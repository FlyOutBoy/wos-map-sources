"""Stage the 2026-10-18 item update in MAIN object data (idempotent).

New: Kusanagi (+3 elemental grades), Hashirama Cells, Shun Shun Rikka,
Ashisogi Jizo, Rhitta strength stacks, Frozen Heart ally aura.
Changed: Rhitta, Frozen Heart, Philosopher's Stone, Hokage Hat Evolved,
Hell Blaze, Murasame tooltips/stats.

Only object JSON/raw/metadata are staged; the regular check/save writes the map.
Allocated rawcodes are kept in object-data/items-2026-10-18-ids.json.
"""
from pathlib import Path
import json
import re
import copy

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field, clone_object, allocate

ROOT = Path(__file__).resolve().parents[1]
IDS_PATH = ROOT / "object-data/items-2026-10-18-ids.json"
ICON = "ReplaceableTextures\\CommandButtons\\BTNItem_{}.blp"

# label -> (kind, template)
NEW_OBJECTS = [
    ("KusanagiAtk", "abilities", "A0HU"),
    ("KusanagiGradeAtk", "abilities", "A0HU"),
    ("KusanagiActive", "abilities", "A02T"),
    *[(f"RhittaStr{n}", "abilities", "A00A") for n in range(1, 8)],
    ("HashiramaStr", "abilities", "A06T"),
    ("HashiramaActive", "abilities", "A02T"),
    ("ShunBuff", "buffs", "B013"),
    ("ShunAura", "abilities", "A09X"),
    ("FrozenBuff", "buffs", "B013"),
    ("FrozenAura", "abilities", "A09X"),
    ("AshisogiBuff", "buffs", "B03C"),
    ("AshisogiCurse", "abilities", "A0I3"),
    ("LaxusGAttackSpeed15", "abilities", "A0I2"),
    ("LaxusGAttackSpeed30", "abilities", "A0I2"),
    ("RimuruG3Copy2R", "abilities", "A0A6"),
    ("KyorakuTakaoni", "abilities", "A052"),
    ("Kusanagi", "items", "I02L"),
    ("KusanagiFire", "items", "I02L"),
    ("KusanagiWater", "items", "I02L"),
    ("KusanagiElectro", "items", "I02L"),
    ("HashiramaCells", "items", "I02L"),
    ("ShunShunRikka", "items", "I03Y"),
    ("AshisogiJizo", "items", "I03Y"),
]

KUS_BASE = ('+40 atk\n+15 allstats\nActive: Target an area: dashes once to every enemy within 700 range of the target point, striking each one with an attack that deals 2x ATK, then returns to the cast point. Does not grant invulnerability.\nShares its cooldown with every Kusanagi.\nCooldown: 20 sec.')


def kus_grade(element):
    return ("+60 atk\n+20 allstats\nActive: Target an area: dashes once to every enemy within 700 range of the target "
            f"point, striking each one with an attack that deals 3x ATK and applies the {element} debuff, then returns "
            "to the cast point. Does not grant invulnerability.\nOnly one elemental Kusanagi can be carried. "
            "Shares its cooldown with every Kusanagi.\nCooldown: 20 sec.")


HASHIRAMA = ("+15 str\n+10 allstats\n+10 hp regen\nPassive: Whenever you take damage from an enemy, allied heroes within 700 range "
             "restore HP equal to 15% of the damage taken.\nActive: Sacrifices 10% of current HP to gain +15 Strength "
             "for 10 sec.\nCooldown: 15 sec.")
SHUN = ('+15 allstats\n+500 hp\nAura: Allies within 1200 range receive 18% more HP regeneration and healing; stuns, silences and roots on them last 0.5 sec shorter.')
ASHISOGI = ('+10 agi\n+10 allstats\nPassive: Dealing 100 or more physical damage with abilities (not basic attacks) poisons the enemy, dealing 0.4x Agility physical damage every second for 5 sec. Works on every target; a new hit refreshes the poison but does not stack it.')
RHITTA = ("+10 str\n+10 allstats\nActive: Strikes the target point with a divine axe, dealing 5.5x Strength physical "
          "damage and applying the Fire debuff. Each enemy hit grants +5 Strength for 10 sec (up to +35).\n"
          "Cooldown: 20 sec.")
FROZEN = ("+10 str\n+10 allstats\nPassive: Each decoration you destroy restores 100 HP and 25 MP (up to 15 stacks). "
          "After 15 uses, the item goes on a 4 sec cooldown.\nOn cast, slows enemies within 1500 range by 25% and "
          "deals 50 damage to nearby decorations (650 range).\nAura: You and allies within 1200 range receive 20% "
          "more mana regeneration and mana restoration.\nCooldown: 4 sec.")
PHILOSOPHER = "+15 allstats\nPassive: Dealing damage to enemies restores HP equal to 15% of the damage dealt."
HOKAGE_EVOLVED = ("+500 hp\n+15 allstats\n+5% phys resistance\nActive: Roots enemies within 600 range for 3 sec and "
                  "burns 250 mana.\nDuration: 4 sec.\nCooldown: 20 sec.")
HELLBLAZE = ('+15 allstats\nPassive: Each instance of damage you deal applies a debuff that reduces healing and HP regeneration by 5.5% (up to 7 stacks). At 7 stacks, the target also loses 1.35% of max mana per second |cffff0000(cannot be dispelled)|r.\nDuration: 10 sec.')
MURASAME = ('+80 atk\n+15 allstats\nPassive: Attacks make the target bleed for 5 sec, dealing 0.45x ATK physical damage every second. Each further attack on a bleeding target adds that bleed damage to the next tick and shortens the bleed by 1 sec.')


def configure_takaoni(documents, identity):
    """Make the new command self-contained, without a separate custom skin record."""
    base_document = next(d for d in documents if d['source_file'] == 'war3map.w3a')
    skin_document = next(d for d in documents if d['source_file'] == 'war3mapSkin.w3a')
    ability = next(o for o in base_document['custom_objects'] if objects.object_id(o) == identity)
    skin = next((o for o in skin_document['custom_objects'] if objects.object_id(o) == identity), None)
    if skin is not None:
        for mod in skin['modifications']:
            set_field(ability, mod['field']['text'], copy.deepcopy(mod['data']['value']),
                      mod['type'], mod.get('level', 0), mod.get('data_pointer', 0))
        skin_document['custom_objects'].remove(skin)
    description = ('Kyoraku flies through the Bushogoma cage, ending 650 range past its center, '
                   'and strikes the cage twice with giant slashes, each dealing 2.5x Agility physical '
                   'damage to enemies inside. Available from level 25 while the cage exists; '
                   'cannot be used farther than 2000 range from it.')
    for field, value in (('anam', 'Bleach Kyoraku E2 Takaoni'),
                             ('aart', 'ReplaceableTextures\\CommandButtons\\BTNHero_Kyoraku_E2.blp'),
                             ('arar', 'ReplaceableTextures\\CommandButtons\\BTNHero_Kyoraku_E2.blp'),
                             ('ahky', 'E'), ('arhk', 'E'), ('aret', 'Takaoni (E)'), ('arut', description)):
        set_field(ability, field, value)
    set_field(ability, 'abpx', 2, 'int')
    set_field(ability, 'abpy', 2, 'int')
    for level in range(1, 6):
        set_field(ability, 'atp1', f'Takaoni [|cffffcc00Level {level}|r]', level=level)
        set_field(ability, 'aub1', description, level=level)


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
    ids = json.loads(IDS_PATH.read_text()) if IDS_PATH.exists() else {}
    prefix = {"abilities": "A", "buffs": "B", "items": "I"}
    for label, kind, _ in NEW_OBJECTS:
        if label not in ids:
            ids[label] = allocate(prefix[kind], used)
    strings = raw.parse_wts(main_map() / "war3map.wts")

    def obj(kind, identity, skin=False):
        return index(files[kind][1 if skin else 0]).get(identity)

    for label, kind, template in NEW_OBJECTS:
        for name in files[kind]:
            existing = index(name)
            if ids[label] in existing or template not in existing:
                continue
            by_file[name]["custom_objects"].append(clone_object(existing[template], ids[label], {}, strings))

    def text(kind, identity, **fields):
        target = obj(kind, identity, skin=True)
        for field, value in fields.items():
            if kind == "items" or kind == "buffs":
                set_field(target, field, value, leveled=False)
            else:
                level = 1 if field in ("atp1", "aub1") else 0
                set_field(target, field, value, level=level)

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
            text("items", identity, **fields)

    i = ids
    # Attack bonuses (GetAttack mirrors these values).
    for label, value in (("KusanagiAtk", 40), ("KusanagiGradeAtk", 60)):
        for level in range(1, 6):
            data(i[label], "Iatt", value, "int", level, 1)
    text("abilities", i["KusanagiAtk"], anam="Item Atk Kusanagi +40")
    text("abilities", i["KusanagiGradeAtk"], anam="Item Atk Kusanagi Grade +60")
    # Shared active of the base sword and all grades (no target, 700 AoE).
    data(i["KusanagiActive"], "acdn", 20.0, "unreal")
    data(i["KusanagiActive"], "amcs", 100, "int")
    data(i["KusanagiActive"], "aare", 700.0, "unreal")
    text("abilities", i["KusanagiActive"], anam="Item Kusanagi", atp1="Kusanagi",
         aub1="Dashes to every enemy within 700 range and strikes it.", aart=ICON.format("Kusanagi"))
    data(i["HashiramaActive"], "acdn", 15.0, "unreal")
    text("abilities", i["HashiramaActive"], anam="Item Hashirama Cells", atp1="Hashirama Cells",
         aub1="Sacrifices 10% of current HP to gain +15 Strength for 10 sec.", aart=ICON.format("HashiramaCells"))
    text("abilities", i["HashiramaStr"], anam="Hashirama Cells STR +15 (buff)")
    for n in range(1, 8):
        text("abilities", i[f"RhittaStr{n}"], anam=f"Rhitta STR +5 stack {n}")
    # Ally auras: no native bonuses, only a positive buff read by code.
    for aura, buff, title, tip, icon in (
        ("ShunAura", "ShunBuff", "Shun Shun Rikka", "Receives 18% more HP regeneration and healing; stuns last 0.5 sec shorter.", "ShunShunRikka"),
        ("FrozenAura", "FrozenBuff", "Frozen Heart Blessing", "Receives 20% more mana regeneration and mana restoration.", "Frozen_Heart"),
    ):
        data(i[aura], "Uau1", 0.0, "unreal", 1, 1)
        data(i[aura], "Uau2", 0.0, "unreal", 1, 2)
        data(i[aura], "aare", 1200.0, "unreal")
        data(i[aura], "abuf", i[buff], "string")
        text("abilities", i[aura], anam=title + " Aura", aart=ICON.format(icon))
        text("buffs", i[buff], ftip=title, fube=tip, fart=ICON.format(icon))
    data(i["AshisogiCurse"], "abuf", i["AshisogiBuff"], "string")
    text("abilities", i["AshisogiCurse"], anam="Ashisogi Jizo Poison", aart=ICON.format("AshisogiJizo"))
    text("buffs", i["AshisogiBuff"], ftip="Ashisogi Jizo",
         fube="Poisoned: takes 0.4x the attacker's Agility physical damage every second for 5 sec.", fart=ICON.format("AshisogiJizo"))

    # Laxus G: Gloves of Haste copies (+15% / +30% attack speed).
    for label, value in (("LaxusGAttackSpeed15", 0.15), ("LaxusGAttackSpeed30", 0.30)):
        data(i[label], "Isx1", value, "unreal", 1, 1)
        text("abilities", i[label], anam=f"Laxus G Attack Speed +{round(value * 100)}%")
    # Rimuru 3rd form: copy of 2R swapped into the G slot by G3 (fixed level 5, 30 sec cooldown).
    for level in range(1, 6):
        data(i["RimuruG3Copy2R"], "acdn", 30.0, "unreal", level)
    text("abilities", i["RimuruG3Copy2R"], anam="Another Anime Rimuru3 G2 (2R copy)")
    set_field(obj("abilities", i["RimuruG3Copy2R"], skin=True), "abpx", 2, "int", 0)  # G slot (swapped with G3)
    set_field(obj("abilities", i["RimuruG3Copy2R"], skin=True), "abpy", 1, "int", 0)
    # Kyoraku E2 (lv 25): Takaoni - instant, swapped with E while the cage is active.
    for level in range(1, 6):
        data(i["KyorakuTakaoni"], "Ncl2", 0, "int", level, 2)
        data(i["KyorakuTakaoni"], "Ncl3", 1, "int", level, 3)
        data(i["KyorakuTakaoni"], "Ncl6", "ancestralspirit", "string", level, 6)
        data(i["KyorakuTakaoni"], "aran", 0.0, "unreal", level)
        data(i["KyorakuTakaoni"], "acdn", 0.0, "unreal", level)
        data(i["KyorakuTakaoni"], "amcs", 0, "int", level)
    configure_takaoni(documents, i["KyorakuTakaoni"])
    item(i["Kusanagi"], f"{i['KusanagiActive']},{i['KusanagiAtk']},A00M", 5000, i["KusanagiActive"],
         "Kusanagi", KUS_BASE, "Kusanagi")
    for label, title, element, icon in (("KusanagiFire", "Kusanagi: Blaze Release", "Fire", "KusanagiFire"),
                                        ("KusanagiWater", "Kusanagi: Water Release", "Water", "KusanagiWater"),
                                        ("KusanagiElectro", "Chidori Kusanagi", "Lightning", "KusanagiElectro")):
        item(i[label], f"{i['KusanagiActive']},{i['KusanagiGradeAtk']},A00W", 11000, i["KusanagiActive"],
             title, kus_grade(element), icon)
    item(i["HashiramaCells"], f"{i['HashiramaActive']},A06T,A00X", 5000, i["HashiramaActive"],
         "Hashirama Cells", HASHIRAMA, "HashiramaCells")
    item(i["ShunShunRikka"], f"{i['ShunAura']},A00M,A01Y", 5000, None, "Shun Shun Rikka", SHUN, "ShunShunRikka")
    item(i["AshisogiJizo"], "A074,A00X", 5000, None, "Ashisogi Jizo", ASHISOGI, "AshisogiJizo")

    # Kusanagi active: point target with an AoE marker of the real radius.
    data(i["KusanagiActive"], "Ncl2", 2, "int", 1, 2)
    data(i["KusanagiActive"], "Ncl3", 3, "int", 1, 3)
    data(i["KusanagiActive"], "aran", 900.0, "unreal")
    data("A0CM", "acdn", 30.0, "unreal")  # Mahoraga F: -5 sec
    data("A0DR", "acdn", 35.0, "unreal")  # Asta F: -5 sec
    data("A0DR", "amcs", 63, "int")  # Asta F: half mana cost
    for level, buff in enumerate(("B01S", "B01T", "B01U", "B01V", "B01W", "B02E", "B02F"), 1):
        tip = f"-{5.5 * level:g}% healing and HP regeneration"
        if level == 7:
            tip += "; burns 1.35% of max mana per second"
        text("buffs", buff, fube=tip)
    # Takeshi Cambio form: GF belongs to the F slot (1,1), GG to the G slot (2,1).
    for abil, x, key in (("A099", 1, "F"), ("A09A", 2, "G")):
        set_field(obj("abilities", abil, skin=True), "abpx", x, "int", 0)
        set_field(obj("abilities", abil, skin=True), "abpy", 1, "int", 0)
        set_field(obj("abilities", abil, skin=True), "ahky", key, "string", 0)
    item("I02L", "A0F5,A072,A00X", tip=RHITTA)
    item("I01K", f"A07N,A07M,{i['FrozenAura']},A072,A00X", tip=FROZEN)
    item("I040", tip=PHILOSOPHER)
    item("I03V", tip=HOKAGE_EVOLVED)
    data("A0GX", "aare", 600.0, "unreal")
    item("I02F", tip=HELLBLAZE)
    for level in range(1, 4):  # Frieren G shields (B02V/B02W/B02X): +1 sec
        data("A0GJ", "adur", 2.5, "unreal", level)
        data("A0GJ", "ahdu", 2.5, "unreal", level)
    for level in range(1, 8):  # Hell Blaze debuff stacks: 15 -> 10 sec
        data("A0E6", "adur", 10.0, "unreal", level)
        data("A0E6", "ahdu", 10.0, "unreal", level)
        tip = f"-{5.5 * level:g}% healing and HP regeneration"
        if level == 7:
            tip += "; burns 1.35% of max mana per second"
        data("A0E6", "aub1", tip + ". Duration: 10 sec.", "string", level)
    item("I03Y", tip=MURASAME)

    from stage_hero_packet_2026_10_18 import apply_packet
    apply_packet(documents)

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
