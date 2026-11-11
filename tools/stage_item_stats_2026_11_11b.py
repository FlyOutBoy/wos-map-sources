"""2026-11-11 (b): damage moved from hero levels into damage items.

Heroes lose 0.4 main stat per level (object-data/units.json). Damage items get +3 stats back:
  A00M (shared +12) -> +15, A00W / A0I5 (+16) -> +19, A170 (attack +14) -> +17
  new ALST13 (attack items that used A00X +10), ALST12 / ALST16 for defensive / support / mobility items,
  which keep +12 / +16 (they switch to the clones in items.json).
Ids: object-data/item-stats-2026-11-11-ids.json (keys alst12, alst16, alst13).

    python tools/stage_item_stats_2026_11_11b.py
"""
from pathlib import Path
import json
import re

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import allocate, clone_object, set_field

ROOT = Path(__file__).resolve().parents[1]
IDS_PATH = ROOT / 'object-data/item-stats-2026-11-11-ids.json'
STATS = {'A00M': 15, 'A00W': 19, 'A0I5': 19, 'A170': 17}
CLONES = {'alst12': ('A00M', 'Hero ALST + 12 (defensive/support items)', 12),
          'alst16': ('A00W', 'Hero ALST + 16 (defensive/support items)', 16),
          'alst13': ('A00W', 'Hero ALST + 13 (attack items)', 13)}


def configure(documents, ids, strings):
    by_file = {d['source_file']: d for d in documents}

    def index(name):
        return {objects.object_id(o): o for o in by_file[name]['custom_objects']}

    for label, (template, _, _) in CLONES.items():
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
    set_field(a['A10C'], 'Istr', 30, 'int', 1, 3)  # Hashirama Cells active: +20 -> +30 Strength
    for label, (_, title, value) in CLONES.items():
        stat(a[ids[label]], value)
        set_field(skin.get(ids[label]) or a[ids[label]], 'anam', title, 'string', 0, 0)


def stage():
    documents, _ = objects.prepare_documents(ROOT / 'object-data', ROOT / '.object-data-raw')
    used = {objects.object_id(o) for d in documents for group in ('custom_objects', 'original_objects') for o in d[group]}
    for root in ('triggers', 'test_map'):
        for path in (ROOT / root).rglob('*'):
            if path.suffix in ('.j', '.json'):
                text = path.read_text(encoding='utf-8-sig', errors='replace')
                used.update(re.findall(r"'([ABI][A-Z0-9]{3})'", text))
                used.update(re.findall(r'"([ABI][A-Z0-9]{3})"\s*:', text))
    ids = json.loads(IDS_PATH.read_text())
    used.update(ids.values())
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
