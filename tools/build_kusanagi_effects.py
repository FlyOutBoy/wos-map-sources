"""Kusanagi effects: coloured copies of the slash model and of the chest aura.

Slash: wos_BrightBlueSlash.mdx (blue, used for the Water grade) -> white / fire / electro copies
with recoloured textures (BLP1 JPEG + alpha). Aura: wos_aurafbred.mdx (Okarun F particle glow)
-> four copies with recoloured particle segment colours (white / fire / water / electro).

    python tools/build_kusanagi_effects.py            # build into assets/effects/war3mapImported
    python tools/build_kusanagi_effects.py --install  # also copy into the MAIN map + war3map.imp
"""
from io import BytesIO
from pathlib import Path
import argparse
import json
import shutil
import struct
from datetime import datetime

from PIL import Image, ImageChops

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'assets/effects'
IMPORTED = 'war3mapImported'
SLASH = 'wos_BrightBlueSlash.mdx'
SLASH_TEXTURES = ('wos_file00006087_0.blp', 'wos_file00006087_1.blp')
AURA = 'wos_aurafbred.mdx'
# variant -> target colour (RGB 0..1)
SLASH_VARIANTS = {'White': (1.00, 1.00, 1.00), 'Fire': (1.00, 0.42, 0.05), 'Electro': (0.68, 0.30, 1.00)}
AURA_VARIANTS = {'White': (1.00, 1.00, 1.00), 'Fire': (1.00, 0.42, 0.05),
                 'Water': (0.15, 0.55, 1.00), 'Electro': (0.68, 0.30, 1.00)}


def blp_decode(data):
    """BLP1 JPEG -> RGBA. Pillow reads the 4 components inverted; BLP stores B, G, R, A."""
    comp, alpha_bits, w, h = struct.unpack_from('<4I', data, 4)
    assert data[:4] == b'BLP1' and comp == 0, 'only BLP1 JPEG is supported'
    offsets = struct.unpack_from('<16I', data, 28)
    sizes = struct.unpack_from('<16I', data, 92)
    header_size = struct.unpack_from('<I', data, 156)[0]
    jpeg = data[160:160 + header_size] + data[offsets[0]:offsets[0] + sizes[0]]
    image = Image.open(BytesIO(jpeg))
    image.draft(image.mode, image.size)
    c, m, y, k = [ImageChops.invert(ch) for ch in image.convert('CMYK').split()]
    return Image.merge('RGBA', (y, m, c, k)), alpha_bits


def strip_app14(jpeg):
    out = bytearray(jpeg[:2])
    p = 2
    while p < len(jpeg):
        marker = jpeg[p + 1]
        if marker == 0xDA:  # start of scan: copy the rest
            out += jpeg[p:]
            break
        length = struct.unpack_from('>H', jpeg, p + 2)[0]
        if marker != 0xEE:
            out += jpeg[p:p + 2 + length]
        p += 2 + length
    return bytes(out)


def blp_encode(image, alpha_bits=8, picture_type=4, quality=92):
    image = image.convert('RGBA')
    levels, level = [], image
    while True:
        r, g, b, a = level.split()
        cmyk = Image.merge('CMYK', [ImageChops.invert(ch) for ch in (b, g, r, a)])
        buf = BytesIO()
        cmyk.save(buf, 'JPEG', quality=quality, subsampling=0)
        levels.append(strip_app14(buf.getvalue()))
        if level.size == (1, 1) or len(levels) == 16:
            break
        level = level.resize((max(1, level.width // 2), max(1, level.height // 2)), Image.Resampling.LANCZOS)
    offsets, at = [], 160
    for data in levels:
        offsets.append(at)
        at += len(data)
    header = struct.pack('<4s6I', b'BLP1', 0, alpha_bits, image.width, image.height, picture_type, 1)
    header += struct.pack('<16I', *(offsets + [0] * (16 - len(offsets))))
    header += struct.pack('<16I', *([len(x) for x in levels] + [0] * (16 - len(levels))))
    return header + struct.pack('<I', 0) + b''.join(levels)


def tint_pixel_table(target):
    return target


def recolour(image, target):
    """Keep brightness/alpha, replace the hue: whiteness + chroma * target colour."""
    r, g, b, a = image.split()
    hi = ImageChops.lighter(ImageChops.lighter(r, g), b)
    lo = ImageChops.darker(ImageChops.darker(r, g), b)
    chroma = ImageChops.subtract(hi, lo)
    channels = []
    for t in target:
        channels.append(ImageChops.add(lo, chroma.point(lambda v, t=t: int(v * t + 0.5))))
    return Image.merge('RGBA', (*channels, a))


def mdx_retexture(data, mapping):
    data = bytearray(data)
    pos = 4
    while pos < len(data):
        tag, size = struct.unpack_from('<4sI', data, pos)
        if tag == b'TEXS':
            for t in range(pos + 8, pos + 8 + size, 268):
                path = bytes(data[t + 4:t + 264]).split(b'\0')[0].decode('ascii')
                name = path.replace('\\', '/').split('/')[-1]
                if name in mapping:
                    new = (IMPORTED + '\\' + mapping[name]).encode('ascii')
                    data[t + 4:t + 264] = new.ljust(260, b'\0')
        pos += 8 + size
    return bytes(data)


def mdx_recolour_particles(data, target):
    data = bytearray(data)
    pos = 4
    while pos < len(data):
        tag, size = struct.unpack_from('<4sI', data, pos)
        if tag == b'PRE2':
            p, end = pos + 8, pos + 8 + size
            while p < end:
                incl = struct.unpack_from('<I', data, p)[0]
                node = p + 4
                q = node + struct.unpack_from('<I', data, node)[0]
                colours = q + 4 * 14
                for seg in range(3):
                    rgb = struct.unpack_from('<3f', data, colours + 12 * seg)
                    lo, hi = min(rgb), max(rgb)
                    new = [lo + (hi - lo) * t for t in target]
                    struct.pack_into('<3f', data, colours + 12 * seg, *new)
                p += incl
        pos += 8 + size
    return bytes(data)


def build(map_dir):
    src = map_dir / IMPORTED
    files = []
    out = OUT / IMPORTED
    out.mkdir(parents=True, exist_ok=True)
    for variant, target in SLASH_VARIANTS.items():
        mapping = {}
        for index, texture in enumerate(SLASH_TEXTURES):
            image, alpha_bits = blp_decode((src / texture).read_bytes())
            name = f'wos_kusanagi_slash_{variant.lower()}_{index}.blp'
            (out / name).write_bytes(blp_encode(recolour(image, target), alpha_bits))
            mapping[texture] = name
            files.append(name)
        model = f'wos_KusanagiSlash{variant}.mdx'
        (out / model).write_bytes(mdx_retexture((src / SLASH).read_bytes(), mapping))
        files.append(model)
    for variant, target in AURA_VARIANTS.items():
        model = f'wos_KusanagiAura{variant}.mdx'
        (out / model).write_bytes(mdx_recolour_particles((src / AURA).read_bytes(), target))
        files.append(model)
    return [f'{IMPORTED}/{name}' for name in files]


def install(map_dir, paths):
    imp = map_dir / 'war3map.imp'
    original = imp.read_bytes()
    version, count = struct.unpack_from('<II', original)
    offset, registered = 8, set()
    for _ in range(count):
        end = original.index(0, offset + 1)
        name = original[offset + 1:end].decode('utf-8')
        if original[offset] in (5, 8):
            name = 'war3mapImported\\' + name
        registered.add(name.replace('\\', '/').casefold())
        offset = end + 1
    if version not in (1, 2) or offset != len(original):
        raise ValueError('Invalid war3map.imp; installation stopped')
    backup = ROOT / 'backups/kusanagi-effects' / datetime.now().strftime('%Y%m%d-%H%M%S')
    backup.mkdir(parents=True)
    shutil.copy2(imp, backup / imp.name)
    additions = [p for p in paths if p.casefold() not in registered]
    for path in paths:
        destination = map_dir / path
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(OUT / path, destination)
    if additions:
        imp.write_bytes(struct.pack('<II', version, count + len(additions)) + original[8:] +
                        b''.join(b'\x0d' + p.replace('/', '\\').encode('utf-8') + b'\0' for p in additions))
    print(f'Installed {len(paths)} files ({len(additions)} new imports); backup: {backup}')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--install', action='store_true')
    args = parser.parse_args()
    config = json.loads((ROOT / '.vscode/wos-build.json').read_text(encoding='utf-8'))
    map_dir = Path(config['mainMap'])
    paths = build(map_dir)
    print('\n'.join(paths))
    if args.install:
        install(map_dir, paths)
