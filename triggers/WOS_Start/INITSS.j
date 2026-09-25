function Trig_INITSS_Actions takes nothing returns nothing
    call ApplyObserverHpBarDiplomacy()
endfunction

//===========================================================================
function InitTrig_INITSS takes nothing returns nothing
    set gg_trg_INITSS = CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_INITSS, 0.01)
    call TriggerAddAction(gg_trg_INITSS, function Trig_INITSS_Actions)
endfunction
