library KenjakuSpells uses GearSystems
    globals
        integer Kenjaku_ID = 'H010'
        real Kenjaku_35lvlDamageIntCreepSpellAdd = 1
//---------------Q ability-----------------------------------------------------
        integer KenjakuQ_ID = 'A05I'
        real KenjakuQ_HealIntBase = 1 // base number x Int damage for 1 level
        real KenjakuQ_HealIntStep = 1 // additional number x Int damage for each next level
        real KenjakuQ_HealInt25lvlBonus = 1 // additional number x Int damage for each next level
        real KenjakuQ_HealStaticBase = 100 // base number x Int damage for 1 level
        real KenjakuQ_HealStaticStep = 0 // additional number x Int damage for each next level
        real KenjakuQ_Duration = 3 // additional number x Int damage for each next level
        real KenjakuQ_HealPeriodic = 0.25 // additional number x Int damage for each next level
        real KenjakuQ_ReduceQ3W3E3_CD = 5 // after usage reduce ongoin cd of active summunos spells by this time
        real KenjakuQ_Reduce25lvlBonusQ3W3E3_CD = 4 // after usage reduce ongoin cd of active summunos spells by this time
//---------------Q2 ability-----------------------------------------------------
        integer KenjakuQ2_ID = 'A05N'
        integer KenjakuQ2_CostCurse = 2
        integer KenjakuQ2_Dummy_ID = 'h012'
        real KenjakuQ2_CD_WhenOtherSpiritUse = 1
//---------------Q3 ability-----------------------------------------------------
        integer KenjakuQ3_ID = 'A05O'
        real KenjakuQ2_DamageIntBase = 1 // base number x Int damage for 1 level
        real KenjakuQ2_DamageIntStep = 1 // additional number x Int damage for each next level
        real KenjakuQ2_DamageStaticBase = 150 // base static damage for 1 level
        real KenjakuQ2_DamageStaticStep = 0 // additional static damage for each next level
        real KenjakuQ2_DamageAoe = 575
        integer KenjakuQ2_SummonHpBase = 400
        integer KenjakuQ2_SummonHpStep = 600 
        real KenjakuQ2_SummonMSBase = 440
        real KenjakuQ2_SummonMSStep = 20
        integer KenjakuQ2_SlowPercent = 40
        integer KenjakuQ2_SlowTime = 2
//---------------W ability-----------------------------------------------------
        integer KenjakuW_ID = 'A05J'
        unit array KenjakuW_Dummy[10]
        real KenjakuW_DamageIntBase = 1 // base number x Int damage for 1 level
        real KenjakuW_DamageIntStep = 1 // additional number x Int damage for each next level
        real KenjakuW_DamageStaticBase = 125 // base static damage for 1 level
        real KenjakuW_DamageStaticStep = 0 // additional static damage for each next level
        real KenjakuW_StunForPunch = 0.5 // additional static damage for each next level
//---------------W2 ability-----------------------------------------------------
        integer KenjakuW2_ID = 'A05P'
        integer KenjakuW2_Dummy_ID = 'h013'
        integer KenjakuW2_CostCurse = 2
        real KenjakuW2_CD_WhenOtherSpiritUse = 1
        integer KenjakuW2_SummonHpBase = 300
        integer KenjakuW2_SummonHpStep = 500 
        real KenjakuW2_SummonMSBase = 440
        real KenjakuW2_SummonMSStep = 0
//---------------W3 ability-----------------------------------------------------
        integer KenjakuW3_ID = 'A05Q'
        real KenjakuW2_DamageIntBase = 1 // base number x Int damage for 1 level
        real KenjakuW2_DamageIntStep = 0.75 // additional number x Int damage for each next level
        real KenjakuW2_DamageStaticBase = 100 // base static damage for 1 level
        real KenjakuW2_DamageStaticStep = 0 // additional static damage for each next level
        real KenjakuW2_DamageAoe = 300
        real KenjakuW2_Stun = 0.7
//---------------E ability-----------------------------------------------------
        integer KenjakuE_ID = 'A05K'
        real KenjakuE_DamageIntBase = 2 // base number x Int damage for 1 level
        real KenjakuE_DamageIntStep = 1 // additional number x Int damage for each next level
        real KenjakuE_Damage2StaticBase = 00 // base static damage for 1 level
        real KenjakuE_Damage2StaticStep = 0 // additional static damage for each next level
        real KenjakuE_DamageAoe = 600
        integer KenjakuE_SlowPercent = 40
        integer KenjakuE_SlowTime = 1
        real KenjakuE_DurationBase = 0.8
        real KenjakuE_DurationStep = 0 // add time per next level
//---------------E2 ability-----------------------------------------------------
        integer KenjakuE2_ID = 'A05R'
        integer KenjakuE3_ID = 'A05S'
        integer KenjakuE2_Dummy_ID = 'h014'
        integer KenjakuE2_CostCurse = 4
        integer KenjakuE2_SummonHpBase = 800
        integer KenjakuE2_SummonHpStep = 800 
        integer KenjakuE2_SlowPercent = 40
        integer KenjakuE2_SlowTime = 2
        real KenjakuE2_SummonMSBase = 522
        real KenjakuE2_SummonMSStep = 0
        real KenjakuE2_CD_WhenOtherSpiritUse = 2
        real KenjakuE2_DamageIntBase = 3 // base number x Int damage for 1 level
        real KenjakuE2_DamageIntStep = 1 // additional number x Int damage for each next level
        real KenjakuE2_Damage2StaticBase = 0 // base static damage for 1 level
        real KenjakuE2_Damage2StaticStep = 0 // additional static damage for each next level
//---------------R ability-----------------------------------------------------
        integer KenjakuR_ID = 'A05L'
        real KenjakuR_ColumnBase = 15
        real KenjakuR_ColumnStep = 3
        real KenjakuR_BarrierBase = 3
        real KenjakuR_BarrierStep = 0.5        
        real KenjakuR_AbilityCD = 40
//---------------R2 ability-----------------------------------------------------
        integer KenjakuR2_ID = 'A05T'
        real KenjakuR2_DamageIntBase = 4 // base number x Int damage for 1 level .dmg per sec
        real KenjakuR2_DamageIntStep = 1 // additional number x Int damage for each next level .dmg per sec
        real KenjakuR2_DamageIntBonusPerCurse = 0.1 // additional number x int for each next curse stack
        real KenjakuR2_DamageAoe = 310
        real KenjakuR2_Stun = 0.7
        real KenjakuR2_Stun2 = 1
//---------------T ability-----------------------------------------------------
        integer KenjakuT_ID = 'A05M'
        real KenjakuT_DamageIntBase = 10 //Int
        real KenjakuT_DamageAoe = 800
        integer KenjakuT_SlowPercent = 40
        integer KenjakuT_SlowTime = 1
//---------------F ability-----------------------------------------------------
        integer KenjakuF_ID = 'A05V'
        integer KenjakuF_Unit1_ID = 'h015'
        integer KenjakuF_Unit2_ID = 'h016'
        unit array KenjakuF_Unit1
        unit array KenjakuF_Unit2
        real KenjakuF_Hpregen = 8
        integer KenjakuF_BaseStacksAmount = 2
        integer KenjakuF_MaxStacksAmount1 = 4 // at 6 lvl
        integer KenjakuF_MaxStacksAmount2 = 8 // at 12
        integer KenjakuF_MaxStacksAmount3 = 12 // at 24 lvl
        integer KenjakuF_MaxStacksAmount4 = 16 // at 35 lvl
        real KenjakuF_StackTimeReplenish0 = 15 // 1 stack added after this time
        real KenjakuF_StackTimeReplenish1 = 12.5 // 1 stack added after this time
        real KenjakuF_StackTimeReplenish2 = 10 // 1 stack added after this time
        real KenjakuF_StackTimeReplenish3 = 7.5 // 1 stack added after this time
        real KenjakuF_StackTimeReplenish4 = 5 // 1 stack added after this time
        integer KenjakuF_BonusHpCreepAt35 = 3000 // at 35 lvl all creeps gain +1500 hp
//---------------F2 ability-----------------------------------------------------
        integer KenjakuF2_ID = 'A05W'
        integer KenjakuF2_Prison_Abi_ID = 'A05Y'
        real KenjakuF2_Aoe = 800
        real KenjakuF2_SealTime = 15
        real KenjakuF2_CastTime = 4
//---------------G ability-----------------------------------------------------
        integer KenjakuG_ID = 'A05U'
//--------------------------------------Kenjaku--------------------------------------------------------------
    endglobals

    function KenjakuPointInTriangle takes real px, real py, real ax, real ay, real bx, real by, real cx, real cy returns boolean
            local real v0x = cx - ax
            local real v0y = cy - ay
            local real v1x = bx - ax
            local real v1y = by - ay
            local real v2x = px - ax
            local real v2y = py - ay
            local real dot00 = v0x * v0x + v0y * v0y
            local real dot01 = v0x * v1x + v0y * v1y
            local real dot02 = v0x * v2x + v0y * v2y
            local real dot11 = v1x * v1x + v1y * v1y
            local real dot12 = v1x * v2x + v1y * v2y
            local real invDenom = 1.0 / (dot00 * dot11 - dot01 * dot01)
            local real u = (dot11 * dot02 - dot01 * dot12) * invDenom
            local real v = (dot00 * dot12 - dot01 * dot02) * invDenom
            return (u >= 0) and (v >= 0) and (u + v <= 1)
    endfunction
    function KenjakuPointInQuadSafe takes real px, real py, real x1, real y1, real x2, real y2, real x3, real y3, real x4, real y4, real cx, real cy returns boolean
            return KenjakuPointInTriangle(px, py, x1, y1, x2, y2, cx, cy) or KenjakuPointInTriangle(px, py, x2, y2, x3, y3, cx, cy) or KenjakuPointInTriangle(px, py, x3, y3, x4, y4, cx, cy) or KenjakuPointInTriangle(px, py, x4, y4, x1, y1, cx, cy)
    endfunction
    function KenjakuPushBack takes unit u, real ux, real uy, real x, real y returns nothing
            local real angle = Atan2(y - uy, x - ux)
            call SetUnitX(u, ux + 150 * Cos(angle))
            call SetUnitY(u, uy + 150 * Sin(angle))
    endfunction

    private struct KenjakuQ_KS
        private static timer t_KenjakuQ = CreateTimer( )
        private static integer array m_KenjakuQ
        private static integer MUI_KenjakuQ = -1
        unit c
        real r2
        real r3
        real r4
        real dmg
        real r
        effect e
        effect e2
        real rmax
        private static method Loop_KenjakuQ takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_KenjakuQ
                set this = m_KenjakuQ[i]
                if SpellBoolCaster(.c) and .r <= .rmax then
                    set .r = .r + 0.03
                    set .r = S2R( R2SW( .r , 0, 3 ) )
                    if .r2 >= .r3 then
                        set .r2 = 0
                        call SetHpCurrent2(c,c, dmg)
                    else
                        set .r2 = .r2 + 0.03
                    endif
                else
                    call DestroyEffect(.e)
                    call DestroyEffect(.e2)
                    set .c = null
                    set .e = null
                    set .e2 = null
                    set m_KenjakuQ[i] = m_KenjakuQ[ MUI_KenjakuQ]
                    set MUI_KenjakuQ = MUI_KenjakuQ - 1
                    if MUI_KenjakuQ == -1 then
                        call PauseTimer( t_KenjakuQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KenjakuQ_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_KenjakuQ = MUI_KenjakuQ + 1
            set m_KenjakuQ[ MUI_KenjakuQ] = this
            set .c = NewC
            set .r = 0
            set .r2 = 0
            set r4 = KenjakuQ_ReduceQ3W3E3_CD
            call MakeSound("war3mapimported\\Hero_Kenjaku_Q")
            call MakeSound("war3mapimported\\Hero_Kenjaku_Q2")
            set .dmg = KenjakuQ_HealStaticBase + (KenjakuQ_HealStaticStep * (GetUnitAbilityLevel(.c, KenjakuQ_ID) - 1))
            set .dmg = .dmg + GetHeroInt(.c, true) * (KenjakuQ_HealIntBase + (KenjakuQ_HealIntStep * (GetUnitAbilityLevel(.c, KenjakuQ_ID) - 1)))
            if GetHeroLevel(c)>= 25 then 
            set dmg = dmg + (KenjakuQ_HealInt25lvlBonus*GetHeroInt(c,true))
            set r4 = r4 + KenjakuQ_Reduce25lvlBonusQ3W3E3_CD
            endif
            call ReduceCooldown(c, KenjakuQ3_ID, r4)
            call ReduceCooldown(c, KenjakuW3_ID, r4)
            call ReduceCooldown(c, KenjakuE3_ID, r4)
            call ReduceCooldown(c, KenjakuQ2_ID, r4)
            call ReduceCooldown(c, KenjakuW2_ID, r4)
            call ReduceCooldown(c, KenjakuE2_ID, r4)
           set .rmax = KenjakuQ_Duration + 0.15
            set .r3 = KenjakuQ_HealPeriodic
            set .dmg = .dmg / (KenjakuQ_Duration / KenjakuQ_HealPeriodic)
            call SetUnitAnimationByIndex(.c, 9)
            set .e = AddSpecialEffectTarget("war3mapImported\\wos_obr08 (18).mdl", c, "origin")
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_glowlinered", c, "origin")
            if MUI_KenjakuQ == 0 then
                call TimerStart( t_KenjakuQ, 0.03, true, function thistype.Loop_KenjakuQ)
            endif
        endmethod
    endstruct

    private struct KenjakuQ2_KS
        private static timer t_KenjakuQ2 = CreateTimer( )
        private static integer array m_KenjakuQ2
        private static integer MUI_KenjakuQ2 = -1
        unit c
        unit d
        real x
        real y
        real r2
        integer k
        real r3
        group g
        unit u
        real dmg
        real aoe
        real move
        real r
        effect e
        real a
        real rmax
        private static method Loop_KenjakuQ2 takes nothing returns nothing
            local integer this
            local real rr5 = 0
            local integer i = 0
            loop
                exitwhen i > MUI_KenjakuQ2
                set this = m_KenjakuQ2[i]
                if SpellBoolCaster(d) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set r = RoundReal(r, 3)
                    if r < rmax - 0.21 then
                        set a = GAngle2(d, x, y) // Angle Between points
                        call SetUnitFacing(d, a * bj_RADTODEG)
                        if SR3(d, x, y) < 100 then
                            set r = rmax - 0.21
                        else    
                            if r3>0.0 then 
                            set r3 = 0                            
            call VisionTimed(GetOwningPlayer(c),GetUnitX(d),GetUnitY(d),aoe,1.5)
                            else
                            set r3 = r3 + 0.03
                            endif
                            if r2 >= 0.12 then
                                set r2 = 0
                                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(d), GetUnitY(d), a * bj_RADTODEG, 2, 1.85, 1, 255, 255, 255, 100))
                            else
                                set r2 = r2 + 0.03
                            endif
                            call MoveUnit(d, move, a)
                        endif
                    endif
                    if r == rmax - 0.21 then
                        call SetUnitAnimationByIndex( d , 4)
                    endif
                    if r == rmax then
                        set x = GetUnitX(d)
                        set y = GetUnitY(d)
            call VisionTimed(GetOwningPlayer(c),x,y,aoe*2,1.5)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdx", .x, .y, GetRandomReal(0, 359), 1, 3, 1))
                        set k = 0
                        loop
                            exitwhen k > 4
                            call EffectSpawn2("war3mapimported\\wos_LD2209 (157).mdx", x, y, GetRandomReal(0, 359), 1 - k * 0.2, 1 + k * 0.5, 0, 1.25)
                            call EffectSpawn2("war3mapimported\\wos_kamni.mdx", x, y, GetRandomReal(0, 359), 1.25 - k * 0.1, 0.7 + k * 0.35, 0, 0.35)
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_dustgaraa2.mdx", x, y, GetRandomReal(0, 359), 1.5 - k * 0.1, 1.9 + k * 0.42, 0))
                            set k = k + 1
                        endloop
                        call DecorRemove(c, x, y, aoe, 50)
                        call MakeSound("war3mapImported\\Hero_Kenjaku_Q2 3")
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                call dmgphys(c, u, dmg)
                                call SlowUnit(c, u, KenjakuQ2_SlowPercent, KenjakuQ2_SlowTime)
                                call SetUnitAnimation(u, "death")
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                else
                    call DestroyEffect(e)
                    call StopSpellUnit2(d)
                    call DestroyGroup(g)
                    set c = null
                    set d = null
                    set e = null
                    set g = null
                    set u = null
                    set m_KenjakuQ2[i] = m_KenjakuQ2[ MUI_KenjakuQ2]
                    set MUI_KenjakuQ2 = MUI_KenjakuQ2 - 1
                    if MUI_KenjakuQ2 == -1 then
                        call PauseTimer( t_KenjakuQ2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KenjakuQ2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_KenjakuQ2 = MUI_KenjakuQ2 + 1
            set m_KenjakuQ2[ MUI_KenjakuQ2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set g = CreateGroup()
            set u = null
            set r2 = 0
            set move = 65
            set a = GAngle2(c, x, y) // Angle Between points
            set dmg = GetHeroInt( c , true) * ( KenjakuQ2_DamageIntBase + ( KenjakuQ2_DamageIntStep * ( GetUnitAbilityLevel( c , KenjakuQ2_ID) - 1 ) ) )
            set dmg = dmg + KenjakuQ2_DamageStaticBase + ( KenjakuQ2_DamageStaticStep * ( GetUnitAbilityLevel( c , KenjakuQ2_ID) - 1 ) )
              set aoe = KenjakuQ2_DamageAoe
            if GetHeroLevel(c)>= 35 then 
            set dmg = dmg + Kenjaku_35lvlDamageIntCreepSpellAdd*GetHeroInt(c,true)
            set move = 85
            set aoe = aoe + 100
            endif
            set d = LoadUnitHandle(hs, GetHandleId(GetOwningPlayer(c)), StringHash("kenjaku unit q"))
            set rmax = 2.1
            call SetUnitFacing(d, a * bj_RADTODEG)
            call StartSpellUnit2(d)
            call MakeSound("war3mapImported\\Hero_Kenjaku_Q2 2")
            call SetUnitAnimationByIndex( d , 5)
            call SetUnitTimeScale(d, 1.35)
            if MUI_KenjakuQ2 == 0 then
                call TimerStart( t_KenjakuQ2, 0.03, true, function thistype.Loop_KenjakuQ2)
            endif
        endmethod
    endstruct

    private struct KenjakuW_KS
        private static timer t_KenjakuW = CreateTimer( )
        private static integer array m_KenjakuW
        private static integer MUI_KenjakuW = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k
        real dmg
        integer check
        real move
        real r
        real a
        real rmax
        private static method Loop_KenjakuW takes nothing returns nothing
            local integer this
            local real rr5 = 0
            local integer i = 0
            loop
                exitwhen i > MUI_KenjakuW
                set this = m_KenjakuW[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set r = RoundReal(r, 3)
                    set a = GAngle(c, td)
                    call SetUnitFacing(c, a * bj_RADTODEG)
                    if check == 0 then
                        call DebugUnit2(c)
                        if r == 0.12 then
                            call MakeSound("war3mapImported\\Hero_Kenjaku_W 0")
                        endif
                        if r == 0.24 then
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, 1, 255, 255, 255, 100))
                        endif
                        if r > 0.24 then
                            if SR2(c, td) > 120 then
                                call MoveUnit(c, move, a)
                                if r2 > 0.03 then
                                    set r2 = 0
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, 1, 255, 255, 255, 100))
                                else
                                    set r2 = r2 + 0.03
                                endif
                            else
                                set check = 1
                                set r = 0
                                call SetUnitAnimationByIndex( c , 5)
                            endif
                        endif
                    elseif check == 1 then
                        call DebugUnit2(c)
                        if r == 0.21 then
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            call MakeSound("war3mapImported\\Hero_Kenjaku_W 2")
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_hitheavy.mdl", x , y , a * bj_RADTODEG, 1, 2.25, 125))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BDEF (124)2.mdx", x, y, GetRandomReal(0, 359), 1, 2.5, 125))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_bbb.mdl", x, y, a * bj_RADTODEG , 1.5, 0.85, 125))
                            call EUTU2_3(EffectSpawn("war3mapimported\\wos_1daji_4.mdl", x, y, GetRandomReal(0, 359), 1, 3, 15), 1, 15, td)
                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", td, "chest"))
                            call dmgphys(c, td, dmg)                            
                                call StunUnit(c,td,KenjakuW_StunForPunch)
                            set rr5 = SR2(c, td)
                            call MUE(td, 255 - rr5, 0.15, a)
                        endif
                        if r == 0.42 then
                            set rr5 = SR2(c, td)
                            call MUE(c, rr5, 0.18, a)
                            call SetUnitAnimationByIndex( c , 3)
                        endif
                        if r == 0.6 then
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            call MakeSound("war3mapImported\\Hero_Kenjaku_W 3")
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_hitheavy.mdl", x , y , a * bj_RADTODEG, 1, 2.25, 125))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BDEF (124)2.mdx", x, y, GetRandomReal(0, 359), 1, 2.5, 125))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_bbb.mdl", x, y, a * bj_RADTODEG , 1.55, 0.85, 125))
                            call dmgphys(c, td, dmg)                            
                                call StunUnit(c,td,KenjakuW_StunForPunch)
                            call MUE(td, 245, 0.21, a)
                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", td, "chest"))
                        endif
                        if r == 0.81 then
                            call SetUnitAnimationByIndex( c , 10)
                        endif
                        if r > 1.02 then
                            if SR2(c, td) > 120 then
                                call MoveUnit(c, move, a)
                            else
                                set x = GetUnitX(td)
                                set y = GetUnitY(td)
                                set k = 0
                                loop
                                    exitwhen k > 4
                                    set rr5 = GetRandomReal(0, 359)
                                    call DestroyEffect(EffectSpawnColor3("war3mapimported\\wos_BY_Wood_Eff_Ord_DanGe_Wav_Kuosan_1_3_0_5s.mdx", x + 200 * Cos(a), y + 200 * Sin(a), rr5, GetRandomReal(0.5, 1), 0.4 + k * 0.065, 260 - k * 20, -15, 255, 255, 255, 90))
                                    set k = k + 1
                                endloop
                                call MakeSound("war3mapImported\\Hero_Kenjaku_W 4")
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlash.mdl" , x + 125 * Cos(a), y + 125 * Sin(a), 1, 1.5, 1.375, 125))
                                call EUTU2_3(EffectSpawn("war3mapImported\\wos_az_hitheavy.mdl", x , y , a * bj_RADTODEG, 0.8, 3.5, 95), 1.2, 95, td)
                                call EUTU2_3(EffectSpawn("war3mapImported\\wos_A_[spell]elementaleffectholy_W2.mdl", x, y, GetRandomReal(0, 359), 0.5, 6, 75), 1, 75, td)
                                call EUTU2_3(EffectSpawn("war3mapimported\\wos_1daji_4.mdl", x, y, GetRandomReal(0, 359), 1, 3, 15), 1, 15, td)
                                set r = 999999
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", td, "chest"))
                                call dmgphys(c, td, dmg)                                
                                call StunUnit(c,td,KenjakuW_StunForPunch)
                                call MUE(td, 225, 0.3, a)
                            endif
                        endif
                    endif
                else
                    call StopSpellUnit2(c)
                    if check > 0 then
                    endif
                    set c = null
                    set td = null
                    set m_KenjakuW[i] = m_KenjakuW[ MUI_KenjakuW]
                    set MUI_KenjakuW = MUI_KenjakuW - 1
                    if MUI_KenjakuW == -1 then
                        call PauseTimer( t_KenjakuW)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KenjakuW_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_KenjakuW = MUI_KenjakuW + 1
            set m_KenjakuW[ MUI_KenjakuW] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set check = 0
            set a = GAngle( c , td ) // Angle Between points
            set dmg = GetHeroInt( c , true) * ( KenjakuW_DamageIntBase + ( KenjakuW_DamageIntStep * ( GetUnitAbilityLevel( c , KenjakuW_ID) - 1 ) ) )
            set dmg = dmg + KenjakuW_DamageStaticBase + ( KenjakuW_DamageStaticStep * ( GetUnitAbilityLevel( c , KenjakuW_ID) - 1 ) )
            set dmg = dmg / 3
            set rmax = 2.8
            call SetUnitFacing(c, a * bj_RADTODEG)
            call StartSpellUnit2(c)
            call MakeSound("war3mapImported\\Hero_Kenjaku_W 1")
            call SetUnitAnimationByIndex( c , 4)
            set move = 65
            if MUI_KenjakuW == 0 then
                call TimerStart( t_KenjakuW, 0.03, true, function thistype.Loop_KenjakuW)
            endif
        endmethod
    endstruct

    private struct KenjakuW2_KS
        private static timer t_KenjakuW2 = CreateTimer( )
        private static integer array m_KenjakuW2
        private static integer MUI_KenjakuW2 = -1
        unit c
        unit d
        real x
        real y
        real scale
        group g
        unit u
        real dmg
        real aoe
        real r
        effect e
        real a
        real rmax
        private static method Loop_KenjakuW2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_KenjakuW2
                set this = m_KenjakuW2[i]
                if SpellBoolCaster(d) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set r = RoundReal(r, 3)
                    if r == rmax then
                        call MakeSound("war3mapImported\\Hero_Kenjaku_W2 3")
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_[tx]lvlup.mdl", x, y, 1, 0.5, 3*scale, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_1jinse_94.mdl", x, y, 1, 1, 3*scale, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_1jinse_93.mdl", x, y, 1, 1, 2*scale, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_1jinse_5.mdl", x, y, 1, 0.95, 3*scale, 1))
                        call DecorRemove(c, x, y, aoe, 40)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                call dmgmag(c, u, dmg)
                                call StunUnit(c, u, KenjakuW2_Stun)
                                call SetAnim(u, 0.03, "death")
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                else
                    call DestroyEffect(e)
                    call StopSpellUnit2(d)
                    call DestroyGroup(g)
                    set c = null
                    set d = null
                    set e = null
                    set g = null
                    set u = null
                    set m_KenjakuW2[i] = m_KenjakuW2[ MUI_KenjakuW2]
                    set MUI_KenjakuW2 = MUI_KenjakuW2 - 1
                    if MUI_KenjakuW2 == -1 then
                        call PauseTimer( t_KenjakuW2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KenjakuW2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_KenjakuW2 = MUI_KenjakuW2 + 1
            set m_KenjakuW2[ MUI_KenjakuW2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set g = CreateGroup()
            set u = null
            set a = GAngle2(c, x, y) // Angle Between points
            set dmg = GetHeroInt( c , true) * ( KenjakuW2_DamageIntBase + ( KenjakuW2_DamageIntStep * ( GetUnitAbilityLevel( c , KenjakuW2_ID) - 1 ) ) )
            set dmg = dmg + KenjakuW2_DamageStaticBase + ( KenjakuW2_DamageStaticStep * ( GetUnitAbilityLevel( c , KenjakuW2_ID) - 1 ) )
            set rmax = 0.81
            set aoe = KenjakuW2_DamageAoe
            set scale = aoe
            if GetHeroLevel(c)>= 35 then 
            set dmg = dmg + Kenjaku_35lvlDamageIntCreepSpellAdd*GetHeroInt(c,true)
            set rmax = 0.81
           // set aoe = aoe + 100
            endif
            set d = LoadUnitHandle(hs, GetHandleId(GetOwningPlayer(c)), StringHash("kenjaku unit w"))
            
            set scale = aoe/scale
            set a = GAngle2(c, x, y) // Angle Between points
            call SetUnitFacing(d, a * bj_RADTODEG)
            call StartSpellUnit2(d)
            call MakeSound("war3mapImported\\Hero_Kenjaku_W2 2")
            call SetUnitAnimationByIndex( d , 3)
            call VisionTimed(GetOwningPlayer(c),x,y,aoe*2,1.5)
            call SetUnitTimeScale(d, 0.95)
            call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_3x4_94.mdl", d, "hand left"))
            set e = EffectSpawnScale("war3mapImported\\wos_JY-[I0]Attack1.mdl", x, y, 1, 1, 0.01, 3, rmax - 0.12, 0.01, 0.45*scale)
            if MUI_KenjakuW2 == 0 then
                call TimerStart( t_KenjakuW2, 0.03, true, function thistype.Loop_KenjakuW2)
            endif
        endmethod
    endstruct

    private struct KenjakuE_KS
        private static timer t_KenjakuE = CreateTimer( )
        private static integer array m_KenjakuE
        private static integer MUI_KenjakuE = -1
        unit c
        real x
        real y
        real r2
        integer k
        group g
        unit u
        real dmg
        real aoe
        real r
        effect e
        real a
        real rmax
        private static method Loop_KenjakuE takes nothing returns nothing
            local integer this
            local real rr5 = 0
            local integer i = 0
            loop
                exitwhen i > MUI_KenjakuE
                set this = m_KenjakuE[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                     call DebugUnit(c)
                    set r = RoundReal(r, 3)
                    if r == 0.24 then
                        call MakeSound("war3mapImported\\Hero_Kenjaku_E 2")
                    endif
                    if r2 > 0.21 then
                        set r2 = 0
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        call DecorRemove(c, x, y, aoe, 40)
                        if GetLocalPlayer() == GetOwningPlayer(c) then
                            call CameraSetTargetNoise(15.0, 25.0)
                        endif
                        call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("cam swing"), 1)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_FantasyBattle (1644)2.mdx", u, "chest"))
                                call dmgmag(c, u, dmg)
                                call SlowUnit(c, u, KenjakuE_SlowPercent, KenjakuE_SlowTime)
                                call SetUnitAnimation(u, "death")
                                if GetLocalPlayer() == GetOwningPlayer(u) then
                                    call CameraSetTargetNoise(15.0, 25.0)
                                endif
                                call SaveInteger(hs, GetHandleId(GetOwningPlayer(u)), StringHash("cam swing"), 1)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        if r < rmax - 0.4 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_aurablack_r14.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 4.5, 1))
                        endif
                    else
                        set r2 = r2 + 0.03
                    endif
                else
                    call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) then
                               call UnitRemoveAbility(u,'Bslo')
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    set k = 0
                    loop
                        exitwhen k > 10
                        if LoadInteger(hs, GetHandleId(Player(k)), StringHash("cam swing")) == 1 then
                            if GetLocalPlayer() == Player(k) then
                                call CameraSetTargetNoise(0, 0)
                            endif
                            call SaveInteger(hs, GetHandleId(Player(k)), StringHash("cam swing"), 0)
                        endif
                        set k = k + 1
                    endloop
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.39)
                    call StopSpellUnit(c)
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set u = null
                    set m_KenjakuE[i] = m_KenjakuE[ MUI_KenjakuE]
                    set MUI_KenjakuE = MUI_KenjakuE - 1
                    if MUI_KenjakuE == -1 then
                        call PauseTimer( t_KenjakuE)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KenjakuE_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_KenjakuE = MUI_KenjakuE + 1
            set m_KenjakuE[ MUI_KenjakuE] = this
            set c = NewC
            set r = 0
            set g = CreateGroup()
            set u = null
            set r2 = 0
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set a = GetUnitFacing(c) * bj_DEGTORAD // Angle Between points
            set dmg = GetHeroInt( c , true) * ( KenjakuE_DamageIntBase + ( KenjakuE_DamageIntStep * ( GetUnitAbilityLevel( c , KenjakuE_ID) - 1 ) ) )
            set aoe = KenjakuE_DamageAoe
            set rmax = KenjakuE_DurationBase +0.27
            set dmg = dmg / (KenjakuE_DurationBase / 0.25)
            call SetUnitFacing(c, a * bj_RADTODEG)
            call StartSpellUnit(c)
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapImported\\Hero_Kenjaku_E")
            else
                call MakeSound("war3mapImported\\Hero_Kenjaku_E 3")
            endif
            call SetUnitAnimationByIndex( c , 2)
            call SetUnitTimeScale(c, 0.95)
            set e = EffectSpawnScale("war3mapImported\\wos_blackring.mdl", GetUnitX(c), GetUnitY(c), 1, 1, 0.01, 1, 0.24, 0.01, 3)
            if MUI_KenjakuE == 0 then
                call TimerStart( t_KenjakuE, 0.03, true, function thistype.Loop_KenjakuE)
            endif
        endmethod
    endstruct

    private struct KenjakuE2_KS
        private static timer t_KenjakuE2 = CreateTimer( )
        private static integer array m_KenjakuE2
        private static integer MUI_KenjakuE2 = -1
        unit c
        unit d
        real x
        real y
        real x1
        real y1
        real x2
        real y2
        real r2
        integer k3
        real r4
        real dmg
        integer check
        real r
        effect e
        real a
        real rmax
        private static method Loop_KenjakuE2 takes nothing returns nothing
            local integer this
            local real rr5 = 0
            local real rr6 = 0
            local integer i = 0
            loop
                exitwhen i > MUI_KenjakuE2
                set this = m_KenjakuE2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set r = RoundReal(r, 3)
                    if r == 0.45 then
                        call MakeSound("war3mapImported\\Hero_Kenjaku_E2 2")
                        call VisionTimed(GetOwningPlayer(c),x+ 300 * Cos(a), y + 300 * Sin(a), 450,3)
                        call VisionTimed(GetOwningPlayer(c),x+ 800 * Cos(a), y + 800 * Sin(a), 750,3)
                        call VisionTimed(GetOwningPlayer(c),x+ 1100 * Cos(a), y + 1100 * Sin(a), 855,3)
                    endif
                    if r2 >= 0.45 then
                        set r2 = 0
                        set rr5 = 1700+(110*k3)
                        set r4 = rr5/2350
                        set rr6 = 27.5
                        set x1 = GetUnitX(d) + rr5 * Cos(a + rr6 * bj_DEGTORAD)
                        set y1 = GetUnitY(d) + rr5 * Sin(a + rr6 * bj_DEGTORAD)
                        set x2 = GetUnitX(d) + rr5 * Cos(a - rr6 * bj_DEGTORAD)
                        set y2 = GetUnitY(d) + rr5 * Sin(a - rr6 * bj_DEGTORAD)
                        call EffectSpawn2("war3mapImported\\wos_hqn5_w.mdl", GetUnitX(d) + 250 * Cos(a), GetUnitY(d) + 250 * Sin(a), a * bj_RADTODEG, 1, 1.5*r4, 1, 0.42)
                        call DamageTriangle(c, GetUnitX(d)-75*Cos(a), GetUnitY(d)-75*Sin(a), x1, y1, x2, y2, dmg, 3)
                        call DecorRemove(c, x + 300 * Cos(a), y + 300 * Sin(a), 450, 40)
                        call DecorRemove(c, x + 700 * Cos(a), y + 700 * Sin(a), 450, 40)
                        call DecorRemove(c, x + 1100 * Cos(a), y + 1100 * Sin(a), 450, 40)
                        call DecorRemove(c, x + 1400 * Cos(a), y + 1400 * Sin(a), 450, 40)
                        call DecorRemove(c, x + 1700 * Cos(a), y + 1700 * Sin(a), 450, 40)
                    else
                        set r2 = r2 + 0.03
                    endif
                else
                    call DestroyEffect(e)
                    call StopSpellUnit(d)
                    set c = null
                    set d = null
                    set e = null
                    set m_KenjakuE2[i] = m_KenjakuE2[ MUI_KenjakuE2]
                    set MUI_KenjakuE2 = MUI_KenjakuE2 - 1
                    if MUI_KenjakuE2 == -1 then
                        call PauseTimer( t_KenjakuE2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KenjakuE2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_KenjakuE2 = MUI_KenjakuE2 + 1
            set m_KenjakuE2[ MUI_KenjakuE2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set check = GetPlayerId(GetOwningPlayer(c))
            set r2 = 0
            set k3 =  GetUnitAbilityLevel( c , KenjakuE2_ID) 
            set a = GAngle2(c, x, y) // Angle Between points
            set dmg = GetHeroInt( c , true) * ( KenjakuE2_DamageIntBase + ( KenjakuE2_DamageIntStep * ( GetUnitAbilityLevel( c , KenjakuE2_ID) - 1 ) ) )
            if GetHeroLevel(c)>= 35 then 
            set dmg = dmg + Kenjaku_35lvlDamageIntCreepSpellAdd*GetHeroInt(c,true)
            endif
            set d = LoadUnitHandle(hs, GetHandleId(GetOwningPlayer(c)), StringHash("kenjaku unit e"))
            set dmg = dmg / 3
            set rmax = 1.53
            call BlinkEff(d)
            call PosUnit(d, GetUnitX(Hero[check]) + 125 * Cos(a), GetUnitY(Hero[check]) + 125 * Sin(a))
            call SetUnitFacing(d, a * bj_RADTODEG)
            call StartSpellUnit(d)
            call MakeSound("war3mapImported\\Hero_Kenjaku_E2 3")
            call SetUnitAnimation(d, "spell channel")
            call SetUnitTimeScale(d, 0.95)
            if MUI_KenjakuE2 == 0 then
                call TimerStart( t_KenjakuE2, 0.03, true, function thistype.Loop_KenjakuE2)
            endif
        endmethod
    endstruct

    private struct KenjakuR_KS
        private static timer t_KenjakuR = CreateTimer( )
        private static integer array m_KenjakuR
        private static integer MUI_KenjakuR = -1
        unit c
        real x
        real y
        real x1
        real y1
        real x2
        real y2
        real x3
        real y3
        real x4
        real y4
        real r2
        integer k2
        group g
        group g2
        unit u
        integer check
        real r
        effect e
        effect e2
        effect e3
        effect e4
        effect e5
        lightning array ls [5]
        real a
        real rmax
        framehandle array frame0_pas1 [10]
        framehandle array frame0_pas2 [10]
        framehandle array frame0_pas3 [10]
        private static method Loop_KenjakuR takes nothing returns nothing
            local integer this
            local integer i = 0
            local real ux
            local real uy
            loop
                exitwhen i > MUI_KenjakuR
                set this = m_KenjakuR[i]
                if SpellBoolCaster(c) and (r <= rmax or (LoadInteger(hs, GetHandleId(c), StringHash("activate r")) == 1 and check != 4)) then
                    set r = RoundReal(r + 0.03, 3)
                    set r = RoundReal(r, 3)
                    call BlzFrameSetValue(frame0_pas3[k2], r)
                    if (LoadInteger(hs, GetHandleId(c), StringHash("activate r")) == 1 and check != 4) then
                        set r = 9999
                    endif
                    if check == 4 then
                    if r2>0.45 then 
                    set r2 = 0
                      call OkarunEggCd(c,KenjakuR_ID,KenjakuR_AbilityCD)           
                    else
                    set r2 = r2 + 0.03
                    endif
                    call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, 10000, NoDecor_Cond) // РС‰РµРј РІСЃРµС… РІРѕРєСЂСѓРі
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitInGroup(u, g2) == false then
                                set ux = GetUnitX(u)
                                set uy = GetUnitY(u)
                                if IsUnitInGroup(u, g2) == false then
                                    if KenjakuPointInQuadSafe(ux, uy, x1, y1, x2, y2, x3, y3, x4, y4, x, y) then
                                        call GroupAddUnit(g2, u)
                                    endif
                                endif
                            endif
                            if SpellBool(u) and IsUnitInGroup(u, g2) == true then
                                set ux = GetUnitX(u)
                                set uy = GetUnitY(u)
                                if not KenjakuPointInQuadSafe(ux, uy, x1, y1, x2, y2, x3, y3, x4, y4, x, y) then
                                    call KenjakuPushBack(u, ux, uy, x, y)
                                endif
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                else
                    if LoadInteger(hs, GetHandleId(c), StringHash("activate r")) == 0 then
                        call DestroyEffect(e)
                        if check == 1 then
                            call RemoveSavedHandle(hs, GetHandleId(c), StringHash("barrier 1"))
                            call SaveEffectHandle(hs, GetHandleId(c), StringHash("barrier 1"), null)
                        elseif check == 2 then
                            call RemoveSavedHandle(hs, GetHandleId(c), StringHash("barrier 2"))
                            call SaveEffectHandle(hs, GetHandleId(c), StringHash("barrier 2"), null)
                        elseif check == 3 then
                            call RemoveSavedHandle(hs, GetHandleId(c), StringHash("barrier 3"))
                            call SaveEffectHandle(hs, GetHandleId(c), StringHash("barrier 3"), null)
                        elseif check == 4 then
                            call RemoveSavedHandle(hs, GetHandleId(c), StringHash("barrier 4"))
                            call SaveEffectHandle(hs, GetHandleId(c), StringHash("barrier 4"), null)
                        endif
                    endif
                    if GetLocalPlayer() == Player(k2) then 
                    call BlzFrameSetVisible(frame0_pas1[k2],false)
                    endif
                    call ColorEffDummy3(e5, 0, 255, 255, 255, 0.2)
                    if LoadInteger(hs, GetHandleId(c), StringHash("activate r")) == 1 and check == 4 then
                        call DestroyLightning(ls[0])
                        call DestroyLightning(ls[1])
                        call DestroyLightning(ls[2])
                        call DestroyLightning(ls[3])
                        set ls[0] = null
                        set ls[1] = null
                        set ls[2] = null
                        set ls[3] = null
                        call DestroyEffect(e)
                        call DestroyEffect(e2)
                        call DestroyEffect(e3)
                        call DestroyEffect(e4)
                        call RemoveSavedHandle(hs, GetHandleId(c), StringHash("barrier 1"))
                        call RemoveSavedHandle(hs, GetHandleId(c), StringHash("barrier 2"))
                        call RemoveSavedHandle(hs, GetHandleId(c), StringHash("barrier 3"))
                        call RemoveSavedHandle(hs, GetHandleId(c), StringHash("barrier 4"))
                        call SaveEffectHandle(hs, GetHandleId(c), StringHash("barrier 1"), null)
                        call SaveEffectHandle(hs, GetHandleId(c), StringHash("barrier 2"), null)
                        call SaveEffectHandle(hs, GetHandleId(c), StringHash("barrier 3"), null)
                        call SaveEffectHandle(hs, GetHandleId(c), StringHash("barrier 4"), null)
                        call SaveInteger(hs, GetHandleId(c), StringHash("activate r"), 0)
                        call DestroyGroup(g2)
                        set g2 = null
                        call DestroyGroup(g)
                        set g = null
                    endif
                    set frame0_pas1[k2] = null
                    set frame0_pas2[k2] = null
                    set frame0_pas3[k2] = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set e5 = null
                    set c = null
                    set u = null
                    set m_KenjakuR[i] = m_KenjakuR[ MUI_KenjakuR]
                    set MUI_KenjakuR = MUI_KenjakuR - 1
                    if MUI_KenjakuR == -1 then
                        call PauseTimer( t_KenjakuR)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KenjakuR_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            local real array px
            local real array py
            local real array ang
            local integer si
            local integer sj
            local real tmp_ang
            local real tmp_x
            local real tmp_y
            set MUI_KenjakuR = MUI_KenjakuR + 1
            set m_KenjakuR[ MUI_KenjakuR] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set check = 0
            set r2 = 10
            set a = GetUnitFacing(c) * bj_DEGTORAD // Angle Between points
            set rmax = KenjakuR_ColumnBase + (KenjakuR_ColumnStep * (GetUnitAbilityLevel(c, KenjakuR_ID) - 1))
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SetUnitAnimationByIndex( c , 6)
            if LoadEffectHandle(hs, GetHandleId(c), StringHash("barrier 1")) == null then
                set e = EffectSpawn("war3mapImported\\wos_kenj_r.mdl", x, y, 1, 2, 1.5, 1)
                call SaveEffectHandle(hs, GetHandleId(c), StringHash("barrier 1"), e)
                set check = 1
                set e5 = EffectSpawn("war3mapImported\\wos_pink circl.mdl", x, y, 1, 2, 1.5, 1)
            elseif LoadEffectHandle(hs, GetHandleId(c), StringHash("barrier 2")) == null then
                set e = EffectSpawn("war3mapImported\\wos_kenj_r.mdl", x, y, 1, 2, 1.5, 1)
                set check = 2
                set e5 = EffectSpawn("war3mapImported\\wos_pink circl.mdl", x, y, 1, 2, 1.5, 1)
                call SaveEffectHandle(hs, GetHandleId(c), StringHash("barrier 2"), e)
            elseif LoadEffectHandle(hs, GetHandleId(c), StringHash("barrier 3")) == null then
                set e = EffectSpawn("war3mapImported\\wos_kenj_r.mdl", x, y, 1, 2, 1.5, 1)
                set check = 3
                set e5 = EffectSpawn("war3mapImported\\wos_pink circl.mdl", x, y, 1, 2, 1.5, 1)
                call SaveEffectHandle(hs, GetHandleId(c), StringHash("barrier 3"), e)
            elseif LoadEffectHandle(hs, GetHandleId(c), StringHash("barrier 4")) == null then
                set e = EffectSpawn("war3mapImported\\wos_kenj_r.mdl", x, y, 1, 2, 1.5, 1)
                set check = 4
                set e5 = EffectSpawn("war3mapImported\\wos_pink circl.mdl", x, y, 1, 2, 1.5, 1)
                call SaveEffectHandle(hs, GetHandleId(c), StringHash("barrier 4"), e)
            endif
            if check != 4 then
                set tmp_x = 0.26875 + check * 0.0225
                set tmp_y = 0.17
                if frame0_pas1[k2] == null then 
                set frame0_pas1[k2] = BlzCreateFrameByType("SIMPLEFRAME", "2Face", main_frame, "", 0)
                call BlzFrameClearAllPoints(frame0_pas1[k2])
                    call BlzFrameSetVisible(frame0_pas1[k2],false)
                if GetLocalPlayer() == Player(k2) then 
                    call BlzFrameSetVisible(frame0_pas1[k2],true)
                    endif
                set frame0_pas2[k2] = BlzCreateFrameByType("SIMPLESTATUSBAR", "2FaceBackGround", frame0_pas1[k2], "", 0)
                set frame0_pas3[k2] = BlzCreateFrameByType("SIMPLESTATUSBAR", "2FaceForeGround", frame0_pas2[k2], "", 0)
                call BlzFrameClearAllPoints(frame0_pas2[k2])
                call BlzFrameClearAllPoints(frame0_pas3[k2])
                call BlzFrameSetAllPoints(frame0_pas2[k2], frame0_pas1[k2])
                call BlzFrameSetAllPoints(frame0_pas3[k2], frame0_pas1[k2])
                call BlzFrameSetSize(frame0_pas1[k2], 0.0225, 0.0225)
                else
                 if GetLocalPlayer() == Player(k2) then 
                    call BlzFrameSetVisible(frame0_pas1[k2],false)
                    endif
                endif
                call BlzFrameSetMinMaxValue(frame0_pas3[k2], 0, rmax)
                call BlzFrameSetValue(frame0_pas2[k2], 100)
                call BlzFrameSetTexture(frame0_pas2[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Kenjaku_R.blp", 0, false)
                if check == 1 then
                    call BlzFrameSetTexture(frame0_pas3[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Stack1.blp", 0, false)
                elseif check == 2 then
                    call BlzFrameSetTexture(frame0_pas3[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Stack2.blp", 0, false)
                elseif check == 3 then
                    call BlzFrameSetTexture(frame0_pas3[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Stack3.blp", 0, false)
                endif
                call BlzFrameSetAbsPoint(frame0_pas1[k2], FRAMEPOINT_CENTER, tmp_x, tmp_y)
            endif            
            if check == 4 then
                set rmax = KenjakuR_BarrierBase + (KenjakuR_BarrierStep * (GetUnitAbilityLevel(c, KenjakuR_ID) - 1))
                set g = CreateGroup()
                set g2 = CreateGroup()
                set u = null
                set e = LoadEffectHandle(hs, GetHandleId(c), StringHash("barrier 1"))
                set e2 = LoadEffectHandle(hs, GetHandleId(c), StringHash("barrier 2"))
                set e3 = LoadEffectHandle(hs, GetHandleId(c), StringHash("barrier 3"))
                set e4 = LoadEffectHandle(hs, GetHandleId(c), StringHash("barrier 4"))
                set x1 = GetEffX(e)
                set y1 = GetEffY(e)
                set x2 = GetEffX(e2)
                set y2 = GetEffY(e2)
                set x3 = GetEffX(e3)
                set y3 = GetEffY(e3)
                set x4 = GetEffX(e4)
                set y4 = GetEffY(e4)
                set x = (x1 + x2 + x3 + x4) * 0.25
                set y = (y1 + y2 + y3 + y4) * 0.25
                set px[0] = x1
                set py[0] = y1
                set px[1] = x2
                set py[1] = y2
                set px[2] = x3
                set py[2] = y3
                set px[3] = x4
                set py[3] = y4
                set si = 0
                loop
                    exitwhen si > 3
                    set ang[si] = Atan2(py[si] - y, px[si] - x)
                    if ang[si] < 0 then
                        set ang[si] = ang[si] + 2.0 * bj_PI
                    endif
                    set si = si + 1
                endloop
                set si = 0
                loop
                    exitwhen si > 2
                    set sj = si + 1
                    loop
                        exitwhen sj > 3
                        if ang[si] > ang[sj] then
                            set tmp_ang = ang[si]
                            set ang[si] = ang[sj]
                            set ang[sj] = tmp_ang
                            set tmp_x = px[si]
                            set px[si] = px[sj]
                            set px[sj] = tmp_x
                            set tmp_y = py[si]
                            set py[si] = py[sj]
                            set py[sj] = tmp_y
                        endif
                        set sj = sj + 1
                    endloop
                    set si = si + 1
                endloop
                set x1 = px[0]
                set y1 = py[0]
                set x2 = px[1]
                set y2 = py[1]
                set x3 = px[2]
                set y3 = py[2]
                set x4 = px[3]
                set y4 = py[3]
                call SaveInteger(hs, GetHandleId(c), StringHash("activate r"), 1)
                set ls[0] = AddLightningEx("AAKN", false, x1, y1, BlzGetLocalSpecialEffectZ(e) + 75, x2, y2, BlzGetLocalSpecialEffectZ(e2) + 75)
                set ls[1] = AddLightningEx("AAKN", false, x2, y2, BlzGetLocalSpecialEffectZ(e2) + 75, x3, y3, BlzGetLocalSpecialEffectZ(e3) + 75)
                set ls[2] = AddLightningEx("AAKN", false, x3, y3, BlzGetLocalSpecialEffectZ(e3) + 75, x4, y4, BlzGetLocalSpecialEffectZ(e4) + 75)
                set ls[3] = AddLightningEx("AAKN", false, x4, y4, BlzGetLocalSpecialEffectZ(e4) + 75, x1, y1, BlzGetLocalSpecialEffectZ(e) + 75)
                call MakeSound("war3mapImported\\Hero_Kenjaku_R")
            endif
            call MakeSound("war3mapImported\\Hero_Kenjaku_R 2")
            if MUI_KenjakuR == 0 then
                call TimerStart( t_KenjakuR, 0.03, true, function thistype.Loop_KenjakuR)
            endif
        endmethod
    endstruct

    private struct KenjakuR2_KS
        private static timer t_KenjakuR2 = CreateTimer( )
        private static integer array m_KenjakuR2
        private static integer MUI_KenjakuR2 = -1
        unit c
        real x
        real y
        integer k2
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
        real a
        real rmax
        private static method Loop_KenjakuR2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_KenjakuR2
                set this = m_KenjakuR2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit(c)
                    set r = RoundReal(r, 3)
                    if r == 0.3 then
                        if check < 6 then
                            set e = EffectSpawn("war3mapImported\\wos_YGNZ_BY_Wood_NEF_Odr_KOF_Igniz_BaiLuoMieJing.mdl", GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), a * bj_RADTODEG, 1, 0.6, 125)
                        else
                            call EffectSpawn2("war3mapImported\\wos_[dttx] (21).mdl", GetUnitX(c), GetUnitY(c), 1, 0.55, 3, 1, r5 + 0.6 - r5)
                            set e = EffectSpawnScale("war3mapImported\\wos_YGNZ_BY_Wood_NEF_Odr_KOF_Igniz_BaiLuoMieJing.mdl", GetUnitX(c) + 25 * Cos(a), GetUnitY(c) + 25 * Sin(a), a * bj_RADTODEG, 1, 0.1, 205, 0.57, 0.1, 3.15)
                        endif
                    endif
                    if r == 0.9 and check >= 6 then
                        call MakeSound("war3mapImported\\Hero_Kenjaku_R2 2")
                    endif
                    if r == 0.9 and check >= 6 then
                        call ScaleEffDummy(e, 0.24, 4, 0.01)
                    endif
                    if r == 1.2 and check >= 6 then
                        call SetUnitAnimationByIndex(c, 6)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Effect_Void_DaiTu_ShenWei_FangChu.mdl", GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), a * bj_RADTODEG, 0.35, 2, 125))
                    endif
                    if r == r5 then
                        call MakeSound("war3mapImported\\Hero_Kenjaku_R2 3")
                        call BlzSetSpecialEffectPosition(e, GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), 100)
                        call DestroyEffect(e)
                        set x = GetUnitX(c) + 150 * Cos(a)
                        set y = GetUnitY(c) + 150 * Sin(a)
                        set move = 200
                        
                        if check >= 6 then
                            set move = 300
                            call MakeSound("war3mapImported\\Hero_Kenjaku_R2 5")
                            call MyRemoveEff(EffectSpawn3("war3mapImported\\wos_tx-redslashginblack.mdl", GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), a * bj_RADTODEG - 180, 1, 1.4, 125, -90), 1)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_effect_az_laser3.mdl", GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), a * bj_RADTODEG, 1, 1.25, 125))
                        else
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_effect_az_laser3.mdl", GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), a * bj_RADTODEG, 1, 0.9, 125))
                        endif
                    endif
                    if r > r5 then
                        call DecorRemove(c, x, y, aoe, 100)    
                        call VisionTimed(GetOwningPlayer(c),x,y,450,1)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_FantasyBattle (1644)2.mdx", x, y, 1, 0.5, 3, 135))
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u, g2) == false then
                                call dmgmag(c, u, dmg)
                                call GroupAddUnit(g2, u)
                                set check2 = check2 + 1
                                if check >= 6 then
                                    call StunUnit(c, u, KenjakuR2_Stun2)
                                else
                                    call StunUnit(c, u, KenjakuR2_Stun)
                                endif
                                call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_FantasyBattle (1644)2.mdx", u, "chest"))
                                call SetAnim(u, 0.03, "death")
                            endif
                            call GroupRemoveUnit(g, u)
                       endloop
                        if check >= 6 then
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", x, y, a * bj_RADTODEG, 2, 3.45, 1, 255, 255, 255, 100))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_K_BaoZha_heibai.mdl", x, y, a * bj_RADTODEG, 0.5, 3.35, 150))
                        endif
                         set x = x + move * Cos(a)
                        set y = y + move * Sin(a)
                       
                    endif
                else
                    if check2 > 0 then
                    call SaveInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"), LoadInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"))+k2)
                    endif
                    call DestroyEffect(e)
                    call StopSpellUnit(c)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set c = null
                    set e = null
                    set g = null
                    set g2 = null
                    set u = null
                    set m_KenjakuR2[i] = m_KenjakuR2[ MUI_KenjakuR2]
                    set MUI_KenjakuR2 = MUI_KenjakuR2 - 1
                    if MUI_KenjakuR2 == -1 then
                        call PauseTimer( t_KenjakuR2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KenjakuR2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_KenjakuR2 = MUI_KenjakuR2 + 1
            set m_KenjakuR2[ MUI_KenjakuR2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set u = null
            set check2 = 0
            set g = CreateGroup()
            set g2 = CreateGroup()
            set k2 = 0
            set a = GAngle2(c, x, y) // Angle Between points
            set dmg = GetHeroInt( c , true) * ( KenjakuR2_DamageIntBase + ( KenjakuR2_DamageIntStep * ( GetUnitAbilityLevel( c , KenjakuR2_ID) - 1 ) ) )
            set aoe = KenjakuR2_DamageAoe
            call SetUnitFacing(c, a * bj_RADTODEG)
            call StartSpellUnit(c)
            call SetUnitTimeScale(c, 1.25)
            set check = LoadInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"))
            if GetHeroLevel(c) >= 35 then
            elseif GetHeroLevel(c) >= 24 then
            endif
            if check < 6 then
                set rmax = 1.08
                call SetUnitAnimationByIndex(c, 6)
                set r5 = 0.81
                call MakeSound("war3mapImported\\Hero_Kenjaku_R2 0")
            else
            set k2 = R2I(check/3)
                set dmg = dmg + GetHeroInt(c, true) * ((check ) * KenjakuR2_DamageIntBonusPerCurse)
                call MakeSound("war3mapImported\\Hero_Kenjaku_R2 1")
                call MakeSound("war3mapImported\\Hero_Kenjaku_R2 4")
                set rmax = 1.54
                call SetUnitTimeScale(c, 2.25)
                call SetUnitAnimationByIndex(c, 14)
            call SaveInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"), 0)
                set r5 = 1.32
            endif
            if MUI_KenjakuR2 == 0 then
                call TimerStart( t_KenjakuR2, 0.03, true, function thistype.Loop_KenjakuR2)
            endif
        endmethod
    endstruct

    private struct KenjakuT_KS
        private static timer t_KenjakuT = CreateTimer( )
        private static integer array m_KenjakuT
        private static integer MUI_KenjakuT = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        real r3
        real r5
        group g
        unit u
        real scale
        real dmg
        real aoe
        real r
        integer check
        integer check2
        effect e
        effect e2
        real a
        real rmax
        private static method Loop_KenjakuT takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_KenjakuT
                set this = m_KenjakuT[i]
                if SpellBoolCaster(c) and r <= rmax and check< check2 then
                    set r = RoundReal(r + 0.03, 3)
                    set r = RoundReal(r, 3)
                    call DebugUnit(c)
                    if r == 0.66 then
                        set e2 = EffectSpawn("war3mapimported\\wos_rt_kenjaku2.mdl", x1, y1, 1, 0.25, 3.3, 0)
                        call EffectSpawnColor2("war3mapimported\\wos_TX-BlackDmGrow.mdl", x1, y1, 1, 1.5, 3.45, 5, rmax - r + 0.12, 255, 55, 55, 255)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_tx027.mdl", x1, y1, 1, 1, 1.25, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_tx027.mdl", x1, y1, 180, 0.75, 2, 1))
                        if GetLocalPlayer() == GetOwningPlayer(c) then
                            call CameraSetTargetNoise(17.0, 25.0)
                        endif
                    endif
                    if r == r5 - 0.21 then
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_tx027.mdl", x1, y1, 1, 1, 1.25*scale, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_tx027.mdl", x1, y1, 180, 0.75, 2*scale, 1))
                    endif
                    if r == r5 then
                        set r2 = 10
                        call MakeSound("war3mapImported\\Hero_Kenjaku_T 3")
                        call EffectSpawn2("war3mapimported\\wos_bankaimess.mdl", x, y, 120, 0.25, 0.4*scale, 1100, rmax - r)
                        call EffectSpawn2("war3mapImported\\wos_bankaimess_black2.mdl", x, y, 120, 0.25, 0.4*scale, 1100, rmax - r)
                        call EffectSpawn2("war3mapImported\\wos_bankaimess_black2.mdl", x, y, 210, 0.25, 0.4*scale, 1100, rmax - r)
                    endif
                    if r > 0.66 then
                        if r > r5 and r3 > 0.17 then
                            set r3 = 0
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_gnaden_air.mdl", x1, y1, GetRandomReal(0, 359), 1, 4.5*scale, 1, 255, 125, 125, 205))
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_gnaden_air.mdl", x1, y1, GetRandomReal(0, 359), 1, 4*scale, 1, 255, 255, 255, 225))
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_gnaden_air.mdl", x1, y1, GetRandomReal(0, 359), 1, 5*scale, 1, 255, 25, 25, 205))
                        else
                            set r3 = r3 + 0.03
                        endif
                        if r2 > 0.39 then
                            set r2 = 0
                            if r >= r5 then
                            set check = check + 1
                            call DecorRemove(c, x, y, aoe, 100)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdx", .x, .y, GetRandomReal(0, 359), 1, 4.5*scale, 1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_FantasyBattle (1517).mdx", .x, .y, GetRandomReal(0, 359), 1.5, 1.25*scale, 3))
                            endif
                            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("cam swing"), 1)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    if r >= r5 then
                                        call dmgmag(c, u, dmg)
                                        call SlowUnit(c,u,KenjakuT_SlowPercent,KenjakuT_SlowTime)
                                        call SetUnitAnimation(u, "death")
                                    endif
                                    if GetLocalPlayer() == GetOwningPlayer(u) then
                                        call CameraSetTargetNoise(17.0, 25.0)
                                    endif
                                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(u)), StringHash("cam swing"), 1)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    set k = 0
                    loop
                        exitwhen k > 10
                        if LoadInteger(hs, GetHandleId(Player(k)), StringHash("cam swing")) == 1 then
                            if GetLocalPlayer() == Player(k) then
                                call CameraSetTargetNoise(0, 0)
                            endif
                            call SaveInteger(hs, GetHandleId(Player(k)), StringHash("cam swing"), 0)
                        endif
                        set k = k + 1
                    endloop
                    call BlzSetSpecialEffectTimeScale(e2, 1)
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.45)
                    call ColorEffDummy3(e2, 0.05, 255, 255, 255, 0.45)
                    call StopSpellUnit(c)
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_KenjakuT[i] = m_KenjakuT[ MUI_KenjakuT]
                    set MUI_KenjakuT = MUI_KenjakuT - 1
                    if MUI_KenjakuT == -1 then
                        call PauseTimer( t_KenjakuT)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method KenjakuT_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_KenjakuT = MUI_KenjakuT + 1
            set m_KenjakuT[ MUI_KenjakuT] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r5 = 1.2
            set g = CreateGroup()
            set u = null
            set r2 = 0
            set check2 = 5
            set check = 0
            set a = GAngle2(c, x, y) // Angle Between points
            set dmg = GetHeroInt( c , true) * KenjakuT_DamageIntBase
            set dmg = dmg / check2
            set aoe = KenjakuT_DamageAoe
            set rmax = 3.42
            set scale = aoe/925
            set x1 = GetUnitX(c) - 240 * Cos(a)
            set y1 = GetUnitY(c) - 240 * Sin(a)
            call SetUnitFacing(c, a * bj_RADTODEG)
            call StartSpellUnit(c)
            call MakeSound("war3mapImported\\Hero_Kenjaku_T")
            call MakeSound("war3mapImported\\Hero_Kenjaku_T 2")
            call SetUnitAnimationByIndex( c , 14)
            call SetUnitTimeScale(c, 0.5)
            set e = EffectSpawn("war3mapimported\\wos_hakkestart.mdl", x1, y1, 1, 1, 1.25, 3)
            call AnimDummyEff(e, 0.25, 0)
            if MUI_KenjakuT == 0 then
                call TimerStart( t_KenjakuT, 0.03, true, function thistype.Loop_KenjakuT)
            endif
        endmethod
    endstruct

    private struct KenjakuF_KS
        private static timer t_KenjakuF = CreateTimer( )
        private static integer array m_KenjakuF
        private static integer MUI_KenjakuF = -1
        unit c
        real r2
        integer k2
        integer k3
        integer check
        integer check2
        real r
        framehandle array frame_pas1 [10]
        framehandle array frame_pas2 [10]
        framehandle array frame_pas3 [10]
        framehandle array frame_pas4 [10]
        framehandle array frame_pas5 [10]
        framehandle array frame_pas6 [10]
        private static method Loop_KenjakuF takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_KenjakuF
                set this = m_KenjakuF[i]
                if GetUnitTypeId(c) == check2  and Hero[k2] != null then
                    if CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c))== false and IsUnitType(c, UNIT_TYPE_DEAD)== false then
                        set r = r + 0.1
                        set r = RoundReal(r, 2)
                    endif
                    if GetHeroLevel(c) >=35 then 
        set r2 = KenjakuF_StackTimeReplenish4
        elseif GetHeroLevel(c) >=25 then
        set r2 = KenjakuF_StackTimeReplenish3
        elseif GetHeroLevel(c) >=12 then
        set r2 = KenjakuF_StackTimeReplenish2
        elseif GetHeroLevel(c) >=6 then
        set r2 = KenjakuF_StackTimeReplenish1
        else
        set r2 = KenjakuF_StackTimeReplenish0
        endif
                    call BlzFrameSetValue(frame_pas3[k2], (r))
                    set k3 = KenjakuF_BaseStacksAmount
                    if GetHeroLevel(c) >= 35 then
                        set k3 = KenjakuF_MaxStacksAmount4
                    elseif GetHeroLevel(c) >= 24 then
                        set k3 = KenjakuF_MaxStacksAmount3
                    elseif GetHeroLevel(c) >= 12 then
                        set k3 = KenjakuF_MaxStacksAmount2
                    elseif GetHeroLevel(c) >= 6 then
                        set k3 = KenjakuF_MaxStacksAmount1
                    endif
                    call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, r2)
                    set check = LoadInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"))
                    if check > k3 then
                        set check = k3
                        call SaveInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"), check)
                    endif
                    if r >= r2 then
                        set r = 0
                        set check = check + 1
                        if check > k3 then
                            set check = k3
                        endif
                        call SaveInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"), check)
                    endif
                    if check >= KenjakuQ2_CostCurse then
                        if KenjakuF_Unit1[k2] == null then
                            set KenjakuF_Unit1[k2] = CreateUnit(Player(k2), KenjakuF_Unit1_ID, GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster), 1)
                        endif
                    else
                        if KenjakuF_Unit1[k2] != null then
                            call RemoveUnit(KenjakuF_Unit1[k2])
                            set KenjakuF_Unit1[k2] = null
                        endif
                    endif
                    if check >= KenjakuE2_CostCurse then
                        if KenjakuF_Unit2[k2] == null then
                            set KenjakuF_Unit2[k2] = CreateUnit(Player(k2), KenjakuF_Unit2_ID, GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster), 1)
                        endif
                    else
                        if KenjakuF_Unit2[k2] != null then
                            call RemoveUnit(KenjakuF_Unit2[k2])
                            set KenjakuF_Unit2[k2] = null
                        endif
                    endif
                    if check >= 6 then
                        call BlzSetAbilityIcon(KenjakuR2_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Kenjaku2_R2.blp")
                    else
                        call BlzSetAbilityIcon(KenjakuR2_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Kenjaku2_R.blp")
                    endif
                    if r2 - r >= 0 then
                        call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(r, 0, 2) + "|r")
                    endif
                    call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Curse count: " + I2S(check) + "/" + I2S(k3) + "|r")
                     /* if CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) or IsUnitType(c, UNIT_TYPE_DEAD) then
                    set r = 0
                    set check = 1
                endif */ 
            else
                if GetLocalPlayer() == Player(k2) then
                    call BlzFrameSetVisible(frame_pas1[k2], false)
                endif
                set c = null
                set m_KenjakuF[i] = m_KenjakuF[ MUI_KenjakuF]
                set MUI_KenjakuF = MUI_KenjakuF - 1
                if MUI_KenjakuF == -1 then
                    call PauseTimer( t_KenjakuF)
                endif
                call deallocate(this)
            endif
            set i = i + 1
        endloop
    endmethod
    public static method KenjakuF_Start takes unit NewC returns nothing
        local thistype this = thistype.create( )
        set MUI_KenjakuF = MUI_KenjakuF + 1
        set m_KenjakuF[ MUI_KenjakuF] = this
        set c = NewC
        call SaveInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"), 0)
        set check = 1
        set check2 = GetUnitTypeId(c)
        set k3 = KenjakuF_BaseStacksAmount
        set k2 = GetPlayerId(GetOwningPlayer(c))
        if GetHeroLevel(c) >=35 then 
        set r2 = KenjakuF_StackTimeReplenish4
        elseif GetHeroLevel(c) >=25 then
        set r2 = KenjakuF_StackTimeReplenish3
        elseif GetHeroLevel(c) >=12 then
        set r2 = KenjakuF_StackTimeReplenish2
        elseif GetHeroLevel(c) >=6 then
        set r2 = KenjakuF_StackTimeReplenish1
        else
        set r2 = KenjakuF_StackTimeReplenish0
        endif
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
            call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, r2)
            call BlzFrameSetValue(frame_pas3[k2], 0)
            set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)
            call BlzFrameSetAbsPoint(frame_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18)
            call BlzFrameSetSize(frame_pas4[k2], 0.03, 0.03)
            call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Kenjaku_F4", 0, false)
            set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
            call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
            call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Curse count:" + I2S(check) + "|r")
            call BlzFrameSetScale(frame_pas5[k2], 0.9)
            set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
            call BlzFrameSetAbsPoint(frame_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17)
            call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(Test_real, 0, 2) + "|r")
            call BlzFrameSetScale(frame_pas6[k2], 0.9)
        else
            if GetLocalPlayer() == GetOwningPlayer(c) then
                call BlzFrameSetVisible(frame_pas1[k2], true)
            endif
            call BlzFrameSetValue(frame_pas3[k2], r2)
        endif
        set r = 0
        if MUI_KenjakuF == 0 then
            call TimerStart( t_KenjakuF, 0.1, true, function thistype.Loop_KenjakuF)
        endif
    endmethod
    endstruct

    private struct KenjakuF2_KS
        private static timer t_KenjakuF2 = CreateTimer( )
        private static integer array m_KenjakuF2
        private static integer MUI_KenjakuF2 = -1
        unit c
        unit td
        real x
        real y
        real x1
        real y1
        integer k
        integer k2
        texttag tt
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
        framehandle array frame2_pas1 [10]
        framehandle array frame2_pas2 [10]
        framehandle array frame2_pas3 [10]
        framehandle array frame2_pas4 [10]
        framehandle array frame2_pas5 [10]
        framehandle array frame2_pas6 [10]
    private static method Loop_KenjakuF2 takes nothing returns nothing
        local integer this
        local integer i = 0
        loop
            exitwhen i > MUI_KenjakuF2
            set this = m_KenjakuF2[i]
            if SpellBoolCaster(c) and GetWidgetLife(td) > 0.405 and r <= rmax then
                set r = RoundReal(r + 0.03, 3)
                set r = RoundReal(r, 3)
                set x = GetUnitX(td)
                set y = GetUnitY(td)
                if check == 0 then
                    set a = GAngle5(e, x, y)
                    call BlzSetSpecialEffectYaw(e, a)
                    if SR5(e, x, y) > 90 then
                        call MoveEff(e, move, a)
                        if BlzGetLocalSpecialEffectZ(e) > 10 then
                            call BlzSetSpecialEffectHeight(e, BlzGetLocalSpecialEffectZ(e) - 1.5)
                        endif
                    else
                        call MakeSound("war3mapImported\\Hero_Kenjaku_F2 1")
                        call BlzSetSpecialEffectPosition(e, x, y, 0)
                        set rmax = KenjakuF2_CastTime
                        set e3 = EffectSpawn("war3mapImported\\wos_tx-tsqyuanxing2.mdl", x, y, 1, 0.5, 1.4, 4)
                        set e4 = EffectSpawn("war3mapImported\\wos_hakkestart.mdl", x, y, 1, 1, 1.25, 3)
                        call AnimDummyEff(e4, 0.25, 0)
                        set e2 = EffectSpawn("war3mapImported\\wos_prisonrealm_2.mdl", x, y, 1, 1, 2, 190)
                        call ColorEffDummy4(e2, 0, 255, 255, 255, 0.3)
                        set check = 1
                        set r = 0
                        set tt = CreateTextTag()
                        call SetTextTagPos(tt, x, y, 500) // РїРѕР·РёС†РёСЏ (РЅР°РїСЂРёРјРµСЂ РЅР° СЋРЅРёС‚Рµ)
                        call SetTextTagText(tt, "|c00FF0303" + R2SW(rmax, 0, 2) + "|r", 0.034) // СЃР°Рј С‚РµРєСЃС‚ Рё СЂР°Р·РјРµСЂ
                        call SetTextTagPermanent(tt, true) // РґРµР»Р°РµРј РЅРµРїРѕСЃС‚РѕСЏРЅРЅС‹Рј
                        call SetTextTagVisibility(tt, false)
                        set k = 0
                        loop
                            exitwhen k > 10
                            if IsUnitVisible(td, Player(k)) or Player(k) == GetOwningPlayer(c) then
                                if GetLocalPlayer() == Player(k) then
                                    call SetTextTagVisibility(tt, true)
                                endif
                            endif
                            set k = k + 1
                        endloop
                    endif
                elseif check == 1 then
                    if SR5(e3, x, y) > aoe then
                        set r = 99999
                    endif
                    if r == 0.99 then
                        call MakeSound("war3mapImported\\Hero_Kenjaku_F2 2")
                    endif
                    call SetTextTagText(tt, "|c00FF0303" + R2SW(rmax - r, 0, 2) + "|r", 0.034) // СЃР°Рј С‚РµРєСЃС‚ Рё СЂР°Р·РјРµСЂ
                    call SetTextTagVisibility(tt, false)
                    set k = 0
                    loop
                        exitwhen k > 10
                        if IsUnitVisible(td, Player(k)) or Player(k) == GetOwningPlayer(c) then
                            if GetLocalPlayer() == Player(k) then
                                call SetTextTagVisibility(tt, true)
                            endif
                        endif
                        set k = k + 1
                    endloop
                    if r >= KenjakuF2_CastTime and r < 999 then
                        set check = 2
                        set r = 0
                        set rmax = KenjakuF2_SealTime
                        call MakeSound("war3mapImported\\Hero_Kenjaku_F2 4")
                        call MakeSound("war3mapImported\\Hero_Kenjaku_F2 5")
                        if GetUnitTypeId(td) == Gojo_ID then 
                        call NextSound("war3mapImported\\Hero_Kenjaku_F2 3",0.7)
                        endif
                        call DestroyEffect(e3)
                        call DestroyTextTag(tt)
                        set x1 = GetUnitX(td)
                        set y1 = GetUnitY(td)
                        call BlzSetSpecialEffectPosition(e, x, y, 0)
                        call ScaleEffDummy(e, 0.3, 1, 6)
                        call ColorEffDummy3(e2, 0, 255, 255, 255, 0.45)
                        call ColorEffDummy3(e4, 0, 255, 255, 255, 0.45)
                        call UnitAddAbility(td,KenjakuF2_Prison_Abi_ID)
                        call UnitMakeAbilityPermanent(td,true,KenjakuF2_Prison_Abi_ID)
                        call SetUnitPosition(td, GetRectCenterX(gg_rct_Cage), GetRectCenterY(gg_rct_Cage))
                        if frame2_pas1[ k2] == null then
                            set frame2_pas1[ k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                            call BlzFrameSetAbsPoint( frame2_pas1[ k2], FRAMEPOINT_CENTER, 0.525, 0.49)
                            call BlzFrameSetSize( frame2_pas1[ k2], 0.135, 0.035)
                            call BlzFrameSetTexture( frame2_pas1[ k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                            call BlzFrameSetVisible( frame2_pas1[ k2], true)
                            set frame2_pas2[ k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame2_pas1[ k2], 0, 0)
                            call BlzFrameSetPoint( frame2_pas2[ k2], FRAMEPOINT_CENTER, frame2_pas1[ k2], FRAMEPOINT_CENTER, 0, 0.5)
                            call BlzFrameSetSize( frame2_pas2[ k2], 0.1, 0.019)
                            set frame2_pas3[ k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[ k2], "", 0)
                            call BlzFrameSetSize( frame2_pas3[ k2], 0.1, 0.035)
                            call BlzFrameSetScale( frame2_pas3[ k2], 0.5)
                            call BlzFrameSetModel( frame2_pas3[ k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                            call BlzFrameSetPoint( frame2_pas3[ k2], FRAMEPOINT_CENTER, frame2_pas1[ k2], FRAMEPOINT_CENTER, -0.015, 0)
                            call BlzFrameSetMinMaxValue( frame2_pas3[ k2], 0, rmax)
                            call BlzFrameSetValue( frame2_pas3[ k2], rmax )
                            set frame2_pas4[ k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[ k2], "", 0)
                            call BlzFrameSetPoint( frame2_pas4[ k2], FRAMEPOINT_CENTER, frame2_pas1[ k2], FRAMEPOINT_CENTER, -0.048, 0)
                            call BlzFrameSetSize( frame2_pas4[ k2], 0.0275, 0.0275)
                            call BlzFrameSetTexture( frame2_pas4[ k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Kenjaku_F3", 0, false)
                            set frame2_pas5[ k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[ k2], "", 0)
                            call BlzFrameSetPoint( frame2_pas5[ k2], FRAMEPOINT_CENTER, frame2_pas1[ k2], FRAMEPOINT_CENTER, 0.0175, 0.01)
                            call BlzFrameSetText( frame2_pas5[ k2], "|c00FFFF00" + "Prison Realm:" + "|r")
                            call BlzFrameSetScale( frame2_pas5[ k2], 0.9)
                            set frame2_pas6[ k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[ k2], "", 0)
                            call BlzFrameSetPoint( frame2_pas6[ k2], FRAMEPOINT_CENTER, frame2_pas1[ k2], FRAMEPOINT_CENTER, 0.0175, -0.005)
                            call BlzFrameSetText( frame2_pas6[ k2], "|c00FFFF00" + R2SW(rmax , 0, 2) + "|r")
                            call BlzFrameSetScale( frame2_pas6[ k2], 0.9)
                        else
                            call BlzFrameSetVisible( frame2_pas1[ k2], true)
                            call BlzFrameSetMinMaxValue( frame2_pas3[ k2], 0, rmax)
                            call BlzFrameSetText( frame2_pas6[ k2], "|c00FFFF00" + R2SW(rmax, 0, 2) + "|r")
                        endif
                    endif
                elseif check >= 2 then
                    if r == 0.6 and check == 2 then
                        call ScaleEffDummy(e, 0.33, 7, 1.5)
                    endif
                    if CheckCoordsInRect(gg_rct_Cage,GetUnitX(td),GetUnitY(td)) == false then 
                    call UnitAddAbility(td,KenjakuF2_Prison_Abi_ID)
                    call UnitMakeAbilityPermanent(td,true,KenjakuF2_Prison_Abi_ID)
                    call SetUnitPosition(td, GetRectCenterX(gg_rct_Cage), GetRectCenterY(gg_rct_Cage))
                    endif
                    call SetMpCurrent(td,-2)
                    if GetWidgetLife(td)>10 then 
                    call SetHpCurrent(td,-1.75)
                    endif
                    call BlzFrameSetValue( frame2_pas3[ k2], r)
                    call BlzFrameSetText( frame2_pas6[ k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                    if SR5(e, GetUnitX(c), GetUnitY(c)) < 90 and check == 2 then
                        set check = 3
                        call ScaleEffDummy(e, 0.21, 2, 0)
                    endif
                    if check == 3 then
                        call BlzSetSpecialEffectPosition(e, GetUnitX(c), GetUnitY(c), 120)
                    endif
                endif
            else
                call UnitRemoveAbility(td,KenjakuF2_Prison_Abi_ID)
                if check >= 2  then
                    call BlzFrameSetVisible( frame2_pas1[ k2], false)
                    if check == 2 then
                        set x = x1 + 200 * Cos(90 * bj_DEGTORAD)
                        set y = y1 + 200 * Sin(90 * bj_DEGTORAD)
                    else
                        set x = GetUnitX(c) + 200 * Cos(90 * bj_DEGTORAD)
                        set y = GetUnitY(c) + 200 * Sin(90 * bj_DEGTORAD)
                    endif
                    call MakeSound("war3mapImported\\Hero_Kenjaku_F2 0")
                    call BlzSetSpecialEffectAlpha(e, 255)
                    call BlzSetSpecialEffectPosition(e, x, y, 0)
                    call ScaleEffDummy(e, 0.3, 1, 5)
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.45)
                    call SetUnitPosition(td, x, y)
                else
                    call DestroyEffect(e)
                endif
                if check == 2 or check == 1 then
                    if check == 1 then
                        call DestroyTextTag(tt)
                    endif
                    call ColorEffDummy3(e2, 0, 255, 255, 255, 0.45)
                    call ColorEffDummy3(e4, 0, 255, 255, 255, 0.45)
                    call DestroyEffect(e3)
                endif
                set c = null
                set tt = null
                set td = null
                set e = null
                set e2 = null
                set e3 = null
                set e4 = null
                set m_KenjakuF2[i] = m_KenjakuF2[ MUI_KenjakuF2]
                set MUI_KenjakuF2 = MUI_KenjakuF2 - 1
                if MUI_KenjakuF2 == -1 then
                    call PauseTimer( t_KenjakuF2)
                endif
                call deallocate(this)
            endif
            set i = i + 1
        endloop
    endmethod
    public static method KenjakuF2_Start takes unit NewC, unit NewTd returns nothing
        local thistype this = thistype.create( )
        set MUI_KenjakuF2 = MUI_KenjakuF2 + 1
        set m_KenjakuF2[ MUI_KenjakuF2] = this
        set c = NewC
        set td = NewTd
        set x = GetUnitX(td)
        set y = GetUnitY(td)
        set k2 = GetPlayerId(GetOwningPlayer(c))
        set r = 0
        set move = 35
        set rmax = 3
        set a = GAngle2(c, x, y) // Angle Between points
        set aoe = KenjakuF2_Aoe
        set e = EffectSpawn("war3mapImported\\wos_prisonrealm.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 3, 1, 120)
        call SetUnitFacing(c, a * bj_RADTODEG)
        call MakeSound("war3mapImported\\Hero_Kenjaku_F2 0")
        set check = 0
        if MUI_KenjakuF2 == 0 then
            call TimerStart( t_KenjakuF2, 0.03, true, function thistype.Loop_KenjakuF2)
        endif
    endmethod
    endstruct

    private struct KenjakuSummon_KS
        private static timer t_KenjakuSummon = CreateTimer( )
        private static integer array m_KenjakuSummon
        private static integer MUI_KenjakuSummon = -1
        unit c
        unit d
        real x
        real y
        real r2
        real r5
        integer check
        integer check2
        real r
    private static method Loop_KenjakuSummon takes nothing returns nothing
        local integer this
        local integer i = 0
        loop
            exitwhen i > MUI_KenjakuSummon
            set this = m_KenjakuSummon[i]
            if GetUnitTypeId(c) == check2 and d != null and IsUnitType(d, UNIT_TYPE_DEAD) == false and IsUnitType(c, UNIT_TYPE_DEAD) == false and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false then
                set r = r + 0.05
                set r = RoundReal(r, 2)
                if r == 0.6 then
                    call StopSpellUnit(d)
                endif
                if IsUnitPaused(d) == false then
                    if SR2(d, c) > 1800 then
                        set x = GetUnitX(d)
                        set y = GetUnitY(d)
                        if GetUnitTypeId(d) == KenjakuE2_Dummy_ID then
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_BY_Wood_Effect_Void_DaiTu_ShenWei_FangChu.mdl", x, y, 1, 0.75, 3, 135, 255, 25, 25, 255))
                            call ColorEffDummy3(EffectSpawnColor("war3mapimported\\wos_afb (43).mdl", x, y, 1, 1, 0.45, 1, 255, 25, 25, 255), 0, 255, 255, 255, 1.1)
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_afb (58).mdl", x, y, 1, 0.95, 1.98, 1, 255, 25, 25, 255))
                        else
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Effect_Void_DaiTu_ShenWei_FangChu.mdl", x, y, 1, 0.75, 3, 135))
                            call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_afb (43).mdl", x, y, 1, 1, 0.45, 1), 0, 255, 255, 255, 1.1)
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_afb (58).mdl", x, y, 1, 0.95, 1.98, 1))
                        endif
                        set r5 = (GetUnitFacing(c) + GetRandomReal( -60, 60)) * bj_DEGTORAD
                        set x = GetUnitX(c) + 450 * Cos(r5)
                        set y = GetUnitY(c) + 450 * Sin(r5)
                        call SetUnitPosition(d, x, y)
                        if GetUnitTypeId(d) == KenjakuE2_Dummy_ID then
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_BY_Wood_Effect_Void_DaiTu_ShenWei_FangChu.mdl", x, y, 1, 0.75, 3, 135, 255, 25, 25, 255))
                            call ColorEffDummy3(EffectSpawnColor("war3mapimported\\wos_afb (43).mdl", x, y, 1, 1, 0.45, 1, 255, 25, 25, 255), 0, 255, 255, 255, 1.1)
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_afb (58).mdl", x, y, 1, 0.95, 1.98, 1, 255, 25, 25, 255))
                        else
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Effect_Void_DaiTu_ShenWei_FangChu.mdl", x, y, 1, 0.75, 3, 135))
                            call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_afb (43).mdl", x, y, 1, 1, 0.45, 1), 0, 255, 255, 255, 1.1)
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_afb (58).mdl", x, y, 1, 0.95, 1.98, 1))
                        endif
                    elseif SR2(d, c) > 750 and GetUnitCurrentOrder(d) != OrderId("attack") and GetUnitCurrentOrder(d) != OrderId("smart") then
                        set r5 = (GetUnitFacing(c) + GetRandomReal( -60, 60)) * bj_DEGTORAD
                        set x = GetUnitX(c) + 450 * Cos(r5)
                        set y = GetUnitY(c) + 450 * Sin(r5)
                        call IssuePointOrder(d, "attack", x, y)
                    elseif r2 > 2.45 and GetUnitCurrentOrder(d) != OrderId("attack") and GetUnitCurrentOrder(d) != OrderId("smart") then
                        set r2 = 0
                        set r5 = (GetRandomReal( 0, 360)) * bj_DEGTORAD
                        set x = GetUnitX(c) + 450 * Cos(r5)
                        set y = GetUnitY(c) + 450 * Sin(r5)
                        call IssuePointOrder(d, "attack", x, y)
                    else
                        set r2 = r2 + 0.05
                    endif
                endif
            else
            if CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) then
            set check = LoadInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"))
            if KenjakuQ2_Dummy_ID == GetUnitTypeId(d) then
        call SaveInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"), check + KenjakuQ2_CostCurse)
    endif
    if KenjakuW2_Dummy_ID == GetUnitTypeId(d) then
        call SaveInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"), check + KenjakuW2_CostCurse)
    endif
    if KenjakuE2_Dummy_ID == GetUnitTypeId(d) then 
        call SaveInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"), check + KenjakuE2_CostCurse)
    endif
    endif
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Effect_Void_DaiTu_ShenWei_FangChu.mdl", GetUnitX(d), GetUnitY(d), 1, 1.1, 2.75, 125))
                call KillUnit(d)
    call SetUnitTimeScale(d, 0.01)
    call PauseUnit(d, false)
    call ScaleDummy(d, 0.3, 1, 0.65)
    call ColorDummy3(d, 0, 5, 5, 5, 0.3)                
                set c = null
                set d = null
                set m_KenjakuSummon[i] = m_KenjakuSummon[ MUI_KenjakuSummon]
                set MUI_KenjakuSummon = MUI_KenjakuSummon - 1
                if MUI_KenjakuSummon == -1 then
                    call PauseTimer( t_KenjakuSummon)
                endif
                call deallocate(this)
            endif
            set i = i + 1
        endloop
    endmethod
    public static method KenjakuSummon_Start takes unit NewC, unit NewD returns nothing
        local thistype this = thistype.create( )
        set MUI_KenjakuSummon = MUI_KenjakuSummon + 1
        set m_KenjakuSummon[ MUI_KenjakuSummon] = this
        set c = NewC
        set d = NewD
        set check = 1
        set check2 = GetUnitTypeId(c)
        set r2 = 15
        set x = GetUnitX(d)
        set y = GetUnitY(d)
        call StartSpellUnit(d)
        call SetScale(d, 0.01)
        call ScaleDummy(d, 0.51, 0.01, 1)
        if GetUnitTypeId(d) == KenjakuE2_Dummy_ID then
            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_BY_Wood_Effect_Void_DaiTu_ShenWei_FangChu.mdl", x, y, 1, 0.75, 3, 135, 255, 25, 25, 255))
            call ColorEffDummy3(EffectSpawnColor("war3mapimported\\wos_afb (43).mdl", x, y, 1, 1, 0.45, 1, 255, 25, 25, 255), 0, 255, 255, 255, 1.1)
            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_afb (58).mdl", x, y, 1, 0.95, 1.98, 1, 255, 25, 25, 255))
        else
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Effect_Void_DaiTu_ShenWei_FangChu.mdl", x, y, 1, 0.75, 3, 135))
            call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_afb (43).mdl", x, y, 1, 1, 0.45, 1), 0, 255, 255, 255, 1.1)
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_afb (58).mdl", x, y, 1, 0.95, 1.98, 1))
        endif
        set r = 0
        if MUI_KenjakuSummon == 0 then
            call TimerStart( t_KenjakuSummon, 0.05, true, function thistype.Loop_KenjakuSummon)
        endif
    endmethod
    endstruct

    
    //----------------------------Kenjaku-----------------------------------------------
 /* Animations index:
Base:
0 - hand forward left
1 - right
2 - up to earth
3 - leg kick
4 - moving to
5 - hand kick after 4
6 - hand forward ladon open
7 - zamah k sebe
9 - charge
10 - leg kick s razvorota
14 - RT
15 - stand ready
16 - schvirok
    
Blue big nose:
0 - attack 1
1 - tp in
2 - tp out
3 - fast atk
4 - attack 2
5 - death
6 - stand channel
    
    
    
 */ 
function KenjakuF3_Start takes unit c, unit td returns nothing
    local integer check = LoadInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"))
    local real hp = GetUnitState(td,UNIT_STATE_LIFE)*(KenjakuF_Hpregen/100)
    call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Effect_Void_DaiTu_ShenWei_FangChu.mdl", GetUnitX(td), GetUnitY(td), 1, 1.1, 2.75, 125))
    call SetUnitTimeScale(td, 0.01)
    call SetUnitUserData(td,10)
    call PauseUnit(td, false)
    call UnitAddAbility(td,'A08L')
    call KillUnit(td)
    call ScaleDummy(td, 0.3, 1, 0.65)
    call ColorDummy3(td, 0, 5, 5, 5, 0.3)
    call MakeSound("war3mapImported\\Hero_Kenjaku_F")
    call MakeSound("war3mapImported\\Hero_Kenjaku_F2")
    if KenjakuQ2_Dummy_ID == GetUnitTypeId(td) then
        call SetMpCurrent(c, BlzGetUnitAbilityManaCost(c, KenjakuQ2_ID, GetUnitAbilityLevel(c, KenjakuQ2_ID)-1))
        call SaveInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"), check + KenjakuQ2_CostCurse)
        call SetHpCurrent2(c,c,hp)
    endif
    if KenjakuW2_Dummy_ID == GetUnitTypeId(td) then
        call SetMpCurrent(c, BlzGetUnitAbilityManaCost(c, KenjakuW2_ID, GetUnitAbilityLevel(c, KenjakuW2_ID)-1))
        call SaveInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"), check + KenjakuW2_CostCurse)
        call SetHpCurrent2(c,c,hp)
    endif
    if KenjakuE2_Dummy_ID == GetUnitTypeId(td) then 
        call SetHpCurrent2(c,c,hp)
        call SetMpCurrent(c, BlzGetUnitAbilityManaCost(c, KenjakuE2_ID, GetUnitAbilityLevel(c, KenjakuE2_ID)-1))
        call SaveInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"), check + KenjakuE2_CostCurse)
    endif
endfunction
function KenjakuF_Start takes unit c, unit td returns nothing
    call KenjakuF2_KS.KenjakuF2_Start( c, td )
endfunction
function KenjakuF2_Start takes unit c returns nothing
    call KenjakuF_KS.KenjakuF_Start( c )
endfunction
function KenjakuG_Start takes unit c returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(c))
    local integer check = LoadInteger(hs, GetHandleId(c), StringHash("kit type"))
    if check == 0 then
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuQ_ID, false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuW_ID, false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuE_ID, false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuR_ID, false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuF_ID, false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuQ2_ID, true)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuW2_ID, true)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuE2_ID, true)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuR2_ID, true)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuF2_ID, true)
        if GetUnitAbilityLevel(c, KenjakuQ2_ID) == 0 then
            call UnitAddAbility(c, KenjakuQ2_ID)
            call UnitAddAbility(c, KenjakuW2_ID)
            call UnitAddAbility(c, KenjakuF2_ID)
        endif
        if GetUnitAbilityLevel(c, KenjakuE2_ID) == 0 and GetUnitAbilityLevel(c, KenjakuE_ID) > 0 then
            call UnitAddAbility(c, KenjakuE2_ID)
        endif
        if GetUnitAbilityLevel(c, KenjakuR2_ID) == 0 and GetUnitAbilityLevel(c, KenjakuR_ID) > 0 then
            call UnitAddAbility(c, KenjakuR2_ID)
        endif
        call SetUnitAbilityLevel(c, KenjakuQ2_ID, GetUnitAbilityLevel(c, KenjakuQ_ID))
        call SetUnitAbilityLevel(c, KenjakuW2_ID, GetUnitAbilityLevel(c, KenjakuW_ID))
        call SetUnitAbilityLevel(c, KenjakuE2_ID, GetUnitAbilityLevel(c, KenjakuE_ID))
        call SetUnitAbilityLevel(c, KenjakuQ3_ID, GetUnitAbilityLevel(c, KenjakuQ_ID))
        call SetUnitAbilityLevel(c, KenjakuW3_ID, GetUnitAbilityLevel(c, KenjakuW_ID))
        call SetUnitAbilityLevel(c, KenjakuE3_ID, GetUnitAbilityLevel(c, KenjakuE_ID))
        call SetUnitAbilityLevel(c, KenjakuR2_ID, GetUnitAbilityLevel(c, KenjakuR_ID))
        if LoadUnitHandle(hs, GetHandleId(GetOwningPlayer(c)), StringHash("kenjaku unit q")) != null then
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuQ2_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuQ3_ID, true)
        endif
        if LoadUnitHandle(hs, GetHandleId(GetOwningPlayer(c)), StringHash("kenjaku unit w")) != null then
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuW2_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuW3_ID, true)
        endif
        if LoadUnitHandle(hs, GetHandleId(GetOwningPlayer(c)), StringHash("kenjaku unit e")) != null then
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuE2_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuE3_ID, true)
        endif
        set check = 1
    else
        set check = 0
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuQ_ID, true)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuW_ID, true)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuE_ID, true)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuR_ID, true)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuF_ID, true)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuQ2_ID, false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuW2_ID, false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuE2_ID, false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuQ3_ID, false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuW3_ID, false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuE3_ID, false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuR2_ID, false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuF2_ID, false)
    endif
    call SaveInteger(hs, GetHandleId(c), StringHash("kit type"), check)
endfunction
function KenjakuQ_Start takes unit c returns nothing
    call KenjakuQ_KS.KenjakuQ_Start( c )
endfunction
function KenjakuQ2_Start takes unit c returns nothing
local integer hp
    local integer check = LoadInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"))
    local unit d = LoadUnitHandle(hs, GetHandleId(GetOwningPlayer(c)), StringHash("kenjaku unit q"))
    if d == null then
        set d = CreateUnit(GetOwningPlayer(c), KenjakuQ2_Dummy_ID, GetUnitX(c) + 250 * Cos((GetUnitFacing(c) + 35) * bj_DEGTORAD), GetUnitY(c) + 250 * Sin((GetUnitFacing(c) + 35) * bj_DEGTORAD), GetUnitFacing(c))
        call SaveUnitHandle(hs, GetHandleId(GetOwningPlayer(c)), StringHash("kenjaku unit q"), d)
        call KenjakuSummon_KS.KenjakuSummon_Start( c, d )
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuQ2_ID, false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuQ3_ID, true)
        call UnitAddAbility(c, KenjakuQ3_ID)
        call SetUnitAbilityLevel(c, KenjakuQ3_ID, GetUnitAbilityLevel(c, KenjakuQ_ID))
        call MakeSound("war3mapImported\\Hero_Kenjaku_Q2 1")
        set hp = KenjakuQ2_SummonHpBase + (KenjakuQ2_SummonHpStep * (GetUnitAbilityLevel(c, KenjakuQ_ID) - 1))
        if GetHeroLevel(c)>=35 then 
        set hp = hp + KenjakuF_BonusHpCreepAt35
        endif
        call BlzSetUnitMaxHP(d, hp)
        call SetHpCurrent(d, 999999)
            
        call UnitAddAbility(d, 'A05X')
        call SetUnitAbilityLevel(d, 'A05X', GetUnitAbilityLevel(c, KenjakuW_ID))
        call SetUnitMoveSpeed(d, KenjakuQ2_SummonMSBase + (KenjakuQ2_SummonMSStep * (GetUnitAbilityLevel(c, KenjakuQ_ID) - 1)))
        if BlzGetUnitAbilityCooldownRemaining(c, KenjakuW2_ID) == 0 then
            call OkarunEggCd(c,KenjakuW2_ID,KenjakuW2_CD_WhenOtherSpiritUse)
        endif
        if BlzGetUnitAbilityCooldownRemaining(c, KenjakuE2_ID) == 0 then
            call OkarunEggCd(c,KenjakuE2_ID,KenjakuE2_CD_WhenOtherSpiritUse)
        endif
        call SaveInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"), check - KenjakuQ2_CostCurse)
    endif
    set d = null
endfunction
function KenjakuQ3_Start takes unit c, real x, real y returns nothing
    call KenjakuQ2_KS.KenjakuQ2_Start( c, x, y )
endfunction
function KenjakuW_Start takes unit c, unit td returns nothing
    call KenjakuW_KS.KenjakuW_Start( c, td )
endfunction
function KenjakuW2_Start takes unit c returns nothing
    local integer check = LoadInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"))
    local integer hp = 0
    local unit d = LoadUnitHandle(hs, GetHandleId(GetOwningPlayer(c)), StringHash("kenjaku unit w"))
    if d == null then
        set d = CreateUnit(GetOwningPlayer(c), KenjakuW2_Dummy_ID, GetUnitX(c) + 250 * Cos(GetUnitFacing(c) * bj_DEGTORAD), GetUnitY(c) + 250 * Sin(GetUnitFacing(c) * bj_DEGTORAD), GetUnitFacing(c))
        call SaveUnitHandle(hs, GetHandleId(GetOwningPlayer(c)), StringHash("kenjaku unit w"), d)
        call KenjakuSummon_KS.KenjakuSummon_Start( c, d )
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuW2_ID, false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuW3_ID, true)
        call UnitAddAbility(c, KenjakuW3_ID)
        call UnitAddAbility(d, 'A05X')
        call SetUnitAbilityLevel(d, 'A05X', GetUnitAbilityLevel(c, KenjakuW_ID))            
        call SetUnitAbilityLevel(c, KenjakuW3_ID, GetUnitAbilityLevel(c, KenjakuW_ID))
        set hp = KenjakuW2_SummonHpBase + (KenjakuW2_SummonHpStep * (GetUnitAbilityLevel(c, KenjakuW_ID) - 1))
        if GetHeroLevel(c)>=35 then 
        set hp = hp + KenjakuF_BonusHpCreepAt35
        endif
        call BlzSetUnitMaxHP(d, hp)
        call SetHpCurrent(d, 999999)
        call SetUnitMoveSpeed(d, KenjakuW2_SummonMSBase + (KenjakuW2_SummonMSStep * (GetUnitAbilityLevel(c, KenjakuQ_ID) - 1)))
        call MakeSound("war3mapImported\\Hero_Kenjaku_W2 1")
        if BlzGetUnitAbilityCooldownRemaining(c, KenjakuQ2_ID) == 0 then
            call OkarunEggCd(c,KenjakuQ2_ID,KenjakuQ2_CD_WhenOtherSpiritUse)
        endif
        if BlzGetUnitAbilityCooldownRemaining(c, KenjakuE2_ID) == 0 then
            call OkarunEggCd(c,KenjakuE2_ID,KenjakuE2_CD_WhenOtherSpiritUse)
        endif
        call SaveInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"), check - KenjakuW2_CostCurse)
    endif
    set d = null
endfunction
function KenjakuW3_Start takes unit c, real x, real y returns nothing
    call KenjakuW2_KS.KenjakuW2_Start( c, x, y )
endfunction
function KenjakuE_Start takes unit c returns nothing
    call KenjakuE_KS.KenjakuE_Start( c)
endfunction
function KenjakuE2_Start takes unit c returns nothing
    local integer check = LoadInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"))
    local unit d = LoadUnitHandle(hs, GetHandleId(GetOwningPlayer(c)), StringHash("kenjaku unit e"))
    local integer hp = 0
    if d == null then
        set d = CreateUnit(GetOwningPlayer(c), KenjakuE2_Dummy_ID, GetUnitX(c) + 250 * Cos((GetUnitFacing(c) - 35) * bj_DEGTORAD), GetUnitY(c) + 250 * Sin((GetUnitFacing(c) - 35) * bj_DEGTORAD), GetUnitFacing(c))
        call SaveUnitHandle(hs, GetHandleId(GetOwningPlayer(c)), StringHash("kenjaku unit e"), d)
        call KenjakuSummon_KS.KenjakuSummon_Start( c, d )
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuE2_ID, false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c), KenjakuE3_ID, true)
        call UnitAddAbility(c, KenjakuE3_ID)
        set hp = KenjakuE2_SummonHpBase + (KenjakuE2_SummonHpStep * (GetUnitAbilityLevel(c, KenjakuE_ID) - 1))
        if GetHeroLevel(c)>=35 then 
        set hp = hp + KenjakuF_BonusHpCreepAt35
        endif
        call BlzSetUnitMaxHP(d, hp)
        call SetHpCurrent(d, 999999)
        call SetUnitMoveSpeed(d, KenjakuW2_SummonMSBase + (KenjakuW2_SummonMSStep * (GetUnitAbilityLevel(c, KenjakuQ_ID) - 1)))
        call UnitAddAbility(d, 'A05X')
        call SetUnitAbilityLevel(d, 'A05X', GetUnitAbilityLevel(c, KenjakuE_ID))
        call SetUnitAbilityLevel(c, KenjakuE3_ID, GetUnitAbilityLevel(c, KenjakuE_ID))
        call MakeSound("war3mapImported\\Hero_Kenjaku_E2 1")
        if BlzGetUnitAbilityCooldownRemaining(c, KenjakuW2_ID) == 0 then
            call OkarunEggCd(c,KenjakuW2_ID,KenjakuW2_CD_WhenOtherSpiritUse)
        endif
        if BlzGetUnitAbilityCooldownRemaining(c, KenjakuQ2_ID) == 0 then
            call OkarunEggCd(c,KenjakuQ2_ID,KenjakuQ2_CD_WhenOtherSpiritUse)
        endif
        call SaveInteger(hs, GetHandleId(c), StringHash("Kenjaku Stacks"), check - KenjakuE2_CostCurse)
    endif
    set d = null
endfunction
function KenjakuE3_Start takes unit c, real x, real y returns nothing
    call KenjakuE2_KS.KenjakuE2_Start( c, x, y )
endfunction
function KenjakuR_Start takes unit c, real x, real y returns nothing
    if LoadInteger(hs, GetHandleId(c), StringHash("activate r")) == 0 then
        call KenjakuR_KS.KenjakuR_Start( c, x, y )
    endif
endfunction
function KenjakuR2_Start takes unit c, real x, real y returns nothing
    call KenjakuR2_KS.KenjakuR2_Start( c, x, y )
endfunction
function KenjakuT_Start takes unit c, real x, real y returns nothing
    call KenjakuT_KS.KenjakuT_Start( c, x, y )
endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com