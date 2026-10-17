"""Checkpoint 22: pick bans/logos/frames, player-pick windows, shop prices,
HUD hit targets, slot hotkeys, F2 statistics, wheels and menu skins."""
from pathlib import Path
import re
import unittest

import png_tga
from install_wos_ui_assets import ASSET_NAMES, CP22_NAMES
from build_wos_ui_textures_cp22 import NAMES as BUILDER_NAMES

ROOT = Path(__file__).resolve().parents[1]
WOS = ROOT / 'triggers/WOS_Start'


def read(name):
    return (WOS / name).read_text(encoding='utf-8-sig')


def body(source, name):
    start = source.index('function ' + name + ' ')
    return source[start:source.index('endfunction', start)]


class Assets(unittest.TestCase):
    def test_every_cp22_texture_is_built_registered_and_rgba(self):
        self.assertEqual(set(BUILDER_NAMES), set(CP22_NAMES))
        self.assertTrue(set(CP22_NAMES) <= ASSET_NAMES)
        for name in CP22_NAMES:
            w, h, rows = png_tga.read_tga(ROOT / f'assets/UI/WOS/{name}.tga')
            self.assertGreater(w * h, 0, name)
            self.assertEqual(len(rows), h)

    def test_logos_are_4_to_1_and_transparent_around_the_art(self):
        for name in [n for n in CP22_NAMES if n.startswith('pick-logo-')]:
            w, h, rows = png_tga.read_tga(ROOT / f'assets/UI/WOS/{name}.tga')
            self.assertEqual((512, 128), (w, h))
            self.assertEqual(0, rows[0][3], name)

    def test_disabled_fill_is_opaque_so_stock_art_cannot_bleed(self):
        w, h, rows = png_tga.read_tga(ROOT / 'assets/UI/WOS/fill-disabled.tga')
        self.assertEqual({255}, {a for row in rows for a in row[3::4]})


class PickScreen(unittest.TestCase):
    def setUp(self):
        self.pick = read('WoS_Pick_Init.j')

    def test_logos_icon_frames_and_timer_plate(self):
        layout = body(self.pick, 'WOS_LayoutHeroPick')
        for logo in ('gacha', 'bleach', 'fairytail', 'onepiece', 'jujutsu', 'other'):
            self.assertIn('pick-logo-' + logo + '.tga', layout)
        self.assertIn('set part = WUI_IconFrame(FRAME_ICON[i], WUI_ICON_FRAME)', layout)
        self.assertIn('set part = WUI_IconFrame(FRAME_PlayerPick[i], WUI_ICON_FRAME)', layout)
        self.assertIn('call BlzFrameSetParent(FRAME_TimerToStart, WOS_PickTimerPlate)', layout)

    def test_teams_hug_edges_and_bans_fit_between(self):
        layout = body(self.pick, 'WOS_LayoutHeroPick')
        # Checkpoint 23: tighter rows; more than six bans use two rows.
        self.assertIn('set x = 0.124 + I2R(i) * 0.040', layout)
        self.assertIn('set x = 0.556 + I2R(i - 5) * 0.040', layout)
        left_edge, right_edge = 0.124 + 4 * 0.040 + 0.015, 0.556 - 0.015
        for count in (1, 4, 6, 8, 10):
            per_row = (count + 1) // 2 if count > 6 else count
            size = 0.020 if count > 6 else 0.026
            step = 0.034 if per_row < 2 else min(0.034, 0.140 / (per_row - 1))
            plate = (per_row - 1) * step + size + 0.016
            self.assertLess(left_edge + 0.010, 0.420 - plate / 2)
            self.assertGreater(right_edge - 0.010, 0.420 + plate / 2)
            self.assertGreaterEqual(step, size)
        self.assertIn('call WOS_PickBanLayout(MaxHeroBans, true)', layout)

    def test_every_locked_ban_reaches_a_slot_with_its_proposer(self):
        # Captain bans, roulette and the instant "ban them all" path.
        self.assertEqual(3, self.pick.count('call WOS_PickBanSet(BannedHeroCount - 1, heroId, pid)'))
        self.assertIn('call WOS_PickBanClear()\n    call LockCaptainBanProposals()', self.pick)

    def test_voice_lines_are_shared_with_the_hud_portrait(self):
        self.assertIn('function WOS_HeroVoicePath takes integer heroId, integer i returns string', self.pick)
        self.assertIn('call WOS_PlayNextHeroVoice(p, PlayerFrameCurrent_ID[pid])', self.pick)
        voice = body(self.pick, 'WOS_HeroVoicePath')
        self.assertNotIn('PlayerFrameCurrent_ID', voice)
        self.assertNotIn('clicked', voice)
        # Cooldown = sound length - 0.5 s.
        self.assertIn('GetSoundFileDuration', body(self.pick, 'WOS_PlayNextHeroVoice'))

    def test_captain_draft_uses_shared_slots_without_names(self):
        draft = read('Captain_Draft.j')
        self.assertIn('call WOS_PickBanSet(i, heroId, -1)', draft)
        self.assertIn('call WOS_PickBanLayout(CaptainDraftBanTotal, false)', draft)
        self.assertNotIn('call BlzFrameSetVisible(CaptainDraftPanel, true)', draft)
        self.assertIn('set CaptainDraftBanHighlight[i] = WOS_PickBanFx[i]', draft)


class PlayerPickWindows(unittest.TestCase):
    def test_names_are_anchored_once(self):
        source = read('Player_Pick_Mode.j')
        for name in ('DetermineCaptain', 'DetermineCaptain2'):
            self.assertNotIn('BlzFrameSetPoint(Frame_Cap1_1', body(source, name))
        layout = body(source, 'WOS_LayoutCaptainVote')
        self.assertIn('glyph-crown', source)
        self.assertIn('WOS_CaptainVoteBadge(Frame_Cap1_7[i], Frame_Cap1_3[i])', layout)
        # Free players compacted into aligned rows of four.
        self.assertIn('set x = 0.325 + I2R(ModuloInteger(k, 4)) * 0.050', layout)


class Shop(unittest.TestCase):
    def test_prices_sit_inside_icons_on_plates(self):
        shop = read('WoS_Shop_Init.j')
        self.assertIn('call ShopPlacePrice(FRAME_ShopItemCost[i], FRAME_ShopItemPricePlate[i], x, y, 0.038)', shop)
        self.assertIn('price-plate.tga', shop)
        self.assertIn('call BlzFrameSetSize(FRAME_ShopItemPricePlate[slot], plateWidth, 0.0105)', shop)

    def test_close_button_reuses_the_shop_state(self):
        shop = read('WoS_Shop_Init.j')
        self.assertIn('call SaveInteger(ShopFrameTable, GetHandleId(FRAME_ShopClose), 0, 408)', shop)
        close = shop[shop.index('if frameCode == 408 then'):]
        close = close[:close.index('if frameCode == 405 then')]
        self.assertIn('set Shop_Active[pid] = false', close)


class HUD(unittest.TestCase):
    def test_portrait_hit_target_and_voice_toggle(self):
        hud = read('DefaultArmorChangeStable_Copy.j')
        self.assertIn('call WUI_PlaceShiftLeft(UNITSTAT_PortraitHit, 0.1945, 0.0430, 0.056, 0.070)', hud)
        self.assertIn('WOS_PlayNextHeroVoice(p, GetUnitTypeId(Hero[pid]))', hud)
        # portrait .0345-.0845 and level plate .011-.030 are inside the target
        self.assertLessEqual(0.0480 - 0.038, 0.011)
        self.assertGreaterEqual(0.0480 + 0.038, 0.0845)

    def test_learn_strip_spans_pips_to_icon(self):
        cd = read('ShowCD.j')
        self.assertIn('WUI_HUD_Y - WUI_ICON_SIZE * 0.5 - 0.0008 - (WUI_PIP_Y - 0.0050)', cd)
        self.assertIn('not WUI_NativeCommandsHidden() and not WUI_IsHotkeyEditing()', cd)

    def test_slot_hotkeys_click_the_native_button_locally(self):
        wui = read('WOSUI.j')
        self.assertNotIn('hook BlzHideOriginFrames', wui)
        self.assertIn('function WUI_SetOriginHidden takes player p, boolean hide returns nothing', wui)
        key = body(wui, 'WUI_OnSlotKey')
        self.assertIn('if found >= 0 and GetLocalPlayer() == p then\n        call WUI_UseSlot(found)', key)
        use = body(wui, 'WUI_UseSlot')
        self.assertIn('call ForceUIKey(WUI_SlotDefaultKey(slot))', use)
        self.assertIn('call BlzFrameClick(WUI_Item[slot - 7])', use)
        conflict = body(wui, 'WUI_SlotKeyConflict')
        for reserved in 'ASHMPBIQWERTFG':
            self.assertIn('name == "%s"' % reserved, conflict)
        self.assertIn('is already used by', conflict)
        capture = body(wui, 'WUI_OnSlotCapture')
        self.assertIn('DisplayTimedTextToPlayer(p, 0, 0, 1.00, WUI_GOLD + "Hotkey changed: "', capture)
        self.assertIn('call WUI_OnReady(function WUI_CreateHotkeyEditor)', wui)

    def test_items_scale_by_the_stock_icon(self):
        wui = read('WOSUI.j')
        self.assertIn('constant real WUI_ITEM_SIZE = 0.033', wui)
        self.assertIn('call WUI_PlaceNativeItem(WUI_Item[i], WUI_ItemX(i), WUI_ItemY(i), WUI_ITEM_SIZE)', wui)
        self.assertIn('|cffe9cf8fINVENTORY|r', wui)
        # three .033 cells fit between the .591 and .697 dividers
        for i in (-1, 1):
            edge = 0.644 + i * 0.0345 + i * 0.033 / 2
            self.assertTrue(0.5925 < edge < 0.6955)


class Statistics(unittest.TestCase):
    def test_f2_is_opaque_and_dealt_taken_are_single_columns(self):
        sb = read('Scoreboard.j')
        self.assertNotIn('Transparent / opaque background', sb)
        self.assertIn('call BlzFrameSetVisible(WOS_STATS_OpacityButton, false)', body(sb, 'WOS_STATS_Layout'))
        self.assertIn('set WOS_STATS_IsOpaque[pid] = true', sb)
        self.assertIn('WOS_STATS_ScaleSize(width), WOS_STATS_ScaleSize(height))', body(sb, 'WOS_STATS_Layout'))
        self.assertIn('WUI_OrnateBorder("WOSScoreboardMetal", WOS_STATS_OpaqueBack', sb)
        self.assertIn('WOS_STATS_Breakdown(damagePhysical, damageMagical)', sb)
        self.assertIn('call WOS_STATS_ParkSwap(viewerPid, false)', sb)


class Misc(unittest.TestCase):
    def test_top_icons_and_discord(self):
        self.assertIn('glyph-music.tga', read('MusicPlayer.j'))
        self.assertIn('glyph-history.tga', read('UI_CAREER.j'))
        self.assertIn('glyph-stats.tga', read('WOSUI.j'))
        self.assertIn('glyph-menu.tga', read('WOSUI.j'))
        self.assertIn('WOS_COMMUNITY_ICON = "UI\\\\WOS\\\\discord.tga"', read('WoS_Hero_Icons_Init.j'))

    def test_restart_button_is_solo_player_one_only_and_switchable(self):
        wui = read('WOSUI.j')
        self.assertIn('boolean WUI_SHOW_RESTART = true', wui)
        allowed = body(wui, 'WUI_RestartAllowed')
        self.assertIn('not WUI_SHOW_RESTART', allowed)
        self.assertIn('GetPlayerController(Player(i)) == MAP_CONTROL_USER then\n            return false', allowed)
        self.assertIn('if not WUI_RestartAllowed() then', body(wui, 'WUI_CreateRestart'))
        click = body(wui, 'WUI_RestartClick')
        self.assertIn('GetTriggerPlayer() != Player(0) or not WUI_RestartAllowed()', click)
        self.assertIn('call RestartGame(false)', click)

    def test_round2_fixes(self):
        pick = read('WoS_Pick_Init.j')
        voice = body(pick, 'WOS_HeroVoicePath')
        self.assertIn('heroId == BazzB_ID', voice)
        self.assertNotIn('Hero_ID', voice.split('\n', 3)[3])
        starts = read('Starts.j')
        self.assertIn('call TimerStart(WOS_ModeCountdown, 1.00, true, function WOS_ModeCountdownTick)', starts)
        wui = read('WOSUI.j')
        self.assertIn('call WUI_SetMenuDrop(not WUI_MenuOpen)', wui)
        self.assertIn('call WUI_MinimalEdge(WUI_MenuDropMetal)', wui)
        self.assertIn('constant integer WUI_ALLY_COLOR_BUTTON = 2', wui)
        # Checkpoint 25c: no FPS docking (the resource bar stays hidden).
        self.assertNotIn('function WUI_DockFpsTick)', wui)
        emotes = read('EMOTES.j')
        self.assertIn('constant integer EMOJI_PAGE_SIZE = 15', emotes)
        self.assertNotIn('call BlzFrameSetSize(EmojiButton[i], EMOJI_ICON_HOVER', emotes)
        self.assertIn('CustomChat_GetPlayerAccessLevel(p) >= 3', emotes)
        chat = read('ChatCommand.j')
        self.assertIn('constant integer EMOJI_PAGE_SIZE = 15', chat)
        shop = read('WoS_Shop_Init.j')
        self.assertIn('call BlzFrameSetVisible(FRAME_ShopItemPricePlate[frameIndex], true)', shop)
        cd = read('ShowCD.j')
        self.assertIn('WUI_SlotKeyLabel(pid, slot) == ""', cd)

    def test_escape_menu_skin_never_adds_a_covering_fill(self):
        wui = read('WOSUI.j')
        self.assertNotIn('WUI_SkinEscBackdrop', wui)
        self.assertNotIn('WUI_StyleEscMenu', wui)
        from install_wos_ui_assets import SKIN_VALUES
        self.assertEqual(r'UI\WOS\panel.tga', SKIN_VALUES['EscMenuBackground'])
        self.assertEqual(r'UI\WOS\fill-pressed.tga', SKIN_VALUES['EscMenuButtonPushedBackground'])


if __name__ == '__main__':
    unittest.main()
