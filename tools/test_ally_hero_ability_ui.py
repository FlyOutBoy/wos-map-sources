"""Execute AllyHeroAbilityUI's real selection, tooltip and cooldown paths."""
from collections import defaultdict
from pathlib import Path
import re
import json
import unittest
from test_crocodile import JassState

ROOT = Path(__file__).resolve().parents[1]


class AllyAbilityUI(unittest.TestCase):
    def test_tooltip_cache_reuses_text_across_hovers_and_skips_unchanged_layout(self):
        self.allies.clear();self.refresh();g=self.vm.g
        g['AHUI_HoveredSlot'][0]=0
        metadata=[];writes=[];sizes=[]
        for name in ('BlzGetAbilityTooltip','BlzGetAbilityExtendedTooltip','BlzGetAbilityManaCost'):
            old=g[name]
            g[name]=lambda *args,n=name,fn=old:(metadata.append(n),fn(*args))[1]
        old_text=g['BlzFrameSetText'];old_size=g['BlzFrameSetSize']
        g['BlzFrameSetText']=lambda *a:(writes.append(a),old_text(*a))
        g['BlzFrameSetSize']=lambda *a:(sizes.append(a),old_size(*a))
        self.vm.run('AHUI_RefreshTooltip',(0,));first_writes=len(writes);first_sizes=len(sizes)
        for _ in range(200):self.vm.run('AHUI_RefreshTooltip',(0,))
        self.assertEqual(3,len(metadata));self.assertEqual(first_writes,len(writes));self.assertEqual(first_sizes,len(sizes))
        g['AHUI_TipEpoch']+=1;self.vm.run('AHUI_RefreshTooltip',(0,))
        self.assertEqual(6,len(metadata));self.assertEqual(first_writes,len(writes));self.assertEqual(first_sizes,len(sizes))
        # Another ability, then return: text comes from the fixed per-slot cache.
        g['AHUI_HoveredSlot'][0]=1;self.vm.run('AHUI_RefreshTooltip',(0,));before=len(metadata)
        g['AHUI_HoveredSlot'][0]=0;self.vm.run('AHUI_RefreshTooltip',(0,));self.assertEqual(before,len(metadata))
        g['BlzGetAbilityExtendedTooltip']=lambda *_:'Updated formula'
        g['TooltipTextRevision']+=1;self.vm.run('AHUI_RefreshTooltip',(0,))
        self.assertIn('Updated formula',self.value('AHUI_TooltipText',0,'text'))

    def test_cooldown_visual_reads_once_per_second_and_uses_whole_seconds(self):
        self.refresh();self.reads.clear()
        for _ in range(3):self.refresh()
        self.assertEqual([],self.reads)
        self.refresh();self.assertEqual(7,len(self.reads))
        for raw,expected in ((9.5,'10'),(.1,'1'),(10.,'10'),(0.,'0')):
            self.assertEqual(expected,self.vm.run('AHUI_FormatCooldown',(raw,)))

    def test_rimuru_black_flame_is_native_g_not_a_locked_custom_preview(self):
        import war3_object_workspace as workspace
        docs,_=workspace.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
        positions={}
        for doc in docs:
            if doc['source_file'] not in ('war3map.w3a','war3mapSkin.w3a'):continue
            for obj in doc['custom_objects']:
                fields=positions.setdefault(workspace.object_id(obj),{})
                fields.update({m['field']['text']:workspace.value_for_user(m) for m in obj['modifications']
                               if m['field']['text'] in ('abpx','abpy')})
        g=self.vm.g;self.c.owner=0;self.c.type=g['Rimuru_ID'];self.c.hero_level=35
        old,new=g['RimuruG3_ID'],g['RimuruG3_2_ID']
        self.c.abilities={old:{'level':1,'remaining':30},new:{'level':1,'remaining':0}}
        g['BlzGetAbilityPosX']=lambda a:positions.get(a,{}).get('abpx',0)
        g['BlzGetAbilityPosY']=lambda a:positions.get(a,{}).get('abpy',0)
        g['hs'][id(0),'AHUI swap '+old]=new
        self.vm.run('AHUI_OnSetPlayerAbilityAvailable',(0,old,False))
        self.vm.run('AHUI_OnSetPlayerAbilityAvailable',(0,new,True))
        self.refresh()
        self.assertEqual(new,g['AHUI_CurrentAbility'][6])
        self.assertTrue(g['AHUI_NativeCommandShown'][6])
        self.assertFalse(self.value('AHUI_CooldownFill',6,'visible'))
        g['AHUI_HoveredSlot'][0]=6
        self.vm.run('AHUI_RefreshTooltip',(0,))
        self.assertFalse(self.value('AHUI_TooltipRoot',0,'visible'))

    def test_takaoni_swap_renders_e_icon_and_description_then_restores_e(self):
        g=self.vm.g
        obj=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))['A114']
        base,shadow,takaoni=g['KyorakuE_ID'],g['KyorakuE2_ID'],g['KyorakuE4_ID']
        g['BlzGetAbilityIcon']=lambda a:obj['icon'] if a==takaoni else 'BTN'+a
        g['BlzGetAbilityTooltip']=lambda a,l:obj[f'tooltip level {l+1}'] if a==takaoni else 'Title '+a
        g['BlzGetAbilityExtendedTooltip']=lambda a,l:obj[f'extended_tooltip level {l+1}'] if a==takaoni else 'Description '+a
        self.c.type=g['Kyoraku_ID']
        self.c.abilities={base:{'level':3,'remaining':15},shadow:{'level':3,'remaining':20},takaoni:{'level':3,'remaining':0}}
        for own in (True,False):
            self.c.owner=0 if own else 1
            owner=self.c.owner
            g['hs'][id(owner),'AHUI swap '+base]=takaoni
            for ability,enabled in ((base,False),(shadow,False),(takaoni,True)):
                self.vm.run('AHUI_OnSetPlayerAbilityAvailable',(owner,ability,enabled))
            self.refresh()
            self.assertEqual(takaoni,g['AHUI_CurrentAbility'][2])
            if own:
                self.assertTrue(g['AHUI_NativeCommandShown'][2])
            else:
                self.assertEqual(obj['icon'],self.value('AHUI_Icon',2,'texture'))
                g['AHUI_HoveredSlot'][0]=2
                self.vm.run('AHUI_RefreshTooltip',(0,))
                self.assertIn('Takaoni',self.value('AHUI_TooltipTitle',0,'text'))
                self.assertIn('650 range past its center',self.value('AHUI_TooltipText',0,'text'))
            self.vm.run('AHUI_OnSetPlayerAbilityAvailable',(owner,takaoni,False))
            self.vm.run('AHUI_OnSetPlayerAbilityAvailable',(owner,base,True))
            self.refresh()
            self.assertEqual(base,g['AHUI_CurrentAbility'][2])

    def setUp(self):
        source = (ROOT/'triggers/WOS_Start/ShowCD.j').read_text(encoding='utf-8-sig')
        self.vm = JassState(source)
        self.viewer = 0
        self.allies = {(0,1)}
        self.frames = {}
        self.reads = []
        g = self.vm.g
        g.update({'AR_Cancel':lambda *_:None,'AR_Hide':lambda *_:None,'AR_Request':lambda *_:None,'AR_Render':lambda *_:None,'AR_Reconcile':lambda:None,'WUI_RangePreviewBlocked':lambda:False,'WUI_RangeNativeSlotVisible':lambda *_:False})
        g.update(AHUI_SelGroup=[],AHUI_MultiShown=False)
        g.setdefault('AHUI_DeselectPending', __import__('collections').defaultdict(bool))
        g.setdefault('WUI_ReleaseClickFocus', lambda: None)  # Shared button owner, checked by test_wos_ui_focus.
        wui = (ROOT/'triggers/WOS_Start/WOSUI.j').read_text(encoding='utf-8-sig')
        g['WUI_ICON_SIZE'] = float(re.search(r'WUI_ICON_SIZE = ([0-9.]+)', wui)[1])
        g['WUI_AbilityY'] = lambda slot: .044 if slot >= 5 else .023
        # Checkpoint 24: every configured skill sits in its own slot's cell.
        def pos(axis):
            def f(ability):
                for s in range(7):
                    if g['AHUI_CurrentAbility'][s] == ability:
                        return self.vm.run('AHUI_GetSlot' + axis, (s,))
                return -1
            return f
        g['BlzGetAbilityPosX'] = pos('X')
        g['BlzGetAbilityPosY'] = pos('Y')
        for kind,name,value in re.findall(r'(?m)^\s*(?:private )?(?:constant )?(integer|real|boolean|string) (\w+) = (.*)',source):
            g[name] = eval(value.split('//')[0].strip().replace('false','False').replace('true','True'),{},g)
        for kind,name in re.findall(r'(?m)^\s*private (\w+) array (\w+)',source):
            default = False if kind=='boolean' else 0 if kind in ('integer','real') else None
            g[name] = defaultdict(lambda v=default:v)
            if kind=='framehandle':
                for index in range(168):
                    g[name][index] = (name,index)
        # Use the project's rawcodes, including every candidate in the roster.
        for path in (ROOT/'triggers/Heroes').rglob('*.j'):
            for name,value in re.findall(r'\binteger (\w+_ID)\s*=\s*\'([^\']+)\'',path.read_text(encoding='utf-8-sig')):
                g[name] = value
        g.update({
            'WUI_COMMAND_X':0.354,'WUI_COMMAND_STEP':0.040,'WUI_HUD_Y':0.044,
            'AHUI_AbilityAvailability':{},'AHUI_UnitAbilityHidden':{},'AHUI_UnitAbilityDisabled':{},'hs':{},
            'AHUI_TooltipsReady':True,'AHUI_AllowCooldownRead':False,'TooltipTextRevision':0,'WUI_SettingsRevision':0,
            'AHUI_GameUI':'game','AHUI_ConsoleBackdrop':'console',
            'bj_MAX_PLAYER_SLOTS':24,'Player':lambda i:i,'GetPlayerId':lambda p:p,
            'GetLocalPlayer':lambda:self.viewer,
            'BlzGetMouseScreenPosX':lambda:0,'BlzGetMouseScreenPosY':lambda:0,
            'BlzPixelToFrameX':lambda v:v,'BlzPixelToFrameY':lambda v:v,
            'IsPlayerAlly':lambda v,o:v==o or (v,o) in self.allies,
            'IsUnitType':lambda u,t:t!='UNIT_TYPE_DEAD' and u.type!='ordinary', 'IsUnitIllusion':lambda u:u.illusion,
            'TestMode':False,'TestUnit':None,'TestAllyUnit':None,
            'HaveSavedBoolean':lambda h,k,c:(k,c) in h,
            'StringHash':lambda s:s,'I2R':float,'R2SW':lambda v,w,p:f'{v:.{p}f}',
            'BlzGetUnitAbilityCooldownRemaining':self.cooldown,
            'BlzGetAbilityIcon':lambda a:'BTN'+a, 'ConvertBTNtoDISBTN':lambda s:'DIS'+s,
            'BlzFrameSetVisible':lambda f,v:self.frame(f,'visible',v),
            'BlzFrameIsVisible':lambda f:self.frames.get((f,'visible'),False),
            'BlzFrameSetAlpha':lambda f,v:self.frame(f,'alpha',v),
            'BlzFrameSetText':lambda f,v:self.frame(f,'text',v),
            'BlzFrameGetText':lambda f:self.frames.get((f,'text'),''),
            'BlzFrameSetTextAlignment':lambda f,v,h:None,
            'TEXT_JUSTIFY_TOP':'top', 'TEXT_JUSTIFY_CENTER':'center', 'TEXT_JUSTIFY_LEFT':'left',
            'BlzFrameSetTexture':lambda f,v,*_:self.frame(f,'texture',v),
            'BlzFrameSetSize':lambda f,*v:self.frame(f,'size',v),
            'BlzFrameSetPoint':lambda *a:None, 'BlzFrameClearAllPoints':lambda *a:None,
            'BlzFrameSetAbsPoint':lambda *a:None,
            'BlzFrameGetHeight':lambda f:.06,
            'WUI_ShowNativeAbilitySlot': lambda slot, visible: self.frame(('native',slot),'visible',visible),
            'WUI_NativeCommandsHidden': lambda: False, 'WUI_IsHotkeyEditing': lambda: False,
            'WUI_SlotKeyLabel': lambda pid, slot: '', 'WUI_SetSlotCustomShown': lambda *_: None,
            'WUI_SlotShownKey': lambda pid, slot: 'QWERTFG'[slot],
            'TasAbilityChargeBox_GetValue': lambda *_: '',
            'TasAbilityChargeBox_CreatePortraitLabel': lambda frame: ('charge', frame),
            'BlzGetAbilityTooltip':lambda a,l:'Title '+a,
            'BlzGetAbilityExtendedTooltip':lambda a,l:f'Description {a} rank {l+1}',
            'BlzGetAbilityManaCost':lambda a,l:50,
            'FRAMEPOINT_TOPLEFT':'tl','FRAMEPOINT_TOPRIGHT':'tr','FRAMEPOINT_BOTTOMRIGHT':'br','FRAMEPOINT_BOTTOMLEFT':'bl',
            'FRAMEPOINT_CENTER':'c',
            # Checkpoint 20 learning row: main heroes, skill points and fields.
            'Hero':defaultdict(lambda:None),'GetHeroSkillPoints':lambda u:getattr(u,'skill_points',0),
            'WUI_AbilityX':lambda slot:.327+.040*slot,'WUI_PIP_Y':.0165,
            'ABILITY_IF_LEVELS':'alev','ABILITY_IF_REQUIRED_LEVEL':'arlv','ABILITY_IF_LEVEL_SKIP_REQUIREMENT':'alsk',
            # Checkpoint 21: object-data level table and unlock labels.
            'AHUI_LevelData':{},'HaveSavedInteger':lambda h,k,c:(k,c) in h,
            'WUI_SetText':lambda f,v:self.frame(f,'text',v),
            'WUI_CHASSIS_LEFT':0.160,'WUI_CHASSIS_RIGHT':0.830,'WUI_CHASSIS_TOP':0.094,
            'FRAMEPOINT_BOTTOM':'b',
        })
        self.vm.run('AHUI_InitLevelTable')
        self.c = self.vm.unit(owner=1)
        self.c.type = g['Crocodile_ID']
        for slot in 'Q W E R T F G'.split():
            self.c.abilities[g['Crocodile'+slot+'_ID']] = {'level':3 if slot in 'QWER' else 1,'remaining':12}
        g['AHUI_SelectedHero'][0] = self.c
        g['AHUI_HoveredSlot'][0] = -1

    def frame(self,handle,property_name,value):
        self.frames[handle,property_name] = value

    def cooldown(self,unit,ability):
        # Fail on any enemy read, including reads used only to select a variant.
        self.assertTrue(self.vm.run('AHUI_CanReadCooldown',(unit,self.viewer)))
        self.reads.append((unit,ability))
        return unit.abilities.get(ability,{}).get('remaining',0)

    def value(self,name,slot,property_name):
        return self.frames.get((self.vm.g[name][slot],property_name))

    def refresh(self):
        self.vm.run('AHUI_Refresh',(0,))

    def test_crocodile_all_seven_slots_and_ally_cooldowns(self):
        self.refresh()
        self.assertEqual(7,len(self.reads))
        for index,slot in enumerate('Q W E R T F G'.split()):
            self.assertEqual(self.vm.g['Crocodile'+slot+'_ID'],self.vm.g['AHUI_CurrentAbility'][index])
            self.assertTrue(self.value('AHUI_Icon',index,'visible'))
            self.assertTrue(self.value('AHUI_CooldownText',index,'visible'))

    def test_enemy_selection_and_hover_show_descriptions_without_cooldown_reads(self):
        self.allies.clear()
        self.vm.g.update(GetTriggerUnit=lambda:self.c,GetTriggerPlayer=lambda:0)
        self.vm.g['AHUI_SelectedHero'][0]=None  # A new selection (re-selecting the same hero rebuilds nothing).
        self.vm.run('AHUI_OnSelect')
        self.assertIs(self.c,self.vm.g['AHUI_SelectedHero'][0])
        self.assertFalse(self.reads)
        for index in range(7):
            self.assertTrue(self.value('AHUI_Icon',index,'visible'))
            self.assertFalse(self.value('AHUI_CooldownFill',index,'visible'))
            self.assertFalse(self.value('AHUI_CooldownText',index,'visible'))
        self.vm.g['AHUI_HoveredSlot'][0] = 0
        self.vm.run('AHUI_RefreshTooltip',(0,))
        self.assertIn('rank 3',self.value('AHUI_TooltipText',0,'text'))
        self.assertTrue(self.value('AHUI_TooltipRoot',0,'visible'))
        self.assertFalse(self.reads)

    def test_alliance_change_clears_previous_numbers_and_shading(self):
        self.refresh()
        self.allies.clear()
        self.reads.clear()
        self.refresh()
        self.assertFalse(self.reads)
        for index in range(7):
            self.assertEqual(0,self.vm.g['AHUI_CooldownPeak'][index])
            self.assertEqual(0,self.vm.g['AHUI_LastRemaining'][index])
            self.assertEqual('',self.value('AHUI_CooldownText',index,'text'))
            self.assertEqual(255,self.value('AHUI_Icon',index,'alpha'))

    def test_t2_swap_resolves_for_both_teams_and_returns_to_t(self):
        g=self.vm.g
        t,t2=g['CrocodileT_ID'],g['CrocodileT2_ID']
        self.c.abilities[t2]={'level':1,'remaining':2}
        for allied in (True,False):
            with self.subTest(allied=allied):
                self.allies={(0,1)} if allied else set()
                self.vm.run('AHUI_OnSetPlayerAbilityAvailable',(1,t,False))
                self.vm.run('AHUI_OnSetPlayerAbilityAvailable',(1,t2,True))
                self.refresh()
                self.assertEqual(t2,g['AHUI_CurrentAbility'][4])
                self.vm.run('AHUI_OnSetPlayerAbilityAvailable',(1,t,True))
                self.vm.run('AHUI_OnSetPlayerAbilityAvailable',(1,t2,False))
                self.refresh()
                self.assertEqual(t,g['AHUI_CurrentAbility'][4])

    def test_enemy_variant_is_not_selected_from_hidden_cooldown(self):
        self.allies.clear()
        self.c.abilities[self.vm.g['CrocodileT2_ID']]={'level':1,'remaining':20}
        self.refresh()
        self.assertFalse(self.reads)
        self.assertEqual(self.vm.g['CrocodileT_ID'],self.vm.g['AHUI_CurrentAbility'][4])

    def test_nonlocal_refresh_and_slot_do_not_read_or_change_frames(self):
        self.vm.g['AHUI_SelectedHero'][1]=self.c
        self.vm.run('AHUI_Refresh',(1,))
        self.vm.run('AHUI_RefreshSlot',(1,0))
        self.assertFalse(self.frames)
        self.assertFalse(self.reads)

    def test_overlay_roots_use_absolute_hud_positions_without_simpleframe_anchors(self):
        roots = []
        positions = {}

        def create(kind, name, parent, template, context):
            frame = (name, context)
            if name == 'AHUIRoot':
                self.assertEqual('independent-root', parent)
                roots.append(frame)
            return frame

        def point(frame, anchor, target, target_anchor, x, y):
            self.assertNotEqual('native-simple', target[0],
                                'Normal overlays must not anchor into native SIMPLEFRAME hierarchy')

        self.vm.g.update({
            'WUI_GetRoot': lambda: 'independent-root',
            'GetSlotByXY': lambda x, y: y * 4 + x,
            'BlzGetOriginFrame': lambda kind, slot: ('native-simple', slot),
            'BlzCreateFrameByType': create,
            'BlzFrameSetAbsPoint': lambda f, _, x, y: positions.update({f: (x, y)}),
            'BlzFrameSetPoint': point, 'BlzFrameSetAllPoints': lambda *_: None,
            'BlzFrameSetLevel': lambda *_: None, 'BlzFrameSetEnable': lambda *_: None,
            'BlzFrameSetScale': lambda *_: None, 'BlzFrameSetTextAlignment': lambda *_: None,
            'ORIGIN_FRAME_COMMAND_BUTTON': 'commands', 'FRAMEPOINT_CENTER': 'center', 'FRAMEPOINT_LEFT': 'left', 'BlzFrameSetModel': lambda *_: None,
            'TEXT_JUSTIFY_MIDDLE': 'middle', 'TEXT_JUSTIFY_CENTER': 'center',
            'TEXT_JUSTIFY_TOP': 'top', 'TEXT_JUSTIFY_LEFT': 'left',
        })
        self.vm.run('AHUI_CreateSlotFrames')
        self.assertEqual(24 * 7, len(roots))
        for frame in roots:
            slot = frame[1] % 7
            self.assertAlmostEqual(.354 + slot * .040, positions[frame][0])
            self.assertEqual(.044 if slot >= 5 else .023, positions[frame][1])

    def test_own_heroes_allow_placeholders_and_observers_keep_permissions(self):
        self.assertTrue(self.vm.run('AHUI_IsEligibleHero',(self.c,1)))
        self.c.illusion=True
        self.assertFalse(self.vm.run('AHUI_IsEligibleHero',(self.c,0)))
        self.c.illusion=False
        self.allies.clear()
        self.assertTrue(self.vm.run('AHUI_IsEligibleHero',(self.c,0)))
        self.assertFalse(self.vm.run('AHUI_CanReadCooldown',(self.c,0)))
        self.assertTrue(self.vm.run('AHUI_CanReadCooldown',(self.c,10)))

    def test_own_hero_keeps_native_commands_and_previews_unlearned_cells(self):
        self.c.owner = self.viewer
        del self.c.abilities[self.vm.g['CrocodileW_ID']]
        self.refresh()
        self.assertFalse(self.reads, 'Own commands use the native cooldown renderer')
        for slot in range(7):
            # W has its preview; native F/G get the WOS key badge over the stock button.
            self.assertEqual(slot == 1 or slot >= 5, bool(self.value('AHUI_Root',slot,'visible')))
            if slot >= 5:
                self.assertFalse(self.value('AHUI_Icon',slot,'visible'))
                self.assertTrue(self.value('AHUI_KeyText',slot,'visible'))
        self.assertFalse(self.frames[('native',1),'visible'])
        self.assertTrue(self.value('AHUI_CooldownFill',1,'visible'))
        self.assertEqual('DISBTN'+self.vm.g['CrocodileW_ID'],self.value('AHUI_CooldownFill',1,'texture'))
        self.assertFalse(self.value('AHUI_CooldownText',1,'visible'))
        self.assertTrue(self.frames[('native',0),'visible'])
        self.assertFalse(self.value('AHUI_Icon',0,'visible'))
        self.c.abilities[self.vm.g['CrocodileW_ID']] = {'level':1,'remaining':0}
        self.refresh()
        self.assertTrue(self.frames[('native',1),'visible'])
        self.assertFalse(self.value('AHUI_CooldownFill',1,'visible'))

    def test_hidden_own_ability_leaves_empty_cell_without_exposing_stock_occupant(self):
        self.c.owner = self.viewer
        ability = self.vm.g['CrocodileF_ID']
        self.vm.run('AHUI_OnBlzUnitHideAbility',(self.c,ability,True))
        self.refresh()
        self.assertFalse(self.frames[('native',5),'visible'])
        self.assertFalse(self.value('AHUI_KeyText',5,'visible'))
        self.assertFalse(self.value('AHUI_CooldownFill',5,'visible'))
        self.assertFalse(self.value('AHUI_CooldownText',5,'visible'))
        self.assertFalse(self.reads)

    def hover_tooltip(self, slot):
        self.vm.g['AHUI_HoveredSlot'][0] = slot
        self.vm.run('AHUI_RefreshTooltip', (0,))
        return bool(self.value('AHUI_TooltipRoot',0,'visible'))

    def test_granted_fg_use_only_native_tooltips_including_zero_requirement(self):
        g = self.vm.g
        self.c.owner = self.viewer
        for hero in ('Laxus', 'Erza'):
            self.c.type = g[hero+'_ID']
            for slot, key in ((5,'F'), (6,'G')):
                ability = g[hero+key+'_ID']
                self.c.abilities[ability] = {'level':1,'remaining':0}
                # These abilities are already granted, irrespective of skill points.
                self.c.hero_level = max(1, g['AHUI_LevelData'].get((ability,1),1))
                self.refresh()
                with self.subTest(hero=hero, slot=key):
                    self.assertTrue(g['AHUI_NativeCommandShown'][slot])
                    self.assertTrue(self.value('AHUI_KeyText',slot,'visible'))
                    self.assertFalse(self.hover_tooltip(slot))

    def test_missing_ability_preview_closes_when_learned_without_mouse_leave(self):
        self.c.owner = self.viewer
        ability = self.vm.g['CrocodileW_ID']
        del self.c.abilities[ability]
        self.refresh()
        self.assertTrue(self.hover_tooltip(1))
        self.c.abilities[ability] = {'level':1,'remaining':0}
        self.refresh()
        self.assertFalse(self.hover_tooltip(1))
        self.assertEqual('',self.vm.g['AHUI_TooltipKey'][0])

    def test_fg_native_guard_closes_cached_preview_and_survives_variant_swap(self):
        g = self.vm.g
        self.c.owner = self.viewer
        self.refresh()
        g['AHUI_TooltipKey'][0] = 'cached'
        self.frame(g['AHUI_TooltipRoot'][0],'visible',True)
        self.assertFalse(self.hover_tooltip(6))
        # A different granted ability in the same native cell owns its tooltip too.
        g['AHUI_CurrentAbility'][4] = g['CrocodileT2_ID']
        self.c.abilities[g['CrocodileT2_ID']] = {'level':1,'remaining':0}
        self.vm.run('AHUI_RefreshSlot',(0,4))
        self.assertTrue(g['AHUI_NativeCommandShown'][4])
        self.assertFalse(self.hover_tooltip(4))

    def test_custom_command_replacement_still_has_its_only_tooltip(self):
        self.c.owner = self.viewer
        self.vm.g['WUI_SlotKeyLabel'] = lambda pid,slot:'Z'
        self.refresh()
        self.assertFalse(self.vm.g['AHUI_NativeCommandShown'][6])
        self.assertTrue(self.hover_tooltip(6))

    def test_owned_fg_below_requirement_retains_locked_preview(self):
        g = self.vm.g
        self.c.owner = self.viewer
        ability = g['CrocodileG_ID']
        g['AHUI_LevelData'][ability,1] = 35
        self.c.hero_level = 1
        self.refresh()
        self.assertFalse(g['AHUI_NativeCommandShown'][6])
        self.assertTrue(self.hover_tooltip(6))
        self.c.hero_level = 35
        self.refresh()
        self.assertFalse(self.hover_tooltip(6))

    def test_other_hero_fg_retains_custom_tooltip_after_own_selection(self):
        self.c.owner = self.viewer
        self.refresh()
        self.assertFalse(self.hover_tooltip(6))
        self.c.owner = 1
        self.refresh()
        self.assertFalse(self.vm.g['AHUI_NativeCommandShown'][6])
        self.assertTrue(self.hover_tooltip(6))

    def test_frieren_milim_native_hover_requests_current_ranges_including_swaps(self):
        g=self.vm.g;self.c.owner=self.viewer;self.c.hero_level=35
        requests=[]
        g.update(WUI_ItemX=lambda s:-1.,WUI_ItemY=lambda s:-1.,WUI_ITEM_SIZE=.033,
                 WUI_RangeNativeItemVisible=lambda s:False,
                 WUI_RangeNativeSlotVisible=lambda s:self.frames.get((('native',s),'visible'),False),
                 AR_Request=lambda *args:requests.append(args))
        for hero,key,slot in (('Frieren','Q',0),('Frieren','Q2',0),('Frieren','Q3',0),('Frieren','W2',1),('Frieren','T2',4),('Milim','Q',0),('Milim','W',1),('Milim','E',2)):
            with self.subTest(hero=hero,ability=key):
                self.c.type=g[hero+'_ID'];ability=g[hero+key+'_ID']
                self.c.abilities={ability:{'level':1,'remaining':0}}
                self.refresh()
                self.assertEqual(ability,g['AHUI_CurrentAbility'][slot])
                g['BlzGetMouseScreenPosX']=lambda:self.vm.run('AHUI_GetSlotCenterX',(slot,))
                g['BlzGetMouseScreenPosY']=lambda:self.vm.run('AHUI_GetSlotCenterY',(slot,))
                self.vm.run('AHUI_UpdateHoveredSlot',(0,))
                self.assertEqual((0,self.c,ability),requests[-1])

    def test_empty_slot_has_no_icon_or_native_learn_button(self):
        self.c.owner = self.viewer
        self.vm.g['AHUI_CurrentAbility'][6] = 0
        self.vm.run('AHUI_RefreshSlot',(0,6))
        self.assertFalse(self.value('AHUI_Root',6,'visible'))
        self.assertFalse(self.value('AHUI_KeyText',6,'visible'))
        self.assertFalse(self.value('AHUI_Icon',6,'visible'))
        self.assertFalse(self.frames[('native',6),'visible'])
        self.assertFalse(self.reads)


if __name__=='__main__':
    unittest.main()
