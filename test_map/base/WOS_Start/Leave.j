function Trig_Leave_Actions takes nothing returns nothing
local player p = GetTriggerPlayer()
local integer i = 0
local integer id = GetPlayerId(p)
local integer gold = GetGold(GetTriggerPlayer())
local integer g = 0
if Hero[id] != null then
loop
exitwhen i == 6 
set g = R2I(GetItemValue(GetItemTypeId(UnitItemInSlot(Hero[id],i)))*0.75)
if g != 0 then 
set gold = gold + g
endif 
set i = i + 1
endloop
set g = 0
set i = 0
loop
exitwhen i == bj_MAX_PLAYER_SLOTS
if GetPlayerSlotState( Player( i ) ) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController( Player( i ) ) == MAP_CONTROL_USER and IsPlayerAlly(p,Player(i)) and Player(i) != p then
set g = g + 1
endif
set i = i + 1
endloop
if g != 0 then 
set gold = gold /g
endif
call RemoveUnit(Hero[id])
endif
if g>0 then 
call PlayersMsg(GetPlayerColorString(p)+GetPlayerName(p)+"|r leaves, all ally gain + |c00FFFF00"+I2S(gold)+"|r gold|r",2)
set i = 0
loop
exitwhen i == bj_MAX_PLAYER_SLOTS
if GetPlayerSlotState( Player( i ) ) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController( Player( i ) ) == MAP_CONTROL_USER and IsPlayerAlly(p,Player(i)) and Player(i) != p then
call AddGold(Player(i),gold,true)
endif
set i = i + 1
endloop
else
call PlayersMsg(GetPlayerColorString(p)+GetPlayerName(p)+"|r leaves|r",2)
endif
set p = null
endfunction

//===========================================================================
function InitTrig_Leave takes nothing returns nothing
local integer i = 0 
    set gg_trg_Leave = CreateTrigger(  )
    loop 
    exitwhen i == bj_MAX_PLAYER_SLOTS
    call TriggerRegisterPlayerEventLeave( gg_trg_Leave, Player(i) )
    set i = i + 1
    endloop
    call TriggerAddAction( gg_trg_Leave, function Trig_Leave_Actions )
endfunction

