"""Behavioral coverage for the October UI follow-up (engine rendering is external)."""
from collections import defaultdict
from pathlib import Path
import json
import re
import unittest

import test_wos_ui as ui
from test_crocodile import JassState

ROOT = Path(__file__).resolve().parents[1]


class Progress(unittest.TestCase):
    def setUp(self):
        self.vm = ui.load_source('WOSUI.j')
        self.local = 0
        self.visible, self.values, self.texts, self.created, self.registered = {}, {}, {}, [], []
        self.hero = self.vm.unit(owner=0)
        g = self.vm.g
        def create(*args):
            frame = 'progress:' + str(len(self.created))
            self.created.append(frame)
            return frame
        g.update(WUI_Ready=True, WUI_Root='root', Hero=defaultdict(lambda: None, {0: self.hero}),
                 Player=lambda p: p, GetPlayerId=lambda p: p, GetLocalPlayer=lambda: self.local,
                 GetOwningPlayer=lambda u: u.owner, IsUnitType=lambda u, _: u.life <= 0,
                 GetWidgetLife=lambda u: u.life, UNIT_TYPE_DEAD='dead',
                 WUI_Window=create, BlzCreateFrameByType=create, BlzGetAbilityIcon=lambda a: str(a),
                 I2R=float, StringLength=len, BlzFrameSetScale=lambda *_: None, WUI_Pin=lambda *_: None,
                 BlzFrameSetTexture=lambda *_: None, BlzFrameSetEnable=lambda *_: None, WUI_HeroMeter=lambda *_: None,
                 BlzFrameIsVisible=lambda f: self.visible.get(f, False),
                 WUI_RegisterMeter=lambda *a: self.registered.append(a),
                 BlzFrameSetVisible=lambda f, v: self.visible.update({f: v}),
                 BlzFrameSetText=lambda f, v: self.texts.update({f: v}),
                 BlzFrameSetMinMaxValue=lambda *_: None,
                 BlzFrameSetValue=lambda f, v: self.values.update({f: v}),
                 R2SW=lambda v, _, n: f'{v:.{n}f}', I2S=str, R2I=int, hs={}, StringHash=lambda s: s)

    def show(self, remaining=4, total=5, aid=10):
        self.vm.run('WUI_HeroProgress', (self.hero, aid, 'Ability', remaining, total, True))
        index = self.vm.g['WUI_ProgressKeys'][0, aid]
        return index, self.vm.g['WUI_ProgressPanel'][index]

    def test_recast_reuses_handles_and_interruption_hides_within_three_ticks(self):
        index, panel = self.show()
        allocated = len(self.created)
        self.assertTrue(self.visible[panel])
        self.show(2)
        self.assertEqual(allocated, len(self.created))
        self.assertEqual(1, len(self.registered))
        for _ in range(3):
            self.vm.run('WUI_ExpireProgress')
        self.assertFalse(self.visible[panel])
        self.show()
        self.assertTrue(self.visible[panel])
        self.assertEqual(allocated, len(self.created))

    def test_other_client_allocates_same_frames_but_never_sees_owner_meter(self):
        self.local = 1
        _, panel = self.show()
        self.assertEqual(6, len(self.created))
        self.assertFalse(self.visible[panel])
        self.assertFalse(self.values)

    def test_death_replacement_and_origin_hide_do_not_leave_visible_meter(self):
        _, panel = self.show()
        self.hero.life = 0
        self.vm.run('WUI_ExpireProgress')
        self.assertFalse(self.visible[panel])
        self.hero.life = 100
        self.show()
        self.vm.g['Hero'][0] = self.vm.unit(owner=0, x=999)
        self.vm.run('WUI_ExpireProgress')
        self.assertFalse(self.visible[panel])
        self.vm.g['Hero'][0] = self.hero
        self.vm.g['WUI_OriginHidden'] = True
        self.show()
        self.assertFalse(self.visible[panel])

    def test_fixed_window_uses_ui_clock_and_stops_when_real_buff_or_subject_ends(self):
        self.vm.add_ability(self.hero, 20)
        self.vm.run('WUI_HeroDuration', (self.hero, 10, 'Buff', 2., 20, '', self.hero))
        index = self.vm.g['WUI_ProgressKeys'][0, 10]
        for _ in range(6):
            self.vm.run('WUI_ExpireProgress')
        self.assertAlmostEqual(1.4, self.vm.g['WUI_ProgressTime'][index])
        self.vm.remove_ability(self.hero, 20)
        self.vm.run('WUI_ExpireProgress')
        self.assertFalse(self.visible[self.vm.g['WUI_ProgressPanel'][index]])
        clone = self.vm.unit(owner=0)
        self.vm.run('WUI_HeroDuration', (self.hero, 10, 'Buff', 2., 0, '', clone))
        clone.life = 0
        self.vm.run('WUI_ExpireProgress')
        self.assertEqual(0, self.vm.g['WUI_ProgressTime'][index])

    def test_consumed_enhanced_q_key_hides_window_without_gameplay_writes(self):
        self.vm.g['hs'][id(self.hero), 'rev q'] = 1
        self.vm.run('WUI_HeroDuration', (self.hero, 10, 'Q window', 5., 0, 'rev q', self.hero))
        self.vm.g['hs'][id(self.hero), 'rev q'] = 0
        self.vm.run('WUI_ExpireProgress')
        self.assertEqual({(id(self.hero), 'rev q'): 0}, self.vm.g['hs'])
        self.assertFalse(self.visible[self.vm.g['WUI_ProgressPanel'][1]])


class Guide(unittest.TestCase):
    def setUp(self):
        from collections import defaultdict
        self.vm = ui.load_source('SaveLoad.j')
        self.local = self.sender = 0
        self.visible = False
        self.file = ''
        self.packet = ''
        self.writes, self.sent, self.closed, self.texts = [], [], [], []
        def write(path):
            self.file = self.buffer
            self.writes.append((path,self.file))
        self.vm.g.update(ss_HelpPanel='guide',ss_HelpCountdown='countdown',ss_SettingsReadReady=True,
            Hero=defaultdict(lambda:None,{0:self.vm.unit(owner=0),1:self.vm.unit(owner=1)}),
            GetLocalPlayer=lambda:self.local,GetTriggerPlayer=lambda:self.sender,GetPlayerId=lambda p:p,Player=lambda p:p,
            SaveSystem_ChunkRead=lambda p:self.file,SaveSystem_ChunkBegin=lambda s:setattr(self,'buffer',s),
            SaveSystem_ChunkFlush=write,PreloadGenClear=lambda:None,PreloadGenStart=lambda:None,
            BlzSendSyncData=lambda *a:self.sent.append(a),BlzGetTriggerSyncData=lambda:self.packet,
            WUI_EnterExclusiveWindow=lambda k:self.closed.append(k),
            BlzFrameSetText=lambda f,s:self.texts.append(s),
            BlzFrameSetVisible=lambda f,v:setattr(self,'visible',v),BlzFrameIsVisible=lambda f:self.visible,I2S=str,R2I=int,
            WUI_ResetClickedButtonFocus=lambda:None)
    def status(self,pid,data):
        self.sender,self.packet=pid,data
        self.vm.run('SaveSystem_HelpSync')
    def bootstrap(self):
        self.vm.run('SaveSystem_HelpTick')
        self.assertEqual('WOS2GUIDE',self.sent[-1][0])
        self.status(self.local,self.sent[-1][1])
    def test_first_visit_syncs_marker_and_times_out_at_twenty_seconds(self):
        self.bootstrap();self.vm.run('SaveSystem_HelpTick')
        self.assertTrue(self.visible)
        self.assertEqual([('Wos2\\playedonce.txt','1')],self.writes)
        self.assertEqual(40.,self.vm.g['ss_HelpLeft'][0])
        for _ in range(160):self.vm.run('SaveSystem_HelpTick')
        self.assertFalse(self.visible)
        for _ in range(120):self.vm.run('SaveSystem_HelpTick')
        self.assertEqual(1,len(self.writes));self.assertEqual([],self.closed)
    def test_marker_one_skips_auto_show_independently_of_career_games(self):
        self.file='1';self.vm.g['ss_LocalGames']=0
        self.bootstrap();self.vm.run('SaveSystem_HelpTick');self.assertFalse(self.visible)
        self.assertEqual([],self.writes)
        self.file='';self.vm.g['ss_LocalGames']=200
        self.vm.g['ss_HelpMarkerRead']=False
        self.bootstrap();self.vm.run('SaveSystem_HelpTick');self.assertTrue(self.visible)
    def test_manual_chat_shared_state_and_close_request_is_authenticated(self):
        self.sender=1;self.vm.run('SaveSystem_HelpChat')
        self.assertTrue(self.vm.g['ss_HelpOpen'][1]);self.assertFalse(self.visible)
        self.sender=0
        for _ in range(2):
            self.vm.run('SaveSystem_HelpChat');self.assertTrue(self.visible)
            self.vm.run('SaveSystem_HelpClick')
            self.assertEqual(('WOS2GUIDE','C'),self.sent[-1])
            self.assertTrue(self.vm.g['ss_HelpOpen'][0])
            self.status(0,'C');self.assertFalse(self.visible)


class WindowsAndCapture(unittest.TestCase):
    def test_exclusive_callbacks_close_other_windows_and_owner_escape_closes_all(self):
        vm=ui.load_source('WOSUI.j');actions=[]
        vm.g.update(WUI_AcceptKeyDown=lambda:True,GetLocalPlayer=lambda:0,GetTriggerPlayer=lambda:0,
            BlzSendSyncData=lambda *a:actions.append(a),BlzGetTriggerSyncData=lambda:'-1',
            WUI_CloseMenuDrop=lambda:actions.append('menu'),
            TriggerExecute=lambda *_:self.fail('no callback dispatch'))
        vm.g['WUI_CaptureChannel'][0]=-1;vm.g['WUI_SlotCapture'][0]=-1
        for name in ['Shop_Active','WOS_STATS_IsOpen','lmpVisible','ss_HelpOpen']:vm.g[name][0]=True
        vm.run('WUI_OnWindowEscape');self.assertEqual([('WUIWCLOSE','-1'),'menu'],actions)
        vm.run('WUI_OnExclusiveCloseSync')
        for name in ['Shop_Active','WOS_STATS_IsOpen','lmpVisible','ss_HelpOpen']:self.assertFalse(vm.g[name][0])

    def test_second_capture_cancels_previous_family_without_changing_bindings(self):
        from test_wos_ui_checkpoint21 import Hotkeys
        f = Hotkeys()
        f.setUp()
        vm = f.vm
        removed = []
        vm.g['DestroyTrigger'] = removed.append
        vm.g.update({f'OSKEY_{k}': k for k in 'QWERTFG'})
        vm.g['OSKEY_BACKSPACE'] = 'backspace'
        vm.run('WUI_OnHotkeyBadge')
        old = vm.g['WUI_CaptureTrigger'][3]
        vm.run('WUI_StartSlotCapture', (3, 1))
        self.assertIn(old, removed)
        self.assertEqual(-1, vm.g['WUI_CaptureChannel'][3])
        self.assertEqual(1, vm.g['WUI_SlotCapture'][3])
        old = vm.g['WUI_SlotCaptureTrigger'][3]
        vm.run('WUI_OnHotkeyBadge')
        self.assertIn(old, removed)
        self.assertEqual(-1, vm.g['WUI_SlotCapture'][3])
        self.assertEqual(0, vm.g['WUI_CaptureChannel'][3])
        self.assertEqual('Z', vm.run('WUI_GetHotkey', (0, 3)))

    def test_hidden_empty_cells_are_restored_but_hide_ui_is_respected(self):
        vm = ui.load_source('WOSUI.j')
        visible = defaultdict(bool)
        vm.g.update(WUI_NativeReady=True, WUI_SimpleRoot='console', WUI_CompactCommands=True,
                    BlzFrameIsVisible=lambda f: visible[f],
                    BlzFrameSetVisible=lambda f, v: visible.update({f: v}))
        for i in range(7):
            vm.g['WUI_EmptyAbility'][i] = 'a' + str(i)
            if i < 6:
                vm.g['WUI_EmptyItem'][i] = 'i' + str(i)
        vm.run('WUI_RestoreEmptyCells')
        self.assertTrue(all(visible.values()))
        self.assertEqual(14, len(visible))
        visible.clear()
        vm.g['WUI_OriginHidden'] = True
        vm.run('WUI_RestoreEmptyCells')
        self.assertFalse(visible)

    def test_shared_shop_close_updates_all_peers_and_only_owner_draws(self):
        for local in (0,1):
            vm=ui.load_source('WOSUI.j');visible={'shop':True}
            vm.g.update(GetLocalPlayer=lambda:local,BlzFrameSetVisible=lambda f,v:visible.update({f:v}))
            vm.g['WUI_WindowPart'][0]='shop';vm.g['Shop_Active'][0]=True
            vm.run('WUI_EnterExclusiveWindow',(1,0))
            self.assertFalse(vm.g['Shop_Active'][0]);self.assertEqual(local!=0,visible['shop'])

    def test_window_sync_rejects_malformed_data_and_does_not_allocate_handles(self):
        vm=ui.load_source('WOSUI.j');data=['0'];calls=[]
        vm.g.update(BlzGetTriggerSyncData=lambda:data[0],GetTriggerPlayer=lambda:2,
            WUI_EnterExclusiveWindow=lambda *a:calls.append(a),
            CreateTrigger=lambda:self.fail('allocation in sync callback'))
        for packet in ('', 'junk', '00', '0', '3', '16', '1,0'):
            data[0]=packet;vm.run('WUI_OnExclusiveCloseSync')
        self.assertFalse(calls)
        data[0]='-1';vm.run('WUI_OnExclusiveCloseSync')
        self.assertEqual([(-1,2)],calls)

    def test_crocodile_t_reads_real_channel_then_ten_second_window(self):
        from test_crocodile_main_integration import MainIntegration
        f = MainIntegration()
        self.addCleanup(f.doCleanups)
        f.setUp()
        f.fixture.start()
        f.step(2)
        ability = f.vm.g['CrocodileT_ID']
        first = [p for p in f.vm.progress_calls if p[1] == ability][0]
        self.assertAlmostEqual(f.vm.g['CrocodileT_Duration'], first[3])
        f.step(145)
        last = [p for p in f.vm.progress_calls if p[1] == ability][-1]
        self.assertAlmostEqual(10, last[4])
        self.assertGreater(last[3], 9)
        self.assertLessEqual(last[3], 10)


class SourceContracts(unittest.TestCase):
    def test_every_hero_has_sourced_anime_title_and_generated_app_icon_is_installed(self):
        titles = json.loads((ROOT / 'assets/UI/WOS/hero-anime.json').read_text(encoding='utf-8'))
        self.assertEqual(33, len(titles))
        source = (ROOT / 'triggers/WOS_Start/WoS_Pick_Init.j').read_text(encoding='utf-8-sig')
        for info in titles:
            name = info["hero"]
            self.assertIn('hero == "' + name + '"', source)
            self.assertTrue(info['source'].startswith('https://'))
        from install_wos_ui_assets import ASSET_NAMES
        self.assertIn('wos-app-link', ASSET_NAMES)
        self.assertGreater((ROOT / 'assets/UI/WOS/wos-app-link.tga').stat().st_size, 10000)

    def test_all_requested_timed_heroes_have_real_loop_hooks_and_no_hero_mouse_changes(self):
        names = ['Neuvillette', 'Patriot', 'Harribel', 'Bambietta', 'Natsu', 'Akainu', 'Crocodile',
                 'Kenjaku', 'Tomioka', 'Inori', 'Tsuna', 'Takeshi', 'DarkShiki', 'Rimuru', 'Asta', 'Ainz', 'Frieren', 'Milim']
        for name in names:
            s = (ROOT / f'triggers/Heroes/{name}.j').read_text(encoding='utf-8-sig')
            self.assertIn('call WUI_HeroProgress(', s, name)
        s = (ROOT / 'triggers/WOS_Start/ShowCD.j').read_text(encoding='utf-8-sig')
        hit = s.split('function AHUI_CooldownPingCommandAt takes', 1)[1].split('endfunction', 1)[0]
        self.assertIn('exitwhen slot >= AHUI_SLOT_COUNT', hit)
        dmg = (ROOT / 'triggers/Systems/DmgSys.j').read_text(encoding='utf-8-sig')
        invul = dmg.split('SH_DmgSys_RIMURU_R3_INVUL) == 1 then', 1)[1].split('elseif', 1)[0]
        self.assertIn('set dmg = 0', invul)
        self.assertNotIn('ApplyFullDamageShield', invul)


if __name__ == '__main__':
    unittest.main()
