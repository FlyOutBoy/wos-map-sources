"""Regression checks against the selected TEST hero's actual vJASS methods."""
from pathlib import Path
import re
import unittest

from test_crocodile import JassState

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "test_map/profiles/Crocodile/imported-hero/Crocodile.j"


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

    def start_e(self):
        self.assertTrue(self.vm.run("CrocodileE_Begin", (self.c, 750., 0.)))

    def start_t(self):
        self.c.order = self.orders["ambush"]
        self.assertTrue(self.vm.run("CrocodileT_Begin", (self.c,)))

    def wait_for_damage_phase(self):
        for _ in range(100):
            if self.e.hitStarted and not self.e.hitWaiting:
                return
            self.assertEqual([], self.vm.damage)
            self.step()
        self.fail("E did not reach the contact damage phase")

    def test_contact_holds_point_point_three_seconds_and_hits_five_times_in_area(self):
        a, b = self.enemy_hero(200, 0), self.vm.unit(250, 30)
        ally, structure, outside = self.vm.unit(200, owner=0), self.vm.unit(180), self.vm.unit(1400)
        self.structures.add(id(structure))
        self.start_e()
        while not self.e.hitStarted:
            self.step()
        position = self.c.x
        slash = self.e.e2
        self.wait_for_damage_phase()
        self.assertAlmostEqual(position, self.c.x)
        self.assertGreaterEqual(self.e.animationTime, 0.9)
        self.assertGreaterEqual(self.e.slashTime, 0.6)
        self.assertAlmostEqual(0.01,self.c.timescale)
        self.assertAlmostEqual(0.01,slash.timescale)
        self.assertEqual([], self.vm.damage)
        for tick in range(1, 11):
            self.step()
            self.assertAlmostEqual(position, self.c.x)
            for target in (a, b):
                self.assertEqual(tick // 2, sum(u is target for _,u,_ in self.vm.damage))
            if tick < 10:
                self.assertAlmostEqual(0.01,self.c.timescale)
                self.assertAlmostEqual(0.01,slash.timescale)
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
        while not self.e.hitStarted:
            self.step()
        self.assertGreater(abs(hero.x-self.c.x),self.e.radius)
        self.assertAlmostEqual(self.c.x+150.,self.e.hitX)
        self.assertAlmostEqual(self.c.y,self.e.hitY)
        self.wait_for_damage_phase()
        self.step(10)
        self.assertEqual(5,sum(u is hero for _,u,_ in self.vm.damage))
        self.assertFalse(any(u is behind for _,u,_ in self.vm.damage))

    def test_units_and_heroes_behind_do_not_start_contact(self):
        self.vm.unit(200)
        self.enemy_hero(-200)
        self.start_e()
        self.step(14)
        self.assertFalse(self.e.hitStarted)
        self.assertEqual([],self.vm.damage)
        self.assertAlmostEqual(750.,self.c.x)

    def test_later_hero_cannot_restart_damage_during_remaining_movement(self):
        first, second = self.enemy_hero(200), self.enemy_hero(1000)
        self.start_e()
        while not self.e.hitStarted:
            self.step()
        self.wait_for_damage_phase()
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

    def test_early_contact_waits_for_each_animation_to_reach_sixty_percent(self):
        self.enemy_hero(200)
        self.start_e()
        self.step(4)
        self.assertTrue(self.e.hitWaiting)
        self.assertLess(self.e.animationTime, 0.9)
        self.assertGreater(self.c.timescale, 0.01)
        for _ in range(70):
            self.assertEqual([], self.vm.damage)
            if self.e.slashRate == 0.01:
                break
            self.step()
        self.assertGreaterEqual(self.e.slashTime, 0.6)
        self.assertLess(self.e.animationTime, 0.9)
        self.assertAlmostEqual(0.4, self.c.timescale)
        self.wait_for_damage_phase()
        self.assertAlmostEqual(0.01, self.c.timescale)
        self.step(10)
        self.assertEqual(5, len(self.vm.damage))
        self.assertAlmostEqual(1.0, self.c.timescale)

    def test_contact_after_sixty_percent_does_not_slow_animation(self):
        self.vm.g['CrocodileE_AnimationLength'] = 0.75
        self.enemy_hero(200)
        self.start_e()
        self.step(4)
        self.assertTrue(self.e.hitStarted)
        self.assertFalse(self.e.hitWaiting)
        self.assertGreater(self.e.animationTime, 0.75*0.6)
        self.assertAlmostEqual(0.4, self.c.timescale)
        self.assertAlmostEqual(1.0, self.e.e2.timescale)
        self.step(10)
        self.assertEqual(5, len(self.vm.damage))
        self.assertAlmostEqual(1.0, self.c.timescale)

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

    def test_t_is_unpaused_hidden_and_interrupt_releases_immunity(self):
        self.start_t()
        self.assertFalse(self.c.paused)
        immunity = self.vm.g["CrocodileT_Immunity"]
        self.assertIn(immunity, self.c.abilities)
        self.assertTrue(self.c.disabled[("hidden", immunity)])
        self.assertTrue(self.vm.run("Crocodile_TargetProtected", (self.c,)))
        self.c.order = self.orders["move"]
        self.step()
        self.assertEqual(0, self.state(4))
        self.assertNotIn(immunity, self.c.abilities)
        self.assertEqual(0, self.c.protection)
        self.assertFalse(self.vm.run("Crocodile_TargetProtected", (self.c,)))
        self.assertEqual([], self.vm.spell_pause_history)

    def test_t_cleanup_timeout_death_removal_and_existing_immunity(self):
        for ending in ("timeout", "death", "removal"):
            with self.subTest(ending=ending):
                self.setUp()
                immunity = self.vm.g["CrocodileT_Immunity"]
                self.vm.add_ability(self.c, immunity)
                self.start_t()
                if ending == "death":
                    self.c.life = 0
                    self.vm.run("Death", (self.c,))
                elif ending == "removal":
                    self.c.type = "otherhero"
                self.step(168 if ending == "timeout" else 2)
                self.assertEqual(0, self.state(4))
                self.assertIn(immunity, self.c.abilities)
                self.assertEqual(0, self.c.protection)
                self.assertFalse(self.c.paused)

    def test_t2_can_finish_cast_point_and_detonate_after_channel_order_change(self):
        target = self.vm.unit(100)
        self.start_t()
        self.step(34)
        self.c.order = self.orders["eattree"]
        self.step(10)
        self.assertNotEqual(0, self.state(4))
        self.assertTrue(self.vm.run("CrocodileT2_Begin", (self.c,)))
        self.assertEqual(1, sum(u is target for _,u,_ in self.vm.damage))
        self.step()
        self.assertEqual(0, self.state(4))
        self.assertFalse(self.c.paused)

    def test_t2_replaces_t_after_unlock_and_restores_t_on_finish(self):
        self.start_t()
        t, t2 = self.vm.g['CrocodileT_ID'], self.vm.g['CrocodileT2_ID']
        self.step(33)
        self.assertNotIn(t2, self.c.abilities)
        self.step()
        self.assertIn(t2, self.c.abilities)
        self.assertFalse(self.available[(self.c.owner,t)])
        self.assertTrue(self.available[(self.c.owner,t2)])
        self.c.order = self.orders['move']
        self.step()
        self.assertFalse(self.available[(self.c.owner,t2)])
        self.assertTrue(self.available[(self.c.owner,t)])
        self.step(2)
        self.assertEqual(-1,self.vm.structs['KS_SpellTimer'].MUI_6)

    def test_existing_unavailable_t2_is_revealed_at_unlock(self):
        t2 = self.vm.g['CrocodileT2_ID']
        self.vm.add_ability(self.c,t2)
        self.available[(self.c.owner,t2)] = False
        self.start_t()
        self.step(34)
        self.assertTrue(self.available[(self.c.owner,t2)])

    def test_swap_timer_from_interrupted_t_does_not_expire_next_t2(self):
        self.start_t()
        self.step(34)
        self.c.order = self.orders['move']
        self.step()
        self.start_t()
        self.step(34)
        t, t2 = self.vm.g['CrocodileT_ID'], self.vm.g['CrocodileT2_ID']
        self.assertTrue(self.available[(self.c.owner,t2)])
        self.step(75)
        self.assertTrue(self.available[(self.c.owner,t2)])
        self.assertFalse(self.available[(self.c.owner,t)])

    def test_enemy_unit_target_channel_is_cancelled_but_attacks_and_allies_are_allowed(self):
        self.start_t()
        enemy = self.vm.unit(200)
        self.vm.add_ability(enemy, "EnemyChannel")
        enemy.abilities["EnemyChannel"]["Ncl6"] = "enemychannel"
        self.vm.g.update({"GetTriggerUnit": lambda: enemy, "GetOrderTargetUnit": lambda: self.c,
                          "GetIssuedOrderId": lambda: self.orders["enemychannel"]})
        self.vm.run("CrocodileT_BlockTargetOrder")
        self.assertEqual([enemy], self.stopped)
        self.stopped.clear()
        self.vm.g["GetIssuedOrderId"] = lambda: self.orders["attack"]
        self.vm.run("CrocodileT_BlockTargetOrder")
        self.assertEqual([], self.stopped)
        self.vm.g.update({"GetSpellAbilityUnit": lambda: enemy, "GetSpellTargetUnit": lambda: self.c})
        self.vm.run("CrocodileT_BlockTargetSpell")
        self.assertEqual([enemy], self.stopped)
        self.stopped.clear()
        enemy.owner = self.c.owner
        self.vm.run("CrocodileT_BlockTargetSpell")
        self.assertEqual([], self.stopped)
        self.vm.g["GetSpellTargetUnit"] = lambda: None
        self.vm.run("CrocodileT_BlockTargetSpell")
        self.assertEqual([], self.stopped)


if __name__ == "__main__":
    unittest.main()
