"""Stage Crocodile MAIN objects using the project's lossless object workspace.

Existing objects are preserved, including unsaved editable JSON values. This
command only stages JSON/metadata; the regular check/save task writes the map.
"""
from pathlib import Path
import copy
import json
import re

import war3_object_data as raw
import war3_object_workspace as objects

ROOT = Path(__file__).resolve().parents[1]
IDS_PATH = ROOT / "object-data/crocodile-main-ids.json"


def code(value):
    return raw.rawcode_to_json(value.encode("ascii"))


def set_field(obj, field, value, kind="string", level=0, pointer=0, leveled=True):
    found = next((m for m in obj["modifications"]
                  if m["field"]["text"] == field and m.get("level", 0) == level), None)
    if found is None:
        found = {"field": code(field), "field_name": "", "type": kind,
                 "data": {}, "sanity_check": copy.deepcopy(obj["new_id"])}
        if leveled:
            found.update(level=level, data_pointer=pointer)
        obj["modifications"].append(found)
    found["data"] = {"value": value}
    found["type"] = kind


def raw_index(documents):
    result = {}
    for document in documents:
        for group in ("original_objects", "custom_objects"):
            for obj in document[group]:
                result[(document["kind"], objects.object_id(obj))] = obj
    return result


def allocate(prefix, used):
    # Standard editor custom IDs: prefix + three hexadecimal digits.
    for number in range(0x1000):
        candidate = f"{prefix}{number:03X}"
        if candidate not in used:
            used.add(candidate)
            return candidate
    raise ValueError(f"No free {prefix} rawcode")


def clone_object(source, destination, mapping, strings):
    obj = copy.deepcopy(source)
    old = objects.object_id(obj)
    obj["new_id"] = code(destination)
    for mod in obj["modifications"]:
        if mod["sanity_check"].get("text") == old:
            mod["sanity_check"] = code(destination)
        if mod["type"] == "string":
            value = objects.value_for_user(mod)
            value = raw.resolve_trigger_string(value, strings) or value
            if value.startswith("TRIGSTR_"):
                raise ValueError(f"Unresolved TEST string in {old}: {value}")
            for before, after in mapping.items():
                value = re.sub(rf"\b{re.escape(before)}\b", after, value)
            mod["data"] = {"value": value}
    return obj


def configure():
    main, _ = objects.prepare_documents(ROOT / "object-data", ROOT / ".object-data-raw")
    test, _ = objects.prepare_documents(ROOT / "test_map/object-data", ROOT / "test_map/.object-data-raw")
    # Earlier staging used TEST identities. MAIN already owns this hero and its
    # eight abilities: keep those production identities and editor settings.
    previous = json.loads(IDS_PATH.read_text()) if IDS_PATH.exists() else {}
    if previous.get("hero") == "Z00A":
        duplicates = {previous[s] for s in "hero Q W E R T T2 F G".split()}
        for document in main:
            document["custom_objects"] = [o for o in document["custom_objects"]
                                           if objects.object_id(o) not in duplicates]
    originals = copy.deepcopy(main)
    index = raw_index(main)
    source = raw_index(test)
    # Include code references and every object namespace, avoiding both existing
    # and reserved/deleted object IDs from production sources.
    used = {identity for _, identity in index}
    for path in (ROOT / "triggers").rglob("*.j"):
        used.update(re.findall(r"'([^'\r\n]{4})'", path.read_text(encoding="utf-8-sig")))
    old_codes = ["A000", "A001", "A002", "A003", "A004", "A015", "A01V", "A01U"]
    mapping = dict(zip(old_codes, "A0I7 A0I8 A0I9 A0IA A0IB A0IC A0ID A0IE".split()))
    ids = {"hero": "H02M", **dict(zip("Q W E R T T2 F G".split(), mapping.values()))}
    for label, prefix in [("QMarkAbility", "A"), ("QMarkBuff", "B"),
                          ("GSpeedAbility", "A"), ("GSpeedBuff", "B")]:
        ids[label] = previous.get(label) or allocate(prefix, used)
    strings = raw.parse_wts(ROOT / "_build/crocodile-source-audit/war3map.wts")
    if not strings:
        raise ValueError("Extract the saved TEST archive's WTS into _build/crocodile-source-audit first")
    added = {kind: [] for kind in ("abilities", "units", "buffs")}
    hero = index[("units", ids["hero"])]
    assert "Crocodile" in next(objects.value_for_user(m) for m in hero["modifications"] if m["field"]["text"] == "unam")
    skills = {identity: index[("abilities", identity)] for identity in mapping.values()}
    set_field(skills[ids["T"]], "Ncl1", 5.0, "unreal", level=1, pointer=1)
    # Channel order remains ambush; T2 remains usable during the channel.
    set_field(skills[ids["T"]], "Ncl5", 0, "int", level=1, pointer=5)
    set_field(skills[ids["T"]], "Ncl6", "ambush", level=1, pointer=6)
    set_field(skills[ids["T"]], "aub1", "Crocodile places a hand on the ground to dry out a large area, turning it into sand. Channels for 5 seconds; sand expands for 3 seconds. Ground Death unlocks after 1 second.", level=1)
    set_field(skills[ids["T2"]], "aub1", "Crocodile drains all moisture on contact. Detonates his active sand, including trails from other abilities, and removes it after the explosion.", level=1)
    for slot in "Q W E R T T2 F G".split():
        obj = skills[ids[slot]]
        if slot in "FG":
            set_field(obj, "alev", 1, "int")
        # Higher MAIN levels still contain the template hero's (Saber) lore.
        # Keep Crocodile's production description; runtime tooltips supply stats.
        description = next(objects.value_for_user(m) for m in obj["modifications"]
                           if m["field"]["text"] == "aub1" and m.get("level", 0) == 1)
        description = re.sub(r"\|cffffff00Cooldown:.*?(?:\|r|$)", "", description, flags=re.I | re.S).strip()
        for mod in obj["modifications"]:
            if mod["field"]["text"] in {"aub1", "arut"}:
                mod["data"] = {"value": description}

    def make_buff(template, identity, title, icon, art):
        if ("buffs", identity) in index:
            return
        obj = clone_object(index[("buffs", template)], identity, {}, {})
        for field, value in {"fnam": title, "ftip": title, "fube": title,
                             "fart": icon, "ftat": art, "fta0": "origin"}.items():
            set_field(obj, field, value, leveled=False)
        added["buffs"].append(obj)

    make_buff("B012", ids["QMarkBuff"], "Desert Spada: Sand Mark",
              "ReplaceableTextures\\CommandButtons\\BTNHero_Crocodile_Q.blp",
              "war3mapImported\\wos_az_f076_clear.mdl")
    make_buff("B02S", ids["GSpeedBuff"], "Suna Suna no Mi: Sand Speed",
              "ReplaceableTextures\\CommandButtons\\BTNHero_Crocodile_G.blp", "")

    def make_ability(template, identity, title, buff, duration, targets, data):
        if ("abilities", identity) in index:
            obj = index[("abilities", identity)]
            for field, value in data.items():
                set_field(obj, field, value, "unreal", 1, int(field[-1]))
            return
        obj = clone_object(index[("abilities", template)], identity, {}, {})
        # Keep only level one of the template; no inherited combat bonuses/art.
        obj["modifications"] = [m for m in obj["modifications"] if m.get("level", 0) <= 1]
        for field, value, kind, level in (
            ("anam", title, "string", 0), ("alev", 1, "int", 0),
            ("aher", 0, "int", 0), ("aite", 0, "int", 0),
            ("amcs", 0, "int", 1), ("acdn", 0.0, "unreal", 1),
            ("aran", 99999.0, "unreal", 1), ("adur", duration, "unreal", 1),
            ("ahdu", duration, "unreal", 1), ("abuf", buff, "string", 1),
            ("atar", targets, "string", 1), ("acat", "", "string", 0),
            ("atat", "", "string", 0), ("aeat", "", "string", 0),
        ):
            set_field(obj, field, value, kind, level)
        for field, value in data.items():
            set_field(obj, field, value, "unreal", 1, int(field[-1]))
        added["abilities"].append(obj)

    make_ability("A03U", ids["QMarkAbility"], "Crocodile Q Sand Mark", ids["QMarkBuff"],
                 20.0, "air,ground,enemy,organic,vulnerable,invulnerable", {"Slo1": 0.0, "Slo2": 0.0})
    make_ability("A0GE", ids["GSpeedAbility"], "Crocodile G Sand Speed", ids["GSpeedBuff"],
                 0.35, "air,ground,friend,self,organic,vulnerable,invulnerable",
                 {"Blo1": 0.0, "Blo2": 80.0/310.0, "Blo3": 0.0})
    for kind, entries in added.items():
        document = next(d for d in main if d["kind"] == kind and not d["source_file"].startswith("war3mapSkin"))
        document["custom_objects"].extend(entries)
    # MAIN splits art and gameplay between normal and Skin files. Gameplay
    # fields belong to the normal object, otherwise the editable merged view
    # exposes two values and native Channel may retain its old zero duration.
    base_abilities = raw_index([d for d in main if d["kind"] == "abilities" and not d["source_file"].startswith("war3mapSkin")])
    for document in main:
        if document["kind"] != "abilities" or not document["source_file"].startswith("war3mapSkin"):
            continue
        for obj in document["custom_objects"]:
            identity = objects.object_id(obj)
            if identity not in mapping.values():
                continue
            base = base_abilities[("abilities", identity)]
            for mod in list(obj["modifications"]):
                field = mod["field"]["text"]
                if field == "alev" or field.startswith("Ncl"):
                    set_field(base, field, objects.value_for_user(mod), mod["type"], mod.get("level", 0), mod.get("data_pointer", 0))
                    obj["modifications"].remove(mod)
    # Verify that all pre-existing objects remain byte-for-byte identical in the
    # prepared object documents; only new objects enter MAIN.
    updated = raw_index(main)
    allowed = {( "abilities", identity) for identity in [*mapping.values(), ids["GSpeedAbility"]]}
    assert all(updated[key] == value for key, value in raw_index(originals).items() if key not in allowed)
    for document in main:
        raw.encode_object_file(document, document["source_file"])
        raw.dump_json(ROOT / ".object-data-raw" / raw.OUTPUT_NAMES[document["source_file"]], document)
    for kind, (editable, metadata) in objects.views_from_raw(main, ROOT / "libs/common.j").items():
        raw.dump_json(ROOT / "object-data" / objects.CATEGORY_FILES[kind], editable)
        raw.dump_json(ROOT / ".object-data-raw/workspace-meta" / objects.CATEGORY_FILES[kind], metadata)
    raw.dump_json(IDS_PATH, ids)
    path = ROOT / "triggers/Heroes/Crocodile.j"
    text = path.read_text(encoding="utf-8-sig")
    replacements = {f"Crocodile{slot}_ID": ids[slot] for slot in "Q W E R T T2 F G".split()}
    replacements.update(CrocodileQ_SandMark_Ability_ID=ids["QMarkAbility"],
                        CrocodileQ_SandMark_Buff_ID=ids["QMarkBuff"],
                        CrocodileG_SandMS_Ability_ID=ids["GSpeedAbility"],
                        CrocodileG_SandMS_Buff_ID=ids["GSpeedBuff"])
    replacements["Crocodile_ID"] = ids["hero"]
    for name, identity in replacements.items():
        text, count = re.subn(rf"(integer {name}\s*=\s*)(?:'[^']*'|0)", rf"\g<1>'{identity}'", text)
        assert count == 1, (name, count)
    path.write_bytes(text.replace("\n", "\r\n").encode("utf-8"))
    print(json.dumps(ids, indent=2))
    print("Existing MAIN objects preserved; Crocodile objects staged for normal check/save.")


if __name__ == "__main__":
    configure()
