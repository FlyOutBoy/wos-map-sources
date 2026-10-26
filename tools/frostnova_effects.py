"""Prepare a reviewed MDX/texture packet; explicit TEST import only, never a build hook."""
from pathlib import Path
import argparse
import hashlib
import json
import shutil
import struct

ROOT = Path(__file__).resolve().parents[1]


def prepare(source: Path, output: Path, builtin: Path) -> dict:
    textures = [p for p in source.rglob('*') if p.suffix.lower() == '.blp']
    entries = {}
    models = {}
    remapped = []
    normalized = []
    builtin_references = set()

    def add(name, data):
        relative=Path(name.replace('\\','/'))
        if relative.is_absolute() or '..' in relative.parts or ':' in name:
            raise ValueError('Unsafe import path: '+name)
        key = name.casefold()
        digest = hashlib.sha256(data).hexdigest()
        if key in entries and entries[key]['sha256'] != digest:
            raise ValueError('Different assets at '+name)
        path = output/'files'/Path(name.replace('\\','/'))
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
        entries[key] = dict(importPath=name, sha256=digest, bytes=len(data))

    for number, path in enumerate(sorted(p for p in source.rglob('*') if p.suffix.lower()=='.mdx')):
        data = bytearray(path.read_bytes())
        if data[:4] != b'MDLX':
            raise ValueError('Invalid MDX: '+str(path))
        relative = path.relative_to(source).as_posix()
        name = 'war3mapImported\\'+path.name
        position = 4
        while position+8 <= len(data):
            tag, size = struct.unpack_from('<4sI',data,position)
            if tag == b'GLBS':
                # Some source exports use zero-duration global animations for
                # constant transforms. Keep their pose without a zero period.
                for offset in range(position+8,position+8+size,4):
                    if struct.unpack_from('<I',data,offset)[0] == 0:
                        struct.pack_into('<I',data,offset,1)
                        normalized.append(dict(model=relative, globalSequence=(offset-position-8)//4, duration=1))
            if tag == b'TEXS':
                if size % 268:
                    raise ValueError('Invalid TEXS: '+relative)
                for offset in range(position+8,position+8+size,268):
                    original = bytes(data[offset+4:offset+264]).split(b'\0')[0].decode('utf-8')
                    if not original:
                        continue
                    local = path.parent/Path(original.replace('\\','/'))
                    candidates = [p for p in textures if p.name.casefold()==original.replace('\\','/').split('/')[-1].casefold()]
                    own = [p for p in candidates if path.parent != source and p.is_relative_to(path.parent)]
                    native = builtin/Path(original.replace('\\','/'))
                    if local.is_file():
                        selected = local
                    elif own:
                        selected = own[0]
                    elif native.is_file():
                        builtin_references.add(original)
                        continue
                    elif candidates and len({hashlib.sha256(p.read_bytes()).hexdigest() for p in candidates}) == 1:
                        selected = candidates[0]
                    else:
                        raise ValueError(f'Missing/ambiguous texture {original} in {relative}')
                    payload = selected.read_bytes()
                    digest = hashlib.sha256(payload).hexdigest()
                    target = original
                    existing = entries.get(target.casefold())
                    if (native.is_file() and native.read_bytes()!=payload) or (existing and existing['sha256']!=digest):
                        target = 'war3mapImported\\'+digest[:12]+'_'+selected.name
                    if target != original:
                        encoded = target.encode('utf-8')
                        if len(encoded)>259:
                            raise ValueError('Texture path too long: '+target)
                        data[offset+4:offset+264] = encoded.ljust(260,b'\0')
                        remapped.append(dict(model=relative, before=original, after=target))
                    add(target,payload)
            position += 8+size
        if position != len(data):
            raise ValueError('Invalid MDX chunks: '+relative)
        add(name,bytes(data))
        models[relative] = name
    manifest = dict(models=models, entries=list(entries.values()), remapped=remapped, normalized=normalized, builtinReferences=sorted(builtin_references))
    output.mkdir(parents=True,exist_ok=True)
    (output/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    return manifest


def stage_import(packet: Path, directory: Path) -> list[str]:
    manifest = json.loads((packet/'manifest.json').read_text('utf-8'))
    imp = directory/'war3map.imp'
    original = imp.read_bytes()
    version,count = struct.unpack_from('<II',original)
    if version not in (1,2):
        raise ValueError('Unsupported import format')
    names = set(); offset = 8
    for _ in range(count):
        end = original.index(0,offset+1)
        names.add(original[offset+1:end].decode('utf-8').casefold())
        offset = end+1
    if offset != len(original):
        raise ValueError('Unexpected import manifest tail')
    additions=[]; requested=['war3map.imp']
    for entry in manifest['entries']:
        name=entry['importPath']; relative=Path(name.replace('\\','/'))
        payload=(packet/'files'/relative).read_bytes()
        if hashlib.sha256(payload).hexdigest()!=entry['sha256']:
            raise ValueError('Changed packet asset: '+name)
        target=directory/relative
        if name.casefold() in names and target.exists() and target.read_bytes()!=payload:
            raise ValueError('Existing map asset differs: '+name)
        target.parent.mkdir(parents=True,exist_ok=True)
        target.write_bytes(payload)
        requested.append(name)
        if name.casefold() not in names:
            additions.append(b'\x0d'+name.encode('utf-8')+b'\0')
            names.add(name.casefold())
    imp.write_bytes(struct.pack('<II',version,count+len(additions))+original[8:]+b''.join(additions))
    return requested


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source',type=Path,required=True)
    parser.add_argument('--builtin',type=Path,required=True)
    parser.add_argument('--output',type=Path,default=ROOT/'assets/FrostnovaEffects')
    args=parser.parse_args()
    report=prepare(args.source,args.output,args.builtin)
    print(f"Prepared {len(report['models'])} models and {len(report['entries'])} assets; remapped {len(report['remapped'])} texture references")
