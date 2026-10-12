"""Checkpoint 21 texture set: stat medallions, attack types, wheels and controls.

Generated deterministically in the same graphite + antique-gold palette as
checkpoint 20 (see build_wos_ui_textures_cp20.py).  No external art is used.
"""
from pathlib import Path
import math
from PIL import Image, ImageDraw, ImageFilter

from build_wos_ui_textures_cp20 import (OUT, S, GOLD, GOLD_BRIGHT, GOLD_DARK, canvas, down, save,
                                        gradient)

NAMES = [
    'stat-str', 'stat-agi', 'stat-int', 'stat-underline', 'attack-melee', 'attack-ranged',
    'hover-glow', 'field', 'glyph-close', 'glyph-swap-off', 'glyph-repick-off', 'glow-gold',
    'shine', 'keycap', 'wheel-base', 'wheel-ring', 'ping-move', 'ping-attack',
    'ping-danger', 'ping-help', 'ping-rally',
]

GRAPHITE = (24, 27, 33)
GRAPHITE_LIGHT = (44, 48, 56)


def P(points):
    return [(x * S, y * S) for x, y in points]


def medallion(inner, glyph, name):
    """Round gold-rimmed medallion with a coloured core and a light glyph."""
    img = canvas(64, 64)
    d = ImageDraw.Draw(img)
    d.ellipse((2 * S, 2 * S, 62 * S, 62 * S), fill=GOLD_DARK + (255,))
    d.ellipse((5 * S, 5 * S, 59 * S, 59 * S), fill=GOLD + (255,))
    d.ellipse((8 * S, 8 * S, 56 * S, 56 * S), fill=tuple(max(0, c - 40) for c in inner) + (255,))
    d.ellipse((10 * S, 10 * S, 54 * S, 54 * S), fill=inner + (255,))
    # Soft top highlight on the core.
    d.chord((12 * S, 10 * S, 52 * S, 40 * S), 200, 340, fill=tuple(min(255, c + 30) for c in inner) + (255,))
    glyph(d)
    save(down(img, 64, 64), name)


def stat_icons():
    light = (250, 236, 200, 255)

    def hammer(d):  # strength: war hammer
        d.polygon(P([(19, 18), (45, 18), (45, 31), (19, 31)]), fill=light)
        d.polygon(P([(19, 18), (45, 18), (45, 22), (19, 22)]), fill=(255, 250, 230, 255))
        d.polygon(P([(29, 31), (35, 31), (35, 50), (29, 50)]), fill=light)
        d.ellipse((28 * S, 48 * S, 36 * S, 54 * S), fill=light)

    def chevrons(d):  # agility: swift chevrons
        for dx in (0, 9, 18):
            d.polygon(P([(15 + dx, 19), (22 + dx, 19), (31 + dx, 32), (22 + dx, 45), (15 + dx, 45), (24 + dx, 32)]),
                      fill=light)

    def eye(d):  # intelligence: arcane eye
        d.polygon(P([(12, 32), (22, 22), (32, 19), (42, 22), (52, 32), (42, 42), (32, 45), (22, 42)]), fill=light)
        d.ellipse((24 * S, 24 * S, 40 * S, 40 * S), fill=(40, 70, 150, 255))
        d.ellipse((28 * S, 28 * S, 36 * S, 36 * S), fill=(12, 16, 30, 255))
        d.ellipse((29 * S, 27 * S, 32 * S, 30 * S), fill=(255, 255, 255, 255))

    medallion((168, 50, 44), hammer, 'stat-str')
    medallion((58, 138, 56), chevrons, 'stat-agi')
    medallion((44, 82, 168), eye, 'stat-int')


def underline():
    """Gold underline inside a charcoal glow (primary attribute marker)."""
    w, h = 128, 16
    glow = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    ImageDraw.Draw(glow).rounded_rectangle((6, 3, w - 7, h - 4), radius=5, fill=(6, 6, 8, 210))
    glow = glow.filter(ImageFilter.GaussianBlur(2.2))
    line = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    px = line.load()
    for x in range(w):
        fade = math.sin(math.pi * x / (w - 1)) ** 0.45
        for y, color in ((6, GOLD_DARK), (7, GOLD_BRIGHT), (8, GOLD), (9, GOLD_DARK)):
            px[x, y] = color + (round(255 * fade),)
    glow.alpha_composite(line)
    save(glow, 'stat-underline')


def framed_square(draw_glyph, name):
    img = canvas(64, 64)
    d = ImageDraw.Draw(img)
    d.rounded_rectangle((2 * S, 2 * S, 62 * S, 62 * S), radius=8 * S, fill=GOLD_DARK + (255,))
    d.rounded_rectangle((5 * S, 5 * S, 59 * S, 59 * S), radius=6 * S, fill=GRAPHITE + (255,))
    draw_glyph(d)
    save(down(img, 64, 64), name)


def attack_icons():
    def sword(d):
        d.polygon(P([(32, 8), (37, 14), (37, 40), (27, 40), (27, 14)]), fill=GOLD_BRIGHT + (255,))
        d.line(P([(32, 12), (32, 39)]), fill=GOLD_DARK + (255,), width=2 * S)
        d.rectangle((18 * S, 40 * S, 46 * S, 45 * S), fill=GOLD + (255,))
        d.rectangle((29 * S, 45 * S, 35 * S, 54 * S), fill=GOLD_DARK + (255,))
        d.ellipse((27 * S, 52 * S, 37 * S, 60 * S), fill=GOLD + (255,))

    def bow(d):
        d.arc((10 * S, 8 * S, 42 * S, 56 * S), 270, 90, fill=GOLD_BRIGHT + (255,), width=5 * S)
        d.line(P([(26, 10), (26, 54)]), fill=(220, 210, 180, 255), width=S)
        d.line(P([(14, 32), (52, 32)]), fill=GOLD + (255,), width=3 * S)
        d.polygon(P([(52, 26), (60, 32), (52, 38)]), fill=GOLD_BRIGHT + (255,))
        d.polygon(P([(14, 32), (9, 27), (12, 32), (9, 37)]), fill=GOLD_DARK + (255,))

    framed_square(sword, 'attack-melee')
    framed_square(bow, 'attack-ranged')


def controls():
    # Additive hover highlight for engine-drawn button hover (HighlightAlphaMode ADD).
    save(gradient((46, 36, 18), (12, 9, 4), size=64), 'hover-glow')
    # Inset input field: deep graphite with an inner top shadow.
    field = gradient((5, 6, 9), (15, 17, 22), size=64, noise=1, seed=21)
    d = ImageDraw.Draw(field)
    for y, a in ((0, 255), (1, 200), (2, 120)):
        d.line([(0, y), (63, y)], fill=(0, 0, 0, a))
    save(field, 'field')
    # Gold X.
    img = canvas(64, 64)
    d = ImageDraw.Draw(img)
    for color, width in ((GOLD_DARK, 12), (GOLD_BRIGHT, 7)):
        d.line(P([(16, 16), (48, 48)]), fill=color + (255,), width=width * S)
        d.line(P([(48, 16), (16, 48)]), fill=color + (255,), width=width * S)
    save(down(img, 64, 64), 'glyph-close')
    # Disabled glyphs: desaturated, dimmed copies of the gold ones.
    for src, dst in (('glyph-swap', 'glyph-swap-off'), ('glyph-repick', 'glyph-repick-off')):
        image = Image.open(OUT / f'{src}.tga').convert('RGBA')
        px = image.load()
        for y in range(image.height):
            for x in range(image.width):
                r, g, b, a = px[x, y]
                v = round(0.30 * r + 0.59 * g + 0.11 * b)
                v = 60 + v * 70 // 255
                px[x, y] = (v, v, v + 4, a * 3 // 4)
        save(image, dst)
    # Key cap badge.
    img = canvas(32, 32)
    d = ImageDraw.Draw(img)
    d.rounded_rectangle((1 * S, 1 * S, 31 * S, 31 * S), radius=6 * S, fill=GOLD_DARK + (255,))
    d.rounded_rectangle((3 * S, 3 * S, 29 * S, 29 * S), radius=5 * S, fill=(14, 16, 20, 255))
    d.rounded_rectangle((4 * S, 4 * S, 28 * S, 14 * S), radius=4 * S, fill=(30, 33, 40, 255))
    save(down(img, 32, 32), 'keycap')


def glows():
    # Rectangular gold halo with a transparent centre (offer window pulse).
    w, h = 256, 128
    halo = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(halo)
    d.rounded_rectangle((10, 10, w - 11, h - 11), radius=12, outline=GOLD_BRIGHT + (255,), width=10)
    halo = halo.filter(ImageFilter.GaussianBlur(5))
    inner = Image.new('L', (w, h), 255)
    ImageDraw.Draw(inner).rounded_rectangle((22, 22, w - 23, h - 23), radius=8, fill=0)
    alpha = Image.eval(halo.getchannel('A'), lambda v: v)
    halo.putalpha(Image.composite(alpha, Image.new('L', (w, h), 0), inner))
    save(halo, 'glow-gold')
    # Moving highlight for the window's top rail.
    img = Image.new('RGBA', (64, 16), (0, 0, 0, 0))
    ImageDraw.Draw(img).ellipse((4, 4, 60, 12), fill=(255, 244, 210, 255))
    save(img.filter(ImageFilter.GaussianBlur(2.5)), 'shine')


def disc(spokes=0):
    size = 256
    img = Image.new('RGBA', (size * 2, size * 2), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    c = size
    R = int(0.47 * size * 2)
    H = int(0.13 * size * 2)
    d.ellipse((c - R - 6, c - R - 6, c + R + 6, c + R + 6), fill=GOLD_DARK + (255,))
    d.ellipse((c - R - 2, c - R - 2, c + R + 2, c + R + 2), fill=GOLD + (255,))
    d.ellipse((c - R + 4, c - R + 4, c + R - 4, c + R - 4), fill=GRAPHITE + (236,))
    # Subtle radial shading.
    for k in range(6):
        rr = R - 4 - k * 30
        if rr <= H:
            break
        d.ellipse((c - rr, c - rr, c + rr, c + rr), outline=GRAPHITE_LIGHT + (60,), width=3)
    for k in range(spokes):
        a = math.radians(90 + 36 - k * 72)
        x1, y1 = c + H * math.cos(a), c - H * math.sin(a)
        x2, y2 = c + (R - 4) * math.cos(a), c - (R - 4) * math.sin(a)
        d.line([(x1, y1), (x2, y2)], fill=GOLD_DARK + (255,), width=6)
        d.line([(x1, y1), (x2, y2)], fill=GOLD + (255,), width=2)
    d.ellipse((c - H - 6, c - H - 6, c + H + 6, c + H + 6), fill=GOLD_DARK + (255,))
    d.ellipse((c - H - 2, c - H - 2, c + H + 2, c + H + 2), fill=GOLD + (255,))
    d.ellipse((c - H + 4, c - H + 4, c + H - 4, c + H - 4), fill=(12, 14, 18, 250))
    return img.resize((size, size), Image.Resampling.LANCZOS)


def wheels():
    save(disc(5), 'wheel-base')
    save(disc(0), 'wheel-ring')
    accents = {'move': (80, 190, 230), 'attack': (230, 110, 70), 'danger': (235, 195, 70),
               'help': (110, 220, 140), 'rally': (175, 145, 240)}
    for index, kind in enumerate(('move', 'attack', 'danger', 'help', 'rally')):
        size = 256
        img = Image.new('RGBA', (size * 2, size * 2), (0, 0, 0, 0))
        d = ImageDraw.Draw(img)
        c = size
        R = int(0.47 * size * 2) - 6
        H = int(0.13 * size * 2) + 8
        mid = 90 - index * 72
        # PIL angles run clockwise from +x; the wheel uses counter-clockwise.
        start, end = -(mid + 34), -(mid - 34)
        accent = accents[kind]
        tint = tuple(round(0.55 * g + 0.45 * a) for g, a in zip(GOLD, accent))
        d.pieslice((c - R, c - R, c + R, c + R), start, end, fill=tuple(round(0.25 * t) for t in tint) + (150,))
        d.ellipse((c - H, c - H, c + H, c + H), fill=(0, 0, 0, 0))
        d.arc((c - R, c - R, c + R, c + R), start, end, fill=tint + (255,), width=6)
        gx = c + 0.62 * R * math.cos(math.radians(mid))
        gy = c - 0.62 * R * math.sin(math.radians(mid))
        g = 58

        def pts(seq):
            return [(gx + x * g / 10, gy + y * g / 10) for x, y in seq]

        if kind == 'move':
            for dx in (-5, 2):
                d.polygon(pts([(dx, -6), (dx + 4, -6), (dx + 9, 0), (dx + 4, 6), (dx, 6), (dx + 5, 0)]), fill=tint + (255,))
        elif kind == 'attack':
            d.line(pts([(-7, -7), (7, 7)]), fill=tint + (255,), width=20)
            d.line(pts([(7, -7), (-7, 7)]), fill=tint + (255,), width=20)
        elif kind == 'danger':
            d.polygon(pts([(0, -9), (9, 7), (-9, 7)]), fill=tint + (255,))
            d.line(pts([(0, -3), (0, 2)]), fill=(20, 18, 14, 255), width=11)
            d.ellipse((gx - 6, gy + 3.2 * g / 10, gx + 6, gy + 3.2 * g / 10 + 12), fill=(20, 18, 14, 255))
        elif kind == 'help':
            d.line(pts([(0, -8), (0, 8)]), fill=tint + (255,), width=22)
            d.line(pts([(-8, 0), (8, 0)]), fill=tint + (255,), width=22)
        else:
            d.line(pts([(-4, -8), (-4, 9)]), fill=tint + (255,), width=13)
            d.polygon(pts([(-4, -8), (7, -5), (-4, -1)]), fill=tint + (255,))
        save(img.resize((size, size), Image.Resampling.LANCZOS), f'ping-{kind}')


def build():
    stat_icons()
    underline()
    attack_icons()
    controls()
    glows()
    wheels()
    print('Prepared checkpoint 21 textures:', len(NAMES))


if __name__ == '__main__':
    build()
