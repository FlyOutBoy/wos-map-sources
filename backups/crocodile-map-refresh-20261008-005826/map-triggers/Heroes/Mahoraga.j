library MahoragaSpells uses GearSystems
    globals
//--------------------------------------Mahoraga--------------------------------------------------------------
        integer Mahoraga_ID = 'H021'
        framehandle array frameMahoraga_pas1 [10]
        framehandle array frameMahoraga_pas2 [10]
        framehandle array frameMahoraga_pas3 [10]
        framehandle array frameMahoraga_pas4 [10]
        framehandle array frameMahoraga_pas5 [10]
        framehandle array frameMahoraga_pas6 [10]
        unit array mahodummy1 
//---------------G ability-----------------------------------------------------
//---------------Q ability-----------------------------------------------------
        integer MahoragaQ_ID = 'A0CD'
        real MahoragaQ_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real MahoragaQ_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real MahoragaQ_Damage2StaticBase = 175 // base static damage for 1 level
        real MahoragaQ_Damage2StaticStep = 0 // additional static damage for each next level
        real MahoragaQ_DamageAoe = 150
        real MahoragaQ_Stun = 1
//---------------Q2 ability-----------------------------------------------------
        integer MahoragaQ2_ID = 'A0CE'
        real MahoragaQ2_DamageAgiBase = 4 // base number x Agi damage for 1 level
        real MahoragaQ2_DamageAoe = 525
        real MahoragaQ2_Stun = 0.1
        real MahoragaQ2_TimeSwap = 3 // how long q2 will be after q end
//---------------W ability-----------------------------------------------------
        integer MahoragaW_ID = 'A0CF'
        real MahoragaW_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real MahoragaW_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real MahoragaW_Damage2StaticBase = 200 // base static damage for 1 level
        real MahoragaW_Damage2StaticStep = 0 // additional static damage for each next level
        real MahoragaW_DamageAoe = 655
        integer MahoragaW_Slow = 30 // Caused slow %
        integer MahoragaW_SlowDuration = 2 // slow time 2, 3, 4 sec only
//---------------W2 ability-----------------------------------------------------
        integer MahoragaW2_ID = 'A0CG'
        real MahoragaW2_DamageAgiBase = 3 // base number x Agi damage for 1 level
        real MahoragaW2_Range = 1400 // base number x Agi damage for 1 level
        real MahoragaW2_Duration = 0.9 // base number x Agi damage for 1 level
        real MahoragaW2_Stun = 0.9 // base number x Agi damage for 1 level
//---------------E ability-----------------------------------------------------
        integer MahoragaE_ID = 'A0CH'
        real MahoragaE_DamageAgiBase = 2 // base number x Agi damage for 1 level
        real MahoragaE_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real MahoragaE_DamageAoe = 675
        real MahoragaE_Range = 1100 // how long from start caster pos you can move
//---------------E2 ability-----------------------------------------------------
        integer MahoragaE2_ID = 'A0CI'
        integer MahoragaE2_Buff_ID = 'B01O'
        real MahoragaE2_DamageAgiBase = 5 // base number x Agi damage for 1 level
        real MahoragaE2_TimeSwap = 3
        real MahoragaE2_DamageAoe = 155
//---------------E3 ability-----------------------------------------------------
        integer MahoragaE3_ID = 'A0CJ'
        real MahoragaE3_DamageAoe = 675
        real MahoragaE3_DamageAgiBase = 5 // base number x Agi damage for 1 level
        real MahoragaE3_DamageAddForBuildings = 20 // %
        real MahoragaE3_Range = 1400 // how long from start target pos you can move
//---------------R ability-----------------------------------------------------
        integer MahoragaR_ID = 'A0CK'
        real MahoragaR_HealAgiBase = 4 // base number x Agi damage for 1 level
        real MahoragaR_HealAgiStep = 1 // additional number x Agi damage for each next level
       // real MahoragaR_HealBonusT = 30 //%
        real MahoragaR_Duration = 1
//---------------T ability-----------------------------------------------------
        integer MahoragaT_ID = 'A0CL'
        integer MahoragaT_Unit_ID = 'h022'
        integer MahoragaT_Abi_ID1 = 'B01G'
        integer MahoragaT_Abi_ID2 = 'B01H'
        integer MahoragaT_Abi_ID3 = 'B01I'
        integer MahoragaT_Abi_ID4 = 'B01J'
        integer MahoragaT_Abi_ID5 = 'B01K'
        integer MahoragaT_Abi_ID6 = 'B01L'
        integer MahoragaT_Abi_ID7 = 'B01M'
        integer MahoragaT_Abi_ID8 = 'B01N'
        integer MahoragaT_DamageToReduceCD = 1750
        real MahoragaT_ReduceCDAfterDone = 1
        real MahoragaT_DamageReductionPerStack = 5 // %
        real MahoragaT_CD = 5
        real MahoragaT_CondAoeFind = 3000
        real MahoragaT_DamageTreshold = 50 
//---------------G ability-----------------------------------------------------
        integer MahoragaG_ID = 'A0CN'
        real MahoragaG_DamageAgiBase = 9 // base number x Agi damage for 1 level
//---------------F ability-----------------------------------------------------
        integer MahoragaF_ID = 'A0CM'
        real MahoragaF_DamageAgiBase = 5 // agi number of damage
        real MahoragaF_DamageAoe = 335 // for both variants of e
        real MahoragaF_PushRange = 600 // not lower than 3.0
        real MahoragaF_PushDuration = 0.45 // not lower than 3.0
//------------------------------------------------------------------------------
    endglobals
    private struct MahoragaSpells_Q
        private static timer t_MahoragaQ = CreateTimer()
        private static integer array m_MahoragaQ
        private static integer MUI_MahoragaQ = -1
        private static timer t_MahoragaQ2 = CreateTimer()
        private static integer array m_MahoragaQ2
        private static integer MUI_MahoragaQ2 = -1
        unit c
        unit td
        real x
        real y
        real x1
        real y1
        real r2
        real r6
        group g
        unit u
        real dmg
        integer check2
        real aoe
        real move
        real r
        effect e
        real a
        real rmax

        private static method Loop_MahoragaQ takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_MahoragaQ
                set this = m_MahoragaQ[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    if r == 0.15 then
                        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_YC_CrossFlash.mdl", c, "weapon"))
                    endif
                    if r == 0.21 then
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 2.25, 1, 255, 255, 255, 255))
                    endif
                    if r == 0.33 then
                        call MakeSound("war3mapimported\\Hero_Mahoraga_Q 3")
                    endif
                    if r == 0.42 then
                        call SetUnitAnimationByIndex(c, 6)
                        call SetUnitTimeScale(c, 1.35)
                    endif
                    if r > 0.54 then
                        if SR2(c, td) > 160 then
                            set a = GAngle(c, td)
                            call MoveUnit(c, move, a)
                            if SR2(c, td) < 520 and check2 == 0 then
                                set check2 = 1
                                call SetUnitAnimationByIndex(c, 3)
                                call SetUnitTimeScale(c, 1)
                                call MakeSound("war3mapimported\\Hero_Mahoraga_Q 2")
                            endif
                            call SetUnitFacing(c, a * bj_RADTODEG)
                        else
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            call PosUnit(c, x - 160 * Cos(a), y - 160 * Sin(a))
                            set r = 99999
                            if GetHeroLevel(c) >= 35 then
                                call SwapAbility(c, MahoragaQ2_TimeSwap, MahoragaQ2_ID, MahoragaQ_ID)
                                call MyFrame(c, MahoragaQ2_TimeSwap, "BTNHero_Mahoraga_Q2", false, 0)
                            endif
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_hitheavy.mdl", x , y , a * bj_RADTODEG, 1, 2.45, 125))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BDEF (124)2.mdx", x, y, GetRandomReal(0, 359), 1, 2.5, 125))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_bbb.mdl", x, y, a * bj_RADTODEG , 2.75, 1.35, 125))
                            call AddSpecialEffectTarget("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", td, "chest")
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_bloodex-special-23.mdl", GetUnitX(td), GetUnitY(td), GetRandomReal(0, 359), 2.5, 2, 80))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlash.mdl" , x + 25 * Cos(a), y + 25 * Sin(a), 1, 1., 1.475, 125))
                            call StunUnit(c, td, MahoragaQ_Stun )
                            call DecorRemove(c, x, y, aoe, 25)
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    call dmgatk(c, u, dmg)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        endif
                    endif
                else
                    call StopSpellUnit2(c)
                    call SetUnitTimeScale( c , 1)
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set e = null
                    set u = null
                    set m_MahoragaQ[i] = m_MahoragaQ[ MUI_MahoragaQ]
                    set MUI_MahoragaQ = MUI_MahoragaQ - 1
                    if MUI_MahoragaQ == -1 then
                        call PauseTimer( t_MahoragaQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MahoragaQ_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_MahoragaQ = MUI_MahoragaQ + 1
            set m_MahoragaQ[ MUI_MahoragaQ] = this
            set c = NewC
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r = 0
            set r2 = 0
            set move = 100
            set r6 = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set check2 = 0
            set a = GAngle2( c , x , y ) // Angle Between points
            set aoe = MahoragaQ_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( MahoragaQ_DamageAgiBase + ( MahoragaQ_DamageAgiStep * ( GetUnitAbilityLevel( c , MahoragaQ_ID) - 1 ) ) )
            set dmg = dmg + MahoragaQ_Damage2StaticBase + ( MahoragaQ_Damage2StaticStep * ( GetUnitAbilityLevel( c , MahoragaQ_ID) - 1 ) )
            set rmax = 2.9
            call SetUnitAnimationByIndex(c, 10)
            call SetUnitTimeScale(c, 1.01)
            call MakeSound("war3mapimported\\Hero_Mahoraga_Q")
            if MUI_MahoragaQ == 0 then
                call TimerStart( t_MahoragaQ, 0.03, true, function thistype.Loop_MahoragaQ)
            endif
        endmethod

        private static method Loop_MahoragaQ2 takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr1 = 0
            local real rr2 = 0
            local real rr3 = 0
            local real rr4 = 0
            local real rr5 = 0
            loop
                exitwhen i > MUI_MahoragaQ2
                set this = m_MahoragaQ2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if r == 0.21 then
                        call MakeSound("war3mapimported\\Hero_Mahoraga_Q2 1")
                    endif
                    call DebugUnit2(c)
                    if r2 > 0.15 then
                        set r2 = 0
                        set x = GetUnitX(c) + 250 * Cos(a)
                        set y = GetUnitY(c) + 250 * Sin(a)
                        set rr3 = GetRandomReal( -45, -15)
                        set rr4 = GetRandomReal(8, 9.5)
                        if GetRandomInt(1, 4) > 2 then
                            set rr3 = GetRandomReal( -345, -315)
                        endif
                        set rr5 = GetRandomReal(20, 150)
                        if check2 == 0 then
                            set check2 = 1
                            call DestroyEffect(EffectSpawn4("war3mapImported\\wos_VergilSlashes.mdl", GetUnitX(c) + rr5 * Cos(a) , GetUnitY(c) + rr5 * Sin(a) , a * bj_RADTODEG, 1.5, rr4, 255, rr3))
                        else
                            call ColorEffDummy3(EffectSpawn4("war3mapImported\\wos_VergilSlashes.mdl", GetUnitX(c) + rr5 * Cos(a) , GetUnitY(c) + rr5 * Sin(a) , a * bj_RADTODEG, 1.5, rr4, 255, rr3), 0.3, 255, 255, 255, 0.03)
                            set check2 = 0
                        endif
                        set rr1 = GetRandomReal(20, 165)
                        if GetRandomInt(1, 10) > 5 then
                            set rr2 = -90 * bj_DEGTORAD
                        else
                            set rr2 = 90 * bj_DEGTORAD
                        endif
                        set x1 = x + rr1 * Cos(a + rr2)
                        set y1 = y + rr1 * Sin(a + rr2)
                        set rr4 = GetRandomReal( -240, -30)
                        set rr5 = GetRandomReal(0, 150)
                        call DestroyEffect(EffectSpawn3("war3mapImported\\wos_acg_bbb.mdl", x + 150 * Cos(a), y + 150 * Sin(a), a * bj_RADTODEG , GetRandomReal(0, 359), 1.35, 225, rr4))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlash.mdl" , x1 + 25 * Cos(a), y1 + 25 * Sin(a), 1, 1.1, 1.475, 125 + rr5))
                        call DecorRemove(c, x, y, aoe, 25)
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                call dmgphys(c, u, dmg)
                                call StunUnit(c, u, MahoragaQ2_Stun)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    else
                        set r2 = r2 + 0.03
                    endif
                else
                    call StopSpellUnit2(c)
                    call SetUnitTimeScale( c , 1)
                    call DestroyGroup( g )
                    call SetUnitAnimation(c, "stand")
                    set g = null
                    set c = null
                    set u = null
                    set m_MahoragaQ2[i] = m_MahoragaQ2[ MUI_MahoragaQ2]
                    set MUI_MahoragaQ2 = MUI_MahoragaQ2 - 1
                    if MUI_MahoragaQ2 == -1 then
                        call PauseTimer( t_MahoragaQ2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MahoragaQ2_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_MahoragaQ2 = MUI_MahoragaQ2 + 1
            set m_MahoragaQ2[ MUI_MahoragaQ2] = this
            set c = NewC
            set a = GetUnitFacing(c) * bj_DEGTORAD
            set x = GetUnitX(c) + 210 * Cos(a)
            set y = GetUnitY(c) + 210 * Sin(a)
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            set r = 0
            set r2 = 0
            set r6 = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set check2 = 0
            set aoe = MahoragaQ2_DamageAoe
            set dmg = GetHeroAgi( c , true) * MahoragaQ2_DamageAgiBase
            set dmg = dmg / 7
            set rmax = 1.5
            call SetUnitAnimationByIndex(c, 14)
            call SetUnitTimeScale(c, 1.3)
            call MakeSound("war3mapimported\\Hero_Mahoraga_Q2 2")
            if MUI_MahoragaQ2 == 0 then
                call TimerStart( t_MahoragaQ2, 0.03, true, function thistype.Loop_MahoragaQ2)
            endif
        endmethod

    endstruct
  private struct MahoragaSpells_E
        private static timer t_MahoragaE3 = CreateTimer()
        private static integer array m_MahoragaE3
        private static integer MUI_MahoragaE3 = -1
        private static timer t_MahoragaE = CreateTimer()
        private static integer array m_MahoragaE
        private static integer MUI_MahoragaE = -1
        private static timer t_MahoragaE2 = CreateTimer()
        private static integer array m_MahoragaE2
        private static integer MUI_MahoragaE2 = -1
        unit c
        unit td
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        integer k2
        real scale
        real scale2
        real r5
        real r6
        group g
        group g2
        unit u
        real dmg
        real a2
        integer check2
        real aoe
        real move
        real r
        effect e
        effect e2
        effect e3
        effect e4
        effect e5
        real a
        real rmax

        private static method Loop_MahoragaE3 takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr = 0
            loop
                exitwhen i > MUI_MahoragaE3
                set this = m_MahoragaE3[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit(c)
                    call DebugUnit(td)
            // Phase 1: r <= 1.2 вЂ” Caster rises up (like normal E start)
                    if r <= 0.6 then
                        call SetFly(c, GetUnitFlyHeight(c) + r5)
                        call MoveUnit(c, r6, a2)
                    endif
                    if r == 0.03 then
                        set x1 = GetUnitX(td)
                        set y1 = GetUnitY(td)
                    endif
                    if r == 0.6 then
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        call SetUnitAnimation(td, "death")
                        call SetUnitTimeScale(td, 0.08)
                        call AddSpecialEffectTarget("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", td, "chest")
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_hitheavy.mdl", x , y , a * bj_RADTODEG, 0.5, 2.45, GetUnitFlyHeight(c) + 475))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_BDEF (124)2.mdx", x, y, GetRandomReal(0, 359), 0.5, 2.5, GetUnitFlyHeight(c) + 475))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_bbb.mdl", x, y, a * bj_RADTODEG , 1.85, 1.35, GetUnitFlyHeight(c) + 475))
                    endif
                    if r > 0.6 then
                        call SetUnitFacing(c, a * bj_RADTODEG)
                        set rr = GetUnitFacing(c) * bj_DEGTORAD
                        call PosUnit(td, GetUnitX(c) + 150 * Cos(rr), GetUnitY(c) + 150 * Sin(rr))
                        call SetFly(td, GetUnitFlyHeight(c) + 495)            
                    endif
                    if r == 0.72 then
                        call SetUnitTimeScale(c, 0.2)
                    endif
                    if r < 1.2 then
                        set x = GetMouseX(GetOwningPlayer(c))
                        set y = GetMouseY(GetOwningPlayer(c))
                      //  call BJDebugMsg(R2S(x)+"  "+R2S(y))
                        if r2 > 0.21 then
                            set r2 = 0
                            call VisionTimed(GetOwningPlayer(c), x, y, aoe * 2, 1)
                        else
                            set r2 = r2 + 0.03
                        endif
                        set a = GAngle4(x1, y1, x, y)
                        if SR0(x1, y1, x, y) > scale2 then
                            set x = x1 + scale2 * Cos(a)
                            set y = y1 + scale2 * Sin(a)
                        endif
                        if SR5(e, x, y) > move then
                            call MoveEff(e, move, GAngle5(e, x, y))
                        else
                            call BlzSetSpecialEffectPosition(e, x, y, 3)
                        endif
                    endif
            // Phase 2: r == 1.2 вЂ” Lock in angle toward td, begin dive
                    if r == 1.2 then
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        call SetUnitTimeScale(c, 2)
                        set a = GAngle2(c, x, y)
                        call SetUnitFacing(c, a * bj_RADTODEG)
                        set r5 = GetUnitFlyHeight(c) / 10
                        set r6 = (SR3(c, x, y) - 100) / 10
                        call MakeSound("war3mapimported\\Hero_Mahoraga_E3 2")
                    endif
            // Phase 3: r > 1.2 вЂ” Caster dives toward td, td tracks caster + 50 height
                    if r > 1.2 and r < rmax then
                        call MoveUnit(c, r6, a)
                        call SetFly(c, GetUnitFlyHeight(c) - r5)
                    endif
            // Phase 4: r == rmax вЂ” Land, deal AoE damage (like normal E)
                    if r == rmax then
                        call SaveInteger(hs, GetHandleId(c), StringHash("decor add"), 0)
                        set x = GetUnitX(c) + 150 * Cos(a)
                        set y = GetUnitY(c) + 150 * Sin(a)
                        call SetFly(c, 0)
                        call SetFly(td, 0)
                        call StopSpellUnit(c)
                        call StopSpellUnit(td)
                        call MakeSound("war3mapimported\\Hero_Mahoraga_E3 3")
                        call DecorRemove(c, x, y, aoe, 100)
                        if LoadInteger(hs, GetHandleId(c), StringHash("decor add")) > 0 then
                            set dmg = dmg * (1 + (MahoragaE3_DamageAddForBuildings / 100))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_hit wave white.mdl", x, y, GetRandomReal(0, 359), 0.65, 2, scale))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Effect Pieces.mdl", x, y, GetRandomReal(0, 359), 1, 3.25, scale - 110))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Effect Pieces.mdl", x, y, GetRandomReal(0, 359), 1, 3.25, scale - 110))
                        endif
                        call VisionTimed(GetOwningPlayer(c), x, y, aoe * 2, 2)
                        set k = 0
                        loop
                            exitwhen k > 7
                            set r5 = GetRandomReal(1.5, 1.8)
                            call EffectSpawn2("krk (1889)2.mdx", x + 350 * Cos(k * 54 * bj_DEGTORAD), y + 350 * Sin(k * 54 * bj_DEGTORAD), k * 54, r5, 3, 0, GetRandomReal(0.35, 0.7))
                            set k = k + 1
                        endloop
                            
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_AZ_TS_TZRed.mdl", x, y, a * bj_RADTODEG + 90, 2.5, 4, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (513)red.mdx", .x, .y, GetRandomReal(0, 359), 1.2, 0.75, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdx", .x, .y, GetRandomReal(0, 359), 0.5, 5, 1))
                        call GroupClear( g )
                        call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                call dmgphys(c, u, dmg)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    endif
                else
                    
                    call MouseOff(GetOwningPlayer(c))
                    call SetFly(c, 0)
                    call SetFly(td, 0)
                   // call BlzStartUnitAbilityCooldown(c,MahoragaE_ID,BlzGetUnitAbilityCooldownRemaining(c,MahoragaE3_ID))
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(MahoragaE_ID)), 0)
                    if GetHeroLevel(c) >= 25 then
                        call SwapAbility(c, MahoragaE2_TimeSwap, MahoragaE2_ID, MahoragaE_ID)
                        call MyFrame(c, MahoragaE2_TimeSwap, "BTNHero_Mahoraga_E2", false, 1)
                    endif
                    call PosUnit(td, GetUnitX(c), GetUnitY(c))
                    call StopSpellUnit(c)
                    call StopSpellUnit(td)
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call DestroyEffect(e3)
                    call DestroyEffect(e4)
                    call DestroyEffect(e5)
                    call SetUnitAnimation(c, "stand")
                    call SaveInteger(hs, GetHandleId(c), StringHash("height td"), 0)
                    call SaveInteger(hs, GetHandleId(c), StringHash("combo w"), 0)
                    call SaveInteger(hs, GetHandleId(c), StringHash("decor add"), 0)
                    call RemoveSavedHandle(hs, GetHandleId(c), StringHash("w target"))
                    call DestroyGroup(g)
                    set c = null
                    set td = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set e5 = null
                    set g = null
                    set u = null
                    set m_MahoragaE3[i] = m_MahoragaE3[MUI_MahoragaE3]
                    set MUI_MahoragaE3 = MUI_MahoragaE3 - 1
                    if MUI_MahoragaE3 == -1 then
                        call PauseTimer(t_MahoragaE3)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MahoragaE3_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_MahoragaE3 = MUI_MahoragaE3 + 1
            set m_MahoragaE3[MUI_MahoragaE3] = this
            set c = NewC
            set td = LoadUnitHandle(hs, GetHandleId(c), StringHash("w target"))
            set r = 0
            set x1 = GetUnitX(c)
            set y1 = GetUnitY(c)
            set a2 = GAngle(c, td)
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r2 = 0
            set r6 = SR2(c, td) / 20
            set scale2 = MahoragaE3_Range
            set move = 125
            set aoe = MahoragaE3_DamageAoe // use your constant, or reuse MahoragaE_DamageAoe
            set dmg = GetHeroAgi(c, true) * MahoragaE3_DamageAgiBase
            set rmax = 1.5 // same total duration as normal E dive phase
            set a = GAngle(c, td) // initial facing toward td
            call StartSpellUnit(c)
            set scale = 6
            call StartSpellUnit(td)
            set g = CreateGroup()
            set g2 = CreateGroup() // hit - tracking group so td isn't hit twice
            set u = null
            call MouseOn(GetOwningPlayer(c))
            set MouseX[GetPlayerId(GetOwningPlayer(c))] = x
            set MouseY[GetPlayerId(GetOwningPlayer(c))] = y
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(MahoragaE_ID)), 1)
            call SetUnitAnimationByIndex(c, 12) // same as normal E startup anim
            call SaveInteger(hs, GetHandleId(c), StringHash("height td"), 1)
            call SaveInteger(hs, GetHandleId(c), StringHash("decor add"), 0)
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(MahoragaE_ID)), 1)
            call MakeSound("war3mapimported\\Hero_Mahoraga_E3 1")
            set e = EffectSpawn("war3mapImported\\wos_[tx] (381).mdl", x1, y1, 1, 1, 0.01, 3)
            call ScaleEffDummy(e, 0.3, 0.01, scale)
            set r5 = (GetUnitFlyHeight(td) - 475) / 19
            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", c, "hand right")
            set e3 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", c, "hand left")
            set e4 = AddSpecialEffectTarget("Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdx", c, "hand right")
            set e5 = AddSpecialEffectTarget("Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdx", c, "hand left")
            if MUI_MahoragaE3 == 0 then
                call TimerStart(t_MahoragaE3, 0.03, true, function thistype.Loop_MahoragaE3)
            endif
        endmethod

        private static method Loop_MahoragaE takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_MahoragaE
                set this = m_MahoragaE[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if r < 0.66 then
                        call SetFly(c, GetUnitFlyHeight(c) + 25)
                    endif
                    if r == 0.72 then
                        call SetUnitTimeScale(c, 0.2)
                    endif
                    if r < 0.9 then
                        set x = GetMouseX(GetOwningPlayer(c))
                        set y = GetMouseY(GetOwningPlayer(c))
                        if r2 > 0.21 then
                            set r2 = 0
                            call VisionTimed(GetOwningPlayer(c), x, y, aoe * 2, 1)
                        else
                            set r2 = r2 + 0.03
                        endif
                        set a = GAngle4(x1, y1, x, y)
                        if SR0(x1, y1, x, y) > scale2 then
                            set x = x1 + scale2 * Cos(a)
                            set y = y1 + scale2 * Sin(a)
                        endif
                        if SR5(e, x, y) > move then
                            call MoveEff(e, move, GAngle5(e, x, y))
                        else
                            call BlzSetSpecialEffectPosition(e, x, y, 3)
                        endif
                        call SetUnitFacing(c, GAngle2(c, x, y) * bj_RADTODEG)
                    endif
                    if r == 0.9 then
                        call SetUnitTimeScale(c, 2)
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        call MakeSound("war3mapimported\\Hero_Mahoraga_E 2")
                        set a = GAngle2(c, x, y)
                        call SetUnitFacing(c, a * bj_RADTODEG)
                        set r5 = GetUnitFlyHeight(c) / 10
                        set r6 = (SR3(c, x, y) - 100) / 10
                    endif
                    if r > 0.9 and r < rmax then
                        call MoveUnit(c, r6, a)
                        call SetFly(c, GetUnitFlyHeight(c) - r5)
                    endif
                    if r == rmax then
                        set x = GetUnitX(c) + 110 * Cos(a)
                        set y = GetUnitY(c) + 110 * Sin(a)
                        call MakeSound("war3mapimported\\Hero_Mahoraga_E 3")
                        call DecorRemove(c, x, y, aoe, 100)
                        
                    call StopSpellUnit(c)
                        call VisionTimed(GetOwningPlayer(c), x, y, aoe * 2, 2)
                        set k = 0
                        loop
                            exitwhen k > 7
                            set r5 = GetRandomReal(1.5, 1.8)
                            call EffectSpawn2("krk (1889)2.mdx", x + 350 * Cos(k * 54 * bj_DEGTORAD), y + 350 * Sin(k * 54 * bj_DEGTORAD), k * 54, r5, 3, 0, GetRandomReal(0.35, 0.7))
                            set k = k + 1
                        endloop
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (513)red.mdx", .x, .y, GetRandomReal(0, 359), 1.2, 0.75, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdx", .x, .y, GetRandomReal(0, 359), 0.5, 5, 1))
                        call GroupClear( g )
                        call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                call dmgphys(c, u, dmg)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                        call StopSpellUnit(c)
                    endif
                else
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call DestroyEffect(e3)
                    call MouseOff(GetOwningPlayer(c))
                    call StopSpellUnit(c)
                    call DestroyGroup(g)
                    if GetHeroLevel(c) >= 25 then
                        call SwapAbility(c, MahoragaE2_TimeSwap, MahoragaE2_ID, MahoragaE_ID)
                        call MyFrame(c, MahoragaE2_TimeSwap, "BTNHero_Mahoraga_E2", false, 1)
                    endif
                    set c = null
                    set td = null
                    set g = null
                    set e = null
                    set g2 = null
                    set m_MahoragaE[i] = m_MahoragaE[ MUI_MahoragaE]
                    set MUI_MahoragaE = MUI_MahoragaE - 1
                    if MUI_MahoragaE == -1 then
                        call PauseTimer( t_MahoragaE)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MahoragaE_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_MahoragaE = MUI_MahoragaE + 1
            set m_MahoragaE[ MUI_MahoragaE] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set x1 = GetUnitX(c)
            set y1 = GetUnitY(c)
            set k2 = 0
            set aoe = MahoragaE_DamageAoe
            set a = GAngle2(c, x, y)
            call StartSpellUnit(c)
            set g = CreateGroup()
            call MakeSound("war3mapimported\\Hero_Mahoraga_E 1")
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(MahoragaE_ID)), 0)
            set dmg = GetHeroAgi( c , true) * ( MahoragaE_DamageAgiBase + ( MahoragaE_DamageAgiStep * ( GetUnitAbilityLevel( c , MahoragaE_ID) - 1 ) ) )
            set move = 150
            call MouseOn(GetOwningPlayer(c))
            set MouseX[GetPlayerId(GetOwningPlayer(c))] = x
            set MouseY[GetPlayerId(GetOwningPlayer(c))] = y
            set scale = 6
            set scale2 = MahoragaE_Range
            set r5 = 0.3
            set rmax = 1.2
            call SetUnitAnimationByIndex( c , 12)
            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", c, "hand right")
            set e3 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", c, "hand left")
            call VisionTimed(GetOwningPlayer(c), x, y, aoe * 2, 2)
            set e = EffectSpawn("war3mapImported\\wos_[tx] (381).mdl", x1, y1, 1, 1, 0.01, 3)
            call ScaleEffDummy(e, r5, 0.01, scale)
            if MUI_MahoragaE == 0 then
                call TimerStart( t_MahoragaE, 0.03, true, function thistype.Loop_MahoragaE)
            endif
        endmethod

        private static method Loop_MahoragaE2 takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr1 = 0
            local real rr2 = 0
            local real rr3 = 0
            local real rr4 = 0
            local real rr5 = 0
            loop
                exitwhen i > MUI_MahoragaE2
                set this = m_MahoragaE2[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    call DebugUnit2(td)
                    if r == 0.42 then
                        call SetUnitAnimationByIndex(c, 3)
                    endif
                    if r == 0.6 then
                        call SetUnitAnimationByIndex(c, 10)
                    endif
                    if r == 0.93 then
                        call SetUnitAnimationByIndex(c, 7)
                        call SetUnitTimeScale(c, 1.5)
                    endif
                    if r == 0.15 or r == 0.51 or r == 0.69 or r == 1.2 then
                        set x1 = GetUnitX(td)
                        set y1 = GetUnitY(td)
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.95, 2, 255, 255, 255, 255))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_BDEF (124)2.mdx", x1, y1, GetRandomReal(0, 359), 1, 2.5, 125))
                        call EffectSpawn2("war3mapimported\\wos_LD2209 (157).mdx", x1, y1, GetRandomReal(0, 359), 1, 0.8, 0, 1)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_blood impact.mdl", GetUnitX(td), GetUnitY(td), a * bj_RADTODEG, 1, 2.5, 0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_bloodex-special-23.mdl", GetUnitX(td), GetUnitY(td), GetRandomReal(0, 359), 2.5, 2, 80))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_hitheavy.mdl", x1 + 25 * Cos(a), y1 + 25 * Sin(a) , a * bj_RADTODEG, 1, 2.25, 125))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_cf2.mdx", x1 + 125 * Cos(a), y1 + 125 * Sin(a) , a * bj_RADTODEG, 1, 1.05, 15))
                        call DecorRemove(c, x1, y1, aoe, 25)                        
                        if r < 0.7 then
                            if r == 0.69 then
                                call MUE(c, 100, 0.21, a)
                                call MUE(td, 110, 0.21, a)
                            elseif r != 1.08 then
                                call MUE(c, 200, 0.3, a)
                                call MUE(td, 210, 0.3, a)
                            endif
                        endif
                        if r == 1.2 then
                            set r = 999
                            set x1 = GetUnitX(td)
                            set y1 = GetUnitY(td)
                            set aoe = aoe * 2
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_FantasyBattle (1517).mdx", .x1, .y1, GetRandomReal(0, 359), 1.5, 0.85, 3))
                            call EffectSpawn2("war3mapimported\\wos_dls1.mdx", x1, y1, GetRandomReal(0, 359), 1, 1.65, 0, 0.5)
                            set k = 0
                            loop
                                exitwhen k > 3
                                if k < 2 then
                              //  call EffectSpawn2("war3mapimported\\wos_kamni.mdx", x1, y1, GetRandomReal(0, 359), 1.25 - k * 0.1, 0.7 + k * 0.45, 0, 0.35)
                                endif
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_dustgaraa2.mdx", x1, y1, GetRandomReal(0, 359), 1.5 - k * 0.1, 1.9 + k * 0.42, 0))
                                set k = k + 1
                            endloop
                        endif
                        call GroupEnumUnitsInRange( g , x1, y1 , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                call dmgphys(c, u, dmg)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    endif
                else
                    call StopSpellUnit2(c)
                    call StopSpellUnit2(td)
                    call SetUnitTimeScale( c , 1)
                    call DestroyGroup( g )
                    call SetUnitAnimation(c, "stand")
                    set g = null
                    set c = null
                    set td = null
                    set u = null
                    set m_MahoragaE2[i] = m_MahoragaE2[ MUI_MahoragaE2]
                    set MUI_MahoragaE2 = MUI_MahoragaE2 - 1
                    if MUI_MahoragaE2 == -1 then
                        call PauseTimer( t_MahoragaE2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MahoragaE2_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_MahoragaE2 = MUI_MahoragaE2 + 1
            set m_MahoragaE2[ MUI_MahoragaE2] = this
            set c = NewC
            set td = NewTd
            set a = GAngle(c, td)
            set x = GetUnitX(td) - 160 * Cos(a)
            set y = GetUnitY(td) - 160 * Sin(a)
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            set r = 0
            set r2 = 0
            set r6 = 0
            call BlinkEff(c)
            call PosUnit(c, x, y)
            call BlinkEff(c)
            call StartSpellUnit2(c)
            call StartSpellUnit2(td)
            call SetUnitAnimationByIndex(c, 2)
            set g = CreateGroup()
            set u = null
            set check2 = 0
            set aoe = MahoragaE2_DamageAoe
            set dmg = GetHeroAgi( c , true) * MahoragaE2_DamageAgiBase
            set dmg = dmg / 4
            set rmax = 1.5
            call MakeSound("war3mapimported\\Hero_Mahoraga_E2")
            if MUI_MahoragaE2 == 0 then
                call TimerStart( t_MahoragaE2, 0.03, true, function thistype.Loop_MahoragaE2)
            endif
        endmethod

    endstruct

   
    private struct MahoragaSpells_W
        private static timer t_MahoragaW2 = CreateTimer()
        private static integer array m_MahoragaW2
        private static integer MUI_MahoragaW2 = -1
        private static timer t_MahoragaW = CreateTimer()
        private static integer array m_MahoragaW
        private static integer MUI_MahoragaW = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k
        real r4
        real r5
        real r6
        group g
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

        private static method Loop_MahoragaW2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_MahoragaW2
                set this = m_MahoragaW2[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    if check == 0 then
                        call DebugUnit2(c)
                        if r == 0.15 then 
                        call MyFrame(c, BlzGetUnitAbilityCooldownRemaining(c,MahoragaW2_ID), "BTNHero_Mahoraga_W2", false, 3)
                        endif
                        if r == 0.3 then
                        
                            call SetUnitAnimationByIndex( c , 3)
                            call SetUnitTimeScale(c, 0.35)
                            set move = 90
                            call MakeSound("war3mapimported\\Hero_Mahoraga_W2 2")
                        endif
                        if r > 0.45 then
                            if r2 > 0.09 then
                                set r2 = 0
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.25, 55, 255, 255, 255, 100))
                            else
                                set r2 = r2 + 0.03
                            endif
                            if SR2(c, td) > 180 then
                                set a = GAngle(c, td)
                                call MoveUnit(c, move, a)
                            else
                                set r = 0
                                set check = 1
                                set rmax = 1.5
                                set r5 = 1000
                                set r4 = 0
                                set e = AddSpecialEffectTarget("war3mapimported\\wos_Windwalk.mdx", td, "chest")
                                set r6 = r5 / 50
                                set r2 = 0.84
                                call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(MahoragaE_ID)), 0)
                                call SwapAbility(c, r2, MahoragaE3_ID, MahoragaE_ID)
                                call MyFrame(c, r2, "BTNHero_Mahoraga_WE", false, 2)
                                call SetUnitAbilityLevel(c, MahoragaE3_ID, GetUnitAbilityLevel(c, MahoragaE_ID))
                               // call BlzStartUnitAbilityCooldown(c,MahoragaE3_ID,BlzGetUnitAbilityCooldownRemaining(c,MahoragaE_ID))
                                call StopSpellUnit2(c)
                                call StunUnit(c, td, MahoragaW2_Stun)
                                call SaveUnitHandle(hs, GetHandleId(c), StringHash("w target"), td)
                                set x = GetUnitX(td)
                                set y = GetUnitY(td)
                                call SaveInteger(hs, GetHandleId(c), StringHash("height td"), 0)
                                call MakeSound("war3mapimported\\Hero_AlterSaber_E4")
                                call dmgphys(c, td, dmg)
                                call EffectSpawn2("war3mapimported\\wos_LD2209 (157).mdx", x, y, GetRandomReal(0, 359), 1, 1, 0, 1)
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_hitheavy.mdl", x , y , a * bj_RADTODEG, 1, 2.45, 125))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_BDEF (124)2.mdx", x, y, GetRandomReal(0, 359), 1, 2.5, 125))
                                call DestroyEffect(EffectSpawn3("war3mapImported\\wos_acg_bbb.mdl", x, y, a * bj_RADTODEG , 2.75, 1.5, 185, -90))
                                call AddSpecialEffectTarget("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", td, "chest")
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_blood impact.mdl", GetUnitX(td), GetUnitY(td), a * bj_RADTODEG, 1, 3.5, 0))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_hitheavy.mdl", x + 25 * Cos(a), y + 25 * Sin(a) , a * bj_RADTODEG, 1, 3.25, 125))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_cf2.mdx", x + 125 * Cos(a), y + 125 * Sin(a) , a * bj_RADTODEG, 1, 1.95, 15))
                            endif
                        endif
                    elseif check == 1 then
                        if LoadInteger(hs, GetHandleId(c), StringHash("height td")) == 1 then
                            set r = 9999
                        endif
                        call MoveUnit(td, r6, a)
                        set r4 = r4 + r6
                        call SetFly(td, Parabola(850, r5, r4))
                    endif
                else
                    if check == 0 then
                        call StopSpellUnit2(c)
                    else
                        call DestroyEffect(e)
                        if LoadInteger(hs, GetHandleId(c), StringHash("height td")) == 0 then
                            call SetFly(td, 0)
                            call RemoveSavedHandle(hs, GetHandleId(c), StringHash("w target"))
                        endif
                    endif
                    call SaveInteger(hs, GetHandleId(c), StringHash("combo w"), 0)
                    set c = null
                    set e = null
                    set u = null
                    set m_MahoragaW2[i] = m_MahoragaW2[ MUI_MahoragaW2]
                    set MUI_MahoragaW2 = MUI_MahoragaW2 - 1
                    if MUI_MahoragaW2 == -1 then
                        call PauseTimer( t_MahoragaW2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MahoragaW2_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_MahoragaW2 = MUI_MahoragaW2 + 1
            set m_MahoragaW2[ MUI_MahoragaW2] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set r2 = 10
            call StartSpellUnit2(c)
            set check = 0
            set rmax = 2.4
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(MahoragaE_ID)), 1)
            set a = GAngle( c , td ) // Angle Between points
            set dmg = GetHeroAgi( c , true) * MahoragaW2_DamageAgiBase
            call SetUnitAnimationByIndex( c , 4)
            call SetUnitTimeScale(c, 0.5)            
            call SaveInteger(hs, GetHandleId(c), StringHash("combo w"), 1)
            //call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_wfile00009065.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 0.5, 1.1, 1, 255, 255, 255, 255))
            call MakeSound("war3mapimported\\Hero_Mahoraga_W2 1")
            call SetUnitFacing( c , a * bj_RADTODEG)
            if MUI_MahoragaW2 == 0 then
                call TimerStart( t_MahoragaW2, 0.03, true, function thistype.Loop_MahoragaW2)
            endif
        endmethod

        private static method Loop_MahoragaW takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr1 = 0
            local real rr2 = 0
            local real rr3 = 0
            local real rr4 = 0
            local real rr5 = 0
            loop
                exitwhen i > MUI_MahoragaW
                set this = m_MahoragaW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    if r == rmax then
                        set r = 9999
                        set x = GetUnitX(c) + 150 * Cos(a)
                        set y = GetUnitY(c) + 150 * Sin(a)                    
                        call MakeSound("war3mapimported\\Hero_Mahoraga_W 2")
                        call EffectSpawn2("war3mapimported\\wos_dls1.mdx", x, y, GetRandomReal(0, 359), 1, 1.85, 0, 0.5)
                        call EffectSpawn2("war3mapimported\\wos_dls1.mdx", x, y, GetRandomReal(0, 359), 1, 1.125, 0, 0.5)
                        set k = 0
                        loop
                            exitwhen k > 3
                            call EffectSpawn2("war3mapimported\\wos_LD2209 (157).mdx", x, y, GetRandomReal(0, 359), 1 - k * 0.2, 0.8 + k * 0.5, 0, 1.25)
                            set k = k + 1
                        endloop
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_bbb.mdl", x, y, 1 , GetRandomReal(0, 359), 1.45, 155))
                        call DecorRemove(c, x, y, aoe, 50)
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                call dmgphys(c, u, dmg)
                                if GetUnitAbilityLevel(c,MahoragaE2_Buff_ID)>0 then 
                                call MahoragaSpells_E.MahoragaE2_Start(c,u)
                                call UnitRemoveAbility(c,MahoragaE2_Buff_ID)
                                endif
                                call SlowUnit(c, u, MahoragaW_Slow, MahoragaW_SlowDuration)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    endif
                else
                    call StopSpellUnit2(c)
                    call SetUnitTimeScale( c , 1)
                    call DestroyEffect(e)
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set e = null
                    set u = null
                    set m_MahoragaW[i] = m_MahoragaW[ MUI_MahoragaW]
                    set MUI_MahoragaW = MUI_MahoragaW - 1
                    if MUI_MahoragaW == -1 then
                        call PauseTimer( t_MahoragaW)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MahoragaW_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_MahoragaW = MUI_MahoragaW + 1
            set m_MahoragaW[ MUI_MahoragaW] = this
            set c = NewC
            set a = GetUnitFacing(c) * bj_DEGTORAD
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            set r = 0
            set r2 = 0
            set r6 = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set check2 = 0
            set aoe = MahoragaW_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( MahoragaW_DamageAgiBase + ( MahoragaW_DamageAgiStep * ( GetUnitAbilityLevel( c , MahoragaW_ID) - 1 ) ) )
            set dmg = dmg + MahoragaW_Damage2StaticBase + ( MahoragaW_Damage2StaticStep * ( GetUnitAbilityLevel( c , MahoragaW_ID) - 1 ) )
            set rmax = 0.6
            call SetUnitAnimationByIndex(c, 7)
            call SetUnitTimeScale(c, 1.)
            call MakeSound("war3mapimported\\Hero_Mahoraga_W")
            if MUI_MahoragaW == 0 then
                call TimerStart( t_MahoragaW, 0.03, true, function thistype.Loop_MahoragaW)
            endif
        endmethod

    endstruct

   private struct MahoragaSpells_T
        private static timer t_MahoragaT = CreateTimer()
        private static integer array m_MahoragaT
        private static integer MUI_MahoragaT = -1
        unit c
        unit td
        real x
        real y
        integer k
        real r5
        real dmg
        integer check
        integer check2
        real move
        real r
        effect e
        effect e2
        effect e3
        real a
        real rmax

        private static method Loop_MahoragaT takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_MahoragaT
                set this = m_MahoragaT[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    set a = GAngle(c, td)
                    if r == 0.3 then
                        set r5 = 0
                    endif
                    if r > 0.45 then
                        if SR2(c, td) > 110 then
                            call MoveUnit(c, move, a)
                        else
                            call MakeSound("war3mapimported\\Hero_Mahoraga_T2 2")
                            call MakeSound("war3mapimported\\Hero_Mahoraga_T2 3")
                            set check = 1
                            set r = 9999
                        endif
                    endif
                else
                    call StopSpellUnit2(c)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    if check == 1 then
                        call MUE(c, 350, 0.15, a)
                        call dmgphys(c, td, dmg)
                        call DecorRemove(c, GetUnitX(td), GetUnitY(td), 300, 100)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-WWSFX-1.mdl", x, y, a * bj_RADTODEG, 0.5, 10, 155))
                        call DestroyEffect( EffectSpawn("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", x, y, a * bj_RADTODEG, 0.2, 4, 145))
                        call DestroyEffect( EffectSpawn("war3mapimported\\wos_bloodex-special-23.mdx", x, y, a * bj_RADTODEG, 1, 3, 145))
                        call DestroyEffect(EffectSpawn3("war3mapimported\\wos_Satsu-RSFX-4.mdl", x - 350 * Cos(a), y - 350 * Sin(a), a * bj_RADTODEG + 180, 0.5, 2.1, 65, -90))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_AZ_TS_TZRed.mdl", x, y, a * bj_RADTODEG + 90, 1.5, 2.5, 1))
                    endif
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call DestroyEffect(e3)
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set td = null
                    set m_MahoragaT[i] = m_MahoragaT[MUI_MahoragaT]
                    set MUI_MahoragaT = MUI_MahoragaT - 1
                    if MUI_MahoragaT == -1 then
                        call PauseTimer( t_MahoragaT )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MahoragaT_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_MahoragaT = MUI_MahoragaT + 1
            set m_MahoragaT[MUI_MahoragaT] = this
            set c = NewC
            set td = NewTd
            set dmg = GetHeroAgi( c , true) * MahoragaG_DamageAgiBase
            set r = 0
            set check2 = 0
            set check = 0
            set rmax = 2
            set move = 90
            call StartSpellUnit2(c)
            call SetUnitAnimationByIndex(c, 8)
            call SetUnitTimeScale(c, 1.3)
            set a = GAngle(c, td)
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            set k = GetRandomInt(1, 2)
            set e = AddSpecialEffectTarget("Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl", c, "hand right")
            set e2 = AddSpecialEffectTarget("Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl", c, "hand left")
            set e3 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", c, "weapon")
            call MakeSound("war3mapimported\\Hero_Mahoraga_T2 1")
            if MUI_MahoragaT == 0 then
                call TimerStart( t_MahoragaT, 0.03, true, function thistype.Loop_MahoragaT )
            endif
        endmethod

    endstruct

    private struct MahoragaSpells_F
        private static timer t_MahoragaF = CreateTimer()
        private static integer array m_MahoragaF
        private static integer MUI_MahoragaF = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        integer k2
        real r3
        real r4
        real r5
        real r6
        real r7
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
        effect e5
        effect e6
        real a
        real rmax

        private static method Loop_MahoragaF takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_MahoragaF
                set this = m_MahoragaF[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit(c)
                    if r7 > 0.03 and r > 0 and check == 0 then
                        set r7 = 0
                        set r5 = GetRandomReal(2, 3.5)
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_dustwave222.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1.1, r5 , 10, 255, 255, 255, 55))
                    else
                        set r7 = r7 + 0.03
                    endif
                    if check == 0 then
                        if r == 0.03 then
                            set e = EffectSpawnColor("war3mapimported\\wos_az_bujingdule03512.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 0.01, 1, 255, 255, 255, 125)
                            call ScaleEffDummy(e, 0.3, 0.01, 1.8)
                        endif
                        if r == 0.3 then
                            call ScaleEffDummy(e, 0.3, 1.8, 0.3)
                        endif
                    endif
                    if check == 0 then
                        if r >= 0.51 then
                            set check = 1
                            set k2 = 0
                            set move = 200
                            set r5 = 0
                            call DestroyEffect(e)
                            call MakeSound("war3mapimported\\Hero_BazzB_T2")
                            set e2 = EffectSpawnColor3("war3mapImported\\wos_BY_Wood_Eff_Wid_XuanFeng.mdl", GetUnitX(c) - 280 * Cos(a), GetUnitY(c) - 280 * Sin(a), a * bj_RADTODEG - 180, 1, 20, 235, -90, 255, 255, 255, 255)
                            set e5 = EffectSpawnColor3("war3mapImported\\wos_BY_Wood_Eff_Wid_XuanFeng.mdl", GetUnitX(c) + 260 * Cos(a), GetUnitY(c) + 260 * Sin(a), a * bj_RADTODEG - 180, 1, 20, 235, -90, 255, 255, 255, 255)
                            set rmax = 0.6
                            call DestroyEffect(e6)
                            set r = 0
                            set x1 = GetUnitX(c) + 150 * Cos(a)
                            set y1 = GetUnitY(c) + 150 * Sin(a)
                        endif
                    elseif check == 1 then
                        set k = 0
                        if r4 > 0.24 then
                            set r4 = 0
                            set x1 = GetUnitX(c) + 150 * Cos(a)
                            set y1 = GetUnitY(c) + 150 * Sin(a)
                        else
                            set r4 = r4 + 0.03
                        endif
                        set r5 = r5 + move
                        set x1 = x1 + move * Cos(a)
                        set y1 = y1 + move * Sin(a)
                        if r6 >= 0.0 then
                            set r6 = 0
                            call DecorRemove(c, x1, y1, aoe, 100)
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , x1 - 100 * Cos(a), y1 - 100 * Sin(a) , aoe , Condition(function NoDecor_Filter))
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup( u , g2 ) == false then
                                    call dmgphys(c, u, dmg)
                                    call MUE(u, MahoragaF_PushRange, MahoragaF_PushDuration, a)
                                    call GroupAddUnit( g2 , u )
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        else
                            set r6 = r6 + 0.03
                        endif
                        if r2 >= 0.0 then
                            set r2 = 0
                            set r3 = GetRandomReal(1.55, 2.75)
                            set r7 = GetRandomReal(1., 2.1)
                            call MyRemoveEff(EffectSpawnColor3("war3mapimported\\wos_az_bujingdule03512.mdl", .x1 + 125 * Cos(a), .y1 + 125 * Sin(a), a * bj_RADTODEG, r3, r7, 125, -90, 255, 255, 255, 75), 0.45)
                            set r7 = r * 2. + GetRandomReal(0.5, 1.65)
                            set r3 = GetRandomReal(1.75, 2.75)
                            call DestroyEffect(EffectSpawn3("war3mapimported\\wos_white-qiquan-new.mdx", x1 + 125 * Cos(a), y1 + 125 * Sin(a), a * bj_RADTODEG, r3, r7, 100, -90))
                            call VisionTimed(GetOwningPlayer(c), x1, y1, 1200, 1)
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    call StopSpellUnit(c)
                    call SetUnitTimeScale( c , 1)
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call DestroyEffect(e5)
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set e = null
                    set e2 = null
                    set e5 = null
                    call DestroyGroup( g2 )
                    set g2 = null
                    set u = null
                    set m_MahoragaF[i] = m_MahoragaF[ MUI_MahoragaF]
                    set MUI_MahoragaF = MUI_MahoragaF - 1
                    if MUI_MahoragaF == -1 then
                        call PauseTimer( t_MahoragaF)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MahoragaF_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_MahoragaF = MUI_MahoragaF + 1
            set m_MahoragaF[ MUI_MahoragaF] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set r3 = 0
            set r4 = 0
            set r5 = 0
            set r6 = 0
            set r7 = 0
            call StartSpellUnit(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set check = 0
           // call DestroyEffect(EffectSpawn("war3mapimported\\wos_HakkeStart.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 0.3, 1.45, 7))
            set aoe = MahoragaF_DamageAoe
            set dmg = GetHeroAgi( c , true) * MahoragaF_DamageAgiBase
            set rmax = 3
            call SetUnitAnimationByIndex(c, 3)
            call SetUnitTimeScale(c, 0.5)
            call MakeSound("war3mapimported\\Hero_Mahoraga_F")
            if MUI_MahoragaF == 0 then
                call TimerStart( t_MahoragaF, 0.03, true, function thistype.Loop_MahoragaF)
            endif
        endmethod

    endstruct

    private struct MahoragaSpells_G
        private static timer t_MahoragaG = CreateTimer()
        private static integer array m_MahoragaG
        private static integer MUI_MahoragaG = -1
        unit c
        unit d
        real x
        real y
        real r2
        integer k
        integer k2
        real r3
        group g
        unit u
        integer check
        real aoe
        real r

        private static method Loop_MahoragaG takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_MahoragaG
                set this = m_MahoragaG[i]
                if true then
                    if GetHeroLevel(c) >= 25 then
                        if CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) or IsUnitType(c, UNIT_TYPE_DEAD) then
                            if d != null then
                                    call SaveInteger(hs,GetHandleId(c),StringHash("stack 5"),0)
                                call RemoveUnit(d)
                                call SetPlayerAbilityAvailable(GetOwningPlayer(c), MahoragaW_ID, true)
                                call SetPlayerAbilityAvailable(GetOwningPlayer(c), MahoragaW2_ID, false)
                                set d = null
                            endif
                        else
                            set k = 0
                            set x = GetUnitX(c)
                            set y = GetUnitY(c)
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and (GetUnitAbilityLevel(u, MahoragaT_Abi_ID3) > 0 or GetUnitAbilityLevel(u, MahoragaT_Abi_ID4) > 0 or GetUnitAbilityLevel(u, MahoragaT_Abi_ID5) > 0 or GetUnitAbilityLevel(u, MahoragaT_Abi_ID6) > 0 or GetUnitAbilityLevel(u, MahoragaT_Abi_ID7) > 0 or GetUnitAbilityLevel(u, MahoragaT_Abi_ID8) > 0) then
                                    set k = 1
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                            if BlzGetUnitAbilityCooldownRemaining(c,MahoragaW2_ID) != 0 or d == null then
                                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), MahoragaW_ID, true)
                                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), MahoragaW2_ID, false)
                                    else
                                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), MahoragaW_ID, false)
                                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), MahoragaW2_ID, true)
                            endif
                            if k == 1 then
                                if d == null  then
                                    call UnitAddAbility(c, MahoragaW2_ID)
                                    call SaveInteger(hs,GetHandleId(c),StringHash("stack 5"),1)
                                    set d = CreateUnit(GetOwningPlayer(c), MahoragaT_Unit_ID, GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster), 1)
                                endif
                            else
                                if d != null  then
                                    call SaveInteger(hs,GetHandleId(c),StringHash("stack 5"),0)
                                    call RemoveUnit(d)
                                    set d = null
                                endif
                            endif
                        endif
                    endif
                else                    
                    set c = null
                    set g = null
                    set u = null
                    set m_MahoragaG[i] = m_MahoragaG[ MUI_MahoragaG]
                    set MUI_MahoragaG = MUI_MahoragaG - 1
                    if MUI_MahoragaG == -1 then
                        call PauseTimer( t_MahoragaG)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MahoragaG_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_MahoragaG = MUI_MahoragaG + 1
            set m_MahoragaG[ MUI_MahoragaG] = this
            set c = NewC
            set check = 1
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set r2 = 0
            set r3 = 0
            set g = CreateGroup()
            set aoe = MahoragaT_CondAoeFind
            set r = 0
            if MUI_MahoragaG == 0 then
                call TimerStart( t_MahoragaG, 0.1, true, function thistype.Loop_MahoragaG)
            endif
        endmethod

    endstruct

    //----------------------------Mahoraga-----------------------------------------------
     /* Animations index:
    0 - stand
    1 - walk normal
    2 - hit forward
    3 - knife slice forward
    4 - F??
    6 - walk fast
    7 - W
    8 - t2 start
    9 - stand ready ( t2 stand)
    10 - slice in front with knife
    11 - turn around with slice
    12 - E
    13 - E3
    14 - q2
     */ 
     function  BuffMahoragaWheel takes unit c, unit u, integer level returns nothing
            local integer i = GetPlayerId(GetOwningPlayer(c))
            if mahodummy1[i] == null or GetWidgetLife(mahodummy1[i]) < 1 then
                set mahodummy1[i] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'h0C9', GetRectCenterX( gg_rct_Caster ), GetRectCenterY( gg_rct_Caster ), 0 )
                call UnitAddAbility(mahodummy1[i], 'A0D1')
            endif
            if level > 0 then
                if GetUnitAbilityLevel(mahodummy1[i], 'A0D1') == 0 then
                    call UnitAddAbility(mahodummy1[i], 'A0D1')
                endif
                call SetUnitAbilityLevel(mahodummy1[i], 'A0D1', level)
                call SetUnitFacing(mahodummy1[i], GAngle(mahodummy1[i], u) * bj_RADTODEG)
                call IssueTargetOrder(mahodummy1[i], "curse", u)
            endif
        endfunction
    function MahoragaQ_Start takes unit c, unit td returns nothing
        call MahoragaSpells_Q.MahoragaQ_Start( c, td )
    endfunction
    function MahoragaQ2_Start takes unit c returns nothing
        call MahoragaSpells_Q.MahoragaQ2_Start( c )
    endfunction
    function MahoragaW_Start takes unit c returns nothing
        call MahoragaSpells_W.MahoragaW_Start( c )
    endfunction
    function MahoragaW2_Start takes unit c, unit td returns nothing
        call MahoragaSpells_W.MahoragaW2_Start( c, td )
    endfunction
    function MahoragaE_Start takes unit c, real x, real y returns nothing
        call MahoragaSpells_E.MahoragaE_Start( c, x, y )
    endfunction
    function MahoragaE2_Start takes unit c returns nothing
        call BuffUnit1(c, c, 12)
    endfunction
    function MahoragaE2Act_Start takes unit c, unit td returns nothing
        call UnitRemoveAbility(c, MahoragaE2_Buff_ID)
        call MahoragaSpells_E.MahoragaE2_Start( c, td )
    endfunction
    function MahoragaE3_Start takes unit c returns nothing
        call MahoragaSpells_E.MahoragaE3_Start( c )
    endfunction
    function MahoragaR_Start takes unit c returns nothing
        local real hp = GetHeroAgi(c, true) * (MahoragaR_HealAgiBase + (MahoragaR_HealAgiStep * (GetUnitAbilityLevel(c, MahoragaR_ID) - 1)))
       //if LoadInteger(hs,GetHandleId(c),StringHash("stack 5")) == 1 then
       // set hp = hp * (1+(MahoragaR_HealBonusT/100))
        //endif
        if GetHeroLevel(c)>= 35 then 
        call SaveInteger(hs,GetHandleId(c),StringHash("debuff immune"),1)
        call MyFlush(GetHandleId(c),StringHash("debuff immune"),0,MahoragaR_Duration)
        call DebuffClear(c)
        endif 
        call HPS(c, c, hp, MahoragaR_Duration)
        call MyRemoveEff(AddSpecialEffectTarget("war3mapimported\\wos_a(rainbow)2.mdx", c, "chest"), MahoragaR_Duration)
        call MakeSound("war3mapimported\\Hero_Mahoraga_R")
        call MakeSound("war3mapimported\\Hero_Mahoraga_R2")
      //  call MahoragaSpells.MahoragaR_Start( c )
    endfunction
    function MahoragaTInfo_Start takes unit c, boolean b returns nothing
        local real r8 = 0
        local integer k2 = GetPlayerId(GetOwningPlayer(c))
        local real tmp_y = 0
        local integer k = 0
        local real x = GetUnitX(c)
        local real y = GetUnitY(c)
        local integer k3 = MahoragaT_DamageToReduceCD
        if b == true then
        call MahoragaSpells_G.MahoragaG_Start( c )
            /*if frameMahoraga_pas1[k2] == null then
                set frameMahoraga_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                call BlzFrameSetAbsPoint(frameMahoraga_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18 + tmp_y)
                call BlzFrameSetSize(frameMahoraga_pas1[k2], 0.135, 0.035)
                call BlzFrameSetTexture(frameMahoraga_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                call BlzFrameSetVisible(frameMahoraga_pas1[k2], false)
                if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frameMahoraga_pas1[k2], true)
                endif
                set frameMahoraga_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frameMahoraga_pas1[k2], 0, 0)
                call BlzFrameSetAbsPoint(frameMahoraga_pas2[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
                call BlzFrameSetSize(frameMahoraga_pas2[k2], 0.1, 0.019)
                set frameMahoraga_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frameMahoraga_pas1[k2], "", 0)
                call BlzFrameSetSize(frameMahoraga_pas3[k2], 0.1, 0.035)
                call BlzFrameSetScale(frameMahoraga_pas3[k2], 0.5)
                call BlzFrameSetModel(frameMahoraga_pas3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                call BlzFrameSetAbsPoint(frameMahoraga_pas3[k2], FRAMEPOINT_CENTER, 0.05, 0.175 + tmp_y)
                call BlzFrameSetMinMaxValue(frameMahoraga_pas3[k2], 0, I2R(k3 + 1))
                call BlzFrameSetValue(frameMahoraga_pas3[k2], 0)
                set frameMahoraga_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frameMahoraga_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frameMahoraga_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18 + tmp_y)
                call BlzFrameSetSize(frameMahoraga_pas4[k2], 0.03, 0.03)
                call BlzFrameSetTexture(frameMahoraga_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Mahoraga_T", 0, false)
                set frameMahoraga_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frameMahoraga_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frameMahoraga_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
                call BlzFrameSetText(frameMahoraga_pas5[k2], "|c00FFFF00" + "Adoptation speed:|r")
                call BlzFrameSetScale(frameMahoraga_pas5[k2], 0.9)
                set frameMahoraga_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frameMahoraga_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frameMahoraga_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17 + tmp_y)
                call BlzFrameSetText(frameMahoraga_pas6[k2], "|c00FFFF00" + "0/" + I2S(k3) + "|r")
                call BlzFrameSetScale(frameMahoraga_pas6[k2], 0.9)
                
            else
                if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frameMahoraga_pas1[k2], true)
                endif
                call BlzFrameSetText(frameMahoraga_pas6[k2], "|c00FFFF00" + "0/" + I2S(k3) + "|r")
                call BlzFrameSetMinMaxValue(frameMahoraga_pas3[k2], 0, I2R(k3 + 1))
                call BlzFrameSetValue(frameMahoraga_pas3[k2], 0)
                set k = LoadInteger(hs, GetHandleId(Hero[k]), StringHash("t dmg"))
                if k > k3 then
                    set k = k3
                endif
                call BlzFrameSetText(frameMahoraga_pas6[k2], "|c00FFFF00" + I2S(k) + "/" + I2S(k3) + "|r")
                call BlzFrameSetValue(frameMahoraga_pas3[k2], I2R(k))
            endif*/
        else
         //   if GetLocalPlayer() == GetOwningPlayer(c) then
             //   call BlzFrameSetVisible(frameMahoraga_pas1[k2], false)
          //  endif
        endif
    endfunction
    function MahoragaT_Start takes unit c, unit td, real dmg returns nothing
    local integer k = 0
    local integer k2 = GetPlayerId(GetOwningPlayer(c))
    local integer k3 = MahoragaT_DamageToReduceCD
    local integer k4 = 0
    local real cd 

    // РЎСѓРјРјРёСЂСѓРµРј РЅР°РєРѕРїР»РµРЅРЅС‹Р№ + РЅРѕРІС‹Р№ СѓСЂРѕРЅ
    set k = LoadInteger(hs, GetHandleId(td), StringHash("maha t dmg")) + R2I(dmg)
    if k>= MahoragaT_DamageToReduceCD then 
        loop
            exitwhen k < k3 or k4 >= 8
            set k = k - k3
            set k4 = k4 + 1
        endloop
      //  call BlzStartUnitAbilityCooldown(c, FakeAbi_ID, cd)
   endif
   
    // Р–С‘СЃС‚РєРѕРµ РѕРіСЂР°РЅРёС‡РµРЅРёРµ: РѕСЃС‚Р°С‚РѕРє РЅРёРєРѕРіРґР° РЅРµ РґРѕР»Р¶РµРЅ Р±С‹С‚СЊ >= k3
    if k >= k3 then
        set k = k3 - 1
    endif
    if k < 0 then
        set k = 0
    endif
    call SaveInteger(hs, GetHandleId(td), StringHash("maha t dmg"), k)
    if k4>0 then
    set k4 = k4 - 1
    if GetUnitAbilityLevel(td, MahoragaT_Abi_ID8) == 1 then
            set k = 8
        elseif GetUnitAbilityLevel(td, MahoragaT_Abi_ID7) == 1 then
            set k = 8
            call UnitRemoveAbility(td, MahoragaT_Abi_ID7)
        elseif GetUnitAbilityLevel(td, MahoragaT_Abi_ID6) == 1 then
            set k = 7
            call UnitRemoveAbility(td, MahoragaT_Abi_ID6)
        elseif GetUnitAbilityLevel(td, MahoragaT_Abi_ID5) == 1 then
            set k = 6
            call UnitRemoveAbility(td, MahoragaT_Abi_ID5)
        elseif GetUnitAbilityLevel(td, MahoragaT_Abi_ID4) == 1 then
            set k = 5
            call UnitRemoveAbility(td, MahoragaT_Abi_ID4)
        elseif GetUnitAbilityLevel(td, MahoragaT_Abi_ID3) == 1 then
            set k = 4
            call UnitRemoveAbility(td, MahoragaT_Abi_ID3)
        elseif GetUnitAbilityLevel(td, MahoragaT_Abi_ID2) == 1 then
            set k = 3
            call UnitRemoveAbility(td, MahoragaT_Abi_ID2)
        elseif GetUnitAbilityLevel(td, MahoragaT_Abi_ID1) == 1 then
            set k = 2
            call UnitRemoveAbility(td, MahoragaT_Abi_ID1)
        else
            set k = 1
        endif
        set k = k + k4
        call BuffMahoragaWheel(c, td, k)
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_mahoragawheel.mdl", c, "overhead"))
    endif 
    // UI вЂ” k РіР°СЂР°РЅС‚РёСЂРѕРІР°РЅРЅРѕ РІ РґРёР°РїР°Р·РѕРЅРµ [0, k3-1]
    call BlzFrameSetText(frameMahoraga_pas6[k2], "|c00FFFF00" + I2S(k) + "/" + I2S(k3) + "|r")
    call BlzFrameSetValue(frameMahoraga_pas3[k2], I2R(k))

    // --- Р›РѕРіРёРєР° РЅР°Р»РѕР¶РµРЅРёСЏ РїСЂРѕРєР»СЏС‚РёСЏ ---
    set k = 0
    // ... РѕСЃС‚Р°Р»СЊРЅРѕР№ РєРѕРґ Р±РµР· РёР·РјРµРЅРµРЅРёР№
    if dmg >= MahoragaT_DamageTreshold and IntegerCd(td,"t cd",4) then
        if IntegerCd(c,"cd sound",10) then 
            call MakeSound("war3mapimported\\Hero_Mahoraga_T")
        endif
       // if  GetUnitAbilityLevel(c, FakeAbi_ID) == 0 then 
       // call FakeCD_Start(c, MahoragaT_ID, MahoragaT_CD , 0, 0)
       // endif
        if GetUnitAbilityLevel(td, MahoragaT_Abi_ID8) == 1 then
            set k = 8
        elseif GetUnitAbilityLevel(td, MahoragaT_Abi_ID7) == 1 then
            set k = 8
            call UnitRemoveAbility(td, MahoragaT_Abi_ID7)
        elseif GetUnitAbilityLevel(td, MahoragaT_Abi_ID6) == 1 then
            set k = 7
            call UnitRemoveAbility(td, MahoragaT_Abi_ID6)
        elseif GetUnitAbilityLevel(td, MahoragaT_Abi_ID5) == 1 then
            set k = 6
            call UnitRemoveAbility(td, MahoragaT_Abi_ID5)
        elseif GetUnitAbilityLevel(td, MahoragaT_Abi_ID4) == 1 then
            set k = 5
            call UnitRemoveAbility(td, MahoragaT_Abi_ID4)
        elseif GetUnitAbilityLevel(td, MahoragaT_Abi_ID3) == 1 then
            set k = 4
            call UnitRemoveAbility(td, MahoragaT_Abi_ID3)
        elseif GetUnitAbilityLevel(td, MahoragaT_Abi_ID2) == 1 then
            set k = 3
            call UnitRemoveAbility(td, MahoragaT_Abi_ID2)
        elseif GetUnitAbilityLevel(td, MahoragaT_Abi_ID1) == 1 then
            set k = 2
            call UnitRemoveAbility(td, MahoragaT_Abi_ID1)
        else
            set k = 1
        endif
        call BuffMahoragaWheel(c, td, k)
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_mahoragawheel.mdl", c, "overhead"))
    endif    
endfunction
    function MahoragaG_Start takes unit c, unit td returns nothing
        call MahoragaSpells_T.MahoragaT_Start( c, td)
    endfunction
    function MahoragaF_Start takes unit c, real x, real y returns nothing
        call MahoragaSpells_F.MahoragaF_Start( c, x, y)
    endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
