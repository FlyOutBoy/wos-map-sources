"""Frostnova F debuff (A11C) Winter's Scar levels 6-10: slow 8% -> 6% per stack,
native duration 6 -> 5 sec (matches FrostnovaTF_Duration). Idempotent; only
object JSON/raw/metadata are staged, the regular check/save writes the map.
"""
from pathlib import Path

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field

ROOT = Path(__file__).resolve().parents[1]
SLOW_PER_STACK = 0.06
DURATION = 5.0


def stage():
    documents, _ = objects.prepare_documents(ROOT / "object-data", ROOT / ".object-data-raw")
    base = next(d for d in documents if d["source_file"] == "war3map.w3a")
    debuff = next(o for o in base["custom_objects"] if objects.object_id(o) == "A11C")
    for stack in range(1, 6):
        level = 5 + stack
        set_field(debuff, "Slo1", round(SLOW_PER_STACK * stack, 4), "unreal", level, 1)
        set_field(debuff, "adur", DURATION, "unreal", level)
        set_field(debuff, "ahdu", DURATION, "unreal", level)
    for document in documents:
        raw.encode_object_file(document, document["source_file"])
        raw.dump_json(ROOT / ".object-data-raw" / raw.OUTPUT_NAMES[document["source_file"]], document)
    for kind, (editable, metadata) in objects.views_from_raw(documents, ROOT / "libs/common.j").items():
        raw.dump_json(ROOT / "object-data" / objects.CATEGORY_FILES[kind], editable)
        raw.dump_json(ROOT / ".object-data-raw/workspace-meta" / objects.CATEGORY_FILES[kind], metadata)


if __name__ == "__main__":
    stage()
