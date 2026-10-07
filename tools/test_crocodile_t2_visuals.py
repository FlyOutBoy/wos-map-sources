"""Run actual T2 VFX and damage methods against the user's latest source."""
import math
import re
import unittest
from pathlib import Path
import test_crocodile_t_ground as ground_tests
from test_crocodile_channel import SOURCE

PASTED=sorted((SOURCE.parents[2]/'backups').glob('crocodile-t2-krk-*/pasted-before.j'))[-1]


class VisualTests(unittest.TestCase):
    def setUp(self):
        self.helper=ground_tests.GroundTests(methodName='runTest')
        self.helper.setUp()
        self.vm,self.c=self.helper.vm,self.helper.c
        self.vm.g['EffectSpawn2']=self.effect_spawn2

    def effect_spawn2(self,*args):
        effect=self.vm.effect(*args)
        self.vm.g['MyRemoveEff'](effect,args[7])
        return effect

    def ground(self,radius):
        ground=self.helper.start()
        for patch in self.helper.patches(ground):
            patch.CrocodileTSand_Release(True)
        ground.patchHead=ground.growthHead=0
        ground.patchCount=0
        ground.maxReach=0.
        self.patch(ground,ground.x,ground.y,radius)
        return ground

    def patch(self,ground,x,y,radius,from_t=True):
        patch=self.vm.run('CrocodileTSand_Create',(x,y,radius/150.,.03,0.))
        patch.fromT=from_t
        patch.next=ground.patchHead
        ground.patchHead=patch
        ground.patchCount+=1
        ground.maxReach=max(ground.maxReach,math.hypot(x-ground.x,y-ground.y)+radius)
        return patch

    def effects(self,model=None):
        models=('war3mapImported\\wos_newdirtexnofire.mdl','war3mapImported\\wos_SandPoff.mdl','krk (1889)2.mdl')
        return [e for e in self.vm.effect_history if e.model in models and (model is None or e.model==model)]

    def check_ring(self,progress,points):
        self.c.x,self.c.y=100.,-500.
        radius=self.vm.g['CrocodileT_MaxAoe']*progress
        ground=self.ground(radius)
        timers=list(self.helper.fixture.timers)
        self.vm.run('CrocodileT2_CreateBlasts',(ground,))
        fires=self.effects('war3mapImported\\wos_newdirtexnofire.mdl')
        poffs=self.effects('war3mapImported\\wos_SandPoff.mdl')
        stones=self.effects('krk (1889)2.mdl')
        count=int(points*1.5+.5)
        self.assertEqual(points,self.vm.structs['CrocodileT2_Struct'].blastCount)
        self.assertEqual((points,points,count),(len(fires),len(poffs),len(stones)))
        factor=progress+.15
        for effects,maximum in ((fires,5.),(poffs,7.5)):
            for j,effect in enumerate(effects):
                angle=2*math.pi*j/points
                self.assertAlmostEqual(100.+radius*.55*math.cos(angle),effect.x)
                self.assertAlmostEqual(-500.+radius*.55*math.sin(angle),effect.y)
                self.assertAlmostEqual(maximum*factor,effect.scale)
                self.assertNotIn(id(effect),self.vm.effects)
        for j,effect in enumerate(stones):
            angle=2*math.pi*j/count # Default native mock samples the midpoint.
            distance=radius*.55+120.
            self.assertAlmostEqual(100.+distance*math.cos(angle),effect.x)
            self.assertAlmostEqual(-500.+distance*math.sin(angle),effect.y)
            self.assertAlmostEqual(3.*factor+.075,effect.scale)
            self.assertIn(id(effect),self.vm.effects)
        self.assertTrue(all((e.x,e.y)!=(100.,-500.) for e in self.effects()))
        self.assertEqual([],self.vm.scan_calls)
        self.assertEqual(timers,self.helper.fixture.timers)
        self.assertEqual(count,len({(round(e.x,5),round(e.y,5)) for e in stones}))
        self.helper.step(26)
        self.assertTrue(all(id(e) not in self.vm.effects for e in stones))

    def test_quarter_half_three_quarters_and_full_ring_counts_scales_positions(self):
        for progress,points in ((.25,3),(.5,6),(.75,9),(1.,12)):
            with self.subTest(progress=progress):
                self.setUp()
                self.check_ring(progress,points)

    def test_non_default_max_radius_and_tiny_radius_use_globals(self):
        self.vm.g['CrocodileT_MaxAoe']=3000.
        self.check_ring(.5,6)
        self.setUp()
        self.check_ring(50./self.vm.g['CrocodileT_MaxAoe'],3)

    def test_jitter_is_bounded_outward_and_stays_in_even_angular_sectors(self):
        for extreme in (0.,1.):
            with self.subTest(extreme=extreme):
                self.setUp()
                self.vm.g['GetRandomReal']=lambda low,high:low+(high-low)*extreme
                radius=self.vm.g['CrocodileT_MaxAoe']
                ground=self.ground(radius)
                self.vm.run('CrocodileT2_CreateBlasts',(ground,))
                stones=self.effects('krk (1889)2.mdl')
                self.assertEqual(18,len(stones))
                for j,effect in enumerate(stones):
                    actual=math.atan2(effect.y-ground.y,effect.x-ground.x)
                    expected=2*math.pi*j/18
                    delta=(actual-expected+math.pi)%(2*math.pi)-math.pi
                    self.assertLessEqual(abs(delta),math.radians(5.)+1e-6)
                    distance=math.hypot(effect.x-ground.x,effect.y-ground.y)
                    self.assertAlmostEqual(radius*.55+120.+(-50. if extreme==0 else 50.),distance)
                    self.assertGreater(distance,radius*.55)
                    self.assertGreaterEqual(effect.scale,(3.*1.15+.05)*.96-1e-6)
                    self.assertLessEqual(effect.scale,(3.*1.15+.1)*1.04+1e-6)

    def test_distant_cluster_does_not_change_main_ring_and_adds_only_one_krk(self):
        ground=self.ground(self.vm.g['CrocodileT_MaxAoe']*.5)
        self.patch(ground,10000.,0.,10000.,False)
        self.vm.run('CrocodileT2_CreateBlasts',(ground,))
        fires=self.effects('war3mapImported\\wos_newdirtexnofire.mdl')
        stones=self.effects('krk (1889)2.mdl')
        self.assertEqual(7,len(fires))
        self.assertEqual(10,len(stones)) # Nine main KRK + one cluster, no multiplier per cluster.
        for effect in fires[:6]:
            self.assertAlmostEqual(5.*.65,effect.scale)
        self.assertAlmostEqual(5.*1.15,fires[-1].scale)
        self.assertEqual((10000.,0.),(stones[-1].x,stones[-1].y))

    def test_covered_extra_sand_does_not_add_full_blast_at_caster(self):
        ground=self.ground(self.vm.g['CrocodileT_MaxAoe'])
        self.patch(ground,0.,0.,100.,False)
        self.vm.run('CrocodileT2_CreateBlasts',(ground,))
        self.assertEqual(12,self.vm.structs['CrocodileT2_Struct'].blastCount)
        self.assertEqual(42,len(self.effects()))
        self.assertTrue(all((e.x,e.y)!=(0.,0.) for e in self.effects()))

    def test_damage_union_hits_once_with_one_scan_and_sand_fades(self):
        ground=self.ground(400.)
        self.patch(ground,600.,0.,250.)
        self.vm.run('AddSand',(self.c,3000.,0.,250.,False))
        center=self.vm.unit(0.,0.)
        edge=self.vm.unit(800.,0.)
        far=self.vm.unit(3000.,0.)
        empty=self.vm.unit(600.,400.)
        ally=self.vm.unit(0.,0.,owner=self.c.owner)
        structure=self.vm.unit(100.,0.)
        self.helper.fixture.structures.add(id(structure))
        original=[p.e for p in self.helper.patches(ground)]
        sand=self.vm.structs['CrocodileSand_Struct']
        original+=[sand.m[i].e for i in range(sand.MUI+1)]
        self.vm.run('CrocodileT2_Detonate',(ground,))
        damage=self.c.agi*self.vm.g['CrocodileT2_DamageAgi']
        for u in (center,edge,far):
            self.assertEqual([damage],[amount for _,target,amount in self.vm.damage if target is u])
        for u in (empty,ally,structure):
            self.assertFalse(any(target is u for _,target,_ in self.vm.damage))
        self.assertEqual(1,len(self.vm.scan_calls))
        self.assertFalse(self.vm.groups)
        for effect in original:
            self.assertIn(id(effect),self.vm.effects)
            self.assertTrue(any(entry[0] is effect for entry in self.vm.fade_history))
        self.helper.step(30)
        self.assertTrue(all(id(effect) not in self.vm.effects for effect in original))

    def test_only_visual_methods_and_visual_globals_changed_from_latest_paste(self):
        original=PASTED.read_text(encoding='utf-8-sig')
        current=SOURCE.read_text(encoding='utf-8-sig')
        methods=lambda text:dict(re.findall(r'^\s*(?:static )?method (\w+) takes[^\n]*\n(.*?)\n\s*endmethod',text,re.M|re.S))
        before,after=methods(original),methods(current)
        self.assertEqual({'CrocodileT2_CreateKrkRing'},after.keys()-before.keys())
        self.assertEqual({'CrocodileT2_AddBlast','CrocodileT2_CreateBlasts'},
            {name for name in before if before[name]!=after[name]})
        self.assertIn('call ground.CrocodileT_Clear(false)',after['CrocodileT2_Detonate'])
        self.assertEqual(10.,self.vm.g['CrocodileT2_DamageAgi'])


if __name__=='__main__':
    unittest.main()
