"""Execute delayed fire impacts, rebound continuity and boomerang return geometry."""
from pathlib import Path
from types import SimpleNamespace
import re
import unittest

from test_crocodile import JassState
from particle_opt.mdx import chunks, pre2
from build_anchor_item_effect import repair

ROOT=Path(__file__).resolve().parents[1]
SOURCE=(ROOT/'triggers/Items/Items.j').read_text(encoding='utf-8-sig')


def branch(start,end,locals=''):
    body=SOURCE.split('elseif .kind == '+start+' then',1)[1].split('elseif .kind == '+end+' then',1)[0]
    body=re.sub(r'(?<![\w])\.([A-Za-z]\w*)',r'this.\1',body)
    return JassState('function Tick takes nothing returns boolean\n'+locals+body+'\nendfunction')


class FireEffects(unittest.TestCase):
    def test_phoenix_cast_places_slow_scaled_sword_above_enemy(self):
        body=re.search(r'function ItemsElements_Cast takes.*?endfunction',SOURCE,re.S)[0]
        vm=JassState(body);c,u=vm.unit(100,200,0),vm.unit(900,700,1)
        created=[];art=[]
        def add(kind,src,caster,target,duration):
            fx=SimpleNamespace(kind=kind,src=src,c=caster,u=target,left=duration)
            created.append(fx);return fx
        names=['BloodPactRingEvolved','BloodPactRing','Emberbreaker','LeviathanGrasp',
               'ThunderVerdict','CinderFang','VoltThread','PhoenixSeal','SirenTear']
        vm.g.update({name+'_Abi_ID':name for name in names})
        vm.g.update(showVision=True,ItemsElementsFx=SimpleNamespace(Add=add,SEALCAST=12),
                    PhoenixSeal_ID='seal',PhoenixSeal_Impact=3.25,
                    ElemValid=lambda *_:True,ElemInt=lambda _:100.,SacredGearBooster=lambda c,d:d,
                    GetUnitFacing=lambda _:123.,EffectSpawn=lambda *args:art.append(args),BlzGetLocalSpecialEffectZ=lambda _:1500.)
        vm.run('ItemsElements_Cast',(c,u,900.,700.,'PhoenixSeal'))
        self.assertEqual(1,len(created));self.assertEqual(.30,created[0].next)
        self.assertEqual(325.,created[0].dmg)
        self.assertTrue(art[0][0].endswith('wos_tx-jian-za.mdl'))
        self.assertEqual((900,700,123.,.08,.5,1500),art[0][1:])

    def test_sword_tracks_enemy_descends_and_damages_once_after_delay(self):
        vm=branch('SEALCAST','MOVE')
        c,u=vm.unit(100,200,0),vm.unit(700,500,1)
        fx=SimpleNamespace(c=c,u=u,e=vm.effect('sword'),phase=0,next=.30,left=1.85,dmg2=0.,step=.08)
        hits=[];speeds=[];sword=fx.e
        fx.Arrive=lambda:hits.append((fx.next,fx.e.x,fx.e.y))
        vm.g.update(showVision=True,DT=.03,ElemValid=lambda *_:u.life>0,
                    BlzSetSpecialEffectTimeScale=lambda e,v:speeds.append((v,len(hits))),BlzSetSpecialEffectZ=lambda e,z:setattr(e,"z",z))
        for i in range(9):
            u.x+=10
            self.assertFalse(vm.run('Tick',obj=fx))
        self.assertFalse(hits)
        self.assertTrue(vm.run('Tick',obj=fx))
        self.assertEqual(1,len(hits));self.assertEqual(u.x,hits[0][1]);self.assertEqual(u.y,hits[0][2]);self.assertAlmostEqual(0.,sword.z)
        self.assertEqual((2.,1),speeds[-1]);self.assertIsNone(fx.e)
        for i,(v,n) in enumerate(speeds[:-1]):self.assertAlmostEqual(.08+(i+1)*.03,v);self.assertEqual(0,n)
        self.assertNotIn(id(sword),vm.effects)

    def test_pending_sword_cancels_if_target_dies(self):
        vm=branch('SEALCAST','MOVE');c,u=vm.unit(),vm.unit()
        fx=SimpleNamespace(c=c,u=u,e=vm.effect('sword'),phase=0,next=.30,left=1.85,Arrive=lambda:self.fail('dead target'))
        vm.g.update(showVision=True,ElemValid=lambda *_:False)
        self.assertTrue(vm.run('Tick',obj=fx))

    def test_shurikens_return_to_turnaround_snapshot_even_after_caster_moves(self):
        # The combined wave/boomerang branch has a compound elseif condition.
        body=SOURCE.split('elseif .kind == ASHEN or .kind == WAVE then',1)[1].split('elseif .kind == COILSHOT then',1)[0]
        body=re.sub(r'(?<![\w])\.([A-Za-z]\w*)',r'this.\1',body)
        vm=JassState('function Tick takes nothing returns boolean\nlocal real a\nlocal real px\nlocal real py\n'+body+'\nendfunction')
        c=vm.unit(800,400,0)
        fx=SimpleNamespace(c=c,kind=8,x=100.,y=200.,vx=1.,vy=0.,step=0.,next=1800.,
                           phase=0,tx=0.,ty=0.,e=vm.effect('left'),e2=vm.effect('mid'),e3=vm.effect('right'),
                           g=[],g2=[],dmg=100.,dmg2=80.,trail1=vm.effect("t1"),trail2=vm.effect("t2"),trail3=vm.effect("t3"))
        sweeps=[];fx.Sweep=lambda x,y,*_:sweeps.append((x,y))
        vm.g.update(showVision=True,DT=.03,WAVE=9,ASHEN=8,IntegerTertiaryOp=lambda p,a,b:a if p else b)
        for _ in range(60):
            vm.run('Tick',obj=fx)
            if fx.phase==1:break
        self.assertEqual(1,fx.phase);self.assertEqual((800,400),(fx.tx,fx.ty))
        c.x,c.y=-500.,-900.
        for _ in range(60):
            if vm.run('Tick',obj=fx):break
        self.assertEqual(0.,fx.step)
        for x,y in sweeps[-3:]:
            self.assertAlmostEqual(800.,x);self.assertAlmostEqual(400.,y)
        self.assertEqual((800,400),(fx.tx,fx.ty))

    def test_anchor_half_turns_land_every_06_above_ground_and_release_to_half_second_fade(self):
        vm=branch('ANCHOR','STORM or .kind == SPIRAL','local real d\nlocal real a\nlocal real take\nlocal real px\nlocal real py\nlocal real best\n')
        import math,struct
        model=(ROOT/'assets/effects/war3mapImported/wos_LeviathanAnchor_NoSpray.mdx').read_bytes()
        vertex_offset=model.index(b'VRTX');vertex_count=struct.unpack_from('<I',model,vertex_offset+4)[0]
        vertices=[struct.unpack_from('<3f',model,vertex_offset+8+i*12) for i in range(vertex_count)]
        impacts=[];extras=[];fades=[];rebounds=[]
        fx=SimpleNamespace(c=vm.unit(),step=0.,charges=0,next=.6,dmg2=0.,dmg=225.,x=0.,y=0.,tx=0.,ty=0.,vx=1.,vy=0.,left=2.,
                           e=vm.effect('anchor'),e2=vm.effect('water'),Drag=lambda *_:None)
        fx.e.z=2050.;fx.e.pitch=-3.141592653589793
        fx.Pulse=lambda *_:impacts.append((fx.step,fx.e.z,fx.e.pitch,fx.e.x))
        vm.g.update(showVision=True,DT=.03,LeviathanAnchor_Aoe=500.,LeviathanAnchor_PullSpeed=240.,
                    ColorEffDummy3=lambda *a:fades.append(a),ElemFx=lambda *a:extras.append(a),BlzGetLocalSpecialEffectZ=lambda e:e.z,
                    BlzSetSpecialEffectPosition=lambda e,x,y,z:(setattr(e,"x",x),setattr(e,"y",y),setattr(e,"z",z)),
                    BlzSetSpecialEffectZ=lambda e,z:setattr(e,'z',z),
                    BlzSetSpecialEffectPitch=lambda e,p:setattr(e,'pitch',p))
        for _ in range(70):
            before=(fx.charges,fx.e.z,fx.e.pitch)
            done=vm.run('Tick',obj=fx)
            if fx.e is not None:
                # Actual mesh under pitch, not just its origin, must clear terrain.
                lowest=min(.9*(-v[0]*math.sin(fx.e.pitch)+v[2]*math.cos(fx.e.pitch)) for v in vertices)
                self.assertGreater(fx.e.z+lowest,50.)
            if fx.e is not None and fx.charges > 0:rebounds.append(fx.e.z)
            if fx.charges>before[0]:
                self.assertLess(before[1],450.)
                if fx.e is not None:self.assertLess(abs(fx.e.pitch-before[2]),.06)
            if done:break
        self.assertEqual(3,len(impacts));self.assertEqual(9,len(extras));self.assertEqual(1,len(fades));self.assertEqual(.5,fades[0][-1])
        self.assertFalse(any('Crack' in a[0] for a in extras))
        for (t,z,p,x),planned,pitch,pos in zip(impacts,(.6,1.2,1.8),(-1.57079633,1.57079633,-1.57079633),(0.,-80.,80.)):
            self.assertAlmostEqual(planned,t,delta=.00001);self.assertAlmostEqual(250.,z)
            self.assertAlmostEqual(pitch,p,places=6);self.assertAlmostEqual(pos,x)
        self.assertAlmostEqual(80.,fx.x)
        self.assertAlmostEqual(900.,max(rebounds));self.assertGreaterEqual(min(rebounds),250.)

    def test_crimson_has_one_four_int_erupt_and_six_pulses_totalling_four_int(self):
        vm=branch('RUNE','ASHEN or .kind == WAVE','local unit v\n')
        c=vm.unit(owner=0);u=vm.unit(owner=1);hits=[];pulses=[];time=0.
        fx=SimpleNamespace(c=c,x=0.,y=0.,phase=0,left=1.8,step=0.,next=0.,charges=0,src='book',dmg=400.,dmg2=400./6.)
        fx.Pulse=lambda radius,damage,*_:pulses.append((time,damage))
        vm.g.update(showVision=True,DT=.03,CrimsonScripture_Prepare=.6,CrimsonScripture_Aoe=450.,ItemsElements_Group=[],NoDecor_Cond=None,
          ElemValid=lambda caster,target:target is u,ElemHit=lambda c,u,src,d,*_:hits.append((time,d)),
          EffectSpawn=lambda *_:vm.effect('fire'),ColorEffDummy3=lambda *_:None)
        for _ in range(80):
            time+=.03;fx.left-=.03
            if vm.run('Tick',obj=fx):break
        self.assertEqual(1,len(hits));self.assertAlmostEqual(.6,hits[0][0],delta=.001)
        self.assertEqual(400.,hits[0][1]);self.assertEqual(6,len(pulses))
        self.assertAlmostEqual(400.,sum(d for _,d in pulses))
        self.assertAlmostEqual(1.2,pulses[-1][0]-hits[0][0],delta=.031)

    def test_coil_endpoint_pulses_four_times_with_growing_radius_and_no_translation(self):
        vm=branch('COILSHOT','STRIKES','local real px\nlocal real py\nlocal real d\nlocal real a\n')
        c=vm.unit();pulses=[]
        fx=SimpleNamespace(c=c,x=1800.,y=200.,phase=1,left=2.,step=0.,next=.5,charges=0,e=vm.effect('coil'),e2=vm.effect('trail'))
        fx.e.x,fx.e.y=1800.,200.
        fx.Pulse=lambda radius,damage,*_:pulses.append((radius,damage))
        vm.g.update(showVision=True,DT=.03,ConstellationCoil_ProjectileScale=1.,ConstellationCoil_Width=250.,ConstellationCoil_Slow=25,
           ElemInt=lambda _:100.,BlzSetSpecialEffectAlpha=lambda e,a:None,EffectSpawn=lambda *_:vm.effect('spark'),ColorEffDummy3=lambda *_:None)
        for _ in range(75):
            if vm.run('Tick',obj=fx):break
        self.assertEqual(4,len(pulses));self.assertEqual(400.,sum(d for _,d in pulses))
        self.assertAlmostEqual(625.,pulses[-1][0]);self.assertEqual(sorted(r for r,_ in pulses),[r for r,_ in pulses])
        self.assertEqual((1800.,200.),(fx.e.x,fx.e.y));self.assertEqual((1800.,200.),(fx.x,fx.y))

    def test_return_buff_outlasts_deadline_and_displacement_preserves_orders(self):
        import json
        data=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
        import war3_object_workspace as workspace
        docs,_=workspace.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
        obj=next(o for d in docs if d['source_file']=='war3map.w3a' for o in d['custom_objects'] if workspace.object_id(o)=='A155')
        duration={m['field']['text']:workspace.value_for_user(m) for m in obj['modifications']}
        self.assertGreater(duration['adur'],5.);self.assertGreater(duration['ahdu'],5.)
        text=(ROOT/'triggers/Systems/Systems2.j').read_text(encoding='utf-8-sig')
        def fn(name):return re.search(r'function '+name+r' takes.*?endfunction',text,re.S)[0]
        vm=JassState(re.sub(r'/\*.*?\*/','',fn('PosUnit')+'\n'+fn('MoveUnit'),flags=re.S))
        u=vm.unit(800,200);u.order='attack'
        vm.g.update(showVision=True,GearCCProtected=lambda _:False,PathableCheck3=lambda *_:True,
           GAngle2=lambda u,x,y:__import__("math").atan2(y-u.y,x-u.x),SR3=lambda u,x,y:__import__("math").hypot(x-u.x,y-u.y),
           IssueImmediateOrder=lambda *_:self.fail('replaced order'),IssuePointOrder=lambda *_:self.fail('replaced order'))
        vm.run('PosUnit',(u,0.,0.))
        self.assertAlmostEqual(0.,u.x,places=5);self.assertAlmostEqual(0.,u.y,places=5)
        self.assertEqual('attack',u.order)
        carrier=SOURCE.split('elseif .kind == KIND_RETURN then')[-1].split('endif\n                endif',1)[0]
        self.assertIn('call PosUnit(.u, .x, .y)',carrier)

    def test_active_anchor_uses_original_model_with_its_attached_water(self):
        import json
        cast=SOURCE.split('if id == LeviathanAnchor_Abi_ID then')[-1].split('elseif id == ThunderBastion_Abi_ID then')[0]
        self.assertIn('wos_EF_AZ_Leviathan_G2.mdx',cast)
        self.assertNotIn('wos_LeviathanAnchor_NoSpray',SOURCE)
        self.assertNotIn('fx.e2 =',cast)
        config=json.loads((ROOT/'.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
        model=(Path(config['mainMap'])/'war3mapImported/wos_EF_AZ_Leviathan_G2.mdx').read_bytes()
        table={tag:(offset,size) for tag,offset,size in chunks(model)}
        water=[e for e in pre2(model,*table['PRE2'],800) if e['name']=='water']
        self.assertEqual(1,len(water));self.assertGreater(water[0]['rate'],0)


if __name__=='__main__':unittest.main()
