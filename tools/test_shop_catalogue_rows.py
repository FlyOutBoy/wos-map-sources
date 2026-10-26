"""Shop catalogue: row groups survive the price sort; items past slot 35 stay buyable."""
from collections import defaultdict
from pathlib import Path
import re
import unittest

from test_crocodile import JassState
import test_quickbuy_fix6 as fix6

ROOT = Path(__file__).resolve().parents[1]


def functions(path, *names):
    text = (ROOT / 'triggers' / path).read_text(encoding='utf-8-sig')
    return '\n'.join(re.search(r'(?m)^\s*(?:(?:private|public) )?function ' + name + r' takes[^\n]*\n[\s\S]*?^\s*endfunction', text)[0]
                     for name in names)


class RowGroups(unittest.TestCase):
    def sort(self, definition, prices):
        page = defaultdict(int, enumerate(definition))
        vm = JassState(functions('WOS_Start/WoS_Shop_Init.j', 'SortShopPageByPrice'))
        vm.g.update(SHOP_CATEGORY_MAX_ITEMS=210, SHOP_CATALOGUE_COLUMNS=7, ModuloInteger=lambda a, b: a % b,
                    ShopGetPageItem=lambda p, s: page[s], ShopSetPageItem=lambda p, s, i: page.__setitem__(s, i),
                    GetItemValue=lambda i: prices[i],
                    ids=defaultdict(int), groupOf=defaultdict(int))  # the VM has no local arrays
        vm.run('SortShopPageByPrice', (2,))
        return [page[s] for s in range(max(page) + 1)]

    def test_empty_cells_start_a_sorted_group_on_its_own_row(self):
        first = list(range(1, 11))            # ten defensive items
        moved = [21, 22, 23, 24, 25]          # moved items, own row
        prices = {i: 1000 - i for i in first + moved}
        result = self.sort(first + [0, 0, 0, 0] + moved, prices)
        self.assertEqual(sorted(first, key=prices.get), result[:10])
        self.assertEqual([0, 0, 0, 0], result[10:14])
        self.assertEqual(sorted(moved, key=prices.get), result[14:19])

    def test_stray_holes_are_compacted_and_whole_page_sorted(self):
        prices = {1: 30, 2: 10, 3: 20}
        self.assertEqual([2, 3, 1], self.sort([1, 2, 3], prices)[:3])


class SecondPage(unittest.TestCase):
    def test_item_past_the_35_slot_page_is_selected_and_bought(self):
        t = fix6.Fix6('test_mastery_manual_buy_at_round_15_full_inventory'); t.setUp()
        g = t.vm.g
        hero = t.units[0]
        g['ItemsPage1_ID'] = defaultdict(int, {**{i: 1 for i in range(35)}, 35: 6})
        g['ItemsFrameCurrentPage_ID'][0] = 1
        table = {}
        g.update(SHOP_SECTION_STRIDE=8, SHOP_SEARCH_PAGE_SIZE=35, SHOP_CATEGORY_MAX_ITEMS=210,
                 ShopSectionPage=defaultdict(int), ShopSearchActive=defaultdict(bool), SHOP_SEARCH_PAGE=99,
                 BlzGetTriggerFrame=lambda: 77, GetHandleId=lambda o: o['pid'] + 1 if isinstance(o, dict) else o,
                 ShopFrameTable=table, SHOP_PAGE_LAST=7, ShopFastAction=lambda p, c, id: c,
                 IsObserverSlot=lambda _: False, ShopShowItemDescription=lambda *_: None,
                 CraftItemCheck=lambda *_: None, ReloadItemPage2=lambda *_: None, ReloadItemPage=lambda *_: None,
                 ShopUpdateCatalogueNavigation=lambda *_: None)
        for code in (407, 200, 306):  # next page, first cell, buy
            table[(77, 0)] = code
            t.vm.run('OnClickItem')
        self.assertEqual(1, g['ShopSectionPage'][1])
        self.assertEqual(6, g['ItemsCurrentItem_ID'][0])
        self.assertIn(6, hero['inv'])


if __name__ == '__main__':
    unittest.main()
