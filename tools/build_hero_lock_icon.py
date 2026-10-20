"""Antique-gold hero/crosshair glyph, matching the existing HUD icon system."""
from pathlib import Path
from raster import Canvas, circle, ring, segment, union, polygon, lerp
from png_tga import write_tga


def build():
    canvas = Canvas(64, 64)
    # Portrait silhouette inside an interrupted targeting reticle.
    shape = union(circle(32, 25, 7), polygon([(20, 47), (21, 38), (27, 34),
                  (37, 34), (43, 38), (44, 47)]),
                  ring(32, 32, 26, 2),
                  segment(32, 2, 32, 12, 2.5), segment(32, 52, 32, 62, 2.5),
                  segment(2, 32, 12, 32, 2.5), segment(52, 32, 62, 32, 2.5))
    canvas.fill(shape, lambda x, y: lerp((248, 226, 166), (112, 84, 40), (x+y)/128))
    write_tga(canvas.image(), Path(__file__).resolve().parents[1]/'assets/UI/WOS/glyph-hero-lock.tga')


if __name__ == '__main__':
    build()
