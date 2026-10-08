function ESC_Hold_Timer_Tick takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer timerId = GetHandleId(t)
    local integer playerId = LoadInteger(hs, timerId, 0)
    local player p = Player(playerId)
    local unit selected = GetSelectedHeroForPlayer(p)
    local real holdTime = LoadReal(hs, GetHandleId(p), StringHash("esc_hold_time")) + 0.05

    if TestMode == true and holdTime >= 0.3 then
        if selected != null then
            call SetHeroLevel(selected, 35, true)
        endif
        set holdTime = 0.0
    endif

    call SaveReal(hs, GetHandleId(p), StringHash("esc_hold_time"), holdTime)

    set selected = null
    set t = null
    set p = null
endfunction

function Trig_ButtonPressed_ESC_Actions takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer playerHandleId = GetHandleId(p)
    local timer t

    if TestMode == true and LoadTimerHandle(hs, playerHandleId, StringHash("esc_timer")) == null then
        set t = CreateTimer()
        call SaveInteger(hs, GetHandleId(t), 0, GetPlayerId(p))
        call SaveTimerHandle(hs, playerHandleId, StringHash("esc_timer"), t)
        call SaveReal(hs, playerHandleId, StringHash("esc_hold_time"), 0.0)
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
