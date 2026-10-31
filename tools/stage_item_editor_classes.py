"""Sort MAIN items into editor classes using the existing seven shop families.

Editor classes are independent of auto-use/powerup flags. Components outside the
catalogue retain their existing class; stat tomes in Base retain STR/AGI/INT.
"""
from pathlib import Path
from collections import defaultdict,Counter
import copy,json,re
import war3_object_data as raw,war3_object_workspace as ws
from integrate_crocodile_main_objects import set_field
from normalize_tooltip_text import save

ROOT=Path(__file__).resolve().parents[1]
CLASSES={'BASE':'Charged','STRENGTH':'Miscellaneous','AGILITY':'Purchasable',
 'INTELLIGENCE':'Campaign','UNIVERSAL':'Permanent','DEFENSIVE':'Artifact','ATTACK':'PowerUp'}

def catalogue(root=ROOT):
 constants={name:aid for p in (root/'triggers').rglob('*.j')
  for name,aid in re.findall(r'integer\s+(\w+)\s*=\s*\x27(.{4})\x27',p.read_text(encoding='utf-8-sig'))}
 source=(root/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8-sig')
 source=source.split('function ShopCatalogue_Define takes',1)[1].split('endfunction',1)[0]
 groups=defaultdict(set)
 for group,expr in re.findall(r'call ShopCat\(SHOP_TAB_(\w+),\s*(.*?)\)',source):
  if expr=='0':continue
  aid=expr.strip("'") if expr.startswith("'") else constants[expr]
  assert group in CLASSES,(aid,group)
  groups[aid].add(group)
 return groups

def desired_classes(items):
 groups=catalogue();result={}
 for iid,item in items.items():
  family=groups.get(iid,set())-{'BASE'}
  assert len(family)<=1,(iid,family)
  if family:result[iid]=CLASSES[next(iter(family))]
  elif iid in groups:
   stat=next((name for name in ('Strength','Agility','Intelligence') if item['name'].startswith('Tome of '+name)),None)
   result[iid]=CLASSES[stat.upper()] if stat else CLASSES['BASE']
  else:result[iid]=item.get('classification','Permanent')
 return result

def configure(documents,items):
 classes=desired_classes(items)
 for d in documents:
  if d['kind']!='items':continue
  for obj in d['custom_objects']:
   iid=ws.object_id(obj);assert iid in classes,iid
   set_field(obj,'icla',classes[iid],'string',leveled=False)
 return classes

def stage():
 docs,_=ws.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
 items=json.loads((ROOT/'object-data/items.json').read_text(encoding='utf-8-sig'))
 classes=configure(docs,items)
 for d in docs:
  if d['kind']=='items':raw.encode_object_file(d,d['source_file']);save(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[d['source_file']],d)
 view,meta=ws.views_from_raw(docs,ROOT/'libs/common.j')['items']
 save(ROOT/'object-data/items.json',view);save(ROOT/'.object-data-raw/workspace-meta/items.json',meta)
 changes={iid:dict(name=items[iid]['name'],before=items[iid].get('classification','Permanent'),after=kind) for iid,kind in classes.items() if items[iid].get('classification','Permanent')!=kind}
 report=dict(items=len(classes),counts=dict(Counter(classes.values())),changed=changes)
 save(ROOT/'_build/item-editor-classes-result.json',report)
 print(f'{len(classes)} item editor classes explicit in main + skin; {len(changes)} items moved; {report["counts"]}')

if __name__=='__main__':stage()
