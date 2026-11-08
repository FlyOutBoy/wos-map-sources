"""Stage the 2026-11-04 item balance in MAIN object data (idempotent).

New item: Dark Repulser (Lostvayne + Elucidator, 10000): +20 allstats, +50% attack speed,
Lostvayne's extra hit with a 0.75 sec cooldown (logic in DmgSys.j).
Changed: Kurikara / Ashisogi Jizo debuffs 5 sec, Ice Coffin cooldown 45 sec,
Sukuna's Finger / Five Elements Seal / Inverted Spear of Heaven cast range 1600,
Frozen Heart aura text (slow resistance, code in SlowUnit / SlowUnitErza).
Allocated rawcodes are kept in object-data/items-2026-11-04-ids.json.
"""
from pathlib import Path
import json
import re

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field, clone_object, allocate

ROOT = Path(__file__).resolve().parents[1]
IDS_PATH = ROOT / "object-data/items-2026-11-04-ids.json"
OLD_IDS = [ROOT / "object-data" / n for n in ("items-2026-10-27-ids.json", "items-2026-10-28-ids.json",
                                               "items-2026-10-28b-ids.json")]
ICON = "ReplaceableTextures\\CommandButtons\\BTNItem_{}.blp"

NEW_OBJECTS = [
    ("DarkRepulser", "items", "I03X"),
    ("DarkRepulserCD", "abilities", "A0HT"),
    ("DarkRepulserAS", "abilities", "A112"),
]

DARK_REPULSER = ("+20 allstats\n+50% attack speed\nPassive: Attacks trigger an additional hit after 0.5 sec, "
                 "dealing 1x ATK as attack damage.\nCooldown: 0.75 sec.")
FROZEN_AURA_OLD = "receive 15% more mana regeneration and mana restoration."
FROZEN_AURA_NEW = ("receive 15% more mana regeneration and mana restoration, and slows on them are 15% weaker "
                   "(45% becomes 30%; a 15% slow is ignored). Slow duration is unchanged.")
FROZEN_BUFF_OLD = "Receives 15% more mana regeneration and mana restoration."
FROZEN_AURA_V1 = FROZEN_AURA_NEW
FROZEN_AURA_NEW = FROZEN_AURA_V1 + " Slow auras are not weakened."
FROZEN_BUFF_V1 = "Receives 15% more mana regeneration and mana restoration. Slows are 15% weaker."
FROZEN_BUFF_NEW = "Receives 15% more mana regeneration and mana restoration. Slows are 15% weaker (slow auras are not)."

# (kind, identity, old text, new text): replaced in every string field of the object (main and skin).
TEXTS = [
    ("items", "I00W", "Duration: 4 sec.", "Duration: 5 sec."),
    ("items", "I04C", "every second for 4 sec.", "every second for 5 sec."),
    ("buffs", "B041", "every second for 4 sec.", "every second for 5 sec."),
    ("items", "I058", "Cooldown: 50 sec.", "Cooldown: 45 sec."),
    ("abilities", "A13C", "Cooldown: 50 sec.", "Cooldown: 45 sec."),
    ("items", "I074", "Cast range: 800", "Cast range: 1600"),
    ("abilities", "A161", "Cast range: 800", "Cast range: 1600"),
    ("items", "I01K", (FROZEN_AURA_V1, FROZEN_AURA_OLD), FROZEN_AURA_NEW),
    ("buffs", "B040", (FROZEN_BUFF_V1, FROZEN_BUFF_OLD), FROZEN_BUFF_NEW),
]


TURN_RATE = 1.75
INSTANT_BASES = {"Absk", "ANbr", "Aroa"}
# Same art fields as stage_instant_foundations.ART_FIELDS (aefs/aefl = effect and loop sound).
INSTANT_PRESENTATION = ("acat", "atat", "asat", "aeat", "aaea", "alig", "amat", "aefs", "aefl", "aani", "acap",
                        "aca1", "ata0", "ata1", "ata2", "ata3", "ata4", "ata5")


def main_map():
    config = json.loads((ROOT / ".vscode/wos-build.json").read_text(encoding="utf-8"))
    return Path(config["mainMap"])


def stage():
    documents, _ = objects.prepare_documents(ROOT / "object-data", ROOT / ".object-data-raw")
    by_file = {d["source_file"]: d for d in documents}
    files = {"abilities": ("war3map.w3a", "war3mapSkin.w3a"),
             "buffs": ("war3map.w3h", "war3mapSkin.w3h"),
             "items": ("war3map.w3t", "war3mapSkin.w3t")}

    def index(name):
        return {objects.object_id(o): o for o in by_file[name]["custom_objects"]}

    used = {objects.object_id(o) for d in documents for g in ("original_objects", "custom_objects") for o in d[g]}
    for path in (ROOT / "triggers").rglob("*.j"):
        used.update(re.findall(r"'([^'\r\n]{4})'", path.read_text(encoding="utf-8-sig", errors="replace")))
    for path in (ROOT / "test_map").rglob("*"):
        if path.suffix in (".json", ".j") and path.is_file():
            text = path.read_text(encoding="utf-8", errors="replace")
            used.update(re.findall(r"'([ABI][0-9A-Z]{3})'", text))
            used.update(re.findall(r'"([ABI][0-9A-Z]{3})"\s*:', text))
    for path in OLD_IDS:
        if path.exists():
            used.update(json.loads(path.read_text()).values())
    ids = json.loads(IDS_PATH.read_text()) if IDS_PATH.exists() else {}
    used.update(ids.values())
    prefix = {"abilities": "A", "buffs": "B", "items": "I"}
    for label, kind, _ in NEW_OBJECTS:
        if label not in ids:
            ids[label] = allocate(prefix[kind], used)
            used.add(ids[label])
    strings = raw.parse_wts(main_map() / "war3map.wts")

    def obj(kind, identity, skin=False):
        return index(files[kind][1 if skin else 0]).get(identity)

    for label, kind, template in NEW_OBJECTS:
        for name in files[kind]:
            existing = index(name)
            if ids[label] in existing or template not in existing:
                continue
            by_file[name]["custom_objects"].append(clone_object(existing[template], ids[label], {}, strings))

    def skin_text(kind, identity, **fields):
        target = obj(kind, identity, skin=True) or obj(kind, identity)
        for field, value in fields.items():
            if kind in ("items", "buffs"):
                set_field(target, field, value, leveled=False)
            else:
                set_field(target, field, value, level=1 if field in ("atp1", "aub1") else 0)

    def data(identity, field, value, kind_name, level=1, pointer=0):
        set_field(obj("abilities", identity), field, value, kind_name, level, pointer)

    def replace_text(kind, identity, old, new):
        hits = 0
        for skin in (False, True):
            target = obj(kind, identity, skin)
            if target is None:
                continue
            for mod in target["modifications"]:
                if mod["type"] != "string":
                    continue
                value = objects.value_for_user(mod)
                value = raw.resolve_trigger_string(value, strings) or value
                if new in value:
                    hits += 1
                    continue
                for variant in (old if isinstance(old, tuple) else (old,)):
                    if variant in value:
                        mod["data"] = {"value": value.replace(variant, new)}
                        hits += 1
                        break
        if hits == 0:
            raise ValueError(f"{kind} {identity}: text not found: {old!r}")

    i = ids
    # Dark Repulser: own cooldown carrier and attack speed bonus.
    skin_text("abilities", i["DarkRepulserCD"], anam="CD Dark Repulser")
    data(i["DarkRepulserAS"], "Isx1", 0.50, "unreal", 1, 1)
    skin_text("abilities", i["DarkRepulserAS"], anam="Item Attack Speed +50%")
    item = obj("items", i["DarkRepulser"])
    set_field(item, "iabi", f"{i['DarkRepulserCD']},A00W,{i['DarkRepulserAS']}", leveled=False)
    set_field(item, "igol", 10000, "int", leveled=False)
    set_field(item, "icid", i["DarkRepulserCD"], leveled=False)
    skin_text("items", i["DarkRepulser"], unam="Dark Repulser", utip="Dark Repulser",
              utub=DARK_REPULSER, ides=DARK_REPULSER, iico=ICON.format("DarkRepulser"))

    # Kurikara / Ashisogi Jizo: the dummy casts rank 1 of the curse.
    for identity in ("A0DZ", "A110"):
        data(identity, "adur", 5.0, "unreal")
        data(identity, "ahdu", 5.0, "unreal")
    data("A13C", "acdn", 45.0, "unreal")
    for identity in ("A131", "A133", "A161"):
        data(identity, "aran", 1600.0, "unreal")
    for kind, identity, old, new in TEXTS:
        replace_text(kind, identity, old, new)

    # Instant buttons (Berserk / Battle Roar / Roar bases) only dispatch script: their stock caster/target
    # art and effect sound (heard e.g. on Item Incursio) must be overridden with empty values in the skin file.
    skin = by_file["war3mapSkin.w3a"]
    skin_index = {objects.object_id(o): o for o in skin["custom_objects"]}
    cleaned = 0
    for base_obj in by_file["war3map.w3a"]["custom_objects"]:
        if base_obj["old_id"]["text"] not in INSTANT_BASES:
            continue
        identity = objects.object_id(base_obj)
        target = skin_index.get(identity)
        if target is None:
            target = {"old_id": dict(base_obj["old_id"]), "new_id": dict(base_obj["new_id"]),
                      "v3_unknown": base_obj.get("v3_unknown", 0), "modifications": []}
            skin["custom_objects"].append(target)
            skin_index[identity] = target
        for field in INSTANT_PRESENTATION:
            set_field(target, field, "", "string", 0, 0)
        for field in ("acac", "atac"):
            set_field(target, field, 0, "int", 0, 0)
        for mod in target["modifications"]:
            if mod["field"]["text"] in INSTANT_PRESENTATION or mod["field"]["text"] in ("acac", "atac"):
                mod["sanity_check"] = {"text": "", "hex": "00000000"}
        cleaned += 1
    print("instant buttons cleaned:", cleaned)

    # Turn rate: every unit at 1.0 (all heroes and their forms) turns at 1.75; 3.0 units (dummies, Okarun) stay.
    turned = 0
    for unit in by_file["war3map.w3u"]["custom_objects"]:
        for mod in unit["modifications"]:
            if mod["field"]["text"] == "umvr" and abs(float(objects.value_for_user(mod)) - 1.0) < 1e-6:
                mod["data"] = {"value": TURN_RATE}
                turned += 1
    print("turn rate 1.0 ->", TURN_RATE, ":", turned)

    for document in documents:
        raw.encode_object_file(document, document["source_file"])
        raw.dump_json(ROOT / ".object-data-raw" / raw.OUTPUT_NAMES[document["source_file"]], document)
    for kind, (editable, metadata) in objects.views_from_raw(documents, ROOT / "libs/common.j").items():
        raw.dump_json(ROOT / "object-data" / objects.CATEGORY_FILES[kind], editable)
        raw.dump_json(ROOT / ".object-data-raw/workspace-meta" / objects.CATEGORY_FILES[kind], metadata)
    raw.dump_json(IDS_PATH, ids)
    print(json.dumps(ids, indent=1))


if __name__ == "__main__":
    stage()
