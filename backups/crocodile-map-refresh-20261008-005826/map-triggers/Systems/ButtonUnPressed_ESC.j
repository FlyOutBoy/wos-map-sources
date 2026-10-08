
function Trig_ButtonUnPressed_ESC_Actions takes nothing returns nothing
    local player pl = GetTriggerPlayer()
    local integer pId = GetHandleId(pl)
    local timer t = LoadTimerHandle(hs, pId, StringHash("esc_timer"))
    
    // Если таймер существовал (игрок реально отпустил кнопку)
    if t != null then
        call PauseTimer(t)
        call FlushChildHashtable(hs, GetHandleId(t)) // Очищаем данные внутри таймера
        call DestroyTimer(t)
        
        // Удаляем таймер и сбрасываем время удержания в хэше игрока
        call RemoveSavedHandle(hs, pId, StringHash("esc_timer"))
        call SaveReal(hs, pId, StringHash("esc_hold_time"), 0.0)
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

