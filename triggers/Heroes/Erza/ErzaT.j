library ErzaTSpells uses GearSystems
    globals
//--------------------------------------Erza--------------------------------------------------------------
//---------------Q ability-----------------------------------------------------
        integer Erza5Q_ID = 'A03N'
        real Erza5Q_DamageAgiBase = 6 // base number x Agi damage for 1 level
        real Erza5Q_DamageAoe = 375
//---------------W ability-----------------------------------------------------
        integer Erza5W_ID = 'A03O'
        real Erza5W_DamageAgiBase = 7 // base number x Agi damage for 1 level
        real Erza5W_Range = 1700 // when increase range also increase damageaoe for half of added amount, example if increase range by 200, increase aoe by 100
        real Erza5W_DamageAoe = 650 // dont make lower than 475
//---------------E ability-----------------------------------------------------
        integer Erza5E_ID = 'A03P'
        real Erza5E_DamageAgiBase = 7 // base number x Agi damage for 1 level
        real Erza5E_DamageAoe = 555
//---------------R ability-----------------------------------------------------
        integer Erza5R_ID = 'A03Q'
        real Erza5R_DamageAgiBase = 8 // base number x Agi damage per 1 second
        real Erza5R_DamageAoe = 600
        integer Erza5R_Dummy = 'h00N'
//---------------T ability-----------------------------------------------------
        integer Erza5T_ID = 'A03R'
        real Erza5T_DamageAgiBase = 10 // base number x Agi damage for 1 level
        real Erza5T_Stun = 0.5 // from 0.1 to 3
        real Erza5T_DamageAoe = 250 
//---------------F ability-----------------------------------------------------
        integer Erza5F_ID = 'A03S'
        real Erza5F_DamageAgiBase = 4 // base number x Agi damage for 1 level
        real Erza5F_DamageAoe = 600
//---------------Elemental absorb-----------------------------------------------------        
        real Erza5ElementAbsorb_Duration = 15 // in seconds , buff duration time
        real Erza5_AddSpellDamage_1Element = 0.75 // x agi if consume only 1 element
        real Erza5_AddSpellDamage_2Element = 1.5 // x agi if consume 2 elements(max)
    endglobals
     

        private function PassiveType takes integer check2, integer check3 returns integer
            local integer check4 = 0
            if check2 > 0 and check2 == check3 then
                set check4 = check2
            elseif check2 > 0 and check3 > 0 then
                if check2 == 1 and check3 == 2 then
                    set check4 = 4
                endif
                if check2 == 1 and check3 == 3 then
                    set check4 = 5
                endif
                if check2 == 2 and check3 == 1 then
                    set check4 = 4
                endif
                if check2 == 2 and check3 == 3 then
                    set check4 = 6
                endif
                if check2 == 3 and check3 == 1 then
                    set check4 = 5
                endif
                if check2 == 3 and check3 == 2 then
                    set check4 = 6
                endif
            elseif check2 > 0 then
                set check4 = check2
            endif
            return check4
        endfunction

    private struct Erza5Q_KS
        private static timer t_ErzaQ = CreateTimer( )
        private static integer array m_ErzaQ
        private static integer MUI_ErzaQ = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k
        real r4
        real r5
        group g
        real array ms [20]
        unit u
        real dmg
        integer check
        integer check2
        integer check3
        integer check4
        real aoe
        real move
        real r
        effect array ee[20]
        real a
        real rmax
        private static method Loop_ErzaQ takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real random
            loop
                exitwhen i > MUI_ErzaQ
                set this = m_ErzaQ[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    if check < 2 then
                        set a = GAngle(c, td)
                        call SetUnitFacing(c, a * bj_RADTODEG)
                    endif
                    if check == 0 then
                        if r == 0.21 then
                            call SetUnitTimeScale(c, 0.5)
                            set r2 = 10
                        endif
                        if r == 0.3 then
                            call MakeSound("war3mapImported\\Hero_Erza5_Q03")
                        endif
                        if r == 0.42 then
                            set k = 0
                            loop
                                exitwhen k > 4
                                call DestroyEffect(ee[k])
                                call BlzSetSpecialEffectTimeScale(ee[k], 0.4)
                                set k = k + 1
                            endloop
                        endif
                        if r > 0.42 then
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            set k = 0
                            loop
                                exitwhen k > 4
                                if k != 2 then
                                    if ee[k] != null and SR5(ee[k], x, y) > ms[k] then
                                        set r5 = GAngle5(ee[k], x, y)
                                        call BlzSetSpecialEffectYaw(ee[k], r5)
                                        call MoveEff(ee[k], ms[k], r5)
                                    else
                                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", x, y, r5 * bj_RADTODEG + 180, 1, 1.5, 80))
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", td, "chest"))
                                        call ColorEffDummy3(ee[k], 0, 255, 255, 255, 0.15)
                                        call StunUnit(c, td, 0.2)
                                        set ee[k] = null
                                    endif
                                endif
                                set k = k + 1
                            endloop
                            if SR2(c, td) > move * 1.25 then
                                call MoveUnit(c, move, a)
                                if r2 > 0.09 then
                                    set r2 = 0
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 0.5, 3.75, 75))
                                else
                                    set r2 = r2 + 0.03
                                endif
                            else
                                set check = 1
                                set r = 0
                                set rmax = 0.03
                                call SetUnitTimeScale(c, 1)
                                call MakeSound("war3mapImported\\Hero_Erza5_Q02")
                                call PosUnit(td, GetUnitX(c) + 130 * Cos(a), GetUnitY(c) + 130 * Sin(a))
                                set k = 0
                                loop
                                    exitwhen k > 4
                                    if k != 2 then
                                        set r5 = GAngle5(ee[k], x, y)
                                        call BlzSetSpecialEffectYaw(ee[k], r5)
                                        call EMUE(ee[k], 400, 0.35, r5)
                                    endif
                                    set k = k + 1
                                endloop
                            endif
                        endif
                    elseif check == 1 then
                    call DebugUnit2(c)
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        if r == rmax then
                            call SetUnitAnimation(td, "death")
                            call MUE(c, 600, 0.4, a)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.1, 3, 9))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.1, 4, 9))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.1, 5, 9))
                            if check2 > 0 then
                                if check2 > 0 and check3 > 0 then
                                    if check2 == 1 then
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_fire explosion.mdl", x, y, GetRandomReal(0, 359), 1, 1.45, 105))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-fire.mdl", x, y, a * bj_RADTODEG + 45, 0.75, 1.2, 195))
                                    elseif check2 == 2 then
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdl", x, y, GetRandomReal(0, 359), 0.75, 1.75, 1))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, a * bj_RADTODEG + 45, 0.75, 1.2, 195))
                                    elseif check2 == 3 then
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_SasukeYh-41.mdl", x, y, GetRandomReal(0, 359), 1.5, 4, 75))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-water_ice.mdl", x, y, a * bj_RADTODEG + 45, 0.75, 1.2, 195))
                                    endif
                                    if check3 == 1 then
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_fire explosion.mdl", x, y, GetRandomReal(0, 359), 1, 1.45, 105))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-fire.mdl", x, y, a * bj_RADTODEG - 45, 0.75, 1.2, 195))
                                    elseif check3 == 2 then
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdl", x, y, GetRandomReal(0, 359), 0.75, 1.75, 1))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, a * bj_RADTODEG - 45, 0.75, 1.2, 195))
                                    elseif check3 == 3 then
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_SasukeYh-41.mdl", x, y, GetRandomReal(0, 359), 1.5, 4, 75))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-water_ice.mdl", x, y, a * bj_RADTODEG - 45, 0.75, 1.2, 195))
                                    endif
                                elseif check2 > 0 and check3 == 0 then
                                    if check2 == 1 then
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_fire explosion.mdl", x, y, GetRandomReal(0, 359), 1, 1.45, 105))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-fire.mdl", x, y, a * bj_RADTODEG + 45, 0.75, 1.2, 195))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-fire.mdl", x, y, a * bj_RADTODEG - 45, 0.75, 1.2, 195))
                                    elseif check2 == 2 then
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdl", x, y, GetRandomReal(0, 359), 0.75, 1.75, 1))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, a * bj_RADTODEG + 45, 0.75, 1.2, 195))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, a * bj_RADTODEG - 45, 0.75, 1.2, 195))
                                    elseif check2 == 3 then
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_SasukeYh-41.mdl", x, y, GetRandomReal(0, 359), 1.5, 4, 75))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-water_ice.mdl", x, y, a * bj_RADTODEG + 45, 0.75, 1.2, 195))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-water_ice.mdl", x, y, a * bj_RADTODEG - 45, 0.75, 1.2, 195))
                                    endif
                                endif
                            else
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, a * bj_RADTODEG + 45, 0.75, 1.2, 195))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, a * bj_RADTODEG - 45, 0.75, 1.2, 195))
                            endif
                            call StopSpellUnit2(c)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x, y, a * bj_RADTODEG, 0.5, 5, 50))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_1hongse_2blue.mdl", x, y, 1, 1.75, 2.95, 11))
                            call DecorRemove(c,x,y,aoe,50)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call dmgphys(c, u, dmg)
                                    if check4 > 0 then
                                        call ErzaPassive(c, u, check4)
                                    endif
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        endif
                    endif
                else
                    set k = 0
                    loop
                        exitwhen k > 4
                        if k != 2 then
                            if ee[k] != null then
                                call ColorEffDummy3(ee[k], 0, 255, 255, 255, 0.15)
                                set ee[k] = null
                            endif
                        endif
                        set k = k + 1
                    endloop
                    if check > 0 then
                        call StopSpellUnit2(td)
                    endif
                    call StopSpellUnit2(c)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set td = null
                    set u = null
                    set m_ErzaQ[i] = m_ErzaQ[MUI_ErzaQ]
                    set MUI_ErzaQ = MUI_ErzaQ - 1
                    if MUI_ErzaQ == -1 then
                        call PauseTimer( t_ErzaQ )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaQ_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaQ = MUI_ErzaQ + 1
            set m_ErzaQ[MUI_ErzaQ] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set r2 = 0
            set check = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set a = GAngle(c, td) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = Erza5Q_DamageAoe
            set dmg = GetHeroAgi(c, true) * Erza5Q_DamageAgiBase
            set rmax = 5
            set check2 = 0
            set check3 = 0
            set check4 = 0
            if LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2")) == 0 then
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt"))
                set dmg = dmg + (GetHeroAgi(c, true) * Erza5_AddSpellDamage_1Element)
            endif
            if LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt")) == 0 then
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2"))
                set dmg = dmg + (GetHeroAgi(c, true) * Erza5_AddSpellDamage_1Element)
            endif
            if LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt")) > 0 then
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt"))
                set check3 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2"))
                set dmg = dmg + GetHeroAgi(c, true) * Erza5_AddSpellDamage_2Element
            endif
            set check4 = PassiveType(check2, check3)
            set move = 125
            set k = 0
            set r5 = -350
            set r4 = 175
            loop
                exitwhen k > 4
                if k != 2 then
                    set ee[k] = EffectSpawn("war3mapimported\\wos_Erza_sword2.mdx", (GetUnitX(c) - 150 * Cos(a)) + r5 * Cos(a - 90 * bj_DEGTORAD), (GetUnitY(c) - 150 * Sin(a)) + r5 * Sin(a - 90 * bj_DEGTORAD), a * bj_RADTODEG, GetRandomReal(0.85, 1.25), 0.66, r4)
                    set ms[k] = move + GetRandomReal(15, 75)
                    if check2 > 0 and check3 > 0 then
                        if k < 2then
                            if check2 == 1 then
                                call BlzSetSpecialEffectColor(ee[k], 255, 185, 25)
                            elseif check2 == 2 then
                                call BlzSetSpecialEffectColor(ee[k], 95, 185, 255)
                            elseif check2 == 3 then
                                call BlzSetSpecialEffectColor(ee[k], 55, 255, 255)
                            endif
                        elseif k > 2 then
                            if check3 == 1 then
                                call BlzSetSpecialEffectColor(ee[k], 255, 185, 25)
                            elseif check3 == 2 then
                                call BlzSetSpecialEffectColor(ee[k], 95, 185, 255)
                            elseif check3 == 3 then
                                call BlzSetSpecialEffectColor(ee[k], 55, 255, 255)
                            endif
                        endif
            
                    elseif check2 > 0 and check3 == 0 then
                        if check2 == 1 then
                            call BlzSetSpecialEffectColor(ee[k], 255, 185, 25)
                        elseif check2 == 2 then
                            call BlzSetSpecialEffectColor(ee[k], 95, 185, 255)
                        elseif check2 == 3 then
                            call BlzSetSpecialEffectColor(ee[k], 55, 255, 255)
                        endif
                    endif
                endif
                set k = k + 1            
                if k < 3 then
                    set r4 = r4 + 55
                else
                    set r4 = r4 - 55
                endif
                set r5 = r5 + 175
            endloop
            call SetUnitTimeScale(c, 1)
            call SetUnitAnimationByIndex(c, 10)
            call MakeSound("war3mapImported\\Hero_Erza5_Q01")
            if MUI_ErzaQ == 0 then
                call TimerStart( t_ErzaQ, 0.03, true, function thistype.Loop_ErzaQ )
            endif
        endmethod
    endstruct

    private struct Erza5W_KS
        private static timer t_ErzaW = CreateTimer( )
        private static integer array m_ErzaW
        private static integer MUI_ErzaW = -1
        unit c
        real x
        real y
        integer k
        integer k2
        real r5
        group g
        real array ms [20]
        group g2
        unit u
        real dmg
        integer check2
        integer check3
        integer check4
        real aoe
        real r
        effect e
        effect array ee[20]
        real a
        real rmax
        private static method Loop_ErzaW takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaW
                set this = m_ErzaW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if r == 0.39 then
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        call SetUnitAnimationByIndex(c, 3)
                        call SetUnitTimeScale(c, 3.15)
                        call VisionTimed(GetOwningPlayer(c), GetEffX(e), GetEffY(e), 1050, rmax + 1.5 - r)
                        set a = 0
                        set k = 0
                        set r5 = 300
                        loop
                            exitwhen k > 15
                            set ee[k] = EffectSpawn("war3mapimported\\wos_Erza_sword2.mdx", GetUnitX(c) + r5 * Cos(k * 24 * bj_DEGTORAD), GetUnitY(c) + r5 * Sin(k * 24 * bj_DEGTORAD), k * 24, 1, 0.8, 315)
                            if check2 > 0 and check3 > 0 then
                                if ModuloInteger(k, 2) == 0 then
                                    if check2 == 1 then
                                        call BlzSetSpecialEffectColor(ee[k], 255, 185, 25)
                                    elseif check2 == 2 then
                                        call BlzSetSpecialEffectColor(ee[k], 95, 185, 255)
                                    elseif check2 == 3 then
                                        call BlzSetSpecialEffectColor(ee[k], 55, 255, 255)
                                    endif
                                else
                                    if check3 == 1 then
                                        call BlzSetSpecialEffectColor(ee[k], 255, 185, 25)
                                    elseif check3 == 2 then
                                        call BlzSetSpecialEffectColor(ee[k], 95, 185, 255)
                                    elseif check3 == 3 then
                                        call BlzSetSpecialEffectColor(ee[k], 55, 255, 255)
                                    endif
                                endif
                            elseif check2 > 0 and check3 == 0 then
                                if check2 == 1 then
                                    call BlzSetSpecialEffectColor(ee[k], 255, 185, 25)
                                elseif check2 == 2 then
                                    call BlzSetSpecialEffectColor(ee[k], 95, 185, 255)
                                elseif check2 == 3 then
                                    call BlzSetSpecialEffectColor(ee[k], 55, 255, 255)
                                endif
                            endif
                            set ms[k] = Erza5W_Range / 20
                            set k = k + 1
                        endloop
                    endif
                    if r > 0.39 and r < 1.8 then
                        set a = a + 6 * bj_DEGTORAD
                        set k = 0
                        loop
                            exitwhen k > 15
                            call BlzSetSpecialEffectPosition(ee[k], x + r5 * Cos(k * 24 * bj_DEGTORAD + a), y + r5 * Sin(k * 24 * bj_DEGTORAD + a), 315 + r5 * Sin(k * 24 * bj_DEGTORAD + a))
                            call BlzSetSpecialEffectYaw(ee[k], k * 24 * bj_DEGTORAD + a)
                            set k = k + 1
                        endloop
                    endif
                    if r == 1.68 then
                        set k = 0
                        set k2 = 0
                        call MakeSound("war3mapImported\\Hero_Erza5_W2")
                        loop
                            exitwhen k > 15
                            call DestroyEffect(ee[k])
                            call BlzSetSpecialEffectTimeScale(ee[k], 0.5)
                            set k = k + 1
                        endloop
                    endif
                    if r == 2.01 then
                        set k = 0
                        loop
                            exitwhen k > 15
                            call BlzSetSpecialEffectTimeScale(ee[k], 0.05)
                            set k = k + 1
                        endloop
                    endif
                    if r == 2.1 then
                        call StopSpellUnit(c)
                    endif
                    if r >= 1.8 and r != 9999 then
                        set k = 0
                        if aoe< 320 then
                        set aoe = aoe + 10
                        endif
                        loop
                            exitwhen k > 15
                            call MoveEff2(ee[k], ms[k], k * 24 * bj_DEGTORAD + a)
                            if BlzGetLocalSpecialEffectZ(ee[k]) > 150 then
                                call BlzSetSpecialEffectZ(ee[k], BlzGetLocalSpecialEffectZ(ee[k]) - 33)
                            endif
                            if ModuloInteger(k, 2) == 0 then
                                call GroupClear( g )
                                call DecorRemove(c,GetEffX(ee[k]), GetEffY(ee[k]) ,aoe,50)
                                call GroupEnumUnitsInRange( g , GetEffX(ee[k]), GetEffY(ee[k]) , aoe , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                        call dmgphys(c, u, dmg)
                                        set k2 = k2 + 1
                                        if k2 == 1 then
                                            call MakeSound("war3mapImported\\Hero_Erza5_W3")
                                        endif
                                        if check4 > 0 then
                                            call ErzaPassive(c, u, check4)
                                        endif
                                        call GroupAddUnit(g2, u)
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_Opdef (571)2.mdl", GetUnitX(u), GetUnitY(u), 0, 1, 1.5, 76))
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                            endif
                            set k = k + 1
                        endloop
                    endif
                else
                    set k = 0
                    loop
                        exitwhen k > 15
                        call ColorEffDummy3(ee[k], 0, 255, 255, 255, 0.09)
                        set ee[k] = null
                        set k = k + 1
                    endloop
                    if r < 2.22 then
                        call StopSpellUnit(c)
                    endif
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set c = null
                    set g = null
                    set g2 = null
                    set m_ErzaW[i] = m_ErzaW[MUI_ErzaW]
                    set MUI_ErzaW = MUI_ErzaW - 1
                    if MUI_ErzaW == -1 then
                        call PauseTimer( t_ErzaW )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaW_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaW = MUI_ErzaW + 1
            set m_ErzaW[MUI_ErzaW] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set aoe = Erza5W_DamageAoe
            set g = CreateGroup()
            set g2 = CreateGroup()
            set rmax = 2.1
            set check2 = 0
            set check3 = 0
            set check4 = 0
            call StartSpellUnit(c)
            set dmg = GetHeroAgi(c, true) * Erza5W_DamageAgiBase
            if LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2")) == 0 then
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt"))
                set dmg = dmg + GetHeroAgi(c, true) * Erza5_AddSpellDamage_1Element
            endif
            if LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt")) == 0 then
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2"))
                set dmg = dmg + GetHeroAgi(c, true) * Erza5_AddSpellDamage_1Element
            endif
            if LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt")) > 0 then
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt"))
                set check3 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2"))
                set dmg = dmg + GetHeroAgi(c, true) * Erza5_AddSpellDamage_2Element
            endif
            set check4 = PassiveType(check2, check3)
            call SetUnitAnimationByIndex(c, 6)
            call SetUnitTimeScale(c, 1)
            call MakeSound("war3mapImported\\Hero_Erza5_W02")
            if MUI_ErzaW == 0 then
                call TimerStart( t_ErzaW, 0.03, true, function thistype.Loop_ErzaW )
            endif
        endmethod
    endstruct

    private struct Erza5E_KS
        private static timer t_ErzaE = CreateTimer( )
        private static integer array m_ErzaE
        private static integer MUI_ErzaE = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        real r3
        group g
        group g2
        unit u
        real dmg
        integer check2
        integer check3
        integer check4
        real aoe
        real move
        real r
        real a
        real rmax
        private static method Loop_ErzaE takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaE
                set this = m_ErzaE[i]
                if SpellBoolCaster(c) and r < rmax then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    if r == 0.45 then
                        call SetUnitTimeScale(c, 0.65)
                        call SetUnitAnimationByIndex(c, 14)
                        if r2 > 0.08 then
                            set r2 = 0
                            set x = x + 150 * Cos(a)
                            set y = y + 150 * Sin(a)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_blue-texiao-buff2.mdl", x, y, GetRandomReal(0, 359), 1.95, 5.25, 0))
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                    if r > 0.45 then
                    if r< rmax then 
                    set a = GAngle2(c,x1,y1)
                    endif
                        call MoveUnit(c, move, a)
                        if r == rmax - 0.15 then
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_HakkeStart.mdx", x1, y1, GetRandomReal(0, 359), 1.35, 1.65, 8, 255, 255, 255, 1555))
                        endif
                        if r == rmax then
                            call MUE(c, 650, 0.4, a)
                            if check2 > 0 then
                                if check2 > 0 and check3 > 0 then
                                    if check2 == 1 then
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_fire explosion.mdl", x, y, GetRandomReal(0, 359), 1, 1.45, 105))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_fire2.mdl", x, y, a * bj_RADTODEG, 0.75, 4.25, 225))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-fire.mdl", x + 300 * Cos(a + 90 * bj_DEGTORAD), y + 300 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 250, 0.5, 0.95, 185))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-fire.mdl", x - 300 * Cos(a + 90 * bj_DEGTORAD), y - 300 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 125, 0.5, 0.95, 185))
                                    elseif check2 == 2 then
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdl", x, y, GetRandomReal(0, 359), 0.75, 1.75, 1))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x + 300 * Cos(a + 90 * bj_DEGTORAD), y + 300 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 250, 0.5, 0.95, 185))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x - 300 * Cos(a + 90 * bj_DEGTORAD), y - 300 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 125, 0.5, 0.95, 185))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_22.mdl", x, y, a * bj_RADTODEG, 0.75, 4.25, 225))
                                    elseif check2 == 3 then
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_SasukeYh-41.mdl", x, y, GetRandomReal(0, 359), 1.5, 4, 75))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-water_ice.mdl", x + 300 * Cos(a + 90 * bj_DEGTORAD), y + 300 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 250, 0.5, 0.95, 185))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-water_ice.mdl", x - 300 * Cos(a + 90 * bj_DEGTORAD), y - 300 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 125, 0.5, 0.95, 185))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_lightning2.mdl", x, y, a * bj_RADTODEG, 0.75, 4.25, 225))
                                    endif
                                    if check3 == 1 then
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_fire2.mdl", x, y, a * bj_RADTODEG + 180, 0.85, 3.5, 225))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_fire explosion.mdl", x, y, GetRandomReal(0, 359), 1, 1.45, 105))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-fire.mdl", x - 300 * Cos(a), y - 300 * Sin(a), a * bj_RADTODEG, 0.5, 0.95, 185))
                                    elseif check3 == 2 then
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdl", x, y, GetRandomReal(0, 359), 0.75, 1.75, 1))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x - 300 * Cos(a), y - 300 * Sin(a), a * bj_RADTODEG, 0.5, 0.95, 185))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_22.mdl", x, y, a * bj_RADTODEG + 180, 0.85, 3.5, 225))
                                    elseif check3 == 3 then
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_SasukeYh-41.mdl", x, y, GetRandomReal(0, 359), 1.5, 4, 75))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-water_ice.mdl", x - 300 * Cos(a), y - 300 * Sin(a), a * bj_RADTODEG, 0.5, 0.95, 185))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_lightning2.mdl", x, y, a * bj_RADTODEG + 180, 0.85, 3.5, 225))
                                    endif
            
                                elseif check2 > 0 and check3 == 0 then
                                    if check2 == 1 then
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_fire explosion.mdl", x, y, GetRandomReal(0, 359), 1, 1.45, 105))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-fire.mdl", x - 300 * Cos(a), y - 300 * Sin(a), a * bj_RADTODEG, 0.5, 0.95, 185))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-fire.mdl", x + 300 * Cos(a + 90 * bj_DEGTORAD), y + 300 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 250, 0.5, 0.95, 185))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-fire.mdl", x - 300 * Cos(a + 90 * bj_DEGTORAD), y - 300 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 125, 0.5, 0.95, 185))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_fire2.mdl", x, y, a * bj_RADTODEG, 0.75, 4.25, 225))
                                    elseif check2 == 2 then
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdl", x, y, GetRandomReal(0, 359), 0.75, 1.75, 1))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x - 300 * Cos(a), y - 300 * Sin(a), a * bj_RADTODEG, 0.5, 0.95, 185))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x + 300 * Cos(a + 90 * bj_DEGTORAD), y + 300 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 250, 0.5, 0.95, 185))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x - 300 * Cos(a + 90 * bj_DEGTORAD), y - 300 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 125, 0.5, 0.95, 185))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_22.mdl", x, y, a * bj_RADTODEG, 0.75, 4.25, 225))
                                    elseif check2 == 3 then
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_SasukeYh-41.mdl", x, y, GetRandomReal(0, 359), 1.5, 4, 75))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-water_ice.mdl", x - 300 * Cos(a), y - 300 * Sin(a), a * bj_RADTODEG, 0.5, 0.95, 185))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-water_ice.mdl", x + 300 * Cos(a + 90 * bj_DEGTORAD), y + 300 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 250, 0.5, 0.95, 185))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-water_ice.mdl", x - 300 * Cos(a + 90 * bj_DEGTORAD), y - 300 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 125, 0.5, 0.95, 185))
                                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_lightning2.mdl", x, y, a * bj_RADTODEG, 0.75, 4.25, 225))
                                    endif
                                endif
                            else
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x - 300 * Cos(a), y - 300 * Sin(a), a * bj_RADTODEG, 0.5, 0.95, 185))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x + 300 * Cos(a + 90 * bj_DEGTORAD), y + 300 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 250, 0.5, 0.95, 185))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x - 300 * Cos(a + 90 * bj_DEGTORAD), y - 300 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 125, 0.5, 0.95, 185))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2.mdl", x, y, a * bj_RADTODEG, 0.75, 4.25, 225))
                            endif
                            call GroupClear(g)
                            call DecorRemove(c,x,y,aoe,80)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call dmgmag(c, u, dmg)
                                    if check4 > 0 then
                                        call ErzaPassive(c, u, check4)
                                    endif
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_Opdef (571)2.mdl", GetUnitX(u), GetUnitY(u), 0, 1, 1.5, 76))
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        endif                        
                        if r3 > 0.03 then
                            set r3 = 0
                            set x = x + 150 * Cos(a)
                            set y = y + 150 * Sin(a)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x, y, a * bj_RADTODEG, 0.5, 2.5, 75))
                        else
                            set r3 = r3 + 0.03
                        endif
                    endif
                else
                    call StopSpellUnit2(c)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set c = null
                    set m_ErzaE[i] = m_ErzaE[ MUI_ErzaE]
                    set MUI_ErzaE = MUI_ErzaE - 1
                    if MUI_ErzaE == -1 then
                        call PauseTimer( t_ErzaE)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaE_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            local integer k3 = 0
            set MUI_ErzaE = MUI_ErzaE + 1
            set m_ErzaE[ MUI_ErzaE] = this
            set c = NewC
            set r = 0
            set x = NewX
            set y = NewY
            set x1 = NewX
            set y1 = NewY
            set r2 = 10
            set r3 = 10
            set g = CreateGroup()
            set g2 = CreateGroup()
            set check2 = 0
            set check3 = 0
            set dmg = GetHeroAgi(c, true) * Erza5E_DamageAgiBase
            if LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2")) == 0 then
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt"))
                set dmg = dmg + GetHeroAgi(c, true) * Erza5_AddSpellDamage_1Element
            endif
            if LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt")) == 0 then
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2"))
                set dmg = dmg + GetHeroAgi(c, true) * Erza5_AddSpellDamage_1Element
            endif
            if LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt")) > 0 then
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt"))
                set check3 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2"))
                set dmg = dmg + GetHeroAgi(c, true) * Erza5_AddSpellDamage_2Element
            endif
            set check4 = PassiveType(check2, check3)
            call StartSpellUnit2(c)
            set aoe = Erza5E_DamageAoe
            set a = GAngle2( c , x, y ) // Angle Between points
            set k3 = 7
            set rmax = 0.48+ k3*0.03
            set move = SR3(c, x, y) / k3
            call MakeSound("war3mapImported\\Hero_Erza5_E3")
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SetUnitAnimationByIndex( c , 6)
            call SetUnitTimeScale( c , 1)
            call VisionTimed(GetOwningPlayer(c), x, y, 750, 6)
            if MUI_ErzaE == 0 then
                call TimerStart( t_ErzaE, 0.03, true, function thistype.Loop_ErzaE)
            endif
        endmethod
    endstruct

    private struct Erza5R2_KS
        private static timer t_ErzaR2 = CreateTimer( )
        private static integer array m_ErzaR2
        private static integer MUI_ErzaR2 = -1
        unit d
        unit d2
        unit c
        real x
        real y
        integer k
        real r3
        real r4
        real r5
        integer check2
        integer check3
        real r
        real a
        real rmax
        private static method Loop_ErzaR2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaR2
                set this = m_ErzaR2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if r > 0.24 then
                        call MoveUnit(d, r3, a)
                        call MoveUnit(d2, r4, a)
                    endif
                else
                    if check2 > 0 then
                        if check2 > 0 and check3 > 0 then
                            if check2 == 1 then
                                call ColorDummy3(d, 0, 255, 185, 25, 0.15)
                            elseif check2 == 2 then
                                call ColorDummy3(d, 0, 95, 185, 255, 0.15)
                            elseif check2 == 3 then
                                call ColorDummy3(d, 0, 55, 255, 255, 0.15)
                            endif
                            if check3 == 1 then
                                call ColorDummy3(d2, 0, 255, 185, 25, 0.15)
                            elseif check3 == 2 then
                                call ColorDummy3(d2, 0, 95, 185, 255, 0.15)
                            elseif check3 == 3 then
                                call ColorDummy3(d2, 0, 55, 255, 255, 0.15)
                            endif
                        elseif check2 > 0 and check3 == 0 then
                            if check2 == 1 then
                                call ColorDummy3(d, 0, 255, 185, 25, 0.15)
                                call ColorDummy3(d2, 0, 255, 185, 25, 0.15)
                            elseif check2 == 2 then
                                call ColorDummy3(d, 0, 95, 185, 255, 0.15)
                                call ColorDummy3(d2, 0, 95, 185, 255, 0.15)
                            elseif check2 == 3 then
                                call ColorDummy3(d, 0, 55, 255, 255, 0.15)
                                call ColorDummy3(d2, 0, 55, 255, 255, 0.15)
                            endif
                        endif
                    else
                        call ColorDummy3(d, 0, 255, 255, 255, 0.15)
                        call ColorDummy3(d2, 0, 255, 255, 255, 0.15)
                    endif
                   // set e = null
                   // set e2 = null
                   set d = null
                   set d2 = null
                   set c = null
                    set m_ErzaR2[i] = m_ErzaR2[ MUI_ErzaR2]
                    set MUI_ErzaR2 = MUI_ErzaR2 - 1
                    if MUI_ErzaR2 == -1 then
                        call PauseTimer( t_ErzaR2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaR2_Start takes unit NewC, real NewX, real NewY, integer NewKK, integer NewKK2 returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaR2 = MUI_ErzaR2 + 1
            set m_ErzaR2[ MUI_ErzaR2] = this
            set c = NewC
            set r = 0
            set x = NewX
            set y = NewY
            set a = GAngle2( c , x, y ) // Angle Between points
            set k = GetRandomInt(1, 2)
            set r4 = GetRandomReal(120, 600)
            set r5 = GetRandomReal( -200, -100)
            set check2 = NewKK
            set check3 = NewKK2
            if k == 1 then
            set d = UnitSpawn0(GetOwningPlayer(c),Erza5R_Dummy,(GetUnitX(c) + r5 * Cos(a)) + r4 * Cos(a + 90 * bj_DEGTORAD), (GetUnitY(c) + r5 * Sin(a)) + r4 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG,GetRandomReal(1.15, 1.5), 0.8, GetRandomReal(110, 555))
           //     set e = EffectSpawn("war3mapimported\\wos_Erza_sword2.mdx", (GetUnitX(c) + r5 * Cos(a)) + r4 * Cos(a + 90 * bj_DEGTORAD), (GetUnitY(c) + r5 * Sin(a)) + r4 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG, GetRandomReal(1.15, 1.5), 0.8, GetRandomReal(110, 555))
            else
           set d = UnitSpawn0(GetOwningPlayer(c),Erza5R_Dummy,(GetUnitX(c) + r5 * Cos(a)) + r4 * Cos(a - 90 * bj_DEGTORAD), (GetUnitY(c) + r5 * Sin(a)) + r4 * Sin(a - 90 * bj_DEGTORAD), a * bj_RADTODEG,GetRandomReal(1.15, 1.5), 0.8, GetRandomReal(110, 555))
           //     set e = EffectSpawn("war3mapimported\\wos_Erza_sword2.mdx", (GetUnitX(c) + r5 * Cos(a)) + r4 * Cos(a - 90 * bj_DEGTORAD), (GetUnitY(c) + r5 * Sin(a)) + r4 * Sin(a - 90 * bj_DEGTORAD), a * bj_RADTODEG, GetRandomReal(1.15, 1.5), 0.8, GetRandomReal(110, 555))
            endif
            set r4 = GetRandomReal(120, 600)
            set r5 = GetRandomReal( -200, -100)
            if k == 1 then
            set d2 = UnitSpawn0(GetOwningPlayer(c),Erza5R_Dummy,(GetUnitX(c) + r5 * Cos(a)) + r4 * Cos(a - 90 * bj_DEGTORAD), (GetUnitY(c) + r5 * Sin(a)) + r4 * Sin(a - 90 * bj_DEGTORAD), a * bj_RADTODEG,GetRandomReal(1.15, 1.5), 0.8, GetRandomReal(110, 555))
           
            //    set e2 = EffectSpawn("war3mapimported\\wos_Erza_sword2.mdx", (GetUnitX(c) + r5 * Cos(a)) + r4 * Cos(a - 90 * bj_DEGTORAD), (GetUnitY(c) + r5 * Sin(a)) + r4 * Sin(a - 90 * bj_DEGTORAD), a * bj_RADTODEG, GetRandomReal(1.15, 1.5), 0.8, GetRandomReal(110, 555))
            else
           set d2 = UnitSpawn0(GetOwningPlayer(c),Erza5R_Dummy,(GetUnitX(c) + r5 * Cos(a)) + r4 * Cos(a + 90 * bj_DEGTORAD), (GetUnitY(c) + r5 * Sin(a)) + r4 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG,GetRandomReal(1.15, 1.5), 0.8, GetRandomReal(110, 555))
           
          // set e2 = EffectSpawn("war3mapimported\\wos_Erza_sword2.mdx", (GetUnitX(c) + r5 * Cos(a)) + r4 * Cos(a + 90 * bj_DEGTORAD), (GetUnitY(c) + r5 * Sin(a)) + r4 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG, GetRandomReal(1.15, 1.5), 0.8, GetRandomReal(110, 555))
            endif
            set r3 = GetRandomReal(200, 300)
            set r4 = GetRandomReal(200, 300)
            if check2 > 0 and check3 > 0 then
                if check2 == 1 then
                    call SetUnitVertexColor(d, 255, 185, 25,255)
                elseif check2 == 2 then
                    call SetUnitVertexColor(d, 95, 185, 255,255)
                elseif check2 == 3 then
                    call SetUnitVertexColor(d, 55, 255, 255,255)
                endif
                if check3 == 1 then
                    call SetUnitVertexColor(d2, 255, 185, 25,255)
                elseif check3 == 2 then
                    call SetUnitVertexColor(d2, 95, 185, 255,255)
                elseif check3 == 3 then
                    call SetUnitVertexColor(d2, 55, 255, 255,255)
                endif
            elseif check2 > 0 and check3 == 0 then
                if check2 == 1 then
                    call SetUnitVertexColor(d, 255, 185, 25,255)
                    call SetUnitVertexColor(d2, 255, 185, 25,255)
                elseif check2 == 2 then
                    call SetUnitVertexColor(d, 95, 185, 255,255)
                    call SetUnitVertexColor(d2, 95, 185, 255,255)
                elseif check2 == 3 then
                    call SetUnitVertexColor(d, 55, 255, 255,255)
                    call SetUnitVertexColor(d2, 55, 255, 255,255)
                endif
            endif
            set rmax = 0.45
            if MUI_ErzaR2 == 0 then
                call TimerStart( t_ErzaR2, 0.03, true, function thistype.Loop_ErzaR2)
            endif
        endmethod
    endstruct

    private struct Erza5R_KS
        private static timer t_ErzaR = CreateTimer( )
        private static integer array m_ErzaR
        private static integer MUI_ErzaR = -1
        unit c
        real x
        real y
        real r2
        integer k
        integer k2
        real r3
        group g
        group g2
        unit u
        real dmg
        integer check2
        integer check3
        integer check4
        real aoe
        real r
        real a
        real rmax
        private static method Loop_ErzaR takes nothing returns nothing
            local integer this
            local integer i = 0
            local real ra1 = GetRandomReal(0, 365)
            local real dk = GetRandomReal(0.4, 0.85)
            loop
                exitwhen i > MUI_ErzaR
                set this = m_ErzaR[i]
                if SpellBoolCaster(c) and r <= rmax and LoadInteger(hs, GetHandleId(Player(k2)), StringHash("r cancel")) == 0 then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if r == 1.8 then
                        call MakeSound("war3mapImported\\Hero_Erza_R3")
                    endif
                    if r3 > 0.03 then
                        set r3 = 0
                        call Erza5R2_KS.ErzaR2_Start(c, GetUnitX(c) + 100 * Cos(a), GetUnitY(c) + 100 * Sin(a), check2, check3)
                        call Erza5R2_KS.ErzaR2_Start(c, GetUnitX(c) + 100 * Cos(a), GetUnitY(c) + 100 * Sin(a), check2, check3)
                    else
                        set r3 = r3 + 0.03
                    endif
                    if r2 > 0.22 then
                        set r2 = 0
                        set k = 1
                        call GroupClear( g2 )
                        loop
                            exitwhen k == 4
                        call DecorRemove(c,GetUnitX(c) + (500*k) * Cos(a) , GetUnitY(c) + (500 * k) * Sin(a), aoe ,50)
                        call VisionTimed(GetOwningPlayer(c), GetUnitX(c) + (700*k) * Cos(a) , GetUnitY(c) + (500 * k) * Sin(a), aoe * 1.6, 2)
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , GetUnitX(c) + (700 * k) * Cos(a) , GetUnitY(c) + (500 * k) * Sin(a) , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup( u , g2 ) == false then
                                    call dmgmag(c, u, dmg)
                                    if check4 > 0 then
                                        call ErzaPassive(c, u, check4)
                                    endif
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    call GroupAddUnit( g2 , u )
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                            set k = k + 1
                        endloop
                    else
                        set r2 = r2 + 0.03
                    endif
                else
                    call StopSpellUnit2(c)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set c = null
                    set m_ErzaR[i] = m_ErzaR[ MUI_ErzaR]
                    set MUI_ErzaR = MUI_ErzaR - 1
                    if MUI_ErzaR == -1 then
                        call PauseTimer( t_ErzaR)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaR_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaR = MUI_ErzaR + 1
            set m_ErzaR[ MUI_ErzaR] = this
            set c = NewC
            set r = 0
            set x = NewX
            set y = NewY
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set g = CreateGroup()
            set g2 = CreateGroup()
            set check2 = 0
            set check3 = 0
            set dmg = GetHeroAgi( c , true) * Erza5R_DamageAgiBase
            if LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2")) == 0 then
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt"))
                set dmg = dmg + GetHeroAgi(c, true) * Erza5_AddSpellDamage_1Element
            endif
            if LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt")) == 0 then
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2"))
                set dmg = dmg + GetHeroAgi(c, true) * Erza5_AddSpellDamage_1Element
            endif
            if LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt")) > 0 then
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt"))
                set check3 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2"))
                set dmg = dmg + GetHeroAgi(c, true) * Erza5_AddSpellDamage_2Element
            endif
            set check4 = PassiveType(check2, check3)
            call PauseUnit(c, true)
            set dmg = dmg / 7
            set r2 = 0
            set aoe = Erza5R_DamageAoe
            call StartSpellUnit2(c)
            set a = GAngle2( c , x, y ) // Angle Between points
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapImported\\Hero_Erza5_R")
            else
                call MakeSound("war3mapImported\\Hero_Erza5_R02")
            endif
            call VisionTimed(GetOwningPlayer(c), GetUnitX(c), GetUnitY(c), 1800, 4)
            set rmax = 2.1
            call SetUnitFacingTimed(c, a * bj_RADTODEG, 0 )
            call SetUnitAnimationByIndex(c, 9)
            
            if MUI_ErzaR == 0 then
                call TimerStart( t_ErzaR, 0.03, true, function thistype.Loop_ErzaR)
            endif
        endmethod
    endstruct

    private struct Erza5T_KS
        private static timer t_ErzaT = CreateTimer( )
        private static integer array m_ErzaT
        private static integer MUI_ErzaT = -1
        unit c
        unit td
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        real scale
        real r5
        real fly
        group g
        string s1
        string s2
        string s3
        unit u
        real dmg
        integer check
        integer check2
        integer check3
        integer check4
        real aoe
        real move
        real r
        effect array ee[20]
        real a
        real rmax
        private static method Loop_ErzaT takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real rng = 355
            local real timescale = 0.85
            local real scale1 = 0.65
            loop
                exitwhen i > MUI_ErzaT
                set this = m_ErzaT[i]
                if SpellBoolCaster(c)  and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit(c)
                    call DebugUnit(td)
                    if check < 1 then
                        set a = GAngle(c, td)
                        call SetUnitFacing(c, a * bj_RADTODEG)
                    endif
                    if check == 0 then
                        if r == 0.6 then
                            call SetUnitAnimationByIndex(c, 0)
                            call SetUnitTimeScale(c, 0.35)
                            set r2 = 10
                        endif
                        if r == 0.78 then
                        endif
                        if r > 0.78 then
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            if SR2(c, td) > move * 1.25 then
                                call MoveUnit(c, move, a)
                                if r2 > 0.09 then
                                    set r2 = 0
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 0.5, 3.75, 75))
                                else
                                    set r2 = r2 + 0.03
                                endif
                            else
                                set check = 1
                                set r = 0
                                set fly = 325
                                set r5 = 0.18
                                set rmax = 1.02
                                call SetUnitTimeScale(c, 0.6)
                                call PauseUnit(td, true)
                                call SetUnitAnimationByIndex(c, 13)
                                call PosUnit(td, GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a))
                                set x = GetUnitX(td)
                                set y = GetUnitY(td)
                                set x1 = GetUnitX(td)
                                set y1 = GetUnitY(td)
                                set x = x - (rng / 1.25) * Cos(a)
                                set y = y - (rng / 1.25) * Sin(a)
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_HakkeStart.mdx", x1, y1, GetRandomReal(0, 359), 0.5, 1.45, 0, 255, 255, 255, 175))
                            endif
                        endif
                    elseif check == 1 then
                        if r == 0.06 then
                            set ee[0] = EffectSpawn(s1, x, y, a * bj_RADTODEG + 35, timescale, scale1, fly)
                            call AnimDummyEff(ee[0], r5, 0.0)
                            call MakeSound("war3mapImported\\Hero_Erza5_T2")
                        elseif r == 0.27 then
                            set ee[1] = EffectSpawn(s2, x, y, a * bj_RADTODEG - 35, timescale, scale1, fly)
                            call AnimDummyEff(ee[1], r5, 0.0)
                            call MakeSound("war3mapImported\\Hero_Erza5_T3")
                            call SetUnitAnimationByIndex(c, 12)
                        elseif r == 0.48 then
                            set ee[2] = EffectSpawn(s1, x + rng * Cos(a), y + rng * Sin(a), a * bj_RADTODEG , timescale, scale1, fly)
                            call AnimDummyEff(ee[2], r5, 0.0)
                        elseif r == 0.69 then
                            set ee[3] = EffectSpawn(s2, x + rng * Cos(a + 90 * bj_DEGTORAD), y + rng * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 245, timescale, scale1, fly)
                            call AnimDummyEff(ee[3], r5, 0.0)
                            call DestroyEffect(ee[3])
                            call MakeSound("war3mapImported\\Hero_Erza5_T2")
                        elseif r == 0.81 then
                            set ee[4] = EffectSpawn(s2, x + rng * Cos(a + 90 * bj_DEGTORAD), y + rng * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 245, timescale, scale1, fly)
                            call AnimDummyEff(ee[4], r5, 0.0)
                            call DestroyEffect(ee[4])
                            call MakeSound("war3mapImported\\Hero_Erza5_T3")
                        elseif r == 1.02 then
                            call SetUnitAnimationByIndex(c, 4)
                            set ee[5] = EffectSpawn(s1, x - rng * Cos(a + 90 * bj_DEGTORAD), y - rng * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 122.5, timescale, scale1, fly)
                            call AnimDummyEff(ee[5], r5, 0)
                            call DestroyEffect(ee[5])
                        endif
                        if r == 0.06 or r == 0.27 or r == 0.48 or r == 0.69 or r == 0.81 or r == 1.02 then
                            call SetUnitAnimation(td, "death")
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x1, y1, GetRandomReal(0, 359), 1.1, 3, 9))
                            if s3 != "" then
                                call DestroyEffect(EffectSpawn(s3, x1, y1, GetRandomReal(0, 359), 1.1, scale, 25))
                            endif
                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", td, "chest"))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_1hongse_2blue.mdl", x1, y1, 1, 1.5, 3.25, 11))
                        endif
                        if r == rmax then
                            set r = 99999999
                            call SetUnitAnimation(td, "death")
                            call MUE(c, 600, 0.4, a)
                             set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            call UnitRemoveAbility(c, 'Avul')
                            call UnitRemoveAbility(td, 'Avul')                            
                            call StunUnit(c,td,Erza5T_Stun)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_fuxuan-21.mdl", x1, y1, a * bj_RADTODEG, 2.5, 8, 155))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x1, y1, GetRandomReal(0, 359), 1.1, 3, 9))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x1, y1, GetRandomReal(0, 359), 1.1, 4, 9))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x1, y1, GetRandomReal(0, 359), 1.1, 5, 9))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x1, y1, a * bj_RADTODEG, 0.5, 5, 50))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_1hongse_2blue.mdl", x1, y1, 1, 1.75, 2.95, 11))
                            call DecorRemove(c,x,y, aoe ,100)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call dmgphys(c, u, dmg)
                                    if check4 > 0 then
                                        call ErzaPassive(c, u, check4)
                                    endif
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        endif
                    endif
                else
                    set k = 0
                    loop
                        exitwhen k > 5
                        call ColorEffDummy3(ee[k], 0.6, 255, 255, 255, 1.02)
                        set k = k + 1
                    endloop
                    call StopSpellUnit(c)
                    call StopSpellUnit(td)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set td = null
                    set u = null
                    set m_ErzaT[i] = m_ErzaT[MUI_ErzaT]
                    set MUI_ErzaT = MUI_ErzaT - 1
                    if MUI_ErzaT == -1 then
                        call PauseTimer( t_ErzaT )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaT_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaT = MUI_ErzaT + 1
            set m_ErzaT[MUI_ErzaT] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set r2 = 0
            set check = 0
            call StartSpellUnit(c)
            call StartSpellUnit(td)
            set g = CreateGroup()
            set u = null
            set scale = 3
            set check2 = 0
            set check3 = 0            
            set check4 = PassiveType(check2, check3)
            set a = GAngle(c, td) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = Erza5T_DamageAoe
            set dmg = GetHeroAgi(c, true) * Erza5T_DamageAgiBase
            if LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2")) == 0 then
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt"))
                set dmg = dmg + GetHeroAgi(c, true) * Erza5_AddSpellDamage_1Element
            endif
            if LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt")) == 0 then
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2"))
                set dmg = dmg + GetHeroAgi(c, true) * Erza5_AddSpellDamage_1Element
            endif
            if LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt")) > 0 then
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt"))
                set check3 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2"))
                set dmg = dmg + GetHeroAgi(c, true) * Erza5_AddSpellDamage_2Element
            endif
            set rmax = 5
            set move = 110
            set s1 = ""
            set s2 = ""
            set s3 = ""
            if check2 > 0 then
                if check2 > 0 and check3 > 0 then
                    if check2 == 1 then
                        set s3 = "war3mapImported\\wos_fire explosion.mdl"
                        set s1 = "war3mapImported\\wos_zhanji-fire.mdl"
                    elseif check2 == 2 then
                        set s3 = "war3mapImported\\wos_obr08 (214).mdl"
                        set scale = 1.75
                        set s1 = "war3mapImported\\wos_zhanji-blue.mdl"
                    elseif check2 == 3 then
                        set s3 = "war3mapImported\\wos_SasukeYh-41.mdl"
                        set s1 = "war3mapImported\\wos_zhanji-water_ice.mdl"
                    endif
                    if check3 == 1 then
                        set s2 = "war3mapImported\\wos_zhanji-fire.mdl"
                    elseif check3 == 2 then
                        set s2 = "war3mapImported\\wos_zhanji-blue.mdl"
                    elseif check3 == 3 then
                        set s2 = "war3mapImported\\wos_zhanji-water_ice.mdl"
                    endif
                elseif check2 > 0 and check3 == 0 then
                    if check2 == 1 then
                        set s3 = "war3mapImported\\wos_fire explosion.mdl"
                        set s2 = "war3mapImported\\wos_zhanji-fire.mdl"
                        set s1 = "war3mapImported\\wos_zhanji-fire.mdl"
                    elseif check2 == 2 then
                        set s3 = "war3mapImported\\wos_obr08 (214).mdl"
                        set scale = 1.95
                        set s2 = "war3mapImported\\wos_zhanji-blue.mdl"
                        set s1 = "war3mapImported\\wos_zhanji-blue.mdl"
                    elseif check2 == 3 then
                        set s3 = "war3mapimported\\wos_blue--zhendi31_3_x1.5.mdl"
                        set s2 = "war3mapImported\\wos_zhanji-water_ice.mdl"
                        set s1 = "war3mapImported\\wos_zhanji-water_ice.mdl"
                    endif
                endif
            else
                set s2 = "war3mapImported\\wos_zhanji-blue.mdl"
                set s1 = "war3mapImported\\wos_zhanji-blue.mdl"
                set s3 = ""
            endif
            set k = 0
            call SetUnitTimeScale(c, 0.8)
            call SetUnitAnimationByIndex(c, 6)
            call MakeSound("war3mapImported\\Hero_Erza5_T")
            if MUI_ErzaT == 0 then
                call TimerStart( t_ErzaT, 0.03, true, function thistype.Loop_ErzaT )
            endif
        endmethod
    endstruct

    private struct Erza5F_KS
        private static timer t_ErzaF = CreateTimer( )
        private static integer array m_ErzaF
        private static integer MUI_ErzaF = -1
        unit c
        real x
        real y
        group g
        unit u
        real dmg
        integer check2
        integer check3
        integer check4
        real aoe
        real r
        effect e
        real a
        real rmax
        private static method Loop_ErzaF takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rand1 = 0
            local real rand2 = 0
            loop
                exitwhen i > MUI_ErzaF
                set this = m_ErzaF[i]
                if SpellBoolCaster(c) and r < rmax then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )                 
                    if r == 0.21 then
                        call GroupClear(g)
                        call DecorRemove(c,x,y, aoe ,50)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                call dmgphys(c, u, dmg)
                                if check4 > 0 then
                                    call ErzaPassive(c, u, check4)
                                endif
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                else
                    call DestroyGroup(g)
                    call ColorEffDummy3(e, 0.5, 255, 255, 255, 0.5)
                    set e = null
                    set g = null
                    set c = null
                    set m_ErzaF[i] = m_ErzaF[ MUI_ErzaF]
                    set MUI_ErzaF = MUI_ErzaF - 1
                    if MUI_ErzaF == -1 then
                        call PauseTimer( t_ErzaF)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaF_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaF = MUI_ErzaF + 1
            set m_ErzaF[ MUI_ErzaF] = this
            set c = NewC
            set r = 0
            set x = NewX
            set y = NewY
            set g = CreateGroup()
            set check2 = 0
            set check3 = 0
            set dmg = GetHeroAgi(c, true) * Erza5F_DamageAgiBase
            if LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2")) == 0 then
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt"))
                set dmg = dmg + GetHeroAgi(c, true) * Erza5_AddSpellDamage_1Element
            endif
            if LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt")) == 0 then
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2"))
                set dmg = dmg + GetHeroAgi(c, true) * Erza5_AddSpellDamage_1Element
            endif
            if LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt")) > 0 then
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt"))
                set check3 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2"))
                set dmg = dmg + GetHeroAgi(c, true) * Erza5_AddSpellDamage_2Element
            endif
            set check4 = PassiveType(check2, check3)
            set aoe = Erza5F_DamageAoe
            set a = GAngle2( c , x, y ) // Angle Between points
            set rmax = 0.66
            call MakeSound("war3mapImported\\Hero_Erza5_F3")
            call MakeSound("war3mapImported\\Hero_Erza5_F")
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SetUnitAnimationByIndex( c , 16)
            set e = EffectSpawn("war3mapImported\\wos_LD2209 (70)_01.mdl", x, y, GetRandomReal(0, 359), 0.95, 2., 0)
            call SetUnitTimeScale( c , 1)
            call VisionTimed(GetOwningPlayer(c), x, y, 750, 6)
            if MUI_ErzaF == 0 then
                call TimerStart( t_ErzaF, 0.03, true, function thistype.Loop_ErzaF)
            endif
        endmethod
    endstruct

    private struct Erza5TT_KS
        private static timer t_ErzaTT = CreateTimer( )
        private static integer array m_ErzaTT
        private static integer MUI_ErzaTT = -1
        unit c
        integer k2
        integer k3
        private static framehandle array frame_pas1
        private static framehandle array frame_pas2
        private static framehandle array frame_pas3
        private static framehandle array frame_pas4
        private static framehandle array frame_pas5
        private static framehandle array frame_pas6
        integer check
        integer check2
        integer check3
        integer k 
        real r
        real r5
        effect e
        effect e2
        real rmax
        private static method Loop_ErzaTT takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaTT
                set this = m_ErzaTT[i]
                if SpellBoolCaster(c) and r <= rmax and LoadInteger(hs, GetHandleId(c), StringHash("t armor active")) == 1 then
                    set r = r + 0.05
                    set r = S2R( R2SW( r , 0, 3 ) )
                    call BlzFrameSetValue(frame_pas3[check], rmax - (r + 0.1))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame_pas6[check], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                    if k3 == 1 then
                        if LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2")) > 0 then
                            if e2 != null then
                                call DestroyEffect(e2)
                                set e2 = null
                            endif
                        else
                            if e2 == null then
                                if k2 == 1 then // fire sword
                                    set e2 = AddSpecialEffectTarget("war3mapimported\\wos_buff_fire_big2.mdx", c, "hand left")
                                elseif k2 == 2 then // water sword
                                    set e2 = AddSpecialEffectTarget("war3mapimported\\wos_laz (167).mdx", c, "hand left")
                                elseif k2 == 3 then // lightning sword
                                    set e2 = AddSpecialEffectTarget("war3mapImported\\wos_obr08 (166).mdx", c, "hand left")
                                endif
                            endif
                        endif
                    endif
                    set i = i + 1
                else
                     if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame_pas1[check], false)
                                endif
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call SaveReal(hs, GetHandleId(c), StringHash("add spell dmg erza4 f"), 0)
                    call SaveInteger(hs, GetHandleId(c), StringHash("type sword"), 0)
                    if k3 == 0 or k3 == 4 then
                        call SaveInteger(hs, GetHandleId(c), StringHash("erza 5 tt"), 0)
                        call SaveInteger(hs, GetHandleId(c), StringHash("erza 5 tt2"), 0)
                    elseif k3 == 1 then
                        call SaveInteger(hs, GetHandleId(c), StringHash("erza 5 tt"), 0)
                    else
                        call SaveInteger(hs, GetHandleId(c), StringHash("erza 5 tt2"), 0)
                    endif
                    set c = null
                    set e = null
                    set e2 = null
                    set m_ErzaTT[i] = m_ErzaTT[MUI_ErzaTT]
                    set MUI_ErzaTT = MUI_ErzaTT - 1
                    if MUI_ErzaTT == -1 then
                        call PauseTimer( t_ErzaTT )
                    endif
                    call destroy( )
                endif
            endloop
        endmethod
        public static method ErzaTT_Start takes unit NewC, integer NewSword1, integer NewK3 returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaTT = MUI_ErzaTT + 1
            set m_ErzaTT[MUI_ErzaTT] = this
            set c = NewC
            set r = 0
            set rmax = Erza5ElementAbsorb_Duration
            set k2 = NewSword1
            set k3 = NewK3
            set check = GetPlayerId(GetOwningPlayer(c))
            set check2 = 0
            set check3 = 0
            set k = 0
            set r5 = 0
            set e = null
            set e2 = null
            if k2 == 0 and k3 == 0 then // natsu and gray
                set e = AddSpecialEffectTarget("war3mapimported\\wos_buff_fire_big2.mdx", c, "hand right")
                set e2 = AddSpecialEffectTarget("war3mapImported\\wos_GrayIce.mdx", c, "hand left")
                set check3 = Erza4F_AttackDamageAdd_NatsuGray
                set k = 1
                set check2 = 7
                set r5 = Erza4F_AddErzaSpellDamage_NatsuGray
                if GetRandomInt(1, 2) == 1 then
                    call MakeSound("war3mapImported\\Hero_Erza4_W(Alt)")
                else
                    call MakeSound("war3mapImported\\Hero_Erza4_W(Alt)2")
                endif
            elseif k2 == 4 and k3 == 4 then 
                set e = AddSpecialEffectTarget("war3mapimported\\wos_buff_fire_big2.mdx", c, "hand right")
                set e2 = AddSpecialEffectTarget("war3mapImported\\wos_obr08 (166).mdx", c, "hand left")
                set check3 = Erza4F_AttackDamageAdd_NatsuGray
                set k = 1
                set check2 = 5
                set r5 = Erza4F_AddErzaSpellDamage_NatsuGray
                if GetRandomInt(1, 2) == 1 then
                    call MakeSound("war3mapImported\\Hero_Erza_Pick1")
                else
                    call MakeSound("war3mapImported\\Hero_Erza_Pick2")
                endif
            elseif k3 == 1 then // first absorbed element: both hands until the second element appears
                set check2 = k2
                set check3 = Erza4F_AttackDamageAdd_1Element
                set r5 = Erza4F_AddErzaSpellDamage_1Element
                if k2 == 1 then // fire
                    set e = AddSpecialEffectTarget("war3mapimported\\wos_buff_fire_big2.mdx", c, "hand right")
                    set e2 = AddSpecialEffectTarget("war3mapimported\\wos_buff_fire_big2.mdx", c, "hand left")
                elseif k2 == 2 then // water
                    set e = AddSpecialEffectTarget("war3mapimported\\wos_laz (167).mdx", c, "hand right")
                    set e2 = AddSpecialEffectTarget("war3mapimported\\wos_laz (167).mdx", c, "hand left")
                elseif k2 == 3 then // lightning
                    set e = AddSpecialEffectTarget("war3mapImported\\wos_obr08 (166).mdx", c, "hand right")
                    set e2 = AddSpecialEffectTarget("war3mapImported\\wos_obr08 (166).mdx", c, "hand left")
                endif
            elseif k3 == 2 then // second absorbed element: left hand
                set check2 = k2
                set check3 = Erza4F_AttackDamageAdd_1Element
                set r5 = Erza4F_AddErzaSpellDamage_1Element
                if k2 == 1 then // fire
                    set e = AddSpecialEffectTarget("war3mapimported\\wos_buff_fire_big2.mdx", c, "hand left")
                elseif k2 == 2 then // water
                    set e = AddSpecialEffectTarget("war3mapimported\\wos_laz (167).mdx", c, "hand left")
                elseif k2 == 3 then // lightning
                    set e = AddSpecialEffectTarget("war3mapImported\\wos_obr08 (166).mdx", c, "hand left")
                endif
            endif
            call SaveReal(hs, GetHandleId(c), StringHash("add spell dmg erza4 f"), r5 / 100)
            call SaveInteger(hs, GetHandleId(c), StringHash("type sword"), check2)
            if frame_pas1[check] == null then
                                set frame_pas1[check] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                                call BlzFrameSetAbsPoint(frame_pas1[check], FRAMEPOINT_CENTER, 0.055, 0.18)
                                call BlzFrameSetSize(frame_pas1[check], 0.135, 0.035)
                                call BlzFrameSetTexture(frame_pas1[check], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                                call BlzFrameSetVisible(frame_pas1[check], false)
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame_pas1[check], true)
                                endif
                                set frame_pas2[check] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame_pas1[check], 0, 0)
                                call BlzFrameSetAbsPoint(frame_pas2[check], FRAMEPOINT_CENTER, 0.07, 0.185)
                                call BlzFrameSetSize(frame_pas2[check], 0.1, 0.019)
                                set frame_pas3[check] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[check], "", 0)
                                call BlzFrameSetSize(frame_pas3[check], 0.1, 0.035)
                                call BlzFrameSetScale(frame_pas3[check], 0.5)
                                call BlzFrameSetModel(frame_pas3[check], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                                call BlzFrameSetAbsPoint(frame_pas3[check], FRAMEPOINT_CENTER, 0.05, 0.175)
                                call BlzFrameSetMinMaxValue(frame_pas3[check], 0, rmax)
                                call BlzFrameSetValue(frame_pas3[check], rmax)
                                set frame_pas4[check] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[check], "", 0)
                                call BlzFrameSetAbsPoint(frame_pas4[check], FRAMEPOINT_CENTER, 0.005, 0.18)
                                call BlzFrameSetSize(frame_pas4[check], 0.025, 0.025)
                                call BlzFrameSetTexture(frame_pas4[check], "ReplaceableTextures\\CommandButtons\\BTNHero_Erza5_Icon", 0, false)
                                set frame_pas5[check] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[check], "", 0)
                                call BlzFrameSetAbsPoint(frame_pas5[check], FRAMEPOINT_CENTER, 0.07, 0.185)
                                call BlzFrameSetText(frame_pas5[check], "|c00FFFF00" + "Elemental infusion:" + "|r")
                                call BlzFrameSetScale(frame_pas5[check], 0.9)
                                set frame_pas6[check] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[check], "", 0)
                                call BlzFrameSetAbsPoint(frame_pas6[check], FRAMEPOINT_CENTER, 0.07, 0.17)
                                call BlzFrameSetText(frame_pas6[check], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                                call BlzFrameSetScale(frame_pas6[check], 0.9)
                            else
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame_pas1[check], true)
                                endif
                                call BlzFrameSetValue(frame_pas3[check], rmax)
                            endif
            if MUI_ErzaTT == 0 then
                call TimerStart( t_ErzaTT, 0.05, true, function thistype.Loop_ErzaTT )
            endif
        endmethod
    endstruct

    //----------------------------Erza-----------------------------------------------
     /* Animations index:
    Base:
    0 - dash
    1 - stand ready
    2 - move
    3 - circle sword from air very long
    4 - T
    5 - E
    6 - jump
    9 - r
    10 - q
    11 - atk strange
    12 - round zamah and to ground
    13 - tripple pierce
    14 - round atk
    16 - victory or charge
     */ 
    function Erza5Q_Start takes unit c, unit td returns nothing
        call Erza5Q_KS.ErzaQ_Start( c, td )
    endfunction
    function Erza5W_Start takes unit c returns nothing
        call Erza5W_KS.ErzaW_Start( c )
    endfunction
    function Erza5E_Start takes unit c, real x, real y returns nothing
        call Erza5E_KS.ErzaE_Start( c, x, y)
    endfunction
    function Erza5R_Start takes unit c, real x, real y returns nothing
        call Erza5R_KS.ErzaR_Start( c, x, y )
    endfunction
    function Erza5T_Start takes unit c, unit td returns nothing
        call Erza5T_KS.ErzaT_Start( c, td)
    endfunction
    function Erza5Pas_Start takes unit c, integer i returns nothing
        local integer k1 = 0
        local integer k2 = 0
        local integer k3 = 0
        local real x = GetUnitX(c)
        local real y = GetUnitY(c)
        local unit u = null
        local group g = CreateGroup()
        local integer counter1 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt")) // 1 - fire, 2 - water, 3 - lightning
        local integer counter2 = LoadInteger(hs, GetHandleId(c), StringHash("erza 5 tt2"))
        local boolean start1 = false
        local boolean start2 = false
        local real x1 = LoadReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("fire x"))
        local real y1 = LoadReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("fire y"))
        local real x2 = LoadReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("water x"))
        local real y2 = LoadReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("water y"))
        local real x3 = LoadReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("lightning x"))
        local real y3 = LoadReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("lightning y"))
        if LoadInteger(hs, GetHandleId(c), StringHash("t armor active")) == 1 then
            call GroupEnumUnitsInRange(g, x, y, 1800, NoDecor_Cond)
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if IsUnitAlly(u, GetOwningPlayer(c)) then
                    if GetUnitTypeId(u) == Gray_ID1 or GetUnitTypeId(u) == Gray_ID2 then
                        set k1 = k1 + 1
                    endif
                    if GetUnitTypeId(u) == Natsu_ID then
                        set k2 = k2 + 1
                    endif
                    if GetUnitTypeId(u) == Laxus_ID then
                        set k3 = k3 + 1
                    endif
                endif
                call GroupRemoveUnit(g, u)
            endloop
            if k1 > 0 and k2 > 0 then // Natsu + Gray, same attach as R form
                if counter1 == 0 and counter2 == 0 then
                    if IntegerCd(c,"elem gain cd",60) then 
                        call SaveInteger(hs, GetHandleId(c), StringHash("erza 5 tt"), 7)
                        call SaveInteger(hs, GetHandleId(c), StringHash("erza 5 tt2"), 7)
                        call Erza5TT_KS.ErzaTT_Start(c, 0, 0)
                    else
                        call DisplayTimedTextToPlayer(GetOwningPlayer(c),0,0,1,"Elemental gain on cooldown")
                    endif
                endif
            elseif k2 > 0 and k3 > 0 then // Natsu + Laxus, same attach as R form
                // Store the pair as regular fire + lightning so every T-form
                // ability creates exactly the same ErzaPassive effects.
                if counter1 == 0 and counter2 == 0 then
                    if IntegerCd(c,"elem gain cd",60) then 
                        call SaveInteger(hs, GetHandleId(c), StringHash("erza 5 tt"), 1)
                        call SaveInteger(hs, GetHandleId(c), StringHash("erza 5 tt2"), 3)
                        call Erza5TT_KS.ErzaTT_Start(c, 4, 4)
                    else
                        call DisplayTimedTextToPlayer(GetOwningPlayer(c),0,0,1,"Elemental gain on cooldown")
                    endif
                endif
            else
                if x1 != 0 and SR3(c, x1, y1) <= Erza1R_DamageAoe and counter1 != 1 and counter2 != 1 then
                    if counter1 == 0 then
                        set counter1 = 1
                        set start1 = true
                    elseif counter2 == 0 then
                        set counter2 = 1
                        set start2 = true
                    endif
                endif
                if x2 != 0 and SR3(c, x2, y2) <= Erza2W_Aoe and counter1 != 2 and counter2 != 2 then
                    if counter1 == 0 then
                        set counter1 = 2
                        set start1 = true
                    elseif counter2 == 0 then
                        set counter2 = 2
                        set start2 = true
                    endif
                endif
                if x3 != 0 and SR3(c, x3, y3) <= Erza3W_Aoe and counter1 != 3 and counter2 != 3 then
                    if counter1 == 0 then
                        set counter1 = 3
                        set start1 = true
                    elseif counter2 == 0 then
                        set counter2 = 3
                        set start2 = true
                    endif
                endif
                if start1 then
                    call SaveInteger(hs, GetHandleId(c), StringHash("erza 5 tt"), counter1)
                    call Erza5TT_KS.ErzaTT_Start(c, counter1, 1)
                endif
                if start2 then
                    call SaveInteger(hs, GetHandleId(c), StringHash("erza 5 tt2"), counter2)
                    call Erza5TT_KS.ErzaTT_Start(c, counter2, 2)
                endif
            endif
        endif
        call DestroyGroup(g)
        set g = null
        set u = null
    endfunction
    function Erza5F_Start takes unit c, real x, real y returns nothing
        call Erza5F_KS.ErzaF_Start( c, x, y )
    endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
