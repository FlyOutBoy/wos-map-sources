"""Stage Crocodile's five-second trail mark without changing map cooldowns."""
from pathlib import Path
import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field

ROOT = Path(__file__).resolve().parents[1]


def stage():
    documents, _ = objects.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
    document = next(d for d in documents if d['source_file']=='war3map.w3a')
    by_id = {objects.object_id(o):o for o in document['custom_objects']}
    mark = by_id['A108']
    # Mark ranks previously encoded the ground slow by mistake. The trail
    # debuff has one rank; SlowUnit handles all ground sand separately.
    mark['modifications'] = [m for m in mark['modifications'] if m.get('level',0) <= 1]
    for field,value,kind in [('alev',1,'int'),('areq','','string'),('arqa','','string'),('achd',0,'int')]:
        set_field(mark,field,value,kind,0,0)
    for level,slow in enumerate((0.0,),1):
        for field,value,kind,pointer in [
            ('Slo1',slow,'unreal',1),('Slo2',0.0,'unreal',2),
            ('adur',5.0,'unreal',0),('ahdu',5.0,'unreal',0),
            ('amcs',0,'int',0),('acdn',0.0,'unreal',0),
            ('aran',99999.0,'unreal',0),('abuf','B03D','string',0),
            ('atar','air,ground,enemy,organic,vulnerable,invulnerable','string',0),
        ]:
            set_field(mark,field,value,kind,level,pointer)
    for d in documents:
        if d['kind']=='abilities':
            raw.encode_object_file(d,d['source_file'])
            raw.dump_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[d['source_file']],d)
    editable,metadata = objects.views_from_raw(documents,ROOT/'libs/common.j')['abilities']
    raw.dump_json(ROOT/'object-data/abilities.json',editable)
    raw.dump_json(ROOT/'.object-data-raw/workspace-meta/abilities.json',metadata)
    print('MAIN cooldowns preserved; trail mark: five seconds, one native level, no native slow')


if __name__=='__main__':
    stage()
