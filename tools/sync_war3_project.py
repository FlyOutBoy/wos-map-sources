#!/usr/bin/env python3
"""Run the object and trigger synchronization as one VS Code task."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

import war3_object_data as raw
import war3_object_workspace as objects
import sync_war3_triggers as triggers


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("export", "check", "save"))
    parser.add_argument("--config", type=Path, default=Path("object-data.config.json"))
    args = parser.parse_args()
    config = args.config.resolve()
    try:
        map_dir, output_dir, raw_dir, backup_dir, common_j = objects.load_config(config)
        if args.command == "export":
            objects.export_workspace(map_dir, output_dir, raw_dir, common_j, False)
        elif args.command == "check":
            objects.check_workspace(map_dir, output_dir, raw_dir)
            triggers.check(config, Path("triggers").resolve())
        else:
            objects.import_workspace(map_dir, output_dir, raw_dir, backup_dir, common_j, False)
            triggers.push(config, Path("triggers").resolve(), Path("backups/trigger-sync").resolve())
        return 0
    except (raw.FormatError, OSError, ValueError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
