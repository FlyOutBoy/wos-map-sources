"""Bounded redraws and common event work, using production JASS in the VM."""
from pathlib import Path
import re
import unittest
from test_crocodile import JassState
import test_damage_stats as damage_fixture

ROOT=Path(__file__).resolve().parents[1]

def functions(path,*names):
    text=(ROOT/path).read_text(encoding='utf-8-sig')
    return '\n'.join(re.search(r'(?m)^\s*(?:(?:private|public) )?function '+name+r' takes[^\n]*\n[\s\S]*?^\s*endfunction',text)[0] for name in names)

class CommonPerformance(unittest.TestCase):
    def test_repeated_selection_skips_tooltips_ability_refresh_and_test_alliances(self):
        unit=object();calls=[]
        vm=JassState(functions('triggers/WOS_Start/UniversalTooltips.j','OnHeroEvent'))
        vm.g.update(GetTriggerUnit=lambda:unit,GetOwningPlayer=lambda _:0,GetPlayerId=lambda p:p,
            GetTriggerEventId=lambda:1,EVENT_PLAYER_UNIT_SELECTED=1,WATCHED_HERO={0:unit},
            RequestHeroTooltipUpdate=lambda *_:calls.append('tooltip'))
        for _ in range(1000):vm.run('OnHeroEvent')
        self.assertEqual([],calls)
        vm=JassState(functions('triggers/WOS_Start/ShowCD.j','AHUI_OnSelect'))
        vm.g.update(GetTriggerUnit=lambda:unit,GetTriggerPlayer=lambda:0,GetPlayerId=lambda p:p,
            GetLocalPlayer=lambda:0,Player=lambda p:p,AHUI_DeselectPending={0:False},
            AHUI_SelectedHero={0:unit},AHUI_Refresh=lambda *_:calls.append('ability'))
        for _ in range(1000):vm.run('AHUI_OnSelect')
        self.assertEqual([],calls)
        vm=JassState(functions('triggers/WOS_Start/TestUnit.j','Trig_TestUnit_Actions'))
        def control(*_):
            calls.append('alliance');vm.g['TestUnitController']=0
        vm.g.update(GetTriggerUnit=lambda:unit,GetTriggerPlayer=lambda:0,GetPlayerId=lambda p:p,
            GetOwningPlayer=lambda _:6,IsUnitType=lambda *_:True,UNIT_TYPE_HERO='hero',TestMode=True,
            TestUnit=unit,TestAllyUnit=None,TestUnitController=0,TestUnitPlayerId=6,HeroChosen={0:unit},
            TestUnit_ConfigureControl=control)
        for _ in range(1000):vm.run('Trig_TestUnit_Actions')
        self.assertEqual([],calls)
        vm.g['TestUnitController']=1;vm.run('Trig_TestUnit_Actions')
        self.assertEqual(['alliance'],calls)

    def test_slow_hud_stats_once_per_second_and_selection_hover_force_immediate(self):
        vm=JassState(functions('triggers/WOS_Start/DefaultArmorChangeStable_Copy.j','UNITSTAT_ShouldRefreshStats'))
        vm.g.update(UNITSTAT_StatsUnit=None,UNITSTAT_StatsType=0,UNITSTAT_StatsMode=-1,
                    UNITSTAT_StatsHover=-1,UNITSTAT_StatsTicks=0)
        self.assertEqual([0,5,10],[tick for tick in range(11) if vm.run('UNITSTAT_ShouldRefreshStats',('hero',1,2,-1))])
        for args in [('other',1,2,-1),('other',2,2,-1),('other',2,3,-1),('other',2,3,0)]:
            self.assertTrue(vm.run('UNITSTAT_ShouldRefreshStats',args))
            self.assertFalse(vm.run('UNITSTAT_ShouldRefreshStats',args))
        text=functions('triggers/WOS_Start/DefaultArmorChangeStable_Copy.j','UNITSTAT_Render')
        slow=text.split('    // Outgoing damage bonus',1)[1].split('    set i = 0\n    loop',1)[0]
        self.assertIn('DamageCheckModifiers',slow)
        fast=text.split('    set i = 0\n    loop\n        exitwhen i >= 2',1)[1]
        self.assertIn('WUI_SetValue(UNITSTAT_Bar[i]',fast)
        self.assertIn('GetWidgetLife(selected)',fast)
        self.assertIn('if refreshStats then',fast)

    def test_empty_spell_dispatch_and_opt_in_listener_preserve_handled_context(self):
        vm=JassState(functions('triggers/Systems/Systems2.j','GearSpellAddListener','GearSpellDispatch'))
        listeners=[];calls=[]
        vm.g.update(GearSpellHasListeners=False,GearSpellListeners=listeners,GearSpellHandled=True,
            TriggerAddAction=lambda trigger,callback:(trigger.append(callback),callback)[1],
            TriggerExecute=lambda trigger:(calls.append(1),[fn() for fn in trigger]))
        for _ in range(1000):self.assertFalse(vm.run('GearSpellDispatch'))
        self.assertEqual([],calls);self.assertTrue(vm.g['GearSpellHandled'])
        vm.run('GearSpellAddListener',(lambda:vm.g.update(GearSpellHandled=True),))
        self.assertTrue(vm.run('GearSpellDispatch'));self.assertEqual(1,len(calls))
        self.assertTrue(vm.g['GearSpellHandled'])

    def test_empty_damage_dispatch_and_nested_listener_context(self):
        vm=JassState(functions('triggers/Systems/Systems2.j','GearDamageAddListener','GearDamageRun'))
        calls=[];listeners=[]
        vm.g.update(GearDamageHasListeners=False,GearDamageListeners=listeners,
            GearDamageSource='previous',GearDamageTarget='old-target',GearDamageAmount=77.,
            GearDamageType=2,GearDamagePhase=3,
            TriggerAddAction=lambda trigger,callback:(trigger.append(callback),callback)[1],
            TriggerExecute=lambda trigger:(calls.append(1),[fn() for fn in trigger]))
        for _ in range(1000):self.assertEqual(10.,vm.run('GearDamageRun',('outer','target',10.,1,1)))
        self.assertEqual([],calls)
        def listener():
            if vm.g['GearDamageSource']=='outer':
                self.assertEqual(5.,vm.run('GearDamageRun',('inner','target',3.,2,2)))
                self.assertEqual('outer',vm.g['GearDamageSource'])
                self.assertEqual(10.,vm.g['GearDamageAmount'])
            vm.g['GearDamageAmount']+=2.
        vm.run('GearDamageAddListener',(listener,))
        self.assertEqual(12.,vm.run('GearDamageRun',('outer','target',10.,1,1)))
        self.assertEqual(2,len(calls))
        self.assertEqual(('previous','old-target',77.,2,3),tuple(vm.g[n] for n in
            ('GearDamageSource','GearDamageTarget','GearDamageAmount','GearDamageType','GearDamagePhase')))
        all_j='\n'.join(p.read_text(encoding='utf-8-sig') for p in (ROOT/'triggers').rglob('*.j'))
        self.assertEqual(1,len(re.findall(r'TriggerAddAction\(GearDamageListeners\s*,',all_j)))
        self.assertIn('TriggerAddAction(GearDamageListeners, callback)',functions(
            'triggers/Systems/Systems2.j','GearDamageAddListener'))

    def damage(self):
        f=damage_fixture.DamageStats();f.setUp();return f

    def test_damage_redraw_every_ten_half_second_ticks_and_forced_ui_is_immediate(self):
        f=self.damage();redraws=[];f.visible['small']=True
        f.vm.g['DS_RenderView']=lambda *a:redraws.append(a)
        for tick in range(21):
            f.hit();before=len(redraws);f.runj('DS_Tick')
            self.assertEqual(tick in (0,10,20),len(redraws)>before)
        before=len(redraws);f.vm.g['DS_LastVersion']=-1;f.runj('DS_Tick')
        self.assertEqual(before+1,len(redraws))
        self.assertEqual(210.,f.runj('DamageStatsTotal',0,0))

    def test_damage_source_kind_loaded_once_per_record_not_per_bucket(self):
        f=self.damage();reads=[];original=f.vm.g['LoadInteger'];table=f.vm.g['DS_SourceKind']
        def load(target,*args):
            if target is table:reads.append(args)
            return original(target,*args)
        f.vm.g.update(LoadInteger=load,DamageStatsHitKind=1)
        for _ in range(1000):f.runj('DamageStatsRecordHit',0,2,100000,10.9,0.)
        self.assertEqual(2000,len(reads))
        for page,pid in ((0,0),(1,0),(2,0),(4,2),(5,2),(6,2)):
            self.assertEqual(10000.,f.runj('DamageStatsTotal',pid,page))

    def test_cast_does_not_schedule_full_tooltip_rebuild_but_poll_and_forms_remain(self):
        text=(ROOT/'triggers/WOS_Start/UniversalTooltips.j').read_text(encoding='utf-8-sig')
        registration=re.findall(r'TriggerRegisterPlayerUnitEvent\(t, Player\(i\), (\w+), null\)',text)
        self.assertNotIn('EVENT_PLAYER_UNIT_SPELL_EFFECT',registration)
        self.assertIn('POLL_PERIOD = 5.00',text)
        self.assertIn('EVENT_PLAYER_HERO_SKILL',registration)
        self.assertIn('RequestHeroTooltipUpdate',functions('triggers/WOS_Start/UniversalTooltips.j','OnPollTimeout'))
        self.assertIn('UpdateHeroTooltips(hero)',functions('triggers/WOS_Start/UniversalTooltips.j','SetUnitForm'))

    def test_tooltip_native_writes_only_when_description_changes(self):
        vm=JassState((ROOT/'triggers/WOS_Start/TooltipBuilder.j').read_text(encoding='utf-8-sig').replace(
            '    struct TooltipBuilder','    private struct TooltipBuilder'))
        values={};writes=[]
        def put(kind,key,text):
            values[kind,key]=text;writes.append((kind,key,text))
        vm.g.update(TooltipTextRevision=0,BlzGetAbilityExtendedTooltip=lambda a,l:values.get(('spell',(a,l)),''),
            BlzSetAbilityExtendedTooltip=lambda a,t,l:put('spell',(a,l),t),
            BlzGetAbilityResearchExtendedTooltip=lambda a,l:values.get(('learn',(a,l)),''),
            BlzSetAbilityResearchExtendedTooltip=lambda a,t,l:put('learn',(a,l),t),
            BlzGetItemExtendedTooltip=lambda i:values.get(('item',i),''),
            BlzSetItemExtendedTooltip=lambda i,t:put('item',i,t))
        data=vm.structs['TooltipBuilder'].create();data.buffer='same description'
        for _ in range(100):
            data.applyToAbility('spell',1);data.applyToAbilityLearn('spell',1);data.applyToItem('item')
        self.assertEqual(3,len(writes))
        data.buffer='new description';data.applyToAbility('spell',1)
        self.assertEqual(4,len(writes))

    def test_tooltips_have_formulas_without_combat_damage_evaluation(self):
        text=(ROOT/'triggers/WOS_Start/UniversalTooltips.j').read_text(encoding='utf-8-sig')
        self.assertNotIn('DamageCheck(',text)
        refresh=functions('triggers/WOS_Start/UniversalTooltips.j','RefreshSkill')
        self.assertNotIn('checkedDamage',refresh)
        self.assertIn('FormulaStr(data.statType, formulaBase,',refresh)
        self.assertIn('MilimQ_ThresholdAgiBonus * I2R(milimSteps)',refresh)
        self.assertIn('MilimT2_ThresholdAgiBonus * I2R(milimSteps)',refresh)

    def test_stationary_hover_does_not_reposition_range_effect(self):
        vm=JassState(functions('triggers/WOS_Start/AbilityRangePreview.j','AR_Render'));moves=[]
        vm.g.update(AR_RequestedHero={0:'hero'},AR_RequestedAbility={0:'spell'},AR_RequestedItemSlot={0:-1},
            AR_Hero={0:'hero'},AR_Effect={0:'effect'},AR_Visible=-1,AR_Scale=0.,AR_LastX=0.,AR_LastY=0.,AR_Ground='ground',
            Player=lambda x:x,GetLocalPlayer=lambda:0,WUI_RangePreviewBlocked=lambda:False,
            GetUnitTypeId=lambda _:1,GetOwningPlayer=lambda _:0,IsUnitHidden=lambda _:False,IsUnitType=lambda *_:False,
            UNIT_TYPE_DEAD='dead',AAUniversalTooltips_GetPreviewRadius=lambda *_:1000.,MilimT2_ID='other',
            GetUnitX=lambda _:vm.g['heroX'],GetUnitY=lambda _:200.,heroX=100.,
            MoveLocation=lambda *a:moves.append(a),GetLocationZ=lambda _:5.,
            BlzSetSpecialEffectPosition=lambda *_:None,BlzSetSpecialEffectScale=lambda *_:None,
            BlzSetSpecialEffectAlpha=lambda *_:None)
        for _ in range(100):vm.run('AR_Render',(0,))
        self.assertEqual(1,len(moves))
        vm.g['heroX']=101.;vm.run('AR_Render',(0,));self.assertEqual(2,len(moves))

if __name__=='__main__':unittest.main()
