"""Execute Patriot's production stance and level-35 death loop with native mocks."""
import re
import unittest
from pathlib import Path

from test_crocodile import JassState

ROOT = Path(__file__).resolve().parents[1]


def function(source, name):
    return re.search(r'(?m)^\s*(?:private )?function ' + name +
                     r' takes[^\n]*\n.*?\bendfunction', source, re.S)[0]


class PatriotStanceTests(unittest.TestCase):
    def setUp(self):
        source = (ROOT / 'triggers/Heroes/Patriot.j').read_text('utf-8-sig')
        globals_text = '\n'.join(re.findall(r'(?m)^\s*globals\b.*?\bendglobals', source, re.S))
        body = re.search(r'    private struct PatriotSpells_E\b.*?    endstruct', source, re.S)[0]
        # The public toggle and the struct's resurrection method share a name.
        body = body.replace('method PatriotE_Start takes', 'method Perseverance_Start takes')
        helpers = '\n'.join(function(source, name) for name in ('Patriot_SetStance', 'PatriotE_Start'))
        shared = (ROOT / 'triggers/Systems/Systems1.j').read_text('utf-8-sig')
        self.vm = vm = JassState('\n'.join((globals_text, body, helpers, function(shared, 'AddSpellLevel'))))
        self.ns = vm.structs['PatriotSpells_E']
        self.ns.statics.update(MUI_PatriotE=-1, m_PatriotE={})
        self.c = vm.unit(owner=0)
        self.c.hero_level = 35
        self.c.max_life = 1000.
        self.killer = vm.unit(owner=1)
        self.available = {}
        self.icons = {}
        self.kills = 0
        self.random = 0
        vm.g.update(
            hs={}, SetPlayerAbilityAvailable=lambda p, a, b: self.available.update({(p, a): b}),
            SetUnitAbilityLevel=lambda u, a, level: u.abilities[a].update(level=level),
            BlzGetUnitAbilityCooldownRemaining=lambda u, a: u.abilities.get(a, {}).get('cd', 0.),
            BlzStartUnitAbilityCooldown=lambda u, a, cd: u.abilities[a].update(cd=cd),
            BlzSetAbilityIcon=lambda a, icon: self.icons.update({a: icon}),
            AddUnitAnimationProperties=lambda u, prop, b: setattr(u, 'alternate', b),
            AAUniversalTooltips_SetUnitForm=lambda u, form: setattr(u, 'form', form),
            Patriot_RestoreOrder=lambda *a: None, ReduceCooldown=lambda *a: None,
            GetPlayerId=lambda p: p, Player=lambda p: p, GetPlayerName=str,
            GetPlayerVisualColorString=lambda p: '', PlayersMsg=lambda *a: None,
            GetRandomInt=self.next_random, MakeSound=lambda *a: None,
            ReviveHero=lambda u, x, y, eye: setattr(u, 'life', u.max_life),
            UNIT_STATE_MAX_LIFE='max_life', UNIT_STATE_LIFE='life',
            SetUnitState=lambda u, field, value: setattr(u, field, value),
            KillUnit=self.kill, GetLocalPlayer=lambda: -1,
            EffectSpawnColor=vm.effect, AddSpecialEffectTarget=lambda model, *a: vm.effect(model),
            PatriotTimer03Acquire=lambda: setattr(vm, 'clock_users', vm.clock_users + 1),
            PatriotTimer03Release=lambda: setattr(vm, 'clock_users', vm.clock_users - 1))
        for ability in ('PatriotE_ID', 'PatriotF_ID', 'PatriotT_ID'):
            vm.add_ability(self.c, vm.g[ability])
        vm.add_ability(self.c, 'A01C')
        self.c.abilities['A01C']['level'] = 6  # Include unrelated movement bonuses.
        self.transition(False)

    def next_random(self, lo, hi):
        self.random = self.random % (hi - lo + 1) + 1
        return lo + self.random - 1

    def kill(self, unit):
        self.kills += 1
        unit.life = 0.

    def transition(self, attack):
        self.vm.run('Patriot_SetStance', (self.c, attack))

    def toggle(self):
        self.vm.run('PatriotE_Start', (self.c,))

    def cd(self, name, value=None):
        ability = self.c.abilities[self.vm.g[name]]
        if value is not None:
            ability['cd'] = value
        return ability.get('cd', 0.)

    def stance(self, attack, form=None):
        table = self.vm.g['hs']
        self.assertEqual(int(attack), table[id(self.c), 'patriot e'])
        self.assertEqual(attack, self.c.alternate)
        self.assertEqual(int(attack) if form is None else form, self.c.form)
        self.assertEqual(16 if attack else 6, self.c.abilities['A01C']['level'])
        self.assertTrue(self.icons[self.vm.g['PatriotE_ID']].endswith(
            'BTNHero_Patriot_E2.blp' if attack else 'BTNHero_Patriot_E.blp'))
        for ability, visible in (('PatriotF_ID', not attack), ('PatriotT_ID', not attack),
                                 ('PatriotF2_ID', attack), ('PatriotT2_ID', attack)):
            self.assertEqual(visible, self.available[self.c.owner, self.vm.g[ability]])

    def perseverance(self):
        self.c.life = 0.
        self.vm.run('Perseverance_Start', (self.c, self.killer))
        self.assertEqual(100., self.c.life)
        self.assertEqual(1, self.vm.clock_users)
        data = self.ns.m_PatriotE[0]
        data.deallocate = lambda *a: setattr(data, 'alive', False)
        return data

    def finish(self, data, early=False):
        if early:
            self.c.life = 0.
        else:
            data.r = data.rmax + .03
        self.vm.run('Loop_PatriotE')
        self.assertEqual(-1, self.ns.MUI_PatriotE)
        self.assertEqual(0, self.vm.clock_users)
        self.assertEqual(set(), self.vm.effects)
        self.assertEqual(0, self.vm.g['hs'][id(self.c), 'patriot ee'])
        self.stance(False)

    def test_normal_toggle_and_repeated_stance_application_preserve_bonus_and_cd(self):
        self.cd('PatriotT_ID', 27.)
        self.toggle()
        self.stance(True)
        self.assertEqual(27., self.cd('PatriotT2_ID'))
        self.cd('PatriotT2_ID', 19.)
        self.transition(True)
        self.stance(True)
        self.assertEqual(19., self.cd('PatriotT2_ID'))
        self.toggle()
        self.stance(False)
        self.assertEqual(19., self.cd('PatriotT_ID'))
        self.transition(False)
        self.stance(False)

    def test_death_from_both_stances_restores_defense_and_first_toggle_works(self):
        for attack in (False, True):
            for early in (False, True):
                with self.subTest(attack=attack, early=early):
                    self.transition(attack)
                    self.cd('PatriotT_ID', 51.)
                    if attack:
                        self.cd('PatriotT2_ID', 23.)
                    data = self.perseverance()
                    self.stance(True, form=2)
                    self.assertEqual(23. if attack else 51., self.cd('PatriotT2_ID'))
                    self.cd('PatriotT2_ID', 17.)
                    self.finish(data, early)
                    self.assertEqual(17., self.cd('PatriotT_ID'))
                    self.c.life = 1000.  # Ordinary round/base resurrection.
                    self.toggle()
                    self.stance(True)
                    self.toggle()
                    self.stance(False)

    def test_switching_during_perseverance_keeps_bonus_balanced_on_cleanup(self):
        data = self.perseverance()
        self.toggle()
        self.stance(False)
        self.toggle()
        self.stance(True, form=2)
        self.toggle()
        self.stance(False)
        self.finish(data)

    def test_stance_without_learned_ultimate_does_not_grant_it(self):
        self.vm.remove_ability(self.c, self.vm.g['PatriotT_ID'])
        self.toggle()
        self.stance(True)
        self.assertNotIn(self.vm.g['PatriotT2_ID'], self.c.abilities)
        self.toggle()
        self.stance(False)


if __name__ == '__main__':
    unittest.main()
