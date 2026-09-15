library BazzBSpells initializer InitBazzBSpells uses GearSystems
    globals
        private timer BazzBTimer03
        private code BazzBTimer03Callback
        private integer BazzBTimer03Users = 0

        private timer BazzBTimer05
        private code BazzBTimer05Callback
        private integer BazzBTimer05Users = 0

//--------------------------------------BazzB Core---------------------------------------------------------
        integer BazzB_ID = 'H01G'

//---------------G ability (The Heat - Cooldown Reduction Passive)-------------
        integer BazzBG_ID = 'A08R'
        real BazzBG_CdReduce1 = 1.25
        real BazzBG_CdReduce2 = 1.75
        real BazzBG_CdReduce3 = 2.25

//---------------Q ability (Burner Finger 1)-----------------------------------
        integer BazzBQ_ID = 'A08M'
        real BazzBQ_DamageAgiBase = 1.00
        real BazzBQ_DamageAgiStep = 1.00
        real BazzBQ_Damage2StaticBase = 150.00
        real BazzBQ_Damage2StaticStep = 0.00
        real BazzBQ_DamageAoe = 245.00
        real BazzBQ_CastTime = 0.63
        boolean BazzBQ_IsInvul = false
        real BazzBQ_DecorDamage = 50.00

//---------------W ability (Burner Finger 2)-----------------------------------
        integer BazzBW_ID = 'A08N'
        real BazzBW_DamageAgiBase = 1.00
        real BazzBW_DamageAgiStep = 1.00
        real BazzBW_Damage2StaticBase = 175.00
        real BazzBW_Damage2StaticStep = 0.00
        real BazzBW_DamageAoe = 225.00
        real BazzBW_CastTime = 1.20
        boolean BazzBW_InvulGain = false
        boolean BazzBW_IsInvul = false
        real BazzBW_DecorDamage = 50.00

//---------------E ability (Burner Finger 3 - Lava Eruption)-------------------
        integer BazzBE_ID = 'A08O'
        real BazzBE_DamageAgiBase = 3.00
        real BazzBE_DamageAgiStep = 1.00
        real BazzBE_DamageAoe = 750.00
        real BazzBE_PushDuration = 0.42
        real BazzBE_PushRange = 500.00
        real BazzBE_CastTime = 0.35
        boolean BazzBE_IsInvul = true
        real BazzBE_DecorDamage = 50.00

//---------------R ability (Burner Finger 4)-----------------------------------
        integer BazzBR_ID = 'A08P'
        real BazzBR_DamageAgiBase = 4.00
        real BazzBR_DamageAgiStep = 1.00
        real BazzBR_DamageAoe = 500.00
        real BazzBR_StunDuration = 1.00
        real BazzBR_CastTime = 2.10
        boolean BazzBR_IsInvul = true
        real BazzBR_DecorDamage = 100.00

//---------------T ability (Burning Full Fingers)------------------------------
        integer BazzBT_ID = 'A08Q'
        real BazzBT_DamageAgiBase = 10.00
        real BazzBT_DamageAoe = 585.00
        real BazzBT_Push = 750.00
        real BazzBT_PushDuration = 0.42
        real BazzBT_StunDuration = 0.00
        real BazzBT_CastTime = 1.50
        real BazzBT_Duration = 1.00
        boolean BazzBT_IsInvul = true
        real BazzBT_DecorDamage = 100.00
    endglobals

    private function BazzBTimer03Acquire takes nothing returns nothing
        set BazzBTimer03Users = BazzBTimer03Users + 1
        if BazzBTimer03Users == 1 then
            call TimerStart(BazzBTimer03, 0.03, true, BazzBTimer03Callback)
        endif
    endfunction

    private function BazzBTimer03Release takes nothing returns nothing
        set BazzBTimer03Users = BazzBTimer03Users - 1
        if BazzBTimer03Users <= 0 then
            set BazzBTimer03Users = 0
            call PauseTimer(BazzBTimer03)
        endif
    endfunction

    private function BazzBTimer05Acquire takes nothing returns nothing
        set BazzBTimer05Users = BazzBTimer05Users + 1
        if BazzBTimer05Users == 1 then
            call TimerStart(BazzBTimer05, 0.05, true, BazzBTimer05Callback)
        endif
    endfunction

    private function BazzBTimer05Release takes nothing returns nothing
        set BazzBTimer05Users = BazzBTimer05Users - 1
        if BazzBTimer05Users <= 0 then
            set BazzBTimer05Users = 0
            call PauseTimer(BazzBTimer05)
        endif
    endfunction

    function BazzBPass_Start takes unit c, integer id returns nothing
        local real r = 0.0
        if GetHeroLevel(c) >= 35 then
            set r = BazzBG_CdReduce3
        elseif GetHeroLevel(c) >= 25 then
            set r = BazzBG_CdReduce2
        elseif GetHeroLevel(c) >= 12 then
            set r = BazzBG_CdReduce1
        endif

        if r != 0.0 then
            if id != BazzBQ_ID then
                call ReduceCooldown(c, BazzBQ_ID, r)
            endif
            if id != BazzBW_ID then
                call ReduceCooldown(c, BazzBW_ID, r)
            endif
            if id != BazzBE_ID then
                call ReduceCooldown(c, BazzBE_ID, r)
            endif
            if id != BazzBR_ID then
                call ReduceCooldown(c, BazzBR_ID, r)
            endif
            if id != BazzBT_ID then
                call ReduceCooldown(c, BazzBT_ID, r)
            endif
        endif
    endfunction

    private struct BazzBSpells_Q
        private static integer array m_BazzBQ
        private static integer MUI_BazzBQ = -1

        unit c
        real x
        real y
        real x1
        real y1
        real r2
        real r3
        real r5
        group g
        group g2
        real dmg
        integer check
        real aoe
        real move
        real r
        real a
        real rmax

        public static method Loop_BazzBQ takes nothing returns nothing
            local integer i = 0
            local thistype this
            local unit u
            local boolean remove

            loop
                exitwhen i > MUI_BazzBQ
                set this = m_BazzBQ[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or GetWidgetLife(c) <= 0.405 then
                    set remove = true
                elseif SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if check == 0 then
                        call DebugUnit2(c)
                        if r == 0.30 then
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_bdef (124)2.mdl", GetUnitX(c) + 100.0 * Cos(a), GetUnitY(c) + 100.0 * Sin(a), a * bj_RADTODEG, 1.0, 2.0, 100.0))
                        endif
                        if r >= BazzBQ_CastTime then
                            call StopSpellUnit2(c)
                            set check = 1
                            set move = 350.0
                            set r5 = 0.0
                            call MakeSound("war3mapimported\\Hero_BazzB_Q2")
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_file00000491.mdl", GetUnitX(c) + 115.0 * Cos(a), GetUnitY(c) + 115.0 * Sin(a), a * bj_RADTODEG, 0.5, 1.65 * 0.835, 0.0))
                            call EffectSpawn2("war3mapImported\\wos_TXfiretuxi2.mdl", GetUnitX(c) + 80.0 * Cos(a), GetUnitY(c) + 80.0 * Sin(a), a * bj_RADTODEG, 2.0, 2.2 * 0.835, 111.0, 0.28)
                            set rmax = 0.15
                            set r = 0.0
                            set r2 = 0.0
                            set x1 = GetUnitX(c) + 150.0 * Cos(a)
                            set y1 = GetUnitY(c) + 150.0 * Sin(a)
                        endif
                    elseif check == 1 then
                        set r5 = r5 + move
                        call DecorRemove(c, x1, y1, aoe, BazzBQ_DecorDamage)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x1, y1, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            call GroupRemoveUnit(g, u)
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                call dmgmag(c, u, dmg)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                call GroupAddUnit(g2, u)
                            endif
                        endloop
                        set x1 = x1 + move * Cos(a)
                        set y1 = y1 + move * Sin(a)

                        if r2 >= 0.0 then
                            set r2 = 0.0
                            call EffectSpawn2("war3mapImported\\wos_BY_Wood_Effect_Order_MuZhiBenYing_Fir_Huo_DiMianss2.mdl", x1, y1, GetRandomReal(0.0, 359.0), 2.0, 1.0, 0.0, 0.15)
                            call VisionTimed(GetOwningPlayer(c), x1, y1, 800.0, 1.0)
                        else
                            set r2 = r2 + 0.03
                        endif

                        if r3 >= 0.03 then
                            set r3 = 0.0
                            call VisionTimed(GetOwningPlayer(c), x1, y1, 800.0, 1.0)
                        else
                            set r3 = r3 + 0.03
                        endif
                    endif
                else
                    set remove = true
                endif

                if remove then
                    if check == 1 then
                        call DecorRemove(c, x1, y1, aoe * 2.0, BazzBQ_DecorDamage)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x1, y1, aoe * 2.0, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            call GroupRemoveUnit(g, u)
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                call dmgmag(c, u, dmg)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                call GroupAddUnit(g2, u)
                            endif
                        endloop
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_firefly-rq-sfx2", x1, y1, 1.1, 1.0, 2.5, 90.0))
                    elseif c != null and GetUnitTypeId(c) != 0 then
                        call StopSpellUnit2(c)
                    endif

                    if c != null and GetUnitTypeId(c) != 0 then
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
                    set u = null
                    set m_BazzBQ[i] = m_BazzBQ[MUI_BazzBQ]
                    set MUI_BazzBQ = MUI_BazzBQ - 1
                    call deallocate(this)
                    if MUI_BazzBQ == -1 then
                        call BazzBTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            set u = null
        endmethod

        public static method BazzBQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            local integer level = GetUnitAbilityLevel(NewC, BazzBQ_ID)
            set MUI_BazzBQ = MUI_BazzBQ + 1
            set m_BazzBQ[MUI_BazzBQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.0
            set r2 = 0.0
            set r3 = 0.0
            set r5 = 0.0
            set move = 0.0
            set check = 0
            if level < 1 then
                set level = 1
            endif
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set a = GAngle2(c, x, y)
            set aoe = BazzBQ_DamageAoe
            set dmg = GetHeroAgi(c, true) * (BazzBQ_DamageAgiBase + (BazzBQ_DamageAgiStep * (level - 1)))
            set dmg = dmg + BazzBQ_Damage2StaticBase + (BazzBQ_Damage2StaticStep * (level - 1))
            set rmax = 0.66
            call SetUnitAnimationByIndex(c, 10)
            call SetUnitTimeScale(c, 0.65)
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapimported\\Hero_BazzB_Q01")
            else
                call MakeSound("war3mapimported\\Hero_BazzB_Q02")
            endif
            if MUI_BazzBQ == 0 then
                call BazzBTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct BazzBSpells_W
        private static integer array m_BazzBW
        private static integer MUI_BazzBW = -1

        unit c
        unit td
        real x
        real y
        real x1
        real y1
        real r2
        real r3
        real r5
        real r6
        group g
        group g2
        real dmg
        integer check
        real aoe
        real move
        real r
        effect e
        effect e6
        real a
        real rmax

        public static method Loop_BazzBW takes nothing returns nothing
            local integer i = 0
            local thistype this
            local unit u
            local boolean remove

            loop
                exitwhen i > MUI_BazzBW
                set this = m_BazzBW[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or GetWidgetLife(c) <= 0.405 then
                    set remove = true
                elseif SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if check == 0 then
                        set a = GAngle(c, td)
                        call DebugUnit2(c)
                        call SetUnitFacing(c, a * bj_RADTODEG)
                        if r >= BazzBW_CastTime then
                            if BazzBW_InvulGain then
                                call StopSpellUnit(c)
                            else
                                call StopSpellUnit2(c)
                            endif
                            set check = 1
                            call MakeSound("war3mapimported\\Hero_BazzB_W2")
                            set move = 120.0
                            set r5 = 0.0
                            call DestroyEffect(e6)
                            set e6 = null
                            set e = EffectSpawn("war3mapImported\\wos_claw slash_orange.mdl", GetUnitX(c) + 80.0 * Cos(a), GetUnitY(c) + 80.0 * Sin(a), a * bj_RADTODEG, 0.46, 2.2, 295.0)
                            call BlzSetSpecialEffectRoll(e, -300.0 * bj_DEGTORAD)
                            set rmax = 2.0
                            set r = 0.0
                            set x1 = GetUnitX(c) + 150.0 * Cos(a)
                            set y1 = GetUnitY(c) + 150.0 * Sin(a)
                        endif
                    elseif check == 1 then
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        if SR5(e, x, y) < 140.0 then
                            set r = 99999.0
                        endif
                        set a = GAngle5(e, x, y)
                        call MoveEff(e, move, a)
                        call BlzSetSpecialEffectYaw(e, a - 30.0 * bj_DEGTORAD)
                        set x1 = x1 + move * Cos(a)
                        set y1 = y1 + move * Sin(a)

                        if r6 >= 0.0 then
                            set r6 = 0.0
                            set x = GetEffX(e)
                            set y = GetEffY(e)
                            call DecorRemove(c, x, y, aoe, BazzBW_DecorDamage)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                call GroupRemoveUnit(g, u)
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                    call dmgmag(c, u, dmg)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    call GroupAddUnit(g2, u)
                                endif
                            endloop
                        else
                            set r6 = r6 + 0.03
                        endif

                        if r2 >= 0.0 then
                            set r2 = 0.0
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_0854.mdl", x1, y1, a * bj_RADTODEG, 2.0, 1.0, 0.0))
                            call EffectSpawn2("war3mapImported\\wos_BY_Wood_Effect_Order_MuZhiBenYing_Fir_Huo_DiMianss2.mdl", x1, y1, GetRandomReal(0.0, 359.0), 2.0, 1.0, 0.0, 0.15)
                            call VisionTimed(GetOwningPlayer(c), x1, y1, 800.0, 1.0)
                        else
                            set r2 = r2 + 0.03
                        endif

                        if r3 >= 0.03 then
                            set r3 = 0.0
                            call VisionTimed(GetOwningPlayer(c), x1, y1, 800.0, 1.0)
                        else
                            set r3 = r3 + 0.03
                        endif
                    endif
                else
                    set remove = true
                endif

                if remove then
                    if check == 1 and c != null and GetUnitTypeId(c) != 0 then
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        call DecorRemove(c, x, y, aoe, BazzBW_DecorDamage)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            call GroupRemoveUnit(g, u)
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                call dmgmag(c, u, dmg)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                call GroupAddUnit(g2, u)
                            endif
                        endloop
                        call DecorRemove(c, x1, y1, aoe, BazzBW_DecorDamage)
                        call VisionTimed(GetOwningPlayer(c), x1, y1, 800.0, 1.0)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_opdef (1054).mdl", x1, y1, 1.0, 2.25, 1.75, 55.0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_firefly-rq-sfx2.mdl", x1, y1, 1.0, 1.25, 3.5, 45.0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_fantasybattle (1403).mdl", x1, y1, 1.0, 1.0, 1.8, 1.0))
                    endif

                    if e != null then
                        call BlzSetSpecialEffectTimeScale(e, 1.0)
                        call DestroyEffect(e)
                        set e = null
                    endif
                    if e6 != null then
                        call DestroyEffect(e6)
                        set e6 = null
                    endif
                    if check == 0 and c != null and GetUnitTypeId(c) != 0 then
                        if BazzBW_InvulGain then
                            call StopSpellUnit(c)
                        else
                            call StopSpellUnit2(c)
                        endif
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
                    set td = null
                    set u = null
                    set m_BazzBW[i] = m_BazzBW[MUI_BazzBW]
                    set MUI_BazzBW = MUI_BazzBW - 1
                    call deallocate(this)
                    if MUI_BazzBW == -1 then
                        call BazzBTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            set u = null
        endmethod

        public static method BazzBW_Start takes unit NewC, unit NewTd returns nothing
            local thistype this
            local integer level = GetUnitAbilityLevel(NewC, BazzBW_ID)
            if NewC == null or NewTd == null or GetWidgetLife(NewTd) <= 0.405 then
                return
            endif
            set this = thistype.create()
            set MUI_BazzBW = MUI_BazzBW + 1
            set m_BazzBW[MUI_BazzBW] = this
            set c = NewC
            set td = NewTd
            set r = 0.0
            set r2 = 0.0
            set r3 = 0.0
            set r5 = 0.0
            set r6 = 0.0
            set move = 0.0
            set check = 0
            if level < 1 then
                set level = 1
            endif
            if BazzBW_InvulGain then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            set g = CreateGroup()
            set g2 = CreateGroup()
            set a = GAngle(c, td)
            set aoe = BazzBW_DamageAoe
            set dmg = GetHeroAgi(c, true) * (BazzBW_DamageAgiBase + (BazzBW_DamageAgiStep * (level - 1)))
            set dmg = dmg + BazzBW_Damage2StaticBase + (BazzBW_Damage2StaticStep * (level - 1))
            set rmax = 2.0
            set e6 = AddSpecialEffectTarget("war3mapimported\\wos_1mt_huo1.mdx", c, "hand right")
            call SetUnitAnimationByIndex(c, 8)
            call SetUnitTimeScale(c, 0.25)
            call MakeSound("war3mapimported\\Hero_BazzB_W")
            if MUI_BazzBW == 0 then
                call BazzBTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct BazzBSpells_E
        private static integer array m_BazzBE
        private static integer MUI_BazzBE = -1

        unit c
        real x
        real y
        real scale
        group g
        real dmg
        real aoe
        real r
        real rmax

        public static method Loop_BazzBE takes nothing returns nothing
            local integer i = 0
            local thistype this
            local unit u
            local boolean remove

            loop
                exitwhen i > MUI_BazzBE
                set this = m_BazzBE[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or GetWidgetLife(c) <= 0.405 then
                    set remove = true
                elseif SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.05, 3)
                    call DebugUnit(c)
                    if r == 0.15 or r == 0.20 or r == 0.25 or r >= rmax then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdx", x, y, GetRandomReal(0.0, 359.0), 0.95, scale, 50.0))
                        set scale = scale + 0.85
                    endif

                    if r >= rmax then
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        call DecorRemove(c, x, y, aoe, BazzBE_DecorDamage)
                        call DebuffClear(c)
                        call VisionTimed(GetOwningPlayer(c), x, y, 1200.0, 3.0)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_opm (583).mdx", x, y, GetRandomReal(0.0, 359.0), 1.0, 1.05, 1.0))
                        call StopSpellUnit(c)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            call GroupRemoveUnit(g, u)
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                call dmgmag(c, u, dmg)
                                call MUE(u, BazzBE_PushRange, BazzBE_PushDuration, GAngle(c, u))
                            endif
                        endloop
                        set remove = true
                    endif
                else
                    set remove = true
                endif

                if remove then
                    if c != null and GetUnitTypeId(c) != 0 then
                        call StopSpellUnit(c)
                    endif
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    set g = null
                    set c = null
                    set u = null
                    set m_BazzBE[i] = m_BazzBE[MUI_BazzBE]
                    set MUI_BazzBE = MUI_BazzBE - 1
                    call deallocate(this)
                    if MUI_BazzBE == -1 then
                        call BazzBTimer05Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            set u = null
        endmethod

        public static method BazzBE_Start takes unit NewC returns nothing
            local thistype this
            local integer level = GetUnitAbilityLevel(NewC, BazzBE_ID)
            if NewC == null or GetUnitTypeId(NewC) == 0 or GetWidgetLife(NewC) <= 0.405 then
                return
            endif
            set this = thistype.create()
            set MUI_BazzBE = MUI_BazzBE + 1
            set m_BazzBE[MUI_BazzBE] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0.0
            set scale = 1.75
            if level < 1 then
                set level = 1
            endif
            call StartSpellUnit(c)
            set g = CreateGroup()
            set aoe = BazzBE_DamageAoe
            set dmg = GetHeroAgi(c, true) * (BazzBE_DamageAgiBase + (BazzBE_DamageAgiStep * (level - 1)))
            set rmax = BazzBE_CastTime
            call SetUnitTimeScale(c, 0.60)
            call SetUnitAnimationByIndex(c, 1)
            call MakeSound("war3mapimported\\Hero_BazzB_E")
            call MakeSound("war3mapimported\\Hero_BazzB_E2")
            if MUI_BazzBE == 0 then
                call BazzBTimer05Acquire()
            endif
        endmethod
    endstruct

    private struct BazzBSpells_R
        private static integer array m_BazzBR
        private static integer MUI_BazzBR = -1

        unit c
        unit td
        real x
        real y
        real x1
        real y1
        real r2
        group g
        real dmg
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax

        public static method Loop_BazzBR takes nothing returns nothing
            local integer i = 0
            local thistype this
            local unit u
            local integer k
            local boolean remove

            loop
                exitwhen i > MUI_BazzBR
                set this = m_BazzBR[i]
                set remove = false

                if c == null or td == null or GetUnitTypeId(c) == 0 or GetUnitTypeId(td) == 0 or GetWidgetLife(c) <= 0.405 then
                    set remove = true
                elseif SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit(c)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    set a = GAngle(c, td)
                    call SetUnitFacing(c, a * bj_RADTODEG)

                    if r == 0.03 then
                        set e = AddSpecialEffectTarget("war3mapImported\\wos_firacharge2.mdx", c, "hand right")
                        set move = 90.0
                    endif
                    if r == 0.60 then
                        call MakeSound("war3mapimported\\Hero_BazzB_R2")
                        call SetUnitTimeScale(c, 0.0)
                    endif
                    if r == 1.80 then
                        call SetUnitTimeScale(c, 0.35)
                    endif
                    if r > BazzBR_CastTime then
                        if SR2(c, td) < 190.0 then
                            set r = 99999.0
                        endif
                        set a = GAngle(c, td)
                        call MoveUnit(c, move, a)
                        if r2 >= 0.0 then
                            set r2 = 0.0
                            call EffectSpawn2("war3mapImported\\wos_BY_Wood_Effect_Order_MuZhiBenYing_Fir_Huo_DiMianss2.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0.0, 359.0), 2.0, 1.0, 0.0, 0.15)
                            call VisionTimed(GetOwningPlayer(c), x1, y1, 800.0, 1.0)
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    set remove = true
                endif

                if remove then
                    if r >= 99999.0 and td != null and GetWidgetLife(td) > 0.405 then
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        call DecorRemove(c, x, y, aoe, BazzBR_DecorDamage)
                        call StopSpellUnit(c)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            call GroupRemoveUnit(g, u)
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call dmgmag(c, u, dmg)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                call StunUnit(c, u, BazzBR_StunDuration)
                            endif
                        endloop

                        set k = 0
                        loop
                            exitwhen k == 8
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", x + 300.0 * Cos(k * 45.0 * bj_DEGTORAD), y + 300.0 * Sin(k * 45.0 * bj_DEGTORAD), k * 45.0 + 180.0, 1.0, 4.0, 1.0, 255, 255, 255, 75))
                            set k = k + 1
                        endloop

                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_opdef (1054).mdl", x, y, 1.0, 1.75, 1.9, 55.0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_Satsu-Hit-fire.mdl", x, y, 1.0, 2.0, 5.25, 1.0))
                        call DestroyEffect(EffectSpawnScale("war3mapImported\\wos_fantasybattle (1654)1.mdl", x, y, 1.0, 3.15, 0.1, 1.0, 0.21, 0.1, 1.1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_papsnaz (707).mdl", x, y, 1.0, 1.0, 1.2, 1.0))
                    endif

                    if c != null and GetUnitTypeId(c) != 0 then
                        call StopSpellUnit(c)
                        call SetUnitTimeScale(c, 1.0)
                    endif
                    if e != null then
                        call DestroyEffect(e)
                        set e = null
                    endif
                    if e2 != null then
                        call DestroyEffect(e2)
                        set e2 = null
                    endif
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    set g = null
                    set c = null
                    set td = null
                    set u = null
                    set m_BazzBR[i] = m_BazzBR[MUI_BazzBR]
                    set MUI_BazzBR = MUI_BazzBR - 1
                    call deallocate(this)
                    if MUI_BazzBR == -1 then
                        call BazzBTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            set u = null
        endmethod

        public static method BazzBR_Start takes unit NewC, unit NewTd returns nothing
            local thistype this
            local integer level = GetUnitAbilityLevel(NewC, BazzBR_ID)
            if NewC == null or NewTd == null or GetWidgetLife(NewTd) <= 0.405 then
                return
            endif
            set this = thistype.create()
            set MUI_BazzBR = MUI_BazzBR + 1
            set m_BazzBR[MUI_BazzBR] = this
            set c = NewC
            set td = NewTd
            set r = 0.0
            set r2 = 0.0
            set move = 0.0
            if level < 1 then
                set level = 1
            endif
            call StartSpellUnit(c)
            set g = CreateGroup()
            set a = GAngle(c, td)
            set aoe = BazzBR_DamageAoe
            set dmg = GetHeroAgi(c, true) * (BazzBR_DamageAgiBase + (BazzBR_DamageAgiStep * (level - 1)))
            set rmax = 6.0
            call SetUnitAnimationByIndex(c, 6)
            call SetUnitTimeScale(c, 0.25)
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_summon3missle.mdl", c, "hand right")
            call MakeSound("war3mapimported\\Hero_BazzB_R")
            if MUI_BazzBR == 0 then
                call BazzBTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct BazzBSpells_T
        private static integer array m_BazzBT
        private static integer MUI_BazzBT = -1

        unit c
        real x
        real y
        real x1
        real y1
        real r2
        real r3
        real r4
        real r5
        real r6
        real r7
        group g
        group g2
        real dmg
        integer check
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

        public static method Loop_BazzBT takes nothing returns nothing
            local integer i = 0
            local thistype this
            local unit u
            local boolean remove

            loop
                exitwhen i > MUI_BazzBT
                set this = m_BazzBT[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or GetWidgetLife(c) <= 0.405 then
                    set remove = true
                elseif SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit(c)

                    if r7 > 0.24 and r > 0.40 then
                        set r7 = 0.0
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0.0, 359.0), 0.95, 2.0, 10.0))
                    else
                        set r7 = r7 + 0.03
                    endif

                    if check == 0 then
                        if r == 0.39 or r == 0.75 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_chargeorange2.mdx", GetUnitX(c) + 10.0 * Cos(a), GetUnitY(c) + 10.0 * Sin(a), 14.0, 1.0, 4.0, 60.0))
                        endif
                        if r == 1.20 then
                            call SetUnitAnimationByIndex(c, 8)
                            call SetUnitTimeScale(c, 0.35)
                        endif
                        if r >= BazzBT_CastTime then
                            set check = 1
                            set move = 200.0
                            set r5 = 0.0
                            call MakeSound("war3mapimported\\Hero_BazzB_T2")
                            set e = EffectSpawn3("war3mapImported\\wos_1huo_92_01.mdl", GetUnitX(c) - 110.0 * Cos(a), GetUnitY(c) - 110.0 * Sin(a), a * bj_RADTODEG - 180.0, 1.0, 7.5, 135.0, -90.0)
                            set e3 = EffectSpawn3("war3mapImported\\wos_1huo_92_01.mdl", GetUnitX(c) + 880.0 * Cos(a), GetUnitY(c) + 880.0 * Sin(a), a * bj_RADTODEG - 180.0, 1.0, 6.0, 135.0, -90.0)
                            set e4 = EffectSpawn3("war3mapImported\\wos_1huo_92_01.mdl", GetUnitX(c) + 1680.0 * Cos(a), GetUnitY(c) + 1680.0 * Sin(a), a * bj_RADTODEG - 180.0, 1.0, 6.0, 135.0, -90.0)
                            set e2 = EffectSpawnColor3("war3mapImported\\wos_BY_Wood_Eff_Wid_XuanFeng.mdl", GetUnitX(c) - 320.0 * Cos(a), GetUnitY(c) - 320.0 * Sin(a), a * bj_RADTODEG - 180.0, 1.0, 22.0, 235.0, -90.0, 255, 125, 0, 255)
                            set e5 = EffectSpawnColor3("war3mapImported\\wos_BY_Wood_Eff_Wid_XuanFeng.mdl", GetUnitX(c) + 220.0 * Cos(a), GetUnitY(c) + 220.0 * Sin(a), a * bj_RADTODEG - 180.0, 1.0, 22.0, 235.0, -90.0, 255, 125, 0, 255)
                            set rmax = BazzBT_Duration
                            if e6 != null then
                                call DestroyEffect(e6)
                                set e6 = null
                            endif
                            set r = 0.0
                            set x1 = GetUnitX(c) + 150.0 * Cos(a)
                            set y1 = GetUnitY(c) + 150.0 * Sin(a)
                        endif
                    elseif check == 1 then
                        if r4 > 0.24 then
                            set r4 = 0.0
                            set x1 = GetUnitX(c) + 150.0 * Cos(a)
                            set y1 = GetUnitY(c) + 150.0 * Sin(a)
                        else
                            set r4 = r4 + 0.03
                        endif
                        set r5 = r5 + move
                        set x1 = x1 + move * Cos(a)
                        set y1 = y1 + move * Sin(a)

                        if r6 >= 0.0 then
                            set r6 = 0.0
                            call DecorRemove(c, x1, y1, aoe, BazzBT_DecorDamage)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x1, y1, aoe, Condition(function NoDecor_Filter))
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                call GroupRemoveUnit(g, u)
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                    call dmgmag(c, u, dmg)
                                    call MUE(u, BazzBT_Push, BazzBT_PushDuration, a)
                                    if BazzBT_StunDuration > 0.0 then
                                        call StunUnit(c, u, BazzBT_StunDuration)
                                    endif
                                    call GroupAddUnit(g2, u)
                                endif
                            endloop
                        else
                            set r6 = r6 + 0.03
                        endif

                        if r2 >= 0.0 then
                            set r2 = 0.0
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_firefly-rq-sfx2.mdl", x1, y1, GetRandomReal(0.0, 359.0), GetRandomReal(1.0, 2.0), 2.5, 105.0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_opdef (652).mdl", x1, y1, GetRandomReal(0.0, 359.0), 2.0, 1.0, 150.0))
                            call VisionTimed(GetOwningPlayer(c), x1, y1, 1200.0, 1.0)
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    set remove = true
                endif

                if remove then
                    if c != null and GetUnitTypeId(c) != 0 then
                        call StopSpellUnit(c)
                        call SetUnitTimeScale(c, 1.0)
                    endif
                    if e != null then
                        call DestroyEffect(e)
                        set e = null
                    endif
                    if e2 != null then
                        call DestroyEffect(e2)
                        set e2 = null
                    endif
                    if e3 != null then
                        call DestroyEffect(e3)
                        set e3 = null
                    endif
                    if e4 != null then
                        call DestroyEffect(e4)
                        set e4 = null
                    endif
                    if e5 != null then
                        call DestroyEffect(e5)
                        set e5 = null
                    endif
                    if e6 != null then
                        call DestroyEffect(e6)
                        set e6 = null
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
                    set u = null
                    set m_BazzBT[i] = m_BazzBT[MUI_BazzBT]
                    set MUI_BazzBT = MUI_BazzBT - 1
                    call deallocate(this)
                    if MUI_BazzBT == -1 then
                        call BazzBTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            set u = null
        endmethod

        public static method BazzBT_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this
            if NewC == null or GetUnitTypeId(NewC) == 0 or GetWidgetLife(NewC) <= 0.405 then
                return
            endif
            set this = thistype.create()
            set MUI_BazzBT = MUI_BazzBT + 1
            set m_BazzBT[MUI_BazzBT] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.0
            set r2 = 0.0
            set r3 = 0.0
            set r4 = 0.0
            set r5 = 0.0
            set r6 = 0.0
            set r7 = 0.0
            set check = 0
            call StartSpellUnit(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set a = GAngle2(c, x, y)
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_HakkeStart.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0.0, 359.0), 0.3, 1.45, 7.0))
            set e6 = AddSpecialEffectTarget("war3mapImported\\wos_firacharge2.mdx", c, "hand right")
            set aoe = BazzBT_DamageAoe
            set dmg = GetHeroAgi(c, true) * BazzBT_DamageAgiBase
            set rmax = 3.0
            call MyRemoveEff(AddSpecialEffectTarget("war3mapImported\\wos_summon3missle.mdl", c, "hand right"), 1.41)
            call MyRemoveEff(AddSpecialEffectTarget("war3mapImported\\wos_summon3missle.mdl", c, "hand left"), 1.41)
            call SetUnitAnimationByIndex(c, 3)
            call SetUnitTimeScale(c, 0.65)
            call MakeSound("war3mapimported\\Hero_BazzB_T")
            if MUI_BazzBT == 0 then
                call BazzBTimer03Acquire()
            endif
        endmethod
    endstruct

    private function BazzBTimer03Loop takes nothing returns nothing
        call BazzBSpells_Q.Loop_BazzBQ()
        call BazzBSpells_W.Loop_BazzBW()
        call BazzBSpells_R.Loop_BazzBR()
        call BazzBSpells_T.Loop_BazzBT()
    endfunction

    private function BazzBTimer05Loop takes nothing returns nothing
        call BazzBSpells_E.Loop_BazzBE()
    endfunction

    private function InitBazzBSpells takes nothing returns nothing
        set BazzBTimer03 = CreateTimer()
        set BazzBTimer03Callback = function BazzBTimer03Loop
        set BazzBTimer05 = CreateTimer()
        set BazzBTimer05Callback = function BazzBTimer05Loop
    endfunction

    function BazzBQ_Start takes unit c, real x, real y returns nothing
        call BazzBSpells_Q.BazzBQ_Start(c, x, y)
        call BazzBPass_Start(c, BazzBQ_ID)
    endfunction

    function BazzBW_Start takes unit c, unit td returns nothing
        call BazzBSpells_W.BazzBW_Start(c, td)
        call BazzBPass_Start(c, BazzBW_ID)
    endfunction

    function BazzBE_Start takes unit c returns nothing
        call BazzBSpells_E.BazzBE_Start(c)
        call BazzBPass_Start(c, BazzBE_ID)
    endfunction

    function BazzBR_Start takes unit c, unit td returns nothing
        call BazzBSpells_R.BazzBR_Start(c, td)
        call BazzBPass_Start(c, BazzBR_ID)
    endfunction

    function BazzBT_Start takes unit c, real x, real y returns nothing
        call BazzBSpells_T.BazzBT_Start(c, x, y)
        call BazzBPass_Start(c, BazzBT_ID)
    endfunction
endlibrary