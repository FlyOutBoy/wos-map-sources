"""Operation/lifetime regressions for actual handlers; these are not FPS measurements."""
from collections import defaultdict
from pathlib import Path
import re
import unittest

from test_crocodile import JassState

ROOT=Path(__file__).resolve().parents[1]

def functions(path,*names):
    text=(ROOT/'triggers'/path).read_text(encoding='utf-8-sig')
    return '\n'.join(re.search(r'(?m)^\s*(?:private |public )?function '+name+r' takes.*?^\s*endfunction',text,re.S)[0] for name in names)


class Performance(unittest.TestCase):
    def test_disabled_desync_probe_does_no_allocation_rng_enumeration_or_disk_io(self):
        vm=JassState(functions('Systems/Systems1.j','WOS_ProbeMark','WOS_ProbeDump','WOS_ProbeTick','WOS_ProbeStart'))
        def forbidden(*a):self.fail('Disabled diagnostic performed work')
        vm.g.update(WOS_DESYNC_PROBE_ENABLED=False)
        for n in ['Location','CreateTimer','GroupEnumUnitsInRect','GetRandomInt','PreloadGenClear','PreloadGenStart','Preload','PreloadGenEnd']:
            vm.g[n]=forbidden
        for _ in range(100):
            vm.run('WOS_ProbeStart',('hero',));vm.run('WOS_ProbeMark',('after minimap',))
            vm.run('WOS_ProbeTick');vm.run('WOS_ProbeDump')
        text=(ROOT/'triggers/Systems/Systems1.j').read_text(encoding='utf-8-sig')
        self.assertIn('constant boolean WOS_DESYNC_PROBE_ENABLED = false',text)

    def test_stats_clock_starts_once_and_sleeps_when_last_shared_window_closes(self):
        vm=JassState(functions('WOS_Start/Scoreboard.j','WOS_STATS_Periodic','WOS_STATS_WakeTimer'))
        starts=[];pauses=[];render=[];viewer=0
        vm.g.update(WOS_STATS_TimerRunning=False,WOS_STATS_UpdateTimer='clock',WOS_STATS_UPDATE_PERIOD=.5,
            WOS_STATS_VIEWER_COUNT=24,WOS_STATS_IsOpen=defaultdict(bool),WOS_STATS_IsFinal=defaultdict(bool),
            GetPlayerId=lambda p:p,GetLocalPlayer=lambda:viewer,
            TimerStart=lambda *a:starts.append(a),PauseTimer=pauses.append,
            WOS_STATS_HideLegacyUI=lambda:None,WOS_STATS_Show=lambda *a:None,WOS_STATS_Main='main',
            WOS_STATS_UpdateForPlayer=render.append)
        vm.run('WOS_STATS_WakeTimer');vm.run('WOS_STATS_WakeTimer');self.assertEqual(1,len(starts))
        vm.g['WOS_STATS_IsOpen'][5]=True;vm.run('WOS_STATS_Periodic');self.assertFalse(render);self.assertFalse(pauses)
        viewer=5;vm.run('WOS_STATS_Periodic');self.assertEqual([5],render)
        vm.g['WOS_STATS_IsOpen'][5]=False;vm.run('WOS_STATS_Periodic')
        self.assertEqual(['clock'],pauses);self.assertFalse(vm.g['WOS_STATS_TimerRunning'])
        vm.run('WOS_STATS_WakeTimer');self.assertEqual(2,len(starts))

    def test_range_inventory_scan_is_four_hz_while_hover_remains_twenty_hz(self):
        vm=JassState(functions('WOS_Start/ShowCD.j','AHUI_Periodic'));scan=[];render=[]
        vm.g.update(AHUI_UpdateTick=0,AHUI_REFRESH_TICKS=5,AHUI_SeenHudRevision=0,WUI_HudRevision=0,
            GetPlayerId=lambda p:p,GetLocalPlayer=lambda:0,bj_MAX_PLAYER_SLOTS=24,
            AHUI_SelectedHero=defaultdict(lambda:None),AHUI_DeselectPending=defaultdict(bool),AHUI_HoveredSlot=defaultdict(int),
            AR_Reconcile=lambda:scan.append(1),AR_Render=render.append,AHUI_HideTooltip=lambda *a:None)
        for _ in range(100):vm.run('AHUI_Periodic')
        self.assertEqual(20,len(scan));self.assertEqual([0]*100,render)

    def test_already_hidden_native_ability_placeholders_do_not_invalidate_frames(self):
        vm=JassState(functions('WOS_Start/ShowCD.j','AHUI_ShowKey','AHUI_HideSlot')+'\n'+functions('WOS_Start/WOSUI.j','WUI_Show'))
        native=[];alpha=[];frames={}
        def show(f,v):native.append((f,v));frames[f]=v
        vm.g.update(AHUI_FrameIndex=lambda p,s:s,AHUI_SlotVisible=defaultdict(bool),AHUI_RenderedAbility=defaultdict(int),
            AHUI_RenderedIconPath=defaultdict(lambda:None),AHUI_CooldownPeak=defaultdict(float),AHUI_LastRemaining=defaultdict(float),
            AHUI_HoveredSlot=defaultdict(lambda:-1),AHUI_READY_ALPHA=255,
            BlzFrameIsVisible=lambda f:frames.get(f,False),BlzFrameSetVisible=show,
            BlzFrameSetAlpha=lambda *a:alpha.append(a))
        for name in ['PausedText','Root','Icon','CooldownFill','CooldownText','KeyBox','KeyText','ChargeBox']:
            vm.g['AHUI_'+name]=defaultdict(lambda n=name:n)
        vm.g['AHUI_SlotVisible'][0]=True
        for n in ['Root','Icon','CooldownFill','CooldownText','KeyBox','KeyText','ChargeBox']:frames[n]=True
        vm.run('AHUI_HideSlot',(0,0));initial=len(native);initial_alpha=len(alpha)
        self.assertGreater(initial,0);self.assertEqual(4,initial_alpha)
        for _ in range(100):vm.run('AHUI_HideSlot',(0,0))
        self.assertEqual(initial,len(native));self.assertEqual(initial_alpha,len(alpha))

    def test_music_elapsed_keeps_advancing_but_hidden_panel_never_sets_slider(self):
        vm=JassState(functions('WOS_Start/MusicPlayer.j','LMP_OnTick'));progress=[];labels=[];players=[]
        visible=False
        vm.g.update(GetPlayerId=lambda p:p,GetLocalPlayer=lambda:0,bj_MAX_PLAYERS=16,
            Player=lambda p:(players.append(p),p)[1],LMP_ProcessMusicSwitch=lambda p:None,LMP_TICK=.1,
            lmpPlaying=defaultdict(lambda:True),lmpSkipElapsedTick=defaultdict(bool),lmpCurrent=defaultdict(lambda:1),
            lmpTrackCount=1,lmpDurationMs={1:300000},LMP_END_GUARD_MS=100,
            lmpElapsed=defaultdict(float),lmpUiElapsed=defaultdict(float),lmpEqualizerElapsed=defaultdict(float),
            lmpEqualizerPhase=defaultdict(int),lmpPanel='panel',BlzFrameIsVisible=lambda f:visible,
            LMP_SetProgress=lambda *a:progress.append(a),LMP_UpdateTimeText=labels.append,
            LMP_UpdateEqualizer=lambda p:None,ModuloInteger=lambda a,b:a%b,I2R=float)
        for _ in range(50):vm.run('LMP_OnTick')
        self.assertAlmostEqual(5.,vm.g['lmpElapsed'][0]);self.assertFalse(progress);self.assertFalse(labels)
        visible=True
        for _ in range(50):vm.run('LMP_OnTick')
        self.assertEqual(10,len(progress));self.assertEqual(10,len(labels));self.assertEqual([0]*100,players)

    def test_unchanged_shop_inventory_does_not_rebuild_names_icons_or_prices(self):
        vm=JassState(functions('WOS_Start/WoS_Shop_Init.j','PlayerInventoryPeriodic'));metadata=[]
        ids=list(range(100,106))
        vm.g.update(Player=lambda p:p,Hero=defaultdict(lambda:'hero'),ShopSearchActive=defaultdict(bool),
            Shop_Active=defaultdict(bool,{0:True}),ShopTargetUnitId=defaultdict(lambda:100),
            IsActivePlayerSlot=lambda p:True,GetSelectedHeroForPlayer=lambda p:'hero',GetHandleId=lambda u:100,
            ShopGetInventoryItemId=lambda u,s:ids[s],hs={},LoadInteger=lambda *a:0,ShopRefundKey=defaultdict(int),
            ShopInventoryLastId=defaultdict(int,{s:100+s for s in range(6)}),ShopInventoryLastRefund=defaultdict(int),
            GetLocalPlayer=lambda:0,GetItemValue=lambda i:(metadata.append(('cost',i)),600)[1],
            GetObjectName=lambda i:(metadata.append(('name',i)),'Item')[1],
            BlzGetAbilityIcon=lambda i:(metadata.append(('icon',i)),'icon')[1],
            I2S=str,R2I=int,RefundPercent=50,ShopPricePlateWidth=lambda c:.02,ShopGetItemTooltipWidth=lambda s:.1,
            QB_InventorySize=.03,RMinBJ=min,WUI_TEXT='',
            BlzFrameSetText=lambda *a:None,BlzFrameSetSize=lambda *a:None,
            BlzFrameSetEnable=lambda *a:None,BlzFrameSetTexture=lambda *a:None,BlzFrameSetVisible=lambda *a:None)
        for n in ['FRAME_ShopInventoryTooltipBox','FRAME_ShopInventoryItemName','FRAME_ShopInventoryTooltipText',
                  'FRAME_ShopItemInventorySlot','FRAME_ShopItemInventorySlotBack','FRAME_ShopItemInventorySlotCost','FRAME_ShopInventoryPricePlate']:
            vm.g[n]=defaultdict(lambda:'frame')
        for _ in range(30):vm.run('PlayerInventoryPeriodic')
        self.assertFalse(metadata)
        ids[2]=500;vm.run('PlayerInventoryPeriodic');self.assertEqual([('cost',500),('name',500),('icon',500)],metadata)
        vm.run('PlayerInventoryPeriodic');self.assertEqual(3,len(metadata))

    def test_key_hold_runs_once_and_synthetic_press_cycles_are_capped_at_ten_hz(self):
        vm=JassState(functions('WOS_Start/WOSUI.j','WUI_AcceptKeyDown'))
        state={};clock=[0.];down=[True];pid=[0];scope=[10];key=[65]
        vm.g.update(WUI_InputClock='clock',WUI_InputState=state,GetTriggeringTrigger=lambda:scope[0],
            GetHandleId=lambda v:v,GetTriggerPlayer=lambda:pid[0],GetPlayerId=lambda p:p,
            BlzGetTriggerPlayerKey=lambda:key[0],BlzGetTriggerPlayerIsKeyDown=lambda:down[0],
            TimerGetElapsed=lambda _:clock[0],LoadBoolean=lambda t,p,c:t.get(('b',p,c),False),
            SaveBoolean=lambda t,p,c,v:t.update({('b',p,c):v}),LoadReal=lambda t,p,c:t.get(('r',p,c),0.),
            SaveReal=lambda t,p,c,v:t.update({('r',p,c):v}))
        self.assertTrue(vm.run('WUI_AcceptKeyDown'))
        for n in range(2000):
            clock[0]=n*.001
            self.assertFalse(vm.run('WUI_AcceptKeyDown'))
        down[0]=False;self.assertFalse(vm.run('WUI_AcceptKeyDown'))
        down[0]=True;clock[0]=2.1;self.assertTrue(vm.run('WUI_AcceptKeyDown'))
        # A separate trigger/key/player still receives its independent press.
        scope[0]=11;self.assertTrue(vm.run('WUI_AcceptKeyDown'))
        pid[0]=1;self.assertTrue(vm.run('WUI_AcceptKeyDown'))
        key[0]=66;self.assertTrue(vm.run('WUI_AcceptKeyDown'))
        accepted=0
        for n in range(1000):
            clock[0]=3.+n*.001;down[0]=False;vm.run('WUI_AcceptKeyDown')
            down[0]=True;accepted+=bool(vm.run('WUI_AcceptKeyDown'))
        self.assertLessEqual(accepted,10);self.assertGreaterEqual(accepted,9)

    def test_slot_forwarding_cannot_recursively_force_the_same_key(self):
        vm=JassState(functions('WOS_Start/WOSUI.j','WUI_UseSlot'));calls=[]
        vm.g.update(WUI_ForwardingSlot=False,WUI_SlotDefaultKey=lambda s:'Q',WUI_Item={},
            ForceUIKey=lambda k:(calls.append(k),vm.run('WUI_UseSlot',(0,))))
        vm.run('WUI_UseSlot',(0,));self.assertEqual(['Q'],calls);self.assertFalse(vm.g['WUI_ForwardingSlot'])

    def test_direct_environment_hp_loss_keeps_the_same_setter_and_records_actual_loss(self):
        vm=JassState(functions('Round_End/RoundEnd.j','EnvironmentHpLoss').replace('static if','if'));life=[120.];seen=[]
        vm.g.update(LIBRARY_DamageStats=True,GetWidgetLife=lambda u:life[0],
            SetHpCurrent=lambda u,r:life.__setitem__(0,max(0.,life[0]+r)),
            DamageStatsRecordDirect=lambda *a:seen.append(a),RMaxBJ=max)
        vm.run('EnvironmentHpLoss',('car','hero',200.,-13))
        self.assertEqual(0.,life[0]);self.assertEqual([('car','hero',-13,120.)],seen)

    def test_damage_details_hides_and_restores_both_status_boxes_with_top_ui(self):
        vm=JassState(functions('WOS_Start/WoS_Hero_Icons_Init.j','StatusSetDamageDetailsVisible'));seen=[];top=[True]
        vm.g.update(StatusGameTimeBox='time',StatusTrainBox='train',WUI_TopShown=lambda:top[0],WUI_Show=lambda *a:seen.append(a))
        vm.run('StatusSetDamageDetailsVisible',(True,));self.assertEqual([('time',False),('train',False)],seen)
        seen.clear();vm.run('StatusSetDamageDetailsVisible',(False,));self.assertEqual([('time',True),('train',True)],seen)
        seen.clear();top[0]=False;vm.run('StatusSetDamageDetailsVisible',(False,));self.assertEqual([('time',False),('train',False)],seen)


if __name__=='__main__':unittest.main()
