"""Execute Return by Death's deadline, positive-buff dispel and cleanup paths."""
from pathlib import Path
import json
import re
import unittest

from test_crocodile import JassState
import war3_object_workspace as objects
from stage_return_by_death_buff import configure

ROOT = Path(__file__).resolve().parents[1]


class ReturnByDeath(unittest.TestCase):
    def fixture(self):
        source = (ROOT/'triggers/Items/Items.j').read_text(encoding='utf-8-sig')
        struct = re.search(r'    private struct ItemsAnimeEffect\b.*?    endstruct', source, re.S)[0]
        funcs = '\n'.join(re.search(r'    private function '+name+r' takes.*?    endfunction', source, re.S)[0]
                          for name in ('ReturnStart', 'KairosekiStart'))
        # Expand vJASS's implicit instance-member syntax for the native-mock interpreter.
        vm = JassState(re.sub(r'(?<![\w.\]])\.(?=[A-Za-z_])', 'this.', struct+'\n'+funcs))
        ns = vm.structs['ItemsAnimeEffect']
        ns.statics.update(KIND_SUKUNA=1, KIND_SEAL=2, KIND_COFFIN=3, KIND_RETURN=4, KIND_WILL=5, KIND_SPEAR=6,
                          list={}, count=0, clock=None)
        vm.g.update(hs={}, SH_WILL_OF_D_END='will end', CurrentRound=1, HealRegenClock=None, ReturnByDeath_Delay=4.,
                    ReturnByDeath_BuffAbi_ID='return ability', ReturnByDeath_Buff_ID='return buff',
                    ReturnByDeath_FrameSlot=5, TimerStart=lambda *_: None, PauseTimer=lambda *_: None,
                    AddSpecialEffect=vm.effect, EffectSpawn=vm.effect,
                    BlzSetSpecialEffectTimeScale=lambda *_: None,
                    IsUnitType=lambda u, _: u.life <= 0.,
                    BuffUnit01=lambda c, u, *_: vm.add_ability(u, 'return buff'),
                    MyFrameBuffSlot=lambda *_: None, MakeSound=lambda *_: None,
                    SpellBool=lambda *_: True, ItemsAnime_Curse=lambda *_: None,
                    DebuffImmune_Start=lambda *_: 0)
        moves = []

        def move(u, x, y):
            moves.append((x, y))
            u.x, u.y = x, y

        vm.g['SetUnitPosition'] = move
        vm.g['PosUnit'] = move
        vm.g['UnitRemoveBuffs'] = lambda u, positive, negative: vm.remove_ability(u, 'return buff') if positive else None
        return vm, ns, vm.unit(owner=0, x=100., y=200.), moves

    def test_returns_only_after_four_seconds_then_removes_buff_and_effects(self):
        vm, ns, u, moves = self.fixture()
        vm.elapsed = .09
        vm.run('ReturnStart', (u,))
        self.assertIn('return buff', u.abilities)
        self.assertEqual(2, len(vm.effects))
        u.x, u.y = 800., 900.
        for index in range(1, 41):
            vm.elapsed = index*.1
            vm.run('Tick')
        self.assertEqual([], moves)
        vm.elapsed = 4.1
        vm.run('Tick')
        self.assertEqual([(100., 200.)], moves)
        self.assertEqual(0, ns.count)
        self.assertNotIn('return buff', u.abilities)
        self.assertFalse(vm.effects)

    def test_kairoseki_cancels_before_or_at_deadline_and_does_not_rearm(self):
        for dispel_at in (1., 4.):
            with self.subTest(dispel_at=dispel_at):
                vm, ns, u, moves = self.fixture()
                vm.run('ReturnStart', (u,))
                enemy = vm.unit(owner=1)
                vm.elapsed = dispel_at
                vm.run('KairosekiStart', (enemy, u))
                vm.run('Tick')
                self.assertEqual(0, ns.count)
                self.assertFalse(vm.effects)
                # A later unrelated buff application cannot revive the canceled instance.
                vm.add_ability(u, 'return buff')
                vm.elapsed = 8.
                vm.run('Tick')
                self.assertEqual([], moves)

    def test_death_removal_and_round_change_cancel_and_clean_up(self):
        for reason in ('death', 'removed', 'round'):
            with self.subTest(reason=reason):
                vm, ns, u, moves = self.fixture()
                vm.run('ReturnStart', (u,))
                if reason == 'death':
                    u.life = 0.
                elif reason == 'removed':
                    vm.g['GetUnitTypeId'] = lambda _: 0
                else:
                    vm.g['CurrentRound'] = 2
                vm.elapsed = 4.1
                vm.run('Tick')
                self.assertEqual([], moves)
                self.assertEqual(0, ns.count)
                self.assertNotIn('return buff', u.abilities)
                self.assertFalse(vm.effects)

    def test_recast_replaces_position_and_deadline_without_leaking_effects(self):
        vm, ns, u, moves = self.fixture()
        vm.run('ReturnStart', (u,))
        vm.elapsed = 3.
        u.x, u.y = 300., 400.
        vm.run('ReturnStart', (u,))
        self.assertEqual(1, ns.count)
        self.assertEqual(2, len(vm.effects))
        vm.elapsed = 4.1
        vm.run('Tick')
        self.assertEqual([], moves)
        vm.elapsed = 7.
        vm.run('Tick')
        self.assertEqual([(300., 400.)], moves)
        self.assertFalse(vm.effects)

    def test_staging_is_repeatable_and_buff_has_no_native_bonuses(self):
        docs, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
        ids = json.loads((ROOT/'object-data/return-by-death-ids.json').read_text())
        configure(docs, ids, {})
        before = json.dumps(docs, sort_keys=True)
        configure(docs, ids, {})
        self.assertEqual(before, json.dumps(docs, sort_keys=True))
        ability = next(o for d in docs if d['source_file'] == 'war3map.w3a'
                       for o in d['custom_objects'] if objects.object_id(o) == ids['buffAbility'])
        fields = {m['field']['text']: objects.value_for_user(m) for m in ability['modifications']}
        self.assertEqual(ids['buff'], fields['abuf'])
        self.assertEqual(4.5, fields['adur'])
        self.assertEqual(4.5, fields['ahdu'])
        for field in ('Inf1', 'Inf2', 'Inf3'):
            self.assertEqual(0, fields[field])


if __name__ == '__main__':
    unittest.main()
