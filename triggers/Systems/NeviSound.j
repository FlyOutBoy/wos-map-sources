function Trig_NeviSound_Actions takes nothing returns nothing
   local real r = S2R(SubString(GetEventPlayerChatString(), 5,9))
  local  integer i = GetPlayerId(GetTriggerPlayer())
  local integer k = LoadInteger(hs,GetHandleId(Player(i)),StringHash("nevi sound"))
  if VIPCheckLvl3(FramePlayerFirstName[i]) then
  if GetUnitTypeId(Hero[i]) == Neuvillette_ID then 
  if  k == 0 then 
  call DisplayTimedTextToPlayer(Player(i),0,0,0.1,"|c00FF0303Neuvillette|r |c00FFFF00voice line changed to |c00FF0303English|r")
  call SaveInteger(hs,GetHandleId(Player(i)),StringHash("nevi sound"),1)
  else
  call DisplayTimedTextToPlayer(Player(i),0,0,0.1,"|c00FF0303Neuvillette|r |c00FFFF00voice line changed to |c00FF0303Japan|r")
  call SaveInteger(hs,GetHandleId(Player(i)),StringHash("nevi sound"),0)  
  endif
  endif
    endif
endfunction
//===========================================================================
function InitTrig_NeviSound takes nothing returns nothing
    local trigger LvlSelf = CreateTrigger( )
    local integer i = 0
    loop
        exitwhen i == 13
        call TriggerRegisterPlayerChatEvent( LvlSelf, Player(i), "-sound", true )
       set i = i + 1
    endloop
    call TriggerAddAction( LvlSelf, function Trig_NeviSound_Actions )
    set LvlSelf = null
endfunction
