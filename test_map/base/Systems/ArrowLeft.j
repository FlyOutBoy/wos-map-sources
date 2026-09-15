function Trig_ArrowLeft_Actions takes nothing returns nothing
local integer i = GetPlayerId(GetTriggerPlayer())
local integer k = 0
local real rr1 = 0
local real rr2 = 0
set k = 0 
set Armor =1 
endfunction

//===========================================================================
function InitTrig_ArrowLeft takes nothing returns nothing
    local integer i = 0
    set gg_trg_ArrowLeft = CreateTrigger()
    loop
    exitwhen i == 10 
    call TriggerRegisterPlayerKeyEventBJ( gg_trg_ArrowLeft, Player(i), bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_LEFT )
    set i = i + 1
    endloop
    call TriggerAddAction( gg_trg_ArrowLeft, function Trig_ArrowLeft_Actions )
endfunction

