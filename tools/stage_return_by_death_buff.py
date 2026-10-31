"""Stage Return by Death's dispellable positive buff without restaging other items."""
from pathlib import Path
import json
import re

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import allocate, clone_object, set_field

ROOT = Path(__file__).resolve().parents[1]
IDS_PATH = ROOT / 'object-data/return-by-death-ids.json'
TIP = ('+15 allstats\nActive: Applies a dispellable buff and remembers your position. After 4 sec, '
       'returns you there only if the buff is still active. Removing the buff (including with Kairoseki '
       'Cuffs) cancels the return.\nCooldown: 25 sec.')
BUFF_TIP = ('Returns to the marked position after 4 sec. Removing this positive buff cancels the return.')
ICON = 'ReplaceableTextures\\CommandButtons\\BTNItem_ReturnByDeath.blp'


def configure(documents, ids, strings):
    by_file = {d['source_file']: d for d in documents}
    pairs = {'abilities': ('war3map.w3a', 'war3mapSkin.w3a'),
             'buffs': ('war3map.w3h', 'war3mapSkin.w3h'),
             'items': ('war3map.w3t', 'war3mapSkin.w3t')}

    def index(name):
        return {objects.object_id(o): o for o in by_file[name]['custom_objects']}

    for kind, label, template in [('abilities', 'buffAbility', 'A13D'), ('buffs', 'buff', 'B05D')]:
        for name in pairs[kind]:
            existing = index(name)
            if ids[label] not in existing and template in existing:
                by_file[name]['custom_objects'].append(clone_object(existing[template], ids[label], {}, strings))

    def field(kind, identity, key, value, type='string', level=0, pointer=0, skin=False):
        target = index(pairs[kind][1 if skin else 0]).get(identity)
        if target is None and skin:
            target = index(pairs[kind][0])[identity]
        found = [m for m in target['modifications'] if m['field']['text'] == key
                 and m.get('level', 0) == level and m.get('data_pointer', 0) == pointer]
        if found and objects.value_for_user(found[-1]) == value:
            return
        set_field(target, key, value, type, level, pointer, leveled=kind == 'abilities')

    ability, buff = ids['buffAbility'], ids['buff']
    for key, value, kind, pointer in [('abuf', buff, 'string', 0),
                                      # Script owns the four-second deadline; grace avoids native expiry racing it.
                                      ('adur', 4.5, 'unreal', 0), ('ahdu', 4.5, 'unreal', 0),
                                      ('Inf1', 0., 'unreal', 1), ('Inf2', 0, 'int', 2),
                                      ('Inf3', 0., 'unreal', 3)]:
        field('abilities', ability, key, value, kind, 1, pointer)
    for key, value in dict(anam='Return by Death (buff)', aart=ICON).items():
        field('abilities', ability, key, value, skin=True)
    for key, value in dict(ftip='Return by Death', fube=BUFF_TIP, fart=ICON, ftat='').items():
        field('buffs', buff, key, value, skin=True)
    for key in ('ides', 'utub'):
        field('items', 'I059', key, TIP, skin=True)
    for key, value in dict(aart=ICON, arar=ICON, aret='Return by Death', arut=TIP,
                           atp1='Return by Death', aub1=TIP).items():
        field('abilities', 'A13E', key, value, level=1 if key in ('atp1', 'aub1') else 0, skin=True)


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
    for label, prefix in [('buffAbility', 'A'), ('buff', 'B')]:
        if label not in ids:
            ids[label] = allocate(prefix, used)
    # Reserve IDs before writing documents so a transient Windows file lock is safely retryable.
    raw.dump_json(IDS_PATH, ids)
    config = json.loads((ROOT/'.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
    configure(documents, ids, raw.parse_wts(Path(config['mainMap'])/'war3map.wts'))
    for document in documents:
        raw.encode_object_file(document, document['source_file'])
        raw.dump_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[document['source_file']], document)
    for kind, (editable, metadata) in objects.views_from_raw(documents, ROOT/'libs/common.j').items():
        raw.dump_json(ROOT/'object-data'/objects.CATEGORY_FILES[kind], editable)
        raw.dump_json(ROOT/'.object-data-raw/workspace-meta'/objects.CATEGORY_FILES[kind], metadata)
    raw.dump_json(IDS_PATH, ids)
    print(json.dumps(ids))


if __name__ == '__main__':
    stage()
