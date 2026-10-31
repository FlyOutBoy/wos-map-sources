"""AUTOBUY toggle fills: green while on, red while off (64x64 RGBA, gradient like fill-normal).

    python tools/build_autobuy_fills.py
"""
from pathlib import Path

import png_tga

ROOT = Path(__file__).resolve().parents[1]
FILLS = {'autobuy-on': ((46, 150, 64), (18, 70, 28)), 'autobuy-off': ((176, 44, 40), (84, 16, 16))}


def build():
    for name, (top, bottom) in FILLS.items():
        rows = []
        for y in range(64):
            t = y / 63
            r, g, b = (round(a + (c - a) * t) for a, c in zip(top, bottom))
            rows.append(bytearray(bytes((r, g, b, 255)) * 64))
        png_tga.write_tga((64, 64, rows), ROOT / f'assets/UI/WOS/{name}.tga')
    return list(FILLS)


if __name__ == '__main__':
    print(build())
