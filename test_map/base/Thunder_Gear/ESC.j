
function Trig_ESC_ACT takes nothing returns nothing
local integer i = GetPlayerId(GetTriggerPlayer()) //GetPlayerId(GetTriggerPlayer()) // 0 - красный игрок
local unit c = Hero[i] 
if  LoadInteger(hs, GetHandleId(Player(i)), StringHash("r start")) == 1 then          
    call SaveInteger(hs, GetHandleId(Player(i)), StringHash("r cancel"), 1)   
    endif
    if GetUnitTypeId(Hero[i]) == Tomioka_ID then 
call SaveInteger(hs,GetHandleId(Hero[i]),StringHash("tomioka esc"),1)
endif
    if GetUnitTypeId(Hero[i]) == Gojo_ID and LoadInteger(hs, GetHandleId(Hero[i]), StringHash("purple")) == 1 then 
call SaveInteger(hs,GetHandleId(Hero[i]),StringHash("skip t"),1)
endif
call SaveInteger(hs, GetHandleId(Hero[i]), StringHash("Kenjaku Stacks"), 6)

if HeroSelector_testing then 
//call FogEnable(false)
//call FogMaskEnable(false)
call UnitResetCooldown(Hero[i])
 set udg_RK_KOTH_ENABLED = false
call DisableTrigger(gg_trg_KOTH_Loop)
call PauseTimer(AntiMh)
if GetLocalPlayer() == Player(i) then 
call ClearTextMessages()
endif
call SetHpCurrent(Hero[i],999999)
call SetMpCurrent(Hero[i],999999)
call SetPlayerState(Player(i), PLAYER_STATE_RESOURCE_GOLD, 999999)
call SetHeroLevel(Hero[i],35,false)
endif
set c = null
endfunction

//===========================================================================
function InitTrig_ESC takes nothing returns nothing
local integer i = 0
local trigger trg2 = CreateTrigger()
    loop
    exitwhen i== 12
    call TriggerRegisterPlayerEvent(trg2, Player(i), EVENT_PLAYER_END_CINEMATIC)
    set i = i + 1
    endloop
    call TriggerAddAction( trg2, function Trig_ESC_ACT )
    set trg2 = null
endfunction

