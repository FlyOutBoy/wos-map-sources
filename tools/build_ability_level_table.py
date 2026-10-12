"""Regenerate the hero-ability level table embedded in ShowCD.j.

Unlearned hero skills have no ability handle, so their level count and the
hero levels at which each level unlocks cannot be read at runtime.  This tool
copies `levels`, `required_level` and `level_skip` for every rawcode listed in
AHUI_ConfigureHeroAbilities from object-data/abilities.json into the block
between the GENERATED markers of ShowCD.j.

Usage:  python tools/build_ability_level_table.py [--abilities PATH]
Run it after changing hero abilities in the object editor JSON.
"""
from pathlib import Path
import argparse
import json
import re

ROOT = Path(__file__).resolve().parents[1]
SHOWCD = ROOT / 'triggers/WOS_Start/ShowCD.j'
BEGIN = '    // BEGIN GENERATED ABILITY LEVELS (tools/build_ability_level_table.py)'
END = '    // END GENERATED ABILITY LEVELS'


def rawcode_table():
    ids = {}
    for path in (ROOT / 'triggers').rglob('*.j'):
        text = path.read_text(encoding='utf-8', errors='replace')
        for m in re.finditer(r"\b(?:constant\s+)?integer\s+(\w+_ID)\s*=\s*'(\w{4})'", text):
            ids.setdefault(m.group(1), m.group(2))
    return ids


def build_block(abilities):
    source = SHOWCD.read_text(encoding='utf-8')
    names = re.findall(r'AHUI_AddHeroAbility\(whichHero, AHUI_SLOT_\w, (\w+)\)', source)
    ids = rawcode_table()
    lines = [BEGIN]
    seen = set()
    for name in names:
        code = ids.get(name)
        if not code or code in seen:
            continue
        seen.add(code)
        data = abilities.get(code, {})
        levels = int(data.get('levels') or 1)
        required = int(data.get('required_level') or 1)
        skip = int(data.get('level_skip') or 0)
        lines.append(f"    call AHUI_SetLevelInfo('{code}', {levels}, {required}, {skip})")
    lines.append(END)
    return source, '\r\n'.join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--abilities', type=Path, default=ROOT / 'object-data/abilities.json')
    args = parser.parse_args()
    abilities = json.loads(args.abilities.read_text(encoding='utf-8-sig'))
    source, block = build_block(abilities)
    raw = SHOWCD.read_bytes().decode('utf-8')
    start = raw.index(BEGIN)
    end = raw.index(END) + len(END)
    raw = raw[:start] + block + raw[end:]
    SHOWCD.write_bytes(raw.encode('utf-8'))
    print('ability level rows:', block.count('AHUI_SetLevelInfo'))


if __name__ == '__main__':
    main()
