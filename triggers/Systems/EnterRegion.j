
globals 
integer inststart = 0
endglobals
function Trig_EnterRegion_Conditions takes nothing returns boolean
   return IsUnitType(GetEnteringUnit(),UNIT_TYPE_HERO) and IsUnitIllusion(GetEnteringUnit())== false
endfunction

function Trig_EnterRegion_Actions takes nothing returns nothing
local player p = GetOwningPlayer(GetEnteringUnit())
local integer id = GetPlayerId(p)
 set Shop_Active[id] = true
 if GetLocalPlayer() == p then 
call StartSound(gg_snd_wos_shopenter)
call BlzFrameSetVisible(FRAME_ShopMAIN,true)
endif
set p = null
endfunction
function Trig_EnterRegion_ActionsGO takes nothing returns nothing
local player p = GetOwningPlayer(GetEnteringUnit())
local integer id = GetPlayerId(p)
local group g = CreateGroup()
local unit u = null
local integer counter = 0
local integer countercheck = 0
local integer i = 0
if END1 == 0 and (((CapPickPhase == 2 or CapPickPhase == 4) and CaptainMode == true) or CaptainMode == false) then 
if IntegerCd(GetEnteringUnit(),"round instant start cd",5) then 
call PlayersMsg(GetPlayerVisualColorString(p)+GetPlayerName(p)+"|r wants to start next round immediatly...",1)
endif 
loop
exitwhen i == bj_MAX_PLAYER_SLOTS
if GetPlayerSlotState( Player( i ) ) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController( Player( i ) ) == MAP_CONTROL_USER then
set countercheck = countercheck + 1
endif
set i = i + 1
endloop
call GroupEnumUnitsInRect(g,gg_rct_Go,null)
loop
set u = FirstOfGroup(g)
exitwhen u == null 
if IsUnitType(u,UNIT_TYPE_HERO) and IsUnitIllusion(u)== false then 
set counter = counter + 1
endif
call GroupRemoveUnit(g,u)
endloop
call DestroyGroup(g)
if counter == countercheck and inststart == 0 then
set inststart = 1
call PlayersMsg(GetPlayerVisualColorString(Player(0))+"Round starts immediatly!",1)
set TimeMove = TimeRound-1
endif
endif
set g = null
set u = null
set p = null
endfunction
function Trig_PushTop takes nothing returns nothing
local unit c = GetEnteringUnit()
if IntegerCd(c,"move cd",3) then 
call ImmuneToPushDebuff(c)
call MUE(c,800,0.3,90*bj_DEGTORAD)
call BuffUnitMS(c,c,0.2)
call SetUnitFacing(c,90)
endif
set c = null
endfunction
function Trig_PushBottom takes nothing returns nothing
local unit c = GetEnteringUnit()
if IntegerCd(c,"move cd",3) then 
call ImmuneToPushDebuff(c)
call MUE(c,800,0.3,270*bj_DEGTORAD)
call BuffUnitMS(c,c,0.2)
call SetUnitFacing(c,270)
endif
set c = null
endfunction
function Trig_PushLeft takes nothing returns nothing
local unit c = GetEnteringUnit()
if IntegerCd(c,"move cd",3) then 
call ImmuneToPushDebuff(c)
call MUE(c,800,0.3,180*bj_DEGTORAD)
call BuffUnitMS(c,c,0.2)
call SetUnitFacing(c,180)
endif
set c = null
endfunction
function Trig_PushRight takes nothing returns nothing
local unit c = GetEnteringUnit()
if IntegerCd(c,"move cd",3) then 
call ImmuneToPushDebuff(c)
call MUE(c,800,0.3,0*bj_DEGTORAD)
call BuffUnitMS(c,c,0.2)
call SetUnitFacing(c,0)
endif
set c = null
endfunction

//===========================================================================
function InitTrig_EnterRegion takes nothing returns nothing
local trigger t1 = CreateTrigger(  )
local trigger ar1 = CreateTrigger(  )
local trigger ar2 = CreateTrigger(  )
local trigger ar3 = CreateTrigger(  )
local trigger ar4 = CreateTrigger(  )
call TriggerRegisterEnterRectSimple( ar1, gg_rct_SpeedTop1 )
call TriggerRegisterEnterRectSimple( ar1, gg_rct_SpeedTop2 )
    call TriggerAddCondition( ar1, Condition( function Trig_EnterRegion_Conditions ) )
    call TriggerAddAction( ar1, function Trig_PushTop )
call TriggerRegisterEnterRectSimple( ar2, gg_rct_SpeedBottom1 )
call TriggerRegisterEnterRectSimple( ar2, gg_rct_SpeedBottom2 )
    call TriggerAddCondition( ar2, Condition( function Trig_EnterRegion_Conditions ) )
    call TriggerAddAction( ar2, function Trig_PushBottom )
call TriggerRegisterEnterRectSimple( ar3, gg_rct_SpeedRight1 )
call TriggerRegisterEnterRectSimple( ar3, gg_rct_SpeedRight2 )
    call TriggerAddCondition( ar3, Condition( function Trig_EnterRegion_Conditions ) )
    call TriggerAddAction( ar3, function Trig_PushRight )
call TriggerRegisterEnterRectSimple( ar4, gg_rct_SpeedLeft1 )
call TriggerRegisterEnterRectSimple( ar4, gg_rct_SpeedLeft2 )
    call TriggerAddCondition( ar4, Condition( function Trig_EnterRegion_Conditions ) )
    call TriggerAddAction( ar4, function Trig_PushLeft )
call TriggerRegisterEnterRectSimple( t1, gg_rct_Go2 )
    call TriggerAddCondition( t1, Condition( function Trig_EnterRegion_Conditions ) )
    call TriggerAddAction( t1, function Trig_EnterRegion_ActionsGO )
    set gg_trg_EnterRegion = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_EnterRegion, gg_rct_Shop )
    call TriggerAddCondition( gg_trg_EnterRegion, Condition( function Trig_EnterRegion_Conditions ) )
    call TriggerAddAction( gg_trg_EnterRegion, function Trig_EnterRegion_Actions )
set t1 = null
endfunction
