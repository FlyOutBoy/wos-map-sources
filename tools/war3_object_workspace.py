#!/usr/bin/env python3
"""Convenient merged object workspace on top of the lossless binary converter."""

from __future__ import annotations

import argparse
import copy
import json
import re
import sys
from pathlib import Path
from typing import Any

import war3_object_data as raw


CATEGORY_FILES = {
    "abilities": "abilities.json",
    "units": "units.json",
    "items": "items.json",
    "buffs": "buffs.json",
    "upgrades": "upgrades.json",
    "destructables": "destructables.json",
    "doodads": "doodads.json",
}

KIND_TITLES = {
    "abilities": "Способности / Abilities",
    "units": "Юниты / Units",
    "items": "Предметы / Items",
    "buffs": "Баффы и эффекты / Buffs and effects",
    "upgrades": "Улучшения / Upgrades",
    "destructables": "Разрушаемые объекты / Destructables",
    "doodads": "Декорации / Doodads",
}

FRIENDLY_FIELDS = {
    # Ability gameplay.
    "acdn": ("cooldown", "Перезарядка / Cooldown"),
    "amcs": ("mana_cost", "Затраты маны / Mana cost"),
    "aran": ("cast_range", "Дальность применения / Cast range"),
    "aare": ("area_of_effect", "Область действия / Area of effect"),
    "adur": ("duration", "Длительность / Duration"),
    "ahdu": ("hero_duration", "Длительность на героях / Hero duration"),
    "acas": ("casting_time", "Время применения / Casting time"),
    "acpt": ("cast_point", "Точка применения / Cast point"),
    "acbs": ("cast_backswing", "Завершение анимации / Cast backswing"),
    "atar": ("allowed_targets", "Разрешённые цели / Allowed targets"),
    "alev": ("levels", "Количество уровней / Levels"),
    "arlv": ("required_level", "Требуемый уровень / Required level"),
    "alsk": ("level_skip", "Шаг требований по уровню / Level skip"),
    "aher": ("hero_ability", "Способность героя / Hero ability"),
    "aite": ("item_ability", "Способность предмета / Item ability"),
    "achd": ("check_dependencies", "Проверять зависимости / Check dependencies"),
    "amsp": ("missile_speed", "Скорость снаряда / Missile speed"),
    "amac": ("missile_arc", "Дуга снаряда / Missile arc"),
    # Ability UI/text.
    "anam": ("name", "Название / Name"),
    "ansf": ("editor_suffix", "Суффикс редактора / Editor suffix"),
    "atp1": ("tooltip", "Краткое описание / Tooltip"),
    "aub1": ("extended_tooltip", "Полное описание / Extended tooltip"),
    "aret": ("research_tooltip", "Описание изучения / Research tooltip"),
    "arut": ("research_extended_tooltip", "Полное описание изучения / Research extended tooltip"),
    "aart": ("icon", "Иконка / Icon"),
    "auar": ("activated_icon", "Активная иконка / Activated icon"),
    "arar": ("research_icon", "Иконка изучения / Research icon"),
    "ahky": ("hotkey", "Горячая клавиша / Hotkey"),
    "auhk": ("activated_hotkey", "Активная горячая клавиша / Activated hotkey"),
    "arhk": ("research_hotkey", "Горячая клавиша изучения / Research hotkey"),
    "abpx": ("button_x", "Позиция кнопки X / Button position X"),
    "abpy": ("button_y", "Позиция кнопки Y / Button position Y"),
    "aubx": ("activated_button_x", "Позиция активной кнопки X / Activated button X"),
    "auby": ("activated_button_y", "Позиция активной кнопки Y / Activated button Y"),
    "arpx": ("research_button_x", "Позиция изучения X / Research button X"),
    "arpy": ("research_button_y", "Позиция изучения Y / Research button Y"),
    "acat": ("caster_art", "Эффект на заклинателе / Caster art"),
    "atat": ("target_art", "Эффект на цели / Target art"),
    "asat": ("special_art", "Особый эффект / Special art"),
    "aeat": ("effect_art", "Основной эффект / Effect art"),
    "amat": ("missile_art", "Модель снаряда / Missile art"),
    "aefs": ("effect_sound", "Звук эффекта / Effect sound"),
    "aefl": ("looping_effect_sound", "Зацикленный звук / Looping effect sound"),
    "aani": ("animation_names", "Animation names"),
    "arac": ("race", "Race"),
    "abuf": ("buffs", "Buffs"),
    "aeff": ("effects", "Effects"),
    "acac": ("caster_attachments", "Caster attachments"),
    "atac": ("target_attachments", "Target attachments"),
    "acap": ("caster_attachment_point_1", "Caster attachment point 1"),
    "ata0": ("target_attachment_point_1", "Target attachment point 1"),
    "ata1": ("target_attachment_point_2", "Target attachment point 2"),
    "ata2": ("target_attachment_point_3", "Target attachment point 3"),
    "ata3": ("target_attachment_point_4", "Target attachment point 4"),
    "ata4": ("target_attachment_point_5", "Target attachment point 5"),
    "ata5": ("target_attachment_point_6", "Target attachment point 6"),
    # Unit and item essentials.
    "unam": ("name", "Название / Name"),
    "unsf": ("editor_suffix", "Суффикс редактора / Editor suffix"),
    "utip": ("tooltip", "Краткое описание / Tooltip"),
    "utub": ("extended_tooltip", "Полное описание / Extended tooltip"),
    "uabi": ("normal_abilities", "Обычные способности / Normal abilities"),
    "uhab": ("hero_abilities", "Способности героя / Hero abilities"),
    "umdl": ("model", "Модель / Model"),
    "uico": ("icon", "Иконка / Icon"),
    "uhpm": ("maximum_hit_points", "Максимум здоровья / Maximum hit points"),
    "umpm": ("maximum_mana", "Максимум маны / Maximum mana"),
    "umvs": ("movement_speed", "Скорость движения / Movement speed"),
    "udef": ("base_armor", "Базовая броня / Base armor"),
    "uacq": ("acquisition_range", "Радиус обнаружения / Acquisition range"),
    "ua1r": ("attack_1_range", "Дальность атаки 1 / Attack 1 range"),
    "ua2r": ("attack_2_range", "Дальность атаки 2 / Attack 2 range"),
    "ua1c": ("attack_1_cooldown", "Перезарядка атаки 1 / Attack 1 cooldown"),
    "ua2c": ("attack_2_cooldown", "Перезарядка атаки 2 / Attack 2 cooldown"),
    "ua1b": ("attack_1_base_damage", "Базовый урон атаки 1 / Attack 1 base damage"),
    "ua2b": ("attack_2_base_damage", "Базовый урон атаки 2 / Attack 2 base damage"),
    "ulev": ("level", "Уровень / Level"),
    "igol": ("gold_cost", "Стоимость в золоте / Gold cost"),
    "ilum": ("lumber_cost", "Стоимость в дереве / Lumber cost"),
    "iabi": ("abilities", "Способности / Abilities"),
    "ides": ("description", "Описание / Description"),
    "iico": ("icon", "Icon"),
    "icla": ("classification", "Classification"),
    "fnsf": ("editor_suffix", "Editor suffix"),
    "frac": ("race", "Race"),
    "ftat": ("target_art", "Target art"),
    "fsat": ("special_art", "Special art"),
    "ftac": ("target_attachments", "Target attachments"),
    "fta0": ("target_attachment_point_1", "Target attachment point 1"),
    "fta1": ("target_attachment_point_2", "Target attachment point 2"),
    "fta2": ("target_attachment_point_3", "Target attachment point 3"),
    "fta3": ("target_attachment_point_4", "Target attachment point 4"),
    "fta4": ("target_attachment_point_5", "Target attachment point 5"),
    "fta5": ("target_attachment_point_6", "Target attachment point 6"),
    # Other object names.
    "fnam": ("name", "Название / Name"),
    "ftip": ("tooltip", "Краткое описание / Tooltip"),
    "fube": ("extended_tooltip", "Полное описание / Extended tooltip"),
    "fart": ("icon", "Иконка / Icon"),
    "bnam": ("name", "Название / Name"),
    "dnam": ("name", "Название / Name"),
    "gnam": ("name", "Название / Name"),
}

NAME_FIELDS = {kind: values[0] for kind, values in raw.DISPLAY_NAME_FIELDS.items()}
FIELD_PRIORITY = {
    key: index
    for index, key in enumerate(
        (
            "mana_cost", "cooldown", "cast_range", "area_of_effect", "casting_time", "duration", "hero_duration",
            "buffs", "effects", "allowed_targets", "levels", "required_level", "hero_ability", "item_ability",
            "tooltip", "extended_tooltip", "research_tooltip", "research_extended_tooltip", "hotkey",
            "icon", "activated_icon", "research_icon", "caster_art", "target_art", "special_art", "effect_art",
        )
    )
}

# Fields marked in the supplied World Editor screenshots, plus buffs/effects
# and attachment fields needed by item and non-hero abilities.
ABILITY_DISPLAY_KEYS = {
    "mana_cost", "cooldown", "cast_range", "area_of_effect", "allowed_targets",
    "levels", "level_skip", "required_level", "race",
    "icon", "research_icon", "hotkey", "research_hotkey",
    "tooltip", "extended_tooltip", "research_tooltip", "research_extended_tooltip",
    "base_order_id", "follow_through_time", "options", "target_type",
    "buffs", "effects",
    "caster_art", "target_art", "special_art", "effect_art", "area_effect", "missile_art",
    "caster_attachments", "target_attachments", "caster_attachment_point_1",
    "target_attachment_point_1", "target_attachment_point_2", "target_attachment_point_3",
    "target_attachment_point_4", "target_attachment_point_5", "target_attachment_point_6",
}

META_SUBDIRECTORY = "workspace-meta"
TARGET_TYPES = {
    0: "None",
    1: "Unit Target",
    2: "Point Target",
    3: "Unit or Point Target",
}
CHANNEL_OPTIONS = {
    1: "Visible",
    2: "Targeting Image",
    4: "Physical Spell",
    8: "Universal Spell",
    16: "Unique Cast",
}


def load_config(config_path: Path) -> tuple[Path, Path, Path, Path, Path]:
    try:
        config = json.loads(config_path.read_text(encoding="utf-8-sig"))
    except (OSError, json.JSONDecodeError) as exc:
        raise raw.FormatError(f"cannot read {config_path}: {exc}") from exc
    base = config_path.parent.resolve()

    def resolve(key: str, default: str) -> Path:
        path = Path(config.get(key, default))
        return (path if path.is_absolute() else base / path).resolve()

    common_j = resolve("common_j", "libs/common.j")
    return (
        resolve("map_directory", ""),
        resolve("json_directory", "object-data"),
        resolve("raw_json_directory", ".object-data-raw"),
        resolve("backup_directory", "object-data-backups"),
        common_j,
    )


def common_field_names(path: Path) -> dict[str, str]:
    result: dict[str, str] = {}
    if not path.is_file():
        return result
    pattern = re.compile(r"\bconstant\s+\w+\s+([A-Z][A-Z0-9_]+)\s*=\s*Convert\w*Field\('(.{4})'\)")
    for constant, field_id in pattern.findall(path.read_text(encoding="utf-8-sig", errors="replace")):
        parts = constant.split("_")
        while parts and (parts[0] in {"ABILITY", "UNIT", "ITEM", "PLAYER"} or re.fullmatch(r"[A-Z]{1,4}F", parts[0])):
            parts.pop(0)
        if parts and parts[-1].lower() == field_id.lower():
            parts.pop()
        label = " ".join(parts).replace("  ", " ").strip().title()
        if label:
            result.setdefault(field_id, label)
    return result


def semantic_key(label: str, field_id: str) -> str:
    key = re.sub(r"[^a-z0-9]+", "_", label.lower()).strip("_")
    return key or f"field_{field_id}"


def value_for_user(modification: dict[str, Any]) -> Any:
    data = modification["data"]
    value = data.get("resolved_value", data.get("value"))
    field_id = modification["field"].get("text")
    if field_id == "Ncl2" and isinstance(value, int):
        return TARGET_TYPES.get(value, value)
    if field_id == "Ncl3" and isinstance(value, int) and value >= 0:
        known_mask = sum(CHANNEL_OPTIONS)
        if value & ~known_mask == 0:
            return ", ".join(name for flag, name in CHANNEL_OPTIONS.items() if value & flag) or "None"
    return value


def object_id(obj: dict[str, Any]) -> str:
    rawcode = obj["new_id"] if obj["new_id"]["hex"] != "00000000" else obj["old_id"]
    return rawcode.get("text") or f"0x{rawcode['hex']}"


def object_hex(obj: dict[str, Any]) -> str:
    return obj["new_id"]["hex"] if obj["new_id"]["hex"] != "00000000" else obj["old_id"]["hex"]


def source_area(filename: str) -> str:
    return "Интерфейс и текст / Interface and text" if filename.startswith("war3mapSkin") else "Игровые данные / Gameplay"


def field_entry(
    modification: dict[str, Any], filename: str, group: str, object_index: int, modification_index: int,
    common_names: dict[str, str],
) -> dict[str, Any]:
    field_id = modification["field"].get("text") or f"0x{modification['field']['hex']}"
    if field_id in FRIENDLY_FIELDS:
        key, friendly = FRIENDLY_FIELDS[field_id]
    else:
        friendly = common_names.get(field_id, f"Поле {field_id} / Field {field_id}")
        key = semantic_key(friendly, field_id) if field_id in common_names else f"field_{field_id}"
    entry: dict[str, Any] = {
        "key": key,
        "field_id": field_id,
        "name": friendly,
        "section": source_area(filename),
        "type": modification["type"],
    }
    if "level" in modification:
        entry["level"] = modification["level"]
    if "variation" in modification:
        entry["variation"] = modification["variation"]
    if "data_pointer" in modification:
        entry["data_pointer"] = modification["data_pointer"]
    entry["value"] = value_for_user(modification)
    entry["_source"] = {
        "file": filename,
        "group": group,
        "object_index": object_index,
        "modification_index": modification_index,
    }
    return entry


def build_unified(raw_documents: list[dict[str, Any]], common_names: dict[str, str]) -> dict[str, dict[str, Any]]:
    by_kind: dict[str, dict[str, dict[str, Any]]] = {kind: {} for kind in CATEGORY_FILES}
    for document in raw_documents:
        kind = document["kind"]
        filename = document["source_file"]
        for group in ("original_objects", "custom_objects"):
            for object_index, obj in enumerate(document[group]):
                key = object_hex(obj)
                unified = by_kind[kind].setdefault(
                    key,
                    {
                        "id": object_id(obj),
                        "base_id": obj["old_id"].get("text") or f"0x{obj['old_id']['hex']}",
                        "name": "",
                        "fields": [],
                    },
                )
                name_id = NAME_FIELDS.get(kind)
                for modification_index, modification in enumerate(obj["modifications"]):
                    entry = field_entry(modification, filename, group, object_index, modification_index, common_names)
                    if modification["field"].get("text") == name_id and modification["type"] == "string" and not unified["name"]:
                        unified["name"] = entry["value"]
                        unified["_name_source"] = entry["_source"]
                    else:
                        unified["fields"].append(entry)
    results: dict[str, dict[str, Any]] = {}
    for kind, objects_by_id in by_kind.items():
        objects = list(objects_by_id.values())
        for obj in objects:
            obj["fields"].sort(key=lambda field: (FIELD_PRIORITY.get(field["key"], 1000), field["name"], field.get("level", 0), field["field_id"], field["section"]))
        objects.sort(key=lambda obj: (obj["id"].lower(), str(obj["name"]).lower()))
        results[kind] = {
            "_format": "warcraft-3-unified-object-workspace-v1",
            "_instructions_ru": "Каждый объект собран в одном блоке. Редактируйте name и value; для многоуровневых полей также level. Поля с '_' не меняйте.",
            "category": kind,
            "title": KIND_TITLES[kind],
            "object_count": len(objects),
            "objects": objects,
        }
    return results


def property_base(field: dict[str, Any]) -> str:
    result = field["key"]
    if isinstance(field.get("level"), int) and field["level"] > 0:
        result += f" level {field['level']}"
    if isinstance(field.get("variation"), int) and field["variation"] > 0:
        result += f" variation {field['variation']}"
    return result


def unique_property_name(base: str, field: dict[str, Any], used: set[str]) -> str:
    if base not in used:
        return base
    pointer = field.get("data_pointer")
    candidates = []
    if isinstance(pointer, int):
        candidates.append(f"{base} data {pointer}")
    candidates.append(f"{base} [{field['field_id']}]")
    area = "interface" if str(field.get("section", "")).startswith("Интерфейс") else "gameplay"
    candidates.append(f"{base} [{field['field_id']} {area}]")
    for candidate in candidates:
        if candidate not in used:
            return candidate
    number = 2
    while f"{base} #{number}" in used:
        number += 1
    return f"{base} #{number}"


def should_expose_field(category: str, field: dict[str, Any]) -> bool:
    # The screenshots define a compact ability view. Other categories retain
    # all modified values, but use the same metadata-free layout.
    return category != "abilities" or field["key"] in ABILITY_DISPLAY_KEYS


def flatten_unified(document: dict[str, Any]) -> tuple[dict[str, Any], dict[str, Any]]:
    editable: dict[str, Any] = {}
    metadata: dict[str, Any] = {
        "format": "warcraft-3-minimal-object-metadata-v1",
        "category": document["category"],
        "objects": {},
    }
    for obj in document["objects"]:
        object_id_value = obj["id"]
        if object_id_value in editable:
            raise raw.FormatError(f"duplicate object id {object_id_value} in {document['category']}")
        editable_object: dict[str, Any] = {"name": obj["name"], "base_id": obj["base_id"]}
        meta_object: dict[str, Any] = {
            "base_id": obj["base_id"],
            "name_source": obj.get("_name_source"),
            "fields": {},
        }
        used = set(editable_object)
        for field in obj["fields"]:
            if not should_expose_field(document["category"], field):
                continue
            property_name = unique_property_name(property_base(field), field, used)
            used.add(property_name)
            editable_object[property_name] = field["value"]
            meta_object["fields"][property_name] = {
                "source": field["_source"],
                "field_id": field["field_id"],
                "type": field["type"],
                "level": field.get("level"),
                "variation": field.get("variation"),
                "data_pointer": field.get("data_pointer"),
            }
        editable[object_id_value] = editable_object
        metadata["objects"][object_id_value] = meta_object
    return editable, metadata


def export_workspace(map_dir: Path, output_dir: Path, raw_dir: Path, common_j: Path, force: bool) -> None:
    existing = [output_dir / name for name in CATEGORY_FILES.values() if (output_dir / name).exists()]
    if existing and not force:
        try:
            _, prepared = prepare_documents(output_dir, raw_dir)
        except (raw.FormatError, OSError) as exc:
            raise raw.FormatError(f"cannot safely refresh existing object files: {exc}") from exc
        unsaved = [document["source_file"] for _, document, encoded, entry in prepared if raw.sha256(encoded) != entry.get("sha256")]
        if unsaved:
            raise raw.FormatError(
                f"editable JSON has unsaved changes for {unsaved[0]}. Save it into the map first, "
                "or use export --force only if discarding those edits is intentional."
            )
    raw.export_files(map_dir, raw_dir, force=True)
    _, loaded = raw.load_documents(raw_dir)
    raw_documents = [document for _, document, _, _ in loaded]
    unified = build_unified(raw_documents, common_field_names(common_j))
    output_dir.mkdir(parents=True, exist_ok=True)
    meta_dir = raw_dir / META_SUBDIRECTORY
    meta_dir.mkdir(parents=True, exist_ok=True)
    manifest = {"format": "warcraft-3-minimal-object-workspace-manifest-v1", "files": []}
    for kind, filename in CATEGORY_FILES.items():
        path = output_dir / filename
        editable, metadata = flatten_unified(unified[kind])
        raw.dump_json(path, editable)
        raw.dump_json(meta_dir / filename, metadata)
        manifest["files"].append({"category": kind, "file": filename, "objects": unified[kind]["object_count"]})
        print(f"MERGE   {kind:15} -> {filename} ({unified[kind]['object_count']} objects)")
    raw.dump_json(meta_dir / "manifest.json", manifest)


def load_editable(output_dir: Path, raw_dir: Path) -> list[tuple[str, dict[str, Any], dict[str, Any]]]:
    documents: list[tuple[str, dict[str, Any], dict[str, Any]]] = []
    for kind, filename in CATEGORY_FILES.items():
        path = output_dir / filename
        try:
            document = json.loads(path.read_text(encoding="utf-8-sig"))
        except FileNotFoundError as exc:
            raise raw.FormatError(f"editable file not found: {path}; run export first") from exc
        except json.JSONDecodeError as exc:
            raise raw.FormatError(f"invalid JSON in {path}: line {exc.lineno}, column {exc.colno}: {exc.msg}") from exc
        meta_path = raw_dir / META_SUBDIRECTORY / filename
        try:
            metadata = json.loads(meta_path.read_text(encoding="utf-8-sig"))
        except FileNotFoundError as exc:
            raise raw.FormatError(f"internal metadata not found: {meta_path}; run export first") from exc
        except json.JSONDecodeError as exc:
            raise raw.FormatError(f"invalid internal metadata in {meta_path}: {exc}") from exc
        if not isinstance(document, dict):
            raise raw.FormatError(f"{path}: root must be an object keyed by object id")
        if metadata.get("format") != "warcraft-3-minimal-object-metadata-v1" or metadata.get("category") != kind:
            raise raw.FormatError(f"unsupported internal metadata: {meta_path}")
        documents.append((kind, document, metadata))
    return documents


def locate_modification(raw_by_file: dict[str, dict[str, Any]], source: Any, label: str) -> dict[str, Any]:
    if not isinstance(source, dict):
        raise raw.FormatError(f"{label}: missing internal source locator")
    filename = source.get("file")
    group = source.get("group")
    oi = source.get("object_index")
    mi = source.get("modification_index")
    try:
        return raw_by_file[filename][group][oi]["modifications"][mi]
    except (KeyError, IndexError, TypeError) as exc:
        raise raw.FormatError(f"{label}: invalid internal source locator") from exc


def assign_value(modification: dict[str, Any], value: Any, label: str) -> None:
    type_name = modification["type"]
    field_id = modification["field"].get("text")
    if type_name == "int" and field_id == "Ncl2" and isinstance(value, str):
        by_name = {name.casefold(): number for number, name in TARGET_TYPES.items()}
        value = by_name.get(value.strip().casefold(), value)
    if type_name == "int" and field_id == "Ncl3" and isinstance(value, str) and not re.fullmatch(r"[+-]?\d+", value.strip()):
        names = {name.casefold(): flag for flag, name in CHANNEL_OPTIONS.items()}
        parts = [part.strip().casefold() for part in value.split(",") if part.strip()]
        if parts == ["none"] or not parts:
            value = 0
        elif all(part in names for part in parts):
            value = sum(names[part] for part in parts)
    if type_name == "string":
        if not isinstance(value, str):
            raise raw.FormatError(f"{label}.value: expected text")
        if "resolved_value" in modification["data"]:
            modification["data"]["resolved_value"] = value
        else:
            modification["data"]["value"] = value
    elif type_name == "int":
        if isinstance(value, str) and re.fullmatch(r"[+-]?\d+", value.strip()):
            value = int(value.strip())
        if not isinstance(value, int) or isinstance(value, bool):
            raise raw.FormatError(f"{label}.value: expected an integer")
        modification["data"]["value"] = value
    elif type_name in ("real", "unreal"):
        if isinstance(value, str) and value.strip().lower() not in {"nan", "infinity", "-infinity"}:
            try:
                value = float(value.strip())
            except ValueError:
                pass
        if not isinstance(value, (int, float, str)) or isinstance(value, bool):
            raise raw.FormatError(f"{label}.value: expected a number")
        modification["data"]["value"] = value
    elif type_name == "bool":
        if not isinstance(value, bool):
            raise raw.FormatError(f"{label}.value: expected true or false")
        modification["data"]["value"] = value
    else:
        modification["data"]["value"] = value


def apply_editable(editable_documents: list[tuple[str, dict[str, Any], dict[str, Any]]], raw_documents: list[dict[str, Any]]) -> None:
    raw_by_file = {document["source_file"]: document for document in raw_documents}
    seen_sources: set[tuple[Any, ...]] = set()
    for kind, document, metadata in editable_documents:
        meta_objects = metadata.get("objects")
        if not isinstance(meta_objects, dict) or set(document) != set(meta_objects):
            raise raw.FormatError(f"{kind}: object ids do not match internal metadata")
        for object_id_value, obj in document.items():
            label_prefix = f"{kind}.{object_id_value}"
            if not isinstance(obj, dict):
                raise raw.FormatError(f"{label_prefix}: expected an object")
            meta_object = meta_objects[object_id_value]
            if obj.get("base_id") != meta_object.get("base_id"):
                raise raw.FormatError(f"{label_prefix}.base_id is structural and must not be changed")
            name_source = meta_object.get("name_source")
            if name_source is not None:
                modification = locate_modification(raw_by_file, name_source, f"{label_prefix}.name")
                assign_value(modification, obj.get("name"), f"{label_prefix}.name")
                seen_sources.add(tuple(name_source.get(key) for key in ("file", "group", "object_index", "modification_index")))
            meta_fields = meta_object.get("fields")
            if not isinstance(meta_fields, dict):
                raise raw.FormatError(f"{label_prefix}: invalid internal field metadata")
            expected_properties = {"name", "base_id", *meta_fields.keys()}
            if set(obj) != expected_properties:
                missing = expected_properties - set(obj)
                extra = set(obj) - expected_properties
                raise raw.FormatError(f"{label_prefix}: fields differ from metadata; missing={sorted(missing)}, extra={sorted(extra)}")
            for property_name, field_meta in meta_fields.items():
                label = f"{label_prefix}.{property_name}"
                source = field_meta.get("source")
                source_key = tuple(source.get(key) for key in ("file", "group", "object_index", "modification_index")) if isinstance(source, dict) else ()
                if source_key in seen_sources:
                    raise raw.FormatError(f"{label}: duplicate internal source locator")
                seen_sources.add(source_key)
                modification = locate_modification(raw_by_file, source, label)
                assign_value(modification, obj[property_name], label)


def prepare_documents(output_dir: Path, raw_dir: Path) -> tuple[list[dict[str, Any]], list[tuple[Path, dict[str, Any], bytes, dict[str, Any]]]]:
    editable_documents = load_editable(output_dir, raw_dir)
    _, loaded = raw.load_documents(raw_dir)
    raw_documents = [copy.deepcopy(document) for _, document, _, _ in loaded]
    apply_editable(editable_documents, raw_documents)
    prepared = []
    by_name = {path.name: (path, entry) for path, _, _, entry in loaded}
    for document in raw_documents:
        path, entry = by_name[raw.OUTPUT_NAMES[document["source_file"]]]
        encoded = raw.encode_object_file(document, path.name)
        kind, mode = raw.FORMAT_BY_EXTENSION[Path(document["source_file"]).suffix.lower()]
        raw.parse_object_file(encoded, document["source_file"], kind, mode, {})
        prepared.append((path, document, encoded, entry))
    return raw_documents, prepared


def views_from_raw(raw_documents: list[dict[str, Any]], common_j: Path) -> dict[str, tuple[dict[str, Any], dict[str, Any]]]:
    unified = build_unified(raw_documents, common_field_names(common_j))
    return {kind: flatten_unified(unified[kind]) for kind in CATEGORY_FILES}


def read_map_documents(map_dir: Path) -> list[dict[str, Any]]:
    wts = raw.parse_wts(map_dir / "war3map.wts")
    documents: list[dict[str, Any]] = []
    for source in raw.discover_map_files(map_dir):
        kind, mode = raw.FORMAT_BY_EXTENSION[source.suffix.lower()]
        documents.append(raw.parse_object_file(source.read_bytes(), source.name, kind, mode, wts))
    raw.share_display_names(documents)
    return documents


def write_raw_baseline(map_dir: Path, raw_dir: Path, documents: list[dict[str, Any]]) -> None:
    raw_dir.mkdir(parents=True, exist_ok=True)
    manifest: dict[str, Any] = {
        "format": "warcraft-3-object-data-manifest-v1",
        "map_directory": str(map_dir),
        "files": [],
    }
    by_source = {document["source_file"]: document for document in documents}
    for source in raw.discover_map_files(map_dir):
        document = by_source[source.name]
        json_name = raw.OUTPUT_NAMES[source.name]
        raw.dump_json(raw_dir / json_name, document)
        manifest["files"].append({"json": json_name, "binary": source.name, "sha256": raw.sha256(source.read_bytes())})
    raw.dump_json(raw_dir / "manifest.json", manifest)


def rebase_editable_onto_map(map_dir: Path, output_dir: Path, raw_dir: Path, common_j: Path) -> None:
    editable_documents = load_editable(output_dir, raw_dir)
    user_by_kind = {kind: document for kind, document, _ in editable_documents}
    _, loaded = raw.load_documents(raw_dir)
    baseline_documents = [document for _, document, _, _ in loaded]
    baseline_views = views_from_raw(baseline_documents, common_j)
    current_documents = read_map_documents(map_dir)
    current_views = views_from_raw(current_documents, common_j)

    conflicts: list[str] = []
    merged: dict[str, tuple[dict[str, Any], dict[str, Any]]] = {}
    for kind in CATEGORY_FILES:
        baseline, _ = baseline_views[kind]
        current, current_meta = current_views[kind]
        user = user_by_kind[kind]
        if set(user) != set(baseline):
            raise raw.FormatError(f"{kind}: editable object ids changed; cannot merge safely")
        for object_id_value, baseline_object in baseline.items():
            user_object = user[object_id_value]
            if set(user_object) != set(baseline_object):
                raise raw.FormatError(f"{kind}.{object_id_value}: editable fields changed; cannot merge safely")
            for property_name, baseline_value in baseline_object.items():
                if property_name == "base_id" or user_object[property_name] == baseline_value:
                    continue
                if object_id_value not in current or property_name not in current[object_id_value]:
                    conflicts.append(f"{kind}.{object_id_value}.{property_name} (field removed in World Editor)")
                    continue
                current_value = current[object_id_value][property_name]
                user_value = user_object[property_name]
                if current_value != baseline_value and current_value != user_value:
                    conflicts.append(f"{kind}.{object_id_value}.{property_name}")
                    continue
                current[object_id_value][property_name] = user_value
        merged[kind] = (current, current_meta)

    if conflicts:
        preview = ", ".join(conflicts[:5])
        extra = f" and {len(conflicts) - 5} more" if len(conflicts) > 5 else ""
        raise raw.FormatError(f"World Editor and JSON changed the same field(s): {preview}{extra}")

    validation_input = [(kind, merged[kind][0], merged[kind][1]) for kind in CATEGORY_FILES]
    apply_editable(validation_input, copy.deepcopy(current_documents))
    write_raw_baseline(map_dir, raw_dir, current_documents)
    meta_dir = raw_dir / META_SUBDIRECTORY
    meta_dir.mkdir(parents=True, exist_ok=True)
    for kind, filename in CATEGORY_FILES.items():
        editable, metadata = merged[kind]
        raw.dump_json(output_dir / filename, editable)
        raw.dump_json(meta_dir / filename, metadata)
    print("REBASE  World Editor changes and editable JSON were merged safely")


def check_workspace(map_dir: Path, output_dir: Path, raw_dir: Path) -> None:
    _, prepared = prepare_documents(output_dir, raw_dir)
    changed = 0
    for _, document, encoded, _ in prepared:
        current = (map_dir / document["source_file"]).read_bytes()
        changed += current != encoded
        print(f"OK      {document['source_file']:18} ({'will change' if current != encoded else 'same'})")
    print(f"CHECK OK: all convenient files are valid; {changed} binary files will change")


def import_workspace(map_dir: Path, output_dir: Path, raw_dir: Path, backup_dir: Path, common_j: Path, force: bool) -> None:
    raw_documents, prepared = prepare_documents(output_dir, raw_dir)
    stale = []
    for _, document, _, entry in prepared:
        target = map_dir / document["source_file"]
        if not target.is_file():
            raise raw.FormatError(f"target binary file not found: {target}")
        if not force and raw.sha256(target.read_bytes()) != entry.get("sha256"):
            stale.append(target.name)
    if stale:
        print(f"NOTICE  newer World Editor data detected in {', '.join(stale)}")
        rebase_editable_onto_map(map_dir, output_dir, raw_dir, common_j)
        raw_documents, prepared = prepare_documents(output_dir, raw_dir)
    for document in raw_documents:
        raw.dump_json(raw_dir / raw.OUTPUT_NAMES[document["source_file"]], document)
    raw.import_files(map_dir, raw_dir, backup_dir, force=force)


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description="Convenient merged Warcraft III object editor")
    result.add_argument("--config", type=Path, default=Path("object-data.config.json"))
    commands = result.add_subparsers(dest="command", required=True)
    export = commands.add_parser("export")
    export.add_argument("--force", action="store_true")
    commands.add_parser("check")
    imp = commands.add_parser("import")
    imp.add_argument("--force", action="store_true")
    return result


def main() -> int:
    args = parser().parse_args()
    try:
        map_dir, output_dir, raw_dir, backup_dir, common_j = load_config(args.config.resolve())
        if args.command == "export":
            export_workspace(map_dir, output_dir, raw_dir, common_j, args.force)
        elif args.command == "check":
            check_workspace(map_dir, output_dir, raw_dir)
        elif args.command == "import":
            import_workspace(map_dir, output_dir, raw_dir, backup_dir, common_j, args.force)
        return 0
    except (raw.FormatError, OSError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
