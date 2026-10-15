"""Execute candidate JASS with native mocks. Does not test Warcraft input or multiplayer."""
import unittest, re, json
from collections import defaultdict
import test_quickbuy_fix4 as prior
import test_wos_ui as ui

class Fix5(prior.Fix4):
 def setUp(self):
  super().setUp(); g=self.vm.g
  g.update(REC_AddSound='rec-add',REC_RemoveSound='rec-remove',gg_snd_Swap='rec-add',gg_snd_BattleNetTick='rec-remove',QB_HoverSlot=-1,I2R=lambda n:float(int(n)))
  for name in re.findall(r'(?m)^    framehandle (FRAME_\w+)\s*(?:=.*)?$',(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8')):g.setdefault(name,'existing:'+name)
  g['StartSoundForPlayerBJ']=lambda p,s:(self.feedback if s in ['add','remove','clear','rec-add','rec-remove'] else self.sound).append((p,s))
 def button(self,code,event='click'):
  g=self.vm.g;g['QB_Frames'][77,0]=code
  g.update(GetHandleId=lambda x:x,BlzGetTriggerFrame=lambda:77,BlzGetTriggerFrameEvent=lambda:event,FRAMEEVENT_CONTROL_CLICK='click',BlzFrameSetFocus=lambda *_:None,QB_DragRender=lambda:None)
  self.vm.run('QB_ButtonEvent')
 def test_rec_add_duplicate_capacity_ban_version_and_owner(self):
  self.rec([1,2]);self.rec([6],1);self.rsync('A','3');self.rsync('A','3');self.assertEqual(self.ritems(),[1,2,3]);self.assertEqual(self.ritems(1),[6]);self.assertFalse(self.filewrites)
  self.assertEqual(self.feedback,[(0,'rec-add')]);self.rsync('A','999');self.rsync('A','4',hero=999);self.assertEqual(self.ritems(),[1,2,3])
  self.vm.g['CheckBanItems']=lambda id,u:id==4;self.rsync('A','4');self.assertEqual(self.ritems(),[1,2,3])
  self.rec([1]*28);self.rsync('A','5');self.assertEqual(len(self.ritems()),28)
 def test_rec_save_affordance_sends_add_not_file_write(self):
  self.rec([1]);self.vm.g['QB_AddId'][7]=2;self.button(807);self.assertEqual(self.messages[0][0],'WOSREC1');self.receive();self.assertEqual(self.ritems(),[1,2]);self.assertFalse(self.filewrites)
 def test_rec_affordance_independent_of_full_queue_hidden_for_existing_item(self):
  g=self.vm.g;self.rec([1]);self.goals([1,2,3,4,5,6]);seen={};g.update(BlzFrameSetVisible=lambda f,v:seen.update({f:v}));g['REC_AddButton'][7]='disk';g['QB_Add'][7]='plus'
  self.vm.run('QB_SetAddFrame',(7,2,False));self.assertFalse(seen.get('disk',False)) # Recommended catalogue has no disk.
  g['ItemsFrameCurrentPage_ID'][0]=1;self.vm.run('QB_SetAddFrame',(7,2,False));self.assertTrue(seen['disk']);self.assertFalse(seen.get('plus',False))
  self.vm.run('QB_SetAddFrame',(7,1,False));self.assertFalse(seen['disk']);self.vm.run('QB_SetAddFrame',(7,2,True));self.assertFalse(seen.get('disk',False))
 def test_three_requested_feedback_actions_are_distinct(self):
  self.rec([1,2]);self.goals([1]);self.rsync('D','0');self.sync('A','2');self.sync('D','0')
  self.assertEqual(self.feedback,[(0,'rec-remove'),(0,'add'),(0,'remove')]);self.assertEqual(len({s for p,s in self.feedback}),3)
 def test_qb_icon_click_requests_inspection_only(self):
  self.goals([3]);self.vm.g['Shop_Active'][0]=True;seen=[];self.vm.g['QB_Inspect']=lambda p,id:seen.append((p,id));before=self.steps();self.button(501);self.receive()
  self.assertEqual(seen,[(0,2)]);self.assertEqual(self.steps(),before);self.assertFalse(self.adds);self.assertFalse(self.filewrites)
 def test_inspection_rejects_stale_index_closed_shop_and_foreign_hero(self):
  self.goals([3]);seen=[];g=self.vm.g;g['QB_Inspect']=lambda *a:seen.append(a);g['Shop_Active'][0]=True
  self.sync('V','9');self.sync('V','0',version=0);self.sync('V','0',hero=999);g['Shop_Active'][0]=False;self.sync('V','0');self.assertFalse(seen)
 def test_actual_inspection_updates_agreed_tree_caches_without_purchases(self):
  self.goals([3]);g=self.vm.g;tree=[];desc=[];g.update(BlzFrameSetTexture=lambda *_:None,BlzFrameSetText=lambda *_:None,ShopShowItemDescription=lambda *a:desc.append(a),CraftItemCheck=lambda *a:tree.append(a))
  self.vm.run('QB_Inspect',(0,3));self.assertEqual(g['ItemsCurrentItem_ID'][0],3);self.assertEqual(tree,[(3,0,0)]);self.assertEqual(desc,[(3,0)]);self.assertFalse(self.adds);self.assertEqual(self.gold[0],3000)
 def test_passive_event_tooltip_enters_and_leaves_without_repainting_cursor(self):
  self.goals([1,2]);visible=[];g=self.vm.g;g['BlzFrameSetVisible']=lambda f,v:visible.append((f,v));g['QB_TipBox'][0]='tip';self.button(500,'enter');self.assertEqual(g['QB_HoverSlot'],0);self.assertIn(('tip',True),visible)
  g['BlzIsMouseButtonPressed']=lambda _:False;self.button(500,'leave');self.assertEqual(g['QB_HoverSlot'],-1);self.assertIn(('tip',False),visible);self.assertFalse(self.messages)
  body=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8').split('function QB_CreateTip takes',1)[1].split('endfunction',1)[0];self.assertNotIn('call BlzFrameSetTooltip',body)
 def test_hud_simple_click_has_no_focus_operation(self):
  self.goals([1]);g=self.vm.g;g['QB_PreviewStep'][1]=0;g['QB_PreviewVersion'][1]=g['QB_Version'][0]
  g['BlzFrameSetFocus']=lambda *_:self.fail('SIMPLEBUTTON cannot take normal focus')
  g['QB_Frames'][77,0]=401;g.update(GetHandleId=lambda x:x,BlzGetTriggerFrame=lambda:77,BlzGetTriggerFrameEvent=lambda:'click',FRAMEEVENT_CONTROL_CLICK='click',QB_DragRender=lambda:None)
  self.vm.run('QB_ButtonEvent');self.assertTrue(self.messages[-1][1].endswith('D,0') or self.messages[-1][1].startswith('D,'))
 def test_hud_minuses_disable_on_real_items_other_selection_and_empty_queue(self):
  self.goals([1,2,3]);g=self.vm.g;enabled={};g.update(QB_Panel=None,WUI_GOLD='',WUI_TEXT='',BlzFrameSetEnable=lambda f,v:enabled.update({f:v}),QB_Layout=lambda:None,REC_Render=lambda:None,QB_RefreshAdds=lambda:None,WUI_TopShown=lambda:True)
  # Use actual renderer after suppressing unrelated shop panel painting.
  g['QB_Panel']='panel';g['QB_LastViewVersion']=g['QB_Version'][0];g['QB_LastViewStatus']=g['QB_Status'][0];g['QB_LastViewPage']=g['QB_Page'];g['QB_LastShopOpen']=False
  for i in range(6):g['QB_PreviewRemove'][i]='minus'+str(i);g['QB_LastPreview'][i]=-1
  g.update(BlzFrameSetTexture=lambda *_:None,BlzFrameSetText=lambda *_:None)
  self.units[0]['inv'][0]=6;self.vm.run('QB_RenderLocal');self.assertFalse(enabled['minus0']);self.assertTrue(enabled['minus1'])
  g['UNITSTAT_GetSelected']=lambda _:self.units[1];self.vm.run('QB_RenderLocal');self.assertTrue(all(not v for v in enabled.values()))
 def test_each_hud_minus_matches_own_slot_lower_rim_not_common_strip(self):
  s=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8');self.assertIn('BlzCreateSimpleFrame("WOSQBHUDRemove", WUI_GetSimpleRoot()',s)
  self.assertIn('WUI_ItemY(i) - 0.0162, 0.014, 0.0035',s);self.assertNotIn('0.0055, 0.012, 0.007',s)
  for i in range(6):
   top=.0625-(i//3)*.035;centre=top-.0162;self.assertGreater(centre-.00175,0)
   if i<3:self.assertGreater(centre-.00175,.0275+.0165) # first-row minus does not enter next native icon.
 def test_third_row_names_minuses_and_footer_do_not_overlap(self):
  size=.036;bottom=.312-2*.065-size/2;name_top=bottom-.001;name_bottom=name_top-.013;minus_top=bottom-.016;minus_bottom=minus_top-.010
  self.assertGreaterEqual(name_bottom,minus_top);self.assertGreater(minus_bottom,.126+.0075)
  f=(ui.ROOT/'assets/UI/WOS/WOSControls.fdf').read_text(encoding='utf-8');self.assertIn('WOSQBslotTemplate',f);self.assertIn('Frame "SIMPLEBUTTON" "WOSQBHUDRemove"',f)
 def test_layout_all_supported_aspects_reflows_names_and_keeps_footer_in_panel(self):
  g=self.vm.g;source=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8');placed={};hidden={}
  for is_array,name in re.findall(r'(?m)^    framehandle (array )?(\w+)\s*(?:=.*)?$',source):g[name]={i:(name,i) for i in range(70)} if is_array else name
  g.update(WUI_Place=lambda fr,x,y,a,b:placed.update({fr:(x,y,a,b)}),ShopPlacePrice=lambda *_:None,BlzFrameSetScale=lambda *_:None,BlzFrameSetSize=lambda *_:None,BlzFrameClearAllPoints=lambda *_:None,BlzFrameSetAllPoints=lambda *_:None,BlzFrameSetVisible=lambda fr,v:hidden.update({fr:v}),WUI_ScreenRight=lambda:.8)
  for aspect in [5/4,4/3,16/9,21/9]:
   g['WUI_ScreenRight']=lambda a=aspect:.4+.3*a;g['QB_Right']=0;placed.clear();self.vm.run('QB_Layout');panel=placed['QB_Panel'];footer=placed['QB_StateText']
   self.assertAlmostEqual(panel[1]-panel[3]/2,.110);self.assertGreater(footer[1]-.015/2,panel[1]-panel[3]/2)
   for i in range(15):
    x,y,a,z=placed['QB_Slot',i];self.assertGreaterEqual(x-a/2,g['QB_Left']);self.assertLessEqual(x+a/2,g['QB_Right']);self.assertGreater(y-z/2-.026,.126+.0075)
   placed.clear();self.vm.run('QB_Layout');self.assertFalse(placed)
 def test_repeated_data_show_does_not_toggle_hover_widgets(self):
  g=self.vm.g;calls=[];g.update(BlzFrameSetVisible=lambda f,v:calls.append((f,v)));g['QB_LastSlotShown'][0]=False;g['QB_HoverSlot']=-1
  self.vm.run('QB_ShowSlot',(0,True));self.assertEqual(len(calls),3);calls.clear();self.vm.run('QB_ShowSlot',(0,True));self.assertFalse(calls)
  g['QB_HoverSlot']=0;self.vm.run('QB_ShowSlot',(0,False));self.assertEqual(g['QB_HoverSlot'],-1)
 def test_full_inventory_missing_part_assembled_directly_in_one_operation(self):
  self.units[0]['inv']=[1,6,6,6,6,6];self.goals([3]);self.tick();self.assertEqual(self.adds,[(0,3)]);self.assertIn(3,self.units[0]['inv']);self.assertNotIn(1,self.units[0]['inv']);self.assertNotIn(2,self.units[0]['inv']);self.assertEqual(self.gold[0],2750);self.assertEqual(self.steps(),[])
 def test_full_inventory_nested_recipe_releases_slot_and_keeps_other_goals(self):
  self.units[0]['inv']=[1,6,6,6,6,6];self.goals([5,2]);self.tick();self.assertEqual(self.adds,[(0,3)]);self.assertEqual(self.gold[0],2750);self.tick();self.assertEqual(self.adds,[(0,3),(0,5)]);self.assertEqual(self.gold[0],2630);self.assertEqual(self.steps(),[2])
 def test_full_inventory_no_owned_part_never_spends_or_drops_item(self):
  self.units[0]['inv']=[6]*6;self.goals([3]);before=self.units[0]['inv'][:];self.tick();self.assertEqual(self.gold[0],3000);self.assertEqual(self.units[0]['inv'],before);self.assertFalse(self.adds);self.assertEqual(self.vm.g['QB_Status'][0],2)
 def test_full_inventory_not_enough_gold_retains_entire_queue(self):
  self.units[0]['inv']=[1,6,6,6,6,6];self.goals([3]);self.gold[0]=249;before=self.units[0]['inv'][:];steps=self.steps();self.tick();self.assertEqual(self.units[0]['inv'],before);self.assertEqual(self.gold[0],249);self.assertEqual(self.steps(),steps);self.assertEqual(self.vm.g['QB_Status'][0],1)
 def test_full_inventory_banned_assembly_is_not_bought(self):
  self.units[0]['inv']=[1,6,6,6,6,6];self.goals([3]);self.vm.g['CheckBanItems']=lambda id,u:id==3;self.tick();self.assertFalse(self.adds);self.assertEqual(self.gold[0],3000)
 def test_full_inventory_other_player_does_not_change_local_hero_queue_or_gold(self):
  self.goals([2],0);self.units[1]['inv']=[1,6,6,6,6,6];self.goals([3],1);local_steps=self.steps(0);local_inv=self.units[0]['inv'][:]
  self.vm.run('QB_Tick',(1,self.units[1]));self.assertEqual(self.adds,[(1,3)]);self.assertEqual(self.gold[1],2750);self.assertEqual(self.gold[0],3000);self.assertEqual(self.steps(0),local_steps);self.assertEqual(self.units[0]['inv'],local_inv)
 def test_rec_duplicate_and_stale_packet_has_no_feedback(self):
  self.rec([1]);self.rsync('A','1');self.rsync('A','2',version=0);self.rsync('A','999');self.assertFalse(self.feedback)
 def test_idle_hover_does_not_create_handles_or_periodic_mouse_sampling(self):
  s=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8');body=s.split('function QB_ButtonEvent takes',1)[1].split('endfunction',1)[0]
  for token in ['CreateUnit','CreateItem','CreateSound','CreateTimer','BlzCreate','GetItemValue','CheckItemsReduceCostCraft','CraftItemCheck']:self.assertNotIn(token,body)
  body=s.split('function QB_Inspect takes',1)[1].split('endfunction',1)[0];self.assertIn('CraftItemCheck',body)

class SaveRequest(prior.SaveRequest):pass
if __name__=='__main__':unittest.main()
