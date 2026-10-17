"""Read actual item rules and execute MAIN's shared item/ability ring lifecycle."""
from collections import defaultdict
from pathlib import Path
import json
import re
import unittest

from test_crocodile import JassState
import test_ability_range_preview as prior

ROOT = Path(__file__).resolve().parents[1]


def rules_vm():
    source = (ROOT / 'triggers/Items/Items.j').read_text(encoding='utf-8-sig')
    functions = re.findall(r'(?m)^\s*public function (?:GetPreviewAbility|GetItemPreviewRadius) takes[^\n]*\n[\s\S]*?^\s*endfunction', source)
    vm = JassState('\n'.join(functions))
    for name, value in re.findall(r'^\s+(?:integer|real) (\w+) = ([0-9.]+)\b', ''.join(re.findall(r'globals(.*?)endglobals', source, re.S)), re.M):
        vm.g[name] = float(value)
    vm.g.update(ABILITY_RLF_CAST_RANGE='cast', ABILITY_RLF_AREA_OF_EFFECT='area',
                BlzGetAbilityRealLevelField=lambda a, field, level: a[field])
    return vm


class Rules(unittest.TestCase):
    def setUp(self):
        self.vm = rules_vm()

    def radius(self, iid, ability=None):
        return self.vm.run('GetItemPreviewRadius', (iid, ability))

    def test_grail_uses_live_aura_field_not_cast_range(self):
        self.assertEqual(1200, self.radius('I021'))
        self.assertEqual(1500, self.radius('I02B'))
        self.assertEqual(1500, self.radius('I01K'))
        self.assertEqual(1350, self.radius('I021', {'area': 1350, 'cast': 900}))
        self.assertEqual('A09X', self.vm.run('GetPreviewAbility', ('I021',)))

    def test_projectiles_use_j_travel_globals_instead_of_dummy_cast_distance(self):
        for iid, expected in [('I014', 1100), ('I01S', 1820), ('I01V', 1800), ('I042', 2100)]:
            self.assertEqual(expected, self.radius(iid, {'cast': 9999, 'area': 400}))
        self.vm.g['RockleeWeights_Range'] = 1234
        self.assertEqual(1234, self.radius('I014'))

    def test_blink_passive_ranges_and_real_native_casts(self):
        for iid, expected in [('I00E', 750), ('I00O', 900), ('I02G', 850), ('I02H', 1000), ('I02P', 650)]:
            self.assertEqual(expected, self.radius(iid))
        self.assertEqual(1100, self.radius('I01N'))
        self.assertEqual(1180, self.radius('I01N', {'cast': 1180, 'area': 0}))

    def test_passive_cd_carriers_stats_and_self_buffs_never_get_fake_circles(self):
        for iid in ('I000', 'I00H', 'I00L', 'I00M', 'I043', 'I00V', 'I00Y', 'I00Z', 'I01Q', 'I020', 'I02E', 'I041'):
            self.assertEqual(0, self.radius(iid, {'cast': 900, 'area': 600}), iid)
            self.assertEqual(0, self.vm.run('GetPreviewAbility', (iid,)), iid)

    def test_audit_covers_all_items_and_matches_every_item_ability_and_native_fallback(self):
        items = json.loads((ROOT / 'object-data/items.json').read_text(encoding='utf-8-sig'))
        abilities = json.loads((ROOT / 'object-data/abilities.json').read_text(encoding='utf-8-sig'))
        audit = json.loads((ROOT / 'assets/AbilityRange/item-rules.json').read_text(encoding='utf-8'))
        self.assertEqual(set(items), {r['item'] for r in audit})
        self.assertEqual(150, len(audit))
        for row in audit:
            ids = items[row['item']].get('abilities', '').split(',')
            self.assertEqual([a['id'] for a in row['abilities']], [a for a in ids if a])
            if row['mode'] in ('cast', 'aura'):
                self.assertIn(row['ability'], ids)
                self.assertEqual(abilities[row['ability']].get(row['field'], 0), row['fallback'])
                self.assertEqual(row['fallback'], self.radius(row['item']))
        self.assertEqual(27, sum(r['mode'] != 'none' for r in audit))


class Runtime(prior.RangeRuntime):
    """Also rerun every existing lifecycle test on MAIN, rather than the old TEST template."""
    def setUp(self):
        super().setUp()
        old = self.vm
        self.source = (ROOT / 'triggers/WOS_Start/AbilityRangePreview.j').read_text(encoding='utf-8-sig')
        self.vm = JassState(self.source)
        self.vm.g.update({k: v for k, v in old.g.items() if k not in old.methods})
        self.inventory = defaultdict(lambda: None)
        self.item_types = {'grail': 'I021', 'dark': 'I02B', 'stats': 'I000', 'sakura': 'I03W'}
        self.lookups = []
        rules = rules_vm()
        self.vm.g.update(AR_ItemOwner=defaultdict(lambda: None), AR_CachedItem=defaultdict(lambda: None),
                         AR_ItemAbility=defaultdict(lambda: None), AR_RequestedItemSlot=defaultdict(lambda: -1),
                         UnitItemInSlot=lambda u, s: self.inventory[u, s], GetItemTypeId=lambda i: self.item_types[i],
                         ItemsSpells_GetPreviewAbility=lambda iid: rules.run('GetPreviewAbility', (iid,)),
                         ItemsSpells_GetItemPreviewRadius=lambda iid, a: rules.run('GetItemPreviewRadius', (iid, a)),
                         BlzGetItemAbility=lambda i, a: self.lookups.append((i, a)) or None)
        self.runj('AR_Reconcile')

    def item(self, name='grail', slot=0):
        self.inventory['a', slot] = name
        self.runj('AR_Reconcile')
        self.runj('AR_RequestItem', 0, 'a', slot)
        self.runj('AR_Render', 0)

    def test_item_reuses_existing_ring_and_switches_back_to_ability(self):
        self.item()
        self.assertAlmostEqual(1200 / 512, self.vm.g['AR_Scale'])
        self.assertEqual(2, self.number)
        self.show()
        self.assertEqual(1, self.vm.g['AR_Scale'])
        self.assertEqual(-1, self.vm.g['AR_RequestedItemSlot'][0])
        self.assertEqual(2, self.number)

    def test_ability_handles_only_on_changed_slots_in_shared_reconcile_not_hover(self):
        self.item()
        self.assertEqual([('grail', 'A09X')], self.lookups)
        for _ in range(20):
            self.runj('AR_Reconcile')
            self.runj('AR_RequestItem', 0, 'a', 0)
            self.runj('AR_Render', 0)
        self.assertEqual(1, len(self.lookups))
        self.assertEqual(1, sum(c[0] == 'alpha' and c[-1] == 255 for c in self.calls))
        cache = self.vm.methods['AR_CacheItems']
        self.assertNotIn('GetLocalPlayer', cache)
        render = self.vm.methods['AR_Render']
        self.assertNotIn('BlzGetItemAbility', render)

    def test_empty_drop_move_stats_and_over_limit_hide_immediately(self):
        self.item()
        self.inventory['a', 0] = None
        self.runj('AR_Render', 0)  # Inventory changed since the shared cache pass.
        self.assertEqual(-1, self.vm.g['AR_Visible'])
        self.item('grail', 1)
        self.assertGreaterEqual(self.vm.g['AR_Visible'], 0)
        self.item('stats', 1)
        self.assertEqual(-1, self.vm.g['AR_Visible'])
        self.item('sakura', 1)
        self.assertEqual(-1, self.vm.g['AR_Visible'])

    def test_item_is_owner_only_and_cancels_for_cover_death_and_hover_leave(self):
        self.item()
        self.runj('AR_Hide', 0)
        self.assertEqual(-1, self.vm.g['AR_RequestedItemSlot'][0])
        self.item()
        self.blocked = True
        self.runj('AR_Render', 0)
        self.assertEqual(-1, self.vm.g['AR_Visible'])
        self.blocked = False
        self.item()
        self.dead.add('a')
        self.runj('AR_Render', 0)
        self.assertEqual(-1, self.vm.g['AR_Visible'])


class Hover(unittest.TestCase):
    def test_inventory_hit_clears_old_tooltip_grace_and_requests_actual_slot(self):
        f = prior.HoverIntegration()
        f.setUp()
        items = []
        f.vm.g.update(WUI_ItemX=lambda s: .676 + (s % 3 - 1) * .0345,
                      WUI_ItemY=lambda s: .0625 - (s // 3) * .035,
                      WUI_RangeNativeItemVisible=lambda s: True,
                      AR_RequestItem=lambda *a: items.append(a))
        for slot in range(6):
            f.x = f.vm.g['WUI_ItemX'](slot)
            f.y = f.vm.g['WUI_ItemY'](slot)
            f.vm.g['AHUI_PingHoverGrace'][0] = 10
            f.hover()
            self.assertEqual((0, 'hero', slot), items[-1])
            self.assertEqual(0, f.vm.g['AHUI_PingHoverGrace'][0])
        f.x = .4
        f.y = .04
        f.hover()
        self.assertEqual((0, 'hero', 100), f.requests[-1])

    def test_item_hover_does_not_hide_and_reshow_same_ring_each_tick(self):
        f = prior.HoverIntegration()
        f.setUp()
        f.x, f.y = .65, .06
        hidden = []
        def hide(pid):
            f.visible = False
            hidden.append(pid)
        f.vm.g.update(WUI_ItemX=lambda s: .65 + .04 * s, WUI_ItemY=lambda s: .06,
                      WUI_RangeNativeItemVisible=lambda s: True, AR_RequestItem=lambda *a: None,
                      AHUI_HideTooltip=hide)
        for _ in range(20):
            f.hover()
        self.assertEqual([0], hidden)


if __name__ == '__main__':
    unittest.main()
