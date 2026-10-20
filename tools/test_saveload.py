"""Career startup/round-trip regressions using the production JASS functions.

Native file calls are simulated; this does not validate the Warcraft engine's
Preloader sandbox, tooltip limits, persistent client cache or multiplayer sync.
"""
from collections import defaultdict
from pathlib import Path
import json
import re
import unittest

from test_crocodile import JassState

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'triggers/WOS_Start/SaveLoad.j'
FIXTURE = ROOT / 'tools/fixtures/saveload/WOS2_local4_-1498221858_-568995849.txt'


def signed32(value):
    return (int(value) + 2**31) % 2**32 - 2**31


def warcraft_hash(text):
    data = text.upper().replace('/', '\\').encode('utf-8')
    mask = 0xffffffff
    def mix(a, b, c):
        for ashift, bshift, cshift in ((13, 8, 13), (12, 16, 5), (3, 10, 15)):
            a = ((a - b - c) & mask) ^ (c >> ashift)
            b = ((b - c - a) & mask) ^ ((a << bshift) & mask)
            c = ((c - a - b) & mask) ^ (b >> cshift)
        return a, b, c
    a = b = 0x9e3779b9
    c = 0
    offset = 0
    while len(data) - offset >= 12:
        a = (a + int.from_bytes(data[offset:offset+4], 'little')) & mask
        b = (b + int.from_bytes(data[offset+4:offset+8], 'little')) & mask
        c = (c + int.from_bytes(data[offset+8:offset+12], 'little')) & mask
        a, b, c = mix(a, b, c)
        offset += 12
    c = (c + len(data)) & mask
    for index, byte in enumerate(data[offset:]):
        if index < 4:
            a = (a + (byte << (8 * index))) & mask
        elif index < 8:
            b = (b + (byte << (8 * (index - 4)))) & mask
        else:
            c = (c + (byte << (8 * (index - 7)))) & mask
    return signed32(mix(a, b, c)[2])


class CareerRuntime:
    def __init__(self, disk=None, pid=0):
        self.disk = disk if disk is not None else {}
        self.pid = pid
        self.names = defaultdict(lambda: 'Other#1234', {pid: 'Owner#1234'})
        self.reads = []
        self.writes = []
        self.cached = {}
        self.tooltips = defaultdict(lambda: 'original tooltip')
        # Abilities absent from the game (e.g. most stock 'AIxx'): setters are ignored, getters give "".
        self.missing = set()
        self.preload_lines = []
        self.handles = []
        self.expired = None
        # JassState represents spell rawcodes as strings; file natives need integer ids.
        vm_source = re.sub(r"'([A-Za-z0-9]{4})'", lambda m: str(int.from_bytes(m[1].encode('ascii'), 'big')), SOURCE.read_text(encoding='utf-8-sig'))
        self.vm = JassState(vm_source)
        g = self.vm.g
        source = SOURCE.read_text(encoding='utf-8-sig')
        for kind, name in re.findall(r'^\s*(\w+) array (\w+)', source, re.M):
            default = None if kind == 'string' else False if kind == 'boolean' else 0
            g[name] = defaultdict(lambda v=default: v)
        for kind, name, value in re.findall(r'^\s*(?:constant\s+)?(integer|boolean|timer|trigger|string)\s+(\w+)\s+=\s+(.+)$', source, re.M):
            value = value.strip()
            if value.startswith("'"):
                g[name] = int.from_bytes(value[1:-1].encode('ascii'), 'big')
            elif value.startswith('"'):
                g[name] = json.loads(value)
            elif value in ('true', 'false', 'null'):
                g[name] = {'true': True, 'false': False, 'null': None}[value]
            else:
                g[name] = int(value)
        g.update({
            'GetLocalPlayer': lambda: self.pid,
            'GetPlayerId': lambda p: p,
            'Player': lambda p: p,
            'GetPlayerName': lambda p: self.names[p],
            'StringHash': lambda s: (-1498221858 if ':A:' in s else -568995849)
                if s.endswith(':Owner#1234') else warcraft_hash(s),
            'StringCase': lambda s, upper: s.upper() if upper else s.lower(),
            'StringLength': lambda s: len(s or ''),
            'SubString': lambda s, a, b: (s or '')[int(a):int(b)],
            'S2I': lambda s: signed32(int(s)) if re.fullmatch(r'-?\d+', s or '') else 0,
            'I2S': lambda n: str(int(n)),
            'ModuloInteger': lambda n, b: signed32(n) % b,
            'BlzSetAbilityTooltip': lambda a, s, level: None if a in self.missing else self.tooltips.__setitem__((a, level), s),
            'BlzGetAbilityTooltip': lambda a, level: '' if a in self.missing else self.tooltips[a, level],
            'Preloader': self.preloader,
            'PreloadGenClear': lambda: self.preload_lines.clear(),
            'PreloadGenStart': lambda: None,
            'Preload': self.preload_lines.append,
            'PreloadGenEnd': self.write,
            'CreateTimer': self.create_timer,
            'TimerStart': lambda handle, delay, repeating, callback: handle.update(callback=callback),
            'GetExpiredTimer': lambda: self.expired,
            'PauseTimer': lambda handle: None,
            'DestroyTimer': lambda handle: handle.update(destroyed=True),
            'CreateTrigger': lambda: {},
            'GetPlayerSlotState': lambda p: 'playing',
            'GetPlayerController': lambda p: 'user',
            'PLAYER_SLOT_STATE_PLAYING': 'playing',
            'MAP_CONTROL_USER': 'user',
            'EVENT_PLAYER_LEAVE': 'leave',
            'TriggerRegisterPlayerEvent': lambda *args: None,
            'TriggerAddAction': lambda *args: None,
            'TriggerAddCondition': lambda *args: None, 'Condition': lambda f: f, 'BlzTriggerRegisterPlayerSyncEvent': lambda *args: None,
            # Checkpoint 27b: chunked career parsing runs through TriggerEvaluate.
            # UI construction is outside these save tests; callbacks stay deferred.
            'WUI_OnReady': lambda callback: None,
            'TriggerEvaluate': lambda trigger: self.vm.run('SaveSystem_AppExtParseChunk' if trigger is self.vm.g.get('ss_AppExtTrigger') else 'SaveSystem_LocalCareerParseChunk'),
            'UnitItemInSlot': lambda *args: None,
            'GetUnitTypeId': lambda hero: hero,
        })

    def create_timer(self):
        handle = {'destroyed': False}
        self.handles.append(handle)
        return handle

    def preloader(self, path):
        self.reads.append(path)
        # Model the documented engine cache: writes do not refresh a read path.
        script = self.cached.setdefault(path, self.disk.get(path, ''))
        # Only interpret the tooltip carrier grammar, never execute file code.
        for match in re.finditer(r"call BlzSetAbilityTooltip\((\d+|'[A-Za-z0-9]{4}'),(.*),0\)", script):
            code = match[1]
            ability, rhs = (int.from_bytes(code[1:-1].encode('ascii'), 'big') if code.startswith("'") else int(code)), match[2]
            if ability in self.missing:
                continue
            prefix = f'BlzGetAbilityTooltip({ability},0)+'
            if rhs.startswith(prefix):
                self.tooltips[ability, 0] += json.loads(rhs[len(prefix):])
            else:
                self.tooltips[ability, 0] = json.loads(rhs)

    def write(self, path):
        self.disk[path] = '\n'.join(self.preload_lines)
        self.writes.append(path)

    def run(self, name, *args):
        return self.vm.run(name, args)

    def start(self):
        self.run('SaveSystem_Init')
        self.expired = self.vm.g['ss_StartupLoadTimer']
        self.expired['callback']()
        self.expired = None

    def finish(self, win=True, hero=1211117892):
        self.run('SaveSystem_OnGameEndDetailed', self.pid, hero, win, 0, 0)
        self.run('SaveSystem_WriteOwnCareerAtFinish')


def game_like_abilities(runtime):
    """As in the real game: of the 120 stock 'AIxx' only two hold a tooltip, stock hero abilities none."""
    codes = re.findall(r'set ss_ChunkCode\[\d+\] = "(AI..)"', SOURCE.read_text(encoding='utf-8-sig'))
    codes = [code for code in codes if code not in ('AIcy', 'AIfg')] + 'AHbz AHwe AHab AHmt AHtb AHtc AHbh AHav AHhb AHds AHad AHre AHfs AHbn AHdr AHpx AOcl AOfs AOsf AOeq AOwk AOcr AOmi AOww AOsh AOws AOae AOre AOhw AOhx AOsw AOvd'.split()
    runtime.missing.update(int.from_bytes(code.encode('ascii'), 'big') for code in codes)


class CareerPersistence(unittest.TestCase):
    def test_long_career_survives_when_most_stock_carriers_are_missing(self):
        disk = {}
        heroes = [1211117600 + i for i in range(45)]
        for game, hero in enumerate(heroes, 1):
            runtime = CareerRuntime(disk)
            game_like_abilities(runtime)
            runtime.start()
            self.assertEqual(game - 1, runtime.run('SaveSystem_GetGamesPlayed', 0), 'career reloaded intact')
            self.assertFalse(runtime.run('SaveSystem_IsLocalLoadFailed'))
            runtime.finish(win=game % 2 == 0, hero=hero)
        path = runtime.run('SaveSystem_LocalFilePath', 0)
        written = [key for key in disk if key.startswith(path[:-4])]
        self.assertGreater(len(written), 1, 'a long career is split into parts')
        self.assertGreater(sum(len(disk[key]) for key in written), 2000)
        runtime = CareerRuntime(disk)
        game_like_abilities(runtime)
        runtime.start()
        self.assertEqual(len(heroes), runtime.run('SaveSystem_GetGamesPlayed', 0))
        self.assertEqual(1, runtime.run('SaveSystem_GetHeroGames', 0, heroes[-1]))

    def test_old_single_file_on_stock_carriers_still_loads(self):
        # File as written by maps before 2026-10-19: pieces on the first working 'AIxx'.
        payload = 'WOS2L5|V,6|A,1,1,0|'
        runtime = CareerRuntime()
        game_like_abilities(runtime)
        path = runtime.run('SaveSystem_LocalFilePath', 0)
        runtime.run('SaveSystem_EnsureIdentity', 0)
        checksum = runtime.run('SaveSystem_LocalChecksum', 0, 1, 1)
        hero = runtime.run('SaveSystem_LocalChecksum', 0, 1, 0)
        payload = 'WOS2L5|V,6|A,1,1,%d|E,1,%d|' % (checksum, hero)
        runtime.disk[path] = "call BlzSetAbilityTooltip('AIcy',\"%s\",0)\n" % payload[:12] + "call BlzSetAbilityTooltip('AIfg',\"%s\",0)\n" % payload[12:]
        runtime.start()
        self.assertFalse(runtime.run('SaveSystem_IsLocalLoadFailed'))
        self.assertEqual(1, runtime.run('SaveSystem_GetGamesPlayed', 0))

    def test_existing_real_l5_file_loads_before_career_opens(self):
        runtime = CareerRuntime()
        path = runtime.run('SaveSystem_LocalRawFilePath', 0)
        runtime.disk[path] = FIXTURE.read_text(encoding='utf-8-sig')
        runtime.start()
        self.assertEqual(1, runtime.run('SaveSystem_GetGamesPlayed', 0))
        self.assertEqual(1, runtime.run('SaveSystem_GetHeroGames', 0, 1211117892))
        self.assertEqual(13, runtime.run('SaveSystem_GetHeroTotalKills', 0, 1211117892))
        self.assertGreater(runtime.run('SaveSystem_GetLocalLoadedRecordCount'), 3)
        self.assertFalse(runtime.run('SaveSystem_IsLocalLoadFailed'))
        self.assertEqual('original tooltip', runtime.tooltips[runtime.vm.g['SAVE_ABILITY'], 0])
        self.assertTrue(runtime.handles[0]['destroyed'])
        self.assertTrue(runtime.run('SaveSystem_IsLocalLegacyImported'))
        runtime.finish()
        self.assertNotEqual(path, runtime.writes[0])

    def test_same_file_accumulates_across_three_map_runs(self):
        disk = {}
        paths = []
        for game in range(1, 4):
            runtime = CareerRuntime(disk)
            runtime.start()
            self.assertEqual(game - 1, runtime.run('SaveSystem_GetGamesPlayed', 0))
            reads = list(runtime.reads)
            runtime.run('SaveSystem_LoadLocalPlayer', 0)
            runtime.finish(win=game != 2)
            self.assertEqual(reads, runtime.reads)
            self.assertEqual(game, runtime.run('SaveSystem_GetGamesPlayed', 0))
            paths.extend(runtime.writes)
            # Duplicate end events cannot count the same match twice.
            runtime.finish()
            self.assertEqual(game, runtime.run('SaveSystem_GetGamesPlayed', 0))
        # One profile file; an empty "_p1" part only terminates the part sequence.
        self.assertEqual(1, len({path for path in paths if '_p' not in path}))
        self.assertEqual(1, len([path for path in disk if '_p' not in path]))
        self.assertEqual(2, runtime.run('SaveSystem_GetGamesWon', 0))
        self.assertEqual(3, runtime.run('SaveSystem_GetHeroGames', 0, 1211117892))

    def test_identity_is_frozen_before_vip_name_and_slot_independent(self):
        runtime = CareerRuntime()
        runtime.run('SaveSystem_SetIdentity', 0, 'Owner#1234')
        path = runtime.run('SaveSystem_LocalFilePath', 0)
        runtime.names[0] = 'Owner|c00FFFF00[VIP]|r'
        runtime.run('SaveSystem_SetIdentity', 0, runtime.names[0])
        self.assertEqual(path, runtime.run('SaveSystem_LocalFilePath', 0))
        other_slot = CareerRuntime(pid=7)
        self.assertEqual(path, other_slot.run('SaveSystem_LocalFilePath', 7))
        self.assertEqual('Owner#1234', runtime.vm.g['ss_Identity'][0])

    def test_corrupt_profile_is_not_partially_used_or_overwritten(self):
        runtime = CareerRuntime()
        path = runtime.run('SaveSystem_LocalFilePath', 0)
        original = FIXTURE.read_text(encoding='utf-8-sig').replace('A,1,1,328162', 'A,1,1,123')
        runtime.disk[path] = original
        runtime.start()
        self.assertTrue(runtime.run('SaveSystem_IsLocalLoadFailed'))
        self.assertEqual(0, runtime.run('SaveSystem_GetGamesPlayed', 0))
        self.assertEqual(0, runtime.vm.g['ss_LocalHeroCount'])
        runtime.finish()
        self.assertEqual([], runtime.writes)
        self.assertEqual(original, runtime.disk[path])

    def test_truncated_and_non_numeric_records_are_rejected(self):
        runtime = CareerRuntime()
        for payload in ('A,0,0', 'A,0,0,17041,', 'A,text,0,17041', 'A,0,0,17041,0'):
            before = runtime.vm.g['ss_LocalRejectedRecordCount']
            runtime.run('SaveSystem_LocalCareerApplyPayload', payload)
            self.assertEqual(before + 1, runtime.vm.g['ss_LocalRejectedRecordCount'])

    def test_new_file_missing_end_marker_is_not_overwritten(self):
        disk = {}
        runtime = CareerRuntime(disk)
        runtime.start()
        runtime.finish()
        path = runtime.writes[0]
        disk[path] = re.sub(r'call BlzSetAbilityTooltip\([^\n]+\+"E,[^\n]+', '', disk[path])
        reopened = CareerRuntime(disk)
        reopened.start()
        self.assertTrue(reopened.run('SaveSystem_IsLocalLoadFailed'))
        reopened.finish()
        self.assertEqual([], reopened.writes)

    def test_zero_key_recovery_imports_hero_and_overall_once(self):
        runtime = CareerRuntime()
        # Build a valid historical zero-key file with production checksums.
        runtime.vm.g['ss_Identity'][0] = 'Owner#1234'
        runtime.vm.g['ss_IdentityKeyA'][0] = 0
        runtime.vm.g['ss_IdentityKeyB'][0] = 0
        checksum = runtime.run('SaveSystem_LocalHeroChecksum', 0, 1211117892, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0)
        ability = runtime.vm.g['SAVE_ABILITY']
        buffer = f'WOS2L5|A,2,1,17176|H,1211117892,2,1,0,0,0,0,0,0,0,0,{checksum}|'
        legacy = 'save\\WOS2_local4_0_0.txt'
        runtime.disk[legacy] = f'call BlzSetAbilityTooltip({ability},{json.dumps(buffer)},0)'
        runtime.start()
        self.assertEqual(2, runtime.run('SaveSystem_GetGamesPlayed', 0))
        self.assertEqual(2, runtime.run('SaveSystem_GetHeroGames', 0, 1211117892))
        self.assertTrue(runtime.run('SaveSystem_IsLocalLegacyImported'))
        runtime.finish()
        self.assertEqual(3, runtime.run('SaveSystem_GetGamesPlayed', 0))
        self.assertNotIn(legacy, runtime.writes)

    def test_observer_startup_allocates_same_timer_without_reading(self):
        runtime = CareerRuntime(pid=10)
        runtime.start()
        self.assertEqual([], runtime.reads)
        # Startup career timer + the delayed settings timer (checkpoint 27b).
        self.assertEqual(2, len(runtime.handles))
        self.assertTrue(runtime.handles[0]['destroyed'])

    def test_other_players_do_not_read_or_receive_owners_profile(self):
        runtime = CareerRuntime()
        runtime.start()
        runtime.finish()
        reads = list(runtime.reads)
        runtime.run('SaveSystem_LoadLocalPlayer', 1)
        self.assertEqual(reads, runtime.reads)
        self.assertEqual(0, runtime.run('SaveSystem_GetGamesPlayed', 1))
        self.assertEqual(0, runtime.run('SaveSystem_GetHeroGames', 1, 1211117892))

    def test_same_nickname_with_other_tag_case_and_vip_reuses_local_profile(self):
        disk = {}
        first = CareerRuntime(disk)
        first.start()
        first.finish()
        second = CareerRuntime(disk, pid=7)
        second.names[7] = ' |c00FFFF00OWNER|r [VIP]#9876 '
        second.start()
        self.assertEqual(1, second.run('SaveSystem_GetLocalGames'))
        second.finish()
        self.assertEqual(first.writes[0], second.writes[0])
        self.assertEqual(2, second.run('SaveSystem_GetLocalGames'))

    def install_app(self, runtime, script=None):
        path = runtime.run('SaveSystem_AppFilePath', runtime.pid)
        runtime.disk[path] = script if script is not None else (ROOT / 'tools/fixtures/saveload/wosapp_career_owner.txt').read_text(encoding='utf-8-sig')
        return path

    def test_real_csharp_export_is_priority_while_local_keeps_accumulating(self):
        runtime = CareerRuntime()
        runtime.disk[runtime.run('SaveSystem_LocalRawFilePath', 0)] = FIXTURE.read_text(encoding='utf-8-sig')
        app = self.install_app(runtime)
        runtime.start()
        self.assertTrue(runtime.run('SaveSystem_HasAppProfile'))
        self.assertEqual(13, runtime.run('SaveSystem_GetGamesPlayed', 0))
        self.assertEqual(9, runtime.run('SaveSystem_GetGamesWon', 0))
        self.assertEqual(13, runtime.run('SaveSystem_GetHeroGames', 0, 1211117892))
        self.assertEqual(1, runtime.run('SaveSystem_GetLocalGames'))
        self.assertEqual(1, runtime.run('SaveSystem_GetLocalHeroGames', 1211117892))
        self.assertEqual(0, runtime.run('SaveSystem_GetGamesPlayed', 1))
        for carrier in runtime.vm.g['ss_AppCarrier'].values():
            self.assertEqual('original tooltip', runtime.tooltips[carrier, 0])
        reads = list(runtime.reads)
        runtime.finish()
        self.assertEqual(reads, runtime.reads)
        self.assertEqual(2, runtime.run('SaveSystem_GetLocalGames'))
        self.assertEqual(13, runtime.run('SaveSystem_GetGamesPlayed', 0))
        self.assertNotIn(app, runtime.writes)
        del runtime.disk[app]
        reopened = CareerRuntime(runtime.disk)
        reopened.start()
        self.assertFalse(reopened.run('SaveSystem_HasAppProfile'))
        self.assertEqual(2, reopened.run('SaveSystem_GetGamesPlayed', 0))

    def test_app_corruption_wrong_owner_and_truncation_fall_back(self):
        script = (ROOT / 'tools/fixtures/saveload/wosapp_career_owner.txt').read_text(encoding='utf-8-sig')
        for damaged in (script.replace('A,13,9,', 'A,13,8,'), re.sub(r'E,[0-9,]+\|', '', script)):
            runtime = CareerRuntime()
            runtime.disk[runtime.run('SaveSystem_LocalRawFilePath', 0)] = FIXTURE.read_text(encoding='utf-8-sig')
            self.install_app(runtime, damaged)
            runtime.start()
            self.assertFalse(runtime.run('SaveSystem_HasAppProfile'))
            self.assertEqual(1, runtime.run('SaveSystem_GetGamesPlayed', 0))
            self.assertFalse(runtime.run('SaveSystem_IsLocalLoadFailed'))
            runtime.finish()
            self.assertEqual(2, runtime.run('SaveSystem_GetLocalGames'))
        other = CareerRuntime()
        other.names[0] = 'Other'
        self.install_app(other, script)
        other.start()
        self.assertFalse(other.run('SaveSystem_HasAppProfile'))

    def test_multi_carrier_csharp_export_loads_all_48_heroes(self):
        runtime = CareerRuntime()
        script = (ROOT / 'tools/fixtures/saveload/wosapp_career_multichunk.txt').read_text(encoding='utf-8-sig')
        self.install_app(runtime, script)
        runtime.start()
        self.assertTrue(runtime.run('SaveSystem_HasAppProfile'))
        self.assertEqual(4800000, runtime.run('SaveSystem_GetGamesPlayed', 0))
        self.assertEqual(2400000, runtime.run('SaveSystem_GetGamesWon', 0))
        self.assertEqual(48, runtime.vm.g['ss_AppHeroCount'])
        self.assertEqual(1211117939, runtime.run('SaveSystem_GetRecordedHeroId', 0, 48))
        self.assertEqual(0, runtime.run('SaveSystem_GetRecordedHeroId', 0, 49))
        for carrier in runtime.vm.g['ss_AppCarrier'].values():
            self.assertEqual('original tooltip', runtime.tooltips[carrier, 0])

    def test_app_only_and_local_only_heroes_are_merged_for_display(self):
        runtime = CareerRuntime()
        self.install_app(runtime)
        runtime.start()
        runtime.finish(hero=1211118157)
        self.assertEqual(1, runtime.run('SaveSystem_GetHeroGames', 0, 1211118157))
        self.assertEqual('Local', runtime.run('SaveSystem_HeroCareerSource', 1211118157))
        self.assertEqual('WOSApp', runtime.run('SaveSystem_HeroCareerSource', 1211117892))
        self.assertEqual(1211118157, runtime.run('SaveSystem_GetRecordedHeroId', 0, 1))
        self.assertEqual(1211117892, runtime.run('SaveSystem_GetRecordedHeroId', 0, 2))
        self.assertEqual(0, runtime.run('SaveSystem_GetRecordedHeroId', 0, 3))

    def test_empty_app_does_not_hide_local_games(self):
        runtime = CareerRuntime()
        a = runtime.run('SaveSystem_LocalChecksum', 0, 0, 0)
        runtime.run('SaveSystem_EnsureIdentity', 0)
        a = runtime.run('SaveSystem_LocalChecksum', 0, 0, 0)
        end = runtime.run('SaveSystem_LocalChecksum', 0, 1, 0)
        self.install_app(runtime, 'call BlzSetAbilityTooltip(1097690227,' + json.dumps(f'WOS2APP1|A,0,0,{a}|E,1,{end}|') + ',0)')
        runtime.disk[runtime.run('SaveSystem_LocalRawFilePath', 0)] = FIXTURE.read_text(encoding='utf-8-sig')
        runtime.start()
        self.assertFalse(runtime.run('SaveSystem_HasAppProfile'))
        self.assertEqual(1, runtime.run('SaveSystem_GetGamesPlayed', 0))

    def test_home_page_requests_stats_for_owner_after_assignment(self):
        vm = JassState((ROOT / 'triggers/WOS_Start/UI_CAREER.j').read_text(encoding='utf-8-sig'))
        text = {}
        requested = []
        def stats(player, value):
            requested.append(player)
            self.assertEqual(0, player)
            return value
        vm.g.update({
            'WCS_PLAYER_COUNT': 10, 'Player': lambda p: p, 'GetLocalPlayer': lambda: 0,
            'Hero': defaultdict(lambda: None), 'WCS_HomeOverall': 'overall', 'WCS_HomeHero': 'hero',
            'SaveSystem_GetGamesPlayed': lambda p: stats(p, 7),
            'SaveSystem_GetGamesWon': lambda p: stats(p, 4),
            'SaveSystem_IsLocalLoadFailed': lambda: False,
            'SaveSystem_HasAppProfile': lambda: False,
            'SaveSystem_CareerSource': lambda: 'Local',
            'SaveSystem_GetLocalGames': lambda: 7,
            'SaveSystem_GetLocalWins': lambda: 4,
            'I2S': str, 'BlzFrameSetText': lambda frame, value: text.update({frame: value}),
            'WCS_Percent': lambda wins, games: '57%',
        })
        vm.run('WCS_UpdateHome', (0,))
        self.assertEqual([0, 0], requested)
        self.assertIn('7', text['overall'])
        self.assertIn('57%', text['overall'])


if __name__ == '__main__':
    unittest.main()
