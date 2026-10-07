"""Run actual W/R methods against native mocks, including owner and lifetime boundaries."""
import math
import unittest
import test_crocodile_channel as channel


class TornadoPitTests(unittest.TestCase):
    def setUp(self):
        self.fixture = channel.ContactAndChannelTests('runTest')
        self.fixture.setUp()
        self.vm,self.c = self.fixture.vm,self.fixture.c
        self.time = 0.
        self.hits = []
        self.landings = []
        self.visual_end = []
        self.vm.g.update({
            'HeightSet':lambda u,t,h:self.landings.append((u,t,h)),
            'EffectSpawnColor':self.color_effect,
            'EffectSpawn':self.effect,
            'ScaleEffDummy':lambda e,*args:self.visual_end.append((self.time,e)),
            'dmgphys':self.damage,
        })

    def effect(self,*args):
        e = self.vm.effect(*args)
        e.timescale = args[4]
        e.height = args[6]
        return e

    def color_effect(self,*args):
        e = self.effect(*args[:7])
        e.rgb,e.alpha = args[7:10],args[10]
        e.spawn_time = round(self.time,3)
        return e

    def damage(self,c,u,d):
        self.vm.damage.append((c,u,d))
        self.hits.append((round(self.time,3),c,u,d))

    def step(self,n=1):
        for _ in range(n):
            self.time += .03
            self.fixture.step()

    def w(self,x=900.,y=0.,caster=None):
        self.assertTrue(self.vm.run('CrocodileW_Begin',(caster or self.c,x,y)))
        cls = self.vm.structs['CrocodileW_Struct']
        return cls.m[cls.MUI]

    def r(self,caster=None):
        self.assertTrue(self.vm.run('CrocodileR_Begin',(caster or self.c,4000.,0.)))
        cls = self.vm.structs['CrocodileR_Struct']
        return cls.m[cls.MUI]

    def combo_effects(self):
        return [e for e in self.vm.effect_history if 'YeYe_Wid_KuoSan_3' in e.model]

    def own_other(self,owner=0):
        c = self.vm.unit(owner=owner)
        c.type = self.c.type
        self.vm.hero(c)
        return c

    def test_inner_zone_then_smooth_centering_without_teleport_or_new_trail(self):
        pit = self.w()
        self.step(18)
        tornado = self.r()
        self.step(14)
        self.assertAlmostEqual(315.,tornado.x)  # Inside W radius 600, outside inner 300.
        self.assertFalse(tornado.stoppedByW)
        self.step(6)
        self.assertAlmostEqual(450.,tornado.x)
        self.assertFalse(tornado.stoppedByW)
        self.step(7)
        self.assertTrue(tornado.stoppedByW)
        self.assertAlmostEqual(607.5,tornado.x)
        self.assertNotEqual(pit.x,tornado.x)
        point = tornado.x,tornado.y
        self.assertEqual(3.1,tornado.rmax)
        self.assertAlmostEqual(4.11,pit.rmax)
        sand_distance = tornado.sandDistance
        sand = self.vm.structs['CrocodileSand_Struct']
        patches = sand.MUI
        for _ in range(20):
            previous = tornado.x,tornado.y
            self.step()
            self.assertLessEqual(math.dist(previous,(tornado.x,tornado.y)),22.5+.001)
            self.assertLessEqual(tornado.x,pit.x+.001)
        self.assertEqual((pit.x,pit.y),(tornado.x,tornado.y))
        self.assertEqual((pit.x,pit.y),(tornado.e.x,tornado.e.y))
        self.assertEqual((pit.x,pit.y),(tornado.e2.x,tornado.e2.y))
        self.assertEqual(sand_distance,tornado.sandDistance)
        self.assertEqual(patches,sand.MUI)
        effects = self.combo_effects()
        self.assertEqual(6,len(effects))
        self.assertEqual(point,(effects[0].x,effects[0].y))
        self.assertEqual([607.5,697.5,787.5,877.5,900.,900.],[e.x for e in effects])
        for e in effects:
            self.assertEqual((255,205,120),e.rgb)
            self.assertEqual(255,e.alpha)
            self.assertEqual(1.,e.scale)
            self.assertEqual(30.,e.height)
            self.assertNotIn(id(e),self.vm.effects)
            self.assertFalse(any(f is e for f,_ in self.vm.timed_effects))
        for first,second in zip(effects,effects[1:]):
            self.assertAlmostEqual(.12,second.spawn_time-first.spawn_time)
        self.step(15)
        self.assertEqual(9,len(self.combo_effects()))
        self.assertEqual(3.1,tornado.rmax)
        self.assertAlmostEqual(4.11,pit.rmax)

    def test_radius_and_visual_multiplier_are_exact_and_do_not_accumulate(self):
        self.w()
        self.step(18)
        tornado = self.r()
        self.step(27)
        for _ in range(20):
            progress = min(1.,tornado.r/2.5)
            self.assertAlmostEqual((200.+200.*progress)*1.15,tornado.radius)
            self.assertAlmostEqual((.1+(.85-.1)*progress)*1.15,tornado.e.scale)
            self.assertAlmostEqual(.1*1.15,tornado.e2.scale)
            self.assertEqual(2.,tornado.e2.timescale)
            self.step()

    def test_grazing_outer_w_never_stops_r(self):
        self.w(900.,450.)
        self.step(18)
        tornado = self.r()
        self.step(84)
        self.assertFalse(tornado.stoppedByW)
        self.assertFalse(tornado.alive)
        self.assertAlmostEqual(750.*.03*84,tornado.x)
        self.assertEqual([],self.combo_effects())

    def test_other_crocodile_even_same_owner_cannot_link_and_state_is_mui(self):
        other = self.own_other()
        pit = self.w(caster=other)
        self.step(18)
        first,second = self.r(),self.r(other)
        self.step(27)
        self.assertFalse(first.stoppedByW)
        self.assertTrue(second.stoppedByW)
        self.assertFalse(pit.combo)
        self.step(20)
        self.assertGreater(first.x,second.x)
        self.assertEqual(6,len(self.combo_effects()))

    def test_start_phase_not_eligible_and_expired_pit_removed(self):
        pit = self.w(200.,0.)
        tornado = self.r()
        self.step(17)
        self.assertFalse(tornado.stoppedByW)
        self.step()
        self.assertTrue(tornado.stoppedByW)
        self.assertAlmostEqual(405.,tornado.x)
        center = pit.x
        pit.rmax = pit.r+.03
        self.step()
        self.assertFalse(pit.alive)
        pit.x = 9999.  # Reused/destroyed W storage must not steer R.
        self.step(10)
        self.assertTrue(tornado.alive)
        self.assertAlmostEqual(center,tornado.x)
        self.assertEqual(3,len(self.combo_effects()))

    def test_nearest_active_own_pit_extended_only_once(self):
        far,near = self.w(250.,0.),self.w(100.,0.)
        self.step(18)
        far.r,near.r = 3.2,3.2
        far.hits,near.hits = 6,6
        tornado = self.r()
        self.step()
        self.assertTrue(tornado.stoppedByW)
        self.assertAlmostEqual(3.51,far.rmax)
        self.assertAlmostEqual(near.r+3.1-tornado.r,near.rmax)
        self.assertEqual(3.1,tornado.rmax)
        deadline = near.rmax
        self.step(3)
        self.assertEqual(deadline,near.rmax)
        self.assertEqual(1,len(self.combo_effects()))

    def test_configurable_center_radius_and_effect_scale(self):
        self.vm.g['CrocodileWR_ComboCenterRadius'] = 250.
        self.vm.g['CrocodileWR_ComboEffectScale'] = 1.8
        self.w()
        self.step(18)
        tornado = self.r()
        self.step(28)
        self.assertFalse(tornado.stoppedByW)
        self.step()
        self.assertTrue(tornado.stoppedByW)
        self.assertAlmostEqual(652.5,tornado.x)
        self.assertEqual(1.8,self.combo_effects()[0].scale)

    def test_extension_keeps_six_original_w_hits_pull_visuals_and_r_deadline(self):
        target = self.vm.unit(900.,0.)
        pit = self.w()
        w_effect = pit.e
        scan,pull = pit.g,pit.pullGroup
        self.step(70)
        tornado = self.r()
        r_scan = tornado.g
        r_effects = tornado.e,tornado.e2
        self.step(27)
        self.assertTrue(tornado.stoppedByW)
        self.assertGreater(pit.rmax,3.51)
        self.assertEqual(3.51,pit.damageRmax)
        self.assertEqual(3.1,tornado.rmax)
        self.step(21)
        w_hits = [t for t,c,u,d in self.hits if u is target and d == 75.]
        self.assertEqual([.6,1.17,1.77,2.34,2.94,3.51],w_hits)
        self.assertEqual(6,pit.hits)
        self.assertTrue(pit.alive)
        self.assertFalse(any(e is w_effect for _,e in self.visual_end))
        distant = self.vm.unit(1400.,0.)
        self.step(5)
        initial = distant.x
        self.step()
        self.assertLess(distant.x,initial)
        self.step(30)
        self.assertTrue(tornado.alive)
        self.assertTrue(pit.alive)
        self.assertEqual(6,tornado.hits)
        self.step(21)
        self.assertFalse(pit.alive)
        self.assertFalse(tornado.alive)
        self.assertNotIn(id(scan),self.vm.groups)
        self.assertNotIn(id(pull),self.vm.groups)
        self.assertNotIn(id(r_scan),self.vm.groups)
        self.assertTrue(all(id(e) not in self.vm.effects for e in r_effects))
        self.assertEqual([.6,1.17,1.77,2.34,2.94,3.51],[t for t,c,u,d in self.hits if u is target and d == 75.])
        self.assertEqual(1,len([e for _,e in self.visual_end if e is w_effect]))

    def test_unneeded_extension_does_not_shorten_w_and_q_combo_is_independent(self):
        pit = self.w()
        self.step(18)
        tornado = self.r()
        self.step(27)
        self.assertAlmostEqual(4.11,pit.rmax)
        self.assertFalse(pit.combo)
        victim = self.vm.unit(pit.x+20.,pit.y)
        pit.CrocodileW_Combo()
        self.assertTrue(pit.combo)
        self.assertTrue(tornado.stoppedByW)
        self.assertIn((self.c,victim,300.),self.vm.damage)
        self.assertIn((victim,1.5),self.vm.stuns)
        self.assertEqual(.24,pit.comboPullTime)
        pit.CrocodileW_Combo()
        self.assertEqual(1,len([d for c,u,d in self.vm.damage if u is victim and d == 300.]))

    def test_captured_units_keep_orbit_around_stop_point_and_new_enemies_enter_bonus_radius(self):
        victim = self.vm.unit(100.,0.)
        self.w()
        self.step(18)
        tornado = self.r()
        self.step(27)
        self.assertTrue(tornado.stoppedByW)
        self.assertNotEqual(0,tornado.captured)
        self.assertLess(math.hypot(victim.x-tornado.x,victim.y-tornado.y),tornado.radius*.4)
        base = tornado.radius/1.15
        late = self.vm.unit(tornado.x,base*1.08)
        self.step()
        key = self.vm.g['CrocodileR_TargetKey']
        self.assertNotEqual(0,self.vm.g['LoadInteger'](self.vm.g['CrocodileTable'],id(late),key))
        self.step(56)
        self.assertEqual([60.]*6,[d for _,u,d in self.vm.damage if u is victim and d == 60.])
        self.assertTrue(tornado.alive)
        self.step(20)
        self.assertEqual(1,len([u for u,_,_ in self.landings if u is victim]))
        self.assertEqual(1,len([u for u,_,_ in self.landings if u is late]))
        self.assertFalse(victim.paused)
        self.assertFalse(late.paused)

    def test_caster_death_releases_both_areas_and_captured_targets(self):
        victim = self.vm.unit(100.,0.)
        pit = self.w()
        self.step(18)
        tornado = self.r()
        self.step(27)
        self.assertTrue(tornado.stoppedByW)
        groups = pit.g,pit.pullGroup,tornado.g
        self.c.life = 0
        self.vm.run('Death',(self.c,))
        self.step()
        self.assertFalse(pit.alive)
        self.assertFalse(tornado.alive)
        self.assertFalse(self.c.paused)
        self.assertFalse(victim.paused)
        self.assertEqual(1,len([u for u,_,_ in self.landings if u is victim]))
        self.assertTrue(all(id(g) not in self.vm.groups for g in groups))
        count = len(self.combo_effects())
        self.step(35)
        self.assertEqual(count,len(self.combo_effects()))
        self.assertTrue(all(id(e) not in self.vm.effects for e in self.combo_effects()))

    def test_off_axis_centering_clamps_last_step_and_moves_both_effects(self):
        pit = self.w(900.,200.)
        self.step(18)
        tornado = self.r()
        while not tornado.stoppedByW:
            self.step()
        self.assertNotEqual(pit.y,tornado.y)
        distance = math.dist((tornado.x,tornado.y),(pit.x,pit.y))
        for _ in range(20):
            previous = tornado.x,tornado.y
            self.step()
            current = tornado.x,tornado.y
            next_distance = math.dist(current,(pit.x,pit.y))
            self.assertLessEqual(next_distance,distance+.001)
            self.assertLessEqual(math.dist(previous,current),22.5+.001)
            self.assertEqual(current,(tornado.e.x,tornado.e.y))
            self.assertEqual(current,(tornado.e2.x,tornado.e2.y))
            distance = next_distance
        self.assertAlmostEqual(0.,distance)
        self.assertEqual(6,len(self.combo_effects()))
        self.assertEqual(3.1,tornado.rmax)

    def test_bonus_period_configurable_once_and_repeated_effects_stop_at_cleanup(self):
        self.vm.g['CrocodileWR_ComboEffectPeriod'] = .18
        self.vm.g['CrocodileWR_DurationBonus'] = .9
        pit = self.w()
        self.step(18)
        tornado = self.r()
        self.step(27)
        self.assertEqual(3.4,tornado.rmax)
        self.assertAlmostEqual(4.41,pit.rmax)
        self.step(100)
        self.assertFalse(tornado.alive)
        self.assertEqual(6,tornado.hits)
        self.assertAlmostEqual(4.41,pit.rmax)
        effects = self.combo_effects()
        for first,second in zip(effects,effects[1:]):
            self.assertAlmostEqual(.18,second.spawn_time-first.spawn_time)
        self.assertTrue(all(id(e) not in self.vm.effects for e in effects))
        self.assertTrue(all(not any(f is e for f,_ in self.vm.timed_effects) for e in effects))
        self.step(10)
        self.assertEqual(len(effects),len(self.combo_effects()))


if __name__ == '__main__':
    unittest.main()
