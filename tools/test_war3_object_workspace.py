import json
import shutil
import tempfile
import unittest
from pathlib import Path

import war3_object_data as raw
import war3_object_workspace as workspace


PROJECT_ROOT = Path(__file__).resolve().parent.parent


class UnifiedWorkspaceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.map_dir, _, _, _, cls.common_j = workspace.load_config(PROJECT_ROOT / "object-data.config.json")

    def test_ability_has_name_tooltips_and_gameplay_together(self):
        output_dir = PROJECT_ROOT / "object-data"
        document = json.loads((output_dir / "abilities.json").read_text(encoding="utf-8"))
        ability = document["A000"]
        self.assertEqual("Hoyoverse Raiden Ei Q", ability["name"])
        self.assertTrue(
            {
                "tooltip level 1", "extended_tooltip level 1", "mana_cost level 1",
                "cooldown level 1", "cast_range level 1", "base_order_id level 1",
                "follow_through_time level 1", "options level 1", "target_type level 1",
                "target_attachment_point_1",
            }
            <= set(ability)
        )
        self.assertNotIn("fields", ability)
        self.assertNotIn("field_id", json.dumps(ability))
        self.assertNotIn("data_pointer", json.dumps(ability))

    def test_convenient_edit_saves_to_both_binary_files(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            map_dir = root / "Map.w3x"
            output_dir = root / "objects"
            raw_dir = root / "raw"
            backup_dir = root / "backups"
            map_dir.mkdir()
            for name in ("war3map.w3a", "war3mapSkin.w3a", "war3map.wts"):
                shutil.copy2(self.map_dir / name, map_dir / name)

            workspace.export_workspace(map_dir, output_dir, raw_dir, self.common_j, force=False)
            path = output_dir / "abilities.json"
            document = json.loads(path.read_text(encoding="utf-8"))
            ability = document["A000"]
            ability["name"] = "Проверочное название"
            ability["cooldown level 1"] = "12.5"
            raw.dump_json(path, document)

            with self.assertRaises(raw.FormatError):
                workspace.export_workspace(map_dir, output_dir, raw_dir, self.common_j, force=False)
            # Simulate World Editor saving an unrelated field after export.
            kind, mode = raw.FORMAT_BY_EXTENSION[".w3a"]
            skin_path = map_dir / "war3mapSkin.w3a"
            editor_skin = raw.parse_object_file(skin_path.read_bytes(), skin_path.name, kind, mode, {})
            editor_a001 = next(obj for obj in editor_skin["custom_objects"] if obj["new_id"]["text"] == "A001")
            editor_icon = next(mod for mod in editor_a001["modifications"] if mod["field"]["text"] == "aart")
            editor_icon["data"]["value"] = "ReplaceableTextures\\CommandButtons\\BTNRebaseTest.blp"
            skin_path.write_bytes(raw.encode_object_file(editor_skin, skin_path.name))

            workspace.check_workspace(map_dir, output_dir, raw_dir)
            workspace.import_workspace(map_dir, output_dir, raw_dir, backup_dir, self.common_j, force=False)

            main_data = (map_dir / "war3map.w3a").read_bytes()
            main = raw.parse_object_file(main_data, "war3map.w3a", kind, mode, {})
            a000 = next(obj for obj in main["custom_objects"] if obj["new_id"]["text"] == "A000")
            saved_cooldown = next(
                mod for mod in a000["modifications"]
                if mod["field"]["text"] == "acdn" and mod["level"] == 1
            )
            self.assertEqual(12.5, saved_cooldown["data"]["value"])

            skin_data = (map_dir / "war3mapSkin.w3a").read_bytes()
            skin = raw.parse_object_file(skin_data, "war3mapSkin.w3a", kind, mode, {})
            skin_a000 = next(obj for obj in skin["custom_objects"] if obj["new_id"]["text"] == "A000")
            saved_name = next(mod for mod in skin_a000["modifications"] if mod["field"]["text"] == "anam")
            self.assertEqual("Проверочное название", saved_name["data"]["value"])
            skin_a001 = next(obj for obj in skin["custom_objects"] if obj["new_id"]["text"] == "A001")
            saved_icon = next(mod for mod in skin_a001["modifications"] if mod["field"]["text"] == "aart")
            self.assertEqual("ReplaceableTextures\\CommandButtons\\BTNRebaseTest.blp", saved_icon["data"]["value"])
            self.assertEqual(2, len(list(backup_dir.glob("*/*.w3a"))))


if __name__ == "__main__":
    unittest.main()
