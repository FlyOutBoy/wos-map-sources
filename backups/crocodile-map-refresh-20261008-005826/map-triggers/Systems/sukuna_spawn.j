function Trig_sukuna_spawn_Actions takes nothing returns nothing
   local real r = S2R(SubString(GetEventPlayerChatString(), 5,9))
  local  integer i = GetPlayerId(GetTriggerPlayer())
  if TestMode then
 call SukunaEnd()
 endif
endfunction
//===========================================================================
function InitTrig_sukuna_spawn takes nothing returns nothing
    local trigger LvlSelf = CreateTrigger( )
    local integer i = 0
    loop
        exitwhen i == 13
        call TriggerRegisterPlayerChatEvent( LvlSelf, Player(i), "-sukuna", true )
       set i = i + 1
    endloop
    call TriggerAddAction( LvlSelf, function Trig_sukuna_spawn_Actions )
    set LvlSelf = null
endfunction
