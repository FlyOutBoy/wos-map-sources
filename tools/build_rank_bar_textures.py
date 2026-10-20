"""Career rank bar textures (History window).

rank-fill-<rank>-<step>.tga - glossy fill blended from rank colour to the next one
                              (rank 0..4, step 0..9); vertex colour does not tint BACKDROPs.
rank-gold.tga               - SOUL KING fill: rich gold with a soft shine band and sparkles.
Uncompressed 32-bit TGA (Warcraft III does not read RLE TGA).

    python tools/build_rank_bar_textures.py [--preview out.png]
"""
from pathlib import Path
import argparse
import math
import random

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'assets/UI/WOS'
W, H = 256, 16
FILL_W, FILL_H = 128, 8
STEPS = 10
# NOOB green, NORMAL orange, ADVANCED blue, EXPERT purple, MASTER red, (SOUL KING gold).
RANK_COLOURS = [(86, 214, 92), (255, 150, 40), (72, 168, 255), (176, 96, 255), (255, 82, 82), (255, 206, 74)]


def lerp(a, b, t):
    return tuple(int(round(a[i] + (b[i] - a[i]) * t)) for i in range(len(a)))


def shade(v):
    """Glossy vertical profile 0..1 -> brightness multiplier."""
    if v < 0.3:
        return 1.18 - v * 0.6
    if v < 0.8:
        return 1.0 - (v - 0.3) * 0.3
    return 0.85 - (v - 0.8) * 1.4


def fill_texture(colour):
    image = Image.new('RGBA', (FILL_W, FILL_H))
    px = image.load()
    for y in range(FILL_H):
        k = shade(y / (FILL_H - 1))
        top = 1.0 if y == 0 else 0.0
        r, g, b = (min(255, int(c * k + (255 - c) * 0.35 * top)) for c in colour)
        for x in range(FILL_W):
            px[x, y] = (r, g, b, 255)
    return image


def gold_texture():
    random.seed(19)
    image = Image.new('RGBA', (W, H))
    px = image.load()
    stops = [(0.0, (255, 246, 196)), (0.22, (255, 214, 92)), (0.55, (214, 150, 34)),
             (0.82, (150, 92, 14)), (1.0, (96, 56, 8))]
    for y in range(H):
        v = y / (H - 1)
        for i in range(len(stops) - 1):
            if stops[i][0] <= v <= stops[i + 1][0]:
                t = (v - stops[i][0]) / (stops[i + 1][0] - stops[i][0])
                base = lerp(stops[i][1], stops[i + 1][1], t)
                break
        for x in range(W):
            phase = ((x + y * 2) % 64) / 64.0
            shine = max(0.0, 1.0 - abs(phase - 0.5) * 7.0) * 0.55
            shimmer = 0.06 * math.sin(x * 0.19)
            r, g, b = (min(255, int(c + (255 - c) * shine + c * shimmer)) for c in base)
            px[x, y] = (r, g, b, 255)
    for _ in range(26):
        x, y = random.randrange(2, W - 2), random.randrange(2, H - 3)
        for dx, dy, a in ((0, 0, 1.0), (1, 0, 0.5), (-1, 0, 0.5), (0, 1, 0.5), (0, -1, 0.5)):
            r, g, b, _ = px[x + dx, y + dy]
            px[x + dx, y + dy] = (int(r + (255 - r) * a), int(g + (255 - g) * a), int(b + (240 - b) * a), 255)
    return image


def names():
    return [f'rank-fill-{rank}-{step}' for rank in range(5) for step in range(STEPS)] + ['rank-gold']


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--preview')
    args = parser.parse_args()
    OUT.mkdir(parents=True, exist_ok=True)
    old = OUT / 'rank-fill.tga'
    if old.exists():
        old.unlink()
    strip = []
    for rank in range(5):
        for step in range(STEPS):
            colour = lerp(RANK_COLOURS[rank], RANK_COLOURS[rank + 1], step / (STEPS - 1))
            image = fill_texture(colour)
            image.save(OUT / f'rank-fill-{rank}-{step}.tga', compression=None)
            strip.append(image)
    gold = gold_texture()
    gold.save(OUT / 'rank-gold.tga', compression=None)
    if args.preview:
        cell = 12
        sheet = Image.new('RGBA', (cell * len(strip), cell * 2 + H * 2 + 8), (20, 20, 24, 255))
        for i, image in enumerate(strip):
            sheet.paste(image.resize((cell, cell * 2), Image.NEAREST), (i * cell, 0))
        sheet.paste(gold.resize((cell * len(strip), H * 2), Image.NEAREST), (0, cell * 2 + 8))
        sheet.save(args.preview)
    print(f'{len(strip)} fill steps + rank-gold.tga written to', OUT)


if __name__ == '__main__':
    main()
