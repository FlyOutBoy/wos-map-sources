function Trig_LvlSelf_Actions takes nothing returns nothing
   local real r = S2R(SubString(GetEventPlayerChatString(), 5,9))
   local unit d = null
  local  integer i = GetPlayerId(GetTriggerPlayer())
  if TestMode then 
  if HeroChosen[i] != null  then
   set d = HeroChosen[i]
   else
   set d = Hero[i]
   endif
   if r<GetHeroLevel(d) then
   call UnitStripHeroLevel(d,GetHeroLevel(d)-R2I(r))
    else
   call  SetHeroLevel(d,R2I(r),true)
    endif
    endif
    set d = null
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
