library AkainuSpells initializer InitAkainuSpells uses GearSystems
    globals
        private timer AkainuTimer03
        private code AkainuTimer03Callback
        private integer AkainuTimer03Users = 0

//--------------------------------------Akainu Core---------------------------------------------------------
        integer Akainu_ID = 'H01A'

//---------------Q ability (Hellhound Dash)------------------------------------
        integer AkainuQ_ID = 'A06V'
        real AkainuQ_DamageAgiBase = 1.00
        real AkainuQ_DamageAgiStep = 1.001
        real AkainuQ_Damage2StaticBase = 175.00
        real AkainuQ_Damage2StaticStep = 0.00
        real AkainuQ_DamageAoe = 110.00
        real AkainuQ_Stun = 1.00
        real AkainuQ_PushRange = 100.00
        real AkainuQ_PushDuration = 0.21
        real AkainuQ_Move = 75.00
        real AkainuQ_MaxDuration = 2.10
        real AkainuQ_CastTime = 0.54
        boolean AkainuQ_IsInvul = false
        real AkainuQ_DecorDamage = 25.00

//---------------W ability (Magma Punch Barrage)-------------------------------
        integer AkainuW_ID = 'A06W'
        integer AkainuW_Fists = 5
        real AkainuW_DamageAgiBase = 1.00
        real AkainuW_DamageAgiStep = 1.00
        real AkainuW_Damage2StaticBase = 200.00
        real AkainuW_Damage2StaticStep = 0.00
        real AkainuW_DamageAoe = 700.00
        real AkainuW_DamageAoePunch = 525.00
        integer AkainuW_Slow = 20
        integer AkainuW_Duration = 1
        real AkainuW_MaxDuration = 2.10
        real AkainuW_CastTime = 0.15
        boolean AkainuW_IsInvul = false
        real AkainuW_DecorFlightDamage = 20.00
        real AkainuW_DecorImpactDamage = 50.00

//---------------E ability (Dark Dog / Meigo)----------------------------------
        integer AkainuE_ID = 'A06X'
        real AkainuE_DamageAgiBase = 2.00
        real AkainuE_DamageAgiStep = 1.00
        real AkainuE_DamageAoe = 575.00
        real AkainuE_Move = 75.00
        real AkainuE_MaxDuration = 2.40
        real AkainuE_CastTime = 0.60
        boolean AkainuE_IsInvul = true
        real AkainuE_DecorDamage = 50.00

//---------------R ability (Dai Funka - Great Eruption)------------------------
        integer AkainuR_ID = 'A06Y'
        real AkainuR_DamageAgiBase = 5.00
        real AkainuR_DamageAgiStep = 1.00
        real AkainuR_DamageAoe = 480.00
        real AkainuR_Stun = 1.50
        real AkainuR_PushRange = 600.00
        real AkainuR_PushDuration = 0.30
        real AkainuR_Move = 165.00
        real AkainuR_MaxDuration = 0.99
        real AkainuR_CastTime = 0.72
        boolean AkainuR_IsInvul = true
        real AkainuR_DecorDamage = 100.00

//---------------T ability (Ryusei Kazan - Meteor Volcano)---------------------
        integer AkainuT_ID = 'A06Z'
        integer AkainuT_Fists = 30
        real AkainuT_DamageAgiBase = 1.20
        real AkainuT_DamageAoe = 2000.00
        real AkainuT_DamageAoePunch = 700.00
        integer AkainuT_Slow = 50
        integer AkainuT_Duration = 2
        real AkainuT_MaxDuration = 25.00
        real AkainuT_CastTime = 1.80
        boolean AkainuT_IsInvul = true
        real AkainuT_DecorDamage = 100.00

//---------------F ability (Passive: Magma Body / Active Proc)-----------------
        integer AkainuF_ID = 'A070'
        real AkainuF_DamagePhysResist = 15.00
        real AkainuF_Damage = 2.00
        real AkainuF_CD = 5.00
    endglobals

    //===========================================================================
    // Централизованный менеджер таймера
    //===========================================================================
    private function AkainuTimer03Acquire takes nothing returns nothing
        set AkainuTimer03Users = AkainuTimer03Users + 1
        if AkainuTimer03Users == 1 then
            call TimerStart(AkainuTimer03, 0.03, true, AkainuTimer03Callback)
        endif
    endfunction

    private function AkainuTimer03Release takes nothing returns nothing
        set AkainuTimer03Users = AkainuTimer03Users - 1
        if AkainuTimer03Users <= 0 then
            set AkainuTimer03Users = 0
            call PauseTimer(AkainuTimer03)
        endif
    endfunction

    //===========================================================================
    // Прок пассивной способности F (Lv. 35)
    //===========================================================================
    function AkainuF_Start takes unit c, unit td returns nothing
        if BlzGetUnitAbilityCooldownRemaining(c, FakeAbi_ID) == 0 or GetUnitAbilityLevel(c, FakeAbi_ID) == 0 then
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_GZ_jntxn (11)_R1-200.mdl", GetUnitX(td), GetUnitY(td), 1, 1, 2, 1))
            call NextDmg(c, td, AkainuF_Damage * GetHeroAgi(c, true), 1, 0.03)
            call FakeCD_Start(c, AkainuF_ID, AkainuF_CD, 0, 0)
        endif
    endfunction

    //===========================================================================
    // Q Способность
    //===========================================================================
    private struct AkainuSpells_Q
        private static integer array m_AkainuQ
        private static integer MUI_AkainuQ = -1

        unit c
        unit td
        real x
        real y
        real r2
        group g
        unit u
        real dmg
        real aoe
        real move
        real r
        effect e
        real a
        real rmax

        public static method Loop_AkainuQ takes nothing returns nothing
            local integer i = 0
            local thistype this
            local boolean remove

            loop
                exitwhen i > MUI_AkainuQ
                set this = m_AkainuQ[i]
                set remove = false

                if c == null or td == null or GetUnitTypeId(c) == 0 or GetUnitTypeId(td) == 0 or GetWidgetLife(c) <= 0.405 or GetWidgetLife(td) <= 0.405 or not SpellBoolCaster(c) or not SpellBoolCaster(td) or r > rmax then
                    set remove = true
                else
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit2(c)

                    if r == 0.51 then
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, 1, 255, 255, 255, 255))
                    endif

                    if r > AkainuQ_CastTime then
                        if SR2(c, td) > 120.00 then
                            set a = GAngle(c, td)
                            call MoveUnit2(c, move, a)
                            call SetUnitFacing(c, a * bj_RADTODEG)
                            if r2 > 0.06 then
                                set r2 = 0.00
                                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, 1, 255, 255, 255, 255))
                            else
                                set r2 = r2 + 0.03
                            endif
                        else
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            set r = 99999.00
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_opbr0326 (347).mdl", x, y, 1, 1.00, 1, 1))
                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_FSAeff (198)1.mdl", td, "chest"))
                            call StunUnit(c, td, AkainuQ_Stun)
                            call MakeSound("war3mapimported\\Hero_Akainu_Q2")
                            call DecorRemove(c, x, y, aoe, AkainuQ_DecorDamage)
                            call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                    call dmgphys(c, u, dmg)
                                    if GetUnitTypeId(c) == Akainu_ID and GetHeroLevel(c) >= 35 then
                                        call AkainuF_Start(c, u)
                                    endif
                                    call MUE(u, AkainuQ_PushRange, AkainuQ_PushDuration, a)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        endif
                    endif
                endif

                if remove then
                    if c != null and GetUnitTypeId(c) != 0 then
                        call StopSpellUnit2(c)
                        call SetUnitTimeScale(c, 1.00)
                    endif
                    if e != null then
                        call DestroyEffect(e)
                    endif
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    set g = null
                    set c = null
                    set td = null
                    set e = null
                    set u = null
                    set m_AkainuQ[i] = m_AkainuQ[MUI_AkainuQ]
                    set MUI_AkainuQ = MUI_AkainuQ - 1
                    call deallocate(this)
                    if MUI_AkainuQ == -1 then
                        call AkainuTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
        endmethod

        public static method AkainuQ_Start takes unit NewC, unit NewTd returns nothing
            local thistype this
            local integer lvl

            if NewC == null or NewTd == null or GetWidgetLife(NewTd) <= 0.405 then
                return
            endif

            set this = thistype.create()
            set MUI_AkainuQ = MUI_AkainuQ + 1
            set m_AkainuQ[MUI_AkainuQ] = this
            set c = NewC
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r = 0.00
            set r2 = 0.00
            set move = AkainuQ_Move
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set a = GAngle2(c, x, y)
            set aoe = AkainuQ_DamageAoe

            set lvl = GetUnitAbilityLevel(c, AkainuQ_ID)
            if lvl < 1 then
                set lvl = 1
            endif

            set dmg = GetHeroAgi(c, true) * (AkainuQ_DamageAgiBase + AkainuQ_DamageAgiStep * (lvl - 1))
            set dmg = dmg + AkainuQ_Damage2StaticBase + AkainuQ_Damage2StaticStep * (lvl - 1)
            set rmax = AkainuQ_MaxDuration

            call SetUnitAnimationByIndex(c, 9)
            call SetUnitTimeScale(c, 0.40)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_magmahandBig-91F172.mdl", c, "hand right")
            call MakeSound("war3mapimported\\Hero_Akainu_Q")

            if MUI_AkainuQ == 0 then
                call AkainuTimer03Acquire()
            endif
        endmethod
    endstruct

    //===========================================================================
    // W2 Снаряд Кулака
    //===========================================================================
    private struct AkainuSpells_W2
        private static integer array m_AkainuW2
        private static integer MUI_AkainuW2 = -1

        unit c
        real x
        real y
        group g
        unit u
        real dmg
        real aoe
        real move
        real r
        effect e
        real a
        real rmax

        public static method Loop_AkainuW2 takes nothing returns nothing
            local integer i = 0
            local thistype this
            local boolean remove

            loop
                exitwhen i > MUI_AkainuW2
                set this = m_AkainuW2[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or not SpellBoolCaster(c) or r > rmax then
                    set remove = true
                else
                    set r = RoundReal(r + 0.03, 3)
                    call MoveEff(e, move, a)
                    call VisionTimed(GetOwningPlayer(c), GetEffX(e), GetEffY(e), aoe, 1.00)
                    call DecorRemove(c, GetEffX(e), GetEffY(e), aoe, AkainuW_DecorFlightDamage)
                endif

                if remove then
                    set x = GetEffX(e)
                    set y = GetEffY(e)
                    call MakeSound("war3mapimported\\Hero_Akainu_W2")
                    call DecorRemove(c, x, y, aoe, AkainuW_DecorImpactDamage)
                    call VisionTimed(GetOwningPlayer(c), x, y, aoe, 2.00)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_opbr0326 (347).mdl", x, y, 1, 1.00, 1, 1))

                    if g != null then
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call dmgmag(c, u, dmg)
                                call SlowUnit(c, u, AkainuW_Slow, AkainuW_Duration)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        call DestroyGroup(g)
                    endif

                    if e != null then
                        call DestroyEffect(e)
                    endif
                    set g = null
                    set c = null
                    set e = null
                    set u = null
                    set m_AkainuW2[i] = m_AkainuW2[MUI_AkainuW2]
                    set MUI_AkainuW2 = MUI_AkainuW2 - 1
                    call deallocate(this)
                    if MUI_AkainuW2 == -1 then
                        call AkainuTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
        endmethod

        public static method AkainuW2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            local integer lvl

            set MUI_AkainuW2 = MUI_AkainuW2 + 1
            set m_AkainuW2[MUI_AkainuW2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.00
            set g = CreateGroup()
            set u = null
            set a = GAngle2(c, x, y)
            set aoe = AkainuW_DamageAoePunch

            set lvl = GetUnitAbilityLevel(c, AkainuW_ID)
            if lvl < 1 then
                set lvl = 1
            endif

            set dmg = GetHeroAgi(c, true) * (AkainuW_DamageAgiBase + AkainuW_DamageAgiStep * (lvl - 1))
            set dmg = dmg + AkainuW_Damage2StaticBase + AkainuW_Damage2StaticStep * (lvl - 1)
            set dmg = dmg / I2R(AkainuW_Fists)
            set rmax = 0.27
            set e = EffectSpawn("war3mapImported\\wos_magmahandBig-91F17.mdl", GetUnitX(c) + 110.00 * Cos(a), GetUnitY(c) + 110.00 * Sin(a), a * bj_RADTODEG, 1, 1.25, 110.00)
            set move = SR5(e, x, y) / 9.00

            if MUI_AkainuW2 == 0 then
                call AkainuTimer03Acquire()
            endif
        endmethod
    endstruct

    //===========================================================================
    // W Способность
    //===========================================================================
    private struct AkainuSpells_W
        private static integer array m_AkainuW
        private static integer MUI_AkainuW = -1

        unit c
        real x
        real y
        real x1
        real y1
        real r2
        real r3
        integer check
        real aoe
        real r
        effect e
        effect e2
        real rmax

        public static method Loop_AkainuW takes nothing returns nothing
            local integer i = 0
            local thistype this
            local real rr1 = 0.00
            local real rr2 = 0.00
            local boolean remove

            loop
                exitwhen i > MUI_AkainuW
                set this = m_AkainuW[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or GetWidgetLife(c) <= 0.405 or not SpellBoolCaster(c) or r > rmax or check >= AkainuW_Fists then
                    set remove = true
                else
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit2(c)

                    if r == 0.15 then
                        call MakeSound("war3mapimported\\Hero_Akainu_W")
                        call SetUnitAnimationByIndex(c, 0)
                        call SetUnitTimeScale(c, 1.50)
                    endif

                    if r > AkainuW_CastTime then
                        if r3 > 0.30 then
                            set r3 = 0.03
                            call SetUnitAnimationByIndex(c, 0)
                        else
                            set r3 = r3 + 0.03
                        endif

                        if r2 > 0.15 then
                            set r2 = 0.03
                            set rr1 = GetRandomReal(150.00, 375.00)
                            set rr2 = GetRandomReal(0.00, 359.00) * bj_DEGTORAD
                            set x1 = x + rr1 * Cos(rr2)
                            set y1 = y + rr1 * Sin(rr2)
                            call AkainuSpells_W2.AkainuW2_Start(c, x1, y1)
                            set check = check + 1
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                endif

                if remove then
                    if c != null and GetUnitTypeId(c) != 0 then
                        call StopSpellUnit2(c)
                        call SetUnitTimeScale(c, 1.00)
                    endif
                    if e != null then
                        call DestroyEffect(e)
                    endif
                    if e2 != null then
                        call DestroyEffect(e2)
                    endif
                    set c = null
                    set e = null
                    set e2 = null
                    set m_AkainuW[i] = m_AkainuW[MUI_AkainuW]
                    set MUI_AkainuW = MUI_AkainuW - 1
                    call deallocate(this)
                    if MUI_AkainuW == -1 then
                        call AkainuTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
        endmethod

        public static method AkainuW_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()

            set MUI_AkainuW = MUI_AkainuW + 1
            set m_AkainuW[MUI_AkainuW] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.00
            set r3 = 0.00
            set check = 0
            set r2 = 10.00
            call StartSpellUnit2(c)
            set aoe = AkainuW_DamageAoe
            set rmax = AkainuW_MaxDuration

            call SetUnitAnimationByIndex(c, 7)
            call SetUnitTimeScale(c, 0.50)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_magmahandBig-91F172.mdl", c, "hand right")
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_magmahandBig-91F172.mdl", c, "hand left")
            call MakeSound("war3mapimported\\Hero_Akainu_W3")

            if MUI_AkainuW == 0 then
                call AkainuTimer03Acquire()
            endif
        endmethod
    endstruct

    //===========================================================================
    // E Способность
    //===========================================================================
    private struct AkainuSpells_E
        private static integer array m_AkainuE
        private static integer MUI_AkainuE = -1

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
        real a
        real rmax

        public static method Loop_AkainuE takes nothing returns nothing
            local integer i = 0
            local thistype this
            local boolean remove

            loop
                exitwhen i > MUI_AkainuE
                set this = m_AkainuE[i]
                set remove = false

                if c == null or td == null or GetUnitTypeId(c) == 0 or GetUnitTypeId(td) == 0 or GetWidgetLife(c) <= 0.405 or GetWidgetLife(td) <= 0.405 or not SpellBoolCaster(c) or not SpellBoolCaster(td) or r > rmax then
                    set remove = true
                else
                    set r = RoundReal(r + 0.03, 3)
                    if r < AkainuE_CastTime then
                        call DebugUnit(c)
                    endif

                    if r == 0.30 then
                        set e = AddSpecialEffectTarget("war3mapImported\\wos_magmahandBig-91F172.mdl", c, "hand right")
                        set e2 = AddSpecialEffectTarget("war3mapImported\\wos_magmahandBig-91F172.mdl", c, "hand left")
                    endif

                    if r == AkainuE_CastTime then
                        set e3 = EffectSpawn("war3mapImported\\wos_opbr0326 (762).mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 0.60, 0)
                        call MakeSound("war3mapimported\\Hero_Akainu_E2")
                        call StopSpellUnit(c)
                        if e != null then
                            call DestroyEffect(e)
                            set e = null
                        endif
                        if e2 != null then
                            call DestroyEffect(e2)
                            set e2 = null
                        endif
                    endif

                    if r > AkainuE_CastTime then
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        set a = GAngle5(e3, x, y)
                        if SR5(e3, x, y) > 350.00 then
                            if r2 > 0.03 then
                                set r2 = 0.00
                                call VisionTimed(GetOwningPlayer(c), GetEffX(e3), GetEffY(e3), aoe, 1.00)
                                call DecorRemove(c, GetEffX(e3), GetEffY(e3), aoe, AkainuE_DecorDamage)
                                call GroupClear(g)
                                call GroupEnumUnitsInRange(g, GetEffX(e3), GetEffY(e3), aoe, Condition(function NoDecor_Filter))
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                        call dmgmag(c, u, dmg)
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
                            call MoveEff(e3, move, a)
                        else
                            set r = 9999.00
                        endif
                    endif
                endif

                if remove then
                    call StopSpellUnit(c)
                    if r < AkainuE_CastTime then
                        call StopSpellUnit2(c)
                        if e != null then
                            call DestroyEffect(e)
                        endif
                        if e2 != null then
                            call DestroyEffect(e2)
                        endif
                    endif

                    if r >= AkainuE_CastTime and e3 != null then
                        if r == 9999.00 and td != null then
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                        else
                            set x = GetEffX(e3) + 300.00 * Cos(a)
                            set y = GetEffY(e3) + 300.00 * Sin(a)
                        endif
                        call VisionTimed(GetOwningPlayer(c), x, y, aoe, 1.00)
                        call DecorRemove(c, x, y, aoe, AkainuE_DecorDamage)
                        call BlzSetSpecialEffectTimeScale(e3, 5.00)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_opbr0326 (344).mdl", x, y, 1, 2.00, 1, 1))
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                call dmgmag(c, u, dmg)
                                call GroupAddUnit(g2, u)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                        call DestroyEffect(e3)
                    endif

                    if c != null and GetUnitTypeId(c) != 0 then
                        call SetUnitTimeScale(c, 1.00)
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
                    set td = null
                    set u = null
                    set m_AkainuE[i] = m_AkainuE[MUI_AkainuE]
                    set MUI_AkainuE = MUI_AkainuE - 1
                    call deallocate(this)
                    if MUI_AkainuE == -1 then
                        call AkainuTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
        endmethod

        public static method AkainuE_Start takes unit NewC, unit NewTd returns nothing
            local thistype this
            local integer lvl

            if NewC == null or NewTd == null or GetWidgetLife(NewTd) <= 0.405 then
                return
            endif

            set this = thistype.create()
            set MUI_AkainuE = MUI_AkainuE + 1
            set m_AkainuE[MUI_AkainuE] = this
            set c = NewC
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r = 0.00
            set r2 = 0.00
            set move = AkainuE_Move
            call StartSpellUnit(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2(c, x, y)
            set aoe = AkainuE_DamageAoe

            set lvl = GetUnitAbilityLevel(c, AkainuE_ID)
            if lvl < 1 then
                set lvl = 1
            endif

            set dmg = GetHeroAgi(c, true) * (AkainuE_DamageAgiBase + AkainuE_DamageAgiStep * (lvl - 1))
            set rmax = AkainuE_MaxDuration

            call SetUnitAnimationByIndex(c, 2)
            call SetUnitTimeScale(c, 1.00)
            call MakeSound("war3mapimported\\Hero_Akainu_E")
            call MakeSound("war3mapimported\\Hero_Akainu_E3")

            if MUI_AkainuE == 0 then
                call AkainuTimer03Acquire()
            endif
        endmethod
    endstruct
    //===========================================================================
    // R Способность
    //===========================================================================
    private struct AkainuSpells_R
        private static integer array m_AkainuR
        private static integer MUI_AkainuR = -1

        unit c
        real x
        real y
        real r2
        real r5
        group g
        group g2
        unit u
        real dmg
        real aoe
        real move
        real r
        effect e
        real a
        real rmax

        public static method Loop_AkainuR takes nothing returns nothing
            local integer i = 0
            local thistype this
            local boolean remove

            loop
                exitwhen i > MUI_AkainuR
                set this = m_AkainuR[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or GetWidgetLife(c) <= 0.405 or not SpellBoolCaster(c) or r > rmax then
                    set remove = true
                else
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit(c)

                    if r == AkainuR_CastTime then
                        call MakeSound("war3mapimported\\Hero_Akainu_R2")
                        set x = GetUnitX(c) + 150.00 * Cos(a)
                        set y = GetUnitY(c) + 150.00 * Sin(a)
                        set r5 = 0.20
                        call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_obr08 (24).mdl", GetUnitX(c) + 110.00 * Cos(a + 25.00 * bj_DEGTORAD), GetUnitY(c) + 110.00 * Sin(a + 25.00 * bj_DEGTORAD), a * bj_RADTODEG, 0.90, 1.62, 116.00), 0.56, 255, 255, 255, 0.30)
                    endif

                    if r > AkainuR_CastTime then
                        set x = x + move * Cos(a)
                        set y = y + move * Sin(a)
                        call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_opbr0326 (40).mdl", x, y, a * bj_RADTODEG, 2, r5, 1), 0, 255, 255, 255, 0.60)

                        if r2 > 0.03 then
                            set r5 = r5 + 0.16
                            set r2 = 0.00
                            call DecorRemove(c, x, y, aoe, AkainuR_DecorDamage)
                            call VisionTimed(GetOwningPlayer(c), x, y, aoe + 400.00, 2.00)

                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                    call dmgphys(c, u, dmg)
                                    call GroupAddUnit(g2, u)
                                    if GetUnitTypeId(c) == Akainu_ID and GetHeroLevel(c) >= 35 then
                                        call AkainuF_Start(c, u)
                                    endif
                                    call StunUnit(c, u, AkainuR_Stun)
                                    call MUE(u, AkainuR_PushRange, AkainuR_PushDuration, a)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                endif

                if remove then
                    if e != null then
                        call DestroyEffect(e)
                    endif
                    if c != null and GetUnitTypeId(c) != 0 then
                        call StopSpellUnit(c)
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
                    set u = null
                    set m_AkainuR[i] = m_AkainuR[MUI_AkainuR]
                    set MUI_AkainuR = MUI_AkainuR - 1
                    call deallocate(this)
                    if MUI_AkainuR == -1 then
                        call AkainuTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
        endmethod

        public static method AkainuR_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            local integer lvl

            set MUI_AkainuR = MUI_AkainuR + 1
            set m_AkainuR[MUI_AkainuR] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.00
            set r2 = 50.00
            set move = AkainuR_Move
            call StartSpellUnit(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2(c, x, y)
            set aoe = AkainuR_DamageAoe

            set lvl = GetUnitAbilityLevel(c, AkainuR_ID)
            if lvl < 1 then
                set lvl = 1
            endif

            set dmg = GetHeroAgi(c, true) * (AkainuR_DamageAgiBase + AkainuR_DamageAgiStep * (lvl - 1))
            set rmax = AkainuR_MaxDuration

            call SetUnitAnimationByIndex(c, 4)
            call SetUnitTimeScale(c, 1.00)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_magmahandBig-91F172.mdl", c, "hand right")
            call MakeSound("war3mapimported\\Hero_Akainu_R")

            if MUI_AkainuR == 0 then
                call AkainuTimer03Acquire()
            endif
        endmethod
    endstruct

    //===========================================================================
    // T2 Снаряд Метеорита
    //===========================================================================
    private struct AkainuSpells_T2
        private static integer array m_AkainuT2
        private static integer MUI_AkainuT2 = -1

        unit c
        real x
        real y
        group g
        unit u
        real dmg
        real aoe
        real r
        effect e
        real a
        real rmax

        public static method Loop_AkainuT2 takes nothing returns nothing
            local integer i = 0
            local thistype this
            local boolean remove

            loop
                exitwhen i > MUI_AkainuT2
                set this = m_AkainuT2[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or not SpellBoolCaster(c) or r > rmax then
                    set remove = true
                else
                    set r = RoundReal(r + 0.03, 3)
                endif

                if remove then
                    set x = GetEffX(e)
                    set y = GetEffY(e)
                    call DecorRemove(c, x, y, aoe, AkainuT_DecorDamage)
                    if GetRandomInt(1, 2) == 2 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_opbr0326 (347).mdl", x, y, 1, 1.00, 1, 1))
                    endif

                    if g != null then
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call dmgmag(c, u, dmg)
                                call SlowUnit(c, u, AkainuT_Slow, AkainuT_Duration)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        call DestroyGroup(g)
                    endif

                    if e != null then
                        call DestroyEffect(e)
                    endif
                    set g = null
                    set c = null
                    set e = null
                    set u = null
                    set m_AkainuT2[i] = m_AkainuT2[MUI_AkainuT2]
                    set MUI_AkainuT2 = MUI_AkainuT2 - 1
                    call deallocate(this)
                    if MUI_AkainuT2 == -1 then
                        call AkainuTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
        endmethod

        public static method AkainuT2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()

            set MUI_AkainuT2 = MUI_AkainuT2 + 1
            set m_AkainuT2[MUI_AkainuT2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.00
            set g = CreateGroup()
            set u = null
            set a = GAngle2(c, x, y)
            set aoe = AkainuT_DamageAoePunch
            set dmg = GetHeroAgi(c, true) * AkainuT_DamageAgiBase
            set rmax = 0.39
            set e = EffectSpawn("war3mapImported\\wos_OP (114).mdl", x, y, a * bj_RADTODEG, 1, 0.50, 1)

            if MUI_AkainuT2 == 0 then
                call AkainuTimer03Acquire()
            endif
        endmethod
    endstruct

    //===========================================================================
    // T Способность
    //===========================================================================
    private struct AkainuSpells_T
        private static integer array m_AkainuT
        private static integer MUI_AkainuT = -1

        unit c
        real x
        real y
        real x1
        real y1
        real r2
        real r3
        integer check
        real aoe
        real r
        effect e
        effect e2
        effect e3
        real a
        real rmax

        public static method Loop_AkainuT takes nothing returns nothing
            local integer i = 0
            local thistype this
            local real rr1 = 0.00
            local real rr2 = 0.00
            local boolean remove

            loop
                exitwhen i > MUI_AkainuT
                set this = m_AkainuT[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or (not SpellBoolCaster(c) and r <= 3.00) or r > rmax or check >= AkainuT_Fists then
                    set remove = true
                else
                    set r = RoundReal(r + 0.03, 3)

                    if r == 1.65 then
                        call SetUnitTimeScale(c, 0.15)
                        call MakeSound("war3mapimported\\Hero_Akainu_T2")
                    endif

                    if r > 1.32 and r < 1.80 then
                        if r3 > 0.09 then
                            set r3 = 0.00
                            set e3 = EffectSpawn3("war3mapImported\\wos_OP (114).mdl", (GetUnitX(c) + 300.00 * Cos(a)) + 85.00 * Cos(a + 60.00 * bj_DEGTORAD), (GetUnitY(c) + 300.00 * Sin(a)) + 85.00 * Sin(a + 60.00 * bj_DEGTORAD), a * bj_RADTODEG + 180.00, 1, 0.25, 800.00, -205.00)
                            call EMUE(e3, 900.00, 0.12, a)
                            call EHeightSet(e3, 0.12, 1800.00)
                            call MyRemoveEff(e3, 0.45)
                            set e3 = null

                            set e3 = EffectSpawn3("war3mapImported\\wos_OP (114).mdl", (GetUnitX(c) + 300.00 * Cos(a)) + 85.00 * Cos(a - 60.00 * bj_DEGTORAD), (GetUnitY(c) + 300.00 * Sin(a)) + 85.00 * Sin(a - 60.00 * bj_DEGTORAD), a * bj_RADTODEG + 180.00, 1, 0.25, 800.00, -205.00)
                            call EMUE(e3, 900.00, 0.12, a)
                            call EHeightSet(e3, 0.12, 1800.00)
                            call MyRemoveEff(e3, 0.45)
                            set e3 = null
                        else
                            set r3 = r3 + 0.03
                        endif
                    endif

                    if r < AkainuT_CastTime then
                        call DebugUnit(c)
                    endif

                    if r == AkainuT_CastTime then
                        call VisionTimed(GetOwningPlayer(c), x, y, aoe + 600.00, 4.50)
                        call StopSpellUnit(c)
                        if e != null then
                            call DestroyEffect(e)
                            set e = null
                        endif
                        if e2 != null then
                            call DestroyEffect(e2)
                            set e2 = null
                        endif
                    endif

                    if r == 4.20 then
                        call MakeSound("war3mapimported\\Hero_Akainu_T3")
                    endif

                    if r > AkainuT_CastTime then
                        if r2 > 0.15 then
                            set r2 = 0.03
                            set rr1 = GetRandomReal(155.00, aoe / 2.00)
                            set rr2 = GetRandomReal(0.00, 359.00) * bj_DEGTORAD
                            set x1 = x + rr1 * Cos(rr2)
                            set y1 = y + rr1 * Sin(rr2)
                            call AkainuSpells_T2.AkainuT2_Start(c, x1, y1)
                            set check = check + 1
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                endif

                if remove then
                    if r < 1.68 then
                        if e != null then
                            call DestroyEffect(e)
                        endif
                        if e2 != null then
                            call DestroyEffect(e2)
                        endif
                    endif
                    if c != null and GetUnitTypeId(c) != 0 then
                        call StopSpellUnit(c)
                        call SetUnitTimeScale(c, 1.00)
                    endif
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set m_AkainuT[i] = m_AkainuT[MUI_AkainuT]
                    set MUI_AkainuT = MUI_AkainuT - 1
                    call deallocate(this)
                    if MUI_AkainuT == -1 then
                        call AkainuTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
        endmethod

        public static method AkainuT_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()

            set MUI_AkainuT = MUI_AkainuT + 1
            set m_AkainuT[MUI_AkainuT] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.00
            set r2 = 0.00
            set r3 = 0.00
            set check = 0
            call StartSpellUnit(c)
            set a = GAngle2(c, x, y)
            set aoe = AkainuT_DamageAoe
            set rmax = AkainuT_MaxDuration

            call SetUnitAnimationByIndex(c, 6)
            call SetUnitTimeScale(c, 3.30)
            call MakeSound("war3mapimported\\Hero_Akainu_T")
            set e = AddSpecialEffectTarget("war3mapImported\\wos_magmahandBig-91F172.mdl", c, "hand right")
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_magmahandBig-91F172.mdl", c, "hand left")

            if MUI_AkainuT == 0 then
                call AkainuTimer03Acquire()
            endif
        endmethod
    endstruct

    //===========================================================================
    // Инициализация и публичный интерфейс
    //===========================================================================
    private function AkainuTimer03Loop takes nothing returns nothing
        call AkainuSpells_Q.Loop_AkainuQ()
        call AkainuSpells_W.Loop_AkainuW()
        call AkainuSpells_W2.Loop_AkainuW2()
        call AkainuSpells_E.Loop_AkainuE()
        call AkainuSpells_R.Loop_AkainuR()
        call AkainuSpells_T.Loop_AkainuT()
        call AkainuSpells_T2.Loop_AkainuT2()
    endfunction

    private function InitAkainuSpells takes nothing returns nothing
        set AkainuTimer03 = CreateTimer()
        set AkainuTimer03Callback = function AkainuTimer03Loop
    endfunction

    function AkainuQ_Start takes unit c, unit td returns nothing
        call AkainuSpells_Q.AkainuQ_Start(c, td)
    endfunction

    function AkainuW_Start takes unit c, real x, real y returns nothing
        call AkainuSpells_W.AkainuW_Start(c, x, y)
    endfunction

    function AkainuE_Start takes unit c, unit td returns nothing
        call AkainuSpells_E.AkainuE_Start(c, td)
    endfunction

    function AkainuR_Start takes unit c, real x, real y returns nothing
        call AkainuSpells_R.AkainuR_Start(c, x, y)
    endfunction

    function AkainuT_Start takes unit c, real x, real y returns nothing
        call AkainuSpells_T.AkainuT_Start(c, x, y)
    endfunction
endlibrary