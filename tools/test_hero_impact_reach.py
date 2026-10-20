"""Hit envelopes and tooltip/circle agreement, checked against real flight paths."""
from pathlib import Path
import re
import unittest
from test_crocodile import JassState

ROOT=Path(__file__).resolve().parents[1]


class ImpactReach(unittest.TestCase):
    def setUp(self):
        self.text=(ROOT/'triggers/WOS_Start/UniversalTooltips.j').read_text(encoding='utf-8-sig')
        self.vm=JassState(self.text);self.hero=self.vm.unit(owner=0);self.flags={};self.levels={}
        for p in (ROOT/'triggers/Heroes').rglob('*.j'):
            for kind,name,value in re.findall(r"(?m)^\s*(?:private )?(?:constant )?(real|integer)\s+(\w+)\s*=\s*('[^']+'|[-+]?\d+(?:\.\d+)?)",p.read_text(encoding='utf-8-sig')):
                self.vm.g[name]=value[1:-1] if value.startswith("'") else float(value) if kind=='real' else int(value)
        self.vm.g.update(hs=self.flags,GetHeroInt=lambda *_:100.,I2R=float,
            GetUnitAbilityLevel=lambda u,a:self.levels.get(a,0),
            BlzGetAbilityRealLevelField=lambda *_:2100.,ABILITY_RLF_CAST_RANGE='range')

    def reach(self,name,level=5,padding=0.):
        identity=self.vm.g[name]
        center=self.vm.run('ARules_GetCastRange',(self.hero,identity,'ability',level))
        return self.vm.run('ARules_GetImpactReach',(self.hero,identity,level,center,padding))

    def test_source_executed_maximum_samples_include_offsets_and_collision_radii(self):
        # Empty enemy groups let the production projectile/dash run to its last damage probe.
        # Values are asserted independently of the renderer's existing visibility limit.
        cases={'DarkShikiT_ID':2490.,'DarkShikiQ_ID':1880.,'TojiW_ID':1650.,'TojiE_ID':975.,
            'CrocodileQ_ID':1940.,'CrocodileE_ID':1225.,'KiritoQ_ID':1740.,'AstaW_ID':1945.,
            'AlucardQ_ID':2265.,'InoriQ_ID':2470.,'RimuruQ_ID':2370.,'RimuruE_ID':2290.,
            'RimuruE4_ID':2465.,'RimuruW2_ID':1685.,'TsunaQ_ID':1260.,'TsunaQ2_ID':1555.,
            'TakeshiQ_ID':1910.,'TakeshiW_ID':2285.,'MilimE_ID':2245.,'HarribelQ_ID':2797.5,
            'NatsuQ_ID':1935.,'NatsuT_ID':2755.,'StarrkQ_ID':2481.3,'FrierenQ_ID':2287.04,
            'AstaQ_ID':2705.,'LaxusQ2_ID':2485.,'PatriotQ_ID':2315.,'Erza2R_ID':1925.}
        for name,expected in cases.items():
            with self.subTest(ability=name):self.assertAlmostEqual(expected,self.reach(name),places=5)

    def test_live_levels_and_forms_and_typed_target_padding(self):
        for level in range(1,6):
            self.assertAlmostEqual(1150.+100*(level-1)+330.,self.reach('DarkShikiQ_ID',level))
            self.assertAlmostEqual(1200.+50*(level-1)+75.+175.,self.reach('TojiW_ID',level))
        self.flags[id(0),'morph r']=1
        self.assertAlmostEqual(2230.,self.reach('AlucardQ_ID'))
        self.flags.clear();self.flags[id(0),'morph e']=1
        self.assertAlmostEqual(80.+19.*1400/17.+725.,self.reach('HarribelQ_ID'))
        self.flags.clear();self.levels[self.vm.g['TsunaW_Buff_ID']]=1
        normal=self.reach('TsunaQ_ID');self.assertGreater(normal,1260.)
        self.assertEqual(2350.,self.vm.run('ARules_GetImpactReach',(self.hero,'other',1,2100.,250.)))
        self.assertEqual(2100.,self.vm.run('ARules_GetImpactReach',(self.hero,'other',1,2100.,0.)))

    def test_pure_bounded_geometry_and_one_live_range_contract(self):
        helpers='\n'.join(re.findall(r'(?m)^    private function ARules_(?:CeilSteps|BeamEnvelope|BreathEnvelope|GetImpactReach) takes[^\n]*\n[\s\S]*?^    endfunction',self.text))
        self.assertNotRegex(helpers,r'\b(?:GetRandom\w*|Save\w*|Create\w*|Set\w*|BlzSet\w*|Destroy\w*)\(')
        self.assertIn('n == 64',helpers)
        self.assertIn('return GetPreviewRadius(hero, abilId)',self.text)
        self.assertIn('call builder.addRange(FormatReal(previewRadius))',self.text)


if __name__=='__main__':unittest.main()
