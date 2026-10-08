function Trig_LeavesBase_Conditions takes nothing returns boolean
   return IsUnitType(GetLeavingUnit(),UNIT_TYPE_HERO) and IsUnitIllusion(GetLeavingUnit())== false
endfunction

function Trig_LeavesBase_Actions takes nothing returns nothing
local unit c = GetLeavingUnit()
local integer i = GetPlayerId(GetOwningPlayer(c))
call UnitRemoveAbility(c,'Avul')
call SetMpCurrent(c,888888)
call SetHpCurrent(c,888888)
if  atbase_cond[i] != null then 
call RemoveUnit(atbase_cond[i])
set atbase_cond[i] = null
    endif
call UnitResetCooldown(c)
call UnitRemoveAbility(c,'BTLF')
set c = null
endfunction

//===========================================================================
function InitTrig_LeavesBase takes nothing returns nothing
    set gg_trg_LeavesBase = CreateTrigger(  )
    call TriggerRegisterLeaveRectSimple( gg_trg_LeavesBase, gg_rct_Base )
    call TriggerAddCondition( gg_trg_LeavesBase, Condition( function Trig_LeavesBase_Conditions ) )
    call TriggerAddAction( gg_trg_LeavesBase, function Trig_LeavesBase_Actions )
endfunction

