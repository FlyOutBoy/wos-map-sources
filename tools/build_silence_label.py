"""Rasterize the HUD's Silence wordmark in the existing antique-gold palette."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter

ROOT = Path(__file__).resolve().parents[1]


def build():
    fonts = [Path('C:/Windows/Fonts/constanb.ttf'), Path('C:/Windows/Fonts/georgiab.ttf')]
    font_path = next((p for p in fonts if p.is_file()), None)
    font = ImageFont.truetype(str(font_path) if font_path else 'DejaVuSerif-Bold.ttf', 96)
    text = 'Silence'
    mask = Image.new('L', (512, 128))
    draw = ImageDraw.Draw(mask)
    box = draw.textbbox((0, 0), text, font=font, stroke_width=1)
    x = (512 - (box[2] - box[0])) / 2 - box[0]
    y = (128 - (box[3] - box[1])) / 2 - box[1]
    draw.text((x, y), text, font=font, fill=255, stroke_width=1)
    shadow = Image.new('RGBA', mask.size, (0, 0, 0, 0))
    shadow.putalpha(mask.filter(ImageFilter.GaussianBlur(3)))
    letters = Image.new('RGBA', mask.size)
    painter = ImageDraw.Draw(letters)
    for row in range(128):
        ratio = row / 127
        color = tuple(round(a + (b-a)*ratio) for a, b in zip((248, 226, 166), (179, 133, 66)))
        painter.line((0, row, 511, row), fill=(*color, 255))
    letters.putalpha(mask)
    Image.alpha_composite(shadow, letters).save(ROOT/'assets/UI/WOS/silence-label.tga')


if __name__ == '__main__':
    build()
