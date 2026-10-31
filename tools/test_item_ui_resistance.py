"""Native data, scenery interactions and shop layout for the item follow-up."""
from pathlib import Path
from collections import defaultdict
import json
import re
import unittest

from test_crocodile import JassState
from install_gameplay_constants import mana_regen_per_int, patch_misc
from build_ability_level_table import build_block, BEGIN, END
import war3_object_data as raw
import war3_object_workspace as objects

ROOT = Path(__file__).resolve().parents[1]


def source(name):
    return (ROOT/'triggers'/name).read_text(encoding='utf-8-sig')


def function(text, name):
    return re.search(r'(?m)^\s*(?:(?:private|public) )?function '+name+r' takes.*?endfunction', text, re.S)[0]


class ItemUIResistance(unittest.TestCase):
    def test_native_duration_ring_cooldown_and_invulnerable_silence_targets(self):
        docs, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
        doc = next(d for d in docs if d['source_file'] == 'war3map.w3a')
        packed = raw.parse_object_file(raw.encode_object_file(doc, 'war3map.w3a'),
                                       'war3map.w3a', 'abilities', 'level', {})
        index = {objects.object_id(o): o for o in packed['custom_objects']}
        def mod(aid, field, level):
            return next(m for m in index[aid]['modifications']
                        if m['field']['text'] == field and m.get('level') == level)
        for aid, level in [('A01H', 2), ('A07L', 1)]:
            for field in ('adur', 'ahdu'):
                record = mod(aid, field, level)
                self.assertEqual(('unreal', 10.), (record['type'], record['data']['value']))
        self.assertEqual(20., mod('A154', 'acdn', 1)['data']['value'])
        for aid, ranks in [('A133', [1]), ('A01V', range(1, 11))]:
            for level in ranks:
                targets = mod(aid, 'atar', level)['data']['value'].split(',')
                self.assertIn('invulnerable', targets)
                self.assertIn('vulnerable', targets)
        self.assertEqual(2., mod('A01V', 'ahdu', 4)['data']['value'])

    def test_native_mana_regen_patch_preserves_other_constants_and_endings(self):
        self.assertEqual(.15, mana_regen_per_int())
        before = b'\xef\xbb\xbf[Misc]\r\nIntManaBonus=10.0\r\nIntRegenBonus=0.2\r\nStrRegenBonus=0.2\r\n[Other]\r\nIntRegenBonus=9\r\n'
        after = patch_misc(before, mana_regen_per_int())
        self.assertEqual(before.replace(b'IntRegenBonus=0.2', b'IntRegenBonus=0.15'), after)
        self.assertEqual(after, patch_misc(after, .15))
        with self.assertRaises(ValueError):
            patch_misc(b'[Misc]\nIntManaBonus=10.0\n', .15)

    def test_two_mana_amplifiers_each_add_fifteen_percent(self):
        vm = JassState(function(source('Systems/Systems2.j'), 'GetManaAmp'))
        item_source = source('Items/Items.j')
        constants = {name: float(value) for name, value in re.findall(
            r'real (FrozenHeart_ManaAmp|FairyTailEvolved_ManaAmp) = ([0-9.]+)', item_source)}
        self.assertEqual({'FrozenHeart_ManaAmp': 15., 'FairyTailEvolved_ManaAmp': 15.}, constants)
        equipped = [False]
        vm.g.update(constants)
        vm.g.update(FrozenHeart_Buff_ID='frozen', FairyTailEvolved_ID='emblem',
                    HasCachedItem=lambda *_: int(equipped[0]))
        u = vm.unit()
        self.assertEqual(0., vm.run('GetManaAmp', (u,)))
        vm.add_ability(u, 'frozen')
        self.assertEqual(.15, vm.run('GetManaAmp', (u,)))
        equipped[0] = True
        self.assertEqual(.30, vm.run('GetManaAmp', (u,)))

    def test_scenery_explosion_damage_is_not_counted_as_item_hit_healing(self):
        vm = JassState(function(source('Items/Items.j'), 'ElemHit'))
        c, u = vm.unit(owner=0), vm.unit(owner=1)
        u.life = 1000.
        def scenery(*_):
            u.life -= 200.
        def damage(caster, victim, amount):
            victim.life -= amount
        vm.g.update(ItemActive_DecorDamage=50., DecorRemove=scenery, dmgphys=damage,
                    DamageSource=lambda _: None)
        self.assertEqual(100., vm.run('ElemHit', (c, u, 1, 100., False, 0)))
        self.assertEqual(700., u.life)

    def test_ability_level_table_matches_current_objects_and_tsuna_w_uses_four_level_steps(self):
        abilities = json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
        text, block = build_block(abilities)
        self.assertEqual(block.replace('\r\n', '\n'), text[text.index(BEGIN):text.index(END)+len(END)])
        self.assertIn("AHUI_SetLevelInfo('A083', 5, 1, 4)", block)

    def test_shop_description_keeps_slider_gutter_and_eight_lines_inside_expanded_panel(self):
        text = source('WOS_Start/WoS_Shop_Init.j')
        self.assertIn('SHOP_DESC_LINES = 8', text)
        self.assertIn('SHOP_DESC_CHARS = 48', text)
        self.assertIn('Shop_Place(FRAME_ShopItemDescription, SHOP_TREE_X, 0.170, 0.252, 0.132)', text)
        self.assertIn('Shop_Place(FRAME_ShopItemDescriptionName2, SHOP_TREE_X - 0.003, 0.158, 0.218, 0.094)', text)
        self.assertLess(-.003 + .218/2, .117 - .009/2)
        self.assertGreater(.158-.094/2, .170-.132/2)
        self.assertLess(.158+.094/2, .223-.016/2)
        self.assertLessEqual(8*.0095*1.2, .094)
        self.assertIn('FRAME_ShopItemDescriptionName2, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT', text)

    def test_description_header_mana_is_separate_and_hidden_for_passive_items(self):
        text = source('WOS_Start/WoS_Shop_Init.j')
        vm = JassState(function(text, 'ShopDescriptionHeader'))
        visible, values, places = {}, {}, []
        vm.g.update(FRAME_ShopDescriptionManaIcon='icon', FRAME_ShopDescriptionManaText='mana',
                    FRAME_ShopItemDescriptionName='title', SHOP_TREE_X=.5,
                    ShopItemManaCost=lambda iid: 175 if iid == 1 else 0,
                    BlzFrameSetVisible=lambda f, value: visible.update({f: value}),
                    BlzFrameSetText=lambda f, value: values.update({f: value}),
                    Shop_Place=lambda *args: places.append(args))
        vm.run('ShopDescriptionHeader', (1,))
        self.assertTrue(visible['icon']); self.assertTrue(visible['mana'])
        self.assertIn('175', values['mana'])
        self.assertGreater(places[-1][1]-.160/2, .5-.080+.032/2)
        vm.run('ShopDescriptionHeader', (0,))
        self.assertFalse(visible['icon']); self.assertFalse(visible['mana'])
        header = function(text, 'ShopShowItemDescription')
        self.assertNotIn('ShopItemDisplayName(id)', header)
        self.assertNotIn('CreateFrame', function(text, 'ShopDescriptionHeader'))
        self.assertNotIn('CreateFrame', function(text, 'ShopSetItemTooltipHeader'))

    def test_silence_unit_issues_correct_rank_order_to_invulnerable_target(self):
        code = function(source('Systems/Systems1.j'), 'SilenceUnit')
        code = re.sub(r'(?m)^(\s*set [^=\n]+?)\s*=\s*', r'\1 = ', code)
        vm = JassState(code)
        c, target = vm.unit(owner=0), vm.unit(owner=1)
        vm.add_ability(target, 'Avul')
        orders = []
        vm.g.update(DummyPlayer=defaultdict(lambda: None), hs={},
                    GetPlayerId=lambda p: p, Player=lambda p: p,
                    GetRectCenterX=lambda _: 0., GetRectCenterY=lambda _: 0., gg_rct_Caster=None,
                    CreateUnit=lambda p, *_: vm.unit(owner=p), HasCachedItem=lambda *_: 0,
                    DebuffImmune_Start=lambda u, rank: rank, ShunShunRikka_Buff_ID='rikka',
                    SH_ERZA_G2_ACTIVE='erza', SH_ERZA_G2_TYPE='type', SH_NAOFUMI_SHIELD='shield',
                    GAngle=lambda *_: 0., SetUnitFacing=lambda *_: None,
                    IssueTargetOrder=lambda d, order, u: orders.append((d, order, u)),
                    SetUnitAbilityLevel=lambda u, aid, rank: u.abilities[aid].update(level=rank))
        vm.run('SilenceUnit', (c, target, 2.))
        self.assertEqual(1, len(orders))
        dummy, order, u = orders[0]
        self.assertIs(target, u); self.assertEqual('drunkenhaze', order)
        self.assertEqual(4, dummy.abilities['A01V']['level'])
        self.assertEqual(target.owner, dummy.owner)
        seal = function(source('Items/Items.j'), 'SealStart')
        self.assertIn('SpellBoolCaster(td)', seal)
        self.assertNotIn('not SpellBool(td)', seal)


if __name__ == '__main__':
    unittest.main()
