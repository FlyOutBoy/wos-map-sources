library RaidenSpells uses GearSystems
    globals
        // --------------------------------------------------------------------------
        // Raiden Core
        // --------------------------------------------------------------------------
        integer Raiden_ID = 'H000'
        integer Raiden_Morph_ID = 'H003'
        integer Raiden_Dummy_ID = 'h004'
        integer Raiden_FDummy_ID = 'h02G'
        unit Raiden_F_Dummy = null

        // Глобальные фреймы интерфейса (создаются один раз, без утечек)
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

        // --------------------------------------------------------------------------
        // Q Ability
        // --------------------------------------------------------------------------
        integer RaidenQ_ID = 'A000'
        real RaidenQ_DamageAgiBase = 1.0
        real RaidenQ_DamageAgiStep = 1.0
        real RaidenTQ_DamageAgiBonus = 2.0
        real RaidenTTQ_DamageAgiBonus = 3.0
        real RaidenQ_Damage2StaticBase = 200.0
        real RaidenQ_Damage2StaticStep = 0.0
        real RaidenQ_DamageAoeCheck = 200.0
        real RaidenQ_DamageAoe = 475.0
        real RaidenQ_StunTime = 0.10
        real RaidenQ_PrepareTime = 0.30
        real RaidenQ_CastTime = 0.30
        real RaidenQ_MinMove = 1200.0
        real RaidenQ_PushRange = 300.0
        real RaidenQ_PushDuration = 0.45
        boolean RaidenQ_IsInvul = false
        real RaidenQ_DecorDamage = 10.0
        real RaidenTQ_DecorDamage = 40.0
        real RaidenTTQ_DecorDamage = 60.0

        // --------------------------------------------------------------------------
        // W Ability
        // --------------------------------------------------------------------------
        integer RaidenW_ID = 'A001'
        real RaidenW_DamageAgiBase = 0.30
        real RaidenW_DamageAgiStep = 0.10
        real RaidenW_Damage2StaticBase = 50.0
        real RaidenW_Damage2StaticStep = 0.0
        real RaidenW_ManaRestoreSec = 10.0
        real RaidenW_ManaRestore = 20.0
        real RaidenW_ManaRestoreCd = 20.0
        real RaidenW_Duration = 8.00
        real RaidenW_AtkCd = 0.10
        real RaidenTW_DamageAgiBase = 0.20
        real RaidenTW_DamageAgiStep = 0.1
        real RaidenTTW_DamageAgiBonus = 0.10
        real RaidenTW_DamageAoe = 400.0
        real RaidenTW_DamageAoeCheck = 700.0
        real RaidenTTW_DamageAoeCheck = 1000.0
        real RaidenW_MoveSpeedBonus = 1.20
        real RaidenArena_DamageAgiBase = 1.00
        real RaidenArena_DamageAgiStep = 0.50
        real RaidenArena_StaticBase = 20.0
        real RaidenArena_StaticStep = 10.0
        boolean RaidenW_IsInvul = false
        real RaidenW_DecorDamage = 20.0
        real RaidenTW_StrikeInterval = 0.48
        real RaidenTTW_CastTime = 0.60
        boolean RaidenTTW_IsInvul = false
        real RaidenTTW_ArenaInterval = 0.05
        real RaidenTTW_ArenaDecorDamage = 50.0

        // --------------------------------------------------------------------------
        // E Ability
        // --------------------------------------------------------------------------
        integer RaidenE_ID = 'A002'
        real RaidenE_DamageAgiBase = 2.0
        real RaidenE_DamageAgiStep = 1.0
        real RaidenE_Damage2StaticBase = 0.0
        real RaidenE_Damage2StaticStep = 0.0
        real RaidenTE_DamageAgiBonus = 1.0
        real RaidenTTE_DamageAgiBonus = 2.0
        real RaidenE_Range = 1800.0
        real RaidenE_DamageAoe = 425.0
        real RaidenE_PushRange = 500.0
        real RaidenE_PushDuration = 0.39
        real RaidenTE_DamageAoe = 650.0
        integer RaidenE_Slow = 40
        integer RaidenE_Duration = 1
        real RaidenE_CastTime = 0.51
        boolean RaidenE_IsInvul = true
        real RaidenE_DecorDamage = 25.0
        real RaidenTE_Duration = 1.02
        real RaidenTE_DecorDamage = 10.0
        real RaidenTTE_DecorDamage = 100.0

        // --------------------------------------------------------------------------
        // R Ability
        // --------------------------------------------------------------------------
        integer RaidenR_ID = 'A003'
        real RaidenR_StunTime = 0.50
        real RaidenTR_StunTime = 1.00
        real RaidenTTR_StunTime = 1.50
        real RaidenTR_DamageAgiBonus = 1.0
        real RaidenTTR_DamageAgiBonus = 2.0
        real RaidenR_DamageAgiBase = 4.0
        real RaidenR_DamageAgiStep = 1.0
        real RaidenR_Damage2StaticBase = 0.0
        real RaidenR_Damage2StaticStep = 0.0
        real RaidenR_DamageAoe = 650.0
        real RaidenR_CastTime = 0.66
        boolean RaidenR_IsInvul = false
        real RaidenR_DecorDamage = 50.0
        real RaidenTR_CastTime = 1.20
        boolean RaidenTR_IsInvul = true
        real RaidenTTR_CastTime = 1.92
        boolean RaidenTTR_IsInvul = true
        real RaidenTR_DecorDamage = 100.0
        real RaidenTTR_DecorDamage = 100.0

        // --------------------------------------------------------------------------
        // T & TT Abilities
        // --------------------------------------------------------------------------
        integer RaidenT_ID = 'A004'
        integer RaidenTT_ID = 'A005'
        integer RaidenT_AS = 'A006'
        real RaidenT_AddManaPerHit = 2.0
        real RaidenT_CastTime = 1.00
        real RaidenT_Duration = 20.00
        real RaidenTT_CastTime = 0.90
        real RaidenTT_AddDuration = 15.00
        real RaidenTT_RemoveCd = 10.00
        integer RaidenT_AdditionalDmg = 150
        boolean RaidenT_IsInvul = false
        boolean RaidenTT_IsInvul = false

        // --------------------------------------------------------------------------
        // G Ability
        // --------------------------------------------------------------------------
        integer RaidenG_ID = 'A0GD'
        real RaidenG_AgiDMG = 1.50
        integer RaidenG_CountAtkToTrigger = 3

        // --------------------------------------------------------------------------
        // F Ability
        // --------------------------------------------------------------------------
        integer RaidenF_ID = 'A0GF'
        integer RaidenF_Slow = 20
        integer RaidenF_SlowDuration = 3
        boolean RaidenF_IsInvul = false
    endglobals

    function RaidenAtk_Start takes unit c, unit td returns nothing
        local real x = GetUnitX(td)
        local real y = GetUnitY(td)
        local real a = GetRandomReal(0, 359)
        local integer atk_trigger = RaidenG_CountAtkToTrigger
        local boolean b = LoadInteger(hs, GetHandleId(c), StringHash("q abi")) > 0
        local integer lvl = 1
        local real dmg = GetHeroAgi(c, true) * RaidenG_AgiDMG
        local integer atk = LoadInteger(hs, GetHandleId(c), StringHash("atk count")) + 1

        if GetHeroLevel(c) >= 35 then
            set lvl = 4
        elseif GetHeroLevel(c) >= 25 then
            set lvl = 3
        elseif GetHeroLevel(c) >= 12 then
            set lvl = 2
        endif

        if LoadInteger(hs, GetHandleId(c), StringHash("raiden w atk")) == 1 then
            set atk_trigger = 2
        endif

        if atk >= atk_trigger then
            if Raiden_F_Dummy == null then
                set Raiden_F_Dummy = CreateUnit(GetOwningPlayer(c), Raiden_FDummy_ID, GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster), 1)
            endif
            if not b then
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-trlightning2.mdl", x, y, GetRandomReal(0, 359), 1, 1, 0))
                call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_WTW-whitethunder-Zi.mdx", x, y, GetRandomReal(0, 359), 1, 1.1, 0), 0.3, 255, 255, 255, 0.3)
                call EUTU2(EffectSpawn("war3mapImported\\wos_mei-rsfx-6.mdl", x, y, a, 1.25, 1.45, 100), 0.36, 100, td)
                call NextDmg(c, td, dmg, 0, 0.1)
            endif
            set atk = 0
        endif

        call BuffUnit01(c, c, 'A0GE', "bloodlust", lvl)
        call SaveInteger(hs, GetHandleId(c), StringHash("atk count"), atk)
    endfunction

    private struct RaidenQ_KS
        private static timer t_RaidenQ = CreateTimer()
        private static integer array m_RaidenQ
        private static integer MUI_RaidenQ = -1

        unit c
        real x
        real y
        real r2
        integer k2
        real scale
        real r_prepare
        real r3
        real r5
        real r6
        real sr
        group g
        group g2
        unit u
        real dmg
        integer check
        integer check2
        real aoe
        real move
        real r
        effect e
        real a
        real rmax

        private static method Loop_RaidenQ takes nothing returns nothing
            local integer this
            local integer i = 0

            loop
                exitwhen i > MUI_RaidenQ
                set this = m_RaidenQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if k2 == 0 then
                        if check == 0 then
                            if r == r_prepare - 0.03 then
                                call SetUnitTimeScale(c, 1)
                                call SetUnitAnimationByIndex(c, 40)
                                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, 1, 255, 255, 255, 225))
                            endif
                            if r < r_prepare then
                                call DebugUnit2(c)
                            endif
                            if r >= r_prepare then
                                set x = GetUnitX(c) + 50 * Cos(a)
                                set y = GetUnitY(c) + 50 * Sin(a)
                                if r2 > 0.03 then
                                    set r2 = 0
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, 1, 255, 255, 255, 225))
                                else
                                    set r2 = r2 + 0.03
                                endif
                                call MoveUnit(c, move, a)
                                call GroupClear(g)
                                call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null or check > 0
                                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                        set check = 1
                                        set r = 0
                                        set rmax = 0.75
                                        call MUE(u, 100, 0.3, a)
                                        call MakeSound("war3mapimported\\Hero_Raiden_Q_1")
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                                set u = null
                            endif
                        elseif check == 1 then
                            set x = GetUnitX(c) + 85 * Cos(a)
                            set y = GetUnitY(c) + 85 * Sin(a)
                            call DebugUnit2(c)
                            if r == 0.03 then
                                call MUE(c, 80, 0.21, a)
                                call SetUnitTimeScale(c, 0.8)
                                call SetUnitAnimationByIndex(c, 3)
                                call MakeSound("war3mapimported\\Hero_Raiden_Q_01")
                                call MakeSound("war3mapimported\\Hero_Raiden_Q2")
                            endif
                            if r == 0.21 then
                                call MakeSound("war3mapimported\\Hero_Raiden_Q_2")
                            endif
                            if r == 0.24 then
                                if check2 == 0 then
                                    call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_VergilSlashesYellow.mdl", x, y, a * bj_RADTODEG, 1.35, scale, 165), 1, 255, 255, 255, 0.06)
                                else
                                    call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_RaidenEi-12.mdl", x, y, a * bj_RADTODEG, 1.15, scale * 0.11, 165), 1, 255, 255, 255, 0.06)
                                endif
                            endif
                            if r == 0.36 then
                                call MakeSound("war3mapimported\\Hero_Raiden_Q3")
                                call MakeSound("war3mapimported\\Hero_Raiden_Q_02")
                                call SetUnitTimeScale(c, 0.8)
                                call SetUnitAnimationByIndex(c, 4)
                            endif
                            if r == 0.45 then
                                if check2 == 0 then
                                    call ColorEffDummy3(EffectSpawn2("war3mapImported\\wos_VergilSlashesYellow.mdl", x, y, a * bj_RADTODEG, 1.35, scale, 165, 0.03), 1, 255, 255, 255, 0.06)
                                else
                                    call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_RaidenEi-11.mdl", x, y, a * bj_RADTODEG, 1.15, scale * 0.11, 165), 1, 255, 255, 255, 0.06)
                                endif
                                call MakeSound("war3mapimported\\Hero_Raiden_Q_3")
                            endif
                            if r == 0.57 then
                                call MakeSound("war3mapimported\\Hero_Raiden_Q_03")
                                call MakeSound("war3mapimported\\Hero_Raiden_Q4")
                                call SetUnitTimeScale(c, 0.8)
                                call SetUnitAnimationByIndex(c, 5)
                            endif
                            if r == 0.72 then
                                set scale = 7.5
                                if check2 == 1 then
                                    call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_RaidenEi-11.mdl", x, y, a * bj_RADTODEG, 1, scale * 0.125, 165), 1, 255, 255, 255, 0.06)
                                    call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_RaidenEi-12.mdl", x, y, a * bj_RADTODEG, 1, scale * 0.125, 165), 1, 255, 255, 255, 0.06)
                                else
                                    call ColorEffDummy3(EffectSpawn3_2("war3mapImported\\wos_VergilSlashesYellow.mdl", x, y, a * bj_RADTODEG, 1, scale, 195, -35), 1, 255, 255, 255, 0.06)
                                    call ColorEffDummy3(EffectSpawn3_2("war3mapImported\\wos_VergilSlashesYellow.mdl", x, y, a * bj_RADTODEG, 1, scale, 195, -325), 1, 255, 255, 255, 0.06)
                                endif
                            endif
                            if r == 0.24 or r == 0.45 or r == 0.72 then
                                if r != 0.72 then
                                    call MUE(c, 80, 0.21, a)
                                endif
                                if check2 == 1 then
                                    call DecorRemove(c, x, y, RaidenQ_DamageAoe, RaidenQ_DecorDamage * 2.0)
                                else
                                    call DecorRemove(c, x, y, RaidenQ_DamageAoe, RaidenQ_DecorDamage)
                                endif
                                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_3.mdl", x, y, GetRandomReal(0, 359), 1.15, 2.35, 1, 255, 255, 255, 90))
                                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.325, 1, 255, 255, 255, 155))
                                call GroupClear(g)
                                call GroupEnumUnitsInRange(g, x, y, RaidenQ_DamageAoe, NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                        call dmgphys(c, u, dmg)
                                        call RaidenAtk_Start(c, u)
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                        if r == 0.72 then
                                            call MUE(u, RaidenQ_PushRange, RaidenQ_PushDuration, a)
                                        else
                                            call MUE(u, 95, 0.21, a)
                                        endif
                                        call StunUnit(c, u, RaidenQ_StunTime)
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                                set u = null
                            endif
                        endif
                    elseif k2 == 1 then
                        if r == r_prepare - 0.03 then
                            set e = EffectSpawnColor("war3mapImported\\wos_zk_shiki_dash.mdl", GetUnitX(c) + 200 * Cos(a), GetUnitY(c) + 200 * Sin(a), a * bj_RADTODEG, 0.9, 1.05, 10, 255, 255, 255, 195)
                            call EMUE(e, 400, 0.3, a)
                            set e = null
                            call SetUnitAnimationByIndex(c, 14)
                        endif
                        if r >= r_prepare then
                            set x = GetUnitX(c) + 50 * Cos(a)
                            set y = GetUnitY(c) + 50 * Sin(a)
                            call MoveUnit(c, move, a)
                            if r3 > 0.12 then
                                set r3 = 0
                                set r5 = GetRandomReal(150, 400)
                                set r6 = GetRandomReal(0, 359) * bj_DEGTORAD
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-trlightning2.mdl", GetUnitX(c) + r5 * Cos(r6), GetUnitY(c) + r5 * Sin(r6), GetRandomReal(0, 359), 1, 2, 1))
                            else
                                set r3 = r3 + 0.03
                            endif
                            if r2 > 0.06 then
                                set r2 = 0
                                call DecorRemove(c, x, y, RaidenQ_DamageAoe, RaidenTQ_DecorDamage)
                                call GroupClear(g)
                                call GroupEnumUnitsInRange(g, x, y, RaidenQ_DamageAoe, NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                        call GroupAddUnit(g2, u)
                                        call dmgmag(c, u, dmg)
                                        call StunUnit(c, u, RaidenQ_StunTime)
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                        call MUE(u, RaidenQ_PushRange, RaidenQ_PushDuration, a)
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                                set u = null
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif
                        set x = GetUnitX(c) + 85 * Cos(a)
                        set y = GetUnitY(c) + 85 * Sin(a)
                        call DebugUnit2(c)
                        if r == r_prepare - 0.12 then
                            call MakeSound("war3mapimported\\Hero_Raiden_TQ_1")
                        elseif r == r_prepare + 0.09 then
                            call SetUnitAnimationByIndex(c, 20)
                            call MakeSound("war3mapimported\\Hero_Raiden_TQ_2")
                        elseif r == r_prepare + 0.24 then
                            call MakeSound("war3mapimported\\Hero_Raiden_T_Atk3")
                        endif
                        if r == r_prepare + 0.12 or r == r_prepare + 0.36 then
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_RaidenEi-12.mdl", x, y, a * bj_RADTODEG, 1.15, scale * 0.11, 165), 1, 255, 255, 255, 0.06)
                        endif
                        if r == r_prepare + 0.24 then
                            call MakeSound("war3mapimported\\Hero_Raiden_TQ_2")
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_RaidenEi-11.mdl", x, y, a * bj_RADTODEG, 1.15, scale * 0.11, 165), 1, 255, 255, 255, 0.06)
                        endif
                    elseif k2 == 2 then
                        if r >= r_prepare then
                            set x = GetUnitX(c) + 50 * Cos(a)
                            set y = GetUnitY(c) + 50 * Sin(a)
                            call MoveUnit(c, move, a)
                            if r3 > 0.12 then
                                set r3 = 0
                                set r5 = GetRandomReal(150, 400)
                                set r6 = GetRandomReal(0, 359) * bj_DEGTORAD
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-trlightning2.mdl", GetUnitX(c) + r5 * Cos(r6), GetUnitY(c) + r5 * Sin(r6), GetRandomReal(0, 359), 1, 2, 1))
                                set r5 = GetRandomReal(250, 400)
                                set r6 = GetRandomReal(0, 359) * bj_DEGTORAD
                                call EffectSpawn2("war3mapImported\\wos_mei-qsfx-4.mdl", GetUnitX(c) + r5 * Cos(r6), GetUnitY(c) + r5 * Sin(r6), GetRandomReal(0, 359), 1, 1.5, 1, 0.3)
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_2-[tx]-03-01jianta (3).mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1.5, 0.645, 1))
                            else
                                set r3 = r3 + 0.03
                            endif
                            if r2 > 0.06 then
                                set r2 = 0
                                call DecorRemove(c, x, y, RaidenQ_DamageAoe, RaidenTTQ_DecorDamage)
                                call GroupClear(g)
                                call GroupEnumUnitsInRange(g, x, y, RaidenQ_DamageAoe, NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                        call GroupAddUnit(g2, u)
                                        call dmgmag(c, u, dmg)
                                        call StunUnit(c, u, RaidenQ_StunTime)
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                        call MUE(u, RaidenQ_PushRange, RaidenQ_PushDuration, a)
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                                set u = null
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif
                        set x = GetUnitX(c) + 85 * Cos(a)
                        set y = GetUnitY(c) + 85 * Sin(a)
                        call DebugUnit2(c)
                        if r == r_prepare + 0.03 then
                            call SetUnitAnimationByIndex(c, 11)
                        endif
                        if r == r_prepare + 0.15 then
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_RaidenEi-12.mdl", x + 105 * Cos(a), y + 105 * Sin(a), a * bj_RADTODEG, 1.15, scale * 0.164, 215), 1, 255, 255, 255, 0.06)
                        endif
                        if r == r_prepare + 0.30 then
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_RaidenEi-11.mdl", x + 105 * Cos(a), y + 105 * Sin(a), a * bj_RADTODEG, 1.15, scale * 0.164, 215), 1, 255, 255, 255, 0.06)
                        endif
                    endif
                else
                    call SaveInteger(hs, GetHandleId(c), StringHash("q abi"), 0)
                    call SetUnitAnimation(c, "stand")
                    call StopSpellUnit2(c)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set u = null
                    set m_RaidenQ[i] = m_RaidenQ[MUI_RaidenQ]
                    set MUI_RaidenQ = MUI_RaidenQ - 1
                    set i = i - 1
                    if MUI_RaidenQ == -1 then
                        call PauseTimer(t_RaidenQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method RaidenQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            set MUI_RaidenQ = MUI_RaidenQ + 1
            set m_RaidenQ[MUI_RaidenQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set r3 = 1
            set k2 = 0
            set check = 0
            call DebugUnit2(c)
            set move = 60
            set sr = SR3(c, x, y)
            if sr < RaidenQ_MinMove then
                set sr = RaidenQ_MinMove
            endif
            set r_prepare = RaidenQ_CastTime
            set rmax = r_prepare + ((sr / move) * 0.03)
            call SaveInteger(hs, GetHandleId(c), StringHash("q abi"), 1)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set scale = 5.75
            set u = null
            set check2 = 0
            if LoadInteger(hs, GetHandleId(c), StringHash("raiden t2")) > 0 then
                set k2 = 2
            elseif LoadInteger(hs, GetHandleId(c), StringHash("raiden t")) > 0 then
                set k2 = 1
            elseif LoadInteger(hs, GetHandleId(c), StringHash("raiden w")) > 0 then
                set check2 = 1
            endif
            set a = GAngle2(c, x, y)
            set aoe = RaidenQ_DamageAoeCheck
            set dmg = GetHeroAgi(c, true) * (RaidenQ_DamageAgiBase + (RaidenQ_DamageAgiStep * (GetUnitAbilityLevel(c, RaidenQ_ID) - 1)))
            set dmg = dmg + RaidenQ_Damage2StaticBase + (RaidenQ_Damage2StaticStep * (GetUnitAbilityLevel(c, RaidenQ_ID) - 1))
            if k2 == 2 then
                set move = 120
                set scale = 6.3
                set r_prepare = RaidenQ_CastTime + 0.33
                set rmax = r_prepare + 0.42
                call SetUnitAnimationByIndex(c, 6)
                call SetUnitTimeScale(c, 0.5)
                call MakeSound("war3mapimported\\Hero_Raiden_TT Q")
                call MakeSound("war3mapimported\\Hero_Raiden_TT_Q_1")
                set dmg = dmg + GetHeroAgi(c, true) * RaidenTTQ_DamageAgiBonus
            elseif k2 == 1 then
                set move = 90
                set scale = 6.3
                set r_prepare = RaidenQ_CastTime + 0.27
                set rmax = r_prepare + 0.45
                call SetUnitAnimationByIndex(c, 12)
                call SetUnitTimeScale(c, 1.25)
                call MakeSound("war3mapimported\\Hero_Raiden_TQ")
                set dmg = dmg + GetHeroAgi(c, true) * RaidenTQ_DamageAgiBonus
            elseif k2 == 0 then
                call SetUnitAnimationByIndex(c, 21)
                call MakeSound("war3mapimported\\Hero_Raiden_Q")
                set dmg = dmg / 3
                call SetUnitTimeScale(c, 1)
            endif
            call SetUnitFacing(c, a * bj_RADTODEG)
            set r5 = 0
            if MUI_RaidenQ == 0 then
                call TimerStart(t_RaidenQ, 0.03, true, function thistype.Loop_RaidenQ)
            endif
        endmethod
    endstruct
    
    private function OnRaidenPointOrder takes nothing returns boolean
        local unit u = GetOrderedUnit()
        local integer id = GetUnitTypeId(u)
        local integer ord = GetIssuedOrderId()
        if id == Raiden_ID or id == Raiden_Morph_ID then
            if ord == 851971 or ord == 851986 or ord == 851990 then
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_mode"), 1)
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_id"), ord)
                call SaveReal(hs, GetHandleId(u), StringHash("ord_x"), GetOrderPointX())
                call SaveReal(hs, GetHandleId(u), StringHash("ord_y"), GetOrderPointY())
            endif
        endif
        set u = null
        return false
    endfunction

    private function OnRaidenTargetOrder takes nothing returns boolean
        local unit u = GetOrderedUnit()
        local integer id = GetUnitTypeId(u)
        local integer ord = GetIssuedOrderId()
        if id == Raiden_ID or id == Raiden_Morph_ID then
            if ord == 851971 or ord == 851983 then
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_mode"), 2)
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_id"), ord)
                call SaveUnitHandle(hs, GetHandleId(u), StringHash("ord_target"), GetOrderTargetUnit())
            endif
        endif
        set u = null
        return false
    endfunction

    private function OnRaidenImmediateOrder takes nothing returns boolean
        local unit u = GetOrderedUnit()
        local integer id = GetUnitTypeId(u)
        local integer ord = GetIssuedOrderId()
        if id == Raiden_ID or id == Raiden_Morph_ID then
            if ord == 851972 or ord == 851993 then
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_mode"), 0)
            endif
        endif
        set u = null
        return false
    endfunction

    function Raiden_RestoreOrder takes unit c, integer animIndex returns nothing
        local integer mode = LoadInteger(hs, GetHandleId(c), StringHash("ord_mode"))
        local real ox
        local real oy
        local real dx
        local real dy
        local integer oid
        local unit tu

        if mode == 1 then
            set ox = LoadReal(hs, GetHandleId(c), StringHash("ord_x"))
            set oy = LoadReal(hs, GetHandleId(c), StringHash("ord_y"))
            set dx = ox - GetUnitX(c)
            set dy = oy - GetUnitY(c)
            // Если до точки назначения больше 75 единиц — продолжаем бег
            if (dx * dx + dy * dy) > 5625.0 then
                set oid = LoadInteger(hs, GetHandleId(c), StringHash("ord_id"))
                call IssuePointOrderById(c, oid, ox, oy)
                return
            endif
        elseif mode == 2 then
            set tu = LoadUnitHandle(hs, GetHandleId(c), StringHash("ord_target"))
            if tu != null and GetWidgetLife(tu) > 0.405 then
                set oid = LoadInteger(hs, GetHandleId(c), StringHash("ord_id"))
                call IssueTargetOrderById(c, oid, tu)
                set tu = null
                return
            endif
            set tu = null
        endif

        // Если стоял на месте или уже дошёл до цели
        call SetUnitAnimationByIndex(c, animIndex)
    endfunction

    private struct RaidenOrderInit extends array
        private static method onInit takes nothing returns nothing
            local trigger tPoint = CreateTrigger()
            local trigger tTarget = CreateTrigger()
            local trigger tImmediate = CreateTrigger()
            local integer i = 0
            loop
                exitwhen i >= 16
                call TriggerRegisterPlayerUnitEvent(tPoint, Player(i), EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER, null)
                call TriggerRegisterPlayerUnitEvent(tTarget, Player(i), EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER, null)
                call TriggerRegisterPlayerUnitEvent(tImmediate, Player(i), EVENT_PLAYER_UNIT_ISSUED_ORDER, null)
                set i = i + 1
            endloop
            call TriggerAddCondition(tPoint, Condition(function OnRaidenPointOrder))
            call TriggerAddCondition(tTarget, Condition(function OnRaidenTargetOrder))
            call TriggerAddCondition(tImmediate, Condition(function OnRaidenImmediateOrder))
        endmethod
    endstruct

    private struct RaidenW_KS
        private static timer t_RaidenW = CreateTimer()
        private static integer array m_RaidenW
        private static integer MUI_RaidenW = -1

        unit c
        unit td
        real x
        real y
        integer k2
        real r3
        real r6
        real r
        effect e
        effect e2
        real a
        real rmax
        real ms_base

        private static method Loop_RaidenW takes nothing returns nothing
            local integer this
            local integer i = 0

            loop
                exitwhen i > MUI_RaidenW
                set this = m_RaidenW[i]
                if SpellBoolCaster(c) and r <= rmax and LoadInteger(hs, GetHandleId(c), StringHash("raiden t")) == 0 then
                    if not IsUnitPaused(c) then
                        set r = r + 0.03
                    endif
                    if r == 0.15 then
                        set r6 = BlzGetUnitAbilityCooldown(c, RaidenW_ID, GetUnitAbilityLevel(c, RaidenW_ID) - 1)
                    endif
                    if r3 > 0.15 then
                        set r3 = 0
                        call BlzStartUnitAbilityCooldown(c, RaidenW_ID, r6)
                    else
                        set r3 = r3 + 0.03
                    endif
                    if r == 0.51 then
                        call BlzSetSpecialEffectTimeScale(e, 0.25)
                    endif
                    if r > 0.27 then
                        set a = GetUnitFacing(td) * bj_DEGTORAD
                        set x = GetUnitX(td) - 100 * Cos(a)
                        set y = GetUnitY(td) - 100 * Sin(a)
                        call BlzSetSpecialEffectPosition(e, x, y, 135)
                    endif
                    call BlzFrameSetValue(frame_pas3[k2], rmax - (r + 0.1))
                    if rmax - r >= 0 then
                        call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                    endif
                else
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame_pas1[k2], false)
                    endif
                    call BlzSetSpecialEffectTimeScale(e, 2)
                    call DestroyEffect(e)
                    call RemoveSavedHandle(hs, GetHandleId(td), StringHash("raiden"))
                    call SaveInteger(hs, GetHandleId(td), StringHash("raiden w"), 0)
                    call SetUnitMoveSpeed(c, ms_base)
                    call SaveInteger(hs, GetHandleId(c), StringHash("raiden w atk"), 0)
                    set c = null
                    set td = null
                    set e = null
                    set e2 = null
                    set m_RaidenW[i] = m_RaidenW[MUI_RaidenW]
                    set MUI_RaidenW = MUI_RaidenW - 1
                    set i = i - 1
                    if MUI_RaidenW == -1 then
                        call PauseTimer(t_RaidenW)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method RaidenW_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create()
            set MUI_RaidenW = MUI_RaidenW + 1
            set m_RaidenW[MUI_RaidenW] = this
            set c = NewC
            set td = NewTd
            set a = GetUnitFacing(c) * bj_DEGTORAD
            set x = GetUnitX(c) + 200 * Cos(a)
            set y = GetUnitY(c) + 200 * Sin(a)
            set r = 0
            set r3 = 0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set rmax = RaidenW_Duration
            set ms_base = GetUnitDefaultMoveSpeed(c)
            call SetUnitMoveSpeed(c, ms_base * RaidenW_MoveSpeedBonus)
            call Raiden_RestoreOrder(c, 8)

            if frame_pas1[k2] == null then
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
                call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Raiden_W", 0, false)
                set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Eye of Judgment:" + "|r")
                call BlzFrameSetScale(frame_pas5[k2], 0.8)
                set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17)
                call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                call BlzFrameSetScale(frame_pas6[k2], 0.9)
            else
                if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frame_pas1[k2], true)
                endif
                call BlzFrameSetValue(frame_pas3[k2], rmax)
            endif

            set e = EffectSpawn("war3mapImported\\wos_RaidenEi-41.mdl", x, y, a * bj_RADTODEG + 90, 2, 0.01, 0)
            call ScaleEffDummy(e, 0.18, 0.01, 0.75)
            call ScaleEffDummy2(e, 0.36, 0.18, 0.75, 0.55)
            set e2 = EffectSpawn("war3mapImported\\wos_RaidenEi-18.mdl", x, y, a * bj_RADTODEG + 90, 2, 0.01, 0)
            call ScaleEffDummy(e2, 0.18, 0.01, 0.5)
            call ColorEffDummy3(e2, 0.18, 255, 255, 255, 0.39)

            call SaveInteger(hs, GetHandleId(c), StringHash("raiden w atk"), 1)
            call MakeSound("war3mapimported\\Hero_Raiden_W")
            call MakeSound("war3mapimported\\Hero_Raiden_W_1")
            call SaveUnitHandle(hs, GetHandleId(td), StringHash("raiden"), c)
            call SaveInteger(hs, GetHandleId(td), StringHash("raiden w"), 1)
            if MUI_RaidenW == 0 then
                call TimerStart(t_RaidenW, 0.03, true, function thistype.Loop_RaidenW)
            endif
        endmethod
    endstruct

    private struct RaidenTW_KS
        private static timer t_RaidenTW = CreateTimer()
        private static integer array m_RaidenTW
        private static integer MUI_RaidenTW = -1

        unit c
        real x
        real y
        real r2
        integer k2
        integer k3
        real r3
        real r4
        real r5
        real r6
        real r7
        real r8
        real r9
        group g
        group g2
        unit u
        real dmg
        real r
        effect e
        effect e2
        real a
        real rmax
        real ms_base
        real dmg_arena

        private static method Loop_RaidenTW takes nothing returns nothing
            local integer this
            local integer i = 0
            local integer kek = 0
            local integer kek2 = 0
            local integer kek3 = 0

            loop
                exitwhen i > MUI_RaidenTW
                set this = m_RaidenTW[i]
                if SpellBoolCaster(c) and r <= rmax and LoadInteger(hs, GetHandleId(c), StringHash("raiden t")) == 1 and LoadInteger(hs, GetHandleId(c), StringHash("raiden t cast")) == 0 then
                    if k3 == 0 then
                        if not IsUnitPaused(c) then
                            set r = r + 0.03
                        endif
                        if r3 >= RaidenTW_StrikeInterval then
                            set r3 = 0
                            set r5 = GetRandomReal(RaidenTW_DamageAoe / 2, RaidenTW_DamageAoeCheck)
                            set r6 = GetRandomReal(0, 359) * bj_DEGTORAD
                            set x = GetUnitX(c) + r5 * Cos(r6)
                            set y = GetUnitY(c) + r5 * Sin(r6)
                            call GroupClear(g)
                            call GroupClear(g2)
                            call GroupEnumUnitsInRange(g, GetUnitX(c), GetUnitY(c), RaidenTW_DamageAoeCheck, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitType(u, UNIT_TYPE_HERO) then
                                    set x = GetUnitX(u)
                                    set y = GetUnitY(u)
                                    set kek = kek + 1
                                    call GroupAddUnit(g2, u)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                            if kek > 1 then
                                set kek2 = GetRandomInt(0, kek)
                                set kek3 = 0
                                call GroupClear(g)
                                call GroupEnumUnitsInRange(g, GetUnitX(c), GetUnitY(c), RaidenTW_DamageAoeCheck, NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitType(u, UNIT_TYPE_HERO) and IsUnitInGroup(u, g2) then
                                        if kek2 == kek3 then
                                            set x = GetUnitX(u)
                                            set y = GetUnitY(u)
                                        endif
                                        set kek3 = kek3 + 1
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                                set u = null
                            endif
                            call DecorRemove(c, x, y, RaidenTW_DamageAoe, RaidenW_DecorDamage)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-trlightning2.mdl", x, y, GetRandomReal(0, 359), 1, 1, 0))
                            call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_WTW-whitethunder-Zi.mdx", x, y, GetRandomReal(0, 359), 1, 1.1, 0), 0.3, 255, 255, 255, 0.3)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, RaidenTW_DamageAoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                    call dmgmag(c, u, dmg)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        else
                            set r3 = r3 + 0.03
                        endif
                    elseif k3 == 1 then
                        call BlzSetSpecialEffectPosition(e, GetUnitX(c), GetUnitY(c), 5)
                        call BlzSetSpecialEffectPosition(e2, GetUnitX(c), GetUnitY(c), 0)
                        if r < RaidenTTW_CastTime then
                            set r = r + 0.03
                            if r4 > 0.09 then
                                set r4 = 0
                                call EffectSpawn2("war3mapImported\\wos_mei-qsfx-4.mdl", GetUnitX(c), GetUnitY(c), 1, 1, 2.25, 35, 0.5)
                                call EffectSpawn2("war3mapImported\\wos_raiden-trarea.mdl", GetUnitX(c), GetUnitY(c), 1, 1, 1.25, 135, 0.5)
                            else
                                set r4 = r4 + 0.03
                            endif
                        else
                            if not IsUnitPaused(c) then
                                set r = r + 0.03
                            endif
                        endif
                        if r == RaidenTTW_CastTime then
                            call StopSpellUnit2(c)
                        endif
                        if r7 > 0.93 then
                            set r7 = 0
                            call EUTU2(EffectSpawn("war3mapImported\\wos_lucia-qsfx-2.mdl", GetUnitX(c), GetUnitY(c), 1, 1, 2, 20), 0.6, 20, c)
                        else
                            set r7 = r7 + 0.03
                        endif
                        if r3 >= RaidenTW_StrikeInterval then
                            set r3 = 0
                            set r5 = GetRandomReal(RaidenTW_DamageAoe / 2, RaidenTTW_DamageAoeCheck)
                            set r6 = GetRandomReal(0, 359) * bj_DEGTORAD
                            set x = GetUnitX(c) + r5 * Cos(r6)
                            set y = GetUnitY(c) + r5 * Sin(r6)
                            call GroupClear(g)
                            call GroupClear(g2)
                            call GroupEnumUnitsInRange(g, GetUnitX(c), GetUnitY(c), RaidenTTW_DamageAoeCheck, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitType(u, UNIT_TYPE_HERO) then
                                    set x = GetUnitX(u)
                                    set y = GetUnitY(u)
                                    set kek = kek + 1
                                    call GroupAddUnit(g2, u)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                            if kek > 0 then
                                if kek > 1 then
                                    set kek2 = GetRandomInt(0, kek)
                                    set kek3 = 0
                                    call GroupClear(g)
                                    call GroupEnumUnitsInRange(g, GetUnitX(c), GetUnitY(c), RaidenTTW_DamageAoeCheck, NoDecor_Cond)
                                    loop
                                        set u = FirstOfGroup(g)
                                        exitwhen u == null
                                        if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitType(u, UNIT_TYPE_HERO) and IsUnitInGroup(u, g2) then
                                            if kek2 == kek3 then
                                                set x = GetUnitX(u)
                                                set y = GetUnitY(u)
                                            endif
                                            set kek3 = kek3 + 1
                                        endif
                                        call GroupRemoveUnit(g, u)
                                    endloop
                                    set u = null
                                endif
                                call DecorRemove(c, x, y, RaidenTW_DamageAoe, RaidenW_DecorDamage)
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-trlightning2.mdl", x, y, GetRandomReal(0, 359), 1, 1, 0))
                                call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_purple wave explosion.mdl", x, y, a * bj_RADTODEG, 2.25, 0.9, 1), 0.21, 255, 255, 255, 0.21)
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_RaidenEi-8.mdl", x, y, a * bj_RADTODEG, 1, 0.9, 0))
                                call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_WTW-whitethunder-Zi.mdx", x, y, GetRandomReal(0, 359), 1, 1.1, 0), 0.3, 255, 255, 255, 0.3)
                                call GroupClear(g)
                                call GroupEnumUnitsInRange(g, x, y, RaidenTW_DamageAoe, NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                        call dmgmag(c, u, dmg)
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                                set u = null
                            endif
                        else
                            set r3 = r3 + 0.03
                        endif
                        if r2 > RaidenTTW_ArenaInterval then
                            set r2 = 0
                            set x = GetRandomReal(GetRectMinX(gg_rct_Arena), GetRectMaxX(gg_rct_Arena))
                            set y = GetRandomReal(GetRectMinY(gg_rct_Arena), GetRectMaxY(gg_rct_Arena))
                            call DecorRemove(c, x, y, RaidenTW_DamageAoe, RaidenTTW_ArenaDecorDamage)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-trlightning2.mdl", x, y, GetRandomReal(0, 359), 1, 1.5, 0))
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_purple wave explosion.mdl", x, y, a * bj_RADTODEG, 2.25, 0.9, 1), 0.21, 255, 255, 255, 0.21)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_RaidenEi-8.mdl", x, y, a * bj_RADTODEG, 1, 1.25, 0))
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_WTW-whitethunder-Zi.mdx", x, y, GetRandomReal(0, 359), 1, 2.1, 0), 0.3, 255, 255, 255, 0.3)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, RaidenTW_DamageAoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                    call dmgmag(c, u, dmg_arena)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                    call BlzFrameSetValue(frame_pas3[k2], rmax - (r + 0.1))
                    if rmax - r >= 0 then
                        call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                    endif
                    if r == 0.15 then
                        set r9 = BlzGetUnitAbilityCooldown(c, RaidenW_ID, GetUnitAbilityLevel(c, RaidenW_ID) - 1)
                    endif
                    if r8 > 0.15 then
                        set r8 = 0
                        call BlzStartUnitAbilityCooldown(c, RaidenW_ID, r9)
                    else
                        set r8 = r8 + 0.03
                    endif
                else
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame_pas1[k2], false)
                    endif
                    if k3 == 1 and r < 0.50 then
                        call StopSpellUnit(c)
                    endif
                    if k3 == 1 then
                        call ScaleEffDummy(e, 0.21, 1.25, 0.01)
                        call ColorEffDummy3(e, 0, 255, 255, 255, 0.36)
                        call ScaleEffDummy(e2, 0.21, 1.25, 0.01)
                        call ColorEffDummy3(e2, 0, 255, 255, 255, 0.36)
                    endif
                    call SetUnitMoveSpeed(c, ms_base)
                    call SaveInteger(hs, GetHandleId(c), StringHash("raiden w atk"), 0)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set u = null
                    set c = null
                    set e = null
                    set e2 = null
                    set m_RaidenTW[i] = m_RaidenTW[MUI_RaidenTW]
                    set MUI_RaidenTW = MUI_RaidenTW - 1
                    set i = i - 1
                    if MUI_RaidenTW == -1 then
                        call PauseTimer(t_RaidenTW)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method RaidenTW_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_RaidenTW = MUI_RaidenTW + 1
            set m_RaidenTW[MUI_RaidenTW] = this
            set c = NewC
            set r = 0
            set g = CreateGroup()
            set g2 = CreateGroup()
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set k3 = 0
            set r3 = 0
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r7 = 0
            set r8 = 0
            set rmax = RaidenW_Duration
            set ms_base = GetUnitDefaultMoveSpeed(c)
            call SetUnitMoveSpeed(c, ms_base * RaidenW_MoveSpeedBonus)

            if frame_pas1[k2] == null then
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
                call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Raiden_W", 0, false)
                set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Eye of Judgment:" + "|r")
                call BlzFrameSetScale(frame_pas5[k2], 0.8)
                set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17)
                call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                call BlzFrameSetScale(frame_pas6[k2], 0.9)
            else
                if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frame_pas1[k2], true)
                endif
                call BlzFrameSetValue(frame_pas3[k2], rmax)
            endif

            if LoadInteger(hs, GetHandleId(c), StringHash("raiden t2")) > 0 then
                set k3 = 1
                set e = EffectSpawn("war3mapImported\\wos_blackmoon.mdl", x, y, 1, 1, 0.01, 5)
                call ScaleEffDummy(e, 0.71, 0.01, 1.3)
                call BlzSetSpecialEffectAlpha(e, 160)
                call AnimDummyEff(e, 0.25, 0)
                set e2 = EffectSpawn("war3mapImported\\wos_tx2601.mdl", x, y, 1, 1, 0.01, 5)
                call StartSpellUnit2(c)
                call SetUnitAnimationByIndex(c, 3)
                call SetUnitTimeScale(c, 1)
                if GetRandomInt(1, 2) == 1 then
                    call MakeSound("war3mapimported\\Hero_Raiden_TTW_0")
                else
                    call MakeSound("war3mapimported\\Hero_Raiden_TT W")
                endif
                set dmg = GetHeroAgi(c, true) * (RaidenTW_DamageAgiBase + (RaidenTW_DamageAgiStep * (GetUnitAbilityLevel(c, RaidenW_ID) - 1)))
                set dmg = dmg + RaidenW_Damage2StaticBase + (RaidenW_Damage2StaticStep * (GetUnitAbilityLevel(c, RaidenW_ID) - 1))
                set dmg = dmg + GetHeroAgi(c, true) * RaidenTTW_DamageAgiBonus
                set dmg_arena = GetHeroAgi(c, true) * (RaidenArena_DamageAgiBase + (RaidenArena_DamageAgiStep * (GetUnitAbilityLevel(c, RaidenW_ID) - 1)))
                set dmg_arena = dmg_arena + RaidenArena_StaticBase + (RaidenArena_StaticStep * (GetUnitAbilityLevel(c, RaidenW_ID) - 1))
            else
                set dmg = GetHeroAgi(c, true) * (RaidenTW_DamageAgiBase + (RaidenTW_DamageAgiStep * (GetUnitAbilityLevel(c, RaidenW_ID) - 1)))
                set dmg = dmg + RaidenW_Damage2StaticBase + (RaidenW_Damage2StaticStep * (GetUnitAbilityLevel(c, RaidenW_ID) - 1))
                set dmg_arena = GetHeroAgi(c, true) * (RaidenArena_DamageAgiBase + (RaidenArena_DamageAgiStep * (GetUnitAbilityLevel(c, RaidenW_ID) - 1)))
                set dmg_arena = dmg_arena + RaidenArena_StaticBase + (RaidenArena_StaticStep * (GetUnitAbilityLevel(c, RaidenW_ID) - 1))

                call Raiden_RestoreOrder(c, 33)

                call MakeSound("war3mapimported\\Hero_Raiden_TW")
            endif

            call SaveInteger(hs, GetHandleId(c), StringHash("raiden w atk"), 1)
            call MakeSound("war3mapimported\\Hero_Raiden_TW_2")
            if MUI_RaidenTW == 0 then
                call TimerStart(t_RaidenTW, 0.03, true, function thistype.Loop_RaidenTW)
            endif
        endmethod
    endstruct

    private struct RaidenE_KS
        private static timer t_RaidenE = CreateTimer()
        private static integer array m_RaidenE
        private static integer MUI_RaidenE = -1

        unit c
        unit d
        real x
        real y
        real r2
        integer k
        integer k2
        real r3
        real r4
        real r5
        real r6
        real r7
        real sr
        group g
        group g2
        unit u
        real dmg
        real a2
        integer check2
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_RaidenE takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rkek = 0
            local real rkek2 = 0

            loop
                exitwhen i > MUI_RaidenE
                set this = m_RaidenE[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if k2 == 0 then
                        if r < RaidenE_CastTime then
                            call DebugUnit(c)
                        endif
                        if r == 0.30 then
                            call DestroyEffect(EffectSpawn3_2("war3mapImported\\wos_RaidenEi-11.mdl", GetUnitX(c) + 25 * Cos(a), GetUnitY(c) + 25 * Sin(a), a * bj_RADTODEG, 1.3, 0.625, 105, -165))
                        endif
                        if r == RaidenE_CastTime then
                            call StopSpellUnit(c)
                            set e = EffectSpawn("war3mapImported\\wos_by_wood_neff_odr_sla_jianqi_1-4ly1.mdl", GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), a * bj_RADTODEG, 1.5, 1.5, 65)
                        endif
                        if r > RaidenE_CastTime then
                            set x = GetEffX(e) + 140 * Cos(a)
                            set y = GetEffY(e) + 140 * Sin(a)
                            call MoveEff(e, move, a)
                            call MoveEff(e2, move, a)
                            if r2 > 0.0 then
                                set r2 = 0
                                call DecorRemove(c, x, y, aoe * 1.25, RaidenE_DecorDamage)
                                call VisionTimed(GetOwningPlayer(c), x, y, aoe * 2, 1)
                                call GroupClear(g)
                                call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                        call dmgmag(c, u, dmg)
                                        call ErzaPassive(c, u, 3)
                                        call SlowUnit(c, u, RaidenE_Slow, RaidenE_Duration)
                                        call GroupAddUnit(g2, u)
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                        call MUE(u, RaidenE_PushRange * (1 - (r / rmax)), RaidenE_PushDuration, a)
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                                set u = null
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif
                    elseif k2 == 1 then
                        if r == 0.21 then
                            set r7 = 10
                            call SetUnitVertexColor(c, 255, 255, 255, 0)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_hakkestart.mdx", x, y, GetRandomReal(0, 359), 0.75, 1.8, 5))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx", x - sr * Cos(a), y - sr * Sin(a), a * bj_RADTODEG, 1.5, 1.8, 0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_RaidenEi-7.mdl", x - sr * Cos(a), y - sr * Sin(a), a * bj_RADTODEG, 1.3, 1.325, 15))
                            set d = UnitSpawn0(GetOwningPlayer(c), Raiden_Dummy_ID, x - sr * Cos(a), y - sr * Sin(a), a * bj_RADTODEG, 2, BlzGetUnitRealField(c, UNIT_RF_SCALING_VALUE), 0)
                            call SetUnitAnimationByIndex(d, 33)
                            call SetUnitVertexColor(d, 255, 55, 255, 255)
                            call ColorDummy3(d, 0, 255, 55, 255, 0.35)
                            set d = null
                        endif
                        if (r == 0.27 or r == 0.45 or r == 0.63 or r == 0.81) and sr > 450 then
                            set sr = sr - 450
                            set d = UnitSpawn0(GetOwningPlayer(c), Raiden_Dummy_ID, x - sr * Cos(a), y - sr * Sin(a), a * bj_RADTODEG, 2, BlzGetUnitRealField(c, UNIT_RF_SCALING_VALUE), 0)
                            call SetUnitAnimationByIndex(d, 36)
                            call SetUnitVertexColor(d, 255, 55, 255, 255)
                            call ColorDummy3(d, 0, 255, 55, 255, 0.35)
                            set d = null
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx", x - sr * Cos(a), y - sr * Sin(a), a * bj_RADTODEG, 1.5, 1.8, 0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_RaidenEi-7.mdl", x - sr * Cos(a), y - sr * Sin(a), a * bj_RADTODEG, 1.3, 1.325, 15))
                        endif
                        if sr < 450 and check2 == 0 then
                            set rmax = r + 0.81
                            call EffectSpawn2("war3mapImported\\wos_raiden-trarea.mdl", x, y, 0, 2, 2.75, 155, rmax - r)
                            set check2 = 1
                            call MakeSound("war3mapimported\\Hero_Raiden_TE_1")
                        endif
                        if sr < 450 then
                            if r7 > 0.15 and r < rmax - 0.15 then
                                set r7 = 0
                                set r5 = GetRandomReal(120, aoe / 1.25)
                                set r6 = GetRandomReal(0, 359) * bj_DEGTORAD
                                set r4 = GetRandomReal(0, 359)
                                set r3 = GetRandomReal(-25, 0)
                                set rkek2 = GetRandomReal(0.85, 1.75)
                                set d = UnitSpawn0(GetOwningPlayer(c), Raiden_Dummy_ID, x + r5 * Cos(r6), y + r5 * Sin(r6), r6 * bj_DEGTORAD, rkek2, BlzGetUnitRealField(c, UNIT_RF_SCALING_VALUE), 0)
                                call SetFly(d, GetRandomReal(255, 575))
                                call SetUnitVertexColor(d, 255, 55, 255, 255)
                                set r6 = GAngle2(d, x, y) + GetRandomReal(-42.5, 42.5) * bj_DEGTORAD
                                call SetUnitFacing(c, r6 * bj_DEGTORAD)
                                set k = GetRandomInt(1, 3)
                                if k == 1 then
                                    call SetUnitAnimationByIndex(d, 18)
                                elseif k == 2 then
                                    call SetUnitAnimationByIndex(d, 19)
                                elseif k == 3 then
                                    call SetUnitAnimationByIndex(d, 20)
                                endif
                                set rkek2 = GetRandomReal(375, 575)
                                call MUE(d, rkek2, 0.21, r6)
                                call HeightSet(d, 0.21, 0)
                                call ColorDummy3(d, 0, 255, 55, 255, 0.35)
                                set d = null
                            else
                                set r7 = r7 + 0.03
                            endif
                            if r2 > 0.06 then
                                set k = 0
                                loop
                                    exitwhen k == 4
                                    set r5 = GetRandomReal(40, aoe / 2)
                                    set r6 = GetRandomReal(0, 359) * bj_DEGTORAD
                                    set r4 = GetRandomReal(0, 359)
                                    set r3 = GetRandomReal(-25, 0)
                                    set rkek = GetRandomReal(2.75, 4.75)
                                    set rkek2 = GetRandomReal(1.65, 2.55)
                                    call DestroyEffect(EffectSpawn3("war3mapImported\\wos_ld2209 (199).mdl", x + r5 * Cos(r6), y + r5 * Sin(r6), r4, rkek2, rkek, GetRandomReal(100, 350), r3))
                                    set k = k + 1
                                endloop
                                set r2 = 0
                                call DecorRemove(c, x, y, aoe, RaidenTE_DecorDamage)
                                call GroupClear(g)
                                call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                        call dmgmag(c, u, dmg)
                                        call ErzaPassive(c, u, 3)
                                        call GroupAddUnit(g2, u)
                                        call SlowUnit(c, u, RaidenE_Slow, RaidenE_Duration)
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                                set u = null
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif
                    elseif k2 == 2 then
                        if r < 0.69 then
                            call DebugUnit(c)
                        endif
                        if r == 0.36 then
                            call MakeSound("war3mapimported\\Hero_Raiden_TTE_0")
                            set e = EffectSpawn("war3mapImported\\wos_fantasybattle (804).mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG + 180, 1, 3.45, 550)
                        endif
                        if r == 0.75 then
                            call SetUnitTimeScale(c, 2.45)
                            call SetUnitAnimationByIndex(c, 8)
                            call VisionTimed(GetOwningPlayer(c), GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), aoe * 2, 2)
                            call VisionTimed(GetOwningPlayer(c), GetUnitX(c) + 450 * Cos(a), GetUnitY(c) + 450 * Sin(a), aoe * 2, 2)
                            call VisionTimed(GetOwningPlayer(c), GetUnitX(c) + 900 * Cos(a), GetUnitY(c) + 900 * Sin(a), aoe * 2, 2)
                            call VisionTimed(GetOwningPlayer(c), GetUnitX(c) + 1200 * Cos(a), GetUnitY(c) + 1200 * Sin(a), aoe * 2, 2)
                            call VisionTimed(GetOwningPlayer(c), GetUnitX(c) + 1500 * Cos(a), GetUnitY(c) + 1500 * Sin(a), aoe * 2, 2)
                            call VisionTimed(GetOwningPlayer(c), GetUnitX(c) + 1800 * Cos(a), GetUnitY(c) + 1800 * Sin(a), aoe * 2, 2)
                            call VisionTimed(GetOwningPlayer(c), GetUnitX(c) + 2100 * Cos(a), GetUnitY(c) + 2100 * Sin(a), aoe * 2, 2)
                            call VisionTimed(GetOwningPlayer(c), GetUnitX(c) + 2400 * Cos(a), GetUnitY(c) + 2400 * Sin(a), aoe * 2, 2)
                            call VisionTimed(GetOwningPlayer(c), GetUnitX(c) + 2700 * Cos(a), GetUnitY(c) + 2700 * Sin(a), aoe * 2, 2)
                            call VisionTimed(GetOwningPlayer(c), GetUnitX(c) + 3000 * Cos(a), GetUnitY(c) + 3000 * Sin(a), aoe * 2, 2)
                        endif
                        if r >= 0.75 and r < 1.06 then
                            set a2 = a2 - 9
                            call MoveEff(e, 35, a)
                            call BlzSetSpecialEffectHeight(e, BlzGetLocalSpecialEffectZ(e) - 22)
                            call BlzSetSpecialEffectPitch(e, a2 * bj_DEGTORAD)
                        endif
                        if r == 0.90 then
                            call MakeSound("war3mapimported\\Hero_Raiden_TTE_2")
                        endif
                        if r == 0.96 then
                            call DestroyEffect(e)
                            call DestroyEffect(e2)
                            call StopSpellUnit(c)
                            call SetUnitTimeScale(c, 1)
                            set x = GetUnitX(c) + 150 * Cos(a)
                            set y = GetUnitY(c) + 150 * Sin(a)
                        endif
                        if r == 1.23 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_te-leilv-diliepurple.mdl", x, y, a * bj_RADTODEG, 1.5, 1.2, 1))
                        endif
                        if r > 0.96 then
                            set x = x + move * Cos(a)
                            set y = y + move * Sin(a)
                            call EffectSpawn2("war3mapImported\\wos_mei-qsfx-4.mdl", x, y, GetRandomReal(0, 359), GetRandomReal(0.5, 1.5), 1.95, 1, 0.35)
                            if r3 > 0.09 then
                                set r3 = 0
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_YH_Shio_Ichigo_Wy_Tx_Wy_purp.mdl", x, y, a * bj_RADTODEG, 1.5, 1.1, 1))
                            else
                                set r3 = r3 + 0.03
                            endif
                            if r2 > 0.0 then
                                set r2 = 0
                                call DecorRemove(c, x, y, aoe, RaidenTTE_DecorDamage)
                                call GroupClear(g)
                                call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                        call dmgmag(c, u, dmg)
                                        call ErzaPassive(c, u, 3)
                                        call GroupAddUnit(g2, u)
                                        call SlowUnit(c, u, RaidenE_Slow, RaidenE_Duration)
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                        call MUE(u, RaidenE_PushRange * (1 - (r / rmax)), RaidenE_PushDuration, a)
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                                set u = null
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif
                    endif
                else
                    if k2 == 0 then
                        if r < RaidenE_CastTime then
                            call StopSpellUnit(c)
                        endif
                        call BlzSetSpecialEffectTimeScale(e, 2)
                        call DestroyEffect(e)
                    elseif k2 == 1 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_hakkestart.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 2.25, 0.55, 5))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.5, 1.8, 0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-trlightning2.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 15))
                        call StopSpellUnit(c)
                        call SetUnitVertexColor(c, 255, 255, 255, 255)
                    elseif k2 == 2 then
                        if r < 0.81 then
                            call StopSpellUnit(c)
                            call DestroyEffect(e)
                            call DestroyEffect(e2)
                        endif
                    endif
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set c = null
                    set g = null
                    set g2 = null
                    set e = null
                    set m_RaidenE[i] = m_RaidenE[MUI_RaidenE]
                    set MUI_RaidenE = MUI_RaidenE - 1
                    set i = i - 1
                    if MUI_RaidenE == -1 then
                        call PauseTimer(t_RaidenE)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method RaidenE_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            set MUI_RaidenE = MUI_RaidenE + 1
            set m_RaidenE[MUI_RaidenE] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set aoe = RaidenE_DamageAoe
            set move = 66
            set r5 = GetRandomReal(40, aoe / 2)
            set r6 = GetRandomReal(0, 359) * bj_DEGTORAD
            set r4 = GetRandomReal(0, 359)
            set r3 = GetRandomReal(-25, 0)
            set k2 = 0
            set a = GAngle2(c, x, y)
            call StartSpellUnit(c)
            set check2 = 0
            set g = CreateGroup()
            set g2 = CreateGroup()
            set rmax = RaidenE_CastTime + ((RaidenE_Range / move) * 0.03)
            set dmg = GetHeroAgi(c, true) * (RaidenE_DamageAgiBase + (RaidenE_DamageAgiStep * (GetUnitAbilityLevel(c, RaidenE_ID) - 1)))
            set dmg = dmg + RaidenE_Damage2StaticBase + (RaidenE_Damage2StaticStep * (GetUnitAbilityLevel(c, RaidenE_ID) - 1))

            if LoadInteger(hs, GetHandleId(c), StringHash("raiden t2")) > 0 then
                set k2 = 2
                set r3 = 0.06
                set rmax = 1.36
                set dmg = dmg + GetHeroAgi(c, true) * RaidenTTE_DamageAgiBonus
                set a2 = 0
                call MakeSound("war3mapimported\\Hero_Raiden_TTE_1")
                call SetUnitAnimationByIndex(c, 7)
                set e2 = AddSpecialEffectTarget("war3mapImported\\wos_mei-qsfx-4.mdl", c, "weapon")
                call SetUnitTimeScale(c, 2.25)
                set move = 225
            elseif LoadInteger(hs, GetHandleId(c), StringHash("raiden t")) > 0 then
                set k2 = 1
                set rmax = RaidenTE_Duration
                set dmg = dmg + GetHeroAgi(c, true) * RaidenTE_DamageAgiBonus
                call MakeSound("war3mapimported\\Hero_Raiden_TE")
                call MakeSound("war3mapimported\\Hero_Raiden_W_1")
                call SetUnitAnimationByIndex(c, 32)
                call SetUnitTimeScale(c, 0.65)
                set sr = SR3(c, x, y)
                set aoe = RaidenTE_DamageAoe
            else
                call SetUnitAnimationByIndex(c, 6)
                call SetUnitTimeScale(c, 0.65)
                call MakeSound("war3mapimported\\Hero_Raiden_E")
                call MakeSound("war3mapimported\\Hero_Raiden_W_1")
            endif

            if MUI_RaidenE == 0 then
                call TimerStart(t_RaidenE, 0.03, true, function thistype.Loop_RaidenE)
            endif
        endmethod
    endstruct

    private struct RaidenR_KS
        private static timer t_RaidenR = CreateTimer()
        private static integer array m_RaidenR
        private static integer MUI_RaidenR = -1

        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k2
        real scale
        real scale2
        real r5
        group g
        unit u
        real dmg
        real a2
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_RaidenR takes nothing returns nothing
            local integer this
            local integer i = 0

            loop
                exitwhen i > MUI_RaidenR
                set this = m_RaidenR[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if k2 == 0 then
                        call DebugUnit2(c)
                        if r == rmax then
                            call MakeSound("war3mapimported\\Hero_Raiden_R_1")
                            call StopSpellUnit2(c)
                            call DecorRemove(c, x, y, aoe, RaidenR_DecorDamage)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-trlightning2.mdl", x, y, a * bj_RADTODEG, 1, 2, 0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_purple wave explosion.mdl", x, y, a * bj_RADTODEG, 1.25, 2, 6))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_RaidenEi-8.mdl", x, y, a * bj_RADTODEG, 1, 2, 0))
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_WTW-whitethunder-Zi.mdx", x, y, a * bj_RADTODEG, 1, 4, 0), 0.3, 255, 255, 255, 0.3)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                    call dmgmag(c, u, dmg)
                                    call ErzaPassive(c, u, 3)
                                    call StunUnit(c, u, RaidenR_StunTime)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        endif
                    elseif k2 == 1 then
                        if r == 0.57 then
                            call DestroyEffect(EffectSpawnScale("war3mapImported\\wos_2-[tx]-03-01jianta (3).mdl", x, y, 1, 0.65, 0.01, 3, 0.6, 0.01, 0.8))
                        endif
                        if r == rmax then
                            call DecorRemove(c, x, y, aoe, RaidenTR_DecorDamage)
                            call StopSpellUnit(c)
                            call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_RaidenEi-18.mdl", x, y, a * bj_RADTODEG + 90, 2, 0.01, 0, 0.12, 0.01, 1.35), 0.5, 255, 255, 255, 1)
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_zsn (448)_purp.mdl", x, y, a * bj_RADTODEG + 90, 0.35, 2.75, 0), 0.5, 255, 255, 255, 1)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                    call dmgmag(c, u, dmg)
                                    call ErzaPassive(c, u, 3)
                                    call StunUnit(c, u, RaidenTR_StunTime)
                                    call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_WTW-whitethunder-Zi.mdx", GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359), 1, 4, 0), 0.3, 255, 255, 255, 0.3)
                                    call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_RaidenEi-8.mdl", GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359), 1, 1, 0), 0.3, 255, 255, 255, 0.3)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        endif
                    elseif k2 == 2 then
                        if r == 0.15 then
                            call MakeSound("war3mapimported\\Hero_Raiden_TT_R_1")
                            call ScaleEffDummy(EffectSpawn2("war3mapImported\\wos_raidenei-4.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1, 0, 0.6), 0.65, 1, 2)
                        endif
                        if r == 0.60 then
                            call MakeSound("war3mapimported\\Hero_Raiden_TT_R_2")
                        endif
                        if r < 1.20 then
                            set x = GetMouseX(GetOwningPlayer(c))
                            set y = GetMouseY(GetOwningPlayer(c))
                            if r2 > 0.21 then
                                set r2 = 0
                                call VisionTimed(GetOwningPlayer(c), x, y, aoe * 2, 1)
                            else
                                set r2 = r2 + 0.03
                            endif
                            set a = GAngle4(x1, y1, x, y)
                            if SR0(x1, y1, x, y) > scale2 then
                                set x = x1 + scale2 * Cos(a)
                                set y = y1 + scale2 * Sin(a)
                            endif
                            if SR5(e, x, y) > move then
                                call MoveEff(e, move, GAngle5(e, x, y))
                            else
                                call BlzSetSpecialEffectPosition(e, x, y, 3)
                            endif
                        endif
                        if r == 1.20 then
                            set x = GetEffX(e)
                            set y = GetEffY(e)
                            set a = GAngle2(c, x, y)
                            call SetUnitFacing(c, a * bj_DEGTORAD)
                            call PosUnit(c, x - 750 * Cos(a), y - 750 * Sin(a))
                            set e2 = EffectSpawn3_2("war3mapImported\\wos_RaidenEi-18.mdl", GetUnitX(c) - 70 * Cos(a), GetUnitY(c) - 70 * Sin(a), a * bj_RADTODEG - 90, 0.35, 0.01, 255, -90)
                            call ScaleEffDummy(e2, 0.3, 0.01, 0.9)
                            call ScaleEffDummy2(e2, 0.9, 0.3, 1, 0.01)
                            call ColorEffDummy3(e2, 0.9, 255, 255, 255, 0.51)
                            call ScaleEffDummy(EffectSpawn2("war3mapImported\\wos_raidenei-4.mdl", GetUnitX(c) + 65 * Cos(a), GetUnitY(c) + 65 * Sin(a), a * bj_RADTODEG, 2, 2, 130, 0.7), 0.21, 1, 2.15)
                        endif
                        if r == 1.32 then
                            call SetUnitAnimationByIndex(c, 4)
                            call SetUnitTimeScale(c, 2.7)
                        endif
                        if r == 1.74 then
                            set a2 = 225 * bj_DEGTORAD
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_raiden-esfx-5.mdl", x - 400 * Cos(a), y - 400 * Sin(a), a * bj_RADTODEG + 30, 0.75, 1.4, 80))
                        endif
                        if r == 1.80 or r == 1.83 or r == 1.86 or r == 1.89 or r == 1.92 then
                            set a2 = a2 - 65 * bj_DEGTORAD
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_RaidenEi-8.mdl", x + 545 * Cos(a - a2), y + 545 * Sin(a - a2), GetRandomReal(0, 359), 1, 1.6, 0), 0.3, 255, 255, 255, 0.3)
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_energyburstb.mdx", x + 545 * Cos(a - a2), y + 545 * Sin(a - a2), GetRandomReal(0, 359), 1, 5.5, 0), 0.3, 255, 255, 255, 0.3)
                        endif
                        if r == rmax then
                            call MakeSound("war3mapimported\\Hero_Raiden_TT_R_3")
                            call StopSpellUnit(c)
                            call DecorRemove(c, x, y, aoe, RaidenTTR_DecorDamage)
                            call VisionTimed(GetOwningPlayer(c), x, y, aoe * 2, 2)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                    call dmgmag(c, u, dmg)
                                    call ErzaPassive(c, u, 3)
                                    call StunUnit(c, u, RaidenTTR_StunTime)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        endif
                    endif
                else
                    if k2 == 0 then
                        call StopSpellUnit2(c)
                    else
                        if k2 == 2 then
                            call MouseOff(GetOwningPlayer(c))
                            call SetUnitAnimation(c, "stand")
                        endif
                        call StopSpellUnit(c)
                    endif
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("raiden tt r"), 0)
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.21)
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set e = null
                    set m_RaidenR[i] = m_RaidenR[MUI_RaidenR]
                    set MUI_RaidenR = MUI_RaidenR - 1
                    set i = i - 1
                    if MUI_RaidenR == -1 then
                        call PauseTimer(t_RaidenR)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method RaidenR_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            set MUI_RaidenR = MUI_RaidenR + 1
            set m_RaidenR[MUI_RaidenR] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set k2 = 0
            set aoe = RaidenR_DamageAoe
            set a = GAngle2(c, x, y)
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set rmax = RaidenR_CastTime
            set dmg = GetHeroAgi(c, true) * (RaidenR_DamageAgiBase + (RaidenR_DamageAgiStep * (GetUnitAbilityLevel(c, RaidenR_ID) - 1)))
            set dmg = dmg + RaidenR_Damage2StaticBase + (RaidenR_Damage2StaticStep * (GetUnitAbilityLevel(c, RaidenR_ID) - 1))

            if LoadInteger(hs, GetHandleId(c), StringHash("raiden t2")) > 0 then
                set k2 = 2
                call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("raiden tt r x"), x)
                call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("raiden tt r y"), y)
                set MouseX[GetPlayerId(GetOwningPlayer(c))] = x
                set MouseY[GetPlayerId(GetOwningPlayer(c))] = y
            elseif LoadInteger(hs, GetHandleId(c), StringHash("raiden t")) > 0 then
                set k2 = 1
            endif

            set scale2 = 0
            set scale = 2.3
            set x1 = GetUnitX(c)
            set y1 = GetUnitY(c)

            if k2 == 2 then
                set dmg = dmg + GetHeroAgi(c, true) * RaidenTTR_DamageAgiBonus
                set move = 150
                call MouseOn(GetOwningPlayer(c))
                set MouseX[GetPlayerId(GetOwningPlayer(c))] = x
                set MouseY[GetPlayerId(GetOwningPlayer(c))] = y
                call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("raiden tt r"), 1)
                set scale = 2.5
                set scale2 = 1800
                set r5 = 0.3
                set rmax = RaidenTTR_CastTime
                set aoe = aoe * 1.15
                call StartSpellUnit(c)
                call SetUnitAnimationByIndex(c, 3)
                call SetUnitTimeScale(c, 3.75)
                call MakeSound("war3mapimported\\Hero_Raiden_TT_R_0")
                call MakeSound("war3mapimported\\Hero_Raiden_TT R")
            elseif k2 == 0 then
                set r5 = rmax - 0.18
                call SetUnitAnimationByIndex(c, 7)
                call SetUnitTimeScale(c, 0.45)
                call MakeSound("war3mapimported\\Hero_Raiden_R")
                call MakeSound("war3mapimported\\Hero_Raiden_W_1")
            else
                set scale = 2.5
                call StartSpellUnit(c)
                set aoe = aoe * 1
                set dmg = dmg + GetHeroAgi(c, true) * RaidenTR_DamageAgiBonus
                call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_raiden-trarea.mdl", x, y, a * bj_RADTODEG + 90, 1.5, 0.01, 0, rmax - 0.21, 0.01, 2.75), rmax, 255, 255, 255, 0.21)
                set rmax = RaidenTR_CastTime
                set r5 = rmax - 0.18
                call MakeSound("war3mapimported\\Hero_Raiden_TR")
                call MakeSound("war3mapimported\\Hero_Raiden_TR_2")
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_hakkestart.mdx", x, y, GetRandomReal(0, 359), 0.45, 2.1, 5))
                call SetUnitAnimationByIndex(c, 11)
                call SetUnitTimeScale(c, 1)
            endif

            call VisionTimed(GetOwningPlayer(c), x, y, aoe * 2, 2)
            if k2 == 2 then
                set e = EffectSpawn("war3mapImported\\wos_lightning circle.mdl", x1, y1, 1, 1, 0.01, 3)
            else
                set e = EffectSpawn("war3mapImported\\wos_lightning circle.mdl", x, y, 1, 1, 0.01, 3)
            endif
            call ScaleEffDummy(e, r5, 0.01, scale)
            if MUI_RaidenR == 0 then
                call TimerStart(t_RaidenR, 0.03, true, function thistype.Loop_RaidenR)
            endif
        endmethod
    endstruct

    private struct RaidenT_KS
        private static timer t_RaidenT = CreateTimer()
        private static integer array m_RaidenT
        private static integer MUI_RaidenT = -1

        unit c
        real x
        real y
        integer k2
        integer k3
        integer check
        integer check2
        real r
        effect e
        effect e2
        real rmax

        private static method Loop_RaidenT takes nothing returns nothing
            local integer this
            local integer i = 0

            loop
                exitwhen i > MUI_RaidenT
                set this = m_RaidenT[i]
                if SpellBoolCaster(c) and r <= rmax and not CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) then
                    if check == 0 or not IsUnitPaused(c) then
                        set r = r + 0.05
                    endif
                    set r = S2R(R2SW(r, 0, 3))
                    if check == 0 then
                        if r == 0.25 then
                            call MakeSound("war3mapimported\\Hero_Raiden_T_1")
                        endif
                        call DebugUnit2(c)
                        if r == rmax then
                            set r = 0
                            set rmax = RaidenT_Duration
                            call AddUnitAnimationProperties(c, "alternate", true)
                            call SetUnitTimeScale(c, 1)
                            set check = 1
                            call FixAura(c)

                            // Переключение тултипов на Форму 1 (Musou Shinsetsu)
                            call AAUniversalTooltips_SetUnitForm(c, 1)

                            if frame2_pas1[k2] == null then
                                set frame2_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.2175)
                                call BlzFrameSetSize(frame2_pas1[k2], 0.135, 0.035)
                                call BlzFrameSetTexture(frame2_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                                call BlzFrameSetVisible(frame2_pas1[k2], false)
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame2_pas1[k2], true)
                                endif
                                set frame2_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame2_pas1[k2], 0, 0)
                                call BlzFrameSetAbsPoint(frame2_pas2[k2], FRAMEPOINT_CENTER, 0.07, 0.2225)
                                call BlzFrameSetSize(frame2_pas2[k2], 0.1, 0.019)
                                set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)
                                call BlzFrameSetSize(frame2_pas3[k2], 0.1, 0.035)
                                call BlzFrameSetScale(frame2_pas3[k2], 0.5)
                                call BlzFrameSetModel(frame2_pas3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                                call BlzFrameSetAbsPoint(frame2_pas3[k2], FRAMEPOINT_CENTER, 0.05, 0.2125)
                                call BlzFrameSetMinMaxValue(frame2_pas3[k2], 0, rmax)
                                call BlzFrameSetValue(frame2_pas3[k2], rmax)
                                set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.2175)
                                call BlzFrameSetSize(frame2_pas4[k2], 0.03, 0.03)
                                call BlzFrameSetTexture(frame2_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Raiden_T", 0, false)
                                set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.2225)
                                call BlzFrameSetText(frame2_pas5[k2], "|c00FFFF00" + "Musou Shinsetsu:" + "|r")
                                call BlzFrameSetScale(frame2_pas5[k2], 0.8)
                                set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.2075)
                                call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                                call BlzFrameSetScale(frame2_pas6[k2], 0.9)
                            else
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame2_pas1[k2], true)
                                endif
                                call BlzFrameSetMinMaxValue(frame2_pas3[k2], 0, rmax)
                                call BlzFrameSetValue(frame2_pas3[k2], rmax)
                            endif

                            if GetHeroLevel(c) >= 35 then
                                call SetPlayerAbilityAvailable(GetOwningPlayer(c), RaidenTT_ID, true)
                                call SetPlayerAbilityAvailable(GetOwningPlayer(c), RaidenT_ID, false)
                                call UnitAddAbility(c, RaidenTT_ID)
                            endif
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-trlightning2.mdl", x, y, 1, 1, 1.25, 1))
                            call EffectSpawn2("war3mapImported\\wos_mei-qsfx-4.mdl", x, y, 1, 1, 2.25, 35, 0.5)
                            call EffectSpawn2("war3mapImported\\wos_raiden-trarea.mdl", x, y, 1, 1, 1.25, 135, 0.5)
                            call DestroyEffect(e)
                            set e = null
                            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_JY-Shio_Super_Saiyan_JN_Zi.mdl", c, "origin")
                            call StopSpellUnit2(c)
                            call BlzSetUnitWeaponIntegerField(c, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0, check2 + RaidenT_AdditionalDmg)
                            call BlzSetUnitWeaponIntegerField(c, UNIT_WEAPON_IF_ATTACK_ATTACK_TYPE, 0, 4)
                            call UnitAddAbility(c, RaidenT_AS)
                        endif
                    elseif check == 1 then
                        if k3 == 0 and LoadInteger(hs, GetHandleId(c), StringHash("raiden t2")) == 1 then
                            set k3 = 1
                            call BlzFrameSetTexture(frame2_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Raiden_TT", 0, false)
                            set rmax = rmax + RaidenTT_AddDuration
                            call BlzFrameSetMinMaxValue(frame2_pas3[k2], 0, rmax)
                        endif
                        call BlzFrameSetValue(frame2_pas3[k2], rmax - (r + 0.1))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                    endif
                else
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame2_pas1[k2], false)
                    endif
                    call DestroyEffect(e)
                    if check == 0 then
                        call StopSpellUnit2(c)
                    else
                        if GetHeroLevel(c) >= 35 then
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), RaidenTT_ID, false)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), RaidenT_ID, true)
                        endif
                        call UnitRemoveAbility(c, RaidenT_AS)
                        call DestroyEffect(e2)
                        if LoadInteger(hs, GetHandleId(c), StringHash("raiden t2")) > 0 then
                            call SaveInteger(hs, GetHandleId(c), StringHash("raiden t2"), 0)
                            call BlzSetUnitSkin(c, Raiden_ID)
                        endif
                        call BlzSetAbilityIcon(Raiden_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Raiden_Icon.blp")
                        call BlzSetUnitWeaponIntegerField(c, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0, check2)
                        call AddUnitAnimationProperties(c, "alternate", false)
                        call BlzSetUnitWeaponIntegerField(c, UNIT_WEAPON_IF_ATTACK_ATTACK_TYPE, 0, 6)
                        call FixAura(c)
                    endif
                    call AddUnitAnimationProperties(c, "alternate", false)
                    call SaveInteger(hs, GetHandleId(c), StringHash("raiden t"), 0)
                    call FixAura(c)

                    // Сброс тултипов обратно в форму 0
                    call AAUniversalTooltips_SetUnitForm(c, 0)

                    set c = null
                    set e = null
                    set e2 = null
                    set m_RaidenT[i] = m_RaidenT[MUI_RaidenT]
                    set MUI_RaidenT = MUI_RaidenT - 1
                    set i = i - 1
                    if MUI_RaidenT == -1 then
                        call PauseTimer(t_RaidenT)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method RaidenT_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_RaidenT = MUI_RaidenT + 1
            set m_RaidenT[MUI_RaidenT] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set check2 = BlzGetUnitWeaponIntegerField(c, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0)
            set check = 0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set k3 = 0
            call StartSpellUnit2(c)
            set rmax = RaidenT_CastTime
            call SetUnitAnimationByIndex(c, 10)
            call SetUnitTimeScale(c, 3.5)
            call ReduceCooldown(c, RaidenW_ID, RaidenTT_RemoveCd)
            call ReduceCooldown(c, RaidenE_ID, RaidenTT_RemoveCd)
            call ReduceCooldown(c, RaidenR_ID, RaidenTT_RemoveCd)
            set e = EffectSpawn("war3mapImported\\wos_Opdef (429).mdl", x, y, 1, 1, 1.35, 1)
            call EffectSpawn2("war3mapImported\\wos_mei-qsfx-4.mdl", x, y, 1, 1, 2.25, 35, 1)
            call EffectSpawn2("war3mapImported\\wos_raiden-trarea.mdl", x, y, 1, 1, 1.25, 135, 1)
            call MakeSound("war3mapimported\\Hero_Raiden_T")
            call SaveInteger(hs, GetHandleId(c), StringHash("raiden t"), 1)
            if MUI_RaidenT == 0 then
                call TimerStart(t_RaidenT, 0.05, true, function thistype.Loop_RaidenT)
            endif
        endmethod
    endstruct

    private struct RaidenT2_KS
        private static timer t_RaidenT2 = CreateTimer()
        private static integer array m_RaidenT2
        private static integer MUI_RaidenT2 = -1

        unit c
        real x
        real y
        integer check
        real r
        effect e
        real a
        real rmax

        private static method Loop_RaidenT2 takes nothing returns nothing
            local integer this
            local integer i = 0

            loop
                exitwhen i > MUI_RaidenT2
                set this = m_RaidenT2[i]
                if SpellBoolCaster(c) and r <= rmax and not CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) then
                    set r = r + 0.05
                    set r = S2R(R2SW(r, 0, 3))
                    if check == 0 then
                        if r == 0.05 then
                            call HeightSet(c, 0.6, 250)
                        endif
                        if r == 0.25 then
                            call MakeSound("war3mapimported\\Hero_Raiden_T_1")
                        endif
                        call DebugUnit2(c)
                        if r == 0.55 then
                            call ScaleEffDummy(EffectSpawn2("war3mapImported\\wos_raidenei-4.mdl", x, y, a * bj_RADTODEG, 2, 1, 0, 0.56), 0.42, 1, 6)
                        endif
                        if r == 0.65 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_1.mdl", x, y, a * bj_RADTODEG, 1.25, 1.2, 375))
                        endif
                        if r == 0.75 then
                            call SaveInteger(hs, GetHandleId(c), StringHash("raiden t cast"), 0)
                            call BlzSetUnitSkin(c, Raiden_Morph_ID)
                            call BlzSetAbilityIcon(Raiden_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Raiden_Icon2.blp")
                            call BlzSetAbilityIcon(Raiden_Morph_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Raiden_Icon2.blp")
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-trlightning2.mdl", x, y, 1, 1, 1.25, 1))
                            call EffectSpawn2("war3mapImported\\wos_mei-qsfx-4.mdl", x, y, 1, 1, 2.25, 35, 0.5)
                            call EffectSpawn2("war3mapImported\\wos_raiden-trarea.mdl", x, y, 1, 1, 1.25, 135, 0.5)
                            call DestroyEffect(e)
                            set e = null
                            call SaveInteger(hs, GetHandleId(c), StringHash("raiden t2"), 1)
                            call StopSpellUnit2(c)
                            call HeightSet(c, 0.35, 0)
                            call FixAura(c)

                            // Переключение тултипов на Форму 2 (True God)
                            call AAUniversalTooltips_SetUnitForm(c, 2)
                        endif
                    endif
                else
                    call SaveInteger(hs, GetHandleId(c), StringHash("raiden t cast"), 0)
                    call StopSpellUnit2(c)
                    call DestroyEffect(e)
                    set c = null
                    set e = null
                    set m_RaidenT2[i] = m_RaidenT2[MUI_RaidenT2]
                    set MUI_RaidenT2 = MUI_RaidenT2 - 1
                    set i = i - 1
                    if MUI_RaidenT2 == -1 then
                        call PauseTimer(t_RaidenT2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method RaidenT2_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_RaidenT2 = MUI_RaidenT2 + 1
            set m_RaidenT2[MUI_RaidenT2] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set check = 0
            call StartSpellUnit2(c)
            set rmax = RaidenTT_CastTime
            call SetUnitAnimationByIndex(c, 10)
            call SetUnitTimeScale(c, 0.365)
            call AnimDummy(c, 0.75, 2.5)
            call BlzStartUnitAbilityCooldown(c, RaidenQ_ID, 0.01)
            call ReduceCooldown(c, RaidenW_ID, RaidenTT_RemoveCd)
            call ReduceCooldown(c, RaidenE_ID, RaidenTT_RemoveCd)
            call ReduceCooldown(c, RaidenR_ID, RaidenTT_RemoveCd)
            set e = EffectSpawn("war3mapImported\\wos_Opdef (429).mdl", x, y, 1, 1, 1.35, 1)
            call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_Raiden-17.mdl", x, y, 1, 1, 0.01, 1, 1.1, 0.01, 7.45), 0.9, 255, 255, 255, 0.51)
            call EffectSpawn2("war3mapImported\\wos_mei-qsfx-4.mdl", x, y, 1, 1, 2.25, 35, 2)
            call EffectSpawn2("war3mapImported\\wos_raiden-trarea.mdl", x, y, 1, 1, 1.45, 135, 2)
            call MakeSound("war3mapimported\\Hero_Raiden_TT_0")
            call MakeSound("war3mapimported\\Hero_Raiden_TT_1")
            call SaveInteger(hs, GetHandleId(c), StringHash("raiden t2"), 1)
            call SaveInteger(hs, GetHandleId(c), StringHash("raiden t cast"), 1)
            if MUI_RaidenT2 == 0 then
                call TimerStart(t_RaidenT2, 0.05, true, function thistype.Loop_RaidenT2)
            endif
        endmethod
    endstruct

    private struct RaidenPas_KS
        private static timer t_RaidenPas = CreateTimer()
        private static integer array m_RaidenPas
        private static integer MUI_RaidenPas = -1

        unit c
        real x
        real y
        real r2
        real scale
        real fly
        real r
        effect e
        real a
        real rmax

        private static method Loop_RaidenPas takes nothing returns nothing
            local integer this
            local integer i = 0

            loop
                exitwhen i > MUI_RaidenPas
                set this = m_RaidenPas[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    set r = S2R(R2SW(r, 0, 3))
                    set a = GetUnitFacing(c)
                    set x = GetUnitX(c) + 15 * Cos(a * bj_DEGTORAD)
                    set y = GetUnitY(c) + 15 * Sin(a * bj_DEGTORAD)
                    call BlzSetSpecialEffectPosition(e, x, y, fly)
                    call BlzSetSpecialEffectYaw(e, a * bj_DEGTORAD)
                    if LoadInteger(hs, GetHandleId(c), StringHash("raiden t2")) == 1 then
                        set fly = 25
                        set scale = 2.65
                    else
                        set fly = 15
                        set scale = 1.45
                    endif
                    call BlzSetSpecialEffectScale(e, scale)
                    if r2 > 0.90 then
                        call SetMpCurrent(c, ((RaidenW_ManaRestore / 100.0) * GetUnitState(c, UNIT_STATE_MAX_MANA)) / rmax)
                        set r2 = 0
                    else
                        set r2 = r2 + 0.03
                    endif
                else
                    call DestroyEffect(e)
                    set c = null
                    set e = null
                    set m_RaidenPas[i] = m_RaidenPas[MUI_RaidenPas]
                    set MUI_RaidenPas = MUI_RaidenPas - 1
                    set i = i - 1
                    if MUI_RaidenPas == -1 then
                        call PauseTimer(t_RaidenPas)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method RaidenPas_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_RaidenPas = MUI_RaidenPas + 1
            set m_RaidenPas[MUI_RaidenPas] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set r2 = 0
            if LoadInteger(hs, GetHandleId(c), StringHash("raiden t2")) == 1 then
                set fly = 25
                set scale = 2.65
            else
                set fly = 15
                set scale = 1.45
            endif
            set rmax = RaidenW_ManaRestoreSec
            set a = GetUnitFacing(c)
            set e = EffectSpawn("war3mapImported\\wos_ZK_Divine ring333.mdl", x, y, a, 1, scale, fly)
            if MUI_RaidenPas == 0 then
                call TimerStart(t_RaidenPas, 0.03, true, function thistype.Loop_RaidenPas)
            endif
        endmethod
    endstruct

    function RaidenPas_Start takes unit c returns nothing
        if IntegerCd(c, "raiden pas", RaidenW_ManaRestoreCd) then
            call RaidenPas_KS.RaidenPas_Start(c)
        endif
    endfunction

    function RaidenQ_Start takes unit c, real x, real y returns nothing
        call RaidenQ_KS.RaidenQ_Start(c, x, y)
    endfunction

    function RaidenW_Strike_Start takes unit c, unit td, integer typeatk returns nothing
        local real x = GetUnitX(td)
        local real y = GetUnitY(td)
        local real a = GetRandomReal(0, 359)
        local real dmg = GetHeroAgi(c, true) * (RaidenW_DamageAgiBase + (RaidenW_DamageAgiStep * (GetUnitAbilityLevel(c, RaidenW_ID) - 1)))

        if IntegerCd(c, "raiden w cd", 0.15) then
            set dmg = dmg + RaidenW_Damage2StaticBase + (RaidenW_Damage2StaticStep * (GetUnitAbilityLevel(c, RaidenW_ID) - 1))
            call EUTU2(EffectSpawn("war3mapImported\\wos_ld2209 (199).mdl", x, y, a, 0.85, 2.5, 90), 0.36, 90, td)
            if typeatk == 0 then
                call EUTU2(EffectSpawn("war3mapImported\\wos_mei-rsfx-6.mdl", x, y, a, 1.25, 1.45, 100), 0.36, 100, td)
                call EUTU2(EffectSpawn("war3mapImported\\wos_mh_tx-ba-symh-hit11Purple.mdl", x, y, a, 2, 1.0, 1), 0.36, 1, td)
            endif
            call NextDmg(c, td, dmg, 0, 0.1)
            call StartSound(gg_snd_Hero_Raiden_W_1)
        endif
    endfunction

    function RaidenF_Start takes unit c, unit td returns nothing
        local real a = GAngle(c, td)
        local real x = GetUnitX(td)
        local real y = GetUnitY(td)
        call RemoveUnit(Raiden_F_Dummy)
        set Raiden_F_Dummy = null
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-trlightning2.mdl", x, y, a * bj_RADTODEG, 1, 1, 0))
        call BlinkEff(c)
        call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_WTW-whitethunder-Zi.mdx", x, y, a * bj_RADTODEG, 1, 1, 0), 0.3, 255, 255, 255, 0.3)
        call SlowUnit(c, td, RaidenF_Slow, RaidenF_SlowDuration)
        call SetUnitPosition(c, GetUnitX(td) - 100 * Cos(a), GetUnitY(td) - 100 * Sin(a))
        call BlzSetUnitFacingEx(c, GAngle(c, td) * bj_RADTODEG)
        call IssueTargetOrder(c, "attack", td)
        call BlinkEff2(c)
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_purple wave explosion.mdl", x, y, a * bj_RADTODEG, 1.25, 1, 6))
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_RaidenEi-8.mdl", x, y, a * bj_RADTODEG, 1, 1, 0))
    endfunction

    function RaidenW_Start takes unit c returns nothing
        if LoadInteger(hs, GetHandleId(c), StringHash("raiden t")) > 0 then
            call RaidenTW_KS.RaidenTW_Start(c)
        else
            call RaidenW_KS.RaidenW_Start(c, c)
        endif
        call RaidenPas_Start(c)
    endfunction

    function RaidenE_Start takes unit c, real x, real y returns nothing
        call RaidenE_KS.RaidenE_Start(c, x, y)
    endfunction

    function RaidenR_Start takes unit c, real x, real y returns nothing
        call RaidenR_KS.RaidenR_Start(c, x, y)
    endfunction

    function RaidenT_Start takes unit c returns nothing
        call RaidenT_KS.RaidenT_Start(c)
    endfunction

    function RaidenTT_Start takes unit c returns nothing
        call RaidenT2_KS.RaidenT2_Start(c)
    endfunction
endlibrary