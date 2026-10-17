"""MAIN Crocodile sand: grid lookups and the shared 0.5 s slow pulse."""
import unittest

from test_crocodile import JassState


class SandGrid(unittest.TestCase):
    def setUp(self):
        self.vm = JassState()
        self.c = self.vm.unit()
        self.vm.hero(self.c)
        self.sand = self.vm.structs['CrocodileSand_Struct']

    def add(self, x, y=0., radius=250.):
        self.vm.run('CrocodileSand_Start', (self.c, x, y, radius, False))

    def live(self):
        return [self.sand.m[i] for i in range(self.sand.MUI + 1)]

    def test_lookup_reads_only_the_unit_cell_and_respects_the_circle(self):
        self.add(1000.); self.add(9000.)
        inside = self.vm.unit(1240., 0., owner=self.c.owner + 1)
        edge = self.vm.unit(1250.01, 0., owner=self.c.owner + 1)
        far = self.vm.unit(5000., 0., owner=self.c.owner + 1)
        on = lambda u: self.vm.run('CrocodileSand_IsOnGround', (u, None))
        self.assertTrue(on(inside)); self.assertFalse(on(edge)); self.assertFalse(on(far))

    def test_spacing_and_growth_regrid_the_same_patch(self):
        self.add(1000., radius=200.)
        self.add(1100., radius=600.)  # Within MinDistance: refresh + grow, no new patch.
        self.assertEqual(0, self.sand.MUI)
        u = self.vm.unit(1590., 0., owner=self.c.owner + 1)
        self.assertTrue(self.vm.run('CrocodileSand_IsOnGround', (u, None)))

    def test_one_pulse_slows_each_enemy_once_and_expiry_empties_cells(self):
        self.add(1000.); self.add(1200.); self.add(9000.)
        enemy = self.vm.unit(1100., 0., owner=self.c.owner + 1)
        ally = self.vm.unit(1100., 0., owner=self.c.owner)
        far = self.vm.unit(5000., 0., owner=self.c.owner + 1)
        del self.vm.slows[:]
        before = len(self.vm.scan_calls)
        self.vm.run('CrocodileSand_Pulse')  # The 0.5 s shared pulse body.
        self.assertEqual(1, len(self.vm.scan_calls) - before)  # One enumeration, not one per patch.
        self.assertEqual(1, len([s for s in self.vm.slows if enemy in s]))
        self.assertFalse([s for s in self.vm.slows if ally in s or far in s])
        for patch in self.live():
            patch.endNow = True
        self.vm.run('Loop_CrocodileSand')
        self.assertEqual(-1, self.sand.MUI)
        grid = self.vm.g['CrocodileSand_Grid']
        self.assertFalse([k for k, v in grid.items() if k[1] == 0 and v])


if __name__ == '__main__':
    unittest.main()
