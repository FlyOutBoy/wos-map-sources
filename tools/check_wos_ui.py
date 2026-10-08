"""Bounded compilation of the production source tree using bundled JassHelper."""
from pathlib import Path
import json,subprocess

ROOT = Path(__file__).resolve().parents[1]

def check():
    build = ROOT/'_build/ui-redesign'
    build.mkdir(parents=True,exist_ok=True)
    settings = json.loads((ROOT/'triggers/trigger-settings.json').read_text(encoding='utf-8-sig'))['triggers']
    files = [ROOT/'triggers/Map_Header.j']+[ROOT/'triggers'/path for path,enabled in settings.items() if enabled]
    source = build/'compile-input.j'
    # Existing generated native gg_* declarations are needed by map triggers.
    files.insert(0,ROOT/'.vscode/build/wos_map_globals.j')
    source.write_text('\n'.join(f'//! import "{path}"' for path in files)+
                      '\nfunction config takes nothing returns nothing\nendfunction\nfunction main takes nothing returns nothing\nendfunction\n',encoding='utf-8')
    config = json.loads((ROOT/'.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
    executable = Path(config['jassHelper'])
    if not executable.is_absolute():
        executable = ROOT/executable
    result = subprocess.run([str(executable),'--scriptonly',str(ROOT/'libs/common.j'),str(ROOT/'libs/Blizzard.j'),str(source),str(build/'compiled.j')],
                            cwd=executable.parent,timeout=30,creationflags=subprocess.CREATE_NO_WINDOW)
    log = executable.parent/'logs'/('pjass.txt' if result.returncode==0 else 'compileerrors.txt')
    if log.exists():
        print(log.read_text(errors='replace')[-1800:])
    print('UI compile:',result.returncode,'enabled production sources:',len(files)-1)
    raise SystemExit(result.returncode)

if __name__ == '__main__':
    check()
