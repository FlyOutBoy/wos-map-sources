"""Update Frostnova's native Slow tiers, effects and descriptions without restaging the hero."""
from pathlib import Path
import copy
import json

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import allocate, set_field, clone_object

ROOT=Path(__file__).resolve().parents[1]


def stage():
    locations=[(ROOT/'object-data',ROOT/'.object-data-raw'),
               (ROOT/'test_map/profiles/Frostnova/object-data',ROOT/'test_map/profiles/Frostnova/.object-data-raw')]
    prepared=[(output,baseline,objects.prepare_documents(output,baseline)[0]) for output,baseline in locations]
    ids=json.loads((ROOT/'object-data/frostnova-ids.json').read_text('utf-8'))
    used={objects.object_id(o) for _,_,docs in prepared for d in docs for group in ('original_objects','custom_objects') for o in d[group]}
    for label in ('Cold','Frostbite'):
        for tier in range(2,6):
            ids.setdefault(f'{label}Buff{tier}',allocate('B',used)) if f'{label}Buff{tier}' not in ids else None
    descriptions={
      'Q':'Ice javelins orbit Frostnova while charges remain and launch from their current positions. Stops on the first enemy, dealing Intelligence-scaled magic damage, applying Cold and a 0.1 sec ministun. Charges: 2/2/4/4/6; recharge: 6 sec. No cooldown while a charge remains. Range: 1200.',
      'W':"Prepares for 0.6 sec, then sends a freezing wave growing from radius 80 to 220, applying Cold, Intelligence-scaled damage and 150 push. Winter's Scar: three waves at -30/0/+30 degrees with 350 push; each enemy is hit once per cast.",
      'E':"Prepares for 0.75 sec, then explodes and pushes nearby enemies 250 range. Leaves a frost field for 7 sec, dealing Intelligence-scaled magic damage each second and applying Cold. Radius: 450. Winter's Scar: the burst also stuns for 1 sec.",
      'R':"A blizzard forms over 0.5 sec; the icefield then lasts 8 sec and deals Intelligence-scaled damage each second. Radius: 800. Winter's Scar grows blocking ice shards. Each crystal expands the field by 50 and deals 0.25x Intelligence magic damage per second within 180 range.",
      'F':"Cold stacks up to 5 times: 5/10/15/20/25% native movement slow for 4 sec. Winter's Scar applies separate Frostbite buffs: 8/16/24/32/40% slow for 6 sec plus 0.12x Intelligence damage per stack each second. Each tier has its own Frostnova buff icon; refreshing replaces the previous tier. Dispelling clears stacks.",
      'T':"Winter's Scar lasts 20 sec and refills Q. Spells apply stronger Frostbite slow and damage over time. W fires in three directions, E initially stuns, and R grows damaging crystals which expand its area.",
    }
    for output,baseline,docs in prepared:
        def find(kind,identity):
            return next(o for d in docs if d['kind']==kind for group in ('custom_objects','original_objects') for o in d[group] if objects.object_id(o)==identity)
        ability=find('abilities',ids['Cold'])
        set_field(ability,'anam','Frostnova Slow - Cold / Frostbite')
        set_field(ability,'alev',10,'int')
        for label in ('Cold','Frostbite'):
            template=copy.deepcopy(find('buffs',ids[label+'Buff']))
            for tier in range(1,6):
                identity=ids[label+'Buff' if tier==1 else f'{label}Buff{tier}']
                try: buff=find('buffs',identity)
                except StopIteration:
                    buff=clone_object(template,identity,{}, {})
                    next(d for d in docs if d['kind']=='buffs' and not d['source_file'].startswith('war3mapSkin'))['custom_objects'].append(buff)
                percent=tier*(5 if label=='Cold' else 8)
                title=f'Frostnova {label} ({tier}/5)'
                for key,value in [('fnam',title),('ftip',title),('fube',f'Movement slowed by {percent}%.'+(' Takes frost damage each second.' if label=='Frostbite' else '')),
                    ('fart',fr'ReplaceableTextures\CommandButtons\BTNHero_Frostnova_{"F" if label=="Cold" else "T"}.blp'),
                    ('feat',r'Abilities\Spells\Other\FrostDamage\FrostDamage.mdl' if label=='Cold' else r'war3mapImported\file00003801.mdx')]:
                    set_field(buff,key,value,leveled=False)
                level=tier+(5 if label=='Frostbite' else 0)
                set_field(ability,'abuf',identity,'string',level)
                set_field(ability,'Slo1',percent/100.,'unreal',level,1)
                set_field(ability,'Slo2',0.,'unreal',level,2)
                for key,value,kind in [('acdn',0.,'unreal'),('amcs',0,'int'),('aran',99999.,'unreal'),
                    ('adur',4. if label=='Cold' else 6.,'unreal'),('ahdu',4. if label=='Cold' else 6.,'unreal'),
                    ('atar','air,ground,enemy,friend,self,organic,vulnerable','string')]:
                    set_field(ability,key,value,kind,level)
        set_field(find('destructables',ids['Crystal']),'bfil',r'war3mapImported\Ice_Shard-6CC27.mdx',leveled=False)
        for slot,description in descriptions.items():
            ability=find('abilities',ids[slot])
            for level in range(1,2 if slot in 'TF' else 6):
                set_field(ability,'aub1',description,'string',level)
            set_field(ability,'arut',description)
        for doc in docs:
            raw.encode_object_file(doc,doc['source_file'])
            raw.dump_json(baseline/raw.OUTPUT_NAMES[doc['source_file']],doc)
        for kind,(editable,metadata) in objects.views_from_raw(docs,ROOT/'libs/common.j').items():
            raw.dump_json(output/objects.CATEGORY_FILES[kind],editable)
            raw.dump_json(baseline/'workspace-meta'/objects.CATEGORY_FILES[kind],metadata)
    raw.dump_json(ROOT/'object-data/frostnova-ids.json',ids)
    print(json.dumps({k:v for k,v in ids.items() if 'Buff' in k}))


if __name__=='__main__':
    stage()
