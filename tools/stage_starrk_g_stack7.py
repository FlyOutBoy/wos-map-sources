"""Stage Starrk G seventh stat stack (clone of A0BW) through MAIN's object codec."""
from pathlib import Path
import json,re
import war3_object_data as raw
import war3_object_workspace as ws
from integrate_crocodile_main_objects import allocate,clone_object
from normalize_tooltip_text import save
ROOT=Path(__file__).resolve().parents[1]
PATH=ROOT/'object-data/starrk-g-stack-ids.json'
TEMPLATE='A0BW'

def stage():
 docs,_=ws.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
 used={ws.object_id(o) for d in docs for o in d['original_objects']+d['custom_objects']}
 own=used
 used=set()
 for folder in ('triggers','test_map'):
  for p in (ROOT/folder).rglob('*.j'):
   used.update(re.findall(r"'([ABI][A-Z0-9]{3})'",p.read_text(encoding='utf-8-sig',errors='replace')))
 for p in (ROOT/'object-data').glob('*-ids.json'):
  if p!=PATH:used.update(re.findall(r'"([ABI][A-Z0-9]{3})"',p.read_text(encoding='utf-8')))
 ids=json.loads(PATH.read_text()) if PATH.exists() else {}
 if ids.get('Pas7') in used and ids['Pas7'] not in re.findall(r"'([A-Z0-9]{4})'",(ROOT/'triggers/Heroes/Starrk.j').read_text(encoding='utf-8')):
  # Earlier allocation collided with a TEST-hero id: drop that clone and reallocate.
  bad=ids.pop('Pas7')
  for d in docs:
   if d['kind']=='abilities':d['custom_objects']=[o for o in d['custom_objects'] if ws.object_id(o)!=bad]
 used|=own
 if 'Pas7' not in ids:ids['Pas7']=allocate('A',used)
 strings=raw.parse_wts(Path(json.loads((ROOT/'.vscode/wos-build.json').read_text())['mainMap'])/'war3map.wts')
 for d in docs:
  if d['kind']!='abilities':continue
  entries={ws.object_id(o):o for o in d['custom_objects']}
  if TEMPLATE in entries and ids['Pas7'] not in entries:
   d['custom_objects'].append(clone_object(entries[TEMPLATE],ids['Pas7'],{},strings))
 for d in docs:
  if d['kind']=='abilities':
   raw.encode_object_file(d,d['source_file']);save(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[d['source_file']],d)
 for kind,(view,meta) in ws.views_from_raw(docs,ROOT/'libs/common.j').items():
  if kind=='abilities':save(ROOT/'object-data'/ws.CATEGORY_FILES[kind],view);save(ROOT/'.object-data-raw/workspace-meta'/ws.CATEGORY_FILES[kind],meta)
 save(PATH,ids);print(ids)
if __name__=='__main__':stage()
