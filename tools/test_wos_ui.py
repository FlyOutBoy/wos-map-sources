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
            'WUI_COMMAND_X': .354, 'WUI_COMMAND_STEP': .040,
            'WUI_HUD_Y': .044, 'WUI_ICON_SIZE': .036,
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
        for index, native in enumerate((8, 9, 10, 11, 7, 5, 6)):
            x, y = self.positions[g['WUI_Command'][native]]
            self.assertAlmostEqual(.354 + index * .040, x)
            self.assertEqual(.044, y)
        for index in range(5):
            self.assertEqual((-.20, -.20), self.positions[g['WUI_Command'][index]])
        g['WUI_OrdersOpen'] = True
        self.vm.run('WUI_LayoutCommands', (True,))
        for index in range(5):
            self.assertEqual(.139, self.positions[g['WUI_Command'][index]][1])

    def test_switch_to_ordinary_unit_preserves_all_twelve_commands(self):
        self.vm.run('WUI_LayoutCommands', (True,))
        self.vm.run('WUI_LayoutCommands', (False,))
        for frame in self.vm.g['WUI_Command'].values():
            if frame in self.positions:
                x, y = self.positions[frame]
                self.assertGreater(x, 0)
                self.assertGreaterEqual(y, .015)
                self.assertLess(y + .014, .0755, "Alternate cards must remain below MP")


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
            'BlzGetFrameByName': lambda name, _: 'named:' + name,
            'BlzGetOriginFrame': lambda origin, _: 'origin:' + origin,
            'BlzCreateFrameByType': self.create_frame,
            'BlzCreateFrame': lambda name, parent, *_: self.create_frame('FRAME', name, parent),
            'BlzCreateSimpleFrame': lambda name, parent, *_: self.create_frame('SIMPLEFRAME', name, parent),
            'BlzLoadTOCFile': lambda *_: True,
            'SaveFrameHandle': lambda table, key, child, frame: table.update({(key, child): frame}),
            'LoadFrameHandle': lambda table, key, child: table.get((key, child)),
            'BlzFrameGetChildrenCount': lambda _: self.children,
            'BlzFrameGetChild': self.child,
            'BlzFrameSetVisible': self.visibility,
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
        self.assertEqual(3, len(self.destroyed))
        # Late owners execute once without replaying the initial queue.
        self.vm.run('WUI_OnReady', (callback,))
        self.assertEqual(3, len(observed))
        self.assertEqual(4, len(self.destroyed))

    def test_native_strings_and_short_console_tree_are_safe(self):
        self.vm.run('WUI_Bootstrap')
        self.assertIsNone(self.vm.g['WUI_DeadZone'])
        self.assertFalse(any(name == 'child' for name, _ in self.calls))
        text_calls = [args for name, args in self.calls if name == 'BlzFrameSetText']
        self.assertIn(('origin:ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR_LABEL', ''), text_calls)
        self.assertIn(('named:LeaderboardTitle', ''), text_calls)

    def test_style_button_does_not_read_missing_children(self):
        self.children = 3
        self.vm.run('WUI_StyleButton', ('button',))
        self.assertFalse(self.calls)
        self.vm.run('WUI_StyleButton', (None,))
        self.assertFalse(self.calls)


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
            'IsUnitDetected': lambda *_: self.detected,
            'BlzFrameSetVisible': lambda f, v: self.frames.update({(f, 'visible'): v}),
            'BlzFrameSetAlpha': lambda f, v: self.frames.update({(f, 'alpha'): v}),
            'GetUnitTypeId': self.fail_read, 'IsUnitType': self.fail_read,
            'GetWidgetLife': self.fail_read, 'BlzGetUnitMaxHP': self.fail_read,
            'GetUnitState': self.fail_read, 'BlzGetUnitMaxMana': self.fail_read,
        })

    def test_top_panel_does_not_query_hidden_enemy_changes(self):
        vm = load_source('WoS_Hero_Icons_Init.j')
        self.configure(vm)
        vm.g.update(Hero={5: vm.unit(owner=5)}, CaptainMode=False, CapPickPhase=2)
        vm.run('UpdateStatusHeroSlotOptimized', (5,))
        self.assertFalse(self.frames[vm.g['StatusHpBar'][5], 'visible'])
        self.assertFalse(self.frames[vm.g['StatusMpBar'][5], 'visible'])

    def test_visible_but_undetected_enemy_is_also_private(self):
        self.visible = True
        self.detected = False
        self.test_top_panel_does_not_query_hidden_enemy_changes()

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
            'WUI_DockCount': 0, 'WUI_DockKeys': {}, 'WUI_OrdersOpen': False,
            'WUI_RefreshHelpVisibility': lambda: None,
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
        self.assertAlmostEqual(.178, self.positions['buff-a'][0])
        self.assertAlmostEqual(.204, self.positions['buff-b'][0])
        self.assertAlmostEqual(self.positions['buff-b'][1]-.016, self.positions['time-b'][1])
        self.vm.g['WUI_OrdersOpen'] = True
        self.vm.run('WUI_RefreshDocks')
        self.assertGreater(self.positions['buff-a'][1], .144)
        self.assertAlmostEqual(self.positions['buff-a'][1]-.016, self.positions['time-a'][1])

    def test_other_players_private_meters_do_not_take_local_slots(self):
        self.register('opponent', owner=5)
        self.register('own')
        self.register('public', owner=-1, kind=2)
        self.vm.run('WUI_RefreshDocks')
        self.assertNotIn('opponent', self.positions)
        self.assertAlmostEqual(.162, self.positions['own'][1])
        self.assertEqual((.325, .490), self.positions['public'])

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
