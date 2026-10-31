"""Source of active-item mana tiers and native elemental cooldown families.

--fix stages fields through the project object API, including metadata for new
mana overrides. Normal check/save writes the map. Utility actives and mode buttons cost no mana.
"""
from pathlib import Path
import argparse
import json
import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field

ROOT = Path(__file__).resolve().parents[1]
# Only damage actives consume mana; Return by Death and the knife are explicit exceptions.
MANA_COSTS = {
    **dict.fromkeys('A00Y A01B A02I A02U A02T A06R A06S A0AL A0BZ A0CX A0E4 A0FD A0G0 A0G1 A0GX A0HE A10D A131 A133 A135 A13A A13C A140 A142 A152 A154 A161'.split(), 0),
    **dict.fromkeys('A00Z A01Z A02G A06Q A076 A13E'.split(), 125),
    **dict.fromkeys('A06P A09M A09N A0DD A102 A145 A146 A148 A14A A14D A14E A150'.split(), 150),
    **dict.fromkeys('A06O A09L A0F5 A147 A149 A14B A14C A14F A151'.split(), 175),
    'A0HY': 80,
}
DAMAGE_CAST_ABILITIES = set('A00Z A01Z A02G A06Q A076 A06O A06P A09L A09M A09N A0DD A0F5 A0HY A102 A145 A146 A147 A148 A149 A14A A14B A14C A14D A14E A14F A150 A151'.split())
DAMAGE_CAST_RANGE = 1600.0
DAMAGE_CAST_RANGES = {aid: 2100.0 if aid == 'A0HY' else DAMAGE_CAST_RANGE for aid in DAMAGE_CAST_ABILITIES}
# Linear/fan projectiles select a direction, not an impact disc at the cursor.
SKILLSHOT_ABILITIES = set('A06Q A09L A09N A0HY A14B A14C A151'.split())
RESIST_DEBUFF_RANKS = {'A01H': 2, 'A07L': 1}
RESIST_DEBUFF_DURATION = 10.0

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
    count += sum(abilities[aid].get('cast_range level 1') != reach for aid, reach in DAMAGE_CAST_RANGES.items())
    documents, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
    count += len(native_field_errors(documents))
    native = {objects.object_id(o): {(m['field']['text'], m.get('level', 0)): objects.value_for_user(m) for m in o['modifications']}
              for d in documents if d['source_file'] == 'war3map.w3a' for o in d['custom_objects']}
    count += sum(native[aid].get((field, rank)) != RESIST_DEBUFF_DURATION
                 for aid, rank in RESIST_DEBUFF_RANKS.items() for field in ('adur', 'ahdu'))
    count += sum(native[aid].get(('aite', 0)) != 1 or native[aid].get(('aher', 0)) != 0 for aid in MANA_COSTS)
    count += abilities['A06O'].get('area_of_effect level 1') != 450.0
    count += abilities['A154'].get('cooldown level 1') != 20.0
    count += 'invulnerable' not in abilities['A133'].get('allowed_targets level 1', '').split(',')
    count += shop_policy_source(items) not in (ROOT/'triggers/WOS_Start/WoS_Shop_Init.j').read_text(encoding='utf-8-sig')
    count += sum(items[iid].get('cooldown_group') != fields['cooldown_group'] for iid, fields in families.items())
    if args.fix:
        configure(documents)
        sync_shop_policy(items)
        for document in documents:
            raw.encode_object_file(document, document['source_file'])
            raw.dump_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[document['source_file']], document)
        for kind, (editable, metadata) in objects.views_from_raw(documents, ROOT/'libs/common.j').items():
            raw.dump_json(ROOT/'object-data'/objects.CATEGORY_FILES[kind], editable)
            raw.dump_json(ROOT/'.object-data-raw/workspace-meta'/objects.CATEGORY_FILES[kind], metadata)
    print(f'{len(MANA_COSTS)} active abilities; {len(families)} elemental items; {count} fields ' + ('updated' if args.fix else 'differ'))
    return 0 if args.fix or count == 0 else 1



def shop_policy_source(items):
    """Pure display and purchase rules; safe to read from local frame rendering."""
    by_cost = {}
    for iid, item in items.items():
        cost = max((MANA_COSTS.get(aid, 0) for aid in item.get('abilities', '').split(',')), default=0)
        if cost:
            by_cost.setdefault(cost, []).append(iid)
    lines = ['// BEGIN GENERATED ACTIVE ITEM POLICY (tools/balance_active_items.py)',
             'function ShopItemManaCost takes integer id returns integer']
    for cost, ids in sorted(by_cost.items()):
        lines += ['    if ' + ' or '.join("id == '%s'" % iid for iid in ids) + ' then',
                  '        return ' + str(cost), '    endif']
    lines += ['    return 0', 'endfunction', '',
              'function ShopItemDisplayName takes integer id returns string',
              '    local integer cost = ShopItemManaCost(id)',
              '    if cost > 0 then',
              '        return "|cff7caefa" + I2S(cost) + " MP|r " + GetObjectName(id)',
              '    endif', '    return GetObjectName(id)', 'endfunction', '',
              'function ShopElementalClass takes integer id returns integer']
    for index, family in enumerate(GROUP_ABILITIES, 1):
        ids = [iid for iid, element in ELEMENT_ITEMS.items() if element == family]
        lines += ['    if ' + ' or '.join("id == '%s'" % iid for iid in ids) + ' then',
                  '        return ' + str(index), '    endif']
    lines += ['    return 0', 'endfunction', '// END GENERATED ACTIVE ITEM POLICY']
    return '\n'.join(lines)


def sync_shop_policy(items):
    import re
    path = ROOT/'triggers/WOS_Start/WoS_Shop_Init.j'
    data = path.read_bytes()
    text = data.decode('utf-8-sig').replace('\r\n', '\n')
    source = shop_policy_source(items)
    pattern = r'// BEGIN GENERATED ACTIVE ITEM POLICY.*?// END GENERATED ACTIVE ITEM POLICY'
    if re.search(pattern, text, re.S):
        text = re.sub(pattern, lambda _: source, text, flags=re.S)
    else:
        text = text.replace('endglobals', 'endglobals\n\n'+source, 1)
    ending = '\r\n' if b'\r\n' in data else '\n'
    path.write_bytes((b'\xef\xbb\xbf' if data.startswith(b'\xef\xbb\xbf') else b'') + text.replace('\n', ending).encode())


def native_field_errors(documents):
    errors = []
    for document in documents:
        if document['source_file'] != 'war3map.w3a':
            continue
        for obj in document['custom_objects']:
            aid = objects.object_id(obj)
            for mod in obj['modifications']:
                field = mod['field']['text']
                if mod.get('level') != 1:
                    continue
                if ((aid in DAMAGE_CAST_ABILITIES and field == 'aran') or
                        (aid == 'A06O' and field == 'aare')) and mod['type'] != 'unreal':
                    errors.append((aid, field, mod['type']))
                if aid in SKILLSHOT_ABILITIES and field == 'Ncl3' and mod['data']['value'] & 2:
                    errors.append((aid, field, 'Targeting Image'))
    return errors


def configure(documents):
    for document in documents:
        for obj in document['custom_objects']:
            identity = objects.object_id(obj)
            if document['source_file'] == 'war3map.w3a' and identity in MANA_COSTS:
                set_field(obj, 'amcs', MANA_COSTS[identity], 'int', 1)
                set_field(obj, 'aite', 1, 'int', 0)
                set_field(obj, 'aher', 0, 'int', 0)
            if document['source_file'] == 'war3map.w3a' and identity in DAMAGE_CAST_ABILITIES:
                # Native distance/area fields use type 2 (unreal), not type 1 (real).
                set_field(obj, 'aran', DAMAGE_CAST_RANGES[identity], 'unreal', 1)
            if document['source_file'] == 'war3map.w3a' and identity == 'A151':
                set_field(obj, 'aare', 250.0, 'unreal', 1)
            if document['source_file'] == 'war3map.w3a' and identity == 'A06O':
                set_field(obj, 'aare', 450.0, 'unreal', 1)
            if document['source_file'] == 'war3map.w3a' and identity in SKILLSHOT_ABILITIES:
                options = next(m['data']['value'] for m in obj['modifications']
                               if m['field']['text'] == 'Ncl3' and m.get('level') == 1)
                set_field(obj, 'Ncl3', options & ~2, 'int', 1)
            if document['source_file'] == 'war3map.w3a' and identity in RESIST_DEBUFF_RANKS:
                for field in ('adur', 'ahdu'):
                    set_field(obj, field, RESIST_DEBUFF_DURATION, 'unreal', RESIST_DEBUFF_RANKS[identity])
            if document['source_file'] == 'war3map.w3a' and identity == 'A154':
                set_field(obj, 'acdn', 20.0, 'unreal', 1)
            if document['source_file'] == 'war3map.w3a' and identity == 'A133':
                set_field(obj, 'atar', 'air,enemies,ground,hero,invulnerable,vulnerable', 'string', 1)
            if document['source_file'] == 'war3map.w3t' and identity in ELEMENT_ITEMS:
                set_field(obj, 'icid', GROUP_ABILITIES[ELEMENT_ITEMS[identity]], leveled=False)


if __name__ == '__main__':
    raise SystemExit(main())
