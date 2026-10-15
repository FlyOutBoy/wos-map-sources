"""Menu native-paint reset and scaled stat bounds, using actual JASS methods."""
import unittest,re
import test_wos_ui as ui
import test_wos_ui_multiplayer as multi
class Fixes(unittest.TestCase):
 def test_menu_repeated_clicks_close_and_mouse_leave_clear_paint(self):
  h=multi.MultiplayerFrames();h._testMethodName='runTest';f,_,v=h.client(0);g=f.vm.g;g['GetTriggerPlayer']=lambda:0;g['BlzGetTriggerFrame']=lambda:g['WUI_Menu']
  for _ in range(3):
   g['BlzGetTriggerFrameEvent']=lambda:g['FRAMEEVENT_MOUSE_ENTER'];f.vm.run('WUI_ControlClick');self.assertTrue(v[g['WUI_MenuHoverArt']])
   g['BlzGetTriggerFrameEvent']=lambda:g['FRAMEEVENT_CONTROL_CLICK'];f.vm.run('WUI_ControlClick');self.assertTrue(g['WUI_MenuOpen']);self.assertTrue(v[g['WUI_MenuActive']]);self.assertFalse(v[g['WUI_MenuPushed']])
   g['BlzGetTriggerFrameEvent']=lambda:g['FRAMEEVENT_MOUSE_LEAVE'];f.vm.run('WUI_ControlClick');self.assertFalse(v[g['WUI_MenuHoverArt']]);self.assertTrue(v[g['WUI_MenuActive']])
   f.vm.run('WUI_CloseMenuDrop');self.assertFalse(g['WUI_MenuOpen']);self.assertFalse(v[g['WUI_MenuActive']]);self.assertFalse(v[g['WUI_MenuPushed']])
  self.assertIn(('BlzFrameSetFocus',(g['WUI_Menu'],False)),f.calls)
 def test_foreign_player_menu_event_cannot_change_local_paint(self):
  h=multi.MultiplayerFrames();h._testMethodName='runTest';f,_,v=h.client(1);g=f.vm.g;g['GetTriggerPlayer']=lambda:0;g['BlzGetTriggerFrame']=lambda:g['WUI_Menu'];g['BlzGetTriggerFrameEvent']=lambda:g['FRAMEEVENT_CONTROL_CLICK'];f.vm.run('WUI_ControlClick');self.assertFalse(g['WUI_MenuOpen'])
 def test_stats_fill_available_width_without_crossing_widget_or_moving_font(self):
  vm=ui.load_source('DefaultArmorChangeStable_Copy.j');g=vm.g;sizes={};scales={};points={};created=[]
  def frame(kind,name,*_):fr=(kind,len(created));created.append(fr);return fr
  g.update(UNITSTAT_Root='root',BlzCreateFrameByType=frame,BlzFrameSetSize=lambda fr,w,h:sizes.update({fr:(w,h)}),BlzFrameSetScale=lambda fr,v:scales.update({fr:v}),BlzFrameSetPoint=lambda fr,*p:points.update({fr:p}),BlzFrameSetTexture=lambda *_:None,BlzFrameSetEnable=lambda *_:None,BlzFrameSetTextAlignment=lambda *_:None,WUI_PlaceShiftLeft=lambda *_:None,FRAMEPOINT_LEFT='left',TEXT_JUSTIFY_MIDDLE='middle',TEXT_JUSTIFY_LEFT='left')
  for index,width in [(3,.058),(4,.058),(5,.058),(8,.040),(0,.103)]:
   vm.run('UNITSTAT_WidgetCreate',(index,'icon',.2615,.04,width,None));fr=g['UNITSTAT_Value'][index];self.assertAlmostEqual(sizes[fr][0]*scales[fr],width-.015);self.assertEqual(scales[fr],.76);self.assertEqual(points[fr][-2:],(.0145,0));self.assertLessEqual(.0145+sizes[fr][0]*.76,width)
 def test_full_values_and_negative_bonuses_independent_clients(self):
  a=ui.load_source('DefaultArmorChangeStable_Copy.j');b=ui.load_source('DefaultArmorChangeStable_Copy.j')
  for vm in [a,b]:vm.g.update(I2S=str,WUI_GOLD='gold')
  for bonus in [99,100,999,1000,-99,-100,-999,-1000,0]:
   text=a.run('UNITSTAT_StatText',(1200+bonus,1200,False));plain=re.sub(r'\|c[0-9a-fA-F]{8}|\|r','',text);self.assertEqual(plain,'1200'+((' +'+str(bonus)) if bonus>0 else (' '+str(bonus)) if bonus<0 else ''))
  self.assertIn('+1000',a.run('UNITSTAT_StatText',(2200,1200,False)));self.assertIn('-1000',b.run('UNITSTAT_StatText',(200,1200,False)))
 def test_compact_menu_state_and_no_event_getters_in_runtime_cache(self):
  h=multi.MultiplayerFrames();h._testMethodName='runTest';f,_,v=h.client(0);g=f.vm.g;f.vm.run('WUI_ShowTopControls',(False,));g['GetTriggerPlayer']=lambda:0;g['BlzGetTriggerFrame']=lambda:g['WUI_Menu'];g['BlzGetTriggerFrameEvent']=lambda:g['FRAMEEVENT_CONTROL_CLICK'];f.vm.run('WUI_ControlClick');self.assertTrue(g['WUI_MenuOpen']);f.vm.run('WUI_ControlClick');self.assertFalse(g['WUI_MenuOpen']);self.assertFalse(v[g['WUI_MenuPushed']])
if __name__=='__main__':unittest.main()
