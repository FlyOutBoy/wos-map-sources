"""Native TEST updates must ignore stale imports and assets in extracted caches."""
from pathlib import Path
import json
import os
import struct
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import test_map_profile as profiles

ROOT = Path(__file__).resolve().parents[1]


@unittest.skipUnless(os.name == 'nt', 'Bundled Windows SFmpq')
class TestImportPreservation(unittest.TestCase):
    def test_refresh_reads_editor_objects_but_preserves_imports_code_and_json(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            cache = root/'test_map/profiles/Frostnova/unpacked'
            cache.mkdir(parents=True)
            original = {'war3map.imp':b'current user imports', 'war3map.wct':b'current project code',
                        'custom.mdx':b'current custom model', 'war3map.w3t':b'removed object file'}
            for name, data in original.items():
                (cache/name).write_bytes(data)
            editable = cache.parent/'object-data/units.json'
            editable.parent.mkdir()
            editable.write_bytes(b'local JSON edits')
            context = {'testMapDirectory':str(cache), 'testMap':str(root/'Saved.w3x'),
                       'jassHelper':'utility/JassHelper/jasshelper.exe'}
            def extract(_, script, *args):
                destination = Path(args[args.index('-Directory')+1])
                (destination/'war3map.w3u').write_bytes(b'fresh WE model binding')
                (destination/'war3map.wct').write_bytes(b'old map code')
                (destination/'war3map.imp').write_bytes(b'stale imports')
            with patch.object(profiles, 'powershell', side_effect=extract):
                profiles.refresh_objects(root, context)
            self.assertEqual(b'fresh WE model binding', (cache/'war3map.w3u').read_bytes())
            self.assertFalse((cache/'war3map.w3t').exists())
            self.assertEqual(b'local JSON edits', editable.read_bytes())
            for name in ('war3map.imp', 'war3map.wct', 'custom.mdx'):
                self.assertEqual(original[name], (cache/name).read_bytes())

    def test_default_update_preserves_custom_files_and_does_not_revive_deleted_imports(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source, staged, output = root/'source', root/'staged', root/'extracted'
            source.mkdir()
            staged.mkdir()
            imported = {'war3map.imp':struct.pack('<II',1,0),
                        'custom/model.mdx':b'user model', 'custom/skin.blp':b'user skin'}
            native = {'war3map.wtg':b'wtg fixture', 'war3map.wct':b'wct fixture',
                      'war3map.w3a':b'old native data', 'war3map.j':b'call SetPlayers(1)',
                      'war3map.w3i':struct.pack('<III',25,0,0)+b'Test\0Author\0Description\0Players\0'+bytes(64)}
            for name, data in {**native, **imported}.items():
                path = source/name
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_bytes(data)
            archive = root/'Test.w3x'
            shell = Path(os.environ['WINDIR'])/'System32/WindowsPowerShell/v1.0/powershell.exe'
            def run(mode, folder, *extra):
                result = subprocess.run([str(shell),'-NoProfile','-ExecutionPolicy','Bypass','-File',
                    str(ROOT/'.vscode/test-map-archive.ps1'),'-Mode',mode,'-Map',str(archive),
                    '-Directory',str(folder),'-Library',str(ROOT/'utility/JassHelper/sfmpq.dll'),*extra],
                    cwd=ROOT, capture_output=True, timeout=20)
                self.assertEqual(0,result.returncode,result.stdout.decode(errors='replace')+result.stderr.decode(errors='replace'))
            run('Pack', source)
            for name in [*imported, 'custom/deleted-in-editor.blp', 'war3map.wtg', 'war3map.wct', 'war3map.w3a']:
                path = staged/name
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_bytes(b'stale cache' if name in imported or name.endswith('.blp') else b'new native data')
            run('Update', staged)
            names = root/'names.json'
            names.write_text(json.dumps([*imported, 'war3map.w3a', '(listfile)']))
            run('Extract', output, '-NamesFile', str(names))
            for name, data in imported.items():
                self.assertEqual(data, (output/name).read_bytes(), name)
            self.assertEqual(b'new native data', (output/'war3map.w3a').read_bytes())
            self.assertNotIn('deleted-in-editor', (output/'(listfile)').read_text())

            # Expanding a saved archive must preserve every named payload,
            # including opaque files, without collecting unrelated cache files.
            (source/'conversation.json').write_bytes(b'opaque saved payload')
            unicode_name='war3mapImported/freezingsplinter体.mdx'
            (source/'war3mapImported').mkdir()
            (source/unicode_name).write_bytes(b'original Unicode effect name')
            (source/'stale-cache.blp').write_bytes(b'do not import')
            explicit = root/'pack-names.json'
            explicit.write_text(json.dumps([*native, *imported, 'conversation.json',unicode_name]))
            run('Pack', source, '-NamesFile', str(explicit))
            names.write_text(json.dumps(['conversation.json', unicode_name,'(listfile)']))
            run('Extract', output, '-NamesFile', str(names))
            self.assertEqual(b'opaque saved payload', (output/'conversation.json').read_bytes())
            self.assertEqual(b'original Unicode effect name',(output/unicode_name).read_bytes())
            self.assertNotIn('stale-cache', (output/'(listfile)').read_text())


if __name__ == '__main__':
    unittest.main()
