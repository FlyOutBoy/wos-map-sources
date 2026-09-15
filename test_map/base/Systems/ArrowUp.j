globals
    effect array AttachDonat1
    effect array AttachDonat2
    effect array AttachDonat3
    effect array AttachDonat4
    hashtable CloneVisualCache = InitHashtable()
    integer array ActiveDonatType
    integer array ActiveDonatVariant
    integer array HeroCloneRevision
    boolean array EffectActive 
endglobals
function Trig_ArrowUp_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetTriggerPlayer())
    local integer id = 0
    if TestMode == true then
        call StunUnit(Hero[i], Hero[i], 2)
    endif
    if TestMode == false or (TestMode == true and EffectActive[i] == true) then
        if TestMode == true or VIPCheckLvl2(FramePlayerFirstName[i]) or VIPCheckLvl3(FramePlayerFirstName[i]) then
            if AttachDonat1[i] == null then
                call DestroyEffect(AttachDonat2[i])
                call DestroyEffect(AttachDonat3[i])
                call DestroyEffect(AttachDonat4[i])
                set AttachDonat2[i] = null
                set AttachDonat3[i] = null
                set AttachDonat4[i] = null
                set id = LoadInteger(hs, GetHandleId(Player(i)), StringHash("donat up"))
                call SetActiveDonat(i, 1, id)
                if id == 0 then
                    set AttachDonat1[i] = AddSpecialEffectTarget("war3mapimported\\wos_scghmx (6).mdx", Hero[i], "origin")
                elseif id == 1 then
                    set AttachDonat1[i] = AddSpecialEffectTarget("war3mapimported\\wos_scghmx (9).mdx", Hero[i], "origin")
                elseif id == 2 then
                    set AttachDonat1[i] = AddSpecialEffectTarget("war3mapimported\\wos_firet1_aura.mdl", Hero[i], "origin")
                endif
                set id = id + 1
                if id > 2 then
                    set id = 0
                endif
                call SaveInteger(hs, GetHandleId(Player(i)), StringHash("donat up"), id)
            else
                call DestroyEffect(AttachDonat1[i])
                set AttachDonat1[i] = null
                call SetActiveDonat(i, 0, 0)
            endif
        elseif VIPCheckLvl1(FramePlayerFirstName[i]) then
            if AttachDonat1[i] == null then
                call DestroyEffect(AttachDonat2[i])
                call DestroyEffect(AttachDonat3[i])
                call DestroyEffect(AttachDonat4[i])
                set AttachDonat2[i] = null
                set AttachDonat3[i] = null
                set AttachDonat4[i] = null
                set AttachDonat1[i] = AddSpecialEffectTarget("war3mapImported\\wos_scghmx (9).mdl", Hero[i], "origin")
                call SetActiveDonat(i, 1, 0)
            else
                call DestroyEffect(AttachDonat1[i])
                set AttachDonat1[i] = null
                call SetActiveDonat(i, 0, 0)
            endif
        endif
    endif
endfunction


//===========================================================================
function InitTrig_ArrowUp takes nothing returns nothing
    local integer i = 0
    set gg_trg_ArrowUp = CreateTrigger()
    loop
    exitwhen i == 10 
    call TriggerRegisterPlayerKeyEventBJ( gg_trg_ArrowUp, Player(i), bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_UP )
    set i = i + 1
    endloop
    call TriggerAddAction( gg_trg_ArrowUp, function Trig_ArrowUp_Actions )
endfunction

