"""Fill missing hero durations (ahdu) of the service CC abilities.

A missing ahdu on a level falls back to 0 = infinite on heroes:
silence A01V lv10 (5 s, -killme), stun A1OA lv30 (3 s), root APPP lv28.
Hero duration is set equal to the normal duration (adur) of the same level.
"""
from pathlib import Path
import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field

ROOT = Path(__file__).resolve().parents[1]
CC_ABILITIES = ('A01V', 'A1OA', 'A1OT', 'APPP', 'A1QY')


def missing_hero_durations(obj):
    levels = 0
    adur, ahdu = {}, {}
    for m in obj['modifications']:
        field = m['field']['text']
        if field == 'alev':
            levels = m['data']['value']
        elif field == 'adur':
            adur[m.get('level')] = m['data']['value']
        elif field == 'ahdu':
            ahdu[m.get('level')] = m['data']['value']
    return {level: adur[level] for level in range(1, levels + 1) if level in adur and level not in ahdu}


def stage():
    documents, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
    document = next(d for d in documents if d['source_file'] == 'war3map.w3a')
    by_id = {objects.object_id(o): o for o in document['custom_objects']}
    fixed = []
    for ability_id in CC_ABILITIES:
        for level, value in missing_hero_durations(by_id[ability_id]).items():
            set_field(by_id[ability_id], 'ahdu', value, 'unreal', level, 0)
            fixed.append(f'{ability_id} lv{level}={value:g}')
    for d in documents:
        if d['kind'] == 'abilities':
            raw.encode_object_file(d, d['source_file'])
            raw.dump_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[d['source_file']], d)
    editable, metadata = objects.views_from_raw(documents, ROOT/'libs/common.j')['abilities']
    raw.dump_json(ROOT/'object-data/abilities.json', editable)
    raw.dump_json(ROOT/'.object-data-raw/workspace-meta/abilities.json', metadata)
    print('hero durations filled:', ', '.join(fixed) or 'nothing missing')


if __name__ == '__main__':
    stage()
