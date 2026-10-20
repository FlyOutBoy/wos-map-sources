"""Execute production progress/hero clocks; Warcraft rendering remains external."""
from pathlib import Path
from collections import defaultdict
import re
import unittest

from test_crocodile import JassState
import test_ui_followup as progress_fixture
import test_wos_ui_checkpoint30 as counter_fixture

ROOT = Path(__file__).resolve().parents[1]
def source(path):
    return (ROOT / 'triggers' / path).read_text(encoding='utf-8-sig')

def bankai_vm():
    text = source('Heroes/Kyoraku.j')
    functions = re.findall(r'(?m)^\s*(?:(?:private|public)\s+)?function\s+Kyoraku(?:BankaiProgress|BankaiHelp|TSkip_Start)\s+takes[\s\S]*?^\s*endfunction', text)
    vm = JassState('\n'.join(functions))
    vm.g['KyorakuBankaiStage'] = defaultdict(int)
    return vm


class UnifiedProgress(unittest.TestCase):
    def setUp(self):
        self.fx = progress_fixture.Progress()
        self.fx.setUp()
        self.vm = self.fx.vm

    def test_bankai_stages_reuse_public_meter_and_change_art_for_every_viewer(self):
        fx, vm = self.fx, self.vm
        hero_vm = bankai_vm()
        textures = {}
        vm.g['BlzFrameSetTexture'] = lambda f, t, *_: textures.update({f: t})
        vm.g['WUI_RegisterPublicMeter'] = lambda *_: None
        hero_vm.g.update(vm.g)
        hero_vm.g.update(KyorakuT_ID=10, KyorakuT0_ID=20, KyorakuT1_ID=21,
            KyorakuT2_ID=22, KyorakuT3_ID=23, KyorakuT4_ID=24,
            SH_LAST_DAN='final', hs={},
            WUI_HeroProgressPublic=lambda *a: vm.run('WUI_HeroProgressPublic', a),
            WUI_HeroProgressIcon=lambda *a: vm.run('WUI_HeroProgressIcon', a))
        fx.local = 1
        for stage, caption in enumerate(['Bankai', '1-st stage', '2-nd stage', '3-rd stage', '4-th stage']):
            hero_vm.run('KyorakuBankaiProgress', (fx.hero, stage, 3., 5.))
            self.assertEqual(6, len(fx.created))
            self.assertIn(caption, fx.texts[vm.g['WUI_ProgressCaption'][1]])
            self.assertEqual(str(20 + stage), textures[vm.g['WUI_ProgressIcon'][1]])
        # Final execution replaces the third act even while its loop keeps check=3.
        hero_vm.g['hs'][id(fx.hero), 'final'] = 1
        hero_vm.run('KyorakuBankaiProgress', (fx.hero, 3, 2., 5.))
        self.assertIn('4-th stage', fx.texts[vm.g['WUI_ProgressCaption'][1]])
        self.assertEqual('24', textures[vm.g['WUI_ProgressIcon'][1]])
        hero_vm.run('KyorakuBankaiProgress', (fx.hero, 3, 0., 0.))
        self.assertFalse(fx.visible[vm.g['WUI_ProgressPanel'][1]])

    def test_bankai_help_height_shrinks_and_grows_with_rendered_text(self):
        vm = bankai_vm()
        heights, sizes = [], []
        measured = [0.12]
        vm.g.update(frame_KyorBankai7={0:'text'}, frame_KyorBankai12={0:'panel'},
            ABILITY_SLF_TOOLTIP_NORMAL='title', ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED='body',
            BlzGetUnitAbility=lambda *a: 'ability',
            BlzGetAbilityStringLevelField=lambda *a: 'description',
            BlzFrameSetSize=lambda *a: sizes.append(a), BlzFrameSetText=lambda *a: None,
            BlzFrameGetHeight=lambda *a: measured[0],
            WUI_ColumnHeight=lambda panel, height: heights.append(height))
        for value in [0.12, 0.02, 0.22, 0.0]:
            measured[0] = value
            vm.run('KyorakuBankaiHelp', ('hero', 0, 20))
        for got, want in zip(heights, [.136, .036, .236, .035]):
            self.assertAlmostEqual(want, got)
        self.assertEqual([('text', .164, 0.)] * 4, sizes)

    def test_skip_outside_bankai_is_removed_and_cannot_queue_next_cast(self):
        vm = bankai_vm()
        hero = vm.unit(owner=0)
        changes = []
        vm.add_ability(hero, 30)
        vm.g.update(KyorakuTSkip_ID=30, SH_INSTANT_SKIP='skip', hs={},
            BankaiActive=False, KyorakuBankaiCaster=hero,
            GetOwningPlayer=lambda u: u.owner,
            SetPlayerAbilityAvailable=lambda *a: changes.append(a))
        vm.run('KyorakuTSkip_Start', (hero,))
        self.assertEqual([(0, 30, False)], changes)
        self.assertEqual(0, vm.g['GetUnitAbilityLevel'](hero, 30))
        self.assertNotIn((id(hero), 'skip'), vm.g['hs'])
        vm.g['BankaiActive'] = True
        vm.add_ability(hero, 30)
        vm.run('KyorakuTSkip_Start', (hero,))
        self.assertEqual(1, vm.g['hs'][id(hero), 'skip'])
        text = source('Heroes/Kyoraku.j')
        cleanup = text.split('call KyorakuBankaiProgress(.c, .check, 0.00, 0.00)', 1)[1].split('set .c = null', 1)[0]
        self.assertIn('call UnitRemoveAbility(.c, KyorakuTSkip_ID)', cleanup)
        self.assertIn('KyorakuTSkip_ID, false)', cleanup)

    def test_curse_artwork_override_preserves_ability_key_and_other_meter(self):
        fx,vm=self.fx,self.vm;textures={}
        vm.g['BlzFrameSetTexture']=lambda f,t,*_:textures.update({f:t})
        fx.show(aid=10);fx.show(aid=11)
        before=dict(vm.g['WUI_ProgressKeys']);created=len(fx.created)
        vm.run('WUI_HeroProgressIcon',(fx.hero,10,'BTNHero_Kenjaku_F2.blp'))
        self.assertEqual('BTNHero_Kenjaku_F2.blp',textures[vm.g['WUI_ProgressIcon'][1]])
        self.assertNotEqual('BTNHero_Kenjaku_F2.blp',textures[vm.g['WUI_ProgressIcon'][2]])
        self.assertEqual(before,dict(vm.g['WUI_ProgressKeys']));self.assertEqual(created,len(fx.created))
        textures.clear();fx.local=1
        vm.run('WUI_HeroProgressIcon',(fx.hero,10,'BTNHero_Kenjaku_F2.blp'))
        self.assertFalse(textures)

    def test_charge_meter_resets_purple_and_enlarges_red_text_at_overcharge(self):
        vm,fx=self.vm,self.fx;textures={};scales={}
        vm.g.update(LoadFrameHandle=lambda t,k,c:t.get((k,c)),
            BlzFrameSetTexture=lambda f,tex,*_:textures.update({f:tex}),
            BlzFrameSetScale=lambda f,n:scales.update({f:n}))
        vm.run('WUI_HeroProgressCharge',(fx.hero,10,'X-Burner',37.5,125.,False))
        bar=vm.g['WUI_ProgressBar'][1];label=vm.g['WUI_ProgressValue'][1]
        self.assertIn('37.5%',fx.texts[label]);self.assertTrue(textures[bar].endswith('meter-fill.tga'))
        small=scales[label]
        vm.run('WUI_HeroProgressCharge',(fx.hero,10,'X-Burner',125.,125.,True))
        self.assertTrue(textures[bar].endswith('meter-fill-red.tga'));self.assertGreater(scales[label],small)
        vm.run('WUI_HeroProgressCharge',(fx.hero,10,'X-Burner',0.,125.,False))
        self.assertEqual(small,scales[label]);self.assertTrue(textures[bar].endswith('meter-fill.tga'))
        self.assertEqual(6,len(fx.created))

    def test_tsuna_charge_is_continuous_and_legacy_buff_widget_is_removed(self):
        import re
        text=source('Heroes/Tsuna.j');helper=text.split('function TsunaT_DisplayCharge ',1)[1].split('endfunction',1)[0];vm=JassState('function TsunaT_DisplayCharge '+helper+'endfunction')
        for name in ['TsunaT_ChargeTimeFull','TsunaT_OverchargeTime','TsunaT_OverchargeDmgPct']:
            vm.g[name]=float(re.search(r'real '+name+r' = ([0-9.]+)',text)[1])
        full=.3+vm.g['TsunaT_ChargeTimeFull'];end=vm.g['TsunaT_OverchargeTime']
        self.assertEqual(0.,vm.run('TsunaT_DisplayCharge',(0.,True)))
        self.assertEqual(100.,vm.run('TsunaT_DisplayCharge',(full,True)))
        self.assertAlmostEqual(112.5,vm.run('TsunaT_DisplayCharge',((full+end)/2,True)))
        self.assertEqual(125.,vm.run('TsunaT_DisplayCharge',(end+1,True)))
        self.assertEqual(100.,vm.run('TsunaT_DisplayCharge',(end+1,False)))
        body=text.split('private struct TsunaTKS',1)[1].split('endstruct',1)[0]
        self.assertNotIn('frame0_pas',body);self.assertNotIn('WUI_RegisterBuff',body)
        self.assertIn('WUI_HeroProgressCharge',body)

    def test_real_burner_charge_feeds_partial_overcharge_damage_and_firing_time(self):
        text=source('Heroes/Tsuna.j');body=text.split('private struct TsunaTKS',1)[1].split('endstruct',1)[0]
        helper=text.split('function TsunaT_DisplayCharge ',1)[1].split('endfunction',1)[0]
        begin=body.index('                        if r >= 0.3 and r <= TsunaT_OverchargeTime then')
        end=body.index('                        if r == 1.5 then',begin)
        block=body[begin:end]
        render=body.split('                if SpellBoolCaster(c) and r <= rmax then',1)[1].split('                    set r = r + 0.05',1)[0]
        damage=body.split('// Partial overcharge is continuous; ordinary charge keeps legacy rounding.',1)[1].split('                            call StartSpellUnit(c)',1)[0]
        code='function TsunaT_DisplayCharge '+helper+'endfunction\n'
        code+='function Charge takes nothing returns nothing\n'+block+'\n'+damage+'\nendfunction\n'
        code+='function Paint takes nothing returns nothing\n'+render+'\nendfunction\n'
        vm=JassState(code);calls=[];level=[35]
        for name in ['TsunaT_ChargeTimeFull','TsunaT_OverchargeTime','TsunaT_OverchargeDmgPct','TsunaT_Duration']:
            vm.g[name]=float(re.search(r'real '+name+r' = ([0-9.]+)',text)[1])
        vm.g.update(r=0.,rmax=2.15,check=0,check2=0,chargePct=0.,chargeVisual=0.,dmg=100.,c='hero',
            I2R=float,GetHeroLevel=lambda _:level[0],GetOwningPlayer=lambda _:0,SetPlayerAbilityAvailable=lambda *_:None,
            UnitAddAbility=lambda *_:None,TsunaT_ID='T',TsunaT2_ID='T2',
            WUI_HeroProgressCharge=lambda *a:calls.append(('charge',a)),
            WUI_HeroProgressText=lambda *a:calls.append(('time',a)),R2SW=lambda x,_,n:f'{x:.{n}f}')
        for elapsed,want in [(.95,54.),(1.5,100.),(2.,105.),(2.5,110.),(3.,115.),(3.5,120.),(3.95,124.5),(4.,125.)]:
            vm.g.update(r=elapsed,dmg=100.);vm.run('Charge');self.assertAlmostEqual(want,vm.g['dmg'])
        vm.g.update(r=2.5,dmg=100.);level[0]=34;vm.run('Charge');self.assertEqual(100.,vm.g['dmg'])
        for elapsed,label in [(0.,'0.0 / 2.0s'),(1.,'1.0 / 2.0s'),(2.,'2.0 / 2.0s')]:
            vm.g.update(check=1,r=elapsed);vm.run('Paint')
            self.assertEqual('time',calls[-1][0]);self.assertEqual(label,calls[-1][1][-1])
            self.assertNotIn('%',calls[-1][1][-1])
        vm.g.update(check=0,r=1.);vm.run('Paint');self.assertEqual('charge',calls[-1][0])

    def test_zero_resource_allocates_once_and_persists_until_explicit_close(self):
        vm, fx = self.vm, self.fx
        vm.run('WUI_HeroProgressCounter', (fx.hero, 10, 'Charge', 0., 6000.))
        panel = vm.g['WUI_ProgressPanel'][1]
        self.assertTrue(fx.visible[panel])
        self.assertIn('0 / 6000', fx.texts[vm.g['WUI_ProgressValue'][1]])
        for _ in range(40):
            vm.run('WUI_ExpireProgress')
        self.assertTrue(fx.visible[panel])
        vm.run('WUI_HeroProgressCounter', (fx.hero, 10, 'Charge', 6000., 6000.))
        self.assertEqual(6, len(fx.created))
        vm.run('WUI_HeroProgress', (fx.hero, 10, 'Charge', 0., 0., True))
        self.assertFalse(fx.visible[panel])

    def test_custom_percent_and_stack_caption_reuse_panel_and_reset_duration_clock(self):
        vm, fx = self.vm, self.fx
        vm.run('WUI_HeroDuration', (fx.hero, 10, 'Window', 5., 0, '', fx.hero))
        vm.run('WUI_HeroProgressText', (fx.hero, 10, 'Hyperintuition', 90., 100., False, '90% to dodge'))
        self.assertEqual(0., vm.g['WUI_ProgressTime'][1])
        self.assertIn('90% to dodge', fx.texts[vm.g['WUI_ProgressValue'][1]])
        vm.run('WUI_HeroProgressText', (fx.hero, 10, 'Eye of Death', 2., 7., True, '2.0s | 3 / 4'))
        self.assertEqual(6, len(fx.created))
        self.assertIn('Eye of Death', fx.texts[vm.g['WUI_ProgressCaption'][1]])
        self.assertIn('3 / 4', fx.texts[vm.g['WUI_ProgressValue'][1]])

    def test_public_meter_is_visible_on_other_client_and_expires_for_its_real_owner(self):
        vm, fx = self.vm, self.fx
        fx.local = 1
        public = []
        vm.g['WUI_RegisterPublicMeter'] = lambda *args: public.append(args)
        vm.run('WUI_HeroProgressPublic', (fx.hero, 10, 'Prison Realm', 3., 5.))
        panel = vm.g['WUI_ProgressPanel'][1]
        self.assertTrue(fx.visible[panel])
        self.assertEqual(1, len(public))
        vm.run('WUI_ExpireProgress')
        self.assertTrue(fx.visible[panel])
        fx.hero.life = 0
        vm.run('WUI_ExpireProgress')
        self.assertFalse(fx.visible[panel])

    def test_private_first_zero_counter_allocates_same_handles_on_nonowner(self):
        self.fx.local = 1
        self.vm.run('WUI_HeroProgressCounter', (self.fx.hero, 10, 'Charge', 0., 20.))
        self.assertEqual(6, len(self.fx.created))
        self.assertFalse(self.fx.visible[self.vm.g['WUI_ProgressPanel'][1]])

    def test_all_hero_meters_use_common_api_and_no_attached_shiki_inori_bar_remains(self):
        for path in (ROOT / 'triggers/Heroes').rglob('*.j'):
            text = path.read_text(encoding='utf-8-sig')
            self.assertNotIn('WUI_HeroMeter(', text, path)
            self.assertNotIn('WUI_TrackedMeter', text, path)
        tsuna = source('Heroes/Tsuna.j')
        self.assertNotIn('Morph Time Left', tsuna)
        self.assertNotIn('wos_ShikiCounter', source('Heroes/DarkShiki.j'))
        self.assertNotIn('wos_Inori_Bar', source('Heroes/Inori.j'))
        self.assertNotIn('wos_Inori_Bar', source('Systems/Systems1.j'))
        self.assertNotIn('WUI_HeroMeter(', source('Systems/DecorDestroy_and_Erza_Debuff.j'))
        self.assertNotIn('Counterattack begin!', source('Heroes/Rimuru.j'))


class HeroClocks(unittest.TestCase):
    def test_toji_tether_clock_freezes_in_both_states_and_disappears_on_dispel(self):
        for state in [1, 3]:
            vm = JassState(source('Heroes/Toji.j'))
            hero, target = vm.unit(owner=0), vm.unit(owner=1, x=100)
            data = vm.structs['TojiSpells_W'].create()
            data.c, data.td, data.state, data.r = hero, target, state, 1.
            data.chainDuration = 5.
            data.pullRemaining, data.pullMove, data.pullElapsed = 100., 0., 0.
            vm.fields['chain'] = 'lightning'
            data.chain = None
            data.deallocate = lambda *_: None
            data.TojiTimer03Release = lambda: None
            vm.add_ability(target, vm.g['TojiW_Debuff_ID'])
            clocks, paused = [], [True]
            vm.structs['TojiSpells_W'].statics.update(MUI_TojiW=0, m_TojiW={0: data})
            vm.g.update(IsUnitPaused=lambda u: paused[0], MoveLightningEx=lambda *_: None,
                        WUI_HeroProgress=lambda *a: clocks.append(a),
                        SetPlayerAbilityAvailable=lambda *_: None, TojiTimer03Release=lambda: None)
            for _ in range(20):
                vm.run('Loop_TojiW')
            self.assertEqual(1., data.r, state)
            self.assertEqual(4., clocks[-1][3])
            paused[0] = False
            vm.run('Loop_TojiW')
            self.assertAlmostEqual(1.03, data.r)
            self.assertAlmostEqual(3.97, clocks[-1][3])
            vm.remove_ability(target, vm.g['TojiW_Debuff_ID'])
            vm.run('Loop_TojiW')
            self.assertEqual((0., 0., True), clocks[-1][3:])

    def test_frieren_clone_cleanup_cannot_close_real_players_transformed_slots(self):
        for real in [False, True]:
            vm = JassState(source('Heroes/Frieren.j'))
            hero = vm.unit(owner=0)
            data = vm.structs['FrierenSpells_T'].create()
            data.c, data.b, data.check, data.r, data.rmax = hero, real, 1, 31., 30.
            data.deallocate = lambda *_: None
            data.FrierenTimer03Release = lambda: None
            vm.structs['FrierenSpells_T'].statics.update(MUI_FrierenT=0, m_FrierenT={0: data})
            slots = []
            vm.g.update(SpellBoolCaster=lambda _: True, CheckCoordsInRect=lambda *_: False,
                        gg_rct_Base='base', SetPlayerAbilityAvailable=lambda *a: slots.append(a),
                        AddUnitAnimationProperties=lambda *_: None, WUI_HeroProgress=lambda *_: None,
                        FrierenTimer03Release=lambda: None, hs={}, StringHash=lambda s:s)
            vm.run('Loop_FrierenT')
            self.assertEqual(6 if real else 0, len(slots))

    def test_takeshi_first_damage_and_threshold_do_not_depend_on_frame_creation(self):
        vm = JassState(source('Heroes/Takeshi.j'))
        hero = vm.unit(owner=0)
        hero.hero_level = 35
        values = []
        vm.g.update(hs={}, TakeshiDummy=None, TakeshiDummy_ID='dummy', gg_rct_Caster='caster',
                    StringHash=lambda s:s, GetRectCenterX=lambda _:0., GetRectCenterY=lambda _:0.,
                    CreateUnit=lambda owner,code,x,y,facing: vm.unit(owner=owner,x=x,y=y),
                    RemoveUnit=lambda unit:setattr(unit,'life',0),
                    WUI_HeroProgressCounter=lambda *a: values.append(a),WUI_HeroProgressSingle=lambda *_:None,
                    WUI_HeroProgressDualCounter=lambda *a:values.append(a))
        vm.run('TakeshiGAdd_Start', (hero, 150.))
        self.assertEqual(150., vm.g['hs'][id(hero), 'takeshi dmg'])
        self.assertEqual(150., values[-1][3])
        vm.run('TakeshiGAdd_Start', (hero, 7000.))
        self.assertEqual(5000., vm.g['hs'][id(hero), 'takeshi dmg'])
        self.assertIsNotNone(vm.g['TakeshiDummy'])
        vm.run('TakeshiGAdd_Start', (hero, -50.))
        self.assertEqual(4950., vm.g['hs'][id(hero), 'takeshi dmg'])
        self.assertIsNone(vm.g['TakeshiDummy'])

    def test_shiki_button_and_progress_read_current_target_stacks(self):
        fx = counter_fixture.PassiveCounters()
        fx.setUp()
        target = fx.vm.unit(owner=1)
        fx.state('passive target', target)
        for stacks in [1, 2, 3, 0]:
            fx.vm.g['hs'][id(target), 'DarkShiki pas'] = stacks
            self.assertEqual(str(stacks) if stacks > 0 else '', fx.value('DarkShikiF_ID'))
        self.assertIn('I2R(LoadInteger(hs, GetHandleId(td), SH_DARKSHIKI_PAS))', source('Heroes/DarkShiki.j'))

    def test_rimuru_both_activations_track_buff_windows_and_clear_previous_dodges(self):
        text = source('Heroes/Rimuru.j')
        functions = []
        for name in ['Rimuru2Q_Start', 'Rimuru3F_Start']:
            a=text.index('function '+name+' takes')
            functions.append(text[a:text.index('endfunction',a)+len('endfunction')])
        vm = JassState('\n'.join(functions))
        vm.g.update(RimuruQ2_ID='Q2', RimuruF3_ID='F3', RimuruQ2_Buff_ID='bQ', RimuruF3_Buff_ID='bF')
        hero = vm.unit(owner=0)
        registered = []
        vm.g.update(hs={}, RimuruTrackDodges=lambda *a: registered.append(a),
                    BuffUnit1=lambda *_: None, MakeSound=lambda *_: None, NextSound=lambda *_: None,
                    MyFlushBuff=lambda *_: None, StringHash=lambda s:s)
        for fn, aid in [('Rimuru2Q_Start', 'RimuruQ2_ID'), ('Rimuru3F_Start', 'RimuruF3_ID')]:
            vm.g['hs'][id(hero), 'dodge q'] = 3
            vm.run(fn, (hero,))
            self.assertEqual(0, vm.g['hs'][id(hero), 'dodge q'])
            self.assertEqual(vm.g[aid], registered[-1][1])


class RoundWarnings(unittest.TestCase):
    def test_sukuna_warning_caches_exact_spawn_without_a_second_random_draw(self):
        vm = JassState(source('Round_End/RoundEnd.j'))
        pings, draws = [], []
        vm.g.update(GetRandomInt=lambda a,b: draws.append((a,b)) or 4,
                    SukunaSpawnPrepared=False, SukunaSpawnX=0., SukunaSpawnY=0.,
                    GetRectCenterX=lambda _:100., GetRectCenterY=lambda _:200.,
                    gg_rct_Arena='arena', PingMinimapEx=lambda *a:pings.append(a))
        vm.run('SukunaResetSpawn')
        vm.run('SukunaWarnSpawn')
        point = (vm.g['SukunaSpawnX'], vm.g['SukunaSpawnY'])
        vm.run('SukunaPrepareSpawn')
        self.assertEqual([(0,4)],draws)
        self.assertEqual(point, pings[0][:2])
        self.assertEqual(15., pings[0][2])
        spawn=source('Round_End/RoundEnd.j').split('public static method SukunaEnd_Start takes')[1].split('endmethod')[0]
        self.assertIn('set x = SukunaSpawnX',spawn)
        self.assertIn('set y = SukunaSpawnY',spawn)
        pick=source('WOS_Start/WoS_Pick_Init.j')
        self.assertRegex(pick,r'if not TestMode and TimeMove == Time_Sukuna - 15 then\s+call SukunaWarnSpawn\(\)')
        vm.run('SukunaResetSpawn');vm.run('SukunaPrepareSpawn')
        self.assertEqual(2,len(draws))

    def test_first_post_pick_window_adds_thirty_once_without_changing_next_rounds(self):
        text=source('WOS_Start/WoS_Pick_Init.j')
        start=text.index('            if TimeMove == FRAME_RoundCountSecBasePrepare + PrePickTime and RandomAllPlayers == 0 then')
        end=text.index('                set i = 0',start)
        block=text[start:end]+'\n            endif'
        vm=JassState('function FinishPick takes nothing returns nothing\n'+block+'\nendfunction')
        vm.g.update(PickChat_Sync=lambda *a:None, TimeMove=70, FRAME_RoundCountSecBasePrepare=60, PrePickTime=10, RandomAllPlayers=0, TimeRound=120)
        vm.run('FinishPick');vm.run('FinishPick')
        self.assertEqual(150,vm.g['TimeRound'])
        self.assertIn('set TimeRound = FRAME_RoundCountSecBasePrepare',text)


if __name__ == '__main__':
    unittest.main()
