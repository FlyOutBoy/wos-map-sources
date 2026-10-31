"""Normalize player-visible zero terms and numeric percent text, preserving gameplay fields."""
from pathlib import Path
import argparse, json, re, time
import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field
ROOT=Path(__file__).resolve().parents[1]
TEXT_FIELDS=('extended_tooltip','description','research_extended_tooltip')

def normalize(text):
 text=re.sub(r'(?<=\d)\s+(?:percentage points?|percent|процентов|процента|процент)\b','%',text,flags=re.I)
 text=re.sub(r' [+-] 0(?:\.0+)?(?![\d./%])','',text)
 parts=re.split(r'(\|n|\n)',text);out=[]
 for i in range(0,len(parts),2):
  line=parts[i];plain=re.sub(r'\|c[0-9a-fA-F]{8}|\|[rR]','',line).strip()
  if re.fullmatch(r'(?:Range|Radius|Area|AOE|Cast Time|Duration|Damage|Phys\. Damage|Mag\. Damage|Mana|Decor Damage|Heal):\s*0(?:\.0+)?(?:\s*(?:sec|units|%))?',plain,re.I):continue
  out.append(line+(parts[i+1] if i+1<len(parts) else ''))
 return ''.join(out).rstrip('\n')

def save(path,value):
 for attempt in range(6):
  try:return raw.dump_json(path,value)
  except PermissionError:
   if attempt==5:raise
   time.sleep(.2*(attempt+1))

def stage():
 docs,_=objects.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
 merged=objects.views_from_raw(docs,ROOT/'libs/common.j')
 # Active item buttons display the same reviewed mechanics as their owning items.
 items=merged['items'][0]
 active={}
 for iid,it in items.items():
  if it.get('actively_used') and iid not in ('I025','I03U','I051'):
   aid=it.get('abilities','').split(',')[0]
   if aid:active[aid]=it['extended_tooltip']
 changed=0
 for d in docs:
  for o in d['original_objects']+d['custom_objects']:
   aid=objects.object_id(o)
   for m in o['modifications']:
    key=objects.value_for_user(m);f=m['field']['text']
    if not isinstance(key,str):continue
    is_text=f in ('aub1','arut','utub','ides','fube')
    if not is_text:continue
    new=normalize(active[aid] if aid in active and f in ('aub1','arut') else key)
    if new!=key:
     set_field(o,f,new,'string',m.get('level',0),m.get('data_pointer',0),leveled=d['kind']=='abilities');changed+=1
 for d in docs:
  raw.encode_object_file(d,d['source_file']);save(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[d['source_file']],d)
 for k,(v,m) in objects.views_from_raw(docs,ROOT/'libs/common.j').items():
  save(ROOT/'object-data'/objects.CATEGORY_FILES[k],v);save(ROOT/'.object-data-raw/workspace-meta'/objects.CATEGORY_FILES[k],m)
 print(f'{changed} tooltip fields normalized; gameplay metadata preserved')
if __name__=='__main__':stage()
