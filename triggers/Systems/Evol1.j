function Trig_Evol1_Actions takes nothing returns nothing
  local  integer i = GetPlayerId(GetTriggerPlayer())
  local integer k = LoadInteger(hs,GetHandleId(Player(i)),StringHash("nevi sound"))
  local integer id = GetUnitTypeId(Hero[i])
  if TestMode == true then 
 if id == Rimuru_ID and LoadReal(hs, GetHandleId(Hero[i]), StringHash("evol dmg")) <= RimuruEvol1_MagiculeDmg and LoadInteger(hs,GetHandleId(Hero[i]),StringHash("rimuru evol 1")) == 0 then 
call SaveInteger(hs,GetHandleId(Hero[i]),StringHash("rimuru evol 1"),1)
            call BlzFrameSetText(frameRimuru1_pas6[i], "|c00FFFF00" + I2S(RimuruEvol1_MagiculeDmg)+ "/" + I2S(RimuruEvol1_MagiculeDmg) + "|r")
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
