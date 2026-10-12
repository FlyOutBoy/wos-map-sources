"""Dependency-free PNG decode, box resampling and TGA output.

Pillow is not available in every environment that builds the map assets, so
the checkpoint 22 art (user supplied PNG logos, generated SDF textures) goes
through this small module.  Images are (width, height, rows) where rows is a
list of bytearrays with RGBA pixels.
"""
from pathlib import Path
import struct
import zlib


def _paeth(a, b, c):
    p = a + b - c
    pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
    if pa <= pb and pa <= pc:
        return a
    return b if pb <= pc else c


def read_png(path):
    data = Path(path).read_bytes()
    if data[:8] != b'\x89PNG\r\n\x1a\n':
        raise ValueError(f'{path}: not a PNG')
    pos = 8
    idat = bytearray()
    width = height = depth = ctype = interlace = None
    while pos < len(data):
        length, kind = struct.unpack('>I4s', data[pos:pos + 8])
        body = data[pos + 8:pos + 8 + length]
        pos += 12 + length
        if kind == b'IHDR':
            width, height, depth, ctype, _, _, interlace = struct.unpack('>IIBBBBB', body)
        elif kind == b'IDAT':
            idat += body
        elif kind == b'IEND':
            break
    if depth != 8 or ctype not in (2, 6) or interlace:
        raise ValueError(f'{path}: only 8-bit non-interlaced RGB/RGBA is supported')
    bpp = 4 if ctype == 6 else 3
    raw = zlib.decompress(bytes(idat))
    stride = width * bpp
    rows = []
    prev = bytearray(stride)
    pos = 0
    for _ in range(height):
        kind = raw[pos]
        line = bytearray(raw[pos + 1:pos + 1 + stride])
        pos += 1 + stride
        if kind == 1:
            for i in range(bpp, stride):
                line[i] = (line[i] + line[i - bpp]) & 255
        elif kind == 2:
            line = bytearray((x + y) & 255 for x, y in zip(line, prev))
        elif kind == 3:
            for i in range(stride):
                left = line[i - bpp] if i >= bpp else 0
                line[i] = (line[i] + ((left + prev[i]) >> 1)) & 255
        elif kind == 4:
            for i in range(stride):
                left = line[i - bpp] if i >= bpp else 0
                up_left = prev[i - bpp] if i >= bpp else 0
                line[i] = (line[i] + _paeth(left, prev[i], up_left)) & 255
        rows.append(line)
        prev = line
    if bpp == 3:
        rgba = []
        for line in rows:
            out = bytearray(width * 4)
            out[0::4] = line[0::3]
            out[1::4] = line[1::3]
            out[2::4] = line[2::3]
            out[3::4] = b'\xff' * width
            rgba.append(out)
        rows = rgba
    return width, height, rows


def alpha_bbox(image, threshold=8):
    width, height, rows = image
    top, bottom, left, right = height, -1, width, -1
    for y, line in enumerate(rows):
        alphas = line[3::4]
        hits = [x for x, a in enumerate(alphas) if a > threshold]
        if hits:
            top = min(top, y)
            bottom = y
            left = min(left, hits[0])
            right = max(right, hits[-1])
    return left, top, right + 1, bottom + 1


def crop(image, box):
    left, top, right, bottom = box
    _, _, rows = image
    return right - left, bottom - top, [bytearray(r[left * 4:right * 4]) for r in rows[top:bottom]]


def pad(image, width, height):
    """Centre on a transparent canvas of the given size."""
    w, h, rows = image
    ox, oy = (width - w) // 2, (height - h) // 2
    out = [bytearray(width * 4) for _ in range(height)]
    for y, line in enumerate(rows):
        out[oy + y][ox * 4:(ox + w) * 4] = line
    return width, height, out


def resize(image, width, height):
    """Area-average (box) resample with premultiplied alpha."""
    sw, sh, rows = image
    xs = [x * sw / width for x in range(width + 1)]
    ys = [y * sh / height for y in range(height + 1)]
    out = []
    for oy in range(height):
        y0, y1 = ys[oy], ys[oy + 1]
        acc = [[0.0, 0.0, 0.0, 0.0] for _ in range(width)]
        sy = int(y0)
        while sy < y1 and sy < sh:
            wy = min(y1, sy + 1) - max(y0, sy)
            line = rows[sy]
            for ox in range(width):
                x0, x1 = xs[ox], xs[ox + 1]
                a = acc[ox]
                sx = int(x0)
                while sx < x1 and sx < sw:
                    w = wy * (min(x1, sx + 1) - max(x0, sx))
                    i = sx * 4
                    al = line[i + 3] * w
                    a[0] += line[i] * al
                    a[1] += line[i + 1] * al
                    a[2] += line[i + 2] * al
                    a[3] += al
                    sx += 1
            sy += 1
        area = (y1 - y0) * (sw / width)
        line = bytearray(width * 4)
        for ox, (r, g, b, al) in enumerate(acc):
            if al > 0:
                line[ox * 4:ox * 4 + 4] = bytes((min(255, round(r / al)), min(255, round(g / al)),
                                                 min(255, round(b / al)), min(255, round(al / area))))
        out.append(line)
    return width, height, out


def write_tga(image, path):
    """Uncompressed 32-bit BGRA TGA, top-left origin (descriptor 0x28)."""
    width, height, rows = image
    body = bytearray()
    for line in rows:
        bgra = bytearray(line)
        bgra[0::4], bgra[2::4] = line[2::4], line[0::4]
        body += bgra
    header = struct.pack('<BBBHHBHHHHBB', 0, 0, 2, 0, 0, 0, 0, 0, width, height, 32, 0x28)
    Path(path).parent.mkdir(parents=True, exist_ok=True)
    Path(path).write_bytes(header + bytes(body))


def read_tga(path):
    data = Path(path).read_bytes()
    width, height = struct.unpack_from('<HH', data, 12)
    bpp, desc = data[16], data[17]
    if data[2] != 2 or bpp != 32:
        raise ValueError(f'{path}: expected uncompressed 32-bit TGA')
    start = 18 + data[0]
    rows = []
    for y in range(height):
        line = bytearray(data[start + y * width * 4:start + (y + 1) * width * 4])
        line[0::4], line[2::4] = line[2::4], line[0::4]
        rows.append(line)
    if not desc & 0x20:
        rows.reverse()
    return width, height, rows
