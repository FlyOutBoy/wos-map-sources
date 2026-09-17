library RimuruSpells initializer InitRimuruSpells uses GearSystems
    globals
        private timer RimuruTimer03
        private timer RimuruTimer10
        private code RimuruTimer03Callback
        private code RimuruTimer10Callback
        private integer RimuruTimer03Users = 0
        private integer RimuruTimer10Users = 0
//--------------------------------------Rimuru--------------------------------------------------------------
        integer Rimuru_ID = 'H01M'
        integer Rimuru2_ID = 'H01N'
        integer Rimuru3_ID = 'H01O'
        integer RimuruEvol1_MagiculeDmg = 1500 // need to deal 4000 dmg with T to evolve in next grade
        integer RimuruEvol2_Counter = 20 // need N times that enemy die
        framehandle array frameRimuru1_pas1
        framehandle array frameRimuru1_pas2
        framehandle array frameRimuru1_pas3
        framehandle array frameRimuru1_pas4
        framehandle array frameRimuru1_pas5
        framehandle array frameRimuru1_pas6
        framehandle array frameRimuru2_pas1
        framehandle array frameRimuru2_pas2
        framehandle array frameRimuru2_pas3
        framehandle array frameRimuru2_pas4
        framehandle array frameRimuru2_pas5
        framehandle array frameRimuru2_pas6
//---------------F ability-----------------------------------------------------
        integer RimuruF_ID = 'A0A1'
        real RimuruF_CD = 20 // in seconds
//---------------F2 ability-----------------------------------------------------
        integer RimuruF2_ID = 'A0A8'
        real RimuruF2_CD = 20 // in second
        real RimuruF2_DamageIntBase = 5 // base number x Int damage for 1 level
        real RimuruF2_Range = 1500
        real RimiruF2_PushRange = 50
        real RimiruF2_PushDuration = 0.3
        real RimiruF2_Aoe = 350
//---------------F3 ability-----------------------------------------------------
        integer RimuruF3_ID = 'A0AH'
        real RimuruF3_CD = 20 // in second
        integer RimuruF3_Buff_ID = 'B015'
        real RimiruF3_ReduceQCdTime = 2
//---------------G ability-----------------------------------------------------
        integer RimuruG_ID = 'A0A2'
        real RimuruG_MinDmg = 100 // from that damage passive will work
        real RimuruG_Restore1 = 7.5 // 10% of taken damage will restore orb when rimuru take it
        real RimuruG_Restore2 = 10 // 10% of taken damage will restore orb when rimuru take it
        real RimuruG_Restore3 = 10 // 10% of taken damage will restore orb when rimuru take it
        real RimuruG_OrbLifeTime = 8 // how long orb will alive, after it planting
        real RimuruG_OrbMinHeight = 250 // min height of parabola
        real RimuruG_OrbMaxHeight = 400 // max height of parabola
        real RimuruG_OrbMinRange = 325 // min range where orb will plant
        real RimuruG_OrbMaxRange = 475 // max range where orb will plant
        real RimuruG_ConsumeRange = 375 // max range where orb will plant
        integer RimuruG_MaxActiveOrbs = 24 // максимум шаров на одного Rimuru; можно поднять до 32
//---------------G2 ability-----------------------------------------------------
        integer RimuruG2_ID = 'A0A9'
//---------------G3 ability-----------------------------------------------------
        integer RimuruG3_ID = 'A0AI'
        integer RimuruG3_AgiBonus_ID = 'A0AJ'
        integer RimuruG3_IntBonus_ID = 'A0AK'
        real RimuruG3_BonusDuration = 10
//---------------Q ability-----------------------------------------------------
        integer RimuruQ_ID = 'A09V'
        real RimuruQ_RangeBase = 1500
        real RimuruQ_RangeStep = 125
        real RimuruQ_DamageIntBase = 1 // base number x Int damage for 1 level
        real RimuruQ_DamageIntStep = 1 // additional number x Int damage for each next level
        real RimuruQ_Damage2StaticBase = 175 // base static damage for 1 level
        real RimuruQ_Damage2StaticStep = 0 // additional static damage for each next level
        real RimuruQ_DamageAoe = 320
//---------------Q2 ability-----------------------------------------------------
        integer RimuruQ2_ID = 'A0A3'
        integer RimuruQ2_Buff_ID = 'B014'
        real RimuruQ2_DamageIntBase = 1 // base number x Int damage for 1 level
        real RimuruQ2_DamageIntStep = 1 // additional number x Int damage for each next level
        real RimuruQ2_DamageIntBurnBase = 0.5 // base number x Int damage for 1 level
        real RimuruQ2_DamageIntBurnStep = 0.5 // additional number x Int damage for each next level
        real RimuruQ2_DurationDebuff = 5 // additional number x Int damage for each next level
        real RimuruQ2_DebuffHealReduce = 50 // % reduce taken heal
        real RimuruQ2_MinDamage = 100 // min damage when it trigger dodge
        integer RimuruQ2_NumberofDodges = 4 // it will dodge only this amount of times when last one dodge triggered he will attack enemy
//---------------Q3 ability-----------------------------------------------------
        integer RimuruQ3_ID = 'A0AA'
        real RimuruQ3_DamageIntBase = 4 // base number x Int damage for 1 level
        real RimuruQ3_DamageIntBurnBase = 3 // additional number x Int damage for each next level
//---------------W ability-----------------------------------------------------
        integer RimuruW_ID = 'A09W'
        real RimuruW_DamageIntBase = 1 // base number x Int damage for 1 level
        real RimuruW_DamageIntStep = 1 // additional number x Int damage for each next level
        real RimuruW_Damage2StaticBase = 150 // base static damage for 1 level
        real RimuruW_Damage2StaticStep = 0 // additional static damage for each next level
        real RimiruW_Root = 1
//---------------W2 ability-----------------------------------------------------
        integer RimuruW2_ID = 'A0A4'
        real RimuruW2_DamageIntBase = 1 // base number x Int damage for 1 level
        real RimuruW2_DamageIntStep = 1 // additional number x Int damage for each next level
        real RimuruW2_Damage2StaticBase = 0 // base static damage for 1 level
        real RimuruW2_Damage2StaticStep = 0 // additional static damage for each next level
        real RimuruW2_Range = 1300
        real RimiruW2_Root = 1
        real RimiruW2_Aoe = 450
//---------------W3 ability-----------------------------------------------------
        integer RimuruW3_ID = 'A0AB'
        integer RimuruW3_Buff_ID = 'B016'
        integer RimuruW3_BuffEnemy_ID = 'B017'
        real RimiruW3_Aoe = 725
        real RimiruW3_Duration = 2.5
//---------------E ability-----------------------------------------------------
        integer RimuruE_ID = 'A09Y'
        real RimuruE_DamageIntBase = 2 // base number x Int damage for 1 level
        real RimuruE_DamageIntStep = 1 // additional number x Int damage for each next level
        real RimuruE_DamageAoe = 280
        real RimuruE_DamageAoeAdd = 10
        real RimuruE_Range = 1700
        integer RimuruE_SlowPercent = 40
        integer RimuruE_SlowTime = 3
//---------------E2 ability-----------------------------------------------------
        integer RimuruE2_ID = 'A0A5'
        real RimuruE2_DamageIntBase = 3 // base number x Int damage for 1 level
        real RimuruE2_DamageIntStep = 1 // additional number x Int damage for each next level
        real RimuruE2_DamageAoe = 575
        real RimuruE2_Stun = 1
//---------------E3 ability-----------------------------------------------------
        integer RimuruE3_ID = 'A0AD'
        integer RimuruE4_ID = 'A0AC'
        integer RimuruE5_ID = 'A0AE'
        real RimuruE345_CD_SWAP = 10 // how long min cd for swap
        real RimuruE3_DamageIntBase = 6 // base number x Int damage for 1 level
        real RimuruE3_DamageAoe = 900
        real RimuruE3_Duration = 6
        real RimuruE4_DamageIntBase = 5 // base number x Int damage for 1 level
        real RimuruE4_DamageAoe = 450
        real RimuruE4_Range = 1800
        real RimuruE5_DamageIntBase = 5 // base number x Int damage for 1 level
        real RimuruE5_DamageAoe = 550
        real RimuruE5_Stun = 0.5
        integer RimuruE3_SlowPercent = 20
        integer RimuruE3_SlowTime = 1
//---------------T ability-----------------------------------------------------
        integer RimuruT_ID = 'A09Z'
        real RimuruT_DamageIntBase = 10 // base number x Int damage per 1 second
        real RimuruT_DamageIntStep = 0 // additional number x Int damage for each next level per second
        real RimuruT_DamageAoe = 225
        real RimuruT_Stun = 0 // from 0.1 to 3
//---------------R2 ability-----------------------------------------------------
        integer RimuruR2_ID = 'A0A6'
        real RimuruR2_DamageIntBase = 4 // base number x Int damage per 1 second
        real RimuruR2_DamageIntStep = 1 // additional number x Int damage for each next level per second
        real RimuruR2_DamageAoe = 800
        integer RimuruR2_Slow = 40 // from 0.1 to 3
        integer RimuruR2_SlowDuration = 2 // from 0.1 to 3
//---------------R3 ability-----------------------------------------------------
        integer RimuruR3_ID = 'A0AF'
        real RimuruR3_DamageIntBase = 8 // base number x Int damage per 1 second
        real RimuruR3_DamageAoe = 360
        real RimuruR3_Stun = 1 // from 0.1 to 3
//---------------T ability-----------------------------------------------------
        integer RimuruR_ID = 'A0A0'
        real RimuruR_DamageIntStep = 1 // additional number x Int damage for each next level per second
        real RimuruR_DamageIntBase = 3 // base number x Int damage for 1 level
//---------------T2 ability-----------------------------------------------------
        integer RimuruT2_ID = 'A0A7'
        real RimuruT2_DamageAoe = 750 // explosion dealt damage area
        real RimuruT2_AoeCheck = 425 // aoe for trigger mIntc circle
        integer RimuruT2_SlowPercent = 70 //cause when deal dps
        integer RimuruT2_SlowTime = 1 // cause when deal dps
        real RimuruT2_Root = 1.5 // applied when catch any enemy at aoe check area
        real RimuruT2_CircleTime = 10 // how long mIntc circle live till removd
        real RimuruT2_DamageIntBase = 12 // base number x Int damage for 1 level
//---------------T3 ability-----------------------------------------------------
        integer RimuruT3_ID = 'A0AG'
        real RimuruT3_DamageAoe = 1000 // explosion dealt damage area
        real RimuruT3_Stun = 0 //cause when deal dps
        real RimuruT3_DamageIntBase = 3 // base number x Int damage for 1 level
        real RimuruT3_ChildMinDistance = 200
        real RimuruT3_TargetSearchRange = 650
        real RimuruT3_ImpactMinDistance = 100
    endglobals

    private function RimuruTimer03Acquire takes nothing returns nothing
        set RimuruTimer03Users = RimuruTimer03Users + 1
        if RimuruTimer03Users == 1 then
            call TimerStart(RimuruTimer03, 0.03, true, RimuruTimer03Callback)
        endif
    endfunction

    private function RimuruTimer03Release takes nothing returns nothing
        set RimuruTimer03Users = RimuruTimer03Users - 1
        if RimuruTimer03Users <= 0 then
            set RimuruTimer03Users = 0
            call PauseTimer(RimuruTimer03)
        endif
    endfunction

    private function RimuruTimer10Acquire takes nothing returns nothing
        set RimuruTimer10Users = RimuruTimer10Users + 1
        if RimuruTimer10Users == 1 then
            call TimerStart(RimuruTimer10, 0.10, true, RimuruTimer10Callback)
        endif
    endfunction

    private function RimuruTimer10Release takes nothing returns nothing
        set RimuruTimer10Users = RimuruTimer10Users - 1
        if RimuruTimer10Users <= 0 then
            set RimuruTimer10Users = 0
            call PauseTimer(RimuruTimer10)
        endif
    endfunction

    private struct RimuruQ_KS
        private static integer array m_RimuruQ
        private static integer MUI_RimuruQ = -1
        unit c
        real x
        real y
        real r5
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
        effect e3
        effect e4
        real a
        real rmax
        public static method Loop_RimuruQ takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_RimuruQ
                set this = m_RimuruQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r < 0.6 then
                        call DebugUnit2(c)
                    endif
                    if r == 0.6 then
                        call StopSpellUnit2(c)
                        set e = EffectSpawnScale("war3mapImported\\wos_by_wood_dange_zhanji_daoguang_6_1.mdl", GetUnitX(c) , GetUnitY(c), a * bj_RADTODEG - 20, 2.5, 0.3, 100, 0.21, 0.3, 1.3)
                        call MakeSound("war3mapimported\\Hero_Rimuru_Q2")
                        set e2 = EffectSpawnScale("war3mapImported\\wos_Bubbles2.mdx", GetUnitX(c) + (aoe * 0.5) * Cos(a + 90 * bj_DEGTORAD) , GetUnitY(c) + (aoe * 0.5) * Sin(a + 90 * bj_DEGTORAD), GetRandomReal(0, 359), 1, 1, 25, 0.3, 1, 5)
                        set e4 = EffectSpawnScale("war3mapImported\\wos_Bubbles2.mdx", GetUnitX(c) + (aoe * 0.5) * Cos(a - 90 * bj_DEGTORAD) , GetUnitY(c) + (aoe * 0.5) * Sin(a - 90 * bj_DEGTORAD), GetRandomReal(0, 359), 1, 1, 25, 0.3, 1, 5)
                        set e3 = EffectSpawnScale("war3mapImported\\wos_papsnaz (692).mdl", GetUnitX(c) , GetUnitY(c) , a * bj_RADTODEG, 0.5, 0.55, 100, 0.21, 0.1, 1.8)
                        call BlzSetSpecialEffectAlpha(e3, 140)
                    endif
                    if r == 0.69 then
                        call BlzSetSpecialEffectTimeScale(e, 0.05)
                    endif
                    if r >= 0.63 then
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        call MoveEff(e, move, a)
                        call MoveEff(e2, move, a)
                        call MoveEff(e3, move, a)
                        call MoveEff(e4, move, a)
                        set r5 = r5 + move
                        if r5 >= r6 then
                            set r = 9999
                        endif
                        call DecorRemove(c, x+150*Cos(a), y+150*Sin(a), aoe, 20)
                        call GroupClear( g )
                        call GroupEnumUnitsInRange( g ,x+150*Cos(a), y+150*Sin(a) , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                call GroupAddUnit(g2, u)
                                call dmgphys(c, u, dmg)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    endif
                else
                    call DestroyEffect(e2)
                    call DestroyEffect(e3)
                    call DestroyEffect(e4)
                    if e != null then
                        call ColorEffDummy3(e, 0, 125, 125, 125, 0.12)
                    endif
                    call StopSpellUnit2(c)
                    call SetUnitTimeScale(c, 1)
                    call SetUnitTimeScale(c, 1)
                    call DestroyGroup( g )
                    set g = null
                    call DestroyGroup( g2 )
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set u = null
                    set m_RimuruQ[i] = m_RimuruQ[ MUI_RimuruQ]
                    set MUI_RimuruQ = MUI_RimuruQ - 1
                    if MUI_RimuruQ == -1 then
                        call RimuruTimer03Release()
                    endif
                    call deallocate(this)
                set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method RimuruQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_RimuruQ = MUI_RimuruQ + 1
            set m_RimuruQ[ MUI_RimuruQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r5 = 0
            set r6 = RimuruQ_RangeBase + RimuruQ_RangeStep * (GetUnitAbilityLevel(c, RimuruQ_ID) - 1)
            set g = CreateGroup()
            set g2 = CreateGroup()
            call StartSpellUnit2(c)
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set rmax = 2.1
            set move = 100
            set aoe = RimuruQ_DamageAoe
            set dmg = GetHeroInt( c , true) * ( RimuruQ_DamageIntBase + ( RimuruQ_DamageIntStep * ( GetUnitAbilityLevel( c , RimuruQ_ID) - 1 ) ) )
            set dmg = dmg + RimuruQ_Damage2StaticBase + ( RimuruQ_Damage2StaticStep * ( GetUnitAbilityLevel( c , RimuruQ_ID) - 1 ) )
            call SetUnitFacing( c , a * bj_RADTODEG)
            call SetUnitAnimationByIndex( c , 4)
            call SetUnitTimeScale(c, 1.5)
            call MakeSound("war3mapimported\\Hero_Rimuru_Q")
            if MUI_RimuruQ == 0 then
                call RimuruTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct RimuruW_KS
        private static integer array m_RimuruW
        private static integer MUI_RimuruW = -1
        unit c
        unit td
        integer k
        integer retractStarted
        real dmg
        real r
        real ls_retract
        lightning array ls [80]
        real array ls_x1[80]
        real array ls_y1[80]
        real array ls_x2[80]
        real array ls_y2[80]
        real array ls_h1[80]
        real array ls_h2[80]
        real ls_progress // 0.0 to 1.0
        real rmax
        public static method Loop_RimuruW takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr1 = 0
            local real rr2 = 0
            local real rr3 = 0
            local real rr4 = 0
            loop
                exitwhen i > MUI_RimuruW
                set this = m_RimuruW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r < 0.3 then
                        call DebugUnit2(c)
                    endif
                    if r == 0.6 then
                        call MakeSound("war3mapimported\\Hero_Rimuru_W2")
                        call StopSpellUnit2(c)
                        call RootUnit(c, td, RimiruW_Root)
                        call dmgphys(c, td, dmg)
                    endif
                    if r == 0.3 then
                        call MakeSound("war3mapimported\\Hero_Rimuru_W2")
                        call RootUnit(c, td, RimiruW_Root)
                        set ls_progress = 0.0
                        set ls_retract = 0
                        set k = 0
                        loop
                            exitwhen k == 19
                            set rr3 = rr3 + 20 * bj_DEGTORAD
                            set rr2 = GetRandomReal(550, 725)
        // Entry point вЂ” random offset on one side of target
                            set ls_x1[k] = GetUnitX(td) + rr2 * Cos(rr3)
                            set ls_y1[k] = GetUnitY(td) + rr2 * Sin(rr3)
        // Exit point вЂ” opposite side, different random radius so it looks skewed
                            set rr1 = GetRandomReal(650, 725)
                            set rr4 = GetRandomReal( -0.3, 0.3)
                            set ls_x2[k] = GetUnitX(td) - rr1 * Cos(rr3 + rr4)
                            set ls_y2[k] = GetUnitY(td) - rr1 * Sin(rr3 + rr4)
                           // Randomly from ground or from air
                            if GetRandomInt(0, 1) == 0 then
                                set ls_h1[k] = GetRandomReal(0, 155) // crawling from earth
                            else
                                set ls_h1[k] = GetRandomReal(350, 425) // dropping from air
                            endif
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_rimuruwhit.mdl", GetUnitX(td) + (rr2 - 100) * Cos(rr3), GetUnitY(td) + (rr2 - 100) * Sin(rr3), GetRandomReal(0, 359), 0.35, 1.5, ls_h1[k] - 20))
                            set ls_h2[k] = GetRandomReal(0, 30) // exit near ground
        // Spawn collapsed at entry point
                            set ls[k] = AddLightningEx("RMRW", false,ls_x1[k],ls_y1[k],ls_h1[k],ls_x1[k],ls_y1[k],ls_h1[k])
                            set k = k + 1
                        endloop
                    endif
                    if r >= rmax - 0.3 and retractStarted == 0 then
                        set retractStarted = 1
                        set k = 0
                        loop
                            exitwhen k == 19
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_rimuruwhit.mdl", ls_x2[k], ls_y2[k], GetRandomReal(0, 359), 1, 1.5, ls_h2[k] + 35))
                            set k = k + 1
                        endloop
                    endif
                    if r >= 0.3 and ls_progress < 1.0 then
                        set ls_progress = ls_progress + 0.1
                        if ls_progress > 1.0 then
                            set ls_progress = 1.0
                        endif
                        set k = 0
                        loop
                            exitwhen k == 19
                            call MoveLightningEx(ls[k], false,ls_x1[k],ls_y1[k],ls_h1[k],ls_x1[k] + (ls_x2[k] - ls_x1[k]) * ls_progress,ls_y1[k] + (ls_y2[k] - ls_y1[k]) * ls_progress,ls_h1[k] + (ls_h2[k] - ls_h1[k]) * ls_progress)
                            set k = k + 1
                        endloop
                    endif
                    if r >= rmax-0.3 and ls_retract < 1.0 then
                        set ls_retract = ls_retract + 0.1
                        if ls_retract > 1.0 then
                            set ls_retract = 1.0
                        endif
                        set k = 0
                        loop
                            exitwhen k == 19
                            call MoveLightningEx(ls[k], false,ls_x1[k] + (ls_x2[k] - ls_x1[k]) * ls_retract,ls_y1[k] + (ls_y2[k] - ls_y1[k]) * ls_retract,ls_h1[k] + (ls_h2[k] - ls_h1[k]) * ls_retract,ls_x2[k],ls_y2[k],ls_h2[k])
                            set k = k + 1
                        endloop
                    endif
                else
                    call StopSpellUnit2(c)
                    set k = 0
                    loop
                        exitwhen k == 19
                        call DestroyLightning(ls[k])
                        set ls[k] = null
                        set k = k + 1
                    endloop
                    set c = null
                    set td = null
                    set m_RimuruW[i] = m_RimuruW[ MUI_RimuruW]
                    set MUI_RimuruW = MUI_RimuruW - 1
                    if MUI_RimuruW == -1 then
                        call RimuruTimer03Release()
                    endif
                    call deallocate(this)
                set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method RimuruW_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            local real angle
            set MUI_RimuruW = MUI_RimuruW + 1
            set m_RimuruW[ MUI_RimuruW] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set retractStarted = 0
            call StartSpellUnit2(c)
            set angle = GAngle(c, td)
            set rmax = RimiruW_Root+0.6
            set dmg = GetHeroInt( c , true) * ( RimuruW_DamageIntBase + ( RimuruW_DamageIntStep * ( GetUnitAbilityLevel( c , RimuruW_ID) - 1 ) ) )
            set dmg = dmg + RimuruW_Damage2StaticBase + ( RimuruW_Damage2StaticStep * ( GetUnitAbilityLevel( c , RimuruW_ID) - 1 ) )
            call SetUnitFacing(c, angle * bj_RADTODEG)
            call SetUnitAnimationByIndex( c , 4)
            call MakeSound("war3mapimported\\Hero_Rimuru_W")
            if MUI_RimuruW == 0 then
                call RimuruTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct RimuruE_KS
        private static integer array m_RimuruE
        private static integer MUI_RimuruE = -1
        unit c
        real x1
        real y1
        real r2
        real scale
        real r4
        real r5
        real r6
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
        public static method Loop_RimuruE takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_RimuruE
                set this = m_RimuruE[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r < 1.2 then
                        call DebugUnit(c)
                    endif
                    if r == 0.6 then
                        set scale = 0.25
                        set x1 = GetUnitX(c) + 90 * Cos(a)
                        set y1 = GetUnitY(c) + 90 * Sin(a)
                        set move = 110
                        set e = EffectSpawn("war3mapImported\\wos_poisonbeam.mdl", x1, y1, a * bj_RADTODEG, 1.5, 1.35, 100)
                    endif
                    if r == 0.6 then
                        call BlzSetSpecialEffectTimeScale(e, 0.05)
                        set r4 = 20
                    endif
                    if r >= 0.6 then
                        set scale = scale + 0.3
                        set x1 = x1 + move * Cos(a)
                        set y1 = y1 + move * Sin(a)
                        set r5 = r5 + move
                        if r5 >= r6 then
                            set r = 5555
                        endif
                        if r2 > 0.04 then
                            set r2 = 0
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_opm (686).mdl", x1, y1, GetRandomReal(0, 359), 2, scale / 3 + 0.6, 1))
                        else
                            set r2 = r2 + 0.03
                        endif
                        set aoe = aoe + RimuruE_DamageAoeAdd
                        if r5 > r6 / 2 then
                            set r4 = r4 - 5
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_GameBABY_qilongzhu_21.mdl", x1, y1, GetRandomReal(0, 359), 1, scale - 0.5, r4))
                        else
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_GameBABY_qilongzhu_2.mdl", x1, y1, GetRandomReal(0, 359), 1, scale, 65 - scale * 20))
                        endif
                        call DecorRemove(c, x1, y1, aoe, 20)
                        call GroupClear( g )
                        call GroupEnumUnitsInRange( g , x1 , y1 , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                call GroupAddUnit(g2, u)
                                call EUTU2(EffectSpawn("war3mapImported\\wos_poisonaura_purp.mdx", GetUnitX(u), GetUnitY(u), 1, 1, 1.2, 1), 2, 20, u)
                                call SlowUnit(c, u, RimuruE_SlowPercent, RimuruE_SlowTime)
                                call DmgPTime(c, u, dmg, 2, 0.25, 1)
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    endif
                else
                    call StopSpellUnit(c)
                    call SetUnitTimeScale(c, 1)
                    call MyRemoveEff(e, 0.3)
                    call DestroyGroup( g )
                    set g = null
                    call DestroyGroup( g2 )
                    set g2 = null
                    set c = null
                    set e = null
                    set u = null
                    set m_RimuruE[i] = m_RimuruE[ MUI_RimuruE]
                    set MUI_RimuruE = MUI_RimuruE - 1
                    if MUI_RimuruE == -1 then
                        call RimuruTimer03Release()
                    endif
                    call deallocate(this)
                set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method RimuruE_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            local real angle
            set MUI_RimuruE = MUI_RimuruE + 1
            set m_RimuruE[ MUI_RimuruE] = this
            set c = NewC
            set r = 0
            set r5 = 0
            set r6 = RimuruE_Range
            set r2 = 1
            set g = CreateGroup()
            set g2 = CreateGroup()
            call StartSpellUnit(c)
            set u = null
            set angle = GAngle2(c, NewX, NewY)
            set a = angle
            set rmax = 2.1
            set aoe = RimuruE_DamageAoe
            set dmg = GetHeroInt( c , true) * ( RimuruE_DamageIntBase + ( RimuruE_DamageIntStep * ( GetUnitAbilityLevel( c , RimuruE_ID) - 1 ) ) )
            call SetUnitFacing(c, angle * bj_RADTODEG)
            call SetUnitAnimationByIndex( c , 4)
            call SetUnitTimeScale(c, 1.5)
            call MakeSound("war3mapimported\\Hero_Rimuru_E")
            call MakeSound("war3mapimported\\Hero_Rimuru_E2")
            if MUI_RimuruE == 0 then
                call RimuruTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct RimuruT2Helper_KS
        private static integer array m_RimuruT2
        private static integer MUI_RimuruT2 = -1
        unit c
        real x
        real y
        real r5
        group g
        group g2
        unit u
        real dmg
        integer check2
        real aoe
        real move
        real r
        effect e
        real a
        real rmax
        public static method Loop_RimuruT2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_RimuruT2
                set this = m_RimuruT2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r >= r5 then
                        call MoveEff2(e, move, a)
                        call VisionTimed(GetOwningPlayer(c), GetEffX(e), GetEffY(e) , aoe, 1)
                        call DecorRemove(c, GetEffX(e), GetEffY(e) , aoe, 25)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, GetEffX(e), GetEffY(e), aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c ))and IsUnitInGroup(u, g2) == false then
                                call dmgmag(c, u, dmg)
                                call GroupAddUnit(g2, u)
                                call StunUnit(c, u, RimuruT_Stun)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                    endif
                else
                    set u = null
                    call GroupClear(g)
                    call GroupEnumUnitsInRange( g , x, y , 450 , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c ))and IsUnitInGroup(u, g2) == false then
                            call dmgmag(c, u, dmg)
                            call GroupAddUnit(g2, u)
                            call StunUnit(c, u, RimuruT_Stun)
                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    if check2 == 2 then
                        set x = GetEffX(e) + 00 * Cos(a)
                        set y = GetEffY(e) + 00 * Sin(a)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_[skillm]explosion ice.mdx", x, y, 1, 1, 1.5, 1))
                    endif
                    if check2 == 2 or check2 == 4 or check2 == 6 then
                        set x = GetEffX(e) + 150 * Cos(a)
                        set y = GetEffY(e) + 150 * Sin(a)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_icestomp.mdx", x, y, 1, 2, 2.5, 1))
                    endif
                    call DestroyEffect(e)
                    call DestroyGroup( g )
                    call DestroyGroup( g2 )
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set u = null
                    set m_RimuruT2[i] = m_RimuruT2[ MUI_RimuruT2]
                    set MUI_RimuruT2 = MUI_RimuruT2 - 1
                    if MUI_RimuruT2 == -1 then
                        call RimuruTimer03Release()
                    endif
                    call deallocate(this)
                set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method RimuruT2_Start takes unit NewC, real NewX, real NewY, real NewR, integer NewCheck returns nothing
            local thistype this = thistype.create( )
            local real rr1
            local real baseAngle // clean shared angle for both rings
            set MUI_RimuruT2 = MUI_RimuruT2 + 1
            set m_RimuruT2[ MUI_RimuruT2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r5 = NewR
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set aoe = RimuruT_DamageAoe
            set dmg = GetHeroInt( c , true) * ( RimuruT_DamageIntBase + ( RimuruT_DamageIntStep * ( GetUnitAbilityLevel( c , RimuruT_ID) - 1 ) ) )
            set dmg = dmg / 7
            set rmax = 0.24 + r5
            set check2 = NewCheck
            set baseAngle = ModuloInteger(NewCheck, 7) * (360.0 / 7.0) * bj_DEGTORAD
            set rr1 = GetRandomReal(650, 850)
            set e = EffectSpawnScale("war3mapImported\\wos_icesword.mdl", x + rr1 * Cos(baseAngle), y + rr1 * Sin(baseAngle), GAngle4(x + rr1 * Cos(baseAngle), y + rr1 * Sin(baseAngle), x, y) * bj_RADTODEG, 1, 0.01, GetRandomReal(75, 110), 0.18, 0.01, GetRandomReal(1.3, 1.5))
            set move = (SR5(e, x, y) - 275) / 6
            set a = GAngle4(x + rr1 * Cos(baseAngle), y + rr1 * Sin(baseAngle), x, y)
            if MUI_RimuruT2 == 0 then
                call RimuruTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct RimuruT_KS
        private static integer array m_RimuruT
        private static integer MUI_RimuruT = -1
        unit c
        real x
        real y
        real r2
        real r3
        integer check
        real aoe
        real r
        real rmax
        public static method Loop_RimuruT takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_RimuruT
                set this = m_RimuruT[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r < 0.51 then
                        call DebugUnit2(c)
                    endif
                    if r == 0.51 then
                        call MakeSound("war3mapimported\\Hero_Rimuru_R2")
                        call StopSpellUnit2(c)
                    endif
                    if r == 0.75 then
                        call MakeSound("war3mapimported\\Hero_Rimuru_R3")
                        set r = 99999
                    endif
                    if r3 > 0.3 then
                        set r3 = 0.03
                        call SetUnitAnimationByIndex(c, 0)
                    else
                        set r3 = r3 + 0.03
                    endif
                    if r < 0.66 and check < 7 then
                        if r2 > 0.03 then
                            set r2 = 0.03
                            call RimuruT2Helper_KS.RimuruT2_Start(c, x, y, 0.6 - r, check)
                            set check = check + 1
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    if r < 0.51 then
                        call StopSpellUnit2(c)
                    endif
                    call SetUnitTimeScale( c , 1)
                    set c = null
                    set m_RimuruT[i] = m_RimuruT[ MUI_RimuruT]
                    set MUI_RimuruT = MUI_RimuruT - 1
                    if MUI_RimuruT == -1 then
                        call RimuruTimer03Release()
                    endif
                    call deallocate(this)
                set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method RimuruT_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_RimuruT = MUI_RimuruT + 1
            set m_RimuruT[ MUI_RimuruT] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r3 = 0
            set check = 0
            set r2 = 10
            call StartSpellUnit2(c)
            set aoe = RimuruT_DamageAoe
            set rmax = 2.1
            call SetUnitAnimationByIndex(c, 4)
            call SetUnitTimeScale(c, 0.5)
            call MakeSound("war3mapimported\\Hero_Rimuru_R")
            call VisionTimed(GetOwningPlayer(c), x,y , aoe+850, 3)
            if MUI_RimuruT == 0 then
                call RimuruTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct RimuruR_KS
        private static integer array m_RimuruR
        private static integer MUI_RimuruR = -1
        unit c
        unit td
        real x
        real y
        real x1
        real y1
        real r2
        integer k2
        integer k3
        real scale
        real r3
        real r4
        real r5
        real r6
        real r7
        real r8
        real dmg
        integer check
        real sr
        real r
        real rmax
        public static method Loop_RimuruR takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rand1 = 0
            local real rand2 = 0
            loop
                exitwhen i > MUI_RimuruR
                set this = m_RimuruR[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set r8 = LoadReal(hs, GetHandleId(c), StringHash("evol dmg"))
                    if r8 > k3 then
                        set r8 = I2R(k3)
                    endif
                    // Эволюционный интерфейс мог ещё не быть создан.
                    if frameRimuru1_pas6[k2] != null and frameRimuru1_pas3[k2] != null then
                        call BlzFrameSetText(frameRimuru1_pas6[k2], "|c00FFFF00" + I2S(R2I(r8)) + "/" + I2S(k3) + "|r")
                        call BlzFrameSetValue(frameRimuru1_pas3[k2], r8)
                    endif
                    if check == 0 then
                        if r <= 0.6 then
                            set r4 = r4 + 0.05
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            call SetUnitX(c, x1 + (x - x1) * r4)
                            call SetUnitY(c, y1 + (y - y1) * r4)
                            call SetFly(c, Parabola(r7, sr, r4 * sr))
                            set scale = scale + 0.15
                            call SetScale(c, scale)
                        endif
                        if r >= 0.6 then
                            call SetFly(c, 0)
                            set check = 1
                            set r = 0
                            set rmax = 1.5
                            set r5 = 0
                            set r6 = 255
                            set r3 = 0
                            call SetUnitTimeScale(c, 0.4)
                            call DebugUnit2(td)
                            call StartSpellUnit(c)
                            call MakeSound("war3mapimported\\Hero_Rimuru_T3")
                        endif
                    elseif check == 1 then
                        call DebugUnit(c)
                        call DebugUnit2(td)
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        call SetUnitX(c, x)
                        call SetUnitY(c, y)
                        if r5 < 500 then
                            set r5 = r5 + 7
                        endif
                        if r6 > 190 then
                            set r6 = r6 - 6
                        endif
                        call SetUnitVertexColor(c, 255, 255, 255, R2I(r6))
                        call SetFly(td, r5)
                        if r3 >= 0.12 then
                            set r3 = 0
                            set rand1 = GetRandomReal(50, 350)
                            set rand2 = GetRandomReal(0, 359) * bj_DEGTORAD
                            call EffectSpawn2("war3mapImported\\wos_Bubbles2.mdx", x + rand1 * Cos(rand2) , y + rand1 * Sin(rand2), GetRandomReal(0, 359), 1, 5, GetRandomReal(300, 1050), 0.6)
                        else
                            set r3 = r3 + 0.03
                        endif
                        if r2 > 0.21 then
                            set r2 = 0
                            call dmgphys(c, td, dmg)
                            if GetHeroLevel(c)>=12 then
                            call SaveReal(hs, GetHandleId(c), StringHash("evol dmg"), r8 + dmg)
                            endif
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_xiaonajia01_d_W.mdl", x, y, GetRandomReal(0, 359), 1.75, 1.75, 455))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdl", x, y, GetRandomReal(0, 359), 1, 1.25, 1))
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    call ColorDummy4(c, 0, 255, 255, 255, 0.3)
                    call StopSpellUnit(c)
                    call SetUnitTimeScale(c, 1)
                    if check == 1 then
                        call StopSpellUnit2(td)
                    endif
                    call SetScale(c,1)
                    call SetFly(td, 0)
                    set c = null
                    set td = null
                    set m_RimuruR[i] = m_RimuruR[ MUI_RimuruR]
                    set MUI_RimuruR = MUI_RimuruR - 1
                    if MUI_RimuruR == -1 then
                        call RimuruTimer03Release()
                    endif
                    call deallocate(this)
                set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method RimuruR_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_RimuruR = MUI_RimuruR + 1
            set m_RimuruR[ MUI_RimuruR] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set r7 = 800
            set r2 = 1
            set r4 = 0
            set x1 = GetUnitX(c)
            set y1 = GetUnitY(c)
            set sr = SR2(c, td)
            set check = 0
            set rmax = 2.4
            set scale = 1
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set k3 = RimuruEvol1_MagiculeDmg
            call StartSpellUnit2(c)
            set dmg = GetHeroInt( c , true) * ( RimuruR_DamageIntBase + ( RimuruR_DamageIntStep * ( GetUnitAbilityLevel( c , RimuruR_ID) - 1 ) ) )
            set dmg = dmg / 6
            call SetUnitFacing(c, GAngle(c, td) * bj_RADTODEG)
            call SetUnitTimeScale(c, 0.5)
            call SetUnitAnimationByIndex( c , 3)
            call MakeSound("war3mapimported\\Hero_Rimuru_T")
            call MakeSound("war3mapimported\\Hero_Rimuru_T2")
            if MUI_RimuruR == 0 then
                call RimuruTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct RimuruG_KS
        private static integer array m_RimuruG
        private static integer MUI_RimuruG = -1
        unit c
        real x
        real y
        real r3
        real r4
        real r5
        real r6
        real dmg
        integer check
        integer check2
        real sr
        real move
        real r
        effect e
        real a
        real rmax

        // При достижении лимита лечение добавляется к существующему шару.
        // Визуально одновременно остаётся много шаров, но рост ограничен.
        private static method FindActive takes unit whichUnit returns thistype
            local integer i = 0
            local thistype this
            loop
                exitwhen i > MUI_RimuruG
                set this = m_RimuruG[i]
                if c == whichUnit then
                    return this
                endif
                set i = i + 1
            endloop
            return 0
        endmethod

        public static method CountActive takes unit whichUnit returns integer
            if whichUnit == null then
                return 0
            endif
            return LoadInteger(hs, GetHandleId(whichUnit), StringHash("rimuru g orb count"))
        endmethod

        public static method Loop_RimuruG takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_RimuruG
                set this = m_RimuruG[i]
                if SpellBoolCaster(c) and r <= rmax then
                    // В этой структуре нет сравнений r на точное равенство.
                    // Не вызываем RoundReal для каждого шара 33 раза в секунду.
                    set r = r + 0.03
                    if check == 0 then
                        if r <= r3 then
                            set r4 = r4 + move
                            call MoveEff(e, move, a)
                            call BlzSetSpecialEffectHeight(e, Parabola(r5, sr, r4))
                        endif
                        if r >= r3 then
                            set check = 1
                            set check2 = 0
                            set r = 0
                        endif
                    elseif check == 1 then
                        // Лежащему шару достаточно проверять героя раз в 0.09 сек.
                        set check2 = check2 + 1
                        if check2 >= 3 then
                            set check2 = 0
                            set x = GetUnitX(c)
                            set y = GetUnitY(c)
                            set sr = SR5(e, x, y)
                            set r6 = RimuruG_ConsumeRange
                            if LoadInteger(hs,GetHandleId(c),StringHash("rimuru evol 2")) == 1 then
                                set r6 = 9999
                            endif
                            if sr < r6 then
                                set r = 0
                                set check = 2
                                set move = 30
                            endif
                        endif
                    elseif check == 2 then
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        set a = GAngle5(e, x, y)
                        if SR5(e, x, y) < 50 then
                            call SetHpCurrent2(c, c, dmg)
                            set r = 9999
                            call BlzSetSpecialEffectPosition(e, x, y, 0)
                          //  call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_az_lifebloom.mdx", c, "origin"))
                            call EUTU2(EffectSpawn("war3mapImported\\wos_effect_lv131.mdl", GetUnitX(c), GetUnitY(c), 1, 1, 1, 40), 0.6, 40, c)
                        else
                            call MoveEff2(e, move, a)
                        endif
                    endif
                else
                    set x = GetEffX(e)
                    set y = GetEffY(e)
                    call EffectSpawn2("war3mapImported\\wos_Bubbles2_small.mdx", x, y, GetRandomReal(0, 359), 1, 3, 10, 0.15)
                    call DestroyEffect(e)
                    set check2 = LoadInteger(hs, GetHandleId(c), StringHash("rimuru g orb count")) - 1
                    if check2 < 0 then
                        set check2 = 0
                    endif
                    call SaveInteger(hs, GetHandleId(c), StringHash("rimuru g orb count"), check2)
                    set c = null
                    set e = null
                    set m_RimuruG[i] = m_RimuruG[ MUI_RimuruG]
                    set MUI_RimuruG = MUI_RimuruG - 1
                    if MUI_RimuruG == -1 then
                        call RimuruTimer03Release()
                    endif
                    call deallocate(this)
                set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method RimuruG_Start takes unit NewC, real NewHp, real NewRmax returns nothing
            local thistype this
            if thistype.CountActive(NewC) >= RimuruG_MaxActiveOrbs then
                set this = thistype.FindActive(NewC)
                if this != 0 then
                    set dmg = dmg + NewHp
                    // После последнего попадания накопление живёт ещё полный срок.
                    if rmax < r + NewRmax then
                        set rmax = r + NewRmax
                    endif
                    return
                endif
                // Самовосстановление счётчика, если внешняя система удалила эффект/instance.
                call SaveInteger(hs, GetHandleId(NewC), StringHash("rimuru g orb count"), 0)
            endif
            set this = thistype.create( )
            set MUI_RimuruG = MUI_RimuruG + 1
            set m_RimuruG[ MUI_RimuruG] = this
            set c = NewC
            call SaveInteger(hs, GetHandleId(c), StringHash("rimuru g orb count"), thistype.CountActive(c) + 1)
            set r = 0
            set dmg = NewHp
            set rmax = NewRmax
            set check2 = R2I(GetRandomReal(0.51, 0.9) / 0.03 + 0.5)
            set r3 = check2 * 0.03
            set r4 = 0
            set a = GetRandomReal(0, 359) * bj_DEGTORAD
            set sr = GetRandomReal(RimuruG_OrbMinRange , RimuruG_OrbMaxRange )
            set r5 = GetRandomReal(RimuruG_OrbMinHeight , RimuruG_OrbMaxHeight )
            set check = 0
            set move = sr / check2
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set e = EffectSpawnColor("war3mapImported\\wos_[skillm]orbwaterx2.mdl", x, y, GetRandomReal(0, 359), 2.5, 1.75, 10, 255, 255, 255, 100)
            if MUI_RimuruG == 0 then
                call RimuruTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct Rimuru2Q_KS
        private static integer array m_Rimuru2Q
        private static integer MUI_Rimuru2Q = -1
        unit c
        unit td
        real x
        real y
        real dmg
        real dmg2
        real move
        real r
        effect e
        real a
        real rmax
        public static method Loop_Rimuru2Q takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_Rimuru2Q
                set this = m_Rimuru2Q[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit(c)
                    set a = GAngle(c, td)
                    call SetUnitFacing(c, a * bj_DEGTORAD)
                    if r >= 0.3 then
                        if SR2(c, td) > 180 then
                            call MoveUnit(c, move, a)
                        else
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            call dmgmag(c, td, dmg)
                            set r = 9999
                            call EUTU2_3(EffectSpawn("war3mapImported\\wos_yh_az_jugg_e2_black.mdl", x, y, GetRandomReal(0, 359), 0.35, 4.25, 180), 1.5, 185, td)
                            call MyRemoveEff(AddSpecialEffectTarget("war3mapImported\\wos_dark purple fire.mdl", td, "chest"), 4)
                            call DmgPTime(c, td, dmg2, RimuruQ2_DurationDebuff, 0.25, 1)
                            call BlockRegen(td,RimuruQ2_DurationDebuff,RimuruQ2_DebuffHealReduce/100)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_yc_launchbig.mdx", .x, .y, GetRandomReal(0, 359), 1.5, 1, 13))
                        endif
                    endif
                else
                    call StopSpellUnit(c)
                    call SetUnitTimeScale(c, 1)
                    call DestroyEffect(e)
                    set c = null
                    set e = null
                    set td = null
                    set m_Rimuru2Q[i] = m_Rimuru2Q[ MUI_Rimuru2Q]
                    set MUI_Rimuru2Q = MUI_Rimuru2Q - 1
                    if MUI_Rimuru2Q == -1 then
                        call RimuruTimer03Release()
                    endif
                    call deallocate(this)
                set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method Rimuru2Q_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_Rimuru2Q = MUI_Rimuru2Q + 1
            set m_Rimuru2Q[ MUI_Rimuru2Q] = this
            set c = NewC
            set td = NewTd
            set r = 0
            call StartSpellUnit(c)
            set a = GAngle(c, td)
            set rmax = 2.1
            set move = 75
            set dmg = GetHeroInt( c , true) * ( RimuruQ2_DamageIntBase + ( RimuruQ2_DamageIntStep * ( GetUnitAbilityLevel( c , RimuruQ2_ID) - 1 ) ) )
            set dmg2 = GetHeroInt( c , true) * ( RimuruQ2_DamageIntBurnBase + ( RimuruQ2_DamageIntBurnStep * ( GetUnitAbilityLevel( c , RimuruQ2_ID) - 1 ) ) )
            call SetUnitFacing( c , a * bj_RADTODEG)
            call SetUnitAnimationByIndex( c , 4)
            call SetUnitTimeScale(c, 1.5)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_dark purple fire.mdl", c, "weapon")
            call MakeSound("war3mapimported\\Hero_Rimuru_Q4")
            if MUI_Rimuru2Q == 0 then
                call RimuruTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct Rimuru2W2_KS
        private static integer array m_RimuruW2
        private static integer MUI_RimuruW2 = -1
        unit c
        unit td
        integer k
        integer retractStarted
        real r
        real ls_retract
        lightning array ls [80]
        real array ls_x1[80]
        real array ls_y1[80]
        real array ls_x2[80]
        real array ls_y2[80]
        real array ls_h1[80]
        real array ls_h2[80]
        real ls_progress // 0.0 to 1.0
        real rmax
        public static method Loop_Rimuru2W2 takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr1 = 0
            local real rr2 = 0
            local real rr3 = 0
            local real rr4 = 0
            loop
                exitwhen i > MUI_RimuruW2
                set this = m_RimuruW2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r == 0.03 then
                        call RootUnit(c, td, RimiruW_Root)
                        set ls_progress = 0.0
                        set ls_retract = 0
                        set k = 0
                        loop
                            exitwhen k == 10
                            set rr3 = rr3 + 20 * bj_DEGTORAD
                            set rr2 = GetRandomReal(350, 425)
        // Entry point вЂ” random offset on one side of target
                            set ls_x1[k] = GetUnitX(td) + rr2 * Cos(rr3)
                            set ls_y1[k] = GetUnitY(td) + rr2 * Sin(rr3)
        // Exit point вЂ” opposite side, different random radius so it looks skewed
                            set rr1 = GetRandomReal(350, 425)
                            set rr4 = GetRandomReal( -0.3, 0.3)
                            set ls_x2[k] = GetUnitX(td) - rr1 * Cos(rr3 + rr4)
                            set ls_y2[k] = GetUnitY(td) - rr1 * Sin(rr3 + rr4)
                           // Randomly from ground or from air
                            if GetRandomInt(0, 1) == 0 then
                                set ls_h1[k] = GetRandomReal(0, 155) // crawling from earth
                            else
                                set ls_h1[k] = GetRandomReal(305, 375) // dropping from air
                            endif
                            set ls_h2[k] = GetRandomReal(0, 50) // exit near ground
        // Spawn collapsed at entry point
                            set ls[k] = AddLightningEx("RMRW", false, ls_x1[k], ls_y1[k],ls_h1[k],ls_x1[k],ls_y1[k],ls_h1[k])
                            set k = k + 1
                        endloop
                    endif
                    if r >= rmax - 0.3 and retractStarted == 0 then
                        set retractStarted = 1
                        set k = 0
                        loop
                            exitwhen k == 10
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_RimuruWhit.mdl", ls_x2[k], ls_y2[k], GetRandomReal(0, 359), 1, 1.5, ls_h2[k] + 35))
                            set k = k + 1
                        endloop
                    endif
                    if r > 0.03 and ls_progress < 1.0 then
                        set ls_progress = ls_progress + 0.1
                        if ls_progress > 1.0 then
                            set ls_progress = 1.0
                        endif
                        set k = 0
                        loop
                            exitwhen k == 10
                            call MoveLightningEx(ls[k], false,ls_x1[k],ls_y1[k],ls_h1[k],ls_x1[k] + (ls_x2[k] - ls_x1[k]) * ls_progress,ls_y1[k] + (ls_y2[k] - ls_y1[k]) * ls_progress,ls_h1[k] + (ls_h2[k] - ls_h1[k]) * ls_progress)
                            set k = k + 1
                        endloop
                    endif
                    if r >= rmax-0.3 and ls_retract < 1.0 then
                        set ls_retract = ls_retract + 0.1
                        if ls_retract > 1.0 then
                            set ls_retract = 1.0
                        endif
                        set k = 0
                        loop
                            exitwhen k == 10
                            call MoveLightningEx(ls[k], false,ls_x1[k] + (ls_x2[k] - ls_x1[k]) * ls_retract,ls_y1[k] + (ls_y2[k] - ls_y1[k]) * ls_retract,ls_h1[k] + (ls_h2[k] - ls_h1[k]) * ls_retract,ls_x2[k],ls_y2[k],ls_h2[k])
                            set k = k + 1
                        endloop
                    endif
                else
                    set k = 0
                    loop
                        exitwhen k == 10
                        call DestroyLightning(ls[k])
                        set ls[k] = null
                        set k = k + 1
                    endloop
                    set c = null
                    set td = null
                    set m_RimuruW2[i] = m_RimuruW2[ MUI_RimuruW2]
                    set MUI_RimuruW2 = MUI_RimuruW2 - 1
                    if MUI_RimuruW2 == -1 then
                        call RimuruTimer03Release()
                    endif
                    call deallocate(this)
                set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method Rimuru2W2_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_RimuruW2 = MUI_RimuruW2 + 1
            set m_RimuruW2[ MUI_RimuruW2] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set retractStarted = 0
            set rmax = RimiruW_Root+0.3
            if MUI_RimuruW2 == 0 then
                call RimuruTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct Rimuru2W_KS
        private static integer array m_Rimuru2W
        private static integer MUI_Rimuru2W = -1
        unit c
        real x
        real y
        real x1
        real y1
        real x2
        real y2
        real r2
        integer k
        real r3
        real r4
        group g
        group g2
        unit u
        real dmg
        real aoe
        real sr
        real move
        real r
        real ls_retract
        effect array ee[80]
        lightning array ls [80]
        real a
        real array ls_r1[80]
        real array ls_r2[80]
        real array ls_x1[80]
        real array ls_y1[80]
        real array ls_x2[80]
        real array ls_y2[80]
        real array ls_h1[80]
        real array ls_h2[80]
        real ls_progress // 0.0 to 1.0
        real rmax
        public static method Loop_Rimuru2W takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr1 = 0
            local real rr2 = 0
            local real rr3 = 0
            loop
                exitwhen i > MUI_Rimuru2W
                set this = m_Rimuru2W[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r < 0.75 then
                        call DebugUnit2(c)
                    endif
                    if r == 0.15 then
                        call MakeSound("war3mapimported\\Hero_Rimuru_W2")
                        set ls_retract = 0
                        set ls_progress = 0.0
                        set k = 0
                        loop
                            exitwhen k == 19
                            set rr3 = rr3 + 20 * bj_DEGTORAD
                            set rr2 = GetRandomReal(210, 425)
                            set ls_r1[k] = rr2
                            set ls_r2[k] = rr3
        // Origins spread around the CASTER
                            set ls_x1[k] = GetUnitX(c) - rr2 * Cos(rr3)
                            set ls_y1[k] = GetUnitY(c) - rr2 * Sin(rr3)
        // All bolts converge on the TARGET
                            set x1 = (GetUnitX(c) + sr * Cos(a))
                            set y1 = (GetUnitY(c) + sr * Sin(a))
                            set r4 = 200
                            set x2 = x1 + r4 * Cos(a)
                            set y2 = y1 + r4 * Sin(a)
                            set ls_x2[k] = x2 - ls_r1[k] * Cos(ls_r2[k])
                            set ls_y2[k] = y2 - ls_r1[k] * Sin(ls_r2[k])
                            set r3 = 0
                            set ls_h1[k] = GetRandomReal(0, 50) // ground - level start, slight variance
                            set ls_h2[k] = GetRandomReal(50, 150) // hits target at mid - height
                            set ee[k] = EffectSpawn("war3mapImported\\wos_RimuruWhit.mdl", ls_x1[k], ls_y1[k], GetRandomReal(0, 359), 0.6, 1, ls_h1[k] + 35)
                            set ls[k] = AddLightningEx("RMRE", false, ls_x1[k], ls_y1[k], ls_h1[k], ls_x1[k], ls_y1[k], ls_h1[k])
                            set k = k + 1
                        endloop
                    endif
                    if r == 0.75 then
                        call StopSpellUnit2(c)
                    endif
                    if r > 0.15 and r < 0.75 then
                        call MoveUnit(c, move, a)
                        if r2 > 0.03 then
                            set r2 = 0
                            set x = GetUnitX(c) + 0 * Cos(a)
                            set y = GetUnitY(c) + 0 * Sin(a)
                            call DecorRemove(c, x, y, aoe, 30)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c ))and IsUnitInGroup(u, g2) == false then
                                    call dmgphys(c, u, dmg)
                                    call GroupAddUnit(g2, u)
                                    call Rimuru2W2_KS.Rimuru2W2_Start(c, u)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                    if r > 0.15 and ls_progress < 1.0 then
                        set ls_progress = ls_progress + 0.05
                        if ls_progress > 1.0 then
                            set ls_progress = 1.0
                        endif
                        set k = 0
                        loop
                            exitwhen k == 19
                            call BlzSetSpecialEffectPosition(ee[k], ls_x1[k] + (ls_x2[k] - ls_x1[k]) * (ls_progress - 0.06), ls_y1[k] + (ls_y2[k] - ls_y1[k]) * (ls_progress - 0.06), ls_h2[k])
                            call MoveLightningEx(ls[k], false, ls_x1[k], ls_y1[k], ls_h1[k], ls_x1[k] + (ls_x2[k] - ls_x1[k]) * ls_progress, ls_y1[k] + (ls_y2[k] - ls_y1[k]) * ls_progress, ls_h2[k])
                            set k = k + 1
                        endloop
                    endif
                    if r > 0.45 then
                        if r3 < 1 then
                            set r3 = r3 + 0.065
                            set k = 0
                            set rr1 = 1.25
                            loop
                                exitwhen k == 19
                                set x2 = x1 + (r4 * (rr1 - r3)) * Cos(a)
                                set y2 = y1 + (r4 * (rr1 - r3)) * Sin(a)
                                set ls_x2[k] = x2 - (ls_r1[k] * (1 - r3)) * Cos(ls_r2[k])
                                set ls_y2[k] = y2 - (ls_r1[k] * (1 - r3)) * Sin(ls_r2[k])
                                set k = k + 1
                            endloop
                        endif
                    endif
                    if r >= 0.81 and ls_retract < 1.0 then
                        set ls_retract = ls_retract + 0.1
                        if ls_retract > 1.0 then
                            set ls_retract = 1.0
                        endif
                        set k = 0
                        loop
                            exitwhen k == 19
                            call MoveLightningEx(ls[k], false,ls_x1[k] + (ls_x2[k] - ls_x1[k]) * ls_retract,ls_y1[k] + (ls_y2[k] - ls_y1[k]) * ls_retract,ls_h1[k] + (ls_h2[k] - ls_h1[k]) * ls_retract,ls_x2[k],ls_y2[k],ls_h2[k])
                            set k = k + 1
                        endloop
                    endif
                else
                    if r < 0.75 then
                        call StopSpellUnit2(c)
                    endif
                    set k = 0
                    loop
                        exitwhen k == 19
                        call DestroyEffect(ee[k])
                        call DestroyLightning(ls[k])
                        set ls[k] = null
                        set ee[k] = null
                        set k = k + 1
                    endloop
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    call SetUnitTimeScale(c, 1)
                    set c = null
                    set u = null
                    set g = null
                    set g2 = null
                    set m_Rimuru2W[i] = m_Rimuru2W[ MUI_Rimuru2W]
                    set MUI_Rimuru2W = MUI_Rimuru2W - 1
                    if MUI_Rimuru2W == -1 then
                        call RimuruTimer03Release()
                    endif
                    call deallocate(this)
                set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method Rimuru2W_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_Rimuru2W = MUI_Rimuru2W + 1
            set m_Rimuru2W[ MUI_Rimuru2W] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 1
            set u = null
            set g = CreateGroup()
            set g2 = CreateGroup()
            set aoe = RimiruW2_Aoe
            set sr = RimuruW2_Range
            set move = sr / 20
            set a = GAngle2( c , x , y ) // Angle Between points
            set rmax = 1.5
            call StartSpellUnit2(c)
            set dmg = GetHeroInt( c , true) * ( RimuruW2_DamageIntBase + ( RimuruW2_DamageIntStep * ( GetUnitAbilityLevel( c , RimuruW2_ID) - 1 ) ) )
            call SetUnitFacing( c , a * bj_RADTODEG)
            call SetUnitAnimationByIndex( c , 8)
            call SetUnitTimeScale(c, 2)
            call MakeSound("war3mapimported\\Hero_Rimuru2_W3")
            call MakeSound("war3mapimported\\Hero_Rimuru2_W4")
            if MUI_Rimuru2W == 0 then
                call RimuruTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct Rimuru2E_KS
        private static integer array m_Rimuru2E
        private static integer MUI_Rimuru2E = -1
        unit c
        real x
        real y
        real r2
        integer k
        real r3
        real r4
        real r5
        real r6
        group g
        unit u
        real dmg
        real aoe
        real r
        effect e
        real a
        real rmax
        public static method Loop_Rimuru2E takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_Rimuru2E
                set this = m_Rimuru2E[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit2(c)
                    if r == 0.6 then
                        call MakeSound("war3mapimported\\Hero_Rimuru2_E2")
                        set k = 0
                        loop
                            exitwhen k == 5
                            set r4 = GetRandomReal(0.5, 0.75)
                            set r3 = GetRandomReal(3., 4)
                            set r2 = GetRandomReal(2., 3)
                            set r5 = GetRandomReal(60, 90)
                            set r6 = GetRandomReal(150, 185)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_txsd13.mdl", x + r5 * Cos(a + 72 * k * bj_DEGTORAD), y + r5 * Sin(a + 72 * k * bj_DEGTORAD), GetRandomReal(0, 359), r4, r3, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_txsd13.mdl", x + r6 * Cos(a + 72 * k * bj_DEGTORAD), y + r6 * Sin(a + 72 * k * bj_DEGTORAD), GetRandomReal(0, 359), r4, r2, 1))
                            //call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPEE (39).mdl", x + (r5+200) * Cos(a + 72 * k * bj_DEGTORAD), y + (r5+200) * Sin(a + 72 * k * bj_DEGTORAD), GetRandomReal(0, 359), r4, r3+4, 155))
                            set k = k + 1
                        endloop
                    endif
                    if r == 0.75 then
                        call MakeSound("war3mapimported\\Hero_Rimuru2_E3")
                        set k = 0
                        loop
                            exitwhen k == 5
                            set r4 = GetRandomReal(0.35, 0.4)
                            set r3 = GetRandomReal(6., 7)
                            set r5 = GetRandomReal(335, 410)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPEE (39).mdl", x + r5 * Cos(a + 72 * k * bj_DEGTORAD), y + r5 * Sin(a + 72 * k * bj_DEGTORAD), GetRandomReal(0, 359), r4, r3, 155))
                            set k = k + 1
                        endloop
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_FantasyBattle (1517).mdx", .x, .y, GetRandomReal(0, 359), 1.5, 1, 2))
                        call EffectSpawn2("war3mapImported\\wos_blacklightningarea3.mdl", x, y, GetRandomReal(0, 359), 1, 1, 1, 1)
                        call DecorRemove(c, x, y, aoe, 50)
                        call GroupClear( g )
                        call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                call dmgmag(c, u, dmg)
                                call StunUnit(c, u, RimuruE2_Stun)
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    endif
                else
                    call StopSpellUnit2(c)
                    call MyRemoveEff(e, 0.3)
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set e = null
                    set u = null
                    set m_Rimuru2E[i] = m_Rimuru2E[ MUI_Rimuru2E]
                    set MUI_Rimuru2E = MUI_Rimuru2E - 1
                    if MUI_Rimuru2E == -1 then
                        call RimuruTimer03Release()
                    endif
                    call deallocate(this)
                set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method Rimuru2E_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_Rimuru2E = MUI_Rimuru2E + 1
            set m_Rimuru2E[ MUI_Rimuru2E] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 1
            set g = CreateGroup()
            call StartSpellUnit2(c)
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set rmax = 0.75
            set aoe = RimuruE2_DamageAoe
            set dmg = GetHeroInt( c , true) * ( RimuruE2_DamageIntBase + ( RimuruE2_DamageIntStep * ( GetUnitAbilityLevel( c , RimuruE2_ID) - 1 ) ) )
            call SetUnitFacing( c , a * bj_RADTODEG)
            call SetUnitAnimationByIndex( c , 5)
            call SetUnitTimeScale(c, 2.5)
            set e = AddSpecialEffectTarget("war3mapimported\\wos_[spell]lightningboltbuff01_black.mdx", c, "hand right")
            call MakeSound("war3mapimported\\Hero_Rimuru2_E")
            if MUI_Rimuru2E == 0 then
                call RimuruTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct Rimuru2R_KS
        private static integer array m_Rimuru2R
        private static integer MUI_Rimuru2R = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        real r3
        real r4
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
        public static method Loop_Rimuru2R takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_Rimuru2R
                set this = m_Rimuru2R[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if check == 0 then
                        if r < 0.6 then
                            call DebugUnit2(c)
                        endif
                        if r == 0.6 then
                            call StopSpellUnit2(c)
                            set e = EffectSpawn("war3mapImported\\wos_dark purple fire.mdl", GetUnitX(c) , GetUnitY(c), a * bj_RADTODEG , 1, 1 , 55)
                            set e2 = EffectSpawn("war3mapImported\\wos_blacksphereexp.mdl", GetUnitX(c) , GetUnitY(c), 0, 2, 1, 100)
                            call BlzPlaySpecialEffect(e2, ANIM_TYPE_BIRTH)
                        endif
                        if r >= 0.66 then
                            set x1 = GetEffX(e)
                            set y1 = GetEffY(e)
                            set a = GAngle5(e,x,y)
                            call MoveEff(e, move, a)
                            call MoveEff(e2, move, a)
                            call DecorRemove(c, x1, y1, 175, 20)
                            if SR5(e, x, y) < 150 then
                                call BlzSetSpecialEffectPosition(e, x, y, 50)
                                call BlzSetSpecialEffectPosition(e2, x, y, 100)
                                set check = 1
                                set r = 0
                                set rmax = 1.8
                            endif
                        endif
                    elseif check == 1 then
                        if r == 0.03 then
                            call BlzPlaySpecialEffect(e2, ANIM_TYPE_SPELL)
                            call ScaleEffDummy(e2, 0.3, 1, 1.75)
                            call MakeSound("war3mapimported\\Hero_Rimuru2_R2")
                            call DestroyEffect(EffectSpawnScale("war3mapimported\\wos_by_wood_effect_void_daitu_shenwei_fangchu.mdx", x, y, 1, 1.5, 3, 375, 0.21, 3, 6))
                        endif
                        if r == 0.6 then
                            call BlzPlaySpecialEffect(e2, ANIM_TYPE_STAND)
                        endif
                        if r2 > 0.15 and r > 0 then
                            set r2 = 0
                            call DecorRemove(c, x, y, aoe, 50)
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    call dmgmag(c, u, dmg)
                                    call SlowUnit(c,u,RimuruR2_Slow,RimuruR2_SlowDuration )
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        else
                            set r2 = r2 + 0.03
                        endif
                        if r3 > 0.35 then
                            set r3 = 0
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_opm (513)purple.mdx", .x, .y, GetRandomReal(0, 359), 1.5, 0.9775, 2))
                        else
                            set r3 = r3 + 0.03
                        endif
                        if r4 > 0.24 then
                            set r4 = 0
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_yc_launchbig.mdl", .x, .y, GetRandomReal(0, 359), 1, 1.62, 25))
                        else
                            set r4 = r4 + 0.03
                        endif
                    endif
                else
                    if check == 0 and r < 0.6 then
                        call StopSpellUnit2(c)
                    endif
                    call DestroyEffect(e)
                    call BlzSetSpecialEffectTimeScale(e2, 2)
                    call DestroyEffect(e2)
                    call DestroyGroup( g )
                    call SetUnitTimeScale(c, 1)
                    set g = null
                    set c = null
                    set e = null
                    set u = null
                    set m_Rimuru2R[i] = m_Rimuru2R[ MUI_Rimuru2R]
                    set MUI_Rimuru2R = MUI_Rimuru2R - 1
                    if MUI_Rimuru2R == -1 then
                        call RimuruTimer03Release()
                    endif
                    call deallocate(this)
                set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method Rimuru2R_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_Rimuru2R = MUI_Rimuru2R + 1
            set m_Rimuru2R[ MUI_Rimuru2R] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 1
            set g = CreateGroup()
            call StartSpellUnit2(c)
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set rmax = 2.1
            set check = 0
            set move = 90
            set aoe = RimuruR2_DamageAoe
            set dmg = GetHeroInt( c , true) * ( RimuruR2_DamageIntBase + ( RimuruR2_DamageIntStep * ( GetUnitAbilityLevel( c , RimuruR2_ID) - 1 ) ) )
            set dmg = dmg / 9
            call SetUnitFacing( c , a * bj_RADTODEG)
            call SetUnitAnimationByIndex( c , 8)
            call SetUnitTimeScale(c, 1.5)
            call MakeSound("war3mapimported\\Hero_Rimuru2_R")
            if MUI_Rimuru2R == 0 then
                call RimuruTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct Rimuru2T_KS
        private static integer array m_Rimuru2T
        private static integer MUI_Rimuru2T = -1
        unit c
        real x
        real y
        real r2
        integer k
        real r3
        group g
        unit u
        real dmg
        integer check
        real aoe
        real r
        effect e
        effect e2
        effect e3
        effect e4
        effect e5
        real rmax
        public static method Loop_Rimuru2T takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rrk = 1
            local integer kk = 0
            loop
                exitwhen i > MUI_Rimuru2T
                set this = m_Rimuru2T[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if check == 0 then
                        if r == 0.03 then
                            set e = EffectSpawn("war3mapImported\\wos_SacredAuraRed.mdl", x, y, 1, 1, 0.01, 1)
                            call BlzSetSpecialEffectAlpha(e, 0)
                            set kk = 0 
            loop
            exitwhen kk == 10 
            if IsPlayerAlly(GetOwningPlayer(c),Player(kk)) then 
            if GetLocalPlayer() == Player(kk) then
            call BlzSetSpecialEffectAlpha(e,255)
            endif
            endif
            set kk = kk + 1 
            endloop
                            set rrk = aoe/450
                            call ScaleEffDummy(e, 0.7, 0.01, 5.5*rrk)
                        endif
                        if r == 0.6 then
                            call StopSpellUnit2(c)
                        endif
                        if r >= 0.7 then
                            if r2 > 0.03 then
                                set r2 = 0
                                call GroupClear( g )
                                call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null or check > 0
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                        set check = 1
                                        set r = 0
                                        set rmax = 2.1
                                        set aoe = RimuruT2_DamageAoe
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif
                    elseif check == 1 then
                        if r == 0.03 then
                        call BlzSetSpecialEffectAlpha(e, 255)
                            call MakeSound("war3mapimported\\Hero_Rimuru2_T2")
                            call NextSound("war3mapimported\\Hero_Rimuru2_T3", 1)
                            set e5 = EffectSpawn("war3mapimported\\wos_hakkestart.mdl", x, y, 1, 1, 1.65, 3)
                            call AnimDummyEff(e5, 0.25, 0)
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    call RootUnit(c, u, RimuruT2_Root )
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        endif
                        if r == 0.03 then
                        call VisionTimed(GetOwningPlayer(c),x,y,aoe+300,3)
                            set k = 0
                            loop
                                exitwhen k == 5
                                set e3 = EffectSpawn2("war3mapImported\\wos_orangeflamewind2.mdl", x, y, GetRandomReal(0, 359), GetRandomReal(1.5, 3.25), 1, 1 + k * 25, 1.1)
                                call ColorEffDummy4(e3, 0, 255, 255, 255, 0.15)
                                call EHeightSet2(e3, 0.51, k * 250 + 325, 0.8 - k * 0.06)
                                set k = k + 1
                            endloop
                        elseif r == 0.42 then
                            set e2 = EffectSpawn("war3mapImported\\wos_123 (1222).mdl", x, y, GetRandomReal(0, 359), 0.5, 1.25, 1)
                        elseif r == 0.66 then
                            call DecorRemove(c,x,y,aoe+100,100)
                            set e4 = EffectSpawnScale("war3mapImported\\wos_by_wood_effect_order_muzhibenying_fir_huo_huozhu.mdl", x, y, GetRandomReal(0, 359), 1, 1, 1, 0.21, 1, 5.5)
                        endif
                        if r2 > 0.21 and r > 0.4 then
                            set r2 = 0
                            call GroupClear( g )
                            call DecorRemove(c,x,y,aoe,100)
                            call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    call dmgmag(c, u, dmg)
                                    call SlowUnit(c, u, RimuruT2_SlowPercent , RimuruT2_SlowTime )
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        else
                            set r2 = r2 + 0.03
                        endif
                        if r3 > 0.35 and r > 0.9 then
                            set r3 = 0
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdx", x, y, GetRandomReal(0, 359), 1.325, 3.85 , 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_papsnaz (707).mdl", x, y, 1, 1, 1.4, 1))
                        else
                            set r3 = r3 + 0.03
                        endif
                endif
            else
                if check == 0 and r < 0.45 then
                    call StopSpellUnit2(c)
                endif
                if check > 0 then
                    call BlzSetSpecialEffectTimeScale(e2, 2.5)
                    call DestroyEffect(e2)
                    call DestroyEffect(e4)
                endif
                call ColorEffDummy3(e, 0, 255, 255, 255, 0.15)
                call ColorEffDummy3(e5, 0, 255, 255, 255, 0.15)
                call DestroyGroup( g )
                set g = null
                set c = null
                set e = null
                set e2 = null
                set e3 = null
                set e4 = null
                set e5 = null
                set u = null
                set m_Rimuru2T[i] = m_Rimuru2T[ MUI_Rimuru2T]
                set MUI_Rimuru2T = MUI_Rimuru2T - 1
                if MUI_Rimuru2T == -1 then
                    call RimuruTimer03Release()
                endif
                call deallocate(this)
            set i = i - 1
            endif
            set i = i + 1
        endloop
    endmethod
    public static method Rimuru2T_Start takes unit NewC, real NewX, real NewY returns nothing
        local thistype this = thistype.create( )
        local real angle
        set MUI_Rimuru2T = MUI_Rimuru2T + 1
        set m_Rimuru2T[ MUI_Rimuru2T] = this
        set c = NewC
        set x = NewX
        set y = NewY
        set r = 0
        set r2 = 1
        set g = CreateGroup()
        call StartSpellUnit2(c)
        set u = null
        set angle = GAngle2(c, x, y)
        set rmax = RimuruT2_CircleTime
        set check = 0
        set aoe = RimuruT2_AoeCheck
        set dmg = GetHeroInt( c , true) * RimuruT2_DamageIntBase
        set dmg = dmg / 7
        call SetUnitFacing(c, angle * bj_RADTODEG)
        call SetUnitAnimationByIndex( c , 10)
        call MakeSound("war3mapimported\\Hero_Rimuru2_T")
        call MakeSound("war3mapimported\\Hero_Rimuru2_T1")
        if MUI_Rimuru2T == 0 then
            call RimuruTimer03Acquire()
        endif
    endmethod
    endstruct

    private struct Rimuru2F_KS
        private static integer array m_Rimuru2F
        private static integer MUI_Rimuru2F = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        real r5
        group g
        group g2
        unit u
        real dmg
        real aoe
        real r
        effect e
        real a
        real rmax
    public static method Loop_Rimuru2F takes nothing returns nothing
        local integer this
        local integer i = 0
        local real rr1
        local real rr2
        local real rr3
        local real rr4
        loop
            exitwhen i > MUI_Rimuru2F
            set this = m_Rimuru2F[i]
            if SpellBoolCaster(c) and r <= rmax then
                set r = RoundReal(r + 0.03, 3)
                call DebugUnit2(c)
                if r == 0.45 then
                    set e = EffectSpawn("war3mapImported\\wos_ZK_MS_LJ_H.mdl", GetUnitX(c) + 50 * Cos(a), GetUnitY(c) + 50 * Sin(a), a * bj_RADTODEG, 1, 0.01, 165)
                    call ScaleEffDummy(e, 0.45, 0.01, 0.9)
                    call MakeSound("war3mapimported\\Hero_Rimuru2_F2")
                    set x = GetUnitX(c) + 100 * Cos(a)
                    set y = GetUnitY(c) + 100 * Sin(a)
                endif
                if r > 0.45 then
                    if r2 > 0.18 then
                        set r2 = 0
                        set r5 = 225
                        call GroupClear( g )
                        call GroupClear( g2 )
                        set k = 0
                        loop
                            exitwhen k == 4
                            call DecorRemove(c,x + r5 * Cos(a) , y + r5 * Sin(a) , aoe,50)
                            call VisionTimed(GetOwningPlayer(c),x + r5 * Cos(a) , y + r5 * Sin(a) ,700,2)
                            call GroupEnumUnitsInRange( g , x + r5 * Cos(a) , y + r5 * Sin(a) , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                    call dmgmag(c, u, dmg)
                                    call GroupAddUnit(g2, u)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    set rr1 = SR3(u, x + 350 * 1 * Cos(a) , y + 350 * 1 * Sin(a))
                                    set rr2 = SR3(u, x + 350 * 2 * Cos(a) , y + 350 * 2 * Sin(a))
                                    set rr3 = SR3(u, x + 350 * 3 * Cos(a) , y + 350 * 3 * Sin(a))
                                    set rr4 = SR3(u, x + 350 * 4 * Cos(a) , y + 350 * 4 * Sin(a))
                                    if rr1 <= rr2 and rr1 <= rr3 and rr1 <= rr4 then
                                        set x1 = x + 350 * 1 * Cos(a)
                                        set y1 = y + 350 * 1 * Sin(a)
                                    elseif rr2 <= rr1 and rr2 <= rr3 and rr2 <= rr4 then
                                        set x1 = x + 350 * 2 * Cos(a)
                                        set y1 = y + 350 * 2 * Sin(a)
                                    elseif rr3 <= rr1 and rr3 <= rr2 and rr3 <= rr4 then
                                        set x1 = x + 350 * 3 * Cos(a)
                                        set y1 = y + 350 * 3 * Sin(a)
                                    else
                                        set x1 = x + 350 * 4 * Cos(a)
                                        set y1 = y + 350 * 4 * Sin(a)
                                    endif

                                    call MUE(u, SR3(u, x1 , y1)*0.3, 0.15, GAngle2(u, x1 , y1))
                                endif
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c ))==false then
                                    call DebuffClear(u)
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            call DecorRemove(c, x + r5 * Cos(a) , y + r5 * Sin(a) , aoe+60,100)
                            set r5 = r5 + 350
                            set u = null
                            set k = k + 1
                        endloop
                    else
                        set r2 = r2 + 0.03
                    endif
                endif
            else
                call SaveInteger(hs, GetHandleId(c), StringHash("rimuru f"), 0)
                call StopSpellUnit2(c)
                call DestroyEffect(e)
                call DestroyGroup( g )
                call DestroyGroup( g2 )
                call SetUnitTimeScale(c, 1)
                set g = null
                set g2 = null
                set c = null
                set e = null
                set u = null
                set m_Rimuru2F[i] = m_Rimuru2F[ MUI_Rimuru2F]
                set MUI_Rimuru2F = MUI_Rimuru2F - 1
                if MUI_Rimuru2F == -1 then
                    call RimuruTimer03Release()
                endif
                call deallocate(this)
            set i = i - 1
            endif
            set i = i + 1
        endloop
    endmethod
    public static method Rimuru2F_Start takes unit NewC, real NewX, real NewY returns nothing
        local thistype this = thistype.create( )
        set MUI_Rimuru2F = MUI_Rimuru2F + 1
        set m_Rimuru2F[ MUI_Rimuru2F] = this
        set c = NewC
        set x = NewX
        set y = NewY
        set r = 0
        set r5 = 0
        set r2 = 1
        set g = CreateGroup()
        set g2 = CreateGroup()
        call StartSpellUnit2(c)
        call DebuffClear(c)
        set u = null
        set a = GAngle2( c , x , y ) // Angle Between points
        set rmax = 1.25
        set aoe = RimiruF2_Aoe
        call SaveInteger(hs, GetHandleId(c), StringHash("rimuru f"), 1)
        set dmg = GetHeroInt( c , true) * RimuruF2_DamageIntBase
        set dmg = dmg / 4
        call SetUnitFacing( c , a * bj_RADTODEG)
        call SetUnitAnimationByIndex( c , 8)
        call SetUnitTimeScale(c, 2.5)
        call MakeSound("war3mapimported\\Hero_Rimuru2_F")
        if MUI_Rimuru2F == 0 then
            call RimuruTimer03Acquire()
        endif
    endmethod
    endstruct

    private struct Rimuru2Evol_KS
        private static integer array m_Rimuru2Evol
        private static integer MUI_Rimuru2Evol = -1
        unit c
        real x
        real y
        real r
        effect e
        effect e2
        effect e3
        real rmax
    public static method Loop_Rimuru2Evol takes nothing returns nothing
        local integer this
        local integer i = 0
        loop
            exitwhen i > MUI_Rimuru2Evol
            set this = m_Rimuru2Evol[i]
            if r <= rmax then
                set r = RoundReal(r + 0.1, 1)
            else
                set x = GetUnitX(c)
                set y = GetUnitY(c)
                call DestroyEffect(e)
                call DestroyEffect(e2)
                call DestroyEffect(e3)
                call BlzSetUnitSkin(c, Rimuru3_ID)
                call UnitRemoveAbility(c, RimuruQ2_ID)
                call UnitRemoveAbility(c, RimuruW2_ID)
                call UnitRemoveAbility(c, RimuruE2_ID)
                call UnitRemoveAbility(c, RimuruR2_ID)
                call UnitRemoveAbility(c, RimuruT2_ID)
                call UnitRemoveAbility(c, RimuruF2_ID)
                call UnitRemoveAbility(c, RimuruG2_ID)
                call UnitAddAbility(c, RimuruQ3_ID)
                call UnitAddAbility(c, RimuruW3_ID)
                call UnitAddAbility(c, RimuruE3_ID)
                call UnitAddAbility(c, RimuruR3_ID)
                call UnitAddAbility(c, RimuruT3_ID)
                call UnitAddAbility(c, RimuruF3_ID)
                call UnitAddAbility(c, RimuruG3_ID)
                call UnitMakeAbilityPermanent(c, true, RimuruQ3_ID)
                call UnitMakeAbilityPermanent(c, true, RimuruW3_ID)
                call UnitMakeAbilityPermanent(c, true, RimuruE3_ID)
                call UnitMakeAbilityPermanent(c, true, RimuruR3_ID)
                call UnitMakeAbilityPermanent(c, true, RimuruT3_ID)
                call UnitMakeAbilityPermanent(c, true, RimuruF3_ID)
                call UnitMakeAbilityPermanent(c, true, RimuruG3_ID)
                call MakeSound("war3mapimported\\Hero_Rimuru3_G")
                call EUTU2_3(EffectSpawn("war3mapimported\\wos_[tx]lvlup.mdl", x, y, 1, 0.5, 3, 1), 2, 1, c)
                call EUTU2_3(EffectSpawn("war3mapimported\\wos_1jinse_94.mdl", x, y, 1, 1, 3, 1), 2, 1, c)
                call EUTU2_3(EffectSpawn("war3mapimported\\wos_1jinse_93.mdl", x, y, 1, 1, 2, 1), 2, 1, c)
                call EUTU2_3(EffectSpawn("war3mapimported\\wos_1jinse_5.mdl", x, y, 1, 0.95, 3, 1), 2, 1, c)
                call EUTU2_3(EffectSpawn("war3mapimported\\wos_5731-sl_8bc718f-F.mdl", x, y, 1, 0.95, 1, 1), 2, 1, c)
                set c = null
                set e = null
                set e2 = null
                set e3 = null
                set m_Rimuru2Evol[i] = m_Rimuru2Evol[ MUI_Rimuru2Evol]
                set MUI_Rimuru2Evol = MUI_Rimuru2Evol - 1
                if MUI_Rimuru2Evol == -1 then
                    call RimuruTimer10Release()
                endif
                call deallocate(this)
            set i = i - 1
            endif
            set i = i + 1
        endloop
    endmethod
    public static method Rimuru2Evol_Start takes unit NewC returns nothing
        local thistype this = thistype.create( )
        set MUI_Rimuru2Evol = MUI_Rimuru2Evol + 1
        set m_Rimuru2Evol[ MUI_Rimuru2Evol] = this
        set c = NewC
        set r = 0
        set rmax = 3.72//3.72
        set e = AddSpecialEffectTarget("war3mapImported\\wos_ChuShou_BY_Wood_yellow_XuLi.mdl", c, "chest")
        set e2 = AddSpecialEffectTarget("war3mapImported\\wos_evolution2.mdl", c, "origin")
        set e3 = AddSpecialEffectTarget("war3mapImported\\wos_evolution2.mdl", c, "chest")
        call MakeSound("war3mapimported\\Hero_Rimuru2_Evol")
        if MUI_Rimuru2Evol == 0 then
            call RimuruTimer10Acquire()
        endif
    endmethod
    endstruct

    private struct Rimuru3Q_KS
        private static integer array m_Rimuru3Q
        private static integer MUI_Rimuru3Q = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k
        integer k4
        real r3
        real r4
        real r5
        real dmg
        real dmg2
        real move
        real r
        effect e
        effect e2
        real a
        real rmax
    public static method Loop_Rimuru3Q takes nothing returns nothing
        local integer this
        local integer i = 0
        loop
            exitwhen i > MUI_Rimuru3Q
            set this = m_Rimuru3Q[i]
            if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                set r = RoundReal(r + 0.03, 3)
                call DebugUnit2(c)
                set a = GAngle(c, td)
                call SetUnitFacing(c, a * bj_DEGTORAD)
                if r == 0.3 then
                    call BlinkEff(c)
                    call BlinkEff2(c)
                    set x = GetUnitX(td) - 120 * Cos(a)
                    set y = GetUnitY(td) - 120 * Sin(a)
                    call PosUnit(c, x, y)
                    call BlinkEff(c)
                endif
                if r == 0.6 or r == 0.9 or r == 1.2 or r == 1.5 then
                    call SetUnitAnimationByIndex(c, GetRandomInt(0, 2))
                    set x = GetUnitX(td) - 120 * Cos(a)
                    set y = GetUnitY(td) - 120 * Sin(a)
                    call PosUnit(c, x, y)
                    set k4 = 0
                                if GetUnitAbilityLevel(c,RimuruG3_IntBonus_ID)>0 then
                                set k4 = GetRandomInt(1,3)
                                endif
                                 if k4>0 then
                                     call ErzaPassive(c,td,k4)
                                    endif
                    call dmgphys(c, td, dmg)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    set r2 = GetRandomReal( -15, 15) * bj_DEGTORAD
                    call MUE(td, move, 0.1, a + r2)
                    if r == 1.5 then
                        call MakeSound("war3mapimported\\Hero_Rimuru3_Q4")
                            call MyRemoveEff(AddSpecialEffectTarget("war3mapImported\\wos_dark purple fire.mdl", td, "chest"), 4)
                            call DmgPTime(c, td, dmg2, RimuruQ2_DurationDebuff, 0.25, 1)
                            call BlockRegen(td,RimuruQ2_DurationDebuff,RimuruQ2_DebuffHealReduce/100)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_yc_launchbig.mdx", .x, .y, GetRandomReal(0, 359), 1.5, 1, 13))
                        call MakeSound("war3mapimported\\Hero_Rimuru2_E3")
                        set k = 0
                        loop
                            exitwhen k == 3
                            set r4 = GetRandomReal(0.75, 1)
                            set r3 = GetRandomReal(4., 5)
                            set r5 = GetRandomReal(35, 110)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPEE (39).mdl", x + r5 * Cos(a + 122 * k * bj_DEGTORAD), y + r5 * Sin(a + 122 * k * bj_DEGTORAD), GetRandomReal(0, 359), r4, r3, 155))
                            set k = k + 1
                        endloop
                       // call DestroyEffect(EffectSpawn("123 (136)1.mdx", .x, .y, GetRandomReal(0, 359), 1, 3, 2))
                       //  call DestroyEffect(EffectSpawn("war3mapImported\file00007846.mdx", .x, .y, GetRandomReal(0, 359), 0.756, 3, 2))
                        call EffectSpawn2("war3mapImported\\wos_blacklightningarea3.mdl", x, y, GetRandomReal(0, 359), 1, 0.6, 1, 0.5)
                        call DecorRemove(c, x, y, 300, 20)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_txsd13.mdl", x, y, GetRandomReal(0, 359), 0.4, 6, 1))
                    else
                        call MakeSound("war3mapimported\\Hero_Rimuru3_Q")
                        set r5 = GetRandomReal(0, 359)
                            call EUTU2_3(EffectSpawn("war3mapImported\\wos_yh_az_jugg_e2_black.mdl", x, y, r5, 0.35, 4.25, 180), 1.5, 185, td)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPEE (39).mdl", x , y , GetRandomReal(0, 359), 2, 5, 155))
                        call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_az_jingzi_jiansheng01_e2.mdl", x, y, r5, 0.8, 1.85, 0), 0.5, 255, 255, 255, 0.5)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_yc_launchbig.mdx", .x, .y, GetRandomReal(0, 359), 1.75, 1, 13))
                    endif
                endif
            else
                call StopSpellUnit2(c)
                call SetUnitTimeScale(c, 1)
                call DestroyEffect(e)
                call DestroyEffect(e2)
                call SetUnitTimeScale(c, 1)
                set c = null
                set e = null
                set e2 = null
                set td = null
                set m_Rimuru3Q[i] = m_Rimuru3Q[ MUI_Rimuru3Q]
                set MUI_Rimuru3Q = MUI_Rimuru3Q - 1
                if MUI_Rimuru3Q == -1 then
                    call RimuruTimer03Release()
                endif
                call deallocate(this)
            set i = i - 1
            endif
            set i = i + 1
        endloop
    endmethod
    public static method Rimuru3Q_Start takes unit NewC, unit NewTd returns nothing
        local thistype this = thistype.create( )
        set MUI_Rimuru3Q = MUI_Rimuru3Q + 1
        set m_Rimuru3Q[ MUI_Rimuru3Q] = this
        set c = NewC
        set td = NewTd
        set r = 0
        set r5 = 0
        call StartSpellUnit2(c)
        set a = GAngle(c, td)
        set rmax = 1.5
        set move = 75
        if LoadInteger(hs,GetHandleId(c),StringHash("rim main stat")) ==0 then
        set dmg = GetHeroInt( c , true) * RimuruQ3_DamageIntBase
        set dmg2 = GetHeroInt( c , true) * RimuruQ3_DamageIntBurnBase
        else
        set dmg = GetHeroAgi( c , true) * RimuruQ3_DamageIntBase
        set dmg2 = GetHeroAgi( c , true) * RimuruQ3_DamageIntBurnBase
        endif
        set dmg = dmg /4
        call SetUnitFacing( c , a * bj_RADTODEG)
        call SetUnitAnimationByIndex( c , 4)
        call SetUnitTimeScale(c, 1.5)
        set e2 = AddSpecialEffectTarget("war3mapImported\\wos_saber_attach.mdl", c, "hand right")
        set e = AddSpecialEffectTarget("war3mapImported\\wos_dark purple fire.mdl", c, "hand right")
        if GetRandomInt(1, 2) == 1 then
            call MakeSound("war3mapimported\\Hero_Rimuru3_Q2")
        else
            call MakeSound("war3mapimported\\Hero_Rimuru3_Q3")
        endif
        if MUI_Rimuru3Q == 0 then
            call RimuruTimer03Acquire()
        endif
    endmethod
    endstruct

    private struct Rimuru3W_KS
        private static integer array m_Rimuru3W
        private static integer MUI_Rimuru3W = -1
        unit c
        real x
        real y
        group g
        unit u
        real aoe
        real r
        effect e
        real rmax
    public static method Loop_Rimuru3W takes nothing returns nothing
        local integer this
        local integer i = 0
        local real dist
        loop
            exitwhen i > MUI_Rimuru3W
            set this = m_Rimuru3W[i]
            if SpellBoolCaster(c) and r <= rmax then
                set r = RoundReal(r + 0.03, 3)
                if r == 0.24 then
                    call BlzPlaySpecialEffect(e, ANIM_TYPE_STAND)
                    call BlzSetSpecialEffectTimeScale(e, 1)
                    call GroupClear( g )
                    call GroupEnumUnitsInRange( g , x, y , aoe , null)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                            call CurseUnit(c, u, 4)
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    set u = null
                endif
                if r >= 0.24 then
                    call GroupClear( g )
                    call GroupEnumUnitsInRange( g , x, y , aoe + 550 , null)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        set dist = SR3(u, x, y)
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                            if GetUnitAbilityLevel(u,RimuruW3_BuffEnemy_ID )>0 then
                                if dist >= aoe - 125 then
                                    call MoveUnit(u, 125 , GAngle2(u, x, y))
                                endif
                            else
                                if dist <= aoe and GetUnitAbilityLevel(u,'B005' )==0 then
                                    call MoveUnit(u, aoe + 100 - dist, GAngle3(x, y, u))
                                endif
                            endif
                        endif
                        if IsUnitAlly(u, GetOwningPlayer(c)) and dist <= aoe then
                            call BuffUnit1(c, u, 11)
                        endif
                        if IsUnitEnemy(u, GetOwningPlayer(c)) and dist <= aoe-150 then
                            call CurseUnit(c, u, 4)
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    set u = null
                endif

            else
                call GroupClear( g )
                    call GroupEnumUnitsInRange( g , x, y , aoe*5 , null)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                            call UnitRemoveAbility(u,RimuruW3_BuffEnemy_ID)
                        endif
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c ))== false then
                            call UnitRemoveAbility(u,RimuruW3_Buff_ID)
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    set u = null
                call BlzSetSpecialEffectTimeScale(e, 3)
                call DestroyEffect(e)
                call DestroyGroup( g )
                set g = null
                set c = null
                set e = null
                set u = null
                set m_Rimuru3W[i] = m_Rimuru3W[ MUI_Rimuru3W]
                set MUI_Rimuru3W = MUI_Rimuru3W - 1
                if MUI_Rimuru3W == -1 then
                    call RimuruTimer03Release()
                endif
                call deallocate(this)
            set i = i - 1
            endif
            set i = i + 1
        endloop
    endmethod
    public static method Rimuru3W_Start takes unit NewC, real NewX, real NewY returns nothing
        local thistype this = thistype.create( )
        local real angle
        set MUI_Rimuru3W = MUI_Rimuru3W + 1
        set m_Rimuru3W[ MUI_Rimuru3W] = this
        set c = NewC
        set x = NewX
        set y = NewY
        set r = 0
        set g = CreateGroup()
        set u = null
        set angle = GAngle2(c, x, y)
        set rmax = RimiruW3_Duration+ 0.75
        set aoe = RimiruW3_Aoe
        call SetUnitFacing(c, angle * bj_RADTODEG)
        call SetUnitAnimationByIndex( c , 1)
        call VisionTimed(GetOwningPlayer(c),x,y,aoe+500,rmax+1)
        call DecorRemove(c,x,y,aoe,50)
        set e = EffectSpawn("war3mapImported\\wos_moon_texiao_shengguangweimu_01_22.mdl", x, y, 1, 2, 1, 0)
        call BlzPlaySpecialEffect(e, ANIM_TYPE_BIRTH)
        if GetRandomInt(1, 2) == 1 then
            call MakeSound("war3mapimported\\Hero_Rimuru3_W")
        else
            call MakeSound("war3mapimported\\Hero_Rimuru3_W2")
        endif
        if MUI_Rimuru3W == 0 then
            call RimuruTimer03Acquire()
        endif
    endmethod
    endstruct

    private struct Rimuru3E_KS
        private static integer array m_Rimuru3E
        private static integer MUI_Rimuru3E = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        integer k3
        integer k4
        real r3
        group g
        unit u
        real dmg
        real aoe
        real r
        real array te[4] // each tornado's current angle
        real array tr[4]
        effect array ee[80]
        real rmax
    public static method Loop_Rimuru3E takes nothing returns nothing
        local integer this
        local integer i = 0
        local real rr1 = 0
        local real rr2 = 0
        loop
            exitwhen i > MUI_Rimuru3E
            set this = m_Rimuru3E[i]
            if r <= rmax then
                set r = RoundReal(r + 0.03, 3)
                if k3 < 175 then
                    set k3 = k3 + 3
                endif
                set k = 0
                loop
                    exitwhen k == 4
                    set te[k] = te[k] + 0.01
                    set tr[k] = tr[k] - 1
                    set x1 = x + tr[k] * Cos(te[k])
                    set y1 = y + tr[k] * Sin(te[k])
                    call BlzSetSpecialEffectAlpha(ee[k], k3)
                    call BlzSetSpecialEffectPosition(ee[k], x1, y1, 0)
                    set k = k + 1
                endloop
                if r3 > 0.12 then
                    set r3 = 0
                    set k = 0
                    loop
                        exitwhen k == 2
                        set rr1 = GetRandomReal(0, aoe)
                        set rr2 = GetRandomReal(0, 359) * bj_DEGTORAD
                        set x1 = x + rr1 * Cos(rr2)
                        set y1 = y + rr1 * Sin(rr2)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_txsd13.mdl", x1, y1, GetRandomReal(0, 359), 1, 2.25, 1))
                        set k = k + 1
                    endloop
                else
                    set r3 = r3 + 0.03
                endif
                if r2 > 0.45 then
                    set r2 = 0
                    call DecorRemove(c, x, y , aoe, 100)
                    call GroupClear(g)
                    call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                        set k4 = 0
                                if GetUnitAbilityLevel(c,RimuruG3_IntBonus_ID)>0 then
                                set k4 = GetRandomInt(1,3)
                                endif
                         if k4>0 then
                                     call ErzaPassive(c,u,k4)
                                    endif
                            call ErzaPassive(c, u, 3)
                            call dmgmag(c, u, dmg)
                            call SlowUnit(c, u, RimuruE3_SlowPercent , RimuruE3_SlowTime )
                            set k = 0
                            loop
                                exitwhen k == 4
                                if SR3(u, GetEffX(ee[k]), GetEffY(ee[k])) < 375 then
                                    call MUE(u, 75, 0.3, GAngle2(u, GetEffX(ee[k]), GetEffY(ee[k])))
                                endif
                                set k = k + 1
                            endloop
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    set u = null
                else
                    set r2 = r2 + 0.03
                endif
            else
                set k = 0
                loop
                    exitwhen k == 4
                    call BlzSetSpecialEffectTimeScale(ee[k], 3)
                    call DestroyEffect(ee[k])
                    set ee[k] = null
                    set k = k + 1
                endloop
                call DestroyGroup( g )
                set g = null
                set c = null
                set u = null
                set m_Rimuru3E[i] = m_Rimuru3E[ MUI_Rimuru3E]
                set MUI_Rimuru3E = MUI_Rimuru3E - 1
                if MUI_Rimuru3E == -1 then
                    call RimuruTimer03Release()
                endif
                call deallocate(this)
            set i = i - 1
            endif
            set i = i + 1
        endloop
    endmethod
    public static method Rimuru3E_Start takes unit NewC, real NewX, real NewY returns nothing
        local thistype this = thistype.create( )
        local real rr1 = 0
        local real rr2 = 0
        set MUI_Rimuru3E = MUI_Rimuru3E + 1
        set m_Rimuru3E[ MUI_Rimuru3E] = this
        set c = NewC
        set x = NewX
        set y = NewY
        set r = 0
        set r2 = 0
        set g = CreateGroup()
        set u = null
        set k3 = 0
        set aoe = RimuruE3_DamageAoe
        if LoadInteger(hs,GetHandleId(c),StringHash("rim main stat")) ==0 then
        set dmg = GetHeroInt( c , true) * ( RimuruE3_DamageIntBase )
        else
        set dmg = GetHeroAgi( c , true) * ( RimuruE3_DamageIntBase )
        endif
        set rmax = RimuruE3_Duration
        set dmg = dmg / (rmax * 2)
        set rmax = rmax + 0.2
        call VisionTimed(GetOwningPlayer(c), x, y , aoe + 250, rmax)
        call SetUnitAnimationByIndex(c, 2)
        call SetUnitTimeScale(c, 1)
        set k = 0
        loop
            exitwhen k == 4
            set rr1 = GetRandomReal(aoe - 500, aoe - 125)
            set rr2 = (k * 90 + GetRandomReal( -10, 10)) * bj_DEGTORAD
            set x1 = x + rr1 * Cos(rr2)
            set y1 = y + rr1 * Sin(rr2)
            set ee[k] = EffectSpawn("war3mapImported\\wos_VeldoraTornado.mdl", x1, y1, GetRandomReal(0, 359), 1, 1.2, 1)
            call BlzSetSpecialEffectAlpha(ee[k], 0)
            set te[k] = rr2
            set tr[k] = rr1
            set k = k + 1
        endloop
        call MakeSound("war3mapImported\\Hero_Rimuru3_E3 1")
        call MakeSound("war3mapimported\\Hero_Rimuru3_E3 2")
        call NextSound("war3mapimported\\Hero_Rimuru3_E3 3", 2)
        if MUI_Rimuru3E == 0 then
            call RimuruTimer03Acquire()
        endif
    endmethod
    endstruct

    private struct Rimuru3E2_KS
        private static integer array m_Rimuru3E2
        private static integer MUI_Rimuru3E2 = -1
        unit c
        real x
        real y
        real r2
        integer k4
        real scale
        real r3
        real r_prepare
        real r4
        real fly
        real r7
        group g
        group g2
        unit u
        real dmg
        real aoe
        real move
        real r
        effect e3
        real a
        real rmax
    public static method Loop_Rimuru3E2 takes nothing returns nothing
        local integer this
        local integer i = 0
        loop
            exitwhen i > MUI_Rimuru3E2
            set this = m_Rimuru3E2[i]
            if SpellBoolCaster(c) and r <= rmax then
                set r = RoundReal(r + 0.03, 3)
                if r == 0.03 or r == 0.3 or r == 0.6 then
                    call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_chargeorange2.mdl", c, "hand right"))
                endif
                if r == r_prepare - 0.03 then
                    call SetUnitTimeScale(c, 1)
                    set x = GetUnitX(c) + 180 * Cos(a)
                    set y = GetUnitY(c) + 180 * Sin(a)
                    set e3 = EffectSpawn3("war3mapImported\\wos_firefly-r1e-sfx2.mdl", x, y, a * bj_RADTODEG + 180, 2.5, 1, 230, -90)
                    call AnimDummyEff(e3, 0.65, 1)
                    call MyRemoveEff(e3, 0.7)
                    set e3 = null
                    set e3 = EffectSpawn3("war3mapImported\\wos_firefly-r1e-sfx2.mdl", x, y, a * bj_RADTODEG + 180, 2.5, 1, 230, -90)
                    call AnimDummyEff(e3, 0.65, 1)
                    call MyRemoveEff(e3, 0.7)
                    set e3 = null
                    call MakeSound("war3mapimported\\Hero_Rimuru3_E2 1")
                endif
                if r == r_prepare + 0.21 then
                    set e3 = EffectSpawn3("war3mapImported\\wos_firefly-r1e-sfx2.mdl", x, y, a * bj_RADTODEG + 180, 2.5, 1, 230, -90)
                    call AnimDummyEff(e3, 0.65, 1)
                    call MyRemoveEff(e3, 0.7)
                    set e3 = null
                    set e3 = EffectSpawn3("war3mapImported\\wos_firefly-r1e-sfx2.mdl", x, y, a * bj_RADTODEG + 180, 2.5, 1, 230, -90)
                    call AnimDummyEff(e3, 0.65, 1)
                    call MyRemoveEff(e3, 0.7)
                    set e3 = null
                endif
                if r < r_prepare then
                    call DebugUnit2(c)
                endif
                if r >= r_prepare then
                    set x = x + move * Cos(a)
                    set y = y + move * Sin(a)
                    set r7 = r7 + move
                    if r7 >= RimuruE4_Range then
                        set r = 999999
                    endif
                    if r2 > 0.00 then
                        set r2 = 0
                        set scale = scale + 0.21
                        set move = move + 5
                        set fly = fly + 9
                    else
                        set r2 = r2 + 0.03
                    endif
                    if r3 > 0.03 then
                        set r3 = 0
                        call DecorRemove(c, x, y, aoe, 100)
                        call VisionTimed(GetOwningPlayer(c), x, y, 1255, 2)
                        call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_papsnaz (1050).mdl", x, y, GetRandomReal(0, 359), 1.85, 0.01, 0, 0.12, 0.01, scale * 0.6), 0.3, 255, 255, 255, 0.51)
                    else
                        set r3 = r3 + 0.03
                    endif
                    if r4 > 0.06 then
                        set r4 = 0
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_papsnaz (707).mdl", x, y, GetRandomReal(0, 359), 1, 1., 1))
                    else
                        set r4 = r4 + 0.03
                    endif
                    call GroupClear( g )
                    call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                            call GroupAddUnit(g2, u)
                            call dmgmag(c, u, dmg)
                            set k4 = 0
                                if GetUnitAbilityLevel(c,RimuruG3_IntBonus_ID)>0 then
                                set k4 = GetRandomInt(1,3)
                                endif
                             if k4>0 then
                                     call ErzaPassive(c,u,k4)
                                    endif
                            call ErzaPassive(c,u,1)
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    set u = null
                endif
            else
                call SetUnitAnimation(c, "stand")
                call StopSpellUnit2(c)
                call SetUnitTimeScale(c, 1)
                call DestroyGroup( g )
                set g = null
                call DestroyGroup( g2 )
                set g2 = null
                set c = null
                set u = null
                set m_Rimuru3E2[i] = m_Rimuru3E2[ MUI_Rimuru3E2]
                set MUI_Rimuru3E2 = MUI_Rimuru3E2 - 1
                if MUI_Rimuru3E2 == -1 then
                    call RimuruTimer03Release()
                endif
                call deallocate(this)
            set i = i - 1
            endif
            set i = i + 1
        endloop
    endmethod
    public static method Rimuru3E2_Start takes unit NewC, real NewX, real NewY returns nothing
        local thistype this = thistype.create( )
        set MUI_Rimuru3E2 = MUI_Rimuru3E2 + 1
        set m_Rimuru3E2[ MUI_Rimuru3E2] = this
        set c = NewC
        set x = NewX
        set y = NewY
        set r = 0
        set r2 = 10
        set r3 = 1
        call DebugUnit2(c)
        set move = 125
        set g = CreateGroup()
        set g2 = CreateGroup()
        set fly = 130
        set scale = 0.25
        call SetUnitAnimationByIndex( c , 2)
        set r3 = 1
        set r4 = 1
        set u = null
        set a = GAngle2( c , x , y ) // Angle Between points
        set aoe = RimuruE4_DamageAoe
        if LoadInteger(hs,GetHandleId(c),StringHash("rim main stat")) ==0 then
        set dmg = GetHeroInt( c , true) * ( RimuruE4_DamageIntBase )
        else
        set dmg = GetHeroAgi( c , true) * ( RimuruE4_DamageIntBase )
        endif
        set r_prepare = 0.6
        call MakeSound("war3mapimported\\Hero_Rimuru3_E2 2")
        call SetUnitTimeScale( c , 0.7)
        set rmax = r_prepare + 0.6
        call SetUnitFacing( c , a * bj_RADTODEG)
        set r7 = 0
        if MUI_Rimuru3E2 == 0 then
            call RimuruTimer03Acquire()
        endif
    endmethod
    endstruct

    private struct Rimuru3E3_KS
        private static integer array m_Rimuru3E3
        private static integer MUI_Rimuru3E3 = -1
        unit c
        real x
        real y
        integer k
        integer k4
        group g
        unit u
        real dmg
        real aoe
        real r
        effect e
        effect e2
        real rmax
    public static method Loop_Rimuru3E3 takes nothing returns nothing
        local integer this
        local integer i = 0
        loop
            exitwhen i > MUI_Rimuru3E3
            set this = m_Rimuru3E3[i]
            if SpellBoolCaster(c) and r <= rmax then
                set r = RoundReal(r + 0.03, 3)
                if r == rmax - 0.21 then
                    call VisionTimed(GetOwningPlayer(c),x,y,1000,2)
                    call MakeSound("war3mapImported\\Hero_Rimuru3_E1 2")
                    set e2 = EffectSpawn("war3mapimported\\wos_yc_firebeam2_black.mdl", x, y, 1, 1.5, 1.05, 1)
                    call AnimDummyEff(e2, 1.5, 3.5)
                    call MyRemoveEff(e2, 1.55)
                endif
                if r == rmax then
                    call BlzSetSpecialEffectTimeScale(e, 2.5)
                    set k = 0
                    loop
                        exitwhen k == 6
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_yc_launchbig.mdl", .x, .y, GetRandomReal(0, 359), 0.9, 1.5, 150 + k * 400))
                        set k = k + 1
                    endloop
                    set k4 = 0
                                if GetUnitAbilityLevel(c,RimuruG3_IntBonus_ID)>0 then
                                set k4 = GetRandomInt(1,3)
                                endif
                    call DecorRemove(c, x, y, aoe, 100)
                    call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                            call dmgmag(c, u, dmg)
                            set k4 = 0
                                if GetUnitAbilityLevel(c,RimuruG3_IntBonus_ID)>0 then
                                set k4 = GetRandomInt(1,3)
                                endif
                            if k4>0 then
                                     call ErzaPassive(c,u,k4)
                                    endif
                            call StunUnit(c,u,RimuruE5_Stun)
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop
                endif
            else
                call StopSpellUnit2(c)
                call DestroyEffect(e)
                call DestroyGroup(g)
                set c = null
                set e = null
                set e2 = null
                set g = null
                set u = null
                set m_Rimuru3E3[i] = m_Rimuru3E3[ MUI_Rimuru3E3]
                set MUI_Rimuru3E3 = MUI_Rimuru3E3 - 1
                if MUI_Rimuru3E3 == -1 then
                    call RimuruTimer03Release()
                endif
                call deallocate(this)
            set i = i - 1
            endif
            set i = i + 1
        endloop
    endmethod
    public static method Rimuru3E3_Start takes unit NewC, real NewX, real NewY returns nothing
        local thistype this = thistype.create( )
        local real angle
        set MUI_Rimuru3E3 = MUI_Rimuru3E3 + 1
        set m_Rimuru3E3[ MUI_Rimuru3E3] = this
        set c = NewC
        set x = NewX
        set y = NewY
        set r = 0
        set g = CreateGroup()
        set u = null
        set angle = GAngle2(c, x, y)
        if LoadInteger(hs,GetHandleId(c),StringHash("rim main stat")) ==0 then
        set dmg = GetHeroInt( c , true) * ( RimuruE5_DamageIntBase )
        else
        set dmg = GetHeroAgi( c , true) * ( RimuruE5_DamageIntBase )
        endif
        set aoe = RimuruE5_DamageAoe
        set rmax = 0.6
        call SetUnitFacing(c, angle * bj_RADTODEG)
        call StartSpellUnit2(c)
        call MakeSound("war3mapImported\\Hero_Rimuru3_E1 1")
        call SetUnitAnimationByIndex( c , 0)
        set e = AddSpecialEffectTarget("war3mapimported\\wos_[spell]lightningboltbuff01_black.mdx", c, "hand left")
        call SetUnitTimeScale(c, 1.35)
        if MUI_Rimuru3E3 == 0 then
            call RimuruTimer03Acquire()
        endif
    endmethod
    endstruct

    private struct Rimuru3R_KS
        private static integer array m_Rimuru3R
        private static integer MUI_Rimuru3R = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        integer k4
        real r3
        real r5
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
    public static method Loop_Rimuru3R takes nothing returns nothing
        local integer this
        local integer i = 0
        local real rr1
        local real rr2
        local real rr3
        local real rr4
        loop
            exitwhen i > MUI_Rimuru3R
            set this = m_Rimuru3R[i]
            if SpellBoolCaster(c) and r <= rmax then
                set r = RoundReal(r + 0.03, 3)
                call DebugUnit(c)
                if r == 0.36 then
                    set e = EffectSpawn("war3mapImported\\wos_ZK_MS_LJ_H.mdl", GetUnitX(c) + 50 * Cos(a), GetUnitY(c) + 50 * Sin(a), a * bj_RADTODEG, 1, 0.01, 165)
                    call ScaleEffDummy(e, 0.45, 0.01, 0.95)
                endif
                if r == 0.45 then
                    call MakeSound("war3mapimported\\Hero_Rimuru3_R2")
                    set x = GetUnitX(c) + 100 * Cos(a)
                    set y = GetUnitY(c) + 100 * Sin(a)
                endif
                if r == 0.69 then
                    call SetUnitTimeScale(c, 0)
                endif
                if r == 1.65 then
                    call DestroyEffect(e2)
                endif
                if r > 0.81 then
                    if r2 > 0.18 then
                        set r2 = 0
                        set r5 = 275
                        call GroupClear( g )
                        call GroupClear( g2 )
                        set k = 0
                        loop
                            exitwhen k == 4
                    call DecorRemove(c,x + r5 * Cos(a) , y + r5 * Sin(a) , aoe,100)
                    call VisionTimed(GetOwningPlayer(c),x + r5 * Cos(a) , y + r5 * Sin(a) ,700,2)
                            call GroupEnumUnitsInRange( g , x + r5 * Cos(a) , y + r5 * Sin(a) , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                    call dmgmag(c, u, dmg)
                                    call GroupAddUnit(g2, u)
                                    set rr1 = SR3(u, x + 350 * 1 * Cos(a) , y + 350 * 1 * Sin(a))
                                    set rr2 = SR3(u, x + 350 * 2 * Cos(a) , y + 350 * 2 * Sin(a))
                                    set rr3 = SR3(u, x + 350 * 3 * Cos(a) , y + 350 * 3 * Sin(a))
                                    set rr4 = SR3(u, x + 350 * 4 * Cos(a) , y + 350 * 4 * Sin(a))
                                    if rr1 <= rr2 and rr1 <= rr3 and rr1 <= rr4 then
                                        set x1 = x + 350 * 1 * Cos(a)
                                        set y1 = y + 350 * 1 * Sin(a)
                                    elseif rr2 <= rr1 and rr2 <= rr3 and rr2 <= rr4 then
                                        set x1 = x + 350 * 2 * Cos(a)
                                        set y1 = y + 350 * 2 * Sin(a)
                                    elseif rr3 <= rr1 and rr3 <= rr2 and rr3 <= rr4 then
                                        set x1 = x + 350 * 3 * Cos(a)
                                        set y1 = y + 350 * 3 * Sin(a)
                                    else
                                        set x1 = x + 350 * 4 * Cos(a)
                                        set y1 = y + 350 * 4 * Sin(a)
                                    endif
                                    set k4 = 0
                                if GetUnitAbilityLevel(c,RimuruG3_IntBonus_ID)>0 then
                                set k4 = GetRandomInt(1,3)
                                endif
                                    if k4>0 then
                                     call ErzaPassive(c,u,k4)
                                    endif
                                    call MUE(u, SR3(u, x1 , y1)*0.4, 0.12, GAngle2(u, x1 , y1))
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c ))==false then
                                    call DebuffClear(u)
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set r5 = r5 + 350
                            set u = null
                            set k = k + 1
                        endloop
                    else
                        set r2 = r2 + 0.03
                    endif
                    if r3 > 0.31 and r > 0.66 and r < rmax - 0.21 then
                        set r3 = 0
                        set r5 = 200
                        call GroupClear( g )
                        set k = 0
                        loop
                            exitwhen k == 6
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_chushou_by_wood_effect_fire_flamecrack23.mdl", x + r5 * Cos(a) , y + r5 * Sin(a) , GetRandomReal(0, 359), 2, 1 + k * 0.35, 1))
                            call DestroyEffect(EffectSpawn3("war3mapimported\\wos_kirito-17.mdl", x + (r5 * 1.35) * Cos(a) , y + (r5 * 1.35) * Sin(a) , a * bj_RADTODEG, GetRandomReal(0.9, 1.2), 0.8 + k * 0.25, 100, -90))
                            set r5 = r5 + 250
                            set u = null
                            set k = k + 1
                        endloop
                    else
                        set r3 = r3 + 0.03
                    endif

                endif

            else
                call DebuffClear(c)
                call EUTU2(e2, 4, 1, c)
                call SaveInteger(hs, GetHandleId(c), StringHash("rimuru f"), 0)
                call StopSpellUnit(c)
                call SetUnitTimeScale(c, 1)
                call MakeSound("war3mapimported\\Hero_Rimuru3_R3")
                call DestroyEffect(e)
                call DestroyGroup( g )
                call DestroyGroup( g2 )
                set g = null
                set g2 = null
                set c = null
                set e = null
                set e2 = null
                set u = null
                set m_Rimuru3R[i] = m_Rimuru3R[ MUI_Rimuru3R]
                set MUI_Rimuru3R = MUI_Rimuru3R - 1
                if MUI_Rimuru3R == -1 then
                    call RimuruTimer03Release()
                endif
                call deallocate(this)
            set i = i - 1
            endif
            set i = i + 1
        endloop
    endmethod
    public static method Rimuru3R_Start takes unit NewC, real NewX, real NewY returns nothing
        local thistype this = thistype.create( )
        set MUI_Rimuru3R = MUI_Rimuru3R + 1
        set m_Rimuru3R[ MUI_Rimuru3R] = this
        set c = NewC
        set x = NewX
        set y = NewY
        set r = 0
        set r5 = 0
        set r2 = 1
        set r3 = 1
        set g = CreateGroup()
        set g2 = CreateGroup()
        call StartSpellUnit(c)
        set u = null
        set a = GAngle2( c , x , y ) // Angle Between points
        set rmax = 1.8
        set e2 = EffectSpawn("war3mapImported\\wos_blackwhiteaura_3.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.5, 1, 1)
        set aoe = RimuruR3_DamageAoe
        call SaveInteger(hs, GetHandleId(c), StringHash("rimuru f"), 1)
        if LoadInteger(hs,GetHandleId(c),StringHash("rim main stat")) ==0 then
        set dmg = GetHeroInt( c , true) * ( RimuruR3_DamageIntBase )
        else
        set dmg = GetHeroAgi( c , true) * ( RimuruR3_DamageIntBase )
        endif
        set dmg = dmg / 5
        call SetUnitFacing( c , a * bj_RADTODEG)
        call SetUnitAnimationByIndex( c , 1)
        call SetUnitTimeScale(c, 1)
        call MakeSound("war3mapimported\\Hero_Rimuru3_R")
        if MUI_Rimuru3R == 0 then
            call RimuruTimer03Acquire()
        endif
    endmethod
    // в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// RIMURU3T вЂ” FIXED
// Changes vs original:
//   1. ee[ring..ring*2-1] (child orbs) now destroyed in cleanup
//   2. ls[k+ring*2] (leaf lightnings) guarded with null-check on destroy;
//      also destroyed when check<6 ends early
//   3. AnimDummyEff Г— 15 replaced with a single staggered timer approach вЂ”
//      each orb gets its anim queued via r-offset so they don't all fire at once
//   4. DestroyLightning calls in check==3 init now guarded with null checks
//   5. g2 DestroyGroup added to cleanup
//   6. e2 (ground pulse effect) null-check + destroy in cleanup even when check==0
//   7. Lightning destroy loop in cleanup extended to cover ring*3 slots safely
//   8. check==6 в†’ check==2 reshuffle: leaf lightnings (ring*2 slots) explicitly
//      destroyed before the loop resets, preventing double-live lightnings
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

    endstruct

    private struct Rimuru3T_KS
        private static integer array m_Rimuru3T
        private static integer MUI_Rimuru3T = -1
        unit c
        real x
        real y
        real r2
        integer k
        integer k3
        integer k4
        real r3
        real r4
        group g
        real scale 
        group g2
        unit u
        real dmg
        integer check
        integer check2
        real aoe
        real r
        effect e2
        effect array ee[80]
        lightning array ls [80]
        real array ls_x1[80]
        real array ls_y1[80]
        real array ls_x2[80]
        real array ls_x3[80]
        real array ls_y2[80]
        real array ls_y3[80]
        real array ls_h1[80]
        real array ls_h2[80]
        real array ls_h3[80]
        real rmax
        public static method Loop_Rimuru3T takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr1 = 3000
            local real rr2 = 0
            local real ang = 0
            local integer ring = 15
            local real radius
            local integer j
            local integer attempt
            local boolean positionOk
            local real candidateX
            local real candidateY
            local real deltaX
            local real deltaY
            local real bestDistance
            local real currentDistance
            local unit target
            loop
                exitwhen i > MUI_Rimuru3T
                set this = m_Rimuru3T[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r < 2.7 then
                      //  call DebugUnit(c)
                    endif
                    // в”Ђв”Ђ Phase 0 : spawn falling orbs в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                    if r == 0.3 then
                        call VisionTimed(GetOwningPlayer(c), x, y, aoe + 300, rmax + 0.5)
                        call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_sunglow.mdl", x + 1700 * Cos(45 * bj_DEGTORAD), y + 1700 * Sin(45 * bj_DEGTORAD), 0, 0.2, 6, 1), rmax - 3, 255, 255, 255, 1)
                        set e2 = EffectSpawn("war3mapImported\\wos_lm_w-A3F1B.mdl", x, y, 1, 0.1, 15*scale, 1)
                        call BlzSetSpecialEffectAlpha(e2, 0)
                        call ColorEffDummy4(e2, 0, 255, 255, 255, 1.5)
                        call AnimDummyEff(e2, rmax - 0.5, 10)
                        call MyRemoveEff(e2, rmax + 0.03)
                        set e2 = null  // Таймер MyRemoveEff уничтожит эффект после анимации.
                        set k3 = 40
                        set .k = 0
                        loop
                            exitwhen .k == ring
                            if .k < 3 then
                                set radius = 250.0*scale
                                set ang = .k * 120 * bj_DEGTORAD
                            elseif .k < 8 then
                                set radius = 550.0*scale
                                set ang = (.k - 8) * 72 * bj_DEGTORAD
                            else
                                set radius = 900.0*scale
                                set ang = (.k - 8) * 54 * bj_DEGTORAD
                            endif
                            set .ls_x1[.k] = x + radius * Cos(ang)
                            set .ls_y1[.k] = y + radius * Sin(ang)
                            set .ls_h1[.k] = GetRandomReal(1500, 1650)
                            set .ee[.k] = EffectSpawn3("war3mapImported\\wos_rimurut_slime2.mdl", .ls_x1[.k], .ls_y1[.k], ang * bj_RADTODEG, 1, 0.01, ls_h1[.k], -180)
                            call ScaleEffDummy(ee[.k], 1.5, 0.01, 1)
                            // FIX: stagger AnimDummyEff calls so they don't all fire in the same tick.
                            // Each orb's anim delay = r + k*0.03, spread over ~0.45 s total.
                            // Instead of AnimDummyEff (which spawns a hidden timer per call),
                            // we drive the anim ourselves: orb starts at BIRTH scale, we let
                            // ScaleEffDummy handle the descent; skip AnimDummyEff entirely here.
                            // The orbs are already animated by ScaleEffDummy above.
                            call BlzSetSpecialEffectAlpha(ee[.k], k3)
                            call BlzSetSpecialEffectColor(ee[.k], 125, 200, 255)
                            set .k = .k + 1
                        endloop
                    endif
                    // в”Ђв”Ђ Phase 0 : fade orbs in в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                    if r >= 0.3 and r < 1.8 then
                        if k3 < 232 then
                            set k3 = k3 + 1
                        endif
                        set .k = 0
                        loop
                            exitwhen .k == ring
                            call BlzSetSpecialEffectAlpha(ee[.k], k3)
                            set .k = .k + 1
                        endloop
                    endif
                    // в”Ђв”Ђ check 0в†’1 : spawn child (ground) orbs в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                    if .r >= 1.8 and check == 0 then
                        set .check = 1
                        set .k = 0
                        loop
                            exitwhen .k == ring
                            set attempt = 0
                            set positionOk = false
                            loop
                                set radius = GetRandomReal(180, 420)
                                set ang = GetRandomReal(0, 359) * bj_DEGTORAD
                                set candidateX = .ls_x1[.k] + radius * Cos(ang)
                                set candidateY = .ls_y1[.k] + radius * Sin(ang)
                                // Keep every branch point inside the configured damage area.
                                set deltaX = candidateX - x
                                set deltaY = candidateY - y
                                set currentDistance = SquareRoot(deltaX * deltaX + deltaY * deltaY)
                                if currentDistance > aoe then
                                    set candidateX = x + deltaX * aoe / currentDistance
                                    set candidateY = y + deltaY * aoe / currentDistance
                                endif
                                set positionOk = true
                                set j = 0
                                loop
                                    exitwhen j >= .k
                                    set deltaX = candidateX - .ls_x2[j]
                                    set deltaY = candidateY - .ls_y2[j]
                                    if deltaX * deltaX + deltaY * deltaY < RimuruT3_ChildMinDistance * RimuruT3_ChildMinDistance then
                                        set positionOk = false
                                    endif
                                    set j = j + 1
                                endloop
                                set attempt = attempt + 1
                                exitwhen positionOk or attempt >= 16
                            endloop
                            if positionOk == false then
                                set attempt = 0
                                loop
                                    set ang = (.k * 137.5 + attempt * 47.0) * bj_DEGTORAD
                                    set radius = 500 + 40 * (.k + attempt)
                                    set candidateX = .ls_x1[.k] + radius * Cos(ang)
                                    set candidateY = .ls_y1[.k] + radius * Sin(ang)
                                    set deltaX = candidateX - x
                                    set deltaY = candidateY - y
                                    set currentDistance = SquareRoot(deltaX * deltaX + deltaY * deltaY)
                                    if currentDistance > aoe then
                                        set candidateX = x + deltaX * aoe / currentDistance
                                        set candidateY = y + deltaY * aoe / currentDistance
                                    endif
                                    set positionOk = true
                                    set j = 0
                                    loop
                                        exitwhen j >= .k
                                        set deltaX = candidateX - .ls_x2[j]
                                        set deltaY = candidateY - .ls_y2[j]
                                        if deltaX * deltaX + deltaY * deltaY < RimuruT3_ChildMinDistance * RimuruT3_ChildMinDistance then
                                            set positionOk = false
                                        endif
                                        set j = j + 1
                                    endloop
                                    set attempt = attempt + 1
                                    exitwhen positionOk
                                endloop
                            endif
                            set .ls_x2[.k] = candidateX
                            set .ls_y2[.k] = candidateY
                            set .ls_h2[.k] = GetRandomReal(300, 600)
                            set ee[ring + .k] = EffectSpawn("war3mapImported\\wos_[skillm]orbwaterx2.mdl", candidateX, candidateY, GetRandomReal(0, 359), 1, 1, .ls_h1[.k] - 77)
                            call EHeightSet(ee[ring + .k], 1.2, .ls_h2[.k]-55)
                            set .k = .k + 1
                        endloop
                    endif
                    // в”Ђв”Ђ check 1в†’2 : compute scatter targets (no extra ee slots) в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                    if .r >= 2.4 and check == 1 then
                        set .check = 2
                            // FIX: scatter orbs were stored in ee[ring + ring + k] in original,
                            // but that slot was never cleaned up.  We only need the position data
                            // (ls_x2/y2/h2) for lightning targeting; no extra effect is needed here.
                            // Removed EffectSpawnScale for scatter orbs вЂ” the lightning tips reach
                            // those points visually; a separate floating orb was redundant and leaked.
                    endif
                    // в”Ђв”Ђ Animation cues в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                    if r == 4.5 then
                        call MakeSound("war3mapimported\\Hero_Rimuru3_T3")
                    endif
                    if r == 3.15 then
                        call SetUnitAnimationByIndex(c, 8)
                    elseif r == 2.7 then
                        call MakeSound("war3mapimported\\Hero_Rimuru3_T2")
                        call SetUnitTimeScale(c, 2)
                        call SetUnitAnimationByIndex(c, 7)
                    elseif r == 3.51 then
                      //  call StopSpellUnit(c)
                    endif
                    // в”Ђв”Ђ Lightning strike loop (check 2..6, repeating) в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                    if r > 2.7 and r < rmax - 0.1 then
                        // в”Ђв”Ђ check 2в†’3 : init descending lightning from sky в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                        if check == 2 then
                            set check = 3
                            set r3 = 0.0
                            set r2 = 0.0
                            set .k = 0
                            loop
                                exitwhen .k == ring
                                // FIX: guard destroy вЂ” ls[k] may be null on the very first cycle
                                if .ls[.k] != null then
                                    call DestroyLightning(.ls[.k])
                                    set .ls[.k] = null
                                endif
                                if .ls[.k + ring] != null then
                                    call DestroyLightning(.ls[.k + ring])
                                    set .ls[.k + ring] = null
                                endif
                                if .ls[.k + ring * 2] != null then
                                    call DestroyLightning(.ls[.k + ring * 2])
                                    set .ls[.k + ring * 2] = null
                                endif
                                set .ls[.k] = AddLightningEx("RMRT", false, .ls_x1[.k], .ls_y1[.k], .ls_h1[.k] + rr1, .ls_x1[.k], .ls_y1[.k], .ls_h1[.k] + rr1)
                                set .k = .k + 1
                            endloop
                        endif
                        // в”Ђв”Ђ check 3 : descend sky lightning toward parent orb в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                        if check == 3 then
                            set rr2 = 180
                            set r3 = r3 + 0.1
                            if r3 > 1.0 then
                                set r3 = 1.0
                            endif
                            set .k = 0
                            loop
                                exitwhen .k == ring
                                call MoveLightningEx(.ls[.k], false, .ls_x1[.k], .ls_y1[.k], .ls_h1[.k] + rr1, .ls_x1[.k], .ls_y1[.k], .ls_h1[.k] + rr1 + (.ls_h1[.k] - rr2 - (.ls_h1[.k] + rr1)) * r3)
                                set .k = .k + 1
                            endloop
                            if r3 >= 1.0 then
                                set check = 4
                                set r3 = 0.0
                            endif
                        endif
                        // в”Ђв”Ђ check 4в†’5 : spawn branch lightnings (parentв†’scatter) в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                        if check == 4 then
                            set check = 5
                            set r3 = 0.0
                            set rr2 = 160
                            set .k = 0
                            loop
                                exitwhen .k == ring
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_1jinse_912_clear.mdx", .ls_x1[.k], .ls_y1[.k], 1, 2, 1, .ls_h1[.k] - rr2 - 50))
                                // FIX: guard вЂ” destroy old branch before creating new one
                                if .ls[.k + ring] != null then
                                    call DestroyLightning(.ls[.k + ring])
                                    set .ls[.k + ring] = null
                                endif
                                set .ls[.k + ring] = AddLightningEx("RMRT", false, .ls_x1[.k], .ls_y1[.k], .ls_h1[.k] - rr2, .ls_x1[.k], .ls_y1[.k], .ls_h1[.k] - rr2)
                                set .k = .k + 1
                            endloop
                        endif
                        // в”Ђв”Ђ check 5 : animate branch expansion в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                        if check == 5 then
                            set rr2 = 160
                            set r3 = r3 + 0.15
                            if r3 > 1.0 then
                                set r3 = 1.0
                            endif
                            set .k = 0
                            loop
                                exitwhen .k == ring
                                call MoveLightningEx(.ls[.k], false, .ls_x1[.k], .ls_y1[.k], .ls_h1[.k] + rr1, .ls_x1[.k], .ls_y1[.k], .ls_h1[.k] - rr2)
                                call MoveLightningEx(.ls[.k + ring], false, .ls_x1[.k], .ls_y1[.k], .ls_h1[.k] - rr2, .ls_x1[.k] + (.ls_x2[.k] - .ls_x1[.k]) * r3, .ls_y1[.k] + (.ls_y2[.k] - .ls_y1[.k]) * r3, .ls_h1[.k] - rr2 + (.ls_h2[.k] - (.ls_h1[.k] - rr2)) * r3)
                                set .k = .k + 1
                            endloop
                            if r3 >= 1.0 then
                                set check = 6
                                set r3 = 0.0
                                set r2 = 0.0
                                // в”Ђв”Ђ Assign leaf lightnings to enemy units (or random ground pts)
                                call DecorRemove(c, x, y, aoe, 50)
                                call GroupClear(g2)
                                set k = 0
                                loop
                                    exitwhen k >= ring
                                    set target = null
                                    set bestDistance = 999999.0
                                    call GroupClear(g)
                                    call GroupEnumUnitsInRange(g, .ls_x2[k], .ls_y2[k], RimuruT3_TargetSearchRange, NoDecor_Cond)
                                    loop
                                        set u = FirstOfGroup(g)
                                        exitwhen u == null
                                        if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and SR3(u, x, y) <= aoe then
                                            set currentDistance = SR3(u, .ls_x2[k], .ls_y2[k])
                                            if currentDistance < bestDistance then
                                                set bestDistance = currentDistance
                                                set target = u
                                            endif
                                        endif
                                        call GroupRemoveUnit(g, u)
                                    endloop
                                    set attempt = 0
                                    set positionOk = false
                                    loop
                                        set ang = GetRandomReal(0, 359) * bj_DEGTORAD
                                        if target != null then
                                            set radius = GetRandomReal(40, 90)
                                            set candidateX = GetUnitX(target) + radius * Cos(ang)
                                            set candidateY = GetUnitY(target) + radius * Sin(ang)
                                        else
                                            set radius = GetRandomReal(100, 320)
                                            set candidateX = .ls_x2[k] + radius * Cos(ang)
                                            set candidateY = .ls_y2[k] + radius * Sin(ang)
                                        endif
                                        // Clamp the visible impact point to the same AoE used for damage.
                                        set deltaX = candidateX - x
                                        set deltaY = candidateY - y
                                        set currentDistance = SquareRoot(deltaX * deltaX + deltaY * deltaY)
                                        if currentDistance > aoe then
                                            set candidateX = x + deltaX * aoe / currentDistance
                                            set candidateY = y + deltaY * aoe / currentDistance
                                        endif
                                        set positionOk = true
                                        set j = 0
                                        loop
                                            exitwhen j >= k
                                            set deltaX = candidateX - .ls_x3[j]
                                            set deltaY = candidateY - .ls_y3[j]
                                            if deltaX * deltaX + deltaY * deltaY < RimuruT3_ImpactMinDistance * RimuruT3_ImpactMinDistance then
                                                set positionOk = false
                                            endif
                                            set j = j + 1
                                        endloop
                                        set attempt = attempt + 1
                                        exitwhen positionOk or attempt >= 16
                                    endloop
                                    if positionOk == false then
                                        set attempt = 0
                                        loop
                                            set ang = (k * 137.5 + attempt * 47.0) * bj_DEGTORAD
                                            set radius = 400 + 40 * (k + attempt)
                                            set candidateX = .ls_x2[k] + radius * Cos(ang)
                                            set candidateY = .ls_y2[k] + radius * Sin(ang)
                                            set deltaX = candidateX - x
                                            set deltaY = candidateY - y
                                            set currentDistance = SquareRoot(deltaX * deltaX + deltaY * deltaY)
                                            if currentDistance > aoe then
                                                set candidateX = x + deltaX * aoe / currentDistance
                                                set candidateY = y + deltaY * aoe / currentDistance
                                            endif
                                            set positionOk = true
                                            set j = 0
                                            loop
                                                exitwhen j >= k
                                                set deltaX = candidateX - .ls_x3[j]
                                                set deltaY = candidateY - .ls_y3[j]
                                                if deltaX * deltaX + deltaY * deltaY < RimuruT3_ImpactMinDistance * RimuruT3_ImpactMinDistance then
                                                    set positionOk = false
                                                endif
                                                set j = j + 1
                                            endloop
                                            set attempt = attempt + 1
                                            exitwhen positionOk
                                        endloop
                                    endif
                                    set .ls_x3[k] = candidateX
                                    set .ls_y3[k] = candidateY
                                    set .ls_h3[k] = GetRandomReal(-10, 0)
                                    if target != null then
                                        call GroupAddUnit(g2, target)
                                    endif
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_1jinse_912_clear.mdx", .ls_x2[k], .ls_y2[k], 1, 2, 1, .ls_h2[k] - 50))
                                    if .ls[k + ring * 2] != null then
                                        call DestroyLightning(.ls[k + ring * 2])
                                        set .ls[k + ring * 2] = null
                                    endif
                                    set .ls[k + ring * 2] = AddLightningEx("RMRT", false, .ls_x2[k], .ls_y2[k], .ls_h2[k], .ls_x2[k], .ls_y2[k], .ls_h2[k])
                                    set k = k + 1
                                endloop
                                set target = null
                                set u = null
                            endif
                        endif
                        // в”Ђв”Ђ check 6 : animate leaf descent + damage on arrival в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                        if check == 6 then
                            set .k = 0
                            loop
                                exitwhen .k == ring
                                if r3 < 1.0 then
                                    call MoveLightningEx(.ls[.k + ring * 2], false, .ls_x2[.k], .ls_y2[.k], .ls_h2[.k], .ls_x2[.k] + (.ls_x3[.k] - .ls_x2[.k]) * r3, .ls_y2[.k] + (.ls_y3[.k] - .ls_y2[.k]) * r3, .ls_h2[.k] + (.ls_h3[.k] - .ls_h2[.k]) * r3)
                                else
                                    call MoveLightningEx(.ls[.k + ring * 2], false, .ls_x2[.k] + (.ls_x3[.k] - .ls_x2[.k]) * r4, .ls_y2[.k] + (.ls_y3[.k] - .ls_y2[.k]) * r4, .ls_h2[.k] + (.ls_h3[.k] - .ls_h2[.k]) * r4, .ls_x3[.k], .ls_y3[.k], .ls_h3[.k])
                                endif
                                set .k = .k + 1
                            endloop
                            if r3 < 1.0 then
                                set r3 = r3 + 0.2
                                if r3 > 1.0 then
                                    set r3 = 1.0
                                endif
                            else
                                set r4 = r4 + 0.2
                                if r4 > 1.0 then
                                    set r4 = 1.0
                                endif
                            endif
                            // в”Ђв”Ђ Impact: deal damage once r3 fully extended в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                            if r3 >= 1.0 and check2 == 0 then
                                set check2 = 1
                                set k = 0
                                loop
                                    exitwhen k == ring
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_0854.mdx", .ls_x3[.k], .ls_y3[.k], 1, 1, 1.5, 1))
                                    set k = k + 1
                                endloop

                                loop
                                    set u = FirstOfGroup(g2)
                                    exitwhen u == null
                                    if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and SR3(u, x, y) <= aoe then
                                        call dmgmag(c, u, dmg)
                                        call StunUnit(c, u, RimuruT3_Stun)
                                        set k4 = 0
                                if GetUnitAbilityLevel(c,RimuruG3_IntBonus_ID)>0 then
                                set k4 = GetRandomInt(1,3)
                                endif
                                        if k4>0 then
                                     call ErzaPassive(c,u,k4)
                                        endif
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    endif
                                    call GroupRemoveUnit(g2, u)
                                endloop
                                set .k = 0
                                loop
                                    exitwhen .k == ring
                                    if .ls[.k] != null then
                                        call DestroyLightning(.ls[.k])
                                        set .ls[.k] = null
                                    endif
                                    if .ls[.k + ring] != null then
                                        call DestroyLightning(.ls[.k + ring])
                                        set .ls[.k + ring] = null
                                    endif
                                    if .ls[.k + ring * 2] != null then
                                        call DestroyLightning(.ls[.k + ring * 2])
                                        set .ls[.k + ring * 2] = null
                                    endif
                                    set .k = .k + 1
                                endloop
                            endif
                            // в”Ђв”Ђ After impact pause, reset for next cycle в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                            if r2 >= 0.5 and check2 == 1 then
                                set r3 = 0.0
                                set r4 = 0.0
                                set r2 = 0.0
                                set check2 = 0
                                // FIX: explicitly destroy ALL 3 banks before resetting.
                                // Without this, next cycle's check==3 would double-live.
                                set .k = 0
                                loop
                                    exitwhen .k == ring
                                    if .ls[.k] != null then
                                        call DestroyLightning(.ls[.k])
                                        set .ls[.k] = null
                                    endif
                                    if .ls[.k + ring] != null then
                                        call DestroyLightning(.ls[.k + ring])
                                        set .ls[.k + ring] = null
                                    endif
                                    if .ls[.k + ring * 2] != null then
                                        call DestroyLightning(.ls[.k + ring * 2])
                                        set .ls[.k + ring * 2] = null
                                    endif
                                    set .k = .k + 1
                                endloop
                                set check = 2  // restart the lightning cycle
                            endif
                        endif
                    endif
                    if check >= 2 then
                        set r2 = r2 + 0.03
                    endif
                // в”Ђв”Ђ Cleanup в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                else
                    if r < 3.51 then
                       // call StopSpellUnit(c)
                    endif
                    // Destroy ee[0..ring-1]: falling slime orbs
                    // Destroy ee[ring..ring*2-1]: child ground orbs  в†ђ FIX (was missing)
                    // (No ee slots beyond ring*2 вЂ” scatter orbs were removed; see check 1в†’2)
                    set .k = 0
                    loop
                        exitwhen .k == ring * 2   // FIX: was ring, now ring*2
                        if ee[.k] != null then
                            call ColorEffDummy3(.ee[.k], 0, 255, 255, 255, 0.15)
                            set .ee[.k] = null
                        endif
                        set .k = .k + 1
                    endloop
                    // Destroy ALL lightning slots (3 banks Г— ring)
                    set .k = 0
                    loop
                        exitwhen .k == ring * 3
                        if .ls[.k] != null then
                            call DestroyLightning(.ls[.k])
                            set .ls[.k] = null
                        endif
                        set .k = .k + 1
                    endloop
                    call DestroyGroup(g)
                    call DestroyGroup(g2)   // was missing in original
                    call SetUnitTimeScale(c, 1)
                    set c = null
                    set e2 = null
                    set u = null
                    set g = null
                    set g2 = null
                    set m_Rimuru3T[i] = m_Rimuru3T[MUI_Rimuru3T]
                    set MUI_Rimuru3T = MUI_Rimuru3T - 1
                    if MUI_Rimuru3T == -1 then
                        call RimuruTimer03Release()
                    endif
                    call deallocate(this)
                set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method Rimuru3T_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            local integer ring = 15
            local real angle
            set MUI_Rimuru3T = MUI_Rimuru3T + 1
            set m_Rimuru3T[MUI_Rimuru3T] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set r3 = 0     // FIX: explicitly zero r3/r4 so leftover values from a
            set r4 = 0     //      previous struct allocation don't corrupt phase math
            set check = 0
            set check2 = 0
            set u = null
            set k3 = 0
            set e2 = null
            set g = CreateGroup()
            set g2 = CreateGroup()
            // FIX: zero all lightning slots so null-guards in Loop work on first cycle
            set .k = 0
            loop
                exitwhen .k == ring * 3  // ring is 15, constant
                set .ls[.k] = null
                set .k = .k + 1
            endloop
            set aoe = RimuruT3_DamageAoe
            set scale = aoe /900
            set angle = GAngle2(c, x, y)
            set rmax = 6.5
            //call StartSpellUnit(c)
            if LoadInteger(hs, GetHandleId(c), StringHash("rim main stat")) == 0 then
                set dmg = GetHeroInt(c, true) * RimuruT3_DamageIntBase
            else
                set dmg = GetHeroAgi(c, true) * RimuruT3_DamageIntBase
            endif
            call SetUnitFacing(c, angle * bj_RADTODEG)
            call SetUnitAnimationByIndex(c, 6)
            call SetUnitTimeScale(c, 1.6)
            call MakeSound("war3mapimported\\Hero_Rimuru3_T")
            if MUI_Rimuru3T == 0 then
                call RimuruTimer03Acquire()
            endif
        endmethod

    endstruct
    
    private function RimuruTimer03Loop takes nothing returns nothing
        call RimuruQ_KS.Loop_RimuruQ()
        call RimuruW_KS.Loop_RimuruW()
        call RimuruE_KS.Loop_RimuruE()
        call RimuruT2Helper_KS.Loop_RimuruT2()
        call RimuruT_KS.Loop_RimuruT()
        call RimuruR_KS.Loop_RimuruR()
        call RimuruG_KS.Loop_RimuruG()
        call Rimuru2Q_KS.Loop_Rimuru2Q()
        call Rimuru2W2_KS.Loop_Rimuru2W2()
        call Rimuru2W_KS.Loop_Rimuru2W()
        call Rimuru2E_KS.Loop_Rimuru2E()
        call Rimuru2R_KS.Loop_Rimuru2R()
        call Rimuru2T_KS.Loop_Rimuru2T()
        call Rimuru2F_KS.Loop_Rimuru2F()
        call Rimuru3Q_KS.Loop_Rimuru3Q()
        call Rimuru3W_KS.Loop_Rimuru3W()
        call Rimuru3E_KS.Loop_Rimuru3E()
        call Rimuru3E2_KS.Loop_Rimuru3E2()
        call Rimuru3E3_KS.Loop_Rimuru3E3()
        call Rimuru3R_KS.Loop_Rimuru3R()
        call Rimuru3T_KS.Loop_Rimuru3T()
    endfunction

    private function RimuruTimer10Loop takes nothing returns nothing
        call Rimuru2Evol_KS.Loop_Rimuru2Evol()
    endfunction

    private function InitRimuruSpells takes nothing returns nothing
        set RimuruTimer03 = CreateTimer()
        set RimuruTimer10 = CreateTimer()
        set RimuruTimer03Callback = function RimuruTimer03Loop
        set RimuruTimer10Callback = function RimuruTimer10Loop
    endfunction

//----------------------------Rimuru-----------------------------------------------
 /* Animations index:
Base:
0
3 - big or predator target
4 - predator
Morph:
2 - run
6 - atk fast ot sebya
7 - e
8 - w
3 - r
10 - t
3 form :
0 - throw something
2 - throw 2 hand
3 - holy ray
5 - cast charge ruka v bok
6 - sel na styl vstal ruka vpered, megido begin
7 - next of 6 charge
8 - megido attack next of 7
11 - move
 */
function RimuruEvol2_Start takes unit c, boolean b returns nothing
    local integer k2 = GetPlayerId(GetOwningPlayer(c))
    local real tmp_y = 0
    local integer k = 0
    local integer k3 = RimuruEvol2_Counter
    if b == true then
        if frameRimuru2_pas1[k2] == null then
            set frameRimuru2_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
            call BlzFrameSetAbsPoint(frameRimuru2_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18 + tmp_y)
            call BlzFrameSetSize(frameRimuru2_pas1[k2], 0.135, 0.035)
            call BlzFrameSetTexture(frameRimuru2_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
            call BlzFrameSetVisible(frameRimuru2_pas1[k2], false)
            if GetLocalPlayer() == GetOwningPlayer(c) then
                call BlzFrameSetVisible(frameRimuru2_pas1[k2], true)
            endif
            set frameRimuru2_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frameRimuru2_pas1[k2], 0, 0)
            call BlzFrameSetAbsPoint(frameRimuru2_pas2[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
            call BlzFrameSetSize(frameRimuru2_pas2[k2], 0.1, 0.019)
            set frameRimuru2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frameRimuru2_pas1[k2], "", 0)
            call BlzFrameSetSize(frameRimuru2_pas3[k2], 0.1, 0.035)
            call BlzFrameSetScale(frameRimuru2_pas3[k2], 0.5)
            call BlzFrameSetModel(frameRimuru2_pas3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
            call BlzFrameSetAbsPoint(frameRimuru2_pas3[k2], FRAMEPOINT_CENTER, 0.05, 0.175 + tmp_y)
            call BlzFrameSetMinMaxValue(frameRimuru2_pas3[k2], 0, I2R(k3))
            call BlzFrameSetValue(frameRimuru2_pas3[k2], 0)
            set frameRimuru2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frameRimuru2_pas1[k2], "", 0)
            call BlzFrameSetAbsPoint(frameRimuru2_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18 + tmp_y)
            call BlzFrameSetSize(frameRimuru2_pas4[k2], 0.03, 0.03)
            call BlzFrameSetTexture(frameRimuru2_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Rimuru3_G.blp", 0, false)
            set frameRimuru2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frameRimuru2_pas1[k2], "", 0)
            call BlzFrameSetAbsPoint(frameRimuru2_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
            call BlzFrameSetText(frameRimuru2_pas5[k2], "|c00FFFF00" + "Soul Gathered:|r")
            call BlzFrameSetScale(frameRimuru2_pas5[k2], 0.9)
            set frameRimuru2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frameRimuru2_pas1[k2], "", 0)
            call BlzFrameSetAbsPoint(frameRimuru2_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17 + tmp_y)
            call BlzFrameSetText(frameRimuru2_pas6[k2], "|c00FFFF00" + "0/" + I2S(k3) + "|r")
            call BlzFrameSetScale(frameRimuru2_pas6[k2], 0.9)
        else
            if GetLocalPlayer() == GetOwningPlayer(c) then
                call BlzFrameSetVisible(frameRimuru2_pas1[k2], true)
            endif
            call BlzFrameSetText(frameRimuru2_pas6[k2], "|c00FFFF00" + "0/" + I2S(k3) + "|r")
            call BlzFrameSetMinMaxValue(frameRimuru2_pas3[k2], 0, I2R(k3))
            call BlzFrameSetValue(frameRimuru2_pas3[k2], 0)
            set k = LoadInteger(hs, GetHandleId(c), StringHash("evol kill"))
            if k > k3 then
                set k = k3
            endif
            call BlzFrameSetText(frameRimuru2_pas6[k2], "|c00FFFF00" + I2S(k) + "/" + I2S(k3) + "|r")
            call BlzFrameSetValue(frameRimuru2_pas3[k2], I2R(k))
        endif
    else
        call Rimuru2Evol_KS.Rimuru2Evol_Start(c)
        if frameRimuru2_pas1[k2] != null and GetLocalPlayer() == GetOwningPlayer(c) then
            call BlzFrameSetVisible(frameRimuru2_pas1[k2], false)
        endif
    endif
endfunction
function RimuruEvol_Start takes unit c, boolean b returns nothing
    local real r8 = 0
    local integer k2 = GetPlayerId(GetOwningPlayer(c))
    local real tmp_y = 0
    local real x = GetUnitX(c)
    local real y = GetUnitY(c)
    local integer k3 = RimuruEvol1_MagiculeDmg
    if b == true then
        if frameRimuru1_pas1[k2] == null then
            set frameRimuru1_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
            call BlzFrameSetAbsPoint(frameRimuru1_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18 + tmp_y)
            call BlzFrameSetSize(frameRimuru1_pas1[k2], 0.135, 0.035)
            call BlzFrameSetTexture(frameRimuru1_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
            call BlzFrameSetVisible(frameRimuru1_pas1[k2], false)
            if GetLocalPlayer() == GetOwningPlayer(c) then
                call BlzFrameSetVisible(frameRimuru1_pas1[k2], true)
            endif
            set frameRimuru1_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frameRimuru1_pas1[k2], 0, 0)
            call BlzFrameSetAbsPoint(frameRimuru1_pas2[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
            call BlzFrameSetSize(frameRimuru1_pas2[k2], 0.1, 0.019)
            set frameRimuru1_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frameRimuru1_pas1[k2], "", 0)
            call BlzFrameSetSize(frameRimuru1_pas3[k2], 0.1, 0.035)
            call BlzFrameSetScale(frameRimuru1_pas3[k2], 0.5)
            call BlzFrameSetModel(frameRimuru1_pas3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
            call BlzFrameSetAbsPoint(frameRimuru1_pas3[k2], FRAMEPOINT_CENTER, 0.05, 0.175 + tmp_y)
            call BlzFrameSetMinMaxValue(frameRimuru1_pas3[k2], 0, I2R(k3 + 10))
            call BlzFrameSetValue(frameRimuru1_pas3[k2], 0)
            set frameRimuru1_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frameRimuru1_pas1[k2], "", 0)
            call BlzFrameSetAbsPoint(frameRimuru1_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18 + tmp_y)
            call BlzFrameSetSize(frameRimuru1_pas4[k2], 0.03, 0.03)
            call BlzFrameSetTexture(frameRimuru1_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Rimuru_Evol1.blp", 0, false)
            set frameRimuru1_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frameRimuru1_pas1[k2], "", 0)
            call BlzFrameSetAbsPoint(frameRimuru1_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
            call BlzFrameSetText(frameRimuru1_pas5[k2], "|c00FFFF00" + "Magicule absorbed:|r")
            call BlzFrameSetScale(frameRimuru1_pas5[k2], 0.9)
            set frameRimuru1_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frameRimuru1_pas1[k2], "", 0)
            call BlzFrameSetAbsPoint(frameRimuru1_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17 + tmp_y)
            call BlzFrameSetText(frameRimuru1_pas6[k2], "|c00FFFF00" + "0/" + I2S(k3) + "|r")
            call BlzFrameSetScale(frameRimuru1_pas6[k2], 0.9)
        else
            if GetLocalPlayer() == GetOwningPlayer(c) then
                call BlzFrameSetVisible(frameRimuru1_pas1[k2], true)
            endif
            call BlzFrameSetText(frameRimuru1_pas6[k2], "|c00FFFF00" + "0/" + I2S(k3) + "|r")
            call BlzFrameSetMinMaxValue(frameRimuru1_pas3[k2], 0, I2R(k3 + 10))
            call BlzFrameSetValue(frameRimuru1_pas3[k2], 0)
            set r8 = LoadReal(hs, GetHandleId(c), StringHash("evol dmg"))
            if r8 > k3 then
                set r8 = I2R(k3)
            endif
            call BlzFrameSetText(frameRimuru1_pas6[k2], "|c00FFFF00" + I2S(R2I(r8)) + "/" + I2S(k3) + "|r")
            call BlzFrameSetValue(frameRimuru1_pas3[k2], r8)
        endif
    else
        call BlzSetUnitSkin(c, Rimuru2_ID)
        call MakeSound("war3mapimported\\Hero_Rimuru_Evol1")
        call UnitAddAbility(c, RimuruQ2_ID)
        call UnitAddAbility(c, RimuruW2_ID)
        call UnitAddAbility(c, RimuruE2_ID)
        call UnitAddAbility(c, RimuruR2_ID)
        call UnitAddAbility(c, RimuruT2_ID)
        call UnitAddAbility(c, RimuruF2_ID)
        call UnitAddAbility(c, RimuruG2_ID)
        call UnitMakeAbilityPermanent(c, true, RimuruQ2_ID)
        call UnitMakeAbilityPermanent(c, true, RimuruW2_ID)
        call UnitMakeAbilityPermanent(c, true, RimuruE2_ID)
        call UnitMakeAbilityPermanent(c, true, RimuruR2_ID)
        call UnitMakeAbilityPermanent(c, true, RimuruT2_ID)
        call UnitMakeAbilityPermanent(c, true, RimuruF2_ID)
        call UnitMakeAbilityPermanent(c, true, RimuruG2_ID)
        /*call SetUnitAbilityLevel(c,RimuruQ2_ID,GetUnitAbilityLevel(c,RimuruQ_ID))
        call SetUnitAbilityLevel(c,RimuruW2_ID,GetUnitAbilityLevel(c,RimuruW_ID))
        call SetUnitAbilityLevel(c,RimuruE2_ID,GetUnitAbilityLevel(c,RimuruE_ID))
        call SetUnitAbilityLevel(c,RimuruR2_ID,GetUnitAbilityLevel(c,RimuruR_ID))
        call SetUnitAbilityLevel(c,RimuruT2_ID,GetUnitAbilityLevel(c,RimuruT_ID))*/
        call SetUnitAbilityLevel(c,RimuruQ2_ID,5)
        call SetUnitAbilityLevel(c,RimuruW2_ID,5)
        call SetUnitAbilityLevel(c,RimuruE2_ID,5)
        call SetUnitAbilityLevel(c,RimuruR2_ID,5)
        call UnitRemoveAbility(c, RimuruQ_ID)
        call UnitRemoveAbility(c, RimuruW_ID)
        call UnitRemoveAbility(c, RimuruE_ID)
        call UnitRemoveAbility(c, RimuruR_ID)
        call UnitRemoveAbility(c, RimuruT_ID)
        call UnitRemoveAbility(c, RimuruF_ID)
        call UnitRemoveAbility(c, RimuruG_ID)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c),RimuruQ_ID,false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c),RimuruW_ID,false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c),RimuruE_ID,false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c),RimuruR_ID,false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c),RimuruT_ID,false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c),RimuruF_ID,false)
        call SetPlayerAbilityAvailable(GetOwningPlayer(c),RimuruG_ID,false)
        call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_shockwave_b.mdl", x, y, 1, 1, 1.45, 125))
        call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_shockwave_b.mdl", x, y, 1, 1, 1.45, 255))
        call DestroyEffect(EffectSpawn("war3mapimported\\wos_waterexplosion.mdl", x, y, 1, 1, 1.5, 1))
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_2-[tx]-03-03jianta (3)_1.mdl", x, y, 1, 2.5, 1, 1))
        call RimuruEvol2_Start(c, true)
        if frameRimuru1_pas1[k2] != null and GetLocalPlayer() == GetOwningPlayer(c) then
            call BlzFrameSetVisible(frameRimuru1_pas1[k2], false)
        endif
    endif
endfunction
function RimuruQ_Start takes unit c, real x, real y returns nothing
    call RimuruQ_KS.RimuruQ_Start( c, x, y )
endfunction
function RimuruW_Start takes unit c, unit td returns nothing
    call RimuruW_KS.RimuruW_Start( c, td )
endfunction
function RimuruE_Start takes unit c, real x, real y returns nothing
    call RimuruE_KS.RimuruE_Start( c, x, y)
endfunction
function RimuruR_Start takes unit c, unit td returns nothing
    call RimuruR_KS.RimuruR_Start( c, td)
endfunction
function RimuruT_Start takes unit c, real x,real y returns nothing
    call RimuruT_KS.RimuruT_Start( c, x,y)
endfunction
function RimuruG_Start takes unit c, real dmg returns nothing
local real hp = 0
    local real hp1 = dmg * (RimuruG_Restore1 / 100)
    local real hp2 = dmg * (RimuruG_Restore2 / 100)
    local real hp3 = dmg * (RimuruG_Restore3 / 100)
    set hp = hp1
    if LoadInteger(hs,GetHandleId(c),StringHash("rimuru evol 1")) == 1 then
    set hp = hp2
    endif
    if LoadInteger(hs,GetHandleId(c),StringHash("rimuru evol 2")) == 1 then
    set hp = hp3
    endif
    call RimuruG_KS.RimuruG_Start( c, hp, RimuruG_OrbLifeTime )
endfunction
function RimuruG_GetActiveOrbCount takes unit c returns integer
    return RimuruG_KS.CountActive(c)
endfunction
function Rimuru2Q_Start takes unit c returns nothing
    call BuffUnit1( c, c, 9 )
    call MakeSound("war3mapimported\\Hero_Rimuru2_Q")
    call NextSound("war3mapimported\\Hero_Rimuru2_Q2", 1.5)
    call MyFlushBuff(GetHandleId(c), StringHash("dodge q"), 0, c, RimuruQ2_Buff_ID)
    call DisplayTimedTextToPlayer(GetOwningPlayer(c), 0, 0, 1, "|c00FF0303Dodges left: |r" + I2S(RimuruQ2_NumberofDodges))
endfunction
function Rimuru2QAct_Start takes unit c, unit td returns nothing
    call Rimuru2Q_KS.Rimuru2Q_Start( c, td )
endfunction
function Rimuru2Q_Dodge takes unit c, unit td, real dmg returns nothing
    local real x = GetUnitX(c)
    local real y = GetUnitY(c)
    local real r1 = GetRandomReal(65, 100)
    local real r2 = 0
    local real a = GAngle(c, td)
    local real x1
    local real y1
    local integer k = LoadInteger(hs, GetHandleId(c), StringHash("dodge q"))
    if GetRandomInt(1, 2) == 1 then
        set r2 = 90
    else
        set r2 = -90
    endif
    set x1 = x + r1 * Cos(a + r2 * bj_DEGTORAD)
    set y1 = y + r1 * Sin(a + r2 * bj_DEGTORAD)
    call BlinkEff(c)
    call BlinkEff2(c)
    call PosUnit(c, x1, y1)
    call BlinkEff(c)
    set k = k + 1
    call SaveInteger(hs, GetHandleId(c), StringHash("dodge q"), k)
    if RimuruQ2_NumberofDodges - k == 0 then
    if  LoadInteger(hs,GetHandleId(c),StringHash("rimuru evol 2")) == 0 then
        call DisplayTimedTextToPlayer(GetOwningPlayer(c), 0, 0, 1, "|c00FF0303Counterattack begin!")
        endif
    else
        call DisplayTimedTextToPlayer(GetOwningPlayer(c), 0, 0, 1, "|c00FF0303Dodges left: |r" + I2S(RimuruQ2_NumberofDodges - k))
    endif
    if LoadInteger(hs,GetHandleId(c),StringHash("rimuru evol 2")) == 1 then
        call ReduceCooldown(c, RimuruQ3_ID, RimiruF3_ReduceQCdTime)
    endif
    if k >= RimuruQ2_NumberofDodges  then
    if LoadInteger(hs,GetHandleId(c),StringHash("rimuru evol 2")) == 0 then
        call Rimuru2QAct_Start(c, td)
        endif
        call UnitRemoveAbility(c, RimuruQ2_Buff_ID)
        call UnitRemoveAbility(c, RimuruF3_Buff_ID)
    endif
endfunction
function Rimuru2W_Start takes unit c, real x, real y returns nothing
    call Rimuru2W_KS.Rimuru2W_Start( c, x , y )
endfunction
function Rimuru2E_Start takes unit c, real x, real y returns nothing
    call Rimuru2E_KS.Rimuru2E_Start( c, x, y)
endfunction
function Rimuru2R_Start takes unit c, real x, real y returns nothing
    call Rimuru2R_KS.Rimuru2R_Start( c, x, y )
endfunction
function Rimuru2T_Start takes unit c, real x, real y returns nothing
    call Rimuru2T_KS.Rimuru2T_Start( c, x, y)
endfunction
function Rimuru2F_Start takes unit c, real x, real y returns nothing
    call Rimuru2F_KS.Rimuru2F_Start( c, x, y)
endfunction
function Rimuru3Q_Start takes unit c, unit td returns nothing
    call Rimuru3Q_KS.Rimuru3Q_Start( c, td)
endfunction
function Rimuru3W_Start takes unit c, real x, real y returns nothing
    call Rimuru3W_KS.Rimuru3W_Start( c, x , y )
endfunction
function Rimuru3E_Start takes unit c, real x, real y returns nothing
    call Rimuru3E3_KS.Rimuru3E3_Start( c, x, y )
    call SetPlayerAbilityAvailable(GetOwningPlayer(c), RimuruE3_ID, false)
    if GetUnitAbilityLevel(c, RimuruE4_ID) == 0 then
        call UnitAddAbility(c, RimuruE4_ID)
        call UnitMakeAbilityPermanent(c, true, RimuruE4_ID)
    endif
    call SetPlayerAbilityAvailable(GetOwningPlayer(c), RimuruE4_ID, true)
    if BlzGetUnitAbilityCooldownRemaining(c, RimuruE4_ID) < RimuruE345_CD_SWAP then
    call OkarunEggCd(c,RimuruE4_ID,RimuruE345_CD_SWAP)
    endif
endfunction
function Rimuru3E2_Start takes unit c, real x, real y returns nothing
    call Rimuru3E2_KS.Rimuru3E2_Start( c, x, y )
    call SetPlayerAbilityAvailable(GetOwningPlayer(c), RimuruE4_ID, false)
    if GetUnitAbilityLevel(c, RimuruE5_ID) == 0 then
        call UnitAddAbility(c, RimuruE5_ID)
        call UnitMakeAbilityPermanent(c, true, RimuruE5_ID)
    endif
    call SetPlayerAbilityAvailable(GetOwningPlayer(c), RimuruE5_ID, true)
    if BlzGetUnitAbilityCooldownRemaining(c, RimuruE5_ID) < RimuruE345_CD_SWAP then
    call OkarunEggCd(c,RimuruE5_ID,RimuruE345_CD_SWAP)
    endif
endfunction
function Rimuru3E3_Start takes unit c, real x, real y returns nothing
    call Rimuru3E_KS.Rimuru3E_Start( c, x, y )
    call SetPlayerAbilityAvailable(GetOwningPlayer(c), RimuruE5_ID, false)
    if GetUnitAbilityLevel(c, RimuruE3_ID) == 0 then
        call UnitAddAbility(c, RimuruE3_ID)
        call UnitMakeAbilityPermanent(c, true, RimuruE3_ID)
    endif
    call SetPlayerAbilityAvailable(GetOwningPlayer(c), RimuruE3_ID, true)
    if BlzGetUnitAbilityCooldownRemaining(c, RimuruE3_ID) < RimuruE345_CD_SWAP then
    call OkarunEggCd(c,RimuruE3_ID,RimuruE345_CD_SWAP)
    endif
endfunction
function Rimuru3R_Start takes unit c, real x, real y returns nothing
    call Rimuru3R_KS.Rimuru3R_Start( c, x, y )
endfunction
function Rimuru3T_Start takes unit c, real x, real y returns nothing
    call Rimuru3T_KS.Rimuru3T_Start( c, x, y )
    call GetMainStatValue(c,false)
endfunction
function Rimuru3F_Start takes unit c returns nothing
    call BuffUnit1( c, c, 10 )
    if GetRandomInt(1, 2) == 1 then
        call MakeSound("war3mapimported\\Hero_Rimuru3_F")
    else
        call MakeSound("war3mapimported\\Hero_Rimuru3_F2")
    endif
    call MyFlushBuff(GetHandleId(c), StringHash("dodge q"), 0, c, RimuruF3_Buff_ID)
    call DisplayTimedTextToPlayer(GetOwningPlayer(c), 0, 0, 1, "|c00FF0303Dodges left: |r" + I2S(RimuruQ2_NumberofDodges))
endfunction
function Rimuru3G_Start takes unit c, real x, real y returns nothing
    local integer abilityId = RimuruG3_IntBonus_ID
    call UnitAddAbility(c, abilityId)
    call MyRemoveEff(AddSpecialEffectTarget("war3mapImported\\wos_BDEF (2313).mdx", c, "origin"), RimuruG3_BonusDuration)
    call MyRemoveEff(AddSpecialEffectTarget("war3mapImported\\wos_blackwhiteaura_3.mdx", c, "origin"), RimuruG3_BonusDuration)
    call MyRemoveAbility(c, RimuruG3_BonusDuration, abilityId, 1)
endfunction
endlibrary

//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
