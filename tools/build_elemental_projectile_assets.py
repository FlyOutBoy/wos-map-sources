"""Install user-supplied projectile assets into project assets, preserving originals.

Usage: python tools/build_elemental_projectile_assets.py --source-directory <folder>
Shared map paths are stable; no personal source directory is persisted.
Only the axe's blue effect textures are recolored; its diffuse axe texture is kept.
"""
from pathlib import Path
import argparse
import shutil
import struct

from build_kusanagi_effects import blp_decode, blp_encode, recolour, mdx_retexture
from particle_opt.mdx import chunks, texs, node_end, track

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'assets/effects/war3mapImported'
MODELS = ('wos_file00012198.mdx', 'wos_tx28.mdx', 'wos_mx-yx-tsw-a-1.mdx')
AXE_TEXTURES = {
    'wos_MX-YX-TSW-A-1-2.blp': 'wos_MX-YX-TSW-A-1-2_fire.blp',
    'wos_MX-YX-TSW-A-1-3.blp': 'wos_MX-YX-TSW-A-1-3_fire.blp',
}
AXE_RIBBON_BGR = (.025, .28, 1.)


def recolour_axe_ribbons(data):
    result = bytearray(data)
    for tag, offset, size in chunks(data):
        if tag != 'RIBB':
            continue
        end = offset + size
        while offset < end:
            emitter_end = offset + struct.unpack_from('<I', data, offset)[0]
            node, _ = node_end(data, offset + 4)
            struct.pack_into('<3f', result, node + 12, *AXE_RIBBON_BGR)
            animation = node + 52
            while animation < emitter_end:
                tag, keys, interpolation, _, animation = track(data, animation)
                if tag == 'KRCO':
                    for _, value in keys:
                        struct.pack_into('<3f', result, value, *AXE_RIBBON_BGR)
                        if interpolation > 1:
                            tangent = (0., 0., 0.) if interpolation == 2 else AXE_RIBBON_BGR
                            struct.pack_into('<6f', result, value + 12, *tangent, *tangent)
            offset = emitter_end
    return bytes(result)


def build(source):
    OUT.mkdir(parents=True, exist_ok=True)
    for name in MODELS:
        data = (source / name).read_bytes()
        for tag, offset, size in chunks(data):
            if tag != 'TEXS':
                continue
            for _, texture in texs(data, offset, size):
                if not texture.lower().startswith('war3mapimported\\'):
                    continue
                texture_name = texture.replace('\\', '/').split('/')[-1]
                path = source / 'war3mapImported' / texture_name
                if texture_name in AXE_TEXTURES:
                    image, alpha = blp_decode(path.read_bytes())
                    picture_type = struct.unpack_from('<I', path.read_bytes(), 20)[0]
                    output = recolour(image, (1., .28, .025))
                    (OUT / AXE_TEXTURES[texture_name]).write_bytes(blp_encode(output, alpha, picture_type))
                else:
                    shutil.copy2(path, OUT / texture_name)
        if name == 'wos_mx-yx-tsw-a-1.mdx':
            data = recolour_axe_ribbons(mdx_retexture(data, AXE_TEXTURES))
            name = 'wos_mx-yx-tsw-a-1_fire.mdx'
        (OUT / name).write_bytes(data)
    print('Projectile models and required textures prepared:', OUT)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source-directory', type=Path, required=True)
    build(parser.parse_args().source_directory)
