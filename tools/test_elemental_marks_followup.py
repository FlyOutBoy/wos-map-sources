"""Execute dispel-driven item reactions, timed rounds and order-preserving metadata contracts."""
from collections import defaultdict
from pathlib import Path
from types import SimpleNamespace
import copy,json,re,unittest
from test_crocodile import JassState
from stage_instant_foundations import BASES, ITEMS, configure
from normalize_tooltip_text import normalize
import war3_object_workspace as objects
ROOT=Path(__file__).resolve().parents[1]
def source(p):return (ROOT/'triggers'/p).read_text(encoding='utf-8-sig')
def function(text,name):return re.search(r'(?m)^\s*(?:(?:private|public) )?function '+name+r' takes.*?endfunction',text,re.S)[0]
def numeric_literals(text):return re.sub(r"'([A-Z][A-Za-z0-9]{3})'",lambda m:str(int.from_bytes(m[1].encode(),'big')),text)

class ElementalMarks(unittest.TestCase):
 def setUp(self):
  text=source('Items/Items.j');self.vm=JassState(numeric_literals(function(text,'ItemsElements_OnDamage')))
  self.c,self.u,self.other=self.vm.unit(0,0,0),self.vm.unit(100,0,1),self.vm.unit(400,0,1)
  self.other.illusion=True
  self.marks={};self.hits=[];self.missiles=[];self.now=10.
  kinds=dict(EMBER=20,VERDICT=21,BASTION=22,CINDER=23,MIRROR=24,VOLT=25)
  def find(kind,c,u):return next((f for (k,_,_),f in self.marks.items() if k==kind and (c is None or f.c is c) and (u is None or f.u is u) and f.left>0),0)
  self.vm.g.update(ItemsElementsFx=SimpleNamespace(count=1,Find=find,Missile=lambda *a:self.missiles.append(a),**kinds),
    ItemsElements_Group=[],NoDecor_Cond=None,MirrorTide_Aoe=600.,MirrorTide_ProjectileModel='wave',
    TimerGetElapsed=lambda _:self.now,HealRegenClock='clock',DamageSourceBase=lambda x:x,ItemDamageCanProc=lambda x:x>=0,
    ElemValid=lambda c,u:u.owner!=c.owner and u.life>0,IsUnitAlly=lambda u,p:u.owner==p,
    ElemHit=lambda *a:self.hits.append(a),SpellBool=lambda u:u.life>0,
    Emberbreaker_ID=1,ThunderBastion_ID=2,CinderFang_ID=3,MirrorTide_ID=4,VoltThread_ID=5)
 def mark(self,kind):
  fx=SimpleNamespace(c=self.c,u=self.u,left=3.,charges=3,step=0.,phase=0,dmg2=150.,present=True,g=[])
  fx.HasMark=lambda:fx.left>0 and fx.present
  self.marks[kind,id(self.c),id(self.u)]=fx;return fx
 def hit(self,attack=False,source=100000,damage=101.):self.vm.run('ItemsElements_OnDamage',(self.c,self.u,damage,attack,source))
 def test_mirror_reflects_hero_spell_damage_to_clone_and_has_one_second_gate(self):
  f=self.mark(24);self.hit(False)
  self.assertEqual(self.other,self.missiles[0][4]);self.assertEqual(2,f.charges)
  self.hit(True);self.assertEqual(1,len(self.missiles))
  self.now+=1.;self.hit(False);self.assertEqual(2,len(self.missiles))
  self.assertEqual(1,f.charges)
 def test_mirror_threshold_and_damage_owner_are_independent(self):
  f=self.mark(24)
  self.hit(damage=100.);self.assertFalse(self.missiles)
  attacker=self.vm.unit(owner=2)
  self.vm.run('ItemsElements_OnDamage',(attacker,self.u,101.,False,-101))
  self.assertEqual(self.c,self.missiles[0][1]);self.assertEqual(2,f.charges)
 def test_mirror_accepts_self_damage_above_threshold(self):
  f=self.mark(24)
  self.vm.run('ItemsElements_OnDamage',(self.u,self.u,101.,False,-101))
  self.assertEqual(1,len(self.missiles));self.assertEqual(self.c,self.missiles[0][1])
 def test_removed_marks_cannot_proc_before_periodic_cleanup(self):
  for kind in (23,24,25):
   with self.subTest(kind=kind):
    self.marks.clear();f=self.mark(kind);f.present=False;self.hit(True)
    self.assertEqual([],self.hits);self.assertEqual([],self.missiles)
 def test_cinder_bonus_works_on_hero_ability_once_and_retains_the_regen_seal(self):
  f=self.mark(23);f.charges=1
  self.hit(False);self.hit(True)
  self.assertEqual(1,len(self.hits));self.assertEqual(150.,self.hits[0][3])
  self.assertEqual(3.,f.left);self.assertTrue(f.present)
 def test_item_and_periodic_followups_feed_only_mirror_above_threshold(self):
  self.mark(23);self.mark(24)
  for sid in (-101,-111,int.from_bytes(b'I067','big')):self.hit(False,sid)
  self.assertEqual([],self.hits);self.assertEqual(1,len(self.missiles))
 def test_cinder_cancels_native_regen_and_restores_offsets_after_dispel(self):
  text=source('Items/Items.j')
  def method(name):
   body=re.search(r'(?m)^\s*method '+name+r' takes.*?endmethod',text,re.S)[0]
   return re.sub(r'(?<![\w])\.([A-Za-z]\w*)',r'this.\1',body)
  vm=JassState(method('update')+'\n'+method('finish'))
  c,u=vm.unit(owner=0),vm.unit(owner=1);native={'hp':5.,'mp':2.}
  fx=SimpleNamespace(c=c,u=u,left=3.,kind=23,buffId='cinder',buffWait=.12,hpOffset=0.,mpOffset=0.,next=0.,e=None,e2=None,e3=None,trail1=None,trail2=None,trail3=None,ln=None,g=None,g2=None,destroy=lambda:None)
  vm.add_ability(u,'cinder')
  vm.g.update(DT=.03,PROJ=1,MOVE=2,DOT=3,ANCHOR=4,STORM=5,RUNE=6,SPIRAL=7,ASHEN=8,WAVE=9,STRIKES=10,COILSHOT=11,SEALCAST=12,CINDER=23,VERDICT=21,VOLT=25,COIL=28,SIREN=27,
    UNIT_RF_HIT_POINTS_REGENERATION_RATE='hp',UNIT_RF_MANA_REGENERATION='mp',count=0,
    BlzGetUnitRealField=lambda u,f:native[f],BlzSetUnitRealField=lambda u,f,x:native.update({f:x}),
    GetHpRegenBase=lambda u:native['hp']+1.5,GetMpRegenNative=lambda u:native['mp']+15.,ElemAlive=lambda u:u.life>0)
  self.assertFalse(vm.run('update',obj=fx));self.assertEqual((-1.5,-15.),(native['hp'],native['mp']))
  self.assertEqual((6.5,17.),(fx.hpOffset,fx.mpOffset))
  native['hp']+=3.;fx.next=0.;vm.run('update',obj=fx)
  self.assertEqual(9.5,fx.hpOffset)
  vm.remove_ability(u,'cinder');fx.buffWait=0.
  self.assertTrue(vm.run('update',obj=fx));vm.run('finish',obj=fx)
  self.assertEqual((8.,2.),(native['hp'],native['mp']))
 def test_native_buff_ids_have_item_icons_and_timed_dispellable_delivery(self):
  ids=json.loads((ROOT/'object-data/elemental-marks-ids.json').read_text())
  a=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
  docs,_=objects.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
  mods={objects.object_id(o):{(m['field']['text'],m.get('level',0)):objects.value_for_user(m) for m in o['modifications']} for d in docs if d['source_file']=='war3map.w3a' for o in d['custom_objects']}
  b=json.loads((ROOT/'object-data/buffs.json').read_text(encoding='utf-8-sig'))
  for label in ('Ember','Verdict','Bastion','Cinder','Mirror','Volt','Phoenix','Siren','Coil','EmberBurn','PhoenixBurn'):
   with self.subTest(label=label):
    delivery=a[ids[label+'Ability']];buff=b[ids[label+'Buff']]
    self.assertEqual('Ainf' if label=='Bastion' else 'Acrs',delivery['base_id'])
    self.assertEqual(0,delivery['mana_cost level 1'])
    self.assertEqual(5.5,mods[ids[label+'Ability']]['ahdu',11])
    self.assertIn('BTNItem_',buff['icon'])
    self.assertIn('Dispelling',buff['extended_tooltip'])

class PresentationAndMetadata(unittest.TestCase):
 def test_zero_terms_percent_and_decimal_values(self):
  for before,after in [('Heal: Intelligence x 1 + 0 per sec','Heal: Intelligence x 1 per sec'),('Damage: 1 + 0.5','Damage: 1 + 0.5'),('Value: 0/1/2','Value: 0/1/2'),('16 percentage points','16%'),('25 percent','25%'),('Restores a percentage of MP','Restores a percentage of MP'),('Range: 0|nRadius: 450','Radius: 450')]:self.assertEqual(after,normalize(before))
  text=source('WOS_Start/TooltipBuilder.j');vm=JassState(text)
  vm.g.update(StringLength=len,SubString=lambda s,a,b:s[a:b])
  for before,after in [('Heal x 1 + 0 per sec','Heal x 1 per sec'),('Damage + 0.5','Damage + 0.5'),('16 percentage points','16%'),('Restores a percentage of MP','Restores a percentage of MP')]:self.assertEqual(after,vm.run('TooltipCleanText',(before,)))
 def test_instant_rebase_retains_unlock_progression_and_distinct_coexisting_orders(self):
  a=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
  # Fixed unlock/cost progressions are covered below independently of the migration snapshot.
  self.assertEqual([75,85,95,105,115],[a['A0DF'][f'mana_cost level {r}'] for r in range(1,6)])
  self.assertEqual(5,a['A0DF']['levels'])
  self.assertEqual(4,a['A0DF']['level_skip'])
  self.assertEqual(6,a['A0GP']['required_level'])
  self.assertEqual(4,a['A0GP']['level_skip'])
  docs,_=objects.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
  native={objects.object_id(o):{(m['field']['text'],m.get('level',0)):objects.value_for_user(m) for m in o['modifications']} for d in docs if d['source_file']=='war3map.w3a' for o in d['custom_objects']}
  for aid,base in BASES.items():
   self.assertEqual(base,a[aid]['base_id'],aid)
   self.assertEqual(1,native[aid]['aite' if aid in ITEMS else 'aher',0])
  # Known coexisting slots use different native order families.
  for group in [('A065','A066','A06E'),('A0GP','A0GU'),('A093','A090'),('A0A3','A0AH','A0AI')]:
   self.assertEqual(len(group),len({a[k]['base_id'] for k in group}))
 def test_rebase_is_idempotent(self):
  docs,_=objects.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
  a=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
  configure(docs,a);first=copy.deepcopy(docs);configure(docs,a);self.assertEqual(first,docs)
 def test_quincy_recipe_reaches_maximum_pakkun(self):
  text=source('WOS_Start/WoS_Shop_Init.j')
  self.assertIn('RegisterCraft(\'I023\', "I037")',text)
  for dst,prev in [('I037','I036'),('I036','I035')]:self.assertIn(f'RegisterCraft(\'{dst}\', "{prev}")',text)

class BasePhase(unittest.TestCase):
 def setUp(self):
  text=source('Systems/EnterRegion.j')
  self.vm=JassState('\n'.join(function(text,n) for n in ('ArenaWalkEligible','BasePhaseEligible','BasePhaseApply','BasePhaseLeave','HeroUnstuck_Tick')))
  self.u=self.vm.unit();self.selected=True;self.hidden=False;self.inside=True;self.kind=None;self.calls=[];self.owned={}
  g=self.vm.g
  g.update(UnitAddAbility=lambda u,a:self.vm.add_ability(u,a) or True,BASE_PHASE_ABILITY='Aeth',BasePhaseOwnedKey='phase',hs=self.owned,
   BlzIsUnitSelectable=lambda _:self.selected,IsUnitHidden=lambda _:self.hidden,
   UNIT_TYPE_STRUCTURE='structure',UNIT_TYPE_FLYING='flying',IsUnitType=lambda u,t:t==self.kind,
   gg_rct_Arena='arena',gg_rct_Base='base',CheckCoordsInRect=lambda *a:self.inside,
   UnitMakeAbilityPermanent=lambda *a:self.calls.append(('permanent',)),
   SaveBoolean=lambda h,u,k,v:h.update({(u,k):v}),LoadBoolean=lambda h,u,k:h.get((u,k),False),
   RemoveSavedBoolean=lambda h,u,k:h.pop((u,k),None),GetTriggerUnit=lambda:self.u)
 def test_eligibility_excludes_off_arena_hidden_unselectable_structures_flyers_and_locust(self):
  self.assertTrue(self.vm.run('BasePhaseEligible',(self.u,)))
  for attr,value in [('selected',False),('hidden',True),('inside',False),('kind','structure'),('kind','flying')]:
   before=getattr(self,attr);setattr(self,attr,value)
   self.assertFalse(self.vm.run('BasePhaseEligible',(self.u,)))
   setattr(self,attr,before)
  self.vm.add_ability(self.u,'Aloc');self.assertFalse(self.vm.run('BasePhaseEligible',(self.u,)))
 def test_phase_has_no_orders_no_pathing_toggle_and_removes_copied_ability(self):
  for n in ('SetUnitPathing','IssueImmediateOrder','IssuePointOrder','SetUnitMoveSpeed','SetUnitVertexColor'):
   self.vm.g[n]=lambda *a,n=n:self.fail(n)
  self.vm.run('BasePhaseApply',(self.u,));self.vm.run('BasePhaseApply',(self.u,))
  self.assertEqual(1,self.vm.g['GetUnitAbilityLevel'](self.u,'Aeth'));self.assertEqual([('permanent',)],self.calls)
  self.vm.run('BasePhaseLeave');self.assertEqual(0,self.vm.g['GetUnitAbilityLevel'](self.u,'Aeth'))
  self.vm.add_ability(self.u,'Aeth');self.calls.clear()
  self.vm.run('BasePhaseApply',(self.u,));self.vm.run('BasePhaseLeave')
  self.assertEqual(0,self.vm.g['GetUnitAbilityLevel'](self.u,'Aeth'));self.assertEqual([],self.calls)

 def test_phase_applies_only_in_base_not_in_arena(self):
  self.vm.g['CheckCoordsInRect']=lambda rect,x,y:rect=='arena'
  self.assertTrue(self.vm.run('ArenaWalkEligible',(self.u,)))
  self.assertFalse(self.vm.run('BasePhaseEligible',(self.u,)))
  self.vm.run('BasePhaseApply',(self.u,))
  self.assertEqual(0,self.vm.g['GetUnitAbilityLevel'](self.u,'Aeth'))
  self.assertEqual([],self.calls)
 def test_tick_reuses_group_for_base_phase_and_arena_unstuck(self):
  other=self.vm.unit();units=[self.u,other];queue=[];probed=[]
  g=self.vm.g
  g.update(ArenaWalkScan=queue,
   GroupEnumUnitsInRect=lambda group,rect,f:group.extend([self.u] if rect=='base' else units),
   FirstOfGroup=lambda group:group[0] if group else None,
   GroupRemoveUnit=lambda group,u:group.remove(u),
   ArenaWalkEligible=lambda u:u is self.u,
   BasePhaseApply=lambda u:self.calls.append(u),HeroUnstuck_Unit=lambda u:probed.append(u))
  self.vm.add_ability(self.u,'Aeth')
  self.vm.run('HeroUnstuck_Tick')
  self.assertEqual(0,self.vm.g['GetUnitAbilityLevel'](self.u,'Aeth'))
  self.assertEqual([self.u],probed);self.assertEqual([self.u],self.calls);self.assertEqual([],queue)

class OrdersAndUnstuck(unittest.TestCase):
 def test_scripted_instant_windup_preserves_orders_and_invulnerability_pair(self):
  text=source('Systems/Systems2.j')
  vm=JassState(function(text,'StartSpellUnitQueued')+'\n'+function(text,'StopSpellUnitQueued'))
  u=vm.unit(owner=0);pauses=[]
  vm.g.update(GearPauseSpellStart=lambda u,e:pauses.append(True),GearStopSpellPause=lambda u,e:pauses.append(False),PauseUnit=lambda u,p:pauses.append(p),SetUnitTimeScale=lambda *_:None,
    IssueImmediateOrder=lambda *_:self.fail('queued cast must not issue stop'),hs={},SH_AHK_PIDOR='cast lock',ahk_delay=.1,
    MyFlush=lambda *_:None,GearSelectOnlyHero=lambda *_:None)
  vm.run('StartSpellUnitQueued',(u,True));self.assertGreater(vm.g['GetUnitAbilityLevel'](u,'Avul'),0)
  vm.run('StopSpellUnitQueued',(u,True));self.assertEqual(0,vm.g['GetUnitAbilityLevel'](u,'Avul'))
  self.assertEqual([True,False],pauses)
 def test_unstuck_only_moves_embedded_ground_heroes_to_a_clear_point(self):
  vm=JassState(function(source('Systems/EnterRegion.j'),'HeroUnstuck_Unit'))
  u=vm.unit();u.fly_height=0.;u.paused=False
  vm.g.update(ArenaWalkEligible=lambda _:True,IsUnitHidden=lambda _:False,IsUnitPaused=lambda u:u.paused,GetUnitFlyHeight=lambda u:u.fly_height,
    UNIT_TYPE_FLYING='flying',IsUnitType=lambda *_:False,hs={},HeroUnstuckCastKey='cast',TestMode=False,
    HeroUnstuck_Point=lambda x,y:x>=100.,HeroUnstuck_Free=lambda x,y:x>=100.,
    IssuePointOrder=lambda *_:self.fail('unstuck must not replace orders'),IssueImmediateOrder=lambda *_:self.fail('unstuck must not replace orders'))
  vm.run('HeroUnstuck_Unit',(u,));self.assertEqual((128.,0.),(u.x,u.y))
  for paused,height in [(False,0.),(True,0.),(False,80.)]:
   u.x=150. if not paused and height==0 else 0.;u.y=0.;u.paused=paused;u.fly_height=height;before=(u.x,u.y)
   vm.run('HeroUnstuck_Unit',(u,));self.assertEqual(before,(u.x,u.y))

class TestRound(unittest.TestCase):
 def test_primary_death_allows_three_full_seconds_but_ally_cannot_hold_round(self):
  vm=JassState(function(source('WOS_Start/WoS_Pick_Init.j'),'TestUnit_PrimaryDefeated'))
  main,ally=vm.unit(owner=0),vm.unit(owner=1)
  main.life=0;main.dead=True
  vm.g.update(Hero=defaultdict(lambda:None,{0:main,1:ally}),TestPrimaryDeadTicks=defaultdict(int),TestUnit=None,TestAllyUnit=ally,
    IsActivePlayerSlot=lambda p:p==0,GetPlayerController=lambda p:'human',MAP_CONTROL_USER='human',Player=lambda p:p,Leave=defaultdict(int),
    UNIT_TYPE_DEAD='dead',IsUnitType=lambda u,t:getattr(u,'dead',False))
  self.assertEqual([False,False,False,True],[vm.run('TestUnit_PrimaryDefeated') for _ in range(4)])
  main.life=100;main.dead=False;self.assertFalse(vm.run('TestUnit_PrimaryDefeated'))
  main.life=0;main.dead=True;self.assertFalse(vm.run('TestUnit_PrimaryDefeated'))

class TestRepickRound(unittest.TestCase):
 def setup_vm(self):
  text=source('WOS_Start/WoS_Pick_Init.j')
  vm=JassState(function(text,'TestUnit_PrimaryDefeated')+'\n'+function(text,'TestUnit_EndRoundForRepick'))
  main,enemy=vm.unit(owner=0),vm.unit(owner=1)
  vm.g.update(TestMode=True,CondArena=1,END1=0,TestRepickRoundEndPending=False,IntroStart1='round clock',TestRepickRoundEndAction='round tick',Hero=defaultdict(lambda:None,{0:main,1:enemy}),
   TestUnit=enemy,TestAllyUnit=None,TestPrimaryDeadTicks=defaultdict(int),IsActivePlayerSlot=lambda p:p==0,
   GetPlayerController=lambda p:'human',MAP_CONTROL_USER='human',Player=lambda p:p,Leave=defaultdict(int),
   UNIT_TYPE_DEAD='dead',IsUnitType=lambda u,t:u.life<=0)
  return vm,main,enemy
 def test_missing_primary_ends_test_round_without_death_grace(self):
  vm,main,enemy=self.setup_vm();vm.g['Hero'][0]=None
  self.assertTrue(vm.run('TestUnit_PrimaryDefeated'));self.assertEqual(4,vm.g['TestPrimaryDeadTicks'][0])
  vm.g['Hero'][0]=main;self.assertFalse(vm.run('TestUnit_PrimaryDefeated'))
 def test_removed_primary_handle_also_cannot_hold_round(self):
  vm,main,enemy=self.setup_vm();main.type=0
  self.assertTrue(vm.run('TestUnit_PrimaryDefeated'))
 def test_replace_branch_invokes_normal_round_cleanup_before_picker_ui(self):
  vm,main,enemy=self.setup_vm();text=source('WOS_Start/WoS_Pick_Init.j')
  body=text.split('// TestMode: return player to pick screen',1)[1].split('if GetLocalPlayer() == Player(pid) then',1)[0]
  body='function Replace takes integer pid returns nothing\n'+body+'\nendfunction'
  # Keep the real branch, including RemoveUnit and the immediate round-end hook.
  fresh=JassState(function(text,'TestUnit_EndRoundForRepick')+'\n'+body)
  fresh.g.update(vm.g);fresh.g['TestUnit_EndRoundForRepick']=lambda:fresh.run('TestUnit_EndRoundForRepick')
  seen=[]
  def finish(clock,delay,repeat,callback):
   self.assertEqual(('round clock',0.,False,'round tick'),(clock,delay,repeat,callback));self.assertIsNone(fresh.g['Hero'][0]);self.assertTrue(fresh.g['TestRepickRoundEndPending'])
   enemy.x,enemy.y=0.,0.;fresh.g['CondArena']=0;seen.append(callback)
  fresh.g.update(TimerStart=finish,Erza_ID='other hero',WUI_ReleaseHeroMeters=lambda _:None,
    RemoveUnit=lambda u:setattr(u,'type',0),level_id=defaultdict(int))
  fresh.run('Replace',(0,));self.assertEqual(['round tick'],seen);self.assertEqual(0,fresh.g['CondArena'])
  round_source=function(text,'PrepareStart')
  self.assertIn('TestRepickRoundEndPending or TestUnit_PrimaryDefeated()',round_source)
 def test_zero_delay_round_tick_restores_normal_periodic_timer(self):
  text=function(source('WOS_Start/WoS_Pick_Init.j'),'PrepareStart')
  body=text.split('    if TestRepickRoundEndPending then',1)[1].split('    call PickChat_Sync',1)[0]
  vm=JassState('function Resume takes nothing returns nothing\nif TestRepickRoundEndPending then\n'+body+'\nendfunction')
  calls=[];callback=lambda:None
  vm.g.update(TestRepickRoundEndPending=True,IntroStart1='round clock',PrepareStart=callback,TimerStart=lambda *a:calls.append(a))
  vm.run('Resume');self.assertEqual([('round clock',1.,True,callback)],calls)
  calls.clear();vm.g['TestRepickRoundEndPending']=False;vm.run('Resume');self.assertFalse(calls)
 def test_repick_hook_ignores_normal_matches_and_prep(self):
  vm,_,_=self.setup_vm();calls=[];vm.g['TimerStart']=lambda *args:calls.append(args)
  for test_mode,arena,end in [(False,1,0),(True,0,0),(True,1,1)]:
   vm.g.update(TestMode=test_mode,CondArena=arena,END1=end);vm.run('TestUnit_EndRoundForRepick')
  self.assertFalse(calls);self.assertFalse(vm.g['TestRepickRoundEndPending'])

if __name__=='__main__':unittest.main()
