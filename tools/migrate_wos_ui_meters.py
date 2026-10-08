"""One-time presentation-only migration of the existing six-frame hero meters.

Run with --apply only once. Commented prototypes and non-frame gameplay statements
are preserved; an independent non-presentation fingerprint guards every rewrite.
"""
from pathlib import Path
import argparse
import re

ROOT = Path(__file__).resolve().parents[1]


def mask(source):
    return re.sub(r'/\*.*?\*/', lambda m: ' ' * len(m[0]), source, flags=re.S)


def gameplay(source):
    active = re.sub(r'/\*.*?\*/', '', source, flags=re.S)
    lines = []
    for line in active.splitlines():
        line = line.split('//')[0].strip()
        if not line or re.match(r'call (?:BlzFrame|WUI_)', line):
            continue
        if re.match(r'set \w+\s*\[.*?\]\s*=\s*(?:BlzCreateFrame|WUI_)', line):
            continue
        lines.append(line)
    return lines


def migrate(path):
    before = path.read_text(encoding='utf-8-sig')
    active = mask(before)
    roots = list(re.finditer(
        r'(?m)^(\s*)set (\w+1)\s*\[\s*([^]]+)\]\s*=\s*BlzCreateFrameByType\("BACKDROP", "SS",\s*main_frame, "", 0\)', active))
    edits = []
    count = 0
    for root in roots:
        indent, name, index = root.groups()
        indent = indent.split('\n')[-1]
        prefix = name[:-1]
        refs = [f'{prefix}{i}[{index.strip()}]' for i in range(1, 7)]
        tail = active[root.start():root.start()+6200]
        # Exclude the Second Origin's distinct two-icon/seven-frame meter.
        value_scale = re.search(r'call BlzFrameSetScale\(\s*'+prefix+r'6\s*\[\s*'+re.escape(index.strip())+r'\s*\],\s*0\.90?\)', tail)
        if not value_scale or 'human-xpbar-border.blp' not in tail[:value_scale.end()]:
            continue
        block = before[root.start():root.start()+value_scale.end()]
        if not re.search(r'set '+prefix+r'5\s*\[.*?\]\s*= BlzCreateFrameByType\("TEXT"', block):
            continue
        block = re.sub(r'BlzCreateFrameByType\("BACKDROP", "SS",\s*main_frame, "", 0\)',
                       'WUI_Window("WOSHeroMeter", main_frame, 0, 0)', block, count=1)
        block = re.sub(r'BlzCreateFrame\("EscMenuControlBackdropTemplate",\s*([^,]+), 0, 0\)',
                       r'BlzCreateFrameByType("BACKDROP", "WOSMeterBack", \1, "", 0)', block)
        targets = prefix + r'[1-6]\s*\[\s*' + re.escape(index.strip()) + r'\s*\]'
        block = re.sub(r'(?m)^\s*call BlzFrameSet(?:AbsPoint|Point|Size|Scale)\(\s*'+targets+r',.*?\)\s*$', '', block)
        block = re.sub(r'(?m)^\s*call BlzFrameSetTexture\(\s*'+re.escape(name)+r'\s*\[.*?\],.*human-xpbar-border.*?\)\s*$', '', block)
        block = re.sub(r'(?m)^\s*call BlzFrameSetModel\(\s*'+prefix+r'3\s*\[.*?\],.*?\)\s*$', '', block)
        block = re.sub(r'\n[ \t]*\n', '\n', block)
        key = path.relative_to(ROOT / 'triggers').as_posix() + ':' + name + ':'
        if (path.name, name) in [('Kenjaku.j', 'frame2_pas1'), ('Kyoraku.j', 'frame_KyorBankai1')]:
            register = f'WUI_RegisterPublicMeter({refs[0]}, "{key}" + I2S({index.strip()}))'
        else:
            register = f'WUI_RegisterMeter({refs[0]}, {index.strip()}, "{key}" + I2S({index.strip()}))'
        block += '\n' + indent + 'call WUI_HeroMeter(' + ', '.join(refs) + ')'
        block += '\n' + indent + 'call ' + register
        block += '\n' + indent + 'call WUI_RefreshDocks()'
        edits.append((root.start(), root.start()+value_scale.end(), block))
        count += 1
    after = before
    for start, end, replacement in reversed(edits):
        after = after[:start] + replacement + after[end:]
    assert gameplay(before) == gameplay(after), f'Non-presentation change: {path}'
    return after, count


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apply', action='store_true')
    args = parser.parse_args()
    total = 0
    files = list((ROOT/'triggers/Heroes').rglob('*.j')) + [ROOT/'triggers/Systems/DecorDestroy_and_Erza_Debuff.j']
    for path in files:
        source, count = migrate(path)
        if count:
            print(path.relative_to(ROOT), count)
            total += count
            if args.apply:
                path.write_bytes(source.replace('\r\n', '\n').replace('\n', '\r\n').encode('utf-8'))
    print('Active six-frame meters:', total, 'mode:', 'APPLY' if args.apply else 'CHECK')
