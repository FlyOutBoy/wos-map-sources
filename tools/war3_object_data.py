#!/usr/bin/env python3
"""Lossless Warcraft III object-data <-> readable JSON converter.

Supports ObjectDataFormatVersion 1-3 and the seven native object files:
units, items, destructables, doodads, abilities, buffs and upgrades.
No third-party Python packages are required.
"""

from __future__ import annotations

import argparse
import base64
import hashlib
import json
import math
import os
import shutil
import struct
import sys
import tempfile
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Any


FORMAT_BY_EXTENSION = {
    ".w3u": ("units", "simple"),
    ".w3t": ("items", "simple"),
    ".w3b": ("destructables", "simple"),
    ".w3d": ("doodads", "variation"),
    ".w3a": ("abilities", "level"),
    ".w3h": ("buffs", "simple"),
    ".w3q": ("upgrades", "level"),
}

OUTPUT_NAMES = {
    "war3map.w3u": "units.json",
    "war3map.w3t": "items.json",
    "war3map.w3b": "destructables.json",
    "war3map.w3d": "doodads.json",
    "war3map.w3a": "abilities.json",
    "war3map.w3h": "buffs.json",
    "war3map.w3q": "upgrades.json",
    "war3mapSkin.w3u": "units-skin.json",
    "war3mapSkin.w3t": "items-skin.json",
    "war3mapSkin.w3b": "destructables-skin.json",
    "war3mapSkin.w3d": "doodads-skin.json",
    "war3mapSkin.w3a": "abilities-skin.json",
    "war3mapSkin.w3h": "buffs-skin.json",
    "war3mapSkin.w3q": "upgrades-skin.json",
}

TYPE_NAMES = {0: "int", 1: "real", 2: "unreal", 3: "string", 4: "bool", 5: "char"}
TYPE_IDS = {name: value for value, name in TYPE_NAMES.items()}

# Only stable, well-known metadata names are included. Unknown field rawcodes stay
# fully editable and are intentionally not guessed.
FIELD_NAMES = {
    "unam": "Name / Имя",
    "unsf": "Editor suffix / Суффикс редактора",
    "utip": "Tooltip / Подсказка",
    "utub": "Extended tooltip / Полная подсказка",
    "uabi": "Normal abilities / Обычные способности",
    "uhab": "Hero abilities / Способности героя",
    "umdl": "Model / Модель",
    "uico": "Icon / Иконка",
    "uhpm": "Maximum hit points / Максимум здоровья",
    "umpm": "Maximum mana / Максимум маны",
    "umvs": "Movement speed / Скорость движения",
    "udef": "Base armor / Базовая броня",
    "ulev": "Level / Уровень",
    "anam": "Name / Имя",
    "ansf": "Editor suffix / Суффикс редактора",
    "atp1": "Tooltip / Подсказка",
    "aub1": "Extended tooltip / Полная подсказка",
    "aret": "Research tooltip / Подсказка изучения",
    "arut": "Research extended tooltip / Полная подсказка изучения",
    "aart": "Icon / Иконка",
    "acdn": "Cooldown / Перезарядка",
    "amcs": "Mana cost / Затраты маны",
    "aare": "Area of effect / Область действия",
    "adur": "Duration / Длительность",
    "ahdu": "Hero duration / Длительность на героях",
    "alev": "Levels / Число уровней",
    "arlv": "Required level / Требуемый уровень",
    "aher": "Hero ability / Способность героя",
    "aite": "Item ability / Способность предмета",
    "fnam": "Name / Имя",
    "ftip": "Tooltip / Подсказка",
    "fube": "Extended tooltip / Полная подсказка",
    "fart": "Icon / Иконка",
    "bnam": "Name / Имя",
    "dnam": "Name / Имя",
    "gnam": "Name / Имя",
}

DISPLAY_NAME_FIELDS = {
    "units": ("unam",),
    "items": ("unam",),
    "destructables": ("bnam",),
    "doodads": ("dnam",),
    "abilities": ("anam",),
    "buffs": ("fnam",),
    "upgrades": ("gnam",),
}

MAX_COUNT = 10_000_000


class FormatError(ValueError):
    pass


@dataclass
class Reader:
    data: bytes
    source: str
    pos: int = 0

    def take(self, size: int) -> bytes:
        if size < 0 or self.pos + size > len(self.data):
            raise FormatError(f"{self.source}: unexpected end of file at byte {self.pos}")
        value = self.data[self.pos : self.pos + size]
        self.pos += size
        return value

    def i32(self) -> int:
        return struct.unpack("<i", self.take(4))[0]

    def u8(self) -> int:
        return self.take(1)[0]

    def cstring(self) -> bytes:
        end = self.data.find(b"\0", self.pos)
        if end < 0:
            raise FormatError(f"{self.source}: unterminated string at byte {self.pos}")
        value = self.data[self.pos:end]
        self.pos = end + 1
        return value


def checked_count(reader: Reader, label: str) -> int:
    count = reader.i32()
    if count < 0 or count > MAX_COUNT:
        raise FormatError(f"{reader.source}: invalid {label} count {count} at byte {reader.pos - 4}")
    return count


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def rawcode_to_json(raw: bytes) -> dict[str, Any]:
    if len(raw) != 4:
        raise FormatError("rawcode must be exactly four bytes")
    try:
        text = raw.decode("ascii")
        if any(ord(char) < 32 or ord(char) > 126 for char in text):
            text = ""
    except UnicodeDecodeError:
        text = ""
    return {"text": text, "hex": raw.hex().upper()}


def rawcode_from_json(value: Any, label: str) -> bytes:
    if isinstance(value, str):
        try:
            raw = value.encode("ascii")
        except UnicodeEncodeError as exc:
            raise FormatError(f"{label}: rawcode must contain ASCII characters") from exc
        if len(raw) != 4:
            raise FormatError(f"{label}: rawcode must be exactly 4 ASCII characters")
        return raw
    if not isinstance(value, dict):
        raise FormatError(f"{label}: expected rawcode object with text/hex")
    text = value.get("text", "")
    hex_value = value.get("hex", "")
    if text:
        try:
            raw = text.encode("ascii")
        except UnicodeEncodeError as exc:
            raise FormatError(f"{label}.text: rawcode must be ASCII") from exc
        if len(raw) != 4:
            raise FormatError(f"{label}.text: rawcode must be exactly 4 characters")
        # If text was not edited, retain any exact original bytes from hex.
        if isinstance(hex_value, str) and len(hex_value) == 8:
            try:
                original = bytes.fromhex(hex_value)
                if original == raw:
                    return original
            except ValueError:
                pass
        return raw
    try:
        raw = bytes.fromhex(hex_value)
    except (TypeError, ValueError) as exc:
        raise FormatError(f"{label}.hex: expected eight hexadecimal digits") from exc
    if len(raw) != 4:
        raise FormatError(f"{label}.hex: expected exactly four bytes")
    return raw


def decode_text(raw: bytes) -> tuple[str, str]:
    for encoding in ("utf-8", "cp1251"):
        try:
            return raw.decode(encoding), encoding
        except UnicodeDecodeError:
            pass
    return raw.decode("latin-1"), "latin-1"


def json_float(raw: bytes) -> dict[str, Any]:
    number = struct.unpack("<f", raw)[0]
    if math.isnan(number):
        value: Any = "NaN"
    elif math.isinf(number):
        value = "Infinity" if number > 0 else "-Infinity"
    else:
        value = number
    return {"value": value, "_original_value": value, "_raw_hex": raw.hex().upper()}


def float_from_json(value: dict[str, Any], label: str) -> bytes:
    current = value.get("value")
    original = value.get("_original_value")
    raw_hex = value.get("_raw_hex")
    if current == original and isinstance(raw_hex, str):
        try:
            raw = bytes.fromhex(raw_hex)
            if len(raw) == 4:
                return raw
        except ValueError:
            pass
    if isinstance(current, str):
        special = {"NaN": math.nan, "Infinity": math.inf, "-Infinity": -math.inf}
        if current not in special:
            raise FormatError(f"{label}.value: expected a number, NaN or Infinity")
        number = special[current]
    elif isinstance(current, (int, float)) and not isinstance(current, bool):
        number = float(current)
    else:
        raise FormatError(f"{label}.value: expected a number")
    try:
        return struct.pack("<f", number)
    except (OverflowError, struct.error) as exc:
        raise FormatError(f"{label}.value: value does not fit a 32-bit float") from exc


def json_string(raw: bytes, wts: dict[str, str]) -> dict[str, Any]:
    text, encoding = decode_text(raw)
    result: dict[str, Any] = {
        "value": text,
        "_original_value": text,
        "_encoding": encoding,
        "_raw_base64": base64.b64encode(raw).decode("ascii"),
    }
    resolved = resolve_trigger_string(text, wts)
    if resolved is not None:
        result["resolved_value"] = resolved
        result["_original_resolved_value"] = resolved
    return result


def string_from_json(value: dict[str, Any], label: str) -> bytes:
    current = value.get("value")
    if not isinstance(current, str):
        raise FormatError(f"{label}.value: expected a string")
    if "\0" in current:
        raise FormatError(f"{label}.value: NUL characters are not allowed")
    resolved = value.get("resolved_value")
    original_resolved = value.get("_original_resolved_value")
    if current == value.get("_original_value") and isinstance(resolved, str) and resolved != original_resolved:
        if "\0" in resolved:
            raise FormatError(f"{label}.resolved_value: NUL characters are not allowed")
        current = resolved
    if current == value.get("_original_value"):
        try:
            return base64.b64decode(value.get("_raw_base64", ""), validate=True)
        except (ValueError, TypeError):
            pass
    encoding = value.get("_encoding", "utf-8")
    if encoding not in ("utf-8", "cp1251", "latin-1"):
        raise FormatError(f"{label}._encoding: unsupported encoding {encoding!r}")
    try:
        return current.encode(encoding)
    except UnicodeEncodeError:
        # New text should remain usable even if the old string used a legacy codepage.
        return current.encode("utf-8")


def read_value(reader: Reader, type_id: int, wts: dict[str, str]) -> dict[str, Any]:
    if type_id == 0:
        return {"value": reader.i32()}
    if type_id in (1, 2):
        return json_float(reader.take(4))
    if type_id == 3:
        return json_string(reader.cstring(), wts)
    if type_id == 4:
        return {"value": bool(reader.u8())}
    if type_id == 5:
        raw = reader.take(1)
        text, encoding = decode_text(raw)
        return {"value": text, "_original_value": text, "_encoding": encoding, "_raw_hex": raw.hex().upper()}
    raise FormatError(f"{reader.source}: unsupported object value type {type_id} at byte {reader.pos - 4}")


def write_value(value: dict[str, Any], type_id: int, label: str) -> bytes:
    if not isinstance(value, dict):
        raise FormatError(f"{label}: expected an object containing value")
    if type_id == 0:
        number = value.get("value")
        if not isinstance(number, int) or isinstance(number, bool) or not -(2**31) <= number < 2**31:
            raise FormatError(f"{label}.value: expected a signed 32-bit integer")
        return struct.pack("<i", number)
    if type_id in (1, 2):
        return float_from_json(value, label)
    if type_id == 3:
        return string_from_json(value, label) + b"\0"
    if type_id == 4:
        if not isinstance(value.get("value"), bool):
            raise FormatError(f"{label}.value: expected true or false")
        return bytes((1 if value["value"] else 0,))
    if type_id == 5:
        current = value.get("value")
        if current == value.get("_original_value") and isinstance(value.get("_raw_hex"), str):
            raw = bytes.fromhex(value["_raw_hex"])
        elif isinstance(current, str):
            raw = current.encode(value.get("_encoding", "utf-8"))
        else:
            raise FormatError(f"{label}.value: expected one character")
        if len(raw) != 1:
            raise FormatError(f"{label}.value: encoded character must occupy one byte")
        return raw
    raise FormatError(f"{label}: unsupported object value type {type_id}")


def read_modification(reader: Reader, mode: str, wts: dict[str, str]) -> dict[str, Any]:
    field_raw = reader.take(4)
    field = rawcode_to_json(field_raw)
    type_id = reader.i32()
    result: dict[str, Any] = {
        "field": field,
        "field_name": FIELD_NAMES.get(field.get("text", ""), ""),
        "type": TYPE_NAMES.get(type_id, type_id),
    }
    if mode == "level":
        result["level"] = reader.i32()
        result["data_pointer"] = reader.i32()
    elif mode == "variation":
        result["variation"] = reader.i32()
        result["data_pointer"] = reader.i32()
    result["data"] = read_value(reader, type_id, wts)
    result["sanity_check"] = rawcode_to_json(reader.take(4))
    return result


def write_modification(mod: Any, mode: str, label: str) -> bytes:
    if not isinstance(mod, dict):
        raise FormatError(f"{label}: expected an object")
    output = bytearray()
    output += rawcode_from_json(mod.get("field"), f"{label}.field")
    type_value = mod.get("type")
    if isinstance(type_value, str):
        if type_value not in TYPE_IDS:
            raise FormatError(f"{label}.type: unknown type {type_value!r}")
        type_id = TYPE_IDS[type_value]
    elif isinstance(type_value, int) and not isinstance(type_value, bool):
        type_id = type_value
    else:
        raise FormatError(f"{label}.type: expected a known type name")
    output += struct.pack("<i", type_id)
    for key in (("level", "data_pointer") if mode == "level" else (("variation", "data_pointer") if mode == "variation" else ())):
        number = mod.get(key)
        if not isinstance(number, int) or isinstance(number, bool) or not -(2**31) <= number < 2**31:
            raise FormatError(f"{label}.{key}: expected a signed 32-bit integer")
        output += struct.pack("<i", number)
    output += write_value(mod.get("data"), type_id, f"{label}.data")
    output += rawcode_from_json(mod.get("sanity_check"), f"{label}.sanity_check")
    return bytes(output)


def read_object(reader: Reader, version: int, mode: str, wts: dict[str, str]) -> dict[str, Any]:
    result: dict[str, Any] = {
        "old_id": rawcode_to_json(reader.take(4)),
        "new_id": rawcode_to_json(reader.take(4)),
    }
    if version >= 3:
        result["v3_unknown"] = [reader.i32() for _ in range(checked_count(reader, "v3 unknown"))]
    count = checked_count(reader, "modification")
    result["modifications"] = [read_modification(reader, mode, wts) for _ in range(count)]
    return result


def write_object(obj: Any, version: int, mode: str, label: str) -> bytes:
    if not isinstance(obj, dict):
        raise FormatError(f"{label}: expected an object")
    output = bytearray()
    output += rawcode_from_json(obj.get("old_id"), f"{label}.old_id")
    output += rawcode_from_json(obj.get("new_id"), f"{label}.new_id")
    if version >= 3:
        unknown = obj.get("v3_unknown", [])
        if not isinstance(unknown, list) or len(unknown) > MAX_COUNT:
            raise FormatError(f"{label}.v3_unknown: expected a reasonably sized array")
        output += struct.pack("<i", len(unknown))
        for index, number in enumerate(unknown):
            if not isinstance(number, int) or isinstance(number, bool) or not -(2**31) <= number < 2**31:
                raise FormatError(f"{label}.v3_unknown[{index}]: expected a signed 32-bit integer")
            output += struct.pack("<i", number)
    modifications = obj.get("modifications")
    if not isinstance(modifications, list) or len(modifications) > MAX_COUNT:
        raise FormatError(f"{label}.modifications: expected a reasonably sized array")
    output += struct.pack("<i", len(modifications))
    for index, modification in enumerate(modifications):
        output += write_modification(modification, mode, f"{label}.modifications[{index}]")
    return bytes(output)


def parse_object_file(data: bytes, source: str, kind: str, mode: str, wts: dict[str, str]) -> dict[str, Any]:
    reader = Reader(data, source)
    version = reader.i32()
    if version not in (1, 2, 3):
        raise FormatError(f"{source}: unsupported object-data version {version}")
    original_count = checked_count(reader, "original object")
    original = [read_object(reader, version, mode, wts) for _ in range(original_count)]
    custom_count = checked_count(reader, "custom object")
    custom = [read_object(reader, version, mode, wts) for _ in range(custom_count)]
    if reader.pos != len(data):
        raise FormatError(f"{source}: {len(data) - reader.pos} trailing bytes after object data")
    result = {
        "_format": "warcraft-3-object-data-json-v1",
        "_instructions_ru": "Редактируйте data.value или resolved_value, level и data_pointer. Поля с '_' и sanity_check сохраняйте без изменений.",
        "source_file": Path(source).name,
        "source_sha256": sha256(data),
        "kind": kind,
        "record_mode": mode,
        "format_version": version,
        "original_objects": original,
        "custom_objects": custom,
    }
    add_display_names(result, wts)
    return result


def encode_object_file(document: Any, label: str) -> bytes:
    if not isinstance(document, dict) or document.get("_format") != "warcraft-3-object-data-json-v1":
        raise FormatError(f"{label}: not a supported Warcraft III object JSON file")
    version = document.get("format_version")
    if version not in (1, 2, 3):
        raise FormatError(f"{label}.format_version: expected 1, 2 or 3")
    mode = document.get("record_mode")
    if mode not in ("simple", "level", "variation"):
        raise FormatError(f"{label}.record_mode: unsupported mode {mode!r}")
    expected = FORMAT_BY_EXTENSION.get(Path(str(document.get("source_file", ""))).suffix.lower())
    if expected is None or expected != (document.get("kind"), mode):
        raise FormatError(f"{label}: kind/mode does not match source_file extension")
    output = bytearray(struct.pack("<i", version))
    for group_name in ("original_objects", "custom_objects"):
        group = document.get(group_name)
        if not isinstance(group, list) or len(group) > MAX_COUNT:
            raise FormatError(f"{label}.{group_name}: expected a reasonably sized array")
        output += struct.pack("<i", len(group))
        for index, obj in enumerate(group):
            output += write_object(obj, version, mode, f"{label}.{group_name}[{index}]")
    return bytes(output)


def parse_wts(path: Path) -> dict[str, str]:
    if not path.is_file():
        return {}
    raw = path.read_bytes()
    text, _ = decode_text(raw)
    result: dict[str, str] = {}
    lines = text.replace("\r\n", "\n").replace("\r", "\n").split("\n")
    index = 0
    while index < len(lines):
        stripped = lines[index].strip()
        if stripped.upper().startswith("STRING "):
            number = stripped[7:].strip()
            index += 1
            while index < len(lines) and lines[index].strip() != "{":
                index += 1
            if index < len(lines):
                index += 1
                body: list[str] = []
                while index < len(lines) and lines[index].strip() != "}":
                    body.append(lines[index])
                    index += 1
                try:
                    key = f"TRIGSTR_{int(number)}"
                except ValueError:
                    key = f"TRIGSTR_{number}"
                result[key] = "\n".join(body)
        index += 1
    return result


def resolve_trigger_string(text: str, wts: dict[str, str]) -> str | None:
    normalized = text.strip()
    if normalized.upper().startswith("TRIGSTR_"):
        suffix = normalized[8:]
        try:
            normalized = f"TRIGSTR_{int(suffix)}"
        except ValueError:
            pass
    if normalized in wts:
        return wts[normalized]
    return None


def add_display_names(document: dict[str, Any], wts: dict[str, str]) -> None:
    name_fields = DISPLAY_NAME_FIELDS.get(document["kind"], ())
    for group_name in ("original_objects", "custom_objects"):
        for obj in document[group_name]:
            display = ""
            for mod in obj["modifications"]:
                if mod["field"].get("text") in name_fields and mod["type"] == "string":
                    display = mod["data"].get("resolved_value") or mod["data"].get("value", "")
                    if display:
                        break
            obj["display_name"] = display


def object_key(obj: dict[str, Any]) -> str:
    return obj["new_id"].get("hex") if obj["new_id"].get("hex") != "00000000" else obj["old_id"].get("hex", "")


def share_display_names(documents: list[dict[str, Any]]) -> None:
    names: dict[tuple[str, str], str] = {}
    for document in documents:
        for group_name in ("original_objects", "custom_objects"):
            for obj in document[group_name]:
                if obj.get("display_name"):
                    names[(document["kind"], object_key(obj))] = obj["display_name"]
    for document in documents:
        for group_name in ("original_objects", "custom_objects"):
            for obj in document[group_name]:
                if not obj.get("display_name"):
                    obj["display_name"] = names.get((document["kind"], object_key(obj)), "")


def load_config(config_path: Path) -> tuple[Path, Path, Path]:
    try:
        config = json.loads(config_path.read_text(encoding="utf-8-sig"))
    except FileNotFoundError as exc:
        raise FormatError(f"configuration file not found: {config_path}") from exc
    except json.JSONDecodeError as exc:
        raise FormatError(f"invalid JSON in {config_path}: {exc}") from exc
    base = config_path.parent.resolve()
    map_dir = Path(config.get("map_directory", ""))
    if not map_dir.is_absolute():
        map_dir = base / map_dir
    json_dir = Path(config.get("json_directory", "object-data"))
    if not json_dir.is_absolute():
        json_dir = base / json_dir
    backup_dir = Path(config.get("backup_directory", "object-data-backups"))
    if not backup_dir.is_absolute():
        backup_dir = base / backup_dir
    return map_dir.resolve(), json_dir.resolve(), backup_dir.resolve()


def discover_map_files(map_dir: Path) -> list[Path]:
    if not map_dir.is_dir():
        raise FormatError(f"map directory not found: {map_dir}")
    paths = [map_dir / name for name in OUTPUT_NAMES if (map_dir / name).is_file()]
    if not paths:
        raise FormatError(f"no supported war3map object files found in {map_dir}")
    return paths


def dump_json(path: Path, document: dict[str, Any]) -> None:
    path.write_text(json.dumps(document, ensure_ascii=False, indent=2, allow_nan=False) + "\n", encoding="utf-8")


def export_files(map_dir: Path, json_dir: Path, force: bool) -> None:
    paths = discover_map_files(map_dir)
    json_dir.mkdir(parents=True, exist_ok=True)
    targets = [json_dir / OUTPUT_NAMES[path.name] for path in paths]
    existing = [path for path in targets if path.exists()]
    if existing and not force:
        raise FormatError(f"JSON already exists ({existing[0]}). Use export --force only when you intentionally want to refresh it.")
    wts = parse_wts(map_dir / "war3map.wts")
    manifest: dict[str, Any] = {"format": "warcraft-3-object-data-manifest-v1", "map_directory": str(map_dir), "files": []}
    pending: list[tuple[Path, Path, dict[str, Any]]] = []
    for source, target in zip(paths, targets):
        data = source.read_bytes()
        kind, mode = FORMAT_BY_EXTENSION[source.suffix.lower()]
        document = parse_object_file(data, source.name, kind, mode, wts)
        pending.append((source, target, document))
    share_display_names([document for _, _, document in pending])
    for source, target, document in pending:
        dump_json(target, document)
        manifest["files"].append({"json": target.name, "binary": source.name, "sha256": document["source_sha256"]})
        print(f"EXPORT  {source.name:18} -> {target.name} ({len(document['original_objects']) + len(document['custom_objects'])} objects)")
    (json_dir / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def load_documents(json_dir: Path) -> tuple[dict[str, Any], list[tuple[Path, dict[str, Any], bytes, dict[str, Any]]]]:
    manifest_path = json_dir / "manifest.json"
    try:
        manifest = json.loads(manifest_path.read_text(encoding="utf-8-sig"))
    except FileNotFoundError as exc:
        raise FormatError(f"manifest not found: {manifest_path}; run export first") from exc
    except json.JSONDecodeError as exc:
        raise FormatError(f"invalid JSON in {manifest_path}: {exc}") from exc
    if manifest.get("format") != "warcraft-3-object-data-manifest-v1" or not isinstance(manifest.get("files"), list):
        raise FormatError(f"unsupported manifest format in {manifest_path}")
    documents = []
    allowed_sources = set(OUTPUT_NAMES)
    for entry in manifest["files"]:
        json_name = entry.get("json")
        if not isinstance(json_name, str) or Path(json_name).name != json_name:
            raise FormatError("manifest contains an unsafe JSON filename")
        path = json_dir / json_name
        try:
            document = json.loads(path.read_text(encoding="utf-8-sig"))
        except FileNotFoundError as exc:
            raise FormatError(f"JSON file not found: {path}") from exc
        except json.JSONDecodeError as exc:
            raise FormatError(f"invalid JSON in {path}: line {exc.lineno}, column {exc.colno}: {exc.msg}") from exc
        source_name = document.get("source_file")
        if source_name not in allowed_sources or source_name != entry.get("binary"):
            raise FormatError(f"{path}: unsafe or unexpected source_file {source_name!r}")
        encoded = encode_object_file(document, path.name)
        # Parse the generated bytes as a strict structural verification.
        kind, mode = FORMAT_BY_EXTENSION[Path(source_name).suffix.lower()]
        parse_object_file(encoded, source_name, kind, mode, {})
        documents.append((path, document, encoded, entry))
    return manifest, documents


def check_files(map_dir: Path, json_dir: Path) -> None:
    _, documents = load_documents(json_dir)
    changed = 0
    for path, document, encoded, _ in documents:
        binary = map_dir / document["source_file"]
        if not binary.is_file():
            raise FormatError(f"target binary file not found: {binary}")
        current = binary.read_bytes()
        status = "same" if current == encoded else "will change"
        changed += current != encoded
        print(f"OK      {path.name:24} ({len(encoded)} bytes, {status})")
    print(f"CHECK OK: {len(documents)} JSON files are valid; {changed} binary files differ")


def import_files(map_dir: Path, json_dir: Path, backup_root: Path, force: bool) -> None:
    manifest, documents = load_documents(json_dir)
    changes: list[tuple[Path, bytes, bytes, dict[str, Any]]] = []
    for path, document, encoded, entry in documents:
        target = map_dir / document["source_file"]
        if not target.is_file():
            raise FormatError(f"target binary file not found: {target}")
        current = target.read_bytes()
        expected_hash = entry.get("sha256")
        if not force and sha256(current) != expected_hash:
            raise FormatError(
                f"{target.name} changed after JSON export. Run export --force to accept the editor's newer data, "
                "or import --force only if overwriting it is intentional."
            )
        if current != encoded:
            changes.append((target, current, encoded, entry))
    if not changes:
        print("IMPORT OK: no binary object files need changes")
        return
    stamp = datetime.now().strftime("%Y-%m-%d_%H%M%S_%f")
    backup_dir = backup_root / stamp
    backup_dir.mkdir(parents=True, exist_ok=False)
    for target, current, _, _ in changes:
        (backup_dir / target.name).write_bytes(current)
    written: list[tuple[Path, bytes]] = []
    try:
        for target, current, encoded, entry in changes:
            fd, temp_name = tempfile.mkstemp(prefix=f".{target.name}.", suffix=".tmp", dir=target.parent)
            try:
                with os.fdopen(fd, "wb") as stream:
                    stream.write(encoded)
                    stream.flush()
                    os.fsync(stream.fileno())
                os.replace(temp_name, target)
            finally:
                if os.path.exists(temp_name):
                    os.unlink(temp_name)
            written.append((target, current))
            entry["sha256"] = sha256(encoded)
            print(f"WRITE   {target.name} ({len(current)} -> {len(encoded)} bytes)")
        manifest_text = json.dumps(manifest, ensure_ascii=False, indent=2) + "\n"
        fd, temp_manifest = tempfile.mkstemp(prefix=".manifest.", suffix=".tmp", dir=json_dir)
        try:
            with os.fdopen(fd, "w", encoding="utf-8", newline="\n") as stream:
                stream.write(manifest_text)
                stream.flush()
                os.fsync(stream.fileno())
            os.replace(temp_manifest, json_dir / "manifest.json")
        finally:
            if os.path.exists(temp_manifest):
                os.unlink(temp_manifest)
    except Exception:
        for target, original in reversed(written):
            target.write_bytes(original)
        raise
    print(f"IMPORT OK: {len(changes)} files saved; backup: {backup_dir}")


def roundtrip(map_dir: Path) -> None:
    wts = parse_wts(map_dir / "war3map.wts")
    failures = 0
    for source in discover_map_files(map_dir):
        original = source.read_bytes()
        kind, mode = FORMAT_BY_EXTENSION[source.suffix.lower()]
        document = parse_object_file(original, source.name, kind, mode, wts)
        rebuilt = encode_object_file(document, source.name)
        if rebuilt != original:
            failures += 1
            print(f"FAIL    {source.name}: rebuilt bytes differ")
        else:
            print(f"EXACT   {source.name}: {len(original)} bytes")
    if failures:
        raise FormatError(f"round-trip failed for {failures} files")
    print("ROUNDTRIP OK: every supported file is byte-for-byte identical")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Edit Warcraft III .w3u/.w3a/.w3t/.w3b/.w3d/.w3h/.w3q as readable JSON")
    parser.add_argument("--config", type=Path, default=Path("object-data.config.json"), help="path to JSON configuration")
    sub = parser.add_subparsers(dest="command", required=True)
    export = sub.add_parser("export", help="read binary object files and create editable JSON")
    export.add_argument("--force", action="store_true", help="overwrite existing editable JSON")
    sub.add_parser("check", help="validate all editable JSON without writing the map")
    imp = sub.add_parser("import", help="validate and save JSON changes into the map folder")
    imp.add_argument("--force", action="store_true", help="overwrite binary files changed since export")
    sub.add_parser("roundtrip", help="prove binary -> JSON -> binary identity without writing")
    return parser


def main() -> int:
    args = build_parser().parse_args()
    try:
        map_dir, json_dir, backup_dir = load_config(args.config.resolve())
        if args.command == "export":
            export_files(map_dir, json_dir, args.force)
        elif args.command == "check":
            check_files(map_dir, json_dir)
        elif args.command == "import":
            import_files(map_dir, json_dir, backup_dir, args.force)
        elif args.command == "roundtrip":
            roundtrip(map_dir)
        return 0
    except (FormatError, OSError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
