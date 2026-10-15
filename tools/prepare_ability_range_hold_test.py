"""Upgrade the isolated Range TEST candidate: instant area preview and hero range rules.

The production enabled trigger tree and MAIN map are never modified.
"""
from pathlib import Path
import argparse
import json
import re

from prepare_ability_range_test import ROOT, once


def channel_ids(workspace):
    objects = json.loads((workspace/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
    ids = {}
    for p in (workspace/'triggers/Heroes').rglob('*.j'):
        for name, raw in re.findall(r"\b(?:constant\s+)?integer\s+(\w+_ID)\s*=\s*'([^']+)'",p.read_text(encoding='utf-8-sig')):
            if objects.get(raw, {}).get('base_id') == 'ANcl':
                ids[name] = raw
    return ids


def upgrade_utb(s, ids):
    s = once(s, 'TakeshiT_ID, TakeshiF_ID, TakeshiG_ID, TakeshiQ2_ID', 'TakeshiT_ID, TakeshiG_ID, TakeshiF_ID, TakeshiQ2_ID')
    rules=(ROOT/'test_map/ability_range/HeroRangeRules.j').read_text(encoding='utf-8-sig')
    rules=once(rules,'library AbilityRangeRules requires GearSystems','').replace('endlibrary','')
    # Inline this TEST component before its caller. Adding a late library
    # dependency would move AAUniversalTooltips behind heroes calling SetUnitForm.
    s = once(s, '    private function ListRealField', rules+'\n'+'''    // The builder and circle share the audited live hero formulas.
    private function ReadHeroCastRange takes unit hero, integer abilId, ability ab, integer level returns real
        return ARules_GetCastRange(hero, abilId, ab, level)
    endfunction

    private function ListRealField''')
    s = once(s, 'set result = ReadCastRange(ab, level)', 'set result = ReadHeroCastRange(hero, abilId, ab, level)')
    m = re.search(r'    private function ParseLevelTags takes[^\n]*\n[\s\S]*?    endfunction',s)
    if not m:
        raise ValueError('Missing existing level-tag resolver')
    pure = m[0].replace('function ParseLevelTags ', 'function ResolveLevelTags ')
    pure = pure.replace('        local integer strHash\n', '').replace('        local string cachedStr\n', '')
    pure = once(pure, '''        set strHash = StringHash(src)
        set cachedStr = LoadStr(HT_DESC, strHash, lvl)
        if cachedStr != null then
            return cachedStr
        endif''', '')
    pure = once(pure, '        call SaveStr(HT_DESC, strHash, lvl, result)\n', '')
    wrapper = '''

    private function ParseLevelTags takes string src, integer lvl returns string
        local integer key
        local string result
        if src == "" or src == null then
            return ""
        endif
        set key = StringHash(src)
        set result = LoadStr(HT_DESC, key, lvl)
        if result == null then
            set result = ResolveLevelTags(src, lvl)
            call SaveStr(HT_DESC, key, lvl, result)
        endif
        return result
    endfunction'''
    s = s[:m.start()]+pure+wrapper+s[m.end():]
    s = once(s, '        boolean cdAfterDur = false', '''        boolean cdAfterDur = false
        boolean previewChannel = false
        boolean previewDirected = false

        method setPreviewDirected takes nothing returns thistype
            set this.previewDirected = true
            return this
        endmethod

        method setPreviewChannel takes nothing returns thistype
            set this.previewChannel = true
            return this
        endmethod''')
    count = 0
    lines = []
    objects = json.loads((ROOT/'object-data/abilities.json').read_text(encoding='utf-8-sig'))
    for line in s.splitlines():
        m = re.search(r'call SpellData\.create\w*\((\w+_ID),', line)
        if m and m[1] in ids:
            line += '.setPreviewChannel()'
            obj = objects[ids[m[1]]]
            modes = {obj.get(f'target_type level {i}', 'Instant (No Target)') for i in range(1,obj.get('levels',1)+1)}
            if len(modes) != 1:
                raise ValueError('Mixed Channel target modes require level-aware metadata: '+m[1])
            if modes != {'Instant (No Target)'}:
                line += '.setPreviewDirected()'
            count += 1
        lines.append(line)
    s = '\n'.join(lines)+'\n'
    if count < 100:
        raise ValueError('Unexpected Channel ability coverage: '+str(count))
    s = once(s, '    // Only abilities registered with this builder, including its form fallback.', '''    private function PreviewMechanic takes unit hero, SpellData data, integer level returns string
        local string text = ResolveLevelTags(data.mecha, level)
        // This heal grows at Lv35 in the hero implementation. Keep both the
        // displayed builder Radius and preview tied to the same hero constants.
        if data.abilId == InoriR_ID and GetHeroLevel(hero) >= 35 then
            set text = StringReplace(text, T_Rad(InoriR_HealAoe), T_Rad(InoriR_HealAoe + InoriR_HealAoeAdd))
        endif
        if data.abilId == GojoR_ID and GetHeroLevel(hero) >= 35 then
            set text = StringReplace(text, T_Rad(GojoR_DamageAoe), T_Rad(GojoR_DamageAoe + GojoR_35lvl_AddAoe))
        endif
        if data.abilId == InoriT_ID then
            set text = StringReplace(text, T_Rad(InoriT_DamageAoe), T_Rad(InoriT_DamageMaxAoe))
        endif
        if data.abilId == TsunaW2_ID then
            set text = StringReplace(text, T_RadExp(TsunaW_DamageAoe, TsunaW_DamageAoe + TsunaW_DamageAoeAdd * 5.0), T_Rad(TsunaW_DamageAoe + TsunaW_DamageAoeAdd * 5.0 + 25.0))
        endif
        return text
    endfunction

    private function ReadMechanicRadius takes string text returns real
        local integer i = 0
        local integer start
        local integer size = StringLength(text)
        local string c
        local real radius
        loop
            exitwhen i + 7 > size
            if SubString(text, i, i + 7) == "Radius:" then
                set i = i + 7
                if SubString(text, i, i + 2) == "|r" then
                    set i = i + 2
                endif
                loop
                    exitwhen i >= size or SubString(text, i, i + 1) != " "
                    set i = i + 1
                endloop
                set start = i
                loop
                    exitwhen i >= size
                    set c = SubString(text, i, i + 1)
                    exitwhen not (c == "0" or S2I(c) > 0 or c == "." or (i == start and c == "-"))
                    set i = i + 1
                endloop
                set radius = S2R(SubString(text, start, i))
                if SubString(text, i, i + 12) == " (Explosion " then
                    set i = i + 12
                    set start = i
                    loop
                        exitwhen i >= size
                        set c = SubString(text, i, i + 1)
                        exitwhen not (c == "0" or S2I(c) > 0 or c == ".")
                        set i = i + 1
                    endloop
                    set radius = RMaxBJ(radius, S2R(SubString(text, start, i)))
                endif
                return radius
            endif
            set i = i + 1
        endloop
        return 0.0
    endfunction

    private function HasAreaImpact takes SpellData data, string text returns boolean
        local integer i = 0
        local integer size = StringLength(text)
        if data.statBase != 0.0 or data.statStep != 0.0 or data.staticBase != 0.0 or data.staticStep != 0.0 or data.statBase2 != 0.0 or data.statStep2 != 0.0 or data.staticBase2 != 0.0 or data.staticStep2 != 0.0 then
            return true
        endif
        set text = StringCase(text, false)
        loop
            exitwhen i >= size
            if SubString(text, i, i + 4) == "heal" or SubString(text, i, i + 7) == "damage:" or SubString(text, i, i + 9) == "mana burn" then
                return true
            endif
            set i = i + 1
        endloop
        return false
    endfunction

    // Instant Channel + actual damage/healing area => builder Radius.
    // Self-heals with no Radius (Kenjaku Q / Mahoraga R) intentionally return 0.
    public function GetPreviewRadius takes unit hero, integer abilId returns real
        local SpellData data
        local integer level
        local integer formId
        local integer sourceId
        local ability ab
        local real radius = 0.0
        local string text
        if HT_DATA == null or hero == null or abilId == 0 then
            return 0.0
        endif
        set level = GetUnitAbilityLevel(hero, abilId)
        if level <= 0 then
            return 0.0
        endif
        set formId = LoadInteger(HT_DATA, GetHandleId(hero), 8888)
        set sourceId = ARules_GetPreviewSource(abilId)
        set data = LoadInteger(HT_DATA, sourceId, formId)
        if data == 0 then
            set data = LoadInteger(HT_DATA, sourceId, 0)
        endif
        if data == 0 then
            return 0.0
        endif
        set ab = BlzGetUnitAbility(hero, abilId)
        if ab != null then
            // Channel target mode comes from the exported object data. Heroes
            // never mutate Ncl2; ignore unused editor levels above "levels".
            if data.previewChannel and not data.previewDirected then
                set text = PreviewMechanic(hero, data, level)
                // Utility areas (mana restore/shield, resistance aura, purge)
                // are real areas too. A self buff without Radius still yields 0.
                set radius = ReadMechanicRadius(text)
            else
                set radius = ReadHeroCastRange(hero, abilId, ab, level)
            endif
        endif
        set ab = null
        return radius
    endfunction

    // Only abilities registered with this builder, including its form fallback.''')
    # Rendering shares the exact mechanic string used by the live tooltip.
    s = once(s, 'call builder.addMechanic(ParseLevelTags(data.mecha, lvl))', 'call builder.addMechanic(PreviewMechanic(hero, data, lvl))')
    s = once(s, 'call builder.addRange(ListRealField(ab, ABILITY_RLF_CAST_RANGE, lvl, lvl))', 'call builder.addRange(FormatReal(ReadHeroCastRange(hero, abilId, ab, lvl)))')
    s = once(s, '        local integer keyDamage\n', '        local integer keyDamage\n        local real previewRadius\n')
    s = once(s, '        if HaveSavedReal(HT_DATA, heroHandle, keyStat) then', '        set previewRadius = GetPreviewRadius(hero, abilId)\n        if HaveSavedReal(HT_DATA, heroHandle, keyStat) then')
    s = once(s, '(LoadReal(HT_DATA, heroHandle, keyDamage) == checkedDamage) then', '(LoadReal(HT_DATA, heroHandle, keyDamage) == checkedDamage) and HaveSavedReal(HT_DATA, heroHandle, abilId + 4000000) and (LoadReal(HT_DATA, heroHandle, abilId + 4000000) == previewRadius) then')
    s = once(s, '        call SaveReal(HT_DATA, heroHandle, keyDamage, checkedDamage)', '        call SaveReal(HT_DATA, heroHandle, keyDamage, checkedDamage)\n        call SaveReal(HT_DATA, heroHandle, abilId + 4000000, previewRadius)')
    s = once(s, '    private function OnPollTimeout takes', '''    // Agreed existing .25 poll: refresh tooltip text even if only a dynamic
    // range/area changed (E-state, radius modifier), with unchanged attributes.
    private function CheckAndSaveRangeState takes unit hero returns boolean
        local integer formId = LoadInteger(HT_DATA, GetHandleId(hero), 8888)
        local HeroData data = LoadInteger(HT_DATA, GetUnitTypeId(hero), 1000 + formId)
        local integer i = 0
        local integer abilityId
        local integer key
        local real radius
        local boolean changed = false
        if data == 0 then
            set data = LoadInteger(HT_DATA, GetUnitTypeId(hero), 1000)
        endif
        if data != 0 then
            loop
                exitwhen i >= data.count
                set abilityId = data.abilities[i]
                set key = abilityId + 5000000
                set radius = GetPreviewRadius(hero, abilityId)
                if not HaveSavedReal(HT_DATA, GetHandleId(hero), key) or LoadReal(HT_DATA, GetHandleId(hero), key) != radius then
                    call SaveReal(HT_DATA, GetHandleId(hero), key, radius)
                    set changed = true
                endif
                set i = i + 1
            endloop
        endif
        return changed
    endfunction

    private function OnPollTimeout takes''')
    start=s.index('    private function OnPollTimeout takes')
    end=s.index('    endfunction',start)
    body=once(s[start:end], '        local unit u\n', '        local unit u\n        local boolean rangeChanged\n')
    body=once(body, '                if CheckAndSavePreviewState(u) then', '                set rangeChanged = CheckAndSaveRangeState(u)\n                if CheckAndSavePreviewState(u) or rangeChanged then')
    s=s[:start]+body+s[end:]
    print('Channel preview metadata from object-data:', count, 'registrations')
    return s


def upgrade_wui(s):
    # Hold/V was retired on promotion; preserve the six existing UI channels.
    return s


def upgrade_tooltip_leave(s):
    s = once(s, '    private constant real AHUI_UPDATE_PERIOD = 0.05', '''    private constant real AHUI_UPDATE_PERIOD = 0.05
    // 10 existing hover ticks: descriptions expire .50 s after icon/pip leave.
    private constant integer AHUI_TOOLTIP_LEAVE_TICKS = 10''')
    s = once(s, '''        if AHUI_CooldownTooltipContains(pid, mouseX, mouseY) then
            set AHUI_PingHoverGrace[pid] = 8
            call AHUI_RefreshTooltip(pid)
            return
        endif
''', '')
    if s.count('set AHUI_PingHoverGrace[pid] = 8') != 2:
        raise ValueError('Unexpected tooltip grace renewals')
    s = s.replace('set AHUI_PingHoverGrace[pid] = 8', 'set AHUI_PingHoverGrace[pid] = AHUI_TOOLTIP_LEAVE_TICKS')
    return once(s, '''        set AHUI_HoveredSlot[pid] = previousSlot
        set AHUI_HoverPips[pid] = previousPips
        set AHUI_PingHoverGrace[pid] = AHUI_PingHoverGrace[pid] - 1
        return''', '''        set AHUI_PingHoverGrace[pid] = AHUI_PingHoverGrace[pid] - 1
        if AHUI_PingHoverGrace[pid] > 0 then
            set AHUI_HoveredSlot[pid] = previousSlot
            set AHUI_HoverPips[pid] = previousPips
            // Keep RMB-on-description usable during the short leave window.
            // The description itself never renews that window.
            if AHUI_CooldownTooltipContains(pid, mouseX, mouseY) then
                call AHUI_RefreshTooltip(pid)
            endif
            return
        endif''')


def upgrade_ahui(s):
    s = upgrade_tooltip_leave(s)
    start = s.index('private function AHUI_ClearSelection ')
    end = s.index('endfunction',start)
    body = once(s[start:end], '    set AHUI_SelectedHero[pid] = null', '    call AR_Cancel(pid)\n    set AHUI_SelectedHero[pid] = null')
    s = s[:start]+body+s[end:]
    s = once(s, '        call WUI_PlaceShift(AHUI_ReqText[slot], WUI_AbilityX(slot) - WUI_HudShift, WUI_PIP_Y - 0.0085, 0.040, 0.008)', '''        if slot == 0 then
            // Reserve a separate footer row under Q for the new hold binding.
            call WUI_PlaceShift(AHUI_ReqText[slot], WUI_AbilityX(slot) - WUI_HudShift, WUI_PIP_Y - 0.0060, 0.040, 0.006)
        else
            call WUI_PlaceShift(AHUI_ReqText[slot], WUI_AbilityX(slot) - WUI_HudShift, WUI_PIP_Y - 0.0085, 0.040, 0.008)
        endif''')
    return once(s, '        call BlzFrameSetScale(AHUI_ReqText[slot], 0.62)', '''        if slot == 0 then
            call BlzFrameSetScale(AHUI_ReqText[slot], 0.52)
        else
            call BlzFrameSetScale(AHUI_ReqText[slot], 0.62)
        endif''')


def upgrade_save(s):
    return once(s, 'Saves hotkeys, camera, music, voice and stats columns now (they are also saved at the end of the match).', 'Saves Q/W/E/R/T/F/G ability aliases, 6 item hotkeys, Shop, Pings, Emotes, Stats, Clear/Load Stats bindings.|nAlso saves Fast Buy/Fast Sell, camera, music, voice, HUD and panel preferences. Settings are also saved at match end.')


def install(workspace):
    workspace = workspace.resolve()
    if workspace == ROOT or ROOT in workspace.parents or workspace in ROOT.parents:
        raise ValueError('Isolated TEST workspace required')
    cfg = json.loads((workspace/'.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
    if workspace.parent not in Path(cfg['mainMap']).resolve().parents:
        raise ValueError('Profile targets production MAIN')
    folder = workspace/'triggers/WOS_Start'
    ids = channel_ids(workspace)
    changes = {}
    for name, fn in [('UniversalTooltips.j',lambda s:upgrade_utb(s,ids)),('WOSUI.j',upgrade_wui),('ShowCD.j',upgrade_ahui),('SaveLoad.j',upgrade_save)]:
        changes[folder/name] = fn((folder/name).read_text(encoding='utf-8-sig'))
    for p,s in changes.items():
        p.write_bytes(s.replace('\n','\r\n').encode('utf-8'))
    (folder/'AbilityRangePreview.j').write_bytes((ROOT/'test_map/ability_range/AbilityRangePreview.j').read_bytes().replace(b'\r\n',b'\n').replace(b'\n',b'\r\n'))
    # A previous development pass tried a separate library. Do not leave a
    # duplicate standalone function or enabled trigger in the candidate.
    old_rules=folder/'HeroRangeRules.j'
    if old_rules.exists():
        if not old_rules.read_text().startswith('// TEST-only read-only presentation'):
            raise ValueError('Unexpected existing HeroRangeRules source')
        old_rules.unlink()
    settings=workspace/'triggers/trigger-settings.json'
    data=json.loads(settings.read_text(encoding='utf-8-sig'))
    data['triggers'].pop('WOS_Start/HeroRangeRules.j',None)
    settings.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print('Range AoE/hold upgrade installed:',workspace)
    from prepare_range_ui_followup import install as install_ui_followup
    install_ui_followup(workspace)
    from prepare_ability_range_fixes_test import install as install_fixes
    install_fixes(workspace)


if __name__ == '__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--workspace',type=Path,required=True)
    install(parser.parse_args().workspace)
