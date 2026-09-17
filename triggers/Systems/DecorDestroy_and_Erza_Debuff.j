library AAADest uses GearSystems
    globals
        integer ErzaElemntalAbi_ID = 'A03T'
        integer ErzaFire_ID = 'B006'
        integer ErzaWater_ID = 'B007'
        integer ErzaLightning_ID = 'B008'
        integer ErzaWape_ID = 'B009'
        real ErzaWape_IncreaseDmg = 10 // increase physical taken dmg by target with wape debuff by 8% ( 8 = 8%)
        integer ErzaWape_DecreaseArmor_ID = 'A04T'
        integer ErzaOverload_ID = 'B00A'
        integer ErzaElectrized_ID = 'B00B'
        integer ErzaNakagamiBuff = 'A04K'
        integer ErzaWater_Slow1 = 10 // percantage 30 = 30% slow
        integer ErzaWater_Slow2 = 20 // percantage 30 = 30% slow
        integer ErzaWater_Slow3 = 30 // percantage 30 = 30% slow
        integer ErzaWater_Slow4 = 30 // percantage 30 = 30% slow
        integer ErzaWater_Slow5 = 40 // percantage 30 = 30% slow
        real ErzaWater_DamageBase = 75// static damage each sec
        real ErzaFire_DamageBase = 30 // static damage each sec
        real ErzaWape_Damage = 1 // x mainstat damage each one time
        real ErzaOverload_Damage = 1 // x mainstat damage each one time
        real ErzaElectrized_Damage = 0.3 // x mainstat damage each sec for buff duration time
        real ErzaOverload_Stun = 1 // increased stun when water + fire
        real ErzaLightning_Stun = 0.6 // stun time after end of buff
        real ErzaLightning_ManaBurnBase = 120 // burn mana after end of buff
        real ErzaLightning_ManaBurnStep = 20 // burn mana after end of buff for each next armor lvl
        unit array ErzaG2_Dummy [10]
        integer ErzaG2_DummyID = 'h00P'
        integer ErzaG2_ActivateDamageCond = 40000 // how much dmg need deal to activate G2
        unit array DummyPlayer4
        unit array DummyPlayer6

        // Dedicated timestamp cooldowns for destructables. Unlike IntegerCd,
        // this does not allocate a KS_Flush instance for every hit object.
        private hashtable DecorCooldownTable = InitHashtable()
        private timer DecorCooldownClock = CreateTimer()
        private boolean DecorCooldownClockStarted = false
         boolexpr DecorAliveCond 
         boolexpr AAADestNoDecorCond 
    endglobals
    function SlowUnitErza takes unit c, unit u, integer lvl returns nothing // percent - from 10 to 80( all percentage, example 10, 20, 30, 40, 50, 60, 70, 80), time choose prefered time 2, 3, 4 sec only
        local integer i = GetPlayerId(GetOwningPlayer(c))
        if DummyPlayer4[i] == null or GetWidgetLife(DummyPlayer4[i]) < 1 then
            set DummyPlayer4[i] = CreateUnit( Player( i ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyPlayer4[i], 'A03U')
        endif
        set lvl = R2I(lvl /10)
        if lvl< 1 then 
        set lvl = 1
        endif
        if lvl > 0 then
            if GetUnitAbilityLevel(DummyPlayer4[i], 'A03U') == 0 then
                call UnitAddAbility(DummyPlayer4[i], 'A03U')
            endif
            call SetUnitAbilityLevel(DummyPlayer4[i], 'A03U', lvl)
            call BlzSetUnitFacingEx(DummyPlayer4[i], GAngle(DummyPlayer4[i], u) * bj_RADTODEG)
            call IssueTargetOrder(DummyPlayer4[i], "slow", u)
        endif
    endfunction
   private function FormatK takes integer value returns string
        local integer thousands
        local integer remainder
        if value < 1000 then
            return I2S(value)
        endif
        set thousands = value / 1000
        set remainder = value - thousands * 1000
    // до 100k — показываем одну цифру после точки
        if value < 100000 then
            return I2S(thousands) + "." + I2S(remainder / 100) + "k"
        endif
    // 100k и выше — без дробей
        return I2S(thousands) + "k"
    endfunction
    private struct ErzaDebuffs
        private static timer t_ErzaPas = CreateTimer( )
        private static integer array m_ErzaPas
        private static integer MUI_ErzaPas = -1
        private static timer t_2 = CreateTimer( )
        private static integer array m_2
        private static integer MUI_2 = -1
        private static timer t_3 = CreateTimer( )
        private static integer array m_3
        private static integer MUI_3 = -1
        unit d
        unit c
        unit td
        real x
        real y
        real r5
        integer id
        integer k
        integer k2
        integer k3
        integer check
        integer check2 
        integer child_id
        integer value
        real rmax
        real r
        real r2
        real dmg
        effect e
        effect e2
        real a
        framehandle array frame_pas1 [10]
        framehandle array frame_pas2 [10]
        framehandle array frame_pas3 [10]
        framehandle array frame_pas4 [10]
        framehandle array frame_pas5 [10]
        framehandle array frame_pas6 [10]
        framehandle array frame2_pas1 [10]
        framehandle array frame2_pas2 [10]
        framehandle array frame2_pas3 [10]
        framehandle array frame2_pas4 [10]
        framehandle array frame2_pas5 [10]
        framehandle array frame2_pas6 [10]
        framehandle array frame2_pas7 [10]
        framehandle array frame2_pas8 [10]      
        private static method Loop_ErzaBar takes nothing returns nothing
            local thistype this
            local integer i = 0
            local integer phys
            local integer mag
            local integer result
            loop
                exitwhen i > MUI_3
                set this = m_3[i]
                if GetUnitTypeId(Hero[k2]) == id and Hero[k2] != null then
                    set r = r + 0.05
                    set r = S2R( R2SW( r , 0, 5 ) )
                    if check == 0 then
                        set phys = LoadInteger(hs, GetHandleId(c), StringHash("Erza G2 phys"))
                        set mag = LoadInteger(hs, GetHandleId(c), StringHash("Erza G2 mag"))
                        set result = phys + mag
                        if result > ErzaG2_ActivateDamageCond then
                            set result = ErzaG2_ActivateDamageCond
                            set check = 1
                            if ErzaG2_Dummy[k2] != null then
                                call RemoveUnit(ErzaG2_Dummy[k2])
                                set ErzaG2_Dummy[k2] = null
                            endif
                            set ErzaG2_Dummy[k2] = CreateUnit(GetOwningPlayer(c), ErzaG2_DummyID, x, y, 0)
                            call MakeSound("war3mapimported\\Hero_Erza_G2_1")
                            if GetLocalPlayer() == Player(k2) then
                                call BlzFrameSetVisible(frame2_pas8[k2], true)
                            endif
                            if mag <= phys then
                                call BlzFrameSetText(frame2_pas7[k2], "|c00FFFF00" + "Nakagami" + "|r")
                                call SaveInteger(hs, GetHandleId(c), StringHash("erza g2 type"), 1) // nakagami
                                call BlzFrameSetValue(frame2_pas3[k2], 99)
                                call BlzFrameSetPoint(frame2_pas8[k2], FRAMEPOINT_BOTTOMLEFT, frame2_pas4[k2], FRAMEPOINT_CENTER, 0.0, 0.0)
                                call BlzFrameSetTexture(frame2_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Erza_G2_1", 0, false)
                                call BlzFrameSetTexture(frame2_pas5[k2], "ReplaceableTextures\\CommandButtonsDisabled\\DISBTNHero_Erza_G2_2Pas", 0, false)
                                call BlzSetAbilityIcon(ErzaG2_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Erza_G2_1")
                            else
                                call BlzFrameSetValue(frame2_pas3[k2], 0)
                                call BlzFrameSetPoint(frame2_pas8[k2], FRAMEPOINT_BOTTOMLEFT, frame2_pas5[k2], FRAMEPOINT_CENTER, 0.0, 0.0)
                                call BlzFrameSetText(frame2_pas7[k2], "|c00FFFF00" + "Armadura Fairy" + "|r")
                                call BlzFrameSetTexture(frame2_pas4[k2], "ReplaceableTextures\\CommandButtonsDisabled\\DISBTNHero_Erza_G2_1Pas", 0, false)
                                call BlzFrameSetTexture(frame2_pas5[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Erza_G2_2", 0, false)
                                call SaveInteger(hs, GetHandleId(c), StringHash("erza g2 type"), 2) // armadura fairy
                                call BlzSetAbilityIcon(ErzaG2_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Erza_G2_2")
                            endif
                        endif
                        if check == 0 then
                            call BlzFrameSetText(frame2_pas7[k2], "|c00FFFF00" + FormatK(result - 2) + "/" + FormatK(ErzaG2_ActivateDamageCond) + "|r")
                            set result = R2I((I2R(phys) / I2R(phys + mag)) * 100)
                            if phys + mag < 3 then
                                call BlzFrameSetValue(frame2_pas3[k2], 50)
                            else
                                call BlzFrameSetValue(frame2_pas3[k2], result)
                            endif
                        endif
                    if CondArena == 0 then
                    
                    endif
                    elseif check == 1 then
                        if LoadInteger(hs, GetHandleId(c), StringHash("erza g2 active")) == 1 then
                            if GetLocalPlayer() == GetOwningPlayer(c) then
                                call BlzFrameSetVisible(frame2_pas8[k2], false)
                                call BlzFrameSetVisible(frame2_pas1[k2], false)
                            endif
                            call SaveInteger(hs, GetHandleId(c), StringHash("Erza G2 phys"), 1)
                            call SaveInteger(hs, GetHandleId(c), StringHash("Erza G2 mag"), 1)
                            set r = 0
                            call RemoveUnit(ErzaG2_Dummy[k2])
                            call BlzFrameSetValue(frame2_pas3[k2], 50)
                            call BlzFrameSetTexture(frame2_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Erza_G2_1Pas", 0, false)
                            call BlzFrameSetTexture(frame2_pas5[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Erza_G2_2Pas", 0, false)
                            set check = 2
                        endif
                    elseif check == 2 then
                        if CondArena == 0 then
                            if GetLocalPlayer() == GetOwningPlayer(c) then
                                call BlzFrameSetVisible(frame2_pas1[k2], true)
                            endif
                            call SaveInteger(hs, GetHandleId(c), StringHash("Erza G2 phys"), 1)
                            call SaveInteger(hs, GetHandleId(c), StringHash("Erza G2 mag"), 1)
                            set check = 0
                        endif
          
                    endif
                else
                    if GetLocalPlayer() == Player(k2) then
                    call BlzFrameSetVisible(frame2_pas1[k2], false)
                    endif
                    set c = null
                    set m_3[i] = m_3[MUI_3]
                    set MUI_3 = MUI_3 - 1
                    if MUI_3 == -1 then
                        call PauseTimer(t_3)
                    endif
                    call destroy()
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaBar_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_3 = MUI_3 + 1
            set m_3[MUI_3] = this
            set c = NewC
            set r = 0
            set check = 0
            set r2 = 0
            set id = GetUnitTypeId(c)
            set k2 = GetPlayerId(GetOwningPlayer(c))
            call SaveInteger(hs, GetHandleId(c), StringHash("Erza G2 phys"), 1)
            call SaveInteger(hs, GetHandleId(c), StringHash("Erza G2 mag"), 1)
            set k = LoadInteger(hs, id, child_id)
            set frame2_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
            call BlzFrameSetAbsPoint(frame2_pas1[k2], FRAMEPOINT_CENTER, 0.7, 0.18)
            call BlzFrameSetSize(frame2_pas1[k2], 0.18, 0.04)
            call BlzFrameSetTexture(frame2_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
            call BlzFrameSetVisible(frame2_pas1[k2], false)
            if GetLocalPlayer() == GetOwningPlayer(c) then
                call BlzFrameSetVisible(frame2_pas1[k2], true)
            endif
            set frame2_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame2_pas1[k2], 0, 0)
            call BlzFrameSetPoint(frame2_pas2[k2], FRAMEPOINT_CENTER, frame2_pas1[k2], FRAMEPOINT_CENTER, 0.0, 0.5)
            call BlzFrameSetSize(frame2_pas2[k2], 0.1, 0.02)
            set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)
            call BlzFrameSetSize(frame2_pas3[k2], 0.1, 0.035)
            call BlzFrameSetScale(frame2_pas3[k2], 0.5)
            call BlzFrameSetModel(frame2_pas3[k2], "war3mapimported\\wos_XpBarConsole3.mdx", 0)
            call BlzFrameSetPoint(frame2_pas3[k2], FRAMEPOINT_CENTER, frame2_pas1[k2], FRAMEPOINT_CENTER, -0.04, -0.01)
            call BlzFrameSetMinMaxValue(frame2_pas3[k2], 0, 100)
            call BlzFrameSetValue(frame2_pas3[k2], 50)
            set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)
            call BlzFrameSetPoint(frame2_pas4[k2], FRAMEPOINT_CENTER, frame2_pas1[k2], FRAMEPOINT_CENTER, -0.07, 0.0)
            call BlzFrameSetSize(frame2_pas4[k2], 0.03, 0.03)
            call BlzFrameSetTexture(frame2_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Erza_G2_1Pas", 0, false)
            set frame2_pas5[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)
            call BlzFrameSetPoint(frame2_pas5[k2], FRAMEPOINT_CENTER, frame2_pas1[k2], FRAMEPOINT_CENTER, 0.07, 0.0)
            call BlzFrameSetSize(frame2_pas5[k2], 0.03, 0.03)
            call BlzFrameSetTexture(frame2_pas5[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Erza_G2_2Pas", 0, false)
            set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
            call BlzFrameSetPoint(frame2_pas6[k2], FRAMEPOINT_CENTER, frame2_pas1[k2], FRAMEPOINT_CENTER, 0.0, 0.0125)
            call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + "Second Origin:" + "|r")
            call BlzFrameSetScale(frame2_pas6[k2], 0.9)
            set frame2_pas7[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
            call BlzFrameSetPoint(frame2_pas7[k2], FRAMEPOINT_CENTER, frame2_pas1[k2], FRAMEPOINT_CENTER, 0.0, -0.005)
            call BlzFrameSetText(frame2_pas7[k2], "|c00FFFF00" + "0/" + FormatK(ErzaG2_ActivateDamageCond) + "|r")
            call BlzFrameSetScale(frame2_pas7[k2], 1.1)
            set frame2_pas8[k2] = BlzCreateFrameByType("SPRITE", "justAName", frame2_pas1[k2], "WarCraftIIILogo", 0)
            call BlzFrameSetPoint(frame2_pas8[k2], FRAMEPOINT_BOTTOMLEFT, frame2_pas5[k2], FRAMEPOINT_CENTER, 0.0, 0.0)
            call BlzFrameSetSize(frame2_pas8[k2], 1., 1.)
            call BlzFrameSetScale(frame2_pas8[k2], 1.)
            call BlzFrameSetModel(frame2_pas8[k2], "Pick\\selecter5.mdx", 0)
            call BlzFrameSetVisible(frame2_pas8[k2], false)
            if MUI_3 == 0 then
                call TimerStart(t_3, 0.05, true, function thistype.Loop_ErzaBar)
            endif
        endmethod
     
        private static method Loop_MyFlushStacks takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_2
                set this = m_2[i]
                if r < rmax then
                    set r = r + 0.05
                    set r = S2R( R2SW( r , 0, 5 ) )
                    call BlzFrameSetValue(frame_pas3[k2], rmax - (r + 0.1))
                    if rmax - r >= 0 then
                        call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                    endif
                    if LoadInteger(hs, id, child_id) != k then
                        set r = 9999
                    endif
                else
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frame_pas1[k2], false)
                    endif
                    if r != 9999 then
                        call SaveInteger(hs, id, child_id, value)
                        call BlzSetAbilityIcon(Erza4E_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Erza4_E.blp")
                        call BlzStartUnitAbilityCooldown(c, Erza4E_ID, r5)
                    endif
                    set c = null
                    set m_2[i] = m_2[MUI_2]
                    set MUI_2 = MUI_2 - 1
                    if MUI_2 == -1 then
                        call PauseTimer(t_2)
                    endif
                    call destroy()
                endif
                set i = i + 1
            endloop
        endmethod
        public static method MyFlushStacks_Start takes unit NewC, integer NewId, integer NewChild_Id, integer NewValue, real NewRmax returns nothing
            local thistype this = thistype.create()
            set MUI_2 = MUI_2 + 1
            set m_2[MUI_2] = this
            set c = NewC
            set r = 0
            set r2 = 0
            set rmax = NewRmax
            set id = NewId
            set child_id = NewChild_Id
            set value = NewValue
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set r5 = BlzGetUnitAbilityCooldown(c, Erza4E_ID, GetUnitAbilityLevel(c, Erza4E_ID) - 1)
            set k = LoadInteger(hs, id, child_id)
            set frame_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
            call BlzFrameSetAbsPoint(frame_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18)
            call BlzFrameSetSize(frame_pas1[k2], 0.135, 0.035)
            call BlzFrameSetTexture(frame_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
            call BlzFrameSetVisible(frame_pas1[k2], false)
            if GetLocalPlayer() == GetOwningPlayer(c) then
                call BlzFrameSetVisible(frame_pas1[k2], true)
            endif
            set frame_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame_pas1[k2], 0, 0)
            call BlzFrameSetAbsPoint(frame_pas2[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
            call BlzFrameSetSize(frame_pas2[k2], 0.1, 0.019)
            set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)
            call BlzFrameSetSize(frame_pas3[k2], 0.1, 0.035)
            call BlzFrameSetScale(frame_pas3[k2], 0.5)
            call BlzFrameSetModel(frame_pas3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
            call BlzFrameSetAbsPoint(frame_pas3[k2], FRAMEPOINT_CENTER, 0.05, 0.175)
            call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, rmax)
            call BlzFrameSetValue(frame_pas3[k2], rmax)
            set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)
            call BlzFrameSetAbsPoint(frame_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18)
            call BlzFrameSetSize(frame_pas4[k2], 0.0275, 0.0275)
            call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Erza4_E", 0, false)
            set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
            call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
            call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Stack Time Left:" + "|r")
            call BlzFrameSetScale(frame_pas5[k2], 0.9)
            set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
            call BlzFrameSetAbsPoint(frame_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17)
            call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
            call BlzFrameSetScale(frame_pas6[k2], 0.9)
            if MUI_2 == 0 then
                call TimerStart(t_2, 0.05, true, function thistype.Loop_MyFlushStacks)
            endif
        endmethod
        private static method Loop_Elemental takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaPas
                set this = m_ErzaPas[i]
                set r = r + 0.1
                if true then
                    if GetUnitAbilityLevel(td, id) > 0 then
                        if r2 > 0.9 then
                            set r2 = 0.1
                            if dmg != 0 then
                                if k2 == 6 then
                                    call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_by_wood_effect_yubanmeiqin_lightning_dianjishanghai.mdx", td, "chest"))
                                endif
                                call SaveInteger(hs,GetHandleId(c),StringHash("dmg stop mag"),1)
                                call MyFlush(GetHandleId(c),StringHash("dmg stop mag"),0,0.06)
                                call dmgmag(c, td, dmg)
                            endif
                            if (k2 == 2 or k2 == 6 )  then
                                if GetUnitAbilityLevel(c, ErzaW_ID) == 1 then
                                    call SlowUnitErza(c, td, ErzaWater_Slow1)
                                elseif GetUnitAbilityLevel(c, ErzaW_ID) == 2 then
                                    call SlowUnitErza(c, td, ErzaWater_Slow2)
                                elseif GetUnitAbilityLevel(c, ErzaW_ID) == 3 then
                                    call SlowUnitErza(c, td, ErzaWater_Slow3)
                                elseif GetUnitAbilityLevel(c, ErzaW_ID) == 4 then
                                    call SlowUnitErza(c, td, ErzaWater_Slow4)
                                elseif GetUnitAbilityLevel(c, ErzaW_ID) == 5 then
                                    call SlowUnitErza(c, td, ErzaWater_Slow5)
                                else
                                    call SlowUnitErza(c, td, ErzaWater_Slow1)
                                endif
                            endif
                        else
                            set r2 = r2 + 0.1
                        endif
                    else
                        if k2 == 2 or k2 == 6 then 
                        call UnitRemoveAbility(td,'B012')
                        endif
                        if k2 == 3 then
                            call SetMpCurrent(td, -(ErzaLightning_ManaBurnBase + (ErzaLightning_ManaBurnStep * (GetUnitAbilityLevel(c, ErzaE_ID) - 1))))
                            call StunUnit(c, td, ErzaLightning_Stun)
                            if check2 == 1 then 
                            call dmgmag(c,td,300)
                            
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_RedMissile.mdl", GetUnitX(td),GetUnitY(td),1,1,3,50))
                            call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_by_wood_effect_yubanmeiqin_lightning_dianjishanghaired.mdx", td, "chest"))
                            else
                            call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_by_wood_effect_yubanmeiqin_lightning_dianjishanghai.mdx", td, "chest"))
                            endif
                        endif
                        if k2 == 4 then
                            call UnitRemoveAbility(td, ErzaWape_DecreaseArmor_ID)
                        endif
                        if k2 == 6 then
                            call DestroyEffect(e2)
                        endif
                        if k2 == 9 then 
                        
                        endif
                        call DestroyEffect(e)
                        set c = null
                        set td = null
                        set e = null
                        set e2 = null
                        set m_ErzaPas[i] = m_ErzaPas[MUI_ErzaPas]
                        set MUI_ErzaPas = MUI_ErzaPas - 1
                        if MUI_ErzaPas == -1 then
                            call PauseTimer( t_ErzaPas )
                        endif
                        call destroy( )
                    endif
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaPas_Start takes unit NewC, unit NewTd , integer NewId returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaPas = MUI_ErzaPas + 1
            set m_ErzaPas[MUI_ErzaPas] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set dmg = 0
            set check2 = 0
            set k2 = NewId
            if NewId == 1 then
                set id = ErzaFire_ID
                set dmg = ErzaFire_DamageBase
                set e = AddSpecialEffectTarget("war3mapImported\\wos_BY_Wood_Effect_Order_MuZhiBenYing_Fir_Huo_DiMianss2.mdl", td, "origin")
            elseif NewId == 2 then
                set e = AddSpecialEffectTarget("war3mapImported\\wos_laz (167).mdl", td, "origin")
                if GetUnitAbilityLevel(c, ErzaW_ID) == 1 then
                    call SlowUnitErza(c, td, ErzaWater_Slow1)
                elseif GetUnitAbilityLevel(c, ErzaW_ID) == 2 then
                    call SlowUnitErza(c, td, ErzaWater_Slow2)
                elseif GetUnitAbilityLevel(c, ErzaW_ID) == 3 then
                    call SlowUnitErza(c, td, ErzaWater_Slow3)
                elseif GetUnitAbilityLevel(c, ErzaW_ID) == 4 then
                    call SlowUnitErza(c, td, ErzaWater_Slow4)
                elseif GetUnitAbilityLevel(c, ErzaW_ID) == 5 then
                    call SlowUnitErza(c, td, ErzaWater_Slow5)
                else
                    call SlowUnitErza(c, td, ErzaWater_Slow1)
                endif                     
            if IsUnitEnemy(td,GetOwningPlayer(c)) then
                call NextDmg(c, td, ErzaWater_DamageBase, 0, 0.15)
            endif
            set id = ErzaWater_ID
            elseif NewId == 3 then
             if  LoadInteger(hs, GetHandleId(c), StringHash("mode g"))>0 and LoadInteger(hs,GetHandleId(c),StringHash("lvl5")) >0 then  
                set e = AddSpecialEffectTarget("war3mapImported\\wos_Opdef (1005)2red.mdl", td, "origin")
                set check2 = 1
               else 
                set e = AddSpecialEffectTarget("war3mapImported\\wos_Opdef (1005)2.mdl", td, "origin")
                endif
                set id = ErzaLightning_ID
            elseif NewId == 4 then
                set id = ErzaWape_ID
                set e = AddSpecialEffectTarget("war3mapImported\\wos_steam.mdl", td, "origin")
                call UnitAddAbility(td, ErzaWape_DecreaseArmor_ID)
                call UnitMakeAbilityPermanent(td, true, ErzaWape_DecreaseArmor_ID)
            if IsUnitEnemy(td,GetOwningPlayer(c)) then
            call NextDmg(c, td, ErzaWape_Damage * GetMainStatValue(c, true), 0, 0.3)
            endif
            elseif NewId == 5 then
                set id = ErzaOverload_ID
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_WTW-whitethunder-Zi.mdl", x, y, GetRandomReal(0, 359), 1.5, 2, 0))
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_SasukeYh-41.mdl", x, y, GetRandomReal(0, 359), 1.5, 3, 75))
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_fire explosion-41.mdl", x, y, GetRandomReal(0, 359), 1, 1.2, 105))
                if IsUnitEnemy(td,GetOwningPlayer(c)) then
                call NextDmg(c, td, ErzaOverload_Damage * GetMainStatValue(c, true), 0, 0.3)
                call StunUnit(c, td, ErzaOverload_Stun)
            endif
           elseif NewId == 6 then
                set id = ErzaElectrized_ID
                set dmg = GetMainStatValue(c, true) * ErzaElectrized_Damage
                set e2 = AddSpecialEffectTarget("war3mapImported\\wos_Opdef (1005)2.mdl", td, "origin")
                set e = AddSpecialEffectTarget("war3mapImported\\wos_laz (167).mdl", td, "origin")
                if GetUnitAbilityLevel(c, ErzaW_ID) == 1 then
                    call SlowUnitErza(c, td, ErzaWater_Slow1)
                elseif GetUnitAbilityLevel(c, ErzaW_ID) == 2 then
                    call SlowUnitErza(c, td, ErzaWater_Slow2)
                elseif GetUnitAbilityLevel(c, ErzaW_ID) == 3 then
                    call SlowUnitErza(c, td, ErzaWater_Slow3)
                elseif GetUnitAbilityLevel(c, ErzaW_ID) == 4 then
                    call SlowUnitErza(c, td, ErzaWater_Slow4)
                elseif GetUnitAbilityLevel(c, ErzaW_ID) == 5 then
                    call SlowUnitErza(c, td, ErzaWater_Slow5)
                endif
            elseif NewId == 9 then
                set id = 'B00F'
                
                set dmg = GetUnitState(c,UNIT_STATE_MAX_MANA)*(Kurikara_MaxManaDmg/100)
                set e = AddSpecialEffectTarget("war3mapImported\\wos_tx_huoyan.mdl", td, "origin")
            endif
            set r2 = 0.06
            if MUI_ErzaPas == 0 then
                call TimerStart( t_ErzaPas, 0.1, true, function thistype.Loop_Elemental )
            endif
        endmethod
    endstruct  
    function ErzaPassive takes unit c, unit u, integer level returns nothing // min 0.5 , max 5.0 sec
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local integer id
        local integer cancel = 0
        local unit d = DummyPlayer2[i] 
        local integer skip = 0
        if IsUnitIllusion(u) == false and IsUnitVisible(u, Player(i)) == true and LoadInteger(hs,GetHandleId(u),StringHash("naofumi shield")) == 0 then
            if level == 9 then 
            set d = DummyPlayer6[i]
            endif
            if d == null or GetWidgetLife(d) < 1 then
             if level == 9 then 
              set DummyPlayer6[i] = CreateUnit( Player( i ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
             else
                set DummyPlayer2[i] = CreateUnit( Player( i ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
               endif
            if level == 9 then 
            set d = DummyPlayer6[i] 
             call UnitAddAbility(d, 'A0DZ')
            else 
            set d = DummyPlayer2[i] 
             call UnitAddAbility(d, ErzaElemntalAbi_ID)
             endif
            endif
            if GetUnitTypeId(u) == Rimuru_ID and level == 1 then 
            set level = 0
            endif
            if level>0 and level != 9  then 
             set level = DebuffImmune_Start(u,level)
            endif
            if level > 0 then
                if GetUnitAbilityLevel(d, ErzaElemntalAbi_ID) == 0 and level != 9 then
                    call UnitAddAbility(d, ErzaElemntalAbi_ID)
                endif
                call SetUnitFacing(d, GAngle(d, u) * bj_RADTODEG)
                if level == 1 then
                    set id = ErzaFire_ID
                    if GetUnitAbilityLevel(u, ErzaWater_ID) > 0 then
                        set level = 4
                        set skip = 1
                        call UnitRemoveAbility(u, ErzaFire_ID)
                        call UnitRemoveAbility(u, ErzaWater_ID)
                    endif
                    if GetUnitAbilityLevel(u, ErzaLightning_ID) > 0 then
                        set level = 5
                        set skip = 1
                        call UnitRemoveAbility(u, ErzaFire_ID)
                        call UnitRemoveAbility(u, ErzaLightning_ID)
                    endif
                elseif level == 2 then
                    set id = ErzaWater_ID
                    if GetUnitAbilityLevel(u, ErzaFire_ID) > 0 then
                        set level = 4
                        call UnitRemoveAbility(u, ErzaFire_ID)
                        call UnitRemoveAbility(u, ErzaWater_ID)
                        set skip = 1
                    endif
                    if GetUnitAbilityLevel(u, ErzaLightning_ID) > 0 then
                        set level = 6
                        set skip = 1
                        call UnitRemoveAbility(u, ErzaWater_ID)
                        call UnitRemoveAbility(u, ErzaLightning_ID)
                    endif
                elseif level == 3 then
                    set id = ErzaLightning_ID
                    if GetUnitAbilityLevel(u, ErzaFire_ID) > 0 then
                        set level = 5
                        set skip = 1
                        call UnitRemoveAbility(u, ErzaFire_ID)
                        call UnitRemoveAbility(u, ErzaLightning_ID)
                    endif
                    if GetUnitAbilityLevel(u, ErzaWater_ID) > 0 then
                        set level = 6
                        set skip = 1
                        call UnitRemoveAbility(u, ErzaWater_ID)
                        call UnitRemoveAbility(u, ErzaLightning_ID)
                    endif
                elseif level == 4 then
                    set id = ErzaWape_ID
                elseif level == 5 then
                    set id = ErzaOverload_ID
                elseif level == 6 then
                    set id = ErzaElectrized_ID
                elseif level == 7 or level == 8 then
                    set id = ErzaElectrized_ID
                elseif level == 9 then
                    set id = 'B00F'    
                endif
                call SetUnitAbilityLevel(d, ErzaElemntalAbi_ID, level)
                if level !=9 and GetUnitAbilityLevel(u, ErzaWape_ID) > 0 or GetUnitAbilityLevel(u, ErzaOverload_ID) > 0 or GetUnitAbilityLevel(u, ErzaElectrized_ID) > 0 then
                    set cancel = 1
                endif
                if level == 3 and GetUnitAbilityLevel(u, ErzaLightning_ID) > 0 then
                    set cancel = 1
                endif
                if level == 7 or level == 8 then
                    set cancel = 0
                endif
                if (GetUnitAbilityLevel(u, id) == 0 or skip == 1 ) and cancel == 0 and level != 7 and level != 8 then
                    call ErzaDebuffs.ErzaPas_Start(c, u, level)
                endif
                if cancel == 0 then
                    call IssueTargetOrder(d, "curse", u)
                    if level == 2 and IsItemInInventory(c,'I01P')>0 and IntegerCd(u,"cd sog",SogyoNoKotowari_CD) then 
                   // call BlzStartUnitAbilityCooldown(c,'A09O',SogyoNoKotowari_CD)
                    if GetUnitAbilityLevel(c,'A07Z') == 0 then 
                    call UnitAddAbility(c,'A07Z')
                    call MyRemoveAbility(c,10,'A07Z',1)
                    endif
                    call ErzaPassive(c,u, 3)
                    endif
                endif
            endif
        endif
        set d = null
    endfunction
    function ErzaBuffNakagami_Start takes unit c, unit u returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        if DummyPlayer2[i] == null or GetWidgetLife(DummyPlayer2[i]) < 1 then
            set DummyPlayer2[i] = CreateUnit( Player( i ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
            call UnitAddAbility(DummyPlayer2[i], ErzaNakagamiBuff)
        endif
        if GetUnitAbilityLevel(DummyPlayer2[i], ErzaNakagamiBuff) == 0 then
            call UnitAddAbility(DummyPlayer2[i], ErzaNakagamiBuff)
        endif
        call SetUnitFacing(DummyPlayer2[i], GAngle(DummyPlayer2[i], u) * bj_RADTODEG)
        call IssueTargetOrder(DummyPlayer2[i], "innerfire", u)
    endfunction
    function ErzaBar takes unit c returns nothing
        call ErzaDebuffs.ErzaBar_Start(c)
    endfunction
    function ErzaStackRemoved takes unit erza, integer h_id, integer sh, integer value, real time returns nothing
        call ErzaDebuffs.MyFlushStacks_Start(erza, h_id, sh, value, time)
    endfunction
    function GroupPush takes unit c, real x, real y, real aoe, real push_distance, real push_duration, real a, boolean all returns nothing
        local group g = CreateGroup()
        local unit u
        local boolean b = true
        call GroupEnumUnitsInRange( g , x , y , aoe , AAADestNoDecorCond)
        loop
            set u = FirstOfGroup( g )
            exitwhen u == null
            if all == false then
                set b = IsUnitEnemy( u , GetOwningPlayer( c ))
            endif
            if SpellBool( u ) and b then
                if a == -2 then
                    call MUE(u, push_distance, push_duration, GAngle2(u, x, y))
                elseif a == -1 then
                    call MUE(u, push_distance, push_duration, GAngle3(x, y, u))
                else
                    call MUE(u, push_distance, push_duration, a)
                endif
            endif
            call GroupRemoveUnit( g , u )
        endloop
        call DestroyGroup(g)
        set u = null
        set g = null
    endfunction
    function GroupPushEff takes unit c, real x, real y, real aoe, real push_distance, real push_duration, real a, boolean all,integer k returns nothing
        local group g = CreateGroup()
        local unit u
        local boolean b = true
        call GroupEnumUnitsInRange( g , x , y , aoe , AAADestNoDecorCond)
        loop
            set u = FirstOfGroup( g )
            exitwhen u == null
            if all == false then
                set b = IsUnitEnemy( u , GetOwningPlayer( c ))
            endif
            if SpellBool( u ) and b then
            call ErzaPassive(c, u, k)
                if a == -2 then
                    call MUE(u, push_distance, push_duration, GAngle2(u, x, y))
                elseif a == -1 then
                    call MUE(u, push_distance, push_duration, GAngle3(x, y, u))
                else
                    call MUE(u, push_distance, push_duration, a)
                endif
            endif
            call GroupRemoveUnit( g , u )
        endloop
        call DestroyGroup(g)
        set u = null
        set g = null
    endfunction
    function GroupDmgEff takes unit c, real x, real y, real aoe, real dmg, integer k returns nothing
        local group g = CreateGroup()
        local unit u
        call GroupEnumUnitsInRange( g , x , y , aoe , AAADestNoDecorCond)
        loop
            set u = FirstOfGroup( g )
            exitwhen u == null
            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                call NextDmg(c, u, dmg,0,0.12)
                call ErzaPassive(c, u, k)
            endif
            call GroupRemoveUnit( g , u )
        endloop
        call DestroyGroup(g)
        set u = null
        set g = null
    endfunction
    function KurikaraFlame takes unit c, unit td returns nothing
        call ErzaPassive(c,td,9)
        endfunction
        function IsBuilding takes integer id returns boolean  
        return id == 'B005' or id == 'B00B' or id == 'B00C' or id == 'B00D' or id == 'B00E' or id == 'B00Q' or id == 'B00R' or id == 'B00J' or id == 'B00K' or id == 'B00L' or id == 'B00N' or id == 'B00M' or id == 'B01B'
        endfunction
        function IsBuildingFrieren takes integer id returns boolean  
        return id == 'B005' or id == 'B00B' or id == 'B00A' or id == 'B014' or id == 'B00Y'  or id == 'B00T' or id == 'B00C' or id == 'B00D' or id == 'B00E' or id == 'B00Q' or id == 'B00R' or id == 'B00J' or id == 'B00K' or id == 'B00L' or id == 'B00N' or id == 'B00M' or id == 'B01B'
        endfunction
    // One shared clock replaces thousands of short IntegerCd scheduler entries.
    // A Warcraft match will not approach this timer's expiration time.
    function DecorAlive_Filter takes nothing returns boolean
        return GetDestructableLife(GetFilterDestructable()) > 0.0 and GetDestructableTypeId(GetFilterDestructable()) != 'YTfb'
    endfunction

    private function DecorClockNow takes nothing returns real
        if not DecorCooldownClockStarted then
            set DecorCooldownClockStarted = true
            call TimerStart(DecorCooldownClock, 1000000.0, false, null)
        endif
        return TimerGetElapsed(DecorCooldownClock)
    endfunction

    // At most one expensive decor enumeration per 0.10 sec for each player.
    // Calls made by another unit/dummy of the same player share this limit.
   

    private function DecorCooldownReady takes integer sourceId, destructable d, real cooldown returns boolean
        local integer destructableId = GetHandleId(d)
        local real now = DecorClockNow()

        if now >= LoadReal(DecorCooldownTable, sourceId, destructableId) then
            call SaveReal(DecorCooldownTable, sourceId, destructableId, now + cooldown)
            return true
        endif

        return false
    endfunction
    function decordestroy takes nothing returns nothing
        local destructable d = GetEnumDestructable()
        local unit source = decorunit
        local integer sourceTypeId = GetUnitTypeId(source)
        local integer sourceHandleId = GetHandleId(source)
        local real damage = decordmg
        local real centerX = decor_x
        local real centerY = decor_y
        local real radius = decor_aoe
        local real x = GetDestructableX(d)
        local real y = GetDestructableY(d)
        local integer id = GetDestructableTypeId(d)
        local integer k = 0
        local integer k2 = 0
        local real hp = GetDestructableLife(d)
        local real f = 270 * bj_DEGTORAD
        local real hpcheck = hp - damage
        local real scale = 0.0
        local real time = 0.42
        local boolean b = true
        local real r5 = 0.0
        local integer frozenCount = 0
        local integer hungryCount = 0
        local integer itemSlot = -1
        local integer charges = 0
        local item trackedItem = null
        if sourceTypeId == 'h005' then
            if SR0(centerX, centerY, x, y) > radius and hp > 0.0 then
                set b = true
                set r5 = GetRandomReal( -0.35, -0.15)
                call DestroyEffect(EffectSpawn3("war3mapImported\\wos_az_jingzi_jiansheng01_e1_l2.mdl", x, y, GetRandomReal(0, 359), 1, 1.2, 150, r5))
                call DestroyEffect(EffectSpawn3("war3mapImported\\wos_az_jingzi_jiansheng01_e1_l2.mdl", x, y, GetRandomReal(0, 359), 1, 1.2, 450, r5))
            else
                set b = false
            endif
        endif
        if b then
        if sourceTypeId == Mahoraga_ID and IsBuilding(id) and LoadInteger(hs, sourceHandleId, StringHash("height td")) == 1 and hp > 0 then 
            call SaveInteger(hs, sourceHandleId, StringHash("decor add"),1)
            endif
            
        if IsBuildingFrieren(id) and LoadInteger(hs, sourceHandleId, StringHash("frieren t push")) == 1 and hp > 0 then 
            call StunUnit(source,source,FrierenT_Stun)
            call SaveInteger(hs,GetHandleId(source),StringHash("frieren t push hit"),1)
            endif
            if id == 'B015' or id == 'B017' then
                set time = 1
            endif
            if id == 'B013' then
                set time = 0.8
            endif
            if hp > 0.0 and DecorCooldownReady(sourceHandleId, d, time) then
                call SetDestructableLife(d, hp - damage)
                if hpcheck <= 0.0 then
                    set frozenCount = IsItemInInventory(source, 'I01K')
                    set hungryCount = IsItemInInventory(source, 'I00Q')

                    // Preserve the original priority: Frozen Heart wins when
                    // both items are present.
                    if frozenCount > 0 then
                        if BlzGetUnitAbilityCooldownRemaining(source, 'A07N') == 0.0 then
                            set itemSlot = IsItemInInventory3(source, 'I01K')
                            set trackedItem = UnitItemInSlot(source, itemSlot)
                            set charges = GetItemCharges(trackedItem) + 1
                            call SetItemCharges(trackedItem, charges)
                            if charges >= FrozenHeart_stack then
                                call SetItemCharges(trackedItem, 0)
                                call BlzStartUnitAbilityCooldown(source, 'A07N', FrozenHeart_cd)
                            endif
                            call SetHpCurrent2(source, source, FrozenHeart_hp)
                            call SetMpCurrent(source, FrozenHeart_mp)
                        endif
                    elseif hungryCount > 0 then
                        if BlzGetUnitAbilityCooldownRemaining(source, 'A02E') == 0.0 then
                            set itemSlot = IsItemInInventory3(source, 'I00Q')
                            set trackedItem = UnitItemInSlot(source, itemSlot)
                            set charges = GetItemCharges(trackedItem) + 1
                            call SetItemCharges(trackedItem, charges)
                            if charges >= HungrySin_stack then
                                call SetItemCharges(trackedItem, 0)
                                call BlzStartUnitAbilityCooldown(source, 'A02E', HungrySin_cd)
                            endif
                            call SetHpCurrent2(source, source, HungrySin_hp)
                            call SetMpCurrent(source, HungrySin_mp)
                        endif
                    endif
                endif
                if id == 'B01A' or id == 'B019'  and hpcheck <= 0 then // inori crystall
                    call SetDestructableAnimationSpeed(d, 3.15)
                    call KillDestructable(d)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_FantasyBattle (1644).mdx", x, y, 1, 1, 2, 30))
                endif
                if id == 'B00O' and hpcheck <= 0 then // explosive barrel
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_GZ_jntxn (11)_R1-200.mdl", x, y, 1, 1, 0.65, 1))
                    call ScaleDummy(UnitSpawn(Player(PLAYER_NEUTRAL_PASSIVE), Fire_ID, x, y, 1, 1, 1.75, 45, 9), 7.5, 1.75, 0.5)
                    call GroupDmgEff(source, x, y, 350, 300, 1)
                endif
                if id == 'B00P' and hpcheck <= 0 then // simple barrel
                    call DestroyEffect(EffectSpawn("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", x, y, 1, 1, 1, 1))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_dustbrown.mdl", x, y, 1, 1, 1, 1))
                endif
                if id == 'B007' or id == 'B009' and hpcheck <= 0 then // leaves
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_Razor_leaf-A392F3.mdl", x, y, 1, 1, 2, 95))
                endif
                if id == 'B005' or id == 'B00B' or id == 'B00C' or id == 'B00D' or id == 'B00E' then // red dom normal konoha and high and thin red konoha
                    set scale = 1
                    if id == 'B00D' or id == 'B00E' then
                        set scale = 1.5
                    endif
                    if hpcheck > 0 then // simple barrel
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_1baozha_90.mdl", x, y, GetRandomReal(0, 359), 1, scale, 2))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_1baozha_90.mdl", x, y, GetRandomReal(0, 359), 1, scale, 145))
                        if id == 'B00B' then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_1baozha_90.mdl", x, y, GetRandomReal(0, 359), 1, scale, 295))
                        endif
                    else
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_fbt-dilie22.mdl", x, y, GetRandomReal(0, 359), 1, scale + 0.5, 1))
                    endif
                endif
                if decordustcheck(d) and hpcheck <= 0 then // dust brown
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_dustbrown.mdl", x, y, GetRandomReal(0, 359), 1, 1, 1))
                endif
                if id == 'B013' then // gold bags
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_item_goldcredit.mdl", x, y, GetRandomReal(0, 359), 1, 1, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_item_goldcredit.mdl", x, y, GetRandomReal(0, 359), 1, 1, 1))
                endif
                if id == 'B01B' or id == 'B00N' then // gold bags
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_item_goldcredit.mdl", x+180*Cos(120*bj_DEGTORAD), y+180*Sin(120*bj_DEGTORAD), 120+GetRandomReal(0, 359), 1, 6, 25))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_item_goldcredit.mdl", x+180*Cos(240*bj_DEGTORAD), y+180*Sin(240*bj_DEGTORAD), 240+GetRandomReal(0, 359), 1, 6, 25))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_item_goldcredit.mdl", x+180*Cos(360*bj_DEGTORAD), y+180*Sin(360*bj_DEGTORAD), 360+GetRandomReal(0, 359), 1, 6, 25))
                endif
                if id == 'B00A' then // poneglif
                    if hpcheck <= 0 then
                        call SetDestructableAnimationSpeed(d, 1.25)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_darkdustgroundeffect.mdl", x, y, GetRandomReal(0, 359), 1, 1, 151))
                    else
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_hit-juhuang1.mdl", x, y, GetRandomReal(0, 359), 1, 2.5, 61))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_T_dustgaraa2.mdl", x, y, GetRandomReal(0, 359), 0.7, 1.35, 1))
                    endif
                endif
                if id == 'B00Q' or id == 'B00R' then // sand buildings
                    if hpcheck <= 0 then
                        call SetDestructableAnimationSpeed(d, 0.75)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_fbt-dilie22.mdl", x, y, GetRandomReal(0, 359), 1, 1.5, 1))
                    endif
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_dizhen-qiquan.mdl", x, y, GetRandomReal(0, 359), 1, 1, 125))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_dizhen-qiquan.mdl", x, y, GetRandomReal(0, 359), 1, 1, 415))
                    if id == 'B00Q' then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_dizhen-qiquan.mdl", x, y, GetRandomReal(0, 359), 1, 1, 595))
                    endif
                endif
                if id == 'B003' or id == 'B004' or id == 'B00Y' or id == 'B00S' then // metal hit
                    if hpcheck <= 0 then
                        if id == 'B00Y' or id == 'B00S' then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_hit-juhuang1.mdl", x, y, GetRandomReal(0, 359), 1, 1.25, 45))
                        endif
                        if id == 'B00S' then 
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (431232).mdl", x, y, 1, 1, 0.7, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_SasukeYh-41.mdl", x, y, 1, 1, 1.5, 55))
                        call GroupDmgEff(source, x, y, 400, 200, 3)
                        endif 
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_solaire_lightning_impact.mdl", x, y, GetRandomReal(0, 359), 0.4, 2.15, 51))
                    endif
                endif
                if id == 'B014' or id == 'B015' or id == 'B017' then // busic
                    if hpcheck > 0 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_hit-juhuang1.mdl", x, y, GetRandomReal(0, 359), 1, 1.75, 45))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_solaire_lightning_impact.mdl", x, y, GetRandomReal(0, 359), 0.4, 2.15, 51))
                    else
                        call ScaleDummy(UnitSpawn(Player(PLAYER_NEUTRAL_PASSIVE), Fire_ID, x, y, 1, 1, 1.75, 45, 9), 7.5, 1.75, 0.5)
                        if id == 'B014' then
                            call GroupDmgEff(source, x, y, 500, 500, 5)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (431232).mdl", x, y, 1, 1, 0.7, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_SasukeYh-41.mdl", x, y, 1, 1, 1.5, 55))
                        else
                            call GroupDmgEff(source, x, y, 500, 1000, 1)
                        endif
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_effect_yuzhiboyou_unusual_fenshendabaopo_2.mdl", x, y, GetRandomReal(0, 359), 1, 2, 1))
                    endif
                endif
                if id == 'B00T' then // gidrant
                    if hpcheck <= 0 then
                        call GroupPushEff(source, x, y, 350, 350, 0.42, -1, true,2)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (171).mdl", x, y, GetRandomReal(0, 359), 0.75, 1.25, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_LD2209 (129).mdl", x, y, GetRandomReal(0, 359), 0.4, 0.8, 1))
                    endif
                endif
                if id == 'B00J' or id == 'B00K' or id == 'B00L' or id == 'B00N' or id == 'B00M' or id == 'B01B' then // red dom normal konoha and high and thin red konoha
                    set k2 = 3
                    set f = 800
                    if id == 'B00K' then
                        set k2 = 4
                        set f = 1100
                    endif
                    if id == 'B00M' then
                        set k2 = 5
                        set f = 1600
                    endif
                    set k = 0
                    loop
                        exitwhen k == k2
                        set scale = GetRandomReal(150, f)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_hit wave white.mdl", x, y, GetRandomReal(0, 359), 0.65, 2, scale))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_Effect Pieces.mdl", x, y, GetRandomReal(0, 359), 1, 3.25, scale - 110))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_Effect Pieces.mdl", x, y, GetRandomReal(0, 359), 1, 3.25, scale - 110))
                        set k = k + 1
                    endloop
                    call SetDestructableAnimationSpeed(d, 1.15)
                    if hpcheck <= 0 then // dust big
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_shachen1.mdl", x, y, GetRandomReal(0, 359), 1, 1, 1))
                    endif
                endif
            //call MyReviveDest(d,90)
            endif
        endif
        set trackedItem = null
        set source = null
        set d = null
    endfunction
    function decordestroyInori takes nothing returns nothing
        local destructable d = GetEnumDestructable()
        local integer id = GetDestructableTypeId(d)
                if id == 'B01A' or id == 'B019'  then // inori crystall
              call RemoveDestructable(d)
              endif
        set d = null
    endfunction
    function DecorRestore takes nothing returns nothing
        call EnumDestructablesInRect( bj_mapInitialPlayableArea, null, function decordrevive )
    endfunction
    function PlayersMsg takes string s, real r returns nothing
        local integer i = 0
        loop
            exitwhen i == bj_MAX_PLAYER_SLOTS
            call DisplayTimedTextToPlayer(Player(i), 0, 0, r, s)
            set i = i + 1
        endloop
    endfunction
   function DecorRemove takes unit c, real x, real y, real aoe, real dmg returns nothing
    local rect enumRect
    // Проверяем только корректность вызова. Общего кулдауна игрока здесь нет.
    if c == null or aoe <= 0.0 then
        return
    endif
    set decordmg = dmg
    set decorunit = c
    set decor_x = x
    set decor_y = y
    set decor_aoe = aoe
    set enumRect = Rect(x - aoe, y - aoe, x + aoe, y + aoe)
    call EnumDestructablesInRect(enumRect, DecorAliveCond, function decordestroy)
    call RemoveRect(enumRect)
    set enumRect = null
endfunction

    function DecorRemoveInori takes unit c, real x, real y, real aoe returns nothing
        local rect enumRect

        if aoe > 0.0 then
            set enumRect = Rect(x - aoe, y - aoe, x + aoe, y + aoe)
            call EnumDestructablesInRect(enumRect, null, function decordestroyInori)
            call RemoveRect(enumRect)
            set enumRect = null
        endif
    endfunction

    function DecorRemove2 takes unit c, real x, real y, real aoe, real dmg returns nothing
        set decor_x = x
        set decor_y = y
        set decor_aoe = aoe
        set decordmg = dmg
        set decorunit = c
        call EnumDestructablesInRect(gg_rct_Arena, DecorAliveCond, function decordestroy)
    endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
