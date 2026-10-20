"""Execute the MAIN paths reported from the October 18 Warcraft screenshots."""
from collections import defaultdict
from pathlib import Path
from types import SimpleNamespace
import json
import math
import re
import unittest

from test_crocodile import JassState
import war3_object_workspace as objects
from stage_hero_packet_2026_10_18 import apply_packet

ROOT = Path(__file__).resolve().parents[1]


def source(name):
    return (ROOT / 'triggers' / name).read_text(encoding='utf-8-sig')


def functions(text, *names):
    return '\n'.join(re.search(r'(?m)^\s*(?:(?:private|public) )?function ' + name +
                              r' takes[^\n]*\n[\s\S]*?^\s*endfunction', text)[0] for name in names)


class HeroPacket(unittest.TestCase):
    def test_test_fast_start_counts_shared_ally_enemy_once_and_real_players(self):
        vm=JassState(functions(source('Systems/EnterRegion.j'),'TestUnit_FastStartReady','Trig_EnterRegion_ActionsGO'))
        hero=vm.unit(owner=0,x=0.,y=0.);ally=vm.unit(owner=1,x=0.,y=0.);enemy=vm.unit(owner=6,x=0.,y=0.)
        active={0};heroes=defaultdict(lambda:None,{0:hero,1:ally,6:enemy})
        vm.g.update(Hero=heroes,TestUnit=enemy,TestAllyUnit=ally,gg_rct_Go=(-10,-10,10,10),
                    IsActivePlayerSlot=lambda i:i in active,CheckCoordsInRect=lambda rect,x,y:rect[0]<=x<=rect[2] and rect[1]<=y<=rect[3],
                    TestMode=True,END1=0,CondArena=0,inststart=0,TimeMove=0,TimeRound=120.,
                    GetEnteringUnit=lambda:ally,GetPlayerId=lambda p:p,IsGamePlayerSlot=lambda i:0<=i<10,
                    PlayersMsg=lambda *_:None,GetPlayerVisualColorString=lambda *_:'',
                    TestUnit_FastStartReady=lambda:vm.run('TestUnit_FastStartReady'))
        self.assertTrue(vm.run('TestUnit_FastStartReady'))
        ally.x=30.;self.assertFalse(vm.run('TestUnit_FastStartReady'))
        vm.run('Trig_EnterRegion_ActionsGO');self.assertEqual(0,vm.g['inststart'])
        ally.x=0.;active.update((1,6))  # Native owner slots must not be counted twice.
        vm.run('Trig_EnterRegion_ActionsGO');self.assertEqual(1,vm.g['inststart']);self.assertEqual(119.,vm.g['TimeMove'])
        active.add(2);self.assertFalse(vm.run('TestUnit_FastStartReady'))
        heroes[2]=vm.unit(owner=2,x=0.,y=0.);self.assertTrue(vm.run('TestUnit_FastStartReady'))

    def test_shiki_t_preview_includes_launch_offset_flight_and_final_hit_radius(self):
        vm=JassState(functions(source('WOS_Start/UniversalTooltips.j'),'ARules_CeilSteps','ARules_BeamEnvelope','ARules_BreathEnvelope','ARules_GetImpactReach','GetPreviewRadius','GetDisplayedRange'))
        for p in (ROOT/'triggers/Heroes').rglob('*.j'):
            vm.g.update(re.findall(r"\binteger (\w+)\s*=\s*'(....)'",p.read_text(encoding='utf-8-sig')))
        hero=vm.unit(owner=0);data=SimpleNamespace(previewChannel=True,previewDirected=True)
        vm.g.update(HT_DATA='data',GetUnitAbilityLevel=lambda *_:1,ARules_GetPreviewSource=lambda a:a,
                    LoadInteger=lambda table,parent,key:0 if key==8888 else data,
                    BlzGetUnitAbility=lambda *_:'ability',ReadHeroCastRange=lambda *_:2100.,
                    PreviewMechanic=lambda *_:'Radius: 250',ReadMechanicRadius=lambda *_:250.,
                    BlzGetAbilityIntegerLevelField=lambda *_:2,ABILITY_ILF_TARGET_TYPE='target',
                    DarkShikiT_ID='T',DarkShikiT_ProjectileOffset=140.,DarkShikiT_Range=2100.,DarkShikiT_AoE=250.)
        self.assertEqual(2490.,vm.run('GetPreviewRadius',(hero,'T')))
        self.assertEqual(2490.,vm.run('GetDisplayedRange',(hero,'T')))
        self.assertEqual(2350.,vm.run('GetPreviewRadius',(hero,'other')))
        game=source('Heroes/DarkShiki.j').split('    private struct DarkShikiT_KS',1)[1].split('    endstruct',1)[0]
        self.assertEqual(2,game.count('GetUnitX(c) + DarkShikiT_ProjectileOffset * Cos(a)'))

    def test_saber_f_always_current_mana_and_on_burn_double(self):
        vm=JassState(functions(source('Heroes/AlterSaber.j'),'AlterSaberF_Initialize','AlterSaberF_Toggle','AlterSaberF_Attack'))
        hero=vm.unit(owner=0);hero.mana=1000.;vm.add_ability(hero,'F')
        vm.g.update(hs={},SH_ALTERSABER_F_ACTIVE='saber f',AlterSaberF_ID='F',AlterSaberF_Active_ID='Fon',
                    AlterSaberF_DamageFromCurrentMana=5.,AlterSaberF_ManaBurnBase=5.,AlterSaberF_ManaBurnMorph=3.,
                    AlterSaberF_BurnDamageMultiplier=2.,UNIT_STATE_MANA='mana',
                    GetUnitState=lambda u,k:getattr(u,k),SetUnitState=lambda u,k,v:setattr(u,k,v),
                    UnitMakeAbilityPermanent=lambda *_:None,SetPlayerAbilityAvailable=lambda *_:None)
        for morph,burn in ((False,50.),(True,30.)):
            hero.mana=1000.
            self.assertEqual(50.,vm.run('AlterSaberF_Attack',(hero,morph)))
            self.assertEqual(1000.,hero.mana)
            vm.run('AlterSaberF_Toggle',(hero,))
            self.assertEqual('Fon',vm.g['hs'][id(0),'AHUI swap F'])
            self.assertAlmostEqual(50.+2*burn,vm.run('AlterSaberF_Attack',(hero,morph)))
            self.assertAlmostEqual(1000.-burn,hero.mana)
            vm.run('AlterSaberF_Toggle',(hero,))
            self.assertEqual(0,vm.g['hs'][id(0),'AHUI swap F'])
        vm.run('AlterSaberF_Toggle',(hero,))
        vm.run('AlterSaberF_Initialize',(hero,))  # Re-pick resets the state; F starts switched On.
        self.assertTrue(vm.g['hs'][id(hero),'saber f'])
        self.assertEqual('Fon',vm.g['hs'][id(0),'AHUI swap F'])

    def test_sakura_1250_area_uses_raiden_circle_at_actual_xy_and_destroys_it(self):
        text=source('Items/Items.j')
        body=text.split('    private struct ItemsSpells_SakuraSesshou',1)[1].split('    endstruct',1)[0]
        vm=JassState('    private struct ItemsSpells_SakuraSesshou'+body+'\n    endstruct')
        ns=vm.structs['ItemsSpells_SakuraSesshou'];ns.statics.update(MUI_Item16=-1,m_Item16={})
        hero=vm.unit(owner=0);effects=[];destroyed=[]
        def effect(*args):
            e=vm.effect(*args);effects.append((e,args));return e
        vm.g.update(SakuraSesshou_Damage=1.,SakuraSesshou_Aoe=1250.,SakuraSesshou_Duration=10.,
                    SakuraSesshou_Interval=2.,SacredGearBooster=lambda *_:0.,GetMainStatValue=lambda *_:100.,
                    Bambietta_ID='other',ItemsTick_On=lambda *_:None,ItemsTick_Off=lambda *_:None,
                    EffectSpawn=effect,DestroyEffect=destroyed.append)
        vm.run('SakuraSesshou_Start',(hero,220.,-410.));data=ns.m_Item16[0]
        area,args=next((e,a) for e,a in effects if 'lightning circle' in a[0])
        self.assertEqual((220.,-410.),args[1:3]);self.assertAlmostEqual(2.3*1.05*1250/650,args[5])
        data.r=10.;data.deallocate=lambda *_:None
        vm.run('Loop_SakuraSesshou');self.assertIn(area,destroyed)
        self.assertEqual(-1,ns.MUI_Item16)

    def test_kyoraku_cage_cleanup_closes_e2_before_the_longer_swap_timer(self):
        text=source('Heroes/Kyoraku.j')
        block=re.search(r'(?m)^                    if LoadInteger\(hs, GetHandleId\(GetOwningPlayer\(\.c\)\).*?^                    endif',text,re.S)[0]
        vm=JassState('function Close takes unit c returns nothing\n'+block.replace('.c','c')+'\nendfunction')
        hero=vm.unit(owner=0);calls=[]
        vm.g.update(hs={},KyorakuE_ID='E',KyorakuE4_ID='E2',SetPlayerAbilityAvailable=lambda *a:calls.append(a))
        vm.g['hs'][id(0),'AHUI swap E']='E2'
        vm.run('Close',(hero,));self.assertEqual([(0,'E2',False),(0,'E',True)],calls)
        self.assertEqual(0,vm.g['hs'][id(0),'AHUI swap E'])

    def test_ashisogi_only_tagged_physical_spell_hits_exclude_normal_and_tagged_attacks(self):
        text=source('Systems/DmgSys.j')
        block=re.search(r'(?m)^        if typedmg == 2 and not eventIsAttack.*\n'
                        r'            call AshisogiJizo_Poison\(c, td\)\n        endif',text)[0]
        vm=JassState('function Hit takes nothing returns nothing\n'+block+'\nendfunction')
        procs=[];attack=[False]
        vm.g.update(c='caster',td='target',AshisogiTrigger=False,MurasameTrigger=False,
                    AshisogiJizo_ID='jizo',AshisogiJizo_MinDmg=100.,isEnemy=True,dmg=100.,
                    damageSourceId='spell',HasCachedItem=lambda *_:1,BlzGetEventIsAttack=lambda:attack[0],
                    AshisogiJizo_Poison=lambda *args:procs.append(args))
        for damage_type,is_attack,tagged,expected in ((0,True,False,0),(0,True,True,0),
                (2,True,True,0),(1,False,True,0),(2,False,True,1),(2,False,False,0)):
            vm.g.update(typedmg=damage_type,damageSourceId='spell' if tagged else 0)
            attack[0]=is_attack;vm.g['eventIsAttack']=is_attack;procs.clear();vm.run('Hit');self.assertEqual(expected,len(procs))
        vm.g.update(typedmg=2,damageSourceId='spell',dmg=99.);procs.clear();vm.run('Hit')
        self.assertFalse(procs)

    def test_test_units_have_moving_shared_sight_without_reveal_timer(self):
        text=source('WOS_Start/WoS_Pick_Init.j')
        vm=JassState(functions(text,'TestUnit_ConfigureControl'))
        relations={}
        vm.g.update(Player=lambda i:i,TestAllyUnitPlayerId=1,TestUnitPlayerId=6,TestAllyUnitController=None,TestUnitController=None,
                    ALLIANCE_SHARED_CONTROL='control',ALLIANCE_SHARED_ADVANCED_CONTROL='advanced',
                    ALLIANCE_PASSIVE='ally',ALLIANCE_SHARED_VISION='sight',
                    SetPlayerAlliance=lambda a,b,k,v:relations.__setitem__((a,b,k),v))
        for owner,allied in ((6,False),(1,True)):
            vm.run('TestUnit_ConfigureControl',(0,owner,allied))
            self.assertTrue(relations[owner,0,'sight']);self.assertTrue(relations[0,owner,'sight'])
            self.assertEqual(allied,relations[owner,0,'ally'])
        self.assertTrue(relations[6,1,'sight']);self.assertTrue(relations[1,6,'sight'])
        vm.run('TestUnit_ConfigureControl',(2,6,False))
        self.assertFalse(relations[6,0,'sight']);self.assertFalse(relations[0,6,'sight'])
        self.assertTrue(relations[6,2,'sight'])
        create=functions(text,'TestUnit_CreateSelectedHero')
        self.assertIn('BlzSetUnitRealField(created, UNIT_RF_SIGHT_RADIUS, 1800.0)',create)
        self.assertNotIn('CreateTimer',create)

    def test_tomioka_bonus_hits_per_three_stacks_and_larger_jump_candidate_is_selected(self):
        text=source('Heroes/Tomioka.j')
        body=text.split('    private struct TomiokaE_KS',1)[1].split('    endstruct',1)[0]
        declarations='\n'.join(re.findall(r'(?m)^        (?:private )?(?:integer|real) \w+ = [^\n]+',text))
        vm=JassState(re.sub(r'//[^\n]*','','globals\n'+declarations+'\nendglobals\n    private struct TomiokaE_KS'+body+'\n    endstruct'))
        hero=vm.unit(owner=0);initial=vm.unit(owner=1,x=0.,y=0.)
        vm.add_ability(hero,vm.g['TomiokaE_ID']);hero.abilities[vm.g['TomiokaE_ID']]['level']=1
        vm.g.update(hs={},SH_SKILL_Q='combo q',SH_SKILL_W='combo w',
                    StartSpellUnit=lambda *_:None,SetUnitAnimationByIndex=lambda *_:None,
                    SetUnitTimeScale=lambda *_:None,TomiokaTick_On=lambda *_:None,GAngle2=lambda *_:0.,
                    GetAttack=lambda *_:100.)
        ns=vm.structs['TomiokaE_KS'];ns.statics.update(MUI_TomiokaE=-1,m_TomiokaE={})
        for stacks,extra in ((0,0),(2,0),(3,1),(5,1),(6,2)):
            vm.g['hs'][id(hero),'tomioka add dmg']=stacks
            vm.run('TomiokaE_Start',(hero,initial));data=ns.m_TomiokaE[ns.MUI_TomiokaE]
            self.assertEqual(vm.g['TomiokaE_AtkCountBase']+extra,data.check3)
            self.assertEqual(1050.,data.aoe)
        for level, base_hits in enumerate((2, 3, 4, 5, 5), 1):
            hero.abilities[vm.g['TomiokaE_ID']]['level'] = level
            for stacks in (0, 3, 15):
                vm.g['hs'][id(hero),'tomioka add dmg'] = stacks
                vm.run('TomiokaE_Start',(hero,initial))
                data=ns.m_TomiokaE[ns.MUI_TomiokaE]
                self.assertEqual(base_hits + stacks // 3, data.check3)
                self.assertAlmostEqual(90., data.dmg)
        # Keep one live instance; the last candidate must be reachable beyond the old875 radius.
        target=vm.unit(owner=1,x=950.,y=0.)
        data.td=initial;data.check=1;data.r2=1.;data.r=0.;data.rmax=15.;data.check3=8
        ns.statics.update(MUI_TomiokaE=0,m_TomiokaE={0:data})
        vm.g.update(I2R=float,WUI_HeroProgress=lambda *_:None,DebugUnit2=lambda *_:None,
                    BlzIsUnitInvulnerable=lambda u:getattr(u,'invulnerable',False),
                    GroupEnumUnitsInRange=lambda group,x,y,r,*_:group.extend(u for u in (initial,target) if math.hypot(u.x-x,u.y-y)<=r),
                    GetRandomInt=lambda a,b:b,EffectSpawnColor=vm.effect,PosUnit=lambda *_:None,
                    SetUnitAnimation=lambda *_:None,MakeSoundVolume=lambda *_:None,SetUnitFacing=lambda *_:None,
                    GAngle=lambda *_:0.,DamageSource=lambda *_:None,dmgatk=lambda *_:None,DecorRemove=lambda *_:None)
        vm.run('Loop_TomiokaE');self.assertIs(target,data.td)
        # Losing the current/initial target can still jump to a nearby living enemy.
        initial.life=0.;data.td=initial;data.d=initial;data.r=0.;data.r2=1.
        vm.run('Loop_TomiokaE');self.assertIs(target,data.td)
        for invulnerable,nearby in ((False,False),(True,True)):
            with self.subTest(invulnerable=invulnerable,nearby=nearby):
                initial.life=100. if invulnerable else 0.;initial.invulnerable=invulnerable
                target.life=100. if nearby else 0.
                data.c=hero;data.td=initial;data.d=initial;data.r=0.;data.r2=1.;data.check=1
                data.rmax=15.;data.g=vm.g['CreateGroup']();data.deallocate=lambda *_:None
                ns.statics.update(MUI_TomiokaE=0,m_TomiokaE={0:data})
                hits=[];vm.g.update(dmgatk=lambda *a:hits.append(a),TomiokaTick_Off=lambda *_:None)
                hero.paused=True
                vm.run('Loop_TomiokaE')
                self.assertEqual(-1,ns.MUI_TomiokaE);self.assertFalse(hero.paused);self.assertFalse(hits)

    def test_targeted_debuffs_reuse_target_owner_pools_even_without_caster_vision(self):
        names=('StunUnit','SilenceUnit','DoomUnit','RootUnit','SlowUnit','DecreaseArmorUnit',
               'CurseUnit','CurseUnit2','CurseUnitHellBlaze','BuffUnit1','BuffUnit2','BuffUnit01','BuffUnit02')
        text=source('Systems/Systems1.j')
        for owner in (2,23):
            code=functions(text,*names,'GetSlowAbilityLevel')
            code=re.sub(r'(?m)^(\s*set [^=\n]+?)\s*=\s*',r'\1 = ',code)
            vm=JassState(code)
            caster=vm.unit(owner=0);target=vm.unit(owner=owner);orders=[];created=[]
            def create(p,typ,x,y,a):
                unit=vm.unit(owner=p,x=x,y=y);created.append(unit);return unit
            def order(dummy,command,unit):
                self.assertEqual(unit.owner,dummy.owner)
                self.assertFalse(vm.g['IsUnitVisible'](unit,caster.owner))
                orders.append((dummy,command,unit))
            vm.g.update(Player=lambda p:p,GetPlayerId=lambda p:p,CreateUnit=create,
                        GetWidgetLife=lambda u:u.life if u else 0.,GetRectCenterX=lambda *_:0.,GetRectCenterY=lambda *_:0.,
                        gg_rct_Caster=None,DebuffImmune_Start=lambda u,n:n,HasCachedItem=lambda *_:0,
                        Erza_ID='erza',ShunShunRikka_Buff_ID='shun',ShunShunRikka_StunReduce=.5,
                        IsUnitVisible=lambda u,p:u.owner==p,hs={},SetUnitFacing=lambda *_:None,GAngle=lambda *_:0.,
                        SetUnitAbilityLevel=lambda u,a,n:u.abilities[a].update(level=n),
                        IssueTargetOrder=order,IssueTargetOrderById=order,MyRemoveUnit=lambda *_:None,
                        BlzGetAbilityRealLevelField=lambda *_:1.,ABILITY_RLF_DURATION_HERO='hero',ABILITY_RLF_DURATION_NORMAL='unit')
            for pool in ('DummyPlayer','DummyPlayer3','DummyDebuff1'):
                vm.g[pool]=defaultdict(lambda:None)
                vm.g[pool][0]=vm.unit(owner=0)
            for name in names:
                args=(caster,target,30,1) if name=='SlowUnit' else (caster,target,'A01E','innerfire',1) if name=='BuffUnit01' else (caster,target,'A01E',852066,1) if name=='BuffUnit02' else (caster,target,1)
                vm.run(name,args)
            self.assertEqual(len(names),len(orders))
            self.assertEqual(5,len(created))  # Three shared pools and two pre-existing disposable helpers.
        for name in ('SlowUnitErza','ErzaPassive','ErzaBuffNakagami_Start'):
            body=functions(source('Systems/DecorDestroy_and_Erza_Debuff.j'),name)
            self.assertIn('GetPlayerId(GetOwningPlayer(u))',body)
            self.assertNotIn('GetPlayerId(GetOwningPlayer(c))',body)

    def test_hashirama_item_shows_15_strength_and_clears_on_existing_buff_clock(self):
        text=source('Items/Items.j')
        body=text.split('    private struct ItemsSpells_TimedStr',1)[1].split('    endstruct',1)[0]
        vm=JassState('    private struct ItemsSpells_TimedStr\n'+body+'\n    endstruct')
        ns=vm.structs['ItemsSpells_TimedStr'];ns.statics.update(MUI_Str=-1,m_Str={})
        hero=vm.unit(owner=0);item=SimpleNamespace(charges=0);writes=[];acquired=[]
        vm.g.update(HashiramaCells_Str_ID='str',HashiramaCells_ID='item',UnitMakeAbilityPermanent=lambda *_:None,
                    GetItemOfTypeFromUnitBJ=lambda *_:item,ItemsTick05_On=lambda k:acquired.append(k),ItemsTick05_Off=lambda *_:None,
                    SetItemCharges=lambda it,n:(writes.append(n),setattr(it,'charges',n)))
        vm.run('Add',(hero,1,1,1,10.));data=ns.m_Str[0];data.deallocate=lambda *_:None
        self.assertEqual(15,item.charges)
        item.charges-=1  # Engine consumption happens after SPELL_EFFECT, as seen in Warcraft.
        vm.run('Loop_TimedStr')
        self.assertEqual(15,item.charges)
        for _ in range(50):vm.run('Loop_TimedStr')
        self.assertEqual([15,15],writes)  # One deferred correction; no repeated writes after it.
        vm.run('Add',(hero,1,1,1,10.))
        self.assertEqual(15,item.charges);self.assertEqual([2],acquired)
        for _ in range(201):
            vm.run('Loop_TimedStr')
            if ns.MUI_Str==-1:break
        self.assertEqual(0,item.charges);self.assertEqual([15,15,0,15,15,0],writes)
        self.assertEqual(0,vm.g['GetUnitAbilityLevel'](hero,'str'))

    def test_alucard_q_and_q2_keep_independent_marked_hit_budgets(self):
        text=source('Heroes/Alucard.j')
        vm=JassState(functions(text,'AlucardT_ArmCDR','AlucardT_MarkedHit'))
        hero=vm.unit(owner=0);cuts=[];remaining=[16.]
        vm.g.update(hs={},SH_ALUCARD_T_CDR='cdr:',AlucardQ_ID='Q',AlucardQ2_ID='Q2',
                    AlucardW_ID='W',AlucardW2_ID='W2',AlucardE_ID='E',AlucardT_CDReduce=50.,
                    BlzGetUnitAbilityCooldownRemaining=lambda *_:remaining[0],
                    ReduceCooldown=lambda c,a,v:(cuts.append((a,v)),remaining.__setitem__(0,remaining[0]-v)))
        for order in (('Q','Q2'),('Q2','Q')):
            vm.g['hs'].clear();cuts.clear();remaining[0]=16.
            vm.run('AlucardT_ArmCDR',(hero,'Q'));vm.run('AlucardT_ArmCDR',(hero,'Q2'))
            for ability in order:vm.run('AlucardT_MarkedHit',(hero,ability))
            vm.run('AlucardT_MarkedHit',(hero,'Q'))
            self.assertEqual([('Q',8.),('Q',4.)],cuts)
        remaining[0]=0.;vm.run('AlucardT_ArmCDR',(hero,'Q'))
        vm.run('AlucardT_MarkedHit',(hero,'Q'))
        self.assertEqual(1,vm.g['hs'][id(hero),'cdr:Q'])
        self.assertIn('AlucardT_ArmCDR(c, AlucardQ2_ID)',functions(text,'AlucardQ2_Start'))

    def test_tsuna_cambio_has_complete_w_attack_and_refreshes_only_missing_buff(self):
        text=source('Heroes/Tsuna.j')
        vm=JassState(functions(text,'TsunaCambio_OnAttack','TsunaCambio_RefreshW'))
        hero=vm.unit(owner=0);target=vm.unit(owner=1);hero.abilities['W']={'level':3}
        hits=[];roots=[];buffs=[]
        vm.g.update(hs={(id(hero),'cambio'):1},SH_TSUNA_CAMBIO='cambio',TsunaW_ID='W',TsunaW_Buff_ID='buff',
                    TsunaW_DamageAgiBase=.4,TsunaW_DamageAgiStep=.2,TsunaW_Damage2StaticBase=50.,
                    TsunaW_Damage2StaticStep=0.,TsunaW_Root=.25,
                    RootUnit=lambda *a:roots.append(a),DamageSource=lambda *_:None,
                    NextDmg=lambda *a:hits.append(a),MyEffBuff=lambda *_:None,
                    BuffUnit1=lambda *a:(buffs.append(a),vm.add_ability(hero,'buff')))
        vm.run('TsunaCambio_OnAttack',(hero,target))
        self.assertEqual([(hero,target,.25)],roots)
        self.assertEqual((hero,target,130.,0,.05),hits[0])
        self.assertEqual(2,len(vm.effect_history))
        vm.run('TsunaCambio_RefreshW',(hero,));vm.run('TsunaCambio_RefreshW',(hero,))
        self.assertEqual(1,len(buffs))
        vm.run('TsunaCambio_OnAttack',(hero,target))
        self.assertEqual(1,len(hits))  # The standard W branch owns an already-present buff.
        self.assertIn('call TsunaCambio_RefreshW(c)',text.split('elseif check == 1 then')[-1])

    def test_okarun_t_push_clock_and_moving_trail_use_live_xy_and_facing(self):
        text=source('Heroes/Okarun.j')
        body=text.split('    private struct OkarunTBuff_KS',1)[1].split('    endstruct',1)[0]
        vm=JassState('    private struct OkarunTBuff_KS\n'+body+'\n    endstruct')
        vm.g.update(OkarunT_PushScanPeriod=.5,OkarunT_Buff_Duration=10.,OkarunT_Buff_ID='buff',
                    GetWidgetLife=lambda u:u.life,IsUnitPaused=lambda u:u.paused,GetUnitFacing=lambda u:u.facing,
                    OkarunTick_Off=lambda *_:None)
        ns=vm.structs['OkarunTBuff_KS'];data=ns.create();hero=vm.unit(owner=0,x=320.,y=170.)
        vm.add_ability(hero,'buff');hero.facing=123.;effects=[];pushes=[]
        vm.g['EffectSpawn']=lambda *a:effects.append(a)
        for n,v in dict(c=hero,r=0.,r2=0.,trailTime=0.,lastX=hero.x,lastY=hero.y).items():setattr(data,n,v)
        data.tackle=lambda:pushes.append(data.r)
        ns.statics.update(MUI_OkarunTBuff=0,m_OkarunTBuff={0:data})
        for _ in range(100):
            hero.x+=20.;hero.y+=3.;vm.run('Loop_OkarunTBuff')
        self.assertEqual(20,len(effects))
        self.assertEqual(6,len(pushes))
        self.assertTrue(all(.48-1e-8 <= b-a <= .51+1e-8 for a,b in zip(pushes,pushes[1:])))
        self.assertTrue(all(a[0]=='war3mapImported\\cf2.mdx' and a[3]==123. and a[5]==.5 for a in effects))
        for a in effects:self.assertAlmostEqual(170.+(a[1]-320.)*.15,a[2])
        count=len(effects)
        for _ in range(10):vm.run('Loop_OkarunTBuff')
        self.assertEqual(count,len(effects))
        push_count=len(pushes);hero.paused=True
        for _ in range(30):vm.run('Loop_OkarunTBuff')
        self.assertEqual(push_count,len(pushes));self.assertEqual(0.,data.r2)
        hero.paused=False;vm.run('Loop_OkarunTBuff')
        self.assertEqual(push_count,len(pushes))

    def test_crocodile_channel_resistance_preview_has_no_dispatch_or_state_writes(self):
        text=functions(source('Systems/Systems1.j'),'HeroChannelDamageFactor','GetPhysRes','GetMagRes')
        vm=JassState(text.replace('static if LIBRARY_CrocodileSpells then','if true then'))
        hero=vm.unit(owner=0);hero.type='croc';hero.hero_level=20
        vm.g.update(hs={},SH_CROCODILE_T_CHANNEL='channel',Crocodile_ID='croc',
                    CrocodileT_DamageReductionHeroLevel=35,CrocodileT_DamageReduction=.35,CrocodileT_DamageReduction35=.7,
                    DamageBlock=lambda *_:.9,GetWidgetLife=lambda u:u.life)
        self.assertAlmostEqual(10.,vm.run('GetPhysRes',(hero,)))
        vm.g['hs'][id(hero),'channel']=True
        self.assertAlmostEqual(41.5,vm.run('GetPhysRes',(hero,)))
        hero.hero_level=35
        self.assertAlmostEqual(73.,vm.run('GetMagRes',(hero,)))
        hero.illusion=True
        self.assertAlmostEqual(10.,vm.run('GetPhysRes',(hero,)))
        self.assertNotRegex(text,r'TriggerEvaluate|Save\w+\(|Create\w+\(')
        croc=source('Heroes/Crocodile.j')
        self.assertIn('SH_CROCODILE_T_CHANNEL, true',croc)
        self.assertIn('SH_CROCODILE_T_CHANNEL, false',croc)

    def test_bunshin_summon_copies_current_hero_move_speed_once(self):
        vm=JassState(functions(source('WOS_Start/Starts.j'),'WOS_MinimapSummon'))
        hero=vm.unit(owner=0);clone=vm.unit(owner=0);hero.type=clone.type='hero';clone.illusion=True
        hero.speed=467.;clone.speed=300.;calls=[]
        vm.g.update(Hero={0:hero},GetSummonedUnit=lambda:clone,GetPlayerId=lambda p:p,
                    WOS_RegisterHeroMinimap=lambda *_:None,GetUnitMoveSpeed=lambda u:u.speed,
                    SetUnitMoveSpeed=lambda u,v:(calls.append(v),setattr(u,'speed',v)))
        vm.run('WOS_MinimapSummon');self.assertEqual([467.],calls);self.assertEqual(467.,clone.speed)
        clone.illusion=False;vm.run('WOS_MinimapSummon');self.assertEqual([467.],calls)

    def test_live_objects_single_level_black_flame_positions_auras_and_compact_levels(self):
        docs,_=objects.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
        original=json.dumps(docs,sort_keys=True);apply_packet(docs)
        self.assertEqual(original,json.dumps(docs,sort_keys=True))
        by_id={}
        for d in docs:
            if d['source_file'] in ('war3map.w3a','war3mapSkin.w3a'):
                for o in d['custom_objects']:
                    by_id.setdefault(objects.object_id(o),{}).update({m['field']['text']:objects.value_for_user(m) for m in o['modifications'] if m.get('level',0)<=1})
        ids={}
        for p in (ROOT/'triggers/Heroes').rglob('*.j'):
            ids.update(re.findall(r"\binteger (\w+)\s*=\s*'(....)'",p.read_text(encoding='utf-8-sig')))
        for slot,name in re.findall(r'AHUI_AddHeroAbility\(whichHero, AHUI_SLOT_([FG]), (\w+)\)',source('WOS_Start/ShowCD.j')):
            self.assertEqual((1 if slot=='F' else 2,1),(by_id[ids[name]]['abpx'],by_id[ids[name]]['abpy']),name)
        self.assertEqual(1,by_id['A113']['alev'])
        self.assertEqual(('G','G','Black Flame'),tuple(by_id['A113'][k] for k in ('ahky','arhk','atp1')))
        for identity in ('A02C','A115'):
            self.assertEqual(('Absk',1,1),next((o['old_id']['text'],by_id[identity]['abpx'],by_id[identity]['abpy'])
                for d in docs for o in d['custom_objects'] if objects.object_id(o)==identity))
            self.assertEqual('F',by_id[identity]['ahky'])
        self.assertEqual((225.,750.,1500.),tuple(by_id[k]['aare'] for k in ('A09Z','A0A7','A0AG')))
        abilities=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
        for obj in abilities.values():
            if 'levels' in obj:
                self.assertTrue(all(int(m[1])<=obj['levels'] for k in obj for m in [re.search(r' level (\d+)$',k)] if m))
        buffs=json.loads((ROOT/'object-data/buffs.json').read_text(encoding='utf-8-sig'))
        self.assertIn('18%',buffs['B03F']['extended_tooltip'])
        self.assertNotIn('15%',buffs['B03F']['extended_tooltip'])
        self.assertIn('0.4x',buffs['B041']['extended_tooltip'])


if __name__ == '__main__':
    unittest.main()
