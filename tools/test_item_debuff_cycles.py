"""Execute elemental lifecycle and item refresh rules; Warcraft rendering is not emulated."""
from collections import defaultdict
from pathlib import Path
import json
import re
import unittest
from types import SimpleNamespace

from test_crocodile import JassState

ROOT = Path(__file__).resolve().parents[1]


def source(path):
    return (ROOT / 'triggers' / path).read_text(encoding='utf-8-sig')


def rawcode(value):
    return int.from_bytes(value.encode('ascii'), 'big')


class ItemDebuffCycles(unittest.TestCase):
    def test_anchor_three_impacts_follow_visual_landings_and_rebound(self):
        text = source('Items/Items.j')
        body = text.split('elseif .kind == ANCHOR then', 1)[1].split('elseif .kind == STORM or .kind == SPIRAL then', 1)[0]
        body = re.sub(r'(?<![\w])\.([A-Za-z]\w*)', r'this.\1', body)
        vm = JassState('function AnchorTick takes nothing returns boolean\n'
                       'local real d\nset this.left = this.left - DT\n' + body + '\nendfunction')
        impacts = []
        vm.g.update(DT=.03, LeviathanAnchor_Aoe=500., LeviathanAnchor_PullSpeed=190.,
                    IntegerTertiaryOp=lambda condition, a, b: a if condition else b,
                    BlzSetSpecialEffectZ=lambda e, z: setattr(e, 'z', z),
                    BlzSetSpecialEffectPitch=lambda e, r: setattr(e, 'pitch', r),
                    ElemFx=lambda *_: None)
        fx = SimpleNamespace(left=2.1, step=0., charges=0, next=.6, dmg2=50.,
                             dmg=575./3., x=0., y=0., e=vm.effect('anchor'), e2=None,
                             Drag=lambda *_: None)
        fx.Pulse = lambda *args: impacts.append((fx.step, fx.e.z, fx.e.pitch, args[1]))
        rebounds = []
        for _ in range(72):
            done = vm.run('AnchorTick', obj=fx)
            if fx.e is not None and fx.charges > 0:
                rebounds.append((fx.e.z, fx.e.pitch))
            if done:
                break
        self.assertEqual(3, len(impacts))
        for impact, planned in zip(impacts, (.6, 1.1, 1.6)):
            self.assertGreaterEqual(impact[0] + 1e-9, planned)
            self.assertLessEqual(impact[0], planned + .03)
            self.assertEqual((50., 0.), impact[1:3])
        self.assertAlmostEqual(575., sum(p[3] for p in impacts))
        self.assertTrue(any(z > 350. and pitch < -.5 for z, pitch in rebounds))
        self.assertIsNone(fx.e)
        self.assertTrue(done)

    def fixture(self):
        text = re.sub(r'//[^\n]*', '', source('Systems/DecorDestroy_and_Erza_Debuff.j'))
        # Numeric rawcodes preserve JASS range comparisons, including item attribution.
        text = re.sub(r"'([A-Za-z0-9]{4})'", lambda m: str(rawcode(m[1])), text)
        vm = JassState(text)
        caster, target, dummy = vm.unit(owner=0), vm.unit(owner=1), vm.unit(owner=1)
        vm.g.update(hs={}, GearDamageNextSource=0, ItemProcDamageDepth=0,
                    DamageSourceBase=lambda x: x, GetPlayerId=lambda x: x, Player=lambda x: x,
                    IsUnitVisible=lambda *_: True, Rimuru_ID=-20, Laxus_ID=-21,
                    DummyPlayer2=defaultdict(lambda: dummy), DummyPlayer6=defaultdict(lambda: dummy),
                    DummyPlayer4=defaultdict(lambda: dummy),
                    HasCachedItem=lambda *_: 0, IsItemInInventory=lambda *_: 0,
                    DebuffImmune_Start=lambda u, level: level,
                    SetUnitFacing=lambda *_: None, BlzSetUnitFacingEx=lambda *_: None, GAngle=lambda *_: 0.,
                    SetUnitAbilityLevel=lambda u, a, n: u.abilities.get(a, {}).update(level=n),
                    TimerStart=lambda *_: None, PauseTimer=lambda *_: None,
                    MyFlush=lambda *_: None, SlowUnitErza=lambda *_: None,
                    BlzSetSpecialEffectMatrixScale=lambda *_: None,
                    GetMainStatValue=lambda *_: 100., NextDmg=lambda *_: None,
                    ErzaW_ID=-22, ErzaE_ID=-23, ZankaNoTachi_ID=-24,
                    KokoGonryo_ID=-25, Suzumebachi_ID=-26, Tobiume_ID=-27,
                    KyokaSuigetsu_ID=-28, ZankaNoTachi_Stack=40., ZankaNoTachi_MaxDamage=300.,
                    ZankaNoTachi_Extend=2., Kurikara_MaxManaDmg=4.5,
                    AshisogiJizo_ID=rawcode('I04C'), AshisogiJizo_Curse_ID=rawcode('A110'),
                    AshisogiJizo_Buff_ID=rawcode('B041'), AshisogiJizo_DamageAgi=.5)
        vm.g['dmgmag'] = lambda c, u, d: vm.damage.append((c, u, d))
        vm.g['dmgmag2'] = lambda c, u, d, _: vm.damage.append((c, u, d))
        ns = vm.structs['ErzaDebuffs']
        ns.statics.update(MUI_ErzaPas=-1, m_ErzaPas={}, t_ErzaPas=None)
        casts = []
        buffs = {1: 'B006', 2: 'B007', 3: 'B008', 4: 'B009', 5: 'B00A',
                 6: 'B00B', 9: 'B00F', 10: 'B03C', 11: 'B041'}

        def curse(d, order, u):
            if order != 'curse':
                return
            if rawcode('A0DZ') in d.abilities:
                level = 9
            elif rawcode('A110') in d.abilities:
                level = 11
            else:
                level = d.abilities[vm.g['ErzaElemntalAbi_ID']]['level']
            casts.append(level)
            vm.add_ability(u, rawcode(buffs[level]))
        vm.g['IssueTargetOrder'] = curse
        return vm, caster, target, ns, casts

    def test_item_initial_plus_one_refresh_abilities_unlimited_and_expiry_resets(self):
        for kind in (2, 3, 9, 11):
            with self.subTest(kind=kind):
                vm, c, u, ns, casts = self.fixture()
                for _ in range(8):
                    vm.g['GearDamageNextSource'] = rawcode('I01Q')
                    vm.run('ErzaPassive', (c, u, kind))
                self.assertEqual([kind, kind], casts)
                self.assertEqual(0, ns.MUI_ErzaPas)
                for _ in range(30):
                    vm.g['GearDamageNextSource'] = rawcode('A001')
                    vm.run('ErzaPassive', (c, u, kind))
                    vm.run('Loop_Elemental')
                self.assertEqual(32, len(casts))
                self.assertEqual(1, ns.m_ErzaPas[0].itemRefreshes)
                vm.g['GearDamageNextSource'] = rawcode('I01Q')
                vm.run('ErzaPassive', (c, u, kind))
                self.assertEqual(32, len(casts))
                vm.remove_ability(u, ns.m_ErzaPas[0].id)
                vm.run('Loop_Elemental')
                self.assertEqual(-1, ns.MUI_ErzaPas)
                self.assertFalse(vm.effects)
                vm.g['GearDamageNextSource'] = rawcode('I01Q')
                vm.run('ErzaPassive', (c, u, kind))
                self.assertEqual(33, len(casts))
                self.assertEqual(0, ns.m_ErzaPas[0].itemRefreshes)

    def test_fire_refreshes_beyond_ten_seconds_without_duplicate_visuals_or_ticks(self):
        vm, c, u, ns, casts = self.fixture()
        vm.g['HasCachedItem'] = lambda unit, item: int(item == vm.g['ZankaNoTachi_ID'])
        vm.g['HealRegenClock'] = None
        for _ in range(220):
            vm.g['GearDamageNextSource'] = rawcode('I01Q')
            vm.run('ErzaPassive', (c, u, 1))
            vm.run('Loop_Elemental')
        self.assertEqual(220, len(casts))
        self.assertEqual(0, ns.MUI_ErzaPas)
        self.assertEqual(1, len(vm.effects))
        self.assertEqual(22, len(vm.damage))
        self.assertEqual(300., ns.m_ErzaPas[0].dmg)
        vm.remove_ability(u, vm.g['ErzaFire_ID'])
        vm.run('Loop_Elemental')
        self.assertFalse(vm.effects)

    def test_lightning_dispel_death_and_periodic_poison_cleanup(self):
        for kind, death in ((3, False), (3, True), (6, False), (9, False), (11, False)):
            with self.subTest(kind=kind, death=death):
                vm, c, u, ns, _ = self.fixture()
                vm.run('ErzaPas_Start', (c, u, kind, -100-kind))
                fx = ns.m_ErzaPas[0]
                vm.add_ability(u, fx.id)
                for _ in range(20):
                    vm.run('Loop_Elemental')
                self.assertEqual(0, ns.MUI_ErzaPas)
                if kind in (6, 9, 11):
                    self.assertEqual(2, len(vm.damage))
                if death:
                    u.life = 0.
                else:
                    vm.remove_ability(u, fx.id)
                vm.run('Loop_Elemental')
                self.assertEqual(-1, ns.MUI_ErzaPas)
                self.assertFalse(vm.effects)
                if kind == 11:
                    self.assertEqual(0, vm.g['hs'][id(u), 'ashisogi active'])

    def test_element_ticks_and_poison_cannot_feed_item_proc_chains(self):
        text = source('Systems/Systems2.j')
        helper = re.search(r'    function ItemDamageCanProc takes.*?endfunction', text, re.S)[0]
        helper = re.sub(r"'([A-Za-z0-9]{4})'", lambda m: str(rawcode(m[1])), helper)
        vm = JassState(helper)
        vm.g['DamageSourceBase'] = lambda x: rawcode('I00W') if x == 2100000001 else x
        for tag in list(range(-111, -100)) + [rawcode(x) for x in ('I00W', 'I04C', 'I03Y', 'I02H')] + [2100000001]:
            self.assertFalse(vm.run('ItemDamageCanProc', (tag,)), tag)
        for tag in (0, rawcode('A001'), rawcode('I01Q'), rawcode('I02S')):
            self.assertTrue(vm.run('ItemDamageCanProc', (tag,)), tag)

    def test_evolved_hit_applies_once_and_own_explosion_or_burn_cannot_restart_it(self):
        text = source('Systems/DmgSys.j')
        start = text.index('    // Evolved elements refresh')
        block = text[start:text.index('    if targetId == Tsuna_ID', start)]
        block = re.sub(r"'([A-Za-z0-9]{4})'", lambda m: str(rawcode(m[1])), block)
        helper = re.search(r'    function ItemDamageCanProc takes.*?endfunction', source('Systems/Systems2.j'), re.S)[0]
        helper = re.sub(r"'([A-Za-z0-9]{4})'", lambda m: str(rawcode(m[1])), helper)
        vm = JassState(helper + '\nfunction Hit takes nothing returns nothing\n' + block + '\nendfunction')
        c, u = vm.unit(owner=0), vm.unit(owner=1)
        applications, explosions = [], []
        evolved_ids = {'RyujinJakkaEvolved_ID': 'I05B', 'NejibanaEvolved_ID': 'I05C', 'GonryomaruEvolved_ID': 'I05D'}
        vm.g.update(c=c, td=u, isEnemy=True, dmg=500.,
                    DamageSourceBase=lambda x: x,
                    RyijinJakka_MinDmg=200., Nejibana_MinDmg=200., Gonryomaru_MinDmg=200.,
                    RyijinJakka_CD=6., Nejibana_CD=6., Gonryomaru_CD=6., ZanpakutoEvolved_CdReduce=1.,
                    RyijinJakka_DamageBase=2., Nejibana_DamageBase=2., Gonryomaru_DamageBase=2.,
                    GetMainStatValue=lambda *_: 1000., NextDmg=lambda *a: explosions.append(a),
                    ErzaPassive=lambda c, u, kind: applications.append(kind),
                    **{k: rawcode(v) for k, v in evolved_ids.items()})
        for evolved, ability, own_tag, kind in (('I05B', 'A080', 'I01Q', 1), ('I05C', 'A09P', 'I01X', 2), ('I05D', 'A081', 'I01Y', 3)):
            with self.subTest(evolved=evolved):
                vm.g['HasCachedItem'] = lambda c, item: int(item == rawcode(evolved))
                vm.g['GetUnitAbilityLevel'] = lambda c, abi: int(abi == rawcode(ability))
                for tag, expected in ((rawcode('A001'), 1), (rawcode(own_tag), 0), (-101, 0), (-106, 0), (rawcode('I00W'), 0), (rawcode('I04C'), 0)):
                    applications.clear(); explosions.clear(); c.cooldown = 0.
                    vm.g['damageSourceId'] = tag
                    vm.run('Hit')
                    self.assertEqual([kind] if expected else [], applications)
                    self.assertEqual(expected, len(explosions))

    def test_sukuna_and_seal_cast_paths_have_no_damage(self):
        text = source('Items/Items.j')
        for name in ('ItemsAnime_Curse', 'SukunaStart', 'SealStart'):
            body = re.search(r'function ' + name + r' takes.*?endfunction', text, re.S)[0]
            self.assertNotRegex(body, r'\b(?:dmgmag|dmgphys|dmgatk|NextDmg|DmgPTime|UnitDamageTarget)\(')
        tick = text.split('private struct ItemsAnimeEffect', 1)[1].split('endstruct', 1)[0]
        self.assertNotRegex(tick, r'\b(?:dmgmag|dmgphys|dmgatk|NextDmg|DmgPTime|UnitDamageTarget)\(')
        data = json.loads((ROOT / 'object-data/abilities.json').read_text(encoding='utf-8-sig'))
        for raw in ('A131', 'A133'):
            self.assertEqual('ANcl', data[raw]['base_id'])
            self.assertNotIn('Raiden', data[raw]['research_extended_tooltip'])
            self.assertIn('Does not deal damage.', data[raw]['extended_tooltip level 1'])


if __name__ == '__main__':
    unittest.main()
