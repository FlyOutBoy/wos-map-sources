"""Pin MAIN's dummy Bloodlust to a research-free, single-level sand buff."""
from pathlib import Path
import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field

ROOT = Path(__file__).resolve().parents[1]


def stage():
    documents, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
    document = next(d for d in documents if d['source_file'] == 'war3map.w3a')
    ability = next(o for o in document['custom_objects'] if objects.object_id(o) == 'A109')
    # Bloodlust is an ordinary Orc spell. Dummy casts must not inherit its
    # training requirements or depend on a player's research state.
    for field, value, kind, level, pointer in [
        ('areq', '', 'string', 0, 0), ('arqa', '', 'string', 0, 0),
        ('achd', 0, 'int', 0, 0), ('alev', 1, 'int', 0, 0),
        ('aher', 0, 'int', 0, 0), ('aite', 0, 'int', 0, 0),
        ('amcs', 0, 'int', 1, 0), ('acdn', 0.0, 'unreal', 1, 0),
        ('acas', 0.0, 'unreal', 1, 0), ('aran', 99999.0, 'unreal', 1, 0),
        ('adur', .35, 'unreal', 1, 0), ('ahdu', .35, 'unreal', 1, 0),
        ('Blo1', 0.0, 'unreal', 1, 1), ('Blo2', 80.0/310.0, 'unreal', 1, 2),
        ('Blo3', 0.0, 'unreal', 1, 3), ('abuf', 'B03E', 'string', 1, 0),
    ]:
        set_field(ability, field, value, kind, level, pointer)
    for d in documents:
        raw.encode_object_file(d, d['source_file'])
        raw.dump_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[d['source_file']], d)
    for kind, (editable, metadata) in objects.views_from_raw(documents, ROOT/'libs/common.j').items():
        raw.dump_json(ROOT/'object-data'/objects.CATEGORY_FILES[kind], editable)
        raw.dump_json(ROOT/'.object-data-raw/workspace-meta'/objects.CATEGORY_FILES[kind], metadata)
    print('MAIN A109: no research/dependencies/cast delay; B03E, +80 sand MS, 0.35 sec')


if __name__ == '__main__':
    stage()
