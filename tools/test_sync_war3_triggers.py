import tempfile
import unittest
from pathlib import Path

import extract_war3_triggers as fmt
import sync_war3_triggers as sync


class TriggerSourceMappingTests(unittest.TestCase):
    def test_current_wtg_name_wins_over_reused_manifest_id(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            expected = root / "Heroes" / "Milim.j"
            wrong = root / "Heroes" / "Bambietta.j"
            expected.parent.mkdir(parents=True)
            expected.write_text("library MilimSpells\nendlibrary\n", encoding="utf-8")
            wrong.write_text("library BambiettaSpells\nendlibrary\n", encoding="utf-8")
            category_id = 0x02000001
            item = {
                "object_id": 0x0300007A,
                "name": "Milim",
                "parent_id": category_id,
            }
            objects = {
                category_id: {
                    "object_type": fmt.OBJECT_CATEGORY,
                    "object_id": category_id,
                    "name": "Heroes",
                    "parent_id": 0,
                }
            }
            result = sync.find_source_path(
                item,
                objects,
                root,
                {item["object_id"]: "Heroes/Bambietta.j"},
                ["Heroes/Bambietta.j", "Heroes/Milim.j"],
            )
            self.assertEqual("Heroes/Milim.j", result)


if __name__ == "__main__":
    unittest.main()
