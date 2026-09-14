library ErzaWSpells uses GearSystems, ErzaTSpells
    globals
//---------------Q ability-----------------------------------------------------
        integer Erza2Q_ID = 'A037'
        real Erza2Q_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real Erza2Q_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real Erza2Q_Damage2StaticBase = 125 // base static damage for 1 level
        real Erza2Q_Damage2StaticStep = 0 // additional static damage for each next level
        real Erza2Q_DamageAoe = 200
//---------------W ability-----------------------------------------------------
        integer Erza2W_ID = 'A038'
        integer Erza2W_Invis_ID = 'A03W'
        integer Erza2W_Armor_ID = 'A03V'
        integer Erza2W_DummyElementalId = 'h00O'
        unit ErzaElementalWaterDummy = null
        real Erza2W_AllyBuffDurationBase = 7 // how long ally have buff armor and hp regen base
        real Erza2W_AllyBuffDurationStep = 0 // how long ally have buff armor and hp regen for each next level
        real Erza2W_AllyBuffHealBase = 100 // how much hp restore for full armor buff duration ally base
        real Erza2W_AllyBuffHealStep = 75 // how much hp restore for full armor buff duration ally for each next level
        real Erza2W_Aoe = 600
        real Erza2W_PushDistance = 800 // how long enemy will be pushed every second , push from cast point it meant , if enemy was in center it will be pushed for full rage, if in aoe edge it would be pushed for distance - aoe ( 800 - 600) = 200 range
        real Erza2W_PushTime = 0.6
        real Erza2W_DurationBase = 3 // change from 3.5 to 5.5 sec
        real Erza2W_DurationStep = 0.5 
//---------------E ability-----------------------------------------------------
        integer Erza2E_ID = 'A039'
        real Erza2E_Aoe = 400
//---------------R ability-----------------------------------------------------
        integer Erza2R_ID = 'A03A'
        real Erza2R_DamageAgiBase = 3 // base number x Agi damage per 1 second
        real Erza2R_DamageAgiStep = 0.75 // additional number x Agi damage for each next level per second
        real Erza2R_DamageAoe = 575
        real Erza2R_Range = 1800
//---------------T ability-----------------------------------------------------
        integer Erza2T_ID = 'A03B'
        real Erza2T_DamageAgiBase = 6 // base number x Agi damage for 1 level
        real Erza2T_DamageAoe = 650
    endglobals
     

    private struct Erza2Q_KS
        private static timer t_ErzaQ = CreateTimer( )
        private static integer array m_ErzaQ
        private static integer MUI_ErzaQ = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k
        real scale
        group g
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
        private static method Loop_ErzaQ takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaQ
                set this = m_ErzaQ[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    if check == 0 then
                        set a = GAngle(c, td)
                        call SetUnitFacing(c, a * bj_RADTODEG)
                    else
                        set a = GAngle5(e, GetUnitX(td), GetUnitY(td))
                    endif
                    if check == 0 then
                        if r == 0.51 then
                            set e = EffectSpawn("war3mapImported\\wos_papsnaz (692).mdl", GetUnitX(c) + 140 * Cos(a), GetUnitY(c) + 140 * Sin(a), a * bj_RADTODEG, 1, 0.8, 135)
                            set scale = 0.8
                        endif
                        if r<0.54 then 
                        call DebugUnit2(c)
                        endif
                        if r == 0.54 then
                            call DestroyEffect(e2)
                            if k == 1 then
                                call MakeSound("war3mapImported\\Hero_Erza2_Q2")
                            endif
                            set check = 1
                            set r = 0
                            set move = 90
                            call StopSpellUnit2(c)
                        endif
                    endif
                    if check == 1 then
                        if r < rmax and SR5(e, x, y) > move * 2.35 then
                            if scale < 2. then
                                set scale = scale + 0.12
                                call BlzSetSpecialEffectScale(e, scale)
                            endif
                            call MoveEff2(e, move, a)
                            if r2 > 0.03 then
                                set r2 = 0
                                call DecorRemove(c,GetEffX(e), GetEffY(e),aoe,20)
                                call VisionTimed(GetOwningPlayer(c), GetEffX(e), GetEffY(e), 750, 1.5)
                            else
                                set r2 = r2 + 0.03
                            endif
                        else
                            set r = 99999
                            call BlzSetSpecialEffectPosition(e, x - 145 * Cos(a), y - 145 * Sin(a), 145)
                        endif
                    endif
                else
                    if check < 1 then
                        call StopSpellUnit2(c)
                        call DestroyEffect(e2)
                    endif
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    if check == 1 then
                        call GroupClear( g )
                        call DecorRemove(c,x, y,aoe,20)
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                call dmgphys(c, u, dmg)
                                call ErzaPassive(c, u, 2)
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                        call VisionTimed(GetOwningPlayer(c), x, y, 750, 2)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_waterexplosion.mdl", x, y, a * bj_RADTODEG, 1.1, 2, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdl", x, y, GetRandomReal(0, 359), 0.75, 1.75, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 0.65, 3, 3))
                    endif
                        call DestroyEffect(e)
                    call DestroyGroup(g)
                    set c = null
                    set td = null
                    set g = null
                    set e = null
                    set e2 = null
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
            call StartSpellUnit2(c)
            set dmg = Erza2Q_Damage2StaticBase + (Erza2Q_Damage2StaticStep * (GetUnitAbilityLevel(c, Erza2Q_ID) - 1))
            set dmg = dmg + GetHeroAgi( c , true) * ( Erza2Q_DamageAgiBase + ( Erza2Q_DamageAgiStep * ( GetUnitAbilityLevel( c , Erza2Q_ID) - 1 ) ) )
            set r = 0
            set aoe = Erza2Q_DamageAoe
            set check = 0
            set g = CreateGroup()
            set rmax = 3
            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_laz (167).mdx", c, "weapon")
            call SetUnitAnimationByIndex(c,1)
            set k = GetRandomInt(1, 2)
            if k == 1 then
                call MakeSound("war3mapImported\\Hero_Erza2_Q")
            elseif k == 2 then
                call MakeSound("war3mapImported\\Hero_Erza2_Q3")
            endif
            if MUI_ErzaQ == 0 then
                call TimerStart( t_ErzaQ, 0.03, true, function thistype.Loop_ErzaQ )
            endif
        endmethod
    endstruct

    private struct Erza2W_KS
        private static timer t_ErzaW = CreateTimer( )
        private static integer array m_ErzaW
        private static integer MUI_ErzaW = -1
        unit c
        real x
        real y
        real r2
        integer k
        real r5
        real hp
        group g
        unit u
        real aoe
        real r
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
                    if r< 0.5 then 
                    call DebugUnit2(c)
                    endif
                    if r == 0.5 then
                        call StopSpellUnit2(c)
                        call DestroyEffect(e2)
                        call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("water x"), x)
                        call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("water y"), y)
                        call VisionTimed(GetOwningPlayer(c), GetUnitX(c), GetUnitY(c), 1250, rmax + 1.5 - r)
                        call DecorRemove(c,x, y,aoe,20)
                    endif
                    if r > 0.5 then
                        if SR3(c, x, y) <= Erza2W_Aoe then
                            call Erza5Pas_Start(c, 2)
                            if ErzaElementalWaterDummy == null then
                                set ErzaElementalWaterDummy = CreateUnit(GetOwningPlayer(c), Erza2W_DummyElementalId, x, y, 0)
                            endif
                        else
                            if ErzaElementalWaterDummy != null then
                                call RemoveUnit(ErzaElementalWaterDummy)
                                set ErzaElementalWaterDummy = null
                            endif
                        endif
                        call GroupClear( g )
                        call GroupEnumUnitsInRange( g , x, y , 30000 , null)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitAlly( u , GetOwningPlayer( c )) then
                                if SR3(u, x, y) < aoe then
                                    if GetUnitAbilityLevel(u, Erza2W_Armor_ID) == 0 then
                                        call UnitAddAbility(u, Erza2W_Armor_ID)
                                        call UnitMakeAbilityPermanent(u, true, Erza2W_Armor_ID)
                                        call HPS(c,u, hp, r5)
                                        call MyRemoveAbility(u, r5, Erza2W_Armor_ID, 1)
                                    endif
                                    if GetUnitAbilityLevel(u, Erza2W_Invis_ID) == 0 then
                                        call UnitAddAbility(u, Erza2W_Invis_ID)
                                        call MyRemoveAbility(u, rmax - r, Erza2W_Invis_ID, 1)
                                    endif
                                else
                                    call UnitRemoveAbility(u, Erza2W_Invis_ID)
                                endif
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                        if r2 > 0.8 then
                            set r2 = 0
                            call DecorRemove(c,x, y,aoe,20)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (171)44.mdl", x, y, 0, 1.5, 0.6, 0))
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    call MUE(u, Erza2W_PushDistance - SR3(u, x, y), Erza2W_PushTime, GAngle3(x, y, u))
                                    call ErzaPassive(c, u, 2)
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_waterexplosion.mdl", x, y, a * bj_RADTODEG, 1.1, 2, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdl", x, y, GetRandomReal(0, 359), 0.75, 1.5, 1))
                        else
                            set r2 = r2 + 0.1
                        endif
                    endif
                else
                    if ErzaElementalWaterDummy != null then
                        call RemoveUnit(ErzaElementalWaterDummy)
                        set ErzaElementalWaterDummy = null
                    endif
                    if r < 0.5 then
                        call StopSpellUnit2(c)
                    endif
                    call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("water x"), 0)
                    call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("water y"), 0)
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set u = null
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
            set aoe = Erza2W_Aoe
            set g = CreateGroup()
            set r5 = Erza2W_AllyBuffDurationBase + (Erza2W_AllyBuffDurationStep * (GetUnitAbilityLevel(c, Erza2W_ID) - 1))
            set rmax = Erza2W_DurationBase + (Erza2W_DurationStep * (GetUnitAbilityLevel(c, Erza2W_ID) - 1)) + 0.5 
            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_laz (167).mdx", c, "weapon")
            call StartSpellUnit2(c)
            call SetUnitAnimationByIndex(c, 10)
            set k = GetRandomInt(1, 2)
            set hp = Erza2W_AllyBuffHealBase + (Erza2W_AllyBuffHealStep * (GetUnitAbilityLevel(c, Erza2W_ID) - 1))
            if k == 1 then
                call MakeSound("war3mapImported\\Hero_Erza2_W")
            elseif k == 2 then
                call MakeSound("war3mapImported\\Hero_Erza2_W2")
            endif
            if MUI_ErzaW == 0 then
                call TimerStart( t_ErzaW, 0.1, true, function thistype.Loop_ErzaW )
            endif
        endmethod
    endstruct

    private struct Erza2E_KS
        private static timer t_ErzaE = CreateTimer( )
        private static integer array m_ErzaE
        private static integer MUI_ErzaE = -1
        unit c
        real x
        real y
        real r2
        integer k
        real r3
        real r5
        group g
        group g2
        unit u
        real aoe
        real move
        real r
        effect e2
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
                    call MoveUnit(c, move, a)
                    call GroupClear(g)
                    call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                            if IsUnitInGroup(u, g2) == false then
                                call GroupAddUnit(g2, u)
                                call ErzaPassive(c, u, 2)
                            endif
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop
                    if r2 > 0.08 then
                        set r2 = 0
                        set x = x + 150 * Cos(a)
                        set y = y + 150 * Sin(a)
                        set r5 = GetRandomReal(0.4, 1)
                        call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_opdef (424).mdl", x, y, a * bj_RADTODEG, r5, GetRandomReal(1.45, 1.55), 1), 0, 255, 255, 255, 0.3)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_blue-texiao-buff2.mdl", x, y, GetRandomReal(0, 359), 1.95, 5.25, 0))
                    else
                        set r2 = r2 + 0.03
                    endif
                    if r3 > 0.03 then
                        set r3 = 0
                        set x = x + 150 * Cos(a)
                        set y = y + 150 * Sin(a)
                        set r5 = GetRandomReal(0.4, 1)
                        call DecorRemove(c,x, y,aoe,20)
                        call EffectSpawn2("war3mapImported\\wos_Bubbles2.mdx", x , y, GetRandomReal(0, 359), 1, 6, GetRandomReal(50, 150), 0.45)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x, y, a * bj_RADTODEG, 0.5, 2.5, 75))
                    else
                        set r3 = r3 + 0.03
                    endif
                else
                    call DestroyEffect(e2)
                    call SetUnitTimeScale( c , 1)
                    call PauseUnit( c , false)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set e2 = null
                    set g = null
                    set g2 = null
                    set c = null
                    set u = null
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
            set MUI_ErzaE = MUI_ErzaE + 1
            set m_ErzaE[ MUI_ErzaE] = this
            set c = NewC
            set r = 0
            set x = NewX
            set y = NewY
            set r2 = 10
            set r3 = 10
            set g = CreateGroup()
            set g2 = CreateGroup()
            call PauseUnit( c , true)
            set aoe = Erza2E_Aoe
            set a = GAngle2( c , x, y ) // Angle Between points
            set rmax = 0.54
            set move = SR3(c, x, y) / 18
            set k = GetRandomInt(1, 2)
            if k == 1 then
                call MakeSound("war3mapImported\\Hero_Erza2_E")
            elseif k == 2 then
                call MakeSound("war3mapImported\\Hero_Erza2_E2")
            endif
            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_laz (167).mdx", c, "weapon")
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SetUnitAnimationByIndex( c , 6)
            call SetUnitTimeScale( c , 1)
            if MUI_ErzaE == 0 then
                call TimerStart( t_ErzaE, 0.03, true, function thistype.Loop_ErzaE)
            endif
        endmethod
    endstruct

    private struct Erza2R_KS
        private static timer t_ErzaR = CreateTimer( )
        private static integer array m_ErzaR
        private static integer MUI_ErzaR = -1
        unit c
        real x
        real y
        real r2
        real r3
        group g
        group g2
        unit u
        real dmg
        real aoe
        real move
        real r
        effect e2
        real a
        real rmax
        private static method Loop_ErzaR takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaR
                set this = m_ErzaR[i]
                if SpellBoolCaster(c) and r < rmax then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    call DebugUnit2(c)
                    if r == 0.3 then
                        call SetUnitAnimationByIndex(c, 7)
                        call MakeSound("war3mapImported\\Hero_Erza2_R2")
                    elseif r == 0.6 then
                        call SetUnitAnimationByIndex(c, 8)
                    endif
                    if r > 0.69 then
                        call MoveUnit(c, move, a)
                        if r2 > 0.28 then
                            set r2 = 0
                            set x = x + 150 * Cos(a)
                            set y = y + 150 * Sin(a)
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_blue spin slash.mdl", x, y, a * bj_RADTODEG, 1, 1.2 , 1), 0.5, 255, 255, 255, 0.675)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Opdef17 (1110).mdl", x, y, GetRandomReal(0, 359), 1.15, 1, 0))
                        else
                            set r2 = r2 + 0.03
                        endif
                        if r3 > 0.03 then
                            set r3 = 0
                        call DecorRemove(c,x, y,aoe,50)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    if IsUnitInGroup(u, g2) == false then
                                        call GroupAddUnit(g2, u)
                                        call dmgphys(c, u, dmg)
                                        call ErzaPassive(c, u, 2)
                                    endif
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                            call EffectSpawn2("war3mapImported\\wos_Bubbles2.mdx", x , y, GetRandomReal(0, 359), 1, 6, GetRandomReal(50, 150), 0.45)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x, y, a * bj_RADTODEG, 0.5, 2.5, 75))
                        else
                            set r3 = r3 + 0.03
                        endif
                    endif
                else
                    call StopSpellUnit2(c)
                    call DestroyEffect(e2)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set e2 = null
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
            set r2 = 10
            set r3 = 10
            set g = CreateGroup()
            set g2 = CreateGroup()
            call StartSpellUnit2(c)
            set dmg = GetHeroAgi( c , true) * ( Erza2R_DamageAgiBase + ( Erza2R_DamageAgiStep * ( GetUnitAbilityLevel( c , Erza2R_ID) - 1 ) ) )
            set r = 0
            set aoe = Erza2R_DamageAoe
            set a = GAngle2( c , x, y ) // Angle Between points
            set rmax = 1.2
            set move = Erza2R_Range / 20
            call MakeSound("war3mapImported\\Hero_Erza2_R")
            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_laz (167).mdx", c, "weapon")
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SetUnitAnimationByIndex( c , 5)
            call SetUnitTimeScale( c , 0.5)
            if MUI_ErzaR == 0 then
                call TimerStart( t_ErzaR, 0.03, true, function thistype.Loop_ErzaR)
            endif
        endmethod
    endstruct

    private struct Erza2T_KS
        private static timer t_ErzaT = CreateTimer( )
        private static integer array m_ErzaT
        private static integer MUI_ErzaT = -1
        unit c
        unit td
        real x
        real y
        real r2
        group g
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
        private static method Loop_ErzaT takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaT
                set this = m_ErzaT[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    if check < 2 then
                        set a = GAngle(c, td)
                        call SetUnitFacing(c, a * bj_RADTODEG)
                    endif
                    if check == 0 then
                        if r == 0.66 then
                            call SetUnitAnimationByIndex(c, 12)
                            call SetUnitTimeScale(c, 0.65)
                            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", c, "weapon")
                            set r2 = 10
                        endif
                        if r == 1.02 then
                            call SetUnitTimeScale(c, 0.45)
                        endif
                        if r > 1.02 then
                            if SR2(c, td) > move * 1.25 then
                                call MoveUnit(c, move, a)
                                if r2 > 0.09 then
                                    set r2 = 0
                                    call EffectSpawn2("war3mapImported\\wos_Bubbles2.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 10, GetRandomReal(50, 150), 0.7)
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_Kamijo-6blue.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 2.35, 0, 255, 255, 255, 200))
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 0.5, 3.75, 75))
                                else
                                    set r2 = r2 + 0.03
                                endif
                            else
                                set check = 1
                                set r = 0
                                set rmax = 0.03
                                call SetUnitTimeScale(c, 1)
                                call MakeSound("war3mapImported\\Hero_Erza1_T4")
                                call PosUnit(td, GetUnitX(c) + 130 * Cos(a), GetUnitY(c) + 130 * Sin(a))
                            endif
                        endif
                    elseif check == 1 then
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        if r == rmax then
                            call SetUnitAnimation(td, "death")
                        call DecorRemove(c,x, y,aoe,70)
                            call VisionTimed(GetOwningPlayer(c), x, y, 1250, 2)
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_blue spin slash.mdl", x, y, a * bj_RADTODEG + 120, 1, 0.75 , 1), 0.5, 255, 255, 255, 0.675)
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_blue spin slash.mdl", x, y, a * bj_RADTODEG + 240, 1, 1.25 , 1), 0.5, 255, 255, 255, 0.675)
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_blue spin slash.mdl", x, y, a * bj_RADTODEG + 360, 1, 1.75 , 1), 0.5, 255, 255, 255, 0.675)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Opdef17 (1110).mdl", x, y, GetRandomReal(0, 359), 1.15, 1.5, 35))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdl", x, y, GetRandomReal(0, 359), 1.15, 2.5, 1))
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call dmgmag(c, u, dmg)
                                    call ErzaPassive(c, u, 2)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                           
                        endif
                    endif
                else
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call StopSpellUnit2(c)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set td = null
                    set e = null
                    set e2 = null
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
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set a = GAngle(c, td) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = Erza2T_DamageAoe
            set dmg = GetHeroAgi(c, true) * Erza2T_DamageAgiBase
            set rmax = 5
            set move = 80
            set e = AddSpecialEffectTarget("war3mapImported\\wos_aurapartred2.mdx", c, "origin")
            call SetUnitTimeScale(c, 0.65)
            call SetUnitAnimationByIndex(c, 5)
            call MakeSound("war3mapImported\\Hero_Erza2_T")
            if MUI_ErzaT == 0 then
                call TimerStart( t_ErzaT, 0.03, true, function thistype.Loop_ErzaT )
            endif
        endmethod
    endstruct

    //----------------------------Erza-----------------------------------------------
     /* Animations index:
    Base:
    0 - stand
    1 - round atk slow mb q
    2 - move
    5 - stand ready
    6 - atk pierce
    7 - same as 1 but fast
    8 - same as 7 but + 180
    10 - w
    12 - t
    11 - w + kuvirok
     */ 
    function Erza2Q_Start takes unit c, unit td returns nothing
        call Erza2Q_KS.ErzaQ_Start( c, td )
    endfunction
    function Erza2W_Start takes unit c returns nothing
        call Erza2W_KS.ErzaW_Start( c )
    endfunction
    function Erza2E_Start takes unit c, real x, real y returns nothing
        call Erza2E_KS.ErzaE_Start( c, x, y)
    endfunction
    function Erza2R_Start takes unit c, real x, real y returns nothing
        call Erza2R_KS.ErzaR_Start( c, x, y )
    endfunction
    function Erza2T_Start takes unit c, unit td returns nothing
        call Erza2T_KS.ErzaT_Start( c, td)
    endfunction
   
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com