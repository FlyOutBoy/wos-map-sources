"""Execute candidate JASS with mocked natives; does not emulate Warcraft UI/network."""
import re,unittest
from collections import defaultdict
import test_quickbuy_fix1 as prior
import test_wos_ui as ui

class Fix2(prior.Fix1):
 def setUp(self):
  super().setUp();self.sound=[];self.saved=[];self.notice=[]
  self.vm.g.update(gg_snd_ReceiveGold='purchase',StartSoundForPlayerBJ=lambda *a:self.sound.append(a),EVENT_PLAYER_MOUSE_DOWN='down',EVENT_PLAYER_MOUSE_UP='up',EVENT_PLAYER_MOUSE_MOVE='move',BlzGetTriggerPlayerMouseButton=lambda:'right',MOUSE_BUTTON_TYPE_RIGHT='right',QB_SaveLocal=lambda:self.saved.append('write'),DisplayTimedTextToPlayer=lambda *a:self.notice.append(a),Shop_Active=defaultdict(bool))
 def test_single_component_delete_stays_deleted_and_blocks_its_parent(self):
  self.goals([5]);self.sync('D','0');self.assertEqual(self.steps(),[2,3,4,5])
  for _ in range(3):self.vm.run('QB_Tick',(0,self.units[0]))
  self.assertEqual(self.adds,[(0,2),(0,4)]);self.assertEqual(self.steps(),[3,5])
  self.assertEqual(self.vm.g['QB_Status'][0],4)
  self.vm.run('QB_Rebuild',(0,));self.assertEqual(self.steps(),[3,5]);self.assertNotIn(1,self.steps())
 def test_delete_intermediate_keeps_components_and_other_group_order(self):
  self.goals([5,6]);self.sync('D','2')
  for _ in range(4):self.vm.run('QB_Tick',(0,self.units[0]))
  self.assertEqual(self.adds,[(0,1),(0,2),(0,4),(0,6)]);self.assertEqual(self.steps(),[5])
 def test_exclusion_moves_with_group_and_survives_other_target_completion(self):
  self.goals([5,6]);self.sync('D','0');self.sync('M','0,1');self.assertEqual(self.steps(),[3,2,4,5,6])
  self.units[0]['inv'][0]=6;self.vm.run('QB_Rebuild',(0,));self.assertEqual(self.steps(),[3,2,4,5]);self.assertNotIn(1,self.steps())
  self.assertTrue(self.vm.g['QB_StepMissing'][0])
 def test_group_reorder_preserves_dependency_order(self):
  self.goals([3,6]);self.sync('M','0,1');self.assertEqual(self.steps(),[2,1,3,6]);self.sync('M','1,0');self.assertEqual(self.steps(),[1,2,3,6])
 def test_horizontal_right_drag_ignores_y_and_commits_once(self):
  self.goals([1,2,6]);g=self.vm.g;coords=[.6895,.312]
  g.update(QB_Width=.147,QB_Left=.665,QB_Size=.038,QB_Columns=3,QB_Page=0,QB_DragFrom=-1,RAbsBJ=abs,I2R=lambda n:float(int(n)),R2I=int,ModuloInteger=lambda a,b:a%b,Shop_Active={0:True},WUI_TopShown=lambda:True,BlzGetMouseScreenPosX=lambda:coords[0],BlzGetMouseScreenPosY=lambda:coords[1],BlzPixelToFrameX=lambda x:x,BlzPixelToFrameY=lambda y:y,GetTriggerEventId=lambda:'down',EVENT_PLAYER_UNIT_PICKUP_ITEM='pickup',EVENT_PLAYER_UNIT_DROP_ITEM='drop',QB_DragRender=lambda:None)
  self.vm.run('QB_OnMouse');self.assertEqual(g['QB_DragFrom'],0);self.assertEqual(len(self.messages),1)
  g['GetTriggerEventId']=lambda:'move';coords[:]=[.7875,999];self.vm.run('QB_OnMouse');self.assertEqual(len(self.messages),1)
  g['GetTriggerEventId']=lambda:'up';self.vm.run('QB_OnMouse');self.assertEqual(g['QB_DragFrom'],-1);self.assertTrue(self.messages[-1][1].endswith('0,2'));self.assertEqual(len(self.messages),2)
 def test_left_drag_and_close_cancel_do_not_change_gameplay(self):
  self.goals([1,2]);g=self.vm.g;g.update(QB_DragFrom=1,QB_DragVersion=g['QB_Version'][0],QB_DragRender=lambda:None,WUI_TopClosePlayer=0)
  self.vm.run('QB_CloseTop');self.assertEqual(g['QB_DragFrom'],-1);self.assertEqual(self.steps(),[1,2]);self.assertTrue(self.messages[-1][1].endswith(',0'))
 def test_layout_single_inventory_row_full_tabs_close_bounds_and_15_slots(self):
  g=self.vm.g;source=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8');placed={};hidden={};art={}
  for is_array,name in re.findall(r'(?m)^    framehandle (array )?(\w+)\s*(?:=.*)?$',source):g[name]={i:(name,i) for i in range(70)} if is_array else name
  g.update(WUI_Place=lambda fr,x,y,a,b:placed.update({fr:(x,y,a,b)}),ShopPlacePrice=lambda *_:None,BlzFrameSetScale=lambda *_:None,BlzFrameSetAbsPoint=lambda *_:None,BlzFrameSetSize=lambda *_:None,BlzFrameClearAllPoints=lambda *_:None,BlzFrameSetAllPoints=lambda a,b:art.update({a:b}),BlzFrameSetVisible=lambda fr,v:hidden.update({fr:v}),I2R=lambda n:float(int(n)),R2I=int,RAbsBJ=abs,RMinBJ=min,RMaxBJ=max,ModuloInteger=lambda a,b:a%b,QB_DragFrom=-1)
  for aspect in [5/4,4/3,16/9,21/9]:
   g['WUI_ScreenRight']=lambda a=aspect:.4+.3*a;g['QB_Right']=0;placed.clear();self.vm.run('QB_Layout')
   items=[placed['FRAME_ShopItemInventorySlot',i] for i in range(6)]
   self.assertEqual(len({p[0] for p in items}),3);self.assertEqual(len({p[1] for p in items}),2)
   for i,item in enumerate(items):
    self.assertEqual(art['FRAME_ShopItemInventorySlotBack',i],('FRAME_ShopItemInventorySlot',i));self.assertFalse(hidden['FRAME_ShopInventoryItemName',i])
    self.assertGreaterEqual(item[0]-item[2]/2,g['QB_Left']);self.assertLessEqual(item[0]+item[2]/2,g['QB_Right'])
   tabs=[placed['FRAME_ShopSection',i] for i in range(8)];close=placed['FRAME_ShopClose']
   for i in range(7):self.assertAlmostEqual(tabs[i][0]+tabs[i][2]/2,tabs[i+1][0]-tabs[i+1][2]/2)
   self.assertLess(tabs[-1][0]+tabs[-1][2]/2,close[0]-close[2]/2);self.assertAlmostEqual(close[0]+close[2]/2,g['QB_Right']-.004)
   for i in range(15):
    x,y,a,b=placed['QB_Slot',i];self.assertGreaterEqual(y-b/2,.174-.00001);self.assertLessEqual(y+b/2,.33001)
   panel=placed['QB_Panel'];self.assertAlmostEqual(panel[1]-panel[3]/2,.149)
   controls=[items[i] for i in range(6)]+[placed['FRAME_ShopItemInventorySlot',6],placed['FRAME_ShopItemInventorySlot',7],placed['FRAME_FastBuyToggle'],placed['FRAME_FastSellToggle'],placed['QB_SaveBuildButton']]
   for i,a in enumerate(controls):
    for z in controls[i+1:]:self.assertTrue(abs(a[0]-z[0])>=(a[2]+z[2])/2 or abs(a[1]-z[1])>=(a[3]+z[3])/2,(aspect,a,z))
   placed.clear();self.vm.run('QB_Layout');self.assertFalse(placed)
 def test_move_one_step_survives_rebuild_and_purchase(self):
  self.goals([5,6]);self.sync('M','5,0');self.assertEqual(self.steps(),[6,1,2,3,4,5])
  self.vm.run('QB_Rebuild',(0,));self.assertEqual(self.steps(),[6,1,2,3,4,5])
  self.vm.run('QB_Tick',(0,self.units[0]));self.assertEqual(self.adds,[(0,6)]);self.assertEqual(self.steps(),[1,2,3,4,5])
 def test_recipe_dragged_ahead_waits_for_components_without_recursive_rebuy(self):
  self.goals([3]);self.sync('M','2,0');self.assertEqual(self.steps(),[3,1,2])
  for _ in range(3):self.vm.run('QB_Tick',(0,self.units[0]))
  self.assertEqual(self.adds,[(0,1),(0,2),(0,3)]);self.assertEqual(self.steps(),[])
 def test_minus_after_reorder_deletes_correct_token_not_neighbor(self):
  self.goals([5]);self.sync('M','3,0');self.assertEqual(self.steps(),[4,1,2,3,5]);self.sync('D','1')
  self.assertEqual(self.steps(),[4,2,3,5]);self.vm.run('QB_Rebuild',(0,));self.assertEqual(self.steps(),[4,2,3,5])
 def test_same_rawcodes_different_groups_have_distinct_tokens(self):
  self.goals([3,5]);g=self.vm.g;tokens=[g['QB_Token'][i] for i in range(len(self.steps()))];self.assertEqual(len(tokens),len(set(tokens)))
 def test_ready_second_group_runs_while_first_waits(self):
  self.goals([3,6]);self.sync('D','0')
  for _ in range(3):self.vm.run('QB_Tick',(0,self.units[0]))
  self.assertEqual(self.adds,[(0,2),(0,6)]);self.assertEqual(self.steps(),[3]);self.assertEqual(self.vm.g['QB_Status'][0],4)
 def test_purchase_sound_only_after_confirmed_purchase(self):
  self.goals([6]);self.gold[0]=0;self.vm.run('QB_Tick',(0,self.units[0]));self.assertFalse(self.sound)
  self.gold[0]=100;self.vm.run('QB_Tick',(0,self.units[0]));self.assertEqual(self.sound,[(0,'sound')])
 def test_save_build_uses_real_inventory_slot_order_keeps_queue(self):
  self.goals([5]);self.units[0]['inv']=[6,0,2,1,0,4];before=self.steps();self.sync('S','0')
  g=self.vm.g;self.assertEqual([g['QB_Preset'][i] for i in range(6)],[6,2,1,4,0,0]);self.assertEqual([g['ItemsPage0_ID'][i] for i in range(6)],[6,2,1,4,0,0]);self.assertEqual(before,self.steps());self.assertEqual(self.saved,['write'])
 def test_empty_build_does_not_overwrite_saved_file_or_recommended(self):
  self.goals([5]);self.sync('S','0');self.assertFalse(self.saved);self.assertEqual(self.vm.g['QB_Preset'][0],5);self.assertFalse(self.vm.g['QB_HasRecommended'][0])
 def test_saved_record_matches_inventory_and_load_updates_recommended(self):
  self.goals([5]);self.units[0]['inv']=[6,0,2,1,0,4];self.sync('S','0')
  self.assertEqual(self.vm.run('QB_TemplateRecord',(123,)),'123,6,2,1,4,0,0')
  self.units[0]['inv']=[0]*6;self.vm.run('QB_OnHero',(0,123));self.sync('L','123,6,2,1,4,0,0')
  self.assertEqual([self.vm.g['ItemsPage0_ID'][i] for i in range(6)],[6,2,1,4,0,0])
 def test_invalid_build_file_preserved_by_explicit_save(self):
  self.units[0]['inv']=[6,0,0,0,0,0];g=self.vm.g;g['QB_LocalReady']=False
  g['QB_SaveLocal']=lambda:self.vm.run('QB_SaveLocal')
  self.sync('S','0');self.assertFalse(self.saved);self.assertTrue(any('invalid' in a[-1] for a in self.notice))
 def test_save_build_for_other_player_does_not_write_my_file(self):
  self.goals([1],1);self.units[1]['inv']=[2,6,0,0,0,0];self.sync('S','0',p=1)
  self.assertEqual(self.vm.g['ItemsPage0_ID'][35],2);self.assertEqual(self.vm.g['ItemsPage0_ID'][36],6);self.assertFalse(self.saved)
 def test_clear_keeps_saved_build_and_clears_runtime_order(self):
  self.goals([5]);self.sync('M','3,0');self.sync('C','0');g=self.vm.g
  self.assertEqual(self.steps(),[]);self.assertEqual(g['QB_OrderCount'][0],0);self.assertEqual(g['QB_Preset'][0],5)
 def test_no_mouse_move_registration_or_continuous_sampling(self):
  source=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8')
  bootstrap=source.split('function QB_CreateUI takes',1)[1].split('endfunction',1)[0]
  self.assertNotIn('EVENT_PLAYER_MOUSE_MOVE',bootstrap)
  for name in ['QB_RenderLocal','QB_CheckDrag','QB_Tick']:
   body=source.split('function '+name+' takes',1)[1].split('endfunction',1)[0];self.assertNotIn('BlzGetMouseScreenPos',body)

class SaveRequest(unittest.TestCase):
 def test_frame_handler_only_sends_request_no_timer_or_gameplay(self):
  vm=ui.load_source('SaveLoad.j');g=vm.g;sent=[]
  g.update(GetTriggerPlayer=lambda:1,GetLocalPlayer=lambda:1,BlzSendSyncData=lambda *a:sent.append(a))
  vm.run('SaveSystem_OnSaveButton');self.assertEqual(sent,[('WOS2SAVE','1')])
  source=(ui.ROOT/'triggers/WOS_Start/SaveLoad.j').read_text(encoding='utf-8');body=source.split('function SaveSystem_OnSaveButton takes',1)[1].split('endfunction',1)[0]
  for name in ['CreateTimer','TimerStart','ss_SaveButtonBusy','SaveSystem_WriteSettingsFile']:self.assertNotIn(name,body)
 def test_two_clients_create_identical_cooldown_only_owner_writes(self):
  counts=[]
  for local in [0,1]:
   vm=ui.load_source('SaveLoad.j');g=vm.g;creates=[];starts=[];writes=[]
   g.update(GetTriggerPlayer=lambda:1,GetLocalPlayer=lambda n=local:n,BlzGetTriggerSyncData=lambda:'1',BlzGetTriggerSyncPrefix=lambda:'WOS2SAVE',CreateTimer=lambda:creates.append('timer') or 'timer',TimerStart=lambda *a:starts.append(a),SaveSystem_WriteSettingsFile=lambda:writes.append('file'),IsGamePlayerSlot=lambda _:True,BlzFrameSetEnable=lambda *_:None,WUI_SetButtonCaption=lambda *_:None,DisplayTimedTextToPlayer=lambda *_:None)
   vm.run('SaveSystem_OnSettingsSync');vm.run('SaveSystem_OnSettingsSync')
   counts.append((len(creates),len(starts),len(writes)));self.assertTrue(g['ss_SaveButtonBusy'][1])
  self.assertEqual(counts,[(1,1,0),(1,1,1)])
 def test_save_sync_does_not_apply_hotkeys_or_hide_ui(self):
  source=(ui.ROOT/'triggers/WOS_Start/SaveLoad.j').read_text(encoding='utf-8')
  branch=source.split('if BlzGetTriggerSyncPrefix() == "WOS2SAVE"',1)[1].split('    loop',1)[0]
  self.assertIn('return',branch);self.assertNotIn('WUI_ApplySaved',branch)

if __name__=='__main__':unittest.main()
