"""Drop duplicate A1F2/B0F3 (Frostnova T shield) and give the kept marker a 4-second buff.

stage_frostnova_release_objects.py appended both objects on every run. The second A1F2 had no
duration, so Frost Armor's default applied and the T shield never expired; the kept B0F3 also lost
its shield art. Also makes F's dummy slow (A11C) free on every rank: ranks 2-10 fell back to
Slow's default mana/cooldown/attack-speed slow. Stages project files only; check/save follows.
"""
from pathlib import Path
import war3_object_data as raw
import war3_object_workspace as objects
from integrate_crocodile_main_objects import set_field

ROOT = Path(__file__).resolve().parents[1]
SHIELD = 'A1F2'
SHIELD_BUFF = 'B0F3'
SHIELD_ART = r'war3mapImported\wos_Frostnova_title_shielded.mdl'
DURATION = 4.0


def stage():
    documents, _ = objects.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
    for document in documents:
        seen = {}
        kept = []
        for obj in document['custom_objects']:
            oid = objects.object_id(obj)
            if oid in seen:
                if oid not in (SHIELD, SHIELD_BUFF):
                    raise SystemExit('unexpected duplicate %s in %s' % (oid, document['source_file']))
                print('removed duplicate %s from %s (%d fields)' % (oid, document['source_file'], len(obj['modifications'])))
                continue
            seen[oid] = obj
            kept.append(obj)
        document['custom_objects'] = kept
        if document['source_file'] == 'war3map.w3a':
            shield = seen[SHIELD]
            set_field(shield, 'adur', DURATION, 'unreal', 1, 0)
            set_field(shield, 'ahdu', DURATION, 'unreal', 1, 0)
            # The Frost Armor caster dummy must not shield itself (second visible "Shielded").
            set_field(shield, 'atar', 'invulnerable,vulnerable,notself', 'string', 1, 0)
            slow = seen['A11C']
            for rank in range(2, 11):
                set_field(slow, 'amcs', 0, 'int', rank, 0)
                set_field(slow, 'acdn', 0.0, 'unreal', rank, 0)
                set_field(slow, 'Slo2', 0.0, 'unreal', rank, 2)
        if document['source_file'] == 'war3mapSkin.w3h':
            set_field(seen[SHIELD_BUFF], 'ftat', SHIELD_ART, leveled=False)
            set_field(seen[SHIELD_BUFF], 'ftac', 'origin', leveled=False)
    for d in documents:
        if d['kind'] in ('abilities', 'buffs'):
            raw.encode_object_file(d, d['source_file'])
            raw.dump_json(ROOT/'.object-data-raw'/raw.OUTPUT_NAMES[d['source_file']], d)
    views = objects.views_from_raw(documents, ROOT/'libs/common.j')
    for kind in ('abilities', 'buffs'):
        editable, metadata = views[kind]
        raw.dump_json(ROOT/'object-data'/(kind + '.json'), editable)
        raw.dump_json(ROOT/'.object-data-raw/workspace-meta'/(kind + '.json'), metadata)
    print('A1F2: one object, buff duration %.0f sec' % DURATION)


if __name__ == '__main__':
    stage()
