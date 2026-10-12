"""Tiny anti-aliased vector rasterizer (signed distance fields, no Pillow).

Shapes are functions sdf(x, y) -> distance in pixels (negative inside).
Paint functions return (r, g, b) for a pixel centre, so gradients/bevels are
plain Python lambdas.  Coverage = clamp(0.5 - d, 0, 1) gives one-pixel AA.
"""
import math


class Canvas:
    def __init__(self, width, height):
        self.w = width
        self.h = height
        # premultiplied RGBA floats 0..1
        self.px = [[0.0, 0.0, 0.0, 0.0] for _ in range(width * height)]

    def fill(self, sdf, paint, alpha=1.0, feather=1.0, bbox=None):
        x0, y0, x1, y1 = bbox if bbox else (0, 0, self.w, self.h)
        x0, y0 = max(0, int(x0)), max(0, int(y0))
        x1, y1 = min(self.w, int(math.ceil(x1))), min(self.h, int(math.ceil(y1)))
        constant = paint if isinstance(paint, tuple) else None
        for y in range(y0, y1):
            cy = y + 0.5
            row = y * self.w
            for x in range(x0, x1):
                cx = x + 0.5
                d = sdf(cx, cy)
                cov = 0.5 - d / feather
                if cov <= 0:
                    continue
                if cov > 1:
                    cov = 1.0
                a = cov * (alpha(cx, cy) if callable(alpha) else alpha)
                if a <= 0:
                    continue
                r, g, b = constant if constant else paint(cx, cy)
                p = self.px[row + x]
                k = 1 - a
                p[0] = r / 255 * a + p[0] * k
                p[1] = g / 255 * a + p[1] * k
                p[2] = b / 255 * a + p[2] * k
                p[3] = a + p[3] * k

    def image(self):
        rows = []
        for y in range(self.h):
            line = bytearray(self.w * 4)
            for x in range(self.w):
                r, g, b, a = self.px[y * self.w + x]
                if a > 0:
                    line[x * 4:x * 4 + 4] = bytes((min(255, round(r / a * 255)), min(255, round(g / a * 255)),
                                                   min(255, round(b / a * 255)), min(255, round(a * 255))))
            rows.append(line)
        return self.w, self.h, rows


# ---- shapes -------------------------------------------------------------
def circle(cx, cy, r):
    return lambda x, y: math.hypot(x - cx, y - cy) - r


def ring(cx, cy, r, half):
    return lambda x, y: abs(math.hypot(x - cx, y - cy) - r) - half


def box(cx, cy, hw, hh, radius=0.0):
    def f(x, y):
        qx = abs(x - cx) - hw + radius
        qy = abs(y - cy) - hh + radius
        return math.hypot(max(qx, 0), max(qy, 0)) + min(max(qx, qy), 0) - radius
    return f


def segment(ax, ay, bx, by, r):
    dx, dy = bx - ax, by - ay
    ll = dx * dx + dy * dy or 1e-9

    def f(x, y):
        t = max(0.0, min(1.0, ((x - ax) * dx + (y - ay) * dy) / ll))
        return math.hypot(x - ax - t * dx, y - ay - t * dy) - r
    return f


def polygon(points):
    pts = list(points)
    n = len(pts)

    def f(x, y):
        d = float('inf')
        inside = False
        j = n - 1
        for i in range(n):
            xi, yi = pts[i]
            xj, yj = pts[j]
            ex, ey = xj - xi, yj - yi
            ll = ex * ex + ey * ey or 1e-9
            t = max(0.0, min(1.0, ((x - xi) * ex + (y - yi) * ey) / ll))
            d = min(d, math.hypot(x - xi - t * ex, y - yi - t * ey))
            if (yi > y) != (yj > y) and x < (xj - xi) * (y - yi) / (yj - yi + 1e-12) + xi:
                inside = not inside
            j = i
        return -d if inside else d
    return f


def union(*shapes):
    return lambda x, y: min(s(x, y) for s in shapes)


def subtract(a, b):
    return lambda x, y: max(a(x, y), -b(x, y))


def intersect(a, b):
    return lambda x, y: max(a(x, y), b(x, y))


def offset(shape, amount):
    return lambda x, y: shape(x, y) - amount


def sector(cx, cy, start_deg, end_deg):
    """Infinite wedge between two angles (counter-clockwise, y up)."""
    a0, a1 = math.radians(start_deg), math.radians(end_deg)
    mid = (a0 + a1) / 2
    half = (a1 - a0) / 2

    def f(x, y):
        dx, dy = x - cx, cy - y
        ang = math.atan2(dy, dx) - mid
        ang = (ang + math.pi) % (2 * math.pi) - math.pi
        r = math.hypot(dx, dy)
        over = abs(ang) - half
        if over <= 0:
            return -r * math.sin(min(-over, math.pi / 2))
        return r * math.sin(min(over, math.pi / 2))
    return f


# ---- paints -------------------------------------------------------------
def lerp(c0, c1, t):
    t = max(0.0, min(1.0, t))
    return tuple(round(a + (b - a) * t) for a, b in zip(c0, c1))


def vertical(c0, c1, top, bottom):
    return lambda x, y: lerp(c0, c1, (y - top) / max(1e-6, bottom - top))


def diagonal(c0, c1, size):
    return lambda x, y: lerp(c0, c1, (x + y) / (2 * size))


def radial(c0, c1, cx, cy, r):
    return lambda x, y: lerp(c0, c1, math.hypot(x - cx, y - cy) / r)
