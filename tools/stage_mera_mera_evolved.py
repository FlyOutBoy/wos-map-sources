"""Stage Mera Mera no Mi (+25 static) and Mera Mera no Mi Evolved via the lossless object workspace API."""
from pathlib import Path
import json
import re

import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import allocate, clone_object, set_field

ROOT = Path(__file__).resolve().parents[1]
IDS_PATH = ROOT / 'object-data/mera-mera-evolved-ids.json'
BASE_TIP = ("+10 str\n+10 allstats\nPassive: Deals 65 + 1.15% of the owner's max HP (up to 250) as magic damage "
            "every second to enemies within 850 range.")
TIP = ("+15 str\n+15 allstats\nPassive: Deals 65 + 1.4% of the owner's max HP (up to 250) as magic damage "
       "every second to enemies within 850 range.\nActive: Grants a fire shield that absorbs damage equal to 10% "
       "of max HP for 5 sec.\nCooldown: 20 sec.")
ICON = 'ReplaceableTextures\\CommandButtons\\BTNItem_MeraMeraEvolved.blp'
NAME = 'Mera Mera no Mi Evolved'


def configure(documents, ids, strings):
    by_file = {d['source_file']: d for d in documents}
    pairs = {'items': ('war3map.w3t', 'war3mapSkin.w3t'),
             'abilities': ('war3map.w3a', 'war3mapSkin.w3a')}

    def index(name):
        return {objects.object_id(o): o for o in by_file[name]['custom_objects']}

    # item: clone of Mera Mera; active: clone of Blood Pact Ring Evolved active (Absk, instant).
    for kind, label, template in [('items', 'item', 'I02G'), ('abilities', 'active', 'A154')]:
        for name in pairs[kind]:
            existing = index(name)
            if ids[label] not in existing and template in existing:
                by_file[name]['custom_objects'].append(clone_object(existing[template], ids[label], {}, strings))

    def field(kind, identity, name, value, type='string', level=0, pointer=0, skin=False):
        target = index(pairs[kind][1 if skin else 0]).get(identity)
        if target is None and skin:
            target = index(pairs[kind][0])[identity]
        found = [m for m in target['modifications'] if m['field']['text'] == name
                 and m.get('level', 0) == level and m.get('data_pointer', 0) == pointer]
        if found and objects.value_for_user(found[-1]) == value:
            return
        set_field(target, name, value, type, level, pointer)

    item, active = ids['item'], ids['active']
    for key in ('utub', 'ides'):
        field('items', 'I02G', key, BASE_TIP, skin=True)
    # A06T = Item STR +15, A07Y = Item ALST +15
    for key, value, kind in [('iabi', active + ',A06T,A07Y', 'string'), ('igol', 10000, 'int'),
                             ('icid', active, 'string'), ('iusa', 1, 'int')]:
        field('items', item, key, value, kind)
    for key, value in dict(unam=NAME, utip=NAME, utub=TIP, ides=TIP, iico=ICON).items():
        field('items', item, key, value, skin=True)
    for key, value, kind in [('acdn', 20., 'unreal'), ('amcs', 0, 'int'), ('aran', 0., 'unreal')]:
        field('abilities', active, key, value, kind, level=1)
    for key, value in dict(anam='Item Mera Mera no Mi Evolved', aart=ICON, arar=ICON,
                           aret=NAME, arut=TIP, atp1=NAME, aub1=TIP).items():
        field('abilities', active, key, value, level=1 if key in ('atp1', 'aub1') else 0, skin=True)


def stage():
    documents, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
    used = {objects.object_id(o) for d in documents for group in ('custom_objects', 'original_objects') for o in d[group]}
    for root in ('triggers', 'test_map'):
        for path in (ROOT/root).rglob('*'):
            if path.suffix in ('.j', '.json'):
                text = path.read_text(encoding='utf-8-sig', errors='replace')
                used.update(re.findall(r"'([ABI][A-Z0-9]{3})'", text))
                used.update(re.findall(r'"([ABI][A-Z0-9]{3})"\s*:', text))
    ids = json.loads(IDS_PATH.read_text()) if IDS_PATH.exists() else {}
    for label, prefix in [('item', 'I'), ('active', 'A')]:
        if label not in ids:
            ids[label] = allocate(prefix, used)
            used.add(ids[label])
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
