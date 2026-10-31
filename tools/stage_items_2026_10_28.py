"""Stage the 2026-10-28 item update in MAIN object data (idempotent).

New items: Ryujin Jakka / Nejibana / Gonryomaru Evolved, Mirror of Yata Evolved,
Philosopher's Stone Evolved; Five Elements Seal gets a second (dispellable) seal buff.
Changed: prices, stats and texts of the items listed in CHANGES below.
Allocated rawcodes are kept in object-data/items-2026-10-28-ids.json.
"""
from pathlib import Path
import json
import balance_active_items as active_balance
import re

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field, clone_object, allocate

ROOT = Path(__file__).resolve().parents[1]
IDS_PATH = ROOT / "object-data/items-2026-10-28-ids.json"
IDS_1027 = json.loads((ROOT / "object-data/items-2026-10-27-ids.json").read_text())
ICON = "ReplaceableTextures\\CommandButtons\\BTNItem_{}.blp"

NEW_OBJECTS = [
    ("RyujinEvo", "items", "I01Q"),
    ("NejibanaEvo", "items", "I01X"),
    ("GonryomaruEvo", "items", "I01Y"),
    ("YataEvo", "items", "I02H"),
    ("YataActive", "abilities", "A02T"),
    ("YataBuffAbi", "abilities", "A01E"), ("YataBuff", "buffs", "B001"),
    ("PhilEvo", "items", "I040"),
    ("PhilActive", "abilities", "A02T"),
    ("PhilBuffAbi", "abilities", "A01E"), ("PhilBuff", "buffs", "B001"),
    ("SealSilenceCurse", "abilities", "A110"), ("SealSilenceBuff", "buffs", "B041"),
]

ZANPAKUTO = {  # label: (title, element, icon, base CD carrier)
    "RyujinEvo": ("Ryujin Jakka Evolved", "Fire", "RyujinJakkaEvolved", "A080"),
    "NejibanaEvo": ("Nejibana Evolved", "Water", "NejibanaEvolved", "A09P"),
    "GonryomaruEvo": ("Gonryomaru Evolved", "Lightning", "GonryomaruEvolved", "A081"),
}


def zanpakuto_tip(element):
    return ("+20 allstats\nPassive: Every hit of 200 or more damage to an enemy applies the " + element + " debuff. "
            "Such a hit also causes an explosion at its position, dealing 2x main stat damage.\n"
            "Explosion cooldown: 5 sec.\n|cffff0000Does not work together with other items of this type.|r")


YATA_EVO = ("+20 str\n+1000 hp\n+500 mp\nPassive: Reflects 30% of damage taken from enemies (no range limit).\n"
            "Active: For 4 sec, reflects 75% of damage taken.\nCooldown: 35 sec.")
PHIL_EVO = ("+20 allstats\nPassive: Dealing damage to enemies restores HP equal to 18% of the damage dealt.\n"
            "Active: For 3 sec, restores an additional 18% of the damage dealt.\nCooldown: 25 sec.")
SEAL = ("+25 agi\n+15 int\nActive: Seals an enemy hero for 9 sec with two seals. The mana seal "
        "|cffff0000cannot be dispelled|r: mana regeneration and mana restoration -100%. If the second seal is removed "
        "or the hero casts an ability, it is silenced for 2 sec (once).\nCooldown: 30 sec.")


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
    used.update(IDS_1027.values())
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

    def item(identity, abilities=None, gold=None, cooldown=None, title=None, tip=None, icon=None):
        base = obj("items", identity)
        if abilities is not None:
            set_field(base, "iabi", abilities, leveled=False)
        if gold is not None:
            set_field(base, "igol", gold, "int", leveled=False)
        if cooldown is not None:
            set_field(base, "icid", cooldown, leveled=False)
        fields = {}
        if title is not None:
            fields.update(unam=title, utip=title)
        if tip is not None:
            fields.update(utub=tip, ides=tip)
        if icon is not None:
            fields.update(iico=ICON.format(icon))
        if fields:
            skin_text("items", identity, **fields)

    i = ids
    for label, (title, element, icon, carrier) in ZANPAKUTO.items():
        item(i[label], f"{carrier},A00W", 10000, carrier, title, zanpakuto_tip(element), icon)
    # Actives with a 3 sec self buff.
    for active, abil, buff, title, tip, icon, cooldown, mana, duration in (
            ("YataActive", "YataBuffAbi", "YataBuff", "Mirror of Yata", "Reflects 75% of damage taken.", "MirrorYataEvolved", 35.0, 100, 4.0),
            ("PhilActive", "PhilBuffAbi", "PhilBuff", "Philosopher's Stone", "Restores an additional 18% of damage dealt as HP.", "PhilosopherStoneEvolved", 25.0, 50, 3.0)):
        data(i[active], "acdn", cooldown, "unreal")
        data(i[active], "amcs", mana, "int")
        data(i[active], "aran", 0.0, "unreal")
        skin_text("abilities", i[active], anam="Item " + title + " Evolved")
        data(i[abil], "abuf", i[buff], "string")
        data(i[abil], "adur", duration, "unreal")
        data(i[abil], "ahdu", duration, "unreal")
        data(i[abil], "Inf1", 0.0, "unreal", 1, 1)
        data(i[abil], "Inf2", 0, "int", 1, 2)
        data(i[abil], "Inf3", 0.0, "unreal", 1, 3)
        skin_text("abilities", i[abil], anam=title + " Evolved (buff)", aart=ICON.format(icon))
        skin_text("buffs", i[buff], ftip=title, fube=tip, fart=ICON.format(icon), ftat="")
    item(i["YataEvo"], f"{i['YataActive']},A04W,A04S,A0G8", 12000, i["YataActive"], "Mirror of Yata Evolved",
         YATA_EVO, "MirrorYataEvolved")
    # No A0HV: a second Channel with the same order id blocked the active (lifesteal checks the item).
    item(i["PhilEvo"], f"{i['PhilActive']},A00W", 10000, i["PhilActive"], "Philosopher's Stone Evolved",
         PHIL_EVO, "PhilosopherStoneEvolved")
    for label in ("YataEvo", "PhilEvo"):
        set_field(obj("items", i[label]), "iusa", 1, "int", leveled=False)
    # Five Elements Seal: second, dispellable seal (silence trigger).
    seal_curse = obj("abilities", i["SealSilenceCurse"])
    seal_curse["modifications"] = [m for m in seal_curse["modifications"] if m.get("level", 0) <= 1]
    set_field(seal_curse, "alev", 1, "int", 0)
    data(i["SealSilenceCurse"], "abuf", i["SealSilenceBuff"], "string")
    data(i["SealSilenceCurse"], "adur", 9.0, "unreal")
    data(i["SealSilenceCurse"], "ahdu", 9.0, "unreal")
    skin_text("abilities", i["SealSilenceCurse"], anam="Five Elements Seal: Silence (debuff)", aart=ICON.format("FiveElementsSeal"))
    skin_text("buffs", i["SealSilenceBuff"], ftip="Five Elements Seal: Lock",
              fube="Removing this seal or casting an ability silences for 2 sec.", fart=ICON.format("FiveElementsSeal"))
    skin_text("buffs", IDS_1027["SealBuff"], ftip="Five Elements Seal: Mana",
              fube="Mana regeneration and restoration -100%. Cannot be dispelled.")
    data(IDS_1027["SealActive"], "acdn", 30.0, "unreal")
    item(IDS_1027["Seal"], tip=SEAL)

    active_balance.configure(documents)
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
