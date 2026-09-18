library KiritoSpells uses GearSystems
    globals
    integer Kirito_ID = 'H023'
//---------------Q ability-----------------------------------------------------
        integer KiritoQ_ID = 'A0D3'
        real KiritoQ_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real KiritoQ_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real KiritoQ_Damage2StaticBase = 175 // base static damage for 1 level
        real KiritoQ_Damage2StaticStep = 0 // additional static damage for each next level
        real KiritoQ_DamageAoe = 300
        real KiritoQ_RangeBase = 1200
        real KiritoQ_RangeStep = 80
        real KiritoQ_StunDuration = 1 // in seconds
//---------------W ability-----------------------------------------------------
        integer KiritoW_ID = 'A0D4'
        real KiritoW_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real KiritoW_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real KiritoW_Damage2StaticBase = 150 // base static damage for 1 level
        real KiritoW_Damage2StaticStep = 0 // additional static damage for each next level
        real KiritoW_DamageAoe = 600
        integer KiritoW_Slow = 40 // in % 60 = 60%
        integer KiritoW_SlowDuration = 2 // in seconds
        real KiritoRW_AdditionalAoe = 200 // add to default aoe damage
        real KiritoRW_AdditionalDamageAgi = 1 // add to default damage
//---------------E ability-----------------------------------------------------
        integer KiritoE_ID = 'A0D5'
        integer KiritoE2_ID = 'A0E2'
        real KiritoE_DamageAgiBase = 2 // base number x Agi damage for 1 level
        real KiritoE_DamageAgiStep = 0.5 // additional number x Agi damage for each next level
        
        real KiritoE_DamageAgiBase2 = 1 // base number x Agi damage for 1 level
        real KiritoE_DamageAgiStep2 = 0.5 // additional number x Agi damage for each next level
        real KiritoE_Damage2StaticBase = 0 // base static damage for 1 level
        real KiritoE_Damage2StaticStep = 0 // additional static damage for each next level
        real KiritoE_DamageAoe = 330
        real KiritoE_CloneMoveRangeBase = 1300
        real KiritoE_AoeClickAroundClone = 250
        real KiritoE_CloneMoveRangeStep = 120
        real KiritoE_MaxMoveRange = 3000
        real KiritoE_CloneMoveDuration = 0.3 // how much clone would run from kirito position , duration must be divisible by 0.03 seconds
        integer KiritoE_DummyId = 'h024'
        integer KiritoE_DummyId2 = 'h025'
        real KiritoE_PickCloneAoe = 450 // in which aoe around dummy rmb would activate tp
        real KiritoE_Duration = 5 // in seconds , how long clone would live 10 = 10 sec
//---------------R ability-----------------------------------------------------
        integer KiritoR_ID = 'A0D6'
        integer KiritoR2_ID = 'A0D7'
        real KiritoR_DamageAgiBase = 1.2 // base number x Agi damage for each strike
        real KiritoR_DamageAgiStep = 0.4 // additional number x Agi damage for each next level each strike
        real KiritoR_Damage2AgiBase = 3 // base number x Agi damage for each strike
        real KiritoR_Damage2AgiStep = 0.3 // additional number x Agi damage for each next level each strike
        real KiritoR_DamageDealtBonusFinal = 0 // additional amout of damage that trigger final strike in %, example kirito attack enemy cause 500 dmg, with 70% it additionaly deal 375 damage for final strike
        real KiritoR_StunDuration = 0.1 // from 0.1 to 3 sec
        real KiritoR_DurationBase = 10 // in seconds
        real KiritoR_DurationStep = 2 // in seconds
        real KiritoR_DamageAoe = 500// aoe where deal damage and stun at the end
        integer KiritoR_AS = 'A0DC'
//---------------T ability-----------------------------------------------------
        integer KiritoT_ID = 'A0D8'
        integer KiritoT2_ID = 'A0D9'
        real KiritoT_DamageAgiBase = 10 // base number x Agi damage
        real KiritoT2_DamageAgiBase = 4 // base number x Agi damage
        real KiritoT2_Stun = 1 // base number x Agi damage
        real KiritoT_DamageAoe = 500
        real KiritoT_BlockHpRegenTime = 10.00 // in seconds
        real KiritoT_BlockHpRegenAmount = 75.00 // in %, block 65% of regen, not lower than 0 and not more than 100, 100 = no regen
//---------------G ability-----------------------------------------------------
        integer KiritoG_ID = 'A0DB'
        integer KiritoG2_ID = 'A0E3'
        real KiritoG_Heal = 1 // x agi
        real KiritoG_Time = 5.00 // every 5 sec heal
//---------------F ability-----------------------------------------------------
        integer KiritoF_ID = 'A0DA'
//--------------------------------------Kirito--------------------------------------------------------------
    endglobals
    private struct KiritoSpells_Q
        private static timer t_KiritoQ = CreateTimer()
        private static integer array m_KiritoQ
        private static integer MUI_KiritoQ = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k2
        real r3
        real r4
        real r5
        real r6
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

        private static method Loop_KiritoQ takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_KiritoQ
                set this = m_KiritoQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit2(c)                    
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    if r == 0.18 then
                        call SetUnitAnimation( c , "spell two")
                    endif
                    if r == 0.27 then
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_DanGe_Wid_ChongFengQiLiu.mdl", x + 300 * Cos(a), y + 300 * Sin(a), a * bj_RADTODEG, 1.2, 1.95, 0, 255, 255, 255, 125))
                    endif
                    if r == 0.45 then
                        set e = EffectSpawn("war3mapImported\\wos_BDEF (55).mdl", GetUnitX(c) + 35 * Cos(a), GetUnitY(c) + 35 * Sin(a), a * bj_RADTODEG + 90, 0.66, 1.5, 50)
                        call DestroyEffect(e)
                        call BlzSetSpecialEffectAlpha(e, 0)
                        call ColorEffDummy4(e, 0, 255, 255, 255, 0.25)
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_DanGe_Dus_Kuosan_1_2_1.mdl", x, y, a * bj_RADTODEG, 1.25, 1.55, 0, 255, 255, 255, 125))
                    endif
                    if r >= 0.45 then
                        call MoveUnit(c, move, a)
                        call BlzSetSpecialEffectPosition(e,GetUnitX(c) + 35 * Cos(a), GetUnitY(c) + 35 * Sin(a),50)
                        call BlzSetUnitFacingEx(c,a*bj_RADTODEG)
                        set r4 = r4 + move
                        if r4 >= r6 then 
                        set r = 9999
                        endif
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                set k2 = k2 + 1
                                if k2 == 1 then
                                    call MakeSound("war3mapImported\\Hero_Kirito_Q2")
                                endif
                                if IsUnitInGroup(u, g2) == false then
                                    call dmgphys(c, u, dmg)
                                    call GroupAddUnit(g2, u)
                                    call StunUnit(c, u, KiritoQ_StunDuration)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_ZK_BMSword-qi explosion_Lan.mdl", u, "chest"))
                                endif
                                if check2 == 1 then 
                                call MoveUnit(u, move, a)
                                else
                                if td == null then 
                                set td = u
                                endif
                                call PosUnit(td,GetUnitX(c)+175*Cos(a),GetUnitY(c)+175*Sin(a))
                                endif
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        if r2 > 0.0 then
                            set r2 = 0
                            set x = x + 150 * Cos(a)
                            set y = y + 150 * Sin(a)
                            set r5 = GetRandomReal(0.4, 1)
                            call DecorRemove(c,x,y,aoe,25)
                            call ColorEffDummy3(EffectSpawn3("war3mapimported\\wos_xxxxuanfeng2.mdl", x, y, a * bj_RADTODEG, r5, GetRandomReal(0.75, 1.35), 100, -90), 0, 255, 255, 255, 0.3)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_blue-texiao-buff2.mdl", x, y, GetRandomReal(0, 359), 1.95, 5.25, 0))
                        else
                            set r2 = r2 + 0.03
                        endif
                        if r3 > 0.03 then
                            set r3 = 0
                            set x = x + 150 * Cos(a)
                            set y = y + 150 * Sin(a)
                            set r5 = GetRandomReal(0.4, 1)
                            if GetUnitAbilityLevel(c, KiritoR_AS) > 0 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.5, 2.5, 3))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x, y, a * bj_RADTODEG, 0.5, 2.5, 50))
                            endif
                        else
                            set r3 = r3 + 0.03
                        endif
                    endif
                else
                    call StopSpellUnit2(c)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set e = null
                    set g = null
                    set td = null
                    set g2 = null
                    set c = null
                    set e = null
                    set m_KiritoQ[i] = m_KiritoQ[ MUI_KiritoQ]
                    set MUI_KiritoQ = MUI_KiritoQ - 1
                    if MUI_KiritoQ == -1 then
                        call PauseTimer( t_KiritoQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method KiritoQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_KiritoQ = MUI_KiritoQ + 1
            set m_KiritoQ[ MUI_KiritoQ] = this
            set c = NewC
            set r = 0
            set td = null
            set x = NewX
            set y = NewY
            set check = 0
            set k2 = 0
            set r2 = 10
            set r3 = 10
            set r4 = 0
            set r6 = KiritoQ_RangeBase + ( KiritoQ_RangeStep * ( GetUnitAbilityLevel( c , KiritoQ_ID) - 1 ) ) 
            set g = CreateGroup()
            set g2 = CreateGroup()
            call StartSpellUnit2(c)
            set aoe = KiritoQ_DamageAoe
            set a = GAngle2( c , x, y ) // Angle Between points
            call MakeSound("war3mapImported\\Hero_Kirito_Q")
            set dmg = GetHeroAgi( c , true) * ( KiritoQ_DamageAgiBase + ( KiritoQ_DamageAgiStep * ( GetUnitAbilityLevel( c , KiritoQ_ID) - 1 ) ) )
            set dmg = dmg+ KiritoQ_Damage2StaticBase + (KiritoQ_Damage2StaticStep * (GetUnitAbilityLevel(c, KiritoQ_ID) - 1))
            set rmax = 2
            set check2 = 0
            if GetUnitAbilityLevel(c,KiritoR_AS)== 0 then 
            set check2 = 0
            else
            set check2 = 1
            endif
            set move = 120
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SetUnitAnimation( c , "spell one")
            call SetUnitTimeScale( c , 0.6)
            call VisionTimed(GetOwningPlayer(c), x, y, 750, 6)
            if MUI_KiritoQ == 0 then
                call TimerStart( t_KiritoQ, 0.03, true, function thistype.Loop_KiritoQ)
            endif
        endmethod

    endstruct

    private struct KiritoSpells_W
        private static timer t_KiritoW = CreateTimer()
        private static integer array m_KiritoW
        private static integer MUI_KiritoW = -1
        unit c
        real x
        real y
        real r2
        integer k2
        real scale
        real r5
        group g
        unit u
        real dmg
        integer check
        real aoe
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_KiritoW takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_KiritoW
                set this = m_KiritoW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit(c)
                    if scale < r5 then
                        set scale = scale + 0.35
                    endif
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    call BlzSetSpecialEffectScale(e2, scale)
                    call BlzSetSpecialEffectPosition(e2,x,y,45)
                    if r == rmax then
                        if check == 1 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1., 3, 3))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1., 4, 3))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1., 5, 3))
                            set e = EffectSpawn("war3mapImported\\wos_obr08 (237).mdl", x, y, a * bj_RADTODEG, 0.9, 4.75, GetUnitFlyHeight(c) + 25)
                        else
                            set e = EffectSpawnColor("war3mapimported\\wos_ZK_Narumea_tiaozhan1.mdx", GetUnitX(c) + 475 * Cos(a), GetUnitY(c) + 475 * Sin(a), a * bj_RADTODEG + 95, 1, 1.9, GetUnitFlyHeight(c) + 155, 255, 255, 255, 205)
                            call BlzSetSpecialEffectRoll(e, -90 * bj_DEGTORAD)
                        endif
                        call DestroyEffect(e)
                        call DecorRemove(c,x,y,aoe,40)
                        call MakeSound("war3mapimported\\Hero_Kirito_W2")
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                call dmgphys(c, u, dmg)
                                call SlowUnit(c, u, KiritoW_Slow, KiritoW_SlowDuration)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_whiteakihared.mdl", GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359), 1.1, 1.65, 100))
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                call DestroyEffect( AddSpecialEffectTarget("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", u, "chest"))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                else
                    call ColorEffDummy3(e2, 0, 255, 255, 255, 0.5)
                    call StopSpellUnit(c)
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set e = null
                    set m_KiritoW[i] = m_KiritoW[ MUI_KiritoW]
                    set MUI_KiritoW = MUI_KiritoW - 1
                    if MUI_KiritoW == -1 then
                        call PauseTimer( t_KiritoW)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method KiritoW_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_KiritoW = MUI_KiritoW + 1
            set m_KiritoW[ MUI_KiritoW] = this
            set c = NewC
            set r = 0
            set check = 0
            set a = GetUnitFacing(c) * bj_DEGTORAD
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = KiritoW_DamageAoe
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set g = CreateGroup()
            set r5 = 2.05
            set k2 = 0
            call StartSpellUnit(c)
            set dmg = KiritoW_Damage2StaticBase + (KiritoW_Damage2StaticStep * (GetUnitAbilityLevel(c, KiritoW_ID) - 1))
            set dmg = dmg + GetHeroAgi(c, true) * (KiritoW_DamageAgiBase + (KiritoW_DamageAgiStep * (GetUnitAbilityLevel(c, KiritoW_ID) - 1)))
            set rmax = 0.42
            if GetUnitAbilityLevel(c, KiritoR_AS) > 0 then
                set check = 1
                set r5 = 2.5
                set aoe = aoe + KiritoRW_AdditionalAoe
                set dmg = dmg + (KiritoRW_AdditionalDamageAgi * GetHeroAgi(c, true))
            endif
            call MakeSound("war3mapimported\\Hero_Kirito_W")
            call SetUnitAnimation( c , "spell five")
            call SetUnitTimeScale( c , 0.4)
            set r2 = 10
            set scale = 0.01
            
            set e2 = EffectSpawn2("war3mapImported\\wos_fuxuan-38.mdl", x, y, GetRandomReal(0, 359), 1.95, 0.01, 55, rmax + 0.3)
            call BlzSetSpecialEffectPitch(e2, -90 * bj_DEGTORAD)
            if MUI_KiritoW == 0 then
                call TimerStart( t_KiritoW, 0.03, true, function thistype.Loop_KiritoW)
            endif
        endmethod

    endstruct

    private struct KiritoSpells_E
        private static timer t_KiritoE2 = CreateTimer()
        private static integer array m_KiritoE2
        private static integer MUI_KiritoE2 = -1
        private static timer t_KiritoE = CreateTimer()
        private static integer array m_KiritoE
        private static integer MUI_KiritoE = -1
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
        unit array dd[4]
        real a
        real rmax

          private static method Loop_KiritoE2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_KiritoE2
                set this = m_KiritoE2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set r = S2R( R2SW( r , 0, 3 ) )
                    set x1 = GetUnitX(c)
                    set y1 = GetUnitY(c)
                    set a = GAngle2(c, x,y)
                    call DebugUnit(c)
                    if SR3(c, x,y) > move then
                        call MoveUnit(c, move, a)
                        set r6 = r6 + move
                        if r6 > KiritoE_MaxMoveRange then 
                        set r = 55555
                        endif
                        call SetUnitFacing(c, a * bj_RADTODEG)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x1, y1, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u, g2) == false then
                                call dmgphys(c, u, dmg)
                                if check == 0 then
                                    call MakeSound("Hero_Kirito_R5")
                                endif
                                set check = check + 1
                                call GroupAddUnit(g2, u)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_whiteakihared.mdl", GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359), 1.1, 1.65, 100))
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                call DestroyEffect( AddSpecialEffectTarget("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", u, "chest"))
                                call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_ZK_BMSword-qi explosion_Lan.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set r5 = GetRandomReal(0.4, 1)
                        call ColorEffDummy3(EffectSpawn3("war3mapimported\\wos_xxxxuanfeng2.mdl", x1, y1, a * bj_RADTODEG, r5, GetRandomReal(0.75, 1.35), 100, -90), 0.1, 25, 175, 175, 0.2)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_blue-texiao-buff2.mdl", x1, y1, GetRandomReal(0, 359), 2.55, 5.25, 0))
                        if r2 > 0.03 then
                            set r2 = 0
                            call DecorRemove(c,x1,y1,aoe,25)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x1, y1, a * bj_RADTODEG, 1, 1.5, 50))
                        else
                            set r2 = r2 + 0.03
                        endif
                    else
                        set r = 99999
                    endif
                else
                    call SaveInteger(hs, GetHandleId(c), StringHash("e count"), 1)
                    call SaveInteger(hs, GetHandleId(c), StringHash("e end"), 1)
                    
                    call StopSpellUnit(c)
                    call DestroyEffect(e2)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set e2 = null
                    set g = null
                    set g2 = null
                    set c = null
                    set m_KiritoE2[i] = m_KiritoE2[ MUI_KiritoE2]
                    set MUI_KiritoE2 = MUI_KiritoE2 - 1
                    if MUI_KiritoE2 == -1 then
                        call PauseTimer( t_KiritoE2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method KiritoE2_Start takes unit NewC, unit NewD returns nothing
            local thistype this = thistype.create( )
            set MUI_KiritoE2 = MUI_KiritoE2 + 1
            set m_KiritoE2[ MUI_KiritoE2] = this
            set c = NewC
            set r = 0
            set x = GetUnitX(NewD)
            set y = GetUnitY(NewD) 
            set check = 0
            set r2 = 10
            set r6 = 0
            set r3 = 10
            set g = CreateGroup()
            set g2 = CreateGroup()
            call StartSpellUnit(c)
            set aoe = KiritoE_DamageAoe
            set a = GAngle2( c , x, y ) // Angle Between points
            call MakeSound("war3mapImported\\Hero_Kirito_T5")
            set dmg = GetHeroAgi( c , true) * ( KiritoE_DamageAgiBase2 + ( KiritoE_DamageAgiStep2 * ( GetUnitAbilityLevel( c , KiritoE_ID) - 1 ) ) )
            set rmax = 3
            set move = 150
            call SaveInteger(hs, GetHandleId(c), StringHash("e end"), 1)
            if GetUnitAbilityLevel(c, KiritoR_AS) == 0 then
                call SetUnitAnimationByIndex(c, 6)
            else
                call SetUnitAnimationByIndex(c, 18)
            endif
            call SetUnitTimeScale( c , 1)
            call VisionTimed(GetOwningPlayer(c), x, y, 750, 6)
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_aurapartblue.mdx", c, "origin")
            if MUI_KiritoE2 == 0 then
                call TimerStart( t_KiritoE2, 0.03, true, function thistype.Loop_KiritoE2)
            endif
        endmethod

        private static method Loop_KiritoE takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_KiritoE
                set this = m_KiritoE[i]
                if SpellBoolCaster(c) and r <= rmax and LoadInteger(hs, GetHandleId(c), StringHash("e count")) == 0 then
                    if LoadInteger(hs, GetHandleId(c), StringHash("e end")) == 0 then
                        set r = RoundReal(r + 0.03, 3)
                    endif
                    call SaveReal(hs,GetHandleId(c),StringHash("e x"),GetMouseX(GetOwningPlayer(c)))
                    call SaveReal(hs,GetHandleId(c),StringHash("e y"),GetMouseY(GetOwningPlayer(c)))
                    if r == r5 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_afb_satomirentaro_kuding_clear.mdl", x, y, 0, 0.5, 3, 15))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_[dz_spell]002_blue5.mdl", x, y, 0, 1.5, 2, 5))
                       // call StopSpellUnit2(c)
                        set k = 0
                        loop
                            exitwhen k > 3
                            set dd[k] = CreateUnit(GetOwningPlayer(c), KiritoE_DummyId, GetUnitX(c), GetUnitY(c), a * bj_RADTODEG + (90 * k))
                            call PauseUnit(dd[k], true)
                            call MyRemoveUnit(dd[k], rmax + 1)
                            call SaveUnitHandle(hs, GetHandleId(c), StringHash("dummy" + I2S(k)), dd[k])
                            call AddSpecialEffectTarget("war3mapImported\\wos_aurapartblue.mdl", dd[k], "origin")
                            call SetScale(dd[k], BlzGetUnitRealField(c, UNIT_RF_SCALING_VALUE))
                            call SetUnitTimeScale(dd[k], 0.5)
                            call AddUnitAnimationProperties(dd[k], "alternate", false)
                            if GetUnitAbilityLevel(c, KiritoR_AS) == 0 then
                                call SetUnitAnimationByIndex(dd[k], 6)
                            else
                                call SetUnitAnimationByIndex(dd[k], 18)
                            endif
                            set k = k + 1
                        endloop
                    endif
                    if r == r5 + r4 then
                    
                      //      call SetMouseX(GetOwningPlayer(c),GetRectCenterX(gg_rct_Base))
                      //      call SetMouseY(GetOwningPlayer(c),GetRectCenterY(gg_rct_Base))
                  //  call MouseOn(GetOwningPlayer(c))
                        set k = 0
                        loop
                            exitwhen k > 3
                            call PauseUnit(dd[k], false)
                         //   call SaveUnitHandle(hs, GetHandleId(c), StringHash("dummy" + I2S(k)), dd[k])
                            if GetUnitAbilityLevel(c, KiritoR_AS) == 0 then
                                call SetUnitAnimationByIndex(dd[k], 8)
                            else
                                call SetUnitAnimationByIndex(dd[k], 19)
                            endif
                            call SetUnitTimeScale(dd[k], 1)
                            set k = k + 1
                        endloop
                    endif
                    if r >= r5 and r < r5 + r4 then
                        set k = 0
                        loop
                            exitwhen k > 3
                            if GetUnitTypeId(dd[k]) == KiritoE_DummyId then
                                call MoveUnit(dd[k], move, GetUnitFacing(dd[k]) * bj_DEGTORAD)
                            endif
                            
                            set k = k + 1
                        endloop
                        if r2 > 0.03 then
                            set r2 = 0
                            set k = 0
                            set k2 = 0
                            loop
                                exitwhen k > 3
                                call VisionTimed(GetOwningPlayer(c),GetUnitX(dd[k]), GetUnitY(dd[k]), aoe+200,0.8)
                                if GetUnitTypeId(dd[k]) == KiritoE_DummyId then
                                call DecorRemove(c,GetUnitX(dd[k]), GetUnitY(dd[k]), aoe,25)
                                    call ColorEffDummy3(EffectSpawn3("war3mapimported\\wos_xxxxuanfeng2.mdl", GetUnitX(dd[k]), GetUnitY(dd[k]), GetUnitFacing(dd[k]), r5, GetRandomReal(0.75, 1.35), 100, -90), 0.1, 25, 175, 175, 0.2)
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_blue-texiao-buff2.mdl", GetUnitX(dd[k]), GetUnitY(dd[k]), GetRandomReal(0, 359), 2.55, 5.25, 0))
                                    call GroupClear(g)
                                    call GroupEnumUnitsInRange(g, GetUnitX(dd[k]), GetUnitY(dd[k]), aoe, NoDecor_Cond)
                                    loop
                                        set u = FirstOfGroup(g)
                                        exitwhen u == null or k2 > 0
                                        if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitIllusion(u) == false and LoadInteger(hs, GetHandleId(u), StringHash("already marked kirito")) == 0 then
                                            call SaveInteger(hs, GetHandleId(u), StringHash("already marked kirito"), 1)
                                            call MyFlush(GetHandleId(u), StringHash("already marked kirito"), 0, 2)
                                            call dmgphys(c, u, dmg)
                                            call MakeSound("Hero_Kirito_R5")
                                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_whiteakihared.mdl", GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359), 1.1, 1.65, 100))
                                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                            call DestroyEffect( AddSpecialEffectTarget("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", u, "chest"))
                                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_ZK_BMSword-qi explosion_Lan.mdl", u, "chest"))
                                            set k2 = 1
                                            call ColorDummy3(dd[k], 0, 255, 255, 255, 0.75)
                                            set dd[k] = null
                                            set dd[k] = CreateUnit(GetOwningPlayer(c), KiritoE_DummyId2, GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359))
                                            call MUTU2(dd[k], rmax - r, 65, u)                                            
                            call SaveUnitHandle(hs, GetHandleId(c), StringHash("dummy" + I2S(k)), dd[k])
                                            call MyRemoveUnit(dd[k], rmax - r)
                                        endif
                                        call GroupRemoveUnit(g, u)
                                    endloop
                                endif
                                set k = k + 1
                            endloop
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                    if r> r5+r4 then 
                    if r2 > 0.03 then
                    set r2 = 0
                    
                            set k = 0
                            set k2 = 0
                            loop
                                exitwhen k > 3
                                call VisionTimed(GetOwningPlayer(c),GetUnitX(dd[k]), GetUnitY(dd[k]), aoe+200,0.8)
                                set k = k + 1
                            endloop
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),KiritoE_ID,true)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),KiritoE2_ID,false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),KiritoG_ID,true)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),KiritoG2_ID,false)
                    call SaveInteger(hs, GetHandleId(c), StringHash("e count"), 0)
                    call SaveInteger(hs, GetHandleId(c), StringHash("e"), 0)
                    set k = 0
                    loop
                        exitwhen k > 3
                        call ColorDummy3(dd[k], 0, 255, 255, 255, 0.4)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_[dz_spell]002_blue5.mdl", GetUnitX(dd[k]), GetUnitY(dd[k]), 0, 1.5, 1, 0))
                        call SaveUnitHandle(hs, GetHandleId(c), StringHash("dummy" + I2S(k)), null)
                        set dd[k] = null
                        set k = k + 1
                    endloop
                    if r < r5 then
                    call StopSpellUnit2(c)
                    endif
            call MouseOff(GetOwningPlayer(c))
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set e = null
                    set m_KiritoE[i] = m_KiritoE[ MUI_KiritoE]
                    set MUI_KiritoE = MUI_KiritoE - 1
                    if MUI_KiritoE == -1 then
                        call PauseTimer( t_KiritoE)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method KiritoE_Start takes unit NewC ,real NewX,real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_KiritoE = MUI_KiritoE + 1
            set m_KiritoE[ MUI_KiritoE] = this
            set c = NewC
            set r = 0
            set check = 0
            call SaveInteger(hs, GetHandleId(c), StringHash("e count"), 0)
            call SaveInteger(hs, GetHandleId(c), StringHash("e"), 1)
            call SaveInteger(hs, GetHandleId(c), StringHash("e end"), 0)
            set x = NewX
            set y = NewY
            set a = GAngle2(c,x,y)
            //call StartSpellUnit2(c)
            set g = CreateGroup()
            set r4 = KiritoE_CloneMoveDuration
            set move = (KiritoE_CloneMoveRangeBase+(KiritoE_CloneMoveRangeStep * (GetUnitAbilityLevel(c, KiritoE_ID) - 1))) / (KiritoE_CloneMoveDuration/0.03)
            call MakeSound("war3mapimported\\Hero_Kirito_E")
            set aoe = KiritoE_DamageAoe
            set dmg = KiritoE_Damage2StaticBase + (KiritoE_Damage2StaticStep * (GetUnitAbilityLevel(c, KiritoE_ID) - 1))
            set dmg = dmg + GetHeroAgi(c, true) * (KiritoE_DamageAgiBase + (KiritoE_DamageAgiStep * (GetUnitAbilityLevel(c, KiritoE_ID) - 1)))
            set r5 = 0.03
            set rmax = KiritoE_Duration + r5 + r4 //r5 + r4 ( r5 - prepate time, r4 - shadows walk all way by this time)
                        call MyFrame(c,rmax,"BTNHero_Kirito_E",false,0)
            if GetUnitAbilityLevel(c, KiritoR_AS) == 0 then
                call SetUnitAnimationByIndex(c, 8)
            else
                call SetUnitAnimationByIndex(c, 19)
            endif
            call UnitAddAbility(c,KiritoE2_ID)
            call UnitAddAbility(c,KiritoG2_ID)
            call MouseOn(GetOwningPlayer(c))
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),KiritoE2_ID,true)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),KiritoE_ID,false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),KiritoG2_ID,true)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),KiritoG_ID,false)
            call SetUnitTimeScale( c , 1)
            if MUI_KiritoE == 0 then
                call TimerStart( t_KiritoE, 0.03, true, function thistype.Loop_KiritoE)
            endif
        endmethod

    endstruct

    private struct KiritoSpells_R
        private static timer t_KiritoR = CreateTimer()
        private static integer array m_KiritoR
        private static integer MUI_KiritoR = -1
        private static timer t_KiritoR2 = CreateTimer()
        private static integer array m_KiritoR2
        private static integer MUI_KiritoR2 = -1
        private static timer t_KiritoR3 = CreateTimer()
        private static integer array m_KiritoR3
        private static integer MUI_KiritoR3 = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k2
        integer k3
        real r3
        group g
        framehandle array frame_pas1 [10]
        framehandle array frame_pas2 [10]
        framehandle array frame_pas3 [10]
        framehandle array frame_pas4 [10]
        framehandle array frame_pas5 [10]
        framehandle array frame_pas6 [10]
        unit u
        real dmg
        integer check
        real aoe
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_KiritoR takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_KiritoR
                set this = m_KiritoR[i]
                if SpellBoolCaster(c) and r <= rmax then
                    if IsUnitPaused(c) == false then 
                    set r = r + 0.05
                    endif
                    call BlzFrameSetValue(frame_pas3[k2], rmax - (r + 0.1))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                else
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),KiritoR2_ID,false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),KiritoR_ID,true)
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                     if GetLocalPlayer() == Player(k2) then
                                    call BlzFrameSetVisible(frame_pas1[k2], false)
                                endif
                                
            call AddSpellLevel(c,'A01C',10,false)
                    call UnitRemoveAbility(c, KiritoR_AS)
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("r atk count"), 0)
                    call AddUnitAnimationProperties(c, "alternate", false)
                    set e = null
                    set c = null
                    set e = null
                    set e2 = null
                    set m_KiritoR[i] = m_KiritoR[ MUI_KiritoR]
                    set MUI_KiritoR = MUI_KiritoR - 1
                    if MUI_KiritoR == -1 then
                        call PauseTimer( t_KiritoR)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method KiritoR_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_KiritoR = MUI_KiritoR + 1
            set m_KiritoR[ MUI_KiritoR] = this
            set c = NewC
            set r = 0
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set check = 0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set r2 = 10
            set r3 = 10
            set rmax = KiritoR_DurationBase + (KiritoR_DurationStep *(GetUnitAbilityLevel(c,KiritoR_ID)-1))
            call SetUnitAnimationByIndex(c, 18)
            call UnitAddAbility(c, KiritoR_AS)
            call SetUnitTimeScale( c , 1)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),KiritoR_ID,false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c),KiritoR2_ID,true)
            call UnitAddAbility(c,KiritoR2_ID)
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
                                call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Kirito_R", 0, false)
                                set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                                call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Starburst Stream:" + "|r")
                                call BlzFrameSetScale(frame_pas5[k2], 0.9)
                                set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17)
                                call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                                call BlzFrameSetScale(frame_pas6[k2], 0.9)
                            else
                                if GetLocalPlayer() == Player(k2) then
                                    call BlzFrameSetVisible(frame_pas1[k2], true)
                                endif
                                call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, rmax + 2)
                                call BlzFrameSetValue(frame_pas3[k2], rmax)
                            endif
            call AddUnitAnimationProperties(c, "alternate", true)
            call DecorRemove(c,x,y,350,20)
            call AddSpellLevel(c,'A01C',10,true)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_aurapartblue.mdx", c, "origin")
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_JN_22blue.mdx", c, "chest")
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_[dz_spell]002_blue5.mdl", x, y, 0, 1.25, 2, 0))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_[dz_spell]002_blue5.mdl", x, y, 0, 1.25, 1.5, 0))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.1, 1, 3))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.1, 2, 3))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.1, 3, 3))
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("r atk count"), 0)
            call MakeSound("war3mapImported\\Hero_Kirito_R")
            if MUI_KiritoR == 0 then
                call TimerStart( t_KiritoR, 0.05, true, function thistype.Loop_KiritoR)
            endif
        endmethod

        private static method Loop_KiritoR2 takes nothing returns nothing
            local integer this
            local integer i = 0
            local real random = 0
            loop
                exitwhen i > MUI_KiritoR2
                set this = m_KiritoR2[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.05
                    set r = S2R( R2SW( r , 0, 3 ) )
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    set a = GAngle(c, td)
                    call DebugUnit2(td)
                    call DebugUnit2(c)
                    call PosUnit(c, GetUnitX(td) - 160 * Cos(a), GetUnitY(td) - 160 * Sin(a))
                    if r2 > 0.1 then
                        set r2 = 0
                        if GetRandomInt(1,2) == 2 then 
            call SetUnitAnimationByIndex(c, 14)
            else
            call SetUnitAnimationByIndex(c, 20)
            endif
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.1, 2, 9))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.1, 3, 9))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.1, 4, 9))
                        set random = GetRandomReal(0, 359)
                        set e = EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, random, 0.75, 1, 115)
                        call BlzSetSpecialEffectRoll(e, -10 * bj_DEGTORAD)
                        call DestroyEffect(e)
                        set random = GetRandomReal(0, 359)
                        set e = EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, random, 0.75, 1, 115)
                        call BlzSetSpecialEffectRoll(e, -10 * bj_DEGTORAD)
                        call DestroyEffect(e)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x, y, a * bj_RADTODEG, 0.5, 4, 50))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_1hongse_2blue.mdl", x, y, random, 1.75, 2.5, 11))
                        call GroupClear(g)
                        call DecorRemove(c,x,y,aoe,25)
                        call GroupEnumUnitsInRange(g, x, y, aoe, null)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) or u == td then
                                if u == td then
                                //    call UnitRemoveAbility(td, 'Avul')
                                endif
                                call dmgphys(c, u, dmg)
                                call StunUnit(c, u, KiritoR_StunDuration)
                                if u == td then
                                  //  call UnitAddAbility(td, 'Avul')
                                endif
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_ZK_BMSword-qi explosion_Lan.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    else
                        set r2 = r2 + 0.05
                    endif
                    if r == 0.05 or r == 0.5 or r == 1 or r == 1.5 or r == 2 or r == 2.3 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZK_Narumea_lianzhan1.mdx", x - 50 * Cos(a), y - 50 * Sin(a), a * bj_RADTODEG + GetRandomReal( -15, 15), 1.1, 1.75, 1))
                    endif
                else
            call SaveInteger(hs,GetHandleId(c),StringHash("r st"),0)
            
            call SaveInteger(hs,GetHandleId(c),StringHash("asta e"),0)
                    call StopSpellUnit2(c)
                    call StopSpellUnit2(td)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set td = null
                    set m_KiritoR2[i] = m_KiritoR2[ MUI_KiritoR2]
                    set MUI_KiritoR2 = MUI_KiritoR2 - 1
                    if MUI_KiritoR2 == -1 then
                        call PauseTimer( t_KiritoR2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method KiritoR2_Start takes unit NewC, unit NewTd, real NewDmg returns nothing
            local thistype this = thistype.create( )
            set MUI_KiritoR2 = MUI_KiritoR2 + 1
            set m_KiritoR2[ MUI_KiritoR2] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set r2 = 10
            set r3 = 10
            set g = CreateGroup()
            set aoe = KiritoR_DamageAoe
            //set dmg = NewDmg * (KiritoR_DamageDealtBonusFinal / 100)
            set dmg = dmg + GetHeroAgi( c , true) * ( KiritoR_Damage2AgiBase + ( KiritoR_Damage2AgiStep * ( GetUnitAbilityLevel( c , KiritoR_ID) - 1 ) ) )
            set dmg = dmg / 5
            call StartSpellUnit2(c)
            
            call SaveInteger(hs,GetHandleId(c),StringHash("asta e"),1)
            call StartSpellUnit2(td)
            call SaveInteger(hs,GetHandleId(c),StringHash("r st"),1)
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("r atk count"),20)
            set rmax = 0.8
            call SetUnitAnimationByIndex(c, 14)
            call SetUnitTimeScale( c , 1)
            call MakeSound("war3mapImported\\Hero_Kirito_R12")
            if MUI_KiritoR2 == 0 then
                call TimerStart( t_KiritoR2, 0.05, true, function thistype.Loop_KiritoR2)
            endif
        endmethod

        private static method Loop_KiritoR3 takes nothing returns nothing
            local integer this
            local integer i = 0
             local integer atk
            local real random = 0
            loop
                exitwhen i > MUI_KiritoR3
                set this = m_KiritoR3[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax and check <3 then
                    set r = r + 0.05
                    set r = S2R( R2SW( r , 0, 3 ) )
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    set a = GAngle(c, td)
                    call DebugUnit2(c)
                    call PosUnit(c, GetUnitX(td) - 160 * Cos(a), GetUnitY(td) - 160 * Sin(a))
                    if r2 > 0.05 then
                        set r2 = 0
                        set check = check +1
       set atk = k3
        if atk == 0 then
            call MakeSound("war3mapImported\\Hero_Kirito_R1")
        elseif atk == 1 then
            call MakeSound("war3mapImported\\Hero_Kirito_R2")
        elseif atk == 2 then
            call MakeSound("war3mapImported\\Hero_Kirito_R3")
        elseif atk == 3 then
            call MakeSound("war3mapImported\\Hero_Kirito_R4")
        elseif atk == 4 then
            call MakeSound("war3mapImported\\Hero_Kirito_R5")
        elseif atk == 5 then
            call MakeSound("war3mapImported\\Hero_Kirito_R6")
        elseif atk == 6 then
            call MakeSound("war3mapImported\\Hero_Kirito_R7")
        elseif atk == 7 then
            call MakeSound("war3mapImported\\Hero_Kirito_R8")
        elseif atk == 8 then
            call MakeSound("war3mapImported\\Hero_Kirito_R9")
        elseif atk == 9 then
            call MakeSound("war3mapImported\\Hero_Kirito_R10")
            call MakeSound("war3mapImported\\Hero_Kirito_T3")
        elseif atk == 10 then
            call MakeSound("war3mapImported\\Hero_Kirito_R11")
            call MakeSound("war3mapImported\\Hero_Kirito_R5")
        elseif atk == 0 then
            call MakeSound("war3mapImported\\Hero_Kirito_R1")
        endif
        call SetUnitAnimation(c,"attack")
        call StunUnit(c, td, KiritoR_StunDuration)
        call dmgphys(c, td, dmg)
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", td, "chest"))
        call DestroyEffect( AddSpecialEffectTarget("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", td, "chest"))
        set e = EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, random, 0.75, 1, 115)
        call BlzSetSpecialEffectRoll(e, -15 * bj_DEGTORAD)
        call DestroyEffect(e)
        set random = GetRandomReal(0, 359)
        set e = EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, random, 0.75, 1, 115)
        call BlzSetSpecialEffectRoll(e, -10 * bj_DEGTORAD)
        call DestroyEffect(e)
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x, y, a * bj_RADTODEG, 0.5, 3, 50))
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_1hongse_2blue.mdl", x, y, random, 1.5, 3.45, 11))
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.4, 3, 3))
        set k3 = k3 + 1
                    else
                        set r2 = r2 + 0.05
                    endif
                  
                else
                    call StopSpellUnit2(c)
                    
            call SaveInteger(hs,GetHandleId(c),StringHash("asta e"),0)
                   // call UnitAddAbility(c,'Abun')
                   // call MyRemoveAbility(c,0.0,'Abun',1)
                    set c = null
                    set td = null
                    set m_KiritoR3[i] = m_KiritoR3[ MUI_KiritoR3]
                    set MUI_KiritoR3 = MUI_KiritoR3 - 1
                    if MUI_KiritoR3 == -1 then
                        call PauseTimer( t_KiritoR3)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method KiritoR3_Start takes unit NewC, unit NewTd, real NewDmg returns nothing
            local thistype this = thistype.create( )
             local integer atk
            set MUI_KiritoR3 = MUI_KiritoR3 + 1
            set m_KiritoR3[ MUI_KiritoR3] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set r2 = 10
            set r3 = 10
            set aoe = KiritoR_DamageAoe
            set dmg = NewDmg 
            set dmg = dmg /3 
            
            call SaveInteger(hs,GetHandleId(c),StringHash("asta e"),1)
            set k3 = LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("r atk count"))
            call StartSpellUnit2(c)
            set check = 0
            set rmax = 2
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("r atk count"), k3+5)
            call SetUnitAnimationByIndex(c, 14)
            call SetUnitTimeScale( c , 0.75)
            if MUI_KiritoR3 == 0 then
                call TimerStart( t_KiritoR3, 0.05, true, function thistype.Loop_KiritoR3)
            endif
        endmethod

    endstruct

    private struct KiritoSpells_T
        private static timer t_KiritoT = CreateTimer()
        private static integer array m_KiritoT
        private static integer MUI_KiritoT = -1
        private static timer t_KiritoT2 = CreateTimer()
        private static integer array m_KiritoT2
        private static integer MUI_KiritoT2 = -1
        unit c
        unit td
        real x
        real y
        real x1
        real y1
        real r2
        real scale
        real scale2
        real r3
        real r5
        group g
        unit u
        real dmg
        integer check
        real aoe
        real move
        real r
        effect e
        real a
        real rmax

        private static method Loop_KiritoT takes nothing returns nothing
            local integer this
            local integer i = 0
            local real random = 0
            loop
                exitwhen i > MUI_KiritoT
                set this = m_KiritoT[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set r = S2R( R2SW( r , 0, 3 ) )
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call DebugUnit(c)
                    call DebugUnit(td)
                    set a = GAngle(c, td)
                    call SetUnitFacing(c, a * bj_RADTODEG)                   
                    if check == 0 then
                        if r == 0.3 then
                            call SetUnitTimeScale(c, 0.1)
                        endif
                        if r == 0.3 then
                            set r = 0
                            set check = 1
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_[dz_spell]002_blue5.mdl", GetUnitX(c), GetUnitY(c), 0, 1.35, 1, 0))
                            call PosUnit(c, x - 150 * Cos(a), y - 150 * Sin(a))
                            call SetUnitFacing(c, GAngle(c, td) * bj_RADTODEG)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_[dz_spell]002_blue5.mdl", GetUnitX(c), GetUnitY(c), 0, 1.35, 1, 0))
                            call SetUnitTimeScale(c, 0.9)
                        endif
                    elseif check == 1 then
                        if r == 0.03 then
                            call SetUnitAnimationByIndex(c, 14)
                            call MakeSound("war3mapImported\\Hero_Kirito_T4")
                        endif
                        if r == 0.51 then 
                        set r5 = 0.3
                        endif
                        if r == 1.02 then 
                        set r5 = 0.24
                        endif
                        if r == 1.5 then 
                        set r5 = 0.18
                        endif
                        call PosUnit(td,GetUnitX(c)+150*Cos(a),GetUnitY(c)+150*Sin(a))
                        if r2 >= r5 and r < 1.51 then
                            set r2 = 0
                            if GetRandomInt(1,2) == 2 then                             
                            call SetUnitAnimationByIndex(c, 14)
                            else
                            call SetUnitAnimationByIndex(c, 20)
                            endif
                            call SetUnitAnimation(td, "death")
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.1, 3, 9))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_FantasyBattle (1642).mdx", x, y, GetRandomReal(0, 359), 1, 6, 0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_FantasyBattle (1643).mdx", x, y, GetRandomReal(0, 359), 0.9, 2.75, 0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.1, 5, 9))                    
                            set random = GetRandomReal(0, 359)
                            set e = EffectSpawn("war3mapImported\\wos_LD2209 (198)blue.mdl", x, y, random, 1.35, 4, 105)
                            call BlzSetSpecialEffectRoll(e, -10 * bj_DEGTORAD)
                            call DestroyEffect(e)
                            call BlzSetSpecialEffectAlpha(e, 0)
                            call ColorEffDummy4(e, 0, 255, 255, 255, 0.25)
                            set random = GetRandomReal(0, 359)
                            set e = EffectSpawn("war3mapImported\\wos_LD2209 (198)blue.mdl", x, y, random, 1.35, 4, 105)
                            call BlzSetSpecialEffectRoll(e, -10 * bj_DEGTORAD)
                            call DestroyEffect(e)
   
                            call BlzSetSpecialEffectAlpha(e, 0)
                            call ColorEffDummy4(e, 0, 255, 255, 255, 0.25)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x, y, a * bj_RADTODEG, 0.5, 5, 50))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_1hongse_2blue.mdl", x, y, random, 1.75, 3.45, 11))
                        else
                            set r2 = r2 + 0.05
                        endif
                        if r> 1.51 then 
                        if GetHeroLevel(c)>=35 then 
                        call MyFrame(c,4,"BTNHero_Kirito_T2",false,1)
                        call SwapAbility(c,4,KiritoT2_ID,KiritoT_ID)
                        endif
                        set r = 9999
                        endif
                    endif
                else
                    call StopSpellUnit(c)
                    call StopSpellUnit(td)
                                    call dmgphys(c, td, dmg)
                            call StunUnit(c,td,KiritoT2_Stun)
                                    set x = GetUnitX(td)
                                    set y = GetUnitY(td)
                                    call EUTU2(EffectSpawn("war3mapImported\\wos_Efect125.mdl",x,y,125,1,0.35,1),KiritoT_BlockHpRegenTime,1,td)
                            call BlockRegen(td, KiritoT_BlockHpRegenTime, KiritoT_BlockHpRegenAmount / 100)
                                
                    call SetUnitTimeScale(c, 1)
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set td = null
                    set e = null
                    set m_KiritoT[i] = m_KiritoT[ MUI_KiritoT]
                    set MUI_KiritoT = MUI_KiritoT - 1
                    if MUI_KiritoT == -1 then
                        call PauseTimer( t_KiritoT)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method KiritoT_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_KiritoT = MUI_KiritoT + 1
            set m_KiritoT[ MUI_KiritoT] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set r2 = 10
            set r3 = 10
            set check = 0
            set r5 = 0.39
            set aoe = KiritoT_DamageAoe
            set g = CreateGroup()
            set dmg = GetHeroAgi( c , true) * KiritoT_DamageAgiBase
            call StartSpellUnit(c)
            call StartSpellUnit(td)
            set rmax = 10
            call SetUnitAnimationByIndex(c, 19)
            call SetUnitTimeScale( c , 0.25)
            call MakeSound("war3mapImported\\Hero_Kirito_T1")            
            if MUI_KiritoT == 0 then
                call TimerStart( t_KiritoT, 0.03, true, function thistype.Loop_KiritoT)
            endif
        endmethod

         private static method Loop_KiritoT2 takes nothing returns nothing
            local integer this
            local integer i = 0
            local real random = 0
            loop
                exitwhen i > MUI_KiritoT2
                set this = m_KiritoT2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set r = S2R( R2SW( r , 0, 3 ) )
                    call DebugUnit(c)
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
                        if r == 0.03 then
                            call MakeSound("war3mapImported\\Hero_Kirito_T6")
                        endif
                        if r == 0.51 then // final strike start
            call SetUnitAnimationByIndex(c, 17)
            call SetUnitTimeScale(c, 0.2)
                            call MakeSound("war3mapImported\\Hero_Kirito_T5")
                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_moon_texiao_yanxindaji_01b.mdx", c, "hand right"))
                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_hit-nl-star2.mdx", c, "hand right"))
                        endif
                        if r == 0.9 then
                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_hit-nl-star2.mdx", c, "hand right"))
                        endif
                        if r == 1.02 then
                            call MakeSound("war3mapImported\\Hero_Kirito_T7")
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_[dz_spell]002_blue5.mdl", GetUnitX(c), GetUnitY(c), 0, 1.35, 1, 0))
                            call PosUnit(c, x - 150 * Cos(a), y - 150 * Sin(a))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_[dz_spell]002_blue5.mdl", GetUnitX(c), GetUnitY(c), 0, 1.35, 1, 0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Xuanfeng_whitewind.mdl", x - 60 * Cos(a), y - 60 * Sin(a), a * bj_RADTODEG, 0.5, 2.5, 125))
                        endif
                        if r == 1.02 then // final strike end
                            call DecorRemove(c,x,y,aoe,50)
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_2.mdl", x, y, a * bj_RADTODEG, 0.75, 6, 155, 255, 255, 255, 90))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_2.mdl", x, y, GetRandomReal(0, 359), 0.75, 7, 155, 255, 255, 255, 90))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_2.mdl", x, y, GetRandomReal(0, 359), 0.75, 8, 155, 255, 255, 255, 90))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (513).mdl", x, y, a * bj_RADTODEG, 2, 1, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x, y, a * bj_RADTODEG, 0.25, 5, 50))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_fuxuan-21.mdl", x, y, a * bj_RADTODEG, 2.5, 4, 155))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_1hongse_2blue.mdl", x, y, random, 0.45, 3.95, 11))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1., 3, 3))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 0.65, 4, 3))
                            set r = 99999
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, null)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call dmgphys(c, u, dmg)
                            call StunUnit(c,u,KiritoT2_Stun)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            endif
                else
                    call StopSpellUnit(c)
                    call DestroyEffect(e)
            call MouseOff(GetOwningPlayer(c))
                    call SetUnitTimeScale(c, 1)
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set u = null
                    set e = null
                    set m_KiritoT2[i] = m_KiritoT2[ MUI_KiritoT2]
                    set MUI_KiritoT2 = MUI_KiritoT2 - 1
                    if MUI_KiritoT2 == -1 then
                        call PauseTimer( t_KiritoT2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method KiritoT2_Start takes unit NewC, real NewX,real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_KiritoT2 = MUI_KiritoT2 + 1
            set m_KiritoT2[ MUI_KiritoT2] = this
            set c = NewC
            set x = NewX
            set y = NewY            
            set r = 0
            set r2 = 10
            set r3 = 10
            set check = 0
            set r5 = 0.42
            set x1 = GetUnitX(c)
            set y1 = GetUnitY(c)
            set g = CreateGroup()
            set dmg = GetHeroAgi( c , true) * KiritoT2_DamageAgiBase
            call StartSpellUnit(c)
            call MouseOn(GetOwningPlayer(c))
            set MouseX[GetPlayerId(GetOwningPlayer(c))] = x
            set MouseY[GetPlayerId(GetOwningPlayer(c))] = y
            set scale2 = 1300
            set r5 = 0.3
            set scale = 5
            call VisionTimed(GetOwningPlayer(c), x, y, aoe * 2, 2)
             set e = EffectSpawn("war3mapImported\\wos_[tx] (381).mdl", x1, y1, 1, 1, 0.01, 3)
            call ScaleEffDummy(e, r5, 0.01, scale)
            set rmax = 10
            set move = 150
            call SetUnitAnimationByIndex(c, 16)
            call SetUnitTimeScale( c , 0.25)        
            if MUI_KiritoT2 == 0 then
                call TimerStart( t_KiritoT2, 0.03, true, function thistype.Loop_KiritoT2)
            endif
        endmethod

    endstruct

    private struct KiritoSpells_G
        private static timer t_KiritoG = CreateTimer()
        private static integer array m_KiritoG
        private static integer MUI_KiritoG = -1
        unit c
        unit td
        real r2
        real r5
        group g
        effect e
        effect e2

        private static method Loop_KiritoG takes nothing returns nothing
            local integer this
            local integer i = 0
            local real random = 0
            loop
                exitwhen i > MUI_KiritoG
                set this = m_KiritoG[i]
                if c != null then
                    if IsUnitType(c,UNIT_TYPE_DEAD)==false and GetUnitState(c, UNIT_STATE_LIFE) < GetUnitState(c, UNIT_STATE_MAX_LIFE) then
                        set r5 = GetHeroAgi(c, true)*KiritoG_Heal
                        call SetHpCurrent2(c,c, r5)
                        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_e_buffgreen2a.mdx", c, "origin"))
                    endif
                else
                    call SetUnitTimeScale(c, 1)
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set td = null
                    set e = null
                    set e2 = null
                    set m_KiritoG[i] = m_KiritoG[ MUI_KiritoG]
                    set MUI_KiritoG = MUI_KiritoG - 1
                    if MUI_KiritoG == -1 then
                        call PauseTimer( t_KiritoG)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method KiritoG_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_KiritoG = MUI_KiritoG + 1
            set m_KiritoG[ MUI_KiritoG] = this
            set c = NewC
            set r2 = 0
            if MUI_KiritoG == 0 then
                call TimerStart( t_KiritoG, KiritoG_Time, true, function thistype.Loop_KiritoG)
            endif
        endmethod

    endstruct

    //----------------------------Kirito-----------------------------------------------
     /* Animations index:
    Base:
    0 - normal Stand reay
    1 - normal stand
    2 - normal walk
    3 - normal atk 1
    4 - normal atk2
    5 - normal atk prepare for q / w
    6 - normal q atk
    7 - normal w
    8 - normal defensive
    9 - normal T prepare
    10 - normal T
    11 - morph stand
    12 - morph atk1
    13 - morph atk2
    14 - morph atk3
    15 - morph t
    16 - morph walk
    17 - morph q prepare
    18 - morph q atk
    19 - morph defensive
    20 - morph starbust or t
    21 - morph ornyl i poletel
    22 - morph 21 continue
    
    
     */ 
    

    function KiritoQ_Start takes unit c, real x, real y returns nothing
        call KiritoSpells_Q.KiritoQ_Start( c, x, y )
    endfunction
    function KiritoW_Start takes unit c returns nothing
        call KiritoSpells_W.KiritoW_Start( c )
    endfunction
    function KiritoE_Start takes unit c ,real x, real y returns nothing
        call KiritoSpells_E.KiritoE_Start( c,x,y)
    endfunction
   /* function KiritoE2_Start takes unit c, real x, real y returns nothing
        local integer k = 0
        local integer check = 0
        local unit d
        local integer aoe = R2I(KiritoE_AoeClickAroundClone)
        loop
            exitwhen k > 3 or check > 0
            set d = LoadUnitHandle(hs, GetHandleId(c), StringHash("dummy" + I2S(k)))
            if d != null and SR3(d, x, y) <= aoe and IsUnitPaused(d) == false then
                call KiritoSpells_E.KiritoE2_Start(c, d)
                set check = 1
            endif
            set k = k + 1
        endloop
    endfunction*/
    function KiritoE2_Start takes unit c, real x, real y returns nothing
    local integer k = 0
    local unit d
    local unit closest = null
    local real dist
    local real minDist = 999999.0
    local integer check = 1
    local boolean b 
    if GetUnitAbilityLevel(c,KiritoG2_ID) == 2 then
    set check = 2
    set minDist = 0
    endif
    set x = LoadReal(hs,GetHandleId(c),StringHash("e x"))
    set y = LoadReal(hs,GetHandleId(c),StringHash("e y"))
    loop
        exitwhen k > 3
        set d = LoadUnitHandle(hs, GetHandleId(c), StringHash("dummy" + I2S(k)))
        if d != null and IsUnitPaused(d) == false then
            set dist = SR3(d, x, y)
            if check == 1 then 
            set b = dist < minDist
            else
            set b = dist > minDist
            endif
            if b then
                set minDist = dist
                set closest = d
            endif
        endif
        set k = k + 1
    endloop

    if closest != null then
        call KiritoSpells_E.KiritoE2_Start(c, closest)
    endif
    set d = null
    set closest = null
endfunction
    function KiritoR_Start takes unit c returns nothing
        call KiritoSpells_R.KiritoR_Start( c )
    endfunction
    function KiritoR2_Start takes unit c, unit td returns nothing
        local real dmg = GetAttack(c)
        local real a = GAngle(c,td)
        local real x = GetUnitX(td)-110*Cos(a)
        local real y = GetUnitY(td)-110*Sin(a)        
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_[dz_spell]002_blue5.mdl", GetUnitX(c), GetUnitY(c), 0, 2, 1.5, 0))
        call PosUnit(c,x,y)
        call SetUnitAnimation(c,"attack")
        call dmgatk(c,td,dmg)
        if IntegerCd(c,"cd atk ss",4) then 
        call MakeSound("war3mapimported\\Hero_Kirito_T5")
        endif
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_[dz_spell]002_blue5.mdl", GetUnitX(c), GetUnitY(c), 0, 2, 1.5, 0))
    endfunction
    function KiritoR_Attack takes unit c, unit td, real adddmg returns nothing
        local real x = GetUnitX(td)
        local real y = GetUnitY(td)
        local effect e
        local real a = GAngle(c, td)
        local real random = GetRandomReal(0, 359)
        local real dmg = GetHeroAgi( c , true) * ( KiritoR_DamageAgiBase + ( KiritoR_DamageAgiStep * ( GetUnitAbilityLevel( c , KiritoR_ID) - 1 ) ) )
        local real dmg2 = GetHeroAgi( c , true) * ( KiritoR_Damage2AgiBase + ( KiritoR_Damage2AgiStep * ( GetUnitAbilityLevel( c , KiritoR_ID) - 1 ) ) )
        local integer atk = LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("r atk count"))
        if LoadInteger(hs, GetHandleId(c), StringHash("r st")) == 0 then
        if atk < 20 then 
        if atk >=12 then //final atk
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("r atk count"),20)
            call KiritoSpells_R.KiritoR2_Start(c, td, dmg2)
            elseif atk< 12 then 
            call KiritoSpells_R.KiritoR3_Start(c, td, dmg)
            endif
            endif
            endif
        set e = null
    endfunction
    function KiritoT_Start takes unit c, unit td returns nothing
        call KiritoSpells_T.KiritoT_Start( c , td)
    endfunction
    function KiritoT2_Start takes unit c, real x,real y returns nothing
        call KiritoSpells_T.KiritoT2_Start( c , x,y)
    endfunction
    function KiritoPas takes unit c returns nothing
        if LoadInteger(hs, GetHandleId(c), StringHash("passive active")) == 0 then
            call SaveInteger(hs, GetHandleId(c), StringHash("passive active"), 1)
            call KiritoSpells_G.KiritoG_Start( c )
        endif
    endfunction
    
    function KiritoG2_Start takes unit c returns nothing
    if GetUnitAbilityLevel(c,KiritoG2_ID) == 1 then 
    call SetUnitAbilityLevel(c,KiritoG2_ID,2)
    call BlzSetAbilityIcon(KiritoE2_ID, "ReplaceableTextures\\CommandButtons\\BTNMove_Back.blp")
    call DisplayTimedTextToPlayer(GetOwningPlayer(c),0,0,1,"|c00FF0000you will move to ranged clone|r")
    else 
    call BlzSetAbilityIcon(KiritoE2_ID, "ReplaceableTextures\\CommandButtons\\BTNMove_Forward.blp")
    call DisplayTimedTextToPlayer(GetOwningPlayer(c),0,0,1,"|c00FF0000you will move to closest clone|r")
    call SetUnitAbilityLevel(c,KiritoG2_ID,1)    
    endif
    endfunction
    function KiritoF_Start takes unit c, unit td returns nothing
        local real x = GetUnitX(td)
        local real y = GetUnitY(td)
        local real x2 = GetUnitX(c)
        local real y2 = GetUnitY(c)
        call PosUnit(c,x,y)
        call PosUnit(td,x2,y2)
        call MakeSound("war3mapImported\\Hero_Kirito_F")
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_[dz_spell]002_blue5.mdl", x, y, 0, 1.5, 1.5, 0))
        call DestroyEffect(EffectSpawn("war3mapImported\\wos_[dz_spell]002_blue5.mdl", x2, y2, 0, 1.5, 1.5, 0))
    endfunction
endlibrary

