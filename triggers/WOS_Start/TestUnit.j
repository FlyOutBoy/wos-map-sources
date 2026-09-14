function Trig_TestUnit_Actions takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local unit selected = GetTriggerUnit()
    local integer pid = GetPlayerId(p)

    // Запоминаем только собственного героя либо один из двух тестовых героев.
    if IsUnitType(selected, UNIT_TYPE_HERO) and (GetOwningPlayer(selected) == p or (TestMode and (selected == TestUnit or selected == TestAllyUnit))) then
        set HeroChosen[pid] = selected
        if selected == TestUnit then
            call TestUnit_ConfigureControl(p, TestUnitPlayerId, false)
        elseif selected == TestAllyUnit then
            call TestUnit_ConfigureControl(p, TestAllyUnitPlayerId, true)
        endif
    else
        set HeroChosen[pid] = Hero[pid]
    endif

    set selected = null
    set p = null
endfunction

//===========================================================================
function InitTrig_TestUnit takes nothing returns nothing
    set gg_trg_TestUnit = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_TestUnit, EVENT_PLAYER_UNIT_SELECTED)
    call TriggerAddAction(gg_trg_TestUnit, function Trig_TestUnit_Actions)
endfunction
