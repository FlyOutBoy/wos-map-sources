"""Core Drill (I04E): same-type ability damage stacks, +5% per stack, 5 max, 4 sec."""
from pathlib import Path
import re
import unittest
from collections import defaultdict

from test_crocodile import JassState

ROOT = Path(__file__).resolve().parents[1]


def functions(path, *names):
    text = (ROOT / 'triggers' / path).read_text(encoding='utf-8-sig')
    return '\n'.join(re.search(r'(?m)^\s*(?:(?:private|public) )?function ' + name + r' takes[^\n]*\n[\s\S]*?^\s*endfunction', text)[0]
                     for name in names)


class CoreDrill(unittest.TestCase):
    def setUp(self):
        self.vm = JassState(functions('Items/Items.j', 'CoreDrill_AddStack') + '\n' +
                            functions('Systems/Systems1.j', 'CoreDrill_GetStacks'))
        self.now = 0.0
        table = {}
        self.vm.g.update(
            hs=table, GetHandleId=lambda u: u, TimerGetElapsed=lambda _: self.now,
            TimerStart=lambda *a: None, IMinBJ=min, CoreDrill_Clock='clock', CoreDrill_ClockStarted=False,
            CoreDrill_MaxStacks=5, CoreDrill_Duration=4.0,
            SH_CORE_DRILL_PHYS=1, SH_CORE_DRILL_PHYS_END=2, SH_CORE_DRILL_MAG=3, SH_CORE_DRILL_MAG_END=4,
            LoadInteger=lambda t, h, k: t.get((h, k), 0), SaveInteger=lambda t, h, k, v: t.update({(h, k): v}),
            LoadReal=lambda t, h, k: t.get((h, k), 0.0), SaveReal=lambda t, h, k, v: t.update({(h, k): v}))
        self.shown = []
        self.vm.g['CoreDrill_ShowBuff'] = lambda u, kind, stacks, now: self.shown.append((kind, stacks))

    def add(self, kind):
        self.vm.run('CoreDrill_AddStack', (7, kind))

    def stacks(self, kind):
        return self.vm.run('CoreDrill_GetStacks', (7, kind))

    def test_no_stacks_before_any_damage(self):
        self.assertEqual(0, self.stacks(2))
        self.assertEqual(0, self.stacks(1))

    def test_types_stack_separately_and_cap_at_five(self):
        for _ in range(7):
            self.add(2)
        self.add(1)
        self.assertEqual(5, self.stacks(2))
        self.assertEqual(1, self.stacks(1))
        self.assertEqual(0, self.stacks(0))

    def test_each_stack_refreshes_and_expired_stacks_restart_at_one(self):
        self.add(1); self.now = 3.0; self.add(1)
        self.now = 6.9
        self.assertEqual(2, self.stacks(1))
        self.now = 7.0
        self.assertEqual(0, self.stacks(1))
        self.add(1)
        self.assertEqual(1, self.stacks(1))

    def test_each_stack_shows_its_level_buff(self):
        for _ in range(6):
            self.add(2)
        self.add(1)
        self.assertEqual([(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 5), (1, 1)], self.shown)

    def show_vm(self):
        vm = JassState(functions('Items/Items.j', 'CoreDrill_Buff', 'CoreDrill_ShowBuff'))
        self.removed, self.orders, self.levels, self.abilities = [], [], [], []
        self.created = []
        table = {}
        def create(*a):
            self.created.append({'life': 100.0})
            return self.created[-1]
        vm.g.update(hs=table, GetHandleId=lambda u: u, GetPlayerId=lambda p: p, GetOwningPlayer=lambda u: 3,
                    CoreDrill_MaxStacks=5, CoreDrill_RecastGap=0.25,
                    SH_CORE_DRILL_PHYS_SHOWN=11, SH_CORE_DRILL_PHYS_CAST=12, SH_CORE_DRILL_MAG_SHOWN=13, SH_CORE_DRILL_MAG_CAST=14,
                    LoadInteger=lambda t, h, k: t.get((h, k), 0), SaveInteger=lambda t, h, k, v: t.update({(h, k): v}),
                    LoadReal=lambda t, h, k: t.get((h, k), 0.0), SaveReal=lambda t, h, k, v: t.update({(h, k): v}),
                    HaveSavedReal=lambda t, h, k: (h, k) in t,
                    CoreDrill_PhysAbi='phys', CoreDrill_MagAbi='mag', CoreDrill_Dummy=defaultdict(lambda: None),
                    CoreDrill_DummyAbi=defaultdict(int),
                    UnitRemoveAbility=lambda u, b: self.removed.append(b), GetWidgetLife=lambda u: u['life'],
                    GetUnitTypeId=lambda u: 'h0C9', CreateUnit=create, Player=lambda p: p, GetRectCenterX=lambda r: 0.0,
                    GetRectCenterY=lambda r: 0.0, gg_rct_Caster='caster',
                    UnitAddAbility=lambda u, a: self.abilities.append(a), SetUnitAbilityLevel=lambda u, a, l: self.levels.append((a, l)),
                    SetUnitFacing=lambda *a: None, GAngle=lambda *a: 0.0, bj_RADTODEG=57.3,
                    IssueTargetOrder=lambda u, o, t: self.orders.append(o))
        return vm

    def test_show_buff_casts_the_level_on_one_permanent_dummy_per_player(self):
        vm = self.show_vm()
        vm.run('CoreDrill_ShowBuff', ('hero', 1, 3, 0.0))
        self.assertEqual([], self.removed)
        self.assertEqual(['mag'], self.abilities)
        self.assertEqual([('mag', 3)], self.levels)
        self.assertEqual(['innerfire'], self.orders)
        self.assertIs(self.created[0], vm.g['CoreDrill_Dummy'][3])
        # Same level inside the recast gap: no new cast.
        vm.run('CoreDrill_ShowBuff', ('hero', 1, 3, 0.1))
        self.assertEqual(['innerfire'], self.orders)
        # New level: only the previously shown level's buff is removed.
        vm.run('CoreDrill_ShowBuff', ('hero', 1, 4, 0.15))
        self.assertEqual(['B054'], self.removed)
        self.assertEqual(['mag'], self.abilities)
        # Same level after the gap: recast to refresh the buff.
        vm.run('CoreDrill_ShowBuff', ('hero', 1, 4, 0.5))
        self.assertEqual(3, len(self.orders))
        # The other type swaps the ability on the same dummy; no second dummy.
        vm.run('CoreDrill_ShowBuff', ('hero', 2, 1, 0.5))
        self.assertEqual(['mag', 'phys'], self.abilities)
        self.assertIn('mag', self.removed)
        self.assertEqual([('mag', 3), ('mag', 4), ('mag', 4), ('phys', 1)], self.levels)
        self.assertEqual(1, len(self.created))

    def test_bonus_is_applied_only_to_the_same_type_in_damage_modifiers(self):
        src = (ROOT / 'triggers/Systems/Systems1.j').read_text(encoding='utf-8-sig')
        body = re.search(r'function DamageCheckModifiers takes.*?\nendfunction', src, re.S).group(0)
        self.assertIn('CoreDrill_GetStacks(c, typedmg)', body)
        self.assertIn('stacks * CoreDrill_BonusPerStack / 100.0', body)
        dmg = (ROOT / 'triggers/Systems/DmgSys.j').read_text(encoding='utf-8-sig')
        self.assertRegex(dmg, r'not eventIsAttack[^\n]*HasCachedItem\(c, CoreDrill_ID\)[^\n]*\n\s*call CoreDrill_AddStack\(c, typedmg\)')


if __name__ == '__main__':
    unittest.main()
