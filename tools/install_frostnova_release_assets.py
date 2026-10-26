"""Install the explicit reviewed Frostnova packet into a folder map, additively."""
from pathlib import Path
from datetime import datetime
import argparse
import hashlib
import json
import shutil
import struct
import subprocess

ROOT=Path(__file__).resolve().parents[1]


def install(map_dir,packet,backup_root):
    if map_dir.suffix.lower()=='.w3x':
        closed=subprocess.run(['powershell','-NoProfile','-Command',
            "if (Get-Process -Name 'World Editor','WorldEditorTESH' -ErrorAction SilentlyContinue) {exit 1}"],capture_output=True)
        if closed.returncode:raise ValueError('Close World Editor before writing map assets')
    manifest=json.loads((packet/'manifest.json').read_text('utf8'))
    imp=map_dir/'war3map.imp';original=imp.read_bytes()
    version,count=struct.unpack_from('<II',original);offset=8;registered=set()
    for _ in range(count):
        end=original.index(0,offset+1)
        name=original[offset+1:end].decode('utf8')
        if original[offset] in (5,8):name='war3mapImported\\'+name
        registered.add(name.replace('/','\\').casefold());offset=end+1
    if offset!=len(original) or version not in (1,2):raise ValueError('Invalid IMP')
    backup=backup_root/datetime.now().strftime('%Y%m%d-%H%M%S-%f')
    backup.mkdir(parents=True);shutil.copy2(imp,backup/imp.name)
    changed=[];additions=[]
    for item in manifest['imports']:
        name=item['path'];relative=Path(name.replace('\\','/'))
        if relative.is_absolute() or '..' in relative.parts or ':' in name:raise ValueError('Unsafe packet path')
        source=packet/'files'/relative;data=source.read_bytes()
        if hashlib.sha256(data).hexdigest()!=item['sha256']:raise ValueError('Stale manifest: '+name)
        target=map_dir/relative
        if not target.exists() or target.read_bytes()!=data:
            if target.exists():
                saved=backup/relative;saved.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(target,saved)
            target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(source,target);changed.append(name)
        if name.casefold() not in registered:
            additions.append(name);registered.add(name.casefold())
    if additions:
        imp.write_bytes(struct.pack('<II',version,count+len(additions))+original[8:]+
            b''.join(b'\x0d'+name.encode('utf8')+b'\0' for name in additions))
    report=dict(changed=changed,added=additions,backup=str(backup))
    (backup/'report.json').write_text(json.dumps(report,indent=2)+'\n')
    print('Frostnova assets:',len(changed),'changed,',len(additions),'registered; backup',backup)
    return report


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--map',type=Path,required=True)
    parser.add_argument('--packet',type=Path,default=ROOT/'assets/FrostnovaRelease')
    parser.add_argument('--backup',type=Path,default=ROOT/'backups/frostnova-release-assets')
    args=parser.parse_args();install(args.map,args.packet,args.backup)
