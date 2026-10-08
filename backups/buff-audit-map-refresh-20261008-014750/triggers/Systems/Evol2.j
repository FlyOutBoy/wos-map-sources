function Trig_Evol2_Actions takes nothing returns nothing
  local  integer i = GetPlayerId(GetTriggerPlayer())
  local integer k = LoadInteger(hs,GetHandleId(Player(i)),StringHash("nevi sound"))
  local integer id = GetUnitTypeId(Hero[i])
  if TestMode == true then 
if id == Rimuru_ID and  LoadInteger(hs, GetHandleId(Hero[i]), StringHash("evol kill")) <= RimuruEvol2_Counter and LoadInteger(hs,GetHandleId(Hero[i]),StringHash("rimuru evol 2")) == 0 then 
call SaveInteger(hs,GetHandleId(Hero[i]),StringHash("rimuru evol 2"),1)
call RimuruEvol2_Start(Hero[i],false)
            call BlzFrameSetText(frameRimuru2_pas6[i], "|c00FFFF00" + I2S(RimuruEvol2_Counter)+"/" + I2S(RimuruEvol2_Counter) + "|r")
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
