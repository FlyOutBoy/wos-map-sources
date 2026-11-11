"""Install the overhead shield bar (ProgressCastingBar model from 'Desktop/red or green bar').

The model has 100 looping sequences 'Birth 1'..'Birth 100' (fill percent) and 'Death'; JASS shows a percent
with SetUnitAnimationByIndex(barUnit, pct - 1) on a locust dummy unit (tools/stage_shield_bar_unit.py).
Textures are converted TGA -> paletted BLP1 with 8-bit alpha; the fill is made grey. Paths get the wos_ prefix.

    python tools/build_shield_bar_asset.py            # build into assets/ShieldBar
    python tools/build_shield_bar_asset.py --install  # also copy into the MAIN map + war3map.imp
"""
from pathlib import Path
import argparse
import json
import shutil
import struct
from datetime import datetime

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SOURCE = Path(r'C:\Users\Gear\Desktop\red or green bar')
OUT = ROOT / 'assets/ShieldBar'
PREFIX = 'war3mapImported/'
MODEL = 'wos_shield_bar.mdx'
FILL = 'wos_shield_bar_fill.blp'
BACK = 'wos_shield_bar_back.blp'
OLD = ['war3mapImported/WOSBar/wos_shield_bar.mdx', 'war3mapImported/WOSBar/wos_shield_bar.blp']


def write_blp1_alpha(image, destination):
    """Paletted BLP1 with an 8-bit alpha plane and a full mipmap chain."""
    image = image.convert('RGBA')
    rgb = image.convert('RGB')
    quantized = rgb.quantize(colors=256, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    palette = (quantized.getpalette() + [0] * 768)[:768]
    palette_bytes = b''.join(bytes((palette[i + 2], palette[i + 1], palette[i], 0)) for i in range(0, 768, 3))
    levels, level = [], image
    while True:
        index = level.convert('RGB').quantize(palette=quantized, dither=Image.Dither.NONE).tobytes()
        alpha = level.getchannel('A').tobytes()
        levels.append(index + alpha)
        if level.size == (1, 1) or len(levels) == 16:
            break
        level = level.resize((max(1, level.width // 2), max(1, level.height // 2)), Image.Resampling.LANCZOS)
    offsets, at = [], 156 + 1024
    for data in levels:
        offsets.append(at)
        at += len(data)
    header = struct.pack('<4s6I', b'BLP1', 1, 8, image.width, image.height, 4, 1)
    header += struct.pack('<16I', *(offsets + [0] * (16 - len(offsets))))
    header += struct.pack('<16I', *([len(x) for x in levels] + [0] * (16 - len(levels))))
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_bytes(header + palette_bytes + b''.join(levels))


def grey(image):
    image = image.convert('RGBA')
    r, g, b, a = image.split()
    lum = Image.merge('RGB', (r, g, b)).convert('L').point(lambda v: min(255, int(v * 0.85 + 40)))
    return Image.merge('RGBA', (lum, lum, lum, a))


def model_bytes():
    data = bytearray((SOURCE / 'file00000143.mdx').read_bytes())
    pos = 4
    while pos < len(data):
        tag = bytes(data[pos:pos + 4])
        size = struct.unpack_from('<I', data, pos + 4)[0]
        if tag == b'TEXS':
            names = [PREFIX + FILL, PREFIX + BACK]
            assert size == 268 * len(names)
            for i, name in enumerate(names):
                raw = name.replace('/', '\\').encode('ascii')
                at = pos + 8 + i * 268 + 4
                data[at:at + 260] = raw + b'\0' * (260 - len(raw))
        pos += 8 + size
    assert pos == len(data)
    return bytes(data)


def build():
    runtime = OUT / PREFIX
    runtime.mkdir(parents=True, exist_ok=True)
    (runtime / MODEL).write_bytes(model_bytes())
    write_blp1_alpha(grey(Image.open(SOURCE / 'xuetiaobar (3).tga')), runtime / FILL)
    write_blp1_alpha(Image.open(SOURCE / 'alpha.TGA'), runtime / BACK)
    return [PREFIX + MODEL, PREFIX + FILL, PREFIX + BACK]


def read_imports(imp):
    original = imp.read_bytes()
    version, count = struct.unpack_from('<II', original)
    offset, entries = 8, []
    for _ in range(count):
        end = original.index(0, offset + 1)
        entries.append((original[offset], original[offset + 1:end]))
        offset = end + 1
    if version not in (1, 2) or offset != len(original):
        raise ValueError('Invalid war3map.imp; installation stopped')
    return version, entries


def install(map_dir, paths):
    imp = map_dir / 'war3map.imp'
    backup = ROOT / 'backups/shield-bar' / datetime.now().strftime('%Y%m%d-%H%M%S')
    backup.mkdir(parents=True)
    shutil.copy2(imp, backup / imp.name)
    version, entries = read_imports(imp)

    def norm(flag, raw):
        name = raw.decode('utf-8')
        if flag in (5, 8):
            name = 'war3mapImported\\' + name
        return name.replace('\\', '/').casefold()

    old = {p.casefold() for p in OLD}
    entries = [(f, n) for f, n in entries if norm(f, n) not in old]
    for path in OLD:
        stale = map_dir / path
        if stale.exists():
            (backup / path).parent.mkdir(parents=True, exist_ok=True)
            shutil.move(str(stale), backup / path)
    folder = map_dir / 'war3mapImported/WOSBar'
    if folder.exists() and not any(folder.iterdir()):
        folder.rmdir()
    registered = {norm(f, n) for f, n in entries}
    for path in paths:
        destination = map_dir / path
        if destination.exists():
            (backup / path).parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(destination, backup / path)
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(OUT / path, destination)
        if path.casefold() not in registered:
            entries.append((0x0d, path.replace('/', '\\').encode('utf-8')))
    imp.write_bytes(struct.pack('<II', version, len(entries)) + b''.join(bytes([f]) + n + b'\0' for f, n in entries))
    print(f'Installed {len(paths)} files; imports now {len(entries)}; backup: {backup}')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--install', action='store_true')
    args = parser.parse_args()
    built = build()
    print('\n'.join(built))
    if args.install:
        config = json.loads((ROOT / '.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
        install(Path(config['mainMap']), built)
