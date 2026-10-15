"""Inventory hero distance sources and local range modifiers, without map writes."""
from pathlib import Path
import argparse,hashlib,json,re

ROOT=Path(__file__).resolve().parents[1]


def audit():
    rules=(ROOT/'test_map/ability_range/HeroRangeRules.j').read_text(encoding='utf-8-sig')
    heroes=[];mutations=[];native=[]
    files=sorted((ROOT/'triggers/Heroes').rglob('*.j'))
    for p in files:
        lines=p.read_text(encoding='utf-8-sig').splitlines();definitions=[]
        for i,line in enumerate(lines):
            m=re.match(r'\s*(?:constant )?(?:real|integer) (\w*(?:Range|Distance)\w*)\s*=',line)
            if m:
                name=m[1]
                refs=[j+1 for j,s in enumerate(lines) if not s.lstrip().startswith('//') and re.search(r'\b'+re.escape(name)+r'\b',s.split('//')[0])]
                if re.search(r'\b'+re.escape(name)+r'\b',rules):reason='shared preview formula'
                elif len(refs)<=1:reason='unused parameter; native targeting retained'
                elif any(s in name for s in ('Push','Pull','Attack','Search','Behind','Orb','Consume','MinDistance','Tight','HitRange')):reason='secondary movement/attack/search; not cast range'
                else:reason='native targeting retained; fixed or secondary effect travel'
                definitions.append({'name':name,'line':i+1,'declaration':line.strip(),'references':refs,'presentation':reason})
            if 'ABILITY_RLF_CAST_RANGE' in line:
                native.append({'source':str(p.relative_to(ROOT)),'line':i+1,'code':line.strip()})
            m=re.match(r'\s*set (\w+)\s*=.*\b\w*(?:Range|Distance)\w*',line)
            if not m or any(s in line for s in ('Push','Pull','MinDistance','MaxDistance','Search','AttackRange')):continue
            for j in range(i+1,min(i+70,len(lines))):
                if re.search(r'endmethod|endfunction',lines[j]):break
                if re.match(r'\s*set '+m[1]+r'\s*=\s*'+m[1]+r'\s*[-+*/]',lines[j]):
                    mutations.append({'source':str(p.relative_to(ROOT)),'initial_line':i+1,'initial':line.strip(),'modifier_line':j+1,'modifier':lines[j].strip()})
        if definitions:heroes.append({'source':str(p.relative_to(ROOT)),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'ranges':definitions})
    objects=json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
    tooltip=(ROOT/'triggers/WOS_Start/UniversalTooltips.j').read_text(encoding='utf-8-sig')
    hud=(ROOT/'triggers/WOS_Start/ShowCD.j').read_text(encoding='utf-8-sig')
    buttons=sorted(set(re.findall(r'AHUI_AddHeroAbility\(whichHero, AHUI_SLOT_\w+, (\w+)\)',hud)))
    ids={};declarations={}
    for p in files:
        for number,line in enumerate(p.read_text(encoding='utf-8-sig').splitlines(),1):
            m=re.match(r"\s*(?:constant )?integer (\w+_ID)\s*=\s*'([^']+)'",line)
            if m:ids[m[1]]=m[2];declarations[m[1]]={'source':str(p.relative_to(ROOT)),'line':number}
    registered={}
    for number,line in enumerate(tooltip.splitlines(),1):
        m=re.search(r'call SpellData\.create\w*\((\w+_ID),',line)
        if m:registered.setdefault(m[1],[]).append({'line':number,'builder':line.strip()})
    aliases={}
    alias_body=re.search(r'function ARules_GetPreviewSource.*?endfunction',rules,re.S)
    if alias_body:
        for cond,target in re.findall(r'(?:if|elseif) (.*?) then\s+return (\w+)',alias_body[0],re.S):
            for name in re.findall(r'abilId == (\w+)',cond):aliases[name]=target
    rows=[]
    for name in buttons:
        source=aliases.get(name,name);obj=objects.get(ids.get(name,''),{})
        formula=re.search(r'(?m)^    (?:if|elseif) abilId == '+re.escape(name)+r' then\n([\s\S]*?)(?=^    elseif abilId ==|^    endif)',rules)
        metadata={k:v for k,v in obj.items() if k=='base_id' or k=='levels' or k.startswith(('cast_range level ','target_type level '))}
        regs=registered.get(source,[])
        if formula:kind='hero J distance formula'
        elif regs and any('T_Rad' in e['builder'] or 'Radius:' in e['builder'] for e in regs):kind='builder area / directed native range'
        elif source in registered:kind='native targeting or no-area utility/passive'
        else:kind='no-area passive/cancel control'
        rows.append({'ability':name,'rawcode':ids.get(name),'declaration':declarations.get(name),
            'preview_source':source,'classification':kind,'object_targeting':metadata,
            'formula':formula[1].strip() if formula else None,'builder_registrations':regs})
    missing=[r['ability'] for r in rows if not r['rawcode'] or not r['object_targeting']]
    return {'hero_files_scanned':len(files),'hero_files_with_range_constants':len(heroes),
        'range_definitions':sum(len(h['ranges']) for h in heroes),'shared_ability_rules':len(re.findall(r'abilId ==',rules)),
        'native_cast_field_setters':native,'local_distance_modifiers':mutations,'heroes':heroes,
        'hud_buttons_audited':len(rows),'buttons_without_object_metadata':missing,'button_audit':rows,
        'scope':'Source audit; secondary push/pull/attack/search and unused parameters must not become cast radii. No engine verification.'}


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--output',type=Path,required=True)
    result=audit();parser.parse_args().output.write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
    print(json.dumps({k:v for k,v in result.items() if k not in ('heroes','scope','button_audit')},ensure_ascii=False,indent=2))
