"""Run MAIN movement and per-target damage paths; Warcraft still owns native pathing."""
import json
import math
import re
import unittest
from pathlib import Path
import test_crocodile_main_integration as main
from test_crocodile import JassState

ROOT=Path(__file__).resolve().parents[1]


class CrocodileMovementFollowup(unittest.TestCase):
    def setUp(self):
        self.fixture=main.MainIntegration('runTest')
        self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)
        self.vm,self.c=self.fixture.vm,self.fixture.c
        self.vm.g.update(HeightSet=lambda u,t,h:setattr(u,'height',h),
                         EffectSpawnColor=self.vm.effect)

    def tornado(self):
        self.assertTrue(self.vm.run('CrocodileR_Begin',(self.c,4000.,0.)))
        return self.vm.structs['CrocodileR_Struct'].m[0]

    def damage(self,target):
        return [d for _,u,d in self.vm.damage if u is target]

    def test_r_each_target_gets_five_hits_then_only_pull_even_on_late_contact(self):
        early=self.vm.unit(100.,0.)
        r=self.tornado()
        self.fixture.step(20)
        late=self.vm.unit(r.x+30.,r.y)
        self.fixture.step(29)
        self.assertEqual(5,len(self.damage(early)))
        self.assertEqual(5,len(self.damage(late)))
        for _ in range(20):
            early.x+=15. # An ordinary movement attempt must not escape the central pull.
            self.fixture.step()
            self.assertLess(self.vm.g['SR3'](early,r.x,r.y),r.radius*.35)
        self.assertEqual(5,len(self.damage(early)))
        self.assertEqual(5,len(self.damage(late)))
        self.fixture.step(20)
        self.assertFalse(r.alive)
        self.assertEqual(0,r.captured)

    def test_w_level_35_halves_pause_and_preserves_full_field_radius(self):
        for level,pause_ticks in ((34,15),(35,8)):
            self.c.hero_level=level
            self.assertTrue(self.vm.run('CrocodileW_Begin',(self.c,900.,0.)))
            ns=self.vm.structs['CrocodileW_Struct'];w=ns.m[ns.MUI]
            self.assertEqual(800.,w.radius)
            self.assertTrue(w.castPauseHeld)
            self.fixture.step(pause_ticks-1)
            self.assertTrue(w.castPauseHeld)
            self.fixture.step()
            self.assertFalse(w.castPauseHeld)
            self.assertEqual(3.51,w.rmax)

    def test_w_q_combo_recognizes_new_outer_200_radius(self):
        self.vm.run('CrocodileW_Begin',(self.c,1000.,900.))
        w=self.vm.structs['CrocodileW_Struct'].m[0]
        self.vm.run('CrocodileQ_Begin',(self.c,2500.,0.))
        self.fixture.step(50)
        self.assertTrue(w.combo)
        self.assertEqual(800.,w.radius)

    def test_w_r_combo_centers_once_and_extends_current_map_durations(self):
        self.vm.run('CrocodileW_Begin',(self.c,900.,0.))
        w=self.vm.structs['CrocodileW_Struct'].m[0]
        self.fixture.step(18)
        r=self.tornado()
        base_w,base_r=w.rmax,r.rmax
        self.fixture.step(40)
        bonus=self.vm.g['CrocodileWR_DurationBonus']
        self.assertTrue(r.stoppedByW)
        self.assertAlmostEqual(900.,r.x)
        self.assertAlmostEqual(base_w+bonus,w.rmax)
        self.assertAlmostEqual(base_r+bonus,r.rmax)
        self.fixture.step(10)
        self.assertAlmostEqual(base_w+bonus,w.rmax)
        self.assertAlmostEqual(base_r+bonus,r.rmax)

    def test_native_crocodile_e_cooldowns_are_used_for_charge_recovery(self):
        native=json.loads((ROOT/'object-data/abilities.json').read_text('utf8'))
        ability=self.c.abilities[self.vm.g['CrocodileE_ID']]
        cooldowns=[native[self.vm.g['CrocodileE_ID']][f'cooldown level {i}'] for i in range(1,6)]
        self.assertEqual([21.,20.,19.,18.,17.],cooldowns)
        ability['cooldowns']=cooldowns
        data=self.fixture.state(1)
        for rank,seconds in enumerate(cooldowns,1):
            ability['level']=rank
            data.charge1=data.charge2=data.charge3=data.useCooldown=0.
            self.assertTrue(self.vm.run('CrocodileE_Begin',(self.c,750.,0.)))
            self.assertEqual(seconds,data.charge1)
            self.vm.run('CrocodileE_Finish',obj=data)


class AlucardEContact(unittest.TestCase):
    def fixture(self):
        source=(ROOT/'triggers/Heroes/Alucard.j').read_text('utf-8-sig')
        globals_text='\n'.join(re.findall(r'(?m)^\s*globals\b.*?\bendglobals',source,re.S))
        globals_text=re.sub(r'//[^\n]*','',globals_text)
        body=re.search(r'    private struct AlucardSpells_E\b.*?    endstruct',source,re.S)[0]
        vm=JassState(globals_text+'\n'+body)
        ns=vm.structs['AlucardSpells_E'];ns.statics.update(MUI_AlucardE=-1,m_AlucardE={})
        caster=vm.unit(x=500.,y=700.,owner=0)
        vm.add_ability(caster,vm.g['AlucardE_ID'])
        heroes=set()
        vm.g.update(hs={},AlucardTick_On=lambda *a:None,AlucardTick_Off=lambda *a:None,
                    GAngle2=lambda u,x,y:math.atan2(y-u.y,x-u.x),
                    SetUnitFacing=lambda u,a:setattr(u,'facing',a),
                    ColorEffDummy4=lambda *a:None,BlzPlaySpecialEffect=lambda *a:None,
                    BlzSetSpecialEffectTimeScale=lambda *a:None,BlzSetSpecialEffectPosition=lambda e,x,y,z:(setattr(e,'x',x),setattr(e,'y',y)),
                    ANIM_TYPE_WALK='walk',ANIM_TYPE_ATTACK='attack',UNIT_TYPE_HERO='hero',
                    IsUnitType=lambda u,t:id(u) in heroes if t=='hero' else False,
                    SetUnitAnimationByIndex=lambda *a:None,GroupClear=lambda g:g.clear())
        move=vm.g['MoveEff'];vm.g['MoveEff']=lambda e,d,a:move(e,d,a) if e is not None else None
        return vm,ns,caster,heroes

    def test_point_blank_e_hits_on_launch_before_first_move_and_never_twice(self):
        for dx,dy in ((1.,0.),(20.,100.),(20.,-100.),(140.,0.)):
            vm,ns,caster,heroes=self.fixture()
            enemy=vm.unit(x=caster.x+dx,y=caster.y+dy);heroes.add(id(enemy))
            vm.run('AlucardE_Start',(caster,caster.x+1600.,caster.y))
            data=ns.m_AlucardE[0]
            data.deallocate=lambda *_:setattr(data,'alive',False)
            for _ in range(9):vm.run('Loop_AlucardE')
            self.assertEqual([],vm.damage)
            vm.run('Loop_AlucardE')
            self.assertEqual([enemy],[u for c,u,d in vm.damage])
            self.assertEqual(1,data.k2)
            self.assertEqual(1,len(vm.slows))
            vm.run('Loop_AlucardE')
            self.assertEqual(1,len(vm.damage))
            self.assertEqual(-1,ns.MUI_AlucardE)
            self.assertEqual(set(),vm.groups)

    def test_e_still_hits_distant_target_once_after_flying(self):
        vm,ns,caster,heroes=self.fixture()
        enemy=vm.unit(x=caster.x+700.,y=caster.y);heroes.add(id(enemy))
        vm.run('AlucardE_Start',(caster,caster.x+1600.,caster.y))
        data=ns.m_AlucardE[0];data.deallocate=lambda *_:setattr(data,'alive',False)
        for _ in range(10):vm.run('Loop_AlucardE')
        self.assertEqual([],vm.damage)
        for _ in range(30):vm.run('Loop_AlucardE')
        self.assertEqual([enemy],[u for c,u,d in vm.damage])
        self.assertEqual(-1,ns.MUI_AlucardE)
        self.assertEqual(set(),vm.groups)

    def test_frostnova_recommended_items_match_current_barragan_slots(self):
        text=(ROOT/'triggers/Systems/Systems1.j').read_text('utf-8-sig')
        block=lambda hero:re.search(r'if id == '+hero+r'_ID then(.*?)endif',text[text.index('function RecommenedItems'):],re.S)[1]
        slots=lambda hero:re.findall(r'set ItemsPage0_ID\[i2\+(\d+)\] = \'([^\']+)\'',block(hero))
        self.assertEqual(6,len(slots('Frostnova')))
        self.assertEqual(slots('Barragan'),slots('Frostnova'))


if __name__=='__main__':
    unittest.main()
