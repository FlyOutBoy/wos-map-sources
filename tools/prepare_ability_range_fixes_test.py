"""TEST-only follow-up: picker focus, repeat swaps, HUD requirements and -killme."""
from pathlib import Path
import json
import re
from prepare_ability_range_test import ROOT, once


def picker(s):
    start=s.index('function OnClick takes')
    end=s.index('endfunction',start)+len('endfunction')
    body=s[start:end]
    if body.count('call WUI_ReleaseClickFocus()') != 7:
        raise ValueError('Unexpected picker click exits')
    body=body.replace('call WUI_ReleaseClickFocus()','call WOS_FinishPickerClick()')
    helper='''function WOS_FinishPickerClick takes nothing returns nothing
    local framehandle frame = BlzGetTriggerFrame()
    if frame == FRAME_Pick[2] or frame == FRAME_Pick[3] then
        call WUI_ResetClickedButtonFocus()
    else
        call WUI_ReleaseClickFocus()
    endif
    set frame = null
endfunction

'''
    s=s[:start]+helper+body+s[end:]
    old='''            if PickedOnce[pid] == 1 then
                call BlzFrameSetEnable(FRAME_Repick[pid], true)
                call BlzFrameSetVisible(FRAME_Repick[pid], true)
                if canShowSwap then
                    call BlzFrameSetEnable(FRAME_Swap[pid], true)
                    call BlzFrameSetVisible(FRAME_Swap[pid], true)
                endif
            endif'''
    return once(s,old,'''            if PickedOnce[pid] == 1 then
                call BlzFrameSetEnable(FRAME_Repick[pid], true)
                call BlzFrameSetVisible(FRAME_Repick[pid], true)
            endif
            if canShowSwap and (PickedOnce[pid] == 1 or TestMode) then
                call BlzFrameSetEnable(FRAME_Swap[pid], true)
                call BlzFrameSetVisible(FRAME_Swap[pid], true)
            endif''')


def icons(s):
    s=once(s,'if not CaptainDraftPreRoundUnlimitedSwap then','if not CaptainDraftPreRoundUnlimitedSwap and not TestMode then')
    return once(s,'        if CaptainDraftPreRoundUnlimitedSwap then\n            if GetLocalPlayer() == p then',
                  '        if CaptainDraftPreRoundUnlimitedSwap or TestMode then\n            if GetLocalPlayer() == p then')


def requirements(s):
    s=kyoraku_finale(s)
    for slot,old,new in [('F','TakeshiF_ID','TakeshiG_ID'),('F','TakeshiGF_ID','TakeshiG2_ID'),('G','TakeshiG_ID','TakeshiF_ID'),('G','TakeshiG2_ID','TakeshiGF_ID')]:
        # Simultaneous replacement avoids changing the newly swapped lines.
        s=once(s,f'AHUI_SLOT_{slot}, {old})',f'AHUI_SLOT_{slot}, __SWAP_{new})')
    s=s.replace('__SWAP_','')
    s=once(s,'private function AHUI_IsActiveSlotCandidate takes','''private function AHUI_RequirementLocked takes unit hero, integer abilityId returns boolean
    if abilityId == TakeshiG_ID then
        return LoadReal(hs, GetHandleId(hero), StringHash("takeshi dmg")) < TakeshiG_TakenDamageToEnter
    endif
    return false
endfunction

private function AHUI_IsActiveSlotCandidate takes''')
    s=once(s,'    if not AHUI_IsAbilityAvailable(owner, abilityId) then',
                  '    if AHUI_RequirementLocked(whichHero, abilityId) or not AHUI_IsAbilityAvailable(owner, abilityId) then')
    if s.count('AHUI_PassiveLocked(AHUI_SelectedHero[pid], slot, abilityId)') != 2:
        raise ValueError('Unexpected HUD availability gates')
    return s.replace('AHUI_PassiveLocked(AHUI_SelectedHero[pid], slot, abilityId)',
                     '(AHUI_PassiveLocked(AHUI_SelectedHero[pid], slot, abilityId) or AHUI_RequirementLocked(AHUI_SelectedHero[pid], abilityId))')


def shop(s):
    # Every WUI_Place / absolute-point call in this owner belongs to the shop.
    # Bottom HUD previews use WUI_PlaceShift and keep their own coordinates.
    s=s.replace('call WUI_Place(', 'call Shop_Place(').replace('call BlzFrameSetAbsPoint(', 'call Shop_SetAbsPoint(')
    s=once(s,'    set QB_Right = right','    call Shop_Recenter()\n    set QB_Right = right')
    start=s.index('function QB_BeginRightDrag takes');end=s.index('endfunction',start)
    body=once(s[start:end],'    local integer k\n','    local integer k\n    set x = x - Shop_Shift()\n')
    s=s[:start]+body+s[end:]
    for name in ('QB_UpdateDragTarget','QB_FinishDrag'):
        start=s.index('function '+name+' takes');end=s.index('endfunction',start)
        body=s[start:end].replace('BlzPixelToFrameX(BlzGetMouseScreenPosX())','(BlzPixelToFrameX(BlzGetMouseScreenPosX()) - Shop_Shift())')
        s=s[:start]+body+s[end:]
    helper=(ROOT/'test_map/ability_range/ShopCentering.j').read_text(encoding='utf-8-sig').replace('private ','')
    start=re.search(r'(?m)^function ',s).start()
    return s[:start]+helper+'\n'+s[start:]


def kyoraku_finale(s):
    # The third-act finisher has hotkey G and replaces Skip Stage there.
    s=once(s,'        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_T, KyorakuT4_ID)\n','')
    return once(s,'        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, KyorakuTSkip_ID)',
                  '        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, KyorakuTSkip_ID)\n        call AHUI_AddHeroAbility(whichHero, AHUI_SLOT_G, KyorakuT4_ID)')


def harribel_meter(s):
    # Legacy absolute child anchors run after WUI_HeroMeter and tear its layout
    # apart. Keep the shared dock as the sole geometry owner on create AND reuse.
    pattern=r'(?m)^\s*call BlzFrameSetAbsPoint\(frame2_pas[1-6]\[k2\], FRAMEPOINT_CENTER, [^\n]+\)\n'
    s,count=re.subn(pattern,'',s)
    if count != 6:raise ValueError('Unexpected Harribel morph meter anchors')
    anchor='                            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e"), 1)'
    return once(s,anchor,'                            call WUI_RefreshDocks()\n'+anchor)


def bindings(s):
    helper='''private function WUI_BindingConflict takes integer pid, integer channel, integer slot, oskeytype key, string name returns string
    local integer other = 0
    local string title
    loop
        exitwhen other >= WUI_HOTKEY_CHANNELS
        if other != channel and WUI_HotkeyKey[other * 16 + pid] == key then
            if other == WUI_HOTKEY_SHOP then
                set title = "Shop"
            elseif other == WUI_HOTKEY_PING then
                set title = "Pings"
            elseif other == WUI_HOTKEY_EMOTE then
                set title = "Emotes"
            elseif other == WUI_HOTKEY_STATS then
                set title = "Stats"
            else
                set title = "Stats Clear/Load"
            endif
            return name + " is already used by " + title
        endif
        set other = other + 1
    endloop
    set other = 0
    loop
        exitwhen other >= WUI_SLOT_KEYS
        if other != slot then
            if WUI_SlotKey[pid * WUI_SLOT_KEYS + other] == key then
                return name + " is already used by skill/item slot " + I2S(other + 1)
            elseif other < 7 and name == SubString("QWERTFG", other, other + 1) then
                return name + " is already used by a stock skill"
            endif
        endif
        set other = other + 1
    endloop
    return ""
endfunction

'''
    s=once(s,'private function WUI_OnCapture takes',helper+'private function WUI_OnCapture takes')
    start=s.index('private function WUI_OnCapture takes');end=s.index('endfunction',start)
    body=once(s[start:end],'    local string name = ""','    local string name = ""\n    local string conflict = ""')
    begin=body.index('            set WUI_HotkeyKey[channel * 16 + pid] = key')
    finish=body.index('\n        endif',begin)
    original=body[begin:finish]
    body=body[:begin]+'''            set conflict = WUI_BindingConflict(pid, channel, -1, key, name)
            if conflict == "" then
'''+original+'''
            else
                call DisplayTimedTextToPlayer(p, 0, 0, 4.00, "|cffff7a6aKey taken: " + conflict + ". Hotkey unchanged.|r")
            endif'''+body[finish:]
    s=s[:start]+body+s[end:]
    start=s.index('private function WUI_SlotKeyConflict takes');end=s.index('endfunction',start)
    body=once(s[start:end],'    local integer other = 0','''    local integer other = 0
    local string conflict = WUI_BindingConflict(pid, -1, slot, key, name)
    if conflict != "" then
        return conflict
    endif''')
    s=s[:start]+body+s[end:]
    return once(s,'function WUI_SavedSettingsString takes','''// Validate the complete restored packet, not each record against temporary
// defaults: a valid F3/F4 permutation must survive loading.
function WUI_ValidateRestoredHotkeys takes player p returns nothing
    local integer pid = GetPlayerId(p)
    local integer channel = 0
    local oskeytype key
    loop
        exitwhen channel >= WUI_HOTKEY_CHANNELS
        set key = WUI_HotkeyKey[channel * 16 + pid]
        if key != null and WUI_BindingConflict(pid, channel, -1, key, WUI_HotkeyName[channel * 16 + pid]) != "" then
            call WUI_ResetHotkeys(p)
            call DisplayTimedTextToPlayer(p, 0, 0, 6.00, "|cffff7a6aDuplicate hotkeys in saved settings. Hotkeys reset to defaults; other settings kept.|r")
            set key = null
            return
        endif
        set channel = channel + 1
    endloop
    set key = null
endfunction

function WUI_SavedSettingsString takes''')


def validate_loaded_bindings(s):
    return once(s,'    if GetLocalPlayer() == p and data == ss_SettingsLastPacket and data != "" then',
                  '    call WUI_ValidateRestoredHotkeys(p)\n    if GetLocalPlayer() == p and data == ss_SettingsLastPacket and data != "" then')


def statistics_keys(s):
    start=s.index('private function WOS_STATS_OnData takes');end=s.index('endfunction',start)
    body=once(s[start:end],'    if BlzGetTriggerFrame() == null then',
                  '    if GetTriggeringTrigger() == WOS_STATS_DataKeys then')
    body=re.sub(r'            call WUI_(?:ResetClickedButtonFocus|ReleaseClickFocus)\(\)\n            return','            return',body)
    body=re.sub(r'    call WUI_(?:ResetClickedButtonFocus|ReleaseClickFocus)\(\)', '''    if GetTriggeringTrigger() == WOS_STATS_DataTrigger then
        call WUI_ResetClickedButtonFocus()
    endif''',body)
    return s[:start]+body+s[end:]


def attack_help(s):
    return once(s, 'set UNITSTAT_Help[0] = "|cffd5b876ATTACK|r|nDamage: " + damage',
                'set UNITSTAT_Help[0] = "|cffd5b876ATTACK|r|nDamage: " + damage + "|nEach point of the primary attribute|ngrants +1 Attack Damage."')


def install(workspace):
    workspace=workspace.resolve()
    if workspace == ROOT or ROOT in workspace.parents or workspace in ROOT.parents:
        raise ValueError('Isolated TEST workspace required')
    cfg=json.loads((workspace/'.vscode/wos-build.json').read_text(encoding='utf-8-sig'))
    if workspace.parent not in Path(cfg['mainMap']).resolve().parents:
        raise ValueError('Profile targets production MAIN')
    changes={}
    for name,fn in [('WoS_Pick_Init.j',picker),('WoS_Hero_Icons_Init.j',icons),('ShowCD.j',requirements),('WoS_Shop_Init.j',shop),('WOSUI.j',bindings),('Scoreboard.j',statistics_keys),('DefaultArmorChangeStable_Copy.j',attack_help),('SaveLoad.j',validate_loaded_bindings)]:
        p=workspace/'triggers/WOS_Start'/name
        changes[p]=fn(p.read_text(encoding='utf-8-sig'))
    for name in ('EnterBase','LeavesBase'):
        p=workspace/f'triggers/Systems/{name}.j'
        changes[p]=once(p.read_text(encoding='utf-8-sig'),"call UnitRemoveAbility(c,'BTLF')","call KM_Cancel(c)\ncall UnitRemoveAbility(c,'BTLF')")
    changes[workspace/'triggers/Systems/Killme.j']=(ROOT/'test_map/ability_range/KillmeProgress.j').read_text(encoding='utf-8-sig')
    p=workspace/'triggers/Heroes/Harribel.j'
    changes[p]=harribel_meter(p.read_text(encoding='utf-8-sig'))
    for p,s in changes.items():p.write_bytes(s.replace('\n','\r\n').encode('utf-8'))
    print('TEST picker, repeat swaps, HUD requirements, centered shop and killme installed')
