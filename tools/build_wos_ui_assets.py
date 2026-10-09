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
    print('Prepared 22 Warcraft UI textures:',OUT)

if __name__ == '__main__':
    build()
