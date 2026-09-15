library BrandishSpells initializer InitBrandishSpells uses GearSystems

    globals
        // Central Timer Management
        private timer BrandishTimer03
        private code BrandishTimer03Callback
        private integer BrandishTimer03Users = 0

        private timer BrandishTimer05
        private code BrandishTimer05Callback
        private integer BrandishTimer05Users = 0

        private timer BrandishTimerE
        private code BrandishTimerECallback
        private integer BrandishTimerEUsers = 0

        private timer BrandishTimerF
        private code BrandishTimerFCallback
        private integer BrandishTimerFUsers = 0

        // System Hash
        private hashtable hs = InitHashtable()

        // Dummy Casters
        private unit array branddummy1
        private unit array branddummy2

//--------------------------------------Brandish Core-----------------------------------------
        integer Brandish_ID = 'H02B'

//---------------Q ability (Sand Wave / Earth Surge)--------------------------
        integer BrandishQ_ID = 'A0EH'
        real BrandishQ_DamageIntBase = 1.0
        real BrandishQ_DamageIntStep = 1.0
        real BrandishQ_Damage2StaticBase = 150.0
        real BrandishQ_Damage2StaticStep = 0.0
        real BrandishQ_DamageAoe = 425.0
        real BrandishQ_Range = 1800.0
        real BrandishQ_PushRange = 600.0
        real BrandishQ_PushTime = 0.51
        real BrandishQ_CastTime = 1.50
        real BrandishQ_Duration = 0.54
        boolean BrandishQ_IsInvul = true
        real BrandishQ_DecorDamage = 50.0

//---------------W ability (Stone Pillar Crush)--------------------------------
        integer BrandishW_ID = 'A0EI'
        real BrandishW_DamageIntBase = 1.0
        real BrandishW_DamageIntStep = 1.0
        real BrandishW_Damage2StaticBase = 150.0
        real BrandishW_Damage2StaticStep = 0.0
        real BrandishW_DamageAoe = 575.0
        real BrandishW_RootDuration = 1.00
        real BrandishW_DelayBase = 1.30
        real BrandishW_DelayStep = 0.10
        boolean BrandishW_IsInvul = false
        real BrandishW_CastTime = 0.00
        real BrandishW_DecorDamage = 40.0

//---------------E ability (Matter Recovery / Cellular Heal)-------------------
        integer BrandishE_ID = 'A0EJ'
        integer BrandishE_Buff1_ID = 'B025'
        integer BrandishE_Buff2_ID = 'B026'
        integer BrandishE_Buff3_ID = 'B027'
        integer BrandishE_Buff4_ID = 'B028'
        integer BrandishE_Buff5_ID = 'B029'
        real BrandishE_DurationBase = 2.0
        real BrandishE_DurationStep = 1.0
        real BrandishE_DamageDecrease = 15.0
        real BrandishE_HealStaticBase = 0.0
        real BrandishE_HealStaticStep = 0.0
        real BrandishE_HealIntBase = 0.80
        real BrandishE_HealIntStep = 0.00
        boolean BrandishE_IsInvul = false
        real BrandishE_CastTime = 0.00
        real BrandishE_DecorDamage = 0.0

//---------------R ability (Tectonic Rupture / Great Collapse)-----------------
        integer BrandishR_ID = 'A0EK'
        real BrandishR_DamageIntBase = 4.0
        real BrandishR_DamageIntStep = 1.0
        real BrandishR_DamageAoe = 800.0
        integer BrandishR_Slow = 50
        integer BrandishR_SlowDuration = 3
        real BrandishR_Delay = 1.00
        boolean BrandishR_IsInvul = false
        real BrandishR_DecorDamage = 100.0

//---------------T ability (Command T / Gigantification)-----------------------
        integer BrandishT_ID = 'A0EL'
        real BrandishT_DamageIntBase = 10.0
        real BrandishT_DamageIntBase2 = 1.0
        real BrandishT_DamageAoe = 1250.0
        real BrandishT_Stun = 0.50
        real BrandishT_ScaleIncrease = 500.0
        real BrandishT_CastTime = 1.20
        real BrandishT_Duration = 0.30
        real BrandishT_Lv35Duration = 5.30
        boolean BrandishT_IsInvul = true
        real BrandishT_DecorDamage = 100.0

//---------------F ability (Command F / Scale Manipulation)-------------------
        integer BrandishF_ID = 'A0EM'
        integer BrandishF_Buff_ID = 'B02A'
        integer BrandishF_Debuff_ID = 'B02B'
        real BrandishF_DamageOutputDecreaseScale = 50.0
        real BrandishF_DamageOutputIncreaseScale = 200.0
        real BrandishF_DamageOutputDecrease = 18.0
        real BrandishF_DamageOutputIncrease = 18.0
        real BrandishF_Time = 10.0
        boolean BrandishF_IsInvul = false
        real BrandishF_CastTime = 0.00
        real BrandishF_DecorDamage = 0.0
    endglobals

    //===========================================================================
    // Order Tracking (Бег без остановки)
    //===========================================================================
    private function OnHeroPointOrder takes nothing returns boolean
        local unit u = GetOrderedUnit()
        local integer ord = GetIssuedOrderId()
        if GetUnitTypeId(u) == Brandish_ID then
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

    private function OnHeroTargetOrder takes nothing returns boolean
        local unit u = GetOrderedUnit()
        local integer ord = GetIssuedOrderId()
        if GetUnitTypeId(u) == Brandish_ID then
            if ord == 851971 or ord == 851983 then
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_mode"), 2)
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_id"), ord)
                call SaveUnitHandle(hs, GetHandleId(u), StringHash("ord_target"), GetOrderTargetUnit())
            endif
        endif
        set u = null
        return false
    endfunction

    private function OnHeroImmediateOrder takes nothing returns boolean
        local unit u = GetOrderedUnit()
        local integer ord = GetIssuedOrderId()
        if GetUnitTypeId(u) == Brandish_ID then
            if ord == 851972 or ord == 851993 then
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_mode"), 0)
            endif
        endif
        set u = null
        return false
    endfunction

    function Brandish_RestoreOrder takes unit c, integer animIndex returns nothing
        local integer mode = LoadInteger(hs, GetHandleId(c), StringHash("ord_mode"))
        local real ox
        local real oy
        local real dx
        local real dy
        local integer oid
        local unit tu

        // 1. Герой на бегу в точку
        if mode == 1 then
            set ox = LoadReal(hs, GetHandleId(c), StringHash("ord_x"))
            set oy = LoadReal(hs, GetHandleId(c), StringHash("ord_y"))
            set dx = ox - GetUnitX(c)
            set dy = oy - GetUnitY(c)
            // Если до цели больше 75 единиц — сразу возобновляем бег без анимации каста
            if (dx * dx + dy * dy) > 5625.0 then
                set oid = LoadInteger(hs, GetHandleId(c), StringHash("ord_id"))
                call IssuePointOrderById(c, oid, ox, oy)
                return
            endif
        // 2. Герой на бегу к цели атаки/приказа
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

        // 3. Герой стоит на месте (или уже добежал) — проигрываем анимацию
        call SetUnitAnimationByIndex(c, animIndex)
        call SetAnimIndex(c, 0.03, animIndex)
    endfunction

    private struct BrandishOrderInit extends array
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
            call TriggerAddCondition(tPoint, Condition(function OnHeroPointOrder))
            call TriggerAddCondition(tTarget, Condition(function OnHeroTargetOrder))
            call TriggerAddCondition(tImmediate, Condition(function OnHeroImmediateOrder))
        endmethod
    endstruct

    //===========================================================================
    // Утилиты таймеров
    //===========================================================================
    private function BrandishTimer03Acquire takes nothing returns nothing
        set BrandishTimer03Users = BrandishTimer03Users + 1
        if BrandishTimer03Users == 1 then
            call TimerStart(BrandishTimer03, 0.03, true, BrandishTimer03Callback)
        endif
    endfunction

    private function BrandishTimer03Release takes nothing returns nothing
        set BrandishTimer03Users = BrandishTimer03Users - 1
        if BrandishTimer03Users <= 0 then
            set BrandishTimer03Users = 0
            call PauseTimer(BrandishTimer03)
        endif
    endfunction

    private function BrandishTimer05Acquire takes nothing returns nothing
        set BrandishTimer05Users = BrandishTimer05Users + 1
        if BrandishTimer05Users == 1 then
            call TimerStart(BrandishTimer05, 0.05, true, BrandishTimer05Callback)
        endif
    endfunction

    private function BrandishTimer05Release takes nothing returns nothing
        set BrandishTimer05Users = BrandishTimer05Users - 1
        if BrandishTimer05Users <= 0 then
            set BrandishTimer05Users = 0
            call PauseTimer(BrandishTimer05)
        endif
    endfunction

    private function BrandishTimerEAcquire takes nothing returns nothing
        set BrandishTimerEUsers = BrandishTimerEUsers + 1
        if BrandishTimerEUsers == 1 then
            call TimerStart(BrandishTimerE, 1.00, true, BrandishTimerECallback)
        endif
    endfunction

    private function BrandishTimerERelease takes nothing returns nothing
        set BrandishTimerEUsers = BrandishTimerEUsers - 1
        if BrandishTimerEUsers <= 0 then
            set BrandishTimerEUsers = 0
            call PauseTimer(BrandishTimerE)
        endif
    endfunction

    private function BrandishTimerFAcquire takes nothing returns nothing
        set BrandishTimerFUsers = BrandishTimerFUsers + 1
        if BrandishTimerFUsers == 1 then
            call TimerStart(BrandishTimerF, 0.75, true, BrandishTimerFCallback)
        endif
    endfunction

    private function BrandishTimerFRelease takes nothing returns nothing
        set BrandishTimerFUsers = BrandishTimerFUsers - 1
        if BrandishTimerFUsers <= 0 then
            set BrandishTimerFUsers = 0
            call PauseTimer(BrandishTimerF)
        endif
    endfunction

    //===========================================================================
    // Базовые утилиты баффов и масштабирования
    //===========================================================================
    struct BrandishSpells_Utility
        public static method BuffUnitBran takes unit c, unit u, integer level returns nothing
            local integer i = GetPlayerId(GetOwningPlayer(c))
            if branddummy1[i] == null or GetWidgetLife(branddummy1[i]) < 1.0 then
                set branddummy1[i] = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'h0C9', GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster), 0.0)
                call UnitAddAbility(branddummy1[i], 'A0EN')
            endif
            if level > 0 then
                if GetUnitAbilityLevel(branddummy1[i], 'A0EN') == 0 then
                    call UnitAddAbility(branddummy1[i], 'A0EN')
                endif
                call SetUnitAbilityLevel(branddummy1[i], 'A0EN', level)
                call SetUnitFacing(branddummy1[i], GAngle(branddummy1[i], u) * bj_RADTODEG)
                call IssueTargetOrder(branddummy1[i], "innerfire", u)
            endif
        endmethod

        public static method BuffUnitBran2 takes unit c, unit u, integer level, boolean isenemy returns nothing
            local integer i = GetPlayerId(GetOwningPlayer(c))
            if branddummy2[i] == null or GetWidgetLife(branddummy2[i]) < 1.0 then
                set branddummy2[i] = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'h0C9', GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster), 0.0)
                call UnitAddAbility(branddummy2[i], 'A0EO')
                call UnitAddAbility(branddummy2[i], 'A0EP')
            endif
            if level > 0 then
                if GetUnitAbilityLevel(branddummy2[i], 'A0EO') == 0 then
                    call UnitAddAbility(branddummy2[i], 'A0EO')
                endif
                if GetUnitAbilityLevel(branddummy2[i], 'A0EP') == 0 then
                    call UnitAddAbility(branddummy2[i], 'A0EP')
                endif
                call SetUnitAbilityLevel(branddummy2[i], 'A0EP', level)
                call SetUnitAbilityLevel(branddummy2[i], 'A0EO', level)
                call SetUnitFacing(branddummy2[i], GAngle(branddummy2[i], u) * bj_RADTODEG)
                if isenemy then
                    call IssueTargetOrder(branddummy2[i], "curse", u)
                else
                    call IssueTargetOrder(branddummy2[i], "innerfire", u)
                endif
            endif
        endmethod

        public static method GetTotalScale takes unit u returns real
            local real tm = LoadReal(hs, GetHandleId(u), StringHash("TMult"))
            local real fm = LoadReal(hs, GetHandleId(u), StringHash("FMult"))
            if tm == 0.0 then
                set tm = 1.0
            endif
            if fm == 0.0 then
                set fm = 1.0
            endif
            return tm * fm
        endmethod
    endstruct

    //===========================================================================
    // Q - Sand Wave
    //===========================================================================
    private struct BrandishSpells_Q
        private static integer array m_BrandishQ
        private static integer MUI_BrandishQ = -1

        unit c
        real x
        real y
        real r2
        real scale
        real r3
        real r5
        real r6
        group g
        group g2
        unit u
        real dmg
        integer check
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax

        public static method Loop_BrandishQ takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_BrandishQ
                set this = m_BrandishQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if check == 0 then
                        call DebugUnit(c)
                        if r == 0.33 then
                            call SetUnitTimeScale(c, 0.0)
                            if GetUnitAbilityLevel(c, BrandishF_Buff_ID) == 1 then
                                set r5 = 260.0
                                set e2 = EffectSpawn2("war3mapImported\\wos_BranQCast2.mdl", GetUnitX(c) + r5 * Cos(a), GetUnitY(c) + r5 * Sin(a), a * bj_RADTODEG, 3.0, 0.01, 135.0, 1.52)
                                call ScaleEffDummy(e2, 0.21, 0.01, 0.65)
                            else
                                set r5 = 190.0
                                set e2 = EffectSpawn2("war3mapImported\\wos_BranQCast2.mdl", GetUnitX(c) + r5 * Cos(a), GetUnitY(c) + r5 * Sin(a), a * bj_RADTODEG, 3.0, 0.01, 65.0, 1.52)
                                call ScaleEffDummy(e2, 0.21, 0.01, 0.50)
                            endif
                        endif
                        if r > 0.33 then
                            if r2 > 0.09 then
                                set r2 = 0.0
                                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_T_dustgaraa2.mdx", GetUnitX(c) + r5 * Cos(a), GetUnitY(c) + r5 * Sin(a), GetRandomReal(0, 359), 0.8, 0.8, 0.0, 255, 255, 200, 100))
                                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_T_dustgaraa2.mdx", GetUnitX(c) + r5 * Cos(a), GetUnitY(c) + r5 * Sin(a), GetRandomReal(0, 359), 0.8, 1.2, 0.0, 255, 255, 200, 100))
                                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_T_dustgaraa2.mdx", GetUnitX(c) + r5 * Cos(a), GetUnitY(c) + r5 * Sin(a), GetRandomReal(0, 359), 0.8, 1.6, 0.0, 255, 255, 200, 100))
                            else
                                set r2 = r2 + 0.03
                            endif
                            if r3 > 0.15 then
                                set r3 = 0.0
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZarakiQEff2.mdx", GetUnitX(c) + r5 * Cos(a), GetUnitY(c) + r5 * Sin(a), GetRandomReal(0, 359), 1.2, 1.55, 45.0))
                            else
                                set r3 = r3 + 0.03
                            endif
                        endif
                        if r == 1.35 then
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_by_wood_bashenan_juqi_2_2.mdl", GetUnitX(c) + r5 * Cos(a), GetUnitY(c) + r5 * Sin(a), 0.0, 0.5, 3.0, 155.0, 125, 255, 100, 255))
                        endif
                        if r >= BrandishQ_CastTime then
                            call StopSpellUnit(c)
                            set e2 = null
                            set check = 1
                            set e = EffectSpawn("war3mapImported\\wos_Sand_Wave3.mdl", GetUnitX(c) + 200.0 * Cos(a), GetUnitY(c) + 200.0 * Sin(a), a * bj_RADTODEG, 0.2, 1.0, 0.0)
                            set rmax = BrandishQ_Duration
                            set r = 0.0
                            set r2 = 10.0
                            set r5 = 0.0
                        endif
                    elseif check == 1 then
                        call MoveEff2(e, move, a)
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        set r5 = r5 + move
                        set scale = scale + 0.047
                        call BlzSetSpecialEffectScale(e, scale)
                        if r6 >= 0.09 then
                            set r6 = 0.0
                            call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_Sand_Wave3.mdx", x, y, a * bj_RADTODEG, 0.2, scale, 0.0), rmax - r, 255, 255, 255, 0.42)
                            call VisionTimed(GetOwningPlayer(c), x, y, 850.0, 2.2)
                            call DecorRemove(c, x, y, aoe, BrandishQ_DecorDamage)
                        else
                            set r6 = r6 + 0.03
                        endif
                        if r2 > 0.03 then
                            set r2 = 0.0
                            call GroupClear(g)
                            call EMUE(EffectSpawn2("war3mapimported\\wos_brandi_sandq.mdx", x - 200.0 * Cos(a), y - 200.0 * Sin(a), a * bj_RADTODEG, 2.25, 1.75, r * 200.0, 0.36), 650.0, 0.42, a)
                            call EMUE(EffectSpawn2("war3mapimported\\wos_brandi_sandq.mdx", x + 300.0 * Cos(a), y + 300.0 * Sin(a), a * bj_RADTODEG, 2.15, 1.50, 200.0 + r * 500.0, 0.36), 450.0, 0.42, a)
                            call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                    call dmgphys(c, u, dmg)
                                    call MUE(u, BrandishQ_PushRange, BrandishQ_PushTime, a)
                                    call GroupAddUnit(g2, u)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    call ColorEffDummy3(e, 0.0, 255, 255, 255, 0.42)
                    if r <= BrandishQ_CastTime and check == 0 then
                        call StopSpellUnit(c)
                    endif
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_BrandishQ[i] = m_BrandishQ[MUI_BrandishQ]
                    set MUI_BrandishQ = MUI_BrandishQ - 1
                    call deallocate(this)
                    set i = i - 1
                    if MUI_BrandishQ == -1 then
                        call BrandishTimer03Release()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BrandishQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            local integer level = GetUnitAbilityLevel(NewC, BrandishQ_ID)
            if level < 1 then
                set level = 1
            endif
            set MUI_BrandishQ = MUI_BrandishQ + 1
            set m_BrandishQ[MUI_BrandishQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.0
            set r2 = 10.0
            set r3 = 1.0
            set r6 = 0.0
            set scale = 1.50
            call StartSpellUnit(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2(c, x, y)
            set check = 0
            set move = 100.0
            set aoe = BrandishQ_DamageAoe
            set dmg = GetHeroInt(c, true) * (BrandishQ_DamageIntBase + (BrandishQ_DamageIntStep * (level - 1)))
            set dmg = dmg + BrandishQ_Damage2StaticBase + (BrandishQ_Damage2StaticStep * (level - 1))
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SetUnitTimeScale(c, 0.45)
            call SetUnitAnimationByIndex(c, 7)
            call MakeSound("war3mapimported\\Hero_Brandish_Q")
            set rmax = BrandishQ_CastTime
            if MUI_BrandishQ == 0 then
                call BrandishTimer03Acquire()
            endif
        endmethod
    endstruct

    //===========================================================================
    // W - Stone Pillar Crush
    //===========================================================================
    private struct BrandishSpells_W
        private static integer array m_BrandishW
        private static integer MUI_BrandishW = -1

        unit c
        real x
        real y
        integer k
        real r5
        group g
        unit u
        real dmg
        real aoe
        real r
        effect e
        effect e2
        real a
        real rmax

        public static method Loop_BrandishW takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_BrandishW
                set this = m_BrandishW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.05, 3)
                    if r >= rmax then
                        call DestroyEffect(e2)
                        set k = 0
                        loop
                            exitwhen k == 6
                            set r5 = GetRandomReal(1.48, 2.0)
                            set e = EffectSpawn("war3mapimported\\wos_BrandW.mdx", x + 410.0 * Cos(k * 60.0 * bj_DEGTORAD), y + 410.0 * Sin(k * 60.0 * bj_DEGTORAD), GetRandomReal(0, 359), 1.5, r5, 0.0)
                            call AnimDummyEff(e, 0.25, 0.1)
                            call ColorEffDummy3(e, 1.0, 255, 255, 255, 1.5)
                            set k = k + 1
                        endloop
                        set k = 0
                        loop
                            exitwhen k > 7
                            set r5 = GetRandomReal(1.0, 1.2)
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_dustwave222.mdx", x, y, GetRandomReal(0, 359), r5, 1.35 + k * 0.65, 0.0, 55, 255, 155, 50))
                            set k = k + 1
                        endloop
                        set r5 = GetRandomReal(0, 359)
                        set e = EffectSpawn("war3mapimported\\wos_opm (3832).mdl", x, y, r5, 1.0, 0.90, 1.0)
                        call AnimDummyEff(e, 0.25, 0.0)
                        call ColorEffDummy3(e, 1.0, 255, 255, 255, 1.5)
                        set r5 = r5 + 180.0
                        call DecorRemove(c, x, y, aoe, BrandishW_DecorDamage)
                        set e = EffectSpawn("war3mapimported\\wos_opm (3832).mdl", x, y, r5, 1.0, 0.45, 25.0)
                        call AnimDummyEff(e, 0.25, 0.0)
                        call ColorEffDummy3(e, 1.0, 255, 255, 255, 1.5)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_JY-ZK_BM_Mine blasting-Lv-075.mdl", x, y, GetRandomReal(0, 359), 0.5, 2.15, 0.0))
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call dmgphys(c, u, dmg)
                                call RootUnit(c, u, BrandishW_RootDuration)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                        set r = 999.0
                    endif
                else
                    if r < rmax and e2 != null then
                        call DestroyEffect(e2)
                    endif
                    call DestroyGroup(g)
                    set g = null
                    set e2 = null
                    set e = null
                    set c = null
                    set m_BrandishW[i] = m_BrandishW[MUI_BrandishW]
                    set MUI_BrandishW = MUI_BrandishW - 1
                    call deallocate(this)
                    set i = i - 1
                    if MUI_BrandishW == -1 then
                        call BrandishTimer05Release()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BrandishW_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            local integer level = GetUnitAbilityLevel(NewC, BrandishW_ID)
            if level < 1 then
                set level = 1
            endif
            set MUI_BrandishW = MUI_BrandishW + 1
            set m_BrandishW[MUI_BrandishW] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r5 = 0.0
            set g = CreateGroup()
            set r = 0.0
            set aoe = BrandishW_DamageAoe
            set a = GAngle2(c, x, y)
            set dmg = GetHeroInt(c, true) * (BrandishW_DamageIntBase + (BrandishW_DamageIntStep * (level - 1)))
            set dmg = dmg + BrandishW_Damage2StaticBase + (BrandishW_Damage2StaticStep * (level - 1))
            set rmax = BrandishW_DelayBase - (BrandishW_DelayStep * (level - 1))
            call MakeSound("war3mapimported\\Hero_Brandish_W")
            call VisionTimed(GetOwningPlayer(c), x, y, 1000.0, 2.5)
            call Brandish_RestoreOrder(c, 3)
            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiGreen.mdx", c, "hand right")
            if MUI_BrandishW == 0 then
                call BrandishTimer05Acquire()
            endif
        endmethod
    endstruct

    //===========================================================================
    // E - Matter Recovery (Heal & Damage Reduction)
    //===========================================================================
    private struct BrandishSpells_E
        private static integer array m_BrandishE
        private static integer MUI_BrandishE = -1

        unit c
        unit td
        integer check
        real r
        real heal
        real rmax

        public static method Loop_BrandishE takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_BrandishE
                set this = m_BrandishE[i]
                if SpellBoolCaster(td) and GetUnitAbilityLevel(td, check) > 0 and r < rmax and not CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) then
                    set r = r + 1.0
                    call SetHpCurrent2(c, td, heal)
                else
                    call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_eff (119)brand.mdx", td, "chest"))
                    set c = null
                    set td = null
                    set m_BrandishE[i] = m_BrandishE[MUI_BrandishE]
                    set MUI_BrandishE = MUI_BrandishE - 1
                    call deallocate(this)
                    set i = i - 1
                    if MUI_BrandishE == -1 then
                        call BrandishTimerERelease()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BrandishE_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create()
            local integer level = GetUnitAbilityLevel(NewC, BrandishE_ID)
            if level < 1 then
                set level = 1
            endif
            set MUI_BrandishE = MUI_BrandishE + 1
            set m_BrandishE[MUI_BrandishE] = this
            set c = NewC
            set td = NewTd
            set r = 0.0
            call Brandish_RestoreOrder(c, 8)
            set rmax = BrandishE_DurationBase + (BrandishE_DurationStep * (level - 1))
            set heal = GetHeroInt(c, true) * (BrandishE_HealIntBase + (BrandishE_HealIntStep * (level - 1)))
            set heal = heal + BrandishE_HealStaticBase + (BrandishE_HealStaticStep * (level - 1))
            call MakeSound("war3mapimported\\Hero_Brandish_E")
            call MakeSound("war3mapimported\\Hero_Brandish_T3")
            call BrandishSpells_Utility.BuffUnitBran(c, td, level)
            if level == 1 then
                set check = BrandishE_Buff1_ID
            elseif level == 2 then
                set check = BrandishE_Buff2_ID
            elseif level == 3 then
                set check = BrandishE_Buff3_ID
            elseif level == 4 then
                set check = BrandishE_Buff4_ID
            else
                set check = BrandishE_Buff5_ID
            endif
            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_eff (119)brand.mdx", td, "chest"))
            if MUI_BrandishE == 0 then
                call BrandishTimerEAcquire()
            endif
        endmethod
    endstruct

    //===========================================================================
    // R - Tectonic Rupture
    //===========================================================================
    private struct BrandishSpells_R
        private static integer array m_BrandishR
        private static integer MUI_BrandishR = -1

        unit c
        real x
        real y
        real x1
        real y1
        integer k
        integer k2
        group g
        unit u
        real dmg
        real aoe
        real scale
        real r
        effect e
        effect e2
        real a
        real rmax

        public static method Loop_BrandishR takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_BrandishR
                set this = m_BrandishR[i]
                if SpellBoolCaster(c) and r <= rmax and LoadInteger(hs, GetHandleId(Player(k2)), StringHash("r cancel")) == 0 then
                    set r = RoundReal(r + 0.05, 3)
                    set x1 = GetUnitX(c)
                    set y1 = GetUnitY(c)
                    if r == 0.05 then
                        call VisionTimed(GetOwningPlayer(c), x, y, 1500.0, 3.0)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_2B2506950AC33FAB.mdx", x1, y1, GetRandomReal(0, 359), 1.5, 1.0, 0.0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_2B2506950AC33FAB.mdx", x, y, GetRandomReal(0, 359), 1.5, 6.5 * scale, 100.0))
                    endif
                    if r == 0.30 then
                        set k = 0
                        loop
                            exitwhen k == 7
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_T_dustgaraa2.mdx", x, y, GetRandomReal(0, 359), 0.5, k * 0.85 * scale, 0.0, 255, 255, 200, 125))
                            set k = k + 1
                        endloop
                    endif
                    if r == 0.80 then
                        set k = 0
                        call MakeSound("war3mapimported\\Hero_Brandish_T3")
                        loop
                            exitwhen k == 3
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZarakiWCrack1.mdx", x + 375.0 * scale * Cos(k * 120.0 * bj_DEGTORAD), y + 375.0 * scale * Sin(k * 120.0 * bj_DEGTORAD), GetRandomReal(0, 359), 2.5, 2.0 * scale, 1.0))
                            set k = k + 1
                        endloop
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_Effect AZ_Shockwave Light.mdx", x, y, GetRandomReal(0, 359), 2.0, 0.74 * scale, 1.0))
                    endif
                    if r >= BrandishR_Delay then
                        set k = 0
                        loop
                            exitwhen k == 7
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_T_dustgaraa2.mdx", x, y, GetRandomReal(0, 359), 0.85, 2.5 + k * 0.45 * scale, 0.0, 255, 255, 200, 225))
                            set k = k + 1
                        endloop
                        call DecorRemove(c, x, y, aoe, BrandishR_DecorDamage)
                        set e = EffectSpawn("war3mapImported\\wos_wangha2.mdx", x, y, GetRandomReal(0, 359), 0.25, 1.4 * scale, 1.0)
                        call ColorEffDummy4(e, 0.0, 255, 255, 255, 0.42)
                        call ColorEffDummy3(e, 1.0, 255, 255, 255, 1.11)
                        set e2 = EffectSpawn2("war3mapImported\\wos_kamni.mdx", x, y, GetRandomReal(0, 359), 1.25, 2.55 * scale, 1.0, 1.35)
                        call ColorEffDummy3(e2, 0.8, 255, 255, 255, 1.65)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call dmgphys(c, u, dmg)
                                call MUE(u, SR3(u, x, y), 0.21, GAngle2(u, x, y))
                                call SlowUnit(c, u, BrandishR_Slow, BrandishR_SlowDuration)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdx", x, y, GetRandomReal(0, 359), 0.86, 2.1 * scale, 1.0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_az_xiaonajia01_d_W.mdx", x, y, GetRandomReal(0, 359), 1.15, 2.95 * scale, 1.0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_LD2209 (129).mdx", x, y, GetRandomReal(0, 359), 1.35, 3.55 * scale, 1.0))
                        set r = 999.0
                    endif
                else
                    call DestroyGroup(g)
                    set g = null
                    set e = null
                    set e2 = null
                    set c = null
                    set m_BrandishR[i] = m_BrandishR[MUI_BrandishR]
                    set MUI_BrandishR = MUI_BrandishR - 1
                    call deallocate(this)
                    set i = i - 1
                    if MUI_BrandishR == -1 then
                        call BrandishTimer05Release()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BrandishR_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            local integer level = GetUnitAbilityLevel(NewC, BrandishR_ID)
            if level < 1 then
                set level = 1
            endif
            set MUI_BrandishR = MUI_BrandishR + 1
            set m_BrandishR[MUI_BrandishR] = this
            set c = NewC
            set r = 0.0
            set x = NewX
            set y = NewY
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set g = CreateGroup()
            set dmg = GetHeroInt(c, true) * (BrandishR_DamageIntBase + (BrandishR_DamageIntStep * (level - 1)))
            set aoe = BrandishR_DamageAoe
            set scale = aoe / 1050.0
            call Brandish_RestoreOrder(c, 3)
            call SetUnitTimeScale(c, 0.25)
            set a = GetUnitFacing(c) * bj_DEGTORAD
            call MakeSound("war3mapimported\\Hero_Brandish_R1")
            call MakeSound("war3mapimported\\Hero_Brandish_R3")
            call VisionTimed(GetOwningPlayer(c), GetUnitX(c), GetUnitY(c), 1800.0, 4.0)
            set rmax = BrandishR_Delay
            if MUI_BrandishR == 0 then
                call BrandishTimer05Acquire()
            endif
        endmethod
    endstruct

    //===========================================================================
    // T - Command T (Gigantification)
    //===========================================================================
    private struct BrandishSpells_T
        private static integer array m_BrandishT
        private static integer MUI_BrandishT = -1

        unit c
        real x
        real y
        real r2
        integer k
        real scale
        real scale2
        real r4
        real r5
        real r8
        group g
        group g2
        unit u
        real dmg
        real dmg2
        integer check2
        real aoe
        real r
        effect e
        effect e2
        real a
        real rmax

        public static method Loop_BrandishT takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_BrandishT
                set this = m_BrandishT[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.05, 3)
                    if GetUnitAbilityLevel(c, BrandishF_Buff_ID) > 0 then
                        set r8 = aoe * (1.0 + (BrandishF_DamageOutputIncrease / 100.0))
                    else
                        set r8 = aoe
                    endif
                    if r == 0.70 then
                        set e2 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiGreen.mdx", c, "hand right")
                        call MakeSound("war3mapimported\\Hero_Brandish_T2")
                        call SetUnitAnimationByIndex(c, 9)
                        call SetUnitTimeScale(c, 0.50)
                    endif
                    if r == BrandishT_CastTime then
                        set x = GetUnitX(c) + 150.0 * Cos(a)
                        set y = GetUnitY(c) + 150.0 * Sin(a)
                        call GroupClear(g)
                        if e2 != null then
                            call DestroyEffect(e2)
                            set e2 = null
                        endif
                        call StopSpellUnit(c)
                        call ColorEffDummy3((EffectSpawn("war3mapImported\\wos_Brand_Opdef (178).mdl", x, y, GetRandomReal(0, 359), 1.0, 6.0, 1.0)), 0.5, 255, 255, 255, 2.0)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_JY-ZK_BM_Mine blasting-Lv-075.mdl", x, y, GetRandomReal(0, 359), 0.5, 3.55, 0.0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_chushou_by_wood_effect_earth_longzhituxi.mdx", x, y, GetRandomReal(0, 359), 0.5, 2.0, 0.0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_FBT-dilie2big.mdx", x, y, GetRandomReal(0, 359), 0.5, 4.0, 1.0))
                        set k = 0
                        loop
                            exitwhen k > 7
                            set r5 = GetRandomReal(0.5, 0.9)
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_dustwave222.mdx", x, y, GetRandomReal(0, 359), r5, 2.35 + k * 0.85, 0.0, 55, 255, 155, 50))
                            set k = k + 1
                        endloop
                        call DecorRemove(c, x, y, r8, BrandishT_DecorDamage)
                        call MakeSound("war3mapimported\\Hero_Brandish_T4")
                        call GroupEnumUnitsInRange(g, x, y, r8, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call dmgphys(c, u, dmg)
                                call StunUnit(c, u, BrandishT_Stun)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                call GroupAddUnit(g2, u)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                    endif
                    if r == BrandishT_CastTime and check2 == 1 then
                        call StopSpellUnit(c)
                        call AddSpellLevel(c, 'A01C', 17, true)
                        call BuffUnit1(c, c, 15)
                    endif
                    if r > BrandishT_CastTime and check2 == 1 then
                        if r2 > 0.30 then
                            set r2 = 0.0
                            set x = GetUnitX(c)
                            set y = GetUnitY(c)
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_dustgaraa2.mdx", x, y, GetRandomReal(0, 359), 1.0, 3.0, 0.0))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdl", x, y, GetRandomReal(0, 359), 1.0, 3.55, 0.0))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Eff_Ord_YeYe_Eat_DiBanZhaKai2.mdx", x, y, GetRandomReal(0, 359), 1.5, 2.0, 0.0))
                            call DecorRemove(c, x, y, r8 - 500.0, BrandishT_DecorDamage)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, r8 - 500.0, Condition(function NoDecor_Filter))
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                    call dmgphys(c, u, dmg2)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        else
                            if GetUnitCurrentOrder(c) == OrderId("move") or GetUnitCurrentOrder(c) == OrderId("smart") then
                                set r2 = r2 + 0.05
                            endif
                        endif
                    endif
                    if r >= r4 then
                        set r = 9999.0
                        set scale2 = BrandishSpells_Utility.GetTotalScale(c)
                        call SaveReal(hs, GetHandleId(c), StringHash("TMult"), 1.0)
                        set scale = BrandishSpells_Utility.GetTotalScale(c)
                        call MakeSound("war3mapimported\\Hero_Brandish_T3")
                        call ScaleDummy(c, 0.30, scale2, scale)
                    endif
                else
                    if r < BrandishT_CastTime and e2 != null then
                        call DestroyEffect(e2)
                    endif
                    if check2 == 1 then
                        call UnitRemoveAbility(c, 'B02C')
                        call AddSpellLevel(c, 'A01C', 17, false)
                    endif
                    set scale2 = BrandishSpells_Utility.GetTotalScale(c)
                    call SaveReal(hs, GetHandleId(c), StringHash("TMult"), 1.0)
                    set scale = BrandishSpells_Utility.GetTotalScale(c)
                    call ScaleDummy(c, 0.20, scale2, scale)
                    call SaveInteger(hs, GetHandleId(c), StringHash("t"), 0)
                    if e != null then
                        call DestroyEffect(e)
                    endif
                    call StopSpellUnit(c)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set e = null
                    set e2 = null
                    set c = null
                    set m_BrandishT[i] = m_BrandishT[MUI_BrandishT]
                    set MUI_BrandishT = MUI_BrandishT - 1
                    call deallocate(this)
                    set i = i - 1
                    if MUI_BrandishT == -1 then
                        call BrandishTimer05Release()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BrandishT_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_BrandishT = MUI_BrandishT + 1
            set m_BrandishT[MUI_BrandishT] = this
            set c = NewC
            set r = 0.0
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set dmg = GetHeroInt(c, true) * BrandishT_DamageIntBase
            set dmg2 = GetHeroInt(c, true) * BrandishT_DamageIntBase2
            set r2 = 0.0
            set check2 = 0
            set r4 = BrandishT_CastTime + BrandishT_Duration
            set rmax = r4 + 0.50
            if GetHeroLevel(c) >= 35 then
                set check2 = 1
                set r4 = BrandishT_CastTime + BrandishT_Lv35Duration
                set rmax = r4 + 0.50
            endif
            set scale = BrandishSpells_Utility.GetTotalScale(c)
            call SaveReal(hs, GetHandleId(c), StringHash("TMult"), BrandishT_ScaleIncrease / 100.0)
            set scale2 = BrandishSpells_Utility.GetTotalScale(c)
            call ScaleDummy(c, 0.75, scale, scale2)
            set aoe = BrandishT_DamageAoe
            if GetUnitAbilityLevel(c, BrandishF_Buff_ID) > 0 then
                set r8 = aoe * (1.0 + (BrandishF_DamageOutputIncrease / 100.0))
            else
                set r8 = aoe
            endif
            call StartSpellUnit(c)
            set a = GetUnitFacing(c) * bj_DEGTORAD
            call MakeSound("war3mapimported\\Hero_Brandish_T1")
            call MakeSound("war3mapimported\\Hero_Brandish_T3")
            call VisionTimed(GetOwningPlayer(c), GetUnitX(c), GetUnitY(c), 1800.0, 4.0)
            call SaveInteger(hs, GetHandleId(c), StringHash("t"), 1)
            call SetUnitFacingTimed(c, a * bj_RADTODEG, 0.0)
            call SetUnitTimeScale(c, 2.0)
            if MUI_BrandishT == 0 then
                call BrandishTimer05Acquire()
            endif
        endmethod
    endstruct

    //===========================================================================
    // F - Command F (Scale Manipulation)
    //===========================================================================
    private struct BrandishSpells_F
        private static integer array m_BrandishF
        private static integer MUI_BrandishF = -1

        unit c
        unit td
        real scale
        real scale2
        integer check
        integer check2
        real r
        real rmax

        public static method Loop_BrandishF takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_BrandishF
                set this = m_BrandishF[i]
                if GetUnitAbilityLevel(td, check2) > 0 and SpellBoolCaster(c) and r < rmax and not CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) then
                    if not IsUnitPaused(td) then
                        set r = RoundReal(r + 0.05, 3)
                    endif
                else
                    set scale2 = BrandishSpells_Utility.GetTotalScale(td)
                    call SaveReal(hs, GetHandleId(td), StringHash("FMult"), 1.0)
                    set scale = BrandishSpells_Utility.GetTotalScale(td)
                    call ScaleDummy(td, 0.50, scale2, scale)
                    if check == 0 then
                        call SaveInteger(hs, GetHandleId(td), StringHash("brandish g enemy"), 0)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_brandi_red_increase.mdl", GetUnitX(td), GetUnitY(td), 0.0, 1.25, 2.20, 0.0))
                    else
                        call SaveInteger(hs, GetHandleId(td), StringHash("brandish g ally"), 0)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_brandi_green_decrease.mdl", GetUnitX(td), GetUnitY(td), 0.0, 1.25, 2.00, 0.0))
                    endif
                    call MakeSound("war3mapimported\\Hero_Brandish_G3")
                    set c = null
                    set td = null
                    set m_BrandishF[i] = m_BrandishF[MUI_BrandishF]
                    set MUI_BrandishF = MUI_BrandishF - 1
                    call deallocate(this)
                    set i = i - 1
                    if MUI_BrandishF == -1 then
                        call BrandishTimer05Release()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BrandishF_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create()
            set MUI_BrandishF = MUI_BrandishF + 1
            set m_BrandishF[MUI_BrandishF] = this
            set c = NewC
            set td = NewTd
            set r = 0.0
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapimported\\Hero_Brandish_G01")
            else
                call MakeSound("war3mapimported\\Hero_Brandish_G02")
            endif
            call MakeSound("war3mapimported\\Hero_Brandish_G1")
            set scale = BrandishSpells_Utility.GetTotalScale(td)
            call SaveReal(hs, GetHandleId(td), StringHash("FMult"), 1.0)
            if IsUnitEnemy(td, GetOwningPlayer(c)) then
                call SaveReal(hs, GetHandleId(td), StringHash("FMult"), BrandishF_DamageOutputDecreaseScale / 100.0)
                set check = 0
                set check2 = BrandishF_Debuff_ID
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_brandi_red_decrease.mdl", GetUnitX(td), GetUnitY(td), 0.0, 1.25, 2.20, 0.0))
                call SaveInteger(hs, GetHandleId(td), StringHash("brandish g enemy"), 1)
                call BrandishSpells_Utility.BuffUnitBran2(c, td, 1, true)
            else
                set check = 1
                set check2 = BrandishF_Buff_ID
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_brandi_green_increase.mdl", GetUnitX(td), GetUnitY(td), 0.0, 1.25, 2.00, 0.0))
                call SaveInteger(hs, GetHandleId(td), StringHash("brandish g ally"), 1)
                call SaveReal(hs, GetHandleId(td), StringHash("FMult"), BrandishF_DamageOutputIncreaseScale / 100.0)
                call BrandishSpells_Utility.BuffUnitBran2(c, td, 1, false)
            endif
            set scale2 = BrandishSpells_Utility.GetTotalScale(td)
            call ScaleDummy(td, 0.50, scale, scale2)
            set rmax = BrandishF_Time
            call Brandish_RestoreOrder(c, 5)
            if MUI_BrandishF == 0 then
                call BrandishTimer05Acquire()
            endif
        endmethod
    endstruct

    //===========================================================================
    // Инициализация библиотеки и публичный интерфейс
    //===========================================================================
    private function BrandishTimer03Loop takes nothing returns nothing
        call BrandishSpells_Q.Loop_BrandishQ()
    endfunction

    private function BrandishTimer05Loop takes nothing returns nothing
        call BrandishSpells_W.Loop_BrandishW()
        call BrandishSpells_R.Loop_BrandishR()
        call BrandishSpells_T.Loop_BrandishT()
        call BrandishSpells_F.Loop_BrandishF()
    endfunction

    private function BrandishTimerELoop takes nothing returns nothing
        call BrandishSpells_E.Loop_BrandishE()
    endfunction

    private function BrandishTimerFLoop takes nothing returns nothing
        call BrandishSpells_F.Loop_BrandishF()
    endfunction

    private function InitBrandishSpells takes nothing returns nothing
        set BrandishTimer03 = CreateTimer()
        set BrandishTimer03Callback = function BrandishTimer03Loop

        set BrandishTimer05 = CreateTimer()
        set BrandishTimer05Callback = function BrandishTimer05Loop

        set BrandishTimerE = CreateTimer()
        set BrandishTimerECallback = function BrandishTimerELoop

        set BrandishTimerF = CreateTimer()
        set BrandishTimerFCallback = function BrandishTimerFLoop
    endfunction

    function BrandishQ_Start takes unit c, real x, real y returns nothing
        call BrandishSpells_Q.BrandishQ_Start(c, x, y)
    endfunction

    function BrandishW_Start takes unit c, real x, real y returns nothing
        call BrandishSpells_W.BrandishW_Start(c, x, y)
    endfunction

    function BrandishE_Start takes unit c, unit td returns nothing
        call BrandishSpells_E.BrandishE_Start(c, td)
    endfunction

    function BrandishR_Start takes unit c, real x, real y returns nothing
        call BrandishSpells_R.BrandishR_Start(c, x, y)
    endfunction

    function BrandishT_Start takes unit c returns nothing
        call BrandishSpells_T.BrandishT_Start(c)
    endfunction

    function BrandishF_Start takes unit c, unit td returns nothing
        call BrandishSpells_F.BrandishF_Start(c, td)
    endfunction

endlibrary