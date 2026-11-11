"""2026-11-11: a save rebased the project onto the map and dropped staged raw-only data.

Restores A16A (Mera Mera no Mi Evolved active) level-1 mana cost 0 / cast range 0 (were staged in 0.34i, not in the map)
and re-stages the Inori R Lv. 35 buff objects (A16D/B079, tools/stage_inori_r_dmg_buff.py).

    python tools/restage_after_rebase_2026_11_11.py
"""
from pathlib import Path
import json
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
import war3_object_data as raw  # noqa: E402
import war3_object_workspace as objects  # noqa: E402
from integrate_crocodile_main_objects import set_field  # noqa: E402
import stage_inori_r_dmg_buff as inori  # noqa: E402

ROOT = Path(__file__).resolve().parents[1]


def main():
    documents, _ = objects.prepare_documents(ROOT / 'object-data', ROOT / '.object-data-raw')
    by_file = {d['source_file']: d for d in documents}
    mera = {objects.object_id(o): o for o in by_file['war3map.w3a']['custom_objects']}['A16A']
    for name, value, kind in (('amcs', 0, 'int'), ('aran', 0.0, 'unreal')):
        found = [m for m in mera['modifications'] if m['field']['text'] == name and m.get('level', 0) == 1]
        if not found:
            set_field(mera, name, value, kind, 1, 0)
    ids = json.loads(inori.IDS_PATH.read_text())
    config = json.loads((ROOT / '.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
    inori.configure(documents, ids, raw.parse_wts(Path(config['mainMap']) / 'war3map.wts'))
    for document in documents:
        raw.encode_object_file(document, document['source_file'])
        raw.dump_json(ROOT / '.object-data-raw' / raw.OUTPUT_NAMES[document['source_file']], document)
    for kind, (editable, metadata) in objects.views_from_raw(documents, ROOT / 'libs/common.j').items():
        raw.dump_json(ROOT / 'object-data' / objects.CATEGORY_FILES[kind], editable)
        raw.dump_json(ROOT / '.object-data-raw/workspace-meta' / objects.CATEGORY_FILES[kind], metadata)
    print('restaged', ids)


if __name__ == '__main__':
    main()
