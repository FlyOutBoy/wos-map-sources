"""2026-11-11 item stat pass (season 2 data, anti AoE burst): stats -> HP.

Raw-only data fields (not in the editable JSON), so they are staged here:
  A00M (+15 allstats, shared by the 5000-tier items) -> +12;  A00W / A0I5 (+20) -> +16
  new HP abilities (clones of A01Y): HP400 for former +15 items, HP500 for former +20 items
  new ALST14 (clone of A00W) for attack items of the +20 tier; +15 attack items use A00X (+10)
  attack bonuses: Kusanagi A100 40->30, grades A101 60->45, Samehada A137 45->35, Murasame A0I4 80->60,
  Katana A0HU 40->30; Dark Repulser attack speed A165 +50% -> +35%
Item ability lists and tooltips are edited in object-data/items.json (tools: see the session notes).
Ids of the new abilities: object-data/item-stats-2026-11-11-ids.json.

    python tools/stage_item_stats_2026_11_11.py
"""
from pathlib import Path
import json
import re

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import allocate, clone_object, set_field

ROOT = Path(__file__).resolve().parents[1]
IDS_PATH = ROOT / 'object-data/item-stats-2026-11-11-ids.json'

STATS = {'A00M': 12, 'A00W': 16, 'A0I5': 16}
ATK = {'A100': 30, 'A101': 45, 'A137': 35, 'A0HU': 30}
CLONES = {'hp400': ('A01Y', 'Item HP +350 (stat pass)'), 'hp500': ('A01Y', 'Item HP +450 (stat pass)'),
          'alst14': ('A00W', 'Hero ALST + 14 (attack items)'),
          'alst35': ('A00W', 'Hero ALST + 35 (Hogyoku, was A00W+A00M)')}


def configure(documents, ids, strings):
    by_file = {d['source_file']: d for d in documents}

    def index(name):
        return {objects.object_id(o): o for o in by_file[name]['custom_objects']}

    for label, (template, _) in CLONES.items():
        for name in ('war3map.w3a', 'war3mapSkin.w3a'):
            existing = index(name)
            if ids[label] not in existing and template in existing:
                by_file[name]['custom_objects'].append(clone_object(existing[template], ids[label], {}, strings))
    a = index('war3map.w3a')
    skin = index('war3mapSkin.w3a')

    def stat(obj, value):
        for name, pointer in (('Iagi', 1), ('Iint', 2), ('Istr', 3)):
            set_field(obj, name, value, 'int', 1, pointer)

    for rid, value in STATS.items():
        stat(a[rid], value)
    stat(a[ids['alst14']], 14)
    stat(a[ids['alst35']], 35)  # Hogyoku keeps +35
    set_field(a[ids['hp400']], 'Ilif', 350, 'int', 1, 1)  # 400 -> 350: no sudden tank meta
    set_field(a[ids['hp500']], 'Ilif', 450, 'int', 1, 1)  # 500 -> 450
    for rid, value in ATK.items():
        for m in a[rid]['modifications']:
            # flat abilities (same value on every level) change everywhere; A0HU only on its live level 1
            if m['field']['text'] == 'Iatt' and (m.get('level') == 1 or rid != 'A0HU'):
                m['data'] = {'value': value}
    for m in a['A0I4']['modifications']:  # Murasame: level 1 is the live one (80); higher levels unused
        if m['field']['text'] == 'Iatt' and m.get('level') == 1:
            m['data'] = {'value': 60}
    for m in a['A165']['modifications']:
        if m['field']['text'] == 'Isx1':
            m['data'] = {'value': 0.35}
    for label, (_, title) in CLONES.items():
        target = skin.get(ids[label]) or a[ids[label]]
        set_field(target, 'anam', title, 'string', 0, 0)


def stage():
    documents, _ = objects.prepare_documents(ROOT / 'object-data', ROOT / '.object-data-raw')
    used = {objects.object_id(o) for d in documents for group in ('custom_objects', 'original_objects') for o in d[group]}
    for root in ('triggers', 'test_map'):
        for path in (ROOT / root).rglob('*'):
            if path.suffix in ('.j', '.json'):
                text = path.read_text(encoding='utf-8-sig', errors='replace')
                used.update(re.findall(r"'([ABI][A-Z0-9]{3})'", text))
                used.update(re.findall(r'"([ABI][A-Z0-9]{3})"\s*:', text))
    ids = json.loads(IDS_PATH.read_text()) if IDS_PATH.exists() else {}
    for label in CLONES:
        if label not in ids:
            ids[label] = allocate('A', used)
    config = json.loads((ROOT / '.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
    configure(documents, ids, raw.parse_wts(Path(config['mainMap']) / 'war3map.wts'))
    for document in documents:
        raw.encode_object_file(document, document['source_file'])
        raw.dump_json(ROOT / '.object-data-raw' / raw.OUTPUT_NAMES[document['source_file']], document)
    for kind, (editable, metadata) in objects.views_from_raw(documents, ROOT / 'libs/common.j').items():
        raw.dump_json(ROOT / 'object-data' / objects.CATEGORY_FILES[kind], editable)
        raw.dump_json(ROOT / '.object-data-raw/workspace-meta' / objects.CATEGORY_FILES[kind], metadata)
    raw.dump_json(IDS_PATH, ids)
    print(json.dumps(ids))


if __name__ == '__main__':
    stage()
