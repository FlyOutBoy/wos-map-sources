"""Execute changed hero paths; native rendering and multiplayer require Warcraft."""
from collections import defaultdict
from pathlib import Path
from types import SimpleNamespace
import json
import math
import re
import unittest

from test_crocodile import JassState
import test_ui_followup as progress_fixture

ROOT = Path(__file__).resolve().parents[1]
def source(path):
    return (ROOT / 'triggers' / path).read_text(encoding='utf-8-sig')


class HeroBalanceFollowup(unittest.TestCase):
    def test_takaoni_flies_past_cage_but_both_slashes_stay_at_its_center(self):
        text=source('Heroes/Kyoraku.j')
        declarations='\n'.join(re.findall(r'(?m)^        (?:integer|real) KyorakuE(?:4_\w+|_ID|_DamageAoe) = [^\n]+',text))
        body=text.split('    private struct KyorakuE4_KS',1)[1].split('    endstruct',1)[0]
        text='globals\n'+declarations+'\nendglobals\n    private struct KyorakuE4_KS\n'+body+'\n    endstruct'
        for start,center in (((0.,0.),(300.,400.)), ((900.,0.),(300.,0.)), ((300.,400.),(300.,400.))):
            vm=JassState(text);hero=vm.unit(owner=0,x=start[0],y=start[1])
            enemy=vm.unit(owner=1,x=center[0],y=center[1]);hero.facing=90.
            effects=[];blue=[];availability=[];hit_positions=[];hit_ticks=[];tick=[0];stops=[]
            vm.g.update(hs={},SH_KYORAKU_E4_CAGE='kyoraku e4 cage',SH_KYORAKU_E4_X='kyoraku e4 x',SH_KYORAKU_E4_Y='kyoraku e4 y',
                        GAngle2=lambda u,x,y:math.atan2(y-u.y,x-u.x),GetUnitFacing=lambda u:u.facing,
                        SetUnitFacing=lambda u,a:setattr(u,'facing',a),SetUnitAnimationByIndex=lambda *_:None,
                        SetUnitTimeScale=lambda *_:None,KyorakuTick_On=lambda *_:None,KyorakuTick_Off=lambda *_:None,
                        EffectSpawnColor3=lambda *a:effects.append(a),DamageSource=lambda *_:None,
                        EffectSpawn3=lambda *a:blue.append(a),
                        StopSpellUnit2=lambda *_:stops.append(tick[0]),
                        SetPlayerAbilityAvailable=lambda *a:availability.append(a),
                        DisplayTimedTextToPlayer=lambda *_:self.fail('valid cage rejected'))
            # Initialize the struct globals; the fixture does not parse private arrays.
            ns=vm.structs['KyorakuE4_KS'];ns.statics.update(MUI_KyorakuE4=-1,m_KyorakuE4={})
            for key,value in (('kyoraku e4 cage',1),('kyoraku e4 x',center[0]),('kyoraku e4 y',center[1])):
                vm.g['hs'][id(hero),key]=value
            vm.run('KyorakuE4_Start',(hero,));data=ns.m_KyorakuE4[0]
            def slash():
                hit_positions.append((hero.x,hero.y));hit_ticks.append(tick[0])
                vm.run('slash',obj=data)
            data.slash=slash
            data.deallocate=lambda *_:None
            angle=math.atan2(center[1]-start[1],center[0]-start[0]) if start!=center else math.pi/2
            for _ in range(100):
                tick[0]+=1
                vm.run('Loop_KyorakuE4')
                if ns.MUI_KyorakuE4==-1:break
            self.assertEqual(-1,ns.MUI_KyorakuE4)
            self.assertAlmostEqual(center[0]+650*math.cos(angle),hero.x)
            self.assertAlmostEqual(center[1]+650*math.sin(angle),hero.y)
            self.assertEqual(4,len(effects))
            self.assertTrue(all(a[1:3]==center for a in effects))
            self.assertEqual([1.44,7.2,1.44,7.2],[round(a[5],2) for a in effects])
            self.assertEqual(hit_ticks[0],hit_ticks[1])
            self.assertLessEqual(math.dist(hit_positions[0],center),100.)
            self.assertEqual([tick[0]],stops)  # Released on the final flight tick, without a slash pause.
            self.assertEqual([(1,175,45),(1,175,-45)],[(a[5],a[6],a[7]) for a in blue])
            self.assertEqual(2,len(vm.damage))
            self.assertTrue(all(hit[1] is enemy for hit in vm.damage))
            self.assertEqual([(0,vm.g['KyorakuE4_ID'],False),(0,vm.g['KyorakuE_ID'],True)],availability)

    def test_takaoni_encoded_object_has_native_presentation_without_skin_record(self):
        import war3_object_workspace as workspace
        import war3_object_data as raw
        from stage_items_2026_10_18 import configure_takaoni
        docs,_=workspace.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
        configure_takaoni(docs,'A114')
        first=json.dumps(docs,sort_keys=True)
        configure_takaoni(docs,'A114')
        self.assertEqual(first,json.dumps(docs,sort_keys=True))
        for doc in docs:
            if doc['source_file'] not in ('war3map.w3a','war3mapSkin.w3a'):continue
            encoded=raw.encode_object_file(doc,doc['source_file'])
            decoded=raw.parse_object_file(encoded,doc['source_file'],doc['kind'],doc['record_mode'],{})
            found=[o for o in decoded['custom_objects'] if workspace.object_id(o)=='A114']
            if doc['source_file']=='war3mapSkin.w3a':
                self.assertFalse(found);continue
            fields={(m['field']['text'],m['level']):workspace.value_for_user(m) for m in found[0]['modifications']}
            self.assertEqual((2,2),(fields['abpx',0],fields['abpy',0]))
            self.assertEqual('ReplaceableTextures\\CommandButtons\\BTNHero_Kyoraku_E2.blp',fields['aart',0])
            for level in range(1,6):
                self.assertIn('Takaoni',fields['atp1',level])
                self.assertIn('650 range past its center',fields['aub1',level])

    def test_bazz_tiers_and_every_damage_site_applies_fire_only_at_35(self):
        text=source('Heroes/BazzB.j');vm=JassState(text);hero=vm.unit(owner=0)
        cuts=[];vm.g['ReduceCooldown']=lambda *a:cuts.append(a)
        for level,amount in ((11,0.),(12,1.),(25,1.5),(35,2.)):
            hero.hero_level=level;cuts.clear()
            vm.run('BazzBPass_Start',(hero,vm.g['BazzBQ_ID']))
            self.assertEqual(4 if amount else 0,len(cuts))
            self.assertTrue(all(a[2]==amount and a[1]!=vm.g['BazzBQ_ID'] for a in cuts))
        hits=re.findall(r'call dmgmag\(c, u, dmg\)\s+if GetHeroLevel\(c\) >= 35 then\s+call ErzaPassive\(c, u, 1\)\s+endif',text)
        self.assertEqual(text.count('call dmgmag(c, u, dmg)'),len(hits))
        self.assertEqual(6,len(hits));self.assertEqual(1.2,vm.g['BazzBR_CastTime'])
        fire=[];code='function Hit takes nothing returns nothing\n'+hits[0]+'\nendfunction'
        hit=JassState(code);hit.g.update(c=hero,u=hero,dmg=1.,dmgmag=lambda *_:None,ErzaPassive=lambda *a:fire.append(a))
        hero.hero_level=34;hit.run('Hit');self.assertFalse(fire)
        hero.hero_level=35;hit.run('Hit');self.assertEqual([(hero,hero,1)],fire)

    def test_gojo_panel_changes_from_free_seconds_to_mana_percent(self):
        loop=source('Heroes/Gojo.j').split('method Loop_GojoE takes',1)[1]
        a=loop.index('                    if GetUnitAbilityLevel(c, GojoE_ID) >= 5 then')
        b=loop.index('                else\n                        call WUI_HeroProgress',a)
        vm=JassState('function Display takes nothing returns nothing\n'+loop[a:b]+'endfunction')
        hero=vm.unit(owner=0);vm.add_ability(hero,'E');hero.abilities['E']['level']=5
        hero.mana=700.;hero.max_mana=1000.;calls=[]
        vm.g.update(c=hero,GojoE_ID='E',r=1.97,rmax=2.,UNIT_STATE_MANA='mana',UNIT_STATE_MAX_MANA='max_mana',
                    GetUnitState=lambda u,k:getattr(u,k),R2SW=lambda v,_,n:f'{v:.{n}f}',
                    WUI_HeroProgress=lambda *a:calls.append(a),WUI_HeroProgressText=lambda *a:calls.append(a))
        vm.run('Display');self.assertEqual('Eternity: free time',calls[-1][2]);self.assertAlmostEqual(.03,calls[-1][3])
        vm.g['r']=2.;vm.run('Display')
        self.assertEqual(('Eternity: mana',700.,1000.,False,'70.0% MP'),calls[-1][2:])

    def test_object_cast_range_and_shiki_description_match_main_mechanics(self):
        objects=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
        self.assertEqual([900.,1000.,1100.,1200.,1300.],[objects['A0GQ'][f'cast_range level {i}'] for i in range(1,6)])
        self.assertEqual(2100.,objects['A09I']['cast_range level 1'])
        self.assertIn('Radius:|r 250',objects['A09I']['extended_tooltip level 1'])
        self.assertIn('DarkShikiT_DamageAgiBase, 0.0, T_Rad(DarkShikiT_AoE)',source('WOS_Start/UniversalTooltips.j'))
        for level in range(1,6):
            self.assertEqual(600.,objects['A0HH'][f'area_of_effect level {level}'])
            self.assertEqual(objects['A01P'][f'options level {level}'],objects['A0HH'][f'options level {level}'])

    def test_gojo_free_period_exact_drain_low_mana_and_cancel(self):
        text = source('Heroes/Gojo.j')
        loop = text.split('method Loop_GojoE takes', 1)[1]
        code = loop[loop.index('                if GetUnitAbilityLevel(c, GojoE_ID) >= 5 then'):loop.index('                    set x = GetUnitX(c)')]
        code += '\n                endif\n'
        vm = JassState('function Step takes nothing returns nothing\n' + code + 'endfunction')
        for maximum in (1000., 20000.):
            hero = vm.unit(owner=0)
            hero.mana, hero.max_mana = maximum, maximum
            vm.add_ability(hero, 'E');hero.abilities['E']['level']=5
            # An actual drain must bypass SetMpCurrent, whose Inori modifier changes negative deltas.
            vm.g.update(c=hero, b=False, r=0., rmax=2., GojoE_ID='E', GojoE_Lvl5Manacost=10.,
                        hs={}, UNIT_STATE_MANA='mana', UNIT_STATE_MAX_MANA='max_mana',
                        GetUnitState=lambda u,k:getattr(u,k),
                        SetUnitState=lambda u,k,v:setattr(u,k,v),
                        SetMpCurrent=lambda *_:self.fail('mana cost went through the restore modifier'))
            for _ in range(66): vm.run('Step')
            self.assertAlmostEqual(maximum, hero.mana)
            vm.run('Step')  # 1.98 -> 2.01: only .01 seconds are paid.
            self.assertAlmostEqual(maximum*.999,hero.mana)
            vm.g['r']=2.;hero.mana=maximum
            for _ in range(100): vm.run('Step')
            self.assertAlmostEqual(maximum * .70, hero.mana, places=6)
            self.assertTrue(vm.g['b'])  # Still running after the former max duration.
            hero.mana = 99.99
            vm.run('Step')
            self.assertFalse(vm.g['b'])
            hero.mana = 100.
            vm.run('Step')
            self.assertTrue(vm.g['b'])
            vm.g['hs'][id(hero), 'turn off e'] = 1
            vm.run('Step')
            self.assertFalse(vm.g['b'])

    def test_milim_thresholds_are_aggregate_and_gated_at_35(self):
        vm = JassState(source('Heroes/Milim.j'))
        hero = vm.unit(owner=0)
        vm.g.update(hs={}, I2R=float)
        thresholds = [vm.g[f'MilimG_DamagetoStats{i}'] for i in (1,2,3)]
        for level in (34,35):
            hero.hero_level = level
            for amount, count in ((0.,0), (thresholds[0]-.01,0), (thresholds[0],1),
                                  (thresholds[1],2), (thresholds[2],3)):
                vm.g['hs'][id(hero), 'milim g dmg'] = amount
                self.assertEqual(1.0*count if level==35 else 0., vm.run('MilimT2_GetThresholdBonus',(hero,)))
        body = source('Heroes/Milim.j').split('method MilimT2_Start takes',1)[1].split('endmethod',1)[0]
        self.assertIn('(MilimT2_DamageAgiBase + thresholdBonus) / I2R(MilimT2_DamageTicks)',body)

    def test_threshold_markers_reuse_frames_and_keep_nonowner_hidden(self):
        fx = progress_fixture.Progress(); fx.setUp(); vm = fx.vm
        vm.g.update(WUI_Piece=lambda *a:vm.g['BlzCreateFrameByType'](*a), BlzFrameSetLevel=lambda *_:None,
                    LoadFrameHandle=lambda t,k,c:t.get((k,c)),SaveFrameHandle=lambda t,k,c,v:t.update({(k,c):v}))
        fx.show(aid=10)
        vm.run('WUI_HeroProgressThresholds',(fx.hero,10,10500.,3500.,7000.,10500.,False))
        panel = vm.g['WUI_ProgressPanel'][1]
        marks = [vm.g['WUI_MeterEdges'][id(panel),30+i] for i in range(3)]
        self.assertEqual([True,True,False],[fx.visible[m] for m in marks])  # Bar edge is already the last threshold.
        created = len(fx.created)
        vm.run('WUI_HeroProgressThresholds',(fx.hero,10,3500.,3500.,7000.,10500.,False))
        self.assertEqual([False,False,False],[fx.visible[m] for m in marks])
        self.assertEqual(created,len(fx.created))
        pins=[];vm.g['WUI_Pin']=lambda *a:pins.append(a)
        vm.run('WUI_HeroProgressThresholds',(fx.hero,10,10500.,3500.,7000.,10500.,True))
        self.assertEqual(6,len(pins))  # Each threshold has a tick above and below the row.
        for top,bottom in zip(pins[::2],pins[1::2]):
            self.assertAlmostEqual(.0005+.0040+.0013,top[3])
            self.assertAlmostEqual(.0005-.0040-.0013,bottom[3])
        fx.local=1
        fx.show(aid=11)
        vm.run('WUI_HeroProgressThresholds',(fx.hero,11,3000.,1000.,2000.,3000.,True))
        panel2=vm.g['WUI_ProgressPanel'][2]
        self.assertFalse(any(fx.visible[vm.g['WUI_MeterEdges'][id(panel2),30+i]] for i in range(3)))

    def test_akainu_aims_only_five_of_thirty_six_with_minimum_interval(self):
        vm=JassState(source('Heroes/Akainu.j'))
        hero=vm.unit(owner=0); enemy=vm.unit(owner=1,x=400,y=200)
        ally=vm.unit(owner=0,x=100,y=100)
        data=vm.structs['AkainuSpells_T'].create()
        data.c=hero;data.x=data.y=0.;data.r=1.8;data.r2=data.r3=0.
        data.check=data.aimed=0;data.aoe=2000.;data.rmax=25.;data.targets=vm.g['CreateGroup']()
        data.e=data.e2=data.e3=None;data.a=0.
        data.deallocate=lambda *_:None
        data.AkainuTimer03Release=lambda:None
        vm.structs['AkainuSpells_T'].statics.update(MUI_AkainuT=0,m_AkainuT={0:data})
        hits=[]
        vm.g.update(I2R=float,WUI_HeroProgress=lambda *_:None,
                    AkainuSpells_T2=SimpleNamespace(AkainuT2_Start=lambda c,x,y:hits.append((data.r,x,y))),
                    AkainuTimer03Release=lambda:None)
        for _ in range(181): vm.run('Loop_AkainuT')
        self.assertEqual(36,len(hits))
        self.assertEqual(5,sum((x,y)==(enemy.x,enemy.y) for _,x,y in hits))
        self.assertTrue(all(b[0]-a[0]>=.15-1e-8 for a,b in zip(hits,hits[1:])))
        self.assertFalse(any((x,y)==(ally.x,ally.y) for _,x,y in hits))
        self.assertIsNone(data.targets)

    def test_natsu_cleans_only_allied_fire_once_and_counts_cooldowns(self):
        text=source('Heroes/Natsu.j').split('private struct NatsuG_KS',1)[1]
        a=text.index('                    call GroupClear( g )');b=text.index('                    set u = null',a)
        vm=JassState('function Absorb takes nothing returns nothing\n'+text[a:b]+'endfunction')
        hero=vm.unit(owner=0);ally=vm.unit(owner=0,x=50);enemy=vm.unit(owner=1,x=50)
        for u in (hero,ally,enemy):
            vm.add_ability(u,'fire');vm.add_ability(u,'water')
        sphere=vm.unit(owner=1,x=40);sphere.type='sphere';vm.add_ability(sphere,'Avul')
        rewards=[]
        vm.g.update(c=hero,u=None,x=0.,y=0.,aoe=1600.,g=vm.g['CreateGroup'](),check=0,check2=0,ErzaFire_ID='fire',Fire_ID='sphere',
                    NatsuQ_ID='Q',NatsuW_ID='W',NatsuE_ID='E',NatsuG_CdReduceTime=2.,
                    SetMpCurrent=lambda *a:rewards.append(a),ReduceCooldown=lambda *a:rewards.append(a),
                    IsUnitAlly=lambda u,p:u.owner==p,MUE=lambda *_:None,SetAnim=lambda *_:None,
                    PauseUnit=lambda *_:None,MyRemoveUnit=lambda *_:None,GAngle2=lambda *_:0.)
        vm.run('Absorb');vm.run('Absorb')
        self.assertEqual(2,vm.g['check2']);self.assertEqual(1,vm.g['check'])
        self.assertEqual(0,vm.g['GetUnitAbilityLevel'](hero,'fire'))
        self.assertEqual(0,vm.g['GetUnitAbilityLevel'](ally,'fire'))
        self.assertEqual(1,vm.g['GetUnitAbilityLevel'](enemy,'fire'))
        self.assertTrue(all(vm.g['GetUnitAbilityLevel'](u,'water')==1 for u in (hero,ally,enemy)))
        self.assertEqual(1,rewards.count((hero,100)))
        for ability in ('Q','W','E'):
            self.assertEqual(3,rewards.count((hero,ability,2.)))  # Applied immediately per absorbed flame.
        self.assertEqual(10,len(rewards))  # The repeated scan must not reward consumed flames twice.

    def test_laxus_absorbs_lightning_before_any_reaction_or_dummy(self):
        vm=JassState(re.sub(r'//[^\n]*','',source('Systems/DecorDestroy_and_Erza_Debuff.j')))
        hero=vm.unit(owner=1);hero.type='laxus';caster=vm.unit(owner=0)
        mana=[];cooldowns=[]
        vm.g.update(GearDamageNextSource=0,DummyPlayer2=defaultdict(lambda:None),hs={},Player=lambda p:p,GetPlayerId=lambda p:p,
                    IsUnitVisible=lambda *_:True,Laxus_ID='laxus',LaxusG_ID='G',LaxusQ_ID='Q',LaxusQ2_ID='Q2',
                    Laxus_LightningManaRestore=120.,Laxus_LightningGReduceCD=1.,Laxus_LightningQReduceCD=1.,
                    SetMpCurrent=lambda *a:mana.append(a),ReduceCooldown=lambda *a:cooldowns.append(a),
                    CreateUnit=lambda *_:self.fail('Lightning dummy must not be created'))
        vm.run('ErzaPassive',(caster,hero,3))
        self.assertEqual([(hero,120.)],mana);self.assertEqual([(hero,'G',1.),(hero,'Q',1.),(hero,'Q2',1.)],cooldowns)
        self.assertFalse(vm.stuns)

    def test_laxus_g_both_native_levels_and_builder_describe_lightning_absorption(self):
        obj=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))['A0EZ']
        for level in (1,2):
            tip=obj[f'extended_tooltip level {level}']
            self.assertIn('restores 120 mana',tip)
            self.assertIn('Q (both forms) and G cooldowns by 1 sec each',tip)
            self.assertIn('preventing its stun and mana burn',tip)
        builder=source('WOS_Start/UniversalTooltips.j')
        self.assertIn('createUtility(LaxusG_ID, 2,',builder)
        self.assertIn('FormatReal(Laxus_LightningQReduceCD)',builder)

    def test_tomioka_e_actual_strike_uses_attack_route(self):
        vm=JassState(source('Heroes/Tomioka.j'))
        hero=vm.unit(owner=0);target=vm.unit(owner=1,x=50)
        data=vm.structs['TomiokaE_KS'].create()
        for k,v in dict(c=hero,td=target,d=target,g=set(),r=0.,r2=1.,rmax=10.,check=0,check2=0,check3=2,dmg=250.,aoe=875.).items():setattr(data,k,v)
        vm.structs['TomiokaE_KS'].statics.update(MUI_TomiokaE=0,m_TomiokaE={0:data})
        hits=[]
        vm.g.update(WUI_HeroProgress=lambda *_:None,I2R=float,DebugUnit2=lambda *_:None,MakeSoundVolume=lambda *_:None,
                    DamageSource=lambda *_:None,PosUnit=lambda *_:None,EffectSpawnColor=vm.effect,GAngle=lambda *_:0.,SetUnitFacing=lambda *_:None,
                    BlzIsUnitInvulnerable=lambda *_:False,
                    dmgatk=lambda *a:hits.append(a),dmgphys=lambda *_:self.fail('physical spell route'))
        vm.run('Loop_TomiokaE')
        self.assertEqual([(hero,target,250.)],hits)

    def frieren_fixture(self):
        systems=source('Systems/Systems2.j')
        timer=systems[systems.index('    private struct KS_SpellTimer'):systems.index('    private struct KS_UnitColor')]
        frieren=source('Heroes/Frieren.j').split('    private function FrierenR_GetIllusion')[0]
        vm=JassState(re.sub(r'//[^\n]*','',frieren+'\n'+timer))
        vm.structs['KS_SpellTimer'].statics.update(MUI_6=-1,m_6={})
        vm.structs['FrierenSpells_W2'].statics.update(MUI_FrierenW2=-1,m_FrierenW2={})
        base_allocate=vm.structs['FrierenSpells_W2'].allocate
        def allocate_w2():
            data=base_allocate();data.ee=defaultdict(lambda:None)
            data.deallocate=lambda *_:setattr(data,'alive',False)
            return data
        vm.structs['FrierenSpells_W2'].allocate=allocate_w2
        for name,value in re.findall(r'\b(?:integer|real) (Frieren\w+) = ([^\r\n/]+)',source('Heroes/Frieren.j')):
            vm.g[name]=eval(value.strip())
        available={}
        vm.g.update(hs={},FrierenW2_Hits={},SH_Frieren_FRIERENQ_ID=str(vm.g['FrierenQ_ID']),
                    FrierenTimer03Acquire=lambda:None,FrierenTimer03Release=lambda:None,
                    GearTimer05Acquire=lambda:None,GearTimer05Release=lambda:None,
                    PauseTimer=lambda *_:None,TimerStart=lambda *_:None,FrierenTimer03=None,FrierenTimer03Callback=None,
                    MyFrame=lambda *_:None,UnitMakeAbilityPermanent=lambda *_:None,
                    SetUnitAbilityLevel=lambda u,a,l:u.abilities[a].update(level=l),
                    SetPlayerAbilityAvailable=lambda p,a,v:available.update({(p,a):v}),
                    GetUnitCurrentOrder=lambda _:0,OrderId=lambda _:1,
                    BlzGetAbilityStringLevelField=lambda *_:'unused',ABILITY_SLF_BASE_ORDER_ID_NCL6=0,
                    StopSpellUnit2=lambda *_:None,ColorEffDummy3=lambda *_:None,
                    GetInt=lambda _:100.,GetHeroInt=lambda *_:100.,GetRandomInt=lambda a,b:a,GAngle2=lambda *_:0.,
                    SetUnitAnimationByIndex=lambda *_:None,BlzSetUnitFacingEx=lambda *_:None,
                    EffectSpawn3=vm.effect,ErzaPassive=lambda *_:None,
                    SaveGroupHandle=lambda h,k,c,v:h.update({(k,c):v}),
                    RemoveSavedHandle=lambda h,k,c:h.pop((k,c),None),
                    LoadGroupHandle=lambda h,k,c:h.get((k,c)))
        vm.g['SwapAbility']=lambda c,r,new,old:vm.run('SpellTimer_Timer_Start',(c,r,new,old,0))
        hero=vm.unit(owner=0);hero.type=vm.g['Frieren_ID'];hero.abilities[vm.g['FrierenQ_ID']]={'level':5}
        return vm,hero,available

    def test_frieren_q1_miss_and_q2_completion_unlock_q3_in_t_form(self):
        for name,method,stat in (('FrierenSpells_Q','Loop_FrierenQ','MUI_FrierenQ'),('FrierenSpells_Q2','Loop_FrierenQ2','MUI_FrierenQ2')):
            with self.subTest(stage=name):
                vm,hero,available=self.frieren_fixture();g=vm.g
                g['hs'][id(hero),g['SH_MODE_T']]=1
                g['hs'][id(hero.owner),g['SH_Frieren_FRIERENQ_ID']]=1
                data=vm.structs[name].create()
                data.deallocate=lambda *_:setattr(data,'alive',False)
                for k,v in dict(c=hero,statSource=hero,r=4.,rmax=3.,check=1,g=vm.create_group(),g2=vm.create_group(),g3=vm.create_group(),targetCount=0,ee=defaultdict(lambda:None)).items():setattr(data,k,v)
                vm.structs[name].statics.update({stat:0,'m_FrierenQ2' if name.endswith('Q2') else 'm_FrierenQ':{0:data}})
                vm.run(method)
                self.assertTrue(available[0,g['FrierenQ3_ID']])
                self.assertFalse(available[0,g['FrierenQ_ID']])
                self.assertFalse(available[0,g['FrierenQ2_ID']])
                self.assertEqual(1,hero.abilities[g['FrierenQ3_ID']]['level'])
                self.assertEqual(0,g['hs'][id(hero.owner),g['SH_Frieren_FRIERENQ_ID']])

    def test_frieren_new_q3_window_survives_old_q2_timer_and_expires_normally(self):
        vm,hero,available=self.frieren_fixture();g=vm.g
        g['SwapAbility'](hero,4.,g['FrierenQ2_ID'],g['FrierenQ_ID'])
        vm.run('FrierenQ_UnlockFinisher',(hero,))
        for _ in range(90):vm.run('LoopSpellTimer')
        self.assertEqual(g['FrierenQ3_ID'],g['hs'][id(hero.owner),'AHUI swap '+str(g['FrierenQ_ID'])])
        self.assertFalse(available[0,g['FrierenQ_ID']])
        self.assertTrue(available[0,g['FrierenQ3_ID']])
        for _ in range(110):vm.run('LoopSpellTimer')
        self.assertTrue(available[0,g['FrierenQ_ID']])
        self.assertFalse(available[0,g['FrierenQ3_ID']])

    def test_frieren_tw_range_speed_hit_limit_and_cleanup(self):
        vm,hero,available=self.frieren_fixture();g=vm.g
        # The evaluator represents JASS integer struct ids as Python objects.
        key=lambda k:k if isinstance(k,(str,int)) else id(k)
        g.update(LoadInteger=lambda h,k,c:h.get((key(k),c),0),SaveInteger=lambda h,k,c,v:h.update({(key(k),c):v}),
                 FlushChildHashtable=lambda h,k:vm.flush(h,key(k)))
        enemy=vm.unit(owner=1);friend=vm.unit(owner=0);hits=[]
        g['dmgmag']=lambda c,u,d:hits.append((u,d))
        for cast in range(2):
            before=len(hits)
            vm.run('FrierenW2_Start',(hero,hero,10000.,0.))
            data=vm.structs['FrierenSpells_W2'].m_FrierenW2[0]
            self.assertAlmostEqual(25.5,data.move)
            for _ in range(110):
                if not data.alive:break
                enemy.x=data.x;enemy.y=data.y;friend.x=data.x;friend.y=data.y
                vm.run('Loop_FrierenW2')
                self.assertLessEqual(data.travelled,g['FrierenW2_Range'])
            self.assertFalse(data.alive)
            self.assertEqual(5,len(hits)-before)
            self.assertTrue(all(u is enemy for u,d in hits))
            self.assertTrue(all(d==202.5 for u,d in hits))
            self.assertFalse(g['FrierenW2_Hits'])

    def test_frieren_native_targeting_and_current_scripted_travel_limits(self):
        obj=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
        vm,_,_=self.frieren_fixture()
        self.assertEqual(1800.,vm.g['FrierenW2_Range']);self.assertEqual(2000.,vm.g['FrierenT2_Range'])
        # Native point targeting remains 2000; TW's scripted travel is capped at 1800.
        for raw in ('A0GO','A0GT'):
            self.assertEqual(2000.,obj[raw]['cast_range level 1'])
            self.assertIn('2000',obj[raw]['extended_tooltip level 1'])
        builder=source('WOS_Start/UniversalTooltips.j')
        self.assertIn('return FrierenW2_Range',builder)
        self.assertIn('return FrierenT2_Range',builder)
        self.assertIn('FrierenW2_Damage2StaticBase, 0.0',builder)

    def test_frieren_t2_last_step_stops_at_2000_before_cleanup(self):
        vm,hero,_=self.frieren_fixture()
        data=vm.structs['FrierenSpells_T2'].create()
        for k,v in dict(c=hero,x=1995.,y=0.,travelled=1995.,limit=2000.,move=30.,a=0.,rmax=2.5,aoe=600.,g=vm.create_group(),e=vm.effect('test'),e2=vm.effect('test'),e3=vm.effect('test'),scale=.85).items():setattr(data,k,v)
        data.deallocate=lambda *_:setattr(data,'alive',False)
        vm.structs['FrierenSpells_T2'].statics.update(MUI_FrierenT2=0,m_FrierenT2={0:data})
        vm.g.update(IsTerrainPathable=lambda *_:False,SlowUnit=lambda *_:None)
        vm.run('Loop_FrierenT2')
        self.assertEqual(2000.,data.travelled)
        self.assertEqual(2000.,data.x)
        vm.run('Loop_FrierenT2')
        self.assertFalse(data.alive)

    def test_all_tooltip_registrations_have_separate_staggered_operation_budgets(self):
        text=source('WOS_Start/UniversalTooltips.j')
        jobs=dict(re.findall(r'(?m)^    function (WOS_UTB_Init_\w+) takes[^\n]*\n([\s\S]*?)^    endfunction',text))
        self.assertEqual(483,len(jobs))
        spell_jobs=[body for body in jobs.values() if 'call SpellData.' in body]
        self.assertEqual(432,len(spell_jobs))
        for body in jobs.values():
            self.assertLessEqual(body.count('call SpellData.'),1)
            self.assertLessEqual(body.count('HeroData.create('),1)
        for hero in ('Milim','Frieren','Tsuna','Inori','AlterSaber','Kenjaku','Mahoraga','Toji','Brandish','Laxus','Harribel','Barragan','Patriot'):
            self.assertTrue(any('HeroData.create('+hero+'_ID' in body for body in jobs.values()),hero)
        queue='\n'.join(re.findall(r'(?m)^    private function InitTooltip(?:Queue|Step) takes[^\n]*\n[\s\S]*?^    endfunction',text))
        vm=JassState(queue);called=[];destroyed=[]
        rearmed=[]
        vm.g.update(UTB_InitJobs={},UTB_InitJobCount=0,UTB_InitJobIndex=1,UTB_InitComplete=False,UTB_INIT_BATCH=2,UTB_INIT_PERIOD=.01,WUI_StartupEnd=lambda:None,
                    ExecuteFunc=lambda name:called.append(name),GetExpiredTimer=lambda:'timer',DestroyTimer=destroyed.append,
                    TimerStart=lambda *a:rearmed.append(a[1:3]))
        vm.run('InitTooltipQueue')
        steps=(len(jobs)+1)//2
        for i in range(steps):
            vm.run('InitTooltipStep')
            self.assertEqual(min(2*(i+1),len(jobs)),len(called))
            self.assertEqual(i==steps-1,vm.g['UTB_InitComplete'])
            if i<steps-1:self.assertFalse(destroyed)
        self.assertEqual(list(jobs),called)
        self.assertEqual(['timer'],destroyed)
        # One-shot re-armed after every step except the last: no periodic catch-up bursts.
        self.assertEqual([(.01,False)]*(steps-1),rearmed)
        self.assertTrue(all(v is None for v in vm.g['UTB_InitJobs'].values()))
        self.assertIn('UTB_INIT_PERIOD = 0.01',text)
        self.assertIn('TimerStart(CreateTimer(), UTB_INIT_PERIOD, false, function InitTooltipStep)',text)

    def test_long_reach_preview_supports_milim_and_other_heroes(self):
        vm=JassState(source('WOS_Start/AbilityRangePreview.j'))
        hero=vm.unit(owner=0);visible=[];scale=[]
        vm.g.update(AR_RequestedHero={0:hero},AR_RequestedAbility={0:'finisher'},AR_RequestedItemSlot={0:-1},
                    AR_Hero=defaultdict(lambda:None,{0:hero}),AR_Effect={0:'ring'},AR_Visible=-1,AR_Scale=0.,AR_LastX=0.,AR_LastY=0.,AR_Ground='ground',
                    GetLocalPlayer=lambda:0,Player=lambda p:p,IsUnitHidden=lambda _:False,IsUnitType=lambda *_:False,
                    WUI_RangePreviewBlocked=lambda:False,MilimT2_ID='finisher',MilimT2_BeamRange=2700.,
                    AAUniversalTooltips_GetPreviewRadius=lambda *_:2700.,
                    MoveLocation=lambda *_:None,GetLocationZ=lambda _:0.,
                    BlzSetSpecialEffectPosition=lambda *_:None,
                    BlzSetSpecialEffectScale=lambda e,s:scale.append(s),BlzSetSpecialEffectAlpha=lambda e,a:visible.append(a))
        vm.run('AR_Render',(0,))
        self.assertEqual(0,vm.g['AR_Visible']);self.assertEqual(2700./512.,scale[-1]);self.assertEqual(255,visible[-1])
        vm.g['AR_RequestedAbility'][0]='other'
        vm.run('AR_Render',(0,))
        self.assertEqual(0,vm.g['AR_Visible']);self.assertEqual(2700./512.,scale[-1])


if __name__=='__main__':unittest.main()
