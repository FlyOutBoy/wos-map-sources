"""Stage the 2026-10-28b update in MAIN object data (idempotent).

Inori (H017 / T2 skin H018): Alucard's ranged attack (missile 725, 1800 homing bullets,
acquisition 700). The crystal shots of E / T2 are drawn by script (InoriShot in Inori.j).

Elemental actives: every stat gets Fire / Water / Lightning as a single-target and an AOE item
(13 new + Rhitta, Shark Trail, Raijin's Wrath, Red Cup, Red Flower). Target and AOE of one
stat + element no longer share a cooldown (each item has its own). Logic: triggers/Items/ItemsElements.j.
Blood Pact Ring (STR): pay 400 HP for 400 mana.
Allocated rawcodes are kept in object-data/items-2026-10-28b-ids.json.
"""
from pathlib import Path
import json
import balance_active_items as active_balance
import re

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field, clone_object, allocate

ROOT = Path(__file__).resolve().parents[1]
IDS_PATH = ROOT / "object-data/items-2026-10-28b-ids.json"
OLDER_IDS = ("items-2026-10-27-ids.json", "items-2026-10-28-ids.json")
BULLET = "war3mapimported\\wos_alucard bullet.mdl"
STOCK = "ReplaceableTextures\\CommandButtons\\{}.blp"
STAT_ITEM = {"str": "I02L", "agi": "I016", "int": "I01U"}
STAT_ABIL = {"str": "A072", "agi": "A074", "int": "A075"}
STAT_WORD = {"str": "Strength", "agi": "Agility", "int": "Intelligence"}
TARGET_ABIL, AOE_ABIL = "A06P", "A0F5"

# label, stat, kind, name, icon, aoe, active text (every item has its own cooldown)
ELEMENTAL = [
    ("Ember", "str", "T", "Emberbreaker", "BTNItem_Emberbreaker", 0,
     "Hurls a blazing fist at an enemy. On impact it deals 4x Strength physical damage, applies the Fire debuff, "
     "knocks the target back a little and burns it for 1.25x Strength over 2 sec. For 3 sec the first time the target "
     "damages you it takes 0.75x Strength magic damage back."),
    ("Grasp", "str", "T", "Leviathan's Grasp", "BTNItem_LeviathanGrasp", 0,
     "Throws a tide claw at an enemy: 3.75x Strength physical damage and the Water debuff on impact, then the claw drags "
     "the target 250 towards you over 0.5 sec and squeezes it for 2.25x Strength. Restores HP equal to 15% of the "
     "damage dealt (up to 1.2x Strength)."),
    ("Anchor", "str", "A", "Leviathan's Anchor", "BTNItem_LeviathanAnchor", 500,
     "A giant water anchor falls on the target area after 0.6 sec and opens a whirlpool (500 range) for 1.5 sec that "
     "slowly drags enemies to its centre. The whirlpool deals 5.75x Strength physical damage in 3 waves, applies the "
     "Water debuff and slows by 15%."),
    ("Verdict", "str", "T", "Thunder Verdict", "BTNItem_ThunderVerdict", 0,
     "Calls three lightning strikes on an enemy over 0.7 sec, 5.5x Strength magic damage in total, applying the "
     "Lightning debuff. If the target moves more than 500 away from the first strike within 3 sec, it takes 0.5x "
     "Strength magic damage and is slowed by 25% for 1 sec."),
    ("Bastion", "str", "A", "Thunder Bastion", "BTNItem_ThunderBastion", 475,
     "Raises a thunderstorm (475 range) for 2 sec: 4 pulses, 5.25x Strength magic damage in total, Lightning debuff. "
     "Each enemy hero caught gives a Static Counter charge for 4 sec (up to 3): an enemy that damages you spends one, "
     "taking 0.25x Strength magic damage and a 20% slow for 1 sec (once per 0.8 sec)."),
    ("Cinder", "agi", "T", "Cinder Fang", "BTNItem_CinderFang", 0,
     "Launches a phoenix projectile: 5x Agility physical damage and the Fire debuff on impact, then it ricochets to the "
     "nearest other enemy within 500 for 2.5x Agility. Your next attack on the first target within 3 sec deals 1x "
     "Agility bonus physical damage."),
    ("Ashen", "agi", "A", "Ashen Crossfire", "BTNItem_AshenCrossfire", 400,
     "Throws three fire shuriken towards the target point. Going out they deal 5.5x Agility physical damage and the "
     "Fire debuff to enemies they cross; on the way back 3.8x Agility to enemies the first sweep missed."),
    ("Mirror", "agi", "A", "Mirror Tide", "BTNItem_MirrorTide", 600,
     "Sends a tidal wave towards the target point: enemies it crosses take 5.5x Agility physical damage, the Water "
     "debuff and are pushed back 150. The wave leaves a water mirror (600 range) for 3 sec: your next attack on an "
     "enemy inside reflects 0.5x Agility physical damage to the nearest other enemy inside."),
    ("Volt", "agi", "T", "Volt Thread", "BTNItem_VoltThread", 0,
     "Fires a lightning needle: 5.5x Agility magic damage and Lightning. For 3 sec, other enemies within 300 of the thread "
     "between you and the target take 0.9x Agility magic damage every second. Your attacks on the target add Static "
     "Needle charges (once per 0.4 sec); at 3 charges it takes 0.5x Agility magic damage and a 20% slow for 1 sec."),
    ("Phoenix", "int", "T", "Phoenix Seal", "BTNItem_PhoenixSeal", 0,
     "Releases a homing fire projectile: 3.75x Intelligence magic damage and the Fire debuff on impact, then the seal burns "
     "the target for 1.75x Intelligence over 2 sec. If it casts an ability within 3 sec, the seal explodes for 0.5x "
     "Intelligence magic damage."),
    ("Scripture", "int", "A", "Crimson Scripture", "BTNItem_CrimsonScripture", 450,
     "Draws a burning rune circle (450 range) that erupts after 0.8 sec for 4x Intelligence magic damage and the Fire "
     "debuff (enemies already burning take 0.5x Intelligence more), then the ground burns for 1.5x Intelligence over "
     "1.5 sec."),
    ("Siren", "int", "T", "Siren's Tear", "BTNItem_SirenTear", 0,
     "Launches a water orb: 6x Intelligence magic damage and the Water debuff on impact, then drains mana for 2 sec "
     "(up to 2.5x Intelligence or 8% of the target's max mana). You restore 60% of the drained mana."),
    ("Coil", "int", "A", "Constellation Coil", "BTNItem_ConstellationCoil", 200,
     "Fires a lightning projectile in a straight line up to 1800 range. Each enemy within 200 of its path is hit "
     "once for 5.5x Intelligence magic damage, receives Lightning and a 25% slow for 2 sec."),
]
# Universal Bleach zanpakuto for the element debuffs (logic: AAADest ErzaPassive / Systems1 steam).
ZANPAKUTO_UNIVERSAL = [
    ("Zanka", "Zanka no Tachi", "ZankaNoTachi",
     "Passive: Your Fire burns for 7 sec at 70 damage per second. Re-applying it adds +40 per second "
     "(up to 240) and restarts the 7 sec."),
    ("Kyoka", "Kyoka Suigetsu", "KyokaSuigetsu",
     "Passive: Your Fire or Water turns into Steam (3 sec per target; with Sogyo no Kotowari only Fire). Fire or Water "
     "on Steam refreshes it and deals 0.6x main stat damage. Steam: +24% physical damage from you in total (12% normally)."),
    ("Koko", "Koko Gonryo Rikyu", "KokoGonryoRikyu",
     "Passive: Your Lightning debuff also deals 0.5x main stat magic damage every second while it lasts."),
    ("Tobiume", "Tobiume", "Tobiume",
     "Passive: Your Overload (Fire + Lightning) deals 175% more damage and stuns 0.4 sec longer."),
    ("Suzume", "Suzumebachi", "Suzumebachi",
     "Passive: Your Electrized (Water + Lightning) deals 125% more damage every second."),
]
PACT_TIP = ("+15 str\n+250 hp\nActive: Sacrifices 400 HP (cannot kill you) to restore 400 mana.\nCooldown: 12 sec.")


def main_map():
    config = json.loads((ROOT / ".vscode/wos-build.json").read_text(encoding="utf-8"))
    return Path(config["mainMap"])


def stage():
    documents, _ = objects.prepare_documents(ROOT / "object-data", ROOT / ".object-data-raw")
    by_file = {d["source_file"]: d for d in documents}
    files = {"abilities": ("war3map.w3a", "war3mapSkin.w3a"), "items": ("war3map.w3t", "war3mapSkin.w3t"),
             "buffs": ("war3map.w3h", "war3mapSkin.w3h")}

    def index(name):
        return {objects.object_id(o): o for o in by_file[name]["custom_objects"]}

    # First run allocated A11E-A12B, the Altair TEST hero's rawcodes: drop those clones.
    ids = json.loads(IDS_PATH.read_text()) if IDS_PATH.exists() else {}
    stale = {v for k, v in ids.items() if k.endswith("Active") and "A11E" <= v <= "A12B"}
    for document in documents:
        document["custom_objects"] = [o for o in document["custom_objects"] if objects.object_id(o) not in stale]
    ids = {k: v for k, v in ids.items() if v not in stale}

    # ---- Inori: Alucard's ranged attack
    for unit in ("H017", "H018"):
        base = index("war3map.w3u")[unit]
        set_field(base, "ua1w", "missile", "string", leveled=False)
        set_field(base, "ua1r", 725, "int", leveled=False)
        set_field(base, "ua2r", 575, "int", leveled=False)
        set_field(base, "ua1z", 1800, "int", leveled=False)
        set_field(base, "umh1", 1, "int", leveled=False)
        set_field(base, "ucs1", "", "string", leveled=False)
        set_field(base, "uacq", 700.0, "unreal", leveled=False)
        skin = index("war3mapSkin.w3u")[unit]
        set_field(skin, "ua1m", BULLET, "string", leveled=False)
        set_field(skin, "uimz", 90.0, "unreal", leveled=False)  # launch height (Alucard 150 looked ~60 too high)

    # ---- rawcodes
    used = {objects.object_id(o) for d in documents for g in ("original_objects", "custom_objects") for o in d[g]}
    for path in (ROOT / "triggers").rglob("*.j"):
        used.update(re.findall(r"'([^'\r\n]{4})'", path.read_text(encoding="utf-8-sig", errors="replace")))
    for path in (ROOT / "test_map").rglob("*"):
        if path.suffix in (".json", ".j") and path.is_file():
            text = path.read_text(encoding="utf-8", errors="replace")
            used.update(re.findall(r"'([ABI][0-9A-Z]{3})'", text))
            used.update(re.findall(r'"([ABI][0-9A-Z]{3})"\s*:', text))
    used.update({"A1%02X" % n for n in range(0x1E, 0x2C)} | {"A11E", "A11F"})
    for name in OLDER_IDS:
        used.update(json.loads((ROOT / "object-data" / name).read_text()).values())
    used.update(ids.values())
    wanted = [(label + "Item", "I") for label, *_ in ELEMENTAL] + [(label + "Active", "A") for label, *_ in ELEMENTAL]
    wanted += [("InoriT2Aura", "A"), ("InoriT2AuraBuff", "B")]
    wanted += [("PactItem", "I"), ("PactActive", "A")] + [(label + "Item", "I") for label, *_ in ZANPAKUTO_UNIVERSAL]
    for label, prefix in wanted:
        if label not in ids:
            ids[label] = allocate(prefix, used)
    strings = raw.parse_wts(main_map() / "war3map.wts")

    def clone(kind, identity, template):
        for name in files[kind]:
            existing = index(name)
            if identity not in existing and template in existing:
                by_file[name]["custom_objects"].append(clone_object(existing[template], identity, {}, strings))

    def obj(kind, identity, skin=False):
        return index(files[kind][1 if skin else 0]).get(identity)

    def skin_text(kind, identity, **fields):
        target = obj(kind, identity, skin=True) or obj(kind, identity)
        for field, value in fields.items():
            if kind in ("items", "buffs"):
                set_field(target, field, value, leveled=False)
            else:
                set_field(target, field, value, level=1 if field in ("atp1", "aub1") else 0)

    def data(identity, field, value, kind_name, level=1, pointer=0):
        set_field(obj("abilities", identity), field, value, kind_name, level, pointer)

    def item(identity, abilities, gold, group, title, tip, icon, active=1):
        base = obj("items", identity)
        set_field(base, "iabi", abilities, leveled=False)
        set_field(base, "igol", gold, "int", leveled=False)
        set_field(base, "icid", group, leveled=False)
        set_field(base, "iusa", active, "int", leveled=False)
        skin_text("items", identity, unam=title, utip=title, utub=tip, ides=tip, iico=STOCK.format(icon))

    for label, stat, kind, title, icon, aoe, text in ELEMENTAL:
        active, item_id = ids[label + "Active"], ids[label + "Item"]
        clone("abilities", active, TARGET_ABIL if kind == "T" else AOE_ABIL)
        clone("items", item_id, STAT_ITEM[stat])
        data(active, "acdn", 20.0, "unreal")
        data(active, "amcs", active_balance.MANA_COSTS[active], "int")
        data(active, "aran", 1600.0 if label == "Mirror" else (1800.0 if label == "Coil" else 1400.0), "unreal")
        if kind == "A":
            data(active, "aare", float(aoe), "unreal")
        skin_text("abilities", active, anam="Item " + title, aart=STOCK.format(icon))
        group = active
        tip = f"+10 {stat}\n+15 allstats\nActive: {text}\nCooldown: 20 sec.\nShared CD: {active_balance.ELEMENT_ITEMS[item_id]} items."
        item(item_id, f"{active},{STAT_ABIL[stat]},A00M", 7500, group, title, tip, icon)

    # Inori T2: an enemy aura (clone of her E aura) whose debuff lowers physical and magic resistance by 10%.
    aura, aura_buff = ids["InoriT2Aura"], ids["InoriT2AuraBuff"]
    clone("abilities", aura, "A061")
    clone("buffs", aura_buff, "B00I")
    aura_obj = obj("abilities", aura)
    aura_obj["modifications"] = [m for m in aura_obj["modifications"] if m.get("level", 0) <= 1]
    set_field(aura_obj, "alev", 1, "int", 0)
    data(aura, "Had1", 0.0, "unreal")
    data(aura, "aare", 1400.0, "unreal")
    data(aura, "abuf", aura_buff, "string")
    data(aura, "atar", "air,enemies,ground,hero,invulnerable,vulnerable", "string")
    set_field(aura_obj, "aite", 1, "int", 0)
    skin_text("abilities", aura, anam="Inori T2 Aura (enemies)")
    skin_text("buffs", aura_buff, ftip="Mana Ascension", fube="Inori in T2 nearby: -10% physical resistance and -10% magic resistance.",
              fart="ReplaceableTextures\\CommandButtons\\BTNHero_Inori_T2.blp")

    clone("abilities", ids["PactActive"], "A135")
    clone("items", ids["PactItem"], "I02L")
    data(ids["PactActive"], "acdn", 12.0, "unreal")
    data(ids["PactActive"], "amcs", 0, "int")
    skin_text("abilities", ids["PactActive"], anam="Item Blood Pact Ring", aart=STOCK.format("BTNRingSkull"))
    item(ids["PactItem"], f"{ids['PactActive']},A06T,A020", 2800, ids["PactActive"], "Blood Pact Ring", PACT_TIP,
         "BTNRingSkull")

    for label, title, icon, text in ZANPAKUTO_UNIVERSAL:
        clone("items", ids[label + "Item"], "I01P")
        item(ids[label + "Item"], "A00M", 6000 if label == "Suzume" else 5500, ids[label + "Item"], title, "+15 allstats\n" + text, "BTNItem_" + icon, 0)

    active_balance.configure(documents)
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
