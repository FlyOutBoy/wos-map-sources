"""Release power, periodic hit limits, carrier-local mana and form cooldowns."""
from pathlib import Path
import json,re,unittest,math
from test_crocodile import JassState
import war3_object_workspace as ws
ROOT=Path(__file__).resolve().parents[1]
def src(p):return (ROOT/'triggers'/p).read_text(encoding='utf-8-sig')
def fn(s,name):return re.search(r'(?m)^\s*(?:private |public )?function '+name+r' takes.*?endfunction',s,re.S)[0]

class HeroTimingWave(unittest.TestCase):
 def test_ainz_mine_damage_has_five_even_ranks_and_original_visual_scale(self):
  text=src('Heroes/Ainz.j')
  lines=re.findall(r'^\s*set dmg = .*$',text,re.M)
  first=next(i for i,line in enumerate(lines) if 'AinzQ_DamageIntBase' in line)
  vm=JassState('function MineDamage takes nothing returns nothing\n'+'\n'.join(lines[first:first+2])+'\nendfunction')
  for name in ('AinzQ_DamageIntBase','AinzQ_DamageIntStep','AinzQ_Damage2StaticBase','AinzQ_Damage2StaticStep'):
   vm.g[name]=float(re.search(r'real '+name+r' = ([0-9.]+)',text)[1])
  vm.g.update(c=vm.unit(),GetHeroInt=lambda *_:100.,dmg=0.)
  for rank,coefficient in enumerate((1.,1.375,1.75,2.125,2.5),1):
   vm.g['level']=rank;vm.run('MineDamage');self.assertAlmostEqual(100.*coefficient+100.,vm.g['dmg'])
  self.assertNotIn('AinzQ_MineScale',text)
  self.assertIn('call BlzSetSpecialEffectScale(e, 0.85)',text)
 def test_funny_barrel_adds_main_stat_without_changing_tusk_barrel(self):
  text=src('Items/Items.j');line=re.search(r'set dmg = FunnyBarrel_Damage[^\r\n]*',text)[0]
  vm=JassState('function BarrelDamage takes nothing returns nothing\n'+line+'\nendfunction')
  vm.g.update(c=vm.unit(),FunnyBarrel_Damage=175.,FunnyBarrel_DamageLvlMultiplier=0.,FunnyBarrel_DamageStat=float(re.search(r'real FunnyBarrel_DamageStat = ([0-9.]+)',text)[1]),GetMainStatValue=lambda *_:80.,GetHeroLevel=lambda *_:35,dmg=0.)
  vm.run('BarrelDamage');self.assertEqual(335.,vm.g['dmg'])
  self.assertRegex(text,r'real TuskBarrel_DamageStat = 4\b')
 def test_harribel_r_delays_slashes_but_keeps_invulnerability(self):
  text=re.search(r'    private struct HarribelSpells_R\b.*?    endstruct',src('Heroes/Harribel.j'),re.S)[0];vm=JassState(text);ns=vm.structs['HarribelSpells_R'];c=vm.unit();c.abilities['Avul']={'level':1};d=ns.create();d.deallocate=lambda *_:None
  for k,v in dict(c=c,r=0.,rmax=1.35,r2=10.,r3=0.,x=0.,y=0.,aoe=800.,g=vm.create_group(),g2=vm.create_group()).items():setattr(d,k,v)
  ns.statics.update(MUI_HarribelR=0,m_HarribelR={0:d})
  vm.g.update(HarribelR_CastDelay=.33,DebugUnit=lambda *_:None,EffectSpawn=vm.effect,StopSpellUnit=lambda u:vm.remove_ability(u,'Avul'),HarribelTick_Off=lambda *_:None)
  for _ in range(10):vm.run('Loop_HarribelR')
  self.assertFalse(vm.effect_history);self.assertIn('Avul',c.abilities)
  vm.run('Loop_HarribelR');self.assertGreater(len(vm.effect_history),0);self.assertIn('Avul',c.abilities)
  c.life=0.;vm.run('Loop_HarribelR');self.assertNotIn('Avul',c.abilities)
 def test_raiden_t_bonus_is_removed_once_on_t2_and_not_again_on_exit(self):
  text=src('Heroes/Raiden.j');transition=re.search(r'if k3 == 0 and LoadInteger\(hs, GetHandleId\(c\), SH_RAIDEN_T2\) == 1 then.*?endif',text,re.S)[0]
  cleanup=re.search(r'if k3 == 0 then\s+call BlzSetUnitWeaponIntegerField.*?endif',text,re.S)[0]
  vm=JassState('function Transition takes nothing returns nothing\n'+transition+'\nendfunction\nfunction Cleanup takes nothing returns nothing\n'+cleanup+'\nendfunction')
  c=vm.unit();weapon={'damage':150};vm.g.update(c=c,hs={(id(c),'t2'):1},SH_RAIDEN_T2='t2',k3=0,rmax=5.,RaidenTT_AddDuration=5.,RaidenT_AdditionalDmg=50,RaidenTT_AttackRangeBonus=80.,UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE=1,UNIT_WEAPON_RF_ATTACK_RANGE=2,
   BlzGetUnitWeaponIntegerField=lambda *_:weapon['damage'],BlzSetUnitWeaponIntegerField=lambda u,f,i,v:weapon.update(damage=v),BlzGetUnitWeaponRealField=lambda *_:700.,SetUnitRange=lambda *_:None)
  vm.run('Transition');self.assertEqual(100,weapon['damage']);vm.run('Transition');vm.run('Cleanup');self.assertEqual(100,weapon['damage'])
  vm.g['k3']=0;weapon['damage']=150;vm.run('Cleanup');self.assertEqual(100,weapon['damage'])
 def test_raiden_transformed_dashes_share_1650_unit_limit(self):
  text=re.search(r'    private struct RaidenQ_KS\b.*?    endstruct',src('Heroes/Raiden.j'),re.S)[0]
  for mode in (1,2):
   vm=JassState(text);ns=vm.structs['RaidenQ_KS'];c=vm.unit();d=ns.create();d.deallocate=lambda *_:None
   for k,v in dict(c=c,k2=mode,r=0.,r_prepare=.57 if mode==1 else .63,rmax=1.02 if mode==1 else 1.05,move=110. if mode==1 else 120.,dashTravelled=0.,a=0.,scale=6.3,g=vm.create_group(),g2=vm.create_group()).items():setattr(d,k,v)
   ns.statics.update(MUI_RaidenQ=0,m_RaidenQ={0:d})
   vm.g.update(hs={},SH_Q_ABI='q',DebugUnit2=lambda *_:None,RaidenTQ_Range=1650.,RaidenQ_DamageAoe=475.,RaidenTQ_DecorDamage=40.,RaidenTTQ_DecorDamage=60.,RaidenQ_StunTime=.5,EffectSpawn=vm.effect,EffectSpawn2=vm.effect,EffectSpawnColor=vm.effect,StopSpellUnit2=lambda *_:None,RaidenTick_Off=lambda *_:None)
   for _ in range(40):
    if ns.MUI_RaidenQ<0:break
    vm.run('Loop_RaidenQ')
   self.assertAlmostEqual(1650.,d.dashTravelled);self.assertAlmostEqual(1650.,c.x)
 def test_harribel_charge_caps_at_four_only_from_level_35(self):
  vm=JassState(fn(src('Heroes/Harribel.j'),'HarribelEW_ChargedDamage'));c=vm.unit();level=[34]
  vm.g.update(HarribelEW_ChargeBonus35=4.,HarribelEW_MaxCastDuration=3.,GetHeroLevel=lambda _:level[0],GetHeroAgi=lambda *_:100.)
  self.assertEqual(300.,vm.run('HarribelEW_ChargedDamage',(c,100.,3.)))
  level[0]=35;self.assertEqual(300.,vm.run('HarribelEW_ChargedDamage',(c,100.,1.5)))
  self.assertEqual(500.,vm.run('HarribelEW_ChargedDamage',(c,100.,3.)));self.assertEqual(500.,vm.run('HarribelEW_ChargedDamage',(c,100.,30.)))
 def test_patriot_barrier_catches_entrants_and_returns_blinks_without_touching_allies(self):
  text=src('Heroes/Patriot.j');a=text.index('                    // Like Kenjaku R:');z=text.index('\n                    if ',a)
  body=text[a:z]
  vm=JassState('function Boundary takes nothing returns nothing\n'+body+'\nendfunction');c=vm.unit(owner=0);u=vm.unit(owner=1);u.x=100.;ally=vm.unit(owner=0);ally.x=200.
  vm.g.update(c=c,u=None,distance=0.,x=0.,y=0.,aoe=500.,PatriotT_EdgeInset=50.,g=vm.create_group(),g2=vm.create_group(),PosUnit=lambda u,x,y:(setattr(u,'x',x),setattr(u,'y',y)))
  vm.g['GAngle3']=lambda x,y,u:math.atan2(u.y-y,u.x-x)
  vm.run('Boundary');self.assertIn(u,vm.g['g2']);self.assertNotIn(ally,vm.g['g2'])
  u.x=2500.;ally.x=2500.;vm.run('Boundary');self.assertAlmostEqual(450.,u.x);self.assertEqual(2500.,ally.x)
 def test_tsuna_earlier_release_has_50_percent_and_continuous_growth(self):
  vm=JassState(fn(src('Heroes/Tsuna.j'),'TsunaT_DisplayCharge'))
  vm.g.update(TsunaT_ReleaseTime=.54,TsunaT_ChargeTimeFull=1.2,TsunaT_OverchargeTime=4.,TsunaT_OverchargeDmgPct=125.)
  for time,power in ((.3,0.),(.54,50.),(1.02,75.),(1.5,100.),(2.75,112.5),(4.,125.)):
   self.assertAlmostEqual(power,vm.run('TsunaT_DisplayCharge',(time,True)))
  self.assertEqual(100.,vm.run('TsunaT_DisplayCharge',(4.,False)))
 def test_toji_item_mana_changes_only_agility_and_only_that_carrier(self):
  text=fn(src('Systems/ItemEnter.j'),'Toji_FreeAgilityItem').replace('static if LIBRARY_TojiSpells then','if LIBRARY_TojiSpells then')
  vm=JassState(text);hero=vm.unit();hero.type='toji';other=vm.unit();other.type='raiden'
  hero.abilities['active']={'level':2};other.abilities['active']={'level':2};calls=[]
  vm.g.update(LIBRARY_TojiSpells=True,Toji_ID='toji',ITEM_TYPE_PURCHASABLE='agi',GetItemType=lambda it:it['class'],GetItemTypeId=lambda it:it['id'],
   ABILITY_IF_LEVELS='levels',BlzGetItemAbilityByIndex=lambda it,i:('active','passive')[i] if i<2 else None,BlzGetAbilityId=lambda ab:ab,BlzGetAbilityIntegerField=lambda ab,_:2 if ab=='active' else 1,BlzSetUnitAbilityManaCost=lambda *args:calls.append(args))
  vm.run('Toji_FreeAgilityItem',(hero,{'class':'int','id':'x'}));vm.run('Toji_FreeAgilityItem',(other,{'class':'agi','id':'x'}));self.assertFalse(calls)
  vm.run('Toji_FreeAgilityItem',(hero,{'class':'agi','id':'x'}));self.assertEqual([(hero,'active',0,0),(hero,'active',1,0),(hero,'passive',0,0)],calls)
 def test_saber_form_swap_keeps_the_longest_remaining_w_cooldown(self):
  vm=JassState(fn(src('Heroes/AlterSaber.j'),'AlterSaber_ShareWCooldown'));c=vm.unit();c.abilities.update(w={'level':3},rw={'level':3});cd={'w':8.,'rw':0.}
  vm.g.update(AlterSaberW_ID='w',AlterSaberW2_ID='rw',BlzGetUnitAbilityCooldownRemaining=lambda u,a:cd[a],BlzStartUnitAbilityCooldown=lambda u,a,v:cd.update({a:v}))
  vm.run('AlterSaber_ShareWCooldown',(c,));self.assertEqual({'w':8.,'rw':8.},cd)
  cd.update(w=0.,rw=4.);vm.run('AlterSaber_ShareWCooldown',(c,));self.assertEqual({'w':4.,'rw':4.},cd)
 def test_raiden_aimed_and_arena_lightning_share_target_deadline(self):
  text=src('Heroes/Raiden.j');guards=re.findall(r'if TimerGetElapsed\(HealRegenClock\) >= LoadReal\(RaidenTTWHits, this, GetHandleId\(u\)\) then.*?endif',text,re.S)
  self.assertEqual(2,len(guards));code='\n'.join('function Hit'+str(i)+' takes unit c, unit u, integer instance, real dmg, real dmg_arena returns nothing\n'+g.replace('this','instance')+'\nendfunction' for i,g in enumerate(guards))
  vm=JassState(code);c,u=vm.unit(),vm.unit();hits=[];tags=[]
  vm.g.update(RaidenTTWHits={},HealRegenClock=None,RaidenTTW_HitInterval=1.,src=1,DamageSource=lambda x:tags.append(x),dmgmag=lambda c,u,d:hits.append(d))
  vm.run('Hit0',(c,u,1,20.,5.));vm.elapsed=.1;vm.run('Hit1',(c,u,1,20.,5.));vm.elapsed=.99;vm.run('Hit0',(c,u,1,20.,5.))
  self.assertEqual([20.],hits);self.assertEqual([1],tags)
  vm.elapsed=1.;vm.run('Hit1',(c,u,1,20.,5.));self.assertEqual([20.,5.],hits)
 def test_frieren_e_has_six_columns_even_with_a_long_lifetime(self):
  from test_hero_balance_followup import HeroBalanceFollowup
  vm,c,_=HeroBalanceFollowup().frieren_fixture();ns=vm.structs['FrierenSpells_E'];d=ns.create();d.deallocate=lambda *_:None
  for k,v in dict(c=c,statSource=c,r=0.,rmax=5.,r3=.42,k=0,aoe=100.,aoe2=100.,g=vm.create_group(),g2=vm.create_group(),dmg=1.,check2=0).items():setattr(d,k,v)
  ns.statics.update(MUI_FrierenE=0,m_FrierenE={0:d})
  vm.g.update(GearKey=lambda _,name,index:name+str(index),WUI_HeroProgress=lambda *_:None,SlowUnit=lambda *_:None,GetRandomReal=lambda lo,hi:(lo+hi)/2)
  key=lambda value:value if isinstance(value,(str,int)) else id(value)
  vm.g.update(SaveReal=lambda h,k,f,v:h.update({(key(k),f):v}),LoadReal=lambda h,k,f:h.get((key(k),f),0.))
  for _ in range(120):vm.run('Loop_FrierenE')
  self.assertEqual(6,d.k)
 def test_inori_fq_keeps_five_hits_in_shortened_window(self):
  text=re.search(r'    private struct InoriQ_KS\b.*?    endstruct',src('Heroes/Inori.j'),re.S)[0];vm=JassState(text);c=vm.unit(owner=0);enemy=vm.unit(owner=1);enemy.x=250.
  ns=vm.structs['InoriQ_KS'];d=ns.create();d.deallocate=lambda *_:None
  for k,v in dict(c=c,r=.42,rmax=1.45,check2=2,r7=1000.,dmg=200.,aoe=365.,a=0.,e=None,e2=None,g=vm.create_group(),g2=vm.create_group(),fqPulses=0).items():setattr(d,k,v)
  ns.statics.update(MUI_InoriQ=0,m_InoriQ={0:d});hits=[]
  vm.g.update(EffectSpawn=vm.effect,DamageSource=lambda *_:None,dmgmag=lambda c,u,v:hits.append(v),StunUnit=lambda *_:None,InoriFQ_StunPeriodic=.1,StopSpellUnit2=lambda *_:None,InoriTick_Off=lambda *_:None)
  for _ in range(36):
   if ns.MUI_InoriQ<0:break
   vm.run('Loop_InoriQ')
  self.assertEqual(5,d.fqPulses);self.assertEqual(1000.,sum(hits));self.assertLessEqual(d.r,1.48)
 def test_native_elements_exceptions_growth_and_shared_cooldowns(self):
  docs,_=ws.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
  for doc in docs:
   if doc['kind'] not in ('abilities','units'):continue
   index={ws.object_id(o):o for o in doc['custom_objects']}
   def f(a):return {(m['field']['text'],m.get('level',0)):ws.value_for_user(m) for m in index[a]['modifications']}
   if doc['kind']=='abilities':
    for rank in range(1,9):
     for key in ('adur','ahdu'):self.assertEqual(4.,f('A03T')[key,rank])
    for aid in ('A0DZ','A110'):
     for key in ('adur','ahdu'):self.assertEqual(4.,f(aid)[key,1])
    for rank in range(1,6):
     self.assertEqual(21.-rank,f('A028')['acdn',rank]);self.assertEqual(700.+rank*100,f('A0GN')['aran',rank])
    self.assertEqual(2200.,f('A0GT')['aran',1])
   else:
    for key,value in [('ustp',1.8),('uagp',2.1),('uinp',1.65)]:self.assertAlmostEqual(value,f('H021')[key,0],places=6)

if __name__=='__main__':unittest.main()
