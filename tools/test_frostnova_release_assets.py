"""Validate the binary transforms used by the Frostnova release packet."""
import struct
import unittest
from pathlib import Path
import json

from fix_frostnova_model import Geoset,encode_geoset,parse_geoset,chunks
from prepare_frostnova_release_assets import tune_model
from resize_frostnova_te_model import resized


def model(tag,body):
    return b'MDLX'+tag+struct.pack('<I',len(body))+body


class ReleaseAssetTests(unittest.TestCase):
    def test_te_baked_size_preserves_materials_alpha_skin_uvs_and_topology(self):
        packet=Path(__file__).resolve().parents[1]/'assets/FrostnovaRelease'
        for old,new in [('wos_file00000883_1.mdx','wos_Frostnova_TE_Aura.mdx'),('wos_az_aachristmas_t1_700_1.mdx','wos_Frostnova_TE_Area.mdx')]:
            original=(packet/'source-followup'/old).read_bytes()
            updated=(packet/'files/war3mapImported'/new).read_bytes()
            self.assertEqual(resized(original,1.2),updated)
            before=dict(chunks(original));after=dict(chunks(updated))
            self.assertEqual(before[b'MODL'][:340],after[b'MODL'][:340])
            for x,y in zip(struct.unpack_from('<7f',before[b'MODL'],340),struct.unpack_from('<7f',after[b'MODL'],340)):
                self.assertAlmostEqual(x*1.2,y,delta=max(1e-5,abs(x)*1e-6))
            for tag in (b'MTLS',b'TEXS',b'TXAN',b'GEOA',b'GLBS'):
                self.assertEqual(before.get(tag),after.get(tag))
            from fix_frostnova_model import records
            meshes=[list(records(group.get(b'GEOS',b''))) for group in (before,after)]
            self.assertEqual(len(meshes[0]),len(meshes[1]))
            for a,b in zip(*meshes):
                a=parse_geoset(a);b=parse_geoset(b)
                for name in ('normals','faces','groups','vertex_groups','uvs'):
                    self.assertEqual(getattr(a,name),getattr(b,name))
                for va,vb in zip(a.vertices,b.vertices):
                    for x,y in zip(struct.unpack('<3f',va),struct.unpack('<3f',vb)):
                        self.assertAlmostEqual(x*1.2,y,delta=max(1e-5,abs(x)*1e-6))

    def test_object_progression_cooldowns_and_helper_cast_costs_are_explicit(self):
        root=Path(__file__).resolve().parents[1]
        document=json.loads((root/'.object-data-raw/abilities.json').read_text('utf8'))
        objects={obj['new_id']['text']:obj for obj in document['custom_objects']}
        def value(identity,field,level=0):
            return next(m['data']['value'] for m in objects[identity]['modifications'] if m['field']['text']==field and m['level']==level)
        for ability,start in [('A116',17),('A117',24),('A118',25),('A119',30)]:
            self.assertEqual(5,value(ability,'alev'))
            self.assertEqual(4,value(ability,'alsk'))
            for rank in range(1,6):
                self.assertEqual(start-(rank-1 if ability!='A118' else 0),value(ability,'acdn',rank))
        self.assertEqual(50,value('A11A','acdn',1))
        self.assertEqual('h002',value('A11B','areq'))
        for ability in ('A11C','A1F0','A1F1','A1F2'):
            for rank in range(1,11 if ability=='A11C' else 2):
                self.assertEqual(0,value(ability,'amcs',rank))
                self.assertEqual(0,value(ability,'acdn',rank))
                self.assertEqual('invulnerable,vulnerable,notself' if ability=='A1F2' else 'invulnerable,vulnerable',value(ability,'atar',rank))

    def test_shard_palette_repair_preserves_every_geometry_attribute(self):
        vertex=struct.pack('<3f',1,2,3)
        mesh=Geoset([vertex]*3,[vertex]*3,[(0,1,2)],[1]*3,[(0,)],bytes(44),[[struct.pack('<2f',.2,.7)]*3])
        fixed,_=tune_model(model(b'GEOS',encode_geoset(mesh)),{})
        repaired=parse_geoset(dict(chunks(fixed))[b'GEOS'])
        self.assertEqual([0,0,0],repaired.vertex_groups)
        for name in ('vertices','normals','faces','groups','metadata','uvs'):
            self.assertEqual(getattr(mesh,name),getattr(repaired,name))

    def test_emission_cap_scales_tracks_and_leaves_small_emitters_unchanged(self):
        record=bytearray(271)
        struct.pack_into('<I',record,4,96)
        struct.pack_into('<f',record,116,1.)  # lifespan
        struct.pack_into('<f',record,120,20.)
        struct.pack_into('<I',record,0,len(record))
        fixed,changes=tune_model(model(b'PRE2',record),{})
        self.assertEqual([],changes)
        self.assertEqual(bytes(record),dict(chunks(fixed))[b'PRE2'])
        record+=b'KP2E'+struct.pack('<III',2,1,0xffffffff)+struct.pack('<IfIf',0,2500.,1000,0.)
        struct.pack_into('<I',record,0,len(record))
        fixed,changes=tune_model(model(b'PRE2',record),{})
        body=dict(chunks(fixed))[b'PRE2']
        self.assertEqual(60.,struct.unpack_from('<f',body,291)[0])
        self.assertEqual(0.,struct.unpack_from('<f',body,299)[0])
        self.assertEqual(1.,struct.unpack_from('<f',body,116)[0])
        self.assertEqual(2500.,changes[0]['before'])


if __name__=='__main__':unittest.main()
