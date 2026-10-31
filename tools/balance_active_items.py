"""Source of active-item mana tiers and native elemental cooldown families.

--fix stages fields through the project object API, including metadata for new
mana overrides. Normal check/save writes the map. Mode buttons also cost125 MP.
"""
from pathlib import Path
import argparse
import json
import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field

ROOT = Path(__file__).resolve().parents[1]
MANA_COSTS = {
    **dict.fromkeys('A00Y A00Z A01B A01Z A02G A06S A02I A06Q A076 A0AL A0FD A0G0 A0G1 A0HE A0HY A152'.split(), 125),
    **dict.fromkeys('A02U A06P A09M A09N A0CX A0DD A0E4 A0GX A102 A10D A142 A145 A146 A148 A14A A14D A14E A150'.split(), 150),
    **dict.fromkeys('A02T A06O A06R A09L A0BZ A0F5 A131 A133 A135 A13A A13C A13E A140 A147 A149 A14B A14C A14F A151 A154'.split(), 175),
}
ELEMENT_ITEMS = {
    **dict.fromkeys('I00G I01V I02L I047 I060 I065 I066 I069 I06A'.split(), 'Fire'),
    **dict.fromkeys('I016 I01S I048 I061 I062 I067 I06B'.split(), 'Water'),
    **dict.fromkeys('I015 I01U I049 I063 I064 I068 I06C'.split(), 'Lightning'),
}
GROUP_ABILITIES = {'Fire': 'A145', 'Water': 'A146', 'Lightning': 'A148'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--fix', action='store_true')
    args = parser.parse_args()
    abilities = json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
    items = json.loads((ROOT/'object-data/items.json').read_text(encoding='utf-8-sig'))
    families = {iid: {'cooldown_group': GROUP_ABILITIES[element]} for iid, element in ELEMENT_ITEMS.items()}
    for iid, obj in items.items():
        if obj.get('actively_used'):
            assert any(aid in MANA_COSTS for aid in obj.get('abilities', '').split(',')), iid
    count = sum(abilities[aid].get('mana_cost level 1') != cost for aid, cost in MANA_COSTS.items())
    count += sum(items[iid].get('cooldown_group') != fields['cooldown_group'] for iid, fields in families.items())
    if args.fix:
        documents, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
        configure(documents)
        for document in documents:
            raw.encode_object_file(document, document['source_file'])
            raw.dump_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[document['source_file']], document)
        for kind, (editable, metadata) in objects.views_from_raw(documents, ROOT/'libs/common.j').items():
            raw.dump_json(ROOT/'object-data'/objects.CATEGORY_FILES[kind], editable)
            raw.dump_json(ROOT/'.object-data-raw/workspace-meta'/objects.CATEGORY_FILES[kind], metadata)
    print(f'{len(MANA_COSTS)} active abilities; {len(families)} elemental items; {count} fields ' + ('updated' if args.fix else 'differ'))
    return 0 if args.fix or count == 0 else 1


def configure(documents):
    for document in documents:
        for obj in document['custom_objects']:
            identity = objects.object_id(obj)
            if document['source_file'] == 'war3map.w3a' and identity in MANA_COSTS:
                set_field(obj, 'amcs', MANA_COSTS[identity], 'int', 1)
            if document['source_file'] == 'war3map.w3t' and identity in ELEMENT_ITEMS:
                set_field(obj, 'icid', GROUP_ABILITIES[ELEMENT_ITEMS[identity]], leveled=False)


if __name__ == '__main__':
    raise SystemExit(main())
