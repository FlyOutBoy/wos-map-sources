"""Copy the command wheel textures and register them in World Editor imports."""
from pathlib import Path
import argparse
from datetime import datetime
import shutil
import struct

ROOT = Path(__file__).resolve().parents[1]
ASSET_NAMES = {'base', 'move', 'attack', 'danger', 'help', 'rally',
              'symbol-move', 'symbol-attack', 'symbol-danger', 'symbol-help', 'symbol-rally',
              'button-ping', 'button-ping-muted', 'button-emoji', 'button-emoji-block', 'button-emoji-allow'}


def install(map_dir: Path, source: Path | None = None, backup_root: Path | None = None, expected_names: set | None = None, prefix: str = 'UI/TeamPings'):
    source = source or ROOT/'assets/UI/TeamPings'
    backup_root = backup_root or ROOT/'backups/team-ping-assets'
    assets = sorted(source.glob('*.tga'))
    if {asset.stem for asset in assets} != (expected_names or ASSET_NAMES):
        raise ValueError('Expected the complete command wheel, minimap and toolbar texture set')
    imp = map_dir/'war3map.imp'
    original = imp.read_bytes()
    version,count = struct.unpack_from('<II',original)
    if version not in (1,2):
        raise ValueError('Unsupported Warcraft imports version')
    offset = 8
    registered = set()
    for _ in range(count):
        flag = original[offset]
        end = original.index(0,offset+1)
        name = original[offset+1:end].decode('utf-8')
        if flag in (5,8):
            name = 'war3mapImported\\'+name
        registered.add(name.replace('/','\\').casefold())
        offset = end+1
    if offset != len(original):
        raise ValueError('Unrecognized imports tail; preserving the original file')
    additions = []
    changed = []
    for asset in assets:
        relative = Path(prefix)/asset.name
        destination = map_dir/relative
        if not destination.exists() or destination.read_bytes() != asset.read_bytes():
            changed.append((asset,destination,relative))
        name = str(relative).replace('/','\\')
        if name.casefold() not in registered:
            additions.append(b'\x0d'+name.encode('utf-8')+b'\x00')
    if not additions and not changed:
        print('Command wheel textures/imports already match the project')
        return
    backup = backup_root/datetime.now().strftime('%Y%m%d-%H%M%S-%f')
    backup.mkdir(parents=True)
    shutil.copy2(imp,backup/'war3map.imp')
    for asset,destination,relative in changed:
        if destination.exists():
            saved = backup/relative
            saved.parent.mkdir(parents=True,exist_ok=True)
            shutil.copy2(destination,saved)
        destination.parent.mkdir(parents=True,exist_ok=True)
        shutil.copy2(asset,destination)
    if additions:
        imp.write_bytes(struct.pack('<II',version,count+len(additions))+original[8:]+b''.join(additions))
    print(f'Command wheel: {len(changed)} textures copied; {len(additions)} imports registered; backup: {backup}')


def install_models(map_dir: Path, source: Path | None = None, backup_root: Path | None = None):
    """Install the five user ping MDX and their six exact-path BLP dependencies."""
    import json
    import hashlib
    source = source or ROOT/'assets/TeamPings/models'
    backup_root = backup_root or ROOT/'backups/team-ping-models'
    manifest = json.loads((source/'manifest.json').read_text(encoding='utf-8'))
    if len(manifest) != 11:
        raise ValueError('Expected five MDX and six BLP dependencies')
    original = (map_dir/'war3map.imp').read_bytes()
    version,count = struct.unpack_from('<II',original)
    if version not in (1,2):
        raise ValueError('Unsupported imports version')
    offset=8
    names=set()
    for _ in range(count):
        flag=original[offset]
        end=original.index(0,offset+1)
        name=original[offset+1:end].decode('utf-8')
        if flag in (5,8):
            name='war3mapImported\\'+name
        names.add(name.replace('/','\\').casefold())
        offset=end+1
    if offset!=len(original):
        raise ValueError('Unexpected imports tail')
    changed=[]
    additions=[]
    seen=set()
    for entry in manifest:
        name=entry['import'].replace('/','\\')
        rel=Path(name.replace('\\','/'))
        if rel.is_absolute() or '..' in rel.parts or not name.lower().startswith('war3mapimported\\') or name.lower() in seen:
            raise ValueError('Invalid/duplicate model import')
        seen.add(name.lower())
        src=source/rel
        data=src.read_bytes()
        if hashlib.sha256(data).hexdigest()!=entry['sha256']:
            raise ValueError('Model asset hash mismatch: '+name)
        if src.suffix.lower()=='.mdx' and not data.startswith(b'MDLX'):
            raise ValueError('Invalid MDX')
        dest=map_dir/rel
        if not dest.exists() or dest.read_bytes()!=data:
            changed.append((src,dest,rel))
        if name.casefold() not in names:
            additions.append(b'\x0d'+name.encode('utf-8')+b'\0')
    if not changed and not additions:
        print('Team ping models/imports already match')
        return
    backup=backup_root/datetime.now().strftime('%Y%m%d-%H%M%S-%f')
    backup.mkdir(parents=True)
    shutil.copy2(map_dir/'war3map.imp',backup/'war3map.imp')
    for src,dest,rel in changed:
        if dest.exists():
            saved=backup/rel
            saved.parent.mkdir(parents=True,exist_ok=True)
            shutil.copy2(dest,saved)
        dest.parent.mkdir(parents=True,exist_ok=True)
        shutil.copy2(src,dest)
    if additions:
        (map_dir/'war3map.imp').write_bytes(struct.pack('<II',version,count+len(additions))+original[8:]+b''.join(additions))
    print(f'Team pings: {len(changed)} assets; {len(additions)} imports; backup: {backup}')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--map',required=True,type=Path)
    args = parser.parse_args()
    install(args.map.resolve())
    install_models(args.map.resolve())
