"""Shared guide state, real preview metadata, compact votes and 2D reorder."""
from collections import defaultdict
from pathlib import Path
import json
import re
import unittest
import test_wos_ui as ui
import test_ui_followup as followup
import test_match_votes as votes
import test_quickbuy_fix8 as quickbuy

ROOT=Path(__file__).resolve().parents[1]

class GuideSync(unittest.TestCase):
    def test_mixed_new_and_existing_clients_have_identical_shared_state(self):
        peers=[]
        for local,marker in [(0,''),(1,'1')]:
            f=followup.Guide();f.setUp();f.local=local;f.file=marker
            f.vm.run('SaveSystem_HelpTick');peers.append(f)
        self.assertEqual([('WOS2GUIDE','N')],peers[0].sent)
        self.assertEqual([('WOS2GUIDE','P')],peers[1].sent)
        for f in peers:
            f.status(0,'N');f.status(1,'P');f.vm.run('SaveSystem_HelpTick')
        self.assertTrue(peers[0].visible);self.assertFalse(peers[1].visible)
        for f in peers:
            f.sender=1;f.vm.run('SaveSystem_HelpChat')
        for tick in range(161):
            for f in peers:f.vm.run('SaveSystem_HelpTick')
            for name in ['ss_HelpOpen','ss_HelpHandled','ss_HelpLeft','ss_HelpEligible']:
                self.assertEqual([peers[0].vm.g[name][p] for p in range(10)],
                                 [peers[1].vm.g[name][p] for p in range(10)],(name,tick))
        self.assertFalse(any(f.visible for f in peers))
        self.assertEqual([('Wos2\\playedonce.txt','1')],peers[0].writes)
        self.assertEqual([('Wos2\\playedonce.txt','1')],peers[1].writes)

    def test_guide_tick_uses_shared_player_loop_and_no_exclusive_or_modal_path(self):
        text=(ROOT/'triggers/WOS_Start/SaveLoad.j').read_text(encoding='utf-8-sig')
        tick=text.split('private function SaveSystem_HelpTick takes',1)[1].split('endfunction',1)[0]
        self.assertIn('local integer pid = 0',tick)
        self.assertNotIn('GetPlayerId(GetLocalPlayer())',tick)
        show=text.split('private function SaveSystem_HelpShow takes',1)[1].split('endfunction',1)[0]
        self.assertNotIn('WUI_EnterExclusiveWindow',show);self.assertNotIn('WUI_RegisterModal',show)

    def test_guide_collapse_bit_roundtrips_with_both_existing_ui_bits(self):
        for flags in range(8):
            vm=ui.load_source('WOSUI.j')
            vm.run('WUI_ApplySettingsUIRecord',(0,flags))
            self.assertEqual('U,'+str(flags)+'|',vm.run('WUI_SettingsUIRecord',(0,)))
            self.assertEqual(bool(flags&4),vm.g['WUI_HeroGuideHiddenOf'][0])
            self.assertEqual(bool(flags&2),vm.g['WUI_InfoHiddenOf'][0])

class Preview(unittest.TestCase):
    def setUp(self):
        self.vm=ui.load_source('WoS_Pick_Init.j');g=self.vm.g
        heroes=['Rimuru','Takeshi','Tsuna','Ainz','Kenjaku','Kyoraku','Toji','Inori','Frieren','Gojo','Natsu','Starrk']
        paths=[ROOT/f'triggers/Heroes/{h}.j' for h in heroes]+list((ROOT/'triggers/Heroes/Erza').glob('*.j'))
        for p in paths:
            for name,value in re.findall(r"(?m)^\s*(?:private )?(?:constant )?integer (\w+)\s*=\s*'(.{4})'",p.read_text(encoding='utf-8-sig')):g[name]=value
        self.objects=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
        self.texts={};self.textures={};self.visible={};self.created=[]
        def frame(*args):
            self.created.append(args);return len(self.created)
        g.update(I2R=lambda n:float(int(n)),WOS_PreviewTable={},FRAME_MAIN3='picker',FRAME_HeroModel='portrait',
            WUI_TextButton=frame,WUI_GoldFrame=frame,WUI_Place=lambda *_:None,
            WUI_SetButtonTextScale=lambda *_:None,WUI_SetButtonCaption=lambda f,s:self.texts.update({f:s}),
            WUI_SetToggleState=lambda *_:None,BlzFrameSetLevel=lambda *_:None,
            BlzTriggerRegisterFrameEvent=lambda *_:None,FRAMEEVENT_CONTROL_CLICK='click',
            CreateTrigger=lambda:{},TriggerAddAction=lambda *_:None,
            SaveStr=lambda t,k,c,v:t.update({(k,c):v}),LoadStr=lambda t,k,c:t.get((k,c),''),
            BlzFrameSetVisible=lambda f,v:self.visible.update({f:v}),BlzFrameSetEnable=lambda *_:None,
            BlzFrameSetText=lambda f,s:self.texts.update({f:s}),
            BlzFrameSetTexture=lambda f,s,*_:self.textures.update({f:s}),
            AAUniversalTooltips_GetFormGuide=lambda a,f:'Wolf State: '+str(a),
            BlzGetAbilityIcon=lambda a:self.objects[a].get('icon',''),
            BlzGetAbilityResearchTooltip=lambda a,_:self.objects[a].get('research_tooltip',''),
            BlzGetAbilityResearchExtendedTooltip=lambda a,_:self.objects[a].get('research_extended_tooltip',''),
            BlzGetAbilityTooltip=lambda a,_:self.objects[a].get('tooltip level 1',''),
            BlzGetAbilityExtendedTooltip=lambda a,_:self.objects[a].get('extended_tooltip level 1',''))
        for i in range(7):
            for name in ['FRAME_AbiText','FRAME_ICON5','FRAME_ICON6','FRAME_AbilityTooltipText']:g[name][i]=name+str(i)
        self.vm.run('WOS_PreviewInit')
    def test_all_requested_kits_have_existing_abilities_and_portraits(self):
        g=self.vm.g;total=0
        expected={'Rimuru':3,'Erza':8,'Takeshi':3,'Tsuna':2,'Ainz':2,'Kenjaku':3,'Kyoraku':2,'Toji':2,'Inori':3,'Frieren':2,'Gojo':2,'Natsu':2,'Starrk':2}
        main=Path(json.loads((ROOT/'.vscode/wos-build.json').read_text(encoding='utf-8-sig'))['mainMap'])
        count=len(self.created)
        for hero,n in expected.items():
            identity=g[hero+'_ID'];self.assertEqual(n,g['WOS_PreviewTable'][identity,-1])
            self.vm.run('WOS_PreviewSelect',(identity,))
            for form in range(n):
                total+=1;g['WOS_PreviewForm']=form;self.vm.run('WOS_PreviewRender')
                self.assertTrue((main/self.textures['portrait'].replace('\\','/')).exists(),(hero,form))
                for i in range(7):
                    aid=g['WOS_PreviewTable'][identity,form*32+10+i]
                    if aid:
                        self.assertIn(aid,self.objects)
                        if hero=='Starrk' and form==1 and i<2:
                            self.assertIn('BTNHero_Starrk_T'+('Q' if i==0 else 'W'),self.textures['FRAME_ICON6'+str(i)])
                            self.assertIn('Wolf State',self.texts['FRAME_AbilityTooltipText'+str(i)])
                        else:
                            self.assertEqual(self.objects[aid].get('icon',''),self.textures['FRAME_ICON6'+str(i)])
                        self.assertTrue(self.texts['FRAME_AbilityTooltipText'+str(i)])
        self.assertEqual(36,total);self.assertEqual(count,len(self.created))
    def test_starrk_form_description_reads_alt_record_without_allocating_or_mutating(self):
        from types import SimpleNamespace
        from test_crocodile import JassState
        text=(ROOT/'triggers/WOS_Start/UniversalTooltips.j').read_text(encoding='utf-8-sig')
        body=text.split('public function GetFormGuide ',1)[1].split('endfunction',1)[0]
        vm=JassState('function GetFormGuide '+body+'endfunction')
        row=SimpleNamespace(bonus='Wolf State',statType=2,statBase=3.,statStep=.5,staticBase=0.,staticStep=0.,maxLv=5,mecha='Wolf mechanics')
        records={('Q',2):row};before=dict(vars(row));lookups=[]
        vm.g.update(HT_DATA=records,LoadInteger=lambda t,k,c:lookups.append((k,c)) or t.get((k,c),0),
            GetDesc=lambda a:'Q description',FormulaList=lambda *a:'Damage formula '+str(a),ParseLevelTags=lambda t,l:t)
        def forbid(*a):self.fail('local guide attempted shared allocation/mutation')
        for name in ['CreateUnit','BlzCreateFrameByType','CreateTrigger','CreateTimer','SaveInteger','SetUnitAbilityLevel']:
            vm.g[name]=forbid
        result=vm.run('GetFormGuide',('Q',2))
        self.assertIn('Wolf State',result);self.assertIn('Wolf mechanics',result)
        self.assertEqual([('Q',2)],lookups);self.assertEqual(before,vars(row))
        self.assertEqual('',vm.run('GetFormGuide',('Q',9)))

    def test_toji_variant_labels_reset_for_regular_form_and_other_hero(self):
        g=self.vm.g;self.vm.run('WOS_PreviewSelect',(g['Toji_ID'],));g['WOS_PreviewForm']=1;self.vm.run('WOS_PreviewRender')
        self.assertEqual(['Q1','Q2','Q3'],[self.texts['FRAME_AbiText'+str(i)] for i in range(3)])
        for identity in [g['Toji_ID'],g['Rimuru_ID'],'unlisted']:
            self.vm.run('WOS_PreviewSelect',(identity,))
            self.assertEqual(list('QWERTFG'),[self.texts['FRAME_AbiText'+str(i)] for i in range(7)])
            self.assertEqual(0,g['WOS_PreviewForm'])
    def test_rimuru_preview_uses_actual_r_t_icons_with_inverted_filenames(self):
        g=self.vm.g;self.vm.run('WOS_PreviewSelect',(g['Rimuru_ID'],))
        self.assertTrue(self.textures['FRAME_ICON63'].endswith('Rimuru_T.blp'))
        self.assertTrue(self.textures['FRAME_ICON64'].endswith('Rimuru_R.blp'))

class CompactVotes(unittest.TestCase):
    def test_build_and_render_empty_solo_team_and_full_lobby_have_all_controls(self):
        f=votes.MatchVotes();f.setUp();vm=f.vm;g=vm.g
        for name in re.findall(r'(?m)^    private framehandle (MV_\w+)\s*$',(ROOT/'triggers/WOS_Start/MatchVotes.j').read_text()):g.setdefault(name,None)
        visible={};enabled={};text={};size={};pos={};handles=[];models={};anchors={};scales={}
        def frame(*args):handles.append(args);return len(handles)
        g.update(CreateTrigger=lambda:{},TriggerAddAction=lambda *_:None,WUI_GetRoot=lambda:'root',
            BlzCreateFrameByType=frame,WUI_TextButton=frame,WUI_Window=frame,WUI_GoldFrame=frame,
            WUI_Place=lambda *_:None,WUI_Pin=lambda f,p,x,y,w,h:pos.update({f:(x,y,w,h)}),
            WUI_SetText=lambda f,s:text.update({f:s}),BlzFrameSetText=lambda f,s:text.update({f:s}),
            BlzFrameSetVisible=lambda f,v:visible.update({f:v}),BlzFrameIsVisible=lambda f:visible.get(f,False),
            BlzFrameSetEnable=lambda f,v:enabled.update({f:v}),BlzFrameSetSize=lambda f,w,h:size.update({f:(w,h)}),
            BlzFrameSetTexture=lambda *_:None,BlzFrameSetLevel=lambda *_:None,BlzFrameSetAlpha=lambda *_:None,
            BlzFrameSetPoint=lambda f,*a:anchors.update({f:a}),BlzFrameSetModel=lambda f,m,*_:models.update({f:m}),
            BlzFrameSetTextAlignment=lambda *_:None,BlzFrameSetScale=lambda f,v:scales.update({f:v}),WUI_Tooltip=lambda *_:None,
            BlzTriggerRegisterFrameEvent=lambda *_:None,BlzTriggerRegisterPlayerKeyEvent=lambda *_:None,
            WUI_RegisterModal=lambda *_:None,WOS_REPICK_X=.12,WOS_SWAP_Y=.57,I2R=lambda n:float(int(n)),R2I=int,
            TEXT_JUSTIFY_MIDDLE='middle',TEXT_JUSTIFY_CENTER='center',TEXT_JUSTIFY_LEFT='left',
            FRAMEPOINT_LEFT='left',FRAMEEVENT_CONTROL_CLICK='click',OSKEY_ESCAPE='escape',BlzGetAbilityIcon=lambda a:'icon')
        vm.run('MV_Build');count=len(handles)
        for frame_handle in [g['MV_Button'][0],g['MV_Button'][1],g['MV_Panel']]:
            self.assertEqual('top-actions',handles[frame_handle-1][1])
        for i in range(2):
            glow=g['MV_Glow'][i]
            self.assertEqual('SPRITE',handles[glow-1][0])
            self.assertEqual('Pick\\wos_IconShine1.mdx',models[glow])
            self.assertEqual(('left',g['MV_Button'][i],'left',0,.48),anchors[glow])
            self.assertEqual(.72,scales[glow]);self.assertEqual((1.,1.),size[glow])
            self.assertFalse(enabled[glow]);self.assertFalse(visible[glow])
        f.players={0};g['MV_View']=0;vm.run('MV_Render')
        self.assertTrue(visible[g['MV_Empty']]);self.assertIn('VOTE KICK',text[g['MV_Title']])
        self.assertEqual((.260,.135),size[g['MV_Panel']])
        g['MV_View']=1;vm.run('MV_Render');self.assertTrue(visible[g['MV_Start']])
        self.assertTrue(visible[g['MV_Row'][0]]);self.assertTrue(enabled[g['MV_Start']])
        self.assertFalse(enabled[g['MV_Row'][0]])
        f.players=set(range(10));f.heroes.update({p:vm.unit(owner=p) for p in f.players});g['Hero'].update(f.heroes)
        g['MV_View']=0;vm.run('MV_Render')
        self.assertEqual(9,sum(visible[g['MV_Row'][p]] for p in range(10)))
        self.assertLessEqual(size[g['MV_Panel']][1],.211)
        textures={};g['BlzFrameSetTexture']=lambda f,t,*_:textures.update({f:t})
        f.players={0,1,5};f.local=0;g['MV_View']=1;g['CondArena']=0
        f.begin(slot=1);f.local=1;vm.run('MV_Render')
        self.assertTrue(visible[g['MV_Glow'][1]])
        f.local=0;vm.run('MV_Render');self.assertFalse(visible[g['MV_Glow'][1]])
        self.assertTrue(visible[g['MV_RowMark'][0]])
        self.assertTrue(textures[g['MV_RowMark'][0]].endswith('checked.tga'))
        f.answer(1,slot=1,yes=2);vm.run('MV_Render')
        self.assertTrue(visible[g['MV_RowMark'][1]])
        self.assertTrue(textures[g['MV_RowMark'][1]].endswith('glyph-close.tga'))
        self.assertFalse(enabled[g['MV_Row'][1]])
        self.assertIn('READY IN 30s',text[g['MV_Title']])
        self.assertFalse(enabled[g['MV_Start']])
        g['MV_RetryLeft'][1]=14.2;vm.run('MV_Render')
        self.assertIn('READY IN 15s',text[g['MV_Title']])
        g['MV_View']=0;f.begin();f.answer(5,yes=2);vm.run('MV_Render')
        self.assertIn('READY IN 30s',text[g['MV_Title']])
        self.assertFalse(any(enabled[g['MV_Row'][p]] for p in range(10)))
        g['MV_RetryLeft'][0]=0.0

        x,y,w,h=pos[g['MV_RowMark'][1]]
        self.assertLess(x+w/2,.061);self.assertGreater(x,.04)
        f.players=set(range(10));g['MV_View']=0
        f.begin();f.local=5;vm.run('MV_Render')
        self.assertTrue(visible[g['MV_Yes']]);self.assertTrue(visible[g['MV_No']])
        self.assertTrue(visible[g['MV_Glow'][0]])
        f.answer(5);vm.run('MV_Render');self.assertFalse(visible[g['MV_Glow'][0]])
        g['WUI_TopShown']=lambda:False;g['MV_View']=0;vm.run('MV_Render')
        self.assertFalse(visible[g['MV_Button'][0]]);self.assertFalse(visible[g['MV_Button'][1]])
        self.assertFalse(visible[g['MV_Panel']]);self.assertEqual(-1,g['MV_View'])
        g['WUI_TopShown']=lambda:True
        g['WOS_FF_ENABLED']=False;g['MV_View']=1;vm.run('MV_Render')
        self.assertTrue(visible[g['MV_Button'][0]])
        self.assertFalse(visible[g['MV_Button'][1]])
        self.assertFalse(visible[g['MV_Glow'][1]])
        self.assertFalse(visible[g['MV_Panel']])
        self.assertEqual(-1,g['MV_View'])
        self.assertEqual(count,len(handles))

class DragGrid(unittest.TestCase):
    def test_grid_targets_cover_all_axes_and_do_not_wrap_or_leave_bounds(self):
        f=quickbuy.Fix8();f.setUp();vm=f.vm
        for dx,dy,expected in [(0,0,6),(.049,0,7),(-.049,0,5),(0,.065,11),(0,-.065,1),(.049,.065,12),(100,100,14),(-100,-100,0)]:
            self.assertEqual(expected,vm.run('QB_GridDragTarget',(6,15,5,dx,dy,.049,.065)))
    def test_vertical_release_commits_the_same_preview_once(self):
        f=quickbuy.Fix8();f.setUp();f.goals([1,2,6,1,2,6]);g=f.vm.g;g.update(QB_DragFrom=1,QB_DragVersion=g['QB_Version'][0],QB_DragX=.7,QB_DragY=.312,QB_Width=.245,QB_Columns=5,REC_DragFrom=-1,
            BlzGetMouseScreenPosX=lambda:.7,BlzGetMouseScreenPosY=lambda:.247,BlzPixelToFrameX=lambda x:x,BlzPixelToFrameY=lambda y:y,
            WUI_TopShown=lambda:True,QB_DragRender=lambda:None)
        g['Shop_Active'][0]=True
        f.vm.run('QB_UpdateDragTarget');dest=g['QB_DragTo'];self.assertGreater(dest,1)
        f.vm.run('QB_FinishDrag');self.assertTrue(f.messages[-1][1].endswith('1,'+str(dest)))
        count=len(f.messages);f.vm.run('QB_FinishDrag');self.assertEqual(count,len(f.messages))

if __name__=='__main__':unittest.main()


class WindowTransitions(unittest.TestCase):
    def peer(self, local):
        vm=ui.load_source('WOSUI.j')
        for name in ['Scoreboard.j','MusicPlayer.j','SaveLoad.j','WoS_Shop_Init.j']:
            extra=ui.load_source(name)
            vm.methods.update(extra.methods);vm.text+='\n'+extra.text
            for k,v in extra.g.items():vm.g.setdefault(k,v)
        from test_crocodile import JassState
        extra=JassState((ROOT/'triggers/Systems/ButtonPressed.j').read_text(encoding='utf-8-sig'))
        vm.methods.update(extra.methods);vm.text+='\n'+extra.text
        for name in vm.methods:vm.g[name]=lambda *a,n=name:vm.run(n,a)
        sender=[0];data=[''];visible={};calls=[];sent=[]
        def execute(t):calls.append((vm.g['WUI_WindowPlayer'],t['name']));t['action']()
        vm.g.update(WUI_WindowPlayer=None,GetLocalPlayer=lambda:local,GetTriggerPlayer=lambda:sender[0],
            Player=lambda p:p,GetPlayerId=lambda p:p,GetHandleId=lambda p:p,
            BlzGetTriggerSyncData=lambda:data[0],BlzSendSyncData=lambda *a:sent.append(a),
            BlzFrameSetVisible=lambda f,v:visible.update({f:v}),
            BlzFrameIsVisible=lambda f:visible.get(f,False),BlzFrameSetEnable=lambda *_:None,
            QB_CancelDrag=lambda:None,WOS_STATS_UpdateForPlayer=lambda *_:None,
            WOS_STATS_ParkSwap=lambda *_:None,WOS_STATS_SaveAndHideLegacyUI=lambda *_:None,
            WOS_STATS_RestoreLegacyUI=lambda *_:None,LMP_UpdateAll=lambda *_:None,
            LMP_StopTrackMusic=lambda *_:None,TriggerExecute=lambda *_:self.fail('no runtime callback dispatch'),
            CreateTrigger=lambda:self.fail('allocation while switching windows'),
            CreateTimer=lambda:self.fail('allocation while switching windows'),
            ExecuteFunc=lambda *_:self.fail('local function dispatch'),
            FRAME_ShopMAIN='shop',WOS_STATS_Main='stats',WOS_STATS_Inner='stats-inner',
            ss_HelpPanel='guide',lmpPanel='music',lmpSeek='seek',lmpSeekBlocker='seekblock',
            lmpVolumeSlider='volume',lmpOpenButton='music-open',lmpLinkButton='music-link',FRAME_StatsMain=None,
            WUI_CloseMenuDrop=lambda:None,Hero={0:'hero0',1:'hero1'},hs={},
            LoadInteger=lambda *_:0,SaveInteger=lambda *_:None,StringHash=lambda s:s,MyFlush=lambda *_:None,
            IsObserverSlot=lambda *_:False,END1=0,ShopUICreated=True,
            ReloadItemPage=lambda *_:None,ShopUpdateCatalogueNavigation=lambda *_:None,
            WOS_STATS_VIEWER_COUNT=24,CondArena=0,TestMode=False,
            WUI_GetHotkey=lambda *a:'F2',WUI_HOTKEY_STATS=1,BlzGetTriggerPlayerKey=lambda:'F2',
            BlzGetTriggerFrame=lambda:'music-open',WUI_ReleaseClickFocus=lambda:None,
            WUI_ResetClickedButtonFocus=lambda:None)
        for i,frame in [(0,'shop'),(1,'stats'),(4,'music'),(5,'seek'),(6,'seekblock'),(7,'volume'),(8,'music-open'),(9,'guide')]:
            vm.g['WUI_WindowPart'][i]=frame
        return vm,sender,data,visible,calls,sent

    def test_tab_f2_music_escape_match_on_two_clients_without_followup_state_packets(self):
        peers=[self.peer(0),self.peer(1)]
        events=[('WOS_ToggleShop',(0,)),('WOS_STATS_OnKey',()),('LMP_OnClick',()),
                ('WOS_ToggleShop',(1,)),('WUI_OnExclusiveCloseSync',()),('WOS_ToggleShop',(0,))]
        for n,(fn,args) in enumerate(events):
            for vm,sender,data,visible,calls,sent in peers:
                sender[0]=1 if n in (3,4) else 0;data[0]='-1'
                vm.g['lmpClickBusy'][sender[0]]=False
                vm.run(fn,args)
                self.assertIsNone(vm.g['WUI_WindowPlayer'])
                self.assertFalse(sent,'switching must not leave shared flags waiting for a later packet')
            for name in ['Shop_Active','WOS_STATS_IsOpen','lmpVisible','ss_HelpOpen','ss_HelpLeft']:
                self.assertEqual([peers[0][0].g[name][p] for p in range(2)],
                                 [peers[1][0].g[name][p] for p in range(2)],(n,name))
            self.assertEqual(peers[0][4],peers[1][4], 'same callback dispatch on both clients')
        self.assertTrue(peers[0][3]['shop']);self.assertFalse(peers[1][3]['shop'])

    def test_no_window_dispatch_is_under_a_local_guard(self):
        for name in ['WOS_Start/WOSUI.j','WOS_Start/Scoreboard.j','WOS_Start/MusicPlayer.j',
                     'WOS_Start/WoS_Shop_Init.j','Systems/ButtonPressed.j','Systems/EnterRegion.j']:
            text=(ROOT/'triggers'/name).read_text(encoding='utf-8-sig');stack=[]
            for line in text.splitlines():
                code=line.strip()
                if code.startswith('//'):continue
                if code.startswith(('if ','static if ')):stack.append('GetLocalPlayer' in code or any(stack))
                if 'call WUI_EnterExclusiveWindow(' in code:self.assertFalse(any(stack),(name,code))
                if code=='endif':stack.pop()
        text=(ROOT/'triggers/WOS_Start/WOSUI.j').read_text(encoding='utf-8-sig')
        self.assertNotIn('WUI_ExclusiveState',text);self.assertNotIn('WUI_RequestExclusiveClose',text)

    def test_drag_pointers_share_the_target_panel_layer_and_form_tabs_are_narrower(self):
        vm=ui.load_source('WoS_Shop_Init.j');parents={};levels={}
        # Execute the production allocation block, not just its coordinate helper.
        source=(ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8-sig')
        block=source.split('set QB_DragLight = QB_Decor',1)[1].split('set QB_DropLine =',1)[0]
        block=block[block.index('    set i = 0'):]
        from test_crocodile import JassState
        test=JassState('function AllocatePointers takes nothing returns nothing\nlocal integer i\n'+block+'endfunction\n')
        test.g.update(QB_Panel='qb92',FRAME_ShopItemList='catalogue',QB_DragArrow={},
            QB_Decor=lambda name,parent,texture:parents.setdefault(len(parents),(parent,texture)) or 0,
            BlzFrameSetTexture=lambda *_:None,BlzFrameSetEnable=lambda *_:None,
            BlzFrameSetVisible=lambda *_:None,BlzFrameSetLevel=lambda *_:None)
        test.run('AllocatePointers')
        self.assertEqual(['qb92']*4+['catalogue']*4,[p[0] for p in parents.values()])
        pick=(ROOT/'triggers/WOS_Start/WoS_Pick_Init.j').read_text(encoding='utf-8-sig')
        width=float(re.search(r'WUI_TextButton\("WOSHeroForm", FRAME_MAIN3, "", ([0-9.]+)',pick)[1])
        self.assertLess(width,.041);self.assertGreaterEqual(width,.028)



class PickerLocalCalls(unittest.TestCase):
    def test_preview_clear_select_and_form_click_never_dispatch_or_allocate(self):
        f=Preview();f.setUp();vm=f.vm
        def forbid(*a):self.fail('local preview dispatched/allocated: '+str(a))
        for name in ['ExecuteFunc','TriggerExecute','TriggerEvaluate','CreateTrigger','CreateTimer',
                     'BlzCreateFrameByType','BlzCreateFrame','BlzGetFrameByName','BlzGetOriginFrame',
                     'BlzFrameGetChild','BlzFrameGetParent','CreateUnit']:
            vm.g[name]=forbid
        vm.g.update(GetLocalPlayer=lambda:0,GetTriggerPlayer=lambda:0,WUI_ReleaseClickFocus=lambda:None)
        for hero in [vm.g['Erza_ID'],vm.g['Tsuna_ID'],vm.g['Takeshi_ID'],vm.g['Rimuru_ID']]:
            vm.run('WOS_PreviewSelect',(hero,))
            vm.g['BlzGetTriggerFrame']=lambda:vm.g['WOS_PreviewButton'][1]
            vm.run('WOS_PreviewClick')
            self.assertEqual(1,vm.g['WOS_PreviewForm'])
            vm.run('WOS_PreviewClear')
            self.assertEqual(0,vm.g['WOS_PreviewHero'])
            self.assertFalse(any(f.visible[vm.g['WOS_PreviewButton'][i]] for i in range(8)))

    def test_local_helpers_are_defined_before_their_first_call(self):
        for file,names in [('WoS_Pick_Init.j',['WOS_PreviewRender','WOS_PreviewSelect','WOS_PreviewClear']),
                           ('WOSUI.j',['WUI_RefreshSlotBadges'])]:
            text=(ROOT/'triggers/WOS_Start'/file).read_text(encoding='utf-8-sig')
            for name in names:
                self.assertLess(text.index('function '+name+' takes'),text.index('call '+name+'('),name)
                self.assertNotIn('ExecuteFunc("'+name+'")',text)
                self.assertNotIn('ExecuteFunc(SCOPE_PRIVATE + "'+name+'")',text)

    def test_form_buttons_fit_the_gap_with_equal_margins(self):
        text=(ROOT/'triggers/WOS_Start/WoS_Pick_Init.j').read_text(encoding='utf-8-sig')
        m=re.search(r'WUI_Place\(WOS_PreviewButton\[i\], ([0-9.]+), .*?, ([0-9.]+), 0.018\)',text)
        center,width=map(float,m.groups())
        # Portrait centre .613, ornate width .164; panel right edge .733.
        left=.613+.164/2;right=.613+.240/2
        self.assertAlmostEqual((left+right)/2,center)
        self.assertLess(width,.034)
        self.assertGreater(center-width/2-.002,left)
        self.assertLess(center+width/2+.002,right)

    def test_one_level_form_tooltip_registrations_match_objects(self):
        text=(ROOT/'triggers/WOS_Start/UniversalTooltips.j').read_text(encoding='utf-8-sig')
        fixture=Preview();fixture.setUp();ids=fixture.vm.g;objects=fixture.objects
        names=[f'Erza{form}{slot}_ID' for form in (5,6,7) for slot in 'QWERT']
        names += ['TsunaQ2_ID','TsunaW3_ID','TsunaE2_ID','TsunaR2_ID','TsunaT3_ID']
        names += ['TakeshiGQ_ID','TakeshiGW_ID','TakeshiGE_ID','TakeshiGR_ID','TakeshiGF_ID']
        for name in names:
            self.assertEqual(1,objects[ids[name]]['levels'],name)
            pattern=r'SpellData\.create(?:Simple|Utility|Alt)?\('+name+r', (?:1, )?(\d+),'
            # createAlt carries formId before maxLv, the others do not.
            line=next(l for l in text.splitlines() if 'SpellData.create' in l and '('+name+',' in l)
            args=line.split('('+name+',',1)[1].split(',')
            maxLv=int(args[1] if 'createAlt(' in line else args[0])
            self.assertEqual(1,maxLv,name)


class PickHover(unittest.TestCase):
    def test_category_and_form_hover_only_paint_cached_frames(self):
        for local in (0,1):
            vm=ui.load_source('WOSUI.j');textures=[];event=['enter']
            def forbid(*a):self.fail('hover dispatched/allocated: '+str(a))
            for name in ['ExecuteFunc','TriggerExecute','TriggerEvaluate','CreateTrigger','CreateTimer',
                         'BlzCreateFrameByType','BlzGetFrameByName','BlzGetOriginFrame','CreateUnit']:
                vm.g[name]=forbid
            vm.g.update(GetLocalPlayer=lambda:local,GetTriggerPlayer=lambda:0,
                BlzGetTriggerFrame=lambda:'category',GetHandleId=lambda f:f,
                BlzGetTriggerFrameEvent=lambda:event[0],FRAMEEVENT_MOUSE_ENTER='enter',
                WUI_FILL_HOVER='hover',WUI_FILL_NORMAL='normal',WUI_FILL_SELECTED='selected',
                WUI_ButtonStyle={('category',0):'cached-backdrop',('category',2):False},
                LoadFrameHandle=lambda t,k,c:t.get((k,c)),LoadBoolean=lambda t,k,c:t.get((k,c),False),
                SaveBoolean=lambda t,k,c,v:t.update({(k,c):v}),
                BlzFrameSetTexture=lambda *a:textures.append(a))
            vm.run('WUI_ButtonHover');event[0]='leave';vm.run('WUI_ButtonHover')
            self.assertEqual(2 if local==0 else 0,len(textures))
            self.assertTrue(all(t[0]=='cached-backdrop' for t in textures))
