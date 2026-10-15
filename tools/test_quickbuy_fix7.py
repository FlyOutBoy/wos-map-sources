import unittest
import test_quickbuy_fix6 as prior
import test_wos_ui as ui
class Fix7(prior.Fix6):
 def display(self):return [self.vm.g['QB_DisplayCost'][i] for i in range(len(self.steps()))]
 def test_omitted_cost_excludes_retained_future_children(self):
  self.goals([3]);self.sync('D','0');self.assertEqual(self.steps(),[2,3]);self.assertEqual(self.display(),[200,150]);self.assertEqual(self.costs(),[200,150])
 def test_omitted_part_bought_manually_reduces_remaining_fee(self):
  self.goals([3]);self.sync('D','0');self.units[0]['inv'][0]=1;self.gold[0]=0;self.tick();self.assertEqual(self.steps(),[2,3]);self.assertEqual(self.display(),[200,50]);self.assertFalse(self.adds)
 def test_manually_sold_omitted_part_restores_fee(self):
  self.goals([3]);self.sync('D','0');self.units[0]['inv'][0]=1;self.gold[0]=0;self.tick();self.units[0]['inv'][0]=0;self.tick();self.assertEqual(self.display(),[200,150])
 def test_three_of_four_components_omitted_then_manual_purchase(self):
  self.recipes[7]=[1,2,4,6];self.prices[7]=500;g=self.vm.g;g['QB_Data'][7,0]=True;g['QB_Data'][7,1]=500;g['QB_Data'][7,2]='7';self.goals([7])
  for _ in range(3):self.sync('D','0')
  self.assertEqual(self.steps(),[6,7]);self.assertEqual(self.display(),[60,440]);self.units[0]['inv'][0]=2;self.gold[0]=0;self.tick();self.assertEqual(self.display(),[60,240]);self.assertEqual(sum(self.display()),300)
 def test_nested_deferred_and_reorder_keep_cost(self):
  self.goals([5]);self.sync('D','2');self.assertEqual(self.steps(),[1,2,4,5]);self.assertEqual(self.display(),[100,200,80,90]);self.sync('M','3,0');self.assertEqual(self.steps(),[5,1,2,4]);self.assertEqual(self.display(),[90,100,200,80])
 def test_all_omitted_manual_owned_detail_reduces_actual_total(self):
  self.goals([3]);self.sync('D','0');self.sync('D','0');self.assertEqual(self.display(),[350]);self.units[0]['inv'][0]=1;self.gold[0]=0;self.tick();self.assertEqual(self.display(),[250])
 def test_catalogue_no_visibility_writes_on_identical_repeated_render(self):
  g=self.vm.g;self.rec([1,2]);g['REC_Action'][0]='action';state={};calls=[];g.update(BlzFrameIsVisible=lambda f:state.get(f,False),BlzFrameSetVisible=lambda f,v:(state.update({f:v}),calls.append(f)))
  self.vm.run('REC_Render');calls.clear();self.vm.run('REC_Render');self.assertFalse([f for f in calls if isinstance(f,tuple) and f[0] in ['FRAME_ShopItem','REC_Remove']]);g['ItemsFrameCurrentPage_ID'][0]=1;self.vm.run('REC_Render');self.assertTrue(state[g['FRAME_ShopItem'][34]])
 def test_rec_minus_mirrors_plus_inside_anchor_and_hud_hover_style(self):
  s=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8');self.assertIn('FRAMEPOINT_TOPLEFT, FRAME_ShopItem[i], FRAMEPOINT_TOPLEFT, 0.001, -0.001',s);self.assertIn('WUI_ItemY(i) - 0.0175, 0.014, 0.00525',s)
  f=(ui.ROOT/'assets/UI/WOS/WOSControls.fdf').read_text(encoding='utf-8').split('Frame "SIMPLEBUTTON" "WOSQBHUDRemove" {',1)[1].split('}',1)[0];self.assertIn('AUTOTRACK|HIGHLIGHTONMOUSEOVER',f);self.assertIn('UseHighlight "WOSQBHUDRemoveHover"',f)
if __name__=='__main__':unittest.main()
