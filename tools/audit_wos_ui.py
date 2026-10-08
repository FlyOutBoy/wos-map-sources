"""Persist the production frame inventory for incremental UI migration."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]

def audit():
    lines = ['# Production UI frame inventory', '',
             'Generated from active source in triggers/. Commented prototypes are excluded.',
             'FRAME roots can migrate to WOSUI; SIMPLEFRAME roots retain a native simple parent.', '']
    files = 0
    for path in sorted((ROOT/'triggers').rglob('*.j')):
        text = path.read_text(encoding='utf-8-sig')
        active = re.sub(r'/\*.*?\*/',lambda m:'\n'*m[0].count('\n'),text,flags=re.S)
        active = re.sub(r'//[^\n]*','',active)
        sites = []
        owner = '(globals)'
        for number,line in enumerate(active.splitlines(),1):
            match = re.search(r'\b(?:function|method) (\w+) takes',line)
            if match:
                owner = match[1]
            if re.search(r'BlzCreateFrame|BlzLoadTOCFile|CreateLeaderboard',line):
                sites.append((number,owner,line.strip()))
        if not sites:
            continue
        files += 1
        relative = path.relative_to(ROOT).as_posix()
        lines += [f'## {relative}', '',f'{len(sites)} creation/TOC sites.', '', '| Line | Function | Creation |', '|---|---|---|']
        for number,owner,line in sites:
            lines.append(f'| {number} | {owner} | `{line.replace("|","/")}` |')
        lines.append('')
    out = ROOT/'docs/ui-redesign/FRAME_INVENTORY.md'
    out.write_text('\n'.join(lines)+'\n',encoding='utf-8')
    print(f'UI owners: {files}; inventory: {out}')

if __name__ == '__main__':
    audit()
