"""Execute Inori aura selection, exact resistance and transformation lifetime contracts."""
from pathlib import Path
from collections import defaultdict
import json
import re
import unittest

from test_crocodile import JassState
import war3_object_workspace as objects
from stage_inori_aura import configure

ROOT = Path(__file__).resolve().parents[1]


def source(path):
    return (ROOT/'triggers'/path).read_text(encoding='utf-8-sig')


def functions(text, *names):
    return '\n'.join(re.search(r'(?m)^\s*(?:private |public )?function '+name+r' takes.*?endfunction', text, re.S)[0]
                     for name in names)


class InoriAura(unittest.TestCase):
    def fixture(self, extra=''):
        system = source('Systems/Systems1.j')
        text = functions(system, 'InoriE_AuraResistance', 'InoriE_ApplyAuraResistance', 'InoriT2_ApplyResistDown', 'InoriE_UpdateAura')
        hero = source('Heroes/Inori.j')
        text = re.sub(r'/\*.*?\*/', '', text+'\n'+functions(hero, 'InoriE_SetBaseHidden')+'\n'+extra, flags=re.S)
        vm = JassState(re.sub(r'(?<![\w.\]])\.(?=[A-Za-z_])', 'this.', text))
        for name, value in re.findall(r'\binteger (Inori\w*_ID)\s*=\s*\'([^\']+)\'', hero):
            vm.g[name] = value
        for name, value in re.findall(r'\breal (Inori\w+) = ([0-9.]+)', hero):
            vm.g[name] = float(value)
        available, disabled = {}, {}
        vm.g.update(hs={}, SH_INORI_AURA_DISABLED='aura disabled', SH_INORI_AURA_MODE_T='mode t',
                    SH_INORI_AURA_CURRENT_T='current t', SH_MODE_T='mode t', SH_CURRENT_T='current t',
                    SH_CANCEL_T='cancel t', SH_PAS_CD='pas cd', SH_INORI_E='Inori E', SH_INORI_E_HIDDEN='inori base E hidden',
                    IMinBJ=min, HaveSavedBoolean=lambda h, k, c: (k, c) in h,
                    GetPlayerId=lambda p: p, Player=lambda p: p,
                    GetHeroLevel=lambda u: u.hero_level,
                    SetPlayerAbilityAvailable=lambda p, a, v: available.update({(p, a): v}),
                    BlzUnitDisableAbility=lambda u, a, d, h: disabled.update({(id(u), a): (d, h)}),
                    SetUnitAbilityLevel=lambda u, a, v: u.abilities[a].update(level=v) if a in u.abilities else None)
        remove = vm.g['UnitRemoveAbility']
        def remove_and_reset(u,a):
            remove(u,a)
            disabled[id(u),a] = (False,False)
        vm.g['UnitRemoveAbility'] = remove_and_reset
        c = vm.unit(owner=0)
        c.hero_level = 24
        c.type = vm.g['Inori_ID']
        vm.add_ability(c, vm.g['InoriE_ID']); c.abilities[vm.g['InoriE_ID']]['level'] = 5
        vm.add_ability(c, vm.g['InoriEAlt2_ID']); c.abilities[vm.g['InoriEAlt2_ID']]['level'] = 5
        return vm, c, available, disabled

    def rank(self, vm, c):
        return c.abilities[vm.g['InoriEAlt2_ID']]['level']

    def test_25_default_and_selected_t1_grant_rank6_t2_choice_returns_rank5(self):
        vm, c, _, _ = self.fixture()
        vm.run('InoriE_UpdateAura', (c,))
        self.assertEqual(5, self.rank(vm, c))
        c.hero_level = 25
        vm.run('InoriE_UpdateAura', (c,))
        self.assertEqual(6, self.rank(vm, c))
        vm.g['hs'][id(c), 'current t'] = vm.g['InoriT2_ID']
        vm.run('InoriE_UpdateAura', (c,))
        self.assertEqual(5, self.rank(vm, c))
        vm.g['hs'][id(c), 'current t'] = vm.g['InoriT_ID']
        vm.run('InoriE_UpdateAura', (c,))
        self.assertEqual(6, self.rank(vm, c))
        self.assertEqual(5, c.abilities[vm.g['InoriE_ID']]['level'])

    def test_t2_blocks_and_hides_actual_aura_then_restores_it_with_no_repeated_writes(self):
        vm, c, available, disabled = self.fixture()
        c.hero_level = 25
        vm.g['hs'][id(c), 'current t'] = vm.g['InoriT2_ID']
        vm.g['hs'][id(c), 'mode t'] = 1
        vm.run('InoriE_UpdateAura', (c,))
        aura = vm.g['InoriEAlt2_ID']
        self.assertEqual(5, self.rank(vm, c))
        self.assertFalse(available[c.owner, aura])
        self.assertEqual((True, True), disabled[id(c), aura])
        available.clear(); disabled.clear()
        for _ in range(100):
            vm.run('InoriE_UpdateAura', (c,))
        self.assertFalse(available); self.assertFalse(disabled)
        vm.g['hs'][id(c), 'mode t'] = 0
        vm.run('InoriE_UpdateAura', (c,))
        self.assertTrue(available[c.owner, aura])
        self.assertEqual((False, False), disabled[id(c), aura])

    def test_regular_ranks_and_boost_apply_exact_resistance_to_physical_magic_and_attacks(self):
        vm, _, _, _ = self.fixture()
        u = vm.unit(owner=1)
        for rank in range(1, 7):
            u.abilities.clear()
            name = 'InoriE_Aura_ID' if rank == 5 else f'InoriE_AuraRank{rank}_ID'
            vm.add_ability(u, vm.g[name])
            physical, magic = (10, 10) if rank == 6 else (rank, 5)
            for damage_type, resistance in ((0, physical), (1, magic), (2, physical)):
                self.assertAlmostEqual(100-resistance, vm.run('InoriE_ApplyAuraResistance', (u, 100., damage_type)))
            self.assertEqual(100., vm.run('InoriE_ApplyAuraResistance', (u, 100., 3)))
        # Lingering lower-rank markers cannot stack with rank 6.
        vm.add_ability(u, vm.g['InoriE_Aura_ID'])
        self.assertEqual(90., vm.run('InoriE_ApplyAuraResistance', (u, 100., 2)))

    def test_t2_debuff_affects_both_damage_families_without_disabling_another_inori_aura(self):
        vm, c, _, _ = self.fixture()
        boosted_ally, enemy = vm.unit(owner=0), vm.unit(owner=1)
        vm.add_ability(boosted_ally, vm.g['InoriE_AuraRank6_ID'])
        vm.add_ability(enemy, vm.g['InoriT2_AuraBuff_ID'])
        vm.g['hs'][id(c), 'mode t'] = 1
        vm.run('InoriE_UpdateAura', (c,))
        for damage_type in (0, 1, 2):
            self.assertAlmostEqual(100., vm.run('InoriE_ApplyAuraResistance', (enemy, 100., damage_type)))
            self.assertAlmostEqual(90., vm.run('InoriE_ApplyAuraResistance', (boosted_ally, 100., damage_type)))
        for amount, expected in ((50., 60.), (80., 90.), (95., 100.), (100., 100.)):
            self.assertAlmostEqual(expected, vm.run('InoriT2_ApplyResistDown', (enemy, amount, 100.)))
        self.assertAlmostEqual(80., vm.run('InoriT2_ApplyResistDown', (boosted_ally, 80., 100.)))

    def test_unlearned_e_does_not_receive_service_rank6(self):
        vm, c, _, _ = self.fixture()
        c.hero_level = 35
        vm.remove_ability(c, vm.g['InoriE_ID'])
        vm.run('InoriE_UpdateAura', (c,))
        self.assertNotEqual(6, self.rank(vm, c))

    def test_enemy_resistance_shred_runs_after_ainz_in_both_real_damage_branches(self):
        text = source('Systems/Systems1.j')
        cursor = text.index('function DamageBlock')
        for kind in ('physical', 'magic'):
            start = text.index('if GetUnitAbilityLevel(td, AinzT_Debuff_ID)', cursor)
            end = text.index('set dmg = InoriT2_ApplyResistDown(td, dmg, dmgbase)', start)
            end = text.index('\n', end)
            cursor = end
            extra = ('function AfterAinz takes unit td, real dmg, real dmgbase returns real\nlocal real value\n' +
                     text[start:end]+'\nreturn dmg\nendfunction')
            vm, _, _, _ = self.fixture(extra)
            vm.g.update(AinzT_Debuff_ID='ainz', AinzT_ResistReduce=30.)
            enemy = vm.unit(owner=1)
            vm.add_ability(enemy, vm.g['InoriT2_AuraBuff_ID'])
            self.assertEqual(60., vm.run('AfterAinz', (enemy, 50., 100.)), kind)
            self.assertEqual(100., vm.run('AfterAinz', (enemy, 95., 100.)), kind)
            vm.add_ability(enemy, 'ainz')
            self.assertEqual(90., vm.run('AfterAinz', (enemy, 50., 100.)), kind)
            self.assertEqual(100., vm.run('AfterAinz', (enemy, 95., 100.)), kind)

    def test_actual_ultimate_selection_updates_aura_immediately(self):
        vm, c, _, _ = self.fixture(functions(source('Heroes/Inori.j'), 'OnClickInori'))
        c.hero_level = 25
        clicked = ['t1']
        vm.g.update(Hero={0: c}, inori_frame_pas5={0: 't1'}, inori_frame_pas7={0: 't2'},
                    inori_frame_pas10={0: 'confirm'}, inori_frame_pas12={0: 'close'},
                    inori_frame_pas9={0: 'confirm art'}, inori_frame_pas1={0: 'window'},
                    BlzGetTriggerFrame=lambda: clicked[0], GetTriggerPlayer=lambda: 0,
                    GetLocalPlayer=lambda: 0, BlzFrameSetTexture=lambda *_: None,
                    BlzFrameSetEnable=lambda *_: None, BlzFrameSetVisible=lambda *_: None,
                    WUI_ReleaseClickFocus=lambda: None)
        vm.run('OnClickInori')
        self.assertEqual(6, self.rank(vm, c))
        clicked[0] = 't2'
        vm.run('OnClickInori')
        self.assertEqual(5, self.rank(vm, c))
        clicked[0] = 't1'
        vm.run('OnClickInori')
        self.assertEqual(6, self.rank(vm, c))

    def test_t2_inori_does_not_gain_instability_from_damage_to_other_allies(self):
        vm, c, _, _ = self.fixture(functions(source('Heroes/Inori.j'), 'InoriEPas_Start'))
        vm.g.update(Hero=defaultdict(lambda: None, {0: c}), bj_MAX_PLAYERS=10,
                    IsUnitAlly=lambda u, p: u.owner == p, IsUnitIllusion=lambda _: False)
        ally = vm.unit(owner=0)
        vm.g['hs'][id(c), 'mode t'] = 1
        vm.run('InoriEPas_Start', (ally,))
        self.assertEqual(0, vm.g['hs'].get((id(c), 'Inori E'), 0))
        vm.g['hs'][id(c), 'mode t'] = 0
        vm.run('InoriEPas_Start', (ally,))
        self.assertEqual(1, vm.g['hs'][id(c), 'Inori E'])

    def test_e_repeats_and_repairs_a_present_but_hidden_disabled_ready_button(self):
        hero = source('Heroes/Inori.j')
        struct = re.search(r'    private struct InoriE_KS\b.*?    endstruct', hero, re.S)[0]
        vm, c, available, disabled = self.fixture(struct+'\n'+functions(hero, 'InoriEE_Start'))
        ns = vm.structs['InoriE_KS']
        ns.statics.update(MUI_InoriE=-1, m_InoriE={})
        hidden = {}
        for name in ('InoriTick10_On', 'InoriTick10_Off', 'MakeSound', 'InoriAttackArt',
                     'AddSpellLevel', 'WUI_HeroProgress', 'MyFlush'):
            vm.g[name] = lambda *_: None
        vm.g.update(SH_INORI_E_ACTIVE='Inori E Active', SH_E_ACTIVATED='e activated',
                    SH_E_ACTIVATED2='e activated2', PassiveCD_Start=lambda *_: 22.,
                    IsUnitPaused=lambda _: False, RoundReal=lambda a, b: round(a, b),
                    GetUnitCurrentOrder=lambda _: 0, OrderId=lambda _: 1,
                    BlzUnitHideAbility=lambda u, a, h: hidden.update({a: h}))
        remove = vm.g['UnitRemoveAbility']
        def remove_ready(u,a):
            remove(u,a)
            hidden[a] = False
        vm.g['UnitRemoveAbility'] = remove_ready
        vm.run('InoriE_Start', (c,))
        fx = ns.m_InoriE[0]
        for cycle in range(3):
            if cycle:
                # Existing rawcode with stale presentation state must recover too.
                vm.add_ability(c, vm.g['InoriEE_ID'])
                available[c.owner, vm.g['InoriEE_ID']] = False
                disabled[id(c), vm.g['InoriEE_ID']] = (True, True)
                hidden[vm.g['InoriEE_ID']] = True
                fx.check3 = 4  # An old transition marker must not suppress reconciliation.
            vm.g['hs'][id(c), 'Inori E'] = 4
            vm.run('Loop_InoriE')
            self.assertTrue(available[c.owner, vm.g['InoriEE_ID']])
            self.assertEqual((False, False), disabled[id(c), vm.g['InoriEE_ID']])
            self.assertFalse(hidden[vm.g['InoriEE_ID']])
            self.assertTrue(hidden[vm.g['InoriE_ID']])
            vm.run('InoriEE_Start', (c,))
            vm.run('Loop_InoriE')
            self.assertEqual(1, fx.k3)
            self.assertEqual(1, vm.g['hs'][id(c), 'Inori E Active'])
            fx.r = fx.rmax
            vm.run('Loop_InoriE')
            self.assertEqual(0, fx.k3)
            self.assertEqual(0, vm.g['hs'][id(c), 'Inori E Active'])
            self.assertFalse(hidden[vm.g['InoriE_ID']])
            self.assertEqual(1, vm.g['hs'][id(c), 'pas cd'])
            vm.g['hs'][id(c), 'pas cd'] = 0  # Fire the existing cooldown's expiry callback.

    def test_actual_t2_start_and_cancel_disable_and_restore_ally_aura(self):
        hero = source('Heroes/Inori.j')
        struct = re.search(r'    private struct InoriT2_KS\b.*?    endstruct', hero, re.S)[0]
        vm, c, available, disabled = self.fixture(struct)
        ns = vm.structs['InoriT2_KS']
        ns.statics.update(MUI_InoriT2=-1, m_InoriT2={})
        vm.g['hs'][id(c), 'current t'] = vm.g['InoriT2_ID']
        for name in ('StartSpellUnit', 'StopSpellUnit2', 'VisionTimed', 'MakeSound',
                     'BlzSetSpecialEffectAlpha', 'ColorEffDummy4', 'BlzPlaySpecialEffect',
                     'InoriAttackArt', 'SetUnitAnimationByIndex', 'BlzSetAbilityIcon',
                     'ColorDummy32', 'InoriTick_On', 'InoriTick_Off', 'BlzSetUnitSkin',
                     'FixAura', 'BlzEndUnitAbilityCooldown', 'SetUnitVertexColor',
                     'ColorDummy4', 'EUTU2_3', 'WUI_HeroProgress'):
            vm.g[name] = lambda *_: None
        hidden = {}
        vm.g.update(EffectSpawnScale=vm.effect, EffectSpawn3=vm.effect,
                    GetHeroInt=lambda *_: 100.,
                    ANIM_TYPE_BIRTH='birth', SpellBoolCaster=lambda _: False,
                    BlzUnitHideAbility=lambda u, a, v: hidden.update({a: v}))
        vm.run('InoriT2_Start', (c,))
        aura = vm.g['InoriEAlt2_ID']; enemy = vm.g['InoriT2_Aura_ID']
        self.assertFalse(available[c.owner, aura])
        self.assertEqual((True, True), disabled[id(c), aura])
        self.assertIn(enemy, c.abilities)
        self.assertTrue(hidden[enemy])
        instance = ns.m_InoriT2[0]
        # vJASS also accepts the explicit deallocate(this) form used by this legacy struct.
        instance.deallocate = lambda *_: setattr(instance, 'alive', False)
        vm.run('Loop_InoriT2')
        self.assertTrue(available[c.owner, aura])
        self.assertEqual((False, False), disabled[id(c), aura])
        self.assertNotIn(enemy, c.abilities)
        self.assertEqual(-1, ns.MUI_InoriT2)

    def test_objects_have_nonhero_rank6_zero_native_armor_equal_radii_and_both_tooltips(self):
        docs, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
        ids = json.loads((ROOT/'object-data/inori-aura-ids.json').read_text())
        configure(docs, ids, {})
        before = json.dumps(docs, sort_keys=True)
        configure(docs, ids, {})
        self.assertEqual(before, json.dumps(docs, sort_keys=True))
        indexed = {objects.object_id(o): o for d in docs if d['source_file'] == 'war3map.w3a'
                   for o in d['custom_objects']}
        def fields(code):
            return {(m['field']['text'], m.get('level', 0)): objects.value_for_user(m)
                    for m in indexed[code]['modifications']}
        aura, base, enemy = fields('A061'), fields('A09S'), fields('A153')
        self.assertEqual(6, aura['alev', 0]); self.assertEqual(0, aura['aher', 0])
        self.assertEqual(5, base['alev', 0])
        for rank in range(1, 7):
            self.assertEqual(0., aura['Had1', rank])
            self.assertEqual(1400., aura['aare', rank])
        self.assertEqual(ids['rank6'], aura['abuf', 6])
        self.assertEqual(1400., enemy['aare', 1])
        tips = json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
        for code in ('A06D', 'A153'):
            tip = tips[code]['extended_tooltip level 1']
            self.assertIn('10% physical resistance', tip)
            self.assertIn('10% magic resistance', tip)
            self.assertIn('1400', tip)


if __name__ == '__main__':
    unittest.main()
