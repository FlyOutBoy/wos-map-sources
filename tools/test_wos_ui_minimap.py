"""Run production minimap allocation, visibility/cleanup, and camera transitions."""
from collections import defaultdict
from pathlib import Path
import unittest
from test_crocodile import JassState
import test_wos_ui as ui

ROOT = Path(__file__).resolve().parents[1]

@unittest.skip("hero portrait minimap icons are disabled: stock hero markers are used")
class HeroMinimap(unittest.TestCase):
    def setUp(self):
        source = (ROOT / 'triggers/Systems/Systems1.j').read_text(encoding='utf-8-sig')
        begin = source.index('function WOS_RegisterHeroMinimap ')
        end = source.index('function LearnHeroSpells ', begin)
        self.vm = JassState(source[begin:end])
        self.created, self.destroyed, self.visible = [], [], {}
        self.seen, self.detected = True, True
        self.vm.g.update(WOS_MiniCount=0, WOS_MiniUnits={}, WOS_MiniUnit=defaultdict(lambda: None),
                         WOS_MiniSource=defaultdict(lambda: None), WOS_MiniIcon=defaultdict(lambda: None),
                         WOS_MiniTexture=defaultdict(lambda: None), FOG_OF_WAR_VISIBLE='visible-fog',
                         UNIT_BF_HERO_HIDE_HERO_MINIMAP_DISPLAY='hide-hero-dot', UNIT_BF_HIDE_MINIMAP_DISPLAY='hide-unit-dot',
                         GetLocalPlayer=lambda: 1, BlzGetAbilityIcon=lambda code: 'portrait-' + str(code),
                         CreateMinimapIconOnUnit=self.create,
                         DestroyMinimapIcon=lambda icon: self.destroyed.append(icon),
                         SetMinimapIconOrphanDestroy=lambda *_: None,
                         SetMinimapIconVisible=lambda icon, visible: self.visible.update({icon: visible}),
                         BlzSetUnitBooleanField=lambda *_: True, IsUnitHidden=lambda _: False,
                         IsUnitVisible=lambda *_: self.seen, IsUnitDetected=lambda *_: self.detected, IsUnitInvisible=lambda *_: not self.detected)
        self.hero = self.vm.unit(owner=0)
        self.clone = self.vm.unit(owner=0)
        self.clone.type = 'clone-dummy'

    def create(self, u, r, g, b, texture, fog):
        icon = len(self.created) + 1
        self.created.append((u, r, g, b, texture, fog))
        return icon

    def register(self, u):
        self.vm.run('WOS_RegisterHeroMinimap', (u, self.hero))

    def test_hero_and_clone_have_identical_portraits_and_no_duplicate_handles(self):
        self.register(self.hero)
        self.register(self.clone)
        self.register(self.clone)
        self.assertEqual(2, len(self.created))
        self.assertEqual(self.created[0][1:], self.created[1][1:])
        self.assertEqual(2, self.vm.g['WOS_MiniCount'])

    def test_local_visibility_does_not_allocate_icons_or_reveal_undetected_units(self):
        self.register(self.hero)
        self.register(self.clone)
        self.vm.run('WOS_UpdateHeroMinimap')
        self.assertTrue(all(self.visible.values()))
        self.seen = False
        self.vm.run('WOS_UpdateHeroMinimap')
        self.assertFalse(any(self.visible.values()))
        self.seen, self.detected = True, False
        self.vm.run('WOS_UpdateHeroMinimap')
        self.assertFalse(any(self.visible.values()))
        self.assertEqual(2, len(self.created))

    def test_removed_clone_releases_icon_while_dead_hero_can_revive(self):
        self.register(self.clone)
        self.register(self.hero)
        self.clone.type = 0
        self.hero.life = 0
        self.vm.run('WOS_UpdateHeroMinimap')
        self.assertEqual([1], self.destroyed)
        self.assertEqual(1, self.vm.g['WOS_MiniCount'])
        self.assertIs(self.hero, self.vm.g['WOS_MiniUnit'][1])
        self.assertEqual(1, self.vm.g['WOS_MiniUnits'][id(self.hero), 0])
        self.assertFalse(self.visible[2])
        self.hero.life = 100
        self.vm.run('WOS_UpdateHeroMinimap')
        self.assertTrue(self.visible[2])
        self.assertEqual(2, len(self.created))

class ArenaCamera(unittest.TestCase):
    @unittest.skip("arena camera lock is commented out in Starts.j for an icon test")
    def test_base_unlocks_camera_and_arena_locks_with_overlay(self):
        vm = ui.load_source('Starts.j')
        bounds, centers, overlay = [], [], []
        hero = vm.unit(owner=0)
        hero.y = 0
        vm.g.update(Hero={0: hero, 10: None}, CondArena=0, gg_rct_Base='base', gg_rct_Arena='arena',
                    bj_mapInitialCameraBounds='map', Player=lambda pid: pid,
                    GetRectCenterX=lambda _: 15000, GetRectCenterY=lambda _: 15000,
                    CheckCoordsInRect=lambda _, x, y: x > 14000,
                    SetCameraBoundsToRectForPlayerBJ=lambda *args: bounds.append(args),
                    PanCameraToTimedForPlayer=lambda *args: centers.append(args),
                    ArenaMinimap_SetArena=lambda p, on, r: overlay.append((p, on, r)))
        hero.x = 15000
        vm.run('WOS_UpdateArenaCamera', (0,))
        vm.run('WOS_UpdateArenaCamera', (0,))
        # Base: the usual map bounds, one pan on arrival, no per-tick re-centring.
        self.assertEqual([(0, 'map')], bounds)
        self.assertEqual([(0, 15000, 0, 0.0)], centers)
        self.assertEqual([(0, False, 'arena')], overlay)
        hero.x = 0
        vm.run('WOS_UpdateArenaCamera', (0,))
        self.assertEqual((0, 'arena'), bounds[-1])
        self.assertEqual((0, 0, 0, 0.0), centers[-1])
        self.assertEqual((0, True, 'arena'), overlay[-1])
        vm.run('WOS_UpdateArenaCamera', (10,))
        self.assertEqual((10, 'map'), bounds[-1])
        vm.g['CondArena'] = 1
        vm.run('WOS_UpdateArenaCamera', (10,))
        self.assertEqual((10, 'arena'), bounds[-1])


if __name__ == '__main__':
    unittest.main()
