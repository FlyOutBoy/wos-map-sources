"""Focus ownership/event/lifetime checks; native keyboard recovery needs game testing."""
from collections import defaultdict
from pathlib import Path
from types import SimpleNamespace
import re
import unittest

from test_wos_ui import load_source

ROOT = Path(__file__).resolve().parents[1]
FUNCTION = re.compile(r"(?m)^\s*(?:(?:private|public)\s+)?function\s+(\w+)\s+takes[^\n]*\n([\s\S]*?)^\s*endfunction")


def strip_comments(text):
    return re.sub(r"/\*.*?\*/|//[^\n]*", "", text, flags=re.S)


def inventory():
    sources = {p: strip_comments(p.read_text(encoding="utf-8-sig"))
               for p in (ROOT / "triggers").rglob("*.j")}
    functions = {p: dict(FUNCTION.findall(s)) for p, s in sources.items()}
    bindings = {}
    all_bindings = defaultdict(set)
    for p, source in sources.items():
        bindings[p] = defaultdict(set)
        for trigger, callback in re.findall(r"TriggerAdd(?:Action|Condition)\((\w+),\s*(?:Condition\()?\s*function\s+(\w+)", source):
            bindings[p][trigger].add(callback)
            all_bindings[trigger].add(callback)
    handlers = set()
    for p, source in sources.items():
        for trigger in re.findall(r"BlzTriggerRegisterFrameEvent\((\w+),[^\n]*,\s*FRAMEEVENT_(?:CONTROL_CLICK|CHECKBOX_CHECKED|CHECKBOX_UNCHECKED)\)", source):
            callbacks = bindings[p][trigger] or all_bindings[trigger]
            if not callbacks:
                raise AssertionError(f"Unresolved click trigger {p}:{trigger}")
            for callback in callbacks:
                if callback in functions[p]:
                    handlers.add((p, callback))
                else:
                    matches = [f for f, names in functions.items() if callback in names]
                    if len(matches) != 1:
                        raise AssertionError(f"Unresolved callback {callback}: {matches}")
                    handlers.add((matches[0], callback))
    return sources, functions, handlers


class FocusContract(unittest.TestCase):
    def setUp(self):
        self.vm = load_source("WOSUI.j")
        self.owner = 0
        self.local = 0
        self.frame = "button"
        self.event = "click"
        self.calls = []
        self.vm.g.update({
            "GetTriggerPlayer": lambda: self.owner,
            "GetLocalPlayer": lambda: self.local,
            "BlzGetTriggerFrame": lambda: self.frame,
            "BlzGetTriggerFrameEvent": lambda: self.event,
            "FRAMEEVENT_CONTROL_CLICK": "click",
            "FRAMEEVENT_CHECKBOX_CHECKED": "checked",
            "FRAMEEVENT_CHECKBOX_UNCHECKED": "unchecked",
            "FRAMEEVENT_MOUSE_UP": "up",
            "BlzFrameSetFocus": lambda f, on: self.calls.append((f, on)),
        })

    def test_release_only_event_owner_on_all_clients(self):
        for owner in (0, 1, 9, 12):
            for local in (0, 1, 9, 12):
                with self.subTest(owner=owner, local=local):
                    self.owner, self.local = owner, local
                    self.calls.clear()
                    self.vm.run("WUI_ReleaseClickFocus")
                    self.assertEqual(self.calls, [("button", False)] if owner == local else [])

    def test_click_checkbox_and_button_drag_release(self):
        for event in ("click", "checked", "unchecked", "up"):
            self.event = event
            self.calls.clear()
            self.vm.run("WUI_ReleaseClickFocus")
            self.assertEqual(self.calls, [("button", False)])

    def test_key_hover_wheel_text_and_slider_events_keep_focus(self):
        for event in (None, "enter", "leave", "wheel", "text", "slider"):
            self.event = event
            self.vm.run("WUI_ReleaseClickFocus")
        self.frame = None
        self.event = "click"
        self.vm.run("WUI_ReleaseClickFocus")
        self.assertEqual(self.calls, [])

    def reset_fixture(self, enabled=True):
        self.enabled = enabled
        self.vm.g['BlzFrameGetEnable'] = lambda f: self.enabled
        def set_enabled(frame, value):
            self.calls.append(('enabled', frame, value))
            self.enabled = value
        self.vm.g['BlzFrameSetEnable'] = set_enabled
        for native in ('BlzFrameSetFocus', 'BlzFrameGetParent', 'BlzGetOriginFrame',
                       'BlzCreateFrame', 'BlzCreateFrameByType', 'BlzDestroyFrame',
                       'CreateTimer', 'CreateTrigger'):
            self.vm.g[native] = lambda *args, n=native: self.fail(n)

    def test_reset_uses_exact_clicked_control_and_preserves_enabled_state(self):
        self.reset_fixture()
        self.frame = 'interactive-button-not-its-icon'
        self.vm.run('WUI_ResetClickedButtonFocus')
        self.assertEqual(self.calls, [('enabled', self.frame, False), ('enabled', self.frame, True)])
        self.assertTrue(self.enabled)

    def test_disabled_button_is_never_reenabled(self):
        self.reset_fixture(False)
        self.vm.run('WUI_ResetClickedButtonFocus')
        self.assertEqual(self.calls, [])
        self.assertFalse(self.enabled)

    def test_reset_only_for_own_real_clicks_and_checkbox_events(self):
        for event in ('click', 'checked', 'unchecked'):
            for owner in (0, 1, 9, 12):
                for local in (0, 1, 9, 12):
                    self.reset_fixture()
                    self.calls.clear()
                    self.owner, self.local, self.event = owner, local, event
                    self.vm.run('WUI_ResetClickedButtonFocus')
                    self.assertEqual(len(self.calls), 2 if owner == local else 0)
                    self.assertTrue(self.enabled)

    def test_key_hover_drag_text_and_slider_do_not_read_or_toggle_button(self):
        self.reset_fixture()
        self.vm.g['BlzFrameGetEnable'] = lambda f: self.fail('queried non-click control')
        for local, event, frame in [(1, 'click', 'button'), (0, 'text', 'user-search'),
                                    (0, 'slider', 'slider'), (0, None, None),
                                    (0, 'up', 'button'), (0, 'enter', 'button')]:
            self.local, self.event, self.frame = local, event, frame
            self.vm.run('WUI_ResetClickedButtonFocus')
        self.assertEqual(self.calls, [])

    def test_handler_disabling_button_before_cleanup_is_preserved(self):
        self.reset_fixture()
        vm = load_source('DefaultArmorChangeStable_Copy.j')
        vm.g.update(self.vm.g)
        vm.g['GetPlayerId'] = lambda p: p
        def apply_state(*args):
            self.calls.append(('business-disabled', self.frame))
            self.enabled = False
        vm.g['WUI_SetToggleState'] = apply_state
        vm.g['WUI_ResetClickedButtonFocus'] = lambda: self.vm.run('WUI_ResetClickedButtonFocus')
        vm.run('UNITSTAT_OnVoiceToggle')
        self.assertEqual(self.calls, [('business-disabled', self.frame)])
        self.assertFalse(self.enabled)

    def test_passive_dynamic_controls_register_once_and_share_one_trigger(self):
        registry, registrations, triggers, actions = {}, [], [], []
        self.vm.g.update({
            "WUI_PassiveFocusFrames": registry, "WUI_PassiveFocusClick": None,
            "GetHandleId": lambda f: f,
            "HaveSavedBoolean": lambda table, key, child: (key, child) in table,
            "SaveBoolean": lambda table, key, child, value: table.update({(key, child): value}),
            "CreateTrigger": lambda: triggers.append("passive") or "passive",
            "TriggerAddAction": lambda *args: actions.append(args),
            "BlzTriggerRegisterFrameEvent": lambda *args: registrations.append(args),
        })
        for frame in (None, "a", "b", "a", "b"):
            self.vm.run("WUI_RegisterPassiveFocus", (frame,))
        self.assertEqual(triggers, ["passive"])
        self.assertEqual(len(actions), 1)
        self.assertEqual(registrations, [("passive", "a", "click"), ("passive", "b", "click")])

    def test_toolbar_logic_precedes_cleanup(self):
        vm = load_source("DefaultArmorChangeStable_Copy.j")
        vm.g.update(self.vm.g)
        vm.g.update({
            "UNITSTAT_Shop": "button",
            "WOS_ToggleShop": SimpleNamespace(evaluate=lambda p: self.calls.append(("shop", p))),
            "WUI_ReleaseClickFocus": lambda: self.vm.run("WUI_ReleaseClickFocus"),
        })
        vm.run("UNITSTAT_ToolbarClick")
        self.assertEqual(self.calls, [("shop", 0), ("button", False)])

    def test_shop_close_early_return_hides_then_releases_live_button(self):
        vm = load_source("WoS_Shop_Init.j")
        vm.g.update(self.vm.g)
        vm.g.update({
            "GetPlayerId": lambda p: p, "GetSelectedHeroForPlayer": lambda p: None,
            "ShopFrameTable": {}, "LoadInteger": lambda *_: 408,
            "FRAME_ShopMAIN": "shop-panel", "Shop_Active": defaultdict(lambda: True),
            "WUI_ReleaseClickFocus": lambda: self.vm.run("WUI_ReleaseClickFocus"),
            "BlzFrameSetVisible": lambda *args: self.calls.append(args),
        })
        vm.run("OnClickItem")
        self.assertFalse(vm.g["Shop_Active"][0])
        self.assertEqual(self.calls, [("shop-panel", False), ("button", False)])

    def test_link_open_transfers_to_editbox_after_button_cleanup(self):
        vm = load_source("WoS_Hero_Icons_Init.j")
        vm.g.update(self.vm.g)
        vm.g.update({
            "GetPlayerId": lambda p: p, "FRAME_LINK2": "button", "FRAME_LINK": "edit",
            "FRAME_LINK3": "link-label", "FRAME_LINK4": "link-close", "FRAME_LINK5": "link-back",
            "BlzFrameSetVisible": lambda *_: None, "BlzFrameSetText": lambda *_: None,
            "BlzFrameSetEnable": lambda *_: None,
            "WUI_ReleaseClickFocus": lambda: self.vm.run("WUI_ReleaseClickFocus"),
        })
        vm.run("OnClickFrameLink")
        self.assertEqual(self.calls, [("button", False), ("edit", True)])


class FocusAudit(unittest.TestCase):
    def test_every_registered_button_handler_and_early_return_cleans_up(self):
        _, functions, handlers = inventory()
        for path, name in handlers:
            if name in ("LMP_OnLinkEdit", "WUI_ReleaseClickFocus"):
                continue  # Intentional EDITBOX focus, or the cleanup action itself.
            with self.subTest(file=path.name, handler=name):
                body = functions[path][name]
                if 'call WOS_FinishPickerClick()' in body:
                    wrapper = functions[path]['WOS_FinishPickerClick']
                    self.assertIn('frame == FRAME_Pick[2] or frame == FRAME_Pick[3]', wrapper)
                    self.assertIn('call WUI_ResetClickedButtonFocus()', wrapper)
                    self.assertIn('call WUI_ReleaseClickFocus()', wrapper)
                    body = body.replace('call WOS_FinishPickerClick()', 'call WUI_ResetClickedButtonFocus()')
                self.assertRegex(body, r"call WUI_(?:ReleaseClickFocus|ResetClickedButtonFocus)\(\)")
                for early in re.finditer(r"(?m)^\s*return\s*$", body):
                    if name == 'WOS_STATS_OnData' and 'if GetTriggeringTrigger() == WOS_STATS_DataKeys then' in body[:early.start()]:
                        continue  # Rejected keyboard event has no clicked frame.
                    self.assertRegex(body[:early.start()].rstrip(), r"call WUI_(?:ReleaseClickFocus|ResetClickedButtonFocus)\(\)$")
                # At the ordinary exit only intentional link-focus transfer / restart may follow.
                tail = re.split(r"call WUI_(?:ReleaseClickFocus|ResetClickedButtonFocus)\(\)", body)[-1]
                self.assertNotRegex(tail, r"\bcall (?!BlzFrameSetFocus|RestartGame)\w+\(")

    def test_cleanup_is_not_used_by_editboxes_or_slider_only_handlers(self):
        sources, functions, _ = inventory()
        for path, names in functions.items():
            for name, body in names.items():
                if name in ("LMP_OnLinkEdit", "LMP_OnScroll", "LMP_OnVolume", "OnEditBoxFocus",
                            "ShopSearchOnTextChanged", "ShopVipLinkEdited", "ShopDescOnScroll",
                            "ShopCraftOnScroll", "SliderCheck"):
                    self.assertNotIn("WUI_ReleaseClickFocus", body, f"{path}:{name}")
        self.assertIn("call BlzFrameSetFocus(editBox, true)",
                      functions[ROOT / "triggers/WOS_Start/MusicPlayer.j"]["LMP_OnLinkEdit"])

    def test_audited_click_paths_do_not_destroy_frames_or_yield(self):
        _, functions, handlers = inventory()
        all_functions = defaultdict(list)
        for names in functions.values():
            for name, body in names.items():
                all_functions[name].append(body)
        for path, name in handlers:
            pending, seen = [functions[path][name]], set()
            while pending:
                body = pending.pop()
                if body in seen:
                    continue
                seen.add(body)
                self.assertNotRegex(body, r"\bcall (?:BlzDestroyFrame|TriggerSleepAction|PolledWait)\(", f"{path}:{name}")
                for callee in re.findall(r"\bcall (\w+)(?:\.evaluate|\.execute)?\(", body):
                    pending.extend(all_functions[callee])

    def test_only_new_helper_owns_enable_toggle_no_sink_or_method_mix(self):
        sources, functions, _ = inventory()
        for path, source in sources.items():
            self.assertNotIn('WUI_ReleaseStuckClickFocus', source)
            self.assertNotIn('WUI_FocusSink', source)
            for name, body in functions[path].items():
                if name != 'WUI_ResetClickedButtonFocus':
                    self.assertNotRegex(body, r'BlzFrameSetEnable\(([^\n]+),\s*false\)\s*call BlzFrameSetEnable\(\1,\s*true\)', str(path))
                if 'call WUI_ResetClickedButtonFocus()' in body:
                    # Mixed toolbar/QB branches are mutually exclusive by frame/code.
                    self.assertNotIn('BlzFrameSetFocus', body, f'{path}:{name}')
        wui = functions[ROOT / 'triggers/WOS_Start/WOSUI.j']
        helper = wui['WUI_ResetClickedButtonFocus']
        self.assertNotRegex(helper, r'Timer|Create|Destroy|Save|SelectUnit|Issue|BlzFrameSetFocus')
        self.assertIn('if BlzFrameGetEnable(frame) then', helper)
        self.assertNotIn('BlzFrameSetEnable', wui['WUI_SetToggleState'])


if __name__ == "__main__":
    unittest.main()
