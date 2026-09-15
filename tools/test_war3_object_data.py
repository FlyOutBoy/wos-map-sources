import json
import shutil
import tempfile
import unittest
from pathlib import Path

import war3_object_data as object_data


PROJECT_ROOT = Path(__file__).resolve().parent.parent


class ObjectDataTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.map_dir, _, _ = object_data.load_config(PROJECT_ROOT / "object-data.config.json")

    def test_real_map_roundtrip_is_exact(self):
        wts = object_data.parse_wts(self.map_dir / "war3map.wts")
        for source in object_data.discover_map_files(self.map_dir):
            original = source.read_bytes()
            kind, mode = object_data.FORMAT_BY_EXTENSION[source.suffix.lower()]
            document = object_data.parse_object_file(original, source.name, kind, mode, wts)
            self.assertEqual(original, object_data.encode_object_file(document, source.name), source.name)

    def test_edited_json_is_validated_backed_up_and_saved(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            map_dir = root / "Map.w3x"
            json_dir = root / "json"
            backup_dir = root / "backups"
            map_dir.mkdir()
            source = self.map_dir / "war3map.w3a"
            shutil.copy2(source, map_dir / source.name)
            shutil.copy2(self.map_dir / "war3map.wts", map_dir / "war3map.wts")

            object_data.export_files(map_dir, json_dir, force=False)
            json_path = json_dir / "abilities.json"
            document = json.loads(json_path.read_text(encoding="utf-8"))
            changed = False
            for obj in document["original_objects"] + document["custom_objects"]:
                for modification in obj["modifications"]:
                    if modification["type"] == "int":
                        modification["data"]["value"] += 1
                        changed = True
                        break
                if changed:
                    break
            self.assertTrue(changed)
            object_data.dump_json(json_path, document)

            original = (map_dir / source.name).read_bytes()
            object_data.import_files(map_dir, json_dir, backup_dir, force=False)
            edited = (map_dir / source.name).read_bytes()
            self.assertNotEqual(original, edited)
            backups = list(backup_dir.glob("*/war3map.w3a"))
            self.assertEqual(1, len(backups))
            self.assertEqual(original, backups[0].read_bytes())
            kind, mode = object_data.FORMAT_BY_EXTENSION[".w3a"]
            parsed = object_data.parse_object_file(edited, source.name, kind, mode, {})
            self.assertEqual(edited, object_data.encode_object_file(parsed, source.name))

            # A second edit/save must not be rejected as an external conflict.
            document["original_objects"][0]["modifications"][2]["data"]["value"] += 1
            object_data.dump_json(json_path, document)
            object_data.import_files(map_dir, json_dir, backup_dir, force=False)
            self.assertNotEqual(edited, (map_dir / source.name).read_bytes())

    def test_editing_resolved_trigger_string_writes_readable_text(self):
        source = self.map_dir / "war3mapSkin.w3a"
        original = source.read_bytes()
        kind, mode = object_data.FORMAT_BY_EXTENSION[source.suffix.lower()]
        document = object_data.parse_object_file(
            original, source.name, kind, mode, object_data.parse_wts(self.map_dir / "war3map.wts")
        )
        target = None
        for obj in document["original_objects"] + document["custom_objects"]:
            for modification in obj["modifications"]:
                data = modification["data"]
                if modification["type"] == "string" and "resolved_value" in data:
                    target = data
                    break
            if target:
                break
        self.assertIsNotNone(target)
        target["resolved_value"] = "Проверка читаемого текста"
        rebuilt = object_data.encode_object_file(document, source.name)
        reparsed = object_data.parse_object_file(rebuilt, source.name, kind, mode, {})
        values = [
            modification["data"].get("value")
            for obj in reparsed["original_objects"] + reparsed["custom_objects"]
            for modification in obj["modifications"]
            if modification["type"] == "string"
        ]
        self.assertIn("Проверка читаемого текста", values)


if __name__ == "__main__":
    unittest.main()
