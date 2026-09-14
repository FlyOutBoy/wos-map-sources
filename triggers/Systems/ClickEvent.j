function KiritoMoveCheck takes unit c returns boolean
local boolean b = true 
if IsUnitPaused(c)  or GetUnitAbilityLevel(c,'BPSE') >0  or LoadInteger(hs,GetHandleId(c),StringHash("e end"))>0 then
set b = false
endif
if GetUnitCurrentOrder(c) != OrderId("smart") and GetUnitCurrentOrder(c) != OrderId("move") and GetUnitCurrentOrder(c) != OrderId("attack") then
set b = false
endif
return b
endfunction
function Trig_ClickEvent_Actions takes nothing returns nothing
local integer i = GetPlayerId(GetTriggerPlayer())
local real x
local real y
local real id= GetUnitTypeId(GetTriggerUnit())

if GetOrderTargetUnit()!= null then 
set x = GetUnitX(GetOrderTargetUnit())
set y = GetUnitY(GetOrderTargetUnit())
else
set x = GetOrderPointX()
set y = GetOrderPointY()
endif
//if id == Kirito_ID and KiritoMoveCheck(GetTriggerUnit()) then 
//call KiritoECheck(GetTriggerUnit(),x,y)
//endif
if id == Okarun_ID then 
if GetOrderTargetUnit()!= null then
call SaveUnitHandle(hs,GetHandleId(GetTriggerUnit()),StringHash("unit target"),GetOrderTargetUnit())
elseif LoadUnitHandle(hs,GetHandleId(GetTriggerUnit()),StringHash("unit target")) != null then 
call RemoveSavedHandle(hs,GetHandleId(GetTriggerUnit()),StringHash("unit target"))
endif
call SaveReal(hs,GetHandleId(GetTriggerUnit()),StringHash("real x"),x)
call SaveReal(hs,GetHandleId(GetTriggerUnit()),StringHash("real y"),y)
endif
endfunction
function Trig_ClickEvent_Cond takes nothing returns boolean
local integer i = GetPlayerId(GetTriggerPlayer())
local integer id = GetUnitTypeId(GetTriggerUnit())
return id==Okarun_ID //or id == Kirito_ID 
endfunction
//===========================================================================
function InitTrig_ClickEvent takes nothing returns nothing
local integer index=0
    set gg_trg_ClickEvent = CreateTrigger(  )
    loop
        call TriggerRegisterPlayerUnitEvent(gg_trg_ClickEvent, Player(index), EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER, null)
        call TriggerRegisterPlayerUnitEvent(gg_trg_ClickEvent, Player(index), EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER, null)
        set index = index + 1
        exitwhen index == 10
    endloop
    call TriggerAddAction( gg_trg_ClickEvent, function Trig_ClickEvent_Actions )
    call TriggerAddCondition( gg_trg_ClickEvent, Condition(function Trig_ClickEvent_Cond))
endfunction

