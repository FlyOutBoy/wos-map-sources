"""Execute the actual selected-unit UI callbacks with native mocks, not the game engine."""
from types import SimpleNamespace
import unittest
from test_wos_ui import load_source

class Selection(unittest.TestCase):
 def setUp(self):
  self.vm=load_source('DefaultArmorChangeStable_Copy.j');self.pid=0;self.unit=None;self.local=0;self.render=[]
  self.vm.g.update({'UNITSTAT_PickCount':0,'UNITSTAT_PickFree':0,'bj_MAX_PLAYER_SLOTS':4,'PLAYER_SLOT_STATE_PLAYING':'playing','MAP_CONTROL_USER':'human','UNIT_TYPE_DEAD':'dead','Player':lambda i:i,'GetPlayerId':lambda p:p,'GetTriggerPlayer':lambda:self.pid,'GetTriggerUnit':lambda:self.unit,'GetUnitTypeId':lambda u:u.type if u else 0,'IsUnitSelected':lambda u,p:p in u.selected,'IsUnitHidden':lambda u:u.hidden,'IsUnitType':lambda u,t:u.dead if t=='dead' else False,'GetWidgetLife':lambda u:u.life,'GetPlayerSlotState':lambda p:'playing','GetPlayerController':lambda p:'human','GetLocalPlayer':lambda:self.local,'UNITSTAT_Render':lambda u,p:self.render.append((u,p))})
 def u(self,name):return SimpleNamespace(name=name,type=1,selected=set(),hidden=False,dead=False,life=100.)
 def select(self,p,u):self.pid=p;self.unit=u;u.selected.add(p);self.vm.run('UNITSTAT_OnSelectVoice')
 def deselect(self,p,u):self.pid=p;self.unit=u;u.selected.discard(p);self.vm.run('UNITSTAT_OnDeselectVoice')
 def resolve(self,p):return self.vm.run('UNITSTAT_ResolvePicked',(p,))
 def test_independent_two_players(self):
  a,b=self.u('a'),self.u('b');self.select(0,a);self.select(1,b)
  self.assertIs(self.resolve(0),a);self.assertIs(self.resolve(1),b)
  self.deselect(1,b);self.assertIs(self.resolve(0),a);self.assertIsNone(self.resolve(1))
 def test_multi_fallback_and_voice_original(self):
  a,b=self.u('a'),self.u('b');self.select(0,a);self.select(0,b);self.deselect(0,b)
  self.assertIs(self.resolve(0),a);self.assertIsNone(self.vm.g['UNITSTAT_VoiceUnit'][0])
 def test_deselect_other_does_not_clear_picked(self):
  a,b=self.u('a'),self.u('b');self.select(0,a);self.select(0,b);self.deselect(0,a)
  self.assertIs(self.resolve(0),b);self.assertIs(self.vm.g['UNITSTAT_VoiceUnit'][0],b)
 def test_duplicate_select_no_duplicate_record(self):
  a,b=self.u('a'),self.u('b');self.select(0,a);self.select(0,b);self.select(0,a)
  self.assertEqual(self.vm.g['UNITSTAT_PickCount'],2);self.assertIs(self.resolve(0),a)
  self.deselect(0,a);self.assertIs(self.resolve(0),b)
 def test_removed_without_deselected_prunes_and_reuses(self):
  a,b=self.u('a'),self.u('b');self.select(0,a);a.type=0
  self.assertIsNone(self.resolve(0));self.select(1,b)
  self.assertEqual(self.vm.g['UNITSTAT_PickCount'],1);self.assertIs(self.resolve(1),b)
 def test_hidden_dead_and_unreported_deselection(self):
  a,b=self.u('a'),self.u('b');self.select(0,a);self.select(0,b)
  b.hidden=True;self.assertIs(self.resolve(0),a)
  b.hidden=False;b.dead=True;self.assertIs(self.resolve(0),a)
  b.dead=False;b.life=.4;self.assertIs(self.resolve(0),a)
  b.life=100.;b.selected.clear();self.assertIs(self.resolve(0),a)
  a.selected.clear();self.assertIsNone(self.resolve(0))
 def test_timer_only_renders_matching_player_and_null(self):
  a,b=self.u('a'),self.u('b');self.select(0,a);self.select(1,b)
  for local,u in [(0,a),(1,b),(2,None)]:
   self.local=local;self.render=[];self.vm.run('UNITSTAT_Update');self.assertEqual(self.render,[(u,local)])
 def test_local_delivery_uses_only_ui_state(self):
  a=self.u('a');self.select(0,a);self.local=1
  self.vm.run('UNITSTAT_Update');self.assertEqual(self.render,[(None,1)])
 def test_three_modes_local_geometry_only(self):
  shifts=[];glyphs=[]
  self.vm.g.update({'WUI_HudMode':2,'WUI_HudShift':0.,'WUI_HudLeft':0.,'WUI_SetHud':lambda shift,left:shifts.append((shift,left)),'WUI_SetToggleGlyph':lambda frame,glyph:glyphs.append(glyph),'WUI_Place':lambda *_:None,'BlzFrameSetEnable':lambda *_:None,'BlzFrameSetSize':lambda *_:None,'BlzFrameSetVisible':lambda *_:None,'I2S':str})
  self.pid=1;self.local=0;self.vm.run('UNITSTAT_OnModeClick');self.assertEqual(self.vm.g['WUI_HudMode'],2);self.assertEqual(shifts,[(0.,0.)]);self.assertEqual(self.vm.g['WUI_HudModeOf'][1],3)
  self.local=1
  modes=[]
  for _ in range(3):self.vm.run('UNITSTAT_OnModeClick');modes.append(self.vm.g['WUI_HudMode'])
  self.assertEqual(modes,[1,2,3]);self.assertEqual(len(shifts),4);self.assertEqual(len(glyphs),4)


if __name__ == '__main__':
 unittest.main()
