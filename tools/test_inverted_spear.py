"""Execute resistance piercing, undispellable lifetime, native item and Bazz-B contracts."""
from pathlib import Path
import json,re,unittest
from test_crocodile import JassState
import war3_object_workspace as ws
ROOT=Path(__file__).resolve().parents[1]
def source(path):return (ROOT/'triggers'/path).read_text(encoding='utf-8-sig')
def fn(text,name):return re.search(r'(?m)^\s*(?:private |public )?function '+name+r' takes.*?endfunction',text,re.S)[0]

class InvertedSpear(unittest.TestCase):
 def fixture(self,extra=''):
  items=source('Items/Items.j');systems=source('Systems/Systems1.j')
  struct=re.search(r'    private struct ItemsAnimeEffect\b.*?    endstruct',items,re.S)[0]
  text=struct+'\n'+fn(items,'InvertedSpear_Start')+'\n'+fn(systems,'InvertedSpear_IsActive')+'\n'+fn(systems,'InvertedSpear_IgnoreResistance')+'\n'+extra
  vm=JassState(re.sub(r'(?<![\w.\]])\.(?=[A-Za-z_])','this.',text.replace('static if LIBRARY_FrostnovaSpells then','if LIBRARY_FrostnovaSpells then')))
  ns=vm.structs['ItemsAnimeEffect'];ns.statics.update(KIND_SUKUNA=1,KIND_SEAL=2,KIND_COFFIN=3,KIND_RETURN=4,KIND_WILL=5,KIND_SPEAR=6,list={},count=0,clock=None)
  vm.g.update(hs={},SH_INVERTED_SPEAR_END='spear end',HealRegenClock=None,InvertedSpear_Buff_ID='spear',InvertedSpear_Curse_ID='curse',InvertedSpear_Duration=9.,InvertedSpear_ResistanceIgnore=50.,
   SpellBool=lambda u:u.life>.405,IsUnitType=lambda u,t:u.life<=.405,DebuffImmune_Start=lambda *_:1,TimerStart=lambda *_:None,PauseTimer=lambda *_:None,
   ItemsAnime_Curse=lambda c,u,_:vm.add_ability(u,'spear'))
  c,u=vm.unit(owner=0),vm.unit(owner=1)
  return vm,ns,c,u
 def test_dispels_cannot_cancel_actual_piercing_and_refresh_has_one_instance(self):
  vm,ns,c,u=self.fixture();vm.run('InvertedSpear_Start',(c,u))
  self.assertEqual(1,ns.count);self.assertTrue(vm.run('InvertedSpear_IsActive',(u,)))
  for t in (.1,1.,2.,8.99):
   vm.elapsed=t;vm.remove_ability(u,'spear')
   self.assertTrue(vm.run('InvertedSpear_IsActive',(u,)))
   vm.run('Tick');self.assertIn('spear',u.abilities)
  vm.elapsed=9.;self.assertFalse(vm.run('InvertedSpear_IsActive',(u,)));vm.run('Tick')
  self.assertEqual(0,ns.count);self.assertNotIn('spear',u.abilities)
  vm.elapsed=10.;vm.run('InvertedSpear_Start',(c,u));vm.elapsed=12.;vm.run('InvertedSpear_Start',(c,u))
  self.assertEqual(1,ns.count);vm.elapsed=20.99;self.assertTrue(vm.run('InvertedSpear_IsActive',(u,)))
  vm.elapsed=21.;vm.run('Tick');self.assertEqual(0,ns.count)
 def test_half_of_total_resistance_with_channel_factors_and_negative_resistance(self):
  vm,_,_,_=self.fixture()
  for base,ordinary,outside,expected in ((100.,100.,1.,100.),(100.,20.,1.,60.),(100.,50.,1.,75.),
    (100.,50.,.3,57.5),(100.,50.,.15,53.75),(100.,120.,1.,120.),(0.,0.,.3,0.)):
   result=vm.run('InvertedSpear_IgnoreResistance',(base,ordinary,outside))
   self.assertAlmostEqual(expected,result*outside)
 def test_target_guards_death_and_no_pause_or_order_side_effects(self):
  vm,ns,c,u=self.fixture()
  vm.run('InvertedSpear_Start',(c,c));self.assertEqual(0,ns.count)
  u.life=0.;vm.run('InvertedSpear_Start',(c,u));self.assertEqual(0,ns.count)
  u.life=100.;vm.g['DebuffImmune_Start']=lambda *_:0;vm.run('InvertedSpear_Start',(c,u));self.assertEqual(0,ns.count)
  vm.g['DebuffImmune_Start']=lambda *_:1;vm.run('InvertedSpear_Start',(c,u));u.life=0.;u.dead=True;vm.run('Tick')
  self.assertEqual(0,ns.count);self.assertEqual(0.,vm.g['hs'][id(u),'spear end'])
  text=fn(source('Items/Items.j'),'InvertedSpear_Start')
  self.assertNotRegex(text,r'PauseUnit|Issue.*Order|StartSpellUnit')
 def test_resistance_piercing_stays_before_full_shields_and_hud_reads_same_formula(self):
  text=source('Systems/Systems1.j');body=fn(text,'DamageBlock')
  self.assertLess(body.index('InvertedSpear_IgnoreResistance'),body.index('set dmg = ApplyGearSystemFullShields'))
  tail=body[body.index('    set dmg = InoriE_ApplyAuraResistance'):]
  vm,_,c,u=self.fixture('function Tail takes unit c, unit td, real dmgbase, real dmg, integer typedmg, boolean test returns real\nlocal real value\nlocal real shieldTriggerDmg = 100\nlocal player targetOwner = null\n'+tail)
  vm.g.update(LIBRARY_FrostnovaSpells=True,FrostnovaE_ResistBuffID='frost',FrostnovaE_Resist=.5,
   HeroChannelDamageFactor=lambda _:1.,InoriE_ApplyAuraResistance=lambda u,d,t:d,ApplyGearSystemFullShields=lambda c,u,d,*_:max(0.,d-20.))
  vm.run('InvertedSpear_Start',(c,u))
  for kind in (0,1,2):self.assertAlmostEqual(40.,vm.run('Tail',(c,u,100.,20.,kind,False)))
  vm.elapsed=9.;self.assertEqual(0.,vm.run('Tail',(c,u,100.,20.,1,False)))
 def test_native_item_recipe_buff_and_bazz_cooldowns(self):
  ids=json.loads((ROOT/'object-data/inverted-spear-ids.json').read_text());items=json.loads((ROOT/'object-data/items.json').read_text(encoding='utf-8-sig'))
  item=items[ids['Item']];self.assertEqual(7500,item['gold_cost']);self.assertEqual(1,item['actively_used'])
  self.assertEqual('Permanent',item['classification']);self.assertEqual(ids['Active']+',A00M',item['abilities'])
  self.assertIn("RegisterCraft('"+ids['Item']+"', \"I034 I01J\")",source('WOS_Start/WoS_Shop_Init.j'))
  self.assertEqual(4500,7500-items['I034']['gold_cost']-items['I01J']['gold_cost'])
  docs,_=ws.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
  for doc in docs:
   if doc['kind']!='abilities':continue
   index={ws.object_id(o):o for o in doc['custom_objects']}
   def fields(aid):return {(m['field']['text'],m.get('level',0)):ws.value_for_user(m) for m in index[aid]['modifications']}
   active=fields(ids['Active']);curse=fields(ids['Curse'])
   self.assertEqual(1,active['aite',0]);self.assertEqual(20.,active['acdn',1]);self.assertEqual(800.,active['aran',1]);self.assertEqual(0,active['amcs',1])
   self.assertEqual(9.,curse['adur',1]);self.assertEqual(9.,curse['ahdu',1]);self.assertEqual(0.,curse['Crs1',1]);self.assertEqual(ids['Buff'],curse['abuf',1])
   for aid,base in [('A08N',20.),('A08O',18.),('A08P',28.)]:
    for rank in range(1,6):self.assertEqual(base-rank+1,fields(aid)['acdn',rank])

if __name__=='__main__':unittest.main()
