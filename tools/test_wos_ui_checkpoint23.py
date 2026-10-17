"""Checkpoint 23: pick/ban feed, instant bans, captain windows, draft vote
window, menu access during the pick, shop/HUD rework and new textures."""
from pathlib import Path
import unittest

import png_tga
from install_wos_ui_assets import ASSET_NAMES
from build_wos_ui_textures_cp23 import NAMES as CP23_NAMES

ROOT = Path(__file__).resolve().parents[1]
WOS = ROOT / 'triggers/WOS_Start'


def read(name):
    return (WOS / name).read_text(encoding='utf-8-sig')


def body(source, name):
    start = source.index('function ' + name + ' ')
    return source[start:source.index('endfunction', start)]


class Assets(unittest.TestCase):
    def test_cp23_textures_are_built_and_registered(self):
        self.assertTrue(set(CP23_NAMES) <= ASSET_NAMES)
        for name in list(CP23_NAMES) + ['glyph-allycolor', 'slider-track-h']:
            w, h, _ = png_tga.read_tga(ROOT / f'assets/UI/WOS/{name}.tga')
            self.assertGreater(w * h, 0, name)


class Feed(unittest.TestCase):
    def test_pick_and_ban_lines_go_to_the_feed_not_chat(self):
        pick, draft = read('WoS_Pick_Init.j'), read('Captain_Draft.j')
        for text in ('randomed', 'repicked', '|r picked', 'Banned hero:', 'Captain guaranteed ban:'):
            line = next(l for l in pick.splitlines() if text in l and 'Msg(' in l or text in l and 'WUI_Feed(' in l)
            self.assertIn('WUI_Feed(', line, text)
        self.assertNotIn('PlayersMsg(', draft)
        self.assertIn('call WUI_Feed("|c00FFFF00Hero ban phase starting!|r", 2)', pick)
        wui = read('WOSUI.j')
        self.assertIn('call WUI_CreateFeed()', body(wui, 'WUI_Bootstrap'))


class Bans(unittest.TestCase):
    def test_all_proposals_are_banned_at_once_when_they_fit(self):
        pick = read('WoS_Pick_Init.j')
        instant = body(pick, 'BanAllCandidatesNow')
        self.assertIn('BannedHeroCount + BanUniqueCandidateCount() > MaxHeroBans', instant)
        self.assertIn('call LockBannedHero(heroId)', instant)
        self.assertIn('if BanAllCandidatesNow() then', body(pick, 'StartBanPhase'))
        self.assertIn('elseif BanAllCandidatesNow() then', body(pick, 'BanPhaseTick'))
        self.assertIn('ban-cover.tga', pick)


class CaptainWindows(unittest.TestCase):
    def test_player_pick_vote_digits_inside_and_rows_divided(self):
        ppm = read('Player_Pick_Mode.j')
        badge = body(ppm, 'WOS_CaptainVoteBadge')
        self.assertIn('FRAMEPOINT_BOTTOMRIGHT, control, FRAMEPOINT_BOTTOMRIGHT, -0.0025, 0.0025', badge)   # cp26: digit over the whole icon
        self.assertIn('WOSTeamDraftRowDivider', body(ppm, 'WOS_LayoutCaptainVote'))
        self.assertEqual(4, ppm.count('], 0.72)\n    call BlzFrameSetModel('))

    def test_draft_vote_is_a_frame_window_and_claim_has_no_model(self):
        draft = read('Captain_Draft.j')
        self.assertNotIn('DialogCreate', draft)
        self.assertNotIn('DialogDisplay', draft)
        self.assertIn('BlzTriggerRegisterFrameEvent(CaptainDraftVoteTrigger, CaptainDraftVoteButton1', draft)
        self.assertNotIn('wos_IconShine1', draft)
        self.assertNotIn('FRAMEEVENT_MOUSE_ENTER', draft)
        self.assertIn('call BlzFrameSetTooltip(FRAME_PlayerPick[i], CaptainDraftClaimHover[i])', draft)
        self.assertIn('0.375, 0.5245, 0.214)', draft)


class Menu(unittest.TestCase):
    def test_dropdown_reshows_stock_buttons_hidden_by_the_pick(self):
        wui = read('WOSUI.j')
        drop = body(wui, 'WUI_SetMenuDrop')
        self.assertIn('call BlzFrameSetVisible(WUI_System[i], true)', drop)
        self.assertIn('call BlzFrameSetVisible(WUI_SystemBar, true)', drop)
        self.assertIn('if not BlzFrameIsVisible(WUI_System[i]) then', body(wui, 'WUI_RefreshMenuSkins'))


class Checkpoint24(unittest.TestCase):
    def test_tree_two_rows_of_six_and_pages_of_twelve(self):
        shop = read('WoS_Shop_Init.j')
        self.assertIn('constant integer SHOP_TREE_ROW = 6', shop)
        self.assertIn('constant integer SHOP_TREE_PAGE = 6', shop)
        self.assertIn('constant integer SHOP_TREE_SLOTS = 24', shop)
        self.assertIn('exitwhen i > 60', shop)
        self.assertIn('glyph-prev.tga', shop)

    def test_game_info_is_clickable_and_history_sits_on_the_bar(self):
        icons = read('WoS_Hero_Icons_Init.j')
        self.assertIn('call WUI_PlaceRight(FRAME_StatusHeroMain3, WUI_TOP_ROW_X2, 0.5495, WUI_TOP_ROW_W, 0.015)', icons)
        career = read('UI_CAREER.j')
        self.assertIn('call WUI_PlaceRight(WCS_OpenButton, 0.090, 0.584, WCS_OPEN_SIZE, WCS_OPEN_SIZE)', career)

    def test_statistics_keys_are_rebindable(self):
        sb = read('Scoreboard.j')
        for channel in ('WUI_HOTKEY_STATS', 'WUI_HOTKEY_CLEAR', 'WUI_HOTKEY_LOAD'):
            self.assertIn('call WUI_RegisterHotkeyEx(' + channel, sb)
        self.assertNotIn('OSKEY_F2, 0, false)', sb)
        self.assertNotIn('OSKEY_F3, 0, false', read('WoS_Pick_Init.j'))

    def test_native_tooltip_is_pinned_and_damage_bonus_has_no_plus(self):
        wui = read('WOSUI.j')
        self.assertIn('call BlzFrameSetSize(WUI_NativeTooltip, 0.300, 0.050)', wui)
        hud = read('DefaultArmorChangeStable_Copy.j')
        self.assertNotIn('|cff7cd67c+" + R2SW', hud)
        self.assertIn('function UNITSTAT_Pct', hud)


class Checkpoint24b(unittest.TestCase):
    def test_meters_fill_through_hooks_and_dock_above_minimap(self):
        wui = read('WOSUI.j')
        self.assertNotIn('hook BlzFrameSetValue', wui)
        self.assertIn('function WUI_FrameSetValue takes', wui)
        self.assertNotIn('hook BlzFrameSetMinMaxValue', wui)
        self.assertIn('function WUI_FrameSetMinMaxValue takes', wui)
        self.assertIn('meter-fill.tga', wui)
        self.assertIn('call WUI_HeroProgressCounter(c, MilimG_ID', (WOS.parent / 'Heroes/Milim.j').read_text(encoding='utf-8-sig'))

    def test_right_column_panels_and_fps(self):
        wui = read('WOSUI.j')
        self.assertIn('function WUI_RegisterColumnPanel', wui)
        self.assertIn('function WUI_ParkResourceBar', wui)
        park = wui[wui.index('function WUI_ParkResourceBar'):]
        park = park[:park.index('endfunction')]
        self.assertNotIn('BlzFrameGetChild', park)
        # Bar visible for /fps; only cached mouse listeners are hidden.
        self.assertIn('BlzFrameSetVisible(WUI_Resource, true)', park)
        self.assertIn('FRAMEPOINT_TOPRIGHT, WUI_FPS_X + 0.44, WUI_FPS_Y + 0.03', park)
        kyoraku = (WOS.parent / 'Heroes/Kyoraku.j').read_text(encoding='utf-8-sig')
        self.assertIn('call WUI_RegisterColumnPanel(frame_KyorBankai12[k2], "BANKAI STAGES", 0.190)', kyoraku)
        self.assertNotIn('BlzFrameSetVisible(frame_KyorBankai12', kyoraku)

    def test_shop_fast_actions_and_two_level_tree(self):
        shop = read('WoS_Shop_Init.j')
        self.assertIn('function ShopTreeCollect', shop)
        self.assertIn('return 306', shop)
        self.assertIn('return 307', shop)
        self.assertIn('fastbuy-off.tga', shop)

    def test_pick_buttons_leavers_and_shared_control(self):
        pick = read('WoS_Pick_Init.j')
        self.assertRegex(pick, r'pick-confirm(?:-wide)?-off\.tga')
        self.assertNotIn('PickButton_Pick_', pick)
        self.assertIn('ALLIANCE_SHARED_ADVANCED_CONTROL, false)', pick)
        icons = read('WoS_Hero_Icons_Init.j')
        self.assertIn('WOSStatusLeaveCover', icons)
        self.assertNotIn('BTNleave1', icons)


if __name__ == '__main__':
    unittest.main()
