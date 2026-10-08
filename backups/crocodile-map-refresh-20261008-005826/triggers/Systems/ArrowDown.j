function Trig_ArrowDown_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetTriggerPlayer())
    if TestMode == true then
        call RootUnit(Hero[i], Hero[i], 2)
    endif
    if TestMode == false or (TestMode == true and EffectActive[i] == true) then
        if TestMode == true or VIPCheckLvl2(FramePlayerFirstName[i]) or VIPCheckLvl3(FramePlayerFirstName[i]) then
            if AttachDonat4[i] == null then
                call DestroyEffect(AttachDonat1[i])
                call DestroyEffect(AttachDonat2[i])
                call DestroyEffect(AttachDonat3[i])
                set AttachDonat1[i] = null
                set AttachDonat2[i] = null
                set AttachDonat3[i] = null
                set AttachDonat4[i] = AddSpecialEffectTarget("war3mapImported\\wos_raidensymbol.mdx", Hero[i], "origin")
                call SetActiveDonat(i, 4, 0)
            else
                call DestroyEffect(AttachDonat4[i])
                set AttachDonat4[i] = null
                call SetActiveDonat(i, 0, 0)
            endif
        endif
    endif
endfunction


//===========================================================================
function InitTrig_ArrowDown takes nothing returns nothing
    local integer i = 0
    set gg_trg_ArrowDown = CreateTrigger()
    loop
    exitwhen i == 10 
    call TriggerRegisterPlayerKeyEventBJ( gg_trg_ArrowDown, Player(i), bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_DOWN )
    set i = i + 1
    endloop
    call TriggerAddAction( gg_trg_ArrowDown, function Trig_ArrowDown_Actions )
endfunction

