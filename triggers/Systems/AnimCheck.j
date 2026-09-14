function AnimCheckActions2 takes nothing returns nothing
    local integer i = GetPlayerId(GetTriggerPlayer())
    local real r = S2R(SubString(GetEventPlayerChatString(), 1, 5))
    local unit u
    if TestMode == true then 
    set bj_lastCreatedGroup = CreateGroup()
    call GroupEnumUnitsInRange(bj_lastCreatedGroup, 1, 1, 30000, Condition(function NoDecor_Filter))
    loop
        set u = FirstOfGroup(bj_lastCreatedGroup)
        exitwhen u == null
        call SetUnitAnimationByIndex(u, R2I(r))
        call GroupRemoveUnit(bj_lastCreatedGroup, u)
    endloop
    set u = null
    call GroupClear(bj_lastCreatedGroup)
    call DestroyGroup(bj_lastCreatedGroup)
    endif
    set u = null
    set r = 0
endfunction
//===========================================================================
function InitTrig_AnimCheck takes nothing returns nothing
    local trigger AnimCheck2 = CreateTrigger()
    local integer i = 0
    loop
        exitwhen i == 9
        call TriggerRegisterPlayerChatEvent(AnimCheck2, Player(i), "-", false)
        set i = i + 1
    endloop
    call TriggerAddAction(AnimCheck2, function AnimCheckActions2)
    set AnimCheck2 = null
endfunction


