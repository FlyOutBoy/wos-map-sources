function SetupObserverHpBarDiplomacy takes nothing returns nothing
    local integer observerPid = 10
    local integer gamePid

    loop
        exitwhen observerPid >= 15

        set gamePid = 0
        loop
            exitwhen gamePid >= 10

            // Observer -> gameplay player controls the native HP-bar relation.
            call SetPlayerAlliance(Player(observerPid), Player(gamePid), ALLIANCE_PASSIVE, gamePid < 5)

            // Gameplay players never consider observers allies.
            call SetPlayerAlliance(Player(gamePid), Player(observerPid), ALLIANCE_PASSIVE, false)

            // HP-bar coloring must not grant any gameplay benefits.
            call SetPlayerAlliance(Player(observerPid), Player(gamePid), ALLIANCE_HELP_REQUEST, false)
            call SetPlayerAlliance(Player(gamePid), Player(observerPid), ALLIANCE_HELP_REQUEST, false)
            call SetPlayerAlliance(Player(observerPid), Player(gamePid), ALLIANCE_HELP_RESPONSE, false)
            call SetPlayerAlliance(Player(gamePid), Player(observerPid), ALLIANCE_HELP_RESPONSE, false)
            call SetPlayerAlliance(Player(observerPid), Player(gamePid), ALLIANCE_SHARED_XP, false)
            call SetPlayerAlliance(Player(gamePid), Player(observerPid), ALLIANCE_SHARED_XP, false)
            call SetPlayerAlliance(Player(observerPid), Player(gamePid), ALLIANCE_SHARED_SPELLS, false)
            call SetPlayerAlliance(Player(gamePid), Player(observerPid), ALLIANCE_SHARED_SPELLS, false)
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
    set gg_trg_INITSS = CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_INITSS, 0.01)
    call TriggerAddAction(gg_trg_INITSS, function Trig_INITSS_Actions)
endfunction
