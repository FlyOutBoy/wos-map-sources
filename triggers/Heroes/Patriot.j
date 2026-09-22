library PatriotSpells initializer InitPatriotSpells uses GearSystems
    globals
        private timer PatriotTimer03
        private code PatriotTimer03Callback
        private integer PatriotTimer03Users = 0

        // --------------------------------------------------------------------------
        // Patriot Core & UI Frames
        // --------------------------------------------------------------------------
        integer Patriot_ID = 'H02A'
        framehandle array framePatriot_pas1 [10]
        framehandle array framePatriot_pas2 [10]
        framehandle array framePatriot_pas3 [10]
        framehandle array framePatriot_pas4 [10]
        framehandle array framePatriot_pas5 [10]
        framehandle array framePatriot_pas6 [10]
        unit array patdummy1

        // --------------------------------------------------------------------------
        // Q Ability (Halberd Thrust / Spear Throw)
        // --------------------------------------------------------------------------
        integer PatriotQ_ID = 'A0E7'
        real PatriotQ_DamageAgiBase = 1.0
        real PatriotQ_DamageAgiStep = 1.0
        real PatriotQ_Damage2StaticBase = 150.0
        real PatriotQ_Damage2StaticStep = 0.0
        real PatriotQ_DamageAoe = 235.0
        real PatriotQ_DamageAoe2 = 475.0
        real PatriotQ_RangeBase = 1200.0
        real PatriotQ_RangeStep = 100.0
        real PatriotQ_TimeSwap = 4.0
        real PatriotTQ_AoeBonus = 35.0
        real PatriotQ_RuinationAgiBonus = 2.0
        real PatriotQ_CastTime = 0.60
        boolean PatriotQ_IsInvul = false
        integer PatriotQ_SlowPercent = 30
        integer PatriotQ_SlowDuration = 2
        real PatriotQ_StunDuration = 1.00
        real PatriotQ_DecorDamage = 25.0
        real PatriotQ_DecorExpDamage = 40.0

        // --------------------------------------------------------------------------
        // W Ability (Sacred Territory / Halberd Stomp)
        // --------------------------------------------------------------------------
        integer PatriotW_ID = 'A0E8'
        integer PatriotW_Buff1_ID = 'B01X'
        integer PatriotW_Buff21_ID = 'B01Y'
        integer PatriotW_Buff22_ID = 'B021'
        integer PatriotW_Buff23_ID = 'B022'
        integer PatriotW_Buff24_ID = 'B023'
        integer PatriotW_Buff25_ID = 'B024'
        real PatriotW_DamageAgiBase = 1.0
        real PatriotW_DamageAgiStep = 0.0
        real PatriotW_Damage2StaticBase = 30.0
        real PatriotW_Damage2StaticStep = 0.0
        real PatriotW_HealAgiBase = 0.5
        real PatriotW_HealAgiStep = 0.0
        real PatriotW_Heal2StaticBase = 0.0
        real PatriotW_Heal2StaticStep = 0.0
        integer PatriotW_DurationBase = 3
        integer PatriotW_DurationStep = 1
        real PatriotW_PulseInterval = 0.98
        real PatriotW_DamageAoe = 650.0
        real PatriotW_CastTime = 0.51
        boolean PatriotW_IsInvul = false
        real PatriotW_DecorDamage = 25.0
        real PatriotW_DecorExpDamage = 40.0

        // --------------------------------------------------------------------------
        // E Ability (Stance Switch / Perseverance Stance)
        // --------------------------------------------------------------------------
        integer PatriotE_ID = 'A0E9'
        real PatriotE_MissHpCountPercent = 20.0
        real PatriotE_DmgBonusBase = 1.0
        real PatriotE_DmgBonusStep = 1.0
        real PatriotE_DmgReductBase = 1.0
        real PatriotE_DmgReductStep = 1.0
        real PatriotEE_Duration = 5.0
        real PatriotE_CDReductBase = 2.0
        real PatriotE_CDReductStep = 0.5
        real PatriotE_CDReductR = 2.0

        // --------------------------------------------------------------------------
        // R Ability (Phalanx March / Shield Wall)
        // --------------------------------------------------------------------------
        integer PatriotR_ID = 'A0EA'
        real PatriotR_DamageAoe = 455.0
        real PatriotR_PushRange = 300.0
        real PatriotR_RangeBase = 1300.0
        real PatriotR_RangeStep = 50.0
        real PatriotR_PushDuration = 0.30
        real PatriotR_DamageAgiBase = 4.0
        real PatriotR_DamageAgiStep = 1.0
        real PatriotR2_DamageAgiBase = 0.50
        real PatriotR2_DamageAgiStep = 0.25
        real PatriotR_CastTime = 0.30
        real PatriotR_Duration = 2.10
        boolean PatriotR_IsInvul = false
        real PatriotR_DecorDamage = 50.0

        // --------------------------------------------------------------------------
        // T & T2 Abilities (Phalanx Bastion / Catastrophic Javelin)
        // --------------------------------------------------------------------------
        integer PatriotT_ID = 'A0EB'
        integer PatriotT2_ID = 'A0EC'
        real PatriotT_Duration = 4.0
        real PatriotT_DamageAgiBase = 3.5
        real PatriotT_DamageAoe = 800.0
        real PatriotT_EdgeInset = 150.0
        real PatriotT_CastTime = 0.97
        boolean PatriotT_IsInvul = false
        real PatriotT_DecorDamage = 50.0

        real PatriotT2_DamageAgiBase = 10.0
        real PatriotT2_DamageAoe = 750.0
        real PatriotT2_Range = 4000.0
        real PatriotT2_CastTime = 1.50
        real PatriotT2_Duration = 0.90
        boolean PatriotT2_IsInvul = true
        real PatriotT2_DecorDamage = 100.0

        // --------------------------------------------------------------------------
        // F & F2 Abilities (Shield Rush / Vanguard Advance)
        // --------------------------------------------------------------------------
        integer PatriotF_ID = 'A0EE'
        integer PatriotF2_ID = 'A0ED'
        integer PatriotF_Buff1_ID = 'B01Z'
        integer PatriotF_Buff2_ID = 'B020'
        real PatriotF_Buff1_Resist = 40.0
        real PatriotF_Buff2_Resist = 20.0
        real PatriotF_AoE = 450.0
        real PatriotF_Duration = 4.0
        boolean PatriotF_IsInvul = false
        real PatriotF_DecorDamage = 10.0

        // --------------------------------------------------------------------------
        // G Ability (Veteran Wendigo - Passive Strike)
        // --------------------------------------------------------------------------
        integer PatriotG_ID = 'A0EF'
        real PatriotG_DamageAgiBase = 1.0
        real PatriotG_CD_Atk = 0
        real PatriotG_CD_Def = 2.0
        integer PatriotG_Lvl_CD = 12
    endglobals

    // ===========================================================================
    // Order Tracking & Animation Restore Module
    // ===========================================================================
    private function OnPatriotPointOrder takes nothing returns boolean
        local unit u = GetOrderedUnit()
        local integer ord = GetIssuedOrderId()
        if GetUnitTypeId(u) == Patriot_ID then
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

    private function OnPatriotTargetOrder takes nothing returns boolean
        local unit u = GetOrderedUnit()
        local integer ord = GetIssuedOrderId()
        if GetUnitTypeId(u) == Patriot_ID then
            if ord == 851971 or ord == 851983 then
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_mode"), 2)
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_id"), ord)
                call SaveUnitHandle(hs, GetHandleId(u), StringHash("ord_target"), GetOrderTargetUnit())
            endif
        endif
        set u = null
        return false
    endfunction

    private function OnPatriotImmediateOrder takes nothing returns boolean
        local unit u = GetOrderedUnit()
        local integer ord = GetIssuedOrderId()
        if GetUnitTypeId(u) == Patriot_ID then
            if ord == 851972 or ord == 851993 then
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_mode"), 0)
            endif
        endif
        set u = null
        return false
    endfunction

    function Patriot_RestoreOrder takes unit c, integer animIndex returns nothing
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

    private struct PatriotOrderInit extends array
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
            call TriggerAddCondition(tPoint, Condition(function OnPatriotPointOrder))
            call TriggerAddCondition(tTarget, Condition(function OnPatriotTargetOrder))
            call TriggerAddCondition(tImmediate, Condition(function OnPatriotImmediateOrder))
            set tPoint = null
            set tTarget = null
            set tImmediate = null
        endmethod
    endstruct

    // ===========================================================================
    // Timer Management
    // ===========================================================================
    private function PatriotTimer03Acquire takes nothing returns nothing
        set PatriotTimer03Users = PatriotTimer03Users + 1
        if PatriotTimer03Users == 1 then
            call TimerStart(PatriotTimer03, 0.03, true, PatriotTimer03Callback)
        endif
    endfunction

    private function PatriotTimer03Release takes nothing returns nothing
        set PatriotTimer03Users = PatriotTimer03Users - 1
        if PatriotTimer03Users <= 0 then
            set PatriotTimer03Users = 0
            call PauseTimer(PatriotTimer03)
        endif
    endfunction

    // ===========================================================================
    // Core Helpers
    // ===========================================================================
    function PatriotPas takes unit c, unit td returns nothing
        local real x
        local real y
        if (c == null or td == null) or (GetWidgetLife(td) <= 0.405) or (BlzGetUnitAbilityCooldownRemaining(c,PatriotG_ID)>0.1) then
            return
        endif
        set x = GetUnitX(td)
        set y = GetUnitY(td)
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", td, "chest"))
        call EUTU2_3(EffectSpawn("war3mapImported\\wos_Satsu-WWSFX-1.mdx", x, y, 0.0, 1.25, 2.0, 75.0), 0.76, 75.0, td)
        call NextDmg(c, td, PatriotG_DamageAgiBase * GetHeroAgi(c, true), 0, 0.10)
        if LoadInteger(hs, GetHandleId(c), StringHash("patriot e")) == 1 then
        if PatriotG_CD_Atk >0 then 
            call BlzStartUnitAbilityCooldown(c,PatriotG_ID,PatriotG_CD_Atk)
            endif
        else
            call BlzStartUnitAbilityCooldown(c,PatriotG_ID,PatriotG_CD_Def)
        endif
    endfunction

    function BuffUnitPat takes unit c, unit u, integer level returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        if patdummy1[i] == null or GetWidgetLife(patdummy1[i]) < 1.0 then
            set patdummy1[i] = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'h0C9', GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster), 0.0)
            call UnitAddAbility(patdummy1[i], 'A0EG')
        endif
        if level > 0 then
            if GetUnitAbilityLevel(patdummy1[i], 'A0EG') == 0 then
                call UnitAddAbility(patdummy1[i], 'A0EG')
            endif
            call SetUnitAbilityLevel(patdummy1[i], 'A0EG', level)
            call SetUnitFacing(patdummy1[i], GAngle(patdummy1[i], u) * bj_RADTODEG)
            call IssueTargetOrder(patdummy1[i], "innerfire", u)
        endif
    endfunction

    // ===========================================================================
    // Abilities MUI Implementation
    // ===========================================================================
    private struct PatriotSpells_Q
        private static integer array m_PatriotQ
        private static integer MUI_PatriotQ = -1

        unit c
        unit td
        real x
        real y
        real r2
        integer k2
        integer k3
        real r5
        real r6
        real r7
        real r4
        group g
        group g2
        real dmg
        integer check3
        integer check4
        real aoe
        real move
        real r
        effect e
        effect e3
        real a
        real rmax

        public static method Loop_PatriotQ takes nothing returns nothing
            local integer i = 0
            local thistype this
            local unit u = null
            local real x1
            local real y1
            local real x2
            local real y2
            local real x3
            local real y3
            local real arenaAngle
            local boolean remove

            loop
                exitwhen i > MUI_PatriotQ
                set this = m_PatriotQ[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or not SpellBoolCaster(c) or r > rmax then
                    set remove = true
                else
                    set r = RoundReal(r + 0.03, 3)
                    if r < PatriotQ_CastTime then
                        call DebugUnit2(c)
                    endif

                    if r == PatriotQ_CastTime then
                        call MakeSound("war3mapimported\\Hero_Patriot_Q2")
                        set e = EffectSpawn4("war3mapImported\\wos_PatriotsSpear.mdx", GetUnitX(c) + 150.0 * Cos(a), GetUnitY(c) + 150.0 * Sin(a), a * bj_RADTODEG, 0.65, 1.0, 155.0, -20.0)
                        set e3 = EffectSpawn("Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl", GetUnitX(c) + 250.0 * Cos(a), GetUnitY(c) + 250.0 * Sin(a), a * bj_RADTODEG, 0.65, 1.0, 135.0)
                        call MoveEff(e3, 10.0, a)
                        set k3 = 0
                        call StopSpellUnit2(c)
                    endif

                    if r >= PatriotQ_CastTime+0.12 then
                        if k3 == 0 then
                            call MoveEff(e, move, a)
                            call MoveEff(e3, move, a)
                        endif

                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        if move > 80.0 then
                            set move = move - 1.25
                        endif

                        if r2 > 0.03 then
                            set r2 = 0.0
                            call DecorRemove(c, x, y, aoe, PatriotQ_DecorDamage)
                            call VisionTimed(GetOwningPlayer(c), x, y, 1000.0, 2.0)
                            call ColorEffDummy3(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_1.mdx", x, y, a * bj_RADTODEG, 1.25, 2.65, 180.0, 0, 0, 0, 255), 0.0, 0, 0, 0, 0.21)
                        else
                            set r2 = r2 + 0.03
                        endif

                        set r5 = r5 + move
                        set x1 = LoadReal(hs, GetHandleId(c), StringHash("w x"))
                        set y1 = LoadReal(hs, GetHandleId(c), StringHash("w y"))
                        set x2 = LoadReal(hs, GetHandleId(c), StringHash("r x"))
                        set y2 = LoadReal(hs, GetHandleId(c), StringHash("r y"))
                        set x3 = LoadReal(hs, GetHandleId(c), StringHash("t x"))
                        set y3 = LoadReal(hs, GetHandleId(c), StringHash("t y"))

                        if r5 >= r6 then
                            set r = 9999.0
                        endif

                        if x1 != 0.0 and SR5(e, x1, y1) < 150.0 then
                            set r = 9999.0
                            set k3 = 1
                            call SaveInteger(hs, GetHandleId(c), StringHash("w act"), 1)
                            call BlzSetSpecialEffectPosition(e, x1, y1, 25.0)
                        endif

                        if x2 != 0.0 and SR5(e, x2, y2) < 275.0 then
                            set k3 = 1
                            set r = 9999.0
                            call SaveInteger(hs, GetHandleId(c), StringHash("r act"), 1)
                            call BlzSetSpecialEffectPosition(e, x2, y2, 25.0)
                        endif

                        if x3 != 0.0 or y3 != 0.0 then
                            set r4 = SR5(e, x3, y3)
                            if check3 == 0 then
                                set r7 = r4
                                set check3 = 1
                            else
                                // The T arena is one-way for the Q spear: an outward
                                // crossing stops at the inner edge, while an inward
                                // crossing remains free to carry enemies into it.
                                if r7 <= PatriotT_DamageAoe - PatriotT_EdgeInset and r4 > PatriotT_DamageAoe - PatriotT_EdgeInset then
                                    set k3 = 1
                                    call SaveInteger(hs, GetHandleId(c), StringHash("t act"), 1)
                                    set arenaAngle = Atan2(y - y3, x - x3)
                                    set x = x3 + (PatriotT_DamageAoe - PatriotT_EdgeInset) * Cos(arenaAngle)
                                    set y = y3 + (PatriotT_DamageAoe - PatriotT_EdgeInset) * Sin(arenaAngle)
                                    call BlzSetSpecialEffectPosition(e, x, y, 25.0)
                                endif
                                set r7 = r4
                            endif
                        endif

                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
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
                                    if GetHeroLevel(c) >= 35 then
                                        call PatriotPas(c, u)
                                    endif
                                    call GroupAddUnit(g2, u)
                                    call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_FSAeff (198)1.mdl", u, "chest"))
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                if td == null then
                                    set td = u
                                endif
                                if check4 == 0 then
                                    call SlowUnit(c, u, PatriotQ_SlowPercent, PatriotQ_SlowDuration)
                                endif
                                if td != null and SpellBool(td) then
                                    set x1 = x + move * Cos(a)
                                    set y1 = y + move * Sin(a)
                                    // A carried target that has entered T may not be
                                    // pushed back through its wall. Keep it near the
                                    // edge instead of dragging it toward the center.
                                    if (x3 != 0.0 or y3 != 0.0) and SR3(td, x3, y3) <= PatriotT_DamageAoe then
                                        set r4 = SquareRoot((x1 - x3) * (x1 - x3) + (y1 - y3) * (y1 - y3))
                                        if r4 > PatriotT_DamageAoe - PatriotT_EdgeInset then
                                            set r4 = Atan2(y1 - y3, x1 - x3)
                                            set x1 = x3 + (PatriotT_DamageAoe - PatriotT_EdgeInset) * Cos(r4)
                                            set y1 = y3 + (PatriotT_DamageAoe - PatriotT_EdgeInset) * Sin(r4)
                                        endif
                                    endif
                                    call PosUnit(td, x1, y1)
                                endif
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                endif

                if remove then
                    set x = GetEffX(e)
                    set y = GetEffY(e)
                    call DecorRemove(c, x, y, aoe, PatriotQ_DecorExpDamage)
                    call VisionTimed(GetOwningPlayer(c), x, y, 1000.0, 2.0)
                    call EffectSpawn2("war3mapimported\\wos_LD2209 (157).mdx", x, y, GetRandomReal(0, 359), 1.0, 1.8, 0.0, 1.0)
                    call EffectSpawn2("war3mapimported\\wos_LD2209 (157).mdx", x, y, GetRandomReal(0, 359), 1.0, 2.2, 0.0, 1.0)
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_dustgaraa2.mdx", x, y, GetRandomReal(0, 359), 1.0, 1.5, 0.0))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_dustgaraa2.mdx", x, y, GetRandomReal(0, 359), 1.0, 2.0, 0.0))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdl", x, y, GetRandomReal(0, 359), 1.0, 2.25, 0.0))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Eff_Ord_YeYe_Eat_DiBanZhaKai2.mdx", x, y, GetRandomReal(0, 359), 1.5, 1.35, 0.0))
                    call MakeSound("war3mapimported\\Hero_Patriot_Q3")
                    call DecorRemove(c, x, y, PatriotQ_DamageAoe2, PatriotQ_DecorExpDamage)

                    call GroupClear(g)
                    call GroupEnumUnitsInRange(g, x, y, PatriotQ_DamageAoe2, NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                            call GroupAddUnit(g2, u)
                            call dmgphys(c, u, dmg)
                            if GetHeroLevel(c) >= 35 then
                                call PatriotPas(c, u)
                            endif
                            if k3 == 1 then
                                call StunUnit(c, u, PatriotQ_StunDuration)
                            endif
                            if check4 == 0 then
                                call SlowUnit(c, u, PatriotQ_SlowPercent, PatriotQ_SlowDuration)
                            endif
                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop

                    call MyRemoveEff(e3, 0.15)
                    call BlzSetSpecialEffectPitch(e, -295.0 * bj_DEGTORAD)
                    if k3 == 0 then
                        call MoveEff(e, 100.0, a)
                    endif
                    call BlzSetSpecialEffectScale(e, 1.25)
                    call BlzSetSpecialEffectHeight(e, 25.0)
                    call ColorEffDummy3(e, 1.0, 255, 255, 255, 0.30)
                    call BlzSetSpecialEffectTimeScale(e, 1.15)

                    if g != null then
                        call DestroyGroup(g)
                    endif
                    if g2 != null then
                        call DestroyGroup(g2)
                    endif
                    set g = null
                    set g2 = null
                    set td = null
                    set c = null
                    set e = null
                    set e3 = null
                    set m_PatriotQ[i] = m_PatriotQ[MUI_PatriotQ]
                    set MUI_PatriotQ = MUI_PatriotQ - 1
                    call deallocate(this)
                    set i = i - 1
                    if MUI_PatriotQ == -1 then
                        call PatriotTimer03Release()
                    endif
                endif
                set i = i + 1
            endloop
            set u = null
        endmethod

        public static method PatriotQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            local integer level = GetUnitAbilityLevel(NewC, PatriotQ_ID)
            if level < 1 then
                set level = 1
            endif

            set MUI_PatriotQ = MUI_PatriotQ + 1
            set m_PatriotQ[MUI_PatriotQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set td = null
            set r = 0.0
            set r5 = 0.0
            set k3 = 0
            set k2 = 0
            set r6 = PatriotQ_RangeBase + (PatriotQ_RangeStep * (level - 1))
            set r2 = 1.0
            set check3 = 0
            set r7 = 0.0
            set g = CreateGroup()
            set g2 = CreateGroup()
            set check4 = 0
            set a = GAngle2(c, x, y)
            set rmax = 2.10
            set move = 100.0
            set aoe = PatriotQ_DamageAoe
            set dmg = GetHeroAgi(c, true) * (PatriotQ_DamageAgiBase + (PatriotQ_DamageAgiStep * (level - 1)))
            set dmg = dmg + PatriotQ_Damage2StaticBase + (PatriotQ_Damage2StaticStep * (level - 1))

            call StartSpellUnit2(c)
            call SetUnitFacing(c, a * bj_RADTODEG)
            call Patriot_RestoreOrder(c, 9)

            if LoadInteger(hs, GetHandleId(c), StringHash("patriot e")) == 1 then
                set check4 = 1
                set dmg = dmg + GetHeroAgi(c, true) * PatriotQ_RuinationAgiBonus
            endif

            call SetUnitTimeScale(c, 2.31)
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapimported\\Hero_Patriot_Q")
            else
                call MakeSound("war3mapimported\\Hero_Patriot_Q4")
            endif

            if MUI_PatriotQ == 0 then
                call PatriotTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct PatriotSpells_W
        private static integer array m_PatriotW
        private static integer MUI_PatriotW = -1

        unit c
        real x
        real y
        real r2
        integer k2
        integer k3
        real scale
        group g
        real dmg
        real dmg2
        real aoe
        real r
        effect e
        real a
        real rmax

        public static method Loop_PatriotW takes nothing returns nothing
            local integer i = 0
            local thistype this
            local unit u
            local boolean remove

            loop
                exitwhen i > MUI_PatriotW
                set this = m_PatriotW[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or not SpellBoolCaster(c) or r > rmax or LoadInteger(hs, GetHandleId(c), StringHash("w act")) != 0 or k3 >= k2 then
                    set remove = true
                else
                    set r = RoundReal(r + 0.03, 3)
                    if r == PatriotW_CastTime then
                        call MakeSound("war3mapImported\\Hero_Patriot_W4")
                        call GroupClear(g)
                        call SaveReal(hs, GetHandleId(c), StringHash("w x"), x)
                        call SaveReal(hs, GetHandleId(c), StringHash("w y"), y)
                        set e = EffectSpawn("war3mapImported\\wos_[tx][z]baofengshuijing4.mdl", x, y, 1.0, 1.0, 1.0, 0.0)
                        call BlzSetSpecialEffectAlpha(e, 0)
                        call ColorEffDummy4(e, 0.0, 255, 255, 255, 0.30)
                    endif

                    if r >= PatriotW_CastTime then
                        if r2 > 0.95 then
                            set k3 = k3 + 1
                            call GroupClear(g)
                            call DecorRemove(c, x, y, aoe, PatriotW_DecorDamage)
                            call VisionTimed(GetOwningPlayer(c), x, y, 1000.0, 2.0)
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-Hit-red.mdl", x, y, a * bj_RADTODEG, 1.0, 3.25 * scale, 200.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlashred.mdl", x + 25.0 * Cos(a), y + 25.0 * Sin(a), 1.0, 1.15, 3.0 * scale, 125.0))
                            call DestroyEffect(EffectSpawn3("war3mapImported\\wos_YC_Shockwave_b_red.mdl", x, y, a * bj_RADTODEG + 180.0, 1.25, 4.15 * scale, 125.0, 0.0))

                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call dmgmag(c, u, dmg)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                if IsUnitAlly(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    if LoadInteger(hs, GetHandleId(c), StringHash("patriot e")) == 1 then
                                        call BuffUnitPat(c, u, GetUnitAbilityLevel(c, PatriotW_ID) + 5)
                                    else
                                        call BuffUnitPat(c, u, GetUnitAbilityLevel(c, PatriotW_ID))
                                    endif
                                    call SetHpCurrent2(c, u, dmg2)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set r2 = 0.0
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                endif

                if remove then
                    if r >= PatriotW_CastTime then
                        call ColorEffDummy3(e, 0.0, 255, 255, 255, 0.30)
                    endif

                    if LoadInteger(hs, GetHandleId(c), StringHash("w act")) == 1 then
                        call MakeSound("war3mapImported\\Hero_Patriot_W3")
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_1hongse_2red.mdl", x, y, a * bj_RADTODEG + 180.0, 1.0, 6.35 * scale, 1.0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_effect_order_dange_yueyun_2withoutred.mdl", x, y, a * bj_RADTODEG, 1.0, 1.65 * scale, 1.0))
                        call DestroyEffect(EffectSpawn3("war3mapImported\\wos_YC_Shockwave_b_red.mdl", x, y, a * bj_RADTODEG + 180.0, 1.25, 4.85 * scale, 125.0, 0.0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_ZarakiWCrack1.mdl", x, y, GetRandomReal(0, 359), 1.25, 2.0 * scale, 5.0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-Hit-red.mdl", x, y, a * bj_RADTODEG, 1.0, 3.25 * scale, 200.0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-RSFX-4.mdl", x, y, a * bj_RADTODEG + 90.0, 0.5, 3.0 * scale, 1.0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_yz-leimitx13.mdl", x, y, a * bj_RADTODEG + 90.0, 2.5, 5.0 * scale, 1.0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_AZ_TS_TZRed.mdl", x, y, a * bj_RADTODEG + 90.0, 2.5, 4.0 * scale, 1.0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlashred.mdl", x + 25.0 * Cos(a), y + 25.0 * Sin(a), 1.0, 1.15, 2.475 * scale, 125.0))

                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                if k2 - k3 <= 1 then
                                    call dmgmag(c, u, dmg)
                                else
                                    call dmgmag(c, u, dmg * (k2 - k3))
                                endif
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif

                    call SaveInteger(hs, GetHandleId(c), StringHash("w act"), 0)
                    call SaveReal(hs, GetHandleId(c), StringHash("w x"), 0.0)
                    call SaveReal(hs, GetHandleId(c), StringHash("w y"), 0.0)

                    if g != null then
                        call DestroyGroup(g)
                    endif
                    set e = null
                    set g = null
                    set c = null
                    set u = null
                    set m_PatriotW[i] = m_PatriotW[MUI_PatriotW]
                    set MUI_PatriotW = MUI_PatriotW - 1
                    call deallocate(this)
                    set i = i - 1
                    if MUI_PatriotW == -1 then
                        call PatriotTimer03Release()
                    endif
                endif
                set i = i + 1
            endloop
            set u = null
        endmethod

        public static method PatriotW_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            local integer level = GetUnitAbilityLevel(NewC, PatriotW_ID)
            if level < 1 then
                set level = 1
            endif

            set MUI_PatriotW = MUI_PatriotW + 1
            set m_PatriotW[MUI_PatriotW] = this
            set c = NewC
            set r = 0.0
            set x = NewX
            set y = NewY
            set r2 = 10.0
            set g = CreateGroup()
            call SaveReal(hs, GetHandleId(c), StringHash("w x"), 0.0)
            call SaveReal(hs, GetHandleId(c), StringHash("w y"), 0.0)
            call SaveInteger(hs, GetHandleId(c), StringHash("w act"), 0)
            if GetHeroLevel(c) >= 35 then
            set PatriotW_CastTime = 0.03
            endif
            set aoe = PatriotW_DamageAoe
            set a = GAngle2(c, x, y)
            call MakeSound("war3mapImported\\Hero_Patriot_W")
            set k2 = PatriotW_DurationBase + (PatriotW_DurationStep * (level - 1))
            set dmg = GetHeroAgi(c, true) * (PatriotW_DamageAgiBase + (PatriotW_DamageAgiStep * (level - 1)))
            set dmg = dmg + PatriotW_Damage2StaticBase + (PatriotW_Damage2StaticStep * (level - 1))
            set dmg2 = GetHeroAgi(c, true) * (PatriotW_HealAgiBase + (PatriotW_HealAgiStep * (level - 1)))
            set dmg2 = dmg2 + PatriotW_Heal2StaticBase + (PatriotW_Heal2StaticStep * (level - 1))
            set rmax = 15.0
            set k3 = 0
            set scale = aoe / 800.0

            call SetUnitFacing(c, a * bj_RADTODEG)
            call Patriot_RestoreOrder(c, 3)
            call SetUnitTimeScale(c, 1.0)
            call VisionTimed(GetOwningPlayer(c), x, y, 750.0, 6.0)

            if MUI_PatriotW == 0 then
                call PatriotTimer03Acquire()
            endif
        endmethod
    endstruct

    // ===========================================================================
    // Master Timer Loop
    // ===========================================================================
    private struct PatriotSpells_E
        private static integer array m_PatriotE
        private static integer MUI_PatriotE = -1

        unit c
        unit td
        integer id
        integer id2
        real x1
        real y1
        framehandle array frame_pas1 [12]
        framehandle array frame_pas2 [12]
        framehandle array frame_pas3 [12]
        framehandle array frame_pas4 [12]
        framehandle array frame_pas5 [12]
        framehandle array frame_pas6 [12]
        integer k2
        real r
        effect e2
        real rmax

        public static method Loop_PatriotE takes nothing returns nothing
            local integer i = 0
            local thistype this
            local boolean remove

            loop
                exitwhen i > MUI_PatriotE
                set this = m_PatriotE[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or not SpellBoolCaster(c) or r > rmax then
                    set remove = true
                else
                    if not IsUnitPaused(c) then
                        set r = RoundReal(r + 0.03, 3)
                    endif

                    if r == 0.03 then
                        if GetLocalPlayer() == GetOwningPlayer(c) then
                            call ClearSelection()
                            call SelectUnit(c, true)
                            call PanCameraToTimed(GetUnitX(c), GetUnitY(c), 0.0)
                        endif
                    endif

                    call BlzFrameSetValue(frame_pas3[k2], rmax - (r + 0.05))
                    if rmax - r >= 0.0 then
                        call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                    endif
                    set x1 = GetUnitX(c)
                    set y1 = GetUnitY(c)
                endif

                if remove then
                    if c != null and GetUnitTypeId(c) != 0 then
                        call PlayersMsg(GetPlayerVisualColorString(Player(id)) + GetPlayerName(Player(id)) + "|r killed " + GetPlayerVisualColorString(Player(id2)) + GetPlayerName(Player(id2)) + "|r", 2)
                        call KillUnit(c)
                        if GetLocalPlayer() == GetOwningPlayer(c) then
                            call BlzFrameSetVisible(frame_pas1[k2], false)
                        endif
                        call SaveInteger(hs, GetHandleId(c), StringHash("patriot ee"), 0)
                        call SaveInteger(hs, GetHandleId(c), StringHash("patriot e"), 0)
                        call AddUnitAnimationProperties(c, "alternate", false)
                        call AAUniversalTooltips_SetUnitForm(c, 0)
                    endif
                    if e2 != null then
                        call DestroyEffect(e2)
                    endif
                    set c = null
                    set td = null
                    set e2 = null
                    set m_PatriotE[i] = m_PatriotE[MUI_PatriotE]
                    set MUI_PatriotE = MUI_PatriotE - 1
                    call deallocate(this)
                    set i = i - 1
                    if MUI_PatriotE == -1 then
                        call PatriotTimer03Release()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method PatriotE_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create()
            local real tmp_y = 0.0
            local real cd1
            local real dmg

            set MUI_PatriotE = MUI_PatriotE + 1
            set m_PatriotE[MUI_PatriotE] = this
            set c = NewC
            set td = NewTd
            set id = GetPlayerId(GetOwningPlayer(td))
            set id2 = GetPlayerId(GetOwningPlayer(c))
            set cd1 = BlzGetUnitAbilityCooldownRemaining(c, PatriotT_ID)
            set r = 0.0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set rmax = PatriotEE_Duration

            call ReviveHero(c, GetUnitX(c), GetUnitY(c), true)
            set dmg = GetUnitState(c, UNIT_STATE_MAX_LIFE) * 0.10
            call SetUnitState(c, UNIT_STATE_LIFE, dmg)

            call SetPlayerAbilityAvailable(GetOwningPlayer(c), PatriotF_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), PatriotT_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), PatriotF2_ID, true)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), PatriotT2_ID, true)
            call UnitAddAbility(c, PatriotF2_ID)
            if GetUnitAbilityLevel(c, PatriotT_ID) > 0 then
                call UnitAddAbility(c, PatriotT2_ID)
                call BlzStartUnitAbilityCooldown(c, PatriotT2_ID, cd1)
            endif

            call AddUnitAnimationProperties(c, "alternate", true)
            call Patriot_RestoreOrder(c, 4)
            call SaveInteger(hs, GetHandleId(c), StringHash("patriot e"), 1)
            call SaveInteger(hs, GetHandleId(c), StringHash("patriot ee"), 1)
            call AddSpellLevel(c, 'A01C', 10, true)
            call BlzSetAbilityIcon(PatriotE_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Patriot_E2.blp")

            call AAUniversalTooltips_SetUnitForm(c, 2)

            if frame_pas1[k2] == null then
                set frame_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                call BlzFrameSetAbsPoint(frame_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18 + tmp_y)
                call BlzFrameSetSize(frame_pas1[k2], 0.135, 0.035)
                call BlzFrameSetTexture(frame_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                call BlzFrameSetVisible(frame_pas1[k2], false)
                if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frame_pas1[k2], true)
                endif
                set frame_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame_pas1[k2], 0, 0)
                call BlzFrameSetAbsPoint(frame_pas2[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
                call BlzFrameSetSize(frame_pas2[k2], 0.1, 0.019)
                set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)
                call BlzFrameSetSize(frame_pas3[k2], 0.1, 0.035)
                call BlzFrameSetScale(frame_pas3[k2], 0.5)
                call BlzFrameSetModel(frame_pas3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                call BlzFrameSetAbsPoint(frame_pas3[k2], FRAMEPOINT_CENTER, 0.05, 0.175 + tmp_y)
                call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, rmax + 1)
                call BlzFrameSetValue(frame_pas3[k2], rmax)
                set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18 + tmp_y)
                call BlzFrameSetSize(frame_pas4[k2], 0.03, 0.03)
                call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Patriot_E2", 0, false)
                set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
                call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Perseverance Stance:" + "|r")
                call BlzFrameSetScale(frame_pas5[k2], 0.9)
                set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17 + tmp_y)
                call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                call BlzFrameSetScale(frame_pas6[k2], 0.9)
            else
                if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frame_pas1[k2], true)
                endif
                call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, rmax + 1)
                call BlzFrameSetValue(frame_pas3[k2], rmax)
            endif

            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_DingZhi_BY_Wood_Effect_Bleach_LvSeQiLiu2.mdx", c, "origin")
            call MakeSound("war3mapImported\\Hero_Patriot_EE")
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapImported\\Hero_Patriot_EE2")
            else
                call MakeSound("war3mapImported\\Hero_Patriot_EE3")
            endif
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_krk (1971).mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1.0, 1.25, 1.0))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)3small.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1.0, 3.0, 145.0))

            if MUI_PatriotE == 0 then
                call PatriotTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct PatriotSpells_R
        private static integer array m_PatriotR
        private static integer MUI_PatriotR = -1

        unit c
        real x1
        real y1
        real r2
        integer k
        real r3
        real r5
        real r6
        real r7
        group g
        group g2
        real dmg
        real dmg2
        integer check
        real aoe
        real move
        real r
        effect array ee [40]
        real a
        real rmax

        public static method Loop_PatriotR takes nothing returns nothing
            local integer i = 0
            local thistype this
            local unit u
            local real x
            local real y
            local boolean remove

            loop
                exitwhen i > MUI_PatriotR
                set this = m_PatriotR[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or not SpellBoolCaster(c) or r > rmax then
                    set remove = true
                else
                    set r = RoundReal(r + 0.03, 3)
                    if check == 0 then
                        if r > PatriotR_CastTime then
                            set r5 = r5 + move
                            if r5 > r7 or LoadInteger(hs, GetHandleId(c), StringHash("r act")) == 1 then
                                set r = 0.0
                                set r2 = 255.0
                                set rmax = PatriotR_Duration
                                set check = 1
                                call SaveReal(hs, GetHandleId(c), StringHash("r x"), x1)
                                call SaveReal(hs, GetHandleId(c), StringHash("r y"), y1)
                            endif

                            set x1 = x1 + move * Cos(a)
                            set y1 = y1 + move * Sin(a)
                            call SaveReal(hs, GetHandleId(c), StringHash("r x"), x1)
                            call SaveReal(hs, GetHandleId(c), StringHash("r y"), y1)

                            set k = 0
                            loop
                                exitwhen k == 3
                                call MoveEff2(ee[k], move, a)
                                call MoveEff2(ee[k + 4], move, a)
                                set k = k + 1
                            endloop

                            if r2 > 0.0 then
                                call GroupClear(g)
                                set r6 = r7 - r5 + move
                                if r6 < 0.0 then
                                    set r6 = 0.0
                                endif
                                call DecorRemove(c, x1, y1, aoe, PatriotR_DecorDamage)
                                call VisionTimed(GetOwningPlayer(c), x1, y1, 1000.0, 2.0)
                                call GroupEnumUnitsInRange(g, x1, y1, aoe, NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                        if not IsUnitInGroup(u, g2) then
                                            call dmgphys(c, u, dmg)
                                            if GetHeroLevel(c) >= 35 then
                                                call PatriotPas(c, u)
                                            endif
                                            call GroupAddUnit(g2, u)
                                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                        endif
                                        if GetWidgetLife(u) > 0.405 then
                                            call MoveUnit(u, move * 2.15, a)
                                        endif
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                                set r2 = 0.0
                            else
                                set r2 = r2 + 0.03
                            endif

                            if r3 > 0.12 then
                                set k = 0
                                loop
                                exitwhen k == 3
                                    set x = GetEffX(ee[k])
                                    set y = GetEffY(ee[k])
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun2.mdl", x + 250.0 * Cos(a), y + 250.0 * Sin(a), a * bj_RADTODEG, 0.90, 2.25, 50.0, 255, 255, 255, 190))
                                    set k = k + 1
                                endloop
                                set r3 = 0.0
                            else
                                set r3 = r3 + 0.03
                            endif
                        endif
                    else
                        call SaveReal(hs, GetHandleId(c), StringHash("r x"), x1)
                        call SaveReal(hs, GetHandleId(c), StringHash("r y"), y1)

                        if r == 1.02 then
                            set k = 0
                            loop
                                exitwhen k == 3
                                call DestroyEffect(ee[k + 4])
                                set ee[k + 4] = null
                                set k = k + 1
                            endloop
                        endif

                        if r2 > 0.45 then
                            set k = 0
                            loop
                                exitwhen k == 3
                                set x = GetEffX(ee[k])
                                set y = GetEffY(ee[k])
                                if k == 1 then
                                    call DecorRemove(c, x, y, aoe, 25.0)
                                    call VisionTimed(GetOwningPlayer(c), x, y, 1000.0, 2.0)
                                endif
                                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun2.mdl", x + 250.0 * Cos(a), y + 250.0 * Sin(a), a * bj_RADTODEG, 0.95, 2.25, 50.0, 255, 255, 255, 190))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_3yue_5.mdl", x, y, GetRandomReal(0, 359), 1.5, 0.6, 0.0))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_LD2209 (157).mdx", x, y, GetRandomReal(0, 359), 1.0, 1.0, 0.0))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdl", x, y, GetRandomReal(0, 359), 1.0, 1.25, 0.0))
                                set k = k + 1
                            endloop

                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x1, y1, aoe + 75.0, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call dmgphys(c, u, dmg2)
                                    if GetHeroLevel(c) >= 35 then
                                        call PatriotPas(c, u)
                                    endif
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    if GetWidgetLife(u) > 0.405 then
                                        call MUE(u, 100.0, 0.09, a)
                                    endif
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set r2 = 0.0
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                endif

                if remove then
                    set k = 0
                    loop
                        exitwhen k == 3
                        call ColorEffDummy3(ee[k], 0.0, 255, 255, 255, 0.30)
                        if check == 0 or (check == 1 and r < 1.02) then
                            call DestroyEffect(ee[k + 4])
                            set ee[k + 4] = null
                        endif
                        set ee[k] = null
                        set k = k + 1
                    endloop
                    call SetUnitTimeScale(c, 1.0)
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    if g2 != null then
                        call DestroyGroup(g2)
                    endif
                    call SaveInteger(hs, GetHandleId(c), StringHash("r act"), 0)
                    call SaveReal(hs, GetHandleId(c), StringHash("r x"), 0.0)
                    call SaveReal(hs, GetHandleId(c), StringHash("r y"), 0.0)
                    set c = null
                    set g = null
                    set g2 = null
                    set u = null
                    set m_PatriotR[i] = m_PatriotR[MUI_PatriotR]
                    set MUI_PatriotR = MUI_PatriotR - 1
                    call deallocate(this)
                    set i = i - 1
                    if MUI_PatriotR == -1 then
                        call PatriotTimer03Release()
                    endif
                endif
                set i = i + 1
            endloop
            set u = null
        endmethod

        public static method PatriotR_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            local real xxx
            local real yyy
            local real maxRange
            local integer level = GetUnitAbilityLevel(NewC, PatriotR_ID)
            if level < 1 then
                set level = 1
            endif

            set MUI_PatriotR = MUI_PatriotR + 1
            set m_PatriotR[MUI_PatriotR] = this
            set c = NewC
            set r = 0.0
            set r2 = 10.0
            set r3 = 10.0
            set check = 0
            call SaveInteger(hs, GetHandleId(c), StringHash("r act"), 0)
            set r5 = 0.0
            set maxRange = PatriotR_RangeBase + (PatriotR_RangeStep * (level - 1))
            set r7 = maxRange
            set move = 40.0
            set aoe = PatriotR_DamageAoe
            set g = CreateGroup()
            set g2 = CreateGroup()
            set dmg = GetHeroAgi(c, true) * (PatriotR_DamageAgiBase + (PatriotR_DamageAgiStep * (level - 1)))
            set dmg2 = GetHeroAgi(c, true) * (PatriotR2_DamageAgiBase + (PatriotR2_DamageAgiStep * (level - 1)))
            set rmax = 3.0

            if LoadInteger(hs, GetHandleId(c), StringHash("patriot e")) == 1 then
                // Стойка Сокрушения: спавн СТРОГО в точке клика курсора
                set xxx = NewX
                set yyy = NewY
                // Направление марша: от точки клика прямо навстречу Патриоту
                set a = GAngle4(NewX, NewY, GetUnitX(c), GetUnitY(c))
            else
                // Маршевая стойка: спавн перед Патриотом и марш вперед от него
                set a = GAngle2(c, NewX, NewY)
                set xxx = GetUnitX(c) + 100.0 * Cos(a)
                set yyy = GetUnitY(c) + 100.0 * Sin(a)
            endif

            set k = 0
            loop
                exitwhen k == 3
                set x1 = xxx + (-125.0 + 125.0 * k) * Cos(a - 90.0 * bj_DEGTORAD)
                set y1 = yyy + (-125.0 + 125.0 * k) * Sin(a - 90.0 * bj_DEGTORAD)
                set ee[k] = EffectSpawn("war3mapimported\\wos_PatriotSoldier01.mdx", x1, y1, a * bj_RADTODEG, 0.5, 1.0, 0.0)
                call ColorEffDummy4(ee[k], 0.0, 255, 255, 255, 0.30)
                call BlzPlaySpecialEffect(ee[k], ANIM_TYPE_ATTACK)
                call AnimDummyEff(ee[k], 0.60, 0)
                set ee[k + 4] = EffectSpawn("war3mapimported\\wos_Windwalk Black.mdx", x1, y1, a * bj_RADTODEG, 1.0, 1.0, 0.0)
                set k = k + 1
            endloop
            set x1 = xxx
            set y1 = yyy

            call MakeSound("war3mapImported\\Hero_Patriot_R2")
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapImported\\Hero_Patriot_R")
            else
                call MakeSound("war3mapImported\\Hero_Patriot_R3")
            endif

            if MUI_PatriotR == 0 then
                call PatriotTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct PatriotSpells_T
        private static integer array m_PatriotT
        private static integer MUI_PatriotT = -1

        unit c
        real x
        real y
        real r2
        integer k
        integer k3
        real r3
        real r4
        group g
        group g2
        real dmg
        integer check2
        real aoe
        real r
        effect array ee [40]
        real rmax

        public static method Loop_PatriotT takes nothing returns nothing
            local integer i = 0
            local thistype this
            local unit u
            local real x1
            local real y1
            local real distance
            local boolean remove

            loop
                exitwhen i > MUI_PatriotT
                set this = m_PatriotT[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or not SpellBoolCaster(c) or r > rmax then
                    set remove = true
                else
                    set r = RoundReal(r + 0.03, 3)
                    call SaveReal(hs, GetHandleId(c), StringHash("t x"), x)
                    call SaveReal(hs, GetHandleId(c), StringHash("t y"), y)

                    if r > PatriotT_CastTime then
                        if r2 > 0.95 then
                            call DecorRemove(c, x, y, aoe, PatriotT_DecorDamage)
                            call VisionTimed(GetOwningPlayer(c), x, y, 1000.0, 2.0)
                            set k = 0
                            loop
                                exitwhen k == k3
                                set x1 = GetEffX(ee[k])
                                set y1 = GetEffY(ee[k])
                                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun2.mdl", x1 - 250.0 * Cos((360.0 / I2R(k3)) * k * bj_DEGTORAD), y1 - 250.0 * Sin((360.0 / I2R(k3)) * k * bj_DEGTORAD), ((360.0 / I2R(k3)) * k) + 180.0, 0.95, 2.25, 50.0, 255, 255, 255, 190))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_3yue_5.mdl", x1, y1, GetRandomReal(0, 359), 1.5, 0.6, 0.0))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdl", x1, y1, GetRandomReal(0, 359), 1.0, 1.25, 0.0))
                                set k = k + 1
                            endloop
                            set r2 = 0.0
                        else
                            set r2 = r2 + 0.03
                        endif
                        if r4 > 0.45 then
                          
                            set check2 = 0
                            set r4 = 0.0
                        else
                            set r4 = r4 + 0.03
                        endif

                        if r3 > 0.0 then
                            call GroupClear(g)
                            set k = 0
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    set distance = SR3(u, x, y)
                                    if distance > aoe - 350.0 and distance < aoe then
                                        if check2 == 0 then
                                            if GetHeroLevel(c) >= 35 then
                                                call NextDmg(c, u, GetAttack(c), 2, 0.36)
                                            endif
                                            call dmgphys(c, u, dmg)
                                        endif
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                        // Soft boundary: normal movement/knockback is
                                        // returned quickly to the inner rim. A blink
                                        // beyond the enumeration radius is untouched.
                                        if distance > aoe - PatriotT_EdgeInset then
                                            call MoveUnit3(u, distance - (aoe - PatriotT_EdgeInset), GAngle2(u, x, y))
                                        endif
                                        set k = k + 1
                                    endif
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set r3 = 0.0
                            if k > 0 then
                                set check2 = 1
                            endif
                        else
                            set r3 = r3 + 0.03
                        endif
                    endif
                endif

                if remove then
                    set k = 0
                    loop
                        exitwhen k == k3
                        call ColorEffDummy3(ee[k], 0.0, 255, 255, 255, 0.30)
                        set ee[k] = null
                        set k = k + 1
                    endloop
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    if g2 != null then
                        call DestroyGroup(g2)
                    endif
                    call SaveReal(hs, GetHandleId(c), StringHash("t x"), 0.0)
                    call SaveReal(hs, GetHandleId(c), StringHash("t y"), 0.0)
                    set c = null
                    set g = null
                    set g2 = null
                    set u = null
                    set m_PatriotT[i] = m_PatriotT[MUI_PatriotT]
                    set MUI_PatriotT = MUI_PatriotT - 1
                    call deallocate(this)
                    set i = i - 1
                    if MUI_PatriotT == -1 then
                        call PatriotTimer03Release()
                    endif
                endif
                set i = i + 1
            endloop
            set u = null
        endmethod

        public static method PatriotT_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            local real x1
            local real y1
            local real x2
            local real y2
            set MUI_PatriotT = MUI_PatriotT + 1
            set m_PatriotT[MUI_PatriotT] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.0
            set r2 = 10.0
            set r3 = 10.0
            set r4 = 0
            set check2 = 0
            call SaveInteger(hs, GetHandleId(c), StringHash("T act"), 0)
            set aoe = PatriotT_DamageAoe
            set g = CreateGroup()
            set g2 = CreateGroup()
            set dmg = GetHeroAgi(c, true) * PatriotT_DamageAgiBase
            set rmax = PatriotT_Duration
            set k = 0
            set k3 = 15

            call VisionTimed(GetOwningPlayer(c), x, y, aoe + 350.0, rmax + 1.0)
            loop
                exitwhen k == k3
                set x1 = x + aoe * Cos((360.0 / I2R(k3)) * k * bj_DEGTORAD)
                set y1 = y + aoe * Sin((360.0 / I2R(k3)) * k * bj_DEGTORAD)
                set x2 = x + (aoe - 325.0) * Cos((360.0 / I2R(k3)) * k * bj_DEGTORAD)
                set y2 = y + (aoe - 325.0) * Sin((360.0 / I2R(k3)) * k * bj_DEGTORAD)

                call MyRemoveEff(EffectSpawn3("war3mapImported\\wos_az_chongci-red%2E.mdl", x2, y2, ((360.0 / I2R(k3)) * k), 2.0, 2.5, 30.0, -270.0), rmax)
                call DestroyEffect(EffectSpawn3("war3mapImported\\wos_mei-qqsfx-5.mdl", x2, y2, ((360.0 / I2R(k3)) * k), 2.0, 1.5, 150.0, -90.0))
                set ee[k] = EffectSpawn("war3mapimported\\wos_PatriotSoldier01.mdx", x1, y1, ((360.0 / I2R(k3)) * k) + 180.0, 0.5, 1.1, 0.0)
                call ColorEffDummy4(ee[k], 0.0, 255, 255, 255, 1.02)
                call BlzPlaySpecialEffect(ee[k], ANIM_TYPE_ATTACK)
                call AnimDummyEff(ee[k], 0.60, 0)
                set k = k + 1
            endloop

            call MakeSound("war3mapImported\\Hero_Patriot_T")
            call MakeSound("war3mapImported\\Hero_Patriot_R2")

            if MUI_PatriotT == 0 then
                call PatriotTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct PatriotSpells_T2
        private static integer array m_PatriotT2
        private static integer MUI_PatriotT2 = -1

        unit c
        real x
        real y
        real x1
        real y1
        real r2
        real scale
        real scale2
        real r3
        real r5
        real r6
        real fly
        group g
        real dmg
        real aoe
        real move
        real r
        effect e
        effect e2
        effect e3
        effect e4
        effect e5
        effect e6
        real a
        real rmax

        public static method Loop_PatriotT2 takes nothing returns nothing
            local integer this
            local integer i = 0
            local unit u
            local integer k
            local boolean remove

            loop
                exitwhen i > MUI_PatriotT2
                set this = m_PatriotT2[i]
                set remove = false

                if r > rmax then
                    set remove = true
                else
                    set r = RoundReal(r + 0.03, 3)

                    if r == 0.60 or r == 1.20 then
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_3yue_5.mdl", x1, y1, GetRandomReal(0, 359), 1.0, 0.60, 0.0, 255, 255, 255, 125))
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_3yue_5.mdl", x1, y1, GetRandomReal(0, 359), 1.0, 0.80, 0.0, 255, 255, 255, 125))
                    endif

                    // Фаза 1: Прицеливание (0.00 – 1.50 сек)
                    if r < PatriotT2_CastTime then
                        set x = GetMouseX(GetOwningPlayer(c))
                        set y = GetMouseY(GetOwningPlayer(c))
                        set a = GAngle4(x1, y1, x, y)
                        if SR0(x1, y1, x, y) > scale2 then
                            set x = x1 + scale2 * Cos(a)
                            set y = y1 + scale2 * Sin(a)
                        endif

                        if SR5(e3, x, y) > move then
                            call MoveEff(e3, move, GAngle5(e3, x, y))
                        else
                            call BlzSetSpecialEffectPosition(e3, x, y, 3.0)
                        endif

                        if r2 > 0.21 then
                            set r2 = 0.0
                            call VisionTimed(GetOwningPlayer(c), GetEffX(e3), GetEffY(e3), aoe * 2.0, 1.0)
                        else
                            set r2 = r2 + 0.03
                        endif
                        call SetUnitFacing(c, GAngle2(c, x, y) * bj_RADTODEG)
                    endif

                    // Момент броска (1.50 сек)
                    if r == PatriotT2_CastTime then
                        call DestroyEffect(e2)
                        set e2 = null
                        call SetUnitTimeScale(c, 2.0)
                        set x = GetEffX(e3)
                        set y = GetEffY(e3)
                        call MakeSound("war3mapimported\\Hero_Patriot_T2 4")
                        set a = GAngle2(c, x, y)
                        call StopSpellUnit(c)
                        call SetUnitFacing(c, a * bj_RADTODEG)

                        // 15 тиков на подъем от 155 до fly
                        set r5 = (fly - 155.0) / 15.0
                        set r6 = SR0(GetUnitX(c) + 150.0 * Cos(a), GetUnitY(c) + 150.0 * Sin(a), x, y) / 15.0
                        set scale = 0.15
                        set e = EffectSpawn3("war3mapImported\\wos_PatriotsSpear.mdx", GetUnitX(c) + 150.0 * Cos(a), GetUnitY(c) + 150.0 * Sin(a), a * bj_RADTODEG, 0.65, 1.0, 155.0, -Atan2(r5, r6) * bj_RADTODEG)

                        set e2 = EffectSpawn("war3mapimported\\wos_Windwalk Black.mdx", GetUnitX(c) + 150.0 * Cos(a), GetUnitY(c) + 150.0 * Sin(a), a * bj_RADTODEG, 0.65, 2.0, 125.0)
                        set e4 = EffectSpawn("war3mapimported\\wos_Windwalk blood.mdx", GetUnitX(c) + 150.0 * Cos(a), GetUnitY(c) + 150.0 * Sin(a), a * bj_RADTODEG, 0.65, 2.0, 125.0)
                        set e5 = EffectSpawn("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", GetUnitX(c) + 150.0 * Cos(a), GetUnitY(c) + 150.0 * Sin(a), a * bj_RADTODEG, 0.65, 2.0, 125.0)
                        set e6 = EffectSpawn("war3mapImported\\wos_OPm (434)3small.mdx", GetUnitX(c) + 150.0 * Cos(a), GetUnitY(c) + 150.0 * Sin(a), a * bj_RADTODEG, 2.0, 3.0, 125.0)
                    endif

                    if r > PatriotT2_CastTime then
                        if r3 > scale then
                            set r3 = 0.0
                            call BlzPlaySpecialEffect(e6, ANIM_TYPE_STAND)
                        else
                            set r3 = r3 + 0.03
                        endif
                    endif

                    // Фаза 2: Взлёт по наклонной к верхней точке (1.50 – 1.95 сек)
                    if r > PatriotT2_CastTime and r <= 1.95 then
                        call MoveEff(e, r6, a)
                        call BlzSetSpecialEffectHeight(e, BlzGetLocalSpecialEffectZ(e) + r5)
                        call MoveEff(e2, r6, a)
                        call BlzSetSpecialEffectHeight(e2, BlzGetLocalSpecialEffectZ(e2) + r5)
                        call MoveEff(e4, r6, a)
                        call BlzSetSpecialEffectHeight(e4, BlzGetLocalSpecialEffectZ(e4) + r5)
                        call MoveEff(e5, r6, a)
                        call BlzSetSpecialEffectHeight(e5, BlzGetLocalSpecialEffectZ(e))
                        call MoveEff(e6, r6, a)
                        call BlzSetSpecialEffectHeight(e6, BlzGetLocalSpecialEffectZ(e))

                        if r2 > 0.03 then
                            set r2 = 0.0
                            call VisionTimed(GetOwningPlayer(c), GetEffX(e), GetEffY(e), 1000.0, 2.0)
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif

                    // Пик высоты: фиксация над целью и разворот острием вниз (1.95 сек)
                    if r == 1.95 then
                        set scale = 0.15
                        call MakeSound("war3mapimported\\Hero_Patriot_T2 3")
                        // 15 тиков на падение от fly до 0 (2.40 - 1.95 = 0.45 сек)
                        set r5 = fly / 15.0
                        call BlzSetSpecialEffectPosition(e, x, y, fly)
                        call BlzSetSpecialEffectPosition(e2, x, y, fly)
                        call BlzSetSpecialEffectPosition(e4, x, y, fly)
                        call BlzSetSpecialEffectPosition(e5, x, y, fly)
                        call BlzSetSpecialEffectPosition(e6, x, y, fly)
                        call BlzSetSpecialEffectPitch(e, -270.0 * bj_DEGTORAD)
                    endif

                    // Фаза 3: Падение строго вертикально вниз (1.95 – 2.40 сек)
                    if r > 1.95 and r <= 2.40 then
                        if r2 > 0.03 then
                            set r2 = 0.0
                            call VisionTimed(GetOwningPlayer(c), x, y, 1000.0, 2.0)
                        else
                            set r2 = r2 + 0.03
                        endif
                        call BlzSetSpecialEffectHeight(e, BlzGetLocalSpecialEffectZ(e) - r5)
                        call BlzSetSpecialEffectHeight(e2, BlzGetLocalSpecialEffectZ(e2) - r5)
                        call BlzSetSpecialEffectHeight(e4, BlzGetLocalSpecialEffectZ(e4) - r5)
                        call BlzSetSpecialEffectHeight(e5, BlzGetLocalSpecialEffectZ(e))
                        call BlzSetSpecialEffectHeight(e6, BlzGetLocalSpecialEffectZ(e))
                    endif

                    // Удар о землю (2.40 сек)
                    if r == 2.40 then
                        set r = 9999.0
                        call MakeSound("war3mapimported\\Hero_Patriot_T2 5")
                        call DecorRemove(c, x, y, aoe, PatriotT2_DecorDamage)
                        call VisionTimed(GetOwningPlayer(c), x, y, aoe * 2.0, 2.0)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)3small.mdl", x, y, GetRandomReal(0, 359), 1.0, 3.0, 145.0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZarakiWCrack2.mdx", x, y, GetRandomReal(0, 359), 1.0, 3.0, 0.0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Eff_Ord_DanGe_Wav_Kuosan_1_3_0_5s.mdx", x, y, 1.0, 1.0, 1.0, 100.0))

                        set k = 0
                        loop
                            exitwhen k > 4
                            call EffectSpawn2("war3mapimported\\wos_LD2209 (157).mdx", x, y, GetRandomReal(0, 359), 1.6 - k * 0.2, 1.0 + k * 0.5, 0.0, 1.25)
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_dustgaraa2.mdx", x, y, GetRandomReal(0, 359), 1.85 - k * 0.1, 1.9 + k * 0.42, 0.0))
                            set k = k + 1
                        endloop

                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_chushou_by_wood_effect_earth_longzhituxi.mdx", x, y, GetRandomReal(0, 359), 0.5, 1.75, 0.0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (597)red.mdx", x, y, GetRandomReal(0, 359), 2.0, 1.75, 0.0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_FBT-dilie22.mdx", x, y, GetRandomReal(0, 359), 0.2, 3.6, 5.0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlashred.mdl", x + 25.0 * Cos(a), y + 25.0 * Sin(a), 1.0, 1.25, 2.5, 255.0))
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_afbcoyrighthdcec.mdl", x, y, GetRandomReal(0, 359), 0.65, 5.0, 175.0, 45, 0, 0, 255))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_ZarakiWCrack1.mdl", x, y, GetRandomReal(0, 359), 1.25, 2.0, 0.0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_3yue_5.mdl", x, y, GetRandomReal(0, 359), 1.5, 1.0, 0.0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_3yue_5.mdl", x, y, GetRandomReal(0, 359), 1.75, 1.3, 0.0))

                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call dmgphys(c, u, dmg)
                                if GetHeroLevel(c) >= 35 then
                                    call PatriotPas(c, u)
                                endif
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        call StopSpellUnit(c)
                    endif
                endif

                if remove then
                    if e != null then
                        call DestroyEffect(e)
                    endif
                    if e2 != null then
                        call DestroyEffect(e2)
                    endif
                    if e3 != null then
                        call DestroyEffect(e3)
                    endif
                    if e4 != null then
                        call DestroyEffect(e4)
                    endif
                    if e5 != null then
                        call DestroyEffect(e5)
                    endif
                    if e6 != null then
                        call DestroyEffect(e6)
                    endif
                    call MouseOff(GetOwningPlayer(c))
                    if r < PatriotT2_CastTime then
                        call StopSpellUnit(c)
                    endif
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    set c = null
                    set g = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set e5 = null
                    set e6 = null
                    set u = null
                    set m_PatriotT2[i] = m_PatriotT2[MUI_PatriotT2]
                    set MUI_PatriotT2 = MUI_PatriotT2 - 1
                    call deallocate(this)
                    set i = i - 1
                    if MUI_PatriotT2 == -1 then
                        call PatriotTimer03Release()
                    endif
                endif
                set i = i + 1
            endloop
            set u = null
        endmethod

        public static method PatriotT2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            set MUI_PatriotT2 = MUI_PatriotT2 + 1
            set m_PatriotT2[MUI_PatriotT2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.0
            set r2 = 10.0
            set x1 = GetUnitX(c)
            set y1 = GetUnitY(c)
            set aoe = PatriotT2_DamageAoe
            set a = GAngle2(c, x, y)
            set g = CreateGroup()

            call StartSpellUnit(c)
            call MakeSound("war3mapimported\\Hero_Patriot_T2 1")
            call MakeSound("war3mapimported\\Hero_Patriot_T2 2")
            set dmg = GetHeroAgi(c, true) * PatriotT2_DamageAgiBase
            set move = 150.0
            set fly = 2400.0
            call MouseOn(GetOwningPlayer(c))
            set MouseX[GetPlayerId(GetOwningPlayer(c))] = x
            set MouseY[GetPlayerId(GetOwningPlayer(c))] = y
            set scale = 6.0*1.2
            set scale2 = PatriotT2_Range
            set r5 = 0.30
            set rmax = 5.0

            call SetUnitAnimationByIndex(c, 9)
            call SetUnitTimeScale(c, 0.85)
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_opdef (425).mdx", x1, y1, GetRandomReal(0, 359), 0.60, 0.50, 0.0))
            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_3yue_5.mdl", x1, y1, GetRandomReal(0, 359), 1.0, 0.60, 0.0, 255, 255, 255, 125))
            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_3yue_5.mdl", x1, y1, GetRandomReal(0, 359), 1.0, 0.80, 0.0, 255, 255, 255, 125))
            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", c, "hand right")
            call VisionTimed(GetOwningPlayer(c), x, y, aoe * 2.0, 2.0)
            set e3 = EffectSpawn("war3mapImported\\wos_[tx] (381).mdl", x1, y1, 1.0, 1.0, 0.01, 3.0)
            call ScaleEffDummy(e3, r5, 0.01, scale)
            call BlzSetSpecialEffectAlpha(e3, 0)
            if GetLocalPlayer() == GetOwningPlayer(c) then
                call BlzSetSpecialEffectAlpha(e3, 255)
            endif
            
            if MUI_PatriotT2 == 0 then
                call PatriotTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct PatriotSpells_F
        private static integer array m_PatriotF
        private static integer MUI_PatriotF = -1

        unit c
        real x
        real y
        real x1
        real y1
        real r2
        real scale2
        real r3
        group g
        real aoe
        real move
        real r
        real a
        real rmax

        public static method Loop_PatriotF takes nothing returns nothing
            local integer i = 0
            local thistype this
            local unit u
            local boolean remove

            loop
                exitwhen i > MUI_PatriotF
                set this = m_PatriotF[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or r >= rmax or not SpellBool(c) or LoadInteger(hs, GetHandleId(c), StringHash("stop r")) != 0 then
                    set remove = true
                else
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit2(c)

                    if r == 0.60 then
                        call SetUnitTimeScale(c, 0.0)
                    endif

                    set x = GetMouseX(GetOwningPlayer(c))
                    set y = GetMouseY(GetOwningPlayer(c))
                    set a = GAngle4(x1, y1, x, y)
                    if SR0(x1, y1, x, y) > scale2 then
                        set x = x1 + scale2 * Cos(a)
                        set y = y1 + scale2 * Sin(a)
                    endif

                    if SR3(c, x, y) > move then
                        call MoveUnit(c, move, GAngle2(c, x, y))
                        call SetUnitFacing(c, GAngle2(c, x, y) * bj_RADTODEG)
                    else
                        call PosUnit(c, x, y)
                    endif

                    set x = GetUnitX(c)
                    set y = GetUnitY(c)

                    if r3 > 0.21 then
                        set r3 = 0.0
                        call DecorRemove(c, x, y, aoe, PatriotF_DecorDamage)
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun2.mdl", x + 250.0 * Cos(a), y + 250.0 * Sin(a), a * bj_RADTODEG, 0.95, 3.25, 50.0, 255, 255, 255, 190))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_krk (1971).mdl", x, y, GetRandomReal(0, 359), 0.90, 1.0, 1.0))
                    else
                        set r3 = r3 + 0.03
                    endif

                    if GetHeroLevel(c) >= 25 then
                        call DebuffClear(c)
                    endif

                    if r2 > 0.12 then
                        set r2 = 0.0
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and SR2(c, u) < 250.0 then
                                call MUE(u, 250.0, 0.30, a)
                            endif
                            if GetHeroLevel(c) >= 35 then
                                if IsUnitAlly(u, GetOwningPlayer(c)) and SpellBool(u) and GetUnitAbilityLevel(u, PatriotF_Buff1_ID) == 0 and GetUnitAbilityLevel(u, PatriotF_Buff2_ID) == 0 then
                                    if c == u then
                                        call BuffUnit1(c, u, 13)
                                    else
                                        call BuffUnit1(c, u, 14)
                                    endif
                                endif
                            else
                                call BuffUnit1(c, c, 13)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    else
                        set r2 = r2 + 0.03
                    endif
                endif

                if remove then
                    if c != null and GetUnitTypeId(c) != 0 then
                        call StopSpellUnit2(c)
                        call SaveInteger(hs, GetHandleId(c), StringHash("stop r"), 0)
                        call SaveInteger(hs, GetHandleId(c), StringHash("cast r"), 0)
                        call SetUnitTimeScale(c, 1.0)
                        call MouseOff(GetOwningPlayer(c))
                    endif
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    set g = null
                    set c = null
                    set u = null
                    set m_PatriotF[i] = m_PatriotF[MUI_PatriotF]
                    set MUI_PatriotF = MUI_PatriotF - 1
                    call deallocate(this)
                    set i = i - 1
                    if MUI_PatriotF == -1 then
                        call PatriotTimer03Release()
                    endif
                endif
                set i = i + 1
            endloop
            set u = null
        endmethod

        public static method PatriotF_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_PatriotF = MUI_PatriotF + 1
            set m_PatriotF[MUI_PatriotF] = this
            set c = NewC
            set r = 0.0
            set a = GetUnitFacing(c) * bj_DEGTORAD
            set x = GetUnitX(c) + 10.0 * Cos(a)
            set y = GetUnitY(c) + 10.0 * Sin(a)
            set r2 = 10.0
            set r3 = 10.0
            set move = 6.0
            set rmax = PatriotF_Duration
            set g = CreateGroup()
            set aoe = PatriotF_AoE

            call StartSpellUnit2(c)
            set x1 = GetUnitX(c)
            set y1 = GetUnitY(c)
            call SaveInteger(hs, GetHandleId(c), StringHash("cast r"), 1)
            call MouseOn(GetOwningPlayer(c))
            set MouseX[GetPlayerId(GetOwningPlayer(c))] = x
            set MouseY[GetPlayerId(GetOwningPlayer(c))] = y
            set scale2 = PatriotT2_Range

            call MakeSound("war3mapImported\\Hero_Patriot_F")
            call SetUnitAnimationByIndex(c, 2)
            call SetUnitTimeScale(c, 2.0)

            if MUI_PatriotF == 0 then
                call PatriotTimer03Acquire()
            endif
        endmethod
    endstruct

    private function PatriotTimer03Loop takes nothing returns nothing
        call PatriotSpells_Q.Loop_PatriotQ()
        call PatriotSpells_W.Loop_PatriotW()
        call PatriotSpells_E.Loop_PatriotE()
        call PatriotSpells_R.Loop_PatriotR()
        call PatriotSpells_T.Loop_PatriotT()
        call PatriotSpells_T2.Loop_PatriotT2()
        call PatriotSpells_F.Loop_PatriotF()
    endfunction

    // ===========================================================================
    // Initializer
    // ===========================================================================
    private function InitPatriotSpells takes nothing returns nothing
        set PatriotTimer03 = CreateTimer()
        set PatriotTimer03Callback = function PatriotTimer03Loop
    endfunction

    // ===========================================================================
    // Public Trigger Interfaces
    // ===========================================================================
    function PatriotQ_Start takes unit c, real x, real y returns nothing
        call PatriotSpells_Q.PatriotQ_Start(c, x, y)
    endfunction

    function PatriotW_Start takes unit c, real x, real y returns nothing
        call PatriotSpells_W.PatriotW_Start(c, x, y)
    endfunction

    function PatriotE_Start takes unit c returns nothing
        local integer e = LoadInteger(hs, GetHandleId(c), StringHash("patriot e"))
        local integer rand = GetRandomInt(1, 3)
        local real x = GetUnitX(c)
        local real y = GetUnitY(c)
        local real cd1 = BlzGetUnitAbilityCooldownRemaining(c, PatriotT_ID)
        local real cd2 = BlzGetUnitAbilityCooldownRemaining(c, PatriotT2_ID)
        local real a = GetUnitFacing(c) * bj_DEGTORAD
        local integer oldrand = LoadInteger(hs, GetHandleId(c), StringHash("old random"))

        loop
            set rand = GetRandomInt(1, 3)
            exitwhen rand != oldrand
        endloop
        if rand == 1 then
            call MakeSound("war3mapImported\\Hero_Patriot_E")
        elseif rand == 2 then
            call MakeSound("war3mapImported\\Hero_Patriot_E2")
        elseif rand == 3 then
            call MakeSound("war3mapImported\\Hero_Patriot_E3")
        endif
        call SaveInteger(hs, GetHandleId(c), StringHash("old random"), rand)

        if e == 0 then
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), PatriotF_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), PatriotT_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), PatriotF2_ID, true)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), PatriotT2_ID, true)
            call UnitAddAbility(c, PatriotF2_ID)
            if GetUnitAbilityLevel(c, PatriotT_ID) > 0 then
                call UnitAddAbility(c, PatriotT2_ID)
                call BlzStartUnitAbilityCooldown(c, PatriotT2_ID, cd1)
            endif
            call AddUnitAnimationProperties(c, "alternate", true)
            call Patriot_RestoreOrder(c, 8)
            call SaveInteger(hs, GetHandleId(c), StringHash("patriot e"), 1)
            call AddSpellLevel(c, 'A01C', 10, true)
            call BlzSetAbilityIcon(PatriotE_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Patriot_E2.blp")
            call AAUniversalTooltips_SetUnitForm(c, 1)
        else
            call AddSpellLevel(c, 'A01C', 10, false)
            call BlzSetAbilityIcon(PatriotE_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Patriot_E.blp")
            call BlzStartUnitAbilityCooldown(c, PatriotT_ID, cd2)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), PatriotF_ID, true)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), PatriotT_ID, true)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), PatriotF2_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), PatriotT2_ID, false)
            call AddUnitAnimationProperties(c, "alternate", false)
            call Patriot_RestoreOrder(c, 3)
            call SaveInteger(hs, GetHandleId(c), StringHash("patriot e"), 0)
            call AAUniversalTooltips_SetUnitForm(c, 0)
        endif

        if GetHeroLevel(c) >= 35 then
            call ReduceCooldown(c, PatriotR_ID, PatriotE_CDReductR)
        endif
        call ReduceCooldown(c, PatriotQ_ID, PatriotE_CDReductBase + (PatriotE_CDReductStep * (GetUnitAbilityLevel(c, PatriotE_ID) - 1)))
        call DestroyEffect(EffectSpawn("war3mapimported\\wos_1hongse_2red.mdl", x, y, a * bj_RADTODEG, 1.0, 4.37, 15.0))
        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_wfile00009065.mdl", x, y, a * bj_RADTODEG, 0.5, 1.1, 1.0, 255, 255, 255, 255))
    endfunction

    function PatriotEE_Start takes unit c, unit td returns nothing
        call PatriotSpells_E.PatriotE_Start(c, td)
    endfunction

    function PatriotR_Start takes unit c, real x, real y returns nothing
        call PatriotSpells_R.PatriotR_Start(c, x, y)
    endfunction

    function PatriotT_Start takes unit c, real x, real y returns nothing
        call PatriotSpells_T.PatriotT_Start(c, x, y)
    endfunction

    function PatriotT2_Start takes unit c, real x, real y returns nothing
        call PatriotSpells_T2.PatriotT2_Start(c, x, y)
    endfunction

    function PatriotF_Start takes unit c returns nothing
        call PatriotSpells_F.PatriotF_Start(c)
    endfunction

    function PatriotF2_Start takes unit c returns nothing
        call PatriotSpells_F.PatriotF_Start(c)
    endfunction
endlibrary
