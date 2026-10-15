"""Hide UI: real event dispatch + cached presentation on asymmetric clients."""
import unittest,re
from collections import defaultdict
from pathlib import Path
import test_wos_ui as ui
from test_wos_ui_multiplayer import MultiplayerFrames
ROOT=Path(__file__).resolve().parents[1]
class HideFollowup(unittest.TestCase):
 def test_real_hide_event_dispatch_is_same_on_actor_and_other_client(self):
  flags=[];logs=[]
  for viewer in [0,1]:
   vm=ui.load_source('WoS_Hero_Icons_Init.j');calls=[]
   vm.g.update(GetTriggerPlayer=lambda:0,GetLocalPlayer=lambda v=viewer:v,GetPlayerId=lambda p:p,IsObserverSlot=lambda _:False,
    BlzGetTriggerFrame=lambda:'hide',FRAME_TopCheckbox='hide',FRAME_ShopButtonCheck='shop',FRAME_StatsCheckbox='stats',
    WUI_CloseTopFor=lambda p:calls.append(('close',p)),LocalMp3Player_SetTopVisible=lambda p,v:calls.append(('music',p,v)),
    WOS_ApplyTopHidden=lambda p,h:calls.append(('presentation',p,h)),BlzFrameSetEnable=lambda *_:None)
   vm.run('CheckBoxCheck');vm.run('CheckBoxCheck');flags.append(dict(vm.g['StatusHeroesHidden']));logs.append(calls)
  self.assertEqual(logs[0],logs[1]);self.assertEqual(flags[0],flags[1])
  self.assertEqual(logs[0],[('close',0),('music',0,False),('presentation',0,True),('music',0,True),('presentation',0,False)])
 def test_synced_close_listener_receives_same_player_on_both_clients(self):
  deliveries=[]
  for pid in [0,1]:
   f=ui.DeferredUIStartup();f.setUp();f.vm.run('WUI_Bootstrap');g=f.vm.g
   g.update(GetLocalPlayer=lambda p=pid:p,WUI_TopCloseCount=1,WUI_TopClose={1:'existing-close-trigger'})
   g['TriggerExecute']=lambda t,g=g:deliveries.append((t,g['WUI_TopClosePlayer']))
   f.vm.run('WUI_CloseTopFor',(0,));self.assertIsNone(g['WUI_TopClosePlayer'])
  self.assertEqual(deliveries,[('existing-close-trigger',0)]*2)
 def test_local_hide_keeps_map_info_menu_and_moves_single_toggle_without_dispatch(self):
  helper=MultiplayerFrames();helper._testMethodName='runTest'
  f,_,visible=helper.client(0);g=f.vm.g;points={}
  g['TriggerExecute']=lambda *_:self.fail('Local trigger dispatch')
  g['BlzFrameSetAbsPoint']=lambda frame,point,x,y:points.update({frame:(x,y)})
  f.vm.run('WUI_CollapseAllPanels');f.vm.run('WUI_ShowTopControls',(False,))
  for key in ['WUI_Menu','WUI_MinimapOwner','WUI_InfoOwner','WUI_MinimapToggle','WUI_InfoToggle']:
   self.assertTrue(visible[g[key]],key)
  self.assertEqual(points[g['WUI_Menu']],(g['WUI_ScreenRight']()-.094,.586))
  toggle=g['WUI_InfoToggle'];g['WUI_InfoHiddenOf'][0]=True;f.vm.run('WUI_ApplyPanelPreferences')
  self.assertEqual(points[toggle],(.7355+g['WUI_HudShift'],.0055));self.assertTrue(visible[toggle])
  f.vm.run('WUI_SetHud',(.044,-.044));self.assertEqual(points[toggle],(.7355+.044,.0055))
  g['WUI_InfoHiddenOf'][0]=False;f.vm.run('WUI_ApplyPanelPreferences');self.assertEqual(points[toggle],(.829+.044,.0055))
 def test_internal_split_has_single_divider_and_only_one_info_toggle_created(self):
  f=ui.DeferredUIStartup();f.setUp();f.vm.run('WUI_Bootstrap')
  created=[args for name,args in f.calls if name=='create'];names=[args[1] for args in created]
  self.assertEqual(names.count('WOSHideInfoPanel'),1)
  self.assertNotIn('WOSHUDMetalRight',names);self.assertNotIn('WOSInfoMetalLeft',names)
  source=(ROOT/'triggers/WOS_Start/DefaultArmorChangeStable_Copy.j').read_text(encoding='utf-8-sig')
  for control in ['UNITSTAT_ModeButton','UNITSTAT_VoiceToggle']:self.assertNotIn('WUI_RegisterTopControl('+control+')',source)
if __name__=='__main__':unittest.main()
