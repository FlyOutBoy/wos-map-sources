"""Regression checks for repaired MAIN objects and executable tooltip formulas."""
import copy
import unittest

import repair_main_ability_levels as repair
import war3_object_data as raw
import war3_object_workspace as workspace


class MainAbilityLevels(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.documents,_ = workspace.prepare_documents(repair.ROOT/'object-data',repair.ROOT/'.object-data-raw')
        cls.fields = repair.AbilityWorkspace(cls.documents)
        cls.vm,cls.records = repair.tooltip_vm()

    def test_every_channel_explicitly_disables_other_abilities_flag_at_every_level(self):
        count = 0
        for identity in self.fields.objects:
            mods = self.fields.fields(identity)
            if self.fields.objects[identity][0]['old_id'].get('text')=='ANcl' or any(f.startswith('Ncl') for f,l in mods):
                count += 1
                for level in range(1,self.fields.get(identity,'alev',0,1)+1):
                    with self.subTest(identity=identity,level=level):
                        self.assertEqual(0,self.fields.get(identity,'Ncl5',level))
        self.assertGreater(count,190)

    def test_all_present_lower_level_fields_have_level_four_and_five(self):
        for identity in self.fields.objects:
            if self.fields.get(identity,'alev',0,1)>=5:
                mods = self.fields.fields(identity)
                for field in {f for f,l in mods if f and 0<l<=3}:
                    with self.subTest(identity=identity,field=field):
                        self.assertIn((field,4),mods)
                        self.assertIn((field,5),mods)

    def test_crocodile_w_has_static_learn_preview_and_rank_four_five_damage_cd_range(self):
        learned = self.fields.get('A0I8','arut')
        for text in ('quicksand','Agility x 0.75','1200','22/21/20/19/18','Hits:|r 6'):
            self.assertIn(text,learned)
        for level,cd in ((4,19),(5,18)):
            desc = self.fields.get('A0I8','aub1',level)
            self.assertIn(f'CD:|r {cd} sec',desc)
            self.assertIn('Range:|r 1200',desc)
            self.assertNotIn('Tool tip missing',desc)

    def test_crocodile_q_e_scaling_and_e_uses_actual_charge_cooldown(self):
        for identity,amounts in [('A0I7',(4,5)),('A0I9',(3.5,4))]:
            for level,amount in zip((4,5),amounts):
                self.assertIn(f'Agility x {amount}',self.fields.get(identity,'aub1',level))
        for level, cooldown in enumerate((18,16,14,12,10),1):
            self.assertEqual(cooldown,self.fields.get('A0I9','acdn',level))
        self.assertIn('five physical damage pulses that split its total damage',self.fields.get('A0I9','arut'))

    def test_range_progression_is_retained_for_crocodile_r(self):
        self.assertIn('1200/1300/1400/1500/1600',self.fields.get('A0IA','arut'))
        self.assertIn('Range:|r 1500',self.fields.get('A0IA','aub1',4))
        self.assertIn('Range:|r 1600',self.fields.get('A0IA','aub1',5))

    def test_all_registered_skills_have_persisted_learn_and_normal_fallbacks(self):
        for identity in {r.identity for r in self.records}:
            with self.subTest(identity=identity):
                self.assertTrue(self.fields.get(identity,'arut'))
                self.assertNotIn('Tool tip missing',self.fields.get(identity,'arut'))
                self.assertTrue(self.fields.get(identity,'aub1',1))

    def test_live_descriptions_strip_static_stats_without_losing_lore(self):
        baked = self.fields.get('A0I8','aub1',5)
        lore = self.vm.run('LoreOnly',(baked,))
        self.assertIn('quicksand',lore)
        self.assertNotIn('CD:',lore)
        self.assertNotIn('Ability Stats:',lore)
        self.assertEqual(lore,self.vm.run('LoreOnly',(lore,)))

    def test_linear_progression_restores_holes_but_preserves_explicit_rank_five(self):
        objects = copy.deepcopy(self.documents)
        fields = repair.AbilityWorkspace(objects)
        fields.put('A0I8','acdn',1,22)
        fields.put('A0I8','acdn',2,21)
        fields.put('A0I8','acdn',3,20)
        for obj in fields.objects['A0I8']:
            obj['modifications'] = [m for m in obj['modifications'] if not (m['field']['text']=='acdn' and m.get('level') in (4,5))]
        fields.repair_levels([])
        self.assertEqual(19,fields.get('A0I8','acdn',4))
        self.assertEqual(18,fields.get('A0I8','acdn',5))
        fields.put('A0I8','acdn',5,12)
        fields.repair_levels([])
        self.assertEqual(12,fields.get('A0I8','acdn',5))

    def test_binary_ability_roundtrip_is_lossless(self):
        for doc in self.documents:
            if doc['kind']=='abilities':
                encoded = raw.encode_object_file(doc,doc['source_file'])
                decoded = raw.parse_object_file(encoded,doc['source_file'],'abilities','level',{})
                self.assertEqual(encoded,raw.encode_object_file(decoded,doc['source_file']))

    def test_every_declared_rank_has_every_configured_level_field(self):
        count = 0
        for identity in self.fields.objects:
            levels = self.fields.get(identity,'alev',0,1)
            if levels<=1:
                continue
            count += 1
            mods = self.fields.fields(identity)
            for field in {f for f,l in mods if 0<l<=levels}:
                for level in range(1,levels+1):
                    with self.subTest(identity=identity,field=field,level=level):
                        self.assertIn((field,level),mods)
        self.assertGreaterEqual(count,241)

    def test_all_rank_repair_is_idempotent(self):
        fields = repair.AbilityWorkspace(copy.deepcopy(self.documents))
        fields.repair_levels([])
        self.assertEqual([],fields.unresolved)
        self.assertEqual([],fields.changes)

    def test_first_and_middle_rank_holes_follow_affine_or_cc_contract(self):
        fields = repair.AbilityWorkspace(copy.deepcopy(self.documents))
        removed = [('A023','aran',1),('A02K','Idef',1),('A1OA','ahdu',30),
                   ('APPP','ahdu',14),('A1OT','adur',41),('A1OT','Slo1',41)]
        before = {(i,f,l):fields.get(i,f,l) for i,f,l in removed}
        for identity,field,level in removed:
            for obj in fields.objects[identity]:
                obj['modifications'] = [m for m in obj['modifications']
                    if (m['field']['text'],m.get('level'))!=(field,level)]
        fields.repair_levels([])
        self.assertEqual([],fields.unresolved)
        for identity,field,level in removed:
            self.assertAlmostEqual(before[(identity,field,level)],fields.get(identity,field,level),places=5)

    def test_variant_table_is_not_extrapolated_when_evidence_is_non_linear(self):
        fields = repair.AbilityWorkspace(copy.deepcopy(self.documents))
        for obj in fields.objects['A0EG']:
            obj['modifications'] = [m for m in obj['modifications']
                if (m['field']['text'],m.get('level'))!=('Inf4',8)]
        fields.repair_levels([])
        self.assertIn(('A0EG','Inf4',8),fields.unresolved)
        self.assertIsNone(fields.get('A0EG','Inf4',8))


if __name__=='__main__':
    unittest.main()
