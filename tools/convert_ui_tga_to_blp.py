"""Convert interface TGA textures to BLP1 JPEG (+8-bit alpha) to shrink the map.

Same container as BLP Laboratory "BLP1 compressed" (JPEG, quality ~80, full mip chain),
encoded like tools/build_kusanagi_effects.py (B,G,R,A stored as inverted CMYK, no APP14).
Mips are resized premultiplied so transparent edges do not bleed dark halos.

Scope (UI only): assets/UI/WOS/**, assets/UI/TeamPings/*, and in the folder map
ui/WOS/**, ui/TeamPings/*. UI/WOS/empty.tga stays TGA (validated by install_wos_ui_assets.py).
For the map, war3map.imp entries and war3mapSkin.txt values are renamed .tga -> .blp.

    python tools/convert_ui_tga_to_blp.py [--map <folder map .w3x>] [--quality 80] [--dry-run]

Re-run after any generator (tools/build_wos_ui_*.py) writes fresh .tga files.
"""
from io import BytesIO
from pathlib import Path
import argparse
import re
import struct

from PIL import Image, ImageChops

ROOT = Path(__file__).resolve().parents[1]
KEEP_TGA = {'empty.tga'}
ASSET_DIRS = [ROOT / 'assets/UI/WOS', ROOT / 'assets/UI/TeamPings']
MAP_DIRS = ['ui/WOS', 'ui/TeamPings']


def strip_app14(jpeg):
    out = bytearray(jpeg[:2])
    p = 2
    while p < len(jpeg):
        marker = jpeg[p + 1]
        if marker == 0xDA:
            out += jpeg[p:]
            break
        length = struct.unpack_from('>H', jpeg, p + 2)[0]
        if marker != 0xEE:
            out += jpeg[p:p + 2 + length]
        p += 2 + length
    return bytes(out)


def blp_encode(image, quality=80):
    image = image.convert('RGBA')
    alpha_bits = 8
    levels, level = [], image
    while True:
        r, g, b, a = level.split()
        cmyk = Image.merge('CMYK', [ImageChops.invert(ch) for ch in (b, g, r, a)])
        buf = BytesIO()
        cmyk.save(buf, 'JPEG', quality=quality, subsampling=0)
        levels.append(strip_app14(buf.getvalue()))
        if level.size == (1, 1) or len(levels) == 16:
            break
        size = (max(1, level.width // 2), max(1, level.height // 2))
        level = level.convert('RGBa').resize(size, Image.Resampling.LANCZOS).convert('RGBA')
    offsets, at = [], 160
    for data in levels:
        offsets.append(at)
        at += len(data)
    header = struct.pack('<4s6I', b'BLP1', 0, alpha_bits, image.width, image.height, 4, 1)
    header += struct.pack('<16I', *(offsets + [0] * (16 - len(offsets))))
    header += struct.pack('<16I', *([len(x) for x in levels] + [0] * (16 - len(levels))))
    return header + struct.pack('<I', 0) + b''.join(levels)


def convert_tree(root, quality, dry):
    before = after = count = 0
    for tga in sorted(root.rglob('*.tga')):
        if tga.name.lower() in KEEP_TGA:
            continue
        blp = tga.with_suffix('.blp')
        data = blp_encode(Image.open(tga), quality)
        before += tga.stat().st_size
        after += len(data)
        count += 1
        if not dry:
            blp.write_bytes(data)
            tga.unlink()
    return count, before, after


def rename_imports(map_dir, dry):
    """Rename converted UI entries in war3map.imp (.tga -> .blp) when the .blp exists."""
    imp = map_dir / 'war3map.imp'
    raw = imp.read_bytes()
    version, count = struct.unpack_from('<II', raw)
    offset, out, renamed = 8, bytearray(raw[:8]), 0
    for _ in range(count):
        end = raw.index(0, offset + 1)
        flag, name = raw[offset], raw[offset + 1:end].decode('utf-8')
        low = name.replace('/', '\\').lower()
        if (low.startswith('ui\\wos\\') or low.startswith('ui\\teampings\\')) and low.endswith('.tga'):
            candidate = map_dir / (name[:-4] + '.blp').replace('\\', '/')
            if candidate.exists():
                name = name[:-4] + '.blp'
                renamed += 1
        out += bytes([flag]) + name.encode('utf-8') + b'\0'
        offset = end + 1
    if offset != len(raw):
        raise ValueError('Unrecognized war3map.imp tail')
    if not dry and renamed:
        imp.write_bytes(bytes(out))
    return renamed


TGA_REF = re.compile(r'(?i)(ui\\+(?:wos|teampings)\\+[^\s"\',=]*?)(?<!\\empty)\.tga')


def rename_skin(map_dir, dry):
    skin = map_dir / 'war3mapSkin.txt'
    if not skin.exists():
        return 0
    text = skin.read_text(encoding='utf-8-sig')
    new, n = TGA_REF.subn(r'\1.blp', text)
    if n and not dry:
        bom = skin.read_bytes().startswith(b'\xef\xbb\xbf')
        skin.write_bytes((b'\xef\xbb\xbf' if bom else b'') + new.encode('utf-8'))
    return n


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--map', type=Path)
    parser.add_argument('--quality', type=int, default=80)
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args()
    roots = list(ASSET_DIRS)
    if args.map:
        roots += [args.map / d for d in MAP_DIRS]
    for root in roots:
        if root.is_dir():
            n, b, a = convert_tree(root, args.quality, args.dry_run)
            print(f'{root}: {n} files, {b / 1048576:.2f} MB -> {a / 1048576:.2f} MB')
    if args.map:
        print('imports renamed:', rename_imports(args.map, args.dry_run))
        print('skin refs renamed:', rename_skin(args.map, args.dry_run))


if __name__ == '__main__':
    main()
