"""Stage MAIN level repairs and bake learn tooltips from actual vJASS definitions.

Dry-run by default. --apply updates the lossless JSON workspace; the normal
check/save and MAIN build still write the map. No TEST objects are modified.
Uses the existing small JASS evaluator to execute formatting helpers and the
TooltipBuilder method bodies, rather than duplicating the tooltip formulas.
"""
import argparse
import copy
import json
import math
import re
from pathlib import Path
from types import SimpleNamespace

import war3_object_data as raw
import war3_object_workspace as workspace
from test_crocodile import JassState

ROOT = Path(__file__).resolve().parents[1]


def expression(value):
    # Translate keywords outside quoted strings only.
    return ''.join(part if i % 2 else re.sub(r'\b(true|false|null)\b',
        lambda m: {'true':'True','false':'False','null':'None'}[m[0]],part)
        for i,part in enumerate(re.split(r'("(?:\\.|[^"\\])*"|\'[^\']*\')',value)))


class SpellFactory:
    def __init__(self):
        self.records = []

    def create(self, identity, levels, damage, stat, base, step, static, static_step, mechanics, bonus):
        data = SimpleNamespace(identity=identity, levels=levels, damage=damage,
            stat=stat, base=base, step=step, static=static, static_step=static_step,
            mechanics=mechanics, bonus=bonus, form=0, decor='', after=False,
            second=None, mults=(0,0))
        def change(name,value):
            setattr(data,name,value)
            return data
        data.setDecor = lambda v: change('decor',v)
        data.setCdAfterDuration = lambda v: change('after',v)
        data.setSecondDamage = lambda *v: change('second',v)
        data.setBonusMults = lambda *v: change('mults',v)
        data.setPreviewChannel = lambda: change('preview_channel',True)
        data.setPreviewDirected = lambda: change('preview_directed',True)
        data.setCooldownFrom = lambda v: change('cooldown_from',v)
        self.records.append(data)
        return data

    def createSimple(self, identity, levels, damage, stat, base, step, mechanics, bonus):
        return self.create(identity,levels,damage,stat,base,step,0,0,mechanics,bonus)

    def createUtility(self, identity, levels, mechanics, bonus):
        return self.create(identity,levels,0,0,0,0,0,0,mechanics,bonus)

    def createAlt(self, identity, form, *args):
        data = self.create(identity,*args)
        data.form = form
        return data

    def createUtilityAlt(self, identity, form, levels, mechanics, bonus):
        return self.createAlt(identity,form,levels,0,0,0,0,0,0,mechanics,bonus)


def tooltip_vm():
    source = (ROOT/'triggers/WOS_Start/UniversalTooltips.j').read_text(encoding='utf-8-sig')
    builder = (ROOT/'triggers/WOS_Start/TooltipBuilder.j').read_text(encoding='utf-8-sig')
    functions = '\n'.join(re.findall(r'(?m)^\s*(?:(?:public|private) )?function \w+ takes.*?endfunction',source,re.S))
    vm = JassState(builder+'\n'+functions)
    vm.g.update(I2R=float, R2SW=lambda v,w,p: f'{v:.{p}f}',
        StringLength=len, SubString=lambda s,a,b:s[a:b], StringHash=lambda s:s,
        HT_DESC={}, HaveSavedString=lambda h,k,c:(k,c) in h,
        LoadStr=lambda h,k,c:h.get((k,c)), SaveStr=lambda h,k,c,v:h.update({(k,c):v}))
    pending = []
    for path in sorted((ROOT/'triggers').rglob('*.j')):
        text = re.sub(r'/\*.*?\*/','',path.read_text(encoding='utf-8-sig'),flags=re.S)
        for block in re.findall(r'\bglobals\s*(.*?)\bendglobals',text,re.S):
            pending.extend(re.findall(r'(?m)^\s*(?:(?:private|public)\s+)?(?:constant\s+)?(?:integer|real|boolean|string)\s+(\w+)\s*=\s*(.*)',block))
    for _ in range(12):
        unresolved = []
        for name,value in pending:
            value = re.split(r'//(?=(?:[^"\\]|\\.)*$)',value)[0].strip()
            try:
                vm.g[name] = eval(expression(value),{'__builtins__':{}},vm.g)
            except (NameError,TypeError,SyntaxError,AttributeError):
                unresolved.append((name,value))
        if len(unresolved)==len(pending):
            break
        pending = unresolved
    factory = SpellFactory()
    env = dict(vm.g,SpellData=factory)
    failures = []
    for line_no,line in enumerate(source.splitlines(),1):
        line = line.strip()
        if line.startswith('call SpellData.create'):
            try:
                eval(expression(line[5:]),{'__builtins__':{}},env)
            except Exception as exc:
                failures.append((line_no,str(exc)))
    if failures:
        raise ValueError(f'Cannot render actual SpellData definitions: {failures}')
    return vm,factory.records


class AbilityWorkspace:
    def __init__(self, documents):
        self.documents = documents
        self.objects = {}
        self.changes = []
        for doc in documents:
            if doc['kind']=='abilities':
                for obj in doc['original_objects']+doc['custom_objects']:
                    self.objects.setdefault(workspace.object_id(obj),[]).append(obj)

    def fields(self, identity):
        return {(m['field']['text'],m.get('level',0)):m
                for obj in self.objects[identity] for m in obj['modifications']}

    def get(self,identity,field,level=0,default=None):
        mod = self.fields(identity).get((field,level))
        return mod['data'].get('resolved_value',mod['data'].get('value')) if mod else default

    def put(self,identity,field,level,value,template=None,kind=None,pointer=0):
        current = self.fields(identity).get((field,level))
        if current and self.get(identity,field,level)==value:
            return
        obj = self.objects[identity][0]
        mod = copy.deepcopy(current or template) if current or template else {
            'field':raw.rawcode_to_json(field.encode('ascii')), 'field_name':'',
            'type':kind or 'string', 'sanity_check':copy.deepcopy(obj['new_id'])}
        mod.update(level=level,data_pointer=mod.get('data_pointer',pointer))
        mod['data'] = {'value':value}
        for other in self.objects[identity]:
            other['modifications'] = [m for m in other['modifications']
                if (m['field']['text'],m.get('level',0))!=(field,level)]
        obj['modifications'].append(mod)
        self.changes.append((identity,field,level,value))

    def repair_levels(self, records):
        """Restore holes at every declared rank, preserving explicit balance.

        A constant or affine sequence must explain *all* existing ranks. Buff
        variant registries have code-backed exceptions, never extrapolated IDs.
        The raw Crs\0 field has an empty display name; its template keeps its ID.
        """
        self.unresolved = []
        for identity in self.objects:
            levels = self.get(identity,'alev',0,1)
            fields = self.fields(identity)
            base = self.objects[identity][0]['old_id'].get('text')
            if base=='ANcl' or any(f.startswith('Ncl') for f,l in fields):
                for level in range(1,levels+1):
                    self.put(identity,'Ncl5',level,0,kind='int',pointer=5)
            if levels < 2:
                continue
            for field in sorted({f for f,l in fields if 0<l<=levels}):
                available = {l:m for (f,l),m in fields.items() if f==field and 0<l<=levels}
                ranks = sorted(available)
                numbers = [self.get(identity,field,l) for l in ranks]
                for level in range(1,levels+1):
                    if level in available:
                        continue
                    sample = available[min(ranks,key=lambda l:abs(l-level))]
                    value = None
                    cc_steps = {'A1OA':0.1,'A1QY':0.5,'APPP':0.25,'A01V':0.5}
                    if identity in cc_steps and field in {'adur','ahdu'}:
                        value = level*cc_steps[identity]
                    elif identity=='A1OT' and field in {'adur','ahdu','Slo1','Slo2'}:
                        value = (level-1)%4+1 if field in {'adur','ahdu'} else ((level-1)//4+1)*0.05
                    elif identity=='A0EG' and field=='Inf2' and level>=6:
                        value = 0  # Offensive W: no defensive native armor.
                    elif identity=='A0FW' and field=='Blo2' and level==8:
                        value = 0.0  # W protection, not an F movement rank.
                    elif all(v==numbers[0] for v in numbers):
                        value = numbers[0]
                    elif field in {'atp1','aut1'} and all(isinstance(v,str) for v in numbers):
                        normalized = [re.sub(r'(?i)(level\s+)\d+',r'\1{rank}',v) for v in numbers]
                        if len(set(normalized))==1:
                            value = normalized[0].replace('{rank}',str(level))
                    elif len(ranks)>=2 and all(isinstance(v,(int,float)) for v in numbers) and field not in {'Ncl2','Ncl3','Ncl5'}:
                        step = (numbers[-1]-numbers[0])/(ranks[-1]-ranks[0])
                        if all(math.isclose(v,numbers[0]+step*(l-ranks[0]),abs_tol=1e-5) for l,v in zip(ranks,numbers)):
                            value = numbers[0]+step*(level-ranks[0])
                            if sample['type']=='int':
                                value = round(value) if math.isclose(value,round(value),abs_tol=1e-5) else None
                            if field in {'acdn','amcs','aran','aare','adur','ahdu'} and value is not None and value<0:
                                value = None
                    if value is None:
                        self.unresolved.append((identity,field,level))
                        continue
                    self.put(identity,field,level,value,template=sample)
        # Standard native CC buff IDs were omitted completely in the baseline.
        for identity,buff in [('A1OA','BPSE'),('APPP','BEer')]:
            for level in range(1,self.get(identity,'alev',0,1)+1):
                if self.get(identity,'abuf',level) is None:
                    self.put(identity,'abuf',level,buff,kind='string')


def render_tooltip(vm, data, desc, fields, level=0):
    builder = SimpleNamespace(buffer='',hasStats=False)
    builder.checkFirstStat = lambda:vm.run('checkFirstStat',obj=builder)
    def add(method,*args):
        vm.run(method,args,obj=builder)
    add('addDescription',vm.run('NormalizeDesc',(desc,)))
    bonus = data.bonus.replace('<V1>','0').replace('<V2>','0')
    add('addBonus',vm.run('ParseLevelTags',(bonus,level)))
    def formula(stat,base,step,static,static_step):
        return vm.run('FormulaStr' if level else 'FormulaList',
            (stat,base,step,static,static_step,level or data.levels))
    if data.base or data.step or data.static or data.static_step:
        add('addDamage',data.damage,formula(data.stat,data.base,data.step,data.static,data.static_step))
    if data.second:
        damage,name,stat,base,step,static,static_step = data.second
        add('addCustomDamage',damage,name,formula(stat,base,step,static,static_step))
    def listing(field):
        values = [fields.get(data.identity,field,l,0) for l in ([level] if level else range(1,data.levels+1))]
        return '/'.join(vm.run('FormatReal',(v,)) for v in (values[:1] if len(set(values))==1 else values))
    add('addRange',listing('aran'))
    add('addMechanic',vm.run('ParseLevelTags',(data.mechanics,level)))
    add('addCooldownEx',listing('acdn'),data.after)
    if data.decor:
        add('addDecorDamage',vm.run('ParseLevelTags',(data.decor,level)))
    add('addMana',listing('amcs'))
    return builder.buffer


def stage(apply=False, levels_only=False):
    documents,_ = workspace.prepare_documents(ROOT/'object-data',ROOT/'.object-data-raw')
    vm,records = (None,[]) if levels_only else tooltip_vm()
    fields = AbilityWorkspace(documents)
    before = {(identity,field,level):fields.get(identity,field,level)
        for identity in fields.objects for field,level in fields.fields(identity)}
    fields.repair_levels(records)
    if levels_only:
        report = {'changes':fields.changes,'unresolved':fields.unresolved,
                  'abilities':len(fields.objects),
                  'multilevel_abilities':sum(fields.get(i,'alev',0,1)>1 for i in fields.objects)}
        raw.dump_json(ROOT/'_build/all-ability-levels-report.json',report)
        if fields.unresolved:
            raise ValueError(f'Non-linear holes require explicit rules: {fields.unresolved}')
        if apply:
            write_abilities(documents)
        print(f"{'Staged' if apply else 'Dry-run'}: {len(fields.changes)} fields; {report['multilevel_abilities']} multilevel abilities; no tooltip rebake.")
        return fields,{},vm
    # Native Channel and the scripted T duration must agree after map edits.
    fields.put(vm.g['CrocodileT_ID'],'Ncl1',1,vm.g['CrocodileT_Duration'],kind='unreal',pointer=1)
    # E reads its recharge from Object Data; never replace acdn with the
    # shorter interval between uses.
    crocodile_lore = {
        'Q': 'Crocodile sends a sand slash through enemies, dealing physical damage, slowing them and applying a sand mark. Creates sand along its path; marked enemies leave sand as they move. Combines with Desert Girasole.',
        'W': 'Crocodile creates quicksand that pulls enemies toward its centre and deals six physical damage pulses over 3 seconds. Combines with Q for an explosion and stun, and with R for an enlarged sandstorm. Leaves ground sand.',
        'E': 'Crocodile dashes forward while invulnerable. On contact, deals five physical damage pulses that split its total damage, then continues the dash. Each charge recharges independently at the ability cooldown. Leaves ground sand.',
        'R': 'Crocodile creates a moving sandstorm that lifts and carries enemies, dealing six physical damage pulses. Can combine with quicksand. Leaves ground sand.',
    }
    for slot,lore in crocodile_lore.items():
        identity = vm.g[f'Crocodile{slot}_ID']
        for level in range(1,6):
            fields.put(identity,'aub1',level,lore)
    registry = {}
    for record in records:
        if record.identity not in fields.objects:
            raise ValueError(f'SpellData references missing MAIN ability {record.identity}')
        if record.form==0:
            registry[record.identity] = record
        elif record.identity not in registry:
            registry[record.identity] = record
    baked = []
    for identity,data in registry.items():
        data = copy.copy(data)
        data.levels = min(data.levels,fields.get(identity,'alev',0,1))
        desc = fields.get(identity,'aub1',1,'') or fields.get(identity,'arut',0,'')
        desc = vm.run('LoreOnly',(vm.run('NormalizeDesc',(desc,)),))
        text = render_tooltip(vm,data,desc,fields)
        fields.put(identity,'arut',0,text)
        for level in range(1,data.levels+1):
            stats = render_tooltip(vm,data,'',fields,level)
            fields.put(identity,'aub1',level,desc+'|n|n|cffffcc00Ability Stats:|r|n'+stats)
        baked.append(identity)
    final_changes = {}
    for identity,field,level,value in fields.changes:
        final_changes[(identity,field,level)] = value
    fields.changes = [(identity,field,level,value)
        for (identity,field,level),value in final_changes.items()
        if before.get((identity,field,level)) != value]
    report = {'rendered_learn_abilities':baked, 'changes':fields.changes,
              'registered_definitions':len(records)}
    raw.dump_json(ROOT/'_build/main-ability-levels-report.json',report)
    if apply:
        write_abilities(documents)
    print(f"{'Staged' if apply else 'Dry-run'}: {len(fields.changes)} fields; {len(baked)} learn tooltips; {len(records)} code definitions.")
    return fields,registry,vm


def write_abilities(documents):
    for document in documents:
        if document['kind']=='abilities':
            raw.encode_object_file(document,document['source_file'])
            raw.dump_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[document['source_file']],document)
    editable,metadata = workspace.views_from_raw(documents,ROOT/'libs/common.j')['abilities']
    raw.dump_json(ROOT/'object-data/abilities.json',editable)
    raw.dump_json(ROOT/'.object-data-raw/workspace-meta/abilities.json',metadata)


if __name__=='__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apply',action='store_true')
    parser.add_argument('--levels-only',action='store_true',help='Only restore level fields; preserve current tooltip text and formulas')
    args = parser.parse_args()
    stage(args.apply,args.levels_only)
