"""Add Altair TEST imports to the saved packed archive Heroes/Altair.w3x, additively.

Sources: Altair icons (assets/AltairTest), every decor/train model used by the TEST
destructables/units and the effect models listed in EFFECTS, each copied byte-for-byte
from the MAIN folder map together with the custom textures it references.
Missing textures are assumed to be Warcraft built-ins. MAIN is only read.
The archive is backed up first; existing imports and payloads are not replaced.

    python tools/install_altair_test_assets.py [--dry-run]
"""
from pathlib import Path
from datetime import datetime
import argparse
import json
import re
import shutil
import struct
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
PROFILE = ROOT/'test_map/profiles/Altair'
ICONS = ROOT/'assets/AltairTest'
# Effect models referenced by test_map/heroes/Altair.j.
EFFECTS = [
    'war3mapImported\\wos_alucard bulletfire.mdl', 'war3mapImported\\wos_alucard bullet.mdl',
    'war3mapImported\\wos_hit-juhuang1.mdl', 'war3mapImported\\wos_zk_shiki_dash.mdl',
    'war3mapImported\\wos_HealBlue.mdl', 'war3mapImported\\wos_title_shielded.mdl',
    'war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx', 'war3mapImported\\wos_shielddome2.mdl',
    'war3mapImported\\wos_clockwisetimer3.mdl', 'war3mapImported\\wos_yc_bluemorphcircle3.mdl',
    'war3mapImported\\wos_yc_bluemorphcircle2.mdl', 'war3mapImported\\wos_whitering.mdx',
    'war3mapImported\\wos_fbt-dilie22.mdl', 'war3mapImported\\wos_dustbrown.mdl',
    'war3mapImported\\wos_GZ_jntxn (11)_R1-200.mdl', 'war3mapImported\\wos_obr08 (171).mdl',
    'war3mapImported\\wos_by_wood_effect_yuzhiboyou_unusual_fenshendabaopo_2.mdl',
    'war3mapImported\\wos_[Spell]EnergyShield-blackred.mdx', 'war3mapImported\\wos_blackblink.mdx',
    'war3mapImported\\wos_Erza_sword2.mdx', 'war3mapImported\\wos_az_jingzi_jiansheng01_e1_l2.mdl',
    'war3mapImported\\wos_daoguang_blue_hitsword.mdx', 'war3mapImported\\wos_1baozha_90.mdl',
    'war3mapImported\\wos_shachen1.mdl', 'war3mapImported\\wos_item_goldcredit.mdl',
    'war3mapImported\\wos_Razor_leaf-A392F3.mdl', 'war3mapImported\\wos_solaire_lightning_impact.mdl',
    'war3mapImported\\wos_t8_by_wood_effect_order_dange_daoguang_baozha_2_2_clear.mdl',
    'war3mapImported\\wos_Opdef (571)2.mdl',
]
# Models chosen from the user's library (ZZZZZZ), imported under war3mapImported\wos_<name>.
LIBRARY = Path(r'E:\WAR3REF\Warcraft III\_retail_\ZZZZZZ')
EXTERNAL = [
    'effect_mythic_VoidRiftPurple.mdx', 'cronosphere.mdx', 'AsNodtSphere.mdx', 'KyorakuPetals.mdx',
    'mirrorzi_effect_ansekuosanbo.mdx', 'Mdx_Effect_MirrorImage_White.mdx', 'huoqiang02_T1.mdx',
    'effect_fate_jiujian_galibang_qixuan.mdx', 'effect_fate_jiujian_chongjibo.mdx',
    'LXY-ZK_BM_The might of a sword_LAN-2.mdx', 'az_erdaoliujianqi.mdx',
]


def folder_index(root):
    return {p.relative_to(root).as_posix().replace('/', '\\').casefold(): p for p in root.rglob('*') if p.is_file()}


def model_textures(data):
    if data[:4] == b'MDLX':
        offset, found = 4, []
        while offset+8 <= len(data):
            tag, size = data[offset:offset+4], struct.unpack_from('<I', data, offset+4)[0]
            if tag == b'TEXS':
                for start in range(offset+8, offset+8+size, 268):
                    name = data[start+4:start+264].split(b'\0')[0]
                    if name:
                        found.append(name.decode('utf8', 'replace'))
            offset += 8+size
        return found
    return re.findall(r'Image\s+"([^"]+)"', data.decode('utf8', 'replace'))


def resolve(index, name):
    key = name.replace('/', '\\').casefold()
    candidates = [key]
    stem, dot, extension = key.rpartition('.')
    if extension in ('mdl', 'mdx'):
        candidates.append(stem+('.mdx' if extension == 'mdl' else '.mdl'))
    return next(((c, index[c]) for c in candidates if c in index), (None, None))


def collect(main):
    index = folder_index(main)
    destructables = json.loads((PROFILE/'object-data/destructables.json').read_text('utf8'))
    units = json.loads((PROFILE/'object-data/units.json').read_text('utf8'))
    models = [v['field_bfil'] for k, v in destructables.items() if v.get('field_bfil', '').strip(' .')]
    models += [units[k]['model'] for k in ('h00G', 'h02N')]
    files, missing = {}, []
    for model in [*models, *EFFECTS]:
        key, path = resolve(index, model)
        if path is None:
            missing.append(model)
            continue
        files[path.relative_to(main).as_posix().replace('/', '\\')] = path
        for texture in model_textures(path.read_bytes()):
            tkey, tpath = resolve(index, texture)
            if tpath is not None:
                files[tpath.relative_to(main).as_posix().replace('/', '\\')] = tpath
    # Library textures are found by file name and imported at the path the model references.
    library = {}
    for path in LIBRARY.rglob('*'):
        if path.is_file():
            library.setdefault(path.name.casefold(), path)
    for name in EXTERNAL:
        path = library.get(name.casefold())
        if path is None:
            missing.append(name)
            continue
        files['war3mapImported\\wos_'+name] = path
        for texture in model_textures(path.read_bytes()):
            tkey, tpath = resolve(index, texture)
            if tpath is not None:
                files[tpath.relative_to(main).as_posix().replace('/', '\\')] = tpath
            # Textures\ and UI\ are Warcraft built-ins: importing library copies would override them map-wide.
            elif not texture.replace('/', '\\').casefold().startswith(('textures\\', 'ui\\')) \
                    and texture.replace('/', '\\').split('\\')[-1].casefold() in library:
                files[texture.replace('/', '\\')] = library[texture.replace('/', '\\').split('\\')[-1].casefold()]
    # Icons and the Hero_Altair_*.mp3 voice lines cut from the anime.
    for path in [*ICONS.rglob('*.blp'), *ICONS.rglob('*.mp3')]:
        files[path.relative_to(ICONS).as_posix().replace('/', '\\')] = path
    return files, missing


REALM = ('AltairRealm', (-3200.0, -3456.0, -1856.0, -2112.0)) # matches profile TestBase.vj


def with_realm(data):
    """Return war3map.w3r with the Fate Reconstruction rect, or None when it already exists."""
    version, count = struct.unpack_from('<II', data)
    offset, last = 8, -1
    for _ in range(count):
        offset += 16
        end = data.index(0, offset)
        if data[offset:end].decode('utf8') == REALM[0]:
            return None
        offset = end+1
        last = max(last, struct.unpack_from('<I', data, offset)[0])
        # index, weather, ambient sound, color + end; Reforged v7 appends 8 more bytes.
        offset = data.index(0, offset+8)+1+4+(8 if version >= 7 else 0)
    if offset != len(data) or version not in (5, 7):
        raise ValueError('Unexpected W3R layout')
    record = struct.pack('<4f', *REALM[1])+REALM[0].encode()+b'\0'+struct.pack('<I', last+1)+b'\0'*4+b'\0'+b'\xff\x80\x80\xff'
    if version >= 7:
        record += b'\0'*8
    return struct.pack('<II', version, count+1)+data[8:]+record


def run_archive(mode, archive, directory, names, library):
    subprocess.run(['powershell', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File',
                    str(ROOT/'.vscode/test-map-archive.ps1'), '-Mode', mode, '-Map', str(archive),
                    '-Directory', str(directory), '-Library', str(library), '-NamesFile', str(names)], check=True)


def install(dry_run):
    config = json.loads((ROOT/'.vscode/wos-build.json').read_text('utf-8-sig'))
    if config.get('testHero') != 'Altair':
        raise ValueError('Select testHero Altair first')
    # Only this archive is written: an editor working on another map (e.g. MAIN) is left alone.
    closed = subprocess.run(['powershell', '-NoProfile', '-Command',
        "if (Get-Process -Name 'World Editor','WorldEditorTESH' -ErrorAction SilentlyContinue | "
        "Where-Object { $_.MainWindowTitle -like '*Altair*' }) {exit 1}"], capture_output=True)
    if closed.returncode:
        raise ValueError('Close Altair.w3x in World Editor before writing map assets')
    main = Path(config['mainMap'])
    archive = Path(config['testMapsDir'])/'Altair.w3x'
    library = ROOT/config['jassHelper']
    library = library.parent/'sfmpq.dll'
    files, missing = collect(main)
    (ROOT/'_build').mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='altair-assets-', dir=ROOT/'_build') as temporary:
        stage = Path(temporary)
        names = stage/'names.json'
        names.write_text(json.dumps(['war3map.imp', '(listfile)', 'war3map.w3r']), encoding='utf8')
        run_archive('Extract', archive, stage, names, library)
        present = {line.strip().casefold() for line in (stage/'(listfile)').read_text('utf8', 'replace').splitlines()}
        imp = (stage/'war3map.imp').read_bytes()
        version, count = struct.unpack_from('<II', imp)
        offset, registered = 8, set()
        for _ in range(count):
            end = imp.index(0, offset+1)
            name = imp[offset+1:end].decode('utf8')
            if imp[offset] in (5, 8):
                name = 'war3mapImported\\'+name
            registered.add(name.casefold())
            offset = end+1
        if offset != len(imp) or version not in (1, 2):
            raise ValueError('Invalid IMP')
        added = [n for n in sorted(files) if n.casefold() not in present]
        # SFmpq updates do not maintain the listfile that editors use to enumerate imports.
        listed = (stage/'(listfile)').read_text('utf8', 'replace').splitlines()
        (stage/'(listfile)').write_text('\r\n'.join([*listed, *added])+'\r\n', encoding='utf8')
        register = [n for n in sorted(files) if n.casefold() not in registered]
        # Project-owned Altair files (icons, voice lines) are replaced when they changed; library/MAIN copies are not.
        owned = [n for n in sorted(files) if n not in added and files[n].is_relative_to(ICONS)]
        changed = []
        if owned:
            existing = stage/'existing'
            (stage/'owned.json').write_text(json.dumps(owned, ensure_ascii=False), encoding='utf8')
            run_archive('Extract', archive, existing, stage/'owned.json', library)
            changed = [n for n in owned if (existing/n).read_bytes() != files[n].read_bytes()]
        regions = with_realm((stage/'war3map.w3r').read_bytes())
        print(f'{len(files)} assets resolved, {len(added)} new payloads, {len(changed)} changed, {len(register)} new import records,'
              f' realm rect {"missing" if regions else "present"}')
        for model in missing:
            print('  not in MAIN (built-in or absent):', model)
        if dry_run:
            return
        backup = ROOT/'backups/test-maps/Altair'/datetime.now().strftime('%Y%m%d-%H%M%S-assets')
        backup.mkdir(parents=True)
        shutil.copy2(archive, backup/archive.name)
        for name in [*added, *changed]:
            target = stage/name
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(files[name], target)
        (stage/'war3map.imp').write_bytes(struct.pack('<II', version, count+len(register))+imp[8:]+
                                          b''.join(b'\x0d'+n.encode('utf8')+b'\0' for n in register))
        # The archive script's Update guard expects the trigger pair; only listed names are written.
        for name in ('war3map.wtg', 'war3map.wct'):
            shutil.copy2(PROFILE/'unpacked'/name, stage/name)
        written = ['war3map.imp', '(listfile)', *added, *changed]
        if regions:
            (stage/'war3map.w3r').write_bytes(regions)
            written.append('war3map.w3r')
        names.write_text(json.dumps(written, ensure_ascii=False), encoding='utf8')
        run_archive('Update', archive, stage, names, library)
        print('Altair assets installed; backup', backup)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--dry-run', action='store_true')
    install(parser.parse_args().dry_run)
