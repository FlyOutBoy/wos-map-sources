globals
    // Hashed once at map load (was StringHash(...) on every call).
        integer SH_Evol1_EVOL_DMG = StringHash("evol dmg")
        integer SH_Evol1_NEVI_SOUND = StringHash("nevi sound")
        integer SH_Evol1_RIMURU_EVOL_1 = StringHash("rimuru evol 1")
endglobals
function Trig_Evol1_Actions takes nothing returns nothing
  local  integer i = GetPlayerId(GetTriggerPlayer())
  local integer k = LoadInteger(hs,GetHandleId(Player(i)),SH_Evol1_NEVI_SOUND)
  local integer id = GetUnitTypeId(Hero[i])
  if TestMode == true then 
 if id == Rimuru_ID and LoadReal(hs, GetHandleId(Hero[i]), SH_Evol1_EVOL_DMG) <= RimuruEvol1_MagiculeDmg and LoadInteger(hs,GetHandleId(Hero[i]),SH_Evol1_RIMURU_EVOL_1) == 0 then 
call SaveInteger(hs,GetHandleId(Hero[i]),SH_Evol1_RIMURU_EVOL_1,1)
            call WUI_HeroProgressCounter(Hero[i], RimuruF_ID, "Magicules absorbed", I2R(RimuruEvol1_MagiculeDmg), I2R(RimuruEvol1_MagiculeDmg))
call RimuruEvol_Start(Hero[i],false)
endif
    endif
endfunction
//===========================================================================
function InitTrig_Evol1 takes nothing returns nothing
    local trigger Evol1 = CreateTrigger( )
    local integer i = 0
    loop
        exitwhen i == 13
        call TriggerRegisterPlayerChatEvent( Evol1, Player(i), "-s1", true )
       set i = i + 1
    endloop
    call TriggerAddAction( Evol1, function Trig_Evol1_Actions )
    set Evol1 = null
endfunction
