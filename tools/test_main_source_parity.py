"""The import guard must detect stale gameplay, positions and cached globals."""
import unittest
from check_main_source_parity import compare


def script(body='call SetUnitX(u, 1.0)', value='2', prefix='WOSUI__'):
    return f'''globals
real {prefix}Duration = {value}
endglobals
function {prefix}Render takes nothing returns nothing
{body}
endfunction
'''


class SourceParity(unittest.TestCase):
    def assert_same(self,a,b):
        report=compare(a,b)
        self.assertFalse(any(v for v in report.values() if isinstance(v,list)))

    def test_private_mangling_spacing_and_comments_do_not_change_behavior(self):
        self.assert_same(script(),script('call SetUnitX ( u , 1.0 ) // comment',prefix='WOSUI___'))

    def test_feed_coordinate_changes_are_reported(self):
        result=compare(script('call SetUnitX(u, 0.442)'),script('call SetUnitX(u, 0.560)'))
        self.assertEqual(['WOSUI_Render'],result['changed_functions'])

    def test_global_balance_changes_are_reported(self):
        self.assertEqual(['WOSUI_Duration'],compare(script(),script(value='18'))['changed_globals'])

    def test_missing_newer_ui_callback_is_reported(self):
        a=script()+'function DS_Poll takes nothing returns nothing\nendfunction\n'
        self.assertEqual(['DS_Poll'],compare(a,script())['missing_functions'])

    def test_urls_and_message_spacing_are_not_treated_as_comments(self):
        a=script('call Msg("https://a/b two words")')
        b=script('call Msg("https://a/b twowords")')
        self.assertEqual(['WOSUI_Render'],compare(a,b)['changed_functions'])

    def test_indented_hero_methods_are_included(self):
        a=script()+'        function Hero_Loop takes nothing returns nothing\ncall Drain(2)\n        endfunction\n'
        b=a.replace('Drain(2)','Drain(18)')
        self.assertEqual(['Hero_Loop'],compare(a,b)['changed_functions'])

    def test_multiline_retired_functions_are_not_live_code(self):
        a=script()+'\n/*\nfunction Old takes nothing returns nothing\nendfunction\n*/'
        self.assert_same(a,script())

    def test_rawcodes_retain_spaces_and_underscores(self):
        self.assertEqual(['WOSUI_Render'],compare(script("call Cast('a__a')"),script("call Cast('a_a ' )"))['changed_functions'])


if __name__=='__main__':unittest.main()
