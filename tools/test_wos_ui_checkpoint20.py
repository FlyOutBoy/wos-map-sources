"""Checkpoint 20: level pips, Dota-style learning, flush frames and new assets."""
from pathlib import Path
import re
import struct
import unittest
import test_wos_ui as ui
import test_ally_hero_ability_ui as ally
from install_wos_ui_assets import ASSET_NAMES, CP20_NAMES, FRAME_RESOURCES, validate_frame_resources

ROOT = Path(__file__).resolve().parents[1]


class Learning(unittest.TestCase):
    """Runs the production ShowCD learning code against the ally fixture."""
    frame = ally.AllyAbilityUI.frame
    cooldown = ally.AllyAbilityUI.cooldown
    value = ally.AllyAbilityUI.value
    refresh = ally.AllyAbilityUI.refresh

    def setUp(self):
        ally.AllyAbilityUI.setUp(self)
        g = self.vm.g
        self.learned = []
        self.vm.g['WUI_ResetClickedButtonFocus']=lambda:None
        g.update(SelectHeroSkill=lambda hero, ability: self.learned.append((hero, ability)),
                 BlzFrameSetEnable=lambda *_: None, GetTriggerPlayer=lambda: 0)
        # The selected Crocodile is the viewer's OWN main hero with points.
        self.c.owner = 0
        self.c.skill_points = 1
        self.c.hero_level = 13
        g['Hero'][0] = self.c

    def pips(self, slot, count=6):
        g = self.vm.g
        return [self.frames.get((g['AHUI_Pip'][slot * 6 + k], 'texture')) for k in range(count)]

    def click(self, slot):
        g = self.vm.g
        g['BlzGetTriggerFrame'] = lambda: g['AHUI_LearnButton'][slot]
        self.vm.run('AHUI_OnLearnClick')

    def test_learn_glow_restores_cached_backdrop_without_hitbox(self):
        vm=ui.load_source('ShowCD.j');created=[];enabled={};visible={};textures={}
        def frame(kind,name,*args):created.append((kind,name));return len(created)
        vm.g.update(AHUI_LearnTrigger=None,WUI_GetRoot=lambda:'root',CreateTrigger=lambda:'learn',BlzCreateFrameByType=frame,
            WUI_Place=lambda *_:None,WUI_PlaceShift=lambda *_:None,WUI_AbilityX=lambda n:n*.04,
            WUI_HudShift=0.,WUI_HUD_Y=.07,WUI_COMMAND_STEP=.04,WUI_ICON_SIZE=.035,WUI_PIP_Y=.025,
            BlzFrameSetEnable=lambda f,v:enabled.update({f:v}),BlzFrameSetVisible=lambda f,v:visible.update({f:v}),
            BlzFrameSetTexture=lambda f,t,*_:textures.update({f:t}),BlzTriggerRegisterFrameEvent=lambda *_:None,TriggerAddAction=lambda *_:None)
        for name in ['Level','AllPoints','Size','Scale','TextAlignment']:vm.g['BlzFrameSet'+name]=lambda *_:None
        for name in ['TEXT_JUSTIFY_MIDDLE','TEXT_JUSTIFY_CENTER','FRAMEEVENT_CONTROL_CLICK']:vm.g[name]=name
        vm.run('AHUI_CreateLearnFrames')
        for i in range(5):
            f=vm.g['AHUI_LearnGlow'][i]
            self.assertEqual(('BACKDROP','AHUILearnGlow'),created[f-1])
            self.assertEqual('UI\\WOS\\learn-glow.tga',textures[f])
            self.assertFalse(enabled[f]);self.assertFalse(visible[f])

    def test_learning_click_clears_pressed_state_after_learning(self):
        resets=[]
        self.vm.g['WUI_ResetClickedButtonFocus']=lambda:resets.append(len(self.learned))
        self.click(0)
        self.assertEqual([1],resets)

    def test_pip_count_matches_object_data_levels(self):
        self.refresh()
        # Q is level 3 of 5; hero level 13 unlocks Q4 (1 + 3 * 4).
        full, ready, empty = ('UI\\WOS\\pip-%s.tga' % n for n in ('full', 'ready', 'empty'))
        self.assertEqual([full] * 3 + [ready, empty, None], self.pips(0))
        # T has a single level: exactly one pip, never five.
        self.assertEqual([full, None], self.pips(4, 2))
        self.assertTrue(self.value('AHUI_LearnGlow', 0, 'visible'))
        self.assertFalse(self.value('AHUI_LearnGlow', 4, 'visible'))

    def test_locked_level_is_not_green_and_shows_unlock_level(self):
        self.c.hero_level = 12
        self.refresh()
        self.assertNotIn('UI\\WOS\\pip-ready.tga', self.pips(0))
        self.assertFalse(self.value('AHUI_LearnGlow', 0, 'visible'))
        self.assertTrue(self.value('AHUI_ReqText', 0, 'visible'))
        self.assertIn('Lv 13', self.value('AHUI_ReqText', 0, 'text'))
        self.click(0)
        self.assertEqual([], self.learned)

    def test_no_points_hides_glow_and_foreign_hero_hides_strip(self):
        self.c.skill_points = 0
        self.refresh()
        for slot in range(5):
            self.assertFalse(self.value('AHUI_LearnGlow', slot, 'visible'))
        self.c.skill_points = 1
        self.vm.g['Hero'][0] = None
        self.refresh()
        for slot in range(5):
            self.assertFalse(self.value('AHUI_LearnButton', slot, 'visible'))

    def test_clicking_pips_learns_base_skill(self):
        self.click(0)
        self.assertEqual([(self.c, self.vm.g['CrocodileQ_ID'])], self.learned)

    def test_replaced_t_does_not_learn_base_until_replacement_ends(self):
        g = self.vm.g
        self.c.abilities[g['CrocodileT_ID']]['level'] = 0
        self.c.abilities[g['CrocodileT2_ID']] = {'level': 1, 'remaining': 3}
        self.c.hero_level = 25
        self.click(4)
        self.assertEqual([], self.learned)
        self.vm.run('AHUI_OnSetPlayerAbilityAvailable',(0,g['CrocodileT2_ID'],False))
        self.vm.run('AHUI_OnSetPlayerAbilityAvailable',(0,g['CrocodileT_ID'],True))
        self.click(4)
        self.assertEqual([(self.c, g['CrocodileT_ID'])], self.learned)

    def test_max_level_is_not_learnable(self):
        g = self.vm.g
        self.c.abilities[g['CrocodileQ_ID']]['level'] = 5
        self.c.hero_level = 30
        self.click(0)
        self.assertEqual([], self.learned)

    def test_unlearned_own_skill_is_previewed_dimmed(self):
        g = self.vm.g
        self.c.abilities[g['CrocodileE_ID']]['level'] = 0
        self.refresh()
        self.assertTrue(self.value('AHUI_Icon', 2, 'visible'))
        self.assertEqual(0, self.value('AHUI_Icon', 2, 'alpha'))
        self.assertTrue(self.value('AHUI_CooldownFill', 2, 'visible'))
        self.assertFalse(self.frames.get((('native', 2), 'visible')))
        # Learned own skills stay native.
        self.assertTrue(self.frames.get((('native', 0), 'visible')))
        self.assertFalse(self.value('AHUI_Icon', 0, 'visible'))


class FlushFrames(unittest.TestCase):
    def setUp(self):
        self.fixture = ui.DeferredUIStartup()
        self.fixture.setUp()
        self.vm = self.fixture.vm
        self.vm.g.update(ModuloInteger=lambda a, b: a % b)

    def test_text_button_frame_is_its_hit_rectangle(self):
        self.vm.g.update(GetHandleId=lambda f: f, SaveFrameHandle=lambda h, p, c, v: h.update({(p, c): v}))
        self.vm.run('WUI_Bootstrap')
        self.fixture.calls.clear()
        button = self.vm.run('WUI_TextButton', ('b', 'parent', 'Caption', .264, .040))
        points = [a for n, a in self.fixture.calls if n == 'BlzFrameSetPoint']
        # Hairlines are anchored on the button's own corners (zero offsets).
        self.assertIn(('BACKDROP:bMetalT', 'FRAMEPOINT_LEFT', button, 'FRAMEPOINT_TOPLEFT', 0, 0), points)
        self.assertIn(('BACKDROP:bMetalR', 'FRAMEPOINT_BOTTOM', button, 'FRAMEPOINT_BOTTOMRIGHT', 0, 0), points)
        # Checkpoint 21: the FDF template draws hover itself; no frame events.
        self.assertIn(('create', ('FRAME', 'WOSTextButtonTemplate', 'parent')), self.fixture.calls)
        self.assertFalse([c for c in self.fixture.calls if 'FRAMEEVENT_MOUSE_ENTER' in str(c)])

    def test_text_button_fallback_keeps_event_hover_without_definitions(self):
        self.vm.g.update(GetHandleId=lambda f: f, SaveFrameHandle=lambda h, p, c, v: h.update({(p, c): v}))
        self.vm.run('WUI_Bootstrap')
        self.vm.g['WUI_FrameDefinitionsReady'] = False
        self.fixture.calls.clear()
        self.vm.run('WUI_TextButton', ('b', 'parent', 'Caption', .264, .040))
        self.assertIn(('BlzFrameSetTexture', ('BACKDROP:bBack', 'UI\\WOS\\fill-normal.tga', 0, True)), self.fixture.calls)

    def test_corner_mask_skips_requested_corners(self):
        self.vm.run('WUI_OrnateBorderEx', ('e', 'owner', .020, 11))
        created = {a[1] for n, a in self.fixture.calls if n == 'create'}
        self.assertTrue({'etl', 'etr', 'ebr'} <= created)
        self.assertNotIn('ebl', created)


class SourceContracts(unittest.TestCase):
    def test_damage_taken_line_is_not_drawn(self):
        source = (ROOT / 'triggers/WOS_Start/WoS_Hero_Icons_Init.j').read_text(encoding='utf-8-sig')
        self.assertIn('call BlzFrameSetVisible(FRAME_StatusHeroStringPlayerTakenDamageMag, false)', source)

    def test_train_kills_docks_directly_under_elapsed_time(self):
        source = (ROOT / 'triggers/WOS_Start/WoS_Hero_Icons_Init.j').read_text(encoding='utf-8-sig')
        time = re.search(r'WUI_Place\(StatusGameTimeBox, 0\.400, ([0-9.]+), [0-9.]+, ([0-9.]+)\)', source)
        train = re.search(r'WUI_Place\(StatusTrainBox, 0\.400, ([0-9.]+), [0-9.]+, ([0-9.]+)\)', source)
        time_bottom = float(time[1]) - float(time[2]) / 2
        train_top = float(train[1]) + float(train[2]) / 2
        self.assertAlmostEqual(time_bottom, train_top, places=3)
        self.assertLess(float(train[2]), float(time[2]))

    def test_hud_poll_does_not_acquire_lazy_cooldown_handles(self):
        source = (ROOT / 'triggers/WOS_Start/WOSUI.j').read_text(encoding='utf-8-sig')
        body = source.split('function WUI_RefreshDocks', 1)[1].split('endfunction', 1)[0]
        self.assertNotIn('BlzGetOriginFrame', body)
        self.assertNotIn('WUI_RefreshCooldownSizes', body)
        self.assertNotIn('private function WUI_ResizeCooldown', source)

    def test_stats_show_base_plus_bonus(self):
        source = (ROOT / 'triggers/WOS_Start/DefaultArmorChangeStable_Copy.j').read_text(encoding='utf-8-sig')
        self.assertIn('UNITSTAT_StatText(GetHeroStr(selected, true), GetHeroStr(selected, false)', source)
        # Checkpoint 21: drawn stat medallions replace the stock infocard icons.
        self.assertIn('UI\\\\WOS\\\\stat-agi.tga', source)


class Assets(unittest.TestCase):
    def test_new_textures_are_registered_rgba(self):
        self.assertTrue(set(CP20_NAMES) <= ASSET_NAMES)
        for name in CP20_NAMES:
            data = (ROOT / 'assets/UI/WOS' / (name + '.tga')).read_bytes()
            self.assertEqual(b'\x00\x02', data[1:3], name)
            self.assertEqual((32, 8), (data[16], data[17] & 15), name)

    def test_rails_have_no_stray_crop_pixels(self):
        # Rails are replicated profiles: every column of a horizontal rail is
        # identical in alpha, so no isolated red/yellow crop lines remain.
        for name in ('ornate-top', 'ornate-bottom'):
            data = (ROOT / 'assets/UI/WOS' / (name + '.tga')).read_bytes()
            width, height = struct.unpack_from('<HH', data, 12)
            pixels = data[18 + data[0]:]
            alphas = {tuple(pixels[(y * width + x) * 4 + 3] for y in range(height)) for x in range(width)}
            self.assertEqual(1, len(alphas), name)

    def test_controls_fdf_is_bundled_last_and_valid(self):
        self.assertIn('UI/WOS/WOSControls.fdf', FRAME_RESOURCES)
        validate_frame_resources(ROOT / 'assets')
        toc = (ROOT / 'assets/UI/WOS/Templates.toc').read_bytes().split(b'\r\n')
        self.assertEqual(b'UI\\WOS\\WOSControls.fdf', [line for line in toc if line][-1])
        fdf = (ROOT / 'assets/UI/WOS/WOSControls.fdf').read_text()
        self.assertIn('SliderLayoutVertical', fdf)
        self.assertIn('UI\\WOS\\slider-thumb.tga', fdf)


if __name__ == '__main__':
    unittest.main()
