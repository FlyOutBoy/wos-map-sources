"""Regression checks for actual mode/shop/native/placeholder screenshot defects."""
from pathlib import Path
import re
import unittest
from test_wos_ui import load_source
import test_wos_ui as ui_fixture
import test_wos_ui_runtime_fixes as layout_fixture

ROOT = Path(__file__).resolve().parents[1]


class NativeChassis(unittest.TestCase):
    def test_opaque_surface_is_native_and_normal_ornaments_do_not_cover_commands(self):
        fixture = ui_fixture.DeferredUIStartup()
        fixture.setUp()
        fixture.vm.run('WUI_Bootstrap')
        created = [args for name, args in fixture.calls if name == 'create']
        self.assertIn(('SIMPLEFRAME', 'WOSNativeHUDSurface', 'named:ConsoleUI'), created)
        for name in ('WOSHUDSurface', 'WOSMinimapSurface', 'WOSInventorySurface'):
            self.assertIn(('FRAME', name, 'FRAME:WOSIndependentRoot'), created)
        self.assertTrue(all(kind != 'BACKDROP' for kind, name, _ in created
                            if name in ('WOSHUDSurface', 'WOSMinimapSurface', 'WOSInventorySurface')))

    def test_returning_from_pick_hides_engine_restored_stock_chrome(self):
        fixture = ui_fixture.DeferredUIStartup()
        fixture.setUp()
        vm = fixture.vm
        vm.run('WUI_Bootstrap')
        vm.g['WUI_NativeReady'] = True
        vm.g['WUI_CommandBar'] = 'commands'
        vm.g['WUI_NativeDetailParent'] = 'inventory'
        vm.g['ModuloInteger'] = lambda a,b:a % b
        fixture.calls.clear()
        vm.run('WUI_RestoreCompactNative')
        for name in ('ConsoleTopBar', 'ConsoleBottomBar', 'ResourceBarFrame'):
            self.assertIn(('visible', ('named:' + name, False)), fixture.calls)
        self.assertIn(('visible', ('commands', True)), fixture.calls)

    def test_mode_selector_has_no_four_by_three_shade(self):
        source = (ROOT/'triggers/WOS_Start/Starts.j').read_text(encoding='utf-8-sig')
        function = re.search(r'function WOS_CreateModeSelector takes.*?endfunction', source, re.S)[0]
        self.assertNotIn('WOSModeShade', function)
        self.assertNotIn('WOSModeDim', function)
        self.assertEqual(1, function.count('WUI_RegisterModal(WOS_ModeRoot)'))


class ShopTree(unittest.TestCase):
    def test_footer_tabs_clear_the_leftward_catalogue(self):
        vm, pos, size = layout_fixture.ShopAndPickLayout().layout('WoS_Shop_Init.j','WOS_LayoutShop')
        tabs = [pos[vm.g['FRAME_ShopSection'][i]] for i in range(7)]
        self.assertEqual(1, len({y for x,y in tabs}))
        self.assertEqual(sorted(x for x,y in tabs), [x for x,y in tabs])
        self.assertLess(pos[vm.g['FRAME_ShopItem'][0]][0], .10)
        for i in range(35):
            self.assertEqual((.040,.040), size[vm.g['FRAME_ShopItem'][i]])
        list_bottom = pos['FRAME_ShopItemList'][1] - size['FRAME_ShopItemList'][1]/2
        self.assertLess(tabs[0][1] + size[vm.g['FRAME_ShopSection'][0]][1]/2, list_bottom)

    def test_recipe_branch_visibility_changes_with_actual_relations(self):
        vm = load_source('WoS_Shop_Init.j')
        visible = {}
        relations = [111,0,222,333,0,0]
        vm.g.update({
            'FRAME_ShopRecipeLine': {i:('line',i) for i in range(18)},
            'GetLocalPlayer':lambda:0,'GetPlayerId':lambda p:p,
            'ShopCraftScrollItemId':{0:77},'ShopCraftUpgradeOffset':{0:0},'ShopCraftComponentOffset':{0:0},
            'GetSelectedHeroForPlayer':lambda _:None,'ShopUpdateCraftScrollbars':lambda *_:None,
            'ResetCraftFrames':lambda *_:None,'GetVisibleCraftRelation':lambda id,up,offset,slot:relations[slot if up else slot+3],
            'GetCraftUpgradeCount':lambda _:2,'HasCraftComponents':lambda _:True,
            'CheckItemsReduceCostCraft':lambda u,c,id,r:c,'GetItemValue':lambda _:100,
            'CheckBanItems':lambda *_:False,'BlzGetAbilityIcon':lambda _:'icon',
            'BlzFrameSetVisible':lambda f,v:visible.update({f:v}),
            'BlzFrameSetTexture':lambda *_:None,'BlzFrameSetEnable':lambda *_:None,
            'BlzFrameSetText':lambda *_:None,'I2S':str,
        })
        vm.run('CraftItemCheck',(77,0,0))
        self.assertEqual([True,False,True,True,False,False], [visible['line',i*3] for i in range(6)])
        relations[:] = [0,444,0,0,555,0]
        vm.run('CraftItemCheck',(77,0,0))
        self.assertEqual([False,True,False,False,True,False], [visible['line',i*3] for i in range(6)])
        visible.clear()
        vm.g['GetLocalPlayer'] = lambda:1
        vm.run('CraftItemCheck',(77,0,0))
        self.assertFalse(visible)


if __name__ == '__main__':
    unittest.main()
