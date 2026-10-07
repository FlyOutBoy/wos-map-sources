#!/usr/bin/env python3
"""Adapt EXISTING Crocodile TEST objects; no MAIN writes and no new rawcodes.

Run before the existing object-data.crocodile.config.json import command.
The editable JSON and unpacked map remain in the project's existing workflow.
"""
from pathlib import Path
import json
import copy
import war3_object_data as raw

TEST_BASE_MOVE_SPEED = 350  # TODO BALANCE: 522 leaves no room for the +80 sand bonus.

# Explicit field schema for additions to EXISTING objects. The editor workspace
# deliberately rejects fields without metadata, so extend its lossless records
# and locators together, then let its existing check/import validate/write MPQs.
FIELDS = {
    "follow_through_time": ("Ncl1", "unreal"),
    "target_type": ("Ncl2", "int"),
    "options": ("Ncl3", "int"),
    "field_Ncl5": ("Ncl5", "int"),
    "cooldown": ("acdn", "unreal"),
    "tooltip": ("atp1", "string"),
    "extended_tooltip": ("aub1", "string"),
    "acquisition_range": ("uacq", "unreal"),
    "attack_2_cooldown": ("ua2c", "unreal"),
    "field_uaen": ("uaen", "int"),
    "field_ua2w": ("ua2w", "string"),
    "field_ua2t": ("ua2t", "string"),
    "field_udp2": ("udp2", "unreal"),
    "field_uma2": ("uma2", "unreal"),
    "field_abpx": ("abpx", "int"),
    "field_abpy": ("abpy", "int"),
    "animation_names": ("aani", "string"),
}


def extend_metadata(workspace: Path, edited: dict) -> None:
    directory = workspace / "test_map/.object-data-raw"
    changed = {}
    changed_meta = {}
    for category, document in edited.items():
        meta_path = directory / "workspace-meta" / f"{category}.json"
        meta = json.loads(meta_path.read_text(encoding="utf-8-sig"))
        for code, obj in document.items():
            entry = meta["objects"][code]
            for prop in set(obj) - {"name", "base_id", *entry["fields"]}:
                base, _, level_text = prop.partition(" level ")
                field, type_name = FIELDS[base]
                level = int(level_text) if level_text else 0
                # A fresh Export can choose a different friendly name for a field.
                # Reuse its existing locator instead of appending a duplicate.
                alias = next((key for key, info in entry["fields"].items()
                    if info["field_id"] == field and (info["level"] or 0) == level), None)
                if alias is not None:
                    obj[alias] = obj.pop(prop)
                    continue
                source = entry["name_source"]
                filename = source["file"]
                if filename not in changed:
                    changed[filename] = json.loads((directory / raw.OUTPUT_NAMES[filename]).read_text(encoding="utf-8-sig"))
                obj_raw = changed[filename][source["group"]][source["object_index"]]
                if obj_raw["new_id"]["text"] != code:
                    raise ValueError(f"Unexpected raw object locator for {code}")
                modification = {
                    "field": raw.rawcode_to_json(field.encode("ascii")),
                    "field_name": "",
                    "type": type_name,
                    "data": {"value": 0 if type_name != "string" else ""},
                    "sanity_check": copy.deepcopy(obj_raw["new_id"]),
                }
                pointer = int(field[-1]) if field.startswith("Ncl") else 0
                if category == "abilities":
                    modification.update(level=level, data_pointer=pointer)
                locator = {**source, "modification_index": len(obj_raw["modifications"])}
                obj_raw["modifications"].append(modification)
                entry["fields"][prop] = {
                    "source": locator, "field_id": field, "type": type_name,
                    "level": level if category == "abilities" else None,
                    "variation": None, "data_pointer": pointer if category == "abilities" else None,
                }
        changed_meta[meta_path] = meta
    for filename, document in changed.items():
        raw.dump_json(directory / raw.OUTPUT_NAMES[filename], document)
    for path, document in changed_meta.items():
        raw.dump_json(path, document)


def configure(workspace: Path) -> None:
    folder = workspace / "test_map/object-data"
    abilities_path = folder / "abilities.json"
    units_path = folder / "units.json"
    abilities = json.loads(abilities_path.read_text(encoding="utf-8-sig"))
    units = json.loads(units_path.read_text(encoding="utf-8-sig"))
    if "Crocodile" not in units["H00A"].get("model", ""):
        raise ValueError("H00A is not the Crocodile TEST object; refusing to edit")
    names = {
        "A000": "Desert Spada",
        "A001": "Desert Girasole",
        "A002": "Crescent Cutlass",
        "A003": "Sables",
        "A004": "Ground Secco",
        "A015": "Ground Death",
    }
    for rawcode, name in names.items():
        obj = abilities[rawcode]
        if obj["base_id"] != "ANcl":
            raise ValueError(f"{rawcode}: expected existing Channel ability")
        obj["name"] = name
        obj["tooltip level 1"] = name
        if rawcode in ("A004", "A015"):
            obj["animation_names"] = ""  # T/T2 set their model animation by index.
        for level in range(1, 6):
            obj[f"follow_through_time level {level}"] = 3.0 if rawcode == "A004" else 0.0
            obj[f"target_type level {level}"] = "None" if rawcode in ("A004", "A015") else "Point Target"
            obj[f"options level {level}"] = "Visible, Physical Spell"
            obj[f"field_Ncl5 level {level}"] = 0  # Channel: don't disable T2 or other controls.
        if rawcode == "A002":
            for level in range(1, 6):
                obj[f"cooldown level {level}"] = 0.0  # Independent charge clocks own the cooldown.
    # Separate command-card slots are required for simultaneous E/F Tas counters.
    for code, position in {
        "A000": (0,2), "A001": (1,2), "A002": (2,2), "A003": (3,2),
        "A004": (0,1), "A015": (0,1), "A01V": (1,1), "A01U": (2,1),
    }.items():
        abilities[code]["field_abpx"], abilities[code]["field_abpy"] = position
    abilities["A000"]["extended_tooltip level 1"] = "Slashes the ground in a straight line, dealing physical damage once to each enemy hit and slowing them. Leaves a trail of sand."
    abilities["A001"]["extended_tooltip level 1"] = "Three-second quicksand: pulls and deals six physical damage pulses at half-second intervals, slowing enemies. Q/sand interaction explodes once and stuns."
    abilities["A002"]["extended_tooltip level 1"] = "Physical lunge up to 600 units after a 0.15-second windup. Three independently recharging charges (one second per charge), with a one-second interval between lunges. Leaves sand at the destination."
    abilities["A003"]["extended_tooltip level 1"] = "Travelling sand tornado (2.5 seconds, 540 units/s): captured enemies orbit and rise, taking physical damage. Leaves spaced sand patches along its path."
    for code in ("A001", "A002", "A003"):
        for level in range(2, 6):
            abilities[code][f"extended_tooltip level {level}"] = abilities[code]["extended_tooltip level 1"]
    abilities["A004"]["extended_tooltip level 1"] = "Sand spreads in all directions to radius 2100 over three seconds. Ground Death unlocks after 0.5 seconds. Ending or cancelling the channel after this threshold preserves the sand for ten seconds; Ground Death is available while standing in any active Crocodile sand."
    abilities["A015"]["extended_tooltip level 1"] = "After 0.5 seconds, detonate all your active sand, including trails from other abilities. Each enemy inside any patch takes physical damage once. Requires standing in active Crocodile sand during the ten-second window."
    for code in ("A004", "A015"):
        for level in range(2, 6):
            abilities[code][f"extended_tooltip level {level}"] = abilities[code]["extended_tooltip level 1"]
    abilities["A015"]["hotkey"] = "T"
    for key in ("button_position_x", "button_position_y"):
        abilities["A015"].pop(key, None)
    abilities["A015"]["field_abpx"] = 0
    abilities["A015"]["field_abpy"] = 1
    abilities["A01V"]["name"] = "Suna Suna no Mi: La Spada"
    abilities["A01V"]["tooltip level 1"] = "Suna Suna no Mi: La Spada"
    abilities["A01V"]["extended_tooltip level 1"] = "Successful spells grant one stack (maximum three). Each enhanced normal attack consumes one stack: ranged sand blade, range 800, +300% attack speed and agility-based physical damage. Sand blades can launch every two seconds."
    abilities["A01U"]["name"] = "Suna Suna no Mi"
    abilities["A01U"]["tooltip level 1"] = "Suna Suna no Mi"
    abilities["A01U"]["extended_tooltip level 1"] = "Your sand grants movement speed. Spell damage drains 1% maximum mana. All damage increases by 0.35% for each 1% missing target mana, capped at 15%."
    hero = units["H00A"]
    hero["movement_speed"] = TEST_BASE_MOVE_SPEED
    hero["acquisition_range"] = 800.0
    # Weapon 2 detects ranged attacks; F redirects the hit into its scripted slash.
    # Store its range in object data instead of the broken runtime range setter.
    hero["field_uaen"] = 1
    hero["field_ua2w"] = "missile"
    hero["field_ua2t"] = "hero"
    hero["attack_2_range"] = 800
    hero["attack_2_cooldown"] = hero["attack_1_cooldown"]
    hero.pop("field_ua2p", None)
    hero["field_udp2"] = hero["weapon_rf_attack_damage_point"]
    hero["field_ua2g"] = "air,debris,enemies,ground,structure,ward"
    hero["field_uma2"] = 0.0
    hero["field_ua2z"] = 1455
    hero["field_ua2m"] = "war3mapImported\\wos_tx-ha_nitu.mdl"
    extend_metadata(workspace, {"abilities": abilities, "units": units})
    for path, document in ((abilities_path, abilities), (units_path, units)):
        path.write_text(json.dumps(document, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    configure(Path(__file__).resolve().parent.parent)
    print("Existing Crocodile TEST object profile configured; run TEST object import.")
