"""WOS2 Quick Buy: validated JSON rawcodes to the map's Preload carrier file.
Usage: python tools/wos_quickbuy_builds.py builds.json output.txt
Writes only the explicit output path; never edits existing settings implicitly.
"""
from pathlib import Path
import argparse,json,re
ROOT=Path(__file__).resolve().parents[1]
def rawcode(s):
 if not isinstance(s,str) or not re.fullmatch('[A-Za-z0-9_]{4}',s):raise ValueError('Rawcode must be four ASCII letters/digits/underscores')
 return int.from_bytes(s.encode('ascii'),'big')
def validate(data):
 if not isinstance(data,dict) or data.get('version')!=1 or not isinstance(data.get('heroes'),dict):raise ValueError('Expected version:1 and heroes object')
 if len(data['heroes'])>128:raise ValueError('At most 128 hero builds')
 # The actual shop lists and recipe definitions remain the source of truth.
 source=(ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8-sig')
 heroes=json.loads((ROOT/'object-data/units.json').read_text(encoding='utf-8-sig'))
 known=set(re.findall(r"'([I][A-Za-z0-9_]{3})'",source))
 for hero,items in data['heroes'].items():
  rawcode(hero)
  if hero not in heroes:raise ValueError('Hero rawcode is absent from current MAIN: '+hero)
  if not hero.startswith(('H','O','E','U','N','h','o','e','u','n')):raise ValueError('Expected hero/unit rawcode: '+hero)
  if not isinstance(items,list) or len(items)>6 or len(set(items))!=len(items):raise ValueError('At most six distinct item targets per hero')
  for item in items:
   rawcode(item)
   if item not in known:raise ValueError('Item is not referenced by this shop: '+item)
 return data
def payload(data):
 validate(data);s='QB1|'
 for hero,items in sorted(data['heroes'].items()):s+=','.join(map(str,[rawcode(hero)]+[rawcode(x) for x in items]+[0]*(6-len(items))))+'|'
 if len(s)>18000:raise ValueError('Payload exceeds loader limit')
 return s
def encode(data):
 text=payload(data);source=(ROOT/'triggers/WOS_Start/SaveLoad.j').read_text(encoding='utf-8-sig');carriers=[v for _,v in sorted((int(i),v) for i,v in re.findall(r'set ss_ChunkCode\[(\d+)\] = "([A-Za-z0-9]{4})"',source))]
 if len(text)>len(carriers)*180:raise ValueError('Too many carrier chunks')
 lines=['function PreloadFiles takes nothing returns nothing','    call PreloadStart()']
 for i,pos in enumerate(range(0,len(text),180)):
  lines.append('    call BlzSetAbilityTooltip(\''+carriers[i]+'\',"'+text[pos:pos+180]+'",0)')
 lines+=['    call PreloadEnd(0.0)','endfunction'];return '\n'.join(lines)+'\n'
if __name__=='__main__':
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('json',type=Path);p.add_argument('output',type=Path);a=p.parse_args();data=json.loads(a.json.read_text(encoding='utf-8-sig'));a.output.write_text(encode(data),encoding='utf-8');print('Quick Buy preload file:',a.output,'heroes:',len(data['heroes']))
