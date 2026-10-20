"""Combined tasks must stop on validation errors and recover partial MAIN imports."""
from pathlib import Path
import os
import shutil
import struct
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import wos_map_workflow as workflow


class MapWorkflow(unittest.TestCase):
    def test_save_precedes_one_build_and_optional_launch(self):
        for target in ("Main", "Test"):
            for no_launch in (False, True):
                with self.subTest(target=target, no_launch=no_launch), patch.object(workflow, "run") as run:
                    workflow.build(Path("workspace"), target, no_launch)
                    self.assertEqual(2, run.call_count)
                    save, build = [call.args for call in run.call_args_list]
                    self.assertEqual("tools/sync_war3_project.py", save[1])
                    self.assertIn("object-data.test.config.json" if target == "Test" else "object-data.config.json", str(save[3]))
                    self.assertEqual(("check-save", "--no-build"), save[-2:])
                    self.assertEqual(".vscode/build-run-w3-map.ps1", build[1])
                    self.assertEqual(target, build[3])
                    self.assertEqual(no_launch, "-NoLaunch" in build)

    def test_save_failure_prevents_compiler_and_game_launch(self):
        with patch.object(workflow, "run", side_effect=subprocess.CalledProcessError(1, "check-save")) as run:
            with self.assertRaises(subprocess.CalledProcessError):
                workflow.build(Path("workspace"), "Test", False)
            self.assertEqual(1, run.call_count)

    def test_test_import_uses_selected_archive_and_does_not_touch_main(self):
        with patch.object(workflow, "run") as run:
            workflow.receive(Path("workspace"), "Test", "All", None, True)
            self.assertEqual(1, run.call_count)
            self.assertEqual((Path("workspace"), ".vscode/import-test-map.ps1", "-Mode", "All", "-ValidateOnly"), run.call_args.args)

    def test_bad_main_objects_prevent_any_project_replacement(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root/"map"
            source.mkdir()
            calls = []
            def run(*args):
                calls.append(args)
                self.assertIn("-ValidateOnly", args)
                if "object-data" in args[1]:
                    raise subprocess.CalledProcessError(1, "invalid objects")
            with patch.object(workflow, "run", side_effect=run):
                with self.assertRaises(subprocess.CalledProcessError):
                    workflow.receive(root, "Main", "All", source, False)
            self.assertEqual(2, len(calls))
            self.assertFalse((root/"backups").exists())

    def test_partial_main_import_restores_code_objects_and_absent_files(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root/"map"
            source.mkdir()
            before = {"triggers/Hero.j": b"current hero", "object-data/units.json": b"local JSON",
                      ".object-data-raw/manifest.json": b"metadata", "map_source/Main.vj": b"template",
                      "war3map.wct": b"original WCT"}
            for name, content in before.items():
                path = root/name
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_bytes(content)
            applied = []
            def run(_, script, *args):
                if "-ValidateOnly" in args:
                    return
                applied.append(script)
                (root/"triggers/Hero.j").write_bytes(b"replaced code")
                (root/"war3map.j").write_bytes(b"new file")
                if "object-data" in script:
                    (root/"object-data/units.json").write_bytes(b"partly replaced JSON")
                    raise subprocess.CalledProcessError(1, "disk failure fixture")
            with patch.object(workflow, "run", side_effect=run):
                with self.assertRaises(subprocess.CalledProcessError):
                    workflow.receive(root, "Main", "All", source, False)
            self.assertEqual(2, len(applied))
            for name, content in before.items():
                self.assertEqual(content, (root/name).read_bytes(), name)
            self.assertFalse((root/"war3map.j").exists())
            self.assertEqual(1, len(list((root/"backups/project-import").glob("*/failed/triggers/Hero.j"))))

    def test_validate_only_never_applies_main_import(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            with patch.object(workflow, "run") as run:
                workflow.receive(root, "Main", "All", root, True)
            self.assertEqual(2, run.call_count)
            self.assertTrue(all("-ValidateOnly" in call.args for call in run.call_args_list))
            self.assertFalse((root/"backups").exists())

    def test_restore_paths_cannot_escape_workspace(self):
        with tempfile.TemporaryDirectory() as directory:
            with self.assertRaises(ValueError):
                workflow.project_path(Path(directory), "../outside")

    @unittest.skipUnless(os.name == "nt", "Windows object importer")
    def test_real_object_import_validation_and_project_id_preservation(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for relative in (".vscode/import-object-data-from-map.ps1", "tools/war3_object_workspace.py",
                             "tools/war3_object_data.py", "libs/common.j"):
                target = root/relative
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(workflow.ROOT/relative, target)
            source = root/"Map.w3x"
            source.mkdir()
            # Empty, valid v2 unit data; converter still emits all seven categories.
            (source/"war3map.w3u").write_bytes(struct.pack("<iii", 2, 0, 0))
            local = root/"object-data"
            local.mkdir()
            (local/"units.json").write_bytes(b"local edits")
            (local/"frostnova-ids.json").write_bytes(b'{"hero":"H002"}')
            with patch.object(workflow.subprocess, "run", wraps=subprocess.run) as run:
                workflow.run(root, ".vscode/import-object-data-from-map.ps1", "-MapDirectory", str(source), "-ValidateOnly")
                self.assertEqual(b"local edits", (local/"units.json").read_bytes())
                self.assertFalse((root/"object-data-backups").exists())
                workflow.run(root, ".vscode/import-object-data-from-map.ps1", "-MapDirectory", str(source))
                self.assertEqual(2, run.call_count)
            self.assertEqual(b'{"hero":"H002"}', (local/"frostnova-ids.json").read_bytes())
            self.assertNotEqual(b"local edits", (local/"units.json").read_bytes())
            self.assertEqual(1, len(list((root/"object-data-backups").glob("*/object-data/units.json"))))


if __name__ == "__main__":
    unittest.main()
