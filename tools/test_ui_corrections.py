"""Production JASS with recorded natives; does not claim Warcraft input/render QA."""
from collections import defaultdict
from pathlib import Path
import json, math, re, unittest
import test_wos_ui as ui
from test_crocodile import JassState

ROOT=Path(__file__).resolve().parents[1]
def source(name):return (ROOT/'triggers'/name).read_text(encoding='utf-8-sig')

class EscapeAndGuide(unittest.TestCase):
    def test_first_boot_escape_closes_windows_without_visiting_hotkey_editor(self):
        vm=ui.load_source('WOSUI.j');calls=[];events=[];hooks=[]
        vm.g.update(WUI_AcceptKeyDown=lambda:True,WUI_OnReady=hooks.append,TimerStart=lambda *_:None,WUI_BootTimer='boot',
                    GetTriggerPlayer=lambda:0,GetLocalPlayer=lambda:0,
                    WUI_CloseMenuDrop=lambda:calls.append('menu'),
                    CreateTrigger=lambda:{},TriggerAddCondition=lambda t,f:t.update(condition=f),Condition=lambda f:f,TriggerAddAction=lambda t,f:t.update(action=f),
                    TriggerExecute=lambda t:t['action'](),BlzTriggerRegisterPlayerSyncEvent=lambda *_:None,
                    BlzTriggerRegisterPlayerKeyEvent=lambda *a:events.append(a),OSKEY_ESCAPE='ESC')
        # This used to leave SlotCapture at zero, permanently rejecting Esc.
        vm.run('WUI_Init')
        for pid in range(24):
            self.assertEqual(-1,vm.g['WUI_CaptureChannel'][pid])
            self.assertEqual(-1,vm.g['WUI_SlotCapture'][pid])
        for name in ['Shop_Active','WOS_STATS_IsOpen','lmpVisible','ss_HelpOpen']:vm.g[name][0]=True
        hooks[0]()
        self.assertEqual(24*16*2,len(events))
        self.assertEqual({False,True},{e[4] for e in events})
        self.assertEqual(set(range(16)),{e[3] for e in events})
        vm.g.update(WUI_WindowPlayer=None,BlzSendSyncData=lambda *a:calls.append(a),
                    BlzGetTriggerSyncData=lambda:'-1')
        vm.run('WUI_OnWindowEscape')
        self.assertEqual([('WUIWCLOSE','-1'),'menu'],calls)
        vm.g['WUI_WindowPart'][11]='vote';vm.g['MV_View']=1;paint=[]
        vm.g['BlzFrameSetVisible']=lambda f,v:paint.append((f,v))
        calls.clear();vm.run('WUI_OnExclusiveCloseSync')
        self.assertEqual(-1,vm.g['MV_View']);self.assertIn(('vote',False),paint)
        paint.clear();vm.g['GetLocalPlayer']=lambda:1;vm.g['MV_View']=0
        vm.run('WUI_OnExclusiveCloseSync');self.assertEqual(0,vm.g['MV_View'])
        self.assertNotIn(('vote',False),paint)
        vm.g['GetLocalPlayer']=lambda:0
        self.assertFalse(calls)
        for name in ['Shop_Active','WOS_STATS_IsOpen','lmpVisible','ss_HelpOpen']:self.assertFalse(vm.g[name][0])
        calls.clear();vm.g['WUI_CaptureChannel'][0]=2
        vm.run('WUI_OnWindowEscape');self.assertFalse(calls)

    def test_guide_arrows_follow_actual_controls_and_not_screen_guesses(self):
        vm=ui.load_source('SaveLoad.j');points=[];sizes=[];visible={}
        vm.g.update(WUI_GetHelpTarget=lambda i:f'control{i}',I2R=float,
                    BlzFrameSetPoint=lambda *a:points.append(a),
                    BlzFrameClearAllPoints=lambda *_:None,
                    BlzFrameSetSize=lambda *a:sizes.append(a),
                    BlzFrameSetVisible=lambda f,v:visible.update({f:v}))
        for p in ['TOPRIGHT','BOTTOMRIGHT','TOP','BOTTOM','BOTTOMLEFT','TOPLEFT']:
            vm.g['FRAMEPOINT_'+p]=p
        vm.run('SaveSystem_HelpAnchor')
        self.assertEqual(15,len(points));self.assertTrue(all(visible.values()))
        for i in range(5):self.assertEqual(2,len([p for p in points if p[2]==f'control{i}']))
        self.assertEqual('TOPRIGHT',points[0][1]);self.assertEqual('BOTTOMLEFT',points[6][1])
        self.assertEqual('TOPRIGHT',points[12][1]);self.assertEqual((.034,-.205),points[12][-2:])
        self.assertIn('WUI_RegisterHelpTarget(4, text)',source('WOS_Start/WOSUI.j'))
        self.assertIn('global match statistics and set custom music',source('WOS_Start/SaveLoad.j'))
        for i in range(5):
            arrow=vm.g['ss_HelpArrow'][i];card=vm.g['ss_HelpCard'][i]
            endpoints=[p for p in points if p[0]==arrow]
            self.assertEqual({'TOP','BOTTOM'},{p[1] for p in endpoints})
            self.assertEqual({card,f'control{i}'},{p[2] for p in endpoints})
        self.assertIn('WUI_RegisterHelpTarget(2, UNITSTAT_ModeButton)',source('WOS_Start/DefaultArmorChangeStable_Copy.j'))
        self.assertIn('WUI_RegisterHelpTarget(3, FRAME_AutoBuyToggle)',source('WOS_Start/WoS_Shop_Init.j'))

    def test_upper_guide_targets_are_visible_labels_not_icon_hit_boxes(self):
        vm=ui.load_source('WOSUI.j')
        vm.g.update(WUI_MenuLabel='menu-label',WUI_Menu='menu-button',WUI_StatsButton='stats-button')
        vm.run('WUI_RegisterHelpTarget',(1,'stats-label'))
        vm.run('WUI_RegisterHelpTarget',(4,'app-label'))
        self.assertEqual('menu-label',vm.run('WUI_GetHelpTarget',(0,)))
        self.assertEqual('stats-label',vm.run('WUI_GetHelpTarget',(1,)))
        self.assertEqual('app-label',vm.run('WUI_GetHelpTarget',(4,)))

    def test_save_tooltip_opens_down_and_every_requested_close_explains_escape(self):
        s=source('WOS_Start/WOSUI.j').split('function WUI_TooltipBelowSized takes')[1].split('endfunction')[0]
        self.assertIn('FRAMEPOINT_TOPRIGHT, owner, FRAMEPOINT_BOTTOMRIGHT, 0.00, -offset',s)
        self.assertIn('WUI_TooltipBelowSized(ss_SaveButton,',source('WOS_Start/SaveLoad.j'))
        for file in ['SaveLoad.j','WoS_Shop_Init.j','MusicPlayer.j','Scoreboard.j']:
            self.assertIn('Hotkey: ESC',source('WOS_Start/'+file))

class AutoBuy(unittest.TestCase):
    def setUp(self):
        self.vm=ui.load_source('WoS_Shop_Init.j');self.boots='I007';self.inv=set();self.bought=[];self.gold=0
        # Root recipe is hat -> boots -> token, like the actual Urahara recipe.
        self.recipes={10:[11,'I007',12],20:[10,13],30:[14,15]}
        self.cost={'I007':500,11:300,12:100,10:1200,13:100,14:100,15:100,20:1500,30:300}
        g=self.vm.g
        g.update(GetCraftComponentCount=lambda i:len(self.recipes.get(i,[])),
                 GetCraftComponent=lambda i,j:self.recipes[i][j],GetOwningPlayer=lambda _:0,
                 IsItemInInventory=lambda _,i:int(i in self.inv),GetGold=lambda _:self.gold,
                 GetItemValue=lambda i:self.cost[i],CheckItemsReduceCostCraft=lambda _,cost,i,consume:cost,
                 CheckSlotAvailable=lambda _:True,HasCraftComponents=lambda i:i in self.recipes,
                 AddGold=lambda _,n,b:setattr(self,'gold',self.gold-n),UnitAddItemById=self.add,
                 StartSoundForPlayerBJ=lambda *_:None,gg_snd_AlchemistTransmuteDeath1='sound')
    def add(self,unit,item):self.bought.append(item);self.inv.add(item)
    def test_first_purchase_boots_even_when_hat_is_first_in_recipe(self):
        self.gold=500;self.vm.run('BuyAutoLimited',(None,10,1))
        self.assertEqual(['I007'],self.bought)
    def test_insufficient_boot_gold_waits_instead_of_buying_cheaper_hat(self):
        self.gold=300;self.vm.run('BuyAuto',(None,10));self.assertFalse(self.bought)
        self.assertEqual(300,self.gold)
    def test_nested_boots_branch_is_prioritized_but_unrelated_recipes_keep_order(self):
        self.recipes[20]=[13,10];self.gold=500;self.vm.run('BuyAutoLimited',(None,20,1))
        self.assertEqual(['I007'],self.bought)
        self.assertEqual([14,15],[self.vm.run('AutoBuyComponent',(30,i)) for i in range(2)])
    def test_owned_boot_upgrade_satisfies_boot_priority_without_buying_second_boots(self):
        self.inv.add(10);self.recipes[20]=[13,10];self.gold=100
        self.vm.run('BuyAuto',(None,20));self.assertEqual([13],self.bought)

class TimersAndRounds(unittest.TestCase):
    def preview(self,hero,ability,**values):
        s=source('Heroes/'+hero+'.j')
        call=next(line.strip() for line in s.splitlines() if 'call WUI_HeroProgress(c, '+ability+',' in line)
        # Execute the actual display expression taken from the production loop.
        vm=JassState('function Preview takes nothing returns nothing\n'+call+'\nendfunction')
        out=[];vm.g.update(values,c='hero',I2R=float,WUI_HeroProgress=lambda *a:out.append(a))
        vm.g[ability]=ability;vm.run('Preview');return out[0]
    def test_patriot_follows_remaining_pulses_not_fifteen_second_watchdog(self):
        for pulses in [3,5,7]:
            initial=self.preview('Patriot','PatriotW_ID',rmax=15,r=0,r2=10,k2=pulses,k3=0,PatriotW_CastTime=.03)
            self.assertAlmostEqual(.03+(pulses-1)*.99,initial[3])
            last=self.preview('Patriot','PatriotW_ID',rmax=15,r=4,r2=.60,k2=pulses,k3=pulses-1,PatriotW_CastTime=.03)
            self.assertAlmostEqual(.39,last[3])
    def test_harribel_channel_matches_charge_gate(self):
        p=self.preview('Harribel','HarribelW_ID',r=1,HarribelEW_MaxCastDuration=3)
        self.assertAlmostEqual(2.12,p[3]);self.assertAlmostEqual(3.12,p[4])
        self.assertIn('if check == 1 and r4 > rmax then',source('Heroes/Harribel.j'))
    def test_akainu_display_matches_real_fist_count_and_interval(self):
        # Trace the requested .15 period; the dedicated hero test executes the loop.
        r=r2=0.;count=0;events=[]
        while count<30:
            r=round(r+.03,3)
            if r>1.8:
                r2+=.03
                if r2+.0001>=.15:r2-=.15;count+=1;events.append(r)
        p=self.preview('Akainu','AkainuT_ID',rmax=25,r=0,r2=0,check=0,AkainuT_CastTime=1.8,AkainuT_Fists=30,AkainuT_FistPeriod=.15)
        self.assertAlmostEqual(events[-1],p[3],delta=.031)
        self.assertAlmostEqual(6.3,p[4])
    def test_inori_uses_live_channel_field_once_from_shared_start(self):
        s=source('Heroes/Inori.j');self.assertIn('BlzGetAbilityRealLevelField(BlzGetUnitAbility(NewC, InoriW_ID), ABILITY_RLF_FOLLOW_THROUGH_TIME',s)
        p=self.preview('Inori','InoriW_ID',uiChannelDuration=7.5,r=2)
        self.assertEqual((5.5,7.5),p[3:5])
        obj=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))['A060']
        self.assertEqual({7.5},{v for k,v in obj.items() if k.startswith('follow_through_time')})
    def test_train_schedule_switches_to_thirty_seconds_during_sukuna(self):
        s=source('WOS_Start/WoS_Pick_Init.j');start=s.index('            if TestMode == false and ((TimeMove < Time_Sukuna')
        block=s[start:s.index('            set i = 0',s.index('            endif',start))]
        vm=JassState('function Tick takes nothing returns nothing\n'+block+'\nendfunction')
        events=[];vm.g.update(TestMode=False,Time_Sukuna=120,r_train=1,i=0,TrainStart=lambda:events.append(vm.g['TimeMove']))
        for tick in range(1,241):vm.g['TimeMove']=tick;vm.run('Tick')
        self.assertEqual([60,120,150,180,210,240],events)
        vm.g.update(TestMode=True,r_train=100,TimeMove=241);vm.run('Tick');self.assertEqual(6,len(events))
    def test_damage_game_info_matches_round_formulas(self):
        decor=source('Systems/DecorDestroy_and_Erza_Debuff.j');info=source('WOS_Start/WOSUI.j');train=source('Round_End/RoundEnd.j')
        for base,range_ in [(100,350),(100,400),(200,500)]:
            self.assertIn(f'GroupDmgEff(source, x, y, {range_}, {base}.00 + IMaxBJ(0, GetEnvironmentRoundNumber() - 1) * 25.00',decor)
            self.assertIn(f'WUI_InfoCurrentDamage({base}, 25)',info)
        for base in [200,400]:
            self.assertIn(f'{base}.00 + IMaxBJ(0, GetEnvironmentRoundNumber() - 1) * 50.00',train)
            self.assertIn(f'WUI_InfoCurrentDamage({base}, 50)',info)
        self.assertIn('WUI_InfoCurrentDamage(0, 25)',info)
    def test_game_info_snapshots_once_at_round_start_not_during_timer_ticks(self):
        vm=ui.load_source('WOSUI.j');calls=[]
        vm.g['GetEnvironmentRoundNumber']=lambda:max(1,vm.g['CurrentRound'])
        def refresh():
            calls.append(vm.g['CurrentRound'])
        vm.g.update(WUI_FeedText=defaultdict(lambda:None),WUI_InfoPanel='info',WUI_InfoOpen=True,WUI_InfoPage=2,WUI_InfoRoundSnapshot=1,CurrentRound=2,WUI_InfoShowPage=refresh)
        vm.run('WUI_FeedTick');self.assertFalse(calls)
        vm.run('WUI_GameInfoRoundStart');vm.run('WUI_GameInfoRoundStart');self.assertEqual([2],calls)
        self.assertEqual(2,vm.g['WUI_InfoRoundSnapshot'])
        vm.g['CurrentRound']=3;vm.run('WUI_FeedTick');self.assertEqual([2],calls)
        self.assertEqual(2,vm.g['WUI_InfoRoundSnapshot'])
        vm.run('WUI_GameInfoRoundStart');self.assertEqual([2,3],calls)
        vm.g.update(WUI_InfoOpen=False,CurrentRound=4);vm.run('WUI_GameInfoRoundStart')
        self.assertEqual([2,3],calls);self.assertEqual(4,vm.g['WUI_InfoRoundSnapshot'])
        s=source('WOS_Start/WoS_Pick_Init.j')
        self.assertEqual(1,s.count('call WUI_GameInfoRoundStart()'))
        self.assertIn('set CondArena = 1\n                call WUI_GameInfoRoundStart()',s)

    def test_current_damage_suffix_uses_cached_round_and_ends_each_flat_damage_entry(self):
        vm=ui.load_source('WOSUI.j');vm.g.update(I2S=str,CurrentRound=99)
        for round_ in [0,1,2,7]:
            vm.g['WUI_InfoRoundSnapshot']=round_
            for base,step in [(100,25),(100,25),(200,25),(0,25),(100,50),(200,50)]:
                expected=base+max(0,round_-1)*step
                self.assertEqual(f'|n|cffd5b876(Current damage: {expected})|r',vm.run('WUI_InfoCurrentDamage',(base,step)))
        s=source('WOS_Start/WOSUI.j')
        rows=[line for line in s.splitlines() if 'call WUI_InfoRow(' in line and 'WUI_InfoCurrentDamage(' in line]
        self.assertEqual(6,len(rows))
        self.assertTrue(all(re.search(r'\+ WUI_InfoCurrentDamage\(\d+, \d+\)\)$',line) for line in rows))
    def test_sukuna_five_random_locations_use_one_shared_draw(self):
        s=source('Round_End/RoundEnd.j')
        vm=JassState(s)
        vm.g.update(SukunaSpawnPrepared=False,SukunaSpawnX=0.,SukunaSpawnY=0.)
        calls=[];vm.g.update(k=0,x=0.,y=0.,a=0.,gg_rct_Arena='arena',GetRectCenterX=lambda _:100,GetRectCenterY=lambda _:200)
        for index,angle in enumerate([None,45,135,215,315]):
            vm.g['GetRandomInt']=lambda a,b,i=index:calls.append((a,b)) or i
            vm.run('SukunaResetSpawn');vm.run('SukunaPrepareSpawn');x,y=vm.g['SukunaSpawnX']-100,vm.g['SukunaSpawnY']-200
            self.assertAlmostEqual(0 if index==0 else 3000,math.hypot(x,y))
            if index:self.assertAlmostEqual(angle,math.degrees(math.atan2(y,x))%360)
        self.assertEqual([(0,4)]*5,calls)

class Resources(unittest.TestCase):
    def test_docking_preserves_long_meter_name_geometry(self):
        vm=ui.load_source('WOSUI.j');points=[]
        vm.g.update(WUI_Pin=lambda *a:points.append(a),GetHandleId=lambda f:f,
                    LoadReal=lambda table,key,child:table.get((key,child),0),
                    LoadFrameHandle=lambda table,key,child:table.get((key,child)),
                    HaveSavedHandle=lambda table,key,child:(key,child) in table,
                    HaveSavedReal=lambda table,key,child:(key,child) in table)
        for k in range(1,6):vm.g['WUI_MeterEdges']['panel',k]=f'part{k}'
        vm.g['WUI_MeterEdges']['panel',6]=.40
        self.assertTrue(vm.run('WUI_RepinMeter',('panel',)))
        caption=next(p for p in points if p[0]=='part4')
        self.assertEqual((.012/.4,.006/.4,.104/.4,.011/.4),caption[2:])
    def test_cast_and_guide_assets_are_project_owned_and_skin_uses_new_cursor(self):
        from install_wos_ui_assets import ASSET_NAMES,SKIN_VALUES
        self.assertEqual(r'UI\WOS\cast-range-red.tga',SKIN_VALUES['PlacementCursor'])
        for asset in ['cast-range-red','help-arrow-up','help-arrow-down','wos-app-link']:
            self.assertIn(asset,ASSET_NAMES);self.assertTrue((ROOT/f'assets/UI/WOS/{asset}.tga').is_file())
    def test_all_new_meter_titles_are_human_object_names(self):
        for p in (ROOT/'triggers/Heroes').rglob('*.j'):
            for title in re.findall(r'WUI_Hero(?:Progress|Duration)\([^,]+,[^,]+,\s*"([^"]+)"',p.read_text(encoding='utf-8-sig')):
                self.assertNotRegex(title,r'^(Form \d|[QWERTFG]\d?: |EW: |Passive: |.* form [QWERTFG]:)')
        abilities=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
        self.assertEqual('Uriel Protection',abilities['A0AB']['tooltip level 1'])

class EnvironmentRounds(unittest.TestCase):
    def test_actual_damage_and_info_use_same_round_after_training_restarts(self):
        header=source('Map_Header.j')
        decor=source('Systems/DecorDestroy_and_Erza_Debuff.j')
        calls=[s.strip() for s in decor.splitlines() if 'call GroupDmgEff(source,' in s and 'GetEnvironmentRoundNumber()' in s]
        self.assertEqual(4,len(calls))
        probe='\nfunction Probe takes nothing returns nothing\n'+'\n'.join(calls)+'\nendfunction'
        vm=JassState(header+probe);actual=[]
        vm.g.update(source='unit',x=0.,y=0.,GroupDmgEff=lambda *a:actual.append(a[4]))
        info=ui.load_source('WOSUI.j')
        info.g.update(WUI_InfoPanel=None,GetEnvironmentRoundNumber=lambda:vm.run('GetEnvironmentRoundNumber'),I2S=str)
        for training,technical_round,expected in [
            (False,1,[100,100,200,0]),(False,2,[125,125,225,25]),(False,3,[150,150,250,50]),
            (True,1,[100,100,200,0]),(True,3,[100,100,200,0]),(True,20,[100,100,200,0])]:
            vm.g.update(TestMode=training,CurrentRound=technical_round);actual.clear();vm.run('Probe')
            self.assertEqual(expected,actual,(training,technical_round))
            info.run('WUI_GameInfoRoundStart')
            for (base,step),damage in zip([(100,25),(100,25),(200,25),(0,25)],expected):
                self.assertIn(f'(Current damage: {damage})',info.run('WUI_InfoCurrentDamage',(base,step)))

    def test_train_uses_same_round_rule_and_existing_bases(self):
        train=source('Round_End/RoundEnd.j');header=source('Map_Header.j')
        assignments=[s.strip() for s in train.splitlines() if 'set dmg' in s and 'GetEnvironmentRoundNumber()' in s]
        self.assertEqual(2,len(assignments))
        vm=JassState(header+'\nfunction Probe takes nothing returns nothing\n'+'\n'.join(assignments)+'\nendfunction')
        vm.g.update(dmg=0.,dmg2=0.)
        for training,round_,expected in [(False,1,(200,400)),(False,2,(250,450)),(True,3,(200,400))]:
            vm.g.update(TestMode=training,CurrentRound=round_);vm.run('Probe')
            self.assertEqual(expected,(vm.g['dmg'],vm.g['dmg2']))

if __name__=='__main__':unittest.main()
