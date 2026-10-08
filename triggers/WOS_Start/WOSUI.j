library WOSUI initializer WUI_Init

// Normal FRAME root only. Native SIMPLEFRAME commands/items keep their own tree.
globals
    private leaderboard WUI_ServiceBoard = null
    private framehandle WUI_Root = null
    private framehandle WUI_SimpleRoot = null
    private timer WUI_BootTimer = CreateTimer()
    private boolean WUI_Ready = false
    private integer WUI_ReadyCount = 0
    private trigger array WUI_ReadyOwner
    private timer WUI_DockTimer = CreateTimer()
    private hashtable WUI_DockKeys = InitHashtable()
    private integer WUI_DockCount = 0
    private framehandle array WUI_DockFrame
    private framehandle array WUI_DockLabel
    private integer array WUI_DockOwner
    private integer array WUI_DockKind
    private boolean array WUI_DockPlaced
    private real array WUI_DockX
    private real array WUI_DockY
    private framehandle WUI_TestPanel = null
    private framehandle WUI_TestToggle = null
    private boolean WUI_TestOpen = true
    private framehandle array WUI_Command
    private framehandle array WUI_Item
    private framehandle array WUI_System
    private framehandle WUI_Menu = null
    private framehandle WUI_Orders = null
    private boolean WUI_MenuOpen = false
    private boolean WUI_OrdersOpen = false
    private boolean WUI_CompactCommands = false
    private framehandle WUI_Console = null
    private framehandle WUI_Portrait = null
    private framehandle WUI_Resource = null
    private framehandle WUI_HeroBar = null
    private framehandle WUI_DeadZone = null
    private framehandle WUI_HiddenDetails = null
    private framehandle WUI_Buffs = null
    constant real WUI_HUD_Y = 0.044
    constant real WUI_COMMAND_X = 0.354
    constant real WUI_COMMAND_STEP = 0.040
    constant real WUI_ICON_SIZE = 0.036
    constant string WUI_PANEL_TEXTURE = "UI\\WOS\\panel.tga"
    constant string WUI_BORDER_TEXTURE = "UI\\WOS\\border.tga"
    constant string WUI_GOLD = "|cffd5b876"
    constant string WUI_TEXT = "|cffe1e5eb"
endglobals

// Library initializers register owners only. No frame native may run until the
// bootstrap timer fires in game time; every client allocates the same handles.
// One trigger per owner also keeps large UI builds in separate JASS threads.
function WUI_OnReady takes code callback returns nothing
    local trigger owner = CreateTrigger()
    call TriggerAddAction(owner, callback)
    if WUI_Ready then
        call TriggerExecute(owner)
        call DestroyTrigger(owner)
    else
        set WUI_ReadyCount = WUI_ReadyCount + 1
        set WUI_ReadyOwner[WUI_ReadyCount] = owner
    endif
    set owner = null
endfunction

function WUI_GetRoot takes nothing returns framehandle
    return WUI_Root
endfunction

function WUI_GetSimpleRoot takes nothing returns framehandle
    return WUI_SimpleRoot
endfunction

function WUI_Place takes framehandle frame, real x, real y, real width, real height returns nothing
    if frame != null then
        call BlzFrameClearAllPoints(frame)
        call BlzFrameSetAbsPoint(frame, FRAMEPOINT_CENTER, x, y)
        call BlzFrameSetSize(frame, width, height)
    endif
endfunction

function WUI_Panel takes string name, framehandle parent, real width, real height returns framehandle
    local framehandle panel = BlzCreateFrameByType("BACKDROP", name, parent, "", 0)
    call BlzFrameSetSize(panel, width, height)
    call BlzFrameSetTexture(panel, WUI_PANEL_TEXTURE, 0, true)
    return panel
endfunction

function WUI_Border takes string name, framehandle owner returns framehandle
    local framehandle edge = BlzCreateFrameByType("BACKDROP", name, owner, "", 0)
    call BlzFrameSetAllPoints(edge, owner)
    call BlzFrameSetTexture(edge, WUI_BORDER_TEXTURE, 0, true)
    call BlzFrameSetEnable(edge, false)
    return edge
endfunction

function WUI_Window takes string name, framehandle parent, integer layer, integer context returns framehandle
    local framehandle panel = BlzCreateFrameByType("BACKDROP", name, parent, "", context)
    local framehandle edge = WUI_Border(name + "Edge", panel)
    call BlzFrameSetTexture(panel, WUI_PANEL_TEXTURE, 0, true)
    call BlzFrameSetLevel(panel, layer)
    set edge = null
    return panel
endfunction

// Existing hero owners keep their state, values and visibility. Only presentation
// is shared. This helper allocates no handles and can be reused when showing a bar.
function WUI_Pin takes framehandle child, framehandle owner, real x, real y, real width, real height returns nothing
    call BlzFrameClearAllPoints(child)
    call BlzFrameSetPoint(child, FRAMEPOINT_CENTER, owner, FRAMEPOINT_CENTER, x, y)
    call BlzFrameSetSize(child, width, height)
endfunction

function WUI_HeroMeter takes framehandle panel, framehandle back, framehandle bar, framehandle icon, framehandle title, framehandle value returns nothing
    call BlzFrameSetSize(panel, 0.140, 0.025)
    call BlzFrameSetTexture(back, "UI\\WOS\\bar-back.tga", 0, true)
    call WUI_Pin(back, panel, 0.012, -0.004, 0.104, 0.007)
    call BlzFrameSetScale(bar, 1.00)
    call BlzFrameSetTexture(bar, "UI\\WOS\\meter.tga", 0, true)
    call WUI_Pin(bar, panel, 0.012, -0.004, 0.104, 0.007)
    call WUI_Pin(icon, panel, -0.055, 0.000, 0.019, 0.019)
    call BlzFrameSetScale(title, 0.70)
    call WUI_Pin(title, panel, 0.012, 0.006, 0.112, 0.011)
    call BlzFrameSetTextAlignment(title, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(value, 0.66)
    call WUI_Pin(value, panel, 0.012, -0.004, 0.104, 0.009)
    call BlzFrameSetTextAlignment(value, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
endfunction

// Registration is synchronous. Per-client visibility, coordinates and movement
// belong only to presentation; they never feed casting, charges or game timers.
function WUI_RegisterDock takes framehandle panel, framehandle label, integer owner, integer kind, string key returns nothing
    local integer index = LoadInteger(WUI_DockKeys, StringHash(key), 0)
    if panel == null then
        return
    endif
    if index == 0 then
        set WUI_DockCount = WUI_DockCount + 1
        set index = WUI_DockCount
        call SaveInteger(WUI_DockKeys, StringHash(key), 0, index)
    elseif WUI_DockFrame[index] != null and WUI_DockFrame[index] != panel then
        call BlzFrameSetVisible(WUI_DockFrame[index], false)
        if WUI_DockLabel[index] != null then
            call BlzFrameSetVisible(WUI_DockLabel[index], false)
        endif
    endif
    set WUI_DockFrame[index] = panel
    set WUI_DockLabel[index] = label
    set WUI_DockOwner[index] = owner
    set WUI_DockKind[index] = kind
    set WUI_DockPlaced[index] = false
endfunction

function WUI_RegisterMeter takes framehandle panel, integer owner, string key returns nothing
    call WUI_RegisterDock(panel, null, owner, 0, key)
endfunction

function WUI_RegisterPublicMeter takes framehandle panel, string key returns nothing
    call WUI_RegisterDock(panel, null, -1, 2, key)
endfunction

function WUI_RegisterBuff takes framehandle panel, framehandle label, integer owner, string key returns nothing
    call WUI_RegisterDock(panel, label, owner, 1, key)
endfunction

function WUI_SimpleBorder takes framehandle owner returns nothing
    local framehandle edge = BlzCreateFrameByType("SIMPLESTATUSBAR", "WOSBuffBorder", owner, "", 0)
    call BlzFrameSetAllPoints(edge, owner)
    call BlzFrameSetTexture(edge, WUI_BORDER_TEXTURE, 0, true)
    call BlzFrameSetMinMaxValue(edge, 0.00, 100.00)
    call BlzFrameSetValue(edge, 100.00)
    call BlzFrameSetEnable(edge, false)
    set edge = null
endfunction

function WUI_RefreshDocks takes nothing returns nothing
    local integer playerId = GetPlayerId(GetLocalPlayer())
    local integer index = 1
    local integer meterSlot = 0
    local integer buffSlot = 0
    local integer publicSlot = 0
    local integer column
    local integer row
    local real x
    local real y
    local real buffY = 0.144
    if WUI_OrdersOpen then
        set buffY = 0.181
    endif
    loop
        exitwhen index > WUI_DockCount
        if WUI_DockOwner[index] == playerId or WUI_DockOwner[index] == -1 then
            if BlzFrameIsVisible(WUI_DockFrame[index]) then
                if WUI_DockKind[index] == 0 then
                    set x = 0.075
                    set y = 0.162 + I2R(meterSlot) * 0.030
                    set meterSlot = meterSlot + 1
                elseif WUI_DockKind[index] == 1 then
                    set column = ModuloInteger(buffSlot, 20)
                    set row = (buffSlot - column) / 20
                    set x = 0.178 + I2R(column) * 0.026
                    set y = buffY + I2R(row) * 0.035
                    set buffSlot = buffSlot + 1
                else
                    set column = ModuloInteger(publicSlot, 2)
                    set row = (publicSlot - column) / 2
                    set x = 0.325 + I2R(column) * 0.150
                    set y = 0.490 - I2R(row) * 0.030
                    set publicSlot = publicSlot + 1
                endif
                if not WUI_DockPlaced[index] then
                    set WUI_DockX[index] = x
                    set WUI_DockY[index] = y
                else
                    set x = WUI_DockX[index] + (x - WUI_DockX[index]) * 0.60
                    set y = WUI_DockY[index] + (y - WUI_DockY[index]) * 0.60
                endif
                if RAbsBJ(x - WUI_DockX[index]) > 0.0001 or RAbsBJ(y - WUI_DockY[index]) > 0.0001 or not WUI_DockPlaced[index] then
                    call BlzFrameClearAllPoints(WUI_DockFrame[index])
                    call BlzFrameSetAbsPoint(WUI_DockFrame[index], FRAMEPOINT_CENTER, x, y)
                    set WUI_DockX[index] = x
                    set WUI_DockY[index] = y
                    if WUI_DockLabel[index] != null then
                        call WUI_Place(WUI_DockLabel[index], x, y - 0.016, 0.025, 0.010)
                        call BlzFrameSetScale(WUI_DockLabel[index], 0.66)
                    endif
                endif
                set WUI_DockPlaced[index] = true
            else
                set WUI_DockPlaced[index] = false
            endif
        endif
        set index = index + 1
    endloop
endfunction

function WUI_SetText takes framehandle frame, string value returns nothing
    if BlzFrameGetText(frame) != value then
        call BlzFrameSetText(frame, value)
    endif
endfunction

function WUI_SetValue takes framehandle frame, real value returns nothing
    if BlzFrameGetValue(frame) != value then
        call BlzFrameSetValue(frame, value)
    endif
endfunction

// For new heroes: one synchronous add, then update/show from the existing owner.
// Legacy meters attach to the same dock without replacing their frame references.
struct WOSHeroMeter
    framehandle panel
    framehandle back
    framehandle bar
    framehandle icon
    framehandle title
    framehandle value
    integer owner

    static method add takes integer playerId, string key, string iconPath, string caption, real maximum returns thistype
        local thistype this = thistype.allocate()
        set owner = playerId
        set panel = WUI_Window("WOSHeroMeter", WUI_GetRoot(), 0, 0)
        set back = BlzCreateFrameByType("BACKDROP", "WOSMeterBack", panel, "", 0)
        set bar = BlzCreateFrameByType("STATUSBAR", "WOSMeterFill", panel, "", 0)
        set icon = BlzCreateFrameByType("BACKDROP", "WOSMeterIcon", panel, "", 0)
        set title = BlzCreateFrameByType("TEXT", "WOSMeterTitle", panel, "", 0)
        set value = BlzCreateFrameByType("TEXT", "WOSMeterValue", panel, "", 0)
        call BlzFrameSetTexture(icon, iconPath, 0, true)
        call BlzFrameSetText(title, WUI_GOLD + caption + "|r")
        call BlzFrameSetMinMaxValue(bar, 0.00, maximum)
        call WUI_HeroMeter(panel, back, bar, icon, title, value)
        call BlzFrameSetVisible(panel, false)
        call WUI_RegisterMeter(panel, owner, key)
        return this
    endmethod

    method update takes real amount, string caption returns nothing
        call WUI_SetValue(bar, amount)
        call WUI_SetText(value, WUI_TEXT + caption + "|r")
    endmethod

    method show takes boolean visible returns nothing
        if GetPlayerId(GetLocalPlayer()) == owner then
            call BlzFrameSetVisible(panel, visible)
        endif
        call WUI_RefreshDocks()
    endmethod

    method onDestroy takes nothing returns nothing
        local integer index = 1
        loop
            exitwhen index > WUI_DockCount
            if WUI_DockFrame[index] == panel then
                set WUI_DockFrame[index] = null
                set WUI_DockLabel[index] = null
                set WUI_DockOwner[index] = -2
            endif
            set index = index + 1
        endloop
        call BlzDestroyFrame(panel)
        set panel = null
        set back = null
        set bar = null
        set icon = null
        set title = null
        set value = null
    endmethod
endstruct

function WUI_ShowNativeBuffs takes boolean visible returns nothing
    if WUI_Buffs != null then
        call BlzFrameSetVisible(WUI_Buffs, visible)
    endif
endfunction

// Call only while creating frames synchronously, before local visibility changes.
function WUI_Tooltip takes framehandle owner, string label returns nothing
    local framehandle box = WUI_Panel("WOSToolbarTooltip", WUI_Root, 0.170, 0.038)
    local framehandle text = BlzCreateFrameByType("TEXT", "WOSToolbarTooltipText", box, "", 0)
    local framehandle edge = WUI_Border("WOSToolbarTooltipBorder", box)
    call BlzFrameSetPoint(box, FRAMEPOINT_BOTTOMRIGHT, owner, FRAMEPOINT_TOPRIGHT, 0.00, 0.010)
    call BlzFrameSetPoint(text, FRAMEPOINT_CENTER, box, FRAMEPOINT_CENTER, 0.00, 0.00)
    call BlzFrameSetSize(text, 0.158, 0.030)
    call BlzFrameSetScale(text, 0.66)
    call BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_LEFT)
    call BlzFrameSetText(text, WUI_TEXT + label + "|r")
    call BlzFrameSetEnable(text, false)
    call BlzFrameSetLevel(box, 60)
    call BlzFrameSetTooltip(owner, box)
    call BlzFrameSetVisible(box, false)
    set box = null
    set text = null
    set edge = null
endfunction

function WUI_StyleButton takes framehandle control returns nothing
    // These five children are backdrops/highlight, never the native text string.
    if control == null then
        return
    endif
    if BlzFrameGetChildrenCount(control) < 5 then
        return
    endif
    call BlzFrameSetTexture(BlzFrameGetChild(control, 0), "UI\\WOS\\button.tga", 0, true)
    call BlzFrameSetTexture(BlzFrameGetChild(control, 1), "UI\\WOS\\pressed.tga", 0, true)
    call BlzFrameSetTexture(BlzFrameGetChild(control, 2), "UI\\WOS\\disabled.tga", 0, true)
    call BlzFrameSetTexture(BlzFrameGetChild(control, 3), "UI\\WOS\\disabled.tga", 0, true)
    call BlzFrameSetAlpha(BlzFrameGetChild(control, 4), 110)
endfunction

function WUI_HideNativeDeadZone takes nothing returns nothing
    if WUI_DeadZone != null then
        call BlzFrameSetVisible(WUI_DeadZone, false)
    endif
endfunction

function WUI_CommandSlot takes integer slot returns integer
    if slot < 4 then
        return slot + 8
    elseif slot == 4 then
        return 7
    endif
    return slot
endfunction

function WUI_LayoutCommands takes boolean compact returns nothing
    local integer i = 0
    local integer slot
    local real y
    set WUI_CompactCommands = compact
    loop
        exitwhen i >= 12
        if compact and i < 5 and not WUI_OrdersOpen then
            call WUI_Place(WUI_Command[i], -0.20, -0.20, WUI_ICON_SIZE, WUI_ICON_SIZE)
        elseif compact and i < 5 then
            call WUI_Place(WUI_Command[i], WUI_COMMAND_X + I2R(i) * WUI_COMMAND_STEP, 0.139, WUI_ICON_SIZE, WUI_ICON_SIZE)
        elseif not compact then
            // Ordinary units, shop and learn cards retain access to all 12 slots.
            set y = 0.035
            if i < 6 then
                set y = y + WUI_COMMAND_STEP
            endif
            call WUI_Place(WUI_Command[i], WUI_COMMAND_X + I2R(ModuloInteger(i, 6)) * WUI_COMMAND_STEP, y, WUI_ICON_SIZE, WUI_ICON_SIZE)
        endif
        set i = i + 1
    endloop
    if compact then
        set slot = 0
        loop
            exitwhen slot >= 7
            call WUI_Place(WUI_Command[WUI_CommandSlot(slot)], WUI_COMMAND_X + I2R(slot) * WUI_COMMAND_STEP, WUI_HUD_Y, WUI_ICON_SIZE, WUI_ICON_SIZE)
            set slot = slot + 1
        endloop
    endif
endfunction

private function WUI_ControlClick takes nothing returns nothing
    local integer i = 0
    if GetLocalPlayer() == GetTriggerPlayer() then
        if BlzGetTriggerFrame() == WUI_Menu then
            set WUI_MenuOpen = not WUI_MenuOpen
            loop
                exitwhen i >= 3
                if WUI_MenuOpen then
                    call WUI_Place(WUI_System[i], 0.730, 0.540 - I2R(i) * 0.025, 0.110, 0.021)
                else
                    call WUI_Place(WUI_System[i], -0.20, -0.20, 0.110, 0.021)
                endif
                set i = i + 1
            endloop
        else
            set WUI_OrdersOpen = not WUI_OrdersOpen
            call WUI_LayoutCommands(WUI_CompactCommands)
        endif
        call BlzFrameSetEnable(BlzGetTriggerFrame(), false)
        call BlzFrameSetEnable(BlzGetTriggerFrame(), true)
    endif
endfunction

function WUI_InstallNativeLayout takes nothing returns nothing
    local integer i = 0
    local framehandle simpleParent = null
    local framehandle itemParent = null
    local framehandle detail = BlzGetFrameByName("SimpleInfoPanelUnitDetail", 0)
    local framehandle cover = BlzGetFrameByName("SimpleInventoryCover", 0)
    local framehandle minimap = BlzGetOriginFrame(ORIGIN_FRAME_MINIMAP, 0)
    if WUI_HiddenDetails != null or WUI_Command[0] == null or WUI_Item[0] == null or WUI_SimpleRoot == null then
        set simpleParent = null
        set detail = null
        set cover = null
        set minimap = null
        return
    endif
    set simpleParent = BlzFrameGetParent(WUI_Command[0])
    set itemParent = BlzFrameGetParent(WUI_Item[0])
    if simpleParent == null or itemParent == null then
        set simpleParent = null
        set itemParent = null
        set detail = null
        set cover = null
        set minimap = null
        return
    endif
    // Do not move a SIMPLEFRAME into the normal FRAME hierarchy.
    call BlzFrameSetParent(itemParent, simpleParent)
    set WUI_HiddenDetails = BlzCreateFrameByType("SIMPLEFRAME", "WOSHiddenNativeDetails", WUI_SimpleRoot, "", 0)
    call BlzFrameSetVisible(WUI_HiddenDetails, false)
    if detail != null then
        // Keep real status icons/tooltips when the large unit detail panel is hidden.
        if WUI_Buffs != null then
            call BlzFrameSetParent(WUI_Buffs, simpleParent)
            call WUI_Place(WUI_Buffs, 0.245, 0.113, 0.165, 0.016)
        endif
        call BlzFrameSetParent(detail, WUI_HiddenDetails)
    endif
    if cover != null then
        call BlzFrameSetAlpha(cover, 0)
    endif
    call BlzEnableUIAutoPosition(false)
    if minimap != null then
        call BlzFrameClearAllPoints(minimap)
        call BlzFrameSetAbsPoint(minimap, FRAMEPOINT_BOTTOMLEFT, 0.004, 0.004)
        call BlzFrameSetAbsPoint(minimap, FRAMEPOINT_TOPRIGHT, 0.144, 0.144)
    endif
    loop
        exitwhen i >= 6
        call WUI_Place(WUI_Item[i], 0.630 + I2R(ModuloInteger(i, 3)) * 0.025, 0.060 - I2R(i / 3) * 0.025, 0.022, 0.022)
        set i = i + 1
    endloop
    if WUI_Console != null then
        call BlzFrameSetVisible(WUI_Console, false)
    endif
    if WUI_Portrait != null then
        call BlzFrameSetVisible(WUI_Portrait, false)
    endif
    if WUI_Resource != null then
        call BlzFrameSetVisible(WUI_Resource, false)
    endif
    if WUI_HeroBar != null then
        call BlzFrameSetVisible(WUI_HeroBar, false)
    endif
    call WUI_HideNativeDeadZone()
    set i = 0
    loop
        exitwhen i >= 5
        set cover = BlzGetOriginFrame(ORIGIN_FRAME_MINIMAP_BUTTON, i)
        if cover != null then
            call BlzFrameSetVisible(cover, false)
        endif
        set i = i + 1
    endloop
    if minimap != null then
        call BlzFrameSetVisible(minimap, true)
    endif
    set simpleParent = null
    set itemParent = null
    set detail = null
    set cover = null
    set minimap = null
endfunction

private function WUI_CreateControls takes nothing returns nothing
    local integer i = 0
    local framehandle text
    local framehandle back
    local framehandle label
    local trigger events = CreateTrigger()
    set WUI_Console = BlzGetFrameByName("ConsoleUIBackdrop", 0)
    set WUI_Portrait = BlzGetOriginFrame(ORIGIN_FRAME_PORTRAIT, 0)
    set WUI_Resource = BlzGetFrameByName("ResourceBarFrame", 0)
    set WUI_HeroBar = BlzGetOriginFrame(ORIGIN_FRAME_HERO_BAR, 0)
    set WUI_Buffs = BlzGetOriginFrame(ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR, 0)
    // A native SimpleFontString cannot safely receive visibility/alpha calls.
    set label = BlzGetOriginFrame(ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR_LABEL, 0)
    if label != null then
        call BlzFrameSetText(label, "")
    endif
    if WUI_SimpleRoot != null then
        if BlzFrameGetChildrenCount(WUI_SimpleRoot) > 5 then
            set WUI_DeadZone = BlzFrameGetChild(WUI_SimpleRoot, 5)
        endif
    endif
    loop
        exitwhen i >= 12
        set WUI_Command[i] = BlzGetFrameByName("CommandButton_" + I2S(i), 0)
        if WUI_Command[i] == null then
            set WUI_Command[i] = BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON, i)
        endif
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= 6
        set WUI_Item[i] = BlzGetFrameByName("InventoryButton_" + I2S(i), 0)
        if WUI_Item[i] == null then
            set WUI_Item[i] = BlzGetOriginFrame(ORIGIN_FRAME_ITEM_BUTTON, i)
        endif
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= 4
        set WUI_System[i] = BlzGetOriginFrame(ORIGIN_FRAME_SYSTEM_BUTTON, i)
        set i = i + 1
    endloop
    set WUI_Menu = BlzCreateFrameByType("BUTTON", "WOSCompactMenu", WUI_Root, "", 0)
    call WUI_Place(WUI_Menu, 0.780, 0.573, 0.025, 0.025)
    set back = WUI_Panel("WOSMenuBack", WUI_Menu, 0.025, 0.025)
    call BlzFrameSetAllPoints(back, WUI_Menu)
    set text = BlzCreateFrameByType("TEXT", "WOSMenuGlyph", WUI_Menu, "", 0)
    call BlzFrameSetAllPoints(text, WUI_Menu)
    call BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetText(text, "")
    call BlzFrameSetEnable(text, false)
    set i = 0
    loop
        exitwhen i >= 3
        set back = BlzCreateFrameByType("BACKDROP", "WOSMenuLine", WUI_Menu, "", i)
        call WUI_Place(back, 0.780, 0.577 - I2R(i) * 0.004, 0.013, 0.001)
        call BlzFrameSetTexture(back, "Textures\\white.blp", 0, true)
        call BlzFrameSetVertexColor(back, BlzConvertColor(255, 213, 184, 118))
        call BlzFrameSetEnable(back, false)
        set i = i + 1
    endloop
    set WUI_Orders = BlzCreateFrameByType("BUTTON", "WOSOrderDrawer", WUI_Root, "", 0)
    call WUI_Place(WUI_Orders, 0.566, 0.110, 0.090, 0.016)
    set text = BlzCreateFrameByType("TEXT", "WOSOrderDrawerLabel", WUI_Orders, "", 0)
    call BlzFrameSetAllPoints(text, WUI_Orders)
    call BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(text, 0.60)
    call BlzFrameSetText(text, "|cffd5b876Orders / Learn|r")
    call BlzFrameSetEnable(text, false)
    call BlzTriggerRegisterFrameEvent(events, WUI_Menu, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(events, WUI_Orders, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(events, function WUI_ControlClick)
    set i = 0
    loop
        exitwhen i >= 4
        call WUI_Place(WUI_System[i], -0.20, -0.20, 0.110, 0.021)
        set i = i + 1
    endloop
    set text = null
    set back = null
    set label = null
    set events = null
endfunction

private function WUI_TestClick takes nothing returns nothing
    if GetLocalPlayer() == GetTriggerPlayer() then
        set WUI_TestOpen = not WUI_TestOpen
        call BlzFrameSetVisible(WUI_TestPanel, WUI_TestOpen)
        call BlzFrameSetEnable(WUI_TestToggle, false)
        call BlzFrameSetEnable(WUI_TestToggle, true)
    endif
endfunction

function WUI_ShowTestHelp takes boolean enabled returns nothing
    call BlzFrameSetVisible(WUI_TestToggle, enabled)
    call BlzFrameSetVisible(WUI_TestPanel, enabled and WUI_TestOpen)
endfunction

private function WUI_CreateTestHelp takes nothing returns nothing
    local framehandle title
    local framehandle text
    local trigger events = CreateTrigger()
    local string help = "|cffd5b876UNITS & RECOVERY|r|nLeft / Right: create enemy / hurt ally.|nDown / Up: self root / stun for 2s.|nEsc: restore HP, MP and cooldowns.|nHold Esc (0.15s+): maximum level.|n|n"
    set help = help + "|cffd5b876SELECTED UNIT|r|n-lvl X: set level (example: -lvl 35).|n-pr X / -mr X: set physical / magical resistance %.|n-hp X / -mp X: set current HP / MP.|n-X: play animation X (example: -0).|nBuy items for a selected enemy in the shop.|n|n"
    set help = help + "|cffd5b876TEST EFFECTS|r|n-slow: self slow 50%, 4s.|n-silence: self silence, 3s.|n-sukuna: summon the round ender.|n-killme: kill your hero after a delay.|n|n"
    set help = help + "|cffd5b876WINDOWS & HOTKEYS|r|nTab: shop; use Auto-buy for recommended items.|nF2: statistics.|nF3 / F4: clear / load damage statistics.|nHold Z, select a sector, release: team ping.|nK: emotes.|n|n"
    set help = help + "|cffd5b876ELEMENTS|r|nFire: 40 magic damage/s, 5s.|nWater: 100 damage on apply, 10% slow, 5s.|nLightning: after 5s, stun 0.6s and burn 120 mana.|nFire + Water: 1.5 x main stat damage, +10% physical damage taken, 8s.|nFire + Lightning: 1.5 x main stat damage, stun 1.25s, 2.5s lockout.|nLightning + Water: 10% slow, 0.4 x main stat damage/s, 5s."
    set WUI_TestPanel = WUI_Panel("WOSTestHelpPanel", WUI_Root, 0.192, 0.246)
    call WUI_Place(WUI_TestPanel, 0.694, 0.325, 0.192, 0.246)
    set text = BlzCreateFrame("EscMenuTextAreaTemplate", WUI_TestPanel, 0, 9020)
    call WUI_Place(text, 0.694, 0.325, 0.182, 0.234)
    call BlzFrameSetText(text, help)
    call BlzFrameSetScale(text, 0.78)
    set WUI_TestToggle = BlzCreateFrameByType("BUTTON", "WOSTestHelpToggle", WUI_Root, "", 0)
    call WUI_Place(WUI_TestToggle, 0.694, 0.459, 0.192, 0.021)
    set title = WUI_Panel("WOSTestHelpHeading", WUI_TestToggle, 0.192, 0.021)
    call BlzFrameSetAllPoints(title, WUI_TestToggle)
    set title = BlzCreateFrameByType("TEXT", "WOSTestHelpTitle", WUI_TestToggle, "", 0)
    call BlzFrameSetAllPoints(title, WUI_TestToggle)
    call BlzFrameSetTextAlignment(title, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(title, 0.72)
    call BlzFrameSetText(title, "|cffd5b876TEST COMMANDS|r  +/-")
    call BlzFrameSetEnable(title, false)
    call BlzTriggerRegisterFrameEvent(events, WUI_TestToggle, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(events, function WUI_TestClick)
    call WUI_ShowTestHelp(false)
    set title = null
    set text = null
    set events = null
endfunction

private function WUI_Bootstrap takes nothing returns nothing
    local framehandle board
    local framehandle part
    local integer index = 1
    call DestroyTimer(WUI_BootTimer)
    set WUI_BootTimer = null
    set WUI_SimpleRoot = BlzGetFrameByName("ConsoleUI", 0)
    // Keep the service board ROOT visible: hidden parents hide their children.
    // Its visual children alone are hidden. No players' existing boards are replaced.
    set WUI_ServiceBoard = CreateLeaderboardBJ(bj_FORCE_ALL_PLAYERS, "WOS UI")
    call LeaderboardSetSizeByItemCount(WUI_ServiceBoard, 0)
    call LeaderboardDisplay(WUI_ServiceBoard, true)
    set board = BlzGetFrameByName("Leaderboard", 0)
    if board == null then
        set board = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
    else
        call BlzFrameSetSize(board, 0.00, 0.00)
        set part = BlzGetFrameByName("LeaderboardBackdrop", 0)
        if part != null then
            call BlzFrameSetVisible(part, false)
        endif
        set part = BlzGetFrameByName("LeaderboardTitle", 0)
        if part != null then
            call BlzFrameSetText(part, "")
        endif
    endif
    set WUI_Root = BlzCreateFrameByType("FRAME", "WOSIndependentRoot", board, "", 0)
    call BlzFrameSetAbsPoint(WUI_Root, FRAMEPOINT_BOTTOMLEFT, 0.00, 0.00)
    call BlzFrameSetAbsPoint(WUI_Root, FRAMEPOINT_TOPRIGHT, 0.80, 0.60)
    call BlzFrameSetEnable(WUI_Root, false)
    call BlzFrameSetVisible(WUI_Root, true)
    call WUI_CreateTestHelp()
    call WUI_CreateControls()
    set WUI_Ready = true
    loop
        exitwhen index > WUI_ReadyCount
        call TriggerExecute(WUI_ReadyOwner[index])
        call DestroyTrigger(WUI_ReadyOwner[index])
        set WUI_ReadyOwner[index] = null
        set index = index + 1
    endloop
    set WUI_ReadyCount = 0
    call TimerStart(WUI_DockTimer, 0.10, true, function WUI_RefreshDocks)
    set board = null
    set part = null
endfunction

private function WUI_Init takes nothing returns nothing
    call TimerStart(WUI_BootTimer, 0.10, false, function WUI_Bootstrap)
endfunction

endlibrary
