import contextlib
import io
import json
import re
from pathlib import Path
import struct
import tempfile
import unittest
from unittest.mock import patch

import test_map_runtime as runtime
from test_crocodile import JassState

ROOT = Path(__file__).resolve().parents[1]


class MinimalRuntime(unittest.TestCase):
    def test_ui_adapter_preserves_public_signatures_without_executable_ui_work(self):
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp)/'MinimalUI.j'
            runtime.minimal_ui(ROOT, path)
            adapter = path.read_text()
        for filename in ('WOSUI.j', 'UniversalTooltips.j'):
            source = (ROOT/'triggers/WOS_Start'/filename).read_text('utf-8-sig')
            signatures = re.findall(r'(?m)^[ \t]*(?:public )?(function \w+ takes [^\r\n]+)', source)
            for signature in signatures:
                if signature.startswith('function WOS_UTB_Init_'):
                    continue
                self.assertIn(signature.rstrip(), adapter)
        functions = re.compile(r'(?m)^[ \t]*(?:private )?function (\w+)[^\n]*\n[\s\S]*?^[ \t]*endfunction')
        code = runtime.mask(functions.sub(lambda m:'' if m[1].startswith('WUI_Test') or m[1] in {'WUI_HeroProgress','WUI_HeroProgressText'} else m[0],adapter))
        self.assertNotRegex(code, r'\b(?:call|initializer|CreateTimer|CreateTrigger|InitHashtable|Blz\w+)\b')
        self.assertNotIn('library TooltipBuilder', adapter)
        self.assertNotIn('WOS_UTB_Init_', adapter)
        self.assertIn('function WUI_OnReady takes code callback returns nothing\nendfunction', adapter)
        self.assertIn('function SetUnitForm takes unit hero, integer formId returns nothing\nendfunction', adapter)
        self.assertIn('call WUI_TestHeroProgress(',adapter)
        self.assertNotIn('TimerStart(',adapter)
        self.assertNotIn('BlzLoadTOCFile(',adapter)

    def test_gameplay_initializers_remain_active_and_only_ui_owners_are_guarded(self):
        source = ('library OtherSpells initializer Init\n'
                  'private function Init takes nothing returns nothing\n'
                  'local timer t = CreateTimer()\ncall TimerStart(t, 1., true, function Loop)\nendfunction\n'
                  'private static method onInit takes nothing returns nothing\ncall RegisterOtherHero()\nendmethod\nendlibrary\n')
        transformed, disabled = runtime.lighten(source, 'Heroes/Other.j', 'Frostnova', True)
        self.assertEqual([], disabled)
        self.assertEqual(source, transformed)
        self.assertEqual(source, runtime.unguard(transformed))
        self.assertEqual((transformed, disabled), runtime.lighten(transformed, 'Heroes/Other.j', 'Frostnova', True))
        self.assertEqual((source, []), runtime.lighten(source, 'Heroes/Frostnova.j', 'Frostnova', True))
        core = source.split('private static method')[0].replace('OtherSpells', 'GearSystems')+'endlibrary\n'
        self.assertEqual((core, []), runtime.lighten(core, 'Systems/Systems1.j', 'Frostnova', True))
        transformed,disabled=runtime.lighten(core,'WOS_Start/Scoreboard.j','Frostnova',True)
        self.assertEqual(['Init'],disabled)
        self.assertEqual(core,runtime.unguard(transformed))

    def test_companion_timer_and_event_registrations_remain_intact(self):
        source=('function Other_On takes nothing returns nothing\n'
                'call TimerStart(t, .03, true, function Tick)\n'
                'call TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_DAMAGING)\nendfunction\n')
        transformed,_=runtime.lighten(source,'Heroes/Other.j','Frostnova',True)
        self.assertEqual(source,transformed)

    def test_music_toc_and_foreign_sound_probe_are_guarded_without_losing_startup(self):
        source = ('function Trig_Start_Actions4 takes nothing returns nothing\n'
                  'loop\nif GetSoundFileDuration("foreign.mp3") > 0 then\nendif\nexitwhen true\nendloop\n'
                  'call BlzLoadTOCFile("Templates.toc")\ncall TasAbilityChargeBox_Init()\ncall TestHero_Register(Hero[0])\nendfunction\n'
                  'function main takes nothing returns nothing\ncall SetMapMusic("Music", true, 0)\ncall InitCustomTriggers()\nendfunction\n')
        transformed, disabled = runtime.lighten(source, 'Init/Start.j', 'Frostnova', True)
        self.assertEqual(3, len(disabled))
        self.assertIn('call TestHero_Register(Hero[0])', transformed)
        self.assertEqual(source, runtime.unguard(transformed))
        self.assertEqual((source, []), runtime.lighten(transformed, 'Init/Start.j', 'Frostnova', False))

    def test_gameplay_editor_triggers_are_not_disabled(self):
        source = ('// function Fake takes nothing returns nothing\n'
                  'function InitTrig_DmgSys takes nothing returns nothing\ncall RegisterDamage()\nendfunction\n'
                  'function InitTrig_MouseMove takes nothing returns nothing\ncall RegisterMouseTimer()\nendfunction\n')
        transformed, disabled = runtime.lighten(source, 'Systems/Test.j', 'Frostnova', True)
        self.assertEqual([], disabled)
        self.assertEqual(source, transformed)

    def test_incomplete_generated_guard_is_rejected(self):
        with self.assertRaises(ValueError):
            runtime.unguard(runtime.BEGIN+'call foo()\n')

    def test_real_cast_initializer_subscribes_without_level_up_trigger(self):
        source = (ROOT/'triggers/Systems/CastCheck.j').read_text('utf-8-sig')
        source = source[source.index('function InitTrig_CastCheck '):]
        transformed, _ = runtime.lighten(source, 'Systems/CastCheck.j', 'Frostnova', True)
        self.assertEqual(source, runtime.unguard(transformed))
        self.assertEqual(transformed, runtime.lighten(transformed, 'Systems/CastCheck.j', 'Frostnova', True)[0])
        vm = JassState(transformed.replace('static if LIBRARY_WOSTestMinimalRuntime then', 'if Minimal then'))
        registrations = []
        vm.g.update(Minimal=True, gg_trg_CastCheck=None, CreateTrigger=lambda:object(),
                    TriggerRegisterAnyUnitEventBJ=lambda t,event:registrations.append((t,event)),
                    TriggerAddCondition=lambda *args:None, Condition=lambda f:f,
                    ManaFix_Snapshot=lambda:False, ManaFix_EndCast=lambda:False,
                    CastHero_Conditions=lambda:False, EVENT_PLAYER_UNIT_SPELL_CAST='cast',
                    EVENT_PLAYER_UNIT_SPELL_ENDCAST='endcast', EVENT_PLAYER_UNIT_SPELL_EFFECT='effect')
        vm.run('InitTrig_CastCheck')
        self.assertIn((vm.g['gg_trg_CastCheck'], 'effect'), registrations)
        vm.g['Minimal'] = False
        registrations.clear()
        vm.run('InitTrig_CastCheck')
        self.assertNotIn((vm.g['gg_trg_CastCheck'], 'effect'), registrations)

    def test_escape_replaces_legacy_reset_and_is_reversible(self):
        source = ('function Trig_Start_Actions3 takes nothing returns nothing\n'
                  'local integer i = 0\ncall UnitResetCooldown(Hero[i])\nendfunction\n')
        transformed, _ = runtime.lighten(source, 'Init/Start.j', 'Frostnova', True)
        self.assertEqual(source, runtime.unguard(transformed))
        self.assertEqual(transformed, runtime.lighten(transformed, 'Init/Start.j', 'Frostnova', True)[0])
        vm = JassState(transformed.replace('static if ', 'if ').replace('TestHero_Reset.evaluate(', 'TestHero_Reset('))
        calls = []
        vm.g.update(LIBRARY_WOSTestMinimalRuntime=True, Hero=['hero'],
                    GetTriggerPlayer=lambda:0, GetPlayerId=lambda p:p,
                    TestHero_Reset=lambda u:calls.append(u),
                    UnitResetCooldown=lambda u:self.fail('legacy mass reset reached minimal TEST'))
        for _ in range(100):
            vm.run('Trig_Start_Actions3')
        self.assertEqual(['hero']*100, calls)

    def test_test_escape_has_no_second_main_handler_with_mass_cooldown_reset(self):
        source=(ROOT/'triggers/Systems/ESC.j').read_text('utf-8-sig')
        transformed,disabled=runtime.lighten(source,'Systems/ESC.j','Frostnova',True)
        self.assertEqual(['InitTrig_ESC'],disabled)
        self.assertEqual(source,runtime.unguard(transformed))
        self.assertEqual((source,[]),runtime.lighten(source,'Systems/ESC.j','Frostnova',False))
        initializer=transformed[transformed.index('function InitTrig_ESC '):]
        self.assertIn(runtime.BEGIN,initializer)

    def test_startup_does_not_replace_the_initialized_shared_hashtable(self):
        source = ('function Trig_Start_Actions4 takes nothing returns nothing\n'
                  'set hs = InitHashtable()\ncall TestHero_Register(Hero[0])\nendfunction\n')
        transformed, _ = runtime.lighten(source, 'Init/Start.j', 'Frostnova', True)
        self.assertEqual(source, runtime.unguard(transformed))
        vm = JassState(transformed.replace('static if ', 'if '))
        original = {'initialized-key': 1}
        calls=[]
        vm.g.update(hs=original, Hero=['hero'], LIBRARY_WOSTestMinimalRuntime=True,
                    CreateKeys=lambda:calls.append('keys'), TestHero_Register=lambda u:calls.append('hero'))
        vm.run('Trig_Start_Actions4')
        self.assertIs(original, vm.g['hs'])
        self.assertEqual(['keys','hero'],calls)

    def test_cast_retains_complete_main_dispatch_and_all_side_hooks(self):
        source=(ROOT/'triggers/Systems/CastCheck.j').read_text('utf-8-sig')
        transformed,_=runtime.lighten(source,'Systems/CastCheck.j','Frostnova',True)
        body=transformed[:transformed.index('function InitTrig_CastCheck ')]
        original=source[:source.index('function InitTrig_CastCheck ')]
        self.assertEqual(original,body)
        self.assertIn('FrostnovaQ_Start(c,x,y)',body)
        self.assertIn('ManaFix_AfterEffects',body)
        self.assertIn('ItemsCast',body)
        self.assertIn('FrierenF_Stacks',body)
        self.assertIn('GearSpellDispatch',body)
        self.assertEqual(source,runtime.unguard(transformed))

    def test_damage_death_and_regeneration_systems_remain_unchanged(self):
        source=('function Trig_Death_Actions takes nothing returns nothing\ncall MakeSound("main")\nendfunction\n'
                'function HealAmp_StartClock takes nothing returns nothing\ncall TimerStart(t, .5, true, function Tick)\nendfunction\n')
        transformed,_=runtime.lighten(source,'Systems/Death.j','Frostnova',True)
        self.assertEqual(source,transformed)
        for relative in ('Systems/DmgSys.j','Systems/Death.j','Systems/Systems1.j'):
            actual=(ROOT/'triggers'/relative).read_text('utf-8-sig')
            self.assertEqual((actual,[]),runtime.lighten(actual,relative,'Frostnova',True))

    def test_level_up_remains_active_without_duplicate_cast_subscription(self):
        source=(ROOT/'triggers/Systems/LvlUpCheck.j').read_text('utf-8-sig')
        transformed,disabled=runtime.lighten(source,'Systems/LvlUpCheck.j','Frostnova',True)
        self.assertEqual(['duplicate-cast-subscription'],disabled)
        self.assertEqual(source,runtime.unguard(transformed))
        self.assertIn('EVENT_PLAYER_HERO_LEVEL',transformed)



if __name__ == '__main__':
    unittest.main()
