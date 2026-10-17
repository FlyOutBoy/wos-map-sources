"""UI mouse sampling is local and demand-driven; hero tracking is a separate owner."""
from pathlib import Path
from collections import defaultdict
import re,unittest
from test_crocodile import JassState

ROOT=Path(__file__).resolve().parents[1]
def source(name):return (ROOT/'triggers/WOS_Start'/name).read_text(encoding='utf-8-sig')


class Registration(unittest.TestCase):
    def test_ui_has_no_world_mouse_down_or_up_registration(self):
        for name in ('EMOTES.j','WoS_Shop_Init.j'):
            with self.subTest(name=name):
                self.assertNotRegex(source(name),r'TriggerRegisterPlayerEvent\([^\n]*EVENT_PLAYER_MOUSE_(?:DOWN|UP)')
        self.assertIn('EVENT_PLAYER_UNIT_PICKUP_ITEM',source('WoS_Shop_Init.j'))
        self.assertIn('EVENT_PLAYER_UNIT_DROP_ITEM',source('WoS_Shop_Init.j'))

    def test_shop_input_uses_existing_fast_local_tick_and_preserves_30s_timeout(self):
        body=source('WoS_Shop_Init.j').split('function ShopSearchDebounceTick takes',1)[1].split('endfunction',1)[0]
        self.assertIn('call QB_ApplyLocalUIChanges()',body)
        self.assertNotIn('call QB_CheckDrag()',body)
        self.assertIn('call TriggerRegisterTimerExpireEvent(WUI_ShopRmbTrigger[i], ShopSearchDebounceTimer)',source('WoS_Shop_Init.j'))
        self.assertIn('call DisableTrigger(WUI_ShopRmbTrigger[i])',source('WoS_Shop_Init.j'))
        self.assertNotIn('QB_CheckDrag.evaluate()',source('ShowCD.j'))
        self.assertIn('SHOP_SEARCH_DEBOUNCE_PERIOD = 0.05',source('WoS_Shop_Init.j'))
        self.assertIn('QB_DragAge >= 600 or',source('WoS_Shop_Init.j'))

    def test_closed_shop_does_not_sample_or_send_for_idle_clicks(self):
        from test_quickbuy_fix8 import Fix8
        f=Fix8();f.setUp();g=f.vm.g
        def forbidden(*a):self.fail('Mouse read outside active UI')
        g.update(BlzIsMouseButtonPressed=forbidden,BlzGetMouseScreenPosX=forbidden,
                 BlzGetMouseScreenPosY=forbidden,WUI_TopShown=forbidden)
        g['Shop_Active'][0]=False
        for _ in range(500):f.vm.run('QB_CheckDrag')
        self.assertFalse(f.messages)


class ShopRmbLifecycle(unittest.TestCase):
    def test_real_trigger_enables_only_for_its_shop_and_closes_on_other_windows(self):
        import test_wos_ui as ui
        vm=ui.load_source('WOSUI.j');enabled=set()
        vm.g['WUI_ShopRmbTrigger'][0]='p0';vm.g['WUI_ShopRmbTrigger'][1]='p1'
        vm.g.update(EnableTrigger=lambda t:enabled.add(t),DisableTrigger=lambda t:enabled.discard(t),
            GetLocalPlayer=lambda:9)
        vm.run('WUI_SetShopRmb',(0,False));self.assertEqual(set(),enabled)
        vm.g['Shop_Active'][0]=True;vm.run('WUI_EnterExclusiveWindow',(0,0))
        self.assertEqual({'p0'},enabled)
        vm.run('WUI_EnterExclusiveWindow',(1,0));self.assertEqual(set(),enabled)
        self.assertFalse(vm.g['Shop_Active'][0])
        vm.g['Shop_Active'][1]=True;vm.run('WUI_EnterExclusiveWindow',(0,1))
        self.assertEqual({'p1'},enabled)
        vm.run('WUI_EnterExclusiveWindow',(-1,1));self.assertEqual(set(),enabled)

class Pollers(unittest.TestCase):
    def setUp(self):
        self.down=set();self.reads=[];self.actions=[]
    def read(self,key):self.reads.append(key);return key in self.down

    def emoji(self):
        vm=JassState(source('EMOTES.j'));g=vm.g
        g.update(GetLocalPlayer=lambda:0,GetPlayerId=lambda p:p,EmojiPanelOpen=defaultdict(bool),
                 EmojiRightWasDown=False,MOUSE_BUTTON_TYPE_RIGHT='right',BlzIsMouseButtonPressed=self.read)
        def close(p,flag):self.actions.append(('emoji',p,flag));g['EmojiPanelOpen'][p]=flag
        g['Emoji_ShowMenu']=close
        return vm

    def test_emoji_closed_never_reads_and_right_press_closes_only_once(self):
        vm=self.emoji()
        for _ in range(500):vm.run('Emoji_PollMouse')
        self.assertFalse(self.reads)
        vm.g['EmojiPanelOpen'][0]=True
        vm.run('Emoji_PollMouse');self.down.add('right');vm.run('Emoji_PollMouse')
        for _ in range(5):vm.run('Emoji_PollMouse')
        self.assertEqual(self.actions,[('emoji',0,False)])

    def test_ping_source_has_no_mouse_move_or_button_polling(self):
        text=source('TeamMapPings.j')
        self.assertNotIn('EVENT_PLAYER_MOUSE_MOVE',text)
        self.assertNotIn('BlzGetMouseScreenPos',text)
        self.assertNotIn('BlzIsMouseButtonPressed',text)
        self.assertNotIn('TMP_PollMouse',text)
        for fn in ['TMP_OnFrame','TMP_OnKey','TMP_OnTargetClick']:
            body=text.split('function '+fn+' ',1)[1].split('endfunction',1)[0]
            self.assertNotIn('CreateTrigger',body);self.assertNotIn('DestroyTrigger',body)
        self.assertIn('call DisableTrigger(TMP_TargetTrigger[pid])',text)

    def test_emoji_mouse_already_held_before_open_is_ignored(self):
        vm=self.emoji();vm.g.update(EmojiPanelOpen={0:True},EmojiRightWasDown=True)
        self.down={'right'};vm.run('Emoji_PollMouse');self.assertFalse(self.actions)
        self.down.clear();vm.run('Emoji_PollMouse');self.down.add('right');vm.run('Emoji_PollMouse')
        self.assertEqual(self.actions,[('emoji',0,False)])

    def cooldown(self):
        vm=JassState(source('ShowCD.j'));g=vm.g;self.local=0;self.slot=-1
        g.update(Player=lambda p:p,GetLocalPlayer=lambda:self.local,AHUI_PingInputInside=defaultdict(bool),
                 AHUI_PingRmbHeld=defaultdict(bool),AHUI_CooldownPingCommandAt=lambda *a:self.slot,
                 BlzIsMouseButtonPressed=self.read,MOUSE_BUTTON_TYPE_RIGHT='right')
        def request(pid,x,y):
            if not g['AHUI_PingRmbHeld'][pid]:self.actions.append(('report',pid))
            g['AHUI_PingRmbHeld'][pid]=True
        def release(pid):g['AHUI_PingRmbHeld'][pid]=False
        g.update(AHUI_RequestCooldownPing=request,AHUI_ReleaseCooldownPing=release)
        return vm

    def test_cooldown_world_and_other_clients_do_not_sample_or_send(self):
        vm=self.cooldown()
        for _ in range(500):vm.run('AHUI_PollCooldownMouse',(0,.5,.5))
        self.local=1;self.slot=0;vm.run('AHUI_PollCooldownMouse',(0,.5,.5))
        self.assertFalse(self.reads);self.assertFalse(self.actions)

    def test_cooldown_enter_held_is_ignored_then_new_press_reports_once(self):
        vm=self.cooldown();self.slot=0;self.down.add('right')
        vm.run('AHUI_PollCooldownMouse',(0,.5,.5));vm.run('AHUI_PollCooldownMouse',(0,.5,.5))
        self.assertFalse(self.actions)
        self.down.clear();vm.run('AHUI_PollCooldownMouse',(0,.5,.5))
        self.down.add('right');vm.run('AHUI_PollCooldownMouse',(0,.5,.5));vm.run('AHUI_PollCooldownMouse',(0,.5,.5))
        self.assertEqual(self.actions,[('report',0)])


if __name__=='__main__':unittest.main()
