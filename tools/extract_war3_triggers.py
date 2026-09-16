#!/usr/bin/env python3
"""Extract Reforged WTG/WCT custom-text triggers without altering source bytes."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import struct
from collections import Counter
from pathlib import Path


OBJECT_MAP_HEADER = 1
OBJECT_CATEGORY = 4
OBJECT_TRIGGER = 8
OBJECT_COMMENT = 16
OBJECT_SCRIPT = 32
OBJECT_VARIABLE = 64


class BinaryReader:
    def __init__(self, data: bytes, source: Path):
        self.data = data
        self.source = source
        self.offset = 0

    def read(self, size: int) -> bytes:
        end = self.offset + size
        if size < 0 or end > len(self.data):
            raise ValueError(
                f"Unexpected end of {self.source} at byte {self.offset} "
                f"while reading {size} bytes"
            )
        value = self.data[self.offset:end]
        self.offset = end
        return value

    def int32(self) -> int:
        return struct.unpack("<i", self.read(4))[0]

    def uint32(self) -> int:
        return struct.unpack("<I", self.read(4))[0]

    def string(self) -> str:
        end = self.data.find(b"\0", self.offset)
        if end < 0:
            raise ValueError(f"Unterminated string in {self.source} at byte {self.offset}")
        raw = self.data[self.offset:end]
        self.offset = end + 1
        return raw.decode("utf-8")

    def at_end(self) -> bool:
        return self.offset == len(self.data)


def read_type_info(reader: BinaryReader) -> dict:
    total = reader.int32()
    deleted_count = reader.int32()
    return {
        "total": total,
        "deleted_ids": [reader.int32() for _ in range(deleted_count)],
    }


def read_trigger_object(reader: BinaryReader, object_order: int) -> dict:
    object_type = reader.int32()
    result = {"object_order": object_order, "object_type": object_type}

    if object_type == OBJECT_MAP_HEADER:
        result.update(
            object_id=reader.int32(),
            name=reader.string(),
            is_comment=bool(reader.int32()),
            is_expandable=bool(reader.int32()),
            parent_id=reader.int32(),
        )
    elif object_type == OBJECT_CATEGORY:
        result.update(
            object_id=reader.int32(),
            name=reader.string(),
            is_category=bool(reader.int32()),
            is_expandable=bool(reader.int32()),
            parent_id=reader.int32(),
        )
    elif object_type == OBJECT_VARIABLE:
        result.update(
            object_id=reader.int32(),
            name=reader.string(),
            parent_id=reader.int32(),
        )
    elif object_type in (OBJECT_TRIGGER, OBJECT_COMMENT, OBJECT_SCRIPT):
        result.update(
            name=reader.string(),
            comment=reader.string(),
            is_comment=bool(reader.int32()),
            object_id=reader.int32(),
            enabled=bool(reader.int32()),
            is_custom_text=bool(reader.int32()),
            initially_off=bool(reader.int32()),
            run_on_map_init=bool(reader.int32()),
            parent_id=reader.int32(),
            function_count=reader.int32(),
        )
        if result["function_count"]:
            raise ValueError(
                "This extractor intentionally does not consume GUI ECA data. "
                f"Object {result['name']!r} has {result['function_count']} GUI functions."
            )
    else:
        raise ValueError(
            f"Unsupported WTG object type {object_type} at object order {object_order}"
        )
    return result


def parse_wtg(path: Path) -> dict:
    reader = BinaryReader(path.read_bytes(), path)
    if reader.read(4) != b"WTG!":
        raise ValueError(f"{path} does not have a WTG! signature")

    magic_number = reader.uint32()
    if magic_number != 0x80000004:
        raise ValueError(
            f"Unsupported WTG layout marker 0x{magic_number:08X}; "
            "this extractor expects the Reforged object-tree format"
        )

    format_version = reader.int32()
    type_names = ("map_header", "library", "category", "trigger", "comment", "script", "variable")
    type_info = {name: read_type_info(reader) for name in type_names}
    unknown_1 = reader.int32()
    unknown_2 = reader.int32()
    trigger_definition_version = reader.int32()

    variable_count = reader.int32()
    variables = []
    for _ in range(variable_count):
        variables.append(
            {
                "name": reader.string(),
                "type": reader.string(),
                "category": reader.int32(),
                "is_array": bool(reader.int32()),
                "array_size": reader.int32(),
                "is_initialized": bool(reader.int32()),
                "initial_value": reader.string(),
                "object_id": reader.int32(),
                "parent_id": reader.int32(),
            }
        )

    object_count = reader.int32()
    objects = [read_trigger_object(reader, index) for index in range(object_count)]
    if not reader.at_end():
        raise ValueError(f"Unparsed WTG data remains at byte {reader.offset}")

    actual_counts = Counter(item["object_type"] for item in objects)
    expected_current = {
        OBJECT_MAP_HEADER: type_info["map_header"]["total"] - len(type_info["map_header"]["deleted_ids"]),
        OBJECT_CATEGORY: type_info["category"]["total"] - len(type_info["category"]["deleted_ids"]),
        OBJECT_TRIGGER: type_info["trigger"]["total"] - len(type_info["trigger"]["deleted_ids"]),
        OBJECT_COMMENT: type_info["comment"]["total"] - len(type_info["comment"]["deleted_ids"]),
        OBJECT_SCRIPT: type_info["script"]["total"] - len(type_info["script"]["deleted_ids"]),
        OBJECT_VARIABLE: type_info["variable"]["total"] - len(type_info["variable"]["deleted_ids"]),
    }
    for object_type, expected in expected_current.items():
        if actual_counts[object_type] != expected:
            raise ValueError(
                f"WTG type-count mismatch for object type {object_type}: "
                f"header says {expected}, parsed {actual_counts[object_type]}"
            )

    return {
        "magic_number": f"0x{magic_number:08X}",
        "format_version": format_version,
        "trigger_definition_version": trigger_definition_version,
        "unknown": [unknown_1, unknown_2],
        "type_info": type_info,
        "variables": variables,
        "objects": objects,
    }


def read_sized_source(reader: BinaryReader) -> bytes:
    size = reader.int32()
    payload = reader.read(size)
    if payload and payload[-1] != 0:
        raise ValueError(
            f"WCT source block ending at byte {reader.offset} has no null terminator"
        )
    return payload[:-1] if payload else b""


def parse_wct(path: Path, source_count: int) -> dict:
    reader = BinaryReader(path.read_bytes(), path)
    magic_number = reader.uint32()
    if magic_number != 0x80000004:
        raise ValueError(
            f"Unsupported WCT layout marker 0x{magic_number:08X}; "
            "this extractor expects the Reforged custom-text format"
        )
    format_version = reader.int32()
    header_comment = reader.string()
    header_source = read_sized_source(reader)
    sources = [read_sized_source(reader) for _ in range(source_count)]
    if not reader.at_end():
        raise ValueError(f"Unparsed WCT data remains at byte {reader.offset}")
    return {
        "magic_number": f"0x{magic_number:08X}",
        "format_version": format_version,
        "header_comment": header_comment,
        "header_source": header_source,
        "sources": sources,
    }


def safe_name(value: str, fallback: str) -> str:
    value = re.sub(r"[<>:\"/\\|?*\x00-\x1F]", "_", value).strip().rstrip(".")
    value = re.sub(r"\s+", "_", value)
    return value or fallback


def category_directory(parent_id: int, object_by_id: dict[int, dict]) -> Path:
    """Return the complete WTG category chain instead of flattening its leaf."""
    parts = []
    visited = set()
    while parent_id and parent_id not in visited:
        visited.add(parent_id)
        category = object_by_id.get(parent_id)
        if not category or category["object_type"] != OBJECT_CATEGORY:
            break
        fallback = f"Category_{parent_id & 0xFFFFFFFF:08X}"
        parts.append(safe_name(category["name"], fallback))
        parent_id = category["parent_id"]
    parts.reverse()
    return Path(*parts) if parts else Path("Uncategorized")


def source_metadata(source: bytes) -> dict:
    text = source.decode("utf-8")
    masked = re.sub(r"(?s)/\*.*?\*/", "", text)
    masked = re.sub(r"(?m)//.*$", "", masked)

    declarations = {
        "libraries": re.findall(r"(?im)^\s*library(?:_once)?\s+([A-Za-z_]\w*)", masked),
        "scopes": re.findall(r"(?im)^\s*scope\s+([A-Za-z_]\w*)", masked),
        "structs": re.findall(r"(?im)^\s*(?:private\s+|public\s+)?struct\s+([A-Za-z_]\w*)", masked),
        "modules": re.findall(r"(?im)^\s*(?:private\s+|public\s+)?module\s+([A-Za-z_]\w*)", masked),
        "textmacros": re.findall(r"(?im)^\s*//!\s+textmacro\s+([A-Za-z_]\w*)", text),
    }

    dependencies = []
    declaration_pattern = re.compile(
        r"(?im)^\s*(?:library(?:_once)?|scope)\s+[A-Za-z_]\w*"
        r"(?:\s+initializer\s+[A-Za-z_]\w*)?\s+"
        r"(requires|uses|needs)\s+([^\r\n]+)"
    )
    for match in declaration_pattern.finditer(masked):
        keyword = match.group(1).lower()
        for item in match.group(2).split(","):
            item = item.strip()
            optional = bool(re.match(r"(?i)^optional\s+", item))
            name = re.sub(r"(?i)^optional\s+", "", item).strip()
            name_match = re.match(r"[A-Za-z_]\w*", name)
            if name_match:
                dependencies.append(
                    {"name": name_match.group(0), "optional": optional, "keyword": keyword}
                )

    return {"declarations": declarations, "dependencies": dependencies}


def write_index(output: Path, manifest: dict) -> None:
    lines = [
        "# Extracted Warcraft III trigger sources",
        "",
        "Sources are byte-for-byte copies of WCT payloads with only the binary null terminator removed.",
        "Trigger names, category membership, and order come from WTG.",
        "Machine-readable metadata is in `trigger-manifest.json`; the resolved vJASS graph is in `dependency-manifest.json`.",
        "Regenerate with `python tools/extract_war3_triggers.py` from the project root.",
        "",
        "| Order | Category | Trigger | Source | Libraries/scopes | Dependencies |",
        "| ---: | --- | --- | --- | --- | --- |",
    ]
    for item in manifest["sources"]:
        declared = item["declarations"]["libraries"] + item["declarations"]["scopes"]
        dependencies = [
            ("optional " if dep["optional"] else "") + dep["name"]
            for dep in item["dependencies"]
        ]
        lines.append(
            f"| {item['order']:03d} | {item['category']} | {item['trigger_name']} | "
            f"[{item['path']}]({item['path'].replace(' ', '%20')}) | "
            f"{', '.join(declared) or '—'} | {', '.join(dependencies) or '—'} |"
        )
    (output / "README.md").write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")


def write_dependency_manifest(output: Path, manifest: dict) -> None:
    providers = {}
    for item in manifest["sources"]:
        for name in item["declarations"]["libraries"] + item["declarations"]["scopes"]:
            providers.setdefault(name, []).append(item["path"])

    files = []
    unresolved_required = []
    unresolved_optional = []
    for item in manifest["sources"]:
        dependencies = []
        for dependency in item["dependencies"]:
            matches = providers.get(dependency["name"], [])
            record = {**dependency, "resolved_paths": matches}
            dependencies.append(record)
            if not matches:
                unresolved = {
                    "source": item["path"],
                    "dependency": dependency["name"],
                }
                if dependency["optional"]:
                    unresolved_optional.append(unresolved)
                else:
                    unresolved_required.append(unresolved)
        files.append(
            {
                "order": item["order"],
                "path": item["path"],
                "provides": item["declarations"]["libraries"] + item["declarations"]["scopes"],
                "dependencies": dependencies,
            }
        )

    dependency_manifest = {
        "format": 1,
        "providers": providers,
        "files": files,
        "unresolved_required": unresolved_required,
        "unresolved_optional": unresolved_optional,
    }
    (output / "dependency-manifest.json").write_text(
        json.dumps(dependency_manifest, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
        newline="\n",
    )


def extract(wtg_path: Path, wct_path: Path, output: Path) -> dict:
    wtg = parse_wtg(wtg_path)
    source_objects = [
        item for item in wtg["objects"] if item["object_type"] in (OBJECT_TRIGGER, OBJECT_SCRIPT)
    ]
    if any(not item["is_custom_text"] for item in source_objects):
        names = [item["name"] for item in source_objects if not item["is_custom_text"]]
        raise ValueError(f"Non-custom trigger objects cannot be recovered from WCT: {names}")

    wct = parse_wct(wct_path, len(source_objects))
    output.mkdir(parents=True, exist_ok=True)

    object_by_id = {item["object_id"]: item for item in wtg["objects"]}
    manifest_sources = []

    header_relative = "Map_Header.j"
    (output / header_relative).write_bytes(wct["header_source"])
    header_meta = source_metadata(wct["header_source"])
    manifest_sources.append(
        {
            "order": 0,
            "wct_index": "map_header",
            "object_order": 0,
            "object_id": "0x00000000",
            "object_type": "map_header",
            "category": "Map Header",
            "trigger_name": "Map Header",
            "enabled": True,
            "run_on_map_init": True,
            "path": header_relative,
            "source_bytes": len(wct["header_source"]),
            "sha256": hashlib.sha256(wct["header_source"]).hexdigest(),
            **header_meta,
        }
    )

    for index, (item, source) in enumerate(zip(source_objects, wct["sources"]), start=1):
        parent = object_by_id.get(item["parent_id"])
        category_name = parent["name"] if parent and parent["object_type"] == OBJECT_CATEGORY else "Uncategorized"
        category_dir = category_directory(item["parent_id"], object_by_id)
        file_name = f"{safe_name(item['name'], f'Trigger_{index}')}.j"
        relative = (Path(category_dir) / file_name).as_posix()
        target = output / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(source)
        meta = source_metadata(source)
        manifest_sources.append(
            {
                "order": index,
                "wct_index": index - 1,
                "object_order": item["object_order"],
                "object_id": f"0x{item['object_id'] & 0xFFFFFFFF:08X}",
                "object_type": "script" if item["object_type"] == OBJECT_SCRIPT else "trigger",
                "category": category_name,
                "category_id": f"0x{item['parent_id'] & 0xFFFFFFFF:08X}",
                "trigger_name": item["name"],
                "comment": item["comment"],
                "enabled": item["enabled"],
                "initially_off": item["initially_off"],
                "run_on_map_init": item["run_on_map_init"],
                "path": relative,
                "source_bytes": len(source),
                "sha256": hashlib.sha256(source).hexdigest(),
                **meta,
            }
        )

    manifest = {
        "format": 1,
        "source_files": {"wtg": str(wtg_path), "wct": str(wct_path)},
        "wtg": {
            "magic_number": wtg["magic_number"],
            "format_version": wtg["format_version"],
            "trigger_definition_version": wtg["trigger_definition_version"],
            "object_count": len(wtg["objects"]),
            "custom_text_object_count": len(source_objects),
        },
        "wct": {
            "magic_number": wct["magic_number"],
            "format_version": wct["format_version"],
            "header_comment": wct["header_comment"],
            "source_count": len(wct["sources"]),
        },
        "sources": manifest_sources,
    }
    (output / "trigger-manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
        newline="\n",
    )
    trigger_settings = {
        "format": 1,
        "description": "true = enabled and imported; false = disabled and excluded from Main.vj",
        "triggers": {
            item["path"]: bool(item["enabled"])
            for item in manifest_sources
            if item["wct_index"] != "map_header"
        },
    }
    (output / "trigger-settings.json").write_text(
        json.dumps(trigger_settings, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
        newline="\n",
    )
    write_dependency_manifest(output, manifest)
    write_index(output, manifest)
    return manifest


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--wtg", type=Path, default=Path("war3map.wtg"))
    parser.add_argument("--wct", type=Path, default=Path("war3map.wct"))
    parser.add_argument("--output", type=Path, default=Path("triggers"))
    args = parser.parse_args()
    manifest = extract(args.wtg, args.wct, args.output)
    print(
        f"Extracted {manifest['wct']['source_count']} triggers plus map header "
        f"to {args.output}"
    )


if __name__ == "__main__":
    main()
