"""Coloured-frame copies of hero icons for alternative skill sets (2026-11-03).

Grey (stock) frame = first skill set, gold = second, pale red = third.
Reads the BTN/DISBTN from the folder MAIN map, tints the outer frame of the BTN and
writes BTN<name>_Gold/_Red (+ an unchanged DISBTN copy) to assets/ReplaceableTextures,
then points the abilities' icon/research_icon at the copies in object-data/abilities.json.

    python tools/build_alt_frame_icons.py [--map <folder map .w3x>]
"""
from pathlib import Path
import argparse
import json
import shutil
from PIL import Image, ImageDraw
from build_item_icons import write_blp1

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'assets/ReplaceableTextures'
FRAMES = {'Gold': ((255, 196, 52), 1.0), 'Red': ((205, 92, 84), 0.78)}
# rawcode: frame
ABILITIES = {
    # Takeshi Yamamoto: defensive form Q2/W2/E2/R2, Q3
    'A08Z': 'Gold', 'A090': 'Gold', 'A091': 'Gold', 'A092': 'Gold', 'A093': 'Red',
    # Kenjaku
    'A05N': 'Gold', 'A05P': 'Gold', 'A05R': 'Gold', 'A05T': 'Gold',
    'A05O': 'Red', 'A05Q': 'Red', 'A05S': 'Red',
    # Mahoraga
    'A0CE': 'Gold', 'A0CG': 'Gold', 'A0CI': 'Gold', 'A0CJ': 'Red',
    # Ainz T form: TQ/TW/TE/TR
    'A0FJ': 'Gold', 'A0FN': 'Gold', 'A0FQ': 'Gold', 'A0FS': 'Gold',
    # Asta Q2/W2/TR/TT
    'A0DS': 'Gold', 'A0DT': 'Gold', 'A0DU': 'Gold', 'A0DV': 'Gold',
    # Inori EQ/EW/ER
    'A067': 'Gold', 'A069': 'Gold', 'A06B': 'Gold',
    # Toji Q2/Q3/W2 (Q1 keeps the stock frame)
    'A0GZ': 'Gold', 'A0H0': 'Red', 'A0H2': 'Gold',
}


def tint(image, colour, strength):
    img = image.convert('RGB')
    px = img.load()
    for y in range(64):
        for x in range(64):
            d = min(x, y, 63 - x, 63 - y)
            if d > 4:
                continue
            w = strength * (1.0 if d < 3 else 0.5)
            r, g, b = px[x, y]
            lum = (r * 0.3 + g * 0.59 + b * 0.11) / 255
            lit = 0.45 + 0.75 * lum if d < 3 else 1.0
            t = tuple(min(255, int(c * lit)) for c in colour)
            px[x, y] = tuple(int(o * (1 - w) + n * w) for o, n in zip((r, g, b), t))
    # thin dark inner line keeps the art separated from the frame
    ImageDraw.Draw(img).rectangle((5, 5, 58, 58), outline=(20, 14, 6))
    return img


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--map', type=Path)
    args = parser.parse_args()
    game = args.map or Path(json.loads((ROOT / '.vscode/wos-build.json').read_text(encoding='utf8'))['mainMap'])
    path = ROOT / 'object-data/abilities.json'
    data = json.loads(path.read_text(encoding='utf8'))
    for raw, frame in ABILITIES.items():
        obj = data[raw]
        icon = obj['icon']
        stem = icon.split('\\')[-1][:-4]
        for suffix in FRAMES:
            if stem.endswith('_' + suffix):
                stem = stem[:-len(suffix) - 1]
        name = f'{stem}_{frame}'
        src = game / 'ReplaceableTextures/CommandButtons' / f'{stem}.blp'
        dis = game / 'ReplaceableTextures/CommandButtonsDisabled' / f'DIS{stem}.blp'
        colour, strength = FRAMES[frame]
        write_blp1(tint(Image.open(src), colour, strength), OUT / 'CommandButtons' / f'{name}.blp')
        (OUT / 'CommandButtonsDisabled').mkdir(parents=True, exist_ok=True)
        shutil.copyfile(dis, OUT / 'CommandButtonsDisabled' / f'DIS{name}.blp')
        new = f'ReplaceableTextures\\CommandButtons\\{name}.blp'
        obj['icon'] = new
        if 'research_icon' in obj:
            obj['research_icon'] = new
        print(raw, frame, name)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf8')


if __name__ == '__main__':
    main()
