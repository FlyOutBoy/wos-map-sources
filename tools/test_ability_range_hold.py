"""Exercise the shared instant-area source and saved hold channel, without a game."""
from pathlib import Path
import json,re,unittest
from types import SimpleNamespace
from test_crocodile import JassState
from prepare_ability_range_test import integrate_utb
from prepare_ability_range_hold_test import upgrade_utb,channel_ids,upgrade_wui

ROOT=Path(__file__).resolve().parents[1]


class AreaSource(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        s=(ROOT/'triggers/WOS_Start/UniversalTooltips.j').read_text(encoding='utf-8-sig')
        if 'function GetDisplayedRange' not in s:s=integrate_utb(s)
        if 'function GetPreviewRadius' not in s:s=upgrade_utb(s,channel_ids(ROOT))
        cls.source=s

    def setUp(self):
        names='ReadCastRange|ReadHeroCastRange|GetPreviewRadius|ReadMechanicRadius|HasAreaImpact|PreviewMechanic|ResolveLevelTags|GetListElement|StringReplace|T_Rad'
        text='\n'.join(re.findall(r'(?m)^\s*(?:private|public) function (?:'+names+r') takes[^\n]*\n[\s\S]*?^\s*endfunction',self.source))
        rules=(ROOT/'test_map/ability_range/HeroRangeRules.j').read_text()
        self.vm=JassState(text+'\n'+rules);self.level=1;self.heroLevel=1;self.targetType=0;self.castRange=800
        for name in re.findall(r'abilId == (\w+)',rules):self.vm.g[name]=name
        self.data=SimpleNamespace(abilId=123,previewChannel=True,previewDirected=False,mecha='|cffffcc00Radius:|r 600|n',bonus='',statBase=2.0,statStep=0.0,staticBase=0.0,staticStep=0.0,statBase2=0.0,statStep2=0.0,staticBase2=0.0,staticStep2=0.0)
        self.registered=True
        self.abilityId=123;self.hs={}
        self.vm.g.update({'HT_DATA':{},'GetUnitAbilityLevel':lambda u,a:self.level,
            'GetHeroLevel':lambda h:self.heroLevel,'GetHandleId':lambda h:7,
            'LoadInteger':lambda ht,p,c:self.hs.get((p,c),0) if ht is self.hs else 0 if c==8888 or not self.registered else self.data,
            'BlzGetUnitAbility':lambda *a:'ability',
            'BlzGetAbilityRealLevelField':lambda *a:self.castRange,
            'BlzGetAbilityIntegerLevelField':lambda *a:self.targetType,
            'ABILITY_ILF_TARGET_TYPE':'type','ABILITY_RLF_CAST_RANGE':'range',
            'S2R':lambda s:float(s) if s else 0.0,'S2I':lambda s:int(s) if s.lstrip('-').isdigit() else 0,
            'StringCase':lambda s,upper:s.upper() if upper else s.lower(),
            'StringLength':len,'SubString':lambda s,a,b:s[max(0,a):max(0,b)],
            'I2S':lambda n:str(int(n)),'R2I':int,
            'InoriR_ID':999,'InoriR_HealAoe':1000.0,'InoriR_HealAoeAdd':250.0,
            'GojoR_ID':998,'GojoR_DamageAoe':900.0,'GojoR_35lvl_AddAoe':150.0,
            'InoriT_ID':997,'InoriT_DamageAoe':1400.0,'InoriT_DamageMaxAoe':2000.0,
            'TsunaW2_ID':996,'TsunaW_DamageAoe':100.0,'TsunaW_DamageAoeAdd':110.0,
            'T_RadExp':lambda a,b:f'|cffffcc00Radius:|r {int(a)} (Explosion {int(b)})|n',
            'StarrkQ_ID':1001,'StarrkQ_RangeBase':1300.0,'StarrkQ_RangeStep':100.0,
            'StarrkEQ_RangeBonus':100.0,'hs':self.hs,'StringHash':lambda s:s,
            'DarkShikiT_ID':'DarkShikiT_ID',
            'ARules_GetImpactReach':lambda h,a,l,r,p:r,  # This suite isolates instant-vs-directed source selection.
            'GetOwningPlayer':lambda h:0})

    def radius(self):return self.vm.run('GetPreviewRadius',('hero',self.abilityId))

    def test_instant_damage_uses_radius_instead_of_default_channel_cast_range(self):
        self.assertEqual(self.radius(),600)
        self.data.previewDirected=True;self.assertEqual(self.radius(),800)

    def test_self_heals_no_area_no_circle_and_area_heal_is_visible(self):
        self.data.statBase=0;self.data.mecha='Heal: Intelligence x 3 over 3 sec'
        self.assertEqual(self.radius(),0)
        self.data.mecha='|cffffcc00Radius:|r 1000|nHeals allies in the area'
        self.assertEqual(self.radius(),1000)

    def test_real_utility_areas_include_mana_shield_restore_and_resistance(self):
        self.data.statBase=0;self.data.mecha='Radius: 600|n'
        self.data.bonus='Grants nearby allies armor and heals 50 HP'
        self.assertEqual(self.radius(),600)
        self.data.bonus='Base Damage: Agility x 3'
        self.assertEqual(self.radius(),600)
        self.data.bonus='Restores 10% Mana. Grants Damage Immunity.'
        self.assertEqual(self.radius(),600)

    def test_level_tags_form_radius_decimal_and_nonimpact_area(self):
        self.data.mecha='Radius: <L:250/375/500/625/750>|n'
        self.level=3;self.assertEqual(self.radius(),500)
        self.data.mecha='Radius: 600.5 (Explosion 900)|n';self.assertEqual(self.radius(),900)
        self.data.statBase=0;self.data.mecha='Radius: 600|nSlows enemies'
        self.assertEqual(self.radius(),600)

    def test_inori_radius_bonus_is_shared_with_tooltip(self):
        self.data.abilId=999;self.data.statBase=0
        self.data.mecha='|cffffcc00Radius:|r 1000|nHeals allies'
        self.assertEqual(self.radius(),1000)
        self.heroLevel=35;self.assertEqual(self.radius(),1250)
        self.assertIn('builder.addMechanic(PreviewMechanic(hero, data, lvl))',self.source)

    def test_unregistered_unlearned_and_passive_gates(self):
        self.level=0;self.assertEqual(self.radius(),0)
        self.level=1;self.registered=False;self.assertEqual(self.radius(),0)
        self.registered=True;self.data.previewChannel=False;self.assertEqual(self.radius(),800)

    def test_final_tsuna_wave_and_inori_area_and_gojo_lv35(self):
        self.data.abilId=996
        self.data.mecha=self.vm.g['T_RadExp'](100,650)
        self.assertEqual(self.radius(),675)
        self.data.abilId=997;self.data.mecha='|cffffcc00Radius:|r 1400|n'
        self.assertEqual(self.radius(),2000)
        self.data.abilId=998;self.data.mecha='|cffffcc00Radius:|r 900|n';self.heroLevel=35
        self.assertEqual(self.radius(),1050)

    def test_owner_local_preview_never_writes_tooltip_cache(self):
        self.assertNotRegex(self.vm.text,r'\b(?:Save\w*|Create\w*|AddSpecialEffect|DestroyEffect)\(')

    def test_starrk_eq_bonus_actual_projectile_range_and_wolf_target_range(self):
        self.abilityId=1001;self.targetType=3;self.data.previewDirected=True
        self.assertEqual(self.radius(),1300)
        self.hs[(7,'morph e')]=1
        self.assertEqual(self.radius(),1400)
        self.level=5;self.assertEqual(self.radius(),1800)
        self.hs[(7,'stark t')]=1;self.castRange=2100
        self.assertEqual(self.radius(),2100)
        self.assertIn('builder.addRange(FormatReal(previewRadius))',self.source)
        self.assertIn('set rangeChanged = CheckAndSaveRangeState(u)',self.source)

    def test_examples_are_inferred_from_real_object_data_not_an_exception_table(self):
        ids=channel_ids(ROOT)
        for name in ('AstaQ_ID','GojoQ_ID','GojoW_ID','PatriotR_ID','PatriotT_ID'):
            line=next(l for l in self.source.splitlines() if 'call SpellData.' in l and name+',' in l)
            self.assertIn('.setPreviewDirected()',line)
        for name in ('KenjakuQ_ID','KenjakuE_ID','MahoragaR_ID','InoriR_ID','BambiettaR_ID'):
            self.assertIn(name,ids)
            line=next(l for l in self.source.splitlines() if 'call SpellData.create' in l and '('+name+',' in l)
            self.assertTrue(line.endswith('.setPreviewChannel()'),name)
        self.assertNotIn('abilId == KenjakuQ_ID',self.source)
        self.assertNotIn('abilId == MahoragaR_ID',self.source)


class RetiredHoldSettings(unittest.TestCase):
    def setUp(self):
        self.source=(ROOT/'triggers/WOS_Start/WOSUI.j').read_text(encoding='utf-8-sig')
        from test_wos_ui import load_source
        self.vm=load_source('WOSUI.j')

    def test_retired_channel_six_ignores_legacy_hold_save_record(self):
        # Channel 6 stays unused; Damage Stats took channel 7.
        self.assertIn('WUI_HOTKEY_DAMAGE = 7',self.source);self.assertIn('WUI_HOTKEY_CHANNELS = 8',self.source)
        self.assertNotIn('WUI_HOTKEY_RANGE',self.source)
        g=self.vm.g
        g.update(GetPlayerId=lambda p:p,WUI_KeyByLabel=lambda s:s)
        self.vm.run('WUI_ApplySavedHotkey',(0,6,'V'))
        self.assertNotIn('H,6,',self.vm.run('WUI_SavedSettingsString',(0,)))

    def test_hold_control_and_save_hint_are_gone(self):
        library=(ROOT/'triggers/WOS_Start/AbilityRangePreview.j').read_text()
        self.assertNotIn('OSKEY_V',library)
        self.assertNotIn('WUI_RegisterHotkey',library)
        save=(ROOT/'triggers/WOS_Start/SaveLoad.j').read_text(encoding='utf-8-sig')
        self.assertNotIn('Hold Range/AoE',save)
        self.assertIn('Fast Buy/Fast Sell',save)


if __name__=='__main__':unittest.main()
