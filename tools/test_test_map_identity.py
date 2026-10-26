"""Renaming variable-length native names must preserve other map metadata."""
from pathlib import Path
import struct
import tempfile
import unittest

import test_map_identity as identity


class MapIdentity(unittest.TestCase):
    def test_w3i_rename_preserves_version_header_and_every_trailing_field(self):
        for version, offset in ((25, 12), (28, 28), (31, 28)):
            prefix = struct.pack('<I', version) + b'\x17'*(offset-4)
            tail = b'\0Author\0Description\0Suggested players\0' + bytes(range(256))
            renamed = identity.rename_info(prefix+b'TRIGSTR_020'+tail, 'Frostnova — TEST')
            self.assertEqual(prefix+'Frostnova — TEST'.encode()+tail, renamed)
            self.assertEqual(renamed, identity.rename_info(renamed, 'Frostnova — TEST'))

    def test_source_encoding_and_failed_validation_preserve_generated_files(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            info, source = root/'war3map.w3i', root/'Test.vj'
            original = struct.pack('<III',25,0,0)+b'Old name\0Other fields'
            info.write_bytes(original)
            source.write_bytes(b'\xef\xbb\xbffunction config takes nothing returns nothing\r\n    call SetMapName("TRIGSTR_020")\r\nendfunction\r\n')
            identity.rename_staged(root, source, 'Frostnova — TEST')
            result = source.read_bytes()
            self.assertTrue(result.startswith(b'\xef\xbb\xbf'))
            self.assertIn('SetMapName("Frostnova — TEST")\r\n'.encode(), result)
            source.write_bytes(b'// missing config')
            before = info.read_bytes()
            with self.assertRaises(ValueError):
                identity.rename_staged(root, source, 'Another — TEST')
            self.assertEqual(before, info.read_bytes())

    def test_lobby_header_keeps_flags_players_and_archive_payload_unchanged(self):
        with tempfile.TemporaryDirectory() as directory:
            archive = Path(directory)/'Map.w3x'
            flags = struct.pack('<II', 12345, 10)
            payload = b'MPQ\x1a'+bytes(range(256))*3
            archive.write_bytes((b'HM3W'+b'\0'*4+b'Old\0'+flags).ljust(512,b'\0')+payload)
            identity.rename_archive_header(archive, 'Frostnova — TEST')
            data = archive.read_bytes()
            self.assertEqual(payload, data[512:])
            end = data.index(b'\0',8)
            self.assertEqual('Frostnova — TEST', data[8:end].decode())
            self.assertEqual(flags, data[end+1:end+9])
            archive.write_bytes(payload)
            identity.rename_archive_header(archive, 'Frostnova — TEST')
            self.assertEqual(payload, archive.read_bytes())


if __name__ == '__main__':
    unittest.main()
