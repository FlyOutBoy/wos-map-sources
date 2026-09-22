library NeuvilletteSpells initializer InitNeuvilletteSpells uses GearSystems
    globals
        private timer NeuvilletteTimer03
        private code NeuvilletteTimer03Callback
        private integer NeuvilletteTimer03Users = 0

//--------------------------------------Neuvillette Core--------------------------------------------------
        integer Neuvillette_ID = 'H01C'

//---------------Q ability (Tidal Eruption)------------------------------------
        integer NeuvilletteQ_ID = 'A07R'
        real NeuvilletteQ_DamageIntBase = 1.0
        real NeuvilletteQ_DamageIntStep = 1.0
        real NeuvilletteQ_DamageStaticBase = 150.0
        real NeuvilletteQ_DamageStaticStep = 0.0
        real NeuvilletteQ_DamageAoe = 475.0
        real NeuvilletteQ_CastTime = 0.63
        boolean NeuvilletteQ_IsInvul = false
        real NeuvilletteQ_DecorDamage = 40.0

//---------------W ability (Surging Plunge)------------------------------------
        integer NeuvilletteW_ID = 'A07S'
        real NeuvilletteW_DamageIntBase = 1.0
        real NeuvilletteW_DamageIntStep = 1.0
        real NeuvilletteW_Damage2StaticBase = 150.0
        real NeuvilletteW_Damage2StaticStep = 0.0
        real NeuvilletteW_DamageAoe = 450.0
        real NeuvilletteW_BlinkDistance = 110.0
        real NeuvilletteW_CastTime = 0.60
        boolean NeuvilletteW_IsInvul = false
        real NeuvilletteW_DecorDamage = 35.0

//---------------E ability (Torrential Rain)-----------------------------------
        integer NeuvilletteE_ID = 'A07T'
        real NeuvilletteE_DamageIntBase = 4.0
        real NeuvilletteE_DamageIntStep = 1.0
        real NeuvilletteE_DamageAoeBase = 800.0
        real NeuvilletteE_DamageAoeStep = 50.0
        real NeuvilletteE_Duration = 5.0
        real NeuvilletteE_DamageInterval = 0.45
        integer NeuvilletteE_SlowBase = 0
        integer NeuvilletteE_SlowAdd = 5
        integer NeuvilletteE_SlowDuration = 1
        boolean NeuvilletteE_IsInvul = false
        real NeuvilletteE_DecorDamage = 5.0

//---------------R ability (Equitable Judgment - Hydro Beam)-------------------
        integer NeuvilletteR_ID = 'A07U'
        real NeuvilletteR_DamageIntBase = 4.0
        real NeuvilletteR_DamageIntStep = 1.0
        real NeuvilletteR_DamageAoe = 375.0
        real NeuvilletteR_PushRange = 120.0
        real NeuvilletteR_PushDuration = 0.30
        real NeuvilletteR_CastTime = 0.51
        real NeuvilletteR_Duration = 1.50
        real NeuvilletteR_DamageInterval = 0.24
        boolean NeuvilletteR_IsInvul = true
        real NeuvilletteR_DecorDamage = 100.0

//---------------T ability (O Fonta, I Drink of Thee)--------------------------
        integer NeuvilletteT_ID = 'A07V'
        real NeuvilletteT_DamageIntBase = 1.70
        real NeuvilletteT_DamageAoe = 1250.0
        integer NeuvilletteT_PillarsCount = 10
        real NeuvilletteT_DamageAoePillar = 775.0
        real NeuvilletteT_ReduceRCd_Sec = 15.0
        integer NeuvilletteT_Slow = 60
        integer NeuvilletteT_Duration = 2
        real NeuvilletteT_CastDuration = 1.30
        boolean NeuvilletteT_IsInvul = true
        real NeuvilletteT_DecorDamage = 100.0

//---------------F ability (Draconic Authority - Passive)----------------------
        integer NeuvilletteF_ID = 'A07W'
        real NeuvilletteF_DamageAdd = 15.0
        real NeuvilletteF_DamageAdd35 = 5.0
    endglobals

    //===========================================================================
    // Управление централизованным таймером 0.03 сек
    //===========================================================================
    private function NeuvilletteTimer03Acquire takes nothing returns nothing
        set NeuvilletteTimer03Users = NeuvilletteTimer03Users + 1
        if NeuvilletteTimer03Users == 1 then
            call TimerStart(NeuvilletteTimer03, 0.03, true, NeuvilletteTimer03Callback)
        endif
    endfunction

    private function NeuvilletteTimer03Release takes nothing returns nothing
        set NeuvilletteTimer03Users = NeuvilletteTimer03Users - 1
        if NeuvilletteTimer03Users <= 0 then
            set NeuvilletteTimer03Users = 0
            call PauseTimer(NeuvilletteTimer03)
        endif
    endfunction

    //===========================================================================
    // Q Ability Struct
    //===========================================================================
    private struct NeuvilletteSpells_Q
        private static integer array m_NeuvilletteQ
        private static integer MUI_NeuvilletteQ = -1

        unit c
        real x
        real y
        group g
        real dmg
        real aoe
        real r
        real rmax
        effect e

        public static method Loop_NeuvilletteQ takes nothing returns nothing
            local integer i = 0
            local thistype this
            local unit u
            local boolean remove

            loop
                exitwhen i > MUI_NeuvilletteQ
                set this = m_NeuvilletteQ[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or GetWidgetLife(c) <= 0.405 then
                    set remove = true
                elseif SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)

                    if r == RoundReal(rmax - 0.21, 3) then
                        call MakeSound("war3mapImported\\Hero_Kenjaku_W2 3")
                    endif

                    if r >= rmax then
                        call BlzSetSpecialEffectTimeScale(e, 2.50)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_shockwave_b.mdl", x, y, 1, 1, 2.45, 125))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_shockwave_b.mdl", x, y, 1, 1, 2.45, 475))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_waterexplosion.mdl", x, y, 1, 2.5, 2.5, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_2-[tx]-03-03jianta (3)_1.mdl", x, y, 1, 2.15, 3, 1))
                        call DecorRemove(c, x, y, aoe, NeuvilletteQ_DecorDamage)

                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            call GroupRemoveUnit(g, u)
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                if GetHeroLevel(c) >= 35 then
                                    call ErzaPassive(c, u, 2)
                                endif
                                call dmgmag(c, u, dmg)
                            endif
                        endloop
                        set remove = true
                    endif
                else
                    set remove = true
                endif

                if remove then
                    if c != null and GetUnitTypeId(c) != 0 then
                        if NeuvilletteQ_IsInvul then
                            call StopSpellUnit(c)
                        else
                            call StopSpellUnit2(c)
                        endif
                    endif
                    if e != null then
                        call DestroyEffect(e)
                    endif
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    set c = null
                    set e = null
                    set g = null
                    set u = null
                    set m_NeuvilletteQ[i] = m_NeuvilletteQ[MUI_NeuvilletteQ]
                    set MUI_NeuvilletteQ = MUI_NeuvilletteQ - 1
                    call deallocate(this)
                    if MUI_NeuvilletteQ == -1 then
                        call NeuvilletteTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            set u = null
        endmethod

        public static method NeuvilletteQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this
            local integer level
            local real a

            if NewC == null or GetUnitTypeId(NewC) == 0 or GetWidgetLife(NewC) <= 0.405 then
                return
            endif

            set this = thistype.create()
            set MUI_NeuvilletteQ = MUI_NeuvilletteQ + 1
            set m_NeuvilletteQ[MUI_NeuvilletteQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.0
            set rmax = NeuvilletteQ_CastTime
            set aoe = NeuvilletteQ_DamageAoe
            set g = CreateGroup()

            set level = GetUnitAbilityLevel(c, NeuvilletteQ_ID)
            if level < 1 then
                set level = 1
            endif

            set dmg = GetHeroInt(c, true) * (NeuvilletteQ_DamageIntBase + NeuvilletteQ_DamageIntStep * (level - 1))
            set dmg = dmg + NeuvilletteQ_DamageStaticBase + NeuvilletteQ_DamageStaticStep * (level - 1)

            set a = GAngle2(c, x, y)
            call SetUnitFacing(c, a * bj_RADTODEG)

            if NeuvilletteQ_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif

            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("nevi sound")) == 1 then
                call MakeSound("war3mapImported\\Hero_Neuvillette2_Q")
            else
                call MakeSound("war3mapImported\\Hero_Neuvillette_Q")
            endif

            call SetUnitAnimationByIndex(c, 1)
            call SetUnitTimeScale(c, 0.95)
            set e = EffectSpawn("war3mapimported\\wos_tidalerruption.mdl", x, y, 1, 0.01, 3, 1)

            if MUI_NeuvilletteQ == 0 then
                call NeuvilletteTimer03Acquire()
            endif
        endmethod
    endstruct

    //===========================================================================
    // W Ability Struct
    //===========================================================================
    private struct NeuvilletteSpells_W
        private static integer array m_NeuvilletteW
        private static integer MUI_NeuvilletteW = -1

        unit c
        real x
        real y
        group g
        real dmg
        real aoe
        real r
        real rmax
        real a

        public static method Loop_NeuvilletteW takes nothing returns nothing
            local integer i = 0
            local thistype this
            local unit u
            local boolean remove

            loop
                exitwhen i > MUI_NeuvilletteW
                set this = m_NeuvilletteW[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or GetWidgetLife(c) <= 0.405 then
                    set remove = true
                elseif SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if NeuvilletteW_IsInvul then
                        call DebugUnit(c)
                    else
                        call DebugUnit2(c)
                    endif

                    if r == 0.39 then
                        set a = GAngle2(c, x, y)
                        call SetUnitTimeScale(c, 1.25)
                        call BlinkEff(c)
                        call MakeSound("war3mapimported\\Hero_Neuvillette_W2")
                        call PosUnit(c, x - NeuvilletteW_BlinkDistance * Cos(a), y - NeuvilletteW_BlinkDistance * Sin(a))
                        call SetUnitTimeScale(c, 3.0)
                    endif

                    if r >= rmax then
                        call MakeSound("war3mapimported\\Hero_Okarun_Q2")
                        call DecorRemove(c, x, y, aoe, NeuvilletteW_DecorDamage)

                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            call GroupRemoveUnit(g, u)
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                call dmgphys(c, u, dmg)
                            endif
                        endloop

                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_crackwhitee.mdl", x, y, a * bj_RADTODEG, 1.5, 0.7, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_waterexplosion.mdx", x, y, GetRandomReal(0, 359), 1, 3, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_shockwave_b.mdl", x, y, GetRandomReal(0, 359), 0.8, 4, 145))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_1hongse_2blue.mdl", x, y, GetRandomReal(0, 359), 0.6, 3.75, 0))
                        set remove = true
                    endif
                else
                    set remove = true
                endif

                if remove then
                    if c != null and GetUnitTypeId(c) != 0 then
                        if NeuvilletteW_IsInvul then
                            call StopSpellUnit(c)
                        else
                            call StopSpellUnit2(c)
                        endif
                        call SetUnitTimeScale(c, 1.0)
                    endif
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    set c = null
                    set g = null
                    set u = null
                    set m_NeuvilletteW[i] = m_NeuvilletteW[MUI_NeuvilletteW]
                    set MUI_NeuvilletteW = MUI_NeuvilletteW - 1
                    call deallocate(this)
                    if MUI_NeuvilletteW == -1 then
                        call NeuvilletteTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            set u = null
        endmethod

        public static method NeuvilletteW_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this
            local integer level

            if NewC == null or GetUnitTypeId(NewC) == 0 or GetWidgetLife(NewC) <= 0.405 then
                return
            endif

            set this = thistype.create()
            set MUI_NeuvilletteW = MUI_NeuvilletteW + 1
            set m_NeuvilletteW[MUI_NeuvilletteW] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.0
            set rmax = NeuvilletteW_CastTime
            set aoe = NeuvilletteW_DamageAoe
            set g = CreateGroup()
            set a = GAngle2(c, x, y)

            set level = GetUnitAbilityLevel(c, NeuvilletteW_ID)
            if level < 1 then
                set level = 1
            endif

            set dmg = GetHeroInt(c, true) * (NeuvilletteW_DamageIntBase + NeuvilletteW_DamageIntStep * (level - 1))
            set dmg = dmg + NeuvilletteW_Damage2StaticBase + NeuvilletteW_Damage2StaticStep * (level - 1)

            if NeuvilletteW_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif

            call SetUnitAnimationByIndex(c, 1)
            call SetUnitTimeScale(c, 0.60)

            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("nevi sound")) == 1 then
                call MakeSound("war3mapImported\\Hero_Neuvillette2_W")
            else
                call MakeSound("war3mapimported\\Hero_Neuvillette_W")
            endif

            if MUI_NeuvilletteW == 0 then
                call NeuvilletteTimer03Acquire()
            endif
        endmethod
    endstruct

    //===========================================================================
    // E Ability Struct
    //===========================================================================
    private struct NeuvilletteSpells_E
        private static integer array m_NeuvilletteE
        private static integer MUI_NeuvilletteE = -1

        unit c
        real x
        real y
        real r2
        real r3
        real r4
        group g
        real dmg
        integer slowPercent
        real aoe
        real scale
        real r
        real rmax
        effect e

        public static method Loop_NeuvilletteE takes nothing returns nothing
            local integer i = 0
            local thistype this
            local unit u
            local boolean remove

            loop
                exitwhen i > MUI_NeuvilletteE
                set this = m_NeuvilletteE[i]
                set remove = false

                if r <= rmax then
                    set r = RoundReal(r + 0.03, 3)

                    if r < 0.81 then
                        set scale = scale + r4
                        set aoe = aoe + r3
                        call BlzSetSpecialEffectScale(e, scale)
                    endif

                    if r2 >= NeuvilletteE_DamageInterval then
                        set r2 = 0.0
                        call DecorRemove(c, x, y, aoe, NeuvilletteE_DecorDamage)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            call GroupRemoveUnit(g, u)
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call ErzaPassive(c, u, 2)
                                call dmgmag(c, u, dmg)
                                if slowPercent > 0 then
                                    call SlowUnit(c, u, slowPercent, NeuvilletteE_SlowDuration)
                                endif
                            endif
                        endloop
                    else
                        set r2 = RoundReal(r2 + 0.03, 3)
                    endif
                else
                    set remove = true
                endif

                if remove then
                    if e != null then
                        call DestroyEffect(e)
                    endif
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    set g = null
                    set c = null
                    set e = null
                    set u = null
                    set m_NeuvilletteE[i] = m_NeuvilletteE[MUI_NeuvilletteE]
                    set MUI_NeuvilletteE = MUI_NeuvilletteE - 1
                    call deallocate(this)
                    if MUI_NeuvilletteE == -1 then
                        call NeuvilletteTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            set u = null
        endmethod

        public static method NeuvilletteE_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this
            local integer level
            local real fullAoe
            local real r5
            local real r6

            if NewC == null or GetUnitTypeId(NewC) == 0 then
                return
            endif

            set this = thistype.create()
            set MUI_NeuvilletteE = MUI_NeuvilletteE + 1
            set m_NeuvilletteE[MUI_NeuvilletteE] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.0
            set r2 = 0.0
            set g = CreateGroup()

            set level = GetUnitAbilityLevel(c, NeuvilletteE_ID)
            if level < 1 then
                set level = 1
            endif

            set slowPercent = NeuvilletteE_SlowBase + NeuvilletteE_SlowAdd * (level - 1)
            set fullAoe = NeuvilletteE_DamageAoeBase + NeuvilletteE_DamageAoeStep * (level - 1)
            set dmg = GetHeroInt(c, true) * (NeuvilletteE_DamageIntBase + NeuvilletteE_DamageIntStep * (level - 1))
            set dmg = dmg / (NeuvilletteE_Duration * 2.0)
            set rmax = NeuvilletteE_Duration + 0.60

            set r5 = fullAoe / 1000.0
            set r6 = 2.0 * r5
            set r4 = r6 / 27.0
            set r3 = fullAoe / 27.0
            set aoe = 25.0
            set scale = 0.0

            call VisionTimed(GetOwningPlayer(c), x, y, fullAoe + 250.0, rmax)
            set e = EffectSpawn("war3mapImported\\wos_rain-0631C2.mdl", x, y, 2.0 * (fullAoe / 1150.0), 1.0, 2.0 * r5, 1.0)
            call BlzPlaySpecialEffect(e, ANIM_TYPE_STAND)

            call SetUnitAnimationByIndex(c, 2)
            call SetUnitTimeScale(c, 1.0)

            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("nevi sound")) == 1 then
                call MakeSound("war3mapImported\\Hero_Neuvillette2_E")
            else
                call MakeSound("war3mapimported\\Hero_Neuvillette_E")
            endif
            call MakeSound("war3mapimported\\Hero_Neuvillette_E2")

            if MUI_NeuvilletteE == 0 then
                call NeuvilletteTimer03Acquire()
            endif
        endmethod
    endstruct

    //===========================================================================
    // R Ability Struct (Two-Phase: Charge -> Hydro Pump Beam)
    //===========================================================================
    private struct NeuvilletteSpells_R
        private static integer array m_NeuvilletteR
        private static integer MUI_NeuvilletteR = -1

        unit c
        real x
        real y
        real x1
        real y1
        real r2
        real r5
        group g
        group g2
        real dmg
        real aoe
        real r
        real rmax
        integer check
        effect e
        effect e2
        effect e3
        effect e4
        real a

        public static method Loop_NeuvilletteR takes nothing returns nothing
            local integer i = 0
            local thistype this
            local real targetA
            local real step
            local real diff
            local integer k
            local real r4
            local real r6
            local unit u
            local boolean remove

            loop
                exitwhen i > MUI_NeuvilletteR
                set this = m_NeuvilletteR[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or GetWidgetLife(c) <= 0.405 then
                    set remove = true
                elseif SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if NeuvilletteR_IsInvul then
                        call DebugUnit(c)
                    else
                        call DebugUnit2(c)
                    endif

                    // Фаза 0: Подготовка / Зарядка луча
                    if check == 0 then
                        if r == 0.21 then
                            set r5 = 70.0
                            set e = EffectSpawn3("war3mapImported\\wos_water_sign.mdl", GetUnitX(c) + r5 * Cos(a), GetUnitY(c) + r5 * Sin(a), a * bj_RADTODEG + 180.0, 1.0, 0.6, 185.0, -90.0)
                            call ScaleEffDummy(e, 0.3, 0.01, 0.6)
                            call ColorEffDummy4(e, 0, 255, 255, 255, 0.3)
                        endif
                        if r == 0.27 then
                            call MakeSound("war3mapimported\\Hero_Neuvillette_R2")
                        endif
                        if r >= NeuvilletteR_CastTime then
                            set check = 1
                            set r = 0.0
                            set rmax = NeuvilletteR_Duration
                            set r5 = 10.0
                            call SetUnitTimeScale(c, 0.0)

                            set e2 = EffectSpawn("war3mapImported\\wos_waterbeam.mdl", GetUnitX(c) + r5 * Cos(a), GetUnitY(c) + r5 * Sin(a), a * bj_RADTODEG, 1.6, 0.64, 80.0)
                            call ColorEffDummy4(e2, 0, 255, 255, 255, 0.4)

                            set x = GetUnitX(c) + 150.0 * Cos(a)
                            set y = GetUnitY(c) + 150.0 * Sin(a)
                            set MouseX[GetPlayerId(GetOwningPlayer(c))] = x
                            set MouseY[GetPlayerId(GetOwningPlayer(c))] = y
                            call MouseOn(GetOwningPlayer(c))
                        endif

                    // Фаза 1: Активное поддержание потокового луча
                    else
                        set x1 = GetMouseX(GetOwningPlayer(c))
                        set y1 = GetMouseY(GetOwningPlayer(c))
                        set targetA = GAngle2(c, x1, y1)
                        set step = 14.0 * bj_DEGTORAD
                        set diff = targetA - a

                        // Нормализация разницы углов
                        if diff > bj_PI then
                            set diff = diff - 2.0 * bj_PI
                        elseif diff < -bj_PI then
                            set diff = diff + 2.0 * bj_PI
                        endif

                        // Плавный поворот за курсором
                        if diff > step then
                            set a = a + step
                        elseif diff < -step then
                            set a = a - step
                        else
                            set a = targetA
                        endif

                        call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
                        call BlzSetSpecialEffectPosition(e, GetUnitX(c) + r5 * Cos(a), GetUnitY(c) + r5 * Sin(a), BlzGetLocalSpecialEffectZ(e))
                        call BlzSetSpecialEffectPosition(e2, GetUnitX(c) + r5 * Cos(a), GetUnitY(c) + r5 * Sin(a), BlzGetLocalSpecialEffectZ(e2))
                        call BlzSetSpecialEffectYaw(e, a + 180.0 * bj_DEGTORAD)
                        call BlzSetSpecialEffectYaw(e2, a)

                        if r2 >= NeuvilletteR_DamageInterval then
                            set r2 = 0.0
                            set k = 0
                            call GroupClear(g2)
                            set r6 = 300.0
                            set x = GetUnitX(c) + r6 * Cos(a)
                            set y = GetUnitY(c) + r6 * Sin(a)

                            loop
                                exitwhen k == 6
                                call DecorRemove(c, x, y, aoe, NeuvilletteR_DecorDamage)
                                set r4 = NeuvilletteR_PushRange - (NeuvilletteR_PushRange * (I2R(k) / 10.0))
                                call VisionTimed(GetOwningPlayer(c), x, y, aoe + 400.0, 2.0)

                                call GroupClear(g)
                                call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    call GroupRemoveUnit(g, u)
                                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                        if GetHeroLevel(c) >= 35 then
                                            call ErzaPassive(c, u, 2)
                                        endif
                                        call dmgmag(c, u, dmg)
                                        call GroupAddUnit(g2, u)
                                        call MUE(u, r4, NeuvilletteR_PushDuration, a)
                                    endif
                                endloop

                                set k = k + 1
                                set r6 = r6 + 370.0
                                set x = GetUnitX(c) + r6 * Cos(a)
                                set y = GetUnitY(c) + r6 * Sin(a)
                            endloop
                        else
                            set r2 = RoundReal(r2 + 0.03, 3)
                        endif

                        if r >= rmax then
                            set remove = true
                        endif
                    endif
                else
                    set remove = true
                endif

                if remove then
                    if e != null then
                        call DestroyEffect(e)
                    endif
                    if e3 != null then
                        call DestroyEffect(e3)
                    endif
                    if e4 != null then
                        call DestroyEffect(e4)
                    endif
                    call MouseOff(GetOwningPlayer(c))
                    if e != null then
                        call ColorEffDummy3(e, 0, 255, 255, 255, 0.3)
                    endif
                    if e2 != null then
                        call ColorEffDummy3(e2, 0, 255, 255, 255, 0.3)
                    endif
                    if c != null and GetUnitTypeId(c) != 0 then
                        if NeuvilletteR_IsInvul then
                            call StopSpellUnit(c)
                        else
                            call StopSpellUnit2(c)
                        endif
                        call SetUnitTimeScale(c, 1.0)
                    endif
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    if g2 != null then
                        call DestroyGroup(g2)
                    endif
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set u = null
                    set m_NeuvilletteR[i] = m_NeuvilletteR[MUI_NeuvilletteR]
                    set MUI_NeuvilletteR = MUI_NeuvilletteR - 1
                    call deallocate(this)
                    if MUI_NeuvilletteR == -1 then
                        call NeuvilletteTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            set u = null
        endmethod

        public static method NeuvilletteR_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this
            local integer level

            if NewC == null or GetUnitTypeId(NewC) == 0 or GetWidgetLife(NewC) <= 0.405 then
                return
            endif

            set this = thistype.create()
            set MUI_NeuvilletteR = MUI_NeuvilletteR + 1
            set m_NeuvilletteR[MUI_NeuvilletteR] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.0
            set r2 = NeuvilletteR_DamageInterval
            set check = 0
            set rmax = NeuvilletteR_CastTime
            set aoe = NeuvilletteR_DamageAoe
            set g = CreateGroup()
            set g2 = CreateGroup()
            set a = GAngle2(c, x, y)

            set level = GetUnitAbilityLevel(c, NeuvilletteR_ID)
            if level < 1 then
                set level = 1
            endif

            set dmg = GetHeroInt(c, true) * (NeuvilletteR_DamageIntBase + NeuvilletteR_DamageIntStep * (level - 1))
            set dmg = dmg / 6.0

            if NeuvilletteR_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif

            call SetUnitAnimationByIndex(c, 3)
            call SetUnitTimeScale(c, 0.90)

            set e3 = AddSpecialEffectTarget("war3mapImported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiblue.mdx", c, "hand right")
            set e4 = AddSpecialEffectTarget("war3mapImported\\wos_241.mdx", c, "origin")

            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("nevi sound")) == 1 then
                if GetRandomInt(1, 2) == 1 then
                    call MakeSound("war3mapImported\\Hero_Neuvillette2_R")
                else
                    call MakeSound("war3mapImported\\Hero_Neuvillette2_R2")
                endif
            else
                call MakeSound("war3mapimported\\Hero_Neuvillette_R")
            endif

            if MUI_NeuvilletteR == 0 then
                call NeuvilletteTimer03Acquire()
            endif
        endmethod
    endstruct

    //===========================================================================
    // T Ability Struct (Pillar Deluge)
    //===========================================================================
    private struct NeuvilletteSpells_T
        private static integer array m_NeuvilletteT
        private static integer MUI_NeuvilletteT = -1

        unit c
        real x
        real y
        real x1
        real y1
        real r2
        real r5
        group g
        real dmg
        real aoe
        real r
        real rmax
        integer pillarsSpawned
        effect e
        effect e2
        effect e3

        public static method Loop_NeuvilletteT takes nothing returns nothing
            local integer i = 0
            local thistype this
            local integer k
            local real rr1
            local real rr2
            local unit u
            local boolean remove

            loop
                exitwhen i > MUI_NeuvilletteT
                set this = m_NeuvilletteT[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or GetWidgetLife(c) <= 0.405 then
                    set remove = true
                elseif SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if NeuvilletteT_IsInvul then
                        call DebugUnit(c)
                    else
                        call DebugUnit2(c)
                    endif

                    set r5 = r5 + 0.6 * bj_DEGTORAD
                    call BlzSetSpecialEffectYaw(e2, r5)

                    if r == 0.90 and LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("nevi sound")) == 0 then
                        call MakeSound("war3mapimported\\Hero_Neuvillette_T2")
                    endif

                    // Автоматизированный спавн столбов строго по лимиту NeuvilletteT_PillarsCount
                    if r > 0.40 and pillarsSpawned < NeuvilletteT_PillarsCount then
                        if r2 >= 0.15 then
                            set r2 = 0.0
                            set k = 0
                            loop
                                exitwhen k == 2 or pillarsSpawned >= NeuvilletteT_PillarsCount
                                set rr1 = GetRandomReal(350.0, aoe - (NeuvilletteT_DamageAoePillar / 2.0))
                                set rr2 = GetRandomReal(0.0, 359.0) * bj_DEGTORAD
                                set x1 = x + rr1 * Cos(rr2)
                                set y1 = y + rr1 * Sin(rr2)

                                call DecorRemove(c, x1, y1, NeuvilletteT_DamageAoePillar, NeuvilletteT_DecorDamage)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_tidalerruption.mdl", x1, y1, 1, 2, 3.5, 1))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_shockwave_b.mdl", x1, y1, 11, 1, 3, 475))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_obr08 (214).mdl", x1, y1, GetRandomReal(0, 359), 1, 1.5, 1))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_1hongse_2blue.mdl", x1, y1, GetRandomReal(0, 359), 0.6, 4, 0))

                                call GroupClear(g)
                                call GroupEnumUnitsInRange(g, x1, y1, NeuvilletteT_DamageAoePillar, Condition(function NoDecor_Filter))
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    call GroupRemoveUnit(g, u)
                                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                        call ErzaPassive(c, u, 2)
                                        call SlowUnit(c, u, NeuvilletteT_Slow, NeuvilletteT_Duration)
                                        call dmgmag(c, u, dmg)
                                    endif
                                endloop

                                set pillarsSpawned = pillarsSpawned + 1
                                set k = k + 1
                            endloop
                        else
                            set r2 = RoundReal(r2 + 0.03, 3)
                        endif
                    endif

                    if r >= rmax then
                        set remove = true
                    endif
                else
                    set remove = true
                endif

                if remove then
                    if e != null then
                        call ColorEffDummy3(e, 0, 255, 255, 255, 0.3)
                    endif
                    if e2 != null then
                        call ColorEffDummy3(e2, 0, 255, 255, 255, 0.3)
                    endif
                    if e3 != null then
                        call DestroyEffect(e3)
                    endif
                    if c != null and GetUnitTypeId(c) != 0 then
                        call ReduceCooldown(c, NeuvilletteR_ID, NeuvilletteT_ReduceRCd_Sec)
                        if NeuvilletteT_IsInvul then
                            call StopSpellUnit(c)
                        else
                            call StopSpellUnit2(c)
                        endif
                        call SetUnitTimeScale(c, 1.0)
                    endif
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    set c = null
                    set g = null
                    set u = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set m_NeuvilletteT[i] = m_NeuvilletteT[MUI_NeuvilletteT]
                    set MUI_NeuvilletteT = MUI_NeuvilletteT - 1
                    call deallocate(this)
                    if MUI_NeuvilletteT == -1 then
                        call NeuvilletteTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            set u = null
        endmethod

        public static method NeuvilletteT_Start takes unit NewC returns nothing
            local thistype this
            local real a
            local integer waves

            if NewC == null or GetUnitTypeId(NewC) == 0 or GetWidgetLife(NewC) <= 0.405 then
                return
            endif

            set this = thistype.create()
            set MUI_NeuvilletteT = MUI_NeuvilletteT + 1
            set m_NeuvilletteT[MUI_NeuvilletteT] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0.0
            set r2 = 0.15
            set r5 = 0.0
            set pillarsSpawned = 0

            // Автоматический расчет длительности поддержания под количество волн спавна
            set waves = (NeuvilletteT_PillarsCount + 1) / 2
            set rmax = 0.40 + (I2R(waves) * 0.15) + 0.15

            set aoe = NeuvilletteT_DamageAoe
            set dmg = GetHeroInt(c, true) * NeuvilletteT_DamageIntBase
            set g = CreateGroup()
            set a = GAngle2(c, x, y)

            if NeuvilletteT_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif

            call SetUnitAnimationByIndex(c, 0)
            call SetUnitTimeScale(c, 0.50)
            call VisionTimed(GetOwningPlayer(c), x, y, aoe + 800.0, 4.0)

            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("nevi sound")) == 1 then
                call MakeSound("war3mapImported\\Hero_Neuvillette2_T")
            else
                call MakeSound("war3mapimported\\Hero_Neuvillette_T")
            endif
            call MakeSound("war3mapimported\\Hero_Neuvillette_T3")

            set e = EffectSpawn("war3mapImported\\wos_hakkestart.mdl", x, y, a * bj_RADTODEG + 180.0, 1.0, 2.0, 4.0)
            call AnimDummyEff(e, 0.25, 0)
            set e2 = EffectSpawn("war3mapImported\\wos_water_sign.mdl", x, y, r5 * bj_RADTODEG + 180.0, 0.2, 0.6, 1385.0)
            call ScaleEffDummy(e2, 0.3, 0.01, 3.0)
            call ColorEffDummy4(e2, 0, 255, 255, 255, 0.15)
            set e3 = AddSpecialEffectTarget("war3mapImported\\wos_aurapartblue.mdl", c, "origin")

            if MUI_NeuvilletteT == 0 then
                call NeuvilletteTimer03Acquire()
            endif
        endmethod
    endstruct


    //===========================================================================
    // Инициализация триггеров и точек входа
    //===========================================================================
    private function NeuvilletteTimer03Loop takes nothing returns nothing
        call NeuvilletteSpells_Q.Loop_NeuvilletteQ()
        call NeuvilletteSpells_W.Loop_NeuvilletteW()
        call NeuvilletteSpells_E.Loop_NeuvilletteE()
        call NeuvilletteSpells_R.Loop_NeuvilletteR()
        call NeuvilletteSpells_T.Loop_NeuvilletteT()
    endfunction

    private function InitNeuvilletteSpells takes nothing returns nothing
        set NeuvilletteTimer03 = CreateTimer()
        set NeuvilletteTimer03Callback = function NeuvilletteTimer03Loop
    endfunction

    function NeuvilletteQ_Start takes unit c, real x, real y returns nothing
        call NeuvilletteSpells_Q.NeuvilletteQ_Start(c, x, y)
    endfunction

    function NeuvilletteW_Start takes unit c, real x, real y returns nothing
        call NeuvilletteSpells_W.NeuvilletteW_Start(c, x, y)
    endfunction

    function NeuvilletteE_Start takes unit c, real x, real y returns nothing
        call NeuvilletteSpells_E.NeuvilletteE_Start(c, x, y)
    endfunction

    function NeuvilletteR_Start takes unit c, real x, real y returns nothing
        call NeuvilletteSpells_R.NeuvilletteR_Start(c, x, y)
    endfunction

    function NeuvilletteT_Start takes unit c returns nothing
        call NeuvilletteSpells_T.NeuvilletteT_Start(c)
    endfunction
endlibrary