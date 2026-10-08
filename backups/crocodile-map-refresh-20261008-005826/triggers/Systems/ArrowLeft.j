function Trig_ArrowLeft_Actions takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer i = GetPlayerId(p)
    local integer id = 'Hblm'

    if TestMode == true then
        call TestUnit_ToggleHeroPicker(p, TestUnitPickEnemy)
    endif

    if TestMode == false or (TestMode == true and EffectActive[i] == true) then
        if TestMode == true or VIPCheckLvl3(FramePlayerFirstName[i]) then
            if AttachDonat2[i] == null then
                call DestroyEffect(AttachDonat1[i])
                call DestroyEffect(AttachDonat3[i])
                call DestroyEffect(AttachDonat4[i])
                set AttachDonat1[i] = null
                set AttachDonat3[i] = null
                set AttachDonat4[i] = null
                set id = LoadInteger(hs, GetHandleId(Player(i)), StringHash("donat left"))
                call SetActiveDonat(i, 2, id)
                if id == 0 then
                    set AttachDonat2[i] = AddSpecialEffectTarget("war3mapimported\\wos_qpanda_putong_san01.mdx", Hero[i], "origin")
                elseif id == 1 then
                    set AttachDonat2[i] = AddSpecialEffectTarget("war3mapimported\\wos_qpanda_putong_san02.mdx", Hero[i], "origin")
                elseif id == 2 then
                    set AttachDonat2[i] = AddSpecialEffectTarget("war3mapimported\\wos_qpanda_putong_san03.mdx", Hero[i], "origin")
                elseif id == 3 then
                    set AttachDonat2[i] = AddSpecialEffectTarget("war3mapimported\\wos_qpanda_putong_san04.mdx", Hero[i], "origin")
                endif
                set id = id + 1
                if id > 3 then
                    set id = 0
                endif
                call SaveInteger(hs, GetHandleId(Player(i)), StringHash("donat left"), id)
            else
                call DestroyEffect(AttachDonat2[i])
                set AttachDonat2[i] = null
                call SetActiveDonat(i, 0, 0)
            endif
        elseif VIPCheckLvl2(FramePlayerFirstName[i]) then
            if AttachDonat2[i] == null then
                call DestroyEffect(AttachDonat1[i])
                call DestroyEffect(AttachDonat3[i])
                call DestroyEffect(AttachDonat4[i])
                set AttachDonat1[i] = null
                set AttachDonat3[i] = null
                set AttachDonat4[i] = null
                set AttachDonat2[i] = AddSpecialEffectTarget("war3mapImported\\wos_scghmx (6).mdl", Hero[i], "origin")
                call SetActiveDonat(i, 2, 0)
            else
                call DestroyEffect(AttachDonat2[i])
                set AttachDonat2[i] = null
                call SetActiveDonat(i, 0, 0)
            endif
        endif
    endif

    set p = null
endfunction

//===========================================================================
function InitTrig_ArrowLeft takes nothing returns nothing
    local integer i = 0
    set gg_trg_ArrowLeft = CreateTrigger()
    loop
        exitwhen i == 10
        call TriggerRegisterPlayerKeyEventBJ(gg_trg_ArrowLeft, Player(i), bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_LEFT)
        set i = i + 1
    endloop
    call TriggerAddAction(gg_trg_ArrowLeft, function Trig_ArrowLeft_Actions)
endfunction

