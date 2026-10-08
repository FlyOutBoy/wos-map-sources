"""Register shared UI resources without changing existing imports."""
from pathlib import Path
import argparse
from datetime import datetime
import re
import shutil
import struct
from install_team_ping_assets import install

ROOT = Path(__file__).resolve().parents[1]
ASSET_NAMES = {'panel','border','button','hover','pressed','selected','disabled','hp','mp','meter','bar-back','checked','unchecked'}
ASSET_NAMES.update('ornate-' + suffix for suffix in ('tl','tr','bl','br','top','bottom','left','right'))
CONSOLE_MODEL = 'UI/WOS/empty-clock.mdx'
FRAME_RESOURCES = ['UI/WOS/WOSHUD.fdf', 'UI/WOS/WOSHUD.toc']
BLANK_TEXTURE = r'UI\Widgets\EscMenu\Human\blank-background.blp'
SKIN_VALUES = {f'ConsoleTexture{i:02}': BLANK_TEXTURE for i in range(1, 7)}
SKIN_VALUES.update(ConsoleTexture05Overlay=BLANK_TEXTURE, ConsoleTexture06Overlay=BLANK_TEXTURE,
                   ConsoleInventoryCoverTexture=BLANK_TEXTURE,
                   TimeOfDayIndicator=CONSOLE_MODEL.replace('/', '\\'))


def hide_stock_console(text):
    """Edit only CustomSkin keys; preserve translations and unrelated overrides."""
    match = re.search(r'(?m)^\[CustomSkin\][^\n]*\n', text)
    if not match:
        return '[CustomSkin]\n' + '\n'.join(f'{k}={v}' for k, v in SKIN_VALUES.items()) + '\n\n' + text
    end = re.search(r'(?m)^\[', text[match.end():])
    stop = match.end() + end.start() if end else len(text)
    section = text[match.end():stop]
    for key, value in SKIN_VALUES.items():
        pattern = re.compile(rf'(?m)^{re.escape(key)}=[^\r\n]*')
        if pattern.search(section):
            section = pattern.sub(lambda _: key + '=' + value, section)
        else:
            section = section.rstrip() + '\n' + key + '=' + value + '\n\n'
    return text[:match.end()] + section + text[stop:]


def install_console(map_dir):
    model = ROOT / 'assets' / CONSOLE_MODEL
    destination = map_dir / CONSOLE_MODEL
    skin = map_dir / 'war3mapSkin.txt'
    original = skin.read_bytes() if skin.exists() else b''
    old_text = original.decode('utf-8-sig')
    updated_text = hide_stock_console(old_text)
    updated = updated_text.encode('utf-8') if updated_text != old_text else original
    imp = map_dir / 'war3map.imp'
    imports = imp.read_bytes()
    version, count = struct.unpack_from('<II', imports)
    offset = 8
    registered = set()
    for _ in range(count):
        flag = imports[offset]
        end = imports.index(0, offset + 1)
        name = imports[offset + 1:end].decode('utf-8')
        if flag in (5, 8):
            name = 'war3mapImported\\' + name
        registered.add(name.replace('\\', '/').casefold())
        offset = end + 1
    if version not in (1, 2) or offset != len(imports):
        raise ValueError('Invalid imports; console installation stopped')
    add_model = CONSOLE_MODEL.casefold() not in registered
    changed_model = not destination.exists() or destination.read_bytes() != model.read_bytes()
    if updated == original and not add_model and not changed_model:
        return
    backup = ROOT / 'backups/ui-redesign/console' / datetime.now().strftime('%Y%m%d-%H%M%S-%f')
    backup.mkdir(parents=True)
    if skin.exists():
        shutil.copy2(skin, backup / skin.name)
    shutil.copy2(imp, backup / imp.name)
    if destination.exists():
        shutil.copy2(destination, backup / 'empty-clock.mdx')
    skin.write_bytes(updated)
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(model, destination)
    if add_model:
        imp.write_bytes(struct.pack('<II', version, count + 1) + imports[8:] +
                        b'\x0d' + CONSOLE_MODEL.replace('/', '\\').encode('utf-8') + b'\0')
    print('Stock console skin/model installed; backup:', backup)

def install_ui(map_dir):
    install(map_dir,ROOT/'assets/UI/WOS',ROOT/'backups/ui-redesign/assets',ASSET_NAMES,'UI/WOS')
    install_console(map_dir)
    install_frame_resources(map_dir)


def install_frame_resources(map_dir):
    imp = map_dir / 'war3map.imp'
    original = imp.read_bytes()
    version, count = struct.unpack_from('<II', original)
    offset = 8
    registered = set()
    for _ in range(count):
        end = original.index(0, offset + 1)
        name = original[offset + 1:end].decode('utf-8')
        if original[offset] in (5, 8):
            name = 'war3mapImported\\' + name
        registered.add(name.replace('\\', '/').casefold())
        offset = end + 1
    if version not in (1, 2) or offset != len(original):
        raise ValueError('Invalid imports; frame installation stopped')
    changed = [name for name in FRAME_RESOURCES if not (map_dir / name).exists()
               or (map_dir / name).read_bytes() != (ROOT / 'assets' / name).read_bytes()]
    additions = [name for name in FRAME_RESOURCES if name.casefold() not in registered]
    if not changed and not additions:
        return
    backup = ROOT / 'backups/ui-redesign/frames' / datetime.now().strftime('%Y%m%d-%H%M%S-%f')
    backup.mkdir(parents=True)
    shutil.copy2(imp, backup / imp.name)
    for name in changed:
        destination = map_dir / name
        if destination.exists():
            saved = backup / name
            saved.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(destination, saved)
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(ROOT / 'assets' / name, destination)
    if additions:
        imp.write_bytes(struct.pack('<II', version, count + len(additions)) + original[8:] +
                        b''.join(b'\x0d' + name.replace('/', '\\').encode('utf-8') + b'\0' for name in additions))
    print('Native HUD frame definitions installed; backup:', backup)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--map',required=True,type=Path)
    args = parser.parse_args()
    install_ui(args.map.resolve())
