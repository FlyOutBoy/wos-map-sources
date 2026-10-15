"""FIX6 actual JASS/native mocks; visual hit testing and multiplayer remain engine checks."""
import unittest,re
import test_quickbuy_fix5 as prior
import test_wos_ui as ui
class Fix6(prior.Fix5):
 def setUp(self):
  super().setUp();g=self.vm.g;g.update(AHUI_RequestCooldownPing=lambda *_:None,AHUI_ReleaseCooldownPing=lambda *_:None);g.update(REC_Hint=None,QB_Hint=None,FRAMEPOINT_TOP='top',FRAMEPOINT_CENTER='centre',ShopDescCount=0,ShopDescOffset=0,FRAME_ShopDescScroll=None,WUI_EMPTY_TEXTURE='empty',WUI_TEXT='',WUI_GOLD='',SHOP_TREE_SLOTS=24,GetSelectedHeroForPlayer=lambda p:self.units[p],BlzFrameSetEnable=lambda *_:None,BlzFrameSetTexture=lambda *_:None,BlzFrameSetText=lambda *_:None)
  self.visible={};self.texts={};g['BlzFrameSetVisible']=lambda f,v:self.visible.update({f:v});g['BlzFrameSetText']=lambda f,t:self.texts.update({f:t});g['BlzFrameIsVisible']=lambda f:self.visible.get(f,True)
  for name in ['FRAME_ShopItem','FRAME_ShopItemBack','FRAME_ShopItemCost','FRAME_ShopItemName','FRAME_ShopItemTooltipBox','FRAME_ShopItemTooltipText','FRAME_ShopItemPricePlate','FRAME_ShopRecipeLine','FRAME_ShopItemInventorySlot']:
   for i in range(80):g[name][i]=(name,i)
 def test_each_hud_minus_matches_own_slot_lower_rim_not_common_strip(self):
  s=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8');self.assertIn('WUI_ItemY(i) - 0.0175, 0.014, 0.00525',s);self.assertIn('WUI_ItemY(i), 0.028, 0.028)',s)
  for i in range(6):
   y=.0625-(i//3)*.035;minus_y=y-.0175;self.assertGreater(minus_y-.00525/2,0)
   self.assertLess(minus_y+.00525/2,y-.028/2)
   if i<3:self.assertGreater(minus_y-.00525/2,y-.035+.028/2)
 def test_layout_all_supported_aspects_reflows_names_and_keeps_footer_in_panel(self):
  g=self.vm.g;source=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8');placed={}
  for array,name in re.findall(r'(?m)^    framehandle (array )?(\w+)\s*(?:=.*)?$',source):g[name]={i:(name,i) for i in range(80)} if array else name
  g.update(WUI_Place=lambda f,x,y,a,z:placed.update({f:(x,y,a,z)}),ShopPlacePrice=lambda *_:None,BlzFrameSetScale=lambda *_:None,BlzFrameSetSize=lambda *_:None,BlzFrameClearAllPoints=lambda *_:None,BlzFrameSetAllPoints=lambda *_:None)
  for aspect in [5/4,4/3,16/9,21/9]:
   g['WUI_ScreenRight']=lambda a=aspect:.4+.3*a;g['QB_Right']=0;placed.clear();self.vm.run('QB_Layout');panel=placed['QB_Panel'];hint=placed['QB_Hint'];status=placed['QB_StateText'];self.assertAlmostEqual(panel[1]-panel[3]/2,.098)
   self.assertAlmostEqual(hint[1],.126);self.assertAlmostEqual(status[1],.107);self.assertGreater(status[1]-.01/2,.098)
   for i in range(15):
    x,y,a,z=placed['QB_Slot',i];shift=self.vm.run('Shop_Shift');self.assertGreaterEqual(x-a/2,g['QB_Left']+shift);self.assertLessEqual(x+a/2,g['QB_Right']+shift);self.assertGreater(y-z/2-.026,.126+.013/2)
   placed.clear();self.vm.run('QB_Layout');self.assertFalse(placed)
 def test_clear_tree_resets_selection_slots_offsets_description_and_controls(self):
  g=self.vm.g
  for name in ['ItemsCurrentItem_ID','ItemsCurrentItem_ID_BACKUP','ItemsCurrentItemBag_ID','ShopCraftUpgradeOffset','ShopCraftComponentOffset','ShopCraftScrollItemId']:g[name][0]=9
  for i in range(24):g['ShopCraftSlotItem'][i]=3
  g['ShopDescCount']=10;g['ShopDescOffset']=3;self.vm.run('ShopClearItemTree',(0,))
  for name in ['ItemsCurrentItem_ID','ItemsCurrentItem_ID_BACKUP','ItemsCurrentItemBag_ID','ShopCraftUpgradeOffset','ShopCraftComponentOffset','ShopCraftScrollItemId']:self.assertEqual(g[name][0],0,name)
  self.assertTrue(all(g['ShopCraftSlotItem'][i]==0 for i in range(24)));self.assertEqual(g['ShopDescCount'],0);self.assertEqual(g['ShopDescOffset'],0)
  for name in ['FRAME_ShopItemCost','FRAME_ShopItemName','FRAME_ShopItemTooltipText']:self.assertEqual(self.texts[g[name][42]],'')
  self.assertFalse(self.visible[g['FRAME_ShopItem'][42]]);self.assertFalse(self.visible[g['FRAME_ShopItemInventorySlot'][6]]);self.assertFalse(self.visible[g['FRAME_ShopItemInventorySlot'][7]])
  for i in range(72):self.assertFalse(self.visible[g['FRAME_ShopRecipeLine'][i]])
 def test_clear_other_player_leaves_local_tree_paint_and_data_unchanged(self):
  g=self.vm.g;g['ItemsCurrentItem_ID'][0]=3;g['ItemsCurrentItem_ID'][1]=5;self.vm.run('ShopClearItemTree',(1,));self.assertEqual(g['ItemsCurrentItem_ID'][1],0);self.assertEqual(g['ItemsCurrentItem_ID'][0],3);self.assertFalse(self.visible);self.assertFalse(self.texts)
 def test_zero_item_does_not_query_bans_recipe_or_object_name(self):
  g=self.vm.g;g['CheckBanItems']=lambda *_:self.fail('zero item ban query');g['ShopTreeNeed']=lambda *_:self.fail('zero recipe query');g['GetObjectName']=lambda *_:self.fail('zero object query');self.vm.run('CraftItemCheck',(0,0,0));self.assertEqual(g['ItemsCurrentItem_ID'][0],0)
 def test_delayed_scroll_packet_cannot_recreate_empty_tree(self):
  g=self.vm.g;g['ItemsCurrentItem_ID'][0]=0;g['BlzGetTriggerSyncData']=lambda:'1';g['CraftItemCheck']=lambda *_:self.fail('empty tree resurrected');g['ShopSaveCraftScrollState']=lambda *_:self.fail('empty scroll cache')
  for prefix in ['WScU','WScC']:g['BlzGetTriggerSyncPrefix']=lambda p=prefix:p;self.vm.run('SyncDataHandler')
 def sell(self,full_refund=False):
  g=self.vm.g;self.units[0]['inv'][0]=1;g['ItemsCurrentItem_ID'][0]=1;g['ItemsCurrentItem_ID_BACKUP'][0]=0;g['ItemsCurrentItemBag_ID'][0]=1
  g.update(BlzGetTriggerFrame=lambda:77,GetHandleId=lambda o:o['pid']+1 if isinstance(o,dict) else o,ShopFrameTable={(77,0):307},ShopFastAction=lambda p,code,id:code,IsObserverSlot=lambda _:False,hs={},StringHash=lambda s:s,MyFlush=lambda *_:None,RemoveSavedInteger=lambda t,k,c:t.pop((k,c),None),RefundPercent=85,RefreshItemCache2=lambda _:None,ReloadItemPage2=lambda *_:None,RemoveItem=lambda it:self.units[0]['inv'].__setitem__(self.units[0]['inv'].index(it),0),GetItemValue=lambda id:self.prices[id] if id else self.fail('looked up sold backup zero'),AddGold=lambda p,c,credit:self.gold.update({p:self.gold[p]+(c if credit else -c)}))
  if full_refund:g['hs'][1,'fullrefund_0']=1
  self.vm.run('OnClickItem')
 def test_fast_sell_clears_tree_without_invalid_backup_lookup(self):
  self.sell();g=self.vm.g;self.assertEqual(self.units[0]['inv'][0],0);self.assertEqual(self.gold[0],3085);self.assertEqual(g['ItemsCurrentItem_ID'][0],0);self.assertEqual(g['ItemsCurrentItem_ID_BACKUP'][0],0);self.assertEqual(g['ItemsCurrentItemBag_ID'][0],0);self.assertFalse(self.visible[g['FRAME_ShopItem'][42]])
 def test_full_refund_sale_preserves_refund_and_clears_tree(self):
  self.sell(True);self.assertEqual(self.gold[0],3100);self.assertEqual(self.vm.g['ItemsCurrentItem_ID'][0],0)
 def test_next_inspection_restores_centre_after_clear(self):
  g=self.vm.g;g.update(ShopTreeNeed=lambda *_:0,ShopTreeNeedDirect=0,ShopTreeFillSide=lambda *_:None,ShopSaveCraftScrollState=lambda *_:None,ShopLoadCraftScrollState=lambda *_:None,ShopUpdateCraftScrollbars=lambda *_:None,ShopShowItemDescription=lambda *_:None,SHOP_TREE_X=.495,SHOP_TREE_ROW=6,GetCraftUpgradeCount=lambda _:0,HasCraftComponents=lambda id:bool(self.recipes.get(id)),IntegerTertiaryOp=lambda c,a,z:a if c else z,BlzFrameClearAllPoints=lambda *_:None,BlzFrameSetAbsPoint=lambda *_:None,BlzFrameSetSize=lambda *_:None)
  self.vm.run('ShopClearItemTree',(0,));self.vm.run('QB_Inspect',(0,3));self.assertEqual(g['ItemsCurrentItem_ID'][0],3);self.assertTrue(self.visible[g['FRAME_ShopItem'][42]]);self.assertTrue(self.visible[g['FRAME_ShopItemPricePlate'][42]]);self.assertFalse(self.adds)
 def test_recommended_drag_hint_only_shows_in_recommended(self):
  g=self.vm.g;g['REC_Action'][0]='action';g['REC_Hint']='rec-hint';self.rec([1,2]);self.vm.run('REC_Render');self.assertTrue(self.visible['rec-hint']);g['ItemsFrameCurrentPage_ID'][0]=1;self.vm.run('REC_Render');self.assertFalse(self.visible['rec-hint']);g['ItemsFrameCurrentPage_ID'][0]=0;g['ShopSearchActive'][0]=True;self.vm.run('REC_Render');self.assertFalse(self.visible['rec-hint'])
 def test_missing_space_label_removed_and_visible_instructions_are_passive(self):
  s=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8');self.assertNotIn('Need space/base',s);self.assertIn('WOSRecommendedDragHint',s);self.assertIn('WOSQuickBuyDragHint',s);self.assertIn('Hold RMB: drag left/right',s)
  body=s.split('function ShopClearItemTree takes',1)[1].split('endfunction',1)[0]
  for token in ['GetItemValue','GetObjectName','CreateItem','CreateUnit','CreateGroup','CreateTimer','TimerStart','BlzCreate','BlzGetFrameByName','GetRandom']:self.assertNotIn(token,body)
class SaveRequest(prior.SaveRequest):pass
if __name__=='__main__':unittest.main()
