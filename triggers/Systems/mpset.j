function mpsetActions takes nothing returns nothing
    local integer i = GetPlayerId(GetTriggerPlayer())
    local real r = S2R(SubString(GetEventPlayerChatString(), 4, 12))
    local unit u
    if TestMode == true then 
    //call BJDebugMsg(R2S(r))
    if r <= 1 then 
    set r = 1
    endif
    call SetUnitState(GetSelectedHeroForPlayer(GetTriggerPlayer()),UNIT_STATE_MANA,r)
    endif
    set u = null
    set r = 0
endfunction
//===========================================================================
function InitTrig_mpset takes nothing returns nothing
    local trigger mpset = CreateTrigger()
    local integer i = 0
    loop
        exitwhen i == 9
        call TriggerRegisterPlayerChatEvent(mpset, Player(i), "-mp", false)
        set i = i + 1
    endloop
    call TriggerAddAction(mpset, function mpsetActions)
    set mpset = null
endfunction


