"""Post-rollback contract: exact clean base, original native hides, UI preserved."""
import unittest,re
from pathlib import Path
import test_wos_ui as ui
import test_wos_ui_multiplayer as multi
ROOT=Path(__file__).resolve().parents[1]
class ConsoleTopBarRollback(unittest.TestCase):
 def test_consoletopbar_rollback_remains_intact(self):
  source=(ROOT/'triggers/WOS_Start/WOSUI.j').read_text(encoding='utf-8-sig')
  expected=(ROOT.parent/'consoletopbar-clean-base-WOSUI.j').read_text(encoding='utf-8-sig')
  for helper in ["WUI_CacheResourceMouse","WUI_ParkResourceBar","WUI_BlankResourceTexts"]:
   pattern=r"(?ms)^(?:private )?function "+helper+r" takes.*?^endfunction"
   self.assertEqual(re.search(pattern,source)[0],re.search(pattern,expected)[0])
  self.assertNotIn('WUI_HideConsoleTopBar',source)
  self.assertEqual(source.count('call BlzFrameSetVisible(WUI_TopConsole, false)'),2)
 def test_hide_show_and_menu_do_not_reapply_console_top_experiment(self):
  helper=multi.MultiplayerFrames();helper._testMethodName='runTest'
  for pid in [0,1]:
   f,_,v=helper.client(pid);g=f.vm.g;writes=[];original=g['BlzFrameSetVisible']
   def visible(fr,on):writes.append((fr,on));original(fr,on)
   g['BlzFrameSetVisible']=visible
   f.vm.run('WUI_ShowTopControls',(False,));f.vm.run('WUI_ShowTopControls',(True,));f.vm.run('WUI_ShowNativeMenu',(pid,))
   g['GetTriggerPlayer']=lambda p=pid:p;g['BlzGetTriggerFrame']=lambda:g['WUI_Menu'];f.vm.run('WUI_ControlClick')
   self.assertFalse(any(fr==g['WUI_TopConsole'] for fr,on in writes));self.assertTrue(v[g['WUI_SystemBar']])
   f.vm.run('WUI_RestoreCompactNative',(pid,));self.assertIn((g['WUI_TopConsole'],False),writes)
 def test_confirmed_clock_listener_remains_enabled(self):
  vm=ui.load_source('WOSUI.j');writes=[];vm.g.update(WUI_ClockListener='listener',BlzFrameSetVisible=lambda *a:writes.append(a))
  self.assertTrue(vm.g['WUI_TEST_CLOCK_TOOLTIP']);vm.run('WUI_ApplyClockTooltipDiagnostic');self.assertEqual(writes,[('listener',False)])
 def test_menu_geometry_and_style_are_preserved(self):
  helper=multi.MultiplayerFrames();helper._testMethodName='runTest';f,_,v=helper.client(0);g=f.vm.g;points={}
  g['BlzFrameSetAbsPoint']=lambda fr,pt,x,y:points.update({fr:(x,y)})
  f.vm.run('WUI_ShowTopControls',(False,));self.assertEqual(points[g['WUI_Menu']],(g['WUI_ScreenRight']()-.094,.586));self.assertTrue(v[g['WUI_MenuCompactStyle']]);self.assertTrue(v[g['WUI_MenuBack']])
  f.vm.run('WUI_ShowTopControls',(True,));self.assertEqual(points[g['WUI_Menu']],(g['WUI_TopActionX'](0),.578));self.assertTrue(v[g['WUI_MenuIcon']]);self.assertFalse(v[g['WUI_MenuBack']])
if __name__=='__main__':unittest.main()
