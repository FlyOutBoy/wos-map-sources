"""Execute MAIN spell paths and the real swept-decor enumerator with mock natives."""
import math
import re
import unittest
from types import SimpleNamespace

import test_crocodile_main_integration as main
import war3_object_workspace as objects
import war3_object_data as raw


class Environment(unittest.TestCase):
    def setUp(self):
        self.fixture = main.MainIntegration(methodName='runTest')
        self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)
        self.vm, self.c = self.fixture.vm, self.fixture.c
        self.vision, self.decor = [], []
        self.destructables = []
        source = (main.ROOT/'triggers/Systems/DecorDestroy_and_Erza_Debuff.j').read_text(encoding='utf-8-sig')
        # Use the production capsule filter; only Warcraft's destructable
        # damage/art/drop operation is replaced by deterministic HP accounting.
        for name in ['DecorLineHit','DecorRemoveLine']:
            fn = re.search(r'(?:private )?function '+name+r' takes.*?endfunction',source,re.S)[0]
            fn = fn.replace('function','method')
            # The evaluator attaches every parsed method to new struct
            # instances. Alias free functions to keep the native spy visible.
            fn = re.sub(r'\b(DecorLineHit|DecorRemoveLine)\b',r'Test_\1',fn)
            self.vm.text += '\n'+fn
            self.vm.methods['Test_'+name] = re.search(r'returns nothing\n(.*?)\nendmethod',fn,re.S)[1]
        for name in ['DecorLineX','DecorLineY','DecorLineCos','DecorLineSin','DecorLineLength','DecorLineRadius','DecorLineKey','decordmg','decor_x','decor_y','decor_aoe']:
            self.vm.g[name] = 0
        self.vm.g.update({
            'DecorLineHits': None, 'decorunit': None, 'DecorAliveCond': None,
            'GetDestructableX': lambda d: d.x, 'GetDestructableY': lambda d: d.y,
            'GetEnumDestructable': lambda: self.enumerated,
            'Rect': lambda *p: p, 'RemoveRect': lambda r: None,
            'EnumDestructablesInRect': self.enumerate_decor,
            'Test_DecorLineHit': lambda: self.vm.run('Test_DecorLineHit'),
            'decordestroy': self.decor_damage,
            'DecorRemoveLine': self.line,
            'DecorRemove': self.circle,
            'VisionTimed': lambda *p: self.vision.append((self.fixture.now,*p)),
        })

    def tree(self,x,y=0):
        d = SimpleNamespace(x=x,y=y,hp=10000,hits=[])
        self.destructables.append(d)
        return d

    def enumerate_decor(self,rect,condition,callback):
        for d in self.destructables:
            if d.hp > 0 and rect[0] <= d.x <= rect[2] and rect[1] <= d.y <= rect[3]:
                self.enumerated = d
                callback()

    def decor_damage(self):
        d = self.enumerated
        damage = self.vm.g['decordmg']
        d.hp -= damage
        d.hits.append((self.fixture.now,damage))

    def line(self,*args):
        self.decor.append((self.fixture.now,*args))
        self.vm.run('Test_DecorRemoveLine',args)

    def circle(self,c,x,y,radius,damage):
        self.decor.append((self.fixture.now,c,x,y,radius,damage))
        for d in self.destructables:
            if math.hypot(d.x-x,d.y-y) <= radius:
                d.hp -= damage
                d.hits.append((self.fixture.now,damage))

    def test_q_full_capsule_once_per_pass_and_sparse_three_second_vision(self):
        points = [self.tree(x,y) for x,y in [(-200,0),(125,254),(250,0),(1100,-254),(1855,0)]]
        outside = self.tree(125,256)
        self.assertTrue(self.vm.run('CrocodileQ_Start',(self.c,1655,0)))
        self.fixture.step(60)
        for d in points:
            self.assertEqual([15,25],[damage for _,damage in d.hits])
        self.assertFalse(outside.hits)
        self.assertEqual(7,len(self.vision))
        self.assertTrue(all(v[4:] == (255*1.5,3.0) for v in self.vision))
        self.assertFalse(self.vm.g['CrocodileDecorHits'])

    def test_w_single_cast_vision_and_six_half_second_decor_pulses(self):
        center = self.tree(500)
        outside = self.tree(1101)
        self.assertTrue(self.vm.run('CrocodileW_Start',(self.c,500,0)))
        self.fixture.step(140)
        self.assertEqual([(0.0,0,500,0,900.0,3.0)],self.vision)
        self.assertEqual(6,len(center.hits))
        for i,(time,damage) in enumerate(center.hits,1):
            self.assertLessEqual(abs(time-(.51+i*.5)),.031)
            self.assertEqual(10,damage)
        self.assertFalse(outside.hits)

    def test_e_swept_ground_decor_once_no_vision_no_pause_leak(self):
        points = [self.tree(x) for x in [-200,250,750,1200]]
        outside = self.tree(-226)
        self.assertTrue(self.vm.run('CrocodileE_Begin',(self.c,750,0)))
        self.fixture.step(30)
        self.assertEqual([],self.vision)
        for d in points:
            self.assertEqual([20],[damage for _,damage in d.hits])
        self.assertFalse(outside.hits)
        self.assertFalse(self.c.paused)
        self.assertFalse(self.vm.g['CrocodileDecorHits'])

    def test_r_decor_period_path_start_and_endpoint_vision(self):
        beginning = self.tree(-150)
        ending = self.tree(2250)
        self.assertTrue(self.vm.run('CrocodileR_Begin',(self.c,2000,0)))
        self.fixture.step(90)
        self.assertEqual(9,len(self.decor)) # Eight full 0.3s spans and the final remainder.
        for i,entry in enumerate(self.decor[:8],1):
            self.assertAlmostEqual(i*.3,entry[0],places=6)
            self.assertEqual(50,entry[7])
        self.assertTrue(beginning.hits)
        self.assertTrue(ending.hits)
        self.assertLess(len(self.vision),30)
        self.assertTrue(all(v[-1] == 3.0 for v in self.vision))
        self.assertFalse(self.vm.g['CrocodileDecorHits'])

    def test_t_ten_decor_pulses_five_vision_updates_then_stop_on_residual_sand(self):
        d = self.tree(0)
        ground = self.fixture.begin_t()
        self.fixture.step(180)
        self.assertFalse(ground.channelActive)
        self.assertEqual(10,len(d.hits))
        for i,(time,damage) in enumerate(d.hits,1):
            self.assertLessEqual(abs(time-i*.5),.031)
            self.assertEqual(100,damage)
        self.assertEqual(6,len(self.vision))
        for i,v in enumerate(self.vision):
            self.assertLessEqual(abs(v[0]-i),.031)
            self.assertEqual(3.0,v[-1])
        self.fixture.step(60)
        self.assertEqual(10,len(d.hits))
        self.assertEqual(6,len(self.vision))

    def test_t_interruption_stops_both_environment_clocks(self):
        self.fixture.begin_t()
        self.fixture.step(45)
        self.vm.run('CrocodileT_Finish',(self.c,))
        self.fixture.step(1)
        count = len(self.decor),len(self.vision)
        self.fixture.step(60)
        self.assertEqual(count,(len(self.decor),len(self.vision)))

    def test_f_single_target_environment(self):
        target = self.vm.unit(500)
        d = self.tree(500,150)
        outside = self.tree(500,156)
        self.vm.run('CrocodileF_Single_Start',(self.c,target))
        self.assertEqual([20],[damage for _,damage in d.hits])
        self.assertFalse(outside.hits)
        self.assertEqual([(0.0,0,500,0,155*1.5,2.0)],self.vision)

    def test_f_triple_each_ray_full_travel_and_overlap_not_multiplied(self):
        target = self.vm.unit(300)
        start = self.tree(200)
        angle = math.radians(15)
        ends = [self.tree(200+1700*math.cos(a),1700*math.sin(a)) for a in [0,angle,-angle]]
        outside = self.tree(-200)
        self.vm.run('CrocodileF_Projectile_Start',(self.c,target))
        self.fixture.step(50)
        for d in [start,*ends]:
            self.assertEqual([50],[damage for _,damage in d.hits])
        self.assertFalse(outside.hits)
        self.assertEqual(34,len(self.vision))
        self.assertTrue(all(v[-2:] == (155*1.5,2.0) for v in self.vision))
        self.assertFalse(self.vm.g['CrocodileDecorHits'])

    def test_concurrent_q_e_dedup_tables_do_not_share_cast_keys(self):
        d = self.tree(250)
        self.assertTrue(self.vm.run('CrocodileQ_Start',(self.c,1655,0)))
        self.assertTrue(self.vm.run('CrocodileE_Begin',(self.c,750,0)))
        self.fixture.step(70)
        self.assertEqual([15,20,25],sorted(damage for _,damage in d.hits))
        self.assertFalse(self.vm.g['CrocodileDecorHits'])

    def test_sand_native_settings_survive_binary_encoding(self):
        documents,_ = objects.prepare_documents(main.ROOT/'object-data',main.ROOT/'.object-data-raw')
        doc = next(d for d in documents if d['source_file'] == 'war3map.w3a')
        doc = raw.parse_object_file(raw.encode_object_file(doc,'war3map.w3a'),'war3map.w3a','abilities','level',{})
        a = next(o for o in doc['custom_objects'] if objects.object_id(o) == 'A109')
        fields = {(m['field']['text'],m.get('level',0)):m['data']['value'] for m in a['modifications']}
        for f,value in [('areq',''),('arqa',''),('achd',0),('alev',1),('aher',0)]:
            self.assertEqual(value,fields[f,0])
        self.assertEqual('B03E',fields['abuf',1])
        self.assertEqual(0,fields['amcs',1])
        self.assertEqual(0,fields['acas',1])
        self.assertAlmostEqual(.35,fields['ahdu',1],places=6)
        self.assertAlmostEqual(80/310,fields['Blo2',1],places=6)

    def test_t2_reveals_collected_sand_outside_the_original_t_area(self):
        self.vm.run('AddSand',(self.c,4000,0,250,True))
        self.fixture.begin_t()
        self.fixture.step(35)
        self.assertTrue(self.vm.run('CrocodileT2_Begin',(self.c,)))
        self.fixture.step(17)
        self.assertTrue(any(v[2:4] == (4000,0) and v[4:] == (375.0,3.0) for v in self.vision))

    def test_sand_buff_is_removed_within_one_refresh_after_leaving(self):
        self.vm.run('AddSand',(self.c,0,0,250,True))
        self.fixture.step(7)
        buff = self.vm.g['CrocodileG_SandMS_Buff_ID']
        self.assertGreater(self.vm.g['GetUnitAbilityLevel'](self.c,buff),0)
        self.c.x = 10000
        self.fixture.step(7)
        self.assertEqual(0,self.vm.g['GetUnitAbilityLevel'](self.c,buff))

    def test_death_cleans_partial_q_cast_decor_tracking(self):
        self.tree(250)
        self.assertTrue(self.vm.run('CrocodileQ_Start',(self.c,1655,0)))
        self.fixture.step(19)
        self.assertTrue(self.vm.g['CrocodileDecorHits'])
        self.c.life = 0
        self.fixture.step(1)
        self.assertFalse(self.vm.g['CrocodileDecorHits'])

    def test_e_decor_helper_failure_cannot_keep_the_hero_paused(self):
        def aborted(*args):
            raise RuntimeError('Decor helper aborted')
        self.vm.g['DecorRemoveLine'] = aborted
        self.assertTrue(self.vm.run('CrocodileE_Begin',(self.c,750,0)))
        for _ in range(25):
            try:
                self.fixture.step()
            except RuntimeError:
                pass
        self.assertFalse(self.c.paused)
        self.assertFalse(self.fixture.state(1).active)
        self.assertFalse(self.vm.g['CrocodileDecorHits'])


if __name__ == '__main__':
    unittest.main()
