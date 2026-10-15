"""Promote an approved full Range candidate; remove the retired Hold feature.

No map writes: map backup is taken here, then use normal check/save/build.
"""
from pathlib import Path
import argparse,hashlib,json,re,shutil

ROOT=Path(__file__).resolve().parents[1]


def write(p,s):
    p.parent.mkdir(parents=True,exist_ok=True)
    p.write_bytes(s.replace('\r\n','\n').replace('\n','\r\n').encode('utf-8'))


def remove_function(s,name):
    s,n=re.subn(r'(?m)^(?:private )?function '+name+r' takes[^\n]*\n[\s\S]*?^endfunction\n', '',s)
    if n!=1:raise ValueError('Expected function '+name)
    return s


def if_span(s,start):
    """Find matching endif; don't mistake nested branches for the outer end."""
    depth=0
    for m in re.finditer(r'(?m)^\s*(if\b[^\n]*then|endif)\s*$',s[start:]):
        depth+= -1 if m[1]=='endif' else 1
        if depth==0:return start+m.end()
    raise ValueError('Unclosed if')


def remove_hold_preview(s):
    for line in ('    private boolean array AR_Held\n','    private unit array AR_LatchedHero\n',
                 '    private integer array AR_LatchedAbility\n','    private oskeytype array AR_HeldKey\n',
                 '    private framehandle AR_HoldLabel = null\n'):
        if line not in s:raise ValueError(line)
        s=s.replace(line,'')
    begin=s.index('        if hero != null and AR_Held[pid] then')
    s=s[:begin]+s[if_span(s,begin):]
    begin=s.index('        if not AR_Held[pid] then')
    end=if_span(s,begin)
    s=s[:begin]+'        call AR_Conceal()\n'+s[end:]
    begin=s.index('        set AR_Held[pid] = false')
    end=s.index('        call AR_Hide(pid)',begin)
    s=s[:begin]+s[end:]
    begin=s.index('    // Key down/up events own the latch.')
    end=s.index('    if WUI_RangePreviewBlocked() then',begin)
    s=s[:begin]+s[end:]
    s=s[:s.index('private function AR_OnHoldKey takes')]+'''private function AR_Init takes nothing returns nothing
    // Reconciliation and rendering use the existing AHUI tick; no key control.
endfunction
endlibrary
'''
    s=s.replace('// TEST ONLY. Installed by tools/prepare_ability_range_test.py; never enabled in MAIN.',
                '// Shared hover-only range/AoE preview. Approved Range3 integration.')
    return s.replace('// Soft tooltip leave preserves the last hovered skill only while held.',
                     '// Leaving a skill hides its circle immediately.')


def remove_hold_wui(s):
    s=s.replace('    constant integer WUI_HOTKEY_RANGE = 6\n','').replace('WUI_HOTKEY_CHANNELS = 7','WUI_HOTKEY_CHANNELS = 6')
    s=remove_function(s,'WUI_RangeHoldInputBlocked')
    # Size special-case ends in return, before the normal Stats badge size.
    begin=s.index('    if channel == WUI_HOTKEY_RANGE then');end=if_span(s,begin)
    s=s[:begin]+s[end:]
    s=s.replace('            elseif other == WUI_HOTKEY_RANGE then\n                set title = "Hold Range/AoE"\n','')
    # Click cleanup: retain ordinary badges' original behavior.
    begin=s.index('    if channel == WUI_HOTKEY_RANGE then');end=if_span(s,begin)
    s=s[:begin]+'    call WUI_ReleaseClickFocus()\n'+s[end:]
    # Text scale special-case.
    begin=s.rindex('    if channel == WUI_HOTKEY_RANGE then',0,s.index('call BlzFrameSetScale(WUI_HotkeyLabel[channel], 0.50)'));end=if_span(s,begin)
    s=s[:begin]+'    call BlzFrameSetScale(WUI_HotkeyLabel[channel], 0.62)\n'+s[end:]
    # Anchor / tooltip branches start with Hold, followed by normal Stats.
    for _ in range(2):
        begin=s.index('    if channel == WUI_HOTKEY_RANGE then')
        end=s.index('    elseif channel == WUI_HOTKEY_STATS then',begin)
        s=s[:begin]+s[end:].replace('    elseif channel == WUI_HOTKEY_STATS then','    if channel == WUI_HOTKEY_STATS then',1)
    if 'WUI_HOTKEY_RANGE' in s:raise ValueError('Hold reference left in WOSUI')
    return s


def promote(candidate,backup,resume=False):
    candidate=candidate.resolve();backup=backup.resolve()
    cfg=json.loads((ROOT/'.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
    main=Path(cfg['mainMap']).resolve()
    if candidate==ROOT or not (candidate/'triggers/WOS_Start/AbilityRangePreview.j').is_file():
        raise ValueError('Expected approved external full candidate')
    if backup.exists():
        if not resume or not (backup/'main-before.json').exists() or (backup/'promotion.json').exists():
            raise ValueError('Backup path already exists')
    else:
        backup.mkdir(parents=True)
        shutil.copytree(ROOT/'triggers',backup/'project/triggers')
        shutil.copytree(main,backup/'MAIN-before')
        hashes={str(p.relative_to(main)):hashlib.sha256(p.read_bytes()).hexdigest() for p in main.rglob('*') if p.is_file()}
        (backup/'main-before.json').write_text(json.dumps(hashes,indent=2),encoding='utf-8')
        for name in ('.vscode/wos-build.json','object-data.config.json'):
            q=backup/'project'/name;q.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(ROOT/name,q)
    changed=[];pending={}
    for p in (candidate/'triggers').rglob('*.j'):
        rel=p.relative_to(candidate);dest=ROOT/rel
        # Current project has an independent desync probe here; retain it.
        if rel.as_posix()=='triggers/Systems/Systems1.j':continue
        s=p.read_text(encoding='utf-8-sig')
        if p.name=='AbilityRangePreview.j':s=remove_hold_preview(s)
        elif p.name=='WOSUI.j':s=remove_hold_wui(s)
        elif p.name=='SaveLoad.j':s=s.replace(' and Hold Range/AoE bindings.',' bindings.')
        elif rel.as_posix()=='triggers/Systems/Killme.j':
            s=s.replace('// TEST-only replacement for Systems/Killme.j. Death state stays synchronized;',
                        '// Explicit death countdown. Death state stays synchronized;')
        if not dest.exists() or dest.read_text(encoding='utf-8-sig')!=s:
            pending[dest]=s;changed.append(rel.as_posix())
    for p,s in pending.items():write(p,s)
    path=ROOT/'triggers/trigger-settings.json';settings=json.loads(path.read_text(encoding='utf-8-sig'))
    settings['triggers']['WOS_Start/AbilityRangePreview.j']=True
    write(path,json.dumps(settings,ensure_ascii=False,indent=2)+'\n')
    report={'candidate':str(candidate),'backup':str(backup),'MAIN':str(main),'changed_sources':changed,
            'preserved_independent_source':'triggers/Systems/Systems1.j','Hold_removed':True}
    (backup/'promotion.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
    print(json.dumps(report,ensure_ascii=False,indent=2))


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate',type=Path,required=True);parser.add_argument('--backup',type=Path,required=True)
    parser.add_argument('--resume-incomplete',action='store_true')
    args=parser.parse_args();promote(args.candidate,args.backup,args.resume_incomplete)
