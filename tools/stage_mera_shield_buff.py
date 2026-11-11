"""Stage the Mera Mera Evolved shield buff: clone of Tekkai buff ability A136 (Ainf, no bonuses) + buff B05A, 5 sec."""
from pathlib import Path
import json
import re

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import allocate, clone_object, set_field

ROOT = Path(__file__).resolve().parents[1]
IDS_PATH = ROOT / 'object-data/mera-mera-evolved-ids.json'
ICON = 'ReplaceableTextures\\CommandButtons\\BTNItem_MeraMeraEvolved.blp'
DURATION = 5.0


def configure(documents, ids, strings):
    by_file = {d['source_file']: d for d in documents}
    pairs = {'abilities': ('war3map.w3a', 'war3mapSkin.w3a'), 'buffs': ('war3map.w3h', 'war3mapSkin.w3h')}

    def index(name):
        return {objects.object_id(o): o for o in by_file[name]['custom_objects']}

    for kind, label, template in (('abilities', 'buffAbi', 'A136'), ('buffs', 'buff', 'B05A')):
        for name in pairs[kind]:
            existing = index(name)
            if ids[label] not in existing and template in existing:
                by_file[name]['custom_objects'].append(clone_object(existing[template], ids[label], {}, strings))

    def field(kind, identity, name, value, type='string', level=0, skin=False):
        target = index(pairs[kind][1 if skin else 0]).get(identity)
        if target is None and skin:
            target = index(pairs[kind][0])[identity]
        found = [m for m in target['modifications'] if m['field']['text'] == name and m.get('level', 0) == level]
        if found and objects.value_for_user(found[-1]) == value:
            return
        set_field(target, name, value, type, level, 0)

    a, b = ids['buffAbi'], ids['buff']
    field('abilities', a, 'adur', DURATION, 'unreal', level=1)
    field('abilities', a, 'ahdu', DURATION, 'unreal', level=1)
    field('abilities', a, 'abuf', b, 'string', level=1)
    field('abilities', a, 'anam', 'Mera Mera Evolved shield (buff)', skin=True)
    field('abilities', a, 'aart', ICON, skin=True)
    field('buffs', b, 'ftip', 'Fire Shield', skin=True)
    field('buffs', b, 'fube', 'Absorbs damage while this buff lasts.', skin=True)
    field('buffs', b, 'ftat', '', skin=True)
    field('buffs', b, 'fart', ICON, skin=True)


def stage():
    documents, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
    used = {objects.object_id(o) for d in documents for group in ('custom_objects', 'original_objects') for o in d[group]}
    for root in ('triggers', 'test_map'):
        for path in (ROOT/root).rglob('*'):
            if path.suffix in ('.j', '.json'):
                text = path.read_text(encoding='utf-8-sig', errors='replace')
                used.update(re.findall(r"'([ABI][A-Z0-9]{3})'", text))
                used.update(re.findall(r'"([ABI][A-Z0-9]{3})"\s*:', text))
    ids = json.loads(IDS_PATH.read_text())
    for label, prefix in (('buffAbi', 'A'), ('buff', 'B')):
        if label not in ids:
            ids[label] = allocate(prefix, used)
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
