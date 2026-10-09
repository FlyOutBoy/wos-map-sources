"""Production paths exposed by real Reforged screenshots, with native call records.

These exercise code and packaging contracts; they do not simulate game rendering.
"""
from collections import defaultdict
from pathlib import Path
import re
import struct
import tempfile
import unittest
from test_wos_ui import load_source
import test_wos_ui
from install_wos_ui_assets import hide_stock_console, install_console, CONSOLE_MODEL

ROOT = Path(__file__).resolve().parents[1]


class ConsoleHierarchy(unittest.TestCase):
    def setUp(self):
        self.fixture = test_wos_ui.DeferredUIStartup()
        self.fixture.setUp()
        self.vm = self.fixture.vm
        self.vm.run('WUI_Bootstrap')
        self.fixture.calls.clear()
        self.vm.g.update(BlzFrameGetParent=lambda f: 'detail-parent',
                         PauseTimer=lambda *_: None, ModuloInteger=lambda a, b: a % b)

    def test_detach_required_controls_before_chrome_hiding(self):
        self.vm.run('WUI_StartNativeLayout')
        calls = self.fixture.calls
        hide = next(i for i, (name, args) in enumerate(calls)
                    if name == 'visible' and args == ('named:ConsoleBottomBar', False))
        for child in ('named:CommandBarFrame', 'detail-parent',
                      'named:UpperButtonBarFrame', 'origin:ORIGIN_FRAME_UBERTOOLTIP'):
            self.assertIn(('BlzFrameSetParent', (child, 'named:ConsoleUI')), calls[:hide])
        self.assertIn(('visible', ('named:ConsoleTopBar', False)), calls)
        self.assertIn(('visible', ('named:UpperButtonBarFrame', True)), calls)
        self.assertIn(('BlzFrameSetParent', ('origin:ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR',
                                            'named:ConsoleUI')), calls[:hide])
        self.assertTrue(self.vm.g['WUI_NativeReady'])
        self.assertEqual(6, sum(name == 'BlzFrameSetAbsPoint' and str(args[0]).startswith('named:InventoryButton_')
                                for name, args in calls))

    def test_lazy_container_retries_without_hiding_or_duplicate_creation(self):
        original = self.vm.g['BlzGetFrameByName']
        self.vm.g['BlzGetFrameByName'] = lambda n, c: None if n == 'CommandBarFrame' else original(n, c)
        self.vm.run('WUI_StartNativeLayout')
        self.assertFalse(self.vm.g['WUI_NativeReady'])
        self.assertFalse(any(n == 'visible' for n, _ in self.fixture.calls))
        timer = self.fixture.timers[-1]
        self.assertEqual((.25, True), timer[1:3])
        self.vm.g['BlzGetFrameByName'] = original
        timer[3]()
        self.assertTrue(self.vm.g['WUI_NativeReady'])
        self.fixture.calls.clear()
        timer[3]()
        self.assertFalse(any(n == 'create' for n, _ in self.fixture.calls))


class TestHelpVisibility(unittest.TestCase):
    def setUp(self):
        self.fixture = test_wos_ui.DeferredUIStartup()
        self.fixture.setUp()
        self.vm = self.fixture.vm
        self.vm.run('WUI_Bootstrap')
        self.visible = defaultdict(bool)
        self.vm.g.update(BlzFrameIsVisible=lambda f: self.visible[f],
                         BlzFrameSetVisible=lambda f, v: self.visible.update({f: v}))

    def test_help_is_hidden_during_modals_then_restored_without_reopening(self):
        self.vm.run('WUI_ShowTestHelp', (True,))
        self.assertTrue(self.visible[self.vm.g['WUI_TestPanel']])
        self.vm.run('WUI_RegisterModal', ('shop',))
        self.visible['shop'] = True
        self.vm.run('WUI_RefreshHelpVisibility')
        self.assertFalse(self.visible[self.vm.g['WUI_TestPanel']])
        self.visible['shop'] = False
        self.vm.run('WUI_RefreshHelpVisibility')
        self.assertTrue(self.visible[self.vm.g['WUI_TestPanel']])
        self.vm.g['WUI_TestOpen'] = False
        self.vm.run('WUI_RefreshHelpVisibility')
        self.assertFalse(self.visible[self.vm.g['WUI_TestPanel']])
        self.assertTrue(self.visible[self.vm.g['WUI_TestToggle']])

    def test_scroll_pages_remain_bounded_without_toggling_panel(self):
        self.vm.g.update(GetLocalPlayer=lambda: 0, GetTriggerPlayer=lambda: 0,
                         BlzGetTriggerFrame=lambda: self.vm.g['WUI_TestPanel'],
                         BlzGetTriggerFrameValue=lambda: -1,
                         BlzFrameGetText=lambda _: '', BlzFrameSetText=lambda *_: None)
        for _ in range(10):
            self.vm.run('WUI_TestScroll')
        self.assertEqual(2, self.vm.g['WUI_TestPageIndex'])
        self.assertTrue(self.vm.g['WUI_TestOpen'])
        self.vm.g['BlzGetTriggerFrameValue'] = lambda: 1
        for _ in range(10):
            self.vm.run('WUI_TestScroll')
        self.assertEqual(0, self.vm.g['WUI_TestPageIndex'])


class TexturedVitals(unittest.TestCase):
    def setUp(self):
        self.vm = load_source('WOSUI.j')
        self.sizes = []
        self.vm.g.update({
            'WUI_Fills': {}, 'GetHandleId': lambda f: f,
            'BlzCreateFrameByType': lambda kind, n, parent, *_: (kind, n, parent),
            'BlzFrameSetTexture': lambda *_: None, 'BlzFrameSetEnable': lambda *_: None,
            'BlzFrameSetSize': lambda *args: self.sizes.append(args),
            'SaveReal': lambda h, p, c, v: h.update({(p, c): v}),
            'LoadReal': lambda h, p, c: h.get((p, c), 0),
            'HaveSavedReal': lambda h, p, c: (p, c) in h,
            'BlzFrameGetValue': lambda *_: self.fail('Textured fill used model value API'),
        })
        self.fill = self.vm.run('WUI_CreateFill', ('HP', 'hud-root', .275, .007, 100, 'hp.tga'))
        self.sizes.clear()

    def test_proportional_width_clamped_without_reanchoring(self):
        self.assertEqual('BACKDROP', self.fill[0])
        for value, width in ((50, .1375), (-5, 0), (150, .275)):
            self.vm.run('WUI_SetValue', (self.fill, value))
            self.assertAlmostEqual(width, self.sizes[-1][1])
            self.assertEqual(.007, self.sizes[-1][2])
        before = len(self.sizes)
        self.vm.run('WUI_SetValue', (self.fill, 150))
        self.assertEqual(before, len(self.sizes))


class ModeTransitions(unittest.TestCase):
    def setUp(self):
        self.vm = load_source('Starts.j')
        self.events = []
        self.vm.g.update(PickedMode=0, PlayersAmount=1, WOS_ModeRoot='selector',
                         TestMode=False, CaptainMode=False, CaptainDraftMode=False,
                         CaptainDraftPreRoundUnlimitedSwap=False,
                         CaptainDraftSoundModeStart='draft-sound', GAME_STATE_TIME_OF_DAY='day',
                         TestComm=lambda: self.events.append('test'),
                         Map_Start=lambda: self.events.append('start'),
                         CaptainDraft_StartFirstSideVote=lambda: self.events.append('vote'),
                         CaptainDraft_PlayConfiguredSound=lambda *_: self.events.append('sound'),
                         PlayersMsg=lambda *_: None, BlzFrameSetVisible=lambda *_: None,
                         CreateTimer=lambda: 'timer', TimerStart=lambda *_: self.events.append('music'),
                         SetFloatGameState=lambda *_: None, GetExpiredTimer=lambda: 'timeout',
                         DestroyTimer=lambda *_: None, Player=lambda p: p,
                         GetTriggerPlayer=lambda: 0)

    def test_all_modes_preserve_flags_and_start_once(self):
        for mode in range(1, 5):
            with self.subTest(mode=mode):
                self.vm.g['PickedMode'] = 0
                self.events.clear()
                self.vm.run('WOS_SelectMode', (mode,))
                self.vm.run('CheckPickedMode')
                self.assertEqual(mode, self.vm.g['PickedMode'])
                self.assertEqual((mode == 2, mode == 3, mode == 4, mode == 4),
                                 tuple(self.vm.g[k] for k in ('TestMode', 'CaptainMode',
                                      'CaptainDraftMode', 'CaptainDraftPreRoundUnlimitedSwap')))
                self.assertEqual(1, self.events.count('start'))
                self.assertEqual(mode == 2, 'test' in self.events)
                self.assertEqual(mode == 4, 'vote' in self.events)

    def test_non_host_cannot_choose_mode_and_timeout_defaults_normal(self):
        self.vm.g['GetTriggerPlayer'] = lambda: 1
        self.vm.run('WOS_ModeFrameClick')
        self.assertEqual(0, self.vm.g['PickedMode'])
        self.vm.run('CheckPickedMode')
        self.assertEqual(1, self.vm.g['PickedMode'])
        self.assertEqual(['music', 'start'], self.events)


class ShopAndPickLayout(unittest.TestCase):
    def layout(self, file, function):
        vm = load_source(file)
        source = (ROOT / 'triggers/WOS_Start' / file).read_text(encoding='utf-8-sig')
        positions, sizes = {}, {}
        vm.g['layout_scales'] = {}
        for name in re.findall(r'^\s*framehandle (\w+)\s*$', source, re.M):
            vm.g[name] = name
        for name in re.findall(r'^\s*framehandle array (\w+)', source, re.M):
            vm.g[name].update({i: (name, i) for i in range(96)})
        # In these layouts both operands are JASS integers; Python '/' differs.
        vm.methods[function] = re.sub(r'\bi / ([257])\b', r'jass_div(i, \1)', vm.methods[function])
        vm.g.update({
            'WUI_Place': lambda f, x, y, w, h: (positions.update({f: (x, y)}), sizes.update({f: (w, h)})),
            'WUI_Pin': lambda f, owner, x, y, w, h: (positions.update({f: (positions[owner][0]+x, positions[owner][1]+y)}), sizes.update({f: (w, h)})),
            'BlzFrameSetScale': lambda f, scale: vm.g['layout_scales'].update({f: scale}), 'BlzFrameSetAllPoints': lambda *_: None,
            'BlzFrameSetTexture': lambda *_: None, 'BlzFrameSetLevel': lambda *_: None,
            'BlzFrameSetEnable': lambda *_: None, 'BlzFrameClearAllPoints': lambda *_: None,
            'BlzFrameSetPoint': lambda *_: None, 'BlzFrameSetTextAlignment': lambda *_: None,
            'WUI_Tooltip': lambda *_: None, 'I2R': float, 'ModuloInteger': lambda a, b: a % b,
            'WUI_BORDER_TEXTURE': 'border', 'WUI_PANEL_TEXTURE': 'panel',
            'jass_div': lambda a, b: a // b,
            'RAbsBJ': abs, 'RMaxBJ': max,
            'FRAMEPOINT_TOP': 'top', 'FRAMEPOINT_BOTTOM': 'bottom',
            'TEXT_JUSTIFY_TOP': 'top', 'TEXT_JUSTIFY_MIDDLE': 'middle',
            'TEXT_JUSTIFY_LEFT': 'left', 'TEXT_JUSTIFY_CENTER': 'center',
        })
        vm.run(function)
        return vm, positions, sizes

    def test_all_shop_controls_fit_inside_their_panels(self):
        vm, pos, sizes = self.layout('WoS_Shop_Init.j', 'WOS_LayoutShop')
        for array, panel, count, start in (('FRAME_ShopItem', 'FRAME_ShopItemList', 35, 0),
                                          ('FRAME_ShopItem', 'FRAME_ShopItemCraft', 7, 36),
                                          ('FRAME_ShopItemInventorySlot', 'FRAME_ShopItemInventory', 8, 0),
                                          ('FRAME_ShopSection', 'FRAME_ShopMAIN', 7, 0)):
            px, py = pos[panel]; pw, ph = sizes[panel]
            for index in range(start, start + count):
                frame = vm.g[array][index]; x, y = pos[frame]; w, h = sizes[frame]
                self.assertGreaterEqual(x - w / 2, px - pw / 2)
                self.assertLessEqual(x + w / 2, px + pw / 2)
                self.assertGreaterEqual(y - h / 2, py - ph / 2)
                self.assertLessEqual(y + h / 2, py + ph / 2)

    def test_pick_grid_and_player_rows_are_compact(self):
        vm, pos, sizes = self.layout('WoS_Pick_Init.j', 'WOS_LayoutHeroPick')
        self.assertEqual((.656, .426), sizes['FRAME_MAIN'])
        self.assertEqual(30, len([f for f in pos if isinstance(f, tuple) and f[0] == 'FRAME_ICON']))
        self.assertEqual(7, len([f for f in pos if isinstance(f, tuple) and f[0] == 'FRAME_ICON5']))
        for i in range(10):
            x, y = pos[vm.g['FRAME_PlayerPick'][i]]
            self.assertTrue(.092 < x < .748)
            self.assertEqual(.155, y)


class ConsoleAssets(unittest.TestCase):
    def test_skin_overrides_preserve_other_sections_and_are_idempotent(self):
        original = '[CustomSkin]\nLumberIcon=my-icon.blp\nConsoleTexture01=old\n\n[FrameDef]\nLUMBER=TRIGSTR_12\n'
        updated = hide_stock_console(original)
        self.assertIn('LumberIcon=my-icon.blp', updated)
        self.assertIn('[FrameDef]\nLUMBER=TRIGSTR_12\n', updated)
        self.assertEqual(updated, hide_stock_console(updated))
        self.assertEqual(1, updated.count('ConsoleTexture01='))

    def test_import_is_idempotent_and_keeps_existing_entries(self):
        with tempfile.TemporaryDirectory() as directory:
            scenario = Path(directory)
            entry = b'\x0dexisting.blp\0'
            (scenario / 'war3map.imp').write_bytes(struct.pack('<II', 1, 1) + entry)
            (scenario / 'war3mapSkin.txt').write_text('[CustomSkin]\nLumberIcon=custom.blp\n')
            install_console(scenario)
            first = (scenario / 'war3map.imp').read_bytes()
            install_console(scenario)
            self.assertEqual(first, (scenario / 'war3map.imp').read_bytes())
            self.assertEqual(entry, first[8:8 + len(entry)])
            self.assertEqual(2, struct.unpack_from('<II', first)[1])
            self.assertEqual((ROOT / 'assets' / CONSOLE_MODEL).read_bytes(), (scenario / CONSOLE_MODEL).read_bytes())


if __name__ == '__main__':
    unittest.main()
