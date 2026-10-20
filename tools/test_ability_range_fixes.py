"""Regression paths for TEST countdown, binding collisions and shop coordinates."""
from pathlib import Path
from collections import defaultdict
import re,unittest
from test_crocodile import JassState
from prepare_ability_range_fixes_test import bindings,statistics_keys,requirements,kyoraku_finale,harribel_meter

ROOT=Path(__file__).resolve().parents[1]


class Killme(unittest.TestCase):
    def setUp(self):
        self.vm=JassState((ROOT/'test_map/ability_range/KillmeProgress.j').read_text())
        self.actor=0;self.local=0;self.test=True;self.base=set();self.dead=set();self.kills=[];self.timers={};self.pauses=[];self.silences=[];self.expired=None
        g=self.vm.g
        g.update(KM_Hero=defaultdict(lambda:None),KM_DeathTimer=defaultdict(lambda:None),KM_Duration=defaultdict(float),KM_Count=0,KM_RenderTimer=None,KM_Panel=None,
            Hero={0:'a',1:'b'},GetTriggerPlayer=lambda:self.actor,GetPlayerId=lambda p:p,Player=lambda p:p,
            GetLocalPlayer=lambda:self.local,TestMode=True,bj_MAX_PLAYER_SLOTS=2,UNIT_TYPE_DEAD='dead',gg_rct_Base='base',
            GetUnitTypeId=lambda u:1,IsUnitType=lambda u,t:u in self.dead,GetUnitAbilityLevel=lambda *a:0,
            GetOwningPlayer=lambda u:0 if u=='a' else 1,GetUnitX=lambda u:u,GetUnitY=lambda u:0,
            CheckCoordsInRect=lambda r,x,y:x in self.base,CreateTimer=self.create,TimerStart=self.start,
            PauseTimer=lambda t:self.pauses.append(t),GetExpiredTimer=lambda:self.expired,
            PauseUnit=lambda *a:None,SilenceUnit=lambda *a:self.silences.append(a),KillUnit=lambda u:self.kills.append(u))

    def create(self):
        t='timer'+str(len(self.timers));self.timers[t]=None;return t

    def start(self,t,duration,repeat,callback):self.timers[t]=(duration,repeat,callback)
    def command(self):self.vm.run('Trig_Killme_Actions')
    def expire(self,pid=0):
        self.expired=self.vm.g['KM_DeathTimer'][pid];self.vm.run('KM_Expire')

    def test_test_and_match_durations_and_no_timed_life_buff(self):
        self.command();self.assertEqual(self.timers[self.vm.g['KM_DeathTimer'][0]][0],1)
        self.assertFalse(self.silences)
        self.expire();self.assertEqual(self.kills,['a'])
        self.setUp();self.vm.g['TestMode']=False;self.command()
        self.assertEqual(self.timers[self.vm.g['KM_DeathTimer'][0]][0],10)
        self.assertEqual(self.silences,[('a','a',10)])

    def test_repeat_command_cannot_restart_or_duplicate_countdown(self):
        self.command();old=dict(self.timers);self.command()
        self.assertEqual(self.timers,old);self.assertEqual(self.vm.g['KM_Count'],1)
        self.expire();self.expire();self.assertEqual(self.kills,['a'])

    def test_base_cancels_and_expiry_never_kills_inside_base(self):
        self.command();self.base.add('a');self.vm.run('KM_Tick');self.expire()
        self.assertFalse(self.kills);self.assertEqual(self.vm.g['KM_Count'],0)
        self.assertIn(self.vm.g['KM_RenderTimer'],self.pauses)

    def test_replaced_or_dead_hero_cannot_kill_replacement(self):
        for reason in ('swap','dead'):
            self.setUp();self.command()
            if reason=='swap':self.vm.g['Hero'][0]='replacement'
            else:self.dead.add('a')
            self.expire();self.assertFalse(self.kills)

    def test_two_players_independent_timers_and_reuse(self):
        self.command();self.actor=1;self.command();self.assertEqual(self.vm.g['KM_Count'],2)
        self.expire(0);self.assertEqual(self.kills,['a']);self.assertEqual(self.vm.g['KM_Count'],1)
        self.expire(1);self.assertEqual(self.kills,['a','b']);self.assertEqual(self.vm.g['KM_Count'],0)
        count=len(self.timers);self.command();self.assertEqual(len(self.timers),count)


class BindingConflicts(unittest.TestCase):
    def setUp(self):
        s=(ROOT/'triggers/WOS_Start/WOSUI.j').read_text(encoding='utf-8-sig')
        if 'function WUI_BindingConflict' not in s:s=bindings(s)
        self.vm=JassState(s);self.g=self.vm.g
        self.g.update(WUI_HOTKEY_CHANNELS=6,WUI_SLOT_KEYS=13,WUI_HotkeyKey=defaultdict(lambda:None),
            WUI_SlotKey=defaultdict(lambda:None),WUI_SlotKeyName=defaultdict(lambda:''),
            WUI_HOTKEY_SHOP=0,WUI_HOTKEY_PING=4,WUI_HOTKEY_EMOTE=1,WUI_HOTKEY_STATS=2,
            SubString=lambda s,a,b:s[a:b],I2S=str)

    def conflict(self,key,channel=-1,slot=-1,pid=0):
        return self.vm.run('WUI_BindingConflict',(pid,channel,slot,key,key))

    def test_ui_channels_cannot_share_a_key_and_same_binding_is_allowed(self):
        self.g['WUI_HotkeyKey'][4*16]='Z'
        self.assertIn('already used',self.conflict('Z',2))
        self.assertEqual(self.conflict('Z',4),'')

    def test_ui_slot_and_default_skill_collisions_are_symmetric(self):
        self.g['WUI_SlotKey'][7]='N'
        self.assertIn('already used',self.conflict('N',2))
        self.g['WUI_HotkeyKey'][2*16]='V'
        self.assertIn('already used',self.conflict('V',slot=8))
        self.assertIn('stock skill',self.conflict('Q',2))
        self.assertEqual(self.conflict('N',slot=7),'')

    def test_other_player_does_not_reserve_my_key(self):
        self.g['WUI_HotkeyKey'][2*16]='N'
        self.assertEqual(self.conflict('N',channel=4,pid=1),'')

    def test_capture_rejects_conflict_keeps_binding_and_explains_why(self):
        messages=[];registered=[]
        self.g['WUI_HotkeyKey'][4*16]='N';self.g['WUI_HotkeyKey'][2*16]='V'
        self.g.update(WUI_CaptureChannel={0:2},WUI_KeyCount=1,WUI_KeyCode={1:'N'},WUI_KeyLabel={1:'N'},
            GetTriggerPlayer=lambda:0,GetPlayerId=lambda p:p,GetLocalPlayer=lambda:1,
            BlzGetTriggerPlayerKey=lambda:'N',OSKEY_ESCAPE='ESC',DisableTrigger=lambda *a:None,
            GetTriggeringTrigger=lambda:'capture',WUI_HotkeyName={},
            WUI_RegisterKeyFor=lambda *a:registered.append(a),DisplayTimedTextToPlayer=lambda *a:messages.append(a[-1]))
        self.vm.run('WUI_OnCapture')
        self.assertEqual(self.g['WUI_HotkeyKey'][2*16],'V')
        self.assertFalse(registered)
        self.assertIn('Key taken:',messages[0]);self.assertIn('unchanged',messages[0])

    def test_legacy_saved_duplicate_is_rejected(self):
        resets=[]
        self.g['WUI_HotkeyKey'][4*16]='N';self.g['WUI_HotkeyKey'][2*16]='V'
        self.g['WUI_HotkeyKey'][2*16]='N'
        self.g.update(GetPlayerId=lambda p:p,WUI_HotkeyName=defaultdict(lambda:''),
            WUI_ResetHotkeys=lambda p:resets.append(p),DisplayTimedTextToPlayer=lambda *a:None)
        self.vm.run('WUI_ValidateRestoredHotkeys',(0,))
        self.assertEqual(resets,[0])

    def test_valid_complete_f3_f4_permutation_is_not_reset(self):
        resets=[]
        self.g['WUI_HotkeyKey'][3*16]='F4';self.g['WUI_HotkeyKey'][5*16]='F3'
        self.g.update(GetPlayerId=lambda p:p,WUI_HotkeyName=defaultdict(lambda:''),
            WUI_ResetHotkeys=lambda p:resets.append(p))
        self.vm.run('WUI_ValidateRestoredHotkeys',(0,))
        self.assertFalse(resets)


class ShopCentering(unittest.TestCase):
    def setUp(self):
        self.vm=JassState((ROOT/'test_map/ability_range/ShopCentering.j').read_text())
        self.right=.922;self.placed={};self.table={}
        g=self.vm.g
        g.update(Shop_Position={},Shop_PositionCount=0,Shop_Frame={},Shop_Point={},Shop_PlaceMode={},
            Shop_X={},Shop_Y={},Shop_W={},Shop_H={},WUI_ScreenRight=lambda:self.right,
            GetHandleId=lambda f:f,LoadInteger=lambda t,k,c:t.get((k,c),0),
            SaveInteger=lambda t,k,c,v:t.update({(k,c):v}),
            WUI_Place=lambda f,x,y,w,h:self.placed.update({f:(x,y,w,h)}),
            BlzFrameSetAbsPoint=lambda f,p,x,y:self.placed.update({f:(x,y)}))

    def test_whole_window_is_centered_without_resizing(self):
        self.vm.run('Shop_Place',('window',.466,.312,.888,.428))
        self.assertAlmostEqual(self.placed['window'][0],.4)
        self.assertEqual(self.placed['window'][2:],(.888,.428))

    def test_resize_repositions_cached_frames_without_duplicate_registration(self):
        self.vm.run('Shop_Place',('item',.3,.3,.038,.038))
        self.vm.run('Shop_Place',('item',.3,.3,.038,.038))
        self.assertEqual(self.vm.g['Shop_PositionCount'],1)
        self.right=.8;self.vm.run('Shop_Recenter')
        self.assertAlmostEqual(self.placed['item'][0],.3+self.vm.run('Shop_Shift'))


class ScoreboardKeys(unittest.TestCase):
    def test_keyboard_source_ignores_last_clicked_frame_and_does_not_reset_focus(self):
        s=(ROOT/'triggers/WOS_Start/Scoreboard.j').read_text(encoding='utf-8-sig')
        if 'if GetTriggeringTrigger() == WOS_STATS_DataKeys then' not in s:s=statistics_keys(s)
        vm=JassState(s.replace('static if LIBRARY_DamageStats then','if LIBRARY_DamageStats then'));key=['F3'];focus=[]
        vm.g['LIBRARY_DamageStats']=False
        g=vm.g
        for n in ('PlayerDamageTakenMag','PlayerDamageTakenPhys','PlayerDamagePhys','PlayerDamageMag','PlayerHeal'):
            g[n]={0:42};g[n+'All']={0:100}
        g.update(GetTriggerPlayer=lambda:0,GetPlayerId=lambda p:p,BlzGetTriggerFrame=lambda:'stale-load-button',
            WOS_STATS_ClearButton='clear',WOS_STATS_DataKeys='keys',WOS_STATS_DataTrigger='click',
            GetTriggeringTrigger=lambda:'keys',BlzGetTriggerPlayerKey=lambda:key[0],
            WUI_GetHotkey=lambda c,p:'F3' if c==3 else 'F4',WUI_HOTKEY_CLEAR=3,WUI_HOTKEY_LOAD=5,
            GetLocalPlayer=lambda:1,WUI_ResetClickedButtonFocus=lambda:focus.append('focus'))
        vm.run('WOS_STATS_OnData');self.assertEqual(g['PlayerDamagePhys'][0],0)
        key[0]='F4';vm.run('WOS_STATS_OnData');self.assertEqual(g['PlayerDamagePhys'][0],100)
        self.assertFalse(focus)


class HeroRequirements(unittest.TestCase):
    def test_kyoraku_third_act_finisher_replaces_g_with_live_cooldown(self):
        from test_ally_hero_ability_ui import AllyAbilityUI
        f=AllyAbilityUI();f.setUp();vm=f.vm;g=vm.g
        s=(ROOT/'triggers/WOS_Start/ShowCD.j').read_text(encoding='utf-8-sig')
        if 'AHUI_SLOT_T, KyorakuT4_ID)' in s:s=kyoraku_finale(s)
        vm.methods.update(JassState(s).methods)
        f.c.type=g['Kyoraku_ID'];f.c.hero_level=35;f.c.abilities.clear()
        t,skip,final=g['KyorakuT_ID'],g['KyorakuTSkip_ID'],g['KyorakuT4_ID']
        for a in (t,skip,final):f.c.abilities[a]={'level':1,'remaining':0}
        def availability(a,value):vm.run('AHUI_OnSetPlayerAbilityAvailable',(1,a,value))
        availability(t,False);availability(skip,True);availability(final,False)
        f.refresh();self.assertEqual(g['AHUI_CurrentAbility'][6],skip)
        # Actual Bankai transition enables the finisher, hides Skip, starts 9s CD.
        availability(skip,False);availability(final,True)
        f.c.abilities[final]['remaining']=9
        f.refresh();self.assertEqual(g['AHUI_CurrentAbility'][6],final)
        self.assertNotEqual(g['AHUI_CurrentAbility'][4],final)
        self.assertTrue(f.value('AHUI_CooldownText',6,'visible'))
        self.assertIn('9',f.value('AHUI_CooldownText',6,'text'))
        f.c.abilities[final]['remaining']=0
        f.refresh();self.assertEqual(g['AHUI_CurrentAbility'][6],final)
        availability(final,False);availability(skip,True)
        f.refresh();self.assertEqual(g['AHUI_CurrentAbility'][6],skip)

    def test_harribel_morph_meter_uses_shared_progress_and_spell_clock(self):
        s=(ROOT/'triggers/Heroes/Harribel.j').read_text(encoding='utf-8-sig')
        self.assertNotIn('WUI_HeroMeter(',s)
        self.assertNotIn('frame2_pas1',s)
        self.assertRegex(s,r'WUI_HeroProgress\(c, HarribelE_ID, "[^"]+", rmax - r, rmax, true\)')
        self.assertIn('SH_MORPH_E, 1)',s)

    def test_cambio_disabled_until_real_counter_reaches_threshold(self):
        s=(ROOT/'triggers/WOS_Start/ShowCD.j').read_text(encoding='utf-8-sig')
        if 'function AHUI_RequirementLocked' not in s:s=requirements(s)
        vm=JassState(s);damage=[5999]
        vm.g.update(RaidenF_ID=99,TakeshiG_ID=1,TakeshiG_TakenDamageToEnter=6000,hs={},
            GetHandleId=lambda u:u,StringHash=lambda s:s,LoadReal=lambda *a:damage[0])
        self.assertTrue(vm.run('AHUI_RequirementLocked',('hero',1)))
        damage[0]=6000;self.assertFalse(vm.run('AHUI_RequirementLocked',('hero',1)))
        self.assertFalse(vm.run('AHUI_RequirementLocked',('hero',2)))
        self.assertIn('AHUI_SLOT_F, TakeshiG_ID)',s)
        self.assertIn('AHUI_SLOT_G, TakeshiF_ID)',s)


if __name__=='__main__':unittest.main()
