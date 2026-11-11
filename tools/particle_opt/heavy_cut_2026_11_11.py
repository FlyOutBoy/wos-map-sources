"""2026-11-11 (2): strong particle cut, written to assets/optimized (installed by every BUILD MAIN).

1. Akainu T fists / Bambietta TE blast / fire explosion: emission x0.5 and life x0.5 once more.
2. Every used model (triggers/ or object-data) with simulated peak alive particles above the cap:
   emission x max(FLOOR, cap/peak) on emitters that hold >= 8 particles at the worst moment.
   Caps: effects 120 (floor x0.15), hero/unit models 300 (floor x0.2). No size compensation.
Source = assets/optimized copy if present, else the MAIN map copy. Originals -> backups/models/20261111-heavy-cut.
Idempotent via marker files.
"""
from pathlib import Path
import json
import shutil
import struct
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
import mdx  # noqa: E402
import sim  # noqa: E402

ROOT = Path(__file__).resolve().parents[2]
OPT = ROOT / 'assets/optimized/war3mapImported'
BACKUP = ROOT / 'backups/models/20261111-heavy-cut'
THREE = ['wos_OP (114).mdx', 'wos_AZ_D073red.mdx', 'wos_fire explosion.mdx']
CAP_FX, FLOOR_FX = 120.0, 0.15
CAP_UNIT, FLOOR_UNIT = 300.0, 0.2
BS = chr(92)


def scale_f(d, off, k):
    v = struct.unpack_from('<f', d, off)[0]
    struct.pack_into('<f', d, off, v * k)


def scale_emission(d, e, k):
    scale_f(d, e['rate_off'], k)
    for fr, val, vo in e['anim'].get('KP2E', []):
        scale_f(d, vo, k)


def source(map_dir, name):
    return OPT / name if (OPT / name).exists() else map_dir / name


def save(name, src, d):
    if not (BACKUP / name).exists():
        shutil.copy2(src, BACKUP / name)
    OPT.mkdir(parents=True, exist_ok=True)
    (OPT / name).write_bytes(bytes(d))


def texts():
    code = {}
    for p in (ROOT / 'triggers').rglob('*.j'):
        code[p.stem] = p.read_text(encoding='utf-8', errors='ignore').lower().replace(BS + BS, BS)
    units = (ROOT / 'object-data/units.json').read_text(encoding='utf-8', errors='ignore').lower().replace(BS + BS, BS)
    od = ''
    for p in (ROOT / 'object-data').glob('*.json'):
        od += p.read_text(encoding='utf-8', errors='ignore').lower().replace(BS + BS, BS)
    return code, units, od


def main():
    config = json.loads((ROOT / '.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
    map_dir = Path(config['mainMap']) / 'war3mapImported'
    BACKUP.mkdir(parents=True, exist_ok=True)
    report = []

    for name in THREE:
        marker = BACKUP / (name + '.x2b.done')
        if marker.exists():
            print('skip', name)
            continue
        src = source(map_dir, name)
        info, data = mdx.analyze(str(src))
        before = sim.model_peak(info)[0]
        d = bytearray(data)
        for e in info['emitters']:
            if e['kind'] == 'PRE2':
                scale_emission(d, e, 0.5)
                scale_f(d, e['life_off'], 0.5)
        save(name, src, d)
        marker.write_text('done')
        after = sim.model_peak(mdx.analyze(str(OPT / name))[0])[0]
        report.append((name, 'x0.5 emission+life', before, after, ''))

    code, units, od = texts()
    for p in sorted(map_dir.glob('*.mdx')):
        name = p.name
        if name in THREE:
            continue
        key = p.stem.lower() + '.md'
        where = [k for k, s in code.items() if key in s]
        if not where and key not in od:
            continue
        marker = BACKUP / (name + '.cut.done')
        if marker.exists():
            continue
        src = source(map_dir, name)
        try:
            info, data = mdx.analyze(str(src))
            peak, fill, seq, per = sim.model_peak(info)
        except Exception:
            continue
        is_unit = key in units
        cap, floor = (CAP_UNIT, FLOOR_UNIT) if is_unit else (CAP_FX, FLOOR_FX)
        if peak <= cap:
            continue
        k = max(floor, cap / peak)
        ems = [e for e in info['emitters'] if e['kind'] == 'PRE2']
        d = bytearray(data)
        touched = 0
        for i, e in enumerate(ems):
            if per.get(i, 0) < 8:
                continue
            scale_emission(d, e, k)
            touched += 1
        if not touched:
            continue
        save(name, src, d)
        marker.write_text('done')
        after = sim.model_peak(mdx.analyze(str(OPT / name))[0])[0]
        report.append((name, 'unit' if is_unit else 'fx', peak, after, ','.join(where)[:60]))

    for r in sorted(report, key=lambda r: -r[2]):
        print('%-50s %-18s %6.0f -> %5.0f  %s' % r)
    print('changed:', len(report))


if __name__ == '__main__':
    main()
