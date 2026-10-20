"""Run actual startup, invisibility and wheel-switch paths with native boundaries."""
from pathlib import Path
from collections import defaultdict
import json
import unittest
import test_wos_ui as ui
import test_team_map_pings as pings
import test_ui_followup as followup

ROOT=Path(__file__).resolve().parents[1]

class Invisibility(unittest.TestCase):
    def test_all_granted_object_invis_abilities_work_without_windwalk_buff_or_native_query(self):
        vm=ui.load_source('WOSUI.j');u=vm.unit();vm.g['IsUnitInvisible']=lambda *_:False
        objects=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
        ids={k for k,v in objects.items() if v.get('base_id')=='Apiv'}
        self.assertEqual({'Apiv','A03W','A0HZ'},ids)
        self.assertFalse(vm.run('WUI_UnitHasInvisibility',(u,)))
        for aid in ids:
            vm.add_ability(u,aid)
            self.assertTrue(vm.run('WUI_UnitHasInvisibility',(u,)),aid)
            vm.remove_ability(u,aid)
            self.assertFalse(vm.run('WUI_UnitHasInvisibility',(u,)))
        self.assertFalse(vm.run('WUI_UnitHasInvisibility',(None,)))

class Startup(unittest.TestCase):
    def test_discord_ghost_uses_toolbar_shift_and_never_right_screen_dock(self):
        vm=ui.load_source('WOSUI.j');toolbar=[];right=[];hidden={};n=[0]
        def frame(*_):n[0]+=1;return n[0]
        vm.g.update(WUI_Root='root',WUI_InfoOwner='info',BlzCreateFrameByType=frame,
                    WUI_GhostIcon=frame,WUI_GhostText=frame,WUI_PlaceToolbar=lambda *a:toolbar.append(a),
                    WUI_PlaceRight=lambda *a:right.append(a),BlzFrameSetTexture=lambda *_:None,
                    BlzFrameSetEnable=lambda *_:None,BlzFrameSetParent=lambda *_:None,
                    BlzFrameSetAllPoints=lambda *_:None,BlzFrameSetSize=lambda *_:None,
                    BlzFrameSetVisible=lambda f,v:hidden.update({f:v}),
                    WUI_TopActionX=lambda i:float(i),WUI_ScreenRight=lambda:.8)
        vm.run('WUI_CreateGhostControls')
        ghost=vm.g['WUI_Ghost'][2]
        self.assertEqual([(ghost,1,0)],toolbar)
        self.assertFalse(right)
        vm.run('WUI_ReleaseGhost',(1,));self.assertFalse(hidden[ghost])

    def test_hide_ui_placeholder_keeps_final_dock_width_after_refresh(self):
        vm=ui.load_source('WOSUI.j');dock=[]
        vm.g.update(BlzCreateFrameByType=lambda *a:('frame',a[1]),
            WUI_PlaceRight=lambda *a:dock.append(a),WUI_MinimalEdge=lambda *_:None)
        for name in ['Texture','Enable','AllPoints','TextAlignment','Scale','Text']:
            vm.g['BlzFrameSet'+name]=lambda *_:None
        for name in ['TEXT_JUSTIFY_MIDDLE','TEXT_JUSTIFY_CENTER']:vm.g[name]=name
        vm.g.update(WUI_FILL_NORMAL='fill',WUI_TEXT='')
        vm.run('WUI_GhostText',('hide','Hide UI',vm.g['WUI_TOP_ROW_X2']))
        self.assertEqual(vm.g['WUI_TOP_ROW_X2'],dock[0][1])
        self.assertEqual(vm.g['WUI_TOP_ROW_W'],dock[0][3])
        gap=vm.g['WUI_TOP_ROW_X1']-vm.g['WUI_TOP_ROW_X2']-dock[0][3]
        self.assertGreater(gap,0)
        rows=[];vm.g.update(WUI_InfoRow=lambda *a:rows.append(a),WUI_InfoPage=0,
            BlzFrameSetVisible=lambda *_:None,WUI_GOLD='',I2S=str)
        vm.run('WUI_InfoShowPage')
        self.assertEqual(4,len([r for r in rows if r[2]]));self.assertIn('-help',rows[-1][2])

    def test_guide_shared_tick_never_calls_exclusive_modal_or_allocation_paths(self):
        for client in [0,1]:
            f=followup.Guide();f.setUp();f.local=f.sender=client
            f.vm.g['ss_HelpMarkerRead']=True
            f.status(client,'N')
            f.vm.g['SaveSystem_WritePlayedOnce']=lambda:None
            def forbidden(*_):raise AssertionError('guide invoked gameplay/modal/allocation path')
            for name in ['WUI_EnterExclusiveWindow','WUI_RegisterModal','CreateTimer','CreateTrigger',
                         'BlzCreateFrameByType','CreateUnit','CreateGroup']:
                f.vm.g[name]=forbidden
            f.vm.run('SaveSystem_HelpTick');self.assertTrue(f.visible)
            for _ in range(160):f.vm.run('SaveSystem_HelpTick')
            self.assertFalse(f.visible)
            f.vm.run('SaveSystem_HelpChat');self.assertTrue(f.visible)
            f.vm.run('SaveSystem_HelpClick');f.status(client,'C');self.assertFalse(f.visible)

class StatsStartup(unittest.TestCase):
    def test_entire_stats_startup_with_real_builders_and_hotkey_registration(self):
        import re
        vm=ui.load_source('WOSUI.j');stats=ui.load_source('Scoreboard.j')
        for k,v in stats.g.items():
            if k not in vm.g:vm.g[k]=v
        vm.text+='\n'+stats.text;vm.methods.update(stats.methods)
        for name in vm.methods:vm.g[name]=lambda *a,n=name:vm.run(n,a)
        text=vm.text;count=[100];hotkeys=[];clicks=[];created=[];timers=[];visible={}
        def frame(kind,name,*args):
            count[0]+=1;created.append((count[0],kind,name));return count[0]
        def handle(*a):count[0]+=1;return count[0]
        for name in set(re.findall(r'\b(BlzFrameSet\w+)\(',text)):vm.g[name]=lambda *_:None
        for name in set(re.findall(r'\b(TEXT_JUSTIFY_\w+|FRAMEPOINT_\w+|FRAMEEVENT_\w+|OSKEY_\w+)\b',text)):vm.g[name]=name
        for kind,name in re.findall(r'(?m)^\s*(?:private )?(framehandle|trigger|timer) (\w+)',text):vm.g.setdefault(name,None)
        for name,value in re.findall(r'(?m)^\s*(?:private )?(?:constant )?string (\w+) = "([^"\n]*)"',text):vm.g[name]=value
        vm.g.update(WUI_Root=1,WUI_StatsButton=2,FRAME_StatsMain=None,
            WOS_STATS_TEX_PANEL_FILL='panel',WOS_STATS_TEX_TOOLTIP='panel',
            BlzCreateFrameByType=frame,CreateTimer=handle,CreateTrigger=handle,DestroyTimer=lambda *_:None,
            BlzTriggerRegisterPlayerKeyEvent=lambda *a:hotkeys.append(a),
            BlzTriggerRegisterFrameEvent=lambda *a:clicks.append(a),TriggerAddAction=lambda *_:None,PauseTimer=lambda *_:None,
            TimerStart=lambda *a:timers.append(a),GetExpiredTimer=lambda:'builder',
            GetHandleId=lambda h:h,Player=lambda p:p,ConvertOsKeyType=lambda n:n,
            I2R=float,BlzGetLocalClientWidth=lambda:1920,BlzGetLocalClientHeight=lambda:1080,
            TriggerAddCondition=lambda *_:None,Condition=lambda f:f,
            HaveSavedString=lambda t,k,c:(k,c) in t,LoadStr=lambda t,k,c:t.get((k,c),''),
            SaveStr=lambda t,k,c,v:t.update({(k,c):v}),
            HaveSavedInteger=lambda t,k,c:(k,c) in t,
            LoadFrameHandle=lambda t,k,c:t.get((k,c)),
            BlzFrameSetVisible=lambda f,v:visible.update({f:v}))
        vm.run('WOS_STATS_CreateUI')
        self.assertFalse(created);self.assertEqual(-6,vm.g['WOS_STATS_BuildRow'])
        # Rows wait for every WUI_OnReady owner (one owner per frame after the bootstrap).
        vm.run('WOS_STATS_BuildNextRow');self.assertEqual(-6,vm.g['WOS_STATS_BuildRow'])
        vm.g['WUI_ReadyDrainDone']=True
        vm.run('WOS_STATS_BuildNextRow')
        self.assertEqual('OSKEY_F2',vm.g['WUI_HotkeyKey'][vm.g['WUI_HOTKEY_STATS']*16])
        self.assertTrue(any(a[2]=='OSKEY_F2' for a in hotkeys))
        self.assertTrue(any(a[1]==2 for a in clicks))
        self.assertFalse(any(name=='WOSScoreboardWindow' for _,_,name in created))
        for _ in range(15):vm.run('WOS_STATS_BuildNextRow');self.assertFalse(vm.g['WOS_STATS_Ready'])
        vm.run('WOS_STATS_BuildNextRow');self.assertTrue(vm.g['WOS_STATS_Ready'])
        self.assertEqual(10,sum(name=='WosStatsRowContent' for _,_,name in created))
        self.assertEqual(60,sum(name=='WosStatsItemButton' for _,_,name in created))
        self.assertEqual(3,sum(name=='WOSHotkeyBadge' for _,_,name in created))
        self.assertFalse(visible[vm.g['WOS_STATS_Main']])
        opened=[];vm.g.update(END1=0,GetTriggerPlayer=lambda:0,GetPlayerId=lambda p:p,
            BlzGetTriggerPlayerKey=lambda:'OSKEY_F2',WUI_GetHotkey=lambda *_:'OSKEY_F2',
            WOS_STATS_SetOpen=lambda p,on:opened.append((p,on)),WUI_ResetClickedButtonFocus=lambda:None)
        vm.run('WOS_STATS_OnKey');vm.run('WOS_STATS_OnToggle')
        self.assertEqual([(0,True),(0,True)],opened)

class ModeStartup(unittest.TestCase):
    def test_mode_selector_builds_larger_labels_and_keeps_host_only_actions(self):
        vm=ui.load_source('Starts.j');scales={};button_scales=[];enabled={};callbacks=[]
        vm.g.update(CreateTrigger=lambda:'events',WUI_GetRoot=lambda:'root',
            WUI_Passive=lambda *a:'selector',WUI_Window=lambda *a:'panel',WUI_RegisterModal=lambda *_:None,
            WUI_OrnateBorder=lambda *_:'border',WUI_Place=lambda *_:None,WUI_Divider=lambda *_:'line',
            BlzCreateFrameByType=lambda kind,name,*_:name,WUI_TextButton=lambda name,*_:name,
            BlzFrameSetScale=lambda f,v:scales.update({f:v}),BlzFrameSetLevel=lambda *_:None,
            BlzFrameSetEnable=lambda f,v:enabled.update({f:v}),BlzFrameSetTextAlignment=lambda *_:None,
            BlzFrameSetText=lambda *_:None,BlzFrameSetVisible=lambda *_:None,WUI_SetButtonTextScale=lambda f,v:button_scales.append(v),
            BlzTriggerRegisterFrameEvent=lambda *_:None,TriggerAddAction=lambda t,f:callbacks.append(f),
            TEXT_JUSTIFY_CENTER='center',TEXT_JUSTIFY_MIDDLE='middle',FRAMEEVENT_CONTROL_CLICK='click',
            WUI_GOLD='',WUI_TEXT='',I2R=float,Player=lambda p:p,GetLocalPlayer=lambda:1,WOS_ModeSecondsLeft=20)
        vm.run('WOS_CreateModeSelector')
        self.assertEqual(1.45,scales['WOSModeTitle']);self.assertEqual(1.05,scales['WOSModeHint'])
        self.assertEqual([1.35]*4,button_scales)
        self.assertTrue(all(not enabled[vm.g['WOS_ModeButton'][i]] for i in range(4)))
        self.assertEqual(1,len(callbacks))

    def test_optional_ui_failure_cannot_prevent_selector_or_normal_mode_timeout(self):
        vm=ui.load_source('Starts.j');events=[]
        def fail(*_):raise RuntimeError('optional frame native failed')
        vm.g.update(WOS_ModeCountdown=None,CreateTrigger=lambda:object(),CreateTimer=lambda:object(),bj_DEGTORAD=3.14159/180,
            TimerStart=lambda t,period,repeat,callback:events.append((period,repeat)),
            WUI_OnReady=lambda callback:events.append('selector'),WUI_GetRoot=lambda:'root',
            WOS_PickPrebuild=lambda:None,WUI_StartupComplete=lambda:True,
            BlzCreateFrameByType=fail)
        with self.assertRaisesRegex(RuntimeError,'optional frame'):vm.run('InitTrig_ModeDialog')
        self.assertFalse(vm.g['WOS_ModeStarted'])
        self.assertEqual([(10.,False)],events)
        vm.g.update(GetExpiredTimer=lambda:'delay',DestroyTimer=lambda *_:None)
        vm.run('WOS_ModeDelayExpired')
        self.assertTrue(vm.g['WOS_ModeStarted'])
        self.assertIn((20.,False),events);self.assertIn((1.,True),events)
        self.assertIn('selector',events)
        before=list(events);vm.run('WOS_BeginModeSelection');self.assertEqual(before,events)
        vm.g.update(GetExpiredTimer=lambda:None,DestroyTimer=lambda *_:None,
            CaptainDraftPreRoundUnlimitedSwap=False,PlayersAmount=2,GAME_STATE_TIME_OF_DAY='time',SetFloatGameState=lambda *_:None,
            Map_Start=lambda:events.append('pick'))
        vm.run('CheckPickedMode')
        self.assertEqual(1,vm.g['PickedMode']);self.assertIn('pick',events)
        self.assertNotIn('WUI_FrameSetValue',vm.methods['InitTrig_ModeDialog'])

class Wheels(unittest.TestCase):
    def setUp(self):
        self.p=pings.TeamMapPings();self.p.setUp()
        self.e=ui.load_source('EMOTES.j');self.hub=ui.load_source('WOSUI.j')
        self.down=True;self.sent=[];self.visible={};self.handles=[]
        def trigger():t={};self.handles.append(t);return t
        self.hub.g.update(CreateTrigger=trigger,TriggerAddAction=lambda t,c:t.update(callback=c),
                          TriggerExecute=lambda t:t['callback']())
        enter=lambda k:self.hub.run('WUI_EnterWheel',(k,))
        self.p.vm.g['WUI_EnterWheel']=enter
        self.e.g.update(GetPlayerId=lambda p:p,GetLocalPlayer=lambda:0,GetTriggerPlayer=lambda:0,
                        EmojiInitialized=True,EmojiPanel='emoji',EmojiCloseButton='close',EmojiCooldownText='time',
                        ApplyPaletteForPlayer=lambda *_:None,UpdateCooldownText=lambda:None,
                        HidePanelButtons=lambda:None,UpdateEmojiHover=lambda:None,
                        BlzFrameSetVisible=lambda f,v:self.visible.update({f:v}),
                        BlzIsMouseButtonPressed=lambda *_:False,WUI_EnterWheel=enter,
                        MOUSE_BUTTON_TYPE_RIGHT='right',OSKEY_ESCAPE='escape',
                        BlzGetTriggerPlayerIsKeyDown=lambda:self.down,BlzGetTriggerPlayerKey=lambda:'K',
                        BlzGetTriggerPlayerMetaKey=lambda:0,WUI_HOTKEY_EMOTE=1,
                        WUI_GetHotkey=lambda *_:'K',BlzSendSyncData=lambda *a:self.sent.append(a))
        # All three real owners see the same central passive state.
        shared=self.p.vm.g
        for k,v in self.e.g.items():
            if k in self.e.methods or k not in shared:shared[k]=v
        for k,v in self.hub.g.items():
            if k in self.hub.methods or k not in shared:shared[k]=v
        self.p.vm.g=shared;self.e.g=shared;self.hub.g=shared
        shared.update(EmojiPanel='emoji',EmojiCloseButton='close',EmojiCooldownText='time',
            BlzFrameSetVisible=lambda f,v:(self.visible.update({f:v}),self.p.frames.update({(f,'visible'):v})),
            GetLocalPlayer=lambda:0,GetTriggerPlayer=lambda:0,
            BlzGetTriggerPlayerKey=lambda:self.p.key if self.p.key!='Z' else 'K')
        # Preserve separate event sources while sharing UI globals.
        self.p.vm.g['WUI_EnterWheel']=enter
        self.e.g['WUI_EnterWheel']=enter
        self.p.vm.g['CreateTrigger']=lambda:{}
        self.p.vm.g['TriggerExecute']=lambda *_:self.fail('runtime wheel dispatch')
        self.p.vm.g['TriggerEvaluate']=lambda *_:self.fail('runtime wheel evaluate')
        self.p.vm.g['ExecuteFunc']=lambda *_:self.fail('runtime wheel execute')
        shared['WUI_GetHotkey']=lambda channel,pid:'Z' if channel==0 else 'K'
        p_run=self.p.vm.run;e_run=self.e.run
        def ping_run(n,args=(),**kw):
            shared.update(BlzGetTriggerPlayerKey=lambda:self.p.key,
                          BlzGetTriggerPlayerIsKeyDown=lambda:self.p.key_down,
                          BlzSendSyncData=lambda *a:self.p.sync.append(a) if a[0]!='WOSPMOUSE' else None)
            return p_run(n,args,**kw)
        def emoji_run(n,args=(),**kw):
            shared.update(BlzGetTriggerPlayerKey=lambda:'K',
                          BlzGetTriggerPlayerIsKeyDown=lambda:self.down,
                          BlzSendSyncData=lambda *a:self.sent.append(a) if a[0]!='WOSPMOUSE' else None)
            return e_run(n,args,**kw)
        self.p.vm.run=ping_run;self.e.run=emoji_run
        shared['WUI_HOTKEY_PING']=0;shared['WUI_HOTKEY_EMOTE']=1
        shared['WUI_HotkeyName']=defaultdict(lambda:'K')
    def test_hold_switch_cancelled_releases_and_repeat_keys_never_send_or_reopen_old_wheel(self):
        self.p.vm.run('TMP_OnKey');self.assertTrue(self.p.vm.g['TMP_Open'])
        self.e.run('OnEmojiKey');self.assertFalse(self.p.vm.g['TMP_Open'])
        self.assertTrue(self.visible['emoji'])
        self.p.vm.run('TMP_OnKey');self.assertFalse(self.p.vm.g['TMP_Open'])
        self.p.key_down=False;self.p.vm.run('TMP_OnKey')
        self.assertEqual([],self.p.sync);self.assertTrue(self.visible['emoji'])
        self.p.key_down=True;self.p.vm.run('TMP_OnKey')
        self.assertTrue(self.p.vm.g['TMP_Open']);self.assertFalse(self.visible['emoji'])
        self.e.run('OnEmojiKey');self.assertFalse(self.visible['emoji'])
        self.down=False;self.e.run('OnEmojiKey');self.assertEqual([],self.sent)
        self.down=True;self.e.run('OnEmojiKey')
        self.assertFalse(self.p.vm.g['TMP_Open']);self.assertTrue(self.visible['emoji'])
        self.assertEqual(0,len(self.handles))
    def test_toolbar_switch_also_closes_previous_without_committing(self):
        self.p.vm.run('TMP_ShowWheel')
        self.e.run('Emoji_ToggleMenu',(0,))
        self.assertFalse(self.p.vm.g['TMP_Open']);self.assertTrue(self.visible['emoji'])
        self.p.vm.run('TMP_ShowWheel')
        self.assertTrue(self.p.vm.g['TMP_Open']);self.assertFalse(self.visible['emoji'])
        self.assertEqual([],self.sent);self.assertEqual([],self.p.sync)

    def test_k_key_and_toolbar_disable_ping_target_before_opening_emotes(self):
        for toolbar in (False,True):
            self.p.vm.g['WUI_ResetClickedButtonFocus']=lambda:None
            self.p.vm.run('TMP_OnKey');self.p.choose(2)
            self.assertEqual(2,self.p.vm.g['TMP_TargetKind'][0]);self.assertTrue(self.p.enabled)
            if toolbar:self.e.run('Emoji_ToggleMenu',(0,))
            else:self.e.run('OnEmojiKey')
            self.assertFalse(self.p.enabled);self.assertEqual(0,self.p.vm.g['TMP_TargetKind'][0])
            self.assertFalse(self.p.vm.g['TMP_Open'])
            self.p.vm.run('TMP_OnTargetClick');self.assertFalse(self.p.effects)
            self.p.key_down=False;self.p.vm.run('TMP_OnKey');self.p.key_down=True
            self.down=False;self.e.run('OnEmojiKey');self.down=True

class DirectPresentation(unittest.TestCase):
    def test_meter_wrappers_preserve_fill_clamp_and_native_slider_values(self):
        vm=ui.load_source('WOSUI.j');sizes={};native=[]
        vm.g.update(LoadFrameHandle=lambda t,k,c:t.get((k,c)),BlzFrameSetSize=lambda f,w,h:sizes.update({f:(w,h)}),
            BlzFrameSetMinMaxValue=lambda *a:native.append(('range',)+a),
            BlzFrameSetValue=lambda *a:native.append(('value',)+a))
        key=vm.g['GetHandleId'](101)
        vm.g['WUI_BarInfo'][(key,2)]='fill'
        vm.g['WUI_BarInfo'][(key,3)]=.2
        vm.run('WUI_FrameSetMinMaxValue',(101,10.,30.))
        for value,width in [(20.,.1),(40.,.2),(0.,.0002)]:
            vm.run('WUI_FrameSetValue',(101,value))
            self.assertAlmostEqual(width,sizes['fill'][0])
        vm.run('WUI_SetValue',(101,25.))
        self.assertAlmostEqual(.15,sizes['fill'][0])
        before=dict(sizes)
        vm.run('WUI_FrameSetMinMaxValue',(202,0.,100.))
        vm.run('WUI_FrameSetValue',(202,42.))
        self.assertEqual(before,sizes)
        self.assertEqual(('value',202,42.),native[-1])

    def test_minimap_info_and_expanded_stats_allow_asymmetric_clients_without_dispatch(self):
        from test_wos_ui_multiplayer import MultiplayerFrames
        from test_wos_ui_expansion import Expansion
        fixture=MultiplayerFrames();clients=[fixture.client(i) for i in [0,1]]
        def forbidden(*_):self.fail('runtime presentation dispatch')
        for f,_,_ in clients:
            for native in ['ExecuteFunc','TriggerExecute','TriggerEvaluate']:f.vm.g[native]=forbidden
        for actor,key in [(0,'WUI_MinimapToggle'),(1,'WUI_InfoToggle'),(0,'WUI_MinimapToggle')]:
            for f,_,_ in clients:
                g=f.vm.g;g['GetTriggerPlayer']=lambda a=actor:a
                g['BlzGetTriggerFrame']=lambda g=g,k=key:g[k]
                f.vm.run('WUI_OnPanelToggle')
            for state in ['WUI_MinimapHiddenOf','WUI_InfoHiddenOf']:
                self.assertEqual([clients[0][0].vm.g[state][p] for p in range(24)],
                                 [clients[1][0].vm.g[state][p] for p in range(24)])
        modes=Expansion();vms=[modes.mode(i)[0] for i in [0,1]]
        for i in range(30):
            modes.actor=i%2
            for vm in vms:
                for native in ['ExecuteFunc','TriggerExecute','TriggerEvaluate']:vm.g[native]=forbidden
                vm.run('UNITSTAT_OnModeClick')
            self.assertEqual(dict(vms[0].g['WUI_HudModeOf']),dict(vms[1].g['WUI_HudModeOf']))

    def test_hero_requests_wait_for_data_then_drain_once_before_purchase_or_sync(self):
        vm=ui.load_source('WoS_Shop_Init.j');seen=[]
        vm.g.update(QB_Data=None,WUI_ShopHeroRequest=defaultdict(int),
                    QB_OnHero=lambda *a:seen.append(a))
        vm.g['WUI_ShopHeroRequest'][1]=123
        vm.g['WUI_ShopHeroRequest'][8]=456
        vm.run('QB_ApplyHeroRequests');self.assertEqual([],seen)
        vm.g['QB_Data']={}
        vm.run('QB_ApplyHeroRequests');vm.run('QB_ApplyHeroRequests')
        self.assertEqual([(1,123),(8,456)],seen)
        self.assertEqual(0,vm.g['WUI_ShopHeroRequest'][1])
        source=(ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8-sig')
        for name in ['QB_OnSync','AutoBuyPeriodic','ShopSearchDebounceTick']:
            body=source.split('function '+name+' ',1)[1].split('endfunction',1)[0]
            self.assertIn('call QB_ApplyHeroRequests()',body,name)

    def test_shop_close_and_render_serials_are_consumed_once_without_dispatch(self):
        vm=ui.load_source('WoS_Shop_Init.j');events=[]
        vm.g.update(GetLocalPlayer=lambda:0,Shop_Active=defaultdict(bool),
            WUI_ShopCloseSerial=1,WUI_ShopRenderSerial=2,
            QB_CancelDrag=lambda:events.append('cancel'),QB_RenderLocal=lambda:events.append('render'),
            QB_DragFrom=-1,REC_DragFrom=-1)
        vm.run('QB_CheckDrag');vm.run('QB_CheckDrag')
        self.assertEqual(['cancel','render'],events)
        self.assertEqual(1,vm.g['QB_SeenCloseSerial'])
        self.assertEqual(2,vm.g['QB_SeenRenderSerial'])

    def test_hud_shift_invalidates_pip_cache_without_new_timer_or_callback(self):
        vm=ui.load_source('ShowCD.j')
        vm.g.update(WUI_HudRevision=3,AHUI_SeenHudRevision=2,AHUI_UpdateTick=0,AHUI_TipClock=0,AHUI_TipEpoch=0,
            bj_MAX_PLAYER_SLOTS=0,AR_Reconcile=lambda:None)
        vm.g['AHUI_PipTexture'][0]='old'
        vm.run('AHUI_Periodic')
        self.assertIsNone(vm.g['AHUI_PipTexture'][0])
        self.assertEqual(3,vm.g['AHUI_SeenHudRevision'])
        vm.g['AHUI_PipTexture'][0]='fresh'
        vm.run('AHUI_Periodic')
        self.assertEqual('fresh',vm.g['AHUI_PipTexture'][0])

class CompiledDispatchGuard(unittest.TestCase):
    def test_hidden_forward_dispatch_is_rejected_but_direct_call_passes(self):
        from audit_wos_ui_dispatch import functions,paths,DISPATCH,classification
        source='''function event takes nothing returns nothing
    call draw()
endfunction
function draw takes nothing returns nothing
    call TriggerEvaluate(forward)
endfunction
'''
        table=functions(source)
        bad,_=paths(table,'event',DISPATCH)
        self.assertEqual([['event','draw','TriggerEvaluate']],bad)
        self.assertIsNone(classification(bad[0],table))
        table=functions(source.replace('call TriggerEvaluate(forward)','call BlzFrameSetVisible(panel, false)'))
        self.assertEqual([],paths(table,'event',DISPATCH)[0])

    def test_startup_exception_does_not_allow_arbitrary_runtime_execute(self):
        from audit_wos_ui_dispatch import classification,root_names
        for name in ['EmojiStandalone__Periodic','EmojiStandalone___Periodic']:
            self.assertEqual([name],root_names({name:''},'EmojiStandalone__Periodic'))
        self.assertEqual('shared initial pick allocation',classification(
            ['PrepareNormalPick','ExecuteFunc'],{'PrepareNormalPick':'call ExecuteFunc("CreateUI")'}))
        self.assertIsNone(classification(['PrepareNormalPick','ExecuteFunc'],
            {'PrepareNormalPick':'call ExecuteFunc("runtime")'}))
        self.assertIsNone(classification(['WUI_OnPanelToggle','TriggerExecute'],{}))

    def test_explicit_local_frame_branch_cannot_reach_hidden_handle_creation(self):
        from audit_wos_ui_dispatch import functions,local_paths
        source='function draw takes nothing returns nothing\n    if GetLocalPlayer() == viewer then\n        call make()\n        call BlzFrameSetVisible(panel, true)\n    endif\nendfunction\nfunction make takes nothing returns nothing\n    set t = CreateTimer()\nendfunction\n'
        table=functions(source)
        self.assertEqual([['draw','make','CreateTimer']],local_paths(table,['draw']))
        self.assertEqual([],local_paths(functions(source.replace('set t = CreateTimer()','set x = 1')),['draw']))

if __name__=='__main__':unittest.main()
