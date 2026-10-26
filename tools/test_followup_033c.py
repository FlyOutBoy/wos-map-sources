"""Execute the 0.33c cooldown, movement, counter and local HUD paths."""
from collections import defaultdict
from pathlib import Path
import re
import math
import json
import unittest

from test_crocodile import JassState
import test_ability_range_preview as range_fixture

ROOT = Path(__file__).resolve().parents[1]


def source(name):
    return (ROOT/'triggers'/name).read_text(encoding='utf-8-sig')


def functions(text, *names):
    return '\n'.join(re.search(r'(?m)^\s*(?:(?:private|public) )?function '+name+
        r' takes[^\n]*\n[\s\S]*?^\s*endfunction', text)[0] for name in names)


class TwoRingLifecycle:
    """MAIN preview: each hero owns a red (click) and a white (reach) ring: a=1/2, b=3/4."""
    def two_ring_globals(self):
        self.cast = None
        self.vm.g.update(AR_Outer=defaultdict(lambda: None), AR_OuterScale=0., AR_MODEL_OUTER='outer.mdx', AR_MAX_RADIUS=4000.,
            AAUniversalTooltips_GetPreviewCastRange=lambda u, a: self.cast if self.cast is not None else self.radius)

    def test_synced_create_hidden_deduplicated_and_reused(self):
        self.vm.g['TestUnit'] = 'a'
        self.vm.g['Hero'][2] = 'b'
        self.runj('AR_Reconcile')
        self.assertEqual(self.number, 4)
        self.assertEqual([c for c in self.calls if c[0] == 'alpha'], [('alpha', i, 0) for i in (1, 2, 3, 4)])
        self.show()
        self.radius = 1024
        self.show()
        self.assertEqual(self.number, 4)
        self.assertIn(('scale', 1, 1.0), self.calls)
        self.assertIn(('scale', 1, 2.0), self.calls)
        self.assertIn(('position', 1, 123.0, 456.0, 50.0), self.calls)

    def test_only_owner_can_show_and_wrong_client_does_nothing(self):
        self.calls.clear(); self.show('b')
        self.assertFalse(self.calls)
        self.local = 1; self.show('a', 0)
        self.assertFalse(self.calls)
        self.show('b', 1)
        self.assertIn(('alpha', 3, 255), self.calls)

    def test_swap_retires_all_old_effects_before_creating_replacements(self):
        self.calls.clear()
        self.vm.g['Hero'][0] = 'b'; self.vm.g['Hero'][1] = 'a'
        self.runj('AR_Reconcile')
        lifecycle = [c[0] for c in self.calls if c[0] in ('create', 'destroy')]
        self.assertEqual(lifecycle, ['destroy'] * 4 + ['create'] * 4)

    def test_hover_cancel_and_other_player_leave_are_local_only(self):
        self.show(); self.runj('AR_Hide', 1)
        self.assertEqual(self.vm.g['AR_Visible'], 0)
        self.runj('AR_Cancel', 0)
        self.assertEqual(self.vm.g['AR_Visible'], -1)
        self.assertEqual(self.number, 4)

    def test_red_click_range_and_larger_white_reach(self):
        self.cast = 1000.; self.radius = 1400.; self.show()
        self.assertEqual(1000/512., self.vm.g['AR_Scale'])
        self.assertEqual(1400/512., self.vm.g['AR_OuterScale'])
        self.cast = 0.; self.radius = 600.; self.show()
        self.assertEqual(0., self.vm.g['AR_Scale'])
        self.assertEqual(600/512., self.vm.g['AR_OuterScale'])
        self.cast = 900.; self.radius = 900.; self.show()
        self.assertEqual(900/512., self.vm.g['AR_Scale'])
        self.assertEqual(0., self.vm.g['AR_OuterScale'])
        self.runj('AR_Hide', 0)
        self.assertEqual(0., self.vm.g['AR_OuterScale'])



class MainRangeRuntime(TwoRingLifecycle, range_fixture.RangeRuntime):
    SOURCE = 'triggers/WOS_Start/AbilityRangePreview.j'

    def configure_vm(self):
        self.vm.g.update(AR_ItemOwner=defaultdict(lambda: None),
            AR_CachedItem=defaultdict(lambda: None), AR_ItemAbility=defaultdict(lambda: None),
            AR_RequestedItemSlot=defaultdict(lambda: -1), UnitItemInSlot=lambda *_: None,
            AR_LastX=0., AR_LastY=0.)
        self.two_ring_globals()

    def test_thresholds_no_clamping_and_no_hidden_position_updates(self):
        # Circles are drawn up to 4000 inclusive; larger/global ranges are hidden.
        for radius in (-1, 0, 4000.01, 5000, 32768, 99999):
            self.calls.clear(); self.radius = radius; self.show()
            self.assertFalse(any(c[0] in ('position', 'scale') for c in self.calls))
            self.assertEqual(-1, self.vm.g['AR_Visible'])
        for radius in (1, 2500, 2500.01, 2700, 3999, 4000):
            self.radius = radius; self.show()
            self.assertEqual(radius/512., self.vm.g['AR_Scale'])

    def test_each_player_renders_own_hero_with_long_reach(self):
        for pid in range(10):
            self.setUp(); self.local = pid; self.owner['a'] = pid
            self.vm.g['Hero'].clear(); self.vm.g['Hero'][pid] = 'a'
            self.runj('AR_Reconcile'); self.radius = 3000
            self.show('a', pid)
            self.assertGreaterEqual(self.vm.g['AR_Visible'], 0)
            self.assertEqual(3000/512., self.vm.g['AR_Scale'])


class FollowupRuntime(unittest.TestCase):
    def test_hell_blaze_all_stacks_match_active_healing_and_regeneration(self):
        text=source('Systems/Systems2.j')
        code=functions(text,'GetHellBlazeCut','SetHpCurrent2','GetHealMultiplierNoBlock').replace('static if ','if ')
        constant=re.search(r'constant real HellBlaze_HealCutPerStack = [\d.]+',text)[0]
        buffs=['B01S','B01T','B01U','B01V','B01W','B02E','B02F']
        for stacks in range(8):
            vm=JassState('globals\n'+constant+'\nendglobals\n'+code)
            caster=vm.unit(owner=0);target=vm.unit(owner=1);target.life=100.
            for buff in buffs[:stacks]:vm.add_ability(target,buff)
            vm.g.update(LIBRARY_FrostnovaSpells=False,HellBlaze_HealCutPerStack=float(constant.rsplit('=',1)[1]),
                GetHealAmp=lambda u:0.,DarkHolyGrail_HpRegenReduce=30.,
                GetPlayerId=lambda p:p,
                IsUnitType=lambda *_:False,CheckCoordsInRect=lambda *_:True,
                gg_rct_Base='base',UNIT_STATE_LIFE='life',UNIT_STATE_MAX_LIFE='max-life',
                GetUnitState=lambda u,f:1000. if f=='max-life' else u.life,
                SetUnitState=lambda u,f,v:setattr(u,'life',v),
                PlayerHeal=defaultdict(int),PlayerHealAll=defaultdict(int))
            self.assertAlmostEqual(.055*stacks,vm.run('GetHellBlazeCut',(target,)))
            multiplier=vm.run('GetHealMultiplierNoBlock',(target,))
            self.assertAlmostEqual(1-.055*stacks,multiplier)
            vm.run('SetHpCurrent2',(caster,target,100.))
            self.assertAlmostEqual(100.+100.*multiplier,target.life)
        abilities=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
        objects=json.loads((ROOT/'object-data/buffs.json').read_text(encoding='utf-8-sig'))
        items=json.loads((ROOT/'object-data/items.json').read_text(encoding='utf-8-sig'))
        for level,buff in enumerate(buffs,1):
            amount=f'-{5.5*level:g}%'
            self.assertIn(amount,objects[buff]['extended_tooltip'])
            self.assertIn(amount,abilities['A0E6'][f'extended_tooltip level {level}'])
        self.assertIn('by 5.5%',items['I02F']['extended_tooltip'])

    def test_inori_w_level_35_heal_bonus_all_ranks(self):
        text = source('Heroes/Inori.j')
        vm = JassState(functions(text, 'InoriW_GetHealTotal'))
        hero = vm.unit(owner=0)
        for name, value in re.findall(r'real (InoriW_Heal\w+) = ([\d.]+)', text):
            vm.g[name] = float(value)
        for rank in range(1, 6):
            vm.add_ability(hero, 'A060')
            hero.abilities['A060']['level'] = rank
            for level in (1, 34, 35, 36):
                vm.g.update(InoriW_ID='A060', GetHeroLevel=lambda u:level,
                    GetHeroInt=lambda *_:100.)
                expected = 75 + 100 * (rank + (2 if level >= 35 else 0))
                self.assertEqual(expected, vm.run('InoriW_GetHealTotal', (hero,)))

    def test_hell_blaze_full_stack_mana_burn_and_retirement(self):
        text = source('Systems/Systems1.j')
        vm = JassState(functions(text, 'HellBlazeBurn_Tick'))
        hero = vm.unit(owner=0)
        vm.add_ability(hero, 'B02F')
        burns = []; paused = []
        percent = float(re.search(r'real HellBlaze_ManaBurnPercent = ([\d.]+)', text)[1])
        vm.g.update(HellBlazeBurn_Count=1, HellBlazeBurn_Unit={0:hero},
            HellBlaze_ManaBurnPercent=percent, UNIT_STATE_MAX_MANA='max',
            GetUnitState=lambda *_:1000., SetMpCurrent=lambda u,d:burns.append(d),
            hs={}, SH_HELLBLAZE_BURN='burn', HellBlazeBurn_Timer='timer',
            PauseTimer=lambda t:paused.append(t))
        vm.run('HellBlazeBurn_Tick'); vm.run('HellBlazeBurn_Tick')
        self.assertEqual([-13.5, -13.5], burns)
        hero.abilities.clear()
        vm.run('HellBlazeBurn_Tick')
        self.assertEqual(0, vm.g['HellBlazeBurn_Count'])
        self.assertEqual(['timer'], paused)

    def okarun_fixture(self, order='move', native_speed=300., level=1):
        vm = JassState(source('Heroes/Okarun.j')); hero = vm.unit(owner=0)
        ns = vm.structs['OkarunF_KS']; data = ns.create()
        for key,value in dict(c=hero,td=None,k2=0,check=hero.type,r3=300.,r2=0.,
                r5=600.,r7=0.,lastX=hero.x,lastY=hero.y).items(): setattr(data,key,value)
        ns.statics.update(MUI_OkarunF=0,m_OkarunF={0:data})
        vm.add_ability(hero, vm.g['OkarunT_Buff_ID'])
        vm.g.update(Hero={0:hero}, hs={}, SH_CURRENT_SPEED='speed seed',
            SH_CURRENT_SPEED1='current speed',SH_REAL_X='x',SH_REAL_Y='y',
            SH_UNIT_TARGET='target',SH_SPELL_P='spell pause',gg_rct_Base='base',
            GetHeroLevel=lambda u:level,GetUnitMoveSpeed=lambda u:native_speed,
            LoadUnitHandle=lambda table,p,k:table.get((p,k)),
            GAngle2=lambda u,x,y:math.atan2(y-u.y,x-u.x),
            R2SW=lambda value,*_:str(value),
            GetUnitCurrentOrder=lambda u:order,OrderId=lambda s:s,
            GetUnitFacing=lambda u:0.,IssuePointOrderById=lambda *_:None,
            IssueTargetOrderById=lambda *_:None,
            IsUnitPaused=lambda u:False,CheckCoordsInRect=lambda *_:False,
            PathableCheck3=lambda *_:True,WUI_HeroProgressText=lambda *_:None,
            OkarunF_AddSpeedPercentPerSec=5.,OkarunF_DecreaseSpeedPercentPerSec=1.2)
        vm.g['hs'][id(hero),'x']=10000.;vm.g['hs'][id(hero),'y']=0.
        return vm,hero,data

    def test_okarun_t_is_fixed_and_f_caps_total_speed_at_hero_level_thresholds(self):
        for level,expected in ((1,300.),(5,300.),(6,500.),(11,500.),(12,600.),(18,700.),(25,800.),(35,900.)):
            vm,hero,_ = self.okarun_fixture(level=level)
            self.assertEqual(1200.,vm.run('OkarunT_Speed',(hero,)))
            self.assertEqual(expected,vm.run('OkarunF_MaxSpeed',(hero,)))

    def test_okarun_legacy_control_adds_only_extra_speed_and_respects_stop(self):
        for order in ('move','smart','attack','absorb','ambush'):
            for native_speed in (0.,300.,522.):
                vm,hero,data = self.okarun_fixture(order=order,native_speed=native_speed)
                for _ in range(100):
                    hero.x += native_speed*.03
                    vm.run('Loop_OkarunF')
                self.assertAlmostEqual(1200.*3.,hero.x)
                self.assertAlmostEqual(0.,hero.y)
                self.assertAlmostEqual(1200.,vm.g['hs'][id(hero),'current speed'])
        # Stop/hold and immobilization must never be converted into movement.
        for order in ('stop','holdposition',0):
            vm,hero,_ = self.okarun_fixture(order=order)
            for _ in range(20):vm.run('Loop_OkarunF')
            self.assertEqual(0.,hero.x)
        vm,hero,_ = self.okarun_fixture()
        vm.add_ability(hero,'BEer')
        vm.run('Loop_OkarunF');self.assertEqual(0.,hero.x)

    def test_okarun_order_repeats_are_rate_limited_and_skip_active_casts(self):
        vm,hero,data=self.okarun_fixture();orders=[]
        vm.g['IssuePointOrderById']=lambda *args:orders.append(args)
        for _ in range(100):vm.run('Loop_OkarunF')
        self.assertEqual(14,len(orders));self.assertTrue(all(a[1]=='move' for a in orders))
        vm.g['hs'][id(hero),'spell pause']=1
        for _ in range(100):vm.run('Loop_OkarunF')
        self.assertEqual(14,len(orders))

    def test_okarun_f_turning_never_boosts_back_toward_old_target_or_during_cast(self):
        vm,hero,data=self.okarun_fixture()
        stale=vm.unit(owner=1,x=-2000.)
        vm.g['hs'][id(hero),'target']=stale
        vm.g['GetUnitFacing']=lambda u:90.
        vm.run('Loop_OkarunF')
        self.assertAlmostEqual(0.,hero.x)
        self.assertAlmostEqual(27.,hero.y)
        self.assertIsNone(data.td) # A point move must not track an old unit target.
        vm.g['hs'][id(hero),'spell pause']=1
        vm.run('Loop_OkarunF')
        self.assertAlmostEqual(27.,hero.y)

    def test_okarun_normal_speed_never_adds_native_speed_and_t_expiry_clamps_immediately(self):
        for level,cap in ((6,500.),(12,600.),(18,700.),(25,800.),(35,900.)):
            for order in ('move','stop','holdposition'):
                vm,hero,data=self.okarun_fixture(order=order,native_speed=342.,level=level)
                vm.run('Loop_OkarunF')
                self.assertEqual(1200.,data.r3)
                hero.abilities.pop(vm.g['OkarunT_Buff_ID'])
                vm.g['hs'][id(hero),'speed seed']=1242.
                vm.run('Loop_OkarunF')
                self.assertLessEqual(data.r3,cap)
                self.assertEqual(cap,data.r5)
                self.assertLessEqual(vm.g['hs'][id(hero),'current speed'],cap)
                vm.g['IsUnitPaused']=lambda u:True
                vm.g['hs'][id(hero),'speed seed']=1242.
                vm.run('Loop_OkarunF')
                self.assertLessEqual(data.r3,cap)
                self.assertLessEqual(vm.g['hs'][id(hero),'current speed'],cap)
                data.r3=cap
                for _ in range(100):vm.run('Loop_OkarunF')
                self.assertLessEqual(data.r3,cap)

    def test_okarun_tackle_has_per_target_caster_cooldown_and_stronger_same_time_push(self):
        text=source('Heroes/Okarun.j')+'\n'+functions(source('Systems/Systems2.j'),'IntegerCdKey')
        vm=JassState(text);hero=vm.unit(owner=0);enemy=vm.unit(owner=1,x=20.)
        ns=vm.structs['OkarunTBuff_KS'];data=ns.create();data.c=hero
        ns.statics['pushGroup']=vm.create_group()
        now=[0.];pending=[];pushes=[]
        vm.g.update(hs={},SH_OKARUN_T_TACKLE=100,OkarunT_PushInterval=.75,
            OkarunT_PushRange=450.,OkarunT_PushDuration=.35,OkarunT_PushAoe=350.,
            OkarunT_PushDamageInt=2.,GetHeroInt=lambda *_:10.,
            IsUnitPaused=lambda u:u.paused,
            GAngle=lambda a,b:math.atan2(b.y-a.y,b.x-a.x),
            MyFlush=lambda p,k,v,t:pending.append((now[0]+t,p,k,v)),
            MUE=lambda u,r,t,a:pushes.append((now[0],u,r,t)),DamageSource=lambda *_:None,
            dmgmag=lambda *_:None,EffectSpawn=lambda *_:None,
            AddSpecialEffectTarget=lambda *_:None,DestroyEffect=lambda *_:None)
        def tick(time):
            now[0]=time
            for at,parent,key,value in list(pending):
                if at<=time:
                    vm.g['hs'][parent,key]=value;pending.remove((at,parent,key,value))
            vm.run('tackle',obj=data)
        tick(0.);tick(.09);tick(.74)
        self.assertEqual(1,len(pushes))
        tick(.75);self.assertEqual(2,len(pushes))
        tick(1.49);self.assertEqual(2,len(pushes))
        tick(1.50);self.assertEqual(3,len(pushes))
        self.assertTrue(all(u is enemy and r==450. and t==.35 for _,u,r,t in pushes))
        hero.paused=True;tick(2.25);self.assertEqual(3,len(pushes))
        hero.paused=False;tick(2.25);self.assertEqual(4,len(pushes))

    def test_auto_selection_is_local_alive_only(self):
        vm = JassState(functions(source('WOS_Start/DefaultArmorChangeStable_Copy.j'), 'UNITSTAT_AutoSelectTick').replace('static if ', 'if '))
        hero = vm.unit(owner=1); alive = [True]; calls = []
        vm.g.update(TestMode=False,LIBRARY_WOSTestMinimalRuntime=False,WUI_AutoSelectHero=defaultdict(bool,{1:True}),UNITSTAT_AutoSelectElapsed=0., UNITSTAT_SeenSettingsRevision=0,
            WUI_SettingsRevision=0, UNITSTAT_AutoSelect=defaultdict(bool, {1: True}),
            Hero=defaultdict(lambda: None, {1: hero}), bj_MAX_PLAYER_SLOTS=10,
            GetPlayerSlotState=lambda p: 'playing', PLAYER_SLOT_STATE_PLAYING='playing',
            GetPlayerController=lambda p: 'user', MAP_CONTROL_USER='user',
            Player=lambda p: p, GetLocalPlayer=lambda: 1,
            UNITSTAT_ResolvePicked=lambda p: None, UNITSTAT_LayoutGold=lambda: None,
            UNITSTAT_Render=lambda *_: None, GearSelectOnlyHero=lambda u: calls.append(u),
            IsUnitHidden=lambda u: False, IsUnitType=lambda u,t: not alive[0], UNIT_TYPE_DEAD='dead')
        for _ in range(4): vm.run('UNITSTAT_AutoSelectTick')
        self.assertEqual([hero]*4, calls)
        alive[0] = False
        for _ in range(4): vm.run('UNITSTAT_AutoSelectTick')
        self.assertEqual(4, len(calls))
        alive[0] = True; vm.g['GetLocalPlayer'] = lambda: 0
        for _ in range(4): vm.run('UNITSTAT_AutoSelectTick')
        self.assertEqual(4, len(calls))
        vm.g['GetLocalPlayer'] = lambda: 1; vm.g['UNITSTAT_AutoSelect'][1] = False
        for _ in range(4): vm.run('UNITSTAT_AutoSelectTick')
        self.assertEqual(4, len(calls))

    def test_auto_selection_timer_runs_at_quarter_second_only_while_enabled(self):
        vm=JassState(functions(source('WOS_Start/DefaultArmorChangeStable_Copy.j'), 'UNITSTAT_SetAutoSelect', 'UNITSTAT_OnAutoSelect'))
        started=[];paused=[]
        vm.g.update(TestMode=False,GetPlayerId=lambda p:p,GetTriggerPlayer=lambda:0,GetLocalPlayer=lambda:0,
            Player=lambda p:p,UNITSTAT_AutoSelect=defaultdict(bool),WUI_AutoSelectHero=defaultdict(bool),UNITSTAT_AutoSelectUsers=0,
            UNITSTAT_AutoSelectTimer=None,UNITSTAT_AutoSelectToggle='button',
            UNITSTAT_AutoSelectTick=lambda:None,CreateTimer=lambda:'timer',
            TimerStart=lambda *a:started.append(a),PauseTimer=lambda t:paused.append(t),
            WUI_SetToggleState=lambda *_:None,WUI_ResetClickedButtonFocus=lambda:None)
        vm.run('UNITSTAT_OnAutoSelect')
        self.assertEqual(('timer',.25,True),started[0][:3])
        vm.run('UNITSTAT_SetAutoSelect',(0,True));self.assertEqual(1,len(started))
        self.assertTrue(vm.g['WUI_AutoSelectHero'][0])
        vm.run('UNITSTAT_OnAutoSelect');self.assertEqual(['timer'],paused)
        self.assertFalse(vm.g['WUI_AutoSelectHero'][0])
        vm.run('UNITSTAT_SetAutoSelect',(1,True));vm.run('UNITSTAT_SetAutoSelect',(2,True))
        self.assertEqual(2,vm.g['UNITSTAT_AutoSelectUsers']);self.assertEqual(2,len(started))
        vm.run('UNITSTAT_SetAutoSelect',(1,False));self.assertEqual(1,len(paused))
        vm.run('UNITSTAT_SetAutoSelect',(2,False));self.assertEqual(2,len(paused))

    def test_delayed_cooldown_repairs_reset_but_normal_reduction_cannot_start(self):
        text = source('Systems/Systems2.j')
        struct = 'private struct KS_Cooldown'+text.split('private struct KS_Cooldown', 1)[1].split('endstruct', 1)[0]+'endstruct'
        for ensure, remaining, target, expected in (
                (True, 0., 23., 22.9), (True, 0., 18.4, 18.3),
                (True, 22.9, 23., None), (True, 22.9, 18.4, 18.4),
                (False, 0., 23., None), (True, 0., 0., None)):
            vm = JassState(struct); hero = vm.unit(); vm.add_ability(hero, 'Q')
            writes = []; clock = []
            vm.g.update(GearTimer05Acquire=lambda: clock.append(1),
                GearTimer05Release=lambda: clock.append(-1),
                BlzGetUnitAbilityCooldownRemaining=lambda *_: remaining,
                BlzStartUnitAbilityCooldown=lambda u,a,t: writes.append(t))
            ns = vm.structs['KS_Cooldown']; ns.statics.update(MUI_24=-1, m_24={})
            vm.run('EnsureStart' if ensure else 'CD_Start', (hero, .03, 'Q', target))
            data = ns.m_24[0]; data.destroy = lambda: None
            vm.run('Loop_NextCD'); self.assertFalse(writes)
            vm.run('Loop_NextCD')
            self.assertEqual([1, -1], clock)
            if expected is None:
                self.assertEqual([], writes)
            else:
                self.assertEqual(1, len(writes)); self.assertAlmostEqual(expected, writes[0])

    def test_raiden_f_uses_own_ready_charge_at_early_level(self):
        vm = JassState(functions(source('WOS_Start/ShowCD.j'), 'AHUI_RequirementLocked', 'AHUI_PassiveLocked'))
        hero = vm.unit(owner=0); other = vm.unit(owner=1)
        vm.g.update(RaidenF_ID=10, TakeshiG_ID=20, Raiden_F_Dummy=None,
            AHUI_SLOT_F=5, AHUI_LevelData={(10, 1): 1},
            HaveSavedInteger=lambda table,p,k: (p,k) in table)
        self.assertTrue(vm.run('AHUI_RequirementLocked', (hero, 10)))
        vm.g['Raiden_F_Dummy'] = other
        self.assertTrue(vm.run('AHUI_RequirementLocked', (hero, 10)))
        vm.g['Raiden_F_Dummy'] = vm.unit(owner=0)
        self.assertFalse(vm.run('AHUI_RequirementLocked', (hero, 10)))
        self.assertFalse(vm.run('AHUI_PassiveLocked', (hero, 5, 10)))

    def test_gold_fold_unfold_and_hud_shift_keep_owner_and_font(self):
        vm = JassState(functions(source('WOS_Start/DefaultArmorChangeStable_Copy.j'), 'UNITSTAT_LayoutGold'))
        folded = [False]; places = []; scales = []
        vm.g.update(UNITSTAT_GoldHudRevision=-1, UNITSTAT_GoldFolded=False,
            UNITSTAT_Widget={7:'gold-owner'}, UNITSTAT_GoldIcon='icon', UNITSTAT_Gold='text',
            UNITSTAT_WidgetLeft={}, UNITSTAT_WidgetY={}, UNITSTAT_WidgetWidth={}, UNITSTAT_WidgetHeight={},
            WUI_HudRevision=1, WUI_HudShift=.02, WUI_ITEM_X=.676,
            WUI_InfoShown=lambda: not folded[0], WUI_Place=lambda *a: places.append(a),
            BlzFrameSetScale=lambda *a: scales.append(a), BlzFrameSetPoint=lambda *_: None,
            BlzFrameSetSize=lambda *_: None, BlzFrameClearAllPoints=lambda *_: None,
            FRAMEPOINT_LEFT='left', FRAMEPOINT_RIGHT='right')
        vm.run('UNITSTAT_LayoutGold'); self.assertAlmostEqual(.7995, places[-1][1])
        self.assertEqual(('text', .9), scales[-1])
        vm.run('UNITSTAT_LayoutGold'); self.assertEqual(1, len(places))
        folded[0] = True; vm.run('UNITSTAT_LayoutGold')
        self.assertAlmostEqual(.7175, places[-1][1]); self.assertEqual(('text', .68), scales[-1])
        vm.g['WUI_HudShift'] = -.01; vm.g['WUI_HudRevision'] = 2
        vm.run('UNITSTAT_LayoutGold'); self.assertAlmostEqual(.6875, places[-1][1])
        folded[0] = False; vm.run('UNITSTAT_LayoutGold')
        self.assertAlmostEqual(.7695, places[-1][1]); self.assertEqual(('text', .9), scales[-1])

    def test_laxus_release_has_no_stop_or_delayed_input_gate(self):
        vm = JassState(functions(source('Heroes/Laxus.j'), 'LaxusQ_Release'))
        hero = vm.unit(); paused = []; removed = []; selected = []
        vm.g.update(PauseUnit=lambda u,b: paused.append(b), SetUnitTimeScale=lambda *_: None,
            UnitRemoveAbility=lambda u,a: removed.append(a), GearSelectOnlyHero=lambda u: selected.append(u))
        vm.run('LaxusQ_Release', (hero, False)); self.assertEqual([False], paused)
        self.assertEqual([], removed); self.assertEqual([hero], selected)
        vm.run('LaxusQ_Release', (hero, True)); self.assertEqual(['Avul'], removed)

    def test_laxus_q2_releases_on_the_same_tick_as_beam_retraction(self):
        vm = JassState(source('Heroes/Laxus.j')); hero = vm.unit()
        ns = vm.structs['LaxusQ_KS']; data = ns.create()
        for key,value in dict(c=hero,r=.30,rmax=1.50,check=1,r2=500.,r7=500.,
                a=0.,x=500.,y=0.,l=None,e=None,g=None,g2=None,casterReleased=True).items():
            setattr(data,key,value)
        ns.statics.update(MUI_LaxusQ2=0,m_LaxusQ2={0:data})
        released = []; restored = []; paused = []
        vm.g.update(LaxusQ2_IsInvul=False,LaxusQ_CasterLightningHeight2=100.,
            SpellBoolCaster=lambda u: True,DebugUnit2=lambda u: paused.append(True),
            MoveLightningEx=lambda *_:None,GetUnitFlyHeight=lambda u:0.,
            PauseUnit=lambda u,b:released.append(u),SetUnitTimeScale=lambda *_:None,
            GearSelectOnlyHero=lambda *_:None,SetUnitAnimationByIndex=lambda u,a:restored.append(u),
            hs={},SH_ORD_MODE='order mode')
        data.LaxusTimer03Release = lambda:None
        data.deallocate = lambda *_:None
        vm.run('Loop_LaxusQ2')
        self.assertEqual(-1,ns.MUI_LaxusQ2)
        self.assertEqual([],released); self.assertEqual([],restored)

    def test_laxus_q2_unpauses_at_launch_and_cleanup_does_not_unpause_next_cast(self):
        vm=JassState(source('Heroes/Laxus.j'));hero=vm.unit();hero.paused=True
        ns=vm.structs['LaxusQ_KS'];data=ns.create()
        for key,value in dict(c=hero,r=.57,rmax=1.50,check=0,check2=0,r2=0.,r3=0.,r4=0.,r7=0.,
                move=0.,a=0.,x=0.,y=0.,aoe=350.,dmg=0.,casterReleased=False,
                l=None,e=None,g=vm.create_group(),g2=vm.create_group()).items():setattr(data,key,value)
        ns.statics.update(MUI_LaxusQ2=0,m_LaxusQ2={0:data})
        unpauses=[]
        vm.g.update(LaxusQ2_IsInvul=False,LaxusQ2_CastTime=.60,LaxusQ_Range2=1800.,
            LaxusQ_CasterLightningHeight2=100.,SpellBoolCaster=lambda u:True,
            PauseUnit=lambda u,b:(setattr(u,'paused',b),unpauses.append(b)),
            GearSelectOnlyHero=lambda *_:None,SetUnitAnimationByIndex=lambda *_:None,
            AddLightningEx=lambda *_:'beam',MoveLightningEx=lambda *_:None,
            PathableCheck=lambda *_:True,GetUnitFlyHeight=lambda u:0.,
            EffectSpawnColor=lambda *_:None,DestroyEffect=lambda *_:None,
            DestroyLightning=lambda *_:None,hs={},SH_ORD_MODE='mode')
        data.deallocate=lambda *_:None;data.LaxusTimer03Release=lambda:None
        vm.run('Loop_LaxusQ2')
        self.assertTrue(data.casterReleased);self.assertFalse(hero.paused)
        self.assertEqual([False],unpauses);self.assertEqual(0,ns.MUI_LaxusQ2)
        hero.paused=True;data.check=1;data.r2=data.r7
        vm.run('Loop_LaxusQ2')
        self.assertTrue(hero.paused);self.assertEqual([False],unpauses)
        self.assertEqual(-1,ns.MUI_LaxusQ2)


if __name__ == '__main__':
    unittest.main()
