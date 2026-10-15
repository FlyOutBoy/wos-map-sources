"""Execute TEST range lifecycle/presentation and verify imported MDX contracts."""
from collections import defaultdict
from pathlib import Path
import json
import re
import struct
import tempfile
import unittest

from test_crocodile import JassState
from install_ability_range_assets import ASSETS, MODEL, TEXTURE, PREFIX, chunks, dependencies, install
from prepare_ability_range_test import integrate_utb, integrate_ahui, integrate_wui, install as install_test

ROOT = Path(__file__).resolve().parents[1]


class RangeRuntime(unittest.TestCase):
    def setUp(self):
        self.source = (ROOT/'test_map/ability_range/AbilityRangePreview.j').read_text(encoding='utf-8')
        self.vm = JassState(self.source)
        self.local = 0
        self.radius = 512.0
        self.calls = []
        self.valid = {'a','b'}
        self.dead = set()
        self.blocked = False
        self.owner = {'a':0,'b':1}
        self.number = 0
        self.key = 'V'
        self.binding = 'V'
        self.pressed = True
        self.active = True
        self.down = True
        def create(*args):
            self.number += 1
            self.calls.append(('create',self.number))
            return self.number
        self.vm.g.update({
            'Hero':defaultdict(lambda:None,{0:'a',1:'b'}), 'TestUnit':None,'TestAllyUnit':None,
            'AR_Hero':defaultdict(lambda:None),'AR_NextHero':defaultdict(lambda:None),'AR_Effect':defaultdict(lambda:None),
            'AR_RequestedHero':defaultdict(lambda:None),'AR_RequestedAbility':defaultdict(int),
            'AR_Held':defaultdict(bool),'AR_LatchedHero':defaultdict(lambda:None),
            'AR_LatchedAbility':defaultdict(int),'AR_HeldKey':defaultdict(lambda:None),
            'AR_Visible':-1,'AR_Scale':0.0,'AR_Ground':'private-location','AR_MODEL':MODEL,
            'Player':lambda i:i,'GetLocalPlayer':lambda:self.local,
            'GetUnitTypeId':lambda u:1 if u in self.valid else 0,
            'IsUnitIllusion':lambda u:False,
            'UNIT_TYPE_HERO':'hero','UNIT_TYPE_DEAD':'dead','ANIM_TYPE_STAND':'stand',
            'IsUnitType':lambda u,t:u in self.dead if t=='dead' else True,
            'GetOwningPlayer':lambda u:self.owner[u], 'IsUnitHidden':lambda u:False,
            'AAUniversalTooltips_GetPreviewRadius':lambda u,a:self.radius,
            'GetTriggerPlayer':lambda:0,'GetPlayerId':lambda p:p,
            'BlzGetTriggerPlayerKey':lambda:self.key,'BlzGetTriggerPlayerIsKeyDown':lambda:self.down,
            'WUI_GetHotkey':lambda c,p:self.binding,'WUI_HOTKEY_RANGE':6,
            'WUI_RangeHoldInputBlocked':lambda p:False,'BlzIsKeyPressed':lambda k:self.pressed,
            'BlzIsLocalClientActive':lambda:self.active,
            'WUI_RangePreviewBlocked':lambda:self.blocked,
            'AddSpecialEffect':create,'DestroyEffect':lambda e:self.calls.append(('destroy',e)),
            'BlzPlaySpecialEffect':lambda *a:None,
            'BlzSetSpecialEffectAlpha':lambda *a:self.calls.append(('alpha',)+a),
            'BlzSetSpecialEffectScale':lambda *a:self.calls.append(('scale',)+a),
            'BlzSetSpecialEffectPosition':lambda *a:self.calls.append(('position',)+a),
            'MoveLocation':lambda *a:None,'GetLocationZ':lambda l:47.0,
            'GetUnitX':lambda u:123.0,'GetUnitY':lambda u:456.0,
        })
        self.runj('AR_Reconcile')

    def runj(self,name,*args):
        return self.vm.run(name,args)

    def show(self,hero='a',pid=0):
        self.runj('AR_Request',pid,hero,100)
        self.runj('AR_Render',pid)

    def test_synced_create_hidden_deduplicated_and_reused(self):
        self.vm.g['TestUnit']='a'
        self.vm.g['Hero'][2]='b'
        self.runj('AR_Reconcile')
        self.assertEqual(self.number,2)
        self.assertEqual([c for c in self.calls if c[0]=='alpha'], [('alpha',1,0),('alpha',2,0)])
        self.show()
        self.radius=1024
        self.show()
        self.assertEqual(self.number,2)
        self.assertIn(('scale',1,1.0),self.calls)
        self.assertIn(('scale',1,2.0),self.calls)
        self.assertIn(('position',1,123.0,456.0,50.0),self.calls)

    def test_thresholds_no_clamping_and_no_hidden_position_updates(self):
        for radius in (-1,0,2500.01,5000):
            self.calls.clear();self.radius=radius;self.show()
            self.assertFalse(any(c[0] in ('position','scale') for c in self.calls))
            self.assertEqual(self.vm.g['AR_Visible'],-1)
        for radius in (1,512,1024,1536,2048,2500):
            self.radius=radius;self.show()
            self.assertEqual(self.vm.g['AR_Scale'],radius/512.0)

    def test_only_owner_can_show_and_wrong_client_does_nothing(self):
        self.calls.clear();self.show('b')
        self.assertFalse(self.calls)
        self.local=1;self.show('a',0)
        self.assertFalse(self.calls)
        self.show('b',1)
        self.assertIn(('alpha',2,255),self.calls)

    def test_hide_blocked_death_and_removal(self):
        self.show();self.blocked=True;self.show()
        self.assertIn(('alpha',1,0),self.calls)
        self.blocked=False;self.show();self.dead.add('a');self.show()
        self.assertEqual(self.vm.g['AR_Visible'],-1)
        self.dead.clear();self.show();self.valid.remove('a');self.runj('AR_Reconcile')
        self.assertIn(('destroy',1),self.calls)
        self.assertIsNone(self.vm.g['AR_Effect'][0])

    def test_replacement_destroys_old_creates_hidden_new_on_all_clients(self):
        histories=[]
        for local in (0,1):
            self.setUp();self.local=local
            self.vm.g['Hero'][0]=None
            self.runj('AR_Reconcile');self.vm.g['Hero'][0]='a';self.runj('AR_Reconcile')
            histories.append([c for c in self.calls if c[0] in ('create','destroy')])
        self.assertEqual(histories[0],histories[1])

    def test_swap_retires_all_old_effects_before_creating_replacements(self):
        self.calls.clear()
        self.vm.g['Hero'][0]='b';self.vm.g['Hero'][1]='a'
        self.runj('AR_Reconcile')
        lifecycle=[c[0] for c in self.calls if c[0] in ('create','destroy')]
        self.assertEqual(lifecycle,['destroy','destroy','create','create'])

    def test_hover_leave_hides_without_hold_and_v_has_no_control(self):
        self.show();self.runj('AR_Hide',0);self.runj('AR_Render',0)
        self.assertEqual(self.vm.g['AR_Visible'],-1)
        self.assertEqual(self.vm.g['AR_RequestedAbility'][0],0)
        self.assertNotIn('AR_OnHoldKey',self.source)
        self.assertNotIn('AR_Held',self.source)
        self.assertNotIn('WUI_RegisterHotkey',self.source)
        self.assertNotIn('OSKEY_V',self.source)

    def test_hover_cancel_and_other_player_leave_are_local_only(self):
        self.show();self.runj('AR_Hide',1)
        self.assertEqual(self.vm.g['AR_Visible'],0)
        self.runj('AR_Cancel',0)
        self.assertEqual(self.vm.g['AR_Visible'],-1)
        self.assertEqual(self.number,2)

    def test_hover_has_no_allocation_sync_or_new_timers(self):
        tail=self.source[self.source.index('function AR_Request'):self.source.index('private function AR_Init')]
        self.assertNotRegex(tail,r'\b(AddSpecialEffect|DestroyEffect|Create|Save|BlzSendSyncData)\w*\(')
        self.assertNotIn('TimerStart(',self.source)


class BuilderSource(unittest.TestCase):
    def setUp(self):
        src=(ROOT/'triggers/WOS_Start/UniversalTooltips.j').read_text(encoding='utf-8-sig')
        if 'function GetDisplayedRange' not in src:
            src=integrate_utb(src)
        self.src=src
        funcs=re.findall(r'(?m)^\s*(?:private|public) function (?:ReadCastRange|ReadHeroCastRange|GetDisplayedRange) takes[^\n]*\n[\s\S]*?^\s*endfunction',src)
        self.vm=JassState('\n'.join(funcs))
        self.level=1;self.range=640.0;self.registered=True;self.form=0
        self.vm.g.update({'HT_DATA':{},'GetUnitAbilityLevel':lambda u,a:self.level,
            'GetHandleId':lambda u:7,'BlzGetUnitAbility':lambda u,a:'ability',
            'LoadInteger':lambda h,p,c:self.form if c==8888 else int(self.registered),
            'BlzGetAbilityRealLevelField':lambda a,f,l:self.range+l*10,
            'ABILITY_RLF_CAST_RANGE':'range','StarrkQ_ID':999999,
            'ARules_GetCastRange':lambda h,a,ab,l:self.range+(l-1)*10})

    def test_same_builder_field_live_level_and_registration(self):
        self.assertIn('set v = ReadCastRange(ab, i)',self.src)
        self.assertEqual(self.vm.run('GetDisplayedRange',('hero',123)),640)
        self.range=900;self.level=3
        self.assertEqual(self.vm.run('GetDisplayedRange',('hero',123)),920)
        self.registered=False
        self.assertEqual(self.vm.run('GetDisplayedRange',('hero',123)),0)
        self.registered=True;self.level=0
        self.assertEqual(self.vm.run('GetDisplayedRange',('hero',123)),0)

    def test_production_install_guard(self):
        with self.assertRaises(ValueError):install_test(ROOT)


class HoverIntegration(unittest.TestCase):
    def setUp(self):
        self.source=(ROOT/'triggers/WOS_Start/ShowCD.j').read_text(encoding='utf-8-sig')
        if 'call AR_Reconcile()' not in self.source:
            self.skipTest('Full TEST hover integration is exercised in the isolated candidate')
        if 'AHUI_TOOLTIP_LEAVE_TICKS' not in self.source:
            from prepare_ability_range_hold_test import upgrade_tooltip_leave
            self.source=upgrade_tooltip_leave(self.source)
        self.vm=JassState(self.source)
        self.x=0.4;self.y=0.04
        self.requests=[];self.hides=[];self.visible=True;self.native=False
        self.vm.g.update({
            'Player':lambda p:p,'GetLocalPlayer':lambda:0,'GetOwningPlayer':lambda u:0,
            'AHUI_SelectedHero':{0:'hero'},'Hero':{0:'hero'},'AHUI_HoveredSlot':{0:-1},
            'AHUI_HoverPips':{0:False},'AHUI_PingHoverGrace':{0:0},
            'AHUI_TOOLTIP_LEAVE_TICKS':10,
            'AHUI_SLOT_COUNT':1,'AHUI_LEARN_SLOTS':1,'AHUI_ICON_SIZE':0.04,'WUI_PIP_Y':0.01,
            'AHUI_PipMax':{0:0},'AHUI_SlotVisible':{0:True},'AHUI_TooltipRoot':{0:'tooltip'},
            'AHUI_CurrentAbility':{0:100},'AHUI_FrameIndex':lambda p,s:0,
            'AHUI_IsEligibleHero':lambda u,p:True,'WUI_RangePreviewBlocked':lambda:False,
            'BlzGetMouseScreenPosX':lambda:self.x,'BlzGetMouseScreenPosY':lambda:self.y,
            'BlzPixelToFrameX':lambda x:x,'BlzPixelToFrameY':lambda y:y,
            'BlzIsMouseButtonPressed':lambda b:False,'MOUSE_BUTTON_TYPE_RIGHT':'right',
            'AHUI_RequestCooldownPing':lambda *a:None,'AHUI_ReleaseCooldownPing':lambda *a:None,
            'AHUI_CooldownPingCommandAt':lambda *a:-1,'AHUI_PingInputInside':{0:False},
            'AHUI_CooldownTooltipContains':lambda *a:False,
            'AHUI_GetSlotCenterX':lambda s:0.4,'AHUI_GetSlotCenterY':lambda s:0.04,
            'AHUI_RefreshTooltip':lambda *a:None,'AHUI_HideTooltip':lambda *a:self.hides.append(a),
            'BlzFrameIsVisible':lambda f:self.visible,
            'WUI_RangeNativeSlotVisible':lambda s:self.native,
            'AR_Hide':lambda *a:self.hides.append(a),'AR_Request':lambda *a:self.requests.append(a),
        })

    def hover(self):self.vm.run('AHUI_UpdateHoveredSlot',(0,))

    def test_custom_hover_and_switch_requests_current_ability(self):
        self.hover();self.assertEqual(self.requests[-1],(0,'hero',100))
        self.vm.g['AHUI_CurrentAbility'][0]=101;self.hover()
        self.assertEqual(self.requests[-1],(0,'hero',101))

    def test_native_hover_uses_existing_coordinates_without_new_tooltip(self):
        self.vm.g['AHUI_SlotVisible'][0]=False;self.native=True;self.visible=False
        self.hover();self.assertEqual(self.requests[-1],(0,'hero',100))
        self.assertFalse(self.hides)

    def test_leave_hides_range_immediately_even_during_old_chat_tooltip_grace(self):
        self.hover();self.x=0.7;self.hover()
        self.assertEqual(self.requests[-1],(0,None,0))

    def test_description_does_not_renew_its_own_half_second_leave_window(self):
        self.hover();self.x=0.7
        self.vm.g['AHUI_CooldownTooltipContains']=lambda *a:True
        for _ in range(9):self.hover()
        self.assertFalse(self.hides)
        self.hover()
        self.assertTrue(self.hides)
        self.assertEqual(self.vm.g['AHUI_HoveredSlot'][0],-1)

    def test_actual_icon_reentry_renews_description_window(self):
        self.hover();self.x=0.7
        for _ in range(9):self.hover()
        self.x=0.4;self.hover();self.x=0.7
        for _ in range(9):self.hover()
        self.assertFalse(self.hides)
        self.hover();self.assertTrue(self.hides)


class OverlayGate(unittest.TestCase):
    def test_existing_and_test_covers_and_hotkey_editing(self):
        s=(ROOT/'triggers/WOS_Start/WOSUI.j').read_text(encoding='utf-8-sig')
        if 'function WUI_RangePreviewBlocked' not in s:s=integrate_wui(s)
        vm=JassState(s)
        shown=set()
        vm.g.update({'WUI_OriginHidden':False,'WUI_HeroLayerLocked':False,
            'WUI_InfoOpen':False,'WUI_MenuOpen':False,'WUI_HotkeyEdit':{0:False},
            'Player':lambda p:p,'GetLocalPlayer':lambda:0,'GetPlayerId':lambda p:p,
            'WUI_CoverWatch':'shop','WUI_ModalCount':1,'WUI_Modal':{1:'pick'},
            'WUI_RangeCoverCount':1,'WUI_RangeCover':{1:'music'},
            'BlzFrameIsVisible':lambda f:f in shown})
        self.assertFalse(vm.run('WUI_RangePreviewBlocked'))
        for panel in ('shop','pick','music'):
            shown.add(panel);self.assertTrue(vm.run('WUI_RangePreviewBlocked'));shown.clear()
        vm.g['WUI_HotkeyEdit'][0]=True;self.assertTrue(vm.run('WUI_RangePreviewBlocked'))


class Assets(unittest.TestCase):
    def test_static_radius_dependency_and_alpha_contract(self):
        data=(ASSETS/'war3mapImported/WOSRange'/MODEL).read_bytes()
        c=dict(chunks(data))
        self.assertEqual(dependencies(data),[PREFIX+TEXTURE])
        self.assertFalse(set(c)&{b'PREM',b'PRE2',b'RIBB',b'LITE'})
        self.assertFalse(any(t in data for t in (b'KMTA',b'KGAO',b'KGSC',b'KGTR',b'KGRT')))
        self.assertEqual(len(c[b'GEOS']),struct.unpack_from('<I',c[b'GEOS'])[0])
        for i in range(4):
            x,y,z=struct.unpack_from('<3f',c[b'GEOS'],12+12*i)
            self.assertEqual((abs(x),abs(y)),(512,512))
        original=(ASSETS/'original'/TEXTURE).read_bytes()
        self.assertEqual((ASSETS/'war3mapImported/WOSRange'/TEXTURE).read_bytes(),original)

    def test_install_only_assets_imports_idempotent(self):
        with tempfile.TemporaryDirectory() as t:
            p=Path(t);m=p/'map';m.mkdir()
            imp=struct.pack('<II',1,0);(m/'war3map.imp').write_bytes(imp)
            for n in ('war3map.j','war3map.wct','war3map.w3a'):(m/n).write_bytes(b'protected')
            (m/'war3mapImported').mkdir()
            (m/'war3mapImported'/MODEL).write_bytes(b'existing hero model')
            self.assertTrue(install(m,backup_root=p/'backup'))
            self.assertFalse(install(m,backup_root=p/'backup'))
            self.assertEqual(struct.unpack_from('<II',(m/'war3map.imp').read_bytes()),(1,2))
            for n in ('war3map.j','war3map.wct','war3map.w3a'):self.assertEqual((m/n).read_bytes(),b'protected')
            self.assertEqual((m/'war3mapImported'/MODEL).read_bytes(),b'existing hero model')
            for n in (MODEL,TEXTURE):self.assertTrue((m/'war3mapImported/WOSRange'/n).is_file())
            self.assertEqual((next((p/'backup').iterdir())/'war3map.imp').read_bytes(),imp)


if __name__=='__main__':unittest.main()
