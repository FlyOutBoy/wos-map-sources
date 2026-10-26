"""Merge only Frostnova's saved TEST objects into project MAIN/TEST workspaces.

Resolves TEST WTS strings and skin overrides before transfer. Unrelated editable
objects are retained. Does not write either map; normal check/save follows.
"""
from pathlib import Path
import argparse
import copy
import json
import re

import war3_object_data as raw
import war3_object_workspace as workspace
from integrate_crocodile_main_objects import code, set_field, clone_object, allocate

ROOT = Path(__file__).resolve().parents[1]


def identity(obj):
    return obj['new_id']['text'] or obj['old_id']['text']


def stage(source, packet, output):
    strings = raw.parse_wts(source/'war3map.wts')
    docs = []
    for path in source.glob('*.w3*'):
        if path.suffix in raw.FORMAT_BY_EXTENSION:
            docs.append(raw.parse_object_file(path.read_bytes(), path.name, *raw.FORMAT_BY_EXTENSION[path.suffix], strings))
    globals_text = (ROOT/'test_map/heroes/Frostnova.j').read_text('utf-8-sig').split('endglobals', 1)[0]
    hero_ids = set(re.findall(r"integer\s+Frostnova\w*\s*=\s*'([A-Za-z0-9]{4})'", globals_text))
    hero_ids -= {'B0F3', 'A1F2'}  # Created below after collision inspection.
    originals = copy.deepcopy(docs)
    profiles = [(ROOT/'object-data', ROOT/'.object-data-raw'),
                (ROOT/'test_map/profiles/Frostnova/object-data', ROOT/'test_map/profiles/Frostnova/.object-data-raw')]
    prepared = [(editable, baseline, workspace.prepare_documents(editable, baseline)[0]) for editable, baseline in profiles]
    used = {identity(obj) for document in [*docs, *(d for _, _, group in prepared for d in group)]
            for table in ('original_objects', 'custom_objects') for obj in document[table]}
    mapping = {}
    existing_main = {identity(obj):obj for doc in prepared[0][2] for obj in doc['custom_objects']}
    for old in sorted(hero_ids):
        existing = existing_main.get(old)
        if existing is not None:
            title = ' '.join(str(m['data'].get('value', '')) for m in existing['modifications']
                             if m['field']['text'] in ('anam', 'fnam', 'unam'))
            if 'Frostnova' not in title and 'FrostNova' not in title:
                raise ValueError('Review MAIN rawcode collision before transfer: '+old+' '+title)
        mapping[old] = old
    def reserve(preferred, title):
        existing = existing_main.get(preferred)
        if preferred not in used or (existing and title in str(existing)):
            used.add(preferred)
            return preferred
        return allocate(preferred[0], used)
    shield_buff = reserve('B0F3', 'Frostnova T - Song Shield')
    shield_ability = reserve('A1F2', 'Frostnova T shield marker')
    mapping.update(B0F3=shield_buff, A1F2=shield_ability)
    paths = json.loads((packet/'manifest.json').read_text('utf8'))['paths']
    folded_paths = {key.casefold():value for key,value in paths.items()}
    def find(file, wanted):
        return next(obj for doc in docs if doc['source_file']==file for obj in doc['custom_objects'] if identity(obj)==wanted)
    buff = clone_object(find('war3map.w3h', 'B0F0'), shield_buff, {}, strings)
    buff['old_id'] = code('BUfa')
    for field, value in [('fnam','Frostnova T - Song Shield'), ('ftip', 'Song Shield'),
        ('fube','Blocks the next damage instance. Expires after 5 sec. Renewed by Winter\'s Scar and its song.'),
        ('fart',r'ReplaceableTextures\CommandButtons\BTNHero_Frostnova_T.blp'),
        ('ftat',r'war3mapImported\wos_title_shielded.mdl'), ('feat',''), ('ftac','origin')]:
        set_field(buff, field, value, leveled=False)
    ability = clone_object(find('war3map.w3a', 'A1F0'), shield_ability, {}, strings)
    # Frost Armor has its own buff family and cannot replace E's Inner Fire marker.
    ability['old_id'] = code('AUfu')
    ability['modifications'] = [m for m in ability['modifications'] if not m['field']['text'].startswith('Inf')]
    for field,value,kind,level,pointer in [('anam','Frostnova T shield marker','string',0,0),
        ('abuf',shield_buff,'string',1,0),('adur',4.,'unreal',1,0),('ahdu',4.,'unreal',1,0),
        ('Ufa1',0.,'unreal',1,1),('Ufa2',0.,'unreal',1,2),
        ('atar','air,ground,friend,self,organic,vulnerable,invulnerable','string',1,0)]:
        set_field(ability,field,value,kind,level,pointer)
    # Re-running must not append a second copy (duplicate A1F2 left T's shield without a duration).
    for file, obj in (('war3map.w3h', buff), ('war3map.w3a', ability)):
        target = next(d for d in docs if d['source_file']==file)['custom_objects']
        if not any(identity(o)==identity(obj) for o in target):
            target.append(obj)
    hero_ids.update({shield_buff, shield_ability})
    descriptions = {
        'Q': ('Ice Javelins', 'Throws a javelin that stops at the first enemy and applies Yeti Princess.'),
        'W': ('Northern Winds', 'A widening wave applies Yeti Princess and pushes enemies.'),
        'E': ('Frost Nova', 'A frost burst pushes enemies and leaves a freezing field.'),
        'R': ('Icefield', 'Creates a blizzard that applies Yeti Princess.'),
        'T': ("Winter's Scar", 'Enters Winter\'s Scar, empowering her spells and continuing her song.'),
        'F': ('Yeti Princess', 'Spells apply a stacking movement slow.')}
    ability_ids = {slot:re.search(r'integer Frostnova'+slot+r"_ID\s*=\s*'(.{4})'",globals_text)[1] for slot in 'QWERTF'}
    for doc in docs:
        for obj in doc['custom_objects']:
            old = identity(obj)
            if old not in hero_ids:
                continue
            for modification in obj['modifications']:
                if modification['type']=='string':
                    value = raw.resolve_trigger_string(modification['data'].get('value',''), strings) or modification['data'].get('value','')
                    modification['data']={'value':folded_paths.get(value.casefold(),value)}
            if old=='H002':
                skin = 'Skin' in doc['source_file']
                if skin:
                    for field,value in [('umdl',r'war3mapImported\wos_Frostnova.mdx'),('unam','Frostnova'),('upro','Yeti Princess'),
                        ('uico',r'ReplaceableTextures\CommandButtons\BTNHero_Frostnova_Icon.blp'),('ussi',r'ReplaceableTextures\CommandButtons\BTNHero_Frostnova_Icon.blp'),
                        ('utip','Frostnova'),('utub','Arknights | Difficulty: Normal. A frost mage who controls space with stacking slows and empowers her spells with Winter\'s Scar.')]:
                        set_field(obj,field,value,leveled=False)
                else:
                    set_field(obj,'ufil',r'war3mapImported\wos_Frostnova.mdx',leveled=False)
            for slot,ability_id in ability_ids.items():
                if old==ability_id and 'Skin' not in doc['source_file']:
                    set_field(obj,'aher',1,'int')
                    set_field(obj,'alev',5 if slot in 'QWER' else 1,'int')
                    set_field(obj,'arlv',10 if slot=='R' else 25 if slot=='T' else 1,'int')
                    set_field(obj,'alsk',4 if slot in 'QWER' else 3,'int')
                    set_field(obj,'areq','h002' if slot=='F' else '')
                    set_field(obj,'arqa','1' if slot=='F' else '')
                    if slot!='F':
                        for rank in range(1,6 if slot in 'QWER' else 2):
                            set_field(obj,'Ncl6',dict(Q='absorb',W='carrionswarm',E='thunderclap',R='blizzard',T='berserk')[slot],'string',rank,6)
                            set_field(obj,'Ncl3',3 if slot=='R' else 1,'int',rank,3)
                            if slot=='Q':set_field(obj,'aran',1400.+50.*(rank-1),'unreal',rank)
                            if slot=='W':set_field(obj,'aran',1600.,'unreal',rank)
                            if slot in 'ER':set_field(obj,'aare',850. if slot=='E' else 1050.,'unreal',rank)
                            cooldown=dict(Q=20.,W=24.,E=25.,R=30.,T=50.)[slot]
                            if slot in 'QWR':cooldown-=rank-1
                            set_field(obj,'acdn',cooldown,'unreal',rank)
                if old==ability_id and 'Skin' in doc['source_file']:
                    name,description=descriptions[slot]
                    set_field(obj,'anam','Arknights Frostnova '+slot)
                    set_field(obj,'aart',fr'ReplaceableTextures\CommandButtons\BTNHero_Frostnova_{slot}.blp')
                    for level in range(1,2 if slot in 'TF' else 6):
                        set_field(obj,'atp1',name,'string',level)
                        set_field(obj,'aub1',description,'string',level)
                    set_field(obj,'arut',description)
                    position=dict(Q=(0,2),W=(1,2),E=(2,2),R=(3,2),T=(3,1),F=(1,1))[slot]
                    set_field(obj,'abpx',position[0],'int');set_field(obj,'abpy',position[1],'int')
            if old in {'A11C','A1F0','A1F1',shield_ability} and 'Skin' not in doc['source_file']:
                set_field(obj,'aher',0,'int');set_field(obj,'aite',0,'int');set_field(obj,'areq','')
                for rank in range(1,11 if old=='A11C' else 2):
                    set_field(obj,'amcs',0,'int',rank)
                    set_field(obj,'acdn',0.,'unreal',rank)
                    set_field(obj,'atar','invulnerable,vulnerable','string',rank)
    output.mkdir(parents=True,exist_ok=True)
    for doc in docs:
        if doc != next((old for old in originals if old['source_file']==doc['source_file']),None):
            (output/doc['source_file']).write_bytes(raw.encode_object_file(doc,doc['source_file']))
    updated=[]
    for editable,baseline,documents in prepared:
        for incoming in docs:
            selected=[clone_object(obj,mapping.get(identity(obj),identity(obj)),mapping,strings)
                      for obj in incoming['custom_objects'] if identity(obj) in hero_ids]
            if not selected:
                continue
            target=next((d for d in documents if d['source_file']==incoming['source_file']),None)
            if target is None:
                target=copy.deepcopy(incoming);target['original_objects']=[];target['custom_objects']=[];documents.append(target)
            if editable==ROOT/'object-data' and incoming['source_file']=='war3map.w3a':
                # MAIN follows Ainz's mana costs; TEST retains its saved zero costs.
                previous={identity(obj):obj for obj in target['custom_objects']}
                for obj in selected:
                    if identity(obj) in previous and identity(obj) in {ability_ids[s] for s in 'QWERT'}:
                        slot=next(s for s in 'QWERT' if ability_ids[s]==identity(obj))
                        for rank in range(1,2 if slot=='T' else 6):
                            mana=dict(Q=100+10*(rank-1),W=90+15*(rank-1),E=125,R=125+15*(rank-1),T=225)[slot]
                            set_field(obj,'amcs',mana,'int',rank)
            if editable==ROOT/'object-data':
                for obj in selected:
                    if identity(obj)==shield_buff:
                        # MAIN owns Shielded art through Starts.j. Minimal TEST
                        # uses the same model as a native buff attachment.
                        set_field(obj,'ftat','',leveled=False)
            selected_ids={identity(obj) for obj in selected}
            target['custom_objects']=[obj for obj in target['custom_objects'] if identity(obj) not in selected_ids]+selected
            raw.dump_json(baseline/raw.OUTPUT_NAMES[target['source_file']],target)
        for kind,(view,metadata) in workspace.views_from_raw(documents,ROOT/'libs/common.j').items():
            raw.dump_json(editable/workspace.CATEGORY_FILES[kind],view)
            raw.dump_json(baseline/'workspace-meta'/workspace.CATEGORY_FILES[kind],metadata)
        updated.append(str(editable))
    result=dict(mapping=mapping,shieldBuff=shield_buff,shieldAbility=shield_ability,objects=sorted(hero_ids),workspaces=updated)
    (output/'objects-report.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result))


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source',type=Path);parser.add_argument('packet',type=Path);parser.add_argument('output',type=Path)
    args=parser.parse_args();stage(args.source,args.packet,args.output)
