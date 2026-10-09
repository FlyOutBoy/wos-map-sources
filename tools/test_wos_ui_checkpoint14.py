"""Input-layer and actual native-button subtree regressions from game screenshots."""
from pathlib import Path
import re
import unittest
import test_wos_ui as ui
import test_wos_ui_runtime_fixes as layouts

ROOT = Path(__file__).resolve().parents[1]


class InputAndNativeGeometry(unittest.TestCase):
    def setUp(self):
        self.fixture = ui.DeferredUIStartup()
        self.fixture.setUp()
        self.vm = self.fixture.vm
        self.vm.run('WUI_Bootstrap')

    def test_root_and_ornaments_cannot_own_world_or_mode_mouse_input(self):
        fdf = (ROOT / 'assets/UI/WOS/WOSHUD.fdf').read_text()
        self.assertRegex(fdf, r'Frame "FRAME" "WOSPassiveFrame"\s*\{\s*LayerStyle "IGNORETRACKEVENTS",')
        sizes = [a for n, a in self.fixture.calls if n == 'BlzFrameSetSize'
                 and a[0] == self.vm.g['WUI_Root']]
        self.assertEqual((.0001, .0001), sizes[-1][1:])
        self.assertIn(('BlzFrameSetEnable', (self.vm.g['WUI_Root'], True)), self.fixture.calls)
        self.fixture.calls.clear()
        self.vm.run('WUI_OrnateBorder', ('button-edge', 'button', .020))
        self.assertIn(('create', ('BACKDROP', 'button-edge', 'button')), self.fixture.calls)
        source = (ROOT / 'triggers/WOS_Start/WOSUI.j').read_text(encoding='utf-8-sig')
        self.assertIn('BlzCreateFrameByType("BACKDROP", name, parent, "", 0)', source)
        self.assertIn('local framehandle edge = WUI_Passive(name, owner)', source)

    def test_inventory_art_and_hitboxes_scale_with_wrappers_into_six_cells(self):
        self.vm.g.update(BlzFrameGetParent=lambda _: 'detail-parent',
                         PauseTimer=lambda *_: None, ModuloInteger=lambda a, b: a % b,
                         jass_div=lambda a, b: a // b)
        self.vm.methods['WUI_InstallNativeLayout'] = self.vm.methods['WUI_InstallNativeLayout'].replace('i / 3', 'jass_div(i, 3)')
        self.fixture.calls.clear()
        self.vm.run('WUI_StartNativeLayout')
        calls = self.fixture.calls
        positions = {a[0]: a[2:] for n, a in calls if n == 'BlzFrameSetAbsPoint'}
        scales = {a[0]: a[1] for n, a in calls if n == 'BlzFrameSetScale'}
        sizes = {a[0]: a[1:] for n, a in calls if n == 'BlzFrameSetSize'}
        bounds = []
        for i in range(6):
            frame = 'named:InventoryButton_' + str(i)
            self.assertAlmostEqual(.024/.039, scales[frame])
            self.assertEqual((.039, .039), sizes[frame])
            x, y = positions[frame]
            width = sizes[frame][0] * scales[frame]
            bounds.append((x - width/2, y - width/2, x + width/2, y + width/2))
            self.assertGreaterEqual(bounds[-1][0], .534)
            self.assertLessEqual(bounds[-1][2], .638)
            self.assertGreaterEqual(bounds[-1][1], .002)
            self.assertLessEqual(bounds[-1][3], .098)
        for i, a in enumerate(bounds):
            for b in bounds[i + 1:]:
                self.assertTrue(a[2] <= b[0] or b[2] <= a[0] or a[3] <= b[1] or b[3] <= a[1])

    def test_chassis_texture_is_explicit_and_empty_slots_are_under_native_commands(self):
        self.assertIn(('BlzFrameSetTexture', ('named:WOSNativeHUDTexture', 'UI\\WOS\\panel.tga', 0, True)), self.fixture.calls)
        self.assertIn(('visible', ('SIMPLEFRAME:WOSNativeHUDSurface', True)), self.fixture.calls)
        created = [a for n, a in self.fixture.calls if n == 'create']
        self.assertEqual(7, sum(a[1] == 'WOSNativeEmptyAbility' for a in created))
        self.vm.g.update(ModuloInteger=lambda a, b: a % b)
        self.fixture.calls.clear()
        self.vm.run('WUI_LayoutCommands', (True,))
        self.assertEqual(7, sum(n == 'visible' and a == ('SIMPLEFRAME:WOSNativeEmptyAbility', True)
                                for n, a in self.fixture.calls))
        self.fixture.calls.clear()
        self.vm.run('WUI_LayoutCommands', (False,))
        self.assertEqual(7, sum(n == 'visible' and a == ('SIMPLEFRAME:WOSNativeEmptyAbility', False)
                                for n, a in self.fixture.calls))


class RestoredPickAndHUD(unittest.TestCase):
    def test_pick_matches_backup_two_rows_and_centered_difficulty(self):
        vm, pos, sizes = layouts.ShopAndPickLayout().layout('WoS_Pick_Init.j', 'WOS_LayoutHeroPick')
        qwert = [pos[vm.g['FRAME_ICON5'][i]] for i in range(5)]
        fg = [pos[vm.g['FRAME_ICON5'][i]] for i in (5, 6)]
        self.assertEqual(1, len({y for x, y in qwert}))
        self.assertTrue(all(y > qwert[0][1] for x, y in fg))
        self.assertEqual(.420, pos['FRAME_PlayerPickDifficultText'][0])
        self.assertEqual(.159, sizes['FRAME_HeroName'][0])
        for i in range(7):
            x, y = pos[vm.g['FRAME_ICON5'][i]]
            self.assertLess(y + .013, pos['FRAME_HeroAS'][1] - .0075)

    def test_stat_card_attributes_are_vertical_and_gold_has_actual_icon(self):
        source = (ROOT / 'triggers/WOS_Start/DefaultArmorChangeStable_Copy.j').read_text(encoding='utf-8-sig')
        vm = ui.load_source('DefaultArmorChangeStable_Copy.j')
        positions = {}
        for name in re.findall(r'^    private \w+ (\w+) = ', source, re.M):
            vm.g.setdefault(name, None)
        vm.g.update(WUI_GetRoot=lambda: 'root', WUI_GOLD='gold', WUI_TEXT='text',
                    CreateTrigger=list, CreateTimer=lambda: 'timer', CreateGroup=lambda: 'group',
                    UNITSTAT_CreateToolbar=lambda: None, UNITSTAT_WidgetCreate=lambda i, t, x, y, w, _: positions.update({i: (x, y, w)}),
                    WUI_Passive=lambda *_: 'stat-root', WUI_Panel=lambda name, *args: name,
                    WUI_OrnateWindow=lambda *_: 'edge', WUI_Border=lambda *_: 'edge', WUI_Pin=lambda *_: None,
                    UNITSTAT_Text=lambda *_: 'text', WUI_CreateFill=lambda *_: 'fill', I2R=float,
                    TasAbilityChargeBox_CreatePortraitLabel=lambda *_: 'level-text',
                    TimerStart=lambda *_: None, TriggerAddAction=lambda *_: None,
                    WUI_Place=lambda f, x, y, w, h: positions.update({f: (x, y, w, h)}),
                    BlzCreateFrameByType=lambda _, name, *args: name)
        for name in set(re.findall(r'\b(Blz\w+)\s*\(', source)):
            if name not in vm.g:
                vm.g[name] = lambda *_: None
        for constant in set(re.findall(r'\b(?:FRAMEPOINT_|FRAMEEVENT_|TEXT_JUSTIFY_)\w+', source)):
            vm.g[constant] = constant
        vm.run('UNITSTAT_CreateUI')
        self.assertEqual(1, len({positions[i][0] for i in (3, 4, 5)}))
        self.assertGreater(positions[3][1], positions[4][1])
        self.assertGreater(positions[4][1], positions[5][1])
        self.assertEqual(positions['WOSSelectedUnitBack'][2:], (.104, .088))
        self.assertIn('WOSGoldIcon', positions)
        self.assertIn('UI\\\\Feedback\\\\Resources\\\\ResourceGold.blp', source)


if __name__ == '__main__':
    unittest.main()
