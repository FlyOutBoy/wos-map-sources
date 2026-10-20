"""Stage Frostnova objects in MAIN and its independent TEST profile.

Uses the lossless object API; normal sync check/save owns map writes. Existing
objects outside this hero are preserved. IDs are allocated once across both maps.
"""
from pathlib import Path
import copy
import json
import re

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import allocate, clone_object, set_field, code

ROOT = Path(__file__).resolve().parents[1]
IDS = ROOT / 'object-data/frostnova-ids.json'
PROFILE = ROOT / 'test_map/profiles/Frostnova'
SLOTS = 'QWERTF'
TITLES = dict(zip(SLOTS, ['Ice Javelins', 'Northern Winds', 'Frostnova', 'Icefield', "Winter's Scar", 'Yeti Princess']))
DESCRIPTIONS = {
    'Q': 'Launches an ice javelin that stops at the first enemy, deals {damage} magic damage and stuns for 0.1 sec. Applies Cold. Holds 2/2/4/4/6 charges at ability levels 1/2/3/4/5; restores one charge every 6 sec. Delay between throws: 0.3 sec. Range: 1200.',
    'W': "Sends a freezing wave 1100 range forward, dealing {damage} magic damage once per enemy, applying Cold and pushing enemies 150 range. Winter's Scar: pushes 350 range instead. Width: 220.",
    'E': "Becomes invulnerable for 0.6 sec and pushes nearby enemies 250 range. Leaves a stationary frost field at the cast position for 6 sec, dealing {damage} magic damage each second and applying Cold. Radius: 450. Winter's Scar: the initial burst also stuns for 1 sec.",
    'R': "Freezes an area for 12 sec, dealing {damage} magic damage and applying Cold once per second. Radius: 800. Winter's Scar: grows one blocking ice crystal every 1.5 sec, up to 8. Crystals disappear with the field; they do not deal additional damage.",
    'T': 'Enters Winter\'s Scar for 12 sec, fully restoring Ice Javelins charges and resetting its cooldown. Spells apply Frostbite instead of Cold; Northern Winds pushes farther, Frostnova initially stuns, and Icefield grows blocking crystals. Does not cost HP.',
    'F': "Spells apply Cold: each hit adds one stack, up to 5, slowing movement by 5% per stack for 4 sec (max 25%). Winter's Scar replaces Cold with Frostbite: 8% slow per stack for 6 sec (max 40%) and 0.12x Intelligence magic damage per stack each second. New stacks refresh duration; dispelling the debuff removes the stacks. Cold does not downgrade existing Frostbite. The strongest current stack count is shared between Frostnova casters.",
}
COEFFICIENTS = {'Q': (1., .3), 'W': (1.5, .4), 'E': (.35, .1), 'R': (.2, .05)}


def stage():
    main, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
    test, _ = objects.prepare_documents(PROFILE/'object-data', PROFILE/'.object-data-raw')
    used = {objects.object_id(o) for docs in (main, test) for d in docs
            for g in ('original_objects', 'custom_objects') for o in d[g]}
    for path in (ROOT/'triggers').rglob('*.j'):
        used.update(re.findall(r"'([^'\r\n]{4})'", path.read_text(encoding='utf-8-sig')))
    ids = json.loads(IDS.read_text()) if IDS.exists() else {}
    for name, prefix in [('hero', 'H'), *[(s, 'A') for s in SLOTS],
                         ('Cold', 'A'), ('Frostbite', 'A'), ('ColdBuff', 'B'), ('FrostbiteBuff', 'B'), ('Crystal', 'B')]:
        if name not in ids:
            ids[name] = allocate(prefix, used)
    config = json.loads((ROOT/'.vscode/wos-build.json').read_text('utf-8-sig'))
    strings = raw.parse_wts(Path(config['mainMap'])/'war3map.wts')

    def combined(kind, identity):
        found = [o for d in main if d['kind'] == kind for g in ('original_objects', 'custom_objects')
                 for o in d[g] if objects.object_id(o) == identity]
        if not found:
            raise ValueError(f'Missing template {kind} {identity}')
        result = clone_object(found[0], identity, {}, strings)
        for obj in found[1:]:
            for m in clone_object(obj, identity, {}, strings)['modifications']:
                set_field(result, m['field']['text'], objects.value_for_user(m), m['type'],
                          m.get('level', 0), m.get('data_pointer', 0), kind == 'abilities')
        return result

    additions = {kind: [] for kind in ('units', 'abilities', 'buffs', 'destructables')}
    hero = clone_object(combined('units', 'H02H'), ids['hero'], {}, strings)
    for field, value in {'unam':'Frostnova', 'upro':'Yeti Princess', 'utip':'Frostnova',
                         'utub':'Frostnova - frost mage. Placeholder model; replace ufil when the model is ready.',
                         'ufil':r'units\human\Jaina\Jaina.mdl', 'uico':r'ReplaceableTextures\CommandButtons\BTNHero_Frostnova_Icon.blp',
                         'ussi':r'ReplaceableTextures\CommandButtons\BTNHero_Frostnova_Icon.blp',
                         'uhab':','.join(ids[s] for s in 'QWERT'), 'uabi':ids['F'],
                         'ua1m':r'Abilities\Weapons\LichMissile\LichMissile.mdl', 'usnd':'Jaina'}.items():
        set_field(hero, field, value, leveled=False)
    set_field(hero, 'usca', 1., 'real', leveled=False)
    additions['units'].append(hero)
    for slot in SLOTS:
        template = combined('abilities', 'A0GW' if slot == 'F' else 'A0GK')
        obj = clone_object(template, ids[slot], {}, strings)
        if slot == 'F':
            # Native passive icon, no inherited spell mechanics.
            obj['original_id'] = code('Agyb')
            obj['modifications'] = []
        else:
            obj['modifications'] = [m for m in obj['modifications'] if m.get('level', 0) <= (1 if slot == 'T' else 5)]
        levels = 1 if slot in 'TF' else 5
        for f,v,k in [('anam', 'Arknights Frostnova '+slot,'string'), ('alev',levels,'int'), ('aher',0 if slot=='F' else 1,'int'),
                      ('alsk',0,'int'), ('ahky',slot,'string'), ('arhk',slot,'string'), ('arlv',1 if slot!='T' else 6,'int'),
                      ('alsr',2,'int'), ('abpx', 'QWERTF'.index(slot) if slot!='F' else 1,'int'), ('abpy',2 if slot!='F' else 1,'int'),
                      ('aart',fr'ReplaceableTextures\CommandButtons\BTNHero_Frostnova_{slot}.blp','string'),
                      ('arar',fr'ReplaceableTextures\CommandButtons\BTNHero_Frostnova_{slot}.blp','string'),
                      ('aret', TITLES[slot]+' ('+slot+')','string')]:
            set_field(obj,f,v,k)
        if slot == 'T':
            set_field(obj,'abpx',0,'int')
            set_field(obj,'abpy',1,'int')
        for lv in range(1, levels+1):
            damage = ('Intelligence x '+format(COEFFICIENTS[slot][0]+COEFFICIENTS[slot][1]*(lv-1),'.2f')) if slot in COEFFICIENTS else ''
            desc = DESCRIPTIONS[slot].format(damage=damage)
            set_field(obj,'atp1', TITLES[slot]+f' ({slot}) [Level {lv}]', level=lv)
            set_field(obj,'aub1', desc, level=lv)
            if slot == 'F':
                continue
            cd = {'Q':.3,'W':12.,'E':20.,'R':30.,'T':65.}[slot]
            for f,v,k,p in [('acdn',cd,'unreal',0), ('amcs',{'Q':25,'W':80,'E':100,'R':120,'T':150}[slot],'int',0),
                            ('aran',{'Q':1200.,'W':1100.,'E':0.,'R':1200.,'T':0.}[slot],'unreal',0),
                            ('aare',{'Q':70.,'W':220.,'E':450.,'R':800.,'T':0.}[slot],'unreal',0),
                            ('acas',0.,'unreal',0), ('adur',0.,'unreal',0), ('ahdu',0.,'unreal',0),
                            ('Ncl1',0.,'unreal',1), ('Ncl2',2 if slot in 'QWR' else 0,'int',2),
                            ('Ncl3',1,'int',3), ('Ncl4',0.,'unreal',4), ('Ncl5',0,'int',5),
                            ('Ncl6',{'Q':'channel','W':'carrionswarm','E':'thunderclap','R':'blizzard','T':'berserk'}[slot],'string',6),
                            ('atar','air,ground,enemy,neutral,vulnerable','string',0), ('aeat','','string',0),
                            ('acat','','string',0), ('atat','','string',0)]:
                set_field(obj,f,v,k,lv,p)
        set_field(obj, 'arut', DESCRIPTIONS[slot].format(damage='Intelligence scaling; see learned rank'))
        additions['abilities'].append(obj)
    for label, title in [('Cold', 'Cold'), ('Frostbite', 'Frostbite')]:
        buff = clone_object(combined('buffs','B013'), ids[label+'Buff'], {}, strings)
        for f,v in [('fnam', title), ('ftip', title), ('fube',DESCRIPTIONS['F']),
                    ('fart',fr'ReplaceableTextures\CommandButtons\BTNHero_Frostnova_{"F" if label=="Cold" else "T"}.blp'),
                    ('feat',r'Abilities\Spells\Other\FrostDamage\FrostDamage.mdl'), ('feft',''), ('ftat',''), ('ftac','origin')]:
            set_field(buff,f,v,leveled=False)
        additions['buffs'].append(buff)
        ability = clone_object(combined('abilities','A03U'),ids[label],{},strings)
        set_field(ability,'anam','Frostnova '+title)
        set_field(ability,'alev',5,'int')
        set_field(ability,'aher',0,'int')
        for lv in range(1,6):
            for f,v,k,p in [('Slo1',lv*(.05 if label=='Cold' else .08),'unreal',1), ('Slo2',0.,'unreal',2),
                            ('acdn',0.,'unreal',0),('amcs',0,'int',0),('aran',99999.,'unreal',0),
                            ('adur',4. if label=='Cold' else 6.,'unreal',0), ('ahdu',4. if label=='Cold' else 6.,'unreal',0),
                            ('atar','air,ground,enemy,friend,self,organic,vulnerable','string',0),
                            ('abuf',ids[label+'Buff'],'string',0)]:
                set_field(ability,f,v,k,lv,p)
        additions['abilities'].append(ability)
    # A native ice destructable has real terrain collision and needs no imports.
    # Use the project's existing Inori crystal as a schema/template, replacing art.
    crystals = [o for d in main if d['kind']=='destructables' for o in d['custom_objects']]
    if not crystals:
        raise ValueError('Missing destructable template')
    crystal = clone_object(crystals[0], ids['Crystal'], {}, strings)
    for f,v in [('bnam','Frostnova Ice Crystal'),('bfil',r'Doodads\Icecrown\Terrain\Icecrown_Crystal\Icecrown_Crystal0.mdl'),
                ('bptx',r'PathTextures\4x4SimpleSolid.tga'),('btxf','')]:
        set_field(crystal,f,v,leveled=False)
    for f,v,k in [('bvar',1,'int'),('bhps',500.,'real'),('bmis',1.,'real'),('bmas',1.,'real')]:
        set_field(crystal,f,v,k,leveled=False)
    additions['destructables'].append(crystal)
    for documents, output, rawdir in [(main,ROOT/'object-data',ROOT/'.object-data-raw'),
                                       (test,PROFILE/'object-data',PROFILE/'.object-data-raw')]:
        for kind, new in additions.items():
            targets = {objects.object_id(o) for o in new}
            for d in documents:
                if d['kind']==kind:
                    d['custom_objects'] = [o for o in d['custom_objects'] if objects.object_id(o) not in targets]
            dest = next(d for d in documents if d['kind']==kind and not d['source_file'].startswith('war3mapSkin'))
            dest['custom_objects'].extend(copy.deepcopy(new))
        # TEST uses current MAIN crowd-control ranks, not the old template ranks.
        if documents is test:
            # The arena deliberately casts for free; MAIN keeps its balance costs.
            for ability in additions['abilities']:
                identity = objects.object_id(ability)
                if identity in {ids[s] for s in 'QWERT'}:
                    target = next(o for d in documents if d['kind']=='abilities' and not d['source_file'].startswith('war3mapSkin')
                                  for o in d['custom_objects'] if objects.object_id(o)==identity)
                    for level in range(1, 2 if identity==ids['T'] else 6):
                        set_field(target, 'amcs', 0, 'int', level)
            shared = {'A1OA','A1OT','APPP','A01V','A1QY'}
            for d in documents:
                if d['kind']=='abilities':
                    src = next(x for x in main if x['source_file']==d['source_file'])
                    d['custom_objects'] = [o for o in d['custom_objects'] if objects.object_id(o) not in shared]
                    d['custom_objects'].extend(copy.deepcopy([o for o in src['custom_objects'] if objects.object_id(o) in shared]))
        for d in documents:
            raw.encode_object_file(d,d['source_file'])
            raw.dump_json(rawdir/raw.OUTPUT_NAMES[d['source_file']],d)
        for kind,(editable,metadata) in objects.views_from_raw(documents,ROOT/'libs/common.j').items():
            raw.dump_json(output/objects.CATEGORY_FILES[kind],editable)
            raw.dump_json(rawdir/'workspace-meta'/objects.CATEGORY_FILES[kind],metadata)
    raw.dump_json(IDS,ids)
    print(json.dumps(ids,indent=2))


if __name__ == '__main__':
    stage()
