"""Actual parser failure, hidden partial windows and anchored HUD regressions.

Native calls are recorded; Warcraft rendering and mouse hit testing are separate.
"""
from pathlib import Path
from tempfile import TemporaryDirectory
import re
import unittest
import install_wos_ui_assets as assets
import test_wos_ui as ui
from test_wos_ui_runtime_fixes import ShopAndPickLayout

ROOT = Path(__file__).resolve().parents[1]


class DefinitionStartup(unittest.TestCase):
    def test_actual_invalid_vertical_enum_is_rejected_before_import(self):
        with TemporaryDirectory() as directory:
            base = Path(directory)
            for name in assets.FRAME_RESOURCES:
                destination = base / name
                destination.parent.mkdir(parents=True, exist_ok=True)
                destination.write_bytes((ROOT / 'assets' / name).read_bytes())
            music = base / 'UI/WOS/Music.fdf'
            music.write_text(music.read_text().replace('FontJustificationV JUSTIFYMIDDLE',
                                                      'FontJustificationV JUSTIFYCENTER'))
            with self.assertRaisesRegex(ValueError, 'FontJustificationV.*JUSTIFYCENTER'):
                assets.validate_frame_resources(base)

    def test_all_definition_loads_precede_frame_owners_in_one_timer(self):
        fixture = ui.DeferredUIStartup()
        fixture.setUp()
        order = []
        fixture.vm.g['BlzLoadTOCFile'] = lambda path: order.append(path) or True
        original = fixture.vm.g['BlzCreateFrameByType']
        fixture.vm.g['BlzCreateFrameByType'] = lambda *args: (order.append('frame'), original(*args))[1]
        fixture.vm.run('WUI_OnReady', (lambda: order.append('owner'),))
        self.assertFalse(order)
        fixture.vm.run('WUI_Bootstrap')
        self.assertEqual(['UI\\WOS\\Templates.toc'], order[:1])
        self.assertGreater(order.index('owner'), order.index('frame'))
        sources = list((ROOT / 'triggers').rglob('*.j'))
        loaders = [p.name for p in sources if 'BlzLoadTOCFile(' in p.read_text(encoding='utf-8-sig')]
        self.assertEqual(['WOSUI.j'], loaders)

    def test_tas_creation_and_update_timer_wait_for_the_same_ready_stage(self):
        source = (ROOT / 'triggers/Systems/TasBox.j').read_text(encoding='utf-8-sig')
        vm = ui.JassState(source)
        queued, events = [], []
        vm.g.update(Initialized=False, UpdateTimer=None, CreateTimer=lambda: 'timer', CreateTrigger=list,
                    WUI_OnReady=queued.append, TriggerAddAction=lambda *a: None,
                    TriggerRegisterAnyUnitEventBJ=lambda *a: None,
                    EVENT_PLAYER_UNIT_SELECTED='selected',
                    UpdateIntervale=.05, Create=lambda: events.append('frames'),
                    TimerStart=lambda *a: events.append('timer'))
        vm.run('Init')
        vm.run('Init')
        self.assertFalse(events)
        self.assertEqual(1, len(queued))
        queued[0]()
        self.assertEqual(['frames', 'timer'], events)


class MusicFailure(unittest.TestCase):
    def test_any_missing_required_control_leaves_no_window_or_input_blocker(self):
        for missing in ('edit', 'seek', 'volume'):
            vm = ui.load_source('MusicPlayer.j')
            for name in ('lmpLinkEdit', 'lmpSeek', 'lmpVolumeSlider'):
                vm.g[name] = None
            created, destroyed, messages = [], [], []
            def create(name, parent, priority, context):
                key = 'edit' if name == 'LMPLinkEditTemplate' else 'seek' if context == 0 else 'volume'
                created.append(key)
                return None if key == missing else key
            vm.g.update(WUI_GetRoot=lambda: 'root', BlzCreateFrame=create, WUI_HasFrameDefinitions=lambda: False, bj_MAX_PLAYER_SLOTS=28, WUI_TopActionX=lambda i: .638 + i * .036, WUI_TOGGLE_HOTKEY_Y=.0185, BlzFrameSetVisible=lambda *_: None, WUI_TooltipBox=lambda *_: 'tooltip',
                        BlzDestroyFrame=destroyed.append, BJDebugMsg=messages.append,
                        WUI_Window=lambda *a: self.fail('partial window allocated'),
                        LMP_CreateIconButton=lambda *a: self.fail('partial button allocated'))
            vm.run('LMP_CreateFrames')
            self.assertEqual(['edit', 'seek', 'volume'], created)
            self.assertEqual(set(created)-{missing}, set(destroyed))
            self.assertEqual((None, None, None), tuple(vm.g[n] for n in
                             ('lmpLinkEdit', 'lmpSeek', 'lmpVolumeSlider')))
            self.assertEqual(1, len(messages))


class AnchoredLayout(unittest.TestCase):
    def setUp(self):
        self.fixture = ui.DeferredUIStartup()
        self.fixture.setUp()
        self.fixture.vm.run('WUI_Bootstrap')
        self.fixture.calls.clear()

    def test_score_labels_stay_in_own_boxes_despite_different_font_scales(self):
        vm = ui.load_source('WoS_Hero_Icons_Init.j')
        vm.g.update(self.fixture.vm.g)
        for name in ('FRAME_RoundCount', 'FRAME_RoundTimer', 'FRAME_GameTimer', 'FRAME_Team1Rounds', 'FRAME_Team2Rounds',
                     'StatusRoundClockBox', 'StatusGameTimeBox', 'StatusTeam1Box', 'StatusTeam2Box'):
            vm.g[name] = None
        created = []
        def create(kind, name, parent, template, context):
            handle = f'{kind}:{name}#{len(created)}'
            created.append(handle)
            return handle
        vm.g['BlzCreateFrameByType'] = create
        for name in ('WUI_Passive', 'WUI_Place', 'WUI_Panel', 'WUI_OrnateBorder', 'WUI_RegisterTopControl'):
            vm.g[name] = lambda *a, n=name: self.fixture.vm.run(n, a)
        vm.g.update(FRAME_StatusHeroMain='score-root', CurrentRound=1, TimeRound=60,
                    Team1Round=8, Team2Round=6, GetCompactGameTimerText=lambda: '01:23')
        vm.run('WOS_CreateRoundCounters')
        calls = self.fixture.calls
        anchors = {a[0]: a[2:] for n,a in calls if n == 'BlzFrameSetPoint'}
        for name, box in [('FRAME_Team1Rounds', 'StatusTeam1Box'), ('FRAME_Team2Rounds', 'StatusTeam2Box'),
                          ('FRAME_RoundTimer', 'StatusRoundClockBox'), ('FRAME_GameTimer', 'StatusGameTimeBox')]:
            owner, point, dx, dy = anchors[vm.g[name]]
            self.assertEqual(vm.g[box], owner)
            self.assertEqual((0, 0), (dx, dy))
        registered = list(self.fixture.vm.g['WUI_TopControl'].values())
        self.assertIn(vm.g['StatusGameTimeBox'], registered)
        for box in ('StatusTeam1Box', 'StatusTeam2Box', 'StatusRoundClockBox'):
            self.assertNotIn(vm.g[box], registered)

    def test_hide_ui_keeps_round_counters_and_does_not_reopen_help_on_refresh(self):
        vm = self.fixture.vm
        visible, closed = {}, []
        vm.g['BlzFrameSetVisible'] = lambda f,v: visible.update({f:v})
        vm.run('WUI_RegisterTopControl', ('team-border',))
        vm.g['WCS_IsOpen'][0]=True
        vm.run('WUI_ShowTestHelp', (True,))
        vm.run('WUI_CloseTopFor', (0,))
        vm.run('WUI_ShowTopControls', (False,))
        vm.run('WUI_RefreshHelpVisibility')
        self.assertFalse(visible[vm.g['WUI_TestPanel']])
        self.assertFalse(visible[vm.g['WUI_TestToggle']])
        self.assertFalse(visible['team-border'])
        self.assertFalse(vm.g['WCS_IsOpen'][0])
        vm.run('WUI_ShowTopControls', (True,))
        self.assertTrue(visible['team-border'])

    def test_small_minimap_camera_and_chassis_have_no_large_gap(self):
        vm = self.fixture.vm
        vm.g.update(ModuloInteger=lambda a, b: a % b)
        vm.run('WUI_CreateHUDChrome')
        calls = self.fixture.calls
        points = [a for n,a in calls if n == 'BlzFrameSetAbsPoint']
        mini = 'BACKDROP:WOSMinimapSurface'; hud = 'BACKDROP:WOSHUDSurface'
        # Checkpoint 20: the chassis starts exactly at the minimap block edge.
        self.assertIn((mini, 'FRAMEPOINT_TOPRIGHT', .160, .144), points)
        self.assertIn((hud, 'FRAMEPOINT_BOTTOMLEFT', .160, 0), points)
        source = (ROOT/'triggers/WOS_Start/WoS_Hero_Icons_Init.j').read_text(encoding='utf-8-sig')
        self.assertIn('WUI_PlaceShiftLeft(FRAME_CamSlider, 0.150, 0.0860, 0.012, 0.066)', source)
        # The slider lies in the block's own strip, right of the .136 minimap.
        self.assertGreater(.150-.012/2, .004+vm.g['WUI_MINIMAP_SIZE'])
        self.assertLess(.150+.012/2, .160)

    def test_tabs_grid_and_recipe_header_do_not_overlap(self):
        vm,pos,size = ShopAndPickLayout().layout('WoS_Shop_Init.j','WOS_LayoutShop')
        first = pos[vm.g['FRAME_ShopItem'][0]]
        # Checkpoint 23: the tree title sits right of the (narrower) catalogue.
        last = pos[vm.g['FRAME_ShopItem'][6]]
        self.assertLess(last[0]+.019, pos['FRAME_ShopRecipeTitle'][0]-size['FRAME_ShopRecipeTitle'][0]/2)
        self.assertLess(first[1]+.02, pos[vm.g['FRAME_ShopSection'][0]][1]-.027/2)
        for i in range(35):
            x,y = pos[vm.g['FRAME_ShopItem'][i]]
            bottom = pos['FRAME_ShopItemList'][1]-size['FRAME_ShopItemList'][1]/2
            self.assertGreater(y-.032, bottom)


if __name__ == '__main__':
    unittest.main()
