"""Actual JASS bodies with native mocks. Not Warcraft engine/multiplayer QA."""
import re, unittest
from collections import defaultdict
import test_quickbuy_fix2 as previous
import test_wos_ui as ui

class Fix3(previous.Fix2):
 def setUp(self):
  super().setUp();g=self.vm.g;self.feedback=[]
  g.update(QB_AddSound='add',QB_RemoveSound='remove',QB_ClearSound='clear',gg_snd_UpkeepRing='add',UsedSlot=defaultdict(bool))
  g['StartSoundForPlayerBJ']=lambda p,s:(self.feedback if s in ['add','remove','clear'] else self.sound).append((p,s))
  def reduce(u,c,id,remove):
   def discard(it):u['inv'][u['inv'].index(it)]=0
   g['RemoveItem']=discard
   return self.vm.run('CheckItemsReduceCostCraft',(u,c,id,remove))
  g['CheckItemsReduceCostCraft']=reduce
 def costs(self):return [self.vm.g['QB_Cost'][i] for i in range(len(self.steps()))]
 def tick(self,n=1):
  for _ in range(n):self.vm.run('QB_Tick',(0,self.units[0]))
 def test_single_component_delete_stays_deleted_and_blocks_its_parent(self):
  self.goals([5]);self.sync('D','0');self.assertEqual(self.steps(),[2,3,4,5]);self.assertEqual(self.costs(),[200,150,80,40])
  self.assertTrue(self.vm.g['QB_StepMissing'][1]);self.assertFalse(self.vm.g['QB_StepMissing'][3])
  self.tick(4);self.assertEqual(self.adds,[(0,2),(0,3),(0,4),(0,5)]);self.assertEqual(self.steps(),[]);self.assertEqual(self.gold[0],2530)
 def test_delete_intermediate_keeps_components_and_other_group_order(self):
  self.goals([5,6]);self.sync('D','2');self.assertEqual(self.costs(),[100,200,80,90,60]);self.tick(5)
  self.assertEqual(self.adds,[(0,1),(0,2),(0,4),(0,5),(0,6)]);self.assertEqual(self.gold[0],2470)
 def test_manual_component_restores_dependency_without_rebuying_removed_step(self):
  self.goals([5]);self.sync('D','0');self.tick();self.units[0]['inv'][1]=1;self.tick(3)
  self.assertEqual(self.adds,[(0,2),(0,3),(0,4),(0,5)]);self.assertEqual(self.gold[0],2630)
 def test_queue_order_strict_second_group_waits_for_first(self):
  # Strict queue: a later (cheaper) item never jumps ahead of a ready step waiting for gold.
  self.units[0]['inv'][0]=2;self.goals([3,6]);self.sync('D','0');self.gold[0]=100;self.tick(2)
  self.assertEqual(self.adds,[]);self.assertEqual(self.steps(),[3,6]);self.assertEqual(self.gold[0],100);self.assertEqual(self.vm.g['QB_Status'][0],1)
 def test_two_deleted_levels_do_not_double_charge(self):
  self.goals([5]);self.sync('D','0');self.sync('D','1');self.assertEqual(self.steps(),[2,4,5]);self.assertEqual(self.costs(),[200,80,190])
  self.tick(3);self.assertEqual(self.adds,[(0,2),(0,4),(0,5)]);self.assertEqual(self.gold[0],2530)
 def test_deferred_parent_reordered_ahead_preserves_retained_purchases(self):
  self.goals([5]);self.sync('D','0');self.sync('M','1,0');self.assertEqual(self.steps(),[3,2,4,5]);self.tick(4)
  self.assertEqual(self.adds,[(0,2),(0,3),(0,4),(0,5)]);self.assertEqual(self.gold[0],2530)
 def test_full_inventory_deferred_transaction_consumes_owned_parts(self):
  self.goals([3]);self.sync('D','0');self.units[0]['inv']=[2,6,6,6,6,6];self.tick()
  self.assertEqual(self.adds,[(0,3)]);self.assertEqual(self.gold[0],2850);self.assertNotIn(1,self.units[0]['inv'])
 def test_deferred_insufficient_gold_never_creates_or_removes_items(self):
  self.goals([3]);self.sync('D','0');self.units[0]['inv'][0]=2;self.gold[0]=149;before=self.units[0]['inv'][:];self.tick()
  self.assertEqual(self.gold[0],149);self.assertEqual(self.units[0]['inv'],before);self.assertFalse(self.adds);self.assertFalse(self.sound)
 def test_duplicate_components_partial_allocation(self):
  g=self.vm.g;self.recipes[8]=[1,1];self.prices[8]=250;g['QB_Data'][8,0]=True;g['QB_Data'][8,1]=250
  self.goals([8]);self.sync('D','0');self.assertEqual(self.steps(),[1,8]);self.assertEqual(self.costs(),[100,150]);self.tick(2)
  self.assertEqual(self.adds,[(0,1),(0,8)]);self.assertEqual(self.gold[0],2750)
 def test_distinct_feedback_globals_accepted_actions_only(self):
  self.goals([5]);self.sync('A','6');self.sync('D','0');self.sync('C','0');self.sync('C','0');self.sync('A','999')
  self.assertEqual(self.feedback,[(0,'add'),(0,'remove'),(0,'clear')]);self.assertFalse(self.sound)
 def test_rejected_or_replayed_packet_has_no_feedback(self):
  self.goals([1]);old=self.vm.g['QB_Version'][0];self.sync('A','2');self.sync('D','0',version=old);self.sync('C','0',seq=1);self.sync('A','2')
  self.assertEqual(self.feedback,[(0,'add')])
 def test_feedback_owner_is_sender_and_sound_handles_not_created(self):
  self.goals([1],1);self.sync('A','2',p=1);self.sync('D','0',p=1);self.sync('C','0',p=1)
  self.assertEqual(self.feedback,[(1,'add'),(1,'remove'),(1,'clear')]);s=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8')
  for name in ['QB_AddSound','QB_RemoveSound','QB_ClearSound']:self.assertIn('sound '+name+' = null',s)
  for fn in ['QB_CreateUI','QB_OnSync']:self.assertNotIn('CreateSound',s.split('function '+fn+' takes',1)[1].split('endfunction',1)[0])
 def test_decorations_are_passive_and_inherit_preview_hide(self):
  s=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8')
  for marker in ['QB_PreviewIcon','QB_PreviewEdge','QB_PreviewBolt','QB_PreviewPlate']:self.assertIn('set '+marker+'[i] = QB_Decor(',s)
  self.assertIn('BTNPAS.tga',s);self.assertIn('price-plate.tga',s);self.assertIn('QB_Preview[i], 0.62)',s)
  self.assertIn('call BlzFrameSetEnable(fr, false)',s.split('function QB_Decor takes',1)[1].split('endfunction',1)[0])
 def test_hud_minus_selection_occupancy_version_and_index_guards(self):
  self.goals([5]);g=self.vm.g;g.update(GetHandleId=lambda _:77,BlzGetTriggerFrame=lambda:'minus',BlzGetTriggerFrameEvent=lambda:'click',FRAMEEVENT_CONTROL_CLICK='click',BlzFrameSetFocus=lambda *_:None,UNITSTAT_GetSelected=lambda p:self.units[p])
  g['QB_Frames'][77,0]=400;g['QB_PreviewStep'][0]=1;g['QB_PreviewVersion'][0]=g['QB_Version'][0]
  self.vm.run('QB_ButtonEvent');self.assertTrue(self.messages[-1][1].endswith(',1'))
  self.messages.clear();g['UNITSTAT_GetSelected']=lambda p:self.units[1];self.vm.run('QB_ButtonEvent');self.assertFalse(self.messages)
  g['UNITSTAT_GetSelected']=lambda p:self.units[p];self.units[0]['inv'][0]=6;self.vm.run('QB_ButtonEvent');self.assertFalse(self.messages)
  self.units[0]['inv'][0]=0;g['QB_PreviewVersion'][0]-=1;self.vm.run('QB_ButtonEvent');self.assertFalse(self.messages)
  g['QB_PreviewVersion'][0]=g['QB_Version'][0];g['QB_PreviewStep'][0]=-1;self.vm.run('QB_ButtonEvent');self.assertFalse(self.messages)

class Viewport(unittest.TestCase):
 def test_existing_frames_follow_each_client_right_edge_without_allocations(self):
  for initial,new in [(800,1600),(1920,2560)]:
   vm=ui.load_source('WOSUI.j');g=vm.g;width=[initial];moves=[];layout=[]
   g.update(WUI_ButtonStyle={},GetHandleId=lambda f:f,LoadInteger=lambda t,k,c:t.get((k,c),0),SaveInteger=lambda t,k,c,v:t.update({(k,c):v}),WUI_ScreenRight=lambda:.4+.3*width[0]/900,WUI_Place=lambda *a:moves.append(a),WUI_LayoutMenuDrop=lambda:layout.append('menu'),WUI_LayoutRightColumn=lambda:layout.append('column'),RAbsBJ=abs)
   vm.run('WUI_PlaceRight',('menu',.162,.584,.024,.024));vm.run('WUI_PlaceRight',('history',.090,.584,.024,.024));vm.run('WUI_RefreshViewport');moves.clear();layout.clear()
   vm.run('WUI_RefreshViewport');self.assertFalse(moves);self.assertFalse(layout)
   width[0]=new;vm.run('WUI_RefreshViewport');self.assertEqual(len(moves),2);self.assertAlmostEqual(moves[0][1],.4+.3*new/900-.162);self.assertEqual(layout,['menu','column'])
   vm.run('WUI_PlaceRight',('menu',.094,.584,.054,.015));self.assertEqual(g['WUI_RightDockCount'],2);width[0]+=300;vm.run('WUI_RefreshViewport');self.assertAlmostEqual(moves[-2][1],.4+.3*width[0]/900-.094);self.assertEqual(moves[-2][3:],(.054,.015))
 def test_viewport_refresh_is_presentation_only_existing_timer(self):
  s=(ui.ROOT/'triggers/WOS_Start/WOSUI.j').read_text(encoding='utf-8');body=s.split('function WUI_RefreshViewport takes',1)[1].split('endfunction',1)[0]
  for banned in ['Create','BlzGetFrameByName','BlzGetOriginFrame','ResourceBarFrame','SetUnit','SaveSystem','GetRandom','TimerStart']:self.assertNotIn(banned,body)
  self.assertEqual(s.count('TimerStart(WUI_DockTimer, 0.10'),1)
 def test_save_keys_does_not_call_quickbuy_writer_save_build_still_does(self):
  s=(ui.ROOT/'triggers/WOS_Start/SaveLoad.j').read_text(encoding='utf-8');body=s.split('function SaveSystem_WriteSettingsFile takes',1)[1].split('endfunction',1)[0]
  self.assertNotIn('QB_SaveLocal',body);shop=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8');self.assertIn('call QB_SaveLocal()',shop.split('function QB_OnSync takes',1)[1].split('endfunction',1)[0])

class SaveRequest(previous.SaveRequest):pass
if __name__=='__main__':unittest.main()
