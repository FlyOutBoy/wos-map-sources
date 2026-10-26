"""Execute selection handlers against TEST and MAIN settings, without a game."""
from collections import defaultdict
from pathlib import Path
import re
import unittest
from test_crocodile import JassState

ROOT=Path(__file__).resolve().parents[1]


def source(file,*names):
    text=(ROOT/'triggers'/file).read_text('utf-8-sig')
    return '\n'.join(re.search(r'(?:private )?function '+name+r' takes.*?endfunction',text,re.S)[0] for name in names).replace('static if ','if ')


class AutoSelectPolicy(unittest.TestCase):
    def damage_vm(self,test=False,enabled=False,ui=True):
        vm=JassState(source('Systems/DmgSys.j','DmgSys_AutoSelectHero'))
        self.selected=[];self.started=[]
        vm.g.update(TestMode=test,LIBRARY_WOSTestMinimalRuntime=test,LIBRARY_HeroUnitPanelStats=ui,
            WUI_AutoSelectHero=defaultdict(bool,{0:enabled}),DmgSys_Clock=None,
            DmgSys_AutoSelectAt=defaultdict(float),DMGSYS_AUTOSELECT_CD=2.0,
            CreateTimer=lambda:'timer',TimerStart=lambda *a:self.started.append(a),
            GetLocalPlayer=lambda:0,Player=lambda p:p,IsUnitSelected=lambda *a:False,
            TimerGetElapsed=lambda t:10.0,ClearSelection=lambda:None,
            SelectUnit=lambda u,b:self.selected.append(u))
        return vm,vm.unit(owner=0)

    def test_damage_never_selects_in_test_even_with_saved_option_enabled(self):
        vm,u=self.damage_vm(test=True,enabled=True)
        for _ in range(8):vm.run('DmgSys_AutoSelectHero',(0,u))
        self.assertEqual([],self.selected);self.assertEqual([],self.started)

    def test_damage_respects_main_option_before_creating_clock(self):
        vm,u=self.damage_vm(enabled=False)
        vm.run('DmgSys_AutoSelectHero',(0,u))
        self.assertEqual([],self.selected);self.assertEqual([],self.started)
        vm.g['WUI_AutoSelectHero'][0]=True
        vm.run('DmgSys_AutoSelectHero',(0,u))
        self.assertEqual([u],self.selected);self.assertEqual(1,len(self.started))
        vm.g['WUI_AutoSelectHero'][0]=False
        vm.g['TimerGetElapsed']=lambda t:20.
        vm.run('DmgSys_AutoSelectHero',(0,u))
        self.assertEqual([u],self.selected)

    def test_damage_cannot_select_without_main_settings_owner(self):
        vm,u=self.damage_vm(enabled=True,ui=False)
        vm.run('DmgSys_AutoSelectHero',(0,u))
        self.assertEqual([],self.selected);self.assertEqual([],self.started)

    def test_periodic_handler_rejects_test_mode_and_stale_enabled_mirror(self):
        vm=JassState(source('WOS_Start/DefaultArmorChangeStable_Copy.j','UNITSTAT_AutoSelectTick'))
        u=vm.unit(owner=0);selected=[]
        vm.g.update(TestMode=True,LIBRARY_WOSTestMinimalRuntime=True,UNITSTAT_AutoSelect=defaultdict(bool,{0:True}),
            WUI_AutoSelectHero=defaultdict(bool,{0:True}),Hero=defaultdict(lambda:None,{0:u}),
            GetLocalPlayer=lambda:0,Player=lambda p:p,IsUnitHidden=lambda u:False,
            IsUnitType=lambda *a:False,GearSelectOnlyHero=lambda u:selected.append(u))
        vm.run('UNITSTAT_AutoSelectTick');self.assertEqual([],selected)
        vm.g['TestMode']=False;vm.g['LIBRARY_WOSTestMinimalRuntime']=False;vm.g['WUI_AutoSelectHero'][0]=False
        vm.run('UNITSTAT_AutoSelectTick');self.assertEqual([],selected)
        vm.g['WUI_AutoSelectHero'][0]=True
        vm.run('UNITSTAT_AutoSelectTick');self.assertEqual([u],selected)

    def test_test_settings_do_not_start_periodic_selection_timer(self):
        vm=JassState(source('WOS_Start/DefaultArmorChangeStable_Copy.j','UNITSTAT_SetAutoSelect'))
        started=[]
        vm.g.update(TestMode=True,LIBRARY_WOSTestMinimalRuntime=True,UNITSTAT_AutoSelect=defaultdict(bool),
            UNITSTAT_AutoSelectUsers=0,UNITSTAT_AutoSelectTimer=None,
            CreateTimer=lambda:'timer',TimerStart=lambda *a:started.append(a))
        vm.run('UNITSTAT_SetAutoSelect',(0,True))
        self.assertEqual([],started);self.assertFalse(vm.g['UNITSTAT_AutoSelect'][0])

    def test_main_sandbox_button_starts_and_stops_selection(self):
        vm=JassState(source('WOS_Start/DefaultArmorChangeStable_Copy.j',
            'UNITSTAT_SetAutoSelect','UNITSTAT_OnAutoSelect'))
        started=[];stopped=[]
        vm.g.update(TestMode=True,LIBRARY_WOSTestMinimalRuntime=False,
            UNITSTAT_AutoSelect=defaultdict(bool),WUI_AutoSelectHero=defaultdict(bool),
            UNITSTAT_AutoSelectUsers=0,UNITSTAT_AutoSelectTimer=None,UNITSTAT_AutoSelectToggle=None,
            CreateTimer=lambda:'timer',TimerStart=lambda *a:started.append(a),PauseTimer=lambda t:stopped.append(t),
            GetPlayerId=lambda p:p,GetTriggerPlayer=lambda:0,Player=lambda p:p,GetLocalPlayer=lambda:0,UNITSTAT_AutoSelectTick=lambda:None,WUI_ResetClickedButtonFocus=lambda:None)
        vm.run('UNITSTAT_OnAutoSelect')
        self.assertTrue(vm.g['UNITSTAT_AutoSelect'][0]);self.assertEqual(1,len(started))
        vm.run('UNITSTAT_OnAutoSelect')
        self.assertFalse(vm.g['UNITSTAT_AutoSelect'][0]);self.assertEqual(['timer'],stopped)


if __name__=='__main__':unittest.main()
