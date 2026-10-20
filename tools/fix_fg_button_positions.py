"""Restore F/G command-card positions lost when World Editor re-saved the map.

WE keeps button positions in war3mapSkin.w3a; a base-file abpx was dropped,
so e.g. Rimuru 3G2 (A113) fell to (0,1), the T cell. Every ability that
ShowCD registers in the F/G slots gets abpx (F=1, G=2) and abpy=1 in the
skin object (or the base object when it has no skin entry).
"""
import re
from pathlib import Path
import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field

ROOT = Path(__file__).resolve().parents[1]


def stage():
    documents, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
    by_file = {d['source_file']: d for d in documents}
    base = {objects.object_id(o): o for o in by_file['war3map.w3a']['custom_objects']}
    skin = {objects.object_id(o): o for o in by_file['war3mapSkin.w3a']['custom_objects']}
    ids = {}
    for path in (ROOT/'triggers/Heroes').rglob('*.j'):
        ids.update(re.findall(r"\binteger (\w+)\s*=\s*'(....)'", path.read_text(encoding='utf-8-sig')))
    hud = (ROOT/'triggers/WOS_Start/ShowCD.j').read_text(encoding='utf-8-sig')
    fixed = []
    for slot, name in re.findall(r'AHUI_AddHeroAbility\(whichHero, AHUI_SLOT_([FG]), (\w+)\)', hud):
        aid = ids.get(name)
        if aid not in base:
            continue
        want = {'abpx': 1 if slot == 'F' else 2, 'abpy': 1}
        owner = skin.get(aid) or base[aid]
        for key, value in want.items():
            have = {m['field']['text']: m['data']['value'] for o in (base[aid], skin.get(aid)) if o for m in o['modifications']}
            current = next((m['data']['value'] for m in owner['modifications'] if m['field']['text'] == key), have.get(key))
            if current != value:
                set_field(owner, key, value, 'int', 0)
                fixed.append(f'{aid}.{key}={value}')
    for d in documents:
        if d['kind'] == 'abilities':
            raw.encode_object_file(d, d['source_file'])
            raw.dump_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[d['source_file']], d)
    editable, metadata = objects.views_from_raw(documents, ROOT/'libs/common.j')['abilities']
    raw.dump_json(ROOT/'object-data/abilities.json', editable)
    raw.dump_json(ROOT/'.object-data-raw/workspace-meta/abilities.json', metadata)
    print('F/G positions fixed:', ', '.join(fixed) or 'nothing missing')


if __name__ == '__main__':
    stage()
