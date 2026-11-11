"""Stage Mahoraga GE2 (copy of E3 'Divine Descent: Follow-up' unlocked by a G hit, 10 sec CD)."""
from pathlib import Path
import json
import re

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import allocate, clone_object, set_field

ROOT = Path(__file__).resolve().parents[1]
IDS_PATH = ROOT / 'object-data/mahoraga-ge2-ids.json'
NAME = 'Divine Descent: Cleave Follow-up'
TIP = ('Mahoraga seizes the target struck by his G (Cursed Cleave), leaps into the air with it and crashes down at the '
       'designated location, damaging nearby enemies. Replaces E for a short time after a G hit.')


def configure(documents, ids, strings):
    by_file = {d['source_file']: d for d in documents}
    pair = ('war3map.w3a', 'war3mapSkin.w3a')

    def index(name):
        return {objects.object_id(o): o for o in by_file[name]['custom_objects']}

    for name in pair:
        existing = index(name)
        if ids['ability'] not in existing and 'A0CJ' in existing:
            by_file[name]['custom_objects'].append(clone_object(existing['A0CJ'], ids['ability'], {}, strings))

    def field(identity, name, value, type='string', level=0, skin=False):
        target = index(pair[1 if skin else 0]).get(identity)
        if target is None and skin:
            target = index(pair[0])[identity]
        found = [m for m in target['modifications'] if m['field']['text'] == name and m.get('level', 0) == level]
        if found and objects.value_for_user(found[-1]) == value:
            return
        set_field(target, name, value, type, level, 0)

    a = ids['ability']
    field(a, 'acdn', 10.0, 'unreal', level=1)
    field(a, 'Ncl6', 'spiritlink', 'string', level=1)  # unique order on Mahoraga (E3 uses cripple)
    for key, value in dict(anam='Another Anime Mahoraga GE2', atp1=NAME, aub1=TIP).items():
        field(a, key, value, level=1 if key in ('atp1', 'aub1') else 0, skin=True)


def stage():
    documents, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
    used = {objects.object_id(o) for d in documents for group in ('custom_objects', 'original_objects') for o in d[group]}
    for root in ('triggers', 'test_map'):
        for path in (ROOT/root).rglob('*'):
            if path.suffix in ('.j', '.json'):
                text = path.read_text(encoding='utf-8-sig', errors='replace')
                used.update(re.findall(r"'([ABI][A-Z0-9]{3})'", text))
                used.update(re.findall(r'"([ABI][A-Z0-9]{3})"\s*:', text))
    ids = json.loads(IDS_PATH.read_text()) if IDS_PATH.exists() else {}
    if 'ability' not in ids:
        ids['ability'] = allocate('A', used)
    config = json.loads((ROOT/'.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
    configure(documents, ids, raw.parse_wts(Path(config['mainMap'])/'war3map.wts'))
    for document in documents:
        raw.encode_object_file(document, document['source_file'])
        raw.dump_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[document['source_file']], document)
    for kind, (editable, metadata) in objects.views_from_raw(documents, ROOT/'libs/common.j').items():
        raw.dump_json(ROOT/'object-data'/objects.CATEGORY_FILES[kind], editable)
        raw.dump_json(ROOT/'.object-data-raw/workspace-meta'/objects.CATEGORY_FILES[kind], metadata)
    raw.dump_json(IDS_PATH, ids)
    print(json.dumps(ids))


if __name__ == '__main__':
    stage()
