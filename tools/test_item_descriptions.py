"""Checks source-driven item text, native stats and repeatable text-only updates."""
import copy
import unittest

from check_item_descriptions import Audit


class ItemDescriptionsTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.audit = Audit()

    def test_catalog_parity_and_repeatability(self):
        self.assertEqual(len(self.audit.items), 158)
        self.assertEqual(self.audit.changes(), [])
        for identity in self.audit.items:
            expected = self.audit.expected(identity)
            clone = copy.copy(self.audit)
            clone.items = {**self.audit.items, identity: {**self.audit.items[identity],
                            'description': expected, 'extended_tooltip': expected}}
            self.assertEqual(clone.expected(identity), expected, identity)

    def test_script_constant_drives_egg_text(self):
        clone = copy.copy(self.audit)
        clone.values = {**clone.values, 'OkarunEggReduceCD': 17.5}
        clone.bodies = clone.reviewed_bodies()
        self.assertIn('17.5%', clone.expected('I011'))

    def test_native_hp_drives_jewel_stats(self):
        clone = copy.copy(self.audit)
        clone.abilities = copy.deepcopy(clone.abilities)
        clone.abilities['A020']['Ilif', 1] = 300
        self.assertIn('+1300 hp', clone.expected('I020'))

    def test_cosmetic_fire_lifetime_is_not_debuff_duration(self):
        clone = copy.copy(self.audit)
        clone.values = {**clone.values, 'FunnyBarrel_FireExist': 42}
        self.assertEqual(clone.expected('I00G'), self.audit.expected('I00G'))
        self.assertIn('5 sec', clone.expected('I00G'))


if __name__ == '__main__':
    unittest.main()
