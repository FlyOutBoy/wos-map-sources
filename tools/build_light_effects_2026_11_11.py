"""2026-11-11 (evening): light copies of heavy effects that are spawned very often.

Each copy = source model (assets/optimized copy if present, else the MAIN map copy) with
  * PRE2 emission (rate + KP2E keys) multiplied by `emission`;
  * listed geosets hidden through a static zero-alpha geoset animation (GEOA). No geometry is removed,
    so bone/geoset references stay valid; the engine simply does not draw an invisible geoset.
Written to assets/effects/war3mapImported (installed by tools/install_project_assets.py on BUILD MAIN).

    python tools/build_light_effects_2026_11_11.py
"""
from pathlib import Path
import json
import struct
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent / 'particle_opt'))
import mdx  # noqa: E402

ROOT = Path(__file__).resolve().parents[1]
OPT = ROOT / 'assets/optimized/war3mapImported'
OUT = ROOT / 'assets/effects/war3mapImported'

# source -> (copy, emission multiplier, geosets to hide)
LIGHT = {
    # AlterSaber Q/W2/E/T trail: 11.6k faces in 5 big geosets -> keep 2 (1640 + 2296), particles x0.35
    'wos_Efect125.mdx': ('wos_Efect125_lite.mdx', 0.35, (0, 2, 3)),
    'wos_mei-qqsfx-5.mdx': ('wos_mei-qqsfx-5_lite.mdx', 0.4, ()),
    # Starrk Q ground hits (fill 15.8M): slightly lighter
    'wos_blue--zhendi31_3.mdx': ('wos_blue--zhendi31_3_lite.mdx', 0.6, ()),
    # Crocodile F side trails: same positions/frequency, lighter puff
    'wos_SandExplosion.mdx': ('wos_SandExplosion_lite.mdx', 0.6, ()),
    # Rimuru E2 / Natsu T / Natsu FR vortex: still several copies, each lighter (12.5k -> ~10.2k faces)
    'wos_firefly-r1e-sfx2.mdx': ('wos_firefly-r1e-sfx2_lite.mdx', 0.7, (2, 5)),
}


def find(map_dir, name):
    if (OPT / name).exists():
        return OPT / name
    for p in map_dir.iterdir():
        if p.name.lower() == name.lower():
            return p
    raise FileNotFoundError(name)


def chunk_list(d):
    p, out = 4, []
    while p + 8 <= len(d):
        tag = bytes(d[p:p + 4]).decode('latin1')
        size = struct.unpack_from('<I', d, p + 4)[0]
        out.append((tag, p, size))
        p += 8 + size
    return out


def geoset_count(d):
    for tag, p, size in chunk_list(d):
        if tag == 'GEOS':
            q, n = p + 8, 0
            while q < p + 8 + size:
                q += struct.unpack_from('<I', d, q)[0]
                n += 1
            return n
    return 0


def hide_geosets(d, hide):
    if not hide:
        return d
    count = geoset_count(d)
    assert all(g < count for g in hide), (hide, count)
    chunks = {t: (p, s) for t, p, s in chunk_list(d)}
    covered = set()
    if 'GEOA' in chunks:
        p, size = chunks['GEOA']
        q = p + 8
        while q < p + 8 + size:
            isz = struct.unpack_from('<I', d, q)[0]
            gid = struct.unpack_from('<I', d, q + 24)[0]
            if gid in hide:
                covered.add(gid)
                struct.pack_into('<f', d, q + 4, 0.0)  # static alpha
                t = q + 28
                while t < q + isz:  # zero every KGAO key (and its tangents)
                    tag = bytes(d[t:t + 4]).decode('latin1')
                    n, interp, _ = struct.unpack_from('<IIi', d, t + 4)
                    dim = 3 if tag == 'KGAC' else 1
                    k = t + 16
                    for _ in range(n):
                        if tag == 'KGAO':
                            for j in range(1 + (2 if interp > 1 else 0)):
                                struct.pack_into('<f', d, k + 4 + 4 * j, 0.0)
                        k += 4 + 4 * dim + (8 * dim if interp > 1 else 0)
                    t = k
            q += isz
    extra = b''.join(struct.pack('<IfI3fI', 28, 0.0, 0, 1.0, 1.0, 1.0, g) for g in sorted(set(hide) - covered))
    if not extra:
        return d
    if 'GEOA' in chunks:
        p, size = chunks['GEOA']
        end = p + 8 + size
        d = d[:end] + bytearray(extra) + d[end:]
        struct.pack_into('<I', d, p + 4, size + len(extra))
    else:
        p, size = chunks['GEOS']
        end = p + 8 + size
        d = d[:end] + bytearray(b'GEOA' + struct.pack('<I', len(extra)) + extra) + d[end:]
    return d


def scale_emission(path, d, k):
    if k == 1.0:
        return
    info, _ = mdx.analyze(str(path))
    for e in info['emitters']:
        if e['kind'] != 'PRE2':
            continue
        v = struct.unpack_from('<f', d, e['rate_off'])[0]
        struct.pack_into('<f', d, e['rate_off'], v * k)
        for fr, val, vo in e['anim'].get('KP2E', []):
            struct.pack_into('<f', d, vo, val * k)


def main():
    config = json.loads((ROOT / '.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
    map_dir = Path(config['mainMap']) / 'war3mapImported'
    OUT.mkdir(parents=True, exist_ok=True)
    for source, (target, emission, hide) in LIGHT.items():
        src = find(map_dir, source)
        d = bytearray(src.read_bytes())
        scale_emission(src, d, emission)  # offsets of the untouched layout, before GEOA grows
        d = hide_geosets(d, hide)
        (OUT / target).write_bytes(bytes(d))
        print(f'{target}: from {src.parent.parent.name}/{src.name}, emission x{emission}, hidden geosets {list(hide)}')


if __name__ == '__main__':
    main()
