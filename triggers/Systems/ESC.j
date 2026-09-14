function Trig_ESC_ACT takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local integer stacks = 0
    local unit selected = GetSelectedHeroForPlayer(p)

    if selected == null then
        if GetLocalPlayer() == p then
            call ClearTextMessages()
        endif
        set p = null
        return
    endif

    if TestMode == true then
        if GetUnitTypeId(selected) == Kenjaku_ID then
            set stacks = LoadInteger(hs, GetHandleId(selected), StringHash("Kenjaku Stacks"))
            call SaveInteger(hs, GetHandleId(selected), StringHash("Kenjaku Stacks"), stacks + 2)
        endif

        if GetLocalPlayer() == p then
            call ClearTextMessages()
        endif

        call ReviveHero(selected, GetUnitX(selected), GetUnitY(selected), false)
        call SetHpCurrent(selected, 9999999)
        call SpellStacksResetForEscape(selected)
        if GetUnitTypeId(selected) != Toji_ID then
            call SetMpCurrent(selected, 999999)
        endif
        call UnitResetCooldown(selected)
        call SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, 999999)
    endif

    set selected = null
    set p = null
endfunction

//===========================================================================
function InitTrig_ESC takes nothing returns nothing
    local integer i = 0
    local trigger trg2 = CreateTrigger()
    loop
        exitwhen i == 12
        call TriggerRegisterPlayerEvent(trg2, Player(i), EVENT_PLAYER_END_CINEMATIC)
        set i = i + 1
    endloop
    call TriggerAddAction(trg2, function Trig_ESC_ACT)
    set trg2 = null
endfunction

