"""Alter Saber F toggle: ANcl -> Absk (as Kenjaku G), same rawcodes A02C/A115.

Absk is instant and does not interrupt attack/move orders like Channel did.
A02C (Off) gets the grey passive icon, A115 (On) keeps the coloured one. Idempotent.
"""
from pathlib import Path
import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field

ROOT = Path(__file__).resolve().parents[1]
GENERIC = {'alev', 'arac', 'aher', 'anam', 'alsk', 'arlv', 'abpx', 'abpy', 'ahky', 'arhk',
           'aart', 'aret', 'atp1', 'aub1', 'arar', 'arut', 'amcs', 'acdn'}
OFF_ICON = r'ReplaceableTextures\PassiveButtons\PASBTNHero_AlterSaber_F.blp'


def rebase(obj):
    obj['old_id'] = {'text': 'Absk', 'hex': 'Absk'.encode().hex().upper()}
    obj['modifications'] = [m for m in obj['modifications']
                            if m['field']['text'] in GENERIC and m.get('level', 0) <= 1]
    for field, value, kind, pointer in [
        ('abuf', '', 'string', 0), ('acdn', 0.0, 'unreal', 0), ('amcs', 0, 'int', 0),
        ('ahdu', 0.01, 'unreal', 0), ('adur', 0.01, 'unreal', 0),
        ('bsk1', 0.0, 'unreal', 1), ('bsk2', 0.0, 'unreal', 2), ('bsk3', 0.0, 'unreal', 3),
    ]:
        set_field(obj, field, value, kind, 1, pointer)


def apply(documents):
    document = next(d for d in documents if d['source_file'] == 'war3map.w3a')
    by_id = {objects.object_id(o): o for o in document['custom_objects']}
    for rawcode in ('A02C', 'A115'):
        rebase(by_id[rawcode])
    for field in ('aart', 'arar'):
        set_field(by_id['A02C'], field, OFF_ICON, 'string', 0, 0, leveled=False)


def stage():
    documents, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
    apply(documents)
    for d in documents:
        if d['kind'] == 'abilities':
            raw.encode_object_file(d, d['source_file'])
            raw.dump_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[d['source_file']], d)
    editable, metadata = objects.views_from_raw(documents, ROOT/'libs/common.j')['abilities']
    raw.dump_json(ROOT/'object-data/abilities.json', editable)
    raw.dump_json(ROOT/'.object-data-raw/workspace-meta/abilities.json', metadata)
    print('A02C/A115 rebased to Absk; A02C icon -> grey passive')


if __name__ == '__main__':
    stage()
