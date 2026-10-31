"""Tooltip startup visibility, native placement and valid FDF contracts."""
from pathlib import Path
import shutil
import tempfile
import unittest
import re

from test_wos_ui import load_source, ROOT
from test_crocodile import JassState
from install_wos_ui_assets import FRAME_RESOURCES, validate_frame_resources


class TooltipVisibility(unittest.TestCase):
    def setUp(self):
        self.vm = load_source('WOSUI.j')
        self.frames = {}
        self.attached = {}
        self.label_visible_when_written = []
        self.art_visible_on_creation = []
        g = self.vm.g

        def create(kind, name, parent, *args):
            frame = len(self.frames) + 1
            self.frames[frame] = dict(kind=kind, parent=parent, visible=True)
            if kind == 'BACKDROP':
                self.art_visible_on_creation.append(self.visible(frame))
            return frame

        def text(frame, label):
            self.label_visible_when_written.append(self.visible(frame))
            self.frames[frame]['text'] = label

        g.update(WUI_FrameDefinitionsReady=False, WUI_Root=0, WUI_TEXT='',
                 WUI_PANEL_TEXTURE='panel', WUI_EMPTY_TEXTURE='empty',
                 BlzCreateFrameByType=create, BlzFrameSetText=text,
                 BlzFrameSetVisible=lambda f, v: self.frames[f].update(visible=v),
                 BlzFrameSetTooltip=lambda owner, tip: self.attached.update({owner: tip}),
                 BlzFrameSetSize=lambda *_: None, BlzFrameSetAllPoints=lambda *_: None,
                 BlzFrameSetEnable=lambda *_: None, BlzFrameSetLevel=lambda *_: None,
                 BlzFrameSetPoint=lambda *_: None, BlzFrameSetScale=lambda *_: None,
                 BlzFrameSetTextAlignment=lambda *_: None, BlzFrameSetTexture=lambda *_: None,
                 FRAMEPOINT_BOTTOMRIGHT=1, FRAMEPOINT_TOPRIGHT=2, FRAMEPOINT_TOPLEFT=3,
                 FRAMEPOINT_BOTTOMLEFT=4, FRAMEPOINT_CENTER=5,
                 TEXT_JUSTIFY_MIDDLE=1, TEXT_JUSTIFY_CENTER=2, WUI_Restart=-1)
        self.create = create

    def visible(self, frame):
        return frame == 0 or (self.frames[frame]['visible'] and self.visible(self.frames[frame]['parent']))

    def test_toolbar_labels_are_hidden_before_text_is_assigned(self):
        # Covers all constructors used by the overlapping labels in the video.
        for helper, args in (
            ('WUI_TooltipSized', (0, 'Add this item', .17, .038, .006, .004, .01)),
            ('WUI_TooltipBelowSized', (0, 'Remove this step', .17, .038, .006, .004, .01)),
            ('WUI_TooltipBelowEx', (0, 'HOTKEY', True)),
        ):
            with self.subTest(helper=helper):
                self.vm.run(helper, args)
                tip = self.attached[0]
                self.assertEqual('FRAME', self.frames[tip]['kind'])
                self.assertFalse(self.visible(tip))
                texts = [f for f, data in self.frames.items() if data.get('parent') == tip and data['kind'] == 'TEXT']
                self.assertEqual(1, len(texts))
                # The engine toggles only the empty root: all content follows it.
                self.frames[tip]['visible'] = True
                self.assertTrue(self.visible(texts[0]))
                self.frames[tip]['visible'] = False
                self.assertFalse(self.visible(texts[0]))
        self.assertEqual([False, False, False], self.label_visible_when_written)

    def test_visible_inset_panel_contract_is_preserved(self):
        tip = self.vm.run('WUI_TooltipBox', (0, .225, .104))
        self.assertFalse(self.visible(tip))
        self.assertTrue(self.art_visible_on_creation)
        self.assertFalse(any(self.art_visible_on_creation))
        # Stats explicitly show the inset; ordinary tooltip callers leave it hidden.
        self.frames[tip]['visible'] = True
        self.assertTrue(self.visible(tip))
        child = next(f for f, d in self.frames.items() if d['parent'] == tip)
        self.assertEqual('BACKDROP', self.frames[child]['kind'])

    def test_game_tab_tooltip_cannot_escape_a_hidden_statistics_window(self):
        source = (ROOT/'triggers/WOS_Start/DamageStats.j').read_text(encoding='utf-8-sig')
        function = re.search(r'function DS_CreateGameTip takes.*?endfunction', source, re.S)[0]
        parsed = JassState(function)
        self.vm.text += '\n' + parsed.text
        self.vm.methods.update(parsed.methods)
        self.vm.g.update(BlzFrameSetFont=lambda *_: None, TEXT_JUSTIFY_MIDDLE=1,
                         TEXT_JUSTIFY_CENTER=2, FRAMEPOINT_TOPLEFT=3,
                         FRAMEPOINT_BOTTOMLEFT=4, WUI_GetRoot=lambda: 0)
        window = self.create('FRAME', 'Stats', 0)
        owner = self.create('BUTTON', 'GameTab', window)
        self.frames[window]['visible'] = False
        text = self.vm.run('DS_CreateGameTip', (owner,))
        tip = self.attached[owner]
        # Even if engine hover state enables the tooltip, its window still gates it.
        self.frames[tip]['visible'] = True
        self.assertFalse(self.visible(text))
        self.frames[window]['visible'] = True
        self.assertTrue(self.visible(text))

    def test_mode_three_is_applied_once_and_manual_switch_is_observed(self):
        g = self.vm.g
        state = [2]
        textures = []
        g.update(WUI_AllyColorState=-1, WUI_AllyColorGlyph='glyph',
                 GetAllyColorFilterState=lambda: state[0],
                 BlzFrameSetTexture=lambda *args: textures.append(args[1]))
        self.vm.run('WUI_WatchAllyColor')
        self.assertTrue(textures[-1].endswith('glyph-allycolor-2.tga'))
        state[0] = 0
        self.vm.run('WUI_WatchAllyColor')
        self.assertTrue(textures[-1].endswith('glyph-allycolor.tga'))
        source = (ROOT/'triggers/WOS_Start/WOSUI.j').read_text(encoding='utf-8-sig')
        self.assertEqual(1, source.count('call SetAllyColorFilterState(2)'))
        boot = source.split('function WUI_Bootstrap ', 1)[1].split('endfunction', 1)[0]
        self.assertIn('call SetAllyColorFilterState(2)', boot)


class NativeTemplates(unittest.TestCase):
    def test_resources_validate_and_reject_the_actual_engine_parse_error(self):
        validate_frame_resources(ROOT/'assets')
        with tempfile.TemporaryDirectory() as temp:
            assets = Path(temp)
            for name in FRAME_RESOURCES:
                out = assets/name
                out.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(ROOT/'assets'/name, out)
            fdf = assets/'UI/WOS/WOSControls.fdf'
            fdf.write_text(fdf.read_text() + '\nFrame "SIMPLEBUTTON" "Broken" { ControlStyle "AUTOTRACK", }\n')
            with self.assertRaisesRegex(ValueError, 'ControlStyle is invalid for SIMPLEBUTTON'):
                validate_frame_resources(assets)

    def test_native_skin_and_font_templates_are_in_the_shared_loaded_fdf(self):
        fdf = (ROOT/'assets/UI/WOS/WOSControls.fdf').read_text()
        for key in ('BackdropBackground "ToolTipBackground"', 'BackdropEdgeFile "ToolTipBorder"',
                    'FrameFont "MasterFont", 0.011', 'WOSNativeTooltipTitleTemplate'):
            self.assertIn(key, fdf)
        source = (ROOT/'triggers/WOS_Start/ShowCD.j').read_text(encoding='utf-8-sig')
        self.assertIn('FRAMEPOINT_BOTTOMRIGHT, WUI_CHASSIS_RIGHT + WUI_HudShift - 0.030, WUI_CHASSIS_TOP + 0.070)', source)
        self.assertNotIn('WUI_Window("WOSAbilityTooltip"', source)


if __name__ == '__main__':
    unittest.main()
