"""Exercise the 256-entry skin-palette fix without depending on a local map."""
from collections import Counter
from pathlib import Path
import struct
import unittest

import fix_frostnova_model as model


def triangle_attributes(g):
    return [tuple((g.vertices[v], g.normals[v], g.groups[g.vertex_groups[v]],
        tuple(layer[v] for layer in g.uvs)) for v in face) for face in g.faces]


class FrostnovaModelTests(unittest.TestCase):
    def fixture(self):
        g=model.Geoset([struct.pack('<fff', i, i/2, -i) for i in range(256)],
            [struct.pack('<fff', 0, 0, 1)]*256,
            [(i, i+1, i+2) for i in range(0, 255, 3)]+[(253, 254, 255)],
            list(range(256)), [(i,) for i in range(256)],
            struct.pack('<III7fI', 0, 0, 0, *([0.0]*7), 0),
            [[struct.pack('<ff', i/256, i/128) for i in range(256)]])
        geo_anim=struct.pack('<IfIfffI', 28, 1.0, 0, 1.0, 1.0, 1.0, 0)
        bones=[]
        for i in range(256):
            bone=bytearray(104)
            struct.pack_into('<I', bone, 0, 96)
            struct.pack_into('<III', bone, 84, i, 0xFFFFFFFF, 0)
            struct.pack_into('<II', bone, 96, 0, 0xFFFFFFFF)
            bones.append(bytes(bone))
        chunks=[(b'VERS',struct.pack('<I',800)), (b'SEQS',b'untouched-animation-data'),
            (b'TEXS',b'untouched-texture-paths'), (b'GEOS',model.encode_geoset(g)),
            (b'GEOA',geo_anim),(b'BONE',b''.join(bones))]
        return b'MDLX'+b''.join(tag+struct.pack('<I',len(data))+data for tag,data in chunks),g

    def test_split_preserves_every_triangle_attribute_and_skin_binding(self):
        data,g=self.fixture()
        fixed,report=model.fix_model(data)
        parts=[model.parse_geoset(r) for r in model.records(dict(model.chunks(fixed))[b'GEOS'])]
        self.assertEqual([255,3],report['fixed_groups'])
        self.assertEqual(triangle_attributes(g),[face for p in parts for face in triangle_attributes(p)])
        self.assertTrue(all(max(p.vertex_groups)<len(p.groups)<=255 for p in parts))
        self.assertEqual(report['original_triangles'],report['fixed_triangles'])

    def test_animation_and_material_data_are_retained_and_geoset_alpha_is_copied(self):
        data,g=self.fixture()
        fixed,_=model.fix_model(data)
        old=dict(model.chunks(data));new=dict(model.chunks(fixed))
        for tag in (b'VERS',b'SEQS',b'TEXS'):self.assertEqual(old[tag],new[tag])
        geosets=[model.parse_geoset(r) for r in model.records(new[b'GEOS'])]
        self.assertTrue(all(p.metadata==g.metadata for p in geosets))
        animations=list(model.records(new[b'GEOA']))
        self.assertEqual(2,len(animations))
        self.assertEqual(animations[0][:24],animations[1][:24])
        self.assertEqual((1,),struct.unpack_from('<I',animations[1],24))
        for offset in range(0,len(new[b'BONE']),104):
            self.assertEqual(old[b'BONE'][offset:offset+96],new[b'BONE'][offset:offset+96])
            self.assertEqual(0xFFFFFFFF,struct.unpack_from('<I',new[b'BONE'],offset+96)[0])

    def test_fix_is_idempotent_and_rejects_unhandled_formats(self):
        data,_=self.fixture();fixed,_=model.fix_model(data)
        again,report=model.fix_model(fixed)
        self.assertEqual(fixed,again)
        self.assertEqual({},report['split_geosets'])
        with self.assertRaises(ValueError):model.fix_model(b'not a model')

    def test_checked_in_model_has_no_palette_at_the_renderer_wrap_boundary(self):
        path=Path(__file__).resolve().parents[1]/'assets/FrostnovaModel/war3mapImported/arknights_sx01.mdx'
        data=path.read_bytes()
        geosets=[model.parse_geoset(r) for r in model.records(dict(model.chunks(data))[b'GEOS'])]
        self.assertEqual([255,9,19,1,1,9],[len(g.groups) for g in geosets])
        self.assertEqual(7613,sum(len(g.faces) for g in geosets))


if __name__=='__main__':unittest.main()
