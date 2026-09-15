globals
unit TestUnit = null 
endglobals
function Trig_TestUnit_Actions takes nothing returns nothing
local player p = GetTriggerPlayer()
local unit td = GetTriggerUnit()
local integer i = GetPlayerId(p)
local integer i2 = GetPlayerId(GetOwningPlayer(td))

if Hero[i2] != null then 
set HeroChosen[i] = td
else
set HeroChosen[i] = null
endif
if TestMode == true then
if GetUnitTypeId(td) == 'Hblm' then 
set TestUnit = td
else
set TestUnit = null 
endif
endif
set td = null 
set p = null
endfunction

//===========================================================================
function InitTrig_TestUnit takes nothing returns nothing
    set gg_trg_TestUnit = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_TestUnit, EVENT_PLAYER_UNIT_SELECTED )
    call TriggerAddAction( gg_trg_TestUnit, function Trig_TestUnit_Actions )
endfunction

