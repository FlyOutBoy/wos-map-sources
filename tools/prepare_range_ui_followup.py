"""Apply the supplied wide Pick/Random art and small toolbar adjustments to TEST.

Source patches are deliberately isolated from enabled MAIN triggers. Assets are
ordinary project imports; the previous Pick/Random files are never overwritten.
"""
from pathlib import Path
import argparse
import json
from install_team_ping_assets import install as install_textures

ROOT = Path(__file__).resolve().parents[1]
NAMES = {f'pick-{kind}-wide{state}' for kind in ('confirm', 'random') for state in ('', '-off')}


def replace(s, old, new, count=1):
    if s.count(old) != count:
        raise ValueError(f'Unexpected TEST source context: {old[:100]}')
    return s.replace(old, new)


def toolbar(s):
    # Relative offsets on the scaled TEXT use its scale. Match the other labels'
    # absolute .5645 baseline without changing the button or folded menu layout.
    s = replace(s, 'FRAMEPOINT_CENTER, WUI_Menu, FRAMEPOINT_CENTER, 0.00, -0.0135)',
                'FRAMEPOINT_CENTER, WUI_Menu, FRAMEPOINT_CENTER, 0.00, -0.0135 / 0.62)', 2)
    s = replace(s, '    set WUI_MenuLabel = text\n',
                '    set WUI_MenuLabel = text\n    call BlzFrameClearAllPoints(text)\n')
    s = replace(s, 'call BlzFrameSetSize(back, 0.020, 0.020)\n    call BlzFrameSetTexture(back, "UI\\\\WOS\\\\glyph-menu.tga"',
                'call BlzFrameSetSize(back, 0.024, 0.024)\n    call BlzFrameSetTexture(back, "UI\\\\WOS\\\\glyph-menu.tga"')
    s = replace(s, 'WUI_PlaceRight(WUI_StatsButton, 0.126, 0.584, 0.022, 0.022)',
                'WUI_PlaceRight(WUI_StatsButton, 0.126, 0.584, 0.020, 0.017)')
    start = s.index('private function WUI_SizeHotkeyBadge ')
    end = s.index('endfunction', start)
    body = s[start:end]
    marker = '    if StringLength(name) >= 3 then'
    # Keep the Range badge's existing separate size branch intact.
    point = body.rindex(marker)
    body = body[:point] + '''    if channel == WUI_HOTKEY_STATS then
        if StringLength(name) >= 3 then
            call BlzFrameSetSize(WUI_HotkeyButton[channel], 0.0170, 0.0080)
        elseif StringLength(name) == 2 then
            call BlzFrameSetSize(WUI_HotkeyButton[channel], 0.0130, 0.0080)
        else
            call BlzFrameSetSize(WUI_HotkeyButton[channel], 0.0100, 0.0080)
        endif
        return
    endif
''' + body[point:]
    return s[:start] + body + s[end:]


def pick(s):
    for kind in ('confirm', 'random'):
        for state in ('', '-off'):
            old = f'pick-{kind}{state}.tga'
            if old not in s:
                raise ValueError('Missing pick state: ' + old)
            s = s.replace(old, f'pick-{kind}-wide{state}.tga')
    return replace(s, '        call WUI_Place(FRAME_Pick[i], 0.293 + I2R(i - 2) * 0.082, 0.236, 0.034, 0.034)', '''        if i < 4 then
            // Two-cell centers, +2% width; all three controls share .034 height.
            call WUI_Place(FRAME_Pick[i], 0.293 + 0.0205 + I2R(i - 2) * 0.082, 0.236, 0.0785, 0.034)
        else
            call WUI_Place(FRAME_Pick[i], 0.293 + I2R(i - 2) * 0.082, 0.236, 0.034, 0.034)
        endif''')


def install(workspace):
    workspace = workspace.resolve()
    if workspace == ROOT or ROOT in workspace.parents or workspace in ROOT.parents:
        raise ValueError('Isolated TEST workspace required')
    cfg = json.loads((workspace / '.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
    scenario = Path(cfg['mainMap']).resolve()
    if workspace.parent not in scenario.parents:
        raise ValueError('Profile targets production MAIN')
    changes = {}
    for name, fn in [('WOSUI.j', toolbar), ('WoS_Pick_Init.j', pick)]:
        path = workspace / 'triggers/WOS_Start' / name
        changes[path] = fn(path.read_text(encoding='utf-8-sig'))
    # Preflight transformations above, then preserve original import bytes/paths.
    source = ROOT / 'assets/UI/WOS'
    import tempfile, shutil
    with tempfile.TemporaryDirectory() as tmp:
        for name in NAMES:
            shutil.copy2(source / (name + '.tga'), Path(tmp) / (name + '.tga'))
        install_textures(scenario, Path(tmp), workspace.parent / 'backup-pick-assets', NAMES, 'UI/WOS')
    for path, text in changes.items():
        path.write_bytes(text.replace('\n', '\r\n').encode('utf-8'))
    print('TEST toolbar / wide Pick-Random applied:', workspace)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--workspace', type=Path, required=True)
    install(parser.parse_args().workspace)
