"""Item-only G2 anchor without its embedded water-particle trail."""
from pathlib import Path
import json
import struct

from particle_opt.mdx import chunks, pre2

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT/'assets/effects/war3mapImported/wos_LeviathanAnchor_NoSpray.mdx'


def repair(data):
    result = bytearray(data)
    emitters = []
    for tag, offset, size in chunks(data):
        if tag == 'PRE2':
            emitters.extend(pre2(data, offset, size, 800))
    assert len(emitters) == 1 and emitters[0]['name'] == 'water'
    for emitter in emitters:
        struct.pack_into('<f', result, emitter['rate_off'], 0.)
        for _, _, offset in emitter['anim'].get('KP2E', []):
            struct.pack_into('<f', result, offset, 0.)
    return bytes(result)


def main():
    config = json.loads((ROOT/'.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
    source = Path(config['mainMap'])/'war3mapImported/wos_EF_AZ_Leviathan_G2.mdx'
    result = repair(source.read_bytes())
    assert repair(result) == result
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_bytes(result)
    print('Item anchor water trail disabled:', OUTPUT)


if __name__ == '__main__':
    main()
