library HeroUnitPanelStats initializer HeroUnitPanelStats_Init requires heroicon, WOSUI, TasAbilityChargeBox, EmojiStandalone

// Existing selected-unit overlay migrated into the compact HUD. All combat data
// comes from the map's existing functions or the stock engine panel.
globals
    private group UNITSTAT_SelectedGroup = null
    private timer UNITSTAT_UpdateTimer = null
    private framehandle UNITSTAT_Root = null
    private framehandle UNITSTAT_Portrait = null
    private framehandle UNITSTAT_Level = null
    private framehandle UNITSTAT_LevelBadge = null
    private framehandle array UNITSTAT_Widget
    // Stats column modes: 1 = column A only, 2 = A+B, 3 = A+B+C (penetration,
    // shield penetration, regeneration). The HUD right of the stats moves.
    private framehandle UNITSTAT_DividerB = null
    private framehandle UNITSTAT_DividerC = null
    private framehandle UNITSTAT_ModeButton = null
    private real array UNITSTAT_BaseWidth
    private framehandle array UNITSTAT_Value
    private string array UNITSTAT_Help
    private framehandle array UNITSTAT_Bar
    private framehandle array UNITSTAT_BarText
    private framehandle array UNITSTAT_Regen
    private framehandle UNITSTAT_Tooltip = null
    private framehandle UNITSTAT_TooltipText = null
    // Checkpoint 24: left edge of every stat row (tooltips sit above the HUD).
    private real array UNITSTAT_WidgetLeft
    private real array UNITSTAT_WidgetY
    private real array UNITSTAT_WidgetWidth
    private real array UNITSTAT_WidgetHeight
    private framehandle UNITSTAT_Lock = null
    private framehandle UNITSTAT_Gold = null
    private framehandle UNITSTAT_EngineDamage = null
    private framehandle UNITSTAT_Shop = null
    private framehandle UNITSTAT_Emotes = null
    private integer UNITSTAT_TipLayout = -1
    private integer UNITSTAT_TipLines = -1
    private string UNITSTAT_TipText = ""
    private integer UNITSTAT_Hover = -1
    private unit UNITSTAT_LastSelected = null
    private integer UNITSTAT_LastType = 0
    private boolean UNITSTAT_Compact = false
    // Checkpoint 21: gold underline under the primary attribute value.
    private framehandle array UNITSTAT_PrimaryMark
    private trigger UNITSTAT_PortraitClick = null
    // Checkpoint 22: the whole portrait + level plate is one click target
    // (only its lower half reacted before); voice toggle like the picker's.
    private framehandle UNITSTAT_PortraitHit = null
    private framehandle UNITSTAT_VoiceToggle = null
    private boolean array UNITSTAT_VoiceOn
    private framehandle UNITSTAT_PortraitTip = null
    private framehandle UNITSTAT_PortraitTipText = null
    // Checkpoint 26d: last selected unit per player from the synced selection
    // events, so the portrait voice is the selected hero's on every client.
    private unit array UNITSTAT_VoiceUnit
    private trigger UNITSTAT_ShopKeys = null
    private trigger UNITSTAT_VoiceSelect = null
    private trigger UNITSTAT_VoiceDeselect = null
    // Gameplay constants in MAIN war3mapMisc.txt. Regeneration and attack
    // speed below use the live Systems1 coefficients instead.
    private constant real UNITSTAT_HP_PER_STR = 35.0
    private constant real UNITSTAT_MP_PER_INT = 10.0
    private constant real UNITSTAT_MS_PER_AGI = 1.0
endglobals

private function UNITSTAT_OnSelectVoice takes nothing returns nothing
    set UNITSTAT_VoiceUnit[GetPlayerId(GetTriggerPlayer())] = GetTriggerUnit()
endfunction

private function UNITSTAT_OnDeselectVoice takes nothing returns nothing
    local integer pid = GetPlayerId(GetTriggerPlayer())
    if UNITSTAT_VoiceUnit[pid] == GetTriggerUnit() then
        set UNITSTAT_VoiceUnit[pid] = null
    endif
endfunction

private function UNITSTAT_ToolbarClick takes nothing returns nothing
    if BlzGetTriggerFrame() == UNITSTAT_Shop then
        call WOS_ToggleShop.evaluate(GetTriggerPlayer())
    else
        call Emoji_ToggleMenu(GetTriggerPlayer())
    endif
    if GetLocalPlayer() == GetTriggerPlayer() then
        call BlzFrameSetEnable(BlzGetTriggerFrame(), false)
        call BlzFrameSetEnable(BlzGetTriggerFrame(), true)
    endif
endfunction

// Synced key-up of the player's shop hotkey (stale keys are filtered by WOSUI).
private function UNITSTAT_OnShopKey takes nothing returns nothing
    local player p = GetTriggerPlayer()
    if BlzGetTriggerPlayerKey() == WUI_GetHotkey(WUI_HOTKEY_SHOP, GetPlayerId(p)) then
        call WOS_ToggleShop.evaluate(p)
    endif
    set p = null
endfunction

private function UNITSTAT_CreateToolbar takes nothing returns nothing
    local trigger clicks = CreateTrigger()
    local framehandle icon
    local framehandle text
    set UNITSTAT_Shop = BlzCreateFrameByType("BUTTON", "WOSShopToolbar", WUI_GetRoot(), "", 0)
    call WUI_PlaceToolbar(UNITSTAT_Shop, 0, 0)
    set icon = BlzCreateFrameByType("BACKDROP", "WOSShopToolbarIcon", UNITSTAT_Shop, "", 0)
    call BlzFrameSetAllPoints(icon, UNITSTAT_Shop)
    call BlzFrameSetTexture(icon, "UI\\WOS\\toolbar-shop.tga", 0, true)
    call BlzFrameSetEnable(icon, false)
    call WUI_Tooltip(UNITSTAT_Shop, "SHOP|nOpen or close your current shop tab.|nClick the key badge to rebind.")
    // Checkpoint 27: rebindable shop key (was the Shop Key button + Tab/I/B).
    set UNITSTAT_ShopKeys = CreateTrigger()
    call TriggerAddAction(UNITSTAT_ShopKeys, function UNITSTAT_OnShopKey)
    call WUI_RegisterHotkeyEx(WUI_HOTKEY_SHOP, UNITSTAT_ShopKeys, OSKEY_TAB, "TAB", false, UNITSTAT_Shop, WUI_GetRoot(), true)
    set UNITSTAT_Emotes = BlzCreateFrameByType("BUTTON", "WOSEmotesToolbar", WUI_GetRoot(), "", 0)
    call WUI_PlaceToolbar(UNITSTAT_Emotes, 2, 0)
    set icon = BlzCreateFrameByType("BACKDROP", "WOSEmotesToolbarIcon", UNITSTAT_Emotes, "", 0)
    call BlzFrameSetAllPoints(icon, UNITSTAT_Emotes)
    call BlzFrameSetTexture(icon, "UI\\WOS\\toolbar-emotes.tga", 0, true)
    call BlzFrameSetEnable(icon, false)
    // The key badge (rebindable) is drawn by WOSUI over the corner.
    call Emoji_AttachHotkeyBadge(UNITSTAT_Emotes)
    call WUI_Tooltip(UNITSTAT_Emotes, "EMOTES|nHold the key: wheel at the cursor, release on an emote.|nClick: wheel in the centre.")
    call BlzTriggerRegisterFrameEvent(clicks, UNITSTAT_Shop, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(clicks, UNITSTAT_Emotes, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(clicks, function UNITSTAT_ToolbarClick)
    set icon = null
    set text = null
    set clicks = null
endfunction

private function UNITSTAT_Text takes string name, framehandle parent, real x, real y, real width returns framehandle
    local framehandle text = BlzCreateFrameByType("TEXT", name, parent, "", 0)
    call WUI_Place(text, x, y, width, 0.012)
    call BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(text, 0.80)
    call BlzFrameSetEnable(text, false)
    return text
endfunction

// One stats row: icon on the left, left-aligned value. The whole row is the
// hover target for its explanatory tooltip.
private function UNITSTAT_WidgetCreate takes integer index, string texture, real x, real y, real width, trigger events returns nothing
    local framehandle icon
    set UNITSTAT_Widget[index] = BlzCreateFrameByType("BUTTON", "WOSStatWidget", UNITSTAT_Root, "", index)
    set UNITSTAT_WidgetLeft[index] = x - width * 0.50
    set UNITSTAT_WidgetY[index] = y
    set UNITSTAT_WidgetWidth[index] = width
    set UNITSTAT_WidgetHeight[index] = 0.0125
    call WUI_PlaceShiftLeft(UNITSTAT_Widget[index], x, y, width, 0.0125)
    set icon = BlzCreateFrameByType("BACKDROP", "WOSStatIcon", UNITSTAT_Widget[index], "", index)
    call BlzFrameSetPoint(icon, FRAMEPOINT_LEFT, UNITSTAT_Widget[index], FRAMEPOINT_LEFT, 0.001, 0.00)
    call BlzFrameSetSize(icon, 0.0105, 0.0105)
    call BlzFrameSetTexture(icon, texture, 0, true)
    call BlzFrameSetEnable(icon, false)
    set UNITSTAT_Value[index] = BlzCreateFrameByType("TEXT", "WOSStatValue", UNITSTAT_Widget[index], "", index)
    call BlzFrameSetPoint(UNITSTAT_Value[index], FRAMEPOINT_LEFT, UNITSTAT_Widget[index], FRAMEPOINT_LEFT, 0.0145, 0.00)
    // Never narrower than "-100%" so three-digit values do not wrap.
    call BlzFrameSetSize(UNITSTAT_Value[index], RMaxBJ(width - 0.0150, 0.030), 0.012)
    call BlzFrameSetTextAlignment(UNITSTAT_Value[index], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_LEFT)
    call BlzFrameSetScale(UNITSTAT_Value[index], 0.76)
    call BlzFrameSetEnable(UNITSTAT_Value[index], false)
    set icon = null
endfunction

// Short percent: one decimal below 100, whole numbers from 100 on
// ("4.1%", "17.5%", "100%", "-250%") so the narrow columns always fit.
private function UNITSTAT_Pct takes real value returns string
    if value >= 99.95 then
        return I2S(R2I(value + 0.5)) + "%"
    elseif value <= -99.95 then
        return I2S(R2I(value - 0.5)) + "%"
    endif
    return R2SW(value, 1, 1) + "%"
endfunction

// Damage bonus: green when positive, red when negative, no sign prefix.
private function UNITSTAT_Signed takes real value returns string
    if value > 0.05 then
        return "|cff7cd67c" + UNITSTAT_Pct(value) + "|r"
    elseif value < -0.05 then
        return "|cffff6b5e" + UNITSTAT_Pct(value) + "|r"
    endif
    return "|cff8d96a30%|r"
endfunction

// "base +bonus": white base, green item/buff bonus; the primary stat is gold.
private function UNITSTAT_StatText takes integer total, integer base, boolean primary returns string
    local string color = "|cffe1e5eb"
    local string result
    if primary then
        set color = WUI_GOLD
    endif
    set result = color + I2S(base) + "|r"
    if total > base then
        set result = result + " |cff7cd67c+" + I2S(total - base) + "|r"
    elseif total < base then
        set result = result + " |cffff6b5e-" + I2S(base - total) + "|r"
    endif
    return result
endfunction

// Armor has diminishing returns; the marginal resistance gain is not a
// constant percentage. Match DamageBlock's nonnegative armor/effectiveness.
private function UNITSTAT_ArmorResistancePerAgi takes unit hero returns real
    local real armor = BlzGetUnitArmor(hero)
    local real effectiveness = RMaxBJ(0.0, ARMOR_EFFECTIVENESS_PERCENT) / 100.0
    local real current = RMaxBJ(0.0, armor) * effectiveness
    local real increased = RMaxBJ(0.0, armor + WOS_PHYS_RES_PER_AGI) * effectiveness
    return 100.0 * (increased / (100.0 + increased) - current / (100.0 + current))
endfunction

private function UNITSTAT_AttributeHelp takes unit hero, integer index returns string
    local integer total
    local integer base
    local string title
    local string benefit
    if index == 3 then
        set total = GetHeroStr(hero, true)
        set base = GetHeroStr(hero, false)
        set title = "|cffff8a83STRENGTH|r"
        set benefit = "|nPer 1 Strength:|nHP: +" + R2SW(UNITSTAT_HP_PER_STR, 0, 0) + "|nHP regen: +" + R2SW(str_hpregen, 0, 2) + "/s"
    elseif index == 4 then
        set total = GetHeroAgi(hero, true)
        set base = GetHeroAgi(hero, false)
        set title = "|cff7cd67cAGILITY|r"
        set benefit = "|nPer 1 Agility:|nAttack speed: +" + R2SW(100.0 * agi_as, 0, 2) + "%|nMove speed: +" + R2SW(UNITSTAT_MS_PER_AGI, 0, 2) + "|nArmor: +" + R2SW(WOS_ARMOR_PER_AGI, 0, 2) + "|nPhysical resistance from armor:|n+" + R2SW(UNITSTAT_ArmorResistancePerAgi(hero), 0, 3) + " percentage points|n(at current armor)"
    else
        set total = GetHeroInt(hero, true)
        set base = GetHeroInt(hero, false)
        set title = "|cff7caefaINTELLIGENCE|r"
        set benefit = "|nPer 1 Intelligence:|nMana: +" + R2SW(UNITSTAT_MP_PER_INT, 0, 0) + "|nMana regen: +" + R2SW(int_mpregen, 0, 2) + "/s|nMagic resistance: like " + R2SW(WOS_MAG_RES_PER_INT, 0, 2) + " armor"
    endif
    return title + "|nTotal: " + I2S(total) + "|nBase (level): " + I2S(base) + "|nBonus (items/effects): " + I2S(total - base) + benefit
endfunction

private function UNITSTAT_UpdateGold takes nothing returns nothing
    local player viewer = GetLocalPlayer()
    local integer current = GetPlayerState(viewer, PLAYER_STATE_RESOURCE_GOLD)
    local integer next = GetPlayerState(viewer, PLAYER_STATE_RESOURCE_LUMBER)
    call WUI_SetText(UNITSTAT_Gold, "|cffd5b876" + I2S(current) + "|r |cff00ff00+" + I2S(next) + "|r")
    set UNITSTAT_Help[7] = "|cffd5b876GOLD|r|nCurrent: " + I2S(current) + "|nNext round: " + I2S(next)
    set viewer = null
endfunction

// Tooltip box hugs its text: width by content kind, height by line count,
// placed above the hovered control instead of a fixed oversized panel.
private function UNITSTAT_ShowTooltip takes integer index returns nothing
    local string text = UNITSTAT_Help[index]
    local integer lines = 1
    local integer i = 0
    local integer length = StringLength(text)
    local real width = 0.190
    loop
        exitwhen i >= length - 1
        if SubString(text, i, i + 2) == "|n" then
            set lines = lines + 1
        endif
        set i = i + 1
    endloop
    if index == 6 then
        set width = 0.120
    elseif index == 7 then
        set width = 0.120
    elseif index >= 3 and index <= 5 then
        set width = 0.225
    elseif index >= 8 then
        set width = 0.150
    endif
    if text != UNITSTAT_TipText then
        set UNITSTAT_TipText = text
        call WUI_SetText(UNITSTAT_TooltipText, text)
    endif
    if UNITSTAT_TipLayout != index or UNITSTAT_TipLines != lines then
    set UNITSTAT_TipLayout = index
    set UNITSTAT_TipLines = lines
    call BlzFrameSetSize(UNITSTAT_Tooltip, width, 0.014 + I2R(lines) * 0.0100)
    // Text block centred in its box (it used to hug the top edge).
    call BlzFrameSetSize(UNITSTAT_TooltipText, (width - 0.014) / 0.80, (I2R(lines) * 0.0100 + 0.002) / 0.80)
    call BlzFrameClearAllPoints(UNITSTAT_TooltipText)
    call BlzFrameSetPoint(UNITSTAT_TooltipText, FRAMEPOINT_CENTER, UNITSTAT_Tooltip, FRAMEPOINT_CENTER, 0.000, 0.000)
    call BlzFrameSetTextAlignment(UNITSTAT_TooltipText, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameClearAllPoints(UNITSTAT_Tooltip)
    if UNITSTAT_WidgetLeft[index] > 0.00 then
        // Checkpoint 24: always just above the top edge of the big lower HUD.
        if index == 7 then
            call BlzFrameSetAbsPoint(UNITSTAT_Tooltip, FRAMEPOINT_BOTTOMLEFT, UNITSTAT_WidgetLeft[index], WUI_CHASSIS_TOP + 0.004)
        else
            call BlzFrameSetAbsPoint(UNITSTAT_Tooltip, FRAMEPOINT_BOTTOMLEFT, UNITSTAT_WidgetLeft[index] + WUI_HudLeft, WUI_CHASSIS_TOP + 0.004)
        endif
    else
        call BlzFrameSetPoint(UNITSTAT_Tooltip, FRAMEPOINT_BOTTOMLEFT, UNITSTAT_Widget[index], FRAMEPOINT_TOPLEFT, 0.000, 0.006)
    endif
    endif
    call BlzFrameSetVisible(UNITSTAT_Tooltip, true)
    set text = null
endfunction

// Click on the portrait: with the voice toggle ON the player's own hero says
// its pick lines in turn (sound is local); otherwise the clicking player's
// camera jumps to the selected unit (local camera only).
private function UNITSTAT_OnPortraitClick takes nothing returns nothing
    local unit selected = null
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    // Voice (if on) and camera both happen on every click.
    // Checkpoint 26d: the voice of the selected hero (ally or enemy), else
    // the player's own hero.
    if UNITSTAT_VoiceOn[pid] then
        set selected = UNITSTAT_VoiceUnit[pid]
        if selected != null and IsUnitType(selected, UNIT_TYPE_HERO) and not IsUnitIllusion(selected) and WOS_HeroVoicePath.evaluate(GetUnitTypeId(selected), 0) != "" then
            call WOS_PlayNextHeroVoice.evaluate(p, GetUnitTypeId(selected))
        elseif Hero[pid] != null then
            call WOS_PlayNextHeroVoice.evaluate(p, GetUnitTypeId(Hero[pid]))
        endif
        set selected = null
    endif
    set p = null
    if GetLocalPlayer() == GetTriggerPlayer() then
        call GroupClear(UNITSTAT_SelectedGroup)
        call GroupEnumUnitsSelected(UNITSTAT_SelectedGroup, GetLocalPlayer(), null)
        set selected = FirstOfGroup(UNITSTAT_SelectedGroup)
        if selected == null then
            set selected = Hero[GetPlayerId(GetLocalPlayer())]
        endif
        if selected != null then
            call PanCameraToTimed(GetUnitX(selected), GetUnitY(selected), 0.15)
        endif
        call BlzFrameSetFocus(BlzGetTriggerFrame(), false)
        call BlzFrameSetVisible(UNITSTAT_PortraitTip, false)
        set UNITSTAT_Hover = -1
        call BlzFrameSetVisible(UNITSTAT_Tooltip, false)
    endif
    set selected = null
endfunction

// Local: shows the columns of the current mode and moves the rest of the HUD.
// Runs only when the mode button is clicked (and once at creation).
private function UNITSTAT_ApplyMode takes nothing returns nothing
    local integer i = 8
    local boolean showB = WUI_HudMode >= 2
    local boolean showC = WUI_HudMode >= 3
    loop
        exitwhen i > 17
        if UNITSTAT_BaseWidth[i] == 0.00 then
            set UNITSTAT_BaseWidth[i] = UNITSTAT_WidgetWidth[i]
        endif
        if (i <= 12 and showB) or (i >= 13 and showC) then
            call BlzFrameSetVisible(UNITSTAT_Widget[i], true)
            set UNITSTAT_WidgetWidth[i] = UNITSTAT_BaseWidth[i]
        else
            call BlzFrameSetVisible(UNITSTAT_Widget[i], false)
            set UNITSTAT_WidgetWidth[i] = 0.00
        endif
        set i = i + 1
    endloop
    call BlzFrameSetVisible(UNITSTAT_DividerB, showB)
    call BlzFrameSetVisible(UNITSTAT_DividerC, showC)
    if WUI_HudMode == 1 then
        call WUI_SetHud(-WUI_STATS_COLUMN, 0.00)
    elseif WUI_HudMode == 3 then
        call WUI_SetHud(WUI_STATS_COLUMN, 0.00)
    else
        call WUI_SetHud(0.00, 0.00)
    endif
    set UNITSTAT_WidgetLeft[7] = 0.7325 + WUI_HudShift
    // One glyph per mode: 1, 2 or 3 stat columns.
    call WUI_SetToggleGlyph(UNITSTAT_ModeButton, "UI\\WOS\\glyph-cols" + I2S(WUI_HudMode) + ".tga")
endfunction

private function UNITSTAT_OnModeClick takes nothing returns nothing
    if GetLocalPlayer() == GetTriggerPlayer() then
        set WUI_HudMode = ModuloInteger(WUI_HudMode, 3) + 1
        call UNITSTAT_ApplyMode()
        call BlzFrameSetEnable(UNITSTAT_ModeButton, false)
        call BlzFrameSetEnable(UNITSTAT_ModeButton, true)
    endif
endfunction

// What the unit pierces right now: passive item penetration only; on-hit
// debuff items are listed in the tooltip (nothing is pierced before a hit).
private function UNITSTAT_UpdateColumnC takes unit u returns nothing
    local real phys = 0.00
    local real mag = 0.00
    local string physHelp = ""
    local string magHelp = ""
    local real hp = 0.00
    if HasCachedItem(u, 'I00J') > 0 then
        set phys = KanshoandBakuya_Decrease
        set physHelp = physHelp + "|nKansho & Bakuya: ignores " + R2SW(KanshoandBakuya_Decrease, 0, 0) + "% of the target's physical resistance."
    endif
    if HasCachedItem(u, 'I01M') > 0 then
        set physHelp = physHelp + "|nNichirin Sword Whip: on hit, -" + R2SW(Nichirin_Decrease, 0, 0) + "% physical resistance (debuff)."
    endif
    if HasCachedItem(u, 'I00R') > 0 then
        set mag = KazekageHat_Decrease
        set magHelp = magHelp + "|nKazekage Hat: ignores " + R2SW(KazekageHat_Decrease, 0, 0) + "% of the target's magical resistance."
    endif
    if HasCachedItem(u, 'I01L') > 0 then
        set magHelp = magHelp + "|nTrue Zangetsu: on hit, -" + R2SW(TrueZangetsu_Decrease, 0, 0) + "% magical resistance (debuff)."
    endif
    call WUI_SetText(UNITSTAT_Value[13], "|cffff8a83" + UNITSTAT_Pct(phys) + "|r")
    set UNITSTAT_Help[13] = "|cffff8a83PHYSICAL PENETRATION|r|nNow: " + R2SW(phys, 0, 0) + "%" + physHelp
    call WUI_SetText(UNITSTAT_Value[14], "|cff7caefa" + UNITSTAT_Pct(mag) + "|r")
    set UNITSTAT_Help[14] = "|cff7caefaMAGICAL PENETRATION|r|nNow: " + R2SW(mag, 0, 0) + "%" + magHelp
    // Preview: no minimum damage, no item charge / cooldown use, partial counts.
    set phys = GetShieldPiercePreview(u)
    call WUI_SetText(UNITSTAT_Value[15], "|cffe9cf8f" + UNITSTAT_Pct(phys) + "|r")
    set UNITSTAT_Help[15] = "|cffe9cf8fSHIELD PENETRATION|r|nNow: " + R2SW(phys, 0, 0) + "% of shield damage ignored|n(Lust / Envy / Wrath Sin, buffs; ready charges only)"
    // Heal amplification: no healing bonuses exist yet, heal-cut debuffs
    // (BlockRegen) show as a negative value.
    set hp = -100.00 * GetHealCut(u)
    call WUI_SetText(UNITSTAT_Value[16], UNITSTAT_Signed(hp))
    set UNITSTAT_Help[16] = "|cff7cd67cHP HEAL AMPLIFICATION|r|n" + R2SW(hp, 1, 0) + "% to healing received|nHeal-reduction debuffs lower it."
    call WUI_SetText(UNITSTAT_Value[17], UNITSTAT_Signed(0.00))
    set UNITSTAT_Help[17] = "|cff7caefaMP HEAL AMPLIFICATION|r|n0% to mana restored"
endfunction

// Saved settings were applied (ExecuteFunc from SaveLoad, all clients):
// voice state from WUI_VoiceOff, local HUD mode from WUI_HudMode.
function UNITSTAT_ApplySaved takes nothing returns nothing
    local integer i = 0
    loop
        exitwhen i >= bj_MAX_PLAYER_SLOTS
        set UNITSTAT_VoiceOn[i] = not WUI_VoiceOff[i]
        set i = i + 1
    endloop
    if UNITSTAT_VoiceToggle != null then
        call WUI_SetToggleState(UNITSTAT_VoiceToggle, UNITSTAT_VoiceOn[GetPlayerId(GetLocalPlayer())])
    endif
    if UNITSTAT_ModeButton != null then
        call UNITSTAT_ApplyMode()
    endif
endfunction

private function UNITSTAT_OnVoiceToggle takes nothing returns nothing
    local integer pid = GetPlayerId(GetTriggerPlayer())
    set UNITSTAT_VoiceOn[pid] = not UNITSTAT_VoiceOn[pid]
    set WUI_VoiceOff[pid] = not UNITSTAT_VoiceOn[pid]
    if GetLocalPlayer() == GetTriggerPlayer() then
        call WUI_SetToggleState(UNITSTAT_VoiceToggle, UNITSTAT_VoiceOn[pid])
    endif
endfunction

// Geometry polling cannot retain a button's clicked/focused hover state.
// No networked mouse-enter/leave callback changes tooltip layout under the cursor.
private function UNITSTAT_PollHover takes nothing returns nothing
    local real left
    local integer i = 0
    local real x = BlzPixelToFrameX(BlzGetMouseScreenPosX())
    local real y = BlzPixelToFrameY(BlzGetMouseScreenPosY())
    local boolean readable = BlzFrameIsVisible(UNITSTAT_Root)
    set UNITSTAT_Hover = -1
    loop
        exitwhen i >= 18
        set left = UNITSTAT_WidgetLeft[i]
        if i != 7 then
            set left = left + WUI_HudLeft
        endif
        if (i == 7 or readable) and UNITSTAT_WidgetWidth[i] > 0.0 and x >= left and x <= left + UNITSTAT_WidgetWidth[i] and y >= UNITSTAT_WidgetY[i] - UNITSTAT_WidgetHeight[i] * 0.5 and y <= UNITSTAT_WidgetY[i] + UNITSTAT_WidgetHeight[i] * 0.5 then
            set UNITSTAT_Hover = i
            exitwhen true
        endif
        set i = i + 1
    endloop
    call BlzFrameSetVisible(UNITSTAT_PortraitTip, UNITSTAT_Hover == 6)
    if UNITSTAT_Hover < 0 or UNITSTAT_Hover == 6 then
        call BlzFrameSetVisible(UNITSTAT_Tooltip, false)
    endif
endfunction

private function UNITSTAT_Update takes nothing returns nothing
    local unit selected
    local integer i = 0
    local integer heroType
    local boolean hero
    local boolean readable
    local boolean blocked
    local real maximum
    local real value
    local string damage
    local string color
    call GroupClear(UNITSTAT_SelectedGroup)
    call GroupEnumUnitsSelected(UNITSTAT_SelectedGroup, GetLocalPlayer(), null)
    set selected = FirstOfGroup(UNITSTAT_SelectedGroup)
    set readable = selected != null
    if readable then
        set readable = IsPlayerAlly(GetOwningPlayer(selected), GetLocalPlayer()) or IsUnitVisible(selected, GetLocalPlayer())
    endif
    call WUI_Show(UNITSTAT_Root, readable)
    if readable then
        call WUI_SetPortraitIcon(BlzGetAbilityIcon(GetUnitTypeId(selected)))
    endif
    call WUI_ShowNativePortrait(readable)
    call WUI_ShowHeroIndicator(readable and selected == Hero[GetPlayerId(GetLocalPlayer())] and GetHeroSkillPoints(selected) > 0)
    call WUI_ShowNativeBuffs(readable)
    call UNITSTAT_UpdateGold()
    call UNITSTAT_PollHover()
    if not readable then
        if UNITSTAT_Hover == 7 then
            call UNITSTAT_ShowTooltip(7)
        else
            call WUI_Show(UNITSTAT_Tooltip, false)
        endif
        set selected = null
        return
    endif
    set hero = IsUnitType(selected, UNIT_TYPE_HERO) or IsHeroUnitId(GetUnitTypeId(selected))
    set heroType = GetUnitTypeId(selected)
    if selected != UNITSTAT_LastSelected or heroType != UNITSTAT_LastType then
        call WUI_LayoutCommands(hero)
        set UNITSTAT_LastSelected = selected
        set UNITSTAT_LastType = heroType
    endif
    set UNITSTAT_Compact = hero
    if UNITSTAT_VoiceOn[GetPlayerId(GetLocalPlayer())] then
        set UNITSTAT_Help[6] = "|cffd5b876" + GetUnitName(selected) + "|r|n|cff9aa0a8Click: camera + hero voice|r"
    else
        set UNITSTAT_Help[6] = "|cffd5b876" + GetUnitName(selected) + "|r|n|cff9aa0a8Click: camera to this unit|r"
    endif
    // Engine-drawn tooltip (no hover events: those made the cursor stutter).
    call WUI_SetText(UNITSTAT_PortraitTipText, UNITSTAT_Help[6])
    // Outgoing damage bonus (same modifiers the damage system applies).
    set value = DamageCheck(selected, null, 100.00, 2) - 100.00
    call WUI_SetText(UNITSTAT_Value[8], UNITSTAT_Signed(value))
    set UNITSTAT_Help[8] = "|cffff8a73PHYSICAL DAMAGE BONUS|r|n" + R2SW(value, 1, 2) + "%|nExtra physical damage dealt (items, buffs, passives)."
    set value = DamageCheck(selected, null, 100.00, 1) - 100.00
    call WUI_SetText(UNITSTAT_Value[9], UNITSTAT_Signed(value))
    set UNITSTAT_Help[9] = "|cff7caefaMAGICAL DAMAGE BONUS|r|n" + R2SW(value, 1, 2) + "%|nExtra magical damage dealt (items, buffs, passives)."
    call WUI_Show(UNITSTAT_LevelBadge, hero)
    if hero then
        call WUI_SetText(UNITSTAT_Level, "|cff9aa0a8Lv|r |cfff0d690" + I2S(GetHeroLevel(selected)) + "|r")
    else
        call WUI_SetText(UNITSTAT_Level, "")
    endif
    if UNITSTAT_EngineDamage != null then
        set damage = BlzFrameGetText(UNITSTAT_EngineDamage)
    else
        set damage = R2SW(GetAttack(selected), 0, 0)
    endif
    call WUI_SetText(UNITSTAT_Value[0], "|cffe1e5eb" + damage + "|r")
    set UNITSTAT_Help[0] = "|cffd5b876ATTACK|r|nDamage: " + damage
    set blocked = GetUnitAbilityLevel(selected, 'Avul') > 0 and not CheckCoordsInRect(gg_rct_Base, GetUnitX(selected), GetUnitY(selected))
    if blocked then
        call WUI_SetText(UNITSTAT_Value[1], "|cffff4040Invul|r")
        call WUI_SetText(UNITSTAT_Value[2], "|cffff4040Invul|r")
    else
        call WUI_SetText(UNITSTAT_Value[1], "|cffff8a83" + UNITSTAT_Pct(GetPhysRes(selected)) + "|r")
        call WUI_SetText(UNITSTAT_Value[2], "|cff7caefa" + UNITSTAT_Pct(GetMagRes(selected)) + "|r")
    endif
    set UNITSTAT_Help[1] = "|cffff8a83PHYSICAL RESISTANCE|r|n" + R2SW(GetPhysRes(selected), 0, 2) + "%"
    set UNITSTAT_Help[2] = "|cff7caefaMAGICAL RESISTANCE|r|n" + R2SW(GetMagRes(selected), 0, 2) + "%"
    // Attack speed / move speed / range rows (heroes and units alike).
    set value = GetAS(selected)
    set maximum = BlzGetUnitWeaponRealField(selected, UNIT_WEAPON_RF_ATTACK_BASE_COOLDOWN, 0)
    call WUI_SetText(UNITSTAT_Value[10], "|cffe1e5eb" + R2SW(value, 0, 2) + "s|r")
    set UNITSTAT_Help[10] = "|cffffb36bATTACK SPEED|r|nAttack interval: " + R2SW(value, 0, 2) + "s|nBase interval: " + R2SW(maximum, 0, 2) + "s|nBonus speed: +" + I2S(R2I(100.00 * (maximum / RMaxBJ(0.01, value) - 1.00) + 0.5)) + "%"
    call WUI_SetText(UNITSTAT_Value[11], "|cffe1e5eb" + I2S(R2I(GetUnitMoveSpeed(selected))) + "|r")
    set UNITSTAT_Help[11] = "|cff7cd67cMOVE SPEED|r|nCurrent: " + I2S(R2I(GetUnitMoveSpeed(selected))) + "|nBase: " + I2S(R2I(GetUnitDefaultMoveSpeed(selected))) + "|nBonus: " + I2S(R2I(GetUnitMoveSpeed(selected) - GetUnitDefaultMoveSpeed(selected)))
    call WUI_SetText(UNITSTAT_Value[12], "|cffe1e5eb" + I2S(R2I(BlzGetUnitWeaponRealField(selected, UNIT_WEAPON_RF_ATTACK_RANGE, 0))) + "|r")
    set UNITSTAT_Help[12] = "|cff9fb0ffATTACK RANGE|r|n" + I2S(R2I(BlzGetUnitWeaponRealField(selected, UNIT_WEAPON_RF_ATTACK_RANGE, 0)))
    if WUI_HudMode >= 3 then
        call UNITSTAT_UpdateColumnC(selected)
    endif
    call WUI_Show(UNITSTAT_Lock, IsUnitPaused(selected))
    set i = 3
    loop
        exitwhen i >= 6
        call WUI_Show(UNITSTAT_Widget[i], hero)
        // Checkpoint 28: gold underline under the primary attribute (as in the
        // hero pick). Primary: 1 STR, 3 AGI, 2 INT; widgets 3 STR, 4 AGI, 5 INT.
        if i == 3 then
            call WUI_Show(UNITSTAT_PrimaryMark[0], hero and BlzGetUnitIntegerField(selected, UNIT_IF_PRIMARY_ATTRIBUTE) == 1)
        elseif i == 4 then
            call WUI_Show(UNITSTAT_PrimaryMark[1], hero and BlzGetUnitIntegerField(selected, UNIT_IF_PRIMARY_ATTRIBUTE) == 3)
        else
            call WUI_Show(UNITSTAT_PrimaryMark[2], hero and BlzGetUnitIntegerField(selected, UNIT_IF_PRIMARY_ATTRIBUTE) == 2)
        endif
        if i == 3 then
            call WUI_SetText(UNITSTAT_Value[i], UNITSTAT_StatText(GetHeroStr(selected, true), GetHeroStr(selected, false), GetMainStatStr(selected)))
        elseif i == 4 then
            call WUI_SetText(UNITSTAT_Value[i], UNITSTAT_StatText(GetHeroAgi(selected, true), GetHeroAgi(selected, false), GetMainStatAgi(selected)))
        else
            call WUI_SetText(UNITSTAT_Value[i], UNITSTAT_StatText(GetHeroInt(selected, true), GetHeroInt(selected, false), GetMainStatInt(selected)))
        endif
        set UNITSTAT_Help[i] = UNITSTAT_AttributeHelp(selected, i)
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= 2
        if i == 0 then
            set maximum = I2R(BlzGetUnitMaxHP(selected))
            set value = GetWidgetLife(selected)
            call WUI_SetText(UNITSTAT_Regen[i], "+" + R2SW(GetHpRegen(selected), 0, 1))
        else
            set maximum = I2R(BlzGetUnitMaxMana(selected))
            set value = GetUnitState(selected, UNIT_STATE_MANA)
            call WUI_SetText(UNITSTAT_Regen[i], "+" + R2SW(GetMpRegen(selected), 0, 1))
        endif
        call WUI_Show(UNITSTAT_Bar[i], maximum > 0.00)
        call WUI_Show(UNITSTAT_BarText[i], maximum > 0.00)
        call WUI_Show(UNITSTAT_Regen[i], maximum > 0.00)
        call WUI_SetValue(UNITSTAT_Bar[i], 100.00 * value / RMaxBJ(1.00, maximum))
        call WUI_SetText(UNITSTAT_BarText[i], I2S(R2I(value)) + " / " + I2S(R2I(maximum)))
        set i = i + 1
    endloop
    if UNITSTAT_Hover >= 0 and UNITSTAT_Hover != 6 then
        call UNITSTAT_ShowTooltip(UNITSTAT_Hover)
    endif
    set selected = null
endfunction

private function UNITSTAT_DelayedInit takes nothing returns nothing
    local timer initTimer = GetExpiredTimer()
    call DestroyTimer(initTimer)
    call WUI_StartNativeLayout()
    call WUI_BindHeroIndicator(UNITSTAT_Widget[6])
    set UNITSTAT_EngineDamage = BlzGetFrameByName("InfoPanelIconValue", 0)
    call WUI_LayoutCommands(false)
    set UNITSTAT_UpdateTimer = CreateTimer()
    call TimerStart(UNITSTAT_UpdateTimer, 0.10, true, function UNITSTAT_Update)
    set initTimer = null
endfunction

private function UNITSTAT_CreateUI takes nothing returns nothing
    local trigger events = CreateTrigger()
    local trigger voiceClick = null
    local framehandle back
    local integer i = 0
    local real y
    local timer initTimer = CreateTimer()
    // Checkpoint 26d: synced selection tracking for the portrait voice.
    set UNITSTAT_VoiceSelect = CreateTrigger()
    set UNITSTAT_VoiceDeselect = CreateTrigger()
    set i = 0
    loop
        exitwhen i >= bj_MAX_PLAYER_SLOTS
        call TriggerRegisterPlayerUnitEvent(UNITSTAT_VoiceSelect, Player(i), EVENT_PLAYER_UNIT_SELECTED, null)
        call TriggerRegisterPlayerUnitEvent(UNITSTAT_VoiceDeselect, Player(i), EVENT_PLAYER_UNIT_DESELECTED, null)
        set i = i + 1
    endloop
    call TriggerAddAction(UNITSTAT_VoiceSelect, function UNITSTAT_OnSelectVoice)
    call TriggerAddAction(UNITSTAT_VoiceDeselect, function UNITSTAT_OnDeselectVoice)
    set i = 0
    set UNITSTAT_SelectedGroup = CreateGroup()
    // The graphite chassis is native (WOSUI); this owner adds only presentation.
    set UNITSTAT_Root = WUI_Passive("WOSSelectedUnitHUD", WUI_GetRoot())
    // Portrait column: .160-.2285. Larger portrait with a flush gold frame and a
    // separate level plate below it (no badge covering the portrait art).
    set UNITSTAT_Widget[6] = BlzCreateFrameByType("BUTTON", "WOSSelectedUnitIcon", UNITSTAT_Root, "", 0)
    // Checkpoint 25: portrait a little lower, level plate right under it,
    // the hero voice toggle above it.
    call WUI_PlaceShiftLeft(UNITSTAT_Widget[6], 0.1945, 0.0550, 0.050, 0.050)
    set UNITSTAT_Portrait = WUI_BindNativePortrait(UNITSTAT_Widget[6])
    set back = WUI_GoldFrame("WOSSelectedUnitBorder", UNITSTAT_Widget[6], 0.0045, 0.0090)
    set UNITSTAT_LevelBadge = BlzCreateFrameByType("BACKDROP", "WOSSelectedUnitLevelBadge", UNITSTAT_Root, "", 0)
    call WUI_PlaceShiftLeft(UNITSTAT_LevelBadge, 0.1945, 0.0192, 0.050, 0.019)
    // Lock + chains over the portrait while the unit is paused.
    set UNITSTAT_Lock = BlzCreateFrameByType("BACKDROP", "WOSSelectedUnitLock", UNITSTAT_Widget[6], "", 0)
    call BlzFrameSetAllPoints(UNITSTAT_Lock, UNITSTAT_Widget[6])
    call BlzFrameSetTexture(UNITSTAT_Lock, "UI\\WOS\\portrait-lock.tga", 0, true)
    call BlzFrameSetEnable(UNITSTAT_Lock, false)
    call BlzFrameSetVisible(UNITSTAT_Lock, false)
    call BlzFrameSetTexture(UNITSTAT_LevelBadge, "UI\\WOS\\badge.tga", 0, true)
    call BlzFrameSetEnable(UNITSTAT_LevelBadge, false)
    set UNITSTAT_Level = BlzCreateFrameByType("TEXT", "WOSSelectedUnitLevel", UNITSTAT_LevelBadge, "", 0)
    call BlzFrameSetAllPoints(UNITSTAT_Level, UNITSTAT_LevelBadge)
    call BlzFrameSetTextAlignment(UNITSTAT_Level, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(UNITSTAT_Level, 0.86)
    call BlzFrameSetEnable(UNITSTAT_Level, false)
    // Stats column: .2285-.3035, six equal rows.
    // Checkpoint 25b: stats column .2285-.3355. Left: attack (full width),
    // resistances, attributes; right of ONE divider: damage bonuses, attack
    // speed, move speed and attack range.
    call UNITSTAT_WidgetCreate(0, "UI\\WOS\\icon-attack.tga", 0.2840, 0.0825, 0.103, events)
    // Resistances end at .2785; damage bonuses sit to their right on the same
    // rows (physical above, magical below) behind a thin vertical divider.
    call UNITSTAT_WidgetCreate(1, "UI\\WOS\\icon-phys.tga", 0.2615, 0.0692, 0.058, events)
    call UNITSTAT_WidgetCreate(2, "UI\\WOS\\icon-magic.tga", 0.2615, 0.0559, 0.058, events)
    call UNITSTAT_WidgetCreate(8, "UI\\WOS\\icon-physdmg.tga", 0.3140, 0.0692, 0.040, events)
    call UNITSTAT_WidgetCreate(9, "UI\\WOS\\icon-magdmg.tga", 0.3140, 0.0559, 0.040, events)
    set UNITSTAT_DividerB = WUI_Divider("WOSStatColumnDivider", UNITSTAT_Root, 0.2925, 0.0425, 0.066, true)
    call WUI_PlaceShiftLeft(UNITSTAT_DividerB, 0.2925, 0.0425, 0.004, 0.066)
    // Column C (mode 3) occupies .3355-.3795; the HUD to its right moves by
    // WUI_STATS_COLUMN while it is shown.
    set UNITSTAT_DividerC = WUI_Divider("WOSStatColumnDivider", UNITSTAT_Root, 0.3355, 0.0425, 0.066, true)
    call WUI_PlaceShiftLeft(UNITSTAT_DividerC, 0.3355, 0.0425, 0.004, 0.066)
    call UNITSTAT_WidgetCreate(13, "UI\\WOS\\icon-physpen.tga", 0.3580, 0.0692, 0.040, events)
    call UNITSTAT_WidgetCreate(14, "UI\\WOS\\icon-magpen.tga", 0.3580, 0.0559, 0.040, events)
    call UNITSTAT_WidgetCreate(15, "UI\\WOS\\icon-shieldpen.tga", 0.3580, 0.0426, 0.040, events)
    call UNITSTAT_WidgetCreate(16, "UI\\WOS\\icon-hpregen.tga", 0.3580, 0.0293, 0.040, events)
    call UNITSTAT_WidgetCreate(17, "UI\\WOS\\icon-mpregen.tga", 0.3580, 0.0160, 0.040, events)
    // Attribute rows end at .2765: the voice / hotkey toggles use the free
    // right part of this column.
    call UNITSTAT_WidgetCreate(3, "UI\\WOS\\stat-str.tga", 0.2615, 0.0426, 0.058, events)
    call UNITSTAT_WidgetCreate(4, "UI\\WOS\\stat-agi.tga", 0.2615, 0.0293, 0.058, events)
    call UNITSTAT_WidgetCreate(5, "UI\\WOS\\stat-int.tga", 0.2615, 0.0160, 0.058, events)
    // Checkpoint 25: attack speed / move speed / attack range opposite the
    // attributes, behind a thin divider.
    call UNITSTAT_WidgetCreate(10, "UI\\WOS\\icon-attackspeed.tga", 0.3140, 0.0426, 0.040, events)
    call UNITSTAT_WidgetCreate(11, "UI\\WOS\\icon-movespeed.tga", 0.3140, 0.0293, 0.040, events)
    call UNITSTAT_WidgetCreate(12, "UI\\WOS\\icon-range.tga", 0.3140, 0.0160, 0.040, events)
    loop
        exitwhen i >= 3
        // Under the value's first digits; drawn inside the stat row button.
        set UNITSTAT_PrimaryMark[i] = BlzCreateFrameByType("BACKDROP", "WOSStatPrimaryMark", UNITSTAT_Widget[3 + i], "", i)
        call BlzFrameSetPoint(UNITSTAT_PrimaryMark[i], FRAMEPOINT_LEFT, UNITSTAT_Widget[3 + i], FRAMEPOINT_LEFT, 0.0120, -0.0060)
        call BlzFrameSetSize(UNITSTAT_PrimaryMark[i], 0.026, 0.0058)
        call BlzFrameSetLevel(UNITSTAT_PrimaryMark[i], 6)
        call BlzFrameSetTexture(UNITSTAT_PrimaryMark[i], "UI\\WOS\\stat-underline.tga", 0, true)
        call BlzFrameSetEnable(UNITSTAT_PrimaryMark[i], false)
        call BlzFrameSetVisible(UNITSTAT_PrimaryMark[i], false)
        set i = i + 1
    endloop
    set i = 0
    set UNITSTAT_PortraitClick = CreateTrigger()
    call BlzTriggerRegisterFrameEvent(UNITSTAT_PortraitClick, UNITSTAT_Widget[6], FRAMEEVENT_CONTROL_CLICK)
    // Transparent click target over portrait and level plate. Local mouse
    // polling clears its tooltip independently of native button focus.
    set UNITSTAT_PortraitHit = BlzCreateFrameByType("BUTTON", "WOSPortraitHit", WUI_GetRoot(), "", 0)
    call WUI_PlaceShiftLeft(UNITSTAT_PortraitHit, 0.1945, 0.0430, 0.056, 0.070)
    set UNITSTAT_WidgetLeft[6] = 0.1665
    set UNITSTAT_WidgetY[6] = 0.0430
    set UNITSTAT_WidgetWidth[6] = 0.056
    set UNITSTAT_WidgetHeight[6] = 0.070
    call BlzFrameSetLevel(UNITSTAT_PortraitHit, 50)
    call BlzTriggerRegisterFrameEvent(UNITSTAT_PortraitClick, UNITSTAT_PortraitHit, FRAMEEVENT_CONTROL_CLICK)
    set UNITSTAT_PortraitTip = WUI_TooltipBox(WUI_GetRoot(), 0.132, 0.041)
    // Clear of the HUD's top ornaments.
    call BlzFrameSetAbsPoint(UNITSTAT_PortraitTip, FRAMEPOINT_BOTTOMLEFT, 0.1665, WUI_CHASSIS_TOP + 0.010)
    call BlzFrameSetLevel(UNITSTAT_PortraitTip, 60)
    set UNITSTAT_PortraitTipText = BlzCreateFrameByType("TEXT", "WOSPortraitTipText", UNITSTAT_PortraitTip, "", 0)
    // Checkpoint 26: more room between the frame top and the unit name.
    call BlzFrameSetPoint(UNITSTAT_PortraitTipText, FRAMEPOINT_TOPLEFT, UNITSTAT_PortraitTip, FRAMEPOINT_TOPLEFT, 0.007, -0.0105)
    call BlzFrameSetSize(UNITSTAT_PortraitTipText, 0.118 / 0.80, 0.024 / 0.80)
    call BlzFrameSetScale(UNITSTAT_PortraitTipText, 0.80)
    call BlzFrameSetTextAlignment(UNITSTAT_PortraitTipText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetEnable(UNITSTAT_PortraitTipText, false)
    call BlzFrameSetVisible(UNITSTAT_PortraitTip, false)
    call TriggerAddAction(UNITSTAT_PortraitClick, function UNITSTAT_OnPortraitClick)
    set UNITSTAT_VoiceToggle = WUI_ToggleButton("WOSVoiceToggle", 0.1945, 0.0870, 0.012, "UI\\WOS\\glyph-voice.tga")
    call WUI_PlaceShiftLeft(UNITSTAT_VoiceToggle, 0.1945, 0.0870, 0.012, 0.012)
    // Hero voice is on by default.
    set i = 0
    loop
        exitwhen i >= bj_MAX_PLAYER_SLOTS
        set UNITSTAT_VoiceOn[i] = true
        set i = i + 1
    endloop
    set i = 0
    call WUI_SetToggleState(UNITSTAT_VoiceToggle, true)
    call WUI_Tooltip(UNITSTAT_VoiceToggle, "|cffd5b876HERO VOICE|r|nON: clicking the portrait plays the selected hero's pick lines in turn (only you hear them).|nOFF: the portrait moves the camera.")
    set voiceClick = CreateTrigger()
    call BlzTriggerRegisterFrameEvent(voiceClick, UNITSTAT_VoiceToggle, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(voiceClick, function UNITSTAT_OnVoiceToggle)
    set UNITSTAT_ModeButton = WUI_ToggleButton("WOSStatsMode", 0.2085, 0.0870, 0.012, "UI\\WOS\\glyph-cols2.tga")
    call WUI_PlaceShiftLeft(UNITSTAT_ModeButton, 0.2085, 0.0870, 0.012, 0.012)
    call WUI_Tooltip(UNITSTAT_ModeButton, "|cffd5b876STATS COLUMNS|r|nClick: 1 column / 2 columns / 3 columns.|nThe third column shows penetration and regeneration; the rest of the HUD moves with it.")
    set voiceClick = CreateTrigger()
    call BlzTriggerRegisterFrameEvent(voiceClick, UNITSTAT_ModeButton, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(voiceClick, function UNITSTAT_OnModeClick)
    call UNITSTAT_ApplyMode()
    set voiceClick = null
    // Vitals: two equal bars over the ability row (.311-.583).
    loop
        exitwhen i >= 2
        set y = 0.0835 - I2R(i) * 0.0138
        set back = BlzCreateFrameByType("BACKDROP", "WOSVitalsBack", UNITSTAT_Root, "", i)
        call WUI_PlaceShift(back, 0.479, y, 0.272, 0.011)
        call BlzFrameSetTexture(back, "UI\\WOS\\bar-back.tga", 0, true)
        call BlzFrameSetEnable(back, false)
        if i == 0 then
            set UNITSTAT_Bar[i] = WUI_CreateFill("WOSVitalsHp", UNITSTAT_Root, 0.270, 0.009, 100.00, "UI\\WOS\\hp-dark.tga")
        else
            set UNITSTAT_Bar[i] = WUI_CreateFill("WOSVitalsMp", UNITSTAT_Root, 0.270, 0.009, 100.00, "UI\\WOS\\mp-dark.tga")
        endif
        call BlzFrameSetPoint(UNITSTAT_Bar[i], FRAMEPOINT_LEFT, back, FRAMEPOINT_LEFT, 0.001, 0.000)
        set back = WUI_GoldFrame("WOSVitalsEdge", back, 0.0030, 0.0000)
        set UNITSTAT_BarText[i] = UNITSTAT_Text("WOSVitalsNumber", UNITSTAT_Root, 0.479, y, 0.160)
        call WUI_PlaceShift(UNITSTAT_BarText[i], 0.479, y, 0.160, 0.012)
        call BlzFrameSetScale(UNITSTAT_BarText[i], 0.74)
        set UNITSTAT_Regen[i] = BlzCreateFrameByType("TEXT", "WOSVitalsRegen", UNITSTAT_Root, "", i)
        call BlzFrameSetPoint(UNITSTAT_Regen[i], FRAMEPOINT_RIGHT, back, FRAMEPOINT_RIGHT, -0.003, 0.00)
        call BlzFrameSetSize(UNITSTAT_Regen[i], 0.050, 0.011)
        call BlzFrameSetTextAlignment(UNITSTAT_Regen[i], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_RIGHT)
        call BlzFrameSetScale(UNITSTAT_Regen[i], 0.68)
        call BlzFrameSetEnable(UNITSTAT_Regen[i], false)
        set i = i + 1
    endloop
    // Gold: top row of the right block (.697-.798).
    set UNITSTAT_Widget[7] = BlzCreateFrameByType("BUTTON", "WOSGoldHover", WUI_GetRoot(), "", 0)
    call WUI_PlaceShift(UNITSTAT_Widget[7], 0.7795, 0.0795, 0.094, 0.020)
    set UNITSTAT_WidgetLeft[7] = 0.7325
    set UNITSTAT_WidgetY[7] = 0.0795
    set UNITSTAT_WidgetWidth[7] = 0.094
    set UNITSTAT_WidgetHeight[7] = 0.020
    set back = BlzCreateFrameByType("BACKDROP", "WOSGoldIcon", UNITSTAT_Widget[7], "", 0)
    call WUI_PlaceShift(back, 0.7415, 0.0795, 0.0145, 0.0145)
    call BlzFrameSetTexture(back, "UI\\Feedback\\Resources\\ResourceGold.blp", 0, true)
    call BlzFrameSetEnable(back, false)
    set UNITSTAT_Gold = UNITSTAT_Text("WOSGold", UNITSTAT_Widget[7], 0.7850, 0.0795, 0.070)
    call WUI_PlaceShift(UNITSTAT_Gold, 0.7850, 0.0795, 0.070, 0.012)
    call BlzFrameSetScale(UNITSTAT_Gold, 0.90)
    set UNITSTAT_Tooltip = WUI_Panel("WOSStatTooltip", WUI_GetRoot(), 0.225, 0.104)
    call BlzFrameSetEnable(UNITSTAT_Tooltip, false)
    call WUI_Place(UNITSTAT_Tooltip, 0.246, 0.179, 0.225, 0.104)
    // Checkpoint 23: same drawn-edge tooltip box as every other tooltip.
    set back = WUI_TooltipBox(UNITSTAT_Tooltip, 0.225, 0.104)
    call BlzFrameSetAllPoints(back, UNITSTAT_Tooltip)
    call BlzFrameSetTexture(UNITSTAT_Tooltip, WUI_EMPTY_TEXTURE, 0, true)
    set UNITSTAT_TooltipText = UNITSTAT_Text("WOSStatTooltipText", UNITSTAT_Tooltip, 0.246, 0.179, 0.208)
    call BlzFrameSetSize(UNITSTAT_TooltipText, 0.208, 0.090)
    call BlzFrameSetTextAlignment(UNITSTAT_TooltipText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetVisible(UNITSTAT_Tooltip, false)
    call BlzFrameSetVisible(UNITSTAT_Root, false)
    call UNITSTAT_CreateToolbar()
    call TimerStart(initTimer, 0.20, false, function UNITSTAT_DelayedInit)
    set events = null
    set back = null
    set initTimer = null
endfunction

private function HeroUnitPanelStats_Init takes nothing returns nothing
    call WUI_OnReady(function UNITSTAT_CreateUI)
endfunction

endlibrary
