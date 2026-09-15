function Trig_LvlSelf_Actions takes nothing returns nothing
   local real r = S2R(SubString(GetEventPlayerChatString(), 5,9))
  local  integer i = GetPlayerId(GetTriggerPlayer())
    if r<GetHeroLevel(Hero[i]) then
   call UnitStripHeroLevel(Hero[i],GetHeroLevel(Hero[i])-R2I(r))
    else
   call  SetHeroLevel(Hero[i],R2I(r),true)
    endif
endfunction
//===========================================================================
function InitTrig_LvlSelf takes nothing returns nothing
    local trigger LvlSelf = CreateTrigger( )
    local integer i = 0
    loop
        exitwhen i == 13
        call TriggerRegisterPlayerChatEvent( LvlSelf, Player(i), "-lvl", false )
       set i = i + 1
    endloop
    call TriggerAddAction( LvlSelf, function Trig_LvlSelf_Actions )
    set LvlSelf = null
endfunction
