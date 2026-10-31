
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
call WUI_EnterExclusiveWindow(0, p)
 if GetLocalPlayer() == p then 
call StartSound(gg_snd_wos_shopenter)
call BlzFrameSetVisible(FRAME_ShopMAIN,true)
endif
set p = null
endfunction
// Test heroes have owners reserved for shared control, not extra human ready slots.
function TestUnit_FastStartReady takes nothing returns boolean
    local integer i = 0
    local integer required = 0
    local integer ready = 0
    local unit u
    loop
        exitwhen i == 10
        set u = Hero[i]
        if IsActivePlayerSlot(i) and not (u != null and (u == TestUnit or u == TestAllyUnit)) then
            set required = required + 1
            if u != null and CheckCoordsInRect(gg_rct_Go, GetUnitX(u), GetUnitY(u)) then
                set ready = ready + 1
            endif
        endif
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i == 2
        if i == 0 then
            set u = TestUnit
        else
            set u = TestAllyUnit
        endif
        if u != null and GetUnitTypeId(u) != 0 then
            set required = required + 1
            if CheckCoordsInRect(gg_rct_Go, GetUnitX(u), GetUnitY(u)) then
                set ready = ready + 1
            endif
        endif
        set i = i + 1
    endloop
    set u = null
    return required > 0 and ready == required
endfunction

function Trig_EnterRegion_ActionsGO takes nothing returns nothing
local player p = GetOwningPlayer(GetEnteringUnit())
local integer id = GetPlayerId(p)
local group g = null
local unit u = null
local integer counter = 0
local integer countercheck = 0
local integer i = 0
local integer unitPid = -1
if not IsGamePlayerSlot(id) then
set g = null
set p = null
return
endif
if TestMode then
    if END1 == 0 and CondArena == 0 and inststart == 0 and TestUnit_FastStartReady() then
        set inststart = 1
        call PlayersMsg(GetPlayerVisualColorString(p) + "Round starts immediately!|r", 1)
        set TimeMove = TimeRound - 1
    endif
    set p = null
    return
endif
set g = CreateGroup()
if END1 == 0 and (((CapPickPhase == 2 or CapPickPhase == 4) and CaptainMode == true) or CaptainMode == false) then 
if IntegerCdKey(GetEnteringUnit(), SH_ICD_ROUND_INSTANT_START_CD,5) then 
call PlayersMsg(GetPlayerVisualColorString(p)+GetPlayerName(p)+"|r wants to start next round immediatly...",1)
endif 
loop
exitwhen i == 10
if IsActivePlayerSlot(i) then
set countercheck = countercheck + 1
endif
set i = i + 1
endloop
call GroupEnumUnitsInRect(g,gg_rct_Go,null)
loop
set u = FirstOfGroup(g)
exitwhen u == null 
set unitPid = GetPlayerId(GetOwningPlayer(u))
if IsActivePlayerSlot(unitPid) and u == Hero[unitPid] and IsUnitType(u,UNIT_TYPE_HERO) and IsUnitIllusion(u)== false then
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
if IntegerCdKey(c, SH_ICD_MOVE_CD,3) then 
call ImmuneToPushDebuff(c)
call MUE(c,800,0.3,90*bj_DEGTORAD)
call BuffUnitMS(c,c,0.2)
call SetUnitFacing(c,90)
endif
set c = null
endfunction
function Trig_PushBottom takes nothing returns nothing
local unit c = GetEnteringUnit()
if IntegerCdKey(c, SH_ICD_MOVE_CD,3) then 
call ImmuneToPushDebuff(c)
call MUE(c,800,0.3,270*bj_DEGTORAD)
call BuffUnitMS(c,c,0.2)
call SetUnitFacing(c,270)
endif
set c = null
endfunction
function Trig_PushLeft takes nothing returns nothing
local unit c = GetEnteringUnit()
if IntegerCdKey(c, SH_ICD_MOVE_CD,3) then 
call ImmuneToPushDebuff(c)
call MUE(c,800,0.3,180*bj_DEGTORAD)
call BuffUnitMS(c,c,0.2)
call SetUnitFacing(c,180)
endif
set c = null
endfunction
function Trig_PushRight takes nothing returns nothing
local unit c = GetEnteringUnit()
if IntegerCdKey(c, SH_ICD_MOVE_CD,3) then 
call ImmuneToPushDebuff(c)
call MUE(c,800,0.3,0*bj_DEGTORAD)
call BuffUnitMS(c,c,0.2)
call SetUnitFacing(c,0)
endif
set c = null
endfunction

globals
    integer HeroUnstuckCastKey = StringHash("spell p")
    item HeroUnstuckProbe = null
    timer HeroUnstuckTimer = CreateTimer()
endglobals

function HeroUnstuck_Point takes real x, real y returns boolean
    local boolean valid
    if x <= GetRectMinX(bj_mapInitialPlayableArea)+32.0 or x >= GetRectMaxX(bj_mapInitialPlayableArea)-32.0 or y <= GetRectMinY(bj_mapInitialPlayableArea)+32.0 or y >= GetRectMaxY(bj_mapInitialPlayableArea)-32.0 or IsTerrainPathable(x,y,PATHING_TYPE_WALKABILITY) then
        return false
    endif
    call SetItemVisible(HeroUnstuckProbe,true)
    call SetItemPosition(HeroUnstuckProbe,x,y)
    set valid = RAbsBJ(GetItemX(HeroUnstuckProbe)-x) <= 16.0 and RAbsBJ(GetItemY(HeroUnstuckProbe)-y) <= 16.0
    call SetItemVisible(HeroUnstuckProbe,false)
    return valid
endfunction

function HeroUnstuck_Free takes real x, real y returns boolean
    return HeroUnstuck_Point(x,y) and HeroUnstuck_Point(x+24.0,y+24.0) and HeroUnstuck_Point(x-24.0,y+24.0) and HeroUnstuck_Point(x+24.0,y-24.0) and HeroUnstuck_Point(x-24.0,y-24.0)
endfunction

function HeroUnstuck_Unit takes unit u returns nothing
    local real x
    local real y
    local real radius = 64.0
    local real angle
    local real nx
    local real ny
    local integer ray
    if u == null or GetUnitTypeId(u) == 0 or GetWidgetLife(u) <= 0.405 or IsUnitHidden(u) or IsUnitPaused(u) or IsUnitType(u,UNIT_TYPE_FLYING) or GetUnitFlyHeight(u) > 50.0 or LoadInteger(hs,GetHandleId(u),HeroUnstuckCastKey) > 0 then
        return
    endif
    set x = GetUnitX(u)
    set y = GetUnitY(u)
    // A hero at an ordinary wall/another unit is fine; only an invalid centre is repaired.
    if HeroUnstuck_Point(x,y) then
        return
    endif
    loop
        exitwhen radius > 1536.0
        set ray = 0
        loop
            exitwhen ray >= 16
            set angle = I2R(ray)*bj_PI/8.0
            set nx = x+radius*Cos(angle)
            set ny = y+radius*Sin(angle)
            if HeroUnstuck_Free(nx,ny) then
                call SetUnitX(u,nx)
                call SetUnitY(u,ny)
                return
            endif
            set ray = ray+1
        endloop
        set radius = radius+64.0
    endloop
endfunction

function HeroUnstuck_Tick takes nothing returns nothing
    local integer i = 0
    loop
        exitwhen i >= 10
        call HeroUnstuck_Unit(Hero[i])
        set i = i+1
    endloop
    if TestMode then
        if TestUnit != null and TestUnit != Hero[TestUnitPlayerId] then
            call HeroUnstuck_Unit(TestUnit)
        endif
        if TestAllyUnit != null and TestAllyUnit != Hero[TestAllyUnitPlayerId] then
            call HeroUnstuck_Unit(TestAllyUnit)
        endif
    endif
endfunction

//===========================================================================
function InitTrig_EnterRegion takes nothing returns nothing
local trigger t1 = CreateTrigger(  )
local trigger ar1 = CreateTrigger(  )
local trigger ar2 = CreateTrigger(  )
local trigger ar3 = CreateTrigger(  )
local trigger ar4 = CreateTrigger(  )
set HeroUnstuckProbe = CreateItem('wolg',GetRectCenterX(gg_rct_Caster),GetRectCenterY(gg_rct_Caster))
call SetItemVisible(HeroUnstuckProbe,false)
call SetItemInvulnerable(HeroUnstuckProbe,true)
call TimerStart(HeroUnstuckTimer,2.0,true,function HeroUnstuck_Tick)
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
