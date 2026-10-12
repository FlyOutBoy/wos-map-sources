"""Run the UI and native-map regression suites with a saved failure report."""
from pathlib import Path
import sys
import unittest

SUITES = ['test_wos_ui', 'test_wos_ui_multiplayer', 'test_wos_ui_stat_help', 'test_wos_ui_checkpoint30', 'test_wos_ui_minimap', 'test_wos_ui_runtime_fixes', 'test_wos_ui_checkpoint13',
          'test_wos_ui_checkpoint14', 'test_wos_ui_checkpoint15', 'test_wos_ui_checkpoint16',
          'test_wos_ui_checkpoint17', 'test_wos_ui_checkpoint18', 'test_wos_ui_checkpoint19', 'test_wos_ui_checkpoint20', 'test_wos_ui_checkpoint21', 'test_wos_ui_checkpoint22', 'test_wos_ui_checkpoint23', 'test_ally_hero_ability_ui', 'test_team_map_pings',
          'test_sync_war3_triggers', 'test_test_map_workflow']
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
