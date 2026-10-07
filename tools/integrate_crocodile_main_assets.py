"""Copy missing Crocodile assets from a local TEST archive extraction into MAIN."""
from pathlib import Path
import json
import shutil
import struct

ROOT = Path(__file__).resolve().parents[1]


def integrate():
    config = json.loads((ROOT / '.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
    target = Path(config['mainMap']).resolve()
    source = ROOT / '_build/crocodile-resource-audit'
    backup = Path((ROOT / '_build/crocodile-main-backup.txt').read_text().strip())
    existing = {str(p.relative_to(target)).replace('/', '\\').lower() for p in target.rglob('*') if p.is_file()}
    imports_path = target / 'war3map.imp'
    original = imports_path.read_bytes()
    version, count = struct.unpack_from('<II', original)
    offset = 8
    registered = set()
    for _ in range(count):
        flag = original[offset]
        end = original.index(0, offset + 1)
        name = original[offset+1:end].decode('utf-8')
        if flag in (5, 8):
            name = 'war3mapImported\\' + name
        registered.add(name.lower())
        offset = end+1
    assert offset == len(original), 'Unrecognized imports tail; preserve rather than rewrite'
    saved_imports = backup / 'map-war3map.imp'
    if not saved_imports.exists():
        saved_imports.write_bytes(original)
    additions = []
    copied = []
    for file in sorted(source.rglob('*')):
        if not file.is_file() or file.name == '(listfile)':
            continue
        name = str(file.relative_to(source)).replace('/', '\\')
        if name.lower() in existing:
            continue
        destination = target / file.relative_to(source)
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(file, destination)
        copied.append(name)
        if name.lower() not in registered:
            additions.append(b'\x0d' + name.encode('utf-8') + b'\x00')
            registered.add(name.lower())
    if additions:
        imports_path.write_bytes(struct.pack('<II', version, count + len(additions)) + original[8:] + b''.join(additions))
    (backup / 'added-map-assets.json').write_text(json.dumps(copied, indent=2))
    print(f'MAIN missing assets copied: {len(copied)}; new import entries: {len(additions)}')
    for name in copied:
        print(name)


if __name__ == '__main__':
    integrate()
