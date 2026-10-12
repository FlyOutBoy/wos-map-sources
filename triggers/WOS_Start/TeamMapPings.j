library TeamMapPings initializer TMP_Init requires GearSystems, WOSUI

// Hold Z over the map, hover a sector; release Z or click to send once.
// Frame state is local; only accepted sync messages update cooldown/effects.
globals
    private constant real TMP_COOLDOWN = 2.50
    private constant real TMP_DURATION = 3.00
    private constant real TMP_PERIOD = 0.05
    private constant real TMP_MINIMAP_NAME_DURATION = 2.00
    private constant real TMP_MINIMAP_NAME_FADE = 0.50
    private constant real TMP_BUTTON_SIZE = 0.150
    private constant real TMP_HOVER_SIZE = 0.170
    private constant integer TMP_MAX_EFFECTS = 40
    private constant integer TMP_KINDS = 5
    private constant real TMP_TARGET_RADIUS = 500.00
    private constant string TMP_SYNC = "WOSP"
    private real array TMP_Remaining
    private string array TMP_Label
    private string array TMP_Color
    private string array TMP_Texture
    private string array TMP_Model
    private string array TMP_Symbol
    private string array TMP_MiniTexture
    private real array TMP_Angle
    private integer array TMP_Red
    private integer array TMP_Green
    private integer array TMP_Blue
    private framehandle TMP_Panel = null
    private framehandle TMP_Wheel = null
    private framehandle TMP_Hint = null
    private framehandle TMP_Status = null
    private framehandle TMP_Toggle = null
    private framehandle TMP_ToggleIcon = null
    private framehandle TMP_ToggleText = null
    private integer TMP_ToggleState = 0
    private framehandle array TMP_Button
    private framehandle array TMP_Name
    private framehandle TMP_Minimap = null
    private framehandle array TMP_MiniNameRoot
    private framehandle array TMP_MiniNameBack
    private framehandle array TMP_MiniName
    private framehandle array TMP_MiniIcon
    private real array TMP_MiniRemaining
    private boolean TMP_Muted = false
    private group TMP_TargetGroup = null
    private boolean TMP_ZHeld = false
    private string TMP_LastMessage = ""
    // Local clock of the last ping-key event: a held key auto-repeats, so a
    // press after a long gap means the release was lost (chat, focus, alt-tab).
    private real TMP_Clock = 0.00
    private real TMP_KeyTime = 0.00
    private boolean TMP_HasPoint = false
    // Mouse-move is a synced event: it exists only for a player holding the
    // ping key (created on press, destroyed on release / Esc).
    private trigger array TMP_MoveTrigger
    private boolean TMP_Open = false
    private integer TMP_Hover = 0
    private real TMP_PointX = 0.00
    private real TMP_PointY = 0.00
    private real TMP_CenterX = 0.40
    private real TMP_CenterY = 0.32
    private real array TMP_OffsetX
    private real array TMP_OffsetY
    private timer TMP_Timer = null
    private integer TMP_Count = 0
    private effect array TMP_Effect
    private effect array TMP_Ring
    private texttag array TMP_WorldName
    private texttag array TMP_FogSymbol
    private integer array TMP_Sender
    private integer array TMP_Kind
    private boolean array TMP_Delivered
    private real array TMP_BaseScale
    private real array TMP_X
    private real array TMP_Y
    private real array TMP_Age
endglobals

private function TMP_CanSend takes player sender returns boolean
    local integer pid = GetPlayerId(sender)
    return pid >= 0 and pid < 10 and GetPlayerSlotState(sender) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(sender) == MAP_CONTROL_USER
endfunction

private function TMP_IsRecipient takes player sender, player viewer returns boolean
    return sender == viewer or IsPlayerAlly(viewer, sender)
endfunction

private function TMP_FindTarget takes player sender, real x, real y returns unit
    local unit u
    local unit best = null
    local boolean hero
    local boolean bestHero = false
    local real distance
    local real bestDistance = TMP_TARGET_RADIUS * TMP_TARGET_RADIUS + 1.00
    call GroupEnumUnitsInRange(TMP_TargetGroup, x, y, TMP_TARGET_RADIUS, null)
    loop
        set u = FirstOfGroup(TMP_TargetGroup)
        exitwhen u == null
        call GroupRemoveUnit(TMP_TargetGroup, u)
        if GetWidgetLife(u) > 0.405 and not IsUnitHidden(u) and IsUnitEnemy(u, sender) and IsUnitVisible(u, sender) and IsUnitDetected(u, sender) then
            set hero = IsUnitType(u, UNIT_TYPE_HERO)
            set distance = (GetUnitX(u) - x) * (GetUnitX(u) - x) + (GetUnitY(u) - y) * (GetUnitY(u) - y)
            // Real heroes and hero illusions have exactly the same priority.
            // No illusion, buff, mana, inventory or hidden ability checks here.
            if best == null or (hero and not bestHero) or (hero == bestHero and distance < bestDistance) then
                set best = u
                set bestHero = hero
                set bestDistance = distance
            endif
        endif
    endloop
    set u = null
    return best
endfunction

private function TMP_ActionText takes integer kind, unit target returns string
    local string name
    if target != null and IsUnitVisible(target, GetLocalPlayer()) and IsUnitDetected(target, GetLocalPlayer()) then
        set name = GetUnitName(target)
        if kind == 1 then
            return "On my way to " + name
        elseif kind == 2 then
            return "Attack " + name
        elseif kind == 3 then
            return "Beware of " + name
        endif
    endif
    return TMP_Label[kind]
endfunction

private function TMP_SetHover takes integer kind, boolean active returns nothing
    local real size = TMP_BUTTON_SIZE
    local real labelRadius = 0.065
    if active then
        set size = TMP_HOVER_SIZE
        set labelRadius = labelRadius * 1.25
    endif
    // Grow around the fixed center, so leaving restores the original hit area.
    call BlzFrameSetSize(TMP_Button[kind], size, size)
    call BlzFrameClearAllPoints(TMP_Name[kind])
    call BlzFrameSetPoint(TMP_Name[kind], FRAMEPOINT_CENTER, TMP_Panel, FRAMEPOINT_CENTER, labelRadius * Cos(TMP_Angle[kind]), labelRadius * Sin(TMP_Angle[kind]))
    // Checkpoint 27b: idle sectors clearly translucent, the hovered one fully
    // saturated; leaving it restores the idle look.
    call BlzFrameSetAlpha(TMP_Button[kind], 120)
    if active then
        call BlzFrameSetAlpha(TMP_Button[kind], 255)
        call BlzFrameSetLevel(TMP_Button[kind], 3)
        call BlzFrameSetText(TMP_Status, TMP_Color[kind] + TMP_Label[kind] + "|r")
    else
        call BlzFrameSetLevel(TMP_Button[kind], 2)
    endif
endfunction

private function TMP_Close takes nothing returns nothing
    local integer kind = 1
    set TMP_Open = false
    set TMP_Hover = 0
    call BlzFrameSetVisible(TMP_Panel, false)
    loop
        exitwhen kind > TMP_KINDS
        call TMP_SetHover(kind, false)
        set kind = kind + 1
    endloop
    call BlzFrameSetVisible(TMP_Hint, false)
endfunction

private function TMP_ShowWheel takes nothing returns nothing
    local integer pid = GetPlayerId(GetLocalPlayer())
    call TMP_Close()
    if not TMP_CanSend(GetLocalPlayer()) then
        return
    endif
    // Checkpoint 27: on cooldown the wheel still opens and shows the time in
    // its centre (like the emote wheel) instead of a chat line.
    set TMP_Open = true
    // Keep the entire wheel and its labels in the playable screen area.
    set TMP_CenterX = RMaxBJ(0.13, RMinBJ(0.67, BlzPixelToFrameX(BlzGetMouseScreenPosX())))
    set TMP_CenterY = RMaxBJ(0.27, RMinBJ(0.46, BlzPixelToFrameY(BlzGetMouseScreenPosY())))
    call BlzFrameClearAllPoints(TMP_Panel)
    call BlzFrameSetAbsPoint(TMP_Panel, FRAMEPOINT_CENTER, TMP_CenterX, TMP_CenterY)
    if TMP_Remaining[pid] > 0.00 then
        call BlzFrameSetText(TMP_Status, "|cffffcc00" + R2SW(TMP_Remaining[pid], 0, 1) + "s|r")
    else
        call BlzFrameSetText(TMP_Status, WUI_GOLD + "Select|norder|r")
    endif
    call BlzFrameSetText(TMP_Hint, "|cffd5b876Hold " + WUI_GetHotkeyName(WUI_HOTKEY_PING, pid) + "|r  ·  Hover an order  ·  Release or click to ping  ·  Esc to cancel")
    call BlzFrameSetVisible(TMP_Hint, true)
    call BlzFrameSetVisible(TMP_Panel, true)
endfunction

private function TMP_Remove takes integer index returns nothing
    call DestroyEffect(TMP_Effect[index])
    call DestroyEffect(TMP_Ring[index])
    call DestroyTextTag(TMP_WorldName[index])
    call DestroyTextTag(TMP_FogSymbol[index])
    set TMP_Effect[index] = TMP_Effect[TMP_Count]
    set TMP_Ring[index] = TMP_Ring[TMP_Count]
    set TMP_Age[index] = TMP_Age[TMP_Count]
    set TMP_WorldName[index] = TMP_WorldName[TMP_Count]
    set TMP_FogSymbol[index] = TMP_FogSymbol[TMP_Count]
    set TMP_Sender[index] = TMP_Sender[TMP_Count]
    set TMP_Kind[index] = TMP_Kind[TMP_Count]
    set TMP_Delivered[index] = TMP_Delivered[TMP_Count]
    set TMP_BaseScale[index] = TMP_BaseScale[TMP_Count]
    set TMP_X[index] = TMP_X[TMP_Count]
    set TMP_Y[index] = TMP_Y[TMP_Count]
    set TMP_Effect[TMP_Count] = null
    set TMP_Ring[TMP_Count] = null
    set TMP_WorldName[TMP_Count] = null
    set TMP_FogSymbol[TMP_Count] = null
    set TMP_Count = TMP_Count - 1
endfunction

private function TMP_ShowMinimapName takes player sender, integer kind, real x, real y returns nothing
    local integer pid = GetPlayerId(sender)
    local real width = BlzFrameGetWidth(TMP_Minimap)
    local real height = BlzFrameGetHeight(TMP_Minimap)
    local real labelWidth = RMinBJ(0.085, width - 0.004)
    local real px
    local real py
    local real iconX
    local real iconY
    // Native texttags belong to the world; a non-interactive TEXT overlay
    // projects the same ping point onto the actual minimap frame instead.
    if width <= 0.01 or height <= 0.02 then
        return
    endif
    set px = (x - GetCameraBoundMinX()) / (GetCameraBoundMaxX() - GetCameraBoundMinX()) * width
    set py = (y - GetCameraBoundMinY()) / (GetCameraBoundMaxY() - GetCameraBoundMinY()) * height
    set iconX = RMaxBJ(0.006, RMinBJ(width - 0.006, px))
    set iconY = RMaxBJ(0.006, RMinBJ(height - 0.006, py))
    // Keep the entire name inside the minimap, including pings at its edges.
    set px = RMaxBJ(labelWidth / 2.00 + 0.002, RMinBJ(width - labelWidth / 2.00 - 0.002, px))
    if py > height - 0.030 then
        set py = py - 0.017
    else
        set py = py + 0.017
    endif
    set py = RMaxBJ(0.009, RMinBJ(height - 0.009, py))
    call BlzFrameClearAllPoints(TMP_MiniIcon[pid])
    call BlzFrameSetPoint(TMP_MiniIcon[pid], FRAMEPOINT_CENTER, TMP_Minimap, FRAMEPOINT_BOTTOMLEFT, iconX, iconY)
    call BlzFrameSetTexture(TMP_MiniIcon[pid], TMP_MiniTexture[kind], 0, true)
    call BlzFrameSetAlpha(TMP_MiniIcon[pid], 255)
    call BlzFrameSetVisible(TMP_MiniIcon[pid], true)
    call BlzFrameSetSize(TMP_MiniNameRoot[pid], labelWidth, 0.014)
    call BlzFrameClearAllPoints(TMP_MiniNameRoot[pid])
    call BlzFrameSetPoint(TMP_MiniNameRoot[pid], FRAMEPOINT_CENTER, TMP_Minimap, FRAMEPOINT_BOTTOMLEFT, px, py)
    call BlzFrameSetText(TMP_MiniName[pid], TMP_Color[kind] + GetPlayerName(sender) + "|r")
    call BlzFrameSetAlpha(TMP_MiniNameRoot[pid], 255)
    call BlzFrameSetVisible(TMP_MiniNameRoot[pid], true)
endfunction

// Public API must be called synchronously, just like the sync receiver below.
function TeamPing_Send takes player sender, integer kind, real x, real y returns nothing
    local integer pid = GetPlayerId(sender)
    local string model = ""
    local string ring = ""
    local texttag label
    local texttag symbol
    local unit target = null
    local boolean visible = TMP_IsRecipient(sender, GetLocalPlayer()) and (not TMP_Muted or sender == GetLocalPlayer())
    local string message
    local string action
    local real scale = 1.25
    if not TMP_CanSend(sender) or kind < 1 or kind > TMP_KINDS then
        return
    endif
    if TMP_Remaining[pid] > 0.00 then
        return
    endif
    if x < GetRectMinX(bj_mapInitialPlayableArea) or x > GetRectMaxX(bj_mapInitialPlayableArea) or y < GetRectMinY(bj_mapInitialPlayableArea) or y > GetRectMaxY(bj_mapInitialPlayableArea) then
        return
    endif
    set TMP_Remaining[pid] = TMP_COOLDOWN
    set TMP_MiniRemaining[pid] = TMP_MINIMAP_NAME_DURATION
    if kind <= 3 then
        set target = TMP_FindTarget(sender, x, y)
        if target != null then
            set x = GetUnitX(target)
            set y = GetUnitY(target)
        endif
    endif
    // Snapshot the visible target's position; never follow it into fog later.
    set action = TMP_ActionText(kind, target)
    if kind == 3 or kind == 4 then
        set scale = scale * 5.00
    endif
    if TMP_Count >= TMP_MAX_EFFECTS then
        call TMP_Remove(1)
    endif
    set TMP_Count = TMP_Count + 1
    // Allocate the same handles on every client. Empty models also hide their
    // death animation from enemies; no units, fog or gameplay state are local.
    if visible then
        set model = TMP_Model[kind]
        set ring = "UI\\Feedback\\Confirmation\\Confirmation.mdl"
    endif
    set TMP_Effect[TMP_Count] = AddSpecialEffect(model, x, y)
    set TMP_Ring[TMP_Count] = AddSpecialEffect(ring, x, y)
    set TMP_Age[TMP_Count] = 0.00
    set TMP_Sender[TMP_Count] = pid
    set TMP_Kind[TMP_Count] = kind
    set TMP_Delivered[TMP_Count] = visible
    set TMP_BaseScale[TMP_Count] = scale
    set TMP_X[TMP_Count] = x
    set TMP_Y[TMP_Count] = y
    call BlzSetSpecialEffectColor(TMP_Effect[TMP_Count], TMP_Red[kind], TMP_Green[kind], TMP_Blue[kind])
    call BlzSetSpecialEffectColor(TMP_Ring[TMP_Count], TMP_Red[kind], TMP_Green[kind], TMP_Blue[kind])
    call BlzSetSpecialEffectScale(TMP_Effect[TMP_Count], scale)
    call BlzSetSpecialEffectScale(TMP_Ring[TMP_Count], 1.60)
    set label = CreateTextTag()
    call SetTextTagText(label, action + " · " + GetPlayerName(sender), 0.017)
    if kind == 3 or kind == 4 then
        call SetTextTagPos(label, x, y, 360.00)
    else
        call SetTextTagPos(label, x, y, 240.00)
    endif
    call SetTextTagColor(label, TMP_Red[kind], TMP_Green[kind], TMP_Blue[kind], 255)
    call SetTextTagPermanent(label, true)
    call SetTextTagVisibility(label, visible)
    set TMP_WorldName[TMP_Count] = label
    set symbol = CreateTextTag()
    call SetTextTagText(symbol, TMP_Symbol[kind], 0.016 * scale)
    call SetTextTagPos(symbol, x, y, 110.00)
    call SetTextTagColor(symbol, TMP_Red[kind], TMP_Green[kind], TMP_Blue[kind], 255)
    call SetTextTagPermanent(symbol, true)
    call SetTextTagVisibility(symbol, visible and not IsVisibleToPlayer(x, y, GetLocalPlayer()))
    set TMP_FogSymbol[TMP_Count] = symbol
    if visible then
        call PingMinimapEx(x, y, TMP_DURATION, TMP_Red[kind], TMP_Green[kind], TMP_Blue[kind], true)
        call TMP_ShowMinimapName(sender, kind, x, y)
        // No chat line: the world label and minimap name already show it.
        set TMP_LastMessage = GetPlayerName(sender) + ": " + TMP_Color[kind] + action + "|r"
    endif
    set label = null
    set symbol = null
    set target = null
endfunction

private function TMP_OnSync takes nothing returns nothing
    local string data = BlzGetTriggerSyncData()
    local integer length = StringLength(data)
    local integer first = 0
    local integer second = 0
    local integer i = 0
    // Parse only the action and point. Sender identity comes from the event.
    if length < 5 or length > 64 then
        return
    endif
    loop
        exitwhen i >= length
        if SubString(data, i, i + 1) == ";" then
            if first == 0 then
                set first = i
            elseif second == 0 then
                set second = i
            else
                return
            endif
        endif
        set i = i + 1
    endloop
    if first != 1 or second <= first + 1 or second >= length - 1 then
        return
    endif
    call TeamPing_Send(GetTriggerPlayer(), S2I(SubString(data, 0, first)), S2R(SubString(data, first + 1, second)), S2R(SubString(data, second + 1, length)))
endfunction

private function TMP_UpdateHover takes nothing returns nothing
    local real dx = BlzPixelToFrameX(BlzGetMouseScreenPosX()) - TMP_CenterX
    local real dy = BlzPixelToFrameY(BlzGetMouseScreenPosY()) - TMP_CenterY
    local real radius = SquareRoot(dx * dx + dy * dy)
    local integer kind = 0
    if radius >= 0.019 and radius <= 0.092 and TMP_Remaining[GetPlayerId(GetLocalPlayer())] <= 0.00 then
        set kind = ModuloInteger(R2I((486.00 - Atan2(dy, dx) * bj_RADTODEG) / 72.00), TMP_KINDS) + 1
    endif
    if TMP_Hover != kind then
        if TMP_Hover > 0 then
            call TMP_SetHover(TMP_Hover, false)
        endif
        set TMP_Hover = kind
        if kind > 0 then
            call TMP_SetHover(kind, true)
        else
            call BlzFrameSetText(TMP_Status, WUI_GOLD + "Select|norder|r")
        endif
    endif
    // Countdown in the centre while the ping is cooling down.
    if TMP_Remaining[GetPlayerId(GetLocalPlayer())] > 0.00 then
        call BlzFrameSetText(TMP_Status, "|cffffcc00" + R2SW(TMP_Remaining[GetPlayerId(GetLocalPlayer())], 0, 1) + "s|r")
    elseif kind == 0 and TMP_Open then
        call BlzFrameSetText(TMP_Status, WUI_GOLD + "Select|norder|r")
    endif
endfunction

private function TMP_Commit takes nothing returns nothing
    call TMP_UpdateHover()
    if TMP_Open and TMP_Hover > 0 and TMP_HasPoint then
        call BlzSendSyncData(TMP_SYNC, I2S(TMP_Hover) + ";" + R2S(TMP_PointX) + ";" + R2S(TMP_PointY))
        call TMP_Close()
    endif
endfunction

private function TMP_RenderMark takes integer index returns nothing
    local integer kind = TMP_Kind[index]
    local boolean visible = TMP_Delivered[index] and TMP_IsRecipient(Player(TMP_Sender[index]), GetLocalPlayer()) and (not TMP_Muted or TMP_Sender[index] == GetPlayerId(GetLocalPlayer()))
    local integer alpha = 255
    if TMP_Age[index] > TMP_DURATION - 0.70 then
        set alpha = R2I(255.00 * (TMP_DURATION - TMP_Age[index]) / 0.70)
    endif
    if not visible then
        set alpha = 0
    endif
    call BlzSetSpecialEffectAlpha(TMP_Effect[index], alpha)
    call BlzSetSpecialEffectAlpha(TMP_Ring[index], alpha)
    call SetTextTagColor(TMP_WorldName[index], TMP_Red[kind], TMP_Green[kind], TMP_Blue[kind], alpha)
    call SetTextTagColor(TMP_FogSymbol[index], TMP_Red[kind], TMP_Green[kind], TMP_Blue[kind], alpha)
    call SetTextTagVisibility(TMP_WorldName[index], visible)
    // Native texttags render independently of terrain vision. This fallback
    // symbol changes no fog state and exposes no hidden units.
    call SetTextTagVisibility(TMP_FogSymbol[index], visible and not IsVisibleToPlayer(TMP_X[index], TMP_Y[index], GetLocalPlayer()))
endfunction

private function TMP_ToggleMute takes nothing returns nothing
    local integer i = 1
    local integer pid = 0
    set TMP_Muted = not TMP_Muted
    call TMP_Close()
    if TMP_Muted then
        call BlzFrameSetTexture(TMP_ToggleIcon, "UI\\WOS\\toolbar-ping-muted.tga", 0, true)
        call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 1.50, "|cffffcc66Team pings muted. Hold Z to send your own.|r")
        loop
            exitwhen pid >= 10
            if pid != GetPlayerId(GetLocalPlayer()) then
                call BlzFrameSetVisible(TMP_MiniNameRoot[pid], false)
                call BlzFrameSetVisible(TMP_MiniIcon[pid], false)
            endif
            set pid = pid + 1
        endloop
    else
        call BlzFrameSetTexture(TMP_ToggleIcon, "UI\\WOS\\toolbar-ping.tga", 0, true)
        call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 1.50, "|cff70ef90Team pings enabled.|r")
    endif
    loop
        exitwhen i > TMP_Count
        call TMP_RenderMark(i)
        set i = i + 1
    endloop
endfunction

private function TMP_OnFrame takes nothing returns nothing
    local framehandle frame = BlzGetTriggerFrame()
    local frameeventtype ev = BlzGetTriggerFrameEvent()
    if GetLocalPlayer() != GetTriggerPlayer() then
        set frame = null
        set ev = null
        return
    endif
    if frame == TMP_Toggle and ev == FRAMEEVENT_CONTROL_CLICK then
        call TMP_ToggleMute()
    elseif frame == TMP_Toggle and ev == FRAMEEVENT_MOUSE_ENTER then
        call BlzFrameSetText(TMP_Hint, "|cffd5b876Hold " + WUI_GetHotkeyName(WUI_HOTKEY_PING, GetPlayerId(GetLocalPlayer())) + ": send orders|r  ·  Click this button: mute / enable pings  ·  Click the key badge to rebind")
        call BlzFrameSetVisible(TMP_Hint, true)
    elseif frame == TMP_Toggle and ev == FRAMEEVENT_MOUSE_LEAVE then
        if not TMP_Open then
            call BlzFrameSetVisible(TMP_Hint, false)
        endif
    elseif frame == TMP_Wheel and ev == FRAMEEVENT_CONTROL_CLICK then
        call TMP_Commit()
    endif
    if ev == FRAMEEVENT_CONTROL_CLICK then
        call BlzFrameSetEnable(frame, false)
        call BlzFrameSetEnable(frame, true)
    endif
    set frame = null
    set ev = null
endfunction

private function TMP_OnMouseMove takes nothing returns nothing
    local real x = BlzGetTriggerPlayerMouseX()
    local real y = BlzGetTriggerPlayerMouseY()
    // The first world position after the press is the ping point; UI
    // movement returns 0/0 and is skipped.
    if GetLocalPlayer() == GetTriggerPlayer() and not TMP_HasPoint and (x != 0.00 or y != 0.00) then
        set TMP_PointX = x
        set TMP_PointY = y
        set TMP_HasPoint = true
    endif
endfunction

private function TMP_TrackMouse takes player p, boolean on returns nothing
    local integer pid = GetPlayerId(p)
    if on and TMP_MoveTrigger[pid] == null then
        set TMP_MoveTrigger[pid] = CreateTrigger()
        call TriggerRegisterPlayerEvent(TMP_MoveTrigger[pid], p, EVENT_PLAYER_MOUSE_MOVE)
        call TriggerAddAction(TMP_MoveTrigger[pid], function TMP_OnMouseMove)
    elseif not on and TMP_MoveTrigger[pid] != null then
        call DestroyTrigger(TMP_MoveTrigger[pid])
        set TMP_MoveTrigger[pid] = null
    endif
endfunction

private function TMP_OnKey takes nothing returns nothing
    local player p = GetTriggerPlayer()
    // Synced part: key events reach every client, so the move trigger is
    // created / destroyed identically everywhere.
    if BlzGetTriggerPlayerKey() == OSKEY_ESCAPE then
        call TMP_TrackMouse(p, false)
    elseif BlzGetTriggerPlayerKey() == WUI_GetHotkey(WUI_HOTKEY_PING, GetPlayerId(p)) then
        call TMP_TrackMouse(p, BlzGetTriggerPlayerIsKeyDown())
    endif
    set p = null
    if GetLocalPlayer() != GetTriggerPlayer() then
        return
    endif
    if BlzGetTriggerPlayerKey() == OSKEY_ESCAPE then
        call TMP_Close()
    elseif BlzGetTriggerPlayerKey() != WUI_GetHotkey(WUI_HOTKEY_PING, GetPlayerId(GetTriggerPlayer())) then
        // An old (rebound) key: ignored.
        return
    elseif not BlzGetTriggerPlayerIsKeyDown() then
        set TMP_KeyTime = TMP_Clock
        set TMP_ZHeld = false
        if TMP_Open then
            call TMP_Commit()
            call TMP_Close()
        endif
    elseif not TMP_ZHeld or (not TMP_Open and TMP_Clock - TMP_KeyTime > 0.75) then
        set TMP_KeyTime = TMP_Clock
        set TMP_ZHeld = true
        set TMP_HasPoint = false
        call TMP_ShowWheel()
    else
        set TMP_KeyTime = TMP_Clock
    endif
endfunction

private function TMP_OnMouse takes nothing returns nothing
    local real x = BlzGetTriggerPlayerMouseX()
    local real y = BlzGetTriggerPlayerMouseY()
    if GetLocalPlayer() != GetTriggerPlayer() then
        return
    endif
    if BlzGetTriggerPlayerMouseButton() == MOUSE_BUTTON_TYPE_RIGHT then
        call TMP_Close()
    elseif TMP_Open and BlzGetTriggerPlayerMouseButton() == MOUSE_BUTTON_TYPE_LEFT then
        call TMP_Commit()
    endif
endfunction

private function TMP_Periodic takes nothing returns nothing
    local integer pid = 0
    local integer i = 1
    local real age
    set TMP_Clock = TMP_Clock + TMP_PERIOD
    loop
        exitwhen pid >= 10
        set TMP_Remaining[pid] = RMaxBJ(0.00, TMP_Remaining[pid] - TMP_PERIOD)
        if TMP_Remaining[pid] < 0.001 then
            set TMP_Remaining[pid] = 0.00
        endif
        if TMP_MiniRemaining[pid] > 0.00 then
            set TMP_MiniRemaining[pid] = RMaxBJ(0.00, TMP_MiniRemaining[pid] - TMP_PERIOD)
            if TMP_MiniRemaining[pid] < 0.001 then
                set TMP_MiniRemaining[pid] = 0.00
                call BlzFrameSetVisible(TMP_MiniNameRoot[pid], false)
                call BlzFrameSetVisible(TMP_MiniIcon[pid], false)
            elseif TMP_MiniRemaining[pid] < TMP_MINIMAP_NAME_FADE then
                call BlzFrameSetAlpha(TMP_MiniNameRoot[pid], R2I(255.00 * TMP_MiniRemaining[pid] / TMP_MINIMAP_NAME_FADE))
                call BlzFrameSetAlpha(TMP_MiniIcon[pid], R2I(255.00 * TMP_MiniRemaining[pid] / TMP_MINIMAP_NAME_FADE))
            endif
        endif
        set pid = pid + 1
    endloop
    loop
        exitwhen i > TMP_Count
        set TMP_Age[i] = TMP_Age[i] + TMP_PERIOD
        set age = TMP_Age[i]
        if age >= TMP_DURATION then
            call TMP_Remove(i)
        else
            // A short expanding pulse settles into a smaller visible beacon.
            call BlzSetSpecialEffectScale(TMP_Ring[i], 1.30 + 0.30 * Sin(age * 8.00))
            call BlzSetSpecialEffectScale(TMP_Effect[i], TMP_BaseScale[i] * (1.00 + 0.10 * Sin(age * 8.00)))
            call TMP_RenderMark(i)
            set i = i + 1
        endif
    endloop
    set pid = GetPlayerId(GetLocalPlayer())
    if TMP_Open then
        call TMP_UpdateHover()
    endif
    if pid < 10 then
        // Checkpoint 27d: touch the toolbar icon only when something changes.
        if TMP_Remaining[pid] > 0.00 then
            call WUI_SetText(TMP_ToggleText, "|cffffcc66" + R2SW(TMP_Remaining[pid], 0, 1) + "|r")
            if TMP_ToggleState != 1 then
                set TMP_ToggleState = 1
                call BlzFrameSetAlpha(TMP_ToggleIcon, 125)
            endif
        else
            call WUI_SetText(TMP_ToggleText, "")
            if TMP_ToggleState != 2 then
                set TMP_ToggleState = 2
                call BlzFrameSetAlpha(TMP_ToggleIcon, 190)
            endif
        endif
    endif
endfunction

private function TMP_StartUI takes nothing returns nothing
    local framehandle ui = WUI_GetRoot()
    local trigger frames = CreateTrigger()
    local trigger keys = CreateTrigger()
    local trigger mouse = CreateTrigger()
    local trigger sync = CreateTrigger()
    local integer kind = 1
    local integer pid = 0
    local integer meta = 0
    set TMP_Minimap = BlzGetOriginFrame(ORIGIN_FRAME_MINIMAP, 0)
    set TMP_TargetGroup = CreateGroup()
    set TMP_Label[1] = "On my way"
    set TMP_Label[2] = "Attack"
    set TMP_Label[3] = "Danger"
    set TMP_Label[4] = "Need help"
    set TMP_Label[5] = "Group up here"
    set TMP_Color[1] = "|cff50d9ff"
    set TMP_Color[2] = "|cffff7850"
    set TMP_Color[3] = "|cffffd250"
    set TMP_Color[4] = "|cff70ef90"
    set TMP_Color[5] = "|cffbd9aff"
    set TMP_Red[1] = 80
    set TMP_Green[1] = 217
    set TMP_Blue[1] = 255
    set TMP_Red[2] = 255
    set TMP_Green[2] = 120
    set TMP_Blue[2] = 80
    set TMP_Red[3] = 255
    set TMP_Green[3] = 210
    set TMP_Blue[3] = 80
    set TMP_Red[4] = 112
    set TMP_Green[4] = 239
    set TMP_Blue[4] = 144
    set TMP_Red[5] = 189
    set TMP_Green[5] = 154
    set TMP_Blue[5] = 255
    set TMP_Texture[1] = "UI\\TeamPings\\move.tga"
    set TMP_Texture[2] = "UI\\TeamPings\\attack.tga"
    set TMP_Texture[3] = "UI\\TeamPings\\danger.tga"
    set TMP_Texture[4] = "UI\\TeamPings\\help.tga"
    set TMP_Texture[5] = "UI\\TeamPings\\rally.tga"
    set TMP_Model[1] = "war3mapImported\\wos_SpellMarkerBlue.mdx"
    set TMP_Model[2] = "war3mapImported\\wos_OuterCircleRed.mdx"
    set TMP_Model[3] = "Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl"
    set TMP_Model[4] = "war3mapImported\\wos_HealGreen.mdx"
    set TMP_Model[5] = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl"
    set TMP_Symbol[1] = ">>"
    set TMP_Symbol[2] = "X"
    set TMP_Symbol[3] = "!"
    set TMP_Symbol[4] = "+"
    set TMP_Symbol[5] = "O"
    set kind = 1
    loop
        exitwhen kind > TMP_KINDS
        set TMP_Angle[kind] = (90.00 - I2R(kind - 1) * 72.00) * bj_DEGTORAD
        set TMP_MiniTexture[kind] = "UI\\TeamPings\\symbol-" + SubString(TMP_Texture[kind], 13, StringLength(TMP_Texture[kind]))
        set kind = kind + 1
    endloop
    set kind = 1
    set TMP_Panel = BlzCreateFrameByType("BACKDROP", "TeamPingPanel", ui, "", 0)
    call BlzFrameSetSize(TMP_Panel, TMP_BUTTON_SIZE, TMP_BUTTON_SIZE)
    // Graphite + antique-gold wheel matching the HUD (was a bright stock-looking disc).
    call BlzFrameSetTexture(TMP_Panel, "UI\\WOS\\wheel-base.tga", 0, true)
    call BlzFrameSetAlpha(TMP_Panel, 170)
    call BlzFrameSetLevel(TMP_Panel, 20)
    set TMP_Wheel = BlzCreateFrameByType("BUTTON", "TeamPingWheel", TMP_Panel, "", 0)
    call BlzFrameSetPoint(TMP_Wheel, FRAMEPOINT_CENTER, TMP_Panel, FRAMEPOINT_CENTER, 0, 0)
    call BlzFrameSetSize(TMP_Wheel, TMP_HOVER_SIZE, TMP_HOVER_SIZE)
    call BlzFrameSetEnable(TMP_Wheel, false)
    call BlzTriggerRegisterFrameEvent(frames, TMP_Wheel, FRAMEEVENT_CONTROL_CLICK)
    set TMP_Status = BlzCreateFrameByType("TEXT", "TeamPingStatus", TMP_Panel, "", 0)
    call BlzFrameSetPoint(TMP_Status, FRAMEPOINT_CENTER, TMP_Panel, FRAMEPOINT_CENTER, 0, -0.002)
    call BlzFrameSetSize(TMP_Status, 0.055, 0.035)
    call BlzFrameSetScale(TMP_Status, 0.70)
    call BlzFrameSetLevel(TMP_Status, 5)
    call BlzFrameSetTextAlignment(TMP_Status, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetEnable(TMP_Status, false)
    loop
        exitwhen kind > TMP_KINDS
        set TMP_Button[kind] = BlzCreateFrameByType("BACKDROP", "TeamPingSector", TMP_Wheel, "", kind)
        call BlzFrameSetPoint(TMP_Button[kind], FRAMEPOINT_CENTER, TMP_Wheel, FRAMEPOINT_CENTER, 0, 0)
        call BlzFrameSetSize(TMP_Button[kind], TMP_BUTTON_SIZE, TMP_BUTTON_SIZE)
        call BlzFrameSetTexture(TMP_Button[kind], "UI\\WOS\\ping-" + SubString(TMP_Texture[kind], 13, StringLength(TMP_Texture[kind])), 0, true)
        call BlzFrameSetEnable(TMP_Button[kind], false)
        set TMP_Name[kind] = BlzCreateFrameByType("TEXT", "TeamPingLabel", TMP_Panel, "", kind)
        call BlzFrameSetPoint(TMP_Name[kind], FRAMEPOINT_CENTER, TMP_Panel, FRAMEPOINT_CENTER, 0.065 * Cos(TMP_Angle[kind]), 0.065 * Sin(TMP_Angle[kind]))
        call BlzFrameSetSize(TMP_Name[kind], 0.050, 0.024)
        call BlzFrameSetScale(TMP_Name[kind], 0.62)
        call BlzFrameSetLevel(TMP_Name[kind], 5)
        call BlzFrameSetTextAlignment(TMP_Name[kind], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
        call BlzFrameSetText(TMP_Name[kind], TMP_Color[kind] + TMP_Label[kind] + "|r")
        if kind == 5 then
            call BlzFrameSetText(TMP_Name[kind], TMP_Color[kind] + "Group up|nhere|r")
        endif
        call BlzFrameSetEnable(TMP_Name[kind], false)
        call BlzFrameSetVisible(TMP_Name[kind], false)
        set kind = kind + 1
    endloop
    set TMP_Toggle = BlzCreateFrameByType("BUTTON", "TeamPingToggle", ui, "", 0)
    call WUI_PlaceToolbar(TMP_Toggle, 0, 1)
    set TMP_ToggleIcon = BlzCreateFrameByType("BACKDROP", "TeamPingToggleIcon", TMP_Toggle, "", 0)
    call BlzFrameSetAllPoints(TMP_ToggleIcon, TMP_Toggle)
    call BlzFrameSetTexture(TMP_ToggleIcon, "UI\\WOS\\toolbar-ping.tga", 0, true)
    call BlzFrameSetAlpha(TMP_ToggleIcon, 255)
    call BlzFrameSetEnable(TMP_ToggleIcon, false)
    set TMP_ToggleText = BlzCreateFrameByType("TEXT", "TeamPingToggleText", TMP_Toggle, "", 0)
    call BlzFrameSetPoint(TMP_ToggleText, FRAMEPOINT_BOTTOMRIGHT, TMP_Toggle, FRAMEPOINT_BOTTOMRIGHT, 0, 0)
    call BlzFrameSetSize(TMP_ToggleText, 0.008, 0.008)
    call BlzFrameSetScale(TMP_ToggleText, 0.55)
    call BlzFrameSetLevel(TMP_ToggleText, 3)
    call BlzFrameSetTextAlignment(TMP_ToggleText, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetText(TMP_ToggleText, "")
    call BlzFrameSetEnable(TMP_ToggleText, false)
    // Cooldown digits sit centred on the icon; the key badge owns the corner.
    call BlzFrameClearAllPoints(TMP_ToggleText)
    call BlzFrameSetPoint(TMP_ToggleText, FRAMEPOINT_CENTER, TMP_Toggle, FRAMEPOINT_CENTER, 0, 0)
    call BlzFrameSetSize(TMP_ToggleText, 0.020, 0.012)
    set TMP_Hint = BlzCreateFrameByType("TEXT", "TeamPingHint", ui, "", 0)
    call BlzFrameSetAbsPoint(TMP_Hint, FRAMEPOINT_CENTER, 0.40, 0.47)
    call BlzFrameSetSize(TMP_Hint, 0.60, 0.021)
    call BlzFrameSetTextAlignment(TMP_Hint, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    call BlzFrameSetScale(TMP_Hint, 0.82)
    call BlzFrameSetEnable(TMP_Hint, false)
    call BlzTriggerRegisterFrameEvent(frames, TMP_Toggle, FRAMEEVENT_CONTROL_CLICK)
    call BlzTriggerRegisterFrameEvent(frames, TMP_Toggle, FRAMEEVENT_MOUSE_ENTER)
    call BlzTriggerRegisterFrameEvent(frames, TMP_Toggle, FRAMEEVENT_MOUSE_LEAVE)
    call TriggerAddAction(frames, function TMP_OnFrame)
    call TriggerAddAction(keys, function TMP_OnKey)
    call TriggerAddAction(mouse, function TMP_OnMouse)
    call TriggerAddAction(sync, function TMP_OnSync)
    loop
        exitwhen pid >= 10
        set TMP_MiniIcon[pid] = BlzCreateFrameByType("BACKDROP", "TeamPingMinimapIcon", TMP_Minimap, "", pid)
        call BlzFrameSetSize(TMP_MiniIcon[pid], 0.013, 0.013)
        call BlzFrameSetLevel(TMP_MiniIcon[pid], 21)
        call BlzFrameSetEnable(TMP_MiniIcon[pid], false)
        call BlzFrameSetVisible(TMP_MiniIcon[pid], false)
        // Allocate all frames synchronously; only their content/visibility is local.
        set TMP_MiniNameRoot[pid] = BlzCreateFrameByType("FRAME", "TeamPingMinimapNameRoot", TMP_Minimap, "", pid)
        call BlzFrameSetLevel(TMP_MiniNameRoot[pid], 20)
        call BlzFrameSetEnable(TMP_MiniNameRoot[pid], false)
        set TMP_MiniNameBack[pid] = BlzCreateFrameByType("BACKDROP", "TeamPingMinimapNameBack", TMP_MiniNameRoot[pid], "", pid)
        call BlzFrameSetAllPoints(TMP_MiniNameBack[pid], TMP_MiniNameRoot[pid])
        call BlzFrameSetTexture(TMP_MiniNameBack[pid], "Textures\\black32.blp", 0, true)
        call BlzFrameSetAlpha(TMP_MiniNameBack[pid], 175)
        call BlzFrameSetEnable(TMP_MiniNameBack[pid], false)
        set TMP_MiniName[pid] = BlzCreateFrameByType("TEXT", "TeamPingMinimapName", TMP_MiniNameRoot[pid], "", pid)
        call BlzFrameSetLevel(TMP_MiniName[pid], 2)
        call BlzFrameSetAllPoints(TMP_MiniName[pid], TMP_MiniNameRoot[pid])
        call BlzFrameSetTextAlignment(TMP_MiniName[pid], TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
        call BlzFrameSetScale(TMP_MiniName[pid], 0.65)
        call BlzFrameSetEnable(TMP_MiniName[pid], false)
        call BlzFrameSetVisible(TMP_MiniNameRoot[pid], false)
        call BlzTriggerRegisterPlayerKeyEvent(keys, Player(pid), OSKEY_ESCAPE, 0, false)
        call TriggerRegisterPlayerEvent(mouse, Player(pid), EVENT_PLAYER_MOUSE_DOWN)
        call BlzTriggerRegisterPlayerSyncEvent(sync, Player(pid), TMP_SYNC, false)
        set pid = pid + 1
    endloop
    // Default Z, press and release; rebindable from the key badge.
    call WUI_RegisterHotkey(WUI_HOTKEY_PING, keys, OSKEY_Z, "Z", true, TMP_Toggle)
    call TMP_Close()
    if GetPlayerId(GetLocalPlayer()) >= 10 then
        call BlzFrameSetVisible(TMP_Toggle, false)
    endif
    set TMP_Timer = CreateTimer()
    call TimerStart(TMP_Timer, TMP_PERIOD, true, function TMP_Periodic)
    set ui = null
    set frames = null
    set keys = null
    set mouse = null
    set sync = null
endfunction

private function TMP_Init takes nothing returns nothing
    call WUI_OnReady(function TMP_StartUI)
endfunction

endlibrary
