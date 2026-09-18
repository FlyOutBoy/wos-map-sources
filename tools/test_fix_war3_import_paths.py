import hashlib
import json
import struct
import tempfile
import unittest
from pathlib import Path

import fix_war3_import_paths as fixer


class ImportPathFixTests(unittest.TestCase):
    def test_rename_updates_map_project_and_object_hashes(self):
        with tempfile.TemporaryDirectory() as temporary:
            workspace = Path(temporary) / "workspace"
            map_dir = Path(temporary) / "Map.w3x"
            imports = map_dir / "war3mapImported"
            triggers = workspace / "triggers"
            raw_dir = workspace / ".object-data-raw"
            imports.mkdir(parents=True)
            triggers.mkdir(parents=True)
            raw_dir.mkdir(parents=True)

            old_name = "Effect.V1.5.mdx"
            new_name = "Effect_V1_5.mdx"
            import_path = f"war3mapImported\\{old_name}"
            encoded_path = import_path.encode("utf-8")
            (map_dir / "war3map.imp").write_bytes(
                struct.pack("<II", 1, 1) + b"\x0d" + encoded_path + b"\0"
            )
            (imports / old_name).write_bytes(b"MDX DATA")
            binary_path = map_dir / "war3map.w3a"
            binary_path.write_bytes(b"prefix " + old_name.encode() + b" suffix")
            (triggers / "Example.j").write_text(f'call AddSpecialEffect("{import_path}", 0, 0)\n')

            original_digest = hashlib.sha256(binary_path.read_bytes()).hexdigest()
            raw_document = {
                "source_file": "war3map.w3a",
                "source_sha256": original_digest,
                "original_objects": [],
                "custom_objects": [],
            }
            (raw_dir / "abilities.json").write_text(json.dumps(raw_document), encoding="utf-8")
            manifest = {
                "format": "warcraft-3-object-data-manifest-v1",
                "map_directory": str(map_dir),
                "files": [{
                    "json": "abilities.json",
                    "binary": "war3map.w3a",
                    "sha256": original_digest,
                }],
            }
            (raw_dir / "manifest.json").write_text(json.dumps(manifest), encoding="utf-8")

            plan = fixer.build_rename_plan(map_dir)
            self.assertEqual(1, len(plan))
            changed, references = fixer.scan_references(map_dir, workspace, plan)
            fixer.refresh_object_data_hashes(map_dir, workspace, changed)
            backup = fixer.apply_changes(map_dir, workspace, plan, changed, references)
            text_log, json_log = fixer.write_report_logs(
                map_dir, workspace, plan, changed, references, backup
            )

            self.assertFalse((imports / old_name).exists())
            self.assertTrue((imports / new_name).is_file())
            self.assertIn(new_name.encode(), (map_dir / "war3map.imp").read_bytes())
            self.assertIn(new_name.encode(), binary_path.read_bytes())
            self.assertIn(new_name, (triggers / "Example.j").read_text())
            self.assertGreater(sum(value["count"] for value in references[old_name]), 0)
            trigger_reference = next(
                value for value in references[old_name] if value["file"].endswith("Example.j")
            )
            self.assertEqual([1], trigger_reference["lines"])
            new_digest = hashlib.sha256(binary_path.read_bytes()).hexdigest()
            saved_manifest = json.loads((raw_dir / "manifest.json").read_text())
            saved_raw = json.loads((raw_dir / "abilities.json").read_text())
            self.assertEqual(new_digest, saved_manifest["files"][0]["sha256"])
            self.assertEqual(new_digest, saved_raw["source_sha256"])
            self.assertTrue((backup / "manifest.json").is_file())
            self.assertTrue(text_log.is_file())
            self.assertTrue(json_log.is_file())
            self.assertTrue((workspace / "logs" / "import-path-fix" / "latest.txt").is_file())
            self.assertIn(new_name, text_log.read_text(encoding="utf-8"))
            report = json.loads(json_log.read_text(encoding="utf-8"))
            self.assertEqual(1, report["renamed_import_count"])

    def test_repairs_residual_mdl_code_and_blp_path_inside_mdx(self):
        with tempfile.TemporaryDirectory() as temporary:
            workspace = Path(temporary) / "workspace"
            map_dir = Path(temporary) / "Map.w3x"
            imports = map_dir / "war3mapImported"
            triggers = workspace / "triggers"
            imports.mkdir(parents=True)
            triggers.mkdir(parents=True)

            registered = [
                "war3mapImported\\Effect_V1.mdx",
                "war3mapImported\\Texture_V1.blp",
                "war3mapImported\\Carrier.mdx",
            ]
            imp = struct.pack("<II", 1, len(registered))
            for value in registered:
                imp += b"\x0d" + value.encode("utf-8") + b"\0"
            (map_dir / "war3map.imp").write_bytes(imp)
            (imports / "Effect_V1.mdx").write_bytes(b"MDLX")
            (imports / "Texture_V1.blp").write_bytes(b"BLP1")
            carrier = imports / "Carrier.mdx"
            carrier.write_bytes(
                b"MDLX prefix war3mapImported\\Texture.V1.blp\0"
                b"UI\\Glues\\ocean_h.01.blp\0 suffix"
            )
            source = triggers / "Example.j"
            source.write_text(
                'call AddSpecialEffect("war3mapImported\\\\Effect.V1.mdl", 0, 0)\n',
                encoding="utf-8",
            )

            plan = fixer.build_rename_plan(map_dir, workspace)
            mappings = {(item["old_name"], item["new_name"]) for item in plan}
            self.assertIn(("Effect.V1.mdl", "Effect_V1.mdl"), mappings)
            self.assertIn(("Texture.V1.blp", "Texture_V1.blp"), mappings)

            changed, references = fixer.scan_references(map_dir, workspace, plan)
            fixer.apply_changes(map_dir, workspace, plan, changed, references)

            self.assertIn("Effect_V1.mdl", source.read_text(encoding="utf-8"))
            model_data = carrier.read_bytes()
            self.assertIn(b"Texture_V1.blp", model_data)
            self.assertIn(b"ocean_h.01.blp", model_data)
            self.assertNotIn(b"Texture.V1.blp", model_data)
            self.assertTrue((imports / "Effect_V1.mdx").is_file())
            self.assertTrue((imports / "Texture_V1.blp").is_file())


if __name__ == "__main__":
    unittest.main()
