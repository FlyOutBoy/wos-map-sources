"""Exercise the actual shared Iframe helpers and tooltip section order."""
from pathlib import Path
import re,unittest
from test_crocodile import JassState
ROOT=Path(__file__).resolve().parents[1]


class IframeTooltips(unittest.TestCase):
    def setUp(self):
        source=(ROOT/'triggers/WOS_Start/UniversalTooltips.j').read_text('utf-8-sig')
        names=('FormatReal','T_Invul','T_InvulAuto','T_Cast','T_CastAuto','T_Duration','T_DurAuto','T_CastInvul','T_DurationInvul','T_Bonus','FilterIframe')
        helpers='\n'.join(re.search(r'    (?:public |private )?function '+name+r'\b.*?    endfunction',source,re.S)[0] for name in names)
        builder=(ROOT/'triggers/WOS_Start/TooltipBuilder.j').read_text('utf-8-sig').replace('    struct TooltipBuilder','    private struct TooltipBuilder')
        self.vm=JassState(builder+'\n'+helpers)
        for name,value in re.findall(r'constant string (C_\w+)\s*=\s*"([^"]*)"',builder):self.vm.g[name]=value
        self.vm.g.update(StringLength=lambda s:len(s or ''),SubString=lambda s,a,b:(s or '')[int(a):int(b)],I2S=lambda x:str(int(x)),R2SW=lambda x,w,p:format(x,'.'+str(p)+'f'))

    def test_helpers_emit_only_positive_red_notices_and_filter_preserves_stats(self):
        vm=self.vm
        self.assertEqual('',vm.run('T_Invul',(0.,)))
        self.assertEqual('',vm.run('T_InvulAuto',(2.,False)))
        ordinary=vm.run('T_CastAuto',(.6,False))
        protected=vm.run('T_CastAuto',(.6,True))
        notice=vm.run('FilterIframe',(protected,True))
        self.assertEqual('|cffff3333Iframe: 0.60 sec|r',notice)
        self.assertNotIn('Iframe',vm.run('FilterIframe',(ordinary,True)))
        self.assertEqual(ordinary.rstrip('|n'),vm.run('FilterIframe',(protected,False)))
        self.assertEqual('First paragraph.|n|nSecond paragraph.',vm.run('FilterIframe',('First paragraph.|n|nSecond paragraph.',False)))

    def test_notice_follows_description_and_bonus_before_blank_stat_separator(self):
        vm=self.vm;builder=vm.structs['TooltipBuilder'].create()
        builder.buffer='';builder.normalizedBuffer='';builder.hasStats=False
        builder.addDescription('Base description.')
        bonus='Details.'+vm.run('T_Bonus',("Winter's Scar",'Empowered details.'))
        builder.addBonus(bonus)
        builder.addIframe(vm.run('T_Invul',(1.35,)).removesuffix('|n'))
        builder.addDamage(2,'Intelligence x 2')
        text=builder.get()
        self.assertIn('Details.|n|cffffa500[Winter\'s Scar]',text)
        self.assertLess(text.index('Empowered details.'),text.index('Iframe:'))
        self.assertIn('Iframe: 1.35 sec|r|n|n',text)
        self.assertLess(text.index('Iframe:'),text.index('Mag. Damage:'))

    def test_all_three_generation_paths_filter_notices_before_damage(self):
        source=(ROOT/'triggers/WOS_Start/UniversalTooltips.j').read_text('utf-8-sig')
        starts=[m.start() for m in re.finditer(r'call builder.addDescription\((?:FilterIframe|descBody)',source)]
        self.assertEqual(3,len(starts))
        for start in starts:
            body=source[start:source.index('call builder.addMechanic',start)]
            self.assertLess(body.index('call builder.addIframe'),body.index('call builder.addDamage'))
        self.assertNotIn('Vulnerable cast.',source)
        self.assertNotIn('(Invulnerable)',source)


if __name__=='__main__':unittest.main()
