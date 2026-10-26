"""Crop Altair (Re:Creators) GIF frames from the hero design document for Button Manager Clear.

Run with Pillow. --gif-dir extracts the selected frames from the document GIFs
(img00.png .. img09.gif, in document order) into assets/altair_icons_src/frames.
--button-manager runs the installed Button Manager Clear on a private
configuration copy and copies BTN/DISBTN BLP files to assets/AltairTest only:
TEST imports them explicitly, MAIN asset installation never sees this folder.
"""
from pathlib import Path
import argparse
import json
import re
import shutil
import subprocess
import tempfile
import time
from PIL import Image, ImageEnhance, ImageOps, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT/'assets/altair_icons_src'
OUT = ROOT/'assets/AltairTest'
# slot: (document image, frame, fractional crop box)
ICONS = {
    'Icon': ('img00.png', 0, (.34,.00,.66,.62)),
    'Q':    ('img01.gif', 46, (.30,.00,.86,1.0)),
    'W':    ('img02.gif', 24, (.25,.00,.80,1.0)),
    'E':    ('img05.gif', 38, (.22,.00,.78,1.0)),
    'R':    ('img04.gif', 144, (.22,.00,.78,1.0)),
    'T':    ('img09.gif', 48, (.22,.00,.78,1.0)),
    'F':    ('img07.gif', 162, (.30,.00,.86,1.0)),
    'G':    ('img01.gif', 13, (.22,.00,.78,1.0)),
    'SQ':   ('img05.gif', 66, (.30,.00,.86,1.0)),
    'SW':   ('img05.gif', 0, (.00,.00,.56,1.0)),
    'SE':   ('img06.gif', 19, (.22,.00,.78,1.0)),
    'SR':   ('img05.gif', 28, (.22,.00,.78,1.0)),
    'ST':   ('img03.gif', 113, (.44,.10,1.0,1.0)),
    'SF':   ('img03.gif', 102, (.30,.10,.86,1.0)),
    'SG':   ('img08.gif', 16, (.24,.00,.70,.80)),
}
# Night frames need extra exposure to read at 64x64.
BRIGHTNESS = {'ST': 2.1, 'SF': 2.1, 'SW': 1.5, 'F': 1.3}
DOCUMENT = 'https://docs.google.com/document/d/1Br-1wiwCY5iTqmFx5Wnyy8dhQRFSd0Cz4Cfxu-x6FFU'


def frame_name(slot):
    image, frame, _ = ICONS[slot]
    return f'{Path(image).stem}_f{frame:03d}.png'


def extract(gif_dir):
    (SRC/'frames').mkdir(parents=True, exist_ok=True)
    for slot, (image, frame, _) in ICONS.items():
        with Image.open(gif_dir/image) as art:
            art.seek(min(frame, getattr(art, 'n_frames', 1)-1))
            art.convert('RGB').save(SRC/'frames'/frame_name(slot))
    print(f'{len(ICONS)} document frames extracted')


def build():
    (SRC/'cropped').mkdir(parents=True, exist_ok=True)
    preview = Image.new('RGB', (80*len(ICONS), 100), '#101a24')
    draw = ImageDraw.Draw(preview)
    sources = {}
    for i, (slot, (image, frame, box)) in enumerate(ICONS.items()):
        art = Image.open(SRC/'frames'/frame_name(slot)).convert('RGB')
        box = tuple(round(v*(art.width if k%2 == 0 else art.height)) for k, v in enumerate(box))
        art = ImageOps.fit(art.crop(box), (64,64), Image.Resampling.LANCZOS)
        art = ImageEnhance.Brightness(art).enhance(BRIGHTNESS.get(slot, 1.0))
        art = ImageEnhance.Contrast(art).enhance(1.12)
        art = ImageEnhance.Color(art).enhance(1.10)
        art.save(SRC/'cropped'/f'Hero_Altair_{slot}.tga')
        sources[slot] = {'document': DOCUMENT, 'image': image, 'frame': frame, 'crop_pixels': box}
        draw.text((i*80+4,4), slot, fill='white')
        preview.paste(art, (i*80+8,24))
    (SRC/'sources.json').write_text(json.dumps(sources, ensure_ascii=False, indent=2)+'\n', encoding='utf8')
    preview.save(SRC/'preview.png')
    print(f'{len(ICONS)} cropped icons prepared for Button Manager Clear')


def button_manager(directory):
    """Use a private configuration copy; never change the user's app settings."""
    (ROOT/'_build').mkdir(exist_ok=True)
    app = Path(tempfile.mkdtemp(prefix='altair-button-manager-', dir=ROOT/'_build'))
    for source in directory.iterdir():
        if source.is_file():
            shutil.copy2(source, app/source.name)
    for name in ('standard', 'custom'):
        shutil.copytree(directory/name, app/name, dirs_exist_ok=True)
    config = app/'ButtonManager.ini'
    settings = config.read_bytes().decode('cp1251')
    for key, value in {'AutoBorder':'1', 'AndSave':'1', 'AutoCreateDis':'1',
                       'AddBorderTags':'1', 'BorderType':'0', 'DefFormat':'3',
                       'BorderFolder':str(app/'custom')+'\\'}.items():
        settings, count = re.subn(r'(?m)^'+key+r'=.*$', lambda _:key+'='+value, settings)
        if count != 1:
            raise ValueError(f'Unexpected Button Manager configuration: {key}')
    config.write_bytes(settings.encode('cp1251'))
    expected = [SRC/'cropped'/f'{prefix}Hero_Altair_{slot}.blp'
                for slot in ICONS for prefix in ('BTN', 'DISBTN')]
    for path in expected:
        path.unlink(missing_ok=True)
    processes = []
    try:
        startup = subprocess.STARTUPINFO()
        startup.dwFlags |= subprocess.STARTF_USESHOWWINDOW
        startup.wShowWindow = 0
        for slot in ICONS:
            processes.append(subprocess.Popen([str(app/'ButtonManager.exe'),
                str(SRC/'cropped'/f'Hero_Altair_{slot}.tga')], cwd=app, startupinfo=startup))
        deadline = time.monotonic()+45
        while not all(path.exists() and path.stat().st_size > 128 for path in expected):
            if time.monotonic() >= deadline:
                raise RuntimeError('Button Manager did not produce all BTN/DISBTN icons')
            time.sleep(.1)
        # Let the auto-save finish before checking the complete image payloads.
        time.sleep(.5)
        preview = Image.new('RGB', (80*len(ICONS),190), '#101a24')
        draw = ImageDraw.Draw(preview)
        for i, slot in enumerate(ICONS):
            draw.text((i*80+4,4), slot, fill='white')
            for prefix, folder, y in [('BTN','CommandButtons',24), ('DISBTN','CommandButtonsDisabled',108)]:
                source = SRC/'cropped'/f'{prefix}Hero_Altair_{slot}.blp'
                with Image.open(source) as art:
                    if art.size != (64,64):
                        raise ValueError(f'Unexpected icon size: {source}')
                    preview.paste(art.convert('RGB'), (i*80+8,y))
                destination = OUT/'ReplaceableTextures'/folder/source.name
                destination.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(source, destination)
        preview.save(SRC/'preview.png')
        print(f'Button Manager Clear: {len(expected)} BLP icons saved and verified')
    finally:
        for process in processes:
            if process.poll() is None:
                process.terminate()
                process.wait(timeout=5)
        if not app.resolve().is_relative_to((ROOT/'_build').resolve()):
            raise ValueError('Button Manager temporary directory escaped _build')
        shutil.rmtree(app)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--gif-dir', type=Path, help='Directory with the document images img00..img09')
    parser.add_argument('--button-manager', type=Path, help='Existing Button Manager Clear directory')
    args = parser.parse_args()
    if args.gif_dir:
        extract(args.gif_dir)
    build()
    if args.button_manager:
        button_manager(args.button_manager.resolve())
