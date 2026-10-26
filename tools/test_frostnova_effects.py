from pathlib import Path
import hashlib
import json
import struct
import tempfile
import unittest

import frostnova_effects as effects

ROOT=Path(__file__).resolve().parents[1]
PACKET=ROOT/'assets/FrostnovaEffects'


class FrostnovaEffects(unittest.TestCase):
    def test_every_model_texture_resolves_and_assets_match_manifest(self):
        manifest=json.loads((PACKET/'manifest.json').read_text('utf8'))
        self.assertEqual(17,len(manifest['models']))
        for source,name in manifest['models'].items():
            self.assertEqual('war3mapImported\\'+Path(source).name,name)
        imported={e['importPath'].casefold() for e in manifest['entries']}
        native={name.casefold() for name in manifest['builtinReferences']}
        for entry in manifest['entries']:
            data=(PACKET/'files'/entry['importPath'].replace('\\','/')).read_bytes()
            self.assertEqual(entry['sha256'],hashlib.sha256(data).hexdigest())
            if not entry['importPath'].lower().endswith('.mdx'):
                continue
            self.assertEqual(b'MDLX',data[:4]);position=4
            while position<len(data):
                tag,size=struct.unpack_from('<4sI',data,position)
                if tag==b'GLBS':
                    self.assertTrue(all(struct.unpack_from('<I',data,offset)[0]>0 for offset in range(position+8,position+8+size,4)))
                if tag==b'TEXS':
                    for offset in range(position+8,position+8+size,268):
                        name=data[offset+4:offset+264].split(b'\0')[0].decode('utf8')
                        if name:self.assertIn(name.casefold(),imported|native)
                position+=8+size
            self.assertEqual(len(data),position)
        flare={e['after'] for e in manifest['remapped'] if e['before'].casefold()=='textures\\flare.blp'}
        self.assertEqual(2,len(flare))

    def test_explicit_import_appends_without_changing_old_records_or_assets(self):
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory)
            record=b'\x0dwar3mapImported\\Keep.mdx\0'
            old=struct.pack('<II',1,1)+record
            (root/'war3map.imp').write_bytes(old)
            keep=root/'war3mapImported/Keep.mdx';keep.parent.mkdir();keep.write_bytes(b'original user model')
            names=effects.stage_import(PACKET,root)
            manifest=(root/'war3map.imp').read_bytes()
            self.assertEqual(record,manifest[8:8+len(record)])
            self.assertEqual(b'original user model',keep.read_bytes())
            self.assertEqual(len(names),struct.unpack_from('<I',manifest,4)[0])
            self.assertEqual(names,effects.stage_import(PACKET,root))
            self.assertEqual(manifest,(root/'war3map.imp').read_bytes())


if __name__=='__main__':unittest.main()
