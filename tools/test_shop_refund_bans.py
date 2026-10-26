"""Execute MAIN refund and ban production functions; native input still needs game QA."""
from collections import defaultdict
import unittest

from test_wos_ui import load_source


class LocalInventoryPricing(unittest.TestCase):
    def test_inventory_price_is_read_before_the_local_render_block(self):
        # The first GetItemValue of a type creates and sells a pricing item; on one
        # client only (inside GetLocalPlayer) that desynced the round-end shop.
        import re
        from pathlib import Path
        src = (Path(__file__).resolve().parents[1] / 'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8')
        body = re.search(r'function PlayerInventoryPeriodic takes.*?\nendfunction', src, re.S).group(0)
        cell = body.index('set cacheIndex = pid * 6 + slot')
        local = body.index('if GetLocalPlayer() == p then', cell)
        self.assertIn('GetItemValue(id)', body[cell:local])
        self.assertNotIn('GetItemValue(', body[local:])


class RefundWindow(unittest.TestCase):
    def setUp(self):
        self.vm = load_source('WoS_Shop_Init.j')
        self.now = 0.0
        self.hero = {'uid': 1, 'owner': 0, 'inv': [101, None, None, None, None, None]}
        self.types = {101: 1, 102: 1, 103: 2, 104: 3}
        self.prices = {1: 1000, 2: 2000, 3: 3000}
        self.gold = defaultdict(int)
        self.g = g = self.vm.g
        g.update(ShopRefundData={}, ShopClock='clock', Refund100Time=15.0, RefundPercent=85,
                 TimerGetElapsed=lambda _: self.now, GetHandleId=lambda u: u['uid'],
                 UnitItemInSlot=lambda u, s: u['inv'][s],
                 GetItemTypeId=lambda it: self.types.get(it, 0),
                 UnitHasItem=lambda u, it: it in u['inv'],
                 LoadItemHandle=lambda t, u, k: t.get((u, k)),
                 SaveItemHandle=lambda t, u, k, it: t.update({(u, k): it}),
                 RemoveSavedHandle=lambda t, u, k: t.pop((u, k), None),
                 GetOwningPlayer=lambda u: u['owner'],
                 GetItemValue=lambda kind: self.prices[kind],
                 IsItemInInventory3=lambda u, kind: next((i for i, it in enumerate(u['inv'])
                     if it is not None and self.types[it] == kind), -1),
                 RemoveItem=lambda it: self.hero['inv'].__setitem__(self.hero['inv'].index(it), None),
                 AddGold=lambda p, amount, credit: self.gold.__setitem__(p,
                     self.gold[p] + (amount if credit else -amount)))
        # The shared UI fixture suppresses purchase marks; these tests execute the real one.
        g['ShopMarkFullRefund'] = lambda *args: self.vm.run('ShopMarkFullRefund', args)

    def mark(self, kind=1, paid=1000):
        self.vm.run('ShopMarkFullRefund', (self.hero, kind, paid))

    def full(self, slot=0):
        return self.vm.run('ShopFullRefundRecord', (self.hero, self.hero['inv'][slot])) != -1

    def sell(self, slot=0):
        before = self.gold[0]
        self.assertTrue(self.vm.run('ShopSellInventorySlot', (0, self.hero, slot)))
        return self.gold[0] - before

    def test_test_controller_can_sell_selected_enemy_and_ally_test_heroes(self):
        enemy={'uid':7,'owner':6,'inv':[102,None,None,None,None,None]}
        ally={'uid':8,'owner':1,'inv':[103,None,None,None,None,None]}
        selected=[enemy]
        units=[self.hero,enemy,ally]
        def remove(it):
            unit=next(u for u in units if it in u['inv'])
            unit['inv'][unit['inv'].index(it)]=None
        self.g.update(TestMode=True,TestUnit=enemy,TestAllyUnit=ally,TestUnitController=0,TestAllyUnitController=0,
                      GetSelectedHeroForPlayer=lambda p:selected[0],RemoveItem=remove)
        self.assertTrue(self.vm.run('ShopSellInventorySlot',(0,enemy,0)))
        self.assertEqual(850,self.gold[0])
        self.assertEqual(0,self.gold[6])
        self.assertIsNone(enemy['inv'][0])
        self.assertEqual(101,self.hero['inv'][0])
        selected[0]=ally
        self.assertTrue(self.vm.run('ShopSellInventorySlot',(0,ally,0)))
        self.assertEqual(2550,self.gold[0])
        self.assertIsNone(ally['inv'][0])

    def test_test_sale_rejects_disabled_mode_other_controller_or_unselected_unit(self):
        enemy={'uid':7,'owner':6,'inv':[102,None,None,None,None,None]}
        self.g.update(TestMode=False,TestUnit=enemy,TestAllyUnit=None,TestUnitController=0,TestAllyUnitController=None,
                      GetSelectedHeroForPlayer=lambda p:enemy)
        self.assertFalse(self.vm.run('ShopSellInventorySlot',(0,enemy,0)))
        self.g.update(TestMode=True,TestUnitController=1)
        self.assertFalse(self.vm.run('ShopSellInventorySlot',(0,enemy,0)))
        self.g.update(TestUnitController=0,GetSelectedHeroForPlayer=lambda p:self.hero)
        self.assertFalse(self.vm.run('ShopSellInventorySlot',(0,enemy,0)))
        self.assertEqual(102,enemy['inv'][0])
        self.assertEqual(0,self.gold[0])

    def test_green_item_sells_for_full_value_until_deadline(self):
        self.mark()
        self.now = 14.99
        self.assertTrue(self.full())
        self.assertEqual(1000, self.sell())
        self.assertFalse(self.g['ShopRefundData'])

    def test_rendered_green_price_and_sale_use_the_same_live_refund_record(self):
        texts = {}
        self.g.update(Hero=defaultdict(lambda: None, {0: self.hero}),
                      GetLocalPlayer=lambda: 0, IsActivePlayerSlot=lambda p: p == 0,
                      GetSelectedHeroForPlayer=lambda p: self.hero,
                      ShopGetInventoryItemId=lambda u, slot: self.types.get(u['inv'][slot], 0),
                      WUI_TEXT='', GetObjectName=lambda _: 'item', BlzGetAbilityIcon=lambda _: 'icon',
                      ShopPricePlateWidth=lambda _: .02, ShopGetItemTooltipWidth=lambda _: .1,
                      QB_InventorySize=.03, BlzFrameSetText=lambda f, text: texts.update({f: text}),
                      BlzFrameSetSize=lambda *_: None, BlzFrameSetVisible=lambda *_: None,
                      BlzFrameSetEnable=lambda *_: None, BlzFrameSetTexture=lambda *_: None)
        self.g['Shop_Active'][0] = True
        self.g['ShopTargetUnitId'][0] = 1
        self.mark()
        self.vm.run('PlayerInventoryPeriodic')
        frame = self.g['FRAME_ShopItemInventorySlotCost'][0]
        self.assertEqual('|c0000FF001000|r', texts[frame])
        self.assertEqual(1000, self.sell())

    def test_renderer_switches_to_regular_price_at_the_same_deadline_as_sale(self):
        self.test_rendered_green_price_and_sale_use_the_same_live_refund_record()
        self.hero['inv'][0] = 102
        self.mark()
        self.now = 15.0
        texts = {}
        self.g['BlzFrameSetText'] = lambda f, text: texts.update({f: text})
        self.vm.run('PlayerInventoryPeriodic')
        self.assertEqual('|c00FFFF00850|r', texts[self.g['FRAME_ShopItemInventorySlotCost'][0]])
        self.assertEqual(850, self.sell())

    def test_expired_item_uses_configured_regular_refund(self):
        self.mark()
        self.now = 15.0
        self.assertFalse(self.full())
        self.assertEqual(850, self.sell())

    def test_rebuy_same_slot_has_its_own_fifteen_seconds(self):
        self.mark()
        self.now = 10.0
        self.sell()
        self.hero['inv'][0] = 102
        self.mark()
        self.now = 15.01
        self.assertTrue(self.full())
        self.assertEqual(1000, self.sell())

    def test_refund_follows_item_when_inventory_slots_are_swapped(self):
        self.hero['inv'][1] = 103  # Old item, no full refund.
        self.mark()
        self.hero['inv'][0], self.hero['inv'][1] = 103, 101
        self.assertFalse(self.full(0))
        self.assertTrue(self.full(1))
        self.assertEqual(1700, self.sell(0))
        self.assertEqual(1000, self.sell(1))

    def test_same_type_replacement_cannot_inherit_green_mark(self):
        self.mark()
        self.hero['inv'][0] = 102
        self.assertFalse(self.full())
        self.assertEqual(850, self.sell())

    def test_fresh_craft_components_preserve_full_refund_and_are_cleared(self):
        self.mark()
        self.hero['inv'][1] = 103
        self.mark(2, 2000)
        self.g.update(GetCraftComponentCount=lambda kind: 2 if kind == 3 else 0,
                      GetCraftComponent=lambda kind, index: index + 1,
                      GetItemCharges=lambda _: 0)
        self.assertEqual(0, self.vm.run('CheckItemsReduceCostCraft', (self.hero, 3000, 3, True)))
        self.assertEqual(3000, self.g['ShopCraftRefundCredit'])
        self.assertFalse(self.g['ShopRefundData'])
        self.hero['inv'][0] = 104
        self.mark(3, 0)
        self.assertTrue(self.full())
        self.assertEqual(3000, self.sell())

    def test_old_component_does_not_give_full_refund_to_cheap_upgrade(self):
        self.g['ShopCraftRefundCredit'] = 1000
        self.hero['inv'][0] = 104
        self.mark(3, 0)
        self.assertFalse(self.full())
        self.assertEqual(2550, self.sell())

    def test_normal_autobuy_marks_each_component_and_the_crafted_result(self):
        self.hero['inv'] = [None] * 6
        self.gold[0] = 3000
        def deliver(u, kind):
            handle = {1: 101, 2: 103, 3: 104}[kind]
            u['inv'][u['inv'].index(None)] = handle
        self.g.update(GetGold=lambda p: self.gold[p],
                      IsItemInInventory=lambda u, kind: sum(self.types.get(it) == kind for it in u['inv']),
                      GetCraftComponentCount=lambda kind: 2 if kind == 3 else 0,
                      GetCraftComponent=lambda kind, index: index + 1,
                      AutoBuyComponent=lambda kind, index: index + 1,
                      AutoBuyNeedsBoots=lambda *_: False, CheckSlotAvailable=lambda u: None in u['inv'],
                      ShopDeliverPurchase=deliver, StartSoundForPlayerBJ=lambda *_: None,
                      gg_snd_AlchemistTransmuteDeath1='buy-sound')
        self.vm.run('BuyAuto', (self.hero, 3))
        self.assertEqual(0, self.gold[0])
        self.assertTrue(self.full())
        self.assertEqual(3000, self.sell())

    def test_six_records_survive_reordering_and_repeated_purchase_cycles(self):
        for n in range(6):
            self.types[200+n] = n+10
            self.prices[n+10] = 100
        self.hero['inv'] = list(range(200, 206))
        for kind in range(10, 16):
            self.mark(kind, 100)
        self.hero['inv'].reverse()
        self.assertTrue(all(self.full(slot) for slot in range(6)))
        for _ in range(20):
            for slot in range(6):
                item = self.hero['inv'][slot]
                self.assertEqual(100, self.sell(slot))
                self.hero['inv'][slot] = item
                self.mark(self.types[item], 100)
            self.assertEqual(12, len(self.g['ShopRefundData']))


class BanInput(unittest.TestCase):
    def setUp(self):
        self.vm = load_source('WoS_Pick_Init.j')
        self.g = g = self.vm.g
        self.messages = []
        self.refreshes = []
        self.focus = []
        self.notices = []
        self.enabled = []
        g.update(IsObserverSlot=lambda p: p >= 10, PickPhaseActive=False,
                 BanPhaseActive=False, BanPhaseTriggered=False, BanImmuneHero1=99, PrePickTime=20,
                 BanImmuneHero2=0, BanImmuneHero3=0,
                 CanPickRandom=0, TestMode=False, CaptainDraftMode=False, FRAME_BanLockNotice='notice',
                 BlzFrameSetText=lambda frame, text: self.notices.append((frame, text)),
                 BlzFrameSetVisible=lambda *_: None,
                 BlzFrameSetEnable=lambda frame, on: self.enabled.append((frame, on)),
                 BlzFrameSetTexture=lambda *_: None,
                 IsHeroAvailableForPick=lambda kind: kind in (1, 2, 3),
                 MakeSoundLocal=lambda *_: None, UpdateBanProposalSlot=lambda p: None,
                 RefreshAllPlayersHeroPage=lambda: self.refreshes.append(True),
                 DisplayTimedTextToPlayer=lambda p, x, y, duration, message:
                     self.messages.append((p, message)))

    def click(self, player, kind):
        self.g['PlayerFrameCurrent_ID'][player] = kind
        self.vm.run('WOS_ProposeHeroBan', (player,))

    def test_all_ten_players_can_propose_replace_and_cancel_before_cutoff(self):
        for player in range(10):
            self.g['BanProposalHero'].clear()
            self.vm.run('WOS_LockBanSelection', (4,))
            self.click(player, 1)
            self.assertEqual(1, self.g['BanProposalHero'][player])
            self.click(player, 2)
            self.assertEqual(2, self.g['BanProposalHero'][player])
            self.click(player, 2)
            self.assertEqual(0, self.g['BanProposalHero'][player])
        self.assertFalse(self.messages)

    def test_three_second_cutoff_blocks_changes_and_cancellation_for_every_player(self):
        for player in range(10):
            self.g['BanProposalHero'][player] = 1
        for remaining in (3, 2, 1):
            self.vm.run('WOS_LockBanSelection', (remaining,))
            for player in range(10):
                self.click(player, 2)
                self.click(player, 1)
                self.assertEqual(1, self.g['BanProposalHero'][player])
        self.assertEqual(1, len(self.notices))
        self.assertIn('3 SECONDS LEFT', self.notices[0][1])
        self.assertIn('cannot be changed or cancelled', self.notices[0][1])
        self.assertIn((self.g['FRAME_Pick'][4], False), self.enabled)

    def test_empty_player_can_submit_once_after_lock_then_cannot_change(self):
        self.vm.run('WOS_LockBanSelection', (3,))
        self.click(0, 1)
        self.assertEqual(1, self.g['BanProposalHero'][0])
        self.assertIn((self.g['FRAME_Pick'][4], False), self.enabled)
        self.click(0, 2)
        self.assertEqual(1, self.g['BanProposalHero'][0])

    def test_lock_is_not_announced_during_other_modes_or_after_phase(self):
        self.vm.run('WOS_LockBanSelection', (0,))
        for flag in ('PickPhaseActive', 'BanPhaseActive', 'BanPhaseTriggered', 'TestMode', 'CaptainDraftMode'):
            self.g[flag] = True
            self.vm.run('WOS_LockBanSelection', (3,))
            self.g[flag] = False
        self.g['CanPickRandom'] = 1
        self.vm.run('WOS_LockBanSelection', (3,))
        self.assertFalse(self.notices)
        self.assertFalse(self.g['BanSelectionLocked'])

    def test_notice_uses_top_left_root_anchor_and_never_intercepts_input(self):
        points = []
        self.g.update(WUI_GetRoot=lambda: 'root',
                      BlzCreateFrameByType=lambda *_: 'notice',
                      BlzFrameSetPoint=lambda *args: points.append(args),
                      BlzFrameSetSize=lambda *_: None, BlzFrameSetTextAlignment=lambda *_: None,
                      BlzFrameSetScale=lambda *_: None, BlzFrameSetLevel=lambda *_: None,
                      FRAMEPOINT_TOPLEFT='top-left', TEXT_JUSTIFY_TOP='top', TEXT_JUSTIFY_LEFT='left')
        self.vm.run('WOS_CreateBanLockNotice')
        self.assertEqual([('notice', 'top-left', 'root', 'top-left', .012, -.035)], points)
        self.assertIn(('notice', False), self.enabled)

    def test_two_players_racing_for_same_hero_get_feedback_and_can_retry(self):
        self.click(0, 1)
        self.click(1, 1)
        self.assertEqual(1, self.g['BanProposalHero'][0])
        self.assertEqual(0, self.g['BanProposalHero'][1])
        self.assertIn('Another player', self.messages[-1][1])
        self.click(1, 2)
        self.assertEqual(2, self.g['BanProposalHero'][1])
        self.click(0, 1)
        self.click(1, 1)
        self.assertEqual(1, self.g['BanProposalHero'][1])

    def test_invalid_protected_or_missing_selection_keeps_existing_proposal(self):
        self.click(0, 1)
        for kind in (0, 12, 99, 10):
            self.click(0, kind)
            self.assertEqual(1, self.g['BanProposalHero'][0])
        self.assertEqual(4, len(self.messages))

    def test_observers_and_actual_phase_transition_reject_gameplay(self):
        self.click(12, 1)
        self.assertEqual(0, self.g['BanProposalHero'][12])
        for flag in ('BanPhaseTriggered', 'BanPhaseActive', 'PickPhaseActive'):
            self.g[flag] = True
            self.click(0, 1)
            self.assertEqual(0, self.g['BanProposalHero'][0])
            self.g[flag] = False
        self.assertFalse(self.refreshes)

    def test_ban_uses_same_button_focus_reset_as_confirm_and_random(self):
        self.g.update(BlzGetTriggerFrame=lambda: self.g['FRAME_Pick'][4],
                      WUI_ResetClickedButtonFocus=lambda: self.focus.append('reset'),
                      WUI_ReleaseClickFocus=lambda: self.focus.append('release'))
        self.vm.run('WOS_FinishPickerClick')
        self.assertEqual(['reset'], self.focus)


if __name__ == '__main__':
    unittest.main()
