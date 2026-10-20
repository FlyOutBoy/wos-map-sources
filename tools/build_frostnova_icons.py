"""Crop official PERISH IN FROST stills for Button Manager Clear.

Run with Pillow. --borders also makes deterministic BTN/DISBTN previews using
the original Button Manager Clear standard borders, matching build_item_icons.
Source URLs and crops are kept next to the frame assets.
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
from build_item_icons import apply_border, write_blp1

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT/'assets/frostnova_icons_src'
# Fractional crop boxes, each selected from the original anime still.
ICONS = {
    'Icon': ('14_01.01d2bd12.png', (.10,.02,.49,.72)),
    'Q': ('10_01.61a81040.png', (.59,.03,.99,.74)),
    'W': ('15_01.66f5b707.png', (.35,.02,.86,.93)),
    'E': ('09_05.fbf50caf.png', (.12,.04,.66,.99)),
    'R': ('10_01.61a81040.png', (.00,.07,.32,.95)),
    'T': ('10_01.61a81040.png', (.24,.00,.71,.83)),
    'F': ('16_05.fb3568fa.png', (.20,.03,.76,.99)),
}


def build(borders=False):
    (SRC/'cropped').mkdir(parents=True,exist_ok=True)
    preview=Image.new('RGB',(96*len(ICONS),210),'#101a24')
    draw=ImageDraw.Draw(preview)
    sources={}
    for i,(slot,(name,box)) in enumerate(ICONS.items()):
        art=Image.open(SRC/'frames'/name).convert('RGB')
        box=tuple(round(v*(art.width if k%2==0 else art.height)) for k,v in enumerate(box))
        art=ImageOps.fit(art.crop(box),(64,64),Image.Resampling.LANCZOS)
        art=ImageEnhance.Brightness(art).enhance(1.8 if slot=='W' else 1.28)
        art=ImageEnhance.Contrast(art).enhance(1.10)
        art=ImageEnhance.Color(art).enhance(1.12)
        art.save(SRC/'cropped'/f'Hero_Frostnova_{slot}.tga')
        sources[slot]={'url':'https://webusstatic.yo-star.com/ark_anime/assets/'+name,
                       'page':'https://arknights-anime.jp/','crop_pixels':box}
        draw.text((i*96+5,5),slot,fill='white')
        btn=apply_border(art,'bm_btn.tga')
        dis=apply_border(art,'bm_disbtn.tga',grey=True)
        preview.paste(btn.resize((80,80),Image.Resampling.NEAREST),(i*96+8,25))
        preview.paste(dis.resize((80,80),Image.Resampling.NEAREST),(i*96+8,120))
        if borders:
            write_blp1(btn,ROOT/'assets/ReplaceableTextures/CommandButtons'/f'BTNHero_Frostnova_{slot}.blp')
            write_blp1(dis,ROOT/'assets/ReplaceableTextures/CommandButtonsDisabled'/f'DISBTNHero_Frostnova_{slot}.blp')
    (SRC/'sources.json').write_text(json.dumps(sources,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
    preview.save(SRC/'preview.png')
    print(f'{len(ICONS)} cropped anime icons prepared for Button Manager Clear')


def button_manager(directory):
    """Use a private configuration copy; never change the user's app settings."""
    (ROOT/'_build').mkdir(exist_ok=True)
    app = Path(tempfile.mkdtemp(prefix='frostnova-button-manager-', dir=ROOT/'_build'))
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
    expected = [SRC/'cropped'/f'{prefix}Hero_Frostnova_{slot}.blp'
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
                str(SRC/'cropped'/f'Hero_Frostnova_{slot}.tga')], cwd=app, startupinfo=startup))
        deadline = time.monotonic()+30
        while not all(path.exists() and path.stat().st_size > 128 for path in expected):
            if time.monotonic() >= deadline:
                raise RuntimeError('Button Manager did not produce all BTN/DISBTN icons')
            time.sleep(.1)
        # Let the auto-save finish before checking the complete image payloads.
        time.sleep(.5)
        preview = Image.new('RGB', (96*len(ICONS),210), '#101a24')
        draw = ImageDraw.Draw(preview)
        for i,slot in enumerate(ICONS):
            draw.text((i*96+5,5),slot,fill='white')
            for prefix,folder,y in [('BTN','CommandButtons',25),('DISBTN','CommandButtonsDisabled',120)]:
                source=SRC/'cropped'/f'{prefix}Hero_Frostnova_{slot}.blp'
                with Image.open(source) as art:
                    if art.size != (64,64):
                        raise ValueError(f'Unexpected icon size: {source}')
                    preview.paste(art.convert('RGB').resize((80,80)),(i*96+8,y))
                destination=ROOT/'assets/ReplaceableTextures'/folder/source.name
                destination.parent.mkdir(parents=True,exist_ok=True)
                shutil.copy2(source,destination)
        preview.save(SRC/'preview.png')
        print('Button Manager Clear: 14 BLP icons saved and verified')
    finally:
        for process in processes:
            if process.poll() is None:
                process.terminate()
                process.wait(timeout=5)
        if not app.resolve().is_relative_to((ROOT/'_build').resolve()):
            raise ValueError('Button Manager temporary directory escaped _build')
        shutil.rmtree(app)


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--borders',action='store_true')
    parser.add_argument('--button-manager',type=Path,help='Existing Button Manager Clear directory')
    args=parser.parse_args()
    build(args.borders)
    if args.button_manager:
        button_manager(args.button_manager.resolve())
