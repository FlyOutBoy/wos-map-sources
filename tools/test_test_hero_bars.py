from pathlib import Path
from types import SimpleNamespace
import struct
import tempfile
import unittest

import test_hero_bar_assets as assets
import test_map_runtime as runtime
from test_crocodile import JassState

ROOT=Path(__file__).resolve().parents[1]


class HeroBars(unittest.TestCase):
    def fixture(self,viewer=0):
        with tempfile.TemporaryDirectory() as temp:
            path=Path(temp)/'MinimalUI.j';runtime.minimal_ui(ROOT,path)
            vm=JassState(path.read_text())
        frames=[]
        def create(kind,name,parent,template,context):
            frame=SimpleNamespace(kind=kind,name=name,parent=parent,visible=False)
            frames.append(frame)
            return frame
        vm.g.update(WUI_TestBarKeys=None,WUI_TestBarCount=0,WUI_TestBarOwnerSlots=[0]*24,
            WUI_TestBarPanel=[None]*8192,WUI_TestBarFill=[None]*8192,
            WUI_TestBarCaption=[None]*8192,WUI_TestBarValue=[None]*8192,
            WUI_TestBarTextKey=[0]*8192,WUI_TestBarTitle=['']*8192,
            WUI_PANEL_TEXTURE='UI\\WOS\\panel.tga',WUI_EMPTY_TEXTURE='UI\\WOS\\empty.tga',
            GetLocalPlayer=lambda:viewer,GetPlayerId=lambda p:p,Player=lambda p:p,
            BlzCreateFrameByType=create,BlzGetOriginFrame=lambda origin,index:origin,
            BlzFrameSetTexture=lambda f,t,*a:setattr(f,'texture',t),
            BlzFrameSetSize=lambda f,w,h:setattr(f,'size',(w,h)),
            BlzFrameSetVisible=lambda f,v:setattr(f,'visible',v),
            BlzFrameSetText=lambda f,t:setattr(f,'text',t),
            BlzFrameSetAllPoints=lambda *a:None,BlzFrameSetAbsPoint=lambda *a:None,
            BlzFrameSetEnable=lambda *a:None,BlzFrameSetPoint=lambda f,*a:setattr(f,'anchor',a),
            BlzFrameClearAllPoints=lambda *a:None,BlzFrameSetAlpha=lambda *a:None,
            BlzFrameSetFont=lambda *a:None,BlzFrameSetTextAlignment=lambda *a:None,
            ORIGIN_FRAME_GAME_UI='game-ui',ORIGIN_FRAME_MINIMAP='minimap',TEXT_JUSTIFY_MIDDLE='middle',TEXT_JUSTIFY_CENTER='center',
            BlzGetAbilityIcon=lambda a:'icon',IsUnitType=lambda u,t:u.life<=0,
            R2SW=lambda r,w,p:f'{r:.1f}')
        for point in ('CENTER','LEFT','RIGHT','TOP','BOTTOM','TOPLEFT','TOPRIGHT','BOTTOMLEFT','BOTTOMRIGHT'):
            vm.g['FRAMEPOINT_'+point]=point
        return vm,frames,vm.unit(owner=0)

    def test_duration_fill_updates_and_hides_without_allocating_each_tick(self):
        vm,frames,hero=self.fixture()
        vm.run('WUI_HeroProgress',(hero,'A11A','Winter',12,12,True))
        count=len(frames);panel=vm.g['WUI_TestBarPanel'][1];fill=vm.g['WUI_TestBarFill'][1]
        self.assertTrue(panel.visible)
        self.assertEqual(('BOTTOMLEFT','minimap','TOPLEFT',.003,.006),panel.anchor)
        self.assertAlmostEqual(.104,fill.size[0])
        vm.run('WUI_HeroProgress',(hero,'A11A','Winter',6,12,True))
        self.assertEqual(count,len(frames))
        self.assertAlmostEqual(.052,fill.size[0])
        vm.run('WUI_HeroProgress',(hero,'A11A','Winter',0,0,True))
        self.assertFalse(panel.visible)
        self.assertEqual(count,len(frames))

    def test_frame_allocation_is_synchronous_but_visibility_is_owner_only(self):
        owner,owner_frames,hero=self.fixture(0)
        other,other_frames,other_hero=self.fixture(1)
        owner.run('WUI_HeroProgress',(hero,'A11A','Winter',12,12,True))
        other.run('WUI_HeroProgress',(other_hero,'A11A','Winter',12,12,True))
        self.assertEqual(len(owner_frames),len(other_frames))
        self.assertFalse(other.g['WUI_TestBarPanel'][1].visible)

    def test_only_missing_textures_and_import_records_are_added(self):
        with tempfile.TemporaryDirectory() as temp:
            root=Path(temp);stage=root/'map';source=root/'source'
            stage.mkdir();source.mkdir()
            for name in assets.TEXTURES:(source/(name+'.tga')).write_bytes(name.encode())
            record=b'\x0duser\\model.mdx\0'
            (stage/'war3map.imp').write_bytes(struct.pack('<II',1,1)+record)
            custom=stage/'UI/WOS/panel.tga';custom.parent.mkdir(parents=True);custom.write_bytes(b'user texture')
            existing=['UI\\WOS\\panel.tga','user\\model.mdx']
            changed=assets.stage_assets(stage,existing,source)
            self.assertNotIn('UI\\WOS\\panel.tga',changed)
            self.assertEqual(b'user texture',custom.read_bytes())
            imp=(stage/'war3map.imp').read_bytes()
            self.assertEqual(7,struct.unpack_from('<I',imp,4)[0])
            self.assertEqual(record,imp[8:8+len(record)])
            existing += ['UI\\WOS\\'+name+'.tga' for name in assets.TEXTURES]
            self.assertEqual([],assets.stage_assets(stage,existing,source))
            self.assertEqual(imp,(stage/'war3map.imp').read_bytes())


if __name__=='__main__':unittest.main()
