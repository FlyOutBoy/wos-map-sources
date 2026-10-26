"""Check material mixing, dark haze isolation and fog-only particle edits."""
from pathlib import Path
import struct,unittest
from fix_frostnova_model import chunks,records
from prepare_frostnova_release_assets import textures
from polish_frostnova_effects import mixed_ice,smoke_only,level_fog
ROOT=Path(__file__).resolve().parents[1]/'assets/FrostnovaRelease'


class FrostnovaPolishedEffects(unittest.TestCase):
    def test_mixed_flight_keeps_all_geometry_blue_textures_and_adds_translucent_black_ice(self):
        original=(ROOT/'source-polish/wos_ice_shard-7716D.mdx').read_bytes()
        result=mixed_ice(original);old=dict(chunks(original));new=dict(chunks(result))
        self.assertEqual(result,(ROOT/'files/war3mapImported/wos_ice_shard-7716D-dark.mdx').read_bytes())
        for tag in old:
            if tag not in (b'MTLS',b'TEXS'):self.assertEqual(old[tag],new[tag],tag)
        self.assertEqual(textures(original),textures(result)[:-1])
        layers=[]
        for material in records(new[b'MTLS']):
            count=struct.unpack_from('<I',material,16)[0];offset=20
            for _ in range(count):
                size=struct.unpack_from('<I',material,offset)[0]
                if struct.unpack_from('<I',material,offset+12)[0]==6:
                    layers.append(material[offset:offset+size])
                offset+=size
        self.assertEqual(1,len(layers));self.assertAlmostEqual(.4,struct.unpack_from('<f',layers[0],24)[0])
        self.assertEqual(2,struct.unpack_from('<I',layers[0],4)[0])

    def test_haze_has_dark_particles_and_no_duplicate_crystal_mesh(self):
        original=(ROOT/'source-polish/wos_ice_shard-7716D-dark.mdx').read_bytes()
        result=smoke_only(original);parts=dict(chunks(result));old=dict(chunks(original))
        self.assertNotIn(b'GEOS',parts);self.assertNotIn(b'GEOA',parts)
        self.assertEqual(old[b'PRE2'],parts[b'PRE2'])
        self.assertTrue(all('Dark' in name or 'Black' in name for name in textures(result)))
        at=0
        while at<len(parts[b'BONE']):
            size=struct.unpack_from('<I',parts[b'BONE'],at)[0]
            self.assertEqual((0xffffffff,0xffffffff),struct.unpack_from('<2I',parts[b'BONE'],at+size))
            at+=size+8

    def test_w_fog_is_level_and_more_opaque_while_ice_emitters_are_byte_identical(self):
        for name in ('wos_file00002579_1.mdx','wos_tx026_1.mdx'):
            original=(ROOT/'source-polish'/name).read_bytes();result,changes=level_fog(original)
            self.assertTrue(changes);self.assertEqual(result,(ROOT/'files/war3mapImported'/name).read_bytes())
            before=dict(chunks(original));after=dict(chunks(result));names=textures(original)
            for a,b in zip(records(before[b'PRE2']),records(after[b'PRE2'])):
                end=4+struct.unpack_from('<I',a,4)[0]
                texture=names[struct.unpack_from('<I',a,end+155)[0]].lower()
                if 'smoke' not in texture and 'fog' not in texture:self.assertEqual(a,b)
                else:
                    self.assertEqual((0.,0.,0.,0.),struct.unpack_from('<4f',b,end))
                    self.assertEqual(0,b[end+94])
                    self.assertGreaterEqual(b[end+93],170)
                    node=struct.unpack_from('<I',b,88)[0]
                    self.assertEqual(0.,struct.unpack_from('<f',after[b'PIVT'],node*12+8)[0])


if __name__=='__main__':unittest.main()
