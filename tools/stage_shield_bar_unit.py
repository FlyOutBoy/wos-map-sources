"""Stage the shield bar dummy unit: clone of h0C9 (Control Dummy: locust, fly, no sight) with the bar model."""
from pathlib import Path
import json
import re

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import allocate, clone_object, set_field

ROOT = Path(__file__).resolve().parents[1]
IDS_PATH = ROOT / 'object-data/shield-bar-ids.json'
MODEL = 'war3mapImported\\wos_shield_bar.mdx'


def configure(documents, ids, strings):
    by_file = {d['source_file']: d for d in documents}
    pair = ('war3map.w3u', 'war3mapSkin.w3u')

    def index(name):
        return {objects.object_id(o): o for o in by_file[name]['custom_objects']}

    for name in pair:
        existing = index(name)
        if ids['unit'] not in existing and 'h0C9' in existing:
            by_file[name]['custom_objects'].append(clone_object(existing['h0C9'], ids['unit'], {}, strings))

    def field(name, value, type='string', skin=False):
        target = index(pair[1 if skin else 0]).get(ids['unit'])
        if target is None and skin:
            target = index(pair[0])[ids['unit']]
        found = [m for m in target['modifications'] if m['field']['text'] == name]
        if found and objects.value_for_user(found[-1]) == value:
            return
        set_field(target, name, value, type, 0, 0)

    field('umdl', MODEL, skin=True)
    field('usca', 2.5, 'unreal', skin=True)
    field('unam', 'Shield Bar Dummy', skin=True)
    field('umvh', 350.0, 'unreal')


def stage():
    documents, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
    used = {objects.object_id(o) for d in documents for group in ('custom_objects', 'original_objects') for o in d[group]}
    for root in ('triggers', 'test_map'):
        for path in (ROOT/root).rglob('*'):
            if path.suffix in ('.j', '.json'):
                text = path.read_text(encoding='utf-8-sig', errors='replace')
                used.update(re.findall(r"'([ABIhHnoue][A-Za-z0-9]{3})'", text))
                used.update(re.findall(r'"([ABIhHnoue][A-Za-z0-9]{3})"\s*:', text))
    ids = json.loads(IDS_PATH.read_text()) if IDS_PATH.exists() else {}
    if 'unit' not in ids:
        ids['unit'] = allocate('h', used)
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
