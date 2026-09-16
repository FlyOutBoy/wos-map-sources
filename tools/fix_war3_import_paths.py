#!/usr/bin/env python3
"""Safely rename dotted Warcraft imports and update every matching reference."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import struct
import sys
from collections import defaultdict
from datetime import datetime
from pathlib import Path


class FixError(RuntimeError):
    pass


PROJECT_SCAN_DIRECTORIES = (
    "triggers",
    "map_source",
    "object-data",
    ".object-data-raw",
    "test_map",
)
PROJECT_SCAN_FILES = (
    "war3map.j",
    "war3map.wtg",
    "war3map.wct",
    "warcraft.json",
)
SKIP_DIRECTORY_NAMES = {
    ".git", "_build", ".build", "backups", "object-data-backups", "__pycache__", "logs",
}
FIXABLE_EXTENSIONS = {".blp", ".mdx"}
TEXT_LINE_EXTENSIONS = {".fdf", ".ini", ".j", ".json", ".md", ".toc", ".txt", ".vj", ".wts"}


def read_c_string(data: bytes, offset: int) -> tuple[bytes, int]:
    end = data.find(b"\0", offset)
    if end < 0:
        raise FixError("war3map.imp contains an unterminated import path")
    return data[offset:end], end + 1


def decode_path(value: bytes) -> str:
    for encoding in ("utf-8", "cp1251", "cp1252"):
        try:
            return value.decode(encoding)
        except UnicodeDecodeError:
            pass
    raise FixError(f"cannot decode import path bytes: {value!r}")


def parse_imp(path: Path) -> list[str]:
    try:
        data = path.read_bytes()
    except OSError as exc:
        raise FixError(f"cannot read {path}: {exc}") from exc
    if len(data) < 8:
        raise FixError(f"invalid war3map.imp (too small): {path}")
    version, count = struct.unpack_from("<II", data, 0)
    if version not in (1, 2):
        raise FixError(f"unsupported war3map.imp version {version}: {path}")
    if count > 1_000_000:
        raise FixError(f"invalid war3map.imp entry count {count}: {path}")
    offset = 8
    result: list[str] = []
    for _ in range(count):
        if offset >= len(data):
            raise FixError(f"war3map.imp ended before all {count} entries were read")
        offset += 1  # import-path flag
        raw_path, offset = read_c_string(data, offset)
        result.append(decode_path(raw_path))
    if offset != len(data) and any(data[offset:]):
        raise FixError(f"unexpected trailing data in {path}")
    return result


def fixed_filename(name: str) -> str:
    suffix = Path(name).suffix
    if not suffix:
        return name.replace(".", "_")
    stem = name[: -len(suffix)]
    return stem.replace(".", "_") + suffix


def resolve_import_file(map_dir: Path, import_path: str) -> Path | None:
    relative = Path(import_path.replace("\\", os.sep).replace("/", os.sep))
    candidates = [map_dir / relative]
    if len(relative.parts) == 1:
        candidates.append(map_dir / "war3mapImported" / relative)
    for candidate in candidates:
        if candidate.is_file():
            return candidate.resolve()
    return None


def load_default_map(config_path: Path) -> tuple[Path, Path]:
    try:
        config = json.loads(config_path.read_text(encoding="utf-8-sig"))
    except (OSError, json.JSONDecodeError) as exc:
        raise FixError(f"cannot read {config_path}: {exc}") from exc
    workspace = config_path.parent.resolve()
    build_value = config.get("build_config", ".vscode/wos-build.json")
    build_path = Path(build_value)
    if not build_path.is_absolute():
        build_path = workspace / build_path
    try:
        build = json.loads(build_path.read_text(encoding="utf-8-sig"))
    except (OSError, json.JSONDecodeError) as exc:
        raise FixError(f"cannot read local build config {build_path}: {exc}") from exc
    map_value = build.get(config.get("map_key", "mainMap"))
    if not isinstance(map_value, str) or not map_value.strip():
        raise FixError(f"{build_path}: main map path is missing")
    map_dir = Path(map_value)
    if not map_dir.is_absolute():
        map_dir = build_path.parent / map_dir
    return workspace, map_dir.resolve()


def build_rename_plan(map_dir: Path) -> list[dict[str, object]]:
    imp_path = map_dir / "war3map.imp"
    if not imp_path.is_file():
        raise FixError(f"war3map.imp not found: {imp_path}")
    plan: list[dict[str, object]] = []
    target_keys: dict[str, Path] = {}
    seen_sources: set[Path] = set()
    for import_path in parse_imp(imp_path):
        name = Path(import_path.replace("\\", "/")).name
        if Path(name).suffix.casefold() not in FIXABLE_EXTENSIONS:
            continue
        new_name = fixed_filename(name)
        if new_name == name:
            continue
        source = resolve_import_file(map_dir, import_path)
        if source is None:
            raise FixError(f"import listed in war3map.imp is missing from the map folder: {import_path}")
        if source in seen_sources:
            continue
        seen_sources.add(source)
        target = source.with_name(new_name)
        target_key = str(target).casefold()
        previous = target_keys.get(target_key)
        if previous is not None and previous != source:
            raise FixError(f"two imports would use the same target filename: {target}")
        target_keys[target_key] = source
        if target.exists() and target.resolve() != source:
            raise FixError(f"cannot rename import because the target already exists: {target}")
        old_import = import_path
        separator = "\\" if "\\" in import_path else "/"
        import_parts = re.split(r"[\\/]", import_path)
        import_parts[-1] = new_name
        new_import = separator.join(import_parts)
        plan.append({
            "old_import": old_import,
            "new_import": new_import,
            "old_name": name,
            "new_name": new_name,
            "source": source,
            "target": target,
        })
    return sorted(plan, key=lambda item: len(str(item["old_name"])), reverse=True)


def iter_files(root: Path):
    for current, directories, files in os.walk(root):
        directories[:] = [name for name in directories if name not in SKIP_DIRECTORY_NAMES]
        base = Path(current)
        for name in files:
            yield base / name


def project_files(workspace: Path) -> set[Path]:
    result: set[Path] = set()
    for relative in PROJECT_SCAN_DIRECTORIES:
        directory = workspace / relative
        if directory.is_dir():
            result.update(path.resolve() for path in iter_files(directory))
    for relative in PROJECT_SCAN_FILES:
        path = workspace / relative
        if path.is_file():
            result.add(path.resolve())
    return result


def replacement_patterns(plan: list[dict[str, object]]) -> list[tuple[re.Pattern[bytes], bytes, str, str]]:
    result = []
    seen: set[str] = set()
    for item in plan:
        old_name, new_name = str(item["old_name"]), str(item["new_name"])
        key = old_name.casefold()
        if key in seen:
            continue
        seen.add(key)
        old_bytes, new_bytes = old_name.encode("utf-8"), new_name.encode("utf-8")
        if len(old_bytes) != len(new_bytes):
            raise FixError(f"unsafe unequal-length replacement: {old_name} -> {new_name}")
        result.append((re.compile(re.escape(old_bytes), re.IGNORECASE), new_bytes, old_name, new_name))
    return result


def scan_references(
    map_dir: Path, workspace: Path, plan: list[dict[str, object]],
) -> tuple[dict[Path, bytes], dict[str, list[dict[str, object]]]]:
    patterns = replacement_patterns(plan)
    files = {path.resolve() for path in iter_files(map_dir)} | project_files(workspace)
    changed: dict[Path, bytes] = {}
    references: dict[str, list[dict[str, object]]] = defaultdict(list)
    map_prefix = str(map_dir).casefold() + os.sep
    workspace_prefix = str(workspace).casefold() + os.sep
    for path in sorted(files, key=lambda value: str(value).casefold()):
        try:
            original = path.read_bytes()
        except OSError as exc:
            raise FixError(f"cannot read reference candidate {path}: {exc}") from exc
        updated = original
        for pattern, replacement, old_name, _ in patterns:
            matches = list(pattern.finditer(original))
            updated, count = pattern.subn(replacement, updated)
            if count:
                absolute = str(path)
                if absolute.casefold().startswith(map_prefix):
                    label = "MAP/" + str(path.relative_to(map_dir)).replace("\\", "/")
                elif absolute.casefold().startswith(workspace_prefix):
                    label = "PROJECT/" + str(path.relative_to(workspace)).replace("\\", "/")
                else:
                    label = absolute
                lines: list[int] = []
                if path.suffix.casefold() in TEXT_LINE_EXTENSIONS:
                    lines = sorted({original.count(b"\n", 0, match.start()) + 1 for match in matches})
                references[old_name].append({
                    "file": label,
                    "count": count,
                    "lines": lines,
                })
        if updated != original:
            changed[path] = updated
    return changed, references


def refresh_object_data_hashes(map_dir: Path, workspace: Path, changed: dict[Path, bytes]) -> None:
    raw_dir = workspace / ".object-data-raw"
    manifest_path = (raw_dir / "manifest.json").resolve()
    if not manifest_path.is_file():
        return
    manifest_bytes = changed.get(manifest_path, manifest_path.read_bytes())
    try:
        manifest = json.loads(manifest_bytes.decode("utf-8-sig"))
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise FixError(f"cannot refresh object-data hashes in {manifest_path}: {exc}") from exc
    manifest_changed = False
    for entry in manifest.get("files", []):
        if not isinstance(entry, dict):
            continue
        binary_name, json_name = entry.get("binary"), entry.get("json")
        if not isinstance(binary_name, str) or not isinstance(json_name, str):
            continue
        binary_path = (map_dir / binary_name).resolve()
        if not binary_path.is_file():
            continue
        binary_bytes = changed.get(binary_path, binary_path.read_bytes())
        digest = hashlib.sha256(binary_bytes).hexdigest()
        if entry.get("sha256") != digest:
            entry["sha256"] = digest
            manifest_changed = True
        raw_path = (raw_dir / json_name).resolve()
        if not raw_path.is_file():
            continue
        raw_bytes = changed.get(raw_path, raw_path.read_bytes())
        try:
            document = json.loads(raw_bytes.decode("utf-8-sig"))
        except (UnicodeDecodeError, json.JSONDecodeError) as exc:
            raise FixError(f"cannot refresh source_sha256 in {raw_path}: {exc}") from exc
        if document.get("source_sha256") != digest:
            document["source_sha256"] = digest
            changed[raw_path] = (
                json.dumps(document, ensure_ascii=False, indent=2) + "\n"
            ).encode("utf-8")
    if manifest_changed:
        changed[manifest_path] = (
            json.dumps(manifest, ensure_ascii=False, indent=2) + "\n"
        ).encode("utf-8")


def refresh_trigger_manifest(workspace: Path, changed: dict[Path, bytes]) -> None:
    trigger_dir = workspace / "triggers"
    manifest_path = (trigger_dir / "trigger-manifest.json").resolve()
    if not manifest_path.is_file():
        return
    manifest_bytes = changed.get(manifest_path, manifest_path.read_bytes())
    try:
        manifest = json.loads(manifest_bytes.decode("utf-8-sig"))
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise FixError(f"cannot refresh trigger hashes in {manifest_path}: {exc}") from exc
    manifest_changed = False
    for entry in manifest.get("sources", []):
        if not isinstance(entry, dict) or not isinstance(entry.get("path"), str):
            continue
        source_path = (trigger_dir / entry["path"]).resolve()
        if not source_path.is_file():
            continue
        source_bytes = changed.get(source_path, source_path.read_bytes())
        digest = hashlib.sha256(source_bytes).hexdigest()
        if entry.get("sha256") != digest:
            entry["sha256"] = digest
            manifest_changed = True
        if entry.get("source_bytes") != len(source_bytes):
            entry["source_bytes"] = len(source_bytes)
            manifest_changed = True
    if manifest_changed:
        changed[manifest_path] = (
            json.dumps(manifest, ensure_ascii=False, indent=2) + "\n"
        ).encode("utf-8")


def backup_file(path: Path, base: Path, backup: Path, area: str) -> None:
    relative = path.relative_to(base)
    target = backup / area / relative
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(path, target)


def atomic_write(path: Path, data: bytes) -> None:
    temporary = path.with_name(path.name + ".import-fix.tmp")
    temporary.write_bytes(data)
    os.replace(temporary, path)


def apply_changes(
    map_dir: Path,
    workspace: Path,
    plan: list[dict[str, object]],
    changed: dict[Path, bytes],
    references: dict[str, list[dict[str, object]]] | None = None,
) -> Path:
    stamp = datetime.now().strftime("%Y-%m-%d_%H%M%S_%f")
    backup = workspace / "backups" / "import-path-fix" / stamp
    backup.mkdir(parents=True, exist_ok=False)
    map_prefix = str(map_dir).casefold() + os.sep
    for path in sorted(changed, key=lambda value: str(value).casefold()):
        if str(path).casefold().startswith(map_prefix):
            backup_file(path, map_dir, backup, "map")
        else:
            backup_file(path, workspace, backup, "project")
    for item in plan:
        source = Path(item["source"])
        if source not in changed:
            backup_file(source, map_dir, backup, "map")
    manifest = {
        "map": str(map_dir),
        "renames": [
            {key: str(item[key]) for key in ("old_import", "new_import", "source", "target")}
            for item in plan
        ],
        "changed_files": [str(path) for path in changed],
        "references": references or {},
    }
    (backup / "manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    for path, data in changed.items():
        atomic_write(path, data)
    for item in plan:
        source, target = Path(item["source"]), Path(item["target"])
        if source != target:
            source.rename(target)
    return backup


def display_path(path: Path, map_dir: Path, workspace: Path) -> str:
    absolute = str(path)
    map_prefix = str(map_dir).casefold() + os.sep
    workspace_prefix = str(workspace).casefold() + os.sep
    if absolute.casefold().startswith(map_prefix):
        return "MAP/" + str(path.relative_to(map_dir)).replace("\\", "/")
    if absolute.casefold().startswith(workspace_prefix):
        return "PROJECT/" + str(path.relative_to(workspace)).replace("\\", "/")
    return absolute


def game_checklist(
    plan: list[dict[str, object]], references: dict[str, list[dict[str, object]]],
) -> list[str]:
    checks: list[str] = []
    seen: set[str] = set()

    def add(value: str) -> None:
        if value not in seen:
            seen.add(value)
            checks.append(value)

    for item in plan:
        new_import = str(item["new_import"])
        if Path(str(item["new_name"])).suffix.casefold() == ".mdx":
            add(f"Модель/эффект {new_import}: вызови в игре и проверь модель, анимацию и текстуры.")
        else:
            add(f"Текстура {new_import}: открой использующую её модель/интерфейс и проверь, что нет зелёной текстуры.")
        for reference in references.get(str(item["old_name"]), []):
            label = str(reference["file"])
            normalized = label.replace("\\", "/")
            hero = re.search(r"PROJECT/triggers/Heroes/([^/]+)\.j$", normalized, re.IGNORECASE)
            if hero:
                add(f"Герой {hero.group(1)}: проверь способности и эффекты, связанные с изменённым импортом.")
            elif "/object-data/abilities.json" in normalized or normalized.endswith("/war3map.w3a"):
                add("Способности: проверь визуальные эффекты и модели затронутых умений.")
            elif "/object-data/units.json" in normalized or normalized.endswith("/war3map.w3u"):
                add("Юниты: проверь модели и иконки затронутых юнитов.")
            elif "/object-data/items.json" in normalized or normalized.endswith("/war3map.w3t"):
                add("Предметы: проверь модели и иконки затронутых предметов.")
            elif "/object-data/buffs.json" in normalized or normalized.endswith("/war3map.w3h"):
                add("Баффы: проверь эффекты затронутых баффов.")
            elif normalized.endswith(".mdx"):
                add(f"Модель {normalized}: проверь, что все вложенные текстуры отображаются.")
    return checks


def write_report_logs(
    map_dir: Path,
    workspace: Path,
    plan: list[dict[str, object]],
    changed: dict[Path, bytes],
    references: dict[str, list[dict[str, object]]],
    backup: Path,
) -> tuple[Path, Path]:
    stamp = backup.name
    log_dir = workspace / "logs" / "import-path-fix"
    log_dir.mkdir(parents=True, exist_ok=True)
    checks = game_checklist(plan, references)
    total_references = sum(
        int(reference["count"])
        for values in references.values()
        for reference in values
    )
    renamed: list[dict[str, object]] = []
    lines = [
        "WOS IMPORT PATH FIX REPORT",
        f"Дата: {datetime.now().astimezone().isoformat(timespec='seconds')}",
        f"Карта: {map_dir}",
        f"Backup: {backup}",
        f"Переименовано импортов: {len(plan)}",
        f"Обновлено ссылок: {total_references}",
        f"Изменено файлов: {len(changed)}",
        "",
        "ПЕРЕИМЕНОВАНИЯ И ССЫЛКИ",
    ]
    for index, item in enumerate(plan, 1):
        old_name = str(item["old_name"])
        found = references.get(old_name, [])
        count = sum(int(reference["count"]) for reference in found)
        lines.append(f"{index}. {item['old_import']} -> {item['new_import']} ({count} ссылок)")
        for reference in found:
            line_numbers = [int(value) for value in reference.get("lines", [])]
            location = ""
            if line_numbers:
                location = " | строки: " + ", ".join(str(value) for value in line_numbers)
            lines.append(f"   - {reference['file']} ({reference['count']}){location}")
        renamed.append({
            "old_import": str(item["old_import"]),
            "new_import": str(item["new_import"]),
            "source": str(item["source"]),
            "target": str(item["target"]),
            "reference_count": count,
            "references": found,
        })
    lines.extend(["", "ИЗМЕНЁННЫЕ ФАЙЛЫ"])
    for path in sorted(changed, key=lambda value: str(value).casefold()):
        lines.append(f"- {display_path(path, map_dir, workspace)}")
    lines.extend(["", "ЧТО ПРОВЕРИТЬ В ИГРЕ"])
    lines.extend(f"- {check}" for check in checks)
    lines.extend([
        "",
        "Если что-то сломалось, исходные файлы лежат в Backup, указанном в начале отчёта.",
        "",
    ])
    text = "\n".join(lines)
    document = {
        "format": "wos-import-path-fix-report-v1",
        "timestamp": datetime.now().astimezone().isoformat(timespec="seconds"),
        "map": str(map_dir),
        "backup": str(backup),
        "renamed_import_count": len(plan),
        "updated_reference_count": total_references,
        "changed_file_count": len(changed),
        "renamed_imports": renamed,
        "changed_files": [display_path(path, map_dir, workspace) for path in changed],
        "game_checks": checks,
    }
    text_path = log_dir / f"{stamp}.txt"
    json_path = log_dir / f"{stamp}.json"
    latest_text = log_dir / "latest.txt"
    latest_json = log_dir / "latest.json"
    json_text = json.dumps(document, ensure_ascii=False, indent=2) + "\n"
    text_path.write_text(text, encoding="utf-8")
    json_path.write_text(json_text, encoding="utf-8")
    latest_text.write_text(text, encoding="utf-8")
    latest_json.write_text(json_text, encoding="utf-8")
    return text_path, json_path


def print_report(
    map_dir: Path,
    plan: list[dict[str, object]],
    references: dict[str, list[dict[str, object]]],
    apply: bool,
) -> None:
    total_references = sum(
        int(reference["count"])
        for values in references.values()
        for reference in values
    )
    mode = "apply" if apply else "dry run"
    print(f"Map: {map_dir}")
    print(f"Found {len(plan)} dotted import filename(s), {total_references} reference(s) ({mode}):")
    for item in plan:
        old_name = str(item["old_name"])
        found = references.get(old_name, [])
        count = sum(int(reference["count"]) for reference in found)
        print(f"  {item['old_import']} -> {item['new_import']} ({count} reference(s))")
        for reference in found:
            location = ""
            if reference.get("lines"):
                location = " lines " + ", ".join(str(value) for value in reference["lines"])
            print(f"      {reference['file']} ({reference['count']}){location}")


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__)
    result.add_argument("--config", type=Path, default=Path("object-data.config.json"))
    result.add_argument("--map", dest="map_dir", type=Path, help="unpacked map directory; defaults to mainMap")
    result.add_argument("--apply", action="store_true", help="apply without an interactive prompt")
    result.add_argument("--interactive", action="store_true", help="show report and ask Y before applying")
    return result


def main() -> int:
    args = parser().parse_args()
    try:
        workspace, configured_map = load_default_map(args.config.resolve())
        map_dir = (args.map_dir or configured_map).resolve()
        if not map_dir.is_dir():
            raise FixError(f"unpacked map directory not found: {map_dir}")
        plan = build_rename_plan(map_dir)
        if not plan:
            print(f"IMPORT PATHS OK: no dotted import filenames need fixing in {map_dir}")
            return 0
        changed, references = scan_references(map_dir, workspace, plan)
        refresh_object_data_hashes(map_dir, workspace, changed)
        refresh_trigger_manifest(workspace, changed)
        should_apply = args.apply
        print_report(map_dir, plan, references, should_apply)
        if args.interactive and not should_apply:
            answer = input("\nType Y and press Enter to back up and apply all fixes, or press Enter to cancel: ")
            should_apply = answer.strip().casefold() == "y"
        if not should_apply:
            print("No files were changed.")
            return 0
        backup = apply_changes(map_dir, workspace, plan, changed, references)
        text_log, json_log = write_report_logs(
            map_dir, workspace, plan, changed, references, backup
        )
        print("\nIMPORT PATH FIX OK")
        print(f"Renamed imports: {len(plan)}")
        print(f"Updated files:   {len(changed)}")
        print(f"Backup:          {backup}")
        print(f"Report:          {text_log}")
        print(f"JSON report:     {json_log}")
        return 0
    except (FixError, OSError, ValueError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
