"""Beam interruption and revised hero/item timing regressions."""
from pathlib import Path
import re,json,unittest
import war3_object_workspace as ws
from test_crocodile import JassState
ROOT=Path(__file__).resolve().parents[1]
def source(p):return (ROOT/'triggers'/p).read_text(encoding='utf-8-sig')

class CombatCastFollowup(unittest.TestCase):
 def test_frieren_q_launches_at_point_75_and_not_old_point_6(self):
  from test_hero_balance_followup import HeroBalanceFollowup
  vm,*_=HeroBalanceFollowup().frieren_fixture();ns=vm.structs['FrierenSpells_Q'];data=ns.create();data.c=vm.unit();data.statSource=data.c
  data.r=.57;data.rmax=3.;data.r2=0.;data.r3=0.;data.r5=190.;data.check=0;data.a=0.;data.r7=1000.;data.move=70.
  ns.statics.update(MUI_FrierenQ=0,m_FrierenQ={0:data})
  vm.g.update(SpellBoolCaster=lambda _:True,DebugUnit2=lambda *_:None,EffectSpawnColor=vm.effect,FrierenCloneCheck=lambda _:False)
  for _ in range(5):vm.run('Loop_FrierenQ');self.assertEqual(0,data.check)
  vm.run('Loop_FrierenQ');self.assertEqual(1,data.check);self.assertEqual(0,data.r)
 def beam(self):
  text=source('Heroes/Neuvillette.j');struct=re.search(r'    private struct NeuvilletteSpells_R\b.*?    endstruct',text,re.S)[0]
  vm=JassState(struct);ns=vm.structs['NeuvilletteSpells_R'];c=vm.unit();c.abilities['Avul']={'level':1}
  data=ns.create();data.deallocate=lambda *_:None;data.c=c;data.r=.48;data.rmax=.51;data.check=0;data.a=0.;data.g=vm.g['CreateGroup']();data.g2=vm.g['CreateGroup']()
  data.e=vm.effect('charge');data.e2=None;data.e3=vm.effect('hand');data.e4=None
  ns.statics.update(MUI_NeuvilletteR=0,m_NeuvilletteR={0:data})
  effects=[];stops=[]
  vm.g.update(NeuvilletteR_ID='r',WUI_HeroProgress=lambda *_:None,NeuvilletteR_IsInvul=True,NeuvilletteR_CastTime=.51,NeuvilletteR_Duration=3.,
   DebugUnit=lambda *_:None,DebugUnit2=lambda *_:None,SpellBoolCaster=lambda u:u.life>.405,
   EffectSpawn=vm.effect,ColorEffDummy4=lambda *_:None,GetPlayerId=lambda p:p,GetOwningPlayer=lambda u:u.owner,MouseX={},MouseY={},MouseOn=lambda *_:None,MouseOff=lambda *_:None,
   ColorEffDummy3=lambda e,*_:effects.append(('fade',e)),DestroyEffect=lambda e:effects.append(('destroy',e)),
   StopSpellUnit=lambda _:stops.append('invul'),StopSpellUnit2=lambda _:stops.append('normal'),NeuvilletteTimer03Release=lambda:None)
  return vm,ns,c,data,effects,stops
 def test_beam_loses_invulnerability_on_launch_and_all_effects_have_single_cleanup(self):
  vm,ns,c,data,effects,stops=self.beam();charge=data.e;hand=data.e3
  vm.run('Loop_NeuvilletteR');beam=data.e2
  self.assertEqual(1,data.check);self.assertNotIn('Avul',c.abilities);self.assertIsNotNone(beam)
  c.life=0.;vm.run('Loop_NeuvilletteR')
  self.assertEqual(-1,ns.MUI_NeuvilletteR);self.assertEqual(['normal'],stops)
  self.assertCountEqual([('fade',charge),('fade',beam),('destroy',hand)],effects)
 def test_interrupt_during_preparation_releases_invulnerability_without_spawning_beam(self):
  vm,ns,c,data,effects,stops=self.beam();data.r=.2;c.life=0.
  vm.g['StopSpellUnit']=lambda u:(stops.append('invul'),vm.remove_ability(u,'Avul'))
  vm.run('Loop_NeuvilletteR');self.assertEqual(['invul'],stops);self.assertNotIn('Avul',c.abilities)
  self.assertEqual(2,len(effects));self.assertTrue(all(e is not None for _,e in effects))
 def test_native_costs_durations_and_exit_channel(self):
  docs,_=ws.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
  for d in docs:
   if d['kind']!='abilities':continue
   index={ws.object_id(o):o for o in d['custom_objects']}
   def f(a):return {(m['field']['text'],m.get('level',0)):ws.value_for_user(m) for m in index[a]['modifications']}
   for rank in range(1,6):self.assertEqual(0,f('A02U')['amcs',rank])
   self.assertEqual(20.,f('A0HE')['acdn',1])
   for aid in ('A132','A134','A144','A162'):
    for field in ('adur','ahdu'):self.assertEqual(9.,f(aid)[field,1])
   self.assertEqual('ANcl',index['A030']['old_id']['text']);self.assertEqual('spellshield',f('A030')['Ncl6',1])
   for field in ('abuf','aeff'):self.assertEqual('',f('A030')[field,1])
   for field in ('acat','atat','asat','aeat','amat','aefs'):self.assertEqual('',f('A030')[field,0])

if __name__=='__main__':unittest.main()
