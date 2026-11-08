"""Stage Erza's distinct T-W order and the reviewed Grail/Frostnova balance."""
from pathlib import Path
import shutil
from datetime import datetime

import war3_object_data as raw
import war3_object_workspace as workspace
from integrate_crocodile_main_objects import set_field

ROOT = Path(__file__).resolve().parents[1]


def apply(documents):
    def field(kind, identity, key, value, typ='string', level=0, pointer=0):
        choices = [obj for doc in documents if doc['kind'] == kind
                   for group in ('original_objects', 'custom_objects')
                   for obj in doc[group] if workspace.object_id(obj) == identity]
        if not choices:
            raise ValueError(f'Missing {kind}/{identity}')
        owners = [obj for obj in choices if any(
            m['field']['text'] == key and m.get('level', 0) == level
            for m in obj['modifications'])]
        # Update every existing copy so base/skin cannot restore a stale value.
        for obj in owners or choices[:1]:
            set_field(obj, key, value, typ, level, pointer)

    field('abilities', 'A03O', 'Ncl6', 'carrionswarm', level=1, pointer=6)
    for aid, speed in (('A09X', .10), ('A0CY', .15)):
        field('abilities', aid, 'Uau1', speed, 'unreal', 1, 1)
    field('units', 'H002', 'umvs', 290, 'int')
    field('buffs', 'B013', 'fube', '+10 HP/sec (heroes only)\n+4 MP/sec\n+10% movement speed\nAura radius: 1200')
    field('buffs', 'B01P', 'fube', '+20 HP/sec (heroes only)\n+6 MP/sec\n+15% movement speed\nAura radius: 1500')
    for doc in documents:
        if doc['kind'] != 'items':
            continue
        for group in ('original_objects', 'custom_objects'):
            for obj in doc[group]:
                identity = workspace.object_id(obj)
                if identity not in ('I021', 'I02B'):
                    continue
                old, new = ('15%', '10%') if identity == 'I021' else ('20%', '15%')
                for mod in obj['modifications']:
                    if mod['field']['text'] in ('ides', 'utub'):
                        value = workspace.value_for_user(mod)
                        set_field(obj, mod['field']['text'], value.replace(old + ' movement speed', new + ' movement speed'))


def main():
    documents, _ = workspace.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
    apply(documents)
    backup = ROOT/'object-data-backups'/('erza-grail-' + datetime.now().strftime('%Y%m%d-%H%M%S-%f'))
    for folder in ('object-data', '.object-data-raw'):
        shutil.copytree(ROOT/folder, backup/folder)
    for doc in documents:
        if doc['kind'] in ('abilities', 'units', 'items', 'buffs'):
            raw.encode_object_file(doc, doc['source_file'])
            raw.dump_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[doc['source_file']], doc)
    for kind, (view, meta) in workspace.views_from_raw(documents, ROOT/'libs/common.j').items():
        if kind in ('abilities', 'units', 'items', 'buffs'):
            raw.dump_json(ROOT/'object-data'/f'{kind}.json', view)
            raw.dump_json(ROOT/'.object-data-raw/workspace-meta'/f'{kind}.json', meta)
    print(f'Erza/Grail/Frostnova staged; backup: {backup}')


if __name__ == '__main__':
    main()
