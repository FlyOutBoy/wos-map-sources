globals
    // Hashed once at map load (was StringHash(...) on every call).
        integer SH_ButtonUnPressed_ESC_ESC_HOLD_TIME = StringHash("esc_hold_time")
        integer SH_ButtonUnPressed_ESC_ESC_TIMER = StringHash("esc_timer")
endglobals

function Trig_ButtonUnPressed_ESC_Actions takes nothing returns nothing
    local player pl = GetTriggerPlayer()
    local integer pId = GetHandleId(pl)
    local timer t = LoadTimerHandle(hs, pId, SH_ButtonUnPressed_ESC_ESC_TIMER)
    
    // Если таймер существовал (игрок реально отпустил кнопку)
    if t != null then
        call PauseTimer(t)
        call FlushChildHashtable(hs, GetHandleId(t)) // Очищаем данные внутри таймера
        call DestroyTimer(t)
        
        // Удаляем таймер и сбрасываем время удержания в хэше игрока
        call RemoveSavedHandle(hs, pId, SH_ButtonUnPressed_ESC_ESC_TIMER)
        call SaveReal(hs, pId, SH_ButtonUnPressed_ESC_ESC_HOLD_TIME, 0.0)
    endif
    
    set pl = null
    set t = null
endfunction



//===========================================================================
function InitTrig_ButtonUnPressed_ESC takes nothing returns nothing
     local integer i = 0
    set gg_trg_ButtonUnPressed_ESC = CreateTrigger(  )
    call TriggerAddAction(gg_trg_ButtonUnPressed_ESC, function Trig_ButtonUnPressed_ESC_Actions)
endfunction

