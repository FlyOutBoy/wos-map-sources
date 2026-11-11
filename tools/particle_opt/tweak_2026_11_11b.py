"""2026-11-11 (3), written to assets/optimized (installed by every BUILD MAIN).

wos_OP (114)        Akainu T fist: cloud column (geometry) lives 1 s less - Stand 1000-3100 -> 1000-2100,
                    geoset alpha fade key 3100 -> 2100; geoset alpha 1.0 -> 0.5 (50% transparent).
wos_opbr0326 (347)  Akainu Q fire explosion (also W / T fist landing): PRE2 life -0.5 s where life > 0.5.
Originals -> backups/models/20261111-akainu-b. Idempotent via marker files.
"""
from pathlib import Path
import shutil
import struct
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
import mdx  # noqa: E402

ROOT = Path(__file__).resolve().parents[2]
OPT = ROOT / 'assets/optimized/war3mapImported'
BACKUP = ROOT / 'backups/models/20261111-akainu-b'


def fist(d):
    # SEQS 'Stand' end 3100 -> 2100
    for tag, off, size in mdx.chunks(d):
        if tag == 'SEQS':
            for i in range(size // 132):
                b = off + i * 132
                name = bytes(d[b:b + 80]).split(b'\0')[0]
                s, e = struct.unpack_from('<II', d, b + 80)
                if name == b'Stand' and (s, e) == (1000, 3100):
                    struct.pack_into('<I', d, b + 84, 2100)
                    print('Stand -> 1000..2100')
    i = d.find(b'KGAO')
    cnt, it, gid = struct.unpack_from('<iii', d, i + 4)
    assert cnt == 2 and it == 1, (cnt, it)
    k0, k1 = i + 16, i + 24
    assert struct.unpack_from('<i', d, k1)[0] == 3100
    struct.pack_into('<f', d, k0 + 4, 0.5)
    struct.pack_into('<i', d, k1, 2100)
    print('KGAO 1.0@1000 -> 0.5@1000, 0@3100 -> 0@2100')


def main():
    BACKUP.mkdir(parents=True, exist_ok=True)
    name = 'wos_OP (114).mdx'
    if not (BACKUP / (name + '.done')).exists():
        shutil.copy2(OPT / name, BACKUP / name)
        d = bytearray((OPT / name).read_bytes())
        fist(d)
        (OPT / name).write_bytes(bytes(d))
        (BACKUP / (name + '.done')).write_text('done')
    name = 'wos_opbr0326 (347).mdx'
    if not (BACKUP / (name + '.done')).exists():
        shutil.copy2(OPT / name, BACKUP / name)
        info, data = mdx.analyze(str(OPT / name))
        d = bytearray(data)
        for e in info['emitters']:
            if e['kind'] == 'PRE2' and e['life'] > 0.5:
                struct.pack_into('<f', d, e['life_off'], e['life'] - 0.5)
                print('life %.2f -> %.2f' % (e['life'], e['life'] - 0.5))
        (OPT / name).write_bytes(bytes(d))
        (BACKUP / (name + '.done')).write_text('done')


if __name__ == '__main__':
    main()
