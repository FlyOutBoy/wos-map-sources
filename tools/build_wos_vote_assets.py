"""Convert the versioned generated PNG art into Warcraft RGBA TGA assets."""
from pathlib import Path
import png_tga
from build_wos_ui_textures_cp23 import hover_blue, meter_fill_red

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'assets/UI/WOS'

def main():
    for name, width, height in [('invis-label', 512, 128), ('vote-ff', 256, 256), ('vote-kick', 256, 256)]:
        original = png_tga.read_png(OUT / 'source' / f'{name}-20261016.png')
        image = png_tga.crop(original, png_tga.alpha_bbox(original))
        scale = min(width * .94 / image[0], height * .94 / image[1])
        image = png_tga.resize(image, max(1, round(image[0] * scale)), max(1, round(image[1] * scale)))
        png_tga.write_tga(png_tga.pad(image, width, height), OUT / f'{name}.tga')
    meter_fill_red()
    hover_blue()

if __name__ == '__main__':
    main()
