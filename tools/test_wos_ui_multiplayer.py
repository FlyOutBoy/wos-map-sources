"""Run asymmetric client UI actions and reject fresh handles after bootstrap."""
from collections import defaultdict
import re
import unittest

import test_wos_ui as ui


class MultiplayerFrames(unittest.TestCase):
    def client(self, pid):
        fixture = ui.DeferredUIStartup()
        fixture.setUp()
        vm = fixture.vm
        reservations = []
        for name in ('BlzGetFrameByName', 'BlzGetOriginFrame', 'BlzFrameGetChild'):
            original = vm.g[name]

            def get(*args, name=name, original=original):
                reservations.append((name, args))
                return original(*args)

            vm.g[name] = get
        vm.run('WUI_Bootstrap')
        visible = {args[0]: args[1] for name, args in fixture.calls if name == 'visible'}
        # Engine template instances have distinct handles/context. The base
        # recording fixture collapses template names, so separate column frames
        # before exercising live reflow (otherwise their points overwrite Menu).
        for key in ('WUI_TestToggle', 'WUI_TestPanel', 'WUI_TestText', 'WUI_TestSlider',
                    'WUI_TestPageLabel', 'WUI_TestPrevious', 'WUI_TestNext'):
            old = vm.g.get(key)
            if old is not None:
                vm.g[key] = 'instance:' + key
                visible[vm.g[key]] = visible.get(old, False)

        def visibility(frame, shown):
            fixture.visibility(frame, shown)
            visible[frame] = shown

        vm.g.update(GetLocalPlayer=lambda: pid, GetTriggerPlayer=lambda: 0,
                    GetPlayerId=lambda p: p, Player=lambda p: p,
                    BlzFrameIsVisible=lambda frame: visible.get(frame, False),
                    BlzFrameSetVisible=visibility, BlzFrameGetEnable=lambda _: True,
                    BlzGetMouseScreenPosX=lambda: 0, BlzGetMouseScreenPosY=lambda: 0,
                    BlzPixelToFrameX=lambda x: x, BlzPixelToFrameY=lambda y: y,
                    RAbsBJ=abs, ModuloInteger=lambda a, b: a % b,
                    WUI_CommandBar='commands', WUI_NativeDetailParent='inventory',
                    WUI_NativeReady=True)

        def forbid(*args):
            self.fail(f'Local UI attempted to reserve/create a handle: {args}')

        for name in ('BlzGetFrameByName', 'BlzGetOriginFrame', 'BlzFrameGetChild',
                     'BlzFrameGetParent', 'BlzCreateFrame', 'BlzCreateSimpleFrame',
                     'BlzCreateFrameByType', 'CreateTimer', 'CreateTrigger'):
            vm.g[name] = forbid
        fixture.calls.clear()
        return fixture, reservations, visible

    def test_menu_and_hud_poll_with_different_client_visibility_allocate_nothing(self):
        clients = [self.client(pid) for pid in (0, 1)]
        self.assertEqual(clients[0][1], clients[1][1])
        for fixture, _, _ in clients:
            vm = fixture.vm
            vm.g['BlzGetTriggerFrame'] = lambda vm=vm: vm.g['WUI_Menu']
            vm.run('WUI_ControlClick')
            # Different native selection/cooldown trees must never be enumerated.
            vm.g['BlzFrameGetChildrenCount'] = lambda *_: self.fail('Runtime child traversal')
            vm.run('WUI_RefreshDocks')
        self.assertTrue(clients[0][0].vm.g['WUI_MenuOpen'])
        self.assertFalse(clients[1][0].vm.g['WUI_MenuOpen'])
        fill = clients[0][0].vm.g['WUI_MenuSkinFill'][0]
        textures = [args[0] for name, args in clients[0][0].calls if name == 'BlzFrameSetTexture']
        self.assertIn(fill, textures)

    def test_hide_top_and_restore_after_pick_use_only_cached_handles(self):
        for pid in (0, 1):
            with self.subTest(client=pid):
                fixture, _, visible = self.client(pid)
                vm = fixture.vm
                vm.run('WUI_CollapseAllPanels')
                vm.run('WUI_ShowTopControls', (False,))
                vm.run('WUI_ShowTopControls', (True,))
                vm.run('WUI_RestoreCompactNative', (vm.g['GetLocalPlayer'](),))
                vm.run('WUI_RestoreCompactNative', (vm.g['GetLocalPlayer'](),))
                vm.run('WUI_ShowNativeMenu', (vm.g['GetLocalPlayer'](),))
                self.assertTrue(visible[vm.g['WUI_SystemBar']])
                self.assertTrue(visible[vm.g['WUI_System'][0]])
                self.assertFalse(visible[vm.g['WUI_ResourceMouse'][0]])

    def test_mode_selector_is_created_for_everyone_but_visible_only_to_player_one(self):
        created = []
        for pid in (0, 1):
            fixture = ui.DeferredUIStartup()
            fixture.setUp()
            fixture.vm.run('WUI_Bootstrap')
            vm = ui.load_source('Starts.j')
            for name, value in fixture.vm.g.items():
                if callable(value) and (name.startswith(('Blz', 'Trigger', 'WUI_'))
                                        or name in ('CreateTrigger', 'I2S', 'I2R')):
                    vm.g[name] = value
            vm.g.update(WOS_ModeSecondsLeft=20, WUI_GOLD='gold', WUI_TEXT='text',
                        GetLocalPlayer=lambda pid=pid: pid, Player=lambda p: p,
                        TEXT_JUSTIFY_MIDDLE='middle', TEXT_JUSTIFY_CENTER='center',
                        FRAMEEVENT_CONTROL_CLICK='click')
            fixture.calls.clear()
            vm.run('WOS_CreateModeSelector')
            created.append([args for name, args in fixture.calls if name == 'create'])
            hidden = [('visible', (vm.g['WOS_ModeRoot'], False))]
            if pid == 0:
                self.assertNotIn(hidden[0], fixture.calls)
            else:
                self.assertIn(hidden[0], fixture.calls)
        self.assertEqual(created[0], created[1])

    def test_pick_pages_and_random_dispatch_stay_synced_between_clients(self):
        callbacks = []
        for client_id in (0, 1):
            vm = ui.load_source('WoS_Pick_Init.j')
            source = (ui.ROOT / 'triggers/WOS_Start/WoS_Pick_Init.j').read_text(encoding='utf-8-sig')
            for name, value in re.findall(r'(?m)^\s*(?:private )?integer (\w+)\s*=\s*(\d+)\b', source):
                vm.g[name] = int(value)
            for name in re.findall(r'(?m)^\s*(?:private )?framehandle (\w+)\b', source):
                if name != 'array':
                    vm.g.setdefault(name, ('frame', name))
            events = []
            callbacks.append(events)
            vm.g.update(GetTriggerPlayer=lambda: 0, GetLocalPlayer=lambda: client_id,
                        GetPlayerId=lambda p: p, Player=lambda p: p,
                        IsAllyExist=lambda _: False, IsObserverSlot=lambda _: False,
                        TestMode=True, CaptainMode=False, CaptainDraftMode=False,
                        WOS_PreviewReady=True, Toji_ID='toji',
                        CaptainDraftPreRoundUnlimitedSwap=False,
                        TestUnitPickMode=defaultdict(int),
                        MakeSoundLocal=lambda *args: events.append(('sound', args)),
                        RandomPick=lambda *args: events.append(('random', args)),
                        WUI_SetButtonCaption=lambda *_: None, BlzFrameSetVisible=lambda *_: None,
                        BlzFrameSetEnable=lambda *_: None, BlzFrameSetTexture=lambda *_: None,
                        BlzFrameSetText=lambda *_: None)
            def forbid(*args):
                self.fail(f'Pick presentation attempted a handle lookup: {args}')
            for name in ('BlzGetFrameByName', 'BlzGetOriginFrame', 'BlzFrameGetChild',
                         'BlzFrameGetParent', 'BlzCreateFrameByType', 'ExecuteFunc',
                         'TriggerExecute', 'TriggerEvaluate', 'CreateTrigger', 'CreateTimer'):
                vm.g[name] = forbid
            for page in range(6):
                vm.g['BlzGetTriggerFrame'] = lambda page=page: vm.g['Frame_PageHeroList'][page]
                vm.run('OnClick')
                self.assertEqual(page + 1, vm.g['PlayerFrameCurrentPage_ID'][0])
            vm.g['BlzGetTriggerFrame'] = lambda: vm.g['FRAME_Pick'][3]
            vm.run('OnClick')
            self.assertEqual(('random', (0,)), events[-1])
        self.assertEqual(callbacks[0], callbacks[1])


if __name__ == '__main__':
    unittest.main()
