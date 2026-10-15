"""Native candidates use validated trees; restore/menu paths use cached frames."""
import unittest,re
from pathlib import Path
import test_wos_ui as ui
import test_wos_ui_multiplayer as multi
ROOT=Path(__file__).resolve().parents[1]
class TopInput(unittest.TestCase):
 def clock(self,match=True):
  vm=ui.load_source('WOSUI.j');reads=[];hides=[]
  children={'game':['w0','w1','w2','w3','w4','cluster'],'cluster':['clock','minimap' if match else 'other'],'clock':['listener']}
  parents={'minimap':'cluster','listener':'clock'}
  vm.g.update(WUI_MinimapNative='minimap',WUI_Resource='resource',WUI_SystemBar='bar',BlzGetOriginFrame=lambda *_:'game',ORIGIN_FRAME_GAME_UI='game-kind',
   BlzFrameGetChildrenCount=lambda f:len(children.get(f,[])),BlzFrameGetChild=lambda f,i:reads.append((f,i)) or children[f][i],BlzFrameGetParent=lambda f:parents.get(f),BlzFrameSetVisible=lambda f,v:hides.append((f,v)))
  return vm,reads,hides
 def test_clock_listener_and_minimap_sibling_are_distinguished(self):
  vm,reads,hides=self.clock();vm.run('WUI_CacheClockListener');self.assertEqual(vm.g['WUI_ClockListener'],'listener')
  vm.run('WUI_ApplyClockTooltipDiagnostic');self.assertEqual(hides,[('listener',False)])
  self.assertNotIn(('minimap',False),hides);self.assertNotIn(('cluster',False),hides)
 def test_changed_hierarchy_is_not_hidden_blindly(self):
  vm,reads,hides=self.clock(False);vm.run('WUI_CacheClockListener');self.assertIsNone(vm.g['WUI_ClockListener']);vm.run('WUI_ApplyClockTooltipDiagnostic');self.assertEqual(hides,[])
  self.assertNotIn(('clock',0),reads)
 def test_restore_and_hide_ui_do_not_lookup_or_show_blockers(self):
  helper=multi.MultiplayerFrames();helper._testMethodName='runTest'
  for pid in [0,1]:
   f,_,v=helper.client(pid);g=f.vm.g;g['WUI_ClockListener']='cached-listener'
   g['BlzFrameGetName']=lambda *_:self.fail('Runtime name lookup')
   for name in ['WUI_ShowNativeMenu','WUI_RestoreCompactNative']:f.vm.run(name,(pid,))
   f.vm.run('WUI_ShowTopControls',(False,));f.vm.run('WUI_ShowTopControls',(True,))
   self.assertTrue(v[g['WUI_SystemBar']]);self.assertFalse(v['cached-listener'])
 def test_folded_menu_style_matches_hide_text_button_without_creating_again(self):
  helper=multi.MultiplayerFrames();helper._testMethodName='runTest';f,_,v=helper.client(0);g=f.vm.g
  f.vm.run('WUI_ShowTopControls',(False,));self.assertTrue(v[g['WUI_MenuBack']]);self.assertTrue(v[g['WUI_MenuCompactStyle']]);self.assertFalse(v[g['WUI_MenuIcon']])
  self.assertIn(('BlzFrameSetScale',(g['WUI_MenuLabel'],g['WUI_TOP_ROW_TEXT'])),f.calls)
  self.assertIn(('BlzFrameSetTexture',(g['WUI_MenuBack'],g['WUI_FILL_SELECTED'],0,True)),f.calls)
  f.vm.run('WUI_ShowTopControls',(True,));self.assertFalse(v[g['WUI_MenuBack']]);self.assertFalse(v[g['WUI_MenuCompactStyle']]);self.assertTrue(v[g['WUI_MenuIcon']])
if __name__=='__main__':unittest.main()
