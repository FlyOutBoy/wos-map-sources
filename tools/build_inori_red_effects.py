"""Inori R (Song of Salvation): red copies of the zone / aura models.

Every texture of the copied models is replaced by a red version (`war3mapImported\\InoriRed\\*.blp`):
imported BLP textures are recoloured by brightness onto a red ramp, stock game textures
(Flare, GenericGlow*, ping4, Shockwave1White, Ghost1 - not readable outside the game CASC) are
redrawn procedurally. Each texture gets its own red shade (crimson, scarlet, blood, ruby...), so the
effects are not one flat colour. Tint colours inside the models (PRE2 segment colours, GEOA colour,
RIBB colour and their tracks) are neutralised to grey of the same brightness, so the red comes only
from the textures and is independent of the BGR/RGB order of MDX colours.

    python tools/build_inori_red_effects.py      # writes assets/effects/war3mapImported/...
The models are installed into the MAIN map by tools/install_project_assets.py on BUILD MAIN.
"""
from pathlib import Path
import json
import math
import struct
import sys

from PIL import Image

sys.path.insert(0, str(Path(__file__).resolve().parent))
from build_kusanagi_effects import blp_decode, blp_encode  # noqa: E402

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'assets/effects/war3mapImported'
OPTIMIZED = ROOT / 'assets/optimized/war3mapImported'
TEX_DIR = 'InoriRed'

# source model -> red copy (used by InoriR_KS in triggers/Heroes/Inori.j)
MODELS = {
    'wos_inori_r.mdx': 'wos_InoriRed_zone.mdx',
    'wos_Hero_FarSeer2.mdx': 'wos_InoriRed_farseer.mdx',
    'wos_BD_YEQI1.MDX': 'wos_InoriRed_yeqi1.mdx',
    'wos_LightBlueLand.mdx': 'wos_InoriRed_land.mdx',
    'wos_BD_YEQI03.MDX': 'wos_InoriRed_yeqi3.mdx',
    'wos_Void04.mdx': 'wos_InoriRed_void.mdx',
    'wos_zdgq.mdx': 'wos_InoriRed_zdgq.mdx',
    'wos_qicai-lizi-shangsheng2.mdx': 'wos_InoriRed_rise.mdx',
    'wos_FantasyBattle (1644).mdx': 'wos_InoriRed_cleanse.mdx',
}

# red shades (RGB 0..1); every texture picks its own
CRIMSON = (0.86, 0.06, 0.20)
SCARLET = (1.00, 0.16, 0.04)
BLOOD = (0.72, 0.02, 0.04)
ROSE = (1.00, 0.18, 0.32)
VERMILION = (1.00, 0.30, 0.10)
RUBY = (0.88, 0.07, 0.36)
DEEP = (0.80, 0.00, 0.00)

# imported textures: lowercase file name -> shade
IMPORTED_SHADES = {
    'wos_glowyellow_w.blp': SCARLET,
    'wos_hero_farseer_n2s_glow13.blp': CRIMSON,
    'wos_hero_farseer_n2s_star2.blp': VERMILION,
    'wos_bd_yeqi.blp': BLOOD,
    'wos_by_wood_zd1.blp': ROSE,
    'wos_by_wood_zd2.blp': DEEP,
    'wos_bd_yeqi02.blp': RUBY,
    'wos_gn1.blp': SCARLET,
    'wos_by_wood_eff_odr_fgo_int_imp_1.blp': CRIMSON,
    'wos_by_wood_effect_texture_unusual_kof_integration_glow_2.blp': VERMILION,
}

# stock textures: lowercase file name -> (procedural shape, shade)
STOCK = {
    'flare.blp': ('flare', VERMILION),
    'genericglow2b.blp': ('glow', CRIMSON),
    'genericglow2c.blp': ('glow', SCARLET),
    'genericglow64.blp': ('glow', ROSE),
    'genericglowfaded.blp': ('glow', BLOOD),
    'genericglowx.blp': ('glow', RUBY),
    'genericglowx_mod2.blp': ('glow', RUBY),
    'ping4.blp': ('ring', SCARLET),
    'shockwave1white.blp': ('shockwave', CRIMSON),
    'shockwave4white.blp': ('shockwave', DEEP),
    'ghost1.blp': ('ghost', RUBY),
    'ghost2.blp': ('ghost', CRIMSON),
    # listed in TEXS but not used by any layer/emitter of the copied models
    'smoke.blp': ('glow', BLOOD),
    'aurarune9b_128.blp': ('ring', DEEP),
    'clouds8x8.blp': ('glow', CRIMSON),
}

HOT = (1.00, 0.74, 0.64)  # brightest cores lean warm-white, not flat red


def ramp(v, shade):
    """Brightness 0..1 -> red colour: dark = shade * v, top quarter blends towards HOT."""
    if v <= 0.75:
        return tuple(c * v for c in shade)
    t = (v - 0.75) / 0.25 * 0.55
    return tuple((c * v) * (1 - t) + h * t for c, h in zip(shade, HOT))


def ramp_tables(shade):
    return [[int(round(255 * ramp(i / 255.0, shade)[ch])) for i in range(256)] for ch in range(3)]


def recolour(image, shade):
    r, g, b, a = image.split()
    # brightness = max channel (keeps additive glow strength)
    value = Image.merge('RGB', (r, g, b)).convert('HSV').split()[2]
    tables = ramp_tables(shade)
    return Image.merge('RGBA', [value.point(t) for t in tables] + [a])


def procedural(shape, size=128):
    """Greyscale intensity image of a stock-like effect texture."""
    img = Image.new('L', (size, size))
    px = img.load()
    for j in range(size):
        for i in range(size):
            x = (i + 0.5) / size * 2 - 1
            y = (j + 0.5) / size * 2 - 1
            r = math.hypot(x, y)
            if shape == 'glow':
                v = max(0.0, 1 - r) ** 2
            elif shape == 'flare':
                core = math.exp(-r * 5.0)
                rays = (math.exp(-abs(x) * 28) + math.exp(-abs(y) * 28)) * max(0.0, 1 - r) * 0.55
                v = min(1.0, core + rays) * max(0.0, 1 - r) ** 0.5
            elif shape == 'ring':
                v = math.exp(-((r - 0.78) / 0.07) ** 2) + 0.18 * max(0.0, 1 - r)
            elif shape == 'shockwave':
                v = math.exp(-((r - 0.86) / 0.08) ** 2) + 0.35 * max(0.0, min(1.0, r / 0.86)) ** 3 * (r < 0.86)
            elif shape == 'ghost':
                # ribbon strip: soft across v (y), wavy streaks along u (x)
                band = math.sin(math.pi * (y + 1) / 2) ** 2
                streak = 0.65 + 0.35 * math.sin(x * 9 + math.sin(y * 5) * 1.5)
                v = band * streak
            else:
                raise ValueError(shape)
            px[i, j] = int(max(0.0, min(1.0, v)) * 255 + 0.5)
    return img


def procedural_texture(shape, shade):
    v = procedural(shape)
    tables = ramp_tables(shade)
    return Image.merge('RGBA', [v.point(t) for t in tables] + [v])


# ---------------------------------------------------------------- MDX edits
def chunks(d):
    p = 4
    while p + 8 <= len(d):
        tag = bytes(d[p:p + 4]).decode('latin1')
        size = struct.unpack_from('<I', d, p + 4)[0]
        yield tag, p + 8, size
        p += 8 + size


def grey(d, off, count=1):
    for k in range(count):
        o = off + 12 * k
        c = struct.unpack_from('<3f', d, o)
        g = max(c)
        struct.pack_into('<3f', d, o, g, g, g)


def track_keys(d, q, color_tags):
    """Walk one animation track; grey its values when it is a colour track. Returns the end offset."""
    tag = bytes(d[q:q + 4]).decode('latin1')
    n, interp, _ = struct.unpack_from('<IIi', d, q + 4)
    # GEOA: KGAO/KGAC; RIBB (after its node): KRHA KRHB KRAL KRCO KRTX KRVS
    if tag in ('KGAC', 'KRCO'):
        dim = 3
    elif tag in ('KGAO', 'KRHA', 'KRHB', 'KRAL', 'KRTX', 'KRVS'):
        dim = 1
    else:
        raise ValueError('unexpected track ' + tag)
    p = q + 16
    for _ in range(n):
        value = p + 4
        if tag in color_tags:
            grey(d, value)
            if interp > 1:
                grey(d, value + 12, 2)
        p += 4 + 4 * dim + (8 * dim if interp > 1 else 0)
    return p


def neutralise_colours(d):
    for tag, off, size in list(chunks(d)):
        p, end = off, off + size
        if tag == 'GEOA':
            while p < end:
                isz = struct.unpack_from('<I', d, p)[0]
                grey(d, p + 12)
                q = p + 28
                while q < p + isz:
                    q = track_keys(d, q, ('KGAC',))
                p += isz
        elif tag == 'PRE2':
            while p < end:
                isz = struct.unpack_from('<I', d, p)[0]
                node = p + 4
                q = node + struct.unpack_from('<I', d, node)[0]
                grey(d, q + 56, 3)
                p += isz
        elif tag == 'RIBB':
            while p < end:
                isz = struct.unpack_from('<I', d, p)[0]
                node = p + 4
                q = node + struct.unpack_from('<I', d, node)[0]
                grey(d, q + 12)
                t = q + 52
                while t < p + isz:
                    t = track_keys(d, t, ('KRCO',))
                p += isz


def retexture(d, made):
    for tag, off, size in list(chunks(d)):
        if tag != 'TEXS':
            continue
        for t in range(off, off + size, 268):
            path = bytes(d[t + 4:t + 264]).split(b'\0')[0].decode('latin1')
            if not path:
                continue  # replaceable texture
            name = path.replace('\\', '/').split('/')[-1].lower()
            if name not in IMPORTED_SHADES and name not in STOCK:
                raise ValueError('no red version for texture ' + path)
            new_name = 'wos_inorired_' + name
            made.add(name)
            new = ('war3mapImported\\' + TEX_DIR + '\\' + new_name).encode('ascii')
            assert len(new) < 260
            d[t + 4:t + 264] = new.ljust(260, b'\0')


def main():
    config = json.loads((ROOT / '.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
    map_imported = Path(config['mainMap']) / 'war3mapImported'
    (OUT / TEX_DIR).mkdir(parents=True, exist_ok=True)
    made = set()
    written = []
    for source, target in MODELS.items():
        src = OPTIMIZED / source if (OPTIMIZED / source).exists() else map_imported / source
        d = bytearray(src.read_bytes())
        retexture(d, made)
        neutralise_colours(d)
        (OUT / target).write_bytes(bytes(d))
        written.append(target)
    lower = {p.name.lower(): p for p in map_imported.glob('*.blp')}
    for name in sorted(made):
        if name in IMPORTED_SHADES:
            image, alpha_bits = blp_decode(lower[name].read_bytes())
            data = blp_encode(recolour(image, IMPORTED_SHADES[name]), alpha_bits, quality=88)
        else:
            shape, shade = STOCK[name]
            data = blp_encode(procedural_texture(shape, shade), 8, quality=88)
        (OUT / TEX_DIR / ('wos_inorired_' + name)).write_bytes(data)
        written.append(TEX_DIR + '/wos_inorired_' + name)
    print('\n'.join(written))


if __name__ == '__main__':
    main()
