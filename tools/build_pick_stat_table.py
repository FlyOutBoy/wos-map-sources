"""Regenerate the hero-pick stat fallback table embedded in WoS_Pick_Init.j.

The pick preview reads stats from hidden dummy heroes. When a dummy is missing
the card used to show zeros and every hero looked ranged, so the preview now
falls back to object-editor values copied here from object-data/units.json.

Usage:  python tools/build_pick_stat_table.py [--units PATH]
"""
from pathlib import Path
import argparse
import json
import re

ROOT = Path(__file__).resolve().parents[1]
PICK = ROOT / 'triggers/WOS_Start/WoS_Pick_Init.j'
BUILDS = ROOT / 'triggers/WOS_Start/BuildsForChars.j'
BEGIN = '    // BEGIN GENERATED PICK STATS (tools/build_pick_stat_table.py)'
END = '    // END GENERATED PICK STATS'
# Warcraft defaults of the Paladin (Hpal) base for fields the map leaves unset.
DEFAULTS = {'field_ustr': 22, 'field_uagi': 13, 'field_uint': 17, 'strength_per_level': 2.7,
            'agility_per_level': 1.5, 'intelligence_per_level': 1.8, 'primary_attribute': 'STR',
            'attack_1_range': 100, 'attack_1_base_damage': 20, 'base_armor': 0,
            'movement_speed': 270, 'attack_1_cooldown': 2.2}
PRIMARY = {'STR': 1, 'INT': 2, 'AGI': 3}  # UNIT_IF_PRIMARY_ATTRIBUTE values


def rawcodes():
    ids = {}
    for path in (ROOT / 'triggers').rglob('*.j'):
        text = path.read_text(encoding='utf-8', errors='replace')
        for m in re.finditer(r"\b(?:constant\s+)?integer\s+(\w+_ID)\s*=\s*'(\w{4})'", text):
            ids.setdefault(m.group(1), m.group(2))
    return ids


def block(units):
    ids = rawcodes()
    names = re.findall(r'set Hero_ID\d\[n\] = (\w+)', BUILDS.read_text(encoding='utf-8', errors='replace'))
    lines = [BEGIN]
    for name in dict.fromkeys(names):
        code = ids.get(name)
        if not code or code not in units:
            continue
        data = dict(DEFAULTS)
        data.update({k: v for k, v in units[code].items() if v is not None})
        values = [int(data['field_ustr']), int(data['field_uagi']), int(data['field_uint']),
                  round(float(data['strength_per_level']) * 100), round(float(data['agility_per_level']) * 100),
                  round(float(data['intelligence_per_level']) * 100), PRIMARY.get(data['primary_attribute'], 1),
                  1 if float(data['attack_1_range']) <= 200 else 0, int(data['attack_1_base_damage']),
                  round(float(data['base_armor']) * 100), int(data['movement_speed']),
                  round(float(data['attack_1_cooldown']) * 100), int(float(data['attack_1_range']))]
        lines.append(f"    call WOS_PickStatRow('{code}', " + ', '.join(str(v) for v in values) + ')')
    lines.append(END)
    return '\n'.join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--units', type=Path, default=ROOT / 'object-data/units.json')
    args = parser.parse_args()
    units = json.loads(args.units.read_text(encoding='utf-8-sig'))
    raw = PICK.read_bytes().decode('utf-8')
    crlf = '\r\n' in raw
    text = raw.replace('\r\n', '\n')
    start, end = text.index(BEGIN), text.index(END) + len(END)
    new = block(units)
    text = text[:start] + new + text[end:]
    PICK.write_bytes((text.replace('\n', '\r\n') if crlf else text).encode('utf-8'))
    print('pick stat rows:', new.count('WOS_PickStatRow('))


if __name__ == '__main__':
    main()
