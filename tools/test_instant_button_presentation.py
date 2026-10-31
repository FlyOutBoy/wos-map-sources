"""Regression checks for rebased command buttons, form UI, cancel keys and VFX."""
from pathlib import Path
from types import SimpleNamespace
from collections import defaultdict
import copy,json,re,unittest
import war3_object_workspace as ws
from test_crocodile import JassState
from stage_instant_foundations import ART_FIELDS,configure_presentation,configure_neutral
from build_milim_w2_effect import repair
ROOT=Path(__file__).resolve().parents[1]
def source(path):return (ROOT/'triggers'/path).read_text(encoding='utf-8-sig')
def fn(text,name):return re.search(r'\bfunction '+name+r' takes.*?endfunction',text,re.S)[0]
class NativeButtons(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  cls.docs,_=ws.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
  cls.abilities=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
  cls.native={}
  for d in cls.docs:
   if d['kind']=='abilities':
    for o in d['custom_objects']:
     cls.native.setdefault(ws.object_id(o),{}).update({(m['field']['text'],m.get('level',0)):ws.value_for_user(m) for m in o['modifications']})
 def test_every_instant_button_overrides_stock_art_sound_and_buffs(self):
  ids={k for k,v in self.abilities.items() if v['base_id'] in ('Absk','ANbr','Aroa')}|{'A0DF','A030','A0EY','A0HI'}
  for aid in ids:
   v=self.native[aid]
   for field in ART_FIELDS:self.assertEqual('',v[field,0],(aid,field))
   for field in ('acac','atac'):self.assertEqual(0,v[field,0],(aid,field))
   for rank in range(1,self.abilities[aid].get('levels',1)+1):
    for field in ('abuf','aeff'):self.assertEqual('',v[field,rank],(aid,field,rank))
 def test_canonical_buttons_do_not_collide_with_other_command_cells(self):
  expected={'A0DF':(1,2),'A0EY':(1,1),'A0EZ':(2,1),'A06U':(2,2),'A065':(1,1),'A066':(2,1),'A083':(1,2),'A090':(1,2),'A093':(0,2),'A0GP':(2,2)}
  for aid,pos in expected.items():
   for xf,yf in [('abpx','abpy'),('aubx','auby'),('arpx','arpy')]:self.assertEqual(pos,(self.native[aid][xf,0],self.native[aid][yf,0]),aid)
  self.assertEqual('Aroa',self.abilities['A06U']['base_id'])
  self.assertEqual(5,self.abilities['A06U']['levels']);self.assertEqual(6,self.abilities['A06U']['required_level'])
 def test_all_berserk_and_both_roars_have_enemy_only_zero_native_effects_on_every_rank(self):
  for doc in self.docs:
   if doc['kind']!='abilities':continue
   selected=[o for o in doc['custom_objects'] if o['old_id']['text'] in ('Absk','ANbr','Aroa')]
   self.assertEqual(54,len(selected),doc['source_file'])
   for o in selected:
    aid=ws.object_id(o);base=o['old_id']['text']
    v={(m['field']['text'],m.get('level',0),m.get('data_pointer',0)):ws.value_for_user(m) for m in o['modifications']}
    for rank in range(1,self.abilities[aid].get('levels',1)+1):
     self.assertEqual('enemies',v['atar',rank,0],(aid,rank))
     self.assertEqual(0.,v['aare',rank,0],(aid,rank))
     fields=list(enumerate(('bsk1','bsk2','bsk3'),1)) if base=='Absk' else list(enumerate(('Nbr1' if base=='ANbr' else 'Roa1','Roa2','Roa3','Roa4','Roa5','Roa6','Roa7'),1))
     for pointer,field in fields:self.assertEqual(0,v[field,rank,pointer],(aid,rank,field))
  docs=copy.deepcopy(self.docs);configure_neutral(docs,self.abilities)
  self.assertTrue(docs==self.docs,'neutral staging must be idempotent')
 def test_presentation_stage_is_idempotent_and_does_not_change_gameplay_text_or_costs(self):
  docs=copy.deepcopy(self.docs);configure_presentation(docs,self.abilities);first=copy.deepcopy(docs);configure_presentation(docs,self.abilities)
  self.assertTrue(first==docs,'presentation order must be stable')
  view,_=ws.views_from_raw(docs,ROOT/'libs/common.j')['abilities']
  for aid,old in self.abilities.items():
   for key,value in old.items():
    if 'tooltip' in key or 'mana_cost' in key or 'cooldown' in key or key in ('levels','required_level','level_skip'):
     self.assertEqual(value,view[aid][key],(aid,key))
class RuntimeButtons(unittest.TestCase):
 def test_four_stack_e_is_selected_even_when_service_auras_are_available(self):
  text=source('WOS_Start/ShowCD.j');block=text.split('elseif heroId == Inori_ID then')[1].split('elseif heroId ==',1)[0]
  vm=JassState('function Resolve takes unit whichHero returns nothing\n'+block+'\nendfunction')
  c=vm.unit();chosen=[]
  names=set(re.findall(r'\bInori\w+_ID\b',block));vm.g.update({n:n for n in names})
  vm.g.update({f'AHUI_SLOT_{s}':i for i,s in enumerate('QWERTFG')})
  vm.g.update(AHUI_AddHeroAbility=lambda *_:None,AHUI_IsActiveSlotCandidate=lambda u,p,a:a=='InoriEE_ID',AHUI_SetActiveHeroAbility=lambda *a:chosen.append(a))
  vm.run('Resolve',(c,));self.assertEqual([(c,2,'InoriEE_ID')],chosen)
 def test_inori_form_interval_and_missile_restore_together(self):
  vm=JassState(fn(source('Heroes/Inori.j'),'InoriAttackArt'));c=vm.unit();crystal=[False];intervals=[]
  vm.g.update(InoriCrystalMode=lambda _:crystal[0],BlzSetUnitAttackCooldown=lambda u,x,i:intervals.append(x),UNIT_WEAPON_SF_ATTACK_PROJECTILE_ART='art',BlzSetUnitWeaponStringField=lambda *_:None,InoriAtk_Bullet='bullet')
  for state in (False,True,False,True,False):crystal[0]=state;vm.run('InoriAttackArt',(c,))
  self.assertEqual([2.,1.8,2.,1.8,2.],intervals)
 def test_s_cancel_uses_active_state_for_all_forms_and_is_idempotent(self):
  text=source('Systems/ButtonPressed.j');block=text.split('elseif but == OSKEY_S then',1)[1].split('elseif but == OSKEY_F3',1)[0]
  vm=JassState('function Cancel takes nothing returns nothing\n'+block+'\nendfunction')
  keys=set(re.findall(r'SH_ButtonPressed_\w+',block));vm.g.update({k:k for k in keys});vm.g.update(hs={},heroHandleId=12,playerHandleId=34)
  active=['INVUL','CAST_R','TOMIOKA_F_INVUL','ZERO_KAI','YAMAMOTO_FR','W_ACTIVE']
  for key in active:vm.g['hs'][12 if key in ('INVUL','CAST_R') else 34,'SH_ButtonPressed_'+key]=1
  vm.run('Cancel');first=copy.deepcopy(vm.g['hs']);vm.run('Cancel');self.assertEqual(first,vm.g['hs'])
  for key in ('ESC','STOP_R','TOMIOKA_ESC','TSUNA_ESC','TAKESHI_ESC','KYORAKU_ESC'):
   self.assertEqual(1,vm.g['hs'][12 if key in ('ESC','STOP_R') else 34,'SH_ButtonPressed_'+key])
  pick=source('WOS_Start/WoS_Pick_Init.j')
  self.assertIn('OSKEY_S, 0, true',pick);self.assertIn('OSKEY_S, 0, false',pick)
 def test_anchor_cast_samples_terrain_without_reading_back_effect_transform(self):
  text=source('Items/Items.j');block=text.split('if id == LeviathanAnchor_Abi_ID then')[-1].split('elseif id == ThunderBastion_Abi_ID then')[0]
  vm=JassState('function AnchorCast takes unit c, real x, real y returns nothing\nlocal real a\nlocal integer fx\n'+block+'\nendfunction');c=vm.unit();carrier=SimpleNamespace(dmg2=0,e=None)
  carrier_type=SimpleNamespace(ANCHOR=4,Add=lambda *_:carrier)
  vm.g.update(ItemsElementsFx=carrier_type,LeviathanAnchor_ID='anchor',LeviathanAnchor_Damage=6.75,SacredGearBooster=lambda c,x:x,ElemStr=lambda _:100.,AnchorGround='ground',MoveLocation=lambda *_:None,GetLocationZ=lambda _:432.,BlzGetLocalSpecialEffectZ=lambda _:self.fail('same-thread transform readback'),AddSpecialEffect=lambda *a:vm.effect('anchor'),BlzSetSpecialEffectScale=lambda *_:None,BlzSetSpecialEffectPitch=lambda *_:None,BlzSetSpecialEffectPosition=lambda e,x,y,z:setattr(e,'z',z))
  vm.run('AnchorCast',(c,100.,200.));self.assertEqual(432.,carrier.dmg2);self.assertEqual(2482.,carrier.e.z)
 def test_milim_copy_removes_only_embedded_flamestrike_sound_events(self):
  config=json.loads((ROOT/'.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
  original=(Path(config['mainMap'])/'war3mapImported/wos_file00001145.mdx').read_bytes()
  silent=(ROOT/'assets/effects/war3mapImported/wos_MilimW2_Silent.mdx').read_bytes()
  self.assertEqual(repair(original),silent);self.assertEqual(repair(silent),silent)
  self.assertIn(b'SNDxAHFS',original);self.assertNotIn(b'SNDxAHFS',silent)
if __name__=='__main__':unittest.main()
