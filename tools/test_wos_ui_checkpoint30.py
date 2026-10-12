"""Execute delayed-handle, mouse-focus, shop and live passive counter paths."""
from collections import defaultdict
from pathlib import Path
from types import SimpleNamespace
import re
import unittest

import test_wos_ui as ui
import test_ally_hero_ability_ui as ally
from test_crocodile import JassState

ROOT = Path(__file__).resolve().parents[1]


class PassiveCounters(unittest.TestCase):
    def setUp(self):
        source = (ROOT / 'triggers/Systems/TasBox.j').read_text(encoding='utf-8-sig')
        # These libraries are all enabled in MAIN; execute those static branches.
        self.vm = JassState(source.replace('static if LIBRARY_', 'if LIBRARY_'))
        g = self.vm.g
        for name in ('Tomioka', 'Starrk', 'Inori', 'Raiden'):
            g['LIBRARY_' + name + 'Spells'] = True
            hero = (ROOT / f'triggers/Heroes/{name}.j').read_text(encoding='utf-8-sig')
            for key, code in re.findall(r'\binteger (\w+)\s*=\s*\'([^\']+)\'', hero):
                g[key] = code
            for key, value in re.findall(r'\breal (Tomioka_G_AddDamage\w+) = ([0-9.]+)', hero):
                g[key] = float(value)
        g.update(hs={}, Hash={}, StringHash=lambda key: key, I2S=str, R2I=int,
                 GetHeroAgi=lambda u, _: 100, Raiden_F_Dummy=None)
        self.u = self.vm.unit(owner=0)

    def value(self, ability):
        return self.vm.run('GetValue', (self.u, self.vm.g[ability]))

    def state(self, key, value):
        self.vm.g['hs'][id(self.u), key] = value

    def test_tomioka_bonus_tracks_stacks_and_hides_at_expiry(self):
        # Stack count in the corner box, the damage on the plate below.
        plate = lambda: self.vm.run('GetSubValue', (self.u, self.vm.g['TomiokaG_ID']))
        self.state('tomioka add dmg', 1)
        self.assertEqual('1', self.value('TomiokaG_ID'))
        self.assertIn('+40 dmg', plate())
        self.state('tomioka add dmg', 6)
        self.assertEqual('6', self.value('TomiokaG_ID'))
        self.assertIn('+190 dmg', plate())
        self.state('tomioka add dmg', 0)
        self.assertEqual('', self.value('TomiokaG_ID'))
        self.assertEqual('', plate())

    def test_starrk_counts_actual_independent_abilities(self):
        for index in range(1, 7):
            self.vm.add_ability(self.u, self.vm.g[f'Starrk_Pas{index}ID'])
            self.assertEqual(str(index), self.value('StarrkG_ID'))
        for index in range(1, 7):
            self.vm.remove_ability(self.u, self.vm.g[f'Starrk_Pas{index}ID'])
            self.assertEqual(str(6 - index) if index < 6 else '', self.value('StarrkG_ID'))

    def test_inori_all_e_variants_clear_when_stacks_are_consumed(self):
        for stacks in (1, 2, 3, 4):
            self.state('Inori E', stacks)
            for ability in ('InoriE_ID', 'InoriEAlt_ID', 'InoriEAlt2_ID', 'InoriEE_ID', 'InoriE2_ID'):
                self.assertEqual(str(stacks), self.value(ability))
        self.state('Inori E Active', 1)
        self.assertEqual('', self.value('InoriE_ID'))
        self.state('Inori E', 0)
        self.state('Inori E Active', 0)
        self.assertEqual('', self.value('InoriE_ID'))

    def test_raiden_counts_until_own_blink_is_available(self):
        self.state('atk count', 2)
        self.assertEqual('2', self.value('RaidenG_ID'))
        self.vm.g['Raiden_F_Dummy'] = self.vm.unit(owner=1)
        self.assertEqual('2', self.value('RaidenG_ID'))
        self.vm.g['Raiden_F_Dummy'].owner = 0
        self.assertEqual('', self.value('RaidenG_ID'))
        self.vm.g['Raiden_F_Dummy'] = None
        self.state('atk count', 0)
        self.assertEqual('0', self.value('RaidenG_ID'))


class FastBuy(unittest.TestCase):
    def setUp(self):
        self.vm = ui.load_source('WoS_Shop_Init.j')
        self.now = 2.0
        self.vm.g.update(TimerGetElapsed=lambda _: self.now, ShopClock='clock')
        self.vm.g['ShopFastBuy'][0] = True

    def click(self, frame, item, pid=0):
        return self.vm.run('ShopFastAction', (pid, frame, item))

    def test_tree_double_click_survives_recenter_and_buys_original_item(self):
        self.assertEqual(236, self.click(236, 'item-a'))
        self.now += .2
        self.assertEqual(306, self.click(236, 'new-child'))
        self.assertEqual('item-a', self.vm.g['ItemsCurrentItem_ID'][0])

    def test_center_accepts_second_click_on_the_same_item(self):
        self.click(243, 'item-a')
        self.now += .2
        self.assertEqual(306, self.click(242, 'item-a'))

    def test_disabled_slow_or_other_player_click_does_not_buy(self):
        self.click(236, 'item-a')
        self.assertEqual(236, self.click(236, 'item-a', pid=1))
        self.now += .5
        self.assertEqual(242, self.click(242, 'item-a'))
        self.vm.g['ShopFastBuy'][0] = False
        self.now += .1
        self.assertEqual(242, self.click(242, 'item-a'))


class HoverAndHandles(unittest.TestCase):
    def test_unknown_ability_level_never_acquires_local_ability_handle(self):
        fixture = ally.AllyAbilityUI()
        fixture.setUp()
        fixture.vm.g['BlzGetUnitAbility'] = lambda *_: self.fail('local handle reservation')
        self.assertEqual(1, fixture.vm.run('AHUI_MaxLevel', (fixture.c, 'unknown')))

    def test_hover_clears_when_mouse_leaves_clicked_portrait(self):
        vm = ui.load_source('DefaultArmorChangeStable_Copy.j')
        visible = {}
        pos = [.19, .05]
        vm.g.update(UNITSTAT_Root='hud', UNITSTAT_PortraitTip='portrait-tip', UNITSTAT_Tooltip='stat-tip', UNITSTAT_Hover=-1,
                    BlzFrameIsVisible=lambda _: True,
                    BlzGetMouseScreenPosX=lambda: pos[0], BlzGetMouseScreenPosY=lambda: pos[1],
                    BlzFrameSetVisible=lambda f, shown: visible.update({f: shown}))
        for key, value in (('Left', .1665), ('Y', .043), ('Width', .056), ('Height', .070)):
            vm.g['UNITSTAT_Widget' + key][6] = value
        vm.run('UNITSTAT_PollHover')
        self.assertTrue(visible['portrait-tip'])
        pos[:] = [.4, .3]
        vm.run('UNITSTAT_PollHover')
        self.assertEqual(-1, vm.g['UNITSTAT_Hover'])
        self.assertFalse(visible['portrait-tip'])
        self.assertFalse(visible['stat-tip'])

    def test_live_stat_text_does_not_reanchor_same_tooltip(self):
        vm = ui.load_source('DefaultArmorChangeStable_Copy.j')
        moved = []
        vm.g.update(UNITSTAT_Tooltip='tip', UNITSTAT_TooltipText='text',
                    UNITSTAT_TipLayout=-1, UNITSTAT_TipLines=-1, UNITSTAT_TipText='', WUI_CHASSIS_TOP=.094,
                    WUI_SetText=lambda *_: None, I2R=float,
                    BlzFrameSetSize=lambda *_: None, BlzFrameSetPoint=lambda *_: None,
                    BlzFrameSetAbsPoint=lambda *args: moved.append(args),
                    BlzFrameSetTextAlignment=lambda *_: None, BlzFrameSetVisible=lambda *_: None,
                    FRAMEPOINT_CENTER='center', FRAMEPOINT_BOTTOMLEFT='bl', FRAMEPOINT_TOPLEFT='tl',
                    TEXT_JUSTIFY_MIDDLE='middle', TEXT_JUSTIFY_CENTER='center')
        vm.g['UNITSTAT_Help'][4] = 'Agility|n100'
        vm.g['UNITSTAT_WidgetLeft'][4] = .2325
        vm.run('UNITSTAT_ShowTooltip', (4,))
        vm.g['UNITSTAT_Help'][4] = 'Agility|n101'
        vm.run('UNITSTAT_ShowTooltip', (4,))
        self.assertEqual(1, len(moved))

    def test_f2_only_hides_obsolete_stats_window(self):
        vm = ui.load_source('Scoreboard.j')
        visible = {key: True for key in ('top', 'options', 'camera', 'taken', 'old-stats')}
        vm.g.update(FRAME_StatusHeroMain='top', FRAME_StatusHeroMain2='taken',
                    FRAME_StatusHeroMain3='options', FRAME_StatusHeroMain4='camera', FRAME_StatsMain='old-stats',
                    BlzFrameIsVisible=lambda f: visible[f],
                    BlzFrameSetVisible=lambda f, v: visible.update({f: v}),
                    WOS_STATS_Show=lambda f, v: visible.update({f: v}))
        vm.run('WOS_STATS_SaveAndHideLegacyUI', (0,))
        vm.run('WOS_STATS_HideLegacyUI')
        self.assertFalse(visible['old-stats'])
        for key in ('top', 'taken', 'options', 'camera'):
            self.assertTrue(visible[key])

    def test_ten_player_expanded_f2_fits_between_minimap_and_top_strip(self):
        vm = ui.load_source('Scoreboard.j')
        positions, sizes, rows, parked = {}, {}, {}, []
        for name in list(vm.g):
            if name.startswith('WOS_STATS_') and vm.g[name] is None:
                vm.g[name] = name
        vm.g.update(FRAMEPOINT_CENTER='center', WOS_STATS_TEX_COLLAPSE='collapse',
                    BlzFrameSetAbsPoint=lambda f, _, x, y: positions.update({f: (x, y)}),
                    BlzFrameSetSize=lambda f, w, h: sizes.update({f: (w, h)}),
                    BlzFrameSetScale=lambda *_: None, BlzFrameSetVisible=lambda *_: None,
                    WOS_STATS_ConfigureHeaders=lambda *_: None,
                    WOS_STATS_GetDisplayPidForRow=lambda row: row,
                    WOS_STATS_ShouldDisplayPid=lambda pid: pid < 10,
                    WOS_STATS_MoveRow=lambda row, y, _: rows.update({row: y}),
                    WOS_STATS_ParkSwap=lambda pid, hidden: parked.append(hidden), WOS_STATS_Tex=lambda *_: None)
        vm.g['WOS_STATS_IsExpanded'][0] = True
        vm.run('WOS_STATS_Layout', (0,))
        center = positions[vm.g['WOS_STATS_Main']][1]
        height = sizes[vm.g['WOS_STATS_Main']][1]
        self.assertAlmostEqual(.148, center - height / 2)
        self.assertLess(center + height / 2, .565)
        self.assertEqual(10, len(rows))
        self.assertEqual([False], parked)
        for y in rows.values():
            self.assertGreater(vm.run('WOS_STATS_ScaleY', (y,)), .148)


class SharedMeterClocks(unittest.TestCase):
    def test_watched_agility_uses_actual_remover_and_clears_on_early_removal(self):
        source = (ROOT / 'triggers/Systems/Systems2.j').read_text(encoding='utf-8-sig')
        begin = source.index('    private struct KS_RemoveAbility\n')
        end = source.index('    endstruct', begin) + len('    endstruct')
        api_begin = source.index('    function GearWatchAbilityTime ')
        api_end = source.index('    function MyRemoveAbility2 ', api_begin)
        snippet = source[begin:end] + '\n' + source[api_begin:api_end]
        # The old remover uses compact assignment spacing; normalize for the VM.
        snippet = re.sub(r'(?m)(^\s*set [^\r\n=]+?)\s*=\s*', r'\1 = ', snippet)
        vm = JassState(snippet)
        clock_users = []
        vm.g.update(hs={}, StringHash=lambda key: key, I2S=str, UNIT_TYPE_HERO='hero',
                    gg_rct_Base='base', CheckCoordsInRect=lambda *_: False,
                    GearTimer10Acquire=lambda: clock_users.append(1),
                    GearTimer10Release=lambda: clock_users.pop())
        remover = vm.structs['KS_RemoveAbility']
        remover.statics.update(MUI_14=-1, m_14=defaultdict(int))
        u = vm.unit()
        vm.add_ability(u, 'buff')
        vm.run('GearWatchAbilityTime', (u, 'buff'))
        vm.run('RemoveAbility_Start', (u, .3, 'buff', 1))
        self.assertAlmostEqual(.3, vm.run('GearAbilityTimeRemaining', (u, 'buff')))
        vm.run('Loop_RemoveAbility')
        self.assertAlmostEqual(.2, vm.run('GearAbilityTimeRemaining', (u, 'buff')))
        vm.remove_ability(u, 'buff')
        vm.run('Loop_RemoveAbility')
        self.assertEqual(0, vm.run('GearAbilityTimeRemaining', (u, 'buff')))
        self.assertNotIn((id(u), 'ability time buff'), vm.g['hs'])
        self.assertEqual([], clock_users)

    def test_kirito_meter_reads_existing_heal_clock_and_hides_after_death(self):
        source = (ROOT / 'triggers/Heroes/Kirito.j').read_text(encoding='utf-8-sig')
        begin = source.index('    private struct KiritoSpells_G\n')
        end = source.index('    endstruct', begin) + len('    endstruct')
        vm = JassState(source[begin:end])
        u, updates = vm.unit(owner=0), []
        kirito = vm.structs['KiritoSpells_G']
        data = kirito.create()
        data.c = u
        data.healMeter = SimpleNamespace(update=lambda *args: updates.append(args))
        kirito.statics.update(MUI_KiritoG=0, m_KiritoG={0: data}, uiTick=0.0, t_KiritoG='heal-clock')
        vm.g.update(GetPlayerId=lambda p: p, Hero={0: u}, UNIT_TYPE_DEAD='dead',
                    IsUnitType=lambda hero, _: hero.life <= 0,
                    TimerGetRemaining=lambda timer: .7 if timer == 'heal-clock' else -1)
        for _ in range(4):
            vm.run('Loop_KiritoGMeter')
        self.assertEqual([(.7, 'Next heal', True)], updates)
        u.life = 0
        for _ in range(4):
            vm.run('Loop_KiritoGMeter')
        self.assertEqual((.7, 'Next heal', False), updates[-1])


if __name__ == '__main__':
    unittest.main()
