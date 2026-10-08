library HeroUnitPanelStats initializer HeroUnitPanelStats_Init requires heroicon, WOSUI

// Existing selected-unit overlay migrated into the compact HUD. All combat data
// comes from the map's existing functions or the stock engine panel.
globals
    private group UNITSTAT_SelectedGroup = null
    private timer UNITSTAT_UpdateTimer = null
    private framehandle UNITSTAT_Root = null
    private framehandle UNITSTAT_Portrait = null
    private framehandle UNITSTAT_Level = null
    private framehandle array UNITSTAT_Widget
    private framehandle array UNITSTAT_Value
    private string array UNITSTAT_Help
    private framehandle array UNITSTAT_Bar
    private framehandle array UNITSTAT_BarText
    private framehandle array UNITSTAT_Regen
    private framehandle UNITSTAT_Tooltip = null
    private framehandle UNITSTAT_TooltipText = null
    private framehandle UNITSTAT_Gold = null
    private framehandle UNITSTAT_EngineDamage = null
    private framehandle UNITSTAT_Shop = null
    private framehandle UNITSTAT_Emotes = null
    private integer UNITSTAT_Hover = -1
    private unit UNITSTAT_LastSelected = null
    private integer UNITSTAT_LastType = 0
    private boolean UNITSTAT_Compact = false
endglobals

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

private function UNITSTAT_CreateToolbar takes nothing returns nothing
    local trigger clicks = CreateTrigger()
    local framehandle icon
    local framehandle text
    set UNITSTAT_Shop = BlzCreateFrameByType("BUTTON", "WOSShopToolbar", WUI_GetRoot(), "", 0)
    call WUI_PlaceToolbar(UNITSTAT_Shop, 0, 0)
    set icon = BlzCreateFrameByType("BACKDROP", "WOSShopToolbarIcon", UNITSTAT_Shop, "", 0)
    call BlzFrameSetAllPoints(icon, UNITSTAT_Shop)
    call BlzFrameSetTexture(icon, "ReplaceableTextures\\CommandButtons\\BTNMarketplace.blp", 0, true)
    call BlzFrameSetEnable(icon, false)
    call WUI_Tooltip(UNITSTAT_Shop, "SHOP [Tab]|nOpen or close your current shop tab.")
    set UNITSTAT_Emotes = BlzCreateFrameByType("BUTTON", "WOSEmotesToolbar", WUI_GetRoot(), "", 0)
    call WUI_PlaceToolbar(UNITSTAT_Emotes, 2, 0)
    set icon = BlzCreateFrameByType("BACKDROP", "WOSEmotesToolbarIcon", UNITSTAT_Emotes, "", 0)
    call BlzFrameSetAllPoints(icon, UNITSTAT_Emotes)
    call BlzFrameSetTexture(icon, "UI\\TeamPings\\button-emoji.tga", 0, true)
    call BlzFrameSetEnable(icon, false)
    set text = BlzCreateFrameByType("TEXT", "WOSEmotesToolbarHotkey", UNITSTAT_Emotes, "", 0)
    call BlzFrameSetPoint(text, FRAMEPOINT_BOTTOMRIGHT, UNITSTAT_Emotes, FRAMEPOINT_BOTTOMRIGHT, 0.00, 0.00)
    call BlzFrameSetText(text, WUI_GOLD + "K|r")
    call BlzFrameSetScale(text, 0.55)
    call BlzFrameSetEnable(text, false)
    call WUI_Tooltip(UNITSTAT_Emotes, "EMOTES [K]|nOpen the existing hero emote palette.")
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

private function UNITSTAT_WidgetCreate takes integer index, string texture, real x, real y, real width, trigger events returns nothing
    local framehandle icon
    set UNITSTAT_Widget[index] = BlzCreateFrameByType("BUTTON", "WOSStatWidget", UNITSTAT_Root, "", index)
    call WUI_Place(UNITSTAT_Widget[index], x, y, width, 0.013)
    set icon = BlzCreateFrameByType("BACKDROP", "WOSStatIcon", UNITSTAT_Widget[index], "", index)
    call BlzFrameSetPoint(icon, FRAMEPOINT_LEFT, UNITSTAT_Widget[index], FRAMEPOINT_LEFT, 0.001, 0.00)
    call BlzFrameSetSize(icon, 0.010, 0.010)
    call BlzFrameSetTexture(icon, texture, 0, true)
    call BlzFrameSetEnable(icon, false)
    set UNITSTAT_Value[index] = UNITSTAT_Text("WOSStatValue", UNITSTAT_Widget[index], x + 0.006, y, width - 0.012)
    call BlzTriggerRegisterFrameEvent(events, UNITSTAT_Widget[index], FRAMEEVENT_MOUSE_ENTER)
    call BlzTriggerRegisterFrameEvent(events, UNITSTAT_Widget[index], FRAMEEVENT_MOUSE_LEAVE)
    set icon = null
endfunction

private function UNITSTAT_HoverEvent takes nothing returns nothing
    local integer i = 0
    if GetLocalPlayer() != GetTriggerPlayer() then
        return
    endif
    if BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_LEAVE then
        set UNITSTAT_Hover = -1
        call BlzFrameSetVisible(UNITSTAT_Tooltip, false)
        return
    endif
    loop
        exitwhen i >= 8
        if BlzGetTriggerFrame() == UNITSTAT_Widget[i] then
            set UNITSTAT_Hover = i
            call WUI_SetText(UNITSTAT_TooltipText, UNITSTAT_Help[i])
            call BlzFrameSetVisible(UNITSTAT_Tooltip, true)
            return
        endif
        set i = i + 1
    endloop
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
        set readable = IsPlayerAlly(GetOwningPlayer(selected), GetLocalPlayer()) or (IsUnitVisible(selected, GetLocalPlayer()) and IsUnitDetected(selected, GetLocalPlayer()))
    endif
    call BlzFrameSetVisible(UNITSTAT_Root, readable)
    call WUI_ShowNativeBuffs(readable)
    call WUI_SetText(UNITSTAT_Gold, "|cffd5b876" + I2S(GetPlayerState(GetLocalPlayer(), PLAYER_STATE_RESOURCE_GOLD)) + "|r")
    set UNITSTAT_Help[7] = "|cffd5b876GOLD|r|nCurrent: " + I2S(GetPlayerState(GetLocalPlayer(), PLAYER_STATE_RESOURCE_GOLD)) + "|nNext round: " + I2S(GetPlayerState(GetLocalPlayer(), PLAYER_STATE_RESOURCE_LUMBER))
    if not readable then
        if UNITSTAT_Hover == 7 then
            call WUI_SetText(UNITSTAT_TooltipText, UNITSTAT_Help[7])
        else
            call BlzFrameSetVisible(UNITSTAT_Tooltip, false)
        endif
        set selected = null
        return
    endif
    set hero = IsUnitType(selected, UNIT_TYPE_HERO) or IsHeroUnitId(GetUnitTypeId(selected))
    set heroType = GetUnitTypeId(selected)
    if selected != UNITSTAT_LastSelected or heroType != UNITSTAT_LastType then
        call BlzFrameSetTexture(UNITSTAT_Portrait, BlzGetAbilityIcon(heroType), 0, true)
        call WUI_LayoutCommands(hero)
        set UNITSTAT_LastSelected = selected
        set UNITSTAT_LastType = heroType
    endif
    set UNITSTAT_Compact = hero
    set UNITSTAT_Help[6] = "|cffd5b876" + GetUnitName(selected) + "|r"
    if hero then
        call WUI_SetText(UNITSTAT_Level, "|cffd5b876" + I2S(GetHeroLevel(selected)) + "|r")
    else
        call WUI_SetText(UNITSTAT_Level, "")
    endif
    if UNITSTAT_EngineDamage != null then
        set damage = BlzFrameGetText(UNITSTAT_EngineDamage)
    else
        set damage = R2SW(GetAttack(selected), 0, 0)
    endif
    call WUI_SetText(UNITSTAT_Value[0], "|cffe1e5eb" + damage + "|r")
    set UNITSTAT_Help[0] = "|cffd5b876ATTACK|r|nDamage: " + damage + "|nAttack interval: " + R2SW(GetAS(selected), 0, 2) + "s|nRange: " + R2SW(BlzGetUnitWeaponRealField(selected, UNIT_WEAPON_RF_ATTACK_RANGE, 0), 0, 0)
    set blocked = GetUnitAbilityLevel(selected, 'Avul') > 0 and not CheckCoordsInRect(gg_rct_Base, GetUnitX(selected), GetUnitY(selected))
    if blocked then
        call WUI_SetText(UNITSTAT_Value[1], "|cffe8c975Block|r")
        call WUI_SetText(UNITSTAT_Value[2], "|cffe8c975Block|r")
    else
        call WUI_SetText(UNITSTAT_Value[1], "|cffff8a83" + R2SW(GetPhysRes(selected), 0, 1) + "%|r")
        call WUI_SetText(UNITSTAT_Value[2], "|cff7caefa" + R2SW(GetMagRes(selected), 0, 1) + "%|r")
    endif
    set UNITSTAT_Help[1] = "|cffff8a83PHYSICAL RESISTANCE|r|n" + R2SW(GetPhysRes(selected), 0, 2) + "%|nUses the map's physical damage system.|nInvulnerability blocks damage outside the base."
    set UNITSTAT_Help[2] = "|cff7caefaMAGICAL RESISTANCE|r|n" + R2SW(GetMagRes(selected), 0, 2) + "%|nUses the map's magical damage system.|nInvulnerability blocks damage outside the base."
    set i = 3
    loop
        exitwhen i >= 6
        call BlzFrameSetVisible(UNITSTAT_Widget[i], hero)
        set color = "|cffe1e5eb"
        if i == 3 then
            set value = I2R(GetHeroStr(selected, true))
            if GetMainStatStr(selected) then
                set color = WUI_GOLD
            endif
            set UNITSTAT_Help[i] = "|cffd5b876STRENGTH|r|nTotal: " + I2S(GetHeroStr(selected, true)) + "|nBase: " + I2S(GetHeroStr(selected, false))
        elseif i == 4 then
            set value = I2R(GetHeroAgi(selected, true))
            if GetMainStatAgi(selected) then
                set color = WUI_GOLD
            endif
            set UNITSTAT_Help[i] = "|cffd5b876AGILITY|r|nTotal: " + I2S(GetHeroAgi(selected, true)) + "|nBase: " + I2S(GetHeroAgi(selected, false))
        else
            set value = I2R(GetHeroInt(selected, true))
            if GetMainStatInt(selected) then
                set color = WUI_GOLD
            endif
            set UNITSTAT_Help[i] = "|cffd5b876INTELLIGENCE|r|nTotal: " + I2S(GetHeroInt(selected, true)) + "|nBase: " + I2S(GetHeroInt(selected, false))
        endif
        call WUI_SetText(UNITSTAT_Value[i], color + I2S(R2I(value)) + "|r")
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
        call BlzFrameSetVisible(UNITSTAT_Bar[i], maximum > 0.00)
        call BlzFrameSetVisible(UNITSTAT_BarText[i], maximum > 0.00)
        call BlzFrameSetVisible(UNITSTAT_Regen[i], maximum > 0.00)
        call WUI_SetValue(UNITSTAT_Bar[i], 100.00 * value / RMaxBJ(1.00, maximum))
        call WUI_SetText(UNITSTAT_BarText[i], I2S(R2I(value)) + " / " + I2S(R2I(maximum)))
        set i = i + 1
    endloop
    if UNITSTAT_Hover >= 0 then
        call WUI_SetText(UNITSTAT_TooltipText, UNITSTAT_Help[UNITSTAT_Hover])
    endif
    set selected = null
endfunction

private function UNITSTAT_DelayedInit takes nothing returns nothing
    local timer initTimer = GetExpiredTimer()
    call DestroyTimer(initTimer)
    call WUI_StartNativeLayout()
    set UNITSTAT_EngineDamage = BlzGetFrameByName("InfoPanelIconValue", 0)
    call WUI_LayoutCommands(false)
    set UNITSTAT_UpdateTimer = CreateTimer()
    call TimerStart(UNITSTAT_UpdateTimer, 0.10, true, function UNITSTAT_Update)
    set initTimer = null
endfunction

private function UNITSTAT_CreateUI takes nothing returns nothing
    local trigger events = CreateTrigger()
    local framehandle back
    local integer i = 0
    local timer initTimer = CreateTimer()
    set UNITSTAT_SelectedGroup = CreateGroup()
    set UNITSTAT_Root = WUI_Passive("WOSSelectedUnitHUD", WUI_GetRoot())
    set back = WUI_Panel("WOSSelectedUnitBack", UNITSTAT_Root, 0.096, 0.092)
    call WUI_Place(back, 0.203, 0.052, 0.096, 0.092)
    set back = WUI_OrnateWindow("WOSSelectedUnitEdge", back, 0.014)
    set UNITSTAT_Widget[6] = BlzCreateFrameByType("BUTTON", "WOSSelectedUnitIcon", UNITSTAT_Root, "", 0)
    call WUI_Place(UNITSTAT_Widget[6], 0.177, 0.059, 0.038, 0.038)
    set UNITSTAT_Portrait = BlzCreateFrameByType("BACKDROP", "WOSSelectedUnitIconTexture", UNITSTAT_Widget[6], "", 0)
    call BlzFrameSetAllPoints(UNITSTAT_Portrait, UNITSTAT_Widget[6])
    set back = WUI_Border("WOSSelectedUnitBorder", UNITSTAT_Widget[6])
    set UNITSTAT_Level = UNITSTAT_Text("WOSSelectedUnitLevel", UNITSTAT_Root, 0.177, 0.032, 0.031)
    call UNITSTAT_WidgetCreate(0, "ReplaceableTextures\\CommandButtons\\BTNSteelMelee.blp", 0.224, 0.085, 0.048, events)
    call UNITSTAT_WidgetCreate(1, "ReplaceableTextures\\CommandButtons\\BTNDefend.blp", 0.224, 0.071, 0.048, events)
    call UNITSTAT_WidgetCreate(2, "ReplaceableTextures\\CommandButtons\\BTNSpellShieldAmulet.blp", 0.224, 0.057, 0.048, events)
    call UNITSTAT_WidgetCreate(3, "UI\\Widgets\\Console\\Human\\human-attribute-str.blp", 0.224, 0.043, 0.048, events)
    call UNITSTAT_WidgetCreate(4, "UI\\Widgets\\Console\\Human\\human-attribute-agi.blp", 0.224, 0.029, 0.048, events)
    call UNITSTAT_WidgetCreate(5, "UI\\Widgets\\Console\\Human\\human-attribute-int.blp", 0.224, 0.015, 0.048, events)
    loop
        exitwhen i >= 2
        set back = WUI_Panel("WOSVitalsBack", UNITSTAT_Root, 0.277, 0.009)
        call WUI_Place(back, 0.474, 0.093 - I2R(i) * 0.014, 0.277, 0.009)
        if i == 0 then
            set UNITSTAT_Bar[i] = WUI_CreateFill("WOSVitalsHp", UNITSTAT_Root, 0.275, 0.007, 100.00, "UI\\WOS\\hp.tga")
        else
            set UNITSTAT_Bar[i] = WUI_CreateFill("WOSVitalsMp", UNITSTAT_Root, 0.275, 0.007, 100.00, "UI\\WOS\\mp.tga")
        endif
        call BlzFrameSetAbsPoint(UNITSTAT_Bar[i], FRAMEPOINT_LEFT, 0.3365, 0.093 - I2R(i) * 0.014)
        set UNITSTAT_BarText[i] = UNITSTAT_Text("WOSVitalsNumber", UNITSTAT_Root, 0.470, 0.093 - I2R(i) * 0.014, 0.160)
        call BlzFrameSetScale(UNITSTAT_BarText[i], 0.76)
        set UNITSTAT_Regen[i] = UNITSTAT_Text("WOSVitalsRegen", UNITSTAT_Root, 0.586, 0.093 - I2R(i) * 0.014, 0.044)
        call BlzFrameSetScale(UNITSTAT_Regen[i], 0.70)
        set i = i + 1
    endloop
    set UNITSTAT_Widget[7] = BlzCreateFrameByType("BUTTON", "WOSGoldHover", WUI_GetRoot(), "", 0)
    call WUI_Place(UNITSTAT_Widget[7], 0.742, 0.091, 0.093, 0.016)
    set back = BlzCreateFrameByType("BACKDROP", "WOSGoldIcon", UNITSTAT_Widget[7], "", 0)
    call WUI_Place(back, 0.707, 0.091, 0.014, 0.014)
    call BlzFrameSetTexture(back, "UI\\Feedback\\Resources\\ResourceGold.blp", 0, true)
    call BlzFrameSetEnable(back, false)
    set UNITSTAT_Gold = UNITSTAT_Text("WOSGold", UNITSTAT_Widget[7], 0.753, 0.091, 0.067)
    call BlzTriggerRegisterFrameEvent(events, UNITSTAT_Widget[7], FRAMEEVENT_MOUSE_ENTER)
    call BlzTriggerRegisterFrameEvent(events, UNITSTAT_Widget[7], FRAMEEVENT_MOUSE_LEAVE)
    call BlzTriggerRegisterFrameEvent(events, UNITSTAT_Widget[6], FRAMEEVENT_MOUSE_ENTER)
    call BlzTriggerRegisterFrameEvent(events, UNITSTAT_Widget[6], FRAMEEVENT_MOUSE_LEAVE)
    call TriggerAddAction(events, function UNITSTAT_HoverEvent)
    set UNITSTAT_Tooltip = WUI_Panel("WOSStatTooltip", WUI_GetRoot(), 0.225, 0.104)
    call WUI_Place(UNITSTAT_Tooltip, 0.272, 0.179, 0.225, 0.104)
    set back = WUI_Border("WOSStatTooltipBorder", UNITSTAT_Tooltip)
    set UNITSTAT_TooltipText = UNITSTAT_Text("WOSStatTooltipText", UNITSTAT_Tooltip, 0.272, 0.179, 0.208)
    call BlzFrameSetSize(UNITSTAT_TooltipText, 0.208, 0.090)
    call BlzFrameSetTextAlignment(UNITSTAT_TooltipText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
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
