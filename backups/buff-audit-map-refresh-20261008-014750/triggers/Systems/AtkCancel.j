function Trig_AtkCancel_Actions takes nothing returns nothing
if IsPlayerAlly(GetOwningPlayer(GetTriggerUnit()),GetOwningPlayer(GetAttacker())) then 
call IssueImmediateOrder(GetAttacker(),"stop")
endif
endfunction

//===========================================================================
function InitTrig_AtkCancel takes nothing returns nothing
    set gg_trg_AtkCancel = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AtkCancel, EVENT_PLAYER_UNIT_ATTACKED )
    call TriggerAddAction( gg_trg_AtkCancel, function Trig_AtkCancel_Actions )
endfunction

