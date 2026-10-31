"""Execute round purchase gates, survivor portraits and Patriot timer cleanup.

Native engine rendering and networking are not emulated.
"""
from collections import defaultdict
from pathlib import Path
import re
import unittest

from test_crocodile import JassState
from test_item_shop_followup import function
import test_quickbuy_fix4 as quick_fixture
from test_wos_ui import load_source

ROOT = Path(__file__).resolve().parents[1]


def source(name):
    return (ROOT/'triggers'/name).read_text(encoding='utf-8-sig')


class RoundPurchases(unittest.TestCase):
    def setUp(self):
        fixture = quick_fixture.Fix4('runTest')
        fixture.setUp()
        self.fixture = fixture
        self.vm = fixture.vm
        self.u = fixture.units[0]

    def test_quick_buy_waits_during_normal_combat_and_resumes_in_prep(self):
        self.fixture.goals([3])
        self.vm.g.update(CondArena=1, TestMode=False)
        self.fixture.tick(3)
        self.assertEqual([], self.fixture.adds)
        self.assertEqual(3000, self.fixture.gold[0])
        self.vm.g['CondArena'] = 0
        self.fixture.tick(3)
        self.assertEqual([(0, 1), (0, 2), (0, 3)], self.fixture.adds)
        self.assertEqual(2650, self.fixture.gold[0])

    def test_direct_automatic_purchase_entry_points_cannot_spend_in_combat(self):
        self.vm.g.update(CondArena=1, TestMode=False, UsedSlot=defaultdict(bool))
        self.vm.run('BuyAuto', (self.u, 3))
        self.assertEqual(4, self.vm.run('BuyAutoLimited', (self.u, 3, 4)))
        self.assertEqual(1, self.vm.run('QB_BuyWhole', (0, self.u, 3, 350)))
        self.assertEqual([], self.fixture.adds)
        self.assertEqual(3000, self.fixture.gold[0])

    def test_test_mode_can_purchase_during_combat_outside_base(self):
        self.fixture.goals([3])
        self.u['base'] = False
        self.vm.g.update(CondArena=1, TestMode=True)
        self.assertTrue(self.vm.run('ShopCanPurchase', (self.u,)))
        self.fixture.tick(3)
        self.assertEqual([(0, 1), (0, 2), (0, 3)], self.fixture.adds)
        self.assertEqual(2650, self.fixture.gold[0])

    def test_buy_and_fast_buy_buttons_follow_round_gate(self):
        vm=JassState(function(source('WOS_Start/WoS_Shop_Init.j'),'AutoBuyPeriodic'))
        enabled, visible = {}, {}
        vm.g.update(GetLocalPlayer=lambda:0,GetPlayerId=lambda p:p,
            FRAME_ShopItemInventorySlot={6:'buy'}, FRAME_FastBuyToggle='fast',
            BlzFrameSetEnable=lambda f,v:enabled.update({f:v}),
            BlzFrameSetVisible=lambda f,v:visible.update({f:v}),
            PlayerInventoryPeriodic=lambda:None,ShopRefreshGoldLabel=lambda *_:None,
            QB_ApplyHeroRequests=lambda:None,QB_RunDeferredFirst=lambda:None,
            IsActivePlayerSlot=lambda _:False,QB_RenderLocal=lambda:None)
        for arena,test_mode,allowed in ((1,False,False),(0,False,True),(1,True,True)):
            vm.g.update(CondArena=arena,TestMode=test_mode)
            vm.run('AutoBuyPeriodic')
            self.assertEqual(allowed,enabled['buy'])
            self.assertEqual(allowed,enabled['fast'])
            if not allowed:self.assertFalse(visible['buy'])

    def test_live_one_hp_hero_can_purchase_in_prep_but_corpse_cannot(self):
        self.u['life'] = 1.
        self.assertTrue(self.vm.run('ShopCanPurchase', (self.u,)))
        self.u['dead'] = True
        self.assertFalse(self.vm.run('ShopCanPurchase', (self.u,)))
        self.assertFalse(self.vm.run('ShopCanPurchase', (None,)))

    def test_fast_double_click_during_combat_never_becomes_a_buy_command(self):
        g = self.vm.g
        g.update(CondArena=1, ShopFastBuy={0: True}, ShopLastClickItem={0: 3},
                 ShopLastClickCode={0: 200}, ShopLastClickTime={0: 0.},
                 TimerGetElapsed=lambda _: .1, ShopClock='clock')
        self.assertEqual(200, self.vm.run('ShopFastAction', (0, 200, 3)))
        self.assertEqual(0, g['ShopLastClickItem'][0])

    def test_manual_purchase_uses_the_same_gate_and_opening_buy_precedes_combat(self):
        text = source('WOS_Start/WoS_Shop_Init.j')
        self.assertIn('frameCode == 306 and not IsObserverSlot(pid) and ShopCanPurchase(d)', function(text, 'OnClickItem'))
        pick = source('WOS_Start/WoS_Pick_Init.j')
        branch = pick.split('if TimeMove == TimeRound then', 1)[1]
        self.assertLess(branch.index('call ShopForceFirstRoundAutoBuy()'), branch.index('set CondArena = 1'))


class SurvivalUI(unittest.TestCase):
    def test_one_hp_survivor_keeps_normal_portrait_and_visible_hp_sliver(self):
        vm = load_source('WoS_Hero_Icons_Init.j')
        u = vm.unit(owner=0)
        u.life = 1.
        values, textures, alphas = {}, {}, {}
        vm.g.update(Hero={0:u}, CaptainMode=False, CapPickPhase=2, Leave={0:0},
            GetLocalPlayer=lambda:0, IsPlayerAlly=lambda *_:True, IsUnitVisible=lambda *_:True,
            IsUnitType=lambda *_:False, GetUnitTypeId=lambda _:1,
            GetWidgetLife=lambda u:u.life, BlzGetUnitMaxHP=lambda _:10000,
            GetUnitState=lambda *_:100., BlzGetUnitMaxMana=lambda _:100,
            StatusHpBar={0:'hp'}, StatusMpBar={0:'mp'}, StatusLeaveCover={0:'cover'},
            FRAME_StatusHeroBack={0:'portrait'}, FRAME_StatusHeroBack2={0:'portrait2'},
            StatusSlotInitialized={0:True}, StatusLastHeroType={0:1}, StatusLastDead={0:True},
            StatusLastLeave={0:0}, StatusLastVisible={0:True}, FRAME_StatusHeroStringIcon={0:'hero-icon'},
            WUI_SetValue=lambda f,v:values.update({f:v}), WUI_Show=lambda *_:None,
            BlzFrameSetTexture=lambda f,v,*_:textures.update({f:v}),
            BlzFrameSetVisible=lambda *_:None,
            BlzFrameSetAlpha=lambda f,v:alphas.update({f:v}))
        vm.run('UpdateStatusHeroSlotOptimized', (0,))
        self.assertEqual('hero-icon', textures['portrait'])
        self.assertEqual(2., values['hp'])
        self.assertEqual(255, alphas['hp'])
        self.assertFalse(vm.g['StatusLastDead'][0])
        self.assertEqual(1., u.life)

    def test_spell_damage_reaches_one_hp_survivor_but_not_a_corpse(self):
        names = ('dmgmag', 'dmgmag2', 'dmgphys', 'dmgphysattack', 'dmgatk', 'spelldmg')
        text = source('Systems/Systems2.j')
        vm = JassState('\n'.join(function(text, n) for n in names))
        c, target = vm.unit(), vm.unit()
        calls = []
        vm.g.update(UnitDamageTarget=lambda *args:calls.append(args),
                    GearDamageActiveSource=0, GearDamageNextSource=0, GearDamageAttackFollowup=False,
                    ATTACK_TYPE_MAGIC=1, ATTACK_TYPE_NORMAL=2, ATTACK_TYPE_MELEE=3,
                    DAMAGE_TYPE_NORMAL=1, DAMAGE_TYPE_FIRE=2, DAMAGE_TYPE_UNIVERSAL=3)
        for life in (1., .4):
            target.life = life
            before = len(calls)
            for name in names:
                args=(c,target,100.,'other') if name=='dmgmag2' else (c,target,100.)
                vm.run(name,args)
            self.assertEqual(6 if life==1. else 0, len(calls)-before)


class PatriotExpiry(unittest.TestCase):
    def test_early_death_is_not_killed_or_announced_twice_and_cleanup_still_runs(self):
        body=source('Heroes/Patriot.j').split('    private struct PatriotSpells_E\n',1)[1].split('    endstruct',1)[0]
        vm=JassState('    private struct PatriotSpells_E\n'+body+'    endstruct')
        ns=vm.structs['PatriotSpells_E']
        ns.statics.update(m_PatriotE={}, MUI_PatriotE=-1)
        for alive in (False, True):
            c=vm.unit(owner=0)
            c.life=1. if alive else 0.
            fx=vm.allocate(ns)
            fx.deallocate=lambda *_:setattr(fx,'alive',False)
            fx.c=c;fx.td=None;fx.id=1;fx.id2=0;fx.r=6.;fx.rmax=5.;fx.e2=vm.effect('revival')
            ns.m_PatriotE[0]=fx;ns.MUI_PatriotE=0
            killed=[];messages=[];cleared=[];released=[]
            vm.g.update(SpellBoolCaster=lambda u:u.life>.405,
                IsUnitType=lambda u,_:u.life<=.405,
                PlayersMsg=lambda *a:messages.append(a), KillUnit=lambda u:killed.append(u),
                Player=lambda i:i, GetPlayerName=lambda i:str(i), GetPlayerVisualColorString=lambda _:'',
                WUI_HeroProgress=lambda *_:None, Patriot_SetStance=lambda *a:cleared.append(a),
                hs={}, PatriotE_ID=1, SH_PATRIOT_EE='patriot ee', PatriotTimer03Release=lambda:released.append(True))
            vm.run('Loop_PatriotE')
            self.assertEqual(int(alive),len(killed))
            self.assertEqual(int(alive),len(messages))
            self.assertEqual([(c,False)],cleared)
            self.assertEqual([True],released)
            self.assertFalse(fx.alive)


if __name__=='__main__':
    unittest.main()
