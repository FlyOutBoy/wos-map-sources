#!/usr/bin/env python3
"""Synchronize editable J files with Reforged war3map.wtg/war3map.wct."""

from __future__ import annotations

import argparse
import json
import shutil
import struct
import sys
from collections import Counter
from datetime import datetime
from pathlib import Path

import extract_war3_triggers as fmt


def i32(value: int) -> bytes:
    return struct.pack("<i", value)


def u32(value: int) -> bytes:
    return struct.pack("<I", value)


def string(value: str) -> bytes:
    return value.encode("utf-8") + b"\0"


def encode_type_info(value: dict) -> bytes:
    deleted = value["deleted_ids"]
    return i32(value["total"]) + i32(len(deleted)) + b"".join(i32(item) for item in deleted)


def encode_object(value: dict) -> bytes:
    result = bytearray(i32(value["object_type"]))
    if value["object_type"] == fmt.OBJECT_MAP_HEADER:
        result += i32(value["object_id"])
        result += string(value["name"])
        result += i32(int(value["is_comment"]))
        result += i32(int(value["is_expandable"]))
        result += i32(value["parent_id"])
    elif value["object_type"] == fmt.OBJECT_CATEGORY:
        result += i32(value["object_id"])
        result += string(value["name"])
        result += i32(int(value["is_category"]))
        result += i32(int(value["is_expandable"]))
        result += i32(value["parent_id"])
    elif value["object_type"] == fmt.OBJECT_VARIABLE:
        result += i32(value["object_id"])
        result += string(value["name"])
        result += i32(value["parent_id"])
    elif value["object_type"] in (fmt.OBJECT_TRIGGER, fmt.OBJECT_COMMENT, fmt.OBJECT_SCRIPT):
        result += string(value["name"])
        result += string(value["comment"])
        result += i32(int(value["is_comment"]))
        result += i32(value["object_id"])
        result += i32(int(value["enabled"]))
        result += i32(int(value["is_custom_text"]))
        result += i32(int(value["initially_off"]))
        result += i32(int(value["run_on_map_init"]))
        result += i32(value["parent_id"])
        result += i32(value["function_count"])
        if value["function_count"]:
            raise ValueError(f"cannot encode GUI functions in {value['name']!r}")
    else:
        raise ValueError(f"unsupported WTG object type {value['object_type']}")
    return bytes(result)


def encode_wtg(value: dict) -> bytes:
    result = bytearray(b"WTG!" + u32(int(value["magic_number"], 16)))
    result += i32(value["format_version"])
    for name in ("map_header", "library", "category", "trigger", "comment", "script", "variable"):
        result += encode_type_info(value["type_info"][name])
    result += i32(value["unknown"][0]) + i32(value["unknown"][1])
    result += i32(value["trigger_definition_version"])
    result += i32(len(value["variables"]))
    for variable in value["variables"]:
        result += string(variable["name"])
        result += string(variable["type"])
        result += i32(variable["category"])
        result += i32(int(variable["is_array"]))
        result += i32(variable["array_size"])
        result += i32(int(variable["is_initialized"]))
        result += string(variable["initial_value"])
        result += i32(variable["object_id"])
        result += i32(variable["parent_id"])
    result += i32(len(value["objects"]))
    result += b"".join(encode_object(item) for item in value["objects"])
    return bytes(result)


def source_block(source: bytes) -> bytes:
    payload = source + b"\0" if source else b""
    return i32(len(payload)) + payload


def encode_wct(value: dict) -> bytes:
    result = bytearray(u32(int(value["magic_number"], 16)))
    result += i32(value["format_version"])
    result += string(value["header_comment"])
    result += source_block(value["header_source"])
    result += b"".join(source_block(source) for source in value["sources"])
    return bytes(result)


def load_map(config_path: Path) -> Path:
    config = json.loads(config_path.read_text(encoding="utf-8-sig"))
    base = config_path.parent.resolve()
    build_path = Path(config.get("build_config", ".vscode/wos-build.json"))
    if not build_path.is_absolute():
        build_path = base / build_path
    build_path = build_path.resolve()
    try:
        build = json.loads(build_path.read_text(encoding="utf-8-sig"))
    except FileNotFoundError as exc:
        raise ValueError(f"local build config not found: {build_path}; set mainMap for this PC") from exc
    map_value = build.get(config.get("map_key", "mainMap"))
    if not isinstance(map_value, str) or not map_value.strip():
        raise ValueError(f"{build_path}: missing non-empty mainMap")
    result = Path(map_value)
    if not result.is_absolute():
        result = build_path.parent / result
    result = result.resolve()
    if not result.is_dir():
        raise ValueError(f"Scenario Folder not found: {result}")
    return result


def world_editor_source(path: Path) -> bytes:
    data = path.read_bytes()
    try:
        data.decode("utf-8")
    except UnicodeDecodeError as exc:
        raise ValueError(f"{path}: J source must be UTF-8: {exc}") from exc
    normalized = data.replace(b"\r\n", b"\n").replace(b"\r", b"\n").replace(b"\n", b"\r\n")
    if normalized != data:
        path.write_bytes(normalized)
        print(f"CRLF    {path}")
    return normalized


def expected_path(item: dict, objects_by_id: dict[int, dict]) -> str:
    parent = objects_by_id.get(item["parent_id"])
    category = parent["name"] if parent and parent["object_type"] == fmt.OBJECT_CATEGORY else "Uncategorized"
    return (Path(fmt.safe_name(category, "Uncategorized")) / f"{fmt.safe_name(item['name'], 'Trigger')}.j").as_posix()


def manifest_paths(trigger_dir: Path) -> dict[int, str]:
    path = trigger_dir / "trigger-manifest.json"
    if not path.is_file():
        return {}
    value = json.loads(path.read_text(encoding="utf-8-sig"))
    result = {}
    for item in value.get("sources", []):
        if item.get("wct_index") == "map_header":
            continue
        try:
            result[int(item["object_id"], 16)] = item["path"]
        except (KeyError, TypeError, ValueError):
            pass
    return result


def find_source_path(item: dict, objects_by_id: dict[int, dict], trigger_dir: Path, known: dict[int, str]) -> str | None:
    candidates = [known.get(item["object_id"]), expected_path(item, objects_by_id)]
    for relative in candidates:
        if relative and (trigger_dir / Path(relative)).is_file():
            return Path(relative).as_posix()
    return None


def next_id(wtg: dict, type_name: str, prefix: int) -> int:
    info = wtg["type_info"][type_name]
    low = info["total"]
    used = {item["object_id"] & 0xFFFFFF for item in wtg["objects"] if item["object_id"] >> 24 == prefix}
    while low in used:
        low += 1
    info["total"] = low + 1
    return (prefix << 24) | low


def ensure_category(wtg: dict, name: str) -> int:
    for item in wtg["objects"]:
        if item["object_type"] == fmt.OBJECT_CATEGORY and item["name"].casefold() == name.casefold():
            return item["object_id"]
    object_id = next_id(wtg, "category", 2)
    wtg["objects"].append({
        "object_type": fmt.OBJECT_CATEGORY,
        "object_id": object_id,
        "name": name,
        "is_category": True,
        "is_expandable": True,
        "parent_id": 0,
    })
    print(f"ADD     category {name}")
    return object_id


def candidate_files(trigger_dir: Path) -> list[str]:
    return sorted(
        path.relative_to(trigger_dir).as_posix()
        for path in trigger_dir.rglob("*.j")
        if path.name.casefold() != "map_header.j"
    )


def prepare(config_path: Path, trigger_dir: Path) -> tuple[Path, dict, dict, int, int]:
    map_dir = load_map(config_path)
    wtg_path, wct_path = map_dir / "war3map.wtg", map_dir / "war3map.wct"
    wtg = fmt.parse_wtg(wtg_path)
    source_objects = [item for item in wtg["objects"] if item["object_type"] in (fmt.OBJECT_TRIGGER, fmt.OBJECT_SCRIPT)]
    if any(not item["is_custom_text"] or item["function_count"] for item in source_objects):
        raise ValueError("map contains unsupported GUI trigger data")
    wct = fmt.parse_wct(wct_path, len(source_objects))
    objects_by_id = {item["object_id"]: item for item in wtg["objects"]}
    known = manifest_paths(trigger_dir)
    used = set()
    differences = 0
    for index, item in enumerate(source_objects):
        relative = find_source_path(item, objects_by_id, trigger_dir, known)
        if relative is None:
            continue
        used.add(relative.casefold())
        source = world_editor_source(trigger_dir / Path(relative))
        differences += source != wct["sources"][index]
        wct["sources"][index] = source
    header = trigger_dir / "Map_Header.j"
    if header.is_file():
        source = world_editor_source(header)
        differences += source != wct["header_source"]
        wct["header_source"] = source

    added = 0
    for relative in candidate_files(trigger_dir):
        if relative.casefold() in used:
            continue
        parts = Path(relative).parts
        category_name = parts[0] if len(parts) > 1 else "Uncategorized"
        trigger_name = Path(relative).stem.replace("_", " ")
        parent_id = ensure_category(wtg, category_name.replace("_", " "))
        object_id = next_id(wtg, "trigger", 3)
        wtg["objects"].append({
            "object_type": fmt.OBJECT_TRIGGER,
            "name": trigger_name,
            "comment": "",
            "is_comment": False,
            "object_id": object_id,
            "enabled": True,
            "is_custom_text": True,
            "initially_off": False,
            "run_on_map_init": False,
            "parent_id": parent_id,
            "function_count": 0,
        })
        wct["sources"].append(world_editor_source(trigger_dir / Path(relative)))
        used.add(relative.casefold())
        added += 1
        print(f"ADD     {relative} -> WTG trigger 0x{object_id:08X}")
    return map_dir, wtg, wct, differences, added


def validate_counts(wtg: dict, wct: dict) -> None:
    count = sum(item["object_type"] in (fmt.OBJECT_TRIGGER, fmt.OBJECT_SCRIPT) for item in wtg["objects"])
    if count != len(wct["sources"]):
        raise ValueError(f"WTG/WCT source-count mismatch: {count} != {len(wct['sources'])}")
    counts = Counter(item["object_type"] for item in wtg["objects"])
    for object_type, name in ((fmt.OBJECT_MAP_HEADER, "map_header"), (fmt.OBJECT_CATEGORY, "category"),
                              (fmt.OBJECT_TRIGGER, "trigger"), (fmt.OBJECT_COMMENT, "comment"),
                              (fmt.OBJECT_SCRIPT, "script"), (fmt.OBJECT_VARIABLE, "variable")):
        current = wtg["type_info"][name]["total"] - len(wtg["type_info"][name]["deleted_ids"])
        if counts[object_type] != current:
            raise ValueError(f"WTG {name} count mismatch: {counts[object_type]} != {current}")


def check(config_path: Path, trigger_dir: Path) -> None:
    map_dir, wtg, wct, differences, added = prepare(config_path, trigger_dir)
    validate_counts(wtg, wct)
    print(f"CHECK OK: {len(wct['sources'])} WTG triggers; {differences} source differences; {added} new J files")
    print(f"MAP: {map_dir}")


def push(config_path: Path, trigger_dir: Path, backup_root: Path) -> None:
    map_dir, wtg, wct, differences, added = prepare(config_path, trigger_dir)
    validate_counts(wtg, wct)
    encoded_wtg, encoded_wct = encode_wtg(wtg), encode_wct(wct)
    # Parse the generated bytes through temporary files before touching the map.
    verify = backup_root / ".verify"
    verify.mkdir(parents=True, exist_ok=True)
    try:
        (verify / "war3map.wtg").write_bytes(encoded_wtg)
        (verify / "war3map.wct").write_bytes(encoded_wct)
        checked_wtg = fmt.parse_wtg(verify / "war3map.wtg")
        fmt.parse_wct(verify / "war3map.wct", sum(
            item["object_type"] in (fmt.OBJECT_TRIGGER, fmt.OBJECT_SCRIPT) for item in checked_wtg["objects"]
        ))
    finally:
        shutil.rmtree(verify, ignore_errors=True)

    stamp = datetime.now().strftime("%Y-%m-%d_%H%M%S_%f")
    backup = backup_root / stamp / "map-before-push"
    backup.mkdir(parents=True, exist_ok=False)
    shutil.copy2(map_dir / "war3map.wtg", backup / "war3map.wtg")
    shutil.copy2(map_dir / "war3map.wct", backup / "war3map.wct")
    (map_dir / "war3map.wtg").write_bytes(encoded_wtg)
    (map_dir / "war3map.wct").write_bytes(encoded_wct)
    print(f"PUSH OK: {len(wct['sources'])} J triggers written; {added} WTG entries added; {differences} updated")
    print(f"BACKUP: {backup}")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("check", "push"))
    parser.add_argument("--config", type=Path, default=Path("object-data.config.json"))
    parser.add_argument("--triggers", type=Path, default=Path("triggers"))
    parser.add_argument("--backups", type=Path, default=Path("backups/trigger-sync"))
    args = parser.parse_args()
    try:
        if args.command == "check":
            check(args.config.resolve(), args.triggers.resolve())
        else:
            push(args.config.resolve(), args.triggers.resolve(), args.backups.resolve())
        return 0
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
