"""Pixel alpha, top-panel geometry and relocated engine skill-point indicator.

These verify resources and emitted anchors, not Warcraft rendering/hit testing.
"""
from pathlib import Path
from tempfile import TemporaryDirectory
from unittest.mock import patch
import struct
import unittest
import install_wos_ui_assets as installer
import test_wos_ui as ui

ROOT = Path(__file__).resolve().parents[1]


class RealTransparency(unittest.TestCase):
    def test_container_uses_real_transparent_pixels_not_vertex_tint(self):
        installer.validate_passive_texture(ROOT / 'assets')
        fixture = ui.DeferredUIStartup()
        fixture.setUp()
        owner = fixture.vm.run('WUI_Passive', ('edge', 'parent'))
        self.assertIn(('BlzFrameSetTexture', (owner, 'UI\\WOS\\empty.tga', 0, True)), fixture.calls)
        self.assertFalse(any(n in ('BlzFrameSetAlpha', 'BlzFrameSetVertexColor') for n, _ in fixture.calls))

    def test_one_opaque_pixel_is_rejected_before_import_mutation(self):
        with TemporaryDirectory() as directory:
            base = Path(directory)
            folder = base / 'assets/UI/WOS'
            folder.mkdir(parents=True)
            for name in ('WOSHUD.toc', 'WOSHUD.fdf', 'Music.toc', 'Music.fdf', 'empty.tga'):
                (folder / name).write_bytes((ROOT / 'assets/UI/WOS' / name).read_bytes())
            data = bytearray((folder / 'empty.tga').read_bytes())
            data[18 + data[0] + 3] = 255
            (folder / 'empty.tga').write_bytes(data)
            with patch.object(installer, 'ROOT', base), patch.object(installer, 'install') as install:
                with self.assertRaisesRegex(ValueError, 'zero alpha'):
                    installer.install_ui(base / 'scenario')
                install.assert_not_called()
            self.assertFalse((base / 'scenario').exists())

    def test_graphite_fill_is_opaque_dark_and_packaged(self):
        data = (ROOT / 'assets/UI/WOS/panel.tga').read_bytes()
        width, height = struct.unpack_from('<HH', data, 12)
        self.assertEqual((512, 512, 32), (width, height, data[16]))
        pixels = data[18 + data[0]:18 + data[0] + width * height * 4]
        self.assertEqual({255}, set(pixels[3::4]))
        self.assertLess(max(pixels[0::4] + pixels[1::4] + pixels[2::4]), 64)
        self.assertIn('empty', installer.ASSET_NAMES)


class OrnamentAndControls(unittest.TestCase):
    def setUp(self):
        self.fixture = ui.DeferredUIStartup()
        self.fixture.setUp()
        self.vm = self.fixture.vm

    def test_all_square_corners_and_rails_grow_fifteen_percent(self):
        self.vm.run('WUI_OrnateBorder', ('edge', 'owner', .020))
        sizes = {a[0]: a[1:] for n, a in self.fixture.calls if n == 'BlzFrameSetSize'}
        for suffix in ('tl', 'tr', 'bl', 'br'):
            for size in sizes['BACKDROP:edge' + suffix]:
                self.assertAlmostEqual(.020 * 1.15, size)
        self.assertAlmostEqual(.020 * 1.15 * .16, sizes['BACKDROP:edgeTop'][1])

    def test_top_strip_contains_four_distinct_icons_and_readable_menu(self):
        self.vm.run('WUI_Bootstrap')
        pos = {a[0]: a[2:] for n, a in self.fixture.calls if n == 'BlzFrameSetAbsPoint'}
        sizes = {a[0]: a[1:] for n, a in self.fixture.calls if n == 'BlzFrameSetSize'}
        x, y = pos['BACKDROP:WOSTopActionsPanel']
        w, h = sizes['BACKDROP:WOSTopActionsPanel']
        for xx in (self.vm.run('WUI_TopActionX', (i,)) for i in range(4)):
            self.assertLessEqual(x-w/2, xx-.0125)
            self.assertGreaterEqual(x+w/2, xx+.0125)
            self.assertGreaterEqual(y+h/2, .580+.0125)
            self.assertLessEqual(y-h/2, .558-.005)
        self.assertAlmostEqual(.6, y+h/2)
        self.assertAlmostEqual(self.vm.run('WUI_ScreenRight'), x+w/2)
        self.assertIn(('BlzFrameSetText', ('TEXT:WOSMenuGlyph', '|cffd5b876Menu|r')), self.fixture.calls)

    def test_stock_glow_follows_portrait_and_cannot_leak_at_old_location(self):
        self.vm.g['BlzGetOriginFrame'] = lambda _, i: 'indicator' + str(i)
        self.vm.run('WUI_BindHeroIndicator', ('portrait',))
        self.assertIn(('BlzFrameSetParent', ('indicator0', 'portrait')), self.fixture.calls)
        self.assertIn(('BlzFrameSetPoint', ('indicator0', 'FRAMEPOINT_BOTTOMLEFT', 'portrait', 'FRAMEPOINT_BOTTOMLEFT', 0, 0)), self.fixture.calls)
        for i in range(1, 7):
            self.assertIn(('BlzFrameSetAbsPoint', ('indicator' + str(i), 'FRAMEPOINT_CENTER', -.2, -.2)), self.fixture.calls)
        for shown in (True, False):
            self.fixture.calls.clear()
            self.vm.run('WUI_ShowHeroIndicator', (shown,))
            self.assertEqual([('visible', ('indicator' + str(i), shown and i == 0)) for i in range(7)], self.fixture.calls)


if __name__ == '__main__':
    unittest.main()
