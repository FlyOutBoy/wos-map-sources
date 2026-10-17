"""Checkpoint 21: ability preview/levels, pick stats, shop tree, cover, swap, hotkeys."""
from pathlib import Path
import re
import unittest

import test_wos_ui as ui
from install_wos_ui_assets import ASSET_NAMES, FRAME_RESOURCES, validate_frame_resources
from install_wos_ui_assets import CP21_NAMES  # builder needs Pillow; installer list is the contract

ROOT = Path(__file__).resolve().parents[1]
WOS = ROOT / 'triggers/WOS_Start'


def read(name):
    return (WOS / name).read_text(encoding='utf-8-sig')


class LevelTable(unittest.TestCase):
    def setUp(self):
        self.source = read('ShowCD.j')
        self.rows = {code: tuple(map(int, rest.split(', ')))
                     for code, rest in re.findall(r"AHUI_SetLevelInfo\('(\w{4})', ([0-9, ]+)\)", self.source)}

    def test_every_base_slot_skill_has_object_data_levels(self):
        ids = {}
        for path in (ROOT / 'triggers').rglob('*.j'):
            for name, code in re.findall(r"\binteger\s+(\w+_ID)\s*=\s*'(\w{4})'", path.read_text(encoding='utf-8', errors='replace')):
                ids.setdefault(name, code)
        for name in re.findall(r'AHUI_AddHeroAbility\(whichHero, AHUI_SLOT_\w, (\w+)\)', self.source):
            self.assertIn(ids[name], self.rows, name)
        # Crocodile: Q five levels from hero level 1 every 4; T one level at 25.
        self.assertEqual((5, 1, 4), self.rows[ids['CrocodileQ_ID']])
        self.assertEqual((1, 25, 3), self.rows[ids['CrocodileT_ID']])

    def test_alt_learning_is_gone_and_pips_learn_on_click(self):
        self.assertNotIn('OSKEY_LALT', self.source)
        self.assertNotIn('AHUI_AltHit', self.source)
        self.assertIn('BlzTriggerRegisterFrameEvent(AHUI_LearnTrigger, AHUI_LearnButton[slot], FRAMEEVENT_CONTROL_CLICK)', self.source)

    def test_tooltip_is_a_compact_column(self):
        width = float(re.search(r'AHUI_TOOLTIP_WIDTH = ([0-9.]+)', self.source)[1])
        self.assertLess(width, 0.25)
        wui = read('WOSUI.j')
        self.assertIn('FRAMEPOINT_BOTTOMRIGHT, 0.598, 0.150', wui)


class PickStats(unittest.TestCase):
    def test_fallback_table_has_melee_and_ranged_heroes(self):
        source = read('WoS_Pick_Init.j')
        rows = {code: list(map(int, rest.split(', ')))
                for code, rest in re.findall(r"WOS_PickStatRow\('(\w{4})', ([0-9, ]+)\)", source)}
        self.assertGreaterEqual(len(rows), 30)
        self.assertEqual(1, rows['H01X'][7])   # Starrk: melee
        self.assertEqual(0, rows['H01Z'][7])   # Alucard: ranged
        self.assertTrue(all(row[0] > 0 or row[2] > 0 for row in rows.values()))
        self.assertNotIn('" |cffd5b876*|r"', source)
        self.assertIn('stat-underline.tga', source)
        self.assertIn('attack-melee.tga', source)


class ShopTree(unittest.TestCase):
    def setUp(self):
        self.vm = ui.load_source('WoS_Shop_Init.j')

    def test_tree_frames_and_slots_are_inverse(self):
        frames = [self.vm.run('ShopTreeFrame', (slot,)) for slot in range(24)]
        self.assertEqual(24, len(set(frames)))
        self.assertNotIn(42, frames)
        for slot, frame in enumerate(frames):
            self.assertEqual(slot, self.vm.run('ShopTreeSlotFromFrame', (frame,)))
        self.assertEqual(-1, self.vm.run('ShopTreeSlotFromFrame', (42,)))

    def test_rows_of_one_to_five_fit_the_tree_panel_without_overlap(self):
        # Checkpoint 24: wider tree panel (.252 at SHOP_TREE_X), up to 6 per row.
        centre = self.vm.g['SHOP_TREE_X']
        left, right = centre - 0.126, centre + 0.126
        for count in range(1, 7):
            size = self.vm.run('ShopTreeIconSize', (count,))
            step = self.vm.run('ShopTreeStep', (count,))
            xs = [centre + (k - (count - 1) * 0.5) * step for k in range(count)]
            self.assertGreaterEqual(min(xs) - size / 2, left)
            self.assertLessEqual(max(xs) + size / 2, right - 0.012)   # clear of the slider
            for a, b in zip(xs, xs[1:]):
                self.assertGreater(b - a, size)
        # Top-row prices sit above their icons, below the "ITEM TREE" title.
        self.assertLess(0.432 + 0.036 / 2 + 0.006 + 0.005, 0.473 - 0.006)

    def test_paging_uses_the_row_size(self):
        # Checkpoint 24b: the first level pages by six (second level is derived).
        self.assertEqual(0, self.vm.run('GetCraftMaxOffset', (6,)))
        self.assertEqual(6, self.vm.run('GetCraftMaxOffset', (7,)))
        self.assertEqual(12, self.vm.run('GetCraftMaxOffset', (13,)))


class Cover(unittest.TestCase):
    def setUp(self):
        dock = ui.DynamicHeroAndBuffDocks()
        dock.setUp()
        self.dock = dock
        self.layer_visible = []
        self.dock.vm.g.update(WUI_CoverWatch='shop', BlzFrameSetVisible=lambda f, v: (self.dock.visible.update({f: v}), self.layer_visible.append((f, v))),
                              WUI_HeroLayer='layer')

    def test_open_shop_parks_docks_and_hides_hero_layer_then_restores(self):
        self.dock.register('meter')
        self.dock.vm.run('WUI_RefreshDocks')
        self.assertAlmostEqual(.162, self.dock.positions['meter'][1])
        self.dock.visible['shop'] = True
        self.dock.vm.run('WUI_RefreshDocks')
        self.assertEqual((-0.5, -0.5), self.dock.positions['meter'])
        self.assertIn(('layer', False), self.layer_visible)
        self.assertTrue(self.dock.visible['meter'], 'owner visibility is never touched')
        self.dock.visible['shop'] = False
        self.dock.vm.run('WUI_RefreshDocks')
        self.assertAlmostEqual(.162, self.dock.positions['meter'][1])
        self.assertIn(('layer', True), self.layer_visible)


class SwapFlow(unittest.TestCase):
    def setUp(self):
        self.source = read('WoS_Hero_Icons_Init.j')

    def test_request_opens_offer_and_success_closes_it(self):
        swap = re.search(r'function SwapActions takes.*?endfunction', self.source, re.S)[0]
        self.assertIn('call WOS_SwapOfferShow(pid2, pid)', swap)
        self.assertIn('call WOS_SwapOfferHide(pid)', swap)
        self.assertIn('call WOS_SwapOfferHide(pid2)', swap)

    def test_accept_requires_a_matching_request_and_decline_clears_it(self):
        click = re.search(r'function WOS_SwapUIOnClick takes.*?endfunction', self.source, re.S)[0]
        self.assertIn('SwapRequests[from] == pid then\n                call SwapActions(p, Player(from))', click)
        self.assertIn('set SwapRequests[from] = -1', click)
        self.assertIn('Round1Started == 0', click)

    def test_swap_button_routes_to_menu_with_test_toggle(self):
        pick = read('WoS_Pick_Init.j')
        self.assertIn('if WOS_SwapUsesMenu(pid) then\n            call WOS_SwapMenuToggle(p)', pick)
        self.assertIn('return not TestMode or WOS_SwapTestReal[pid]', self.source)
        self.assertIn('glyph-swap-off.tga', self.source)


class Hotkeys(unittest.TestCase):
    def setUp(self):
        fixture = ui.DeferredUIStartup()
        fixture.setUp()
        self.vm = fixture.vm
        self.registered = []
        self.messages = []
        self.state = {'player': 3, 'key': 'L'}
        self.vm.g.update(PauseTimer=lambda *_: None, ExecuteFunc=lambda *_: None, SCOPE_PRIVATE='', TriggerAddCondition=lambda *_: None, Condition=lambda f: f, OSKEY_TAB=('oskey', 9))
        self.vm.g.update(
            ConvertOsKeyType=lambda code: chr(code), SubString=lambda s, a, b: s[a:b], StringLength=len,
            Player=lambda i: i, GetPlayerId=lambda p: p, GetLocalPlayer=lambda: 3,
            GetTriggerPlayer=lambda: self.state['player'], BlzGetTriggerPlayerKey=lambda: self.state['key'],
            GetTriggeringTrigger=lambda: 'capture', DisableTrigger=lambda *_: None,
            OSKEY_ESCAPE='esc', BlzTriggerRegisterPlayerKeyEvent=lambda *a: self.registered.append(a),
            BlzTriggerRegisterFrameEvent=lambda *a: None, DisplayTimedTextToPlayer=lambda *a: self.messages.append(a),
            BlzGetTriggerFrame=lambda: self.vm.g['WUI_HotkeyButton'][0], WUI_Tooltip=lambda *_: None,
        )
        self.vm.run('WUI_Bootstrap')
        self.vm.run('WUI_RegisterHotkey', (0, 'ping-keys', 'Z', 'Z', True, 'toolbar'))

    def test_default_key_is_registered_for_every_player_and_edge(self):
        for pid in range(16):
            self.assertEqual('Z', self.vm.run('WUI_GetHotkey', (0, pid)))
        self.assertIn(('ping-keys', 5, 'Z', 0, True), self.registered)
        self.assertIn(('ping-keys', 5, 'Z', 0, False), self.registered)

    def test_badge_click_then_key_rebinds_only_that_player(self):
        self.vm.run('WUI_OnHotkeyBadge')
        # Ability keys are never offered as hotkeys.
        offered = {a[2] for a in self.registered if a[0] != 'ping-keys'}
        self.assertNotIn('Q', offered)
        self.assertIn('L', offered)
        self.vm.run('WUI_OnCapture')
        self.assertEqual('L', self.vm.run('WUI_GetHotkey', (0, 3)))
        self.assertEqual('L', self.vm.run('WUI_GetHotkeyName', (0, 3)))
        self.assertEqual('Z', self.vm.run('WUI_GetHotkey', (0, 4)))
        self.assertIn(('ping-keys', 3, 'L', 0, True), self.registered)

    def test_escape_keeps_the_current_key(self):
        self.vm.run('WUI_OnHotkeyBadge')
        self.state['key'] = 'esc'
        self.vm.run('WUI_OnCapture')
        self.assertEqual('Z', self.vm.run('WUI_GetHotkey', (0, 3)))


class EmoteWheel(unittest.TestCase):
    def test_emotes_use_a_hold_wheel_and_rebindable_key(self):
        source = read('EMOTES.j')
        self.assertIn('wheel-ring.tga', source)
        self.assertIn('WUI_RegisterHotkey(WUI_HOTKEY_EMOTE, EmojiKeyTrigger, EmojiMenuKey, "K", true, EmojiHotkeyOwner)', source)
        self.assertIn('BlzSendSyncData("WEMJ", I2S(EmojiHover))', source)
        pings = read('TeamMapPings.j')
        self.assertIn('wheel-base.tga', pings)
        self.assertNotIn('OSKEY_Z, meta', pings)


class AssetsAndTemplates(unittest.TestCase):
    def test_new_textures_are_generated_and_registered(self):
        self.assertTrue(set(CP21_NAMES) <= ASSET_NAMES)
        for name in CP21_NAMES:
            data = (ROOT / 'assets/UI/WOS' / (name + '.tga')).read_bytes()
            self.assertEqual(b'\x00\x02', data[1:3], name)
            self.assertEqual((32, 8), (data[16], data[17] & 15), name)
        for source in ('ShowCD.j', 'WoS_Pick_Init.j', 'WoS_Shop_Init.j', 'WoS_Hero_Icons_Init.j', 'EMOTES.j',
                       'TeamMapPings.j', 'WOSUI.j', 'DefaultArmorChangeStable_Copy.j'):
            for path in re.findall(r'UI\\\\WOS\\\\([\w-]+)\.tga', read(source)):
                self.assertIn(path, ASSET_NAMES, f'{source}: {path}')

    def test_templates_are_appended_to_the_last_fdf(self):
        validate_frame_resources(ROOT / 'assets')
        fdf = (ROOT / 'assets/UI/WOS/WOSControls.fdf').read_text()
        self.assertIn('Frame "BUTTON" "WOSTextButtonTemplate"', fdf)
        self.assertIn('HIGHLIGHTONMOUSEOVER', fdf)
        self.assertIn('Frame "EDITBOX" "WOSEditBox"', fdf)
        self.assertLess(fdf.index('WOSNativeMenuSkin'), fdf.index('WOSTextButtonTemplate'))


if __name__ == '__main__':
    unittest.main()
