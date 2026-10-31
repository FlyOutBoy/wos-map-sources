"""Execute the new collision, drain, pulse and ricochet contracts."""
from pathlib import Path
from types import SimpleNamespace
import json,re,unittest,math
from test_crocodile import JassState
from test_fire_item_effects import branch,SOURCE
import test_hero_balance_followup as hero_tests
ROOT=Path(__file__).resolve().parents[1]

def method(name):
 return re.search(r'(?m)^        (?:static )?method '+name+r' takes.*?        endmethod',SOURCE,re.S)[0]

class ElementWave(unittest.TestCase):
 def test_frieren_combined_tw_is_one_carrier_with_more_damage_and_double_radius(self):
  vm,c,_=hero_tests.HeroBalanceFollowup().frieren_fixture();normal=[]
  vm.run('FrierenW2_Start',(c,c,100.,200.,False));a=vm.structs['FrierenSpells_W2'].m_FrierenW2[0]
  vm.run('FrierenW2_Start',(c,c,100.,200.,True));b=vm.structs['FrierenSpells_W2'].m_FrierenW2[1]
  self.assertAlmostEqual(a.dmg*1.6,b.dmg);self.assertEqual(2.,b.sizeMultiplier)
  for _ in range(25):vm.run('Loop_FrierenW2')
  self.assertAlmostEqual(a.aoe*2.,b.aoe)
  text=(ROOT/'triggers/Heroes/Frieren.j').read_text(encoding='utf-8-sig');body=re.search(r'    function FrierenW2_Start takes.*?endfunction',text,re.S)[0]
  self.assertEqual(1,body.count('call FrierenSpells_W2.FrierenW2_Start'))
 def test_frieren_t2_collision_converges_and_cashout_is_four_shared_bursts(self):
  vm,c,_=hero_tests.HeroBalanceFollowup().frieren_fixture();ns=vm.structs['FrierenSpells_T2'];ns.statics.update(MUI_FrierenT2=-1,m_FrierenT2={})
  clone=vm.unit(x=600.,owner=0);clone.type=vm.g['FrierenTR_unitid'];c.x=0.;c.y=clone.y=0.;hits=[];pulls=[];bursts=[]
  vm.g.update(IsTerrainPathable=lambda *_:False,GAngle2=lambda u,x,y:math.atan2(y-u.y,x-u.x),SlowUnit=lambda *_:None,BlzPlaySpecialEffect=lambda *_:None,ANIM_TYPE_STAND=0,
   dmgmag=lambda caster,u,d:hits.append((caster,d*(.6 if caster is clone else 1.))),MUE=lambda *args:pulls.append(args),EffectSpawn3=lambda *args:(bursts.append(args),vm.effect(*args))[1])
  target=vm.unit(x=300.,owner=1)
  a=vm.run('FrierenT2_Start',(c,c,300.,0.));b=vm.run('FrierenT2_Start',(clone,c,300.,0.))
  for data in (a,b):data.deallocate=lambda *_:None
  a.partner=b;b.partner=a
  want=a.dmg2+6*a.dmg+.6*(b.dmg2+6*b.dmg);bursts.clear()
  for _ in range(130):
   if ns.MUI_FrierenT2<0:break
   vm.run('Loop_FrierenT2')
  self.assertTrue(a.merged and b.merged);self.assertLess(a.r,1.2);self.assertLess(b.r,1.2)
  self.assertEqual(-1,ns.MUI_FrierenT2);self.assertAlmostEqual(want,sum(d for _,d in hits))
  self.assertEqual(4,len([d for _,d in hits if math.isclose(d,a.dmg2 * .25)]));self.assertEqual(4,len(bursts))
  self.assertEqual(4,a.mergeBursts);self.assertEqual(0.,b.dmg2)
  self.assertAlmostEqual(a.x,b.x);self.assertAlmostEqual(a.y,b.y);self.assertEqual((a.mergeX,a.mergeY),(a.x,a.y))
  self.assertTrue(a.silent != b.silent);self.assertTrue(pulls)
  self.assertAlmostEqual(math.atan2(a.y-target.y,a.x-target.x),pulls[-1][-1])
 def test_frieren_merge_bursts_are_spaced_and_pull_outside_the_damage_area(self):
  vm,c,_=hero_tests.HeroBalanceFollowup().frieren_fixture();ns=vm.structs['FrierenSpells_T2'];ns.statics.update(MUI_FrierenT2=-1,m_FrierenT2={})
  target=vm.unit(x=1050.,y=0.,owner=1);hits=[];pulls=[];times=[];growth=[];clock=[0.]
  vm.g.update(SlowUnit=lambda *_:None,BlzPlaySpecialEffect=lambda *_:None,ANIM_TYPE_STAND=0,
   dmgmag=lambda caster,u,d:hits.append((u,d)),MUE=lambda *args:pulls.append(args),
   GAngle2=lambda u,x,y:math.atan2(y-u.y,x-u.x),
   BlzSetSpecialEffectScale=lambda e,v:growth.append((clock[0],e,v)),
   EffectSpawn3=lambda *args:(times.append(clock[0]),vm.effect(*args))[1])
  fx=vm.run('FrierenT2_Start',(c,c,0.,0.));fx.x=fx.y=0.;fx.aoe=600.;fx.dmg2=800.;fx.mergePhase=2;fx.mergeTime=0.;fx.mergeBursts=0;fx.r=.54
  fx.deallocate=lambda *_:None;orb=fx.e
  for _ in range(65):
   clock[0]+=.03
   if ns.MUI_FrierenT2<0:break
   vm.run('Loop_FrierenT2')
  self.assertEqual(4,len(times));self.assertAlmostEqual(.5,times[0],delta=.03)
  for a,b in zip(times,times[1:]):self.assertAlmostEqual(.4,b-a,delta=.03)
  self.assertFalse([d for u,d in hits if u is target]);self.assertEqual(4,len([p for p in pulls if p[0] is target]))
  scales=[v for _,e,v in growth if e is orb];self.assertEqual(sorted(scales),scales);self.assertAlmostEqual(2.625,scales[-1])
  self.assertEqual(-1,ns.MUI_FrierenT2)

 def test_siren_restores_only_actual_drained_mana(self):
  text=SOURCE.split('            elseif .kind == SIREN then',1)[1].split('            endif\n            set v = null',1)[0]
  text=re.sub(r'(?<![\w])\.([A-Za-z]\w*)',r'this.\1',text)
  vm=JassState('function Drain takes nothing returns nothing\nlocal real take\n'+text+'\nendfunction')
  c,u=vm.unit(owner=0),vm.unit(owner=1);mana={id(c):0.,id(u):25.}
  fx=SimpleNamespace(c=c,u=u,next=0.,dmg2=float(re.search(r'real SirenTear_IntCap = ([0-9.]+)',SOURCE)[1])*100./8.)
  vm.g.update(DT=.03,SirenTear_Return=float(re.search(r'real SirenTear_Return = ([0-9.]+)',SOURCE)[1]),UNIT_STATE_MANA=0,GetUnitState=lambda v,_:mana[id(v)],SetMpCurrentQuiet=lambda v,d:mana.update({id(v):mana[id(v)]+d}))
  for _ in range(100):vm.run('Drain',obj=fx)
  self.assertEqual(0.,mana[id(u)]);self.assertEqual(18.75,mana[id(c)])
  mana[id(u)]=500.;mana[id(c)]=0.;fx.next=0.;vm.g['DT']=.25
  for _ in range(8):vm.run('Drain',obj=fx)
  self.assertEqual(200.,mana[id(u)]);self.assertEqual(225.,mana[id(c)])
 def test_bastion_four_pulses_total_five_str_and_finish_point_three_earlier(self):
  vm=branch('STORM or .kind == SPIRAL','RUNE','local real a\nlocal real dx\nlocal real dy\nlocal real px\nlocal real py\nlocal real best\nlocal thistype m\nlocal unit v\nlocal unit a1\nlocal unit b1\nlocal unit array hits\n')
  fx=SimpleNamespace(kind=5,c=vm.unit(),x=0.,y=0.,next=.2,step=.4,charges=0,dmg=125.,g=[],left=1.6);pulses=[];t=0.
  fx.Pulse=lambda *args:pulses.append((t,args[1]))
  vm.g.update(DT=.03,STORM=5,SPIRAL=7,ThunderBastion_Aoe=475.,ElemFx=lambda *_:None,showVision=False,IntegerTertiaryOp=lambda p,a,b:a if p else b)
  for _ in range(60):
   t+=.03;fx.left-=.03
   if vm.run('Tick',obj=fx):break
  self.assertEqual(4,len(pulses));self.assertEqual(500.,sum(d for _,d in pulses));self.assertAlmostEqual(1.4,pulses[-1][0],delta=.03)
 def test_mirror_ricochets_are_random_enemies_throttled_and_limited_to_four(self):
  body=SOURCE.split('        set fx = ItemsElementsFx.Find(ItemsElementsFx.MIRROR, null, td)',1)[1].split('        // Only attacks and hero abilities',1)[0]
  vm=JassState('function Proc takes nothing returns nothing\nlocal real best\nlocal unit v\nlocal unit near = null\n'+body+'\nendfunction');c=vm.unit(owner=0);td=vm.unit(owner=1);enemy=vm.unit(owner=1,x=300);friend=vm.unit(owner=0,x=200);missiles=[]
  fx=SimpleNamespace(c=c,g=[],charges=4,step=0.,dmg2=150.,HasMark=lambda:True)
  vm.g.update(fx=fx,td=td,dmg=101.,now=0.,NoDecor_Cond=None,ElemValid=lambda caster,v:v.owner!=caster.owner,ItemsElementsFx=SimpleNamespace(Missile=lambda *args:missiles.append(args)),MirrorTide_ID='mirror')
  for n in range(30):vm.g['now']=n*.03;vm.run('Proc')
  self.assertEqual(4,len(missiles));self.assertEqual(0,fx.charges)
  self.assertTrue(all(args[4] is enemy for args in missiles));self.assertTrue(all(args[6].endswith('WaterElementalMissile.mdl') for args in missiles))
 def test_anchor_disarm_restores_attack_and_first_contact_is_remembered(self):
  text=method('Disarm');vm=JassState('private struct D\n'+text+'\nendstruct');locks=[];instances=[];ns=vm.structs['D'];ns.statics['DISARM']=13
  def add(k,src,c,u,d):
   fx=SimpleNamespace(kind=k,c=c,u=u,left=d);instances.append(fx);return fx
  vm.g['Find']=lambda k,c,u:next((f for f in instances if f.u is u),0);vm.g['Add']=add
  vm.g.update(DISARM=13,LeviathanAnchor_ID='anchor',BlzUnitDisableAbility=lambda *args:locks.append(args))
  c,u=vm.unit(),vm.unit();vm.run('Disarm',(c,u));instances[0].left=.3;vm.run('Disarm',(c,u))
  self.assertEqual(1,len(instances));self.assertEqual(2.,instances[0].left);self.assertEqual(1,len(locks))
  cleanup=method('finish');self.assertIn("BlzUnitDisableAbility(.u, 'Aatk', false, false)",cleanup)
  self.assertIn('not IsUnitInGroup(v, .g2)',method('Pulse'))
 def test_coil_flies_point_three_after_first_contact_then_stops_and_drags(self):
  vm=branch('COILSHOT','STRIKES','local real px\nlocal real py\nlocal real d\nlocal real a\n')
  c,u=vm.unit(),vm.unit(owner=1);fx=SimpleNamespace(c=c,u=None,x=0.,y=0.,vx=1.,vy=0.,step=0.,next=1800.,ty=0.,phase=0,left=2.,dmg=450.,g=[],e=vm.effect('coil'),e2=vm.effect('trail'))
  contact=[];drag=[]
  def sweep(*args):
   if fx.u is None:fx.u=u;fx.ty=-.03;contact.append(args[0])
  fx.Sweep=sweep;fx.DragCaught=lambda x,y:drag.append((x,y))
  vm.g.update(showVision=False,DT=.03,ConstellationCoil_Speed=1400.,ConstellationCoil_Width=250.,ConstellationCoil_Slow=25)
  for _ in range(11):vm.run('Tick',obj=fx)
  self.assertEqual(1,fx.phase);self.assertAlmostEqual(420.,fx.x-contact[0]);self.assertEqual(11,len(drag));self.assertEqual(2.,fx.left)
 def test_ashen_hits_the_same_enemy_once_on_each_pass(self):
  body=SOURCE.split('elseif .kind == ASHEN or .kind == WAVE then',1)[1].split('elseif .kind == COILSHOT then',1)[0]
  body=re.sub(r'(?<![\w])\.([A-Za-z]\w*)',r'this.\1',body)
  vm=JassState('private struct S\n'+re.sub(r'(?<![\w])\.([A-Za-z]\w*)',r'this.\1',method('Sweep'))+'\nendstruct\nfunction Tick takes nothing returns boolean\nlocal real d\nlocal real a\nlocal real px\nlocal real py\n'+body+'\nendfunction')
  c,u=vm.unit(owner=0),vm.unit(x=600.,owner=1);hits=[]
  fx=SimpleNamespace(c=c,kind=8,x=0.,y=0.,vx=1.,vy=0.,step=0.,next=1800.,phase=0,tx=0.,ty=0.,g=[],g2=[],dmg=450.,dmg2=350.,e=vm.effect('a'),e2=vm.effect('b'),e3=vm.effect('c'),trail1=vm.effect('a'),trail2=vm.effect('b'),trail3=vm.effect('c'))
  fx.Sweep=lambda *args:vm.run('Sweep',args,obj=fx)
  vm.g.update(showVision=False,DT=.03,WAVE=9,ASHEN=8,COILSHOT=11,ItemsElements_Group=[],NoDecor_Cond=None,ItemActive_DecorDamage=40.,ElemValid=lambda c,u:u.owner!=c.owner,ElemHit=lambda c,u,s,d,*_:hits.append(d),IntegerTertiaryOp=lambda p,a,b:a if p else b)
  fx.src='ashen'
  for _ in range(100):
   if vm.run('Tick',obj=fx):break
  self.assertEqual([450.,350.],hits)
 def test_starrk_preparation_particles_cover_windup_with_positive_lifetime(self):
  text=(ROOT/'triggers/Heroes/Starrk.j').read_text(encoding='utf-8-sig');body=text.split('                    // Stratified cross-section:',1)[1].split('                    if r == 0.03 then',1)[0];body=body[body.index('                    if r >'):]
  vm=JassState('function Prepare takes nothing returns nothing\nlocal real ra1\nlocal real dk\n'+body+'\nendfunction');fx=[]
  vm.g.update(c=vm.unit(),a=0.,r=0.,StarrkR2_CastTime=.54,EffectSpawn2=lambda *args:fx.append(args))
  for i in range(1,19):vm.g['r']=i*.03;vm.run('Prepare')
  self.assertEqual(34,len(fx));self.assertTrue(all(args[-1]>0. for args in fx));self.assertAlmostEqual(.03,fx[-1][-1])
 def test_native_item_cooldowns_stats_and_passive_durations(self):
  a=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'));it=json.loads((ROOT/'object-data/items.json').read_text(encoding='utf-8-sig'))
  self.assertEqual(15.,a['A146']['cooldown level 1']);self.assertEqual(16.,a['A14E']['cooldown level 1']);self.assertEqual('A073,A00X',it['I04C']['abilities'])
  import war3_object_workspace as ws
  docs,_=ws.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
  for doc in docs:
   if doc['kind']=='abilities':
    for o in doc['custom_objects']:
     if ws.object_id(o) in ('A0DZ','A110'):
      for m in o['modifications']:
       if m['field']['text'] in ('adur','ahdu') and m.get('level')==1:self.assertEqual(4.,ws.value_for_user(m))

if __name__=='__main__':unittest.main()
