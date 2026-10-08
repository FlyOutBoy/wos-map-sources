function Trig_slow_Actions takes nothing returns nothing
   local real r = S2R(SubString(GetEventPlayerChatString(), 5,9))
  local  integer i = GetPlayerId(GetTriggerPlayer())
  if TestMode then 
  call SlowUnit(Hero[i],Hero[i],50,4)
    endif
endfunction
//===========================================================================
function InitTrig_slow takes nothing returns nothing
    local trigger LvlSelf = CreateTrigger( )
    local integer i = 0
    loop
        exitwhen i == 13
        call TriggerRegisterPlayerChatEvent( LvlSelf, Player(i), "-slow", true )
       set i = i + 1
    endloop
    call TriggerAddAction( LvlSelf, function Trig_slow_Actions )
    set LvlSelf = null
endfunction
