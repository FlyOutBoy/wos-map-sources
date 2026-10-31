"""Execute shared pause ownership, event deferral and Ice Coffin lifecycle contracts."""
from pathlib import Path
from types import SimpleNamespace
import re,unittest
from test_crocodile import JassState
ROOT=Path(__file__).resolve().parents[1]
SYSTEM=(ROOT/'triggers/Systems/Systems2.j').read_text(encoding='utf-8-sig')
ITEMS=(ROOT/'triggers/Items/Items.j').read_text(encoding='utf-8-sig')
def function(text,name):return re.search(r'\bfunction '+name+r' takes.*?endfunction',text,re.S)[0]
def method(text,name):
    body=re.search(r'\bmethod '+name+r' takes.*?endmethod',text,re.S)[0]
    return re.sub(r'(?<![\w])\.([A-Za-z]\w*)',r'this.\1',body)
NAMES=['GearCancelSpellPause','GearApplySpellPauses','GearPauseSpellStart','GearStopSpellPause','GearPauseSpellImmediate','StartSpellUnit','StartSpellUnit2','StartSpellUnit2_2','StartSpellUnitQueued','StopSpellUnit','StopSpellUnit2','StopSpellUnit2_2','StopSpellUnitQueued']
class SpellPause(unittest.TestCase):
    def setUp(self):
        self.event='effect';self.callbacks={};self.orders=[];self.pauses=[];self.extended=[]
        carrier=ITEMS.split('private struct ItemsAnimeEffect',1)[1].split('endstruct',1)[0]
        text='\n'.join(function(SYSTEM,n) for n in NAMES)+'\n'+function(ITEMS,'CoffinStart')+'\n'+method(carrier,'Finish')+'\n'+method(carrier,'Tick')
        self.vm=vm=JassState(text)
        def pause(u,b):
            self.pauses.append(b);u.paused=b
        def extended(u,b):
            self.extended.append(b);u.pause_count+=1 if b else -1
        vm.g.update(GearSpellPauseCount=0,GearSpellPauseUnits=[None]*32,GearSpellPauseExtended=[False]*32,
            GearSpellPauseClock='deferred',GetTriggerEventId=lambda:self.event,
            EVENT_PLAYER_UNIT_SPELL_EFFECT='effect',EVENT_PLAYER_UNIT_SPELL_CAST='cast',EVENT_PLAYER_UNIT_SPELL_CHANNEL='channel',EVENT_UNIT_SPELL_EFFECT='unit effect',EVENT_UNIT_SPELL_CAST='unit cast',EVENT_UNIT_SPELL_CHANNEL='unit channel',
            TimerStart=lambda clock,sec,repeat,cb:self.callbacks.update({clock:(sec,cb)}),PauseTimer=lambda clock:self.callbacks.pop(clock,None),
            PauseUnit=pause,BlzPauseUnitEx=extended,hs={},GearSelectOnlyHero=lambda _:None,MyFlush=lambda *_:None,ahk_delay=.06,
            IssueImmediateOrder=lambda u,o:(self.orders.append(o),setattr(u,'order',o)),
            UNIT_TYPE_DEAD='dead',IsUnitType=lambda u,t:u.life<=0,
            IceCoffin_Duration=2.,IceCoffin_BuffAbi_ID='coffin ability',IceCoffin_Buff_ID='coffin',CurrentRound=1,
            KIND_COFFIN=3,KIND_SUKUNA=1,KIND_SEAL=2,KIND_WILL=5,KIND_RETURN=4,KIND_SPEAR=6,
            AddSpecialEffectTarget=lambda model,u,point:vm.effect(model),AddSpecialEffect=lambda model,x,y:vm.effect(model),
            BuffUnit01=lambda *a:None,count=0,list=[None]*32,clock='coffin tick')
        self.u=vm.unit();self.u.order='move'
    def fire(self):
        self.event=None
        delay,cb=self.callbacks.pop('deferred');self.assertEqual(.01,delay);cb()
    def test_regular_start_stops_and_pauses_before_caller_animation_and_end_stops(self):
        for name,end in [('StartSpellUnit','StopSpellUnit'),('StartSpellUnit2','StopSpellUnit2')]:
            self.vm.run(name,(self.u,));self.assertTrue(self.u.paused)
            self.assertEqual('stop',self.u.order);self.assertFalse(self.callbacks)
            self.vm.run(end,(self.u,));self.assertFalse(self.u.paused)
        self.assertEqual(['stop']*4,self.orders)
    def test_same_frame_deferred_end_cancels_pending_pause(self):
        self.vm.run('GearPauseSpellStart',(self.u,False));self.vm.run('GearStopSpellPause',(self.u,False))
        self.assertEqual(0,self.vm.g['GearSpellPauseCount']);self.assertNotIn('deferred',self.callbacks)
        self.event=None;self.vm.run('GearApplySpellPauses');self.assertFalse(self.u.paused)
    def test_cancelling_one_unit_keeps_other_units_queued(self):
        other=self.vm.unit(owner=1)
        self.vm.run('GearPauseSpellStart',(self.u,False));self.vm.run('GearPauseSpellStart',(other,False))
        self.vm.run('GearStopSpellPause',(self.u,False));self.fire()
        self.assertFalse(self.u.paused);self.assertTrue(other.paused)
        self.assertEqual(0,self.vm.g['GearSpellPauseCount'])

    def test_queued_windup_keeps_order_through_both_ends(self):
        self.vm.run('StartSpellUnitQueued',(self.u,True));self.fire()
        self.vm.run('StopSpellUnitQueued',(self.u,True));self.assertEqual('move',self.u.order);self.assertFalse(self.orders)
    def test_extended_duplicate_requests_apply_once_and_do_not_release_external_stuns(self):
        self.u.pause_count=2
        self.vm.run('GearPauseSpellStart',(self.u,True));self.vm.run('GearPauseSpellStart',(self.u,True));self.fire()
        self.assertEqual(3,self.u.pause_count)
        self.vm.run('StopSpellUnit2_2',(self.u,));self.vm.run('StopSpellUnit2_2',(self.u,))
        self.assertEqual(2,self.u.pause_count);self.assertEqual([True,False],self.extended)
    def test_cancelled_or_dead_pending_extended_pause_never_unbalances_counter(self):
        self.vm.run('GearPauseSpellStart',(self.u,True));self.vm.run('StopSpellUnit2_2',(self.u,));self.assertFalse(self.extended)
        self.vm.run('GearPauseSpellStart',(self.u,True));self.u.life=0;self.fire()
        self.vm.run('StopSpellUnit2_2',(self.u,));self.assertEqual(0,self.u.pause_count);self.assertFalse(self.extended)
    def coffin(self):
        vm=self.vm;fx=SimpleNamespace(kind=3,c=self.u,u=self.u,left=2.,step=0.,armed=False,e=None,e2=None,round=1)
        fx.destroy=lambda:None
        def add(*a):vm.g['list'][0]=fx;vm.g['count']=1;return fx
        vm.g['ItemsAnimeEffect']=SimpleNamespace(KIND_COFFIN=3,Find=lambda *a:fx if vm.g['count'] else 0,Add=add)
        fx.Finish=lambda i:vm.run('Finish',(i,),obj=fx)
        return fx
    def test_coffin_double_hotkey_and_expiry_release_exactly_one_pause(self):
        fx=self.coffin();self.vm.run('CoffinStart',(self.u,));self.vm.run('CoffinStart',(self.u,))
        self.assertFalse(self.extended);self.assertFalse(self.orders);self.assertEqual(1,self.vm.g['GearSpellPauseCount'])
        self.fire();self.assertEqual(1,self.u.pause_count)
        for _ in range(21):self.vm.run('Tick')
        self.assertEqual(0,self.vm.g['count']);self.assertEqual(0,self.u.pause_count)
        self.assertEqual([True,False],self.extended);self.assertEqual(['stop'],self.orders)
    def test_coffin_cleanup_before_deferred_arm_does_not_unpause_unowned_stun(self):
        fx=self.coffin();self.u.pause_count=2;self.vm.run('CoffinStart',(self.u,));fx.Finish(0)
        self.assertEqual(2,self.u.pause_count);self.assertFalse(self.extended);self.assertNotIn('deferred',self.callbacks)
    def test_individual_unit_spell_events_also_defer(self):
        self.event='unit effect';self.vm.run('GearPauseSpellStart',(self.u,False))
        self.assertFalse(self.pauses);self.fire();self.assertTrue(self.u.paused)

    def test_timer_starts_keep_immediate_pause_timing(self):
        self.event=None;self.vm.run('StartSpellUnit2',(self.u,));self.assertTrue(self.u.paused);self.assertFalse(self.callbacks)

class NativeTiming(unittest.TestCase):
    def test_all_instant_foundations_already_have_short_duration_at_every_rank(self):
        import war3_object_workspace as ws
        docs,_=ws.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
        merged={}
        for d in docs:
            if d['kind']=='abilities':
                for o in d['custom_objects']:
                    if o['old_id']['text'] in ('Absk','ANbr','Aroa'):
                        v=merged.setdefault(ws.object_id(o),{})
                        v.update({(m['field']['text'],m.get('level',0)):ws.value_for_user(m) for m in o['modifications']})
        self.assertGreaterEqual(len(merged),54)
        for oid,v in merged.items():
            for rank in range(1,v.get(('alev',0),1)+1):
                for field in ('adur','ahdu'):
                    self.assertAlmostEqual(.01,v[field,rank],places=6,msg=f'{oid}/{rank}/{field}')

    def test_only_immediate_paused_button_is_channel_and_counter_buffs_stay_instant(self):
        import json
        from stage_instant_foundations import PAUSED_CHANNELS
        a=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
        for aid,order in PAUSED_CHANNELS.items():
            self.assertEqual('ANcl',a[aid]['base_id'])
            for rank in range(1,a[aid].get('levels',1)+1):
                self.assertEqual(order,a[aid][f'base_order_id level {rank}'])
        self.assertEqual('ANcl',a['A08Z']['base_id'])
        self.assertEqual('Absk',a['A13C']['base_id'])
        for aid,base in {'A029':'ANbr','A053':'Absk','A083':'Absk','A090':'ANbr','A093':'Aroa','A0A3':'Absk','A0CI':'Absk'}.items():
            self.assertEqual(base,a[aid]['base_id'],aid)
        self.assertEqual(5,a['A0DF']['levels']);self.assertEqual(4,a['A0DF']['level_skip'])
        self.assertEqual([75,85,95,105,115],[a['A0DF'][f'mana_cost level {r}'] for r in range(1,6)])
        hero=(ROOT/'triggers/Heroes/Bambietta.j').read_text(encoding='utf-8-sig')
        self.assertNotIn('SpellUnitQueued(',hero)

if __name__=='__main__':unittest.main()
