"""Exercise current TEST methods; native Warcraft weapon/UI behavior remains a game check."""
import math
import unittest
import test_crocodile_channel as channel
import test_crocodile_f_volley as volley


class TornadoAndSandTests(unittest.TestCase):
    def setUp(self):
        self.fixture = channel.ContactAndChannelTests('runTest')
        self.fixture.setUp()
        self.vm, self.c = self.fixture.vm, self.fixture.c
        self.step = self.fixture.step
        self.landings = []
        self.vm.g['HeightSet'] = lambda u,t,h: self.landings.append((u,t,h))
        self.vm.g['ModuloInteger'] = lambda a,b: a % b
        self.baseline_users = self.vm.clock_users

    def start_r(self):
        self.assertTrue(self.vm.run('CrocodileR_Begin',(self.c,2500.,0.)))
        return self.vm.structs['CrocodileR_Struct'].m[0]

    def test_six_damage_pulses_timed_stun_smooth_pull_and_single_landing(self):
        target = self.vm.unit(100.,0.)
        tornado = self.start_r()
        scan = tornado.g
        self.step()
        self.assertEqual([(target,1.)],self.vm.stuns)
        self.assertFalse(target.paused)
        # The first move is a pull, not a snap to the outer radius.
        self.assertLessEqual(math.hypot(target.x-100.,target.y),1200.*.03+.001)
        for _ in range(82):
            self.step()
            self.assertLess(math.hypot(target.x-tornado.x,target.y-tornado.y),tornado.radius*.4)
        self.step()
        hits = [d for _,u,d in self.vm.damage if u is target]
        self.assertEqual([60.]*6,hits)
        self.assertEqual(6,tornado.hits)
        self.assertFalse(tornado.alive)
        self.assertEqual([(target,.5,0)],self.landings)
        self.assertFalse(self.c.paused)
        self.assertNotIn(id(scan),self.vm.groups)
        self.assertFalse(any(u is target for u,_ in self.vm.pause_history))
        self.step(10)
        self.assertEqual(1,len(self.landings))

    def test_exit_and_reentry_have_separate_capture_stun_and_landing(self):
        target = self.vm.unit(100.,0.)
        tornado = self.start_r()
        self.step(5)
        target.x,target.y = 8000.,8000.
        self.step()
        self.assertEqual([(target,.5,0)],self.landings)
        self.assertEqual(0,tornado.captured)
        self.step(3)
        self.assertEqual(1,len(self.landings))
        target.x,target.y = tornado.x+40.,tornado.y
        self.step()
        self.assertEqual([(target,1.),(target,1.)],self.vm.stuns)
        self.c.life = 0
        self.vm.run('Death',(self.c,))
        self.step()
        self.assertEqual(2,len(self.landings))
        self.assertFalse(tornado.alive)
        self.assertFalse(target.paused)
        self.assertFalse(self.vm.groups)

    def test_immune_target_not_captured_and_two_tornadoes_do_not_share_records(self):
        immune = self.vm.unit(100.,20.)
        immune.protection = 1
        target = self.vm.unit(100.,0.)
        first = self.start_r()
        other = self.vm.unit(owner=self.c.owner)
        other.type = self.c.type
        self.vm.hero(other)
        self.assertTrue(self.vm.run('CrocodileR_Begin',(other,2500.,0.)))
        second = self.vm.structs['CrocodileR_Struct'].m[1]
        self.step()
        self.assertNotEqual(0,first.captured)
        self.assertEqual(0,second.captured)
        self.assertEqual([(target,1.)],self.vm.stuns)
        self.assertEqual(100.,immune.x)

    def test_t_sand_outlives_t2_window_without_respawning_effects_or_timer(self):
        self.fixture.start_t()
        self.step(100)
        ground = self.fixture.state(4)
        patches = []
        patch = ground.patchHead
        while patch != 0:
            patches.append(patch)
            patch = patch.next
        effects = [p.e for p in patches]
        self.assertEqual(10.,ground.windowTime)
        self.assertEqual(30.,self.vm.g['CrocodileSand_GroundDuration'])
        count = len(self.vm.effect_history)
        self.step(337)
        sand = self.vm.structs['CrocodileSand_Struct']
        self.assertTrue(ground.endNow)
        self.assertEqual(len(effects),sand.MUI+1)
        self.assertFalse(self.fixture.timers)
        self.assertEqual(count,len(self.vm.effect_history))
        retained = [sand.m[i].e for i in range(sand.MUI+1)]
        self.assertEqual({id(e) for e in effects},{id(e) for e in retained})
        self.assertTrue(self.vm.run('CrocodileSand_IsOnGround',(self.c,self.c)))
        self.step(670)
        self.assertEqual(-1,sand.MUI)
        self.assertEqual(self.baseline_users,self.vm.clock_users)

    def test_ground_duration_is_shared_and_configurable(self):
        self.vm.g['CrocodileSand_GroundDuration'] = .3
        self.vm.run('CrocodileSand_Start',(self.c,1000.,0.,250.,False))
        sand = self.vm.structs['CrocodileSand_Struct']
        self.assertEqual(.3,sand.m[0].rmax)
        self.step(10)
        self.assertEqual(-1,sand.MUI)

    def test_w_continuous_pull_uses_cached_scan_group_and_frees_both_groups(self):
        near,edge = self.vm.unit(100.,0.),self.vm.unit(590.,0.)
        self.assertTrue(self.vm.run('CrocodileW_Begin',(self.c,0.,0.)))
        pit = self.vm.structs['CrocodileW_Struct'].m[0]
        self.step(18)
        p0,q0 = near.x,edge.x
        self.step()
        self.assertGreater(p0-near.x,q0-edge.x)
        p0 = near.x
        self.step()
        self.assertGreater(p0,near.x)
        self.assertFalse(self.vm.pulls)  # No new MUE instances per target.
        self.step(100)
        self.assertFalse(pit.alive)
        self.assertFalse(self.vm.groups)

    def test_w_combo_preserves_point_twenty_four_pull_instead_of_teleporting(self):
        target = self.vm.unit(400.,0.)
        self.assertTrue(self.vm.run('CrocodileW_Begin',(self.c,0.,0.)))
        pit = self.vm.structs['CrocodileW_Struct'].m[0]
        self.step(18)
        initial = target.x
        pit.CrocodileW_Combo()
        self.assertEqual(initial,target.x)
        self.step()
        self.assertGreater(target.x,0.)
        self.assertLess(target.x,initial)
        self.step(7)
        self.assertAlmostEqual(0.,target.x)
        self.assertEqual(0.,pit.comboPullTime)


class WeaponAndBladeTests(unittest.TestCase):
    def setUp(self):
        self.fixture = volley.VolleyTests('runTest')
        self.fixture.setUp()
        self.vm,self.c,self.f,self.target = self.fixture.vm,self.fixture.c,self.fixture.f,self.fixture.target
        self.step = self.fixture.step

    def weapons(self):
        return [w['UNIT_WEAPON_BF_ATTACKS_ENABLED'] for w in self.c.weapons]

    def test_no_stacks_melee_range_and_ready_single_weapon_restored_on_proc(self):
        self.assertEqual([True,False],self.weapons())
        self.assertEqual(175.,self.c.weapons[0]['UNIT_WEAPON_RF_ATTACK_RANGE'])
        self.assertFalse(self.vm.run('CrocodileF_Begin',(self.c,self.target)))
        self.assertEqual(100.,self.vm.run('CrocodileF_Attack',(self.c,self.target,100.)))
        for distance in (100.,500.,800.):
            with self.subTest(distance=distance):
                self.setUp()
                self.target.x = distance
                self.f.stacks = 1
                self.f.CrocodileF_SetEnhanced(True)
                self.assertEqual([True,False],self.weapons())
                self.assertEqual(800.,self.c.weapons[0]['UNIT_WEAPON_RF_ATTACK_RANGE'])
                self.vm.g.update({'GetAttacker':lambda:self.c,'GetTriggerUnit':lambda:self.target})
                self.vm.run('CrocodileF_OnAttack')
                self.assertEqual([True,False],self.weapons())
                self.assertEqual(175.,self.c.weapons[0]['UNIT_WEAPON_RF_ATTACK_RANGE'])
                self.assertEqual(0,self.f.stacks)
                self.assertIn('Abun',self.c.abilities)
                self.assertEqual(0.,self.vm.run('CrocodileF_Attack',(self.c,self.target,100.)))
                self.step(15)
                self.assertEqual([300.],self.fixture.target_hits())
                self.assertEqual([],self.fixture.blades())
                self.assertNotIn('Abun',self.c.abilities)

    def test_original_weapon_state_and_attack_speed_restored(self):
        for attack1,attack2 in ((True,False),(False,False),(True,True)):
            with self.subTest(original=(attack1,attack2)):
                self.setUp()
                for w,on in zip(self.c.weapons,(attack1,attack2)):
                    w['UNIT_WEAPON_BF_ATTACKS_ENABLED'] = on
                self.f.CrocodileF_SetEnhanced(True)
                self.assertEqual([True,False],self.weapons())
                self.assertIn('AIsx',self.c.abilities)
                self.f.CrocodileF_SetEnhanced(False)
                self.assertEqual([attack1,attack2],self.weapons())
                self.assertNotIn('AIsx',self.c.abilities)
                self.assertEqual(175.,self.c.weapons[0]['UNIT_WEAPON_RF_ATTACK_RANGE'])

    def test_two_stacks_restore_range_only_after_cooldown(self):
        self.fixture.attack(2)
        self.assertEqual([True,False],self.weapons())
        self.assertEqual(175.,self.c.weapons[0]['UNIT_WEAPON_RF_ATTACK_RANGE'])
        self.step(66)
        self.assertFalse(self.f.enhanced)
        self.assertEqual(175.,self.c.weapons[0]['UNIT_WEAPON_RF_ATTACK_RANGE'])
        self.step(2)
        self.assertEqual([True,False],self.weapons())
        self.assertEqual(800.,self.c.weapons[0]['UNIT_WEAPON_RF_ATTACK_RANGE'])
        self.assertTrue(self.f.enhanced)
        self.assertEqual(1,self.f.stacks)

    def test_range_is_saved_once_and_repeated_enhancing_does_not_accumulate(self):
        self.c.weapons[0]['UNIT_WEAPON_RF_ATTACK_RANGE'] = 225.
        for _ in range(3):
            self.f.CrocodileF_SetEnhanced(True)
            self.f.CrocodileF_SetEnhanced(True)
            self.assertEqual(800.,self.c.weapons[0]['UNIT_WEAPON_RF_ATTACK_RANGE'])
            self.f.CrocodileF_SetEnhanced(False)
            self.f.CrocodileF_SetEnhanced(False)
            self.assertEqual(225.,self.c.weapons[0]['UNIT_WEAPON_RF_ATTACK_RANGE'])
        self.assertEqual([800.,225.]*3,[r for _,r in self.vm.range_history])
        self.assertEqual(800.,self.c.weapons[1]['UNIT_WEAPON_RF_ATTACK_RANGE'])

    def test_death_and_loss_of_f_restore_melee_range(self):
        for reason in ('death','ability'):
            with self.subTest(reason=reason):
                self.setUp()
                self.f.stacks = 1
                self.f.CrocodileF_SetEnhanced(True)
                if reason == 'death':
                    self.c.life = 0
                    self.vm.run('Death',(self.c,))
                else:
                    self.vm.remove_ability(self.c,self.vm.g['CrocodileF_ID'])
                self.step()
                self.assertEqual(175.,self.c.weapons[0]['UNIT_WEAPON_RF_ATTACK_RANGE'])
                self.assertEqual([True,False],self.weapons())

    def test_triple_creation_delay_scale_animation_speed_full_range_and_unique_hit(self):
        self.fixture.attack(3)
        self.step(15)
        blades = self.fixture.blades()
        self.assertEqual(3,len(blades))
        for e in blades:
            self.assertAlmostEqual(6.1875*.85,e.scale)
        self.assertTrue(all(e.timescale == 1. for e in blades))
        projectile = self.vm.structs['CrocodileF_Projectile'].m[0]
        self.assertEqual(0.,projectile.distance)
        self.step(4)
        self.assertEqual(0.,projectile.distance)
        self.assertEqual([],self.vm.damage)
        self.step()
        self.assertAlmostEqual(2160.*1.15*.03,projectile.distance)
        self.step(22)
        self.assertFalse(projectile.alive)
        self.assertAlmostEqual(1700.,projectile.distance)
        self.assertEqual([900.],self.fixture.target_hits())
        for e in blades:
            self.assertAlmostEqual(1700.,math.hypot(e.x-self.c.x,e.y-self.c.y))
        self.assertFalse(self.vm.groups)

    def test_caster_dies_while_blades_wait_no_hits_and_groups_freed(self):
        self.fixture.attack(3)
        self.step(15)
        self.c.life = 0
        self.vm.run('Death',(self.c,))
        self.step(20)
        self.assertEqual([],self.vm.damage)
        self.assertFalse(self.vm.groups)
        self.assertTrue(all(id(e) not in self.vm.effects for e in self.fixture.blades()))


if __name__ == '__main__':
    unittest.main()
