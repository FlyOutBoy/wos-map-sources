"""Execute the Frostnova JASS methods with the existing deterministic harness.

Native rendering, pathing and buff timing still require Warcraft III.
"""
from pathlib import Path
import json
import re
import unittest
import random
import math
from types import SimpleNamespace

from test_crocodile import JassState

ROOT=Path(__file__).resolve().parents[1]
SOURCE=ROOT/'triggers/Heroes/Frostnova.j'


class NativeArray(dict):
    def __getitem__(self,key):
        return super().get(key if isinstance(key,int) else id(key),0)
    def __setitem__(self,key,value):
        return super().__setitem__(key if isinstance(key,int) else id(key),value)


class FrostnovaTests(unittest.TestCase):
    def setUp(self):
        text=SOURCE.read_text('utf-8-sig')
        cast=(ROOT/'triggers/Systems/CastCheck.j').read_text('utf-8-sig')
        movement=re.search(r'function DisableMoveRoot takes.*?endfunction',cast,re.S)[0]
        text+='\n'+movement.replace('static if ','if ')
        # Keep the harness' historical field names while executing the current
        # implementation: only identifiers change, never expressions or values.
        aliases={'hero':'c','targets':'g','mainEffect':'art','fieldEffect':'art2','target':'u',
            'positionX':'x','positionY':'y','index':'i','orientationAngle':'a','shardEffect':'e',
            'targetX':'tx','targetY':'ty','winterRemaining':'scar','qCastDelay':'qUsePause',
            'previousQCharges':'previousCharges','nextNormalVoice':'qVoice','enhancedShards':'darkShards',
            'remainingTime':'remaining','damageCountdown':'pulse','buffCountdown':'buffTime',
            'burstCountdown':'burstTime','invulnerabilityRemaining':'invulnerable',
            'preparationRemaining':'preparation','remainingDistance':'distance','distancePerTick':'speed',
            'firstTarget':'first'}
        text=re.sub(r'"(?:\\.|[^"\\])*"|//[^\n]*|/\*.*?\*/|\b[A-Za-z_]\w*\b',
                    lambda m:aliases.get(m[0],m[0]),text,flags=re.S)
        text=text.replace('= allocate()', '= thistype.allocate()')
        # The production expression uses JASS integer division.
        text=text.replace('((IMaxBJ(1, level) - 1) / 2)', 'R2I((IMaxBJ(1, level) - 1) / 2)')
        # Qualify repeated method names for the small shared test interpreter.
        for name in ('FrostnovaState', *(f'Frostnova{slot}_KS' for slot in 'FQWERT')):
            match=re.search(r'private struct '+name+r'\b.*?endstruct',text,re.S)
            body=match[0]
            for meth in ('Loop','Start'):
                body=body.replace('method '+meth+' takes','method '+name+'_'+meth+' takes')
                text=text.replace(name+'.'+meth+'(',name+'.'+name+'_'+meth+'(')
            text=re.sub(r'private struct '+name+r'\b.*?endstruct',lambda _:body,text,count=1,flags=re.S)
        shared=(ROOT/'triggers/Systems/Systems2.j').read_text('utf-8-sig')
        shared=shared[shared.index('        struct KS_SpellStacks'):shared.index('    function SpellStacksHideAndPause')]
        shared=shared[:shared.index('    endstruct')+len('    endstruct')]+'\n'+shared[shared.index('    function SpellStacksStart'):]
        text+='\n'+shared.replace('struct KS_SpellStacks','private struct KS_SpellStacks')
        self.vm=vm=JassState(text)
        for name in re.findall(r'\b(?:\w+_ID|Erza4W_Start)\b',movement):
            vm.g.setdefault(name,name)
        vm.g.update(LIBRARY_FrostnovaSpells=True,GearCCProtected=lambda u:u.protection>0)
        vm.g.update(MoveEff2=vm.g['MoveEff'],PathableCheck=lambda *args:True)
        self.small_icons=[]
        vm.g["MyFrameTimed"]=lambda *args:self.small_icons.append(args)
        self.dual_progress=[]
        def dual(*args):
            self.dual_progress.append(args)
            vm.progress_calls.append((*args[:5],True))
        vm.g.update(WUI_HeroProgressDualText=dual,R2SW=lambda value,*args:format(value,'.1f'))
        self.progress_text=[]
        vm.g.update(WUI_HeroProgressText=lambda *args:self.progress_text.append(args),WUI_HeroProgressIcon=lambda *args:None)
        for struct in vm.structs.values():
            struct.statics.update(active=[None]*8192,count=0)
        vm.structs['KS_SpellStacks'].statics.update(instances=[None]*8192,lastInstance=-1,STACK_USE_COOLDOWN=.25)
        self.timers=[]
        self.expired=None
        self.stack_time=0
        self.buff_times={}
        vm.g.update(hs={},FrostnovaDummy=[None]*16,FrostnovaListenerOn=True,
            FrostnovaFBuff=[0]*11,
            FrostnovaIcefields=[None]*8192,FrostnovaIcefieldX=NativeArray(),
            FrostnovaIcefieldY=NativeArray(),FrostnovaIcefieldRadius=NativeArray(),
            LoadInteger=lambda t,k,c:t.get((k if isinstance(k,int) else id(k),c),0),
            SaveInteger=lambda t,k,c,v:t.update({(k if isinstance(k,int) else id(k),c):v}),
            LoadReal=lambda t,k,c:t.get((k if isinstance(k,int) else id(k),c),0.0),
            SaveReal=lambda t,k,c,v:t.update({(k if isinstance(k,int) else id(k),c):v}),
            HaveSavedReal=lambda t,k,c:(k if isinstance(k,int) else id(k),c) in t,
            RemoveSavedReal=lambda t,k,c:t.pop((k if isinstance(k,int) else id(k),c),None),
            AnimDummy=lambda *a:None,
            GetRandomReal=random.Random(13).uniform,
            SetAnimIndex=lambda *a:None,SetUnitAnimationByIndex=lambda *a:None,
            GetLocalPlayer=lambda:0,Player=lambda p:p,PLAYER_NEUTRAL_PASSIVE=15,
            IsUnitInvisible=lambda u,p:getattr(u,'invisible',False),
            IsUnitVisible=lambda u,p:not getattr(u,'hidden',False),
            LoadEffectHandle=lambda t,k,c:t.get((k if isinstance(k,int) else id(k),c)),
            SaveEffectHandle=lambda t,k,c,v:t.update({(k if isinstance(k,int) else id(k),c):v}),
            RemoveSavedHandle=lambda t,k,c:t.pop((k if isinstance(k,int) else id(k),c),None),
            BlzPlaySpecialEffect=lambda e,a:setattr(e,"animation",a), ANIM_TYPE_STAND='stand',
            BlzSetSpecialEffectTime=lambda e,t:setattr(e,'time',t),
            BlzSetSpecialEffectAlpha=lambda e,a:setattr(e,'alpha',a),
            GetDestructableX=lambda d:d.args[1],GetDestructableY=lambda d:d.args[2],
            CreateTrigger=lambda:object(),TriggerRegisterAnyUnitEventBJ=lambda *a:None,
            TriggerAddAction=lambda *a:None,EVENT_PLAYER_HERO_SKILL='learn',
            IMinBJ=lambda a,b:int(min(a,b)),
            GetHeroInt=lambda u,b:u.intelligence,
            GetPlayerId=lambda p:p,
            UnitMakeAbilityPermanent=lambda *a:None,
            SetUnitAbilityLevel=lambda u,a,v:u.abilities[a].update(level=v),
            TasAbilityChargeBox_SetValue=lambda u,a,v:u.counters.update({a:v}),
            BlzEndUnitAbilityCooldown=lambda u,a:setattr(u,'cooldown',0),
            BlzStartUnitAbilityCooldown=lambda u,a,v:setattr(u,'cooldown',v),
            BlzGetUnitAbilityCooldownRemaining=lambda u,a:u.cooldown,
            ABILITY_SLF_ICON_NORMAL='icon',
            ABILITY_RLF_CAST_RANGE='range',
            BlzSetAbilityStringLevelField=lambda a,f,l,v:a.update({f:v}),
            CreateTimer=lambda:SimpleNamespace(running=False),
            TimerStart=self.timer_start,
            SaveUnitHandle=lambda t,k,c,v:t.update({(k if isinstance(k,int) else id(k),c):v}),
            LoadUnitHandle=lambda t,k,c:t.get((k if isinstance(k,int) else id(k),c)),
            GetExpiredTimer=lambda:self.expired,
            PauseTimer=lambda t:setattr(t,'running',False),
            DestroyTimer=lambda t:None,
            TasAbilityChargeBox_Update=lambda:None,
            TasAbilityChargeBox_Clear=lambda u:u.counters.clear(),
            GearTimer05Acquire=lambda:None,GearTimer05Release=lambda:None,
            deallocate=lambda data:data.deallocate(),
            CD_Start=lambda u,t,a,v:setattr(u,'cooldown',v),
            CreateUnit=self.dummy,
            RemoveUnit=lambda u:(setattr(u,'type',0),setattr(u,'life',0)),
            SpellBool=lambda u:u.life > 0 and 'Avul' not in u.abilities,
            IssueTargetOrder=self.slow,
            dmgmag=lambda c,u,d:vm.damage.append((c,u,d,vm.g.get('GearDamageNextSource'))),
            AddSpecialEffect=vm.effect,
            BlzSetSpecialEffectScale=lambda e,s:setattr(e,'scale',s),
            ScaleEffDummy=lambda e,t,s,target:(setattr(e,'scale',s),setattr(e,'scale_transition',(t,s,target))),
            BlzGetUnitZ=lambda u:0,
            BlzSetSpecialEffectZ=lambda e,z:setattr(e,'z',z),
            BlzSetSpecialEffectPosition=lambda e,x,y,z:(setattr(e,'x',x),setattr(e,'y',y),setattr(e,'z',z)),
            BlzSetSpecialEffectColor=lambda *a:None,
            SaveDestructableHandle=lambda t,k,c,v:t.update({(id(k),c):v}),
            LoadDestructableHandle=lambda t,k,c:t.get((id(k),c)),
            FlushChildHashtable=lambda t,k:vm.flush(t,k if isinstance(k,int) else id(k)),
            CreateDestructable=self.crystal,
            SetDestructableInvulnerable=lambda *a:None,
            RemoveDestructable=lambda d:self.crystals.remove(d),
            MyAddMana=lambda u,v,t:setattr(u,'mana',u.mana+v),
            I2S=lambda v:str(int(v)))
        self.vision=[]
        self.decor=[]
        vm.g['VisionTimed']=lambda *args:self.vision.append(args)
        vm.g['DecorRemove']=lambda *args:self.decor.append(args)
        self.roots=[]
        vm.g["RootUnit"]=lambda c,u,t:self.roots.append((u,t))
        self.sounds=[]
        vm.g["MakeSound"]=lambda path:self.sounds.append(path.rsplit("_",1)[-1])
        self.sound_volumes={}
        vm.g['MakeSoundVolume']=lambda path,volume:(self.sounds.append(path.rsplit('_',1)[-1]),self.sound_volumes.__setitem__(path.rsplit('_',1)[-1],volume))
        self.buff_casts=[]
        vm.g['BuffUnit01']=lambda c,u,ability,order,level:(self.buff_casts.append((ability,order,u)),self.slow(None,order,u),0.)[2]
        vm.g.update(BankaiActive=False,UnitApplyTimedLife=lambda u,*args:vm.units.remove(u) if u in vm.units else None,  # one-shot casters expire
            GearSoundPlay=lambda path,volume,*args:(self.sounds.append(path.rsplit("_",1)[-1][:-4]),self.sound_volumes.__setitem__(path.rsplit("_",1)[-1][:-4],volume)))
        self.crystals=[]
        vm.run('InitFrostnovaSpells')
        self.c=vm.unit(owner=0)
        self.c.type=vm.g['Frostnova_ID']
        self.c.intelligence=100
        for slot in 'QWERT':self.c.abilities[vm.g[f'Frostnova{slot}_ID']]={'level':1}
        vm.run('Frostnova_Register',(self.c,))
        self.e_duration=vm.g['FrostnovaE_Duration']
        self.e_finish_ticks=math.ceil((self.e_duration+vm.g['FrostnovaE_Preparation'])/.03)

    def timer_start(self,t,period,repeating,callback):
        t.remaining=period;t.callback=callback;t.running=True
        self.timers.append(t)

    def charges(self,u=None):
        return self.vm.run('SpellStacksGet',(u or self.c,))

    def capacity(self,u=None):
        return self.vm.run('SpellStacksGetMax',(u or self.c,))

    def slow(self,dummy,order,target):
        if order=='frostarmor':
            buff=self.vm.g['FrostnovaT_ShieldBuffID']
            target.abilities[buff]={'level':1}
            self.buff_times[(id(target),buff)]=[target,self.vm.g['FrostnovaT_ShieldDuration']]
            return
        if order in ('innerfire','cripple'):
            buff=self.vm.g['FrostnovaE_ResistBuffID' if order=='innerfire' else 'FrostnovaE_HealCutBuffID']
            target.abilities[buff]={'level':1}
            self.buff_times[(id(target),buff)]=[target,.36]
            return
        level=dummy.abilities[self.vm.g['FrostnovaF_DebuffID']]['level']
        target.abilities[self.vm.g['FrostnovaFBuff'][level]]={'level':1}

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
        for _ in range(n):
            for key,(unit,remaining) in list(self.buff_times.items()):
                remaining-=.03
                if remaining<=.00001:
                    unit.abilities.pop(key[1],None);del self.buff_times[key]
                else:self.buff_times[key][1]=remaining
            for unit in self.vm.units:unit.cooldown=max(0,unit.cooldown-.03)
            for timer in self.timers[:]:
                timer.remaining-=.03
                if timer.remaining<=.0001 and timer.running:
                    self.expired=timer;timer.callback();self.timers.remove(timer)
            self.stack_time+=.03
            while self.stack_time>=.05-.00001:
                self.stack_time-=.05
                self.vm.run('Loop_AddSpellStacks')
            self.vm.run('FrostnovaTimer03Loop')
            for entry in self.vm.timed_effects[:]:
                entry[1] -= 0.03
                if entry[1] <= 0:
                    self.vm.effects.discard(id(entry[0]))
                    self.vm.timed_effects.remove(entry)

    def orbit_effects(self):
        return {id(self.vm.g['LoadEffectHandle'](self.vm.g['FrostnovaTable'],id(u),base+i))
                for u in self.vm.units for i in range(6) for base in (100,200)
                if self.vm.g['LoadEffectHandle'](self.vm.g['FrostnovaTable'],id(u),base+i) is not None}

    def enemy(self,x=150,y=0):
        u=self.vm.unit(x,y,1);u.intelligence=50
        return u

    def test_q_orbits_match_charges_follow_hide_die_and_return_on_revive(self):
        self.c.abilities[self.vm.g['FrostnovaQ_ID']]['level']=5
        self.vm.run('Frostnova_Register',(self.c,))
        self.assertEqual(6,len(self.orbit_effects()))
        shards=[self.vm.g['LoadEffectHandle'](self.vm.g['FrostnovaTable'],id(self.c),100+i) for i in range(6)]
        self.assertEqual(3,len([e for e in shards if e.y<self.c.y]))
        self.assertEqual(3,len([e for e in shards if e.y>self.c.y]))
        self.assertGreater(max(e.z for e in shards)-min(e.z for e in shards),40)
        import math
        self.assertGreater(min(math.dist((a.x,a.y,a.z),(b.x,b.y,b.z)) for i,a in enumerate(shards) for b in shards[i+1:]),60)
        self.c.x=500;self.c.y=300;self.c.invisible=True
        self.ticks(1)
        self.assertTrue(all(e.alpha==0 and abs(e.x-self.c.x)<280 for e in shards))
        self.assertEqual({id(e) for e in shards},self.orbit_effects())
        self.c.invisible=False;self.ticks(1)
        self.assertTrue(all(e.alpha==255 for e in shards))
        self.c.life=0;self.ticks(1)
        self.assertEqual(set(),self.orbit_effects())
        self.c.life=100;self.ticks(1)
        self.assertEqual(6,len(self.orbit_effects()))

    def test_q_detaches_its_orbit_effect_and_aims_from_that_position(self):
        shard=self.vm.g['LoadEffectHandle'](self.vm.g['FrostnovaTable'],id(self.c),101)
        x,y=shard.x,shard.y
        self.vm.run('FrostnovaQ_Start',(self.c,1000,0))
        projectile=self.vm.structs['FrostnovaQ_KS'].statics['active'][0]
        self.assertIs(shard,projectile.art)
        self.assertAlmostEqual(x,projectile.x);self.assertAlmostEqual(y,projectile.y)
        self.assertEqual(1,len(self.orbit_effects()))
        self.assertNotIn(id(shard),self.orbit_effects())
        self.assertEqual((projectile.x,projectile.y,shard.z+self.vm.g['FrostnovaQ_TrailHeightOffset']),(projectile.trail.x,projectile.trail.y,projectile.trail.z))
        self.assertEqual('war3mapImported\\wos_ice_shard-7716D.mdx',self.vm.g['FrostnovaQ_Model'])
        self.assertIn('[skillm]als-tx (6)',self.vm.g['FrostnovaQ_TrailModel'])

    def test_q_shards_rotate_around_a_stationary_hero_and_launch_from_the_rotated_position(self):
        shard=self.vm.g['LoadEffectHandle'](self.vm.g['FrostnovaTable'],id(self.c),101)
        original=(shard.x,shard.y)
        self.ticks(50)
        self.assertGreater(abs(shard.x-original[0])+abs(shard.y-original[1]),100)
        rotated=(shard.x,shard.y)
        self.vm.run('FrostnovaQ_Start',(self.c,1000,0))
        projectile=self.vm.structs['FrostnovaQ_KS'].statics['active'][0]
        self.assertEqual(rotated,(projectile.x,projectile.y))
        self.assertIs(shard,projectile.art)

    def test_level_up_is_observed_on_shared_clock_without_skill_event_side_effects(self):
        text=SOURCE.read_text('utf8')
        self.assertNotIn('EVENT_PLAYER_HERO_SKILL',text)
        original=self.orbit_effects()
        self.c.abilities[self.vm.g['FrostnovaQ_ID']]['level']=2
        self.ticks(1)
        self.assertEqual(2,self.capacity())
        self.assertEqual(original,self.orbit_effects())
        self.c.abilities[self.vm.g['FrostnovaQ_ID']]['level']=3
        self.ticks(1)
        self.assertEqual(4,self.capacity())
        self.assertEqual(4,len(self.orbit_effects()))
        self.assertEqual(1,self.vm.clock_users)

    def test_charges_use_shared_toji_tracker_through_learning_escape_and_casting(self):
        for rank in (2,3,4,5):
            self.c.abilities[self.vm.g['FrostnovaQ_ID']]['level']=rank
            self.ticks(1)
            for _ in range(10):
                self.vm.run('FrostnovaQ_Start',(self.c,1000,0))
                self.ticks(1)
                self.vm.run('Frostnova_ResetForTest',(self.c,))
                self.ticks(1)
                self.assertEqual(self.capacity(),self.charges())
                self.assertEqual(0,self.c.cooldown)
                self.assertEqual(self.capacity(),len(self.orbit_effects()))
                self.assertEqual(0,self.vm.structs['KS_SpellStacks'].statics['lastInstance'])
                self.assertEqual(1,self.vm.structs['FrostnovaState'].statics['count'])
        text=SOURCE.read_text('utf8')
        self.assertNotIn('integer charges',text)
        self.assertNotIn('state.recharge',text)
        self.assertNotIn('CD_Start(caster',text)

    def test_visible_local_hero_is_not_hidden_by_a_neutral_observer(self):
        self.vm.g['IsUnitInvisible']=lambda u,p:p==15
        self.ticks(1)
        shards=[self.vm.g['LoadEffectHandle'](self.vm.g['FrostnovaTable'],id(self.c),100+i) for i in range(self.charges())]
        self.assertTrue(all(e.alpha==255 for e in shards))
        self.assertNotIn("BlzSetSpecialEffectTime(",SOURCE.read_text("utf8"))

    def test_q_orbit_is_centered_small_and_projectile_descends_with_lower_trail(self):
        self.c.abilities[self.vm.g['FrostnovaQ_ID']]['level']=5
        self.vm.run('Frostnova_Register',(self.c,))
        shards=[self.vm.g['LoadEffectHandle'](self.vm.g['FrostnovaTable'],id(self.c),100+i) for i in range(6)]
        self.assertAlmostEqual(self.c.x,sum(e.x for e in shards)/6)
        self.assertAlmostEqual(self.c.y,sum(e.y for e in shards)/6)
        self.assertTrue(all(abs(e.scale-self.vm.g['FrostnovaQ_ModelScale']/3)<.00001 for e in shards))
        self.vm.run('FrostnovaQ_Start',(self.c,1200,0))
        p=self.vm.structs['FrostnovaQ_KS'].statics['active'][0]
        self.assertEqual((.18,.7/3,.7),p.art.scale_transition)
        previous=p.height
        for _ in range(12):
            self.ticks(1)
            self.assertLessEqual(p.height,previous)
            self.assertAlmostEqual(self.vm.g['FrostnovaQ_TrailHeightOffset'],p.trail.z-p.art.z)
            previous=p.height
        self.assertAlmostEqual(150,p.height)

    def test_early_charge_grant_keeps_the_between_shot_delay(self):
        self.c.abilities[self.vm.g['FrostnovaQ_ID']]['level']=3
        self.vm.run('Frostnova_Register',(self.c,))
        self.vm.run('FrostnovaQ_Start',(self.c,1200,0));self.ticks(1)
        self.c.cooldown=3
        self.vm.run('SpellStacksAdd',(self.c,1))
        self.ticks(1)
        self.assertEqual(4,self.charges())
        self.assertGreater(self.c.cooldown,0)
        self.ticks(20)
        self.assertEqual(0,self.c.cooldown)

    def test_low_charge_rises_to_flight_height_and_q_receives_the_extra_ten_percent_speed(self):
        self.vm.run('SpellStacksSet',(self.c,1))
        self.ticks(1)
        self.vm.run('FrostnovaQ_Start',(self.c,1200,0))
        p=self.vm.structs['FrostnovaQ_KS'].statics['active'][0]
        self.assertLess(p.height,40)
        self.assertEqual(2310*.03,p.speed)
        previous=p.height
        for _ in range(11):
            self.ticks(1)
            self.assertGreaterEqual(p.height,previous)
            previous=p.height
        self.assertAlmostEqual(150,p.height)

    def test_t_reports_real_morph_duration_and_clears_bar_on_death(self):
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.assertEqual((self.c,self.vm.g['FrostnovaT_ID'],"Winter's Scar",20,20,True),self.vm.progress_calls[-1])
        self.ticks(20)
        self.assertAlmostEqual(self.state().scar,self.vm.progress_calls[-1][3])
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.assertEqual(20,self.vm.progress_calls[-1][3])
        self.c.life=0;self.ticks(1)
        self.assertEqual((0,0),self.vm.progress_calls[-1][3:5])

    def test_walking_and_learning_do_not_recreate_existing_orbits_or_add_timer_users(self):
        original=self.orbit_effects()
        for tick in range(1200):
            self.c.x=tick%700;self.c.y=(tick*3)%500;self.c.facing=tick%360
            if tick==300:self.c.abilities[self.vm.g['FrostnovaQ_ID']]['level']=2
            self.ticks(1)
            self.assertEqual(original,self.orbit_effects())
        self.assertEqual(1,self.vm.clock_users)
        self.assertEqual(set(),self.vm.groups)
        self.assertEqual([],self.vm.timed_effects)

    def test_tw_has_three_directions_and_one_shared_hit_set(self):
        import math
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.vm.run('FrostnovaW_Start',(self.c,1000,0))
        waves=self.vm.structs['FrostnovaW_KS'].statics
        self.assertEqual(3,waves['count'])
        instances=waves['active'][:3]
        self.assertEqual([-self.vm.g['FrostnovaTW_Angle'],0,self.vm.g['FrostnovaTW_Angle']],[round(e.angle*180/math.pi) for e in instances])
        self.assertTrue(all(e.hit is instances[0].hit for e in instances))
        self.ticks(80)
        self.assertEqual(0,waves['count'])
        self.assertEqual(set(),self.vm.groups)


    def test_native_slow_has_ten_distinct_visible_buff_tiers(self):
        data=json.loads((ROOT/'object-data/abilities.json').read_text('utf8'))
        seen=set()
        obj=data[self.vm.g['FrostnovaF_DebuffID']]
        self.assertEqual('Aslo',obj['base_id'])
        self.assertEqual(10,obj['levels'])
        for tier in range(1,11):seen.add(obj[f'buffs level {tier}'])
        self.assertEqual(10,len(seen))
        self.assertNotIn('SetUnitMoveSpeed(',SOURCE.read_text('utf-8-sig'))

    def test_frost_burst_survives_creation_frame(self):
        self.vm.run('FrostnovaE_Start', (self.c,))
        field = self.state(key=2)
        self.ticks(25)
        effect = field.burst
        self.assertEqual(self.vm.g['FrostnovaE_BurstDuration'], field.burstTime)
        self.assertIn(id(effect), self.vm.effects)
        self.ticks(51)
        self.assertNotIn(id(effect), self.vm.effects)
        self.assertIsNone(field.burst)

    def test_charge_capacity_for_every_rank(self):
        for rank,maximum in enumerate([2,2,4,4,6],1):
            self.c.abilities[self.vm.g['FrostnovaQ_ID']]['level']=rank
            self.vm.run('Frostnova_Register',(self.c,))
            self.assertEqual(maximum,self.capacity())
            self.assertEqual(maximum,self.charges())

    def test_test_reset_restores_charges_and_recharge_without_overdrive(self):
        self.vm.run('FrostnovaQ_Start',(self.c,1000,0))
        self.vm.run('FrostnovaQ_Start',(self.c,1000,0))
        self.ticks(30)
        for _ in range(100):
            self.vm.run('Frostnova_ResetForTest',(self.c,))
        self.assertEqual(self.capacity(),self.charges())
        data=self.vm.structs['KS_SpellStacks'].statics['instances'][0]
        self.assertEqual(0,data.r)
        self.assertEqual(0,self.state().scar)
        self.assertEqual(0,self.vm.g['LoadInteger'](self.vm.g['FrostnovaTable'],id(self.c),3))
        self.assertEqual('2',self.c.counters[self.vm.g['FrostnovaQ_ID']])
        self.ticks(1)
        self.assertEqual(0,self.c.cooldown)

    def test_last_charge_recharges_and_overdrive_resets(self):
        self.assertTrue(self.vm.run('FrostnovaQ_Start',(self.c,1000,0)))
        self.assertTrue(self.vm.run('FrostnovaQ_Start',(self.c,1000,0)))
        self.assertEqual(0,self.charges())
        self.ticks(1)
        self.assertFalse(self.vm.run('FrostnovaQ_Start',(self.c,1000,0)))
        self.ticks(math.ceil(self.vm.g['FrostnovaQ_Recharge']/.03))
        self.assertEqual(1,self.charges())
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.assertEqual(2,self.charges())
        self.ticks(1)
        self.assertEqual(0,self.c.cooldown)
        self.assertGreater(self.state().scar,0)

    def test_q_enforces_longer_between_shot_delay_before_consuming_another_charge(self):
        self.vm.run('FrostnovaQ_Start', (self.c, 1200, 0))
        self.assertEqual(1, self.charges())
        self.ticks(2)
        self.assertGreater(self.c.cooldown,.25)
        self.vm.run('FrostnovaQ_Start', (self.c, 1200, 0))
        self.assertEqual(1, self.charges())
        self.ticks(20)
        self.vm.run('FrostnovaQ_Start', (self.c, 1200, 0))
        self.assertEqual(0, self.charges())
        self.ticks(1)
        # Recharge has already progressed while the first shard was on cooldown.
        self.assertGreater(self.c.cooldown,self.vm.g['FrostnovaQ_Recharge']-1.0)
        self.assertLessEqual(self.c.cooldown,self.vm.g['FrostnovaQ_Recharge'])
        self.ticks(math.ceil(self.vm.g['FrostnovaQ_Recharge']/.03))
        self.assertEqual(1, self.charges())
        self.assertEqual(0.0, self.c.cooldown)

    def test_q_stops_at_first_enemy(self):
        first=self.enemy(200,110);second=self.enemy(450,110)
        self.vm.run('FrostnovaQ_Start',(self.c,1000,110));self.ticks(50)
        self.assertEqual([first],[entry[1] for entry in self.vm.damage])
        self.assertEqual([(first,.1)],self.vm.stuns)
        self.assertEqual(0,self.vm.structs['FrostnovaQ_KS'].statics['count'])
        self.assertEqual(0,self.state(second,1))

    def test_normal_q_hit_effect_lives_through_its_animation_without_unit_scale(self):
        enemy=self.enemy(200,110)
        self.vm.run('FrostnovaQ_Start',(self.c,1000,110))
        self.ticks(8)
        impacts=[e for e in self.vm.effect_history if e.model==self.vm.g['FrostnovaQ_ImpactModel']]
        self.assertEqual(1,len(impacts))
        impact=impacts[0]
        self.assertEqual((enemy.x,enemy.y,80.),(impact.x,impact.y,impact.z))
        self.assertIn(id(impact),self.vm.effects)
        self.ticks(35)
        self.assertNotIn(id(impact),self.vm.effects)

    def test_tq_pierces_and_hits_each_enemy_once_with_dark_impact(self):
        first=self.enemy(200,110);second=self.enemy(450,110)
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.vm.run('FrostnovaQ_Start',(self.c,1000,110));self.ticks(50)
        hits=[d for d in self.vm.damage if d[3]==self.vm.g['FrostnovaQ_ID']]
        self.assertEqual([first,second],[d[1] for d in hits])
        self.assertEqual(2,len([e for e in self.vm.effect_history if e.model==self.vm.g['FrostnovaTQ_ImpactModel']]))
        self.assertTrue(all(e.scale==.5 for e in self.vm.effect_history if e.model==self.vm.g['FrostnovaTQ_ImpactModel']))
        self.assertEqual(0,self.vm.structs['FrostnovaQ_KS'].statics['count'])
        self.assertEqual(set(),self.vm.groups)

    def test_f_rejects_self_and_friendly_targets_including_t(self):
        ally=self.vm.unit(100,0,0)
        self.vm.run('FrostnovaT_Start',(self.c,))
        for target in [self.c,ally]:
            for _ in range(8):self.vm.run('Apply',(self.c,target,True))
            self.assertEqual(0,self.state(target,1))
            self.assertFalse(any(b in target.abilities for b in self.vm.g['FrostnovaFBuff'][1:]))

    def test_tw_releases_only_invulnerability_it_added(self):
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.vm.run('FrostnovaW_Start',(self.c,1200,0))
        self.assertIn('Avul',self.c.abilities)
        self.ticks(20)
        self.assertNotIn('Avul',self.c.abilities)
        self.vm.add_ability(self.c,'Avul')
        self.vm.run('FrostnovaW_Start',(self.c,1200,0));self.ticks(20)
        self.assertIn('Avul',self.c.abilities)

    def test_w_push_is_clipped_to_all_containing_icefields_and_registry_cleans(self):
        import math
        self.vm.run('FrostnovaR_Start',(self.c,0,0))
        u=self.enemy(1000,0)
        for angle in [0, .3, -.3, math.pi/2]:
            d=self.vm.run('FrostnovaIcefieldPush',(u,550,angle))
            self.assertLessEqual(math.hypot(u.x+d*math.cos(angle),u.y+d*math.sin(angle)),1050)
        outside=self.enemy(2000,0)
        self.assertEqual(550,self.vm.run('FrostnovaIcefieldPush',(outside,550,0)))
        self.vm.run('FrostnovaR_Start',(self.c,200,0))
        self.assertEqual(2,self.vm.g['FrostnovaIcefieldCount'])
        self.ticks(284)
        self.assertEqual(0,self.vm.g['FrostnovaIcefieldCount'])
        self.assertEqual(550,self.vm.run('FrostnovaIcefieldPush',(u,550,0)))

    def test_e_separate_buffs_refresh_inside_then_expire_after_exit(self):
        target=self.enemy(300)
        self.vm.run('FrostnovaE_Start',(self.c,));self.ticks(26)
        resist=self.vm.g['FrostnovaE_ResistBuffID'];cut=self.vm.g['FrostnovaE_HealCutBuffID']
        self.assertIn(resist,self.c.abilities)
        self.assertIn(cut,target.abilities)
        self.assertNotIn(cut,self.c.abilities)
        self.assertNotIn(resist,target.abilities)
        self.ticks(40)
        self.assertIn(resist,self.c.abilities);self.assertIn(cut,target.abilities)
        self.c.x=2000;target.x=2000;self.ticks(13)
        self.assertNotIn(resist,self.c.abilities);self.assertNotIn(cut,target.abilities)
        self.c.x=0;target.x=0;self.ticks(5)
        self.assertIn(resist,self.c.abilities);self.assertIn(cut,target.abilities)
        self.ticks(self.e_finish_ticks)
        self.assertNotIn(resist,self.c.abilities);self.assertNotIn(cut,target.abilities)

    def test_te_attached_aura_damages_near_moving_caster_and_cleans(self):
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.vm.run('FrostnovaE_Start',(self.c,));self.ticks(26)
        field=self.state(key=2);aura=field.aura
        self.assertIn(id(aura),self.vm.effects)
        self.assertEqual('war3mapImported\\wos_Frostnova_TE_Aura.mdx',aura.model)
        self.assertGreater(self.vm.g['FrostnovaTE_Aoe'],0)
        self.assertAlmostEqual(self.e_duration,field.remaining+.03)
        self.c.x=2000
        target=self.enemy(2000+self.vm.g['FrostnovaTE_Aoe']-10)
        outside=self.enemy(2000+self.vm.g['FrostnovaTE_Aoe']+10)
        self.ticks(self.e_finish_ticks-25)
        self.assertEqual(int(self.e_duration),len([d for d in self.vm.damage if d[1] is target and d[2]==50 and d[3]==self.vm.g['FrostnovaE_ID']]))
        self.assertFalse(any(d[1] is outside for d in self.vm.damage))
        self.assertEqual(0,self.state(key=2))
        self.assertNotIn(id(aura),self.vm.effects)
        self.vm.run('FrostnovaE_Start',(self.c,));self.ticks(26)
        field=self.state(key=2);aura=field.aura
        self.c.life=0;self.ticks(1)
        self.assertIsNone(field.aura)
        self.assertNotIn(id(aura),self.vm.effects)
        self.ticks(self.e_finish_ticks)
        self.assertEqual(set(),self.vm.groups)

    def test_e_has_one_burst_ring_and_preserves_saved_field_art(self):
        self.enemy(100)
        self.vm.run('FrostnovaE_Start',(self.c,));self.ticks(25)
        field=self.state(key=2);art=field.art;ground=field.art2
        self.assertEqual(self.vm.g['FrostnovaE_ModelScale'],art.scale)
        spikes=lambda:[e for e in self.vm.effect_history if 'wos_Frostnova_a (81)' in e.model]
        self.assertEqual(8,len(spikes()))
        self.ticks(26)
        self.assertIs(art,field.art)
        self.assertIn(id(art),self.vm.effects)
        self.assertIn(id(ground),self.vm.effects)
        self.ticks(self.e_finish_ticks-51)
        self.assertEqual(8,len(spikes()))
        self.assertEqual(int(self.e_duration)+1,len(self.vm.damage))
        self.assertEqual(0,self.state(key=2))

    def test_buff_resistance_and_healing_formulas_compose_with_existing_modifiers(self):
        systems1=(ROOT/'triggers/Systems/Systems1.j').read_text('utf-8-sig')
        systems2=(ROOT/'triggers/Systems/Systems2.j').read_text('utf-8-sig')
        text='\n'.join(re.search(r'function '+name+r' takes.*?endfunction',src,re.S)[0]
            for name,src in [('GetPhysRes',systems1),('GetMagRes',systems1),('GetHealMultiplierNoBlock',systems2)])
        vm=JassState(text.replace("static if ","if "))
        vm.g.update(LIBRARY_FrostnovaSpells=True,FrostnovaE_ResistBuffID='B0F0',FrostnovaE_HealCutBuffID='B0F1',
            FrostnovaE_Resist=.30,FrostnovaE_HealCut=.35,DamageBlock=lambda *a:.8,
            HeroChannelDamageFactor=lambda c:1.0,GetHealAmp=lambda u:0.0,GetHellBlazeCut=lambda u:0.0)
        u=vm.unit()
        self.assertAlmostEqual(20,vm.run('GetPhysRes',(u,)))
        vm.add_ability(u,'B0F0');vm.add_ability(u,'B0F1')
        self.assertAlmostEqual(44,vm.run('GetPhysRes',(u,)))
        self.assertAlmostEqual(44,vm.run('GetMagRes',(u,)))
        self.assertAlmostEqual(.65,vm.run('GetHealMultiplierNoBlock',(u,)))
        vm.add_ability(u,'B00K')
        self.assertAlmostEqual(.39,vm.run('GetHealMultiplierNoBlock',(u,)))

    def test_wave_hits_each_enemy_once_and_enhances_push(self):
        self.enemy(200);self.enemy(450)
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.vm.run('FrostnovaW_Start',(self.c,1000,0));self.ticks(45)
        self.assertEqual(2,len([d for d in self.vm.damage if d[3]==self.vm.g['FrostnovaW_ID']]))
        # 750 at the cast point, fading to x0.35 at max range: nearer enemy is pushed harder.
        near,far=[p[1] for p in self.vm.pulls]
        self.assertTrue(750*0.35<far<near<=750,(near,far))

    def test_tw_covers_near_and_far_gaps_and_damages_once_per_cast(self):
        targets=[self.enemy(20,0)]
        for distance in [200,800,1500]:
            for angle in [-15,0,15]:
                targets.append(self.enemy(distance*math.cos(math.radians(angle)),distance*math.sin(math.radians(angle))))
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.vm.run('FrostnovaW_Start',(self.c,1600,0));self.ticks(80)
        hits=[d[1] for d in self.vm.damage if d[3]==self.vm.g['FrostnovaW_ID']]
        self.assertCountEqual([id(u) for u in targets],[id(u) for u in hits])
        self.assertEqual(len(targets),len(self.vm.pulls))

    def test_e_damage_is_applied_on_the_same_tick_as_initial_push(self):
        target=self.enemy(200)
        self.vm.run('FrostnovaE_Start',(self.c,));self.ticks(24)
        self.assertEqual([],self.vm.damage);self.assertEqual([],self.vm.pulls)
        self.ticks(1)
        self.assertEqual([target],[d[1] for d in self.vm.damage])
        self.assertEqual([target],[p[0] for p in self.vm.pulls])
        self.assertEqual(200,self.vm.damage[0][2])

    def test_r_field_allows_blinks_and_dashes_unless_actually_rooted(self):
        radius=self.vm.g['FrostnovaR_Aoe']
        inside=self.enemy(radius-30,0);outside=self.enemy(radius+30,0)
        abilities=['A01B',self.vm.g['OkarunQ_ID'],self.vm.g['KiritoQ_ID']]
        self.vm.run('FrostnovaR_Start',(self.c,0,0))
        for ability in abilities:
            self.assertTrue(self.vm.run('DisableMoveRoot',(inside,ability)))
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.vm.run('FrostnovaR_Start',(self.c,0,0))
        for target in (inside,outside,self.c):
            for ability in abilities:
                with self.subTest(target=target.x,ability=ability):
                    self.assertTrue(self.vm.run('DisableMoveRoot',(target,ability)))
                    self.vm.add_ability(target,'BEer')
                    self.assertFalse(self.vm.run('DisableMoveRoot',(target,ability)))
                    self.assertTrue(self.vm.run('DisableMoveRoot',(target,self.vm.g['FrostnovaQ_ID'])))
                    target.protection=1
                    self.assertTrue(self.vm.run('DisableMoveRoot',(target,ability)))
                    target.protection=0
                    target.abilities.pop('BEer')
                    self.assertTrue(self.vm.run('DisableMoveRoot',(target,ability)))

    def test_tr_movement_unlocks_after_initial_and_exit_root_expire(self):
        target=self.enemy(900)
        radius=self.vm.g['FrostnovaR_Aoe']
        def root(c,u,duration):
            self.roots.append((u,duration))
            self.vm.add_ability(u,'BEer')
            self.buff_times[(id(u),'BEer')]=[u,duration]
        self.vm.g['RootUnit']=root
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.vm.run('FrostnovaR_Start',(self.c,0,0))
        self.assertFalse(self.vm.run('DisableMoveRoot',(target,'A01B')))
        self.ticks(34)
        self.assertTrue(self.vm.run('DisableMoveRoot',(target,'A01B')))
        target.x=radius+10
        self.ticks(4)
        self.assertEqual(2,len(self.roots))
        self.assertFalse(self.vm.run('DisableMoveRoot',(target,'A01B')))
        self.ticks(34)
        self.assertTrue(self.vm.run('DisableMoveRoot',(target,'A01B')))
        target.x=radius-10
        self.ticks(4)
        self.assertTrue(self.vm.run('DisableMoveRoot',(target,'A01B')))

    def test_tr_has_fixed_radius_initial_root_and_scheduled_random_extra_bursts(self):
        self.vm.g['GetRandomReal']=lambda a,b:(a+b)/2
        radius=self.vm.g['FrostnovaR_Aoe']
        center=-(radius-self.vm.g['FrostnovaTR_BurstAoe'])*math.sqrt(.5)
        target=self.enemy(center,0)
        outside=self.enemy(radius+20,0)
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.vm.run('FrostnovaR_Start',(self.c,0,0))
        self.assertEqual([(target,1.0)],self.roots)
        start=[e for e in self.vm.effect_history if e.model==self.vm.g['FrostnovaTR_StartModel']]
        self.assertEqual(1,len(start));self.assertEqual(self.vm.g['FrostnovaTR_StartScale'],start[0].scale)
        field=self.vm.structs['FrostnovaR_KS'].statics['active'][0]
        self.ticks(17);scale=field.art.scale
        self.ticks(100)
        self.assertEqual(radius,field.radius);self.assertEqual(scale,field.art.scale)
        self.ticks(167)
        bursts=[e for e in self.vm.effect_history if e.model==self.vm.g['FrostnovaTR_BurstModel']]
        expected=int(self.vm.g['FrostnovaR_Duration']/self.vm.g['FrostnovaTR_BurstPeriod'])
        self.assertEqual(expected,len(bursts))
        self.assertEqual(expected,len([d for d in self.vm.damage if d[1] is target and d[2]==50 and d[3]==self.vm.g['FrostnovaR_ID']]))
        self.assertFalse(any(d[1] is outside for d in self.vm.damage))
        self.assertEqual(radius,field.radius)
        self.assertEqual([],self.crystals)
        self.assertEqual(set(),self.vm.groups)

    def test_normal_r_has_neither_tr_start_effect_nor_root_nor_microbursts(self):
        self.enemy(100)
        self.vm.run('FrostnovaR_Start',(self.c,0,0));self.ticks(284)
        self.assertEqual([],self.roots)
        self.assertFalse(any(e.model in [self.vm.g['FrostnovaTR_StartModel'],self.vm.g['FrostnovaTR_BurstModel']] for e in self.vm.effect_history))

    def test_tr_traps_outward_movement_with_four_crystals_and_cleans_at_expiry(self):
        target=self.enemy(900)
        vm=self.vm
        vm.run('FrostnovaT_Start',(self.c,))
        vm.run('FrostnovaR_Start',(self.c,0,0))
        self.assertEqual([(target,1.)],self.roots)
        self.ticks(18)
        target.x=980
        self.ticks(4)
        self.assertEqual([(target,1.)],self.roots)  # Still inside: no exit root.
        target.x=vm.g['FrostnovaR_Aoe']+10
        self.ticks(4)
        crystal_model=vm.g['FrostnovaTR_CrystalModel']
        crystals=[e for e in vm.effect_history if e.model==crystal_model]
        self.assertEqual(4,len(crystals))
        self.assertEqual([(target,1.),(target,1.)],self.roots)
        for crystal in crystals:
            self.assertAlmostEqual(vm.g['FrostnovaTR_TrapRadius'],math.hypot(crystal.x-target.x,crystal.y-target.y))
            self.assertEqual(2.,crystal.scale)
        target.x=990
        self.ticks(4)
        self.assertEqual(4,len([e for e in vm.effect_history if e.model==crystal_model]))
        self.ticks(70)
        target.x=1000
        self.ticks(4)
        self.assertEqual(2,len(self.roots))
        self.assertEqual(4,len([e for e in vm.effect_history if e.model==crystal_model]))
        self.ticks(80)
        self.assertTrue(all(id(e) not in vm.effects for e in crystals))
        self.assertEqual(0,vm.structs['FrostnovaR_KS'].statics['count'])

    def test_tr_exit_band_does_not_root_blinks_beyond_it_or_enemies_entering_from_outside(self):
        radius=self.vm.g['FrostnovaR_Aoe']
        jumper=self.enemy(900)
        newcomer=self.enemy(radius+50)
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.vm.run('FrostnovaR_Start',(self.c,0,0))
        self.ticks(34)
        self.roots.clear()
        jumper.x=radius*3
        self.ticks(4)
        self.assertEqual([],self.roots)
        jumper.x=radius+20
        self.ticks(4)
        self.assertEqual([],self.roots)  # Returning from a long blink is not an exit.
        newcomer.x=radius-20
        self.ticks(4)
        self.assertEqual([],self.roots)
        newcomer.x=radius+20
        self.ticks(4)
        self.assertEqual([(newcomer,self.vm.g['FrostnovaTR_ExitRoot'])],self.roots)

    def test_f_activates_at_level_twelve_and_five_empowered_stacks_deal_75_percent_int(self):
        target=self.enemy()
        self.c.hero_level=11
        self.vm.run('Apply',(self.c,target,True))
        self.assertEqual(0,self.state(target,1))
        self.c.hero_level=12
        for _ in range(5):self.vm.run('Apply',(self.c,target,True))
        self.ticks(34)
        self.assertEqual(.75*self.c.intelligence,self.vm.damage[-1][2])

    def test_f_replaces_all_old_tiers_and_carries_normal_stacks_into_t(self):
        target=self.enemy()
        for rank in range(1,4):
            self.vm.run('Apply',(self.c,target,False))
            self.assertEqual(rank,self.state(target,1).stacks)
            self.assertEqual([self.vm.g['FrostnovaFBuff'][rank]],[b for b in self.vm.g['FrostnovaFBuff'][1:] if b in target.abilities])
        self.vm.run('Apply',(self.c,target,True))
        self.assertEqual(4,self.state(target,1).stacks)
        self.assertEqual([self.vm.g['FrostnovaFBuff'][9]],[b for b in self.vm.g['FrostnovaFBuff'][1:] if b in target.abilities])
        self.vm.run('Apply',(self.c,target,False))
        self.assertEqual(5,self.state(target,1).stacks)
        self.assertEqual([self.vm.g['FrostnovaFBuff'][10]],[b for b in self.vm.g['FrostnovaFBuff'][1:] if b in target.abilities])

    def test_f_recovers_native_stacks_if_tracking_record_is_missing(self):
        target=self.enemy()
        target.abilities[self.vm.g['FrostnovaFBuff'][3]]={'level':1}
        target.abilities[self.vm.g['FrostnovaFBuff'][6]]={'level':1}
        self.vm.run('Apply',(self.c,target,True))
        self.assertEqual(4,self.state(target,1).stacks)
        self.assertEqual([self.vm.g['FrostnovaFBuff'][9]],[b for b in self.vm.g['FrostnovaFBuff'][1:] if b in target.abilities])

    def test_f_waits_for_native_slow_order_without_resetting_stacks(self):
        target=self.enemy()
        self.vm.g['IssueTargetOrder']=lambda *args:True
        for _ in range(3):self.vm.run('Apply',(self.c,target,False))
        self.ticks(2)
        self.assertEqual(3,self.state(target,1).stacks)
        target.abilities[self.vm.g['FrostnovaFBuff'][3]]={'level':1}
        self.ticks(1)
        self.vm.run('Apply',(self.c,target,True))
        self.ticks(2)
        self.assertEqual(4,self.state(target,1).stacks)
        self.assertIn(self.vm.g['FrostnovaFBuff'][3],target.abilities) # Keep the old slow until the new buff arrives.
        target.abilities[self.vm.g['FrostnovaFBuff'][9]]={'level':1}
        self.ticks(1)
        self.assertNotIn(self.vm.g['FrostnovaFBuff'][3],target.abilities)
        target.abilities.pop(self.vm.g['FrostnovaFBuff'][9])
        self.vm.run('Apply',(self.c,target,True))
        self.assertEqual(1,self.state(target,1).stacks) # A real dispel still resets the count.

    def test_f_level_35_damage_has_one_flat_t_bonus_not_one_per_stack(self):
        for level,enhanced,stacks,damage in ((34,False,3,0.),(35,False,3,45.),(34,True,3,45.),(35,True,3,70.),(35,True,5,100.)):
            target=self.enemy()
            self.c.hero_level=level
            for _ in range(stacks):self.vm.run('Apply',(self.c,target,enhanced))
            data=self.state(target,1);data.pulse=0.
            before=len(self.vm.damage)
            self.vm.run('FrostnovaF_KS_Loop')
            hits=[d for d in self.vm.damage[before:] if d[1] is target]
            self.assertEqual([damage] if damage else [],[d[2] for d in hits])
            target.life=0
            self.vm.run('FrostnovaF_KS_Loop')

    def test_level_35_range_bonus_updates_native_fields_and_projectile_distances(self):
        writes=[]
        self.vm.g['BlzSetAbilityRealLevelField']=lambda a,f,l,v:writes.append((a,f,l,v))
        self.c.hero_level=34
        self.ticks(1)
        self.assertEqual([],writes)
        self.c.hero_level=35
        self.ticks(1)
        self.assertEqual([1650.,1700.,1750.,1800.,1850.],[v for a,f,l,v in writes if a is self.c.abilities[self.vm.g['FrostnovaQ_ID']]])
        self.assertEqual([1750.]*5,[v for a,f,l,v in writes if a is self.c.abilities[self.vm.g['FrostnovaW_ID']]])
        self.ticks(10)
        self.assertEqual(10,len(writes)) # Do not rewrite native fields every timer tick.
        self.vm.run('FrostnovaQ_Start',(self.c,2200.,0.))
        projectile=self.vm.structs['FrostnovaQ_KS'].statics['active'][0]
        self.assertEqual(1650.,projectile.distance)
        self.vm.run('FrostnovaW_Start',(self.c,2200.,0.))
        wave=self.vm.structs['FrostnovaW_KS'].statics['active'][0]
        self.assertEqual(1750.,wave.distance)
        self.c.hero_level=34
        self.ticks(1)
        self.assertEqual(20,len(writes))

    def test_w_level_25_speed_bonus_also_applies_to_all_three_t_waves(self):
        vm=self.vm
        for level,enhanced,multiplier in ((24,False,1.),(25,False,1.2),(35,True,1.2)):
            self.c.hero_level=level
            if enhanced:vm.run('FrostnovaT_Start',(self.c,))
            ns=vm.structs['FrostnovaW_KS'];before=ns.statics['count']
            vm.run('FrostnovaW_Start',(self.c,2200.,0.))
            waves=[ns.statics['active'][i] for i in range(before,ns.statics['count'])]
            self.assertEqual(3 if enhanced else 1,len(waves))
            self.assertTrue(all(abs(w.speed-1430.*.03*multiplier)<.0001 for w in waves))

    def test_q_w_stop_at_arena_edge_and_clean_up_instead_of_leaving_map(self):
        vm=self.vm;calls=[];move=vm.g['MoveEff2']
        vm.g['PathableCheck']=lambda x,y:x<=200.
        vm.g['MoveEff2']=lambda e,d,a:(calls.append((e,d)),move(e,d,a))
        vm.run('FrostnovaQ_Start',(self.c,2200.,0.))
        q=vm.structs['FrostnovaQ_KS'].statics['active'][0]
        vm.run('FrostnovaW_Start',(self.c,2200.,0.))
        w=vm.structs['FrostnovaW_KS'].statics['active'][0]
        self.ticks(45)
        self.assertGreater(len(calls),0)
        self.assertLessEqual(q.x,200.)
        self.assertLessEqual(w.x,200.)
        self.assertLess(w.radius,vm.g['FrostnovaW_Aoe'])
        self.assertEqual(0,vm.structs['FrostnovaQ_KS'].statics['count'])
        self.assertEqual(0,vm.structs['FrostnovaW_KS'].statics['count'])
        self.assertEqual(set(),vm.groups)

    def test_t_shield_native_duration_is_four_seconds_for_heroes_and_other_units(self):
        import war3_object_workspace as workspace
        docs,_=workspace.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
        for doc in docs:
            if doc['source_file'] not in ('war3map.w3a','war3mapSkin.w3a'):continue
            helper=next(o for o in doc['custom_objects'] if workspace.object_id(o)==self.vm.g['FrostnovaT_ShieldAbilityID'])
            durations={m['field']['text']:m['data']['value'] for m in helper['modifications'] if m['field']['text'] in ('adur','ahdu')}
            self.assertEqual({'adur':4.,'ahdu':4.},durations)

    def test_t_song_bar_counts_voice_then_shows_ready_and_restarts_with_shield(self):
        vm=self.vm;key=vm.g['FrostnovaT_ID'];shield=vm.g['FrostnovaT_ShieldBuffID']
        vm.run('FrostnovaT_Start',(self.c,))
        bar=self.dual_progress[-1]
        self.assertEqual(key,bar[1])
        self.assertEqual((20.,20.),bar[3:5])
        self.assertAlmostEqual(4.393,bar[5])
        self.assertIn('|cffffffff',bar[-1])
        self.ticks(150)
        self.assertIn('Shield Ready',self.dual_progress[-1][-1])
        self.assertNotIn(shield,self.c.abilities)
        vm.run('FrostnovaW_Start',(self.c,1500.,0.))
        self.assertIn(shield,self.c.abilities)
        self.ticks(1)
        self.assertAlmostEqual(4.08,self.dual_progress[-1][6])
        self.assertGreater(self.dual_progress[-1][5],4.)
        self.assertFalse(any(a[1]==vm.g['FrostnovaT_ShieldAbilityID'] for a in vm.progress_calls))
        self.c.life=0
        self.ticks(1)
        self.assertEqual((0.,0.),vm.progress_calls[-1][3:5])

    def test_t_shield_shared_loop_caps_lifetime_even_if_native_buff_does_not_expire(self):
        vm=self.vm;buff=vm.g['FrostnovaT_ShieldBuffID']
        vm.run('FrostnovaT_Start',(self.c,))
        self.buff_times.clear() # Simulate the reported native Frost Armor expiry failure.
        self.ticks(130)
        self.assertIn(buff,self.c.abilities)
        self.ticks(4)
        self.assertNotIn(buff,self.c.abilities)
        self.assertEqual(0.,self.state().shieldRemaining)
        self.ticks(15)
        vm.run('FrostnovaW_Start',(self.c,1500.,0.))
        self.assertIn(buff,self.c.abilities)
        self.buff_times.clear()
        self.assertEqual(4.,self.state().shieldRemaining)
        self.ticks(18) # W preparation pauses the hero and shield countdown.
        self.assertAlmostEqual(3.94,self.state().shieldRemaining)
        self.buff_times.clear()
        self.ticks(134)
        self.assertNotIn(buff,self.c.abilities)

    def test_t_duration_and_shield_freeze_while_paused_but_voice_finishes(self):
        vm=self.vm
        vm.run('FrostnovaT_Start',(self.c,))
        self.buff_times.clear()
        self.c.paused=True
        self.ticks(170)
        self.assertEqual(20.,self.state().scar)
        self.assertEqual(4.,self.state().shieldRemaining)
        self.assertEqual(0.,self.state().voiceRemaining)
        self.c.paused=False
        self.ticks(134)
        self.assertNotIn(vm.g['FrostnovaT_ShieldBuffID'],self.c.abilities)
        self.assertAlmostEqual(15.98,self.state().scar)

    def test_e_te_and_r_publish_small_timed_icons(self):
        vm=self.vm
        vm.run('FrostnovaT_Start',(self.c,))
        vm.run('FrostnovaE_Start',(self.c,))
        self.ticks(26)
        icons={a[2]:a for a in self.small_icons if a[1]>0}
        for name,slot in [('BTNHero_Frostnova_E',2),('BTNHero_Frostnova_TE',3)]:
            self.assertAlmostEqual(vm.g['FrostnovaE_Duration'],icons[name][1])
            self.assertEqual(slot,icons[name][3])
        vm.run('FrostnovaR_Start',(self.c,500.,0.))
        self.ticks(18)
        self.assertTrue(any(a[2]=='BTNHero_Frostnova_R' and a[1]>0 and a[3]==4 for a in self.small_icons))
        self.ticks(340)
        for name in ('BTNHero_Frostnova_E','BTNHero_Frostnova_TE','BTNHero_Frostnova_R'):
            self.assertTrue(any(a[2]==name and a[1]==0 for a in self.small_icons))

    def test_tr_detects_blink_into_outer_band_and_roots_only_once(self):
        vm=self.vm;radius=vm.g['FrostnovaR_Aoe']
        target=vm.unit(radius-100,0,1)
        vm.run('FrostnovaT_Start',(self.c,))
        vm.run('FrostnovaR_Start',(self.c,0.,0.))
        self.ticks(19)
        self.roots.clear()
        target.x=radius+vm.g['FrostnovaTR_ExitBand']*.75
        self.ticks(5)
        self.assertEqual(1,len(self.roots))
        self.assertEqual(1.,self.roots[0][1])
        self.ticks(15)
        self.assertEqual(1,len(self.roots))

    def test_rank_scaling_changes_q_recharge_range_and_r_lifetime(self):
        vm=self.vm
        for rank in range(1,6):
            self.c.abilities[vm.g['FrostnovaQ_ID']]['level']=rank
            vm.run('Frostnova_Register',(self.c,))
            self.assertEqual([2,2,4,4,6][rank-1],self.capacity())
            vm.run('SpellStacksSet',(self.c,1))
            self.state().qUsePause=0
            self.assertTrue(vm.run('FrostnovaQ_Start',(self.c,2000,0)))
            projectile=vm.structs['FrostnovaQ_KS'].statics['active'][0]
            self.assertEqual(1500+50*(rank-1),projectile.distance)
            self.assertEqual(18-rank,self.c.cooldown)
            self.ticks(30)
            vm.run('SpellStacksAdd',(self.c,1));self.ticks(1)
            self.assertEqual(0,self.c.cooldown)
            self.c.abilities[vm.g['FrostnovaR_ID']]['level']=rank
            vm.run('FrostnovaR_Start',(self.c,0,0))
            field=vm.structs['FrostnovaR_KS'].statics['active'][rank-1]
            self.assertEqual(3+rank,field.remaining)

    def test_projectile_speed_vision_and_decor_use_spell_aoe(self):
        vm=self.vm
        vm.run('FrostnovaQ_Start',(self.c,2000,0));self.ticks(1)
        projectile=vm.structs['FrostnovaQ_KS'].statics['active'][0]
        self.assertEqual(2310*.03,projectile.speed)
        self.assertEqual(300,self.vision[-1][3])
        self.assertEqual((150.,20.),self.decor[-1][-2:])
        vm.run('FrostnovaT_Start',(self.c,))
        vm.run('FrostnovaQ_Start',(self.c,2000,0))
        enhanced=vm.structs['FrostnovaQ_KS'].statics['active'][1]
        self.assertAlmostEqual(2310*1.3*.03,enhanced.speed)
        vm.run('FrostnovaW_Start',(self.c,2000,0));self.ticks(20)
        self.assertTrue(any(call[-1]==50 and call[-2]>=80 for call in self.decor))

    def test_e_first_burst_scales_two_to_six_and_has_one_decor_hit(self):
        vm=self.vm;target=self.enemy(100)
        self.c.hero_level=11
        for rank in range(1,6):
            self.c.abilities[vm.g['FrostnovaE_ID']]['level']=rank
            start=len(vm.damage);before=len(self.decor)
            vm.run('FrostnovaE_Start',(self.c,));self.ticks(25)
            self.assertEqual((rank+1)*100,vm.damage[start][2])
            self.assertEqual(before+1,len(self.decor))
            self.assertEqual((vm.g['FrostnovaE_Aoe'],50.),self.decor[-1][-2:])
            self.assertTrue(any(v[3]==vm.g['FrostnovaE_Aoe']*1.5 for v in self.vision))

    def test_normal_r_total_damage_and_decor_tick_once_each_second_at_all_ranks(self):
        vm=self.vm;target=self.enemy(100);self.c.hero_level=11
        for rank in range(1,6):
            self.c.abilities[vm.g['FrostnovaR_ID']]['level']=rank
            start=len(vm.damage);before=len(self.decor)
            vm.run('FrostnovaR_Start',(self.c,0,0))
            self.assertEqual(vm.g['FrostnovaR_Aoe']*1.5,self.vision[-1][3])
            self.ticks(math.ceil((.5+rank+3)/.03)+2)
            damage=[d for d in vm.damage[start:] if d[1] is target and d[3]==vm.g['FrostnovaR_ID']]
            self.assertEqual((rank+3)*100,sum(d[2] for d in damage))
            self.assertEqual(rank+3,len(self.decor)-before)
            self.assertTrue(all(d[-2:]==(vm.g['FrostnovaR_Aoe'],50.) for d in self.decor[before:]))

    def test_te_placeholder_attaches_refreshes_and_cleans_with_aura(self):
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.vm.run('FrostnovaE_Start',(self.c,));self.ticks(25)
        field=self.state(key=2);area=field.area
        self.assertEqual(self.vm.g['FrostnovaTE_AreaModel'],area.model)
        self.assertIn(id(area),self.vm.effects)
        self.vm.run('FrostnovaE_Start',(self.c,))
        self.assertNotIn(id(area),self.vm.effects)
        self.ticks(25);area=field.area
        self.c.life=0;self.ticks(1)
        self.assertIsNone(field.area);self.assertNotIn(id(area),self.vm.effects)

    def test_te_marker_lifetime_does_not_depend_on_inside_field_and_attachments_are_never_scaled(self):
        vm=self.vm;attached=set()
        create=vm.g['AddSpecialEffectTarget'];scale=vm.g['BlzSetSpecialEffectScale']
        def attach(*args):
            effect=create(*args);attached.add(id(effect));return effect
        def scale_world(effect,value):
            self.assertNotIn(id(effect),attached,'Attempted to scale a unit attachment')
            scale(effect,value)
        vm.g['AddSpecialEffectTarget']=attach
        vm.g['BlzSetSpecialEffectScale']=scale_world
        vm.run('FrostnovaT_Start',(self.c,))
        for _ in range(4):
            vm.run('FrostnovaE_Start',(self.c,));self.ticks(25)
            field=self.state(key=2);area=field.area
            self.assertEqual('stand',area.animation)
            self.assertIsNone(area.scale)
            self.ticks(5);self.assertIs(area,field.area)
            self.c.x+=2000;self.ticks(5)
            self.assertIs(area,field.area);self.assertIn(id(area),vm.effects)
        # The enhanced impact stays half-size as a world effect, not an attachment.
        self.enemy(self.c.x+250,110)
        vm.run('FrostnovaQ_Start',(self.c,self.c.x+1000,110));self.ticks(20)
        self.assertTrue(any(e.model==vm.g['FrostnovaTQ_ImpactModel'] and e.scale==.5 for e in vm.effect_history))

    def test_stacks_cap_frostbite_survives_normal_hit_and_dispels(self):
        u=self.enemy()
        for _ in range(8):self.vm.run('Apply',(self.c,u,True))
        self.assertEqual(5,self.state(u,1).stacks)
        self.vm.run('Apply',(self.c,u,False))
        self.assertTrue(self.state(u,1).empowered)
        self.ticks(34)
        self.assertEqual(5*self.c.intelligence*self.vm.g['FrostnovaTF_DamageInt'],self.vm.damage[-1][2])
        self.vm.remove_ability(u,self.state(u,1).buffId)
        self.ticks(1)
        self.assertEqual(0,self.state(u,1))

    def test_e_releases_only_owned_invulnerability_and_completes_saved_duration(self):
        self.enemy(100)
        self.vm.run('FrostnovaE_Start',(self.c,))
        self.assertIn('Avul',self.c.abilities)
        self.ticks(45)
        self.assertNotIn('Avul',self.c.abilities)
        self.ticks(self.e_finish_ticks-45)
        self.assertEqual(int(self.e_duration)+1,len(self.vm.damage))
        self.vm.add_ability(self.c,'Avul')
        self.vm.run('FrostnovaE_Start',(self.c,));self.ticks(20)
        self.assertIn('Avul',self.c.abilities)

    def test_rapid_e_recasts_reuse_one_field_group_and_two_effects(self):
        self.vm.run('FrostnovaE_Start',(self.c,))
        field = self.state(key=2)
        group = field.g
        for _ in range(100):
            self.c.x += 1
            self.vm.run('FrostnovaE_Start',(self.c,))
            self.assertIs(field,self.state(key=2))
            self.assertIs(group,field.g)
            self.assertEqual(1,self.vm.structs['FrostnovaE_KS'].statics['count'])
            self.assertEqual(1,len(self.vm.groups))
            self.assertEqual(2,len(self.vm.effects))
            self.assertEqual(2,self.vm.clock_users)
            self.ticks(1)
        self.assertEqual(self.c.x,field.x)
        self.ticks(self.e_finish_ticks)
        self.assertEqual(0,self.state(key=2))
        self.assertEqual(1,self.vm.clock_users)
        self.assertEqual(set(),self.vm.groups)
        self.assertEqual(self.orbit_effects(),self.vm.effects)
        self.assertNotIn('Avul',self.c.abilities)

    def test_e_recast_after_cleanup_has_no_stale_owner_or_immunity(self):
        for _ in range(6):
            self.vm.run('FrostnovaE_Start',(self.c,))
            self.assertTrue(self.state(key=2).alive)
            self.ticks(self.e_finish_ticks)
            self.assertEqual(0,self.state(key=2))
            self.assertNotIn('Avul',self.c.abilities)
        self.assertEqual(1,self.vm.clock_users)

    def test_repeated_e_on_enemy_bounds_debuffs_dummies_and_timer_users(self):
        target=self.enemy(100)
        for index in range(30):
            self.vm.run('FrostnovaE_Start',(self.c,))
            self.ticks(59)
            self.assertEqual(1,self.vm.structs['FrostnovaE_KS'].statics['count'])
            self.assertEqual(1,self.vm.structs['FrostnovaF_KS'].statics['count'])
            self.assertEqual(1,len(self.vm.groups))
            self.assertEqual(3,self.vm.clock_users)
            self.assertEqual(3,len(self.vm.units))  # caster, target, caster-owned dummy
            self.assertEqual(min(5,2*(index+1)),self.state(target,1).stacks)
        self.ticks(self.e_finish_ticks+200)
        self.assertEqual(1,self.vm.clock_users)
        self.assertEqual(set(),self.vm.groups)
        self.assertEqual(self.orbit_effects(),self.vm.effects)

    def test_two_casters_own_independent_e_fields_and_groups(self):
        other=self.vm.unit(200,0,0)
        other.type=self.c.type
        other.intelligence=100
        other.abilities[self.vm.g['FrostnovaE_ID']]={'level':1}
        self.vm.run('FrostnovaE_Start',(self.c,))
        self.vm.run('FrostnovaE_Start',(other,))
        first=self.state(key=2)
        second=self.state(other,key=2)
        self.assertIsNot(first,second)
        self.assertIsNot(first.g,second.g)
        self.ticks(101)
        self.vm.run('FrostnovaE_Start',(other,))
        self.ticks(self.e_finish_ticks-101)
        self.assertEqual(0,self.state(key=2))
        self.assertIs(second,self.state(other,key=2))
        self.ticks(102)
        self.assertEqual(2,self.vm.clock_users)

    def test_spell_structures_and_castcheck_entry_points_are_explicit(self):
        text=SOURCE.read_text('utf-8-sig')
        self.assertEqual(1,len(re.findall(r'(?m)^library ',text)))
        positions=[text.index(f'private struct Frostnova{slot}_KS') for slot in 'FQWERT']
        self.assertEqual(sorted(positions),positions)
        for slot in 'QWERT':
            body=re.search(r'private struct Frostnova'+slot+r'_KS\b.*?endstruct',text,re.S)[0]
            self.assertLess(body.index('static method Loop'),body.index('static method Start'))
        wrappers=text.index('// ==================== Q / W / E / R / T: CastCheck entry points')
        for slot in 'QWERT':
            self.assertGreater(text.index(f'function Frostnova{slot}_Start '),wrappers)
            self.assertIn(f'Frostnova{slot}_KS.Start(',text[wrappers:])
    def test_frostbite_includes_last_tick_and_releases_state(self):
        u=self.enemy()
        self.vm.run('Apply',(self.c,u,True))
        self.ticks(200)
        self.assertEqual(5,len(self.vm.damage))
        self.assertEqual(0,self.state(u,1))
        self.assertEqual(1,self.vm.clock_users)

    def test_enhanced_field_creates_no_crystals_and_cleans_timer_users(self):
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.vm.run('FrostnovaR_Start',(self.c,0,0))
        self.ticks(240)
        self.assertEqual([],self.crystals)
        self.ticks(428)  # Winter's Scar also finishes and releases its bar
        self.assertEqual([],self.crystals)
        self.assertEqual(1,self.vm.clock_users)
        self.assertEqual(self.orbit_effects(),self.vm.effects)

    def test_removed_caster_cleans_fields_missiles_and_state(self):
        self.vm.run('FrostnovaE_Start',(self.c,))
        self.vm.run('FrostnovaQ_Start',(self.c,1200,0))
        self.c.type=0
        self.ticks(1)
        self.assertEqual({id(entry[0]) for entry in self.vm.timed_effects}, self.vm.effects)
        self.ticks(51)
        self.assertEqual(0,self.vm.clock_users)
        self.assertEqual(set(),self.vm.effects)
        self.assertNotIn('Avul',self.c.abilities)

    def test_death_clears_mode_and_restores_charge_display(self):
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.vm.run('FrostnovaQ_Start',(self.c,1200,0))
        self.c.life=0
        self.vm.run('Frostnova_Death',(self.c,))
        self.assertEqual('2',self.c.counters[self.vm.g['FrostnovaQ_ID']])
        self.ticks(1)
        self.assertEqual(0,self.c.cooldown)
        self.ticks(40)
        self.assertEqual(0,self.state().scar)
        self.assertEqual(1,self.vm.clock_users)


    def test_q_voice_cycles_every_cast_and_always_plays_launch_hit(self):
        for clip in ['Q1','Q2','Q3','Q4','Q5','Q1']:
            self.vm.run('Frostnova_ResetForTest',(self.c,))
            self.vm.run('FrostnovaQ_Start',(self.c,1200,0))
            self.assertEqual([clip,'Q6'],self.sounds[-2:])
            self.ticks(100)
        self.vm.run('Frostnova_ResetForTest',(self.c,))
        self.vm.run('FrostnovaQ_Start',(self.c,1200,0))
        self.vm.run('FrostnovaQ_Start',(self.c,1200,0))
        self.assertEqual(['Q2','Q6','Q3','Q6'],self.sounds[-4:])
        self.enemy(200,110)
        self.vm.run('Frostnova_ResetForTest',(self.c,))
        self.vm.run('FrostnovaQ_Start',(self.c,1200,110))
        self.ticks(20)
        self.assertIn('Q7',self.sounds)

    def test_enhanced_voice_only_advances_on_cast_after_previous_line_finishes(self):
        self.vm.g['FrostnovaT_Duration']=24.0
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.vm.run('FrostnovaW_Start',(self.c,1200,0))
        self.vm.run('FrostnovaE_Start',(self.c,))
        self.vm.run('FrostnovaQ_Start',(self.c,1200,0))
        self.vm.run('FrostnovaR_Start',(self.c,0,0))
        self.assertEqual(['T1','T5','W2','E2','Q6','R2'],self.sounds)
        self.ticks(26)
        for sound in ['W3','E3','E4','R3']:self.assertIn(sound,self.sounds)
        self.assertFalse(any(x in self.sounds for x in ['W','E','R']))
        self.ticks(121)
        self.assertEqual(['T1'],[x for x in self.sounds if x in ['T1','T2','T3','T4']])
        self.vm.run('FrostnovaR_Start',(self.c,2000,0))
        self.vm.run('FrostnovaW_Start',(self.c,1200,0))
        self.assertEqual(['T1','T2'],[x for x in self.sounds if x in ['T1','T2','T3','T4']])
        self.ticks(136)
        self.assertNotIn('T3',self.sounds)
        self.vm.run('FrostnovaE_Start',(self.c,))
        self.assertEqual(['T1','T2','T3'],[x for x in self.sounds if x in ['T1','T2','T3','T4']])
        self.ticks(157)
        self.assertNotIn('T4',self.sounds)
        self.vm.run('FrostnovaQ_Start',(self.c,1200,0))
        self.assertEqual(['T1','T2','T3','T4'],[x for x in self.sounds if x in ['T1','T2','T3','T4']])
        self.ticks(177)
        self.vm.run('FrostnovaW_Start',(self.c,1200,0))
        self.assertEqual(['T1','T2','T3','T4','T2'],[x for x in self.sounds if x in ['T1','T2','T3','T4']])

    def test_enhanced_voice_queue_is_cleared_when_t_ends(self):
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.vm.run('FrostnovaW_Start',(self.c,1200,0))
        self.state().scar=.01
        self.ticks(22) # T survives the paused W preparation, then expires.
        self.ticks(180)
        self.assertNotIn('T2',self.sounds)





    def test_w_preparation_hand_pause_growth_and_death_cancel(self):
        target=self.enemy(400)
        self.vm.run('FrostnovaW_Start',(self.c,1200,0))
        wave=self.vm.structs['FrostnovaW_KS'].statics['active'][0]
        self.assertTrue(self.c.paused)
        self.assertIsNotNone(wave.hand)
        self.assertIsNone(wave.art)
        self.ticks(16)
        self.assertEqual([],self.vm.damage)
        self.assertTrue(self.c.paused)
        self.ticks(1)
        self.assertFalse(self.c.paused)
        self.assertIsNone(wave.hand)
        self.assertIsNotNone(wave.art)
        radius=wave.radius;scale=wave.art.scale
        self.ticks(10)
        self.assertGreater(wave.radius,radius)
        self.assertGreater(wave.art.scale,scale)
        self.assertEqual(['W','W2','W3'],self.sounds)
        self.vm.run('FrostnovaW_Start',(self.c,1200,0))
        self.c.life=0;self.ticks(1)
        self.assertFalse(self.c.paused)
        self.ticks(60)
        self.assertEqual(set(),self.vm.groups)

    def test_e_preparation_then_saved_duration_and_r_formation(self):
        self.enemy(100)
        self.vm.run('FrostnovaE_Start',(self.c,))
        self.ticks(24)
        self.assertTrue(self.c.paused)
        self.assertEqual([],self.vm.damage)
        self.assertIsNone(self.state(key=2).art)
        self.ticks(1)
        self.assertFalse(self.c.paused)
        self.assertEqual(['E','E2','E3','E4'],self.sounds)
        self.assertEqual(self.e_duration,self.state(key=2).remaining)
        self.ticks(self.e_finish_ticks-25)
        self.assertEqual(int(self.e_duration)+1,len(self.vm.damage))
        self.assertEqual(0,self.state(key=2))
        self.sounds.clear();self.vm.damage.clear()
        self.vm.run('FrostnovaR_Start',(self.c,0,0))
        self.assertEqual(['R','R2'],self.sounds)
        field=self.vm.structs['FrostnovaR_KS'].statics['active'][0]
        before=field.art.scale
        self.ticks(10)
        self.assertGreater(field.art.scale,before)
        self.assertEqual([],self.vm.damage)
        self.ticks(7)
        self.assertEqual(['R','R2','R3'],self.sounds)
        self.assertEqual(self.vm.g['FrostnovaR_Duration'],field.remaining)
        self.ticks(267)
        self.assertEqual(int(self.vm.g['FrostnovaR_Duration']),len(self.vm.damage))
        self.assertEqual(0,self.vm.structs['FrostnovaR_KS'].statics['count'])

    def test_t_keeps_white_orbit_adds_black_haze_and_uses_mixed_ice_in_flight(self):
        original=self.orbit_effects()
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.assertEqual(original,original & self.orbit_effects())
        self.assertEqual(4,len(self.orbit_effects()))
        for i in range(2):
            normal=self.vm.g['LoadEffectHandle'](self.vm.g['FrostnovaTable'],id(self.c),100+i)
            shadow=self.vm.g['LoadEffectHandle'](self.vm.g['FrostnovaTable'],id(self.c),200+i)
            self.assertEqual(self.vm.g['FrostnovaQ_Model'],normal.model)
            self.assertEqual(self.vm.g['FrostnovaTQ_ShadowModel'],shadow.model)
            self.assertAlmostEqual(35,math.hypot(normal.x-shadow.x,normal.y-shadow.y))
            self.assertAlmostEqual(normal.z-10,shadow.z)
        self.c.invisible=True;self.ticks(1)
        self.assertEqual(0,shadow.alpha)
        self.c.invisible=False
        self.vm.run('FrostnovaQ_Start',(self.c,1200,0))
        projectile=self.vm.structs['FrostnovaQ_KS'].statics['active'][0]
        self.assertEqual(self.vm.g['FrostnovaTQ_Model'],projectile.art.model)
        self.assertEqual(self.vm.g['FrostnovaTQ_ShadowModel'],projectile.shadow.model)
        self.ticks(1)
        self.assertAlmostEqual(55,math.hypot(projectile.art.x-projectile.shadow.x,projectile.art.y-projectile.shadow.y))
        self.assertAlmostEqual(projectile.art.z-10,projectile.shadow.z)
        self.ticks(668)
        self.assertFalse(self.state().darkShards)
        self.assertEqual(2,len(self.orbit_effects()))
        self.assertEqual(self.orbit_effects(),self.vm.effects)

    def test_late_cooldown_write_after_refill_is_repaired(self):
        self.vm.run('SpellStacksSet',(self.c,0));self.ticks(1)
        self.vm.run('SpellStacksAdd',(self.c,1));self.ticks(1)
        self.assertEqual(1,self.charges())
        self.c.cooldown=6
        self.ticks(1)
        self.assertEqual(0,self.c.cooldown)
        self.vm.run('FrostnovaQ_Start',(self.c,1200,0));self.ticks(1)
        self.assertEqual(0,self.charges())
        self.assertGreater(self.c.cooldown,5)

    def test_last_charge_cannot_regenerate_between_cast_and_deferred_callback(self):
        self.vm.run('SpellStacksSet',(self.c,1))
        self.ticks(1)
        self.assertTrue(self.vm.run('FrostnovaQ_Start',(self.c,1200,0)))
        self.assertEqual(0,self.charges())
        self.assertGreater(self.c.cooldown,0)
        # Force the shared 0.05 listener before the pending 0.03 callback.
        self.vm.run('Loop_AddSpellStacks')
        self.assertEqual(0,self.charges())
        for _ in range(20):
            self.assertFalse(self.vm.run('FrostnovaQ_Start',(self.c,1200,0)))
        self.assertEqual(1,self.vm.structs['FrostnovaQ_KS'].statics['count'])
        self.ticks(1)
        self.assertEqual(0,self.charges())

    def test_zero_native_cooldown_does_not_create_charge_inside_q_cast(self):
        self.vm.run('SpellStacksSet',(self.c,0))
        self.c.cooldown=0
        self.assertFalse(self.vm.run('FrostnovaQ_Start',(self.c,1200,0)))
        self.assertEqual(0,self.charges())

    def test_normal_voices_never_wait_and_t1_always_plays(self):
        self.state().voiceRemaining=100
        self.vm.run('FrostnovaQ_Start',(self.c,1200,0))
        self.vm.run('FrostnovaW_Start',(self.c,1200,0))
        self.vm.run('FrostnovaE_Start',(self.c,))
        self.vm.run('FrostnovaR_Start',(self.c,0,0))
        self.assertEqual(['Q1','Q6','W','W2','E','E2','R','R2'],self.sounds)
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.assertEqual(['T1','T5'],self.sounds[-2:])
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.assertEqual(['T1','T5','T1','T5'],self.sounds[-4:])
        self.assertEqual(20,self.state().scar)

    def test_main_and_saved_profile_object_levels_match(self):
        # MAIN can advance after transfer while another hero owns TEST.
        ids=json.loads((ROOT/'object-data/frostnova-ids.json').read_text())
        for base in [ROOT/'object-data',ROOT/'test_map/profiles/Frostnova/object-data']:
            if not base.is_dir():
                continue
            abilities=json.loads((base/'abilities.json').read_text('utf8'))
            for slot in 'QWERTF':
                obj=abilities[ids[slot]]
                self.assertEqual(1 if slot in 'TF' else 5,obj.get('levels',1))
                if slot!='F':
                    for rank in range(1,obj.get('levels',1)+1):
                        self.assertEqual(0.0,obj.get(f'follow_through_time level {rank}',0.0))
                        cost=0 if base.name=='object-data' and base.parent.name=='Frostnova' else {'Q':70,'W':90+15*(rank-1),'E':125,'R':125+15*(rank-1),'T':225}[slot]
                        self.assertEqual(cost,obj.get(f'mana_cost level {rank}',0))

    def test_t_reduces_three_cooldowns_updates_icons_and_renews_native_shield(self):
        cooldowns={self.vm.g['Frostnova'+slot+'_ID']:value for slot,value in zip('WER',(7.,15.,30.))}
        self.vm.g['BlzGetUnitAbilityCooldownRemaining']=lambda u,a:cooldowns.get(a,0.)
        self.vm.g['BlzStartUnitAbilityCooldown']=lambda u,a,t:cooldowns.update({a:t})
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.assertEqual([0.,5.,20.],[cooldowns[self.vm.g['Frostnova'+s+'_ID']] for s in 'WER'])
        buff=self.vm.g['FrostnovaT_ShieldBuffID']
        self.assertIn(buff,self.c.abilities)
        for slot in 'QWER':
            self.assertTrue(self.c.abilities[self.vm.g['Frostnova'+slot+'_ID']]['icon'].endswith('_T'+slot+'.blp'))
        self.c.abilities.pop(buff)
        self.state().voiceRemaining=0
        self.vm.run('FrostnovaQ_Start',(self.c,1000,0))
        self.assertIn(buff,self.c.abilities)
        self.assertIn('T2',self.sounds)
        self.c.abilities.pop(buff)
        self.vm.run('FrostnovaW_Start',(self.c,1000,0))
        self.assertNotIn(buff,self.c.abilities)  # Speech lock: no line, no renewal.
        self.state().scar=.01
        self.ticks(22) # T survives the paused W preparation, then expires.
        for slot in 'QWER':
            self.assertTrue(self.c.abilities[self.vm.g['Frostnova'+slot+'_ID']]['icon'].endswith('_'+slot+'.blp'))

    def test_each_song_continuation_recasts_shield_through_buffunit01(self):
        vm=self.vm;target=self.enemy(100)
        vm.run('FrostnovaT_Start',(self.c,))
        buff=vm.g['FrostnovaT_ShieldBuffID']
        for expected in ('T2','T3','T4'):
            self.c.abilities.pop(buff,None)
            self.state().voiceRemaining=0
            self.state().Voice(True)
            self.assertEqual(expected,self.sounds[-1])
            vm.run('Apply',(self.c,target,True))
            self.assertIn(buff,self.c.abilities)
            self.assertEqual(4.,self.buff_times[(id(self.c),buff)][1])
        shields=[cast for cast in self.buff_casts if cast[1]=='frostarmor']
        self.assertEqual(4,len(shields))
        self.assertTrue(all(cast[0]==vm.g['FrostnovaT_ShieldAbilityID'] and cast[2] is self.c for cast in shields))

    def test_song_refresh_keeps_existing_shield_until_native_recast_and_starts_recognizes_it(self):
        vm=self.vm;vm.run('FrostnovaT_Start',(self.c,))
        buff=vm.g['FrostnovaT_ShieldBuffID']
        self.state().voiceRemaining=0;self.state().Voice(True)
        self.assertIn(buff,self.c.abilities)
        source=(ROOT/'triggers/WOS_Start/Starts.j').read_text('utf-8-sig')
        function=re.search(r'function HasFullShieldVisual takes.*?endfunction',source,re.S)[0]
        visual=JassState(function.replace('static if LIBRARY_FrostnovaSpells then','if true then'))
        visual.g.update(hs={},KEY_INVUL=1,KEY_SHIELD=2,KEY_TOMIOKA_F_INVUL=3,
            TurboNeko_Invul_ID='notPresent',FrostnovaT_ShieldBuffID=buff)
        self.assertTrue(visual.run('HasFullShieldVisual',(self.c,)))

    def test_tr_burst_really_damages_inside_450_and_excludes_outside(self):
        self.vm.g['GetRandomReal']=lambda a,b:0.
        inside=self.enemy(425,0);outside=self.enemy(475,0)
        self.vm.run('FrostnovaT_Start',(self.c,))
        self.vm.run('FrostnovaR_Start',(self.c,0,0))
        self.ticks(31)  # Formation + first burst; before the first normal pulse.
        damage=[d for d in self.vm.damage if d[3]==self.vm.g['FrostnovaR_ID']]
        self.assertTrue(any(d[1] is inside and d[2]==50 for d in damage))
        self.assertFalse(any(d[1] is outside for d in damage))

    def test_t_shield_consumes_only_one_damage_instance_in_real_damage_hook(self):
        text=(ROOT/'triggers/Systems/DmgSys.j').read_text('utf-8-sig')
        block=re.search(r'        if isEnemy and dmg > 0.0 and GetUnitAbilityLevel\(td, FrostnovaT_ShieldBuffID\).*?        endif',text,re.S)[0]
        vm=JassState('function Hit takes unit c, unit td, real dmg returns real\n'+block+'\nreturn dmg\nendfunction')
        vm.g.update(isEnemy=True,shieldPen=False,penetrationTrigger=0.,typedmg=1,DAMAGE_SHIELD_TYPE_ALL=0,
            FrostnovaT_ShieldBuffID=self.vm.g['FrostnovaT_ShieldBuffID'],ApplyFullDamageShield=lambda *args:0.)
        self.vm.run('FrostnovaT_Start',(self.c,))
        attacker=self.enemy()
        self.assertEqual(0.,vm.run('Hit',(attacker,self.c,100.)))
        self.assertEqual(100.,vm.run('Hit',(attacker,self.c,100.)))


if __name__=='__main__':unittest.main()
