"""Add E marker buffs/helpers and an invisible TR blocker to a saved-map snapshot.

Existing objects are never modified. This stages files; it does not write a map.
"""
from pathlib import Path
import argparse
import copy

import war3_object_data as raw
from integrate_crocodile_main_objects import code, set_field, clone_object

IDS = dict(resist='B0F0', heal_cut='B0F1', resist_spell='A1F0',
           heal_cut_spell='A1F1', blocker='B0F2')


def add_objects(documents, strings):
    added = []

    def make(file, base, identity, title):
        doc = documents[file]
        for group in ('custom_objects', 'original_objects'):
            for obj in doc[group]:
                if (obj['new_id']['text'] or obj['old_id']['text']) == identity:
                    if obj['old_id']['text'] != base:
                        raise ValueError('Frostnova helper ID collision: '+identity)
                    return None
        obj = dict(old_id=code(base), new_id=code(identity), v3_unknown=[0],
                   modifications=[], display_name=title)
        doc['custom_objects'].append(obj)
        added.append((file, identity))
        return obj

    for identity, base, title, description, icon in [
        (IDS['resist'], 'Binf', 'Frostnova E - Frozen Shelter',
         'All incoming damage reduced by 30% while Frostnova is inside her E field.', 'E'),
        (IDS['heal_cut'], 'Bcri', 'Frostnova E - Frozen Recovery',
         'Health restoration reduced by 35% inside the E field.', 'F')]:
        obj = make('war3map.w3h', base, identity, title)
        if obj is not None:
            for field, value in [('fnam',title),('ftip',title),('fube',description),
                ('fart',fr'ReplaceableTextures\CommandButtons\BTNHero_Frostnova_{icon}.blp'),
                ('ftat',''),('feat','')]:
                set_field(obj, field, value, leveled=False)

    for identity, base, buff, order_data in [
        (IDS['resist_spell'], 'Ainf', IDS['resist'], [('Inf1',1),('Inf2',2),('Inf3',3),('Inf4',4)]),
        (IDS['heal_cut_spell'], 'Acri', IDS['heal_cut'], [('Cri1',1),('Cri2',2),('Cri3',3)])]:
        obj = make('war3map.w3a', base, identity, 'Frostnova E marker - '+buff)
        if obj is not None:
            for field, value, kind, level in [
                ('anam','Frostnova E marker - '+buff,'string',0),('alev',1,'int',0),
                ('aher',0,'int',0),('aite',0,'int',0),('areq','','string',0),
                ('acdn',0.,'unreal',1),('amcs',0,'int',1),('aran',99999.,'unreal',1),
                ('adur',.36,'unreal',1),('ahdu',.36,'unreal',1),('abuf',buff,'string',1),
                ('atar','air,ground,enemy,friend,self,organic,vulnerable,invulnerable','string',1),
                ('acat','','string',0),('atat','','string',0),('asat','','string',0),
                ('aeat','','string',0),('aefl','','string',1)]:
                set_field(obj,field,value,kind,level)
            for field, pointer in order_data:
                set_field(obj,field,0.,'unreal',1,pointer)

    obj = make('war3map.w3b', 'YTct', IDS['blocker'], 'Frostnova TR collision')
    if obj is not None:
        template = next(o for d in documents.values() if d['kind']=='destructables'
            for o in d['custom_objects'] if o['new_id']['text']=='B044')
        replacement=clone_object(template,IDS['blocker'],{},strings)
        obj.update(replacement)
        # Explicit visibility is an effect handle, avoiding destructable variations.
        for field, value, kind in [('bfil','none.mdl','string'),('bnam','Frostnova TR collision','string'),
            ('bptx',r'PathTextures\4x4SimpleSolid.tga','string'),('bvar',1,'int'),
            ('bmis',1.,'real'),('bmas',1.,'real')]:
            set_field(obj,field,value,kind,leveled=False)
    return added


def stage(source, output):
    names=['war3map.w3a','war3map.w3h','war3map.w3b']
    strings=raw.parse_wts(source/'war3map.wts')
    docs={n:raw.parse_object_file((source/n).read_bytes(),n,*raw.FORMAT_BY_EXTENSION[Path(n).suffix],strings)
          for n in names}
    originals=copy.deepcopy(docs)
    added=add_objects(docs,strings)
    output.mkdir(parents=True,exist_ok=True)
    changed=[]
    for name,doc in docs.items():
        if doc!=originals[name]:
            (output/name).write_bytes(raw.encode_object_file(doc,name));changed.append(name)
    return changed,added


if __name__ == '__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source',type=Path)
    parser.add_argument('output',type=Path)
    args=parser.parse_args()
    print(stage(args.source,args.output))
