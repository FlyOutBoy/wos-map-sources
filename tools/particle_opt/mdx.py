"""Minimal MDX (MDLX) reader: chunk table, PRE2/RIBB/PREM emitters, geoset stats, textures."""
import struct, sys, os, json

def chunks(d):
    if d[:4] != b'MDLX':
        raise ValueError('not MDLX')
    p = 4
    out = []
    while p + 8 <= len(d):
        tag = d[p:p+4].decode('latin1'); size = struct.unpack_from('<I', d, p+4)[0]
        out.append((tag, p+8, size))
        p += 8 + size
    return out

def track(d, p):
    """returns (tag, keys[(frame,value)], interp, gseq, endpos) ; value float only (dim 1)"""
    tag = d[p:p+4].decode('latin1')
    n, interp, gs = struct.unpack_from('<IIi', d, p+4)
    q = p + 16
    dim = 3 if tag == 'KRCO' else 1
    keys = []
    for _ in range(n):
        fr, = struct.unpack_from('<i', d, q); q += 4
        keys.append((fr, q))  # value offset
        q += 4 * dim
        if interp > 1:
            q += 8 * dim
    TRACK_META[(id(d), p)] = (interp, gs)
    LAST_META[tag] = (interp, gs)
    return tag, keys, interp, gs, q

TRACK_META = {}
LAST_META = {}

def node_end(d, p):
    size = struct.unpack_from('<I', d, p)[0]
    name = d[p+4:p+84].split(b'\0')[0].decode('latin1', 'replace')
    return p + size, name

def pre2(d, off, size, ver):
    res = []
    p = off; end = off + size
    while p < end:
        isz = struct.unpack_from('<I', d, p)[0]
        e_end = p + isz
        ne, name = node_end(d, p + 4)
        q = ne
        speed, var, lat, grav, life, rate, length, width = struct.unpack_from('<8f', d, q)
        filt, rows, cols, hot = struct.unpack_from('<4I', d, q+32)
        tail_len, tm = struct.unpack_from('<2f', d, q+48)
        seg_scale = struct.unpack_from('<3f', d, q+56+36+3)
        tex, squirt = struct.unpack_from('<II', d, q+56+36+3+12+48)
        tq = q + 56+36+3+12+48+16
        anim = {}; meta = {}
        while tq < e_end:
            tag, keys, interp, gs, tq2 = track(d, tq)
            anim[tag] = [(fr, struct.unpack_from('<f', d, vo)[0], vo) for fr, vo in keys]
            meta[tag] = (interp, gs)
            tq = tq2
        res.append(dict(kind='PRE2', name=name, start=p, rate_off=q+20, life_off=q+16, width_off=q+28,
                        scale_off=q+95, rate=rate, life=life, width=width, length=length, scale=seg_scale, tex=tex,
                        squirt=squirt, head_or_tail=hot, filter=filt, anim=anim, meta=meta))
        p = e_end
    return res

def ribb(d, off, size):
    res = []
    p = off; end = off + size
    while p < end:
        isz = struct.unpack_from('<I', d, p)[0]
        e_end = p + isz
        ne, name = node_end(d, p + 4)
        q = ne
        hab, hbe, alpha = struct.unpack_from('<3f', d, q)
        q2 = q + 12 + 12 + 4  # color + texslot? layout: above, below, alpha, color[3], lifespan, texSlot, rate, rows, cols, matId, gravity
        life, = struct.unpack_from('<f', d, q+24)
        rate, = struct.unpack_from('<I', d, q+32)
        anim = {}
        tq = q + 52
        while tq < e_end:
            tag, keys, interp, gs, tq2 = track(d, tq)
            anim[tag] = [(fr, struct.unpack_from('<f', d, vo)[0], vo) for fr, vo in keys]
            tq = tq2
        res.append(dict(kind='RIBB', name=name, rate=rate, life=life, rate_off=q+32, life_off=q+24))
        p = e_end
    return res

def prem(d, off, size):
    res = []
    p = off; end = off + size
    while p < end:
        isz = struct.unpack_from('<I', d, p)[0]
        e_end = p + isz
        ne, name = node_end(d, p + 4)
        q = ne
        rate, grav, lon, lat = struct.unpack_from('<4f', d, q)
        path = d[q+16:q+16+260].split(b'\0')[0].decode('latin1', 'replace')
        life, spd = struct.unpack_from('<2f', d, q+276)
        res.append(dict(kind='PREM', name=name, rate=rate, life=life, path=path, rate_off=q))
        p = e_end
    return res

def geos(d, off, size, ver):
    verts = faces = 0; n = 0
    p = off; end = off + size
    while p < end:
        isz = struct.unpack_from('<I', d, p)[0]
        q = p + 4
        if d[q:q+4] == b'VRTX':
            c = struct.unpack_from('<I', d, q+4)[0]; verts += c
            q += 8 + c*12
            if d[q:q+4] == b'NRMS':
                c2 = struct.unpack_from('<I', d, q+4)[0]; q += 8 + c2*12
            if d[q:q+4] == b'PTYP':
                c2 = struct.unpack_from('<I', d, q+4)[0]; q += 8 + c2*4
            if d[q:q+4] == b'PCNT':
                c2 = struct.unpack_from('<I', d, q+4)[0]; q += 8 + c2*4
            if d[q:q+4] == b'PVTX':
                c2 = struct.unpack_from('<I', d, q+4)[0]; faces += c2 // 3
        n += 1
        p += isz
    return n, verts, faces

def texs(d, off, size):
    out = []
    for i in range(size // 268):
        rid = struct.unpack_from('<I', d, off + i*268)[0]
        path = d[off+i*268+4: off+i*268+264].split(b'\0')[0].decode('latin1', 'replace')
        out.append((rid, path))
    return out

def seqs(d, off, size):
    out = []
    for i in range(size // 132):
        b = off + i*132
        name = d[b:b+80].split(b'\0')[0].decode('latin1', 'replace')
        s, e = struct.unpack_from('<II', d, b+80)
        flags, = struct.unpack_from('<I', d, b+92)
        out.append((name, s, e, flags))
    return out

def analyze(path):
    d = open(path, 'rb').read()
    info = dict(path=path, size=len(d), emitters=[], textures=[], geosets=0, verts=0, faces=0, seqs=[])
    ver = 800
    for tag, off, size in chunks(d):
        if tag == 'VERS':
            ver = struct.unpack_from('<I', d, off)[0]
        elif tag == 'PRE2':
            info['emitters'] += pre2(d, off, size, ver)
        elif tag == 'RIBB':
            info['emitters'] += ribb(d, off, size)
        elif tag == 'PREM':
            info['emitters'] += prem(d, off, size)
        elif tag == 'GEOS':
            info['geosets'], info['verts'], info['faces'] = geos(d, off, size, ver)
        elif tag == 'TEXS':
            info['textures'] = texs(d, off, size)
        elif tag == 'SEQS':
            info['seqs'] = seqs(d, off, size)
    info['version'] = ver
    return info, d

def peak_rate(e):
    r = e['rate']
    keys = e.get('anim', {}).get('KP2E') if e['kind'] == 'PRE2' else None
    if keys:
        r = max(v for _, v, _ in keys)
    return r

def cost(e):
    """steady-state particle count estimate"""
    if e['kind'] == 'PRE2':
        mult = 2 if e['head_or_tail'] == 2 else 1
        return peak_rate(e) * max(0.0, e['life']) * mult
    return e['rate'] * max(0.0, e['life'])

if __name__ == '__main__':
    info, _ = analyze(sys.argv[1])
    print('ver', info['version'], 'size', info['size'], 'geos', info['geosets'], 'v', info['verts'], 'f', info['faces'])
    for s in info['seqs']:
        print(' seq', s)
    for e in info['emitters']:
        extra = ''
        if e['kind'] == 'PRE2':
            extra = 'w=%.1f len=%.1f scale=%s tex=%d hot=%d KP2E=%s' % (e['width'], e['length'], tuple(round(x, 2) for x in e['scale']), e['tex'], e['head_or_tail'], [(f, round(v, 1)) for f, v, _ in e['anim'].get('KP2E', [])][:8])
        print(' %s %-30s rate=%.1f life=%.2f cost=%.0f %s' % (e['kind'], e['name'], e['rate'], e['life'], cost(e), extra))
    for t in info['textures']:
        print(' tex', t)
