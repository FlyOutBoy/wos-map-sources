"""Prepare the generated graphite material and deterministic alpha UI states."""
from pathlib import Path
from PIL import Image,ImageDraw

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT/'assets/UI/WOS'

def build():
    # Pixel alpha works even when BACKDROP vertex tint is ignored. Keeping
    # container alpha at 255 also keeps all its children visible.
    Image.new('RGBA', (32,32), (0,0,0,0)).save(OUT/'empty.tga')
    # Format/downscale only; keep the original built-in imagegen source unchanged.
    Image.open(OUT/'source/graphite.png').convert('RGBA').resize((512,512),Image.Resampling.LANCZOS).save(OUT/'panel.tga')
    edge = Image.new('RGBA',(128,128))
    draw = ImageDraw.Draw(edge)
    draw.rectangle((1,1,126,126),outline=(179,149,83,230),width=1)
    draw.line((4,3,123,3),fill=(240,213,147,70))
    edge.save(OUT/'border.tga')
    for name,fill,line in [('button',(17,23,32,245),(94,92,78,230)),('hover',(33,38,47,250),(210,180,114,255)),
                           ('pressed',(10,14,21,250),(170,137,69,255)),('selected',(29,29,29,250),(232,194,108,255)),
                           ('disabled',(17,20,24,150),(76,80,87,160))]:
        image = Image.new('RGBA',(128,128))
        draw = ImageDraw.Draw(image)
        draw.rounded_rectangle((1,1,126,126),radius=5,fill=fill,outline=line,width=1)
        image.save(OUT/(name+'.tga'))
    # Established UI icon system: deterministic gold glyphs on matching dark
    # buttons, with alpha outside the rounded outline. No stock item/shop icon.
    for name in ('shop', 'community', 'chat', 'emotes', 'ping', 'ping-muted'):
        image = Image.open(OUT/'button.tga').convert('RGBA')
        draw = ImageDraw.Draw(image)
        gold = (221, 191, 124, 255)
        if name == 'shop':
            draw.line((24, 30, 35, 30, 46, 83, 96, 83), fill=gold, width=6)
            draw.line((40, 42, 102, 42, 93, 70, 46, 70), fill=gold, width=6)
            for x in (53, 71, 89):
                draw.line((x, 45, x-3, 68), fill=gold, width=3)
            for x in (51, 88):
                draw.ellipse((x-5, 92, x+5, 102), fill=gold)
        elif name in ('community', 'chat'):
            draw.rounded_rectangle((24, 30, 104, 87), radius=19, outline=gold, width=6)
            draw.line((43, 86, 35, 103, 66, 87), fill=gold, width=5)
            if name == 'community':
                for x in (47, 64, 81):
                    draw.ellipse((x-4, 54, x+4, 62), fill=gold)
            else:
                for x in (48, 80):
                    draw.ellipse((x-3, 46, x+3, 52), fill=gold)
                draw.arc((44, 49, 84, 75), 0, 180, fill=gold, width=5)
        elif name == 'emotes':
            draw.ellipse((26, 26, 102, 102), outline=gold, width=6)
            for x in (48, 80):
                draw.ellipse((x-4, 44, x+4, 52), fill=gold)
            draw.arc((43, 49, 85, 84), 0, 180, fill=gold, width=6)
        else:
            draw.ellipse((41, 41, 87, 87), outline=gold, width=5)
            draw.ellipse((57, 57, 71, 71), fill=gold)
            for line in ((64, 23, 64, 43), (64, 85, 64, 105), (23, 64, 43, 64), (85, 64, 105, 64)):
                draw.line(line, fill=gold, width=5)
            if name == 'ping-muted':
                draw.line((28, 99, 99, 28), fill=(240, 179, 96, 255), width=7)
        image.save(OUT/('toolbar-'+name+'.tga'))
    for name, checked in [('checked', True), ('unchecked', False)]:
        image = Image.new('RGBA', (64, 64))
        draw = ImageDraw.Draw(image)
        draw.rounded_rectangle((8, 8, 55, 55), radius=4, fill=(15, 20, 28, 220), outline=(179, 149, 83, 245), width=2)
        if checked:
            draw.line((18, 31, 28, 41, 46, 22), fill=(221, 191, 124, 255), width=5)
        image.save(OUT/(name+'.tga'))
    for name,color in [('hp',(83,190,97)),('mp',(70,139,226)),('meter',(176,143,74)),('bar-back',(22,29,40))]:
        image = Image.new('RGBA',(256,16))
        draw = ImageDraw.Draw(image)
        for y in range(16):
            factor = .90 + .16*(1-y/15)
            draw.line((0,y,255,y),fill=(*[min(255,round(c*factor)) for c in color],255))
        image.save(OUT/(name+'.tga'))
    # Slice the generated ornament without repainting its gold/metal details.
    # Corners keep their aspect ratio. Uniform rails stretch separately.
    ornament = Image.open(OUT/'source/ornate-frame.png').convert('RGBA')
    w, h = ornament.size
    boxes = {
        'ornate-tl': (0,0,w//4,h//4), 'ornate-tr': (w*3//4,0,w,h//4),
        'ornate-bl': (0,h*3//4,w//4,h), 'ornate-br': (w*3//4,h*3//4,w,h),
        'ornate-top': (w*3//10,h*5//100,w*4//10,h*9//100),
        'ornate-bottom': (w*3//10,h*89//100,w*4//10,h*93//100),
        'ornate-left': (w*3//100,h*3//10,w*7//100,h*4//10),
        'ornate-right': (w*93//100,h*3//10,w*97//100,h*4//10),
    }
    for name, box in boxes.items():
        size = (256,256) if name[-2:] in ('tl','tr','bl','br') else ((128,32) if name.endswith(('top','bottom')) else (32,128))
        ornament.crop(box).resize(size,Image.Resampling.LANCZOS).save(OUT/(name+'.tga'))
    print('Prepared 28 Warcraft UI textures:',OUT)

if __name__ == '__main__':
    build()
    # Checkpoint 20: clean rails rebuilt from the corner art + new HUD textures.
    from build_wos_ui_textures_cp20 import build as build_checkpoint20
    build_checkpoint20()
    # Checkpoint 21: stat medallions, attack types, wheels, fields, glows.
    from build_wos_ui_textures_cp21 import build as build_checkpoint21
    build_checkpoint21()
