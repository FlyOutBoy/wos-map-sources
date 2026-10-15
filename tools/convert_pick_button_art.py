"""Convert supplied Pick_Button.png / Random_Button.png into RGBA TGA imports."""
from pathlib import Path
import argparse
import hashlib
import json


def convert(source, destination):
    from PIL import Image, ImageEnhance, ImageOps
    destination.mkdir(parents=True, exist_ok=True)
    manifest = []
    for source_name, kind in [('Pick_Button.png', 'confirm'), ('Random_Button.png', 'random')]:
        original = source / source_name
        image = Image.open(original).convert('RGBA')
        # Discard only almost invisible alpha noise outside the supplied border.
        alpha = image.getchannel('A').point(lambda a: 0 if a <= 16 else a)
        image.putalpha(alpha)
        bounds = alpha.getbbox()
        if not bounds:
            raise ValueError('Empty button artwork: ' + str(original))
        image = image.crop(bounds).resize((512, 256), Image.Resampling.LANCZOS)
        disabled = ImageEnhance.Brightness(ImageOps.grayscale(image).convert('RGB')).enhance(0.55).convert('RGBA')
        disabled.putalpha(image.getchannel('A'))
        for suffix, result in [('', image), ('-off', disabled)]:
            name = f'pick-{kind}-wide{suffix}.tga'
            path = destination / name
            result.save(path, format='TGA', compression=None)
            manifest.append({'source': source_name, 'source_sha256': hashlib.sha256(original.read_bytes()).hexdigest(),
                             'crop': bounds, 'import': 'UI\\WOS\\' + name,
                             'sha256': hashlib.sha256(path.read_bytes()).hexdigest(), 'size': [512, 256], 'mode': 'RGBA'})
    (destination / 'pick-wide-manifest.json').write_text(json.dumps(manifest, indent=2) + '\n', encoding='utf-8')
    print('Four uncompressed 32-bit TGA textures written; old assets preserved')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', type=Path, required=True)
    parser.add_argument('--destination', type=Path, default=Path(__file__).resolve().parents[1] / 'assets/UI/WOS')
    args = parser.parse_args()
    convert(args.source, args.destination)
