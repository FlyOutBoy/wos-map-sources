"""Production callbacks, settings protocol and render counts; no engine emulation."""
import unittest,re
from collections import defaultdict
from pathlib import Path
from test_wos_ui import load_source
import test_wos_ui as ui_fixture
from test_wos_ui_multiplayer import MultiplayerFrames
ROOT=Path(__file__).resolve().parents[1]
class Expansion(unittest.TestCase):
 def mode(self,pid):
  vm=load_source('DefaultArmorChangeStable_Copy.j');calls=[]
  vm.g.update(GetLocalPlayer=lambda:pid,GetTriggerPlayer=lambda:self.actor,I2S=str,ModuloInteger=lambda a,b:a%b,
   WUI_HudModeOf=defaultdict(lambda:2,{0:1,1:3}),WUI_SetHud=lambda s,l:calls.append((s,l)),WUI_SetToggleGlyph=lambda *_:None,
   BlzFrameSetVisible=lambda *_:None,BlzFrameSetEnable=lambda *_:None)
  for i in range(8,18):vm.g['UNITSTAT_WidgetWidth'][i]=.04
  return vm,calls
 def test_independent_modes_120_interleaved_events_same_shift_invocation_count(self):
  a,ac=self.mode(0);b,bc=self.mode(1);expected=[1,3]
  for i in range(120):
   self.actor=i%2;expected[self.actor]=expected[self.actor]%3+1
   for vm in [a,b]:vm.run('UNITSTAT_OnModeClick')
   self.assertEqual(dict(a.g['WUI_HudModeOf']),dict(b.g['WUI_HudModeOf']))
   self.assertEqual((a.g['WUI_HudMode'],b.g['WUI_HudMode']),tuple(expected))
  self.assertEqual(len(ac),120);self.assertEqual(len(bc),120)
 def clients(self):
  fixture=MultiplayerFrames();fixture._testMethodName='runTest'
  return [fixture.client(i) for i in [0,1]]
 def test_panel_preferences_differ_no_handle_lookup_and_return_buttons_survive(self):
  clients=self.clients()
  for f,_,v in clients:
   g=f.vm.g;g['GetTriggerPlayer']=lambda:0;g['BlzGetTriggerFrame']=lambda g=g:g['WUI_MinimapToggle']
   f.vm.run('WUI_OnPanelToggle')
  self.assertTrue(clients[0][0].vm.g['WUI_MinimapHiddenOf'][0]);self.assertTrue(clients[1][0].vm.g['WUI_MinimapHiddenOf'][0])
  for i,(f,_,v) in enumerate(clients):
   g=f.vm.g;self.assertTrue(v[g['WUI_MinimapToggle']]);self.assertEqual(v[g['WUI_MinimapOwner']],i==1)
   g['GetTriggerPlayer']=lambda:1;g['BlzGetTriggerFrame']=lambda g=g:g['WUI_InfoToggle'];f.vm.run('WUI_OnPanelToggle')
   self.assertEqual(v[g['WUI_InfoOwner']],i==0);self.assertTrue(v[g['WUI_InfoToggle']])
   f.vm.run('WUI_ShowTopControls',(False,));self.assertTrue(v[g['WUI_InfoToggle']]);self.assertTrue(v[g['WUI_MinimapToggle']])
   f.vm.run('WUI_ShowTopControls',(True,));self.assertEqual(v[g['WUI_InfoOwner']],i==0);self.assertEqual(v[g['WUI_MinimapOwner']],i==1)
   f.vm.run('WUI_RestoreCompactNative',(g['GetLocalPlayer'](),));self.assertTrue(v.get(g['WUI_Item'][0],True))
 def test_info_toggle_does_not_write_item_visibility_and_inventory_has_persistent_parent(self):
  f=ui_fixture.DeferredUIStartup();f.setUp();f.vm.run('WUI_Bootstrap');g=f.vm.g
  calls=[];g['BlzFrameSetVisible']=lambda frame,on:calls.append((frame,on))
  g['WUI_InfoHiddenOf'][0]=True;f.vm.run('WUI_ApplyPanelPreferences')
  self.assertFalse(any(frame in list(g['WUI_Item'].values()) for frame,on in calls))
  self.assertIn(('create',('TEXT','WOSInventoryTitle','BACKDROP:WOSHUDSurface')),f.calls)
  shop=(ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8-sig')
  self.assertIn('WUI_TextButton("WOSAutoBuyToggle", WUI_GetRoot()',shop)
 def test_ping_badge_parent_matches_info_button_group(self):
  f=ui_fixture.DeferredUIStartup();f.setUp();f.vm.run('WUI_Bootstrap');g=f.vm.g
  g['WUI_KeyCount']=1
  g.update(WUI_RegisterKeyFor=lambda *_:None,Condition=lambda x:x,TriggerAddCondition=lambda *_:None)
  f.vm.run('WUI_RegisterHotkeyEx',(0,'ping-keys','Z','Z',True,'ping-button',g['WUI_Root'],False))
  self.assertIn(('create',('BUTTON','WOSHotkeyBadge',g['WUI_InfoOwner'])),f.calls)
  self.assertEqual(g['WUI_HotkeyKey'][0],'Z');self.assertEqual(g['WUI_HotkeyKey'][15],'Z')
 def test_legacy_flags_defaults_and_roundtrip_per_player(self):
  vm=load_source('WOSUI.j');vm.g.update(I2S=str,ModuloInteger=lambda a,b:a%b)
  self.assertEqual(vm.run('WUI_SettingsUIRecord',(0,)),'U,0|')
  for flags in range(4):
   vm.run('WUI_ApplySettingsUIRecord',(1,flags));self.assertEqual(vm.run('WUI_SettingsUIRecord',(1,)),'U,'+str(flags)+'|')
   self.assertEqual(vm.run('WUI_SettingsUIRecord',(0,)),'U,0|')
  before=vm.run('WUI_SettingsUIRecord',(1,));vm.run('WUI_ApplySettingsUIRecord',(1,99));self.assertEqual(vm.run('WUI_SettingsUIRecord',(1,)),before)
 def test_late_load_does_not_replace_clicked_preferences(self):
  vm=load_source('WOSUI.j');vm.g.update(I2S=str,ModuloInteger=lambda a,b:a%b)
  vm.g['WUI_MinimapTouched'][0]=True;vm.g['WUI_MinimapHiddenOf'][0]=True
  vm.run('WUI_ApplySettingsUIRecord',(0,2));self.assertEqual(vm.run('WUI_SettingsUIRecord',(0,)),'U,3|')
 def settings(self,buffer):
  vm=load_source('SaveLoad.j');self.sent=[];writes=[]
  vm.g.update(GetPlayerId=lambda p:p,GetLocalPlayer=lambda:0,IsGamePlayerSlot=lambda i:True,GetExpiredTimer=lambda:None,
   BlzGetAbilityTooltip=lambda *_:'original',BlzSetAbilityTooltip=lambda *_:None,SAVE_ABILITY=123,SAVE_SETTINGS_FORMAT='SSET|',SAVE_SETTINGS_SYNC='settings',
   SaveSystem_ChunkRead=lambda _:buffer,SaveSystem_SettingsFilePath=lambda _:'profile',LocalMp3Player_SetCurrent=lambda *_:None,S2I=int,
   BlzSendSyncData=lambda channel,data:self.sent.append(data),DisplayTimedTextToPlayer=lambda *_:None,
   SaveSystem_WriteSettingsFile=lambda:writes.append('write'),ss_SettingsLastPacket='',ss_SettingsReadReady=False)
  return vm,writes
 def test_long_settings_packets_preserve_whole_records(self):
  records=['H,'+str(i)+','+'A'*35+'|' for i in range(12)]
  vm,_=self.settings('SSET|'+''.join(records)+'S,3|U,2|V,0|');vm.run('SaveSystem_LoadSettings')
  self.assertTrue(all(len(x)<=250 for x in self.sent));self.assertEqual(''.join(self.sent),''.join(records)+'S,3|U,2|V,0|')
  self.assertFalse(vm.g['ss_SettingsReadReady']);self.assertEqual(vm.g['ss_SettingsLastPacket'],self.sent[-1]);self.assertEqual(vm.g['WUI_HudModeOf'][0],2)
 def test_invalid_load_does_not_overwrite_existing_profile_automatically(self):
  vm,writes=self.settings('old-unreadable-data');vm.g.update(ss_SettingsReadReady=False,ss_SettingsWritten=False)
  vm.run('SaveSystem_LoadSettings');vm.run('SaveSystem_WriteSettings');self.assertEqual(writes,[]);self.assertEqual(self.sent,[])
 def test_ui_sync_applies_only_sender_and_mode_click_wins_over_late_load(self):
  vm,_=self.settings('');applied=[]
  vm.g.update(GetTriggerPlayer=lambda:1,BlzGetTriggerSyncData=lambda:'S,3|U,2|V,0|',Player=lambda i:i,
   ExecuteFunc=lambda name:applied.append(name),WUI_ApplyPanelPreferences=lambda:None,WUI_VoiceOff=defaultdict(bool),
   WUI_ApplySettingsUIRecord=lambda pid,flags:applied.append((pid,flags)))
  vm.run('SaveSystem_OnSettingsSync');self.assertEqual(vm.g['WUI_HudModeOf'][1],3);self.assertEqual(vm.g['WUI_HudModeOf'][0],2)
  vm.g['WUI_ModeTouched'][1]=True;vm.g['WUI_HudModeOf'][1]=1;vm.run('SaveSystem_OnSettingsSync');self.assertEqual(vm.g['WUI_HudModeOf'][1],1)
 def test_automatic_save_requires_local_last_packet_ack_not_just_read(self):
  vm,writes=self.settings('SSET|S,3|U,2|V,0|');vm.g['ss_SettingsWritten']=False
  vm.run('SaveSystem_LoadSettings');vm.run('SaveSystem_WriteSettings');self.assertEqual(writes,[])
  vm.g.update(GetTriggerPlayer=lambda:0,BlzGetTriggerSyncData=lambda:self.sent[-1],WUI_VoiceOff=defaultdict(bool),
   WUI_ApplySettingsUIRecord=lambda *_:None,ExecuteFunc=lambda *_:None,WUI_ApplyPanelPreferences=lambda:None)
  vm.run('SaveSystem_OnSettingsSync');self.assertTrue(vm.g['ss_SettingsReadReady'])
  vm.run('SaveSystem_WriteSettings');self.assertEqual(writes,['write'])
 def test_explicit_manual_save_enables_later_automatic_updates_of_new_profile(self):
  vm,writes=self.settings('');timers=[]
  vm.g.update(GetTriggerPlayer=lambda:0,CreateTimer=lambda:'existing-save-cooldown',TimerStart=lambda *args:timers.append(args),
   BlzFrameSetEnable=lambda *_:None,WUI_SetButtonCaption=lambda *_:None,ss_SettingsWritten=False)
  vm.run('SaveSystem_OnSaveButton');self.assertTrue(vm.g['ss_SettingsReadReady']);self.assertEqual(writes,['write'])
  vm.run('SaveSystem_WriteSettings');self.assertEqual(writes,['write','write']);self.assertEqual(len(timers),1)
 def test_render_resistances_once_each_and_damage_combat_unchanged(self):
  source=(ROOT/'triggers/WOS_Start/DefaultArmorChangeStable_Copy.j').read_text(encoding='utf-8-sig')
  body=re.search(r'(?ms)^private function UNITSTAT_Render.*?^endfunction',source)[0]
  self.assertEqual(body.count('GetPhysRes(selected)'),1);self.assertEqual(body.count('GetMagRes(selected)'),1)
  self.assertIn('UNITSTAT_Pct(physRes)',body);self.assertIn('R2SW(physRes, 0, 2)',body);self.assertIn('Invul',body)
  s=(ROOT/'triggers/Systems/Systems1.j').read_text(encoding='utf-8-sig');self.assertNotIn('WOS_Probe',s)
  self.assertIn('GearDamageRun(c, td, DamageCheckModifiers(c, td, dmg, typedmg), typedmg, 1)',s)
 def test_actual_render_calls_two_resistance_getters_in_normal_and_invul_cases(self):
  source=(ROOT/'triggers/WOS_Start/DefaultArmorChangeStable_Copy.j').read_text(encoding='utf-8-sig')
  body=re.search(r'(?ms)^private function UNITSTAT_Render.*?^endfunction',source)[0]
  for invul in [False,True]:
   vm=load_source('DefaultArmorChangeStable_Copy.j');counts={'phys':0,'mag':0};texts={}
   for name in set(re.findall(r'(\w+)\(',body)):vm.g[name]=lambda *_:0
   for name in set(re.findall(r'\b(?:UNIT_\w+|gg_\w+)\b',body)):vm.g[name]=name
   def phys(*_):counts['phys']+=1;return 17.25
   def mag(*_):counts['mag']+=1;return 32.75
   vm.g.update(GetPhysRes=phys,GetMagRes=mag,Player=lambda i:i,IsPlayerAlly=lambda *_:True,IsUnitType=lambda *_:True,IsHeroUnitId=lambda *_:True,
    GetUnitTypeId=lambda _:1,GetUnitAbilityLevel=lambda *_:int(invul),CheckCoordsInRect=lambda *_:False,UNITSTAT_EngineDamage=None,UNITSTAT_Hover=-1,UNITSTAT_LastSelected=None,UNITSTAT_LastType=0,Hero=defaultdict(lambda:None),
    GetUnitName=lambda _:'hero',BlzGetAbilityIcon=lambda _:'icon',DamageCheckModifiers=lambda *_:100.,I2S=str,R2I=int,I2R=float,RMaxBJ=max,
    R2SW=lambda val,*_:str(val),UNITSTAT_StatText=lambda *_:'stats',UNITSTAT_AttributeHelp=lambda *_:'help',
    UNITSTAT_Signed=lambda _:'0%',UNITSTAT_Pct=lambda val:str(val)+'%',WUI_SetText=lambda frame,text:texts.update({frame:text}))
   vm.run('UNITSTAT_Render',(1,0));self.assertEqual(counts,{'phys':1,'mag':1})
   self.assertIn('17.25',vm.g['UNITSTAT_Help'][1]);self.assertIn('32.75',vm.g['UNITSTAT_Help'][2])
   self.assertIn('Invul' if invul else '17.25',texts[vm.g['UNITSTAT_Value'][1]])
 def test_restore_toggle_hitbox_clears_toolbar_at_all_stats_shifts(self):
  vm=load_source('WOSUI.j');points=[]
  vm.g.update(I2R=float,WUI_PlaceShift=lambda frame,x,y,w,h:points.append((x,y,w,h)))
  vm.run('WUI_PlaceToolbar',('mute',2,1));x,y,w,h=points[0]
  for shift in [-.044,0.,.044]:
   # Top of the new toggle stays below bottom of the existing lower row.
   self.assertGreater(.8290+shift-.010/2,x+shift+w/2)
   self.assertLess(.0055+.010/2,.0330)  # Both upper-row badge bottoms remain above it.
   self.assertLess(.8290+shift+.010/2+.0015,.880)  # Includes border at 16:10.
   self.assertGreater(.0055-.010/2,0.)
 def test_interactive_group_ancestors_enabled_chrome_noninteractive_and_no_fullscreen_hitbox(self):
  f=ui_fixture.DeferredUIStartup();f.setUp();f.vm.run('WUI_Bootstrap')
  for n in ['Info','Minimap']:
   frame='BACKDROP:WOS'+n+'Owner'
   self.assertIn(('BlzFrameSetEnable',(frame,True)),f.calls)
   self.assertIn(('BlzFrameSetSize',(frame,.0001,.0001)),f.calls)
  self.assertIn(('BlzFrameSetEnable',('BACKDROP:WOSInfoChrome',False)),f.calls)
 def test_terrain_is_native_index_one_no_custom_action_and_old_assets_identical(self):
  s=(ROOT/'triggers/WOS_Start/WOSUI.j').read_text(encoding='utf-8-sig')
  self.assertIn('set WUI_Terrain = WUI_MinimapButton[1]',s)
  self.assertNotRegex(s,r'BlzTriggerRegisterFrameEvent\([^\n]*WUI_Terrain')
  for suffix in ['tl','tr','bl','br','top','bottom','left','right']:
   root=ROOT/'assets/UI/WOS';self.assertEqual((root/f'ornate-{suffix}.tga').read_bytes(),(root/f'minimap-frame-{suffix}.tga').read_bytes())
if __name__=='__main__':unittest.main()
