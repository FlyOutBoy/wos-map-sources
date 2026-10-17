"""Check scripted damage coverage and regenerate/check the small item icon catalogue.

No map writes. Source IDs stay numeric on damage paths; object strings are UI-only.
"""
from pathlib import Path
import argparse
import json
import re

ROOT = Path(__file__).resolve().parents[1]
LEAF = re.compile(r'\bcall\s+(dmgmag2?|dmgphys|dmgatk|spelldmg|DmgPTime2?|NextDmg|UnitDamageTarget(?:BJ)?)\s*\(')


def sources():
    settings=json.loads((ROOT/'triggers/trigger-settings.json').read_text(encoding='utf-8-sig'))['triggers']
    return {name:(ROOT/'triggers'/name).read_text(encoding='utf-8-sig')
            for name,enabled in settings.items() if enabled}


def item_catalogue(texts):
    used=set()
    for text in texts.values():
        used.update(re.findall(r"DamageSource\(\s*'(I...)'",text))
    used.update(['I00W','I03Y'])  # ErzaPassive levels 9/10 capture their item directly.
    items=json.loads((ROOT/'object-data/items.json').read_text(encoding='utf-8-sig'))
    lines=[]
    for raw in sorted(used):
        icon=items[raw]['icon'].replace('\\','\\\\').replace('"','\\"')
        lines.extend([f"    if sourceId == '{raw}' then",f'        return "{icon}"','    endif'])
    return '\n'.join(lines)+'\n'


def ability_catalogue(texts):
    used=set()
    for text in texts.values():
        used.update(re.findall(r"DamageSource\(\s*'(A...)'",text))
    abilities=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
    lines=[]
    for raw in sorted(used):
        icon=abilities[raw]['icon'].replace('\\','\\\\').replace('"','\\"')
        lines.append(f'    call SaveStr(DS_Keys,\'{raw}\',2,"{icon}")')
    return '\n'.join(lines)+'\n'


def audit():
    texts=sources();hits=[];errors=[]
    for name,text in texts.items():
        text=re.sub(r'/\*.*?\*/','',text,flags=re.S)
        scope='';lines=text.splitlines()
        for index,line in enumerate(lines):
            code=line.split('//',1)[0]
            definition=re.match(r'\s*(?:(?:private|public|static)\s+)*(?:method|function)\s+(\w+)',code)
            if definition:scope=definition[1]
            hit=LEAF.search(code)
            if not hit:continue
            caller=hit[1]
            inherited=name=='Heroes/Crocodile.j' and scope=='Crocodile_SpellDamage'
            native=name=='Systems/Systems2.j' and scope in ['dmgmag','dmgmag2','dmgphys','dmgatk','spelldmg'] and caller.startswith('UnitDamageTarget')
            tagged='call DamageSource(' in '\n'.join(lines[max(0,index-9):index])
            if not (inherited or native or tagged):errors.append(f'{name}:{index+1}: untagged {scope}: {code.strip()}')
            hits.append({'file':name,'line':index+1,'scope':scope,'call':caller,
                         'route':'native wrapper' if native else 'inherited helper' if inherited else 'explicit source'})
    core=texts.get('WOS_Start/DamageStats.j','')
    if core:
        current=core.split('    // DS_ITEM_ICONS_BEGIN\n',1)[1].split('    // DS_ITEM_ICONS_END',1)[0]
        if current!=item_catalogue(texts):errors.append('Item icon catalogue differs from object-data; run --write-icons')
        current=core.split('    // DS_ABILITY_ICONS_BEGIN\n',1)[1].split('    // DS_ABILITY_ICONS_END',1)[0]
        if current!=ability_catalogue(texts):errors.append('Ability icon catalogue differs from object-data; run --write-icons')
    return {'calls':len(hits),'files':len(set(x['file'] for x in hits)),'hits':hits,'errors':errors}


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--write-icons',action='store_true')
    parser.add_argument('--report',type=Path,default=ROOT/'_build/damage-source-audit.json')
    args=parser.parse_args()
    if args.write_icons:
        path=ROOT/'triggers/WOS_Start/DamageStats.j';raw=path.read_bytes()
        bom=raw.startswith(b'\xef\xbb\xbf');nl='\r\n' if b'\r\n' in raw else '\n'
        text=raw.decode('utf-8-sig').replace('\r\n','\n')
        text=re.sub(r'(?<=    // DS_ITEM_ICONS_BEGIN\n).*?(?=    // DS_ITEM_ICONS_END)',
                    lambda _:item_catalogue(sources()),text,flags=re.S)
        text=re.sub(r'(?<=    // DS_ABILITY_ICONS_BEGIN\n).*?(?=    // DS_ABILITY_ICONS_END)',
                    lambda _:ability_catalogue(sources()),text,flags=re.S)
        path.write_bytes((b'\xef\xbb\xbf' if bom else b'')+text.replace('\n',nl).encode('utf-8'))
    report=audit();args.report.parent.mkdir(parents=True,exist_ok=True)
    args.report.write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print(f"Damage source audit: {report['calls']} calls / {report['files']} files / {len(report['errors'])} errors")
    for error in report['errors']:print(error)
    raise SystemExit(bool(report['errors']))


if __name__=='__main__':main()
