"""Shared backup-style definitions and selected-hero layout regressions."""
from pathlib import Path
import unittest
import test_wos_ui as ui

ROOT = Path(__file__).resolve().parents[1]


class SharedDefinitions(unittest.TestCase):
    def test_single_manifest_orders_dependencies_without_duplicate_engine_templates(self):
        data = (ROOT/'assets/UI/WOS/Templates.toc').read_bytes()
        # Checkpoint 20 appends its controls LAST, after all dependencies.
        self.assertEqual([b'UI\\WOS\\WOSHUD.fdf', b'UI\\WOS\\Music.fdf',
                          b'UI\\WOS\\Charges.fdf', b'UI\\WOS\\WOSControls.fdf', b'', b''], data.split(b'\r\n'))
        self.assertNotIn(b'escmenutemplates', data)
        fdf = (ROOT/'assets/UI/WOS/Music.fdf').read_text()
        # Checkpoint 23: music sliders use the camera-slider art.
        for skin in ('UI\\WOS\\slider-clean-h.tga', 'UI\\WOS\\slider-thumb.tga'):
            self.assertIn('"'+skin+'"', fdf)
        self.assertNotIn('UI\\WOS\\bar-back.tga', fdf)

    def test_own_and_ally_rows_use_the_same_size_and_fg_anchors(self):
        source = (ROOT/'triggers/WOS_Start/ShowCD.j').read_text(encoding='utf-8-sig')
        self.assertIn('AHUI_ICON_SIZE = WUI_ICON_SIZE', source)
        self.assertIn('return WUI_AbilityY(slot)', source)
        vm = ui.load_source('WOSUI.j')
        # Checkpoint 20: one row for all seven, clear of MP (bottom .0642) and
        # of the level pips (WUI_PIP_Y) underneath.
        self.assertGreaterEqual(vm.g['WUI_ICON_SIZE'], .034)
        for slot in range(7):
            self.assertEqual(.042, vm.run('WUI_AbilityY', (slot,)))
        self.assertLess(.042+vm.g['WUI_ICON_SIZE']/2, .0642)
        self.assertLess(vm.g['WUI_PIP_Y']+.0055, .042-vm.g['WUI_ICON_SIZE']/2)

    def test_camera_exact_requested_shift_and_height_reduction(self):
        source = (ROOT/'triggers/WOS_Start/WoS_Hero_Icons_Init.j').read_text(encoding='utf-8-sig')
        # Checkpoint 20 supersedes: styled slider inside the minimap block strip.
        self.assertIn('WUI_PlaceShiftLeft(FRAME_CamSlider, 0.150, 0.0745, 0.012, 0.087)', source)
        self.assertIn('BlzCreateFrame("WOSVerticalSlider", FRAME_StatusHeroMain4, 0, 0)', source)
        self.assertIn('"QuestMainListScrollBar"', source)


class NativeCooldowns(unittest.TestCase):
    def test_native_item_wrapper_scales_without_reading_lazy_children(self):
        vm = ui.load_source('WOSUI.j')
        scales = []
        def forbid(*_):
            self.fail('Native cooldown children must not acquire local handles')
        vm.g.update(BlzFrameGetChildrenCount=forbid, BlzFrameGetChild=forbid,
                    BlzFrameSetScale=lambda f,s: scales.append((f,s)),
                    BlzFrameSetSize=lambda *_: None, BlzFrameSetAbsPoint=lambda *_: None,
                    FRAMEPOINT_CENTER='center')
        vm.run('WUI_PlaceNativeItem', ('item', .60, .04, .024))
        self.assertEqual([('item', .024/vm.g['WUI_NATIVE_ITEM_ICON'])], scales)

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
