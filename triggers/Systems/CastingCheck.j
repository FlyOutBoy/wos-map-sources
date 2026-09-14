function Trig_CastingCheck_Actions takes nothing returns nothing
    local integer id = GetSpellAbilityId()
    local unit c
    local effect e
    local integer i
    local real x
    local real y
    local integer sh
    if CheckCoordsInRect(gg_rct_Base,GetUnitX(GetSpellAbilityUnit()),GetUnitY(GetSpellAbilityUnit())) == false then 
    if id == ErzaG2_ID then 
    set c = GetSpellAbilityUnit()
        set i = GetHandleId(c) 
        set x = GetUnitX(c)
        set y = GetUnitY(c)
        if LoadInteger(hs,GetHandleId(c),StringHash("erza g2 type")) ==1 then
    call StartSound(gg_snd_Hero_Erza7_G2)
        set sh = StringHash("kaso sfx 3")
    set e = LoadEffectHandle(hs, i, sh)
        if e == null then
            set e = EffectSpawn("war3mapImported\\wos_0713.mdl", x, y, 0, 0.55, 4, 115)
            endif
            call SaveEffectHandle(hs, i, sh, e)
        else
    call StartSound(gg_snd_Hero_Erza6_G1)
    call SaveInteger(hs,GetHandleId(c),StringHash("sound g2 cd"),1)
    call MyFlush(GetHandleId(c),StringHash("sound g2 cd"),1,0.5)
        set sh = StringHash("kaso sfx 3")
    set e = LoadEffectHandle(hs, i, sh)
        if e == null then
            set e = EffectSpawn("war3mapImported\\wos_Evolt-1greenlightning.mdl", x, y, 0, 1, 3.4, 35)
            endif
            call SaveEffectHandle(hs, i, sh, e)
            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_dustwave222.mdx",x,y,GetRandomReal(0,359),0.6,2,0,255,255,255,100))
            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_dustwave222.mdx",x,y,GetRandomReal(0,359),0.7,2.5,0,255,255,255,100))
            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_dustwave222.mdx",x,y,GetRandomReal(0,359),0.8,3,0,255,255,255,100))
            set sh = StringHash("kaso sfx 4")
    set e = LoadEffectHandle(hs, i, sh)
        if e == null then        
        set e = EffectSpawn("war3mapImported\\wos_Opdef (125)2.mdl", x, y, 0, 1, 0.4, 1)
            call ColorEffDummy4(e,0,255,255,255,0.24)
            endif
            call SaveEffectHandle(hs, i, sh, e)            
        endif
    endif
    if id == ErzaQ_ID or id == ErzaW_ID or id == ErzaE_ID or id == ErzaR_ID or id == ErzaT_ID or id == ErzaG2_ID then
        set c = GetSpellAbilityUnit()
        set i = GetHandleId(c)
        set sh = StringHash("kaso sfx 1")
        set x = GetUnitX(c)
        set y = GetUnitY(c)
        set e = LoadEffectHandle(hs, i, sh)
            if IntegerCd(c,"sound f erza cd",10) then 
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapimported\\Hero_Erza_F01")
            else
                call MakeSound("war3mapimported\\Hero_Erza_F02")
            endif
            else
            if GetRandomInt(1, 2) == 1 then
                call MakeSoundLocal("war3mapimported\\Hero_Erza_F01",GetOwningPlayer(c))
            else
                call MakeSoundLocal("war3mapimported\\Hero_Erza_F02",GetOwningPlayer(c))
            endif
        endif
        if e == null then
            set e = EffectSpawn("war3mapimported\\wos_0001.mdl", x, y, 0, 1, 0.65, 0)
            call SaveEffectHandle(hs, i, sh, e)
        endif
        set sh = StringHash("kaso sfx 2")
        set e = LoadEffectHandle(hs, i, sh)
        if e == null then
            set e = EffectSpawn("war3mapimported\\wos_afb (2634).mdl", x, y, 0, 1, 1., 155)
            call SaveEffectHandle(hs, i, sh, e)
        endif
    endif
    endif
    set c = null
    set e = null
endfunction
function Trig_CastingStop_Actions takes nothing returns nothing
    local integer id = GetSpellAbilityId()
    local unit c
    local effect e
    local integer i
    local real x
    local real y
    local integer sh
    if CheckCoordsInRect(gg_rct_Base,GetUnitX(GetSpellAbilityUnit()),GetUnitY(GetSpellAbilityUnit())) == false then 
    if id == ErzaQ_ID or id == ErzaW_ID or id == ErzaE_ID or id == ErzaR_ID or id == ErzaT_ID or id == ErzaG2_ID then
        set c = GetSpellAbilityUnit()
        set i = GetHandleId(c)
        set sh = StringHash("kaso sfx 1")
        set x = GetUnitX(c)
        set y = GetUnitY(c)
        set e = LoadEffectHandle(hs, i, sh)
        if e != null then
            call DestroyEffect(e)
            call RemoveSavedHandle(hs, i, sh)
        endif
        set sh = StringHash("kaso sfx 2")
        set e = LoadEffectHandle(hs, i, sh)
        if e != null then
            call DestroyEffect(e)
            call RemoveSavedHandle(hs, i, sh)
        endif
        if id == ErzaG2_ID then 
        set sh = StringHash("kaso sfx 3")
        set e = LoadEffectHandle(hs, i, sh)
        if e != null then
        call DestroyEffect(e)
        endif
            call RemoveSavedHandle(hs, i, sh)
            if LoadInteger(hs,GetHandleId(c),StringHash("erza g2 type")) ==2 then 
            set sh = StringHash("kaso sfx 4")
        set e = LoadEffectHandle(hs, i, sh)
        if e != null then
        call ColorEffDummy3(e,0,255,255,255,0.21)
            call RemoveSavedHandle(hs, i, sh)
            
            endif
        endif
    if LoadInteger(hs,GetHandleId(c),StringHash("sound g2 cd"))== 1 then
    call StopSound(gg_snd_Hero_Erza6_G1,false,false)
    endif
    endif
    endif
    endif
    set c = null
    set e = null
endfunction
//===========================================================================
function InitTrig_CastingCheck takes nothing returns nothing
    local trigger trig2 = CreateTrigger()
    set gg_trg_CastingCheck = CreateTrigger( )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_CastingCheck, EVENT_PLAYER_UNIT_SPELL_CHANNEL )
    call TriggerRegisterAnyUnitEventBJ( trig2, EVENT_PLAYER_UNIT_SPELL_ENDCAST )
    call TriggerAddAction( gg_trg_CastingCheck, function Trig_CastingCheck_Actions )
    call TriggerAddAction( trig2, function Trig_CastingStop_Actions )
    set trig2 = null
endfunction


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
