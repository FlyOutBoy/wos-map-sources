"""Native counter balance, exact barrage count and live aura badges."""
from pathlib import Path
import re,unittest,math
from test_crocodile import JassState
ROOT=Path(__file__).resolve().parents[1]
def source(f):return (ROOT/'triggers'/f).read_text(encoding='utf-8-sig')
def globals_from(vm,text):
 for n,v in re.findall(r'(?:integer|real|boolean) (\w+)\s*=\s*([^\r\n/]+)',text):
  v=v.strip()
  if v.startswith('StringHash') or 'Create' in v or 'Init' in v:continue
  try:vm.g[n]=eval(v.replace('true','True').replace('false','False'))
  except (SyntaxError,NameError):pass

class MergeFollowup(unittest.TestCase):
 def test_harribel_ew_disables_once_and_reenables_once_on_each_exit(self):
  text=source('Heroes/Harribel.j');struct=re.search(r'    private struct HarribelSpells_W\b.*?    endstruct',text,re.S)[0];helper=re.search(r'    (?:private )?function HarribelEW_ChargedDamage takes.*?endfunction',text,re.S)[0]
  vm=JassState(struct+'\n'+helper);globals_from(vm,text);ns=vm.structs['HarribelSpells_W'];ns.statics.update(MUI_HarribelW=-1,m_HarribelW={})
  c,u=vm.unit(owner=0),vm.unit(x=500.,owner=1);c.abilities[vm.g['HarribelE2_ID']]={'level':5};c.abilities[vm.g['HarribelW_ID']]={'level':5};locks=[];balance=[0]
  def lock(c,a,disabled,hide):locks.append(disabled);balance[0]+=1 if disabled else -1
  vm.g.update(hs={(id(c.owner),'morph'):1},SH_MORPH_E='morph',SH_W_SKILL='w',GAngle=lambda *_:0.,SR2=lambda a,b:math.hypot(a.x-b.x,a.y-b.y),GetHeroAgi=lambda *_:100.,GetHeroLevel=lambda _:35,BlzUnitDisableAbility=lock,GetUnitCurrentOrder=lambda _:1,OrderId=lambda _:1,DamageSourceVariant=lambda a,*_:a,SetUnitFacing=lambda *_:None,
   HarribelTick_On=lambda *_:None,HarribelTick_Off=lambda *_:None,MakeSound=lambda *_:None,StartSpellUnit=lambda *_:None,StopSpellUnit=lambda *_:None,StartSpellUnit2=lambda *_:None,
   EffectSpawn=vm.effect,EffectSpawnColor=vm.effect,EffectSpawn2=vm.effect,StunUnit=lambda *_:None,dmgphys=lambda *_:None)
  for _ in range(3):
   vm.run('HarribelW_Start',(c,u));fx=ns.m_HarribelW[0];fx.deallocate=lambda *_:None
   for tick in range(20):vm.run('Loop_HarribelW')
   self.assertEqual(1,balance[0])
   fx.r=999.;vm.run('Loop_HarribelW');self.assertEqual(0,balance[0]);self.assertEqual(-1,ns.MUI_HarribelW)
  self.assertEqual([True,False]*3,locks)
 def test_bambietta_te_emits_exactly_twenty_shells_in_the_original_channel(self):
  text=source('Heroes/Bambietta.j');struct=re.search(r'    private struct BambiettaSpells_E\b.*?    endstruct',text,re.S)[0];vm=JassState(struct);globals_from(vm,text);ns=vm.structs['BambiettaSpells_E'];ns.statics.update(MUI_BambiettaTE=0,m_BambiettaTE={})
  c=vm.unit();fx=ns.create();ns.m_BambiettaTE[0]=fx;fx.deallocate=lambda *_:None
  for k,v in dict(c=c,r=0.,rmax=vm.g['BambiettaTE_CastTime']+vm.g['BambiettaTE_Duration'],shellsFired=0).items():setattr(fx,k,v)
  shots=[];fx.BambiettaTE2_Start=lambda *args:shots.append(args);vm.g.update(SetUnitFacing=lambda *_:None,DebugUnit=lambda *_:None,DebugUnit2=lambda *_:None,GetMouseX=lambda _:100.,GetMouseY=lambda _:0.,GAngle2=lambda *_:0.,IntegerCdKey=lambda *_:False,BambiettaTE2_Start=lambda *args:shots.append(args),SH_ICD_SOUND_E='sound',MouseOff=lambda *_:None,StopSpellUnit=lambda *_:None,StopSpellUnit2=lambda *_:None,BambiettaTimer03Release=lambda *_:None)
  for _ in range(70):
   if ns.MUI_BambiettaTE<0:break
   vm.run('Loop_BambiettaTE')
  self.assertEqual(20,len(shots));self.assertEqual(20,fx.shellsFired);self.assertEqual(-1,ns.MUI_BambiettaTE)
  self.assertAlmostEqual(14.,vm.g['BambiettaTE_DamageDivisor'])
 def test_inori_base_hide_is_a_balanced_switch_not_a_periodic_counter(self):
  text=source('Heroes/Inori.j');helper=re.search(r'    private function InoriE_SetBaseHidden takes.*?endfunction',text,re.S)[0];vm=JassState(helper);calls=[];vm.g.update(hs={},SH_INORI_E_HIDDEN='hidden',InoriE_ID='E',BlzUnitHideAbility=lambda c,a,h:calls.append(h));c=vm.unit()
  for _ in range(3):
   for _ in range(100):vm.run('InoriE_SetBaseHidden',(c,True))
   for _ in range(100):vm.run('InoriE_SetBaseHidden',(c,False))
  self.assertEqual([True,False]*3,calls)
 def test_aura_description_keeps_passive_and_t1_upgrade_on_sixth_rank(self):
  import json
  obj=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
  text=obj['A061']['extended_tooltip level 6']
  for token in ('10% physical resistance','10% magic resistance','Instability','4 stacks','Void Absorption','8 sec','T2'):self.assertIn(token,text)
  ui=source('WOS_Start/ShowCD.j');self.assertIn('BlzFrameSetLevel(AHUI_ChargeBox[index], 112)',ui)

if __name__=='__main__':unittest.main()
