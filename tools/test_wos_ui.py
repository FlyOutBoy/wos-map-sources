"""Run production HUD layout and fog-of-war guards with recorded native calls."""
from collections import defaultdict
from pathlib import Path
import re
import tempfile
import struct
import unittest
from test_crocodile import JassState
from install_wos_ui_assets import install_ui, ASSET_NAMES, FRAME_RESOURCES

ROOT = Path(__file__).resolve().parents[1]


def load_source(filename):
    source = (ROOT / 'triggers/WOS_Start' / filename).read_text(encoding='utf-8-sig')
    # Comments include retired implementations, which are not compiled by Warcraft.
    source = re.sub(r'/\*.*?\*/', '', source, flags=re.S)
    vm = JassState(source)
    # Import literal production constants/default flags for dependent helpers.
    for name, value in re.findall(r'(?m)^\s*(?:private )?(?:constant )?(?:real|boolean) (\w+) = ([0-9.]+|true|false)\s*$', source):
        vm.g[name] = value == 'true' if value in ('true', 'false') else float(value)
    for name, value in re.findall(r'(?m)^\s*(?:private )?constant integer (\w+) = ([0-9]+)\s*$', source):
        vm.g[name] = int(value)
    # Checkpoint 24: plain framehandle globals start as null.
    for name in re.findall(r'(?m)^\s*(?:private )?framehandle (\w+) = null\s*$', source):
        vm.g.setdefault(name, None)
    vm.g.setdefault('BlzGetAbilityPosX', lambda *_: -1)
    vm.g.setdefault('BlzGetAbilityPosY', lambda *_: -1)
    vm.g.setdefault('BlzFrameClearAllPoints', lambda *_: None)
    # External native-portrait owner; tests that exercise it install real helpers.
    vm.g.setdefault('WUI_ShowNativePortrait', lambda *_: None)
    vm.g.setdefault('WUI_BindNativePortrait', lambda *_: 'native-portrait')
    vm.g.setdefault('BlzGetMouseScreenPosX', lambda: 2.0)
    vm.g.setdefault('BlzGetMouseScreenPosY', lambda: 2.0)
    vm.g.setdefault('BlzPixelToFrameX', lambda value: value)
    vm.g.setdefault('BlzPixelToFrameY', lambda value: value)
    # Checkpoint 27: string natives used by the TEST COMMANDS line scroller.
    vm.g.setdefault('StringLength', len)
    vm.g.setdefault('BlzFrameGetValue', lambda *_: 0.0)
    vm.g.setdefault('WUI_TestSliderMax', -1)
    vm.g.setdefault('WUI_TestSliderValue', -1)
    vm.g.setdefault('SubString', lambda text, a, b: text[a:b])
    vm.g.setdefault('WUI_ShiftTable', {})
    for name, value in (('WUI_ShiftCount', 0), ('WUI_ShiftHookCount', 0), ('WUI_HudMode', 2), ('WUI_HudShift', 0.0), ('WUI_HudLeft', 0.0), ('WUI_RectCount', 0)):
        vm.g.setdefault(name, value)
    for kind, name in re.findall(r'(?m)^\s*(?:private )?(\w+) array (\w+)', source):
        default = False if kind == 'boolean' else 0 if kind in ('integer', 'real') else None
        vm.g[name] = defaultdict(lambda v=default: v)
        if kind == 'framehandle':
            vm.g[name].update({i: (name, i) for i in range(24)})
    return vm


class NativeCommandLayout(unittest.TestCase):
    def setUp(self):
        self.vm = load_source('WOSUI.j')
        self.positions = {}
        self.vm.g.update({
            'WUI_OrdersOpen': False, 'WUI_CompactCommands': False,
            # Production constants come from load_source (checkpoint 20 values).
            'FRAMEPOINT_CENTER': 'center', 'I2R': float,
            'ModuloInteger': lambda a, b: a % b,
            'BlzFrameClearAllPoints': lambda *_: None,
            'BlzFrameSetSize': lambda *_: None,
            'BlzFrameSetScale': lambda *_: None,
            'BlzFrameSetVisible': lambda *_: None,
            'BlzFrameSetAbsPoint': lambda f, _, x, y: self.positions.update({f: (x, y)}),
        })

    def test_seven_existing_native_slots_and_reachable_orders(self):
        self.vm.run('WUI_LayoutCommands', (True,))
        g = self.vm.g
        # Checkpoint 20: QWERT F G share ONE row (user request), level pips below.
        for index, native in enumerate((8, 9, 10, 11, 7, 5, 6)):
            x, y = self.positions[g['WUI_Command'][native]]
            self.assertAlmostEqual(.359 + index * .040, x)
            self.assertEqual(.042, y)
        for index in range(5):
            self.assertEqual((-.20, -.20), self.positions[g['WUI_Command'][index]])
        g['WUI_OrdersOpen'] = True
        self.vm.run('WUI_LayoutCommands', (True,))
        for index in range(5):
            self.assertEqual(.137, self.positions[g['WUI_Command'][index]][1])

    def test_switch_to_ordinary_unit_preserves_all_twelve_commands(self):
        self.vm.run('WUI_LayoutCommands', (True,))
        self.vm.run('WUI_LayoutCommands', (False,))
        for frame in self.vm.g['WUI_Command'].values():
            if frame in self.positions:
                x, y = self.positions[frame]
                self.assertGreater(x, 0)
                self.assertGreaterEqual(y, .015)
                self.assertLess(y + .015, .0642, "Alternate cards must remain below MP")


class DeferredUIStartup(unittest.TestCase):
    """Exercise the real bootstrap; mocks reject unsafe loading-time natives."""
    def setUp(self):
        self.vm = load_source('WOSUI.j')
        self.calls = []
        self.timers = []
        self.destroyed = []
        self.children = 5
        source = (ROOT / 'triggers/WOS_Start/WOSUI.j').read_text(encoding='utf-8-sig')
        for name in set(re.findall(r'\b(Blz\w+|Leaderboard\w+)\s*\(', source)):
            self.vm.g[name] = lambda *args, n=name: self.native(n, *args)
        for constant in set(re.findall(r'\b(?:ORIGIN_FRAME_|FRAMEPOINT_|FRAMEEVENT_|TEXT_JUSTIFY_)\w+', source)):
            self.vm.g[constant] = constant
        self.vm.g.update({
            'CreateTimer': lambda: object(), 'InitHashtable': dict,
            'CreateTrigger': list, 'TriggerAddAction': lambda t, c: t.append(c),
            'TriggerExecute': lambda t: [c() for c in list(t)],
            'DestroyTrigger': lambda t: self.destroyed.append(t),
            'TimerStart': lambda *args: self.timers.append(args),
            'DestroyTimer': lambda *_: None,
            'CreateLeaderboardBJ': lambda *_: self.native('CreateLeaderboardBJ'),
            'bj_FORCE_ALL_PLAYERS': 'all-players', 'I2R': float, 'I2S': str,
            'BlzGetLocalClientWidth': lambda: 1920,
            'BlzGetLocalClientHeight': lambda: 1080,
            'RMaxBJ': max,
            'BlzGetFrameByName': lambda name, _: 'named:' + name,
            'BlzGetOriginFrame': lambda origin, _: 'origin:' + origin,
            'BlzCreateFrameByType': self.create_frame,
            'BlzCreateFrame': lambda name, parent, *_: self.create_frame('FRAME', name, parent),
            'BlzCreateSimpleFrame': lambda name, parent, *_: self.create_frame('SIMPLEFRAME', name, parent),
            'BlzLoadTOCFile': lambda *_: True,
            'SaveFrameHandle': lambda table, key, child, frame: table.update({(key, child): frame}),
            'LoadFrameHandle': lambda table, key, child: table.get((key, child)),
            'BlzFrameGetChildrenCount': lambda _: self.children, 'BlzFrameGetWidth': lambda *_: 0.0,
            'BlzFrameGetChild': self.child,
            'BlzFrameSetVisible': self.visibility,
            # Checkpoint 22: rebindable slot hotkeys and stock escape menu.
            'ConvertOsKeyType': lambda code: ('oskey', code), 'SubString': lambda s, a, b: s[a:b],
            'OSKEY_ESCAPE': ('oskey', 27), 'OSKEY_BACKSPACE': ('oskey', 8),
            # Solo-only Restart button: these fixtures model a non-solo game.
            'Player': lambda i: ('player', i), 'GetPlayerSlotState': lambda p: 'empty',
            'GetPlayerController': lambda p: 'user', 'PLAYER_SLOT_STATE_PLAYING': 'playing',
            'MAP_CONTROL_USER': 'user', 'bj_MAX_PLAYERS': 12,
        })
        # Evaluate declarations from the production globals, including constants.
        for name, value in re.findall(r'^    (?:private )?(?:constant )?\w+ (\w+) = ([^\n]+)', source.split('endglobals', 1)[0], re.M):
            value = re.sub(r'\b(true|false|null)\b', lambda m: {'true': 'True', 'false': 'False', 'null': 'None'}[m[0]], value)
            self.vm.g[name] = eval(value, {}, self.vm.g)

    def native(self, name, *args):
        self.calls.append((name, args))
        return name

    def create_frame(self, kind, name, parent, *_):
        self.assertIsNotNone(parent, 'Every owner must have a ready parent')
        self.native('create', kind, name, parent)
        return kind + ':' + name

    def child(self, frame, index):
        self.assertLess(index, self.children, 'Warcraft does not bounds-check children')
        self.native('child', frame, index)
        return 'child:' + str(index)

    def visibility(self, frame, visible):
        self.assertIsNotNone(frame)
        self.assertNotIn('BUFF_BAR_LABEL', frame)
        self.assertNotIn('LeaderboardTitle', frame)
        self.assertNotIn(frame, ['named:ResourceBar' + name + 'Text'
                                for name in ('Gold', 'Lumber', 'Supply', 'Upkeep')])
        self.native('visible', frame, visible)

    def test_initializers_only_register_or_schedule_until_game_time(self):
        self.vm.run('WUI_Init')
        self.assertFalse(self.calls)
        self.assertEqual(1, len(self.timers))
        self.assertEqual((.10, False), self.timers[0][1:3])
        owners = [('DefaultArmorChangeStable_Copy.j', 'HeroUnitPanelStats_Init'),
                  ('ShowCD.j', 'InitAllyHeroAbilityUI'), ('ChatCommand.j', 'Init'),
                  ('TeamMapPings.j', 'TMP_Init'), ('Scoreboard.j', 'WOS_STATS_Init'),
                  ('UI_CAREER.j', 'WCS_Init')]
        callbacks = []
        for file, initializer in owners:
            vm = load_source(file)
            vm.g['WUI_OnReady'] = callbacks.append
            vm.run(initializer)
        self.assertEqual(len(owners), len(callbacks))
        self.assertTrue(all(callable(callback) for callback in callbacks))

    def test_bootstrap_creates_root_before_owners_once(self):
        observed = []
        callback = lambda: observed.append((self.vm.g['WUI_Root'], self.vm.g['WUI_Ready']))
        self.vm.run('WUI_OnReady', (callback,))
        self.vm.run('WUI_OnReady', (callback,))
        self.assertFalse(observed)
        self.assertFalse(self.calls)
        self.vm.run('WUI_Init')
        self.timers[0][3]()
        self.assertEqual([('BACKDROP:WOSIndependentRoot', True)] * 2, observed)
        self.assertEqual(0, self.vm.g['WUI_ReadyCount'])
        # Two test owners + HUD chrome (the hotkey editor is switched off,
        # WUI_ENABLE_HOTKEYS = false, checkpoint 23).
        self.assertEqual(3, len(self.destroyed))
        # Late owners execute once without replaying the initial queue.
        self.vm.run('WUI_OnReady', (callback,))
        self.assertEqual(3, len(observed))
        self.assertEqual(4, len(self.destroyed))

    def test_native_strings_and_short_console_tree_are_safe(self):
        self.vm.run('WUI_Bootstrap')
        self.assertIsNone(self.vm.g['WUI_DeadZone'])
        # Resource mouse listeners are cached synchronously after the delayed
        # bootstrap; only their documented four slots and guarded escape-menu
        # button children may be read, never an arbitrary console subtree.
        self.assertFalse(any(name == 'child' and not (
                             args[0].startswith('named:') and args[0].endswith('Button')
                             or args[0] == 'named:ResourceBarFrame' and 0 <= args[1] < 4)
                             for name, args in self.calls))
        text_calls = [args for name, args in self.calls if name == 'BlzFrameSetText']
        self.assertIn(('origin:ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR_LABEL', ''), text_calls)
        self.assertIn(('named:LeaderboardTitle', ''), text_calls)

    def test_style_button_does_not_read_missing_children(self):
        self.children = 3
        self.vm.run('WUI_StyleButton', ('button',))
        self.assertFalse(self.calls)
        self.vm.run('WUI_StyleButton', (None,))
        self.assertFalse(self.calls)


class ResourceBarTooltips(unittest.TestCase):
    """Execute the real resource-bar path without unsafe native text operations."""
    def setUp(self):
        self.fixture = DeferredUIStartup()
        self.fixture.setUp()
        self.vm = self.fixture.vm
        self.resource = 'named:ResourceBarFrame'
        self.listeners = ['gold-hover', 'lumber-hover', 'upkeep-hover', 'food-hover']
        self.children = self.listeners + ['fps-line', 'unknown-child']
        self.visible = {frame: True for frame in self.children}
        self.reads = []
        original_count = self.vm.g['BlzFrameGetChildrenCount']
        original_child = self.vm.g['BlzFrameGetChild']

        def count(frame):
            self.assertIsNotNone(frame)
            return len(self.children) if frame == self.resource else original_count(frame)

        def child(frame, index):
            if frame != self.resource:
                return original_child(frame, index)
            self.assertGreaterEqual(index, 0)
            self.assertLess(index, len(self.children))
            self.reads.append(index)
            return self.children[index]

        def visible(frame, shown):
            self.fixture.visibility(frame, shown)
            self.visible[frame] = shown

        self.vm.g.update({'BlzFrameGetChildrenCount': count,
                          'BlzFrameGetChild': child, 'BlzFrameSetVisible': visible})
        self.vm.g['WUI_Resource'] = self.resource

    def test_only_hover_listeners_are_hidden_and_fps_anchor_survives(self):
        self.vm.run('WUI_CacheResourceMouse')
        self.assertEqual([0, 1, 2, 3], self.reads)
        self.vm.run('WUI_ParkResourceBar')
        self.assertTrue(self.visible[self.resource])
        self.assertTrue(all(not self.visible[frame] for frame in self.listeners))
        self.assertTrue(self.visible['fps-line'])
        self.assertTrue(self.visible['unknown-child'])
        self.assertEqual([0, 1, 2, 3], self.reads, 'Presentation must use already-cached handles')
        points = [args for name, args in self.fixture.calls if name == 'BlzFrameSetAbsPoint']
        self.assertEqual([(self.resource, 'FRAMEPOINT_TOPRIGHT',
                           self.vm.g['WUI_FPS_X'] + .44, self.vm.g['WUI_FPS_Y'] + .03)], points)
        self.assertFalse(any(name in ('BlzFrameSetAlpha', 'BlzFrameSetParent', 'BlzFrameSetEnable')
                             for name, _ in self.fixture.calls))

    def test_short_tree_and_missing_child_handles_are_safe(self):
        for children in ([], ['gold-hover'], ['gold-hover', None, 'upkeep-hover']):
            with self.subTest(children=children):
                self.children = children
                self.reads.clear()
                self.fixture.calls.clear()
                self.vm.run('WUI_CacheResourceMouse')
                self.vm.run('WUI_ParkResourceBar')
                self.assertEqual(list(range(len(children))), self.reads)
                hidden = [args[0] for name, args in self.fixture.calls
                          if name == 'visible' and not args[1]]
                self.assertEqual([frame for frame in children if frame is not None], hidden)

    def test_absent_resource_bar_has_no_native_reads_or_writes(self):
        self.vm.g['WUI_Resource'] = None
        self.vm.run('WUI_CacheResourceMouse')
        self.vm.run('WUI_ParkResourceBar')
        self.assertFalse(self.reads)
        self.assertFalse(self.fixture.calls)

    def test_return_from_pick_rehides_listeners_without_new_handle_lookups(self):
        self.vm.run('WUI_Init')
        self.assertFalse(self.fixture.calls, 'No frame native belongs in a library initializer')
        self.vm.run('WUI_Bootstrap')
        self.assertEqual([0, 1, 2, 3], self.reads)
        self.vm.g.update({'WUI_NativeReady': True, 'WUI_CommandBar': 'commands',
                          'WUI_NativeDetailParent': 'inventory', 'ModuloInteger': lambda a, b: a % b})
        for _ in range(2):
            # Model the engine showing origin frames at the end of pick/draft.
            self.visible.update({frame: True for frame in self.children})
            self.vm.run('WUI_RestoreCompactNative')
            self.assertTrue(all(not self.visible[frame] for frame in self.listeners))
            self.assertTrue(self.visible[self.resource])
            self.assertTrue(self.visible['fps-line'])
        self.assertEqual([0, 1, 2, 3], self.reads)


class HiddenEnemyData(unittest.TestCase):
    def setUp(self):
        self.frames = {}
        self.visible = False
        self.detected = True
        self.ally = False

    def fail_read(self, *_):
        self.fail('Hidden enemy type, death or vitals were read')

    def configure(self, vm):
        vm.g.update({
            'GetLocalPlayer': lambda: 0, 'GetOwningPlayer': lambda u: u.owner,
            'IsPlayerAlly': lambda *_: self.ally,
            'IsUnitVisible': lambda *_: self.visible,
            'IsUnitDetected': lambda *_: self.detected, 'IsUnitInvisible': lambda *_: not self.detected,
            'BlzFrameSetVisible': lambda f, v: self.frames.update({(f, 'visible'): v}),
            'BlzFrameSetAlpha': lambda f, v: self.frames.update({(f, 'alpha'): v}),
            'GetUnitTypeId': self.fail_read, 'IsUnitType': self.fail_read,
            'GetWidgetLife': self.fail_read, 'BlzGetUnitMaxHP': self.fail_read,
            'GetUnitState': self.fail_read, 'BlzGetUnitMaxMana': self.fail_read,
        })

    def test_top_panel_does_not_query_hidden_enemy_changes(self):
        vm = load_source('WoS_Hero_Icons_Init.j')
        self.configure(vm)
        vm.g.update(Hero={5: vm.unit(owner=5)}, CaptainMode=False, CapPickPhase=2, Leave={5: 0})
        vm.run('UpdateStatusHeroSlotOptimized', (5,))
        self.assertFalse(self.frames[vm.g['StatusHpBar'][5], 'visible'])
        self.assertFalse(self.frames[vm.g['StatusMpBar'][5], 'visible'])

    def test_visible_but_undetected_enemy_is_also_private(self):
        # Checkpoint 25: a visible enemy is inspectable (portrait, stats and
        # the team-strip hero); only units the player cannot see stay private.
        self.skipTest('visibility alone decides since checkpoint 25')

    def test_selected_hidden_enemy_does_not_query_stats(self):
        vm = load_source('DefaultArmorChangeStable_Copy.j')
        self.configure(vm)
        selected = vm.unit(owner=5)
        vm.g.update({
            'UNITSTAT_SelectedGroup': [], 'UNITSTAT_Root': 'selected-hud',
            'UNITSTAT_Gold': 'gold', 'UNITSTAT_Hover': -1,
            'UNITSTAT_Tooltip': 'tooltip', 'GroupClear': lambda *_: None,
            'GroupEnumUnitsSelected': lambda *_: None, 'FirstOfGroup': lambda *_: selected,
            'WUI_SetText': lambda f, v: self.frames.update({(f, 'text'): v}),
            'WUI_ShowNativeBuffs': lambda v: self.frames.update({('buffs', 'visible'): v}),
            'WUI_ShowHeroIndicator': lambda v: self.frames.update({('skill-glow', 'visible'): v}),
            'I2S': str, 'PLAYER_STATE_RESOURCE_GOLD': 'gold',
            'PLAYER_STATE_RESOURCE_LUMBER': 'lumber',
            'GetPlayerState': lambda p, s: 120 if s == 'gold' else 45,
        })
        vm.run('UNITSTAT_Update')
        self.assertFalse(self.frames['selected-hud', 'visible'])
        self.assertFalse(self.frames['skill-glow', 'visible'])
        self.assertIn('120', self.frames['gold', 'text'])
        self.assertIn('Next round: 45', vm.g['UNITSTAT_Help'][7])


class SharedShopControls(unittest.TestCase):
    def setUp(self):
        self.vm = JassState((ROOT / 'triggers/Systems/ButtonPressed.j').read_text(encoding='utf-8-sig'))
        self.guard = 0
        self.reloads = []
        self.visibility = []
        self.observer = False
        self.vm.g.update({
            'Hero': {0: self.vm.unit(owner=0)}, 'Shop_Active': defaultdict(bool),
            'ItemsCraftPlayerDebug_ID': defaultdict(int), 'ItemsFrameCurrentPage_ID': {0: 5},
            'ShopUICreated': True, 'FRAME_ShopMAIN': 'shop', 'END1': 0,
            'FRAME_AutoBuyCheckbox': 'auto', 'FRAME_AutoBuyText': 'auto-label',
            'FRAME_ShopItemInventorySlot': {6: 'buy', 7: 'sell'}, 'hs': {},
            'GetPlayerId': lambda p: p, 'GetHandleId': lambda p: p,
            'GetLocalPlayer': lambda: 0, 'StringHash': lambda s: s,
            'IsObserverSlot': lambda p: self.observer,
            'LoadInteger': lambda *_: self.guard,
            'SaveInteger': lambda *_: setattr(self, 'guard', 1), 'MyFlush': lambda *_: None,
            'ReloadItemPage': lambda page, p: self.reloads.append((page, p)),
            'ShopUpdateCatalogueNavigation': lambda *_: None,
            'DisplayTimedTextToPlayer': lambda *_: None,
            'BlzFrameSetVisible': lambda f, v: self.visibility.append((f, v)),
            'BlzFrameSetEnable': lambda *_: None,
        })

    def test_shop_reopens_same_page_and_debounces(self):
        self.vm.run('WOS_ToggleShop', (0,))
        self.assertTrue(self.vm.g['Shop_Active'][0])
        self.assertEqual([(5, 0)], self.reloads)
        self.vm.run('WOS_ToggleShop', (0,))
        self.assertTrue(self.vm.g['Shop_Active'][0])
        self.guard = 0
        self.vm.run('WOS_ToggleShop', (0,))
        self.assertFalse(self.vm.g['Shop_Active'][0])
        self.guard = 0
        self.vm.run('WOS_ToggleShop', (0,))
        self.assertEqual([(5, 0), (5, 0)], self.reloads)

    def test_observer_can_browse_without_autobuy_or_hero(self):
        self.observer = True
        self.vm.g['Hero'][0] = None
        self.vm.run('WOS_ToggleShop', (0,))
        self.assertTrue(self.vm.g['Shop_Active'][0])
        self.assertIn(('auto', False), self.visibility)

    def test_no_shop_before_hero_selection(self):
        self.vm.g['Hero'][0] = None
        self.vm.run('WOS_ToggleShop', (0,))
        self.assertFalse(self.reloads)
        self.assertFalse(self.vm.g['Shop_Active'][0])


class SharedImports(unittest.TestCase):
    def test_imports_preserve_existing_entries_and_are_idempotent(self):
        with tempfile.TemporaryDirectory() as directory:
            scenario = Path(directory)
            imp = scenario / 'war3map.imp'
            old_entry = b'\x0dExisting\\HeroTexture.blp\0'
            imp.write_bytes(struct.pack('<II', 1, 1) + old_entry)
            install_ui(scenario)
            first = imp.read_bytes()
            self.assertEqual(2 + len(ASSET_NAMES) + len(FRAME_RESOURCES), struct.unpack_from('<II', first)[1])
            self.assertEqual(old_entry, first[8:8 + len(old_entry)])
            install_ui(scenario)
            self.assertEqual(first, imp.read_bytes())
            for name in ASSET_NAMES:
                self.assertEqual((ROOT / 'assets/UI/WOS' / (name + '.tga')).read_bytes(),
                                 (scenario / 'UI/WOS' / (name + '.tga')).read_bytes())


class DynamicHeroAndBuffDocks(unittest.TestCase):
    def setUp(self):
        self.vm = load_source('WOSUI.j')
        self.positions = {}
        self.visible = defaultdict(bool)
        self.moves = []
        self.vm.g.update({
            'WUI_DockCount': 0, 'WUI_DockPlacing': False, 'WUI_DockTick': 0, 'HaveSavedHandle': lambda *_: False, 'ModuloInteger': lambda a, b: a % b, 'WUI_MeterEdges': {}, 'WUI_DockKeys': {}, 'WUI_OrdersOpen': False,
            'WUI_RefreshHelpVisibility': lambda: None,
            # Checkpoint 21: shop cover / hero layer / menu skins.
            'WUI_CoverWatch': None, 'WUI_DocksCovered': False, 'WUI_HeroLayer': None,
            'WUI_HeroLayerLocked': False, 'WUI_RefreshMenuSkins': lambda: None,
            'GetPlayerId': lambda p: p, 'GetLocalPlayer': lambda: 0,
            'StringHash': lambda s: s, 'I2R': float,
            'ModuloInteger': lambda a, b: a % b,
            'BlzFrameIsVisible': lambda f: self.visible[f],
            'BlzFrameSetVisible': lambda f, v: self.visible.update({f: v}),
            'BlzFrameClearAllPoints': lambda *_: None,
            'BlzFrameSetSize': lambda *_: None,
            'BlzFrameSetScale': lambda *_: None,
            'BlzFrameSetAbsPoint': self.place,
            'FRAMEPOINT_CENTER': 'center',
        })

    def place(self, frame, point, x, y):
        self.positions[frame] = (x, y)
        self.moves.append(frame)

    def register(self, frame, owner=0, kind=0, label=None):
        self.visible[frame] = True
        self.vm.run('WUI_RegisterDock', (frame, label, owner, kind, frame))

    def test_hidden_meter_reclaims_space_with_smooth_movement(self):
        self.register('first')
        self.register('second')
        self.vm.run('WUI_RefreshDocks')
        self.assertAlmostEqual(.162, self.positions['first'][1])
        self.assertAlmostEqual(.192, self.positions['second'][1])
        self.visible['first'] = False
        self.vm.run('WUI_RefreshDocks')
        self.assertGreater(self.positions['second'][1], .162)
        self.assertLess(self.positions['second'][1], .192)
        for _ in range(8):
            self.vm.run('WUI_RefreshDocks')
        self.assertAlmostEqual(.162, self.positions['second'][1], delta=.0002)
        self.moves.clear()
        self.vm.run('WUI_RefreshDocks')
        self.assertFalse(self.moves, 'Settled docks should not rewrite native points')

    def test_unit_buff_labels_follow_their_icons_and_avoid_orders(self):
        self.register('buff-a', kind=1, label='time-a')
        self.register('buff-b', kind=1, label='time-b')
        self.vm.run('WUI_RefreshDocks')
        # Checkpoint 25b: one row under the stock buff bar, left to right.
        # Buffs were shrunk to .024 with a .0275 step.
        self.assertAlmostEqual(.179, self.positions['buff-a'][0])
        self.assertAlmostEqual(.207, self.positions['buff-b'][0])
        self.assertAlmostEqual(self.positions['buff-b'][1]-.0045, self.positions['time-b'][1])
        self.assertAlmostEqual(self.positions['buff-a'][1]-.0045, self.positions['time-a'][1])

    def test_other_players_private_meters_do_not_take_local_slots(self):
        self.register('opponent', owner=5)
        self.register('own')
        self.register('public', owner=-1, kind=2)
        self.vm.run('WUI_RefreshDocks')
        self.assertNotIn('opponent', self.positions)
        self.assertAlmostEqual(.162, self.positions['own'][1])
        # Checkpoint 24: a lone public meter hangs centred under Train kills.
        self.assertEqual((.400, .5145), self.positions['public'])

    def test_same_key_rebinds_recreated_frame_without_registry_growth(self):
        self.register('old')
        self.vm.run('WUI_RefreshDocks')
        self.visible['new'] = True
        self.vm.run('WUI_RegisterDock', ('new', None, 0, 0, 'old'))
        self.assertEqual(1, self.vm.g['WUI_DockCount'])
        self.assertFalse(self.visible['old'])
        self.moves.clear()
        self.vm.run('WUI_RefreshDocks')
        self.assertEqual(['new'], self.moves)


if __name__ == '__main__':
    unittest.main()
