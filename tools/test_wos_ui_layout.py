"""Folded menu footprint, independent clients and reuse of owner-meter frames."""
import unittest
import test_wos_ui as ui
import test_wos_ui_multiplayer as multi
class Layout(unittest.TestCase):
 def client(self,pid):
  helper=multi.MultiplayerFrames();helper._testMethodName='runTest';f,_,v=helper.client(pid);g=f.vm.g;points={};sizes={}
  g['WUI_System']={i:'native-system'+str(i) for i in range(4)}
  g['BlzFrameSetAbsPoint']=lambda fr,pt,x,y:points.update({(fr,pt):(x,y)})
  g['BlzFrameSetSize']=lambda fr,x,y:sizes.update({fr:(x,y)})
  return f,v,points,sizes
 def test_discord_ghost_inherits_info_preferences_and_stays_released(self):
  f=ui.DeferredUIStartup();f.setUp();f.vm.run('WUI_Bootstrap');g=f.vm.g
  ghost=g['WUI_Ghost'][2];owner=g['WUI_InfoOwner']
  self.assertIn(('BlzFrameSetParent',(ghost,owner)),f.calls)
  g.update(GetLocalPlayer=lambda:0,GetPlayerId=lambda p:p)
  for hidden in [True,False,True]:
   g['WUI_InfoHiddenOf'][0]=hidden;f.calls.clear();f.vm.run('WUI_ApplyPanelPreferences')
   self.assertIn(('visible',(owner,not hidden)),f.calls)
   self.assertNotIn(('visible',(ghost,True)),f.calls)
  f.vm.run('WUI_ReleaseGhost',(1,));self.assertIn(('visible',(ghost,False)),f.calls)
  f.calls.clear();g['WUI_InfoHiddenOf'][0]=False;f.vm.run('WUI_ApplyPanelPreferences')
  self.assertNotIn(('visible',(ghost,True)),f.calls)
 def test_solo_restart_not_hidden_by_top_ui(self):
  f=ui.DeferredUIStartup();f.setUp();g=f.vm.g
  g['GetPlayerSlotState']=lambda p:'playing' if p==('player',0) else 'empty'
  # Distinct template instances: the base fixture otherwise aliases text buttons.
  create=f.create_frame;counter=[0]
  def unique(*args):
   counter[0]+=1;return create(*args)+':'+str(counter[0])
  g['BlzCreateFrame']=lambda name,parent,*args:unique('FRAME',name,parent,*args)
  f.vm.run('WUI_Bootstrap');restart=g['WUI_Restart'];self.assertIsNotNone(restart)
  self.assertNotIn(restart,[g['WUI_TopControl'][i] for i in range(1,g['WUI_TopControlCount']+1)])
  f.calls.clear()
  for shown in [False,True,False]:f.vm.run('WUI_ShowTopControls',(shown,))
  self.assertNotIn(('visible',(restart,False)),f.calls)
 def test_initial_menu_clears_inherited_label_anchors_and_matches_restored_mode(self):
  f=ui.DeferredUIStartup();f.setUp();f.vm.run('WUI_Bootstrap');g=f.vm.g
  clear=('BlzFrameClearAllPoints',(g['WUI_MenuLabel'],))
  self.assertIn(clear,f.calls)
  def last(name,frame):return next(args for n,args in reversed(f.calls) if n==name and args[0]==frame)
  before={name:last(name,g['WUI_MenuLabel']) for name in ['BlzFrameSetPoint','BlzFrameSetSize','BlzFrameSetScale']}
  f.vm.run('WUI_LayoutPersistentMenu',(False,));f.vm.run('WUI_LayoutPersistentMenu',(True,))
  after={name:last(name,g['WUI_MenuLabel']) for name in before}
  self.assertEqual(before,after)
  self.assertEqual(before['BlzFrameSetPoint'],(g['WUI_MenuLabel'],'FRAMEPOINT_CENTER',g['WUI_Menu'],'FRAMEPOINT_CENTER',0.,-.0135))
 def test_folded_menu_flush_to_both_buttons_and_full_mode_restores_old_layout(self):
  f,v,p,s=self.client(0);g=f.vm.g
  for folded in [True,False,True,False]:
   if g['WUI_MenuOpen']:f.vm.run('WUI_ControlClick')
   f.vm.run('WUI_ShowTopControls',(not folded,));g['GetTriggerPlayer']=lambda:0;g['BlzGetTriggerFrame']=lambda:g['WUI_Menu'];f.vm.run('WUI_ControlClick')
   right=g['WUI_ScreenRight']();left=right-(.122 if folded else .180);edge=right-(.006 if folded else 0);top=.5785 if folded else .540
   for fr in [g['WUI_MenuDrop'],g['WUI_MenuDropMetal']]:
    self.assertAlmostEqual(p[fr,'FRAMEPOINT_BOTTOMLEFT'][0],left);self.assertAlmostEqual(p[fr,'FRAMEPOINT_TOPRIGHT'][0],edge);self.assertAlmostEqual(p[fr,'FRAMEPOINT_TOPRIGHT'][1],top)
   for i in range(3):
    self.assertAlmostEqual(s[g['WUI_System'][i]][0],.086 if folded else .150)
    self.assertAlmostEqual(s[g['WUI_MenuSkin'][i]][0],.096 if folded else .160)
    self.assertAlmostEqual(p[g['WUI_System'][i],'FRAMEPOINT_CENTER'][1],top-.0115-i*.023)
 def test_open_menu_then_return_ui_places_test_commands_under_restored_menu(self):
  f,v,p,s=self.client(0);g=f.vm.g
  g['WUI_TestEnabled']=True
  for key in ['WUI_TestToggle','WUI_TestPanel','WUI_TestText','WUI_TestSlider','WUI_TestPageLabel','WUI_TestPrevious','WUI_TestNext']:g[key]='unique:'+key
  f.vm.run('WUI_ShowTopControls',(False,));g['WUI_MenuOpen']=True
  f.vm.run('WUI_LayoutMenuDrop')
  f.vm.run('WUI_ShowTopControls',(True,))
  self.assertTrue(g['WUI_MenuOpen']);self.assertTrue(v[g['WUI_TestToggle']])
  bottom=f.vm.run('WUI_MenuDropBottom')
  self.assertAlmostEqual(p[g['WUI_TestToggle'],'FRAMEPOINT_CENTER'][1]+s[g['WUI_TestToggle']][1]*.5,bottom)
  self.assertLess(p[g['WUI_TestPanel'],'FRAMEPOINT_CENTER'][1],bottom)
 def test_two_clients_keep_independent_menu_geometry_without_first_getters(self):
  a,_,ap,_=self.client(0);b,_,bp,_=self.client(1)
  a.vm.run('WUI_ShowTopControls',(False,));b.vm.run('WUI_ShowTopControls',(True,))
  self.assertAlmostEqual(ap[a.vm.g['WUI_MenuDropMetal'],'FRAMEPOINT_TOPRIGHT'][1],.5785)
  self.assertAlmostEqual(bp[b.vm.g['WUI_MenuDropMetal'],'FRAMEPOINT_TOPRIGHT'][1],.540)
 def test_hover_uses_folded_rows_not_old_region(self):
  f,_,_,_=self.client(0);g=f.vm.g;f.vm.run('WUI_ShowTopControls',(False,));g['WUI_MenuOpen']=True;changes=[]
  g.update(BlzPixelToFrameX=lambda _:g['WUI_ScreenRight']()-.064,BlzPixelToFrameY=lambda _:.567,BlzFrameSetTexture=lambda *a:changes.append(a))
  f.vm.run('WUI_RefreshMenuSkins');self.assertIn((g['WUI_MenuSkinFill'][0],'UI\\WOS\\fill-hover-blue.tga',0,True),changes)
 def test_meter_stack_snaps_down_and_back_other_dock_kinds_unchanged(self):
  f=ui.DynamicHeroAndBuffDocks();f.setUp();g=f.vm.g
  for name in ['meter0','meter1','meter2']:f.register(name)
  f.register('other-client',owner=1);f.register('buff',kind=1);f.register('public',owner=-1,kind=2)
  f.vm.run('WUI_RefreshDocks');buff=f.positions['buff'];public=f.positions['public']
  g['WUI_MinimapHiddenOf'][0]=True;f.vm.run('WUI_RefreshDocks')
  for i in range(3):
   self.assertAlmostEqual(f.positions['meter'+str(i)][1],.016+i*.030)
   self.assertAlmostEqual(f.positions['meter'+str(i)][0],.085)
  self.assertEqual(f.positions['buff'],buff);self.assertEqual(f.positions['public'],public);self.assertNotIn('other-client',f.positions)
  g['WUI_MinimapHiddenOf'][0]=False;f.vm.run('WUI_RefreshDocks')
  for i in range(3):self.assertAlmostEqual(f.positions['meter'+str(i)][1],.162+i*.030)
 def test_minimap_preference_of_other_player_does_not_move_local_meters(self):
  f=ui.DynamicHeroAndBuffDocks();f.setUp();f.register('meter');f.vm.g['WUI_MinimapHiddenOf'][1]=True;f.vm.run('WUI_RefreshDocks');self.assertAlmostEqual(f.positions['meter'][1],.162)
if __name__=='__main__':unittest.main()

