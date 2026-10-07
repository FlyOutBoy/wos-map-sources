"""Run F's actual TEST vJASS with native mocks; no duplicate implementation."""
import math
import unittest

from test_crocodile import JassState
from test_crocodile_channel import SOURCE


class VolleyTests(unittest.TestCase):
    def setUp(self):
        self.vm = JassState(text=SOURCE.read_text(encoding='utf-8-sig'))
        self.voices = []
        self.structures = set()
        self.vm.g.update({
            'MakeSound': self.voices.append,
            'EffectSpawn': self.effect,
            'EffectSpawn3': self.effect,
            'IsUnitType': lambda u,t: t == 'UNIT_TYPE_STRUCTURE' and id(u) in self.structures,
            'SetUnitAnimationByIndex': lambda u,a: setattr(u,'animation',a),
        })
        self.c = self.vm.unit(owner=0)
        self.c.type = self.vm.g['Crocodile_ID']
        self.vm.hero(self.c)
        self.f = self.vm.g['LoadInteger'](self.vm.g['CrocodileTable'],id(self.c),2)
        self.target = self.vm.unit(800,0)

    def effect(self, *args):
        effect = self.vm.effect(*args)
        if len(args)>3:
            effect.angle = args[3]
            effect.timescale = args[4]
            effect.height = args[6]
        return effect

    def step(self, ticks=1):
        for _ in range(ticks):
            self.vm.run('Loop')

    def attack(self, stacks):
        self.f.stacks = stacks
        self.f.CrocodileF_SetEnhanced(True)
        self.assertTrue(self.vm.run('CrocodileF_Begin',(self.c,self.target)))
        self.assertEqual(0.,self.vm.run('CrocodileF_Attack',(self.c,self.target,100.)))

    def blades(self):
        return [e for e in self.vm.effect_history if 'CrocodileWeapon.mdl' in e.model]

    def target_hits(self, target=None):
        target = target or self.target
        return [amount for _,u,amount in self.vm.damage if u is target]

    def test_one_stack_windup_side_effect_faces_target_and_hits_area_once(self):
        nearby = self.vm.unit(820,30)
        outside = self.vm.unit(800,180)
        ally = self.vm.unit(820,owner=0)
        self.attack(1)
        self.assertNotIn('AIsx',self.c.abilities)
        self.assertTrue(self.c.weapons[0]['UNIT_WEAPON_BF_ATTACKS_ENABLED'])
        self.assertFalse(self.c.weapons[1]['UNIT_WEAPON_BF_ATTACKS_ENABLED'])
        self.assertFalse(self.c.paused)
        self.assertEqual(self.vm.g['CrocodileF_Animation'],self.c.animation)
        self.step(14)
        self.assertEqual([],self.vm.damage)
        self.assertEqual([],self.blades())
        self.assertIn('Abun',self.c.abilities)
        self.assertEqual(0,self.f.stacks)
        self.step()
        self.assertEqual([300.],self.target_hits())
        self.assertEqual([300.],self.target_hits(nearby))
        self.assertEqual([],self.target_hits(outside))
        self.assertEqual([],self.target_hits(ally))
        self.assertEqual(0,self.f.stacks)
        self.assertNotIn('Abun',self.c.abilities)
        single = [e for e in self.vm.effect_history if 'Crocodile nits.mdl' in e.model]
        self.assertEqual(1,len(single))
        single = single[0]
        self.assertAlmostEqual(180.,math.hypot(single.x-self.target.x,single.y-self.target.y))
        yaw = single.angle*math.pi/180
        self.assertAlmostEqual(-180.,(self.target.x-single.x)*math.cos(yaw)+(self.target.y-single.y)*math.sin(yaw))
        self.assertEqual([r'war3mapImported\Hero_Crocodile_F3',r'war3mapImported\Hero_Crocodile_F5'],self.voices)
        self.step(30)
        self.assertEqual([300.],self.target_hits())

    def test_two_stacks_spend_one_and_restore_bonuses_after_cooldown(self):
        self.attack(2)
        self.assertEqual(1,self.f.stacks)
        self.step(15)
        self.assertEqual(1,self.f.stacks)
        self.assertEqual([],self.blades())
        self.assertNotIn('AIsx',self.c.abilities)
        self.assertEqual(100.,self.vm.run('CrocodileF_Attack',(self.c,self.target,100.)))
        self.assertFalse(self.vm.run('CrocodileF_Begin',(self.c,self.target)))
        self.step(53)
        self.assertTrue(self.f.enhanced)
        self.assertIn('AIsx',self.c.abilities)
        self.assertFalse(self.c.weapons[0]['UNIT_WEAPON_BF_ATTACKS_ENABLED'])
        self.assertTrue(self.c.weapons[1]['UNIT_WEAPON_BF_ATTACKS_ENABLED'])

    def test_three_stacks_emit_rotated_fan_and_deal_one_triple_hit(self):
        side = self.vm.unit(1150,308)
        overlap = self.vm.unit(500,0)
        structure = self.vm.unit(500,10)
        self.structures.add(id(structure))
        self.attack(3)
        self.assertEqual(0,self.f.stacks)
        self.assertTrue(self.c.paused)
        self.step(14)
        self.assertEqual([],self.blades())
        self.step()
        self.assertEqual(3,len(self.blades()))
        self.assertFalse(self.c.paused)
        self.assertTrue(all(e.scale == 6.1875 for e in self.blades()))
        self.assertTrue(all(e.timescale == 1.75 for e in self.blades()))
        self.assertTrue(all(e.height == 90. for e in self.blades()))
        for expected,actual in zip([-15.,0.,15.],sorted(e.angle for e in self.blades())):
            self.assertAlmostEqual(expected,actual)
        self.assertEqual(0,self.f.stacks)
        volley = self.vm.structs['CrocodileF_Projectile'].m[0]
        scan_group,hit_group = volley.g,volley.g2
        # Both side rays include the aimed unit even at maximum attack range.
        self.assertGreaterEqual(volley.radius,800*math.sin(math.pi/12)+32)
        self.step(33)
        self.assertEqual([900.],self.target_hits())
        self.assertEqual([900.],self.target_hits(side))
        self.assertEqual([900.],self.target_hits(overlap))
        self.assertEqual([],self.target_hits(structure))
        self.assertFalse(volley.alive)
        # The latest pasted source fades blades for 0.45 seconds after landing.
        self.assertTrue(all(any(entry[0] is e for entry in self.vm.fade_history) for e in self.blades()))
        self.step(16)
        self.assertTrue(all(id(e) not in self.vm.effects for e in self.blades()))
        for blade in self.blades():
            self.assertAlmostEqual(1700.,math.hypot(blade.x-self.c.x,blade.y-self.c.y))
        self.assertNotIn(id(scan_group),self.vm.groups)
        self.assertNotIn(id(hit_group),self.vm.groups)

    def test_sand_trail_is_spaced_and_stays_until_its_normal_expiration(self):
        self.attack(3)
        self.step(45)
        sand = self.vm.structs['CrocodileSand_Struct']
        patches = [sand.m[i] for i in range(sand.MUI+1)]
        self.assertGreater(len(patches),9)
        self.assertLessEqual(len(patches),28)
        self.assertTrue(any(p.x>1500 for p in patches))
        self.assertTrue(any(p.y>300 for p in patches))
        self.assertTrue(any(p.y<-300 for p in patches))
        for i,p in enumerate(patches):
            for q in patches[i+1:]:
                self.assertGreaterEqual(math.hypot(p.x-q.x,p.y-q.y)+0.001,180.)
        self.step(310)
        self.assertEqual(-1,sand.MUI)

    def test_triple_blades_fly_twenty_percent_faster_and_stop_at_original_range(self):
        self.attack(3)
        self.step(15)
        volley = self.vm.structs['CrocodileF_Projectile'].m[0]
        self.assertAlmostEqual(1800.*1.2*0.03,volley.distance)
        self.step(25)
        self.assertTrue(volley.alive)
        self.assertAlmostEqual(1684.8,volley.distance)
        self.step()
        self.assertFalse(volley.alive)
        self.assertAlmostEqual(1700.,volley.distance)
        self.assertEqual([900.],self.target_hits())

    def test_target_death_during_windup_cancels_and_releases_pause(self):
        self.attack(3)
        self.step(5)
        self.target.life = 0
        self.step()
        self.assertEqual(0,self.f.stacks)
        self.assertFalse(self.c.paused)
        self.assertFalse(self.f.ownsAttackBlock)
        self.assertNotIn('Abun',self.c.abilities)
        self.step(20)
        self.assertEqual([],self.blades())
        self.assertEqual([],self.vm.damage)

    def test_caster_death_before_or_after_release_cleans_pending_and_volley(self):
        for released in (False,True):
            with self.subTest(released=released):
                self.setUp()
                self.attack(3)
                self.step(15 if released else 3)
                blades = self.blades()
                self.c.life = 0
                self.vm.run('Death',(self.c,))
                count = len(self.vm.damage)
                self.step(20)
                self.assertEqual(count,len(self.vm.damage))
                self.assertNotIn('Abun',self.c.abilities)
                self.assertNotIn('AIsx',self.c.abilities)
                self.assertFalse(self.f.ownsAttackBlock)
                self.assertFalse(self.c.paused)
                self.assertTrue(all(id(e) not in self.vm.effects for e in blades))

    def test_two_casters_have_independent_volley_hit_groups(self):
        other = self.vm.unit(0,20,owner=0)
        other.type = self.c.type
        self.vm.hero(other)
        second = self.vm.g['LoadInteger'](self.vm.g['CrocodileTable'],id(other),2)
        self.attack(3)
        second.stacks = 3
        second.CrocodileF_SetEnhanced(True)
        self.assertTrue(self.vm.run('CrocodileF_Begin',(other,self.target)))
        self.step(46)
        self.assertEqual([900.,900.],self.target_hits())
        self.assertEqual(6,len(self.blades()))

    def test_attack_start_launches_once_before_native_damage(self):
        self.f.stacks = 3
        self.f.CrocodileF_SetEnhanced(True)
        self.vm.g.update({'GetAttacker': lambda: self.c, 'GetTriggerUnit': lambda: self.target})
        self.vm.run('CrocodileF_OnAttack')
        self.assertEqual(0,self.f.stacks)
        self.assertTrue(self.c.paused)
        self.vm.run('CrocodileF_OnAttack')
        self.assertEqual(2,len(self.voices))
        self.assertEqual(0.,self.vm.run('CrocodileF_Attack',(self.c,self.target,100.)))
        self.step(15)
        self.assertEqual(3,len(self.blades()))
        self.assertEqual(100.,self.vm.run('CrocodileF_Attack',(self.c,self.target,100.)))
        self.step(35)
        self.assertEqual(3,len(self.blades()))


if __name__ == '__main__':
    unittest.main()
