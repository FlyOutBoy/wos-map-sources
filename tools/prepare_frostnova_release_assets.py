"""Stage Frostnova assets without writing maps or altering source directories.

Only the supplied models and the hero's referenced custom assets are processed.
The reviewed FULL_AUTO converter is used on isolated BLP copies; native textures
stay native, and existing MAIN assets are never overwritten with different data.
"""
from pathlib import Path
import argparse
import hashlib
import json
import re
import struct
import subprocess

from fix_frostnova_model import chunks, records, fix_model


def digest(data):
    return hashlib.sha256(data).hexdigest()


def index(folder):
    return {str(p.relative_to(folder)).replace('/', '\\').casefold(): p
            for p in folder.rglob('*') if p.is_file()}


def textures(data):
    body = dict(chunks(data)).get(b'TEXS', b'')
    return [body[i+4:i+264].split(b'\0')[0].decode('utf8')
            for i in range(0, len(body), 268)]


def tune_model(data, mapping):
    output = []
    peaks = []
    for record in records(dict(chunks(data)).get(b'PRE2', b'')):
        end = 4 + struct.unpack_from('<I', record, 4)[0]
        peak = struct.unpack_from('<f', record, end+20)[0]
        at = record.find(b'KP2E', end+171)
        if at >= 0:
            count, interpolation = struct.unpack_from('<2I', record, at+4)
            stride = 8 if interpolation < 2 else 16
            peak = max([peak] + [struct.unpack_from('<f', record, at+20+i*stride)[0] for i in range(count)])
        peaks.append(max(0.0, peak))
    # Preserve small emitters. Dense models share a total 240 particles/sec
    # budget; a single continuous emitter never exceeds 60 particles/sec.
    small_total = sum(peak for peak in peaks if peak <= 40)
    dense_total = sum(peak for peak in peaks if peak > 40)
    budget_factor = min(1.0, max(60.0, 240.0-small_total)/max(1.0, dense_total))
    particle_changes = []
    for tag, body in chunks(data):
        result = bytearray(body)
        if tag == b'TEXS':
            for at in range(0, len(body), 268):
                old = body[at+4:at+264].split(b'\0')[0].decode('utf8')
                new = mapping.get(old.casefold(), old).encode('utf8')
                if len(new) > 259:
                    raise ValueError('Texture path too long')
                result[at+4:at+264] = new.ljust(260, b'\0')
        elif tag == b'GLBS':
            for at in range(0, len(body), 4):
                if struct.unpack_from('<I', result, at)[0] == 0:
                    struct.pack_into('<I', result, at, 1)
        elif tag == b'GEOS':
            offset = 0
            for record in records(body):
                group_at=record.index(b'GNDX');palette_at=record.index(b'MTGC')
                count=struct.unpack_from('<I',record,group_at+4)[0]
                palette_count=struct.unpack_from('<I',record,palette_at+4)[0]
                groups=record[group_at+8:group_at+8+count]
                if any(group>=palette_count for group in groups):
                    # The supplied Q shard's last mesh is one-based although
                    # it has exactly one palette. Repair indices, not geometry.
                    if palette_count!=1 or set(groups)-{0,1}:
                        raise ValueError('Ambiguous invalid skin palette')
                    result[offset+group_at+8:offset+group_at+8+count]=bytes(count)
                offset+=len(record)
        elif tag == b'PRE2':
            offset = 0
            for number, record in enumerate(records(body)):
                end = 4 + struct.unpack_from('<I', record, 4)[0]
                factor = 1.0 if peaks[number] <= 40 else min(budget_factor, 60.0/peaks[number])
                if factor < 1.0:
                    struct.pack_into('<f', result, offset+end+20,
                                     struct.unpack_from('<f', record, end+20)[0]*factor)
                    at = record.find(b'KP2E', end+171)
                    if at >= 0:
                        count, interpolation = struct.unpack_from('<2I', record, at+4)
                        stride = 8 if interpolation < 2 else 16
                        for key in range(count):
                            for component in range(1 if interpolation < 2 else 3):
                                position = at+20+key*stride+component*4
                                struct.pack_into('<f', result, offset+position,
                                                 struct.unpack_from('<f', record, position)[0]*factor)
                    particle_changes.append(dict(emitter=number, before=peaks[number], after=peaks[number]*factor))
                offset += len(record)
        output.append(tag+struct.pack('<I', len(result))+result)
    return b'MDLX'+b''.join(output), particle_changes


def prepare(args):
    test, main, database = index(args.test), index(args.main), index(args.database)
    db_names = {}
    for path in database.values():
        db_names.setdefault(path.name.casefold(), path)
    main_hash = {}
    for path in main.values():
        if path.suffix.lower() in ('.blp', '.tga', '.mdx') and path.name.lower().startswith('wos_'):
            main_hash.setdefault(digest(path.read_bytes()), str(path.relative_to(args.main)).replace('/', '\\'))
    output = args.output/'files'
    output.mkdir(parents=True, exist_ok=True)
    report = dict(paths={}, models=[], textures=[], imports=[], reused=[])
    staged = {}
    previous_manifest=args.output/'manifest.json'
    owned={item['path'].casefold():item['sha256'] for item in json.loads(previous_manifest.read_text('utf8'))['imports']} if previous_manifest.exists() else {}

    def locate(name):
        key = name.replace('/', '\\').casefold()
        alternatives = [key]
        if key.endswith('.mdl'):
            alternatives.append(key[:-4]+'.mdx')
        for lookup in (test, main, database):
            for alternative in alternatives:
                if alternative in lookup:
                    return lookup[alternative]
        for alternative in alternatives:
            if alternative.split('\\')[-1] in db_names:
                return db_names[alternative.split('\\')[-1]]
        return None

    def put(name, data, shared=True):
        if shared and digest(data) in main_hash:
            name = main_hash[digest(data)]
            report['reused'].append(name)
        previous = main.get(name.casefold())
        if previous is not None and previous.read_bytes() != data and shared and digest(previous.read_bytes())!=owned.get(name.casefold()):
            base = name.split('\\')[-1]
            name = 'war3mapImported\\wos_Frostnova_'+base.removeprefix('wos_')
            previous = main.get(name.casefold())
            if previous is not None and previous.read_bytes() != data:
                raise ValueError('Conflicting Frostnova asset: '+name)
        destination = output/Path(name.replace('\\', '/'))
        destination.parent.mkdir(parents=True, exist_ok=True)
        if name.casefold() in staged and staged[name.casefold()] != digest(data):
            raise ValueError('Packet asset collision: '+name)
        staged[name.casefold()] = digest(data)
        destination.write_bytes(data)
        return name

    converter = args.converter.read_text('utf-8-sig')
    match = re.search(r"\$converter\w*\s*=\s*@'\r?\n(.*?)\r?\n'@", converter, re.S)
    if not match:
        raise ValueError('FULL_AUTO converter source not found')
    js = args.output/'blp-converter.js'
    js.write_text(match[1], encoding='utf8')
    runtime = re.search(r"\$fixedJava\s*=\s*'([^']+)'", converter)
    java = args.java or (Path(runtime[1]) if runtime else None)
    if java is None or not java.is_file():
        raise ValueError('Supply --java or a FULL_AUTO file with a valid fixedJava runtime')
    classpath = str(java.parent.parent/'lib/*')
    texture_mapping = {}

    def texture(name, explicit=None):
        if name.casefold() in texture_mapping:
            return texture_mapping[name.casefold()]
        supplied_texture = args.buttons/name.replace('\\', '/').split('/')[-1]
        path = explicit or (supplied_texture if supplied_texture.is_file() else locate(name))
        if path is None:
            if name.lower().startswith(('textures\\', 'abilities\\', 'replaceabletextures\\')):
                return name
            raise ValueError('Missing custom texture: '+name)
        data = path.read_bytes()
        base = path.name
        if not base.lower().startswith('wos_'):
            base = 'wos_'+base
        if path.suffix.lower() == '.blp':
            width, height = struct.unpack_from('<2I', data, 12)
            if max(width, height) > 256 or len(data) > 102400:
                factor = min(1.0, 256/max(width, height))
                temporary = args.output/(base+'.converted.blp')
                subprocess.run([str(java), '-Dwos.input='+str(path.resolve()),
                    '-Dwos.output='+str(temporary.resolve()), '-Dwos.width='+str(max(1,round(width*factor))),
                    '-Dwos.height='+str(max(1,round(height*factor))), '-Dwos.maxbytes=102400',
                    '--class-path', classpath, 'org.openjdk.nashorn.tools.Shell', str(js.resolve())], check=True,
                    capture_output=True, creationflags=0x08000000)
                compressed = temporary.read_bytes()
                if factor < 1 or len(compressed) < len(data):
                    data = compressed
                temporary.unlink()
        elif path.suffix.lower() == '.tga':
            # Lossless encoding only: preserve all pixels, especially alpha.
            from PIL import Image
            import io
            image = Image.open(path); buffer = io.BytesIO()
            image.save(buffer, format='TGA', compression='tga_rle')
            if len(buffer.getvalue()) < len(data):
                data = buffer.getvalue()
        target = put('war3mapImported\\'+base, data)
        texture_mapping[name.casefold()] = target
        report['paths'][name] = target
        report['textures'].append(dict(source=str(path), target=target, before=path.stat().st_size, after=len(data)))
        return target

    source = args.hero.read_text('utf-8-sig')
    names = set(m.replace('\\\\', '\\') for m in re.findall(r'"([^"\n]+\.(?:mdx|mdl))"', source, re.I))
    import war3_object_data as raw
    identities = set(re.findall(r"=\s*'([A-Za-z0-9]{4})'", source.split('endglobals', 1)[0]))
    for filename in ('war3map.w3a', 'war3mapSkin.w3a', 'war3map.w3h', 'war3mapSkin.w3h'):
        path = args.test/filename
        if not path.exists():
            continue
        document = raw.parse_object_file(path.read_bytes(), filename, *raw.FORMAT_BY_EXTENSION[path.suffix], {})
        for obj in document['custom_objects']:
            if obj['new_id']['text'] in identities:
                for modification in obj['modifications']:
                    value = modification['data'].get('value', '')
                    if isinstance(value, str) and value.lower().startswith('war3mapimported\\') and value.lower().endswith(('.mdx', '.mdl')):
                        names.add(value)
    names = sorted(names)
    supplied = {p.name: p for p in args.buttons.glob('*.mdx')}
    for name in names + list(supplied):
        path = supplied.get(name) or locate(name)
        if path is None:
            raise ValueError('Missing model: '+name)
        original = path.read_bytes()
        mappings = {name.casefold(): texture(name) for name in textures(original) if name}
        optimized, particles = tune_model(original, mappings)
        geoset_report = None
        if path.name in supplied:
            optimized, geoset_report = fix_model(optimized)
        base = path.with_suffix('.mdx').name
        if not base.lower().startswith('wos_'):
            base = 'wos_'+base
        target = put('war3mapImported\\'+base, optimized)
        report['paths'][name] = target
        report['models'].append(dict(source=str(path), target=target, before=len(original), after=len(optimized),
                                     particles=particles, skin=geoset_report))
    # Portrait texture is explicit so it resolves before model processing too.
    for path in args.buttons.glob('*.blp'):
        if path.name.startswith('BTN') or path.name.startswith('DISBTN'):
            sub = 'CommandButtonsDisabled' if path.name.startswith('DISBTN') else 'CommandButtons'
            put('ReplaceableTextures\\'+sub+'\\'+path.name, path.read_bytes(), False)
    for path in args.sounds.glob('*.mp3'):
        put('war3mapImported\\'+path.name, path.read_bytes(), False)
    for path in output.rglob('*'):
        if path.is_file():
            name = str(path.relative_to(output)).replace('/', '\\')
            report['imports'].append(dict(path=name, bytes=path.stat().st_size, sha256=digest(path.read_bytes())))
    (args.output/'manifest.json').write_text(json.dumps(report, indent=2)+'\n', encoding='utf8')
    print('Prepared', len(report['models']), 'models,', len(report['textures']), 'textures,', len(report['imports']), 'payloads')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('test', 'main', 'database', 'buttons', 'sounds', 'hero', 'converter', 'output'):
        parser.add_argument('--'+name, required=True, type=Path)
    parser.add_argument('--java', type=Path, help='Optional Java runtime override; otherwise read from the supplied converter')
    prepare(parser.parse_args())
