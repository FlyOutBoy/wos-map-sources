library StarrkSpells uses GearSystems
    globals
//--------------------------------------Starrk--------------------------------------------------------------
        integer Starrk_ID = 'H01X'
        integer Starrk_Morph_ID = 'H01Y'
        integer StarrkG_ID = 'A0BO'
        integer CeroDummy_ID = 'h01U'
        real StarkG_Aoe12 = 1000
        real StarkG_Aoe25 = 800
        real StarkG_Aoe35 = 600
        real StarkG_TimeStatAdd = 30
        integer Starrk_Pas1ID = 'A0BR'
        integer Starrk_Pas2ID = 'A0BS'
        integer Starrk_Pas3ID = 'A0BT'
        integer Starrk_Pas4ID = 'A0BU'
        integer Starrk_Pas5ID = 'A0BV'
        integer Starrk_Pas6ID = 'A0BW'
//---------------Q ability-----------------------------------------------------
        integer StarrkQ_ID = 'A0BH'
        real StarrkQ_DamageAgiBase = 1 // base number x Int damage for 1 level
        real StarrkQ_DamageAgiStep = 1 // additional number x Int damage for each next level
        real StarrkQ_Damage2StaticBase = 150 // base static damage for 1 level
        real StarrkQ_Damage2StaticStep = 0 // additional static damage for each next level
        real StarrkQ_DamageMorphIntImprove = 1 // how much damage stat increase in morph
        real StarrkQ_DamageTIntImprove = 1 // morph + this amount will be added
        real StarrkQ_DamageAoe = 320
        real StarrkQ_RangeBase = 1300
        real StarrkQ_RangeStep = 100
        real StarrkEQ_RangeBonus = 150 // Range in morph 2x cero strike, Range for TQ(wolfes point atk) regulate in object editor in spell cast range
        real StarrkEQ_AoeMultiplier = 1.5 // multuple base DamageAoe x times
        real StarrkEQ_PushDistance = 400
        real StarrkEQ_PushDuration = 0.42
        real StarrkTQ_Aoe = 525
        real StarrkTQ_Stun = 0.2
//---------------W ability-----------------------------------------------------
        integer StarrkW_ID = 'A0BI'
        real StarrkW_DamageAgiBase = 1 // base number x Int damage for 1 level
        real StarrkW_DamageAgiStep = 1 // additional number x Int damage for each next level
        real StarrkW_Damage2StaticBase = 175 // base static damage for 1 level
        real StarrkW_Damage2StaticStep = 0 // additional static damage for each next level
        real StarrkW_StunDuration = 0.5 // in seconds
        real StarrkW_TargetHeight = 600 // max height
        real StarrkW_DamageAoe = 100 // cero aoe damage at the end
        real StarrkEW_DamageAoe = 100 // aoe dmg around target, same for TW
        integer StarrkEW_AttackCount = 4 // full amount of damage would be dealt for x times, TW dealt damage once
        real StarrkEW_DamageMorphIntImprove = 1 // how much damage stat increase in morph
        real StarrkTW_DamageImprove = 1 //morph + this amount will be added
//---------------E ability-----------------------------------------------------
        integer StarrkE_ID = 'A0BJ'
        integer StarrkE2_ID = 'A0BQ'
        real StarrkE_ReduceR_CD = 15
        real StarrkE2_RangeBase = 700
        real StarrkE2_RangeStep = 50
        integer StarrkE_MS = 20
        integer StarrkE_Atk_ID = 'A0BX'
        real StarrkE_DurationBase = 12 // in seconds , how long clone would live 10 = 10 sec
        real StarrkE_DurationStep = 2 // in seconds , how much time added with next level
        real StarrkE_AttackRange = 800 // additional attack range to morph, it mean count as basical attack range + this
        real StarrkE_AttackRangeBase = 100 // additional attack range to morph, it mean count as basical attack range + this
        integer StarrkE_IdDummy = 'h00E'//'h0CO'
        real StarrkEAtk_Aoe = 330
        real StarrkEAtk_CeroRange = 1900
        real StarrkEAtk_AddIntDmg = 0 // how much int adds to damage of cero attack
//---------------R ability-----------------------------------------------------
        integer StarrkR_ID = 'A0BP'
        integer StarrkR2_ID = 'A0BK'
        integer StarrkR3_ID = 'A0BN'
        integer StarrkR_Dummy_ID = 'h01W'
        real StarrkR_DamageAgiBase = 4 // base number x Int damage for 1 level
        real StarrkR_DamageAgiStep = 1 // additional number x Int damage for each next level
        real StarrkR_StunDuration = 0 // in seconds
        real StarrkR_TargetHeight = 600 // max height
        real StarrkR_DamageAoe = 250 // cero aoe damage at the end
        real StarrkR2_DamageAgiBase = 3 // base number x Int damage per 1 second
        real StarrkR2_DamageAgiStep = 0.4 // additional number x Int damage for each next level per second
        real StarrkR2_DamageAoe = 475
        integer StarrkR2_Slow = 50 // in % , 50 = 50%
        integer StarrkR2_SlowDuration = 1 // in seconds, from 2 to 4
        real StarrkR2_Stun = 0.1
        real StarrkR2_InvulPerLvlAdd = 0.2
        real StarrkR2_AbilityDurationBase = 1.5 // base duration, 1.3 - prepare time
        real StarrkR2_AbilityDurationStep = 0.8 // additional duration per each next lvl, at 5 lvl 1.85 * 4 additional time
        real StarrkR2_StunAppearTime = 2.01 // time after start of ability ( prepare time included) stun will also be applied to enemies, should be divided by 0.03
        real StarrkR2_PushToRange = 600 // spell will be push enemy if they are closer than this amount
//---------------T ability-----------------------------------------------------
        integer StarrkT_ID = 'A0BL'
        integer StarrkF_ID = 'A0F2'
        integer StarrkT2_ID = 'A0BM'
        integer StarrkWolf_ID = 'h01V'
        real StarrkT_DamageAgiBase = 0.85 // 1 x Agility damage per wolf, default wolf
        real StarrkTR_DamageAgiBase = 0.8 
        real StarrkT_DamageAgiBase2 = 1 // TT damage per wolf
        real StarrkT_DamageAoe = 600
        real StarrkT_SearchAoe = 1800
        real StarrkT_Duration = 10 + 1.6// 1.6 - delay, 15 - real wolfs time, add this time to morph duration
        real StarrkT_Stun = 0 // wolves do not stun
        real StarrkT3_HitGroupDuration = 3.0 // keeps one shared hit group alive after TT/TR launches
    endglobals
    private struct StarrkSpells_Utility
        private static timer t_StarrkPas2 = CreateTimer()
        private static integer array m_StarrkPas2
        private static integer MUI_StarrkPas2 = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        real scale
        real r6
        group g
        group g2
        unit u
        real dmg
        real aoe
        real move
        real r
        real a
        real rmax

        private static method Loop_StarrkPas2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_StarrkPas2
                set this = m_StarrkPas2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if move >= StarrkEAtk_CeroRange then
                        set r = 9999
                    endif
                    set k = 0
                    loop
                        exitwhen k > 1
                        if r < 0.09 then
                            set move = move + 9 + ( scale * 8 )
                        else
                            set move = move + 18 + ( scale * 9 )
                        endif
                        if PathableCheck(x1 + move * Cos( a ), y1 + move * Sin( a )) then
                            set x = x1 + move * Cos( a )
                            set y = y1 + move * Sin( a )
                        endif
                        call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx" , x , y , a * bj_RADTODEG , 1 , scale , 180 + r * 80 , 0.4 , 0 , 75 , 255 , 255)
                        call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx" , x , y , a * bj_RADTODEG , 1 , scale * 0.7 , 180 + r * 80 , 0.4 , 225 , 225 , 225 , 205)
                        set scale = scale + 0.3
                        set k = k + 1
                    endloop
                    if r6 > 0.03 then
                        set r6 = 0
                        call VisionTimed(GetOwningPlayer(c), x, y, 650, 2.5)
                        call DecorRemove(c, x, y, aoe, 20)
                    else
                        set r6 = r6 + 0.03
                    endif
                    if r2 > 0.03 then
                        set r2 = 0
                        call GroupClear( g )
                        call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup( u , g2 ) == false then
                                call dmgmag(c, u, dmg)
                                call GroupAddUnit( g2 , u )
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    else
                        set r2 = r2 + 0.03
                    endif
                else
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set u = null
                    set c = null
                    set m_StarrkPas2[i] = m_StarrkPas2[ MUI_StarrkPas2]
                    set MUI_StarrkPas2 = MUI_StarrkPas2 - 1
                    if MUI_StarrkPas2 == -1 then
                        call PauseTimer( t_StarrkPas2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method StarrkPas2_Start takes unit NewC, real NewX, real NewY, real NewDmg returns nothing
            local thistype this = thistype.create( )
            set MUI_StarrkPas2 = MUI_StarrkPas2 + 1
            set m_StarrkPas2[ MUI_StarrkPas2] = this
            set c = NewC
            set r = 0
            set x = NewX
            set y = NewY
            set move = 0
            set scale = 0.7
            set r2 = 10
            set g = CreateGroup()
            set g2 = CreateGroup()
            set aoe = StarrkEAtk_Aoe
            set a = GAngle2( c , x, y ) // Angle Between points
            call MakeSound("war3mapimported\\Hero_Starrk_E_Pas")
            set dmg = NewDmg
            set rmax = 0.9
            set x1 = GetUnitX(c) + 130 * Cos(a)
            set y1 = GetUnitY(c) + 130 * Sin(a)
            call DestroyEffect(EffectSpawnColor3("war3mapimported\\wos_whitering.mdx", x1, y1, a * bj_RADTODEG, 3, 0.71, 180, -90, 0, 75, 255, 255))
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue-shoot.mdl", x1 - 160 * Cos(a), y1 - 160 * Sin(a), a * bj_RADTODEG, 1.25, 1.15, 1))
            if MUI_StarrkPas2 == 0 then
                call TimerStart( t_StarrkPas2, 0.03, true, function thistype.Loop_StarrkPas2)
            endif
        endmethod

        private static method StarkCheckEffPass takes unit c, integer spell returns nothing
          
            call EUTU3(EffectSpawn("war3mapImported\\wos_az_airfloww11.mdx", GetUnitX(c), GetUnitY(c), 0, 1, 1.6, 10), 6000, 0, c, Starrk_Pas3ID)
           
        endmethod

    endstruct

    private struct StarrkSpells_Q
        private static timer t_StarrkQ = CreateTimer()
        private static integer array m_StarrkQ
        private static integer MUI_StarrkQ = -1
        unit c
        real x
        real y
        real x1
        real y1
        real x2
        real offset
        real y2
        real r2
        real r7
        integer k
        integer k2
        real scale
        real scale2
        real r3
        real r4
        unit array dd[18]
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

        private static method Loop_StarrkQ takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rkek = 0
            loop
                exitwhen i > MUI_StarrkQ
                set this = m_StarrkQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if k2 == 0 then // 0 - normal spell, 1 - morph spell, 2( only for q) enchaned with T morph spell
                        if check == 0 then
                            call DebugUnit2(c)
                            if r >= 0.6 then
                                call SetUnitTimeScale( c , 1)
                                call PauseUnit( c , false)
                                set check = 1
                                call MakeSound("war3mapimported\\Hero_Starrk_Q3")
                                set move = 0
                                set scale = 1
                                set rmax = 1.75
                                set r = 0
                            endif
                        elseif check == 1 then
                            if move >= r7 then
                                set r = 9999
                            endif
                            set offset = (18 + scale * 9)
                            set move = move + (offset * 2)
                            if PathableCheck(x1 + (move - offset) * Cos( a ), y1 + (move - offset) * Sin( a )) then
                                set x = x1 + (move - offset) * Cos( a )
                                set y = y1 + (move - offset) * Sin( a )
                            endif
                            call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx", x, y, a * bj_RADTODEG, 1, scale, 180 + r * 80, 0.45, 0, 75, 255, 255)
                            call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx", x + offset * Cos( a ), y + offset * Sin( a ), a * bj_RADTODEG, 1, scale * 0.7, 180 + r * 80, 0.45, 225, 225, 225, 205)
                            if PathableCheck(x1 + move * Cos( a ), y1 + move * Sin( a )) then
                                set x = x1 + move * Cos( a )
                                set y = y1 + move * Sin( a )
                            endif
                            call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx", x, y, a * bj_RADTODEG, 1, scale, 180 + r * 80, 0.45, 0, 75, 255, 255)
                            call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx", x + offset * Cos( a ), y + offset * Sin( a ), a * bj_RADTODEG, 1, scale * 0.7, 180 + r * 80, 0.45, 225, 225, 225, 205)
                            
                            set scale = scale + 0.67
                             /* set k = 0
                            loop
                                exitwhen k > 1
                                if r < 0.09 then
                                    set move = move + 9 + ( scale * 8 )
                                    elsedoe
                                    set move = move + 18 + ( scale * 9 )
                                endif
                                if PathableCheck(x1 + move * Cos( a ), y1 + move * Sin( a )) then
                                    set x = x1 + move * Cos( a )
                                    set y = y1 + move * Sin( a )
                                endif
                                call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx" , x , y , a * bj_RADTODEG , 1 , scale , 180 + r * 80 , 0.45 , 0 , 75 , 255 , 255)
                                call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx" , x , y , a * bj_RADTODEG , 1 , scale * 0.7 , 180 + r * 80 , 0.45 , 225 , 225 , 225 , 205)
                                
                                set scale = scale + 0.39
                                set k = k + 1
                            endloop */ 
                            if r6 > 0.03 then
                                set r6 = 0
                                call DecorRemove(c, x, y, aoe, 20)
                                call VisionTimed(GetOwningPlayer(c), x, y, 750, 2.2)
                            else
                                set r6 = r6 + 0.03
                            endif
                            if r2 > 0.03 then
                                set r2 = 0
                                call GroupClear( g )
                                call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup( u , g2 ) == false then
                                        call dmgmag(c, u, dmg)
                                        call GroupAddUnit( g2 , u )
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif
                    elseif k2 == 1 then
                        if check == 0 then
                            if r == rmax - 0.33 then
                                set x1 = (GetUnitX( c )) + 150 * Cos( a )
                                set y1 = (GetUnitY( c )) + 150 * Sin( a )
                                call EffectSpawn2("war3mapimported\\wos_BY_Wood_Effect_Order_DanGe_Stf_XuLi_1_1.mdx", x1 + 65 * Cos(a + 90 * bj_DEGTORAD), y1 + 65 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG, 1.15, 5, 170, 0.45)
                                call EffectSpawn2("war3mapimported\\wos_BY_Wood_Effect_Order_DanGe_Stf_XuLi_1_1.mdx", x1 + 65 * Cos(a - 90 * bj_DEGTORAD), y1 + 65 * Sin(a - 90 * bj_DEGTORAD), a * bj_RADTODEG, 1.15, 5, 170, 0.45)
                            endif
                            if r >= rmax then
                                call SetUnitTimeScale( c , 1)
                                call PauseUnit( c , false)
                                call DestroyEffect(e2)
                                call DestroyEffect(e)
                                set check = 1
                                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 3.55, 0, 255, 255, 255, 85))
                                call MakeSound("war3mapimported\\Hero_Starrk_EQ3")
                                set x1 = (GetUnitX( c )) + 10 * Cos( a )
                                set y1 = (GetUnitY( c )) + 10 * Sin( a )
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue-shoot.mdl", x1 + 65 * Cos(a + 90 * bj_DEGTORAD), y1 + 65 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG, 1.25, 1.75, 1))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue-shoot.mdl", x1 + 65 * Cos(a - 90 * bj_DEGTORAD), y1 + 65 * Sin(a - 90 * bj_DEGTORAD), a * bj_RADTODEG, 1.25, 1.75, 1))
                                set x1 = (GetUnitX( c )) + 150 * Cos( a )
                                set y1 = (GetUnitY( c )) + 150 * Sin( a )
                                set move = 70
                                set r4 = 10
                                set r2 = 0
                                set scale2 = 1.25
                                set rmax = 1.5
                                set r3 = 0
                                set r = 0
                            endif
                        elseif check == 1 then
                            if move >= r7 then
                                set r = 9999
                            endif
                            set k = 0
                            loop
                                exitwhen k > 1
                                if r < 0.09 then
                                    set move = move + 9 + ( scale * 8 )
                                else
                                    set move = move + 18 + ( scale * 9 )
                                endif
                                if PathableCheck(x1 + move * Cos( a ), y1 + move * Sin( a )) then
                                    set x = x1 + move * Cos( a )
                                    set y = y1 + move * Sin( a )
                                endif
                                set rkek = 0
                                call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx" , x , y , a * bj_RADTODEG , 1 , scale , 180 + r * 80 , 0.45 , 0 , 75 , 255 , 255)
                                call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx" , x , y , a * bj_RADTODEG , 1 , scale * 0.7 , 180 + r * 80 , 0.45 , 225 , 225 , 225 , 205)
                               // call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx" , x + rkek * Cos(a - 90 * bj_DEGTORAD) , y + rkek * Sin(a - 90 * bj_DEGTORAD) , a * bj_RADTODEG , 1 , scale , 180 + r * 80 , 0.45 , 0 , 75 , 255 , 255)
                              // call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx" , x + rkek * Cos(a - 90 * bj_DEGTORAD) , y + rkek * Sin(a - 90 * bj_DEGTORAD) , a * bj_RADTODEG , 1 , scale * 0.7 , 180 + r * 80 , 0.45 , 225 , 225 , 225 , 205)
                                
                                
                                //call EffectSpawnColor2("war3mapimported\\Gear_ulqashar.mdx" , x + rkek * Cos(a + 90 * bj_DEGTORAD) , y + rkek * Sin(a + 90 * bj_DEGTORAD) , a * bj_RADTODEG , 1 , scale , 200 + r * 80 , 0.51 , 0 , 75 , 255 , 255)
                                //call EffectSpawnColor2("war3mapimported\\Gear_ulqashar.mdx" , x + rkek * Cos(a + 90 * bj_DEGTORAD) , y + rkek * Sin(a + 90 * bj_DEGTORAD) , a * bj_RADTODEG , 1 , scale * 0.7 , 200 + r * 80 , 0.45 , 225 , 225 , 225 , 205)
                                //call EffectSpawnColor2("war3mapimported\\Gear_ulqashar.mdx" , x + rkek * Cos(a - 90 * bj_DEGTORAD) , y + rkek * Sin(a - 90 * bj_DEGTORAD) , a * bj_RADTODEG , 1 , scale , 200 + r * 80 , 0.51 , 0 , 75 , 255 , 255)
                                //call EffectSpawnColor2("war3mapimported\\Gear_ulqashar.mdx" , x + rkek * Cos(a - 90 * bj_DEGTORAD) , y + rkek * Sin(a - 90 * bj_DEGTORAD) , a * bj_RADTODEG , 1 , scale * 0.7 , 200 + r * 80 , 0.45 , 225 , 225 , 225 , 205)
                                set scale = scale + 0.5
                                set k = k + 1
                            endloop
                            if r3 > 0.0 and move < (r7 - 200) then
                                set r3 = 0
                                set scale2 = scale2 + 0.5
                                set e = EffectSpawnColor3("war3mapimported\\wos_whitering.mdx", x + rkek * Cos(a + 90 * bj_DEGTORAD) , y + rkek * Sin(a + 90 * bj_DEGTORAD) , a * bj_RADTODEG, 2.5, scale2, 265, -90, 0, 75, 255, 255)
                                set e = EffectSpawnColor3("war3mapimported\\wos_whitering.mdx", x + rkek * Cos(a - 90 * bj_DEGTORAD) , y + rkek * Sin(a - 90 * bj_DEGTORAD) , a * bj_RADTODEG, 2.5, scale2, 265, -90, 0, 75, 255, 255)
                            else
                                set r3 = r3 + 0.03
                            endif
                            if r6 > 0.03 then
                                set r6 = 0
                                
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue--zhendi31_3.mdl", x, y, GetRandomReal(0, 359), 0.85, 2.5, 1))
                                call DecorRemove(c, x + r2 * Cos(a), y + r2 * Sin(a), aoe * StarrkEQ_AoeMultiplier, 50)
                                call VisionTimed(GetOwningPlayer(c), x + r2 * Cos(a), y + r2 * Sin(a), aoe * StarrkEQ_AoeMultiplier + 400, 2)
                            else
                                set r6 = r6 + 0.03
                            endif
                            if r2 > 0.03  then
                                set r2 = 0
                                call GroupClear( g )
                                call GroupEnumUnitsInRange( g , x , y , aoe * StarrkEQ_AoeMultiplier , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup( u , g2 ) == false then
                                        call dmgmag(c, u, dmg)
                                        call MUE(u, StarrkEQ_PushDistance, StarrkEQ_PushDuration, a)
                                        call GroupAddUnit( g2 , u )
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif
                    elseif k2 == 2 then
                        if check == 0 then
                            if r >= rmax then
                                call SetUnitTimeScale( c , 1)
                                call PauseUnit( c , false)
                                set x1 = (GetUnitX( c )) + 250 * Cos( a + 75 * bj_DEGTORAD )
                                set y1 = (GetUnitY( c )) + 250 * Sin( a + 75 * bj_DEGTORAD )
                                set x2 = (GetUnitX( c )) + 250 * Cos( a - 75 * bj_DEGTORAD )
                                set y2 = (GetUnitY( c )) + 250 * Sin( a - 75 * bj_DEGTORAD )
                                set dd[0] = CreateUnit(GetOwningPlayer(c), StarrkWolf_ID, x1, y1, a * bj_RADTODEG)
                                call GroupAddUnit(g2, dd[0])
                                call SetUnitVertexColor(dd[0], 255, 255, 255, 0)
                                call ColorDummy4(dd[0], 0, 255, 255, 255, 0.45)
                                call AddSpecialEffectTarget("war3mapimported\\wos_by_wood_k_huoyantuowei3.mdx", dd[0], "chest")
                                call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_by_wood_k_baozha_2_blue.mdx", dd[0], "chest"))
                                set dd[1] = CreateUnit(GetOwningPlayer(c), StarrkWolf_ID, x2, y2, a * bj_RADTODEG)
                                call GroupAddUnit(g2, dd[1])
                                call SetUnitVertexColor(dd[1], 255, 255, 255, 0)
                                call ColorDummy4(dd[1], 0, 255, 255, 255, 0.45)
                                call AddSpecialEffectTarget("war3mapimported\\wos_by_wood_k_huoyantuowei3.mdx", dd[1], "chest")
                                call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_by_wood_k_baozha_2_blue.mdx", dd[1], "chest"))
                                set r3 = SR3(dd[0], x, y) / 15
                                set r4 = SR3(dd[1], x, y) / 15
                                set check = 1
                                set rmax = 15 * 0.03
                                set r = 0
                            endif
                        elseif check == 1 then
                            call MoveUnit2(dd[0], r3, GAngle2(dd[0], x, y))
                            call SetUnitFacing(dd[0], GAngle2(dd[0], x, y) * bj_RADTODEG)
                            call MoveUnit2(dd[1], r3, GAngle2(dd[1], x, y))
                            call SetUnitFacing(dd[1], GAngle2(dd[1], x, y) * bj_RADTODEG)
                            if r5 > 0.03 then
                                set r5 = 0
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", GetUnitX(dd[0]), GetUnitY(dd[0]), a * bj_RADTODEG, 0.5, 1.5, GetUnitFlyHeight(dd[0]) + 50))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", GetUnitX(dd[1]), GetUnitY(dd[1]), a * bj_RADTODEG, 0.5, 1.5, GetUnitFlyHeight(dd[1]) + 50))
                                call VisionTimed(GetOwningPlayer(c), GetUnitX(dd[0]), GetUnitY(dd[0]), 700, 2)
                                call VisionTimed(GetOwningPlayer(c), GetUnitX(dd[1]), GetUnitY(dd[1]), 700, 2)
                            else
                                set r5 = r5 + 0.03
                            endif
                            if r == rmax then
                                call VisionTimed(GetOwningPlayer(c), x, y, 1300, 3)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue--zhendi31_3_x2.mdl", x, y, GetRandomReal(0, 359), 0.65, 1, 1))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_acg_dajiqiquan4.mdx", x, y, 1, GetRandomReal(0.75, 1.25), 5.25, 1))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (431232).mdl", x, y, GetRandomReal(0, 359), 1.15, 3, 15))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (513).mdl", x, y, GetRandomReal(0, 359), 1.5, 1, 1))
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_by_wood_effect_order_dange_yueyun_2withoutblue2.mdl", x, y, GetRandomReal(0, 359), 1., 1.35, 1, 255, 255, 255, 255))
                                call GroupClear( g )
                                
                                call DecorRemove(c, x, y, aoe, 100)
                                call GroupEnumUnitsInRange( g , x , y , StarrkTQ_Aoe , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup( u , g2 ) == false then
                                        call dmgmag(c, u, dmg)
                                        call StunUnit(c, u, StarrkTQ_Stun)
                                        call GroupAddUnit( g2 , u )
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                                set k = 0
                                loop
                                    exitwhen k > 7
                                    set r5 = GetRandomReal(1.45, 1.9)
                                    call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_dustwave222.mdx", x, y, GetRandomReal(0, 359), r5, 2.35 + k * 0.85, 0, 75, 185, 255, 50))
                                    set k = k + 1
                                endloop
                                call ColorDummy3(dd[0], 0, 255, 255, 255, 0.3)
                                call ColorDummy3(dd[1], 0, 255, 255, 255, 0.3)
                                set dd[0] = null
                                set dd[1] = null
                            endif
                 
                        endif
                    endif
                else
                    if k2 == 2 then
                        call SaveInteger(hs, GetHandleId(c), StringHash("starrk t action"), 0)
                    endif
                    if check > 0 then
                        call DestroyEffect( e )
                        call DestroyEffect( e2 )
                    endif
                    call SetUnitTimeScale( c , 1)
                    if r <= 0.57 - 0.06 * k2 then
                        call PauseUnit( c , false)
                    endif
                    call DestroyGroup( g )
                    set g = null
                    call DestroyGroup( g2 )
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_StarrkQ[i] = m_StarrkQ[ MUI_StarrkQ]
                    set MUI_StarrkQ = MUI_StarrkQ - 1
                    if MUI_StarrkQ == -1 then
                        call PauseTimer( t_StarrkQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method StarrkQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_StarrkQ = MUI_StarrkQ + 1
            set m_StarrkQ[ MUI_StarrkQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set r3 = 0
            set r4 = 0
            set r5 = 0
            set r6 = 0
            set scale = 1.2
            call PauseUnit( c , true)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set check = 0
            set aoe = StarrkQ_DamageAoe
            set r7 = StarrkQ_RangeBase + ( StarrkQ_RangeStep * ( GetUnitAbilityLevel( c , StarrkQ_ID) - 1 ) )
            set dmg = GetHeroAgi( c , true) * ( StarrkQ_DamageAgiBase + ( StarrkQ_DamageAgiStep * ( GetUnitAbilityLevel( c , StarrkQ_ID) - 1 ) ) )
            set dmg = dmg + StarrkQ_Damage2StaticBase + ( StarrkQ_Damage2StaticStep * ( GetUnitAbilityLevel( c , StarrkQ_ID) - 1 ) )
            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e")) != 0 then
                set dmg = dmg + (GetHeroAgi( c , true) * StarrkQ_DamageMorphIntImprove)
                set r7 = r7+ StarrkEQ_RangeBonus
                if LoadInteger(hs, GetHandleId(c), StringHash("stark t")) == 1 then// T ability add dmg
                    set dmg = dmg + (GetHeroAgi( c , true) * StarrkQ_DamageTIntImprove)
                endif
            endif
            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e")) == 0 then
                set k2 = 0
                set x1 = GetUnitX( c ) + 85 * Cos( a )
                set y1 = GetUnitY( c ) + 85 * Sin( a )
                set e2 = EffectSpawn("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiblue.mdl", x1, y1, 0, 1.15, 2.75, 178)
                call MyRemoveEff(e2, 0.63)
                call SetUnitFacing( c , a * bj_RADTODEG)
                set rmax = 2
                call SetUnitTimeScale( c , 0.75)
                call SetUnitAnimationByIndex( c , 12)
                call MakeSound("war3mapimported\\Hero_Starrk_Q")
                call MakeSound("war3mapimported\\Hero_Starrk_Q2")
            elseif LoadInteger(hs, GetHandleId(c), StringHash("stark t")) == 0 then
                set e = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiblue.mdx", c, "hand left")
                set e2 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiblue.mdx", c, "hand right")
                set k2 = 1
                set rmax = 0.66
                call SetUnitTimeScale( c , 1)
                call SetUnitAnimationByIndex( c , 3)
                if GetRandomInt(1, 2) == 1 or LoadInteger(hs, GetHandleId(c), StringHash("ban sound q")) == 1 then
                    call MakeSound("war3mapimported\\Hero_Starrk_EQ")
                else
                    call MakeSound("war3mapimported\\Hero_Starrk_EQ2")
                endif
            else
                set k2 = 2
                set rmax = 0.6
                call SaveInteger(hs, GetHandleId(c), StringHash("starrk t action"), 1)
                call MakeSound("war3mapimported\\Hero_Starrk_TQ")
            endif
            if MUI_StarrkQ == 0 then
                call TimerStart( t_StarrkQ, 0.03, true, function thistype.Loop_StarrkQ)
            endif
        endmethod

    endstruct

    private struct StarrkSpells_W
        private static timer t_StarrkW = CreateTimer()
        private static integer array m_StarrkW
        private static integer MUI_StarrkW = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k2
        integer k3
        real scale
        real scale2
        real r3
        real r4
        real r5
        real fly
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

        private static method Loop_StarrkW takes nothing returns nothing
            local integer this
            local real rr3 = 0
            local real rr4 = 0
            local real rr5 = 0
            local real random
            local integer i = 0
            loop
                exitwhen i > MUI_StarrkW
                set this = m_StarrkW[i]
                if SpellBoolCaster(c) and r <= rmax and SpellBoolCaster(td) then
                    set r = RoundReal(r + 0.03, 3)
                    set r = S2R( R2SW( r , 0, 3 ) )
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    set a = GAngle(c, td)
                    call SetUnitFacing(c, a * bj_RADTODEG)
                    if check == 0 then
                        call DebugUnit2(c)
                        if r == 0.35 then
                            set move = 80
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, 1, 255, 255, 255, 255))
                        endif
                        if r > 0.35 then
                            if SR2(c, td) > 120 then
                                set a = GAngle(c, td)
                                call MoveUnit(c, move, a)
                                call SetUnitFacing(c, a * bj_RADTODEG)
                            else
                                set x = GetUnitX(td)
                                set y = GetUnitY(td)
                                call DecorRemove(c, x, y, 175, 20)
                                set r = 99999
                                call MakeSound("war3mapimported\\Hero_Starrk_W2 2")
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlash.mdl" , x + 25 * Cos(a), y + 25 * Sin(a), 1, 1., 1.475, 125))
                      //      call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_TanjiroEffect229.mdl", x - 100 * Cos(a), y - 100 * Sin(a), a * bj_RADTODEG, 1.5, 2.65, 135), 0.36, 255, 255, 255, 0.3)
                                call MUE(c, 450, 0.3, a)
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_slashbluekojiro.mdl", x, y, a * bj_RADTODEG + 90, 1, 1.7, 175))
                                call AddSpecialEffectTarget("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", td, "chest")
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.1, 4, 9))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_bloodex-special-23.mdx", x, y, GetRandomReal(0, 359), 2.5, 3.75, 65))
                                call DecorRemove(c, x, y, aoe, 25)
                                call dmgphys(c, td, dmg)
                            endif
                        endif
                    elseif check == 1 then
                        call DebugUnit2(c)
                        if k2 >= k3 then
                            set r = 999
                        endif
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        if r == 0.03 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1.8, 0))
                            call SetUnitPosition(c, GetUnitX(td) - 195 * Cos(a), GetUnitY(td) - 195 * Sin(a))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_blackblink.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.35, 0, 0, 0, 0, 255))
                            call SetUnitAnimationByIndex(c, 14)
                            call SetUnitTimeScale(c, 1.3)
                        endif
                        if r3 > 0.7 then
                            set r3 = 0
                            call SetUnitAnimationByIndex(c, 14)
                        else
                            set r3 = r3 + 0.03
                        endif
                        if r4 > 1.2 then
                            set r4 = 0
                            call MakeSound("war3mapimported\\Hero_Starrk_EW3")
                        else
                            set r4 = r4 + 0.03
                        endif
                        if r2 > 0.15 then
                            set r2 = 0
                            set k2 = k2 + 1
                            call DecorRemove(c, x, y, aoe, 20)
                            set a = GetRandomReal(0, 359) * bj_DEGTORAD
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1.8, 0))
                            call SetUnitPosition(c, GetUnitX(td) - 225 * Cos(a), GetUnitY(td) - 225 * Sin(a))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_blackblink.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.35, 0, 0, 0, 0, 255))
                            call BlzSetUnitFacingEx(c, GAngle(c, td) * bj_RADTODEG)
                            call MUE(c, 450, 0.18, GAngle(c, td))
                            call SetUnitAnimation(td, "death")
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.1, 3, 9))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.1, 4, 9))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_bloodex-special-23.mdx", x, y, GetRandomReal(0, 359), 2.5, 3.75, 65))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.1, 5, 9))
                            set random = GetRandomReal(0, 359)
                            set e = EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, random, 0.75, 1.2, 155)
                            call BlzSetSpecialEffectRoll(e, -10 * bj_DEGTORAD)
                            call DestroyEffect(e)
                            set random = GetRandomReal(0, 359)
                            set e = EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, random, 0.75, 1.2, 155)
                            call BlzSetSpecialEffectRoll(e, -10 * bj_DEGTORAD)
                            call DestroyEffect(e)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x, y, a * bj_RADTODEG, 0.5, 5, 50))
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, null)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) or u == td then
                                    call dmgphys(c, u, dmg)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_ZK_BMSword-qi explosion_Lan.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        else
                            set r2 = r2 + 0.03
                        endif
                    elseif check == 2 then
                        call DebugUnit2(c)
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        if r == 0.03 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1.8, 0))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_HakkeStart.mdx", x, y, a * bj_RADTODEG, 0.5, 2, 5))
                            call SetUnitPosition(c, GetUnitX(td) - 295 * Cos(a), GetUnitY(td) - 295 * Sin(a))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_blackblink.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.35, 0, 0, 0, 0, 255))
                            call SetUnitAnimationByIndex(c, 14)
                            call SetUnitTimeScale(c, 0.15)
                        endif
                        if r == 0.69 then
                            call MakeSound("war3mapimported\\Hero_Starrk_EW2")
                            call MUE(c, 900, 0.27, GAngle(c, td))
                        endif
                        if r == 0.81 then
                            call AddSpecialEffectTarget("war3mapimported\\wos_bloodex-special-23.mdl", td, "chest")
                            call AddSpecialEffectTarget("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", td, "chest")
                            call SetUnitAnimation(td, "death")
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_blood pool.mdx", GetUnitX(td), GetUnitY(td), GetRandomReal(0, 359), 2.1, 1.75, 9))
                            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("wolf ult"), 0)
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (431232).mdl", x, y, GetRandomReal(0, 359), 1.5, 2.15, 35))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue--zhendi31_3_x2.mdl", x, y, GetRandomReal(0, 359), 1, 2.5, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.1, 3, 9))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_slashbluekojiro.mdl", x, y, a * bj_RADTODEG + 90, 1, 1.7, 175))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x, y, a * bj_RADTODEG, 0.45, 6, 50))
                            call GroupClear(g)
                            
                            call DecorRemove(c, x, y, 350, 50)
                            call GroupEnumUnitsInRange(g, x, y, aoe, null)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) or u == td then
                                    call dmgphys(c, u, dmg)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set r = 9999
                        endif
                    endif
                else
                    if check == 2 then
                        call SaveInteger(hs, GetHandleId(c), StringHash("starrk t action"), 0)
                        call DestroyEffect(e)
                        call DestroyEffect(e2)
                        set e = null
                        set e2 = null
                    endif
                    call ColorEffDummy3(e3, 0, 255, 255, 255, 0.06)
                    call SetUnitVertexColor(c, 255, 255, 255, 255)
                    call StopSpellUnit2(c)
                    call StunUnit(c, td, StarrkW_StunDuration)
                    call SetUnitAnimation(c, "stand")
                    call SetUnitTimeScale( c , 1)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set e = null
                    set c = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set m_StarrkW[i] = m_StarrkW[ MUI_StarrkW]
                    set MUI_StarrkW = MUI_StarrkW - 1
                    if MUI_StarrkW == -1 then
                        call PauseTimer( t_StarrkW)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method StarrkW_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_StarrkW = MUI_StarrkW + 1
            set m_StarrkW[ MUI_StarrkW] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set check = 0
            set k2 = 0
            set r5 = 0
            set g = CreateGroup()
            set g2 = CreateGroup()
            set aoe = StarrkW_DamageAoe
            set a = GAngle( c , td ) // Angle Between points
            set dmg = GetHeroAgi( c , true) * ( StarrkW_DamageAgiBase + ( StarrkW_DamageAgiStep * ( GetUnitAbilityLevel( c , StarrkW_ID) - 1 ) ) )
            set dmg = dmg + StarrkW_Damage2StaticBase + ( StarrkW_Damage2StaticStep * ( GetUnitAbilityLevel( c , StarrkW_ID) - 1 ) )
            set rmax = 6
            call SetUnitFacing(c, a * bj_RADTODEG)
            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e")) == 0 then
                call StartSpellUnit2(c)
                call MakeSound("war3mapimported\\Hero_Starrk_W2 1")
                call SetUnitTimeScale( c , 0.5)
                call SetUnitAnimationByIndex(c, 4)
                set fly = StarrkW_TargetHeight / 67
                set r4 = 2.01
                set scale = 1
                set scale2 = 0.25
                set move = 70
            elseif LoadInteger(hs, GetHandleId(c), StringHash("stark t")) == 0 then
                set r4 = 999
                set check = 1
                set rmax = 4
                set aoe = StarrkEW_DamageAoe
                set dmg = dmg + StarrkEW_DamageMorphIntImprove * GetHeroAgi(c, true)
                set k3 = StarrkEW_AttackCount
                set dmg = dmg / k3
                call StartSpellUnit2(c)
                call MakeSound("war3mapimported\\Hero_Starrk_EW")
                call MakeSound("war3mapimported\\Hero_Starrk_EW2")
                call SetUnitAnimationByIndex( c , 0)
                call SetUnitTimeScale( c , 0.4)
                set move = 105
            else
                set r4 = 999
                set check = 2
                set rmax = 1.8
                call SaveInteger(hs, GetHandleId(c), StringHash("starrk t action"), 1)
                set dmg = dmg + StarrkEW_DamageMorphIntImprove * GetHeroAgi(c, true)
                set dmg = dmg + StarrkTW_DamageImprove * GetHeroAgi(c, true)
                set aoe = StarrkEW_DamageAoe
                call StartSpellUnit2(c)
                call MakeSound("war3mapimported\\Hero_Starrk_TW")
                call SetUnitAnimationByIndex( c , 0)
                call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("wolf ult"), 1)
                call SetUnitTimeScale( c , 0.4)
                set e = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiblue.mdx", c, "hand left")
                set e2 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiblue.mdx", c, "hand right")
            endif
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("w skill"), 1)
            if MUI_StarrkW == 0 then
                call TimerStart( t_StarrkW, 0.03, true, function thistype.Loop_StarrkW)
            endif
        endmethod

    endstruct

    private struct StarrkSpells_E
        private static timer t_StarrkE = CreateTimer()
        private static integer array m_StarrkE
        private static integer MUI_StarrkE = -1
        unit d
        unit c
        real x
        real y
        framehandle array frame_pas1 [10]
        framehandle array frame_pas2 [10]
        framehandle array frame_pas3 [10]
        framehandle array frame_pas4 [10]
        framehandle array frame_pas5 [10]
        framehandle array frame_pas6 [10]
        real r2
        integer k
        integer k2
        real r3
        real r5
        unit u
        integer check
        integer check2
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_StarrkE takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_StarrkE
                set this = m_StarrkE[i]
                if SpellBoolCaster(c) and r <= rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false then
                    if check == 0 or (check == 1 and IsUnitPaused(c) == false and GetUnitAbilityLevel(c, 'Avul') == 0 and LoadInteger(hs, GetHandleId(c), StringHash("starrk t action")) == 0) then
                        set r = r + 0.05
                    endif
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if check == 0 then
                        if r == 0.05 then
                            call ColorEffDummy3(e2, 0, 255, 255, 255, 0.5)
                            call MakeSound("war3mapimported\\Hero_Starrk_T3")
                            call EffectSpawn2("war3mapimported\\wos_kenpachiaura.mdx", x, y, 0, 1, 1.55, 0, rmax - 2.4)
                        endif
                        if r >= 0 then
                            if r2 > 0.2 then
                                set r2 = 0
                                call DecorRemove(c, x, y, 650, 20)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (431232).mdl", x, y, GetRandomReal(0, 359), 1.5, 2.15, 35))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue--zhendi31_3_x2.mdl", x, y, GetRandomReal(0, 359), 1, 1, 1))
                            else
                                set r2 = r2 + 0.05
                            endif
                            if r3 > 0.3 then
                                set r3 = 0
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_by_wood_effect_order_dange_yueyun_2withoutblue2.mdl", x, y, GetRandomReal(0, 359), 2.35, 1.5, 1, 255, 255, 255, 55))
                            else
                                set r3 = r3 + 0.05
                            endif
                        endif
                        if r == rmax then
                            call MakeSound("war3mapimported\\Hero_Starrk_E5")
                            call NextSound("war3mapimported\\Hero_Starrk_EQ2", 0.3)
                            call SaveInteger(hs, GetHandleId(c), StringHash("ban sound q"), 1)
                            call MyFlush(GetHandleId(c), StringHash("ban sound q"), 0, 3)
                            set k = 0
                            loop
                                exitwhen k > 3
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_dustwave222.mdx", x, y, GetRandomReal(0, 359), 0.85, 2.35 + k * 0.65, 0, 0, 125, 255, 90))
                                set k = k + 1
                            endloop
                            call SetUnitTimeScale(c, 1)
                            //call DestroyEffect(EffectSpawn("war3mapimported\\wos_es69.mdx", x, y, GetRandomReal(0, 359), 2.15, 4.5, 1))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_by_wood_effect_order_dange_yueyun_2withoutblue2.mdx", x, y, GetRandomReal(0, 359), 0.65, 1.85, 1))
                            call StopSpellUnit2(c)
                            call BlzSetUnitSkin(c, Starrk_Morph_ID)
                            call AAUniversalTooltips_SetUnitForm(c, 1)
                            call FixAura(c)
                            call UnitAddAbility(c, StarrkE_Atk_ID)
                            call SetUnitAbilityLevel(c, StarrkE_Atk_ID, GetUnitAbilityLevel(c, StarrkE_ID))
                            //call UnitAddAbility(c, StarrkE_AS_ID)
                           // call SetUnitAbilityLevel(c,StarrkE_AS_ID,GetUnitAbilityLevel(c,StarrkE_ID))
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), StarrkE_ID, false)
                            if GetUnitAbilityLevel(c, StarrkR_ID) > 0 then
                                call UnitAddAbility(c, StarrkR2_ID)
                                call SetPlayerAbilityAvailable(GetOwningPlayer(c), StarrkR2_ID, true)
                                call SetPlayerAbilityAvailable(GetOwningPlayer(c), StarrkR_ID, false)
                                call SetUnitAbilityLevel(c, StarrkR2_ID, GetUnitAbilityLevel(c, StarrkR_ID))

                                    call BlzStartUnitAbilityCooldown(c,StarrkR2_ID,BlzGetUnitAbilityCooldownRemaining(c, StarrkR_ID))
                                if GetHeroLevel(c) >= 35 then
                                call ReduceCooldown(c,StarrkR2_ID,StarrkE_ReduceR_CD)
                                endif
                            endif
                            call AddSpellLevel(c, 'A01C', GetUnitAbilityLevel(c, StarrkE_ID) * 2, true)
                            call BlzSetUnitWeaponIntegerField(c, UNIT_WEAPON_IF_ATTACK_ATTACK_TYPE, 0, 4)// 4 - mag, 5 - chaos, 6 - hero
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), StarrkE2_ID, true)
                            call UnitAddAbility(c, StarrkE2_ID)
                            call SetUnitAbilityLevel(c, StarrkE2_ID, GetUnitAbilityLevel(c, StarrkE_ID))
                            call UnitMakeAbilityPermanent(c, true, StarrkE_Atk_ID)
                           // call UnitMakeAbilityPermanent(c, true, StarrkE_AS_ID)
                            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e"), 1)
                            set r = 0
                            if GetHeroLevel(c) >= 35 then
                                call AddHpRegen(c, 20, true)
                            endif
                            set rmax = StarrkE_DurationBase + (StarrkE_DurationStep * ( GetUnitAbilityLevel( c , StarrkE_ID) - 1 )) + 0.2
                            set d = CreateUnit(Player(k2), StarrkE_IdDummy, 1, 1, 1)
                            set r2 = 9999
                            set check = 1
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
                                call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, rmax + 2)
                                call BlzFrameSetValue(frame_pas3[k2], rmax)
                                set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18)
                                call BlzFrameSetSize(frame_pas4[k2], 0.03, 0.03)
                                call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Starrk_E", 0, false)
                                set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                                call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Morph Time Left:" + "|r")
                                call BlzFrameSetScale(frame_pas5[k2], 0.9)
                                set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17)
                                call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                                call BlzFrameSetScale(frame_pas6[k2], 0.9)
                            else
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame_pas1[k2], true)
                                endif
                                call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, rmax + 2)
                                call BlzFrameSetValue(frame_pas3[k2], rmax)
                            endif
                        endif
                   
                    elseif check == 1 then
                        call BlzFrameSetValue(frame_pas3[k2], rmax - (r + 0.1))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                        if check2 == 0 and LoadInteger(hs, GetHandleId(c), StringHash("stark t")) == 1 then
                            set rmax = rmax + StarrkT_Duration
                            call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, rmax + 2)
                            set check2 = 1
                        endif
                        if r2 > 0.94 then
                            set r2 = 0
                        else
                            set r2 = r2 + 0.05
                        endif
                        if r == 0.05 then
                            call BlzSetAbilityIcon(StarrkQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Starrk_EQ.blp")
                            call BlzSetAbilityIcon(StarrkW_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Starrk_EW.blp")
                        endif
                    endif
                else
                    if check == 0 then
                        call DestroyEffect(e2)
                        call StopSpellUnit2(c)
                    endif
                    call RemoveUnit(d)
                    call BlzSetUnitWeaponIntegerField(c, UNIT_WEAPON_IF_ATTACK_ATTACK_TYPE, 0, 6)// 4 - mag, 5 - chaos, 6 - hero
                    call SetUnitRange(c, StarrkE_AttackRangeBase)
                    call SaveInteger(hs, GetHandleId(Player(k2)), StringHash("morph e"), 0)
                    call BlzSetAbilityIcon(StarrkQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Starrk_Q.blp")
                    call BlzSetAbilityIcon(StarrkW_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Starrk_W.blp")
                    call BlzSetUnitSkin(c, Starrk_ID)
                    call AAUniversalTooltips_SetUnitForm(c, 0)
                    call BlzStartUnitAbilityCooldown(c, StarrkR_ID, BlzGetUnitAbilityCooldownRemaining(c, StarrkR2_ID))
                    call AddSpellLevel(c, 'A01C', GetUnitAbilityLevel(c, StarrkE_ID) * 2, false)
                    if check == 1 then
                        if GetHeroLevel(c) >= 35 then
                            call AddHpRegen(c, 20, false)
                        endif
                    endif
                    //call UnitRemoveAbility(c, StarrkE_AS_ID)
                    call UnitRemoveAbility(c, StarrkE_Atk_ID)
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame_pas1[k2], false)
                    endif
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), StarrkR2_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), StarrkE2_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), StarrkR_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), StarrkE_ID, true)
                    call UnitRemoveAbility(c, StarrkR3_ID)
                    call UnitRemoveAbility(c, StarrkT2_ID)
                    call FixAura(c)
                    call SetUnitTimeScale( c, 1 )
                    if check == 0 then
                        call PauseUnit(c, false)
                    endif
                    set c = null
                    set d = null
                    set m_StarrkE[i] = m_StarrkE[MUI_StarrkE]
                    set MUI_StarrkE = MUI_StarrkE - 1
                    if MUI_StarrkE == -1 then
                        call PauseTimer( t_StarrkE )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod

        public static method StarrkE_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_StarrkE = MUI_StarrkE + 1
            set m_StarrkE[MUI_StarrkE] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set r2 = 10
            set r3 = 10
            set check2 = 0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            call StartSpellUnit2(c)
            set check = 0
            set r5 = BlzGetUnitWeaponRealField(u, UNIT_WEAPON_RF_ATTACK_RANGE, 0)
            set u = null
            set a = GetUnitFacing(c) * bj_DEGTORAD // Angle Between points
            set rmax = 1
            call VisionTimed(GetOwningPlayer(c), GetUnitX(c), GetUnitY(c), 1800, rmax + 2)
            call SetUnitRange(c, StarrkE_AttackRange)
            call SetUnitTimeScale(c, 0.9)
            call MakeSound("war3mapimported\\Hero_Starrk_E4")
            if MUI_StarrkE == 0 then
                call TimerStart( t_StarrkE, 0.05, true, function thistype.Loop_StarrkE )
            endif
        endmethod

    endstruct

    private struct StarrkSpells_R
        private static timer t_StarrkR3 = CreateTimer()
        private static integer array m_StarrkR3
        private static integer MUI_StarrkR3 = -1
        private static timer t_StarrkR2 = CreateTimer()
        private static integer array m_StarrkR2
        private static integer MUI_StarrkR2 = -1
        private static timer t_StarrkR = CreateTimer()
        private static integer array m_StarrkR
        private static integer MUI_StarrkR = -1
        unit d
        unit c
        unit td
        unit d2
        real x
        real y
        real x1
        real y1
        real r2
        real r7
        integer k
        integer k2
        integer k3
        real scale
        real scale2
        real r3
        real r4
        real r5
        real fly
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
        effect e3
        effect e4
        real a
        real rmax

        private static method Loop_StarrkR3 takes nothing returns nothing
            local integer this
            local real rr3 = 0
            local real rr4 = 0
            local real rr5 = 0
            local real random
            local integer i = 0
            loop
                exitwhen i > MUI_StarrkR3
                set this = m_StarrkR3[i]
                if SpellBoolCaster(c) and r <= rmax and SpellBoolCaster(td) then
                    set r = RoundReal(r + 0.03, 3)
                    set r = S2R( R2SW( r , 0, 3 ) )
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call DebugUnit(c)
                    if r> 1.02 then 
                    call DebugUnit2(td)
                    endif
                    set a = GAngle(c, td)
                    call SetUnitFacing(c, a * bj_RADTODEG)
                    if r < 1.01 then
                        call SetFly(td, GetUnitFlyHeight(td) + fly)
                    endif
                    if k2 == 0 then
                        if r2 > 0.09 then
                            call SetUnitX(c, x - 30 * Cos(a))
                            call SetUnitY(c, y - 30 * Sin(a))
                            set r2 = 0
                            set rr3 = GetRandomReal(150, 475)
                            set rr4 = GetRandomReal(0, 359)
                            set rr5 = GetRandomReal(150, 350)
                            set e = EffectSpawn3("war3mapImported\\wos_Starrk1.mdx", x + rr3 * Cos(rr4), y + rr3 * Sin(rr4), Atan2(y - (y + rr3 * Sin(rr4)), x - ( x + rr3 * Cos(rr4))) * bj_RADTODEG, 1, BlzGetUnitRealField(c, UNIT_RF_SCALING_VALUE), GetUnitFlyHeight(td) + rr5, -330)
                            call ColorEffDummy3(e, 0.21, 125, 125, 125, 0.21)
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_blackblink.mdx", x + rr3 * Cos(rr4), y + rr3 * Sin(rr4), GetRandomReal(0, 359), 4, 2, GetUnitFlyHeight(td) + rr5, 0, 0, 0, 255))
                            set rr3 = GetRandomReal(150, 475)
                            set rr4 = GetRandomReal(0, 359)
                            set rr5 = GetRandomReal( -50, 50)
                            set e = EffectSpawn3("war3mapImported\\wos_Starrk1.mdx", x + rr3 * Cos(rr4), y + rr3 * Sin(rr4), Atan2(y - (y + rr3 * Sin(rr4)), x - ( x + rr3 * Cos(rr4))) * bj_RADTODEG, 1, BlzGetUnitRealField(c, UNIT_RF_SCALING_VALUE), GetUnitFlyHeight(td) + rr5, 0)
                            call ColorEffDummy3(e, 0.21, 125, 125, 125, 0.21)
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_blackblink.mdx", x + rr3 * Cos(rr4), y + rr3 * Sin(rr4), GetRandomReal(0, 359), 4, 2.25, GetUnitFlyHeight(td) + rr5, 0, 0, 0, 255))
                        else
                            set r2 = r2 + 0.03
                        endif
                        if r3 > 0.03 then
                            set r3 = 0
                            set rr3 = GetRandomReal(100, 375)
                            set rr4 = GetRandomReal(0, 359)
                            set rr5 = GetRandomReal( -250, 250)
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_blackblink.mdx", x + rr3 * Cos(rr4), y + rr3 * Sin(rr4), GetRandomReal(0, 359), 4, 2, GetUnitFlyHeight(td) + rr5, 0, 0, 0, 255))
                        else
                            set r3 = r3 + 0.03
                        endif
                    endif
                    if r == 1.02 then                    
            call StartSpellUnit2(td)
                        call MakeSound("war3mapimported\\Hero_Starrk_W3")
                    endif
                    if r == 1.32 then
                        call SetUnitTimeScale(c, 0.65)
                        call SetUnitAnimationByIndex(c, 2)
                        call SetFly(c, GetUnitFlyHeight(td) - 300)
                        call SetUnitPosition(c, x + 30 * Cos(a), y + 30 * Sin(a))
                        set x1 = GetUnitX(c)
                        set y1 = GetUnitY(c)
                        set e2 = EffectSpawn("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiblue.mdl", x1, y1, 0, 1.15, 3, GetUnitFlyHeight(c) + 110)
                        call MyRemoveEff(e2, 1.32)
                        set e4 = EffectSpawn("war3mapimported\\wos_BY_Wood_Effect_Order_DanGe_Stf_XuLi_1_1.mdl", x1, y1, 0, 1, 2.5, GetUnitFlyHeight(c) + 110)
                        call MyRemoveEff(e4, 1.32)
                        call DestroyEffect(EffectSpawn3("war3mapimported\\wos_blackblink.mdx", x1, y1, a * bj_RADTODEG + 180, 4, 3, GetUnitFlyHeight(td) + rr5, -90))
                        set rr3 = GetUnitX(c) - 180 * Cos(a)
                        set rr4 = GetUnitY(c) - 180 * Sin(a)
                        set e3 = EffectSpawn3("war3mapImported\\wos_Starrk1.mdl", rr3, rr4, a * bj_RADTODEG + 180, 1.15, BlzGetUnitRealField(c, UNIT_RF_SCALING_VALUE), GetUnitFlyHeight(c), -90)
                        call MakeSound("war3mapimported\\Hero_Starrk_W2")
                        set move = 0
                        set fly = GetUnitFlyHeight(c)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_HakkeStart.mdx", x, y, GetRandomReal(0, 359), 0.475, 1.65, 5))
                    endif
                    if r == 1.11 or r == 1.34 or r == 1.67 or r == 2.01 then
                        call EffectSpawn2("war3mapimported\\wos_BY_Wood_Effect_Order_DanGe_Stf_XuLi_1_1.mdx", x1, y1, GetRandomReal(0, 359), 0.75, 4.5, fly + 110, 0.66)
                        call EffectSpawn2("war3mapimported\\wos_blue--zhendi31_3.mdx", x1, y1, GetRandomReal(0, 359), 1, 3.5, fly - 150, 0.45)
                    endif
                    if r == 1.2 then
                        set k2 = 1
                    endif
                    if r == 1.5 then
                        call MakeSound("war3mapimported\\Hero_Starrk_W4")
                        call SetUnitAnimation(td, "death")
                            call DecorRemove(c, x, y, 450, 50)
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup( u , g2 ) == false then
                                    call dmgmag(c, u, dmg)
                                    call GroupAddUnit( g2 , u )
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        
                        endif
                    if r > 1.5 then
                        if move >= 1750 then
                            set r = 9999
                        endif
                        set k = 0
                        loop
                            exitwhen k > 1
                            set move = move + 7 + ( scale * 2.5 )
                            call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx" , x , y , a * bj_RADTODEG , 1 , scale , fly + 150 + move , 0.45 , 0 , 75 , 255 , 255)
                            call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx" , x , y , a * bj_RADTODEG , 1 , scale * 0.7 , fly + 150 + move , 0.45 , 225 , 225 , 225 , 205)
                        
                            if scale < 51 then
                                set scale = scale + 0.4
                            endif
                            set k = k + 1
                        endloop
                        if r4 > 0.06 then
                            set scale2 = scale2 + 0.485
                            set e = EffectSpawnColor("war3mapimported\\wos_whitering.mdx", x, y, 0, 3.75, scale2, fly + 150 + move, 0, 75, 255, 255)
                            call AnimDummyEff(e, 0.15, 0.45)
                            call DestroyEffect(e)
                            set r4 = 0
                        else
                            set r4 = r4 + 0.03
                        endif
                    endif
                else
                    call ColorEffDummy3(e3, 0, 255, 255, 255, 0.06)
                    call SetUnitVertexColor(c, 255, 255, 255, 255)
                    call StopSpellUnit(c)
                    call StopSpellUnit2(td)
                    call StunUnit(c, td, StarrkR_StunDuration)
                    call SetUnitAnimation(c, "stand")
                    call SetFly(c, 0)
                    call SetFly(td, 0)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set e = null
                    set c = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set m_StarrkR3[i] = m_StarrkR3[ MUI_StarrkR3]
                    set MUI_StarrkR3 = MUI_StarrkR3 - 1
                    if MUI_StarrkR3 == -1 then
                        call PauseTimer( t_StarrkR3)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method StarrkR3_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_StarrkR3 = MUI_StarrkR3 + 1
            set m_StarrkR3[ MUI_StarrkR3] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set check = 0
            set k2 = 0
            set r5 = 0
            set g = CreateGroup()
            set g2 = CreateGroup()
            set aoe = StarrkR_DamageAoe
            set a = GAngle( c , td ) // Angle Between points
            set dmg = GetHeroAgi( c , true) * ( StarrkR_DamageAgiBase + ( StarrkR_DamageAgiStep * ( GetUnitAbilityLevel( c , StarrkR_ID) - 1 ) ) )
            set rmax = 6
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SetUnitVertexColor(c, 255, 255, 255, 0)
            call StartSpellUnit(c)
            call MakeSound("war3mapimported\\Hero_Starrk_W0")
            call MakeSound("war3mapimported\\Hero_Starrk_W1")
            call SetUnitTimeScale( c , 1)
            set fly = StarrkR_TargetHeight / 33
            set r4 = 2.01
            set scale = 1
            set scale2 = 0.25
            set move = 70
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("w skill"), 1)
            if MUI_StarrkR3 == 0 then
                call TimerStart( t_StarrkR3, 0.03, true, function thistype.Loop_StarrkR3)
            endif
        endmethod

        private static method Loop_StarrkR2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_StarrkR2
                set this = m_StarrkR2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set r = S2R( R2SW( r , 0, 3 ) )
                    //call MoveEff2(e, r3, a)
                    //call MoveEff2(e2, r4, a)
                    //set x = GetEffX(e)
                    //set y = GetEffY(e)
                    call MoveUnit2(d, r3, a)
                    call MoveUnit2(d2, r4, a)
                    //call MoveEff2(e2, r4, a)
                    //set x = GetEffX(e)
                    //set y = GetEffY(e)
                else
                   // set x = GetEffX(e)
                    //set y = GetEffY(e)
                    set x = GetUnitX(d)
                    set y = GetUnitY(d)
                    set r5 = GetRandomReal(4, 6)
                    if k2 == 1 and check == 0 then
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_by_wood_effect_qigongbo_lan.mdl", x, y, 0, GetRandomReal(1.5, 2.25), r5, GetUnitFlyHeight(d) + 40, 75, 155, 255, 255))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_acg_dajiqiquan4.mdx", x, y, 1, GetRandomReal(1.25, 2), 3.25, 1))
                    endif
                    set x = GetUnitX(d2)
                    set y = GetUnitY(d2)
                    
                   // set x = GetEffX(e2)
                   // set y = GetEffY(e2)
                    if k2 == 2 and check == 0 then
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_acg_dajiqiquan4.mdx", x, y, 1, GetRandomReal(1.25, 2), 3.25, 1))
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_by_wood_effect_qigongbo_lan.mdl", x, y, 0, GetRandomReal(1.5, 2.25), r5, GetUnitFlyHeight(d2) + 25, 75, 155, 255, 255))
                    endif
                    call RemoveUnit(d)
                    call RemoveUnit(d2)
                     /* call DestroyEffect(e)
                    call DestroyEffect(e2)
                    set e = null
                    set e2 = null */ 
                    set d = null
                    set d2 = null
                    set c = null
                    set m_StarrkR2[i] = m_StarrkR2[ MUI_StarrkR2]
                    set MUI_StarrkR2 = MUI_StarrkR2 - 1
                    if MUI_StarrkR2 == -1 then
                        call PauseTimer( t_StarrkR2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method StarrkR2_Start takes unit NewC, real NewX, real NewY, integer NewKK, integer NewKK2 returns nothing
            local thistype this = thistype.create( )
            set MUI_StarrkR2 = MUI_StarrkR2 + 1
            set m_StarrkR2[ MUI_StarrkR2] = this
            set c = NewC
            set r = 0
            set x = NewX
            set y = NewY
            set r2 = 0
            set a = GAngle2( c , x, y ) // Angle Between points
            set r4 = GetRandomReal(0, 450)
            set r5 = GetRandomReal(125, 225)
            set check = NewKK
            set k2 = GetRandomInt(1, 2)
            set d = UnitSpawn0(GetOwningPlayer(c), StarrkR_Dummy_ID, (GetUnitX(c) + r5 * Cos(a)) + r4 * Cos(a + 90 * bj_DEGTORAD), (GetUnitY(c) + r5 * Sin(a)) + r4 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG, 1, 1.2, GetRandomReal(110, 555))
           // call SetUnitVertexColor(d,25, 125, 255, 255)
            //set e = EffectSpawnColor("war3mapimported\\Gear_124saq2.mdx", (GetUnitX(c) + r5 * Cos(a)) + r4 * Cos(a + 90 * bj_DEGTORAD), (GetUnitY(c) + r5 * Sin(a)) + r4 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG, 1, 1.45, GetRandomReal(110, 555), 25, 125, 255, 255)
            if NewKK == 0 then
               // call DestroyEffect(EffectSpawn("war3mapimported\\wos_xtyball2.mdl", GetUnitX(d) - (r5 - 125) * Cos(a), GetUnitY(d) - (r5 - 125) * Sin(a), 0, 1.5, 0.4, GetUnitFlyHeight(d)))
                if NewKK2 == 1 then
                    call DestroyEffect(EffectSpawnColor3("war3mapimported\\wos_blue-shoot.mdx", GetUnitX(d) - (r5) * Cos(a), GetUnitY(d) - (r5) * Sin(a), a * bj_RADTODEG, 3, 1.35, GetUnitFlyHeight(d) - 79, 0, 0, 75, 255, 125))
                endif
            endif
            set r4 = GetRandomReal(0, 450)
            set r5 = GetRandomReal(125, 225)
            set d2 = UnitSpawn0(GetOwningPlayer(c), StarrkR_Dummy_ID, (GetUnitX(c) + r5 * Cos(a)) + r4 * Cos(a - 90 * bj_DEGTORAD), (GetUnitY(c) + r5 * Sin(a)) + r4 * Sin(a - 90 * bj_DEGTORAD), a * bj_RADTODEG, 1, 1.2, GetRandomReal(110, 555))
            //call SetUnitVertexColor(d2,25, 125, 255, 255)
            
           // set e2 = EffectSpawnColor("war3mapimported\\Gear_124saq2.mdx", (GetUnitX(c) + r5 * Cos(a)) + r4 * Cos(a - 90 * bj_DEGTORAD), (GetUnitY(c) + r5 * Sin(a)) + r4 * Sin(a - 90 * bj_DEGTORAD), a * bj_RADTODEG, 1, 1.45, GetRandomReal(110, 555), 25, 125, 255, 255)
            if NewKK == 0 then
             //   call DestroyEffect(EffectSpawn("war3mapimported\\wos_xtyball2.mdl", GetUnitX(d2) - (r5 - 125) * Cos(a), GetUnitY(d2) - (r5 - 125) * Sin(a), 0, 1.5, 0.4, GetUnitFlyHeight(d)))
                if NewKK2 == 1 then
                    call DestroyEffect(EffectSpawnColor3("war3mapimported\\wos_blue-shoot.mdx", GetUnitX(d2) - (r5) * Cos(a), GetUnitY(d2) - (r5) * Sin(a), a * bj_RADTODEG, 3, 1.35, GetUnitFlyHeight(d2) - 79, 0, 0, 75, 255, 125))
                endif
            endif
            //call MoveUnit(d,-250,a)
            //call MoveUnit(d2,-250,a)
            set r3 = GetRandomReal(200*1.23, 225*1.23)
            set r4 = GetRandomReal(200*1.23, 225*1.23)
            set rmax = 0.21
            if MUI_StarrkR2 == 0 then
                call TimerStart( t_StarrkR2, 0.03, true, function thistype.Loop_StarrkR2)
            endif
        endmethod

        private static method Loop_StarrkR takes nothing returns nothing
            local integer this
            local integer i = 0
            local real targetA = 0
            local real diff = 0
            local real ra1 = GetRandomReal(0, 365)
            local real dk = GetRandomReal(0.4, 0.85)
            loop
                exitwhen i > MUI_StarrkR
                set this = m_StarrkR[i]
                if SpellBoolCaster(c) and r < rmax and LoadInteger(hs, GetHandleId(c), StringHash("stop r")) == 0 then
                    set r = RoundReal(r + 0.03, 3)
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if r < 1.26 then
                     //   call DebugUnit(c)
                    else
                        call DebugUnit2(c)
                    endif
                    if r == 0.39 then
                        call SetUnitTimeScale(c, 0)
                    endif
                    if r == 0.03 then
                        call MakeSound("war3mapimported\\Hero_Starrk_R2")
                    endif
                    if r == StarrkR2_StunAppearTime + 1.32 and GetHeroLevel(c) >= 35 then
                        call MakeSound("war3mapimported\\Hero_Starrk_R3")
                        set k3 = 1
                    endif
                    if r > 0. and r < 0.15 then
                        if r2 > 0.03 then
                            set ra1 = GetRandomReal(0, 465)
                            set dk = GetRandomReal(0.3, 0.45)
                            set r2 = 0
                            call EffectSpawn2("war3mapimported\\wos_xtyball2.mdl", (GetUnitX(c) + 155 * Cos(a)) + ra1 * Cos(a + 90 * bj_DEGTORAD), (GetUnitY(c) + 155 * Sin(a)) + ra1 * Sin(a + 90 * bj_DEGTORAD), 0, 1.15, dk, GetRandomReal(40, 405), 0.3 - r)
                            call EffectSpawn2("war3mapimported\\wos_xtyball2.mdl", (GetUnitX(c) + 155 * Cos(a)) + ra1 * Cos(a - 90 * bj_DEGTORAD), (GetUnitY(c) + 155 * Sin(a)) + ra1 * Sin(a - 90 * bj_DEGTORAD), 0, 1.15, dk, GetRandomReal(40, 405), 0.3 - r)
                        else
                            set r2 = r2 + 0.02
                        endif
                    endif
                    if r == 0.03 then
                    //call UnitRemoveAbility(c,'Avul')
                    set r2 = 10
                        call SaveInteger(hs, GetHandleId(c), StringHash("cast r"), 1)
                        call MouseOn(GetOwningPlayer(c))
                        set MouseX[GetPlayerId(GetOwningPlayer(c))] = x
                        set MouseY[GetPlayerId(GetOwningPlayer(c))] = y
                    endif
                    if r > 0 then
                        set targetA = GAngle2(c, GetMouseX(GetOwningPlayer(c)), GetMouseY(GetOwningPlayer(c)))
                        set diff = targetA - a
                        if diff > bj_PI then
                            set diff = diff - 2 * bj_PI
                        elseif diff < - bj_PI then
                            set diff = diff + 2 * bj_PI
                        endif
// Clamp rotation speed to max per tick (0.087 rad = ~5 degrees)
                        if diff > 0.12 then
                            set diff = 0.087
                        elseif diff < - 0.087 then
                            set diff = -0.087
                        endif
                        set a = a + diff
                        call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
                        if r3 > 0.03 then
                            set r3 = 0
                            call StarrkR2_Start(c, GetUnitX(c) + 100 * Cos(a), GetUnitY(c) + 100 * Sin(a), check, k3)
                            call StarrkR2_Start(c, GetUnitX(c) + 100 * Cos(a), GetUnitY(c) + 100 * Sin(a), check, k3)
                            if r >= StarrkR2_StunAppearTime then
                              //  call StarrkR2_Start(c, GetUnitX(c) + 100 * Cos(a), GetUnitY(c) + 100 * Sin(a), check, k3)
                            endif
                            set check = check + 1
                            if check == 2 then
                                set check = 0
                            endif
                        else
                            set r3 = r3 + 0.02
                        endif
                        if r2 > 0.3 then
                            set r2 = 0
                            set k = 1
                            call VisionTimed(GetOwningPlayer(c), GetUnitX(c) + (700) * Cos(a) , GetUnitY(c) + (700 * k) * Sin(a), aoe * 1.6, 2)
                            call VisionTimed(GetOwningPlayer(c), GetUnitX(c) + (1400) * Cos(a) , GetUnitY(c) + (1400) * Sin(a), aoe * 1.6, 2)
                            call VisionTimed(GetOwningPlayer(c), GetUnitX(c) + (2100) * Cos(a) , GetUnitY(c) + (2100) * Sin(a), aoe * 1.6, 2)
                            call VisionTimed(GetOwningPlayer(c), GetUnitX(c) + (2600) * Cos(a) , GetUnitY(c) + (2600) * Sin(a), aoe * 1.6, 2)
                            call GroupClear( g2 )
                            set check2 = check2 + 1
                           // call BJDebugMsg(I2S(check2))
                            loop
                                exitwhen k == 8
                                call GroupClear( g )
                                call DecorRemove(c, GetUnitX(c) + (300 * k) * Cos(a) , GetUnitY(c) + (300 * k) * Sin(a) , aoe, 50)
                                call GroupEnumUnitsInRange( g , GetUnitX(c) + (300 * k) * Cos(a) , GetUnitY(c) + (300 * k) * Sin(a) , aoe , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup( u , g2 ) == false then
                                        call dmgmag(c, u, dmg)
                                        if r >= StarrkR2_StunAppearTime and GetHeroLevel(c) >= 35 then
                                            call StunUnit(c, u, StarrkR2_Stun)
                                        endif
                                        call MUE(u, 60, 0.3, a)
                                        call SlowUnit(c, u, StarrkR2_Slow, StarrkR2_SlowDuration)
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
                    endif
                else
                    call StopSpellUnit2(c)
                    call MouseOff(GetOwningPlayer(c))
                    call DestroyEffect(e)
                    call SaveInteger(hs, GetHandleId(c), StringHash("stop r"), 0)
                    call SaveInteger(hs, GetHandleId(c), StringHash("cast r"), 0)
                    call SaveInteger(hs, GetHandleId(c), StringHash("povorot"), 0)
                    if r < r7 then
                        call UnitRemoveAbility(c, 'Avul')
                    endif
                    call SetUnitTimeScale( c , 1)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set e = null
                    set c = null
                    set m_StarrkR[i] = m_StarrkR[ MUI_StarrkR]
                    set MUI_StarrkR = MUI_StarrkR - 1
                    if MUI_StarrkR == -1 then
                        call PauseTimer( t_StarrkR)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method StarrkR_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            local integer kkk = 0
            set MUI_StarrkR = MUI_StarrkR + 1
            set m_StarrkR[ MUI_StarrkR] = this
            set c = NewC
            set r = 0
            set x = NewX
            set y = NewY
            set check = 0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set g = CreateGroup()
            set k3 = 0
            set check2 = 0
            set r4 = 10
            set g2 = CreateGroup()
            set kkk = ( GetUnitAbilityLevel( c , StarrkR_ID) - 1 )
            if kkk > 2 then
            //    set kkk = 2
            endif
            set dmg = GetHeroAgi( c , true) * ( StarrkR2_DamageAgiBase + ( StarrkR2_DamageAgiStep * ( GetUnitAbilityLevel( c , StarrkR_ID) - 1 ) ) )
            //call BJDebugMsg(R2S(dmg))
            set dmg = dmg / 3
            //call BJDebugMsg(R2S(dmg))
            set r2 = 10
            set aoe = StarrkR2_DamageAoe
            call StartSpellUnit2(c)
            call SaveInteger(hs, GetHandleId(Player(k2)), StringHash("r start"), 1)
            set a = GAngle2( c , x, y ) // Angle Between points
            call MakeSound("war3mapimported\\Hero_Starrk_R1")
            call VisionTimed(GetOwningPlayer(c), GetUnitX(c), GetUnitY(c), 1800, 4)
            set rmax =   2.5
            set r7 = StarrkR2_InvulPerLvlAdd* ( GetUnitAbilityLevel( c , StarrkR_ID) - 1 )
            set check2 = 0
            set e = AddSpecialEffectTarget("war3mapimported\\wos_aurapartblue.mdx", c, "origin")
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG )
            call SetUnitTimeScale(c, 1)
            call SetUnitAnimationByIndex(c, 2)
            if MUI_StarrkR == 0 then
                call TimerStart( t_StarrkR, 0.03, true, function thistype.Loop_StarrkR)
            endif
        endmethod

    endstruct

    private struct StarrkSpells_T
        private static timer t_StarrkT2 = CreateTimer()
        private static integer array m_StarrkT2
        private static integer MUI_StarrkT2 = -1
        private static timer t_StarrkT = CreateTimer()
        private static integer array m_StarrkT
        private static integer MUI_StarrkT = -1
        private static timer t_StarrkT3 = CreateTimer()
        private static integer array m_StarrkT3
        private static integer MUI_StarrkT3 = -1
        unit d
        boolean b
        unit c
        unit td
        real x
        real y
        real x1
        real y1
        real x2
        framehandle array frame1_pas1 [10]
        framehandle array frame1_pas2 [10]
        framehandle array frame1_pas3 [10]
        framehandle array frame1_pas4 [10]
        framehandle array frame1_pas5 [10]
        framehandle array frame1_pas6 [10]
        real y2
        real r2
        integer k
        integer k2
        integer k3
        real r3
        real r4
        unit array dd[20]
        real r5
        real fly
        group g
        group g2
        group g3
        unit u
        real dmg
        real a2
        integer check
        integer check2
        real aoe
        real move
        real r
        effect e
        effect e2
        real sr
        real a
        real rmax

        private static method Loop_StarrkT2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_StarrkT2
                set this = m_StarrkT2[i]
                set b = SpellBoolCaster(c) and r <= rmax and SR2(d, td) > 110
                if check == 1 then
                    // TT/TR wolf was already launched: it must finish even if T is cancelled.
                    set b = r <= rmax and SR3(d, x, y) > 110
                    if check2 == 1 then
                        set b = r <= rmax
                    endif
                endif
                if b then
                    set r = RoundReal(r + 0.03, 3)
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if check == 0 then
                        set a = GAngle(d, td)
                    else
                        set a = GAngle2(d, x, y)
                    endif
                    call MoveUnit2(d, move, a)
                    set r3 = r3 + move
                    if check2 == 1 then
                        call SetFly(d, Parabola(fly, sr, r3))
                    endif
                    call BlzSetUnitFacingEx(d, a * bj_RADTODEG)
                    if r2 > 0.03 and check2 == 0 then
                        set r2 = 0
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", GetUnitX(d) + 100 * Cos(a), GetUnitY(d) + 100 * Sin(a), a * bj_RADTODEG, 0.75, 1.5, GetUnitFlyHeight(d) + 50))
                        call VisionTimed(GetOwningPlayer(c), GetUnitX(d), GetUnitY(d), 800, 2)
                    else
                        set r2 = r2 + 0.03
                    endif
                else
                    if SpellBoolCaster(c) or check == 1 then
                    set x = GetUnitX(d)
                    set y = GetUnitY(d)
                    if LoadInteger(hs, GetHandleId(c), StringHash("sond cd2")) == 0 then
                        call MakeSound("war3mapimported\\Hero_Starrk_TT3")
                        call SaveInteger(hs, GetHandleId(c), StringHash("sond cd2"), 1)
                        call MyFlush(GetHandleId(c), StringHash("sond cd2"), 0, 1.5)
                    endif
                    if check == 0 then
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue--zhendi31_3_x2.mdl", x, y, GetRandomReal(0, 359), 1, 1, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (431232).mdl", x, y, GetRandomReal(0, 359), 1.15, 2.35, 15))
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_by_wood_effect_order_dange_yueyun_2withoutblue2.mdl", x, y, GetRandomReal(0, 359), 1.25, 1.1, 1, 255, 255, 255, 255))
                    else
                        if check2 == 1 then
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (431232).mdl", x, y, GetRandomReal(0, 359), 1.15, 2.55, 15))
                        endif
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue--zhendi31_3_x2.mdl", x, y, GetRandomReal(0, 359), 1.5, 1, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_acg_dajiqiquan4.mdx", x, y, 1, GetRandomReal(1.75, 2.25), 2.65, 1))
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_by_wood_effect_order_dange_yueyun_2withoutblue2.mdl", x, y, GetRandomReal(0, 359), 1.35, 1.05, 1, 255, 255, 255, 255))
                    endif
                    call GroupClear(g)
                    call DecorRemove(c, x, y, aoe, 100)
                    call VisionTimed(GetOwningPlayer(c), x, y, aoe + 200, 4.5)
                    call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u, g3) == false then
                            call GroupAddUnit(g3, u)
                            call dmgmag(c, u, dmg)
                            call StunUnit(c, u, StarrkT_Stun)
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop
                    endif
                    // T3 transfers launched wolves out of the base T group.
                    if g2 != null then
                        call GroupRemoveUnit(g2, d)
                    endif
                    call ColorDummy3(d, 0, 255, 255, 255, 0.3)
                    call DestroyGroup(g)
                    set g = null
                    set d = null
                    set g2 = null
                    set g3 = null
                    set c = null
                    set m_StarrkT2[i] = m_StarrkT2[ MUI_StarrkT2]
                    set MUI_StarrkT2 = MUI_StarrkT2 - 1
                    if MUI_StarrkT2 == -1 then
                        call PauseTimer( t_StarrkT2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method StarrkT2_Start takes unit NewC, unit NewU, unit NewTd, group NewG, real NewX, real NewY, group NewG2, real NewDmgX, integer NewFly returns nothing
            local thistype this = thistype.create( )
            set MUI_StarrkT2 = MUI_StarrkT2 + 1
            set m_StarrkT2[ MUI_StarrkT2] = this
            set c = NewC
            set d = NewU
            set td = NewTd
            set r = 0
            if td == null then
                set check = 1
                set x = NewX
                set y = NewY
            else
                set check = 0
                set x = GetUnitX(td)
                set y = GetUnitY(td)
            endif
            set check2 = NewFly
            set r3 = 0
            set sr = SR3(d, x, y)
            set r2 = 0
            set g = CreateGroup()
            set g2 = NewG
            set g3 = NewG2
            set aoe = StarrkT_DamageAoe
            set a = GAngle2( d , x, y ) // Angle Between points
            if NewDmgX > 1 then
                if check2 == 0 then
                    set dmg = GetHeroAgi( c , true) * StarrkT_DamageAgiBase2 * NewDmgX
                else
                    set dmg = GetHeroAgi( c , true) * StarrkTR_DamageAgiBase * NewDmgX
                endif
            else
                set dmg = GetHeroAgi( c , true) * StarrkT_DamageAgiBase * NewDmgX
            endif
            set rmax = 2.39
            set move = GetRandomReal(85, 115)
            call PauseUnit(d, true)
            call BlzSetUnitFacingEx(d, GAngle(d, td) * bj_RADTODEG)
            if check2 == 1 then
                call SetUnitAnimationByIndex(d, 6)
                call SetUnitTimeScale(d, 1)
                set k = GetRandomInt(6, 12)
                set rmax = 0.21 + k * 0.03
                set move = sr / (11 + k)
                set fly = GetRandomReal(450, 800)
            else
                call SetUnitAnimationByIndex(d, 1)
                call SetUnitTimeScale(d, 2)
            endif
            if LoadInteger(hs, GetHandleId(c), StringHash("sond cd")) == 0 then
                call MakeSound("war3mapimported\\Hero_Starrk_TW2")
                call SaveInteger(hs, GetHandleId(c), StringHash("sond cd"), 1)
                call MyFlush(GetHandleId(c), StringHash("sond cd"), 0, 1.5)
            endif
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", GetUnitX(d) + 100 * Cos(a), GetUnitY(d) + 100 * Sin(a), a * bj_RADTODEG, 0.85, 1, 50))
            if MUI_StarrkT2 == 0 then
                call TimerStart( t_StarrkT2, 0.03, true, function thistype.Loop_StarrkT2)
            endif
        endmethod

        private static method Loop_StarrkT takes nothing returns nothing
            local integer this
            local integer i = 0
            local real wolfx = 0
            local real wolfy = 0
            local real kek1 = 0
            local real kek2 = 0
            loop
                exitwhen i > MUI_StarrkT
                set this = m_StarrkT[i]
                if SpellBoolCaster(c) and r <= rmax and LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e")) == 1 and LoadInteger(hs, GetHandleId(c), StringHash("t end")) == 0 then
                    // Do not advance ordinary T while Starrk is paused or casting TQ/TW.
                    if r >1.25 then 
                    if IsUnitPaused(c)==false and LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("wolf ult")) == 0 then
                        set r = r + 0.05
                    endif
                    else
                    if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("wolf ult")) == 0 then
                        set r = r + 0.05
                    endif
                    endif
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if r > 0 and r < 1.2 then
                        if r3 > 0.0 and check < 20 then
                            set r3 = 0
                            set x1 = x - 225 * Cos(a)
                            set y1 = y - 225 * Sin(a)
                            set x2 = x - 550 * Cos(a)
                            set y2 = y - 550 * Sin(a)
                            set wolfx = x1 + move * Cos(a + (90 - a2) * bj_DEGTORAD)
                            set wolfy = y1 + move * Sin(a + (90 - a2) * bj_DEGTORAD)
                            if PathableCheck(wolfx, wolfy) == false then
                                set wolfx = GetUnitX(c)
                                set wolfy = GetUnitY(c)
                            endif
                            if check < 20 then
                                set dd[check] = CreateUnit(GetOwningPlayer(c), StarrkWolf_ID, wolfx, wolfy, a * bj_RADTODEG)
                                call GroupAddUnit(g2, dd[check])
                                call SetUnitVertexColor(dd[check], 255, 255, 255, 0)
                                call ColorDummy4(dd[check], 0, 255, 255, 255, 0.45)
                                call AddSpecialEffectTarget("war3mapimported\\wos_by_wood_k_huoyantuowei3.mdx", dd[check], "chest")
                                call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_by_wood_k_baozha_2_blue.mdx", dd[check], "chest"))
                                set check = check + 1
                                set wolfx = x1 + move * Cos(a - (90 - a2) * bj_DEGTORAD)
                                set wolfy = y1 + move * Sin(a - (90 - a2) * bj_DEGTORAD)
                            endif
                            if PathableCheck(wolfx, wolfy) == false then
                                set wolfx = GetUnitX(c)
                                set wolfy = GetUnitY(c)
                            endif
                            if check < 20 then
                                set dd[check] = CreateUnit(GetOwningPlayer(c), StarrkWolf_ID, wolfx, wolfy, a * bj_RADTODEG)
                                call GroupAddUnit(g2, dd[check])
                                call SetUnitVertexColor(dd[check], 255, 255, 255, 0)
                                call ColorDummy4(dd[check], 0, 255, 255, 255, 0.45)
                                call AddSpecialEffectTarget("war3mapimported\\wos_by_wood_k_huoyantuowei3.mdx", dd[check], "chest")
                                call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_by_wood_k_baozha_2_blue.mdx", dd[check], "chest"))
                                set check = check + 1
                                set wolfx = x2 + move * Cos(a + (90 - a2) * bj_DEGTORAD)
                                set wolfy = y2 + move * Sin(a + (90 - a2) * bj_DEGTORAD)
                            endif
                            if PathableCheck(wolfx, wolfy) == false then
                                set wolfx = GetUnitX(c)
                                set wolfy = GetUnitY(c)
                            endif
                            if check < 20 then
                                set dd[check] = CreateUnit(GetOwningPlayer(c), StarrkWolf_ID, wolfx, wolfy, a * bj_RADTODEG)
                                call SetUnitVertexColor(dd[check], 255, 255, 255, 0)
                                call ColorDummy4(dd[check], 0, 255, 255, 255, 0.45)
                                call AddSpecialEffectTarget("war3mapimported\\wos_by_wood_k_huoyantuowei3.mdx", dd[check], "chest")
                                call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_by_wood_k_baozha_2_blue.mdx", dd[check], "chest"))
                                call GroupAddUnit(g2, dd[check])
                                set check = check + 1
                                set wolfx = x2 + move * Cos(a - (90 - a2) * bj_DEGTORAD)
                                set wolfy = y2 + move * Sin(a - (90 - a2) * bj_DEGTORAD)
                            endif
                            if PathableCheck(wolfx, wolfy) == false then
                                set wolfx = GetUnitX(c)
                                set wolfy = GetUnitY(c)
                            endif
                            if check < 20 then
                                set dd[check] = CreateUnit(GetOwningPlayer(c), StarrkWolf_ID, wolfx, wolfy, a * bj_RADTODEG)
                                call SetUnitVertexColor(dd[check], 255, 255, 255, 0)
                                call ColorDummy4(dd[check], 0, 255, 255, 255, 0.45)
                                call AddSpecialEffectTarget("war3mapimported\\wos_by_wood_k_huoyantuowei3.mdx", dd[check], "chest")
                                call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_by_wood_k_baozha_2_blue.mdx", dd[check], "chest"))
                                call GroupAddUnit(g2, dd[check])
                                set check = check + 1
                            endif
                            set move = move + 205
                            set a2 = a2 + 12
                        else
                            set r3 = r3 + 0.05
                        endif
                    endif
                    if GetUnitAbilityLevel(c, 'Abun') == 0 then
                        call UnitAddAbility(c, 'Abun')
                    endif
                    if r> 1.25 and FirstOfGroup(g2) == null then 
                    set r = 9999
                    endif
                    if r == 0.5 then
                   // call BJDebugMsg(I2S(check))
                   call SetPlayerAbilityAvailable(Player(check2), StarrkR3_ID, true)
                       call SetPlayerAbilityAvailable(Player(check2), StarrkT2_ID, true)
                        call SaveGroupHandle(hs, GetHandleId(c), StringHash("wolf group"), g2)
                        call StopSpellUnit(c)
                        set r4 = 10
                        set r5 = 0
                        set kek1 = 0.0375
                        if frame1_pas1[check2] == null then
                            set frame1_pas1[check2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                            call BlzFrameSetAbsPoint(frame1_pas1[check2], FRAMEPOINT_CENTER, 0.055, 0.18 + kek1)
                            call BlzFrameSetSize(frame1_pas1[check2], 0.135, 0.035)
                            call BlzFrameSetTexture(frame1_pas1[check2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                            call BlzFrameSetVisible(frame1_pas1[check2], false)
                            if GetLocalPlayer() == GetOwningPlayer(c) then
                                call BlzFrameSetVisible(frame1_pas1[check2], true)
                            endif
                            set frame1_pas2[check2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame1_pas1[check2], 0, 0)
                            call BlzFrameSetAbsPoint(frame1_pas2[check2], FRAMEPOINT_CENTER, 0.07, 0.185 + kek1)
                            call BlzFrameSetSize(frame1_pas2[check2], 0.1, 0.019)
                            set frame1_pas3[check2] = BlzCreateFrameByType("STATUSBAR", "", frame1_pas1[check2], "", 0)
                            call BlzFrameSetSize(frame1_pas3[check2], 0.1, 0.035)
                            call BlzFrameSetScale(frame1_pas3[check2], 0.5)
                            call BlzFrameSetModel(frame1_pas3[check2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                            call BlzFrameSetAbsPoint(frame1_pas3[check2], FRAMEPOINT_CENTER, 0.05, 0.175 + kek1)
                            call BlzFrameSetMinMaxValue(frame1_pas3[check2], 0, rmax + 2)
                            call BlzFrameSetValue(frame1_pas3[check2], rmax)
                            set frame1_pas4[check2] = BlzCreateFrameByType("BACKDROP", "SS", frame1_pas1[check2], "", 0)
                            call BlzFrameSetAbsPoint(frame1_pas4[check2], FRAMEPOINT_CENTER, 0.005, 0.18 + kek1)
                            call BlzFrameSetSize(frame1_pas4[check2], 0.03, 0.03)
                            call BlzFrameSetTexture(frame1_pas4[check2], "ReplaceableTextures\\CommandButtons\\BTNHero_Starrk_T", 0, false)
                            set frame1_pas5[check2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame1_pas1[check2], "", 0)
                            call BlzFrameSetAbsPoint(frame1_pas5[check2], FRAMEPOINT_CENTER, 0.07, 0.185 + kek1)
                            call BlzFrameSetText(frame1_pas5[check2], "|c00FFFF00" + "Wolfs Time Left:" + "|r")
                            call BlzFrameSetScale(frame1_pas5[check2], 0.9)
                            set frame1_pas6[check2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame1_pas1[check2], "", 0)
                            call BlzFrameSetAbsPoint(frame1_pas6[check2], FRAMEPOINT_CENTER, 0.07, 0.17 + kek1)
                            call BlzFrameSetText(frame1_pas6[check2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                            call BlzFrameSetScale(frame1_pas6[check2], 0.9)
                        else
                            if GetLocalPlayer() == GetOwningPlayer(c) then
                                call BlzFrameSetVisible(frame1_pas1[check2], true)
                            endif
                            call BlzFrameSetMinMaxValue(frame1_pas3[check2], 0, rmax + 2)
                            call BlzFrameSetValue(frame1_pas3[check2], rmax)
                        endif
                    endif
                    if r > 1.25 then
                        call BlzFrameSetValue(frame1_pas3[check2], rmax - (r + 0.1))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame1_pas6[check2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        if FirstOfGroup(g2) == null and LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("wolf ult")) == 0 then
                            set r = 99999
                        endif
                        if r4 > 0.19 and LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("wolf ult")) == 0 then
                            set r4 = 0
                            call SaveGroupHandle(hs, GetHandleId(c), StringHash("wolf group"), g2)
                            call GroupClear(g)
                            call GroupEnumUnitsOfPlayer(g, GetOwningPlayer(c), null)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitInGroup(u, g2) and IsUnitPaused(u) == false then
                                    set kek1 = GetRandomReal(0, 359) * bj_DEGTORAD
                                    set kek2 = GetRandomReal(275, 850)
                                    if GetUnitCurrentOrder(u) != OrderId("move") and LoadInteger(hs, GetHandleId(u), StringHash("stop move")) == 0 then
                                        call SaveInteger(hs, GetHandleId(u), StringHash("stop move"), 1)
                                        call MyFlush(GetHandleId(u), StringHash("stop move"), 0, 1.5)
                                        call SetUnitPathing(u, false)
                                        call IssuePointOrder(u, "move", GetUnitX(c) + kek2 * Cos(kek1), GetUnitY(c) + kek2 * Sin(kek1))
                                        set wolfx = GetUnitX(c) + kek2 * Cos(kek1)
                                        set wolfy = GetUnitY(c) + kek2 * Sin(kek1)
                                       
                                    endif
                                    if SR2(c, u) > 1600 then
                                        call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_by_wood_k_baozha_2_blue.mdx", u, "chest"))
                                        call SetUnitPosition(u, GetUnitX(c) + kek2 * Cos(kek1), GetUnitY(c) + kek2 * Sin(kek1))
                                    endif
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        else
                            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("wolf ult")) == 0 then
                                set r4 = r4 + 0.05
                            endif
                        endif
                        if r5 > 0.95 and LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("wolf ult")) == 0 then
                            set r5 = 0
                            set k3 = 0
                            set k2 = 0
                            set k = 0
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    set k = k + 1
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                            if k > 0 then
                                set k2 = GetRandomInt(1, k)
                                set k = 0
                                call GroupClear(g)
                                call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null or k3 > 0
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                        set k = k + 1
                                        if k == k2 then
                                            set k3 = 1
                                            set td = FirstOfGroup(g2)
                                            if IsUnitPaused(td) == false and td != null then
                                                call StarrkT2_Start(c, td, u, g2, 0, 0, null, 1, 0)
                                            endif
                                        endif
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                                set u = null
                            endif
                        else
                            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("wolf ult")) == 0 then
                                set r5 = r5 + 0.05
                            endif
                        endif
                    endif
                else
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame1_pas1[check2], false)
                    endif
                    if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e")) == 1 then
                        call SetPlayerAbilityAvailable(Player(check2), StarrkR2_ID, true)
                        call BlzSetAbilityIcon(StarrkQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Starrk_EQ.blp")
                        call BlzSetAbilityIcon(StarrkW_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Starrk_EW.blp")
                    endif
                    call UnitRemoveAbility(c, StarrkR3_ID)
                    call SetPlayerAbilityAvailable(Player(check2), StarrkT_ID, true)
                    call UnitRemoveAbility(c, StarrkT2_ID)
                    call UnitRemoveAbility(c, 'Abun')
                    call UnitRemoveAbility(c,StarrkF_ID)
                    set k = 0
loop
    exitwhen k >= check
    if dd[k] != null and GetUnitTypeId(dd[k]) == StarrkWolf_ID then
        call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_by_wood_k_baozha_2_blue.mdx", dd[k], "chest"))
        call ColorDummy3(dd[k], 0, 255, 255, 255, 0.5)
    endif
    set dd[k] = null
    set k = k + 1
endloop
                    if r < 1.25 then
                        call StopSpellUnit(c)
                    endif
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("wolf ult"), 0)
                    call SaveInteger(hs, GetHandleId(c), StringHash("stark t"), 0)
                    call AAUniversalTooltips_SetUnitForm(c, 0)
                    call SaveGroupHandle(hs, GetHandleId(c), StringHash("wolf group"), null)
                    call DestroyGroup(g)
                    set g = null
                    call DestroyGroup(g2)
                    set g2 = null
                    set td = null
                    set c = null
                    set e2 = null
                    set m_StarrkT[i] = m_StarrkT[ MUI_StarrkT]
                    set MUI_StarrkT = MUI_StarrkT - 1
                    if MUI_StarrkT == -1 then
                        call PauseTimer( t_StarrkT)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method StarrkT_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_StarrkT = MUI_StarrkT + 1
            set m_StarrkT[ MUI_StarrkT] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set check = 0
            set a2 = 0
            set r2 = 10
            set check2 = GetPlayerId(GetOwningPlayer(c))
            set move = 8
            set g = CreateGroup()
            set g2 = CreateGroup()
            set aoe = StarrkT_SearchAoe
            call SaveInteger(hs, GetHandleId(c), StringHash("stark t"), 1)
            call AAUniversalTooltips_SetUnitForm(c, 2)
            call SaveInteger(hs, GetHandleId(c), StringHash("t end"),0)
            call UnitAddAbility(c,StarrkF_ID)
            call BlzSetAbilityIcon(StarrkQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Starrk_TQ.blp")
            call BlzSetAbilityIcon(StarrkW_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Starrk_TW.blp")
            call SetPlayerAbilityAvailable(Player(check2), StarrkR2_ID, false)
            call UnitAddAbility(c, StarrkR3_ID)
            call SetPlayerAbilityAvailable(Player(check2), StarrkT_ID, false)
            call UnitAddAbility(c, StarrkT2_ID)
            call StartSpellUnit(c)
            set a = GetUnitFacing(c) * bj_DEGTORAD // Angle Between points
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            call MakeSound("war3mapimported\\Hero_Starrk_T")
            call MakeSound("war3mapimported\\Hero_Starrk_T2")
            call MakeSound("war3mapimported\\Hero_Starrk_T3")
            set dmg = GetHeroAgi( c , true) * StarrkT_DamageAgiBase
            set dmg = dmg / 12
            set rmax = StarrkT_Duration
            call VisionTimed(GetOwningPlayer(c), x, y, 1800, 5)
            if MUI_StarrkT == 0 then
                call TimerStart( t_StarrkT, 0.05, true, function thistype.Loop_StarrkT)
            endif
        endmethod

        private static method Loop_StarrkT3 takes nothing returns nothing
            local integer this
            local integer i = 0
            local real kek1 = 0
            local real kek2 = 0
            loop
                exitwhen i > MUI_StarrkT3
                set this = m_StarrkT3[i]
                // Keep the shared hit group alive for TT/TR wolves already in flight.
                if r <= rmax and (b or (SpellBoolCaster(c) and FirstOfGroup(g2) != null)) then
                    set r = r + 0.05
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if check == 0 then
                        if r == 0.05 then
                            call GroupClear(g)
                            call GroupEnumUnitsOfPlayer(g, GetOwningPlayer(c), null)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                // One T3 order may spend at most ten wolves.
                                if IsUnitInGroup(u, g2) and IsUnitPaused(u) == false and k < 10 then
                                    call SetUnitFacing(u, GAngle2(u, x, y) * bj_RADTODEG)
                                    // Do not freeze wolves while TT is being aimed/prepared.
                                    // StarrkT2_Start pauses each wolf only when its attack begins.
                                    call GroupAddUnit(g3, u)
                                    call AddSpecialEffectTarget("war3mapImported\\wos_Windwalk Blue Soul.mdl", u, "chest")
                                    set k = k + 1
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        endif
                        if r == 0.6 then
                            set k2 = 0
                            loop
                                exitwhen k2 >= k
                                set td = FirstOfGroup(g3)
                                if td != null then
                                    set kek1 = GetRandomReal(400, 850)
                                    set kek2 = GetRandomReal(0, 359) * bj_DEGTORAD
                                    call GroupRemoveUnit(g2, td)
                                    call StarrkT2_Start(c, td, null, null, x + kek1 * Cos(kek2), y + kek1 * Sin(kek2), g, k, 0)
                                    call GroupRemoveUnit(g3, td)
                                endif
                                set k2 = k2 + 1
                            endloop
                            set u = null
                            // Keep g alive while all ten wolves are still travelling.
                            // It is the shared hit group that allows each target only one hit.
                            set rmax = r+1.2 + StarrkT3_HitGroupDuration
                            set b = true
                            // Resume the normal T loop immediately: remaining wolves can
                            // move and perform their usual automatic attacks.
                            
                    call UnitAddAbility(c,StarrkF_ID)
                            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("wolf ult"), 0)
                            call SaveGroupHandle(hs, GetHandleId(c), StringHash("wolf group"), g2)
                        endif
                    elseif check == 1 then
                        if r == 0.65 then
                            call MakeSound("war3mapimported\\Hero_Starrk_TR")
                        endif
                        if r == 0.05 then
                            call GroupClear(g)
                            call GroupEnumUnitsOfPlayer(g, GetOwningPlayer(c), null)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                // One T3 order may spend at most ten wolves.
                                if IsUnitInGroup(u, g2) and IsUnitPaused(u) == false and k < 10 then
                                    // Do not freeze wolves while TR is being aimed/prepared.
                                    // StarrkT2_Start pauses each wolf only when its attack begins.
                                    call GroupAddUnit(g3, u)
                                    call AddSpecialEffectTarget("war3mapImported\\wos_Windwalk Blue Soul.mdl", u, "chest")
                                    set k = k + 1
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                            set k2 = 0
                            call GroupClear(g)
                            call GroupEnumUnitsOfPlayer(g, GetOwningPlayer(c), null)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitInGroup(u, g3)  then
                                    call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_by_wood_k_baozha_2_blue.mdx", u, "chest"))
                                    set kek2 = GetRandomReal( -25,5)
                                    call SetUnitPosition(u, x + (aoe + kek2) * Cos(360 / k * k2 * bj_DEGTORAD), y + (aoe + kek2) * Sin(360 / k * k2 * bj_DEGTORAD))
                                    call SetUnitFacing(u, 360 / k * k2)
                                    set k2 = k2 + 1
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        endif
                        if r == 1.2 then
                            call UnitRemoveAbility(c, 'Avul')
                            call PauseUnit(c, false)
                            set k2 = 0
                            loop
                                exitwhen k2 >= k
                                set td = FirstOfGroup(g3)
                                if td != null then
                                    set kek1 = GetRandomReal(650, 1000)
                                    set kek2 = GetUnitFacing(td) * bj_DEGTORAD//GetRandomReal(0, 359) * bj_DEGTORAD
                                    call GroupRemoveUnit(g2, td)
                                    call StarrkT2_Start(c, td, null, null, x + kek1 * Cos(GetUnitFacing(td) * bj_DEGTORAD), y + kek1 * Sin(GetUnitFacing(td) * bj_DEGTORAD), g, k, 1)
                                    call GroupRemoveUnit(g3, td)
                                endif
                                set k2 = k2 + 1
                            endloop
                            set u = null
                            call SaveGroupHandle(hs, GetHandleId(c), StringHash("wolf group"), g2)
                            call UnitAddAbility(c,StarrkF_ID)
                    
                            // Keep g alive while all ten wolves are still travelling.
                            // It is the shared hit group that allows each target only one hit.
                            set rmax = r+1.2 + StarrkT3_HitGroupDuration
                            set b = true
                            // Resume the normal T loop immediately: remaining wolves can
                            // move and perform their usual automatic attacks.
                            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("wolf ult"), 0)
                        endif
                    endif
                else
                    call DestroyGroup(g3)
                    call StopSpellUnit(c)
                    set g3 = null
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("wolf ult"), 0)
                    // T is still running: make both T3 orders available again.
                    if LoadInteger(hs, GetHandleId(c), StringHash("stark t")) == 1 then
                    //    call SetPlayerAbilityAvailable(Player(check2), StarrkR3_ID, true)
                   //     call SetPlayerAbilityAvailable(Player(check2), StarrkT2_ID, true)
                    endif
                    call DestroyGroup(g)
                    set g = null
                    set td = null
                    set c = null
                    set m_StarrkT3[i] = m_StarrkT3[ MUI_StarrkT3]
                    set MUI_StarrkT3 = MUI_StarrkT3 - 1
                    if MUI_StarrkT3 == -1 then
                        call PauseTimer( t_StarrkT3)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method StarrkT3_Start takes unit NewC, real NewX, real NewY, integer NewK returns nothing
            local thistype this = thistype.create( )
            set MUI_StarrkT3 = MUI_StarrkT3 + 1
            set m_StarrkT3[ MUI_StarrkT3] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set k = 0
            set check = NewK
            set aoe = 300
            set r = 0
            set b = false
            set g2 = LoadGroupHandle(hs, GetHandleId(c), StringHash("wolf group"))
            set g3 = CreateGroup()
            set g = CreateGroup()
                    call UnitRemoveAbility(c,StarrkF_ID)
            set a = GAngle2(c, x, y) // Angle Between points
            set check2 = GetPlayerId(GetOwningPlayer(c))
            // T remains active. Disable both T3 buttons only while this order runs.
            call SetPlayerAbilityAvailable(Player(check2), StarrkR3_ID, false)
            call SetPlayerAbilityAvailable(Player(check2), StarrkT2_ID, false)
            if check == 0 then
                call MakeSound("war3mapimported\\Hero_Starrk_TT2")
            else
               call StartSpellUnit(c)
            endif
            call MakeSound("war3mapimported\\Hero_Starrk_TT1")
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("wolf ult"), 1)
            set rmax = 8
            call VisionTimed(GetOwningPlayer(c), x, y, 1600, 3)
            if MUI_StarrkT3 == 0 then
                call TimerStart( t_StarrkT3, 0.05, true, function thistype.Loop_StarrkT3)
            endif
        endmethod

    endstruct

    //----------------------------Starrk-----------------------------------------------
     /* Animations index:
    Base:
    0 - move
    1 - stand
    2 - death
    3 - golova bolit
    4 - atk simple
    5 - atk pierce
    6 - smeh
    7 - ruki pered soboi
    
    Morph:
    1 - move
    2 - left hand strike
    3 - double strike 1.2 sec
    4 - perezaryadka
    5 - hand right strike
    6 - na 180 vistreal po obe storoni
    8 - prijok nazad
    9 - vistrel
    14 - sword atk
    
    wolf :
    1 - move
    6 - atk bite
     */ 
    function StarrkPas takes unit c returns nothing
        local group g = CreateGroup()
        local unit u = null
        local real x = GetUnitX(c)
        local real y = GetUnitY(c)
        local real aoe = 0
        local real scale = 0.85
        local integer lvl = GetHeroLevel(c)
        local real hp = GetUnitState(c, UNIT_STATE_MAX_LIFE) * 0.01
        local real mp = GetUnitState(c, UNIT_STATE_MAX_MANA) * 0.01
        local boolean b = false
        local integer check = 0
        if lvl >= 12 then
            if lvl >= 35 then
                set aoe = StarkG_Aoe35
                set scale = 1.25
            elseif lvl >= 25 then
                set aoe = StarkG_Aoe25
                set scale = 1.05
            else
                set aoe = StarkG_Aoe12
            endif
            call GroupEnumUnitsInRange(g, x, y, aoe, null)
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if IsUnitAlly(u, GetOwningPlayer(c)) and GetOwningPlayer(u)!= Player(PLAYER_NEUTRAL_PASSIVE) and u != c then
                    set check = check + 1
                endif
                call GroupRemoveUnit(g, u)
            endloop
            if check == 0 then
                set b = true
            endif
            if b == true then
                if GetUnitAbilityLevel(c, Starrk_Pas1ID) == 0 then
                    call UnitAddAbility(c, Starrk_Pas1ID)
                    call MyRemoveAbility(c, StarkG_TimeStatAdd , Starrk_Pas1ID, 1)
                elseif GetUnitAbilityLevel(c, Starrk_Pas2ID) == 0 then
                    call UnitAddAbility(c, Starrk_Pas2ID)
                    call MyRemoveAbility(c, StarkG_TimeStatAdd , Starrk_Pas2ID, 1)
                elseif GetUnitAbilityLevel(c, Starrk_Pas3ID) == 0 and lvl >= 25 then
                    call UnitAddAbility(c, Starrk_Pas3ID)
                    call MyRemoveAbility(c, StarkG_TimeStatAdd , Starrk_Pas3ID, 1)
                elseif GetUnitAbilityLevel(c, Starrk_Pas4ID) == 0 and lvl >= 25 then
                    call UnitAddAbility(c, Starrk_Pas4ID)
                    call MyRemoveAbility(c, StarkG_TimeStatAdd , Starrk_Pas4ID, 1)
                elseif GetUnitAbilityLevel(c, Starrk_Pas5ID) == 0 and lvl >= 35 then
                    call UnitAddAbility(c, Starrk_Pas5ID)
                    call MyRemoveAbility(c, StarkG_TimeStatAdd , Starrk_Pas5ID, 1)
                elseif GetUnitAbilityLevel(c, Starrk_Pas6ID) == 0 and lvl >= 35 then
                    call UnitAddAbility(c, Starrk_Pas6ID)
                    call MyRemoveAbility(c, StarkG_TimeStatAdd , Starrk_Pas6ID, 1)
                endif
                call SetHpCurrent2(c, c, hp*scale)
                call SetMpCurrent(c, mp*scale)
                call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_longskill_point_39.mdx", c, "origin"))
            endif
        endif
        call DestroyGroup(g)
        set u = null
        set g = null
    endfunction
    function StarrkQ_Start takes unit c, real x, real y returns nothing
        call StarrkSpells_Q.StarrkQ_Start( c, x, y )
    endfunction
    function StarrkW_Start takes unit c, unit td returns nothing
        call StarrkSpells_W.StarrkW_Start( c, td )
    endfunction
    function StarrkR_Start takes unit c, unit td returns nothing
        call StarrkSpells_R.StarrkR3_Start( c, td )
    endfunction
    function StarrkE_Attack_Start takes unit c , real x, real y returns nothing
        local real dmg = GetAttack(c)
        call StarrkSpells_Utility.StarrkPas2_Start( c, x, y, dmg )
        call SaveReal(hs, GetHandleId(c), StringHash("atk base dmg"), 0)
    endfunction
    function StarrkE2_Start takes unit c , real x, real y returns nothing
        local real sr
        local real max = StarrkE2_RangeBase + (StarrkE2_RangeStep * (GetUnitAbilityLevel(c, StarrkE_ID) - 1))
        local real a = GAngle2(c, x, y)
        if GetUnitAbilityLevel(c, StarrkE_ID) == 5 then
            set max = StarrkE2_RangeBase + (StarrkE2_RangeStep * (GetUnitAbilityLevel(c, StarrkE_ID) - 2))
        endif
        call MakeSound("war3mapimported\\Hero_Starrk_EE")
        if SR3(c, x, y) > max then
            set sr = max
        else
            set sr = SR3(c, x, y)
        endif
        set x = GetUnitX(c) + sr * Cos(a)
        set y = GetUnitY(c) + sr * Sin(a)
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx", GetUnitX(c), GetUnitY(c), GetUnitFacing(c), 1.5, 1.8, 0))
        call PosUnit(c, x, y)
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx", GetUnitX(c), GetUnitY(c), GetUnitFacing(c), 1.5, 1.8, 0))
    endfunction
    function StarrkE_Start takes unit c returns nothing
        if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e")) == 0 then
            call StarrkSpells_E.StarrkE_Start( c)
        else
            //call IssueImmediateOrder(c, "stop")
            call DisplayTimedTextToPlayer(GetOwningPlayer(c), 0, 0, 0.1, "|c00FF0303You already in morph , stop doing that|r")
        endif
    endfunction
    function StarrkR3_Start takes unit c returns nothing
        call StarrkSpells_T.StarrkT3_Start( c, GetUnitX(c), GetUnitY(c), 1 )
    endfunction
    function StarrkR2_Start takes unit c , real x, real y returns nothing
        call StarrkSpells_R.StarrkR_Start( c, x, y )
    endfunction
    function StarrkT_Start takes unit c returns nothing
        call StarrkSpells_T.StarrkT_Start( c)
    endfunction
    function StarrkF_Start takes unit c returns nothing
        call SaveInteger(hs, GetHandleId(c), StringHash("t end"),1)
    endfunction
    function StarrkT2_Start takes unit c , real x, real y returns nothing
        call StarrkSpells_T.StarrkT3_Start( c, x, y, 0 )
    endfunction
    
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
