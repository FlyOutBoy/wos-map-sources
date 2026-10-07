"""Execute MAIN Crocodile and its DmgSys helpers with deterministic natives.

This checks code paths, object identities and state ownership. Native casting,
art rendering and Warcraft's own damage events still require a game playtest.
"""
from pathlib import Path
import json
import math
import re
import tempfile
import unittest
from unittest.mock import patch

import test_crocodile_channel as channel
import test_crocodile_t_ground as ground_tests

ROOT = Path(__file__).resolve().parents[1]
MAIN = ROOT / 'triggers/Heroes/Crocodile.j'


class MainIntegration(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        source = MAIN.read_text(encoding='utf-8-sig')
        damage = (ROOT / 'triggers/Systems/DmgSys.j').read_text(encoding='utf-8-sig')
        helpers = '\n'.join(re.findall(r'function CrocodileG_\w+ takes.*?endfunction', damage, re.S))
        path = Path(self.temp.name) / 'main.j'
        path.write_text(source + '\n' + helpers.replace('static if LIBRARY_CrocodileSpells then', 'if true then'))
        self.fixture = ground_tests.GroundTests(methodName='runTest')
        with patch.object(channel, 'SOURCE', path):
            self.fixture.setUp()
        self.vm, self.c = self.fixture.vm, self.fixture.c
        self.fixture.fixture.heroes.add(id(self.c))
        self.permanent = []
        self.buffs = []
        self.now = 0.0
        self.expiry = {}
        self.vm.g.update({
            'GroupClear': lambda g: g.clear(),
            'BuffUnit01': self.buff,
            'UnitMakeAbilityPermanent': lambda u,b,a: self.permanent.append((u,a,b)),
            'dmgatk': self.attack_damage,
            'EffectSpawn2': self.vm.effect,
        })
        self.vm.run('Crocodile_InitializeHero', (self.c,))
        self.fixture.fixture.e = self.state(1)
        self.fixture.e = self.state(1)
        routing = (ROOT/'triggers/Systems/CastCheck.j').read_text(encoding='utf-8-sig')
        start = routing.index('    if GetUnitTypeId(c) == Crocodile_ID')
        end = routing.index('    endif // shared dispatch',start)
        end = routing.rfind('    endif\n',start,end)
        self.vm.methods['Test_CrocodileCast'] = ('    local integer check = 0\n' + routing[start:end] + '    return check == 1')

    def state(self, key, unit=None):
        return self.vm.g['LoadInteger'](self.vm.g['CrocodileTable'], id(unit or self.c), key)

    def buff(self, source, target, ability, order, level):
        self.buffs.append((self.now, source, target, ability, order, level))
        if ability == self.vm.g['CrocodileQ_SandMark_Ability_ID']:
            buff, duration = self.vm.g['CrocodileQ_SandMark_Buff_ID'], self.vm.g['CrocodileSand_Duration']
        else:
            buff, duration = self.vm.g['CrocodileG_SandMS_Buff_ID'], self.vm.g['CrocodileG_SandMS_Duration']
        self.vm.add_ability(target, buff)
        self.expiry[id(target), buff] = (target, self.now + duration)

    def step(self, ticks=1):
        for _ in range(ticks):
            self.now += .03
            for key, (unit, end) in list(self.expiry.items()):
                if self.now >= end:
                    self.vm.remove_ability(unit, key[1])
                    del self.expiry[key]
            self.fixture.step()

    def attack_damage(self, source, target, amount):
        # Enter the real F cancellation guard just as AttackCheck does.
        amount = self.vm.run('CrocodileF_Attack', (source, target, amount))
        amount = self.vm.run('CrocodileG_OffensiveDamage', (source, target, amount))
        self.vm.damage.append((source, target, amount))
        self.vm.run('CrocodileG_AppliedSpellHit', (source, target, amount, 0, True))

    def begin_t(self):
        self.c.order = self.fixture.fixture.orders['ambush']
        self.assertTrue(self.vm.run('CrocodileT_Begin', (self.c,)))
        return self.state(4)

    def on_ground(self, x, y):
        u = self.vm.unit(x, y, owner=0)
        return self.vm.run('OnGround', (u, self.c))

    def test_main_object_identity_and_levels(self):
        ids = json.loads((ROOT / 'object-data/crocodile-main-ids.json').read_text())
        units = json.loads((ROOT / 'object-data/units.json').read_text())
        abilities = json.loads((ROOT / 'object-data/abilities.json').read_text())
        buffs = json.loads((ROOT / 'object-data/buffs.json').read_text())
        self.assertEqual('H02M', ids['hero'])
        self.assertEqual(ids['hero'], self.vm.g['Crocodile_ID'])
        self.assertEqual(','.join(ids[x] for x in 'QWERT'), units[ids['hero']]['hero_abilities'])
        self.assertNotIn('Z00A', units)
        for slot in 'Q W E R T T2 F G'.split():
            with self.subTest(slot=slot):
                identity = ids[slot]
                self.assertEqual(identity, self.vm.g[f'Crocodile{slot}_ID'])
                self.assertIn('Crocodile', abilities[identity]['name'])
                self.assertEqual(5 if slot in 'QWER' else 1, abilities[identity].get('levels', 1))
        for a,b in [('QMarkAbility','QMarkBuff'),('GSpeedAbility','GSpeedBuff')]:
            self.assertIn(ids[a], abilities)
            self.assertIn(ids[b], buffs)
        self.assertEqual('ambush', abilities[ids['T']]['base_order_id level 1'])
        self.assertEqual(5, abilities[ids['T']]['follow_through_time level 1'])

    def test_independent_permanent_passives_and_idempotent_registration(self):
        for missing in [('F',),('G',),('F','G')]:
            with self.subTest(missing=missing):
                u = self.vm.unit(owner=0)
                u.type = self.vm.g['Crocodile_ID']
                self.fixture.fixture.heroes.add(id(u))
                for slot in 'FG':
                    if slot not in missing:
                        self.vm.add_ability(u, self.vm.g[f'Crocodile{slot}_ID'])
                self.vm.run('Crocodile_InitializeHero', (u,))
                first = tuple(self.state(k, u) for k in [0,1,2,3])
                self.vm.run('Crocodile_InitializeHero', (u,))
                self.assertEqual(first, tuple(self.state(k, u) for k in [0,1,2,3]))
                self.assertTrue(all(first))
                for slot in 'FG':
                    a = self.vm.g[f'Crocodile{slot}_ID']
                    self.assertGreater(self.vm.g['GetUnitAbilityLevel'](u,a),0)
                    self.assertTrue(any(x is u and y == a and b for x,y,b in self.permanent))

    def test_illusions_and_other_units_never_register(self):
        for illusion, hero_type in [(True,True),(False,False)]:
            u = self.vm.unit(owner=0)
            u.type = self.vm.g['Crocodile_ID']
            u.illusion = illusion
            if hero_type:
                self.fixture.fixture.heroes.add(id(u))
            self.vm.run('Crocodile_InitializeHero',(u,))
            self.assertEqual(0,self.state(0,u))

    def test_g_damage_missing_mana_and_no_legacy_duplicate(self):
        u = self.vm.unit(500)
        for mana, bonus in [(100,0),(80,.07),(50,.15),(0,.15)]:
            with self.subTest(mana=mana):
                u.mana = mana
                self.assertAlmostEqual(100*(1+bonus),self.vm.run('CrocodileG_OffensiveDamage',(self.c,u,100)))
                self.assertEqual(100,self.vm.run('Damage',(self.c,u,100,2,2)))
        u.max_mana = 0
        self.assertEqual(100,self.vm.run('CrocodileG_OffensiveDamage',(self.c,u,100)))
        u.max_mana = 100
        for amount, owner, illusion in [(0,1,False),(-10,1,False),(100,0,False),(100,1,True)]:
            u.owner = owner
            self.c.illusion = illusion
            self.assertEqual(amount,self.vm.run('CrocodileG_OffensiveDamage',(self.c,u,amount)))

    def test_g_only_positive_applied_spells_deplete_mana(self):
        u = self.vm.unit(500)
        for typed, attack, amount, expected in [(1,False,30,99),(2,False,30,99),(0,True,30,100),(3,False,30,100),(1,True,30,100),(2,False,0,100)]:
            with self.subTest(typed=typed,attack=attack,amount=amount):
                u.mana = 100
                self.vm.run('CrocodileG_AppliedSpellHit',(self.c,u,amount,typed,attack))
                self.assertEqual(expected,u.mana)

    def test_g_refreshes_native_buff_and_stops_after_leaving_sand(self):
        self.vm.run('AddSand',(self.c,0,0,250,True))
        self.step(40)
        casts = [entry for entry in self.buffs if entry[3] == self.vm.g['CrocodileG_SandMS_Ability_ID']]
        self.assertGreaterEqual(len(casts),5)
        self.assertLessEqual(len(casts),6)
        self.assertTrue(all(c[4:] == ('bloodlust',1) for c in casts))
        self.c.x = 10000
        self.step(21)
        self.assertEqual(0,self.vm.g['GetUnitAbilityLevel'](self.c,self.vm.g['CrocodileG_SandMS_Buff_ID']))
        self.assertNotIn('AIms',self.c.abilities)

    def test_q_mark_tracker_refresh_dispel_and_initial_sand(self):
        u = self.vm.unit(500)
        self.vm.run('CrocodileQ_ApplySandMark',(self.c,u))
        key = self.vm.g['CrocodileSand_DebuffKey']
        first = self.state(key,u)
        self.assertTrue(first)
        self.vm.run('CrocodileQ_ApplySandMark',(self.c,u))
        self.assertIs(first,self.state(key,u))
        self.step(6)
        u.x += 200
        self.step(6)
        self.assertTrue(self.vm.run('OnGround',(u,self.c)))
        self.vm.remove_ability(u,self.vm.g['CrocodileQ_SandMark_Buff_ID'])
        self.step(6)
        self.assertEqual(0,self.state(key,u))

    def test_q_baseline_sand_without_enemy_hits(self):
        self.assertTrue(self.vm.run('CrocodileQ_Start',(self.c,1655,0)))
        self.step(45)
        for i in range(8):
            x = 1655*(i+.5)/8
            self.assertTrue(self.on_ground(x,0), i)

    def test_t_keeps_channel_and_aura_after_spreading_and_pulses_once(self):
        u = self.vm.unit(10)
        t = self.begin_t()
        self.step(101)
        self.assertFalse(t.spreading)
        self.assertTrue(t.channelActive)
        self.assertTrue(self.vm.run('CrocodileT_IsChanneling',(self.c,)))
        self.assertEqual(1,self.c.protection)
        self.assertEqual(self.fixture.fixture.orders['ambush'],self.c.order)
        self.assertIsNotNone(t.aura)
        self.assertEqual(70,u.mana)
        self.step(66)
        self.assertFalse(t.channelActive)
        self.assertEqual(50,u.mana)
        self.assertEqual(0,self.c.protection)
        self.assertIsNone(t.aura)
        self.assertIsNone(t.manaGroup)
        self.assertTrue(self.vm.run('Crocodile_IsOnSand',(self.c,)))

    def test_t2_unlock_death_and_mui_owner_cleanup(self):
        t = self.begin_t()
        self.step(30)
        self.assertFalse(t.t2Granted)
        self.step(5)
        self.assertTrue(t.t2Granted)
        other = self.vm.unit(1000,owner=0)
        other.type = self.vm.g['Crocodile_ID']
        self.fixture.fixture.heroes.add(id(other))
        self.vm.run('Crocodile_InitializeHero',(other,))
        other.order = self.fixture.fixture.orders['ambush']
        self.assertTrue(self.vm.run('CrocodileT_Begin',(other,)))
        second = self.state(4,other)
        self.c.life = 0
        self.step(1)
        self.assertEqual(0,self.c.protection)
        self.assertTrue(second.channelActive)
        self.assertEqual(1,other.protection)
        self.vm.run('CrocodileT_Finish',(other,))
        self.assertEqual(0,other.protection)

    def test_f_single_damages_chosen_target_without_mana_burn_or_cancellation(self):
        target = self.vm.unit(200)
        nearby = self.vm.unit(210)
        for _ in range(2):
            self.vm.run('CrocodileF_AddStack',(self.c,))
        self.assertTrue(self.vm.run('CrocodileF_Begin',(self.c,target)))
        self.step(16)
        self.assertEqual([(self.c,target,300)],self.vm.damage)
        self.assertEqual(100,target.mana)
        self.assertEqual(100,nearby.mana)
        self.assertFalse(self.state(2).ownsAttackBlock)
        self.assertEqual(1,self.state(2).stacks)

    def test_damage_hook_order_is_single_and_before_preview(self):
        text = (ROOT/'triggers/Systems/DmgSys.j').read_text(encoding='utf-8-sig')
        self.assertEqual(1,text.count('set dmg = CrocodileG_OffensiveDamage('))
        self.assertEqual(1,text.count('call CrocodileG_AppliedSpellHit('))
        self.assertLess(text.index('set dmg = CrocodileG_OffensiveDamage('),text.index('set dmg = DamageCheck('))
        wrapper = (ROOT/'triggers/Systems/Systems2.j').read_text(encoding='utf-8-sig')
        self.assertNotIn('Crocodile_Damage.evaluate',wrapper)

    def test_f_three_blades_share_one_hit_group_and_keep_attack_damage_type(self):
        target = self.vm.unit(300)
        behind = self.vm.unit(-400)
        for _ in range(3):
            self.vm.run('CrocodileF_AddStack',(self.c,))
        self.assertTrue(self.vm.run('CrocodileF_Begin',(self.c,target)))
        self.step(50)
        hits = [d for c,u,d in self.vm.damage if u is target]
        self.assertEqual([900],hits)
        self.assertFalse(any(u is behind for _,u,_ in self.vm.damage))
        self.assertEqual(100,target.mana)
        self.assertFalse(self.c.paused)
        self.assertNotIn('Abun',self.c.abilities)

    def test_successful_cast_stacks_once_and_rejected_cast_does_not(self):
        self.assertTrue(self.vm.run('Cast',(self.c,self.vm.g['CrocodileE_ID'],750,0)))
        self.assertEqual(1,self.state(2).stacks)
        self.assertFalse(self.vm.run('Cast',(self.c,self.vm.g['CrocodileE_ID'],750,0)))
        self.assertEqual(1,self.state(2).stacks)

    def test_t2_ends_channel_before_delay_and_union_hits_once(self):
        target = self.vm.unit(100)
        self.vm.run('AddSand',(self.c,100,0,250,True))
        self.vm.run('AddSand',(self.c,300,0,250,True))
        t = self.begin_t()
        self.step(35)
        self.assertTrue(self.vm.run('CrocodileT2_Begin',(self.c,)))
        self.assertFalse(t.channelActive)
        self.assertEqual(0,self.c.protection)
        self.assertIsNone(t.manaGroup)
        self.step(16)
        self.assertFalse(self.vm.damage)
        self.step(1)
        hits = [d for c,u,d in self.vm.damage if u is target]
        self.assertEqual([1000],hits)
        self.assertFalse(self.c.paused)

    def test_q_mark_buff_failure_has_grace_then_cleans_tracker(self):
        self.vm.g['BuffUnit01'] = lambda *args: None
        u = self.vm.unit(500)
        self.vm.run('CrocodileQ_ApplySandMark',(self.c,u))
        self.step(6)
        self.assertTrue(self.state(7,u))
        self.step(12)
        self.assertEqual(0,self.state(7,u))

    def test_t_native_finish_after_spreading_cleans_once(self):
        t = self.begin_t()
        self.step(110)
        self.vm.g.update(GetTriggerUnit=lambda: self.c,GetSpellAbilityId=lambda: self.vm.g['CrocodileT_ID'])
        self.vm.run('CrocodileT_OnFinish')
        self.step(1)
        self.assertFalse(t.channelActive)
        self.assertEqual(0,self.c.protection)
        self.vm.run('CrocodileT_OnFinish')
        self.step(1)
        self.assertEqual(0,self.c.protection)

    def test_t_native_full_finish_preserves_fifth_mana_pulse(self):
        u = self.vm.unit(10)
        t = self.begin_t()
        self.step(166)
        self.assertEqual(60,u.mana)
        self.vm.g.update(GetTriggerUnit=lambda: self.c,GetSpellAbilityId=lambda: self.vm.g['CrocodileT_ID'])
        self.vm.run('CrocodileT_OnFinish')
        self.step(1)
        self.assertEqual(50,u.mana)
        self.assertFalse(t.channelActive)
        self.assertEqual(0,self.c.protection)

    def test_e_three_charges_and_five_contact_hits_cleanup(self):
        u = self.vm.unit(200)
        self.assertTrue(self.vm.run('CrocodileE_Begin',(self.c,750,0)))
        self.step(30)
        self.assertEqual(5,len([d for _,target,d in self.vm.damage if target is u]))
        self.assertAlmostEqual(300,sum(d for _,target,d in self.vm.damage if target is u))
        self.assertFalse(self.state(1).active)
        self.assertFalse(self.c.paused)
        self.assertAlmostEqual(750,self.c.x)

    def test_r_keeps_six_hits_and_restores_captured_units(self):
        landings = []
        self.vm.g['HeightSet'] = lambda u,t,h: landings.append((u,t,h))
        u = self.vm.unit(100)
        self.assertTrue(self.vm.run('CrocodileR_Begin',(self.c,2500,0)))
        self.step(85)
        self.assertEqual([60]*6,[d for _,target,d in self.vm.damage if target is u])
        self.assertEqual([(u,.5,0)],landings)
        self.assertFalse(self.c.paused)


if __name__ == '__main__':
    unittest.main()
