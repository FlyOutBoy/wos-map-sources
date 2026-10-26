"""Exercise actual small-icon slot refresh/cancel logic without Warcraft rendering."""
from pathlib import Path
import re
import unittest
from test_crocodile import JassState

class FrostnovaDurationIcons(unittest.TestCase):
    def test_refresh_and_cancel_reuse_timed_slot_without_extra_clock(self):
        text=(Path(__file__).resolve().parents[1]/'triggers/Systems/Systems2.j').read_text('utf-8-sig')
        body=re.search(r'private struct KS_BuffTimer\b.*?endstruct',text,re.S)[0]
        vm=JassState(body);ns=vm.structs['KS_BuffTimer'];u=vm.unit()
        data=ns.allocate();data.c=u;data.k3=3;data.check2=1;data.r=2.;data.rmax=10.;data.k2=73
        frames={73:'frame'};ns.statics.update(MUI_28=0,m_28=[data],frame0_pas2=frames,frame0_pas3=frames,frame0_pas4=frames)
        writes=[]
        vm.g.update(WUI_FrameSetMinMaxValue=lambda *a:None,WUI_FrameSetValue=lambda *a:None,
            BlzFrameSetText=lambda *a:None,BlzFrameSetTexture=lambda *a:writes.append(a),R2SW=lambda v,*a:str(v))
        # This path must never allocate a second instance or subscribe another timer.
        ns.MyBuffTime_Start=lambda *a:self.fail('duplicate timed icon')
        vm.run('SetDuration',(u,7.,'BTNHero_Frostnova_TE',3))
        self.assertEqual((0.,7.),(data.r,data.rmax));self.assertEqual(0,ns.MUI_28)
        self.assertTrue(writes[-1][1].endswith('BTNHero_Frostnova_TE.blp'))
        vm.run('SetDuration',(u,0.,'BTNHero_Frostnova_TE',3))
        self.assertEqual((0.,0.),(data.r,data.rmax))

if __name__=='__main__':unittest.main()
