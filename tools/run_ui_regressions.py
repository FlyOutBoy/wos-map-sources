"""Run the UI and native-map regression suites with a saved failure report."""
from pathlib import Path
import sys
import unittest

SUITES = ['test_ui_performance', 'test_damage_stats_layout', 'test_damage_stats', 'test_guide_forms', 'test_startup_followup', 'test_match_votes', 'test_ui_vote_followup', 'test_hero_progress', 'test_ui_corrections', 'test_item_range_preview', 'test_ui_mouse_demand', 'test_ui_followup', 'test_quickbuy_fix8', 'test_reset_keys', 'test_shop_fast_settings', 'test_ability_range_fixes', 'test_hero_range_rules', 'test_ability_range_hold', 'test_ability_range_preview', 'test_wos_ui_focus', 'test_wos_ui', 'test_wos_ui_multiplayer', 'test_wos_ui_stat_help', 'test_wos_ui_selection', 'test_wos_ui_checkpoint30', 'test_wos_ui_minimap', 'test_wos_ui_runtime_fixes', 'test_wos_ui_checkpoint13',
          'test_wos_ui_checkpoint14', 'test_wos_ui_checkpoint15', 'test_wos_ui_checkpoint16',
          'test_wos_ui_checkpoint17', 'test_wos_ui_checkpoint18', 'test_wos_ui_checkpoint19', 'test_wos_ui_checkpoint20', 'test_wos_ui_checkpoint21', 'test_wos_ui_checkpoint22', 'test_wos_ui_checkpoint23', 'test_ally_hero_ability_ui', 'test_team_map_pings',
          'test_sync_war3_triggers', 'test_test_map_workflow']
SUITES += ['test_hero_balance_followup', 'test_hero_packet_followup', 'test_hero_impact_reach', 'test_main_source_parity', 'test_common_performance', 'test_followup_033c']

if __name__ == '__main__':
    report = Path('_build/ui-redesign/checkpoint23-tests.txt')
    report.parent.mkdir(parents=True, exist_ok=True)
    names = [name for name in SUITES if Path(__file__).with_name(name+'.py').exists()]
    with report.open('w', encoding='utf-8') as stream:
        result = unittest.TextTestRunner(stream=stream, verbosity=2).run(
            unittest.defaultTestLoader.loadTestsFromNames(names))
    print(f'{result.testsRun} checks; {len(result.errors)} errors; {len(result.failures)} failures')
    for test, trace in result.errors + result.failures:
        print(test.id(), '\n', trace.splitlines()[-1])
    sys.exit(not result.wasSuccessful())
