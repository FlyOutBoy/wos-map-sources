"""Install TEST-only range hooks into an isolated full FIX12 workspace.

Never invoke against the production checkout. Does not write either map.
"""
from pathlib import Path
import argparse
import json

ROOT = Path(__file__).resolve().parents[1]


def once(text, old, new):
    if text.count(old) != 1:
        raise ValueError('Unexpected integration boundary: ' + old[:100])
    return text.replace(old, new, 1)


def integrate_utb(s):
    s = once(s, '    private function ListRealField', '''    // Same numeric source for the builder and the TEST range presentation.
    private function ReadCastRange takes ability ab, integer level returns real
        if ab == null or level < 1 then
            return 0.0
        endif
        return BlzGetAbilityRealLevelField(ab, ABILITY_RLF_CAST_RANGE, level - 1)
    endfunction

    private function ListRealField''')
    s = once(s, '            set v = BlzGetAbilityRealLevelField(ab, field, i - 1)', '''            if field == ABILITY_RLF_CAST_RANGE then
                set v = ReadCastRange(ab, i)
            else
                set v = BlzGetAbilityRealLevelField(ab, field, i - 1)
            endif''')
    return once(s, '    private function RefreshSkill', '''    // Only abilities registered with this builder, including its form fallback.
    // Read live instance data, not the global tooltip text or an ability-ID table.
    public function GetDisplayedRange takes unit hero, integer abilId returns real
        local integer level
        local integer formId
        local ability ab
        local real result
        if HT_DATA == null or hero == null or abilId == 0 then
            return 0.0
        endif
        set level = GetUnitAbilityLevel(hero, abilId)
        if level <= 0 then
            return 0.0
        endif
        set formId = LoadInteger(HT_DATA, GetHandleId(hero), 8888)
        if LoadInteger(HT_DATA, abilId, formId) == 0 and LoadInteger(HT_DATA, abilId, 0) == 0 then
            return 0.0
        endif
        set ab = BlzGetUnitAbility(hero, abilId)
        set result = ReadCastRange(ab, level)
        set ab = null
        return result
    endfunction

    private function RefreshSkill''')


def integrate_wui(s):
    s = once(s, '    private integer WUI_ModalCount = 0', '    private integer WUI_RangeCoverCount = 0\n    private framehandle array WUI_RangeCover\n    private integer WUI_ModalCount = 0')
    s = once(s, 'function WUI_SlotKeyLabel takes', '''function WUI_RangeNativeSlotVisible takes integer slot returns boolean
    return WUI_Command[WUI_CommandSlot(slot)] != null and BlzFrameIsVisible(WUI_Command[WUI_CommandSlot(slot)])
endfunction

function WUI_SlotKeyLabel takes''')
    return once(s, 'function WUI_RegisterCover takes', '''// TEST presentation-only registry; these persistent frames are created on all clients.
function WUI_RegisterRangeCover takes framehandle panel returns nothing
    set WUI_RangeCoverCount = WUI_RangeCoverCount + 1
    set WUI_RangeCover[WUI_RangeCoverCount] = panel
endfunction

// Read-only local gate shared with TEST range presentation. No new frames.
function WUI_RangePreviewBlocked takes nothing returns boolean
    local integer i = 1
    if WUI_OriginHidden or WUI_HeroLayerLocked or WUI_InfoOpen or WUI_MenuOpen or WUI_HotkeyEdit[GetPlayerId(GetLocalPlayer())] then
        return true
    endif
    if WUI_CoverWatch != null and BlzFrameIsVisible(WUI_CoverWatch) then
        return true
    endif
    loop
        exitwhen i > WUI_ModalCount
        if WUI_Modal[i] != null and BlzFrameIsVisible(WUI_Modal[i]) then
            return true
        endif
        set i = i + 1
    endloop
    set i = 1
    loop
        exitwhen i > WUI_RangeCoverCount
        if BlzFrameIsVisible(WUI_RangeCover[i]) then
            return true
        endif
        set i = i + 1
    endloop
    return false
endfunction

function WUI_RegisterCover takes''')


def integrate_ahui(s):
    s = once(s, 'requires GearSystems, WOSUI, TasAbilityChargeBox', 'requires GearSystems, WOSUI, TasAbilityChargeBox, AbilityRangePreview')
    s = once(s, 'private function AHUI_HideTooltip takes integer pid returns nothing\n', 'private function AHUI_HideTooltip takes integer pid returns nothing\n    call AR_Hide(pid)\n')
    # Existing hover pass handles custom icons and pips; use it for native icons too.
    s = once(s, '    if not AHUI_IsEligibleHero(AHUI_SelectedHero[pid], pid) then\n        set AHUI_HoveredSlot[pid] = -1', '''    if WUI_RangePreviewBlocked() then
        call AR_Hide(pid)
        // Preserve existing tooltip/chat behavior; only the new ring is gated.
    endif
    if not AHUI_IsEligibleHero(AHUI_SelectedHero[pid], pid) then
        set AHUI_HoveredSlot[pid] = -1''')
    # Clear request before each hover pass, without toggling alpha every tick.
    s = once(s, '    set mouseX = BlzPixelToFrameX(BlzGetMouseScreenPosX())\n    set mouseY = BlzPixelToFrameY(BlzGetMouseScreenPosY())\n    // Existing UI timer fallback', '''    call AR_Request(pid, null, 0)
    set mouseX = BlzPixelToFrameX(BlzGetMouseScreenPosX())
    set mouseY = BlzPixelToFrameY(BlzGetMouseScreenPosY())
    // Existing UI timer fallback''')
    s = once(s, '        if mouseX >= centerX - halfSize and mouseX <= centerX + halfSize then\n            if AHUI_SlotVisible[index]', '''        if mouseX >= centerX - halfSize and mouseX <= centerX + halfSize then
            // Learned own abilities use native buttons, with no custom tooltip.
            if not AHUI_SlotVisible[index] and GetOwningPlayer(AHUI_SelectedHero[pid]) == Player(pid) and mouseY >= centerY - halfSize and mouseY <= centerY + halfSize and WUI_RangeNativeSlotVisible(slot) then
                if BlzFrameIsVisible(AHUI_TooltipRoot[pid]) then
                    call AHUI_HideTooltip(pid)
                endif
                call AR_Request(pid, AHUI_SelectedHero[pid], AHUI_CurrentAbility[slot])
                return
            endif
            if AHUI_SlotVisible[index]''')
    s = once(s, '                call AHUI_RefreshTooltip(pid)\n                return\n            endif\n            // Pip strip', '''                call AHUI_RefreshTooltip(pid)
                if BlzFrameIsVisible(AHUI_TooltipRoot[pid]) then
                    call AR_Request(pid, AHUI_SelectedHero[pid], AHUI_CurrentAbility[slot])
                endif
                return
            endif
            // Pip strip''')
    s = once(s, '    local boolean refreshAbilities = AHUI_UpdateTick == 0\n\n    loop', '    local boolean refreshAbilities = AHUI_UpdateTick == 0\n\n    call AR_Reconcile()\n    loop')
    s = once(s, '                call AHUI_HideTooltip(pid)\n            endif\n        endif\n        set pid = pid + 1\n    endloop\n\n    set AHUI_UpdateTick', '                call AHUI_HideTooltip(pid)\n            endif\n            call AR_Render(pid)\n        endif\n        set pid = pid + 1\n    endloop\n\n    set AHUI_UpdateTick')
    return s


def install(workspace):
    workspace = workspace.resolve()
    if workspace == ROOT or workspace in ROOT.parents or ROOT in workspace.parents:
        raise ValueError('Use an isolated TEST workspace outside the production checkout')
    cfg = json.loads((workspace/'.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
    main = Path(cfg['mainMap']).resolve()
    if workspace.parent not in main.parents:
        raise ValueError('TEST profile still targets a production map')
    folder = workspace/'triggers/WOS_Start'
    updates = {}
    for name, transform in [('UniversalTooltips.j', integrate_utb), ('WOSUI.j', integrate_wui), ('ShowCD.j', integrate_ahui)]:
        updates[folder/name] = transform((folder/name).read_text(encoding='utf-8-sig'))
    covers = [('MusicPlayer.j','lmpPanel','    set lmpPanel = WUI_Window('),
              ('ChatCommand.j','EmojiPanel','    set EmojiPanel = WUI_Window('),
              ('EMOTES.j','EmojiPanel','    set EmojiPanel = BlzCreateFrameByType("BACKDROP", "WOSEmoteWheel"'),
              ('UI_CAREER.j','WCS_Main','    set WCS_Main = WUI_Window('),
              ('Scoreboard.j','WOS_STATS_Main','    set WOS_STATS_Main = BlzCreateFrameByType("FRAME", "WOSScoreboardWindow"')]
    for name, frame, prefix in covers:
        path = folder/name
        s = path.read_text(encoding='utf-8-sig')
        lines = [line for line in s.splitlines() if line.startswith(prefix)]
        if len(lines) != 1:
            raise ValueError('Unexpected covering-panel creation: '+name)
        updates[path] = once(s, lines[0], lines[0]+'\n    call WUI_RegisterRangeCover('+frame+')')
    for path, text in updates.items():
        path.write_bytes(text.replace('\n', '\r\n').encode('utf-8'))
    (folder/'AbilityRangePreview.j').write_bytes((ROOT/'test_map/ability_range/AbilityRangePreview.j').read_bytes().replace(b'\r\n', b'\n').replace(b'\n', b'\r\n'))
    settings = workspace/'triggers/trigger-settings.json'
    data = json.loads(settings.read_text(encoding='utf-8-sig'))
    data['triggers']['WOS_Start/AbilityRangePreview.j'] = True
    settings.write_bytes((json.dumps(data, ensure_ascii=False, indent=2)+'\n').replace('\n', '\r\n').encode('utf-8'))
    print('Installed TEST-only range source/hooks:', workspace)
    # The current candidate includes instant AoE and a saved hold binding.
    from prepare_ability_range_hold_test import install as install_hold
    install_hold(workspace)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--workspace', type=Path, required=True)
    install(parser.parse_args().workspace)
