function hpsetmaxctions2 takes nothing returns nothing
    local string s = GetEventPlayerChatString()
    local string sign = SubString(s, 3, 4)
    local integer value = S2I(SubString(s, 4, StringLength(s)))
    local integer id = GetPlayerId(GetTriggerPlayer())

   // set TestMode = true 

    if TestMode then
        if sign == "+" then
            call BlzSetUnitMaxHP(Hero[id], BlzGetUnitMaxHP(Hero[id]) + value)
            call SetUnitState(Hero[id],UNIT_STATE_LIFE,999999)
        elseif sign == "-" then
            call BlzSetUnitMaxHP(Hero[id], BlzGetUnitMaxHP(Hero[id]) - value)
        endif
    endif
endfunction
//===========================================================================
function InitTrig_MaxHPSET takes nothing returns nothing
    local trigger hpsetmax = CreateTrigger()
    local integer i = 0
    loop
        exitwhen i == 9
        call TriggerRegisterPlayerChatEvent(hpsetmax, Player(i), "-hp", false)
        set i = i + 1
    endloop
    call TriggerAddAction(hpsetmax, function hpsetmaxctions2)
    set hpsetmax = null
endfunction


