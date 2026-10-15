import unittest,tempfile,struct,json,shutil,hashlib
from pathlib import Path
from install_team_ping_assets import install_models,ROOT
class Models(unittest.TestCase):
 def test_install_registers_exact_paths_and_idempotent_bytes(self):
  with tempfile.TemporaryDirectory() as t:
   p=Path(t);m=p/'map';m.mkdir();(m/'war3map.imp').write_bytes(struct.pack('<II',1,0));install_models(m,backup_root=p/'backup');manifest=json.loads((ROOT/'assets/TeamPings/models/manifest.json').read_text());self.assertEqual(len(manifest),11)
   for e in manifest:self.assertEqual(hashlib.sha256((m/e['import'].replace('\\','/')).read_bytes()).hexdigest(),e['sha256']);self.assertIn(e['import'].encode()+b'\0',(m/'war3map.imp').read_bytes())
   old=(m/'war3map.imp').read_bytes();install_models(m,backup_root=p/'backup');self.assertEqual((m/'war3map.imp').read_bytes(),old);self.assertEqual(len(list((p/'backup').iterdir())),1)
 def test_changed_asset_hash_rejected_before_mutation(self):
  with tempfile.TemporaryDirectory() as t:
   p=Path(t);source=p/'source';shutil.copytree(ROOT/'assets/TeamPings/models',source);next(source.rglob('*.mdx')).write_bytes(b'wrong');m=p/'map';m.mkdir();old=struct.pack('<II',1,0);(m/'war3map.imp').write_bytes(old)
   with self.assertRaises(ValueError):install_models(m,source,p/'backup')
   self.assertEqual(list(m.iterdir()),[m/'war3map.imp']);self.assertEqual((m/'war3map.imp').read_bytes(),old)
 def test_imported_mdx_dependencies_resolve_and_paths_are_canonical(self):
  source=ROOT/'assets/TeamPings/models';entries=json.loads((source/'manifest.json').read_text());names={e['import'].lower() for e in entries};self.assertEqual(sum(e['import'].endswith('.mdx') for e in entries),5)
  for p in source.rglob('*.mdx'):
   d=p.read_bytes();self.assertEqual(d[:4],b'MDLX');pos=4
   while pos<len(d):
    tag=d[pos:pos+4];n=struct.unpack_from('<I',d,pos+4)[0];self.assertLessEqual(pos+8+n,len(d))
    if tag==b'TEXS':
     for off in range(pos+8,pos+8+n,268):
      path=d[off+4:off+264].split(b'\0')[0].decode('ascii');self.assertNotIn('\\\\',path);self.assertTrue(path.lower() in names or path=='UI\\MiniMap\\ping6.blp',path)
    pos+=8+n
   self.assertEqual(pos,len(d))
if __name__=='__main__':unittest.main()
