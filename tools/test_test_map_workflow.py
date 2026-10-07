import contextlib
import io
import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import sync_war3_project as project
import test_map_sources as sources
import war3_object_data as raw
import extract_war3_triggers as fmt
import sync_war3_triggers as triggers


class TestSourceStaging(unittest.TestCase):
    def test_resolved_dependencies_enter_editor_payload_without_duplicate_origins(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            base, main, output = root/"test_map/base", root/"triggers", root/"_build/test-sources"
            base.mkdir(parents=True)
            main.mkdir()
            (main/"Systems.j").write_text("library GearSystems\nendlibrary\n")
            (main/"TooltipBuilder.j").write_text("library TooltipBuilder\nendlibrary\n")
            (main/"UniversalTooltips.j").write_text("library AAUniversalTooltips requires GearSystems, TooltipBuilder\nendlibrary\n")
            (base/"Unused.j").write_text("library Snapshot\nendlibrary\n")
            entries = [
                {"path":"Systems_Copy.j","order":0,"enabled":True,"origin":{"kind":"shared","path":"Systems.j"}},
                {"path":"Unused.j","order":1,"enabled":True,"origin":{"kind":"test","reason":"Historical source"}},
            ]
            (base/"test-source-manifest.json").write_text(json.dumps({"format":2,"sources":entries,"enabledImports":[s["path"] for s in entries]}))
            (base/"trigger-manifest.json").write_text(json.dumps({"sources":[]}))
            (base/"trigger-settings.json").write_text(json.dumps({"triggers":{}}))
            sources.stage(root,output)
            report = root/"_build/resolution.json"
            report.write_text(json.dumps({"resolvedSources":[str(main/n) for n in ["Systems.j","TooltipBuilder.j","UniversalTooltips.j"]]}))
            before={p:p.read_bytes() for p in main.glob("*.j")}
            first=sources.include_resolved(root,output,report)
            second=sources.include_resolved(root,output,report)
            self.assertEqual(first,second)
            self.assertTrue(all(Path(p).is_relative_to(output) for p in first["resolvedSources"]))
            self.assertEqual(3,len(set(first["resolvedSources"])))
            self.assertFalse((output/"Systems.j").exists())
            settings=sources.read_json(output/"trigger-settings.json")["triggers"]
            self.assertTrue(settings["TooltipBuilder.j"] and settings["UniversalTooltips.j"])
            self.assertFalse(settings["Unused.j"])
            self.assertEqual([],sources.read_json(output/"dependency-manifest.json")["unresolved_required"])
            self.assertEqual(before,{p:p.read_bytes() for p in main.glob("*.j")})

    def test_shared_freshness_override_and_removed_source(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            base = root / "test_map/base"
            main = root / "triggers"
            output = root / "_build/test-sources"
            base.mkdir(parents=True)
            main.mkdir()
            entries = [
                {"path": "Shared.j", "order": 0, "origin": {"kind": "shared", "path": "Shared.j"}},
                {"path": "Start.j", "order": 1, "origin": {"kind": "test", "reason": "TEST environment"}},
            ]
            (base / "Shared.j").write_text("stale snapshot")
            (base / "Start.j").write_text("test override")
            (main / "Start.j").write_text("main startup")
            (main / "Shared.j").write_text("library Shared\nendlibrary\n")
            (base / "test-source-manifest.json").write_text(json.dumps({"format": 2, "sources": entries, "enabledImports": ["Shared.j", "Start.j"]}))
            (base / "trigger-manifest.json").write_text(json.dumps({"sources": []}))
            (base / "trigger-settings.json").write_text(json.dumps({"triggers": {}}))
            sources.stage(root, output)
            (output / "Removed.j").write_text("obsolete generated source")
            current = "library Shared uses AddedDependency\nendlibrary\n"
            (main / "Shared.j").write_text(current)
            sources.stage(root, output)
            self.assertEqual(current, (output / "Shared.j").read_text())
            self.assertEqual("test override", (output / "Start.j").read_text())
            self.assertEqual("main startup", (main / "Start.j").read_text())
            self.assertEqual("stale snapshot", (base / "Shared.j").read_text())
            self.assertFalse((output / "Removed.j").exists())
            graph = sources.read_json(output / "dependency-manifest.json")
            self.assertEqual("AddedDependency", graph["unresolved_required"][0]["dependency"])
            with self.assertRaises(ValueError):
                sources.stage(root, main)


class ValidateBeforeSave(unittest.TestCase):
    def run_wrapper(self, failure=None):
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        config = Path(directory.name) / "config.json"
        config.write_text("{}")
        calls = []
        def mark(name):
            def callback(*args):
                calls.append(name)
                if failure == name:
                    raise raw.FormatError("invalid fixture")
            return callback
        with patch("sys.argv", ["sync", "--config", str(config), "check-save"]), \
             patch.object(project.objects, "load_config", return_value=(Path("map"),) * 5), \
             patch.object(project.objects, "check_workspace", side_effect=mark("object-check")), \
             patch.object(project.triggers, "check", side_effect=mark("trigger-check")), \
             patch.object(project.objects, "import_workspace", side_effect=mark("object-save")), \
             patch.object(project.triggers, "push", side_effect=mark("trigger-save")), \
             patch.object(project, "world_editor_running", return_value=False), \
             contextlib.redirect_stderr(io.StringIO()):
            result = project.main()
        return result, calls

    def test_both_checks_precede_both_saves(self):
        self.assertEqual((0, ["object-check", "trigger-check", "object-save", "trigger-save"]), self.run_wrapper())

    def test_invalid_objects_block_all_saves(self):
        self.assertEqual((1, ["object-check"]), self.run_wrapper("object-check"))

    def test_invalid_triggers_block_all_saves(self):
        self.assertEqual((1, ["object-check", "trigger-check"]), self.run_wrapper("trigger-check"))


class TestWtgCompatibility(unittest.TestCase):
    def test_added_trigger_keeps_text_and_enabled_flag_in_editor_tree_order(self):
        category = lambda identity, parent=0: {"object_type": fmt.OBJECT_CATEGORY,
            "object_id": identity, "parent_id": parent}
        trigger = lambda identity, parent, enabled: {"object_type": fmt.OBJECT_TRIGGER,
            "object_id": identity, "parent_id": parent, "enabled": enabled}
        # A new tooltip trigger is appended after Systems, but belongs to Start.
        wtg = {"objects": [{"object_type": fmt.OBJECT_MAP_HEADER, "object_id": 0, "parent_id": -1},
            category(0x02000001), trigger(0x03000001, 0x02000001, True),
            category(0x02000002), trigger(0x03000002, 0x02000002, True),
            trigger(0x03000003, 0x02000002, False),
            trigger(0x03000004, 0x02000001, True)]}
        wct = {"sources": [b"startup", b"modern GearSystems", b"old GearSystems", b"tooltip"]}
        paths = ["Start.j", "Systems1.j", "Systems_Copy.j", "TooltipBuilder.j"]
        actual = triggers.order_test_editor_payload(wtg, wct, paths)
        self.assertEqual(["Start.j", "TooltipBuilder.j", "Systems1.j", "Systems_Copy.j"], actual)
        self.assertEqual([b"startup", b"tooltip", b"modern GearSystems", b"old GearSystems"], wct["sources"])
        active = [s for o, s in zip([o for o in wtg["objects"] if o["object_type"] == fmt.OBJECT_TRIGGER],
                                   wct["sources"]) if o["enabled"]]
        self.assertEqual(1, sum(b"GearSystems" in s for s in active))
        self.assertEqual(actual, triggers.order_test_editor_payload(wtg, wct, actual))

    def test_push_new_dependency_triggers_writes_metadata_and_is_idempotent(self):
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory)
            info={name:{"total":0,"deleted_ids":[]} for name in
                  ("map_header","library","category","trigger","comment","script","variable")}
            wtg={"magic_number":"0x80000004","format_version":7,"type_info":info,
                 "unknown":[0,0],"trigger_definition_version":2,"variables":[],"objects":[]}
            (root/"war3map.wtg").write_bytes(triggers.encode_wtg(wtg))
            (root/"war3map.wct").write_bytes(triggers.encode_wct({"magic_number":"0x80000004",
                "format_version":1,"header_comment":"","header_source":b"","sources":[]}))
            (root/"build.json").write_text(json.dumps({"testMapDirectory":str(root)}))
            config=root/"config.json"
            config.write_text(json.dumps({"build_config":"build.json","map_key":"testMapDirectory"}))
            staged=root/"sources/WOS_Start"
            staged.mkdir(parents=True)
            (staged/"TooltipBuilder.j").write_text("library TooltipBuilder\nendlibrary\n")
            (staged/"UniversalTooltips.j").write_text("library AAUniversalTooltips requires TooltipBuilder\nendlibrary\n")
            with contextlib.redirect_stdout(io.StringIO()):
                triggers.push(config,staged.parent,root/"backups")
                first=[(root/f).read_bytes() for f in ["war3map.wtg","war3map.wct"]]
                triggers.push(config,staged.parent,root/"backups")
            self.assertEqual(first,[(root/f).read_bytes() for f in ["war3map.wtg","war3map.wct"]])
            manifest=sources.read_json(staged.parent/"trigger-manifest.json")
            self.assertEqual(2,len([s for s in manifest["sources"] if s["wct_index"] != "map_header"]))
            self.assertEqual([],sources.read_json(staged.parent/"dependency-manifest.json")["unresolved_required"])

    def test_missing_tombstone_is_test_only_and_preserves_counter(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            info = {name: {"total": 0, "deleted_ids": []} for name in
                    ("map_header", "library", "category", "trigger", "comment", "script", "variable")}
            info["category"]["total"] = 2
            wtg = {"magic_number": "0x80000004", "format_version": 7, "type_info": info,
                   "unknown": [0, 0], "trigger_definition_version": 2, "variables": [],
                   "objects": [{"object_type": fmt.OBJECT_CATEGORY, "object_id": 0x02000000,
                                "name": "TEST", "is_category": True, "is_expandable": True, "parent_id": 0}]}
            path = root / "war3map.wtg"
            path.write_bytes(triggers.encode_wtg(wtg))
            (root / "war3map.wct").write_bytes(triggers.encode_wct({"magic_number": "0x80000004",
                "format_version": 1, "header_comment": "", "header_source": b"", "sources": []}))
            with self.assertRaisesRegex(ValueError, "type-count mismatch"):
                fmt.parse_wtg(path)
            self.assertEqual(2, fmt.parse_wtg(path, True)["type_info"]["category"]["total"])
            (root / "build.json").write_text(json.dumps({"testMapDirectory": str(root)}))
            config = root / "config.json"
            config.write_text(json.dumps({"build_config": "build.json", "map_key": "testMapDirectory", "allow_stale_wtg_counts": True}))
            trigger_dir = root / "sources"
            trigger_dir.mkdir()
            result = triggers.prepare(config, trigger_dir)
            repaired = result[1]
            self.assertEqual({"total": 2, "deleted_ids": [1]}, repaired["type_info"]["category"])
            triggers.validate_counts(repaired, result[2])
            path.write_bytes(triggers.encode_wtg(repaired))
            fmt.parse_wtg(path)


if __name__ == "__main__":
    unittest.main()
