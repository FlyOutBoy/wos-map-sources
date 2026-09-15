
function hpsetActions takes nothing returns nothing
    local integer i = GetPlayerId(GetTriggerPlayer())
    local real r = S2R(SubString(GetEventPlayerChatString(), 4, 12))
    local unit u
 //   if TestMode == true then 
    //call BJDebugMsg(R2S(r))
    if r <= 1 then 
    set r = 1
    endif
    if TestUnit != null then 
    call SetUnitState(TestUnit,UNIT_STATE_LIFE,r)
    else
    call SetUnitState(Hero[i],UNIT_STATE_LIFE,r)
    endif
   // endif
    set u = null
    set r = 0
endfunction
//===========================================================================
function InitTrig_hpset takes nothing returns nothing
    local trigger hpset = CreateTrigger()
    local integer i = 0
    loop
        exitwhen i == 20
        call TriggerRegisterPlayerChatEvent(hpset, Player(i), "-hp", false)
        set i = i + 1
    endloop
    call TriggerAddAction(hpset, function hpsetActions)
    set hpset = null
endfunction


