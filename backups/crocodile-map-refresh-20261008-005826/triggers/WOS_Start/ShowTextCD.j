library AllyCooldownChatPing initializer InitAllyCooldownChatPing requires GearSystems, AllyHeroAbilityUI

// Пока J зажата, существующий MouseTrig игрока включён через MouseOn.
// Наведение читается только с нативных command/item buttons: дополнительные
// hover-кнопки здесь намеренно не создаются, потому что custom UI их перекрывает.

globals
    private constant integer ACCP_FRAME_COMMAND = 1
    private constant integer ACCP_FRAME_ITEM = 2
    private constant real ACCP_READY_EPSILON = 0.05

    private hashtable ACCP_FrameData = InitHashtable()
    private hashtable ACCP_ItemCooldownAbility = InitHashtable()

    private unit array ACCP_SelectedUnit
    private boolean array ACCP_PingMode
    private boolean array ACCP_JHeld
    private integer array ACCP_HoverFrameId
    private integer array ACCP_HoverType
    private integer array ACCP_HoverSlot

    private framehandle array ACCP_CommandButton
    private framehandle array ACCP_ItemButton
    private trigger ACCP_HoverTrigger = null
    private trigger ACCP_KeyTrigger = null
    private trigger ACCP_SelectTrigger = null
    private trigger ACCP_DeselectTrigger = null
endglobals

// Для предмета с нестандартным скрытым cooldown rawcode достаточно один раз
// вызвать эту функцию в любом синхронном initializer после создания библиотек.
function ACCP_RegisterItemCooldownAbility takes integer itemTypeId, integer abilityId returns nothing
    if itemTypeId != 0 and abilityId != 0 then
        call SaveInteger(ACCP_ItemCooldownAbility, 0, itemTypeId, abilityId)
    endif
endfunction

private function ACCP_OnSelect takes nothing returns nothing
    set ACCP_SelectedUnit[GetPlayerId(GetTriggerPlayer())] = GetTriggerUnit()
endfunction

private function ACCP_OnDeselect takes nothing returns nothing
    local integer pid = GetPlayerId(GetTriggerPlayer())
    local unit whichUnit = GetTriggerUnit()

    if ACCP_SelectedUnit[pid] == whichUnit and not IsUnitSelected(whichUnit, Player(pid)) then
        set ACCP_SelectedUnit[pid] = null
    endif

    set whichUnit = null
endfunction

private function ACCP_GetPingUnit takes integer pid returns unit
    // Эта система предназначена прежде всего для собственного героя игрока.
    if Hero[pid] != null then
        return Hero[pid]
    endif

    // Fallback оставлен для тестового режима до заполнения Hero[pid].
    if ACCP_SelectedUnit[pid] != null and IsUnitSelected(ACCP_SelectedUnit[pid], Player(pid)) then
        return ACCP_SelectedUnit[pid]
    endif
    return null
endfunction

private function ACCP_FormatCooldown takes real cooldown returns string
    if cooldown >= 10.00 then
        // Для больших значений округляем вверх, чтобы сообщение не обещало
        // готовность раньше фактического окончания cooldown.
        return I2S(R2I(cooldown + 0.99))
    endif
    return R2SW(cooldown, 1, 1)
endfunction

private function ACCP_SendToTeam takes player sender, string objectKind, string objectName, real cooldown returns nothing
    local string message

    if cooldown <= ACCP_READY_EPSILON then
        if objectKind == "Предмет" then
            set message = objectKind + " |cffffffff«" + objectName + "»|r |cff40ff40готов|r."
        else
            set message = objectKind + " |cffffffff«" + objectName + "»|r |cff40ff40готова|r."
        endif
    else
        set message = objectKind + " |cffffffff«" + objectName + "»|r — КД |cffffcc00" + ACCP_FormatCooldown(cooldown) + " сек.|r"
    endif

    // recipient = 1 — стандартный союзный чат Warcraft. Он заметно меньше
    // DisplayTimedTextToPlayer и автоматически показывает имя отправителя.
    call BlzDisplayChatMessage(sender, 1, message)
endfunction

private function ACCP_GetItemCooldown takes unit whichUnit, item whichItem returns real
    local integer index = 0
    local integer abilityId = LoadInteger(ACCP_ItemCooldownAbility, 0, GetItemTypeId(whichItem))
    local real remaining = 0.00
    local real candidate = 0.00
    local ability itemAbility = null

    if abilityId != 0 then
        set remaining = BlzGetUnitAbilityCooldownRemaining(whichUnit, abilityId)
    endif

    loop
        set itemAbility = BlzGetItemAbilityByIndex(whichItem, index)
        exitwhen itemAbility == null
        set abilityId = BlzGetAbilityId(itemAbility)
        if abilityId != 0 then
            set candidate = BlzGetUnitAbilityCooldownRemaining(whichUnit, abilityId)
            if candidate > remaining then
                set remaining = candidate
            endif
        endif
        set index = index + 1
    endloop

    set itemAbility = null
    return remaining
endfunction

private function ACCP_GetAbilityName takes unit whichUnit, integer abilityId returns string
    local integer level = GetUnitAbilityLevel(whichUnit, abilityId)
    local string abilityName = ""
    local ability whichAbility = BlzGetUnitAbility(whichUnit, abilityId)

    if whichAbility != null then
        set abilityName = BlzGetAbilityStringField(whichAbility, ABILITY_SF_NAME)
    endif
    if abilityName == "" then
        if level < 1 then
            set level = 1
        endif
        set abilityName = BlzGetAbilityTooltip(abilityId, level - 1)
    endif
    if abilityName == "" then
        set abilityName = "Неизвестная способность"
    endif

    set whichAbility = null
    return abilityName
endfunction

private function ACCP_Ping takes player sender, integer frameType, integer slot returns nothing
    local integer pid = GetPlayerId(sender)
    local integer abilityId = 0
    local real cooldown = 0.00
    local unit whichUnit = ACCP_GetPingUnit(pid)
    local item whichItem = null

    if whichUnit == null then
        set sender = null
        return
    endif

    if frameType == ACCP_FRAME_COMMAND then
        set abilityId = AHUI_GetAbilityAtCommandSlot(whichUnit, slot)
        // Ability, добавленная герою только ради будущего изучения, имеет
        // уровень 0 и не должна попадать в сообщения.
        if AHUI_IsAbilityLearnedAtCommandSlot(whichUnit, slot, abilityId) then
            set cooldown = BlzGetUnitAbilityCooldownRemaining(whichUnit, abilityId)
            call ACCP_SendToTeam(sender, "Способность", ACCP_GetAbilityName(whichUnit, abilityId), cooldown)
        endif
    elseif frameType == ACCP_FRAME_ITEM then
        set whichItem = UnitItemInSlot(whichUnit, slot)
        if whichItem != null then
            set cooldown = ACCP_GetItemCooldown(whichUnit, whichItem)
            call ACCP_SendToTeam(sender, "Предмет", GetItemName(whichItem), cooldown)
        endif
    endif

    set whichItem = null
    set whichUnit = null
    set sender = null
endfunction

private function ACCP_ConsumeHoveredSlot takes integer pid, player sender returns nothing
    if ACCP_HoverType[pid] == 0 then
        return
    endif

    set ACCP_PingMode[pid] = false
    if MouseTrig[pid] != null then
        call MouseOff(sender)
    endif
    call ACCP_Ping(sender, ACCP_HoverType[pid], ACCP_HoverSlot[pid])
endfunction

// J keyDown включает отслеживание, J keyUp выключает. Отдельный массив нужен,
// чтобы native frame hover не зависел от GetLocalPlayer и локальных handle-переменных.
private function ACCP_OnHoldKey takes nothing returns nothing
    local integer pid = GetPlayerId(GetTriggerPlayer())
    local boolean down = BlzGetTriggerPlayerIsKeyDown()

    if down then
        // Игнорируем возможный auto-repeat: после успешного клика режим не
        // включится повторно, пока игрок физически не отпустит J.
        if not ACCP_JHeld[pid] then
            set ACCP_JHeld[pid] = true
            set ACCP_PingMode[pid] = true
            if MouseTrig[pid] != null then
                call MouseOn(Player(pid))
            endif
            // Если курсор уже находился над нативной кнопкой до нажатия J,
            // повторного MOUSE_ENTER ждать не требуется.
            if ACCP_HoverType[pid] != 0 then
                call ACCP_ConsumeHoveredSlot(pid, Player(pid))
            endif
        endif
    else
        set ACCP_JHeld[pid] = false
        set ACCP_PingMode[pid] = false
        if MouseTrig[pid] != null then
            call MouseOff(Player(pid))
        endif
    endif
endfunction

private function ACCP_OnFrameHover takes nothing returns nothing
    local player sender = GetTriggerPlayer()
    local integer pid = GetPlayerId(sender)
    local framehandle hovered = BlzGetTriggerFrame()
    local integer frameId = GetHandleId(hovered)
    local integer frameType = LoadInteger(ACCP_FrameData, frameId, 0)
    local integer slot = LoadInteger(ACCP_FrameData, frameId, 1)
    local frameeventtype eventType = BlzGetTriggerFrameEvent()

    if eventType == FRAMEEVENT_MOUSE_ENTER then
        set ACCP_HoverFrameId[pid] = frameId
        set ACCP_HoverType[pid] = frameType
        set ACCP_HoverSlot[pid] = slot
        if ACCP_PingMode[pid] then
            call ACCP_ConsumeHoveredSlot(pid, sender)
        endif
    elseif eventType == FRAMEEVENT_MOUSE_LEAVE and ACCP_HoverFrameId[pid] == frameId then
        set ACCP_HoverFrameId[pid] = 0
        set ACCP_HoverType[pid] = 0
        set ACCP_HoverSlot[pid] = -1
    endif

    set eventType = null
    set sender = null
    set hovered = null
endfunction

private function ACCP_RegisterOriginFrame takes framehandle origin, integer frameType, integer slot returns nothing
    if origin != null then
        call SaveInteger(ACCP_FrameData, GetHandleId(origin), 0, frameType)
        call SaveInteger(ACCP_FrameData, GetHandleId(origin), 1, slot)
        call BlzTriggerRegisterFrameEvent(ACCP_HoverTrigger, origin, FRAMEEVENT_MOUSE_ENTER)
        call BlzTriggerRegisterFrameEvent(ACCP_HoverTrigger, origin, FRAMEEVENT_MOUSE_LEAVE)
    endif
endfunction

private function ACCP_InitFrames takes nothing returns nothing
    local integer slot = 0

    set ACCP_HoverTrigger = CreateTrigger()
    call TriggerAddAction(ACCP_HoverTrigger, function ACCP_OnFrameHover)

    loop
        exitwhen slot >= 12
        set ACCP_CommandButton[slot] = BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON, slot)
        call ACCP_RegisterOriginFrame(ACCP_CommandButton[slot], ACCP_FRAME_COMMAND, slot)
        set slot = slot + 1
    endloop

    set slot = 0
    loop
        exitwhen slot >= bj_MAX_INVENTORY
        set ACCP_ItemButton[slot] = BlzGetOriginFrame(ORIGIN_FRAME_ITEM_BUTTON, slot)
        call ACCP_RegisterOriginFrame(ACCP_ItemButton[slot], ACCP_FRAME_ITEM, slot)
        set slot = slot + 1
    endloop
endfunction

private function ACCP_InitEvents takes nothing returns nothing
    local integer pid = 0
    local integer metaKey = 0

    set ACCP_KeyTrigger = CreateTrigger()
    set ACCP_SelectTrigger = CreateTrigger()
    set ACCP_DeselectTrigger = CreateTrigger()

    call TriggerAddAction(ACCP_KeyTrigger, function ACCP_OnHoldKey)
    call TriggerAddAction(ACCP_SelectTrigger, function ACCP_OnSelect)
    call TriggerAddAction(ACCP_DeselectTrigger, function ACCP_OnDeselect)

    loop
        exitwhen pid >= bj_MAX_PLAYER_SLOTS
        // J отслеживается и при нажатии, и при отпускании. Регистрируем все
        // metaKey, чтобы Shift/Ctrl/Alt не оставили MouseTrig включённым.
        set metaKey = 0
        loop
            exitwhen metaKey > 15
            call BlzTriggerRegisterPlayerKeyEvent(ACCP_KeyTrigger, Player(pid), OSKEY_J, metaKey, true)
            call BlzTriggerRegisterPlayerKeyEvent(ACCP_KeyTrigger, Player(pid), OSKEY_J, metaKey, false)
            set metaKey = metaKey + 1
        endloop
        call TriggerRegisterPlayerUnitEvent(ACCP_SelectTrigger, Player(pid), EVENT_PLAYER_UNIT_SELECTED, null)
        call TriggerRegisterPlayerUnitEvent(ACCP_DeselectTrigger, Player(pid), EVENT_PLAYER_UNIT_DESELECTED, null)
        set pid = pid + 1
    endloop
endfunction

private function InitAllyCooldownChatPing takes nothing returns nothing
    call ACCP_InitFrames()
    call ACCP_InitEvents()
endfunction

endlibrary
