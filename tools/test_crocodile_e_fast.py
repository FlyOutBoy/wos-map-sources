"""Execute current E and sand methods, including synchronous damage callbacks."""
import math
import unittest
import test_crocodile_channel as channel


class FastDashTests(unittest.TestCase):
    def setUp(self):
        self.fixture=channel.ContactAndChannelTests(methodName='runTest')
        self.fixture.setUp()
        self.vm,self.c,self.e=self.fixture.vm,self.fixture.c,self.fixture.e
        self.step=self.fixture.step

    def start(self,x=750.,y=0.):
        self.assertTrue(self.vm.run('CrocodileE_Begin',(self.c,x,y)))

    def contact(self):
        for _ in range(30):
            self.step()
            if self.e.hitStarted:
                return
        self.fail('No swept-front contact')

    def hits(self,target):
        return [d for _,u,d in self.vm.damage if u is target]

    def test_five_pulses_over_point_twelve_and_resume_on_fifth_update(self):
        target=self.vm.unit(200.,0.)
        self.start()
        self.contact()
        contact_time=self.e.elapsed
        position=self.c.x
        slash=self.e.e2
        self.assertEqual(1,len(self.hits(target)))
        for tick in range(1,5):
            self.step()
            self.assertEqual(tick+1,len(self.hits(target)))
            if tick < 4:
                self.assertEqual(position,self.c.x)
            else:
                self.assertGreater(self.c.x,position)
                self.assertEqual(0.,self.e.hitRemaining)
                self.assertIsNone(self.e.e2)
                self.assertEqual('death',slash.animation)
                self.assertEqual(1.,self.c.timescale)
        self.assertAlmostEqual(.12,self.e.elapsed-contact_time)
        self.assertAlmostEqual(self.e.dmg,sum(self.hits(target)))
        self.step(15)
        self.assertAlmostEqual(self.vm.g['CrocodileE_Distance'],self.c.x)
        self.assertFalse(self.e.active)
        self.assertFalse(self.c.paused)
        self.assertEqual(5,len(self.hits(target)))
        self.assertFalse(self.vm.groups)

    def test_aoe_filter_and_single_contact_sand_patch(self):
        target=self.vm.unit(200.,0.)
        ally=self.vm.unit(200.,20.,owner=self.c.owner)
        structure=self.vm.unit(200.,30.)
        dead=self.vm.unit(200.,40.)
        dead.life=0
        self.fixture.structures.add(id(structure))
        self.start()
        self.contact()
        self.step(20)
        self.assertEqual(5,len(self.hits(target)))
        for u in (ally,structure,dead):
            self.assertEqual([],self.hits(u))
        self.assertEqual(5,sum('Albatross' in model for model,_,_ in self.fixture.attachments))
        self.assertEqual(1,sum('StampedeMissileDeath' in effect.model for effect in self.vm.effect_history))
        self.assertEqual(0,self.vm.structs['CrocodileSand_Struct'].MUI)

    def test_no_contact_restores_animation_speed_pause_and_group(self):
        self.start()
        self.step(20)
        self.assertFalse(self.e.hitStarted)
        self.assertEqual([],self.vm.damage)
        self.assertAlmostEqual(750.,self.c.x)
        self.assertEqual(1.,self.c.timescale)
        self.assertFalse(self.c.paused)
        self.assertFalse(self.vm.groups)

    def test_angle_and_moving_target_use_live_position_and_swept_front(self):
        for angle in (0.,math.pi/2,math.pi,math.pi*1.5):
            with self.subTest(angle=angle):
                self.setUp()
                target=self.vm.unit(10000.,10000.)
                self.start(750.*math.cos(angle),750.*math.sin(angle))
                self.step(3)
                target.x,target.y=600.*math.cos(angle),600.*math.sin(angle)
                self.contact()
                self.assertAlmostEqual(self.c.x+150.*math.cos(angle),self.e.hitX)
                self.assertAlmostEqual(self.c.y+150.*math.sin(angle),self.e.hitY)
                self.step(20)
                self.assertEqual(5,len(self.hits(target)))
                self.assertAlmostEqual(750.*math.cos(angle),self.c.x)
                self.assertAlmostEqual(750.*math.sin(angle),self.c.y)

    def test_dying_during_pulse_stops_other_targets_and_movement(self):
        first=self.vm.unit(200.,0.)
        other=self.vm.unit(200.,20.)
        original=self.vm.g['dmgphys']
        def damage(c,u,d):
            original(c,u,d)
            c.life=0
            self.vm.run('Death',(c,))
        self.vm.g['dmgphys']=damage
        self.start()
        self.contact()
        position=self.c.x
        self.step(10)
        self.assertEqual(1,len(self.hits(first)))
        self.assertEqual([],self.hits(other))
        self.assertEqual(position,self.c.x)
        self.assertFalse(self.e.active)
        self.assertFalse(self.c.paused)
        self.assertFalse(self.vm.groups)
        self.assertEqual(1.,self.c.timescale)

    def test_configurable_ticks_one_tick_and_longer_five_tick_hold(self):
        for ticks,delay in ((1,.12),(5,.24)):
            with self.subTest(ticks=ticks):
                self.setUp()
                self.vm.g['CrocodileE_HitTicks']=ticks
                self.vm.g['CrocodileE_HitDelay']=delay
                target=self.vm.unit(200.,0.)
                self.start()
                self.contact()
                position=self.c.x
                elapsed=self.e.elapsed
                if ticks==1:
                    self.assertEqual(0.,self.e.hitRemaining)
                    self.step()
                    self.assertGreater(self.c.x,position)
                else:
                    self.step(7)
                    self.assertEqual(4,len(self.hits(target)))
                    self.assertEqual(position,self.c.x)
                    self.step()
                    self.assertEqual(5,len(self.hits(target)))
                    self.assertGreater(self.c.x,position)
                    self.assertAlmostEqual(.24,self.e.elapsed-elapsed)
                self.assertAlmostEqual(self.e.dmg,sum(self.hits(target)))

    def test_blocked_terrain_timeout_frees_cast(self):
        self.vm.g['IsTerrainPathable']=lambda *args:True
        self.start()
        self.step(105)
        self.assertEqual((0.,0.),(self.c.x,self.c.y))
        self.assertFalse(self.e.active)
        self.assertFalse(self.c.paused)
        self.assertFalse(self.vm.groups)
        self.assertEqual(1.,self.c.timescale)

    def test_repeat_cast_charges_remain_independent(self):
        for _ in range(3):
            self.start(self.c.x+750.,self.c.y)
            self.step(34)
            self.assertFalse(self.e.active)
            self.assertFalse(self.c.paused)
            self.assertFalse(self.vm.groups)
        self.assertAlmostEqual(2250.,self.c.x)

    def test_sand_refresh_reuses_visual_and_membership_uses_exact_circle(self):
        self.vm.run('AddSand',(self.c,100.,0.,200.,False))
        sand=self.vm.structs['CrocodileSand_Struct'].m[0]
        effect=sand.e
        self.vm.run('AddSand',(self.c,100.,0.,600.,False))
        self.assertIs(effect,sand.e)
        self.assertEqual(1,sum('wos_ysjsm45.mdl' in e.model for e in self.vm.effect_history))
        self.assertAlmostEqual(600./165.,effect.scale)
        self.c.x,self.c.y=700.,0.
        self.assertTrue(self.vm.run('CrocodileSand_IsOnGround',(self.c,self.c)))
        self.c.x=700.01
        self.assertFalse(self.vm.run('CrocodileSand_IsOnGround',(self.c,self.c)))
        self.c.x=100.
        sand.endNow=True
        self.assertFalse(self.vm.run('CrocodileSand_IsOnGround',(self.c,None)))

    def test_idle_e_does_not_reset_cooldown_every_tick(self):
        calls=[]
        original=self.vm.g['BlzEndUnitAbilityCooldown']
        self.vm.g['BlzEndUnitAbilityCooldown']=lambda u,a:(calls.append((u,a)),original(u,a))
        self.step(10)
        self.assertEqual([],calls)


if __name__=='__main__':
    unittest.main()
