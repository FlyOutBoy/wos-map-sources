library WOSUI initializer WUI_Init

// Normal FRAME root only. Native SIMPLEFRAME commands/items keep their own tree.
globals
    private leaderboard WUI_ServiceBoard = null
    private framehandle WUI_Root = null
    private framehandle WUI_SimpleRoot = null
    private boolean WUI_FrameDefinitionsReady = false
    private framehandle WUI_NativeBack = null
    private framehandle array WUI_EmptyAbility
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
    private framehandle WUI_TestText = null
    private framehandle WUI_TestPrevious = null
    private framehandle WUI_TestNext = null
    private framehandle WUI_TestPageLabel = null
    private string array WUI_TestPage
    private integer WUI_TestPageIndex = 0
    private boolean WUI_TestOpen = true
    private boolean WUI_TestEnabled = false
    private integer WUI_ModalCount = 0
    private framehandle array WUI_Modal
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
    private framehandle WUI_CommandBar = null
    private framehandle WUI_NativeDetail = null
    private framehandle WUI_NativeDetailParent = null
    private framehandle WUI_TopConsole = null
    private framehandle WUI_BottomConsole = null
    private framehandle WUI_NativeTooltip = null
    private timer WUI_NativeTimer = CreateTimer()
    private boolean WUI_NativeReady = false
    private hashtable WUI_Fills = InitHashtable()
    private hashtable WUI_ButtonStyle = InitHashtable()
    private trigger WUI_ButtonEvents = null
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

// BACKDROP containers never track mouse input. This remains true even if custom
// FDF loading fails. Vertex tint hides only their own image, never their children.
function WUI_Passive takes string name, framehandle parent returns framehandle
    local framehandle container = BlzCreateFrameByType("BACKDROP", name, parent, "", 0)
    call BlzFrameSetTexture(container, "Textures\\white.blp", 0, true)
    call BlzFrameSetVertexColor(container, BlzConvertColor(0, 255, 255, 255))
    return container
endfunction

function WUI_Place takes framehandle frame, real x, real y, real width, real height returns nothing
    if frame != null then
        call BlzFrameClearAllPoints(frame)
        call BlzFrameSetAbsPoint(frame, FRAMEPOINT_CENTER, x, y)
        call BlzFrameSetSize(frame, width, height)
    endif
endfunction

// Six existing toolbar actions share one grid and one mouse-target size.
function WUI_PlaceToolbar takes framehandle control, integer column, integer row returns nothing
    call WUI_Place(control, 0.718 + I2R(column) * 0.026, 0.060 - I2R(row) * 0.028, 0.020, 0.020)
endfunction

// Native wrappers contain fixed-size art, cooldowns, hotkeys and mouse buttons.
// Resize the entire wrapper subtree; changing just its width leaves stock art.
function WUI_PlaceNativeButton takes framehandle control, real x, real y, real size returns nothing
    if control != null then
        call BlzFrameSetScale(control, size / 0.039)
        call WUI_Place(control, x, y, 0.039, 0.039)
    endif
endfunction

function WUI_Panel takes string name, framehandle parent, real width, real height returns framehandle
    local framehandle panel = BlzCreateFrameByType("BACKDROP", name, parent, "", 0)
    call BlzFrameSetSize(panel, width, height)
    call BlzFrameSetTexture(panel, WUI_PANEL_TEXTURE, 0, true)
    return panel
endfunction

// Textured bars belong to the normal FRAME family with their HUD/text parent.
// STATUSBAR is an animated model; it cannot display a fill texture this way.
function WUI_CreateFill takes string name, framehandle parent, real width, real height, real maximum, string texture returns framehandle
    local framehandle fill = BlzCreateFrameByType("BACKDROP", name, parent, "", 0)
    local integer key = GetHandleId(fill)
    call BlzFrameSetTexture(fill, texture, 0, true)
    call BlzFrameSetSize(fill, width, height)
    call BlzFrameSetEnable(fill, false)
    call SaveReal(WUI_Fills, key, 0, maximum)
    call SaveReal(WUI_Fills, key, 1, width)
    call SaveReal(WUI_Fills, key, 2, height)
    call SaveReal(WUI_Fills, key, 3, maximum)
    return fill
endfunction

function WUI_Border takes string name, framehandle owner returns framehandle
    local framehandle edge = BlzCreateFrameByType("BACKDROP", name, owner, "", 0)
    call BlzFrameSetAllPoints(edge, owner)
    call BlzFrameSetTexture(edge, WUI_BORDER_TEXTURE, 0, true)
    call BlzFrameSetEnable(edge, false)
    return edge
endfunction

// Eight independently anchored slices keep the generated metal corners square.
// Decorations are passive normal frames; never reparent native SIMPLEFRAMEs.
function WUI_OrnateBorder takes string name, framehandle owner, real corner returns framehandle
    local framehandle edge = WUI_Passive(name, owner)
    local framehandle piece
    local integer i = 0
    local framepointtype anchor
    local string texture
    call BlzFrameSetAllPoints(edge, owner)
    call BlzFrameSetEnable(edge, false)
    loop
        exitwhen i >= 4
        if i == 0 then
            set anchor = FRAMEPOINT_TOPLEFT
            set texture = "tl"
        elseif i == 1 then
            set anchor = FRAMEPOINT_TOPRIGHT
            set texture = "tr"
        elseif i == 2 then
            set anchor = FRAMEPOINT_BOTTOMLEFT
            set texture = "bl"
        else
            set anchor = FRAMEPOINT_BOTTOMRIGHT
            set texture = "br"
        endif
        set piece = BlzCreateFrameByType("BACKDROP", name + texture, edge, "", i)
        call BlzFrameSetPoint(piece, anchor, edge, anchor, 0.00, 0.00)
        call BlzFrameSetSize(piece, corner, corner)
        call BlzFrameSetTexture(piece, "UI\\WOS\\ornate-" + texture + ".tga", 0, true)
        call BlzFrameSetEnable(piece, false)
        set i = i + 1
    endloop
    set piece = BlzCreateFrameByType("BACKDROP", name + "Top", edge, "", 0)
    call BlzFrameSetPoint(piece, FRAMEPOINT_TOPLEFT, edge, FRAMEPOINT_TOPLEFT, corner, -corner * 0.20)
    call BlzFrameSetPoint(piece, FRAMEPOINT_TOPRIGHT, edge, FRAMEPOINT_TOPRIGHT, -corner, -corner * 0.20)
    call BlzFrameSetSize(piece, 0.00, corner * 0.16)
    call BlzFrameSetTexture(piece, "UI\\WOS\\ornate-top.tga", 0, true)
    call BlzFrameSetEnable(piece, false)
    set piece = BlzCreateFrameByType("BACKDROP", name + "Bottom", edge, "", 0)
    call BlzFrameSetPoint(piece, FRAMEPOINT_BOTTOMLEFT, edge, FRAMEPOINT_BOTTOMLEFT, corner, corner * 0.28)
    call BlzFrameSetPoint(piece, FRAMEPOINT_BOTTOMRIGHT, edge, FRAMEPOINT_BOTTOMRIGHT, -corner, corner * 0.28)
    call BlzFrameSetSize(piece, 0.00, corner * 0.16)
    call BlzFrameSetTexture(piece, "UI\\WOS\\ornate-bottom.tga", 0, true)
    call BlzFrameSetEnable(piece, false)
    set piece = BlzCreateFrameByType("BACKDROP", name + "Left", edge, "", 0)
    call BlzFrameSetPoint(piece, FRAMEPOINT_TOPLEFT, edge, FRAMEPOINT_TOPLEFT, corner * 0.12, -corner)
    call BlzFrameSetPoint(piece, FRAMEPOINT_BOTTOMLEFT, edge, FRAMEPOINT_BOTTOMLEFT, corner * 0.12, corner)
    call BlzFrameSetSize(piece, corner * 0.16, 0.00)
    call BlzFrameSetTexture(piece, "UI\\WOS\\ornate-left.tga", 0, true)
    call BlzFrameSetEnable(piece, false)
    set piece = BlzCreateFrameByType("BACKDROP", name + "Right", edge, "", 0)
    call BlzFrameSetPoint(piece, FRAMEPOINT_TOPRIGHT, edge, FRAMEPOINT_TOPRIGHT, -corner * 0.12, -corner)
    call BlzFrameSetPoint(piece, FRAMEPOINT_BOTTOMRIGHT, edge, FRAMEPOINT_BOTTOMRIGHT, -corner * 0.12, corner)
    call BlzFrameSetSize(piece, corner * 0.16, 0.00)
    call BlzFrameSetTexture(piece, "UI\\WOS\\ornate-right.tga", 0, true)
    call BlzFrameSetEnable(piece, false)
    set piece = null
    set anchor = null
    return edge
endfunction

// Window backgrounds sit inside the metal rails instead of beyond their inset.
// The expanded ornament bounds are presentation-only and never a hit rectangle.
function WUI_OrnateWindow takes string name, framehandle owner, real corner returns framehandle
    local framehandle edge = WUI_OrnateBorder(name, owner, corner * 1.10)
    call BlzFrameClearAllPoints(edge)
    call BlzFrameSetPoint(edge, FRAMEPOINT_TOPLEFT, owner, FRAMEPOINT_TOPLEFT, -corner * 0.35, corner * 0.35)
    call BlzFrameSetPoint(edge, FRAMEPOINT_BOTTOMRIGHT, owner, FRAMEPOINT_BOTTOMRIGHT, corner * 0.35, -corner * 0.35)
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
    if HaveSavedReal(WUI_Fills, GetHandleId(bar), 0) then
        call BlzFrameClearAllPoints(bar)
        call BlzFrameSetPoint(bar, FRAMEPOINT_LEFT, panel, FRAMEPOINT_CENTER, -0.040, -0.004)
    else
        call WUI_Pin(bar, panel, 0.012, -0.004, 0.104, 0.007)
    endif
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

function WUI_RegisterModal takes framehandle panel returns nothing
    set WUI_ModalCount = WUI_ModalCount + 1
    set WUI_Modal[WUI_ModalCount] = panel
endfunction

private function WUI_RefreshHelpVisibility takes nothing returns nothing
    local integer i = 1
    local boolean visible = WUI_TestEnabled
    loop
        exitwhen i > WUI_ModalCount
        if WUI_Modal[i] != null and BlzFrameIsVisible(WUI_Modal[i]) then
            set visible = false
        endif
        set i = i + 1
    endloop
    call BlzFrameSetVisible(WUI_TestToggle, visible)
    call BlzFrameSetVisible(WUI_TestPanel, visible and WUI_TestOpen)
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
    call WUI_RefreshHelpVisibility()
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
    local integer key = GetHandleId(frame)
    local real maximum
    if HaveSavedReal(WUI_Fills, key, 0) then
        set maximum = LoadReal(WUI_Fills, key, 0)
        set value = RMaxBJ(0.00, RMinBJ(maximum, value))
        if LoadReal(WUI_Fills, key, 3) != value then
            call BlzFrameSetSize(frame, LoadReal(WUI_Fills, key, 1) * value / RMaxBJ(0.01, maximum), LoadReal(WUI_Fills, key, 2))
            call SaveReal(WUI_Fills, key, 3, value)
        endif
    elseif BlzFrameGetValue(frame) != value then
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
        set bar = WUI_CreateFill("WOSMeterFill", panel, 0.104, 0.007, maximum, "UI\\WOS\\meter.tga")
        set icon = BlzCreateFrameByType("BACKDROP", "WOSMeterIcon", panel, "", 0)
        set title = BlzCreateFrameByType("TEXT", "WOSMeterTitle", panel, "", 0)
        set value = BlzCreateFrameByType("TEXT", "WOSMeterValue", panel, "", 0)
        call BlzFrameSetTexture(icon, iconPath, 0, true)
        call BlzFrameSetText(title, WUI_GOLD + caption + "|r")
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
        call FlushChildHashtable(WUI_Fills, GetHandleId(bar))
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
        exitwhen i >= 7
        if WUI_EmptyAbility[i] != null then
            call BlzFrameSetVisible(WUI_EmptyAbility[i], compact)
        endif
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i >= 12
        if compact and i < 5 and not WUI_OrdersOpen then
            call WUI_PlaceNativeButton(WUI_Command[i], -0.20, -0.20, WUI_ICON_SIZE)
        elseif compact and i < 5 then
            call WUI_PlaceNativeButton(WUI_Command[i], WUI_COMMAND_X + I2R(i) * WUI_COMMAND_STEP, 0.139, WUI_ICON_SIZE)
        elseif not compact then
            // Ordinary units, shop and learn cards retain access to all 12 slots.
            set y = 0.016
            if i < 6 then
                set y = 0.047
            endif
            // Both rows remain below MP; alternative cards cannot cover vitals.
            call WUI_PlaceNativeButton(WUI_Command[i], WUI_COMMAND_X + I2R(ModuloInteger(i, 6)) * WUI_COMMAND_STEP, y, 0.028)
        endif
        set i = i + 1
    endloop
    if compact then
        set slot = 0
        loop
            exitwhen slot >= 7
            call WUI_PlaceNativeButton(WUI_Command[WUI_CommandSlot(slot)], WUI_COMMAND_X + I2R(slot) * WUI_COMMAND_STEP, WUI_HUD_Y, WUI_ICON_SIZE)
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
                    call WUI_Place(WUI_System[i], 0.730, 0.509 - I2R(i) * 0.025, 0.110, 0.021)
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

private function WUI_CacheNativeSlots takes nothing returns nothing
    local integer i = 0
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
endfunction

function WUI_InstallNativeLayout takes nothing returns nothing
    local integer i = 0
    local framehandle detail = BlzGetFrameByName("SimpleInfoPanelUnitDetail", 0)
    local framehandle cover = BlzGetFrameByName("SimpleInventoryCover", 0)
    local framehandle minimap = BlzGetOriginFrame(ORIGIN_FRAME_MINIMAP, 0)
    local framehandle label = BlzGetFrameByName("InventoryText", 0)
    local framehandle systemBar = BlzGetFrameByName("UpperButtonBarFrame", 0)
    if WUI_NativeReady or WUI_SimpleRoot == null then
        set detail = null
        set cover = null
        set minimap = null
        return
    endif
    set WUI_CommandBar = BlzGetFrameByName("CommandBarFrame", 0)
    if detail != null then
        set WUI_NativeDetailParent = BlzFrameGetParent(detail)
    endif
    // Reforged 2+ puts the whole stock lower UI under ConsoleBottomBar.
    // Never infer/reparent a container from one command/item slot: those may
    // not exist before selection, or its immediate parent may be a wrapper.
    if WUI_CommandBar == null or WUI_NativeDetailParent == null then
        set detail = null
        set cover = null
        set minimap = null
        return
    endif
    call WUI_CacheNativeSlots()
    // Do not move a SIMPLEFRAME into the normal FRAME hierarchy.
    call BlzFrameSetParent(WUI_CommandBar, WUI_SimpleRoot)
    call BlzFrameSetParent(WUI_NativeDetailParent, WUI_SimpleRoot)
    call BlzFrameSetLevel(WUI_CommandBar, 2)
    call BlzFrameSetLevel(WUI_NativeDetailParent, 2)
    if systemBar != null then
        call BlzFrameSetParent(systemBar, WUI_SimpleRoot)
    endif
    if WUI_NativeTooltip != null then
        call BlzFrameSetParent(WUI_NativeTooltip, WUI_SimpleRoot)
    endif
    set WUI_HiddenDetails = BlzCreateFrameByType("SIMPLEFRAME", "WOSHiddenNativeDetails", WUI_SimpleRoot, "", 0)
    call BlzFrameSetVisible(WUI_HiddenDetails, false)
    if detail != null then
        // Keep real status icons/tooltips when the large unit detail panel is hidden.
        if WUI_Buffs != null then
            call BlzFrameSetParent(WUI_Buffs, WUI_SimpleRoot)
            call WUI_Place(WUI_Buffs, 0.245, 0.113, 0.165, 0.016)
        endif
        call BlzFrameSetParent(detail, WUI_HiddenDetails)
    endif
    if cover != null then
        call BlzFrameSetAlpha(cover, 0)
    endif
    if label != null then
        call BlzFrameSetText(label, "")
    endif
    call BlzEnableUIAutoPosition(false)
    if minimap != null then
        call BlzFrameClearAllPoints(minimap)
        call BlzFrameSetAbsPoint(minimap, FRAMEPOINT_BOTTOMLEFT, 0.004, 0.004)
        call BlzFrameSetAbsPoint(minimap, FRAMEPOINT_TOPRIGHT, 0.144, 0.144)
    endif
    loop
        exitwhen i >= 6
        call WUI_PlaceNativeButton(WUI_Item[i], 0.630 + I2R(ModuloInteger(i, 3)) * 0.025, 0.062 - I2R(i / 3) * 0.027, 0.022)
        set i = i + 1
    endloop
    if WUI_Console != null then
        call BlzFrameSetVisible(WUI_Console, false)
    endif
    if WUI_TopConsole != null then
        call BlzFrameSetVisible(WUI_TopConsole, false)
    endif
    if WUI_BottomConsole != null then
        call BlzFrameSetVisible(WUI_BottomConsole, false)
    endif
    call BlzFrameSetVisible(WUI_CommandBar, true)
    call BlzFrameSetVisible(WUI_NativeDetailParent, true)
    if systemBar != null then
        call BlzFrameSetVisible(systemBar, true)
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
    set WUI_NativeReady = true
    set detail = null
    set cover = null
    set minimap = null
    set systemBar = null
endfunction

function WUI_SetButtonCaption takes framehandle control, string caption returns nothing
    call BlzFrameSetText(LoadFrameHandle(WUI_ButtonStyle, GetHandleId(control), 1), WUI_TEXT + caption + "|r")
endfunction

// Placeholder overlays never intercept orders. Empty/unlearned logical slots
// move the native occupant out of the row (including the stock learn button).
function WUI_ShowNativeAbilitySlot takes integer slot, boolean visible returns nothing
    if not WUI_CompactCommands or slot < 0 or slot >= 7 then
        return
    endif
    if visible then
        call WUI_PlaceNativeButton(WUI_Command[WUI_CommandSlot(slot)], WUI_COMMAND_X + I2R(slot) * WUI_COMMAND_STEP, WUI_HUD_Y, WUI_ICON_SIZE)
    else
        call WUI_PlaceNativeButton(WUI_Command[WUI_CommandSlot(slot)], -0.20, -0.20, WUI_ICON_SIZE)
    endif
endfunction

function WUI_SetButtonSelected takes framehandle control, boolean selected returns nothing
    local integer key = GetHandleId(control)
    call SaveBoolean(WUI_ButtonStyle, key, 2, selected)
    if selected then
        call BlzFrameSetTexture(LoadFrameHandle(WUI_ButtonStyle, key, 0), "UI\\WOS\\selected.tga", 0, true)
    else
        call BlzFrameSetTexture(LoadFrameHandle(WUI_ButtonStyle, key, 0), "UI\\WOS\\button.tga", 0, true)
    endif
endfunction

private function WUI_ButtonHover takes nothing returns nothing
    local framehandle control = BlzGetTriggerFrame()
    local integer key = GetHandleId(control)
    if GetLocalPlayer() == GetTriggerPlayer() then
        if BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_ENTER then
            call BlzFrameSetTexture(LoadFrameHandle(WUI_ButtonStyle, key, 0), "UI\\WOS\\hover.tga", 0, true)
        else
            call WUI_SetButtonSelected(control, LoadBoolean(WUI_ButtonStyle, key, 2))
        endif
    endif
    set control = null
endfunction

function WUI_TextButton takes string name, framehandle parent, string caption, real width, real height returns framehandle
    local framehandle control = BlzCreateFrameByType("BUTTON", name, parent, "", 0)
    local framehandle back = BlzCreateFrameByType("BACKDROP", name + "Back", control, "", 0)
    local framehandle text = BlzCreateFrameByType("TEXT", name + "Text", control, "", 0)
    call BlzFrameSetSize(control, width, height)
    call BlzFrameSetAllPoints(back, control)
    call BlzFrameSetTexture(back, "UI\\WOS\\button.tga", 0, true)
    call BlzFrameSetEnable(back, false)
    call BlzFrameSetAllPoints(text, control)
    call BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(text, 0.90)
    call BlzFrameSetText(text, WUI_TEXT + caption + "|r")
    call BlzFrameSetEnable(text, false)
    call SaveFrameHandle(WUI_ButtonStyle, GetHandleId(control), 0, back)
    call SaveFrameHandle(WUI_ButtonStyle, GetHandleId(control), 1, text)
    if WUI_ButtonEvents == null then
        set WUI_ButtonEvents = CreateTrigger()
        call TriggerAddAction(WUI_ButtonEvents, function WUI_ButtonHover)
    endif
    call BlzTriggerRegisterFrameEvent(WUI_ButtonEvents, control, FRAMEEVENT_MOUSE_ENTER)
    call BlzTriggerRegisterFrameEvent(WUI_ButtonEvents, control, FRAMEEVENT_MOUSE_LEAVE)
    set back = WUI_OrnateBorder(name + "Metal", control, height * 0.48)
    set back = null
    set text = null
    return control
endfunction

private function WUI_CreateHUDChrome takes nothing returns nothing
    local framehandle panel = WUI_Passive("WOSHUDSurface", WUI_Root)
    local framehandle edge
    local framehandle texture
    local integer slot = 0
    // Normal FRAMEs draw over native SIMPLEFRAME buttons. Their ornament center
    // must remain empty; an opaque chassis is created in the native family.
    if WUI_SimpleRoot != null and WUI_FrameDefinitionsReady then
        set WUI_NativeBack = BlzCreateSimpleFrame("WOSNativeHUDSurface", WUI_SimpleRoot, 9050)
        call WUI_Place(WUI_NativeBack, 0.474, 0.054, 0.640, 0.104)
        call BlzFrameSetLevel(WUI_NativeBack, 1)
        set texture = BlzGetFrameByName("WOSNativeHUDTexture", 9050)
        if texture != null then
            call BlzFrameSetTexture(texture, WUI_PANEL_TEXTURE, 0, true)
        endif
        call BlzFrameSetVisible(WUI_NativeBack, true)
        loop
            exitwhen slot >= 7
            set WUI_EmptyAbility[slot] = BlzCreateSimpleFrame("WOSNativeEmptyAbility", WUI_SimpleRoot, 9060 + slot)
            call WUI_Place(WUI_EmptyAbility[slot], WUI_COMMAND_X + I2R(slot) * WUI_COMMAND_STEP, WUI_HUD_Y, WUI_ICON_SIZE, WUI_ICON_SIZE)
            call BlzFrameSetLevel(WUI_EmptyAbility[slot], 1)
            call BlzFrameSetVisible(WUI_EmptyAbility[slot], WUI_CompactCommands)
            set slot = slot + 1
        endloop
    endif
    call WUI_Place(panel, 0.474, 0.054, 0.640, 0.104)
    call BlzFrameSetEnable(panel, false)
    set edge = WUI_OrnateWindow("WOSHUDMetal", panel, 0.024)
    set panel = WUI_Passive("WOSMinimapSurface", WUI_Root)
    call WUI_Place(panel, 0.074, 0.074, 0.148, 0.148)
    call BlzFrameSetEnable(panel, false)
    set edge = WUI_OrnateBorder("WOSMinimapMetal", panel, 0.025)
    set panel = WUI_Passive("WOSInventorySurface", WUI_Root)
    call WUI_Place(panel, 0.660, 0.049, 0.090, 0.082)
    call BlzFrameSetEnable(panel, false)
    set edge = WUI_OrnateWindow("WOSInventoryMetal", panel, 0.012)
    set panel = WUI_Panel("WOSToolbarSurface", WUI_Root, 0.088, 0.082)
    call WUI_Place(panel, 0.746, 0.049, 0.088, 0.082)
    call BlzFrameSetEnable(panel, false)
    set edge = WUI_OrnateWindow("WOSToolbarMetal", panel, 0.012)
    set panel = null
    set edge = null
    set texture = null
endfunction

private function WUI_TryNativeLayout takes nothing returns nothing
    call WUI_InstallNativeLayout()
    if WUI_NativeReady then
        call PauseTimer(WUI_NativeTimer)
        call WUI_LayoutCommands(WUI_CompactCommands)
    endif
endfunction

function WUI_StartNativeLayout takes nothing returns nothing
    call WUI_TryNativeLayout()
    if not WUI_NativeReady then
        call TimerStart(WUI_NativeTimer, 0.25, true, function WUI_TryNativeLayout)
    endif
endfunction

// Hero-pick/draft owners call BlzHideOriginFrames(false) when returning to play.
// That engine call restores stock bars too; reapply the compact skin afterwards.
function WUI_RestoreCompactNative takes nothing returns nothing
    if not WUI_NativeReady then
        return
    endif
    if WUI_Console != null then
        call BlzFrameSetVisible(WUI_Console, false)
    endif
    if WUI_TopConsole != null then
        call BlzFrameSetVisible(WUI_TopConsole, false)
    endif
    if WUI_BottomConsole != null then
        call BlzFrameSetVisible(WUI_BottomConsole, false)
    endif
    if WUI_Resource != null then
        call BlzFrameSetVisible(WUI_Resource, false)
    endif
    if WUI_HeroBar != null then
        call BlzFrameSetVisible(WUI_HeroBar, false)
    endif
    if WUI_Portrait != null then
        call BlzFrameSetVisible(WUI_Portrait, false)
    endif
    call BlzFrameSetVisible(WUI_CommandBar, true)
    call BlzFrameSetVisible(WUI_NativeDetailParent, true)
    call WUI_HideNativeDeadZone()
    if WUI_NativeBack != null then
        call BlzFrameSetVisible(WUI_NativeBack, true)
    endif
    call WUI_LayoutCommands(WUI_CompactCommands)
endfunction

private function WUI_CreateControls takes nothing returns nothing
    local integer i = 0
    local framehandle text
    local framehandle back
    local framehandle label
    local trigger events = CreateTrigger()
    set WUI_Console = BlzGetFrameByName("ConsoleUIBackdrop", 0)
    set WUI_TopConsole = BlzGetFrameByName("ConsoleTopBar", 0)
    set WUI_BottomConsole = BlzGetFrameByName("ConsoleBottomBar", 0)
    set WUI_NativeTooltip = BlzGetOriginFrame(ORIGIN_FRAME_UBERTOOLTIP, 0)
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
    call WUI_CacheNativeSlots()
    set i = 0
    loop
        exitwhen i >= 4
        set WUI_System[i] = BlzGetOriginFrame(ORIGIN_FRAME_SYSTEM_BUTTON, i)
        set i = i + 1
    endloop
    set WUI_Menu = BlzCreateFrameByType("BUTTON", "WOSCompactMenu", WUI_Root, "", 0)
    call WUI_Place(WUI_Menu, 0.653, 0.548, 0.025, 0.025)
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
        call WUI_Place(back, 0.653, 0.552 - I2R(i) * 0.004, 0.013, 0.001)
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
    call BlzFrameSetScale(text, 0.80)
    call BlzFrameSetText(text, "|cffd5b876Orders|r")
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
    set WUI_TestEnabled = enabled
    call WUI_RefreshHelpVisibility()
endfunction

private function WUI_TestScroll takes nothing returns nothing
    if GetLocalPlayer() == GetTriggerPlayer() then
        if BlzGetTriggerFrame() == WUI_TestPrevious or (BlzGetTriggerFrame() == WUI_TestPanel and BlzGetTriggerFrameValue() > 0.00) then
            set WUI_TestPageIndex = IMaxBJ(0, WUI_TestPageIndex - 1)
        else
            set WUI_TestPageIndex = IMinBJ(4, WUI_TestPageIndex + 1)
        endif
        call WUI_SetText(WUI_TestText, WUI_TestPage[WUI_TestPageIndex])
        call WUI_SetText(WUI_TestPageLabel, I2S(WUI_TestPageIndex + 1) + " / 5 - Scroll to browse")
    endif
endfunction

private function WUI_CreateTestHelp takes nothing returns nothing
    local framehandle back
    local trigger events = CreateTrigger()
    local trigger scroll = CreateTrigger()
    set WUI_TestPage[0] = "|cffd5b876UNITS & RECOVERY|r|n|nLeft / Right: create enemy / hurt ally.|n|nDown / Up: self root / stun for 2s.|n|nEsc: restore HP, MP and cooldowns.|n|nHold Esc (0.15s+): maximum level."
    set WUI_TestPage[1] = "|cffd5b876SELECTED UNIT|r|n|n-lvl X: set level (example: -lvl 35).|n|n-pr X / -mr X: set physical / magical resistance %.|n|n-hp X / -mp X: set current HP / MP.|n|n-X: play animation X (example: -0).|n|nBuy items for a selected enemy in the shop."
    set WUI_TestPage[2] = "|cffd5b876TEST EFFECTS|r|n|n-slow: self slow 50%, 4s.|n|n-silence: self silence, 3s.|n|n-sukuna: summon the round ender.|n|n-killme: kill your hero after a delay."
    set WUI_TestPage[3] = "|cffd5b876WINDOWS & HOTKEYS|r|n|nTab: shop; use Auto-buy for recommended items.|n|nF2: statistics.|n|nF3 / F4: clear / load damage statistics.|n|nHold Z, select a sector, release: team ping.|n|nK: emotes."
    set WUI_TestPage[4] = "|cffd5b876ELEMENTS|r|n|nFire: 40 magic damage/s, 5s.|nWater: 100 damage on apply, 10% slow, 5s.|nLightning: after 5s, stun 0.6s and burn 120 mana.|n|nFire + Water: 1.5 x main stat damage, +10% physical damage taken, 8s.|n|nFire + Lightning: 1.5 x main stat damage, stun 1.25s, 2.5s lockout.|n|nLightning + Water: 10% slow, 0.4 x main stat damage/s, 5s."
    // Ordinary text needs no lazy-loaded stock FDF template.
    set WUI_TestPanel = BlzCreateFrameByType("BUTTON", "WOSTestHelpPanel", WUI_Root, "", 0)
    call WUI_Place(WUI_TestPanel, 0.694, 0.325, 0.192, 0.246)
    set back = WUI_Panel("WOSTestHelpBack", WUI_TestPanel, 0.192, 0.246)
    call BlzFrameSetAllPoints(back, WUI_TestPanel)
    call BlzFrameSetEnable(back, false)
    set back = WUI_Border("WOSTestHelpBorder", WUI_TestPanel)
    set WUI_TestText = BlzCreateFrameByType("TEXT", "WOSTestHelpText", WUI_TestPanel, "", 0)
    call WUI_Place(WUI_TestText, 0.694, 0.333, 0.174, 0.208)
    call BlzFrameSetTextAlignment(WUI_TestText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
    call BlzFrameSetScale(WUI_TestText, 0.86)
    call BlzFrameSetText(WUI_TestText, WUI_TestPage[0])
    call BlzFrameSetEnable(WUI_TestText, false)
    set WUI_TestPageLabel = BlzCreateFrameByType("TEXT", "WOSTestPageLabel", WUI_TestPanel, "", 0)
    call WUI_Place(WUI_TestPageLabel, 0.694, 0.212, 0.130, 0.014)
    call BlzFrameSetTextAlignment(WUI_TestPageLabel, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(WUI_TestPageLabel, 0.66)
    call BlzFrameSetText(WUI_TestPageLabel, "1 / 5 - Scroll to browse")
    call BlzFrameSetEnable(WUI_TestPageLabel, false)
    set WUI_TestPrevious = WUI_TextButton("WOSTestPrevious", WUI_TestPanel, "<", 0.016, 0.016)
    set WUI_TestNext = WUI_TextButton("WOSTestNext", WUI_TestPanel, ">", 0.016, 0.016)
    call WUI_Place(WUI_TestPrevious, 0.612, 0.212, 0.016, 0.016)
    call WUI_Place(WUI_TestNext, 0.776, 0.212, 0.016, 0.016)
    set WUI_TestToggle = WUI_TextButton("WOSTestHelpToggle", WUI_Root, "TEST COMMANDS  +/-", 0.192, 0.021)
    call WUI_Place(WUI_TestToggle, 0.694, 0.459, 0.192, 0.021)
    call BlzTriggerRegisterFrameEvent(events, WUI_TestToggle, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(events, function WUI_TestClick)
    call BlzTriggerRegisterFrameEvent(scroll, WUI_TestPanel, FRAMEEVENT_MOUSE_WHEEL)
    call BlzTriggerRegisterFrameEvent(scroll, WUI_TestPrevious, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(scroll, WUI_TestNext, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(scroll, function WUI_TestScroll)
    call WUI_ShowTestHelp(false)
    set back = null
    set events = null
    set scroll = null
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
    set WUI_FrameDefinitionsReady = BlzLoadTOCFile("UI\\WOS\\WOSHUD.toc")
    set WUI_Root = WUI_Passive("WOSIndependentRoot", board)
    call WUI_Place(WUI_Root, 0.00, 0.00, 0.0001, 0.0001)
    // Never disable the ancestor of interactive controls.
    call BlzFrameSetEnable(WUI_Root, true)
    call BlzFrameSetVisible(WUI_Root, true)
    call WUI_CreateTestHelp()
    call WUI_CreateControls()
    set WUI_Ready = true
    call WUI_OnReady(function WUI_CreateHUDChrome)
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
