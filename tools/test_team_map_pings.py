"""Execute the production ping handlers across allied and enemy clients."""
from collections import defaultdict
from pathlib import Path
import re
import math
import struct
import tempfile
from types import SimpleNamespace
import unittest

from test_crocodile import JassState
import test_wos_ui as ui
from install_team_ping_assets import install, ASSET_NAMES

ROOT = Path(__file__).resolve().parents[1]


class TeamMapPings(unittest.TestCase):
    def setUp(self):
        source = (ROOT/'triggers/WOS_Start/TeamMapPings.j').read_text(encoding='utf-8-sig')
        self.vm = ui.load_source('TeamMapPings.j')
        self.control_sync=[]
        self.viewer = 0
        self.sender = 0
        self.data = ''
        self.key = 'Z'
        self.key_down = True
        self.screen_x = 490
        self.screen_y = 380
        self.mouse = 'left'
        self.mousePressed = False
        self.enabled=set()
        self.timer_running=False
        self.world_x,self.world_y=200,350
        self.focus_resets=0
        self.frame = None
        self.event = 'click'
        self.effects = []
        self.tags = []
        self.messages = []
        self.pings = []
        self.sync = []
        self.frames = {}
        self.ready_callbacks = []
        self.registrations = []
        self.frame_points = {}
        self.terrain_visible = True
        g = self.vm.g
        g.setdefault('WUI_EnterWheel', lambda *_: None)
        g.setdefault('WUI_RegisterWheelClose', lambda *_: None)
        g.setdefault('WUI_ReleaseClickFocus', lambda: None)  # External owner; tested in test_wos_ui_focus.
        for kind, name, value in re.findall(r'^\s*private (?:constant )?(integer|real|boolean|string|framehandle|timer|group) (\w+) = (.*)', source, re.M):
            g[name] = eval(value.replace('null','None').replace('false','False'), {}, g)
        for kind, name in re.findall(r'^\s*private (\w+) array (\w+)', source, re.M):
            default = 0 if kind in ('integer','real') else None
            g[name] = defaultdict(lambda v=default:v)
        constants = ['FRAMEPOINT_CENTER','FRAMEPOINT_TOP','FRAMEPOINT_BOTTOMRIGHT','TEXT_JUSTIFY_MIDDLE','TEXT_JUSTIFY_CENTER',
                     'ORIGIN_FRAME_GAME_UI','ORIGIN_FRAME_MINIMAP','FRAMEPOINT_BOTTOM','FRAMEPOINT_BOTTOMLEFT','UNIT_TYPE_HERO','FRAMEEVENT_CONTROL_CLICK','FRAMEEVENT_MOUSE_ENTER','FRAMEEVENT_MOUSE_LEAVE',
                     'EVENT_PLAYER_MOUSE_DOWN','EVENT_PLAYER_MOUSE_MOVE','PLAYER_SLOT_STATE_PLAYING','MAP_CONTROL_USER']
        g.update({name:name for name in constants})
        g.update(OSKEY_Z='Z', OSKEY_ESCAPE='esc', MOUSE_BUTTON_TYPE_LEFT='left', MOUSE_BUTTON_TYPE_RIGHT='right',
                 FRAMEEVENT_CONTROL_CLICK='click', FRAMEEVENT_MOUSE_ENTER='enter', FRAMEEVENT_MOUSE_LEAVE='leave')
        g.update({
            'BlzIsMouseButtonPressed':lambda k:self.mousePressed and k==self.mouse,
            'Player':lambda p:p, 'GetPlayerId':lambda p:p, 'GetLocalPlayer':lambda:self.viewer,
            'WUI_GetInfoRoot':lambda:'info-owner', 'WUI_GetRoot':lambda:'independent-root',
            'WUI_PlaceToolbar': lambda f,c,r: self.frame_points.update({f: ('FRAMEPOINT_CENTER', .718 + c*.026, .060 - r*.028)}),
            'WUI_OnReady':self.ready_callbacks.append,
            'GetTriggerPlayer':lambda:self.sender, 'GetPlayerName':lambda p:f'Player {p+1}',
            'IsPlayerAlly':lambda a,b:a//5==b//5,
            'GetPlayerSlotState':lambda p:g['PLAYER_SLOT_STATE_PLAYING'],
            'GetPlayerController':lambda p:g['MAP_CONTROL_USER'],
            'bj_mapInitialPlayableArea':'map', 'GetRectMinX':lambda r:-1000, 'GetRectMinY':lambda r:-1000,
            'GetRectMaxX':lambda r:1000, 'GetRectMaxY':lambda r:1000,
            'GetCameraBoundMinX':lambda:-1000, 'GetCameraBoundMinY':lambda:-1000,
            'GetCameraBoundMaxX':lambda:1000, 'GetCameraBoundMaxY':lambda:1000,
            'BlzGetTriggerSyncData':lambda:self.data, 'StringLength':len, 'SubString':lambda s,a,b:s[a:b],
            'S2I':lambda s:int(s) if s.lstrip('-').isdigit() else 0, 'S2R':float,
            'R2SW':lambda v,w,p:f'{v:.{p}f}', 'R2S':str, 'I2S':str,
            'I2R':float, 'ModuloInteger':lambda a,b:a%b,
            'IsUnitHidden':lambda u:u.hidden,
            'IsUnitEnemy':lambda u,p:u.owner//5 != p//5,
            'IsUnitVisible':lambda u,p:p in u.visible_to,
            'IsUnitDetected':lambda u,p:p in u.detected_by,
            'IsUnitType':lambda u,t:u.hero,
            'GetUnitName':lambda u:u.name,
            'IsUnitIllusion':lambda u:(_ for _ in ()).throw(AssertionError('Ping must not inspect illusions')),
            'IsVisibleToPlayer':lambda x,y,p:self.terrain_visible,
            'AddSpecialEffect':self.effect, 'DestroyEffect':lambda e:setattr(e,'destroyed',True),
            'CreateTextTag':self.tag,
            'DestroyTextTag':lambda t:setattr(t,'destroyed',True),
            'SetTextTagText':lambda t,v,*_:setattr(t,'text',v),
            'SetTextTagPos':lambda t,x,y,z:setattr(t,'point',(x,y,z)),
            'SetTextTagVisibility':lambda t,v:setattr(t,'visible',v),
            'SetTextTagColor':lambda t,*a:setattr(t,'alpha',a[-1]), 'SetTextTagPermanent':lambda *a:None,
            'SetTextTagLifespan':lambda t,v:setattr(t,'lifespan',v), 'SetTextTagFadepoint':lambda *a:None,
            'BlzSetSpecialEffectColor':lambda e,*rgb:setattr(e,'color',rgb),
            'BlzSetSpecialEffectScale':lambda e,s:setattr(e,'scale',s),
            'BlzSetSpecialEffectAlpha':lambda e,a:setattr(e,'alpha',a),
            'PingMinimapEx':lambda *a:self.pings.append(a),
            'DisplayTimedTextToPlayer':lambda *a:self.messages.append(a),
            'BlzSendSyncData':self.send_ui_sync,
            'BlzGetTriggerFrame':lambda:self.frame, 'BlzGetTriggerFrameEvent':lambda:self.event,
            'BlzGetTriggerPlayerKey':lambda:self.key, 'BlzGetTriggerPlayerMouseButton':lambda:self.mouse,
            'BlzGetTriggerPlayerIsKeyDown':lambda:self.key_down,
            'BlzGetTriggerPlayerMouseX':lambda:self.world_x, 'BlzGetTriggerPlayerMouseY':lambda:self.world_y,
            'BlzPixelToFrameX':lambda p:p/1000, 'BlzPixelToFrameY':lambda p:p/1000,
            'BlzGetMouseScreenPosX':lambda:self.screen_x, 'BlzGetMouseScreenPosY':lambda:self.screen_y,
            'BlzGetOriginFrame':lambda kind,*a:kind, 'BlzCreateFrameByType':self.create_frame,
            'BlzFrameGetWidth':lambda f:.14, 'BlzFrameGetHeight':lambda f:.14,
            'BlzConvertColor':lambda *a:a, 'BlzFrameSetVertexColor':lambda *a:None,
            'CreateTrigger':lambda:object(), 'CreateTimer':lambda:object(),
            'EnableTrigger':lambda t:self.enabled.add(t),'DisableTrigger':lambda t:self.enabled.discard(t),
            'TriggerAddAction':lambda *a:None, 'DestroyTrigger':lambda *a:None, 'TimerStart':lambda *a:setattr(self,'timer_running',True) if a[2] else None,  # one-shot preload timer is not the ping clock
            'PauseTimer':lambda *a:setattr(self,'timer_running',False),
            'ResumeTimer':lambda *a:setattr(self,'timer_running',True),
            'WUI_ResetClickedButtonFocus':lambda:setattr(self,'focus_resets',self.focus_resets+1),
            'BlzTriggerRegisterFrameEvent':lambda *a:self.registrations.append(a),
            'BlzTriggerRegisterPlayerKeyEvent':lambda *a:self.registrations.append(a),
            'BlzTriggerRegisterPlayerSyncEvent':lambda *a:self.registrations.append(a),
            'TriggerRegisterPlayerEvent':lambda *a:self.registrations.append(a),
            # Checkpoint 21: the ping key is a WOSUI rebindable channel (default Z).
            'WUI_HOTKEY_PING':0, 'WUI_GOLD':'|cffd5b876',
            'WUI_GetHotkey':lambda channel,pid:'Z', 'WUI_GetHotkeyName':lambda channel,pid:'Z',
            'WUI_RegisterHotkey':self.register_hotkey,
        })
        for name in ['BlzFrameSetPoint','BlzFrameSetAllPoints','BlzFrameClearAllPoints','BlzFrameSetAbsPoint','BlzFrameSetTextAlignment']:
            g[name] = lambda *a:None
        g['BlzFrameSetPoint'] = lambda f,*args:self.frame_points.__setitem__(f,args)
        for name, prop in [('BlzFrameSetText','text'),('BlzFrameSetVisible','visible'),('BlzFrameSetSize','size'),
                           ('BlzFrameSetTexture','texture'),('BlzFrameSetAlpha','alpha'),('BlzFrameSetEnable','enabled'),
                           ('BlzFrameSetLevel','level'),('BlzFrameSetScale','scale')]:
            g[name] = lambda f,*v,p=prop:self.frames.__setitem__((f,p),v[0] if len(v)==1 else v)
        self.vm.run('TMP_Init')
        self.assertFalse(self.frames, 'Pings must not create UI during map loading')
        for callback in self.ready_callbacks:
            callback()

    def register_hotkey(self, channel, trigger, key, name, both, owner):
        # Mirrors WUI_RegisterHotkey: every meta, press and release, per player.
        for pid in range(16):
            for meta in range(16):
                self.registrations.append((trigger, pid, key, meta, True))
                if both:
                    self.registrations.append((trigger, pid, key, meta, False))

    def create_frame(self,kind,name,*args):
        return f'{name}:{len(self.frames)}:{args[-1]}'

    def effect(self,model,x,y):
        effect = SimpleNamespace(model=model,x=x,y=y,destroyed=False)
        self.effects.append(effect)
        return effect

    def tag(self):
        tag = SimpleNamespace()
        self.tags.append(tag)
        return tag

    def send(self,kind=1,x=200,y=350):
        self.vm.run('TeamPing_Send',(self.sender,kind,x,y))

    def ticks(self,count):
        for _ in range(count):
            self.vm.run('TMP_Periodic')

    def enemy(self,x,y,hero=True,visible_to=range(10),detected_by=range(10),hidden=False,name='Crocodile'):
        u = self.vm.unit(owner=5,x=x,y=y)
        u.hero,u.hidden,u.name = hero,hidden,name
        u.visible_to,u.detected_by = set(visible_to),set(detected_by)
        return u

    def test_self_and_allies_get_action_name_point_and_minimap(self):
        self.viewer = 3
        self.send(2)
        self.assertTrue(all(e.model for e in self.effects))
        self.assertTrue(self.tags[0].visible)
        self.assertEqual((200,350,240),self.tags[0].point)
        self.assertIn('Attack',self.tags[0].text)
        self.assertIn('Player 1',self.vm.g['TMP_LastMessage'])
        self.assertEqual((200,350),self.pings[0][:2])

    def test_enemy_has_same_allocations_but_no_effect_chat_or_ping(self):
        self.viewer = 5
        self.send()
        self.assertEqual(['',''],[e.model for e in self.effects])
        self.assertFalse(self.tags[0].visible)
        self.assertFalse(self.messages)
        self.assertFalse(self.pings)
        self.assertFalse(self.frames[self.vm.g['TMP_MiniNameRoot'][0],'visible'])
        self.ticks(61)
        self.assertTrue(all(e.destroyed for e in self.effects))

    def test_minimap_name_is_at_projected_point_and_fades_after_two_seconds(self):
        self.viewer = 3
        self.send(2)
        root = self.vm.g['TMP_MiniNameRoot'][0]
        label = self.vm.g['TMP_MiniName'][0]
        self.assertTrue(self.frames[root,'visible'])
        self.assertIn('Player 1',self.frames[label,'text'])
        self.assertIn(self.vm.g['TMP_Color'][2],self.frames[label,'text'])
        anchor = self.frame_points[root]
        self.assertEqual(self.vm.g['TMP_Minimap'],anchor[1])
        self.assertAlmostEqual(.084,anchor[-2])
        self.assertAlmostEqual(.1115,anchor[-1])
        icon = self.vm.g['TMP_MiniIcon'][0]
        self.assertEqual('UI\\TeamPings\\symbol-attack.tga',self.frames[icon,'texture'][0])
        self.assertAlmostEqual(.0945,self.frame_points[icon][-1])
        self.ticks(31)
        self.assertTrue(self.frames[root,'visible'])
        self.assertLess(self.frames[root,'alpha'],255)
        self.ticks(9)
        self.assertFalse(self.frames[root,'visible'])

    def test_minimap_name_stays_inside_edges_and_players_expire_independently(self):
        self.send(1,-1000,1000)
        root0 = self.vm.g['TMP_MiniNameRoot'][0]
        self.assertAlmostEqual(.0445,self.frame_points[root0][-2])
        self.assertAlmostEqual(.123,self.frame_points[root0][-1])
        self.ticks(20)
        self.sender = 1
        self.send(4,1000,-1000)
        root1 = self.vm.g['TMP_MiniNameRoot'][1]
        self.assertAlmostEqual(.0955,self.frame_points[root1][-2])
        self.assertAlmostEqual(.017,self.frame_points[root1][-1])
        self.ticks(20)
        self.assertFalse(self.frames[root0,'visible'])
        self.assertTrue(self.frames[root1,'visible'])

    def test_shared_two_and_half_second_cooldown_is_per_sender(self):
        self.send(1)
        self.send(2)
        self.assertEqual(2,len(self.effects))
        self.sender = 1
        self.send(4)
        self.assertEqual(4,len(self.effects))
        self.sender = 0
        self.ticks(49)
        self.send(3)
        self.assertEqual(4,len(self.effects))
        self.ticks(1)
        self.send(3)
        self.assertEqual(6,len(self.effects))

    def choose(self,kind):
        self.frame=self.vm.g['TMP_Button'][kind];self.event='click'
        self.vm.run('TMP_OnFrame')

    def send_ui_sync(self,channel,data):
        self.sync.append((channel,data))

    def test_startup_has_only_ten_disabled_click_listeners_and_paused_timer(self):
        clicks=[r for r in self.registrations if 'EVENT_PLAYER_MOUSE_DOWN' in r]
        self.assertEqual(10,len(clicks));self.assertEqual(set(),self.enabled)
        self.assertFalse(any('EVENT_PLAYER_MOUSE_MOVE' in r for r in self.registrations))
        self.assertFalse(self.timer_running)
        self.assertEqual(10,len({id(self.vm.g['TMP_TargetTrigger'][p]) for p in range(10)}))

    def test_hover_and_key_release_do_not_send_or_arm_and_bounds_stay_fixed(self):
        self.vm.run('TMP_OnKey')
        for kind in range(1,6):
            self.frame=self.vm.g['TMP_Button'][kind];self.event='enter'
            before=self.frames[self.frame,'size'];anchor=self.frame_points[self.frame]
            self.vm.run('TMP_OnFrame');self.assertEqual(kind,self.vm.g['TMP_Hover'])
            self.assertEqual(255,self.frames[self.vm.g['TMP_Art'][kind],'alpha'])
            self.event='leave';self.vm.run('TMP_OnFrame')
            self.assertEqual(120,self.frames[self.vm.g['TMP_Art'][kind],'alpha'])
            self.assertEqual(before,self.frames[self.frame,'size']);self.assertEqual(anchor,self.frame_points[self.frame])
        self.key_down=False;self.vm.run('TMP_OnKey')
        self.assertTrue(self.vm.g['TMP_Open']);self.assertFalse(self.effects)
        self.assertFalse(self.sync);self.assertFalse(self.enabled);self.assertEqual(0,self.focus_resets)

    def test_frame_choice_then_one_world_click_sends_once_and_disables_listener(self):
        self.vm.run('TMP_OnKey');self.choose(4)
        target=self.vm.g['TMP_TargetTrigger'][0]
        self.assertEqual({target},self.enabled);self.assertFalse(self.vm.g['TMP_Open'])
        self.assertTrue(self.timer_running);self.assertEqual(1,self.focus_resets)
        self.vm.run('TMP_OnTargetClick')
        self.assertEqual(2,len(self.effects));self.assertIn('Need help',self.vm.g['TMP_LastMessage'])
        self.assertEqual((200,350),(self.effects[0].x,self.effects[0].y))
        self.assertFalse(self.enabled);self.assertEqual(0,self.vm.g['TMP_TargetKind'][0])
        self.assertFalse(self.frames[self.vm.g['TMP_Hint'],'visible'])
        self.vm.run('TMP_OnTargetClick');self.assertEqual(2,len(self.effects));self.assertFalse(self.sync)

    def test_ui_click_does_not_consume_target_and_right_click_cancels(self):
        self.choose(2);self.world_x=self.world_y=0
        self.vm.run('TMP_OnTargetClick');self.assertEqual(2,self.vm.g['TMP_TargetKind'][0])
        self.mouse='right';self.vm.run('TMP_OnTargetClick')
        self.assertEqual(0,self.vm.g['TMP_TargetKind'][0]);self.assertFalse(self.enabled);self.assertFalse(self.effects)

    def test_escape_new_z_and_timeout_cancel_only_the_requesting_player(self):
        self.choose(2);self.sender=1;self.choose(3)
        self.sender=0;self.key='esc';self.vm.run('TMP_OnKey')
        self.assertEqual(0,self.vm.g['TMP_TargetKind'][0]);self.assertEqual(3,self.vm.g['TMP_TargetKind'][1])
        self.ticks(162);self.assertFalse(self.enabled);self.assertFalse(self.timer_running)
        self.sender=0;self.choose(4);self.key='Z';self.key_down=True;self.vm.run('TMP_OnKey')
        self.assertEqual(0,self.vm.g['TMP_TargetKind'][0]);self.assertFalse(self.effects)

    def test_auto_repeat_does_not_cancel_an_armed_choice_or_reopen_cancelled_wheel(self):
        self.vm.run('TMP_OnKey');self.choose(1)
        for _ in range(20):self.vm.run('TMP_OnKey')
        self.assertEqual(1,self.vm.g['TMP_TargetKind'][0]);self.assertFalse(self.vm.g['TMP_Open'])
        self.key='esc';self.vm.run('TMP_OnKey');self.key='Z'
        self.vm.run('TMP_OnKey');self.assertFalse(self.vm.g['TMP_Open'])
        self.key_down=False;self.vm.run('TMP_OnKey');self.key_down=True;self.vm.run('TMP_OnKey')
        self.assertTrue(self.vm.g['TMP_Open'])

    def test_target_state_and_click_delivery_match_on_owner_ally_and_enemy(self):
        states=[]
        for viewer in (0,1,5):
            f=TeamMapPings();f.setUp();f.viewer=viewer;f.sender=0
            f.choose(2);self.assertEqual(2,f.vm.g['TMP_TargetKind'][0]);self.assertEqual(1,len(f.enabled))
            f.vm.run('TMP_OnTargetClick');f.ticks(62)
            states.append((f.vm.g['TMP_Count'],f.vm.g['TMP_TargetKind'][0],f.vm.g['TMP_Remaining'][0],f.timer_running))
            self.assertFalse(f.enabled);self.assertTrue(all(e.destroyed for e in f.effects))
        self.assertEqual([states[0]]*3,states)

    def test_repeated_pings_return_to_idle_without_new_trigger_or_timer_handles(self):
        handles=tuple(self.vm.g['TMP_TargetTrigger'][p] for p in range(10));registrations=len(self.registrations)
        def no_alloc(*a):self.fail('Input allocated a persistent handle')
        self.vm.g.update(CreateTrigger=no_alloc,DestroyTrigger=no_alloc,CreateTimer=no_alloc)
        for _ in range(60):
            self.choose(2);self.vm.run('TMP_OnTargetClick');self.ticks(62)
            self.assertFalse(self.timer_running);self.assertFalse(self.enabled)
            self.assertEqual(0,self.vm.g['TMP_Count']);self.assertEqual(0,self.vm.g['TMP_Remaining'][0])
        self.assertEqual(handles,tuple(self.vm.g['TMP_TargetTrigger'][p] for p in range(10)))
        self.assertEqual(registrations,len(self.registrations))
        self.assertTrue(all(e.destroyed for e in self.effects));self.assertTrue(all(t.destroyed for t in self.tags))

    def test_no_mouse_sampling_for_open_frames_or_active_marks(self):
        def forbidden(*a):self.fail('Z sampled the cursor/buttons')
        self.vm.g.update(BlzGetMouseScreenPosX=forbidden,BlzGetMouseScreenPosY=forbidden,BlzIsMouseButtonPressed=forbidden)
        self.vm.run('TMP_OnKey');self.choose(1);self.vm.run('TMP_OnTargetClick');self.ticks(62)
        self.assertFalse(self.timer_running)

    def test_cooldown_prevents_arming_but_all_five_orders_keep_distinct_models(self):
        self.send(1);self.choose(2);self.assertFalse(self.enabled)
        for kind in range(2,6):self.sender=kind-1;self.send(kind)
        self.assertEqual(5,len({e.model for e in self.effects[::2]}))

    def test_invalid_action_point_and_observer_are_rejected(self):
        for kind,x,y in [(0,200,350),(6,200,350),(1,1001,350),(1,200,-1001)]:
            self.send(kind,x,y)
        self.sender = 10
        self.send()
        self.assertFalse(self.effects)
        self.assertFalse(self.messages)
        for data in ['','1;2','1;;2','1;2;3;4','99;200;350']:
            self.data = data
            self.vm.run('TMP_OnSync')
        self.assertFalse(self.effects)

    def test_nonlocal_key_mouse_and_frame_do_not_touch_ui_or_send(self):
        self.sender = 1
        before = dict(self.frames)
        self.vm.run('TMP_OnKey')
        self.frame = self.vm.g['TMP_Button'][1]
        self.event = 'enter'
        self.vm.run('TMP_OnFrame')
        self.assertEqual(before,self.frames)
        self.assertFalse(self.sync)

    def test_visible_hero_wins_over_closer_creep_and_position_is_a_snapshot(self):
        self.enemy(201,350,hero=False,name='Footman')
        hero = self.enemy(650,350)
        self.send(2)
        self.assertEqual((650,350),(self.effects[0].x,self.effects[0].y))
        self.assertIn('Attack Crocodile',self.vm.g['TMP_LastMessage'])
        hero.x,hero.y = 900,900
        hero.visible_to.clear()
        self.ticks(10)
        self.assertEqual((650,350),(self.effects[0].x,self.effects[0].y))
        self.assertEqual((650,350,240),self.tags[0].point)

    def test_hidden_undetected_and_out_of_range_targets_are_never_revealed(self):
        self.enemy(210,350,hidden=True)
        self.enemy(220,350,visible_to=[5])
        self.enemy(230,350,detected_by=[5])
        self.enemy(701,350)
        self.send(2)
        self.assertEqual((200,350),(self.effects[0].x,self.effects[0].y))
        self.assertNotIn('Crocodile',self.vm.g['TMP_LastMessage'])

    def test_illusions_get_identical_priority_and_names(self):
        self.enemy(400,350)
        illusion = self.enemy(300,350)
        illusion.illusion = True
        self.send(2)
        self.assertEqual((300,350),(self.effects[0].x,self.effects[0].y))
        self.assertIn('Attack Crocodile',self.vm.g['TMP_LastMessage'])
        self.assertNotIn('illusion',self.vm.g['TMP_LastMessage'].lower())

    def test_blind_ally_receives_the_position_without_target_identity(self):
        self.viewer = 3
        self.enemy(300,350,visible_to=[0],detected_by=[0])
        self.vm.g['GetUnitName'] = lambda u:(_ for _ in ()).throw(AssertionError('Hidden name queried'))
        self.send(1)
        self.assertEqual((300,350),(self.effects[0].x,self.effects[0].y))
        self.assertIn('On my way',self.vm.g['TMP_LastMessage'])
        self.assertNotIn('Crocodile',self.vm.g['TMP_LastMessage'])

    def test_move_attack_and_danger_snap_but_help_and_rally_keep_ground_point(self):
        self.enemy(300,350)
        for kind,expected in [(1,'On my way to'),(2,'Attack'),(3,'Beware of'),(4,'Need help'),(5,'Group up here')]:
            self.sender = kind-1
            self.send(kind)
            self.assertIn(expected,self.vm.g['TMP_LastMessage'])
            self.assertEqual(300 if kind<=3 else 200,self.effects[-2].x)

    def test_toggle_mutes_incoming_pings_immediately_while_own_pings_still_work(self):
        self.sender,self.viewer = 1,0
        self.send(3)
        self.sender = 0
        self.frame = self.vm.g['TMP_Toggle']
        self.vm.run('TMP_OnFrame')
        self.assertTrue(self.vm.g['TMP_Muted'])
        self.assertFalse(self.tags[0].visible)
        self.assertEqual(0,self.effects[0].alpha)
        self.assertFalse(self.frames[self.vm.g['TMP_MiniIcon'][1],'visible'])
        self.sender = 2
        self.send(1)
        self.assertEqual(['',''],[e.model for e in self.effects[-2:]])
        self.assertFalse(self.tags[-2].visible)
        self.sender = 0
        self.vm.run('TMP_OnKey')
        self.assertTrue(self.vm.g['TMP_Open'])
        self.choose(2);self.vm.run('TMP_OnTargetClick')
        self.assertTrue(self.effects[-2].model)
        self.assertTrue(self.tags[-2].visible)
        self.assertTrue(self.frames[self.vm.g['TMP_MiniIcon'][0],'visible'])
        self.frame=self.vm.g['TMP_Toggle'];self.event='click'
        self.vm.run('TMP_OnFrame')
        self.assertFalse(self.vm.g['TMP_Muted'])
        self.assertTrue(self.tags[0].visible)  # Existing delivered ping can resume.
        self.assertFalse(self.tags[2].visible)  # Ping received while muted stays suppressed.

    def test_help_and_danger_keep_unit_scale_and_fog_symbols_grant_no_vision(self):
        self.terrain_visible = False
        self.send(3)
        self.sender = 1
        self.send(4)
        for index in [0,2]:
            self.assertEqual(1.0,self.effects[index].scale)
            self.assertEqual(360,self.tags[index].point[-1])
            self.assertTrue(self.tags[index+1].visible)
        self.ticks(20)
        for index in [0,2]:
            self.assertEqual(1.0,self.effects[index].scale)
        self.terrain_visible = True
        self.ticks(1)
        self.assertFalse(self.tags[1].visible)
        self.assertFalse(self.tags[3].visible)
        self.assertFalse(self.vm.vision_calls)
        self.ticks(40)
        self.assertTrue(all(t.destroyed for t in self.tags))
        self.assertEqual(0,self.vm.g['TMP_Count'])

    def test_wheel_assets_have_alpha_and_all_runtime_paths_exist(self):
        self.assertEqual(ASSET_NAMES,{p.stem for p in (ROOT/'assets/UI/TeamPings').glob('*.tga')})
        for texture in ['UI\\TeamPings\\'+name+'.tga' for name in ASSET_NAMES]:
            file = ROOT/'assets'/Path(texture.replace('\\','/'))
            header = file.read_bytes()[:18]
            self.assertEqual(2,header[2])  # Native, uncompressed true-color TGA.
            self.assertEqual((256,256),struct.unpack_from('<HH',header,12))
            self.assertEqual(32,header[16])
            self.assertEqual(8,header[17]&15)  # Transparent pixels between sectors.

    def test_map_asset_install_preserves_imports_and_is_idempotent(self):
        with tempfile.TemporaryDirectory() as tmp:
            base = Path(tmp)
            map_dir = base/'map'
            map_dir.mkdir()
            old_entry = b'\x0dexisting\\icon.blp\x00'
            original = struct.pack('<II',1,1)+old_entry
            imp = map_dir/'war3map.imp'
            imp.write_bytes(original)
            install(map_dir,backup_root=base/'backups')
            result = imp.read_bytes()
            self.assertEqual((1,17),struct.unpack_from('<II',result))
            self.assertEqual(old_entry,result[8:8+len(old_entry)])
            for name in ASSET_NAMES:
                self.assertIn(('UI\\TeamPings\\'+name+'.tga').encode(),result)
                self.assertEqual((ROOT/'assets/UI/TeamPings'/f'{name}.tga').read_bytes(),
                                 (map_dir/'UI/TeamPings'/f'{name}.tga').read_bytes())
            install(map_dir,backup_root=base/'backups')
            self.assertEqual(result,imp.read_bytes())
            self.assertEqual(1,len(list((base/'backups').iterdir())))


if __name__ == '__main__':
    unittest.main()
