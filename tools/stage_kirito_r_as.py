"""Kirito R attack-speed buff A0DC (AIs2): Isx1 0.40 -> 2.00 (+200%) via the lossless object workspace API."""
from pathlib import Path

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field

ROOT = Path(__file__).resolve().parents[1]
VALUE = 2.0


def stage():
    documents, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
    doc = next(d for d in documents if d['source_file'] == 'war3map.w3a')
    target = next(o for o in doc['custom_objects'] if objects.object_id(o) == 'A0DC')
    found = [m for m in target['modifications'] if m['field']['text'] == 'Isx1' and m.get('level', 0) == 1]
    if not (found and abs(objects.value_for_user(found[-1]) - VALUE) < 1e-6):
        set_field(target, 'Isx1', VALUE, 'unreal', 1, 0)
    for document in documents:
        raw.encode_object_file(document, document['source_file'])
        raw.dump_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[document['source_file']], document)
    for kind, (editable, metadata) in objects.views_from_raw(documents, ROOT/'libs/common.j').items():
        raw.dump_json(ROOT/'object-data'/objects.CATEGORY_FILES[kind], editable)
        raw.dump_json(ROOT/'.object-data-raw/workspace-meta'/objects.CATEGORY_FILES[kind], metadata)
    print('A0DC Isx1 =', VALUE)


if __name__ == '__main__':
    stage()
