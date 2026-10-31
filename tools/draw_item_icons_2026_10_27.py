"""Helper sources for the 2026-10-27 item icons (assets/item_icons_src/).

The item pictures now are fandom wiki frames (*_art.png, see SOURCES in build_item_icons.py).
This script still writes gold_frame.png (cut from the Lust Sin / Lust Sin Evolved pair) and
the base copies used by the Evolved icons; the procedural drawings are a no-download fallback
(their PNGs are not referenced by ICONS).

    python tools/draw_item_icons_2026_10_27.py <unpacked MAIN map dir>
"""
from pathlib import Path
import math
import sys

from PIL import Image, ImageChops, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / 'assets/item_icons_src'
FONT = r'C:\Windows\Fonts\YuGothB.ttc'
N = 128


def radial(inner, outer, cx=0.5, cy=0.5, power=1.2):
    img = Image.new('RGB', (N, N))
    px = img.load()
    for y in range(N):
        for x in range(N):
            d = min(1.0, math.hypot(x / N - cx, y / N - cy) / 0.72) ** power
            px[x, y] = tuple(round(a + (b - a) * d) for a, b in zip(inner, outer))
    return img


def glow(img, shape_fn, colour, radius=7):
    layer = Image.new('RGBA', (N, N), (0, 0, 0, 0))
    shape_fn(ImageDraw.Draw(layer), colour)
    halo = layer.filter(ImageFilter.GaussianBlur(radius))
    img.paste(halo, (0, 0), halo)
    img.paste(layer, (0, 0), layer)


def kanji(img, char, colour, size=88, shadow=(0, 0, 0), dy=0, alpha=255):
    font = ImageFont.truetype(FONT, size)
    layer = Image.new('RGBA', (N, N), (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    box = draw.textbbox((0, 0), char, font=font)
    x = (N - (box[2] - box[0])) / 2 - box[0]
    y = (N - (box[3] - box[1])) / 2 - box[1] + dy
    draw.text((x + 3, y + 3), char, font=font, fill=shadow + (alpha,))
    draw.text((x, y), char, font=font, fill=colour + (alpha,))
    img.paste(layer, (0, 0), layer)


def armament_haki():
    img = radial((70, 20, 90), (5, 0, 10))
    def bolts(d, c):
        for pts in (((14, 30), (34, 46), (26, 52), (48, 74)), ((112, 24), (92, 44), (102, 50), (80, 76)),
                    ((20, 104), (42, 92), (36, 86), (58, 76))):
            d.line(pts, fill=c, width=3)
    glow(img, bolts, (220, 60, 255, 255), 5)
    def fist(d, c):
        d.rounded_rectangle((34, 46, 96, 104), 18, fill=c)
        for i in range(4):
            d.ellipse((34 + i * 15, 34, 52 + i * 15, 58), fill=c)
        d.rounded_rectangle((22, 62, 46, 90), 10, fill=c)
    glow(img, fist, (12, 10, 16, 255), 9)
    d = ImageDraw.Draw(img)
    for i in range(4):
        d.arc((37 + i * 15, 37, 49 + i * 15, 52), 200, 320, fill=(150, 130, 170), width=2)
    d.line((44, 70, 86, 70), fill=(60, 55, 70), width=2)
    d.arc((40, 52, 92, 100), 210, 300, fill=(120, 110, 140), width=3)
    return img


def sukuna_finger():
    img = radial((150, 10, 10), (20, 0, 0))
    finger = Image.new('RGBA', (N, N), (0, 0, 0, 0))
    d = ImageDraw.Draw(finger)
    d.rounded_rectangle((50, 10, 78, 118), 14, fill=(196, 160, 132, 255))
    d.rounded_rectangle((53, 12, 75, 34), 9, fill=(40, 20, 20, 255))
    for y in (48, 80):
        d.line((52, y, 76, y), fill=(90, 50, 40, 255), width=3)
    d.line((58, 38, 70, 112), fill=(150, 110, 90, 255), width=2)
    finger = finger.rotate(-28, resample=Image.Resampling.BICUBIC)
    halo = finger.filter(ImageFilter.GaussianBlur(8))
    red = Image.new('RGBA', (N, N), (255, 40, 30, 0))
    red.putalpha(halo.split()[3])
    img.paste(red, (0, 0), red)
    img.paste(finger, (0, 0), finger)
    kanji(img, '呪', (255, 220, 200), 34, dy=40, alpha=200)
    return img


def five_elements_seal():
    img = radial((10, 40, 90), (0, 5, 20))
    def seal(d, c):
        d.ellipse((14, 14, 114, 114), outline=c, width=4)
        d.ellipse((28, 28, 100, 100), outline=c, width=2)
        pts = [(64 + 46 * math.cos(math.radians(-90 + 72 * i)), 64 + 46 * math.sin(math.radians(-90 + 72 * i))) for i in range(5)]
        for i in range(5):
            d.line((pts[i], pts[(i + 2) % 5]), fill=c, width=2)
            d.ellipse((pts[i][0] - 6, pts[i][1] - 6, pts[i][0] + 6, pts[i][1] + 6), fill=c)
    glow(img, seal, (90, 230, 255, 255), 6)
    kanji(img, '封', (255, 255, 255), 54, shadow=(0, 40, 90))
    return img


def tekkai():
    img = Image.new('RGB', (N, N))
    px = img.load()
    for y in range(N):
        for x in range(N):
            t = (x + y) / (2 * N)
            v = round(150 - 90 * t + 18 * math.sin(x / 6.0))
            px[x, y] = (v, v + 4, v + 10)
    d = ImageDraw.Draw(img)
    for cx, cy in ((14, 14), (114, 14), (14, 114), (114, 114)):
        d.ellipse((cx - 6, cy - 6, cx + 6, cy + 6), fill=(70, 72, 80), outline=(200, 205, 215))
    kanji(img, '鉄', (36, 38, 46), 86, shadow=(220, 225, 235))
    return img


def samehada():
    img = radial((20, 70, 90), (0, 10, 20))
    blade = Image.new('RGBA', (N, N), (0, 0, 0, 0))
    d = ImageDraw.Draw(blade)
    d.rounded_rectangle((52, 4, 78, 100), 10, fill=(40, 110, 170, 255))
    for row in range(10):
        for col in range(3):
            x = 54 + col * 8 + (row % 2) * 4
            y = 8 + row * 9
            d.polygon(((x, y), (x + 6, y + 3), (x, y + 7)), fill=(150, 210, 240, 255))
    d.rectangle((58, 98, 72, 124), fill=(230, 225, 210, 255))
    for y in range(100, 124, 5):
        d.line((58, y, 72, y + 3), fill=(150, 140, 120, 255), width=1)
    blade = blade.rotate(35, resample=Image.Resampling.BICUBIC)
    halo = blade.filter(ImageFilter.GaussianBlur(6))
    img.paste(halo, (0, 0), halo)
    img.paste(blade, (0, 0), blade)
    return img


def will_of_d():
    img = radial((190, 20, 20), (40, 0, 0))
    d = ImageDraw.Draw(img)
    d.ellipse((12, 30, 116, 62), fill=(232, 190, 70), outline=(120, 80, 20), width=2)
    d.chord((34, 8, 94, 62), 180, 360, fill=(240, 200, 80), outline=(120, 80, 20), width=2)
    d.rectangle((35, 36, 93, 44), fill=(200, 30, 30))
    kanji(img, 'D', (255, 255, 255), 64, shadow=(0, 0, 0), dy=24)
    return img


def kairoseki():
    img = radial((60, 80, 110), (10, 14, 24))
    def cuffs(d, c):
        d.ellipse((12, 40, 62, 90), outline=c, width=9)
        d.ellipse((66, 40, 116, 90), outline=c, width=9)
        for i in range(3):
            d.ellipse((52 + i * 8, 58, 62 + i * 8, 70), outline=c, width=3)
    glow(img, cuffs, (150, 175, 205, 255), 5)
    d = ImageDraw.Draw(img)
    d.arc((16, 44, 58, 86), 200, 300, fill=(230, 240, 255), width=3)
    d.arc((70, 44, 112, 86), 200, 300, fill=(230, 240, 255), width=3)
    kanji(img, '海', (200, 230, 255), 28, dy=44, alpha=220)
    return img


def ice_coffin():
    img = radial((30, 70, 140), (0, 6, 30))
    def crystal(d, c):
        pts = [(64 + 44 * math.cos(math.radians(30 + 60 * i)), 64 + 54 * math.sin(math.radians(30 + 60 * i))) for i in range(6)]
        d.polygon(pts, fill=c)
    glow(img, crystal, (150, 220, 255, 255), 10)
    d = ImageDraw.Draw(img)
    for i in range(6):
        a = math.radians(30 + 60 * i)
        d.line((64, 64, 64 + 44 * math.cos(a), 64 + 54 * math.sin(a)), fill=(235, 250, 255), width=2)
    kanji(img, '氷', (20, 60, 120), 58, shadow=(230, 250, 255))
    return img


def return_by_death():
    img = radial((70, 10, 90), (5, 0, 12))
    def clock(d, c):
        d.ellipse((22, 22, 106, 106), outline=c, width=5)
        for i in range(12):
            a = math.radians(30 * i)
            d.line((64 + 34 * math.cos(a), 64 + 34 * math.sin(a), 64 + 40 * math.cos(a), 64 + 40 * math.sin(a)), fill=c, width=2)
        d.line((64, 64, 64, 34), fill=c, width=4)
        d.line((64, 64, 86, 74), fill=c, width=3)
    glow(img, clock, (240, 230, 255, 255), 6)
    def arrow(d, c):
        d.arc((10, 10, 118, 118), 200, 340, fill=c, width=6)
        d.polygon(((10, 66), (2, 50), (22, 52)), fill=c)
    glow(img, arrow, (255, 60, 200, 255), 5)
    return img


def gold_frame(map_dir):
    base = Image.open(map_dir / 'ReplaceableTextures/CommandButtons/BTNItem_LustSin.blp').convert('RGB').resize((64, 64))
    gold = Image.open(map_dir / 'ReplaceableTextures/CommandButtons/BTNItem_LustSin2.blp').convert('RGB').resize((64, 64))
    diff = ImageChops.difference(base, gold).convert('L')
    frame = Image.new('RGBA', (64, 64), (0, 0, 0, 0))
    fp, gp, dp = frame.load(), gold.load(), diff.load()
    for y in range(64):
        for x in range(64):
            edge = min(x, y, 63 - x, 63 - y)
            if edge <= 5 and dp[x, y] > 24:
                fp[x, y] = gp[x, y] + (255,)
    frame.save(SRC / 'gold_frame.png')


def copy_button(map_dir, blp, name):
    Image.open(map_dir / 'ReplaceableTextures/CommandButtons' / blp).convert('RGB').resize((N, N)).save(SRC / name)


def main():
    map_dir = Path(sys.argv[1])
    SRC.mkdir(parents=True, exist_ok=True)
    for name, fn in (('armament_haki.png', armament_haki), ('sukuna_finger.png', sukuna_finger),
                     ('five_elements_seal.png', five_elements_seal), ('tekkai.png', tekkai),
                     ('samehada.png', samehada), ('will_of_d.png', will_of_d), ('kairoseki.png', kairoseki),
                     ('ice_coffin.png', ice_coffin), ('return_by_death.png', return_by_death)):
        fn().save(SRC / name)
    copy_button(map_dir, 'BTNItem_NaofumiShield.blp', 'naofumi_shield_btn.png')
    copy_button(map_dir, 'BTNItem_FairyTail.blp', 'fairy_tail_btn.png')
    gold_frame(map_dir)
    print('ok')


if __name__ == '__main__':
    main()
