from pathlib import Path
import struct
import unittest

from fix_frostnova_te_area import fix_area
from fix_frostnova_model import chunks,records

ROOT=Path(__file__).resolve().parents[1]


class TEAreaVisibility(unittest.TestCase):
    def test_only_depth_flags_and_global_extent_change(self):
        source=(ROOT/'assets/FrostnovaEffects/source/wos_az_aachristmas_t1_700_1.mdx').read_bytes()
        result=fix_area(source)
        self.assertEqual(len(source),len(result))
        old=dict(chunks(source));new=dict(chunks(result))
        self.assertEqual(set(old),set(new))
        for tag in old:
            if tag not in [b'MODL',b'MTLS']:self.assertEqual(old[tag],new[tag],tag)
        self.assertEqual(old[b'MODL'][:340],new[b'MODL'][:340])
        self.assertEqual(old[b'MODL'][368:],new[b'MODL'][368:])
        extent=struct.unpack_from('<7f',new[b'MODL'],340)
        self.assertGreater(extent[0],900)
        self.assertLess(extent[1],-660);self.assertGreater(extent[4],660)
        self.assertGreater(extent[6],350)
        for before,after in zip(records(old[b'MTLS']),records(new[b'MTLS'])):
            self.assertEqual(before[:20],after[:20])
            count=struct.unpack_from('<I',before,16)[0];at=20
            for _ in range(count):
                size=struct.unpack_from('<I',before,at)[0]
                flags=struct.unpack_from('<I',before,at+8)[0]
                self.assertEqual(flags|0xC0,struct.unpack_from('<I',after,at+8)[0])
                self.assertEqual(before[at:at+8],after[at:at+8])
                self.assertEqual(before[at+12:at+size],after[at+12:at+size])
                at+=size
        self.assertEqual(result,fix_area(result))


if __name__=='__main__':unittest.main()
