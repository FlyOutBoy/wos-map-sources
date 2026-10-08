"""Audit custom native buff tables and stage repairs justified by MAIN code.

Ranks of generic Curse/Inner Fire encode distinct effects, not a numerical
progression. Reserved ranks keep their identities undefined. This tool fills
constant cast fields and uses explicit code contracts for CC durations.
"""
import argparse
import math
import re
from pathlib import Path
import war3_object_data as raw
import war3_object_workspace as workspace
from repair_main_ability_levels import AbilityWorkspace

ROOT = Path(__file__).resolve().parents[1]


def stage(apply=False):
    documents, _ = workspace.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
    for doc in documents:
        if doc['kind']=='buffs':
            for obj in doc['original_objects']+doc['custom_objects']:
                # Buff files have no ranks. Keep one final native field value.
                unique = {}
                for mod in obj['modifications']:
                    mod.pop('level',None)
                    mod.pop('data_pointer',None)
                    unique[mod['field']['hex']] = mod
                obj['modifications'] = list(unique.values())
    abilities = AbilityWorkspace(documents)
    changes = abilities.changes
    # These variant registries have 15 configured effects. MAIN never casts
    # the empty reserved slots; trim the declared range to real definitions.
    abilities.put('A1OB','alev',0,15,kind='int')
    abilities.put('A1P1','alev',0,15,kind='int')

    def put(identity, field, level, value, kind=None):
        sample = next((m for (f,l),m in abilities.fields(identity).items() if f==field), None)
        abilities.put(identity, field, level, value, template=sample, kind=kind)

    # These helpers intentionally use Warcraft's CC buff IDs; make them
    # explicit at every rank, so zero damage is also audited for the root.
    for identity,buff in [('A1OA','BPSE'),('APPP','BEer')]:
        for level in range(1,abilities.get(identity,'alev',0,1)+1):
            if abilities.get(identity,'abuf',level) is None:
                put(identity,'abuf',level,buff,kind='string')

    buff_tables = []
    high_tables = []
    for identity in abilities.objects:
        fields = abilities.fields(identity)
        levels = abilities.get(identity, 'alev', 0, 1)
        if levels > 5:
            high_tables.append(identity)
        if not any(f=='abuf' and l>0 for f,l in fields):
            continue
        buff_tables.append(identity)
        # Only constants with explicit evidence of identical values are filled.
        # Distinct effect identities/durations are never extrapolated.
        for field in {f for f,l in fields if l>0}:
            samples = [m for (f,l),m in fields.items() if f==field and 0<l<=levels]
            values = [m['data'].get('resolved_value',m['data']['value']) for m in samples]
            constant_cast = field in {'amcs','acdn','acas','aran','atar','abuf','adur','ahdu'}
            # Suppress unwanted base damage/armor/attack speed in marker spells.
            zero_effect = (field.startswith(('Inf','Blo','Ndo','Htb','Eer','Fae')) or field=='') and all(v==0 or v=='' for v in values)
            if not samples or not (constant_cast or zero_effect) or any(v!=values[0] for v in values):
                continue
            for level in range(1,levels+1):
                if (field,level) not in fields:
                    put(identity,field,level,values[0])

    # The encoding used by the actual CC wrapper determines native duration.
    for identity, quantum in [('A1OA',.1),('A1QY',.5),('APPP',.25),('A01V',.5)]:
        for level in range(1,abilities.get(identity,'alev',0,1)+1):
            for field in ('adur','ahdu'):
                current = abilities.get(identity,field,level)
                expected = level*quantum
                if current is None or not math.isclose(current,expected,abs_tol=1e-5):
                    put(identity,field,level,expected)

    # Existing restored levels 1/4/5 are the same virus, without rank scaling.
    for field in ('abuf','adur','ahdu'):
        for level in range(1,10):
            if abilities.get('A06G',field,level) is None:
                put('A06G',field,level,abilities.get('A06G',field,1))

    # Patriot offensive W uses five IDs tested by DamageBlock (4..12% bonus).
    for level,buff in enumerate(('B01Y','B021','B022','B023','B024'),6):
        put('A0EG','abuf',level,buff)
        put('A0EG','Inf2',level,0)
    # Ainz W protection is not the progressive F movement speed buff.
    put('A0FW','Blo2',8,0.0)

    buff_objects = {}
    for doc in documents:
        if doc['kind']=='buffs':
            for obj in doc['original_objects']+doc['custom_objects']:
                buff_objects.setdefault(workspace.object_id(obj),[]).append(obj)
    buff_changes = []

    def description(identity, text):
        objects = buff_objects[identity]
        sample = next((m for o in reversed(objects) for m in o['modifications'] if m['field']['text']=='fube'),None)
        if sample and sample['data'].get('resolved_value',sample['data']['value'])==text:
            return
        target = objects[-1]
        from integrate_crocodile_main_objects import set_field
        set_field(target,'fube',text,'string',leveled=False)
        buff_changes.append((identity,text))

    source = (ROOT/'triggers/Heroes/Mahoraga.j').read_text(encoding='utf-8-sig')
    reduction = float(re.search(r'real MahoragaT_DamageReductionPerStack\s*=\s*([\d.]+)',source)[1])
    for level,buff in enumerate(('B01G','B01H','B01I','B01J','B01K','B01L','B01M','B01N'),1):
        description(buff,f'Deals {level*reduction:g}% less damage to Mahoraga while adaptation is active.')
    for rank,buff in enumerate(('B01Y','B021','B022','B023','B024'),1):
        description(buff,f'Normal attacks and physical spells deal {2+rank*2}% more damage. Health regeneration is reduced by {rank*5} HP/sec.')
    description('B01X','Armor +1/2/3/4/5 and health regeneration +5/10/15/20/25 HP/sec, according to Sarkaz Sorcery rank.')
    description('B03D','Marked for 5 sec. Leaves ground sand while moving. All ground sand lasts 20 sec and slows by 10% / 20% / 30% at Crocodile hero levels 1 / 25 / 35.')
    description('B03E','Movement speed +80 while standing on active sand. Removed after leaving the sand.')
    description('B00K','Active healing received is reduced by 40%; mana restored is reduced by 25%.')
    description('B01E','Deals 75% less damage to Alucard and takes 20% more damage from him. Alucard heals for 20% of damage dealt to this target.')
    description('B01F','Deals 30% less damage to Alucard and takes 10% more damage from him. Alucard heals for 10% of damage dealt to this target.')
    description('B002','Marked by Kansho and Bakuya.')
    description('B003','Marked by Kazekage Hat.')

    # Dummy spell tooltips must describe their configured effect rather than
    # inherit the base spell's damage/armor lore at restored high ranks.
    def buff_fields(identity):
        return {m['field']['text']:m['data'].get('resolved_value',m['data']['value'])
                for o in buff_objects.get(identity,[]) for m in o['modifications']}

    for identity in high_tables:
        for level in range(1,abilities.get(identity,'alev',0,1)+1):
            buff = (abilities.get(identity,'abuf',level,'') or '').split(',')[0]
            data = buff_fields(buff)
            title = data.get('ftip') or identity
            text = data.get('fube','')
            seconds = abilities.get(identity,'adur',level)
            if identity=='A1OA':
                title,text = 'Stun', 'Stuns the target. No damage.'
            elif identity=='APPP':
                title,text = 'Root', 'Roots the target. No periodic damage.'
            elif identity=='A1QY':
                title,text = 'Doom', 'Applies Doom. No periodic damage or summoned units.'
            elif identity=='A01V':
                title,text = 'Silence', 'Prevents spellcasting. No movement slow or chance to miss.'
            elif identity=='A1OT':
                title = 'Slow'
                percent = abilities.get(identity,'Slo1',level)*100
                text = f'Movement speed and attack speed reduced by {percent:g}%.'
            elif identity=='A00D':
                title = 'Speed Increase'
                percent = abilities.get(identity,'Blo2',level)*100
                text = f'Movement speed increased by {percent:.0f}%. No attack speed bonus.'
            elif identity=='A01C':
                title = 'Movement Speed'
                text = f"Movement speed +{abilities.get(identity,'Imvb',level)}."
            elif identity=='A0EG' and level<=5:
                text = f'Armor +{level}; health regeneration +{level*5} HP/sec.'
            if seconds is not None:
                text += f' Duration: {seconds:g} sec.'
            put(identity,'atp1',level,title,kind='string')
            put(identity,'aub1',level,text,kind='string')

    audit = []
    for identity in buff_tables:
        levels = abilities.get(identity,'alev',0,1)
        ranks = [{'rank':l,'buff':abilities.get(identity,'abuf',l),
                  'normal_duration':abilities.get(identity,'adur',l),
                  'hero_duration':abilities.get(identity,'ahdu',l)} for l in range(1,levels+1)]
        audit.append({'ability':identity,'levels':levels,'ranks':ranks,
                      'reserved_ranks':[r['rank'] for r in ranks if r['buff'] is None]})
    # Audit every custom buff, including cosmetic and direct passive buffs.
    buff_inventory = []
    all_source = '\n'.join(p.read_text(encoding='utf-8-sig') for p in (ROOT/'triggers').rglob('*.j'))
    for identity,objects in buff_objects.items():
        fields = {m['field']['text']:m['data'].get('resolved_value',m['data']['value']) for o in objects for m in o['modifications']}
        buff_inventory.append({'buff':identity,'title':fields.get('ftip',''),
            'description':fields.get('fube',''), 'referenced_by_code':"'"+identity+"'" in all_source,
            'ability_ranks':[(a['ability'],r['rank']) for a in audit for r in a['ranks'] if identity in (r['buff'] or '').split(',')]})
    report = {'custom_buff_count':len(buff_objects),'buff_ability_count':len(buff_tables),
              'abilities_over_five_levels':high_tables,'ability_changes':changes,
              'buff_description_changes':buff_changes,'tables':audit,'buffs':buff_inventory}
    raw.dump_json(ROOT/'_build/custom-buff-level-audit.json',report)
    if apply:
        for doc in documents:
            if doc['kind'] in ('abilities','buffs'):
                raw.encode_object_file(doc,doc['source_file'])
                raw.dump_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[doc['source_file']],doc)
        for kind,(editable,metadata) in workspace.views_from_raw(documents,ROOT/'libs/common.j').items():
            if kind in ('abilities','buffs'):
                raw.dump_json(ROOT/'object-data'/workspace.CATEGORY_FILES[kind],editable)
                raw.dump_json(ROOT/'.object-data-raw/workspace-meta'/workspace.CATEGORY_FILES[kind],metadata)
    print(f"{'Staged' if apply else 'Dry-run'}: {len(changes)} ability fields; {len(buff_changes)} buff descriptions; audited {len(buff_objects)} buffs, {len(high_tables)} tables above rank 5.")
    return abilities,report


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apply',action='store_true')
    stage(parser.parse_args().apply)
