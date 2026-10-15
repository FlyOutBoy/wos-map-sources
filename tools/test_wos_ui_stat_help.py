"""Attribute benefits and local gold presentation use the current balance."""
import configparser
import json
from pathlib import Path
import re
import unittest

import test_wos_ui as ui


class StatHelp(unittest.TestCase):
    def setUp(self):
        self.vm = ui.load_source('DefaultArmorChangeStable_Copy.j')
        systems = (ui.ROOT / 'triggers/Systems/Systems1.j').read_text(encoding='utf-8-sig')
        for name in ('str_hpregen', 'int_mpregen', 'agi_as', 'ARMOR_EFFECTIVENESS_PERCENT', 'WOS_ARMOR_PER_AGI', 'WOS_PHYS_RES_PER_AGI', 'WOS_MAG_RES_PER_INT'):
            self.vm.g[name] = float(re.search(r'\breal ' + name + r' = ([0-9.]+)', systems)[1])
        self.armor = 20.0
        self.vm.g.update(GetHeroStr=lambda _, bonus: 75 if bonus else 50,
                         GetHeroAgi=lambda _, bonus: 100 if bonus else 60,
                         GetHeroInt=lambda _, bonus: 30 if bonus else 20,
                         BlzGetUnitArmor=lambda _: self.armor, RMaxBJ=max, I2S=str,
                         R2SW=lambda value, _, decimals: f'{value:.{decimals}f}')

    def test_strength_and_intelligence_show_live_regen_coefficients(self):
        self.vm.g.update(str_hpregen=.35, int_mpregen=.45)
        strength = self.vm.run('UNITSTAT_AttributeHelp', ('hero', 3))
        intelligence = self.vm.run('UNITSTAT_AttributeHelp', ('hero', 5))
        for expected in ('Total: 75', 'Base (level): 50', 'Bonus (items/effects): 25',
                         'Per 1 Strength:', 'HP: +35', 'HP regen: +0.35/s'):
            self.assertIn(expected, strength)
        for expected in ('Per 1 Intelligence:', 'Mana: +10', 'Mana regen: +0.45/s'):
            self.assertIn(expected, intelligence)

    def test_agility_resistance_has_diminishing_returns_and_clamps_negative_armor(self):
        self.vm.g['agi_as'] = .009
        text = self.vm.run('UNITSTAT_AttributeHelp', ('hero', 4))
        self.assertIn('Attack speed: +0.90%', text)
        self.assertIn('Move speed: +1.00', text)
        self.assertIn('Armor: +0.10', text)
        gain = self.vm.run('UNITSTAT_ArmorResistancePerAgi', ('hero',))
        before = 20 * 1.05
        after = (20 + self.vm.g['WOS_PHYS_RES_PER_AGI']) * 1.05  # Agility counts x1.2 for physical resistance
        self.assertAlmostEqual(100 * (after / (100 + after) - before / (100 + before)), gain)
        self.armor = 100
        self.assertLess(self.vm.run('UNITSTAT_ArmorResistancePerAgi', ('hero',)), gain)
        self.armor = -.2
        self.assertEqual(0, self.vm.run('UNITSTAT_ArmorResistancePerAgi', ('hero',)))
        self.armor = -.05
        self.assertGreater(self.vm.run('UNITSTAT_ArmorResistancePerAgi', ('hero',)), 0)
        self.vm.g['ARMOR_EFFECTIVENESS_PERCENT'] = -10
        self.assertEqual(0, self.vm.run('UNITSTAT_ArmorResistancePerAgi', ('hero',)))

    def test_inline_gold_and_tooltip_follow_local_lumber_changes(self):
        amounts = {'gold': 999999, 'lumber': 3210}
        text = {}
        def resource(player, kind):
            self.assertEqual(1, player)
            return amounts[kind]
        self.vm.g.update(Player=lambda pid: pid, GetPlayerState=resource,
                         PLAYER_STATE_RESOURCE_GOLD='gold', PLAYER_STATE_RESOURCE_LUMBER='lumber',
                         UNITSTAT_Gold='gold-number', WUI_SetText=lambda f, t: text.update({f: t}))
        for income in (3210, 9876, 0):
            amounts['lumber'] = income
            self.vm.run('UNITSTAT_UpdateGold', (1,))
            self.assertEqual(f'|cffd5b876999999|r |cff00ff00+{income}|r', text['gold-number'])
            self.assertIn(f'Next round: {income}', self.vm.g['UNITSTAT_Help'][7])

    def test_display_constants_match_configured_main_gameplay_constants(self):
        config = ui.ROOT / '.vscode/wos-build.json'
        if not config.exists():
            self.skipTest('Local MAIN config is unavailable')
        map_path = Path(json.loads(config.read_text(encoding='utf-8-sig'))['mainMap'])
        if not map_path.is_absolute():
            map_path = ui.ROOT / map_path
        misc_path = map_path / 'war3mapMisc.txt'
        if not misc_path.exists():
            self.skipTest('Unpacked MAIN gameplay constants are unavailable')
        misc = configparser.ConfigParser()
        misc.read(misc_path, encoding='utf-8-sig')
        for global_name, misc_name in (('UNITSTAT_HP_PER_STR', 'StrHitPointBonus'),
                                       ('UNITSTAT_MP_PER_INT', 'IntManaBonus'),
                                       ('UNITSTAT_MS_PER_AGI', 'AgiMoveBonus'),
                                       ('WOS_ARMOR_PER_AGI', 'AgiDefenseBonus')):
            self.assertEqual(misc.getfloat('Misc', misc_name), self.vm.g[global_name], misc_name)


if __name__ == '__main__':
    unittest.main()
