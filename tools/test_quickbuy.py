"""Run real Quick Buy JASS bodies; native inventory mocks are not engine tests."""
import re,unittest
from collections import defaultdict
from pathlib import Path
import test_wos_ui as ui
class QuickBuy(unittest.TestCase):
 def setUp(self):
  self.vm=ui.load_source('WoS_Shop_Init.j');g=self.vm.g
  self.recipes={3:[1,2],5:[3,4]};self.prices={1:100,2:200,3:350,4:80,5:470,6:60}
  self.units={p:{'pid':p,'inv':[0]*6,'dead':False,'base':True} for p in range(2)};self.gold={0:3000,1:3000};self.messages=[];self.adds=[]
  def s2i(x):
   try:return int(x)
   except ValueError:return 0
  def put(u,id):
   if 0 in u['inv']:u['inv'][u['inv'].index(0)]=id;self.adds.append((u['pid'],id))
  g.update(QB_Data={},QB_Templates={},QB_Frames={},QB_BuildError=False,QB_BuildPid=0,QB_BuildGroup=0,QB_LocalHeroCount=0,QB_LocalDirty=False,QB_LocalReady=True,QB_LocalSequence=0,QB_Page=0,QB_DragFrom=-1,QB_LastViewVersion=-1,QB_AddAvailable=True,QB_SYNC='WOSQB1',QB_TEXTURE='UI/QuickBuy/qb-',QB_Panel=None,Hero=self.units,GetLocalPlayer=lambda:0,GetTriggerPlayer=lambda:0,IsGamePlayerSlot=lambda p:0<=p<10,GetPlayerId=lambda p:p,Player=lambda p:p,GetObjectName=lambda id:'hero' if id>0 else '',StringLength=len,SubString=lambda s,a,b:s[a:b],S2I=s2i,I2S=str,IMaxBJ=max,IMinBJ=min,UnitItemInSlot=lambda u,i:u['inv'][i] or None,GetItemTypeId=lambda it:it or 0,IsItemInInventory=lambda u,id:u['inv'].count(id),GetCraftComponentCount=lambda id:len(self.recipes.get(id,[])),GetCraftComponent=lambda id,i:self.recipes[id][i],GetItemValue=lambda id:self.prices.get(id,0),GetGold=lambda p:self.gold[p],AddGold=lambda p,c,_:self.gold.update({p:self.gold[p]-c}),GetUnitTypeId=lambda u:u.get('type',123+u['pid']),GetOwningPlayer=lambda u:u['pid'],IsUnitType=lambda u,_:u['dead'],UNIT_TYPE_DEAD='dead',CheckCoordsInRect=lambda _,x,y:bool(x),gg_rct_Base='base',GetUnitX=lambda u:1 if u['base'] else 0,GetUnitY=lambda _:0,CondArena=0,TestMode=False,CheckBanItems=lambda *_:False,CheckSlotAvailable=lambda u:0 in u['inv'],UnitAddItemById=put,StartSoundForPlayerBJ=lambda *_:None,gg_snd_AlchemistTransmuteDeath1='sound',LoadBoolean=lambda t,k,c:t.get((k,c),False),SaveBoolean=lambda t,k,c,v:t.update({(k,c):v}),LoadInteger=lambda t,k,c:t.get((k,c),0),SaveInteger=lambda t,k,c,v:t.update({(k,c):v}),LoadStr=lambda t,k,c:t.get((k,c),''),SaveStr=lambda t,k,c,v:t.update({(k,c):v}),BlzGetAbilityIcon=lambda id:str(id),BlzSendSyncData=lambda prefix,data:self.messages.append((prefix,data)))
  g['CheckItemsReduceCostCraft']=self.reduce
  for id in self.prices:g['QB_Data'][id,0]=True;g['QB_Data'][id,1]=self.prices[id];g['QB_Data'][id,2]=str(id)
  for p in self.units:g['QB_Hero'][p]=123+p
 def reduce(self,u,cost,id,remove):
  used=set()
  def walk(id):
   nonlocal cost
   for child in self.recipes.get(id,[]):
    found=next((i for i,x in enumerate(u['inv']) if x==child and i not in used),None)
    if found is None:walk(child)
    else:
     used.add(found);cost-=self.prices[child]
  walk(id)
  if remove:
   for i in used:u['inv'][i]=0
  return cost
 def goals(self,ids,p=0):
  g=self.vm.g;g['QB_Count'][p]=g['QB_PresetCount'][p]=len(ids)
  for i,id in enumerate(ids):g['QB_Target'][p*6+i]=g['QB_Preset'][p*6+i]=id
  self.vm.run('QB_Rebuild',(p,))
 def steps(self,p=0):
  g=self.vm.g;return [g['QB_Step'][p*128+i] for i in range(g['QB_StepCount'][p])]
 def sync(self,op,data,p=0,version=None,seq=None,hero=None):
  g=self.vm.g;g['GetTriggerPlayer']=lambda:p;g['BlzGetTriggerSyncData']=lambda:f'{op},{hero or g["QB_Hero"][p]},{g["QB_Version"][p] if version is None else version},{g["QB_Sequence"][p]+1 if seq is None else seq},{data}';self.vm.run('QB_OnSync')
 def test_leaf_and_nested_postorder(self):
  self.goals([6]);self.assertEqual(self.steps(),[6]);self.goals([5]);self.assertEqual(self.steps(),[1,2,3,4,5]);self.assertEqual([self.vm.g['QB_Cost'][i] for i in range(5)],[100,200,50,80,40])
 def test_owned_component_reserved_once_and_no_fake_recipe(self):
  self.units[0]['inv'][0]=3;self.goals([5,3]);self.assertEqual(self.steps(),[4,5]);self.assertEqual(self.vm.g['QB_Count'][0],1)
 def test_cycle_stops_before_buy(self):
  self.recipes[3]=[5];self.goals([5]);self.assertEqual(self.vm.g['QB_Status'][0],3);self.vm.run('QB_Tick',(0,self.units[0]));self.assertEqual(self.adds,[])
 def test_wait_gold_preserves_queue(self):
  self.goals([3]);self.gold[0]=0;self.assertTrue(self.vm.run('QB_Tick',(0,self.units[0])));self.assertEqual(self.vm.g['QB_Status'][0],1);self.assertEqual(self.steps(),[1,2,3]);self.assertEqual(self.adds,[])
 def test_full_inventory_waits_without_spend(self):
  self.units[0]['inv']=[6]*6;self.goals([1]);before=self.gold[0];self.vm.run('QB_Tick',(0,self.units[0]));self.assertEqual(before,self.gold[0]);self.assertEqual(self.adds,[])
 def test_recipe_buy_and_advance_one_item_per_tick(self):
  self.goals([5]);g=self.vm.g
  for expected in [1,2,3,4,5]:
   n=len(self.adds);self.assertTrue(self.vm.run('QB_Tick',(0,self.units[0])));self.assertEqual(len(self.adds),n+1);self.assertEqual(self.adds[-1][1],expected)
  self.assertEqual(g['QB_Count'][0],0);self.assertEqual(self.gold[0],2530);self.assertFalse(self.vm.run('QB_Tick',(0,self.units[0])));self.assertEqual(g['QB_Preset'][0],5)
 def test_manual_component_sale_rebuilds_missing_steps(self):
  self.units[0]['inv'][0]=1;self.goals([3]);self.assertEqual(self.steps(),[2,3]);self.units[0]['inv'][0]=0;self.gold[0]=0;self.vm.run('QB_Tick',(0,self.units[0]));self.assertEqual(self.steps(),[1,2,3])
 def test_full_inventory_crafts_with_owned_components(self):
  self.units[0]['inv']=[1,2,6,6,6,6];self.goals([3]);self.assertEqual(self.steps(),[3]);self.vm.run('QB_Tick',(0,self.units[0]));self.assertIn(3,self.units[0]['inv']);self.assertEqual(self.gold[0],2950)
 def test_remove_clear_and_preserve_completed_template(self):
  self.goals([1,2]);self.units[0]['inv'][0]=1;self.vm.run('QB_Rebuild',(0,));self.assertEqual(self.vm.g['QB_Count'][0],1);self.sync('A','6');self.assertEqual([self.vm.g['QB_Preset'][i] for i in range(3)],[1,2,6]);self.sync('D','0');self.assertEqual([self.vm.g['QB_Preset'][i] for i in range(2)],[1,6]);self.sync('C','0');self.assertEqual(self.steps(),[])
 def test_group_reorder_preserves_dependency_order(self):
  self.goals([3,6]);self.sync('M','0,1');self.assertEqual(self.steps(),[6,1,2,3]);self.sync('M','1,0');self.assertEqual(self.steps(),[1,2,3,6])
 def test_sender_hero_version_replay_and_bad_rawcodes(self):
  self.goals([1]);self.sync('A','999');self.assertEqual(self.vm.g['QB_Count'][0],1);self.sync('A','2',hero=999);self.sync('A','2',version=0);self.assertEqual(self.vm.g['QB_Count'][0],1);self.sync('A','2');self.assertEqual(self.vm.g['QB_Count'][0],2);self.sync('A','6',seq=1);self.assertEqual(self.vm.g['QB_Count'][0],2)
 def test_independent_players(self):
  self.goals([1],0);self.goals([2],1);self.sync('C','0',p=0);self.assertEqual(self.steps(1),[2]);self.vm.run('QB_Tick',(1,self.units[1]));self.assertIn(2,self.units[1]['inv']);self.assertEqual(self.units[0]['inv'],[0]*6)
 def test_loading_six_targets_and_missing_extension(self):
  g=self.vm.g;g['QB_Awaiting'][0]=True;self.sync('L','123,1,2,3,4,5,6');self.assertEqual(g['QB_PresetCount'][0],6);self.assertFalse(g['QB_Awaiting'][0]);g['QB_Awaiting'][1]=True;self.sync('L','124,0,0,0,0,0,0',p=1);self.assertFalse(g['QB_Awaiting'][1]);self.assertEqual(self.steps(1),[])
 def test_unknown_hero_assignment_does_not_use_transformed_id(self):
  self.goals([1]);self.vm.g['QB_AssignedUnit'][0]=self.units[0];v=self.vm.g['QB_Version'][0];self.vm.run('QB_OnHero',(0,123));self.assertEqual(self.vm.g['QB_Version'][0],v);self.assertEqual(self.steps(),[1])
 def test_empty_quickbuy_does_not_buy(self):
  self.assertFalse(self.vm.run('QB_Tick',(0,self.units[0])));self.assertEqual(self.adds,[])
 def test_lock_and_await_hold_autobuy(self):
  self.goals([1]);self.sync('B','0');self.vm.run('QB_Tick',(0,self.units[0]));self.assertEqual(self.adds,[]);self.sync('U','0');self.vm.run('QB_Tick',(0,self.units[0]));self.assertEqual(len(self.adds),1);self.vm.g['QB_Awaiting'][1]=True;self.assertTrue(self.vm.run('QB_Tick',(1,self.units[1])))
 def test_price_cache_is_populated_agreed_and_render_never_gets_price(self):
  calls=[];self.vm.g['GetItemValue']=lambda id:calls.append(id) or self.prices[id];self.vm.g['QB_Data']={};self.vm.run('QB_CacheItem',(5,0));self.assertEqual(set(calls),{1,2,3,4,5});source=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8');body=source.split('function QB_RenderLocal',1)[1].split('endfunction',1)[0];self.assertNotIn('GetItemValue(',body);self.assertNotIn('DamageCheck',body)
 def test_horizontal_right_drag_ignores_y_and_commits_once(self):
  self.goals([1,2,6]);g=self.vm.g;coords=[.6895,.352];textures=[]
  g.update(QB_Width=.147,QB_Left=.665,QB_Size=.038,QB_Columns=3,QB_Page=0,QB_DragFrom=-1,QB_DragTo=-1,QB_TEXTURE='qb-',WUI_GOLD='',RAbsBJ=abs,I2R=lambda n:float(int(n)),R2I=int,ModuloInteger=lambda a,b:a%b,Shop_Active={0:True},WUI_TopShown=lambda:True,BlzGetMouseScreenPosX=lambda:coords[0],BlzGetMouseScreenPosY=lambda:coords[1],BlzPixelToFrameX=lambda x:x,BlzPixelToFrameY=lambda y:y,BlzGetTriggerPlayerMouseButton=lambda:'right',MOUSE_BUTTON_TYPE_RIGHT='right',EVENT_PLAYER_MOUSE_MOVE='move',EVENT_PLAYER_MOUSE_UP='up',EVENT_PLAYER_UNIT_PICKUP_ITEM='pickup',EVENT_PLAYER_UNIT_DROP_ITEM='drop',GetTriggerEventId=lambda:'down',BlzFrameSetTexture=lambda *a:textures.append(a),BlzFrameSetText=lambda *_:None,BlzFrameSetVisible=lambda *_:None,WUI_Place=lambda *_:None)
  self.vm.run('QB_OnMouse');self.assertEqual(g['QB_DragFrom'],0);self.assertEqual(len(self.messages),1)
  g['GetTriggerEventId']=lambda:'move';coords[1]=999;self.vm.run('QB_OnMouse');self.assertEqual(g['QB_DragTo'],0)
  coords[0]+=.098;self.vm.run('QB_OnMouse');self.assertEqual(g['QB_DragTo'],2);self.assertEqual(self.steps(),[1,2,6]);self.assertEqual(len(self.messages),1)
  g['GetTriggerEventId']=lambda:'up';self.vm.run('QB_OnMouse');self.assertEqual(g['QB_DragFrom'],-1);self.assertTrue(self.messages[-1][1].endswith('0,2'));self.assertEqual(len(self.messages),2)
 def test_left_drag_and_close_cancel_do_not_change_gameplay(self):
  self.goals([1,2]);g=self.vm.g;g.update(QB_DragFrom=1,QB_DragTo=0,QB_DragVersion=g['QB_Version'][0],QB_Page=0,QB_Width=.147,QB_Columns=3,QB_DragX=.74,RAbsBJ=abs,I2R=lambda n:float(int(n)),R2I=int,Shop_Active={0:True},WUI_TopShown=lambda:True,BlzGetMouseScreenPosX=lambda:.691,BlzPixelToFrameX=lambda x:x,EVENT_PLAYER_MOUSE_MOVE='move',EVENT_PLAYER_UNIT_PICKUP_ITEM='pickup',EVENT_PLAYER_UNIT_DROP_ITEM='drop',GetTriggerEventId=lambda:'move',QB_DragRender=lambda:None)
  self.vm.run('QB_OnMouse');self.assertEqual(g['QB_DragTo'],0);g['Shop_Active'][0]=False;self.vm.run('QB_OnMouse');self.assertEqual(g['QB_DragFrom'],-1);self.assertEqual(self.steps(),[1,2]);self.assertTrue(self.messages[-1][1].endswith(',0'))
 def test_idle_mouse_move_scans_nothing_and_reserves_nothing(self):
  g=self.vm.g;g.update(QB_DragFrom=-1,EVENT_PLAYER_MOUSE_MOVE='move',EVENT_PLAYER_UNIT_PICKUP_ITEM='pickup',EVENT_PLAYER_UNIT_DROP_ITEM='drop',GetTriggerEventId=lambda:'move')
  def forbidden(*_):raise AssertionError('idle mouse processing')
  g['BlzGetMouseScreenPosX']=g['BlzGetMouseScreenPosY']=g['CreateTimer']=forbidden;self.vm.run('QB_OnMouse');self.assertEqual(self.messages,[])
 def test_passive_preview_in_free_slots_and_hides_for_other_selection(self):
  self.goals([1,2,6]);g=self.vm.g;visible={};g.update(QB_Layout=lambda:None,QB_Panel='panel',QB_LastViewVersion=g['QB_Version'][0],QB_LastViewStatus=g['QB_Status'][0],QB_LastViewPage=0,QB_Page=0,QB_DragFrom=-1,UNITSTAT_GetSelected=lambda _:self.units[0],BlzFrameSetVisible=lambda f,v:visible.update({f:v}),BlzFrameSetTexture=lambda *_:None,BlzFrameSetText=lambda *_:None,WUI_GOLD='')
  self.units[0]['inv'][1]=4;self.vm.run('QB_RenderLocal');self.assertTrue(visible[g['QB_Preview'][0]]);self.assertFalse(visible.get(g['QB_Preview'][1],False));self.assertTrue(visible[g['QB_Preview'][2]])
  g['UNITSTAT_GetSelected']=lambda _:self.units[1];self.vm.run('QB_RenderLocal');self.assertTrue(all(not visible.get(g['QB_Preview'][i],False) for i in range(6)))
 def test_real_chunk_codec_roundtrip_and_no_default_overwrite(self):
  import test_saveload as save,json,re
  runtime=save.CareerRuntime();g=self.vm.g
  # Native Preloader accepts both quoted fourcc and numeric carrier identifiers.
  def preload(path):
   script=runtime.disk.get(path,'')
   for code,text in re.findall(r"call BlzSetAbilityTooltip\(('?[A-Za-z0-9]+'?),\"([^\"]*)\",0\)",script):
    id=int.from_bytes(code.strip("'").encode(),'big') if code.startswith("'") else int(code);runtime.tooltips[id,0]=text
  runtime.vm.g['Preloader']=preload
  g.update(SAVE_FOLDER='save/',ss_IdentityKeyA={0:10},ss_IdentityKeyB={0:20},SaveSystem_EnsureIdentity=lambda _:None,SaveSystem_ChunkRead=lambda path:runtime.run('SaveSystem_ChunkRead',path),SaveSystem_ChunkBegin=lambda text:runtime.run('SaveSystem_ChunkBegin',text),SaveSystem_ChunkAdd=lambda text:runtime.run('SaveSystem_ChunkAdd',text),SaveSystem_ChunkFlush=lambda path:runtime.run('SaveSystem_ChunkFlush',path),PreloadGenClear=runtime.vm.g['PreloadGenClear'],PreloadGenStart=runtime.vm.g['PreloadGenStart'])
  self.goals([1,2]);self.vm.run('QB_UpdateTemplate',(0,));self.vm.run('QB_SaveLocal');self.assertEqual(len(runtime.writes),1)
  g['QB_Templates'].clear();g['QB_LocalHeroCount']=0;self.vm.run('QB_LoadLocal');self.assertEqual(g['QB_Templates'][123,0],1);self.assertEqual(g['QB_Templates'][123,1],2)
  self.vm.run('QB_SaveLocal');self.assertEqual(len(runtime.writes),1)
 def test_malformed_build_file_is_not_replaced(self):
  g=self.vm.g;g.update(SaveSystem_ChunkRead=lambda _: 'bad data',QB_FilePath=lambda _: 'path');self.vm.run('QB_LoadLocal');self.assertFalse(g['QB_LocalReady']);g['QB_LocalDirty']=True
  def forbid(*_):raise AssertionError('clobbered malformed file')
  g['PreloadGenStart']=forbid;self.vm.run('QB_SaveLocal')
 def test_no_new_timer_and_gameplay_render_separation(self):
  source=(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8');qb=source.split('function QB_Field',1)[1].split('// Р”РѕР±Р°РІР»СЏРµС‚ РёРіСЂРѕРєСѓ',1)[0];self.assertNotIn('CreateTimer(',qb);self.assertNotIn('TimerStart(',qb);self.assertNotIn('GetRandom',qb)
  for fn in ['QB_RenderLocal','QB_DragPreview','QB_DragRender']:
   body=source.split('function '+fn,1)[1].split('endfunction',1)[0]
   for forbidden in ['CreateUnit(','CreateItem(','UnitAddItem','GetItemValue(','TriggerExecute(','GroupEnum','BlzCreate']:
    self.assertNotIn(forbidden,body)
 def test_bootstrap_frame_pool_and_runtime_no_allocations(self):
  f=ui.DeferredUIStartup();f.setUp();g=self.vm.g
  self.vm.methods.update(f.vm.methods)
  self.vm.text += "\n"+f.vm.text
  for key,val in f.vm.g.items():
   if key not in g:g[key]=val
  for name in f.vm.methods:g[name]=lambda *args,n=name:self.vm.run(n,args)
  for name in ['QB_ClickTrigger','QB_HoverTrigger','QB_MouseTrigger','QB_SyncTrigger']:g[name]=None
  g['QB_LastViewStatus']=-1;g['QB_LastViewPage']=-1
  calls=[];created=[];triggers=[];enabled={};counter=[0];g['BlzFrameGetEnable']=lambda f:enabled.get(f,False)
  def create(*args):
   counter[0]+=1;fr='frame:'+str(counter[0]);created.append((fr,args));return fr
  def event(*args):calls.append(args)
  source=(ui.ROOT/'triggers/WOS_Start/WOSUI.j').read_text(encoding='utf-8')+(ui.ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8')
  for frame in re.findall(r'(?m)^    framehandle (FRAME_\w+)\s*$',source):g.setdefault(frame,'existing:'+frame)
  for constant in set(re.findall(r'\bEVENT_PLAYER_\w+',source)):g[constant]=constant
  for name in set(re.findall(r'\b(Blz\w+)\s*\(',source)):g[name]=lambda *_:None
  g.update(BlzCreateFrameByType=create,BlzCreateFrame=create,BlzCreateSimpleFrame=create,BlzFrameSetEnable=lambda fr,v:enabled.update({fr:v}),BlzGetLocalClientWidth=lambda:1920,BlzGetLocalClientHeight=lambda:1080,RMaxBJ=max,RMinBJ=min,RAbsBJ=abs,I2R=lambda n:float(int(n)),R2I=int,ModuloInteger=lambda a,b:a%b,SaveFrameHandle=lambda t,k,c,v:t.update({(k,c):v}),LoadFrameHandle=lambda t,k,c:t.get((k,c)),CreateTrigger=lambda:triggers.append(object()) or triggers[-1],InitHashtable=dict,GetHandleId=lambda x:hash(str(x)),TriggerAddAction=lambda *_:None,TriggerRegisterPlayerEvent=event,TriggerRegisterPlayerUnitEvent=event,BlzTriggerRegisterPlayerSyncEvent=event,BlzTriggerRegisterFrameEvent=event,QB_LoadLocal=lambda:None,Hero=defaultdict(lambda:None),WUI_Root='root',WUI_FrameDefinitionsReady=True,ShopSearchIndexCount=0,WUI_ShiftTable={},Shop_Active=defaultdict(bool),UNITSTAT_GetSelected=lambda _:None)
  g['BlzGetFrameByName']=lambda *_:'existing-native-child'
  self.vm.run('QB_CreateUI');self.assertEqual(len(created),745);self.assertEqual(len(triggers),4)
  for i in range(6):
   for child in ['QB_PreviewIcon','QB_PreviewPrice','QB_PreviewPlate','QB_PreviewEdge']:self.assertFalse(enabled[g[child][i]])
   self.assertFalse(enabled[g['QB_PreviewRemove'][i]])
  def forbid(*_):raise AssertionError('runtime allocation')
  for name in ['BlzCreateFrame','BlzCreateFrameByType','BlzGetFrameByName','BlzGetOriginFrame','BlzFrameGetChild','BlzFrameGetParent','CreateTrigger','CreateTimer']:g[name]=forbid
  self.vm.run('QB_RenderLocal');self.vm.run('QB_DragRender')
  viewport=[1920,1080];moves=[]
  g['BlzGetLocalClientWidth']=lambda:viewport[0];g['BlzGetLocalClientHeight']=lambda:viewport[1];g['I2R']=lambda n:float(int(n));g['BlzFrameSetAbsPoint']=lambda *a:moves.append(a)
  for width,height in [(1024,768),(1280,1024),(1920,1080),(2560,1080)]:
   viewport[:]=[width,height];self.vm.run('QB_Layout');self.assertLessEqual(g['QB_Right'],.4+.3*width/height-.012+.0001)
   for i in range(g['QB_ViewCount']):
    x=self.vm.run('QB_SlotX',(i,));y=self.vm.run('QB_SlotY',(i,));self.assertGreaterEqual(x-g['QB_Size']*.5,g['QB_Left']);self.assertLessEqual(x+g['QB_Size']*.5,g['QB_Right']);self.assertGreaterEqual(y-g['QB_Size']*.5,.164-1e-6)
   moves.clear();self.vm.run('QB_Layout');self.assertEqual(moves,[])

 def test_empty_build_ack_preserves_forced_opening_purchase_once(self):
  g=self.vm.g;g.update(QB_AnyFirstDeferred=False,QB_Awaiting={0:True},Round1Started=1,CurrentRound=1,TestMode=False,SHOP_FIRST_ROUND_BUY_LIMIT=2)
  g['ItemsPage0_ID'][0]=1;self.vm.run('FirstRoundAutoBuyOnce',(self.units[0],0));self.assertEqual(self.adds,[]);self.assertTrue(g['QB_FirstDeferred'][0]);g['QB_Awaiting'][0]=False;self.vm.run('QB_RunDeferredFirst');self.assertEqual(self.adds,[(0,1)]);self.vm.run('QB_RunDeferredFirst');self.assertEqual(self.adds,[(0,1)])
 def test_add_after_completed_six_preserves_build_until_explicit_edit(self):
  self.goals([1,2,3,4,5,6]);g=self.vm.g;g['QB_Count'][0]=0;g['QB_StepCount'][0]=0;g['QB_Data'][7,0]=True;g['QB_Data'][7,1]=10;self.prices[7]=10;self.sync('A','7');self.assertEqual(g['QB_PresetCount'][0],6);self.assertIn(7,[g['QB_Preset'][i] for i in range(6)]);self.assertEqual(self.steps(),[7])
 def test_original_pick_keys_and_swap_assignment_hooks(self):
  pick=(ui.ROOT/'triggers/WOS_Start/WoS_Pick_Init.j').read_text(encoding='utf-8')
  self.assertIn('call QB_OnHero(pid, PlayerFrameCurrent_ID[pid])',pick)
  self.assertIn('call QB_OnHero(pid, id)',pick)
  captain=(ui.ROOT/'triggers/WOS_Start/Captain_Draft.j').read_text(encoding='utf-8')
  self.assertIn('call QB_OnHero.evaluate(pid, heroId)',captain)
  swap=(ui.ROOT/'triggers/WOS_Start/WoS_Hero_Icons_Init.j').read_text(encoding='utf-8')
  self.assertIn('set qbHeroA = QB_Hero[pid]',swap)
  self.assertIn('set qbHeroB = QB_Hero[pid2]',swap)
  self.assertIn('call QB_OnHero.evaluate(pid, qbHeroB)',swap)
  self.assertIn('call QB_OnHero.evaluate(pid2, qbHeroA)',swap)
  self.assertLess(swap.index('set qbHeroA = QB_Hero[pid]'),swap.index('call QB_OnHero.evaluate(pid, qbHeroB)'))
 def test_truncated_saved_build_is_never_overwritten(self):
  g=self.vm.g;g.update(SAVE_FOLDER='save/',ss_IdentityKeyA={0:10},ss_IdentityKeyB={0:20},SaveSystem_EnsureIdentity=lambda _:None,SaveSystem_ChunkRead=lambda _:"QB1|123,1,2,0,0,0,0")
  self.vm.run('QB_LoadLocal');self.assertFalse(g['QB_LocalReady']);g['QB_LocalDirty']=True
  g['PreloadGenClear']=lambda:(_ for _ in ()).throw(AssertionError('damaged file overwritten'))
  self.vm.run('QB_SaveLocal')
if __name__=='__main__':unittest.main()
