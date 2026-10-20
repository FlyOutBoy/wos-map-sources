#!/usr/bin/env python3
"""VS Code map workflows: receive saved editor data, or save/build/run the project."""
from __future__ import annotations

import argparse
from datetime import datetime
import os
from pathlib import Path
import shutil
import subprocess
import sys

import war3_object_workspace as objects


ROOT = Path(__file__).resolve().parents[1]


def run(root: Path, script: str, *args: str) -> None:
    path = root / script
    if path.suffix == ".ps1":
        shell = Path(os.environ.get("WINDIR", "C:/Windows")) / "System32/WindowsPowerShell/v1.0/powershell.exe"
        command = [str(shell), "-NoProfile", "-ExecutionPolicy", "Bypass", "-STA", "-File", str(path)]
    else:
        command = [sys.executable, str(path)]
    subprocess.run([*command, *args], cwd=root, check=True)


def build(root: Path, target: str, no_launch: bool) -> None:
    config = "object-data.test.config.json" if target == "Test" else "object-data.config.json"
    # TEST check-save normally builds itself. Suppress that one build so the
    # common builder below compiles/packs once and launches only after success.
    run(root, "tools/sync_war3_project.py", "--config", str(root/config), "check-save", "--no-build")
    run(root, ".vscode/build-run-w3-map.ps1", "-Target", target, *(["-NoLaunch"] if no_launch else []))


def choose_map() -> Path | None:
    shell = Path(os.environ.get("WINDIR", "C:/Windows")) / "System32/WindowsPowerShell/v1.0/powershell.exe"
    code = """
Add-Type -AssemblyName System.Windows.Forms
$dialog = New-Object System.Windows.Forms.FolderBrowserDialog
$dialog.Description = 'Select the saved, unpacked MAIN map folder'
$dialog.ShowNewFolderButton = $false
if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    [Console]::OutputEncoding = [Text.UTF8Encoding]::new($false)
    [Console]::WriteLine($dialog.SelectedPath)
}
"""
    result = subprocess.run([str(shell), "-NoProfile", "-STA", "-Command", code], check=True,
                            capture_output=True, encoding="utf-8")
    return Path(result.stdout.strip()) if result.stdout.strip() else None


def project_path(root: Path, relative: str) -> Path:
    path = (root/relative).resolve()
    if not path.is_relative_to(root.resolve()) or path == root.resolve():
        raise ValueError(f"Import destination must stay within the workspace: {path}")
    return path


def receive(root: Path, target: str, mode: str, source: Path | None, validate_only: bool) -> None:
    if target == "Test":
        if source is not None:
            raise ValueError("TEST reads the selected testHero archive; --map-directory is for MAIN")
        run(root, ".vscode/import-test-map.ps1", "-Mode", mode,
            *(["-ValidateOnly"] if validate_only else []))
        return

    if source is None:
        source = objects.load_config(root/"object-data.config.json")[0]
    source = source.resolve()
    if not source.is_dir():
        raise ValueError(f"MAIN import requires a saved, unpacked map folder: {source}")
    stages = []
    if mode in ("All", "Code"):
        stages.append((".vscode/import-triggers-and-code-from-map.ps1", ["-Target", "Main"]))
    if mode in ("All", "Data"):
        stages.append((".vscode/import-object-data-from-map.ps1", []))
    print(f"MAIN map -> project ({mode}): {source}", flush=True)
    # Decode/check BOTH incoming datasets, including compiled/source parity,
    # before either importer is allowed to replace project files.
    for script, args in stages:
        run(root, script, *args, "-MapDirectory", str(source), "-ValidateOnly")
    if validate_only:
        return

    paths = []
    if mode in ("All", "Code"):
        paths += ["triggers", "map_source/Main.vj", "war3map.j", "war3map.wtg", "war3map.wct"]
    if mode in ("All", "Data"):
        paths += ["object-data", ".object-data-raw"]
    backup = project_path(root, "backups/project-import/" + datetime.now().strftime("%Y%m%d-%H%M%S-%f"))
    backup.mkdir(parents=True)
    existed = {}
    for relative in paths:
        current = project_path(root, relative)
        existed[relative] = current.exists()
        if current.exists():
            saved = backup/"before"/relative
            saved.parent.mkdir(parents=True, exist_ok=True)
            if current.is_dir():
                shutil.copytree(current, saved)
            else:
                shutil.copy2(current, saved)
    try:
        for script, args in stages:
            run(root, script, *args, "-MapDirectory", str(source))
    except (OSError, subprocess.CalledProcessError):
        # Preserve failed output too; restore the complete selected project set.
        for relative in paths:
            current = project_path(root, relative)
            if current.exists():
                failed = project_path(root, str((backup/"failed"/relative).relative_to(root)))
                failed.parent.mkdir(parents=True, exist_ok=True)
                shutil.move(str(current), str(failed))
            if existed[relative]:
                saved = backup/"before"/relative
                current.parent.mkdir(parents=True, exist_ok=True)
                if saved.is_dir():
                    shutil.copytree(saved, current)
                else:
                    shutil.copy2(saved, current)
        print(f"Import failed; project restored. Backup: {backup}", file=sys.stderr)
        raise
    print(f"MAIN import OK. Complete project backup: {backup}")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("receive", "build"))
    parser.add_argument("--target", choices=("Main", "Test"), required=True)
    parser.add_argument("--mode", choices=("All", "Code", "Data"), default="All")
    source = parser.add_mutually_exclusive_group()
    source.add_argument("--map-directory", type=Path)
    source.add_argument("--choose-map", action="store_true")
    parser.add_argument("--validate-only", action="store_true")
    parser.add_argument("--no-launch", action="store_true")
    args = parser.parse_args()
    if args.command == "build" and (args.validate_only or args.map_directory or args.choose_map or args.mode != "All"):
        parser.error("build accepts only --target and --no-launch")
    if args.command == "receive" and args.no_launch:
        parser.error("--no-launch is a build option")
    if args.target == "Test" and (args.map_directory or args.choose_map):
        parser.error("TEST reads the selected testHero archive")
    try:
        if args.command == "build":
            build(ROOT, args.target, args.no_launch)
        else:
            selected = choose_map() if args.choose_map else args.map_directory
            if args.choose_map and selected is None:
                print("Map import cancelled.")
                return 0
            receive(ROOT, args.target, args.mode, selected, args.validate_only)
        return 0
    except (OSError, ValueError, subprocess.CalledProcessError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
