"""Run production HUD layout and fog-of-war guards with recorded native calls."""
from collections import defaultdict
from pathlib import Path
import re
import tempfile
import struct
import unittest
from test_crocodile import JassState
from install_wos_ui_assets import install_ui, ASSET_NAMES

ROOT = Path(__file__).resolve().parents[1]


def load_source(filename):
    source = (ROOT / 'triggers/WOS_Start' / filename).read_text(encoding='utf-8-sig')
    # Comments include retired implementations, which are not compiled by Warcraft.
    source = re.sub(r'/\*.*?\*/', '', source, flags=re.S)
    vm = JassState(source)
    for kind, name in re.findall(r'(?m)^\s*(?:private )?(\w+) array (\w+)', source):
        default = False if kind == 'boolean' else 0 if kind in ('integer', 'real') else None
        vm.g[name] = defaultdict(lambda v=default: v)
        if kind == 'framehandle':
            vm.g[name].update({i: (name, i) for i in range(24)})
    return vm


class NativeCommandLayout(unittest.TestCase):
    def setUp(self):
        self.vm = load_source('WOSUI.j')
        self.positions = {}
        self.vm.g.update({
            'WUI_OrdersOpen': False, 'WUI_CompactCommands': False,
            'WUI_COMMAND_X': .354, 'WUI_COMMAND_STEP': .040,
            'WUI_HUD_Y': .044, 'WUI_ICON_SIZE': .036,
            'FRAMEPOINT_CENTER': 'center', 'I2R': float,
            'ModuloInteger': lambda a, b: a % b,
            'BlzFrameClearAllPoints': lambda *_: None,
            'BlzFrameSetSize': lambda *_: None,
            'BlzFrameSetAbsPoint': lambda f, _, x, y: self.positions.update({f: (x, y)}),
        })

    def test_seven_existing_native_slots_and_reachable_orders(self):
        self.vm.run('WUI_LayoutCommands', (True,))
        g = self.vm.g
        for index, native in enumerate((8, 9, 10, 11, 7, 5, 6)):
            x, y = self.positions[g['WUI_Command'][native]]
            self.assertAlmostEqual(.354 + index * .040, x)
            self.assertEqual(.044, y)
        for index in range(5):
            self.assertEqual((-.20, -.20), self.positions[g['WUI_Command'][index]])
        g['WUI_OrdersOpen'] = True
        self.vm.run('WUI_LayoutCommands', (True,))
        for index in range(5):
            self.assertEqual(.139, self.positions[g['WUI_Command'][index]][1])

    def test_switch_to_ordinary_unit_preserves_all_twelve_commands(self):
        self.vm.run('WUI_LayoutCommands', (True,))
        self.vm.run('WUI_LayoutCommands', (False,))
        for frame in self.vm.g['WUI_Command'].values():
            if frame in self.positions:
                x, y = self.positions[frame]
                self.assertGreater(x, 0)
                self.assertGreaterEqual(y, .035)


class HiddenEnemyData(unittest.TestCase):
    def setUp(self):
        self.frames = {}
        self.visible = False
        self.detected = True
        self.ally = False

    def fail_read(self, *_):
        self.fail('Hidden enemy type, death or vitals were read')

    def configure(self, vm):
        vm.g.update({
            'GetLocalPlayer': lambda: 0, 'GetOwningPlayer': lambda u: u.owner,
            'IsPlayerAlly': lambda *_: self.ally,
            'IsUnitVisible': lambda *_: self.visible,
            'IsUnitDetected': lambda *_: self.detected,
            'BlzFrameSetVisible': lambda f, v: self.frames.update({(f, 'visible'): v}),
            'BlzFrameSetAlpha': lambda f, v: self.frames.update({(f, 'alpha'): v}),
            'GetUnitTypeId': self.fail_read, 'IsUnitType': self.fail_read,
            'GetWidgetLife': self.fail_read, 'BlzGetUnitMaxHP': self.fail_read,
            'GetUnitState': self.fail_read, 'BlzGetUnitMaxMana': self.fail_read,
        })

    def test_top_panel_does_not_query_hidden_enemy_changes(self):
        vm = load_source('WoS_Hero_Icons_Init.j')
        self.configure(vm)
        vm.g.update(Hero={5: vm.unit(owner=5)}, CaptainMode=False, CapPickPhase=2)
        vm.run('UpdateStatusHeroSlotOptimized', (5,))
        self.assertFalse(self.frames[vm.g['StatusHpBar'][5], 'visible'])
        self.assertFalse(self.frames[vm.g['StatusMpBar'][5], 'visible'])

    def test_visible_but_undetected_enemy_is_also_private(self):
        self.visible = True
        self.detected = False
        self.test_top_panel_does_not_query_hidden_enemy_changes()

    def test_selected_hidden_enemy_does_not_query_stats(self):
        vm = load_source('DefaultArmorChangeStable_Copy.j')
        self.configure(vm)
        selected = vm.unit(owner=5)
        vm.g.update({
            'UNITSTAT_SelectedGroup': [], 'UNITSTAT_Root': 'selected-hud',
            'UNITSTAT_Gold': 'gold', 'UNITSTAT_Hover': -1,
            'UNITSTAT_Tooltip': 'tooltip', 'GroupClear': lambda *_: None,
            'GroupEnumUnitsSelected': lambda *_: None, 'FirstOfGroup': lambda *_: selected,
            'WUI_SetText': lambda f, v: self.frames.update({(f, 'text'): v}),
            'WUI_ShowNativeBuffs': lambda v: self.frames.update({('buffs', 'visible'): v}),
            'I2S': str, 'PLAYER_STATE_RESOURCE_GOLD': 'gold',
            'PLAYER_STATE_RESOURCE_LUMBER': 'lumber',
            'GetPlayerState': lambda p, s: 120 if s == 'gold' else 45,
        })
        vm.run('UNITSTAT_Update')
        self.assertFalse(self.frames['selected-hud', 'visible'])
        self.assertIn('120', self.frames['gold', 'text'])
        self.assertIn('Next round: 45', vm.g['UNITSTAT_Help'][7])


class SharedShopControls(unittest.TestCase):
    def setUp(self):
        self.vm = JassState((ROOT / 'triggers/Systems/ButtonPressed.j').read_text(encoding='utf-8-sig'))
        self.guard = 0
        self.reloads = []
        self.visibility = []
        self.observer = False
        self.vm.g.update({
            'Hero': {0: self.vm.unit(owner=0)}, 'Shop_Active': defaultdict(bool),
            'ItemsCraftPlayerDebug_ID': defaultdict(int), 'ItemsFrameCurrentPage_ID': {0: 5},
            'ShopUICreated': True, 'FRAME_ShopMAIN': 'shop', 'END1': 0,
            'FRAME_AutoBuyCheckbox': 'auto', 'FRAME_AutoBuyText': 'auto-label',
            'FRAME_ShopItemInventorySlot': {6: 'buy', 7: 'sell'}, 'hs': {},
            'GetPlayerId': lambda p: p, 'GetHandleId': lambda p: p,
            'GetLocalPlayer': lambda: 0, 'StringHash': lambda s: s,
            'IsObserverSlot': lambda p: self.observer,
            'LoadInteger': lambda *_: self.guard,
            'SaveInteger': lambda *_: setattr(self, 'guard', 1), 'MyFlush': lambda *_: None,
            'ReloadItemPage': lambda page, p: self.reloads.append((page, p)),
            'ShopUpdateCatalogueNavigation': lambda *_: None,
            'DisplayTimedTextToPlayer': lambda *_: None,
            'BlzFrameSetVisible': lambda f, v: self.visibility.append((f, v)),
            'BlzFrameSetEnable': lambda *_: None,
        })

    def test_shop_reopens_same_page_and_debounces(self):
        self.vm.run('WOS_ToggleShop', (0,))
        self.assertTrue(self.vm.g['Shop_Active'][0])
        self.assertEqual([(5, 0)], self.reloads)
        self.vm.run('WOS_ToggleShop', (0,))
        self.assertTrue(self.vm.g['Shop_Active'][0])
        self.guard = 0
        self.vm.run('WOS_ToggleShop', (0,))
        self.assertFalse(self.vm.g['Shop_Active'][0])
        self.guard = 0
        self.vm.run('WOS_ToggleShop', (0,))
        self.assertEqual([(5, 0), (5, 0)], self.reloads)

    def test_observer_can_browse_without_autobuy_or_hero(self):
        self.observer = True
        self.vm.g['Hero'][0] = None
        self.vm.run('WOS_ToggleShop', (0,))
        self.assertTrue(self.vm.g['Shop_Active'][0])
        self.assertIn(('auto', False), self.visibility)

    def test_no_shop_before_hero_selection(self):
        self.vm.g['Hero'][0] = None
        self.vm.run('WOS_ToggleShop', (0,))
        self.assertFalse(self.reloads)
        self.assertFalse(self.vm.g['Shop_Active'][0])


class SharedImports(unittest.TestCase):
    def test_imports_preserve_existing_entries_and_are_idempotent(self):
        with tempfile.TemporaryDirectory() as directory:
            scenario = Path(directory)
            imp = scenario / 'war3map.imp'
            old_entry = b'\x0dExisting\\HeroTexture.blp\0'
            imp.write_bytes(struct.pack('<II', 1, 1) + old_entry)
            install_ui(scenario)
            first = imp.read_bytes()
            self.assertEqual(1 + len(ASSET_NAMES), struct.unpack_from('<II', first)[1])
            self.assertEqual(old_entry, first[8:8 + len(old_entry)])
            install_ui(scenario)
            self.assertEqual(first, imp.read_bytes())
            for name in ASSET_NAMES:
                self.assertEqual((ROOT / 'assets/UI/WOS' / (name + '.tga')).read_bytes(),
                                 (scenario / 'UI/WOS' / (name + '.tga')).read_bytes())


if __name__ == '__main__':
    unittest.main()
