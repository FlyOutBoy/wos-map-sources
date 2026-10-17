"""Build deterministic WUI-style damage fills. No image library or map writes."""
from pathlib import Path
import struct

ROOT = Path(__file__).resolve().parents[1]
# Same slot palette as Systems1.GetPlayerColorString; dark enough for pale text.
COLORS = ('FF0303', '0042FF', '1CE6B9', '54007F', 'FFFC01',
          'FF8401', '20C000', 'E55BB0', '959697', '7EBFF1')
NAMES = tuple(f'damage-fill-{i}' for i in range(10)) + (
    'damage-row-edge', 'damage-icon-edge', 'damage-window-edge')


def outline(width, height):
    """One-pixel border with a fully transparent interior; never a white tint."""
    header = struct.pack('<BBBHHBHHHHBB', 0, 0, 2, 0, 0, 0,
                         0, 0, width, height, 32, 0x28)
    pixels = bytearray()
    for y in range(height):
        for x in range(width):
            pixels.extend((78, 130, 151, 190) if x in (0, width-1) or y in (0, height-1)
                          else (0, 0, 0, 0))
    return header + pixels


def texture(color):
    width, height = 256, 16
    rgb = tuple(int(color[i:i+2], 16) for i in (0, 2, 4))
    luminance = sum(v * w for v, w in zip(rgb, (.2126, .7152, .0722)))
    exposure = min(1.0, 125 / max(1.0, luminance))
    header = struct.pack('<BBBHHBHHHHBB', 0, 0, 2, 0, 0, 0,
                         0, 0, width, height, 32, 0x28)
    pixels = bytearray()
    for y in range(height):
        # Soft top light and lower shadow, matching the existing hero meter.
        light = .68 + .20 * (1 - y / (height - 1))
        for _ in range(width):
            r, g, b = (min(255, round(v * light * exposure + 10)) for v in rgb)
            pixels.extend((b, g, r, 255))
    return header + pixels


def build():
    folder = ROOT / 'assets/UI/WOS'
    for name, color in zip(NAMES, COLORS):
        (folder / (name + '.tga')).write_bytes(texture(color))
    for name, size in [('damage-row-edge', (256, 64)),
                       ('damage-icon-edge', (64, 64)),
                       ('damage-window-edge', (512, 512))]:
        (folder / (name + '.tga')).write_bytes(outline(*size))
    print(f'DamageStats textures: {len(NAMES)}')


if __name__ == '__main__':
    build()
