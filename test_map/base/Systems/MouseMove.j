globals
real array MouseX
real array MouseY
trigger array MouseTrig
endglobals
function Trig_MouseMove_Actions takes nothing returns nothing
local integer i = GetPlayerId(GetTriggerPlayer())
set MouseX[i] = BlzGetTriggerPlayerMouseX()
set MouseY[i] = BlzGetTriggerPlayerMouseY()
endfunction

//===========================================================================

function Trig_StartMouseTriggers takes nothing returns nothing
    local integer i = 0
    loop
        exitwhen i >= 10
        set MouseTrig[i] = CreateTrigger()      
        call TriggerRegisterPlayerEvent(MouseTrig[i], Player(i), EVENT_PLAYER_MOUSE_DOWN)
        call TriggerAddAction(MouseTrig[i], function Trig_MouseMove_Actions)
        call DisableTrigger(MouseTrig[i]) // по дефолту выключен
        set i = i + 1
    endloop
endfunction

function InitTrig_MouseMove takes nothing returns nothing
    set gg_trg_MouseMove = CreateTrigger()
    call TriggerRegisterTimerEvent(gg_trg_MouseMove, 0.01, false)
    call TriggerAddAction( gg_trg_MouseMove, function Trig_StartMouseTriggers )
endfunction

