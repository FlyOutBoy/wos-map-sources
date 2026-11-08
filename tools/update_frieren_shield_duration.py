"""Frieren G shield (A0GJ): -0.5 sec on every level (2.5/4.0 -> 2.0/3.5)."""
from pathlib import Path
import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field

ROOT = Path(__file__).resolve().parents[1]
DURATIONS = {1: 2.0, 2: 2.0, 3: 2.0, 4: 3.5, 5: 3.5, 6: 3.5}


def stage():
    documents, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
    document = next(d for d in documents if d['source_file'] == 'war3map.w3a')
    by_id = {objects.object_id(o): o for o in document['custom_objects']}
    shield = by_id['A0GJ']
    for level, value in DURATIONS.items():
        for field in ('adur', 'ahdu'):
            set_field(shield, field, value, 'unreal', level, 0)
    for d in documents:
        if d['kind'] == 'abilities':
            raw.encode_object_file(d, d['source_file'])
            raw.dump_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[d['source_file']], d)
    editable, metadata = objects.views_from_raw(documents, ROOT/'libs/common.j')['abilities']
    raw.dump_json(ROOT/'object-data/abilities.json', editable)
    raw.dump_json(ROOT/'.object-data-raw/workspace-meta/abilities.json', metadata)
    print('Frieren shield A0GJ: 2.0/2.0/2.0/3.5/3.5/3.5 sec')


if __name__ == '__main__':
    stage()
