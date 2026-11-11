"""Add Altair W (Ninth Movement) buff/debuff objects to the TEST profile only.

When W reaches an enemy (test_map/heroes/Altair.j, struct AltairWAura):
  * Altair gets a real buff  (clone of MAIN A0FW: Bloodlust base, bonuses zeroed) for AltairW_AuraTime (1.5 sec):
    she is paused under a shield while the moon aura deals all its damage and pushes enemies away;
  * the enemy gets a real debuff (clone of MAIN A108: Slow base, slow factors zeroed) for the same time;
    while it is on, new buffs and shields on the enemy are erased again.
Duration per level 3/4/5/6/7 sec = AltairW_Duration + AltairW_DurationStep*(lvl - 1) in Altair.j.

Only these four objects are added/replaced and the W (A11F) tooltip gets the moon aura line;
other profile objects are preserved.
IDs are allocated once and stored in object-data/altair-ids.json
("W_BuffSpell", "W_Buff", "W_DebuffSpell", "W_Debuff").
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
ICON = r'ReplaceableTextures\CommandButtons\BTNHero_Altair_W.blp'
LEVELS = 5
DURATIONS = [3.0, 4.0, 5.0, 6.0, 7.0]  # debuff = AltairW_Duration + AltairW_DurationStep*(lvl - 1)
AURA_TIME = 1.5  # buff = AltairW_AuraTime (paused + shielded moon aura phase)
# (ids key spell, ids key buff, template spell, template buff, name, tooltip, description, durations per level)
OBJECTS = [
    ('W_BuffSpell', 'W_Buff', 'A0FW', 'B02I', 'Altair W Buff', 'Ninth Movement: Fate Restoration',
     'Altair stands shielded from all damage while the moon aura around her deals magic damage and pushes enemies away.',
     [AURA_TIME]*LEVELS),
    ('W_DebuffSpell', 'W_Debuff', 'A108', 'B03D', 'Altair W Debuff', 'Ninth Movement: Erased',
     'The plot element is erased: new buffs and shields are removed again every second.',
     DURATIONS),
]


def find(documents, kind, identity):
    found = [o for d in documents if d['kind'] == kind for g in ('original_objects', 'custom_objects')
             for o in d[g] if objects.object_id(o) == identity]
    if not found:
        raise ValueError(f'Missing template {kind} {identity}')
    return found


def merged_clone(parts, new_id):
    obj = clone_object(parts[0], new_id, {}, {})
    for extra in parts[1:]:
        obj['modifications'] += clone_object(extra, new_id, {}, {})['modifications']
    return obj


def stage(dry):
    main, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
    test, _ = objects.prepare_documents(PROFILE/'object-data', PROFILE/'.object-data-raw')
    if dry:
        for _, _, spell, buff, *_ in OBJECTS:
            for part in find(main, 'abilities', spell) + find(main, 'buffs', buff):
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

    staged = []
    for spell_key, buff_key, spell_template, buff_template, name, tip, text, durations in OBJECTS:
        if spell_key not in ids:
            ids[spell_key] = allocate('A', used)
        if buff_key not in ids:
            ids[buff_key] = allocate('B', used)

        # Ability: 5 levels, every level = copy of the zeroed template level 1, W duration, the new buff.
        spell = merged_clone(find(main, 'abilities', spell_template), ids[spell_key])
        base = [m for m in spell['modifications'] if m.get('level', 0) == 1]
        spell['modifications'] = [m for m in spell['modifications'] if m.get('level', 0) == 0]
        for level in range(1, LEVELS + 1):
            for m in base:
                copy_mod = copy.deepcopy(m)
                copy_mod['level'] = level
                spell['modifications'].append(copy_mod)
        set_field(spell, 'anam', name, 'string', 0, 0, True)  # .w3a: level/data_pointer always present
        set_field(spell, 'alev', LEVELS, 'int', 0, 0, True)  # .w3a: level/data_pointer always present
        set_field(spell, 'aart', ICON, 'string', 0, 0, True)  # .w3a: level/data_pointer always present
        set_field(spell, 'auar', ICON, 'string', 0, 0, True)  # .w3a: level/data_pointer always present
        for level, duration in enumerate(durations, start=1):
            set_field(spell, 'abuf', ids[buff_key], 'string', level, 0, True)
            set_field(spell, 'adur', duration, 'unreal', level, 0, True)
            set_field(spell, 'ahdu', duration, 'unreal', level, 0, True)
            set_field(spell, 'atp1', tip, 'string', level, 0, True)
            set_field(spell, 'aub1', f'{text} Duration: {duration:g} sec.', 'string', level, 0, True)

        # Buff: W icon and tooltip, no target art.
        buff = merged_clone(find(main, 'buffs', buff_template), ids[buff_key])
        for field, value in [('fnam', name), ('ftip', tip), ('fube', text), ('fart', ICON), ('ftat', '')]:
            set_field(buff, field, value, 'string', leveled=False)
        staged += [('abilities', spell), ('buffs', buff)]

    # W tooltip (A11F): add/refresh the moon aura line before "|nRange:" (idempotent, other text kept).
    marker = '|n|cffffcc00Moon aura:|r'
    w_id = ids['W']
    for d in test:
        if d['kind'] != 'abilities':
            continue
        for o in d['custom_objects']:
            if objects.object_id(o) != w_id:
                continue
            for m in o['modifications']:
                level = m.get('level', 0)
                if m['field']['text'] != 'aub1' or not 1 <= level <= LEVELS:
                    continue
                text = re.sub(re.escape(marker) + r'.*?(?=\|nRange:|$)', '', objects.value_for_user(m), flags=re.S)
                total_int = 1.5 + 0.3*(level - 1)
                total_static = 75 + 25*(level - 1)
                line = (f'{marker} after the enemy hit Altair stands for {AURA_TIME:g} sec under a shield that blocks all damage '
                        f'(pierced by Lust Sin) and deals {total_int:g} x Intelligence + {total_static:g} magic damage over that time '
                        f'to enemies within 350, pushing them away. The enemy is Erased for {DURATIONS[level - 1]:g} sec: '
                        'new buffs and shields are removed every second.')
                pos = text.find('|nRange:')
                m['data'] = {'value': text[:pos] + line + text[pos:] if pos >= 0 else text + line}

    for kind, new in staged:
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
    print(' '.join(f'{k}: {ids[k]}' for k in ('W_BuffSpell', 'W_Buff', 'W_DebuffSpell', 'W_Debuff')))


if __name__ == '__main__':
    stage('--dry' in sys.argv)
