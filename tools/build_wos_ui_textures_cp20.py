"""Checkpoint 20 texture set: clean rails, button fills and HUD glyphs.

Every texture is generated deterministically (no external art) in the existing
graphite + antique-gold palette.  Ornate corner art stays untouched; the four
straight rails are rebuilt from the corners' own exit profiles, so rails and
corners meet without the stray crop pixels of the previous slices.

Geometry contract used by WOSUI.j (fractions of the corner square size c):
  horizontal rail centre: .293c below the top / .307c above the bottom
  vertical rail centre:   .207c inside the left / right edge
  rail texture thickness: .125c (32 of 256 px), profile centred.
"""
from pathlib import Path
import math
import random
from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'assets/UI/WOS'
S = 4  # supersampling factor for anti-aliased vector glyphs

GOLD = (213, 184, 118)
GOLD_BRIGHT = (246, 222, 160)
GOLD_DARK = (122, 92, 44)
INK = (12, 14, 18)
STEEL = (36, 40, 46)

NAMES = [
    'line-h', 'line-v', 'gem', 'fill-normal', 'fill-hover', 'fill-pressed', 'fill-selected',
    'fill-disabled', 'fill-primary', 'panel-soft', 'divider-v', 'divider-h', 'icon-attack',
    'icon-phys', 'icon-magic', 'pip-empty', 'pip-full', 'pip-ready', 'learn-glow', 'badge',
    'glyph-repick', 'glyph-swap', 'glyph-camera', 'slider-track', 'slider-thumb', 'slot-empty',
    'tab',
]


def save(image, name):
    image.save(OUT / f'{name}.tga')


def canvas(w, h):
    return Image.new('RGBA', (w * S, h * S), (0, 0, 0, 0))


def down(image, w, h):
    return image.resize((w, h), Image.Resampling.LANCZOS)


def rails():
    """Rebuild straight rails from the exact corner exit pixels."""
    tl = Image.open(OUT / 'ornate-tl.tga').convert('RGBA')
    tr = Image.open(OUT / 'ornate-tr.tga').convert('RGBA')
    bl = Image.open(OUT / 'ornate-bl.tga').convert('RGBA')
    W, H = tl.size
    col_top = [tl.getpixel((W - 1, y)) for y in range(75 - 16, 75 + 16)]
    col_bottom = [bl.getpixel((W - 1, y)) for y in range(178 - 16, 178 + 16)]
    row_left = [tl.getpixel((x, H - 1)) for x in range(53 - 16, 53 + 16)]
    row_right = [tr.getpixel((x, H - 1)) for x in range(203 - 16, 203 + 16)]
    rng = random.Random(20)

    def strip(profile, horizontal):
        length = 128
        image = Image.new('RGBA', (length, 32) if horizontal else (32, length))
        px = image.load()
        for t in range(length):
            # Subtle brushed-steel variation along the rail; gold stays constant.
            jitter = rng.uniform(-5, 5)
            for k, (r, g, b, a) in enumerate(profile):
                if max(r, g, b) < 90:
                    r, g, b = (max(0, min(255, round(c + jitter))) for c in (r, g, b))
                if horizontal:
                    px[t, k] = (r, g, b, a)
                else:
                    px[k, t] = (r, g, b, a)
        return image

    save(strip(col_top, True), 'ornate-top')
    save(strip(col_bottom, True), 'ornate-bottom')
    save(strip(row_left, False), 'ornate-left')
    save(strip(row_right, False), 'ornate-right')


def thin_lines():
    # Bevelled gold hairline, centred in an 8 px strip (4..5 opaque core).
    profile = [(0, 0, 0, 0), (14, 10, 6, 150), GOLD_DARK + (255,), GOLD_BRIGHT + (255,),
               GOLD + (255,), GOLD_DARK + (255,), (14, 10, 6, 150), (0, 0, 0, 0)]
    h = Image.new('RGBA', (64, 8))
    v = Image.new('RGBA', (8, 64))
    for t in range(64):
        for k, color in enumerate(profile):
            h.putpixel((t, k), color)
            v.putpixel((k, t), color)
    save(h, 'line-h')
    save(v, 'line-v')
    # Small faceted diamond accent used on button corners.
    img = canvas(32, 32)
    d = ImageDraw.Draw(img)
    c = 16 * S
    r = 13 * S
    d.polygon([(c, c - r), (c + r, c), (c, c + r), (c - r, c)], fill=GOLD_DARK + (255,))
    r2 = 10 * S
    d.polygon([(c, c - r2), (c + r2, c), (c, c + r2), (c - r2, c)], fill=GOLD_BRIGHT + (255,))
    d.polygon([(c, c - r2), (c + r2, c), (c, c)], fill=GOLD + (255,))
    d.polygon([(c - r2, c), (c, c + r2), (c, c)], fill=(160, 124, 62, 255))
    r3 = 4 * S
    d.polygon([(c, c - r3), (c + r3, c), (c, c + r3), (c - r3, c)], fill=(40, 30, 14, 255))
    save(down(img, 32, 32), 'gem')


def gradient(top, bottom, size=64, alpha=255, highlight=None, noise=0, seed=1):
    rng = random.Random(seed)
    image = Image.new('RGBA', (size, size))
    px = image.load()
    for y in range(size):
        f = y / (size - 1)
        base = [top[i] + (bottom[i] - top[i]) * f for i in range(3)]
        for x in range(size):
            n = rng.uniform(-noise, noise) if noise else 0
            px[x, y] = tuple(max(0, min(255, round(c + n))) for c in base) + (alpha,)
    if highlight:
        for x in range(size):
            px[x, 1] = highlight + (alpha,)
    return image


def fills():
    save(gradient((40, 45, 54), (13, 16, 21), highlight=(70, 72, 74), noise=1.5, seed=2), 'fill-normal')
    save(gradient((62, 60, 56), (24, 25, 29), highlight=(128, 110, 72), noise=1.5, seed=3), 'fill-hover')
    save(gradient((9, 11, 15), (24, 27, 33), noise=1.5, seed=4), 'fill-pressed')
    save(gradient((92, 72, 34), (32, 25, 14), highlight=(200, 166, 96), noise=1.5, seed=5), 'fill-selected')
    save(gradient((30, 32, 36), (18, 19, 22), alpha=255, noise=1, seed=6), 'fill-disabled')  # cp22: opaque, stock art must not bleed through
    save(gradient((126, 98, 46), (52, 38, 16), highlight=(240, 210, 140), noise=1.5, seed=7), 'fill-primary')
    # Folder tab: same material but a lighter top edge for drawer handles.
    save(gradient((52, 54, 60), (20, 22, 27), highlight=(150, 126, 80), noise=1.5, seed=8), 'tab')
    # Graphite with baked alpha for overlays that should not erase the world.
    graphite = Image.open(OUT / 'source/graphite.png').convert('RGBA').resize((256, 256), Image.Resampling.LANCZOS)
    graphite.putalpha(228)
    save(graphite, 'panel-soft')
    # Recessed, empty ability/item slot.
    slot = gradient((6, 8, 11), (17, 20, 25), noise=1, seed=9)
    d = ImageDraw.Draw(slot)
    d.rectangle((0, 0, 63, 63), outline=(58, 50, 36, 255), width=1)
    d.rectangle((1, 1, 62, 62), outline=(4, 5, 7, 255), width=2)
    save(slot, 'slot-empty')


def dividers():
    v = Image.new('RGBA', (8, 128))
    h = Image.new('RGBA', (128, 8))
    for t in range(128):
        fade = math.sin(math.pi * t / 127) ** 0.6
        for k, (color, a) in enumerate([((0, 0, 0), 0), ((10, 8, 5), 140), (GOLD_DARK, 255), (GOLD, 255),
                                         (GOLD_DARK, 255), ((10, 8, 5), 140), ((0, 0, 0), 0), ((0, 0, 0), 0)]):
            pixel = color + (round(a * fade),)
            v.putpixel((k, t), pixel)
            h.putpixel((t, k), pixel)
    save(v, 'divider-v')
    save(h, 'divider-h')


def glyph_canvas():
    return canvas(64, 64), None


def stroke(d, points, width, color=GOLD + (255,)):
    d.line([(x * S, y * S) for x, y in points], fill=color, width=round(width * S), joint='curve')


def icons():
    # Sword (attack)
    img = canvas(64, 64)
    d = ImageDraw.Draw(img)
    blade = [(46, 8), (54, 10), (56, 18), (26, 48), (16, 38)]
    d.polygon([(x * S, y * S) for x, y in blade], fill=GOLD_BRIGHT + (255,), outline=GOLD_DARK + (255,))
    d.line([(46 * S, 12 * S), (21 * S, 43 * S)], fill=(150, 116, 58, 255), width=2 * S)
    stroke(d, [(12, 34), (30, 52)], 6)
    stroke(d, [(20, 44), (8, 56)], 6, GOLD_DARK + (255,))
    d.ellipse((4 * S, 52 * S, 12 * S, 60 * S), fill=GOLD + (255,))
    save(down(img, 64, 64), 'icon-attack')

    def shield(color, inner, name, star=False):
        img = canvas(64, 64)
        d = ImageDraw.Draw(img)
        outer = [(32, 4), (56, 12), (54, 34), (32, 60), (10, 34), (8, 12)]
        d.polygon([(x * S, y * S) for x, y in outer], fill=GOLD_DARK + (255,))
        mid = [(32, 9), (51, 15), (49, 33), (32, 54), (15, 33), (13, 15)]
        d.polygon([(x * S, y * S) for x, y in mid], fill=color + (255,))
        hi = [(32, 9), (51, 15), (49, 33), (32, 54)]
        d.polygon([(x * S, y * S) for x, y in hi], fill=inner + (255,))
        if star:
            c = (32 * S, 30 * S)
            pts = []
            for i in range(8):
                r = (12 if i % 2 == 0 else 4) * S
                a = math.pi / 4 * i - math.pi / 2
                pts.append((c[0] + r * math.cos(a), c[1] + r * math.sin(a)))
            d.polygon(pts, fill=(235, 240, 255, 255))
        else:
            d.line([(32 * S, 14 * S), (32 * S, 48 * S)], fill=GOLD_BRIGHT + (255,), width=3 * S)
            d.line([(18 * S, 26 * S), (46 * S, 26 * S)], fill=GOLD_BRIGHT + (255,), width=3 * S)
        save(down(img, 64, 64), name)

    shield((168, 52, 46), (200, 76, 64), 'icon-phys')
    shield((44, 82, 168), (70, 120, 214), 'icon-magic', star=True)

    # Circular arrows (repick)
    img = canvas(64, 64)
    d = ImageDraw.Draw(img)
    box = (12 * S, 12 * S, 52 * S, 52 * S)
    d.arc(box, 200, 340, fill=GOLD + (255,), width=6 * S)
    d.arc(box, 20, 160, fill=GOLD + (255,), width=6 * S)
    d.polygon([(46 * S, 8 * S), (56 * S, 22 * S), (40 * S, 24 * S)], fill=GOLD_BRIGHT + (255,))
    d.polygon([(18 * S, 56 * S), (8 * S, 42 * S), (24 * S, 40 * S)], fill=GOLD_BRIGHT + (255,))
    save(down(img, 64, 64), 'glyph-repick')

    # Two opposing arrows (swap)
    img = canvas(64, 64)
    d = ImageDraw.Draw(img)
    stroke(d, [(10, 22), (46, 22)], 6)
    d.polygon([(44 * S, 12 * S), (58 * S, 22 * S), (44 * S, 32 * S)], fill=GOLD_BRIGHT + (255,))
    stroke(d, [(18, 42), (54, 42)], 6)
    d.polygon([(20 * S, 32 * S), (6 * S, 42 * S), (20 * S, 52 * S)], fill=GOLD_BRIGHT + (255,))
    save(down(img, 64, 64), 'glyph-swap')

    # Camera
    img = canvas(64, 64)
    d = ImageDraw.Draw(img)
    d.rounded_rectangle((8 * S, 20 * S, 56 * S, 52 * S), radius=6 * S, outline=GOLD + (255,), width=5 * S)
    d.rectangle((22 * S, 13 * S, 38 * S, 21 * S), fill=GOLD + (255,))
    d.ellipse((22 * S, 26 * S, 42 * S, 46 * S), outline=GOLD_BRIGHT + (255,), width=5 * S)
    d.ellipse((46 * S, 25 * S, 51 * S, 30 * S), fill=GOLD_BRIGHT + (255,))
    save(down(img, 64, 64), 'glyph-camera')


def pips():
    def pip(fill, edge, name, glow=None):
        img = canvas(32, 32)
        d = ImageDraw.Draw(img)
        if glow:
            g = Image.new('RGBA', img.size)
            ImageDraw.Draw(g).rectangle((2 * S, 2 * S, 30 * S, 30 * S), fill=glow)
            img.alpha_composite(g.filter(ImageFilter.GaussianBlur(4 * S)))
            d = ImageDraw.Draw(img)
        d.rectangle((6 * S, 6 * S, 26 * S, 26 * S), fill=edge)
        d.rectangle((9 * S, 9 * S, 23 * S, 23 * S), fill=fill)
        save(down(img, 32, 32), name)

    pip((14, 16, 20, 255), (96, 78, 46, 255), 'pip-empty')
    pip(GOLD_BRIGHT + (255,), GOLD_DARK + (255,), 'pip-full')
    pip((126, 232, 112, 255), (40, 110, 36, 255), 'pip-ready', glow=(120, 255, 110, 160))
    # Learnable strip glow (soft green-gold band).
    img = Image.new('RGBA', (128, 16))
    for x in range(128):
        fx = math.sin(math.pi * x / 127) ** 0.5
        for y in range(16):
            fy = math.sin(math.pi * y / 15) ** 1.2
            img.putpixel((x, y), (150, 232, 120, round(170 * fx * fy)))
    save(img, 'learn-glow')


def badge():
    img = canvas(96, 48)
    d = ImageDraw.Draw(img)
    outer = [(12, 2), (84, 2), (94, 24), (84, 46), (12, 46), (2, 24)]
    d.polygon([(x * S, y * S) for x, y in outer], fill=GOLD_DARK + (255,))
    inner = [(14, 6), (82, 6), (90, 24), (82, 42), (14, 42), (6, 24)]
    d.polygon([(x * S, y * S) for x, y in inner], fill=GOLD + (255,))
    core = [(16, 9), (80, 9), (86, 24), (80, 39), (16, 39), (10, 24)]
    d.polygon([(x * S, y * S) for x, y in core], fill=(20, 22, 27, 255))
    d.line([(18 * S, 11 * S), (78 * S, 11 * S)], fill=(60, 58, 54, 255), width=S)
    save(down(img, 96, 48), 'badge')


def slider():
    img = canvas(32, 256)
    d = ImageDraw.Draw(img)
    d.rounded_rectangle((9 * S, 2 * S, 23 * S, 254 * S), radius=6 * S, fill=GOLD_DARK + (255,))
    d.rounded_rectangle((11 * S, 4 * S, 21 * S, 252 * S), radius=5 * S, fill=(7, 8, 11, 255))
    d.line([(16 * S, 10 * S), (16 * S, 246 * S)], fill=(70, 62, 46, 255), width=2 * S)
    for y in range(32, 240, 32):
        d.line([(12 * S, y * S), (20 * S, y * S)], fill=(96, 80, 50, 255), width=S)
    save(down(img, 32, 256), 'slider-track')
    img = canvas(32, 32)
    d = ImageDraw.Draw(img)
    c, r = 16 * S, 14 * S
    d.polygon([(c, c - r), (c + r, c), (c, c + r), (c - r, c)], fill=GOLD_DARK + (255,))
    r = 11 * S
    d.polygon([(c, c - r), (c + r, c), (c, c + r), (c - r, c)], fill=GOLD_BRIGHT + (255,))
    d.polygon([(c, c - r), (c + r, c), (c, c)], fill=GOLD + (255,))
    r = 4 * S
    d.polygon([(c, c - r), (c + r, c), (c, c + r), (c - r, c)], fill=(34, 26, 12, 255))
    save(down(img, 32, 32), 'slider-thumb')


def build():
    rails()
    thin_lines()
    fills()
    dividers()
    icons()
    pips()
    badge()
    slider()
    print('Prepared checkpoint 20 textures:', len(NAMES), '+ 4 rebuilt rails')


if __name__ == '__main__':
    build()
