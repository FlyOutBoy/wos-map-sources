"""Check native cooldown groups, mana tiers, damage budgets and model assets."""
from pathlib import Path
import json
import unittest
import struct

from balance_active_items import MANA_COSTS, ELEMENT_ITEMS, GROUP_ABILITIES, configure
from check_item_descriptions import Audit
import war3_object_workspace as objects
from particle_opt.mdx import chunks, texs, node_end
from build_elemental_projectile_assets import AXE_RIBBON_BGR, recolour_axe_ribbons
from PIL import Image, ImageStat

ROOT = Path(__file__).resolve().parents[1]
SOURCE = (ROOT/'triggers/Items/Items.j').read_text(encoding='utf-8-sig')


class ElementalBalance(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.audit = Audit()

    def test_shared_cooldowns_are_native_only_and_do_not_keep_reset_blocking_state(self):
        code = SOURCE + (ROOT/'triggers/Systems/CastCheck.j').read_text(encoding='utf-8-sig')
        code += (ROOT/'triggers/Systems/ItemEnter.j').read_text(encoding='utf-8-sig')
        for old in ('ItemsElements_SharedRemaining', 'ItemsElements_RefreshShared',
                    'ItemsElements_StartShared', 'ElementCooldownKey', 'SH_ElementFireCD',
                    'SH_ElementWaterCD', 'SH_ElementLightningCD'):
            self.assertNotIn(old, code)
        # Native item icid is the only cross-item cooldown authority; reset can clear it.
        groups = {family: set() for family in GROUP_ABILITIES}
        for iid, family in ELEMENT_ITEMS.items():
            groups[family].add(self.audit.items[iid]['cooldown_group'])
        self.assertEqual({family: {aid} for family, aid in GROUP_ABILITIES.items()}, groups)

    def test_axes_use_plain_spawn_and_orange_ribbon_nodes(self):
        self.assertEqual(3, SOURCE.count('= EffectSpawn(AshenCrossfire_ProjectileModel,'))
        self.assertNotIn('EffectSpawn3(AshenCrossfire_ProjectileModel,', SOURCE)
        data = (ROOT/'assets/effects/war3mapImported/wos_mx-yx-tsw-a-1_fire.mdx').read_bytes()
        self.assertEqual(data, recolour_axe_ribbons(data))
        count = 0
        for tag, start, size in chunks(data):
            if tag != 'RIBB':
                continue
            end = start + size
            while start < end:
                node, _ = node_end(data, start + 4)
                for actual, expected in zip(struct.unpack_from('<3f', data, node + 12), AXE_RIBBON_BGR):
                    self.assertAlmostEqual(expected, actual)
                count += 1
                start += struct.unpack_from('<I', data, start)[0]
        self.assertEqual(2, count)

    def test_native_groups_and_all_active_mana_tiers_match_and_staging_is_idempotent(self):
        abilities = json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
        for aid, cost in MANA_COSTS.items():
            self.assertIn(cost, (125, 150, 175))
            self.assertEqual(cost, abilities[aid]['mana_cost level 1'], aid)
        for iid, family in ELEMENT_ITEMS.items():
            self.assertEqual(GROUP_ABILITIES[family], self.audit.items[iid]['cooldown_group'])
            self.assertIn('Shared CD: '+family+' items.', self.audit.expected(iid))
        docs, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
        before = json.dumps(docs, sort_keys=True)
        configure(docs)
        self.assertEqual(before, json.dumps(docs, sort_keys=True))

    def test_single_target_own_damage_never_exceeds_six_including_all_item_followups(self):
        v = self.audit.values
        budgets = {
            'Ember': v['Emberbreaker_Impact']+v['Emberbreaker_Burn']+v['Emberbreaker_Retaliate'],
            'Grasp': v['LeviathanGrasp_Impact']+v['LeviathanGrasp_Squeeze'],
            'Anchor': v['LeviathanAnchor_Damage'],
            'Verdict': v['ThunderVerdict_Damage']+v['ThunderVerdict_Bonus'],
            'Bastion': v['ThunderBastion_Damage']+3*v['ThunderBastion_Counter'],
            'Cinder': v['CinderFang_Impact']+v['CinderFang_Bonus'],
            'Cinder ricochet': v['CinderFang_Ricochet'],
            'Ashen': max(v['AshenCrossfire_Damage'], v['AshenCrossfire_Return']),
            'Mirror': v['MirrorTide_Damage']+v['MirrorTide_Reflect'],
            'Volt target': v['VoltThread_Damage']+v['VoltThread_Bonus'],
            'Volt others': 3*v['VoltThread_LineDamage'],
            'Phoenix': v['PhoenixSeal_Impact']+v['PhoenixSeal_Burn']+v['PhoenixSeal_Bonus'],
            'Crimson': v['CrimsonScripture_Damage']+v['CrimsonScripture_Ground']+v['CrimsonScripture_Burning'],
            'Siren': v['SirenTear_Damage'], 'Coil': v['ConstellationCoil_Damage'],
            'Rhitta': v['Rhitta_Damage'], 'Shark': v['Shark_Trail_DamageBase'],
            'Raijin': v['Raijin_Wrath_Damage'], 'RedCup': v['RedCup_Damage'], 'RedFlower': v['RedFlower_DamageBase'],
        }
        for name, budget in budgets.items():
            self.assertGreater(budget, 0., name)
            self.assertLessEqual(budget, 6., name)

    def test_projectile_dependencies_and_axe_effect_textures_are_ready(self):
        folder = ROOT/'assets/effects/war3mapImported'
        for model in ('wos_file00012198.mdx', 'wos_tx28.mdx', 'wos_mx-yx-tsw-a-1_fire.mdx'):
            data = (folder/model).read_bytes()
            for tag, offset, size in chunks(data):
                if tag == 'TEXS':
                    for _, path in texs(data, offset, size):
                        if path.lower().startswith('war3mapimported\\'):
                            self.assertTrue((folder/path.replace('\\', '/').split('/')[-1]).is_file(), path)
        for texture in ('wos_MX-YX-TSW-A-1-2_fire.blp', 'wos_MX-YX-TSW-A-1-3_fire.blp'):
            red, green, blue = ImageStat.Stat(Image.open(folder/texture).convert('RGB')).mean
            self.assertGreater(red, green*1.5)
            self.assertGreater(green, blue*1.5)
        self.assertIn('real MirrorTide_ProjectileScale = 0.66', SOURCE)
        self.assertIn('real ConstellationCoil_Range = 1800', SOURCE)
        self.assertIn('near, 1600, MirrorTide_ProjectileModel', SOURCE)


if __name__ == '__main__':
    unittest.main()
