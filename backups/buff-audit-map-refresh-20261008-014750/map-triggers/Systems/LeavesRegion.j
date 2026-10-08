function Trig_LeavesRegion_Conditions takes nothing returns boolean
   return IsUnitType(GetLeavingUnit(),UNIT_TYPE_HERO) and IsUnitIllusion(GetLeavingUnit())== false
endfunction

function Trig_LeavesRegion_Actions takes nothing returns nothing
local player p = GetOwningPlayer(GetLeavingUnit())
local integer id = GetPlayerId(p)
 set Shop_Active[id] = false
 if GetLocalPlayer() == p then 
call BlzFrameSetVisible(FRAME_ShopMAIN,false)
endif
set p = null
endfunction

//===========================================================================
function InitTrig_LeavesRegion takes nothing returns nothing
    set gg_trg_LeavesRegion = CreateTrigger(  )
    call TriggerRegisterLeaveRectSimple( gg_trg_LeavesRegion, gg_rct_Shop )
    call TriggerAddCondition( gg_trg_LeavesRegion, Condition( function Trig_LeavesRegion_Conditions ) )
    call TriggerAddAction( gg_trg_LeavesRegion, function Trig_LeavesRegion_Actions )
endfunction

