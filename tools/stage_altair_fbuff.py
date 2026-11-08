"""Add Altair F (The Vicissitudes of Fortune) buff objects to the TEST profile only.

Altair F applies a real buff: a dummy casts the new ability (clone of MAIN A0FW, Bloodlust base,
no stat changes) on Altair, which puts the new buff on her for AltairF_Duration seconds.
While the buff is on, the next hit of at least AltairF_MinDamage is blocked and reflected
(test_map/heroes/Altair.j, struct AltairF).

Only these two objects are added/replaced. Other profile objects (including the Altair spells
the user edits in World Editor) are preserved. IDs are allocated once and stored in
object-data/altair-ids.json as "F_BuffSpell" and "F_Buff".
Run with --dry to print the template modifications without writing.
"""
from pathlib import Path
import copy
import json
import re
import sys

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import allocate, clone_object, set_field

ROOT = Path(__file__).resolve().parents[1]
IDS = ROOT/'object-data/altair-ids.json'
PROFILE = ROOT/'test_map/profiles/Altair'
ICON = r'ReplaceableTextures\CommandButtons\BTNHero_Altair_F.blp'
DURATION = 6.0  # = AltairF_Duration in Altair.j
TEMPLATE_SPELL = 'A0FW'  # Ainz F buff spell (Bloodlust, attack speed/size changes zeroed)
TEMPLATE_BUFF = 'B02I'


def find(documents, kind, identity):
    found = [o for d in documents if d['kind'] == kind for g in ('original_objects', 'custom_objects')
             for o in d[g] if objects.object_id(o) == identity]
    if not found:
        raise ValueError(f'Missing template {kind} {identity}')
    return found


def stage(dry):
    main, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
    test, _ = objects.prepare_documents(PROFILE/'object-data', PROFILE/'.object-data-raw')
    spell_parts = find(main, 'abilities', TEMPLATE_SPELL)
    buff_parts = find(main, 'buffs', TEMPLATE_BUFF)
    if dry:
        for part in spell_parts + buff_parts:
            for m in part['modifications']:
                print(objects.object_id(part), m['field']['text'], m.get('level', 0), objects.value_for_user(m))
        return
    used = {objects.object_id(o) for d in main for g in ('original_objects', 'custom_objects') for o in d[g]}
    for profile in (ROOT/'test_map/profiles').iterdir():
        if (profile/'object-data').is_dir() and (profile/'.object-data-raw').is_dir():
            docs, _ = objects.prepare_documents(profile/'object-data', profile/'.object-data-raw')
            used |= {objects.object_id(o) for d in docs for g in ('original_objects', 'custom_objects') for o in d[g]}
    for folder in (ROOT/'triggers', ROOT/'test_map/heroes'):
        for path in folder.rglob('*.j'):
            used.update(re.findall(r"'([^'\r\n]{4})'", path.read_text(encoding='utf-8-sig', errors='replace')))
    ids = json.loads(IDS.read_text())
    used |= set(ids.values())
    if 'F_BuffSpell' not in ids:
        ids['F_BuffSpell'] = allocate('A', used)
    if 'F_Buff' not in ids:
        ids['F_Buff'] = allocate('B', used)

    # Ability: one level, the new buff, 6 sec on heroes and units, no art.
    spell = clone_object(spell_parts[0], ids['F_BuffSpell'], {}, {})
    for extra in spell_parts[1:]:
        spell['modifications'] += clone_object(extra, ids['F_BuffSpell'], {}, {})['modifications']
    spell['modifications'] = [m for m in spell['modifications'] if m.get('level', 0) <= 1]
    for field, value, kind, level in [('anam', 'Altair F Buff', 'string', 0), ('alev', 1, 'int', 0),
                                      ('abuf', ids['F_Buff'], 'string', 1), ('adur', DURATION, 'unreal', 1),
                                      ('ahdu', DURATION, 'unreal', 1), ('atp1', 'The Vicissitudes of Fortune', 'string', 1),
                                      ('aub1', 'The next hit of 200+ damage is blocked and returned to the attacker.', 'string', 1),
                                      ('aart', ICON, 'string', 0)]:
        set_field(spell, field, value, kind, level, 0, level > 0)

    # Buff: F icon and tooltip.
    buff = clone_object(buff_parts[0], ids['F_Buff'], {}, {})
    for extra in buff_parts[1:]:
        buff['modifications'] += clone_object(extra, ids['F_Buff'], {}, {})['modifications']
    for field, value in [('fnam', 'Altair F'), ('ftip', 'The Vicissitudes of Fortune'),
                         ('fube', 'The next hit of 200+ damage is blocked and returned to the attacker.'),
                         ('fart', ICON)]:
        set_field(buff, field, value, 'string', leveled=False)

    for kind, new in (('abilities', spell), ('buffs', buff)):
        identity = objects.object_id(new)
        for d in test:
            if d['kind'] == kind:
                d['custom_objects'] = [o for o in d['custom_objects'] if objects.object_id(o) != identity]
        dest = next(d for d in test if d['kind'] == kind and not d['source_file'].startswith('war3mapSkin'))
        dest['custom_objects'].append(copy.deepcopy(new))
    rawdir = PROFILE/'.object-data-raw'
    for d in test:
        raw.encode_object_file(d, d['source_file'])
        raw.dump_json(rawdir/raw.OUTPUT_NAMES[d['source_file']], d)
    for kind, (editable, metadata) in objects.views_from_raw(test, ROOT/'libs/common.j').items():
        raw.dump_json(PROFILE/'object-data'/objects.CATEGORY_FILES[kind], editable)
        raw.dump_json(rawdir/'workspace-meta'/objects.CATEGORY_FILES[kind], metadata)
    IDS.write_text(json.dumps(ids, indent=2) + '\n')
    print('F buff spell:', ids['F_BuffSpell'], 'F buff:', ids['F_Buff'])


if __name__ == '__main__':
    stage('--dry' in sys.argv)
