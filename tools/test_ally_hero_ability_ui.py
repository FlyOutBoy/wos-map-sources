"""Execute AllyHeroAbilityUI's real selection, tooltip and cooldown paths."""
from collections import defaultdict
from pathlib import Path
import re
import unittest
from test_crocodile import JassState

ROOT = Path(__file__).resolve().parents[1]


class AllyAbilityUI(unittest.TestCase):
    def setUp(self):
        source = (ROOT/'triggers/WOS_Start/ShowCD.j').read_text(encoding='utf-8-sig')
        self.vm = JassState(source)
        self.viewer = 0
        self.allies = {(0,1)}
        self.frames = {}
        self.reads = []
        g = self.vm.g
        wui = (ROOT/'triggers/WOS_Start/WOSUI.j').read_text(encoding='utf-8-sig')
        g['WUI_ICON_SIZE'] = float(re.search(r'WUI_ICON_SIZE = ([0-9.]+)', wui)[1])
        g['WUI_AbilityY'] = lambda slot: .044 if slot >= 5 else .023
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
            'AHUI_TooltipsReady':True,'AHUI_AllowCooldownRead':False,
            'AHUI_GameUI':'game','AHUI_ConsoleBackdrop':'console',
            'bj_MAX_PLAYER_SLOTS':24,'Player':lambda i:i,'GetPlayerId':lambda p:p,
            'GetLocalPlayer':lambda:self.viewer,
            'BlzGetMouseScreenPosX':lambda:0,'BlzGetMouseScreenPosY':lambda:0,
            'BlzPixelToFrameX':lambda v:v,'BlzPixelToFrameY':lambda v:v,
            'IsPlayerAlly':lambda v,o:v==o or (v,o) in self.allies,
            'IsUnitType':lambda u,t:u.type!='ordinary', 'IsUnitIllusion':lambda u:u.illusion,
            'TestMode':False,'TestUnit':None,'TestAllyUnit':None,
            'HaveSavedBoolean':lambda h,k,c:(k,c) in h,
            'StringHash':lambda s:s,'I2R':float,'R2SW':lambda v,w,p:f'{v:.{p}f}',
            'BlzGetUnitAbilityCooldownRemaining':self.cooldown,
            'BlzGetAbilityIcon':lambda a:'BTN'+a, 'ConvertBTNtoDISBTN':lambda s:'DIS'+s,
            'BlzFrameSetVisible':lambda f,v:self.frame(f,'visible',v),
            'BlzFrameSetAlpha':lambda f,v:self.frame(f,'alpha',v),
            'BlzFrameSetText':lambda f,v:self.frame(f,'text',v),
            'BlzFrameSetTexture':lambda f,v,*_:self.frame(f,'texture',v),
            'BlzFrameSetSize':lambda f,*v:self.frame(f,'size',v),
            'BlzFrameSetPoint':lambda *a:None, 'BlzFrameClearAllPoints':lambda *a:None,
            'BlzFrameSetAbsPoint':lambda *a:None,
            'BlzFrameGetHeight':lambda f:.06,
            'WUI_ShowNativeAbilitySlot': lambda slot, visible: self.frame(('native',slot),'visible',visible),
            'BlzGetAbilityTooltip':lambda a,l:'Title '+a,
            'BlzGetAbilityExtendedTooltip':lambda a,l:f'Description {a} rank {l+1}',
            'BlzGetAbilityManaCost':lambda a,l:50,
            'FRAMEPOINT_TOPLEFT':'tl','FRAMEPOINT_TOPRIGHT':'tr','FRAMEPOINT_BOTTOMRIGHT':'br','FRAMEPOINT_BOTTOMLEFT':'bl',
        })
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
            'ORIGIN_FRAME_COMMAND_BUTTON': 'commands', 'FRAMEPOINT_CENTER': 'center',
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

    def test_own_hero_keeps_native_commands_and_leaves_unlearned_cells_empty(self):
        self.c.owner = self.viewer
        del self.c.abilities[self.vm.g['CrocodileW_ID']]
        self.refresh()
        self.assertFalse(self.reads, 'Own commands use the native cooldown renderer')
        for slot in range(7):
            self.assertFalse(self.value('AHUI_Root',slot,'visible'))
            self.assertFalse(self.value('AHUI_KeyText',slot,'visible'))
        self.assertFalse(self.frames[('native',1),'visible'])
        self.assertFalse(self.value('AHUI_CooldownFill',1,'visible'))
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
