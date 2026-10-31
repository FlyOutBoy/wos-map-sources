"""Stage Inverted Spear of Heaven and Bazz-B cooldown changes through MAIN's object codec."""
from pathlib import Path
import copy,json,re
import war3_object_data as raw
import war3_object_workspace as ws
from integrate_crocodile_main_objects import allocate,clone_object,set_field
from normalize_tooltip_text import save
from repair_main_ability_levels import AbilityWorkspace,tooltip_vm,render_tooltip
ROOT=Path(__file__).resolve().parents[1]
PATH=ROOT/'object-data/inverted-spear-ids.json'
ICON='ReplaceableTextures\\CommandButtons\\BTNItem_InvertedSpear.blp'
TIP=('+15 allstats\nActive: For 9 sec, ignores 50% of the target enemy\'s physical and magic resistance. '
     'The debuff cannot be dispelled. Does not bypass shields or invulnerability.\nCast range: 800\nCooldown: 20 sec.')
NEW=(('Item','items','I06F'),('Active','abilities','A13A'),('Curse','abilities','A13B'),('Buff','buffs','B041'))

def stage():
 docs,_=ws.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
 by={d['source_file']:d for d in docs}
 used={ws.object_id(o) for d in docs for o in d['original_objects']+d['custom_objects']}
 for folder in ('triggers','test_map'):
  for p in (ROOT/folder).rglob('*'):
   if p.suffix in ('.j','.json'):
    used.update(re.findall(r"['\"]([ABI][A-Z0-9]{3})['\"]",p.read_text(encoding='utf-8-sig',errors='replace')))
 ids=json.loads(PATH.read_text()) if PATH.exists() else {}
 for label,kind,_ in NEW:
  if label not in ids:
   ids[label]=allocate({'items':'I','abilities':'A','buffs':'B'}[kind],used);used.add(ids[label])
 strings=raw.parse_wts(Path(json.loads((ROOT/'.vscode/wos-build.json').read_text())['mainMap'])/'war3map.wts')
 def idx(d):return {ws.object_id(o):o for o in d['custom_objects']}
 for label,kind,template in NEW:
  for d in docs:
   if d['kind']!=kind:continue
   entries=idx(d)
   if ids[label] not in entries:
    base=entries.get(template)
    if base is None:
     base=next(idx(x)[template] for x in docs if x['kind']==kind and template in idx(x))
    d['custom_objects'].append(clone_object(base,ids[label],{},strings))
   o=idx(d)[ids[label]]
   if kind=='abilities':o['modifications']=[m for m in o['modifications'] if m.get('level',0)<=1]
   def put(f,v,k='string',rank=0,pointer=0):set_field(o,f,v,k,rank,pointer,leveled=kind=='abilities')
   if label=='Item':
    for f,v,k in [('iabi',ids['Active']+',A00M','string'),('icid',ids['Active'],'string'),('icla','Permanent','string'),('igol',7500,'int'),('ilum',0,'int'),('ipow',0,'int'),('iusa',1,'int'),('unam','Inverted Spear of Heaven','string'),('utip','Inverted Spear of Heaven','string'),('utub',TIP,'string'),('ides',TIP,'string'),('iico',ICON,'string')]:put(f,v,k)
   elif label=='Buff':
    for f,v in [('fnam','Heaven Severed'),('ftip','Heaven Severed'),('fube','50% of physical and magic resistance is ignored for 9 sec. Cannot be dispelled.'),('fart',ICON),('ftat',''),('feat','')]:put(f,v)
   else:
    for f,v in [('alev',1),('aher',0),('aite',int(label=='Active'))]:put(f,v,'int')
    for f in ('acat','atat','asat','aeat','aaea','alig','amat','aefs','aefl'):put(f,'')
    put('anam','Item Inverted Spear of Heaven'+(' debuff' if label=='Curse' else ''))
    put('aart',ICON);put('atar','air,ground,enemies,organic,mechanical,vulnerable','string',1)
    for f,v,k in [('amcs',0,'int'),('acdn',20. if label=='Active' else 0.,'unreal'),('aran',800. if label=='Active' else 99999.,'unreal'),('aare',0.,'unreal'),('adur',0. if label=='Active' else 9.,'unreal'),('ahdu',0. if label=='Active' else 5.,'unreal')]:put(f,v,k,1)
    if label=='Active':
     for f,v,k,p in [('Ncl1',0.,'unreal',1),('Ncl2',1,'int',2),('Ncl3',1,'int',3),('Ncl4',0.,'unreal',4),('Ncl5',0,'int',5),('Ncl6','unholyfrenzy','string',6)]:put(f,v,k,1,p)
     put('atp1','Inverted Spear of Heaven','string',1);put('aub1',TIP,'string',1)
    else:put('abuf',ids['Buff'],'string',1);put('Crs1',0.,'unreal',1,1)
 # Explicit final values keep repeated staging idempotent.
 for d in docs:
  if d['kind']=='abilities':
   for aid,base in [('A08N',20.),('A08O',18.),('A08P',28.)]:
    o=idx(d).get(aid)
    if o:
     for rank in range(1,6):set_field(o,'acdn',base-(rank-1),'unreal',rank)
 fields=AbilityWorkspace(docs);vm,records=tooltip_vm()
 for aid in ('A08N','A08O','A08P'):
  data=copy.copy(next(x for x in records if x.identity==aid and x.form==0))
  desc=vm.run('LoreOnly',(vm.run('NormalizeDesc',(fields.get(aid,'aub1',1,''),)),))
  for d in docs:
   if d['kind']!='abilities' or aid not in idx(d):continue
   o=idx(d)[aid];set_field(o,'arut',render_tooltip(vm,data,desc,fields),'string',0)
   for rank in range(1,6):set_field(o,'aub1',desc+'|n|n|cffffcc00Ability Stats:|r|n'+render_tooltip(vm,data,'',fields,rank),'string',rank)
 for d in docs:
  if d['kind'] in ('abilities','items','buffs'):
   raw.encode_object_file(d,d['source_file']);save(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[d['source_file']],d)
 for kind,(view,meta) in ws.views_from_raw(docs,ROOT/'libs/common.j').items():
  if kind in ('abilities','items','buffs'):save(ROOT/'object-data'/ws.CATEGORY_FILES[kind],view);save(ROOT/'.object-data-raw/workspace-meta'/ws.CATEGORY_FILES[kind],meta)
 save(PATH,ids);print(ids)
if __name__=='__main__':stage()
