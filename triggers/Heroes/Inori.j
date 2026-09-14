library InoriSpells uses GearSystems
    globals
        integer Inori_ID = 'H017'
        integer Inori2_ID = 'H018'
        integer InoriF_ID = 'A065'
        unit array inoridummy1
        unit array inoridummy2
        real InoriF_PushRange = 550
//---------------Q ability-----------------------------------------------------
        integer InoriQ_ID = 'A05Z'
        real InoriQ_DamageIntBase = 1.5 // base number x Int damage for 1 level
        real InoriQ_DamageIntStep = 1 // additional number x Int damage for each next level
        real InoriQ_Damage2StaticBase = 175 // base static damage for 1 level
        real InoriQ_Damage2StaticStep = 0 // additional static damage for each next level
        real InoriQ_Range = 1400
        real InoriQ_RangeADD = 125
        real InoriQ_DamageAoe = 190
        real InoriFQ_DamageIntBase = 2 // base number x Int damage for 1 level
        real InoriFQ_DamageIntStep = 1 // additional number x Int damage for each next level
        real InoriFQ_Damage2StaticBase = 175 // base static damage for 1 level
        real InoriFQ_Damage2StaticStep = 0 // additional static damage for each next level
        real InoriFQ_StunPeriodic = 0.1
        real InoriFQ_DamageAoe = 365
//---------------EQ ability-----------------------------------------------------
        integer InoriQ2_ID = 'A067'
        real InoriEQ_DamageIntBase = 1 // base number x Int damage for 1 level
        real InoriEQ_DamageIntStep = 1 // additional number x Int damage for each next level
        real InoriEQ_Damage2StaticBase = 175 // base static damage for 1 level
        real InoriEQ_Damage2StaticStep = 0 // additional static damage for each next level
        real InoriEQ_DamageAoe = 185 // Crystal aoe
        real InoriEQ_Range = 1300
        real InoriEQ_Stun = 0.5
//---------------TQ ability-----------------------------------------------------
        integer InoriQ3_ID = 'A068'
        real InoriTQ_DamageIntBase = 7 // base number x Int damage for 1 level
        real InoriTQ_DamageIntStep = 0 // additional number x Int damage for each next level
        real InoriTQ_Damage2StaticBase = 0 // base static damage for 1 level
        real InoriTQ_Damage2StaticStep = 0 // additional static damage for each next level
        real InoriTQ_DamageAoe = 205 // bullet aoe
        real InoriTQ_Stun = 0.5
        real InoriTQ_Range = 1700
//---------------W ability-----------------------------------------------------
        integer InoriW_ID = 'A060'
        unit array InoriW_Dummy[10]
        real InoriW_DamageIntBase = 1 // base number x Int damage for 1 level
        real InoriW_DamageIntStep = 1 // additional number x Int damage for each next level
        real InoriW_DamageStaticBase = 150 // base static damage for 1 level per second
        real InoriW_DamageStaticStep = 0 // additional static damage for each next level per second
        real InoriW_HealBaseStatic = 75 // base static damage for 1 level per second
        real InoriW_HealStaticStep = 0 // additional static damage for each next le per secondvel
        real InoriW_HealBaseInt = 1 // base static damage for 1 level
        real InoriW_HealStepInt = 1 // additional static damage for each next level
        real InoriW_Stun = 1
//---------------W2 ability-----------------------------------------------------
        integer InoriW2_ID = 'A069'
        real InoriEW_DamageIntBase = 1 // base number x Int damage for 1 level
        real InoriEW_DamageIntStep = 1 // additional number x Int damage for each next level
        real InoriEW_DamageStaticBase = 150 // base static damage for 1 level per second
        real InoriEW_DamageStaticStep = 0 // additional static damage for each next level per second
        real InoriEW_Stun = 1
//---------------W3 ability-----------------------------------------------------
        integer InoriW3_ID = 'A06A'
        real InoriTW_DamageIntBase = 7 // base number x Int damage for 1 level
        real InoriTW_DamageIntStep = 0 // additional number x Int damage for each next level
        real InoriTW_DamageStaticBase = 0 // base static damage for 1 level
        real InoriTW_DamageStaticStep = 0 // additional static damage for each next level
        real InoriTW_DamageAoe = 700
        real InoriTW_Stun = 0.1
//---------------E ability-----------------------------------------------------
        integer InoriE_ID = 'A09S'
        integer InoriEAlt_ID = 'A09T'
        integer InoriEAlt2_ID = 'A061'
        integer InoriEE_ID = 'A06U'
        integer InoriE_Aura_ID = 'B00I'
        integer InoriE_Regen1_ID = 'A06I'
        integer InoriE_Regen2_ID = 'A06J'
        integer InoriE_Regen3_ID = 'A06K'
        integer InoriE_Regen4_ID = 'A06L'
        integer InoriE_Regen5_ID = 'A06M'
        integer InoriE_Atk_ID = 'A06N'
        real InoriE_Duration = 8
        real InoriE_CDBase = 30
        real InoriE_CDReduce = 2
        real InoriE_AoeSearch = 1400
        real InoriE_DmgCap = 250 // same or more value of this damage will add 1 instability stack to inori
        real InoriE_DmgMagResistFromPas = 5 // % of magic resistance from passive
//---------------E2 ability-----------------------------------------------------
        integer InoriE2_ID = 'A06D'
//---------------R ability-----------------------------------------------------
        integer InoriR_ID = 'A062'
        integer InoriER_ID = 'A06B'
        integer InoriR_BuffId = 'B00J'
        real InoriR_HealIntBase = 0.6 // base number x Int damage for 1 level .dmg per sec
        real InoriR_HealIntStep = 0.1 // additional number x Int damage for each next level .dmg per sec
        real InoriR_HealStaticBase = 0 // base number x Int damage for 1 level .dmg per sec
        real InoriR_HealStaticStep = 0 // additional number x Int damage for each next level .dmg per sec
        real InoriR_HealAoe = 1000
        real InoriR_HealAoeAdd = 250
        real InoriR_AntiDebuffStartTime = 5.01 // should be divided by 0.03
//---------------R2 ability-----------------------------------------------------
        integer InoriR2_ID = 'A06C'
        real InoriR2_DamageIntBase = 8 // base number x Int damage for 1 level .dmg per sec
        real InoriR2_DamageIntStep = 0 // additional number x Int damage for each next level .dmg per sec
        real InoriR2_DamageAoe = 400
        real InoriR2_DamageAoeAdd = 100
        real InoriR2_Stun = 1
        real InoriR2_MaxRange = 2000
        real InoriER_DamageIntBase = 4 // base number x Int damage for 1 level
        real InoriER_DamageIntStep = 1 // additional number x Int damage for each next level
        real InoriER_DamageAoe = 600
//---------------T ability-----------------------------------------------------
        integer InoriG_ID = 'A066'
        integer InoriT_ID = 'A063'
        integer InoriT2_ID = 'A064'
        integer InoriT3_ID = 'A06E'
        integer InoriT_Crystal1_ID = 'B019'
        integer InoriT_Crystal2_ID = 'B01A'
        framehandle array inori_frame_pas1 [10]
        framehandle array inori_frame_pas2 [10]
        framehandle array inori_frame_pas3 [10]
        framehandle array inori_frame_pas4 [10]
        framehandle array inori_frame_pas5 [10]
        framehandle array inori_frame_pas6 [10]
        framehandle array inori_frame_pas7 [10]
        framehandle array inori_frame_pas8 [10]
        framehandle array inori_frame_pas9 [10]
        framehandle array inori_frame_pas10 [10]
        framehandle array inori_frame_pas11 [10]
        framehandle array inori_frame_pas12 [10]
        framehandle array inori_frame_pas13 [10]
        framehandle array inori_frame_pas14 [10]
        trigger InoriFrameTrig1 = CreateTrigger()
        integer InoriFrameDebug = 0
        real InoriT_DamageIntBase = 11 //Int
        real InoriT2_DamageIntBase = 2.5 //Int per pillar
        real InoriT_DamageAoe = 1400
        real InoriT_DamageAoeAdd = 125
        real InoriT_DamageMaxAoe = 2000
        real InoriT2_DamageAoeBeam = 525
        real InoriT_CrystalMinRange = 600
        real InoriT_CrystalMaxRange = 2500
        real InoriT_CrystallLifeTime = 14
        real InoriT_RootTime = 3
        real InoriT2_Duration = 25
        
//--------------------------------------Inori--------------------------------------------------------------
    endglobals
    

    function BuffUnitInori2 takes unit c, unit u, integer level returns nothing
            local integer i = GetPlayerId(GetOwningPlayer(c))
            if inoridummy1[i] == null or GetWidgetLife(inoridummy1[i]) < 1 then
                set inoridummy1[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
                call UnitAddAbility(inoridummy1[i], 'A06G')
            endif
            if level > 0 then
                if GetUnitAbilityLevel(inoridummy1[i], 'A06G') == 0 then
                    call UnitAddAbility(inoridummy1[i], 'A06G')
                endif
                call SetUnitAbilityLevel(inoridummy1[i], 'A06G', level)
                call SetUnitFacing(inoridummy1[i], GAngle(inoridummy1[i], u) * bj_RADTODEG)
                call IssueTargetOrder(inoridummy1[i], "curse", u)
            endif
    endfunction

    private struct InoriQ_KS
        private static timer t_InoriQ = CreateTimer( )
        private static integer array m_InoriQ
        private static integer MUI_InoriQ = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        integer k2
        real r4
        real r5
        real r6
        real r7
        group g
        group g2
        unit u
        real dmg
        integer check
        integer check2
        integer check3
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax
        private static method Loop_InoriQ takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_InoriQ
                set this = m_InoriQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if check2 == 0 then
                        if check == 0 then
                            call DebugUnit2(c)
                            if r >= 0.45 then
                                call StopSpellUnit2(c)
                                set check = 1
                                set k2 = 0
                                set move = 150
                                set r5 = 0
                                set r6 = 1
                                set x1 = GetUnitX(c) + 30 * Cos(a)
                                set y1 = GetUnitY(c) + 30 * Sin(a)
                                call SetUnitAnimationByIndex(c, 3)
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_Alucard bulletfire.mdl", x1 + 35 * Cos(a), y1 + 35 * Sin(a), a * bj_RADTODEG, 1, 3, 100))
                                call MakeSound("war3mapimported\\HeroInori_Q2")
                                set e = EffectSpawn("war3mapImported\\wos_Alucard bullet.mdl", x1, y1, a * bj_RADTODEG, 1, 0.7, 150)
                                set e2 = EffectSpawn("war3mapImported\\wos_Marco bullet.mdl", x1, y1, a * bj_RADTODEG, 0.5, 0.7, 150)
                                call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_alucard bullet_backward.mdl", x1 + 130 * Cos(a), GetUnitY(c) + 130 * Sin(a), GetRandomReal(0, 359), 1, 1, 0), 1, 255, 255, 255, 1)
                                set rmax = 2
                                set r = 0
                            endif
                        elseif check == 1 then
                            if r5 >= r7 or k2 > 0 then
                                set r = 9999
                            endif
                            set k = 0
                           
                            set r5 = r5 + move
                            call MoveEff2(e, move, a)
                            call MoveEff2(e2, move, a)
                            if r6 >= 0.0 then
                                set r6 = 0
                                call GroupClear( g )
                                call GroupEnumUnitsInRange( g , GetEffX(e) , GetEffY(e) , aoe , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null or k2 > 0
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup( u , g2 ) == false then
                                        if k2 == 0 then
                                            call dmgmag(c, u, dmg)
                                            if LoadInteger(hs, GetHandleId(c), StringHash("Inori E Active")) == 0 and LoadInteger(hs, GetHandleId(c), StringHash("pas cd")) == 0 then
                                                set check3 = LoadInteger(hs, GetHandleId(c), StringHash("Inori E"))
                                                if check3 < 4 then
                                                    call SaveInteger(hs, GetHandleId(c), StringHash("Inori E"), check3 + 1 )
                                                endif
                                            endif
                                            set k2 = k2 + 1
                                            call MUE(u, 50, 0.12, a)
                                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                        endif
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                            else
                                set r6 = r6 + 0.03
                            endif
                            if r2 >= 0.03 then
                                set r2 = 0
                                call DecorRemove(c, GetEffX(e) , GetEffY(e), aoe + 75 , 25)
                                call VisionTimed(GetOwningPlayer(c), GetEffX(e) , GetEffY(e), 600, 1)
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif
                    elseif check2 == 1 then
                        if r == 0.03 then
                            set move = 30
                            set r5 = 0
                            set x1 = GetUnitX(c) + 0 * Cos(a)
                            set y1 = GetUnitY(c) + 0 * Sin(a)
                            set rmax = 2
                        endif
                        set k = 0
                        if r > 0.45 then
                            loop
                                exitwhen k > 2 or r > 99
                                set r5 = r5 + move
                                if r5 >= InoriEQ_Range then
                                    set r = 9999
                                endif
                                set x1 = x1 + move * Cos(a)
                                set y1 = y1 + move * Sin(a)
                                call MyRemoveEff(EffectSpawn3("war3mapImported\\Wos_InoriCrystall.mdl", x1, y1, a * bj_RADTODEG + 180 + GetRandomReal( -10, 10), GetRandomReal(2.5, 3.25), GetRandomReal(0.45, 0.8), 130, -90), 0.5)
                                set k = k + 1
                            endloop
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , x1 , y1 , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    if IsUnitInGroup( u , g2 ) == false then
                                        call dmgmag(c, u, dmg)
                                        call StunUnit(c, u, InoriEQ_Stun)
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                           
                                        call GroupAddUnit( g2 , u )
                                    endif
                                    call MoveUnit(u, move * 4.5, a)
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                            if r2 >= 0.03 then
                                set r2 = 0
                                call DecorRemove(c, x1, y1, aoe + 90, 50)
                                call VisionTimed(GetOwningPlayer(c), x1 + move * Cos(a), y1 + move * Sin(a), 600, 1)
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif
                    elseif check2 == 2 then
                        if r == 0.45 then
                            set move = 23
                            set r5 = 0
                            call MakeSound("war3mapimported\\Hero_Inori_Q4")
                            set x1 = GetUnitX(c) + 0 * Cos(a)
                            set y1 = GetUnitY(c) + 0 * Sin(a)
                            set e = EffectSpawn("war3mapImported\\wos_Rapid fire.mdl", GetUnitX(c) + 100 * Cos(a), GetUnitY(c) + 100 * Sin(a), a * bj_RADTODEG, 1, 2.8*(r7/1400), 100)
                        endif
                        if r == 1.02 then
                            call MakeSound("war3mapimported\\Hero_Inori_Q4")
                        endif
                        if r >= 0.45 then
                            call BlzSetSpecialEffectPosition(e, GetUnitX(c) + 90 * Cos(a), GetUnitY(c) + 90 * Sin(a), 100)
                            if r2 >= 0.27 then
                                call GroupClear(g2)
                                set r2 = 0
                                set k = 0
                                set r4 = r7 / 6.3
                                loop
                                    exitwhen k == 6
                                    call DecorRemove(c, GetUnitX(c) + r4 * Cos(a), GetUnitY(c) + r4 * Sin(a), aoe + 90, 50)
                                    call VisionTimed(GetOwningPlayer(c), GetUnitX(c) + r4 * Cos(a), GetUnitY(c) + r4 * Sin(a), 600, 1)
                                    call GroupClear( g )
                                    call GroupEnumUnitsInRange( g , GetUnitX(c) + r4 * Cos(a), GetUnitY(c) + r4 * Sin(a) , aoe , NoDecor_Cond)
                                    loop
                                        set u = FirstOfGroup( g )
                                        exitwhen u == null
                                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                            if IsUnitInGroup( u , g2 ) == false then
                                                call dmgmag(c, u, dmg)
                                                call StunUnit(c, u, InoriFQ_StunPeriodic )
                                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                                call MUE(u, 50, 0.12, a)
                                                call GroupAddUnit( g2 , u )
                                            endif
                                        endif
                                        call GroupRemoveUnit( g , u )
                                    endloop
                                    set u = null
                                    set r4 = r4 + r7 / 7.2
                                    set k = k + 1
                                endloop
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif
                    endif
                else
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call SetUnitTimeScale( c , 1)
                    if r <= 0.39 or check2 >= 1 then
                        call StopSpellUnit2(c)
                    endif
                    if check2 == 2 then
                        call StopSpellUnit(c)
                    endif
                    call DestroyGroup( g2 )
                    call DestroyGroup( g )
                    set g = null
                    set e = null
                    set e2 = null
                    set g2 = null
                    set c = null
                    set u = null
                    set m_InoriQ[i] = m_InoriQ[ MUI_InoriQ]
                    set MUI_InoriQ = MUI_InoriQ - 1
                    if MUI_InoriQ == -1 then
                        call PauseTimer( t_InoriQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method InoriQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_InoriQ = MUI_InoriQ + 1
            set m_InoriQ[ MUI_InoriQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set move = 0
            set r6 = 0
            set r7 = InoriQ_Range + InoriQ_RangeADD*(GetUnitAbilityLevel(c,InoriQ_ID)-1) + (GetHeroInt(c, true)*2)
            set check2 = 0
            set check3 = 0
            set k2 = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set check = 0
            set k = 0
            set r5 = 0
            set aoe = InoriQ_DamageAoe
            set dmg = GetHeroInt( c , true) * ( InoriQ_DamageIntBase + ( InoriQ_DamageIntStep * ( GetUnitAbilityLevel( c , InoriQ_ID) - 1 ) ) )
            set dmg = dmg + InoriQ_Damage2StaticBase + ( InoriQ_Damage2StaticStep * ( GetUnitAbilityLevel( c , InoriQ_ID) - 1 ) )
            set rmax = 4
            if LoadInteger(hs, GetHandleId(c), StringHash("Inori E Active")) == 1 then
                set check2 = 1
                set aoe = InoriEQ_DamageAoe
                set dmg = GetHeroInt( c , true) * ( InoriEQ_DamageIntBase + ( InoriEQ_DamageIntStep * ( GetUnitAbilityLevel( c , InoriQ_ID) - 1 ) ) )
                set dmg = dmg + InoriEQ_Damage2StaticBase + ( InoriEQ_Damage2StaticStep * ( GetUnitAbilityLevel( c , InoriQ_ID) - 1 ) )
                call SetUnitAnimationByIndex(c, 6)
                call MakeSound("war3mapimported\\Hero_Inori_W2 1")
                call MakeSound("war3mapimported\\Hero_Inori_EQ")
            elseif LoadInteger(hs, GetHandleId(c), StringHash("mode f")) == 1 then
                set check2 = 2
                set rmax = 1.95
                call StartSpellUnit(c)
                set dmg = GetHeroInt( c , true) * ( InoriFQ_DamageIntBase + ( InoriFQ_DamageIntStep * ( GetUnitAbilityLevel( c , InoriQ_ID) - 1 ) ) )
                set dmg = dmg + InoriFQ_Damage2StaticBase + ( InoriFQ_Damage2StaticStep * ( GetUnitAbilityLevel( c , InoriQ_ID) - 1 ) )
                set dmg = dmg / 5
                set aoe = InoriFQ_DamageAoe
                call MakeSound("war3mapimported\\Hero_Inori_Q2")
                call SetUnitAnimationByIndex(c, 5)
            else
                call SetUnitAnimationByIndex(c, 2)
                call SetUnitTimeScale(c, 0.65)
                set k = GetRandomInt(1, 5)
                call MakeSound("war3mapimported\\Hero_Inori_Q3")
                call MakeSound("war3mapimported\\Hero_Inori_Q5")
            endif
            if MUI_InoriQ == 0 then
                call TimerStart( t_InoriQ, 0.03, true, function thistype.Loop_InoriQ)
            endif
        endmethod
    endstruct

    private struct InoriQ2_KS
        private static timer t_InoriQ2 = CreateTimer( )
        private static integer array m_InoriQ2
        private static integer MUI_InoriQ2 = -1
        unit c
        real x
        real y
        real x1
        real y1
        real x2
        real y2
        real r2
        integer k
        real r5
        group g
        group g2
        unit u
        real dmg
        real aoe
        real move
        real r
        real a
        real a2
        real rmax
        private static method Loop_InoriQ2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_InoriQ2
                set this = m_InoriQ2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r == 0.03 then
                        set move = 23
                        set r5 = 0
                        set x1 = GetUnitX(c) + 225 * Cos(a + 110 * bj_DEGTORAD)
                        set y1 = GetUnitY(c) + 225 * Sin(a + 110 * bj_DEGTORAD)
                        set x2 = GetUnitX(c) + 225 * Cos(a - 110 * bj_DEGTORAD)
                        set y2 = GetUnitY(c) + 225 * Sin(a - 110 * bj_DEGTORAD)
                        set rmax = 2
                        set a = GAngle4(x1, y1, x, y)
                        set a2 = GAngle4(x2, y2, x, y)
                    endif
                    if r< 0.3 then 
                    call DebugUnit2(c)
                    endif
                    if r == 0.3 then 
                    call StopSpellUnit2(c)
                    endif
                    set k = 0
                    loop
                        exitwhen k > 1 or r > 99
                        set r5 = r5 + move
                        if r5 >= InoriTQ_Range then
                            set r = 9999
                        endif
                        set x1 = x1 + move * Cos(a)
                        set y1 = y1 + move * Sin(a)
                        set x2 = x2 + move * Cos(a2)
                        set y2 = y2 + move * Sin(a2)
                        call MyRemoveEff(EffectSpawn3("war3mapImported\\Wos_InoriCrystall.mdl", x1, y1, a * bj_RADTODEG + 180 + GetRandomReal( -10, 10), GetRandomReal(1.5, 2.25), GetRandomReal(0.75, 1.5), 130, -90), 0.6)
                        call MyRemoveEff(EffectSpawn3("war3mapImported\\Wos_InoriCrystall.mdl", x2, y2, a2 * bj_RADTODEG + 180 + GetRandomReal( -10, 10), GetRandomReal(1.5, 2.25), GetRandomReal(0.75, 1.5), 130, -90), 0.6)
                        set k = k + 1
                    endloop
                    call GroupClear( g )
                    call GroupEnumUnitsInRange( g , x1 , y1 , aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                            if IsUnitInGroup( u , g2 ) == false then
                                call dmgmag(c, u, dmg)
                                call StunUnit(c, u, 0.5)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                call GroupAddUnit( g2 , u )
                            endif
                            call MoveUnit(u, move * 2.5, a)
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    set u = null
                    call GroupClear( g )
                    call GroupEnumUnitsInRange( g , x2 , y2 , aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                            if IsUnitInGroup( u , g2 ) == false then
                                call dmgmag(c, u, dmg)
                                call StunUnit(c, u, InoriTQ_Stun)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                call GroupAddUnit( g2 , u )
                            endif
                            call MoveUnit(u, move * 2.5, a2)
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    set u = null
                    if r2 >= 0.03 then
                        set r2 = 0
                        call DecorRemove(c, x1, y1, aoe + 150, 110)
                        call VisionTimed(GetOwningPlayer(c), x1 + move * Cos(a), y1 + move * Sin(a), 600, 1)
                        call DecorRemove(c, x2, y2, aoe + 150, 110)
                        call VisionTimed(GetOwningPlayer(c), x2 + move * Cos(a), y2 + move * Sin(a), 600, 1)
                    else
                        set r2 = r2 + 0.03
                    endif
                else
                    call SetUnitTimeScale( c , 1)
                    if r<0.3 then                     
                    call StopSpellUnit2(c)
                    endif
                    call DestroyGroup( g2 )
                    call DestroyGroup( g )
                    set g = null
                    set g2 = null
                    set c = null
                    set u = null
                    set m_InoriQ2[i] = m_InoriQ2[ MUI_InoriQ2]
                    set MUI_InoriQ2 = MUI_InoriQ2 - 1
                    if MUI_InoriQ2 == -1 then
                        call PauseTimer( t_InoriQ2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method InoriQ2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_InoriQ2 = MUI_InoriQ2 + 1
            set m_InoriQ2[ MUI_InoriQ2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set move = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set k = 0
            set aoe = InoriTQ_DamageAoe
            set dmg = GetHeroInt( c , true) * ( InoriTQ_DamageIntBase + ( InoriTQ_DamageIntStep * ( GetUnitAbilityLevel( c , InoriQ_ID) - 1 ) ) )
            set dmg = dmg + InoriTQ_Damage2StaticBase + ( InoriTQ_Damage2StaticStep * ( GetUnitAbilityLevel( c , InoriQ_ID) - 1 ) )
            set rmax = 0.9
            call SetUnitAnimationByIndex(c, 6)
            call SetUnitTimeScale(c, 0.65)
            set k = GetRandomInt(1, 5)
            call MakeSound("war3mapimported\\Hero_Inori_TQ3")
            call MakeSound("war3mapimported\\Hero_Inori_TQ2")
            if MUI_InoriQ2 == 0 then
                call TimerStart( t_InoriQ2, 0.03, true, function thistype.Loop_InoriQ2)
            endif
        endmethod
    endstruct

    private struct InoriW_KS
        private static timer t_InoriW = CreateTimer( )
        private static integer array m_InoriW
        private static integer MUI_InoriW = -1
        unit c
        unit td
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        real r4
        real r5
        real dmg
        integer check
        integer check3
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
        private static method Loop_InoriW takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_InoriW
                set this = m_InoriW[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set r = RoundReal(r, 3)
                    set a = GAngle(c, td)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call SetUnitFacing(c, a * bj_RADTODEG)
                    if check == 0 then
                        call BlzSetSpecialEffectPosition(e, x, y, BlzGetUnitZ(td))
                        call BlzSetSpecialEffectPosition(e4, GetUnitX(c), GetUnitY(c), BlzGetUnitZ(c) + 1)
                        call BlzSetSpecialEffectPosition(e6, GetUnitX(td), GetUnitY(td), BlzGetUnitZ(td) + 1)
                        if GetUnitCurrentOrder(c) != OrderId("acidbomb") or SR3(td, x1, y1) > r5 then
                            set r = 9999
                        endif
                        if r2 > 0.21 then
                            set r2 = 0
                            call OkarunEggCd(c, InoriW_ID, BlzGetAbilityCooldown(InoriW_ID, GetUnitAbilityLevel(c, InoriW_ID) - 1))
                            call SetHpCurrent2(c,td,r4)
                            set x = GetUnitX(c)
                            set y = GetUnitY(c)
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_3.mdl", x, y, GetRandomReal(0, 359), 1.15, 2.35, 1, 255, 255, 255, 90))
                        else
                            set r2 = r2 + 0.03
                        endif
                    elseif check == 1 or check == 2 then
                        call DebugUnit2(c)
                        if r == 0.3 then
                            call SetUnitAnimationByIndex( c , 1)
                            if check == 2 then
                                set move = 80
                                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_3.mdl", x, y, GetRandomReal(0, 359), 1.15, 2.35, 1, 255, 255, 255, 90))
                            endif
                        endif
                        if r > 0.42 then
                            if SR2(c, td) > 120 then
                                call MoveUnit(c, move, a)
                                if check == 2 then
                                    call BlinkEff2(c)
                                endif
                            else
                                set x = GetUnitX(td)
                                set y = GetUnitY(td)
                                set k = 0
                                if check == 1 then
                                    call MakeSound("war3mapImported\\Hero_Inori_EW3")
                                    call EUTU2_3(EffectSpawn("war3mapImported\\wos_shootgb1afx.mdl", x , y , a * bj_RADTODEG, 0.8, 1.45, 95), 1.2, 95, td)
                                    call EUTU2_3(EffectSpawn("war3mapImported\\wos_A_[spell]elementaleffectholy_W2.mdl", x, y, GetRandomReal(0, 359), 0.5, 6, 75), 1, 75, td)
                                    call EUTU2(EffectSpawn2("war3mapimported\\wos_LightBlueLand.mdl", x, y, GetRandomReal(0, 359), 3, 0.15, 1, 0.33), 1, 1, td)
                                    call StunUnit(c, td, InoriW_Stun)
                                else
                                    call StunUnit(c, td, InoriEW_Stun)
                                    set k = 0
                                    set r5 = 0
                                    set r4 = 0.3
                                    call MUE(c, 350, 0.15, a)
                                    if check == 2 then
                                        call HeightSet(td, 0.21, 250)
                                        call HeightSet2(td, 0.21, 0, 0.3)
                                    endif
                                    loop
                                        exitwhen k == 9
                                        if k == 0 then
                                            call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_jiejin.mdl", x, y, GetRandomReal(0, 359), 4.15, 2.35, 0, 0.45, 0.01, 1.25), 0.51, 255, 255, 255, 0.51)
                                        else
                                            call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_jiejin.mdl", x + r5 * Cos(a + 35 * bj_DEGTORAD), y + r5 * Sin(a + 35 * bj_DEGTORAD), GetRandomReal(0, 359), 2.15, 0.01, 0, 0.45, 0.01, r4), 0.42 + k * 0.03, 255, 255, 255, 0.51)
                                            call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_jiejin.mdl", x + r5 * Cos(a - 35 * bj_DEGTORAD), y + r5 * Sin(a - 35 * bj_DEGTORAD), GetRandomReal(0, 359), 2.15, 0.01, 0, 0.45, 0.01, r4), 0.42 + k * 0.03, 255, 255, 255, 0.51)
                                            call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_jiejin.mdl", x + r5 * Cos(a - 215 * bj_DEGTORAD), y + r5 * Sin(a - 215 * bj_DEGTORAD), GetRandomReal(0, 359), 2.15, 0.01, 0, 0.45, 0.01, r4), 0.42 + k * 0.03, 255, 255, 255, 0.51)
                                            call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_jiejin.mdl", x + r5 * Cos(a + 215 * bj_DEGTORAD), y + r5 * Sin(a + 215 * bj_DEGTORAD), GetRandomReal(0, 359), 2.15, 0.01, 0, 0.45, 0.01, r4), 0.42 + k * 0.03, 255, 255, 255, 0.51)
                                        endif
                                        set r5 = r5 + 75
                                        set r4 = r4 + 0.04
                                        set k = k + 1
                                    endloop
                                    call MakeSound("war3mapimported\\Hero_Inori_EQ2")
                                    call MakeSound("war3mapimported\\Hero_Inori_W4")
                                    call EUTU2(EffectSpawn("war3mapImported\\wos_ld2209 (199).mdl", x, y, a * bj_RADTODEG + 27.5, 1, 4, 110), 0.36, 110, td)
                                    call EUTU2(EffectSpawn("war3mapImported\\wos_ld2209 (199).mdl", x, y, a * bj_RADTODEG - 27.5, 1, 4, 110), 0.36, 110, td)
                                endif
                                set r = 999999
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", td, "chest"))
                                if check == 1 then
                                    if LoadInteger(hs, GetHandleId(c), StringHash("Inori E Active")) == 0 and LoadInteger(hs, GetHandleId(c), StringHash("pas cd")) == 0 then
                                        set check3 = LoadInteger(hs, GetHandleId(c), StringHash("Inori E"))
                                        if check3 < 4 then
                                            call SaveInteger(hs, GetHandleId(c), StringHash("Inori E"), check3 + 1 )
                                        endif
                                    endif
                                    call dmgmag(c, td, dmg)
                                else
                                    call dmgmag(c, td, dmg)
                                endif
                                call SetAnim(td, 0.03, "death")
                            endif
                        endif
                    endif
                else
                    if check > 0 then
                        call StopSpellUnit2(c)
                    else
                        call OkarunEggCd(c, InoriW_ID, BlzGetAbilityCooldown(InoriW_ID, GetUnitAbilityLevel(c, InoriW_ID) - 1))
                        call StopSound(gg_snd_Hero_Inori_W_2, false, false)
                        call DestroyEffect(e2)
                        call DestroyEffect(e3)
                        call DestroyEffect(e5)
                        call ColorEffDummy3(e, 0, 255, 255, 255, 0.39)
                        call ColorEffDummy3(e4, 0, 255, 255, 255, 0.39)
                        call ColorEffDummy3(e6, 0, 255, 255, 255, 0.39)
                    endif
                    set c = null
                    set td = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set e5 = null
                    set m_InoriW[i] = m_InoriW[ MUI_InoriW]
                    set MUI_InoriW = MUI_InoriW - 1
                    if MUI_InoriW == -1 then
                        call PauseTimer( t_InoriW)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method InoriW_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_InoriW = MUI_InoriW + 1
            set m_InoriW[ MUI_InoriW] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set check = 0
            set check3 = 0
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set x1 = GetUnitX(td)
            set y1 = GetUnitY(td)
            set a = GAngle( c , td ) // Angle Between points
            set dmg = GetHeroInt( c , true) * ( InoriW_DamageIntBase + ( InoriW_DamageIntStep * ( GetUnitAbilityLevel( c , InoriW_ID) - 1 ) ) )
            set dmg = dmg + InoriW_DamageStaticBase + ( InoriW_DamageStaticStep * ( GetUnitAbilityLevel( c , InoriW_ID) - 1 ) )
            set rmax = 2
            if LoadInteger(hs, GetHandleId(c), StringHash("Inori E Active")) == 1 then
                set check = 2
                set dmg = GetHeroInt( c , true) * ( InoriEW_DamageIntBase + ( InoriEW_DamageIntStep * ( GetUnitAbilityLevel( c , InoriW_ID) - 1 ) ) )
                set dmg = dmg + InoriEW_DamageStaticBase + ( InoriEW_DamageStaticStep * ( GetUnitAbilityLevel( c , InoriW_ID) - 1 ) )
                call MakeSound("war3mapimported\\Hero_Inori_W2 2")
                call SetUnitAnimationByIndex( c , 10)
                call SetUnitTimeScale(c, 0.25)
            elseif IsUnitEnemy(td, GetOwningPlayer(c)) then
                set check = 1
                call StartSpellUnit2(c)
                call SetUnitFacing(c, a * bj_RADTODEG)
                call SetUnitTimeScale(c, 2.5)
                call SetUnitAnimationByIndex( c , 6)
                call MakeSound("war3mapimported\\Hero_Inori_W6")
            endif
            if check == 0 then
                set r5 = 1000
                call StartSound(gg_snd_Hero_Inori_W_2)
                set r4 = GetHeroInt( c , true) * ( InoriW_HealBaseInt + ( InoriW_HealStepInt * ( GetUnitAbilityLevel( c , InoriW_ID) - 1 ) ) )
                set r4 = r4 + InoriW_HealBaseStatic + ( InoriW_HealStaticStep * ( GetUnitAbilityLevel( c , InoriW_ID) - 1 ) )
                set rmax = 99
                set r4 = r4 / 29
                set check3 = LoadInteger(hs, GetHandleId(c), StringHash("Inori E"))
                if LoadInteger(hs, GetHandleId(c), StringHash("Inori E Active")) == 0 and LoadInteger(hs, GetHandleId(c), StringHash("pas cd")) == 0 then
                    set check3 = LoadInteger(hs, GetHandleId(c), StringHash("Inori E"))
                    if check3 < 4 then
                        call SaveInteger(hs, GetHandleId(c), StringHash("Inori E"), check3 + 1 )
                    endif
                endif
                call MakeSound("war3mapimported\\HeroInori_W3")
                set e = EffectSpawn("war3mapImported\\wos_[sz]shizhilvzhe3.mdl", x, y, 1, 1, 2, 1)
                set e2 = EffectSpawnColor("war3mapImported\\wos_tx-tsqyuanxing2.mdl", x, y, 1, 0.5, 1.7, 4, 255, 255, 255, 100)
                set e3 = AddSpecialEffectTarget("war3mapImported\\wos_az_airfloww111_pink.mdl", c, "origin")
                set e4 = EffectSpawn("war3mapImported\\wos_music circle1.mdl", x, y, 1, 1, 1, 1)
                set e5 = AddSpecialEffectTarget("war3mapImported\\wos_zdgq.mdl", td, "origin")
                set e6 = EffectSpawn("war3mapImported\\wos_buliding_pedestal_red.mdl", x, y, 1, 1, 1.4, 1)
                call SetUnitAnimationByIndex( c , 7)
            endif
            call SetUnitFacing(c, a * bj_RADTODEG)
            set move = 70
            if MUI_InoriW == 0 then
                call TimerStart( t_InoriW, 0.03, true, function thistype.Loop_InoriW)
            endif
        endmethod
    endstruct

    private struct InoriW2_KS
        private static timer t_InoriW2 = CreateTimer( )
        private static integer array m_InoriW2
        private static integer MUI_InoriW2 = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        real r3
        real r4
        group g
        unit u
        real dmg
        real aoe
        real r
        effect e
        real a
        real rmax
        private static method Loop_InoriW2 takes nothing returns nothing
            local integer this
            local real rr1 = 0
            local real rr2 = 0
            local real rr3 = 0
            local real rr4 = 0
            local real rr5 = 0
            local real rr6 = 0
            local real rr7 = 0
            local real rr8 = 0
            local integer i = 0
            loop
                exitwhen i > MUI_InoriW2
                set this = m_InoriW2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set r = RoundReal(r, 3)
                    if r2 > 0.06 then
                        set r2 = 0
                        set k = 0
                        loop
                            exitwhen k == 2
                            set rr1 = GetRandomReal(0, aoe / 2)
                            if k == 0 then
                                set rr2 = a + 90 * bj_DEGTORAD
                            else
                                set rr2 = a - 90 * bj_DEGTORAD
                            endif
                            set rr3 = GetRandomReal(750, 1100)
                            set x1 = GetUnitX(c) + rr1 * Cos(rr2)
                            set y1 = GetUnitY(c) + rr1 * Sin(rr2)
                            set rr4 = GetRandomReal(0, aoe / 1.75)
                            set rr5 = GetRandomReal(0, 359) * bj_DEGTORAD
                            set rr6 = SR0(x + rr4 * Cos(rr5), y + rr4 * Sin(rr5), x1, y1)
                            set rr7 = GetRandomReal(0.75, 1.35)
                            set rr8 = GetRandomReal(1.75, 2.45)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_FantasyBattle (1644).mdx", x1, y1, 1, 1, 2, rr3))
                            set e = EffectSpawn3("war3mapImported\\Wos_InoriCrystall_atch2.mdl", x1, y1, a * bj_RADTODEG, rr8, rr7, rr3, -225 )
                            set rr2 = GetRandomReal(0.15, 0.24)
                            set rr3 = GetRandomReal(45, 120)
                            call EMUE(e, rr6, rr2, a)
                            call EHeightSet(e, rr2, rr3)
                            set rr1 = GetRandomReal(0.35, 0.51)
                            call MyRemoveEff(e, rr1)
                            set k = k + 1
                        endloop
                    else
                        set r2 = r2 + 0.03
                    endif
                    if r4 > 0.0 then
                        set r4 = 0
                        set rr1 = GetRandomReal(1, 1.45)
                        set rr2 = GetRandomReal(1.25, 2)
                        set rr4 = GetRandomReal(0, aoe - 100)
                        set rr5 = GetRandomReal(0, 359) * bj_DEGTORAD
                        set x1 = x + rr4 * Cos(rr5)
                        set y1 = y + rr4 * Sin(rr5)
                        call EffectSpawn2("war3mapImported\\wos_1bing_8_inori.mdl", x1, y1, GetRandomReal(0, 359), rr1, rr2, 1, 0.51)
                        set rr1 = GetRandomReal(1, 1.45)
                        set rr2 = GetRandomReal(1.25, 2)
                        set rr4 = GetRandomReal(0, aoe - 100)
                        set rr5 = GetRandomReal(0, 359) * bj_DEGTORAD
                        set x1 = x + rr4 * Cos(rr5)
                        set y1 = y + rr4 * Sin(rr5)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_FantasyBattle (1644).mdx", x1, y1, 1, 0.6, 2, 50))
                    else
                        set r4 = r4 + 0.03
                    endif
                    if r3 > 0.21 then
                        set r3 = 0
                        call DecorRemove(c, x, y, aoe, 50)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                call dmgmag(c, u, dmg)
                                call StunUnit(c, u, InoriTW_Stun)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    else
                        set r3 = r3 + 0.03
                    endif
                else
                    call DestroyGroup(g)
                    set c = null
                    set e = null
                    set g = null
                    set u = null
                    set m_InoriW2[i] = m_InoriW2[ MUI_InoriW2]
                    set MUI_InoriW2 = MUI_InoriW2 - 1
                    if MUI_InoriW2 == -1 then
                        call PauseTimer( t_InoriW2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method InoriW2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_InoriW2 = MUI_InoriW2 + 1
            set m_InoriW2[ MUI_InoriW2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set g = CreateGroup()
            set u = null
            set r2 = 0
            set r3 = 0
            set a = GAngle2(c, x, y) // Angle Between points
            set dmg = GetHeroInt( c , true) * ( InoriTW_DamageIntBase + ( InoriTW_DamageIntStep * ( GetUnitAbilityLevel( c , InoriW_ID) - 1 ) ) )
            set dmg = dmg + InoriTW_DamageStaticBase + ( InoriTW_DamageStaticStep * ( GetUnitAbilityLevel( c , InoriW_ID) - 1 ) )
            set aoe = InoriTW_DamageAoe
            set dmg = dmg / 4
            set rmax = 1.3
            set a = GAngle2(c, x, y) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            call MakeSound("war3mapImported\\Hero_Inori_TW2")
            call MakeSound("war3mapImported\\Hero_Inori_TW4")
            call SetUnitAnimationByIndex( c , 6)
            call SetUnitTimeScale(c, 0.95)
            if MUI_InoriW2 == 0 then
                call TimerStart( t_InoriW2, 0.03, true, function thistype.Loop_InoriW2)
            endif
        endmethod
    endstruct

    private struct InoriE_KS
        private static timer t_InoriE = CreateTimer( )
        private static integer array m_InoriE
        private static integer MUI_InoriE = -1
        unit c
        real r2
        integer k
        integer k2
        integer k3
        integer k4
        integer check
        integer check2
        integer check3
        real r
        effect e
        effect e2
        effect e3
        real rmax
        framehandle array frame_pas1 [10]
        framehandle array frame_pas2 [10]
        framehandle array frame_pas3 [10]
        framehandle array frame_pas4 [10]
        framehandle array frame_pas5 [10]
        framehandle array frame_pas6 [10]
        private static method Loop_InoriE takes nothing returns nothing
            local integer this
            local integer i = 0
            local real fk
            loop
                exitwhen i > MUI_InoriE
                set this = m_InoriE[i]
                if GetUnitTypeId(c) == check2 then
                    if k3 == 0 then
                        set check = LoadInteger(hs, GetHandleId(c), StringHash("Inori E"))
                        set fk = GetUnitFacing(c) * bj_DEGTORAD
                        if LoadInteger(hs, GetHandleId(c), StringHash("mode t")) == 1 then
                            set k4 = 0
                        endif
                        if k4 == 0 and LoadInteger(hs, GetHandleId(c), StringHash("pas cd")) == 0 and LoadInteger(hs, GetHandleId(c), StringHash("Inori E Active")) == 0 and LoadInteger(hs, GetHandleId(c), StringHash("mode t")) == 0 then
                            call BlzSetSpecialEffectAlpha(e, 0)
                            call DestroyEffect(e)
                            set e = null
                            set e = AddSpecialEffectTarget("war3mapImported\\wos_Inori_Bar.mdl", c, "origin")
                            set k4 = 1
                            call ColorEffDummy4(e, 0, 255, 255, 255, 0.51)
                            call BlzPlaySpecialEffect(e, ANIM_TYPE_DEATH)
                            set check3 = 0
                        endif
                        set fk = 0
                        if check == 0 and check != check3 then
                            set fk = 1
                            set check3 = 0
                            if GetUnitAbilityLevel(c, InoriEE_ID) > 0 then
                                call UnitRemoveAbility(c, InoriEE_ID)
                                call SaveInteger(hs, GetHandleId(c), StringHash("e activated"), 0)
                                call SaveInteger(hs, GetHandleId(c), StringHash("e activated2"), 0)
                                call SetPlayerAbilityAvailable(GetOwningPlayer(c), InoriE_ID, true)
                            endif
                            call BlzPlaySpecialEffect(e, ANIM_TYPE_DEATH)
                        elseif check == 1 and check != check3 then
                            set fk = 1
                            set check3 = 1
                            call BlzPlaySpecialEffect(e, ANIM_TYPE_ATTACK)
                        elseif check == 2 and check != check3 then
                            set fk = 1
                            set check3 = 2
                            call BlzPlaySpecialEffect(e, ANIM_TYPE_DECAY)
                        elseif check == 3 and check != check3 then
                            set fk = 1
                            set check3 = 3
                            call BlzPlaySpecialEffect(e, ANIM_TYPE_DISSIPATE)
                        elseif check == 4 and check != check3 then
                            set check3 = 5
                            if LoadInteger(hs, GetHandleId(c), StringHash("e activated2")) == 0 then
                                call SaveInteger(hs, GetHandleId(c), StringHash("e activated2"), 1)
                                set fk = 1
                            else
                                set fk = 0
                            endif
                            call BlzPlaySpecialEffect(e, ANIM_TYPE_MORPH)
                            if GetUnitAbilityLevel(c, InoriEE_ID) == 0 and LoadInteger(hs, GetHandleId(c), StringHash("mode t")) == 0 then
                                call UnitAddAbility(c, InoriEE_ID)
                                call SetPlayerAbilityAvailable(GetOwningPlayer(c), InoriE_ID, false)
                            endif
                            if k3 == 0 and LoadInteger(hs, GetHandleId(c), StringHash("e activated")) == 1 then
                                set k3 = 1
                                call UnitRemoveAbility(c, InoriEE_ID)
                                call SaveInteger(hs, GetHandleId(c), StringHash("Inori E"), 0)
                                call SaveInteger(hs, GetHandleId(c), StringHash("Inori E Active"), 1)
                                call SetPlayerAbilityAvailable(GetOwningPlayer(c), InoriE_ID, true)
                                call SaveInteger(hs, GetHandleId(c), StringHash("e activated"), 0)
                                set r = 0
                                call ColorEffDummy32(e, 0, 255, 255, 255, 0.51)
                                set k = GetRandomInt(1, 3)
                                if k == 1 then
                                    call MakeSound("war3mapimported\\Hero_Inori_E1")
                                elseif k == 2 then
                                    call MakeSound("war3mapimported\\Hero_Inori_E2")
                                elseif k == 3 then
                                    call MakeSound("war3mapimported\\Hero_Inori_E3")
                                endif
                                call MakeSound("war3mapimported\\Hero_Inori_E4")
                                set e2 = AddSpecialEffectTarget("war3mapimported\\Wos_InoriCrystall_atch.mdx", c, "hand right")
                                set e3 = AddSpecialEffectTarget("war3mapimported\\Wos_InoriCrystall_atch.mdx", c, "hand left")
                                call UnitAddAbility(c, InoriE_Atk_ID)
                                call AddSpellLevel(c, 'A01C', GetUnitAbilityLevel(c, InoriE_ID), true)
                                call SetUnitAbilityLevel(c, InoriE_Atk_ID, GetUnitAbilityLevel(c, InoriE_ID))
                                if GetUnitAbilityLevel(c, InoriE_ID) == 1 then
                                    call UnitAddAbility(c, InoriE_Regen1_ID)
                                elseif GetUnitAbilityLevel(c, InoriE_ID) == 2 then
                                    call UnitAddAbility(c, InoriE_Regen2_ID)
                                elseif GetUnitAbilityLevel(c, InoriE_ID) == 3 then
                                    call UnitAddAbility(c, InoriE_Regen3_ID)
                                elseif GetUnitAbilityLevel(c, InoriE_ID) == 4 then
                                    call UnitAddAbility(c, InoriE_Regen4_ID)
                                elseif GetUnitAbilityLevel(c, InoriE_ID) == 5 then
                                    call UnitAddAbility(c, InoriE_Regen5_ID)
                                endif
                                if GetUnitAbilityLevel(c, InoriQ2_ID) == 0 then
                                    call UnitAddAbility(c, InoriQ2_ID)
                                    call UnitAddAbility(c, InoriW2_ID)
                                endif
                                  //  call BlzStartUnitAbilityCooldown(c,InoriQ2_ID,BlzGetUnitAbilityCooldownRemaining(c,InoriQ_ID)-5)
                                   // call BlzStartUnitAbilityCooldown(c,InoriW2_ID,BlzGetUnitAbilityCooldownRemaining(c,InoriW_ID)-5)
                                call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_FSAeff (203).mdl", c, "origin"))
                                call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_FSAeff (199).mdl", c, "origin"))
                                call SetUnitAbilityLevel(c, InoriQ2_ID, GetUnitAbilityLevel(c, InoriQ_ID))
                                call SetUnitAbilityLevel(c, InoriW2_ID, GetUnitAbilityLevel(c, InoriW_ID))
                                if GetUnitAbilityLevel(c, InoriR_ID) > 0 then
                                    call UnitAddAbility(c, InoriER_ID)
                                    call SetUnitAbilityLevel(c, InoriER_ID, GetUnitAbilityLevel(c, InoriR_ID))
                                  //  call BlzStartUnitAbilityCooldown(c,InoriER_ID,BlzGetUnitAbilityCooldownRemaining(c,InoriR_ID)-5)
                                endif
                                call SetPlayerAbilityAvailable(Player(k2), InoriQ2_ID, true)
                                call SetPlayerAbilityAvailable(Player(k2), InoriW2_ID, true)
                                call SetPlayerAbilityAvailable(Player(k2), InoriER_ID, true)
                                call SetPlayerAbilityAvailable(Player(k2), InoriQ_ID, false)
                                call SetPlayerAbilityAvailable(Player(k2), InoriW_ID, false)
                                call SetPlayerAbilityAvailable(Player(k2), InoriR_ID, false)
                                set rmax = InoriE_Duration
                                if frame_pas1[k2] == null then
                                    set frame_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                                    call BlzFrameSetAbsPoint(frame_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18)
                                    call BlzFrameSetSize(frame_pas1[k2], 0.135, 0.035)
                                    call BlzFrameSetTexture(frame_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                                    call BlzFrameSetVisible(frame_pas1[k2], false)
                                    if GetLocalPlayer() == GetOwningPlayer(c) then
                                        call BlzFrameSetVisible(frame_pas1[k2], true)
                                    endif
                                    set frame_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame_pas1[k2], 0, 0)
                                    call BlzFrameSetAbsPoint(frame_pas2[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                                    call BlzFrameSetSize(frame_pas2[k2], 0.1, 0.019)
                                    set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)
                                    call BlzFrameSetSize(frame_pas3[k2], 0.1, 0.035)
                                    call BlzFrameSetScale(frame_pas3[k2], 0.5)
                                    call BlzFrameSetModel(frame_pas3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                                    call BlzFrameSetAbsPoint(frame_pas3[k2], FRAMEPOINT_CENTER, 0.05, 0.175)
                                    call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, rmax)
                                    call BlzFrameSetValue(frame_pas3[k2], 0)
                                    set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)
                                    call BlzFrameSetAbsPoint(frame_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18)
                                    call BlzFrameSetSize(frame_pas4[k2], 0.03, 0.03)
                                    call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Inori_E", 0, false)
                                    set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                                    call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                                    call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Void Absorbation:" + "|r")
                                    call BlzFrameSetScale(frame_pas5[k2], 0.9)
                                    set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                                    call BlzFrameSetAbsPoint(frame_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17)
                                    call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(rmax, 0, 2) + "|r")
                                    call BlzFrameSetScale(frame_pas6[k2], 0.9)
                                else
                                    if GetLocalPlayer() == GetOwningPlayer(c) then
                                        call BlzFrameSetVisible(frame_pas1[k2], true)
                                    endif
                                    call BlzFrameSetValue(frame_pas3[k2], r2)
                                endif
                            endif
                        endif
                        if fk == 1 then
                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_FSAeff (200).mdl", c, "origin"))
                        endif
                    else
                        if r < rmax and SpellBoolCaster(c) and LoadInteger(hs, GetHandleId(c), StringHash("mode t")) == 0 then
                            if IsUnitPaused(c) == false then
                                set r = r + 0.1
                                set r = RoundReal(r, 2)
                            endif
                            call BlzFrameSetValue(frame_pas3[k2], (rmax - r))
                            call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        else
                            set r = 0
                            set k4 = 0
                            set k3 = 0
                            if GetUnitCurrentOrder(c) == OrderId("bloodluston") or GetUnitCurrentOrder(c) == OrderId("coldarrows") or GetUnitCurrentOrder(c) == OrderId("breathoffrost") then
                                call IssueImmediateOrder(c, "stop")
                            endif
                            call UnitRemoveAbility(c, InoriEE_ID)
                            call BlzStartUnitAbilityCooldown(c,InoriQ_ID,BlzGetUnitAbilityCooldownRemaining(c,InoriQ2_ID))
                            call BlzStartUnitAbilityCooldown(c,InoriW_ID,BlzGetUnitAbilityCooldownRemaining(c,InoriW2_ID))
                            call SetPlayerAbilityAvailable(Player(k2), InoriQ2_ID, false)
                            call SetPlayerAbilityAvailable(Player(k2), InoriW2_ID, false)
                            call SetPlayerAbilityAvailable(Player(k2), InoriER_ID, false)
                            call AddSpellLevel(c, 'A01C', GetUnitAbilityLevel(c, InoriE_ID), false)
                            call UnitRemoveAbility(c, InoriE_Regen5_ID)
                            call UnitRemoveAbility(c, InoriE_Regen1_ID)
                            call UnitRemoveAbility(c, InoriE_Regen2_ID)
                            call UnitRemoveAbility(c, InoriE_Regen3_ID)
                            call UnitRemoveAbility(c, InoriE_Regen4_ID)
                            call UnitRemoveAbility(c, InoriE_Atk_ID)
                            if LoadInteger(hs, GetHandleId(c), StringHash("mode t")) == 0 then
                                call SetPlayerAbilityAvailable(Player(k2), InoriQ_ID, true)
                                call SetPlayerAbilityAvailable(Player(k2), InoriW_ID, true)
                                call SetPlayerAbilityAvailable(Player(k2), InoriR_ID, true)
                            endif
                            call SaveInteger(hs, GetHandleId(c), StringHash("e activated"), 0)
                            call SaveInteger(hs, GetHandleId(c), StringHash("e activated2"), 0)
                            call SaveInteger(hs, GetHandleId(c), StringHash("pas cd"), 1)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), InoriE_ID, true)
                            call FakeCD_Start(c, InoriE_ID, InoriE_CDBase - (InoriE_CDReduce * GetUnitAbilityLevel(c, InoriE_ID) - 1), StringHash("pas cd"), 0)
                            call SaveInteger(hs, GetHandleId(c), StringHash("Inori E"), 0)
                            call SaveInteger(hs, GetHandleId(c), StringHash("Inori E Active"), 0)
                            if GetLocalPlayer() == GetOwningPlayer(c) then
                                call BlzFrameSetVisible(frame_pas1[k2], false)
                            endif
                            call DestroyEffect(e2)
                            call DestroyEffect(e3)
                            set e2 = null
                            set e3 = null
                        endif
                    endif
                else
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame_pas1[k2], false)
                    endif
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call DestroyEffect(e3)
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set m_InoriE[i] = m_InoriE[ MUI_InoriE]
                    set MUI_InoriE = MUI_InoriE - 1
                    if MUI_InoriE == -1 then
                        call PauseTimer( t_InoriE)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method InoriE_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_InoriE = MUI_InoriE + 1
            set m_InoriE[ MUI_InoriE] = this
            set c = NewC
            call SaveInteger(hs, GetHandleId(c), StringHash("Inori E"), 0)
            set check = 1
            set check2 = GetUnitTypeId(c)
            set k3 = 0
            set k4 = 0
            set check3 = -1
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set r = 0
            set e = AddSpecialEffectTarget("war3mapImported\\wos_Inori_Bar.mdl", c, "origin")
            if MUI_InoriE == 0 then
                call TimerStart( t_InoriE, 0.1, true, function thistype.Loop_InoriE)
            endif
        endmethod
    endstruct

    private struct InoriR_KS
        private static timer t_InoriR = CreateTimer( )
        private static integer array m_InoriR
        private static integer MUI_InoriR = -1
        unit c
        real x
        real y
        real r2
        integer k
        real scale
        real r3
        real r5
        real r6
        group g
        unit u
        real dmg
        integer check
        integer check2
        real aoe
        real move
        boolean b
        real r
        effect e
        effect e2
        effect e3
        effect e4
        effect e5
        effect e6
        effect e7
        effect e8
        effect e9
        real a
        real rmax
        private static method Loop_InoriR takes nothing returns nothing
            local integer this
            local integer i = 0
            local real hh
            loop
                exitwhen i > MUI_InoriR
                set this = m_InoriR[i]
                if check == 1 then
                    set b = r < rmax and SpellBoolCaster(c)
                else
                   // if check2 == 0 then 
                   // set b = GetUnitCurrentOrder(c) == OrderId("AImove")
                   // else
                    set b = r < rmax and SpellBoolCaster(c)
                   // endif
                endif
                if b then
                    set r = RoundReal(r + 0.03, 3)
                    if check == 0 then
                        call BlzSetSpecialEffectPosition(e5, GetUnitX(c), GetUnitY(c), GetUnitFlyHeight(c))
                        if r == InoriR_AntiDebuffStartTime and check2 == 0 then
                            set e8 = EffectSpawn("war3mapImported\\wos_Void04.mdl", x + 155 * Cos(0), y + 155 * Sin(0), 1, 1, 7.25*scale, 1)
                        endif
                        if r3 > 0.21 then
                            set r3 = 0
                            call OkarunEggCd(c, InoriR_ID, BlzGetAbilityCooldown(InoriR_ID, GetUnitAbilityLevel(c, InoriR_ID) - 1))
                        else
                            set r3 = r3 + 0.03
                        endif
                        if check2 == 0 then 
                        if r>rmax  and GetHeroLevel(c)>=35 then 
                        set r = 99999
                        set rmax = 12
                        set check2 = 1     
                      //  call IssueImmediateOrder(c,"stop")
                      //  call MyFrame(c,rmax,"BTNHero_Inori_R",false,0)
                        endif
                        else
                        
                        endif
                        if SR5(e2,GetUnitX(c),GetUnitY(c))>aoe then 
                        set r = 99999
                        endif
                      //  call BlzSetSpecialEffectPosition(e, GetUnitX(c), GetUnitY(c), GetUnitFlyHeight(c))
                      //  call BlzSetSpecialEffectPosition(e2, GetUnitX(c), GetUnitY(c), 13)
                      //  call BlzSetSpecialEffectPosition(e3, GetUnitX(c), GetUnitY(c), 55)
                      //  call BlzSetSpecialEffectPosition(e4, GetUnitX(c), GetUnitY(c), 145)
                      //  call BlzSetSpecialEffectPosition(e5, GetUnitX(c), GetUnitY(c), 1)
                       // call BlzSetSpecialEffectPosition(e6, GetUnitX(c), GetUnitY(c), 1)
                      //  call BlzSetSpecialEffectPosition(e7, GetUnitX(c), GetUnitY(c), 1)
                      //  call BlzSetSpecialEffectPosition(e8, GetUnitX(c), GetUnitY(c), 1)
                      //  call BlzSetSpecialEffectPosition(e9, GetUnitX(c), GetUnitY(c), 1)
                      if    LoadInteger(hs,GetHandleId(c),StringHash("inori r clear"))== 1  then 
                       call GroupEnumUnitsInRange(g, x, y, aoe, null)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitAlly(u, GetOwningPlayer(c)) then
                                call DebuffClear(u)
                                    call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_FantasyBattle (1644).mdx", u, "chest"))
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            call SaveInteger(hs,GetHandleId(c),StringHash("inori r clear"),0)
                      endif
                        if r2 > 0.94 then
                            set r2 = 0
                            set hh = dmg
                            if check2 == 1 then 
                            set hh = dmg * 0.5
                            set x = GetUnitX(c)
                            set y = GetUnitY(c)
                            endif
                            call VisionTimed(GetOwningPlayer(c), x, y, aoe + 300, 1.25)
                            call GroupEnumUnitsInRange(g, x, y, aoe, null)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitAlly(u, GetOwningPlayer(c)) then
                                if GetUnitState(u,UNIT_STATE_LIFE)>=GetUnitState(u,UNIT_STATE_MAX_LIFE)*0.5 then 
                                    call SetHpCurrent2(c,u, hh*0.5)
                                    else                                    
                                    call SetHpCurrent2(c,u, hh)
                                    endif
                                    endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        else
                            set r2 = r2 + 0.03
                        endif
                    elseif check == 1 then
                        if r == 0.45 then
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.1, 1, 255, 255, 255, 115))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c) - 70 * Cos(a), GetUnitY(c) - 70 * Sin(a), a * bj_RADTODEG , 2, 2.725, 1, 255, 255, 255, 155))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c) - 70 * Cos(a + 0.25 * bj_DEGTORAD), GetUnitY(c) - 70 * Sin(a + 0.25 * bj_DEGTORAD), a * bj_RADTODEG + 55 , 2, 2.725, 1, 255, 255, 255, 155))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c) - 70 * Cos(a - 0.25 * bj_DEGTORAD), GetUnitY(c) - 70 * Sin(a - 0.25 * bj_DEGTORAD), a * bj_RADTODEG - 55 , 2, 2.725, 1, 255, 255, 255, 155))
                        endif
                        if r > 0.45 then
                            if SR3(c, x, y) > 100 and r < rmax - 0.3 then
                                set a = GAngle2(c, x, y)
                                call MoveUnit(c, move, a)
                                call ColorEffDummy3(EffectSpawn3("war3mapImported\\wos_jiejin.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 2, GetRandomReal(0.25, 0.5), 1, -45), 0.7, 255, 255, 255, 0.45)
                            else
                                set r = 999
                                set x = GetUnitX(c) + 80 * Cos(a)
                                set y = GetUnitY(c) + 80 * Sin(a)
                                call DecorRemove(c, x, y, aoe, 40)
                                call MakeSound("war3mapImported\\Hero_Inori_EQ")
                                call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_ana-animeslashfinal_black_zi_q2.mdl", x - 300 * Cos(a), y - 300 * Sin(a), a * bj_RADTODEG, 0.8, 4, 165), 0.6, 255, 255, 255, 0.06)
                                set k = 0
                                set r5 = 250
                                set r6 = -60 * bj_DEGTORAD
                                set x = GetUnitX(c) - 180 * Cos(a)
                                set y = GetUnitY(c) - 180 * Sin(a)
                                loop
                                    exitwhen k == 6
                                    call ColorEffDummy3(EffectSpawn3("war3mapImported\\Wos_InoriCrystall.mdl", x + (r5 + 80) * Cos(a + r6), y + (r5 + 80) * Sin(a + r6), (a + r6) * bj_RADTODEG + 180, 1, 2, 1, -45), 0.3, 255, 255, 255, 0.9)
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_FSAeff (147).mdl", x + r5 * Cos(a + r6), y + r5 * Sin(a + r6), (a + r6) * bj_RADTODEG, 1.5, 0.6, 1))
                                    call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_1bing_6inori.mdl", x + r5 * Cos(a + r6), y + r5 * Sin(a + r6), (a + r6) * bj_RADTODEG, 0.5, 1.4, 1), 0.3, 255, 255, 255, 0.9)
                                    call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_1bing_6inori.mdl", x + (r5 + 150) * Cos(a + r6), y + (r5 + 150) * Sin(a + r6), (a + r6) * bj_RADTODEG, 0.5, 2.15, 1), 0.3, 255, 255, 255, 0.9)
                                    set k = k + 1
                                    set r6 = r6 + 30 * bj_DEGTORAD
                                endloop
                                call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                        call dmgmag(c, u, dmg)
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                            endif
                        endif
                    endif
                else
                    call DestroyEffect(e)
                    if check == 0 then
                        call BlzStartUnitAbilityCooldown(c, InoriR_ID, BlzGetAbilityCooldown(InoriR_ID, GetUnitAbilityLevel(c, InoriR_ID) - 1))
                        call StopSound(gg_snd_Hero_Inori_R, false, false)
                        call DestroyEffect(e6)
                        call DestroyEffect(e7)
                        call DestroyEffect(e9)
                        call ColorEffDummy3(e2, 0, 255, 255, 255, 0.6)
                        call ColorEffDummy3(e3, 0, 255, 255, 255, 0.6)
                        call ColorEffDummy3(e4, 0, 255, 255, 255, 0.6)
                        call ColorEffDummy3(e5, 0, 255, 255, 255, 0.6)
                        if r >= InoriR_AntiDebuffStartTime or check2 == 1 then
                            call DestroyEffect(e8)
                        endif
                    else
                        call StopSpellUnit(c)
                    endif
                    call DestroyGroup(g)
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set e5 = null
                    set e6 = null
                    set e7 = null
                    set e8 = null
                    set e9 = null
                    set g = null
                    set u = null
                    set m_InoriR[i] = m_InoriR[ MUI_InoriR]
                    set MUI_InoriR = MUI_InoriR - 1
                    if MUI_InoriR == -1 then
                        call PauseTimer( t_InoriR)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method InoriR_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_InoriR = MUI_InoriR + 1
            set m_InoriR[ MUI_InoriR] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set u = null
            set r2 = 0
            set g = CreateGroup()
            set check2 = 0
            set check = 0
            set a = GAngle2(c, x, y) // Angle Between points
            if LoadInteger(hs, GetHandleId(c), StringHash("Inori E Active")) == 1 then
                set rmax = 1.2
                set check = 1
                set move = 90
                call StartSpellUnit(c)
                set aoe = InoriER_DamageAoe
                set dmg = GetHeroInt( c , true) * ( InoriER_DamageIntBase + ( InoriER_DamageIntStep * ( GetUnitAbilityLevel( c , InoriR_ID) - 1 ) ) )
                call SetUnitTimeScale(c, 0.425)
                call SetUnitAnimationByIndex(c, 15)
                call MakeSound("war3mapImported\\Hero_Inori_ER2")
                set e = AddSpecialEffectTarget("war3mapImported\\wos_Void04.mdl", c, "origin")
            else
                set x = GetUnitX(c)
            set y = GetUnitY(c)
            set a = GetUnitFacing(c)*bj_DEGTORAD
                set dmg = GetHeroInt( c , true) * ( InoriR_HealIntBase + ( InoriR_HealIntStep * ( GetUnitAbilityLevel( c , InoriR_ID) - 1 ) ) )
                set dmg = dmg + ( InoriR_HealStaticBase + ( InoriR_HealStaticStep * ( GetUnitAbilityLevel( c , InoriR_ID) - 1 ) ) )
                set aoe = InoriR_HealAoe
                if GetHeroLevel(c)>= 35 then 
                set aoe = aoe + InoriR_HealAoeAdd
                endif
                set scale = aoe/1250
                set rmax = 9.61
                if GetHeroLevel(c)>= 35 then 
                set rmax = rmax + 12
                endif
                call SetUnitFacing(c, a * bj_RADTODEG)
                call SetUnitTimeScale(c, 1.25)
                call StartSound(gg_snd_Hero_Inori_R)
                call SetUnitTimeScale(c, 2.25)
                call SetUnitAnimationByIndex(c, 7)
                set e = AddSpecialEffectTarget("war3mapImported\\wos_Void04.mdl", c, "origin")
                set e2 = EffectSpawnScale("war3mapImported\\wos_inori_r.mdl", x, y, 1, 1, 1*scale, 1, 1, 1, 13*scale)
                set e3 = EffectSpawnColor("war3mapImported\\wos_Hero_FarSeer2.mdl", x, y, 1, 0.2, 1*scale, 1, 255, 255, 255, 55)
                set e4 = EffectSpawnColor("war3mapImported\\wos_BD_YEQI1.mdl", x, y, 1, 0.2, 1*scale, 800, 255, 255, 255, 145)
                set e9 = EffectSpawn("war3mapImported\\wos_LightBlueLand.mdl", x, y, 1, 1, 2*scale, 1)
                set e5 = EffectSpawn("war3mapImported\\wos_BD_YEQI03.mdl", GetUnitX(c), GetUnitY(c), 1, 1, 3*scale, 1)
                set e6 = AddSpecialEffectTarget("war3mapImported\\wos_zdgq.mdl", c, "origin")
                set e7 = AddSpecialEffectTarget("war3mapImported\\wos_qicai-lizi-shangsheng2.mdl", c, "origin")
                call BlzSetSpecialEffectAlpha(e2, 0)
                call BlzSetSpecialEffectAlpha(e3, 0)
                call ColorEffDummy4(e2, 0, 255, 255, 255, 1.5)
                call ColorEffDummy4(e3, 0, 255, 255, 255, 1.5)
            endif
            set r5 = 1.5
            if MUI_InoriR == 0 then
                call TimerStart( t_InoriR, 0.03, true, function thistype.Loop_InoriR)
            endif
        endmethod
    endstruct

    private struct InoriR2_KS
        private static timer t_InoriR2 = CreateTimer( )
        private static integer array m_InoriR2
        private static integer MUI_InoriR2 = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        group g
        group g2
        unit u
        real dmg
        real aoe
        real move
        real r
        real a
        real rmax
        private static method Loop_InoriR2 takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr1 = 0
            local real rr2 = 0
            local real rr3 = 0
            local real rr4 = 0
            loop
                exitwhen i > MUI_InoriR2
                set this = m_InoriR2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r == 0.45 then
                        call MakeSound("war3mapImported\\Hero_Inori_TR2")
                        call MyRemoveEff(EffectSpawnScale("war3mapImported\\wos_pinkfloor1.mdl", GetUnitX(c), GetUnitY(c), 1, 1, 1.5, 1, 0.8, 1.5, 2.75), 1.75)
                        call MyRemoveEff(EffectSpawnScale("war3mapImported\\wos_GameBABY_qilongzhu_004.mdl", GetUnitX(c), GetUnitY(c), 0, 1.1, 1, 1, 0.8, 1, 2.45), 1.75)
                    endif
                    if r == 0.51 or r == 0.75 or r == 0.87 or r == 0.99 or r == rmax - 0.3 or r == rmax - 0.18 or r == rmax - 0.09 or r == rmax then
                        set k = 0
                        if r == 0.51 or r == rmax - 0.3 then
                            set rr1 = 250
                            set rr2 = 1.5
                            set rr3 = 1.25
                            if r == rmax - 0.3 then
                                call MakeSound("war3mapImported\\Hero_Inori_TR2")
                                if r< 1.2 then 
                                call DestroyEffect(EffectSpawnScale("war3mapImported\\wos_pinkfloor1.mdl", x, y, 1, 4, 1.5, 1, 0.8, 0.5, 2.45))
                                endif
                                call MyRemoveEff(EffectSpawnScale("war3mapImported\\wos_GameBABY_qilongzhu_004.mdl", x, y, 0, 1.1, 1.1, 1, 0.8, 1, 2.65), 1.15)
                            endif
                        elseif r == 0.51 or r == rmax - 0.18 then
                            set rr1 = 400
                            set rr2 = 1.85
                            set rr3 = 1.25
                        elseif r == 0.87 or r == rmax - 0.09 then
                            set rr1 = 500
                            set rr2 = 2.15
                            set rr3 = 1.25
                        elseif r == 0.99 or r == rmax then
                            set rr1 = 600
                            set rr2 = 2.45
                            set rr3 = 1.25
                        endif
                        if r > 1. then
                            set rr2 = rr2 + 0.09
                        endif
                        set aoe = aoe + InoriR2_DamageAoeAdd
                        loop
                            exitwhen k == 8
                            call MyRemoveEff(EffectSpawn3("war3mapImported\\Wos_InoriCrystall.mdl", x + rr1 * Cos(k * 45 * bj_DEGTORAD), y + rr1 * Sin(k * 45 * bj_DEGTORAD), k * 45 + 180, 1, rr2, 1, -45), rr3)
                            set k = k + 1
                        endloop
                        call GroupClear(g)
                        call DecorRemove(c, x, y, aoe, 100)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                if IsUnitInGroup(u, g2) == false then
                                    call GroupAddUnit(g2, u)
                                    if r < 1.5 then
                                        call dmgmag(c, u, dmg * 0.25)
                                    else
                                        call dmgmag(c, u, dmg)
                                    endif
                                endif
                                call MUE(u, aoe - SR3(u, x, y) , 0.3, GAngle3(x, y, u))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                    if r == 1.02 then
                        call GroupClear(g2)
                        set x = GetUnitX(c) + 200 * Cos(a)
                        set y = GetUnitY(c) + 200 * Sin(a)
                        call SetUnitTimeScale(c, 0)
                        set move = 80
                        call MakeSound("war3mapImported\\Hero_Inori_EQ")
                        set aoe = InoriR2_DamageAoe
                        call MouseOn(GetOwningPlayer(c))
                        call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("raiden tt r"), 1)
                    endif
                    if r > 1. and r < rmax - 0.3 then
                        set x1 = GetMouseX(GetOwningPlayer(c))
                        set y1 = GetMouseY(GetOwningPlayer(c))
                        set a = GAngle4(x, y, x1, y1)
                        set x = x + move * Cos(a)
                        set y = y + move * Sin(a)
                        if SR3(c, x, y) > InoriR2_MaxRange then
                            set a = GAngle2(c, x, y)
                            set x = GetUnitX(c) + (InoriR2_MaxRange - 5) * Cos(a)
                            set y = GetUnitY(c) + (InoriR2_MaxRange - 5) * Sin(a)
                        endif
                        if r2 > 0.09 then
                            set r2 = 0
                            call VisionTimed(GetOwningPlayer(c), x, y, 1000, 1.25)
                            call DecorRemove(c, x, y, aoe, 100)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u, g2) == false then
                                    call GroupAddUnit(g2, u)
                                    call dmgmag(c, u, dmg)
                                    call RootUnit(c, u, 2)
                                    call MUE(u, SR3(u, x, y), 0.15, GAngle2(u, x, y))
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set k = 0
                            set rr1 = GetRandomReal(100, 250)
                            set rr2 = 1.95
                            set rr3 = 1.25
                            set rr4 = GetRandomReal(0, 359) * bj_DEGTORAD
                            loop
                                exitwhen k == 4
                                call MyRemoveEff(EffectSpawn3("war3mapImported\\Wos_InoriCrystall.mdl", x + rr1 * Cos(k * 90 * bj_DEGTORAD + rr4), y + rr1 * Sin(k * 90 * bj_DEGTORAD + rr4), k * 45 + 180, 1, rr2, 1, -45), rr3)
                                set k = k + 1
                            endloop
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("raiden tt r"), 0)
                    call MouseOff(GetOwningPlayer(c))
                    call StopSpellUnit(c)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set c = null
                    set g = null
                    set g2 = null
                    set u = null
                    set m_InoriR2[i] = m_InoriR2[ MUI_InoriR2]
                    set MUI_InoriR2 = MUI_InoriR2 - 1
                    if MUI_InoriR2 == -1 then
                        call PauseTimer( t_InoriR2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method InoriR2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_InoriR2 = MUI_InoriR2 + 1
            set m_InoriR2[ MUI_InoriR2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set u = null
            set r2 = 0
            set MouseX[GetPlayerId(GetOwningPlayer(c))] = x
            set MouseY[GetPlayerId(GetOwningPlayer(c))] = y
            call StartSpellUnit(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set a = GAngle2(c, x, y) // Angle Between points
            set dmg = GetHeroInt( c , true) * ( InoriR2_DamageIntBase + ( InoriR2_DamageIntStep * ( GetUnitAbilityLevel( c , InoriR2_ID) - 1 ) ) )
            set aoe = InoriR2_DamageAoe
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SetUnitTimeScale(c, 2.25)
            call SetUnitAnimationByIndex(c, 4)
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapImported\\Hero_Inori_TR")
            else
                call MakeSound("war3mapImported\\Hero_Inori_TR3")
            endif
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set rmax = 2.22
            if MUI_InoriR2 == 0 then
                call TimerStart( t_InoriR2, 0.03, true, function thistype.Loop_InoriR2)
            endif
        endmethod
    endstruct

    private struct InoriT_KS
        private static timer t_InoriT = CreateTimer( )
        private static integer array m_InoriT
        private static integer MUI_InoriT = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        real r3
        real r4
        destructable ds
        group g
        unit u
        real dmg
        integer check2
        real aoe
        real r
        effect e
        real rmax
        private static method Loop_InoriT takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr1 = 0
            local real rr2 = 0
            local real rr3 = 0
            local real rr4 = 0
            local real rr5 = 0
            local real rr6 = 0
            loop
                exitwhen i > MUI_InoriT
                set this = m_InoriT[i]
                if SpellBoolCaster(c) and r <= rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false then
                    set r = RoundReal(r + 0.03, 3)
                    if r< 3 then 
                    call DebugUnit(c)
                    endif
                    
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    call BlzSetSpecialEffectPosition(e,x,y,3)
                    set r = RoundReal(r, 3)
                    if r == 0.66 then
                        call MakeSound("war3mapImported\\Hero_Inori_TW2")
                    endif
                    if r == 1.5 or r == 1.98 or r == 2.49 or r == 3 or r == 3.48 or r == 4.02 or r == 4.5 or r == 5.01 or r == 5.52 or r == 6  or r == 6.51 then
                    if aoe < InoriT_DamageMaxAoe then 
                    set aoe = aoe + InoriT_DamageAoeAdd
                    endif
                   // call BJDebugMsg(R2S(aoe))
                    endif
                    if r == 6 then
                        call MakeSound("war3mapImported\\Hero_Inori_T1 3")
                    endif
                    if r4 > 0.45 then
                        set r4 = 0
                        call EUTU2_3(EffectSpawn("war3mapImported\\wos_FSAeff (147).mdl", GetUnitX(c), GetUnitY(c), 0, 1.1, 0.4, 1),1,1,c)
                    else
                        set r4 = r4 + 0.03
                    endif
                    if r == 3 then
                        set check2 = 1
                        call StopSpellUnit(c)
                    endif
                    if r == 1.5 then
                        call MakeSound("war3mapImported\\Hero_Inori_T1 2")
                    endif
                    if r > 1.5 then
                        if r3 > 0.03 then
                            set r3 = 0
                            set rr1 = GetRandomReal(InoriT_CrystalMinRange, InoriT_CrystalMaxRange)
                            set rr2 = GetRandomReal(0, 359) * bj_DEGTORAD
                            set rr3 = GetRandomReal(0, 359)
                            set rr4 = GetRandomReal(0.7, 1)
                            set rr5 = GetRandomReal(0.5, 0.85)
                            set rr6 = GetRandomReal(40, 100)
                            set x1 = GetUnitX(c) + rr1 * Cos(rr2)
                            set y1 = GetUnitY(c) + rr1 * Sin(rr2)
                            set ds = CreateDestructable(InoriT_Crystal1_ID, x1, y1, rr3, rr4, 0)
                            call SetDestructableAnimation(ds, "birth")
                            call SetDestructableAnimationSpeed(ds, rr5)
                            call MyAnimDest(ds, InoriT_CrystallLifeTime - 1.1)
                            call MyRemoveDest(ds, InoriT_CrystallLifeTime)
                        else
                            set r3 = r3 + 0.03
                        endif
                    endif
                    if r2 > 0.9 and r > 1.5 then
                        set r2 = 0
                        call EUTU2_3(EffectSpawnScale("war3mapImported\\wos_shockwave.mdl", .x, .y, GetRandomReal(0, 359), 1, 1, 100, 0.6, 1, 6),1.5,100,c)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                call dmgmag(c, u, dmg)
                                if IsUnitType(u, UNIT_TYPE_HERO) then
                                    call BuffUnitInori2(c, u, 1)
                                    if check2 == 1 then
                                        call RootUnit(c, u, InoriT_RootTime)
                                        set ds = CreateDestructable(InoriT_Crystal2_ID, GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359), 2, 0)
                                        call SetDestructableAnimation(ds, "birth")
                                        call SetDestructableAnimationSpeed(ds, 0.8)
                                        call MyAnimDest(ds, InoriT_RootTime - 0.4)
                                        call MyRemoveDest(ds, InoriT_RootTime)
                                    endif
                                    set rr1 = GetRandomReal(150, 350)
                                    set rr2 = GetRandomReal(0, 359) * bj_DEGTORAD
                                    set rr3 = GetRandomReal(0, 359)
                                    set rr4 = GetRandomReal(0.7, 1.)
                                    set rr5 = GetRandomReal(0.5, 0.85)
                                    set rr6 = GetRandomReal(40, 100)
                                    set x1 = GetUnitX(u) + rr1 * Cos(rr2)
                                    set y1 = GetUnitY(u) + rr1 * Sin(rr2)
                                    set ds = CreateDestructable(InoriT_Crystal1_ID, x1, y1, rr3, rr4, 0)
                                    call SetDestructableAnimation(ds, "birth")
                                    call SetDestructableAnimationSpeed(ds, rr5)
                                    call MyAnimDest(ds, InoriT_CrystallLifeTime - 1.1 - r)
                                    call MyRemoveDest(ds, InoriT_CrystallLifeTime - r)
                                endif
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                        set check2 = 0
                    else
                        set r2 = r2 + 0.03
                    endif
                else
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.45)
                    call SetUnitVertexColor(c, 255, 255, 255, 255)
                    if r< 3 then 
                    call StopSpellUnit(c)
                    endif
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set e = null
                    set ds = null
                    set u = null
                    set m_InoriT[i] = m_InoriT[ MUI_InoriT]
                    set MUI_InoriT = MUI_InoriT - 1
                    if MUI_InoriT == -1 then
                        call PauseTimer( t_InoriT)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method InoriT_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_InoriT = MUI_InoriT + 1
            set m_InoriT[ MUI_InoriT] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set g = CreateGroup()
            set u = null
            set check2 = 0
            set r2 = 0
            call DecorRemoveInori(c,x,y,10000)
            call VisionTimed(GetOwningPlayer(c), x, y, 2500, 11)
            set dmg = GetHeroInt( c , true) * InoriT_DamageIntBase
            set dmg = dmg / 9
            set aoe = InoriT_DamageAoe
            set rmax = 10
            call StartSpellUnit(c)
            call MakeSound("war3mapImported\\Hero_Inori_T1 1")
            call SetUnitAnimationByIndex( c , 8)
            call SetUnitTimeScale(c, 0.75)
            set e = EffectSpawn("war3mapimported\\wos_hakkestart.mdl", x, y, 1, 1, 0.95, 3)
            call AnimDummyEff(e, 0.25, 0)
            if MUI_InoriT == 0 then
                call TimerStart( t_InoriT, 0.03, true, function thistype.Loop_InoriT)
            endif
        endmethod
    endstruct

    private struct InoriT2_KS
        private static timer t_InoriT2 = CreateTimer( )
        private static integer array m_InoriT2
        private static integer MUI_InoriT2 = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        integer k2
        destructable ds
        group g
        unit u
        real dmg
        integer check
        integer check2
        real aoe
        real r
        effect e
        effect e2
        real rmax
        framehandle array frame2_pas1 [10]
        framehandle array frame2_pas2 [10]
        framehandle array frame2_pas3 [10]
        framehandle array frame2_pas4 [10]
        framehandle array frame2_pas5 [10]
        framehandle array frame2_pas6 [10]
        private static method Loop_InoriT2 takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr1 = 0
            local real rr2 = 0
            local real rr3 = 0
            local real rr4 = 0
            local real rr5 = 0
            local real rr6 = 0
            loop
                exitwhen i > MUI_InoriT2
                set this = m_InoriT2[i]
                if SpellBoolCaster(c) and r <= rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false then
                    if check2 == 1 then
                        if r2 > 0.45 then
                            set r2 = 0
                            set rr1 = GetRandomReal(InoriT_CrystalMinRange, InoriT_CrystalMaxRange)
                            set rr2 = GetRandomReal(0, 359) * bj_DEGTORAD
                            set x1 = GetUnitX(c) + rr1 * Cos(rr2)
                            set y1 = GetUnitY(c) + rr1 * Sin(rr2)
                            call DestroyEffect(EffectSpawnScale("war3mapImported\\wos_[sepll]linasun _t2_blast.mdl", .x1, .y1, GetRandomReal(0, 359), 1, 1, 100, 0.6, 1, 2))
                            set k = 0
                            loop
                                exitwhen k == 3
                                set rr1 = GetRandomReal(50, 350)
                                set rr2 = GetRandomReal(0, 359) * bj_DEGTORAD
                                set rr3 = GetRandomReal(0, 359)
                                set rr4 = GetRandomReal(0.7, 1)
                                set rr5 = GetRandomReal(0.25, 0.5)
                                set rr6 = GetRandomReal(40, 100)
                                set ds = CreateDestructable(InoriT_Crystal1_ID, x1 + rr1 * Cos(rr2), y1 + rr1 * Sin(rr2), rr3, rr4, 0)
                                call SetDestructableAnimation(ds, "birth")
                                call SetDestructableAnimationSpeed(ds, rr5)
                                call MyAnimDest(ds, InoriT_CrystallLifeTime - 1.1)
                                call MyRemoveDest(ds, InoriT_CrystallLifeTime)
                                set k = k + 1
                            endloop
                            set k = 0
                            call GroupEnumUnitsInRange(g, x1, y1, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    //call RootUnit(c, u, InoriT_RootTime)
                                    call dmgmag(c, u, dmg)
                                    set ds = CreateDestructable(InoriT_Crystal2_ID, GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359), 2, 0)
                                    call SetDestructableAnimation(ds, "birth")
                                    call SetDestructableAnimationSpeed(ds, 0.8)
                                    call MyAnimDest(ds, InoriT_RootTime - 0.4)
                                    call MyRemoveDest(ds, InoriT_RootTime)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                    if check == 0 then
                        call DebugUnit(c)
                        set r = RoundReal(r + 0.03, 3)
                        set r = S2R( R2SW( r , 0, 3 ) )
                       
                        if r == 1.32 then
                            call UnitRemoveAbility(c, InoriEE_ID)
                            call SetPlayerAbilityAvailable(Player(k2), InoriQ3_ID, true)
                            call SetPlayerAbilityAvailable(Player(k2), InoriW3_ID, true)
                            call SetPlayerAbilityAvailable(Player(k2), InoriE2_ID, true)
                            call SetPlayerAbilityAvailable(Player(k2), InoriR2_ID, true)
                            call SetPlayerAbilityAvailable(Player(k2), InoriT3_ID, true)
                            call UnitAddAbility(c, InoriQ3_ID)
                            call UnitAddAbility(c, InoriW3_ID)
                            call UnitAddAbility(c, InoriE2_ID)
                            call UnitAddAbility(c, InoriR2_ID)
                            call UnitAddAbility(c, InoriT3_ID)
                            call SetUnitAbilityLevel(c, InoriQ3_ID, GetUnitAbilityLevel(c, InoriQ_ID))
                            call SetUnitAbilityLevel(c, InoriW3_ID, GetUnitAbilityLevel(c, InoriW_ID))
                            call SetUnitAbilityLevel(c, InoriE2_ID, GetUnitAbilityLevel(c, InoriE_ID))
                            call SetUnitAbilityLevel(c, InoriR2_ID, GetUnitAbilityLevel(c, InoriR_ID))
                            call SetPlayerAbilityAvailable(Player(k2), InoriQ_ID, false)
                            call SetPlayerAbilityAvailable(Player(k2), InoriQ2_ID, false)
                            call SetPlayerAbilityAvailable(Player(k2), InoriW_ID, false)
                            call SetPlayerAbilityAvailable(Player(k2), InoriW2_ID, false)
                            call SetPlayerAbilityAvailable(Player(k2), InoriE_ID, false)
                            call SetPlayerAbilityAvailable(Player(k2), InoriR_ID, false)
                            call SetPlayerAbilityAvailable(Player(k2), InoriT2_ID, false)
                            call SetPlayerAbilityAvailable(Player(k2), FakeAbi_ID, false)
                            call DecorRemove(c, x, y, 800, 50)
                            call VisionTimed(GetOwningPlayer(c), x , y, 1500, 2)
                            call BlzSetUnitSkin(c, Inori2_ID)
                            call FixAura(c)
                            call ScaleEffDummy(e, 0.5, 3, 6)
                            call ScaleEffDummy(e2, 0.5, 1, 2.5)
                            call ColorEffDummy3(e, 0, 255, 255, 255, 0.6)
                            call ColorEffDummy3(e2, 0, 255, 255, 255, 0.35)
                            call ColorDummy4(c, 0, 255, 255, 255, 1.2)
                            if frame2_pas1[k2] == null then
                                set frame2_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18)
                                call BlzFrameSetSize(frame2_pas1[k2], 0.135, 0.035)
                                call BlzFrameSetTexture(frame2_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                                call BlzFrameSetVisible(frame2_pas1[k2], false)
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame2_pas1[k2], true)
                                endif
                                set frame2_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame2_pas1[k2], 0, 0)
                                call BlzFrameSetAbsPoint(frame2_pas2[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                                call BlzFrameSetSize(frame2_pas2[k2], 0.1, 0.019)
                                set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)
                                call BlzFrameSetSize(frame2_pas3[k2], 0.1, 0.035)
                                call BlzFrameSetScale(frame2_pas3[k2], 0.5)
                                call BlzFrameSetModel(frame2_pas3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                                call BlzFrameSetAbsPoint(frame2_pas3[k2], FRAMEPOINT_CENTER, 0.05, 0.175)
                                call BlzFrameSetMinMaxValue(frame2_pas3[k2], 0, rmax)
                                call BlzFrameSetValue(frame2_pas3[k2], rmax)
                                set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18)
                                call BlzFrameSetSize(frame2_pas4[k2], 0.03, 0.03)
                                call BlzFrameSetTexture(frame2_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Inori_TE", 0, false)
                                set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                                call BlzFrameSetText(frame2_pas5[k2], "|c00FFFF00" + "Morph Time Left:" + "|r")
                                call BlzFrameSetScale(frame2_pas5[k2], 0.9)
                                set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17)
                                call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(rmax, 0, 2) + "|r")
                                call BlzFrameSetScale(frame2_pas6[k2], 0.9)
                            else
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame2_pas1[k2], true)
                                endif
                                call BlzFrameSetValue(frame2_pas3[k2], rmax)
                            endif
                            call DestroyEffect(EffectSpawn3("war3mapImported\\wos_mei-qqsfx-5.mdl", GetUnitX(c), GetUnitY(c), 1, 0.85, 4, 1, -90))
                            call SetUnitAnimationByIndex(c, 7)
                            call SetUnitTimeScale(c, 0.9)
                        endif
                        if r == 1.44 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_FSAeff (147).mdl", GetUnitX(c), GetUnitY(c), 0, 0.4, 0.6, 1))
                        endif
                        if r == 1.86 then
                            set check2 = 1
                            set e = AddSpecialEffectTarget("war3mapImported\\wos_file00002900.mdl", c, "origin")
                            call SetUnitAnimationByIndex(c, 9)
                        endif
                        if r == 2.43 or r == 4.35 then
                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_FSAeff (203).mdl", c, "origin"))
                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_FSAeff (200).mdl", c, "origin"))
                        endif
                        if r == 3 then
                            set r = 0
                            set check = 1
                            call StopSpellUnit(c)
                        endif
                    elseif check == 1 then
                        if IsUnitPaused(c) == false then
                            set r = RoundReal(r + 0.03, 3)
                        endif
                        if LoadInteger(hs, GetHandleId(c), StringHash("cancel t")) == 1 then
                            set r = 99999
                        endif
                        set r = S2R( R2SW( r , 0, 3 ) )
                        call BlzFrameSetValue(frame2_pas3[k2], rmax - (r + 0.1))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                    endif
                else
                    call DestroyEffect(EffectSpawn3("war3mapImported\\wos_mei-qqsfx-5.mdl", GetUnitX(c), GetUnitY(c), 1, 1.25, 3, 50, -90))
                    call BlzSetUnitSkin(c, Inori_ID)
                    call FixAura(c)
                    call UnitRemoveAbility(c,InoriEE_ID)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), InoriE_ID, true)
                    call UnitRemoveAbility(c,FakeAbi_ID)
                    call SaveInteger(hs, GetHandleId(c), StringHash("cancel t"), 0)
                    call BlzSetAbilityIcon(Inori_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Inori_Icon.blp")
                    call SetPlayerAbilityAvailable(Player(k2), InoriQ_ID, true)
                    call SetPlayerAbilityAvailable(Player(k2), InoriW_ID, true)
                    call SetPlayerAbilityAvailable(Player(k2), InoriE_ID, true)
                    call SetPlayerAbilityAvailable(Player(k2), InoriR_ID, true)
                    call SetPlayerAbilityAvailable(Player(k2), InoriT2_ID, true)
                    call SetPlayerAbilityAvailable(Player(k2), InoriQ3_ID, false)
                    call SetPlayerAbilityAvailable(Player(k2), InoriW3_ID, false)
                    call SetPlayerAbilityAvailable(Player(k2), InoriE2_ID, false)
                    call SetPlayerAbilityAvailable(Player(k2), InoriR2_ID, false)
                    call SetPlayerAbilityAvailable(Player(k2), InoriT3_ID, false)
                    call SetPlayerAbilityAvailable(Player(k2), FakeAbi_ID, true)
                    call SetUnitVertexColor(c, 255, 255, 255, 255)
                    call ColorDummy4(c, 0, 255, 255, 255, 0.3)
                    call SaveInteger(hs, GetHandleId(c), StringHash("pas cd"), 0)
                    call SaveInteger(hs, GetHandleId(c), StringHash("mode t"), 0)
                    call EUTU2_3(e, 0.3, 0, c)
                    if check == 0 then
                        call StopSpellUnit2(c)
                        call DestroyEffect(e2)
                    endif
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame2_pas1[k2], false)
                    endif
                    call DestroyGroup(g)
                    set c = null
                    set e = null
                    set e2 = null
                    set g = null
                    set u = null
                    set m_InoriT2[i] = m_InoriT2[ MUI_InoriT2]
                    set MUI_InoriT2 = MUI_InoriT2 - 1
                    if MUI_InoriT2 == -1 then
                        call PauseTimer( t_InoriT2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method InoriT2_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_InoriT2 = MUI_InoriT2 + 1
            set m_InoriT2[ MUI_InoriT2] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            call StartSpellUnit(c)
            set check = 0
            set r = 0
            set aoe = InoriT2_DamageAoeBeam
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set r2 = 10
            set check2 = 0
            set rmax = InoriT2_Duration
            set dmg = InoriT2_DamageIntBase * GetHeroInt(c, true)
            set g = CreateGroup()
            call VisionTimed(GetOwningPlayer(c), x, y, 2400, 9)
            set u = null
            call MakeSound("war3mapimported\\Hero_Inori_T2 1")
            set e = EffectSpawnScale("war3mapImported\\wos_pinkfloor1.mdl", x, y, 1, 1, 1.5, 1, 0.8, 1.5, 2.75)
            call BlzSetSpecialEffectAlpha(e, 0)
            call ColorEffDummy4(e, 0., 255, 255, 255, 0.5)
            set e2 = EffectSpawnScale("war3mapImported\\wos_GameBABY_qilongzhu_004.mdl", x, y, 0, 1.1, 1, 1, 0.8, 1, 1.65)
            call BlzPlaySpecialEffect(e2, ANIM_TYPE_BIRTH)
            call SaveInteger(hs, GetHandleId(c), StringHash("mode t"), 1)
            call SetUnitAnimationByIndex(c, 8)
            call BlzSetAbilityIcon(Inori_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Inori_T2.blp")
            call ColorDummy32(c, 0.3, 255, 255, 255, 1.02)
            if MUI_InoriT2 == 0 then
                call TimerStart( t_InoriT2, 0.03, true, function thistype.Loop_InoriT2)
            endif
        endmethod
    endstruct

    private struct InoriF_KS
        private static timer t_InoriF = CreateTimer( )
        private static integer array m_InoriF
        private static integer MUI_InoriF = -1
        unit c
        real r
        effect e
        real rmax
        private static method Loop_InoriF takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_InoriF
                set this = m_InoriF[i]
                if SpellBoolCaster(c) and r <= rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false then
                    set r = r + 0.1
                    set r = S2R( R2SW( r , 0, 3 ) )
                else
                    call DestroyEffect(e)
                    call AddSpellLevel(c, 'A01C', 5, false)
                    call BlzSetAbilityIcon(InoriQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Inori_Q.blp")
                    call SaveInteger(hs, GetHandleId(c), StringHash("mode f"), 0)
                    set c = null
                    set e = null
                    set m_InoriF[i] = m_InoriF[ MUI_InoriF]
                    set MUI_InoriF = MUI_InoriF - 1
                    if MUI_InoriF == -1 then
                        call PauseTimer( t_InoriF)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method InoriF_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_InoriF = MUI_InoriF + 1
            set m_InoriF[ MUI_InoriF] = this
            set c = NewC
            set r = 0
            set rmax = 6
            call AddSpellLevel(c, 'A01C', 5, true)
            call MakeSound("war3mapimported\\Hero_Inori_F1")
            call ReduceCooldown(c, InoriQ_ID, 4)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_Effect AZ_Lina_F.mdl", c, "origin")
            call SaveInteger(hs, GetHandleId(c), StringHash("mode f"), 1)
            if true then //LoadInteger(hs, GetHandleId(c), StringHash("Inori E Active")) == 1 or LoadInteger(hs, GetHandleId(c), StringHash("mode t")) == 1 then
                call BlinkEff(c)
                call MUE(c, InoriF_PushRange, 0.3, GetUnitFacing(c) * bj_DEGTORAD)
            endif
            call BlzSetAbilityIcon(InoriQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Inori_Q2.blp")
            if MUI_InoriF == 0 then
                call TimerStart( t_InoriF, 0.1, true, function thistype.Loop_InoriF)
            endif
        endmethod
    endstruct

    
    //----------------------------Inori-----------------------------------------------
     /* Animations index:
    Base:
    0 - stand
    1 - move
    2 - stand ready
    3 - atk
    4 - hand to floor
    5 - fast fire
    6 - hand forward
    7 - song
    8 - death ( kolenki)
    9 - dance
        
     */ 
    
    function InoriQ_Start takes unit c, real x, real y returns nothing
        if GetHeroLevel(c)>=35 then
    call SaveInteger(hs,GetHandleId(c),StringHash("inori r clear"),1)
        endif
        call InoriQ_KS.InoriQ_Start( c, x, y )
    endfunction
    function InoriQ2_Start takes unit c, real x, real y returns nothing
        if GetHeroLevel(c)>=35 then
    call SaveInteger(hs,GetHandleId(c),StringHash("inori r clear"),1)
        endif
        call InoriQ_KS.InoriQ_Start( c, x, y )
    endfunction
    function InoriQ3_Start takes unit c, real x, real y returns nothing
        call InoriQ2_KS.InoriQ2_Start( c, x, y )
    endfunction
    function InoriW_Start takes unit c, unit td returns nothing
        call InoriW_KS.InoriW_Start( c, td )
        if GetHeroLevel(c)>=35 then
    call SaveInteger(hs,GetHandleId(c),StringHash("inori r clear"),1)
        endif
    endfunction
    function InoriW2_Start takes unit c, unit td returns nothing
        call InoriW_KS.InoriW_Start( c, td )
        if GetHeroLevel(c)>=35 then
    call SaveInteger(hs,GetHandleId(c),StringHash("inori r clear"),1)
        endif
    endfunction
    function InoriW3_Start takes unit c, real x, real y returns nothing
        call InoriW2_KS.InoriW2_Start( c, x, y )
    endfunction
    function InoriEPas_Start takes unit damagedUnit returns nothing
    local integer i = 0
    local integer stacks
    local integer hid
    local unit inori
    local player damagedOwner
    local real dx
    local real dy
    local real x
    local real y
    local real rangeSquared = InoriE_AoeSearch * InoriE_AoeSearch

    if damagedUnit == null then
        return
    endif

    set x = GetUnitX(damagedUnit)
    set y = GetUnitY(damagedUnit)
    set damagedOwner = GetOwningPlayer(damagedUnit)

    loop
        exitwhen i >= bj_MAX_PLAYERS
        set inori = Hero[i]

        if inori != null /*
        */ and GetUnitTypeId(inori) == Inori_ID /*
        */ and not IsUnitIllusion(inori) /*
        */ and GetHeroLevel(inori) >= 6 /*
        */ and IsUnitAlly(inori, damagedOwner) then
            set dx = GetUnitX(inori) - x
            set dy = GetUnitY(inori) - y

            if dx * dx + dy * dy <= rangeSquared then
                set hid = GetHandleId(inori)

                if LoadInteger(hs, hid, StringHash("pas cd")) == 0 then
                    set stacks = LoadInteger(hs, hid, StringHash("Inori E"))

                    if stacks < 4 then
                        call SaveInteger(hs, hid, StringHash("Inori E"), stacks + 1)
                        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_A_194-9F68D.mdl", inori, "origin"))
                    endif
                endif
            endif
        endif

        set i = i + 1
    endloop

    set inori = null
    set damagedOwner = null
endfunction
    function InoriE_Start takes unit c returns nothing
        call InoriE_KS.InoriE_Start( c )
        if GetHeroLevel(c)>=35 then
    call SaveInteger(hs,GetHandleId(c),StringHash("inori r clear"),1)
        endif
    endfunction
    function InoriR_Start takes unit c, real x, real y returns nothing
   if GetHeroLevel(c)>=35 then
    call SaveInteger(hs,GetHandleId(c),StringHash("inori r clear"),1)
        endif
   call InoriR_KS.InoriR_Start( c, x, y )
    endfunction
    function InoriER_Start takes unit c, real x, real y returns nothing
        call InoriR_KS.InoriR_Start( c, x, y )
    if GetHeroLevel(c)>=35 then
    call SaveInteger(hs,GetHandleId(c),StringHash("inori r clear"),1)
        endif
    endfunction
    function InoriR2_Start takes unit c, real x, real y returns nothing
        call InoriR2_KS.InoriR2_Start( c, x, y )
        
    endfunction
    function OnClickInori takes nothing returns nothing
        local framehandle clicked = BlzGetTriggerFrame()
        local integer k = 0
        local player p = GetTriggerPlayer()
        local integer k2 = GetPlayerId(p)
        if clicked == inori_frame_pas5[k2] then
            call SaveInteger(hs, GetHandleId(Hero[k2]), StringHash("current t"), InoriT_ID)
            call BlzFrameSetPoint(inori_frame_pas8[k2], FRAMEPOINT_BOTTOMLEFT, inori_frame_pas1[k2], FRAMEPOINT_CENTER, -0.11, -0.1)
            if GetLocalPlayer() == p then
                call BlzFrameSetVisible(inori_frame_pas8[k2], true)
                call BlzFrameSetTexture(inori_frame_pas9[k2], "Pick\\PickButton_Pick_Manual", 0, true)
            endif
            call BlzFrameSetEnable(inori_frame_pas10[k2], true)
        endif
        if clicked == inori_frame_pas7[k2] then
            call SaveInteger(hs, GetHandleId(Hero[k2]), StringHash("current t"), InoriT2_ID)
            call BlzFrameSetPoint(inori_frame_pas8[k2], FRAMEPOINT_BOTTOMLEFT, inori_frame_pas1[k2], FRAMEPOINT_CENTER, 0.11, -0.1)
            if GetLocalPlayer() == p then
                call BlzFrameSetVisible(inori_frame_pas8[k2], true)
                call BlzFrameSetTexture(inori_frame_pas9[k2], "Pick\\PickButton_Pick_Manual", 0, true)
            endif
            call BlzFrameSetEnable(inori_frame_pas10[k2], true)
        endif
        if clicked == inori_frame_pas10[k2] then
            set k = LoadInteger(hs, GetHandleId(Hero[k2]), StringHash("current t"))
            if k == InoriT_ID then
                call SetPlayerAbilityAvailable(Player(k2), k, true)
                call SetPlayerAbilityAvailable(Player(k2), InoriT2_ID, false)
            else
                call SetPlayerAbilityAvailable(Player(k2), k, true)
                call SetPlayerAbilityAvailable(Player(k2), InoriT_ID, false)
            endif
            if GetLocalPlayer() == p then
                call BlzFrameSetVisible(inori_frame_pas1[k2], false)
            endif
        endif
        if clicked == inori_frame_pas12[k2] then
            if GetLocalPlayer() == p then
                call BlzFrameSetVisible(inori_frame_pas1[k2], false)
            endif
        endif
        set p = null
        set clicked = null
    endfunction
    function InoriG_Start takes unit c returns nothing
        local real x = 0
        local real y = 0
        local integer id1 = InoriT_ID
        local integer id2 = InoriT2_ID
        local integer k2 = GetPlayerId(GetOwningPlayer(c))
        if GetUnitAbilityLevel(c, InoriT2_ID) == 0 then
            call UnitAddAbility(c, InoriT2_ID)
            call UnitAddAbility(c, InoriT_ID)
            call SetPlayerAbilityAvailable(Player(k2), InoriT2_ID, false)
            call SaveInteger(hs, GetHandleId(c), StringHash("current t"), 0)
        endif
        if inori_frame_pas1[k2] == null then
            if InoriFrameDebug == 0 then
                set InoriFrameDebug = InoriFrameDebug + 10
                call TriggerAddAction(InoriFrameTrig1, function OnClickInori)
            endif
            set inori_frame_pas1[k2] = BlzCreateFrame("EscMenuBackdrop", main_frame, 0, 0)
            call BlzFrameSetAbsPoint(inori_frame_pas1[k2], FRAMEPOINT_CENTER, 0.4, 0.35)
            call BlzFrameSetSize(inori_frame_pas1[k2], 0.5, 0.35)
            call BlzFrameSetVisible(inori_frame_pas1[k2], false)
            if GetLocalPlayer() == GetOwningPlayer(c) then
                call BlzFrameSetVisible(inori_frame_pas1[k2], true)
            endif
            set inori_frame_pas2[k2] = BlzCreateFrameByType("BACKDROP", "Port", inori_frame_pas1[k2], "", 0)
            call BlzFrameSetPoint(inori_frame_pas2[k2], FRAMEPOINT_CENTER, inori_frame_pas1[k2], FRAMEPOINT_BOTTOMLEFT, 0.135, 0.215)
            call BlzFrameSetSize(inori_frame_pas2[k2], 0.19, 0.19)
            call BlzFrameSetTexture(inori_frame_pas2[k2], "Textures\\black32.blp", 0, false)
            set inori_frame_pas3[k2] = BlzCreateFrameByType("BACKDROP", "Port", inori_frame_pas1[k2], "", 0)
            call BlzFrameSetPoint(inori_frame_pas3[k2], FRAMEPOINT_CENTER, inori_frame_pas1[k2], FRAMEPOINT_BOTTOMLEFT, 0.365, 0.215)
            call BlzFrameSetSize(inori_frame_pas3[k2], 0.19, 0.19)
            call BlzFrameSetTexture(inori_frame_pas3[k2], "Textures\\black32.blp", 0, false)
            set x = 0.135
            set y = 0.07
            set inori_frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", inori_frame_pas1[k2], "", 0)
            call BlzFrameSetPoint(inori_frame_pas4[k2], FRAMEPOINT_CENTER, inori_frame_pas1[k2], FRAMEPOINT_BOTTOMLEFT, x, y)
            call BlzFrameSetSize(inori_frame_pas4[k2], 0.04, 0.04)
            call BlzFrameSetTexture(inori_frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Inori_T", 0, false)
            set inori_frame_pas5[k2] = BlzCreateFrameByType("BUTTON", "MyIconButton", inori_frame_pas1[k2], "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetPoint(inori_frame_pas5[k2], FRAMEPOINT_CENTER, inori_frame_pas1[k2], FRAMEPOINT_BOTTOMLEFT, x, y)
            call BlzFrameSetSize(inori_frame_pas5[k2], 0.04, 0.04)
            set x = 0.365
            set y = 0.07
            set inori_frame_pas6[k2] = BlzCreateFrameByType("BACKDROP", "SS", inori_frame_pas1[k2], "", 0)
            call BlzFrameSetPoint(inori_frame_pas6[k2], FRAMEPOINT_CENTER, inori_frame_pas1[k2], FRAMEPOINT_BOTTOMLEFT, x, y)
            call BlzFrameSetSize(inori_frame_pas6[k2], 0.04, 0.04)
            call BlzFrameSetTexture(inori_frame_pas6[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Inori_T2", 0, false)
            set inori_frame_pas7[k2] = BlzCreateFrameByType("BUTTON", "MyIconButton", inori_frame_pas1[k2], "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetPoint(inori_frame_pas7[k2], FRAMEPOINT_CENTER, inori_frame_pas1[k2], FRAMEPOINT_BOTTOMLEFT, x, y)
            call BlzFrameSetSize(inori_frame_pas7[k2], 0.04, 0.04)
            set inori_frame_pas8[k2] = BlzCreateFrameByType("SPRITE", "justAName", inori_frame_pas1[k2], "WarCraftIIILogo", 0)
            call BlzFrameSetPoint(inori_frame_pas8[k2], FRAMEPOINT_BOTTOMLEFT, inori_frame_pas1[k2], FRAMEPOINT_CENTER, 0.11, -0.1)
            call BlzFrameSetSize(inori_frame_pas8[k2], 1, 1)
            call BlzFrameSetScale(inori_frame_pas8[k2], 1.05)
            call BlzFrameSetModel(inori_frame_pas8[k2], "Pick\\selecter5.mdx", 0)
            call BlzFrameSetVisible(inori_frame_pas8[k2], false)
            set x = 0.25
            set y = 0.07
            set inori_frame_pas9[k2] = BlzCreateFrameByType("BACKDROP", "SS", inori_frame_pas1[k2], "", 0)
            call BlzFrameSetPoint(inori_frame_pas9[k2], FRAMEPOINT_CENTER, inori_frame_pas1[k2], FRAMEPOINT_BOTTOMLEFT, x + 0.0025, y)
            call BlzFrameSetSize(inori_frame_pas9[k2], 0.045, 0.045)
            call BlzFrameSetTexture(inori_frame_pas9[k2], "Pick\\PickButton_Pick_Manual2", 0, true)
            set inori_frame_pas10[k2] = BlzCreateFrameByType("BUTTON", "MyIconButton", inori_frame_pas1[k2], "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetPoint(inori_frame_pas10[k2], FRAMEPOINT_CENTER, inori_frame_pas1[k2], FRAMEPOINT_BOTTOMLEFT, x, y)
            call BlzFrameSetSize(inori_frame_pas10[k2], 0.04, 0.04)
            set x = 0.47
            set y = 0.32
            set inori_frame_pas11[k2] = BlzCreateFrameByType("BACKDROP", "SS", inori_frame_pas1[k2], "", 0)
            call BlzFrameSetPoint(inori_frame_pas11[k2], FRAMEPOINT_CENTER, inori_frame_pas1[k2], FRAMEPOINT_BOTTOMLEFT, x, y)
            call BlzFrameSetSize(inori_frame_pas11[k2], 0.02, 0.02)
            call BlzFrameSetTexture(inori_frame_pas11[k2], "WOS\\DiscordIcon2", 0, true)
            set inori_frame_pas12[k2] = BlzCreateFrameByType("BUTTON", "MyIconButton", inori_frame_pas1[k2], "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetPoint(inori_frame_pas12[k2], FRAMEPOINT_CENTER, inori_frame_pas1[k2], FRAMEPOINT_BOTTOMLEFT, x, y)
            call BlzFrameSetSize(inori_frame_pas12[k2], 0.02, 0.02)
            set x = 0.135
            set y = 0.2
            set inori_frame_pas13[k2] = BlzCreateFrameByType("TEXT", "MyHeroNameButton", inori_frame_pas1[k2], "ScriptDialogButton", 0)
            call BlzFrameSetPoint(inori_frame_pas13[k2], FRAMEPOINT_CENTER, inori_frame_pas1[k2], FRAMEPOINT_BOTTOMLEFT, x, y)
            call BlzFrameSetSize(inori_frame_pas13[k2], 0.175, 0.19)
            call BlzFrameSetScale(inori_frame_pas13[k2], 1)
            call BlzFrameSetText(inori_frame_pas13[k2], BlzGetAbilityStringLevelField(BlzGetUnitAbility(c, id1), ABILITY_SLF_TOOLTIP_NORMAL, 0) + "|n|n" + BlzGetAbilityStringLevelField(BlzGetUnitAbility(c, id1), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, 0) )
            set x = 0.365
            set y = 0.2
            set inori_frame_pas14[k2] = BlzCreateFrameByType("TEXT", "MyHeroNameButton", inori_frame_pas1[k2], "ScriptDialogButton", 0)
            call BlzFrameSetPoint(inori_frame_pas14[k2], FRAMEPOINT_CENTER, inori_frame_pas1[k2], FRAMEPOINT_BOTTOMLEFT, x, y)
            call BlzFrameSetSize(inori_frame_pas14[k2], 0.175, 0.19)
            call BlzFrameSetScale(inori_frame_pas14[k2], 1)
            call BlzFrameSetText(inori_frame_pas14[k2], BlzGetAbilityStringLevelField(BlzGetUnitAbility(c, id2), ABILITY_SLF_TOOLTIP_NORMAL, 0) + "|n|n" + BlzGetAbilityStringLevelField(BlzGetUnitAbility(c, id2), ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, 0) )
    
            call BlzTriggerRegisterFrameEvent(InoriFrameTrig1, inori_frame_pas5[k2], FRAMEEVENT_CONTROL_CLICK)
            call BlzTriggerRegisterFrameEvent(InoriFrameTrig1, inori_frame_pas7[k2], FRAMEEVENT_CONTROL_CLICK)
            call BlzTriggerRegisterFrameEvent(InoriFrameTrig1, inori_frame_pas10[k2], FRAMEEVENT_CONTROL_CLICK)
            call BlzTriggerRegisterFrameEvent(InoriFrameTrig1, inori_frame_pas12[k2], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetVisible(inori_frame_pas8[k2], false)
            call BlzFrameSetEnable(inori_frame_pas10[k2], false)
        else
            call BlzFrameSetVisible(inori_frame_pas8[k2], false)
            call BlzFrameSetEnable(inori_frame_pas10[k2], false)
            call BlzFrameSetTexture(inori_frame_pas9[k2], "Pick\\PickButton_Pick_Manual2", 0, true)
            if GetLocalPlayer() == GetOwningPlayer(c) then
                call BlzFrameSetVisible(inori_frame_pas1[k2], true)
            endif
        endif
    endfunction
    function InoriF_Start takes unit c returns nothing
        call InoriF_KS.InoriF_Start( c )        
        if GetHeroLevel(c)>=35 then
    call SaveInteger(hs,GetHandleId(c),StringHash("inori r clear"),1)
        endif
    endfunction
    function InoriEE_Start takes unit c returns nothing
        call SaveInteger(hs, GetHandleId(c), StringHash("e activated"), 1)
    endfunction
    function InoriT1_Start takes unit c returns nothing
        call InoriT_KS.InoriT_Start( c )
        if GetHeroLevel(c)>=35 then
    call SaveInteger(hs,GetHandleId(c),StringHash("inori r clear"),1)
        endif
    endfunction
    function InoriT2_Start takes unit c returns nothing
      if GetHeroLevel(c)>=35 then
    call SaveInteger(hs,GetHandleId(c),StringHash("inori r clear"),1)
        endif
       call InoriT2_KS.InoriT2_Start( c )
    endfunction
    function InoriT3_Start takes unit c returns nothing
        call SaveInteger(hs, GetHandleId(c), StringHash("cancel t"), 1)
    endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com