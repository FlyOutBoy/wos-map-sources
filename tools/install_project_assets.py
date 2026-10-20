"""Copy prebuilt project assets into a folder map and register them in war3map.imp.

Covers files that are generated once and kept in the project:
  assets/ReplaceableTextures/**      item icons (tools/build_item_icons.py)
  assets/effects/war3mapImported/**  Kusanagi slash/aura copies (tools/build_kusanagi_effects.py)
Idempotent: identical files are skipped, registered imports are not duplicated.
Called by .vscode/build-run-w3-map.ps1 (MAIN) before packing.

    python tools/install_project_assets.py --map <folder map .w3x>
"""
from pathlib import Path
import argparse
import shutil
import struct
from datetime import datetime

ROOT = Path(__file__).resolve().parents[1]
SOURCES = [
    (ROOT / 'assets', 'ReplaceableTextures'),
    (ROOT / 'assets/effects', 'war3mapImported'),
]


def collect():
    files = []
    for base, folder in SOURCES:
        root = base / folder
        if root.is_dir():
            for path in sorted(root.rglob('*')):
                if path.is_file() and path.suffix.lower() in ('.blp', '.mdx', '.mdl', '.tga'):
                    files.append((path, path.relative_to(base).as_posix()))
    return files


def install(map_dir):
    imp = map_dir / 'war3map.imp'
    original = imp.read_bytes()
    version, count = struct.unpack_from('<II', original)
    offset, registered = 8, set()
    for _ in range(count):
        end = original.index(0, offset + 1)
        name = original[offset + 1:end].decode('utf-8')
        if original[offset] in (5, 8):
            name = 'war3mapImported\\' + name
        registered.add(name.replace('\\', '/').casefold())
        offset = end + 1
    if version not in (1, 2) or offset != len(original):
        raise ValueError('Invalid war3map.imp; project asset installation stopped')
    files = collect()
    changed = [(src, rel) for src, rel in files
               if not (map_dir / rel).exists() or (map_dir / rel).read_bytes() != src.read_bytes()]
    additions = [rel for _, rel in files if rel.casefold() not in registered]
    if not changed and not additions:
        print(f'Project assets already match the map ({len(files)} files)')
        return
    backup = ROOT / 'backups/project-assets' / datetime.now().strftime('%Y%m%d-%H%M%S-%f')
    backup.mkdir(parents=True)
    shutil.copy2(imp, backup / imp.name)
    for src, rel in changed:
        destination = map_dir / rel
        if destination.exists():
            saved = backup / rel
            saved.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(destination, saved)
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, destination)
    if additions:
        imp.write_bytes(struct.pack('<II', version, count + len(additions)) + original[8:] +
                        b''.join(b'\x0d' + rel.replace('/', '\\').encode('utf-8') + b'\0' for rel in additions))
    print(f'Project assets: {len(changed)} copied, {len(additions)} new imports; backup: {backup}')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--map', required=True, type=Path)
    install(parser.parse_args().map.resolve())
