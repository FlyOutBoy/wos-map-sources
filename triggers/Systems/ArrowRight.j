function Trig_ArrowRight_Actions takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer i = GetPlayerId(p)
    local integer id = Erza_ID

    if TestMode == true then
        call TestUnit_ToggleHeroPicker(p, TestUnitPickAlly)
    endif

    if TestMode == false or (TestMode == true and EffectActive[i] == true) then
        if TestMode == true or VIPCheckLvl2(FramePlayerFirstName[i]) or VIPCheckLvl3(FramePlayerFirstName[i]) then
            if AttachDonat3[i] == null then
                call DestroyEffect(AttachDonat1[i])
                call DestroyEffect(AttachDonat2[i])
                call DestroyEffect(AttachDonat4[i])
                set AttachDonat1[i] = null
                set AttachDonat2[i] = null
                set AttachDonat4[i] = null
                if VIPCheckLvl3(FramePlayerFirstName[i]) then
                    set id = LoadInteger(hs, GetHandleId(Player(i)), StringHash("donat right"))
                    call SetActiveDonat(i, 3, id)
                    if id == 0 then
                        set AttachDonat3[i] = AddSpecialEffectTarget("war3mapImported\\wos_ncow_sfx_sharingan3tomoe.mdx", Hero[i], "origin")
                    elseif id == 1 then
                        set AttachDonat3[i] = AddSpecialEffectTarget("war3mapimported\\wos_sharin_mad.mdx", Hero[i], "origin")
                    elseif id == 2 then
                        set AttachDonat3[i] = AddSpecialEffectTarget("war3mapimported\\wos_sharin_ita.mdx", Hero[i], "origin")
                    elseif id == 3 then
                        set AttachDonat3[i] = AddSpecialEffectTarget("war3mapimported\\wos_sharin_sas.mdx", Hero[i], "origin")
                    elseif id == 4 then
                        set AttachDonat3[i] = AddSpecialEffectTarget("war3mapimported\\wos_sharin_kak.mdx", Hero[i], "origin")
                    endif
                    set id = id + 1
                    if id > 4 then
                        set id = 0
                    endif
                    call SaveInteger(hs, GetHandleId(Player(i)), StringHash("donat right"), id)
                else
                    set AttachDonat3[i] = AddSpecialEffectTarget("war3mapImported\\wos_ncow_sfx_sharingan3tomoe.mdx", Hero[i], "origin")
                    call SetActiveDonat(i, 3, 0)
                endif
            else
                call DestroyEffect(AttachDonat3[i])
                set AttachDonat3[i] = null
                call SetActiveDonat(i, 0, 0)
            endif
        endif
    endif

    set p = null
endfunction

//===========================================================================
function InitTrig_ArrowRight takes nothing returns nothing
    local integer i = 0
    set gg_trg_ArrowRight = CreateTrigger()
    loop
        exitwhen i == 10
        call TriggerRegisterPlayerKeyEventBJ(gg_trg_ArrowRight, Player(i), bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_RIGHT)
        set i = i + 1
    endloop
    call TriggerAddAction(gg_trg_ArrowRight, function Trig_ArrowRight_Actions)
endfunction

