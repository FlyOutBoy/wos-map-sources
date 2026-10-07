#!/usr/bin/env python3
"""Run the object and trigger synchronization as one VS Code task."""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path

import war3_object_data as raw
import war3_object_workspace as objects
import sync_war3_triggers as triggers


def world_editor_running() -> bool:
    if os.name != "nt":
        return False
    try:
        result = subprocess.run(
            ["tasklist", "/FI", "IMAGENAME eq World Editor.exe", "/FO", "CSV", "/NH"],
            check=False,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
        )
    except OSError:
        return False
    return '"World Editor.exe"' in result.stdout


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("export", "check", "save", "check-save"))
    parser.add_argument("--config", type=Path, default=Path("object-data.config.json"))
    args = parser.parse_args()
    config = args.config.resolve()
    try:
        options = json.loads(config.read_text(encoding="utf-8-sig"))
        workspace = config.parent
        selected_profile = options.get("test_profile", False)
        if selected_profile:
            import test_map_profile
            context = test_map_profile.ensure(workspace)
            config = test_map_profile.absolute(workspace,context.get("buildDir","_build"))/"test-profile-sync.json"
            options = json.loads(config.read_text(encoding="utf-8-sig"))
        map_dir, output_dir, raw_dir, backup_dir, common_j = objects.load_config(config)
        base = config.parent
        trigger_dir = (base / options.get("trigger_directory", "triggers")).resolve() if "trigger_directory" in options else Path("triggers").resolve()
        trigger_backup = (base / options.get("trigger_backup_directory", "backups/trigger-sync")).resolve() if "trigger_backup_directory" in options else Path("backups/trigger-sync").resolve()
        if args.command != "export" and options.get("prepare_test_sources"):
            powershell = Path(os.environ.get("SystemRoot", "C:/Windows")) / "System32/WindowsPowerShell/v1.0/powershell.exe"
            subprocess.run([str(powershell), "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
                            str(workspace / ".vscode/prepare-test-map.ps1"), "-OutputDirectory", str(trigger_dir.parent),
                            "-StageDirectory", str(trigger_dir)], cwd=workspace, check=True,
                           creationflags=subprocess.CREATE_NO_WINDOW if os.name == "nt" else 0)
        if args.command == "export":
            if selected_profile:
                print(f"TEST profile ready: {map_dir}\nEditable JSON: {output_dir}")
            else:
                objects.export_workspace(map_dir, output_dir, raw_dir, common_j, False)
        if args.command in ("check", "check-save"):
            objects.check_workspace(map_dir, output_dir, raw_dir)
            triggers.check(config, trigger_dir)
        if args.command in ("save", "check-save"):
            if world_editor_running():
                raise ValueError(
                    "World Editor is running. Close the map WITHOUT saving, then run the save task again; "
                    "World Editor does not reload externally changed WTG/WCT files and can overwrite them."
                )
            objects.import_workspace(map_dir, output_dir, raw_dir, backup_dir, common_j, False)
            triggers.push(config, trigger_dir, trigger_backup)
            if selected_profile:
                test_map_profile.powershell(workspace,workspace/".vscode/build-run-w3-map.ps1","-Target","Test","-NoLaunch")
        return 0
    except (raw.FormatError, OSError, ValueError, subprocess.CalledProcessError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
