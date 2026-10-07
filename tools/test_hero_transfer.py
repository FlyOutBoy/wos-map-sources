import contextlib
import io
import json
import shutil
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import hero_transfer as transfer


ROOT = Path(__file__).resolve().parents[1]
HERO = "TransferFixture"


class HeroTransferTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.workspace = Path(self.directory.name).resolve()
        self.source = self.workspace / "test_map/heroes" / f"{HERO}.j"
        self.source.parent.mkdir(parents=True)
        # Exercise real picker/build insertion anchors, with an unregistered hero.
        for relative in (
            "WOS_Start/BuildsForChars.j", "WOS_Start/WoS_Pick_Init.j",
            "Systems/Systems1.j", "Systems/Death.j", "Systems/LvlUpCheck.j",
        ):
            destination = self.workspace / "triggers" / relative
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(ROOT / "triggers" / relative, destination)
        self.payload = (
            "\ufefflibrary TransferFixtureSpells\r\nglobals\r\n"
            + "\r\n".join(
                f"integer {HERO}{slot}_ID = '{rawcode}'"
                for slot, rawcode in (("", "Z00A"), ("Q", "A000"), ("W", "A001"),
                                      ("E", "A002"), ("R", "A003"), ("T", "A004"),
                                      ("F", "A01V"), ("G", "A01U"))
            )
            + "\r\nendglobals\r\n// Latest TEST code\r\nendlibrary\r\n"
        ).encode("utf-8")
        self.source.write_bytes(self.payload)
        self.destination = self.workspace / "triggers/Heroes" / f"{HERO}.j"
        self.settings = self.workspace / "triggers/trigger-settings.json"
        self.settings.write_text(json.dumps({"triggers": {"Unrelated.j": False}}))
        items = self.workspace / "object-data/items.json"
        items.parent.mkdir()
        items.write_text(json.dumps({code: {"name": code} for code in transfer.DEFAULT_ITEMS}))

    def run_transfer(self, source=None, dry_run=False):
        args = ["hero_transfer", "--workspace", str(self.workspace), "--hero-file",
                str(source or self.source), "--category", "4", "--difficulty", "1",
                "--items", "default", "--yes"]
        if dry_run:
            args.append("--dry-run")
        self.output = io.StringIO()
        with patch("sys.argv", args), contextlib.redirect_stdout(self.output), \
             contextlib.redirect_stderr(self.output):
            return transfer.main()

    def snapshot(self):
        return {path.relative_to(self.workspace): path.read_bytes()
                for path in self.workspace.rglob("*") if path.is_file()}

    def test_test_source_replaces_stale_main_and_backs_it_up(self):
        self.destination.parent.mkdir()
        self.destination.write_bytes(b"// stale MAIN code\n")
        self.assertEqual(0, self.run_transfer())
        self.assertEqual(self.payload, self.destination.read_bytes())
        self.assertEqual(self.payload, self.source.read_bytes())
        settings = json.loads(self.settings.read_text())["triggers"]
        self.assertTrue(settings[f"Heroes/{HERO}.j"])
        self.assertFalse(settings["Unrelated.j"])
        backups = list((self.workspace / "backups/hero-transfer").glob(f"*/triggers/Heroes/{HERO}.j"))
        self.assertEqual([b"// stale MAIN code\n"], [path.read_bytes() for path in backups])
        picker = (self.workspace / "triggers/WOS_Start/WoS_Pick_Init.j").read_text(encoding="utf-8-sig")
        self.assertIn(f"HERO TRANSFER: {HERO} / OnClick details", picker)
        self.assertIn(transfer.DIFFICULTIES[1][1], picker)

    def test_new_main_source_is_created_and_recorded_for_recovery(self):
        self.assertEqual(0, self.run_transfer())
        self.assertEqual(self.payload, self.destination.read_bytes())
        created = list((self.workspace / "backups/hero-transfer").glob("*/created-files.json"))
        self.assertEqual([f"triggers/Heroes/{HERO}.j"], json.loads(created[0].read_text()))

    def test_dry_run_with_missing_destination_changes_nothing(self):
        before = self.snapshot()
        self.assertEqual(0, self.run_transfer(dry_run=True))
        self.assertIn(str(self.destination), self.output.getvalue())
        self.assertEqual(before, self.snapshot())

    def test_repeat_transfer_updates_latest_code_without_duplicate_registration(self):
        self.assertEqual(0, self.run_transfer())
        registry = (self.workspace / "triggers/WOS_Start/BuildsForChars.j").read_bytes()
        self.payload += b"// New TEST revision\r\n"
        self.source.write_bytes(self.payload)
        self.assertEqual(0, self.run_transfer())
        self.assertEqual(self.payload, self.destination.read_bytes())
        self.assertEqual(registry, (self.workspace / "triggers/WOS_Start/BuildsForChars.j").read_bytes())
        before = self.snapshot()
        self.assertEqual(0, self.run_transfer())
        self.assertIn("ALREADY APPLIED", self.output.getvalue())
        self.assertEqual(before, self.snapshot())

    def test_existing_main_source_keeps_original_location_and_is_enabled(self):
        main = self.workspace / "triggers/Heroes/Existing" / f"{HERO}.j"
        main.parent.mkdir(parents=True)
        main.write_bytes(self.payload)
        self.settings.write_text(json.dumps({"triggers": {f"Heroes/Existing/{HERO}.j": False}}))
        self.assertEqual(0, self.run_transfer(main))
        self.assertEqual(self.payload, main.read_bytes())
        self.assertFalse(self.destination.exists())
        self.assertTrue(json.loads(self.settings.read_text())["triggers"][f"Heroes/Existing/{HERO}.j"])

    def test_relative_selected_path_uses_supplied_workspace(self):
        self.assertEqual(0, self.run_transfer(self.source.relative_to(self.workspace)))
        self.assertEqual(self.payload, self.destination.read_bytes())

    def test_invalid_registration_anchor_leaves_main_and_test_untouched(self):
        picker = self.workspace / "triggers/WOS_Start/WoS_Pick_Init.j"
        picker.write_text("// missing picker functions\n")
        before = self.snapshot()
        self.assertEqual(1, self.run_transfer())
        self.assertEqual(before, self.snapshot())

    def test_write_failure_restores_existing_files_and_removes_new_hero(self):
        before = self.snapshot()
        real_replace = Path.replace
        failed = False

        def fail_second_write(path, target):
            nonlocal failed
            if Path(target).name == "BuildsForChars.j" and not failed:
                failed = True
                raise OSError("injected write failure")
            return real_replace(path, target)

        with patch.object(Path, "replace", fail_second_write):
            self.assertEqual(1, self.run_transfer())
        after = {path: data for path, data in self.snapshot().items() if path.parts[0] != "backups"}
        self.assertEqual(before, after)
        self.assertFalse(self.destination.exists())
        self.assertFalse(list(self.workspace.rglob("*.hero-transfer.tmp")))


if __name__ == "__main__":
    unittest.main()
