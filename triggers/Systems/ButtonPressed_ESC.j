globals
    // Hashed once at map load (was StringHash(...) on every call).
        integer SH_ButtonPressed_ESC_ESC_HOLD_TIME = StringHash("esc_hold_time")
        integer SH_ButtonPressed_ESC_ESC_TIMER = StringHash("esc_timer")
endglobals
function ESC_Hold_Timer_Tick takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer timerId = GetHandleId(t)
    local integer playerId = LoadInteger(hs, timerId, 0)
    local player p = Player(playerId)
    local unit selected = GetSelectedHeroForPlayer(p)
    local real holdTime = LoadReal(hs, GetHandleId(p), SH_ButtonPressed_ESC_ESC_HOLD_TIME) + 0.05

    if TestMode == true and holdTime >= 0.3 then
        if selected != null then
            call SetHeroLevel(selected, 35, true)
        endif
        set holdTime = 0.0
    endif

    call SaveReal(hs, GetHandleId(p), SH_ButtonPressed_ESC_ESC_HOLD_TIME, holdTime)

    set selected = null
    set t = null
    set p = null
endfunction

function Trig_ButtonPressed_ESC_Actions takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer playerHandleId = GetHandleId(p)
    local timer t

    if TestMode == true and LoadTimerHandle(hs, playerHandleId, SH_ButtonPressed_ESC_ESC_TIMER) == null then
        set t = CreateTimer()
        call SaveInteger(hs, GetHandleId(t), 0, GetPlayerId(p))
        call SaveTimerHandle(hs, playerHandleId, SH_ButtonPressed_ESC_ESC_TIMER, t)
        call SaveReal(hs, playerHandleId, SH_ButtonPressed_ESC_ESC_HOLD_TIME, 0.0)
        call TimerStart(t, 0.05, true, function ESC_Hold_Timer_Tick)
    endif

    set p = null
    set t = null
endfunction

//===========================================================================
function InitTrig_ButtonPressed_ESC takes nothing returns nothing
    set gg_trg_ButtonPressed_ESC = CreateTrigger()
    call TriggerAddAction(gg_trg_ButtonPressed_ESC, function Trig_ButtonPressed_ESC_Actions)
endfunction
