"""Run the production numeric collector and UI selection code; not an engine test."""
from collections import defaultdict
from pathlib import Path
import re
import unittest

from test_crocodile import JassState

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT/'triggers/WOS_Start/DamageStats.j'


class DamageStats(unittest.TestCase):
    def setUp(self):
        text=SOURCE.read_text(encoding='utf-8-sig')
        # JASS integer division truncates; Python's evaluator otherwise makes floats.
        for expr in ['count/2','slot/DS_CELLS','j/DS_LINE','r/10','i/4','(sourceCount-1)/10','(sourceCount+9)/10','rounded/10']:
            left,right=expr.rsplit('/',1);text=text.replace(expr,f'JDiv({left},{right})')
        # JASS rawcodes are integers; the small interpreter represents four-byte
        # literals as strings. Negative source tests must keep that distinction.
        text=text.replace('sourceId <= -1000000','NegativeAtMost(sourceId,-1000000)')
        text=text.replace('sourceId <= -101','NegativeAtMost(sourceId,-101)')
        self.vm = JassState(text)
        # Hits are buffered until the synced 5 s fold; tests read the buckets right away.
        run=self.vm.run
        def run_and_fold(name,args=(),*rest):
            result=run(name,args,*rest)
            if name.startswith('DamageStatsRecord'):run('DamageStatsFlush',())
            return result
        self.vm.run=run_and_fold
        g = self.vm.g
        for name in self.vm.methods:
            g[name] = lambda *a,n=name:self.vm.run(n,a)
        for name in ['DS_Count','DS_Total','DS_Order','DS_Recent','DS_SourceOrder','DS_RowPid','DS_SlotSource','DS_LastHero','DS_LastActive','DS_RowSource','DS_RowPortrait','DS_RowLines','DS_TabMode','DS_Phys','DS_Mag',
                     'DS_PendSrc','DS_PendCount','DS_PendTotal','DS_PendMag','DS_PendPhys','DS_PendList','DS_SortValue','DS_SlotColor']:
            g[name] = defaultdict(int)
        g['DS_PlayerTexture']=defaultdict(lambda:'texture')
        for name in ['DS_Row','DS_Label','DS_Value','DS_Icon','DS_Art','DS_Number','DS_Tab','DS_Portrait','DS_Fill','DS_BarBack','DS_SourceRowIcon','DS_SourceRowArt','DS_SubLabel','DS_DirTab','DS_Sensor','DS_RowSensor','DS_RowFillTex','DS_RowBackTex']:
            g[name] = defaultdict(lambda:'frame')
        def flush(t,p):
            for key in list(t):
                if key[1] == p:del t[key]
        g.update(NegativeAtMost=lambda n,limit:isinstance(n,(int,float)) and n<=limit,DS_Origins={},DS_Actors={},DS_TakenKeys={},DS_ActorCount=0,DS_OriginCount=0,DS_ScreenRight=-1.0,WUI_ScreenRight=lambda:.933333,WUI_InfoSourceIcon=lambda s:"",
                 DS_Keys={},DS_Data={},DS_Pend={},DS_PendDirty=0,DS_PEND_CAP=400,DS_FlushTicks=10,DS_Sequence=0,DS_Version=0,DAMAGE_STATS_ENABLED=True,DamageStatsActive=True,
                 DS_Direction=0,DS_TabPage=-1,DS_TabDirection=-1,DS_HoverDetail=False,DS_Minimized=False,
                 DS_CELLS=12,DS_MAX_SOURCES=12,GearDamageVariants={},DS_PickHidden=False,DS_SmallBeforePick=False,DS_LINE=12,DS_PITCH=.0254,DS_SMALL=8,DS_SMALL_PITCH=.020,DamageStatsHitKind=0,DS_SourceKind={},DS_GameTip=defaultdict(lambda:None),DS_GameTipKeys='',
                 WUI_HOTKEY_CLEAR=3,WUI_HOTKEY_LOAD=4,WUI_GetHotkeyName=lambda c,p:'F3' if c==3 else 'F4',DS_SmallPitch=.028,DS_SmallGap=.0008,DS_SmallHeight=-1.,DS_LargeHeight=-1.,DS_Page=0,DS_Selected=-1,DS_SourcePage=0,DS_PlayerPage=0,DS_PLAYERS_PER_PAGE=5,DS_SOURCES_PER_PAGE=9,DS_LastVersion=-1,
                 DS_LastRoster=-1,DS_Ready=True,DS_HoverSlot=-1,DS_Small='small',DS_Large='large',
                 DS_WasSmall=False,DS_WasLarge=False,DS_DamageTicks=0,WUI_TopShown=lambda:True,
                 DS_Toggle='toggle',DS_Tooltip='tooltip',DS_TooltipText='tiptext',DS_Footer='footer',DS_Heading='heading',
                 DS_HeadingDamage='heading-damage',DS_HeadingRecent='heading-recent',DS_Details='details',
                 DS_Back='back',DS_Previous='prev',DS_Next='next',
                 HaveSavedString=lambda t,p,c:('s',p,c) in t,HaveSavedInteger=lambda t,p,c:('i',p,c) in t,
                 LoadStr=lambda t,p,c:t.get(('s',p,c),''),
                 SaveStr=lambda t,p,c,v:t.update({('s',p,c):v}),
                 HaveSavedReal=lambda t,p,c:('r',p,c) in t,
                 LoadReal=lambda t,p,c:t.get(('r',p,c),0.),
                 SaveReal=lambda t,p,c,v:t.update({('r',p,c):v}),
                 LoadInteger=lambda t,p,c:t.get(('i',p,c),0),
                 SaveInteger=lambda t,p,c,v:t.update({('i',p,c):v}),
                 FlushChildHashtable=flush,Player=lambda p:p,GetPlayerId=lambda p:p,
                 GetPlayerSlotState=lambda p:'playing' if p in (0,2,5) else 'empty',
                 PLAYER_SLOT_STATE_PLAYING='playing',GetLocalPlayer=lambda:0,JDiv=lambda a,b:int(a/b))
        self.visible={};self.texts={};self.heights=[]
        g.update(BlzFrameSetVisible=lambda f,v:self.visible.update({f:v}),
                 BlzFrameIsVisible=lambda f:self.visible.get(f,False),
                 BlzFrameSetText=lambda f,t:self.texts.update({f:t}),
                 BlzFrameSetTexture=lambda *_:None,
                 BlzFrameSetSize=lambda *a:self.heights.append(a),BlzFrameSetAbsPoint=lambda *_:None,
                 BlzFrameSetScale=lambda *_:None,
                 BlzFrameClearAllPoints=lambda *_:None,BlzFrameSetPoint=lambda *_:None,BlzFrameSetFont=lambda *_:None,
                 WUI_SetFillWidth=lambda *_:None,
                 FRAMEPOINT_LEFT='left',FRAMEPOINT_RIGHT='right',FRAMEPOINT_TOP='top',FRAMEPOINT_BOTTOM='bottom',
                 FRAMEPOINT_TOPLEFT='top-left',FRAMEPOINT_TOPRIGHT='top-right',
                 FRAMEPOINT_BOTTOMLEFT='bottom-left',FRAMEPOINT_BOTTOMRIGHT='bottom-right',
                 WUI_ColumnHeight=lambda *a:self.heights.append(a),
                 WUI_SetValue=lambda *_:None,
                 WUI_SetButtonCaption=lambda *_:None,WUI_SetButtonSelected=lambda *_:None,
                 GetPlayerColorString=lambda p:f'<color{p}>',
                 GetPlayerName=lambda p:f'Player {p}',
                 GetUnitName=lambda u:'Hero',Hero=defaultdict(lambda:None),
                 GetUnitTypeId=lambda u:0,FormatK=lambda n:str(n),
                 GetObjectName=lambda n:f'Source {n}',BlzGetAbilityIcon=lambda n:f'Icon {n}',
                 BlzGetAbilityTooltip=lambda n,l:'Burning Finger',
                 R2SW=lambda v,w,d:f'{v:.{d}f}',I2S=str,I2R=float,
                 BlzFrameSetTextColor=lambda *_:None,BlzConvertColor=lambda a,r,g,b:(a,r,g,b),
                 StringLength=len,SubString=lambda s,a,b:s[a:b])

    def runj(self,name,*args):return self.vm.run(name,args)
    def hit(self,pid=0,source=100000,amount=10.):self.runj('DamageStatsRecord',pid,source,amount)
    def amount(self,page=0,pid=0,source=100000):return self.vm.g['LoadReal'](self.vm.g['DS_Data'],page*10+pid,source)

    def test_round_and_game_accumulate_same_final_value_and_session_is_not_recorded(self):
        self.hit(amount=12.75);self.hit(source=100001,amount=30.25)
        for page in range(3):self.assertEqual(43.,self.runj('DamageStatsTotal',0,page))
        self.assertEqual(2,self.vm.g['DS_Count'][0])

    def test_f3_resets_own_game_counter_f4_restores_real_totals_round_untouched(self):
        self.hit();self.runj('DamageStatsRecordTaken',0,100001,5.);self.hit(pid=2,amount=7.)
        self.runj('DamageStatsClear',0)
        self.assertEqual(0.,self.runj('DamageStatsTotal',0,1));self.assertEqual(0.,self.runj('DamageStatsTotal',0,5))
        self.assertEqual(10.,self.amount(0));self.assertEqual(7.,self.runj('DamageStatsTotal',2,1))
        self.assertEqual(1,self.vm.g['DS_Page'])
        self.hit(amount=3.);self.assertEqual(3.,self.runj('DamageStatsTotal',0,1))
        self.runj('DamageStatsLoad',0)
        self.assertEqual(13.,self.runj('DamageStatsTotal',0,1));self.assertEqual(5.,self.runj('DamageStatsTotal',0,5))
        self.assertEqual(13.,self.amount(1))

    def test_bar_kind_totals_follow_hit_kind(self):
        self.vm.g['DamageStatsHitKind']=1;self.hit(amount=30.)
        self.vm.g['DamageStatsHitKind']=2;self.hit(source=100001,amount=10.)
        self.assertEqual(30.,self.vm.g['DS_Mag'][10]);self.assertEqual(10.,self.vm.g['DS_Phys'][10])

    def test_round_rollover_snapshots_and_clears_only_round(self):
        self.hit();self.runj('DamageStatsNextRound');self.hit(amount=4.)
        self.assertEqual(4.,self.amount(0));self.assertEqual(14.,self.amount(1))
        self.assertEqual(10.,self.amount(3))
        self.runj('DamageStatsNextRound');self.assertEqual(4.,self.amount(3))

    def test_invalid_players_nonpositive_hits_and_disabled_feature_do_not_write(self):
        for pid in [-1,10,23]:self.hit(pid=pid)
        for dmg in [0.,-1.]:self.hit(amount=dmg)
        self.vm.g['DamageStatsActive']=False;self.hit()
        self.assertFalse(self.vm.g['DS_Data']);self.assertEqual(0,self.vm.g['DS_Version'])

    def test_taken_keeps_two_hero_attacks_and_spell_owners_distinct(self):
        g=self.vm.g;g.update(GetOwningPlayer=lambda u:u[0],GetUnitTypeId=lambda u:u[1])
        a=(0,10000000);b=(2,10000001)
        for source,owner,amount in [(a,0,110.),(b,2,50.),(a,0,7.)]:
            self.runj('DamageStatsRecordHitFrom',source,owner,5,-1,amount,0.)
        ka=self.runj('DamageStatsTakenSource',a,-1);kb=self.runj('DamageStatsTakenSource',b,-1)
        self.assertNotEqual(ka,kb);self.assertEqual(117.,self.amount(4,5,ka));self.assertEqual(50.,self.amount(4,5,kb))
        self.assertEqual('Icon 10000000',self.runj('DS_SourceIcon',ka))
        self.assertEqual('UI\\WOS\\icon-attack.tga',self.runj('DS_SourceIcon',-1))
        self.assertEqual(2,g['DS_Count'][45]);self.assertEqual(117.,self.amount(0,0,-1))
        self.runj('DamageStatsNextRound');self.assertEqual(117.,self.amount(7,5,ka))
        # Tooltips read the saved owner/type; they do not inspect a removed unit.
        g.update(DS_Direction=1,DS_HoverSlot=0,DS_Page=1);g['DS_RowPid'][0]=5;g['DS_SlotSource'][0]=kb
        self.runj('DS_UpdateTooltip');self.assertIn('Player 2',self.texts['tiptext']);self.assertIn('Source 10000001',self.texts['tiptext'])

    def test_taken_numeric_identity_is_reused_without_hit_time_strings_or_handles(self):
        g=self.vm.g;g.update(GetOwningPlayer=lambda u:u[0],GetUnitTypeId=lambda u:u[1])
        for name in ['I2S','R2SW','GetObjectName','BlzGetAbilityIcon','CreateTimer','CreateTrigger','InitHashtable','BlzCreateFrameByType']:
            g[name]=lambda *_,n=name:self.fail(n)
        for _ in range(100):self.runj('DamageStatsRecordHitFrom',(2,10000000),2,0,100000,50.9,.2)
        self.assertEqual(1,g['DS_ActorCount']);self.assertEqual(2,g['DS_OriginCount'])
        self.assertEqual(5000.,self.runj('DamageStatsTotal',0,4))
        g['DamageStatsActive']=False
        self.runj('DamageStatsRecordHitFrom',(5,20000000),5,0,200000,50.,0.)
        self.assertEqual(2,g['DS_OriginCount'])

    def test_environment_and_element_sources_have_separate_english_labels(self):
        for source,label in [(-10,'Ground fire'),(-11,'Barrel explosion'),(-12,'Train impact'),(-13,'Train explosion'),(-14,'Sukuna: Malevolent Shrine'),(-15,'Car explosion'),(-16,'Vending machine'),(-17,'Fire hydrant'),(-101,'Fire debuff'),(-102,'Water debuff'),(-104,'Vaporize'),(-105,'Overload')]:
            self.assertEqual(label,self.runj('DS_SourceName',source))
        g=self.vm.g;g.update(GetOwningPlayer=lambda u:u[0],GetUnitTypeId=lambda u:u[1],IsUnitType=lambda u,t:True,IsUnitIllusion=lambda u:False,UNIT_TYPE_HERO='hero')
        self.runj('DamageStatsRecordDirect',(24,10000001),(0,10000000),-14,250.)
        key=self.runj('DamageStatsTakenSource',(24,10000001),-14)
        self.assertEqual(250.,self.amount(4,0,key));self.assertEqual(0.,self.amount(0,0,-14))

    def test_environment_icons_share_the_game_info_catalogue(self):
        text=(ROOT/'triggers/WOS_Start/WOSUI.j').read_text(encoding='utf-8-sig')
        body=re.search(r'function WUI_InfoSourceIcon takes.*?endfunction',text,re.S)[0]
        helper=JassState(body)
        self.vm.g['WUI_InfoSourceIcon']=lambda s:helper.run('WUI_InfoSourceIcon',(s,))
        for source in [-10,-11,-12,-13,-14,-15,-16,-17,-101,-102,-103,-104,-105,-106,-107,-108]:
            icon=self.runj('DS_SourceIcon',source)
            self.assertEqual(helper.run('WUI_InfoSourceIcon',(source,)),icon)
            self.assertIn('CommandButtons',icon)
        for page in ['WUI_InfoSourceIcon(-15)','WUI_InfoSourceIcon(-105)']:
            self.assertIn(page,text.split('private function WUI_InfoShowPage',1)[1])

    def test_saber_g_starts_once_for_main_and_test_heroes_and_rearms_after_cleanup(self):
        from types import SimpleNamespace
        text=(ROOT/'triggers/Heroes/AlterSaber.j').read_text(encoding='utf-8-sig')
        body=re.search(r'function AlterSaberW_Start takes unit c.*?endfunction',text,re.S)[0]
        vm=JassState(body);data={};starts=[]
        vm.g.update(hs=data,AlterSaber_ID=100,GetUnitTypeId=lambda u:u[1],IsUnitIllusion=lambda u:False,
            GetHandleId=lambda u:u[0],StringHash=lambda s:s,LoadInteger=lambda h,p,k:h.get((p,k),0),
            SaveInteger=lambda h,p,k,v:h.update({(p,k):v}),AlterSaberW_KS=SimpleNamespace(AlterSaberW_Start=starts.append))
        for owner in [0,6,1]:
            hero=(owner+1000,100)
            for _ in range(20):vm.run('AlterSaberW_Start',(hero,))
            self.assertEqual(1,starts.count(hero))
        loop=text.split('private struct AlterSaberW_KS',1)[1].split('endstruct',1)[0]
        self.assertLess(loop.index('SH_SABER_G_ACTIVE,0'),loop.index('set c = null'))
        levels=(ROOT/'triggers/Systems/LvlUpCheck.j').read_text(encoding='utf-8-sig')
        branch=levels.split('if AlterSaber_ID == id then',1)[1].split('if Barragan_ID',1)[0]
        self.assertIn('call AlterSaberW_Start(c)',branch)
        data[(1006,'saber g active')]=0;vm.run('AlterSaberW_Start',((1006,100),))
        self.assertEqual(2,starts.count((1006,100)))

    def test_saber_g_extra_autoattack_is_separate_magic_and_consumes_charge_once(self):
        text=(ROOT/'triggers/Heroes/AlterSaber.j').read_text(encoding='utf-8-sig')
        body=re.search(r'function AlterSaberW_PasTrigger takes.*?endfunction',text,re.S)[0]
        for owner in [0,6]:
            for tier in [1,2,3]:
                with self.subTest(owner=owner,tier=tier):
                    vm=JassState(body);data={(owner,'saber w'):1};hits=[];tag=[0]
                    vm.g.update(hs=data,GetHandleId=lambda u:u,GetUnitX=lambda u:0.,GetUnitY=lambda u:0.,
                        StringHash=lambda s:s,LoadInteger=lambda h,p,k:h.get((p,k),0),SaveInteger=lambda h,p,k,v:h.update({(p,k):v}),
                        GAngle=lambda *a:0.,GetHeroAgi=lambda *a:100.,GetLevelPas3Check=lambda u:tier,
                        AlterSaberG_DamageAgiBase=1.,AlterSaberG_DamageAgiStep=1.,AlterSaberG_Damage2StaticBase=150.,AlterSaberG_Damage2StaticStep=0.,
                        AlterSaberG_CD_Base=18.,AlterSaberG_CD_Step=4.,AlterSaberG_ID='A02F',
                        bj_RADTODEG=1.,EffectSpawn=lambda *a:None,EffectSpawnColor=lambda *a:None,
                        EUTU2_3=lambda *a:None,DestroyEffect=lambda *a:None,MakeSound=lambda *a:None,
                        DamageSource=lambda s:tag.__setitem__(0,s),NextDmg=lambda *a:hits.append((tag[0],a)),
                        PassiveCD_Start=lambda *a:None,MyFlush=lambda *a:None)
                    vm.run('AlterSaberW_PasTrigger',(owner,99));vm.run('AlterSaberW_PasTrigger',(owner,99))
                    self.assertEqual(1,len(hits));self.assertEqual('A02F',hits[0][0])
                    self.assertEqual((owner,99,100.*tier+150.,0,.06),hits[0][1])

    def test_no_per_hit_strings_or_handle_allocation(self):
        for n in ['GetObjectName','BlzGetAbilityIcon','I2S','R2SW','FormatK','CreateTimer','InitHashtable','BlzCreateFrameByType']:
            self.vm.g[n]=lambda *_,n=n:self.fail(n)
        for _ in range(200):self.hit(amount=.125)
        self.assertEqual(1,self.vm.g['DS_Count'][0]);self.assertEqual(25.,self.amount())

    def test_recent_ten_are_distinct_and_ordered_by_latest_hit(self):
        for source in range(100000,100015):self.hit(source=source)
        self.hit(source=100003);self.assertEqual(10,self.runj('DS_SelectRecent',0,10))
        # Equal amounts: the bucket keeps its first 12 sources (DS_MAX_SOURCES), later ones are dropped.
        self.assertEqual([100003]+list(range(100011,100003,-1))+[100002],[self.vm.g['DS_Recent'][i] for i in range(10)])
        self.assertEqual(12,self.runj('DS_SelectRecent',0,24));self.assertEqual(0,self.vm.g['DS_Recent'][12])
        self.assertEqual(12,self.vm.g['DS_Count'][0])

    def test_player_rank_excludes_empty_slots_and_breaks_ties_by_slot(self):
        self.hit(pid=2,amount=200);self.hit(pid=0,amount=100);self.hit(pid=1,amount=999)
        self.assertEqual(3,self.runj('DS_RankPlayers'))
        self.assertEqual([2,0,5],[self.vm.g['DS_Order'][i] for i in range(3)])
        self.hit(pid=5,amount=200);self.runj('DS_RankPlayers')
        self.assertEqual([2,5,0],[self.vm.g['DS_Order'][i] for i in range(3)])

    def test_breakdown_sorts_all_sources_by_damage_and_omits_zero(self):
        self.hit(source=100001,amount=5);self.hit(source=100002,amount=30)
        self.assertEqual(2,self.runj('DS_SortSources',0))
        self.assertEqual([100002,100001],[self.vm.g['DS_SourceOrder'][i] for i in range(2)])

    def test_hidden_panels_do_no_ranking_formatting_or_layout(self):
        self.hit()
        self.vm.g['DS_RankPlayers']=lambda:self.fail('ranked while hidden')
        self.runj('DS_Tick');self.assertFalse(self.texts);self.assertFalse(self.heights)

    def test_empty_round_hides_previously_rendered_source_icons(self):
        self.hit();self.runj('DS_RankPlayers')
        self.runj('DS_RenderView',0,3);self.assertEqual(100000,self.vm.g['DS_SlotSource'][0])
        self.runj('DamageStatsNextRound');self.runj('DS_RenderView',0,3)
        self.assertEqual(0,self.vm.g['DS_SlotSource'][0])

    def test_minimized_compact_view_never_selects_or_formats_sources(self):
        self.hit();self.runj('DS_RankPlayers');self.vm.g['DS_Minimized']=True
        self.vm.g['DS_SelectRecent']=lambda *_:self.fail('sources selected while minimized')
        self.vm.g['DS_SourceIcon']=lambda *_:self.fail('source icon while minimized')
        self.runj('DS_RenderView',0,3);self.assertEqual(0,self.vm.g['DS_SlotSource'][0])

    def test_details_show_up_to_12_biggest_sources_on_one_line(self):
        for source in range(100000,100030):self.hit(source=source,amount=float(source-99999))
        self.runj('DS_RankPlayers');self.runj('DS_RenderView',1,3)
        cells=[self.vm.g['DS_SlotSource'][120+j] for j in range(12)]
        self.assertEqual(list(range(100029,100017,-1)),cells);self.assertEqual(1,self.vm.g['DS_RowLines'][10])
        self.runj('DamageStatsNextRound');self.hit(source=100001);self.runj('DS_RenderView',1,3)
        self.assertEqual(1,self.vm.g['DS_RowLines'][10]);self.assertEqual(0,self.vm.g['DS_SlotSource'][121])

    def test_rounded_short_labels_preserve_real_totals(self):
        cases={0.0:'0',.25:'<1',176.6:'177',1234.0:'1.2k',1255.0:'1.3k',
               999.6:'1.0k',15001.0:'15k',15600.0:'16k',1255000.0:'1.3m',9950.0:'10k',9999.4:'10k',10000000.0:'10m',1000000000.0:'1.0b'}
        for amount,label in cases.items():
            self.assertEqual(label,self.runj('DS_AmountLabel',amount))
        self.hit(amount=176.6);self.assertEqual(176.6,self.amount())

    def test_ability_art_uses_fixed_object_catalogue_including_vorpal_strike(self):
        import json
        from audit_damage_sources import ability_catalogue,sources
        code=re.sub(r"'([A-Za-z0-9]{4})'",lambda m:str(int.from_bytes(m[1].encode(),'big')),SOURCE.read_text(encoding='utf-8-sig'))
        vm=JassState(code);vm.g.update(self.vm.g)
        vm.run('DS_BuildIconCatalogue')
        abilities=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
        catalogue=ability_catalogue(sources())
        for raw in re.findall(r"DS_Keys,'(....)'",catalogue):
            self.assertEqual(abilities[raw]['icon'],vm.run('DS_SourceIcon',(int.from_bytes(raw.encode(),'big'),)))
        self.assertEqual('ReplaceableTextures\\CommandButtons\\BTNHero_Kirito_Q.blp',vm.run('DS_SourceIcon',(int.from_bytes(b'A0D3','big'),)))

    def test_dealt_and_taken_split_quincy_once_without_inflating_hit(self):
        self.runj('DamageStatsRecordHit',0,2,100000,140.9,40./140.)
        for page in [0,1]:
            self.assertAlmostEqual(100.,self.amount(page,0,100000))
            self.assertAlmostEqual(40.,self.amount(page,0,'I023'))
            self.assertEqual(140.,self.runj('DamageStatsTotal',0,page))
        for page in [4,5]:
            self.assertAlmostEqual(100.,self.amount(page,2,100000))
            self.assertAlmostEqual(40.,self.amount(page,2,'I023'))
            self.assertEqual(140.,self.runj('DamageStatsTotal',2,page))
        self.assertEqual(0.,self.runj('DamageStatsTotal',2,0))
        self.assertEqual(0.,self.runj('DamageStatsTotal',0,4))

    def test_f2_integer_precision_avoids_premature_7_1k(self):
        for amount in [335.99]*21+[3.99]:self.runj('DamageStatsRecordHit',0,2,100000,amount,0.)
        self.assertEqual(7038.,self.runj('DamageStatsTotal',0,0))
        for amount,label in [(7038.,'7.0k'),(7049.,'7.0k'),(7051.,'7.1k'),(7501.,'7.5k')]:
            self.assertEqual(label,self.runj('DS_AmountLabel',amount))

    def test_neutral_attacker_still_records_taken_and_zero_final_hit_records_nothing(self):
        self.runj('DamageStatsRecordHit',12,2,100000,75.9,0.)
        self.assertEqual(75.,self.runj('DamageStatsTotal',2,4))
        self.runj('DamageStatsRecordHit',0,2,100001,0.,.25)
        self.runj('DamageStatsRecordHit',0,2,100001,.75,.25)
        self.assertEqual(0.,self.runj('DamageStatsTotal',0,0))
        self.assertEqual(75.,self.runj('DamageStatsTotal',2,4))

    def test_post_mitigation_item_share_is_proportional_and_local_to_each_hit(self):
        self.runj('DamageStatsRecordHit',0,2,100000,20.,.25)
        self.runj('DamageStatsRecordHit',0,2,100001,70.,0.)
        self.assertEqual(5.,self.amount(source='I023'))
        self.assertEqual(15.,self.amount(source=100000))
        self.assertEqual(70.,self.amount(source=100001))
        self.assertEqual(90.,self.runj('DamageStatsTotal',0,0))

    def test_round_rollover_snapshots_both_directions(self):
        self.runj('DamageStatsRecordHit',0,2,100000,90.,0.)
        self.runj('DamageStatsNextRound')
        self.assertEqual(0.,self.runj('DamageStatsTotal',2,4))
        self.assertEqual(90.,self.runj('DamageStatsTotal',2,7))
        self.assertEqual(90.,self.runj('DamageStatsTotal',0,3))
        self.assertEqual(90.,self.runj('DamageStatsTotal',2,5))

    def test_taken_ranking_uses_taken_not_dealt(self):
        self.runj('DamageStatsRecordHit',0,2,100000,100.,0.)
        self.runj('DamageStatsRecordHit',5,0,100000,30.,0.)
        self.vm.g['DS_Direction']=1;self.runj('DS_RankPlayers')
        self.assertEqual([2,0,5],[self.vm.g['DS_Order'][n] for n in range(3)])

    def test_hit_collector_allocates_no_handles_or_strings(self):
        for name in ['I2S','R2SW','GetObjectName','BlzGetAbilityIcon','BlzCreateFrameByType','CreateTimer','CreateTrigger','InitHashtable']:
            self.vm.g[name]=lambda *_,n=name:self.fail(n)
        for _ in range(30):self.runj('DamageStatsRecordHit',0,2,100000,50.9,.2)
        self.assertEqual(1500.,self.runj('DamageStatsTotal',2,4))

    def test_native_attack_has_a_distinct_positive_damage_bucket(self):
        self.hit(source=0)
        self.assertEqual(10.,self.amount(source=-1))
        self.assertEqual('Attack',self.runj('DS_SourceName',-1))

    def test_positive_fractional_damage_is_not_labelled_zero(self):
        self.assertEqual('<1',self.runj('DS_AmountLabel',.25))
        self.assertEqual('0',self.runj('DS_AmountLabel',0.))

    def test_ability_uses_its_visible_title_and_item_uses_its_item_name(self):
        self.assertEqual('Burning Finger',self.runj('DS_SourceName','A001'))
        self.assertEqual('Source I001',self.runj('DS_SourceName','I001'))

    def test_opening_a_previously_hidden_view_redraws_even_without_new_hits(self):
        self.hit();self.visible['large']=True
        self.runj('DS_Tick');self.assertEqual(self.vm.g['DS_Version'],self.vm.g['DS_LastVersion'])
        self.visible['large']=False;self.runj('DS_Tick');self.heights.clear()
        self.visible['small']=True;self.runj('DS_Tick')
        self.assertTrue(self.heights)

    def test_hits_stay_buffered_until_the_synced_five_second_fold(self):
        self.runj('DS_Pending',0,100000,10.);self.runj('DS_Pending',0,100000,2.);self.runj('DS_Pending',10,100001,4.)
        self.assertEqual(0.,self.runj('DamageStatsTotal',0,0));self.assertEqual(0,self.vm.g['DS_Version'])
        for _ in range(9):self.runj('DS_Tick')
        self.assertEqual(0.,self.runj('DamageStatsTotal',0,1))
        self.runj('DS_Tick')
        for page in range(3):
            self.assertEqual(12.,self.runj('DamageStatsTotal',0,page));self.assertEqual(4.,self.runj('DamageStatsTotal',0,4+page))
            self.assertEqual(12.,self.amount(page));self.assertEqual(1,self.vm.g['DS_Count'][page*10])
        self.assertEqual(1,self.vm.g['DS_Version']);self.assertEqual(0,self.vm.g['DS_PendDirty'])
        self.runj('DS_Pending',0,100000,5.);self.runj('DamageStatsNextRound')
        self.assertEqual(17.,self.amount(3));self.assertEqual(0.,self.amount(0))

    def test_top_cells_pick_the_biggest_sources_without_a_full_sort(self):
        for n in range(40):self.hit(source=100000+n,amount=float((n*17)%40+1))
        self.assertEqual(8,self.runj('DS_SelectTop',0,8))
        self.assertEqual([100000+n for n in sorted(range(40),key=lambda n:-((n*17)%40))[:8]],[self.vm.g['DS_Recent'][i] for i in range(8)])
        for n,amount in enumerate([5.,30.,12.]):self.hit(pid=2,source=200000+n,amount=amount)
        self.assertEqual(3,self.runj('DS_SelectTop',2,8))
        self.assertEqual([200001,200002,200000,0],[self.vm.g['DS_Recent'][i] for i in range(4)])

    def test_large_source_list_stays_sorted_for_a_long_training_session(self):
        for n in range(451):self.hit(source=100000+n,amount=(n*37)%451+1)
        count=self.runj('DS_SortSources',0)
        values=[self.amount(source=self.vm.g['DS_SourceOrder'][i]) for i in range(count)]
        # Only the 12 biggest sources are kept; totals still include every hit.
        self.assertEqual(12,count);self.assertEqual(sorted(((n*37)%451+1 for n in range(451)),reverse=True)[:12],values)


class Attribution(unittest.TestCase):
    def test_nested_native_damage_restores_outer_source_even_for_dead_target(self):
        text=(ROOT/'triggers/Systems/Systems2.j').read_text(encoding='utf-8-sig')
        names=['DamageSource','dmgmag','dmgphys','dmgatk','spelldmg']
        code='\n'.join(re.search(r'(?m)^\s*function '+n+r' takes.*?^\s*endfunction',text,re.S)[0] for n in names)
        vm=JassState(code);g=vm.g
        for n in names:g[n]=lambda *a,n=n:vm.run(n,a)
        g.update(GearDamageActiveSource=0,GearDamageNextSource=0,ATTACK_TYPE_MAGIC=1,
                 ATTACK_TYPE_NORMAL=2,ATTACK_TYPE_MELEE=3,DAMAGE_TYPE_NORMAL=1,
                 DAMAGE_TYPE_FIRE=2,DAMAGE_TYPE_UNIVERSAL=3)
        hero=vm.unit();target=vm.unit();seen=[]
        def native(*_):
            seen.append(g['GearDamageActiveSource'])
            if len(seen)==1:
                vm.run('DamageSource',(200000,));vm.run('dmgphys',(hero,target,5.))
                self.assertEqual(100000,g['GearDamageActiveSource'])
        g['UnitDamageTarget']=native
        vm.run('DamageSource',(100000,));vm.run('dmgmag',(hero,target,10.))
        self.assertEqual([100000,200000],seen);self.assertEqual(0,g['GearDamageActiveSource'])
        target.life=0;vm.run('DamageSource',(300000,));vm.run('spelldmg',(hero,target,10.))
        self.assertEqual(0,g['GearDamageNextSource']);self.assertEqual(0,g['GearDamageActiveSource'])

    def test_damage_numbers_merge_per_target_player_and_kind_and_show_only_to_owners(self):
        text=(ROOT/'triggers/Systems/DmgSys.j').read_text(encoding='utf-8-sig')
        code='\n'.join(re.search(r'(?m)^function '+n+r' takes.*?^endfunction',text,re.S)[0] for n in ['DmgTextFlush','DmgTextAdd'])
        vm=JassState(code);g=vm.g;tags=[];timers=[];local=[3]
        class Tag:pass
        def create():
            t=Tag();tags.append(t);return t
        for n in ['DmgTextFlush','DmgTextAdd']:g[n]=lambda *a,n=n:vm.run(n,a)
        for n in ['DmgTextHid','DmgTextKey','DmgTextSource','DmgTextTarget','DmgTextKind','DmgTextAmount','DmgTextX','DmgTextY','DmgTextAngle']:
            g[n]=defaultdict(int)
        g.update(DMG_TEXT_SLOTS=64,DMG_TEXT_WINDOW=.10,DmgTextCount=0,DmgTextIndex={},DmgTextTimer='timer',
                 GetHandleId=lambda u:u,GAngle=lambda c,t:0.,GetUnitX=lambda u:100.,GetUnitY=lambda u:200.,
                 LoadInteger=lambda h,p,k:h.get((p,k),0),SaveInteger=lambda h,p,k,v:h.update({(p,k):v}),
                 RemoveSavedInteger=lambda h,p,k:h.pop((p,k),None),TimerStart=lambda *a:timers.append(a),
                 CreateTextTag=create,SetTextTagPos=lambda *a:None,SetTextTagText=lambda t,s,size:setattr(t,'text',s),
                 SetTextTagColor=lambda t,*c:setattr(t,'color',c),SetTextTagLifespan=lambda *a:None,
                 SetTextTagFadepoint=lambda *a:None,SetTextTagPermanent=lambda *a:None,SetTextTagVelocity=lambda *a:None,
                 SetTextTagVisibility=lambda t,v:setattr(t,'visible',v),IsVisibleToPlayer=lambda x,y,p:True,
                 GetLocalPlayer=lambda:local[0],GetPlayerId=lambda p:p,I2S=str,Cos=lambda a:1.,Sin=lambda a:0.,bj_DEGTORAD=.0174)
        for amount in [10,20,30]:vm.run('DmgTextAdd',('c','target',3,5,0,amount))
        vm.run('DmgTextAdd',('c','target',3,5,1,7));vm.run('DmgTextAdd',('c2','target',4,5,0,9))
        self.assertEqual(1,len(timers));self.assertFalse(tags)
        vm.run('DmgTextFlush',())
        self.assertEqual(['60','7','9'],[t.text for t in tags]);self.assertEqual([True,True,False],[t.visible for t in tags])
        self.assertEqual((255,0,0,255),tags[0].color);self.assertEqual((47,99,255,255),tags[1].color)
        self.assertFalse(g['DmgTextIndex']);self.assertEqual(0,g['DmgTextCount'])

    def test_deferred_instances_capture_and_replay_their_own_source(self):
        text=(ROOT/'triggers/Systems/Systems2.j').read_text(encoding='utf-8-sig')
        for name in ['KS_DelayedDamage','KS_DamageOverTime']:
            body=text.split('private struct '+name,1)[1].split('endstruct',1)[0]
            self.assertIn('set damageSource = GearDamageNextSource',body)
            self.assertIn('set GearDamageNextSource = 0',body)
            for hit in re.finditer(r'call dmg(?:mag|phys|atk)\(',body):
                self.assertTrue(body[:hit.start()].rstrip().endswith('call DamageSource(damageSource)'))

    def test_record_uses_entry_snapshot_after_damage_modifiers_and_not_local_ui(self):
        text=(ROOT/'triggers/Systems/DmgSys.j').read_text(encoding='utf-8-sig')
        body=text.split('function Trig_DmgSys_Actions ',1)[1].split('endfunction',1)[0]
        self.assertIn('local integer damageSourceId = GearDamageActiveSource',body)
        self.assertLess(body.index('GearDamageRun(c, td, dmg, typedmg, 3)'),body.index('DamageStatsRecordHit'))
        self.assertIn('targetIsHero and not targetIsIllusion',body)
        self.assertIn('DamageStatsRecordHitFrom(c,id,id2,damageSourceId,dmg,quincyShare)',body)

    def test_panels_default_closed_and_damage_column_does_not_change_saved_hero_guide(self):
        text=SOURCE.read_text(encoding='utf-8-sig')
        self.assertIn('BlzFrameSetVisible(DS_Small,false)',text)
        self.assertNotIn('WUI_RegisterColumnPanel',text)
        ui=(ROOT/'triggers/WOS_Start/WOSUI.j').read_text(encoding='utf-8-sig')
        self.assertIn('private boolean WUI_TestOpen = false',ui)
        self.assertIn('if WUI_ColRemember[i] then',ui)
        self.assertIn('WUI_RegisterWindowPart(12,DS_Large)',text)


if __name__=='__main__':unittest.main()
