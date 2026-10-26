"""Stage Altair (Re:Creators) objects in the independent TEST profile only.

MAIN object data is read (decor/train templates, used rawcodes) but never written.
Uses the lossless object API; normal TEST check/save owns map writes. Existing
objects outside this hero are preserved. IDs are allocated once against MAIN,
every TEST profile and literal rawcodes in code, then kept in altair-ids.json.
The numbers below mirror the tuning globals in test_map/heroes/Altair.j.
"""
from pathlib import Path
import copy
import json
import re

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import allocate, clone_object, set_field, code

ROOT = Path(__file__).resolve().parents[1]
IDS = ROOT/'object-data/altair-ids.json'
PROFILE = ROOT/'test_map/profiles/Altair'
ICON = r'ReplaceableTextures\CommandButtons\BTNHero_Altair_{}.blp'
HOLO = 'Q W E R T F G'.split()
SWORD = 'SQ SW SE SR ST SF SG'.split()
SLOTS = HOLO+SWORD
# Decor and the round-end train are copied from MAIN so TEST can exercise R.
DECOR_UNITS = ['h00G', 'h02N']


def lv(base, step, level):
    return base+step*(level-1)


def num(value):
    return f'{value:g}'


TITLES = {
    'Q': 'PPSH Spray', 'W': 'Representation Exposition / Fate Restoration', 'E': 'Outline Origin',
    'R': 'Factor Mimic', 'T': 'Fate Reconstruction', 'F': 'The Vicissitudes of Fortune', 'G': 'Meta Change',
    'SQ': 'Sword Rush', 'SW': 'Sword Storm', 'SE': 'Spinning Swords', 'SR': 'Shield of Swords',
    'ST': 'Rain of Swords', 'SF': 'Endless Swords', 'SG': 'Meta Change',
}
HOTKEYS = {'Q':'Q','W':'W','E':'E','R':'R','T':'T','F':'F','G':'G',
           'SQ':'Q','SW':'W','SE':'E','SR':'R','ST':'T','SF':'F','SG':'G'}
LEVELS = {'Q':5,'W':5,'E':5,'R':5,'T':1,'F':1,'G':1,'SQ':5,'SW':5,'SE':5,'SR':5,'ST':1,'SF':1,'SG':1}
# Every Channel on one unit needs its own base order.
ORDERS = {'Q':'rainoffire','W':'holybolt','E':'thunderclap','R':'blizzard','T':'earthquake',
          'F':'divineshield','G':'metamorphosis','SQ':'shockwave','SW':'impale','SE':'whirlwind',
          'SR':'stomp','ST':'starfall','SF':'roar','SG':'avatar'}
# Channel target type: 0 none, 1 unit, 2 point. Options: 1 visible, 2 area image.
TARGET = {'Q':(2,3),'W':(1,1),'E':(0,1),'R':(2,3),'T':(2,3),'F':(0,1),'G':(0,1),
          'SQ':(2,1),'SW':(2,1),'SE':(0,1),'SR':(2,1),'ST':(0,1),'SF':(0,1),'SG':(0,1)}
BUTTONS = {'Q':(0,2),'W':(1,2),'E':(2,2),'R':(3,2),'T':(0,1),'F':(1,1),'G':(2,1)}
RESEARCH = {'Q':(0,0),'W':(1,0),'E':(2,0),'R':(3,0),'T':(0,1)}
REQUIRED = {'Q':(1,4),'W':(1,4),'E':(1,4),'R':(10,4),'T':(25,0)}
COOLDOWN = {'Q':lambda l:9., 'W':lambda l:lv(16,-1,l), 'E':lambda l:22., 'R':lambda l:1., 'T':lambda l:60.,
            'F':lambda l:18., 'G':lambda l:10., 'SQ':lambda l:4., 'SW':lambda l:10., 'SE':lambda l:2.,
            'SR':lambda l:20., 'ST':lambda l:50., 'SF':lambda l:1., 'SG':lambda l:10.}
MANA = {'Q':lambda l:lv(100,25,l), 'W':lambda l:lv(90,15,l), 'E':lambda l:125, 'R':lambda l:50,
        'T':lambda l:200, 'F':lambda l:75}
RANGE = {'Q':900.,'W':700.,'R':1800.,'T':800.,'SQ':700.,'SW':1100.,'SR':600.}
AREA = {'Q':300.,'E':650.,'R':600.,'T':300.}

DESCRIPTIONS = {
    'Q': lambda l: (f'Sprays the target area with her PPSH, dealing {num(lv(3,1,l))} x Intelligence + {num(lv(75,25,l))} '
                    f'physical damage to every enemy inside and stunning them for 0.5 sec.|n'
                    f'Radius: 300. Range: 900. Mana: {lv(100,25,l)}.'),
    'W': lambda l: (f'Dashes to the target.|n|cffffcc00Ally (Third Movement):|r rewrites the plot element into flowers: one free '
                    f'damage block (pierced by Lust Sin), clears debuffs and heals {num(lv(1.0,0.25,l))} x Intelligence over '
                    f'{num(lv(3,1,l))} sec.|n|cffffcc00Enemy (Ninth Movement):|r erases the plot element: clears all buffs, '
                    f'shields included, and deals {num(lv(2.0,0.4,l))} x Intelligence + {num(lv(50,25,l))} magic damage.|nRange: 700.'),
    'E': lambda l: (f'Strings her PPSH with a sword and releases a spherical aura (radius 650): every ally and enemy inside '
                    f'returns to its origin, all their cooldowns are reduced by 5 sec. Enemies take {num(lv(1.5,0.4,l))} x '
                    f'Intelligence magic damage. Destroyed decorations inside the aura are restored.'),
    'R': lambda l: (f'Places a marker over the target area (radius 600): every decoration inside it is destroyed and '
                    f'perfectly copied. Recast within 30 sec: a blue portal opens behind Altair and the copies stream out of '
                    f'it one after another (every 0.06 sec) to the target point, smashing decorations and enemies on their way '
                    f'(35% damage). Each impact deals {num(lv(2.5,0.5,l))} x Intelligence + {num(lv(100,50,l))} physical '
                    f'damage and stuns; heavy objects hit harder and wider, explosive barrels explode, hydrants burst. Every extra '
                    f'copy landing on the same enemy overloads it: +0.5 sec stun. Heavy objects glide level, light ones tumble. '
                    f'At hero level 35 she can store the round-end train. Range: 1800.'),
    'T': lambda l: ('Summons a giant portal at the target point that drags up to 4 allies or enemies (Altair cannot enter) '
                    'into an alternate realm for 20 sec (25 sec at hero level 35). Others may walk into the portal while it '
                    'has room. Recast once to relocate the portal. When the realm ends - by time, Meta Change (G) or Altair\'s '
                    'death - everyone reappears at the portal. Forms cannot switch while the realm is active. During an active '
                    'Prison Realm (Kenjaku) the victims join the fight: the realm opens inside the prison.'),
    'F': lambda l: ('Flips cause and effect for 6 sec: a shield blocks the next hit from an enemy (pierced by Lust Sin) and '
                    'reflects its damage back to the attacker as magic damage.'),
    'G': lambda l: ('Switches to the Sword Princess form. The form cannot be changed again for 10 sec. '
                    'Pressing it while Fate Reconstruction is active ends the realm early.'),
    'SQ': lambda l: (f'Costs 3 sword stacks. Rushes 700 range in a line with her swords, dealing {num(lv(1.0,0.2,l))} x '
                     f'Intelligence + 1 x Attack damage to all enemies along the way. Hits as an attack (on-hit items).'),
    'SW': lambda l: (f'Costs 6 sword stacks. Sends 9 swords forward in a cone (1000 range), dealing {num(lv(1.2,0.3,l))} x '
                     f'Intelligence + 0.8 x Attack damage to every enemy hit. Hits as an attack (on-hit items).'),
    'SE': lambda l: (f'Costs 2 sword stacks, +2 for each recast within 4 sec (up to 6). Spins blades at high velocity around '
                     f'her for 1.5 sec, dealing {num(lv(0.3,0.05,l))} x Intelligence + 0.15 x Attack damage every 0.25 sec in '
                     f'radius 300. Each recast adds blades and +50% damage.'),
    'SR': lambda l: (f'Costs 8 sword stacks. Forms a circular shield of spinning blades for {num(lv(3,0.5,l))} sec that blocks '
                     f'all damage coming from the chosen direction (120 degree arc; Lust Sin pierces it). The blades deal '
                     f'0.15 x Intelligence + 0.1 x Attack damage to touching enemies every 0.3 sec.'),
    'ST': lambda l: ('Costs 30 sword stacks. Flies into the sky and rains an endless amount of swords in a large area '
                     '(radius 700) under her for 3 sec. Each sword deals 0.5 x Intelligence + 0.3 x Attack damage in '
                     'radius 160. She is invulnerable during the attack.'),
    'SF': lambda l: ('Passive: gains one sword stack every 4 sec and 8 stacks whenever an allied or enemy hero dies. '
                     'Maximum stacks: hero level + 15. Sword Princess spells hit as attacks and trigger on-hit items.|n'
                     'Toggle: attacks against Altair deal 10% less damage; every received attack consumes 2 stacks '
                     '(turns off without stacks).'),
    'SG': lambda l: 'Switches back to the Holopsicon form. The form cannot be changed again for 10 sec.',
}


def stage():
    main, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
    test, _ = objects.prepare_documents(PROFILE/'object-data', PROFILE/'.object-data-raw')
    used = {objects.object_id(o) for d in main for g in ('original_objects', 'custom_objects') for o in d[g]}
    for profile in (ROOT/'test_map/profiles').iterdir():
        if (profile/'object-data').is_dir() and (profile/'.object-data-raw').is_dir():
            docs, _ = objects.prepare_documents(profile/'object-data', profile/'.object-data-raw')
            used |= {objects.object_id(o) for d in docs for g in ('original_objects', 'custom_objects') for o in d[g]}
    for folder in (ROOT/'triggers', ROOT/'test_map/heroes'):
        for path in folder.rglob('*.j'):
            used.update(re.findall(r"'([^'\r\n]{4})'", path.read_text(encoding='utf-8-sig', errors='replace')))
    ids = json.loads(IDS.read_text()) if IDS.exists() else {}
    for name, prefix in [('hero', 'H'), *[(s, 'A') for s in SLOTS]]:
        if name not in ids:
            ids[name] = allocate(prefix, used)
    config = json.loads((ROOT/'.vscode/wos-build.json').read_text('utf-8-sig'))
    main_strings = raw.parse_wts(Path(config['mainMap'])/'war3map.wts')
    test_strings = raw.parse_wts(PROFILE/'unpacked/war3map.wts')

    def combined(documents, strings, kind, identity):
        found = [o for d in documents if d['kind'] == kind for g in ('original_objects', 'custom_objects')
                 for o in d[g] if objects.object_id(o) == identity]
        if not found:
            raise ValueError(f'Missing template {kind} {identity}')
        result = clone_object(found[0], identity, {}, strings)
        for obj in found[1:]:
            for m in clone_object(obj, identity, {}, strings)['modifications']:
                set_field(result, m['field']['text'], objects.value_for_user(m), m['type'],
                          m.get('level', 0), m.get('data_pointer', 0), kind == 'abilities')
        return result

    additions = {kind: [] for kind in ('units', 'abilities', 'destructables')}
    hero = clone_object(combined(test, test_strings, 'units', 'H002'), ids['hero'], {}, test_strings)
    for field, value in {'unam':'Altair', 'upro':'Military Uniform Princess', 'utip':'Altair',
                         'utub':'Re:Creators | Intelligence. Switches between the Holopsicon (battlefield control) '
                                'and Sword Princess (sword stacks) forms. Placeholder model.',
                         'ufil':r'units\human\Jaina\Jaina.mdl', 'umdl':r'units\human\Jaina\Jaina.mdl',
                         'uico':ICON.format('Icon'), 'ussi':ICON.format('Icon'),
                         'uhab':','.join(ids[s] for s in 'QWERT'), 'uabi':''}.items():
        set_field(hero, field, value, leveled=False)
    additions['units'].append(hero)
    template = combined(test, test_strings, 'abilities', 'A116')
    for slot in SLOTS:
        obj = clone_object(template, ids[slot], {}, test_strings)
        obj['modifications'] = []
        levels = LEVELS[slot]
        holo = slot in RESEARCH
        x, y = BUTTONS[slot.removeprefix('S')] if slot.startswith('S') else BUTTONS[slot]
        form = 'Sword Princess' if slot.startswith('S') else 'Holopsicon'
        for f, v, k in [('anam', 'Altair '+slot, 'string'), ('alev', levels, 'int'), ('aher', 1 if holo else 0, 'int'),
                        ('ahky', HOTKEYS[slot], 'string'), ('abpx', x, 'int'), ('abpy', y, 'int'),
                        ('aart', ICON.format(slot), 'string'), ('arar', ICON.format(slot), 'string'),
                        ('aret', f'{TITLES[slot]} ({HOTKEYS[slot]}) [{form}]', 'string'),
                        ('arut', DESCRIPTIONS[slot](1), 'string')]:
            set_field(obj, f, v, k)
        if holo:
            required, skip = REQUIRED[slot]
            for f, v, k in [('arhk', HOTKEYS[slot], 'string'), ('arlv', required, 'int'), ('alsk', skip, 'int'),
                            ('arpx', RESEARCH[slot][0], 'int'), ('arpy', RESEARCH[slot][1], 'int')]:
                set_field(obj, f, v, k)
        target, options = TARGET[slot]
        for level in range(1, levels+1):
            set_field(obj, 'atp1', f'{TITLES[slot]} ({HOTKEYS[slot]}) [Level {level}]' if levels > 1
                      else f'{TITLES[slot]} ({HOTKEYS[slot]})', level=level)
            set_field(obj, 'aub1', DESCRIPTIONS[slot](level), level=level)
            for f, v, k, p in [('acdn', COOLDOWN[slot](level), 'unreal', 0),
                               ('amcs', MANA[slot](level) if slot in MANA else 0, 'int', 0),
                               ('aran', RANGE.get(slot, 0.), 'unreal', 0), ('aare', AREA.get(slot, 0.), 'unreal', 0),
                               ('acas', 0., 'unreal', 0), ('adur', 0., 'unreal', 0), ('ahdu', 0., 'unreal', 0),
                               ('Ncl1', 0., 'unreal', 1), ('Ncl2', target, 'int', 2), ('Ncl3', options, 'int', 3),
                               ('Ncl4', 0., 'unreal', 4), ('Ncl5', 0, 'int', 5), ('Ncl6', ORDERS[slot], 'string', 6),
                               ('atar', 'air,ground,friend,enemy,neutral,vulnerable,invulnerable' if slot == 'W'
                                else 'air,ground,enemy,neutral,vulnerable', 'string', 0),
                               ('aeat', '', 'string', 0), ('acat', '', 'string', 0), ('atat', '', 'string', 0)]:
                set_field(obj, f, v, k, level, p)
        additions['abilities'].append(obj)
    # Skin-only leftovers in the TEST template do not define an object; MAIN is authoritative.
    present = {objects.object_id(o) for d in test if d['kind'] == 'destructables'
               and not d['source_file'].startswith('war3mapSkin')
               for g in ('original_objects', 'custom_objects') for o in d[g]}
    decor = sorted({objects.object_id(o) for d in main if d['kind'] == 'destructables' for o in d['custom_objects']})
    # The TEST template's own B000-B00Q were stale DTrf placeholders (rendered as raised stone floor):
    # every MAIN decor definition replaces the TEST one.
    for identity in decor:
        additions['destructables'].append(combined(main, main_strings, 'destructables', identity))
    # The TEST template had an unrelated stale h00G; the train dummies always follow MAIN.
    for identity in DECOR_UNITS:
        additions['units'].append(combined(main, main_strings, 'units', identity))
    for kind, new in additions.items():
        targets = {objects.object_id(o) for o in new}
        for d in test:
            if d['kind'] == kind:
                d['custom_objects'] = [o for o in d['custom_objects'] if objects.object_id(o) not in targets]
        dest = next(d for d in test if d['kind'] == kind and not d['source_file'].startswith('war3mapSkin'))
        dest['custom_objects'].extend(copy.deepcopy(new))
    rawdir = PROFILE/'.object-data-raw'
    for d in test:
        raw.encode_object_file(d, d['source_file'])
        raw.dump_json(rawdir/raw.OUTPUT_NAMES[d['source_file']], d)
    for kind, (editable, metadata) in objects.views_from_raw(test, ROOT/'libs/common.j').items():
        raw.dump_json(PROFILE/'object-data'/objects.CATEGORY_FILES[kind], editable)
        raw.dump_json(rawdir/'workspace-meta'/objects.CATEGORY_FILES[kind], metadata)
    raw.dump_json(IDS, ids)
    print(json.dumps(ids, indent=2))
    print('destructables added:', ' '.join(objects.object_id(o) for o in additions['destructables']))


if __name__ == '__main__':
    stage()
