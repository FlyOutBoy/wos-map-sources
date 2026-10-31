"""Ashisogi Jizo poison: a dispellable curse debuff like Kurikara, 0.5x Agility per second."""
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]


class AshisogiPoison(unittest.TestCase):
    def test_poison_lives_on_its_buff_like_kurikara(self):
        src = (ROOT / 'triggers/Systems/DecorDestroy_and_Erza_Debuff.j').read_text(encoding='utf-8-sig')
        self.assertNotIn('SH_ASHISOGI_LEFT', src)  # no private tick counter: a dispel must end it
        loop = re.search(r'method Loop_Elemental takes.*?endmethod', src, re.S).group(0)
        alive = re.search(r'if k2 == 10 then\s*\n\s*set alive = [^\n]*\n\s*else\s*\n\s*set alive = GetWidgetLife\(td\) > 0\.405 and GetUnitAbilityLevel\(td, id\) > 0', loop)
        self.assertIsNotNone(alive)
        self.assertIn('set id = AshisogiJizo_Buff_ID', src)

    def test_damage_and_texts_are_half_agility(self):
        items = (ROOT / 'triggers/Items/Items.j').read_text(encoding='utf-8-sig')
        self.assertIn('real AshisogiJizo_DamageAgi = 0.5 ', items)
        tips = (ROOT / 'object-data/items.json').read_text(encoding='utf-8')
        self.assertEqual(2, tips.count('dealing 0.5x Agility physical damage every second for 5 sec.'))


if __name__ == '__main__':
    unittest.main()
