"""Checkpoint 22 texture set (pure Python, see raster.py / png_tga.py).

Graphite + antique-gold palette of checkpoints 20/21.  User supplied art:
  C:/Users/Gear/Desktop/Новая папка (13)/Pick_*.png  -> pick-logo-*.tga
  .../discord icon.png                              -> discord.tga
Run:  python tools/build_wos_ui_textures_cp22.py [source_dir]
"""
from pathlib import Path
import math
import sys

import png_tga
from raster import (Canvas, box, circle, diagonal, intersect, lerp, offset, polygon, radial, ring,
                    sector, segment, subtract, union, vertical)

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'assets/UI/WOS'
SOURCE = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(r'C:/Users/Gear/Desktop/Новая папка (16)')
# Discord art stayed in the earlier folder.
DISCORD_SOURCE = Path(r'C:/Users/Gear/Desktop/Новая папка (13)')

GOLD = (213, 184, 118)
GOLD_BRIGHT = (248, 226, 166)
GOLD_DARK = (112, 84, 40)
INK = (8, 9, 12)
GRAPHITE = (24, 27, 33)
GRAPHITE_LIGHT = (46, 50, 58)

LOGOS = {
    'pick-logo-gacha': ('Pick_Gacha.png', 'Pick_Genshin or Gacha.png'),
    'pick-logo-bleach': 'Pick_Bleach.png',
    'pick-logo-fairytail': 'Pick_FairyTail.png',
    'pick-logo-onepiece': 'Pick_OnePiece.png',
    'pick-logo-jujutsu': ('Pick_Jujutsu.png', 'Pick_JujutsuKaisen.png'),
    'pick-logo-other': 'Pick_OtherAnime.png',
}

NAMES = [
    'icon-frame', 'icon-frame-ban', 'ban-slash', 'price-plate', 'wheel-base', 'wheel-ring',
    'ping-move', 'ping-attack', 'ping-danger', 'ping-help', 'ping-rally',
    'glyph-menu', 'glyph-stats', 'glyph-link', 'glyph-music', 'glyph-expand', 'glyph-collapse',
    'glyph-voice', 'glyph-keyboard', 'glyph-crown', 'toggle-on', 'toggle-off', 'flourish-l',
    'flourish-r', 'discord', 'glyph-allycolor',
] + list(LOGOS)


def save(canvas_or_image, name):
    image = canvas_or_image.image() if isinstance(canvas_or_image, Canvas) else canvas_or_image
    png_tga.write_tga(image, OUT / f'{name}.tga')


def gold_paint(size):
    """Bright top-left to dark bottom-right metal."""
    return lambda x, y: lerp(GOLD_BRIGHT, GOLD_DARK, (x + y) / (2 * size) * 1.15 - 0.05)


def glyph(shape_fn, name, size=64, shadow=True):
    """Gold glyph with a soft dark outline for readability on graphite."""
    c = Canvas(size, size)
    shape = shape_fn(size)
    if shadow:
        c.fill(offset(shape, size * 0.045), INK, alpha=0.75, feather=2.0)
    c.fill(shape, gold_paint(size))
    save(c, name)


# ---- icon frames ---------------------------------------------------------
def icon_frame(name, accent=None):
    n = 128
    c = Canvas(n, n)
    outer = box(n / 2, n / 2, n / 2, n / 2)
    band = subtract(outer, box(n / 2, n / 2, n / 2 - 11, n / 2 - 11))
    c.fill(band, INK)
    metal = subtract(box(n / 2, n / 2, n / 2 - 1.5, n / 2 - 1.5), box(n / 2, n / 2, n / 2 - 9.5, n / 2 - 9.5))
    hi, lo = (GOLD_BRIGHT, GOLD_DARK) if accent is None else accent
    c.fill(metal, lambda x, y: lerp(hi, lo, (x + y) / (2 * n) * 1.2 - 0.1))
    # centre bevel line of the band
    c.fill(subtract(box(n / 2, n / 2, n / 2 - 5, n / 2 - 5), box(n / 2, n / 2, n / 2 - 6, n / 2 - 6)),
           lerp(lo, INK, 0.35), alpha=0.65)
    # inner shadow over the icon edge
    for k, a in ((0, 0.55), (1, 0.30), (2, 0.14)):
        edge = subtract(box(n / 2, n / 2, n / 2 - 11 - k, n / 2 - 11 - k), box(n / 2, n / 2, n / 2 - 12 - k, n / 2 - 12 - k))
        c.fill(edge, INK, alpha=a)
    # corner rivets
    for cx in (6, n - 6):
        for cy in (6, n - 6):
            c.fill(circle(cx, cy, 3.4), INK)
            c.fill(circle(cx, cy, 2.4), hi)
    save(c, name)


def ban_slash():
    n = 64
    c = Canvas(n, n)
    c.fill(segment(10, 54, 54, 10, 5.5), INK, alpha=0.7)
    c.fill(segment(10, 54, 54, 10, 3.6), lambda x, y: lerp((255, 110, 90), (150, 20, 20), (x + y) / 128))
    c.fill(ring(32, 32, 22, 3.6), INK, alpha=0.7)
    c.fill(ring(32, 32, 22, 2.2), (200, 40, 36))
    save(c, 'ban-slash')


def price_plate():
    w, h = 64, 24
    c = Canvas(w, h)
    c.fill(box(w / 2, h / 2, w / 2 - 1, h / 2 - 1, 9), (4, 5, 7), alpha=0.68, feather=1.6)
    c.fill(box(w / 2, h / 2 - 7, w / 2 - 8, 1.0, 1.0), (255, 255, 255), alpha=0.06)
    save(c, 'price-plate')


# ---- wheels ---------------------------------------------------------------
def wheel(name, spokes):
    """Clean wheel: radial graphite (no concentric rings), double gold rim,
    sector separators that fade toward the hub, gem notches on the rim."""
    n = 256
    c = Canvas(n, n)
    cx = cy = n / 2
    R = 0.47 * n
    H = 0.13 * n
    c.fill(circle(cx, cy, R + 4), INK, alpha=0.85)
    c.fill(circle(cx, cy, R), radial((42, 46, 54), (14, 16, 20), cx, cy, R), alpha=0.94)
    # soft inner vignette toward the rim
    c.fill(ring(cx, cy, R - 6, 6), INK, alpha=0.25, feather=6)
    c.fill(ring(cx, cy, R + 0.5, 2.4), gold_paint(n))
    c.fill(ring(cx, cy, R - 5.5, 0.9), GOLD_DARK, alpha=0.9)
    for k in range(spokes):
        a = math.radians(90 + 36 - k * 72)
        x1, y1 = cx + (H + 6) * math.cos(a), cy - (H + 6) * math.sin(a)
        x2, y2 = cx + (R - 6) * math.cos(a), cy - (R - 6) * math.sin(a)
        c.fill(segment(x1, y1, x2, y2, 1.6), INK, alpha=0.6)
        c.fill(segment(x1, y1, x2, y2, 0.8),
               lambda x, y: GOLD, alpha=lambda x, y: min(1.0, 0.25 + math.hypot(x - cx, y - cy) / R))
        gx, gy = cx + R * math.cos(a), cy - R * math.sin(a)
        c.fill(polygon([(gx + 6 * math.cos(a), gy - 6 * math.sin(a)), (gx + 4 * math.cos(a + 1.57), gy - 4 * math.sin(a + 1.57)),
                        (gx - 6 * math.cos(a), gy + 6 * math.sin(a)), (gx + 4 * math.cos(a - 1.57), gy - 4 * math.sin(a - 1.57))]),
               GOLD_BRIGHT)
    if spokes == 0:
        # emote wheel: four small compass gems instead of rings
        for k in range(4):
            a = math.radians(45 + k * 90)
            gx, gy = cx + R * math.cos(a), cy - R * math.sin(a)
            c.fill(circle(gx, gy, 3.6), INK)
            c.fill(circle(gx, gy, 2.6), GOLD_BRIGHT)
    c.fill(circle(cx, cy, H + 4), INK, alpha=0.9)
    c.fill(ring(cx, cy, H + 1.5, 2.2), gold_paint(n))
    c.fill(circle(cx, cy, H - 1), radial((20, 22, 27), (6, 7, 9), cx, cy, H))
    save(c, name)


ACCENTS = {'move': (90, 196, 236), 'attack': (236, 112, 74), 'danger': (238, 198, 76),
           'help': (116, 222, 146), 'rally': (180, 150, 242)}


def ping_sector(index, kind):
    n = 256
    c = Canvas(n, n)
    cx = cy = n / 2
    R = 0.47 * n - 7
    H = 0.13 * n + 5
    mid = 90 - index * 72
    accent = ACCENTS[kind]
    tint = lerp(GOLD, accent, 0.55)
    wedge = intersect(sector(cx, cy, mid - 35, mid + 35), subtract(circle(cx, cy, R), circle(cx, cy, H)))
    c.fill(wedge, lambda x, y: lerp(lerp(accent, INK, 0.78), lerp(accent, INK, 0.5),
                                    (math.hypot(x - cx, y - cy) - H) / (R - H)), alpha=0.55)
    c.fill(intersect(sector(cx, cy, mid - 33, mid + 33), ring(cx, cy, R - 2, 2.2)), tint)
    gx = cx + 0.63 * R * math.cos(math.radians(mid))
    gy = cy - 0.63 * R * math.sin(math.radians(mid))
    s = 3.0

    def P(seq):
        return [(gx + x * s, gy + y * s) for x, y in seq]

    if kind == 'move':
        shape = union(polygon(P([(-8, -7), (-3, -7), (3, 0), (-3, 7), (-8, 7), (-2, 0)])),
                      polygon(P([(0, -7), (5, -7), (11, 0), (5, 7), (0, 7), (6, 0)])))
    elif kind == 'attack':
        # crossed swords
        blade1 = segment(gx - 8 * s, gy - 8 * s, gx + 6 * s, gy + 6 * s, 1.4 * s)
        blade2 = segment(gx + 8 * s, gy - 8 * s, gx - 6 * s, gy + 6 * s, 1.4 * s)
        guard1 = segment(gx + 3 * s, gy + 7 * s, gx + 7 * s, gy + 3 * s, 1.2 * s)
        guard2 = segment(gx - 3 * s, gy + 7 * s, gx - 7 * s, gy + 3 * s, 1.2 * s)
        hilt1 = segment(gx + 6 * s, gy + 6 * s, gx + 9 * s, gy + 9 * s, 1.1 * s)
        hilt2 = segment(gx - 6 * s, gy + 6 * s, gx - 9 * s, gy + 9 * s, 1.1 * s)
        shape = union(blade1, blade2, guard1, guard2, hilt1, hilt2)
    elif kind == 'danger':
        tri = offset(polygon(P([(0, -9), (9.5, 7.5), (-9.5, 7.5)])), 1.5)
        mark = union(segment(gx, gy - 3.6 * s, gx, gy + 1.6 * s, 1.3 * s), circle(gx, gy + 4.6 * s, 1.4 * s))
        shape = subtract(tri, mark)
    elif kind == 'help':
        shape = union(box(gx, gy, 2.2 * s, 8 * s, 1.0 * s), box(gx, gy, 8 * s, 2.2 * s, 1.0 * s))
    else:
        pole = box(gx - 4 * s, gy + 0.5 * s, 1.1 * s, 9 * s, 0.6 * s)
        flag = polygon(P([(-3, -8.5), (8, -5.5), (-3, -1.5)]))
        shape = union(pole, flag)
    c.fill(offset(shape, 3.0), INK, alpha=0.8, feather=2.0)
    c.fill(shape, lambda x, y: lerp(lerp(tint, (255, 255, 255), 0.35), lerp(tint, INK, 0.25), (y - gy + 20) / 40))
    save(c, f'ping-{kind}')


# ---- glyphs ---------------------------------------------------------------
def build_glyphs():
    glyph(lambda n: union(box(32, 19, 17, 3.2, 2), box(32, 32, 17, 3.2, 2), box(32, 45, 17, 3.2, 2)), 'glyph-menu')
    glyph(lambda n: union(box(17, 45, 4, 9, 1), box(28, 40, 4, 14, 1), box(39, 35, 4, 19, 1), box(50, 29, 4, 25, 1),
                          box(32, 56.5, 24, 1.8, 1)), 'glyph-stats')
    glyph(lambda n: union(subtract(box(24, 38, 13, 7.5, 7.5), box(24, 38, 8.6, 3.1, 3.1)),
                          subtract(box(40, 26, 13, 7.5, 7.5), box(40, 26, 8.6, 3.1, 3.1)),
                          segment(26, 34, 38, 30, 2.6)), 'glyph-link')
    glyph(lambda n: union(circle(21, 47, 7.5), circle(45, 42, 7.5), box(27, 31, 2.2, 16, 1), box(51, 26, 2.2, 16, 1),
                          polygon([(25, 15), (53, 9), (53, 17), (25, 23)])), 'glyph-music')
    glyph(lambda n: union(polygon([(10, 10), (28, 10), (22, 16), (30, 24), (24, 30), (16, 22), (10, 28)]),
                          polygon([(54, 54), (36, 54), (42, 48), (34, 40), (40, 34), (48, 42), (54, 36)])), 'glyph-expand')
    glyph(lambda n: union(polygon([(30, 30), (12, 30), (18, 24), (8, 14), (14, 8), (24, 18), (30, 12)]),
                          polygon([(34, 34), (52, 34), (46, 40), (56, 50), (50, 56), (40, 46), (34, 52)])), 'glyph-collapse')
    glyph(lambda n: union(polygon([(10, 24), (20, 24), (32, 13), (32, 51), (20, 40), (10, 40)]),
                          subtract(ring(32, 32, 13, 2.6), box(18, 32, 18, 32)),
                          subtract(ring(32, 32, 21, 2.6), box(18, 32, 18, 32))), 'glyph-voice')

    def keyboard(n):
        body = subtract(box(32, 34, 26, 16, 4), box(32, 34, 22.5, 12.5, 2))
        keys = [box(16 + 8 * i, 28, 2.6, 2.6, 0.8) for i in range(5)]
        keys += [box(20 + 8 * i, 35, 2.6, 2.6, 0.8) for i in range(4)]
        keys.append(box(32, 42, 12, 2.4, 0.8))
        return union(body, *keys)
    glyph(keyboard, 'glyph-keyboard')
    glyph(lambda n: union(polygon([(10, 48), (8, 18), (21, 32), (32, 12), (43, 32), (56, 18), (54, 48)]),
                          box(32, 53, 22, 3, 1.5)), 'glyph-crown')


def ally_color():
    """Ally colours (Alt+A): three team-coloured gems inside a gold ring."""
    n = 64
    c = Canvas(n, n)
    c.fill(ring(32, 32, 26, 3.6), INK, alpha=0.8)
    c.fill(ring(32, 32, 26, 2.4), gold_paint(n))
    for (cx, cy), color in (((32, 18), (232, 72, 60)), ((20, 40), (70, 200, 220)), ((44, 40), (240, 210, 90))):
        c.fill(circle(cx, cy, 8.6), INK, alpha=0.85)
        c.fill(circle(cx, cy, 7.0), lambda x, y, col=color: lerp(lerp(col, (255, 255, 255), 0.35), lerp(col, INK, 0.3), (y - cy + 7) / 14))
    save(c, 'glyph-allycolor')


def toggles():
    w, h = 64, 32
    for name, on in (('toggle-on', True), ('toggle-off', False)):
        c = Canvas(w, h)
        c.fill(box(w / 2, h / 2, w / 2 - 1, h / 2 - 1, h / 2 - 1), INK)
        track = (lambda x, y: lerp((96, 74, 34), (176, 146, 84), (y - 4) / 24)) if on else \
            (lambda x, y: lerp((22, 24, 29), (40, 43, 50), (y - 4) / 24))
        c.fill(box(w / 2, h / 2, w / 2 - 3, h / 2 - 3, h / 2 - 3), track)
        kx = w - h / 2 if on else h / 2
        c.fill(circle(kx, h / 2, 11.5), INK, alpha=0.8)
        c.fill(circle(kx, h / 2, 10), lambda x, y: lerp(GOLD_BRIGHT, GOLD_DARK, (y - 6) / 20) if on
               else lerp((150, 152, 158), (70, 72, 78), (y - 6) / 20))
        save(c, name)


def flourishes():
    w, h = 96, 16
    for name, mirror in (('flourish-l', False), ('flourish-r', True)):
        c = Canvas(w, h)

        def X(x):
            return w - x if mirror else x
        line = polygon([(X(2), 8), (X(78), 6.6), (X(78), 9.4)])
        gem = polygon([(X(78), 8), (X(85), 3), (X(92), 8), (X(85), 13)])
        c.fill(offset(union(line, gem), 1.4), INK, alpha=0.7)
        c.fill(line, lambda x, y: lerp(GOLD_DARK, GOLD_BRIGHT, (X(x)) / 80))
        c.fill(gem, gold_paint(w))
        save(c, name)


# ---- user art ---------------------------------------------------------------
def logos():
    for name, file in LOGOS.items():
        files = file if isinstance(file, tuple) else (file,)
        path = next((SOURCE / f for f in files if (SOURCE / f).is_file()), SOURCE / files[0])
        if not path.is_file():
            print(f'skip {name}: {path} missing')
            continue
        image = png_tga.read_png(path)
        image = png_tga.crop(image, png_tga.alpha_bbox(image, 12))
        w, h = image[0], image[1]
        # Fit into a 4:1 canvas (button is .151 x .040 wide => ~3.8:1).
        if w / h > 4:
            canvas = (w, math.ceil(w / 4))
        else:
            canvas = (math.ceil(h * 4), h)
        image = png_tga.pad(image, *canvas)
        save(png_tga.resize(image, 512, 128), name)
        print('logo', name, w, h)


def discord():
    path = DISCORD_SOURCE / 'discord icon.png'
    if not path.is_file():
        print('skip discord: missing')
        return
    w, h, rows = png_tga.read_png(path)
    # The source is RGB: mask everything outside the gold rim's circle.
    cx, cy, r = w / 2, h / 2, w * 0.497
    for y, line in enumerate(rows):
        for x in range(w):
            d = math.hypot(x + 0.5 - cx, y + 0.5 - cy) - r
            a = 0 if d >= 1.5 else 255 if d <= -1.5 else round(255 * (1.5 - d) / 3)
            line[x * 4 + 3] = a
    save(png_tga.resize((w, h, rows), 128, 128), 'discord')


def build():
    OUT.mkdir(parents=True, exist_ok=True)
    icon_frame('icon-frame')
    icon_frame('icon-frame-ban', ((236, 120, 104), (96, 22, 20)))
    ban_slash()
    price_plate()
    wheel('wheel-base', 5)
    wheel('wheel-ring', 0)
    for index, kind in enumerate(('move', 'attack', 'danger', 'help', 'rally')):
        ping_sector(index, kind)
    build_glyphs()
    toggles()
    ally_color()
    flourishes()
    discord()
    logos()


if __name__ == '__main__':
    build()
