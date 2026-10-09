"""Regression coverage for the music TOC fault and the unified HUD geometry."""
from pathlib import Path
from tempfile import TemporaryDirectory
import re
import unittest
from unittest.mock import patch
import install_wos_ui_assets as installer
import test_wos_ui as ui

ROOT = Path(__file__).resolve().parents[1]


class MusicResources(unittest.TestCase):
    def test_private_music_toc_is_complete_and_only_includes_needed_definitions(self):
        installer.validate_frame_resources(ROOT/'assets')
        data = (ROOT/'assets/UI/WOS/Music.toc').read_bytes()
        self.assertEqual(b'UI\\WOS\\Music.fdf\r\n\r\n', data)
        fdf = (ROOT/'assets/UI/WOS/Music.fdf').read_text(encoding='utf-8-sig')
        self.assertIn('Frame "SLIDER" "LMPHorizontalSliderTemplate"', fdf)
        self.assertIn('SliderLayoutHorizontal', fdf)
        for path in re.findall(r'"(UI\\WOS\\[^"\n]+)"', fdf):
            self.assertTrue((ROOT/'assets'/path.replace('\\', '/')).is_file(), path)

    def test_missing_music_ending_is_rejected_before_native_mutation(self):
        with TemporaryDirectory() as directory:
            root = Path(directory)
            for name in installer.FRAME_RESOURCES:
                destination = root/name
                destination.parent.mkdir(parents=True, exist_ok=True)
                destination.write_bytes((ROOT/'assets'/name).read_bytes())
            bad = root/'UI/WOS/Music.toc'
            bad.write_bytes(bad.read_bytes()[:-2])
            with self.assertRaisesRegex(ValueError, 'empty line'):
                installer.validate_frame_resources(root)

    def test_music_load_is_deferred_and_success_is_not_reloaded(self):
        fixture = ui.DeferredUIStartup()
        fixture.setUp()
        loads, observed, messages = [], [], []
        def load(path):
            loads.append(path)
            # Reproduce Warcraft's duplicate ReplayPanelStringTemplate failure.
            if path not in ('UI\\WOS\\Templates.toc',):
                raise AssertionError('stock FDF definitions must not be reparsed')
            return True
        fixture.vm.g['BlzLoadTOCFile'] = load
        vm = ui.load_source('MusicPlayer.j')
        vm.g.update(lmpTocLoaded=False, BJDebugMsg=messages.append,
                    WUI_HasMusicDefinitions=lambda: fixture.vm.run('WUI_HasMusicDefinitions'))
        fixture.vm.run('WUI_OnReady', (lambda: observed.append(list(loads)),))
        fixture.vm.run('WUI_OnReady', (lambda: vm.run('LMP_LoadTemplates'),))
        self.assertFalse(loads)
        fixture.vm.run('WUI_Bootstrap')
        vm.run('LMP_LoadTemplates')
        self.assertEqual(['UI\\WOS\\Templates.toc'], loads)
        self.assertEqual([loads], observed)
        self.assertTrue(vm.g['lmpTocLoaded'])
        self.assertFalse(messages)
        source = (ROOT/'triggers/WOS_Start/MusicPlayer.j').read_text(encoding='utf-8-sig')
        self.assertIn('WUI_OnReady(function LMP_LoadTemplates)', source)
        self.assertNotIn('BlzLoadTOCFile(', source)
        self.assertIn('shared UI\\\\WOS\\\\Templates.toc', source)
        for index in (2, 3):
            self.assertIn(f'LMP_CreateIconButton(consoleUI, WUI_TopActionX({index}), 0.580,', source)
        button = source.split('private function LMP_CreateIconButton', 1)[1].split('endfunction', 1)[0]
        self.assertIn('parent, "", context', button)

    def test_private_edit_definition_has_no_engine_include_or_global_string_table(self):
        fdf = (ROOT/'assets/UI/WOS/Music.fdf').read_text(encoding='utf-8-sig')
        self.assertIn('Frame "EDITBOX" "LMPLinkEditTemplate"', fdf)
        self.assertNotRegex(fdf, r'(?m)^\s*(IncludeFile|StringList)\b')
        self.assertNotIn('INHERITS', fdf)
        for name in ('MusicPlayer.j', 'WoS_Hero_Icons_Init.j', 'WoS_Shop_Init.j'):
            source = (ROOT/'triggers/WOS_Start'/name).read_text(encoding='utf-8-sig')
            self.assertIn('BlzCreateFrame("LMPLinkEditTemplate"', source)
            self.assertNotIn('BlzCreateFrame("EscMenuEditBoxTemplate"', source)

    def test_dynamic_track_titles_update_custom_text_child(self):
        fixture = ui.DeferredUIStartup()
        fixture.setUp()
        vm = fixture.vm
        vm.g['BlzFrameGetText'] = lambda _: ''
        control = vm.run('WUI_TextButton', ('track', 'root', '', .1, .02))
        vm.run('WUI_SetButtonText', (control, 'Example track'))
        self.assertIn(('BlzFrameSetText', ('TEXT:trackText', 'Example track')), fixture.calls)
        source = (ROOT/'triggers/WOS_Start/MusicPlayer.j').read_text(encoding='utf-8-sig')
        self.assertNotIn('BlzFrameSetText(lmpRow[row]', source)


class SharedGeometry(unittest.TestCase):
    def setUp(self):
        self.fixture = ui.DeferredUIStartup()
        self.fixture.setUp()
        self.vm = self.fixture.vm
        self.vm.run('WUI_Bootstrap')
        self.fixture.calls.clear()

    def test_top_actions_reach_physical_right_at_three_aspect_ratios(self):
        for width, height in ((1600, 1200), (1920, 1080), (3440, 1440)):
            self.vm.g.update(BlzGetLocalClientWidth=lambda: width, BlzGetLocalClientHeight=lambda: height)
            self.fixture.calls.clear()
            self.vm.run('WUI_CreateControls')
            pos = {a[0]: a[2:] for n,a in self.fixture.calls if n == 'BlzFrameSetAbsPoint'}
            sizes = {a[0]: a[1:] for n,a in self.fixture.calls if n == 'BlzFrameSetSize'}
            x,y = pos['BACKDROP:WOSTopActionsPanel']
            w,h = sizes['BACKDROP:WOSTopActionsPanel']
            self.assertAlmostEqual(.4 + .3*width/height, x+w/2)
            self.assertAlmostEqual(.6, y+h/2)
            centers = [self.vm.run('WUI_TopActionX', (i,)) for i in range(4)]
            self.assertEqual(4, len(set(centers)))
            for xx in centers:
                self.assertGreater(xx-.018, x-w/2)
                self.assertLess(xx+.018, x+w/2)

    def test_equal_lower_boxes_and_native_cells_clear_adjacent_boxes(self):
        self.vm.run('WUI_CreateHUDChrome')
        sizes = {a[0]: a[1:] for n,a in self.fixture.calls if n == 'BlzFrameSetSize'}
        positions = {a[0]: a[2:] for n,a in self.fixture.calls if n == 'BlzFrameSetAbsPoint'}
        for name in ('WOSInventorySurface', 'WOSToolbarSurface'):
            self.assertEqual((.104, .088), sizes['BACKDROP:'+name])
        self.assertEqual((.140, .140), sizes['BACKDROP:WOSMinimapSurface'])
        self.assertEqual((.608, .090), sizes['BACKDROP:WOSHUDSurface'])
        self.assertEqual((.448, .045), positions['BACKDROP:WOSHUDSurface'])
        stats_right = .196 + .104/2
        ability_left = self.vm.g['WUI_COMMAND_X'] - self.vm.g['WUI_ICON_SIZE']/2
        ability_right = self.vm.g['WUI_COMMAND_X'] + 6*self.vm.g['WUI_COMMAND_STEP'] + self.vm.g['WUI_ICON_SIZE']/2
        self.assertGreater(ability_left, stats_right)
        self.assertLess(ability_left-stats_right, .015)
        self.assertLess(ability_right, .586-.104/2)
        self.assertLess(.586+.104/2, .700-.104/2)

    def test_test_help_is_flush_right_and_commands_are_gold_explanations_white(self):
        self.vm.run('WUI_CreateTestHelp')
        positions = {a[0]: a[2:] for n,a in self.fixture.calls if n == 'BlzFrameSetAbsPoint'}
        x, _ = positions['BUTTON:WOSTestHelpPanel']
        self.assertAlmostEqual(self.vm.run('WUI_ScreenRight'), x+.210/2)
        text = self.vm.g['WUI_TestPage'][0]
        for key in ('Arrow Left', 'Arrow Right', 'Arrow Down', 'Arrow Up', 'Esc', 'Tab', 'F2', 'F3 / F4', 'Hold Z', 'K'):
            self.assertIn('|cffd5b876'+key, text)
        self.assertGreaterEqual(text.count('|cffe1e5eb'), 10)

    def test_larger_mode_buttons_have_no_overlapping_hitboxes_and_fit_the_panel(self):
        vm = ui.load_source('Starts.j')
        for name, value in self.vm.g.items():
            if callable(value) and (name.startswith('Blz') or name.startswith('Trigger') or name in ('CreateTrigger', 'I2S', 'I2R')):
                vm.g[name] = value
        for name in ('WUI_GetRoot', 'WUI_Passive', 'WUI_Window', 'WUI_Place', 'WUI_OrnateWindow', 'WUI_TextButton', 'WUI_RegisterModal'):
            vm.g[name] = lambda *args, n=name: self.vm.run(n, args)
        vm.g.update(WOS_ModeRoot=None, WUI_GOLD='gold', FRAMEPOINT_CENTER='center',
                    TEXT_JUSTIFY_MIDDLE='middle', TEXT_JUSTIFY_CENTER='center',
                    FRAMEEVENT_CONTROL_CLICK='click', GetLocalPlayer=lambda: 0, Player=lambda i: i)
        vm.run('WOS_CreateModeSelector')
        sizes = {a[0]: a[1:] for n,a in self.fixture.calls if n == 'BlzFrameSetSize'}
        positions = {a[0]: a[2:] for n,a in self.fixture.calls if n == 'BlzFrameSetAbsPoint'}
        scales = {a[0]: a[1] for n,a in self.fixture.calls if n == 'BlzFrameSetScale'}
        scale = scales['BACKDROP:WOSModeSelector']
        self.assertAlmostEqual(1.15, scale)
        px, py = positions['BACKDROP:WOSModePanel']
        pw, ph = [value*scale for value in sizes['BACKDROP:WOSModePanel']]
        last_bottom = None
        for i in range(4):
            name = f'BUTTON:WOSModeButton{i}'
            x, y = positions[name]; w, h = [value*scale for value in sizes[name]]
            self.assertAlmostEqual(.230*1.15, w)
            self.assertAlmostEqual(.037*1.20, h, places=8)
            self.assertGreater(x-w/2, px-pw/2)
            self.assertLess(x+w/2, px+pw/2)
            self.assertGreater(y-h/2, py-ph/2)
            self.assertLess(y+h/2, py+ph/2)
            if last_bottom is not None:
                self.assertLess(y+h/2, last_bottom)
            last_bottom = y-h/2

    def test_pick_portrait_has_larger_filled_moving_frame_without_covering_text(self):
        from test_wos_ui_runtime_fixes import ShopAndPickLayout
        vm, positions, sizes = ShopAndPickLayout().layout('WoS_Pick_Init.j', 'WOS_LayoutHeroPick')
        x,y = positions['FRAME_HeroPortraitBorder']; scale = vm.g['layout_scales']['FRAME_HeroPortraitBorder']
        w,h = [value*scale for value in sizes['FRAME_HeroPortraitBorder']]
        self.assertEqual((x,y), positions['FRAME_HeroModel'])
        self.assertAlmostEqual(1.15, w/sizes['FRAME_HeroModel'][0])
        self.assertAlmostEqual(1.15, h/sizes['FRAME_HeroModel'][1])
        self.assertGreater(y-h/2, positions['FRAME_HeroStr'][1]+sizes['FRAME_HeroStr'][1]/2)
        self.assertLess(y+h/2, positions['FRAME_HeroName'][1]-sizes['FRAME_HeroName'][1]/2)
        source = (ROOT/'triggers/WOS_Start/WoS_Pick_Init.j').read_text(encoding='utf-8-sig')
        self.assertIn('WUI_Window("WOSPickPortraitSurface", FRAME_MAIN3, 1, 0)', source)

    def test_level_badge_is_owned_by_portrait_not_absolute_screen_position(self):
        source = (ROOT/'triggers/Systems/TasBox.j').read_text(encoding='utf-8-sig')
        vm = ui.JassState(source)
        calls=[]
        vm.g.update(WUI_Panel=lambda *_: 'badge', WUI_Border=lambda *_: 'edge',
                    BlzCreateFrameByType=lambda *_: 'count',
                    FRAMEPOINT_BOTTOMLEFT='bottom-left', TEXT_JUSTIFY_MIDDLE='middle', TEXT_JUSTIFY_CENTER='center')
        for name in ('BlzFrameSetTexture', 'BlzFrameSetPoint', 'BlzFrameSetAllPoints', 'BlzFrameSetFont', 'BlzFrameSetTextAlignment', 'BlzFrameSetEnable'):
            vm.g[name] = lambda *args, n=name: calls.append((n,args))
        self.assertEqual('count', vm.run('CreatePortraitLabel', ('portrait',)))
        self.assertIn(('BlzFrameSetPoint', ('badge', 'bottom-left', 'portrait', 'bottom-left', -.001, -.001)), calls)
        owner = (ROOT/'triggers/WOS_Start/DefaultArmorChangeStable_Copy.j').read_text(encoding='utf-8-sig')
        self.assertIn('TasAbilityChargeBox_CreatePortraitLabel(UNITSTAT_Widget[6])', owner)


if __name__ == '__main__':
    unittest.main()
