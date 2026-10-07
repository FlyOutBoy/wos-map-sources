"""Regression checks against the selected TEST hero's actual vJASS methods."""
from pathlib import Path
import math
import json
import re
import unittest
from types import SimpleNamespace

from test_crocodile import JassState

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "test_map/heroes/Crocodile.j"
_profile_file = ROOT/'_build/test-profile.json'
if _profile_file.is_file():
    _profile = json.loads(_profile_file.read_text(encoding='utf-8-sig'))
    if _profile.get('hero') == 'Crocodile':
        SOURCE = Path(_profile['heroSource'])


class ContactAndChannelTests(unittest.TestCase):
    def setUp(self):
        shared = (ROOT/'test_map/base/Systems/Systems2.j').read_text(encoding='utf-8-sig')
        timer = re.search(r'    private struct KS_SpellTimer\b.*?    endstruct',shared,re.S).group()
        swap = re.search(r'    function SwapAbility takes.*?    endfunction',shared,re.S).group()
        self.vm = JassState(text=SOURCE.read_text(encoding="utf-8-sig")+'\n'+timer+'\n'+swap)
        self.vm.structs['KS_SpellTimer'].statics.update(MUI_6=-1,m_6=[None]*8192)
        self.swap_clock = 0.0
        self.orders = {"stop": 1, "ambush": 2, "eattree": 3, "move": 4, "attack": 5, "enemychannel": 6}
        self.attachments = []
        self.stopped = []
        self.structures = set()
        self.heroes = set()
        self.available = {}
        self.timers = []
        self.expired_timer = None
        self.vm.g.update({
            'hs': {}, 'StringHash': lambda s: s,
            'GearTimer05Acquire': lambda: None, 'GearTimer05Release': lambda: None,
            'UnitMakeAbilityPermanent': lambda *args: None,
            'SetUnitAbilityLevel': lambda u,a,l: u.abilities[a].update(level=l),
            "EffectSpawn3": self.vm.effect,
            "OrderId": lambda name: self.orders.get(name, 0),
            "GetUnitCurrentOrder": lambda u: getattr(u, "order", 0),
            "IssueImmediateOrder": self.stop,
            "BlzUnitHideAbility": lambda u,a,b: u.disabled.update({("hidden", a): b}),
            "SetPlayerAbilityAvailable": lambda p,a,b: self.available.update({(p,a): b}),
            "IsUnitType": lambda u,t: id(u) in (self.structures if t == "UNIT_TYPE_STRUCTURE" else self.heroes if t == "UNIT_TYPE_HERO" else set()),
            "BlzSetSpecialEffectTimeScale": self.effect_time_scale,
            "BlzPlaySpecialEffect": lambda e,a: setattr(e,"animation",a),
            "ANIM_TYPE_DEATH": "death",
            "AddSpecialEffectTarget": self.attachment,
            "ABILITY_SLF_BASE_ORDER_ID_NCL6": "Ncl6",
            "BlzGetAbilityStringLevelField": lambda a,f,n: a.get(f, ""),
            "BlzGetUnitAbilityByIndex": lambda u,i: list(u.abilities.values())[i] if i < len(u.abilities) else None,
            'CreateTimer': self.create_timer,
            'TimerStart': self.start_timer,
            'PauseTimer': lambda t:setattr(t,'running',False),
            'DestroyTimer': self.destroy_timer,
            'GetExpiredTimer': lambda:self.expired_timer,
        })
        self.c = self.vm.unit(owner=0)
        self.c.type = self.vm.g["Crocodile_ID"]
        self.vm.hero(self.c)
        self.vm.add_ability(self.c, self.vm.g['CrocodileT_ID'])
        self.vm.add_ability(self.c, self.vm.g["CrocodileE_ID"])
        self.e = self.state(1)

    def enemy_hero(self, x, y=0):
        unit = self.vm.unit(x,y)
        self.heroes.add(id(unit))
        return unit

    def effect_time_scale(self, effect, speed):
        self.assertIsNotNone(effect)
        self.assertIn(id(effect),self.vm.effects)
        effect.timescale = speed

    def state(self, key):
        return self.vm.g["LoadInteger"](self.vm.g["CrocodileTable"], id(self.c), key)

    def stop(self, unit, order):
        self.stopped.append(unit)
        unit.order = self.orders.get(order, 0)

    def attachment(self, model, unit, point):
        self.attachments.append((model, unit, point))
        return self.vm.effect(model, unit.x, unit.y)

    def step(self, ticks=1):
        for _ in range(ticks):
            self.vm.run("Loop")
            self.swap_clock += 0.03
            while self.swap_clock + 0.00001 >= 0.05:
                self.swap_clock -= 0.05
                self.vm.run('LoopSpellTimer')
            for timer in list(self.timers):
                if timer.running:
                    timer.elapsed += .03
                    while timer.running and timer.elapsed+.00001 >= timer.period:
                        timer.elapsed -= timer.period
                        self.expired_timer=timer
                        timer.callback()
            self.expired_timer=None

    def create_timer(self):
        timer=SimpleNamespace(running=False,elapsed=0.,alive=True)
        self.timers.append(timer)
        return timer

    def start_timer(self,timer,period,repeating,callback):
        timer.period,timer.callback,timer.running=period,callback,True

    def destroy_timer(self,timer):
        self.assertTrue(timer.alive,'Timer destroyed twice')
        timer.alive=timer.running=False
        self.timers.remove(timer)

    def start_e(self):
        self.assertTrue(self.vm.run("CrocodileE_Begin", (self.c, 750., 0.)))

    def start_t(self):
        self.c.order = self.orders["ambush"]
        self.assertTrue(self.vm.run("CrocodileT_Begin", (self.c,)))

    def wait_for_contact(self):
        for _ in range(20):
            if self.e.hitStarted:
                return
            self.assertEqual([], self.vm.damage)
            self.step()
        self.fail("E did not contact the enemy")

    def test_contact_holds_point_point_three_seconds_and_hits_five_times_in_area(self):
        a, b = self.enemy_hero(200, 0), self.vm.unit(250, 30)
        ally, structure, outside = self.vm.unit(200, owner=0), self.vm.unit(180), self.vm.unit(1400)
        self.structures.add(id(structure))
        self.start_e()
        self.wait_for_contact()
        position = self.c.x
        slash = self.e.e2
        self.assertAlmostEqual(0.12,self.e.elapsed)
        self.assertAlmostEqual(0.4,self.c.timescale)
        self.assertAlmostEqual(1.0,slash.timescale)
        self.assertEqual(2, len(self.vm.damage))
        for tick in range(1, 11):
            self.step()
            self.assertAlmostEqual(position, self.c.x)
            for target in (a, b):
                self.assertEqual(1+int((tick*0.03+0.001)/0.075), sum(u is target for _,u,_ in self.vm.damage))
            if tick < 10:
                self.assertAlmostEqual(0.4,self.c.timescale)
                self.assertAlmostEqual(1.0,slash.timescale)
                self.assertIs(self.e.e2,slash)
                self.assertFalse(any(e is slash for e,_,_ in self.vm.fade_history))
        self.assertAlmostEqual(1.0,self.c.timescale)
        self.assertAlmostEqual(1.0,slash.timescale)
        self.assertEqual("death",slash.animation)
        self.assertIsNone(self.e.e2)
        self.assertEqual(1,sum(e is slash for e,_,_ in self.vm.fade_history))
        for target in (a, b):
            self.assertAlmostEqual(300., sum(d for _,u,d in self.vm.damage if u is target))
        self.assertFalse(any(u is ally or u is structure or u is outside for _,u,_ in self.vm.damage))
        albatross = [entry for entry in self.attachments if "Albatross" in entry[0]]
        self.assertEqual(10, len(albatross))
        self.assertTrue(all(point == "chest" for _,_,point in albatross))
        explosions = [e for e in self.vm.effect_history if "StampedeMissileDeath" in e.model]
        self.assertEqual(1, len(explosions))
        self.assertNotIn(id(explosions[0]), self.vm.effects)
        self.step(9)
        self.assertAlmostEqual(750., self.c.x)
        self.assertFalse(self.e.active)
        self.assertFalse(self.c.paused)
        self.assertEqual(10, len(self.vm.damage))
        self.assertEqual(1,sum(e is slash for e,_,_ in self.vm.fade_history))

    def test_contact_and_damage_use_point_150_ahead(self):
        hero = self.enemy_hero(610)
        behind = self.vm.unit(-200)
        self.start_e()
        self.wait_for_contact()
        self.assertGreater(abs(hero.x-self.c.x),self.e.radius)
        self.assertAlmostEqual(self.c.x+150.,self.e.hitX)
        self.assertAlmostEqual(self.c.y,self.e.hitY)
        self.assertEqual(1,sum(u is hero for _,u,_ in self.vm.damage))
        self.step(10)
        self.assertEqual(5,sum(u is hero for _,u,_ in self.vm.damage))
        self.assertFalse(any(u is behind for _,u,_ in self.vm.damage))

    def test_allies_structures_dead_units_and_heroes_behind_do_not_start_contact(self):
        self.vm.unit(200,owner=0)
        self.structures.add(id(self.vm.unit(200)))
        self.vm.unit(200).life = 0
        self.enemy_hero(-200)
        self.start_e()
        self.step(14)
        self.assertFalse(self.e.hitStarted)
        self.assertEqual([],self.vm.damage)
        self.assertAlmostEqual(750.,self.c.x)

    def test_later_hero_cannot_restart_damage_during_remaining_movement(self):
        first, second = self.enemy_hero(200), self.enemy_hero(1000)
        self.start_e()
        self.wait_for_contact()
        self.step(10)
        self.assertTrue(self.e.active)
        hit_point = self.c.x
        self.step(9)
        self.assertGreater(self.c.x,hit_point)
        self.assertEqual(5,sum(u is first for _,u,_ in self.vm.damage))
        self.assertFalse(any(u is second for _,u,_ in self.vm.damage))
        self.assertEqual(1,sum("StampedeMissileDeath" in e.model for e in self.vm.effect_history))

    def test_no_contact_has_no_extra_delay_or_damage(self):
        self.start_e()
        self.step(14)
        self.assertFalse(self.e.active)
        self.assertAlmostEqual(750., self.c.x)
        self.assertEqual([], self.vm.damage)
        self.assertFalse(self.c.paused)

    def test_early_contact_deals_damage_immediately_without_waiting_for_animation(self):
        self.enemy_hero(200)
        self.start_e()
        self.step(4)
        self.assertTrue(self.e.hitStarted)
        self.assertEqual(1,len(self.vm.damage))
        self.assertAlmostEqual(0.12,self.e.elapsed)
        self.assertAlmostEqual(0.4, self.c.timescale)
        self.step(10)
        self.assertEqual(5, len(self.vm.damage))
        self.assertAlmostEqual(1.0, self.c.timescale)
        self.assertLess(self.e.elapsed,self.vm.g['CrocodileE_HitSlowTime'])
        self.assertFalse(self.e.hitSlowed)

    def test_animation_slows_at_configured_time_only_during_damage(self):
        self.enemy_hero(950)
        self.start_e()
        self.wait_for_contact()
        slash = self.e.e2
        self.assertAlmostEqual(0.24,self.e.elapsed)
        self.assertEqual(1,len(self.vm.damage))
        self.step(8)
        self.assertAlmostEqual(0.48,self.e.elapsed)
        self.assertAlmostEqual(0.4, self.c.timescale)
        self.assertAlmostEqual(1.0, slash.timescale)
        self.step()
        self.assertAlmostEqual(0.51,self.e.elapsed)
        self.assertAlmostEqual(0.01,self.c.timescale)
        self.assertAlmostEqual(0.01,slash.timescale)
        self.assertEqual(4,len(self.vm.damage))
        self.step()
        self.assertEqual(5, len(self.vm.damage))
        self.assertAlmostEqual(1.0, self.c.timescale)
        self.assertAlmostEqual(1.0,slash.timescale)

    def test_custom_slow_time_does_not_delay_damage_and_no_contact_never_slows(self):
        self.vm.g['CrocodileE_HitSlowTime'] = 0.15
        self.vm.unit(200)
        self.start_e()
        self.step(4)
        self.assertEqual(1,len(self.vm.damage))
        self.assertAlmostEqual(0.4,self.c.timescale)
        self.step()
        self.assertAlmostEqual(0.01,self.c.timescale)
        self.assertEqual(1,len(self.vm.damage))
        self.step(9)
        self.assertEqual(5,len(self.vm.damage))
        self.assertAlmostEqual(1.0,self.c.timescale)
        self.setUp()
        self.vm.g['CrocodileE_HitSlowTime'] = 0.15
        self.start_e()
        self.step(11)
        self.assertFalse(self.e.hitStarted)
        self.assertFalse(self.e.hitSlowed)
        self.assertGreater(self.c.timescale,0.01)

    def test_regular_enemy_unit_starts_contact_and_receives_five_ticks(self):
        unit = self.vm.unit(200)
        self.start_e()
        self.step(4)
        self.assertTrue(self.e.hitStarted)
        self.assertEqual(1,sum(u is unit for _,u,_ in self.vm.damage))
        self.step(10)
        self.assertEqual(5,sum(u is unit for _,u,_ in self.vm.damage))

    def test_e_hit_places_one_larger_sand_patch_under_target_and_none_at_dash_end(self):
        target = self.vm.unit(200,30)
        self.start_e()
        self.step(4)
        sand = self.vm.structs['CrocodileSand_Struct']
        self.assertEqual(0,sand.MUI)
        patch = sand.m[0]
        self.assertAlmostEqual(target.x,patch.x)
        self.assertAlmostEqual(target.y,patch.y)
        self.assertAlmostEqual(515.,patch.radius)
        self.assertNotEqual(self.e.hitX,patch.x)
        self.step(20)
        self.assertFalse(self.e.active)
        self.assertAlmostEqual(750.,self.c.x)
        self.assertEqual(0,sand.MUI)
        self.assertIs(patch,sand.m[0])
        self.assertAlmostEqual(200.,patch.x)

    def test_e_without_hit_places_larger_sand_only_at_end_150_ahead(self):
        self.assertTrue(self.vm.run('CrocodileE_Begin',(self.c,0.,750.)))
        sand = self.vm.structs['CrocodileSand_Struct']
        self.step(10)
        self.assertEqual(-1,sand.MUI)
        self.step()
        self.assertFalse(self.e.active)
        self.assertFalse(self.e.hitStarted)
        self.assertEqual(0,sand.MUI)
        patch = sand.m[0]
        self.assertAlmostEqual(0.,patch.x)
        self.assertAlmostEqual(900.,patch.y)
        self.assertAlmostEqual(515.,patch.radius)

    def test_e_contact_reuses_nearby_sand_and_expands_its_radius(self):
        target = self.vm.unit(200,30)
        self.vm.run('CrocodileSand_Start',(self.c,target.x,target.y,250.,False))
        sand = self.vm.structs['CrocodileSand_Struct']
        patch = sand.m[0]
        self.start_e()
        self.step(4)
        self.assertTrue(self.e.hitStarted)
        self.assertEqual(0,sand.MUI)
        self.assertIs(patch,sand.m[0])
        self.assertAlmostEqual(515.,patch.radius)

    def test_slow_time_is_measured_from_cast_not_previous_shared_timer_tick(self):
        self.vm.elapsed = 0.029
        self.vm.g['CrocodileE_HitSlowTime'] = 0.27
        self.vm.unit(200)
        self.start_e()
        self.step(4)
        self.assertAlmostEqual(0.091,self.e.elapsed)
        self.assertEqual(1,len(self.vm.damage))
        self.step(5)
        self.assertAlmostEqual(0.241,self.e.elapsed)
        self.assertAlmostEqual(0.4,self.c.timescale)
        self.step()
        self.assertAlmostEqual(0.271,self.e.elapsed)
        self.assertAlmostEqual(0.01,self.c.timescale)
        self.step(4)
        self.assertEqual(5,len(self.vm.damage))
        self.assertAlmostEqual(1.0,self.c.timescale)

    def test_front_uses_spell_angle_in_all_directions_and_current_caster_position(self):
        for angle in (0.,math.pi/2,math.pi,-math.pi/2,math.pi/4):
            with self.subTest(angle=angle):
                self.setUp()
                self.c.x,self.c.y = 100.,-50.
                self.c.facing = angle*180/math.pi+180  # Facing must not affect the spell direction.
                target = self.vm.unit(self.c.x+200*math.cos(angle),self.c.y+200*math.sin(angle))
                self.assertTrue(self.vm.run('CrocodileE_Begin',(self.c,self.c.x+750*math.cos(angle),self.c.y+750*math.sin(angle))))
                self.wait_for_contact()
                self.assertAlmostEqual(self.c.x+150*math.cos(angle),self.e.hitX)
                self.assertAlmostEqual(self.c.y+150*math.sin(angle),self.e.hitY)
                self.assertEqual(1,sum(u is target for _,u,_ in self.vm.damage))

    def test_moving_target_is_checked_on_every_step(self):
        target = self.vm.unit(1600)
        self.start_e()
        self.step(5)
        self.assertFalse(self.e.hitStarted)
        target.x = self.c.x+150
        self.step()
        self.assertTrue(self.e.hitStarted)
        self.assertAlmostEqual(self.c.x+150,self.e.hitX)
        self.assertEqual(1,sum(u is target for _,u,_ in self.vm.damage))

    def test_swept_front_hits_between_steps_and_retains_full_dash_distance(self):
        self.vm.g['CrocodileE_Aoe'] = 35.
        self.vm.g['CrocodileE_Duration'] = 0.12
        target = self.vm.unit(450,30)
        self.start_e()
        self.step(4)
        self.assertFalse(self.e.hitStarted)
        self.step()
        self.assertTrue(self.e.hitStarted)
        self.assertAlmostEqual(450.,self.e.hitX)
        self.assertAlmostEqual(300.,self.c.x)
        self.assertEqual(1,sum(u is target for _,u,_ in self.vm.damage))
        self.step(10)
        self.assertEqual(5,sum(u is target for _,u,_ in self.vm.damage))
        self.step(5)
        self.assertAlmostEqual(750.,self.c.x)
        self.assertFalse(self.e.active)

    def test_death_during_contact_stops_ticks_and_releases_e_pause(self):
        self.enemy_hero(200)
        self.start_e()
        self.step(9)
        count = len(self.vm.damage)
        self.c.life = 0
        self.vm.run("Death", (self.c,))
        self.step(12)
        self.assertEqual(count, len(self.vm.damage))
        self.assertFalse(self.e.active)
        self.assertFalse(self.c.paused)



if __name__ == "__main__":
    unittest.main()
