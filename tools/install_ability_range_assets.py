"""Prepare the supplied ring model; install only its verified resources/imports.

Does not compile JASS or touch trigger/gameplay payloads. Map argument is an
unpacked scenario; use the existing archive pack/extract workflow afterwards.
"""
from pathlib import Path
import argparse
import hashlib
import json
import shutil
import struct
from datetime import datetime

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT/'assets/AbilityRange'
MODEL = 'wos_tx-tsqyuanxing2.mdx'
TEXTURE = 'wos_tx-tsqyuanxing2_0.blp'
PREFIX = 'war3mapImported\\WOSRange\\'


def chunks(data):
    if data[:4] != b'MDLX':
        raise ValueError('Expected MDX')
    pos = 4
    while pos < len(data):
        tag = data[pos:pos+4]
        size = struct.unpack_from('<I', data, pos+4)[0]
        end = pos+8+size
        if end > len(data):
            raise ValueError('Truncated MDX')
        yield tag, data[pos+8:end]
        pos = end
    if pos != len(data):
        raise ValueError('Unexpected MDX tail')


def dependencies(data):
    textures = dict(chunks(data))[b'TEXS']
    if len(textures) % 268:
        raise ValueError('Invalid TEXS')
    return [textures[o+4:o+264].split(b'\0')[0].decode('ascii')
            for o in range(0, len(textures), 268)]


def static_ring(data):
    """Keep the original 512-radius plane and texture; remove birth/death/pulse.

    The source contains two coincident planes animated by global alpha/scale.
    The static copy uses its first plane, material and bones without tracks.
    No particles, ribbons, lights, animated alpha or scale can survive hiding.
    """
    c = dict(chunks(data))
    if set(c) != {b'VERS', b'MODL', b'SEQS', b'GLBS', b'MTLS', b'TEXS', b'GEOS', b'GEOA', b'BONE', b'PIVT'}:
        raise ValueError('Unexpected model structure; inspect before normalizing')
    if [p.lower() for p in dependencies(data)] != [('war3mapImported\\'+TEXTURE).lower()]:
        raise ValueError('Unexpected texture dependency')
    seq = bytearray(c[b'SEQS'][:132])
    seq[:80] = b'Stand'.ljust(80, b'\0')
    struct.pack_into('<II', seq, 80, 0, 1000)
    struct.pack_into('<I', seq, 92, 0)  # looping
    layer = bytearray(c[b'MTLS'][20:48])
    if c[b'MTLS'][12:16] != b'LAYS' or struct.unpack_from('<I', c[b'MTLS'], 16)[0] != 1:
        raise ValueError('Unexpected layer structure')
    struct.pack_into('<I', layer, 0, 28)
    struct.pack_into('<f', layer, 24, 1.0)
    material = struct.pack('<III4sI', 48, 0, 0, b'LAYS', 1)+layer
    tex = bytearray(c[b'TEXS'])
    tex[4:264] = (PREFIX+TEXTURE).encode('ascii').ljust(260, b'\0')
    geo_size = struct.unpack_from('<I', c[b'GEOS'])[0]
    geo = c[b'GEOS'][:geo_size]
    if geo[4:8] != b'VRTX' or struct.unpack_from('<I', geo, 8)[0] != 4:
        raise ValueError('Unexpected ring geometry')
    for i in range(4):
        x,y,_ = struct.unpack_from('<3f', geo, 12+12*i)
        if abs(x) != 512.0 or abs(y) != 512.0:
            raise ValueError('Expected the supplied radius-512 textured plane')
    ga = bytearray(c[b'GEOA'][:28])
    struct.pack_into('<If', ga, 0, 28, 1.0)
    bones = b''
    pos = 0
    while pos < len(c[b'BONE']):
        size = struct.unpack_from('<I', c[b'BONE'], pos)[0]
        node = bytearray(c[b'BONE'][pos:pos+96])
        struct.pack_into('<I', node, 0, 96)
        bones += node + c[b'BONE'][pos+size:pos+size+8]
        pos += size+8
    if pos != len(c[b'BONE']):
        raise ValueError('Invalid bone boundaries')
    out = [(b'VERS',c[b'VERS']), (b'MODL',c[b'MODL']), (b'SEQS',bytes(seq)),
           (b'MTLS',material), (b'TEXS',bytes(tex)), (b'GEOS',geo),
           (b'GEOA',bytes(ga)), (b'BONE',bones), (b'PIVT',c[b'PIVT'])]
    return b'MDLX'+b''.join(t+struct.pack('<I',len(v))+v for t,v in out)


def prepare(source, target=ASSETS):
    data = (source/MODEL).read_bytes()
    model = static_ring(data)
    texture = (source/TEXTURE).read_bytes()
    if texture[:4] not in (b'BLP1', b'BLP2'):
        raise ValueError('Invalid BLP')
    (target/'original').mkdir(parents=True, exist_ok=True)
    for name in (MODEL, TEXTURE):
        shutil.copy2(source/name, target/'original'/name)
    runtime = target/'war3mapImported/WOSRange'
    runtime.mkdir(parents=True,exist_ok=True)
    (runtime/MODEL).write_bytes(model)
    (runtime/TEXTURE).write_bytes(texture)
    manifest = [{'import':PREFIX+n, 'sha256':hashlib.sha256(d).hexdigest(), 'bytes':len(d)}
                for n,d in [(MODEL,model),(TEXTURE,texture)]]
    (target/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n', encoding='utf-8')
    return manifest


def install(map_dir, source=ASSETS, backup_root=None):
    manifest = json.loads((source/'manifest.json').read_text(encoding='utf-8'))
    if [e['import'] for e in manifest] != [PREFIX+MODEL,PREFIX+TEXTURE]:
        raise ValueError('Unexpected range manifest')
    payload = {}
    for entry in manifest:
        name = entry['import']
        d = (source/name.replace('\\','/')).read_bytes()
        if hashlib.sha256(d).hexdigest() != entry['sha256']:
            raise ValueError('Asset hash mismatch: '+name)
        payload[name] = d
    if dependencies(payload[PREFIX+MODEL]) != [PREFIX+TEXTURE]:
        raise ValueError('Unresolved model dependency')
    imp = map_dir/'war3map.imp'
    old = imp.read_bytes()
    version,count = struct.unpack_from('<II',old)
    if version not in (1,2):
        raise ValueError('Unsupported imports')
    names = set()
    offset = 8
    for _ in range(count):
        flag = old[offset]
        end = old.index(0,offset+1)
        name = old[offset+1:end].decode('utf-8')
        if flag in (5,8):
            name = 'war3mapImported\\'+name
        names.add(name.replace('/','\\').lower())
        offset = end+1
    if offset != len(old):
        raise ValueError('Unexpected imports tail')
    additions = [b'\x0d'+n.encode()+b'\0' for n in payload if n.lower() not in names]
    changed = {n:d for n,d in payload.items() if not (map_dir/n).exists() or (map_dir/n).read_bytes()!=d}
    if not changed and not additions:
        return False
    backup = (backup_root or ROOT/'backups/ability-range')/datetime.now().strftime('%Y%m%d-%H%M%S-%f')
    backup.mkdir(parents=True)
    shutil.copy2(imp,backup/'war3map.imp')
    for n,d in changed.items():
        dest = map_dir/n
        if dest.exists():
            (backup/n).parent.mkdir(parents=True,exist_ok=True)
            shutil.copy2(dest,backup/n)
        dest.parent.mkdir(parents=True,exist_ok=True)
        dest.write_bytes(d)
    if additions:
        imp.write_bytes(struct.pack('<II',version,count+len(additions))+old[8:]+b''.join(additions))
    print('Range assets:',len(changed),'payloads;',len(additions),'imports; backup:',backup)
    return True


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--prepare',type=Path)
    parser.add_argument('--map',type=Path)
    args = parser.parse_args()
    if args.prepare:
        print(json.dumps(prepare(args.prepare),indent=2))
    if args.map:
        install(args.map)
