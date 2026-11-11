"""Mana-floor lifetime, seal precedence, object recipe and attack-trigger regressions."""
from collections import defaultdict
from pathlib import Path
import json
import re
import unittest

from test_crocodile import JassState
import war3_object_workspace as objects
from stage_blood_pact_evolved import configure

ROOT = Path(__file__).resolve().parents[1]


def source(name):
    return (ROOT/'triggers'/name).read_text(encoding='utf-8-sig')


def functions(text, *names):
    return '\n'.join(re.search(r'(?m)^\s*(?:private |public )?function '+name+r' takes.*?endfunction', text, re.S)[0] for name in names)


class BloodPactRing(unittest.TestCase):
    def fixture(self):
        text = source('Systems/Systems2.j')
        vm = JassState(functions(text, 'GearManaScriptChange', 'GearManaFloorApply',
                                'GearManaFloorTick', 'GearManaFloorStart', 'SetMpCurrent'))
        vm.elapsed = 0.
        vm.g.update(hs={}, HealRegenClock=None, CurrentRound=1, GearManaFloorCount=0,
                    GearManaFloorListenerOn=False, GearManaFloorUnit=defaultdict(lambda: None),
                    GearManaFloorRound=defaultdict(int), GetManaAmp=lambda *_: 0.,
                    SetUnitState=lambda u, key, value: setattr(u, key, value),
                    HealTextQuiet=True, HealRegenTrack=False, FiveElementsSeal_Buff_ID='seal', CinderFang_Buff_ID='cinder',
                    SH_MANA_FIX_ACTIVE='mana fix slot', SH_MANA_FIX_SCRIPT_DELTA='mana fix script delta')
        u = vm.unit(owner=0); u.max_mana = 1000.; u.mana = 10.
        return vm, u

    def test_initial_refill_script_drains_native_spending_max_mana_and_expiry(self):
        vm, u = self.fixture()
        vm.run('GearManaFloorStart', (u, 5., .25))
        self.assertEqual(250., u.mana)
        self.assertEqual(1, vm.clock_users)
        u.mana = 300.
        vm.g['hs'][id(u), 'mana fix slot'] = 1
        vm.run('SetMpCurrent', (u, -100.))
        self.assertEqual(250., u.mana)
        self.assertEqual(-50., vm.g['hs'][id(u), 'mana fix script delta'])
        u.mana = 0.  # Native engine spell payment / mana burn.
        vm.run('GearManaFloorTick')
        self.assertEqual(250., u.mana)
        u.max_mana = 2000.
        vm.run('GearManaFloorTick')
        self.assertEqual(500., u.mana)
        vm.elapsed = 5.; u.mana = 0.
        vm.run('GearManaFloorApply', (u,))
        self.assertEqual(0., u.mana)
        vm.run('GearManaFloorTick')
        self.assertEqual(0, vm.g['GearManaFloorCount'])
        self.assertEqual(0, vm.clock_users)

    def test_seal_overrides_initial_and_continuous_restoration_without_extending_duration(self):
        vm, u = self.fixture(); vm.add_ability(u, 'seal')
        vm.run('GearManaFloorStart', (u, 5., .25))
        self.assertEqual(10., u.mana)
        vm.run('SetMpCurrent', (u, -5.))
        self.assertEqual(5., u.mana)
        vm.run('GearManaFloorTick')
        self.assertEqual(5., u.mana)
        vm.elapsed = 4.; vm.remove_ability(u, 'seal')
        vm.run('GearManaFloorTick')
        self.assertEqual(250., u.mana)
        vm.elapsed = 5.; u.mana = 0.
        vm.run('GearManaFloorTick')
        self.assertEqual(0., u.mana)
        self.assertEqual(0, vm.clock_users)

    def test_refresh_deduplicates_and_death_round_change_release_shared_timer(self):
        for end in ('death', 'round'):
            with self.subTest(end=end):
                vm, u = self.fixture()
                vm.run('GearManaFloorStart', (u, 5., .25))
                vm.elapsed = 3.
                vm.run('GearManaFloorStart', (u, 5., .25))
                self.assertEqual(1, vm.g['GearManaFloorCount'])
                self.assertEqual(1, vm.clock_users)
                if end == 'death': u.life = 0.
                else: vm.g['CurrentRound'] = 2
                vm.run('GearManaFloorTick')
                self.assertEqual(0, vm.g['GearManaFloorCount'])
                self.assertEqual(0, vm.clock_users)
                self.assertIsNone(vm.g['GearManaFloorUnit'][0])

    def test_object_stats_prices_recipe_and_repeatable_staging(self):
        docs, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
        ids = json.loads((ROOT/'object-data/blood-pact-evolved-ids.json').read_text())
        configure(docs, ids, {})
        before = json.dumps(docs, sort_keys=True)
        configure(docs, ids, {})
        self.assertEqual(before, json.dumps(docs, sort_keys=True))
        items = json.loads((ROOT/'object-data/items.json').read_text(encoding='utf-8-sig'))
        self.assertEqual(2500, items['I06D']['gold_cost'])
        self.assertEqual(5000, items[ids['item']]['gold_cost'])
        self.assertEqual(ids['active']+',A00M,A0CQ', items[ids['item']]['abilities'])
        self.assertIn('RegisterCraft(BloodPactRingEvolved_ID, "I01J I06D")', source('WOS_Start/WoS_Shop_Init.j'))
        self.assertIn('ShopCat(SHOP_TAB_UNIVERSAL,     BloodPactRingEvolved_ID)', source('WOS_Start/WoS_Shop_Init.j'))

    def test_samehada_uses_actual_attacks_and_magic_attacks_not_cero_hits(self):
        items = source('Items/Items.j'); dmg = source('Systems/DmgSys.j')
        branch = re.search(r"        if eventIsAttack and isEnemy and dmg > 0 then.*?        endif", dmg, re.S)[0]
        vm = JassState(functions(items, 'ItemsAnime_OnAttack')+'\nfunction Hit takes nothing returns nothing\n'+branch+'\nendfunction')
        c, u = vm.unit(owner=0), vm.unit(owner=1); calls = []
        vm.g.update(c=c, td=u, isEnemy=True, dmg=100., Samehada_ID='samehada',
                    Samehada_ManaRestore=4., Samehada_ManaDrain=4., HasCachedItem=lambda *_: 1,
                    Tekkai_Buff_ID='tekkai',
                    SetMpCurrentQuiet=lambda *a: calls.append(a), SetMpCurrent=lambda *a: calls.append(a))
        for attack, tag, expected in ((True, 0, 2), (True, 'magic', 2), (False, 'A0BJ', 0), (False, 'spell', 0)):
            calls.clear(); vm.g.update(eventIsAttack=attack, damageSourceId=tag); vm.run('Hit')
            self.assertEqual(expected, len(calls))

    def test_samehada_rejects_clones_allies_and_tekkai(self):
        vm = JassState(functions(source('Items/Items.j'), 'ItemsAnime_OnAttack'))
        c, u = vm.unit(owner=0), vm.unit(owner=1)
        calls = []
        vm.g.update(Samehada_ID='samehada', Tekkai_Buff_ID='tekkai',
                    Samehada_ManaRestore=4., Samehada_ManaDrain=4., HasCachedItem=lambda *_: 1,
                    SetMpCurrentQuiet=lambda *a: calls.append(a), SetMpCurrent=lambda *a: calls.append(a))
        for caster_clone, target_clone, protected, ally, expected in (
                (False, False, False, False, 2), (True, False, False, False, 0),
                (False, True, False, False, 0), (False, False, True, False, 0),
                (False, False, False, True, 0)):
            calls.clear()
            c.illusion, u.illusion, u.owner = caster_clone, target_clone, 0 if ally else 1
            vm.g['GetUnitAbilityLevel'] = lambda *_: int(protected)
            vm.run('ItemsAnime_OnAttack', (c, u))
            self.assertEqual(expected, len(calls))

    def test_starrk_original_attack_procs_once_before_cero_and_zeroing(self):
        text = source('Systems/DmgSys.j')
        body = text.split('if eventIsAttack and sourceId == Starrk_ID', 1)[1]
        body = body[body.index('// The native attack'):body.index('else')]
        body = body.replace('static if LIBRARY_ItemsSpells then', '').replace('        endif\n        call StarrkE_Attack_Start', '        call StarrkE_Attack_Start', 1)
        vm = JassState('function Hit takes nothing returns nothing\n'+body+'\nendfunction')
        c, u = vm.unit(owner=0), vm.unit(owner=1)
        calls = []
        vm.g.update(c=c, td=u, isEnemy=True, dmg=100.,
                    ItemsAnime_OnAttack=lambda *_: calls.append('samehada'),
                    StarrkE_Attack_Start=lambda *_: calls.append('cero'))
        vm.run('Hit')
        self.assertEqual(['samehada', 'cero'], calls)
        self.assertEqual(0, vm.g['dmg'])

    def test_tekkai_cancels_before_attack_hooks_and_item_procs(self):
        text = source('Systems/DmgSys.j')
        body = text.split('// Reject protected attacks', 1)[1].split('static if LIBRARY_AinzSpells then', 1)[0]
        body = body[body.index('        if '):body.rfind('    endif')]
        vm = JassState('function Hit takes nothing returns nothing\n'+body+'\ncall AttackEffects()\nendfunction')
        c, u = vm.unit(owner=0), vm.unit(owner=1)
        calls = []
        vm.g.update(c=c, td=u, sourceOwner=0, targetOwner=1, Tekkai_Buff_ID='tekkai',
                    BlzSetEventDamage=lambda value: calls.append(('damage', value)),
                    AttackEffects=lambda: calls.append('onhit'))
        for attack, kind, tag, active, expected in (
                (True, 0, 0, True, [('damage', 0.)]),
                (True, 1, 0, True, [('damage', 0.)]),
                (False, 1, 'A0BJ', True, [('damage', 0.)]),
                (False, 2, 'spell', True, ['onhit']),
                (True, 0, 0, False, ['onhit'])):
            calls.clear()
            vm.g.update(c=c, td=u, eventIsAttack=attack, typedmg=kind, damageSourceId=tag,
                        GetUnitAbilityLevel=lambda *_: int(active))
            vm.run('Hit')
            self.assertEqual(expected, calls)
        self.assertLess(text.index('// Reject protected attacks'), text.index('call AinzW_KnightHit'))
        self.assertLess(text.index('// Reject protected attacks'), text.index('set dmg = AttackCheck'))

    def test_tsuchikage_bounce_budget_uses_attack_at_cast_time(self):
        text = source('Items/Items.j')
        statement = re.search(r'set check2 = IMaxBJ\(0, R2I\(GetAttack\(c\).*', text)[0]
        vm = JassState('function Budget takes nothing returns nothing\n'+statement+'\nendfunction')
        vm.g.update(check2=0, c=None, TsuchikageHatEvolve_AttackPerBounce=100.)
        for attack, expected in ((0, 0), (99, 0), (100, 1), (350, 3), (600, 6), (1250, 12)):
            vm.g['GetAttack'] = lambda *_: attack
            vm.run('Budget')
            self.assertEqual(expected, vm.g['check2'])

    def test_kirito_microhits_are_physical_attacks_with_reentry_guard(self):
        text = source('Systems/Systems2.j')
        vm = JassState(functions(text, 'dmgphysattack'))
        c, u = vm.unit(owner=0), vm.unit(owner=1); hits = []
        vm.g.update(GearDamageActiveSource='outer', GearDamageNextSource='kirito R',
                    GearDamageAttackFollowup=False, ATTACK_TYPE_NORMAL='physical', DAMAGE_TYPE_FIRE='normal',
                    UnitDamageTarget=lambda *a: hits.append((a, vm.g['GearDamageAttackFollowup'])))
        vm.run('dmgphysattack', (c, u, 100.))
        self.assertEqual((True, False, 'physical', 'normal'), hits[0][0][3:7])
        self.assertTrue(hits[0][1])
        self.assertEqual('outer', vm.g['GearDamageActiveSource'])
        self.assertFalse(vm.g['GearDamageAttackFollowup'])
        micro = source('Heroes/Kirito.j').split('static method Loop_KiritoR3 takes', 1)[1].split('endmethod', 1)[0]
        self.assertIn('call dmgphysattack(c, td, dmg)', micro)
        self.assertIn('KiritoR_AS) > 0 and not GearDamageAttackFollowup then', source('Systems/DmgSys.j'))

    def test_kirito_quick_two_and_strong_four_hits_keep_their_total_damage(self):
        text = re.sub(r'//[^\n]*', '', source('Heroes/Kirito.j'))
        for strong, count, expected_times in ((True, 4, [.05, .15, .25, .35]),):  # quick hits are instant now (no loop)
            with self.subTest(strong=strong):
                start = text.index('    private struct KiritoSpells_R')
                end = text.index('    endstruct', start) + len('    endstruct')
                constants = '\n'.join(re.findall(r'^        (?:integer|real) \w+ = [^\n]+', text[:start], re.M))
                vm = JassState('globals\n'+constants+'\nendglobals\n'+text[start:end])
                c, u = vm.unit(owner=0), vm.unit(owner=1)
                clock, hits = [0.], []
                vm.g.update(hs={}, GetPlayerId=lambda x: x, PosUnit=lambda *_: None,
                            DebugUnit2=lambda *_: None, GAngle=lambda *_: 0.,
                            KiritoTick05_On=lambda *_: None, KiritoTick05_Off=lambda *_: None,
                            SetPlayerAbilityAvailable=lambda *_: None,
                            BlzSetSpecialEffectRoll=lambda *_: None,
                            deallocate=lambda *_: None,
                            dmgphysattack=lambda c, u, d: hits.append((round(clock[0], 2), d)))
                ns = vm.structs['KiritoSpells_R']
                ns.statics.update(MUI_KiritoR2=-1, MUI_KiritoR3=-1, m_KiritoR2={}, m_KiritoR3={})
                suffix = '2' if strong else '3'
                vm.run('KiritoR'+suffix+'_Start', (c, u, 600.))
                getattr(ns, 'm_KiritoR'+suffix)[0].deallocate = lambda *_: None
                for _ in range(30):
                    clock[0] += .05
                    vm.run('Loop_KiritoR'+suffix)
                    if getattr(ns, 'MUI_KiritoR'+suffix) == -1:
                        break
                self.assertEqual(count, len(hits))
                self.assertEqual(expected_times, [t for t, _ in hits])
                self.assertEqual(600., sum(d for _, d in hits))

    def test_yata_checks_naofumi_on_attacker_not_mirror_owner(self):
        vm = JassState(functions(source('Systems/DmgSys.j'), 'I02HReflect'))
        attacker, owner = vm.unit(owner=0), vm.unit(owner=1)
        hits = []
        vm.g.update(hs={}, I02H_ReflectActive=False, SH_DmgSys_NAOFUMI_SHIELD='naofumi shield',
                    YataMirrorEvolved_Buff_ID='yata active', YataMirrorEvolved_ReflectActive=75.,
                    YataMirror_ReversedDmg=30., IntegerCdKey=lambda *_: False,
                    dmgmag=lambda *a: hits.append(a))
        vm.add_ability(attacker, 'B005')
        vm.run('I02HReflect', (attacker, owner, 100., 1))
        self.assertFalse(hits)
        vm.remove_ability(attacker, 'B005')
        vm.g['hs'][id(attacker), 'naofumi shield'] = 1
        vm.run('I02HReflect', (attacker, owner, 100., 1))
        self.assertFalse(hits)
        vm.g['hs'][id(attacker), 'naofumi shield'] = 0
        vm.add_ability(owner, 'B005')
        vm.run('I02HReflect', (attacker, owner, 100., 1))
        self.assertEqual([(owner, attacker, 30.)], hits)
        self.assertFalse(vm.g['I02H_ReflectActive'])


if __name__ == '__main__':
    unittest.main()
