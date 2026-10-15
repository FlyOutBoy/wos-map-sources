"""FIX8 actual JASS bodies with native mocks; native cursor/input need game acceptance."""
import unittest,re
import test_quickbuy_fix7 as prior
import test_wos_ui as ui
class Fix8(prior.Fix7):
 def setUp(self):
  super().setUp();g=self.vm.g;self.enabled={};g.update(BlzFrameGetEnable=lambda f:self.enabled.get(f,False),BlzFrameSetEnable=lambda f,v:self.enabled.update({f:v}),BlzFrameSetTooltip=lambda *_:None)
  for i in range(6):g['QB_PreviewRemove'][i]=('input',i);g['QB_PreviewMinusFace'][i]=('face',i)
 def test_hud_minuses_disable_on_real_items_other_selection_and_empty_queue(self):
  self.goals([1,2,3]);g=self.vm.g;g.update(QB_Panel='panel',WUI_GOLD='',WUI_TEXT='',QB_Layout=lambda:None,REC_Render=lambda:None,QB_RefreshAdds=lambda:None,WUI_TopShown=lambda:True,BlzFrameSetTexture=lambda *_:None,BlzFrameSetText=lambda *_:None)
  g['QB_LastViewVersion']=g['QB_Version'][0];g['QB_LastViewStatus']=g['QB_Status'][0];g['QB_LastViewPage']=g['QB_Page'];g['QB_LastShopOpen']=False
  for i in range(6):g['QB_LastPreview'][i]=-1
  self.units[0]['inv'][0]=6;self.vm.run('QB_RenderLocal');self.assertFalse(self.enabled.get(('input',0),False));self.assertFalse(self.enabled.get(('face',0),False));self.assertTrue(self.enabled['input',1]);self.assertTrue(self.enabled['face',1])
  g['UNITSTAT_GetSelected']=lambda _:self.units[1];self.vm.run('QB_RenderLocal');self.assertTrue(all(not v for v in self.enabled.values()));self.assertTrue(all(not self.visible.get(('face',i),False) for i in range(6)))
 def test_repeated_data_show_does_not_toggle_hover_widgets(self):
  g=self.vm.g;calls=[];g['BlzFrameSetVisible']=lambda *a:calls.append(a);g['QB_LastSlotShown'][0]=False;self.vm.run('QB_ShowSlot',(0,True));self.assertEqual(len(calls),3);calls.clear();self.vm.run('QB_ShowSlot',(0,True));self.assertFalse(calls);self.vm.run('QB_ShowSlot',(0,False));self.assertIn((g['QB_TipBox'][0],False),calls)
 def test_each_hud_minus_matches_own_slot_lower_rim_not_common_strip(self):
  s=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8');self.assertIn('WUI_ItemY(i) - 0.0140, 0.014, 0.00525',s)
  for i in range(6):
   y=.0625-(i//3)*.035;self.assertGreater(y-.014-.00525/2,0)
   if i<3:self.assertGreater(y-.014-.00525/2,y-.035+.028/2)
 def test_rec_minus_mirrors_plus_inside_anchor_and_hud_hover_style(self):
  s=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8');self.assertIn('FRAMEPOINT_TOPLEFT, FRAME_ShopItem[i], FRAMEPOINT_TOPLEFT, 0.001, -0.001',s);self.assertIn('QB_PreviewMinusFace[i] = QB_Button',s);self.assertIn('BlzFrameSetLevel(QB_PreviewMinusFace[i], 80)',s)
 def test_passive_event_tooltip_enters_and_leaves_without_repainting_cursor(self):
  source=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8');self.assertNotIn('FRAMEEVENT_MOUSE_ENTER',source);self.assertNotIn('FRAMEEVENT_MOUSE_LEAVE',source);self.assertNotIn('QB_HoverSlot',source)
  self.goals([1,2]);v=[];g=self.vm.g;g['BlzFrameSetVisible']=lambda *a:v.append(a)
  self.button(500,'enter');self.button(500,'leave');self.assertFalse(v);self.assertFalse(self.messages)
 def drag_fixture(self,rec=False):
  g=self.vm.g
  if rec:self.rec([1,2,3])
  else:self.goals([1,2,6])
  self.x=.068 if rec else .665+.245/10;self.y=.4565 if rec else .270
  g.update(Shop_Active={0:True},WUI_TopShown=lambda:True,BlzIsMouseButtonPressed=lambda _:True,MOUSE_BUTTON_TYPE_RIGHT='right',QB_Left=.665,QB_Width=.245,QB_Columns=5,QB_Size=.036,QB_Page=0,QB_ViewCount=15,BlzPixelToFrameX=lambda x:x,BlzPixelToFrameY=lambda y:y,BlzGetMouseScreenPosX=lambda:self.x,BlzGetMouseScreenPosY=lambda:self.y,QB_SlotY=lambda i:.270-(i//5)*.065,QB_DragRender=lambda:None)
  g['QB_SlotX']=lambda i:.665+.245*(i%5+.5)/5
  return g
 def test_frame_leave_starts_right_drag_without_player_mouse_down(self):
  g=self.drag_fixture();self.vm.run('QB_CheckDrag');self.assertEqual(g['QB_DragFrom'],0);self.assertEqual(self.messages[0][1].split(',')[0],'B');self.x=.7875;self.vm.run('QB_CheckDrag');self.assertEqual(g['QB_DragTo'],2);g['BlzIsMouseButtonPressed']=lambda _:False;self.vm.run('QB_CheckDrag');self.receive();self.assertEqual(self.steps(),[2,6,1])
 def test_recommended_frame_leave_starts_drag_without_frame_mouse_down(self):
  g=self.drag_fixture(True);self.vm.run('QB_CheckDrag');self.assertEqual(g['REC_DragFrom'],0);self.x=.166;self.vm.run('QB_CheckDrag');self.assertEqual(g['REC_DragTo'],2);g['BlzIsMouseButtonPressed']=lambda _:False;self.vm.run('QB_CheckDrag');self.receive();self.assertEqual(self.ritems(),[2,3,1]);self.assertFalse(self.adds)
 def test_idle_drag_check_never_samples_mouse_or_creates_handles(self):
  g=self.vm.g;g['WUI_TopShown']=lambda:True;g['Shop_Active'][0]=True;g['BlzIsMouseButtonPressed']=lambda _:False
  for n in ['BlzGetMouseScreenPosX','BlzGetMouseScreenPosY','BlzCreateFrameByType','CreateTrigger','CreateTimer']:g[n]=lambda *_,n=n:self.fail('idle '+n)
  self.vm.run('QB_CheckDrag');self.assertFalse(self.messages);g['Shop_Active'][0]=False;g['BlzIsMouseButtonPressed']=lambda *_:self.fail('closed shop sampling');self.vm.run('QB_CheckDrag')
 def test_display_cost_changes_with_owned_components_and_step_charge_stays_separate(self):
  self.goals([5]);self.assertEqual(self.display(),[100,200,50,80,40]);self.assertEqual(self.costs(),[100,200,50,80,40]);self.units[0]['inv'][0]=1;self.gold[0]=0;self.tick();self.assertEqual(self.steps(),[2,3,4,5]);self.assertEqual(self.display(),[200,50,80,40]);self.assertEqual(self.gold[0],0)
 def test_hiraishin_4500_shows_250_recipe_on_initial_add(self):
  g=self.vm.g;self.recipes[7]=[8,2,4];self.recipes[8]=[1];self.prices.update({1:500,8:1250,2:1000,4:2000,7:4500})
  for n in [1,8,2,4,7]:g['QB_Data'][n,0]=True;g['QB_Data'][n,1]=self.prices[n]
  self.goals([7]);self.assertEqual(self.steps(),[1,8,2,4,7]);self.assertEqual(self.display(),[500,750,1000,2000,250]);self.assertEqual(sum(self.display()),4500)
 def test_parent_plan_rebuilt_on_inventory_and_moved_steps(self):
  self.goals([5]);g=self.vm.g;parents={self.steps()[i]:g['QB_PriceParent'][i] for i in range(5)};self.assertEqual(parents,{1:2,2:2,3:4,4:4,5:-1});self.sync('M','4,0');self.assertEqual(self.display(),[40,100,200,50,80]);self.units[0]['inv'][0]=3;self.gold[0]=0;self.tick();self.assertEqual(self.steps(),[5,4]);self.assertEqual(self.display(),[40,80])
 def test_show_hide_both_minus_families_without_resetting_stable_hover(self):
  g=self.vm.g;calls=[];g['BlzFrameSetVisible']=lambda f,v:(self.visible.update({f:v}),calls.append(f));g['BlzFrameIsVisible']=lambda f:self.visible.get(f,False)
  self.vm.run('QB_ShowPreviewRemove',(1,True));self.assertTrue(self.visible['face',1]);self.assertTrue(self.enabled['input',1]);calls.clear();self.vm.run('QB_ShowPreviewRemove',(1,True));self.assertFalse(calls);self.vm.run('QB_ShowPreviewRemove',(1,False));self.assertFalse(self.visible['face',1]);self.assertFalse(self.enabled['input',1])
 def test_two_input_families_same_step_version_cannot_delete_twice(self):
  self.goals([1,2]);g=self.vm.g;g['QB_PreviewStep'][0]=0;g['QB_PreviewVersion'][0]=g['QB_Version'][0];self.button(400);self.button(400);self.assertEqual(len(self.messages),2);self.receive();self.assertEqual(self.steps(),[2])
 def test_visible_hud_face_uses_wide_existing_pill_states(self):
  f=(ui.ROOT/'assets/UI/WOS/WOSControls.fdf').read_text(encoding='utf-8');body=f.split('Frame "BUTTON" "WOSQBhudremoveTemplate"',1)[1].split('// Quick Buy:',1)[0]
  for state in ['normal','hover','active','disabled']:self.assertIn('qb-hud-remove-'+state+'.tga',body)
  s=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8');self.assertIn('"hudremove", 400 + i',s)
 def test_native_tip_attached_at_bootstrap_no_hover_code(self):
  g=self.vm.g;attached=[];g.update(WUI_GetRoot=lambda:'root',WUI_TooltipBox=lambda *_:'tip',QB_Text=lambda *_:'text',BlzFrameSetPoint=lambda *_:None,BlzFrameSetSize=lambda *_:None,BlzFrameSetLevel=lambda *_:None,FRAMEPOINT_BOTTOMRIGHT='br',FRAMEPOINT_TOPRIGHT='tr',BlzFrameSetTooltip=lambda *a:attached.append(a));g['QB_Slot'][0]='slot';self.vm.run('QB_CreateTip',(0,));self.assertEqual(attached,[('slot','tip')])
 def test_drag_does_not_start_in_other_catalogue_category(self):
  g=self.drag_fixture(True);g['ItemsFrameCurrentPage_ID'][0]=1;self.vm.run('QB_CheckDrag');self.assertEqual(g['REC_DragFrom'],-1);self.assertFalse(self.messages)
 def test_pressed_elsewhere_cannot_move_into_starting_drag(self):
  g=self.drag_fixture();self.x=0;self.y=0;self.vm.run('QB_CheckDrag');self.x=.6895;self.y=.270;self.vm.run('QB_CheckDrag');self.assertEqual(g['QB_DragFrom'],-1);self.assertFalse(self.messages)
if __name__=='__main__':unittest.main()
