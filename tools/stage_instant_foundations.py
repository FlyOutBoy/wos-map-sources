"""Stage order-preserving foundations while retaining each button's full metadata.

Berserk is truly instant. Battle Roar/Roar are queue-instant fallbacks for
coexisting hero slots: they resume the previous order after their native cast.
Item abilities are addressed by their inventory slot, independently of hero orders.
Only an immediate pause on button press requires Channel. A later counterattack
does not change the instant foundation of the activation button.
Sources: Hive threads 292477, 260836, 270130.
"""
from pathlib import Path
import json
import copy
import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field

ROOT=Path(__file__).resolve().parents[1]
ITEMS=set('A02T A02U A0AL A0BZ A0E4 A0FD A0G0 A0G1 A10D A135 A13C A13E A140 A142 A152 A154'.split())
HERO_BASES={
 **dict.fromkeys('A00K A01O A030 A053 A065 A083 A093 A09E A0A3 A0F2 A0CI A0E3 A0DR A0E9 A0EZ A0GP A0H6 A11A A0DF'.split(),'Absk'),
 **dict.fromkeys('A09Q A029 A03D A05E A0DY A05I A066 A090 A0AH A0CK A0GU'.split(),'ANbr'),
 'A03M':'Absk', 'A06E':'Aroa', 'A0AI':'Aroa', 'A06U':'Aroa',
}
# Alter Saber F and Kenjaku G already occupy Berserk; Erza F/4F are exclusive forms.
BASES={**dict.fromkeys(ITEMS,'Absk'),**HERO_BASES}
# Bambietta W immediately pauses. Erza's form exit intentionally stops the hero.
# Counter/buff buttons retain instant bases; later pauses are separate actions.
PAUSED_CHANNELS={'A0DF':'acolyteharvest','A030':'spellshield'}
BASES.update(dict.fromkeys(PAUSED_CHANNELS,'ANcl'))
# Q3 shares the command card with Yamamoto's Berserk style switch. Erza's
# universal F and Kyoraku's final-act/skip buttons also coexist.
ORDER_BASES={'A093':'Aroa','A03M':'Aroa','A0DY':'Aroa'}
HERO_BASES.update(ORDER_BASES)
BASES.update(ORDER_BASES)
CHANNEL_ORDERS={'A03L':'clusterrockets','A03O':'acidbomb','A113':'charm',
                'A0FS':'grabtree','A0A0':'ancestralspirit'}
CHANNEL_FIELDS={'Ncl1','Ncl2','Ncl3','Ncl4','Ncl5','Ncl6'}
ART_FIELDS={'acat','atat','asat','aeat','aaea','alig','amat','aefs','aefl','aani','acap','aca1','ata0','ata1','ata2','ata3','ata4','ata5'}
INSTANT_BASES={'Absk','ANbr','Aroa'}
# Retail Units/AbilityData.slk: switching bases must preserve inherited costs,
# cooldowns and flags too (e.g. Berserk's default cooldown is 30, Roar's is 0).
NATIVE_DEFAULTS={
 'Absk':dict(alev=1,aher=0,aite=0,arlv=0,alsk=0,amcs=0,acdn=30.),
 'ANbr':dict(alev=4,aher=1,aite=0,arlv=1,alsk=0,amcs=50,acdn=25.),
 'Aroa':dict(alev=1,aher=0,aite=0,arlv=0,alsk=0,amcs=100,acdn=0.),
}

def configure_order_bases(documents,selected=None):
 effective={};previous={}
 for d in documents:
  if d['kind']!='abilities':continue
  for o in d['custom_objects']:
   aid=objects.object_id(o)
   if aid not in ORDER_BASES or selected is not None and aid not in selected:continue
   previous[aid]=o['old_id']['text']
   effective.setdefault(aid,{}).update({(m['field']['text'],m.get('level',0)):objects.value_for_user(m) for m in o['modifications']})
 for d in documents:
  if d['kind']!='abilities':continue
  for o in d['custom_objects']:
   aid=objects.object_id(o)
   if aid not in previous or previous[aid]==ORDER_BASES[aid]:continue
   old=NATIVE_DEFAULTS[previous[aid]];new=NATIVE_DEFAULTS[ORDER_BASES[aid]];values=effective[aid]
   levels=int(values.get(('alev',0),old['alev']))
   for field in ('alev','aher','aite','arlv','alsk','amcs','acdn'):
    if old[field]==new[field]:continue
    for rank in range(1,levels+1) if field in ('amcs','acdn') else (0,):
     set_field(o,field,values.get((field,rank),old[field]),'unreal' if field=='acdn' else 'int',rank,0,leveled=True)
   base=ORDER_BASES[aid];o['old_id']={'text':base,'hex':base.encode().hex().upper()}
def configure_neutral(documents,snapshot):
 """Native instant buttons only dispatch script; no native buffs or bonuses."""
 for d in documents:
  if d['kind']!='abilities':continue
  for o in d['custom_objects']:
   base=o['old_id']['text'];aid=objects.object_id(o)
   if base not in INSTANT_BASES:continue
   for rank in range(1,int(snapshot[aid].get('levels',1))+1):
    set_field(o,'atar','enemies','string',rank)
    set_field(o,'aare',0.,'unreal',rank)
    if base=='Absk':
     for pointer,field in enumerate(('bsk1','bsk2','bsk3'),1):set_field(o,field,0.,'unreal',rank,pointer)
    else:
     damage='Nbr1' if base=='ANbr' else 'Roa1'
     for field,kind,pointer in [(damage,'unreal',1),('Roa2','int',2),('Roa3','unreal',3),('Roa4','unreal',4),('Roa5','int',5),('Roa6','int',6),('Roa7','int',7)]:set_field(o,field,0,'int' if kind=='int' else 'unreal',rank,pointer)

def configure_presentation(documents,snapshot):
 """Explicit presentation overrides prevent inherited stock art and grid slots."""
 import re
 constants={m[0]:m[1] for p in (ROOT/'triggers').rglob('*.j') for m in re.findall(r'integer\s+(\w+)\s*=\s*\x27(.{4})\x27',p.read_text(encoding='utf-8-sig'))}
 slots={constants[name]:slot for slot,name in re.findall(r'AHUI_AddHeroAbility\(whichHero, AHUI_SLOT_(\w), (\w+)\)',(ROOT/'triggers/WOS_Start/ShowCD.j').read_text(encoding='utf-8-sig')) if name in constants}
 selected={aid for aid,v in snapshot.items() if v['base_id'] in ('Absk','ANbr','Aroa')}|set(PAUSED_CHANNELS)|{'A06U','A0EY','A0HI'}
 for d in documents:
  if d['kind']!='abilities':continue
  for o in d['custom_objects']:
   aid=objects.object_id(o)
   if aid not in selected:continue
   for f in ART_FIELDS:set_field(o,f,'','string',0,0,leveled=True)
   for f in ('acac','atac'):set_field(o,f,0,'int',0,0,leveled=True)
   ranks=int(snapshot[aid].get('levels',1))
   for rank in range(1,ranks+1):
    for f in ('abuf','aeff'):set_field(o,f,'','string',rank)
   if aid in slots:
    x,y={'Q':(0,2),'W':(1,2),'E':(2,2),'R':(3,2),'T':(3,1),'F':(1,1),'G':(2,1)}[slots[aid]]
    for f,v in [('abpx',x),('abpy',y),('aubx',x),('auby',y),('arpx',x),('arpy',y)]:set_field(o,f,v,'int',0,0,leveled=True)
   icon=snapshot[aid].get('activated_icon',snapshot[aid].get('icon',''))
   if icon:set_field(o,'auar',icon,'string',0,0,leveled=True)

def configure_channel_orders(documents,snapshot):
 for d in documents:
  if d['kind']!='abilities':continue
  for o in d['custom_objects']:
   aid=objects.object_id(o)
   if aid in CHANNEL_ORDERS:
    assert o['old_id']['text']=='ANcl',aid
    for rank in range(1,int(snapshot[aid].get('levels',1))+1):
     set_field(o,'Ncl6',CHANNEL_ORDERS[aid],'string',rank,6)

def stage_presentation(neutral_only=False,orders_only=False):
 import time
 def dump(path,data):
  for attempt in range(10):
   try:
    raw.dump_json(path,data);return
   except PermissionError:
    if attempt==9:raise
    time.sleep(.1)
 snapshot=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
 docs,_=objects.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
 if not neutral_only:
  configure(docs,snapshot,set(ORDER_BASES) if orders_only else {'A06U'})
  configure_presentation(docs,snapshot)
  configure_channel_orders(docs,snapshot)
 configure_neutral(docs,snapshot)
 for d in docs:
  if d['kind']=='abilities':
   raw.encode_object_file(d,d['source_file']);dump(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[d['source_file']],d)
 view,meta=objects.views_from_raw(docs,ROOT/'libs/common.j')['abilities']
 dump(ROOT/'object-data/abilities.json',view);dump(ROOT/'.object-data-raw/workspace-meta/abilities.json',meta)


def configure(documents, snapshot, selected=None):
 configure_order_bases(documents,selected)
 for d in documents:
  if d['kind']!='abilities':continue
  for o in d['custom_objects']:
   aid=objects.object_id(o)
   if aid not in BASES or (selected is not None and aid not in selected):continue
   if aid in ORDER_BASES:continue
   base=BASES[aid];o['old_id']={'text':base,'hex':base.encode().hex().upper()}
   o['modifications']=[m for m in o['modifications'] if m['field']['text'] not in CHANNEL_FIELDS]
   if d['source_file']!='war3map.w3a' and aid not in PAUSED_CHANNELS:continue
   v=snapshot[aid];levels=int(v.get('levels',1))
   if aid in PAUSED_CHANNELS:
    o['modifications']=[m for m in o['modifications'] if m['field']['text'] not in {'bsk1','bsk2','bsk3','Roa1','Roa2','Roa3','Roa4','adur','ahdu'}]
    for rank in range(1,levels+1):
     for f,x,k,p in [('Ncl1',0.,'unreal',1),('Ncl2',0,'int',2),('Ncl3',1,'int',3),('Ncl4',0,'int',4),('Ncl5',0,'int',5),('Ncl6',PAUSED_CHANNELS[aid],'string',6),('adur',0.,'unreal',0),('ahdu',0.,'unreal',0)]:
      set_field(o,f,x,k,rank,p)
    if aid=='A030':
     # Former Berserk defaults must not become Channel's learnable hero flags.
     for f,x in [('alev',1),('aher',0),('aite',0),('arlv',0),('alsk',0)]:set_field(o,f,x,'int',0)
     set_field(o,'amcs',0,'int',1)
     set_field(o,'acdn',1.,'unreal',1)
    continue
   for f,x in [('alev',levels),('aher',int(v.get('hero_ability',aid not in ITEMS))),
               ('aite',int(v.get('item_ability',aid in ITEMS))),
               ('arlv',int(v.get('required_level',1))),('alsk',int(v.get('level_skip',0)))]:
    set_field(o,f,x,'int',0,0,leveled=True)
   for rank in range(1,levels+1):
    for field,key,default,kind in [('amcs','mana_cost',0,'int'),('acdn','cooldown',0.,'unreal'),('aran','cast_range',0.,'unreal')]:
     set_field(o,field,v.get(f'{key} level {rank}',v.get(f'{key} level 1',default)),kind,rank)
    for f in ('abuf','aeff'):set_field(o,f,'','string',rank)
    for f in ('adur','ahdu'):set_field(o,f,.01,'unreal',rank)
    if base=='Absk':
     for p,f in enumerate(('bsk1','bsk2','bsk3'),1):set_field(o,f,0.,'unreal',rank,p)
    else:
     for f,x,k,p in [('Nbr1' if base=='ANbr' else 'Roa1',0.,'unreal',1),('Roa2',0,'int',2),('Roa3',0.,'unreal',3),('Roa4',0.,'unreal',4),('aare',0.,'unreal',0),('atar','enemies','string',0)]:
      set_field(o,f,x,k,rank,p)
 configure_neutral(documents,snapshot)
 configure_channel_orders(documents,snapshot)


def stage(paused_only=False):
 snapshot=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
 report=ROOT/'_build/instant-foundations-before.json'
 if not report.exists():raw.dump_json(report,{k:snapshot[k] for k in BASES})
 documents,_=objects.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
 configure(documents,snapshot,set(PAUSED_CHANNELS) if paused_only else None)
 for d in documents:
  if d['kind']=='abilities':
   raw.encode_object_file(d,d['source_file']);raw.dump_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[d['source_file']],d)
 view,meta=objects.views_from_raw(documents,ROOT/'libs/common.j')['abilities']
 raw.dump_json(ROOT/'object-data/abilities.json',view)
 raw.dump_json(ROOT/'.object-data-raw/workspace-meta/abilities.json',meta)
 print(f'{len(ITEMS)} item and {len(HERO_BASES)} hero buttons staged; all ranks retained')

if __name__=='__main__':
 import argparse
 parser=argparse.ArgumentParser(description=__doc__)
 parser.add_argument('--paused-only',action='store_true',help='Only restore the reviewed paused hero buttons to Channel')
 parser.add_argument('--presentation-only',action='store_true',help='Repair inherited art, buffs and native command button positions')
 parser.add_argument('--neutral-only',action='store_true',help='Set enemy-only targets, zero area and every native bonus on all Berserk/Roar ranks')
 parser.add_argument('--orders-only',action='store_true',help='Separate reviewed coexisting hero command orders without changing cast mechanics')
 args=parser.parse_args()
 if args.neutral_only:stage_presentation(neutral_only=True)
 elif args.orders_only:stage_presentation(orders_only=True)
 elif args.presentation_only:stage_presentation()
 else:stage(args.paused_only)
