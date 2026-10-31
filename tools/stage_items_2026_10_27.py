"""Stage the 2026-10-27 item update in MAIN object data (idempotent).

New items: Armament Haki (+ Evolved), Naofumi Shield Evolved, Sukuna's Finger,
Five Elements Seal, Rokushiki: Tekkai, Samehada, Will of D., Kairoseki Cuffs,
Hyorinmaru Ice Coffin, Return by Death, Fairy Tail Emblem Evolved.
Changed: Chogurt Evolved gains a 1500 range mana regeneration aura.

Only object JSON/raw/metadata are staged; the regular check/save writes the map.
Allocated rawcodes are kept in object-data/items-2026-10-27-ids.json.
"""
from pathlib import Path
import json
import balance_active_items as active_balance
import re

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field, clone_object, allocate

ROOT = Path(__file__).resolve().parents[1]
IDS_PATH = ROOT / "object-data/items-2026-10-27-ids.json"
ICON = "ReplaceableTextures\\CommandButtons\\BTNItem_{}.blp"
ENEMY_HERO = "air,enemies,ground,hero,vulnerable"

# label -> (kind, template)
NEW_OBJECTS = [
    ("HakiCD", "abilities", "A0HV"),
    ("HakiEvoCD", "abilities", "A0HV"),
    ("HakiEvoBuffAbi", "abilities", "A01E"), ("HakiEvoBuff", "buffs", "B001"),
    ("SukunaActive", "abilities", "A0CX"),
    ("SukunaCurse", "abilities", "A110"), ("SukunaBuff", "buffs", "B041"),
    ("SealActive", "abilities", "A0CX"),
    ("SealCurse", "abilities", "A110"), ("SealBuff", "buffs", "B041"),
    ("TekkaiActive", "abilities", "A02T"),
    ("TekkaiBuffAbi", "abilities", "A01E"), ("TekkaiBuff", "buffs", "B001"),
    ("SamehadaAtk", "abilities", "A0HU"),
    ("WillCD", "abilities", "A0HV"),
    ("WillBuffAbi", "abilities", "A01E"), ("WillBuff", "buffs", "B001"),
    ("KairosekiActive", "abilities", "A0CX"),
    ("KairosekiCurse", "abilities", "A110"), ("KairosekiBuff", "buffs", "B041"),
    ("CoffinActive", "abilities", "A02T"),
    ("CoffinBuffAbi", "abilities", "A01E"), ("CoffinBuff", "buffs", "B001"),
    ("RecallActive", "abilities", "A02T"),
    ("ChogurtAura", "abilities", "A09X"), ("ChogurtAuraBuff", "buffs", "B013"),
    ("Haki", "items", "I03Y"),
    ("HakiEvo", "items", "I03Y"),
    ("NaofumiEvo", "items", "I02L"),
    ("Sukuna", "items", "I02L"),
    ("Seal", "items", "I02L"),
    ("Tekkai", "items", "I02L"),
    ("Samehada", "items", "I03Y"),
    ("Will", "items", "I03Y"),
    ("Kairoseki", "items", "I02L"),
    ("Coffin", "items", "I02L"),
    ("Recall", "items", "I02L"),
    ("FairyEvo", "items", "I03Y"),
]

TIPS = {
    "Haki": ("+10 allstats\nPassive: Blocks the next debuff or crowd control applied to you.\nCooldown: 15 sec."),
    "HakiEvo": ("+20 allstats\nPassive: Blocks the next debuff or crowd control applied to you and grants debuff "
                "immunity for 3 sec.\nCooldown: 15 sec."),
    "NaofumiEvo": ("+20 allstats\nPassive: Blocks 40 damage from every hit.\nActive: Removes all debuffs and reduces "
                   "damage taken by 10% while active; the flat block rises to 100. The duration is extended while the "
                   "hero is paused.\nDuration: 5 sec.\nCooldown: 24 sec."),
    "Sukuna": ("+35 int\n+10 agi\n+500 hp\nActive: Curses an enemy hero for 9 sec: it cannot restore HP (healing and "
               "HP regeneration -100%) and is slowed by 15%. |cffff0000Cannot be dispelled|r; reapplied if removed.\n"
               "Cooldown: 30 sec."),
    "Seal": ("+25 agi\n+15 int\nActive: Seals an enemy hero for 9 sec: its mana regeneration and mana restoration are "
             "reduced by 100%. If the seal is removed early or the hero casts an ability while sealed, it is "
             "silenced for 2 sec.\nCooldown: 25 sec."),
    "Tekkai": ("+15 allstats\n+30 hp regen\nActive: Hardens the body: blocks basic attack damage and all on-hit effects for 4 sec.\n"
               "Cooldown: 25 sec."),
    "Samehada": ("+45 atk\n+10 allstats\nPassive: Each attack restores 4% of your max MP and drains 4% of the target's "
                 "max MP. Does not work with or against clones. Starrk: triggers on the attack that fires Cero, not on Cero hits."),
    "Will": '+10 str\n+25 agi\n+500 hp\nPassive: Lethal damage leaves you at 1 HP and prevents damage from lowering HP below 1 for 3 sec. Dispellable: removing the buff (including Kairoseki Cuffs) ends protection.\nCooldown: 180 sec; resets at the end of each round.',
    "Kairoseki": ("+15 allstats\nActive: Removes all positive buffs from an enemy hero and reduces the damage it deals "
                  "by 18% for 4 sec.\nCooldown: 20 sec."),
    "Coffin": ("+15 allstats\nActive: Seals the hero in ice for 2 sec: paused and invulnerable.\nCooldown: 45 sec."),
    "Recall": ("+15 allstats\nActive: Applies a dispellable buff and remembers your position. After 4 sec you return only if the buff remains. Removing the buff cancels the return.\nCooldown: 25 sec."),
    "FairyEvo": ("+20 allstats\n+200 mp\nPassive: +15% mana regeneration and mana restoration.\nCasting an ability with a "
                 "cooldown of at least 3 sec while at 95% mana or less restores 250 + 18% of max MP and 350 + 4% of max "
                 "HP.\nFairy Tail heroes (Natsu, Erza, Laxus): +1% HP restoration.\nCooldown: 18 sec."),
}
TITLES = {"Haki": "Armament Haki", "HakiEvo": "Armament Haki Evolved", "NaofumiEvo": "Naofumi Shield Evolved",
          "Sukuna": "Sukuna's Finger", "Seal": "Five Elements Seal", "Tekkai": "Rokushiki: Tekkai",
          "Samehada": "Samehada", "Will": "Will of D.", "Kairoseki": "Kairoseki Cuffs",
          "Coffin": "Hyorinmaru Ice Coffin", "Recall": "Return by Death", "FairyEvo": "Fairy Tail Emblem Evolved"}
ICONS = {"Haki": "ArmamentHaki", "HakiEvo": "ArmamentHakiEvolved", "NaofumiEvo": "NaofumiShieldEvolved",
         "Sukuna": "SukunaFinger", "Seal": "FiveElementsSeal", "Tekkai": "Tekkai", "Samehada": "Samehada",
         "Will": "WillOfD", "Kairoseki": "Kairoseki", "Coffin": "IceCoffin", "Recall": "ReturnByDeath",
         "FairyEvo": "FairyTailEvolved"}
GOLD = {"Haki": 3500, "HakiEvo": 9000, "NaofumiEvo": 10000, "Sukuna": 8000, "Seal": 7500, "Tekkai": 5500,
        "Samehada": 5500, "Will": 7500, "Kairoseki": 5500, "Coffin": 12500, "Recall": 4500, "FairyEvo": 10000}


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
    # TEST heroes (e.g. Altair) are moved to MAIN later: never reuse their rawcodes.
    for path in (ROOT / "test_map").rglob("*"):
        if path.suffix in (".json", ".j") and path.is_file():
            text = path.read_text(encoding="utf-8", errors="replace")
            used.update(re.findall(r"'([ABI][0-9A-Z]{3})'", text))
            used.update(re.findall(r'"([ABI][0-9A-Z]{3})"\s*:', text))
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

    i = ids
    # Item actives / cooldown carriers.
    for label, cooldown, mana, cast_range, targets in (
            ("SukunaActive", 30.0, 75, 900.0, ENEMY_HERO), ("SealActive", 25.0, 75, 900.0, ENEMY_HERO),
            ("KairosekiActive", 20.0, 75, 900.0, ENEMY_HERO), ("TekkaiActive", 25.0, 50, 0.0, None),
            ("CoffinActive", 45.0, 0, 0.0, None), ("RecallActive", 25.0, 50, 0.0, None),
            ("HakiCD", 15.0, 0, 0.0, None), ("HakiEvoCD", 15.0, 0, 0.0, None), ("WillCD", 180.0, 0, 0.0, None)):
        data(i[label], "acdn", cooldown, "unreal")
        data(i[label], "amcs", mana, "int")
        data(i[label], "aran", cast_range, "unreal")
        if targets:
            data(i[label], "atar", targets, "string")
    for label, title in (("SukunaActive", "Sukuna's Finger"), ("SealActive", "Five Elements Seal"),
                         ("KairosekiActive", "Kairoseki Cuffs"), ("TekkaiActive", "Rokushiki: Tekkai"),
                         ("CoffinActive", "Hyorinmaru Ice Coffin"), ("RecallActive", "Return by Death"),
                         ("HakiCD", "CD Armament Haki"), ("HakiEvoCD", "CD Armament Haki Evolved"),
                         ("WillCD", "CD Will of D.")):
        skin_text("abilities", i[label], anam="Item " + title)
    for level in range(1, 6):
        data(i["SamehadaAtk"], "Iatt", 45, "int", level, 1)
    skin_text("abilities", i["SamehadaAtk"], anam="Item Atk Samehada +45")

    # Enemy debuffs: curse copies (no miss), shown buff, durations of the item effect.
    for curse, buff, title, tip, icon, duration in (
            ("SukunaCurse", "SukunaBuff", "Sukuna's Curse", "Cannot restore HP (healing and HP regeneration -100%); slowed by 15%.", "SukunaFinger", 9.0),
            ("SealCurse", "SealBuff", "Five Elements Seal", "Mana regeneration and restoration -100%. Removing the seal or casting an ability silences for 2 sec.", "FiveElementsSeal", 9.0),
            ("KairosekiCurse", "KairosekiBuff", "Kairoseki", "Deals 18% less damage.", "Kairoseki", 4.0)):
        ability = obj("abilities", i[curse])  # one level: the Ashisogi copy carries 9 unused ranks
        ability["modifications"] = [m for m in ability["modifications"] if m.get("level", 0) <= 1]
        data(i[curse], "abuf", i[buff], "string")
        data(i[curse], "adur", duration, "unreal")
        data(i[curse], "ahdu", duration, "unreal")
        set_field(obj("abilities", i[curse]), "alev", 1, "int", 0)
        skin_text("abilities", i[curse], anam=title + " (debuff)", aart=ICON.format(icon))
        skin_text("buffs", i[buff], ftip=title, fube=tip, fart=ICON.format(icon))
    # Own positive buffs: Inner Fire copies without bonuses.
    for abil, buff, title, tip, icon, duration in (
            ("HakiEvoBuffAbi", "HakiEvoBuff", "Armament Haki", "Immune to debuffs.", "ArmamentHakiEvolved", 3.0),
            ("TekkaiBuffAbi", "TekkaiBuff", "Tekkai", "Blocks basic attack damage and all on-hit effects.", "Tekkai", 4.0),
            ("WillBuffAbi", "WillBuff", "Will of D.", "HP cannot drop below 1. Dispelling this buff ends protection.", "WillOfD", 3.0),
            ("CoffinBuffAbi", "CoffinBuff", "Ice Coffin", "Sealed in ice: paused and invulnerable.", "IceCoffin", 2.0)):
        data(i[abil], "abuf", i[buff], "string")
        data(i[abil], "adur", duration, "unreal")
        data(i[abil], "ahdu", duration, "unreal")
        data(i[abil], "Inf1", 0.0, "unreal", 1, 1)
        data(i[abil], "Inf2", 0, "int", 1, 2)
        data(i[abil], "Inf3", 0.0, "unreal", 1, 3)
        skin_text("abilities", i[abil], anam=title + " (buff)", aart=ICON.format(icon))
        skin_text("buffs", i[buff], ftip=title, fube=tip, fart=ICON.format(icon), ftat="")
    # Chogurt Evolved: mana regeneration aura read by code (no native bonus).
    data(i["ChogurtAura"], "Uau1", 0.0, "unreal", 1, 1)
    data(i["ChogurtAura"], "Uau2", 0.0, "unreal", 1, 2)
    data(i["ChogurtAura"], "aare", 1500.0, "unreal")
    data(i["ChogurtAura"], "abuf", i["ChogurtAuraBuff"], "string")
    skin_text("abilities", i["ChogurtAura"], anam="Chogurt Evolved Aura", aart=ICON.format("Chogurt_Evolved"))
    skin_text("buffs", i["ChogurtAuraBuff"], ftip="Chogurt", fube="+8 mana regeneration.", fart=ICON.format("Chogurt_Evolved"))
    chogurt = obj("items", "I03U")
    chogurt_abilities = "A06R,A07Y," + i["ChogurtAura"]
    set_field(chogurt, "iabi", chogurt_abilities, leveled=False)

    abilities = {
        "Haki": f"{i['HakiCD']},A00X", "HakiEvo": f"{i['HakiEvoCD']},A00W", "NaofumiEvo": "A02T,A00W",
        "Sukuna": f"{i['SukunaActive']},A00U,A074,A01Y", "Seal": f"{i['SealActive']},A00R,A071",
        "Tekkai": f"{i['TekkaiActive']},A00M", "Samehada": f"{i['SamehadaAtk']},A00X",
        "Will": f"{i['WillCD']},A072,A00R,A01Y", "Kairoseki": f"{i['KairosekiActive']},A00M",
        "Coffin": f"{i['CoffinActive']},A00M", "Recall": f"{i['RecallActive']},A00M", "FairyEvo": "A04Y,A0D2,A00W",
    }
    cooldown_groups = {"Haki": i["HakiCD"], "HakiEvo": i["HakiEvoCD"], "NaofumiEvo": "A02T", "Sukuna": i["SukunaActive"],
                       "Seal": i["SealActive"], "Tekkai": i["TekkaiActive"], "Samehada": "A03T", "Will": i["WillCD"],
                       "Kairoseki": i["KairosekiActive"], "Coffin": i["CoffinActive"], "Recall": i["RecallActive"],
                       "FairyEvo": "A04Y"}
    for label in TITLES:
        base = obj("items", i[label])
        set_field(base, "iabi", abilities[label], leveled=False)
        set_field(base, "igol", GOLD[label], "int", leveled=False)
        set_field(base, "icid", cooldown_groups[label], leveled=False)
        skin_text("items", i[label], unam=TITLES[label], utip=TITLES[label], utub=TIPS[label], ides=TIPS[label],
                  iico=ICON.format(ICONS[label]))

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
