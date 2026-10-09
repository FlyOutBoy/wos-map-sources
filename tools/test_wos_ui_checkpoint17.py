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
        self.assertEqual(b'UI\\FrameDef\\UI\\escmenutemplates.fdf\r\nUI\\WOS\\Music.fdf\r\n\r\n', data)
        fdf = (ROOT/'assets/UI/WOS/Music.fdf').read_text()
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
        vm = ui.load_source('MusicPlayer.j')
        loads, messages = [], []
        vm.g.update(lmpTocLoaded=False, BlzLoadTOCFile=lambda p: loads.append(p) or True,
                    BJDebugMsg=messages.append)
        vm.run('LMP_LoadTemplates')
        vm.run('LMP_LoadTemplates')
        self.assertEqual(['UI\\WOS\\Music.toc'], loads)
        self.assertFalse(messages)
        source = (ROOT/'triggers/WOS_Start/MusicPlayer.j').read_text()
        self.assertIn('WUI_OnReady(function LMP_LoadTemplates)', source)
        self.assertNotIn('Templates.toc', source)
        for index in (2, 3):
            self.assertIn(f'LMP_CreateIconButton(consoleUI, WUI_TopActionX({index}), 0.580,', source)
        button = source.split('private function LMP_CreateIconButton', 1)[1].split('endfunction', 1)[0]
        self.assertIn('parent, "", context', button)

    def test_dynamic_track_titles_update_custom_text_child(self):
        fixture = ui.DeferredUIStartup()
        fixture.setUp()
        vm = fixture.vm
        vm.g['BlzFrameGetText'] = lambda _: ''
        control = vm.run('WUI_TextButton', ('track', 'root', '', .1, .02))
        vm.run('WUI_SetButtonText', (control, 'Example track'))
        self.assertIn(('BlzFrameSetText', ('TEXT:trackText', 'Example track')), fixture.calls)
        source = (ROOT/'triggers/WOS_Start/MusicPlayer.j').read_text()
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
            self.assertEqual((.104, .096), sizes['BACKDROP:'+name])
        self.assertEqual((.1702, .1702), sizes['BACKDROP:WOSMinimapSurface'])
        self.assertEqual((.608, .098), sizes['BACKDROP:WOSHUDSurface'])
        self.assertEqual((.492, .049), positions['BACKDROP:WOSHUDSurface'])
        stats_right = .240 + .104/2
        ability_left = self.vm.g['WUI_COMMAND_X'] - self.vm.g['WUI_ICON_SIZE']/2
        ability_right = self.vm.g['WUI_COMMAND_X'] + 6*self.vm.g['WUI_COMMAND_STEP'] + self.vm.g['WUI_ICON_SIZE']/2
        self.assertGreater(ability_left, stats_right)
        self.assertLess(ability_left-stats_right, .01)
        self.assertLess(ability_right, .630-.104/2)
        self.assertLess(.630+.104/2, .744-.104/2)

    def test_test_help_is_flush_right_and_commands_are_gold_explanations_white(self):
        self.vm.run('WUI_CreateTestHelp')
        positions = {a[0]: a[2:] for n,a in self.fixture.calls if n == 'BlzFrameSetAbsPoint'}
        x, _ = positions['BUTTON:WOSTestHelpPanel']
        self.assertAlmostEqual(self.vm.run('WUI_ScreenRight'), x+.210/2)
        text = self.vm.g['WUI_TestPage'][0]
        for key in ('Arrow Left', 'Arrow Right', 'Arrow Down', 'Arrow Up', 'Esc', 'Tab', 'F2', 'F3 / F4', 'Hold Z', 'K'):
            self.assertIn('|cffd5b876'+key, text)
        self.assertGreaterEqual(text.count('|cffe1e5eb'), 10)

    def test_level_badge_is_owned_by_portrait_not_absolute_screen_position(self):
        source = (ROOT/'triggers/Systems/TasBox.j').read_text()
        vm = ui.JassState(source)
        calls=[]
        vm.g.update(WUI_Panel=lambda *_: 'badge', WUI_Border=lambda *_: 'edge',
                    BlzCreateFrameByType=lambda *_: 'count',
                    FRAMEPOINT_BOTTOMLEFT='bottom-left', TEXT_JUSTIFY_MIDDLE='middle', TEXT_JUSTIFY_CENTER='center')
        for name in ('BlzFrameSetTexture', 'BlzFrameSetPoint', 'BlzFrameSetAllPoints', 'BlzFrameSetFont', 'BlzFrameSetTextAlignment', 'BlzFrameSetEnable'):
            vm.g[name] = lambda *args, n=name: calls.append((n,args))
        self.assertEqual('count', vm.run('CreatePortraitLabel', ('portrait',)))
        self.assertIn(('BlzFrameSetPoint', ('badge', 'bottom-left', 'portrait', 'bottom-left', -.001, -.001)), calls)
        owner = (ROOT/'triggers/WOS_Start/DefaultArmorChangeStable_Copy.j').read_text()
        self.assertIn('TasAbilityChargeBox_CreatePortraitLabel(UNITSTAT_Widget[6])', owner)


if __name__ == '__main__':
    unittest.main()
