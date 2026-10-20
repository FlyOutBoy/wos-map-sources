"""Stage the 2026-10-19 item update in MAIN object data (idempotent).

New: Scroll of Mastery - base shop, 5000 gold, consumed on purchase for a permanent
+2 Strength / Agility / Intelligence (applied by ItemEnter.j).

Only object JSON/raw/metadata are staged; the regular check/save writes the map.
Allocated rawcodes are kept in object-data/items-2026-10-19-ids.json.
"""
from pathlib import Path
import json
import re

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field, clone_object, allocate

ROOT = Path(__file__).resolve().parents[1]
IDS_PATH = ROOT / "object-data/items-2026-10-19-ids.json"
TEMPLATE = "I02Z"  # Tome of Strength +5 (rde1)
ICON = "ReplaceableTextures\\CommandButtons\\BTNTome.blp"
TITLE = "Scroll of Mastery"
TIP = ("Consumed on purchase: permanently grants +2 Strength, +2 Agility and +2 Intelligence.\n"
       "Does not take an inventory slot.")


def main_map():
    config = json.loads((ROOT / ".vscode/wos-build.json").read_text(encoding="utf-8"))
    return Path(config["mainMap"])


def stage():
    documents, _ = objects.prepare_documents(ROOT / "object-data", ROOT / ".object-data-raw")
    by_file = {d["source_file"]: d for d in documents}

    def index(name):
        return {objects.object_id(o): o for o in by_file[name]["custom_objects"]}

    used = {objects.object_id(o) for d in documents for g in ("original_objects", "custom_objects") for o in d[g]}
    for path in (ROOT / "triggers").rglob("*.j"):
        used.update(re.findall(r"'([^'\r\n]{4})'", path.read_text(encoding="utf-8-sig", errors="replace")))
    ids = json.loads(IDS_PATH.read_text()) if IDS_PATH.exists() else {}
    if "ScrollOfMastery" not in ids:
        ids["ScrollOfMastery"] = allocate("I", used)
    identity = ids["ScrollOfMastery"]
    strings = raw.parse_wts(main_map() / "war3map.wts")
    for name in ("war3map.w3t", "war3mapSkin.w3t"):
        existing = index(name)
        if identity not in existing and TEMPLATE in existing:
            by_file[name]["custom_objects"].append(clone_object(existing[TEMPLATE], identity, {}, strings))

    base = index("war3map.w3t")[identity]
    set_field(base, "iabi", "", leveled=False)
    set_field(base, "igol", 5000, "int", leveled=False)
    skin = index("war3mapSkin.w3t").get(identity, base)
    for field, value in (("unam", TITLE), ("utip", TITLE), ("utub", TIP), ("ides", TIP), ("iico", ICON)):
        set_field(skin, field, value, leveled=False)

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
