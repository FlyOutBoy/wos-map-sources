library ErzaESpells uses GearSystems, ErzaTSpells
    globals
//---------------Q ability-----------------------------------------------------
        integer Erza3Q_ID = 'A03C'
        real Erza3Q_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real Erza3Q_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real Erza3Q_Damage2StaticBase = 150 // base static damage for 1 level
        real Erza3Q_Damage2StaticStep = 0 // additional static damage for each next level
        real Erza3Q_DamageAoe = 300
//---------------W ability-----------------------------------------------------
        integer Erza3W_ID = 'A03D'
        integer Erza3W_PositiveMS_ID = 'A03X'
        integer Erza3W_NegativeMS_ID = 'A03Y'
        integer Erza3W_DummyElementalId = 'h00O'
        unit ErzaElementalLightingDummy = null
        real Erza3W_AbilityDelay = 1.2 // after this time erza will restore mana and remove debuffs and create lightning area , from 0.1....0.5...0.6 to 2.5....3) should be divided by 0.1
        real Erza3W_ManarestoreBase = 10 // restore % of her max mana at the end of cast
        real Erza3W_ManarestoreStep = 2.5 // restore % of her max mana at the end of cast for each next lvl
        real Erza3W_AreaDurationBase = 4 // how much seconds lightning area live, from 5....5.5...5.6 to N ) should be divided by 0.1
        real Erza3W_AreaDurationStep = 1 // how much seconds lightning area live, from 5....5.5...5.6 to N ) should be divided by 0.1
        real Erza3W_Aoe = 725 // area where passive will apply to nearby and area where erza can absorb element
//---------------E ability-----------------------------------------------------
        integer Erza3E_ID = 'A03E'
        integer Erza3E_DamageImmune_ID = 'A03Z'
        real Erza3E_Aoe = 600 // area where ally units dont take damage around erza
        real Erza3E_ManaShieldOff = 40 // in %, autofinish ability if damage more than this % of max mana amount
//---------------R ability-----------------------------------------------------
        integer Erza3R_ID = 'A03F'
        real Erza3R_DamageAgiBase = 3 // base number x Agi damage per 1 second
        real Erza3R_DamageAgiStep = 0.75   // additional number x Agi damage for each next level per second
        real Erza3R_DamageAoe = 625
        real Erza3R_Stun = 1 // from 0.1 to 3
//---------------T ability-----------------------------------------------------
        integer Erza3T_ID = 'A03G'
        real Erza3T_DamageAgiBase = 6  // base number x Agi damage for 1 level
        real Erza3T_DamageAoe = 360
        real Erza3T_Range = 2500 // from 1600 to N
        real Erza3T_Stun = 1 // from 0.1 to 3
        real Erza3T_PushDistance = 900
        real Erza3T_PushDuration = 0.3
    endglobals

    private struct Erza3Q_KS
        private static timer t_ErzaQ = CreateTimer( )
        private static integer array m_ErzaQ
        private static integer MUI_ErzaQ = -1
        unit c
        real x
        real y
        real r2
        real scale
        real r6
        group g
        group g2
        unit u
        real dmg
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax
        private static method Loop_ErzaQ takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaQ
                set this = m_ErzaQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if r < 0.51 then
                    call DebugUnit2(c)
                    endif
                    if r == 0.39 then
                        set x = GetUnitX(c) + 100 * Cos(a)
                        set y = GetUnitY(c) + 100 * Sin(a)
                    elseif r == 0.6 then
                        call StopSpellUnit2(c)
                        call DestroyEffect(e2)
                        call MakeSound("war3mapImported\\Hero_Erza3_Q2")
                        set e = EffectSpawn("war3mapimported\\wos_by_wood_effect_yubanmeiqin_lightning_leijizhiqing.mdl", GetUnitX(c) + 110 * Cos(a), GetUnitY(c) + 110 * Sin(a), a * bj_RADTODEG, 1.5, 2, 150)
                        call DestroyEffect(e)
                    endif
                    if r > 0.6 and r < rmax - 0.03 then
                        set scale = scale + 0.08
                        set r2 = r2 + move
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_Hashirama_MADARAa (73).mdx", x + r2 * Cos(a), y + r2 * Sin(a), a * bj_RADTODEG, 1.85, 1.15, 1))
                        call GroupClear(g)
                        call DecorRemove(c,x + r2 * Cos(a), y + r2 * Sin(a), aoe,40)
                        call GroupEnumUnitsInRange(g, x + r2 * Cos(a), y + r2 * Sin(a), aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u, g2) == false then
                                call dmgmag(c, u, dmg)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Effect_Order_DanGe_Stf_DaJi_1_3.mdl", GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359), 1.85, 3, 155))
                                call GroupAddUnit(g2, u)
                                call ErzaPassive(c, u, 3)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set r2 = r2 + move
                        if r6 >= 0.0 then
                            set r6 = 0
                            call VisionTimed(GetOwningPlayer(c), x + r2 * Cos(a), y + r2 * Sin(a), 650, 2)
                        else
                            set r6 = r6 + 0.03
                        endif
                    endif
                else
                    call SetUnitTimeScale( c, 1 )
                    if r < 0.51 then
                        call DestroyEffect(e2)
                        call StopSpellUnit2(c)
                    endif
                    call DestroyGroup(g)
                    set g = null
                    call DestroyGroup(g2)
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
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
        public static method ErzaQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaQ = MUI_ErzaQ + 1
            set m_ErzaQ[MUI_ErzaQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set r6 = 0
            set scale = 0.9
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2(c, x, y) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = Erza3Q_DamageAoe
            set dmg = Erza3Q_Damage2StaticBase + (Erza3Q_Damage2StaticStep * (GetUnitAbilityLevel(c, Erza3Q_ID) - 1))
            set dmg = dmg + GetHeroAgi(c, true) * (Erza3Q_DamageAgiBase + (Erza3Q_DamageAgiStep * (GetUnitAbilityLevel(c, Erza3Q_ID) - 1)))
            set rmax = 0.81
            set move = 150
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_ev-qilangKsblue.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 0.75, 1.5, 1))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_ev-qilangKsblue.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 0.75, 1., 1))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_ev-qilangKsblue.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 0.75, 0.5, 1))
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_obr08 (166).mdx", c, "weapon")
            call SetUnitTimeScale(c, 1)
            call SetUnitAnimationByIndex(c, 5)
            call MakeSound("war3mapImported\\Hero_Erza3_Q")
            if MUI_ErzaQ == 0 then
                call TimerStart( t_ErzaQ, 0.03, true, function thistype.Loop_ErzaQ )
            endif
        endmethod
    endstruct

    private struct Erza3W_KS
        private static timer t_ErzaW = CreateTimer( )
        private static integer array m_ErzaW
        private static integer MUI_ErzaW = -1
        unit c
        real x
        real y
        real r2
        integer k
        real r5
        group g
        unit u
        real aoe
        real r
        effect e
        effect e2
        real a
        real rmax
        private static method Loop_ErzaW takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaW
                set this = m_ErzaW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.1
                    if r < Erza3W_AbilityDelay and LoadInteger(hs, GetHandleId(c), StringHash("e armor active")) == 0 then
                        set r = 9999
                    endif
                    if r == Erza3W_AbilityDelay then
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        call SetMpCurrent(c, r5)
                        call VisionTimed(GetOwningPlayer(c), x, y, 750, rmax+1.5)
                        call UnitRemoveBuffsEx(c, false, true, true, true, true, true, true)
                        call MakeSound("war3mapImported\\Hero_Erza3_W3")
                        call DestroyEffect(e2)
                        call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("lightning x"), x)
                        call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("lightning y"), y)
                        set e = EffectSpawn("war3mapImported\\wos_AZ_tufu02_R3.mdl", x, y, 1, 1, 1.85, 0)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue--zhendi31_3.mdl", x, y, a * bj_RADTODEG, 1.1, 2, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_by_wood_effect_yubanmeiqin_lightning_luolei.mdl", x, y, GetRandomReal(0, 359), 1, 3, 11))
                        call DecorRemove(c,x,y, aoe,50)
                    endif
                    if r > Erza3W_AbilityDelay and r != 9999 then
                        if SR3(c, x, y) <= Erza3W_Aoe then
                            call Erza5Pas_Start(c, 2)
                            if ErzaElementalLightingDummy == null then
                                set ErzaElementalLightingDummy = CreateUnit(GetOwningPlayer(c), Erza3W_DummyElementalId, x, y, 0)
                            endif
                        else
                            if ErzaElementalLightingDummy != null then
                                call RemoveUnit(ErzaElementalLightingDummy)
                                set ErzaElementalLightingDummy = null
                            endif
                        endif
                        call GroupClear( g )
                        call GroupEnumUnitsInRange( g , x, y , 30000 , null)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitAlly( u , GetOwningPlayer( c )) then
                                if SR3(u, x, y) < aoe then
                                    if GetUnitAbilityLevel(u, Erza3W_PositiveMS_ID) == 0 then
                                        call UnitAddAbility(u, Erza3W_PositiveMS_ID)
                                        call MyRemoveAbility(u, rmax - r, Erza3W_PositiveMS_ID, 1)
                                    endif
                                else
                                    call UnitRemoveAbility(u, Erza3W_PositiveMS_ID)
                                endif
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                        if r2 > 0.8 then
                            set r2 = 0
                            call DecorRemove(c,x,y, aoe,20)
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , x, y , 30000 , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    if SR3(u, x, y) < aoe then
                                        call ErzaPassive(c, u, 3)
                                        if GetUnitAbilityLevel(u, Erza3W_NegativeMS_ID) == 0 then
                                            call UnitAddAbility(u, Erza3W_NegativeMS_ID)
                                            call MyRemoveAbility(u, rmax - r, Erza3W_NegativeMS_ID, 1)
                                        endif
                                    else
                                        call UnitRemoveAbility(u, Erza3W_NegativeMS_ID)
                                    endif
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        else
                            set r2 = r2 + 0.1
                        endif
                    endif
                else
                    if ErzaElementalLightingDummy != null then
                        call RemoveUnit(ErzaElementalLightingDummy)
                        set ErzaElementalLightingDummy = null
                    endif
                    if r >= Erza3W_AbilityDelay then
                        call DestroyEffect(e)
                    else
                        call DestroyEffect(e2)
                    endif
                    call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("lightning x"), 0)
                    call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("lightning y"), 0)
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set e = null
                    set e2 = null
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
            set r2 = 10
            set aoe = Erza3W_Aoe
            set g = CreateGroup()
            set r5 = Erza3W_ManarestoreBase + (Erza3W_ManarestoreStep * (GetUnitAbilityLevel(c, Erza3W_ID) - 1))
            set r5 = r5 / 100 * GetUnitState(c, UNIT_STATE_MAX_MANA)
            set rmax = Erza3W_AbilityDelay + Erza3W_AreaDurationBase + (Erza3W_AreaDurationStep * (GetUnitAbilityLevel(c, Erza3W_ID) - 1))
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_Opdef (1005)2.mdx", c, "origin")
            call SetUnitAnimationByIndex(c, 1)
            set k = GetRandomInt(1, 2)
            if k == 1 then
                call MakeSound("war3mapImported\\Hero_Erza3_W")
            elseif k == 2 then
                call MakeSound("war3mapImported\\Hero_Erza3_W2")
            endif
            if MUI_ErzaW == 0 then
                call TimerStart( t_ErzaW, 0.1, true, function thistype.Loop_ErzaW )
            endif
        endmethod
    endstruct

    private struct Erza3E_KS
        private static timer t_ErzaE = CreateTimer( )
        private static integer array m_ErzaE
        private static integer MUI_ErzaE = -1
        unit c
        real x
        real y
        real r2
        real r3
        group g
        unit u
        real dmg
        real aoe
        real r
        effect e
        private static method Loop_ErzaE takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaE
                set this = m_ErzaE[i]
                if GetUnitCurrentOrder(c) == OrderId("autoharvestlumber") and GetUnitState(c,UNIT_STATE_MANA)>= (GetUnitState(c,UNIT_STATE_MAX_MANA)*(Erza3E_ManaShieldOff/100)) then
                    set r = r + 0.05
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    call BlzSetSpecialEffectPosition(e, x, y, 200)
                    call GroupClear( g )
                    call GroupEnumUnitsInRange( g , x, y , 30000 , null)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if IsUnitAlly( u , GetOwningPlayer( c )) and u != c then
                            if SR3(u, x, y) < aoe then
                                if GetUnitAbilityLevel(u, Erza3E_DamageImmune_ID) == 0 then
                                    call UnitAddAbility(u, Erza3E_DamageImmune_ID)
                                    call MyRemoveAbility(u, 10, Erza3E_DamageImmune_ID, 1)
                                endif
                            else
                                call UnitRemoveAbility(u, Erza3E_DamageImmune_ID)
                            endif
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    set u = null
                    if r3 > 0.2 then
                        set r3 = 0
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_ev-qilangKsblue.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 0.775, 4, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_ev-qilangKsblue.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 0.775, 1.8, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_ev-qilangKsblue.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 0.775, 2.8, 1))
                    else
                        set r3 = r3 + 0.05
                    endif
                    if r2 > 0.5 then
                        set r2 = 0
                        call DecorRemove(c,x,y, aoe,20)
                        call GroupClear( g )
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if IsUnitEnemy( u , GetOwningPlayer( c )) then
                                call ErzaPassive(c, u, 3)
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    else
                        set r2 = r2 + 0.05
                    endif
                else
                   call IssueImmediateOrder(c,"stop")
                    call GroupClear( g )
                    call GroupEnumUnitsInRange( g , x, y , 30000 , null)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if IsUnitAlly( u , GetOwningPlayer( c )) and u != c then
                            call UnitRemoveAbility(u, Erza3E_DamageImmune_ID)
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    set u = null
                    call SaveReal(hs,GetHandleId(c),StringHash("dmg b e"),0)
                    call DestroyEffect(e)
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set e = null
                    set m_ErzaE[i] = m_ErzaE[MUI_ErzaE]
                    set MUI_ErzaE = MUI_ErzaE - 1
                    if MUI_ErzaE == -1 then
                        call PauseTimer( t_ErzaE )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaE_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaE = MUI_ErzaE + 1
            set m_ErzaE[MUI_ErzaE] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set r2 = 10
            set r3 = 10
            set aoe = Erza3E_Aoe
            set g = CreateGroup()
            call SaveReal(hs,GetHandleId(c),StringHash("dmg b e"),GetUnitState(c, UNIT_STATE_MAX_MANA)*(Erza3E_ManaShieldOff/100))
            set e = EffectSpawn("war3mapImported\\wos_LDeff (143)2.mdl", x, y, 1, 1, 4., 200)
            call SetUnitAnimationByIndex(c, 1)
            call SetUnitAnimationByIndex(c, 1)
            call MakeSound("war3mapImported\\Hero_Erza3_E")
            if MUI_ErzaE == 0 then
                call TimerStart( t_ErzaE, 0.05, true, function thistype.Loop_ErzaE )
            endif
        endmethod
    endstruct

    private struct Erza3R_KS
        private static timer t_ErzaR = CreateTimer( )
        private static integer array m_ErzaR
        private static integer MUI_ErzaR = -1
        unit c
        real x
        real y
        real r2
        integer k
        real r3
        real r4
        real r5
        real fly
        group g
        unit u
        real dmg
        real aoe
        real sr
        real r
        effect e
        effect e2
        effect e3
        effect e4
        real a
        real rmax
        private static method Loop_ErzaR takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real rr4
            loop
                exitwhen i > MUI_ErzaR
                set this = m_ErzaR[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if r < 0.51 then
                        if r4 != 0 then
                            call MoveUnit(c, -r4, a)
                        endif
                        call SetFly(c, GetUnitFlyHeight(c) + fly)
                    endif
                    if r == 0.51 then
                        call MakeSound("war3mapImported\\Hero_Erza3_R3")
                    elseif r == 0.42 then
                        set e4 = EffectSpawnColor3("war3mapImported\\wos_mystoganauraa.mdl", GetUnitX(c) + 225 * Cos(a), GetUnitY(c) + 225 * Sin(a), a * bj_RADTODEG, 1, 1.65, GetUnitFlyHeight(c) + 85, -65, 255, 35, 35, 225)
                        call ScaleEffDummy(e4, 0.24, 0.5, 1.5)
                    endif
                    if r == 0.39 then
                        set e3 = AddSpecialEffectTarget("war3mapimported\\wos_BY_Wood_Effect_Order_DanGe_Stf_XuLi_1_1.mdx", c, "weapon")
                    endif
                    if r == 0.72 then
                        call SetUnitTimeScale(c, 0)
                    endif
                    if r == 0.81 then
                        set e = EffectSpawn("war3mapimported\\wos_OPM (33227)2.mdl", GetUnitX(c) + 0 * Cos(a), GetUnitY(c) + 0 * Sin(a), a * bj_RADTODEG, 1, 2.85, 205)
                        call MakeSound("war3mapImported\\Hero_Erza3_R2")
                        set x = GetUnitX(c) + sr * Cos(a)
                        set y = GetUnitY(c) + sr * Sin(a)
                    endif
                    if r > 0.81 then
                        if r2 > 0.21 then
                            set r2 = 0
                            call GroupClear(g)
                            call DecorRemove(c,x,y, aoe,50)
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_acg_bbb.mdx", x, y, GetRandomReal(0, 359), 2, 2.45, 155, 55, 185, 255, 125))
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    call dmgmag(c, u, dmg)
                                    call ErzaPassive(c, u, 3)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        else
                            set r2 = r2 + 0.03
                        endif
                        if r3 > 0.09 then
                            set r3 = 0
                            set rr4 = GetRandomReal(150, aoe - 250)
                            set r5 = GetRandomReal(0, 359) * bj_DEGTORAD
                            set k = GetRandomInt(1, 2)
                            if k == 1 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_SparkRErza.mdl", x + rr4 * Cos(a + r5), y + rr4 * Sin(a + r5), GetRandomReal(0, 359), 1, 2.85, 0))
                                set r5 = r5 + 180 * bj_DEGTORAD
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (431232).mdx", x + rr4 * Cos(a + r5), y + rr4 * Sin(a + r5), a * bj_RADTODEG, 0.75, 1.55, 1))
                            else
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (431232).mdx", x + rr4 * Cos(a + r5), y + rr4 * Sin(a + r5), a * bj_RADTODEG, 0.75, 1.55, 1))
                                set r5 = r5 + 180 * bj_DEGTORAD
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_SparkRErza.mdl", x + rr4 * Cos(a + r5), y + rr4 * Sin(a + r5), GetRandomReal(0, 359), 1, 2.85, 0))
                            endif
                        else
                            set r3 = r3 + 0.03
                        endif
                   
                    endif
                else
                    call DestroyEffect(e2)
                    call DestroyEffect(e3)
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.35)
                    call ColorEffDummy3(e4, 0, 255, 45, 45, 0.35)
                    call SetUnitTimeScale( c, 1 )
                    call SetUnitFlyHeight(c, 0, 5000)
                    call StopSpellUnit(c)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set u = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set m_ErzaR[i] = m_ErzaR[MUI_ErzaR]
                    set MUI_ErzaR = MUI_ErzaR - 1
                    if MUI_ErzaR == -1 then
                        call PauseTimer( t_ErzaR )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaR_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaR = MUI_ErzaR + 1
            set m_ErzaR[MUI_ErzaR] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set r3 = 10
            call StartSpellUnit(c)
            set fly = 980 / 16
            set r4 = 0
            set sr = 1150
            if SR3(c, x, y) < sr then
                set r4 = (sr - SR3(c, x, y)) / 16
            elseif SR3(c, x, y) > sr then
                set r4 = ((SR3(c, x, y) - sr) * - 1) / 16
            endif
            set g = CreateGroup()
            set u = null
            set a = GAngle2(c, x, y) // Angle Between points
            set aoe = Erza3R_DamageAoe
            set dmg = GetHeroAgi(c, true) * (Erza3R_DamageAgiBase + (Erza3R_DamageAgiStep * (GetUnitAbilityLevel(c, Erza3R_ID) - 1)))
            set dmg = dmg / 5
            set rmax = 2.12
            call VisionTimed(GetOwningPlayer(c), x, y, 1450, 4)
            call SetUnitTimeScale(c, 0.7)
            call SetUnitAnimationByIndex(c, 3)
            call SetUnitFacing(c, a * bj_RADTODEG - 15)
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_obr08 (166).mdx", c, "weapon")
            call MakeSound("war3mapImported\\Hero_Erza3_R")
            if MUI_ErzaR == 0 then
                call TimerStart( t_ErzaR, 0.03, true, function thistype.Loop_ErzaR )
            endif
        endmethod
    endstruct

    private struct Erza3T_KS
        private static timer t_ErzaT = CreateTimer( )
        private static integer array m_ErzaT
        private static integer MUI_ErzaT = -1
        unit c
        real x
        real y
        real r2
        real r3
        real r5
        real fly
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
        effect e3
        effect e4
        real a
        real rmax
        private static method Loop_ErzaT takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rkek = 0
            loop
                exitwhen i > MUI_ErzaT
                set this = m_ErzaT[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if check == 0 then
                        call DebugUnit2(c)
                        if r == 0.81 then
                            call SetUnitAnimationByIndex(c, 2)
                        endif
                        if r == 0.3 then
                            call MakeSound("war3mapImported\\Hero_Erza3_T3")
                            set e = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiblue.mdl", c, "weapon")
                        endif
                        if r2 > 0.03 then
                            set r2 = 0
                            set e4 = EffectSpawn("war3mapImported\\wos_ev-qilangKsblue.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 0.675, 2.5, 1)
                            call ScaleEffDummy(e4, 0.5, 0.5, 2.25)
                            call MyRemoveEff(e4, 0.5)
                            set e4 = null
                            set e4 = null
                        else
                            set r2 = r2 + 0.03
                        endif
                        if r >= 1.02 then
                            call StopSpellUnit2(c)
                            set check = 1
                            call MakeSound("war3mapimported\\HeroStarrk_Q3")
                            call DestroyEffect(e)
                            call DestroyEffect(e2)
                            call MakeSound("war3mapImported\\Hero_Erza3_T2")
                            set e = null
                            set e2 = null
                            set e4 = null
                            set r5 = 0
                            set rmax = 2
                            set r = 0
                            set fly = 120
                            set e = EffectSpawn("war3mapImported\\wos_ErzaLightningSpear.mdl", GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), a * bj_RADTODEG, 1, 2, fly)
                            set e2 = EffectSpawn("war3mapImported\\wos_az_x023.mdl", GetUnitX(c) + 165 * Cos(a), GetUnitY(c) + 165 * Sin(a), a * bj_RADTODEG + 180, 1, 2.25, fly)
                            set e3 = EffectSpawnColor("war3mapImported\\wos_1028_white.mdl", GetUnitX(c) + 210 * Cos(a), GetUnitY(c) + 210 * Sin(a), a * bj_RADTODEG, 1, 1.4, fly, 55, 185, 255, 220)
                        endif
                    elseif check == 1 then
                        if r5 >= Erza3T_Range then
                            set r = 9999
                        endif
                        call MoveEff2(e, move, a)
                        call MoveEff2(e2, move, a)
                        call MoveEff2(e3, move, a)
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        set r5 = r5 + move
                        if r6 >= 0.0 then
                            set r6 = 0
                            call VisionTimed(GetOwningPlayer(c), x, y, 950, 2.2)
                            call DecorRemove(c,x,y, aoe,80)
                        else
                            set r6 = r6 + 0.03
                        endif
                        if r2 > 0.0 then
                            set r2 = 0
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup( u , g2 ) == false then
                                    call dmgmag(c, u, dmg)
                                    call ErzaPassive(c, u, 3)
                                    call StunUnit(c, u, Erza3T_Stun)
                                    call MUE(u, Erza3T_PushDistance, Erza3T_PushDuration, a)
                                    call GroupAddUnit( g2 , u )
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        else
                            set r2 = r2 + 0.03
                        endif
                        if r3 > 0.03 then
                            set r3 = 0
                            set x = x + 150 * Cos(a)
                            set y = y + 150 * Sin(a)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x, y, a * bj_RADTODEG, 0.85, 2.5, fly))
                        else
                            set r3 = r3 + 0.03
                        endif
                    endif
                else
                    if check == 1 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_SparkRErza.mdl", x, y, GetRandomReal(0, 359), 2, 6, 0))
                        call MakeSound("war3mapImported\\Hero_Erza3_T4")
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue--zhendi31_3_x2.mdl", x, y, a * bj_RADTODEG, 1.1, 2, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_by_wood_effect_yubanmeiqin_lightning_luolei.mdl", x, y, GetRandomReal(0, 359), 0.5, 5, 11))
                        call GroupClear( g )
                        call DecorRemove(c,x,y, aoe*2,100)
                        call GroupEnumUnitsInRange( g , x , y , aoe * 2 , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup( u , g2 ) == false then
                                call dmgmag(c, u, dmg)
                                call ErzaPassive(c, u, 3)
                                call StunUnit(c, u, Erza3T_Stun)
                                call GroupAddUnit( g2 , u )
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                    else
                        call DestroyEffect( e )
                        call DestroyEffect( e2 )
                        call StopSpellUnit2(c)
                    endif
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.24)
                    call ColorEffDummy3(e2, 0, 255, 255, 255, 0.24)
                    call ColorEffDummy3(e3, 0, 55, 185, 255, 0.24)
                    call SetUnitTimeScale( c , 1)
                    call DestroyGroup( g )
                    set g = null
                    call DestroyGroup( g2 )
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_ErzaT[i] = m_ErzaT[ MUI_ErzaT]
                    set MUI_ErzaT = MUI_ErzaT - 1
                    if MUI_ErzaT == -1 then
                        call PauseTimer( t_ErzaT)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaT_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaT = MUI_ErzaT + 1
            set m_ErzaT[ MUI_ErzaT] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set r3 = 0
            set r5 = 0
            set move = 180
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set check = 0
            set aoe = Erza3T_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( Erza3T_DamageAgiBase )
            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_BY_Wood_Effect_Order_DanGe_Stf_XuLi_1_1.mdx", c, "weapon")
            call SetUnitFacing( c , a * bj_RADTODEG)
            set rmax = 1.02
            call SetUnitTimeScale( c , 0.5)
            call SetUnitAnimationByIndex( c , 1)
            call MakeSound("war3mapImported\\Hero_Erza3_T")
            if MUI_ErzaT == 0 then
                call TimerStart( t_ErzaT, 0.03, true, function thistype.Loop_ErzaT)
            endif
        endmethod
    endstruct

    //----------------------------Erza-----------------------------------------------
     /* Animations index:
    Base:
    0 - stand
    1 - stand ready or e
    2 - atk pierce q
    3 - r atk wniz
    4 - move
    5 - channel q and cast for t
     */ 
    function Erza3Q_Start takes unit c, real x, real y returns nothing
        call Erza3Q_KS.ErzaQ_Start( c, x, y )
    endfunction
    function Erza3W_Start takes unit c returns nothing
        call Erza3W_KS.ErzaW_Start( c )
    endfunction
    function Erza3E_Start takes unit c returns nothing
        call Erza3E_KS.ErzaE_Start( c)
    endfunction
    function Erza3R_Start takes unit c, real x, real y returns nothing
        call Erza3R_KS.ErzaR_Start( c, x, y )
    endfunction
    function Erza3T_Start takes unit c, real x, real y returns nothing
        call Erza3T_KS.ErzaT_Start( c, x, y)
    endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com