"""Normalize MAIN hero property labels and remove repeated static Range rows.

Live tooltips use TooltipBuilder directly; this pass keeps the persisted native
fallbacks readable too. Gameplay metadata and unrelated item text are preserved.
"""
from pathlib import Path
from functools import lru_cache
import json,re
import war3_object_data as raw
import war3_object_workspace as ws
from hero_ability_orders import inventory
from normalize_tooltip_text import save

ROOT=Path(__file__).resolve().parents[1]
COLOR=re.compile(r'\|c[0-9a-fA-F]{8}|\|[rR]')
FROST_LORE="A blizzard that damages enemies inside every second."

@lru_cache(maxsize=1)
def mechanic_labels():
 # Native fallback text contains lore too. Only labels actually authored as
 # mechanics may be colored; a sentence such as "Raiden unleashes Musou Isshin:"
 # must retain its lore formatting, including on hidden higher-rank overrides.
 from repair_main_ability_levels import tooltip_vm
 _,records=tooltip_vm();labels=set()
 for data in records:
  for line in data.mechanics.split('|n'):
   match=re.match(r'^([^:|]{1,40}):',COLOR.sub('',line))
   if match:labels.add(match[1])
 return labels

def normalize(text):
 lines=text.split('|n');seen_range=False;out=[]
 for line in lines:
  plain=COLOR.sub('',line).strip()
  if re.match(r'^Range:',plain,re.I):
   if seen_range:continue
   seen_range=True
  if not line.startswith(('|c','[')):
   match=re.match(r'^([^:|]{1,40}):',line)
   if match and match[1] in mechanic_labels():line='|cffffcc00'+line[:match.end()]+'|r'+line[match.end():]
  out.append(line)
 return '|n'.join(out)

def stage():
 docs,_=ws.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
 ids={aid for group in inventory().values() for aid in group};changed=set();fields=0
 for d in docs:
  if d['kind']!='abilities':continue
  for obj in d['custom_objects']:
   aid=ws.object_id(obj)
   if aid not in ids:continue
   for mod in obj['modifications']:
    if mod['field']['text'] not in ('aub1','arut'):continue
    old=ws.value_for_user(mod)
    if not isinstance(old,str):continue
    text=old
    # Keep the native fallback's bonus, but place it below the stats boundary:
    # captured live lore must not repeat the form-aware Winter's Scar bonus.
    if aid=='A119' and text.startswith(FROST_LORE+'|n|cffffa500[Winter\'s Scar]:'):
     marker='|n|n|cffffcc00Ability Stats:|r'
     rest=text[len(FROST_LORE)+2:].replace(marker,'',1)
     text=FROST_LORE+marker+'|n'+rest
    new=normalize(text)
    if new!=old:
     mod['data']={'value':new};changed.add(aid);fields+=1
 for d in docs:
  if d['kind']=='abilities':raw.encode_object_file(d,d['source_file']);save(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[d['source_file']],d)
 view,meta=ws.views_from_raw(docs,ROOT/'libs/common.j')['abilities']
 save(ROOT/'object-data/abilities.json',view);save(ROOT/'.object-data-raw/workspace-meta/abilities.json',meta)
 report=dict(abilities=sorted(changed),fields=fields)
 save(ROOT/'_build/hero-tooltip-properties-result.json',report)
 print(f'{len(changed)} hero native fallbacks / {fields} text fields normalized')

if __name__=='__main__':stage()
