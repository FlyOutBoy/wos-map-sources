"""Native dispellable item marks with each item's artwork; regular check/save publishes them."""
from pathlib import Path
import json, re
import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import allocate, clone_object, set_field
ROOT=Path(__file__).resolve().parents[1]
PATH=ROOT/'object-data/elemental-marks-ids.json'
MARKS={20:('Ember','I060','Damage to the caster triggers retaliation.'),21:('Verdict','I063','Moving 500 from the first strike triggers extra damage.'),22:('Bastion','I064','Incoming hits consume Static Counter charges.'),23:('Cinder','I065','HP and mana restoration are blocked; the caster\'s next hit deals bonus damage.'),24:('Mirror','I067','The caster\'s hits reflect a projectile to another enemy, once per second.'),25:('Volt','I068','Lightning thread: periodic damage and Static Needle charges.'),26:('Phoenix','I069','Casting a hero ability triggers an explosion.'),27:('Siren','I06B','Mana is drained and returned to the caster.'),28:('Coil','I06C','Separating the linked targets triggers extra damage.'),29:('EmberBurn','I060','Burns for 4 seconds. Dispel to end the damage.'),30:('PhoenixBurn','I069','Burning. Dispel to end the damage.')}

def stage():
 docs,_=objects.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
 by={d['source_file']:d for d in docs};ids=json.loads(PATH.read_text()) if PATH.exists() else {}
 used={objects.object_id(o) for d in docs for g in ('original_objects','custom_objects') for o in d[g]}
 for folder in ('triggers','test_map'):
  for p in (ROOT/folder).rglob('*'):
   if p.suffix in ('.j','.json'):
    text=p.read_text(encoding='utf-8-sig',errors='replace')
    used.update(re.findall(r"'([ABI][A-Z0-9]{3})'",text))
    used.update(re.findall(r'"([ABI][A-Z0-9]{3})"',text))
 for label,_,_ in MARKS.values():
  for suffix,prefix in [('Ability','A'),('Buff','B')]:
   ids.setdefault(label+suffix,allocate(prefix,used) if label+suffix not in ids else ids[label+suffix])
 items=json.loads((ROOT/'object-data/items.json').read_text(encoding='utf-8-sig'))
 config=json.loads((ROOT/'.vscode/wos-build.json').read_text(encoding='utf-8-sig'));strings=raw.parse_wts(Path(config['mainMap'])/'war3map.wts')
 for kindnum,(label,iid,tip) in MARKS.items():
  for kind,file,skin,template in [('abilities','war3map.w3a','war3mapSkin.w3a','A01E' if kindnum==22 else 'A110'),('buffs','war3map.w3h','war3mapSkin.w3h','B001' if kindnum==22 else 'B041')]:
   aid=ids[label+('Ability' if kind=='abilities' else 'Buff')]
   for name in (file,skin):
    idx={objects.object_id(o):o for o in by[name]['custom_objects']}
    if aid not in idx and template in idx:by[name]['custom_objects'].append(clone_object(idx[template],aid,{},strings))
   def put(f,v,k='string',rank=0,ptr=0,art=False):
    idx={objects.object_id(o):o for o in by[skin if art else file]['custom_objects']};o=idx.get(aid)
    if o is None:o=next(o for o in by[file]['custom_objects'] if objects.object_id(o)==aid)
    set_field(o,f,v,k,rank,ptr,leveled=kind=='abilities')
   if kind=='abilities':
    o=next(o for o in by[file]['custom_objects'] if objects.object_id(o)==aid)
    o['modifications']=[m for m in o['modifications'] if not m.get('level') or m['level']==1]
    put('alev',12,'int');put('aher',0,'int');put('aite',0,'int')
    put('anam',items[iid]['name']+' mark',art=True)
    for f in ('aart','atat','acat','aeat'):put(f,'',art=True)
    for rank in range(1,13):
     for f,v,k,p in [('amcs',0,'int',0),('acdn',0.,'unreal',0),('aran',99999.,'unreal',0),('adur',rank*.5,'unreal',0),('ahdu',rank*.5,'unreal',0),('abuf',ids[label+'Buff'],'string',0),('atar','air,ground,organic,mechanical,vulnerable,invulnerable','string',0)]:put(f,v,k,rank,p)
     if kindnum==22:
      for p,f in enumerate(('Inf1','Inf2','Inf3','Inf4'),1):put(f,0 if f=='Inf2' else 0.,'int' if f=='Inf2' else 'unreal',rank,p)
     else:put('Crs1',0.,'unreal',rank,1)
   else:
    for f,v in [('fnam',items[iid]['name']),('ftip',items[iid]['name']),('fube',tip+' Dispelling this buff cancels the effect.'),('fart',items[iid]['icon']),('ftat',''),('feat','')]:put(f,v,art=True)
 raw.dump_json(PATH,ids)
 for d in docs:
  raw.encode_object_file(d,d['source_file']);raw.dump_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[d['source_file']],d)
 for k,(v,m) in objects.views_from_raw(docs,ROOT/'libs/common.j').items():
  raw.dump_json(ROOT/'object-data'/objects.CATEGORY_FILES[k],v);raw.dump_json(ROOT/'.object-data-raw/workspace-meta'/objects.CATEGORY_FILES[k],m)
 # Generate lookup in the owning item library, keeping allocation independent of JASS handles.
 lines=['    // BEGIN ELEMENTAL MARK OBJECTS (tools/stage_elemental_marks.py)','    private function ElemMarkObject takes integer kind, boolean isAbility returns integer']
 for num,(label,_,_) in MARKS.items():
  lines += [f'        if kind == {num} then',f'            if isAbility then',f"                return '{ids[label+'Ability']}'",'            endif',f"            return '{ids[label+'Buff']}'",'        endif']
 lines+=['        return 0','    endfunction','    // END ELEMENTAL MARK OBJECTS']
 p=ROOT/'triggers/Items/Items.j';b=p.read_bytes();t=b.decode('utf-8-sig').replace('\r\n','\n');block='\n'.join(lines)
 if '// BEGIN ELEMENTAL MARK OBJECTS' in t:t=re.sub(r'    // BEGIN ELEMENTAL MARK OBJECTS.*?    // END ELEMENTAL MARK OBJECTS',lambda _:block,t,flags=re.S)
 else:t=t.replace('    private function ElemStr takes',block+'\n\n    private function ElemStr takes',1)
 # Globals used by regeneration/healing and UI are declared in the original item globals.
 if 'integer CinderFang_Buff_ID' not in t:t=t.replace("        integer CinderFang_ID = 'I065'",f"        integer CinderFang_Buff_ID = '{ids['CinderBuff']}'\n        integer CinderFang_ID = 'I065'",1)
 p.write_bytes((b'\xef\xbb\xbf' if b.startswith(b'\xef\xbb\xbf') else b'')+t.replace('\n','\r\n' if b'\r\n' in b else '\n').encode())
 print(f'{len(MARKS)} dispellable marks staged')
if __name__=='__main__':stage()
