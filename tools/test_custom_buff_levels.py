"""Check the native tables against the real MAIN encoding and buff IDs."""
import re
import unittest
import repair_main_ability_levels as repair
import war3_object_workspace as workspace
from test_crocodile import JassState


class BuffLevels(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.documents,_ = workspace.prepare_documents(repair.ROOT/'object-data',repair.ROOT/'.object-data-raw')
        cls.a = repair.AbilityWorkspace(cls.documents)
        cls.systems = (repair.ROOT/'triggers/Systems/Systems1.j').read_text(encoding='utf-8-sig')

    def test_all_seventy_six_slow_ranks_match_the_actual_encoder(self):
        function = re.search(r'function GetSlowAbilityLevel takes.*?endfunction',self.systems,re.S)[0]
        vm = JassState(function)
        for percent in range(5,100,5):
            for duration in range(1,5):
                level = vm.run('GetSlowAbilityLevel',(percent,duration))
                for field in ('Slo1','Slo2'):
                    self.assertAlmostEqual(percent/100,self.a.get('A1OT',field,level),places=6)
                for field in ('adur','ahdu'):
                    self.assertEqual(duration,self.a.get('A1OT',field,level))
                self.assertEqual(0,self.a.get('A1OT','amcs',level))
                self.assertEqual(0,self.a.get('A1OT','acdn',level))

    def test_cc_durations_match_real_wrappers_including_last_rank_and_nonheroes(self):
        for function,identity,step in [('StunUnit','A1OA',.1),('DoomUnit','A1QY',.5),('RootUnit','APPP',.25),('SilenceUnit','A01V',.5)]:
            body = re.search(r'function '+function+r' takes.*?endfunction',self.systems,re.S)[0]
            encoding = re.search(r'\blevel\s*=\s*R2I\((.*?)\)',body)[1]
            for rank in range(1,self.a.get(identity,'alev',0,1)+1):
                time = rank*step
                value = eval(encoding,{'time':time})
                self.assertAlmostEqual(rank,value)
                for field in ('adur','ahdu'):
                    self.assertAlmostEqual(time,self.a.get(identity,field,rank),places=5)
                if identity=='APPP':
                    self.assertEqual(0,self.a.get(identity,'Eer1',rank))
                if identity=='A1QY':
                    self.assertEqual(0,self.a.get(identity,'Ndo1',rank))
                    self.assertEqual('',self.a.get(identity,'Ndou',rank))

    def test_patrior_offensive_buffs_match_damage_hooks_without_native_armor(self):
        for rank,buff in enumerate(('B01Y','B021','B022','B023','B024'),6):
            self.assertEqual(buff,self.a.get('A0EG','abuf',rank))
            self.assertEqual(0,self.a.get('A0EG','Inf2',rank))
            self.assertEqual(-(rank-5)*5,self.a.get('A0EG','Inf4',rank))
            self.assertIn(f"= '{buff}'",(repair.ROOT/'triggers/Heroes/Patriot.j').read_text(encoding='utf-8-sig'))

    def test_inori_and_ainz_do_not_inherit_empty_or_standard_high_ranks(self):
        for rank in range(1,10):
            self.assertEqual('B00K',self.a.get('A06G','abuf',rank))
            self.assertEqual(15,self.a.get('A06G','adur',rank))
            self.assertEqual(0,self.a.get('A06G','',rank))
        self.assertEqual(0,self.a.get('A0FW','Blo2',8))
        for rank in range(1,9):
            for field in ('Blo1','Blo3'):
                self.assertEqual(0,self.a.get('A0FW',field,rank))

    def test_variant_registries_have_no_declared_empty_effect_ranks(self):
        for identity in ('A1OB','A1P1','A03T','A0D1','A0E6','A07D','A0EG','A0FW'):
            for rank in range(1,self.a.get(identity,'alev',0,1)+1):
                self.assertTrue(self.a.get(identity,'abuf',rank),(identity,rank))
                for field in ('adur','ahdu','aran','amcs','acdn'):
                    self.assertIsNotNone(self.a.get(identity,field,rank),(identity,field,rank))

    def test_buff_fields_are_not_duplicated_or_leveled(self):
        for doc in self.documents:
            if doc['kind']=='buffs':
                for obj in doc['original_objects']+doc['custom_objects']:
                    fields = [m['field']['hex'] for m in obj['modifications']]
                    self.assertEqual(len(fields),len(set(fields)))
                    self.assertTrue(all('level' not in m for m in obj['modifications']))

    def test_high_rank_dummy_tooltips_describe_configured_effects(self):
        for identity,rank,fragment in [('A1OA',30,'3 sec'),('APPP',30,'7.5 sec'),('A1QY',30,'15 sec'),('A1P1',15,'Brandish'),('A1OT',76,'95%')]:
            self.assertIn(fragment,self.a.get(identity,'aub1',rank))


if __name__=='__main__':
    unittest.main()
