"""Execute full-catalogue cast vision, live projectile areas and train scaling."""
from pathlib import Path
from types import SimpleNamespace
import json,re,unittest
from test_crocodile import JassState
from test_fire_item_effects import branch
import war3_object_workspace as ws

ROOT=Path(__file__).resolve().parents[1]
def read(p):return (ROOT/p).read_text(encoding='utf-8-sig')
ITEMS=read('triggers/Items/Items.j')
def function(text,name):return re.search(r'(?m)^\s*(?:private |public )?function '+name+r' takes.*?endfunction',text,re.S)[0]

class TrailVision(unittest.TestCase):
 def test_all_60_active_item_ids_reach_the_real_common_vision_gate(self):
  source=read('triggers/Systems/CastAItems.j');prefix=source.split('function ItemsCast takes',1)[1].split('set SacredGearBooster_CastAbil',1)[0]
  vm=JassState(function(source,'ItemActiveVision')+'\nfunction Gate takes'+prefix+'endfunction')
  docs,_=ws.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw');native={}
  for doc in docs:
   if doc['kind']=='abilities':
    for o in doc['custom_objects']:
     native.setdefault(ws.object_id(o),{}).update({(m['field']['text'],m.get('level',0)):ws.value_for_user(m) for m in o['modifications']})
  items=json.loads((ROOT/'object-data/items.json').read_text(encoding='utf-8-sig'));active=[v for v in items.values() if v.get('actively_used')]
  current=[None];c=vm.unit(10,20,2);target=vm.unit(900,1000,1)
  vm.g.update(GetSpellAbility=lambda:current[0],GetSpellAbilityId=lambda:current[0],GetPlayerId=lambda p:p,GAngle2=lambda *_:0.,
   GetUnitAbilityLevel=lambda *_:1,ABILITY_BF_ITEM_ABILITY='item',ABILITY_RLF_AREA_OF_EFFECT='area',ABILITY_ILF_TARGET_TYPE='target',
   BlzGetAbilityBooleanField=lambda a,f:native[a].get(('aite',0),0),
   BlzGetAbilityRealLevelField=lambda a,f,l:native[a].get(('aare',l+1),0.),
   BlzGetAbilityIntegerLevelField=lambda a,f,l:native[a].get(('Ncl2',l+1),0),
   DecorRemove=lambda *_:None,ItemActive_DecorDamage=50.,HashiramaCells_AllyAoe=700.)
  for item in active:
   current[0]=item['abilities'].split(',')[0];vm.run('Gate',(c,target,900.,1000.,current[0]))
   call=vm.vision_calls[-1];self.assertEqual((2,900,1000),call[:3]);self.assertGreaterEqual(call[3],750.)
   self.assertGreaterEqual(call[3],1.5*native[current[0]].get(('aare',1),0.));self.assertEqual(2.,call[4])
  self.assertEqual(61,len(active));self.assertEqual(61,len(vm.vision_calls))
 def test_three_agi_shurikens_each_reveal_their_own_current_position_both_directions(self):
  body=ITEMS.split('elseif .kind == ASHEN or .kind == WAVE then',1)[1].split('elseif .kind == COILSHOT then',1)[0]
  body=re.sub(r'(?<![\w])\.([A-Za-z]\w*)',r'this.\1',body)
  vm=JassState('function Tick takes nothing returns boolean\nlocal real px\nlocal real py\nlocal real a\n'+body+'\nendfunction')
  c=vm.unit(800,400,0);fx=SimpleNamespace(c=c,kind=8,x=100.,y=200.,vx=1.,vy=0.,step=800.,next=1800.,phase=0,tx=800.,ty=400.,g=[],g2=[],dmg=100.,dmg2=80.,Sweep=lambda *_:None)
  for name in ('e','e2','e3','trail1','trail2','trail3'):setattr(fx,name,vm.effect(name))
  vm.g.update(showVision=True,DT=.03,WAVE=9,ASHEN=8,IntegerTertiaryOp=lambda p,a,b:a if p else b)
  for phase in (0,1):
   fx.phase=phase;vm.vision_calls.clear();vm.run('Tick',obj=fx)
   self.assertEqual(3,len(vm.vision_calls));self.assertEqual(3,len({(v[1],v[2]) for v in vm.vision_calls}))
   for call,e in zip(vm.vision_calls,(fx.e,fx.e2,fx.e3)):
    self.assertEqual((e.x,e.y),call[1:3]);self.assertEqual((750.,.3),call[3:])
 def test_int_lightning_reveals_during_flight_and_every_growing_spin_phase(self):
  vm=branch('COILSHOT','STRIKES');c=vm.unit();fx=SimpleNamespace(c=c,x=100.,y=200.,phase=0,left=2.,step=0.,next=1800.,vx=1.,vy=0.,charges=0,e=vm.effect('coil'),e2=vm.effect('trail'),g=[],dmg=500.,Sweep=lambda *_:None,Pulse=lambda *_:None)
  vm.g.update(showVision=True,DT=.03,ConstellationCoil_Speed=1400.,ConstellationCoil_Width=600.,ConstellationCoil_Slow=25,ConstellationCoil_ProjectileScale=1.,ElemInt=lambda _:100.,EffectSpawn=lambda *_:vm.effect('spark'),ColorEffDummy3=lambda *_:None)
  vm.run('Tick',obj=fx);self.assertEqual((fx.e.x,fx.e.y),vm.vision_calls[-1][1:3]);self.assertEqual(900.,vm.vision_calls[-1][3])
  fx.phase=1;fx.x=1800.;fx.y=200.;fx.step=0.;fx.next=.5;vm.vision_calls.clear()
  for _ in range(66):vm.run('Tick',obj=fx)
  radii=[v[3] for v in vm.vision_calls];self.assertEqual(66,len(radii));self.assertEqual(radii,sorted(radii))
  self.assertGreater(radii[-1],2200.);self.assertTrue(all(v[1:3]==(1800.,200.) for v in vm.vision_calls))
 def test_int_fire_book_reveals_during_preparation_and_ground_phase(self):
  vm=branch('RUNE','ASHEN or .kind == WAVE');c=vm.unit();fx=SimpleNamespace(c=c,x=900.,y=300.,phase=0,left=1.64,next=0.,charges=0,dmg=400.,dmg2=400./6,src='book',Pulse=lambda *_:None)
  vm.g.update(showVision=True,DT=.03,CrimsonScripture_Aoe=600.,NoDecor_Cond=None,ItemsElements_Group=[],ElemValid=lambda *_:False,ColorEffDummy3=lambda *_:None)
  vm.run('Tick',obj=fx);self.assertEqual(0,fx.phase);self.assertEqual((900.,300.,900.,.3),vm.vision_calls[-1][1:])
  fx.left=1.19;vm.run('Tick',obj=fx);self.assertEqual(1,fx.phase)
  fx.left=.1;vm.run('Tick',obj=fx);self.assertEqual((900.,300.,900.,.3),vm.vision_calls[-1][1:])
 def test_pulse_reveal_covers_its_actual_area(self):
  body=re.search(r'method Pulse takes.*?endmethod',ITEMS,re.S)[0];body=re.sub(r'(?<![\w])\.([A-Za-z]\w*)',r'this.\1',body)
  vm=JassState(body);c=vm.unit(owner=0);fx=SimpleNamespace(c=c,x=1200.,y=350.,g=None)
  vm.g.update(ItemsElements_Group=[],NoDecor_Cond=None,ItemActive_DecorDamage=50.)
  vm.run('Pulse',(1000.,200.,True,0,0),obj=fx);self.assertEqual((0,1200.,350.,1500.,.6),vm.vision_calls[0])
 def test_trail_refresh_gate_is_bounded_and_overlaps_its_reveal_lifetime(self):
  line=re.search(r'set showVision = ([^\n]+)',ITEMS)[1].replace('.left','remaining')
  vm=JassState('function Gate takes real remaining returns boolean\nreturn '+line+'\nendfunction');vm.g['ModuloInteger']=lambda a,b:a%b
  for initial in (2.,1.64,4.):
   ticks=[i for i in range(1,34) if vm.run('Gate',(initial-i*.03,))]
   self.assertTrue(6<=len(ticks)<=7);self.assertTrue(all((b-a)*.03<=.15+.000001 for a,b in zip(ticks,ticks[1:])))

class TrainDamage(unittest.TestCase):
 def test_first_round_and_every_later_round_gain_75_times_round_for_both_hits(self):
  header=read('triggers/Map_Header.j');round_source=read('triggers/Round_End/RoundEnd.j')
  lines='\n'.join(re.findall(r'(?m)^\s*set dmg2? = TRAIN_[^\n]+',round_source));self.assertEqual(2,len(lines.splitlines()))
  vm=JassState(function(header,'GetEnvironmentRoundNumber')+'\nfunction Calculate takes nothing returns nothing\nlocal real dmg\nlocal real dmg2\n'+lines+'\ncall Capture(dmg,dmg2)\nendfunction')
  values=[];vm.g.update({k:int(v) for k,v in re.findall(r'constant integer (TRAIN_\w+) = (\d+)',header)})
  vm.g.update(TestMode=False,CurrentRound=1,Capture=lambda *args:values.append(args))
  for n in (1,2,5,10):
   vm.g['CurrentRound']=n;vm.run('Calculate');self.assertEqual((200+50*(n-1)+75*n,400+50*(n-1)+75*n),values[-1])
  vm.g.update(TestMode=True,CurrentRound=999);vm.run('Calculate');self.assertEqual((275.,475.),values[-1])
  ui=read('triggers/WOS_Start/WOSUI.j');self.assertIn('WUI_InfoCurrentDamage(TRAIN_PUSH_BASE_DAMAGE, TRAIN_DAMAGE_PER_ROUND)',ui);self.assertIn('WUI_InfoCurrentDamage(TRAIN_EXPLOSION_BASE_DAMAGE, TRAIN_DAMAGE_PER_ROUND)',ui)

if __name__=='__main__':unittest.main()
