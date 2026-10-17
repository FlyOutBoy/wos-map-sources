"""Checkpoint 23 textures (pure Python, raster.py): tooltip edge, dropdown row
bevel, BUY/SELL buttons, F3/F4 + History glyphs, damage-bonus icons, ban
cover, new repick glyph and placeholder Game Info icons (info-*.tga - replace
them with game art at the same paths whenever you like).
"""
import math
from pathlib import Path

import png_tga

from build_wos_ui_textures_cp22 import (GOLD, GOLD_BRIGHT, GOLD_DARK, INK, OUT, glyph, gold_paint, save)
from raster import Canvas, box, circle, intersect, lerp, offset, polygon, ring, sector, segment, subtract, union

INFO_ICONS = ['info-fire', 'info-water', 'info-lightning', 'info-firewater', 'info-firelightning',
              'info-lightningwater', 'info-barrel', 'info-barrel-explosive', 'info-vending', 'info-car',
              'info-train', 'info-hydrant', 'info-gold', 'info-building', 'info-roundend']

NAMES = ['tooltip-edge', 'menu-row', 'btn-buy', 'btn-sell', 'glyph-history', 'glyph-clear', 'glyph-load',
         'glyph-repick', 'icon-physdmg', 'icon-magdmg', 'ban-cover', 'glyph-trash', 'glyph-prev', 'glyph-next', 'meter-fill', 'meter-fill-red', 'pick-confirm', 'pick-confirm-off', 'pick-random', 'pick-random-off', 'pick-ban', 'pick-ban-off', 'fastbuy-on', 'fastbuy-off', 'fastsell-on', 'fastsell-off', 'icon-attackspeed', 'icon-movespeed', 'icon-range', 'portrait-lock', 'hp-dark', 'mp-dark', 'slider-clean-v', 'slider-clean-h', 'fill-hover-blue', 'skill-chains', 'icon-physpen', 'icon-magpen', 'icon-shieldpen', 'icon-hpregen', 'icon-mpregen', 'vip-frame-bronze', 'vip-frame-silver', 'vip-frame-gold', 'glyph-cols1', 'glyph-cols2', 'glyph-cols3', 'menu-edge', 'menu-edge-button', 'heart'] + INFO_ICONS

# Checkpoint 24: gold attribute icons supplied by the author (folder 18).
STAT_SOURCE = Path(r'C:/Users/Gear/Desktop/Новая папка (18)')
STAT_FILES = {'stat-str': 'Strength_Gold_Alpha.png', 'stat-agi': 'Agility_Gold_Alpha.png',
              'stat-int': 'Intelligence_Gold_Alpha.png'}


# ---- block letters (stroke font) ----------------------------------------
def letter(ch, x, y, w, h, t):
    L, R, T, B, M = x, x + w, y, y + h, y + h / 2
    s = []
    if ch == 'B':
        s = [segment(L, T, L, B, t), segment(L, T, R - h * .18, T, t), segment(L, M, R - h * .14, M, t),
             segment(L, B, R - h * .14, B, t), segment(R - h * .18, T, R - h * .05, T + h * .12, t),
             segment(R - h * .05, T + h * .12, R - h * .05, M - h * .12, t), segment(R - h * .05, M - h * .12, R - h * .18, M, t),
             segment(R - h * .14, M, R, M + h * .12, t), segment(R, M + h * .12, R, B - h * .12, t), segment(R, B - h * .12, R - h * .14, B, t)]
    elif ch == 'U':
        s = [segment(L, T, L, B - h * .2, t), segment(R, T, R, B - h * .2, t), segment(L, B - h * .2, L + w * .25, B, t),
             segment(L + w * .25, B, R - w * .25, B, t), segment(R - w * .25, B, R, B - h * .2, t)]
    elif ch == 'Y':
        s = [segment(L, T, (L + R) / 2, M, t), segment(R, T, (L + R) / 2, M, t), segment((L + R) / 2, M, (L + R) / 2, B, t)]
    elif ch == 'S':
        s = [segment(R, T + h * .08, R - w * .2, T, t), segment(R - w * .2, T, L + w * .2, T, t), segment(L + w * .2, T, L, T + h * .2, t),
             segment(L, T + h * .2, L + w * .15, M - h * .04, t), segment(L + w * .15, M - h * .04, R - w * .15, M + h * .04, t),
             segment(R - w * .15, M + h * .04, R, B - h * .2, t), segment(R, B - h * .2, R - w * .2, B, t),
             segment(R - w * .2, B, L + w * .2, B, t), segment(L + w * .2, B, L, B - h * .08, t)]
    elif ch == 'E':
        s = [segment(L, T, L, B, t), segment(L, T, R, T, t), segment(L, M, R - w * .2, M, t), segment(L, B, R, B, t)]
    elif ch == 'L':
        s = [segment(L, T, L, B, t), segment(L, B, R, B, t)]
    return union(*s)


def word(text, cx, cy, h, t, gap):
    w = h * 0.62
    total = len(text) * w + (len(text) - 1) * gap
    x = cx - total / 2
    shapes = []
    for ch in text:
        shapes.append(letter(ch, x, cy - h / 2, w, h, t))
        x += w + gap
    return union(*shapes)


# ---- textures --------------------------------------------------------------
def tooltip_edge():
    """Backdrop edge file: 8 tiles in a row (L, R, T, B, UL, UR, BL, BR). The
    four edge tiles carry a centred vertical line, so any rotation the engine
    applies to the top/bottom tiles gives the same look."""
    t = 32
    c = Canvas(8 * t, t)
    for i in range(4):
        x = i * t + t / 2
        c.fill(box(x, t / 2, 2.6, t / 2), INK, alpha=0.8)
        c.fill(box(x, t / 2, 1.3, t / 2), GOLD)
    corners = {4: (1, 1), 5: (-1, 1), 6: (1, -1), 7: (-1, -1)}   # direction of the two arms
    for i, (dx, dy) in corners.items():
        cx, cy = i * t + t / 2, t / 2
        arms = union(box(cx + dx * t / 4, cy, t / 4, 1.3), box(cx, cy + dy * t / 4, 1.3, t / 4))
        c.fill(offset(arms, 1.3), INK, alpha=0.8)
        c.fill(arms, GOLD)
        gem = polygon([(cx, cy - 5), (cx + 5, cy), (cx, cy + 5), (cx - 5, cy)])
        c.fill(offset(gem, 1.2), INK, alpha=0.8)
        c.fill(gem, gold_paint(t))
    save(c, 'tooltip-edge')


# Thin fading gold line, same profile as divider-h/-v (the TEST COMMANDS edge).
LINE_PROFILE = [((10, 8, 5), 140), (GOLD_DARK, 255), (GOLD, 255), (GOLD_DARK, 255), ((10, 8, 5), 140)]


def _blank(w, h):
    return [bytearray(w * 4) for _ in range(h)]


def _put(rows, x, y, color, alpha):
    if 0 <= y < len(rows) and 0 <= x * 4 < len(rows[0]):
        old = rows[y][x * 4 + 3]
        if alpha > old:
            rows[y][x * 4:x * 4 + 4] = bytes((color[0], color[1], color[2], alpha))


def _hline(rows, x0, x1, y, fade, strength=170):
    n = x1 - x0
    for i, x in enumerate(range(x0, x1)):
        f = (math.sin(math.pi * i / max(1, n - 1)) ** 0.6) if fade else 1.0
        for k, (color, a) in enumerate(LINE_PROFILE):
            _put(rows, x, y + k - 2, color, round(a * f * strength / 255))


def _vline(rows, x, y0, y1, fade, strength=170):
    n = y1 - y0
    for i, y in enumerate(range(y0, y1)):
        f = (math.sin(math.pi * i / max(1, n - 1)) ** 0.6) if fade else 1.0
        for k, (color, a) in enumerate(LINE_PROFILE):
            _put(rows, x + k - 2, y, color, round(a * f * strength / 255))


def menu_row():
    """8:1 dropdown row: thin fading gold lines on all four sides (no gems)."""
    w, h = 512, 64
    rows = _blank(w, h)
    _hline(rows, 0, w, 3, True)
    _hline(rows, 0, w, h - 4, True)
    _vline(rows, 3, 0, h, True)
    _vline(rows, w - 4, 0, h, True)
    save((w, h, rows), 'menu-row')


def menu_edge(name='menu-edge', place=0.19):
    """Esc-menu backdrop edge (8 tiles L, R, T, B, UL, UR, BL, BR): one thin
    gold line, like the top-right block edge, placed where the engine starts
    the menu background (about 0.42 of a tile from the outer side), so it
    traces the panel / button edge instead of floating outside it.
    The engine draws the top/bottom tiles rotated 90 degrees clockwise: the
    top tile keeps its outer side on the left, the bottom tile on the right."""
    t = 64
    at = round(t * place)
    rows = _blank(8 * t, t)
    profile = [(GOLD_DARK, 170), (GOLD, 235), (GOLD_DARK, 150)]

    def col(tile, x_line, y0=0, y1=t):
        for k, (color, a) in enumerate(profile):
            for y in range(y0, y1):
                _put(rows, tile * t + x_line + k - 1, y, color, a)

    def row(tile, y_line, x0, x1):
        for k, (color, a) in enumerate(profile):
            for x in range(tile * t + x0, tile * t + x1):
                _put(rows, x, y_line + k - 1, color, a)

    col(0, at)            # L
    col(1, t - 1 - at)    # R
    col(2, at)            # T (stored rotated)
    col(3, t - 1 - at)    # B (stored rotated)
    near, far = at, t - 1 - at

    # Corners: two arms from the meeting point toward the tile edges. Near the
    # meeting point both arms are faded (35% -> 100% over 18 px), so the joint
    # stays soft instead of a bright overlapping knot.
    def fade(d):
        return min(1.0, 0.35 + 0.65 * d / 18.0)

    def corner(tile, cx, cy, dx, dy):
        for k, (color, a) in enumerate(profile):
            x = cx + dx
            d = 1
            while 0 <= x < t:
                _put(rows, tile * t + x, cy + k - 1, color, round(a * fade(d)))
                x += dx
                d += 1
            y = cy + dy
            d = 1
            while 0 <= y < t:
                _put(rows, tile * t + cx + k - 1, y, color, round(a * fade(d)))
                y += dy
                d += 1
            _put(rows, tile * t + cx, cy, color, round(a * 0.35))

    corner(4, near, near, 1, 1)     # UL
    corner(5, far, near, -1, 1)     # UR
    corner(6, near, far, 1, -1)     # BL
    corner(7, far, far, -1, -1)     # BR
    save((8 * t, t, rows), name)


def trade_button(name, label, accent, draw_glyph):
    n = 128
    c = Canvas(n, n)
    c.fill(box(n / 2, n / 2, n / 2 - 2, n / 2 - 2, 10), lambda x, y: lerp(lerp(accent, INK, 0.62), lerp(accent, INK, 0.86), y / n))
    band = subtract(box(n / 2, n / 2, n / 2 - 2, n / 2 - 2, 10), box(n / 2, n / 2, n / 2 - 7, n / 2 - 7, 7))
    c.fill(band, gold_paint(n))
    c.fill(box(n / 2, 30, n / 2 - 12, 15, 5), INK, alpha=0.55)
    text = word(label, n / 2, 30, 18, 2.4, 4)
    c.fill(offset(text, 1.6), INK, alpha=0.9)
    c.fill(text, lambda x, y: lerp(GOLD_BRIGHT, GOLD, (y - 20) / 20))
    draw_glyph(c, n)
    save(c, name)


def cart(c, n):
    lc = lerp((140, 230, 120), GOLD_BRIGHT, 0.3)
    shape = union(segment(30, 58, 42, 58, 4), segment(42, 58, 52, 92, 4), segment(52, 92, 92, 92, 4),
                  segment(46, 66, 100, 66, 4), segment(100, 66, 94, 84, 4), segment(94, 84, 50, 84, 4),
                  circle(58, 104, 6.5), circle(88, 104, 6.5))
    c.fill(offset(shape, 2), INK, alpha=0.8)
    c.fill(shape, lc)


def trash_can(c, n, cx=64, top=52, scale=1.12):
    """Iron bin: lid with handle, tapered ribbed body (steel gradient)."""
    s = scale
    steel = lambda x, y: lerp((236, 240, 246), (96, 104, 116), (x - (cx - 24 * s)) / (48 * s) * 0.85 + 0.1)
    body = polygon([(cx - 20 * s, top + 12 * s), (cx + 20 * s, top + 12 * s), (cx + 16 * s, top + 56 * s), (cx - 16 * s, top + 56 * s)])
    lid = box(cx, top + 6 * s, 24 * s, 4 * s, 2 * s)
    handle = subtract(box(cx, top - 1 * s, 8 * s, 5 * s, 3 * s), box(cx, top, 4.5 * s, 3 * s, 1.5 * s))
    shape = union(body, lid, handle)
    c.fill(offset(shape, 2.4), INK, alpha=0.9)
    c.fill(shape, steel)
    for dx in (-9, 0, 9):
        rib = segment(cx + dx * s, top + 18 * s, cx + dx * 0.8 * s, top + 50 * s, 2.2 * s)
        c.fill(rib, (70, 76, 86), alpha=0.85)
    c.fill(box(cx, top + 12.5 * s, 20 * s, 1.2 * s), (60, 64, 72), alpha=0.8)


def build_glyphs():
    # History: clock face with a counter-clockwise arrow
    glyph(lambda n: union(subtract(ring(32, 33, 20, 3.2), intersect(sector(32, 33, 95, 145), box(32, 33, 32, 32))),
                          polygon([(10, 22), (22, 18), (16, 30)]), segment(32, 33, 32, 21, 2.6), segment(32, 33, 41, 38, 2.6)),
          'glyph-history')
    # Clear (F3): bin
    glyph(lambda n: union(box(32, 40, 13, 15, 2), box(32, 21, 17, 2.6, 1), box(32, 16, 6, 2.4, 1),
                          ), 'glyph-clear')
    # Load (F4): arrow into a tray
    glyph(lambda n: union(box(32, 22, 3.2, 12, 1), polygon([(20, 30), (44, 30), (32, 44)]),
                          box(32, 52, 20, 2.8, 1), box(13, 46, 2.8, 8, 1), box(51, 46, 2.8, 8, 1)), 'glyph-load')
    # Repick: one arc whose end IS the arrowhead
    def repick(n):
        arc = intersect(ring(32, 32, 17, 3.4), sector(32, 32, -200, 70))
        a = math.radians(70)
        hx, hy = 32 + 17 * math.cos(a), 32 - 17 * math.sin(a)
        head = polygon([(hx - 9, hy - 1), (hx + 7, hy - 7), (hx + 3, hy + 10)])
        # Checkpoint 26e: no mouse cursor inside - a clean refresh arrow.
        return union(arc, head)
    glyph(repick, 'glyph-repick')
    # Disabled copy (desaturated, dimmed), same recipe as checkpoint 21.
    width, height, rows = png_tga.read_tga(OUT / 'glyph-repick.tga')
    for line in rows:
        for x in range(width):
            r, g, b, a = line[x * 4:x * 4 + 4]
            v = 60 + round(0.30 * r + 0.59 * g + 0.11 * b) * 70 // 255
            line[x * 4:x * 4 + 4] = bytes((v, v, v + 4, a * 3 // 4))
    save((width, height, rows), 'glyph-repick-off')


def damage_icons():
    """Outgoing damage bonus: a weapon + a big upward arrow.
    Physical = red disc with a sword, magical = blue disc with a spark star."""
    for name, accent, kind in (('icon-physdmg', (226, 84, 60), 'sword'), ('icon-magdmg', (80, 130, 245), 'star')):
        n = 64
        c = Canvas(n, n)
        c.fill(circle(32, 32, 30), INK, alpha=0.9)
        c.fill(circle(32, 32, 27.5), lambda x, y: lerp(lerp(accent, (255, 255, 255), 0.30), lerp(accent, INK, 0.50), y / n))
        c.fill(ring(32, 32, 27.5, 1.4), gold_paint(n))
        if kind == 'sword':
            weapon = union(segment(15, 49, 37, 27, 4.2), polygon([(33, 23), (43, 19), (39, 31)]),
                           segment(12, 40, 24, 52, 3.2), segment(13, 51, 8, 56, 3.4))
        else:
            pts = []
            for k in range(8):
                a = math.radians(k * 45 - 90)
                r = 15 if k % 2 == 0 else 5.5
                pts.append((26 + r * math.cos(a), 36 + r * math.sin(a)))
            weapon = polygon(pts)
        arrow = union(polygon([(48, 9), (59, 23), (37, 23)]), box(48, 30, 4.2, 8, 1))
        c.fill(offset(weapon, 2.2), INK, alpha=0.85)
        c.fill(weapon, (250, 244, 230))
        c.fill(offset(arrow, 2.2), INK, alpha=0.9)
        c.fill(arrow, lambda x, y: lerp((190, 255, 150), (60, 190, 70), (y - 9) / 30))
        save(c, name)


def page_glyphs():
    """Double chevrons for page switching."""
    glyph(lambda n: union(polygon([(36, 14), (44, 14), (26, 32), (44, 50), (36, 50), (18, 32)]),
                          polygon([(50, 14), (58, 14), (40, 32), (58, 50), (50, 50), (32, 32)])), 'glyph-prev')
    glyph(lambda n: union(polygon([(28, 14), (20, 14), (38, 32), (20, 50), (28, 50), (46, 32)]),
                          polygon([(14, 14), (6, 14), (24, 32), (6, 50), (14, 50), (32, 32)])), 'glyph-next')


def meter_fill():
    """Purple progress fill for hero meters (the old XP-bar colour)."""
    w, h = 256, 32
    c = Canvas(w, h)
    c.fill(box(w / 2, h / 2, w / 2, h / 2), lambda x, y: lerp((196, 120, 255), (92, 30, 168), y / h))
    c.fill(box(w / 2, 6, w / 2, 2.5), (255, 255, 255), alpha=0.22)
    save(c, 'meter-fill')


def meter_fill_red():
    """Warm crimson second row, with readable ivory digits."""
    w, h = 256, 32
    c = Canvas(w, h)
    c.fill(box(w / 2, h / 2, w / 2, h / 2), lambda x, y: lerp((240, 96, 78), (140, 28, 44), y / h))
    save(c, 'meter-fill-red')


def pick_buttons():
    """Hero pick actions on a graphite plate with a gold bevel: confirm (green
    check on a red box), random (gold die), ban (red circle-slash). *-off =
    the same art greyed out (disabled state)."""
    def grey(c):
        g = round(c[0] * 0.3 + c[1] * 0.59 + c[2] * 0.11)
        return (g // 2 + 40, g // 2 + 40, g // 2 + 44)

    def plate(c, n, off):
        c.fill(box(n / 2, n / 2, n / 2 - 2, n / 2 - 2, 12), lambda x, y: lerp((52, 56, 64), (20, 22, 27), y / n))
        ring_ = subtract(box(n / 2, n / 2, n / 2 - 2, n / 2 - 2, 12), box(n / 2, n / 2, n / 2 - 8, n / 2 - 8, 8))
        if off:
            c.fill(ring_, (96, 98, 104))
        else:
            c.fill(ring_, gold_paint(n))

    for off in (False, True):
        suffix = '-off' if off else ''
        n = 128
        # confirm
        c = Canvas(n, n)
        plate(c, n, off)
        red = (214, 52, 46)
        check = union(segment(36, 66, 56, 88, 8), segment(56, 88, 96, 36, 8))
        green = (90, 220, 80)
        c.fill(offset(check, 3), INK, alpha=0.85)
        c.fill(check, grey(green) if off else (lambda x, y: lerp((150, 255, 120), (40, 170, 50), y / n)))
        save(c, 'pick-confirm' + suffix)
        # random
        c = Canvas(n, n)
        plate(c, n, off)
        top = polygon([(64, 26), (98, 44), (64, 62), (30, 44)])
        left = polygon([(30, 44), (64, 62), (64, 102), (30, 84)])
        right = polygon([(64, 62), (98, 44), (98, 84), (64, 102)])
        cube = union(top, left, right)
        c.fill(offset(cube, 3), INK, alpha=0.85)
        base = (232, 200, 120)
        for face, k in ((top, 0.0), (left, 0.25), (right, 0.45)):
            col = lerp(base, INK, k)
            c.fill(face, grey(col) if off else col)
        pips = union(circle(64, 44, 5), circle(42, 66, 4), circle(52, 84, 4), circle(76, 86, 4), circle(86, 74, 4), circle(81, 60, 4))
        c.fill(pips, (30, 30, 34), alpha=0.9)
        save(c, 'pick-random' + suffix)
        # ban
        c = Canvas(n, n)
        plate(c, n, off)
        sign = union(ring(64, 64, 34, 7), segment(40, 88, 88, 40, 7))
        c.fill(offset(sign, 3), INK, alpha=0.85)
        c.fill(sign, grey(red) if off else (lambda x, y: lerp((255, 110, 96), (180, 24, 24), (x + y) / (2 * n))))
        save(c, 'pick-ban' + suffix)


def fast_toggles():
    """Fast buy (cart + bolt, green) / fast sell (bin + bolt, red); -off greyed."""
    n = 64
    for kind, accent in (('fastbuy', (90, 210, 90)), ('fastsell', (225, 80, 70))):
        for on in (True, False):
            c = Canvas(n, n)
            c.fill(box(32, 32, 30, 30, 7), lambda x, y: lerp((50, 54, 62), (20, 22, 27), y / n))
            band = subtract(box(32, 32, 30, 30, 7), box(32, 32, 26, 26, 5))
            c.fill(band, gold_paint(n) if on else (96, 98, 104))
            col = accent if on else (118, 120, 126)
            if kind == 'fastbuy':
                g = union(segment(10, 24, 16, 24, 2.4), segment(16, 24, 21, 42, 2.4), segment(21, 42, 40, 42, 2.4),
                          segment(18, 29, 44, 29, 2.4), segment(44, 29, 41, 38, 2.4), circle(24, 48, 3.2), circle(37, 48, 3.2))
            else:
                g = union(polygon([(14, 26), (36, 26), (34, 50), (16, 50)]), box(25, 22, 13, 2.2, 1), box(25, 18, 4, 2, 1))
            c.fill(offset(g, 1.6), INK, alpha=0.85)
            c.fill(g, col)
            bolt = polygon([(50, 8), (40, 30), (48, 30), (42, 52), (58, 24), (50, 24), (56, 8)])
            c.fill(offset(bolt, 1.6), INK, alpha=0.9)
            c.fill(bolt, (255, 222, 90) if on else (130, 130, 136))
            save(c, kind + ('-on' if on else '-off'))


def hud_extra_icons():
    """Attack speed (gauntlet + speed lines), move speed (winged boot), attack
    range (crosshair); portrait lock (diagonal chains + padlock); darker
    HP / MP fills so the white numbers read better."""
    def medal(accent):
        n = 64
        c = Canvas(n, n)
        c.fill(circle(32, 32, 30), INK, alpha=0.9)
        c.fill(circle(32, 32, 27.5), lambda x, y: lerp(lerp(accent, (255, 255, 255), 0.25), lerp(accent, INK, 0.5), y / n))
        c.fill(ring(32, 32, 27.5, 1.4), gold_paint(n))
        return c, n
    light = (250, 244, 230)
    # gauntlet
    c, n = medal((214, 120, 60))
    fist = union(box(34, 36, 11, 10, 4), box(34, 23, 10, 4, 2), box(26, 49, 7, 6, 2), box(44, 34, 4, 7, 2))
    lines = union(segment(10, 26, 20, 26, 2), segment(8, 34, 19, 34, 2), segment(10, 42, 20, 42, 2))
    shape = union(fist, lines)
    c.fill(offset(shape, 2), INK, alpha=0.85)
    c.fill(shape, light)
    save(c, 'icon-attackspeed')
    # winged boot
    c, n = medal((90, 170, 110))
    boot = union(polygon([(26, 14), (38, 14), (38, 38), (50, 42), (50, 50), (22, 50), (22, 38)]))
    wing = polygon([(38, 22), (56, 14), (52, 22), (58, 22), (50, 30), (40, 30)])
    shape = union(boot, wing)
    c.fill(offset(shape, 2), INK, alpha=0.85)
    c.fill(shape, light)
    save(c, 'icon-movespeed')
    # crosshair, gold like the supplied attribute / speed icons
    n = 64
    c = Canvas(n, n)
    shape = union(ring(32, 32, 17, 3.6), segment(32, 4, 32, 22, 3.6), segment(32, 42, 32, 60, 3.6),
                  segment(4, 32, 22, 32, 3.6), segment(42, 32, 60, 32, 3.6), circle(32, 32, 4.5))
    c.fill(offset(shape, 2.4), INK, alpha=0.85)
    c.fill(shape, gold_paint(n))
    save(c, 'icon-range')
    # portrait lock
    n = 128
    c = Canvas(n, n)
    c.fill(box(64, 64, 64, 64), INK, alpha=0.45)
    for k in range(-3, 4):
        cx, cy = 64 + k * 18, 64 - k * 18
        link = ring(cx, cy, 9, 3)
        c.fill(offset(link, 1.5), INK, alpha=0.8)
        c.fill(link, (190, 196, 206))
    body = box(64, 74, 22, 18, 4)
    shackle = subtract(ring(64, 52, 15, 4.5), box(64, 64, 20, 12))
    lock = union(body, shackle)
    c.fill(offset(lock, 3), INK, alpha=0.9)
    c.fill(lock, gold_paint(n))
    c.fill(union(circle(64, 70, 5), box(64, 80, 2.5, 7, 1)), INK, alpha=0.95)
    save(c, 'portrait-lock')
    # darker vitals
    import png_tga as _p
    from pathlib import Path as _P
    out = _P(__file__).resolve().parents[1] / 'assets/UI/WOS'
    for src, dst in (('hp', 'hp-dark'), ('mp', 'mp-dark')):
        w, h, rows = _p.read_tga(out / (src + '.tga'))
        for line in rows:
            for x in range(w):
                for k in range(3):
                    line[x * 4 + k] = line[x * 4 + k] * 62 // 100
        _p.write_tga((w, h, rows), out / (dst + '.tga'))


def clean_tracks():
    """Plain slider tracks (no tick marks): dark groove inside a gold rim."""
    w, h = 32, 256
    c = Canvas(w, h)
    c.fill(box(16, 128, 9, 124, 8), gold_paint(h))
    c.fill(box(16, 128, 6.5, 121.5, 6), lambda x, y: lerp((14, 15, 18), (34, 36, 42), x / w))
    save(c, 'slider-clean-v')
    w, h = 256, 32
    c = Canvas(w, h)
    c.fill(box(128, 16, 124, 9, 8), gold_paint(w))
    c.fill(box(128, 16, 121.5, 6.5, 6), lambda x, y: lerp((14, 15, 18), (34, 36, 42), y / h))
    save(c, 'slider-clean-h')


def hover_blue():
    """Blue hover fill for the Menu / Allies / Log rows (stock menu look)."""
    w, h = 256, 32
    c = Canvas(w, h)
    c.fill(box(w / 2, h / 2, w / 2, h / 2), lambda x, y: lerp((52, 86, 150), (18, 30, 62), y / h))
    save(c, 'fill-hover-blue')


def trash_glyph():
    n = 64
    c = Canvas(n, n)
    trash_can(c, n, cx=32, top=8, scale=0.82)
    save(c, 'glyph-trash')


SPEED_SOURCE = Path(r'C:/Users/Gear/Desktop/Новая папка (16)')
SPEED_FILES = {'icon-attackspeed': 'ICON_ATTACKSPEED.png', 'icon-movespeed': 'ICON_MOVESPEED.png',
               'icon-range': 'Icon_AttackRange.png'}


def speed_icons():
    """Author-supplied attack / move speed icons (folder 16) replace the drawn ones."""
    for name, file in SPEED_FILES.items():
        path = SPEED_SOURCE / file
        if not path.is_file():
            print('skip', name, 'missing', path)
            continue
        image = png_tga.read_png(path)
        image = png_tga.crop(image, png_tga.alpha_bbox(image))
        side = max(image[0], image[1])
        image = png_tga.pad(image, side, side)
        save(png_tga.resize(image, 128, 128), name)
        print('speed icon', name, side)
    # Paused: the supplied icon centred on a dark veil over the portrait.
    path = SPEED_SOURCE / 'Icon_Paused.png'
    if path.is_file():
        image = png_tga.read_png(path)
        image = png_tga.crop(image, png_tga.alpha_bbox(image))
        side = max(image[0], image[1])
        icon = png_tga.resize(png_tga.pad(image, side, side), 92, 92)
        rows = [bytearray([10, 11, 14, 120] * 128) for _ in range(128)]
        for y in range(92):
            for x in range(92):
                r, g, b, a = icon[2][y][x * 4:x * 4 + 4]
                j = (x + 18) * 4
                line = rows[y + 18]
                br, bg, bb, ba = line[j:j + 4]
                out_a = a + ba * (255 - a) // 255
                for k, (fc, bc) in enumerate(((r, br), (g, bg), (b, bb))):
                    line[j + k] = (fc * a + bc * ba * (255 - a) // 255) // max(1, out_a)
                line[j + 3] = out_a
        png_tga.write_tga((128, 128, rows), OUT / 'portrait-lock.tga')
        print('paused overlay', side)


def stat_icons():
    """Square, trimmed and downsampled copies of the supplied gold icons."""
    for name, file in STAT_FILES.items():
        path = STAT_SOURCE / file
        if not path.is_file():
            print('skip', name, 'missing', path)
            continue
        image = png_tga.read_png(path)
        image = png_tga.crop(image, png_tga.alpha_bbox(image))
        side = max(image[0], image[1])
        image = png_tga.pad(image, side, side)
        save(png_tga.resize(image, 128, 128), name)
        print('stat icon', name, side)


def ban_cover():
    n = 64
    c = Canvas(n, n)
    # Checkpoint 26: no red wash over the hero; strokes half as thick so the
    # banned hero stays recognisable.
    for a, b in (((6, 6), (58, 58)), ((58, 6), (6, 58))):
        c.fill(segment(a[0], a[1], b[0], b[1], 3.4), INK, alpha=0.7)
        c.fill(segment(a[0], a[1], b[0], b[1], 2.3), lambda x, y: lerp((255, 120, 100), (190, 25, 25), (x + y) / 128))
    save(c, 'ban-cover')


def info_icons():
    """Placeholder medallions; replace UI\\WOS\\info-*.tga with real art."""
    spec = {
        'info-fire': ((236, 110, 50), 'F'), 'info-water': ((70, 150, 240), 'W'), 'info-lightning': ((240, 220, 90), 'L'),
        'info-firewater': ((200, 120, 160), 'FW'), 'info-firelightning': ((240, 160, 60), 'FL'),
        'info-lightningwater': ((120, 200, 220), 'LW'), 'info-barrel': ((150, 110, 70), 'B'),
        'info-barrel-explosive': ((210, 60, 50), 'B'), 'info-vending': ((90, 160, 200), 'V'), 'info-car': ((170, 170, 180), 'C'),
        'info-train': ((120, 120, 130), 'T'), 'info-hydrant': ((220, 60, 60), 'H'), 'info-gold': ((235, 200, 80), 'G'),
        'info-building': ((150, 140, 120), 'D'), 'info-roundend': ((180, 40, 60), 'R'),
    }
    for name, (accent, mark) in spec.items():
        n = 64
        c = Canvas(n, n)
        c.fill(circle(32, 32, 30), INK, alpha=0.85)
        c.fill(ring(32, 32, 27, 2.6), gold_paint(n))
        c.fill(circle(32, 32, 24), lambda x, y: lerp(lerp(accent, (255, 255, 255), 0.2), lerp(accent, INK, 0.55), y / n))
        dots = [circle(32 + (i - (len(mark) - 1) / 2) * 16, 32, 6) for i in range(len(mark))]
        c.fill(union(*dots), (250, 244, 230), alpha=0.85)
        save(c, name)


def skill_chains():
    """Paused skill: two thin steel chains crossing corner to corner (like the
    ban cross), drawn over the icon instead of a PAUSED caption."""
    n = 64
    c = Canvas(n, n)
    for (ax, ay), (bx, by) in (((5, 5), (59, 59)), ((59, 5), (5, 59))):
        length = math.hypot(bx - ax, by - ay)
        ux, uy = (bx - ax) / length, (by - ay) / length
        count = 9
        step = length / count
        for k in range(count):
            cx, cy = ax + ux * step * (k + 0.5), ay + uy * step * (k + 0.5)
            h = step * 0.62
            p0, p1 = (cx - ux * h * 0.5, cy - uy * h * 0.5), (cx + ux * h * 0.5, cy + uy * h * 0.5)
            if k % 2 == 0:
                link = subtract(segment(p0[0], p0[1], p1[0], p1[1], 2.6), segment(p0[0], p0[1], p1[0], p1[1], 1.1))
            else:
                link = segment(p0[0], p0[1], p1[0], p1[1], 1.0)
            c.fill(offset(link, 1.0), INK, alpha=0.85)
            c.fill(link, lambda x, y: lerp((226, 230, 238), (120, 126, 138), (x + y) / (2 * n)))
    save(c, 'skill-chains')


def stats_column_icons():
    """Third stats column: physical / magical / shield penetration (shield
    pierced by an arrow), HP regeneration (cross) and MP regeneration (drop)."""
    def medal(accent):
        n = 64
        c = Canvas(n, n)
        c.fill(circle(32, 32, 30), INK, alpha=0.9)
        c.fill(circle(32, 32, 27.5), lambda x, y: lerp(lerp(accent, (255, 255, 255), 0.25), lerp(accent, INK, 0.5), y / n))
        c.fill(ring(32, 32, 27.5, 1.4), gold_paint(n))
        return c
    light = (250, 244, 230)
    shield = polygon([(20, 16), (44, 16), (44, 34), (32, 50), (20, 34)])
    arrow = union(segment(12, 52, 50, 14, 2.4), polygon([(50, 14), (40, 16), (48, 24)]))
    for name, accent in (('icon-physpen', (214, 80, 70)), ('icon-magpen', (70, 120, 220)), ('icon-shieldpen', (200, 170, 90))):
        c = medal(accent)
        body = subtract(shield, offset(arrow, 1.6))
        c.fill(offset(union(shield, arrow), 2), INK, alpha=0.85)
        c.fill(body, light)
        c.fill(arrow, (255, 226, 140))
        save(c, name)
    c = medal((70, 170, 90))
    cross = union(box(32, 32, 6, 17, 2), box(32, 32, 17, 6, 2))
    c.fill(offset(cross, 2), INK, alpha=0.85)
    c.fill(cross, light)
    save(c, 'icon-hpregen')
    c = medal((70, 130, 230))
    drop = union(circle(32, 38, 12), polygon([(32, 12), (21, 34), (43, 34)]))
    c.fill(offset(drop, 2), INK, alpha=0.85)
    c.fill(drop, light)
    save(c, 'icon-mpregen')


def vip_frames():
    """VIP tier card frames: thin bronze / silver / gold metal edge, transparent
    inside (drawn over the card)."""
    W, H = 256, 288
    for name, light, dark in (('vip-frame-bronze', (236, 170, 110), (110, 60, 25)),
                              ('vip-frame-silver', (245, 247, 252), (110, 115, 128)),
                              ('vip-frame-gold', (255, 232, 150), (150, 98, 30))):
        c = Canvas(W, H)
        paint = lambda x, y, l=light, d=dark: lerp(l, d, (x + y) / (W + H))
        outer = subtract(box(W / 2, H / 2, W / 2 - 2, H / 2 - 2, 8), box(W / 2, H / 2, W / 2 - 7, H / 2 - 7, 5))
        inner = subtract(box(W / 2, H / 2, W / 2 - 10, H / 2 - 10, 3), box(W / 2, H / 2, W / 2 - 11, H / 2 - 11, 2))
        c.fill(offset(outer, 1.2), INK, alpha=0.8)
        c.fill(outer, paint)
        c.fill(inner, paint, alpha=0.6)
        save(c, name)

def column_mode_glyphs():
    """Stats-mode button: one, two or three stat columns."""
    for count in (1, 2, 3):
        width = 46.0 / count
        bars = [box(9 + width * (i + 0.5), 32, width * 0.5 - 2.6, 19, 1.5) for i in range(count)]
        glyph(lambda n, bars=bars: union(*bars) if len(bars) > 1 else bars[0], f'glyph-cols{count}')


def heart():
    """Red heart with a soft dark outline and a small highlight (VIP thanks)."""
    n = 64
    c = Canvas(n, n)
    shape = union(circle(22, 24, 13), circle(42, 24, 13), polygon([(10.5, 30), (53.5, 30), (32, 54)]))
    c.fill(offset(shape, 2.2), INK, alpha=0.85)
    c.fill(shape, lambda x, y: lerp((236, 64, 72), (150, 18, 30), y / n))
    c.fill(circle(19, 19, 4.5), (255, 255, 255), alpha=0.35)
    save(c, 'heart')


def build():
    tooltip_edge()
    menu_row()
    menu_edge()                                # menu panel: background starts at ~0.19 of a tile
    menu_edge('menu-edge-button', 0.42)        # menu buttons: background starts at ~0.42
    trade_button('btn-buy', 'BUY', (90, 200, 90), cart)
    trade_button('btn-sell', 'SELL', (220, 80, 70), trash_can)
    build_glyphs()
    damage_icons()
    trash_glyph()
    hover_blue()
    clean_tracks()
    hud_extra_icons()
    speed_icons()
    fast_toggles()
    pick_buttons()
    meter_fill()
    meter_fill_red()
    page_glyphs()
    stat_icons()
    ban_cover()
    skill_chains()
    stats_column_icons()
    vip_frames()
    column_mode_glyphs()
    heart()
    info_icons()


if __name__ == '__main__':
    build()
