function Trig_Killme_Actions takes nothing returns nothing
local integer i = GetPlayerId(GetTriggerPlayer())
if Hero[i] != null and GetUnitAbilityLevel(Hero[i],'BTLF') == 0 and CheckCoordsInRect(gg_rct_Base,GetUnitX(Hero[i]),GetUnitY(Hero[i])) == false then
if TestMode == true then 
call PauseUnit(Hero[i],false)
call UnitApplyTimedLife(Hero[i],'BTLF',1)
else
call PauseUnit(Hero[i],false)
call SilenceUnit(Hero[i],Hero[i],10)
call UnitApplyTimedLife(Hero[i],'BTLF',10)
endif

endif
endfunction

//===========================================================================
function InitTrig_Killme takes nothing returns nothing
local integer i = 0
    set gg_trg_Killme = CreateTrigger(  )
    loop 
    exitwhen i == bj_MAX_PLAYER_SLOTS
    call TriggerRegisterPlayerChatEvent( gg_trg_Killme, Player(i), "-killme", true )
    set i = i + 1
    endloop
    call TriggerAddAction( gg_trg_Killme, function Trig_Killme_Actions )
endfunction

