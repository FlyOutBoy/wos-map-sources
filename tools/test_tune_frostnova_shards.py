from pathlib import Path
import struct,unittest
from PIL import Image
from fix_frostnova_model import chunks,records
from tune_frostnova_shards import tune,PARTICLE_SCALE,OUT

ROOT=Path(__file__).resolve().parents[1]


class Shards(unittest.TestCase):
    def setUp(self):
        # Current packet is already the smaller normal model; tune another pass
        # in memory to verify the transform without depending on ignored archives.
        self.source=(OUT/'ice_shard-7716D.mdx').read_bytes()

    def test_only_emitter_sizes_change_for_normal_shard(self):
        result=dict(chunks(tune(self.source)))
        original=dict(chunks(self.source))
        for tag in original:
            if tag!=b'PRE2':self.assertEqual(original[tag],result[tag],tag)
        for old,new in zip(records(original[b'PRE2']),records(result[b'PRE2'])):
            offset=4+struct.unpack_from('<I',old,4)[0]+95
            self.assertEqual(old[:offset],new[:offset])
            self.assertEqual(old[offset+12:],new[offset+12:])
            for a,b in zip(struct.unpack_from('<3f',old,offset),struct.unpack_from('<3f',new,offset)):
                self.assertAlmostEqual(a*PARTICLE_SCALE,b,places=4)

    def test_dark_shard_uses_real_blending_and_transparent_sprites(self):
        original=dict(chunks(self.source));result=dict(chunks(tune(self.source,True)))
        for tag in original:
            if tag not in (b'TEXS',b'MTLS',b'PRE2'):self.assertEqual(original[tag],result[tag],tag)
        for record in records(result[b'MTLS']):
            self.assertEqual(2,struct.unpack_from('<I',record,24)[0])
        for record in records(result[b'PRE2']):
            offset=4+struct.unpack_from('<I',record,4)[0]
            self.assertEqual(0,struct.unpack_from('<I',record,offset+32)[0])
            self.assertEqual(bytes([200,150,0]),record[offset+92:offset+95])
            self.assertLess(max(struct.unpack_from('<9f',record,offset+56)),.66)
        textures=result[b'TEXS']
        for at in range(0,len(textures),268):
            name=textures[at+4:at+264].split(b'\0')[0].decode()
            image=Image.open(ROOT/'assets/FrostnovaEffects/files'/name.replace('\\','/'))
            if 'BlackIce' not in name:
                self.assertEqual('RGBA',image.mode)
                lo,hi=image.getextrema()[3]
                self.assertEqual(0,lo);self.assertGreater(hi,0)


if __name__=='__main__':unittest.main()
