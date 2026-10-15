"""Actual reset/row JASS with native mocks; not an engine/multiplayer acceptance."""
import unittest,re
from collections import defaultdict
import test_wos_ui as ui
class ResetKeys(unittest.TestCase):
 def client(self,local=0):
  vm=ui.load_source('WOSUI.j');g=vm.g;self.paint=[];self.disabled=[];self.paused=[];self.notices=[];self.defaults=['F2','K','Z','F3','F4','TAB']
  g.update(WUI_GOLD='',WUI_TEXT='',WUI_HotkeyToggle='toggle',WUI_PulseTimer='pulse',DisableTrigger=self.disabled.append,PauseTimer=self.paused.append,GetLocalPlayer=lambda:local,BlzFrameSetText=lambda *a:self.paint.append(a),WUI_SizeHotkeyBadge=lambda *_:None,WUI_RefreshSlotBadges=lambda:self.paint.append(('slots','refreshed')),DisplayTimedTextToPlayer=lambda *a:self.notices.append(a),GetTriggeringTrigger=lambda:'trigger0',BlzGetTriggerPlayerKey=lambda:'F2',GetTriggerPlayer=lambda:0)
  for n in ['CreateTrigger','CreateTimer','CreateGroup','BlzTriggerRegisterPlayerKeyEvent','BlzCreateFrame','BlzCreateFrameByType','BlzGetFrameByName','BlzGetOriginFrame','ForceUIKey','ExecuteFunc']:g[n]=lambda *_,n=n:self.fail('reset must not allocate/register/action '+n)
  for c,key in enumerate(self.defaults):
   g['WUI_HotkeyDefaultKey'][c]=key;g['WUI_HotkeyDefaultName'][c]=key;g['WUI_HotkeyTrigger'][c]='trigger'+str(c);g['WUI_HotkeyLabel'][c]='label'+str(c)
   for p in [0,1]:
    g['WUI_HotkeyKey'][c*16+p]='X'+str(c);g['WUI_HotkeyName'][c*16+p]='X'+str(c);g['WUI_HotkeyUsedCount'][c*16+p]=2;g['WUI_HotkeyUsed'][(c*16+p)*16]=key;g['WUI_HotkeyUsed'][(c*16+p)*16+1]='X'+str(c)
  for p in [0,1]:
   g['WUI_CaptureTrigger'][p]='capture'+str(p);g['WUI_SlotCaptureTrigger'][p]='slotcap'+str(p);g['WUI_CaptureChannel'][p]=3;g['WUI_SlotCapture'][p]=2;g['WUI_HotkeyEdit'][p]=True
   for slot in range(13):g['WUI_SlotKey'][p*13+slot]='U';g['WUI_SlotKeyName'][p*13+slot]='U'
  return vm
 def test_all_channels_and_slots_restore_only_sender(self):
  vm=self.client();g=vm.g;vm.run('WUI_ResetHotkeys',(0,))
  for c,key in enumerate(self.defaults):self.assertEqual(g['WUI_HotkeyKey'][c*16],key);self.assertEqual(g['WUI_HotkeyName'][c*16],key);self.assertEqual(g['WUI_HotkeyName'][c*16+1],'X'+str(c))
  for s in range(13):self.assertIsNone(g['WUI_SlotKey'][s]);self.assertEqual(g['WUI_SlotKeyName'][s],'');self.assertEqual(g['WUI_SlotKeyName'][13+s],'U')
  self.assertEqual(self.disabled,['capture0','slotcap0']);self.assertEqual(g['WUI_CaptureChannel'][0],-1);self.assertEqual(g['WUI_SlotCapture'][0],-1);self.assertFalse(g['WUI_HotkeyEdit'][0]);self.assertTrue(g['WUI_HotkeyEdit'][1])
 def test_two_clients_agree_but_only_owner_paints(self):
  snapshots=[]
  for local in [0,1]:
   vm=self.client(local);vm.run('WUI_ResetHotkeys',(1,));snapshots.append([vm.g['WUI_HotkeyName'][c*16+1] for c in range(6)])
   self.assertEqual(bool(self.paint),local==1);self.assertEqual(bool(self.paused),local==1);self.assertEqual(self.disabled,['capture1','slotcap1'])
  self.assertEqual(snapshots[0],snapshots[1])
 def test_old_custom_events_filtered_default_registered_events_still_work(self):
  vm=self.client();g=vm.g;before=dict(g['WUI_HotkeyUsed']);vm.run('WUI_ResetHotkeys',(0,));g['BlzGetTriggerPlayerKey']=lambda:'X0';self.assertFalse(vm.run('WUI_HotkeyFilter'));g['BlzGetTriggerPlayerKey']=lambda:'F2';self.assertTrue(vm.run('WUI_HotkeyFilter'));self.assertEqual(dict(g['WUI_HotkeyUsed']),before);self.assertEqual(g['WUI_HotkeyUsedCount'][0],2)
 def test_reset_idempotent_and_save_serializes_defaults_without_custom_slots(self):
  vm=self.client();g=vm.g;g.update(I2S=str,WUI_IsVoiceMuted=lambda *_:False);vm.run('WUI_ResetHotkeys',(0,));vm.run('WUI_ResetHotkeys',(0,));s=vm.run('WUI_SavedSettingsString',(0,));self.assertNotIn('K,',s)
  for c,key in enumerate(self.defaults):self.assertIn('H,'+str(c)+','+key+'|',s)
 def test_unregistered_owner_and_missing_editor_safe(self):
  vm=self.client();g=vm.g;g['WUI_HotkeyTrigger'][2]=None;g['WUI_HotkeyToggle']=None;g['WUI_PulseTimer']=None;vm.run('WUI_ResetHotkeys',(0,));self.assertEqual(g['WUI_HotkeyName'][2*16],'X2');self.assertNotIn(('slots','refreshed'),self.paint);self.assertFalse(self.paused)
 def test_invalid_player_cannot_mutate_any_state(self):
  vm=self.client();before=dict(vm.g['WUI_HotkeyKey']);vm.run('WUI_ResetHotkeys',(10,));vm.run('WUI_ResetHotkeys',(-1,));self.assertEqual(dict(vm.g['WUI_HotkeyKey']),before);self.assertFalse(self.paint);self.assertFalse(self.disabled)
 def test_owner_registration_retains_real_default_after_rebinding(self):
  vm=self.client();g=vm.g;registered=[];g.update(WUI_InitKeyTable=lambda:None,WUI_HotkeyClick='click',WUI_RegisterKeyFor=lambda *a:registered.append(a),TriggerAddCondition=lambda *_:None,Condition=lambda f:f,BlzCreateFrameByType=lambda typ,name,*_:name,BlzFrameSetPoint=lambda *_:None,BlzFrameSetAllPoints=lambda *_:None,BlzFrameSetTexture=lambda *_:None,BlzFrameSetEnable=lambda *_:None,BlzFrameSetLevel=lambda *_:None,BlzFrameSetTextAlignment=lambda *_:None,BlzFrameSetScale=lambda *_:None,BlzTriggerRegisterFrameEvent=lambda *_:None,WUI_Tooltip=lambda *_:None,WUI_TooltipBelowLeft=lambda *_:None,FRAMEPOINT_LEFT='left',FRAMEPOINT_RIGHT='right',FRAMEPOINT_BOTTOMRIGHT='br',TEXT_JUSTIFY_MIDDLE='mid',TEXT_JUSTIFY_CENTER='centre',FRAMEEVENT_CONTROL_CLICK='click')
  vm.run('WUI_RegisterHotkeyEx',(2,'actual-owner','F9','F9',True,'owner','parent',False));self.assertEqual(len(registered),16);g['WUI_HotkeyKey'][32]='X';g['WUI_HotkeyName'][32]='X';vm.run('WUI_ResetHotkeys',(0,));self.assertEqual(g['WUI_HotkeyKey'][32],'F9');self.assertEqual(g['WUI_HotkeyName'][32],'F9');self.assertEqual(len(registered),16)
 def test_row_preserves_exact_old_edges_and_gaps_at_all_aspects(self):
  vm=self.client();g=vm.g;w=g['WUI_TOP_ROW_W'];xs=[g['WUI_TOP_ROW_X'+str(i)] for i in range(1,5)]
  for right in [.4+.3*a for a in [5/4,4/3,16/9,21/9]]:
   self.assertAlmostEqual(right-xs[0]-w/2,right-(.15065+.0572/2));self.assertAlmostEqual(right-xs[-1]+w/2,right-(.02925-.0572/2))
   for i in range(3):self.assertAlmostEqual(xs[i]-xs[i+1]-w,.0035)
  self.assertEqual(g['WUI_TOP_ROW_TEXT'],.66)
class ResetFlow(unittest.TestCase):
 def client(self,p=0,local=0):
  vm=ui.load_source('SaveLoad.j');g=vm.g;self.sync=[];self.reset=[];self.save=[];self.load=[];g.update(ss_SettingsLastPacket="",ss_SettingsReadReady=False,GetTriggerPlayer=lambda:p,GetLocalPlayer=lambda:local,GetPlayerId=lambda p:p,Player=lambda p:p,BlzGetTriggerFrame=lambda:'reset',ss_ResetButton='reset',BlzSendSyncData=lambda *a:self.sync.append(a),BlzGetTriggerSyncPrefix=lambda:'WOS2SAVE',BlzGetTriggerSyncData=lambda:'R',WUI_ResetHotkeys=self.reset.append,SaveSystem_SaveButtonRequest=self.save.append,SubString=lambda s,a,b:s[a:b],StringLength=len,S2I=lambda s:int(s) if s.lstrip('-').isdigit() else 0,ExecuteFunc=lambda *_:None,WUI_ApplyPanelPreferences=lambda:None,DisplayTimedTextToPlayer=lambda *_:None,IsGamePlayerSlot=lambda p:0<=p<10,WUI_ApplySavedHotkey=lambda *a:self.load.append(a),WUI_ApplySavedSlotKey=lambda *a:self.load.append(a))
  return vm
 def test_click_only_sends_own_reset_request_save_stays_one(self):
  vm=self.client();vm.run('SaveSystem_OnSaveButton');self.assertEqual(self.sync,[('WOS2SAVE','R')]);self.assertFalse(self.reset);vm.g['BlzGetTriggerFrame']=lambda:'save';vm.run('SaveSystem_OnSaveButton');self.assertEqual(self.sync[-1],('WOS2SAVE','1'))
 def test_nonlocal_click_cannot_send(self):
  vm=self.client(1,0);vm.run('SaveSystem_OnSaveButton');self.assertFalse(self.sync)
 def test_backend_reset_sender_and_late_saved_keys_cannot_undo(self):
  vm=self.client(1,0);g=vm.g;vm.run('SaveSystem_OnSettingsSync');self.assertEqual(self.reset,[1]);self.assertFalse(self.save);self.assertTrue(g['ss_HotkeysReset'][1]);g['BlzGetTriggerSyncPrefix']=lambda:'WOS2SET';g['BlzGetTriggerSyncData']=lambda:'H,0,X|K,0,Y|';vm.run('SaveSystem_OnSettingsSync');self.assertFalse(self.load)
  g['GetTriggerPlayer']=lambda:0;vm.run('SaveSystem_OnSettingsSync');self.assertEqual(self.load,[(0,0,'X'),(0,0,'Y')])
 def test_malformed_reset_and_observer_ignored(self):
  vm=self.client();g=vm.g
  for data in ['R,1','reset','R|','']:g['BlzGetTriggerSyncData']=lambda d=data:d;vm.run('SaveSystem_OnSettingsSync')
  self.assertFalse(self.reset);g['GetTriggerPlayer']=lambda:10;g['BlzGetTriggerSyncData']=lambda:'R';vm.run('SaveSystem_OnSettingsSync');self.assertFalse(self.reset)
 def test_two_button_creation_identical_skin_one_click_trigger(self):
  vm=self.client();g=vm.g;buttons=[];styles=[];placed=[];events=[];triggers=[];g.update(CreateTrigger=lambda:triggers.append('click') or 'click',WUI_GetRoot=lambda:'root',WUI_TextButton=lambda n,p,t,w,h:buttons.append((n,t,w,h)) or n,WUI_PlaceRight=lambda *a:placed.append(a),WUI_SetButtonTextScale=lambda *a:styles.append(('scale',a)),WUI_SetButtonMinimal=lambda *a:styles.append(('minimal',a)),WUI_RegisterTopControl=lambda *a:styles.append(('top',a)),WUI_TooltipBelowLeft=lambda *_:None,BlzTriggerRegisterFrameEvent=lambda *a:events.append(a),TriggerAddAction=lambda *_:None,FRAMEEVENT_CONTROL_CLICK='click',WUI_TOP_ROW_W=.042025,WUI_TOP_ROW_X3=.0671875,WUI_TOP_ROW_X4=.0216625,WUI_TOP_ROW_TEXT=.66)
  vm.run('SaveSystem_CreateSaveButton');self.assertEqual(triggers,['click']);self.assertEqual([b[1:] for b in buttons],[('Save Keys',.042025,.015),('Reset Keys',.042025,.015)]);self.assertEqual(len(events),2);self.assertEqual([a[1] for a in placed],[.0671875,.0216625]);self.assertEqual(len(styles),6)
if __name__=='__main__':unittest.main()
