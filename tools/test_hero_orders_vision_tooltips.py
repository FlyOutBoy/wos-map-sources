"""Execute item vision and audit every registered hero order/tooltip definition."""
from pathlib import Path
from collections import Counter
import copy,json,re,unittest
import war3_object_workspace as ws
from hero_ability_orders import audit,inventory,EXCLUSIVE_PAIRS
from stage_instant_foundations import ORDER_BASES,CHANNEL_ORDERS,configure_order_bases
from integrate_crocodile_main_objects import code,set_field
from repair_main_ability_levels import tooltip_vm
from stage_hero_tooltip_properties import normalize
from test_crocodile import JassState
from test_tooltip_startup_performance import builder_vm

ROOT=Path(__file__).resolve().parents[1]
def read(path):return (ROOT/path).read_text(encoding='utf-8-sig')
def function(text,name):return re.search(r'(?m)^\s*(?:private |public )?function '+name+r' takes.*?endfunction',text,re.S)[0]
def plain(text):return re.sub(r'\|c[0-9a-fA-F]{8}|\|[rR]','',text)

class HeroOrders(unittest.TestCase):
 def test_every_registered_hero_command_order_has_been_reviewed(self):
  result=audit();self.assertEqual([],result['errors']);self.assertEqual((34,397,354,43),(result['heroes'],result['buttons'],result['active'],result['service']))
  self.assertEqual(1,len(result['exclusive']))
 def test_repaired_orders_apply_at_every_rank_and_keep_instant_foundations(self):
  a=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
  for aid,base in ORDER_BASES.items():self.assertEqual(base,a[aid]['base_id'],aid)
  self.assertNotEqual(a['A08X']['base_id'],a['A093']['base_id'])
  for aid,order in CHANNEL_ORDERS.items():
   for rank in range(1,a[aid].get('levels',1)+1):self.assertEqual(order,a[aid][f'base_order_id level {rank}'],(aid,rank))
 def test_erza_retained_same_slot_forms_cannot_share_orders(self):
  a=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
  self.assertNotEqual(a['A02W']['base_order_id level 1'],a['A03O']['base_order_id level 1'])
  a['A03O']['base_order_id level 1']=a['A02W']['base_order_id level 1']
  self.assertTrue(any(e[0]=='Erza_ID' and 'A03O' in str(e) for e in audit(a)['errors']))
 def test_erza_audit_covers_every_form_command_in_sources(self):
  commands={aid for p in (ROOT/'triggers/Heroes/Erza').glob('*.j')
   for name,aid in re.findall(r"integer\s+(Erza(?:[1-7])?[QWERTFG](?:2)?_ID)\s*=\s*'(.{4})'",p.read_text(encoding='utf-8-sig'))}
  self.assertEqual(commands,set(inventory()['Erza_ID']))
 def test_grail_native_speed_and_frostnova_base_speed_match_balance(self):
  a=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
  items=json.loads((ROOT/'object-data/items.json').read_text(encoding='utf-8-sig'))
  docs,_=ws.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
  for aid,iid,speed in [('A09X','I021',.10),('A0CY','I02B',.15)]:
   values=[ws.value_for_user(m) for d in docs if d['kind']=='abilities'
    for o in d['custom_objects'] if ws.object_id(o)==aid for m in o['modifications']
    if m['field']['text']=='Uau1' and m['level']==1]
   self.assertTrue(values);self.assertTrue(all(abs(v-speed)<1e-6 for v in values))
   self.assertIn(f'{speed*100:g}% movement speed',items[iid]['extended_tooltip'])
  units=json.loads((ROOT/'object-data/units.json').read_text(encoding='utf-8-sig'))
  self.assertEqual(290,units['H002']['movement_speed'])
  from stage_erza_grail_followup import apply
  apply(docs);first=copy.deepcopy(docs);apply(docs);self.assertEqual(first,docs)
 def test_inori_exception_is_backed_by_removal_before_cancel_is_added(self):
  self.assertEqual({frozenset(('A06U','A06E'))},set(EXCLUSIVE_PAIRS))
  text=read('triggers/Heroes/Inori.j');start=text.index('if r == 1.32 then')
  block=text[start:text.index('call UnitAddAbility(c, InoriT3_ID)',start)]
  self.assertIn('call UnitRemoveAbility(c, InoriEE_ID)',block)
  cancel=text.index('call SetPlayerAbilityAvailable(Player(k2), InoriT3_ID, false)')
  self.assertLess(cancel,text.index('call SaveInteger(hs, GetHandleId(c), SH_MODE_T, 0)',cancel))
  ready=text.split('elseif check >= 4',1)[1].split('call UnitAddAbility(c, InoriEE_ID)',1)[0]
  self.assertIn('LoadInteger(hs, GetHandleId(c), SH_MODE_T) == 0',ready)
 def test_audit_detects_cross_slot_native_conflict_and_mixed_rank_channel_orders(self):
  a=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
  a['A093']['base_id']='Absk';a['A0FS']['base_order_id level 2']='creepthunderbolt'
  errors=audit(a)['errors'];self.assertTrue(any('Takeshi_ID' in e for e in errors));self.assertTrue(any('A0FS' in e for e in errors))
 def test_order_rebase_preserves_inherited_native_cooldown_mana_and_flags(self):
  obj=dict(old_id=code('Absk'),new_id=code('A093'),modifications=[])
  set_field(obj,'amcs',75,'int',1)
  docs=[dict(kind='abilities',custom_objects=[obj]),dict(kind='abilities',custom_objects=[copy.deepcopy(obj)])]
  configure_order_bases(docs)
  for d in docs:
   o=d['custom_objects'][0];v={(m['field']['text'],m['level']):m['data']['value'] for m in o['modifications']}
   self.assertEqual('Aroa',o['old_id']['text']);self.assertEqual(30.,v['acdn',1]);self.assertEqual(75,v['amcs',1])
   self.assertNotIn(('aher',0),v,'both native foundations are non-hero by default')
  first=copy.deepcopy(docs);configure_order_bases(docs);self.assertEqual(first,docs)

class ItemVision(unittest.TestCase):
 def setUp(self):
  text=read('triggers/Systems/CastAItems.j');self.vm=JassState(function(text,'ItemActiveVision'));self.c=self.vm.unit(owner=2,x=120.,y=230.)
  self.area=0.;self.kind=0;self.rank=1;self.calls=[]
  self.vm.g.update(ABILITY_RLF_AREA_OF_EFFECT='area',ABILITY_ILF_TARGET_TYPE='target',
   BlzGetAbilityRealLevelField=lambda a,f,l:self.area,BlzGetAbilityIntegerLevelField=lambda *args:self.kind,
   GetSpellAbilityId=lambda:123,GetUnitAbilityLevel=lambda *args:self.rank,IMaxBJ=max,RMaxBJ=max,
   VisionTimed=lambda *args:self.calls.append(args))
 def test_instant_reveals_caster_instead_of_world_origin(self):
  self.vm.run('ItemActiveVision',(self.c,None,0.,0.,'ability'));self.assertEqual([(2,120.,230.,750.,2.)],self.calls)
 def test_target_uses_live_unit_position_and_large_area_is_kept(self):
  target=self.vm.unit(x=880.,y=990.);self.area=1250.
  self.vm.run('ItemActiveVision',(self.c,target,11.,22.,'ability'));self.assertEqual([(2,880.,990.,1875.,2.)],self.calls)
 def test_point_and_actual_world_origin_are_valid_cast_centres(self):
  self.kind=2
  for x,y in ((900.,1000.),(0.,0.)):self.vm.run('ItemActiveVision',(self.c,None,x,y,'ability'))
  self.assertEqual([(2,900.,1000.,750.,2.),(2,0.,0.,750.,2.)],self.calls)
 def test_common_gate_runs_before_both_item_dispatchers_and_ignores_hero_casts(self):
  text=read('triggers/Systems/CastAItems.j');prefix=text.split('function ItemsCast takes',1)[1].split('set SacredGearBooster_CastAbil',1)[0]
  prefix='function Gate takes'+prefix+'endfunction';vm=JassState(prefix);calls=[]
  vm.g.update(GetPlayerId=lambda p:p,GAngle2=lambda *a:0.,GetSpellAbility=lambda:'ability',ABILITY_BF_ITEM_ABILITY='item',
   DecorRemove=lambda *a:None,ItemActive_DecorDamage=50.,ItemActiveVision=lambda *a:calls.append(a))
  vm.g['BlzGetAbilityBooleanField']=lambda *a:False;vm.run('Gate',(self.c,None,0.,0.,123));self.assertFalse(calls)
  vm.g['BlzGetAbilityBooleanField']=lambda *a:True;vm.run('Gate',(self.c,None,0.,0.,123));self.assertEqual(1,len(calls))
  block=text.split('function ItemsCast takes',1)[1]
  self.assertLess(block.index('call ItemActiveVision'),block.index('call ItemsAnime_Cast'))
  self.assertLess(block.index('call ItemActiveVision'),block.index('call ItemsElements_Cast'))
 def test_every_active_item_primary_ability_reaches_the_native_item_gate(self):
  docs,_=ws.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw');flags={}
  for doc in docs:
   if doc['kind']!='abilities':continue
   for obj in doc['custom_objects']:
    for mod in obj['modifications']:
     if mod['field']['text']=='aite':flags[ws.object_id(obj)]=ws.value_for_user(mod)
  items=json.loads((ROOT/'object-data/items.json').read_text(encoding='utf-8-sig'))
  active={iid:v for iid,v in items.items() if v.get('actively_used')};self.assertEqual(61,len(active))
  for iid,v in active.items():self.assertEqual(1,flags[v['abilities'].split(',')[0]],iid)

class HeroProperties(unittest.TestCase):
 @classmethod
 def setUpClass(cls):cls.vm,cls.records=tooltip_vm()
 def test_every_mechanic_property_is_colored_and_labels_are_not_duplicated(self):
  self.assertEqual(440,len(self.records))
  for data in self.records:
   text=self.vm.run('TooltipGoldMechanics',(data.mechanics,));labels=[]
   for line in text.split('|n'):
    match=re.match(r'^([\w ./%()+-]+):',plain(line))
    if match and len(match[1])<=40:
     self.assertTrue(line.startswith('|c'),(data.identity,data.form,line));labels.append(match[1].lower())
   self.assertFalse([k for k,v in Counter(labels).items() if v>1],(data.identity,data.form,labels))
 def test_range_is_emitted_once_in_gold_for_all_six_repaired_skills(self):
  ids={'A00E','A03G','A05Z','A0F1','A0GK','A0I7'}
  vm,_,_,fac=builder_vm()
  for data in self.records:
   if data.identity not in ids:continue
   builder=fac.create();builder.addRange('800 (1250)');builder.addMechanic(data.mechanics)
   text=builder.get();self.assertEqual(1,sum(line.startswith('Range:') for line in plain(text).split('|n')),(data.identity,data.form))
   self.assertIn('|cffffcc00Range:|r 800 (1250)',text)
 def test_phase_notice_keeps_both_original_durations_in_one_iframe_line(self):
  vm=self.vm
  text=vm.run('T_CastDurationAuto',(1.5,True,1.8,True))
  self.assertEqual(1,text.count('Iframe:'));self.assertIn('1.50 sec (cast), 1.80 sec (active)',text)
 def test_native_fallbacks_have_no_duplicate_range_and_normalization_is_idempotent(self):
  a=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
  for slots in inventory().values():
   for aid in slots:
    for key,text in a[aid].items():
     if 'extended_tooltip' not in key or not isinstance(text,str):continue
     self.assertEqual(text,normalize(text),(aid,key))
     labels=[line.strip().lower().split(':',1)[0] for line in plain(text).split('|n') if re.match(r'^Range:',line.strip(),re.I)]
     self.assertLessEqual(len(labels),1,(aid,key))
 def test_frostnova_winter_bonus_is_kept_in_native_help_but_not_captured_lore(self):
  a=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))['A119']
  for key,text in a.items():
   if 'extended_tooltip' in key:
    self.assertIn("[Winter's Scar]",text)
    self.assertNotIn("[Winter's Scar]",self.vm.run('LoreOnly',(text,)))
 def test_native_property_coloring_preserves_a_colon_inside_lore(self):
  text='Raiden unleashes Musou Isshin: changes attack type.|nDuration: 20 sec'
  self.assertEqual('Raiden unleashes Musou Isshin: changes attack type.|n|cffffcc00Duration:|r 20 sec',normalize(text))

if __name__=='__main__':unittest.main()
