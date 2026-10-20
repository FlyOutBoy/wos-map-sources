"""Execute the Frostnova JASS methods with the existing deterministic harness.

Native rendering, pathing and buff timing still require Warcraft III.
"""
from pathlib import Path
import json
import re
import unittest
from types import SimpleNamespace

from test_crocodile import JassState

ROOT=Path(__file__).resolve().parents[1]
SOURCE=ROOT/'triggers/Heroes/Frostnova.j'


class FrostnovaTests(unittest.TestCase):
    def setUp(self):
        text=SOURCE.read_text('utf-8-sig')
        text=text.replace('= allocate()', '= thistype.allocate()')
        # The production expression uses JASS integer division.
        text=text.replace('((IMaxBJ(1, level) - 1) / 2)', 'R2I((IMaxBJ(1, level) - 1) / 2)')
        # Qualify repeated method names for the small shared test interpreter.
        for name in ('FrostnovaState','FrostnovaCold_KS','FrostnovaMissile_KS','FrostnovaField_KS'):
            match=re.search(r'private struct '+name+r'\b.*?endstruct',text,re.S)
            body=match[0]
            for meth in ('Loop','Start'):
                body=body.replace('method '+meth+' takes','method '+name+'_'+meth+' takes')
                text=text.replace(name+'.'+meth+'(',name+'.'+name+'_'+meth+'(')
            text=re.sub(r'private struct '+name+r'\b.*?endstruct',lambda _:body,text,count=1,flags=re.S)
        self.vm=vm=JassState(text)
        for struct in vm.structs.values():
            struct.statics.update(active=[None]*8192,count=0)
        vm.g.update(FrostnovaDummy=[None]*16,FrostnovaListenerOn=True,
            IMinBJ=lambda a,b:int(min(a,b)),
            GetHeroInt=lambda u,b:u.intelligence,
            GetPlayerId=lambda p:p,
            UnitMakeAbilityPermanent=lambda *a:None,
            SetUnitAbilityLevel=lambda u,a,v:u.abilities[a].update(level=v),
            TasAbilityChargeBox_SetValue=lambda u,a,v:u.counters.update({a:v}),
            BlzEndUnitAbilityCooldown=lambda u,a:setattr(u,'cooldown',0),
            CD_Start=lambda u,t,a,v:setattr(u,'cooldown',v),
            CreateUnit=self.dummy,
            SpellBool=lambda u:u.life > 0 and 'Avul' not in u.abilities,
            IssueTargetOrder=self.slow,
            dmgmag=lambda c,u,d:vm.damage.append((c,u,d,vm.g.get('GearDamageNextSource'))),
            AddSpecialEffect=vm.effect,
            BlzSetSpecialEffectScale=lambda *a:None,
            SaveDestructableHandle=lambda t,k,c,v:t.update({(id(k),c):v}),
            LoadDestructableHandle=lambda t,k,c:t.get((id(k),c)),
            FlushChildHashtable=lambda t,k:vm.flush(t,id(k)),
            CreateDestructable=self.crystal,
            SetDestructableInvulnerable=lambda *a:None,
            RemoveDestructable=lambda d:self.crystals.remove(d),
            MyAddMana=lambda u,v,t:setattr(u,'mana',u.mana+v),
            I2S=lambda v:str(int(v)))
        self.crystals=[]
        self.c=vm.unit(owner=0)
        self.c.type=vm.g['Frostnova_ID']
        self.c.intelligence=100
        for slot in 'QWERT':self.c.abilities[vm.g[f'Frostnova{slot}_ID']]={'level':1}
        vm.run('Frostnova_Register',(self.c,))

    def slow(self,dummy,order,target):
        for ability,buff in [('FrostnovaCold_ID','FrostnovaCold_BuffID'),('FrostnovaFrostbite_ID','FrostnovaFrostbite_BuffID')]:
            if self.vm.g[ability] in dummy.abilities:
                target.abilities[self.vm.g[buff]]={'level':dummy.abilities[self.vm.g[ability]]['level']}

    def dummy(self,p,kind,x,y,f):
        u=self.vm.unit(x,y,p)
        self.vm.add_ability(u,'Avul')
        self.vm.add_ability(u,'Aloc')
        return u

    def crystal(self,*args):
        value=SimpleNamespace(args=args)
        self.crystals.append(value)
        return value

    def state(self,u=None,key=0):
        return self.vm.g['LoadInteger'](self.vm.g['FrostnovaTable'],id(u or self.c),key)

    def ticks(self,n):
        for _ in range(n):self.vm.run('FrostnovaTimer03Loop')

    def enemy(self,x=150,y=0):
        u=self.vm.unit(x,y,1);u.intelligence=50
        return u

    def test_charge_capacity_for_every_rank(self):
        for rank,maximum in enumerate([2,2,4,4,6],1):
            self.c.abilities[self.vm.g['FrostnovaQ_ID']]['level']=rank
            self.vm.run('Frostnova_Register',(self.c,))
            self.assertEqual(maximum,self.state().capacity)
            self.assertEqual(maximum,self.state().charges)

    def test_last_charge_recharges_and_overdrive_resets(self):
        self.assertTrue(self.vm.run('FrostnovaQ_Start',(self.c,1000,0)))
        self.assertTrue(self.vm.run('FrostnovaQ_Start',(self.c,1000,0)))
        self.assertEqual(0,self.state().charges)
        self.assertFalse(self.vm.run('FrostnovaQ_Start',(self.c,1000,0)))
        self.ticks(200)
        self.assertEqual(1,self.state().charges)
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.assertEqual(2,self.state().charges)
        self.assertEqual(0,self.c.cooldown)
        self.assertGreater(self.state().scar,0)

    def test_q_stops_at_first_enemy(self):
        first=self.enemy(200);second=self.enemy(450)
        self.vm.run('FrostnovaQ_Start',(self.c,1000,0));self.ticks(50)
        self.assertEqual([first],[entry[1] for entry in self.vm.damage])
        self.assertEqual([(first,.1)],self.vm.stuns)
        self.assertEqual(0,self.vm.structs['FrostnovaMissile_KS'].statics['count'])
        self.assertEqual(0,self.state(second,1))

    def test_wave_hits_each_enemy_once_and_enhances_push(self):
        self.enemy(200);self.enemy(450)
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.vm.run('FrostnovaW_Start',(self.c,1000,0));self.ticks(45)
        self.assertEqual(2,len([d for d in self.vm.damage if d[3]==self.vm.g['FrostnovaW_ID']]))
        self.assertEqual([350,350],[p[1] for p in self.vm.pulls])

    def test_stacks_cap_frostbite_survives_normal_hit_and_dispels(self):
        u=self.enemy()
        for _ in range(8):self.vm.run('Apply',(self.c,u,True))
        self.assertEqual(5,self.state(u,1).stacks)
        self.vm.run('Apply',(self.c,u,False))
        self.assertTrue(self.state(u,1).frostbite)
        self.ticks(34)
        self.assertEqual(60,self.vm.damage[-1][2])
        self.vm.remove_ability(u,self.vm.g['FrostnovaFrostbite_BuffID'])
        self.ticks(1)
        self.assertEqual(0,self.state(u,1))

    def test_e_releases_only_owned_invulnerability_and_leaves_six_pulses(self):
        self.enemy(100)
        self.vm.run('FrostnovaE_Start',(self.c,))
        self.assertIn('Avul',self.c.abilities)
        self.ticks(20)
        self.assertNotIn('Avul',self.c.abilities)
        self.ticks(180)
        self.assertEqual(6,len(self.vm.damage))
        self.vm.add_ability(self.c,'Avul')
        self.vm.run('FrostnovaE_Start',(self.c,));self.ticks(20)
        self.assertIn('Avul',self.c.abilities)

    def test_frostbite_includes_last_tick_and_releases_state(self):
        u=self.enemy()
        self.vm.run('Apply',(self.c,u,True))
        self.ticks(200)
        self.assertEqual(6,len(self.vm.damage))
        self.assertEqual(0,self.state(u,1))
        self.assertEqual(0,self.vm.clock_users)

    def test_enhanced_field_cleans_all_crystals_and_timer_users(self):
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.vm.run('FrostnovaR_Start',(self.c,0,0))
        self.ticks(370)
        self.assertEqual(8,len(self.crystals))
        self.ticks(31)
        self.assertEqual([],self.crystals)
        self.assertEqual(0,self.vm.clock_users)
        self.assertEqual(set(),self.vm.effects)

    def test_removed_caster_cleans_fields_missiles_and_state(self):
        self.vm.run('FrostnovaE_Start',(self.c,))
        self.vm.run('FrostnovaQ_Start',(self.c,1200,0))
        self.c.type=0
        self.ticks(1)
        self.assertEqual(0,self.vm.clock_users)
        self.assertEqual(set(),self.vm.effects)
        self.assertNotIn('Avul',self.c.abilities)

    def test_death_clears_mode_and_restores_charge_display(self):
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.vm.run('FrostnovaQ_Start',(self.c,1200,0))
        self.vm.run('Frostnova_Death',(self.c,))
        self.assertEqual('2',self.c.counters[self.vm.g['FrostnovaQ_ID']])
        self.assertEqual(0,self.c.cooldown)
        self.ticks(40)
        self.assertEqual(0,self.state().scar)
        self.assertEqual(0,self.vm.clock_users)

    def test_test_and_main_code_and_object_levels_match(self):
        test_source=ROOT/'test_map/heroes/Frostnova.j'
        if test_source.is_file():
            self.assertEqual(SOURCE.read_bytes(),test_source.read_bytes())
        ids=json.loads((ROOT/'object-data/frostnova-ids.json').read_text())
        for base in [ROOT/'object-data',ROOT/'test_map/profiles/Frostnova/object-data']:
            if not base.is_dir():
                continue
            abilities=json.loads((base/'abilities.json').read_text('utf8'))
            for slot in 'QWERTF':
                obj=abilities[ids[slot]]
                self.assertEqual(1 if slot in 'TF' else 5,obj['levels'])
                if slot!='F':
                    for rank in range(1,obj['levels']+1):
                        self.assertEqual(0.0,obj[f'follow_through_time level {rank}'])
                        cost=0 if base.name=='object-data' and base.parent.name=='Frostnova' else {'Q':25,'W':80,'E':100,'R':120,'T':150}[slot]
                        self.assertEqual(cost,obj[f'mana_cost level {rank}'])


if __name__=='__main__':unittest.main()
