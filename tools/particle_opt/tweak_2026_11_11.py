"""2026-11-11 particle tweaks (shared models, written to assets/optimized; installed by every BUILD MAIN).

    wos_OP (114)        Akainu T fists:        life x0.5, size x0.7
    wos_AZ_D073red      Bambietta TE blast:    life x0.5, size x0.5
    wos_fire explosion  Ainz mine (+shared):   life x0.5, speed x1.3
Source = the current optimized copy if present, else the MAIN map copy; originals backed up first.
Idempotent via a marker file per model (re-running does not scale twice).
"""
from pathlib import Path
import json
import shutil
import struct
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
import mdx  # noqa: E402

ROOT = Path(__file__).resolve().parents[2]
OPT = ROOT / 'assets/optimized/war3mapImported'
BACKUP = ROOT / 'backups/models/20261111-particle-tweak'
TWEAKS = {
    'wos_OP (114).mdx': dict(life=0.5, size=0.7),
    'wos_AZ_D073red.mdx': dict(life=0.5, size=0.5),
    'wos_fire explosion.mdx': dict(life=0.5, speed=1.3),
}


def scale_f(d, off, k):
    v = struct.unpack_from('<f', d, off)[0]
    struct.pack_into('<f', d, off, v * k)


def main():
    config = json.loads((ROOT / '.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
    map_dir = Path(config['mainMap']) / 'war3mapImported'
    BACKUP.mkdir(parents=True, exist_ok=True)
    for name, t in TWEAKS.items():
        marker = BACKUP / (name + '.done')
        if marker.exists():
            print('skip (already tweaked):', name)
            continue
        src = OPT / name if (OPT / name).exists() else map_dir / name
        shutil.copy2(src, BACKUP / name)
        info, data = mdx.analyze(str(src))
        d = bytearray(data)
        for e in info['emitters']:
            if e['kind'] != 'PRE2':
                continue
            if 'life' in t:
                scale_f(d, e['life_off'], t['life'])
            if 'size' in t:
                for i in range(3):
                    scale_f(d, e['scale_off'] + 4 * i, t['size'])
            if 'speed' in t:
                scale_f(d, e['life_off'] - 16, t['speed'])
                for fr, val, vo in e['anim'].get('KP2S', []):
                    scale_f(d, vo, t['speed'])
        OPT.mkdir(parents=True, exist_ok=True)
        (OPT / name).write_bytes(bytes(d))
        marker.write_text('done')
        print('tweaked', name, 'from', src)
    # second pass (user request): emission x0.5 - static rate and KP2E keys
    for name in TWEAKS:
        marker = BACKUP / (name + '.emit.done')
        if marker.exists():
            print('skip emission (already halved):', name)
            continue
        path = OPT / name
        shutil.copy2(path, BACKUP / (name + '.before-emit'))
        info, data = mdx.analyze(str(path))
        d = bytearray(data)
        for e in info['emitters']:
            if e['kind'] != 'PRE2':
                continue
            scale_f(d, e['rate_off'], 0.5)
            for fr, val, vo in e['anim'].get('KP2E', []):
                scale_f(d, vo, 0.5)
        path.write_bytes(bytes(d))
        marker.write_text('done')
        print('emission x0.5', name)


if __name__ == '__main__':
    main()
