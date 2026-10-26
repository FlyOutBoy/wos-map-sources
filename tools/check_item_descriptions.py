"""Audit item text against merged native objects and reviewed MAIN script contracts.

Only description/extended_tooltip may be changed by --fix. Native raw metadata and
gameplay sources are read-only. This is source parity, not a Warcraft engine test.
"""
from pathlib import Path
from collections import defaultdict
import argparse
import copy
import json
import re

import war3_object_workspace as workspace

ROOT = Path(__file__).resolve().parents[1]
SOURCE_PATHS = ('Items/Items.j', 'Systems/ItemEnter.j', 'Systems/Systems1.j',
                'Systems/Systems2.j', 'Systems/DmgSys.j', 'Systems/CastAItems.j',
                'Systems/CastCheck.j', 'Systems/DecorDestroy_and_Erza_Debuff.j',
                'WOS_Start/Starts.j', 'WOS_Start/WoS_Shop_Init.j')
# The only inherited (not explicitly overridden) stat among the item's stat
# abilities: Warcraft's Item Mana Bonus (200), used by Fairy Tail Emblem/A0D2.
NATIVE_STAT_DEFAULTS = {'AI2m': {'Iman': 200}}


def clean(text):
    return re.sub(r'/\*.*?\*/|//[^\n]*', '', text, flags=re.S)


def number(value):
    return f'{float(value):.6g}'


class Audit:
    def __init__(self):
        self.items = json.loads((ROOT/'object-data/items.json').read_text(encoding='utf-8-sig'))
        self.sources = {name: clean((ROOT/'triggers'/name).read_text(encoding='utf-8-sig'))
                        for name in SOURCE_PATHS}
        self.values, self.ids = {}, {}
        for source in self.sources.values():
            self.values.update({name: float(value) for name, value in re.findall(
                r'^\s*(?:private )?(?:constant )?(?:integer|real) (\w+)\s*=\s*(-?\d+(?:\.\d+)?)\b', source, re.M)})
            self.ids.update(re.findall(r'\binteger (\w+)\s*=\s*\x27(.{4})\x27', source))
        documents, _ = workspace.prepare_documents(ROOT/'object-data', ROOT/'.object-data-raw')
        self.abilities = defaultdict(dict)
        self.base_ids = {}
        for document in documents:
            if document['kind'] == 'abilities':
                for obj in document['custom_objects']:
                    self.base_ids[workspace.object_id(obj)] = obj['old_id']['text']
                    self.abilities[workspace.object_id(obj)].update({
                        (m['field']['text'], m.get('level', 0)): workspace.value_for_user(m)
                        for m in obj['modifications']})
        self.extra = defaultdict(lambda: defaultdict(float))
        entry = self.sources['Systems/ItemEnter.j']
        for identity, block in re.findall(r'if\s+id\s*==\s*(\x27.{4}\x27|\w+)\s+then\s*(.*?)endif', entry, re.S):
            identity = identity[1:-1] if identity.startswith("'") else self.ids.get(identity)
            if identity not in self.items:
                continue
            for stat, expression in re.findall(r'call Add(Hp|Mp)Regen\(c,\s*([\w.]+),\s*true\)', block):
                self.extra[identity][stat.lower()+' regen'] += self.value(expression)
            for levels in re.findall(r"call AddSpellLevel\(c,\s*'A01C',\s*(\d+),\s*true\)", block):
                self.extra[identity]['ms'] += self.native('A01C', 'Imvb', int(levels)+1)
        self.bodies = self.reviewed_bodies()

    def value(self, expression):
        return self.values[expression] if expression in self.values else float(expression)

    def v(self, expression):
        return number(self.value(expression))

    def native(self, ability, field, level=1):
        return self.abilities[ability][field, level]

    def n(self, ability, field, level=1):
        return number(self.native(ability, field, level))

    def stats(self, identity):
        totals = defaultdict(float)
        fields = dict(Istr='str', Iagi='agi', Iint='int', Ilif='hp', Iman='mp', Iatt='atk', Idef='physical armor')
        for ability in self.items[identity].get('abilities', '').split(','):
            for field, stat in fields.items():
                inherited = NATIVE_STAT_DEFAULTS.get(self.base_ids.get(ability), {}).get(field, 0)
                totals[stat] += self.abilities[ability].get((field, 1), inherited)
        totals.update(self.extra[identity])
        for id_, rating in (('I00K', 10), ('I00L', 20), ('I020', 20)):
            if identity == id_:
                block = self.sources['Systems/Systems1.j'].split("if HasCachedItem(td, '"+id_+"') > 0 then", 1)[1]
                totals['magic resistance rating'] = float(re.search(r'itemMagRes = itemMagRes \+ ([\d.]+)', block)[1])
        if identity == 'I013':
            totals['magic damage reduction'] = 10
        # Preserve the established header's allstats/individual-stat presentation.
        common = min(totals['str'], totals['agi'], totals['int']) if re.search(
            r'^\+[\d.]+ allstats$', self.items[identity]['extended_tooltip'], re.M) else 0
        totals['allstats'] = common
        for stat in ('str', 'agi', 'int'):
            totals[stat] -= common
        return totals

    def header(self, identity, original):
        totals = self.stats(identity)
        aliases = {'phys resistance': 'physical armor', 'armor': 'physical armor',
                   'mag resistance': 'magic damage reduction' if identity == 'I013' else 'magic resistance rating'}
        old = [line for line in original.splitlines() if line.startswith('+')]
        lines, used = [], set()
        for line in old:
            match = re.fullmatch(r'\+([\d.]+)(%?) ([\w ]+)', line)
            if not match:
                raise ValueError(f'{identity}: unrecognized stat line: {line}')
            stat = aliases.get(match[3], match[3])
            if stat in used:
                raise ValueError(f'{identity}: duplicate stat line: {stat}')
            used.add(stat)
            value = totals.get(stat, 0)
            if value:
                percent = '%' if stat == 'magic damage reduction' else ''
                lines.append('+'+number(value)+percent+' '+stat)
        for stat, value in totals.items():
            if value and stat not in used:
                percent = '%' if stat == 'magic damage reduction' else ''
                lines.append('+'+number(value)+percent+' '+stat)
        return lines

    def reviewed_bodies(self):
        v, n = self.v, self.n
        chogurt = lambda evolved: (
            f"Active: Creates a field within {v('Chogurt_Aoe')} range that restores "
            f"{v('Chogurt_MpRestoreStatic')} + {v('Chogurt_MpRestore')}% of max MP per second to allies"
            + (" (as HP instead when their mana is full)" if evolved else "")
            + f", grants +{n('A0G2', 'Inf2', 2 if evolved else 1)} physical armor and "
            + v('ChogurtEvolved_DmgReduct' if evolved else 'Chogurt_DmgReduct')
            + "% magic damage reduction, grants 20% movement speed and removes the Slow debuff.\n"
            + f"Field duration: {v('Chogurt_Duration')} sec.\n"
            + f"Armor/protection buff: {n('A0G2','ahdu',2 if evolved else 1)} sec; movement buff: {n('A00D','ahdu',5)} sec.\n"
            + f"Cooldown: {n('A06R','acdn')} sec.")
        return {
            'I00B': 'Passive: Reduces incoming physical damage by 11% and grants 11 magic resistance rating. Each hit also restores HP equal to 10% of the incoming damage over 5 sec.',
            'I011': f"Passive |cffff0000(Intelligence heroes only)|r: Reduces ability cooldowns by {v('OkarunEggReduceCD')}% after use.",
            'I012': f"Passive: Casting an ability with a cooldown of at least 3 sec while at 95% mana or less restores {v('FairyTailEmblem_ManaRestoreStatic')} + {v('FairyTailEmblem_ManaRestorePercent')}% of max MP and {v('FairyTailEmblem_HpRestoreStatic')} HP.\nCooldown: {v('FairyTailEmblem_CD')} sec.",
            'I013': f"Passive: Taking magic or physical ability damage grants a stack. Each stack grants +{n('A07D','Inf2')} physical armor and +4 magic resistance rating.\nMax stacks: 6.\nDuration: {n('A07D','ahdu')} sec.",
            'I017': chogurt(False), 'I03U': chogurt(True),
            'I019': f"Passive: Dealing at least {v('Earth_Power_MinDmg')} physical damage summons an earth hand that strikes after a short delay, dealing {v('Earth_Power_DamageBase')}x main stat physical damage.\nCooldown: {v('Earth_Power_CD')} sec per target.",
            'I01K': f"Passive: Each decoration you destroy restores {v('FrozenHeart_hp')} HP and {v('FrozenHeart_mp')} MP. After {v('FrozenHeart_stack')} uses, restoration goes on cooldown. Does not stack with Hungry Sin.\nEnemies within {n('A07M','aare')} range are slowed by 25%. Your ability casts deal 50 damage to decorations within 650 range.\nAura: You and allies within {n('A10F','aare')} range receive {v('FrozenHeart_ManaAmp')}% more mana regeneration and mana restoration.\nCooldown: {v('FrozenHeart_cd')} sec.",
            'I01L': f"Passive: Your attacks and magic ability damage apply a debuff that lowers the target's magic resistance by {v('TrueZangetsu_Decrease')} percentage points.\nDuration: {n('A07L','ahdu')} sec.",
            'I01M': f"Passive: Your attacks and physical ability damage apply a debuff that lowers the target's physical resistance by {v('Nichirin_Decrease')} percentage points.\nDuration: {n('A01H','ahdu',2)} sec.",
            'I01P': f"Passive: Applying Water also applies Lightning and, if the stat bonus is not already active, grants +15 allstats for 10 sec. The bonus does not stack or refresh while active.\nCooldown: {v('SogyoNoKotowari_CD')} sec per target.",
            'I021': f"Aura: Allies within {n('A09X','aare')} range gain 15% movement speed. During combat, affected allied heroes restore {v('HolyGrail_HpRegen')} HP and {v('HolyGrail_MpRegen')} MP per second.",
            'I02B': f"Aura: Allies within {n('A0CY','aare')} range gain 20% movement speed. During combat, affected allied heroes restore {v('DarkHolyGrail_HpRegen')} HP and {v('DarkHolyGrail_MpRegen')} MP per second. Enemies in the same area receive {v('DarkHolyGrail_HpRegenReduce')}% less active healing.",
            'I02N': f"Passive: Accumulates damage taken while ready. After accumulating {v('SusanooShield_TresholdDamage')} damage, spends {v('SusanooShield_Manacost')} MP to grant a full damage shield for {n('A0F6','ahdu')} sec. If mana is insufficient, keeps the accumulated amount until a later hit can trigger it.\nCooldown: {v('SusanooShield_CD')} sec.",
            'I02O': f"Passive: During combat, restores {v('ElixirOfLife_HpRegen')} HP per second while ready. Taking damage interrupts this restoration for {v('ElixirOfLife_CD')} sec.",
            'I041': f"Passive: Dealing at least {v('DemonDwellerSword_MinDmg')} physical or magic damage grants +{v('DemonDwellerSword_Bonus')}% damage of the opposite type.\nDuration: 3 sec.\nCooldown: {v('DemonDwellerSword_CD')} sec.",
            'I042': f"Active: Throws a knife dealing {v('ShikiKnifeEvolved_DmgAgi')}x ({v('ShikiKnifeEvolved_DmgBase')} + {v('ShikiKnifeEvolved_DmgAgi')}x Agility) attack damage on hit; it can also trigger the passive when ready.\nPassive: Dealing physical damage to an enemy within {v('ShikiKnifeEvolved_RangeCheck')} range deals an additional {v('ShikiKnifeEvolved_DmgBase')} + {v('ShikiKnifeEvolved_DmgAgi')}x Agility physical damage.\nCooldown: Active {n('A0HY','acdn')} sec, Passive {v('ShikiKnifeEvolved_CD')} sec.",
            'I04D': f"Consumed on purchase: permanently grants +2 Strength, +2 Agility and +2 Intelligence.\nDoes not take an inventory slot.\nAvailable from round {v('ScrollOfMastery_Round')}.",
        }

    def expected(self, identity):
        original = self.items[identity]['extended_tooltip']
        old_lines = original.splitlines()
        body = '\n'.join(line for line in old_lines if not line.startswith('+'))
        body = self.bodies.get(identity, body)
        if identity == 'I00E':
            body = re.sub(r'Duration: [\d.]+ sec', f"Duration: {self.n('A00D','ahdu',5)} sec", body)
        if identity == 'I00U':
            body = re.sub(r'burns [\d.]+ mana', f"burns {self.v('HokageHat_Manaburn')} mana", body)
        if identity == 'I01Q':
            body = re.sub(r'Cooldown: [\d.]+ sec', f"Cooldown: {self.v('RyijinJakka_CD')} sec", body)
        if identity == 'I00X':
            body = body.replace('Taking more than 200 physical damage', 'Taking at least 200 physical damage')
        if identity == 'I00M':
            body = body.replace('above 500', 'of at least 500')
        if identity == 'I043':
            body = re.sub(r'(?<!at or )above the threshold', 'at or above the threshold', body)
        if identity == 'I02C':
            body = body.replace('slows the first target', 'slows each target')
        if identity == 'I03X':
            body = body.replace('Attacks repeat after 0.5 sec, dealing the same attack damage.',
                                'Attacks trigger an additional hit after 0.5 sec, dealing 1x ATK as attack damage.')
        for pattern, expression in self.numeric_rules().get(identity, []):
            match = re.search(pattern, body, re.I)
            if not match:
                raise ValueError(f'{identity}: reviewed numeric claim missing: {pattern}')
            body = body[:match.start('n')]+self.v(expression)+body[match.end('n'):]
        return '\n'.join(self.header(identity, original)+([body] if body else []))

    def numeric_rules(self):
        # Each regex selects one player-visible number and reads its authority
        # from the current production globals, not from a second balance table.
        q = r'(?P<n>\d+(?:\.\d+)?)'
        rules = {}
        def add(ids, pattern, variable):
            for identity in ids.split():
                rules.setdefault(identity, []).append((pattern.replace('#', q), variable))
        add('I00G', r'dealing # magic damage', 'FunnyBarrel_Damage')
        add('I00G', r'for # damage per second', 'ErzaFire_DamageBase')
        add('I00J', r'Ignores #% of', 'KanshoandBakuya_Decrease')
        add('I00R', r'Ignores #% of', 'KazekageHat_Decrease')
        add('I00E', r'forward # range', 'Incursio_Range')
        add('I00O', r'up to # range', 'UraharaSet_Range')
        add('I00P I02C', r'deal(?:s|ing) # \+', 'TsuchikageHat_DamageBase')
        add('I00P I02C', r'\+ #x ATK', 'TsuchikageHat_Damage')
        add('I00Q', r'restores # HP', 'HungrySin_hp')
        add('I00Q', r'HP and # MP', 'HungrySin_mp')
        add('I00Q', r'After # uses', 'HungrySin_stack')
        add('I00Q', r'Cooldown: # sec', 'HungrySin_cd')
        add('I00S', r'deals # magic', 'FunnyPresent_Damage')
        add('I00T', r'by #%', 'RaikageHat_Bonus')
        add('I01B', r'by #%', 'ItachiSet_Bonus')
        add('I00U', r'for # sec', 'HokageHat_RootTime')
        add('I00W', r'Dealing # or more', 'Kurikara_MinDmg')
        add('I00W', r'dealing #% of', 'Kurikara_MaxManaDmg')
        add('I00Y', r'Heals #% of', 'AngelBlessing_Heal')
        add('I00Z', r'Duration: # sec', 'NaofumiShield_Duration')
        add('I014', r'deals # damage per tick', 'RockleeWeights_DMG')
        add('I015', r'dealing #x Agility', 'Raijin_Wrath_Damage')
        add('I016', r'dealing #x Agility', 'Shark_Trail_DamageBase')
        add('I01N', r'Deals # \+', 'Hiraishin_DamageBase')
        add('I01N', r'\+ #x main stat', 'Hiraishin_Damage')
        add('I01O I01W', r'hit of # or more', 'LustSin_MinDmg')
        add('I01O I01W', r'Cooldown: # sec', 'LustSin_CD')
        add('I01Q', r'Dealing # or more', 'RyijinJakka_MinDmg')
        add('I01Q', r'dealing #x main stat', 'RyijinJakka_DamageBase')
        add('I01S', r'deals #x Intelligence', 'RedCup_Damage')
        add('I01U', r'dealing #x Intelligence', 'RedFlower_DamageBase')
        add('I01V', r'deals # \+', 'TuskBarrel_Damage')
        add('I01V', r'\+ #x main stat', 'TuskBarrel_DamageStat')
        add('I01X', r'Dealing # or more', 'Nejibana_MinDmg')
        add('I01X', r'dealing #x main stat', 'Nejibana_DamageBase')
        add('I01X', r'Cooldown: # sec', 'Nejibana_CD')
        add('I01Y', r'Dealing # or more', 'Gonryomaru_MinDmg')
        add('I01Y', r'dealing #x main stat', 'Gonryomaru_DamageBase')
        add('I01Y', r'Cooldown: # sec', 'Gonryomaru_CD')
        add('I023', r'increased by #\.', 'QuincyCross_DamageBase')
        add('I024 I025', r'by #%', 'PrisonRealmReduceCD')
        add('I024 I025', r'Cooldown: # sec', 'PrisonRealmCD')
        add('I02A', r'Duration: # sec', 'TurboNeko_Time')
        add('I02C', r'\+ #x main stat', 'TsuchikageHatEvolve_DamageBaseMain')
        add('I02C', r'by #%, then', 'TsuchikageHatEvolve_Slow')
        add('I02C', r'up to # times', 'TsuchikageHatEvolve_BounceTimes')
        add('I02C', r'deals #% less', 'TsuchikageHatEvolve_DamageReducePerBounce')
        add('I02C', r'Slow duration: # sec', 'TsuchikageHatEvolve_SlowTime')
        add('I02D', r'ignores #%', 'EnvySin_IgnoreAmount')
        add('I02E', r'ignores #%', 'WrathSin_IgnoreAmount')
        add('I02F', r'regeneration by #%', 'HellBlaze_HealCutPerStack')
        add('I02F', r'loses #% of', 'HellBlaze_ManaBurnPercent')
        add('I02G', r'Deals # \+', 'MeraMera_Damage')
        add('I02G', r'\+ #% of', 'MeraMera_MaxHpDamage')
        add('I02G', r'up to #\)', 'MeraMera_MaxDamage')
        add('I02G', r'within # range', 'MeraMera_Aoe')
        add('I02H', r'Reflects #%', 'YataMirror_ReversedDmg')
        add('I02H', r'within # range', 'YataMirror_Range')
        add('I02J', r'Taking # or more', 'GutsArmor_DmgTreshold')
        add('I02J', r'additional #x Strength', 'GutsArmor_DamageBase')
        add('I02J', r'Cooldown: # sec', 'GutsArmor_CD')
        add('I02K', r'Restores # HP', 'Avalon_HpRestore')
        add('I02L', r'dealing #x Strength', 'Rhitta_Damage')
        add('I02L', r'for # sec', 'Rhitta_StrDuration')
        add('I02M', r'by # sec', 'SacredGearBooster_ItemCDReduce')
        add('I02M', r'\+\s*#x main stat', 'SacredGearBooster_Damage')
        add('I02M', r'Cooldown: # sec', 'SacredGearBooster_CD')
        add('I02P', r'within # range', 'ShikiKnife_RangeCheck')
        add('I02P', r'additional # \+', 'ShikiKnife_DmgBase')
        add('I02P', r'\+ #x Agility', 'ShikiKnife_DmgAgi')
        add('I02P', r'Cooldown: # sec', 'ShikiKnife_CD')
        add('I02S', r'deals #x main stat', 'Tachikaze_DamageBase')
        add('I02S', r'Cooldown: # sec', 'Tachikaze_CD')
        add('I03V', r'within # range', 'HokageHatEvolved_AoE')
        add('I03V', r'for # sec', 'HokageHatEvolved_RootTime')
        add('I03V', r'burns # mana', 'HokageHatEvolved_Manaburn')
        add('I03V', r'Duration: # sec', 'HokageHatEvolved_Time')
        add('I03W', r'Every # sec', 'SakuraSesshou_Interval')
        add('I03W', r'within # \(', 'SakuraSesshou_Aoe')
        add('I03W', r'dealing #x main stat', 'SakuraSesshou_Damage')
        add('I03W', r'Duration: # sec', 'SakuraSesshou_Duration')
        add('I03Y', r'bleed for # sec', 'Murasame_Duration')
        add('I03Y', r'dealing #x ATK', 'Murasame_AttackDamage')
        add('I043', r'Cooldown: # sec', 'CupOfTeaEvolved_CD')
        add('I044', r'deal # or more', 'DeathNote_MinDmg')
        add('I044', r'additional #%', 'DeathNote_Damage')
        add('I044', r'after # sec', 'DeathNote_Time')
        add('I044', r'Cooldown: # sec', 'DeathNote_CD')
        add('I045', r'Restores # HP', 'AvalonEvolved_HpRestore')
        add('I046 I047 I048 I049', r'within # range', 'Kusanagi_Aoe')
        add('I046', r'deals #x ATK', 'Kusanagi_AtkMult')
        add('I047 I048 I049', r'deals #x ATK', 'KusanagiGrade_AtkMult')
        add('I04A', r'within # range', 'HashiramaCells_AllyAoe')
        add('I04A', r'equal to #% of', 'HashiramaCells_AllyHeal')
        add('I04A', r'Sacrifices #%', 'HashiramaCells_HpCost')
        add('I04A', r'for # sec', 'HashiramaCells_Duration')
        add('I04B', r'receive #% more', 'ShunShunRikka_HealAmp')
        add('I04B', r'last # sec shorter', 'ShunShunRikka_StunReduce')
        add('I04C', r'Dealing # or more', 'AshisogiJizo_MinDmg')
        add('I04C', r'dealing #x Agility', 'AshisogiJizo_DamageAgi')
        add('I04C', r'for # sec', 'AshisogiJizo_Duration')
        return rules

    def changes(self):
        changes = []
        for identity, obj in self.items.items():
            expected = self.expected(identity)
            for field in ('description', 'extended_tooltip'):
                if obj.get(field) != expected:
                    changes.append(dict(id=identity, name=obj['name'], field=field,
                                        before=obj.get(field), after=expected))
        return changes


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--fix', action='store_true')
    parser.add_argument('--report', type=Path, default=ROOT/'_build/item-descriptions-audit.json')
    args = parser.parse_args()
    audit = Audit()
    changes = audit.changes()
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(dict(items_checked=len(audit.items), changes=changes),
                                     ensure_ascii=False, indent=2), encoding='utf-8')
    if args.fix and changes:
        path = ROOT/'object-data/items.json'
        data = path.read_bytes()
        text = data.decode('utf-8-sig')
        expected = copy.deepcopy(audit.items)
        for change in changes:
            identity, field = change['id'], change['field']
            old = json.dumps(change['before'], ensure_ascii=False)
            new = json.dumps(change['after'], ensure_ascii=False)
            start = text.index('  "'+identity+'": {')
            end = text.find('\n  },', start)
            if end < 0:
                end = len(text)
            block = text[start:end]
            needle = '"'+field+'": '+old
            if block.count(needle) != 1:
                raise ValueError(f'{identity}/{field}: ambiguous source field')
            text = text[:start]+block.replace(needle, '"'+field+'": '+new, 1)+text[end:]
            expected[identity][field] = change['after']
        assert json.loads(text) == expected, 'Non-description fields would change'
        backup = ROOT/'_build/item-descriptions-before.json'
        if not backup.exists():
            backup.write_bytes(data)
        path.write_bytes((b'\xef\xbb\xbf' if data.startswith(b'\xef\xbb\xbf') else b'')+text.encode('utf-8'))
    identities = list(dict.fromkeys(c['id'] for c in changes))
    print(f'{len(audit.items)} items checked; {len(identities)} items / {len(changes)} text fields '+('updated' if args.fix else 'differ'))
    for identity in identities:
        print(identity, audit.items[identity]['name'])
    return 0 if args.fix or not changes else 1


if __name__ == '__main__':
    raise SystemExit(main())
