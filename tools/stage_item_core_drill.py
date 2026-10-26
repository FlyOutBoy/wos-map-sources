"""Stage the Core Drill item (Gurren Lagann) in MAIN object data (idempotent).

Universal item: +20 allstats, 7500 gold (Pakkun +20 + 4000). Physical or magic
ability damage grants a stack of that type (+5% damage of the same type, up to
5 stacks). Each type shows its own buff on the holder: a dummy casts a copy of
the Black Clover Inner Fire (A07D) at the stack level, with zeroed bonuses, so
the previous level's buff can be removed. Only object JSON/raw/metadata are
staged; the regular check/save writes the map. Rawcodes are kept in
object-data/items-core-drill-id.json.
"""
from pathlib import Path
import json
import re

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field, clone_object, allocate

ROOT = Path(__file__).resolve().parents[1]
IDS_PATH = ROOT / "object-data/items-core-drill-id.json"
ICON = "ReplaceableTextures\\CommandButtons\\BTNItem_CoreDrill.blp"
TITLE = "Core Drill"
TIP = ("+20 allstats\nPassive: Dealing physical or magic damage with abilities grants a stack of that damage "
       "type. Each stack increases your damage of the same type by 5% (up to 5 stacks, +25%). Physical and "
       "magic stacks are separate and shown as their own buffs.\nDuration: 4 sec, refreshed by each new stack.")
STACKS = 5
DURATION = 4.0
TYPES = (("Phys", "Physical", "physical"), ("Mag", "Magic", "magic"))
BUFF_ICON = "ReplaceableTextures\\CommandButtons\\BTNItem_CoreDrill{}.blp"  # red Phys / blue Mag

# label -> (kind, template)
NEW_OBJECTS = [("CoreDrill", "items", "I040")]
for key, _, _ in TYPES:
    NEW_OBJECTS.append((f"CoreDrill{key}Abi", "abilities", "A07D"))
    NEW_OBJECTS += [(f"CoreDrill{key}Buff{n}", "buffs", "B00M") for n in range(1, STACKS + 1)]

FILES = {"abilities": ("war3map.w3a", "war3mapSkin.w3a"),
         "buffs": ("war3map.w3h", "war3mapSkin.w3h"),
         "items": ("war3map.w3t", "war3mapSkin.w3t")}
PREFIX = {"abilities": "A", "buffs": "B", "items": "I"}


def main_map():
    config = json.loads((ROOT / ".vscode/wos-build.json").read_text(encoding="utf-8"))
    return Path(config["mainMap"])


def stage():
    documents, _ = objects.prepare_documents(ROOT / "object-data", ROOT / ".object-data-raw")
    by_file = {d["source_file"]: d for d in documents}
    used = {objects.object_id(o) for d in documents for g in ("original_objects", "custom_objects") for o in d[g]}
    for path in (ROOT / "triggers").rglob("*.j"):
        used.update(re.findall(r"'([^'\r\n]{4})'", path.read_text(encoding="utf-8-sig", errors="replace")))
    ids = json.loads(IDS_PATH.read_text()) if IDS_PATH.exists() else {}
    # TEST heroes (e.g. Altair A11E-A12B) are transferred to MAIN later: never reuse their rawcodes.
    reserved = set()
    for path in (ROOT / "test_map").rglob("*"):
        if path.suffix in (".json", ".j") and path.is_file():
            text = path.read_text(encoding="utf-8", errors="replace")
            reserved.update(re.findall(r"'([AB][0-9A-Z]{3})'", text))
            reserved.update(re.findall(r'"([AB][0-9A-Z]{3})"\s*:', text))
    for label, kind, _ in NEW_OBJECTS:
        if label in ids and ids[label] in reserved:
            for name in FILES[kind]:  # drop an earlier clone that took a reserved code
                document = by_file[name]
                document["custom_objects"] = [o for o in document["custom_objects"] if objects.object_id(o) != ids[label]]
            del ids[label]
    used |= reserved
    for label, kind, _ in NEW_OBJECTS:
        if label not in ids:
            ids[label] = allocate(PREFIX[kind], used)
            used.add(ids[label])
    strings = raw.parse_wts(main_map() / "war3map.wts")
    for label, kind, template in NEW_OBJECTS:
        for name in FILES[kind]:
            existing = {objects.object_id(o): o for o in by_file[name]["custom_objects"]}
            if ids[label] not in existing and template in existing:
                by_file[name]["custom_objects"].append(clone_object(existing[template], ids[label], {}, strings))

    def obj(kind, label, skin=False):
        name = FILES[kind][1 if skin else 0]
        return next((o for o in by_file[name]["custom_objects"] if objects.object_id(o) == ids[label]), None)

    item = obj("items", "CoreDrill")
    set_field(item, "iabi", "A00W", leveled=False)  # Hero ALST + 20
    set_field(item, "igol", 7500, "int", leveled=False)
    for field, value in (("unam", TITLE), ("utip", TITLE), ("utub", TIP), ("ides", TIP), ("iico", ICON)):
        set_field(obj("items", "CoreDrill", skin=True), field, value, leveled=False)

    for key, title, word in TYPES:
        for skin in (False, True):
            ability = obj("abilities", f"CoreDrill{key}Abi", skin)
            if ability is not None:  # Black Clover has a 6th level: Core Drill stops at 5.
                ability["modifications"] = [m for m in ability["modifications"] if m.get("level", 0) <= STACKS]
        ability = obj("abilities", f"CoreDrill{key}Abi")
        set_field(ability, "alev", STACKS, "int", 0)
        set_field(ability, "anam", f"Buff Core Drill {title}", "string", 0)
        for n in range(1, STACKS + 1):
            set_field(ability, "abuf", ids[f"CoreDrill{key}Buff{n}"], "string", n)
            set_field(ability, "adur", DURATION, "unreal", n)
            set_field(ability, "ahdu", DURATION, "unreal", n)
            set_field(ability, "Inf1", 0.0, "unreal", n, 1)
            set_field(ability, "Inf2", 0, "int", n, 2)
            set_field(ability, "Inf3", 0.0, "unreal", n, 3)
        skin = obj("abilities", f"CoreDrill{key}Abi", skin=True)
        if skin is not None:
            for n in range(1, STACKS + 1):
                set_field(skin, "atp1", f"Core Drill: {title} {n}/{STACKS}", "string", n)
                set_field(skin, "aub1", f"+{5 * n}% {word} ability damage.", "string", n)
            set_field(skin, "aart", BUFF_ICON.format(key), "string", 0)
        for n in range(1, STACKS + 1):
            buff = obj("buffs", f"CoreDrill{key}Buff{n}", skin=True)
            for field, value in (("ftip", f"Core Drill: {title} ({n}/{STACKS})"),
                                 ("fube", f"+{5 * n}% {word} ability damage. Each {word} ability hit adds a stack "
                                          f"and refreshes it ({DURATION:g} sec)."),
                                 ("fart", BUFF_ICON.format(key)), ("ftat", ""), ("fnam", f"Core Drill {title} {n}"),
                                 ("fnsf", "")):
                set_field(buff, field, value, leveled=False)

    for document in documents:
        raw.encode_object_file(document, document["source_file"])
        raw.dump_json(ROOT / ".object-data-raw" / raw.OUTPUT_NAMES[document["source_file"]], document)
    for kind, (editable, metadata) in objects.views_from_raw(documents, ROOT / "libs/common.j").items():
        raw.dump_json(ROOT / "object-data" / objects.CATEGORY_FILES[kind], editable)
        raw.dump_json(ROOT / ".object-data-raw/workspace-meta" / objects.CATEGORY_FILES[kind], metadata)
    raw.dump_json(IDS_PATH, ids)
    print(json.dumps(ids))


if __name__ == "__main__":
    stage()
