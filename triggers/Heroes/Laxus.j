library LaxusSpells initializer InitLaxusSpells uses GearSystems, NatsuSpells
    globals
        private timer LaxusTimer03
        private code LaxusTimer03Callback
        private integer LaxusTimer03Users = 0

//--------------------------------------Laxus Core--------------------------------------------------------
        integer Laxus_ID = 'H02C'
        boolean LaxusPicked = false
        boolean LaxusFActive = false

//---------------Q ability (Lightning Strike)----------------------------------
        integer LaxusQ_ID = 'A0ES'
        real LaxusQ_DamageStrBase = 1.0
        real LaxusQ_DamageStrStep = 1.0
        real LaxusQ_Damage2StaticBase = 150.0
        real LaxusQ_Damage2StaticStep = 0.0
        real LaxusQ_DamageAoe = 550.0
        real LaxusQ_EffectHeight = 900.0
        real LaxusQ_WaitTime = 0.60
        real LaxusQ_FallTime = 0.39
        real LaxusQ_CasterLightningHeight = 160.0
        real LaxusQ_CasterLightningHeight2 = 100.0
        boolean LaxusQ_IsInvul = false
        real LaxusQ_CastTime = 0.99
        real LaxusQ_DecorDamage = 50.0
        integer LaxusQ_Debuff = 0

//---------------Q2 ability (Raienryuu Roar - Mode G)--------------------------
        integer LaxusQ2_ID = 'A0F1'
        real LaxusGQ_DamageStrBonus = 0.0
        real LaxusGQ2_DamageStrBonus = 1.0
        real LaxusQ2_DamageAoe = 350.0
        real LaxusQ2_DamageAoe2 = 575.0
        real LaxusQ_Range = 1500.0
        real LaxusQ_Range2 = 1800.0
        real LaxusQ_Range3 = 5000.0
        boolean LaxusQ2_IsInvul = false
        real LaxusQ2_CastTime = 0.60
        real LaxusQ2_Duration = 0.90
        real LaxusQ2_DecorDamage = 20.0
        real LaxusQ2_ExplosionDecorDamage = 100.0
        integer LaxusQ2_Debuff = 3

//---------------W ability (Lightning Dragon Jaw)------------------------------
        integer LaxusW_ID = 'A0ET'
        real LaxusW_DamageStrBase = 1.0
        real LaxusW_DamageStrStep = 1.0
        real LaxusW_Damage2StaticBase = 175.0
        real LaxusW_Damage2StaticStep = 0.0
        real LaxusGW_DamageStrBonus = 0.0
        real LaxusGW_DamageStrBonus2 = 1.0
        real LaxusW_PushRange = 200.0
        real LaxusW_PushDuration = 0.39
        real LaxusW_Stun = 0.50
        boolean LaxusW_IsInvul = false
        real LaxusW_CastTime = 0.51
        real LaxusW_MaxDuration = 3.00
        real LaxusW_DecorDamage = 20.0
        integer LaxusW_Debuff = 3

//---------------W2 ability (Roaring Thunder Crush)----------------------------
        integer LaxusW2_ID = 'A0EU'
        real LaxusW2_DamageStrBase = 2.0
        real LaxusW2_DamageStrStep = 0.0
        real LaxusW2_DamageStrBase2 = 2.0
        real LaxusW2_DamageStrStep2 = 0.0
        real LaxusW2_Damage2StaticBase = 0.0
        real LaxusW2_Damage2StaticStep = 0.0
        real LaxusGW2_DamageStrBonus = 0.0
        real LaxusGW2_DamageStrBonus2 = 1.0
        real LaxusW2_Stun = 0.50
        real LaxusW2_DamageAoe = 500.0
        boolean LaxusW2_IsInvul = false
        real LaxusW2_CastTime = 0.51
        real LaxusW2_SecondExplosionDelay = 1.02
        real LaxusW2_MaxDuration = 3.00
        real LaxusW2_DecorDamage = 50.0
        integer LaxusW2_Debuff = 3
        real LaxusW2_AvailableDuration = 3.00

//---------------E ability (Lightning Breakdown Fist)--------------------------
        integer LaxusE_ID = 'A0EV'
        real LaxusE_DamageStrBase = 2.0
        real LaxusE_DamageStrStep = 1.0
        real LaxusE_Damage2StaticBase = 0.0
        real LaxusE_Damage2StaticStep = 0.0
        real LaxusGE_DamageStrBonus = 0.0
        real LaxusGE_DamageStrBonus2 = 1.0
        real LaxusE_DamageAoe = 700.0
        integer LaxusE_Slow = 60
        integer LaxusE_Duration = 1
        boolean LaxusE_IsInvul = true
        real LaxusE_CastTime = 0.66
        real LaxusE_DurationTotal = 0.81
        real LaxusE_DecorDamage = 50.0
        integer LaxusE_Debuff = 3

//---------------R ability (Red Lightning Dragon Iron Fist)--------------------
        integer LaxusR_ID = 'A0EW'
        real LaxusR_Stun = 1.00
        real LaxusGR_DamageStrBonus = 1.0
        real LaxusGR_DamageStrBonus2 = 1.0
        real LaxusR_DamageBonus = 15.0 // Бонус урона по целям с Electro дебаффом
        real LaxusR_DamageStrBase = 4.0
        real LaxusR_DamageStrStep = 1.0
        real LaxusR_Damage2StaticBase = 0.0
        real LaxusR_Damage2StaticStep = 0.0
        real LaxusR_DamageAoe = 275.0
        real LaxusR_DamageAoe2 = 600.0
        boolean LaxusR_IsInvul = false
        real LaxusR_CastTime = 0.75
        real LaxusR_MaxDuration = 2.40
        real LaxusR_DecorDamage = 50.0
        real LaxusR_ExplosionDecorDamage = 100.0
        integer LaxusR_Debuff = 0

//---------------T ability (Fairy Law)-----------------------------------------
        integer LaxusT_ID = 'A0EX'
        real LaxusT_DamageStrBase = 10.0
        real LaxusT_DamageAoe = 1400.0
        real LaxusT_Silence = 2.00
        boolean LaxusT_IsInvul = true
        real LaxusT_CastTime = 2.10
        real LaxusT_DecorDamage = 100.0
        integer LaxusT_Debuff = 0

//---------------G ability (Lightning Dragon Slayer Mode)----------------------
        integer LaxusG_ID = 'A0EZ'
        real LaxusG_Duration = 15.0
        integer LaxusG_HpBonus35 = 1000
        boolean LaxusG_IsInvul = false
        real LaxusG_CastTime = 0.00
        real LaxusG_DecorDamage = 0.0

//---------------F ability (Lightning Body Counter / Rush)---------------------
        integer LaxusF_ID = 'A0EY'
        real LaxusF_DamageStrBase = 3.0
        real LaxusGF_DamageStrBonus = 0.0
        real LaxusGF_DamageStrBonus2 = 1.0
        real LaxusF_PushRange = 200.0
        real LaxusF_PushDuration = 0.39
        real LaxusF_Stun = 0.50
        real LaxusF_AoeSearch = 1800.0
        real LaxusF_DmgPorog = 1000.0
        boolean LaxusF_IsInvul = true
        real LaxusF_CastTime = 0.45
        real LaxusF_HitDelay = 0.66
        real LaxusF_MaxDuration = 3.00
        real LaxusF_DecorDamage = 20.0
        integer LaxusF_Debuff = 3
    endglobals

    //===========================================================================
    // МОДУЛЬ ORDER TRACKING (БЕГ БЕЗ ОСТАНОВКИ)
    //===========================================================================
    private function OnHeroPointOrder takes nothing returns boolean
        local unit u = GetOrderedUnit()
        local integer ord = GetIssuedOrderId()
        if GetUnitTypeId(u) == Laxus_ID then
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
        if GetUnitTypeId(u) == Laxus_ID then
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
        if GetUnitTypeId(u) == Laxus_ID then
            if ord == 851972 or ord == 851993 then
                call SaveInteger(hs, GetHandleId(u), StringHash("ord_mode"), 0)
            endif
        endif
        set u = null
        return false
    endfunction

    function Laxus_RestoreOrder takes unit c, integer animIndex returns nothing
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
    endfunction

    private struct LaxusOrderInit extends array
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
    // ТАЙМЕРЫ И МЕНЕДЖМЕНТ
    //===========================================================================
    private function LaxusTimer03Acquire takes nothing returns nothing
        set LaxusTimer03Users = LaxusTimer03Users + 1
        if LaxusTimer03Users == 1 then
            call TimerStart(LaxusTimer03, 0.03, true, LaxusTimer03Callback)
        endif
    endfunction

    private function LaxusTimer03Release takes nothing returns nothing
        set LaxusTimer03Users = LaxusTimer03Users - 1
        if LaxusTimer03Users <= 0 then
            set LaxusTimer03Users = 0
            call PauseTimer(LaxusTimer03)
        endif
    endfunction

    //===========================================================================
    // СИСТЕМА ОБРАТНОЙ ЗАМЕНЫ W2 -> W ПРИ ИСТЕЧЕНИИ 3 СЕКУНД
    //===========================================================================
    private struct LaxusW2_Revert
        private static integer array m_instances
        private static integer m_count = -1

        unit c
        real elapsed

        public static method Loop takes nothing returns nothing
            local integer i = 0
            local thistype this
            loop
                exitwhen i > m_count
                set this = m_instances[i]
                set elapsed = elapsed + 0.03
                if elapsed >= LaxusW2_AvailableDuration or c == null or GetWidgetLife(c) <= 0.405 or GetUnitAbilityLevel(c, LaxusW2_ID) == 0 then
                    if c != null and GetUnitAbilityLevel(c, LaxusW2_ID) > 0 then
                        call SwapAbility(c, 3, LaxusW_ID, LaxusW2_ID)
                        call MyFrame(c, 3, "BTNHero_Laxus_W", false, 0)
                    endif
                    set c = null
                    set m_instances[i] = m_instances[m_count]
                    set m_count = m_count - 1
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method Start takes unit hero returns nothing
            local thistype this = thistype.create()
            set m_count = m_count + 1
            set m_instances[m_count] = this
            set c = hero
            set elapsed = 0.0
        endmethod
    endstruct

    //===========================================================================
    // СТРУКТУРЫ СПОСОБНОСТЕЙ
    //===========================================================================
    private struct LaxusQ_KS
        private static integer array m_LaxusQ
        private static integer MUI_LaxusQ = -1
        private static integer array m_LaxusQ2
        private static integer MUI_LaxusQ2 = -1

        unit c
        unit u
        group g
        group g2
        effect e
        effect e2
        effect e3
        effect e4
        real r2
        real r3
        real r4
        real r7
        lightning l
        real move
        real rmax
        real a
        real x
        integer check2
        real y
        real r
        real fallTime
        real scale
        integer check
        real startZ
        real effectZ
        real dmg
        real aoe

        public static method Loop_LaxusQ2 takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_LaxusQ2
                set this = m_LaxusQ2[i]

                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)

                    if check == 0 then
                        if r == LaxusQ2_CastTime then
                            call SetUnitTimeScale(c, 1.0)
                            set move = 180.0
                            if e != null then
                                call DestroyEffect(e)
                                set e = null
                            endif
                            set x = GetUnitX(c) + 10.0 * Cos(a)
                            set y = GetUnitY(c) + 10.0 * Sin(a)
                            if check2 == 0 then
                                set l = AddLightningEx("LX01", false, GetUnitX(c) + 10.0 * Cos(a), GetUnitY(c) + 10.0 * Sin(a), GetUnitFlyHeight(c) + LaxusQ_CasterLightningHeight2, x, y, GetUnitFlyHeight(c) + LaxusQ_CasterLightningHeight2)
                            else
                                set l = AddLightningEx("LX02", false, GetUnitX(c) + 10.0 * Cos(a), GetUnitY(c) + 10.0 * Sin(a), GetUnitFlyHeight(c) + LaxusQ_CasterLightningHeight2, x, y, GetUnitFlyHeight(c) + LaxusQ_CasterLightningHeight2)
                            endif
                            call NextSound("war3mapimported\\Hero_Laxus_Q4", 0.15)
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2.0, 1.25, 1.0, 255, 255, 255, 225))
                        endif

                        if r > 0.03 then
                            if r > LaxusQ2_CastTime then
                                if r4 > 0.00 then
                                    set r4 = 0.0
                                    set move = move + 5.0
                                    if check2 == 0 then
                                        call MyRemoveEff(EffectSpawn4("war3mapImported\\wos_krk (1849)2.mdx", x, y, a * bj_RADTODEG, 1.0, 1.25, 145.0, -90.0), 0.5)
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_bx_leidiandaji.mdx", x, y, GetRandomReal(0.0, 359.0), 1.5, 2.0, 1.0))
                                    else
                                        call MyRemoveEff(EffectSpawn4("war3mapImported\\wos_krk (1849)4.mdx", x, y, a * bj_RADTODEG, 1.0, 1.25, 145.0, -90.0), 0.5)
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_bx_leidiandaji_red.mdx", x, y, GetRandomReal(0.0, 359.0), 1.5, 2.0, 1.0))
                                    endif
                                else
                                    set r4 = r4 + 0.03
                                endif
                            else
                                if r4 > 0.03 then
                                    set r4 = 0.0
                                    if GetRandomInt(1, 2) == 1 then
                                        if check2 == 0 then
                                            call MyRemoveEff(EffectSpawn4("war3mapImported\\wos_krk (1849)2.mdx", x, y, a * bj_RADTODEG + 90.0, 1.0, 1.0, 145.0, -90.0), 0.15)
                                        else
                                            call MyRemoveEff(EffectSpawn4("war3mapImported\\wos_krk (1849)4.mdx", x, y, a * bj_RADTODEG + 90.0, 1.0, 1.0, 145.0, -90.0), 0.15)
                                        endif
                                    else
                                        if check2 == 0 then
                                            call MyRemoveEff(EffectSpawn4("war3mapImported\\wos_krk (1849)2.mdx", x, y, a * bj_RADTODEG - 90.0, 1.0, 1.0, 145.0, -90.0), 0.15)
                                        else
                                            call MyRemoveEff(EffectSpawn4("war3mapImported\\wos_krk (1849)4.mdx", x, y, a * bj_RADTODEG - 90.0, 1.0, 1.0, 145.0, -90.0), 0.15)
                                        endif
                                    endif
                                else
                                    set r4 = r4 + 0.03
                                endif
                            endif
                        endif

                        if r < LaxusQ2_CastTime then
                            if LaxusQ2_IsInvul then
                                call DebugUnit(c)
                            else
                                call DebugUnit2(c)
                            endif
                        endif

                        if r >= LaxusQ2_CastTime then
                            if PathableCheck(x + move * Cos(a), y + move * Sin(a)) then 
                                set x = x + move * Cos(a)
                                set y = y + move * Sin(a)
                            endif
                            set r7 = r7 + move

                            call MoveLightningEx(l, false, GetUnitX(c) + 10.0 * Cos(a), GetUnitY(c) + 10.0 * Sin(a), GetUnitFlyHeight(c) + LaxusQ_CasterLightningHeight2, x, y, GetUnitFlyHeight(c) + LaxusQ_CasterLightningHeight2)

                            if r3 > 0.03 then
                                set r3 = 0.0
                                call DecorRemove(c, x, y, aoe, LaxusQ2_DecorDamage)
                                call VisionTimed(GetOwningPlayer(c), x, y, aoe * 1.5, 1.5)
                            else
                                set r3 = r3 + 0.03
                            endif

                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                    call GroupAddUnit(g2, u)
                                    if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) == 1 and LaxusQ2_Debuff > 0 then
                                        call ErzaPassive(c, u, LaxusQ2_Debuff)
                                    endif
                                    call dmgmag(c, u, dmg)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null

                            if r7 >= LaxusQ_Range2 then
                                set scale = LaxusQ2_DamageAoe2 / 675.0
                                call VisionTimed(GetOwningPlayer(c), x, y, LaxusQ2_DamageAoe2 * 1.35, 1.5)
                                call MakeSound("war3mapimported\\Hero_Laxus_Q2")
                                if check2 == 0 then
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (513)yellow.mdl", x, y, GetRandomReal(0.0, 359.0), 1.0, 0.85 * scale, 1.0))
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_5731-sl_8bc718f-F2.mdl", x, y, GetRandomReal(0.0, 359.0), 1.0, 1.0 * scale, 1.0))
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_HakkeStartWhite.mdx", x, y, GetRandomReal(0.0, 359.0), 1.4, 1.4 * scale, 0.0, 255, 255, 125, 255))
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_by_wood_bashenan_juqi_2_2_yellow.mdx", x, y, GetRandomReal(0.0, 359.0), 1.4, 5.0 * scale, 160.0, 255, 255, 125, 255))
                                    call DestroyEffect(EffectSpawnScale("war3mapImported\\wos_by_wood_effect_order_dange_yueyun_3yellowlightclear.mdl", x, y, GetRandomReal(0.0, 359.0), 0.65, 1.0, 1.0, 0.3, 0.01, 1.55 * scale))
                                else
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (513)red.mdl", x, y, GetRandomReal(0.0, 359.0), 1.0, 0.85 * scale, 1.0))
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_5731-sl_8bc718f-F2_red.mdl", x, y, GetRandomReal(0.0, 359.0), 1.0, 1.0 * scale, 1.0))
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_HakkeStartWhite.mdx", x, y, GetRandomReal(0.0, 359.0), 1.4, 1.4 * scale, 0.0, 255, 25, 25, 255))
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_by_wood_bashenan_juqi_2_2_yellow.mdx", x, y, GetRandomReal(0.0, 359.0), 1.4, 5.0 * scale, 160.0, 255, 25, 25, 255))
                                    call DestroyEffect(EffectSpawnScale("war3mapImported\\wos_by_wood_effect_order_dange_yueyun_3red.mdl", x, y, GetRandomReal(0.0, 359.0), 0.65, 1.0, 1.0, 0.3, 0.01, 1.55 * scale))
                                endif
                                call DecorRemove(c, x, y, LaxusQ2_DamageAoe2, LaxusQ2_ExplosionDecorDamage)

                                call GroupClear(g)
                                call GroupEnumUnitsInRange(g, x, y, LaxusQ2_DamageAoe2, Condition(function NoDecor_Filter))
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                        call GroupAddUnit(g2, u)
                                        call dmgmag(c, u, dmg)
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                                set u = null

                                set check = 1
                                set r2 = 10.0
                                set r = 0.0
                            endif
                        endif
                    elseif check == 1 then
                        if LaxusQ2_IsInvul then
                            call DebugUnit(c)
                        else
                            call DebugUnit2(c)
                        endif
                        set r2 = r2 + 180.0
                        if r2 > r7 + 10.0 then
                            set r2 = r7 + 10.0
                        endif

                        call MoveLightningEx(l, false, GetUnitX(c) + r2 * Cos(a), GetUnitY(c) + r2 * Sin(a), GetUnitFlyHeight(c) + LaxusQ_CasterLightningHeight2, x, y, GetUnitFlyHeight(c) + LaxusQ_CasterLightningHeight2)

                        if r2 >= r7 + 10.0 then
                            set r = 999999.0
                        endif
                    endif
                else
                    call SetUnitAnimation(c, "stand")
                    call SetUnitTimeScale(c, 1.0)
                    if LaxusQ2_IsInvul then
                        call StopSpellUnit(c)
                    else
                        call StopSpellUnit2(c)
                    endif
                    if e != null then
                        call DestroyEffect(e)
                    endif
                    if l != null then
                        call DestroyLightning(l)
                    endif
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    if g2 != null then
                        call DestroyGroup(g2)
                    endif
                    set g = null
                    set g2 = null
                    set l = null
                    set e = null
                    set c = null
                    set u = null
                    set m_LaxusQ2[i] = m_LaxusQ2[MUI_LaxusQ2]
                    set MUI_LaxusQ2 = MUI_LaxusQ2 - 1
                    if MUI_LaxusQ2 == -1 then
                        call LaxusTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif

                set i = i + 1
            endloop
        endmethod

        public static method LaxusQ2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            set MUI_LaxusQ2 = MUI_LaxusQ2 + 1
            set m_LaxusQ2[MUI_LaxusQ2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.0
            set check = 0
            set r2 = 10.0
            set r7 = 0.0
            set r4 = 1.0
            set r3 = 1.0
            if LaxusQ2_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            set move = 120.0
            set rmax = LaxusQ2_CastTime + LaxusQ2_Duration

            set a = GAngle2(c, x, y)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set scale = 0.25
            call SetUnitAnimationByIndex(c, 5)
            set u = null
            set x = GetUnitX(c) + 100.0 * Cos(a)
            set y = GetUnitY(c) + 100.0 * Sin(a)
            set aoe = LaxusQ2_DamageAoe
            set dmg = GetHeroStr(c, true) * (LaxusQ_DamageStrBase + (LaxusQ_DamageStrStep * (GetUnitAbilityLevel(c, LaxusQ_ID) - 1)))
            set dmg = dmg + LaxusQ_Damage2StaticBase + (LaxusQ_Damage2StaticStep * (GetUnitAbilityLevel(c, LaxusQ_ID) - 1))
            set check2 = 0
            if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) == 1 then
                set dmg = dmg + GetHeroStr(c, true) * LaxusGQ_DamageStrBonus
                if LoadInteger(hs, GetHandleId(c), StringHash("lvl5")) == 1 then
                    set check2 = 1
                    set dmg = dmg + GetHeroStr(c, true) * LaxusGQ2_DamageStrBonus
                endif
            endif
            call MakeSound("war3mapimported\\Hero_Laxus_Q3")
            if check2 == 1 then
                set e = EffectSpawn("war3mapImported\\wos_Lighting collection_red.mdl", GetUnitX(c) + 150.0 * Cos(a), GetUnitY(c) + 150.0 * Sin(a), a * bj_RADTODEG, 1.0, 2.0, 120.0)
            else
                set e = EffectSpawn("war3mapImported\\wos_Lighting collection.mdl", GetUnitX(c) + 150.0 * Cos(a), GetUnitY(c) + 150.0 * Sin(a), a * bj_RADTODEG, 1.0, 2.0, 120.0)
            endif
            call SetUnitTimeScale(c, 0.55)
            call SetUnitFacing(c, a * bj_RADTODEG)
            set r7 = 0.0
            if MUI_LaxusQ2 == 0 then
                call LaxusTimer03Acquire()
            endif
        endmethod

        public static method Loop_LaxusQ takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real progress
            loop
                exitwhen i > MUI_LaxusQ
                set this = m_LaxusQ[i]

                if SpellBoolCaster(c) then
                    set r = RoundReal(r + 0.03, 3)

                    if LaxusQ_IsInvul then
                        call DebugUnit(c)
                    else
                        call DebugUnit2(c)
                    endif

                    if check == 0 and r >= LaxusQ_WaitTime then
                        set check = 1
                        call NextSound("war3mapimported\\Hero_Laxus_Q1", 0.30)
                        call SetUnitAnimationByIndex(c, 11)
                        call SetUnitTimeScale(c, 1.25)
                    endif

                    if r >= LaxusQ_WaitTime then
                        set fallTime = r - LaxusQ_WaitTime
                        set progress = fallTime / LaxusQ_FallTime

                        if progress > 1.0 then
                            set progress = 1.0
                        endif

                        set effectZ = startZ * (1.0 - progress)
                        call BlzSetSpecialEffectPosition(e, x, y, effectZ)
                    endif

                    set r2 = r2 + 1.65
                    call MoveLightningEx(l, false, GetUnitX(c) + r2 * Cos(a), GetUnitY(c) + r2 * Sin(a), GetUnitFlyHeight(c) + LaxusQ_CasterLightningHeight - (120.0 * progress), x, y, effectZ + 200.0)
                endif

                if not SpellBoolCaster(c) or fallTime >= LaxusQ_FallTime then
                    if SpellBoolCaster(c) and fallTime >= LaxusQ_FallTime then
                        call MakeSound("war3mapimported\\Hero_Laxus_Q2")
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (513)yellow.mdl", x, y, GetRandomReal(0.0, 359.0), 1.0, 0.65, 1.0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_[DoFT]EF501Item.mdl", x, y, GetRandomReal(0.0, 359.0), 1.0, 4.0, 1.0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_File00229.mdl", x, y, GetRandomReal(0.0, 359.0), 0.50, 8.0, 1.0))
                        call DecorRemove(c, x, y, aoe, LaxusQ_DecorDamage)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))

                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                if LaxusQ_Debuff > 0 then
                                    call ErzaPassive(c, u, LaxusQ_Debuff)
                                endif
                                call dmgmag(c, u, dmg)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                        call ColorEffDummy3(EffectSpawnColor("war3mapimported\\wos_almagest1.mdl", x, y, 1.0, 2.0, 3.0 * scale, 155.0, 75, 225, 255, 0), 0.30, 255, 225, 95, 0.30)
                    endif

                    if LaxusQ_IsInvul then
                        call StopSpellUnit(c)
                    else
                        call StopSpellUnit2(c)
                    endif
                    call SetUnitAnimation(c, "stand")
                    call SetUnitTimeScale(c, 1.0)
                    if l != null then
                        call DestroyLightning(l)
                    endif
                    if e != null then
                        call BlzSetSpecialEffectTimeScale(e, 0.75)
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
                    if g != null then
                        call DestroyGroup(g)
                    endif

                    set l = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set g = null
                    set c = null
                    set u = null

                    set m_LaxusQ[i] = m_LaxusQ[MUI_LaxusQ]
                    set MUI_LaxusQ = MUI_LaxusQ - 1

                    if MUI_LaxusQ == -1 then
                        call LaxusTimer03Release()
                    endif

                    call deallocate(this)
                    set i = i - 1
                endif

                set i = i + 1
            endloop
        endmethod

        public static method LaxusQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            local integer level = GetUnitAbilityLevel(NewC, LaxusQ_ID)
            set MUI_LaxusQ = MUI_LaxusQ + 1
            set m_LaxusQ[MUI_LaxusQ] = this
            set c = NewC
            set u = null
            set x = NewX
            set y = NewY
            set r = 0.0
            set check = 0
            set fallTime = 0.0
            set startZ = LaxusQ_EffectHeight
            set effectZ = startZ
            set aoe = LaxusQ_DamageAoe
            set scale = aoe / 575.0
            set g = CreateGroup()
            set a = GAngle2(c, x, y)
            set dmg = GetHeroStr(c, true) * (LaxusQ_DamageStrBase + LaxusQ_DamageStrStep * (level - 1))
            set dmg = dmg + LaxusQ_Damage2StaticBase + LaxusQ_Damage2StaticStep * (level - 1)
            set check2 = 0
            if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) == 1 then
                set dmg = dmg + GetHeroStr(c, true) * LaxusGQ_DamageStrBonus
                if LoadInteger(hs, GetHandleId(c), StringHash("lvl5")) == 1 then
                    set check2 = 1
                    set dmg = dmg + GetHeroStr(c, true) * LaxusGQ2_DamageStrBonus
                endif
            endif
            call MakeSound("war3mapimported\\Hero_Laxus_Q")
            if LaxusQ_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            call SetUnitFacing(c, GAngle2(c, x, y) * bj_RADTODEG)
            call SetUnitAnimationByIndex(c, 10)
            set r2 = 10.0
            set e = AddSpecialEffect("war3mapImported\\wos_YellowMissile2.mdl", x, y)
            call BlzSetSpecialEffectPosition(e, x, y, effectZ)
            call ScaleEffDummy(e, 0.30, 0.01, 1.0 * scale)
            set e2 = EffectSpawn("war3mapImported\\wos_kss (498).mdx", x, y, 0.0, 1.0, 1.0, 1.0)
            call ScaleEffDummy(e2, 0.30, 0.01, 1.10 * scale)
            set l = AddLightningEx("LX00", false, GetUnitX(c) + r2 * Cos(a), GetUnitY(c) + r2 * Sin(a), GetUnitFlyHeight(c) + LaxusQ_CasterLightningHeight, x, y, effectZ + 100.0)
            set e3 = AddSpecialEffectTarget("war3mapImported\\wos_YellowMissile.mdl", c, "hand right")
            set e4 = AddSpecialEffectTarget("war3mapImported\\wos_YellowMissile.mdl", c, "hand left")
            if MUI_LaxusQ == 0 then
                call LaxusTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct LaxusW_KS
        private static integer array m_LaxusW
        private static integer MUI_LaxusW = -1
        private static integer array m_LaxusW2
        private static integer MUI_LaxusW2 = -1
        unit c
        unit td
        real x
        real y
        real dmg
        real dmg2
        real move
        real r
        integer check
        real aoe
        group g
        unit u
        effect e
        integer check2
        effect e2
        effect e3
        real a
        real rmax

        public static method Loop_LaxusW2 takes nothing returns nothing
            local thistype this
            local integer k = 0
            local integer i = 0
            loop
                exitwhen i > MUI_LaxusW2
                set this = m_LaxusW2[i]
                if SpellBoolCaster(c) and r <= rmax and SpellBoolCaster(td) then
                    set r = RoundReal(r + 0.03, 3)
                    set a = GAngle(c, td)
                    call SetUnitFacing(c, a * bj_RADTODEG)
                    if r == 0.30 then
                        call SetUnitAnimationByIndex(c, 11)
                    endif
                    if r == LaxusW2_CastTime then
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        call MakeSound("war3mapimported\\Hero_Laxus_W2 2")
                        if check2 == 0 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_YellowBoom.mdx", x, y, 1.0, 1.25, 4.0, 110.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_SlamYellow.mdl", x, y, 1.0, 1.0, 4.0, 1.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_YellowMissile.mdl", x, y, 1.0, 1.0, 4.0, 100.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_bx_leidiandaji.mdl", x, y, 1.0, 1.0, 2.0, 1.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_YellowThunderAura.mdl", x, y, 1.0, 1.25, 9.0, 100.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Lightning Slam.mdl", x, y, 1.0, 2.0, 4.5, 1.0))
                        else
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_RedBoom.mdx", x, y, 1.0, 1.25, 4.0, 110.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_SlamRed.mdl", x, y, 1.0, 1.0, 4.0, 1.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_RedMissile.mdl", x, y, 1.0, 1.0, 4.0, 100.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_bx_leidiandaji_red.mdl", x, y, 1.0, 1.0, 2.0, 1.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_RedThunderAura.mdl", x, y, 1.0, 1.25, 9.0, 100.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Lightning SlamRed.mdl", x, y, 1.0, 2.0, 4.5, 1.0))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_opdef (425).mdl", x, y, GetRandomReal(0.0, 359.0), 1.85, 0.50, 0.0))
                        endif
                        call SetUnitAnimation(td, "death")
                        set k = 0
                        loop
                            exitwhen k > 3
                            call EffectSpawn2("war3mapimported\\wos_LD2209 (157).mdx", x, y, GetRandomReal(0.0, 359.0), 1.0 - k * 0.20, 1.0 + k * 0.50, 0.0, 1.25)
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_dustgaraa2.mdx", x, y, GetRandomReal(0.0, 359.0), 1.50 - k * 0.10, 1.90 + k * 0.42, 0.0))
                            set k = k + 1
                        endloop
                        call DecorRemove(c, x, y, aoe, LaxusW2_DecorDamage)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))

                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) == 1 and LaxusW2_Debuff > 0 then
                                    call ErzaPassive(c, u, LaxusW2_Debuff)
                                endif
                                call dmgphys(c, u, dmg)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null

                        if LaxusW2_IsInvul then
                            call StopSpellUnit(c)
                            call StopSpellUnit(td)
                        else
                            call StopSpellUnit2(c)
                            call StopSpellUnit2(td)
                        endif
                    endif

                    if r == 0.54 then
                        if check2 == 0 then
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_file00007439_yel.mdl", x, y, 1.0, 1.0, 3.0, 0.0), 0.0, 255, 255, 255, 0.90)
                        else
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_file00007439.mdl", x, y, 1.0, 1.0, 3.0, 0.0), 0.0, 255, 255, 255, 0.90)
                        endif
                    endif

                    if r == LaxusW2_SecondExplosionDelay then
                        call DecorRemove(c, x, y, aoe, LaxusW2_DecorDamage)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))

                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) == 1 and LaxusW2_Debuff > 0 then
                                    call ErzaPassive(c, u, LaxusW2_Debuff)
                                endif
                                call dmgmag(c, u, dmg2)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                        set r = 9999.0
                        call MakeSound("war3mapimported\\Hero_Laxus_W2 3")
                        if check2 == 0 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_YellowBoom.mdx", x, y, 1.0, 1.25, 6.0, 110.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_effect_yubanmeiqin_lightning_zhenzhengdeluolei_yellow.mdl", x, y, 1.0, 1.0, 3.0, 1.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_YellowMissile.mdl", x, y, 1.0, 1.0, 8.0, 100.0))
                        else
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_RedBoom.mdx", x, y, 1.0, 1.25, 6.0, 110.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_effect_yubanmeiqin_lightning_zhenzhengdeluolei_red.mdl", x, y, 1.0, 1.0, 3.0, 1.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_RedMissile.mdl", x, y, 1.0, 1.0, 8.0, 100.0))
                        endif
                    endif
                else
                    // Гарантированный сброс обратно на W при завершении или отмене W2
                    if c != null and GetUnitAbilityLevel(c, LaxusW2_ID) > 0 then
                        call SwapAbility(c, 3, LaxusW_ID, LaxusW2_ID)
                        call MyFrame(c, 3, "BTNHero_Laxus_W", false, 0)
                    endif
                    if e != null then
                        call DestroyEffect(e)
                    endif
                    if e2 != null then
                        call DestroyEffect(e2)
                    endif
                    if e3 != null then
                        call DestroyEffect(e3)
                    endif
                    call SetUnitTimeScale(c, 1.0)
                    if r < 0.60 then
                        if LaxusW2_IsInvul then
                            call StopSpellUnit(c)
                            call StopSpellUnit(td)
                        else
                            call StopSpellUnit2(c)
                            call StopSpellUnit2(td)
                        endif
                    endif
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    set c = null
                    set td = null
                    set e = null
                    set g = null
                    set u = null
                    set e2 = null
                    set e3 = null
                    set m_LaxusW2[i] = m_LaxusW2[MUI_LaxusW2]
                    set MUI_LaxusW2 = MUI_LaxusW2 - 1
                    if MUI_LaxusW2 == -1 then
                        call LaxusTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method LaxusW2_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create()
            set MUI_LaxusW2 = MUI_LaxusW2 + 1
            set m_LaxusW2[MUI_LaxusW2] = this
            set c = NewC
            set td = NewTd
            set r = 0.0
            set g = CreateGroup()
            set rmax = LaxusW2_MaxDuration
            set u = null
            if LaxusW2_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            call SetUnitAnimationByIndex(c, 10)
            call SetUnitTimeScale(c, 1.10)
            set aoe = LaxusW2_DamageAoe
            call MakeSound("war3mapimported\\Hero_Laxus_W2 1")
            set dmg = GetHeroStr(c, true) * (LaxusW2_DamageStrBase + (LaxusW2_DamageStrStep * (GetUnitAbilityLevel(c, LaxusW2_ID) - 1)))
            set dmg2 = GetHeroStr(c, true) * (LaxusW2_DamageStrBase2 + (LaxusW2_DamageStrStep2 * (GetUnitAbilityLevel(c, LaxusW2_ID) - 1)))
            set a = GAngle(c, td)
            call PosUnit(c, GetUnitX(td) - 150.0 * Cos(a), GetUnitY(td) - 150.0 * Sin(a))
            set check2 = 0
            if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) == 1 then
                set dmg = dmg + GetHeroStr(c, true) * LaxusGW2_DamageStrBonus
                set dmg2 = dmg2 + GetHeroStr(c, true) * LaxusGW2_DamageStrBonus
                if LoadInteger(hs, GetHandleId(c), StringHash("lvl5")) == 1 then
                    set check2 = 1
                    set dmg = dmg + GetHeroStr(c, true) * LaxusGW2_DamageStrBonus2
                    set dmg2 = dmg2 + GetHeroStr(c, true) * LaxusGW2_DamageStrBonus2
                endif
            endif
            if check2 == 1 then
                set e = AddSpecialEffectTarget("war3mapImported\\wos_RedMissile.mdl", c, "hand left")
                set e2 = AddSpecialEffectTarget("war3mapImported\\wos_RedMissile.mdl", c, "hand left")
            else
                set e = AddSpecialEffectTarget("war3mapImported\\wos_YellowMissile.mdl", c, "hand left")
                set e2 = AddSpecialEffectTarget("war3mapImported\\wos_YellowMissile.mdl", c, "hand left")
            endif
            if MUI_LaxusW2 == 0 then
                call LaxusTimer03Acquire()
            endif
        endmethod

        public static method Loop_LaxusW takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_LaxusW
                set this = m_LaxusW[i]
                if SpellBoolCaster(c) and r <= rmax and SpellBoolCaster(td) then
                    set r = RoundReal(r + 0.03, 3)
                    set a = GAngle(c, td)
                    call SetUnitFacing(c, a * bj_RADTODEG)
                    if r == LaxusW_CastTime then
                        if check == 1 then
                            call NextSound("war3mapimported\\Hero_Laxus_W2", 0.30)
                        elseif check == 3 then
                            call NextSound("war3mapimported\\Hero_Laxus_W5", 0.30)
                        endif
                    endif
                    if r > LaxusW_CastTime then
                        if SR2(c, td) > 100.0 then
                            call MoveUnit(c, move, a)
                        else
                            call dmgphys(c, td, dmg)
                            call StunUnit(c, td, LaxusW_Stun)
                            if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) == 1 and LaxusW_Debuff > 0 then
                                call ErzaPassive(c, td, LaxusW_Debuff)
                            endif
                            call MUE(td, LaxusW_PushRange, LaxusW_PushDuration, a)
                            call MakeSound("war3mapimported\\Hero_Laxus_W")
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            call DecorRemove(c, x, y, 350.0, LaxusW_DecorDamage)

                            // Разблокировка W2 при 5 уровне способности с таймером автовозврата на 3 секунды
                            if GetUnitAbilityLevel(c, LaxusW_ID) >= 5 then
                                call SwapAbility(c, 3, LaxusW2_ID, LaxusW_ID)
                                call MyFrame(c, 3, "BTNHero_Laxus_W2", false, 0)
                                call LaxusW2_Revert.Start(c)
                            endif

                            set r = 99999.0
                            set x = GetUnitX(td) + 130.0 * Cos(a)
                            set y = GetUnitY(td) + 130.0 * Sin(a)
                            if check2 == 0 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_YellowBoom.mdx", x, y, 1.0, 1.25, 2.5, 110.0))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_SlamYellow.mdl", x, y, 1.0, 1.0, 4.0, 1.0))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_YellowMissile.mdl", x, y, 1.0, 1.0, 4.0, 100.0))
                            else
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)3small.mdl", x, y, GetRandomReal(0.0, 359.0), 1.0, 3.0, 145.0))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZarakiWCrack2.mdx", x, y, GetRandomReal(0.0, 359.0), 1.0, 3.0, 0.0))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Eff_Ord_DanGe_Wav_Kuosan_1_3_0.5s.mdx", x, y, 1.0, 1.0, 1.0, 100.0))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlashred.mdl", x + 25.0 * Cos(a), y + 25.0 * Sin(a), 1.0, 1.25, 2.5, 255.0))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_RedBoom.mdx", x, y, 1.0, 1.25, 2.5, 110.0))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_SlamRed.mdl", x, y, 1.0, 1.0, 4.0, 1.0))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_RedMissile.mdl", x, y, 1.0, 1.0, 4.0, 100.0))
                            endif
                        endif
                    endif
                else
                    if e != null then
                        call DestroyEffect(e)
                    endif
                    if e2 != null then
                        call DestroyEffect(e2)
                    endif
                    if e3 != null then
                        call DestroyEffect(e3)
                    endif
                    if LaxusW_IsInvul then
                        call StopSpellUnit(c)
                    else
                        call StopSpellUnit2(c)
                    endif
                    call SetUnitTimeScale(c, 1.0)
                    set c = null
                    set td = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set m_LaxusW[i] = m_LaxusW[MUI_LaxusW]
                    set MUI_LaxusW = MUI_LaxusW - 1
                    if MUI_LaxusW == -1 then
                        call LaxusTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method LaxusW_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create()
            local integer k = 0
            set MUI_LaxusW = MUI_LaxusW + 1
            set m_LaxusW[MUI_LaxusW] = this
            set c = NewC
            set td = NewTd
            set r = 0.0
            set move = 80.0
            set rmax = LaxusW_MaxDuration
            if LaxusW_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            call SetUnitAnimationByIndex(c, 11)
            call SetUnitTimeScale(c, 1.10)
            set k = GetRandomInt(1, 3)
            if k == 1 then
                call MakeSound("war3mapimported\\Hero_Laxus_W1")
                set check = 1
            elseif k == 2 then
                set check = 2
                call MakeSound("war3mapimported\\Hero_Laxus_W3")
            else
                set check = 3
                call MakeSound("war3mapimported\\Hero_Laxus_W4")
            endif
            set dmg = GetHeroStr(c, true) * (LaxusW_DamageStrBase + (LaxusW_DamageStrStep * (GetUnitAbilityLevel(c, LaxusW_ID) - 1)))
            set dmg = dmg + LaxusW_Damage2StaticBase + (LaxusW_Damage2StaticStep * (GetUnitAbilityLevel(c, LaxusW_ID) - 1))
            set check2 = 0
            if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) == 1 then
                set dmg = dmg + GetHeroStr(c, true) * LaxusGW_DamageStrBonus
                if LoadInteger(hs, GetHandleId(c), StringHash("lvl5")) == 1 then
                    set dmg = dmg + GetHeroStr(c, true) * LaxusGW_DamageStrBonus2
                    set check2 = 1
                endif
            endif
            if check2 == 1 then
                set e = AddSpecialEffectTarget("war3mapImported\\wos_RedMissile.mdl", c, "hand left")
                set e2 = AddSpecialEffectTarget("war3mapImported\\wos_RedMissile.mdl", c, "hand left")
                set e3 = AddSpecialEffectTarget("war3mapImported\\wos_eff (24).mdl", c, "hand left")
            else
                set e = AddSpecialEffectTarget("war3mapImported\\wos_YellowMissile.mdl", c, "hand left")
                set e2 = AddSpecialEffectTarget("war3mapImported\\wos_File00229.mdl", c, "hand left")
                set e3 = AddSpecialEffectTarget("war3mapImported\\wos_eff (24).mdl", c, "hand left")
            endif
            if MUI_LaxusW == 0 then
                call LaxusTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct LaxusE_KS
        private static integer array m_LaxusE
        private static integer MUI_LaxusE = -1
        unit c
        real x
        real y
        integer k
        group g
        unit u
        real dmg
        integer check2
        real aoe
        real r
        effect e4
        effect e3
        real a
        real rmax

        public static method Loop_LaxusE takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real rr1 = 0.0
            local real rr2 = 0.0
            local real x1 = 0.0
            local real y1 = 0.0
            loop
                exitwhen i > MUI_LaxusE
                set this = m_LaxusE[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if LaxusE_IsInvul then
                        call DebugUnit(c)
                    else
                        call DebugUnit2(c)
                    endif
                    if r == 0.45 then
                        set x = GetUnitX(c) + 150.0 * Cos(a)
                        set y = GetUnitY(c) + 150.0 * Sin(a)
                        call MakeSound("war3mapimported\\Hero_Laxus_E3")
                        if check2 == 0 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_SlamYellow.mdl", x, y, 1.0, 1.0, 4.0, 1.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_modelgh (1).mdl", x, y, 0.0, 3.0, 2.0, 100.0))
                        else
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_SlamRed.mdl", x, y, 1.0, 1.0, 4.0, 1.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_modelgh (1)red.mdl", x, y, 0.0, 3.0, 2.0, 100.0))
                        endif
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_bbb.mdl", x, y, GetRandomReal(0.0, 359.0), 1.25, 1.95, 155.0))
                    endif
                    if r > 0.51 then
                        set k = 0
                        loop
                            exitwhen k == 5
                            set rr1 = GetRandomReal(595.0, 820.0)
                            set rr2 = GetRandomReal(0.0, 360.0) * bj_DEGTORAD
                            set x1 = x + rr1 * Cos(rr2)
                            set y1 = y + rr1 * Sin(rr2)
                            if check2 == 0 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_opbr0326 (109)yel.mdl", x1, y1, GetRandomReal(0.0, 359.0), 1.0, 1.0, 1.0))
                            else
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_opbr0326 (109).mdl", x1, y1, GetRandomReal(0.0, 359.0), 1.0, 1.0, 1.0))
                            endif
                            set k = k + 1
                        endloop
                    endif
                    if r == LaxusE_CastTime then
                        set r = 9999.0
                        call MakeSound("war3mapimported\\Hero_Laxus_W2 3")
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_NewDirtEXNofireNoDust.mdl", x, y, GetRandomReal(0.0, 359.0), 1.0, 3.25, 0.0))

                        if check2 == 0 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_opm (597)yellow.mdx", x, y, GetRandomReal(0.0, 359.0), 1.15, 1.45, 0.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_ljq_jn_lsfgxs02.mdl", x, y, GetRandomReal(0.0, 359.0), 4.0, 0.65, 1.0))
                        else
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_opm (597)red.mdx", x, y, GetRandomReal(0.0, 359.0), 1.15, 1.45, 0.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_ljq_jn_lsfgxs02_red.mdl", x, y, GetRandomReal(0.0, 359.0), 4.0, 0.65, 1.0))
                        endif
                        call DecorRemove(c, x, y, aoe, LaxusE_DecorDamage)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call dmgphys(c, u, dmg)
                                if LaxusE_Debuff > 0 then
                                    call ErzaPassive(c, u, LaxusE_Debuff)
                                endif
                                call SlowUnit(c, u, LaxusE_Slow, LaxusE_Duration)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                    endif
                else
                    if LaxusE_IsInvul then
                        call StopSpellUnit(c)
                    else
                        call StopSpellUnit2(c)
                    endif
                    call SetUnitTimeScale(c, 1.0)
                    if e3 != null then
                        call DestroyEffect(e3)
                    endif
                    if e4 != null then
                        call DestroyEffect(e4)
                    endif
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    set g = null
                    set c = null
                    set e3 = null
                    set e4 = null
                    set u = null
                    set m_LaxusE[i] = m_LaxusE[MUI_LaxusE]
                    set MUI_LaxusE = MUI_LaxusE - 1
                    if MUI_LaxusE == -1 then
                        call LaxusTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method LaxusE_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_LaxusE = MUI_LaxusE + 1
            set m_LaxusE[MUI_LaxusE] = this
            set c = NewC
            set a = GetUnitFacing(c) * bj_DEGTORAD
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            set r = 0.0
            if LaxusE_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            set g = CreateGroup()
            set u = null
            set aoe = LaxusE_DamageAoe
            set dmg = GetHeroStr(c, true) * (LaxusE_DamageStrBase + (LaxusE_DamageStrStep * (GetUnitAbilityLevel(c, LaxusE_ID) - 1)))
            set dmg = dmg + LaxusE_Damage2StaticBase + (LaxusE_Damage2StaticStep * (GetUnitAbilityLevel(c, LaxusE_ID) - 1))
            set rmax = LaxusE_DurationTotal
            call SetUnitAnimationByIndex(c, 11)
            call SetUnitTimeScale(c, 0.85)
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapimported\\Hero_Laxus_E")
            else
                call MakeSound("war3mapimported\\Hero_Laxus_E2")
            endif
            set check2 = 0
            if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) == 1 then
                set dmg = dmg + GetHeroStr(c, true) * LaxusGE_DamageStrBonus
                if LoadInteger(hs, GetHandleId(c), StringHash("lvl5")) == 1 then
                    set check2 = 1
                    set dmg = dmg + GetHeroStr(c, true) * LaxusGE_DamageStrBonus2
                endif
            endif
            if check2 == 1 then
                set e3 = AddSpecialEffectTarget("war3mapImported\\wos_RedMissile.mdl", c, "hand right")
                set e4 = AddSpecialEffectTarget("war3mapImported\\wos_RedMissile.mdl", c, "hand left")
            else
                set e3 = AddSpecialEffectTarget("war3mapImported\\wos_YellowMissile.mdl", c, "hand right")
                set e4 = AddSpecialEffectTarget("war3mapImported\\wos_YellowMissile.mdl", c, "hand left")
            endif
            if MUI_LaxusE == 0 then
                call LaxusTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct LaxusR_KS
        private static integer array m_LaxusR
        private static integer MUI_LaxusR = -1
        unit c
        unit td
        real x
        real y
        real r2
        group g
        group g2
        unit u
        real dmg
        real aoe
        real move
        real r
        effect e
        effect e2
        effect e3
        effect e4
        real a
        integer check2
        real rmax

        public static method Loop_LaxusR takes nothing returns nothing
            local thistype this
            local real x1
            local real y1
            local real rr1
            local real rr2
            local integer k
            local integer i = 0
            loop
                exitwhen i > MUI_LaxusR
                set this = m_LaxusR[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r < LaxusR_CastTime then
                        if LaxusR_IsInvul then
                            call DebugUnit(c)
                        else
                            call DebugUnit2(c)
                        endif
                    endif
                    if r < LaxusR_CastTime then
                        if r2 >= 0.12 then
                            set r2 = 0.0
                            if check2 == 0 then
                                call DestroyEffect(EffectSpawnScale("war3mapImported\\wos_LighWave3.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0.0, 359.0), 1.0, 1.0, 0.0, 0.21, 0.50, 1.0))
                            else
                                call DestroyEffect(EffectSpawnScale("war3mapImported\\wos_LighWave3_red.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0.0, 359.0), 1.0, 1.0, 0.0, 0.21, 0.50, 1.0))
                            endif
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                    if r == 0.12 then
                        if check2 == 0 then
                            set e4 = EffectSpawn("war3mapImported\\wos_krk (1849)2.mdl", GetUnitX(c) + 130.0 * Cos(a), GetUnitY(c) + 130.0 * Sin(a), a * bj_RADTODEG, 1.0, 1.0, 235.0)
                            set e3 = EffectSpawn("war3mapImported\\wos_2695945fc783186d.mdl", GetUnitX(c) - 450.0 * Cos(a), GetUnitY(c) - 450.0 * Sin(a), a * bj_RADTODEG, 2.0, 2.75, 110.0)
                        else
                            set e4 = EffectSpawn("war3mapImported\\wos_krk (1849)4.mdl", GetUnitX(c) + 130.0 * Cos(a), GetUnitY(c) + 130.0 * Sin(a), a * bj_RADTODEG, 1.0, 1.0, 235.0)
                            set e3 = EffectSpawn("war3mapImported\\wos_2695945fc783186d_red.mdl", GetUnitX(c) - 450.0 * Cos(a), GetUnitY(c) - 450.0 * Sin(a), a * bj_RADTODEG, 2.0, 2.75, 110.0)
                        endif
                        call BlzSetSpecialEffectAlpha(e3, 0)
                        call ColorEffDummy4(e3, 0.0, 255, 255, 255, 0.27)
                    endif
                    if r == LaxusR_CastTime then
                        call SetUnitAnimationByIndex(c, 13)
                        call MakeSound("war3mapimported\\Hero_Laxus_R3")
                        if LaxusR_IsInvul then
                            call StopSpellUnit(c)
                        else
                            call StopSpellUnit2(c)
                        endif
                        if e != null then
                            call DestroyEffect(e)
                            set e = null
                        endif
                        if e2 != null then
                            call DestroyEffect(e2)
                            set e2 = null
                        endif
                        set r2 = 10.0
                    endif
                    if r > 0.81 then
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        set a = GAngle5(e4, x, y)
                        if BlzGetLocalSpecialEffectZ(e3) > 10.0 then
                            call BlzSetSpecialEffectHeight(e3, BlzGetLocalSpecialEffectZ(e3) - 5.0)
                            call BlzSetSpecialEffectHeight(e4, BlzGetLocalSpecialEffectZ(e3) + 145.0)
                        endif
                        if SR5(e4, x, y) > 160.0 then
                            if r2 > 0.03 then
                                set r2 = 0.0
                                call VisionTimed(GetOwningPlayer(c), GetEffX(e4), GetEffY(e4), aoe, 1.0)
                                call DecorRemove(c, GetEffX(e4), GetEffY(e4), aoe, LaxusR_DecorDamage)
                                call GroupClear(g)
                                call GroupEnumUnitsInRange(g, GetEffX(e4), GetEffY(e4), aoe, Condition(function NoDecor_Filter))
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                        if GetUnitAbilityLevel(u, 'B008') > 0 then 
                                            call dmgmag(c, u, dmg * (1.0 + (LaxusR_DamageBonus / 100.0)))
                                        else
                                            call dmgmag(c, u, dmg)
                                        endif
                                        if LaxusR_Debuff > 0 then
                                            call ErzaPassive(c, u, LaxusR_Debuff)
                                        endif
                                        call StunUnit(c, u, LaxusR_Stun)
                                        call GroupAddUnit(g2, u)
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                                set u = null
                            else
                                set r2 = r2 + 0.03
                            endif
                            call BlzSetSpecialEffectYaw(e3, a)
                            call MoveEff2(e3, move, a)
                            call BlzSetSpecialEffectYaw(e4, a)
                            call MoveEff2(e4, move, a)
                        else
                            set r = 9999.0
                        endif
                    endif
                else
                    if e != null then
                        call DestroyEffect(e)
                        set e = null
                    endif
                    if e2 != null then
                        call DestroyEffect(e2)
                        set e2 = null
                    endif
                    if r >= 0.81 then
                        if r == 9999.0 then
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                        else
                            set x = GetEffX(e4)
                            set y = GetEffY(e4)
                        endif
                        set k = 0
                        loop
                            exitwhen k == 12
                            set rr1 = GetRandomReal(395.0, 700.0)
                            set rr2 = GetRandomReal(0.0, 360.0) * bj_DEGTORAD
                            set x1 = x + rr1 * Cos(rr2)
                            set y1 = y + rr1 * Sin(rr2)
                            if check2 == 0 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_opbr0326 (109)yel.mdl", x1, y1, GetRandomReal(0.0, 359.0), GetRandomReal(1.0, 1.25), 1.35, 1.0))
                            else
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_opbr0326 (109).mdl", x1, y1, GetRandomReal(0.0, 359.0), GetRandomReal(1.0, 1.25), 1.35, 1.0))
                            endif
                            set k = k + 1
                        endloop
                        call MakeSound("war3mapimported\\Hero_Laxus_R2")
                        call VisionTimed(GetOwningPlayer(c), x, y, LaxusR_DamageAoe2, 1.0)
                        call DecorRemove(c, x, y, LaxusR_DamageAoe2, LaxusR_ExplosionDecorDamage)
                        call BlzSetSpecialEffectTimeScale(e3, 5.0)
                        if check2 == 0 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (513)yellow.mdl", x, y, GetRandomReal(0.0, 359.0), 0.75, 0.80, 1.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_[DoFT]EF501Item.mdl", x, y, GetRandomReal(0.0, 359.0), 0.85, 4.50, 1.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_ljq_jn_lsfgxs02.mdl", x, y, GetRandomReal(0.0, 359.0), 4.0, 0.85, 1.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_File00229.mdl", x, y, GetRandomReal(0.0, 359.0), 0.50, 8.0, 1.0))
                        else
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (513)red.mdl", x, y, GetRandomReal(0.0, 359.0), 0.75, 0.80, 1.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_ljq_jn_lsfgxs02_red.mdl", x, y, GetRandomReal(0.0, 359.0), 4.0, 0.85, 1.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_RedMissile.mdl", x, y, GetRandomReal(0.0, 359.0), 0.50, 8.0, 1.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)3small.mdl", x, y, GetRandomReal(0.0, 359.0), 1.0, 3.0, 145.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZarakiWCrack2.mdx", x, y, GetRandomReal(0.0, 359.0), 1.0, 3.0, 0.0))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Eff_Ord_DanGe_Wav_Kuosan_1_3_0.5s.mdx", x, y, 1.0, 1.0, 1.0, 100.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlashred.mdl", x + 25.0 * Cos(a), y + 25.0 * Sin(a), 1.0, 1.25, 2.5, 255.0))
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_afbcoyrighthdcec.mdl", x, y, GetRandomReal(0.0, 359.0), 0.65, 5.0, 175.0, 45, 0, 0, 255))
                        endif
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, LaxusR_DamageAoe2, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                if GetUnitAbilityLevel(u, 'B008') > 0 then 
                                    call dmgmag(c, u, dmg * (1.0 + (LaxusR_DamageBonus / 100.0)))
                                else
                                    call dmgmag(c, u, dmg)
                                endif
                                if LaxusR_Debuff > 0 then
                                    call ErzaPassive(c, u, LaxusR_Debuff)
                                endif
                                call StunUnit(c, u, LaxusR_Stun)
                                call GroupAddUnit(g2, u)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                    else
                        if LaxusR_IsInvul then
                            call StopSpellUnit(c)
                        else
                            call StopSpellUnit2(c)
                        endif
                    endif
                    if e3 != null then
                        call DestroyEffect(e3)
                        set e3 = null
                    endif
                    if e4 != null then
                        call DestroyEffect(e4)
                        set e4 = null
                    endif
                    call SetUnitTimeScale(c, 1.0)
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    if g2 != null then
                        call DestroyGroup(g2)
                    endif
                    set g = null
                    set g2 = null
                    set c = null
                    set td = null
                    set u = null
                    set m_LaxusR[i] = m_LaxusR[MUI_LaxusR]
                    set MUI_LaxusR = MUI_LaxusR - 1
                    if MUI_LaxusR == -1 then
                        call LaxusTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method LaxusR_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create()
            set MUI_LaxusR = MUI_LaxusR + 1
            set m_LaxusR[MUI_LaxusR] = this
            set c = NewC
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r = 0.0
            set r2 = 0.0
            set move = 140.0
            if LaxusR_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set r2 = 10.0
            set dmg = GetHeroStr(c, true) * (LaxusR_DamageStrBase + LaxusR_DamageStrStep * (GetUnitAbilityLevel(c, LaxusR_ID) - 1))
            set check2 = 0
            if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) == 1 then
                set dmg = dmg + GetHeroStr(c, true) * LaxusGR_DamageStrBonus
                if LoadInteger(hs, GetHandleId(c), StringHash("lvl5")) == 1 then
                    set check2 = 1
                    set dmg = dmg + GetHeroStr(c, true) * LaxusGR_DamageStrBonus2
                endif
            endif
            if check2 == 1 then
                set e = AddSpecialEffectTarget("war3mapImported\\wos_RedMissile.mdl", c, "hand right")
                set e2 = AddSpecialEffectTarget("war3mapImported\\wos_RedMissile.mdl", c, "hand left")
            else
                set e = AddSpecialEffectTarget("war3mapImported\\wos_YellowMissile.mdl", c, "hand right")
                set e2 = AddSpecialEffectTarget("war3mapImported\\wos_YellowMissile.mdl", c, "hand left")
            endif
            set a = GAngle2(c, x, y)
            set aoe = LaxusR_DamageAoe
            set rmax = LaxusR_MaxDuration
            call SetUnitAnimationByIndex(c, 12)
            call SetUnitTimeScale(c, 1.0)
            call MakeSound("war3mapimported\\Hero_Laxus_R")
            if MUI_LaxusR == 0 then
                call LaxusTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct LaxusT_KS
        private static integer array m_LaxusT
        private static integer MUI_LaxusT = -1
        unit c
        real x
        real y
        group g
        unit u
        real dmg
        real aoe
        real r
        real scale
        effect e
        effect e2
        effect e3
        real rmax

        public static method Loop_LaxusT takes nothing returns nothing
            local thistype this
            local integer i = 0
            local effect impactEffect
            loop
                exitwhen i > MUI_LaxusT
                set this = m_LaxusT[i]
                if r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if LaxusT_IsInvul then
                        call DebugUnit(c)
                    else
                        call DebugUnit2(c)
                    endif
                    if r == 0.39 then
                        set e = AddSpecialEffectTarget("war3mapImported\\wos_ChuShou_BY_Wood_yellow_XuLi.mdl", c, "hand right")
                        set e2 = AddSpecialEffectTarget("war3mapImported\\wos_ChuShou_BY_Wood_yellow_XuLi.mdl", c, "hand left")
                    endif
                    if r == 1.02 then
                        set e3 = AddSpecialEffectTarget("war3mapImported\\wos_fgo jg.mdl", c, "hand left")
                    endif
                    if r == rmax then
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        call DecorRemove(c, x, y, aoe, LaxusT_DecorDamage)
                        call VisionTimed(GetOwningPlayer(c), x, y, aoe, 1.5)
                        set impactEffect = EffectSpawnScale("war3mapImported\\wos_by_wood_bashenan_juqi_2_2_yellow.mdl", x, y, GetRandomReal(0.0, 359.0), 0.65, 1.0, 150.0, 0.30, 1.0, 17.0 * scale)
                        call EHeightSet(impactEffect, 0.30, 650.0)
                        call AnimDummyEff(impactEffect, 0.40, 10.0)
                        call ColorEffDummy3(impactEffect, 0.50, 255, 255, 255, 0.10)
                        set impactEffect = null
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_HakkeStartWhite.mdx", x, y, GetRandomReal(0.0, 359.0), 1.40, 2.75 * scale, 0.0, 255, 255, 125, 255))
                        call DestroyEffect(EffectSpawnScale("war3mapImported\\wos_by_wood_effect_order_dange_yueyun_3yellowlightclear.mdl", x, y, GetRandomReal(0.0, 359.0), 0.65, 1.0, 1.0, 0.30, 0.01, 2.80 * scale))
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                if LaxusT_Debuff > 0 then
                                    call ErzaPassive(c, u, LaxusT_Debuff)
                                endif
                                call dmgmag(c, u, dmg)
                                call SilenceUnit(c, u, LaxusT_Silence)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                    endif
                else
                    if r < rmax then
                        call StopSound(gg_snd_Hero_Laxus_T, false, false)
                    endif
                    if LaxusT_IsInvul then
                        call StopSpellUnit(c)
                        call UnitRemoveAbility(c, 'Avul')
                    else
                        call StopSpellUnit2(c)
                    endif
                    if e != null then
                        call DestroyEffect(e)
                    endif
                    if e2 != null then
                        call DestroyEffect(e2)
                    endif
                    if e3 != null then
                        call DestroyEffect(e3)
                    endif
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    call SetUnitTimeScale(c, 1.0)
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set g = null
                    set u = null
                    set m_LaxusT[i] = m_LaxusT[MUI_LaxusT]
                    set MUI_LaxusT = MUI_LaxusT - 1
                    if MUI_LaxusT == -1 then
                        call LaxusTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method LaxusT_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_LaxusT = MUI_LaxusT + 1
            set m_LaxusT[MUI_LaxusT] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0.0
            set rmax = LaxusT_CastTime
            set g = CreateGroup()
            set dmg = GetHeroStr(c, true) * LaxusT_DamageStrBase
            if LaxusT_IsInvul then
                call StartSpellUnit(c)
                call UnitAddAbility(c, 'Avul')
            else
                call StartSpellUnit2(c)
            endif
            set aoe = LaxusT_DamageAoe
            call SetUnitAnimationByIndex(c, 8)
            set scale = aoe / 1600.0
            call SetUnitTimeScale(c, 0.45)
            call StopSound(gg_snd_Hero_Laxus_T, false, false)
            call StartSound(gg_snd_Hero_Laxus_T)
            if MUI_LaxusT == 0 then
                call LaxusTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct LaxusF_KS
        private static integer array m_LaxusF
        private static integer MUI_LaxusF = -1
        unit c
        unit td
        real x
        real y
        real dmg
        real move
        real r
        real r2
        real zigzagPhase
        integer check
        integer check2
        effect e
        effect e2
        effect e3
        real a
        real rmax

        public static method Loop_LaxusF takes nothing returns nothing
            local thistype this
            local real rr1
            local real rr2
            local integer k
            local real x1
            local real y1
            local integer i = 0
            loop
                exitwhen i > MUI_LaxusF
                set this = m_LaxusF[i]
                if SpellBoolCaster(c) and r <= rmax and SpellBoolCaster(td) then
                    set r = RoundReal(r + 0.03, 3)
                    set a = GAngle(c, td)
                    call SetUnitFacing(c, a * bj_RADTODEG)

                    // ФАЗА 0: Полет / рывок к цели
                    if check == 0 then
                        if r > LaxusF_CastTime then
                            if SR2(c, td) > 160.0 then
                                set x = GetUnitX(c)
                                set y = GetUnitY(c)

                                set zigzagPhase = zigzagPhase + 0.50
                                call MoveUnit(c, move, a + 60.0 * Sin(zigzagPhase) * bj_DEGTORAD)
                                call MoveEff(e, move, a + 60.0 * Sin(zigzagPhase) * bj_DEGTORAD)

                                set r2 = r2 + 0.03
                                if check2 == 0 then
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_YellowMissile.mdl", x, y, GetRandomReal(0.0, 359.0), 1.0, 1.0, 100.0))
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_YellowSpark.mdl", x, y, GetRandomReal(0.0, 359.0), 1.0, 1.45, 100.0))
                                else
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_RedMissile.mdl", x, y, GetRandomReal(0.0, 359.0), 1.0, 1.0, 100.0))
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_RedSpark.mdl", x, y, GetRandomReal(0.0, 359.0), 1.0, 1.45, 100.0))
                                endif
                                if r2 >= 0.12 then
                                    set r2 = 0.0
                                    call DecorRemove(c, x, y, 350.0, LaxusF_DecorDamage)
                                endif
                            else
                                call SetUnitPosition(c, GetUnitX(td) - 175.0 * Cos(a), GetUnitY(td) - 175.0 * Sin(a))
                                
                                // ИСПРАВЛЕНИЕ: цель td всегда получает только паузу (StartSpellUnit2), без неуязвимости!
                                call StartSpellUnit2(td)

                                if e != null then
                                    call DestroyEffect(e)
                                    set e = null
                                endif
                                if check2 == 0 then
                                    call MakeSound("war3mapimported\\Hero_Laxus_F2")
                                endif
                                call SetUnitAnimationByIndex(c, 6)
                                call SetUnitTimeScale(c, 1.25)
                                call SetUnitVertexColor(c, 255, 255, 255, 255)
                                
                                // ИСПРАВЛЕНИЕ: сброс таймера и задание чистого лимита для фазы удара
                                set r = 0.0
                                set r2 = 0.0
                                set rmax = LaxusF_HitDelay + 0.50
                                set check = 1
                            endif
                        endif

                    // ФАЗА 1: Удар по цели
                    elseif check == 1 then
                        call DebugUnit2(td)
                        if LaxusF_IsInvul then
                            call DebugUnit(c)
                        else
                            call DebugUnit2(c)
                        endif

                        if r >= 0.60 and e2 != null then
                            call DestroyEffect(e2)
                            set e2 = null
                            if e3 != null then
                                call DestroyEffect(e3)
                                set e3 = null
                            endif
                        endif

                        // ИСПРАВЛЕНИЕ: проверка через >= исключает пропуск кадра
                        if r >= LaxusF_HitDelay then
                            call dmgphys(c, td, dmg)
                            if LaxusF_Debuff > 0 then
                                call ErzaPassive(c, td, LaxusF_Debuff)
                            endif
                            call StunUnit(c, td, LaxusF_Stun)
                            call MUE(td, LaxusF_PushRange, LaxusF_PushDuration, a)
                            call MakeSound("war3mapimported\\Hero_Laxus_F3")
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            call DecorRemove(c, x, y, 350.0, LaxusF_DecorDamage)
                            
                            set x = GetUnitX(td) + 130.0 * Cos(a)
                            set y = GetUnitY(td) + 130.0 * Sin(a)
                            if check2 == 0 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_YellowBoom.mdx", x, y, 1.0, 1.25, 4.0, 110.0))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_SlamYellow.mdl", x, y, 1.0, 1.0, 4.0, 1.0))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_YellowMissile.mdl", x, y, 1.0, 1.0, 4.0, 100.0))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (513)yellow.mdl", x, y, GetRandomReal(0.0, 359.0), 2.0, 0.80, 1.0))
                                call DestroyEffect(EffectSpawn("war3mapImported\\modelgh (1).mdl", x, y, 0.0, 3.0, 1.25, 100.0))
                                set k = 0
                                loop
                                    exitwhen k == 6
                                    set rr1 = GetRandomReal(150.0, 200.0)
                                    set rr2 = GetRandomReal(0.0, 360.0) * bj_DEGTORAD
                                    set x1 = x + rr1 * Cos(rr2)
                                    set y1 = y + rr1 * Sin(rr2)
                                    call EffectSpawn2("war3mapImported\\wos_krk (1849)2.mdx", x1, y1, 60.0 * k, 1.0, 1.45, 75.0, 0.50)
                                    set k = k + 1
                                endloop
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_[DoFT]EF501Item.mdl", x, y, GetRandomReal(0.0, 359.0), 0.65, 3.0, 1.0))
                            else
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_RedBoom.mdx", x, y, 1.0, 1.25, 4.0, 110.0))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_SlamRed.mdl", x, y, 1.0, 1.0, 4.0, 1.0))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_RedMissile.mdl", x, y, 1.0, 1.0, 4.0, 100.0))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (513)red.mdl", x, y, GetRandomReal(0.0, 359.0), 2.0, 0.80, 1.0))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_modelgh (1)red.mdl", x, y, 0.0, 3.0, 1.25, 100.0))
                                set k = 0
                                loop
                                    exitwhen k == 6
                                    set rr1 = GetRandomReal(150.0, 200.0)
                                    set rr2 = GetRandomReal(0.0, 360.0) * bj_DEGTORAD
                                    set x1 = x + rr1 * Cos(rr2)
                                    set y1 = y + rr1 * Sin(rr2)
                                    call EffectSpawn2("war3mapImported\\wos_krk (1849)4.mdx", x1, y1, 60.0 * k, 1.0, 1.45, 75.0, 0.50)
                                    set k = k + 1
                                endloop
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)3small.mdl", x, y, GetRandomReal(0.0, 359.0), 1.0, 3.0, 145.0))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZarakiWCrack2.mdx", x, y, GetRandomReal(0.0, 359.0), 1.0, 3.0, 0.0))
                            endif

                            // Удар завершен, отправляем на удаление инстанса
                            set r = 99999.0
                        endif
                    endif
                else
                    // ИСПРАВЛЕНИЕ: цель td всегда освобождается через StopSpellUnit2
                    if check == 1 and td != null then
                        call StopSpellUnit2(td)
                    endif
                    if e != null then
                        call DestroyEffect(e)
                    endif
                    if e2 != null then
                        call DestroyEffect(e2)
                    endif
                    if e3 != null then
                        call DestroyEffect(e3)
                    endif
                    if LaxusF_IsInvul then
                        call StopSpellUnit(c)
                    else
                        call StopSpellUnit2(c)
                    endif
                    call SetUnitTimeScale(c, 1.0)
                    call SetUnitVertexColor(c, 255, 255, 255, 255)
                    set c = null
                    set td = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set m_LaxusF[i] = m_LaxusF[MUI_LaxusF]
                    set MUI_LaxusF = MUI_LaxusF - 1
                    if MUI_LaxusF == -1 then
                        call LaxusTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method LaxusF_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create()
            set MUI_LaxusF = MUI_LaxusF + 1
            set m_LaxusF[MUI_LaxusF] = this
            set c = NewC
            set td = NewTd
            set r = 0.0
            set r2 = 0.0
            set zigzagPhase = 0.0
            set check = 0
            set move = 100.0
            set rmax = LaxusF_MaxDuration
            if LaxusF_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            call SetUnitAnimationByIndex(c, 6)
            call SetUnitTimeScale(c, 1.10)
            set dmg = GetHeroStr(c, true) * LaxusF_DamageStrBase
            set check2 = 0
            if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) == 1 then
                set dmg = dmg + GetHeroStr(c, true) * LaxusGF_DamageStrBonus
                if LoadInteger(hs, GetHandleId(c), StringHash("lvl5")) == 1 then
                    set dmg = dmg + GetHeroStr(c, true) * LaxusGF_DamageStrBonus2
                    set check2 = 1
                endif
            endif
            if LoadInteger(hs, GetHandleId(c), StringHash("lvl5")) == 1 then
                call MakeSound("war3mapimported\\Hero_Laxus_GW3")
            else
                call MakeSound("war3mapimported\\Hero_Laxus_F1")
            endif
            call SetUnitVertexColor(c, 255, 255, 255, 0)
            if check2 == 1 then
                set e = EffectSpawn("war3mapImported\\wos_BJT_VFX_ERE_LightningFieldBall_Ore_red.mdl", GetUnitX(c), GetUnitY(c), 1.0, 1.0, 1.0, 100.0)
                set e2 = AddSpecialEffectTarget("war3mapImported\\wos_File00229.mdl", c, "hand left")
                set e3 = AddSpecialEffectTarget("war3mapImported\\wos_BJT_VFX_ERE_LightningFieldBall_Ore_red.mdl", c, "hand left")
            else
                set e = EffectSpawn("war3mapImported\\wos_BJT_VFX_ERE_LightningFieldBall_Ore.mdl", GetUnitX(c), GetUnitY(c), 1.0, 1.0, 1.0, 100.0)
                set e2 = AddSpecialEffectTarget("war3mapImported\\wos_File00229.mdl", c, "hand left")
                set e3 = AddSpecialEffectTarget("war3mapImported\\wos_BJT_VFX_ERE_LightningFieldBall_Ore.mdl", c, "hand left")
            endif
            if MUI_LaxusF == 0 then
                call LaxusTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct LaxusG_KS
        private static integer array m_LaxusG
        private static integer MUI_LaxusG = -1
        unit c
        integer k2
        private static framehandle array frame_pas1
        private static framehandle array frame_pas2
        private static framehandle array frame_pas3
        private static framehandle array frame_pas4
        private static framehandle array frame_pas5
        private static framehandle array frame_pas6
        real r
        unit d 
        integer scale
        effect e
        real rmax

        public static method Loop_LaxusG takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real remaining
            local real hp 
            loop
                exitwhen i > MUI_LaxusG
                set this = m_LaxusG[i]
                if SpellBoolCaster(c) and r <= rmax and not CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) then
                    if not IsUnitPaused(c) then
                        set r = RoundReal(r + 0.03, 3)
                    endif
                    set remaining = rmax - r
                    if remaining < 0.0 then
                        set remaining = 0.0
                    endif
                    call BlzFrameSetValue(frame_pas3[k2], remaining)
                    call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(remaining, 0, 2) + "|r")
                else
                    if GetLocalPlayer() == Player(k2) then
                        call BlzFrameSetVisible(frame_pas1[k2], false)
                    endif

                    call SaveInteger(hs, GetHandleId(c), StringHash("lvl4"), 0)
                    call IssueImmediateOrder(c, "stop")
                    if GetLocalPlayer() == Player(k2) then
                        call BlzSetAbilityIcon(LaxusQ2_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_Q2.blp")
                        call BlzSetAbilityIcon(LaxusW_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_W.blp")
                        call BlzSetAbilityIcon(LaxusW2_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_W2.blp")
                        call BlzSetAbilityIcon(LaxusE_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_E.blp")
                        call BlzSetAbilityIcon(LaxusR_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_R.blp")
                        call BlzSetAbilityIcon(LaxusF_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_F.blp")
                    endif
                    call SaveInteger(hs, GetHandleId(c), StringHash("mode g"), 0)
                    if e != null then
                        call DestroyEffect(e)
                    endif
                    set hp = GetUnitState(c, UNIT_STATE_LIFE) / GetUnitState(c, UNIT_STATE_MAX_LIFE)
                    call BlzSetUnitMaxHP(c, BlzGetUnitMaxHP(c) - scale)
                    call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_MAX_LIFE) * hp)
                    call UnitRemoveAbility(c, 'A0F0')

                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), LaxusQ_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), LaxusQ2_ID, false)
                    call BlzStartUnitAbilityCooldown(c, LaxusQ_ID, BlzGetUnitAbilityCooldownRemaining(c, LaxusQ2_ID))
                    if d != null then
                        call RemoveUnit(d)
                    endif

                    // Точка 3: Возврат тултипов в форму 0 при окончании морфа
                    call AAUniversalTooltips_SetUnitForm(c, 0)

                    set c = null
                    set d = null
                    set e = null
                    set m_LaxusG[i] = m_LaxusG[MUI_LaxusG]
                    set MUI_LaxusG = MUI_LaxusG - 1
                    if MUI_LaxusG == -1 then
                        call LaxusTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method LaxusG_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            local integer rr = LaxusG_HpBonus35
            local real hp
            set MUI_LaxusG = MUI_LaxusG + 1
            set m_LaxusG[MUI_LaxusG] = this
            set c = NewC
            set r = 0.0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set rmax = LaxusG_Duration
            set d = CreateUnit(GetOwningPlayer(c), 'h02D', GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster), 1.0)
            
            // Запуск без остановки через Order Tracking
            call Laxus_RestoreOrder(c, 7)

            call UnitAddAbility(c, 'A0F0')
            call UnitAddAbility(c, LaxusQ2_ID)
            call SetUnitAbilityLevel(c, LaxusQ2_ID, GetUnitAbilityLevel(c, LaxusQ_ID))
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), LaxusQ_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), LaxusQ2_ID, true)
            call BlzStartUnitAbilityCooldown(c, LaxusQ2_ID, BlzGetUnitAbilityCooldownRemaining(c, LaxusQ_ID))
              
            set hp = GetUnitState(c, UNIT_STATE_LIFE) / GetUnitState(c, UNIT_STATE_MAX_LIFE)
            call SaveInteger(hs, GetHandleId(c), StringHash("mode g"), 1)
            call SaveInteger(hs, GetHandleId(c), StringHash("lvl4"), 1)
            if GetLocalPlayer() == Player(k2) then
                call BlzSetAbilityIcon(LaxusQ2_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_Q2.blp")
            endif
            if frame_pas1[k2] == null then
                set frame_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                call BlzFrameSetAbsPoint(frame_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18)
                call BlzFrameSetSize(frame_pas1[k2], 0.135, 0.035)
                call BlzFrameSetTexture(frame_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                call BlzFrameSetVisible(frame_pas1[k2], false)
                if GetLocalPlayer() == Player(k2) then
                    call BlzFrameSetVisible(frame_pas1[k2], true)
                endif
                set frame_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame_pas1[k2], 0, 0)
                call BlzFrameSetAbsPoint(frame_pas2[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                call BlzFrameSetSize(frame_pas2[k2], 0.10, 0.019)
                set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)
                call BlzFrameSetSize(frame_pas3[k2], 0.10, 0.035)
                call BlzFrameSetScale(frame_pas3[k2], 0.50)
                call BlzFrameSetModel(frame_pas3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                call BlzFrameSetAbsPoint(frame_pas3[k2], FRAMEPOINT_CENTER, 0.05, 0.175)
                call BlzFrameSetMinMaxValue(frame_pas3[k2], 0.0, rmax)
                call BlzFrameSetValue(frame_pas3[k2], rmax)
                set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18)
                call BlzFrameSetSize(frame_pas4[k2], 0.0275, 0.0275)
                call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_Icon2.blp", 0, false)
                set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Morph Time Left:" + "|r")
                call BlzFrameSetScale(frame_pas5[k2], 0.90)
                set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17)
                call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(0.0, 0, 2) + "|r")
                call BlzFrameSetScale(frame_pas6[k2], 0.90)
            else
                if GetLocalPlayer() == Player(k2) then
                    call BlzFrameSetVisible(frame_pas1[k2], true)
                endif
                call BlzFrameSetValue(frame_pas3[k2], rmax)
            endif

            if LoadInteger(hs, GetHandleId(c), StringHash("lvl5")) == 0 then
                set scale = 0
                if GetRandomInt(1, 4) == 2 then
                    call MakeSound("war3mapimported\\Hero_Laxus_G4")
                else
                    call MakeSound("war3mapimported\\Hero_Laxus_G5")
                endif
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_YellowMissile.mdl", GetUnitX(c), GetUnitY(c), 1.0, 1.0, 4.0, 100.0))
                set e = AddSpecialEffectTarget("war3mapImported\\wos_Shio_Super_Saiyan_JN_SS-2_laxus1.mdl", c, "origin")
                call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_G.blp", 0, false)

                // Точка 1: Вход в Форму 1 (Mode G)
                call AAUniversalTooltips_SetUnitForm(c, 1)
            else
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_RedMissile.mdl", GetUnitX(c), GetUnitY(c), 1.0, 1.0, 4.0, 100.0))
                if GetRandomInt(1, 4) == 2 then
                    call MakeSound("war3mapimported\\Hero_Laxus_G4")
                else
                    call MakeSound("war3mapimported\\Hero_Laxus_G2")
                endif
                set scale = rr
                call BlzSetUnitMaxHP(c, BlzGetUnitMaxHP(c) + rr)
                call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_MAX_LIFE) * hp)
                set e = AddSpecialEffectTarget("war3mapImported\\wos_Shio_Super_Saiyan_JN_SS-2_laxus2.mdl", c, "origin")
                call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_G2.blp", 0, false)
                if GetLocalPlayer() == Player(k2) then
                    call BlzSetAbilityIcon(LaxusQ2_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_GQ.blp")
                    call BlzSetAbilityIcon(LaxusW_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_GW.blp")
                    call BlzSetAbilityIcon(LaxusW2_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_GW2.blp")
                    call BlzSetAbilityIcon(LaxusE_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_GE.blp")
                    call BlzSetAbilityIcon(LaxusR_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_GR.blp")
                    call BlzSetAbilityIcon(LaxusF_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Laxus_GF.blp")
                endif

                // Точка 2: Вход в Форму 2 (Red Lightning Mode Lv. 35)
                call AAUniversalTooltips_SetUnitForm(c, 2)
            endif

            if MUI_LaxusG == 0 then
                call LaxusTimer03Acquire()
            endif
        endmethod
    endstruct

    private function LaxusTimer03Loop takes nothing returns nothing
        call LaxusW2_Revert.Loop()
        call LaxusQ_KS.Loop_LaxusQ()
        call LaxusQ_KS.Loop_LaxusQ2()
        call LaxusW_KS.Loop_LaxusW()
        call LaxusW_KS.Loop_LaxusW2()
        call LaxusE_KS.Loop_LaxusE()
        call LaxusR_KS.Loop_LaxusR()
        call LaxusT_KS.Loop_LaxusT()
        call LaxusF_KS.Loop_LaxusF()
        call LaxusG_KS.Loop_LaxusG()
    endfunction

    private function InitLaxusSpells takes nothing returns nothing
        set LaxusTimer03 = CreateTimer()
        set LaxusTimer03Callback = function LaxusTimer03Loop
    endfunction

    //===========================================================================
    // ТОЧКИ ВХОДА СПОСОБНОСТЕЙ
    //===========================================================================
    function LaxusFCheck_Start takes unit damaged returns nothing
        local integer i = 0
        local unit responder
        local player damagedOwner = GetOwningPlayer(damaged)
        local real damagedX = GetUnitX(damaged)
        local real damagedY = GetUnitY(damaged)
        local real dx
        local real dy
        local real rangeSquared = LaxusF_AoeSearch * LaxusF_AoeSearch

        loop
            exitwhen i >= bj_MAX_PLAYER_SLOTS
            set responder = Hero[i]

            if responder != null and GetUnitTypeId(responder) == Laxus_ID and GetWidgetLife(responder) > 1.0 and not IsUnitIllusion(responder) and GetHeroLevel(responder) >= 25 and IsUnitAlly(responder, damagedOwner) then
                set dx = GetUnitX(responder) - damagedX
                set dy = GetUnitY(responder) - damagedY

                if dx * dx + dy * dy <= rangeSquared and IntegerCd(responder, "pas f", 5.0) then
                    call MyRemoveUnit(CreateUnit(GetOwningPlayer(responder), 'h02D', GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster), 1.0), 30.0)
                endif
            endif

            set i = i + 1
        endloop

        set responder = null
        set damagedOwner = null
    endfunction

    function LaxusQ_Start takes unit c, real x, real y returns nothing
        if LoadInteger(hs, GetHandleId(c), StringHash("lvl4")) == 0 then
            call LaxusQ_KS.LaxusQ_Start(c, x, y)
        else
            call LaxusQ_KS.LaxusQ2_Start(c, x, y)
        endif
    endfunction

    function LaxusQ2_Start takes unit c, real x, real y returns nothing
        call LaxusQ_KS.LaxusQ2_Start(c, x, y)
    endfunction

    function LaxusW_Start takes unit c, unit td returns nothing
        call LaxusW_KS.LaxusW_Start(c, td)
    endfunction

    function LaxusW2_Start takes unit c, unit td returns nothing
        call LaxusW_KS.LaxusW2_Start(c, td)
    endfunction

    function LaxusE_Start takes unit c returns nothing
        call LaxusE_KS.LaxusE_Start(c)
    endfunction

    function LaxusR_Start takes unit c, unit td returns nothing
        local real x = GetUnitX(td)
        local real y = GetUnitY(td)
        local integer i2 = 0
        local integer id = LaxusR_ID
        if IsUnitAlly(td, GetOwningPlayer(c)) and GetHeroLevel(td) >= 25 and GetUnitTypeId(td) == Natsu_ID and LoadInteger(hs, GetHandleId(td), StringHash("mode g")) == 0 and IntegerCd(c, "natsu mode raien", 60.0) then 
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_YellowBoom.mdx", x, y, 1.0, 1.25, 4.0, 110.0))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_effect_yubanmeiqin_lightning_zhenzhengdeluolei_yellow.mdl", x, y, 1.0, 1.0, 2.0, 1.0))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_YellowMissile.mdl", x, y, 1.0, 1.0, 6.0, 100.0))
            call NatsuG2_Start(td)
            call UnitAddAbility(td, 'A0F8')
            call MyRemoveAbility(td, 20.0, 'A0F8', 1)
            call MakeSound("war3mapimported\\Hero_Laxus_Pick1")
            call MakeSound("war3mapimported\\Hero_Laxus_W2 2")
        elseif IsUnitEnemy(td, GetOwningPlayer(c)) then 
            call LaxusR_KS.LaxusR_Start(c, td)
        else
            call IssueImmediateOrder(c, "stop")
            set i2 = BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(c, id), ABILITY_ILF_MANA_COST, GetUnitAbilityLevel(c, id) - 1)
            call MyAddMana(c, I2R(i2), 0.03)
        endif
    endfunction

    function LaxusT_Start takes unit c returns nothing
        call LaxusT_KS.LaxusT_Start(c)
    endfunction

    function LaxusF_Start takes unit c, unit td returns nothing
        call LaxusF_KS.LaxusF_Start(c, td)
    endfunction

    function LaxusG_Start takes unit c returns nothing
        call LaxusG_KS.LaxusG_Start(c)
    endfunction
endlibrary