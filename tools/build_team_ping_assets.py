"""Render the existing vector command symbols as alpha-channel Warcraft TGA assets.

Run with the bundled Python/Pillow runtime; generated assets are stored in the
project, so map builds need no extra image dependencies.
"""
from pathlib import Path
import math
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT/'assets/UI/TeamPings'
SIZE, AA = 256, 4
COLORS = [(80,217,255),(255,120,80),(255,210,80),(112,239,144),(189,154,255)]
NAMES = ['move','attack','danger','help','rally']
ANGLES = [-90,-18,54,126,198]
LABELS = ['On my way','Attack','Danger','Need help','Group up here']


def point(radius, angle):
    angle = math.radians(angle)
    return 128+radius*math.cos(angle),128+radius*math.sin(angle)


def arc(radius, begin, end):
    return [point(radius,begin+(end-begin)*i/90) for i in range(91)]


def glyph(draw, index, cx, cy, color, scale=1):
    def coords(points):
        return [((cx+x*scale)*AA,(cy+y*scale)*AA) for x,y in points]
    def line(points,width=3):
        draw.line(coords(points),fill=(*color,255),width=max(1,round(width*scale*AA)),joint='curve')
    def ellipse(box,**kwargs):
        draw.ellipse(coords([(box[0],box[1]),(box[2],box[3])]),**kwargs)
    if index == 0:
        line([(0,13),(0,-14)],4)
        line([(-10,-3),(0,-14),(10,-3)],4)
        line([(-6,14),(0,8),(6,14)],2)
    elif index == 1:
        line([(-12,12),(12,-12)],4)
        line([(-12,-12),(12,12)],4)
        line([(-15,5),(-5,15)],3)
        line([(5,15),(15,5)],3)
    elif index == 2:
        line([(-15,12),(0,-15),(15,12),(-15,12)],3)
        line([(0,-5),(0,3)],3)
        ellipse((-2,7,2,11),fill=(*color,255))
    elif index == 3:
        line([(0,-13),(0,13)],5)
        line([(-13,0),(13,0)],5)
        ellipse((-19,-19,19,19),outline=(*color,180),width=max(1,round(scale*AA)))
    else:
        for x,y in [(-13,-9),(13,-9),(0,13)]:
            ellipse((x-4,y-4,x+4,y+4),fill=(*color,255))
        line([(-9,-4),(-3,2)],2)
        line([(9,-4),(3,2)],2)
        line([(0,8),(0,2)],2)
        line([(-5,3),(0,-2),(5,3)],2)


def draw_sector(index):
    image = Image.new('RGBA',(SIZE*AA,SIZE*AA))
    draw = ImageDraw.Draw(image)
    color,angle = COLORS[index],ANGLES[index]
    points = [(x*AA,y*AA) for x,y in arc(121,angle-34,angle+34)+arc(46,angle+34,angle-34)]
    draw.polygon(points,fill=(12,24,36,242))
    draw.line(points+[points[0]],fill=(*color,225),width=2*AA,joint='curve')
    draw.line([(x*AA,y*AA) for x,y in arc(116,angle-31,angle+31)],fill=(*color,95),width=2*AA)
    glyph(draw,index,*point(64,angle),color,scale=.8)
    return image.resize((SIZE,SIZE),Image.Resampling.LANCZOS)


def symbol(index):
    image = Image.new('RGBA',(SIZE*AA,SIZE*AA))
    glyph(ImageDraw.Draw(image),index,128,128,COLORS[index],scale=5.1)
    return image.resize((SIZE,SIZE),Image.Resampling.LANCZOS)


def toolbar(kind):
    image = Image.new('RGBA',(SIZE*AA,SIZE*AA))
    draw = ImageDraw.Draw(image)
    color = (185,210,219,230)
    def line(points,fill=color,width=9):
        draw.line([(x*AA,y*AA) for x,y in points],fill=fill,width=width*AA,joint='curve')
    def ellipse(box,**kwargs):
        draw.ellipse(tuple(v*AA for v in box),**kwargs)
    if kind.startswith('ping'):
        ellipse((63,63,193,193),outline=color,width=7*AA)
        ellipse((103,103,153,153),outline=color,width=7*AA)
        for points in [[(128,30),(128,63)],[(128,193),(128,226)],[(30,128),(63,128)],[(193,128),(226,128)]]:
            line(points,width=7)
    else:
        ellipse((34,34,222,222),outline=color,width=8*AA)
        for x in (94,162):
            ellipse((x-8,86,x+8,104),fill=color)
        draw.arc((75*AA,100*AA,181*AA,184*AA),20,160,fill=color,width=8*AA)
    if kind in ('ping-muted','emoji-block'):
        line([(38,218),(218,38)],fill=(242,121,101,245),width=12)
    elif kind == 'emoji-allow':
        line([(155,207),(176,226),(225,169)],fill=(112,239,144,245),width=12)
    return image.resize((SIZE,SIZE),Image.Resampling.LANCZOS)


def build():
    OUT.mkdir(parents=True,exist_ok=True)
    base = Image.new('RGBA',(SIZE*AA,SIZE*AA))
    draw = ImageDraw.Draw(base)
    draw.ellipse((6*AA,6*AA,250*AA,250*AA),fill=(6,12,19,220),outline=(66,102,132,255),width=2*AA)
    draw.ellipse((87*AA,87*AA,169*AA,169*AA),fill=(7,15,23,255),outline=(68,111,145,255),width=AA)
    base = base.resize((SIZE,SIZE),Image.Resampling.LANCZOS)
    base.save(OUT/'base.tga')
    sectors = [draw_sector(i) for i in range(5)]
    for index,name in enumerate(NAMES):
        sectors[index].save(OUT/(name+'.tga'))
        symbol(index).save(OUT/('symbol-'+name+'.tga'))
    buttons = [toolbar(kind) for kind in ['ping','ping-muted','emoji','emoji-block','emoji-allow']]
    for kind,image in zip(['ping','ping-muted','emoji','emoji-block','emoji-allow'],buttons):
        image.save(OUT/('button-'+kind+'.tga'))
    preview = Image.new('RGBA',(900,460),(19,24,30,255))
    font = ImageFont.truetype('C:/Windows/Fonts/segoeui.ttf',13)
    for hover,offset in [(False,65),(True,515)]:
        preview.alpha_composite(base.resize((320,320)),(offset,20))
        for index,sector in enumerate(sectors):
            if hover and index == 1:
                continue
            preview.alpha_composite(sector.resize((320,320)),(offset,20))
        if hover:
            preview.alpha_composite(sectors[1].resize((400,400)),(offset-40,-20))
        draw = ImageDraw.Draw(preview)
        for index,(label,angle) in enumerate(zip(LABELS,ANGLES)):
            radius = 138*(1.25 if hover and index==1 else 1)
            x = offset+160+radius*math.cos(math.radians(angle))
            y = 180+radius*math.sin(math.radians(angle))
            draw.multiline_text((x,y),label.replace('Group up here','Group up\nhere'),fill=COLORS[index],font=font,anchor='mm',align='center')
        draw.multiline_text((offset+160,180),'Attack' if hover else 'Select\norder',fill='white',font=font,anchor='mm',align='center')
    for index,image in enumerate(buttons):
        preview.alpha_composite(image.resize((44,44)),(285+index*66,382))
    (ROOT/'_build').mkdir(exist_ok=True)
    preview.convert('RGB').save(ROOT/'_build/team-ping-wheel-preview.png')
    print('Built 16 wheel, minimap and transparent toolbar textures:',OUT)


if __name__ == '__main__':
    build()
