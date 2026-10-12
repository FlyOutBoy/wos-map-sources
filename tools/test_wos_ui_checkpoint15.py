"""Game resource-parser and decoration fallback regressions.

These do not emulate Warcraft's hit testing. They prevent the invalid TOC bytes
that the preceding compile/archive tests accepted, and exercise the no-TOC path.
"""
from pathlib import Path
from tempfile import TemporaryDirectory
import unittest
from unittest.mock import patch
import install_wos_ui_assets as installer
import test_wos_ui as ui

ROOT = Path(__file__).resolve().parents[1]


class FrameResourceParserContract(unittest.TestCase):
    def write_resources(self, root, toc):
        folder = root / 'UI/WOS'
        folder.mkdir(parents=True)
        (folder / 'WOSHUD.fdf').write_bytes(b'Frame "FRAME" "Test" {}\r\n')
        (folder / 'WOSHUD.toc').write_bytes(toc)

    def test_real_source_toc_has_complete_crlf_ending(self):
        installer.validate_frame_resources(ROOT / 'assets')
        self.assertEqual(b'UI\\WOS\\WOSHUD.fdf\r\n\r\n',
                         (ROOT / 'assets/UI/WOS/WOSHUD.toc').read_bytes())

    def test_old_single_lf_and_other_incomplete_formats_are_rejected(self):
        for data in (b'UI\\WOS\\WOSHUD.fdf\n', b'UI\\WOS\\WOSHUD.fdf\r\n',
                     b'UI\\WOS\\WOSHUD.fdf\n\n\r\n\r\n',
                     b'\xef\xbb\xbfUI\\WOS\\WOSHUD.fdf\r\n\r\n'):
            with self.subTest(data=data), TemporaryDirectory() as directory:
                self.write_resources(Path(directory), data)
                with self.assertRaises(ValueError):
                    installer.validate_frame_resources(Path(directory))

    def test_missing_definition_is_rejected_before_map_mutation(self):
        with TemporaryDirectory() as directory:
            base = Path(directory)
            self.write_resources(base / 'assets', b'UI\\WOS\\Missing.fdf\r\n\r\n')
            with patch.object(installer, 'ROOT', base), patch.object(installer, 'install') as install:
                with self.assertRaisesRegex(ValueError, 'not bundled'):
                    installer.install_ui(base / 'scenario')
                install.assert_not_called()
            self.assertFalse((base / 'scenario').exists())


class PassiveFallback(unittest.TestCase):
    def test_toolbar_six_targets_fit_one_grid_without_hover_size_jump(self):
        vm = ui.load_source('WOSUI.j')
        positions = {}
        vm.g.update(I2R=float, WUI_Place=lambda f,x,y,w,h: positions.update({f: (x,y,w,h)}))
        for column in range(3):
            for row in range(2):
                vm.run('WUI_PlaceToolbar', ((column, row), column, row))
        # Checkpoint 20: right block .697-.798, below the gold row/divider (.0655).
        for x,y,w,h in positions.values():
            self.assertGreaterEqual(x-w/2, .699)
            self.assertLessEqual(x+w/2, .829)
            self.assertGreaterEqual(y-h/2, .002)
            self.assertLessEqual(y+h/2, .0655)
            self.assertEqual((.025, .025), (w, h))
        values = list(positions.values())
        for i, (x,y,w,h) in enumerate(values):
            for xx,yy,ww,hh in values[i+1:]:
                self.assertTrue(abs(x-xx) >= (w+ww)/2 or abs(y-yy) >= (h+hh)/2)
        source = (ROOT / 'triggers/WOS_Start/TeamMapPings.j').read_text(encoding='utf-8-sig')
        handler = source.split('private function TMP_OnFrame takes', 1)[1].split('endfunction', 1)[0]
        self.assertNotIn('BlzFrameSetSize(TMP_Toggle', handler)

    def test_no_toc_still_builds_noninteractive_containers_and_interactive_buttons(self):
        fixture = ui.DeferredUIStartup()
        fixture.setUp()
        vm = fixture.vm
        vm.g['BlzLoadTOCFile'] = lambda *_: False
        vm.run('WUI_Bootstrap')
        self.assertFalse(vm.g['WUI_FrameDefinitionsReady'])
        self.assertEqual('BACKDROP:WOSIndependentRoot', vm.g['WUI_Root'])
        for name in ('WOSIndependentRoot', 'WOSHUDSurface', 'WOSMinimapSurface', 'WOSHUDMetal'):
            self.assertTrue(any(n == 'create' and a[:2] == ('BACKDROP', name)
                                for n, a in fixture.calls), name)
        self.assertFalse(any(n == 'BlzFrameSetAlpha' and a[1] == 0 for n, a in fixture.calls))
        self.assertFalse(any(n == 'BlzFrameSetEnable' and a == (vm.g['WUI_Root'], False)
                             for n, a in fixture.calls))
        fixture.calls.clear()
        vm.g.update(GetHandleId=lambda f: f, SaveFrameHandle=lambda h,p,c,v: h.update({(p,c): v}))
        button = vm.run('WUI_TextButton', ('mode-test', vm.g['WUI_Root'], 'Test Mode', .230, .037))
        self.assertEqual('BUTTON:mode-test', button)
        self.assertIn(('create', ('BACKDROP', 'mode-testMetal', button)), fixture.calls)
        self.assertFalse(any(n == 'BlzFrameSetEnable' and a == (button, False)
                             for n, a in fixture.calls))


if __name__ == '__main__':
    unittest.main()
