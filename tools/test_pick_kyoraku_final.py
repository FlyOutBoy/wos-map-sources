"""Production picker text and Kyoraku final-act state with native mocks, not engine QA."""
from pathlib import Path
import math
import re
import unittest

from test_crocodile import JassState

ROOT = Path(__file__).resolve().parents[1]


class PickGold(unittest.TestCase):
    def test_messages_and_tooltip_follow_actual_payment_expressions(self):
        text = (ROOT/'triggers/WOS_Start/WoS_Pick_Init.j').read_text(encoding='utf-8-sig')
        start = text.index('        if PickedOnce[pid] == 1 then\n            call AddGold')
        block = text[start:text.index('\n        endif', start)+len('\n        endif')]
        charge = next(line for line in text.splitlines() if 'call AddGold(p, R2I(AddRandom / 2), false)' in line)
        tip = next(line for line in text.splitlines() if 'call WUI_TooltipBelow(FRAME_Repick[i]' in line)
        vm = JassState('function Report takes nothing returns nothing\n'+block+'\nendfunction\n'
                       'function Charge takes nothing returns nothing\n'+charge+'\nendfunction\n'
                       'function Tip takes nothing returns nothing\n'+tip+'\nendfunction\n')
        messages, amounts, tips = [], [], []
        vm.g.update(p=0, pid=0, i=0, Hero={0:'hero'}, FRAME_Repick={0:'repick'}, PickedOnce={0:1},
                    GetPlayerColorString=lambda _: '', GetPlayerName=lambda _: 'player',
                    BlzGetUnitStringField=lambda *_: 'hero', UNIT_SF_NAME='name',
                    AddGold=lambda p, value, plus: amounts.append((value, plus)),
                    WUI_Feed=lambda message, _: messages.append(message),
                    WUI_TooltipBelow=lambda _, message: tips.append(message), I2S=str, R2I=int)
        for reward in (500, 750, 501, 0):
            vm.g['AddRandom'] = reward
            vm.g['PickedOnce'][0] = 1
            vm.run('Report')
            self.assertIn('+'+str(reward)+' gold', messages[-1])
            self.assertEqual((reward, True), amounts[-1])
            vm.g['PickedOnce'][0] = 2
            vm.run('Charge'); vm.run('Report'); vm.run('Tip')
            self.assertEqual((int(reward/2), False), amounts[-1])
            self.assertIn('-'+str(int(reward/2))+' gold', messages[-1])
            self.assertIn('costs '+str(int(reward/2))+' gold', tips[-1])


class KyorakuFinal(unittest.TestCase):
    def setUp(self):
        source = (ROOT/'triggers/Heroes/Kyoraku.j').read_text(encoding='utf-8-sig')
        start = source.index('    private struct KyorakuT4_KS')
        code = source[start:source.index('    endstruct', start)+len('    endstruct')]
        code = re.sub(r'(?<![\w.])\.(?=[A-Za-z_])', 'this.', code)
        self.vm = vm = JassState(code)
        self.ns = vm.structs['KyorakuT4_KS']
        self.ns.statics.update(MUI_KyorakuT2=-1, m_KyorakuT2={})
        self.hero = vm.unit(x=0, y=0, owner=0)
        self.target = vm.unit(x=800, y=0, owner=1)
        self.events, self.releases, self.sources = [], [], []
        self.tick = 0
        def lock(u):
            u.paused = True
            u.abilities['Avul'] = True
        def release(u):
            self.releases.append(u)
            u.paused = False
            u.abilities.pop('Avul', None)
        def damage(c, target, value):
            self.assertNotIn('Avul', target.abilities)
            self.assertFalse(target.paused)
            self.events.append((self.tick, c, target, value))
        vm.g.update(hs={}, SH_LAST_DAN='last dan', SH_BANKAI_END='bankai end',
                    KyorakuT_DanFinal_Dmg=float(re.search(r'real KyorakuT_DanFinal_Dmg = ([\d.]+)', source)[1]),
                    KyorakuT_DanFinal_Stun=float(re.search(r'real KyorakuT_DanFinal_Stun = ([\d.]+)', source)[1]),
                    gg_snd_Hero_Kyoraku_T14__2=None, StopSound=lambda *_: None,
                    SpellBoolCaster=lambda u: u is not None and u.life > .405,
                    GAngle=lambda c, t: math.atan2(t.y-c.y, t.x-c.x),
                    SR2=lambda c, t: math.hypot(t.x-c.x, t.y-c.y),
                    StartSpellUnit=lock, DebugUnit=lock, StopSpellUnit=release,
                    KyorakuTick_On=lambda *_: None, KyorakuTick_Off=lambda *_: None,
                    MakeSound3=lambda *_: None, SetUnitFacing=lambda *_: None,
                    SetUnitAnimationByIndex=lambda *_: None, CameraSetTargetNoise=lambda *_: None,
                    GetLocalPlayer=lambda: 0, AnimDummyEff=lambda *_: None,
                    BlzSetSpecialEffectTimeScale=lambda *_: None, ColorEffDummy3=lambda *_: None,
                    PathableCheck3=lambda *_: True, DamageSource=lambda source: self.sources.append(source),
                    dmgphys=damage, deallocate=lambda data: setattr(data, 'alive', False),
                    MUE=lambda *_: self.fail('final pass-through must not depend on external forced movement'))
        for name in ('EffectSpawn', 'EffectSpawn2', 'EffectSpawnColor', 'AddSpecialEffectTarget'):
            vm.g[name] = lambda *_: object()
        vm.g.update(DestroyEffect=lambda *_: None, EMUE=lambda *_: None)

    def start(self, c=None, t=None):
        self.vm.run('KyorakuT4_Start', (c or self.hero, t or self.target))
        data = self.ns.m_KyorakuT2[self.ns.MUI_KyorakuT2]
        data.deallocate = lambda *_: setattr(data, 'alive', False)
        return data

    def advance(self, ticks):
        for _ in range(ticks):
            self.tick += 1
            self.vm.run('Loop_KyorakuT4')

    def test_passes_through_target_and_finishes_once_on_schedule(self):
        data = self.start()
        self.advance(89)
        self.assertEqual(0, self.hero.x)
        self.advance(111)
        self.assertGreater(self.hero.x, self.target.x+500)
        self.assertAlmostEqual(0, data.dashRemaining)
        self.assertFalse(self.events)
        self.advance(6)
        self.assertEqual(-1, self.ns.MUI_KyorakuT2)
        self.assertEqual([(206, self.hero, self.target, 1000)], self.events)
        self.assertEqual(['A059'], self.sources)
        self.assertEqual([(self.target, 1.5)], self.vm.stuns)
        self.assertFalse(self.hero.paused or self.target.paused)
        self.assertEqual(1, self.vm.g['hs'][id(self.hero), 'bankai end'])
        self.advance(100)
        self.assertEqual(1, len(self.events))

    def test_blocked_movement_times_out_without_damage_or_leaving_units_locked(self):
        self.vm.g['MoveUnit'] = lambda *_: None
        self.start(); self.advance(206)
        self.assertEqual(-1, self.ns.MUI_KyorakuT2)
        self.assertFalse(self.events)
        self.assertFalse(self.hero.paused or self.target.paused)

    def test_cancel_at_capture_tick_releases_target_without_executing_it(self):
        self.start(); self.advance(60)
        self.assertTrue(self.target.paused)
        self.hero.life = 0
        self.advance(1)
        self.assertFalse(self.target.paused)
        self.assertNotIn('Avul', self.target.abilities)
        self.assertFalse(self.events or self.vm.stuns)

    def test_dead_or_removed_target_cancels_without_damage(self):
        self.start(); self.advance(100)
        self.target.life = 0
        self.advance(1)
        self.assertEqual(-1, self.ns.MUI_KyorakuT2)
        self.assertFalse(self.events)
        self.assertFalse(self.hero.paused or self.target.paused)

    def test_invalid_start_does_not_allocate_or_lock(self):
        self.vm.run('KyorakuT4_Start', (self.hero, None))
        self.target.life = 0
        self.vm.run('KyorakuT4_Start', (self.hero, self.target))
        self.assertEqual(-1, self.ns.MUI_KyorakuT2)
        self.assertFalse(self.hero.paused)

    def test_simultaneous_finish_revisits_moved_instance_and_hits_each_target_once(self):
        other = self.vm.unit(x=0, y=500, owner=2)
        target = self.vm.unit(x=900, y=500, owner=3)
        self.start(); self.start(other, target); self.advance(206)
        self.assertEqual(-1, self.ns.MUI_KyorakuT2)
        self.assertEqual(2, len(self.events))
        self.assertEqual({id(self.target), id(target)}, {id(event[2]) for event in self.events})
        self.assertFalse(any(u.paused for u in (self.hero, self.target, other, target)))


if __name__ == '__main__':
    unittest.main()
