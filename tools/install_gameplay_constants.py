"""Keep native MAIN mana regeneration equal to the authoritative JASS HUD formula.

Only the named field in [Misc] is changed. The previous native file is backed up;
this runs with the regular MAIN asset installation before map packaging.
"""
from pathlib import Path
from datetime import datetime
import argparse
import re
import shutil

ROOT = Path(__file__).resolve().parents[1]


def mana_regen_per_int():
    source = (ROOT/'triggers/Systems/Systems1.j').read_text(encoding='utf-8-sig')
    return float(re.search(r'\breal int_mpregen\s*=\s*([\d.]+)', source)[1])


def agi_move_bonus():
    source = (ROOT/'triggers/Systems/Systems1.j').read_text(encoding='utf-8-sig')
    return float(re.search(r'\breal agi_ms\s*=\s*([\d.]+)', source)[1])


def patch_misc(data, value, field='IntRegenBonus'):
    text = data.decode('utf-8-sig')
    section = re.search(r'(?ms)^\[Misc\][ \t]*\r?\n.*?(?=^\[|\Z)', text)
    if not section:
        raise ValueError('Native gameplay constants have no [Misc] section')
    body, count = re.subn(r'(?m)^(' + field + r'=)[^\r\n]*',
                          lambda m: m[1]+format(value, '.9g'), section[0])
    if count != 1:
        raise ValueError('Expected exactly one Misc.' + field + ' field')
    out = text[:section.start()]+body+text[section.end():]
    return (b'\xef\xbb\xbf' if data.startswith(b'\xef\xbb\xbf') else b'')+out.encode()


def install(map_dir):
    path = map_dir/'war3mapMisc.txt'
    before = path.read_bytes()
    after = patch_misc(patch_misc(before, mana_regen_per_int()), agi_move_bonus(), 'AgiMoveBonus')
    if before == after:
        print('Native gameplay constants already match JASS')
        return
    backup = ROOT/'backups/gameplay-constants'/datetime.now().strftime('%Y%m%d-%H%M%S-%f')
    backup.mkdir(parents=True)
    shutil.copy2(path, backup/path.name)
    path.write_bytes(after)
    print(f'Native IntRegenBonus={mana_regen_per_int():g}, AgiMoveBonus={agi_move_bonus():g}; backup: {backup}')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--map', type=Path, required=True)
    install(parser.parse_args().map.resolve())
