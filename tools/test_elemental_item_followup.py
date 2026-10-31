"""Execute actual thread geometry, projectile collision and model repair contracts."""
from pathlib import Path
import re
import struct
from types import SimpleNamespace
import unittest

from build_ashen_crossfire_effect import repair
from particle_opt.mdx import chunks, node_end
from test_crocodile import JassState

ROOT = Path(__file__).resolve().parents[1]
SOURCE = (ROOT / 'triggers/Items/Items.j').read_text(encoding='utf-8-sig')


def function(name):
    return re.search(r'(?m)^\s*(?:private )?function ' + name + r' takes.*?endfunction', SOURCE, re.S)[0]


def method(name):
    body = re.search(r'(?m)^\s*method ' + name + r' takes.*?endmethod', SOURCE, re.S)[0]
    return re.sub(r'(?<![\w])\.([A-Za-z]\w*)', r'this.\1', body)


class ElementalFollowup(unittest.TestCase):
    def test_missile_heights_and_scales_use_requested_per_item_offsets(self):
        body = re.search(r'static method Missile takes.*?endmethod', SOURCE, re.S)[0]
        body = re.sub(r'(?<![\w])\.([A-Za-z]\w*)', r'this.\1', body)
        vm = JassState(body)
        c, u = vm.unit(owner=0), vm.unit(100, 0, 1)
        vm.g.update(showVision=True,PROJ=1, DT=.03, Add=lambda *_: SimpleNamespace(),
                    Emberbreaker_ID='ember', LeviathanGrasp_ID='grasp', VoltThread_ID='volt',
                    CinderFang_ID='cinder', SirenTear_ID='siren', MirrorTide_ID='mirror', MirrorTide_ProjectileScale=.66,
                    EffectSpawn=lambda model, x, y, yaw, speed, scale, height: SimpleNamespace(z=height, scale=scale),
                    BlzGetLocalSpecialEffectZ=lambda e: e.z,
                    BlzSetSpecialEffectZ=lambda e, z: setattr(e, 'z', z))
        for src, height, scale in (('ember', 170, 2), ('grasp', 70, 1),
                                   ('volt', 150, 1), ('cinder', 220, 1), ('mirror', 70, .66)):
            fx = vm.run('Missile', (src, c, 0., 0., u, 2000., 'model', 100.))
            self.assertEqual((height, scale), (fx.e.z, fx.e.scale))

    def test_thread_uses_finite_segment_and_endpoint_caps(self):
        vm = JassState(function('ElemNearSegment'))
        for x, y, expected in ((500, 300, True), (500, 301, False),
                                (-300, 0, True), (-301, 0, False),
                                (1300, 0, True), (1301, 0, False)):
            self.assertEqual(expected, vm.run('ElemNearSegment', (x, y, 0., 0., 1000., 0., 300.)))
        self.assertTrue(vm.run('ElemNearSegment', (100., 0., 0., 0., 0., 0., 300.)))

    def test_thread_hits_enemies_near_live_line_not_bounding_circle_or_allies(self):
        vm = JassState(function('ElemNearSegment') + '\n' + method('ThreadPulse'))
        c, target = vm.unit(0, 0, 0), vm.unit(1000, 0, 1)
        near = vm.unit(500, 299, 1)
        outside = vm.unit(500, 301, 1)
        ally = vm.unit(500, 0, 0)
        fx = SimpleNamespace(c=c, u=target, g=[], src='volt', dmg=90., tx=30.)
        hits = []
        vm.g.update(showVision=True,VoltThread_LineRadius=300., NoDecor_Cond=None,
                    ElemValid=lambda c, u: u.owner != c.owner and u.life > 0,
                    ElemHit=lambda c, u, src, dmg, magic, element: hits.append((u, dmg, magic)))
        vm.run('ThreadPulse', obj=fx)
        self.assertEqual([target, near], [hit[0] for hit in hits])
        self.assertEqual([(30., True),(90., True)], [hit[1:] for hit in hits])
        # Move the target: geometry must follow both live endpoints, not cast coordinates.
        target.x, target.y = 0, 1000
        hits.clear()
        vm.run('ThreadPulse', obj=fx)
        self.assertEqual([target], [hit[0] for hit in hits])
        self.assertEqual([], fx.g)

    def test_thread_pulses_five_times_one_second_apart_and_stops_on_caster_death(self):
        body = SOURCE.split('elseif .kind == VOLT then', 1)[1].split('elseif .kind == COIL then', 1)[0]
        body = re.sub(r'(?<![\w])\.([A-Za-z]\w*)', r'this.\1', body)
        vm = JassState('function Tick takes nothing returns boolean\n'+body+'\nreturn false\nendfunction')
        hits = []
        fx = SimpleNamespace(c=SimpleNamespace(life=100), next=1., ln=None,
                             ThreadPulse=lambda: hits.append(tick))
        vm.g.update(showVision=True,DT=.03, ElemAlive=lambda c: c.life > 0)
        for tick in range(1, 168):
            vm.run('Tick', obj=fx)
        self.assertEqual([34, 67, 100, 134, 167], hits)
        fx.c.life = 0
        self.assertTrue(vm.run('Tick', obj=fx))

    def test_coil_projectile_hits_each_enemy_once_and_applies_magic_lightning_slow(self):
        vm = JassState(method('Sweep'))
        c, enemy, ally = vm.unit(0, 0, 0), vm.unit(100, 0, 1), vm.unit(100, 0, 0)
        hit = []
        fx = SimpleNamespace(c=c, src='coil',kind=11)
        damage = []
        vm.g.update(showVision=True,NoDecor_Cond=None, ItemsElements_Group=[], ConstellationCoil_SlowDuration=2,
                    ItemActive_DecorDamage=50., WAVE=9,
                    ElemValid=lambda c, u: u.owner != c.owner,
                    ElemHit=lambda *args: damage.append(args))
        for _ in range(4):
            vm.run('Sweep', (100., 0., 200., hit, None, 550., True, 3, 0., 25), obj=fx)
        self.assertEqual([(c, enemy, 'coil', 550., True, 3)], damage)
        self.assertEqual([(c, enemy, 25, 2)], vm.slows)
        self.assertEqual([(c, 100., 0., 200., 50.)]*4, vm.decor_calls)

    def test_coil_motion_is_straight_finite_and_reaches_1800(self):
        body = SOURCE.split('elseif .kind == COILSHOT then', 1)[1].split('elseif .kind == STRIKES then', 1)[0]
        body = re.sub(r'(?<![\w])\.([A-Za-z]\w*)', r'this.\1', body)
        vm = JassState('function Tick takes nothing returns boolean\nlocal real px\nlocal real py\n'+body+'\nendfunction')
        sweeps = []
        fx = SimpleNamespace(c=vm.unit(),step=0., next=1800., x=100., y=200., vx=.6, vy=.8,
                             left=2., phase=0, charges=0, g=[], dmg=550., e=vm.effect('coil'), e2=vm.effect("trail"),
                             Sweep=lambda *args: sweeps.append(args))
        vm.g.update(showVision=True,ConstellationCoil_Speed=1400., DT=.03, ConstellationCoil_Width=200., ConstellationCoil_Slow=25)
        for _ in range(50):
            vm.run('Tick', obj=fx)
            if fx.phase==1:break
        self.assertEqual(1, fx.phase);self.assertEqual(0.,fx.step)
        self.assertAlmostEqual(1180., fx.e.x)
        self.assertAlmostEqual(1640., fx.e.y)
        self.assertTrue(all(abs((row[0]-100)*.8-(row[1]-200)*.6) < 1e-6 for row in sweeps))

    def test_waves_and_returning_shuriken_clamp_their_travel_distance(self):
        body=SOURCE.split('elseif .kind == ASHEN or .kind == WAVE then',1)[1].split('elseif .kind == COILSHOT then',1)[0]
        body=re.sub(r'(?<![\w])\.([A-Za-z]\w*)',r'this.\1',body)
        vm=JassState('function Tick takes nothing returns boolean\nlocal real px\nlocal real py\nlocal real a\n'+body+'\nendfunction')
        vm.g.update(showVision=True,DT=.03,WAVE=9,ASHEN=8,MirrorTide_WaveAoe=350.,MirrorTide_ProjectileScale=.66,MirrorTide_Push=150.,IntegerTertiaryOp=lambda c,a,b:a if c else b)
        fx=SimpleNamespace(c=vm.unit(),kind=9,phase=0,step=1590.,next=1600.,x=0.,y=0.,vx=1.,vy=0.,e=vm.effect('wave'),g=[],g2=[],dmg=100.,dmg2=50.,Sweep=lambda *_:None)
        self.assertTrue(vm.run('Tick',obj=fx));self.assertEqual(1600.,fx.step)
        fx.c=vm.unit();fx.tx=0.;fx.ty=0.;fx.kind=8;fx.phase=0;fx.step=1790.;fx.next=1800.;fx.e2=vm.effect('a');fx.e3=vm.effect('b');fx.trail1=vm.effect('t1');fx.trail2=vm.effect('t2');fx.trail3=vm.effect('t3')
        self.assertFalse(vm.run('Tick',obj=fx));self.assertEqual((1800.,1),(fx.step,fx.phase))
        fx.step=10.;self.assertTrue(vm.run('Tick',obj=fx));self.assertEqual(0.,fx.step)

    def test_ashen_ribbon_is_orange_additive_and_repair_is_repeatable(self):
        data = (ROOT / 'assets/effects/war3mapImported/wos_AshenCrossfire.mdx').read_bytes()
        self.assertEqual(data, repair(data))
        table = {tag: (off, size) for tag, off, size in chunks(data)}
        node, _ = node_end(data, table['RIBB'][0] + 4)
        color = struct.unpack_from('<3f', data, node + 12)
        for actual, expected in zip(color, (.04, .35, 1.)):
            self.assertAlmostEqual(expected, actual)
        material = struct.unpack_from('<I', data, node + 44)[0]
        mat = table['MTLS'][0]
        for _ in range(material):
            mat += struct.unpack_from('<I', data, mat)[0]
        self.assertEqual(3, struct.unpack_from('<I', data, mat + 24)[0])
        old = bytearray(data)
        struct.pack_into('<3f', old, node + 12, 0., .1333333, 0.)
        struct.pack_into('<I', old, mat + 24, 2)
        self.assertEqual(data, repair(bytes(old)))
        for tag in ('GEOS', 'PRE2', 'TEXS', 'BONE', 'SEQS'):
            start, size = table[tag]
            self.assertEqual(data[start:start+size], old[start:start+size])


if __name__ == '__main__':
    unittest.main()
