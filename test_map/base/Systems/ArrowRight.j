function Trig_ArrowRight_Actions takes nothing returns nothing
local integer i = GetPlayerId(GetTriggerPlayer())
local integer k = 0
local unit u = null
local real rr1 = 0
local real rr2 = 0
local real aoe = 10000
local group g = CreateGroup()
local real x = GetUnitX(Hero[i])
local real y = GetUnitY(Hero[i])

set Armor =2
call DestroyGroup(g)
set g = null
set u = null
endfunction

//===========================================================================
function InitTrig_ArrowRight takes nothing returns nothing
    local integer i = 0
    set gg_trg_ArrowRight = CreateTrigger()
    loop
    exitwhen i == 10 
    call TriggerRegisterPlayerKeyEventBJ( gg_trg_ArrowRight, Player(i), bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_RIGHT )
    set i = i + 1
    endloop
    call TriggerAddAction( gg_trg_ArrowRight, function Trig_ArrowRight_Actions )
endfunction

