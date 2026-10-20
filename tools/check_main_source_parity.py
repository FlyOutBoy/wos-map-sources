"""Reject stale WCT imports and builds whose compiled gameplay differs from sources."""
from pathlib import Path
import argparse
import json
import os
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
TOKENS = re.compile(r'''"(?:\\.|[^"\\])*"|'[^'\n]*'|//[^\n]*|/\*.*?\*/|[A-Za-z_]\w*|\d+(?:\.\d*)?|[^\s]''', re.S)


def identifier(value):
    value = re.sub(r'jasshelper_+initstructs\d+', 'jasshelper_initstructs', value)
    return re.sub(r'_+', '_', value)


def tokens(text):
    result = []
    for match in TOKENS.finditer(text):
        value = match[0]
        if value.startswith(('//', '/*')):
            continue
        if value.startswith('"'):
            # JassHelper also refers to private generated callbacks by string.
            inner = value[1:-1]
            if '__' in inner and re.fullmatch(r'[A-Za-z_]\w*', inner):
                value = '"' + identifier(inner) + '"'
        elif re.fullmatch(r'[A-Za-z_]\w*', value):
            value = identifier(value)
        result.append(value)
    return tuple(result)


def snapshot(text):
    # Remove whole multiline comments while preserving strings and line starts.
    pattern = re.compile(r'''"(?:\\.|[^"\\])*"|'[^'\n]*'|//[^\n]*|/\*.*?\*/''', re.S)
    clean = pattern.sub(lambda m: '\n' * m[0].count('\n') if m[0].startswith(('//','/*')) else m[0], text)
    functions = {identifier(m[1]): tokens(m[0]) for m in re.finditer(
        r'^[ \t]*function (\w+) takes[^\n]*\n.*?^[ \t]*endfunction\b', clean, re.S | re.M)}
    globals_text = clean.split('endglobals', 1)[0].split('globals', 1)[-1]
    globals_ = {}
    for line in globals_text.splitlines():
        match = re.match(r'^\s*(?:constant\s+)?\w+\s+(?:array\s+)?(\w+)(?:\s*=.*)?\s*$', line)
        if match:
            globals_[identifier(match[1])] = tokens(line)
    return functions, globals_


def compare(reference, candidate):
    old_f, old_g = snapshot(reference)
    new_f, new_g = snapshot(candidate)
    if not old_f or not new_f:
        raise ValueError('A compiled script contains no JASS functions')
    return {
        'functions_reference': len(old_f), 'functions_candidate': len(new_f),
        'missing_functions': sorted(old_f.keys() - new_f.keys()),
        'extra_functions': sorted(new_f.keys() - old_f.keys()),
        'changed_functions': sorted(k for k in old_f.keys() & new_f.keys() if old_f[k] != new_f[k]),
        'missing_globals': sorted(old_g.keys() - new_g.keys()),
        'extra_globals': sorted(new_g.keys() - old_g.keys()),
        'changed_globals': sorted(k for k in old_g.keys() & new_g.keys() if old_g[k] != new_g[k]),
    }


def check_synced():
    import sync_war3_triggers as sync
    _, _, _, differences, added, moves, _ = sync.prepare(ROOT / 'object-data.config.json', ROOT / 'triggers')
    if differences or added or moves:
        raise ValueError(f'MAIN WCT is not synced: {differences} changed sources, {added} new sources. Run the normal check/save first.')
    print('MAIN WCT/source identity: PASS')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--candidate-source', type=Path)
    parser.add_argument('--reference-script', type=Path)
    parser.add_argument('--work-directory', type=Path, default=ROOT / '_build/main-source-parity')
    parser.add_argument('--require-synced', action='store_true')
    args = parser.parse_args()
    try:
        if args.require_synced:
            check_synced()
        if args.candidate_source is None and args.reference_script is None:
            if not args.require_synced:
                parser.error('provide --require-synced or both script arguments')
            return 0
        if args.candidate_source is None or args.reference_script is None:
            parser.error('both --candidate-source and --reference-script are required')
        work = args.work_directory.resolve(); work.mkdir(parents=True, exist_ok=True)
        config = json.loads((ROOT / '.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
        compiler = Path(config['jassHelper'])
        if not compiler.is_absolute(): compiler = ROOT / compiler
        output = work / 'recompiled.j'
        command = [str(compiler), '--scriptonly', str(ROOT / 'libs/common.j'), str(ROOT / 'libs/Blizzard.j'),
                   str(args.candidate_source.resolve()), str(output)]
        run = subprocess.run(command, cwd=compiler.parent, timeout=60,
                             creationflags=subprocess.CREATE_NO_WINDOW if os.name == 'nt' else 0,
                             capture_output=True)
        if run.returncode:
            log = compiler.parent / 'logs/compileerrors.txt'
            raise ValueError('Incoming-source compile failed: ' + (log.read_text(errors='replace')[-1400:] if log.exists() else str(run.returncode)))
        report = compare(args.reference_script.read_text(encoding='utf-8-sig'), output.read_text(encoding='utf-8-sig'))
        (work / 'parity-report.json').write_text(json.dumps(report, indent=2) + '\n', encoding='utf8')
        mismatches = {k: v for k, v in report.items() if isinstance(v, list) and v}
        if mismatches:
            print(json.dumps({k: v[:12] for k, v in mismatches.items()}, indent=2))
            raise ValueError('Compiled code differs from incoming sources. WCT may be stale; import/publication stopped before replacing working sources.')
        print(f'MAIN compiled/source parity: PASS ({report["functions_candidate"]} functions)')
        return 0
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print('ERROR:', error)
        return 1


if __name__ == '__main__':
    raise SystemExit(main())
