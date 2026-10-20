"""Apply the October 18 hero/UI object corrections through the lossless codec."""
from pathlib import Path
import copy
import json
import re
import shutil

import war3_object_data as raw
import war3_object_workspace as workspace
from integrate_crocodile_main_objects import set_field, code

ROOT = Path(__file__).resolve().parents[1]


from rebase_altersaber_f_objects import apply as rebase_altersaber_f


def apply_packet(documents):
    by_file = {d['source_file']: d for d in documents}

    def find(kind, identity, skin=False):
        suffix = {'abilities': 'w3a', 'buffs': 'w3h', 'items': 'w3t'}[kind]
        doc = by_file[('war3mapSkin.' if skin else 'war3map.') + suffix]
        return next((o for group in ('original_objects', 'custom_objects')
                     for o in doc[group] if workspace.object_id(o) == identity), None)

    def field(kind, identity, key, value, typ='string', level=0):
        # Preserve existing field ownership; new fields belong to the base object.
        choices = [o for o in (find(kind, identity), find(kind, identity, True)) if o]
        owner = next((o for o in reversed(choices) if any(
            m['field']['text'] == key and m.get('level', 0) == level
            for m in o['modifications'])), choices[0])
        set_field(owner, key, value, typ, level)

    # New copied ability: retain all presentation in the actual base definition.
    base, skin = find('abilities', 'A113'), find('abilities', 'A113', True)
    if skin is not None:
        for mod in skin['modifications']:
            set_field(base, mod['field']['text'], copy.deepcopy(mod['data']['value']),
                      mod['type'], mod.get('level', 0), mod.get('data_pointer', 0))
        by_file['war3mapSkin.w3a']['custom_objects'].remove(skin)
    field('abilities', 'A113', 'alev', 1, 'int')
    field('abilities', 'A113', 'alsk', 0, 'int')
    for key in ('ahky', 'arhk'):
        field('abilities', 'A113', key, 'G')
    for key in ('atp1', 'aret'):
        field('abilities', 'A113', key, 'Black Flame', level=1 if key == 'atp1' else 0)

    # Alter Saber F: two Berserk-based toggle buttons (rebased from Channel 2026-10-19).
    rebase_altersaber_f(documents)

    field('abilities', 'A0F7', 'acdn', 8., 'unreal', 1)
    for obj in (find('items', 'I02N'), find('items', 'I02N', True)):
        if obj:
            for mod in obj['modifications']:
                if mod['type'] == 'string':
                    value = workspace.value_for_user(mod)
                    if 'Cooldown: 10 sec.' in value:
                        set_field(obj, mod['field']['text'], value.replace('Cooldown: 10 sec.', 'Cooldown: 8 sec.'),
                                  level=mod.get('level', 0), leveled=False)
    field('abilities', 'A0HE', 'aare', 1400., 'unreal', 1)  # reveal radius; strikes stay 1100
    field('buffs', 'B01P', 'fube', '+20 HP/sec (heroes only)\n+6 MP/sec\n+20% movement speed\nAura radius: 1500')
    field('buffs', 'B01Q', 'fube', 'Receives 30% less active healing.\nDark Holy Grail aura radius: 1500.')
    for level in range(1, 6):
        field('abilities', 'A023', 'aare', 1050., 'unreal', level)
    for obj in (find('abilities', 'A023'), find('abilities', 'A023', True)):
        if obj:
            for mod in obj['modifications']:
                if mod['field']['text'] not in ('aub1', 'arut'):
                    continue
                value = workspace.value_for_user(mod)
                value = re.sub(r'Attack Damage:\|r (?:Agility|Attack) x [\d.]+',
                               'Attack Damage:|r Attack x 0.9', value)
                value = value.replace('Radius:|r 875', 'Radius:|r 1050')
                if mod['field']['text'] == 'arut':
                    value = value.replace('Strikes: 2/3/4/5/6', 'Strikes: 2/3/4/5/5')
                else:
                    count = min(5, 1 + mod.get('level', 1))
                    value = re.sub(r'Strikes: \d+', 'Strikes: ' + str(count), value)
                set_field(obj, mod['field']['text'], value, level=mod.get('level', 0))

    ids = {}
    for path in (ROOT / 'triggers/Heroes').rglob('*.j'):
        ids.update(re.findall(r"\binteger (\w+)\s*=\s*'(....)'", path.read_text(encoding='utf-8-sig')))
    hud = (ROOT / 'triggers/WOS_Start/ShowCD.j').read_text(encoding='utf-8-sig')
    for slot, name in re.findall(r'AHUI_AddHeroAbility\(whichHero, AHUI_SLOT_([FG]), (\w+)\)', hud):
        field('abilities', ids[name], 'abpx', 1 if slot == 'F' else 2, 'int')
        field('abilities', ids[name], 'abpy', 1, 'int')

    for key in ('aart', 'arar'):
        field('abilities', 'A114', key, 'ReplaceableTextures\\CommandButtons\\BTNHero_Kyoraku_E2.blp')
    for level in range(1, 6):
        for obj in (find('abilities', 'A114'), find('abilities', 'A114', True)):
            if obj:
                for mod in obj['modifications']:
                    if mod['field']['text'] in ('aub1', 'arut'):
                        set_field(obj, mod['field']['text'], workspace.value_for_user(mod).replace(
                            '500 range past', '650 range past'), level=mod.get('level', 0))
    for identity, radius in (('A09Z', 225.), ('A0A7', 750.), ('A0AG', 1500.)):
        field('abilities', identity, 'aare', radius, 'unreal', 1)

    field('buffs', 'B041', 'fube', "Poisoned: takes 0.4x the attacker's Agility physical damage every second for 5 sec.")

    # Target-owned dummy casters must be able to cast these Slow variants on allies/self.
    for identity, levels, targets in (
            ('A1OT', 76, 'invulnerable,vulnerable'),
            ('A03U', 5, 'invulnerable,vulnerable'),
            ('A108', 1, 'air,ground,enemy,friend,self,organic,vulnerable,invulnerable')):
        for level in range(1, levels + 1):
            field('abilities', identity, 'atar', targets, level=level)

    # Keep both native buff text and item lore consistent with the runtime values.
    for identity in ('A110', 'B041', 'I04C', 'B03F', 'A10E'):
        kind = 'abilities' if identity[0] == 'A' else 'buffs' if identity[0] == 'B' else 'items'
        for obj in (find(kind, identity), find(kind, identity, True)):
            if obj:
                for mod in obj['modifications']:
                    if mod['type'] == 'string':
                        value = workspace.value_for_user(mod)
                        updated = value.replace('0.5x Agility', '0.4x Agility') if identity in ('A110', 'B041', 'I04C') else value.replace('15%', '18%')
                        if value != updated:
                            set_field(obj, mod['field']['text'], updated, level=mod.get('level', 0))


def main():
    documents, _ = workspace.prepare_documents(ROOT / 'object-data', ROOT / '.object-data-raw')
    apply_packet(documents)
    for document in documents:
        raw.encode_object_file(document, document['source_file'])
        raw.dump_json(ROOT / '.object-data-raw' / raw.OUTPUT_NAMES[document['source_file']], document)
    for kind, (editable, metadata) in workspace.views_from_raw(documents, ROOT / 'libs/common.j').items():
        raw.dump_json(ROOT / 'object-data' / workspace.CATEGORY_FILES[kind], editable)
        raw.dump_json(ROOT / '.object-data-raw/workspace-meta' / workspace.CATEGORY_FILES[kind], metadata)
    config = json.loads((ROOT / '.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
    map_dir = Path(config['mainMap'])
    for folder, name in (('CommandButtons', 'BTNHero_Kyoraku_E2.blp'),
                         ('CommandButtonsDisabled', 'DISBTNHero_Kyoraku_E2.blp')):
        src = map_dir / 'ReplaceableTextures' / folder / name
        dst = ROOT / 'assets/ReplaceableTextures' / folder / name
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)
    dst = ROOT / 'assets/effects/war3mapImported/cf2.mdx'
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(map_dir / 'war3mapImported/wos_cf2.mdx', dst)
    print('Hero packet staged; editable ability levels trimmed; assets copied; map not written')


if __name__ == '__main__':
    main()
