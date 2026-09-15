function Trig_StoneThrowStun_Actions takes nothing returns nothing
   // call TsuchikageHat_Start(gg_unit_hpea_0011,Hero[0] )
endfunction

//===========================================================================
function InitTrig_StoneThrowStun takes nothing returns nothing
    set gg_trg_StoneThrowStun = CreateTrigger(  )
    call TriggerRegisterTimerEventPeriodic( gg_trg_StoneThrowStun, 3 )
    call TriggerAddAction( gg_trg_StoneThrowStun, function Trig_StoneThrowStun_Actions )
endfunction

