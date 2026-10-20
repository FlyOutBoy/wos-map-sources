"""Execute production mana repair with native payment/refund scenarios."""
from pathlib import Path
from collections import defaultdict
import unittest
import re

from test_crocodile import JassState

ROOT = Path(__file__).resolve().parents[1]
CAST = (ROOT/'triggers/Systems/CastCheck.j').read_text(encoding='utf-8-sig')
CASTING = (ROOT/'triggers/Systems/CastingCheck.j').read_text(encoding='utf-8-sig')
SYSTEMS = (ROOT/'triggers/Systems/Systems2.j').read_text(encoding='utf-8-sig')


class CastManaFix(unittest.TestCase):
    def setUp(self):
        helper = re.search(r'function GearManaScriptChange takes.*?endfunction',SYSTEMS,re.S)[0]
        self.vm = JassState(CAST+'\n'+helper)
        self.u = self.vm.unit()
        self.u.mana = 500.0
        self.u.life = 1000
        self.spell = 'test-spell'
        self.users = 0
        self.registrations = []
        self.writes = []
        self.vm.g.update(
            hs={}, ManaFixCount=0, ManaFixListenerOn=False,
            ManaFixUnit=defaultdict(lambda:None),
            ManaFixCost=defaultdict(float), ManaFixBefore=defaultdict(float),
            ManaFixTicks=defaultdict(int), UNIT_TYPE_HERO='hero',
            IsUnitType=lambda u,t:getattr(u,'hero',True),
            GetSpellAbilityUnit=lambda:self.u,
            GetSpellAbilityId=lambda:self.spell,
            GetSpellAbility=lambda:self.u.abilities.get(self.spell),
            ABILITY_ILF_MANA_COST='cost',
            GearTimer03Acquire=lambda:self.clock(1),
            GearTimer03Release=lambda:self.clock(-1),
            TriggerAddCondition=lambda *args:self.registrations.append(args),
            RemoveSavedInteger=lambda table,key,child:table.pop((key,child),None),
            SetUnitState=self.set_mana)
        self.set_cost(100)

    def set_cost(self,cost,level=1):
        self.u.abilities[self.spell] = {'level':level,'cost':cost}

    def clock(self,delta):
        self.users += delta
        self.assertIn(self.users,(0,1))

    def set_mana(self,u,state,value):
        self.writes.append(value)
        u.mana = value

    def snapshot(self):
        self.vm.run('ManaFix_Snapshot')

    def effect(self,paid=0,refund=0):
        self.u.mana -= paid
        self.vm.run('ManaFix_Add',(self.u,self.spell))
        before = self.u.mana
        self.u.mana += refund
        self.vm.run('ManaFix_AfterEffects',(self.u,before,0.0))

    def script_change(self,amount):
        before = self.u.mana
        self.u.mana += amount
        self.vm.run('GearManaScriptChange',(self.u,before))

    def tick(self):
        self.vm.run('ManaFix_Check')

    def finish(self):
        self.tick()
        self.tick()
        self.assertEqual(0,self.vm.ManaFixCount)
        self.assertEqual(0,self.users)
        self.assertTrue(all(u is None for u in self.vm.ManaFixUnit.values()))

    def test_missing_payment_is_deferred_then_charged_once(self):
        self.snapshot(); self.effect()
        self.tick()
        self.assertEqual(500,self.u.mana)
        self.tick()
        self.assertEqual(400,self.u.mana)
        self.assertEqual([400],self.writes)
        self.assertEqual(0,self.users)
        self.assertEqual(1,len(self.registrations))

    def test_native_payment_with_regeneration_never_enters_queue(self):
        self.snapshot(); self.effect(paid=100)
        self.u.mana += 30
        self.finish()
        self.assertEqual(430,self.u.mana)
        self.assertEqual([],self.writes)

    def test_native_payment_with_full_script_refund_remains_refunded(self):
        self.snapshot(); self.effect(paid=100,refund=100)
        self.finish()
        self.assertEqual(500,self.u.mana)

    def test_missing_payment_preserves_script_mana_gain(self):
        self.snapshot(); self.effect(refund=40)
        self.finish()
        self.assertEqual(440,self.u.mana)

    def test_script_mana_cost_is_separate_from_missing_native_cost(self):
        self.snapshot(); self.effect(refund=-40)
        self.finish()
        self.assertEqual(360,self.u.mana)

    def test_partial_payment_only_charges_difference(self):
        self.snapshot(); self.effect(paid=35)
        self.finish()
        self.assertEqual([400],self.writes)

    def test_late_native_payment_is_not_charged_twice(self):
        self.snapshot(); self.effect()
        self.u.mana -= 100
        self.finish()
        self.assertEqual(400,self.u.mana)
        self.assertEqual([],self.writes)

    def test_partial_late_native_payment(self):
        self.snapshot(); self.effect()
        self.u.mana -= 60
        self.finish()
        self.assertEqual(400,self.u.mana)

    def test_late_native_payment_with_small_regen_is_not_charged_again(self):
        self.snapshot(); self.effect()
        self.u.mana -= 100
        self.u.mana += 0.75
        self.finish()
        self.assertEqual(400.75,self.u.mana)
        self.assertEqual([],self.writes)

    def test_native_payment_then_delayed_refund_is_not_charged_again(self):
        self.snapshot(); self.effect()
        self.u.mana -= 100
        self.script_change(100)
        self.finish()
        self.assertEqual(500,self.u.mana)
        self.assertEqual([],self.writes)

    def test_missing_payment_with_delayed_scripted_drain(self):
        self.snapshot(); self.effect()
        self.script_change(-50)
        self.finish()
        self.assertEqual(350,self.u.mana)

    def test_missing_payment_preserves_async_restoration(self):
        self.snapshot(); self.effect()
        self.script_change(25)
        self.finish()
        self.assertEqual(425,self.u.mana)

    def test_synchronous_tracked_restore_is_not_counted_twice(self):
        self.snapshot()
        self.vm.run('ManaFix_Add',(self.u,self.spell))
        before = self.u.mana
        self.script_change(40)
        self.vm.run('ManaFix_AfterEffects',(self.u,before,0.0))
        self.u.mana -= 100
        self.finish()
        self.assertEqual(440,self.u.mana)

    def test_shared_helpers_record_actual_changes(self):
        direct = SYSTEMS[SYSTEMS.index('function SetMpCurrent'):]
        direct = direct[:direct.index('endfunction')]
        delayed = SYSTEMS[SYSTEMS.index('private struct KS_AddMana'):]
        delayed = delayed[:delayed.index('endstruct')]
        self.assertIn('call GearManaScriptChange(c,before)',direct)
        self.assertIn('call GearManaScriptChange(c,before)',delayed)

    def test_two_missing_casts_of_same_spell_accumulate(self):
        for _ in range(2):
            self.snapshot(); self.effect()
        self.assertEqual(1,self.vm.ManaFixCount)
        self.finish()
        self.assertEqual(300,self.u.mana)

    def test_another_spell_payment_cannot_pay_previous_missing_cost(self):
        self.snapshot(); self.effect()
        self.spell = 'second-spell'; self.set_cost(150)
        self.snapshot(); self.effect(paid=150)
        self.finish()
        self.assertEqual(250,self.u.mana)

    def test_late_payment_before_another_cast_is_credited_once(self):
        self.snapshot(); self.effect()
        self.u.mana -= 100
        self.spell = 'second-spell'; self.set_cost(150)
        self.snapshot(); self.effect(paid=150)
        self.finish()
        self.assertEqual(250,self.u.mana)
        self.assertEqual([],self.writes)

    def test_zero_cost_and_missing_snapshot_do_not_charge(self):
        self.set_cost(0)
        self.snapshot(); self.effect()
        self.finish()
        self.assertEqual(500,self.u.mana)

    def test_interrupted_cast_snapshot_is_discarded(self):
        self.snapshot()
        self.vm.run('ManaFix_EndCast')
        self.effect()
        self.finish()
        self.assertEqual(500,self.u.mana)

    def test_effect_consumes_snapshot_so_duplicate_event_cannot_double_charge(self):
        self.snapshot(); self.effect(); self.effect()
        self.finish()
        self.assertEqual(400,self.u.mana)

    def test_endcast_after_effect_does_not_cancel_pending_payment(self):
        self.snapshot(); self.effect()
        self.vm.run('ManaFix_EndCast')
        self.finish()
        self.assertEqual(400,self.u.mana)

    def test_removed_or_dead_caster_is_released(self):
        for removed in (False,True):
            with self.subTest(removed=removed):
                self.snapshot(); self.effect()
                self.u.life = 0
                if removed:
                    self.u.type = 0
                self.finish()
                self.assertEqual(500,self.u.mana)

    def test_cost_one_and_insufficient_remaining_mana(self):
        self.set_cost(1)
        self.snapshot(); self.effect()
        self.finish()
        self.assertEqual(499,self.u.mana)
        self.set_cost(100)
        self.u.mana = 20
        self.snapshot(); self.effect()
        self.finish()
        self.assertEqual(0,self.u.mana)

    def test_multiple_units_compaction_and_balanced_clock(self):
        first = self.u
        self.snapshot(); self.effect()
        self.tick()
        self.u = self.vm.unit(); self.u.mana = 500
        self.set_cost(75)
        self.snapshot(); self.effect()
        self.tick()
        self.assertEqual(400,first.mana)
        self.assertEqual(500,self.u.mana)
        self.assertEqual(1,self.vm.ManaFixCount)
        self.tick()
        self.assertEqual(425,self.u.mana)
        self.assertEqual(0,self.users)

    def test_current_level_cost_and_new_cast_after_old_cancel(self):
        self.snapshot()
        self.vm.run('ManaFix_EndCast')
        self.set_cost(175,level=5)
        self.snapshot(); self.effect()
        self.finish()
        self.assertEqual(325,self.u.mana)

    def test_common_timer_and_effect_order_integration(self):
        self.assertNotIn('ManaFixTimer',CAST)
        self.assertNotIn('TimerStart(',CAST)
        self.assertNotIn('ManaFix_Finish',CASTING)
        self.assertIn('EVENT_PLAYER_UNIT_SPELL_CAST',CAST)
        handler = CAST[CAST.index('function CastHero_Conditions'):]
        self.assertLess(handler.index('call ManaFix_Add(c,id)'),handler.index('call ItemsCast'))
        self.assertLess(handler.index('call ItemsCast'),handler.index('call ManaFix_AfterEffects'))


if __name__=='__main__':
    unittest.main()
