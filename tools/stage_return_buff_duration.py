"""Stage Return by Death's native buff lifetime beyond its five-second return deadline."""
from pathlib import Path
import war3_object_workspace as objects
import war3_object_data as raw
from integrate_crocodile_main_objects import set_field
ROOT=Path(__file__).resolve().parents[1]
def configure(documents):
    for document in documents:
        if document['source_file']=='war3map.w3a':
            for obj in document['custom_objects']:
                if objects.object_id(obj)=='A155':
                    for field in ('adur','ahdu'):
                        set_field(obj,field,5.25,'unreal',1)
def stage():
    documents,_=objects.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
    configure(documents)
    for document in documents:
        if document['kind']=='abilities':
            raw.encode_object_file(document,document['source_file'])
            raw.dump_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[document['source_file']],document)
    editable,meta=objects.views_from_raw(documents,ROOT/'libs/common.j')['abilities']
    raw.dump_json(ROOT/'object-data/abilities.json',editable)
    raw.dump_json(ROOT/'.object-data-raw/workspace-meta/abilities.json',meta)
if __name__=='__main__':stage()
