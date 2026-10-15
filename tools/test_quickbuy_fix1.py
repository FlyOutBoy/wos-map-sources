"""Quick Buy corrections: actual JASS bodies with native mocks, not engine QA."""
import re
from collections import defaultdict
import test_quickbuy as qb
import test_wos_ui as ui

class Fix1(qb.QuickBuy):
 def test_single_component_delete_stays_deleted_and_blocks_its_parent(self):
  self.goals([5]);self.sync('D','0');self.assertEqual(self.steps(),[2,3,4,5])
  g=self.vm.g;self.assertTrue(g['QB_StepMissing'][1]);self.assertTrue(g['QB_StepMissing'][3])
  self.vm.run('QB_Tick',(0,self.units[0]));self.assertEqual(self.adds,[(0,2)])
  self.vm.run('QB_Tick',(0,self.units[0]));self.assertEqual(self.adds,[(0,2)]);self.assertEqual(g['QB_Status'][0],3)
  self.vm.run('QB_Rebuild',(0,));self.assertEqual(self.steps(),[3,4,5]);self.assertNotIn(1,self.steps())
 def test_manual_component_restores_dependency_without_rebuying_removed_step(self):
  self.goals([5]);self.sync('D','0');self.vm.run('QB_Tick',(0,self.units[0]))
  self.units[0]['inv'][1]=1
  self.vm.run('QB_Tick',(0,self.units[0]));self.assertEqual(self.adds,[(0,2),(0,3)])
  self.vm.run('QB_Tick',(0,self.units[0]));self.vm.run('QB_Tick',(0,self.units[0]))
  self.assertEqual(self.adds,[(0,2),(0,3),(0,4),(0,5)])
 def test_delete_intermediate_keeps_components_and_other_group_order(self):
  self.goals([5,6]);self.sync('D','2');self.assertEqual(self.steps(),[1,2,4,5,6])
  for _ in range(4):self.vm.run('QB_Tick',(0,self.units[0]))
  self.assertEqual(self.adds,[(0,1),(0,2),(0,4)]);self.assertEqual(self.steps(),[5,6])
  self.assertEqual(self.vm.g['QB_PresetCount'][0],2)
 def test_delete_final_keeps_components_then_empty_queue_releases_autobuy(self):
  self.goals([5]);self.sync('D','4');self.assertEqual(self.steps(),[1,2,3,4]);self.assertEqual(self.vm.g['QB_PresetCount'][0],0)
  for _ in range(4):self.vm.run('QB_Tick',(0,self.units[0]))
  self.assertEqual(self.adds,[(0,1),(0,2),(0,3),(0,4)]);self.assertEqual(self.steps(),[])
  self.assertFalse(self.vm.run('QB_Tick',(0,self.units[0])))
 def test_duplicate_rawcode_occurrences_have_independent_structural_keys(self):
  g=self.vm.g;self.recipes[8]=[1,4];self.recipes[7]=[3,8]
  for id,cost in [(8,200),(7,600)]:self.prices[id]=cost;g['QB_Data'][id,0]=True;g['QB_Data'][id,1]=cost
  self.goals([7]);self.assertEqual(self.steps(),[1,2,3,1,4,8,7]);self.sync('D','3')
  self.assertEqual(self.steps(),[1,2,3,4,8,7]);self.units[0]['inv'][0]=3;self.vm.run('QB_Rebuild',(0,))
  self.assertEqual(self.steps(),[4,8,7]);self.assertTrue(g['QB_StepMissing'][1])
 def test_exclusion_moves_with_group_and_survives_other_target_completion(self):
  self.goals([5,6]);self.sync('D','0');self.sync('M','0,1');self.assertEqual(self.steps(),[6,2,3,4,5])
  self.units[0]['inv'][0]=6;self.vm.run('QB_Rebuild',(0,));self.assertEqual(self.steps(),[2,3,4,5])
  self.assertTrue(self.vm.g['QB_StepMissing'][1]);self.assertNotIn(1,self.steps())
 def test_explicit_clear_removes_runtime_exclusions_for_only_the_sender(self):
  self.goals([5]);self.goals([5],1);self.sync('D','0');self.sync('D','0',p=1);self.sync('C','0')
  g=self.vm.g;self.assertFalse(any(g['QB_Excluded'][i] for i in range(768)));self.assertTrue(g['QB_Excluded'][768])
  self.sync('A','5');self.assertEqual(self.steps(),[1,2,3,4,5]);self.assertEqual(self.steps(1),[2,3,4,5])
 def test_removed_step_packet_is_versioned_and_replay_safe(self):
  self.goals([5]);old=self.vm.g['QB_Version'][0];self.sync('D','0');remaining=self.steps()
  self.sync('D','0',version=old);self.assertEqual(self.steps(),remaining)
  self.sync('D','0',seq=1);self.assertEqual(self.steps(),remaining)
 def test_base_gate_is_identical_even_in_test_mode_and_waits_outside(self):
  g=self.vm.g;self.goals([6]);g['TestMode']=True;self.units[0]['base']=False
  self.assertTrue(self.vm.run('QB_Tick',(0,self.units[0])));self.assertEqual(self.adds,[])
  self.units[0]['base']=True;g['CondArena']=1;self.vm.run('QB_Tick',(0,self.units[0]));self.assertEqual(self.adds,[])
  g['CondArena']=0;self.vm.run('QB_Tick',(0,self.units[0]));self.assertEqual(self.adds,[(0,6)])
 def test_fifteen_plus_queue_and_second_page_minus_sends_step_not_group(self):
  g=self.vm.g;self.recipes.clear()
  for id in range(1,33):self.prices[id]=10;g['QB_Data'][id,0]=True;g['QB_Data'][id,1]=10
  for id,children in [(1000,list(range(1,17))),(1001,list(range(17,33)))]:
   self.recipes[id]=children;self.prices[id]=190;g['QB_Data'][id,0]=True;g['QB_Data'][id,1]=190
  self.goals([1000,1001]);original=self.steps();self.assertEqual(len(original),34)
  g.update(QB_ViewCount=15,QB_Page=1,GetHandleId=lambda _:77,BlzGetTriggerFrame=lambda:'minus',BlzGetTriggerFrameEvent=lambda:'click',FRAMEEVENT_CONTROL_CLICK='click',BlzFrameSetFocus=lambda *_:None)
  g['QB_Frames'][77,0]=200;self.vm.run('QB_ButtonEvent');self.assertTrue(self.messages[-1][1].endswith(',15'))
  self.sync('D','15');self.assertEqual(self.steps(),original[:15]+original[16:])
  self.assertEqual(len(self.steps()),33);self.assertEqual(g['QB_ViewCount'],15)
 def test_plus_visibility_from_real_item_and_ban_state_without_extra_writes(self):
  g=self.vm.g;g['QB_Add'][36]='plus';writes=[];g['BlzFrameSetVisible']=lambda *a:writes.append(a)
  self.vm.run('QB_SetAddFrame',(36,0,False));self.assertEqual(writes,[])
  self.vm.run('QB_SetAddFrame',(36,1,False));self.assertEqual(writes,[('plus',True)])
  self.vm.run('QB_SetAddFrame',(36,1,False));self.assertEqual(len(writes),1)
  self.vm.run('QB_SetAddFrame',(36,1,True));self.assertEqual(writes[-1],('plus',False))
  self.vm.run('QB_SetAddFrame',(36,2,False));g['QB_Count'][0]=6;self.vm.run('QB_RefreshAdds');self.assertEqual(writes[-1],('plus',False))
  self.vm.run('QB_SetAddFrame',(36,0,False));self.assertEqual(g['QB_AddId'][36],0)
 def test_hover_is_native_fdf_without_callbacks_geometry_or_allocation(self):
  source=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8');fdf=(ui.ROOT/'assets/UI/WOS/WOSControls.fdf').read_text(encoding='utf-8')
  for fn in ['QB_Button','QB_ButtonEvent']:
   body=source.split('function '+fn+' takes',1)[1].split('endfunction',1)[0]
   self.assertNotIn('FRAMEEVENT_MOUSE_ENTER',body);self.assertNotIn('FRAMEEVENT_MOUSE_LEAVE',body)
  event=source.split('function QB_ButtonEvent takes',1)[1].split('endfunction',1)[0]
  for forbidden in ['BlzFrameSetPoint','BlzFrameSetSize','BlzFrameSetLevel','BlzCreate','CreateTrigger','TimerStart']:self.assertNotIn(forbidden,event)
  self.assertNotIn('QB_HoverTrigger',source)
  for glyph in ['add','remove','clear','prev','next']:
   self.assertIn('WOSQB'+glyph+'Template',fdf);self.assertIn('qb-'+glyph+'-hover.tga',fdf)
  self.assertEqual(fdf.count('// Quick Buy: native hover only'),5)
  self.assertIn('FRAMEPOINT_BOTTOMRIGHT, FRAME_ShopItem[i], FRAMEPOINT_BOTTOMRIGHT, -0.001, 0.001',source)
 def test_layout_single_inventory_row_full_tabs_close_bounds_and_15_slots(self):
  g=self.vm.g;source=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8');placed={};sizes={};hidden={}
  for is_array,name in re.findall(r'(?m)^    framehandle (array )?(\w+)\s*(?:=.*)?$',source):
   g[name]={i:(name,i) for i in range(70)} if is_array else name
  g.update(WUI_Place=lambda fr,x,y,a,b:placed.update({fr:(x,y,a,b)}),ShopPlacePrice=lambda *_:None,BlzFrameSetScale=lambda *_:None,BlzFrameSetAbsPoint=lambda *_:None,BlzFrameSetSize=lambda fr,a,b:sizes.update({fr:(a,b)}),BlzFrameSetVisible=lambda fr,v:hidden.update({fr:v}),I2R=lambda n:float(int(n)),R2I=int,RAbsBJ=abs,RMinBJ=min,RMaxBJ=max,ModuloInteger=lambda a,b:a%b,QB_DragFrom=-1)
  for aspect in [4/3,5/4,16/9,21/9]:
   g['WUI_ScreenRight']=lambda a=aspect:.4+.3*a;g['QB_Right']=0;placed.clear();self.vm.run('QB_Layout')
   items=[placed['FRAME_ShopItemInventorySlot',i] for i in range(6)];self.assertEqual(len({p[1] for p in items}),1)
   self.assertTrue(all(items[i][0]+items[i][2]*.5<items[i+1][0]-items[i+1][2]*.5 for i in range(5)))
   buy=placed['FRAME_ShopItemInventorySlot',6];sell=placed['FRAME_ShopItemInventorySlot',7];fast=placed['FRAME_FastBuyToggle']
   self.assertLess(buy[0]+buy[2]*.5,items[0][0]-items[0][2]*.5);self.assertEqual(buy[0],sell[0]);self.assertGreater(buy[1],sell[1])
   self.assertGreater(fast[0]-fast[2]*.5,items[-1][0]+items[-1][2]*.5);self.assertLess(fast[2],buy[2])
   tabs=[placed['FRAME_ShopSection',i] for i in range(8)];close=placed['FRAME_ShopClose']
   for i in range(7):self.assertAlmostEqual(tabs[i][0]+tabs[i][2]*.5,tabs[i+1][0]-tabs[i+1][2]*.5)
   self.assertLess(tabs[-1][0]+tabs[-1][2]*.5,close[0]-close[2]*.5);self.assertAlmostEqual(close[0]+close[2]*.5,g['QB_Right']-.004)
   self.assertEqual(g['QB_ViewCount'],15)
   for i in range(15):
    x,y,a,b=placed['QB_Slot',i];self.assertGreaterEqual(x-a*.5,g['QB_Left']);self.assertLessEqual(x+a*.5,g['QB_Right']);self.assertGreaterEqual(y-b*.5,.188)
   self.assertTrue(all(hidden['FRAME_ShopInventoryItemName',i] is False for i in range(6)))
   placed.clear();self.vm.run('QB_Layout');self.assertEqual(placed,{})
 def test_decorations_are_passive_and_inherit_preview_hide(self):
  source=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8')
  for marker in ['QB_SlotEdge','QB_SlotBolt','QB_PreviewEdge','QB_PreviewBolt']:
   self.assertIn('set '+marker+'[i] = QB_Decor(',source)
  self.assertIn('QB_Preview[i], QB_TEXTURE + "bolt.tga"',source)
  self.assertIn('0.032, 0.032)',source)
  self.assertIn('call BlzFrameSetEnable(fr, false)',source.split('function QB_Decor takes',1)[1].split('endfunction',1)[0])

 def test_visible_slot_does_not_reset_native_hover_on_repeated_data_refresh(self):
  writes=[];self.vm.g['BlzFrameSetVisible']=lambda *a:writes.append(a)
  self.vm.g['QB_Slot'][0]='slot';self.vm.run('QB_ShowSlot',(0,True));self.vm.run('QB_ShowSlot',(0,True))
  self.assertEqual(writes,[('slot',True)]);self.vm.run('QB_ShowSlot',(0,False));self.assertEqual(writes[-1],('slot',False))

 def test_existing_fast_buy_and_sell_routes_and_real_button_binding_are_preserved(self):
  g=self.vm.g;clock=[2.0];g.update(TimerGetElapsed=lambda _:clock[0],ShopClock='clock')
  g['ShopFastSell'][0]=True
  self.assertEqual(self.vm.run('ShopFastAction',(0,300,6)),300);clock[0]+=.2
  self.assertEqual(self.vm.run('ShopFastAction',(0,300,6)),307)
  g['ShopFastBuy'][0]=True;clock[0]+=1
  self.assertEqual(self.vm.run('ShopFastAction',(0,200,1)),200);clock[0]+=.2
  self.assertEqual(self.vm.run('ShopFastAction',(0,200,1)),306)
  self.assertEqual(self.vm.run('ShopFastAction',(0,306,1)),306)
  self.assertEqual(self.vm.run('ShopFastAction',(0,307,6)),307)
  source=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8')
  self.assertIn('GetHandleId(FRAME_ShopItemInventorySlot[i]), 0, 300 + i)',source)
  self.assertIn('BlzTriggerRegisterFrameEvent(FrameClick2, FRAME_ShopItemInventorySlot[i], FRAMEEVENT_CONTROL_CLICK)',source)

 def test_plus_is_hidden_for_an_already_active_target(self):
  self.goals([1]);g=self.vm.g;g['QB_Add'][0]='plus';writes=[];g['BlzFrameSetVisible']=lambda *a:writes.append(a)
  self.vm.run('QB_SetAddFrame',(0,1,False));self.assertEqual(writes,[])
  self.vm.run('QB_SetAddFrame',(0,2,False));self.assertEqual(writes,[('plus',True)])
  self.vm.run('QB_SetAddFrame',(0,1,False));self.assertEqual(writes[-1],('plus',False))

if __name__=='__main__':
 import unittest
 unittest.main()
