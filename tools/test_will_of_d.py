"""Execute Will of D. protection, dispel, cooldown and effect cleanup paths."""
from pathlib import Path
import json,re,unittest
from test_crocodile import JassState

ROOT=Path(__file__).resolve().parents[1]

class WillOfD(unittest.TestCase):
    def fixture(self, delayed=False):
        source=(ROOT/'triggers/Items/Items.j').read_text(encoding='utf-8-sig')
        struct=re.search(r'    private struct ItemsAnimeEffect\b.*?    endstruct',source,re.S)[0]
        funcs='\n'.join(re.search(r'(?m)^\s*(?:private )?function '+n+r' takes.*?endfunction',source,re.S)[0] for n in ('ItemsAnime_FinalDamage','KairosekiStart','ItemsAnime_RoundEnd'))
        vm=JassState(re.sub(r'(?<![\w.\]])\.(?=[A-Za-z_])','this.',struct+'\n'+funcs))
        ns=vm.structs['ItemsAnimeEffect']
        ns.statics.update(KIND_SUKUNA=1,KIND_SEAL=2,KIND_COFFIN=3,KIND_RETURN=4,KIND_WILL=5,KIND_SPEAR=6,list={},count=0,clock=None)
        cd=[]
        vm.g.update(hs={},SH_WILL_OF_D_END='will end',HealRegenClock=None,
            WillOfD_ID=1,WillOfD_CD_ID=2,WillOfD_BuffAbi_ID=3,WillOfD_Buff_ID=4,
            WillOfD_Duration=3.,WillOfD_CD=70.,Kairoseki_Buff_ID=5,Tekkai_Buff_ID=6,
            NaofumiShieldEvolved_ID=7,CurrentRound=1,
            HasCachedItem=lambda u,i:int(i==1),IsUnitType=lambda u,t:(u.life>.405 if t=='UNIT_TYPE_HERO' else u.life<=.405),
            TimerStart=lambda *_:None,PauseTimer=lambda *_:None,
            BlzGetUnitAbilityCooldownRemaining=lambda u,_:u.cooldown,
            BlzStartUnitAbilityCooldown=lambda u,_,s:(setattr(u,'cooldown',s),cd.append(s)),
            BlzEndUnitAbilityCooldown=lambda u,_:setattr(u,'cooldown',0.),
            BuffUnit01=lambda c,u,*_:None if delayed else vm.add_ability(u,4),
            UnitRemoveBuffs=lambda u,*_:vm.remove_ability(u,4),
            SpellBool=lambda u:u.life>.405,DebuffImmune_Start=lambda *_:0)
        c,u=vm.unit(owner=1),vm.unit(owner=0)
        return vm,ns,c,u,cd

    def hit(self,vm,c,u,amount=200.):
        return vm.run('ItemsAnime_FinalDamage',(c,u,amount,1,False))

    def test_lethal_hit_starts_70_second_cooldown_and_keeps_one_hp(self):
        vm,ns,c,u,cd=self.fixture()
        self.assertEqual(99.,self.hit(vm,c,u))
        self.assertEqual([70.],cd)
        u.life=1.;vm.elapsed=1.
        self.assertEqual(0.,self.hit(vm,c,u))
        self.assertEqual(1,ns.count)

    def test_kairoseki_ends_protection_immediately_and_cleans_visual_next_tick(self):
        for when in (.05,1.,2.99):
            vm,ns,c,u,cd=self.fixture()
            self.hit(vm,c,u);u.life=1.;vm.elapsed=when
            vm.run('KairosekiStart',(c,u))
            self.assertEqual(200.,self.hit(vm,c,u))
            vm.run('Tick')
            self.assertEqual(0,ns.count)
            self.assertFalse(vm.effects)
            self.assertEqual([70.],cd)

    def test_other_positive_dispel_cannot_leave_an_invisible_immortality_timer(self):
        vm,ns,c,u,_=self.fixture()
        self.hit(vm,c,u);u.life=1.;vm.elapsed=1.
        vm.remove_ability(u,4)
        self.assertEqual(200.,self.hit(vm,c,u))
        vm.run('Tick')
        self.assertEqual(0,ns.count)

    def test_initial_dummy_cast_window_is_protected_but_kairoseki_still_cancels(self):
        vm,ns,c,u,_=self.fixture(delayed=True)
        self.hit(vm,c,u);u.life=1.;vm.elapsed=.05
        self.assertEqual(0.,self.hit(vm,c,u))
        vm.run('KairosekiStart',(c,u))
        # Even if a queued native dummy applies its buff afterwards, no rearm.
        vm.add_ability(u,4)
        self.assertEqual(200.,self.hit(vm,c,u))

    def test_expiry_and_round_reset_remove_old_protection(self):
        vm,ns,c,u,_=self.fixture()
        self.hit(vm,c,u);u.life=1.;vm.elapsed=3.
        vm.run('Tick')
        self.assertEqual(0,ns.count)
        self.assertFalse(vm.effects)
        self.assertEqual(200.,self.hit(vm,c,u))
        vm.g['Hero']={i:u if i==0 else None for i in range(10)}
        vm.run('ItemsAnime_RoundEnd')
        self.assertEqual(0.,u.cooldown)

    def test_item_and_native_cooldown_descriptions_match_runtime(self):
        abilities=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
        items=json.loads((ROOT/'object-data/items.json').read_text(encoding='utf-8-sig'))
        self.assertEqual(70.,abilities['A138']['cooldown level 1'])
        for field in ('description','extended_tooltip'):
            text=items['I056'][field]
            self.assertIn('70 sec',text)
            self.assertIn('Kairoseki Cuffs',text)
            self.assertIn('Dispellable',text)

if __name__=='__main__':unittest.main()
