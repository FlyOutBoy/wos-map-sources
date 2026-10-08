"""Verify MAIN UI sources/order/imports and optionally their packed archive copies."""
from pathlib import Path
import argparse
import json
import struct
import sync_war3_triggers as sync
from install_wos_ui_assets import ASSET_NAMES as UI_NAMES
from install_wos_ui_assets import CONSOLE_MODEL, SKIN_VALUES
from install_team_ping_assets import ASSET_NAMES as PING_NAMES

ROOT = Path(__file__).resolve().parents[1]
RESOURCES = [f'UI/WOS/{name}.tga' for name in sorted(UI_NAMES)] + [
    f'UI/TeamPings/{name}.tga' for name in sorted(PING_NAMES)] + [CONSOLE_MODEL]
ARCHIVE_NAMES = ['war3map.wtg', 'war3map.wct', 'war3map.imp', 'war3map.j', 'war3mapSkin.txt'] + RESOURCES


def verify(archive=None):
    scenario = sync.load_map(ROOT / 'object-data.config.json')
    wtg = sync.fmt.parse_wtg(scenario / 'war3map.wtg')
    objects = [o for o in wtg['objects'] if o['object_type'] in (
        sync.fmt.OBJECT_TRIGGER, sync.fmt.OBJECT_SCRIPT)]
    wct = sync.fmt.parse_wct(scenario / 'war3map.wct', len(objects))
    sync.validate_counts(wtg, wct)
    by_id = {o['object_id']: o for o in wtg['objects']}
    # Derive identities directly from native WTG names/categories, independently
    # of the sync manifest written by push (a manifest could repeat a writer bug).
    for obj, source in zip(objects, wct['sources']):
        directory = sync.fmt.category_directory(obj['parent_id'], by_id)
        filename = sync.fmt.safe_name(obj['name'], f"Trigger_{obj['object_id']}") + '.j'
        path = ROOT / 'triggers' / directory / filename
        if source != sync.world_editor_source(path):
            raise AssertionError(f'Native WCT code does not match WTG identity: {path}')
    if wct['header_source'] != sync.world_editor_source(ROOT / 'triggers/Map_Header.j'):
        raise AssertionError('Native map header differs from project')
    imp = (scenario / 'war3map.imp').read_bytes()
    version, count = struct.unpack_from('<II', imp)
    assert version in (1, 2)
    offset = 8
    imports = set()
    for _ in range(count):
        end = imp.index(0, offset + 1)
        name = imp[offset + 1:end].decode('utf-8')
        if imp[offset] in (5, 8):
            name = 'war3mapImported\\' + name
        imports.add(name.replace('\\', '/').casefold())
        offset = end + 1
    assert offset == len(imp), 'Unexpected import tail'
    for relative in RESOURCES:
        assert relative.casefold() in imports, f'Missing import: {relative}'
        assert (scenario / relative).read_bytes() == (ROOT / 'assets' / relative).read_bytes(), relative
    skin = (scenario / 'war3mapSkin.txt').read_text(encoding='utf-8-sig')
    for key, value in SKIN_VALUES.items():
        assert f'{key}={value}' in skin, f'Missing console skin override: {key}'
    if archive:
        for name in ARCHIVE_NAMES:
            assert (archive / name).read_bytes() == (scenario / name).read_bytes(), f'Archive mismatch: {name}'
    print(json.dumps({'native_trigger_count': len(objects), 'native_source_identity': 'PASS',
                      'category_traversal': 'PASS', 'ui_imports': len(RESOURCES),
                      'archive_matches_native': bool(archive), 'game_runtime_tested': False}, indent=2))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--archive', type=Path)
    parser.add_argument('--names-output', type=Path)
    args = parser.parse_args()
    if args.names_output:
        args.names_output.parent.mkdir(parents=True, exist_ok=True)
        args.names_output.write_text(json.dumps(ARCHIVE_NAMES), encoding='utf-8')
        print('Archive extraction name list saved:', args.names_output)
    else:
        verify(args.archive)
