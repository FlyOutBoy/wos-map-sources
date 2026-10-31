"""Selected-unit silence presentation and independently restored invisibility."""
from pathlib import Path
import unittest

import png_tga
import test_wos_ui as ui
from install_wos_ui_assets import ASSET_NAMES

ROOT = Path(__file__).resolve().parents[1]


class SilenceHUD(unittest.TestCase):
    def fixture(self):
        vm = ui.load_source('WOSUI.j')
        visible = {'portrait': True}
        alpha = {}
        vm.g.update(WUI_Portrait='portrait', WUI_InvisLabel='invis', WUI_InvisBacking='invis backing',
                    WUI_SilenceLabel='silence',
                    WUI_PinNativePortrait=lambda: None,
                    BlzFrameIsVisible=lambda f: visible.get(f, False),
                    BlzFrameSetVisible=lambda f, v: visible.update({f: v}),
                    BlzFrameSetAlpha=lambda f, a: alpha.update({f: a}))
        return vm, visible, alpha

    def test_silence_is_native_buff_presence_and_ends_on_removal_or_selection_change(self):
        vm, visible, _ = self.fixture()
        u, other = vm.unit(), vm.unit()
        self.assertFalse(vm.run('WUI_UnitSilenced', (None,)))
        self.assertFalse(vm.run('WUI_UnitSilenced', (u,)))
        vm.add_ability(u, 'BNsi')
        vm.run('WUI_SetPortraitSilenced', (vm.run('WUI_UnitSilenced', (u,)),))
        self.assertTrue(visible['silence'])
        vm.run('WUI_SetPortraitSilenced', (vm.run('WUI_UnitSilenced', (other,)),))
        self.assertFalse(visible['silence'])
        vm.remove_ability(u, 'BNsi')
        self.assertFalse(vm.run('WUI_UnitSilenced', (u,)))
        # Toji's curse shares a marker with Doom; it is not the SilenceUnit buff.
        vm.add_ability(u, 'B02Z')
        self.assertFalse(vm.run('WUI_UnitSilenced', (u,)))

    def test_silence_and_invis_coexist_and_hiding_portrait_hides_both(self):
        vm, visible, alpha = self.fixture()
        vm.run('WUI_SetPortraitInvisible', (True,))
        vm.run('WUI_SetPortraitSilenced', (True,))
        self.assertTrue(visible['invis'])
        self.assertTrue(visible['silence'])
        self.assertEqual(85, alpha['portrait'])
        vm.run('WUI_SetPortraitSilenced', (False,))
        self.assertTrue(visible['invis'])
        self.assertEqual(85, alpha['portrait'])
        vm.run('WUI_SetPortraitSilenced', (True,))
        vm.run('WUI_ShowNativePortrait', (False,))
        for name in ('invis', 'invis backing', 'silence'):
            self.assertFalse(visible[name])
        vm.run('WUI_ShowNativePortrait', (True,))
        self.assertTrue(visible['invis'])
        self.assertTrue(visible['silence'])
        vm.run('WUI_SetPortraitInvisible', (False,))
        self.assertTrue(visible['silence'])
        self.assertEqual(255, alpha['portrait'])

    def test_silence_texture_is_packaged_with_transparent_background(self):
        self.assertIn('silence-label', ASSET_NAMES)
        width, height, rows = png_tga.read_tga(ROOT/'assets/UI/WOS/silence-label.tga')
        self.assertEqual((512, 128), (width, height))
        alphas = [a for row in rows for a in row[3::4]]
        self.assertEqual(0, min(alphas))
        self.assertEqual(255, max(alphas))


if __name__ == '__main__':
    unittest.main()
