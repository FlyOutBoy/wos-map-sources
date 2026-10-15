"""Existing settings writer/load/sync JASS with native mocks; not a network test."""
import unittest
from collections import defaultdict
import test_wos_ui as ui
import test_quickbuy_fix6 as shop

class FastSettings(unittest.TestCase):
 def client(self,local=0,sender=0):
  vm=ui.load_source('SaveLoad.j');g=vm.g;self.painted={};self.messages=[];self.records=[];self.header=[];self.flush=[]
  g.update(GetLocalPlayer=lambda:local,GetTriggerPlayer=lambda:sender,GetPlayerId=lambda p:p,Player=lambda p:p,StringLength=len,SubString=lambda s,a,b:s[a:b],I2S=str,S2I=lambda s:int(s) if s.lstrip('-').isdigit() else 0,I2R=lambda n:float(int(n)),R2I=int,IntegerTertiaryOp=lambda c,a,z:a if c else z,ModuloInteger=lambda a,z:a%z,IsGamePlayerSlot=lambda p:0<=p<10,BlzGetTriggerSyncPrefix=lambda:'WOS2SET',BlzGetTriggerSyncData=lambda:'',ShopFastBuy=defaultdict(bool),ShopFastSell=defaultdict(bool),FRAME_FastBuyIcon=None,FRAME_FastSellIcon=None,BlzFrameSetTexture=lambda f,t,*_:self.painted.update({f:t}),BlzSendSyncData=lambda p,s:self.messages.append((p,s)),DisplayTimedTextToPlayer=lambda *_:None,ExecuteFunc=lambda *_:None,WUI_ApplyPanelPreferences=lambda:None,WUI_ApplySavedHotkey=lambda *_:None,WUI_ApplySavedSlotKey=lambda *_:None,WUI_ApplySettingsUIRecord=lambda *_:None,SetCameraFieldForPlayer=lambda *_:None,CAMERA_FIELD_TARGET_DISTANCE='camera',WUI_HudModeOf=defaultdict(lambda:1),WUI_ModeTouched=defaultdict(bool),WUI_VoiceOff=defaultdict(bool),CameraSetup=defaultdict(lambda:1600),WUI_SavedCamera=defaultdict(float),ss_SettingsLastPacket='',ss_SettingsReadReady=False,ss_LocalPayloadPos=0,SAVE_SETTINGS_SYNC='WOS2SET',SAVE_SETTINGS_FORMAT='WOS2SET1|',WUI_SavedSettingsString=lambda _: 'H,1,Z|K,1,Q|',LocalMp3Player_GetCurrent=lambda _:2,WUI_SettingsUIRecord=lambda _:'U,0|',SaveSystem_SettingsFilePath=lambda p:'settings'+str(p)+'.txt',PreloadGenClear=lambda:None,PreloadGenStart=lambda:None,SaveSystem_ChunkBegin=lambda s:self.header.append(s),SaveSystem_ChunkAdd=lambda s:self.records.append(s),SaveSystem_ChunkFlush=lambda s:self.flush.append(s))
  for name in ['CreateTimer','CreateTrigger','CreateGroup','CreateUnit','CreateItem','BlzCreateFrame','BlzCreateFrameByType','BlzGetFrameByName','BlzGetOriginFrame','UnitAddItemById','AddGold']:g[name]=lambda *_,n=name:self.fail('unexpected allocation/gameplay '+n)
  return vm
 def test_writer_all_four_combinations_one_file_no_queue(self):
  for flags in range(4):
   vm=self.client();g=vm.g;g['ShopFastBuy'][0]=bool(flags&1);g['ShopFastSell'][0]=bool(flags&2);vm.run('SaveSystem_WriteSettingsFile');self.assertIn('F,'+str(flags)+'|',self.records);self.assertEqual(self.header,['WOS2SET1|']);self.assertEqual(self.flush,['settings0.txt']);self.assertNotIn('QB_', ''.join(self.records))
 def test_restore_all_combinations_before_ui_exists(self):
  for flags in range(4):
   vm=self.client();g=vm.g;g['BlzGetTriggerSyncData']=lambda f=flags:'F,'+str(f)+'|';vm.run('SaveSystem_OnSettingsSync');self.assertEqual(g['ShopFastBuy'][0],bool(flags&1));self.assertEqual(g['ShopFastSell'][0],bool(flags&2));self.assertFalse(self.painted)
 def test_two_clients_same_owner_flags_only_owner_icons_painted(self):
  for local in [0,1]:
   vm=self.client(local,1);g=vm.g;g['FRAME_FastBuyIcon']='buy';g['FRAME_FastSellIcon']='sell';g['BlzGetTriggerSyncData']=lambda:'F,3|';vm.run('SaveSystem_OnSettingsSync');self.assertTrue(g['ShopFastBuy'][1]);self.assertTrue(g['ShopFastSell'][1]);self.assertFalse(g['ShopFastBuy'][0]);self.assertFalse(g['ShopFastSell'][0])
   if local==1:self.assertEqual(self.painted,{'buy':'UI\\WOS\\fastbuy-on.tga','sell':'UI\\WOS\\fastsell-on.tga'})
   else:self.assertFalse(self.painted)
 def test_off_modes_restore_icons(self):
  vm=self.client();g=vm.g;g['ShopFastBuy'][0]=True;g['ShopFastSell'][0]=True;g.update(FRAME_FastBuyIcon='buy',FRAME_FastSellIcon='sell',BlzGetTriggerSyncData=lambda:'F,0|');vm.run('SaveSystem_OnSettingsSync');self.assertEqual(self.painted,{'buy':'UI\\WOS\\fastbuy-off.tga','sell':'UI\\WOS\\fastsell-off.tga'});self.assertFalse(g['ShopFastBuy'][0]);self.assertFalse(g['ShopFastSell'][0])
 def test_old_settings_without_f_preserve_defaults_and_other_fields(self):
  vm=self.client();g=vm.g;g['BlzGetTriggerSyncData']=lambda:'C,1800|S,2|V,0|U,0|';vm.run('SaveSystem_OnSettingsSync');self.assertFalse(g['ShopFastBuy'][0]);self.assertFalse(g['ShopFastSell'][0]);self.assertEqual(g['CameraSetup'][0],1800);self.assertEqual(g['WUI_HudModeOf'][0],2);self.assertTrue(g['WUI_VoiceOff'][0])
 def test_invalid_flag_record_cannot_change_modes(self):
  for record in ['F,-1|','F,4|','F,|','F,no|','F,03|','F,3,1|']:
   vm=self.client();g=vm.g;g['BlzGetTriggerSyncData']=lambda r=record:r;vm.run('SaveSystem_OnSettingsSync');self.assertFalse(g['ShopFastBuy'][0]);self.assertFalse(g['ShopFastSell'][0]);self.assertFalse(self.painted)
 def test_loader_only_sends_f_through_existing_sync(self):
  vm=self.client();g=vm.g;g.update(GetExpiredTimer=lambda:None,ss_SettingsLoadTimer=None,BlzGetAbilityTooltip=lambda *_:'old',BlzSetAbilityTooltip=lambda *_:None,SAVE_ABILITY=1,SaveSystem_ChunkRead=lambda _:'WOS2SET1|F,3|',LocalMp3Player_SetCurrent=lambda *_:None);vm.run('SaveSystem_LoadSettings');self.assertEqual(self.messages,[('WOS2SET','F,3|')]);self.assertFalse(g['ShopFastBuy'][0]);self.assertFalse(g['ShopFastSell'][0])
  g['BlzGetTriggerSyncData']=lambda:self.messages[0][1];vm.run('SaveSystem_OnSettingsSync');self.assertTrue(g['ShopFastBuy'][0]);self.assertTrue(g['ShopFastSell'][0])
 def test_bounded_packets_keep_f_record_intact(self):
  vm=self.client();g=vm.g;buffer='WOS2SET1|'+'H,1,Z|'*50+'F,3|';g.update(GetExpiredTimer=lambda:None,ss_SettingsLoadTimer=None,BlzGetAbilityTooltip=lambda *_:'old',BlzSetAbilityTooltip=lambda *_:None,SAVE_ABILITY=1,SaveSystem_ChunkRead=lambda _:buffer,LocalMp3Player_SetCurrent=lambda *_:None);vm.run('SaveSystem_LoadSettings');self.assertEqual(''.join(x[1] for x in self.messages),buffer[len('WOS2SET1|'):]);self.assertTrue(all(len(x[1])<=250 for x in self.messages));self.assertIn('F,3|',self.messages[-1][1])
 def test_startup_shop_icons_honour_early_loaded_flags(self):
  h=shop.Fix6('runTest');h.setUp();g=h.vm.g;painted={};created=[];timers=[];g['ShopFastBuy'][0]=True;g['ShopFastSell'][0]=True
  g.update(ShopClock='existing-clock',SHOP_INV_X=.74,CreateTrigger=lambda:'existing-create',BlzCreateFrameByType=lambda typ,name,*_:created.append(name) or name,WUI_Place=lambda *_:None,WUI_Tooltip=lambda *_:None,BlzFrameSetAllPoints=lambda *_:None,BlzFrameSetTexture=lambda f,t,*_:painted.update({f:t}),BlzTriggerRegisterFrameEvent=lambda *_:None,TriggerAddAction=lambda *_:None,FRAMEEVENT_CONTROL_CLICK='click',TimerStart=lambda *a:timers.append(a));h.vm.run('ShopCreateFastToggles');self.assertEqual(len(created),4);self.assertEqual(len(timers),1);self.assertEqual(painted['ShopFastBuyIcon'],'UI\\WOS\\fastbuy-on.tga');self.assertEqual(painted['ShopFastSellIcon'],'UI\\WOS\\fastsell-on.tga')
if __name__=='__main__':unittest.main()
