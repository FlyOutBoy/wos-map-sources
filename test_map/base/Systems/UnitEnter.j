function Trig_UnitEnter_Conditions takes nothing returns boolean
    return IsUnitType(GetEnteringUnit(),UNIT_TYPE_HERO)
endfunction

function Trig_UnitEnter_Actions takes nothing returns nothing
local unit c = GetEnteringUnit()
local integer id = GetUnitTypeId(c)
if LoadReal(hs, GetHandleId(c), StringHash("evol dmg")) >= RimuruEvol1_MagiculeDmg and LoadInteger(hs,GetHandleId(c),StringHash("rimuru evol 1")) == 0 then 
call SaveInteger(hs,GetHandleId(c),StringHash("rimuru evol 1"),1)
call RimuruEvol_Start(c,false)
elseif LoadInteger(hs, GetHandleId(c), StringHash("evol kill")) >= RimuruEvol2_Counter and LoadInteger(hs,GetHandleId(c),StringHash("rimuru evol 2")) == 0 then 
call SaveInteger(hs,GetHandleId(c),StringHash("rimuru evol 2"),1)
call RimuruEvol2_Start(c,false)
endif
set c = null
endfunction

//===========================================================================
function InitTrig_UnitEnter takes nothing returns nothing
    set gg_trg_UnitEnter = CreateTrigger(  )
    // call TriggerRegisterEnterRectSimple( gg_trg_UnitEnter, GetPlayableMapRect() )
    call TriggerRegisterEnterRectSimple( gg_trg_UnitEnter, gg_rct_Base )
    call TriggerAddCondition( gg_trg_UnitEnter, Condition( function Trig_UnitEnter_Conditions ) )
    call TriggerAddAction( gg_trg_UnitEnter, function Trig_UnitEnter_Actions )
endfunction

