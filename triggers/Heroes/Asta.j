library AstaSpells initializer InitAstaSpells uses GearSystems
    globals
        private timer AstaTimer03
        private code AstaTimer03Callback
        private integer AstaTimer03Users = 0
        private timer AstaTimer05
        private code AstaTimer05Callback
        private integer AstaTimer05Users = 0

//--------------------------------------Asta Core---------------------------------------------------------
        integer Asta_ID = 'H028'
        integer AstaSword_ID = 'A0DW'
        integer AstaSword2_ID = 'A0DX'
        framehandle array frameAsta_pas1 [12]
        framehandle array frameAsta_pas2 [12]
        framehandle array frameAsta_pas3 [12]
        framehandle array frameAsta_pas4 [12]
        framehandle array frameAsta_pas5 [12]
        framehandle array frameAsta_pas6 [12]

//---------------Q ability (Demon-Slayer Sword - Black Slash)-------------------
        integer AstaQ_ID = 'A0DL'
        real AstaQ_DamageAgiBase = 1.0
        real AstaQ_DamageAgiStep = 1.0
        real AstaQ_Damage2StaticBase = 150.0
        real AstaQ_Damage2StaticStep = 0.0
        real AstaQ_DamageAoe = 350.0
        real AstaQ_DamageAoe2 = 450.0
        real AstaQ_RangeBase = 1400.0
        real AstaQ_RangeStep = 0.0
        real AstaQ_TimeSwap = 4.0
        real AstaTQ_AoeBonus = 35.0 // %
        real AstaTQ_DmgBonus = 1.0  // x Agi
        real AstaQ_CastTime = 0.45
        real AstaQ_Duration = 1.65
        boolean AstaQ_IsInvul = false
        real AstaQ_DecorDamage = 20.0
        real AstaQ_DecorExpDamage = 40.0

//---------------Q2 ability (Demon-Dweller Sword - Double Slash)----------------
        integer AstaQ2_ID = 'A0DS'
        real AstaQ2_DamageAgiBase = 2.0
        real AstaQ2_DamageAgiStep = 0.0
        real AstaQ2_Damage2StaticBase = 0.0
        real AstaQ2_Damage2StaticStep = 0.0
        real AstaQ2_DamageAoe = 350.0
        real AstaQ2_DamageAoe2 = 450.0
        real AstaQ2_RangeBase = 1450.0
        real AstaQ2_RangeStep = 0.0
        real AstaQ2_CastTime = 0.60
        real AstaQ2_Duration = 1.65
        boolean AstaQ2_IsInvul = false
        real AstaQ2_DecorDamage = 20.0
        real AstaQ2_DecorExpDamage = 40.0

//---------------W ability (Bull Thrust - High Speed Rush)---------------------
        integer AstaW_ID = 'A0DM'
        real AstaW_DamageAgiBase = 1.0
        real AstaW_DamageAgiStep = 1.0
        real AstaW_Damage2StaticBase = 200.0
        real AstaW_Damage2StaticStep = 0.0
        real AstaW_DamageAoe = 265.0
        real AstaW_DamageAoe2 = 455.0
        real AstaW_RangeBase = 1300.0
        real AstaW_RangeStep = 100.0
        real AstaW_PushRange = 400.0
        real AstaW_PushDuration = 0.15
        real AstaW_Stun = 0.0
        real AstaW_TimeSwap = 3.0
        real AstaW_Range = 1450.0
        real AstaTW_DmgBonus = 1.0 // x Agi
        real AstaW_CastTime = 0.30
        real AstaW_Duration = 1.70
        boolean AstaW_IsInvul = false
        real AstaW_DecorDamage = 25.0

//---------------W2 ability (Black Hurricane / Intercept)-----------------------
        integer AstaW2_ID = 'A0DT'
        real AstaW2_DamageAgiBase = 2.0
        real AstaW2_DamageAgiStep = 0.0
        real AstaW2_Damage2StaticBase = 0.0
        real AstaW2_Damage2StaticStep = 0.0
        real AstaW2_DamageAoe = 265.0
        real AstaW2_Stun = 1.0
        real AstaW2_DamageAoe2 = 455.0
        real AstaW2_CastTime = 0.45
        real AstaW2_Duration = 1.55
        boolean AstaW2_IsInvul = false
        real AstaW2_DecorDamage = 50.0

//---------------E ability (Black Spiral - Whirlwind Stance)--------------------
        integer AstaE_ID = 'A0DN'
        real AstaE_DamageStatic = 50.0
        real AstaE_DamageAgiBase = 0.5
        real AstaE_DamageAgiStep = 0.3
        real AstaE_DamageAoe = 385.0
        real AstaE_DamageAoe2 = 475.0
        real AstaE_RangeBase = 1300.0
        real AstaE_RangeStep = 10.0
        real AstaTE_AoeBonus = 35.0      // %
        real AstaE_35_bonuspeed = 50.0   // %
        real AstaE_CastTime = 0.00
        real AstaE_Duration = 2.10
        real AstaE_Interval = 0.15
        boolean AstaE_IsInvul = false
        real AstaE_DecorDamage = 20.0

//---------------R ability (Black Meteorite - Targeted Rush)-------------------
        integer AstaR_ID = 'A0DO'
        real AstaR_DamageAoe = 275.0
        real AstaR_PushRange = 300.0
        real AstaR_PushDuration = 0.30
        real AstaR_DamageAgiBase = 3.0
        real AstaR_DamageAgiStep = 1.0
        real AstaR_CastTime = 0.30
        real AstaR_Duration = 1.70
        boolean AstaR_IsInvul = true
        real AstaR_DecorDamage = 50.0

//---------------R2 ability (Black Divider Strike - Demon Execution)-----------
        integer AstaR2_ID = 'A0DU'
        real AstaR2_DamageAoe = 475.0
        real AstaR2_Silence = 1.0
        real AstaR2_DamageAgiBase = 8.0
        real AstaR2_DamageAgiStep = 0.0
        real AstaR2_CastTime = 1.20
        real AstaR2_Duration = 0.00
        boolean AstaR2_IsInvul = true
        real AstaR2_DecorDamage = 100.0

//---------------T ability (Black Divider - Demon Form)------------------------
        integer AstaT_ID = 'A0DP'
        integer AstaT2_ID = 'A0DV'
        real AstaT_Duration = 20.0
        real AstaT_CastTime = 0.00
        boolean AstaT_IsInvul = false
        real AstaT_DecorDamage = 50.0

//---------------T2 ability (Black Meteorite - Cataclysm Slam)-----------------
        real AstaT2_Stun = 0.0
        real AstaT2_DamageAgiBase = 10.0
        real AstaT2_DamageAoe = 1000.0
        real AstaT2_CastTime = 1.20
        real AstaT2_Duration = 0.00
        boolean AstaT2_IsInvul = true
        real AstaT2_DecorDamage = 100.0

//---------------G ability (Anti-Magic Constitution)---------------------------
        integer AstaG_ID = 'A0DQ'
        real AstaG_MagRes6 = 4.0
        real AstaG_MagRes12 = 8.0
        real AstaG_MagRes25 = 12.0
        real AstaG_MagRes35 = 16.0

//---------------F ability (Anti-Magic Zone - Barrier Purge)-------------------
        integer AstaF_ID = 'A0DR'
        real AstaF_AoE = 1000.0
        real AstaF_ManaSteal = 8.0 // % of max mana
        real AstaF_Duration = 2.0
        real AstaF_CastTime = 0.00
        boolean AstaF_IsInvul = false
        real AstaF_Interval = 0.18
    endglobals

    //===========================================================================
    // Модуль отслеживания приказов (Order Tracking & Animation Restore)
    //===========================================================================
    private function OnAstaPointOrder takes nothing returns boolean
        local unit u = GetOrderedUnit()
        local integer ord = GetIssuedOrderId()
        if GetUnitTypeId(u) == Asta_ID then
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

    private function OnAstaTargetOrder takes nothing returns boolean
        local unit u = GetOrderedUnit()
        local integer ord = GetIssuedOrderId()
        if GetUnitTypeId(u) == Asta_ID then
            if ord == 851971 or ord == 851983 then
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_mode"), 2)
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_id"), ord)
                call SaveUnitHandle(hs, GetHandleId(u), StringHash("ord_target"), GetOrderTargetUnit())
            endif
        endif
        set u = null
        return false
    endfunction

    private function OnAstaImmediateOrder takes nothing returns boolean
        local unit u = GetOrderedUnit()
        local integer ord = GetIssuedOrderId()
        if GetUnitTypeId(u) == Asta_ID then
            if ord == 851972 or ord == 851993 then
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_mode"), 0)
            endif
        endif
        set u = null
        return false
    endfunction

    function Asta_RestoreOrder takes unit c, integer animIndex returns nothing
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

        call SetUnitAnimationByIndex(c, animIndex)
        call SetAnimIndex(c, 0.03, animIndex)
    endfunction

    private struct AstaOrderInit extends array
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
            call TriggerAddCondition(tPoint, Condition(function OnAstaPointOrder))
            call TriggerAddCondition(tTarget, Condition(function OnAstaTargetOrder))
            call TriggerAddCondition(tImmediate, Condition(function OnAstaImmediateOrder))
        endmethod
    endstruct

    //===========================================================================
    // Управление глобальными таймерами
    //===========================================================================
    private function AstaTimer03Acquire takes nothing returns nothing
        set AstaTimer03Users = AstaTimer03Users + 1
        if AstaTimer03Users == 1 then
            call TimerStart(AstaTimer03, 0.03, true, AstaTimer03Callback)
        endif
    endfunction

    private function AstaTimer03Release takes nothing returns nothing
        set AstaTimer03Users = AstaTimer03Users - 1
        if AstaTimer03Users <= 0 then
            set AstaTimer03Users = 0
            call PauseTimer(AstaTimer03)
        endif
    endfunction

    private function AstaTimer05Acquire takes nothing returns nothing
        set AstaTimer05Users = AstaTimer05Users + 1
        if AstaTimer05Users == 1 then
            call TimerStart(AstaTimer05, 0.05, true, AstaTimer05Callback)
        endif
    endfunction

    private function AstaTimer05Release takes nothing returns nothing
        set AstaTimer05Users = AstaTimer05Users - 1
        if AstaTimer05Users <= 0 then
            set AstaTimer05Users = 0
            call PauseTimer(AstaTimer05)
        endif
    endfunction

    //===========================================================================
    // Структуры способностей
    //===========================================================================
    private struct AstaSpells_Q
        private static integer array m_AstaQ
        private static integer MUI_AstaQ = -1
        private static integer array m_AstaQ2
        private static integer MUI_AstaQ2 = -1
        private static integer array m_AstaQ3
        private static integer MUI_AstaQ3 = -1

        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k3
        real scale
        real r5
        real r6
        group g
        group g2
        unit u
        real dmg
        integer check2
        real aoe
        real move
        real r
        effect e
        effect e2
        effect e3
        effect e4
        real a
        real rmax

        public static method Loop_AstaQ takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AstaQ
                set this = m_AstaQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r < AstaQ_CastTime then
                        call DebugUnit2(c)
                    endif
                    if r == 0.39 then
                        call MakeSound("war3mapimported\\Hero_Asta_Q2")
                        call MakeSound("war3mapimported\\Hero_Asta_Q2")
                        set e = EffectSpawn4("war3mapImported\\wos_blackslash.mdx", GetUnitX(c) - 200 * Cos(a), GetUnitY(c) - 200 * Sin(a), a * bj_RADTODEG, 0.65, 0.5, 155, -20)
                        set e2 = EffectSpawn4("war3mapImported\\wos_blackslash.mdx", GetUnitX(c) - 200 * Cos(a), GetUnitY(c) - 200 * Sin(a), a * bj_RADTODEG, 0.65, 0.5, 155, -340)
                        set e3 = EffectSpawn("Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl", GetUnitX(c) + 250 * Cos(a), GetUnitY(c) + 250 * Sin(a), a * bj_RADTODEG, 0.65, 3, 135)
                        call MoveEff(e3, 10, a)
                        set scale = 1.0
                        set k3 = 0
                        if GetUnitAbilityLevel(c, AstaSword2_ID) > 0 then
                            set scale = (1.0 + (AstaTQ_AoeBonus / 100.0))
                            set aoe = aoe * (1.0 + (AstaTQ_AoeBonus / 100.0))
                            set k3 = 1
                            set dmg = dmg + AstaTQ_DmgBonus * GetHeroAgi(c, true)
                            call BlzSetSpecialEffectHeight(e, BlzGetLocalSpecialEffectZ(e) * (1.0 + (AstaTQ_AoeBonus / 100.0)))
                        endif
                        call ScaleEffDummy(e, 0.3, 0.5, 2.6 * scale)
                        call ScaleEffDummy(e2, 0.3, 0.5, 2.6 * scale)
                    endif
                    if r == AstaQ_CastTime then
                        call StopSpellUnit2(c)
                        if GetUnitAbilityLevel(c, AstaQ_ID) >= 5 then
                            call SwapAbility(c, 4, AstaQ2_ID, AstaQ_ID)
                            call MyFrame(c, 4, "BTNHero_Asta_Q2", false, 0)
                        endif
                    endif
                    if r >= AstaQ_CastTime then
                        set x = GetEffX(e) + 280 * Cos(a)
                        set y = GetEffY(e) + 280 * Sin(a)
                        call MoveEff(e, move, a)
                        call MoveEff(e2, move, a)
                        call MoveEff(e3, move, a)
                        if move < 100.0 then
                            set move = move + 1.25
                        endif
                        if r2 > 0.03 then
                            set r2 = 0.0
                            call VisionTimed(GetOwningPlayer(c), x, y, 600, 2)
                            if k3 == 1 then
                                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun2.mdl", x, y, a * bj_RADTODEG, 1.2, 2.75, 60, 255, 255, 255, 255))
                            else
                                call ColorEffDummy3(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_1.mdx", x, y, a * bj_RADTODEG, 1.25, 2.65, 180, 0, 0, 0, 255), 0, 0, 0, 0, 0.3)
                            endif
                        else
                            set r2 = r2 + 0.03
                        endif
                        set r5 = r5 + move
                        if r5 >= r6 then
                            set r = 9999.0
                        endif
                        call DecorRemove(c, x, y, aoe, AstaQ_DecorDamage)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x + 150 * Cos(a), y + 150 * Sin(a), aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                call GroupAddUnit(g2, u)
                                call dmgphys(c, u, dmg)
                                set r = rmax
                                call MUE(u, 150, 0.3, a)
                                call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_whiteakihared.mdl", u, "chest"))
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                    endif
                else
                    set x = GetEffX(e) + 425 * Cos(a)
                    set y = GetEffY(e) + 425 * Sin(a)
                    call DecorRemove(c, x, y, AstaQ_DamageAoe2, AstaQ_DecorExpDamage)
                    call GroupClear(g)
                    call GroupEnumUnitsInRange(g, x, y, AstaQ_DamageAoe2, Condition(function NoDecor_Filter))
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                            call GroupAddUnit(g2, u)
                            call dmgphys(c, u, dmg)
                            set r = rmax
                            call MUE(u, 150, 0.3, GAngle3(x, y, u))
                            call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_whiteakihared.mdl", u, "chest"))
                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop
                    set u = null
                    call MyRemoveEff(e3, 0.15)
                    if k3 == 1 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)3small.mdl", x, y, GetRandomReal(0, 359), 1, 2.4 * scale, 145))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_opdef (425).mdl", x, y, GetRandomReal(0, 359), 2.85, 0.3 * scale, 0))
                    endif
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdl", x, y, GetRandomReal(0, 359), 1, 2 * scale, 0))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Eff_Ord_YeYe_Eat_DiBanZhaKai2.mdx", x, y, GetRandomReal(0, 359), 2, 1.45 * scale, 0))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_3yue_5.mdl", x, y, GetRandomReal(0, 359), 1.5, 0.8 * scale, 0))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_3yue_5.mdl", x, y, GetRandomReal(0, 359), 1.75, 1.1 * scale, 0))
                    call ColorEffDummy3(e, 1, 255, 255, 255, 0.3)
                    call ColorEffDummy3(e2, 1, 255, 255, 255, 0.3)
                    call BlzSetSpecialEffectTimeScale(e, 1.15)
                    call BlzSetSpecialEffectTimeScale(e2, 1.15)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set u = null
                    set m_AstaQ[i] = m_AstaQ[MUI_AstaQ]
                    set MUI_AstaQ = MUI_AstaQ - 1
                    set i = i - 1
                    call deallocate(this)
                    if MUI_AstaQ == -1 then
                        call AstaTimer03Release()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AstaQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            local integer level = GetUnitAbilityLevel(NewC, AstaQ_ID)
            if level < 1 then
                set level = 1
            endif
            set MUI_AstaQ = MUI_AstaQ + 1
            set m_AstaQ[MUI_AstaQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.0
            set r5 = 0.0
            set r6 = AstaQ_RangeBase + AstaQ_RangeStep * (level - 1)
            set r2 = 1.0
            set g = CreateGroup()
            set g2 = CreateGroup()
            call StartSpellUnit2(c)
            set u = null
            set a = GAngle2(c, x, y)
            set rmax = AstaQ_CastTime + AstaQ_Duration
            set move = 80.0
            set aoe = AstaQ_DamageAoe
            set dmg = GetHeroAgi(c, true) * (AstaQ_DamageAgiBase + AstaQ_DamageAgiStep * (level - 1)) + AstaQ_Damage2StaticBase + AstaQ_Damage2StaticStep * (level - 1)
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SetUnitAnimationByIndex(c, 3)
            call SetUnitTimeScale(c, 0.7)
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)3small.mdl", GetUnitX(c), GetUnitY(c), 0, 1.5, 1.15, 120))
            call MakeSound("war3mapimported\\Hero_Asta_Q")
            if MUI_AstaQ == 0 then
                call AstaTimer03Acquire()
            endif
        endmethod

        public static method Loop_AstaQ3 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AstaQ3
                set this = m_AstaQ3[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set x = GetEffX(e) + 280 * Cos(a)
                    set y = GetEffY(e) + 280 * Sin(a)
                    call MoveEff(e, move, a)
                    call MoveEff(e3, move, a)
                    if move < 100.0 then
                        set move = move + 1.25
                    endif
                    if r2 > 0.03 then
                        set r2 = 0.0
                        call VisionTimed(GetOwningPlayer(c), x, y, 600, 2)
                        if k3 == 1 then
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun2.mdl", x, y, a * bj_RADTODEG, 1.2, 2.5, 60, 255, 255, 255, 255))
                        else
                            call ColorEffDummy3(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_1.mdx", x, y, a * bj_RADTODEG, 1.25, 2.65, 180, 0, 0, 0, 255), 0, 0, 0, 0, 0.3)
                        endif
                    else
                        set r2 = r2 + 0.03
                    endif
                    set r5 = r5 + move
                    if r5 >= r6 then
                        set r = 9999.0
                    endif
                    call DecorRemove(c, x, y, aoe, AstaQ2_DecorDamage)
                    call GroupClear(g)
                    call GroupEnumUnitsInRange(g, x + 150 * Cos(a), y + 150 * Sin(a), aoe, Condition(function NoDecor_Filter))
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                            call GroupAddUnit(g2, u)
                            call dmgphys(c, u, dmg)
                            set r = rmax
                            if check2 == 0 then
                                call MUE(u, 150, 0.3, GAngle3(x, y, u))
                            endif
                            call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_whiteakihared.mdl", u, "chest"))
                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop
                    set u = null
                else
                    set x = GetEffX(e) + 425 * Cos(a)
                    set y = GetEffY(e) + 425 * Sin(a)
                    call DecorRemove(c, x, y, AstaQ2_DamageAoe2, AstaQ2_DecorExpDamage)
                    call GroupClear(g)
                    call GroupEnumUnitsInRange(g, x, y, AstaQ2_DamageAoe2, Condition(function NoDecor_Filter))
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                            call GroupAddUnit(g2, u)
                            call dmgphys(c, u, dmg)
                            set r = rmax
                            if check2 == 0 then
                                call MUE(u, 250, 0.3, GAngle3(x, y, u))
                            endif
                            call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_whiteakihared.mdl", u, "chest"))
                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop
                    set u = null
                    call MyRemoveEff(e3, 0.15)
                    if k3 == 1 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)3small.mdl", x, y, GetRandomReal(0, 359), 1, 2 * scale, 145))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_opdef (425).mdl", x, y, GetRandomReal(0, 359), 2.85, 0.2 * scale, 0))
                    endif
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdl", x, y, GetRandomReal(0, 359), 1, 2 * scale, 0))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_3yue_5.mdl", x, y, GetRandomReal(0, 359), 1.5, 0.8 * scale, 0))
                    call ColorEffDummy3(e, 1, 255, 255, 255, 0.3)
                    call BlzSetSpecialEffectTimeScale(e, 1.15)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e3 = null
                    set e4 = null
                    set u = null
                    set m_AstaQ3[i] = m_AstaQ3[MUI_AstaQ3]
                    set MUI_AstaQ3 = MUI_AstaQ3 - 1
                    set i = i - 1
                    call deallocate(this)
                    if MUI_AstaQ3 == -1 then
                        call AstaTimer03Release()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AstaQ3_Start takes unit NewC, real NewX, real NewY, integer NewK returns nothing
            local thistype this = thistype.create()
            local integer level = GetUnitAbilityLevel(NewC, AstaQ2_ID)
            if level < 1 then
                set level = 1
            endif
            set MUI_AstaQ3 = MUI_AstaQ3 + 1
            set m_AstaQ3[MUI_AstaQ3] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.0
            set r5 = 0.0
            set r6 = AstaQ2_RangeBase + AstaQ2_RangeStep * (level - 1)
            set r2 = 1.0
            set g = CreateGroup()
            set g2 = CreateGroup()
            call StartSpellUnit2(c)
            set u = null
            set a = GAngle2(c, x, y)
            set rmax = AstaQ2_Duration
            set move = 80.0
            set aoe = AstaQ2_DamageAoe
            set dmg = GetHeroAgi(c, true) * (AstaQ2_DamageAgiBase + AstaQ2_DamageAgiStep * (level - 1)) + AstaQ2_Damage2StaticBase + AstaQ2_Damage2StaticStep * (level - 1)
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SetUnitAnimationByIndex(c, 3)
            call SetUnitTimeScale(c, 0.7)
            set x1 = GetUnitX(c) - 200 * Cos(a)
            set y1 = GetUnitY(c) - 200 * Sin(a)
            set check2 = 0
            if NewK == 1 then
                set check2 = 1
                set e = EffectSpawn4("war3mapImported\\wos_blackslash.mdx", x1 - 150 * Cos(a - 90 * bj_DEGTORAD), y1 - 150 * Sin(a - 90 * bj_DEGTORAD), a * bj_RADTODEG, 0.65, 0.5, 175, -35)
                set a = a - 4 * bj_DEGTORAD
            else
                set a = a + 4 * bj_DEGTORAD
                set e = EffectSpawn4("war3mapImported\\wos_blackslash.mdx", x1 - 150 * Cos(a + 90 * bj_DEGTORAD), y1 - 150 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG, 0.65, 0.5, 175, -325)
            endif
            set e3 = EffectSpawn("Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl", GetEffX(e), GetEffY(e), a * bj_RADTODEG, 0.65, 3, 135)
            set scale = 1.0
            set k3 = 0
            if GetUnitAbilityLevel(c, AstaSword2_ID) > 0 then
                set k3 = 1
                set scale = (1.0 + (AstaTQ_AoeBonus / 100.0))
                set aoe = aoe * (1.0 + (AstaTQ_AoeBonus / 100.0))
                set dmg = dmg + AstaTQ_DmgBonus * GetHeroAgi(c, true)
                call BlzSetSpecialEffectHeight(e, BlzGetLocalSpecialEffectZ(e) * (1.0 + (AstaTQ_AoeBonus / 100.0)))
            endif
            set dmg = dmg / 2.0
            call ScaleEffDummy(e, 0.3, 0.5, scale * 2.4)
            if MUI_AstaQ3 == 0 then
                call AstaTimer03Acquire()
            endif
        endmethod

        public static method Loop_AstaQ2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AstaQ2
                set this = m_AstaQ2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r < AstaQ2_CastTime then
                        call DebugUnit2(c)
                    endif
                    if r == 0.30 then
                        call AstaQ3_Start(c, x, y, 1)
                        call MakeSound("war3mapimported\\Hero_Asta_Q2")
                    endif
                    if r == 0.60 then
                        set r = 999.0
                        call AstaQ3_Start(c, x, y, 2)
                        call MakeSound("war3mapimported\\Hero_Asta_Q2")
                        call StopSpellUnit2(c)
                    endif
                else
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set u = null
                    set m_AstaQ2[i] = m_AstaQ2[MUI_AstaQ2]
                    set MUI_AstaQ2 = MUI_AstaQ2 - 1
                    set i = i - 1
                    call deallocate(this)
                    if MUI_AstaQ2 == -1 then
                        call AstaTimer03Release()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AstaQ2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            local integer level = GetUnitAbilityLevel(NewC, AstaQ2_ID)
            if level < 1 then
                set level = 1
            endif
            set MUI_AstaQ2 = MUI_AstaQ2 + 1
            set m_AstaQ2[MUI_AstaQ2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.0
            set r5 = 0.0
            set r6 = AstaQ2_RangeBase + AstaQ2_RangeStep * (level - 1)
            set r2 = 1.0
            set g = CreateGroup()
            set g2 = CreateGroup()
            call StartSpellUnit2(c)
            set u = null
            set a = GAngle2(c, x, y)
            set rmax = AstaQ2_CastTime
            set move = 80.0
            set aoe = AstaQ2_DamageAoe
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SetUnitAnimationByIndex(c, 3)
            call SetUnitTimeScale(c, 0.7)
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)3small.mdl", GetUnitX(c), GetUnitY(c), 0, 1.5, 1.15, 120))
            call MakeSound("war3mapimported\\Hero_Asta_Q2_1")
            if MUI_AstaQ2 == 0 then
                call AstaTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct AstaSpells_W
        private static integer array m_AstaW
        private static integer MUI_AstaW = -1
        private static integer array m_AstaW2
        private static integer MUI_AstaW2 = -1

        unit c
        unit td
        real x
        real y
        real r2
        integer k2
        integer k3
        real scale
        real r3
        real r4
        real r5
        real r6
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
        effect e2
        effect e3
        real a
        real rmax

        public static method Loop_AstaW takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AstaW
                set this = m_AstaW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit2(c)
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    if r == 0.27 then
                        call SetUnitAnimationByIndex(c, 7)
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_DanGe_Wid_ChongFengQiLiu.mdl", x + 400 * Cos(a), y + 400 * Sin(a), a * bj_RADTODEG, 1.2, 2.95, 0, 55, 0, 0, 125))
                    endif
                    if r == AstaW_CastTime then
                        call MakeSound("war3mapImported\\Hero_Asta_TW2")
                        set e = EffectSpawn("war3mapImported\\wos_BDEF (55)black.mdl", GetUnitX(c) + 35 * Cos(a), GetUnitY(c) + 35 * Sin(a), a * bj_RADTODEG + 90, 0.66, 1.5, 50)
                        call BlzSetSpecialEffectAlpha(e, 0)
                        call ColorEffDummy4(e, 0, 255, 255, 255, 0.25)
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_DanGe_Dus_Kuosan_1_2_1.mdl", x + 200 * Cos(a), y + 200 * Sin(a), a * bj_RADTODEG, 1.25, 2.55, 0, 55, 0, 0, 125))
                    endif
                    if r >= AstaW_CastTime then
                        call MoveUnit(c, move, a)
                        call BlzSetSpecialEffectPosition(e, GetUnitX(c) + 35 * Cos(a), GetUnitY(c) + 35 * Sin(a), 50)
                        call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
                        set r4 = r4 + move
                        if r4 >= r6 then
                            set r = 9999.0
                        endif
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                set k2 = k2 + 1
                                if k2 == 1 then
                                    call MakeSound("war3mapImported\\Hero_Kirito_Q2")
                                endif
                                if not IsUnitInGroup(u, g2) then
                                    call dmgphys(c, u, dmg)
                                    call GroupAddUnit(g2, u)
                                    call StunUnit(c, u, AstaW_Stun)
                                    call MUE(u, 400, AstaW_PushDuration, GAngle(c, u))
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        if r2 > 0.0 then
                            set r2 = 0.0
                            set x = x + 150 * Cos(a)
                            set y = y + 150 * Sin(a)
                            call DecorRemove(c, x, y, aoe, AstaW_DecorDamage)
                        else
                            set r2 = r2 + 0.03
                        endif
                        if r3 > 0.03 then
                            set r3 = 0.0
                            set x = x + 250 * Cos(a)
                            set y = y + 250 * Sin(a)
                            call ColorEffDummy3(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_1.mdx", x, y, a * bj_RADTODEG, 1.25, 2.65, 180, 0, 0, 0, 255), 0, 0, 0, 0, 0.3)
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun2.mdl", x, y, a * bj_RADTODEG, 1, 2.5, 50, 255, 255, 255, 190))
                        else
                            set r3 = r3 + 0.03
                        endif
                    endif
                else
                    call StopSpellUnit2(c)
                    if k3 == 1 then
                        set x = GetUnitX(c) + 175 * Cos(a)
                        set y = GetUnitY(c) + 175 * Sin(a)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_ZarakiWCrack1.mdl", x, y, GetRandomReal(0, 359), 1.25, 2, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (434)3small.mdx", x, y, GetRandomReal(0, 359), 1, 2, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_3yue_5.mdl", x, y, GetRandomReal(0, 359), 1.5, 1, 0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlashred.mdl", x + 25 * Cos(a), y + 25 * Sin(a), 1, 1.15, 2.475, 125))
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                set k2 = k2 + 1
                                if k2 == 1 then
                                    call MakeSound("war3mapImported\\Hero_Kirito_Q2")
                                endif
                                if td == null then
                                    set td = u
                                endif
                                if not IsUnitInGroup(u, g2) then
                                    call dmgphys(c, u, dmg)
                                    call GroupAddUnit(g2, u)
                                    call StunUnit(c, u, AstaW_Stun)
                                    if td != u then
                                        call MUE(u, 400, AstaW_PushDuration, GAngle(c, u))
                                    endif
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call PosUnit(td, GetUnitX(c) + 175 * Cos(a), GetUnitY(c) + 175 * Sin(a))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                    if GetUnitAbilityLevel(c, AstaW_ID) >= 5 then
                        call SwapAbility(c, 3, AstaW2_ID, AstaW_ID)
                        call MyFrame(c, 3, "BTNHero_Asta_W2", false, 1)
                    endif
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set e = null
                    set g = null
                    set td = null
                    set g2 = null
                    set c = null
                    set m_AstaW[i] = m_AstaW[MUI_AstaW]
                    set MUI_AstaW = MUI_AstaW - 1
                    set i = i - 1
                    call deallocate(this)
                    if MUI_AstaW == -1 then
                        call AstaTimer03Release()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AstaW_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            local integer level = GetUnitAbilityLevel(NewC, AstaW_ID)
            if level < 1 then
                set level = 1
            endif
            set MUI_AstaW = MUI_AstaW + 1
            set m_AstaW[MUI_AstaW] = this
            set c = NewC
            set r = 0.0
            set td = null
            set x = NewX
            set y = NewY
            set check = 0
            set k2 = 0
            set r2 = 10.0
            set r3 = 10.0
            set r4 = 0.0
            set r6 = AstaW_RangeBase + AstaW_RangeStep * (level - 1)
            set g = CreateGroup()
            set g2 = CreateGroup()
            call StartSpellUnit2(c)
            set aoe = AstaW_DamageAoe
            set a = GAngle2(c, x, y)
            call MakeSound("war3mapImported\\Hero_Asta_W")
            set dmg = GetHeroAgi(c, true) * (AstaW_DamageAgiBase + AstaW_DamageAgiStep * (level - 1)) + AstaW_Damage2StaticBase + AstaW_Damage2StaticStep * (level - 1)
            set rmax = AstaW_CastTime + AstaW_Duration
            set move = 120.0
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SetUnitAnimationByIndex(c, 6)
            call SetUnitTimeScale(c, 0.6)
            set scale = 1.0
            set k3 = 0
            if GetUnitAbilityLevel(c, AstaSword2_ID) > 0 then
                set dmg = dmg + GetHeroAgi(c, true) * AstaTW_DmgBonus
                set k3 = 1
            endif
            call VisionTimed(GetOwningPlayer(c), x, y, 750, 6)
            if MUI_AstaW == 0 then
                call AstaTimer03Acquire()
            endif
        endmethod

        public static method Loop_AstaW2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AstaW2
                set this = m_AstaW2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit2(c)
                    set a = GAngle(c, td)
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    if r == 0.27 then
                        call SetUnitAnimationByIndex(c, 7)
                    endif
                    if r == 0.39 then
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_DanGe_Wid_ChongFengQiLiu.mdl", x + 400 * Cos(a), y + 400 * Sin(a), a * bj_RADTODEG, 1.2, 2.95, 0, 55, 0, 0, 125))
                    endif
                    if r >= AstaW2_CastTime then
                        call MoveUnit(c, move, a)
                        call BlzSetSpecialEffectPosition(e, x, y, 0)
                        call BlzSetSpecialEffectPosition(e2, x, y, 0)
                        call BlzSetSpecialEffectPosition(e3, x, y, 0)
                        call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
                        set r4 = r4 + move
                        if SR2(c, td) < 100.0 then
                            set r = 9999.0
                        endif
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                set k2 = k2 + 1
                                if k2 == 1 then
                                    call MakeSound("war3mapImported\\Hero_Kirito_Q2")
                                endif
                                if td == null then
                                    set td = u
                                endif
                                if not IsUnitInGroup(u, g2) then
                                    call dmgphys(c, u, dmg)
                                    call GroupAddUnit(g2, u)
                                    call StunUnit(c, u, AstaW2_Stun)
                                    if td != u then
                                        call MUE(u, 400, 0.15, GAngle(c, u))
                                    endif
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        if r2 > 0.0 then
                            set r2 = 0.0
                            set x = x + 150 * Cos(a)
                            set y = y + 150 * Sin(a)
                            call DecorRemove(c, x, y, aoe, AstaW2_DecorDamage)
                            call ColorEffDummy3(EffectSpawn3("war3mapimported\\wos_xxxxuanfeng2.mdl", x, y, a * bj_RADTODEG, 0.8, GetRandomReal(0.75, 1.35), 100, -90), 0, 255, 255, 255, 0.3)
                        else
                            set r2 = r2 + 0.03
                        endif
                        if r3 > 0.03 then
                            set r3 = 0.0
                            set x = x + 250 * Cos(a)
                            set y = y + 250 * Sin(a)
                            call ColorEffDummy3(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_1.mdx", x, y, a * bj_RADTODEG, 1.25, 2.65, 180, 0, 0, 0, 255), 0, 0, 0, 0, 0.3)
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun2.mdl", x, y, a * bj_RADTODEG, 1, 2.5, 50, 255, 255, 255, 190))
                        else
                            set r3 = r3 + 0.03
                        endif
                    endif
                else
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call MakeSound("war3mapImported\\Hero_Asta_W2_2")
                    if k3 == 1 then
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (597)red.mdx", x, y, GetRandomReal(0, 359), 2, 1.35, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_FBT-dilie22.mdx", x, y, GetRandomReal(0, 359), 0.2, 3.6, 5))
                    endif
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_ldeff (41).mdl", x, y, GetRandomReal(0, 359), 2, 2.75, 0))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_afb (2080).mdl", x, y, a * bj_RADTODEG, 2, 1.7, 1))
                    call StopSpellUnit2(c)
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call DestroyEffect(e3)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set e = null
                    set g = null
                    set td = null
                    set g2 = null
                    set c = null
                    set e2 = null
                    set e3 = null
                    set m_AstaW2[i] = m_AstaW2[MUI_AstaW2]
                    set MUI_AstaW2 = MUI_AstaW2 - 1
                    set i = i - 1
                    call deallocate(this)
                    if MUI_AstaW2 == -1 then
                        call AstaTimer03Release()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AstaW2_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create()
            local integer level = GetUnitAbilityLevel(NewC, AstaW2_ID)
            if level < 1 then
                set level = 1
            endif
            set MUI_AstaW2 = MUI_AstaW2 + 1
            set m_AstaW2[MUI_AstaW2] = this
            set c = NewC
            set r = 0.0
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set check = 0
            set k2 = 0
            set r2 = 10.0
            set r3 = 10.0
            set r4 = 0.0
            set g = CreateGroup()
            set g2 = CreateGroup()
            call StartSpellUnit2(c)
            set aoe = AstaW2_DamageAoe
            set a = GAngle2(c, x, y)
            call MakeSound("war3mapImported\\Hero_Asta_W2_1")
            set dmg = GetHeroAgi(c, true) * (AstaW2_DamageAgiBase + AstaW2_DamageAgiStep * (level - 1)) + AstaW2_Damage2StaticBase + AstaW2_Damage2StaticStep * (level - 1)
            set rmax = AstaW2_CastTime + AstaW2_Duration
            set move = 120.0
            set scale = 1.0
            set k3 = 0
            if GetUnitAbilityLevel(c, AstaSword2_ID) > 0 then
                set k3 = 1
                set dmg = dmg + GetHeroAgi(c, true) * AstaTW_DmgBonus
            endif
            set e = EffectSpawn("war3mapimported\\wos_Windwalk Black.mdx", GetUnitX(c), GetUnitY(c), 1, 3, 1, 1)
            set e2 = EffectSpawn("war3mapimported\\wos_Windwalk Blood.mdx", GetUnitX(c), GetUnitY(c), 1, 2, 1, 1)
            set e3 = EffectSpawn("war3mapimported\\wos_opdef (434).mdl", GetUnitX(c), GetUnitY(c), 1, 1, 0.45, 1)
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SetUnitAnimationByIndex(c, 6)
            call SetUnitTimeScale(c, 0.6)
            call VisionTimed(GetOwningPlayer(c), x, y, 750, 6)
            if MUI_AstaW2 == 0 then
                call AstaTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct AstaSpells_E
        private static integer array m_AstaE
        private static integer MUI_AstaE = -1

        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        integer k3
        real scale
        real r3
        real r4
        real r5
        real r6
        group g
        group g2
        unit u
        real dmg
        integer check2
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax

        public static method Loop_AstaE takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr1 = 0.0
            local real rr2 = 0.0
            local real rr3 = 0.0
            loop
                exitwhen i > MUI_AstaE
                set this = m_AstaE[i]
                if SpellBoolCaster(c) and r <= rmax and LoadInteger(hs, GetHandleId(c), StringHash("stop r")) == 0 then
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit2(c)
                    if r == 1.50 then
                        call MakeSound("war3mapimported\\Hero_Asta_E2")
                    endif
                    if r > 0.30 then
                        if GetMouseX(GetOwningPlayer(c)) != x1 then
                            set x1 = GetMouseX(GetOwningPlayer(c))
                            set y1 = GetMouseY(GetOwningPlayer(c))
                            set a = GAngle2(c, x1, y1)
                        endif
                    endif
                    call BlzSetUnitFacingEx(c, GetUnitFacing(c) + 35)
                    if move < r6 then
                        set move = move + 1.0
                    endif
                    call MoveUnit(c, move, a)
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    call BlzSetSpecialEffectPosition(e, x, y, 0)
                    call BlzSetSpecialEffectPosition(e2, x, y, 0)
                    if r2 > 0.18 then
                        call DecorRemove(c, x, y, aoe, AstaE_DecorDamage)
                        set r2 = 0.0
                        set k = 0
                        loop
                            exitwhen k == 3
                            set rr2 = GetRandomReal(1.5, 2.0)
                            set rr3 = GetRandomReal(0.385, 0.52)
                            if k == 0 then
                                set rr3 = rr3 * 0.63
                                set rr1 = GetRandomReal(30, 60)
                            elseif k == 1 then
                                set rr1 = GetRandomReal(90, 120)
                                set rr3 = rr3 * 0.76
                            else
                                set rr1 = GetRandomReal(150, 180)
                                set rr3 = rr3 * 0.63
                            endif
                            if k3 == 1 then
                                call EUTU2_3(EffectSpawnColor("war3mapimported\\wos_rraiden-esfx-6.mdx", x, y, GetRandomReal(0, 359), rr2, rr3 * scale * 1.25, rr1, 2, 0, 0, 125), 1, rr1, c)
                            endif
                            call EUTU2_3(EffectSpawnColor("war3mapimported\\wos_rraiden-esfx-6.mdx", x, y, GetRandomReal(0, 359), rr2, rr3 * scale, rr1, 75, 0, 0, 255), 1, rr1, c)
                            set k = k + 1
                        endloop
                    else
                        set r2 = r2 + 0.03
                    endif
                    if r4 > 0.45 then
                        set r4 = 0.0
                        call GroupClear(g2)
                    else
                        set r4 = r4 + 0.03
                    endif
                    if r5 > 0.35 then
                        set r5 = 0.0
                        if k3 == 1 then
                            call EUTU2(EffectSpawn("war3mapimported\\wos_OPm (434)3small.mdx", x, y, GetRandomReal(0, 359), 1, 1.5, 115), 1, 115, c)
                        endif
                    else
                        set r5 = r5 + 0.03
                    endif
                    if r3 > AstaE_Interval then
                        set r3 = 0.0
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                call dmgphys(c, u, dmg)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                call GroupAddUnit(g2, u)
                                call MUE(u, 100, 0.15, GAngle(c, u))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                    else
                        set r3 = r3 + 0.03
                    endif
                else
                    call SetUnitTimeScale(c, 1.0)
                    call BlzSetSpecialEffectScale(e, 0.01)
                    call BlzSetSpecialEffectScale(e2, 0.01)
                    call SaveInteger(hs, GetHandleId(c), StringHash("asta e"), 0)
                    call SaveInteger(hs, GetHandleId(c), StringHash("cast r"), 0)
                    call SaveInteger(hs, GetHandleId(c), StringHash("stop r"), 0)
                    call EUTU2(e, 2, 50, c)
                    call EUTU2(e2, 2, 50, c)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    call MouseOff(GetOwningPlayer(c))
                    call StopSpellUnit2(c)
                    set g = null
                    set g2 = null
                    set e = null
                    set e2 = null
                    set c = null
                    set u = null
                    set m_AstaE[i] = m_AstaE[MUI_AstaE]
                    set MUI_AstaE = MUI_AstaE - 1
                    set i = i - 1
                    call deallocate(this)
                    if MUI_AstaE == -1 then
                        call AstaTimer03Release()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AstaE_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            local integer level = GetUnitAbilityLevel(NewC, AstaE_ID)
            if level < 1 then
                set level = 1
            endif
            set MUI_AstaE = MUI_AstaE + 1
            set m_AstaE[MUI_AstaE] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0.0
            set r2 = 0.0
            set r5 = 0.0
            set r6 = 30.0
            call StartSpellUnit2(c)
            set k = 0
            set u = null
            set g = CreateGroup()
            set g2 = CreateGroup()
            set check2 = 0
            set a = GetUnitFacing(c) * bj_DEGTORAD
            set rmax = AstaE_Duration
            set move = 8.0
            call SaveInteger(hs, GetHandleId(c), StringHash("asta e"), 1)
            if GetHeroLevel(c) >= 35 then
                set move = 12.0
                set r6 = r6 * (1.0 + (AstaE_35_bonuspeed / 100.0))
            endif
            call SaveInteger(hs, GetHandleId(c), StringHash("cast r"), 1)
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            set aoe = AstaE_DamageAoe
            set dmg = GetHeroAgi(c, true) * (AstaE_DamageAgiBase + AstaE_DamageAgiStep * (level - 1))
            call SetUnitAnimationByIndex(c, 9)
            call SetUnitTimeScale(c, 1.45)
            call SetMouseX(GetOwningPlayer(c), x + 500 * Cos(a))
            call SetMouseY(GetOwningPlayer(c), y + 500 * Sin(a))
            call MouseOn(GetOwningPlayer(c))
            set scale = 1.0
            set k3 = 0
            if GetUnitAbilityLevel(c, AstaSword2_ID) > 0 then
                set k3 = 1
                set dmg = GetHeroAgi(c, true) * (AstaE_DamageAgiBase + AstaE_DamageAgiStep * level)
                set scale = (1.0 + ((AstaTE_AoeBonus - 5.0) / 100.0))
                set aoe = aoe * (1.0 + (AstaTE_AoeBonus / 100.0))
            endif
            set dmg = dmg + AstaE_DamageStatic
            set e = EffectSpawn("war3mapimported\\wos_Windwalk Black.mdx", x, y, 1, 1, 3 * scale, 0)
            set e2 = EffectSpawn("war3mapimported\\wos_Windwalk blood.mdx", x, y, 1, 1, 2 * scale, 0)
            call MakeSound("war3mapimported\\Hero_Asta_E")
            if MUI_AstaE == 0 then
                call AstaTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct AstaSpells_R
        private static integer array m_AstaR
        private static integer MUI_AstaR = -1
        private static integer array m_AstaR2
        private static integer MUI_AstaR2 = -1

        unit c
        unit td
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        real r3
        real r5
        group g
        unit u
        real dmg
        integer check
        integer check2
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax

        public static method Loop_AstaR takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AstaR
                set this = m_AstaR[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    set x1 = GetUnitX(c)
                    set y1 = GetUnitY(c)
                    call DebugUnit(c)
                    set a = GAngle(c, td)
                    call SetUnitFacing(c, a * bj_RADTODEG)
                    if r > AstaR_CastTime then
                        if r2 > 0.03 then
                            set r2 = 0.0
                            call ColorEffDummy3(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_1.mdx", x1, y1, a * bj_RADTODEG, 1.25, 2.65, 180, 0, 0, 0, 255), 0, 0, 0, 0, 0.3)
                        else
                            set r2 = r2 + 0.03
                        endif
                        if SR2(c, td) >= 200.0 then
                            call MoveUnit(c, move, a)
                        else
                            call dmgphys(c, td, dmg)
                            call MUE(c, 600, 0.3, a)
                            call MakeSound("war3mapImported\\Hero_Asta_R3")
                            call DecorRemove(c, x, y, 600, AstaR_DecorDamage)
                            call SetUnitAnimation(td, "death")
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_rraiden-esfx-6.mdx", x - 250 * Cos(a), y - 250 * Sin(a), a * bj_RADTODEG, 1.965, 0.8, 75, 75, 0, 0, 255))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun2.mdl", x, y, a * bj_RADTODEG, 0.95, 4, 50, 255, 255, 255, 190))
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_afbcoyrighthdcec.mdl", x, y, GetRandomReal(0, 359), 0.65, 3.75, 145, 45, 0, 0, 255))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_ZarakiWCrack1.mdl", x, y, GetRandomReal(0, 359), 1.25, 2, 0))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_opdef (425).mdx", x, y, GetRandomReal(0, 359), 1.45, 0.5, 0))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_3yue_5.mdl", x, y, GetRandomReal(0, 359), 1.5, 1, 0))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_3yue_5.mdl", x, y, GetRandomReal(0, 359), 1.75, 1.3, 0))
                            set r = 9999.0
                        endif
                    endif
                else
                    call StopSpellUnit(c)
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call SetUnitTimeScale(c, 1.0)
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set td = null
                    set e = null
                    set e2 = null
                    set m_AstaR[i] = m_AstaR[MUI_AstaR]
                    set MUI_AstaR = MUI_AstaR - 1
                    set i = i - 1
                    call deallocate(this)
                    if MUI_AstaR == -1 then
                        call AstaTimer03Release()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AstaR_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create()
            local integer level = GetUnitAbilityLevel(NewC, AstaR_ID)
            if level < 1 then
                set level = 1
            endif
            set MUI_AstaR = MUI_AstaR + 1
            set m_AstaR[MUI_AstaR] = this
            set c = NewC
            set td = NewTd
            set r = 0.0
            set r2 = 10.0
            set r3 = 10.0
            set check = 0
            set check2 = 0
            set r5 = 0.39
            set move = 120.0
            set aoe = AstaR_DamageAoe
            set g = CreateGroup()
            set dmg = GetHeroAgi(c, true) * (AstaR_DamageAgiBase + AstaR_DamageAgiStep * (level - 1))
            call StartSpellUnit(c)
            set rmax = AstaR_CastTime + AstaR_Duration
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set e = AddSpecialEffectTarget("war3mapimported\\wos_Windwalk Black.mdx", c, "origin")
            call SetUnitAnimationByIndex(c, 3)
            call SetUnitTimeScale(c, 0.5)
            call MakeSound("war3mapImported\\Hero_Asta_R")
            call MakeSound("war3mapImported\\Hero_Asta_R3")
            if MUI_AstaR == 0 then
                call AstaTimer03Acquire()
            endif
        endmethod

        public static method Loop_AstaR2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AstaR2
                set this = m_AstaR2[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    set x1 = GetUnitX(c)
                    set y1 = GetUnitY(c)
                    call DebugUnit(c)
                    call DebugUnit(td)
                    set a = GAngle(c, td)
                    call SetUnitFacing(c, a * bj_RADTODEG)
                    if r == 0.03 then
                        call PosUnit(c, x - 300 * Cos(a), y - 300 * Sin(a))
                    endif
                    if r2 > 0.16 then
                        set r2 = 0.0
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_krk (1971).mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 1.25, 1))
                    else
                        set r2 = r2 + 0.03
                    endif
                    if r == 0.90 then
                        call MakeSound("war3mapImported\\Hero_Asta_TR2")
                    endif
                    if r >= AstaR2_CastTime then
                        call SetUnitAnimation(td, "death")
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        call dmgphys(c, td, dmg)
                        call DecorRemove(c, x, y, aoe, AstaR2_DecorDamage)
                        call StopSpellUnit(c)
                        call StopSpellUnit(td)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call dmgphys(c, u, dmg)
                                call SilenceUnit(c, u, R2I(AstaR2_Silence))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                        call MakeSound("war3mapImported\\Hero_Asta_TR3")
                        call MakeSound("war3mapImported\\Hero_Erza6_Q3")
                        call DecorRemove(c, x, y, aoe * 1.75, 50)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)3small.mdl", x, y, GetRandomReal(0, 359), 1, 3, 145))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZarakiWCrack2.mdx", x, y, GetRandomReal(0, 359), 1, 3, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Eff_Ord_DanGe_Wav_Kuosan_1_3_0_5s.mdx", x, y, 1, 1, 1, 100))
                        set k = 0
                        loop
                            exitwhen k > 4
                            call EffectSpawn2("war3mapimported\\wos_LD2209 (157).mdx", x, y, GetRandomReal(0, 359), 1.6 - k * 0.2, 1 + k * 0.5, 0, 1.25)
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_dustgaraa2.mdx", x, y, GetRandomReal(0, 359), 1.85 - k * 0.1, 1.9 + k * 0.42, 0))
                            set k = k + 1
                        endloop
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_chushou_by_wood_effect_earth_longzhituxi.mdx", x, y, GetRandomReal(0, 359), 0.5, 1.75, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (597)red.mdx", x, y, GetRandomReal(0, 359), 2, 1.75, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_FBT-dilie22.mdx", x, y, GetRandomReal(0, 359), 0.2, 3.6, 5))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlashred.mdl", x + 25 * Cos(a), y + 25 * Sin(a), 1, 1.25, 2.5, 255))
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_afbcoyrighthdcec.mdl", x, y, GetRandomReal(0, 359), 0.65, 5, 175, 45, 0, 0, 255))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_ZarakiWCrack1.mdl", x, y, GetRandomReal(0, 359), 1.25, 2, 0))
                        call DestroyEffect(EffectSpawn("opm (525).mdx", x, y, GetRandomReal(0, 359), 1.45, 0.65, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_3yue_5.mdl", x, y, GetRandomReal(0, 359), 1.5, 1, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_3yue_5.mdl", x, y, GetRandomReal(0, 359), 1.75, 1.3, 0))
                        set r = 9999.0
                    endif
                else
                    call StopSpellUnit(c)
                    if td != null and GetWidgetLife(td) > 0.405 then
                        call StopSpellUnit(td)
                    endif
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call SetUnitTimeScale(c, 1.0)
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set td = null
                    set e = null
                    set e2 = null
                    set m_AstaR2[i] = m_AstaR2[MUI_AstaR2]
                    set MUI_AstaR2 = MUI_AstaR2 - 1
                    set i = i - 1
                    call deallocate(this)
                    if MUI_AstaR2 == -1 then
                        call AstaTimer03Release()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AstaR2_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create()
            set MUI_AstaR2 = MUI_AstaR2 + 1
            set m_AstaR2[MUI_AstaR2] = this
            set c = NewC
            set td = NewTd
            set r = 0.0
            set r2 = 10.0
            set r3 = 10.0
            set check = 0
            set check2 = 0
            set r5 = 0.39
            set move = 120.0
            set aoe = AstaR2_DamageAoe
            set g = CreateGroup()
            set dmg = GetHeroAgi(c, true) * AstaR2_DamageAgiBase
            call StartSpellUnit(c)
            call StartSpellUnit(td)
            set rmax = AstaR2_CastTime
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set e = AddSpecialEffectTarget("war3mapimported\\wos_Windwalk Black.mdx", c, "origin")
            call SetUnitAnimationByIndex(c, 1)
            call SetUnitTimeScale(c, 0.255)
            call MakeSound("war3mapImported\\Hero_Asta_TR")
            call MakeSound("war3mapImported\\Hero_Asta_R3")
            if MUI_AstaR2 == 0 then
                call AstaTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct AstaSpells_T
        private static integer array m_AstaT
        private static integer MUI_AstaT = -1
        private static integer array m_AstaT2
        private static integer MUI_AstaT2 = -1

        unit c
        unit td
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        integer k2
        real r3
        real r4
        real r5
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
        effect e2
        real a
        real rmax

        public static method Loop_AstaT takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AstaT
                set this = m_AstaT[i]
                if SpellBoolCaster(c) and r <= rmax then
                    if not IsUnitPaused(c) then
                        set r = RoundReal(r + 0.05, 3)
                    endif
                    call BlzFrameSetValue(frameAsta_pas3[k2], rmax - r)
                    if rmax - r >= 0.0 then
                        call BlzFrameSetText(frameAsta_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                    endif
                else
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frameAsta_pas1[k2], false)
                    endif
                    call UnitRemoveAbility(c, AstaSword2_ID)
                    call UnitAddAbility(c, AstaSword_ID)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), AstaT2_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), AstaT_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), AstaR2_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), AstaR_ID, true)
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call AAUniversalTooltips_SetUnitForm(c, 0)
                    set c = null
                    set e = null
                    set e2 = null
                    set m_AstaT[i] = m_AstaT[MUI_AstaT]
                    set MUI_AstaT = MUI_AstaT - 1
                    set i = i - 1
                    call deallocate(this)
                    if MUI_AstaT == -1 then
                        call AstaTimer05Release()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AstaT_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            local real tmp_y = 0.0
            set MUI_AstaT = MUI_AstaT + 1
            set m_AstaT[MUI_AstaT] = this
            set c = NewC
            set r = 0.0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set rmax = AstaT_Duration
            call DecorRemove(c, x, y, 450, AstaT_DecorDamage)
            if frameAsta_pas1[k2] == null then
                set frameAsta_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                call BlzFrameSetAbsPoint(frameAsta_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18 + tmp_y)
                call BlzFrameSetSize(frameAsta_pas1[k2], 0.135, 0.035)
                call BlzFrameSetTexture(frameAsta_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                call BlzFrameSetVisible(frameAsta_pas1[k2], false)
                if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frameAsta_pas1[k2], true)
                endif
                set frameAsta_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frameAsta_pas1[k2], 0, 0)
                call BlzFrameSetAbsPoint(frameAsta_pas2[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
                call BlzFrameSetSize(frameAsta_pas2[k2], 0.1, 0.019)
                set frameAsta_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frameAsta_pas1[k2], "", 0)
                call BlzFrameSetSize(frameAsta_pas3[k2], 0.1, 0.035)
                call BlzFrameSetScale(frameAsta_pas3[k2], 0.5)
                call BlzFrameSetModel(frameAsta_pas3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                call BlzFrameSetAbsPoint(frameAsta_pas3[k2], FRAMEPOINT_CENTER, 0.05, 0.175 + tmp_y)
                call BlzFrameSetMinMaxValue(frameAsta_pas3[k2], 0, rmax + 1)
                call BlzFrameSetValue(frameAsta_pas3[k2], rmax)
                set frameAsta_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frameAsta_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frameAsta_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18 + tmp_y)
                call BlzFrameSetSize(frameAsta_pas4[k2], 0.03, 0.03)
                call BlzFrameSetTexture(frameAsta_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Asta_T", 0, false)
                set frameAsta_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frameAsta_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frameAsta_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
                call BlzFrameSetText(frameAsta_pas5[k2], "|c00FFFF00" + "Divider Time Left:" + "|r")
                call BlzFrameSetScale(frameAsta_pas5[k2], 0.9)
                set frameAsta_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frameAsta_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frameAsta_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17 + tmp_y)
                call BlzFrameSetText(frameAsta_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                call BlzFrameSetScale(frameAsta_pas6[k2], 0.9)
            else
                if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frameAsta_pas1[k2], true)
                endif
                call BlzFrameSetMinMaxValue(frameAsta_pas3[k2], 0, rmax + 1)
                call BlzFrameSetValue(frameAsta_pas3[k2], rmax)
            endif
            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_DingZhi_BY_Wood_Effect_Bleach_LvSeQiLiu2.mdx", c, "origin")
            call Asta_RestoreOrder(c, 3)
            call SetUnitTimeScale(c, 0.5)
            call UnitRemoveAbility(c, AstaSword_ID)
            call UnitAddAbility(c, AstaSword2_ID)
            if GetHeroLevel(c) >= 35 then
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), AstaT2_ID, true)
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), AstaT_ID, false)
                call UnitAddAbility(c, AstaT2_ID)
            endif
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), AstaR2_ID, true)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), AstaR_ID, false)
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_krk (1971).mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 1.25, 1))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)3small.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 3, 145))
            call UnitAddAbility(c, AstaR2_ID)
            call MakeSound("war3mapImported\\Hero_Asta_T")
            call MakeSound("war3mapImported\\Hero_Asta_T2")
            call AAUniversalTooltips_SetUnitForm(c, 1)
            if MUI_AstaT == 0 then
                call AstaTimer05Acquire()
            endif
        endmethod

        public static method Loop_AstaT2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AstaT2
                set this = m_AstaT2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit(c)
                    if r == 1.02 then
                        call MakeSound("war3mapImported\\Hero_Asta_T2 2")
                        call NextSound("war3mapImported\\Hero_Asta_T2 3", 0.51)
                    endif
                    if r == 1.11 then
                        call MakeSound("war3mapImported\\Hero_Asta_T2 4")
                        set x = GetUnitX(c) + 450 * Cos(a)
                        set y = GetUnitY(c) + 450 * Sin(a)
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_rraiden-esfx-6.mdx", GetUnitX(c) + 250 * Cos(a), GetUnitY(c) + 250 * Sin(a), a * bj_RADTODEG, 1.0, 1.9, 75, 25, 0, 0, 255))
                    endif
                    if r >= AstaT2_CastTime then
                        call StopSpellUnit(c)
                        call GroupClear(g)
                        set x = GetUnitX(c) + 565 * Cos(a)
                        set y = GetUnitY(c) + 565 * Sin(a)
                        set k = 0
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)3small.mdl", GetUnitX(c) + 750 * Cos(a - 30 * bj_DEGTORAD), GetUnitY(c) + 750 * Sin(a - 30 * bj_DEGTORAD), GetRandomReal(0, 359), 1, 3, 145))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)3small.mdl", GetUnitX(c) + 750 * Cos(a), GetUnitY(c) + 750 * Sin(a), GetRandomReal(0, 359), 1, 3, 145))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)3small.mdl", GetUnitX(c) + 750 * Cos(a + 30 * bj_DEGTORAD), GetUnitY(c) + 750 * Sin(a + 30 * bj_DEGTORAD), GetRandomReal(0, 359), 1, 3, 145))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdl", GetUnitX(c) + 750 * Cos(a), GetUnitY(c) + 750 * Sin(a), GetRandomReal(0, 359), 1, 4, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Eff_Ord_YeYe_Eat_DiBanZhaKai2.mdx", GetUnitX(c) + 750 * Cos(a), GetUnitY(c) + 750 * Sin(a), GetRandomReal(0, 359), 3, 2.75, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdl", GetUnitX(c) + 750 * Cos(a - 30 * bj_DEGTORAD), GetUnitY(c) + 750 * Sin(a - 30 * bj_DEGTORAD), GetRandomReal(0, 359), 1, 4, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Eff_Ord_YeYe_Eat_DiBanZhaKai2.mdx", GetUnitX(c) + 750 * Cos(a - 30 * bj_DEGTORAD), GetUnitY(c) + 750 * Sin(a - 30 * bj_DEGTORAD), GetRandomReal(0, 359), 3, 2.75, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdl", GetUnitX(c) + 750 * Cos(a + 30 * bj_DEGTORAD), GetUnitY(c) + 750 * Sin(a + 30 * bj_DEGTORAD), GetRandomReal(0, 359), 1, 4, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Eff_Ord_YeYe_Eat_DiBanZhaKai2.mdx", GetUnitX(c) + 750 * Cos(a + 30 * bj_DEGTORAD), GetUnitY(c) + 750 * Sin(a + 30 * bj_DEGTORAD), GetRandomReal(0, 359), 3, 2.75, 0))
                        loop
                            exitwhen k == 7
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdx", GetUnitX(c) + 750 * Cos(a + (30 * k - 90) * bj_DEGTORAD), GetUnitY(c) + 750 * Sin(a + (30 * k - 90) * bj_DEGTORAD), a * bj_RADTODEG + 30 * k - 90 + 180, GetRandomReal(1.1, 1.35), 3, 1, 255, 255, 255, 95))
                            set k = k + 1
                        endloop
                        call DecorRemove(c, x, y, 1000, AstaT2_DecorDamage)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_3yue_5.mdl", x, y, GetRandomReal(0, 359), 1.5, 1, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_3yue_5.mdl", x, y, GetRandomReal(0, 359), 1.75, 1.35, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_opdef (425).mdl", x, y, GetRandomReal(0, 359), 1.85, 0.5, 0))
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                if not IsUnitInGroup(u, g2) then
                                    call dmgphys(c, u, dmg)
                                    call GroupAddUnit(g2, u)
                                    call StunUnit(c, u, AstaT2_Stun)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                            endif
                            if IsUnitAlly(u, GetOwningPlayer(c)) then
                                call DebuffClear(u)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set r = 9999.0
                    endif
                    if r2 > 0.12 then
                        set r2 = 0.0
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_krk (1971).mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 1.25, 1))
                    else
                        set r2 = r2 + 0.03
                    endif
                    if r3 > 0.24 and r < 1.12 then
                        set r3 = 0.0
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)3small.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 3, 145))
                    else
                        set r3 = r3 + 0.03
                    endif
                else
                    call DestroyEffect(e)
                    call UnitAddAbility(c, AstaSword2_ID)
                    call StopSpellUnit(c)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set e = null
                    set e2 = null
                    set g = null
                    set td = null
                    set g2 = null
                    set c = null
                    set m_AstaT2[i] = m_AstaT2[MUI_AstaT2]
                    set MUI_AstaT2 = MUI_AstaT2 - 1
                    set i = i - 1
                    call deallocate(this)
                    if MUI_AstaT2 == -1 then
                        call AstaTimer03Release()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AstaT2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            set MUI_AstaT2 = MUI_AstaT2 + 1
            set m_AstaT2[MUI_AstaT2] = this
            set c = NewC
            set r = 0.0
            set td = null
            set x = NewX
            set y = NewY
            set check = 0
            set k2 = 0
            set r2 = 10.0
            set r3 = 10.0
            set r4 = 0.0
            set g = CreateGroup()
            set g2 = CreateGroup()
            call StartSpellUnit(c)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_Astasword.mdx", c, "hand right")
            set aoe = AstaT2_DamageAoe
            set a = GAngle2(c, x, y)
            call MakeSound("war3mapImported\\Hero_Asta_T2 1")
            call MakeSound("war3mapImported\\Hero_Asta_T2 5")
            set dmg = GetHeroAgi(c, true) * AstaT2_DamageAgiBase
            set rmax = AstaT2_CastTime
            call UnitRemoveAbility(c, AstaSword2_ID)
            set move = 120.0
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SetUnitAnimationByIndex(c, 2)
            call SetUnitTimeScale(c, 0.21)
            call VisionTimed(GetOwningPlayer(c), x, y, 750, 6)
            if MUI_AstaT2 == 0 then
                call AstaTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct AstaSpells_F
        private static integer array m_AstaF
        private static integer MUI_AstaF = -1

        unit c
        real x
        real y
        real r2
        real r3
        real r5
        group g
        unit u
        real aoe
        real r
        effect e
        real rmax

        public static method Loop_AstaF takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AstaF
                set this = m_AstaF[i]
                if SpellBool(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    call BlzSetSpecialEffectPosition(e, x, y, 0)
                    if r3 > 0.16 then
                        set r3 = 0.0
                        call EUTU2(EffectSpawn("war3mapimported\\wos_krk (1971).mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 0.90, 1.25, 1), 1.25, 0, c)
                    else
                        set r3 = r3 + 0.03
                    endif
                    if r2 > AstaF_Interval then
                        set r2 = 0.0
                        set r5 = 0.0
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if not IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                call DebuffClear(u)
                            endif
                            if c != u and SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                set r5 = (GetUnitState(u, UNIT_STATE_MAX_MANA) * (AstaF_ManaSteal / 100.0)) / 4.0
                                if r5 > 0.0 then
                                    call SetMpCurrent(c, r5)
                                    call SetMpCurrent(u, -r5)
                                endif
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    else
                        set r2 = r2 + 0.03
                    endif
                else
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.35)
                    call DestroyGroup(g)
                    set e = null
                    set g = null
                    set c = null
                    set m_AstaF[i] = m_AstaF[MUI_AstaF]
                    set MUI_AstaF = MUI_AstaF - 1
                    set i = i - 1
                    call deallocate(this)
                    if MUI_AstaF == -1 then
                        call AstaTimer03Release()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AstaF_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_AstaF = MUI_AstaF + 1
            set m_AstaF[MUI_AstaF] = this
            set c = NewC
            set r = 0.0
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r2 = 10.0
            set r3 = 10.0
            set rmax = AstaF_Duration
            set g = CreateGroup()
            set e = EffectSpawnScale("war3mapimported\\wos_Evoriginheiqichanrao02red.mdx", x, y, GetRandomReal(0, 359), 1, 0.2, 1, 0.3, 0.2, 2.1)
            set aoe = AstaF_AoE
            call MakeSound("war3mapImported\\Hero_Asta_F")
            call MakeSound("war3mapImported\\Hero_Asta_F2")
            call Asta_RestoreOrder(c, 8)
            if MUI_AstaF == 0 then
                call AstaTimer03Acquire()
            endif
        endmethod
    endstruct

    //===========================================================================
    // Таймерные петли и точка входа библиотеки
    //===========================================================================
    private function AstaTimer03Loop takes nothing returns nothing
        call AstaSpells_Q.Loop_AstaQ()
        call AstaSpells_Q.Loop_AstaQ2()
        call AstaSpells_Q.Loop_AstaQ3()
        call AstaSpells_W.Loop_AstaW()
        call AstaSpells_W.Loop_AstaW2()
        call AstaSpells_E.Loop_AstaE()
        call AstaSpells_R.Loop_AstaR()
        call AstaSpells_R.Loop_AstaR2()
        call AstaSpells_T.Loop_AstaT2()
        call AstaSpells_F.Loop_AstaF()
    endfunction

    private function AstaTimer05Loop takes nothing returns nothing
        call AstaSpells_T.Loop_AstaT()
    endfunction

    private function InitAstaSpells takes nothing returns nothing
        set AstaTimer03 = CreateTimer()
        set AstaTimer03Callback = function AstaTimer03Loop
        set AstaTimer05 = CreateTimer()
        set AstaTimer05Callback = function AstaTimer05Loop
    endfunction

    //===========================================================================
    // Публичный интерфейс
    //===========================================================================
    function AstaQ_Start takes unit c, real x, real y returns nothing
        call AstaSpells_Q.AstaQ_Start(c, x, y)
    endfunction
    function AstaQ2_Start takes unit c, real x, real y returns nothing
        call AstaSpells_Q.AstaQ2_Start(c, x, y)
    endfunction
    function AstaW_Start takes unit c, real x, real y returns nothing
        call AstaSpells_W.AstaW_Start(c, x, y)
    endfunction
    function AstaW2_Start takes unit c, unit td returns nothing
        call AstaSpells_W.AstaW2_Start(c, td)
    endfunction
    function AstaE_Start takes unit c returns nothing
        call AstaSpells_E.AstaE_Start(c)
    endfunction
    function AstaR_Start takes unit c, unit td returns nothing
        call AstaSpells_R.AstaR_Start(c, td)
    endfunction
    function AstaR2_Start takes unit c, unit td returns nothing
        call AstaSpells_R.AstaR2_Start(c, td)
    endfunction
    function AstaT_Start takes unit c returns nothing
        call AstaSpells_T.AstaT_Start(c)
    endfunction
    function AstaT2_Start takes unit c, real x, real y returns nothing
        call AstaSpells_T.AstaT2_Start(c, x, y)
    endfunction
    function AstaF_Start takes unit c returns nothing
        call AstaSpells_F.AstaF_Start(c)
    endfunction
endlibrary