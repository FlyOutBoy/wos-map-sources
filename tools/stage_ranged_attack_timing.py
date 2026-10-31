"""Stage the reviewed +0.3-second base interval of ranged hero attacks (idempotent)."""
from pathlib import Path
import war3_object_workspace as objects
import war3_object_data as raw
from integrate_crocodile_main_objects import set_field
ROOT=Path(__file__).resolve().parents[1]
INTERVALS={'H002':1.8,'H017':2.0,'H018':1.8,'H01Z':1.8,'H020':1.8,'H02E':1.8,'H02H':1.8,'H01X':1.8,'H01Y':2.3}
BASE_DAMAGE={'H002':10,'H017':10,'H018':10,'H02E':10,'H02H':10}

def configure(documents):
    for d in documents:
        if d['source_file']=='war3map.w3u':
            for o in d['custom_objects']:
                oid=objects.object_id(o)
                if oid in INTERVALS:
                    set_field(o,'ua1c',INTERVALS[oid],'unreal',leveled=False)
                if oid in BASE_DAMAGE:
                    set_field(o,'ua1b',BASE_DAMAGE[oid],'int',leveled=False)
def stage():
    docs,_=objects.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
    configure(docs)
    for d in docs:
        if d['kind']=='units':
            raw.encode_object_file(d,d['source_file']);raw.dump_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[d['source_file']],d)
    view,meta=objects.views_from_raw(docs,ROOT/'libs/common.j')['units']
    raw.dump_json(ROOT/'object-data/units.json',view)
    raw.dump_json(ROOT/'.object-data-raw/workspace-meta/units.json',meta)
if __name__=='__main__':stage()
