"""Add only the six isolated hero-bar textures to a built TEST archive.

Read fresh import/listfile data first. Existing payloads and import records win;
never run the MAIN HUD/skin installer or restore deleted unrelated imports.
"""
from pathlib import Path
import argparse
import json
import shutil
import struct
import subprocess

ROOT = Path(__file__).resolve().parents[1]
TEXTURES = ('panel', 'empty', 'bar-back', 'meter-fill', 'divider-h', 'divider-v')


def stage_assets(directory: Path, existing: list[str], source: Path) -> list[str]:
    saved = {name.replace('/', '\\').casefold(): name for name in existing}
    imp = directory/'war3map.imp'
    original = imp.read_bytes()
    version, count = struct.unpack_from('<II', original)
    if version not in (1, 2):
        raise ValueError('Unsupported import table')
    offset = 8
    registered = set()
    for _ in range(count):
        end = original.index(0, offset+1)
        name = original[offset+1:end].decode('utf-8')
        if original[offset] in (5, 8):
            name = 'war3mapImported\\'+name
        registered.add(name.replace('/', '\\').casefold())
        offset = end+1
    if offset != len(original):
        raise ValueError('Invalid import table tail')
    additions, changed = [], []
    for texture in TEXTURES:
        name = 'UI\\WOS\\'+texture+'.tga'
        if name.casefold() not in saved:
            target = directory/'UI/WOS'/(texture+'.tga')
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(source/(texture+'.tga'), target)
            changed.append(name)
        if name.casefold() not in registered:
            additions.append(b'\x0d'+name.encode('utf-8')+b'\0')
    if additions:
        imp.write_bytes(struct.pack('<II', version, count+len(additions))+original[8:]+b''.join(additions))
        changed.append('war3map.imp')
    return changed


def install(archive: Path, directory: Path, library: Path) -> list[str]:
    directory.mkdir(parents=True, exist_ok=True)
    names_file = directory/'asset-operation-names.json'

    def run(mode, names):
        names_file.write_text(json.dumps(names, ensure_ascii=False), encoding='utf-8')
        subprocess.run(['powershell', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File',
            str(ROOT/'.vscode/test-map-archive.ps1'), '-Mode', mode, '-Map', str(archive),
            '-Directory', str(directory), '-Library', str(library), '-NamesFile', str(names_file)], check=True)

    run('Extract', ['(listfile)', 'war3map.imp', 'war3map.wct', 'war3map.wtg'])
    existing = (directory/'(listfile)').read_text(encoding='utf-8-sig').splitlines()
    changed = stage_assets(directory, existing, ROOT/'assets/UI/WOS')
    if changed:
        run('Update', changed)
    return changed


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--archive', type=Path, required=True)
    parser.add_argument('--stage', type=Path, required=True)
    parser.add_argument('--library', type=Path, required=True)
    args = parser.parse_args()
    changed = install(args.archive.resolve(), args.stage.resolve(), args.library.resolve())
    print('TEST hero bars: '+str(len(changed))+' texture/import payloads added; existing imports preserved')
