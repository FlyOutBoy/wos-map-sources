"""Small transparent gold pointers for the existing item reorder UI."""
from build_wos_ui_textures_cp22 import glyph
from raster import polygon

NAMES = ['drag-arrow-' + direction for direction in ('left', 'right', 'up', 'down')]

def main():
    points=[(.12,.40),(.53,.40),(.53,.18),(.90,.50),(.53,.82),(.53,.60),(.12,.60)]
    for direction in ('right','left','up','down'):
        def shape(size, direction=direction):
            transformed=[]
            for x,y in points:
                if direction=='left':x,y=1-x,y
                elif direction=='up':x,y=y,1-x
                elif direction=='down':x,y=1-y,x
                transformed.append((x*size,y*size))
            return polygon(transformed)
        glyph(shape,'drag-arrow-'+direction)

if __name__=='__main__':main()
