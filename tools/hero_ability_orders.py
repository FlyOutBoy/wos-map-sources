"""Audit native orders of registered MAIN hero command-card abilities.

Channel has an editable Ncl6. Berserk and both Roars have fixed native orders;
their editor order-string text is not an override. Passive foundations have no
cast order. Same-slot replacements are grouped, while cross-slot collisions
must be absent or backed by an explicit removal before the other button is added.
"""
from pathlib import Path
from collections import defaultdict
import json,re

ROOT=Path(__file__).resolve().parents[1]
FIXED_ORDERS={'Absk':'berserk','ANbr':'battleroar','Aroa':'roar'}
SERVICE_BASES={'Agyb','Aexh','AHad','AOae','Aspb','Agyv'}
EXCLUSIVE_PAIRS={frozenset(('A06U','A06E')):'Inori removes four-stack E before adding T2 cancel and disables cancel before restoring E.'}

def inventory(root=ROOT):
 constants={name:aid for path in (root/'triggers').rglob('*.j')
  for name,aid in re.findall(r'integer\s+(\w+)\s*=\s*\x27(.{4})\x27',path.read_text(encoding='utf-8-sig'))}
 text=(root/'triggers/WOS_Start/ShowCD.j').read_text(encoding='utf-8-sig')
 return {hero:{constants[name]:(slot,name) for slot,name in re.findall(r'AHUI_AddHeroAbility\(whichHero, AHUI_SLOT_(\w), (\w+)\)',body) if name in constants}
  for hero,body in re.findall(r'(?:if|elseif) heroId == (\w+) then(.*?)(?=\n    (?:elseif heroId|endif))',text,re.S)}

def audit(abilities=None,root=ROOT):
 abilities=abilities or json.loads((root/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
 groups=inventory(root);errors=[];exceptions=[];active=0;service=0
 for hero,slots in groups.items():
  orders=defaultdict(list)
  for aid,(slot,name) in slots.items():
   v=abilities[aid];base=v['base_id']
   if base in SERVICE_BASES:service+=1;continue
   active+=1
   if base=='ANcl':
    values={v.get(f'base_order_id level {rank}',v.get('base_order_id level 1','')) for rank in range(1,v.get('levels',1)+1)}
    if len(values)!=1 or not next(iter(values)):
     errors.append((hero,aid,'Channel has missing or changing rank orders',sorted(values)));continue
    order=next(iter(values))
   elif base in FIXED_ORDERS:order=FIXED_ORDERS[base]
   else:errors.append((hero,aid,'Unreviewed native foundation',base));continue
   orders[order].append((aid,slot,name))
  for order,buttons in orders.items():
   for i,(aid,slot,name) in enumerate(buttons):
    for other,other_slot,other_name in buttons[i+1:]:
     if slot==other_slot:continue
     pair=frozenset((aid,other))
     if pair in EXCLUSIVE_PAIRS:exceptions.append((hero,order,sorted(pair),EXCLUSIVE_PAIRS[pair]))
     else:errors.append((hero,order,(aid,slot,name),(other,other_slot,other_name)))
 return dict(heroes=len(groups),buttons=sum(map(len,groups.values())),active=active,service=service,errors=errors,exclusive=exceptions)

if __name__=='__main__':
 result=audit();print(json.dumps(result,indent=2));raise SystemExit(bool(result['errors']))
