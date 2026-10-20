"""Build 64x64 item icons (BTN + DISBTN) with Button Manager borders and install them.

Sources live in assets/item_icons_src/ (anime frames, see SOURCES). Borders are the
Button Manager originals (D:/WoS Requirment/Button Manager Clear/standard): grey border
pixels shade the picture by their intensity, coloured pixels are drawn as they are -
the same rule Button Manager uses. DISBTN = greyscale picture shaded by bm_disbtn.

    python tools/build_item_icons.py            # build into assets/ReplaceableTextures
    python tools/build_item_icons.py --install  # also copy into the MAIN map + war3map.imp
"""
from pathlib import Path
import argparse
import json
import shutil
import struct
from datetime import datetime

from PIL import Image, ImageOps

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / 'assets/item_icons_src'
OUT = ROOT / 'assets'
BORDERS = Path(r'D:\WoS Requirment\Button Manager Clear\standard')
BTN_DIR = 'ReplaceableTextures/CommandButtons'
DIS_DIR = 'ReplaceableTextures/CommandButtonsDisabled'

# icon name -> (source file, crop box as fractions l, t, r, b, tint)
ICONS = {
    'Kusanagi': ('kusanagi_sword.png', (0.18, 0.00, 0.88, 0.95), None),
    'KusanagiFire': ('kusanagi_sword.png', (0.18, 0.00, 0.88, 0.95), 'fire'),
    'KusanagiWater': ('kusanagi_sword.png', (0.18, 0.00, 0.88, 0.95), 'water'),
    'KusanagiElectro': ('kusanagi_sword.png', (0.18, 0.00, 0.88, 0.95), 'electro'),
    'HashiramaCells': ('hashirama_cells.png', (0.25, 0.12, 0.75, 0.95), None),
    'ShunShunRikka': ('shun_shun_rikka.png', (0.36, 0.26, 0.84, 0.90), None),
    'AshisogiJizo': ('ashisogi_jizo.png', (0.10, 0.00, 0.90, 0.90), None),
}
SOURCES = {  # where the frames come from (fandom wikis)
    'kusanagi_sword.png': 'naruto.fandom.com File:Kusanagi_no_Tsurugi.PNG',
    'hashirama_cells.png': "naruto.fandom.com File:Hashirama's_Cells.png",
    'shun_shun_rikka.png': 'bleach.fandom.com File:Ep13OrihimesClip.png',
    'ashisogi_jizo.png': 'bleach.fandom.com File:Ashisogi_Jizo_(spirit)_Full_body_1.png',
}
TINTS = {
    'fire': ('#1a0200', '#ff4a00', '#ffe27a'),
    'water': ('#000a1c', '#1e78ff', '#d2f4ff'),
    'electro': ('#06001c', '#8a63ff', '#f2f7ff'),
}


def picture(name):
    source, (l, t, r, b), tint = ICONS[name]
    image = Image.open(SRC / source).convert('RGB')
    w, h = image.size
    image = image.crop((round(l * w), round(t * h), round(r * w), round(b * h)))
    side = min(image.size)
    image = ImageOps.fit(image, (side, side), Image.Resampling.LANCZOS)
    image = image.resize((64, 64), Image.Resampling.LANCZOS)
    if tint:
        black, mid, white = TINTS[tint]
        coloured = ImageOps.colorize(ImageOps.autocontrast(image.convert('L')), black, white, mid)
        image = Image.blend(image, coloured, 0.78)
    return image


def apply_border(image, border_name, grey=False):
    border = Image.open(BORDERS / border_name).convert('RGB')
    base = image.convert('L').convert('RGB') if grey else image
    out = Image.new('RGB', (64, 64))
    src, bd, dst = base.load(), border.load(), out.load()
    for y in range(64):
        for x in range(64):
            r, g, b = bd[x, y]
            if r == g == b:
                p = src[x, y]
                dst[x, y] = tuple(c * r // 255 for c in p)
            else:
                dst[x, y] = (r, g, b)
    return out


def write_blp1(image, destination):
    """Paletted BLP1 (256 colours, no alpha) with a full mipmap chain."""
    image = image.convert('RGB')
    quantized = image.quantize(colors=256, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.FLOYDSTEINBERG)
    palette = (quantized.getpalette() + [0] * 768)[:768]
    palette_bytes = b''.join(bytes((palette[i + 2], palette[i + 1], palette[i], 0)) for i in range(0, 768, 3))
    levels, level = [], image
    while True:
        levels.append(level.quantize(palette=quantized, dither=Image.Dither.NONE).tobytes())
        if level.size == (1, 1) or len(levels) == 16:
            break
        level = level.resize((max(1, level.width // 2), max(1, level.height // 2)), Image.Resampling.LANCZOS)
    offsets, at = [], 156 + 1024
    for data in levels:
        offsets.append(at)
        at += len(data)
    header = struct.pack('<4s6I', b'BLP1', 1, 0, image.width, image.height, 5, 1)
    header += struct.pack('<16I', *(offsets + [0] * (16 - len(offsets))))
    header += struct.pack('<16I', *([len(x) for x in levels] + [0] * (16 - len(levels))))
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_bytes(header + palette_bytes + b''.join(levels))


def build():
    built = []
    preview = Image.new('RGB', (64 * len(ICONS), 128), 'black')
    for i, name in enumerate(ICONS):
        image = picture(name)
        btn = apply_border(image, 'bm_btn.tga')
        dis = apply_border(image, 'bm_disbtn.tga', grey=True)
        for folder, prefix, art in ((BTN_DIR, 'BTN', btn), (DIS_DIR, 'DISBTN', dis)):
            path = f'{folder}/{prefix}Item_{name}.blp'
            write_blp1(art, OUT / path)
            built.append(path)
        preview.paste(btn, (64 * i, 0))
        preview.paste(dis, (64 * i, 64))
    preview.save(OUT / 'item_icons_src/preview.png')
    return built


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
        raise ValueError('Invalid war3map.imp; icon installation stopped')
    backup = ROOT / 'backups/item-icons' / datetime.now().strftime('%Y%m%d-%H%M%S')
    backup.mkdir(parents=True)
    shutil.copy2(imp, backup / imp.name)
    additions = [p for p in paths if p.casefold() not in registered]
    for path in paths:
        destination = map_dir / path
        if destination.exists():
            saved = backup / path
            saved.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(destination, saved)
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(OUT / path, destination)
    if additions:
        imp.write_bytes(struct.pack('<II', version, count + len(additions)) + original[8:] +
                        b''.join(b'\x0d' + p.replace('/', '\\').encode('utf-8') + b'\0' for p in additions))
    print(f'Installed {len(paths)} icons ({len(additions)} new imports); backup: {backup}')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--install', action='store_true')
    args = parser.parse_args()
    paths = build()
    print('\n'.join(paths))
    if args.install:
        config = json.loads((ROOT / '.vscode/wos-build.json').read_text(encoding='utf-8'))
        install(Path(config['mainMap']), paths)
