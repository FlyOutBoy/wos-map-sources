library BambiettaSpells initializer InitBambiettaSpells uses GearSystems
    globals
        private timer BambiettaTimer03 = null
        private timer BambiettaTimer05 = null
        private code BambiettaTimer03Callback
        private code BambiettaTimer05Callback
        private integer BambiettaTimer03Users = 0
        private integer BambiettaTimer05Users = 0

//--------------------------------------Bambietta Core---------------------------------------------------------
        integer Bambietta_ID = 'H026'
        integer Bambietta2_ID = 'H027'
        framehandle array frameBambietta_pas1 [10]
        framehandle array frameBambietta_pas2 [10]
        framehandle array frameBambietta_pas3 [10]
        framehandle array frameBambietta_pas4 [10]
        framehandle array frameBambietta_pas5 [10]
        framehandle array frameBambietta_pas6 [10]
        framehandle array framebambietta_morph1 [10]
        framehandle array framebambietta_morph2 [10]
        framehandle array framebambietta_morph3 [10]
        framehandle array framebambietta_morph4 [10]
        framehandle array framebambietta_morph5 [10]
        framehandle array framebambietta_morph6 [10]

//---------------Флаги неуязвимости (true = неуязвим, false = уязвим)-----------
        boolean BambiettaQ_IsInvul   = false
        boolean BambiettaTQ_IsInvul  = false
        boolean BambiettaW_IsInvul   = false
        boolean BambiettaTW_IsInvul  = false
        boolean BambiettaE_IsInvul   = false
        boolean BambiettaTE_IsInvul  = false
        boolean BambiettaR_IsInvul   = true
        boolean BambiettaTR_IsInvul  = true
        boolean BambiettaT_IsInvul   = true
        boolean BambiettaT2_IsInvul  = true

//---------------Q ability (Burst Shell)----------------------------------------
        integer BambiettaQ_ID = 'A0DE'
        real BambiettaQ_DamageAgiBase = 1.0
        real BambiettaQ_DamageAgiStep = 1.0
        real BambiettaQ_Damage2StaticBase = 125.0
        real BambiettaQ_Damage2StaticStep = 0.0
        real BambiettaQ_DamageAoe = 190.0
        real BambiettaQ_DamageAoe2 = 450.0
        real BambiettaQ_RangeBase = 1200.0
        real BambiettaQ_RangeStep = 100.0
        real BambiettaQ_CastTime = 0.60
        real BambiettaQ_DecorDamage = 20.0
        real BambiettaQ_ExplosionDecorDamage = 30.0

//---------------TQ ability (Vollstandig: Triple Shell)------------------------
        real BambiettaTQ_DamageAgiBase = 2.0
        real BambiettaTQ_DamageAgiStep = 1.0
        real BambiettaTQ_DamageAoe = 190.0
        real BambiettaTQ_DamageAoe2 = 450.0
        real BambiettaTQ_RangeBase = 1400.0
        real BambiettaTQ_RangeStep = 100.0
        real BambiettaTQ_CastTime = 0.51
        real BambiettaTQ_DecorDamage = 20.0
        real BambiettaTQ_ExplosionDecorDamage = 30.0

//---------------W ability (Penta Shell)----------------------------------------
        integer BambiettaW_ID = 'A0DF'
        real BambiettaW_DamageAgiBase = 1.0
        real BambiettaW_DamageAgiStep = 1.0
        real BambiettaW_Damage2StaticBase = 150.0
        real BambiettaW_Damage2StaticStep = 0.0
        real BambiettaW_DamageAoe = 330.0
        real BambiettaW_DamageAoe2 = 475.0
        real BambiettaW_RangeBase = 1000.0
        real BambiettaW_RangeStep = 100.0
        real BambiettaW_CastTime = 0.63
        real BambiettaW_DecorDamage = 20.0
        real BambiettaW_ExplosionDecorDamage = 30.0

//---------------TW ability (Vollstandig: Homing Dash)-------------------------
        real BambiettaTW_DamageAgiBase = 2.0
        real BambiettaTW_DamageAgiStep = 1.0
        real BambiettaTW_DamageAoe = 1100.0
        real BambiettaTW_DamageAoe2 = 325.0
        real BambiettaTW_CastTime = 0.15
        real BambiettaTW_Duration = 0.66
        real BambiettaTW_DecorDamage = 30.0

//---------------E ability (Bombardment Wave)----------------------------------
        integer BambiettaE_ID = 'A0DG'
        real BambiettaE_DamageAgiBase = 2.0
        real BambiettaE_DamageAgiStep = 1.0
        real BambiettaE_DamageAoe = 350.0
        real BambiettaE_DamageAoe2 = 525.0
        real BambiettaE_RangeBase = 1400.0
        real BambiettaE_RangeStep = 120.0
        integer BambiettaE_Slow = 30
        integer BambiettaE_SlowDuration = 2
        real BambiettaE_CastTime = 0.60
        real BambiettaE_DecorDamage = 30.0
        real BambiettaE_ExplosionDecorDamage = 50.0

//---------------TE ability (Vollstandig: Shell Barrage)-----------------------
        real BambiettaTE_DamageAgiBase = 3.0
        real BambiettaTE_DamageAgiStep = 1.0
        real BambiettaTE_DamageAoe = 400.0
        real BambiettaTE_RangeBase = 1600.0
        real BambiettaTE_RangeStep = 100.0
        real BambiettaTE_Stun = 0.1
        real BambiettaTE_CastTime = 0.60
        real BambiettaTE_Duration = 1.26
        real BambiettaTE_DecorDamage = 40.0

//---------------R ability (The Bombing Impact)--------------------------------
        integer BambiettaR_ID = 'A0DH'
        real BambiettaR_DamageAoe = 775.0
        real BambiettaR_PushRange = 300.0
        real BambiettaR_PushDuration = 0.3
        real BambiettaR_DamageAgiBase = 4.0
        real BambiettaR_DamageAgiStep = 1.0
        real BambiettaR_CastTime = 0.75
        real BambiettaR_Duration = 1.20
        real BambiettaR_DecorDamage = 100.0

//---------------TR ability (Vollstandig: Cataclysm Impact)--------------------
        real BambiettaTR_DamageAoe = 975.0
        real BambiettaTR_PushRange = 500.0
        real BambiettaTR_PushDuration = 0.3
        real BambiettaTR_DamageAgiBase = 5.0
        real BambiettaTR_DamageAgiStep = 1.0
        real BambiettaTR_CastTime = 0.75
        real BambiettaTR_Duration = 1.20
        real BambiettaTR_DecorDamage = 100.0

//---------------T ability (Vollstandig Transformation)------------------------
        integer BambiettaT_ID = 'A0DI'
        integer BambiettaT2_ID = 'A0DK'
        real BambiettaT_ReduceCD = 10.0
        real BambiettaT_Duration = 20.0
        real BambiettaT_CastTime = 1.50
        real BambiettaT_DecorDamage = 40.0

//---------------TT ability (Rain of Carnage)----------------------------------
        real BambiettaTT_DamageAgiBase = 1.5
        real BambiettaTT_DamageAoe = 750.0
        real BambiettaTT_DamageAoe2 = 500.0
        real BambiettaTT_Duration = 3.30
        real BambiettaTT_DecorDamage = 50.0

//---------------G ability (The Explode)---------------------------------------
        integer BambiettaG_ID = 'A0DJ'
        real BambiettaG_DamageAgiBase12 = 1.0
        real BambiettaG_DamageAgiBase25 = 1.5
        real BambiettaG_DamageAgiBase35 = 2.0
        real BambiettaG_CD = 5.0
        integer BambiettaG_Lvl_CD = 12
        real BambiettaG_DecorDamage = 25.0
    endglobals

    private function BambiettaTimer03Acquire takes nothing returns nothing
        set BambiettaTimer03Users = BambiettaTimer03Users + 1
        if BambiettaTimer03Users == 1 then
            call TimerStart(BambiettaTimer03, 0.03, true, BambiettaTimer03Callback)
        endif
    endfunction

    private function BambiettaTimer03Release takes nothing returns nothing
        set BambiettaTimer03Users = BambiettaTimer03Users - 1
        if BambiettaTimer03Users <= 0 then
            set BambiettaTimer03Users = 0
            call PauseTimer(BambiettaTimer03)
        endif
    endfunction

    private function BambiettaTimer05Acquire takes nothing returns nothing
        set BambiettaTimer05Users = BambiettaTimer05Users + 1
        if BambiettaTimer05Users == 1 then
            call TimerStart(BambiettaTimer05, 0.05, true, BambiettaTimer05Callback)
        endif
    endfunction

    private function BambiettaTimer05Release takes nothing returns nothing
        set BambiettaTimer05Users = BambiettaTimer05Users - 1
        if BambiettaTimer05Users <= 0 then
            set BambiettaTimer05Users = 0
            call PauseTimer(BambiettaTimer05)
        endif
    endfunction

    private struct BambiettaSpells_Q
        private static integer array m_BambiettaQ
        private static integer MUI_BambiettaQ = -1
        private static integer array m_BambiettaTQ2
        private static integer MUI_BambiettaTQ2 = -1
        private static integer array m_BambiettaTQ
        private static integer MUI_BambiettaTQ = -1
        unit c
        real x
        real y
        real r2
        integer k
        real r5
        real r7
        group g
        group g2
        unit u
        real dmg
        integer check2
        real aoe
        real aoe2
        real move
        real r
        effect e
        effect e2
        real a
        real rmax

        public static method Loop_BambiettaQ takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_BambiettaQ
                set this = m_BambiettaQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r < 0.51 then
                        if BambiettaQ_IsInvul then
                            call DebugUnit(c)
                        else
                            call DebugUnit2(c)
                        endif
                    endif
                    if r == 0.15 then
                        set e2 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiblue.mdx", c, "hand right")
                    endif
                    if r == 0.3 then
                        set e = EffectSpawnScale("war3mapimported\\wos_3yifu_2.mdx", GetUnitX(c) + 120 * Cos(a), GetUnitY(c) + 120 * Sin(a), a * bj_RADTODEG, 0.3, 1, 150, 0.12, 0.01, 1.5)
                    endif
                    if r == 0.45 then
                        call DestroyEffect(e2)
                        set e2 = null
                    endif
                    if r == 0.6 then
                        if BambiettaQ_IsInvul then
                            call StopSpellUnit(c)
                        else
                            call StopSpellUnit2(c)
                        endif
                        set r2 = 10
                    endif
                    if r > 0.6 then
                        call MoveEff(e, move, a)
                        set r5 = r5 + move
                        if r5 > r7 then
                            set r = 999
                        endif
                        if r2 > 0.03 then
                            set r2 = 0
                            set x = GetEffX(e)
                            set y = GetEffY(e)
                            if check2 == 0 then
                                call VisionTimed(GetOwningPlayer(c), x, y, 700, 1.5)
                                call DecorRemove(c, x, y, aoe, BambiettaQ_DecorDamage)
                            endif
                            set check2 = check2 + 1
                            if check2 >= 5 then
                                set check2 = 0
                            endif
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                    set r = 999
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    if r == 999 then
                        call MakeSound("war3mapimported\\Hero_Bambietta_Q2")
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        call BlzSetSpecialEffectTimeScale(e, 1)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (426)1.mdl", x, y, a * bj_RADTODEG, 1.35, 3.75 * 0.94, 250))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_1lanse_99.mdl", x, y, a * bj_RADTODEG, 2.15, 0.9 * 0.94, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlash.mdl", x + 25 * Cos(a), y + 25 * Sin(a), 1, 1.15, 1.475 * 0.94, 125))
                        call DecorRemove(c, x, y, aoe2, BambiettaQ_ExplosionDecorDamage)
                        call VisionTimed(GetOwningPlayer(c), x, y, 1000, 2)
                        call GroupEnumUnitsInRange(g, x, y, aoe2, NoDecor_Cond)
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
                    call SetUnitTimeScale(c, 1)
                    call DestroyGroup(g)
                    call DestroyEffect(e)
                    if e2 != null then
                        call DestroyEffect(e2)
                        set e2 = null
                    endif
                    if r < 0.51 then
                        if BambiettaQ_IsInvul then
                            call StopSpellUnit(c)
                        else
                            call StopSpellUnit2(c)
                        endif
                    endif
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_BambiettaQ[i] = m_BambiettaQ[MUI_BambiettaQ]
                    set MUI_BambiettaQ = MUI_BambiettaQ - 1
                    if MUI_BambiettaQ == -1 then
                        call BambiettaTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BambiettaQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            set MUI_BambiettaQ = MUI_BambiettaQ + 1
            set m_BambiettaQ[MUI_BambiettaQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set move = 100
            set r5 = 0
            set e = null
            set e2 = null
            if BambiettaQ_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            set g = CreateGroup()
            set u = null
            set check2 = 0
            set a = GAngle2(c, x, y)
            set aoe = BambiettaQ_DamageAoe
            set aoe2 = BambiettaQ_DamageAoe2
            set dmg = GetHeroAgi(c, true) * (BambiettaQ_DamageAgiBase + (BambiettaQ_DamageAgiStep * (GetUnitAbilityLevel(c, BambiettaQ_ID) - 1)))
            set dmg = dmg + BambiettaQ_Damage2StaticBase + (BambiettaQ_Damage2StaticStep * (GetUnitAbilityLevel(c, BambiettaQ_ID) - 1))
            set rmax = 2.9
            set r7 = BambiettaQ_RangeBase + (BambiettaQ_RangeStep * (GetUnitAbilityLevel(c, BambiettaQ_ID) - 1))
            call SetUnitAnimationByIndex(c, 7)
            call SetUnitTimeScale(c, 0.5)
            set k = GetRandomInt(1, 3)
            if k == 1 then
                call MakeSound("war3mapimported\\Hero_Bambietta_Q")
            elseif k == 2 then
                call MakeSound("war3mapimported\\Hero_Bambietta_Q3")
            elseif k == 3 then
                call MakeSound("war3mapimported\\Hero_Bambietta_Q4")
            endif
            if MUI_BambiettaQ == 0 then
                call BambiettaTimer03Acquire()
            endif
        endmethod

        public static method Loop_BambiettaTQ2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_BambiettaTQ2
                set this = m_BambiettaTQ2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r > 0 then
                        call MoveEff(e, move, a)
                        set r5 = r5 + move
                        if r5 > r7 then
                            set r = 999
                        endif
                        if r2 > 0.03 then
                            set r2 = 0
                            set x = GetEffX(e)
                            set y = GetEffY(e)
                            if check2 == 0 then
                                call VisionTimed(GetOwningPlayer(c), x, y, 700, 1.5)
                                call DecorRemove(c, x, y, aoe, BambiettaTQ_DecorDamage)
                            endif
                            set check2 = check2 + 1
                            if check2 >= 5 then
                                set check2 = 0
                            endif
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitInGroup(u, g2) == false then
                                    set r = 999
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    if r == 999 then
                        if IntegerCd(c, "cd s", 0.5) then
                            call MakeSound("war3mapimported\\Hero_Bambietta_TQ2")
                        endif
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        call BlzSetSpecialEffectTimeScale(e, 1)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_AZ_D073red.mdl", x, y, a * bj_RADTODEG, 1.35, 1, 1))
                        call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_A_P.blast3red.mdl", x, y, a * bj_RADTODEG, 2.15, 1.1, 1), 0.3, 255, 25, 25, 0.65)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlashred.mdl", x + 25 * Cos(a), y + 25 * Sin(a), 1, 1.15, 1.475, 125))
                        call DecorRemove(c, x, y, aoe2, BambiettaTQ_ExplosionDecorDamage)
                        call VisionTimed(GetOwningPlayer(c), x, y, 1000, 1.5)
                        call GroupEnumUnitsInRange(g, x, y, aoe2, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitInGroup(u, g2) == false then
                                call dmgmag(c, u, dmg)
                                call GroupAddUnit(g2, u)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                    endif
                    call DestroyGroup(g)
                    call DestroyEffect(e)
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_BambiettaTQ2[i] = m_BambiettaTQ2[MUI_BambiettaTQ2]
                    set MUI_BambiettaTQ2 = MUI_BambiettaTQ2 - 1
                    if MUI_BambiettaTQ2 == -1 then
                        call BambiettaTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BambiettaTQ2_Start takes unit NewC, real NewX, real NewY, group NewG returns nothing
            local thistype this = thistype.create()
            set MUI_BambiettaTQ2 = MUI_BambiettaTQ2 + 1
            set m_BambiettaTQ2[MUI_BambiettaTQ2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set move = GetRandomReal(100, 150)
            set r5 = 0
            set g2 = NewG
            set g = CreateGroup()
            set u = null
            set check2 = 0
            set a = GAngle2(c, x, y)
            set aoe = BambiettaTQ_DamageAoe
            set aoe2 = BambiettaTQ_DamageAoe2
            set dmg = GetHeroAgi(c, true) * (BambiettaTQ_DamageAgiBase + (BambiettaTQ_DamageAgiStep * (GetUnitAbilityLevel(c, BambiettaQ_ID) - 1)))
            set dmg = dmg + BambiettaQ_Damage2StaticBase + (BambiettaQ_Damage2StaticStep * (GetUnitAbilityLevel(c, BambiettaQ_ID) - 1))
            set rmax = 2.9
            set e = EffectSpawnScale("war3mapimported\\wos_3yifu_2red.mdx", GetUnitX(c) + 90 * Cos(a), GetUnitY(c) + 90 * Sin(a), a * bj_RADTODEG, 0.3, 1, 150, 0.12, 0.01, 1.5)
            set r7 = BambiettaTQ_RangeBase + (BambiettaTQ_RangeStep * (GetUnitAbilityLevel(c, BambiettaQ_ID) - 1)) + GetRandomReal(-250, 250)
            if MUI_BambiettaTQ2 == 0 then
                call BambiettaTimer03Acquire()
            endif
        endmethod

        public static method Loop_BambiettaTQ takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_BambiettaTQ
                set this = m_BambiettaTQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r < 0.51 then
                        if BambiettaTQ_IsInvul then
                            call DebugUnit(c)
                        else
                            call DebugUnit2(c)
                        endif
                    endif
                    if r == 0.21 or r == 0.27 or r == 0.33 then
                        call MyRemoveEff(EffectSpawnScale("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLired.mdx", GetUnitX(c) + 120 * Cos(a + k * 72 * bj_DEGTORAD), GetUnitY(c) + 120 * Sin(a + k * 72 * bj_DEGTORAD), 0, 2, 0.01, 150, 0.15, 0.01, 3), 0.51 - r)
                        set k = k + 1
                    endif
                    if r == 0.51 then
                        if BambiettaTQ_IsInvul then
                            call StopSpellUnit(c)
                        else
                            call StopSpellUnit2(c)
                        endif
                        set k = -1
                        loop
                            exitwhen k == 2
                            call BambiettaTQ2_Start(c, GetUnitX(c) + 100 * Cos(a + k * 9.5 * bj_DEGTORAD), GetUnitY(c) + 100 * Sin(a + k * 9.5 * bj_DEGTORAD), g)
                            set k = k + 1
                        endloop
                    endif
                else
                    call SetUnitTimeScale(c, 1)
                    call DestroyGroup(g)
                    if r < 0.51 then
                        if BambiettaTQ_IsInvul then
                            call StopSpellUnit(c)
                        else
                            call StopSpellUnit2(c)
                        endif
                    endif
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_BambiettaTQ[i] = m_BambiettaTQ[MUI_BambiettaTQ]
                    set MUI_BambiettaTQ = MUI_BambiettaTQ - 1
                    if MUI_BambiettaTQ == -1 then
                        call BambiettaTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BambiettaTQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            set MUI_BambiettaTQ = MUI_BambiettaTQ + 1
            set m_BambiettaTQ[MUI_BambiettaTQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set move = 100
            set r5 = 0
            if BambiettaTQ_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            set k = 0
            set g = CreateGroup()
            set u = null
            set check2 = 0
            set a = GAngle2(c, x, y)
            set rmax = 1.5
            if GetRandomInt(1, 2) == 1 then
                call SetUnitAnimationByIndex(c, 6)
            else
                call SetUnitAnimationByIndex(c, 7)
            endif
            call SetUnitTimeScale(c, 0.75)
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapimported\\Hero_Bambietta_TQ")
            else
                call MakeSound("war3mapimported\\Hero_Bambietta_TW03")
            endif
            set k = -1
            if MUI_BambiettaTQ == 0 then
                call BambiettaTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct BambiettaSpells_W
        private static integer array m_BambiettaW2
        private static integer MUI_BambiettaW2 = -1
        private static integer array m_BambiettaW
        private static integer MUI_BambiettaW = -1
        private static integer array m_BambiettaTW2
        private static integer MUI_BambiettaTW2 = -1
        private static integer array m_BambiettaTW
        private static integer MUI_BambiettaTW = -1
        unit c
        real x
        real y
        real r2
        integer k
        real r5
        real r7
        group g
        group g2
        unit u
        real dmg
        integer check2
        real aoe
        real aoe2
        real move
        real r
        effect e
        effect e2
        real a
        real rmax

        public static method Loop_BambiettaW2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_BambiettaW2
                set this = m_BambiettaW2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r > 0 then
                        call MoveEff(e, move, a)
                        set r5 = r5 + move
                        if r5 > r7 then
                            set r = 999
                        endif
                        if r2 > 0.03 then
                            set r2 = 0
                            set x = GetEffX(e)
                            set y = GetEffY(e)
                            if check2 == 0 then
                                call VisionTimed(GetOwningPlayer(c), x, y, 700, 1.5)
                                call DecorRemove(c, x, y, aoe, BambiettaW_DecorDamage)
                            endif
                            set check2 = check2 + 1
                            if check2 >= 5 then
                                set check2 = 0
                            endif
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitInGroup(u, g2) == false then
                                    set r = 999
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    if r == 999 then
                        if IntegerCd(c, "cd s", 0.5) then
                            call MakeSound("war3mapimported\\Hero_Bambietta_W2")
                        endif
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        call BlzSetSpecialEffectTimeScale(e, 1)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_AZ_D073.mdl", x, y, a * bj_RADTODEG, 1.35, 1, 1))
                        call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_A_P.blast3.mdl", x, y, a * bj_RADTODEG, 2.15, 1.1, 1), 0.3, 255, 255, 255, 0.65)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlash.mdl", x + 25 * Cos(a), y + 25 * Sin(a), 1, 1.15, 1.475, 125))
                        call DecorRemove(c, x, y, aoe2, BambiettaW_ExplosionDecorDamage)
                        call VisionTimed(GetOwningPlayer(c), x, y, 900, 2)
                        call GroupEnumUnitsInRange(g, x, y, aoe2, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitInGroup(u, g2) == false then
                                call dmgmag(c, u, dmg)
                                call GroupAddUnit(g2, u)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                    endif
                    call DestroyGroup(g)
                    call DestroyEffect(e)
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_BambiettaW2[i] = m_BambiettaW2[MUI_BambiettaW2]
                    set MUI_BambiettaW2 = MUI_BambiettaW2 - 1
                    if MUI_BambiettaW2 == -1 then
                        call BambiettaTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BambiettaW2_Start takes unit NewC, real NewX, real NewY, group NewG returns nothing
            local thistype this = thistype.create()
            set MUI_BambiettaW2 = MUI_BambiettaW2 + 1
            set m_BambiettaW2[MUI_BambiettaW2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set move = GetRandomReal(100, 150)
            set r5 = 0
            set g2 = NewG
            set g = CreateGroup()
            set u = null
            set check2 = 0
            set a = GAngle2(c, x, y)
            set aoe = BambiettaW_DamageAoe
            set aoe2 = BambiettaW_DamageAoe2
            set dmg = GetHeroAgi(c, true) * (BambiettaW_DamageAgiBase + (BambiettaW_DamageAgiStep * (GetUnitAbilityLevel(c, BambiettaW_ID) - 1)))
            set dmg = dmg + BambiettaW_Damage2StaticBase + (BambiettaW_Damage2StaticStep * (GetUnitAbilityLevel(c, BambiettaW_ID) - 1))
            set rmax = 2.9
            set e = EffectSpawnScale("war3mapimported\\wos_3yifu_2.mdx", GetUnitX(c) + 90 * Cos(a), GetUnitY(c) + 90 * Sin(a), a * bj_RADTODEG, 0.3, 1, 150, 0.12, 0.01, 1.5)
            set r7 = BambiettaW_RangeBase + (BambiettaW_RangeStep * (GetUnitAbilityLevel(c, BambiettaW_ID) - 1)) + GetRandomReal(-200, 200)
            if MUI_BambiettaW2 == 0 then
                call BambiettaTimer03Acquire()
            endif
        endmethod

        public static method Loop_BambiettaW takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_BambiettaW
                set this = m_BambiettaW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r < 0.51 then
                        if BambiettaW_IsInvul then
                            call DebugUnit(c)
                        else
                            call DebugUnit2(c)
                        endif
                    endif
                    if r == 0.21 or r == 0.27 or r == 0.33 or r == 0.39 or r == 0.45 or r == 0.51 then
                        call MyRemoveEff(EffectSpawnScale("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiblue.mdx", GetUnitX(c) + 120 * Cos(a + k * 72 * bj_DEGTORAD), GetUnitY(c) + 120 * Sin(a + k * 72 * bj_DEGTORAD), 0, 1, 0.01, 150, 0.15, 0.01, 3), 0.6 - r)
                        set k = k + 1
                    endif
                    if r == 0.63 then
                        if BambiettaW_IsInvul then
                            call StopSpellUnit(c)
                        else
                            call StopSpellUnit2(c)
                        endif
                        set k = 0
                        loop
                            exitwhen k == 5
                            call BambiettaW2_Start(c, GetUnitX(c) + 100 * Cos(a + k * 72 * bj_DEGTORAD), GetUnitY(c) + 100 * Sin(a + k * 72 * bj_DEGTORAD), g)
                            set k = k + 1
                        endloop
                    endif
                else
                    call SetUnitTimeScale(c, 1)
                    call DestroyGroup(g)
                    if r < 0.51 then
                        if BambiettaW_IsInvul then
                            call StopSpellUnit(c)
                        else
                            call StopSpellUnit2(c)
                        endif
                    endif
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_BambiettaW[i] = m_BambiettaW[MUI_BambiettaW]
                    set MUI_BambiettaW = MUI_BambiettaW - 1
                    if MUI_BambiettaW == -1 then
                        call BambiettaTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BambiettaW_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_BambiettaW = MUI_BambiettaW + 1
            set m_BambiettaW[MUI_BambiettaW] = this
            set c = NewC
            set r = 0
            set r2 = 0
            set move = 100
            set r5 = 0
            if BambiettaW_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            set g = CreateGroup()
            set u = null
            set check2 = 0
            set a = GetUnitFacing(c) * bj_DEGTORAD
            set rmax = 1.32
            call SetUnitAnimationByIndex(c, 1)
            call SetUnitTimeScale(c, 0.45)
            set k = GetRandomInt(1, 2)
            if k == 1 then
                call MakeSound("war3mapimported\\Hero_Bambietta_W")
            elseif k == 2 then
                call MakeSound("war3mapimported\\Hero_Bambietta_W3")
            endif
            set k = 0
            if MUI_BambiettaW == 0 then
                call BambiettaTimer03Acquire()
            endif
        endmethod

        public static method Loop_BambiettaTW2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_BambiettaTW2
                set this = m_BambiettaTW2[i]
                if SpellBoolCaster(c) and r < rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call MoveEff(e, move, a)
                else
                    if IntegerCd(c, "cd s", 0.5) then
                        call MakeSound("war3mapimported\\Hero_Bambietta_W2")
                    endif
                    set x = GetEffX(e)
                    set y = GetEffY(e)
                    call BlzSetSpecialEffectTimeScale(e, 1)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_chushou_by_wood_effect_fire_flamecrack3.mdl", x, y, a * bj_RADTODEG, 2.15, 5, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_AZ_D073red.mdl", x, y, a * bj_RADTODEG, 1.45, 0.8, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlashred.mdl", x + 25 * Cos(a), y + 25 * Sin(a), 1, 1.25, 1.675, 185))
                    call DecorRemove(c, x, y, aoe, BambiettaTW_DecorDamage)
                    call VisionTimed(GetOwningPlayer(c), x, y, 900, 2)
                    call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                            call dmgmag(c, u, dmg)
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop
                    set u = null
                    call DestroyGroup(g)
                    call DestroyEffect(e)
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_BambiettaTW2[i] = m_BambiettaTW2[MUI_BambiettaTW2]
                    set MUI_BambiettaTW2 = MUI_BambiettaTW2 - 1
                    if MUI_BambiettaTW2 == -1 then
                        call BambiettaTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BambiettaTW2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            set MUI_BambiettaTW2 = MUI_BambiettaTW2 + 1
            set m_BambiettaTW2[MUI_BambiettaTW2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set r5 = 0
            set g = CreateGroup()
            set u = null
            set check2 = 0
            set a = GAngle2(c, x, y)
            set aoe = BambiettaTW_DamageAoe2
            set dmg = GetHeroAgi(c, true) * (BambiettaTW_DamageAgiBase + (BambiettaTW_DamageAgiStep * (GetUnitAbilityLevel(c, BambiettaW_ID) - 1)))
            set dmg = dmg + BambiettaW_Damage2StaticBase + (BambiettaW_Damage2StaticStep * (GetUnitAbilityLevel(c, BambiettaW_ID) - 1))
            set rmax = 0.24
            set e = EffectSpawnScale("war3mapimported\\wos_3yifu_2red.mdx", GetUnitX(c) + 120 * Cos(GetUnitFacing(c) * bj_DEGTORAD), GetUnitY(c) + 120 * Sin(GetUnitFacing(c) * bj_DEGTORAD), a * bj_RADTODEG, 1, 1, 150, 0.12, 0.01, 1.5)
            set move = SR5(e, x, y) / 8
            if MUI_BambiettaTW2 == 0 then
                call BambiettaTimer03Acquire()
            endif
        endmethod

        public static method Loop_BambiettaTW takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_BambiettaTW
                set this = m_BambiettaTW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r > BambiettaTW_CastTime then
                        if BambiettaTW_IsInvul then
                            call DebugUnit(c)
                        else
                            call DebugUnit2(c)
                        endif
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        call MoveUnit(c, move, a)
                        call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
                        call BlzSetSpecialEffectPosition(e, GetUnitX(c) - 255 * Cos(a), GetUnitY(c) - 255 * Sin(a), 70)
                        if r2 > 0.03 then
                            set r2 = 0
                            call GroupClear(g)
                            set k = 0
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null or k > 0
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitInGroup(u, g2) == false then
                                    call BambiettaTW2_Start(c, GetUnitX(u), GetUnitY(u))
                                    call GroupAddUnit(g2, u)
                                    set k = k + 1
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    call SetUnitTimeScale(c, 1)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    call SetUnitVertexColor(c, 255, 255, 255, 255)
                    call BlzSetSpecialEffectAlpha(e, 0)
                    call DestroyEffect(e)
                    if BambiettaTW_IsInvul then
                        call StopSpellUnit(c)
                    else
                        call StopSpellUnit2(c)
                    endif
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set u = null
                    set m_BambiettaTW[i] = m_BambiettaTW[MUI_BambiettaTW]
                    set MUI_BambiettaTW = MUI_BambiettaTW - 1
                    if MUI_BambiettaTW == -1 then
                        call BambiettaTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BambiettaTW_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_BambiettaTW = MUI_BambiettaTW + 1
            set m_BambiettaTW[MUI_BambiettaTW] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set r2 = 0
            set r5 = 0
            if BambiettaTW_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            set k = 0
            set u = null
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set check2 = 0
            set a = GetUnitFacing(c) * bj_DEGTORAD
            set rmax = BambiettaTW_CastTime + BambiettaTW_Duration
            set move = 60
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            set aoe = BambiettaTW_DamageAoe
            call SetUnitTimeScale(c, 0.75)
            set k = GetRandomInt(1, 3)
            call SetUnitVertexColor(c, 255, 255, 255, 0)
            set e = EffectSpawn3("war3mapimported\\wos_Bambietta2.mdx", x - 250 * Cos(a), y - 250 * Sin(a), a * bj_RADTODEG, 1.5, 1, 70, -295)
            call BlzPlaySpecialEffect(e, ANIM_TYPE_BIRTH)
            if k == 1 then
                call MakeSound("war3mapimported\\Hero_Bambietta_TW01")
            elseif k == 2 then
                call MakeSound("war3mapimported\\Hero_Bambietta_TW02")
            elseif k == 3 then
                call MakeSound("war3mapimported\\Hero_Bambietta_TW04")
            endif
            if MUI_BambiettaTW == 0 then
                call BambiettaTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct BambiettaSpells_E
        private static integer array m_BambiettaE2
        private static integer MUI_BambiettaE2 = -1
        private static integer array m_BambiettaE
        private static integer MUI_BambiettaE = -1
        private static integer array m_BambiettaTE2
        private static integer MUI_BambiettaTE2 = -1
        private static integer array m_BambiettaTE
        private static integer MUI_BambiettaTE = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        integer k3
        real r4
        real r5
        real r6
        real r7
        group g
        group g2
        unit u
        real dmg
        integer check2
        real aoe
        real aoe2
        real move
        real r
        effect e
        effect e2
        real a
        real rmax

        public static method Loop_BambiettaE2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_BambiettaE2
                set this = m_BambiettaE2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r > r4 then
                        call MoveEff(e, move, a)
                        call MoveEff(e2, move, a)
                        set r5 = r5 + move
                        if r5 > r7 then
                            set r = 999
                        endif
                        if r2 > 0.03 then
                            set r2 = 0
                            set x = GetEffX(e)
                            set y = GetEffY(e)
                            if check2 == 0 then
                                call VisionTimed(GetOwningPlayer(c), x, y, 700, 1.5)
                                call DecorRemove(c, x, y, aoe, BambiettaE_DecorDamage)
                            endif
                            set check2 = check2 + 1
                            if check2 >= 5 then
                                set check2 = 0
                            endif
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitInGroup(u, g2) == false then
                                    set r = 999
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    if r == 999 then
                        if IntegerCd(c, "cd s", 0.5) then
                            call MakeSound("war3mapimported\\Hero_Bambietta_E3")
                        endif
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        call VisionTimed(GetOwningPlayer(c), x, y, 1100, 2)
                        call DecorRemove(c, x, y, aoe2, BambiettaE_ExplosionDecorDamage)
                        call BlzSetSpecialEffectTimeScale(e, 1)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_AZ_D073.mdl", x, y, a * bj_RADTODEG, 1.35, 1 * 0.87, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_eff_ord_yeye_elp_xiaoqidan_baozha_2.mdl", x, y, a * bj_RADTODEG, 1, 8 * 0.9, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_chushou_by_wood_effect_fire_flamecrack2.mdl", x, y, a * bj_RADTODEG, 2.15, 5 * 0.9, 1))
                        call GroupEnumUnitsInRange(g, x, y, aoe2, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitInGroup(u, g2) == false then
                                call dmgmag(c, u, dmg)
                                call SlowUnit(c, u, BambiettaE_Slow, BambiettaE_SlowDuration)
                                call GroupAddUnit(g2, u)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                    endif
                    call DestroyGroup(g)
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_BambiettaE2[i] = m_BambiettaE2[MUI_BambiettaE2]
                    set MUI_BambiettaE2 = MUI_BambiettaE2 - 1
                    if MUI_BambiettaE2 == -1 then
                        call BambiettaTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BambiettaE2_Start takes unit NewC, real NewX, real NewY, group NewG, integer NewK returns nothing
            local thistype this = thistype.create()
            set MUI_BambiettaE2 = MUI_BambiettaE2 + 1
            set m_BambiettaE2[MUI_BambiettaE2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set move = GetRandomReal(100, 120)
            set r5 = 0
            set r6 = 0
            set g2 = NewG
            set g = CreateGroup()
            set u = null
            set check2 = 0
            set a = GAngle2(c, x, y)
            set aoe = BambiettaE_DamageAoe
            set aoe2 = BambiettaE_DamageAoe2
            set dmg = GetHeroAgi(c, true) * (BambiettaE_DamageAgiBase + (BambiettaE_DamageAgiStep * (GetUnitAbilityLevel(c, BambiettaE_ID) - 1)))
            set rmax = 2.9
            set r4 = GetRandomReal(0, 0.12)
            set k3 = NewK
            if k3 == 0 then
                set x1 = GetUnitX(c) + 300 * Cos(a - 90 * bj_DEGTORAD)
                set y1 = GetUnitY(c) + 300 * Sin(a - 90 * bj_DEGTORAD)
                set a = a - 3 * bj_DEGTORAD
            elseif k3 == 1 then
                set x1 = GetUnitX(c) + 00 * Cos(a)
                set y1 = GetUnitY(c) + 00 * Sin(a)
            else
                set x1 = GetUnitX(c) + 300 * Cos(a + 90 * bj_DEGTORAD)
                set y1 = GetUnitY(c) + 300 * Sin(a + 90 * bj_DEGTORAD)
                set a = a + 3 * bj_DEGTORAD
            endif
            set e = EffectSpawnScale("war3mapimported\\wos_3yifu_2.mdx", x1 - 150 * Cos(a), y1 - 150 * Sin(a), a * bj_RADTODEG, 0.5, 1, 165, 0.12, 0.01, 3)
            set e2 = EffectSpawnScale("war3mapimported\\wos_1chongfeng_1_lan.mdx", x1 - 150 * Cos(a), y1 - 150 * Sin(a), a * bj_RADTODEG, 1.5, 1, 165, 0.12, 0.01, 1.25)
            set r7 = BambiettaE_RangeBase + (BambiettaE_RangeStep * (GetUnitAbilityLevel(c, BambiettaE_ID) - 1)) + GetRandomReal(-200, 200) + 150
            if MUI_BambiettaE2 == 0 then
                call BambiettaTimer03Acquire()
            endif
        endmethod

        public static method Loop_BambiettaE takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_BambiettaE
                set this = m_BambiettaE[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r < 0.6 then
                        if BambiettaE_IsInvul then
                            call DebugUnit(c)
                        else
                            call DebugUnit2(c)
                        endif
                    endif
                    if r == 0.21 or r == 0.3 or r == 0.39 then
                        if k == 0 then
                            set x1 = GetUnitX(c) + 300 * Cos(a - 90 * bj_DEGTORAD)
                            set y1 = GetUnitY(c) + 300 * Sin(a - 90 * bj_DEGTORAD)
                        elseif k == 1 then
                            set x1 = GetUnitX(c) + 00 * Cos(a)
                            set y1 = GetUnitY(c) + 00 * Sin(a)
                        else
                            set x1 = GetUnitX(c) + 300 * Cos(a + 90 * bj_DEGTORAD)
                            set y1 = GetUnitY(c) + 300 * Sin(a + 90 * bj_DEGTORAD)
                        endif
                        set k = k + 1
                        call MyRemoveEff(EffectSpawnScale("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiblue.mdx", x1 - 150 * Cos(a), y1 - 150 * Sin(a), 0, 1, 0.01, 150, 0.15, 0.01, 5), 0.6 - r)
                    endif
                    if r == 0.6 then
                        call MakeSound("war3mapimported\\Hero_Bambietta_E3")
                        if BambiettaE_IsInvul then
                            call StopSpellUnit(c)
                        else
                            call StopSpellUnit2(c)
                        endif
                        call BambiettaE2_Start(c, GetUnitX(c) + 100 * Cos(a), GetUnitY(c) + 100 * Sin(a), g, 0)
                        call BambiettaE2_Start(c, GetUnitX(c) + 100 * Cos(a), GetUnitY(c) + 100 * Sin(a), g, 1)
                        call BambiettaE2_Start(c, GetUnitX(c) + 100 * Cos(a), GetUnitY(c) + 100 * Sin(a), g, 2)
                    endif
                else
                    call SetUnitTimeScale(c, 1)
                    call DestroyGroup(g)
                    if r < 0.6 then
                        if BambiettaE_IsInvul then
                            call StopSpellUnit(c)
                        else
                            call StopSpellUnit2(c)
                        endif
                    endif
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_BambiettaE[i] = m_BambiettaE[MUI_BambiettaE]
                    set MUI_BambiettaE = MUI_BambiettaE - 1
                    if MUI_BambiettaE == -1 then
                        call BambiettaTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BambiettaE_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            set MUI_BambiettaE = MUI_BambiettaE + 1
            set m_BambiettaE[MUI_BambiettaE] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set move = 100
            set r5 = 0
            set r6 = 0
            if BambiettaE_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            set g = CreateGroup()
            set u = null
            set check2 = 0
            set k = 0
            set a = GAngle2(c, x, y)
            set rmax = 1.5
            call SetUnitAnimationByIndex(c, 2)
            call SetUnitTimeScale(c, 1.5)
            set k = GetRandomInt(1, 3)
            if k == 1 then
                call MakeSound("war3mapimported\\Hero_Bambietta_E")
            elseif k == 2 then
                call MakeSound("war3mapimported\\Hero_Bambietta_E4")
            elseif k == 3 then
                call MakeSound("war3mapimported\\Hero_Bambietta_E5")
            endif
            set k = 0
            if MUI_BambiettaE == 0 then
                call BambiettaTimer03Acquire()
            endif
        endmethod

        public static method Loop_BambiettaTE2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_BambiettaTE2
                set this = m_BambiettaTE2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r > r4 then
                        call MoveEff(e, move, a)
                        call MoveEff(e2, move, a)
                        call BlzSetSpecialEffectHeight(e, BlzGetLocalSpecialEffectZ(e) - 5)
                        call BlzSetSpecialEffectHeight(e, BlzGetLocalSpecialEffectZ(e2) - 5)
                        set r5 = r5 + move
                        if r5 > r7 then
                            set r = 999
                        endif
                        if r2 > 0.03 and r > 0.03 then
                            set r2 = 0
                            set x = GetEffX(e)
                            set y = GetEffY(e)
                            if check2 == 0 then
                                call VisionTimed(GetOwningPlayer(c), x, y, 700, 1.5)
                                call DecorRemove(c, x, y, aoe, BambiettaTE_DecorDamage)
                            endif
                            set check2 = check2 + 1
                            if check2 >= 5 then
                                set check2 = 0
                            endif
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitInGroup(u, g2) == false then
                                    set r = 999
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    if r == 999 then
                        if IntegerCd(c, "cd s", 0.25) then
                            call MakeSound("war3mapimported\\Hero_Bambietta_TE3")
                        endif
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        call BlzSetSpecialEffectTimeScale(e, 1)
                        call VisionTimed(GetOwningPlayer(c), x, y, 1000, 1.5)
                        call DecorRemove(c, x, y, aoe, BambiettaTE_DecorDamage)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_AZ_D073red.mdl", x, y, a * bj_RADTODEG, 1.5, 1.2, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_eff_ord_yeye_elp_xiaoqidan_baozha_3.mdl", x, y, a * bj_RADTODEG, 1, 8, 1))
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call dmgmag(c, u, dmg)
                                call SlowUnit(c, u, BambiettaE_Slow, BambiettaE_SlowDuration)
                                call StunUnit(c, u, BambiettaTE_Stun)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                    endif
                    call DestroyGroup(g)
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_BambiettaTE2[i] = m_BambiettaTE2[MUI_BambiettaTE2]
                    set MUI_BambiettaTE2 = MUI_BambiettaTE2 - 1
                    if MUI_BambiettaTE2 == -1 then
                        call BambiettaTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BambiettaTE2_Start takes unit NewC, real NewX, real NewY, group NewG, integer NewK returns nothing
            local thistype this = thistype.create()
            set MUI_BambiettaTE2 = MUI_BambiettaTE2 + 1
            set m_BambiettaTE2[MUI_BambiettaTE2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set move = GetRandomReal(120, 140)
            set r5 = 0
            set r6 = 0
            set g2 = NewG
            set g = CreateGroup()
            set u = null
            set check2 = 0
            set a = GAngle2(c, x, y)
            set aoe = BambiettaE_DamageAoe
            set aoe2 = BambiettaE_DamageAoe2
            set dmg = GetHeroAgi(c, true) * (BambiettaTE_DamageAgiBase + (BambiettaTE_DamageAgiStep * (GetUnitAbilityLevel(c, BambiettaE_ID) - 1)))
            set dmg = dmg / 14
            set rmax = 2.9
            set r4 = GetRandomReal(0, 0.12)
            set k3 = NewK
            set r5 = GetRandomReal(0, 200)
            set r6 = GetRandomReal(150, 320)
            if k3 == 0 then
                set x1 = GetUnitX(c) + r5 * Cos(a - 90 * bj_DEGTORAD)
                set y1 = GetUnitY(c) + r5 * Sin(a - 90 * bj_DEGTORAD)
                set a = a - GetRandomReal(1, 10) * bj_DEGTORAD
            elseif k3 == 1 then
                set x1 = GetUnitX(c) + r5 * Cos(a + 90 * bj_DEGTORAD)
                set y1 = GetUnitY(c) + r5 * Sin(a + 90 * bj_DEGTORAD)
                set a = a + GetRandomReal(1, 10) * bj_DEGTORAD
            endif
            set e = EffectSpawnScale("war3mapimported\\wos_3yifu_2red.mdx", x1 - 150 * Cos(a), y1 - 150 * Sin(a), a * bj_RADTODEG, 0.5, 1, r6, 0.12, 0.01, 3)
            set e2 = EffectSpawnScale("war3mapimported\\wos_1chongfeng_1_lanred.mdx", x1 - 150 * Cos(a), y1 - 150 * Sin(a), a * bj_RADTODEG, 1.5, 1, r6, 0.12, 0.01, GetRandomReal(0.75, 1.25))
            set r7 = BambiettaTE_RangeBase + (BambiettaTE_RangeStep * (GetUnitAbilityLevel(c, BambiettaE_ID) - 1)) + GetRandomReal(-500, 500) + 150
            if MUI_BambiettaTE2 == 0 then
                call BambiettaTimer03Acquire()
            endif
        endmethod

        public static method Loop_BambiettaTE takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_BambiettaTE
                set this = m_BambiettaTE[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if BambiettaTE_IsInvul then
                        call DebugUnit(c)
                    else
                        call DebugUnit2(c)
                    endif
                    set x = GetMouseX(GetOwningPlayer(c))
                    set y = GetMouseY(GetOwningPlayer(c))
                    set a = GAngle2(c, x, y)
                    call SetUnitFacing(c, a * bj_RADTODEG)
                    if r == 0.63 then
                        call SetUnitTimeScale(c, 0.2)
                    endif
                    if r > BambiettaTE_CastTime then
                        if r2 > 0.09 then
                            set r2 = 0
                            set k = 0
                            if IntegerCd(c, "sound e", 1.5) then
                                call MakeSound("war3mapimported\\Hero_Bambietta_TE2")
                            endif
                            set k3 = GetRandomInt(1, 2)
                            call BambiettaTE2_Start(c, GetUnitX(c) + 100 * Cos(a), GetUnitY(c) + 100 * Sin(a), null, 0)
                            call BambiettaTE2_Start(c, GetUnitX(c) + 100 * Cos(a), GetUnitY(c) + 100 * Sin(a), null, 1)
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    call MouseOff(GetOwningPlayer(c))
                    call SetUnitTimeScale(c, 1)
                    if BambiettaTE_IsInvul then
                        call StopSpellUnit(c)
                    else
                        call StopSpellUnit2(c)
                    endif
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_BambiettaTE[i] = m_BambiettaTE[MUI_BambiettaTE]
                    set MUI_BambiettaTE = MUI_BambiettaTE - 1
                    if MUI_BambiettaTE == -1 then
                        call BambiettaTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BambiettaTE_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            set MUI_BambiettaTE = MUI_BambiettaTE + 1
            set m_BambiettaTE[MUI_BambiettaTE] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set move = 100
            set r5 = 0
            set r6 = 0
            if BambiettaTE_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            set g = null
            set u = null
            set check2 = 0
            set k = 0
            set a = GAngle2(c, x, y)
            set rmax = BambiettaTE_CastTime + BambiettaTE_Duration
            call SetUnitAnimationByIndex(c, 1)
            call SetUnitTimeScale(c, 2.15)
            set k = GetRandomInt(1, 2)
            if k == 1 then
                call MakeSound("war3mapimported\\Hero_Bambietta_TE")
            elseif k == 2 then
                call MakeSound("war3mapimported\\Hero_Bambietta_TE01")
            endif
            call SetMouseX(GetOwningPlayer(c), x)
            call SetMouseY(GetOwningPlayer(c), y)
            call MouseOn(GetOwningPlayer(c))
            set k = 0
            if MUI_BambiettaTE == 0 then
                call BambiettaTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct BambiettaSpells_R
        private static integer array m_BambiettaR
        private static integer MUI_BambiettaR = -1
        private static integer array m_BambiettaTR
        private static integer MUI_BambiettaTR = -1
        unit c
        real x
        real y
        real r2
        integer k
        real scale
        group g
        group g2
        unit u
        real dmg
        real aoe
        real r
        effect e
        effect e2
        real a
        real rmax

        public static method Loop_BambiettaR takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_BambiettaR
                set this = m_BambiettaR[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if BambiettaR_IsInvul then
                        call DebugUnit(c)
                    else
                        call DebugUnit2(c)
                    endif
                    if r == 0.15 then
                        call MakeSound("war3mapimported\\Hero_Bambietta_R2")
                    endif
                    if r == 0.63 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlash.mdl", x + 25 * Cos(a), y + 25 * Sin(a), 1, 1.15, 2.475, 225))
                    endif
                    if r == BambiettaR_CastTime then
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        call SetUnitTimeScale(c, 0.2)
                        call DecorRemove(c, x, y, aoe, BambiettaR_DecorDamage)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (426)1.mdl", x, y, a * bj_RADTODEG, 1.25, 6.75, 250))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_1lanse_99.mdl", x, y, a * bj_RADTODEG, 2, 1.1, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (513).mdl", x, y, GetRandomReal(0, 359), 0.65, 1, 15))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue--zhendi31_3_x2.mdl", x, y, GetRandomReal(0, 359), 0.5, 1, 1))
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_by_wood_effect_order_dange_yueyun_2withoutblue2.mdl", x, y, GetRandomReal(0, 359), 0.5, 1.75, 1, 255, 255, 255, 255))
                    endif
                    if r2 > 0.03 and r >= BambiettaR_CastTime then
                        set r2 = 0
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitInGroup(u, g2) == false then
                                call dmgmag(c, u, dmg)
                                call GroupAddUnit(g2, u)
                                call MUE(u, BambiettaR_PushRange, BambiettaR_PushDuration, GAngle3(x, y, u))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                    else
                        set r2 = r2 + 0.03
                    endif
                else
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call SetUnitTimeScale(c, 1)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    if BambiettaR_IsInvul then
                        call StopSpellUnit(c)
                    else
                        call StopSpellUnit2(c)
                    endif
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_BambiettaR[i] = m_BambiettaR[MUI_BambiettaR]
                    set MUI_BambiettaR = MUI_BambiettaR - 1
                    if MUI_BambiettaR == -1 then
                        call BambiettaTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BambiettaR_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_BambiettaR = MUI_BambiettaR + 1
            set m_BambiettaR[MUI_BambiettaR] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set r2 = 0
            if BambiettaR_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set k = 0
            set a = GAngle2(c, x, y)
            set rmax = BambiettaR_Duration
            call SetUnitAnimationByIndex(c, 2)
            call SetUnitTimeScale(c, 1.75)
            set k = GetRandomInt(1, 2)
            set e = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiblue.mdx", c, "hand left")
            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiblue.mdx", c, "hand right")
            if k == 1 then
                call MakeSound("war3mapimported\\Hero_Bambietta_R")
            elseif k == 2 then
                call MakeSound("war3mapimported\\Hero_Bambietta_R3")
            endif
            set aoe = BambiettaR_DamageAoe
            set dmg = GetHeroAgi(c, true) * (BambiettaR_DamageAgiBase + (BambiettaR_DamageAgiStep * (GetUnitAbilityLevel(c, BambiettaR_ID) - 1)))
            set k = 0
            if MUI_BambiettaR == 0 then
                call BambiettaTimer03Acquire()
            endif
        endmethod

        public static method Loop_BambiettaTR takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_BambiettaTR
                set this = m_BambiettaTR[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if BambiettaTR_IsInvul then
                        call DebugUnit(c)
                    else
                        call DebugUnit2(c)
                    endif
                    if r == 0.66 then
                        call MakeSound("war3mapimported\\Hero_Bambietta_TR2")
                    endif
                    if r == 0.63 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlashRed.mdl", x + 25 * Cos(a), y + 25 * Sin(a), 1, 1.15, 2.475, 225))
                    endif
                    if r == BambiettaTR_CastTime then
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        call SetUnitTimeScale(c, 0.2)
                        call DecorRemove(c, x, y, aoe, BambiettaTR_DecorDamage)
                        call EffectSpawn2("war3mapimported\\wos_chushou_by_wood_effect_huozhu_black.mdx", x, y, a * bj_RADTODEG, 1.25, 1.85, 1, 0.65)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (513)red.mdl", x, y, GetRandomReal(0, 359), 0.5, 1.55, 15))
                        set k = 0
                        loop
                            exitwhen k == 5
                            if k < 2 then
                                set scale = GetRandomReal(5, 7.5)
                            else
                                set scale = GetRandomReal(2.5, 4.5)
                            endif
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_m3 (460).mdl", x, y, GetRandomReal(0, 359), 1.5, scale, 350 * k))
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_tx-ha-chongfeng2.mdl", x - 500 * Cos(60 * k * bj_DEGTORAD), y - 500 * Sin(60 * k * bj_DEGTORAD), 60 * k, GetRandomReal(0.5, 0.75), 10.5, 10, 255, 255, 255, 65))
                            set k = k + 1
                        endloop
                    endif
                    if r2 > 0.03 and r >= BambiettaTR_CastTime then
                        set r2 = 0
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitInGroup(u, g2) == false then
                                call dmgmag(c, u, dmg)
                                call GroupAddUnit(g2, u)
                                call MUE(u, BambiettaTR_PushRange, BambiettaTR_PushDuration, GAngle3(x, y, u))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                    else
                        set r2 = r2 + 0.03
                    endif
                else
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call SetUnitTimeScale(c, 1)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    if BambiettaTR_IsInvul then
                        call StopSpellUnit(c)
                    else
                        call StopSpellUnit2(c)
                    endif
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_BambiettaTR[i] = m_BambiettaTR[MUI_BambiettaTR]
                    set MUI_BambiettaTR = MUI_BambiettaTR - 1
                    if MUI_BambiettaTR == -1 then
                        call BambiettaTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BambiettaTR_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_BambiettaTR = MUI_BambiettaTR + 1
            set m_BambiettaTR[MUI_BambiettaTR] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set r2 = 0
            if BambiettaTR_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set k = 0
            set a = GAngle2(c, x, y)
            set rmax = BambiettaTR_Duration
            call SetUnitAnimationByIndex(c, 1)
            call SetUnitTimeScale(c, 1.75)
            set k = GetRandomInt(1, 2)
            set e = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", c, "hand left")
            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", c, "hand right")
            if k == 1 then
                call MakeSound("war3mapimported\\Hero_Bambietta_TR")
            elseif k == 2 then
                call MakeSound("war3mapimported\\Hero_Bambietta_TR3")
            endif
            set aoe = BambiettaTR_DamageAoe
            set dmg = GetHeroAgi(c, true) * (BambiettaTR_DamageAgiBase + (BambiettaTR_DamageAgiStep * (GetUnitAbilityLevel(c, BambiettaR_ID) - 1)))
            set k = 0
            if MUI_BambiettaTR == 0 then
                call BambiettaTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct BambiettaSpells_T
        private static integer array m_BambiettaT
        private static integer MUI_BambiettaT = -1
        private static integer array m_BambiettaTT2
        private static integer MUI_BambiettaTT2 = -1
        private static integer array m_BambiettaTT
        private static integer MUI_BambiettaTT = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        integer k2
        real r3
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

        public static method Loop_BambiettaT takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real tmp_y = 0
            loop
                exitwhen i > MUI_BambiettaT
                set this = m_BambiettaT[i]
                if SpellBoolCaster(c) and r <= rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false then
                    if check == 0 or (check == 1 and IsUnitPaused(c) == false and GetUnitAbilityLevel(c, 'Avul') == 0) then
                        set r = r + 0.05
                    endif
                    set r = S2R(R2SW(r, 0, 3))
                    if check == 0 then
                        if r == 0.05 then
                            set e = EffectSpawn("war3mapImported\\wos_FantasyBattle (805)red.mdl", GetUnitX(c), GetUnitY(c), 1, 1, 3.25, 5)
                            set e2 = EffectSpawn("war3mapImported\\wos_FantasyBattle (804)_3red.mdl", GetUnitX(c), GetUnitY(c), 270, 1, 3, 0)
                            call EffectSpawn2("war3mapimported\\wos_Shio_Super_Saiyan_JN_ZiRed.mdx", GetUnitX(c), GetUnitY(c), 270, 1, 5.75, 10, rmax)
                            call EffectSpawn2("war3mapimported\\wos_Shio_Super_Saiyan_JN_ZiRed.mdx", GetUnitX(c), GetUnitY(c), 120, 1, 5.65, 15, rmax)
                        endif
                        if r == 0.65 then
                            call MakeSound("war3mapimported\\HeroBambietta_T2")
                        endif
                        if r >= 0 then
                            if r2 > 0.1 then
                                set r2 = 0
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_gnaden_air.mdl", x, y, GetRandomReal(0, 359), 0.4, 5, 1, 255, 25, 25, 255))
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_dustwave2221.mdx", x, y, GetRandomReal(0, 359), 0.85, 4, 1, 255, 25, 25, 50))
                            else
                                set r2 = r2 + 0.05
                            endif
                            if r3 > 0.35 then
                                set r3 = 0
                                if check2 == 0 then
                                    call DecorRemove(c, GetUnitX(c), GetUnitY(c), 650, BambiettaT_DecorDamage)
                                    set check2 = 1
                                endif
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_m3 (460).mdx", x, y, GetRandomReal(0, 359), 1.85, 3, 1))
                            else
                                set r3 = r3 + 0.05
                            endif
                        endif
                        if r == rmax - 1.2 then
                            call ColorDummy32(c, 0, 255, 255, 255, 0.6)
                        endif
                        if r == rmax - 0.3 then
                            call BlzSetUnitSkin(c, Bambietta2_ID)
                            call SetUnitVertexColor(c, 255, 255, 255, 0)
                            call ColorDummy4(c, 0, 255, 255, 255, 0.3)
                        endif
                        if r == rmax then
                            call DestroyEffect(e)
                            call DestroyEffect(e2)
                            set e = null
                            set e2 = null
                            call SetUnitVertexColor(c, 255, 255, 255, 255)
                            if BambiettaT_IsInvul then
                                call StopSpellUnit(c)
                            else
                                call StopSpellUnit2(c)
                            endif
                            set check = 1
                            call SaveInteger(hs, GetHandleId(c), StringHash("stack_count"), 2)
                            call MySpellStacks(c, 2, BambiettaG_CD)
                            set rmax = BambiettaT_Duration
                            if framebambietta_morph1[k2] == null then
                                set framebambietta_morph1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                                call BlzFrameSetAbsPoint(framebambietta_morph1[k2], FRAMEPOINT_CENTER, 0.055, 0.18 + tmp_y)
                                call BlzFrameSetSize(framebambietta_morph1[k2], 0.135, 0.035)
                                call BlzFrameSetTexture(framebambietta_morph1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                                call BlzFrameSetVisible(framebambietta_morph1[k2], false)
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(framebambietta_morph1[k2], true)
                                endif
                                set framebambietta_morph2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", framebambietta_morph1[k2], 0, 0)
                                call BlzFrameSetAbsPoint(framebambietta_morph2[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
                                call BlzFrameSetSize(framebambietta_morph2[k2], 0.1, 0.019)
                                set framebambietta_morph3[k2] = BlzCreateFrameByType("STATUSBAR", "", framebambietta_morph1[k2], "", 0)
                                call BlzFrameSetSize(framebambietta_morph3[k2], 0.1, 0.035)
                                call BlzFrameSetScale(framebambietta_morph3[k2], 0.5)
                                call BlzFrameSetModel(framebambietta_morph3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                                call BlzFrameSetAbsPoint(framebambietta_morph3[k2], FRAMEPOINT_CENTER, 0.05, 0.175 + tmp_y)
                                call BlzFrameSetMinMaxValue(framebambietta_morph3[k2], 0, rmax + 1)
                                call BlzFrameSetValue(framebambietta_morph3[k2], rmax)
                                set framebambietta_morph4[k2] = BlzCreateFrameByType("BACKDROP", "SS", framebambietta_morph1[k2], "", 0)
                                call BlzFrameSetAbsPoint(framebambietta_morph4[k2], FRAMEPOINT_CENTER, 0.005, 0.18 + tmp_y)
                                call BlzFrameSetSize(framebambietta_morph4[k2], 0.03, 0.03)
                                call BlzFrameSetTexture(framebambietta_morph4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Bambietta_T", 0, false)
                                set framebambietta_morph5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", framebambietta_morph1[k2], "", 0)
                                call BlzFrameSetAbsPoint(framebambietta_morph5[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
                                call BlzFrameSetText(framebambietta_morph5[k2], "|c00FFFF00" + "Morph Time Left:" + "|r")
                                call BlzFrameSetScale(framebambietta_morph5[k2], 0.9)
                                set framebambietta_morph6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", framebambietta_morph1[k2], "", 0)
                                call BlzFrameSetAbsPoint(framebambietta_morph6[k2], FRAMEPOINT_CENTER, 0.07, 0.17 + tmp_y)
                                call BlzFrameSetText(framebambietta_morph6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                                call BlzFrameSetScale(framebambietta_morph6[k2], 0.9)
                            else
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(framebambietta_morph1[k2], true)
                                endif
                                call BlzFrameSetMinMaxValue(framebambietta_morph3[k2], 0, rmax + 1)
                                call BlzFrameSetValue(framebambietta_morph3[k2], rmax)
                            endif
                            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t"), 1)
                            set r = 0
                            call BlzSetAbilityIcon(BambiettaQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Bambietta_TQ.blp")
                            call BlzSetAbilityIcon(BambiettaW_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Bambietta_TW.blp")
                            call BlzSetAbilityIcon(BambiettaE_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Bambietta_TE.blp")
                            call BlzSetAbilityIcon(BambiettaR_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Bambietta_TR.blp")
                            set check = 1
                        endif
                    elseif check == 1 then
                        call BlzFrameSetValue(framebambietta_morph3[k2], rmax - (r + 0.05))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(framebambietta_morph6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                    endif
                else
                    if check == 0 then
                        call PauseUnit(c, false)
                    endif
                    if e != null then
                        call DestroyEffect(e)
                        set e = null
                    endif
                    if e2 != null then
                        call DestroyEffect(e2)
                        set e2 = null
                    endif
                    call SaveInteger(hs, GetHandleId(c), StringHash("morph_end"), 1)
                    call AddSpellLevel(c, 'A01C', 20, false)
                    call SaveInteger(hs, GetHandleId(Player(k2)), StringHash("morph t"), 0)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), BambiettaT_ID, true)
                    call UnitRemoveAbility(c, BambiettaT2_ID)
                    if framebambietta_morph1[k2] != null then
                        if GetLocalPlayer() == GetOwningPlayer(c) then
                            call BlzFrameSetVisible(framebambietta_morph1[k2], false)
                        endif
                    endif
                    call BlzSetAbilityIcon(BambiettaQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Bambietta_Q.blp")
                    call BlzSetAbilityIcon(BambiettaW_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Bambietta_W.blp")
                    call BlzSetAbilityIcon(BambiettaE_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Bambietta_E.blp")
                    call BlzSetAbilityIcon(BambiettaR_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Bambietta_R.blp")
                    call BlzSetUnitSkin(c, Bambietta_ID)
                    call SetUnitTimeScale(c, 1)
                    call AAUniversalTooltips_SetUnitForm(c, 0)
                    set c = null
                    set m_BambiettaT[i] = m_BambiettaT[MUI_BambiettaT]
                    set MUI_BambiettaT = MUI_BambiettaT - 1
                    if MUI_BambiettaT == -1 then
                        call BambiettaTimer05Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BambiettaT_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_BambiettaT = MUI_BambiettaT + 1
            set m_BambiettaT[MUI_BambiettaT] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set r2 = 10
            set r3 = 10
            set check2 = 0
            set e = null
            set e2 = null
            set k2 = GetPlayerId(GetOwningPlayer(c))
            if BambiettaT_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            set check = 0
            set u = null
            call AddSpellLevel(c, 'A01C', 20, true)
            call SaveInteger(hs, GetHandleId(c), StringHash("morph_end"), 0)
            set a = GetUnitFacing(c) * bj_DEGTORAD
            set rmax = BambiettaT_CastTime
            call ReduceCooldown(c, BambiettaQ_ID, BambiettaT_ReduceCD)
            call ReduceCooldown(c, BambiettaW_ID, BambiettaT_ReduceCD)
            call ReduceCooldown(c, BambiettaE_ID, BambiettaT_ReduceCD)
            call ReduceCooldown(c, BambiettaR_ID, BambiettaT_ReduceCD)
            call BlzStartUnitAbilityCooldown(c, FakeAbi_ID, 0.01)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), BambiettaT_ID, false)
            call UnitAddAbility(c, BambiettaT2_ID)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), BambiettaT2_ID, true)

            // Смена формы СТРОГО ПОСЛЕ добавления BambiettaT2_ID
            call AAUniversalTooltips_SetUnitForm(c, 1)

            call VisionTimed(GetOwningPlayer(c), GetUnitX(c), GetUnitY(c), 1800, rmax)
            call SetUnitTimeScale(c, 0.9)
            call SetUnitAnimationByIndex(c, 1)
            call MakeSound("war3mapimported\\Hero_Bambietta_T")
            call MakeSound("war3mapimported\\Hero_Bambietta_T3")
            call NextSound("war3mapimported\\Hero_Bambietta_T2", 1.5)
            if MUI_BambiettaT == 0 then
                call BambiettaTimer05Acquire()
            endif
        endmethod

        public static method Loop_BambiettaTT2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_BambiettaTT2
                set this = m_BambiettaTT2[i]
                if SpellBoolCaster(c) and r < rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call MoveEff(e, move, a)
                    call BlzSetSpecialEffectHeight(e, BlzGetLocalSpecialEffectZ(e) - r5)
                else
                    set x = GetEffX(e)
                    set y = GetEffY(e)
                    call BlzSetSpecialEffectTimeScale(e, 1)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_chushou_by_wood_effect_fire_flamecrack3.mdl", x, y, a * bj_RADTODEG, 1.5, 4, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_AZ_D073red.mdl", x, y, a * bj_RADTODEG, 1.5, 1, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlashred.mdl", x + 25 * Cos(a), y + 25 * Sin(a), 1, 1.5, 1.775, 185))
                    call DecorRemove(c, x, y, aoe, BambiettaTT_DecorDamage)
                    call VisionTimed(GetOwningPlayer(c), x, y, 900, 2)
                    call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                            call dmgmag(c, u, dmg)
                            call GroupAddUnit(g2, u)
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop
                    set u = null
                    call DestroyGroup(g)
                    call DestroyEffect(e)
                    set g = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_BambiettaTT2[i] = m_BambiettaTT2[MUI_BambiettaTT2]
                    set MUI_BambiettaTT2 = MUI_BambiettaTT2 - 1
                    if MUI_BambiettaTT2 == -1 then
                        call BambiettaTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BambiettaTT2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            set MUI_BambiettaTT2 = MUI_BambiettaTT2 + 1
            set m_BambiettaTT2[MUI_BambiettaTT2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set r5 = 0
            set g = CreateGroup()
            set u = null
            set check2 = 0
            set a = GAngle2(c, x, y)
            set aoe = BambiettaTT_DamageAoe2
            set dmg = GetHeroAgi(c, true) * BambiettaTT_DamageAgiBase
            set rmax = 0.24
            set e = EffectSpawnScale("war3mapimported\\wos_3yifu_2red.mdx", GetUnitX(c) + 120 * Cos(GetUnitFacing(c) * bj_DEGTORAD), GetUnitY(c) + 120 * Sin(GetUnitFacing(c) * bj_DEGTORAD), a * bj_RADTODEG, 1, 1, 600, 0.12, 0.01, 1.5)
            set a = GAngle5(e, x, y)
            set move = SR5(e, x, y) / 8
            set r5 = 600 / 8
            if MUI_BambiettaTT2 == 0 then
                call BambiettaTimer03Acquire()
            endif
        endmethod

        public static method Loop_BambiettaTT takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr1 = 0
            local real rr2 = 0
            local real x2 = 0
            local real y2 = 0
            loop
                exitwhen i > MUI_BambiettaTT
                set this = m_BambiettaTT[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r < 0.9 then
                        if BambiettaT2_IsInvul then
                            call DebugUnit(c)
                        else
                            call DebugUnit2(c)
                        endif
                    endif
                    if r > 0.72 then
                        if GetMouseX(GetOwningPlayer(c)) != x1 then
                            set x1 = GetMouseX(GetOwningPlayer(c))
                            set y1 = GetMouseY(GetOwningPlayer(c))
                            set a = GAngle2(c, x1, y1)
                        endif
                        if r < rmax - 0.3 then
                            call SetUnitFacing(c, a * bj_RADTODEG)
                            call MoveUnit(c, move, a)
                            set x = GetUnitX(c)
                            set y = GetUnitY(c)
                            if r3 > 0.27 then
                                set r3 = 0
                                set check2 = 0
                            else
                                set r3 = r3 + 0.03
                            endif
                            if r2 > 0.0 and check2 < 3 then
                                set r2 = 0
                                set check2 = check2 + 1
                                if IntegerCd(c, "sound t cd", 0.8) then
                                    call MakeSound("war3mapimported\\Hero_Bambietta_E3")
                                endif
                                set rr2 = GetRandomReal(0, 359) * bj_DEGTORAD
                                set rr1 = GetRandomReal(BambiettaTT_DamageAoe2 - 300, BambiettaTT_DamageAoe)
                                set x2 = x + rr1 * Cos(rr2)
                                set y2 = y + rr1 * Sin(rr2)
                                call BambiettaTT2_Start(c, x2, y2)
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif
                    endif
                    if r == rmax - 0.3 then
                        call SetUnitAnimationByIndex(c, 4)
                    endif
                else
                    call SetUnitTimeScale(c, 1)
                    call DestroyGroup(g2)
                    call MouseOff(GetOwningPlayer(c))
                    call DestroyEffect(e)
                    if BambiettaT2_IsInvul then
                        call StopSpellUnit(c)
                    else
                        call StopSpellUnit2(c)
                    endif
                    set g = null
                    set g2 = null
                    set c = null
                    set u = null
                    set m_BambiettaTT[i] = m_BambiettaTT[MUI_BambiettaTT]
                    set MUI_BambiettaTT = MUI_BambiettaTT - 1
                    if MUI_BambiettaTT == -1 then
                        call BambiettaTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BambiettaTT_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_BambiettaTT = MUI_BambiettaTT + 1
            set m_BambiettaTT[MUI_BambiettaTT] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set r2 = 0
            set r3 = 0
            set r5 = 0
            set e = null
            if BambiettaT2_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            set k = 0
            set u = null
            set g = null
            set g2 = CreateGroup()
            set u = null
            set check2 = 0
            set a = GetUnitFacing(c) * bj_DEGTORAD
            set rmax = BambiettaTT_Duration
            set move = 40
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            set aoe = BambiettaTT_DamageAoe
            call SetUnitAnimationByIndex(c, 0)
            call SetUnitTimeScale(c, 1.45)
            set k = GetRandomInt(1, 2)
            set x1 = x + 500 * Cos(a)
            set y1 = y + 500 * Sin(a)
            call SetMouseX(GetOwningPlayer(c), x1)
            call SetMouseY(GetOwningPlayer(c), y1)
            call MouseOn(GetOwningPlayer(c))
            if k == 1 then
                call MakeSound("war3mapimported\\Hero_Bambietta_TT")
            elseif k == 2 then
                call MakeSound("war3mapimported\\Hero_Bambietta_TT3")
            endif
            if MUI_BambiettaTT == 0 then
                call BambiettaTimer03Acquire()
            endif
        endmethod
    endstruct

    private function BambiettaTimer03Loop takes nothing returns nothing
        call BambiettaSpells_Q.Loop_BambiettaQ()
        call BambiettaSpells_Q.Loop_BambiettaTQ2()
        call BambiettaSpells_Q.Loop_BambiettaTQ()
        call BambiettaSpells_W.Loop_BambiettaW2()
        call BambiettaSpells_W.Loop_BambiettaW()
        call BambiettaSpells_W.Loop_BambiettaTW2()
        call BambiettaSpells_W.Loop_BambiettaTW()
        call BambiettaSpells_E.Loop_BambiettaE2()
        call BambiettaSpells_E.Loop_BambiettaE()
        call BambiettaSpells_E.Loop_BambiettaTE2()
        call BambiettaSpells_E.Loop_BambiettaTE()
        call BambiettaSpells_R.Loop_BambiettaR()
        call BambiettaSpells_R.Loop_BambiettaTR()
        call BambiettaSpells_T.Loop_BambiettaTT2()
        call BambiettaSpells_T.Loop_BambiettaTT()
    endfunction

    private function BambiettaTimer05Loop takes nothing returns nothing
        call BambiettaSpells_T.Loop_BambiettaT()
    endfunction

    private function InitBambiettaSpells takes nothing returns nothing
        set BambiettaTimer03 = CreateTimer()
        set BambiettaTimer05 = CreateTimer()
        set BambiettaTimer03Callback = function BambiettaTimer03Loop
        set BambiettaTimer05Callback = function BambiettaTimer05Loop
    endfunction

    function BambiettaQ_Start takes unit c, real x, real y returns nothing
        if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) > 0 then
            call BambiettaSpells_Q.BambiettaTQ_Start(c, x, y)
        else
            call BambiettaSpells_Q.BambiettaQ_Start(c, x, y)
        endif
    endfunction

    function BambiettaW_Start takes unit c returns nothing
        if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) > 0 then
            call BambiettaSpells_W.BambiettaTW_Start(c)
        else
            call BambiettaSpells_W.BambiettaW_Start(c)
        endif
    endfunction

    function BambiettaE_Start takes unit c, real x, real y returns nothing
        if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) > 0 then
            call BambiettaSpells_E.BambiettaTE_Start(c, x, y)
        else
            call BambiettaSpells_E.BambiettaE_Start(c, x, y)
        endif
    endfunction

    function BambiettaR_Start takes unit c returns nothing
        if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) > 0 then
            call BambiettaSpells_R.BambiettaTR_Start(c)
        else
            call BambiettaSpells_R.BambiettaR_Start(c)
        endif
    endfunction

    function BambiettaT_Start takes unit c returns nothing
        call BambiettaSpells_T.BambiettaT_Start(c)
    endfunction

    function BambiettaT2_Start takes unit c returns nothing
        call BambiettaSpells_T.BambiettaTT_Start(c)
    endfunction

    function BambiettaG_Start takes unit c returns nothing
        if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) == 0 then
            call FakeCD_Start(c, BambiettaG_ID, BambiettaG_CD, 0, 0)
        else
            call MyRemoveStack(c)
            if LoadInteger(hs, GetHandleId(c), StringHash("stack_count")) == 0 then
                call FakeCD_Start(c, BambiettaG_ID, BambiettaG_CD, 0, 0)
            endif
        endif
    endfunction

    function BambiettaG2_Start takes unit c, real x, real y returns nothing
        local group g = CreateGroup()
        local unit u = null
        local real a = GAngle2(c, x, y)
        local real aoe = 400
        local real dmg = 0
        call MakeSound("war3mapimported\\Hero_Bambietta_G")
        if GetHeroLevel(c) >= 35 then
            set dmg = BambiettaG_DamageAgiBase35 * GetHeroAgi(c, true)
        elseif GetHeroLevel(c) >= 25 then
            set dmg = BambiettaG_DamageAgiBase25 * GetHeroAgi(c, true)
        else
            set dmg = BambiettaG_DamageAgiBase12 * GetHeroAgi(c, true)
        endif
        if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph t")) == 0 then
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_AZ_D073.mdl", x, y, a * bj_RADTODEG, 1.35, 1, 1))
            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_A_P.blast3.mdl", x, y, a * bj_RADTODEG, 2.15, 1, 1), 0.15, 255, 255, 255, 0.45)
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlash.mdl", x + 25 * Cos(a), y + 25 * Sin(a), 1, 1.15, 1.475, 125))
        else
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_AZ_D073red.mdl", x, y, a * bj_RADTODEG, 1.35, 1, 1))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlashred.mdl", x + 25 * Cos(a), y + 25 * Sin(a), 1, 1.15, 1.475, 125))
            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_A_P.blast3red.mdl", x, y, a * bj_RADTODEG, 2.15, 1, 1), 0.15, 255, 255, 255, 0.45)
        endif
        call VisionTimed(GetOwningPlayer(c), x, y, 700, 1.5)
        call DecorRemove(c, x, y, aoe, BambiettaG_DecorDamage)
        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                call NextDmg(c, u, dmg, 0, 0.1)
            endif
            call GroupRemoveUnit(g, u)
        endloop
        call DestroyGroup(g)
        set u = null
        set g = null
    endfunction
endlibrary