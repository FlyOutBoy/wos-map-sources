"""Shared backup-style definitions and selected-hero layout regressions."""
from pathlib import Path
import unittest
import test_wos_ui as ui

ROOT = Path(__file__).resolve().parents[1]


class SharedDefinitions(unittest.TestCase):
    def test_single_manifest_orders_dependencies_without_duplicate_engine_templates(self):
        data = (ROOT/'assets/UI/WOS/Templates.toc').read_bytes()
        self.assertEqual([b'UI\\WOS\\WOSHUD.fdf', b'UI\\WOS\\Music.fdf',
                          b'UI\\WOS\\Charges.fdf', b'', b''], data.split(b'\r\n'))
        self.assertNotIn(b'escmenutemplates', data)
        fdf = (ROOT/'assets/UI/WOS/Music.fdf').read_text()
        for skin in ('EscMenuSliderBackground', 'EscMenuSliderBorder',
                     'EscMenuSliderThumbButton', 'EscMenuSliderDisabledThumbButton'):
            self.assertIn('"'+skin+'"', fdf)
        self.assertNotIn('UI\\WOS\\bar-back.tga', fdf)

    def test_own_and_ally_rows_use_the_same_size_and_fg_anchors(self):
        source = (ROOT/'triggers/WOS_Start/ShowCD.j').read_text(encoding='utf-8-sig')
        self.assertIn('AHUI_ICON_SIZE = WUI_ICON_SIZE', source)
        self.assertIn('return WUI_AbilityY(slot)', source)
        vm = ui.load_source('WOSUI.j')
        self.assertGreaterEqual(vm.g['WUI_ICON_SIZE'], .036)
        self.assertEqual(.023, vm.run('WUI_AbilityY', (0,)))
        self.assertEqual(.044, vm.run('WUI_AbilityY', (5,)))
        self.assertLess(.044+.036/2, .069-.007/2)

    def test_camera_exact_requested_shift_and_height_reduction(self):
        source = (ROOT/'triggers/WOS_Start/WoS_Hero_Icons_Init.j').read_text(encoding='utf-8-sig')
        self.assertIn('WUI_Place(FRAME_CamSlider, 0.1335, 0.067, 0.014, 0.126)', source)
        self.assertAlmostEqual(.0175, .151-.1335)
        self.assertAlmostEqual(.140*.90, .126)


class NativeCooldowns(unittest.TestCase):
    def test_late_created_model_scales_but_lone_charge_label_is_untouched(self):
        vm = ui.load_source('WOSUI.j')
        children, scales = [], []
        vm.g.update(BlzFrameGetChildrenCount=lambda _: len(children),
                    BlzFrameGetChild=lambda _, i: children[i],
                    BlzFrameGetWidth=lambda f: .039 if f == 'cooldown' else .012,
                    BlzFrameSetScale=lambda f,s: scales.append((f,s)))
        vm.run('WUI_ResizeCooldown', ('command', .036))
        self.assertFalse(scales)
        children.append('charge')
        vm.run('WUI_ResizeCooldown', ('command', .036))
        self.assertFalse(scales)
        children[0] = 'cooldown'
        vm.run('WUI_ResizeCooldown', ('command', .036))
        self.assertEqual([('cooldown', .036/.039)], scales)
        vm.run('WUI_ResizeCooldown', ('item', .024))
        self.assertEqual(('cooldown', .024/.039), scales[-1])

    def test_existing_tracks_do_not_show_a_false_loading_failure(self):
        vm = ui.load_source('MusicPlayer.j')
        text = {}
        vm.g.update(GetPlayerId=lambda p: p, GetLocalPlayer=lambda: 0,
                    lmpCurrent={0:0}, lmpTrackCount=3, lmpNowPlaying='header',
                    lmpTimeText='time', lmpLoop={0:False}, lmpShuffle={0:False},
                    lmpPlaying={0:False}, lmpLoopIcon='loop', lmpShuffleIcon='shuffle',
                    lmpPlayPauseIcon='play', lmpEqualizer='eq',
                    LMP_TEX_LOOP_OFF='loop-off', LMP_TEX_SHUFFLE_OFF='shuffle-off',
                    LMP_TEX_PLAY='play-art', BlzFrameSetTexture=lambda *a: None,
                    BlzFrameSetText=lambda f,v: text.update({f:v}))
        vm.run('LMP_UpdateHeader', (0,))
        self.assertIn('Choose a track', text['header'])
        vm.g['lmpTrackCount'] = 0
        vm.run('LMP_UpdateHeader', (0,))
        self.assertIn('No local tracks found', text['header'])


if __name__ == '__main__':
    unittest.main()
