library ErzaBase uses GearSystems, ErzaQSpells
    globals
//--------------------------------------Erza--------------------------------------------------------------
        integer Erza_ID = 'H00H'
        integer ErzaG_ID = 'A031'
        integer ErzaF_ID = 'A030'
        integer ErzaG2_ID = 'A049'
        integer ErzaUnitSkin_ID = 'H00H'
        real Erza_BaseScale = 1.25
        unit array Erza_12Dummy
        unit array Erza_25Dummy
//---------------Q ability-----------------------------------------------------
        integer ErzaQ_ID = 'A02V'
        integer ErzaQ_UnitSkin_ID = 'H00I'
        integer ErzaQ_ArmorStat_ID = 'A045'
        integer ErzaQ_ArmorStatHpBase = 100 // give + 100 hp when in armor at 1 lvl
        integer ErzaQ_ArmorStatHpStep = 50 // give + 100 hp when in armor for each next lvl
//---------------W ability-----------------------------------------------------
        integer ErzaW_ID = 'A02W'
        integer ErzaW_UnitSkin_ID = 'H00J'
        integer ErzaW_Regen0_ID = 'A048'
        integer ErzaW_Regen1_ID = 'A046'
        integer ErzaW_Regen2_ID = 'A043'
        integer ErzaW_Regen3_ID = 'A044'
        integer ErzaW_Regen4_ID = 'A047'
    //    real ErzaW_ArmorStatHpRegenBase = 10 // give + N hp / sec when in armor at 1 lvl
    //    real ErzaW_ArmorStatHpRegenStep = 5 // give + N hp / sec when in armor for each next lvl
//---------------E ability-----------------------------------------------------
        integer ErzaE_ID = 'A02X'
        integer ErzaE_UnitSkin_ID = 'H00K'
        real ErzaE_ArmorStatMpRegenBase = 1 // give + N mp / sec when in armor at 1 lvl
        real ErzaE_ArmorStatMpRegenStep = 0.8 // give + N mp / sec when in armor for each next lvl
        integer ErzaE_ArmorMS_LvLBase_ID = 2 // 2 = 20 ms, base bonus
        integer ErzaE_ArmorMS_LvLStep_ID = 2 // for each next lvl, base + (this * (ability lvl - 1))
//---------------R ability-----------------------------------------------------
        integer ErzaR_ID = 'A02Y'
        integer ErzaR_DummyElementalId = 'h0DI'
        unit array ErzaR_NatsuGrayDummy [10]
        integer ErzaR_UnitSkin_ID = 'H00L'
        integer ErzaR_ArmorStatHpBase = 250 // give + 100 hp when in armor at 1 lvl
        integer ErzaR_ArmorStatHpStep = 150 // give + 100 hp when in armor for each next lvl
        integer ErzaR_ArmorMS_LvLBase_ID = 4 // 2 = 20 ms, base bonus
        integer ErzaR_ArmorMS_LvLStep_ID = 2 // for each next lvl, base + (this * (ability lvl - 1))
        integer ErzaR_ArmorStatAS_ID = 'A041'
        integer ErzaR_ArmorStatEvade_ID = 'A040'
//---------------T ability-----------------------------------------------------
        integer ErzaT_ID = 'A02Z'
        integer ErzaT_UnitSkin_ID = 'H00M'
        integer ErzaT_ArmorStatHpBase = 1000 // give + 100 hp when in armor at 1 lvl
        //real ErzaT_ArmorStatResistance = 12.5 // in % how much damage would be reduced, pierced by cloud
//---------------G_1 ability-----------------------------------------------------
        integer ErzaG1_UnitSkin_ID = 'H00Q'
        integer ErzaG1_ArmorStatHpBase = 1000 // give + 100 hp when in armor at 1 lvl
        //real ErzaG1_ArmorStatResistance = 10 // in % how much damage would be reduced, pierced by cloud
//---------------G_2 ability-----------------------------------------------------
        integer ErzaG2_UnitSkin_ID = 'H00R'
        integer ErzaG2_ArmorStatHpBase = 1000 // give + 100 hp when in armor at 1 lvl
    endglobals
   
    //----------------------------Erza-----------------------------------------------
     
    function ErzaBaseAbiBlock takes unit c, boolean b returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        call SetPlayerAbilityAvailable(Player(i), ErzaQ_ID, b)
        call SetPlayerAbilityAvailable(Player(i), ErzaW_ID, b)
        call SetPlayerAbilityAvailable(Player(i), ErzaE_ID, b)
        call SetPlayerAbilityAvailable(Player(i), ErzaR_ID, b)
        call SetPlayerAbilityAvailable(Player(i), ErzaT_ID, b)
        if b == false then
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_0706Red.mdl", GetUnitX(c), GetUnitY(c), 0, 1, 3.5, 110))
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_mard effect 2.mdl", GetUnitX(c), GetUnitY(c), 0, 1, 1.35, 0))
        else
            if CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false then
                if GetRandomInt(1, 2) == 1 then
                    call MakeSound("war3mapImported\\Hero_Erza_F_Cancel")
                else
                    call MakeSound("war3mapImported\\Hero_Erza_F_Cancel2")
                endif
            endif
        endif
    endfunction
    function ErzaAbiArmorAdd takes unit c, integer id1, integer id2, integer id3, integer id4, integer id5, integer id6, boolean b, integer level returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local real cd
        local real cd2
        local real cd3
        if b == true then
            call SetPlayerAbilityAvailable(Player(i), id1, b)
            call SetPlayerAbilityAvailable(Player(i), id2, b)
            call SetPlayerAbilityAvailable(Player(i), id3, b)
            call SetPlayerAbilityAvailable(Player(i), id4, b)
            call SetPlayerAbilityAvailable(Player(i), id5, b)
            if id6 != 0 then
                call SetPlayerAbilityAvailable(Player(i), id6, b)
            endif
            if GetUnitAbilityLevel(c, id1) == 0 then
                call UnitAddAbility(c, id1)
                call UnitAddAbility(c, id2)
                call UnitAddAbility(c, id3)
                call UnitAddAbility(c, id4)
                call UnitAddAbility(c, id5)
                if id6 != 0 then
                    call UnitAddAbility(c, id6)
                    call UnitMakeAbilityPermanent(c, b, id6)
                endif
                call UnitMakeAbilityPermanent(c, b, id1)
                call UnitMakeAbilityPermanent(c, b, id2)
                call UnitMakeAbilityPermanent(c, b, id3)
                call UnitMakeAbilityPermanent(c, b, id4)
                call UnitMakeAbilityPermanent(c, b, id5)
                call SetUnitAbilityLevel(c, id1, level)
                call SetUnitAbilityLevel(c, id2, level)
                call SetUnitAbilityLevel(c, id3, level)
                call SetUnitAbilityLevel(c, id4, level)
                call SetUnitAbilityLevel(c, id5, level)
            else
                call SetUnitAbilityLevel(c, id1, level)
                call SetUnitAbilityLevel(c, id2, level)
                call SetUnitAbilityLevel(c, id3, level)
                call SetUnitAbilityLevel(c, id4, level)
                call SetUnitAbilityLevel(c, id5, level)
            endif
     //-------------------------------------------------------
            if id1 == Erza1Q_ID or id1 == Erza2Q_ID or id1 == Erza3Q_ID then
                set cd = BlzGetUnitAbilityCooldownRemaining(c, Erza1Q_ID)
                set cd2 = BlzGetUnitAbilityCooldownRemaining(c, Erza2Q_ID)
                set cd3 = BlzGetUnitAbilityCooldownRemaining(c, Erza3Q_ID)
                if cd > 0 then
                    call BlzStartUnitAbilityCooldown(c, Erza2Q_ID, cd)
                    call BlzStartUnitAbilityCooldown(c, Erza3Q_ID, cd)
                elseif cd2 > 0 then
                    call BlzStartUnitAbilityCooldown(c, Erza1Q_ID, cd2)
                    call BlzStartUnitAbilityCooldown(c, Erza3Q_ID, cd2)
                elseif cd3 > 0 then
                    call BlzStartUnitAbilityCooldown(c, Erza1Q_ID, cd3)
                    call BlzStartUnitAbilityCooldown(c, Erza2Q_ID, cd3)
                endif
            endif
            if id4 == Erza2R_ID or id4 == Erza3R_ID then
                set cd2 = BlzGetUnitAbilityCooldownRemaining(c, Erza2R_ID)
                set cd3 = BlzGetUnitAbilityCooldownRemaining(c, Erza3R_ID)
                if cd2 > 0 then
                    call BlzStartUnitAbilityCooldown(c, Erza3R_ID, cd2)
                elseif cd3 > 0 then
                    call BlzStartUnitAbilityCooldown(c, Erza2R_ID, cd3)
                endif
            endif
            if id5 == Erza1T_ID or id5 == Erza2T_ID or id5 == Erza3T_ID then
                set cd = BlzGetUnitAbilityCooldownRemaining(c, Erza1T_ID)
                set cd2 = BlzGetUnitAbilityCooldownRemaining(c, Erza2T_ID)
                set cd3 = BlzGetUnitAbilityCooldownRemaining(c, Erza3T_ID)
                if cd > 0 then
                    call BlzStartUnitAbilityCooldown(c, Erza2T_ID, cd)
                    call BlzStartUnitAbilityCooldown(c, Erza3T_ID, cd)
                elseif cd2 > 0 then
                    call BlzStartUnitAbilityCooldown(c, Erza1T_ID, cd2)
                    call BlzStartUnitAbilityCooldown(c, Erza3T_ID, cd2)
                elseif cd3 > 0 then
                    call BlzStartUnitAbilityCooldown(c, Erza1T_ID, cd3)
                    call BlzStartUnitAbilityCooldown(c, Erza2T_ID, cd3)
                endif
            endif
    //--------------R and T LoadInteger(hs,GetHandleId(c),StringHash("erza g2 type"))--------------------------------
            if id1 == Erza4Q_ID or id1 == Erza5Q_ID then
                set cd = BlzGetUnitAbilityCooldownRemaining(c, Erza4Q_ID)
                set cd2 = BlzGetUnitAbilityCooldownRemaining(c, Erza5Q_ID)
                if cd > 0 then
                    call BlzStartUnitAbilityCooldown(c, Erza5Q_ID, cd)
                elseif cd2 > 0 then
                    call BlzStartUnitAbilityCooldown(c, Erza4Q_ID, cd2)
                endif
            endif
            if id2 == Erza4W_ID or id2 == Erza5W_ID then
                set cd = BlzGetUnitAbilityCooldownRemaining(c, Erza4W_ID)
                set cd2 = BlzGetUnitAbilityCooldownRemaining(c, Erza5W_ID)
                if cd > 0 then
                    call BlzStartUnitAbilityCooldown(c, Erza5W_ID, cd)
                elseif cd2 > 0 then
                    call BlzStartUnitAbilityCooldown(c, Erza4W_ID, cd2)
                endif
            endif
            if id3 == Erza4E_ID or id3 == Erza5E_ID then
                set cd = BlzGetUnitAbilityCooldownRemaining(c, Erza4E_ID)
                set cd2 = BlzGetUnitAbilityCooldownRemaining(c, Erza5E_ID)
                if cd > 0 then
                    call BlzStartUnitAbilityCooldown(c, Erza5E_ID, cd)
                elseif cd2 > 0 then
                    call BlzStartUnitAbilityCooldown(c, Erza4E_ID, cd2)
                endif
            endif
            if id4 == Erza4R_ID or id4 == Erza5R_ID then
                set cd = BlzGetUnitAbilityCooldownRemaining(c, Erza4R_ID)
                set cd2 = BlzGetUnitAbilityCooldownRemaining(c, Erza5R_ID)
                if cd > 0 then
                    call BlzStartUnitAbilityCooldown(c, Erza5R_ID, cd)
                elseif cd2 > 0 then
                    call BlzStartUnitAbilityCooldown(c, Erza4R_ID, cd2)
                endif
            endif
            if id5 == Erza4T_ID or id5 == Erza5T_ID then
                set cd = BlzGetUnitAbilityCooldownRemaining(c, Erza4T_ID)
                set cd2 = BlzGetUnitAbilityCooldownRemaining(c, Erza5T_ID)
                if cd > 0 then
                    call BlzStartUnitAbilityCooldown(c, Erza5T_ID, cd)
                elseif cd2 > 0 then
                    call BlzStartUnitAbilityCooldown(c, Erza4T_ID, cd2)
                endif
            endif
    //-----------------------------------------------------------
        else
            call SetPlayerAbilityAvailable(Player(i), id1, b)
            call SetPlayerAbilityAvailable(Player(i), id2, b)
            call SetPlayerAbilityAvailable(Player(i), id3, b)
            call SetPlayerAbilityAvailable(Player(i), id4, b)
            call SetPlayerAbilityAvailable(Player(i), id5, b)
            if id6 != 0 then
                call SetPlayerAbilityAvailable(Player(i), id6, b)
            endif
        endif
    endfunction
    function ErzaF_Start takes unit c returns nothing
        local integer id = GetHandleId(c)
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local integer sh1 = StringHash("q armor active")
        local integer sh2 = StringHash("w armor active")
        local integer sh3 = StringHash("e armor active")
        local integer sh4 = StringHash("r armor active")
        local integer sh5 = StringHash("t armor active")
        local integer sh6 = StringHash("g armor active")
        local integer k
        local real hp = GetUnitState(c, UNIT_STATE_LIFE) / GetUnitState(c, UNIT_STATE_MAX_LIFE)
        local real cd
        local integer check = 0
        if GetUnitAbilityLevel(c, ErzaG2_ID) > 0 then
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG2_ID, true)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG_ID, false)
        else
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG_ID, true)
        endif
        if LoadInteger(hs, id, sh1) == 1 then
            set check = 1
            call BlzSetUnitMaxHP(c, BlzGetUnitMaxHP(c) - ErzaQ_ArmorStatHpBase - (ErzaQ_ArmorStatHpStep * (GetUnitAbilityLevel(c, ErzaQ_ID) - 1)))
            call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_MAX_LIFE) * hp)
            call UnitRemoveAbility(c, ErzaQ_ArmorStat_ID)
            call ErzaAbiArmorAdd(c, Erza1Q_ID, Erza1W_ID, Erza1E_ID, Erza1R_ID, Erza1T_ID, 0, false, GetUnitAbilityLevel(c, ErzaQ_ID))
            call ErzaBaseAbiBlock(c, true)
            call SaveInteger(hs, id, sh1, 0)
        elseif LoadInteger(hs, id, sh2) == 1 then
            call ErzaBaseAbiBlock(c, true)
            set check = 1
            call UnitRemoveAbility(c, ErzaW_Regen0_ID)
            call UnitRemoveAbility(c, ErzaW_Regen1_ID)
            call UnitRemoveAbility(c, ErzaW_Regen2_ID)
            call UnitRemoveAbility(c, ErzaW_Regen3_ID)
            call UnitRemoveAbility(c, ErzaW_Regen4_ID)
            //call BlzSetUnitRealField(c, UNIT_RF_HIT_POINTS_REGENERATION_RATE, BlzGetUnitRealField(c, UNIT_RF_HIT_POINTS_REGENERATION_RATE) - (ErzaW_ArmorStatHpRegenBase + (ErzaW_ArmorStatHpRegenStep * (GetUnitAbilityLevel(c, ErzaW_ID) - 1))))
            call ErzaAbiArmorAdd(c, Erza2Q_ID, Erza2W_ID, Erza2E_ID, Erza2R_ID, Erza2T_ID, 0, false, GetUnitAbilityLevel(c, ErzaW_ID))
            call SaveInteger(hs, id, sh2, 0)
        elseif LoadInteger(hs, id, sh3) == 1 then
            call ErzaBaseAbiBlock(c, true)
            set check = 1
            call AddSpellLevel(c, 'A01C', ErzaE_ArmorMS_LvLBase_ID + (ErzaE_ArmorMS_LvLStep_ID * (GetUnitAbilityLevel(c, ErzaW_ID) - 1)), false)
            call BlzSetUnitRealField(c, UNIT_RF_MANA_REGENERATION, BlzGetUnitRealField(c, UNIT_RF_MANA_REGENERATION) - (ErzaE_ArmorStatMpRegenBase + (ErzaE_ArmorStatMpRegenStep * (GetUnitAbilityLevel(c, ErzaE_ID) - 1))))
            call SaveInteger(hs, id, sh3, 0)
            call ErzaAbiArmorAdd(c, Erza3Q_ID, Erza3W_ID, Erza3E_ID, Erza3R_ID, Erza3T_ID, 0, false, GetUnitAbilityLevel(c, ErzaE_ID))
        elseif LoadInteger(hs, id, sh4) == 1 then
            call BlzSetUnitMaxHP(c, BlzGetUnitMaxHP(c) - (ErzaR_ArmorStatHpBase + (ErzaR_ArmorStatHpStep * (GetUnitAbilityLevel(c, ErzaR_ID) - 1))))
            call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_MAX_LIFE) * hp)
            call AddSpellLevel(c, 'A01C', ErzaR_ArmorMS_LvLBase_ID + (ErzaR_ArmorMS_LvLStep_ID * (GetUnitAbilityLevel(c, ErzaR_ID) - 1)), false)
            call UnitRemoveAbility(c, ErzaR_ArmorStatAS_ID)
            call UnitRemoveAbility(c, ErzaR_ArmorStatEvade_ID)
            call ErzaBaseAbiBlock(c, true)
            set check = 1
            call SaveInteger(hs, id, sh4, 0)
            set k = LoadInteger(hs, GetHandleId(c), StringHash("e stacks"))
            set cd = BlzGetUnitAbilityCooldown(c, Erza4E_ID, GetUnitAbilityLevel(c, Erza4E_ID) - 1)
            if k > 0 then
                call MyFlush(GetHandleId(c), StringHash("e stacks"), 0, 1)
                call BlzStartUnitAbilityCooldown(c, Erza4E_ID, cd)
            endif
            call SaveInteger(hs, GetHandleId(c), StringHash("e stacks"), 0)
            call ErzaAbiArmorAdd(c, Erza4Q_ID, Erza4W_ID, Erza4E_ID, Erza4R_ID, Erza4T_ID, Erza4F_ID, false, GetUnitAbilityLevel(c, ErzaR_ID))
        elseif LoadInteger(hs, id, sh5) == 1 then
            set check = 1
            call BlzSetUnitMaxHP(c, BlzGetUnitMaxHP(c) - ErzaT_ArmorStatHpBase)
            call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_MAX_LIFE) * hp)
            call ErzaBaseAbiBlock(c, true)
            call SaveInteger(hs, id, sh5, 0)
            call ErzaAbiArmorAdd(c, Erza5Q_ID, Erza5W_ID, Erza5E_ID, Erza5R_ID, Erza5T_ID, Erza5F_ID, false, GetUnitAbilityLevel(c, ErzaT_ID))
        elseif LoadInteger(hs, id, sh6) == 1 then
            set check = 1
            call BlzSetUnitMaxHP(c, BlzGetUnitMaxHP(c) - ErzaT_ArmorStatHpBase)
            call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_MAX_LIFE) * hp)
            call SaveInteger(hs, GetHandleId(c), StringHash("erza g2 active"), 0)
            call ErzaBaseAbiBlock(c, true)
            call SaveInteger(hs, id, sh6, 0)
            call ErzaAbiArmorAdd(c, Erza6Q_ID, Erza6W_ID, Erza6E_ID, Erza6R_ID, Erza6T_ID, 0, false, GetUnitAbilityLevel(c, ErzaG2_ID))
            call ErzaAbiArmorAdd(c, Erza7Q_ID, Erza7W_ID, Erza7E_ID, Erza7R_ID, Erza7T_ID, 0, false, GetUnitAbilityLevel(c, ErzaG2_ID))
        endif
        // The synergy dummy belongs only to the R armor. Clear it on every
        // form exit as a safeguard against stale armor flags and repicks.
        if ErzaR_NatsuGrayDummy[i] != null then
            call RemoveUnit(ErzaR_NatsuGrayDummy[i])
            set ErzaR_NatsuGrayDummy[i] = null
        endif
        if check > 0 then
            call BlzSetUnitSkin(c, ErzaUnitSkin_ID)
            call FixAura(c)
            call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_[dz_spell]002_blue5.mdl", c, "origin"))
        endif
    endfunction
    function ErzaQ_Start takes unit c returns nothing
        local integer id = GetHandleId(c)
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local integer sh = StringHash("q armor active")
        local real hp = GetUnitState(c, UNIT_STATE_LIFE) / GetUnitState(c, UNIT_STATE_MAX_LIFE)
        call BlzSetUnitSkin(c, ErzaQ_UnitSkin_ID)
        call FixAura(c)
        call SaveInteger(hs, id, sh, 1)
        call ErzaBaseAbiBlock(c, false)
        call Erza1ECheck_Start(c)
        if GetUnitAbilityLevel(c, ErzaG2_ID) > 0 then
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG2_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG_ID, true)
        endif
        call BlzSetUnitMaxHP(c, BlzGetUnitMaxHP(c) + ErzaQ_ArmorStatHpBase + (ErzaQ_ArmorStatHpStep * (GetUnitAbilityLevel(c, ErzaQ_ID) - 1)))
        call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_MAX_LIFE) * hp)
        call UnitAddAbility(c, ErzaQ_ArmorStat_ID)
        call SetUnitAbilityLevel(c, ErzaQ_ArmorStat_ID, GetUnitAbilityLevel(c, ErzaQ_ID))
        if LoadInteger(hs, i, StringHash("sound cd2")) == 0 then
            call SaveInteger(hs, i, StringHash("sound cd2"), 1)
            call MyFlush(i, StringHash("sound cd2"), 0, 10)
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapImported\\Hero_Erza1_Start")
            else
                call MakeSound("war3mapImported\\Hero_Erza1_Start2")
            endif
        endif
        call ErzaAbiArmorAdd(c, Erza1Q_ID, Erza1W_ID, Erza1E_ID, Erza1R_ID, Erza1T_ID, 0, true, GetUnitAbilityLevel(c, ErzaQ_ID))
    endfunction
    function ErzaW_Start takes unit c returns nothing
        local integer id = GetHandleId(c)
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local integer sh = StringHash("w armor active")
        //call BlzSetUnitRealField(c, UNIT_RF_HIT_POINTS_REGENERATION_RATE, BlzGetUnitRealField(c, UNIT_RF_HIT_POINTS_REGENERATION_RATE) + ErzaW_ArmorStatHpRegenBase + (ErzaW_ArmorStatHpRegenStep * (GetUnitAbilityLevel(c, ErzaW_ID) - 1)))
        if GetUnitAbilityLevel(c, ErzaW_ID) == 1 then
            call UnitAddAbility(c, ErzaW_Regen0_ID)
        elseif GetUnitAbilityLevel(c, ErzaW_ID) == 2 then
            call UnitAddAbility(c, ErzaW_Regen1_ID)
        elseif GetUnitAbilityLevel(c, ErzaW_ID) == 3 then
            call UnitAddAbility(c, ErzaW_Regen2_ID)
        elseif GetUnitAbilityLevel(c, ErzaW_ID) == 4 then
            call UnitAddAbility(c, ErzaW_Regen3_ID)
        elseif GetUnitAbilityLevel(c, ErzaW_ID) == 5 then
            call UnitAddAbility(c, ErzaW_Regen4_ID)
        endif
        if GetUnitAbilityLevel(c, ErzaG2_ID) > 0 then
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG2_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG_ID, true)
        endif
        call BlzSetUnitSkin(c, ErzaW_UnitSkin_ID)
        call FixAura(c)
        call SaveInteger(hs, id, sh, 1)
        call ErzaBaseAbiBlock(c, false)
        if LoadInteger(hs, i, StringHash("sound cd3")) == 0 then
            call SaveInteger(hs, i, StringHash("sound cd3"), 1)
            call MyFlush(i, StringHash("sound cd3"), 0, 10)
            call MakeSound("war3mapImported\\Hero_Erza2_Start")
        endif
        call ErzaAbiArmorAdd(c, Erza2Q_ID, Erza2W_ID, Erza2E_ID, Erza2R_ID, Erza2T_ID, 0, true, GetUnitAbilityLevel(c, ErzaW_ID))
    endfunction
    function ErzaE_Start takes unit c returns nothing
        local integer id = GetHandleId(c)
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local integer sh = StringHash("e armor active")
        call BlzSetUnitSkin(c, ErzaE_UnitSkin_ID)
        call FixAura(c)
        call SaveInteger(hs, id, sh, 1)
        call AddSpellLevel(c, 'A01C', ErzaE_ArmorMS_LvLBase_ID + (ErzaE_ArmorMS_LvLStep_ID * (GetUnitAbilityLevel(c, ErzaW_ID) - 1)), true)
        call BlzSetUnitRealField(c, UNIT_RF_MANA_REGENERATION, BlzGetUnitRealField(c, UNIT_RF_MANA_REGENERATION) + (ErzaE_ArmorStatMpRegenBase + (ErzaE_ArmorStatMpRegenStep * (GetUnitAbilityLevel(c, ErzaE_ID) - 1))))
        call ErzaBaseAbiBlock(c, false)
        if LoadInteger(hs, i, StringHash("sound cd4")) == 0 then
            call SaveInteger(hs, i, StringHash("sound cd4"), 1)
            call MyFlush(i, StringHash("sound cd4"), 0, 10)
            call MakeSound("war3mapImported\\Hero_Erza3_Start")
        endif
        if GetUnitAbilityLevel(c, ErzaG2_ID) > 0 then
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG2_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG_ID, true)
        endif
        call ErzaAbiArmorAdd(c, Erza3Q_ID, Erza3W_ID, Erza3E_ID, Erza3R_ID, Erza3T_ID, 0, true, GetUnitAbilityLevel(c, ErzaE_ID))
    endfunction
    function ErzaR_Start takes unit c returns nothing
        local integer id = GetHandleId(c)
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local integer sh = StringHash("r armor active")
        local integer stacks = 3 - LoadInteger(hs, GetHandleId(c), StringHash("e stacks"))
        local real hp = GetUnitState(c, UNIT_STATE_LIFE) / GetUnitState(c, UNIT_STATE_MAX_LIFE)
        local real x = GetUnitX(c)
        local real y = GetUnitY(c)
        local group g = CreateGroup()
        local unit u = null
        local integer k2 = 0
        local integer k3 = 0
        call GroupEnumUnitsInRange(g, x, y, 1800, NoDecor_Cond)
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if IsUnitAlly(u, GetOwningPlayer(c)) and GetWidgetLife(u) > 0.405 and not IsUnitType(u, UNIT_TYPE_DEAD) and not IsUnitHidden(u) then
                if GetUnitTypeId(u) == Gray_ID1 or GetUnitTypeId(u) == Gray_ID2 then
                    set k2 = k2 + 1
                endif
                if GetUnitTypeId(u) == Natsu_ID then
                    set k3 = k3 + 1
                endif
            endif
            call GroupRemoveUnit(g, u)
        endloop
        if k2 > 0 and k3 > 0 then
            if ErzaR_NatsuGrayDummy[i] == null then
                set ErzaR_NatsuGrayDummy[i] = CreateUnit(GetOwningPlayer(c), ErzaR_DummyElementalId, x, y, 0)
            endif
        else
            if ErzaR_NatsuGrayDummy[i] != null then
                call RemoveUnit(ErzaR_NatsuGrayDummy[i])
                set ErzaR_NatsuGrayDummy[i] = null
            endif
        endif
        if GetUnitAbilityLevel(c, ErzaG2_ID) > 0 then
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG2_ID, false)
        else
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG_ID, false)
        endif
        call BlzSetUnitMaxHP(c, BlzGetUnitMaxHP(c) + (ErzaR_ArmorStatHpBase + (ErzaR_ArmorStatHpStep * (GetUnitAbilityLevel(c, ErzaR_ID) - 1))))
        call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_MAX_LIFE) * hp)
        call AddSpellLevel(c, 'A01C', ErzaR_ArmorMS_LvLBase_ID + (ErzaR_ArmorMS_LvLStep_ID * (GetUnitAbilityLevel(c, ErzaR_ID) - 1)), true)
        call UnitAddAbility(c, ErzaR_ArmorStatAS_ID)
        call SetUnitAbilityLevel(c, ErzaR_ArmorStatAS_ID, GetUnitAbilityLevel(c, ErzaR_ID))
        call UnitAddAbility(c, ErzaR_ArmorStatEvade_ID)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaR_ArmorStatEvade_ID, false)
        call BlzSetUnitSkin(c, ErzaR_UnitSkin_ID)
        call FixAura(c)
        call SaveInteger(hs, id, sh, 1)
        call BlzSetAbilityIcon(Erza4E_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Erza4_E.blp")
        call ErzaBaseAbiBlock(c, false)
        if LoadInteger(hs, i, StringHash("sound cd5")) == 0 then
            call SaveInteger(hs, i, StringHash("sound cd5"), 1)
            call MyFlush(i, StringHash("sound cd5"), 0, 10)
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapImported\\Hero_Erza4_Start")
            else
                call MakeSound("war3mapImported\\Hero_Erza4_Start2")
            endif
        endif
        if GetHeroLevel(c)>=25 then 
        call Erza4F_Start(c)
        endif
        call ErzaAbiArmorAdd(c, Erza4Q_ID, Erza4W_ID, Erza4E_ID, Erza4R_ID, Erza4T_ID, Erza4F_ID, true, GetUnitAbilityLevel(c, ErzaR_ID))
        call DestroyGroup(g)
        set g = null
        set u = null
    endfunction
    function ErzaT_Start takes unit c returns nothing
        local integer id = GetHandleId(c)
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local integer sh = StringHash("t armor active")
        local real hp = GetUnitState(c, UNIT_STATE_LIFE) / GetUnitState(c, UNIT_STATE_MAX_LIFE)
        call BlzSetUnitSkin(c, ErzaT_UnitSkin_ID)
        call FixAura(c)
        call SaveInteger(hs, id, sh, 1)
        call BlzSetUnitMaxHP(c, BlzGetUnitMaxHP(c) + ErzaT_ArmorStatHpBase)
        call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_MAX_LIFE) * hp)
        call ErzaBaseAbiBlock(c, false)
        if LoadInteger(hs, i, StringHash("sound cd6")) == 0 then
            call SaveInteger(hs, i, StringHash("sound cd6"), 1)
            call MyFlush(i, StringHash("sound cd6"), 0, 8)
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapImported\\Hero_Erza5_Start")
            else
                call MakeSound("war3mapImported\\Hero_Erza5_Start2")
            endif
        endif
        if GetUnitAbilityLevel(c, ErzaG2_ID) > 0 then
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG2_ID, false)
        else
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG_ID, false)
        endif
        call ErzaAbiArmorAdd(c, Erza5Q_ID, Erza5W_ID, Erza5E_ID, Erza5R_ID, Erza5T_ID, Erza5F_ID, true, GetUnitAbilityLevel(c, ErzaT_ID))
        if GetHeroLevel(c)>= 25 then 
        call Erza5Pas_Start(c, 0)
        endif
    endfunction
    function ErzaG2_Start takes unit c returns nothing
        local integer id = GetHandleId(c)
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local integer k = 0
        local integer sh = StringHash("g armor active")
        local real hp = GetUnitState(c, UNIT_STATE_LIFE) / GetUnitState(c, UNIT_STATE_MAX_LIFE)
            call SaveInteger(hs, GetHandleId(c), StringHash("erza g2 active"), 1)
            call Erza6G_Start(c)
            if GetUnitAbilityLevel(c, ErzaG2_ID) > 0 then
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG2_ID, false)            
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG_ID, true)
        else
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG_ID, false)
        endif
        if LoadInteger(hs, GetHandleId(c), StringHash("erza g2 type")) == 1 then
            call BlzSetUnitSkin(c, ErzaG1_UnitSkin_ID)
            call FixAura(c)
            call SaveInteger(hs, id, sh, 1)
            call BlzSetUnitMaxHP(c, BlzGetUnitMaxHP(c) + ErzaT_ArmorStatHpBase)
            call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_MAX_LIFE) * hp)
            call ErzaBaseAbiBlock(c, false)
            call MakeSound("war3mapImported\\Hero_Erza6_G3")
            if LoadInteger(hs, i, StringHash("sound cd6")) == 0 then
                call SaveInteger(hs, i, StringHash("sound cd6"), 1)
                call MyFlush(i, StringHash("sound cd6"), 0, 0.1)
                call MakeSound("war3mapImported\\Hero_Erza6_Enter")
            endif
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_123 (383)_yell.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1.35, 0.7, 1))
            set k = 0
            loop
                exitwhen k == 6
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_darkdustgroundeffect2fast.mdl", GetUnitX(c) + 390 * Cos(k * 60 * bj_DEGTORAD), GetUnitY(c) + 390 * Sin(k * 60 * bj_DEGTORAD), GetRandomReal(0, 359), 1, 2.5, 115))
                set k = k + 1
            endloop
            call ErzaAbiArmorAdd(c, Erza6Q_ID, Erza6W_ID, Erza6E_ID, Erza6R_ID, Erza6T_ID, 0, true, GetUnitAbilityLevel(c, ErzaG2_ID))
        else
            call ErzaAbiArmorAdd(c, Erza7Q_ID, Erza7W_ID, Erza7E_ID, Erza7R_ID, Erza7T_ID, 0, true, GetUnitAbilityLevel(c, ErzaG2_ID))
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_JY-ZK_BM_Mine blasting-Lv-075.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1.1, 1.75, 1))
            call BlzSetUnitSkin(c, ErzaG2_UnitSkin_ID)
            call FixAura(c)
            call SaveInteger(hs, id, sh, 1)
            call BlzSetUnitMaxHP(c, BlzGetUnitMaxHP(c) + ErzaT_ArmorStatHpBase)
            call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_MAX_LIFE) * hp)
            call ErzaBaseAbiBlock(c, false)
            call MakeSound("war3mapImported\\Hero_Erza6_G3")
            if LoadInteger(hs, i, StringHash("sound cd6")) == 0 then
                call SaveInteger(hs, i, StringHash("sound cd6"), 1)
                call MyFlush(i, StringHash("sound cd6"), 0, 0.1)
                call MakeSound("war3mapImported\\Hero_Erza7_Enter")
            endif
        endif
        if GetUnitAbilityLevel(c, ErzaG2_ID) > 0 then
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG2_ID, false)
        else
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG_ID, false)
        endif
    endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
