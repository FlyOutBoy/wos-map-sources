"""Exercise purchase guards, elemental amplification, mana drains and key capture.

Runs production JASS fragments with native mocks; not Warcraft visual or network QA.
"""
from collections import defaultdict
from pathlib import Path
from types import SimpleNamespace
import json
import re
import unittest

from balance_active_items import MANA_COSTS, ELEMENT_ITEMS, DAMAGE_CAST_RANGES, shop_policy_source
from check_item_descriptions import Audit
from test_crocodile import JassState
import test_item_debuff_cycles as cycles
from test_item_debuff_cycles import rawcode
import test_damage_stats as damage_stats

ROOT = Path(__file__).resolve().parents[1]


def source(path):
    return (ROOT/'triggers'/path).read_text(encoding='utf-8-sig')


def function(text, name):
    return re.search(r'(?m)^\s*(?:(?:private|public) )?function '+name+r' takes.*?endfunction', text, re.S)[0]


def numeric(text):
    return re.sub(r"'([A-Za-z0-9]{4})'", lambda m: str(rawcode(m[1])), re.sub(r'/\*.*?\*/', '', text, flags=re.S))


class ItemShopFollowup(unittest.TestCase):
    def test_steam_adds_twelve_percent_physical_or_twenty_four_with_kyoka(self):
        text = source('Systems/Systems1.j')
        start = text.index('    if typedmg == 0 or typedmg == 2 then')
        end = text.index('    if typedmg == 1 then', start)
        vm = JassState('function SteamHit takes unit c, unit td, real dmg, integer typedmg returns real\n'+
                       text[start:end]+'\nreturn dmg\nendfunction')
        audit = Audit()
        self.assertEqual(12., audit.values['ErzaWape_IncreaseDmg'])
        self.assertEqual(12., audit.values['KyokaSuigetsu_SteamBonus'])
        vm.g.update(ErzaWape_ID='steam', KyokaSuigetsu_ID='kyoka',
                    ErzaWape_IncreaseDmg=audit.values['ErzaWape_IncreaseDmg'],
                    KyokaSuigetsu_SteamBonus=audit.values['KyokaSuigetsu_SteamBonus'])
        for rank in range(1, 6): vm.g[f'PatriotW_Buff2{rank}_ID'] = f'patriot{rank}'
        c, td = vm.unit(owner=0), vm.unit(owner=1)
        for steam in (False, True):
            for kyoka in (False, True):
                vm.g.update(GetUnitAbilityLevel=lambda u, a: int(u is td and a == 'steam' and steam),
                            HasCachedItem=lambda u, a: int(u is c and a == 'kyoka' and kyoka))
                for damage_type in (0, 1, 2):
                    expected = 100. if not steam or damage_type == 1 else 124. if kyoka else 112.
                    self.assertAlmostEqual(expected, vm.run('SteamHit', (c, td, 100., damage_type)))
        self.assertIn('+24% physical damage from you in total (12% normally)', audit.expected('I06F'))

    def test_mana_headers_match_native_objects_and_damage_ranges_match_book(self):
        items = json.loads((ROOT/'object-data/items.json').read_text(encoding='utf-8-sig'))
        abilities = json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
        text = source('WOS_Start/WoS_Shop_Init.j')
        self.assertIn(shop_policy_source(items), text)
        vm = JassState(numeric(function(text, 'ShopItemManaCost')+'\n'+function(text, 'ShopItemDisplayName')))
        vm.g['GetObjectName'] = lambda _: 'Item'
        for iid, item in items.items():
            cost = max((MANA_COSTS.get(a, 0) for a in item.get('abilities', '').split(',')), default=0)
            self.assertEqual(cost, vm.run('ShopItemManaCost', (rawcode(iid),)), iid)
            self.assertEqual(cost > 0, ' MP|r Item' in vm.run('ShopItemDisplayName', (rawcode(iid),)), iid)
        for aid, reach in DAMAGE_CAST_RANGES.items():
            self.assertEqual(reach, abilities[aid]['cast_range level 1'], aid)
        for aid in ('A0FD', 'A0G0', 'A0G1', 'A02I', 'A135', 'A13C', 'A152', 'A154'):
            self.assertEqual(0, abilities[aid]['mana_cost level 1'])
        self.assertEqual(80, abilities['A0HY']['mana_cost level 1'])
        self.assertEqual(125, abilities['A13E']['mana_cost level 1'])
        self.assertEqual([20, 19, 18, 17, 16], [abilities['A077']['cooldown level '+str(i)] for i in range(1, 6)])

    def test_all_new_items_have_affordable_acyclic_recipes(self):
        audit = Audit()
        text = source('WOS_Start/WoS_Shop_Init.j')
        recipes = {}
        for item, components in re.findall(r"call RegisterCraft\((\w+|'[^']+'),\s*\"([^\"]+)\"\)", text):
            recipes[item.strip("'") if item.startswith("'") else audit.ids[item]] = components.split()
        new = 'I04F I052 I053 I054 I055 I056 I057 I058 I059 I06D I06E I06F I070 I071 I072'.split()
        def visit(iid, path):
            self.assertNotIn(iid, path)
            for component in recipes.get(iid, []):
                self.assertIn(component, audit.items)
                visit(component, path+[iid])
        for iid in new:
            self.assertTrue(recipes.get(iid), iid)
            visit(iid, [])
            self.assertLessEqual(sum(audit.items[c]['gold_cost'] for c in recipes[iid]), audit.items[iid]['gold_cost'], iid)

    def test_every_same_element_pair_is_blocked_and_other_elements_are_allowed(self):
        text = source('WOS_Start/WoS_Shop_Init.j')
        vm = JassState(numeric(function(text, 'ShopElementalClass')+'\n'+function(text, 'CheckBanItems')))
        c = vm.unit(owner=0)
        inventory = [0]*6
        vm.g.update(ShopRoundLocked=lambda _: False, CheckBanGroup=lambda *_: False,
                    ShopIsElementalKusanagi=lambda _: False,
                    UsedSlot=defaultdict(bool), ShopPlanCraftSlots=lambda *_: None,
                    IsItemInInventory=lambda c, iid: inventory.count(iid),
                    UnitItemInSlot=lambda c, slot: inventory[slot], GetItemTypeId=lambda i: i)
        for name, iid in Audit().ids.items():
            vm.g[name] = rawcode(iid)
        for incoming, element in ELEMENT_ITEMS.items():
            for carried, other in ELEMENT_ITEMS.items():
                inventory[4] = rawcode(carried)
                self.assertEqual(element == other, vm.run('CheckBanItems', (rawcode(incoming), c)), (incoming, carried))

    def test_elemental_upgrade_consumes_only_recipe_slots_and_never_bypasses_extra_conflicts(self):
        text = source('WOS_Start/WoS_Shop_Init.j')
        names = ('ShopElementalClass', 'CheckBanItems', 'CheckItemsReduceCostCraft',
                 'ReduceCostRecursive', 'ShopPlanCraftSlots', 'ShopIsElementalKusanagi', 'ShopKusanagiSwapCost')
        vm = JassState(numeric('\n'.join(function(text, n) for n in names)))
        recipes = {rawcode(a): [rawcode(c) for c in parts.split()] for a, parts in
                   re.findall(r"call RegisterCraft\('([A-Z0-9]{4})', \"([^\"]+)\"\)", text)}
        inventory = [None]*6
        hero = vm.unit(owner=0)
        vm.g.update(UsedSlot=defaultdict(bool), ShopRoundLocked=lambda _: False,
                    CheckBanGroup=lambda *_: False, UnitItemInSlot=lambda _, s: inventory[s],
                    GetItemTypeId=lambda it: it or 0,
                    GetItemValue=lambda _: self.fail('Ban checks must never create a pricing item'),
                    GetCraftComponentCount=lambda iid: len(recipes.get(iid, [])),
                    GetCraftComponent=lambda iid, i: recipes[iid][i],
                    IsItemInInventory=lambda _, iid: inventory.count(iid))
        for name, iid in Audit().ids.items(): vm.g[name] = rawcode(iid)
        for result in ('I01V',):
            inventory[:] = [rawcode('I00G')]+[None]*5
            before = inventory[:]
            self.assertFalse(vm.run('CheckBanItems', (rawcode(result), hero)), result)
            self.assertEqual(before, inventory)  # Validation must not consume or sell anything.
            self.assertTrue(vm.g['UsedSlot'][0])
            for extra in ('I00G', 'I060'):
                inventory[4] = rawcode(extra)
                self.assertTrue(vm.run('CheckBanItems', (rawcode(result), hero)), (result, extra))
            inventory[4] = None
        inventory[:] = [rawcode('I00G')]+[None]*5
        self.assertTrue(vm.run('CheckBanItems', (rawcode('I060'), hero)))

    def test_autobuy_and_whole_assembly_cannot_charge_for_banned_items(self):
        text = source('WOS_Start/WoS_Shop_Init.j')
        vm = JassState('\n'.join(function(text, f) for f in ('ShopCanPurchase', 'BuyAuto', 'BuyAutoLimited', 'QB_BuyWhole')))
        vm.g.update(CondArena=0, TestMode=False)
        c = vm.unit(owner=0)
        charges = []
        vm.g.update(GetItemValue=lambda _: 5000, GetGold=lambda _: 99999, Player=lambda x: x,
                    IsItemInInventory=lambda *_: 0, CheckBanItems=lambda *_: True,
                    CheckSlotAvailable=lambda _: True, ShopInstantStatPurchase=lambda *_: False,
                    AddGold=lambda *a: charges.append(a))
        vm.run('BuyAuto', (c, 123))
        self.assertEqual(4, vm.run('BuyAutoLimited', (c, 123, 4)))
        self.assertEqual(1, vm.run('QB_BuyWhole', (0, c, 123, 5000)))
        self.assertFalse(charges)

    def test_electrization_from_water_and_raiden_e_has_its_own_source_and_full_ticks(self):
        fixture = cycles.ItemDebuffCycles('runTest')
        vm, c, u, ns, casts = fixture.fixture()
        vm.add_ability(u, vm.g['ErzaWater_ID'])
        vm.g['GearDamageNextSource'] = rawcode('A002')
        vm.run('ErzaPassive', (c, u, 3))
        fx = ns.m_ErzaPas[0]
        self.assertEqual(6, fx.k2)
        self.assertEqual(-106, fx.damageSource)
        self.assertAlmostEqual(30., fx.dmg)
        tags = []
        vm.g['DamageSource'] = lambda tag: tags.append(tag)
        for _ in range(51):
            vm.run('Loop_Elemental')
        self.assertEqual(5, len(vm.damage))
        self.assertAlmostEqual(150., sum(hit[2] for hit in vm.damage))
        self.assertEqual([-106]*5, tags)
        raiden = source('Heroes/Raiden.j')
        self.assertIn('call ErzaPassive(c, u, 3)', raiden)

    def test_quincy_amplifies_elemental_and_new_item_hits_and_stats_split_exactly_once(self):
        helpers = source('Systems/Systems2.j')
        damage = source('Systems/DmgSys.j')
        block = re.search(r'        if ItemDamageCanReceiveQuincy.*?endif', damage, re.S)[0]
        vm = JassState(numeric(function(helpers, 'ItemDamageCanProc')+'\n'+function(helpers, 'ItemDamageCanReceiveQuincy')+
                              '\nfunction Hit takes nothing returns nothing\n'+block+'\nendfunction'))
        vm.g.update(DamageSourceBase=lambda x: x, QuincyCrossDamageActive=False, isEnemy=True,
                    QuincyCross_MaxDmg=99999., QuincyCross_DamageBase=45., QuincyCross_Item_ID=rawcode('I023'),
                    HasCachedItem=lambda *_: 1, c=None)
        for tag in (0, -111, -109, -106, -103, rawcode('I00W'), rawcode('I04C'), rawcode('I03Y'), rawcode('I02H'), rawcode('I060'), rawcode('I06A')):
            vm.g.update(damageSourceId=tag, dmg=30., quincyShare=0.)
            vm.run('Hit')
            self.assertEqual(75., vm.g['dmg'])
            stats = damage_stats.DamageStats('runTest')
            stats.setUp()
            stats.runj('DamageStatsRecordHit', 0, 2, tag, vm.g['dmg'], vm.g['quincyShare'])
            self.assertAlmostEqual(45., stats.amount(0, 0, 'I023'))
            if tag != 0:  # Untagged damage is grouped into the generic source bucket.
                self.assertAlmostEqual(30., stats.amount(0, 0, tag))
            self.assertEqual(75., stats.runj('DamageStatsTotal', 0, 0))
        for tag in (-109, rawcode('I02H'), rawcode('I00W')):
            self.assertTrue(vm.run('ItemDamageCanReceiveQuincy', (tag,)))
        for amount in (0.01, 1., 100000.):
            vm.g.update(damageSourceId=0, dmg=amount, isEnemy=False, QuincyCrossDamageActive=True, quincyShare=0.)
            vm.run('Hit')
            self.assertAlmostEqual(amount+45., vm.g['dmg'])

    def test_only_elemental_kusanagi_uses_fifteen_second_shared_active(self):
        text = source('Systems/CastAItems.j')
        block = text.split('if id == Kusanagi_Abi_ID then', 1)[1].split('call Kusanagi_Start', 1)[0]
        vm = JassState('function ItemCast takes nothing returns nothing\n'+block+'\nendfunction')
        calls = []
        vm.g.update(c=None, id='A102', KusanagiFire_ID='I047', KusanagiWater_ID='I048',
                    KusanagiElectro_ID='I049', KusanagiGrade_Cooldown=15.,
                    BlzStartUnitAbilityCooldown=lambda *args: calls.append(args))
        for item in ('I046', 'I047', 'I048', 'I049'):
            calls.clear()
            vm.g['HasCachedItem'] = lambda _, iid: int(iid == item)
            vm.run('ItemCast')
            self.assertEqual([] if item == 'I046' else [(None, 'A102', 15.)], calls)
        audit = Audit()
        for item in ('I047', 'I048', 'I049'):
            self.assertIn('Cooldown: 15 sec.', audit.expected(item))

    def test_milim_t2_and_saber_balance_match_runtime_and_objects(self):
        milim = source('Heroes/Milim.j')
        saber = source('Heroes/AlterSaber.j')
        for key, value in (('MilimT2_DamageAoe', 550), ('MilimT2_Slow', 90),
                           ('MilimT2_SlowDuration', 2)):
            self.assertRegex(milim, rf'\b{key} = {value}\b')
        self.assertIn('call SlowUnit(c, u, MilimT2_Slow, MilimT2_SlowDuration)', milim)
        abilities = json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
        self.assertEqual(40., abilities['A0HM']['cooldown level 1'])
        self.assertEqual(550., abilities['A0HM']['area_of_effect level 1'])
        for key, value in (('AlterSaberF_ManaBurnBase', 9), ('AlterSaberF_ManaBurnMorph', 9),
                           ('AlterSaberF_BurnDamageMultiplier', 1)):
            self.assertRegex(saber, rf'\b{key} = {value}\b')

    def test_koko_ticks_can_trigger_tachikaze_but_poison_and_own_hits_cannot(self):
        text = source('Systems/DmgSys.j')
        block = re.search(r'    if \(ItemDamageCanProc.*?endif', text, re.S)[0]
        helper = function(source('Systems/Systems2.j'), 'ItemDamageCanProc')
        vm = JassState(numeric(helper+'\nfunction Hit takes nothing returns nothing\n'+block+'\nendfunction'))
        hits = []
        vm.g.update(c=None, td=None, dmg=20., isEnemy=True, DamageSourceBase=lambda x: x,
                    HasCachedItem=lambda *_: 1, GetUnitAbilityLevel=lambda *_: 1,
                    Tachikaze_Start=lambda *a: hits.append(a))
        for tag, count in ((-103, 1), (rawcode('I02S'), 1), (-106, 1), (-109, 1), (rawcode('A002'), 2)):
            vm.g['damageSourceId'] = tag
            vm.run('Hit')
            self.assertEqual(count, len(hits))

    def test_siren_drains_eight_times_and_respects_int_and_max_mana_caps(self):
        text = source('Items/Items.j')
        body = text.split('elseif .kind == SIREN then', 1)[1].split('            endif\n            set v = null', 1)[0]
        body = re.sub(r'(?<![\w])\.([A-Za-z]\w*)', r'this.\1', body)
        vm = JassState('function Tick takes nothing returns nothing\nlocal real take\n'+body+'\nendfunction')
        for intellect, max_mana, expected in ((100., 5000., 250.), (1000., 1000., 200.)):
            c, u = vm.unit(), vm.unit()
            c.mana, u.mana = 0., max_mana
            fx = SimpleNamespace(c=c, u=u, next=.25, dmg2=min(2.5*intellect, max_mana*.2)/8)
            drains = []
            def mana(unit, delta):
                unit.mana += delta
                if unit is u:
                    drains.append(delta)
            vm.g.update(DT=.03, SirenTear_Return=60., UNIT_STATE_MANA='mana',
                        GetUnitState=lambda unit, _: unit.mana, SetMpCurrentQuiet=mana)
            for _ in range(67):
                vm.run('Tick', obj=fx)
            self.assertEqual(8, len(drains))
            self.assertAlmostEqual(expected, -sum(drains))
            self.assertAlmostEqual(expected*.6, c.mana)

    def test_hotkey_assignment_is_consumed_until_release_then_next_press_is_accepted(self):
        text = source('WOS_Start/WOSUI.j')
        vm = JassState('\n'.join(function(text, f) for f in ('WUI_OnCoffinCapture', 'WUI_AcceptKeyDown')))
        down = [True]
        trigger = [99]
        vm.g.update(WUI_CoffinCapturing=defaultdict(bool, {0: True}), WUI_InputState={},
                    WUI_CoffinKeyTrigger=50, WUI_InputClock=None, WUI_KeyCount=1,
                    WUI_KeyCode={1: 65}, WUI_KeyLabel={1: 'A'}, OSKEY_BACKSPACE=8, OSKEY_ESCAPE=27,
                    GetTriggerPlayer=lambda: 0, GetPlayerId=lambda x: x, GetTriggeringTrigger=lambda: trigger[0],
                    GetHandleId=lambda x: x, BlzGetTriggerPlayerKey=lambda: 65,
                    BlzGetTriggerPlayerIsKeyDown=lambda: down[0], DisableTrigger=lambda *_: None,
                    WUI_SetCoffinKey=lambda *_: True,
                    SaveBoolean=lambda table, a, b, value: table.update({(a, b, 'bool'): value}),
                    LoadBoolean=lambda table, a, b: table.get((a, b, 'bool'), False),
                    SaveReal=lambda table, a, b, value: table.update({(a, b, 'real'): value}),
                    LoadReal=lambda table, a, b: table.get((a, b, 'real'), 0.))
        vm.run('WUI_OnCoffinCapture')
        trigger[0] = 50
        self.assertFalse(vm.run('WUI_AcceptKeyDown'))
        self.assertFalse(vm.run('WUI_AcceptKeyDown'))
        down[0] = False
        self.assertFalse(vm.run('WUI_AcceptKeyDown'))
        down[0] = True
        self.assertTrue(vm.run('WUI_AcceptKeyDown'))


if __name__ == '__main__':
    unittest.main()
