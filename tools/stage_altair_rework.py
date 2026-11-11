"""Altair TEST profile: objects for the 2026-11-10 rework (test_map/heroes/Altair.j).

Only the Altair TEST profile is touched (test_map/profiles/Altair); idempotent.
  * H004 becomes a melee hero (range 125, normal weapon, no projectile).
  * W2 "Fate Barrier" (clone of W, no target) - the second W button shown for 4 sec after W lands.
  * Command-card positions and hotkeys of both forms follow the project standard:
    Q(0,2) W(1,2) E(2,2) R(3,2) T(3,1) F(1,1) G(2,1).
  * SQ cooldown 5 sec; tooltips of W / E / SQ / SW / SE / SR / ST describe the new mechanics.
Run with --dry to print what would change without writing.
"""
from pathlib import Path
import copy
import json
import sys

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import clone_object, set_field

ROOT = Path(__file__).resolve().parents[1]
IDS = ROOT/'object-data/altair-ids.json'
PROFILE = ROOT/'test_map/profiles/Altair'
W2_ID = 'A169'  # AltairW2_ID in Altair.j
W2_ORDER = 'bearform'  # base order id not used by any other Altair button
LEVELS = 5
# slot -> (x, y, hotkey)
SLOTS = {'Q': (0, 2, 'Q'), 'W': (1, 2, 'W'), 'E': (2, 2, 'E'), 'R': (3, 2, 'R'),
         'T': (3, 1, 'T'), 'F': (1, 1, 'F'), 'G': (2, 1, 'G')}
# Learn-menu buttons of the five learnable Holopsicon skills.
RESEARCH = {'Q': (0, 0), 'W': (1, 0), 'E': (2, 0), 'R': (3, 0), 'T': (3, 1)}


def g(value):
    return f'{value:g}'


def tooltip_w(level):
    n = level - 1
    return ('Dashes to the target in a swirl of petals.'
            f'|n|cffffcc00Ally (Third Movement):|r rewrites the plot element into flowers: one free damage block '
            f'(pierced by Lust Sin), clears debuffs and heals {g(1 + 0.25*n)} x Intelligence over {g(3 + n)} sec.'
            f'|n|cffffcc00Enemy (Ninth Movement):|r erases the plot element: clears all buffs, shields included, deals '
            f'{g(2 + 0.4*n)} x Intelligence + {g(50 + 25*n)} magic damage and keeps the enemy Erased for {g(3 + n)} sec '
            '(new buffs and shields are removed every second).'
            '|n|cffffcc00Fate Barrier (W again within 4 sec):|r Altair stands for 1.5 sec under a shield that blocks all '
            f'damage (pierced by Lust Sin); the barrier deals {g(1.5 + 0.3*n)} x Intelligence + {g(75 + 25*n)} magic damage '
            'over that time to enemies within 350 and pushes them to its edge.|nRange: 700.')


def tooltip_w2(level):
    n = level - 1
    return ('Available for 4 sec after Representation Exposition / Fate Restoration lands. Altair stands for 1.5 sec under '
            'a shield that blocks all damage (pierced by Lust Sin). The barrier around her deals '
            f'{g(1.5 + 0.3*n)} x Intelligence + {g(75 + 25*n)} magic damage over that time to enemies within 350 and '
            'pushes them to its edge, where they keep taking damage.')


def tooltip_e(level):
    return ('Strings her PPSH with a sword and releases a spherical aura (radius 650). Every hero inside - allies, enemies '
            'and Altair herself - returns to its origin: the cooldowns of all hero abilities are reduced by 5 sec '
            f'(not this ability). Enemies lose their buffs and take {g(1.5 + 0.4*(level - 1))} x Intelligence magic damage once. '
            'Destroyed decorations inside the aura are restored.')


def tooltip_sq(level):
    return (f'Costs 3 sword stacks. Rushes 700 range in a line with her swords, dealing {g(1 + 0.2*(level - 1))} x Intelligence '
            '+ 1 x Attack damage to all enemies along the way. Hits as an attack (on-hit items).')


def tooltip_sw(level):
    return ('Costs 6 sword stacks. Sends waves of swords forward in a cone (1000 range) - narrow at Altair, wide at the far '
            f'end, covering the whole cone. Every enemy inside takes {g(1.2 + 0.3*(level - 1))} x Intelligence + 0.8 x Attack '
            'damage once. Hits as an attack (on-hit items).')


def tooltip_se(level):
    return ('Costs 2 sword stacks, +2 for each recast while the ring is alive (up to 6). Spins a ring of blades around her '
            f'for 3 sec, dealing {g(0.3 + 0.05*(level - 1))} x Intelligence + 0.15 x Attack damage every 0.25 sec in radius 300. '
            'Recasting restarts the 3 sec timer and adds a stack (up to 6): the ring spins faster and deals +20% damage per stack.')


def tooltip_sr(_level):
    return ('Costs 8 sword stacks. Raises a spinning wheel of blades in front of her for 2 sec. Altair cannot act and is '
            'invulnerable while it stands; enemies in front of her take 0.15 x Intelligence + 0.1 x Attack damage every '
            '0.3 sec. Press S to end it early.')


def tooltip_st(_level):
    return ('Costs 30 sword stacks. Flies into the sky and for 3 sec rains about 30 swords per second onto a large area '
            '(radius 700) under her. Each sword deals 0.5 x Intelligence + 0.3 x Attack damage in radius 160 when it lands. '
            'She is invulnerable during the attack.')


def parts(documents, kind, identity):
    """(document, object) for every file that holds a piece of this object (data file and skin file)."""
    return [(d, o) for d in documents if d['kind'] == kind for group in ('original_objects', 'custom_objects')
            for o in d[group] if objects.object_id(o) == identity]


def skin_part(documents, kind, identity):
    found = [o for d, o in parts(documents, kind, identity) if d['source_file'].startswith('war3mapSkin')]
    if len(found) != 1:
        raise ValueError(f'{kind} {identity}: expected one skin record, found {len(found)}')
    return found[0]


def data_part(documents, kind, identity):
    found = [o for d, o in parts(documents, kind, identity) if not d['source_file'].startswith('war3mapSkin')]
    if len(found) != 1:
        raise ValueError(f'{kind} {identity}: expected one data record, found {len(found)}')
    return found[0]


def drop_fields(obj, fields):
    obj['modifications'] = [m for m in obj['modifications'] if m['field']['text'] not in fields]


def set_tooltips(skin, levels, text):
    for level in range(1, levels + 1):
        set_field(skin, 'aub1', text(level), 'string', level, 0, True)


def stage(dry):
    ids = json.loads(IDS.read_text())
    test, _ = objects.prepare_documents(PROFILE/'object-data', PROFILE/'.object-data-raw')

    # ---- W2: clone both records of W into the same files.
    existing = parts(test, 'abilities', W2_ID)
    if existing and ids.get('W2') != W2_ID:
        raise ValueError(f'{W2_ID} is already used by another object')
    for document in test:
        if document['kind'] == 'abilities':
            document['custom_objects'] = [o for o in document['custom_objects'] if objects.object_id(o) != W2_ID]
    for document, source in parts(test, 'abilities', ids['W']):
        document['custom_objects'].append(clone_object(source, W2_ID, {}, {}))
    w2 = data_part(test, 'abilities', W2_ID)
    w2_skin = skin_part(test, 'abilities', W2_ID)
    drop_fields(w2, {'Ncl2'})  # no target (like E)
    set_field(w2, 'aher', 0, 'int', 0, 0, True)  # not learnable: level follows W in code
    for level in range(1, LEVELS + 1):
        set_field(w2, 'Ncl6', W2_ORDER, 'string', level, 6, True)
        set_field(w2, 'acdn', 1.0, 'unreal', level, 0, True)
        set_field(w2, 'amcs', 0, 'int', level, 0, True)
        set_field(w2, 'aran', 0.0, 'unreal', level, 0, True)
        set_field(w2_skin, 'atp1', f'Fate Barrier (W) [Level {level}]', 'string', level, 0, True)
    set_field(w2_skin, 'anam', 'Altair W2', 'string', 0, 0, True)
    set_tooltips(w2_skin, LEVELS, tooltip_w2)
    ids['W2'] = W2_ID

    # ---- Command-card positions and hotkeys (both forms + W2).
    buttons = {ids[slot]: slot for slot in SLOTS}
    buttons.update({ids['S' + slot]: slot for slot in SLOTS})
    buttons[W2_ID] = 'W'
    for identity, slot in buttons.items():
        skin = skin_part(test, 'abilities', identity)
        x, y, key = SLOTS[slot]
        set_field(skin, 'abpx', x, 'int', 0, 0, True)
        set_field(skin, 'abpy', y, 'int', 0, 0, True)
        set_field(skin, 'ahky', key, 'string', 0, 0, True)
    for slot, (x, y) in RESEARCH.items():
        skin = skin_part(test, 'abilities', ids[slot])
        set_field(skin, 'arpx', x, 'int', 0, 0, True)
        set_field(skin, 'arpy', y, 'int', 0, 0, True)
        set_field(skin, 'arhk', SLOTS[slot][2], 'string', 0, 0, True)

    # ---- Cooldown and tooltips.
    sq = data_part(test, 'abilities', ids['SQ'])
    for level in range(1, LEVELS + 1):
        set_field(sq, 'acdn', 5.0, 'unreal', level, 0, True)
    for slot, levels, text in [('W', LEVELS, tooltip_w), ('E', LEVELS, tooltip_e), ('SQ', LEVELS, tooltip_sq),
                               ('SW', LEVELS, tooltip_sw), ('SE', LEVELS, tooltip_se), ('SR', LEVELS, tooltip_sr),
                               ('ST', 1, tooltip_st)]:
        set_tooltips(skin_part(test, 'abilities', ids[slot]), levels, text)

    # ---- H004: melee.
    hero = data_part(test, 'units', ids['hero'])
    hero_skin = skin_part(test, 'units', ids['hero'])
    drop_fields(hero, {'ua1w', 'ua1z'})  # back to the Hpal base: normal weapon, no projectile speed
    drop_fields(hero_skin, {'ua1m'})  # no projectile art
    set_field(hero, 'ua1r', 125, 'int', leveled=False)
    set_field(hero, 'ua2r', 125, 'int', leveled=False)
    set_field(hero, 'ucs1', 'MetalMediumSlice', 'string', leveled=False)

    if dry:
        for identity in [W2_ID, ids['hero']]:
            for kind in ('abilities', 'units'):
                for _, obj in parts(test, kind, identity):
                    for m in obj['modifications']:
                        print(identity, m['field']['text'], m.get('level', 0), str(objects.value_for_user(m))[:80])
        return

    rawdir = PROFILE/'.object-data-raw'
    for d in test:
        raw.encode_object_file(d, d['source_file'])
        raw.dump_json(rawdir/raw.OUTPUT_NAMES[d['source_file']], d)
    for kind, (editable, metadata) in objects.views_from_raw(test, ROOT/'libs/common.j').items():
        raw.dump_json(PROFILE/'object-data'/objects.CATEGORY_FILES[kind], editable)
        raw.dump_json(rawdir/'workspace-meta'/objects.CATEGORY_FILES[kind], metadata)
    IDS.write_text(json.dumps(ids, indent=2) + '\n')
    print(f'W2: {W2_ID}; positions/hotkeys: {len(buttons)} buttons; hero {ids["hero"]} melee')


if __name__ == '__main__':
    stage('--dry' in sys.argv)
