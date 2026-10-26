"""Run real Akainu cast/death paths; native MDX playback still needs Warcraft."""
import math
import re
import unittest
from pathlib import Path

from test_crocodile import JassState

ROOT = Path(__file__).resolve().parents[1]


class AkainuAttachments(unittest.TestCase):
    def setUp(self):
        source = (ROOT / 'triggers/Heroes/Akainu.j').read_text('utf-8-sig')
        parts = re.findall(r'(?m)^\s*globals\b.*?\bendglobals', source, re.S)
        for slot in ('Q', 'R', 'T'):
            body = re.search(r'    private struct AkainuSpells_' + slot +
                             r'\b.*?    endstruct', source, re.S)[0]
            # The small evaluator needs unique names for methods across structs.
            parts.append(body.replace('method OnDeath takes', f'method {slot}_OnDeath takes'))
        for name in ('Akainu_ClearHandEffect', 'Akainu_Death'):
            body = re.search(r'(?m)^\s*(?:private )?function ' + name +
                             r' takes[^\n]*\n.*?\bendfunction', source, re.S)[0]
            for slot in ('Q', 'R'):
                body = body.replace(f'AkainuSpells_{slot}.OnDeath', f'AkainuSpells_{slot}.{slot}_OnDeath')
            parts.append(body)
        self.vm = vm = JassState('\n'.join(parts))
        for slot in ('Q', 'R', 'T'):
            vm.structs['AkainuSpells_' + slot].statics.update({
                'MUI_Akainu' + slot: -1, 'm_Akainu' + slot: {}})
        self.attached = {}
        self.destroyed = []
        destroy = vm.destroy_effect

        def attach(model, unit, point):
            effect = vm.effect(model)
            effect.alpha, effect.scale, effect.timescale = 255, 1., 1.
            self.attached[id(effect)] = (effect, unit, point)
            return effect

        def clear(effect):
            if effect is not None and id(effect) in self.attached:
                self.destroyed.append((effect.alpha, effect.scale, effect.timescale))
                self.attached.pop(id(effect))
            destroy(effect)

        vm.g.update(
            AddSpecialEffectTarget=attach, DestroyEffect=clear,
            BlzSetSpecialEffectTimeScale=lambda e, value: setattr(e, 'timescale', value),
            EffectSpawnColor=vm.effect,
            ColorEffDummy3=lambda effect, *a: destroy(effect),
            SetUnitAnimationByIndex=lambda *a: None, MakeSound=lambda *a: None,
            DebugUnit=lambda *a: None, DebugUnit2=lambda *a: None,
            SetUnitFacing=lambda u, value: setattr(u, 'facing', value),
            SR2=lambda u, v: math.hypot(u.x - v.x, u.y - v.y),
            GAngle=lambda u, v: math.atan2(v.y - u.y, v.x - u.x),
            GAngle2=lambda u, x, y: math.atan2(y - u.y, x - u.x),
            MoveUnit2=vm.g['MoveUnit'],
            AkainuTimer03Acquire=lambda: setattr(vm, 'clock_users', vm.clock_users + 1),
            AkainuTimer03Release=lambda: setattr(vm, 'clock_users', vm.clock_users - 1))
        self.c = self.caster()
        self.target = vm.unit(x=1000., owner=1)

    def caster(self):
        caster = self.vm.unit(owner=0)
        caster.type = self.vm.g['Akainu_ID']
        return caster

    def start(self, slot, caster=None):
        caster = caster or self.c
        ns = self.vm.structs['AkainuSpells_' + slot]
        args = (caster, self.target) if slot == 'Q' else (caster, 1000., 0.)
        self.vm.run('Akainu' + slot + '_Start', args)
        data = getattr(ns, 'm_Akainu' + slot)[getattr(ns, 'MUI_Akainu' + slot)]
        data.deallocate = lambda *a: setattr(data, 'alive', False)
        return data

    def step(self, slot):
        self.vm.run('Loop_Akainu' + slot)

    def assert_finished(self, slot):
        self.assertEqual(-1, getattr(self.vm.structs['AkainuSpells_' + slot], 'MUI_Akainu' + slot))
        self.assertEqual({}, self.attached)
        self.assertEqual(set(), self.vm.groups)
        self.assertEqual(0, self.vm.clock_users)

    def test_q_r_death_hides_effect_immediately_and_cancels_after_fast_revive(self):
        for slot in ('Q', 'R'):
            for time in (0., .30, .75):
                with self.subTest(slot=slot, time=time):
                    data = self.start(slot)
                    data.r = time
                    self.c.life = 0.
                    self.vm.run('Akainu_Death', (self.c,))
                    self.assertEqual({}, self.attached)
                    self.assertIsNone(data.e)
                    self.assertGreater(data.r, data.rmax)
                    self.c.life = 100.  # A resurrection before the .03-second tick.
                    self.step(slot)
                    self.assert_finished(slot)
                    self.assertFalse(data.alive)
                    self.assertFalse(self.c.paused)
                    self.assertEqual([], self.vm.damage)
        self.assertTrue(all(values == (0, 0., 1.) for values in self.destroyed))

    def test_q_r_timer_also_cleans_corpse_removed_unit_and_normal_timeout(self):
        for slot in ('Q', 'R'):
            for reason in ('dead', 'removed', 'timeout'):
                with self.subTest(slot=slot, reason=reason):
                    self.c.type = self.vm.g['Akainu_ID']
                    self.c.life = 100.
                    data = self.start(slot)
                    if reason == 'dead':
                        self.c.life = 0.
                    elif reason == 'removed':
                        self.c.type = 0
                    else:
                        data.r = data.rmax + .03
                    self.step(slot)
                    self.assert_finished(slot)

    def test_q_target_death_also_releases_attached_hand(self):
        self.start('Q')
        self.target.life = 0.
        self.step('Q')
        self.assert_finished('Q')
        self.assertFalse(self.c.paused)

    def test_q_r_normal_casts_finish_and_release_the_attachment(self):
        for slot in ('Q', 'R'):
            with self.subTest(slot=slot):
                self.start(slot)
                for _ in range(90):
                    self.step(slot)
                    if getattr(self.vm.structs['AkainuSpells_' + slot], 'MUI_Akainu' + slot) == -1:
                        break
                self.assert_finished(slot)
                self.assertFalse(self.c.paused)

    def test_death_only_cancels_the_dying_casters_instances(self):
        other = self.caster()
        other.x = 200.  # Native handles differ; SimpleNamespace compares fields.
        for slot in ('Q', 'R'):
            self.start(slot, self.c)
            self.start(slot, other)
        self.vm.run('Akainu_Death', (self.c,))
        self.assertEqual(2, len(self.attached))
        self.assertTrue(all(unit is other for _, unit, _ in self.attached.values()))
        for slot in ('Q', 'R'):
            self.step(slot)
            self.assertEqual(0, getattr(self.vm.structs['AkainuSpells_' + slot], 'MUI_Akainu' + slot))
        self.vm.run('Akainu_Death', (other,))
        for slot in ('Q', 'R'):
            self.step(slot)
        self.assert_finished('Q')
        self.assert_finished('R')

    def test_t_death_cleans_both_hands_through_the_entire_windup(self):
        for time in (0., 1.65, 1.68, 1.71, 1.77):
            with self.subTest(time=time):
                self.c.life = 100.
                data = self.start('T')
                data.r = time
                self.assertEqual(2, len(self.attached))
                self.c.life = 0.
                self.step('T')
                self.assert_finished('T')

    def test_main_death_event_calls_cleanup_before_other_hero_processing(self):
        source = (ROOT / 'triggers/Systems/Death.j').read_text('utf-8-sig')
        self.assertIn('static if LIBRARY_AkainuSpells then\n        call Akainu_Death(td)\n    endif', source)
        self.assertLess(source.index('call Akainu_Death(td)'), source.index('if IsUnitType(td, UNIT_TYPE_HERO)'))


if __name__ == '__main__':
    unittest.main()
