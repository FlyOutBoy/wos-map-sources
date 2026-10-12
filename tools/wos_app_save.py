"""Reference implementation of the WoS2 local save files for WOS App.

Folder: Documents/Warcraft III/CustomMapData/save/

  WOS2_local4_<A>_<B>.txt     career   (written by the map at the end of a full match)
  WOS2_local4set_<A>_<B>.txt  settings (written by the map: match end / "Save Keys" button)
  WOS2_app1_<A>_<B>.txt       app stats (written by WOS App, only read by the map)

<A>, <B> are the profile keys of one nickname. The app does not have to compute
them: it finds the career file whose "N,<nickname>" record equals its own
normalized nickname and takes A and B from that file name. The settings file
(hotkeys, camera, music...) is never touched by the app.

Usage:
  python tools/wos_app_save.py show  <career file>
  python tools/wos_app_save.py find  <save folder> <nickname>
  python tools/wos_app_save.py app   <save folder> <nickname>   # writes WOS2_app1_A_B.txt
"""
from pathlib import Path
import re
import sys

MOD = 999983
LINE_RE = re.compile(r'BlzSetAbilityTooltip\(([^,]+),"(.*?)",0\)')
# The map reads WOS2_app1 from these ten tooltips, in this order.
APP_CARRIERS = ['Amls', 'Aroc', 'Amic', 'Amil', 'Aclf', 'Acmg', 'Adef', 'Adis', 'Afbt', 'Afbk']
APP_PIECE = 200          # characters per carrier line
APP_MAX = 2400           # the map rejects a longer app buffer


def i32(value):
    """JASS integers wrap at 32 bits."""
    value &= 0xFFFFFFFF
    return value - 0x100000000 if value >= 0x80000000 else value


def jass_mod(value, base=MOD):
    """SaveSystem_PositiveModulo: ModuloInteger (truncating) made positive."""
    value = i32(value)
    q = int(value / base)            # truncation toward zero, like JASS
    result = value - q * base
    return result + base if result < 0 else result


def normalize_nickname(name):
    """SaveSystem_NormalizeNickname: no color codes, cut at '#', trimmed,
    lower case, a trailing "[vip]" removed."""
    out, i = '', 0
    while i < len(name):
        two = name[i:i + 2]
        if name[i] == '#':
            break
        if two in ('|c', '|C'):
            i += 10
        elif two in ('|r', '|R'):
            i += 2
        else:
            out += name[i]
            i += 1
    out = out.strip().lower()
    if out.endswith('[vip]'):
        out = out[:-5]
    return out.rstrip()


# ----- checksums (A, B = profile keys from the file name) -----
def local_checksum(a, b, x, y):
    """A record (x=games, y=wins), T record (x=train deaths, y=7), E record (x=count, y=0)."""
    return jass_mod(i32(x * 37) + i32(y * 61) + i32(a * 3) + i32(b * 5) + 17041)


def app_hero_checksum(a, b, hero_id, games, wins):
    return jass_mod(hero_id * 7 + games * 11 + wins * 13 + a + b + 57031)


# ----- reading -----
def read_chunks(path):
    """All tooltip literals of a Preload file, joined in file order."""
    text = Path(path).read_text(encoding='utf-8', errors='replace')
    return ''.join(m.group(2) for m in LINE_RE.finditer(text))


def parse_career(buffer):
    """'WOS2L5|V,6|A,...|N,nick|T,...|H,...|B,...|I,...|E,...|' -> dict."""
    data = {'nick': None, 'games': 0, 'wins': 0, 'train_deaths': 0, 'heroes': {}}
    if not buffer.startswith('WOS2L5|'):
        return None
    for record in buffer.split('|')[1:]:
        kind, _, rest = record.partition(',')
        fields = rest.split(',') if rest else []
        if kind == 'N':
            data['nick'] = rest
        elif kind == 'A':
            data['games'], data['wins'] = int(fields[0]), int(fields[1])
        elif kind == 'T':
            data['train_deaths'] = int(fields[0])
        elif kind == 'H':
            hero = int(fields[0])
            data['heroes'][hero] = {'games': int(fields[1]), 'wins': int(fields[2]),
                                    'round_wins': int(fields[3]), 'round_losses': int(fields[4]),
                                    'kills': int(fields[6]), 'deaths': int(fields[7])}
    return data


def keys_from_name(path):
    m = re.search(r'_(-?\d+)_(-?\d+)\.txt$', Path(path).name)
    return (int(m.group(1)), int(m.group(2))) if m else None


def find_profile(folder, nickname):
    """Career file of this nickname -> (path, A, B, career)."""
    wanted = normalize_nickname(nickname)
    for path in sorted(Path(folder).glob('WOS2_local4_*.txt')):
        career = parse_career(read_chunks(path))
        if career and career['nick'] == wanted:
            a, b = keys_from_name(path)
            return path, a, b, career
    return None


# ----- writing -----
def preload_file(pieces):
    """pieces: [(rawcode, text)] -> Preload file text the map can execute."""
    lines = ['function PreloadFiles takes nothing returns nothing', '', '\tcall PreloadStart()']
    for code, text in pieces:
        assert '"' not in text and '\\' not in text and len(text) <= 255
        lines.append('\tcall Preload( "")')
        lines.append(f"call BlzSetAbilityTooltip('{code}',\"{text}\",0)")
        lines.append('//" )')
    lines += ['\tcall PreloadEnd( 0.0 )', '', 'endfunction', '']
    return '\r\n'.join(lines)


def build_app_buffer(a, b, heroes):
    """heroes: {heroId: (games, wins)}; totals are derived (the map checks them)."""
    games = sum(g for g, _ in heroes.values())
    wins = sum(w for _, w in heroes.values())
    records = [f'A,{games},{wins},{local_checksum(a, b, games, wins)}']
    for hero_id, (g, w) in heroes.items():
        if g > 0:
            records.append(f'H,{hero_id},{g},{w},{app_hero_checksum(a, b, hero_id, g, w)}')
    count = len(records)
    records.append(f'E,{count},{local_checksum(a, b, count, 0)}')
    buffer = 'WOS2APP1|' + '|'.join(records) + '|'
    if len(buffer) > APP_MAX:
        raise ValueError('too many heroes for one app file')
    return buffer


def write_app_file(folder, a, b, heroes):
    buffer = build_app_buffer(a, b, heroes)
    pieces = [buffer[i:i + APP_PIECE] for i in range(0, len(buffer), APP_PIECE)]
    if len(pieces) > len(APP_CARRIERS):
        raise ValueError('app buffer does not fit the carriers')
    path = Path(folder) / f'WOS2_app1_{a}_{b}.txt'
    path.write_text(preload_file(list(zip(APP_CARRIERS, pieces))), encoding='utf-8', newline='')
    return path


def main(argv):
    if len(argv) >= 2 and argv[0] == 'show':
        print(parse_career(read_chunks(argv[1])))
    elif len(argv) >= 3 and argv[0] in ('find', 'app'):
        found = find_profile(argv[1], argv[2])
        if not found:
            print('no career file for', normalize_nickname(argv[2]))
            return 1
        path, a, b, career = found
        print(path.name, a, b, career)
        if argv[0] == 'app':
            heroes = {h: (v['games'], v['wins']) for h, v in career['heroes'].items()}
            print('written', write_app_file(argv[1], a, b, heroes))
    else:
        print(__doc__)
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
