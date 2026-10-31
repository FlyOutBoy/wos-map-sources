"""Stage Inori's non-learnable aura rank 6 and exact percentage resistance markers."""
from pathlib import Path
import copy
import json
import re
import time

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import allocate, clone_object, set_field

ROOT = Path(__file__).resolve().parents[1]
IDS_PATH = ROOT/'object-data/inori-aura-ids.json'
RADIUS = 1400.
E_TIP = ('Aura (1400 radius): Grants allied units 1/2/3/4/5% physical resistance and 5% magic resistance. '
         'At hero level 25 with Apocalypse Virus (T1) selected, the aura automatically becomes rank 6: '
         '10% physical and 10% magic resistance. Rank 6 cannot be learned. Selecting Mana Ascension (T2) '
         'restores rank 5; the allied aura is disabled and hidden during T2.\n'
         'When allied heroes in the aura take at least 250 damage, Inori gains Instability. '
         'At 4 stacks, Void Absorption becomes available.')
E2_TIP = ('While Mana Ascension (T2) is active, enemies within 1400 radius lose 10% physical resistance '
          'and 10% magic resistance. The allied E aura and Instability passive are disabled.\n'
          'Every 0.5 sec, an Apocalypse beam strikes a random point within 2500 range around Inori, '
          'dealing Intelligence x 2.5 magic damage.')


def configure(documents, ids, strings):
    by_file = {d['source_file']: d for d in documents}
    pairs = {'abilities': ('war3map.w3a', 'war3mapSkin.w3a'),
             'buffs': ('war3map.w3h', 'war3mapSkin.w3h')}

    def index(name):
        return {objects.object_id(o): o for o in by_file[name]['custom_objects']}

    for label in ('rank1', 'rank2', 'rank3', 'rank4', 'rank6'):
        for name in pairs['buffs']:
            existing = index(name)
            if ids[label] not in existing and 'B00I' in existing:
                by_file[name]['custom_objects'].append(clone_object(existing['B00I'], ids[label], {}, strings))

    def field(kind, identity, key, value, type='string', level=0, pointer=0, skin=False):
        target = index(pairs[kind][1 if skin else 0]).get(identity)
        if target is None and skin:
            target = index(pairs[kind][0])[identity]
        found = [m for m in target['modifications'] if m['field']['text'] == key
                 and m.get('level', 0) == level and m.get('data_pointer', 0) == pointer]
        if found and objects.value_for_user(found[-1]) == value:
            return
        set_field(target, key, value, type, level, pointer, leveled=kind == 'abilities')

    # Complete rank 6 from rank 5, including native delivery duration and targets.
    for name in pairs['abilities']:
        aura = index(name)['A061']
        for mod in list(aura['modifications']):
            if mod.get('level') == 5 and not any(m['field'] == mod['field'] and m.get('level') == 6
                                                for m in aura['modifications']):
                extra = copy.deepcopy(mod)
                extra['level'] = 6
                aura['modifications'].append(extra)
    field('abilities', 'A061', 'alev', 6, 'int')
    field('abilities', 'A061', 'aher', 0, 'int')
    for level in range(1, 7):
        buff = 'B00I' if level == 5 else ids['rank'+str(level)]
        phys, magic = (10, 10) if level == 6 else (level, 5)
        # DamageBlock owns percentage resistance; no native armor rating may also be added.
        for key, value, type, pointer in [('Had1', 0., 'unreal', 1), ('aare', RADIUS, 'unreal', 0),
                                           ('abuf', buff, 'string', 0)]:
            field('abilities', 'A061', key, value, type, level, pointer)
        tip = f'Allies within 1400 radius gain {phys}% physical resistance and {magic}% magic resistance.'
        field('abilities', 'A061', 'atp1', 'Void Aura' + (' (T1)' if level == 6 else ''), level=level, skin=True)
        field('abilities', 'A061', 'aub1', tip, level=level, skin=True)
        field('buffs', buff, 'ftip', 'Void Aura' + (' (T1)' if level == 6 else ''), skin=True)
        field('buffs', buff, 'fube', tip, skin=True)
    for level in range(1, 6):
        field('abilities', 'A09S', 'aub1', E_TIP, level=level, skin=True)
    field('abilities', 'A09S', 'arut', E_TIP, skin=True)
    field('abilities', 'A153', 'aare', RADIUS, 'unreal', 1)
    field('abilities', 'A153', 'Had1', 0., 'unreal', 1, 1)
    field('abilities', 'A153', 'atp1', 'Mana Ascension Aura', level=1, skin=True)
    field('abilities', 'A153', 'aub1', E2_TIP, level=1, skin=True)
    field('abilities', 'A153', 'arut', E2_TIP, skin=True)
    field('buffs', 'B062', 'fube', 'Nearby Inori in T2: -10% physical resistance and -10% magic resistance.', skin=True)
    field('abilities', 'A06D', 'aub1', E2_TIP, level=1, skin=True)
    field('abilities', 'A06D', 'arut', E2_TIP, skin=True)


def save_json(path, value):
    # Antivirus may briefly hold a recently replaced workspace document on Windows.
    for attempt in range(5):
        try:
            return raw.dump_json(path, value)
        except PermissionError:
            if attempt == 4:
                raise
            time.sleep(.2*(attempt+1))


def stage():
    documents, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
    used = {objects.object_id(o) for d in documents for group in ('custom_objects', 'original_objects') for o in d[group]}
    for name in ('triggers', 'test_map'):
        for path in (ROOT/name).rglob('*'):
            if path.suffix in ('.j', '.json'):
                text = path.read_text(encoding='utf-8-sig', errors='replace')
                used.update(re.findall(r"'([ABI][A-Z0-9]{3})'", text))
                used.update(re.findall(r'"([ABI][A-Z0-9]{3})"\s*:', text))
    ids = json.loads(IDS_PATH.read_text()) if IDS_PATH.exists() else {}
    for label in ('rank1', 'rank2', 'rank3', 'rank4', 'rank6'):
        if label not in ids:
            ids[label] = allocate('B', used)
    save_json(IDS_PATH, ids)
    config = json.loads((ROOT/'.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
    configure(documents, ids, raw.parse_wts(Path(config['mainMap'])/'war3map.wts'))
    for document in documents:
        raw.encode_object_file(document, document['source_file'])
        save_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[document['source_file']], document)
    for kind, (editable, metadata) in objects.views_from_raw(documents, ROOT/'libs/common.j').items():
        save_json(ROOT/'object-data'/objects.CATEGORY_FILES[kind], editable)
        save_json(ROOT/'.object-data-raw/workspace-meta'/objects.CATEGORY_FILES[kind], metadata)
    print(json.dumps(ids))


if __name__ == '__main__':
    stage()
