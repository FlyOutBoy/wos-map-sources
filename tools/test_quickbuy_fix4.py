"""Candidate JASS with native mocks; not engine, filesystem or multiplayer QA."""
import unittest,re
from collections import defaultdict
import test_quickbuy_fix3 as prior
import test_wos_ui as ui

class Fix4(unittest.TestCase):
 def setUp(self):
  h=prior.Fix3('runTest');h.setUp();self.__dict__.update({k:v for k,v in h.__dict__.items() if not k.startswith('_')});g=self.vm.g
  g.update(ReloadItemPage2=lambda *_:None,REC_DragFrom=-1,REC_DragTo=-1,QB_DragTo=-1,FRAMEEVENT_MOUSE_UP='frame-up',FRAMEEVENT_MOUSE_ENTER='enter',FRAMEEVENT_MOUSE_LEAVE='leave',EVENT_PLAYER_UNIT_PICKUP_ITEM='pickup',EVENT_PLAYER_UNIT_DROP_ITEM='drop',BlzFrameSetVisible=lambda *_:None,REC_SYNC='WOSREC1',REC_CAPACITY=28,SHOP_RECOMMENDED_COUNT=6,SHOP_LIST_X=.215,BlzGetTriggerSyncPrefix=lambda:'WOSQB1',GetHandleId=lambda o:o['pid']+1 if isinstance(o,dict) else hash(str(o)),I2R=float,R2I=int,ModuloInteger=lambda a,b:a%b,RAbsBJ=abs,ShopVipOpen=defaultdict(bool),UNITSTAT_GetSelected=lambda p:self.units[p],REC_FileWritable=True,ss_IdentityKeyA={0:10,1:11},ss_IdentityKeyB={0:20,1:21},SaveSystem_EnsureIdentity=lambda _:None,GetObjectName=lambda _: 'Example Hero')
  self.files={};self.filebuffer=[''];self.filewrites=[];self.reads=[]
  g['SaveSystem_ChunkRead']=lambda path:self.reads.append(path) or self.files.get(path,'')
  g['SaveSystem_ChunkBegin']=lambda s:self.filebuffer.__setitem__(0,s)
  g['SaveSystem_ChunkFlush']=lambda path:self.filewrites.append((path,self.filebuffer[0])) or self.files.update({path:self.filebuffer[0]})
  g['PreloadGenClear']=lambda:None;g['PreloadGenStart']=lambda:None
 def goals(self,ids,p=0):
  g=self.vm.g;g['QB_Count'][p]=len(ids)
  for i,id in enumerate(ids):g['QB_Target'][p*6+i]=id
  self.vm.run('QB_Rebuild',(p,))
 def steps(self,p=0):
  g=self.vm.g;return [g['QB_Step'][p*128+i] for i in range(g['QB_StepCount'][p])]
 def costs(self):return [self.vm.g['QB_Cost'][i] for i in range(len(self.steps()))]
 def tick(self,n=1):
  for _ in range(n):self.vm.run('QB_Tick',(0,self.units[0]))
 def sync(self,op,data,p=0,version=None,seq=None,hero=None):
  g=self.vm.g;g['BlzGetTriggerSyncPrefix']=lambda:'WOSQB1';g['GetTriggerPlayer']=lambda:p
  g['BlzGetTriggerSyncData']=lambda:f'{op},{hero or g["QB_Hero"][p]},{g["QB_Version"][p] if version is None else version},{g["QB_Sequence"][p]+1 if seq is None else seq},{data}'
  self.vm.run('QB_OnSync')
 def rec(self,ids,p=0):
  g=self.vm.g;g['REC_Count'][p]=len(ids)
  for i in range(28):g['REC_Item'][p*28+i]=g['REC_Default'][p*28+i]=ids[i] if i<len(ids) else 0
  self.vm.run('REC_Apply',(p,))
 def ritems(self,p=0):
  g=self.vm.g;return [g['REC_Item'][p*28+i] for i in range(g['REC_Count'][p])]
 def rsync(self,op,data,p=0,version=None,seq=None,hero=None):
  g=self.vm.g;g['BlzGetTriggerSyncPrefix']=lambda:'WOSREC1';g['GetTriggerPlayer']=lambda:p
  g['BlzGetTriggerSyncData']=lambda:f'{op},{hero or g["QB_Hero"][p]},{g["REC_Version"][p] if version is None else version},{g["REC_Sequence"][p]+1 if seq is None else seq},{data}'
  if p == 0:g['REC_LocalSequence']=max(g['REC_LocalSequence'],g['REC_Sequence'][p]+1 if seq is None else seq)
  self.vm.run('QB_OnSync')
 def receive(self,p=0):
  g=self.vm.g;messages=self.messages[:];self.messages.clear()
  for prefix,data in messages:
   g['BlzGetTriggerSyncPrefix']=lambda q=prefix:q;g['GetTriggerPlayer']=lambda:p;g['BlzGetTriggerSyncData']=lambda q=data:q;self.vm.run('QB_OnSync')
 def test_recipe_buy_and_advance_one_item_per_tick(self):
  self.goals([5])
  for expected in [1,2,3,4,5]:
   before=len(self.adds);self.tick();self.assertEqual(len(self.adds),before+1);self.assertEqual(self.adds[-1][1],expected)
  self.assertEqual(self.gold[0],2530);self.assertFalse(self.vm.run('QB_Tick',(0,self.units[0])));self.assertFalse(self.filewrites)
 def test_rec_minus_compacts_and_resets_current_autobuy_cursor(self):
  self.rec([1,2,3,4,5,6]);self.vm.g['AutoBuyRecommendedIndex'][0]=4;self.rsync('D','1')
  self.assertEqual(self.ritems(),[1,3,4,5,6]);self.assertEqual([self.vm.g['ItemsPage0_ID'][i] for i in range(7)],[1,3,4,5,6,0,0]);self.assertEqual(self.vm.g['AutoBuyRecommendedIndex'][0],0);self.assertFalse(self.filewrites)
 def test_rec_move_one_step_both_directions_and_reset_default(self):
  self.rec([1,2,3,4]);self.rsync('M','0,3');self.assertEqual(self.ritems(),[2,3,4,1]);self.rsync('M','3,0');self.rsync('D','1');self.rsync('R','0');self.assertEqual(self.ritems(),[1,2,3,4]);self.assertFalse(self.filewrites)
 def test_rec_stale_foreign_hero_replay_and_index_rejected(self):
  self.rec([1,2,3]);old=self.vm.g['REC_Version'][0];self.rsync('D','0');before=self.ritems()
  self.rsync('D','0',version=old);self.rsync('R','0',hero=999);self.rsync('D','9');self.rsync('D','0',seq=1);self.assertEqual(self.ritems(),before)
 def test_two_players_edit_independently(self):
  self.rec([1,2,3]);self.rec([4,5,6],1);self.rsync('D','0');self.rsync('M','2,0',p=1);self.assertEqual(self.ritems(),[2,3]);self.assertEqual(self.ritems(1),[6,4,5])
 def test_quickbuy_add_remove_clear_never_writes_recommended(self):
  self.rec([1,2,3]);self.goals([5]);self.sync('D','0');self.sync('A','6');self.sync('C','0');self.assertEqual(self.ritems(),[1,2,3]);self.assertFalse(self.filewrites);self.assertFalse(self.reads)
 def test_add_first_six_recommendations_appends_preserving_existing_queue(self):
  self.rec([1,2,3,4,5,6,1]);self.goals([6]);self.rsync('Q','0');g=self.vm.g
  self.assertEqual([g['QB_Target'][i] for i in range(6)],[6,1,2,3,4,5]);self.assertEqual(g['QB_Count'][0],6);self.assertEqual(self.ritems(),[1,2,3,4,5,6,1]);self.assertFalse(self.filewrites)
 def test_rec_save_current_list_not_actual_inventory_or_queue(self):
  self.rec([5,6]);self.units[0]['inv'][0]=1;self.goals([3]);self.rsync('S','0');self.assertEqual(len(self.filewrites),1)
  path,record=self.filewrites[0];self.assertTrue(path.startswith('WosHeroes\\Example_Hero_123_10_20'));self.assertTrue(record.startswith('WOSR1|123|5,6,0,'));self.assertEqual(self.steps(),[2,3])
 def test_rec_foreign_owner_save_does_not_write_local_file(self):
  self.rec([4,5],1);self.rsync('S','0',p=1);self.assertFalse(self.filewrites)
 def test_rec_load_chunked_atomic_no_automatic_queue_and_no_game_handles(self):
  self.rec([1,2,3]);self.rsync('S','0');self.rsync('D','0');self.vm.run('REC_LoadLocal',(0,False));self.assertEqual(len(self.messages),4);self.assertTrue(all(len(m[1])<=220 for m in self.messages))
  g=self.vm.g;messages=self.messages[:];self.messages.clear()
  for i,(prefix,data) in enumerate(messages):
   g['BlzGetTriggerSyncPrefix']=lambda:prefix;g['GetTriggerPlayer']=lambda:0;g['BlzGetTriggerSyncData']=lambda:data;self.vm.run('QB_OnSync');self.assertEqual(self.ritems(),[2,3] if i<3 else [1,2,3])
  self.assertEqual(self.steps(),[]);self.assertFalse(g['QB_Awaiting'][0])
 def test_missing_initial_file_loads_defaults_but_manual_missing_keeps_edits(self):
  self.rec([1,2,3]);self.rsync('D','0');self.vm.run('REC_LoadLocal',(0,False));self.assertFalse(self.messages);self.assertEqual(self.ritems(),[2,3])
  self.vm.run('REC_LoadLocal',(0,True));self.receive();self.assertEqual(self.ritems(),[1,2,3]);self.assertEqual(self.steps(),[])
 def test_invalid_wrong_hero_truncated_extra_fields_block_overwrite(self):
  self.rec([1,2]);path=self.vm.run('REC_FilePath',(0,123))
  for record in ['bad','WOSR1|124|'+','.join(['0']*28)+'|','WOSR1|123|1,2|','WOSR1|123|'+','.join(['0']*29)+'|']:
   self.files[path]=record;self.messages.clear();self.vm.run('REC_LoadLocal',(0,False));self.receive();self.assertEqual(self.ritems(),[1,2]);self.filewrites.clear();self.rsync('S','0');self.assertFalse(self.filewrites)
 def test_invalid_load_packet_never_partially_applies(self):
  self.rec([1,2]);self.rsync('L','0,2,3,0,0,0,0,0');self.rsync('L','1,999,0,0,0,0,0,0');self.assertEqual(self.ritems(),[1,2]);self.assertEqual(self.vm.g['REC_LoadMask'][0],0)
 def test_qb_version_does_not_interrupt_rec_load_protocol(self):
  self.rec([1,2]);self.vm.run('REC_LoadLocal',(0,True));self.vm.g['QB_Version'][0]+=100;self.receive();self.assertEqual(self.ritems(),[1,2]);self.assertEqual(self.vm.g['REC_LoadMask'][0],0)
 def test_path_sanitizes_names_and_separates_identity_and_original_hero(self):
  g=self.vm.g;g['GetObjectName']=lambda _: '..\\bad/name:"*?';p=self.vm.run('REC_FilePath',(0,123));self.assertEqual(p.count('\\'),1);self.assertNotIn('..',p);self.assertNotIn('"',p);self.assertNotEqual(p,self.vm.run('REC_FilePath',(1,123)));self.assertNotEqual(p,self.vm.run('REC_FilePath',(0,124)))
 def test_actual_chunk_codec_roundtrip_restores_tooltip_carriers(self):
  import test_saveload as save
  runtime=save.CareerRuntime();g=self.vm.g
  def preloader(path):
   for code,text in re.findall(r"call BlzSetAbilityTooltip\(('?[A-Za-z0-9]+'?),\"([^\"]*)\",0\)",runtime.disk.get(path,'')):
    raw=int.from_bytes(code.strip("'").encode(),'big') if code.startswith("'") else int(code);runtime.tooltips[raw,0]=text
  runtime.vm.g['Preloader']=preloader
  g.update(SaveSystem_ChunkRead=lambda path:runtime.run('SaveSystem_ChunkRead',path),SaveSystem_ChunkBegin=lambda text:runtime.run('SaveSystem_ChunkBegin',text),SaveSystem_ChunkFlush=lambda path:runtime.run('SaveSystem_ChunkFlush',path),PreloadGenClear=runtime.vm.g['PreloadGenClear'],PreloadGenStart=runtime.vm.g['PreloadGenStart'])
  self.rec([1,2,3,4,5,6]*4+[1,2,3,4]);self.rsync('S','0');self.assertEqual(len([w for w in runtime.writes if not re.search(r'_p\d+\.txt$',w)]),1);before=dict(runtime.tooltips);self.rsync('D','0');self.vm.run('REC_LoadLocal',(0,False));self.receive();self.assertEqual(self.ritems(),[1,2,3,4,5,6]*4+[1,2,3,4]);self.assertEqual(before,runtime.tooltips)
 def test_recommended_controls_only_on_recommended_and_last_row_restored_elsewhere(self):
  self.rec([1,2,3]);g=self.vm.g;v={('item',i):True for i in range(35)};v.update({('minus',i):False for i in range(28)});g.update(BlzFrameIsVisible=lambda f:v.get(f,False),BlzFrameSetVisible=lambda f,s:v.update({f:s}),BlzFrameSetEnable=lambda *_:None)
  g['REC_Action']={i:('action',i) for i in range(4)};g['REC_Remove']={i:('minus',i) for i in range(28)};g['FRAME_ShopItem']={i:('item',i) for i in range(35)}
  self.vm.run('REC_Render');self.assertTrue(v['action',0]);self.assertTrue(v['minus',2]);self.assertFalse(v['minus',3]);self.assertFalse(v['item',28]);self.assertTrue(v['item',27])
  g['ItemsFrameCurrentPage_ID'][0]=1;self.vm.run('REC_Render');self.assertFalse(v['action',0]);self.assertFalse(v['minus',0]);self.assertTrue(v['item',28]);g['ItemsFrameCurrentPage_ID'][0]=0;g['ShopSearchActive'][0]=True;self.vm.run('REC_Render');self.assertFalse(v['action',0]);self.assertTrue(v['item',28])
 def test_hero_defaults_do_not_leak_previous_edited_extra_rows(self):
  g=self.vm.g;g['ItemsPage0_ID'][0]=1;g['ItemsPage0_ID'][1]=2;g['ItemsPage0_ID'][7]=6;self.vm.run('REC_InitHero',(0,));self.assertEqual(self.ritems(),[1,2]);self.assertEqual(g['REC_Default'][7],0);self.receive();self.assertEqual(self.steps(),[])
 def test_delete_during_hold_cancels_drag_before_minus_packet(self):
  self.goals([5]);g=self.vm.g;g.update(QB_DragFrom=1,QB_DragTo=2,QB_DragRender=lambda:None,GetHandleId=lambda _:77,BlzGetTriggerFrame=lambda:'minus',BlzGetTriggerFrameEvent=lambda:'click',FRAMEEVENT_CONTROL_CLICK='click',BlzFrameSetFocus=lambda *_:None)
  g['QB_Frames'][77,0]=200;self.vm.run('QB_ButtonEvent');self.assertEqual(g['QB_DragFrom'],-1);self.assertEqual([m[1].split(',')[0] for m in self.messages],['U','D']);self.receive();self.assertEqual(self.steps(),[2,3,4,5])
 def test_frame_leave_starts_right_drag_without_player_mouse_down(self):
  self.goals([1,2,6]);g=self.vm.g;g.update(GetHandleId=lambda _:77,BlzGetTriggerFrame=lambda:'item',BlzGetTriggerFrameEvent=lambda:'leave',BlzIsMouseButtonPressed=lambda _:True,MOUSE_BUTTON_TYPE_RIGHT='right',WUI_TopShown=lambda:True,QB_Left=.665,QB_Width=.245,QB_Columns=5,QB_Size=.036,QB_Page=0,QB_ViewCount=15,BlzPixelToFrameX=lambda x:x,BlzGetMouseScreenPosX=lambda:.7875,QB_DragRender=lambda:None)
  g['Shop_Active'][0]=True;g['QB_Frames'][77,0]=500;self.vm.run('QB_ButtonEvent');self.assertEqual(g['QB_DragFrom'],0);self.assertEqual(g['QB_DragTo'],2);self.assertEqual(self.messages[0][1].split(',')[0],'B')
  g['BlzIsMouseButtonPressed']=lambda _:False;self.vm.run('QB_CheckDrag');self.assertEqual(g['QB_DragFrom'],-1);self.assertTrue(self.messages[-1][1].endswith('0,2'));self.receive();self.assertEqual(self.steps(),[2,6,1])
 def test_recommended_frame_leave_starts_drag_without_frame_mouse_down(self):
  self.rec([1,2,3]);g=self.vm.g;g.update(GetHandleId=lambda _:77,BlzGetTriggerFrame=lambda:'rec-item',BlzGetTriggerFrameEvent=lambda:'leave',BlzIsMouseButtonPressed=lambda _:True,MOUSE_BUTTON_TYPE_RIGHT='right',WUI_TopShown=lambda:True,BlzPixelToFrameX=lambda x:x,BlzGetMouseScreenPosX=lambda:.166,QB_DragRender=lambda:None)
  g['Shop_Active'][0]=True;g['QB_Frames'][77,1]=1;self.vm.run('QB_ButtonEvent');self.assertEqual(g['REC_DragFrom'],0);self.assertEqual(g['REC_DragTo'],2)
  g['BlzIsMouseButtonPressed']=lambda _:False;self.vm.run('QB_CheckDrag');self.receive();self.assertEqual(self.ritems(),[2,3,1]);self.assertEqual(self.adds,[])
 def test_idle_drag_check_never_samples_mouse_or_creates_handles(self):
  def forbid(*_):raise AssertionError('idle mouse sampling')
  self.vm.g.update(BlzIsMouseButtonPressed=forbid,BlzGetMouseScreenPosX=forbid,BlzGetMouseScreenPosY=forbid);self.vm.run('QB_CheckDrag')
 def test_28_item_profile_roundtrip_compacts_holes(self):
  self.rec([1,2,3,4,5,6]*4+[1,2,3,4]);self.rsync('S','0');self.rsync('D','0');self.vm.run('REC_LoadLocal',(0,False));self.receive();self.assertEqual(self.ritems(),[1,2,3,4,5,6]*4+[1,2,3,4])
 def test_autobuy_uses_new_current_list_and_empty_tail_finishes(self):
  g=self.vm.g;self.rec([6,1]);g.update(SHOP_RECOMMENDED_COUNT=6,BuyAuto=lambda u,id:g['UnitAddItemById'](u,id))
  self.vm.run('RecommendedAutoBuyTick',(self.units[0],0));self.assertEqual(self.adds,[(0,6)]);self.rsync('D','0');self.vm.run('RecommendedAutoBuyTick',(self.units[0],0));self.vm.run('RecommendedAutoBuyTick',(self.units[0],0));self.assertEqual(self.adds,[(0,6),(0,1)]);self.assertTrue(g['AutoBuyRecommendedDone'][0])
 def test_display_cost_changes_with_owned_components_and_step_charge_stays_separate(self):
  self.goals([5]);g=self.vm.g;self.assertEqual([g['QB_DisplayCost'][i] for i in range(5)],[100,200,350,80,470]);self.assertEqual(self.costs(),[100,200,50,80,40])
  self.units[0]['inv'][0]=1;self.gold[0]=0;self.tick();self.assertEqual(self.steps(),[2,3,4,5]);self.assertEqual([g['QB_DisplayCost'][i] for i in range(4)],[200,250,80,370]);self.assertEqual(self.gold[0],0)
 def test_catalogue_price_tick_only_when_inventory_changes(self):
  g=self.vm.g;calls=[];g.update(ReloadItemPage2=lambda *a:calls.append(a));g['Shop_Active'][0]=True;self.vm.run('ShopPricesTick',(0,self.units[0]));self.assertFalse(calls)
  self.units[0]['inv'][0]=1;self.vm.run('ShopPricesTick',(0,self.units[0]));self.assertEqual(calls,[(0,0)]);self.vm.run('ShopPricesTick',(0,self.units[0]));self.assertEqual(len(calls),1)
 def test_catalogue_paints_remaining_price_even_when_rawcode_did_not_change(self):
  g=self.vm.g;paint=[];g.update(WUI_TEXT='',GetLocalPlayer=lambda:0,ShopPricePlateWidth=lambda _: .02,ShopGetItemTooltipWidth=lambda _: .15,ConvertBTNtoDISBTN=lambda x:x,BlzFrameSetText=lambda *a:paint.append(a),BlzFrameSetSize=lambda *_:None,BlzFrameSetVisible=lambda *_:None,BlzFrameSetTexture=lambda *_:None,BlzFrameSetEnable=lambda *_:None)
  for name in ['FRAME_ShopItemCost','FRAME_ShopItemName','FRAME_ShopItemTooltipText','FRAME_ShopItemTooltipBox','FRAME_ShopItemBack','FRAME_ShopItemPricePlate','FRAME_ShopItem']:g[name]=defaultdict(lambda:name)
  g['QB_SetAddFrame']=lambda *_:None;self.vm.run('ShopRenderCatalogueSlot',(0,3,False,0));paint.clear();self.units[0]['inv'][0]=1;self.vm.run('ShopRenderCatalogueSlot',(0,3,False,0));self.assertTrue(any('250' in str(x[1]) for x in paint))
 def test_drop_pointers_surround_target_in_both_directions(self):
  g=self.vm.g;moves=[];visible={};g.update(WUI_Place=lambda *a:moves.append(a),BlzFrameSetVisible=lambda f,v:visible.update({f:v}),QB_DragLight='drag',QB_DropLine='drop',QB_Page=0,QB_ViewCount=15,QB_Columns=5,QB_Left=.665,QB_Width=.245,QB_Size=.036,QB_DragFrom=1,QB_DragTo=3)
  for i in range(4):g['QB_DragArrow'][i]='arrow'+str(i)
  for start,dest in [(1,3),(3,1)]:
   g.update(QB_DragFrom=start,QB_DragTo=dest);moves.clear();self.vm.run('QB_DragPreview')
   x=self.vm.run('QB_SlotX',(dest,))+self.vm.run('Shop_Shift');y=self.vm.run('QB_SlotY',(dest,))
   arrows={v[0]:v[1:3] for v in moves[1:]}
   self.assertAlmostEqual(x-.036*.64,arrows['arrow0'][0]);self.assertAlmostEqual(x+.036*.64,arrows['arrow1'][0])
   self.assertAlmostEqual(y-.036*.64,arrows['arrow2'][1]);self.assertAlmostEqual(y+.036*.64,arrows['arrow3'][1])
   self.assertTrue(all(visible['arrow'+str(i)] for i in range(4)))
 def test_right_drag_commits_once_and_left_drag_is_ignored(self):
  self.goals([1,2,6]);g=self.vm.g;pos=[.6895,.312];pressed=[False]
  g.update(QB_Left=.665,QB_Width=.245,QB_Columns=5,QB_Size=.036,QB_ViewCount=15,QB_Page=0,WUI_TopShown=lambda:True,WUI_ScreenRight=lambda:.790,BlzGetMouseScreenPosX=lambda:pos[0],BlzGetMouseScreenPosY=lambda:pos[1],BlzPixelToFrameX=lambda x:x,BlzPixelToFrameY=lambda y:y,MOUSE_BUTTON_TYPE_RIGHT='right',BlzIsMouseButtonPressed=lambda k:pressed[0],QB_DragRender=lambda:None,BlzFrameSetVisible=lambda *_:None)
  g['Shop_Active'][0]=True;self.vm.run('QB_CheckDrag');self.assertFalse(self.messages)
  pressed[0]=True;self.vm.run('QB_CheckDrag');self.assertEqual(g['QB_DragFrom'],0)
  pos[0]+=.098;pressed[0]=False;self.vm.run('QB_CheckDrag');self.assertTrue(self.messages[-1][1].endswith('0,2'))
  n=len(self.messages);self.vm.run('QB_CheckDrag');self.assertEqual(len(self.messages),n)
 def test_recommended_right_drag_changes_only_one_step(self):
  self.rec([1,2,3]);g=self.vm.g;pos=[.068,.4565];pressed=[True]
  g.update(SHOP_LIST_X=.215,WUI_TopShown=lambda:True,WUI_ScreenRight=lambda:.790,BlzGetMouseScreenPosX=lambda:pos[0],BlzGetMouseScreenPosY=lambda:pos[1],BlzPixelToFrameX=lambda x:x,BlzPixelToFrameY=lambda y:y,MOUSE_BUTTON_TYPE_RIGHT='right',BlzIsMouseButtonPressed=lambda k:pressed[0],QB_DragRender=lambda:None)
  g['Shop_Active'][0]=True;self.vm.run('QB_CheckDrag');self.assertEqual(g['REC_DragFrom'],0)
  pos[0]+=.098;pressed[0]=False;self.vm.run('QB_CheckDrag');self.receive();self.assertEqual(self.ritems(),[2,3,1]);self.assertEqual(self.adds,[])
 def test_minuses_are_siblings_plus_at_top_and_bolt_centred(self):
  s=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8');self.assertIn('QB_Remove[i] = QB_Button("WOSQuickBuyRemove", QB_Panel',s);self.assertIn('FRAMEPOINT_TOP, QB_Slot[i], FRAMEPOINT_BOTTOM',s);self.assertIn('FRAMEPOINT_TOPRIGHT, FRAME_ShopItem[i], FRAMEPOINT_TOPRIGHT',s);self.assertIn('QB_SlotBolt[i], FRAMEPOINT_CENTER',s);self.assertIn('QB_PreviewBolt[i], FRAMEPOINT_CENTER',s)
 def test_no_queue_persistence_no_gameplay_handles_from_local_input_or_file_io(self):
  s=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8')
  for old in ['QB_SaveLocal','QB_LoadLocal','QB_Templates','QB_Preset']:self.assertNotIn(old,s)
  for name in ['REC_LoadLocal','REC_SaveLocal','QB_ButtonEvent','QB_OnMouse','QB_DragRender','QB_FinishDrag']:
   body=s.split('function '+name+' takes',1)[1].split('endfunction',1)[0]
   for forbidden in ['CreateTimer','TimerStart','CreateUnit','CreateGroup','BlzCreateFrame','BlzGetFrameByName','GetRandom']:self.assertNotIn(forbidden,body,(name,forbidden))
  self.assertNotIn('EVENT_PLAYER_MOUSE_MOVE',s.split('function QB_CreateUI takes',1)[1].split('endfunction',1)[0]);save=(ui.ROOT/'triggers/WOS_Start/SaveLoad.j').read_text(encoding='utf-8');body=save.split('function SaveSystem_WriteSettingsFile takes',1)[1].split('endfunction',1)[0];self.assertNotIn('REC_',body);self.assertNotIn('QB_',body)

# Preserve meaningful purchase/dependency/sender/audio checks from FIX3.
for name in ['test_leaf_and_nested_postorder','test_cycle_stops_before_buy','test_wait_gold_preserves_queue','test_full_inventory_waits_without_spend','test_manual_component_sale_rebuilds_missing_steps','test_full_inventory_crafts_with_owned_components','test_sender_hero_version_replay_and_bad_rawcodes','test_independent_players','test_empty_quickbuy_does_not_buy','test_single_component_delete_stays_deleted_and_blocks_its_parent','test_two_deleted_levels_do_not_double_charge','test_deferred_parent_reordered_ahead_preserves_retained_purchases','test_full_inventory_deferred_transaction_consumes_owned_parts','test_deferred_insufficient_gold_never_creates_or_removes_items','test_duplicate_components_partial_allocation','test_manual_component_restores_dependency_without_rebuying_removed_step','test_queue_order_strict_second_group_waits_for_first','test_distinct_feedback_globals_accepted_actions_only','test_rejected_or_replayed_packet_has_no_feedback','test_purchase_sound_only_after_confirmed_purchase','test_hud_minus_selection_occupancy_version_and_index_guards','test_bootstrap_frame_pool_and_runtime_no_allocations']:
 setattr(Fix4,name,getattr(prior.Fix3,name))

class SaveRequest(prior.SaveRequest):pass
if __name__=='__main__':unittest.main()
