"""One-time audited migration of normal FRAME creation parents (not SIMPLEFRAME)."""
from pathlib import Path
import re,shutil,json
from datetime import datetime

ROOT = Path(__file__).resolve().parents[1]
OLD = ['BlzGetFrameByName("ConsoleUIBackdrop", 0)', 'BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)']

def migrate():
    backup = ROOT/'backups/ui-redesign'/datetime.now().strftime('%Y%m%d-%H%M%S')/'root-migration'
    changed = []
    for path in sorted((ROOT/'triggers').rglob('*.j')):
        if path.name == 'WOSUI.j':
            continue
        text = path.read_text(encoding='utf-8-sig')
        lines = text.splitlines(keepends=True)
        touched = False
        for index,line in enumerate(lines):
            # Preserve native/simple hierarchy. Named EscMenu and normal frame types
            # are normal FRAME roots. References in comments stay documentary only.
            if 'BlzCreateFrame' in line and not re.search(r'"SIMPLE\w*"',line) and not line.lstrip().startswith('//'):
                for old in OLD:
                    if old in line:
                        line = line.replace(old,'WUI_GetRoot()')
                        touched = True
                lines[index] = line
        specific = {
            'Scoreboard.j': [('local framehandle gameUI = BlzGetFrameByName("ConsoleUIBackdrop", 0)','local framehandle gameUI = WUI_GetRoot()')],
            'ShowCD.j': [('local framehandle console = BlzGetFrameByName("ConsoleUIBackdrop", 0)','local framehandle console = WUI_GetRoot()')],
            'TeamMapPings.j': [('local framehandle ui = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)','local framehandle ui = WUI_GetRoot()')],
        }
        result = ''.join(lines)
        for old,new in specific.get(path.name,[]):
            if old in result:
                result = result.replace(old,new)
                touched = True
        if not touched:
            continue
        header = re.search(r'^library .*$',result,re.M)
        if header and 'WOSUI' not in header[0]:
            addition = ', WOSUI' if re.search(r'\b(requires|uses|needs)\b',header[0]) else ' requires WOSUI'
            result = result[:header.start()]+header[0]+addition+result[header.end():]
        dest = backup/path.relative_to(ROOT)
        dest.parent.mkdir(parents=True,exist_ok=True)
        shutil.copy2(path,dest)
        path.write_text(result,encoding='utf-8',newline='\r\n')
        changed.append(path.relative_to(ROOT).as_posix())
    backup.mkdir(parents=True,exist_ok=True)
    (backup/'files.json').write_text(json.dumps(changed,indent=2),encoding='utf-8')
    print(f'Migrated normal frame creation parents in {len(changed)} sources; backup: {backup}')

if __name__ == '__main__':
    migrate()
