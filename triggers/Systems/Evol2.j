globals
    // Hashed once at map load (was StringHash(...) on every call).
        integer SH_Evol2_EVOL_KILL = StringHash("evol kill")
        integer SH_Evol2_NEVI_SOUND = StringHash("nevi sound")
        integer SH_Evol2_RIMURU_EVOL_1 = StringHash("rimuru evol 1")
        integer SH_Evol2_RIMURU_EVOL_2 = StringHash("rimuru evol 2")
endglobals
function Trig_Evol2_Actions takes nothing returns nothing
  local  integer i = GetPlayerId(GetTriggerPlayer())
  local integer k = LoadInteger(hs,GetHandleId(Player(i)),SH_Evol2_NEVI_SOUND)
  local integer id = GetUnitTypeId(Hero[i])
  if TestMode == true then 
if id == Rimuru_ID and  LoadInteger(hs, GetHandleId(Hero[i]), SH_Evol2_EVOL_KILL) <= RimuruEvol2_Counter and LoadInteger(hs,GetHandleId(Hero[i]),SH_Evol2_RIMURU_EVOL_2) == 0 and LoadInteger(hs,GetHandleId(Hero[i]),SH_Evol2_RIMURU_EVOL_1) == 1 then 
call SaveInteger(hs,GetHandleId(Hero[i]),SH_Evol2_RIMURU_EVOL_2,1)
call RimuruEvol2_Start(Hero[i],false)
            call WUI_HeroProgress(Hero[i], RimuruF2_ID, "Souls Gathered", 0.00, 0.00, true)
endif
    endif
endfunction
//===========================================================================
function InitTrig_Evol2 takes nothing returns nothing
    local trigger Evol2 = CreateTrigger( )
    local integer i = 0
    loop
        exitwhen i == 13
        call TriggerRegisterPlayerChatEvent( Evol2, Player(i), "-s2", true )
       set i = i + 1
    endloop
    call TriggerAddAction( Evol2, function Trig_Evol2_Actions )
    set Evol2 = null
endfunction
