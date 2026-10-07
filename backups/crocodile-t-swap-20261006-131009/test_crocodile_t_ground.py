"""Exercise TEST T/T2's actual vJASS, including the shared SwapAbility timer."""
import json
import math
import unittest
import test_crocodile_channel as channel
from test_crocodile_channel import ROOT, SOURCE


class GroundTests(unittest.TestCase):
    def setUp(self):
        self.fixture = channel.ContactAndChannelTests(methodName='runTest')
        self.fixture.setUp()
        self.vm, self.c = self.fixture.vm, self.fixture.c
        self.registered_clock_users = self.vm.clock_users
        self.step, self.state = self.fixture.step, self.fixture.state
        self.vm.structs['CrocodileT2_Struct'].statics['cluster'] = [0]*32
        self.order_reads = 0
        self.sounds = []
        self.vm.g.update({
            'ModuloInteger': lambda a,b:a%b,
            'SetUnitAnimationByIndex': lambda u,a:setattr(u,'animation',a),
            'SetUnitAnimation': lambda u,a:setattr(u,'animation',a),
            'GetUnitCurrentOrder': self.order,
            'BlzSetSpecialEffectZ': lambda e,z:setattr(e,'z',z),
            'MakeSound': self.sound,
        })
        routing = (ROOT/'test_map/base/Systems/CastCheck.j').read_text(encoding='utf-8-sig')
        start = routing.index('    if GetUnitTypeId(c) == Crocodile_ID')
        end = routing.index('    endif // shared dispatch',start)
        end = routing.rfind('    endif\n',start,end)
        body = '    local integer check = 0\n'+routing[start:end]+'    return check == 1'
        self.vm.text += '\nmethod Test_CrocodileCast takes unit c, integer id, real x, real y returns boolean\n'+body+'\nendmethod\n'
        self.vm.methods['Test_CrocodileCast'] = body

    def order(self, unit):
        self.order_reads += 1
        return getattr(unit,'order',0)

    def sound(self,name):
        ground=self.state(4)
        self.sounds.append((name,ground.r if ground else None))

    def detonate(self,unit=None):
        self.assertTrue(self.vm.run('CrocodileT2_Begin',(unit or self.c,)))
        self.step(17)

    def start(self):
        self.c.order = self.fixture.orders['ambush']
        self.assertTrue(self.vm.run('Test_CrocodileCast',(self.c,self.vm.g['CrocodileT_ID'],0.,0.)))
        return self.state(4)

    def patches(self,ground):
        patches=[]
        p=ground.patchHead
        while p != 0:
            patches.append(p)
            p=p.next
        return patches

    def explosions(self):
        return [e for e in self.vm.effect_history if 'wos_newdirtexnofire' in e.model]

    def ready(self):
        ground=self.start()
        self.step(100)
        self.assertFalse(ground.spreading)
        return ground

    def four(self):
        ground=self.start()
        for p in self.patches(ground):
            p.CrocodileTSand_Release(True)
        ground.patchHead=ground.growthHead=0
        ground.patchCount=0
        ground.maxReach=0.
        for x,y in [(-150.,-150.),(150.,-150.),(-150.,150.),(150.,150.)]:
            ground.CrocodileT_AddPatch(x,y,250./150.,0.)
        ground.r=3.
        ground.CrocodileT_EndSpread()
        return ground

    def test_cast_order_aura_animation_delayed_and_order_check_only_during_spread(self):
        self.c.order=self.fixture.orders['move']
        self.assertFalse(self.vm.run('Test_CrocodileCast',(self.c,self.vm.g['CrocodileT_ID'],0.,0.)))
        self.assertEqual(0,self.state(4))
        self.assertEqual(0,self.state(2).stacks)
        ground=self.start()
        self.assertNotEqual(11,getattr(self.c,'animation',None))
        self.assertEqual(('war3mapImported\\wos_AjeelAura2.mdl',self.c,'origin'),self.fixture.attachments[-1])
        self.assertFalse(self.c.paused)
        self.assertEqual(1,self.state(2).stacks)
        count=self.order_reads
        self.c.animation='spell' # Native Channel animation after the cast-event callback.
        self.c.timescale=.4
        self.step()
        self.assertEqual(11,self.c.animation)
        self.assertEqual(1.35,self.c.timescale)
        self.step(99)
        self.assertEqual(count+100,self.order_reads)
        self.assertIsNone(ground.aura)
        self.assertEqual('stand',self.c.animation)
        self.assertEqual(0,self.state(8))
        reads=self.order_reads
        self.step(10)
        self.assertEqual(reads,self.order_reads)

    def test_animation_waits_point_zero_three_seconds_from_cast_with_shared_timer_offset(self):
        self.vm.elapsed=.025
        ground=self.start()
        self.c.animation='spell'
        self.vm.elapsed=0.
        self.step()
        self.assertAlmostEqual(.005,ground.r)
        self.assertEqual('spell',self.c.animation)
        self.assertFalse(ground.animationApplied)
        self.step()
        self.assertAlmostEqual(.035,ground.r)
        self.assertEqual(11,self.c.animation)
        self.assertTrue(ground.animationApplied)

    def test_t2_window_lasts_ten_seconds_after_spread_with_shared_timer_offset(self):
        self.vm.elapsed=.025
        ground=self.start()
        self.vm.elapsed=0.
        self.step(101)
        self.assertFalse(ground.spreading)
        self.assertAlmostEqual(ground.r+10.,ground.endTime)
        self.step(333)
        self.assertIs(self.state(4),ground)
        self.step()
        self.assertEqual(0,self.state(4))

    def test_loop_else_cancels_when_current_order_changes_without_order_event(self):
        ground=self.start()
        self.step(10)
        effects=[w.e for w in self.waves(ground)]+[p.e for p in self.patches(ground)]+[ground.aura]
        self.c.order=self.fixture.orders['move']
        self.step()
        self.assertEqual(0,self.state(4))
        self.assertFalse(ground.alive)
        self.assertTrue(all(id(e) not in self.vm.effects for e in effects))
        self.assertEqual('stand',self.c.animation)

    def test_wave_density_growth_radius_and_no_unit_scans(self):
        ground=self.start()
        center=self.patches(ground)[0]
        initial=center.e.scale
        self.step(5)
        self.assertGreater(center.e.scale,initial)
        self.step(28)
        first_count=ground.patchCount
        self.step(33)
        second_count=ground.patchCount
        self.step(34)
        patches=self.patches(ground)
        self.assertLess(first_count,second_count)
        self.assertLess(second_count,len(patches))
        self.assertEqual(135,len(patches))
        self.assertAlmostEqual(2100.,ground.maxReach)
        self.assertEqual(0,ground.growthHead)
        self.assertEqual([],self.vm.scan_calls)
        rings={}
        for p in patches:
            radius=round(math.hypot(p.x-ground.x,p.y-ground.y),2)
            rings.setdefault(radius,[]).append(p)
            self.assertAlmostEqual(p.radius/165.*1.4,p.e.scale)
            self.assertEqual('war3mapImported\\wos_ysjsm45.mdl',p.e.model)
            self.assertEqual(128,p.e.alpha)
        self.assertEqual(sorted(map(len,rings.values())),[1,7,13,19,26,32,37])
        for i,p in enumerate(patches):
            for q in patches[i+1:]:
                self.assertGreaterEqual(math.hypot(p.x-q.x,p.y-q.y)+.001,180.)
        self.assertGreater(rings[max(rings)][0].targetScale,rings[0.][0].targetScale)

    def waves(self,ground):
        waves=[]
        wave=ground.waveHead
        while wave != 0:
            waves.append(wave)
            wave=wave.next
        return waves

    def test_front_effects_move_outward_from_caster_and_are_reused_for_entire_spread(self):
        self.c.x,self.c.y=800.,400.
        ground=self.start()
        waves=self.waves(ground)
        effects=[w.e for w in waves]
        self.assertEqual(24,len(waves))
        self.assertTrue(all((e.x,e.y)==(800.,400.) for e in effects))
        self.assertTrue(all('CrocodileSanding3' in e.model for e in effects))
        self.step(25)
        first_scale=effects[0].scale
        for e in effects:
            self.assertAlmostEqual(ground.outerRadius*.25,math.hypot(e.x-800.,e.y-400.))
        self.step(25)
        self.assertGreater(effects[0].scale,first_scale)
        for e in effects:
            self.assertAlmostEqual(ground.outerRadius*.5,math.hypot(e.x-800.,e.y-400.))
        self.step(50)
        self.assertEqual(0,ground.waveHead)
        for w,e in zip(waves,effects):
            self.assertFalse(w.alive)
            self.assertAlmostEqual(ground.outerRadius,math.hypot(e.x-800.,e.y-400.))
            self.assertAlmostEqual(2.6,e.scale)
        self.assertEqual(24,sum('CrocodileSanding3' in e.model for e in self.vm.effect_history))
        self.assertEqual(135,sum('wos_ysjsm45' in e.model for e in self.vm.effect_history))
        self.step(16)
        self.assertTrue(all(id(e) not in self.vm.effects for e in effects))
        self.assertEqual([],self.vm.scan_calls)

    def issue_order(self,unit,order):
        self.vm.g.update({'GetTriggerUnit':lambda:unit,'GetIssuedOrderId':lambda:self.fixture.orders[order]})
        self.vm.run('CrocodileT_OnOrder')

    def channel_event(self,event,ability=None):
        self.vm.g.update({'GetTriggerUnit':lambda:self.c,
            'GetSpellAbilityId':lambda:ability or self.vm.g['CrocodileT_ID'],
            'GetTriggerEventId':lambda:event,
            'EVENT_PLAYER_UNIT_SPELL_FINISH':'finish'})
        self.vm.run('CrocodileT_OnChannelEvent')

    def test_stop_move_and_target_orders_cancel_only_spreading_caster_and_clean_effects(self):
        for order in ('stop','move','attack','enemychannel'):
            with self.subTest(order=order):
                self.setUp()
                ground=self.start()
                self.step(20)
                effects=[w.e for w in self.waves(ground)]+[p.e for p in self.patches(ground)]+[ground.aura]
                other=self.vm.unit(200,0)
                self.issue_order(other,order)
                self.assertIs(self.state(4),ground)
                self.issue_order(self.c,'ambush')
                self.assertIs(self.state(4),ground)
                self.issue_order(self.c,order)
                self.assertEqual(0,self.state(4))
                self.assertEqual(0,self.state(8))
                self.assertTrue(all(id(e) not in self.vm.effects for e in effects))
                self.assertEqual('stand',self.c.animation)
                self.assertFalse(self.c.paused)
                self.assertNotIn(self.vm.g['CrocodileT2_ID'],self.c.abilities)
                self.step()
                self.assertFalse(ground.alive)
                self.assertEqual(self.registered_clock_users,self.vm.clock_users)

    def test_endcast_without_finish_cancels_even_just_before_final_tick(self):
        ground=self.start()
        self.step(99)
        self.channel_event('end',self.vm.g['CrocodileQ_ID'])
        self.assertIs(self.state(4),ground)
        self.c.order=self.fixture.orders['stop']
        self.channel_event('end')
        self.assertEqual(0,self.state(4))
        self.step()
        self.assertFalse(ground.alive)
        self.assertNotIn(self.vm.g['CrocodileT2_ID'],self.c.abilities)

    def test_normal_finish_then_endcast_opens_window_and_later_orders_preserve_sand(self):
        ground=self.start()
        self.step(99)
        self.channel_event('finish')
        self.channel_event('end')
        self.issue_order(self.c,'stop')
        self.assertIs(self.state(4),ground)
        self.step()
        self.assertFalse(ground.spreading)
        self.issue_order(self.c,'move')
        self.assertIs(self.state(4),ground)
        self.assertIn(self.vm.g['CrocodileT2_ID'],self.c.abilities)

    def test_window_and_visibility_follow_any_sand_with_fresh_cast_check(self):
        ground=self.start()
        self.assertFalse(self.vm.run('CrocodileT2_Begin',(self.c,)))
        self.step(99)
        self.assertNotIn(self.vm.g['CrocodileT2_ID'],self.c.abilities)
        self.step()
        t,t2=self.vm.g['CrocodileT_ID'],self.vm.g['CrocodileT2_ID']
        self.assertIn(t2,self.c.abilities)
        self.assertTrue(self.c.disabled[('hidden',t)])
        self.assertFalse(self.c.disabled[('hidden',t2)])
        self.c.x=3000.
        self.step(5)
        self.assertTrue(self.c.disabled[('hidden',t2)])
        self.assertFalse(self.vm.run('CrocodileT2_Begin',(self.c,)))
        self.vm.run('AddSand',(self.c,3000.,0.,250.,False))
        self.step(5)
        self.assertFalse(self.c.disabled[('hidden',t2)])
        self.c.x=4000. # Moving after visibility refresh cannot bypass the cast-time check.
        self.assertFalse(self.vm.run('CrocodileT2_Begin',(self.c,)))
        self.c.x=3000.
        self.assertTrue(self.vm.run('CrocodileT2_Begin',(self.c,)))
        self.assertFalse(self.vm.run('CrocodileT2_Begin',(self.c,)))
        self.step(17)
        self.assertNotIn(t2,self.c.abilities)
        self.assertFalse(self.c.disabled[('hidden',t)])
        self.assertEqual(0,self.state(4))

    def test_four_patch_visual_geometry_and_exact_once_union_damage(self):
        ground=self.four()
        patches=self.patches(ground)
        overlap=self.vm.unit(0,0)
        edge=self.vm.unit(390,150)
        other_edge=self.vm.unit(-390,-150)
        empty_bounding_area=self.vm.unit(0,450)
        ally=self.vm.unit(0,0,owner=0)
        structure=self.vm.unit(0,0)
        dead=self.vm.unit(0,0)
        dead.life=0
        self.fixture.structures.add(id(structure))
        self.detonate()
        effects=self.explosions()
        self.assertEqual(1,len(effects))
        effect=effects[0]
        self.assertAlmostEqual(0.,effect.x)
        self.assertAlmostEqual(0.,effect.y)
        expected=math.hypot(150,150)+250
        base=self.vm.g['CrocodileT2_ExplosionBaseRadius']
        scale=self.vm.g['CrocodileT2_ExplosionScale']
        self.assertAlmostEqual(expected/base*scale,effect.scale)
        self.assertGreater(effect.scale,(250/base)*scale*1.8)
        for p in patches:
            self.assertGreaterEqual(effect.scale*base/scale+.001,math.hypot(effect.x-p.x,effect.y-p.y)+p.radius)
            self.assertFalse(p.alive)
        for target in (overlap,edge,other_edge):
            self.assertEqual([1700.],[d for _,u,d in self.vm.damage if u is target])
        for target in (empty_bounding_area,ally,structure,dead):
            self.assertFalse(any(u is target for _,u,_ in self.vm.damage))
        self.assertEqual(1,len(self.vm.scan_calls))
        self.assertEqual(set(),self.vm.groups)
        self.step(35)
        self.assertNotIn(id(effect),self.vm.effects)

    def test_close_chain_does_not_merge_far_apart_ends(self):
        ground=self.start()
        for p in self.patches(ground):
            p.CrocodileTSand_Release(True)
        ground.patchHead=ground.growthHead=0
        ground.patchCount=0
        for x in (0.,300.,600.):
            ground.CrocodileT_AddPatch(x,0.,250./150.,0.)
        ground.r=3.
        ground.CrocodileT_EndSpread()
        self.detonate()
        self.assertEqual(2,len(self.explosions()))

    def test_natural_expiry_keeps_all_patches_ten_more_seconds_then_fades(self):
        ground=self.ready()
        patches=self.patches(ground)
        effects=[p.e for p in patches]
        self.step(333)
        self.assertNotEqual(0,self.state(4))
        self.assertTrue(all(id(e) in self.vm.effects for e in effects))
        self.step()
        self.assertEqual(0,self.state(4))
        self.assertFalse(ground.alive)
        self.assertTrue(all(not p.alive for p in patches))
        for e in effects:
            self.assertTrue(any(entry[0] is e and entry[-1]==.8 for entry in self.vm.fade_history))
        self.step(28)
        self.assertTrue(all(id(e) not in self.vm.effects for e in effects))
        self.assertFalse(self.vm.run('CrocodileT2_Begin',(self.c,)))
        self.assertEqual(-1,self.vm.structs['KS_SpellTimer'].MUI_6)
        self.assertEqual(self.registered_clock_users,self.vm.clock_users)

    def test_death_removal_cleanup_both_spread_and_window(self):
        for phase in (10,100):
            for ending in ('death','removed'):
                with self.subTest(phase=phase,ending=ending):
                    self.setUp()
                    ground=self.start()
                    self.step(phase)
                    effects=[p.e for p in self.patches(ground)]
                    if ending=='death':
                        self.c.life=0
                        self.vm.run('Death',(self.c,))
                    else:
                        self.c.type=0
                    self.step(2)
                    self.assertEqual(0,self.state(4))
                    self.assertFalse(ground.alive)
                    self.assertTrue(all(id(e) not in self.vm.effects for e in effects))
                    self.assertIsNone(ground.aura)
                    self.assertNotIn(self.vm.g['CrocodileT2_ID'],self.c.abilities)
                    self.assertFalse(self.c.paused)

    def test_other_sand_allows_cast_but_is_not_detonated(self):
        ground=self.ready()
        other=self.vm.unit(4000,0,owner=0)
        other.type=self.c.type
        self.vm.hero(other)
        self.vm.run('AddSand',(other,4000.,0.,250.,False))
        common=self.vm.structs['CrocodileSand_Struct'].m[0]
        untouched=common.e
        self.c.x=4000.
        self.detonate()
        self.assertTrue(common.alive)
        self.assertFalse(common.endNow)
        self.assertIn(id(untouched),self.vm.effects)
        self.assertEqual(0,ground.patchCount)

    def test_same_player_crocodiles_keep_separate_ground_and_swap_cleanup(self):
        first=self.ready()
        other=self.vm.unit(4000,0,owner=0)
        other.type=self.c.type
        other.order=self.fixture.orders['ambush']
        self.vm.hero(other)
        self.vm.add_ability(other,self.vm.g['CrocodileT_ID'])
        self.assertTrue(self.vm.run('CrocodileT_Begin',(other,)))
        second=self.vm.g['LoadInteger'](self.vm.g['CrocodileTable'],id(other),4)
        self.step(100)
        second_effects=[p.e for p in self.patches(second)]
        target=self.vm.unit(4000,0,owner=1)
        self.c.x=4000.
        self.detonate()
        self.assertFalse(any(u is target for _,u,_ in self.vm.damage))
        self.step(2) # Shared SwapAbility's cleanup of the first cast.
        t2=self.vm.g['CrocodileT2_ID']
        self.assertTrue(self.fixture.available[(0,t2)])
        self.assertIn(t2,other.abilities)
        self.assertTrue(all(id(e) in self.vm.effects for e in second_effects))
        self.detonate(other)
        self.assertEqual([1700.],[d for _,u,d in self.vm.damage if u is target])

    def test_damage_callback_sees_detached_cast_and_can_recast(self):
        old=self.four()
        self.vm.unit(0,0)
        original=self.vm.g['dmgphys']
        def damage(c,u,d):
            self.assertEqual(0,self.state(4))
            self.assertEqual(0,old.patchHead)
            self.assertTrue(self.vm.run('CrocodileT_Begin',(c,)))
            original(c,u,d)
        self.vm.g['dmgphys']=damage
        self.detonate()
        self.assertIsNot(self.state(4),old)
        self.step(100)
        self.assertFalse(self.state(4).spreading)

    def test_other_abilities_unlock_after_spread_without_losing_t_window(self):
        ground=self.start()
        self.assertFalse(self.vm.run('CrocodileQ_Begin',(self.c,900.,0.)))
        self.step(100)
        self.assertTrue(self.vm.run('CrocodileQ_Begin',(self.c,900.,0.)))
        self.assertIs(self.state(4),ground)

    def test_native_channel_data_matches_three_second_spread(self):
        objects=json.loads((ROOT/'test_map/object-data/abilities.json').read_text(encoding='utf-8-sig'))
        self.assertEqual('',objects['A004']['animation_names'])
        for level in range(1,6):
            for code,order,duration in [('A004','ambush',3.),('A015','eattree',0.)]:
                a=objects[code]
                self.assertEqual(order,a[f'base_order_id level {level}'])
                self.assertEqual(duration,a[f'follow_through_time level {level}'])
                self.assertEqual('None',a[f'target_type level {level}'])
                self.assertEqual(0,a[f'field_Ncl5 level {level}'])

    def test_t_sounds_and_animation_speed_follow_cast_timeline(self):
        self.start()
        self.assertEqual([('war3mapImported\\Hero_Crocodile_T_1',0.)]*2,self.sounds)
        self.step(33)
        self.assertEqual(1.35,self.c.timescale)
        self.assertFalse(any(name.endswith('_T_2') for name,_ in self.sounds))
        self.step()
        self.assertEqual([1.02],[t for name,t in self.sounds if name.endswith('_T_2')])
        self.step(16)
        self.assertEqual([1.5],[t for name,t in self.sounds if name.endswith('_T_3')])
        self.step(50)
        self.assertEqual([1.5,3.],[t for name,t in self.sounds if name.endswith('_T_3')])
        self.assertEqual(1.,self.c.timescale)
        self.step(50)
        self.assertEqual([1.5,3.],[t for name,t in self.sounds if name.endswith('_T_3')])

    def test_t2_half_second_windup_sounds_pause_and_targets_at_detonation(self):
        ground=self.ready()
        target=self.vm.unit(3000,0)
        self.assertTrue(self.vm.run('CrocodileT2_Begin',(self.c,)))
        self.assertTrue(self.c.paused)
        self.assertTrue(ground.t2Pending)
        self.assertEqual('war3mapImported\\Hero_Crocodile_T2_1',self.sounds[-1][0])
        self.assertFalse(self.vm.run('CrocodileT2_Begin',(self.c,)))
        self.assertFalse(self.vm.run('CrocodileQ_Begin',(self.c,750.,0.)))
        self.step(16)
        self.assertEqual([],self.vm.damage)
        self.assertEqual([],self.explosions())
        self.assertTrue(self.c.paused)
        target.x=0.
        self.step()
        self.assertEqual([1700.],[d for _,u,d in self.vm.damage if u is target])
        self.assertEqual('war3mapImported\\Hero_Crocodile_T2_2',self.sounds[-1][0])
        self.assertAlmostEqual(3.51,self.sounds[-1][1])
        self.assertFalse(self.c.paused)
        self.assertEqual(0,self.state(4))
        self.assertEqual(0,self.state(8))

    def test_t2_delay_measured_from_press_with_shared_timer_offset(self):
        self.ready()
        self.vm.elapsed=.025
        self.assertTrue(self.vm.run('CrocodileT2_Begin',(self.c,)))
        self.vm.elapsed=0.
        self.step(17)
        self.assertEqual([],self.explosions())
        self.assertTrue(self.c.paused)
        self.step()
        self.assertTrue(self.explosions())
        self.assertFalse(self.c.paused)

    def test_t2_consumes_all_owned_sand_immediately_including_outside_t_and_deduplicates_hits(self):
        ground=self.ready()
        effects=[p.e for p in self.patches(ground)]
        for x,radius in [(3000.,350.),(3300.,350.),(4000.,250.),(4500.,250.)]:
            self.vm.run('AddSand',(self.c,x,0.,radius,False))
        common=self.vm.structs['CrocodileSand_Struct']
        owned=[common.m[i] for i in range(common.MUI+1)]
        effects += [s.e for s in owned]
        other=self.vm.unit(4000.,650.,owner=0)
        other.type=self.c.type
        self.vm.hero(other)
        self.vm.run('AddSand',(other,4000.,650.,250.,False))
        foreign=common.m[common.MUI]
        foreign_effect=foreign.e
        overlap=self.vm.unit(3150.,0.)
        far=self.vm.unit(4600.,0.)
        foreign_target=self.vm.unit(4000.,650.)
        self.detonate()
        for target in (overlap,far):
            self.assertEqual([1700.],[d for _,u,d in self.vm.damage if u is target])
        self.assertFalse(any(u is foreign_target for _,u,_ in self.vm.damage))
        for e in effects:
            self.assertNotIn(id(e),self.vm.effects)
            self.assertEqual(0.,e.scale)
            self.assertEqual(0,e.alpha)
            self.assertEqual(-10000.,e.z)
            self.assertFalse(any(entry[0] is e for entry in self.vm.fade_history))
        self.assertTrue(all(not s.alive for s in owned))
        self.assertTrue(foreign.alive)
        self.assertIn(id(foreign_effect),self.vm.effects)
        self.assertEqual(1,common.MUI+1)

    def test_cancel_retry_ignores_late_old_endcast_and_restores_stale_hidden_t2(self):
        self.start()
        self.step(40)
        self.issue_order(self.c,'stop')
        self.step()
        second=self.start()
        self.channel_event('end') # Late cancellation event from the previous T.
        self.assertIs(self.state(4),second)
        self.step(100)
        t2=self.vm.g['CrocodileT2_ID']
        self.assertIn(t2,self.c.abilities)
        self.assertFalse(self.c.disabled[('hidden',t2)])
        self.fixture.available[(0,t2)]=False
        self.c.disabled[('hidden',t2)]=True
        self.step(5)
        self.assertTrue(self.fixture.available[(0,t2)])
        self.assertFalse(self.c.disabled[('hidden',t2)])
        self.vm.remove_ability(self.c,t2)
        self.step(5)
        self.assertIn(t2,self.c.abilities)
        self.assertTrue(self.fixture.available[(0,t2)])
        self.assertFalse(self.c.disabled[('hidden',t2)])
        self.detonate()
        self.assertEqual(0,self.state(4))

    def test_death_during_t2_delay_cancels_damage_and_releases_pause(self):
        self.ready()
        self.vm.unit(0,0)
        self.assertTrue(self.vm.run('CrocodileT2_Begin',(self.c,)))
        self.step(5)
        self.c.life=0
        self.vm.run('Death',(self.c,))
        self.step(20)
        self.assertEqual([],self.vm.damage)
        self.assertEqual([],self.explosions())
        self.assertFalse(self.c.paused)
        self.assertEqual(0,self.c.pause_count)
        self.assertFalse(any(name.endswith('_T2_2') for name,_ in self.sounds))

    def test_t2_accepted_before_expiry_finishes_its_windup_after_window(self):
        ground=self.ready()
        target=self.vm.unit(0,0)
        ground.r=ground.endTime-.01
        self.detonate()
        self.assertEqual([1700.],[d for _,u,d in self.vm.damage if u is target])
        self.assertFalse(self.c.paused)
        self.step()
        self.assertFalse(ground.alive)


if __name__=='__main__':
    unittest.main()
