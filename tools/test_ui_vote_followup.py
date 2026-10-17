"""Production hero/HUD paths for the vote, invisibility and dual-meter follow-up."""
from pathlib import Path
from collections import defaultdict
import unittest
import re
import test_wos_ui as ui
import test_ui_followup as progress
import test_wos_ui_checkpoint20 as learning
import test_crocodile as crocodile
from test_crocodile import JassState
import png_tga

ROOT = Path(__file__).resolve().parents[1]
def source(path):return (ROOT/'triggers'/path).read_text(encoding='utf-8-sig')

class EvolvedLearning(unittest.TestCase):
    def test_both_rimuru_forms_fill_pips_from_displayed_spells(self):
        for form in [2,3]:
            f=learning.Learning();f.setUp();g=f.vm.g
            f.c.type=g['Rimuru_ID'];f.c.abilities.clear();f.c.skill_points=0
            for slot in 'QWERTFG':
                aid=g[f'Rimuru{slot}{form}_ID']
                f.c.abilities[aid]={'level':5 if slot in 'QWERT' else 1,'remaining':0}
            f.refresh()
            for slot in range(5):
                maximum=g['AHUI_PipMax'][slot]
                self.assertGreater(maximum,0)
                self.assertEqual(['UI\\WOS\\pip-full.tga']*maximum,f.pips(slot)[:maximum],(form,slot))

class RealBuffs(unittest.TestCase):
    def test_rimuru_counts_live_dodges_and_stays_visible_for_a_paused_extended_buff(self):
        vm=JassState(source('Heroes/Rimuru.j'));hero=vm.unit(owner=0);calls=[];clock=[]
        vm.g.update(Hero={0:hero},hs={},StringHash=lambda s:s,GetPlayerId=lambda p:p,
                    RimuruDodgeHero=defaultdict(lambda:None),RimuruDodgeAbility=defaultdict(int),
                    RimuruDodgeBuff=defaultdict(int),RimuruDodgeSeen=defaultdict(bool),RimuruDodgeGrace=defaultdict(float),
                    RimuruDodgeCount=0, GearTimer03Acquire=lambda:clock.append(1),GearTimer03Release=lambda:clock.append(-1),
                    WUI_HeroProgress=lambda *a:calls.append(a), I2R=float)
        for aid,buff in [('RimuruQ2_ID','RimuruQ2_Buff_ID'),('RimuruF3_ID','RimuruF3_Buff_ID')]:
            vm.run('RimuruTrackDodges',(hero,vm.g[aid],vm.g[buff]))
            vm.add_ability(hero,vm.g[buff]);hero.paused=True
            for _ in range(200):vm.run('RimuruDodgeProgressTick')
            self.assertEqual((4.,4.,False),calls[-1][3:])
            vm.g['hs'][id(hero),'dodge q']=2
            vm.run('RimuruDodgeProgressTick')
            self.assertEqual((2.,4.,False),calls[-1][3:])
            vm.remove_ability(hero,vm.g[buff]);vm.run('RimuruDodgeProgressTick')
            self.assertEqual((0.,0.,True),calls[-1][3:])
            self.assertEqual(0,vm.g['RimuruDodgeCount'])
            vm.g['hs'][id(hero),'dodge q']=0
        self.assertEqual([1,-1,1,-1],clock)

    def test_buff_application_reads_native_object_duration_for_target_type_and_rank(self):
        text=source('Systems/Systems1.j');a=text.index('function BuffUnit01 takes');b=text.index('endfunction',a)
        vm=JassState(text[a:b]+'endfunction');hero=vm.unit(owner=0);dummy=vm.unit();reads=[]
        vm.g.update(GetPlayerId=lambda p:p, Player=lambda p:p, gg_rct_Caster='caster',
                    CreateUnit=lambda *_:dummy, GetRectCenterX=lambda _:0.,GetRectCenterY=lambda _:0.,
                    SetUnitAbilityLevel=lambda *_:None, SetUnitFacing=lambda *_:None, GAngle=lambda *_:0.,
                    IssueTargetOrder=lambda *_:None, MyRemoveUnit=lambda *_:None,
                    BlzGetUnitAbility=lambda d,a:(d,a),
                    IsUnitType=lambda u,t:u is hero,
                    BlzGetAbilityRealLevelField=lambda a,f,l:reads.append((f,l)) or (4. if f=='ABILITY_RLF_DURATION_HERO' else 3.))
        self.assertEqual(4.,vm.run('BuffUnit01',(hero,hero,'curse','curse',5)))
        self.assertEqual(3.,vm.run('BuffUnit01',(hero,dummy,'curse','curse',2)))
        self.assertEqual([('ABILITY_RLF_DURATION_HERO',4),('ABILITY_RLF_DURATION_NORMAL',1)],reads)

class DualMeters(unittest.TestCase):
    def test_dual_rows_allocate_one_panel_once_and_keep_two_independent_values(self):
        f=progress.Progress();f.setUp();vm=f.vm;sizes={}
        vm.g.update(BlzFrameSetSize=lambda h,w,z:sizes.update({h:(w,z)}),BlzFrameSetLevel=lambda *_:None,
                    HaveSavedHandle=lambda t,k,c:(k,c) in t,
                    SaveFrameHandle=lambda t,k,c,v:t.update({(k,c):v}),
                    LoadFrameHandle=lambda t,k,c:t.get((k,c)),
                    BlzFrameSetTextAlignment=lambda *_:None, WUI_RepinMeter=lambda *_:True,
                    TEXT_JUSTIFY_MIDDLE='middle',TEXT_JUSTIFY_CENTER='center')
        vm.run('WUI_HeroProgressDual',(f.hero,10,'Eye',6.,7.,2.,4.))
        panel=vm.g['WUI_ProgressPanel'][1];key=vm.g['GetHandleId'](panel)
        count=len(f.created)
        self.assertEqual(1,len(f.registered))
        self.assertEqual((.140,.0375),sizes[panel])
        self.assertIn('6.0s',f.texts[vm.g['WUI_ProgressValue'][1]])
        top=vm.g['WUI_MeterEdges'][key,22]
        self.assertIn('2 / 4',f.texts[top])
        vm.run('WUI_HeroProgressDual',(f.hero,10,'Eye',5.,7.,3.,4.))
        self.assertEqual(count,len(f.created))
        self.assertIn('3 / 4',f.texts[top])
        self.assertIn('5.0s',f.texts[vm.g['WUI_ProgressValue'][1]])

    def test_mixed_heights_never_overlap_when_added_hidden_or_minimap_changes(self):
        f=ui.DynamicHeroAndBuffDocks();f.setUp();g=f.vm.g
        frames=['dual-a','normal-a','dual-b','normal-b']
        heights=[.0375,.025,.0375,.025]
        for name,height in zip(frames,heights):
            f.register(name)
            if height>.025:g['WUI_MeterEdges'][g['GetHandleId'](name),7]=height
        def check(names):
            for a,b in zip(names,names[1:]):
                ha=heights[frames.index(a)];hb=heights[frames.index(b)]
                self.assertGreaterEqual(f.positions[b][1]-hb/2 - (f.positions[a][1]+ha/2),.00499)
        f.vm.run('WUI_RefreshDocks');check(frames)
        f.visible['dual-a']=False
        for _ in range(4):f.vm.run('WUI_RefreshDocks');check(frames[1:])
        g['WUI_MinimapHiddenOf'][0]=True
        f.vm.run('WUI_RefreshDocks');check(frames[1:])

    def test_repin_positions_both_real_fill_handles_and_both_value_labels(self):
        vm=ui.load_source('WOSUI.j');points=[]
        vm.g.update(GetHandleId=lambda x:x,WUI_Pin=lambda *a:points.append(a),
                    FRAMEPOINT_LEFT='left', FRAMEPOINT_CENTER='center',
                    BlzFrameSetPoint=lambda *a:points.append(a),BlzFrameClearAllPoints=lambda *_:None,
                    HaveSavedHandle=lambda t,k,c:(k,c) in t,LoadFrameHandle=lambda t,k,c:t.get((k,c)),
                    HaveSavedReal=lambda t,k,c:(k,c) in t,LoadReal=lambda t,k,c:t.get((k,c),0))
        for n in [1,2,3,4,5,20,21,22]:vm.g['WUI_MeterEdges']['panel',n]=f'part{n}'
        vm.g['WUI_MeterEdges']['panel',6]=.7;vm.g['WUI_MeterEdges']['panel',7]=.0375
        vm.g['WUI_BarInfo']['part2',2]='lower-real-fill'
        self.assertTrue(vm.run('WUI_RepinMeter',('panel',)))
        top=next(p for p in points if p[0]=='part22');lower=next(p for p in points if p[0]=='part5')
        self.assertGreater(top[3],lower[3])
        self.assertTrue(any(p[0]=='lower-real-fill' and p[-1]==-.0105 for p in points))

class PortraitAndAssets(unittest.TestCase):
    def test_invis_alpha_and_label_restore_on_end_or_selected_unit_change(self):
        vm=ui.load_source('WOSUI.j');alpha={};visible={'portrait':True}
        vm.g.update(WUI_PortraitIcon='portrait',WUI_InvisLabel='label',WUI_InvisBacking='backing',WUI_InvisPortrait=False,
                    BlzFrameSetAlpha=lambda f,a:alpha.update({f:a}),
                    BlzFrameSetVisible=lambda f,v:visible.update({f:v}),BlzFrameIsVisible=lambda f:visible.get(f,False))
        vm.run('WUI_SetPortraitInvisible',(True,));self.assertEqual(85,alpha['portrait']);self.assertTrue(visible['label']);self.assertTrue(visible['backing'])
        vm.run('WUI_SetPortraitInvisible',(False,));self.assertEqual(255,alpha['portrait']);self.assertFalse(visible['label']);self.assertFalse(visible['backing'])
        visible['portrait']=False;vm.run('WUI_SetPortraitInvisible',(True,));self.assertFalse(visible['label'])

    def test_generated_assets_have_real_alpha_and_hover_has_no_middle_stripe(self):
        from install_wos_ui_assets import ASSET_NAMES
        for name in ['invis-label','vote-ff','vote-kick','meter-fill-red']:
            self.assertIn(name,ASSET_NAMES)
            w,h,rows=png_tga.read_tga(ROOT/f'assets/UI/WOS/{name}.tga')
            if name!='meter-fill-red':
                alphas=[a for row in rows for a in row[3::4]]
                self.assertEqual(0,min(alphas));self.assertGreater(max(alphas),240)
        w,h,rows=png_tga.read_tga(ROOT/'assets/UI/WOS/fill-hover-blue.tga')
        blues=[row[(w//2)*4+2] for row in rows]
        self.assertTrue(all(a>=b for a,b in zip(blues,blues[1:])))

class HitCoverage(unittest.TestCase):
    def test_crocodile_q_hits_visible_last_two_hundred_once_without_moving_model_end(self):
        f=crocodile.CrocodileStateTests();f.setUp();f.c.type=f.vm.g['Crocodile_ID']
        f.vm.g['SaveInteger'](f.vm.g['CrocodileTable'],id(f.c),f.vm.g['CrocodileCore_DataKey'],1)
        f.vm.g['BuffUnit01']=lambda *_:0.
        target=f.vm.unit(x=1850,owner=2)
        outside=f.vm.unit(x=1655+200+155+5,owner=2)
        f.vm.add_ability(f.c,f.vm.g['CrocodileQ_ID'])
        self.assertTrue(f.vm.run('CrocodileQ_Start',(f.c,300.,0.)))
        q=f.vm.structs['CrocodileQ_Struct'].m[0]
        for _ in range(40):f.vm.run('Loop_CrocodileQ')
        self.assertEqual(1655,q.distance)
        self.assertEqual(1,sum(t is target for _,t,_ in f.vm.damage))
        self.assertEqual(0,sum(t is outside for _,t,_ in f.vm.damage))

    def test_tsuna_ge_includes_point_blank_without_extending_far_end(self):
        text=source('Heroes/Tsuna.j');a=text.index('                        set r3 = 0',text.index('struct TsunaE2KS'))
        b=text.index('                        set k = 0\n                        set r3 = 125',a)
        block=text[a:b]
        vm=JassState('function Fire takes nothing returns nothing\n'+block+'\nendfunction')
        hero=vm.unit(owner=0);target=vm.unit(x=0,owner=1);far=vm.unit(x=2540,owner=1)
        vm.g.update(c=hero,x=0.,y=0.,a=0.,aoe=200.,dmg=100.,k=0,k2=0,k3=0,k4=0,kkk=0,r3=0.,check2=0,
                    g=[],g2=[],u=None,TsunaE2_DecorDamage=10.,TsunaE2_StunDuration=1.,
                    DecorRemove=lambda *_:None, VisionTimed=lambda *_:None, StunUnit=lambda *_:None,
                    GroupClear=lambda g:g.clear(),
                    dmgmag=lambda c,u,d:vm.damage.append((c,u,d)),
                    DestroyEffect=lambda *_:None,AddSpecialEffectTarget=lambda *_:None)
        vm.run('Fire')
        self.assertEqual(1,sum(t is target for _,t,_ in vm.damage))
        self.assertEqual(1,sum(t is far for _,t,_ in vm.damage))

if __name__=='__main__':unittest.main()
