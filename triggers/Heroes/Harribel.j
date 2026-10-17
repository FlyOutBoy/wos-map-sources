library HarribelSpells uses GearSystems
    globals
//--------------------------------------Harribel--------------------------------------------------------------
        integer Harribel_ID = 'H01P'
        integer Harribel_Morph_ID = 'H01Q'
        integer HarribelG_ID = 'A0AS'
        integer Harribel_Pas2_lvlCap = 10
        integer Harribel_Pas3_lvlCap = 15
        integer Harribel_Pas4_lvlCap = 20
        real Harribel_Pas_DmgReduct = 5 
        real Harribel_Pas_RestoreHp1 = 6 // how much she restore hp when ally die in % of max hp, 10 = 10% of max hp resrtores when ally hero die
        real Harribel_Pas_RestoreHp2 = 8 // how much she restore hp when ally die in % of max hp, 10 = 10% of max hp resrtores when ally hero die
        real Harribel_Pas_RestoreHp3 = 10 // how much she restore hp when ally die in % of max hp, 10 = 10% of max hp resrtores when ally hero die
//---------------Q ability-----------------------------------------------------
        integer HarribelQ_ID = 'A0AM'
        real HarribelQ_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real HarribelQ_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real HarribelQ_Damage2StaticBase = 150 // base static damage for 1 level
        real HarribelQ_Damage2StaticStep = 0 // additional static damage for each next level
        real HarribelQ_DamageAoe = 200
        real HarribelQ_DamageAoeFinal = 475
        real HarribelQ_RangeBase = 1400        
        real HarribelQ_RangeStep = 100  
        real HarribelEQ_AoeFinal = 725
//---------------W ability-----------------------------------------------------
        integer HarribelW_ID = 'A0AN'
        real HarribelW_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real HarribelW_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real HarribelW_Damage2StaticBase = 175 // base static damage for 1 level
        real HarribelW_Damage2StaticStep = 0 // additional static damage for each next level
        real HarribelW_StunDuration = 1 // in seconds
        real HarribelEW_DamageAoe = 375
        real HarribelEW_DamageAgiBonus = 0.66 // per second
        real HarribelEW_MaxRange = 2000 // if target moved out of this range harribel instantly fly to him
        real HarribelEW_MaxCastDuration = 3 // in seconds, how much she can additionaly charge ability to increase damage
//---------------E ability-----------------------------------------------------
        integer HarribelE_ID = 'A0AO'
        real HarribelE_ReduceR_CD = 15 // in seconds , how long clone would live 10 = 10 sec
        integer HarribelE2_ID = 'A0AT'
        integer HarribelE_Atk_ID = 'A06N'
        real HarribelE_DurationBase = 12 // in seconds , how long clone would live 10 = 10 sec
        real HarribelE_DurationStep = 4 // in seconds , how much time added with next level
        integer HarribelE_Regen1_ID = 'A0AU'
        integer HarribelE_Regen2_ID = 'A0AV'
        integer HarribelE_Regen3_ID = 'A0AW'
        integer HarribelE_Regen4_ID = 'A0AX'
        integer HarribelE_Regen5_ID = 'A0AY'
        integer HarribelE_IdDummy = 'h00E'
        real HarribelEE_DamageAoe = 450
        real HarribelEE_DamageAgiBase = 1
        real HarribelEE_DamageAgiStep = 1
        real HarribelEE_DurationBase = 1
        real HarribelEE_DurationStep = 0.2
        real HarribelEE_PushRange = 400 // if target moved out of this range harribel instantly fly to him
        real HarribelEE_PushDuration = 0.15 // in seconds, how much she can additionaly charge ability to increase damage
//---------------R ability-----------------------------------------------------
        integer HarribelR_ID = 'A0AP'
        integer HarribelR2_ID = 'A0AQ'
        real HarribelR_DamageAgiBase = 5 // base number x Agi damage for each strike
        real HarribelR_DamageAgiStep = 1 // additional number x Agi damage for each next level each strike
        real HarribelR_DamageAoe = 800
        real HarribelER_DamageAoe = 225
        real HarribelER_DamageAoeFinal = 500
        real HarribelER_StunDuration = 0 // from 0.1 to 3 sec
        real HarribelER_DamageAgiBase = 0.8 // base number x Agi damage for each strike
        real HarribelER_DamageAgiStep = 0.25
        real HarribelER_RangeBase = 2100
        real HarribelER_RangeStep = 125
        integer HarribelER_BulletsNumberBase = 5 // base number of bullets for 1 - st level
        integer HarribelER_BulletsNumberStep = 0 // for each next lvl
//---------------T ability-----------------------------------------------------
        integer HarribelT_ID = 'A0AR'
        real HarribelT_DamageAgiBase = 10 // base number x Agi damage
        real HarribelT_DamageAoe = 1100
        real HarribelT_Stun = 0

    endglobals
    private struct HarribelSpells_Q
        private static timer t_HarribelQ = CreateTimer()
        private static integer array m_HarribelQ
        private static integer MUI_HarribelQ = -1
        unit c
        real x
        real y
        real r2
        real scale
        real r5
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
        real a
        real rmax

        private static method Loop_HarribelQ takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_HarribelQ
                set this = m_HarribelQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if r< r7 then 
                    call DebugUnit2(c)
                    endif
                    if r == r7 then
                        call DestroyEffect(e2)
                        if check == 0 then
                            set e2 = null
                            set e = EffectSpawn("war3mapImported\\wos_AZ_X024_2.mdl", GetUnitX(c) + 35 * Cos(a), GetUnitY(c) + 35 * Sin(a), a * bj_RADTODEG + 180, 1, 1.8, 120)
                            call BlzSetSpecialEffectAlpha(e, 0)
                            call ColorEffDummy4(e, 0, 255, 255, 255, 0.15)
                            set e2 = EffectSpawn("war3mapImported\\wos_AZ_D068.mdl", GetUnitX(c) + 65 * Cos(a), GetUnitY(c) + 65 * Sin(a), a * bj_RADTODEG + 180, 1.5, 3.35, 120)
                            call BlzSetSpecialEffectAlpha(e2, 0)
                            call ColorEffDummy4(e2, 0, 255, 255, 255, 0.15)
                            call MakeSound("war3mapImported\\Hero_Harribel_Q2")
                        else
                            call MakeSound("war3mapImported\\Hero_Harribel_EQ2")
                            set e = EffectSpawn("war3mapImported\\wos_cerooD2.mdl", GetUnitX(c) + 80 * Cos(a), GetUnitY(c) + 80 * Sin(a), a * bj_RADTODEG + 180, 1, 1.8, 120)
                            call BlzSetSpecialEffectAlpha(e, 0)
                            call ColorEffDummy4(e, 0, 255, 255, 125, 0.15)
                        endif
                       call StopSpellUnit2(c)
                    endif
                    if r >= r7 then
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        if check == 1 then
                            call EffectSpawnColor2("war3mapImported\\wos_cerooD2.mdx" , x , y , a * bj_RADTODEG , 1 , scale , 160 + r * 80 , 0.6 , 255 , 255 , 25 , 255)
                            call EffectSpawnColor2("war3mapImported\\wos_cerooD2.mdx" , x , y , a * bj_RADTODEG , 1 , scale * 0.7 , 160 + r * 80 , 0.54 , 225 , 225 , 225 , 205)
                            call EffectSpawnColor2("war3mapImported\\wos_cerooD2.mdx" , x + (move / 2) * Cos(a) , y + (move / 2) * Sin(a) , a * bj_RADTODEG , 1 , scale , 160 + r * 80 , 0.6 , 255 , 255 , 25 , 255)
                            call EffectSpawnColor2("war3mapImported\\wos_cerooD2.mdx" , x + (move / 2) * Cos(a) , y + (move / 2) * Sin(a) , a * bj_RADTODEG , 1 , scale * 0.7 , 160 + r * 80 , 0.54 , 225 , 225 , 225 , 205)
                            if scale < 9 then
                                set scale = scale + 0.35
                            endif
                            if aoe < HarribelEQ_AoeFinal then
                                set aoe = aoe + 35
                                else
                                set aoe = HarribelEQ_AoeFinal
                            endif
                        endif
                        call MoveEff(e, move, a)
                        call MoveEff(e2, move, a)
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        call GroupClear(g)
                        if check == 0 then
                        call DecorRemove(c,x,y,200,20)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    set r = 99999
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        else
                        call DecorRemove(c,x,y,aoe+125,50)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u, g2) == false then
                                    call dmgmag(c, u, dmg)
                                    call GroupAddUnit(g2, u)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop                          
                        endif
                        if r2 > 0.0 then
                            set r2 = 0
                            call VisionTimed(GetOwningPlayer(c), x, y, aoe + 300, 2)
                            if check == 0 then
                                set x = x + 150 * Cos(a)
                                set y = y + 150 * Sin(a)
                                set r5 = GetRandomReal(0.6, 1.25)
                                call ColorEffDummy3(EffectSpawn3("war3mapImported\\wos_xxxxuanfeng2.mdl", x, y, a * bj_RADTODEG, r5, GetRandomReal(0.75, 1.35), 100, -90), 0, 255, 255, 25, 0.3)
                            else
                                set x = x + 550 * Cos(a)
                                set y = y + 550 * Sin(a)
                                call EffectSpawn2("war3mapImported\\wos_krk (1849).mdl", x + (aoe / 1.5) * Cos(a - 90 * bj_DEGTORAD), y + (aoe / 1.5) * Sin(a - 90 * bj_DEGTORAD), a * bj_RADTODEG + 30, 2, GetRandomReal(0.95, 1.25), 100, 0.35)
                                call EffectSpawn2("war3mapImported\\wos_krk (1849).mdl", x + (aoe / 1.5) * Cos(a + 90 * bj_DEGTORAD), y + (aoe / 1.5) * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG - 30, 2, GetRandomReal(0.95, 1.25), 100, 0.35)
                            endif
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    call DestroyEffect(e)
                    if check == 0 then
                        call DestroyEffect(e2)
                        call DecorRemove(c,x,y,aoe+100,25)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_effect_order_dange_yueyun_3yellowlightclear.mdl", x, y, GetRandomReal(0, 359), 1.2, 1.2, 0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_5731-sl_8bc718f-F1_5.mdl", x, y, GetRandomReal(0, 359), 1, 1, 0))
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, HarribelQ_DamageAoeFinal, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                call dmgmag(c, u, dmg)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        call DecorRemove(c,x,y,aoe+50,40)
                    endif
                    if r < 0.42 then
                    call StopSpellUnit2(c)
                    endif
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g2 = null
                    set g = null
                    set e = null
                    set c = null
                    set e2 = null
                    set m_HarribelQ[i] = m_HarribelQ[ MUI_HarribelQ]
                    set MUI_HarribelQ = MUI_HarribelQ - 1
                    if MUI_HarribelQ == -1 then
                        call PauseTimer( t_HarribelQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method HarribelQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_HarribelQ = MUI_HarribelQ + 1
            set m_HarribelQ[ MUI_HarribelQ] = this
            set c = NewC
            set r = 0
            set x = NewX
            set y = NewY
            set check = 0
            set r2 = 10
            set g = CreateGroup()
            set g2 = CreateGroup()
            call StartSpellUnit2(c)
            set aoe = HarribelQ_DamageAoe
            set a = GAngle2( c , x, y ) // Angle Between points
            set dmg = GetHeroAgi( c , true) * ( HarribelQ_DamageAgiBase + ( HarribelQ_DamageAgiStep * ( GetUnitAbilityLevel( c , HarribelQ_ID) - 1 ) ) )
            set dmg = dmg+ HarribelQ_Damage2StaticBase + (HarribelQ_Damage2StaticStep * (GetUnitAbilityLevel(c, HarribelQ_ID) - 1))
            
            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e")) == 0 then
                call MakeSound("war3mapImported\\Hero_Harribel_Q")
                call SetUnitAnimationByIndex( c , 1)
                call SetUnitTimeScale( c , 0.42)
                set r7 = 0.57
            set move = (HarribelQ_RangeBase+ (HarribelQ_RangeStep * (GetUnitAbilityLevel(c, HarribelQ_ID) - 1))) / 16
            else
            set r7 = 0.69
            set move = HarribelQ_RangeBase / 17
                set check = 1
                set scale = 3.1
                call MakeSound("war3mapImported\\Hero_Harribel_EQ")
                call SetUnitAnimationByIndex( c , 2)
                call SetUnitTimeScale( c , 0.21)
            endif            
            set rmax = r7+0.51
            call SetUnitFacing(c, a * bj_RADTODEG)
           set e2 = AddSpecialEffectTarget("war3mapImported\\wos_ChuShou_BY_Wood_yellow_XuLi.mdl", c, "weapon")
            if MUI_HarribelQ == 0 then
                call TimerStart( t_HarribelQ, 0.03, true, function thistype.Loop_HarribelQ)
            endif
        endmethod

    endstruct

    private struct HarribelSpells_W
        private static timer t_HarribelW = CreateTimer()
        private static integer array m_HarribelW
        private static integer MUI_HarribelW = -1
        unit c
        unit td
        real x
        real y
        real r2
        real r3
        real r4
        real r5
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

        private static method Loop_HarribelW takes nothing returns nothing
            local integer this
            local real rr5 = 0
            local integer i = 0
            loop
                exitwhen i > MUI_HarribelW
                set this = m_HarribelW[i]
                if SpellBoolCaster(c) and r <= rmax and SpellBoolCaster(td) then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    set a = GAngle(c, td)
                    call SetUnitFacing(c, a * bj_RADTODEG)
                    if check == 1 and r4 > rmax then
                        if r == 0.51 then
                            call SetUnitTimeScale(c, 0)
                        endif
                        if GetUnitCurrentOrder(c) != OrderId("acidbomb") or r > HarribelEW_MaxCastDuration + 0.12 or SR2(c,td)>=HarribelEW_MaxRange then
                            set r4 = r
                            call StartSpellUnit(c)
                            call SetUnitAnimationByIndex(c, 0)
                        endif
                        if r2 > 0.09 then
                            set r2 = 0
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_dustwave222.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 0.75, 2.3, 0, 255, 255, 55, 65))
                        else
                            set r2 = r2 + 0.03
                        endif
                        if r3 > 0.2 then
                            set r3 = 0
                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_eff (24).mdx", c, "weapon"))
                        else
                            set r3 = r3 + 0.03
                        endif
                        if r5 > 0.93 then
                            set r5 = 0
                            set dmg = dmg + GetHeroAgi(c, true) * HarribelEW_DamageAgiBonus
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdx", x, y, GetRandomReal(0, 359), 0.5, 1.4, 1))
                        else
                            set r5 = r5 + 0.03
                        endif                   
                    endif
                    if r == r4 then
                    if check == 0 then
                        call SetUnitTimeScale(c, 0.65)
                        call SetUnitAnimationByIndex(c, 3)
                        endif
                        call MakeSound("war3mapImported\\Hero_Harribel_W2")
                    endif
                    if r >= r4 then
                        if SR2(c, td) > 120 then
                            call MoveUnit2(c, move, a)
                            if r2 > 0.0 then
                                set r2 = 0
                            
                                set x = x + 70 * Cos(a)
                                set y = y + 70 * Sin(a)
                                if check == 0 then
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZarakiQEff2.mdl", x, y, GetRandomReal(0, 359), 2.85, 1.5, 50))
                                else
                                    call EffectSpawn2("war3mapImported\\wos_Bubbles2.mdx", x, y, GetRandomReal(0, 359), 0.45, 4.5, 25, 0.75)
                                endif
                            else
                                set r2 = r2 + 0.03
                            endif
                        else
                            set r = 999
                        endif
                    endif
                else
                    call MakeSound("war3mapImported\\Hero_Harribel_W3")
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call StopSpellUnit(c)
                    call DestroyEffect(e2)
                    if r == 999 then
                        if check == 1 then
                    call DecorRemove(c,x,y,aoe+100,60)                
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdx", x, y, GetRandomReal(0, 359), 0.5, 1.5, 1))
                            call EffectSpawn2("war3mapImported\\wos_Eff (134).mdl", x, y, GetRandomReal(0, 359), 0.55, 1.5, 0, 1)
                            call EffectSpawn2("war3mapImported\\wos_Eff (134).mdl", x, y, GetRandomReal(0, 359), 0.55, 2.5, 0, 1)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_slardar(hclz)_r.mdx", x, y, GetRandomReal(0, 359), 0.35, 2.2, 75))
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call dmgphys(c, u, dmg)
                                    call StunUnit(c, u, HarribelW_StunDuration)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop                 
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_effect_order_dange_yueyun_3yellow_light.mdl", x, y, GetRandomReal(0, 359), 1.15, 1.45, 0))
                        else
                    call DecorRemove(c,x,y,250,25)
                            call StunUnit(c, td, HarribelW_StunDuration)
                            call dmgphys(c, td, dmg)
                        endif
                        call SetUnitAnimation(td, "death")
                        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_bloodex-special-23.mdl", td, "chest"))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZarakiWCrack1.mdx", x, y, GetRandomReal(0, 359), 1.25, 1.5, 0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (513)yellow.mdl", x, y, GetRandomReal(0, 359), 1, 0.9, 1))
                    endif
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("w skill"), 0)                    
                    call SetUnitTimeScale( c , 1)
                    call DestroyGroup(g)
                    set e = null
                    set g = null
                    set c = null
                    set e2 = null
                    set m_HarribelW[i] = m_HarribelW[ MUI_HarribelW]
                    set MUI_HarribelW = MUI_HarribelW - 1
                    if MUI_HarribelW == -1 then
                        call PauseTimer( t_HarribelW)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method HarribelW_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_HarribelW = MUI_HarribelW + 1
            set m_HarribelW[ MUI_HarribelW] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set check = 0
            set r5 = 0
            set g = CreateGroup()
            set aoe = HarribelEW_DamageAoe
            set a = GAngle( c , td ) // Angle Between points
            set dmg = GetHeroAgi( c , true) * ( HarribelW_DamageAgiBase + ( HarribelW_DamageAgiStep * ( GetUnitAbilityLevel( c , HarribelW_ID) - 1 ) ) )
            set dmg = dmg+ HarribelW_Damage2StaticBase + (HarribelW_Damage2StaticStep * (GetUnitAbilityLevel(c, HarribelW_ID) - 1))
            set rmax = 4.12
            call SetUnitFacing(c, a * bj_RADTODEG)
            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e")) == 0 then            
                call StartSpellUnit2(c)
                call MakeSound("war3mapImported\\Hero_Harribel_W")
               // call SetUnitAnimationByIndex( c , 11)
                call SetUnitTimeScale( c , 1)
                set r4 = 0.45                
            set move = 80
            else
                set r4 = 999
                set check = 1
                set rmax = 8
                call MakeSound("war3mapImported\\Hero_Harribel_EW")
                call SetUnitAnimationByIndex( c , 0)
                call SetUnitTimeScale( c , 0.4)
            set move = 105
            endif
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("w skill"), 1)
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_ChuShou_BY_Wood_yellow_XuLi.mdl", c, "weapon")
            if MUI_HarribelW == 0 then
                call TimerStart( t_HarribelW, 0.03, true, function thistype.Loop_HarribelW)
            endif
        endmethod

    endstruct

    private struct HarribelSpells_E
        private static timer t_HarribelE = CreateTimer()
        private static integer array m_HarribelE
        private static integer MUI_HarribelE = -1
        private static timer t_HarribelE2 = CreateTimer()
        private static integer array m_HarribelE2
        private static integer MUI_HarribelE2 = -1
        unit d
        unit c
        real x
        real y
        real r2
        integer k2
        real scale
        real r3
        group g
        group g2
        unit u
        real dmg
        integer check
        real aoe
        real r
        framehandle array frame2_pas1 [10]
        framehandle array frame2_pas2 [10]
        framehandle array frame2_pas3 [10]
        framehandle array frame2_pas4 [10]
        framehandle array frame2_pas5 [10]
        framehandle array frame2_pas6 [10]
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_HarribelE takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real tmp_y = 0.0375
            loop
                exitwhen i > MUI_HarribelE
                set this = m_HarribelE[i]
                if SpellBoolCaster(c) and r <= rmax and CheckCoordsInRect(gg_rct_Base,GetUnitX(c),GetUnitY(c)) == false then
                    if check == 0 or (check == 1 and IsUnitPaused(c) == false and GetUnitAbilityLevel(c, 'Avul') == 0 and LoadInteger(hs, GetHandleId(Player(k2)), StringHash("w skill"))==0) then
                        set r = r + 0.05
                    endif
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if check == 0 then
                        if r == 0.5 then
                            call SetUnitTimeScale(c, 0.05)
                        endif
                        if r >= 0.1 then
                            if r2 > 0.24 then
                                set r2 = 0
                                call DecorRemove(c,x,y,450,20)
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_Eff (134).mdl", x, y, GetRandomReal(0, 359), 1, 0.5, 11))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_Eff (134).mdl", x, y, GetRandomReal(0, 359), 1, 1.5, 11))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_Eff (134).mdl", x, y, GetRandomReal(0, 359), 1, 2.5, 11))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdx", x, y, GetRandomReal(0, 359), 0.86, 2.5, 1))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_az_xiaonajia01_d_W.mdx", x, y, GetRandomReal(0, 359), 1.5, 2.75, 55))
                            else
                                set r2 = r2 + 0.05
                            endif
                        endif
                        if r == rmax then
                            call SetUnitTimeScale(c, 1)
                            set rmax = HarribelE_DurationBase + (HarribelE_DurationStep * ( GetUnitAbilityLevel( c , HarribelE_ID) - 1 )) + 0.2
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_LD2209 (129).mdx", x, y, GetRandomReal(0, 359), 1.75, 3.15, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_LD2209 (129).mdx", x, y, GetRandomReal(0, 359), 1.5, 4.15, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (171)4_short2.mdl", x, y, 0, 3, 0.8, 0))
                            call MakeSound("war3mapImported\\Hero_Harribel_E2")
                            call StopSpellUnit2(c)
                            call BlzSetUnitSkin(c, Harribel_Morph_ID)
                            call AAUniversalTooltips_SetUnitForm(c, 1)
                            call FixAura(c)
                            call UnitRemoveAbility(c,'A0B0')
                            call UnitAddAbility(c,HarribelE_Atk_ID)
                            call SetUnitAbilityLevel(c, HarribelE_Atk_ID, GetUnitAbilityLevel(c, HarribelE_ID))
                            call UnitAddAbility(c, HarribelE2_ID)
                            if GetUnitAbilityLevel(c,HarribelE_ID)== 1 then 
                            call UnitAddAbility(c,HarribelE_Regen1_ID)
                            elseif GetUnitAbilityLevel(c,HarribelE_ID)== 2 then
                            call UnitAddAbility(c,HarribelE_Regen2_ID)
                            elseif GetUnitAbilityLevel(c,HarribelE_ID)== 3 then
                            call UnitAddAbility(c,HarribelE_Regen3_ID)
                            elseif GetUnitAbilityLevel(c,HarribelE_ID)== 4 then
                            call UnitAddAbility(c,HarribelE_Regen4_ID)
                            elseif GetUnitAbilityLevel(c,HarribelE_ID)== 5 then
                            call UnitAddAbility(c,HarribelE_Regen5_ID)
                            endif
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), HarribelE_ID, false)
                            call SetUnitAbilityLevel(c, HarribelE2_ID, GetUnitAbilityLevel(c, HarribelE_ID))
                            if GetUnitAbilityLevel(c,HarribelR_ID)>0 then 
                            call UnitAddAbility(c, HarribelR2_ID)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), HarribelR_ID, false)
                            call SetUnitAbilityLevel(c, HarribelR2_ID, GetUnitAbilityLevel(c, HarribelR_ID))
                             call BlzStartUnitAbilityCooldown(c,HarribelR2_ID,BlzGetUnitAbilityCooldownRemaining(c, HarribelR_ID))
                            if GetHeroLevel(c) >= 35 then
                            call ReduceCooldown(c,HarribelR2_ID,HarribelE_ReduceR_CD)
                           endif
                           endif
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
                                call BlzFrameSetMinMaxValue(frame2_pas3[k2], 0, rmax+2)
                                call BlzFrameSetValue(frame2_pas3[k2], rmax)
                                set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18)
                                call BlzFrameSetSize(frame2_pas4[k2], 0.03, 0.03)
                                call BlzFrameSetTexture(frame2_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Harribel_E", 0, false)
                                set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                                call BlzFrameSetText(frame2_pas5[k2], "|c00FFFF00" + "Morph Time Left:" + "|r")
                                call BlzFrameSetScale(frame2_pas5[k2], 0.9)
                                set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17)
                                call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                                call BlzFrameSetScale(frame2_pas6[k2], 0.9)
                            else
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame2_pas1[k2], true)
                                endif
                                call BlzFrameSetMinMaxValue(frame2_pas3[k2], 0, rmax+2)
                                call BlzFrameSetValue(frame2_pas3[k2], rmax)
                            endif
                            if GetHeroLevel(c)<12 then 
                            set tmp_y = 0
                            endif
                            call BlzFrameSetAbsPoint(frame2_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18+tmp_y)
                            call BlzFrameSetAbsPoint(frame2_pas2[k2], FRAMEPOINT_CENTER, 0.07, 0.185+tmp_y)
                            call BlzFrameSetAbsPoint(frame2_pas3[k2], FRAMEPOINT_CENTER, 0.05, 0.175+tmp_y)
                            call BlzFrameSetAbsPoint(frame2_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18+tmp_y)
                            call BlzFrameSetAbsPoint(frame2_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185+tmp_y)
                            call BlzFrameSetAbsPoint(frame2_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17+tmp_y)
                                               
                            
                            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e"), 1)
                            set r = 0
                            set d = CreateUnit(Player(k2), HarribelE_IdDummy, 1, 1, 1)
                            set r2 = 9999
                            set check = 1
                        endif
                    elseif check == 1 then                    
                        call BlzFrameSetValue(frame2_pas3[k2], rmax - (r + 0.1))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                        
                        if r == 0.05 then
                            call BlzSetAbilityIcon(HarribelQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Harribel_EQ.blp")
                            call BlzSetAbilityIcon(HarribelW_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Harribel_EW.blp")
                        endif
                    endif
                else
                    if check == 0 then                
                        call DestroyEffect(e2)
                        call StopSpellUnit(c)
                    endif
                    call RemoveUnit(d)
                    if GetUnitCurrentOrder(c)== OrderId("antimagicshell") then 
                    call IssueImmediateOrder(c,"stop")
                    endif
                    call SaveInteger(hs, GetHandleId(Player(k2)), StringHash("morph e"), 0)
                    call BlzSetAbilityIcon(HarribelQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Harribel_Q.blp")
                    call BlzSetAbilityIcon(HarribelW_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Harribel_W.blp")           
                    call SetPlayerAbilityAvailable(Player(k2), HarribelR_ID, true)
                    call BlzSetUnitSkin(c, Harribel_ID)
                    call AAUniversalTooltips_SetUnitForm(c, 0)
                    call FixAura(c)
                            call UnitRemoveAbility(c,'A0B0')
                              call BlzStartUnitAbilityCooldown(c,HarribelR_ID,BlzGetUnitAbilityCooldownRemaining(c,HarribelR2_ID))
                    call UnitRemoveAbility(c,HarribelE_Atk_ID)                    
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), HarribelE_ID, true)
                    call UnitRemoveAbility(c,HarribelE_Regen1_ID)
                    call UnitRemoveAbility(c,HarribelE_Regen2_ID)
                    call UnitRemoveAbility(c,HarribelE_Regen3_ID)
                    call UnitRemoveAbility(c,HarribelE_Regen4_ID)
                    call UnitRemoveAbility(c,HarribelE_Regen5_ID)
                    call UnitRemoveAbility(c, HarribelR2_ID)
                    call UnitRemoveAbility(c, HarribelE2_ID)
                    call SetUnitTimeScale( c, 1 )
                    if check == 0 then
                    call StopSpellUnit2(c)
                    endif
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frame2_pas1[k2], false)
                    endif
                    set c = null
                    set d = null
                    set m_HarribelE[i] = m_HarribelE[MUI_HarribelE]
                    set MUI_HarribelE = MUI_HarribelE - 1
                    if MUI_HarribelE == -1 then
                        call PauseTimer( t_HarribelE )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod

        public static method HarribelE_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_HarribelE = MUI_HarribelE + 1
            set m_HarribelE[MUI_HarribelE] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set r2 = 10
            set r3 = 10
            set k2 = GetPlayerId(GetOwningPlayer(c))
            call StartSpellUnit2(c)
            set check = 0
            set u = null
            set a = GetUnitFacing(c) * bj_DEGTORAD // Angle Between points
            set rmax =1
            set scale = BlzGetUnitRealField(c, UNIT_RF_SCALING_VALUE)
            call SetUnitTimeScale(c, 0.9)
            call SetUnitAnimationByIndex(c, 5 )
            call MakeSound("war3mapImported\\Hero_Harribel_E")
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_hakkeStart.mdx", x, y, GetRandomReal(0, 359), 0.35, 1.75, 5))
            if MUI_HarribelE == 0 then
                call TimerStart( t_HarribelE, 0.05, true, function thistype.Loop_HarribelE )
            endif
        endmethod

        private static method Loop_HarribelE2 takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_HarribelE2
                set this = m_HarribelE2[i]
                if SpellBoolCaster(c) and r <= rmax and LoadInteger(hs,GetHandleId(c),StringHash("esc"))== 0 then
                    call DebugUnit2(c)
                    set r = r+ 0.05
                    if r == 0.45 then 
                    call SetUnitTimeScale(c,0)
                    endif
                    call BlzSetSpecialEffectPosition(e,GetUnitX(c)+150*Cos(a),GetUnitY(c)+150*Sin(a),220)
                    if r2>0.3 then 
                    set r2 = 0
                    call GroupClear(g)
                    set x = GetUnitX(c)+150*Cos(a)
                    set y = GetUnitY(c)+150*Sin(a)
                    call DecorRemove(c,x,y,aoe+100,60) 
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_slardar(hclz)_r.mdx", x, y, GetRandomReal(0, 359), 1, 3.15, 1))
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    if IsUnitInGroup(u,g2) ==false then 
                                    call dmgphys(c, u, dmg)
                                    call GroupAddUnit(g2,u)
                                    endif
                                    call MUE(u,HarribelEE_PushRange,HarribelEE_PushDuration,a)                                
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop           
                    else
                    set r2 = r2 + 0.05
                    endif
                else
                call SaveInteger(hs,GetHandleId(c),StringHash("esc"),0)
            call SaveInteger(hs,GetHandleId(c),StringHash("invul"),0)
                    call DestroyEffect(e)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    call StopSpellUnit2(c)
                    set c = null
                    set e = null
                    set u = null
                    set g = null
                    set g2 = null
                    set m_HarribelE2[i] = m_HarribelE2[MUI_HarribelE2]
                    set MUI_HarribelE2 = MUI_HarribelE2 - 1
                    if MUI_HarribelE2 == -1 then
                        call PauseTimer( t_HarribelE2 )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod

        public static method HarribelE2_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_HarribelE2 = MUI_HarribelE2 + 1
            set m_HarribelE2[MUI_HarribelE2] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set g = CreateGroup()
            set g2 = CreateGroup()
            set r2 = 10
            set r3 = 10
            call StartSpellUnit2(c)
            set check = 0
            call SetUnitAnimationByIndex(c,7)
            call SetUnitTimeScale(c,0.5)
            set aoe = HarribelEE_DamageAoe 
                call SaveInteger(hs,GetHandleId(c),StringHash("esc"),0)
            set u = null
            set dmg = GetHeroAgi( c , true) * ( HarribelEE_DamageAgiBase + ( HarribelEE_DamageAgiStep * ( GetUnitAbilityLevel( c , HarribelE_ID) - 1 ) ) )
            call SaveInteger(hs,GetHandleId(c),StringHash("invul"),1)
            set a = GetUnitFacing(c) * bj_DEGTORAD // Angle Between points
            call BlzSetUnitFacingEx(c,a*bj_RADTODEG)
            set rmax = HarribelEE_DurationBase + (HarribelEE_DurationStep *(GetUnitAbilityLevel(c,HarribelE_ID)-1))
            call MakeSound("war3mapImported\\Hero_Harribel_E2 1")
            call MakeSound("war3mapImported\\Hero_Harribel_E2 2")
            set e = EffectSpawn3("war3mapimported\\wos_m2 (105)_2.mdx",GetUnitX(c)+150*Cos(a),GetUnitY(c)+150*Sin(a),a*bj_RADTODEG,1,1.35,220,-90)
            if MUI_HarribelE2 == 0 then
                call TimerStart( t_HarribelE2, 0.05, true, function thistype.Loop_HarribelE2 )
            endif
        endmethod

    endstruct

    private struct HarribelSpells_R
        private static timer t_HarribelR = CreateTimer()
        private static integer array m_HarribelR
        private static integer MUI_HarribelR = -1
        private static timer t_HarribelR3 = CreateTimer()
        private static integer array m_HarribelR3
        private static integer MUI_HarribelR3 = -1
        private static timer t_HarribelR2 = CreateTimer()
        private static integer array m_HarribelR2
        private static integer MUI_HarribelR2 = -1
        unit c
        real x
        real y
        real r2
        integer k
        integer k2
        real r3
        real r4
        real r5
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

        private static method Loop_HarribelR takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_HarribelR
                set this = m_HarribelR[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit(c)
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if r2 > 0.21 then
                        set r2 = 0
                        call DecorRemove(c,x,y,aoe,50)
                        call MakeSound("war3mapImported\\Hero_Harribel_R2")
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_1zdaoguang_97.mdl", x, y, GetRandomReal(0, 359), 1, 1.5, 75))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_1zdaoguang_97.mdl", x, y, GetRandomReal(0, 359), 1, 2, 25))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_1zdaoguang_97.mdl", x, y, GetRandomReal(0, 359), 1, 3.5, 0))
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u, g2) == false then
                                call GroupAddUnit(g2, u)
                                call MUE(u,450,0.21,GAngle3(x,y,u))
                                call dmgphys(c, u, dmg)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    else
                        set r2 = r2 + 0.03
                    endif
                    if r3 > 0.03 then
                        set r3 = 0
                    
                        set k = 0
                        loop
                            exitwhen k > 3
                            set r4 = GetRandomReal(50, 600)
                            set r5 = GetRandomReal(0, 359) * bj_DEGTORAD
                            set e = EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x + r4 * Cos(r5), y + r4 * Sin(r5), GetRandomReal(0, 359), 1.75, 1.2, 255)
                            call BlzSetSpecialEffectRoll(e, -15 * bj_DEGTORAD)
                            call DestroyEffect(e)
                            set k = k + 1
                        endloop
                    else
                        set r3 = r3 + 0.03
                    endif
                else
                    call StopSpellUnit(c)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set e = null
                    set g = null
                    set g2 = null
                    set c = null
                    set e2 = null
                    set m_HarribelR[i] = m_HarribelR[ MUI_HarribelR]
                    set MUI_HarribelR = MUI_HarribelR - 1
                    if MUI_HarribelR == -1 then
                        call PauseTimer( t_HarribelR)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method HarribelR_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_HarribelR = MUI_HarribelR + 1
            set m_HarribelR[ MUI_HarribelR] = this
            set c = NewC
            set r = 0
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set check = 0
            set r2 = 10
            set g = CreateGroup()
            set g2 = CreateGroup()
            call StartSpellUnit(c)
            set aoe = HarribelR_DamageAoe
            set a = GAngle2( c , x, y ) // Angle Between points
            call MakeSound("war3mapImported\\Hero_Harribel_R")
            set dmg = GetHeroAgi( c , true) * ( HarribelR_DamageAgiBase + ( HarribelR_DamageAgiStep * ( GetUnitAbilityLevel( c , HarribelR_ID) - 1 ) ) )
            set rmax = 1.02
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SetUnitAnimationByIndex( c , 9)
            call SetUnitTimeScale( c , 0.8)
            if MUI_HarribelR == 0 then
                call TimerStart( t_HarribelR, 0.03, true, function thistype.Loop_HarribelR)
            endif
        endmethod

        private static method Loop_HarribelR3 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_HarribelR3
                set this = m_HarribelR3[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                    call MoveEff(e, move, a)
                    if r2>0.0 then 
                    set r2 =0
                    call DecorRemove(c,x,y,200,40)
                    call VisionTimed(GetOwningPlayer(c),GetEffX(e),GetEffY(e),500,1)
                    else
                    set r2 = r2 + 0.03
                    endif
                    set x = GetEffX(e)
                    set y = GetEffY(e)
                    call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                            set r = 99999
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop
                else
                    set x = GetEffX(e)
                    set y = GetEffY(e)
                    call MakeSound("war3mapImported\\Hero_Harribel_R3")
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (171)4_short2.mdl", x, y, 0, 1.5, 0.5, 0))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (171)44.mdl", x, y, 0, 1.5, 0.55, 0))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdl", x, y, 0, 0.5, 1.25, 15))
                    call GroupClear(g)
                    call VisionTimed(GetOwningPlayer(c),x,y,HarribelER_DamageAoeFinal+200,4.5)
                    call GroupEnumUnitsInRange(g, x, y, HarribelER_DamageAoeFinal+25, NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                            call dmgmag(c, u, dmg)
                            call ErzaPassive(c,u,2)
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop
                    call DecorRemove(c,x,y,aoe+25,50)
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.12)
                    call DestroyGroup(g)
                    set g = null
                    set e = null
                    set c = null
                    set m_HarribelR3[i] = m_HarribelR3[ MUI_HarribelR3]
                    set MUI_HarribelR3 = MUI_HarribelR3 - 1
                    if MUI_HarribelR3 == -1 then
                        call PauseTimer( t_HarribelR3)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method HarribelR3_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_HarribelR3 = MUI_HarribelR3 + 1
            set m_HarribelR3[ MUI_HarribelR3] = this
            set c = NewC
            set r = 0
            set x = NewX
            set y = NewY
            set r2 = 0
            set g = CreateGroup()
            set r5 = HarribelER_StunDuration
            set aoe = HarribelER_DamageAoe
            set a = GAngle2( c , x, y ) // Angle Between points
            set dmg = GetHeroAgi( c , true) * ( HarribelER_DamageAgiBase + ( HarribelER_DamageAgiStep * ( GetUnitAbilityLevel( c , HarribelR_ID) - 1 ) ) )
            set e = EffectSpawn("war3mapImported\\wos_az_xiaonajia01_e1.mdx", GetUnitX(c) + 120 * Cos(a), GetUnitY(c) + 120 * Sin(a), a * bj_RADTODEG, 1, 1.85, 130)
            set rmax = 0.42
            set move =( HarribelER_RangeBase + ( HarribelER_RangeStep * ( GetUnitAbilityLevel( c , HarribelR_ID) - 1 ) ) )/ (rmax / 0.03)
            if MUI_HarribelR3 == 0 then
                call TimerStart( t_HarribelR3, 0.03, true, function thistype.Loop_HarribelR3)
            endif
        endmethod

        private static method Loop_HarribelR2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_HarribelR2
                set this = m_HarribelR2[i]
                if SpellBoolCaster(c) and r <= rmax and check < k2 and LoadInteger(hs,GetHandleId(c),StringHash("stop r"))==0 then
                    set r = r + 0.02
                    set r = S2R( R2SW( r , 0, 3 ) )
                    call DebugUnit2(c)
                    set a = GAngle2(c,GetMouseX(GetOwningPlayer(c)),GetMouseY(GetOwningPlayer(c)))
                    call BlzSetUnitFacingEx(c,a*bj_RADTODEG)
                    call BlzSetSpecialEffectPosition(e, GetUnitX(c), GetUnitY(c), 0)
                    call BlzSetSpecialEffectYaw(e, a)
                    if r2 > 0.36 then
                        set r2 = 0
                        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_eff (24).mdx", c, "weapon"))
                        call MakeSound("war3mapImported\\Hero_Harribel_R2")
                        set check = check + 1
                        call HarribelR3_Start(c, GetUnitX(c) + 100 * Cos(a), GetUnitY(c) + 100 * Sin(a))                   
                        call SetUnitAnimationByIndex( c , 0 )
                        call SetUnitTimeScale( c , 1.2)
                    else
                        set r2 = r2 + 0.02
                    endif                     
                else
                    call SaveInteger(hs,GetHandleId(c),StringHash("cast r"),0)
                    call SaveInteger(hs,GetHandleId(c),StringHash("stop r"),0)
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.3)
                    call DestroyEffect(e2)
                    call StopSpellUnit2(c)
                    call MouseOff(GetOwningPlayer(c))
                    set e = null
                    set e2 = null
                    set c = null
                    set m_HarribelR2[i] = m_HarribelR2[ MUI_HarribelR2]
                    set MUI_HarribelR2 = MUI_HarribelR2 - 1
                    if MUI_HarribelR2 == -1 then
                        call PauseTimer( t_HarribelR2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method HarribelR2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_HarribelR2 = MUI_HarribelR2 + 1
            set m_HarribelR2[ MUI_HarribelR2] = this
            set c = NewC
            set r = 0
            set x = NewX
            set y = NewY
            set r3 = 10
            set check = 0
            set k2 =  HarribelER_BulletsNumberBase + ( HarribelER_BulletsNumberStep * ( GetUnitAbilityLevel( c , HarribelR_ID) - 1 ) )
            set r2 = 0
            set a = GAngle2( c , x, y ) // Angle Between points
            call MakeSound("war3mapImported\\Hero_Harribel_ER1")
            set rmax = 10
            call SetUnitFacingTimed(c, a * bj_RADTODEG, 0 )            
            call StartSpellUnit2(c)
            call SetUnitAnimationByIndex( c , 0 )
            call SetUnitTimeScale( c , 1.5)
            call MouseOn(GetOwningPlayer(c))
            call SaveInteger(hs,GetHandleId(c),StringHash("stop r"),0)
            call SaveInteger(hs,GetHandleId(c),StringHash("cast r"),1)
            set MouseX[GetPlayerId(GetOwningPlayer(c))]=x
            set MouseY[GetPlayerId(GetOwningPlayer(c))]=y
            set e = EffectSpawn("war3mapImported\\wos_mr_war3_sxxq3.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.5, 4, 0)
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_papsnaz (971)24.mdx", c, "weapon")
            if MUI_HarribelR2 == 0 then
                call TimerStart( t_HarribelR2, 0.02, true, function thistype.Loop_HarribelR2)
            endif
        endmethod

    endstruct

    private struct HarribelSpells_T
        private static timer t_HarribelT = CreateTimer()
        private static integer array m_HarribelT
        private static integer MUI_HarribelT = -1
        unit c
        real x
        real y
        real r2
        integer k
        real fly
        group g
        unit u
        real dmg
        integer check
        real aoe
        real r
        effect e2
        real a
        real rmax

        private static method Loop_HarribelT takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_HarribelT
                set this = m_HarribelT[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                    call DebugUnit(c)
                    if r == 0.03 then
                        call BlinkEff(c)
                        call BlinkEff2(c)
                        call SetFly(c, 900)
                        call BlinkEff(c)
                        call BlinkEff2(c)
                        set e2 = AddSpecialEffectTarget("war3mapImported\\wos_ChuShou_BY_Wood_yellow_XuLi.mdl", c, "weapon")
                    endif
                    if r == 0.39 or r == 1.5 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (171)4_short2.mdl", x, y, 0, 1.5, 0.5, fly + 200))
                    endif
                    if r == 1.92 then
                        call MakeSound("war3mapImported\\Hero_Harribel_T2")
                        call SetUnitTimeScale(c, 0.22)
                    endif
                    if r == 0.3 then
                    elseif r == 2.64 then
                        call DestroyEffect(e2)
                    endif
                    if r > 1.92 then
                        if r > 2.1 then
                        if r > 2.2 then 
                        call DecorRemove(c,x,y,aoe+100,100)
                        endif
                        set fly = fly - 125
                        endif
                        if fly < 200 then
                            set r = 9999
                        endif
                        if r2 > 0.0 then
                            set r2 = 0
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Eff (134).mdl", x, y, GetRandomReal(0, 359), 0.65, 1, fly))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Eff (134).mdl", x, y, GetRandomReal(0, 359), 0.55, 2, fly))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Eff (134).mdl", x, y, GetRandomReal(0, 359), 0.45, 3, fly))
                            if r > 2.1 then
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_az_xiaonajia01_d_W.mdx", x, y, GetRandomReal(0, 359), 1.5, 2, fly))
                            endif
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    call MakeSound("war3mapImported\\Hero_Harribel_T3")
                    set k = 0
                    call DestroyEffect(e2)
                    loop
                        exitwhen k > 3
                        if k < 4 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdx", x, y, GetRandomReal(0, 359), 1 - 0.2 * k, 1 + k, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Eff (134).mdl", x, y, GetRandomReal(0, 359), 0.55, 3, fly))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_az_xiaonajia01_d_W.mdx", x, y, GetRandomReal(0, 359), 0.4, 3 + k, 75))
                        endif
                        set k = k + 1
                    endloop
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_slardar(hclz)_r.mdx", x, y, GetRandomReal(0, 359), 1, 3.15, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_LD2209 (129).mdx", x, y, GetRandomReal(0, 359), 1, 7.15, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (171)4_short2.mdl", x, y, 0, 1.5, 1.35, 0))
                    call GroupClear(g)
                    call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                call dmgmag(c, u, dmg)
                                call ErzaPassive(c,u,2)
                                call StunUnit(c,u,HarribelT_Stun)
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop
                    call StopSpellUnit(c)
                    call SetUnitAnimation(c, "stand")
                    call BlinkEff(c)
                        call BlinkEff2(c)
                    call SetFly(c, 0)
                    call BlinkEff(c)
                    if check == 1 then 
                     call BlzSetUnitSkin(c, Harribel_ID)
                    endif
                    call SetUnitTimeScale( c , 1)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set e2 = null
                    set m_HarribelT[i] = m_HarribelT[ MUI_HarribelT]
                    set MUI_HarribelT = MUI_HarribelT - 1
                    if MUI_HarribelT == -1 then
                        call PauseTimer( t_HarribelT)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method HarribelT_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_HarribelT = MUI_HarribelT + 1
            set m_HarribelT[ MUI_HarribelT] = this
            set c = NewC
            set r = 0
            set x = NewX
            set y = NewY
            set check = 0
            set r2 = 10
            set g = CreateGroup()
            call StartSpellUnit(c)
            set aoe = HarribelT_DamageAoe
            set a = GAngle2( c , x, y ) // Angle Between points
            call MakeSound("war3mapImported\\Hero_Harribel_T")
            set dmg = GetHeroAgi( c , true) * HarribelT_DamageAgiBase
            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e")) == 0 then 
            set check = 1
             call BlzSetUnitSkin(c, Harribel_Morph_ID)
            endif
            set rmax = 8.02
            set fly = 1600
            
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SetUnitAnimationByIndex( c , 6)
            call SetUnitTimeScale( c , 0.1)
            call VisionTimed(GetOwningPlayer(c),x,y,aoe*1.3,rmax)
            if MUI_HarribelT == 0 then
                call TimerStart( t_HarribelT, 0.03, true, function thistype.Loop_HarribelT)
            endif
        endmethod

    endstruct

    private struct HarribelSpells_G
        private static timer t_HarribelG = CreateTimer()
        private static integer array m_HarribelG
        private static integer MUI_HarribelG = -1
        unit c
        unit td
        real r2
        integer k2
        real r3
        real r4
        real r5
        group g
        real dmg
        integer check
        real r
        framehandle array frame_pas1 [10]
        framehandle array frame_pas2 [10]
        framehandle array frame_pas3 [10]
        framehandle array frame_pas4 [10]
        framehandle array frame_pas5 [10]
        framehandle array frame_pas6 [10]

        private static method Loop_HarribelG takes nothing returns nothing
            local integer this
            local integer i = 0
            local real extraSpeed = 0
            loop
                exitwhen i > MUI_HarribelG
                set this = m_HarribelG[i]
                if check == GetUnitTypeId(c) then
                    if GetHeroLevel(c) >= 35 then
                        set r4 = 3000
                    elseif GetHeroLevel(c) >= 25 then
                        set r4 = 2000
                    else
                        set r4 = 1000
                    endif
                    set r5 = 0
                    set r3 =LoadReal(hs, GetHandleId(c), StringHash("dmg count"))  
                    if CheckCoordsInRect(gg_rct_Base,GetUnitX(c),GetUnitY(c)) then 
                    call SaveReal(hs, GetHandleId(c), StringHash("dmg count"), 0)
                    endif
                    if r3>= 1000 then 
                    call UnitAddAbility(c,'A0AZ')
                    call SaveInteger(hs,GetHandleId(c),StringHash("hari g 1"),1)
                    else
                    call UnitRemoveAbility(c,'A0AZ')
                    call SaveInteger(hs,GetHandleId(c),StringHash("hari g 1"),0)
                    endif
                    if r3>= 2000 and GetHeroLevel(c)>=25 then 
                    call SaveInteger(hs,GetHandleId(c),StringHash("hari g 2"),1)
                    else
                    call SaveInteger(hs,GetHandleId(c),StringHash("hari g 2"),0)
                    endif
                    if r3>= 3000 and GetHeroLevel(c)>=35 then 
                    call UnitAddAbility(c,'A0B0')
                    if IntegerCd(c,"cd sound",60) then 
                    call MakeSound("war3mapimported\\Hero_Harribel_G3")
                    endif
                    call SaveInteger(hs,GetHandleId(c),StringHash("hari g 3"),1)
                    else
                    call UnitRemoveAbility(c,'A0B0')
                    call SaveInteger(hs,GetHandleId(c),StringHash("hari g 3"),0)
                    endif
                    if r3>r4 then
                    set r3 = r4
                    call SaveReal(hs, GetHandleId(c), StringHash("dmg count"), r3)
                    endif
                    call BlzFrameSetValue(frame_pas3[k2], r3)
                    call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + I2S(R2I(r3))+"/"+I2S(R2I(r4)) + "|r")
                else
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame_pas1[k2], false)
                    endif
                    set c = null
                    set m_HarribelG[i] = m_HarribelG[MUI_HarribelG]
                    set MUI_HarribelG = MUI_HarribelG - 1
                    if MUI_HarribelG == -1 then
                        call PauseTimer(t_HarribelG)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method HarribelG_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_HarribelG = MUI_HarribelG + 1
            set m_HarribelG[MUI_HarribelG] = this
            set c = NewC
            set td = null
            set check = GetUnitTypeId(c)
            set r = 0
            set r2 = 0
            set k2 = GetPlayerId(GetOwningPlayer(c))
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
                call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, 3000+50)
                call BlzFrameSetValue(frame_pas3[k2], 0)
                set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18)
                call BlzFrameSetSize(frame_pas4[k2], 0.03, 0.03)
                call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Harribel_G", 0, false)
                set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Sacrifice:" + "|r")
                call BlzFrameSetScale(frame_pas5[k2], 0.9)
                set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17)
                call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                call BlzFrameSetScale(frame_pas6[k2], 0.9)
            else
                if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frame_pas1[k2], true)
                endif
                call BlzFrameSetValue(frame_pas3[k2], 0)
            endif
            if MUI_HarribelG == 0 then
                call TimerStart(t_HarribelG, 0.1, true, function thistype.Loop_HarribelG)
            endif
        endmethod

    endstruct

    //----------------------------Harribel-----------------------------------------------
     /* Animations index:
    Base:
    0 - stand
    1 - multiple atk
    2 - atk from air to earth
    3 - atk from self
    4 - fast 2x atk
    5 - fast round atk
    6 - morph need to stop after 0.5
    7 - slow move and atk around
    9 - move
    10 - normal round atk + pierce
    11 - charge
    12 - fast atk for 4 ways
    13 - cero
    14 - after sonido
    
    Morph:
    0 - perce atk (W and R)
    1 - round fast atk
    2 - push away sword at air (Cero Q)
    4 - move
    5 - stand
    6 - cascada throw
    
    
    
     */ 
    

    function HarribelQ_Start takes unit c, real x, real y returns nothing
        call HarribelSpells_Q.HarribelQ_Start( c, x, y )
    endfunction
    function HarribelW_Start takes unit c, unit td returns nothing
        call HarribelSpells_W.HarribelW_Start( c, td )
    endfunction
    function HarribelE_Start takes unit c returns nothing
        if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e")) == 0 then
            call HarribelSpells_E.HarribelE_Start( c)
        endif
    endfunction
    function HarribelE2_Start takes unit c returns nothing
            call HarribelSpells_E.HarribelE2_Start( c)
    endfunction
    function HarribelR_Start takes unit c returns nothing
        call HarribelSpells_R.HarribelR_Start( c )
    endfunction
    function HarribelR2_Start takes unit c , real x, real y returns nothing
        call HarribelSpells_R.HarribelR2_Start( c, x, y )
    endfunction
    function HarribelT_Start takes unit c, real x, real y returns nothing
        call HarribelSpells_T.HarribelT_Start( c , x, y)
    endfunction
    function HarribelG_Start takes unit c returns nothing
        call HarribelSpells_G.HarribelG_Start( c )
    endfunction
     function HarribelG2_Start takes unit c,real dmg returns nothing
        local group g = CreateGroup()
        local unit u
        local real x = GetUnitX(c)
        local real y = GetUnitY(c)
        local real aoe = 3500
        local real r
        call GroupClear( g )
        call GroupEnumUnitsInRange( g , x , y , aoe , null)
        loop
            set u = FirstOfGroup( g )
            exitwhen u == null
            if IsUnitAlly(u, GetOwningPlayer(c)) and GetWidgetLife(u)>1 and IsUnitIllusion(u) == false and GetUnitTypeId(u) == Harribel_ID and GetHeroLevel(u)>= 12 then
            set r = LoadReal(hs, GetHandleId(u), StringHash("dmg count"))
            call SaveReal(hs, GetHandleId(u), StringHash("dmg count"), r+(dmg*0.1))
            endif
            call GroupRemoveUnit( g , u )
        endloop
        call DestroyGroup(g)
        set g = null
        set u = null
    endfunction
    function HarribelPas takes unit c returns nothing
        local real heal 
        local real r
        local real lvl = GetHeroLevel(c)
        if lvl>= 35 then 
        set r= Harribel_Pas_RestoreHp3/100
        elseif lvl>= 25 then 
        set r= Harribel_Pas_RestoreHp2/100
        elseif lvl>= 12 then 
        set r= Harribel_Pas_RestoreHp1/100
        endif
        if GetHeroLevel(c)>=12 and IsUnitType(c,UNIT_TYPE_DEAD) then 
        set heal = r * GetUnitState(c, UNIT_STATE_MAX_LIFE)
        call SetHpCurrent2(c,c, heal)
        call EUTU2(EffectSpawn("war3mapImported\\wos_effect_lv131.mdl", GetUnitX(c), GetUnitY(c), 1, 1, 1, 40), 0.6, 40, c)
        call MakeSound("war3mapImported\\Hero_Harribel_G2")
       endif
    endfunction  
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
