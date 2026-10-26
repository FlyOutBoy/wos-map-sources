"""Native TEST charge counters refresh on gameplay writes and selection events."""
from pathlib import Path
import re
import unittest
from test_crocodile import JassState

ROOT = Path(__file__).resolve().parents[1]


class NativeChargeBox(unittest.TestCase):
    def fixture(self, native):
        source = (ROOT/'triggers/Systems/TasBox.j').read_text('utf-8-sig')
        functions = re.findall(r'(?m)^   public function (?:Init|Select|SetValue) takes[\s\S]*?^   endfunction', source)
        vm = JassState('\n'.join(functions).replace('static if LIBRARY_WOSTestNativeUI then', 'if TestNative then'))
        calls = []
        unit = object()
        vm.g.update(TestNative=native, Initialized=False, Hash={}, Unit=[None]*24,
            Update=lambda:calls.append('update'), Create=lambda:calls.append('frames'), UpdateTimer=None, NativeUpdate=None, NativeRefreshing=False,
            LoadStr=lambda table,hid,key:table.get((hid,key)),
            StartFrames=lambda:None, bj_FORCE_PLAYER=[object()]*24, ForForce=lambda force,cb:cb(),
            SaveStr=lambda table,hid,key,value:table.update({(hid,key):value}),
            CreateTimer=lambda:calls.append('timer'), WUI_OnReady=lambda cb:calls.append('WUI-ready'),
            CreateTrigger=lambda:object(), TriggerAddAction=lambda *a:None,
            TriggerRegisterAnyUnitEventBJ=lambda *a:None, EVENT_PLAYER_UNIT_SELECTED=0,
            GetTriggerUnit=lambda:unit, GetTriggerPlayer=lambda:0, GetPlayerId=lambda p:p,
            GetUnitSpellCodeKey=lambda *a:1)
        return vm, calls, unit

    def test_native_mode_needs_no_timer_or_wosui_and_updates_on_write_and_selection(self):
        vm, calls, unit = self.fixture(True)
        vm.run('Init')
        self.assertEqual(['frames'], calls)
        vm.run('Init')
        self.assertEqual(['frames'], calls)
        vm.run('SetValue', (unit, 'A116', '2'))
        vm.run('SetValue', (unit, 'A116', '2'))  # no redundant refresh for unchanged charge count
        vm.run('Select')
        self.assertEqual(['frames', 'update', 'update'], calls)
        self.assertIs(unit, vm.g['Unit'][0])
        vm.g['NativeRefreshing'] = True
        vm.run('SetValue', (unit, 'A116', '1'))
        self.assertEqual(['frames', 'update', 'update'], calls)


    def test_main_mode_retains_deferred_ui_timer(self):
        vm, calls, _ = self.fixture(False)
        vm.run('Init')
        self.assertEqual(['timer', 'WUI-ready'], calls)


if __name__ == '__main__':
    unittest.main()
