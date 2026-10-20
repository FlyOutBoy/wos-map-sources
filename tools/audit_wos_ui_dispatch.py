"""Audit the compiled UI call graph, including JassHelper's implicit dispatch.

This checks direct calls, not engine event delivery or multiplayer behavior.
Startup allocation and shared gameplay ability hooks are reported separately.
"""
from pathlib import Path
import argparse
import json
import re

ROOT = Path(__file__).resolve().parents[1]
DISPATCH = {'ExecuteFunc', 'TriggerExecute', 'TriggerEvaluate'}
ALLOCATE = {'CreateTrigger', 'CreateTimer', 'CreateGroup', 'CreateUnit',
            'InitHashtable', 'BlzCreateFrame', 'BlzCreateFrameByType',
            'BlzCreateSimpleFrame', 'BlzGetFrameByName', 'BlzGetOriginFrame',
            'BlzFrameGetChild', 'BlzGetUnitAbility'}
CRITICAL = (
    'TMP_OnKey', 'TMP_OnFrame', 'TMP_OnTargetClick', 'TMP_Periodic', 'OnEmojiKey', 'OnEmojiClick',
    'Emoji_ShowMenu', 'EmojiStandalone__Periodic', 'WUI_OnPanelToggle',
    'WUI_OnColumnToggle', 'WUI_OnWindowEscape', 'UNITSTAT_OnModeClick', 'WUI_SetHud',
    'WUI_RefreshDocks', 'WUI_FrameSetValue', 'WUI_FrameSetMinMaxValue',
    'WUI_EnterExclusiveWindow', 'WUI_EnterWheel', 'AHUI_Periodic',
    'WOS_STATS_OnKey', 'LMP_OnClick', 'SaveSystem_HelpTick', 'QB_CheckDrag',
    'QB_ShopKey', 'QB_ShopButton', 'QB_OnRmbTick', 'WOS_PreviewRender', 'WUI_ButtonHover',
    'WCS_SetOpen', 'GuideRefreshAbilityTooltip',
)


def functions(text):
    # Remove comments before extracting; string literals cannot introduce calls.
    text = re.sub(r'/\*.*?\*/', '', text, flags=re.S)
    text = re.sub(r'//[^\n]*', '', text)
    return {m[1]: m[2] for m in re.finditer(
        r'^function (\w+) takes[^\n]*\n(.*?)^endfunction', text, re.S | re.M)}


def calls(body):
    return set(re.findall(r'\b(\w+)\s*\(', re.sub(r'"(?:\\.|[^"\\])*"', '""', body)))


def paths(table, root, terminals):
    todo = [(root, [root])]
    seen = set()
    result = []
    while todo:
        name, chain = todo.pop()
        if name in seen:
            continue
        seen.add(name)
        for callee in sorted(calls(table[name])):
            if callee in terminals:
                result.append(chain + [callee])
            if callee in table:
                todo.append((callee, chain + [callee]))
    return result, seen


def root_names(table, suffix):
    # --scriptonly and map compilation use different private-scope separators.
    normalized = re.sub(r'_+', '_', suffix)
    return [name for name in table if re.sub(r'_+', '_', name) == normalized
            or re.sub(r'_+', '_', name).endswith('_' + normalized)]


def classification(path, table):
    caller, native = path[-2:]
    if native == 'TriggerExecute' and (caller == 'WUI_OnReady' or re.fullmatch(r'WOSUI_+WUI_(Bootstrap|DrainReadyStep)', caller)):
        return 'shared UI startup allocation'
    if native == 'ExecuteFunc' and caller == 'PrepareNormalPick':
        targets = re.findall(r'ExecuteFunc\s*\(\s*"([^"]+)"\s*\)', table[caller])
        if targets == ['CreateUI']:
            return 'shared initial pick allocation'
    if native == 'TriggerEvaluate' and any(n == 'h__SetPlayerAbilityAvailable' for n in path):
        # JassHelper hook in shared LearnHeroSpells/ErzaEPas, not a frame setter.
        if re.fullmatch(r'sc___prototype\d+_evaluate', caller):
            return 'shared gameplay ability hook'
    return None


def local_paths(table, roots):
    """Find allocation/dispatch under explicit local-player branches, transitively."""
    found = []
    for root in roots:
        stack = []
        for line in table[root].splitlines():
            if re.match(r'\s*if\b', line):
                stack.append('GetLocalPlayer' in line or any(stack))
            if any(stack):
                for callee in calls(line):
                    if callee in ALLOCATE | DISPATCH:
                        found.append([root, callee])
                    elif callee in table:
                        nested, _ = paths(table, callee, ALLOCATE | DISPATCH)
                        found.extend([root] + p for p in nested)
            if line.strip() == 'endif' and stack:
                stack.pop()
    return [list(p) for p in sorted(set(tuple(p) for p in found))]


def audit(script, source_root=ROOT):
    table = functions(script.read_text(encoding='utf-8-sig'))
    checked, errors, exceptions, shared_mouse = {}, [], [], []
    optional = ('DS_Click','DS_Poll','DS_OnKey','DS_Tick','WOS_STATS_OnData') if root_names(table,'DS_Tick') else ()
    for suffix in CRITICAL + optional:
        names = root_names(table, suffix)
        if not names:
            errors.append({'missing_root': suffix})
        for name in names:
            bad, reachable = paths(table, name, DISPATCH | ALLOCATE)
            checked[name] = len(reachable)
            for path in bad:
                if (suffix == 'TMP_OnKey' and path[-1] == 'CreateTrigger'
                        and re.fullmatch(r'TeamMapPings_+TMP_TrackMouse', path[-2])):
                    # User-requested demand subscription, before the local branch.
                    shared_mouse.append(path)
                else:
                    errors.append({'runtime_path': path})
    frame_roots = [name for name, body in table.items()
                   if any(re.match(r'Blz(?:Frame|CreateFrame|CreateSimpleFrame|GetFrame|GetOriginFrame)', c)
                          for c in calls(body))]
    for root in frame_roots:
        found, _ = paths(table, root, DISPATCH)
        for path in found:
            reason = classification(path, table)
            if reason:
                exceptions.append({'path': path, 'reason': reason})
            else:
                errors.append({'frame_dispatch_path': path})
    errors.extend({'local_frame_path': p} for p in local_paths(table, sorted(set(frame_roots) | set(checked))))
    settings = json.loads((source_root / 'triggers/trigger-settings.json').read_text(encoding='utf-8-sig'))['triggers']
    owners = []
    for relative in ['Map_Header.j'] + [p for p, enabled in settings.items() if enabled]:
        text = (source_root / 'triggers' / relative).read_text(encoding='utf-8-sig')
        text = re.sub(r'/\*.*?\*/', '', text, flags=re.S)
        text = re.sub(r'//[^\n]*', '', text)
        if re.search(r'\bBlz(?:Frame|CreateFrame|CreateSimpleFrame|GetFrame|GetOriginFrame)\w*\(', text):
            owners.append(relative)
    return dict(compiled_functions=len(table), frame_functions=len(frame_roots),
                frame_sources=owners, critical_roots=checked, exceptions=exceptions,
                agreed_mouse_subscriptions=shared_mouse,
                errors=errors, game_runtime_tested=False)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('script', nargs='?', type=Path, default=ROOT / '_build/ui-redesign/compiled.j')
    parser.add_argument('--report', type=Path, default=ROOT / '_build/ui-redesign/dispatch-audit.json')
    args = parser.parse_args()
    result = audit(args.script)
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf8')
    print(f"UI dispatch audit: {len(result['frame_sources'])} sources; {result['frame_functions']} frame functions; "
          f"{len(result['critical_roots'])} strict roots; {len(result['errors'])} errors")
    for error in result['errors'][:8]:
        print(json.dumps(error, ensure_ascii=False))
    return bool(result['errors'])


if __name__ == '__main__':
    raise SystemExit(main())
