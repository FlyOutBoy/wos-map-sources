
function SetupObserverHpBarDiplomacy takes nothing returns nothing
    local integer observerPid = 10 // Игрок 11
    local integer gamePid

    loop
        exitwhen observerPid >= 15 // До игрока 15 включительно

        set gamePid = 0
        loop
            exitwhen gamePid >= 10

            if gamePid < 5 then
                // Для наблюдателя игроки 1-5 имеют союзные HP-бары.
                call SetPlayerAlliance(Player(observerPid), Player(gamePid), ALLIANCE_PASSIVE, true)
            else
                // Игроки 6-10 имеют вражеские HP-бары.
                call SetPlayerAlliance(Player(observerPid), Player(gamePid), ALLIANCE_PASSIVE, false)
            endif

            // Игровые игроки не считают наблюдателей союзниками.
            call SetPlayerAlliance(Player(gamePid), Player(observerPid), ALLIANCE_PASSIVE, false)

            // Никакого управления и общего обзора.
            call SetPlayerAlliance(Player(observerPid), Player(gamePid), ALLIANCE_SHARED_CONTROL, false)
            call SetPlayerAlliance(Player(gamePid), Player(observerPid), ALLIANCE_SHARED_CONTROL, false)

            call SetPlayerAlliance(Player(observerPid), Player(gamePid), ALLIANCE_SHARED_ADVANCED_CONTROL, false)
            call SetPlayerAlliance(Player(gamePid), Player(observerPid), ALLIANCE_SHARED_ADVANCED_CONTROL, false)

            call SetPlayerAlliance(Player(observerPid), Player(gamePid), ALLIANCE_SHARED_VISION, false)
            call SetPlayerAlliance(Player(gamePid), Player(observerPid), ALLIANCE_SHARED_VISION, false)

            set gamePid = gamePid + 1
        endloop

        set observerPid = observerPid + 1
    endloop
endfunction
function Trig_INITSS_Actions takes nothing returns nothing
call SetupObserverHpBarDiplomacy()
endfunction

//===========================================================================
function InitTrig_INITSS takes nothing returns nothing
    set gg_trg_INITSS = CreateTrigger(  )
    call DisableTrigger( gg_trg_INITSS )
    call TriggerRegisterTimerEventSingle( gg_trg_INITSS, 0.01 )
    call TriggerAddAction( gg_trg_INITSS, function Trig_INITSS_Actions )
endfunction

