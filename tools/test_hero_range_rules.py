"""Read-only range rules against real hero constants, forms, buffs and native fallback."""
from pathlib import Path
import re,unittest
from test_crocodile import JassState

ROOT=Path(__file__).resolve().parents[1]


class HeroRanges(unittest.TestCase):
    def setUp(self):
        self.source=(ROOT/'test_map/ability_range/HeroRangeRules.j').read_text()
        self.vm=JassState(self.source);self.flags={};self.levels={};self.intelligence=100;self.native=2100
        for path in (ROOT/'triggers/Heroes').rglob('*.j'):
            for kind,name,value in re.findall(r"(?m)^\s*(?:constant )?(real|integer)\s+(\w+)\s*=\s*('[^']+'|[-+]?\d+(?:\.\d+)?)",path.read_text(encoding='utf-8-sig')):
                self.vm.g[name]=value[1:-1] if value.startswith("'") else float(value) if kind=='real' else int(value)
        self.vm.g.update({'GetHandleId':lambda h:h,'GetOwningPlayer':lambda h:'owner',
            'hs':self.flags,'StringHash':lambda s:s,'LoadInteger':lambda ht,p,k:self.flags.get((p,k),0),
            'GetUnitAbilityLevel':lambda h,a:self.levels.get(a,0),'GetHeroInt':lambda h,b:self.intelligence,
            'BlzGetAbilityRealLevelField':lambda *a:self.native,'ABILITY_RLF_CAST_RANGE':'cast'})

    def radius(self,name,level=1):
        return self.vm.run('ARules_GetCastRange',('hero',self.vm.g.get(name,name),'ability',level))

    def test_main_frieren_and_milim_ranges_use_live_production_formulas(self):
        production=JassState((ROOT/'triggers/WOS_Start/UniversalTooltips.j').read_text(encoding='utf-8-sig'))
        self.vm.methods['ARules_GetCastRange']=production.methods['ARules_GetCastRange']
        for ability,level,expected in (('FrierenQ_ID',5,1600.),('FrierenW2_ID',1,1800.),('FrierenT2_ID',1,2000.),('MilimQ_ID',1,1255.),('MilimE_ID',5,1600.),('MilimT2_ID',1,2700.)):
            with self.subTest(ability=ability):self.assertEqual(expected,self.radius(ability,level))

    def test_harribel_e_reduces_q_instead_of_stacking_bonus(self):
        self.assertEqual(self.radius('HarribelQ_ID',5),1800)
        self.flags[('owner','morph e')]=1
        self.assertEqual(self.radius('HarribelQ_ID',5),1400)
        self.flags.clear();self.assertEqual(self.radius('HarribelQ_ID',5),1800)

    def test_starrk_eq_bonus_and_wolf_native_targeting(self):
        self.assertEqual(self.radius('StarrkQ_ID',5),1700)
        self.flags[('owner','morph e')]=1;self.assertEqual(self.radius('StarrkQ_ID',5),1800)
        self.flags[('hero','stark t')]=1;self.assertEqual(self.radius('StarrkQ_ID',5),2100)

    def test_barragan_e_bonus_but_w_uses_live_native_range(self):
        self.assertEqual(self.radius('BarraganQ_ID',5),1600)
        self.flags[('owner','morph e')]=1;self.assertEqual(self.radius('BarraganQ_ID',5),2040)
        self.flags[('hero','barragan t')]=1;self.assertEqual(self.radius('BarraganQ_ID',5),2110)
        self.native=1500;self.assertEqual(self.radius('BarraganW_ID'),1500)
        self.native=1200;self.assertEqual(self.radius('BarraganW_ID'),1200)

    def test_tsuna_w_buff_is_added_and_removed(self):
        self.assertEqual(self.radius('TsunaQ_ID'),1000)
        self.levels[self.vm.g['TsunaW_Buff_ID']]=1
        self.assertEqual(self.radius('TsunaQ_ID'),1200)
        self.levels.clear();self.assertEqual(self.radius('TsunaQ_ID'),1000)

    def test_alucard_r_can_shorten_both_q_and_e(self):
        self.assertEqual(self.radius('AlucardQ_ID',5),1700)
        self.assertEqual(self.radius('AlucardE_ID',5),2000)
        self.flags[('owner','morph r')]=1
        self.assertEqual(self.radius('AlucardQ_ID',5),1600)
        self.assertEqual(self.radius('AlucardE_ID',5),1650)

    def test_saber_r_and_inori_replacements_and_live_intelligence(self):
        self.assertEqual(self.radius('AlterSaberQ_ID'),1200)
        self.flags[('hero','mode r')]=1;self.assertEqual(self.radius('AlterSaberQ_ID'),1300)
        self.assertEqual(self.radius('InoriQ_ID',3),1750)
        self.intelligence=300;self.assertEqual(self.radius('InoriQ_ID',3),1950)
        self.assertEqual(self.radius('InoriQ2_ID',3),1300)
        self.assertEqual(self.radius('InoriQ3_ID',3),1700)

    def test_bambietta_transformation_max_envelope_without_rng(self):
        self.assertEqual(self.radius('BambiettaQ_ID',5),1600)
        self.assertEqual(self.radius('BambiettaE_ID',5),2230)
        self.flags[('owner','morph t')]=1
        self.assertEqual(self.radius('BambiettaQ_ID',5),1950)
        self.assertEqual(self.radius('BambiettaE_ID',5),2650)

    def test_natsu_forms_cross_preview_limit_without_clamping(self):
        self.assertEqual(self.radius('NatsuQ_ID'),1300)
        self.flags[('hero','mode g')]=1;self.assertEqual(self.radius('NatsuQ_ID'),2400)
        self.flags[('hero','rev q')]=1;self.assertEqual(self.radius('NatsuQ_ID'),4800)
        self.flags.clear();self.assertEqual(self.radius('NatsuQ_ID'),1300)

    def test_level_scaled_cases_and_replacement_ids(self):
        cases={'AstaQ_ID':2125,'AstaQ2_ID':2055,'AstaW_ID':1700,'DarkShikiQ_ID':1550,
            'FrierenQ_ID':1600,'KiritoQ_ID':1520,'MilimE_ID':1600,'OkarunQ_ID':1200,
            'PatriotQ_ID':1600,'PatriotR_ID':1500,'RimuruQ_ID':2000,'TakeshiQ_ID':1500,
            'TojiW_ID':1400,'TojiE_ID':800,'TsunaE_ID':2160,'MahoragaE_ID':1100,
            'MahoragaE3_ID':1400,'LaxusQ2_ID':1800,'RimuruE_ID':1700,'RimuruE4_ID':1800}
        for name,expected in cases.items():
            with self.subTest(ability=name):self.assertEqual(self.radius(name,5),expected)

    def test_no_rng_state_writes_or_handle_allocation(self):
        self.assertNotRegex(self.source,r'\b(?:GetRandom\w*|Save\w*|Create\w*|Set\w*|BlzSet\w*|AddSpecialEffect|DestroyEffect)\(')
        self.assertEqual(self.radius('unknown'),self.native)
        # Passive proximity / search ranges do not override targeting.
        self.assertEqual(self.radius('Erza6E_ID'),self.native)
        for name in re.findall(r'abilId == (\w+)',self.source):self.assertIn(name,self.vm.g)

    def test_gojo_level_transition_and_upgraded_red_flight(self):
        self.native=1200
        self.assertEqual(self.radius('GojoQ_ID',2),1200)
        self.assertEqual(self.radius('GojoQ_ID',3),1400)
        self.assertEqual(self.radius('GojoW_ID',5),1400)
        self.assertEqual(self.radius('GojoW2_ID'),2250)

    def test_fixed_flight_dash_and_replacement_sources(self):
        for name,expected in {'Erza2R_ID':1800,'Erza3T_ID':2500,'Erza5W_ID':1600,
            'Erza6Q_ID':1500,'Erza7Q_ID':1900,'CrocodileQ_ID':1655,
            'CrocodileE_ID':850,'MilimQ_ID':1255,'MilimT2_ID':2700,'NatsuT_ID':2150,
            'OkarunR_ID':1200,'RaidenE_ID':1800,'TakeshiW_ID':1800,'TakeshiGQ_ID':1500,
            'TsunaQ2_ID':2200,'TsunaW3_ID':2300,'AlterSaberW2_ID':1600,'BarraganT2_ID':2500}.items():
            with self.subTest(ability=name):self.assertEqual(self.radius(name),expected)


if __name__=='__main__':unittest.main()
