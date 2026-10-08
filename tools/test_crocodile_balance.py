"""Execute MAIN balance paths, native data, and damage callbacks after a map pull."""
import unittest
import test_crocodile_main_integration as main
import war3_object_workspace as objects


class Balance(unittest.TestCase):
    def setUp(self):
        self.fixture = main.MainIntegration('runTest')
        self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)
        self.vm,self.c = self.fixture.vm,self.fixture.c
        self.vm.g.update({
            'EffectSpawnColor': self.vm.effect,
            'HeightSet': lambda u,t,h: setattr(u,'height',h),
        })

    def spell_damage_callbacks(self):
        def damage(c,u,amount):
            amount = self.vm.run('CrocodileG_OffensiveDamage',(c,u,amount))
            self.vm.damage.append((c,u,amount))
            self.vm.run('CrocodileG_AppliedSpellHit',(c,u,amount,1,False))
        self.vm.g['dmgphys'] = damage

    def test_e_capacity_uses_ability_rank_and_hero_level(self):
        a = self.c.abilities[self.vm.g['CrocodileE_ID']]
        for hero_level in (1,24,25,35):
            self.c.hero_level = hero_level
            for rank in range(1,6):
                a['level'] = rank
                expected = 3 if hero_level>=25 else 2 if rank>=3 else 1
                self.assertEqual(expected,self.vm.run('CrocodileE_MaxCharges',(self.c,)))
                self.fixture.step()
                self.assertEqual(str(expected),self.c.charge_ui)

    def test_e_reads_native_cooldown_at_each_rank_without_rewriting_it(self):
        a = self.c.abilities[self.vm.g['CrocodileE_ID']]
        e = self.fixture.state(1)
        for rank,cooldown in enumerate((18,16,14,12,10),1):
            a['level'] = rank
            e.charge1,e.charge2,e.charge3,e.useCooldown = 0,0,0,0
            self.assertTrue(self.vm.run('CrocodileE_Begin',(self.c,750,0)))
            self.assertEqual(cooldown,e.charge1)
            self.assertEqual(1.5,e.useCooldown) # User's edited use interval survives the map pull.
            self.assertIn('Avul',self.c.abilities)
            self.vm.run('CrocodileE_Finish',obj=e)
            self.assertNotIn('Avul',self.c.abilities)
        a['cooldowns'] = [7]*5
        e.charge1,e.charge2,e.charge3,e.useCooldown = 0,0,0,0
        self.assertTrue(self.vm.run('CrocodileE_Begin',(self.c,750,0)))
        self.assertEqual(7,e.charge1)

    def test_e_locked_slots_cannot_cast_and_upgrade_does_not_reset_used_charge(self):
        self.c.hero_level = 24
        self.assertTrue(self.vm.run('CrocodileE_Begin',(self.c,750,0)))
        self.fixture.step(51)
        e = self.fixture.state(1)
        first = e.charge1
        self.assertFalse(self.vm.run('CrocodileE_Begin',(self.c,1500,0)))
        self.c.abilities[self.vm.g['CrocodileE_ID']]['level'] = 3
        self.assertTrue(self.vm.run('CrocodileE_Begin',(self.c,1500,0)))
        self.assertEqual(first,e.charge1)
        self.assertEqual(14,e.charge2)
        self.fixture.step(51)
        self.assertFalse(self.vm.run('CrocodileE_Begin',(self.c,2250,0)))
        self.c.hero_level = 25
        self.assertTrue(self.vm.run('CrocodileE_Begin',(self.c,2250,0)))
        self.assertEqual(14,e.charge3)

    def test_q_native_mark_is_fixed_at_five_seconds_without_scaled_slow(self):
        for hero_level,mark_level in [(1,1),(24,1),(25,1),(34,1),(35,1),(45,1)]:
            self.c.hero_level = hero_level
            u = self.vm.unit(100)
            self.vm.run('CrocodileQ_ApplySandMark',(self.c,u))
            self.assertEqual(mark_level,self.fixture.buffs[-1][-1])
        self.fixture.step(166)
        self.assertIn(self.vm.g['CrocodileQ_SandMark_Buff_ID'],u.abilities)
        self.fixture.step(2)
        self.assertNotIn(self.vm.g['CrocodileQ_SandMark_Buff_ID'],u.abilities)
        self.assertEqual(0,self.fixture.state(7,u))

    def test_native_mark_data_keeps_every_level_and_duration(self):
        documents,_ = objects.prepare_documents(main.ROOT/'object-data',main.ROOT/'.object-data-raw')
        doc = next(d for d in documents if d['source_file']=='war3map.w3a')
        mark = next(o for o in doc['custom_objects'] if objects.object_id(o)=='A108')
        fields = {(m['field']['text'],m.get('level',0)):m['data']['value'] for m in mark['modifications']}
        self.assertEqual(1,fields['alev',0])
        for level,slow in enumerate((0.0,),1):
            self.assertAlmostEqual(slow,fields['Slo1',level])
            self.assertEqual(0,fields['Slo2',level])
            self.assertEqual(5,fields['adur',level])
            self.assertEqual(5,fields['ahdu',level])

    def test_w_six_pulses_and_combo_burn_at_most_four_times_per_target(self):
        self.spell_damage_callbacks()
        targets = [self.vm.unit(100),self.vm.unit(120)]
        self.vm.run('CrocodileW_Begin',(self.c,0,0))
        w = self.vm.structs['CrocodileW_Struct'].m[0]
        self.vm.run('CrocodileW_Combo',obj=w)
        self.fixture.step(130)
        for target in targets:
            self.assertEqual(7,len([d for c,u,d in self.vm.damage if u is target]))
            self.assertEqual(92,target.mana)
        self.assertFalse(self.vm.g['CrocodileDecorHits'])
        self.vm.run('CrocodileW_Begin',(self.c,0,0))
        self.fixture.step(130)
        self.assertTrue(all(t.mana==84 for t in targets))

    def test_w_rejected_final_hit_does_not_consume_mana_allowance(self):
        target = self.vm.unit(100)
        self.vm.run('CrocodileW_Begin',(self.c,0,0))
        w = self.vm.structs['CrocodileW_Struct'].m[0]
        def rejected(c,u,amount):
            self.vm.run('CrocodileG_AppliedSpellHit',(c,u,0,1,False))
        self.vm.g['dmgphys'] = rejected
        self.vm.run('CrocodileW_Combo',obj=w)
        self.assertEqual(100,target.mana)
        self.spell_damage_callbacks()
        self.fixture.step(130)
        self.assertEqual(92,target.mana)

    def test_t_uses_only_own_four_second_burn_and_t2_does_not_trigger_g(self):
        self.spell_damage_callbacks()
        target = self.vm.unit(10)
        self.fixture.begin_t()
        self.fixture.step(167)
        self.assertEqual(68,target.mana)
        self.assertTrue(self.vm.run('CrocodileT2_Begin',(self.c,)))
        self.fixture.step(17)
        self.assertEqual(68,target.mana)
        self.assertTrue(any(u is target for c,u,d in self.vm.damage))
        self.assertIsNone(self.vm.g['CrocodileG_ManaSource'])
        self.assertEqual(0,self.vm.g['CrocodileG_ManaContext'])

    def test_t_invulnerability_threshold_and_cleanup_preserve_external_avul(self):
        self.c.hero_level = 34
        self.fixture.begin_t()
        self.assertNotIn('Avul',self.c.abilities)
        self.vm.run('CrocodileT_Finish',(self.c,))
        self.c.hero_level = 35
        t = self.fixture.begin_t()
        self.assertTrue(t.invulnerabilityHeld)
        self.assertIn('Avul',self.c.abilities)
        self.fixture.step(167)
        self.assertNotIn('Avul',self.c.abilities)
        self.vm.run('CrocodileT_Finish',(self.c,))
        self.vm.add_ability(self.c,'Avul')
        self.fixture.begin_t()
        self.vm.run('CrocodileT_Finish',(self.c,))
        self.assertIn('Avul',self.c.abilities)

    def test_e_interrupted_by_t_transfers_invulnerability_without_leak(self):
        self.c.hero_level = 35
        self.fixture.use_main_dash_helpers()
        self.vm.run('CrocodileE_Begin',(self.c,750,0))
        self.assertIn('Avul',self.c.abilities)
        t = self.fixture.begin_t()
        self.assertFalse(self.fixture.state(1).active)
        self.assertFalse(self.c.paused)
        self.fixture.step(30)
        self.assertTrue(t.invulnerabilityHeld)
        self.assertIn('Avul',self.c.abilities)
        self.vm.run('CrocodileT_Finish',(self.c,))
        self.assertNotIn('Avul',self.c.abilities)

    def test_w_r_combo_adds_exactly_one_second_to_each_clock_once(self):
        self.vm.run('CrocodileW_Begin',(self.c,900,0))
        w = self.vm.structs['CrocodileW_Struct'].m[0]
        self.vm.run('CrocodileR_Begin',(self.c,4000,0))
        r = self.vm.structs['CrocodileR_Struct'].m[0]
        clocks = w.rmax,r.rmax
        self.fixture.step(27)
        self.assertTrue(r.stoppedByW)
        self.assertAlmostEqual(clocks[0]+1,w.rmax)
        self.assertAlmostEqual(clocks[1]+1,r.rmax)
        self.fixture.step(30)
        self.assertAlmostEqual(clocks[0]+1,w.rmax)
        self.assertAlmostEqual(clocks[1]+1,r.rmax)

    def test_q_reports_terminal_segment_before_its_struct_is_removed(self):
        self.vm.run('CrocodileW_Begin',(self.c,2510,0))
        self.vm.run('CrocodileQ_Begin',(self.c,1655,0))
        self.fixture.step(35)
        w = self.vm.structs['CrocodileW_Struct'].m[0]
        self.assertFalse(w.combo)
        # Make Q's final scan the only contact. Delay W's update until Q has
        # been removed, to prove that contact is explicitly recorded by Q.
        q = self.vm.structs['CrocodileQ_Struct'].m[0]
        self.assertEqual(1650,q.distance)
        w_type = self.vm.structs['CrocodileW_Struct']
        update = w_type.Loop_CrocodileW
        w_type.Loop_CrocodileW = lambda: None
        self.fixture.step(2)
        self.assertEqual(-1,self.vm.structs['CrocodileQ_Struct'].MUI)
        self.assertTrue(w.comboPending)
        w_type.Loop_CrocodileW = update
        update()
        self.assertTrue(w.combo)

    def test_w_r_t_apply_shared_mark_only_from_hero_level_thirty_five(self):
        for level in (34,35):
            for spell in ('W','R','T'):
                with self.subTest(level=level,spell=spell):
                    self.setUp()
                    self.c.hero_level = level
                    self.vm.unit(10)
                    if spell=='T':
                        self.fixture.begin_t()
                        self.fixture.step(35)
                    else:
                        self.vm.run('Crocodile'+spell+'_Begin',(self.c,0 if spell=='W' else 2000,0))
                        self.fixture.step(20)
                    marks = [b for b in self.fixture.buffs if b[3]==self.vm.g['CrocodileQ_SandMark_Ability_ID']]
                    self.assertEqual(level==35,bool(marks))
                    if level==35:
                        self.assertTrue(all(b[-1]==1 for b in marks))

    def test_any_ground_sand_slows_for_its_entire_life_and_reads_current_hero_level(self):
        target = self.vm.unit(200)
        for q_hit in (False,True):
            self.c.hero_level = 1
            self.vm.run('AddSand',(self.c,200,0,250,q_hit))
            self.fixture.step(220) # Beyond the old five-second Q-only window.
            self.assertEqual((self.c,target,10,1),self.vm.slows[-1])
            self.c.hero_level = 25
            self.fixture.step(20)
            self.assertEqual((self.c,target,20,1),self.vm.slows[-1])
            self.c.hero_level = 35
            self.fixture.step(20)
            self.assertEqual((self.c,target,30,1),self.vm.slows[-1])
            self.fixture.step(420)
            before = len(self.vm.slows)
            self.fixture.step(25)
            self.assertEqual(before,len(self.vm.slows))

    def test_t_ground_after_channel_uses_the_same_scaled_slow(self):
        self.c.hero_level = 35
        target = self.vm.unit(10)
        self.fixture.begin_t()
        self.fixture.step(40) # While T still owns its growing sand patches.
        self.assertEqual((self.c,target,30,1),self.vm.slows[-1])
        self.fixture.step(110) # After the four-second channel, before transfer.
        self.assertEqual((self.c,target,30,1),self.vm.slows[-1])
        self.fixture.step(100) # Transferred to the common sand structure.
        self.assertEqual((self.c,target,30,1),self.vm.slows[-1])

    def test_q_contact_slow_stays_thirty_percent_for_two_seconds_at_any_hero_level(self):
        for hero_level in (1,25,35):
            self.setUp()
            self.c.hero_level = hero_level
            target = self.vm.unit(100,100)
            self.vm.run('CrocodileQ_Begin',(self.c,1655,0))
            self.fixture.step(18)
            self.assertIn((self.c,target,30,2),self.vm.slows)


if __name__=='__main__':
    unittest.main()
