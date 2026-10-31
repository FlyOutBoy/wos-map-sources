"""Check native cooldown groups, mana tiers, damage budgets and model assets."""
from pathlib import Path
import json
import unittest
import struct

from balance_active_items import (MANA_COSTS, ELEMENT_ITEMS, GROUP_ABILITIES,
                                 DAMAGE_CAST_RANGES, SKILLSHOT_ABILITIES, configure,
                                 native_field_errors)
from check_item_descriptions import Audit
import war3_object_workspace as objects
import war3_object_data as raw
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

    def test_pitched_shurikens_and_legacy_orange_ribbon_nodes(self):
        self.assertEqual(3, SOURCE.count('= EffectSpawn3(AshenCrossfire_ProjectileModel,'))
        self.assertNotIn('= EffectSpawn(AshenCrossfire_ProjectileModel,', SOURCE)
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
            self.assertIn(cost, (0, 80, 125, 150, 175))
            self.assertEqual(cost, abilities[aid]['mana_cost level 1'], aid)
        for iid, family in ELEMENT_ITEMS.items():
            self.assertEqual(GROUP_ABILITIES[family], self.audit.items[iid]['cooldown_group'])
            self.assertIn('Shared CD: '+family+' items.', self.audit.expected(iid))
        docs, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
        before = json.dumps(docs, sort_keys=True)
        configure(docs)
        self.assertEqual(before, json.dumps(docs, sort_keys=True))

    def test_single_target_damage_respects_reviewed_budgets_including_requested_followups(self):
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
            'Mirror': v['MirrorTide_Damage']+3*v['MirrorTide_Reflect'],
            'Volt target': v['VoltThread_Damage']+v['VoltThread_Duration']*v['VoltThread_TargetDamage']+v['VoltThread_Bonus'],
            'Volt others': v['VoltThread_Duration']*v['VoltThread_LineDamage'],
            'Phoenix': v['PhoenixSeal_Impact']+v['PhoenixSeal_Burn']+v['PhoenixSeal_Bonus'],
            'Crimson': v['CrimsonScripture_Damage']+v['CrimsonScripture_Ground'],
            'Siren': v['SirenTear_Damage'], 'Coil': v['ConstellationCoil_Damage']+4.,
            'Rhitta': v['Rhitta_Damage'], 'Shark': v['Shark_Trail_DamageBase'],
            'Raijin': v['Raijin_Wrath_Damage'], 'RedCup': v['RedCup_Damage'], 'RedFlower': v['RedFlower_DamageBase'],
        }
        for name, budget in budgets.items():
            self.assertGreater(budget, 0., name)
            limit = {'Anchor':6.75,'Crimson':8.,'Phoenix':6.5,'Coil':8.5}.get(name, 8. if name == 'Ember' else 6. if name in ('Shark','RedFlower') else 5.5 if name in ('Verdict','Bastion','Cinder','Mirror','Volt target','Phoenix') else 5.)
            self.assertLessEqual(budget, limit, name)

    def test_native_binary_ranges_have_engine_types_and_skillshots_hide_cursor_discs(self):
        docs, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
        # Read the serialized native records: editable values alone missed the
        # real/unreal type regression that produced zero cast distance in game.
        doc = next(d for d in docs if d['source_file'] == 'war3map.w3a')
        packed = raw.parse_object_file(raw.encode_object_file(doc, doc['source_file']),
                                       doc['source_file'], 'abilities', 'level', {})
        self.assertEqual([], native_field_errors([packed]))
        index = {objects.object_id(o): o for o in packed['custom_objects']}
        for aid, reach in DAMAGE_CAST_RANGES.items():
            mods = [m for m in index[aid]['modifications']
                    if m['field']['text'] == 'aran' and m.get('level') == 1]
            self.assertEqual(1, len(mods), aid)
            self.assertEqual(('unreal', reach), (mods[0]['type'], mods[0]['data']['value']), aid)
        for aid in SKILLSHOT_ABILITIES:
            options = next(m['data']['value'] for m in index[aid]['modifications']
                           if m['field']['text'] == 'Ncl3' and m.get('level') == 1)
            self.assertEqual(0, options & 2, aid)
            self.assertTrue(options & 1, aid)
        # A true area attack still has its cursor image and correct native area type.
        mods = {m['field']['text']: m for m in index['A06O']['modifications'] if m.get('level') == 1}
        self.assertEqual(('unreal', 450.), (mods['aare']['type'], mods['aare']['data']['value']))
        self.assertTrue(mods['Ncl3']['data']['value'] & 2)
        # The checker must catch the former error even when the numeric value matches.
        bad = next(m for m in index['A151']['modifications']
                   if m['field']['text'] == 'aran' and m.get('level') == 1)
        bad['type'] = 'real'
        self.assertIn(('A151', 'aran', 'real'), native_field_errors([packed]))

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
