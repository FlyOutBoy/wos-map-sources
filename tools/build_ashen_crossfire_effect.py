"""Make an item-only Ashen Crossfire copy with an orange additive ribbon.

The airflow texture has opaque black pixels: Blend draws a black strip. Change
only the ribbon material's filter and its static BGR tint; preserve the shared
source model, mesh, particles, animation tracks and all texture paths.
"""
from pathlib import Path
import json
import struct

from particle_opt.mdx import chunks, node_end

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / 'assets/effects/war3mapImported/wos_AshenCrossfire.mdx'


def repair(data):
    result = bytearray(data)
    table = {tag: (off, size) for tag, off, size in chunks(data)}
    off, size = table['RIBB']
    node, _ = node_end(data, off + 4)
    assert off + struct.unpack_from('<I', data, off)[0] == off + size
    material = struct.unpack_from('<I', data, node + 44)[0]
    # MDX ribbon colors are BGR. Orange RGB = (1.0, 0.35, 0.04).
    struct.pack_into('<3f', result, node + 12, .04, .35, 1.)
    mat, _ = table['MTLS']
    for _ in range(material):
        mat += struct.unpack_from('<I', data, mat)[0]
    assert data[mat + 12:mat + 16] == b'LAYS'
    assert struct.unpack_from('<I', data, mat + 16)[0] == 1
    layer = mat + 20
    assert struct.unpack_from('<I', data, layer + 4)[0] in (2, 3)
    struct.pack_into('<I', result, layer + 4, 3)  # Additive: black is transparent.
    assert len(result) == len(data)
    return bytes(result)


def main():
    config = json.loads((ROOT / '.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
    source = Path(config['mainMap']) / 'war3mapImported/wos_file00001323.mdx'
    result = repair(source.read_bytes())
    assert repair(result) == result
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_bytes(result)
    print('Ashen Crossfire ribbon repaired:', OUTPUT)


if __name__ == '__main__':
    main()
