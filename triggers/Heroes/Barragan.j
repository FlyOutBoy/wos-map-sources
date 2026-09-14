library BarraganSpells uses GearSystems
    globals
//--------------------------------------Barragan--------------------------------------------------------------
        integer Barragan_ID = 'H01R'
        integer Barragan2_ID = 'H01S'
//---------------Q ability-----------------------------------------------------
        integer BarraganQ_ID = 'A0B1'
        real BarraganQ_DamageIntBase = 1 // base number x STR damage for 1 level
        real BarraganQ_DamageIntStep = 1 // additional number x STR damage for each next level
        real BarraganQ_Damage2StaticBase = 150 // base static damage for 1 level
        real BarraganQ_Damage2StaticStep = 0 // additional static damage for each next level
        real BarraganQ_DamageAoe = 320
        real BarraganQ_RangeBase = 1300
        real BarraganQ_RangeStep = 75
        real BarraganEQ_RangeAdd = 250
        real BarraganETQ_Stun = 0.5
        real BarraganQ_DamageMorphIntImprove = 1 // additional str damage to morph ability variation
        real BarraganQ_DamageTIntImprove = 1 // additional str damage to morph ability variation from T
//---------------W ability-----------------------------------------------------
        integer BarraganW_ID = 'A0B2'
        real BarraganW_DamageIntBase = 1 // base number x STR damage for 1 level
        real BarraganW_DamageIntStep = 1 // additional number x STR damage for each next level , count as x4 at max level
        real BarraganW_Damage2StaticBase = 175 // base static damage for 1 level
        real BarraganW_Damage2StaticStep = 0 // additional static damage for each next level
        real BarraganW_StunDuration = 0 // additional static damage for each next level
        real BarraganW_DamageAoe = 600
        real BarraganW_BaseRange = 1200
        real BarraganW_MorphRange = 1500
        integer BarraganW_Slow = 40
        integer BarraganW_SlowDuration = 2
        real BarraganW_DamageMorphIntImprove = 1 // additional to basic + step str ability damage to morph ability variation
//---------------W2 ability-----------------------------------------------------
        integer BarraganW2_ID = 'A0B7'
        real BarraganW2_DamageIntBase = 3 // base number x STR damage for 1 level
        real BarraganW2_Damage2StaticBase = 0 // base static damage for 1 level
        real BarraganW2_DamageAoe = 725
        integer BarraganW2_LevelGain = 15 // write here a number of level afther reaching that he would take a W2 ability after W cast
//---------------E ability-----------------------------------------------------
        integer BarraganE_ID = 'A0B3'
        real BarraganE_ReduceR_CD = 15
        real BarraganE_DamageAoe = 750 // write aoe where passive would be caused each second
        integer BarraganE_IdDummy = 'h00E'
        integer BarraganE_Def_ID = 'A0B9'
        integer BarraganE_HP_Base = 200 // give + 100 hp when in armor at 1 lvl
        integer BarraganE_HP_Step = 200 // give + 100 hp when in armor for each next lvl
        real BarraganE_DurationBase = 12 // in seconds , how long clone would live 10 = 10 sec
        real BarraganE_DurationStep = 2 // in seconds , how much time added with next level
//---------------E2 ability-----------------------------------------------------
        integer BarraganE2_ID = 'A0BG'
        real BarraganE2_DamageAoe = 600 // write aoe where passive would be caused each second
        real BarraganE2_DamageIntBase = 4 // base number x STR damage for 1 level
        real BarraganE2_DamageIntBaseTAdd = 3
        real BarraganE2T_Stun = 0.5 
//---------------R ability-----------------------------------------------------
        integer BarraganR_ID = 'A0B4'
        real BarraganR_DamageIntBase = 5 // base number x STR damage for 1 level dmg per sec
        real BarraganR_DamageIntStep = 1 // additional number x STR damage for each next level dmg per sec
        real BarraganR_Damage2StaticBase = 0 // base static damage for 1 level dmg per sec
        real BarraganR_Damage2StaticStep = 0 // additional static damage for each next level dmg per sec
        real BarraganR_DamageAoe = 925
        integer BarraganR_Slow = 40
        integer BarraganR_SlowDuration = 2
        real BarraganR_DamageInvulBase = 1
        real BarraganR_DamageInvulStep = 0
        real BarraganR_ManaRestore = 15 // % of max
        real BarraganER_DamageAoe = 1125
        real BarraganER_DamageIntBase = 6 // base number x STR , damage that would be dealt for whole time
        real BarraganER_DamageIntStep = 1 // additional number x STR damage for each next level dmg per sec
        real BarraganER_Damage2StaticBase = 0 // base static damage for 1 level dmg per sec
        real BarraganER_Damage2StaticStep = 0
        real BarraganER_DamageDuration = 4 // duration in seconds of passive burning
        real BarraganER_DamagePeriodic = 1
//---------------T ability-----------------------------------------------------
        integer BarraganT_ID = 'A0B5'
        integer BarraganT_IdDummy = 'h01T'
        unit BarraganT_Dummy
        integer BarraganT2_ID = 'A0B6'
        real BarraganT_Duration = 15 // base number x STR damage
        real BarraganT_AtkDmg = 1.5 // base number x STR damage
        real BarraganT2_DamageIntBase = 10 // base number x STR damage
        real BarraganT2_Damage2StaticBase = 0 // base static damage
        real BarraganT2_DamageAoe = 400
        real BarraganT2_Range = 2500
        real BarraganT2_StunDuration = 2 // from 0.1 to 3.0
//---------------G ability-----------------------------------------------------
        integer BarraganG_ID = 'A0B8'
        integer BarraganG2_ID = 'A0BD'
        integer BarraganG3_ID = 'A0BE'
        integer BarraganG4_ID = 'A0BF'
        real BarraganG_DamageIntBase = 2 // base number x STR , damage that would be dealt for whole time
        real BarraganG_Damage2Static_6 = 30 // base static damage, damage that would be dealt for whole time
        real BarraganG_Damage2Static_25 = 40 // base static damage, damage that would be dealt for whole time
        real BarraganG_Damage2Static_35 = 50 // base static damage, damage that would be dealt for whole time
        real BarraganG_DamageDuration = 3 // duration in seconds of passive burning
        real BarraganG_DamagePeriodic = 0.5 // set time to periodic damage per seconds, example: 0.5 - passive will dealt damage 6 times, if duration 3 and this 0.5 each second target take damage 2 times, if this 0.25 - 4 times and total damage times increase to 12
        integer BarraganG_AbilityEnchantLevelGain = 35 // write here a number of level afther reaching that he would add a 1x stack of passive burning to his Q and W
//----------------------------------------------------------------------------------------------------------------------------- 
    endglobals
    function BarraganPassiveBurn takes unit c, unit td returns nothing
    local real dmg = 0
    if GetHeroLevel(c) >= 35 then 
    set dmg = BarraganG_Damage2Static_35
    elseif GetHeroLevel(c) >= 25 then
    set dmg = BarraganG_Damage2Static_25
    else
    set dmg = BarraganG_Damage2Static_6
    endif
    set dmg = dmg + (GetHeroInt(c, true) * BarraganG_DamageIntBase)
        call DmgPTime(c, td,dmg, BarraganG_DamageDuration, BarraganG_DamagePeriodic, 1)
        call EffectSpawnTarget("war3mapImported\\wos_zz-fire-ore-hit1-zihei_2.mdx", td, "origin", GetRandomReal(0, 359), 1.15, 2, 0, BarraganG_DamageDuration)
    endfunction
    
    private struct HeroSpells_Q
        private static timer t_BarraganQ = CreateTimer()
        private static integer array m_BarraganQ
        private static integer MUI_BarraganQ = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        real r7
        integer k
        integer k2
        real scale
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
        real a
        real rmax

        private static method Loop_BarraganQ takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_BarraganQ
                set this = m_BarraganQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if k2 == 0 then // 0 - normal spell, 1 - morph spell, 2( only for q) enchaned with T morph spell
                        if check == 0 then
                            if r >= 0.57 then
                                call StopSpellUnit2(c)
                                call DestroyEffect(e2)
                                set check = 1
                                call MakeSound("war3mapimported\\Hero_Barragan_Q2")
                                set x1 = (GetUnitX( c ) + 20 * Cos(a + 90 * bj_DEGTORAD)) + 79 * Cos( a )
                                set y1 = (GetUnitY( c ) + 20 * Sin(a + 90 * bj_DEGTORAD)) + 79 * Sin( a )
                                set move = 0
                                set scale = 0.5
                                set rmax = 1.5
                                set r = 0
                                set r7 = 0
                            endif
                        elseif check == 1 then
                           
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
                                call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx" , x , y , a * bj_RADTODEG , 1 , scale , 180 + r * 80 , 0.51 , 255 , 25 , 25 , 255)
                                call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx" , x , y , a * bj_RADTODEG , 1 , scale * 0.7 , 180 + r * 80 , 0.45 , 225 , 225 , 225 , 205)
                                
                                set scale = scale + 0.3
                                set k = k + 1
                            endloop
                            set r7 = r7 + move
                            if move > r5 then
                                set r = 999
                            endif
                            if r6 >= 0.0 then
                                set r6 = 0
                                call VisionTimed(GetOwningPlayer(c), x + r2 * Cos(a), y + r2 * Sin(a), 650, 2)
                                call DecorRemove(c, x + r2 * Cos(a), y + r2 * Sin(a), aoe, 25)
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
                            if r >= 0.51 then
                                call StopSpellUnit2(c)
                                call DestroyEffect(e2)
                                set check = 1
                                call MakeSound("war3mapimported\\Hero_Barragan_EQ3")
                                set x1 = (GetUnitX( c )) + 150 * Cos( a )
                                set y1 = (GetUnitY( c )) + 150 * Sin( a )
                                set e = EffectSpawn3("war3mapimported\\wos_zz-shio_zk_zz_stab2_hy-1.mdl", x1, y1, a * bj_RADTODEG, 0.55, 0.65, 175, 0)
                                set x = GetEffX(e)
                                set y = GetEffY(e)
                                set move = 70
                                set r4 = 0
                                set r2 = 0
                                set rmax = 1.2
                                set r3 = 0
                                set r7 = 0
                                set r = 0
                            endif
                        elseif check == 1 then
                            if PathableCheck(x1 + move * Cos( a ), y1 + move * Sin( a )) then
                                set r2 = r2 + move
                            endif
                            set r7 = r7 + move
                            if r7 > r5 then
                                set r = 999
                            endif
                            if r6 >= 0.03 then
                                set r6 = 0
                                call VisionTimed(GetOwningPlayer(c), x + r2 * Cos(a), y + r2 * Sin(a), 800, 2)
                                call DecorRemove(c, x + (r2) * Cos(a), y + (r2) * Sin(a), aoe, 50)
                            else
                                set r6 = r6 + 0.03
                            endif
                            call BlzSetSpecialEffectPosition(e, x + r2 * Cos(a), y + r2 * Sin(a), 175)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x + r2 * Cos(a), y + r2 * Sin(a), aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u, g2) == false then
                                    call dmgmag(c, u, dmg)
                                    call GroupAddUnit(g2, u)
                                    if GetHeroLevel(c) >= BarraganG_AbilityEnchantLevelGain then
                                        call BarraganPassiveBurn(c, u)
                                    endif
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            if r3 > 0.11 then
                                set r3 = 0
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_saberalterqcpurple.mdl", x + r2 * Cos(a), y + r2 * Sin(a), GetRandomReal(0, 359), 0.75, 2.75, 0))
                            else
                                set r3 = r3 + 0.03
                            endif
                            if r4 > 0.18 then
                                set r4 = 0
                                call EffectSpawn2("war3mapimported\\wos_zz-shio_zk_zz_stab2_hy-1.mdl", x + r2 * Cos(a), y + r2 * Sin(a), GetRandomReal(0, 359), 0.55, 0.65, 175, 0.25)
                            else
                                set r4 = r4 + 0.03
                            endif
                        endif
                    elseif k2 == 2 then
                        if check == 0 then
                            if r >= 0.51 then
                                call StopSpellUnit2(c)
                                call DestroyEffect(e2)
                                set check = 1
                                call MakeSound("war3mapimported\\Hero_Barragan_EQ3")
                                set x1 = (GetUnitX( c )) + 150 * Cos( a )
                                set y1 = (GetUnitY( c )) + 150 * Sin( a )
                                set e = EffectSpawn("war3mapimported\\wos_BDEF (202) 90_black237.mdl", x1, y1, a * bj_RADTODEG, 0.55, 2.25, 175)
                                call BlzSetSpecialEffectColor(e, 0, 0, 0)
                                call BlzSetSpecialEffectRoll(e, -90 * bj_DEGTORAD)
                                set x = GetEffX(e)
                                set y = GetEffY(e)
                                set move = 140
                                set r4 = 0
                                set r2 = 0
                                set rmax = 0.66
                                set r3 = 0
                                set r = 0
                            endif
                        elseif check == 1 then
                            if PathableCheck(x1 + move * Cos( a ), y1 + move * Sin( a )) then
                                set r2 = r2 + move
                            endif
                            set r7 = r7 + move
                            if r7 > r5 then
                                set r = 999
                            endif
                            if r6 >= 0.03 then
                                set r6 = 0
                                call DecorRemove(c, x + (r2 + 100) * Cos(a), y + (r2 + 100) * Sin(a), aoe, 100)
                                call VisionTimed(GetOwningPlayer(c), x + (r2 + 100) * Cos(a), y + (r2 + 100) * Sin(a), 900, 2)
                            else
                                set r6 = r6 + 0.03
                            endif
                            call BlzSetSpecialEffectPosition(e, x + r2 * Cos(a), y + r2 * Sin(a), 175)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x + r2 * Cos(a), y + r2 * Sin(a), aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u, g2) == false then
                                    call dmgmag(c, u, dmg)
                                    call GroupAddUnit(g2, u)
                                    call StunUnit(c, u, BarraganETQ_Stun)
                                    if GetHeroLevel(c) >= BarraganG_AbilityEnchantLevelGain then
                                        call BarraganPassiveBurn(c, u)
                                    endif
                                    call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_Ldeff (262)", u, "chest"))
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            if r3 > 0.06 then
                                set r3 = 0
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_saberalterqcpurple.mdl", x + r2 * Cos(a), y + r2 * Sin(a), GetRandomReal(0, 359), 0.75, 2.75, 0))
                            else
                                set r3 = r3 + 0.03
                            endif
                            if r4 > 0.06 then
                                set r4 = 0
                                call EffectSpawn2("war3mapimported\\wos_zz-shio_zk_zz_stab2_hy-1.mdl", x + r2 * Cos(a), y + r2 * Sin(a), GetRandomReal(0, 359), 0.55, 0.65, 175, 0.15)
                            else
                                set r4 = r4 + 0.03
                            endif
                        endif
                    endif
                else
                    call DestroyEffect( e )
                    call DestroyEffect( e2 )
                    call SetUnitTimeScale( c , 1)
                    if r <= 0.57 - 0.06 * k2 then
                        call StopSpellUnit2(c)
                    endif
                    if k2 == 2 then                     
                        call StopSpellUnit(c)
                    endif
                    call DestroyGroup( g )
                    set g = null
                    call DestroyGroup( g2 )
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_BarraganQ[i] = m_BarraganQ[ MUI_BarraganQ]
                    set MUI_BarraganQ = MUI_BarraganQ - 1
                    if MUI_BarraganQ == -1 then
                        call PauseTimer( t_BarraganQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BarraganQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_BarraganQ = MUI_BarraganQ + 1
            set m_BarraganQ[ MUI_BarraganQ] = this
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
            set scale = 1.2
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set check = 0
            set r5 = BarraganQ_RangeBase + ( BarraganQ_RangeStep * ( GetUnitAbilityLevel( c , BarraganQ_ID) - 1 ) )
            set aoe = BarraganQ_DamageAoe
            set dmg = GetHeroInt( c , true) * ( BarraganQ_DamageIntBase + ( BarraganQ_DamageIntStep * ( GetUnitAbilityLevel( c , BarraganQ_ID) - 1 ) ) )
            set dmg = dmg + BarraganQ_Damage2StaticBase + ( BarraganQ_Damage2StaticStep * ( GetUnitAbilityLevel( c , BarraganQ_ID) - 1 ) )
            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e")) != 0 then
                set dmg = dmg + (GetHeroInt( c , true) * BarraganQ_DamageMorphIntImprove)
                set r5 = r5 + BarraganEQ_RangeAdd
                if LoadInteger(hs, GetHandleId(c), StringHash("barragan t")) > 0 then// T ability add dmg
                    set dmg = dmg + (GetHeroInt( c , true) * BarraganQ_DamageTIntImprove)
                endif
            endif
            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e")) == 0 then
                set k2 = 0
                set e2 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", c, "hand left")
                call SetUnitFacing( c , a * bj_RADTODEG)
                set rmax = 3
                call SetUnitTimeScale( c , 0.75)
                call SetUnitAnimationByIndex( c , 12)
                if GetRandomInt(1, 2) == 1 then
                    call MakeSound("war3mapimported\\Hero_Barragan_Q")
                else
                    call MakeSound("war3mapimported\\Hero_Barragan_Q 2")
                endif
            elseif LoadInteger(hs, GetHandleId(c), StringHash("barragan t")) == 0 then
                set e2 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiPurple.mdx", c, "hand left")
                set k2 = 1
                set rmax = 0.6
                call SetUnitTimeScale( c , 1.75)
                call SetUnitAnimationByIndex( c , 4)
                if GetRandomInt(1, 2) == 1 then
                    call MakeSound("war3mapimported\\Hero_Barragan_EQ")
                else
                    call MakeSound("war3mapimported\\Hero_Barragan_EQ2")
                endif
            else
                set e2 = AddSpecialEffectTarget("war3mapimported\\wos_m3 (704).mdx", c, "weapon")
                set k2 = 2
                set rmax = 3
            call StartSpellUnit(c)
                call SetUnitTimeScale( c , 0.75)
                call SetUnitAnimationByIndex( c , 9)
                if GetRandomInt(1, 2) == 1 then
                    call MakeSound("war3mapimported\\Hero_Barragan_ETQ")
                else
                    call MakeSound("war3mapimported\\Hero_Barragan_ETQ2")
                endif
                call MakeSound("war3mapimported\\Hero_Barragan_ET2 2")
            endif
            if MUI_BarraganQ == 0 then
                call TimerStart( t_BarraganQ, 0.03, true, function thistype.Loop_BarraganQ)
            endif
        endmethod

    endstruct

    private struct HeroSpells_W
        private static timer t_BarraganW = CreateTimer()
        private static integer array m_BarraganW
        private static integer MUI_BarraganW = -1
        private static timer t_BarraganW2 = CreateTimer()
        private static integer array m_BarraganW2
        private static integer MUI_BarraganW2 = -1
        unit c
        real x
        real y
        real r2
        effect array ee [15]
        integer k
        integer k2
        real r6
        group g
        unit u
        real fly
        real dmg
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_BarraganW takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_BarraganW
                set this = m_BarraganW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if k2 == 0 then
                        call DebugUnit2(c)
                        if r == 0.18 then
                            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", c, "weapon")
                        endif
                        if r == 0.45 then
                            call BlinkEff(c)
                            call BlinkEff2(c)
                            call SetUnitPosition(c, x - 180 * Cos(a), y - 180 * Sin(a))
                            call BlinkEff(c)
                        endif
                        if r == rmax then
                            call MakeSound("war3mapimported\\Hero_Barragan_W2")
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZarakiWCrack1.mdx", x, y, GetRandomReal(0, 359), 1.25, 1.5, 0))
                            set k = 0
                            loop
                                exitwhen k > 4
                                call EffectSpawn2("war3mapimported\\wos_LD2209 (157).mdx", x, y, GetRandomReal(0, 359), 1 - k * 0.2, 1 + k * 0.5, 0, 1.25)
                                call EffectSpawn2("war3mapimported\\wos_kamni.mdx", x, y, GetRandomReal(0, 359), 1.25 - k * 0.1, 0.7 + k * 0.35, 0, 0.35)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_dustgaraa2.mdx", x, y, GetRandomReal(0, 359), 1.5 - k * 0.1, 1.9 + k * 0.42, 0))
                                set k = k + 1
                            endloop
                            
                            call DecorRemove(c, x, y, aoe, 40)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call dmgphys(c, u, dmg)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            call DestroyGroup(g)
                            if GetUnitAbilityLevel(c, BarraganW_ID) >= 5 then
                            
                            call MyFrame(c,4,"BTNHero_Barragan_W2",false,0)
                                call SwapAbility(c, 4, BarraganW2_ID, BarraganW_ID)
                            endif
                        endif
                    else // morph ability
                        if r < 0.36 then
                            call DebugUnit2(c)
                        endif
                        if r == 0.51 then
                            call StopSpellUnit2(c)
                            call DestroyEffect(e2)
                            set ee[0] = EffectSpawn("war3mapImported\\wos_zz-fire-ore-hit1-zihei_big4.mdx", GetUnitX(c) + 200 * Cos(a + 45 * bj_DEGTORAD), GetUnitY(c) + 200 * Sin(a + 45 * bj_DEGTORAD), GetRandomReal(0, 359), 1, 0.65, 165)
                            set ee[1] = EffectSpawn("war3mapImported\\wos_zz-fire-ore-hit1-zihei_big4.mdx", GetUnitX(c) + 200 * Cos(a - 45 * bj_DEGTORAD), GetUnitY(c) + 200 * Sin(a - 45 * bj_DEGTORAD), GetRandomReal(0, 359), 1, 0.65, 165)
                        endif
                        if r >= 0.51 then
                            set a = GAngle5(ee[0], x, y)
                            call MoveEff(ee[0], move, a + 55 * bj_DEGTORAD)
                            set a = GAngle5(ee[1], x, y)
                            call MoveEff(ee[1], move, a - 55 * bj_DEGTORAD)
                            if r6 >= 0.06 then
                                set r6 = 0
                                call VisionTimed(GetOwningPlayer(c), GetEffX(ee[0]), GetEffY(ee[0]), 775, 1.75)
                                call VisionTimed(GetOwningPlayer(c), GetEffX(ee[1]), GetEffY(ee[1]), 775, 1.75)
                            else
                                set r6 = r6 + 0.03
                            endif
                            if r >= 0.75 then
                                call BlzSetSpecialEffectHeight(ee[0], BlzGetLocalSpecialEffectZ(ee[0]) - fly)
                                call BlzSetSpecialEffectHeight(ee[1], BlzGetLocalSpecialEffectZ(ee[0]) - fly)
                            else
                                call BlzSetSpecialEffectHeight(ee[0], BlzGetLocalSpecialEffectZ(ee[0]) + fly)
                                call BlzSetSpecialEffectHeight(ee[1], BlzGetLocalSpecialEffectZ(ee[0]) + fly)
                            endif
                        endif
                        if r == rmax then
                            set r = 99999
                            call DecorRemove(c, x, y, aoe, 80)
                            call VisionTimed(GetOwningPlayer(c), x, y, 1075, 1.75)
                            call EffectSpawn2("war3mapimported\\wos_zz-shio_zk_zz_stab2_hy-1.mdl", x, y, GetRandomReal(0, 359), 0.55, 2, 0, 0.35)
                            call MakeSound("war3mapimported\\Hero_Barragan_EW4")
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_by_wood_effect_order_dange_yueyun_2withoutpurple3.mdx", x, y, GetRandomReal(0, 359), 0.45, 1.45, 0))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPM (513)purple.mdx", x, y, GetRandomReal(0, 359), 1, 1, 0))
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call dmgmag(c, u, dmg)
                                    call SlowUnit(c, u, BarraganW_Slow, BarraganW_SlowDuration)
                                    if GetHeroLevel(c) >= BarraganG_AbilityEnchantLevelGain then
                                        call BarraganPassiveBurn(c, u)
                                    endif
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            call DestroyGroup(g)
                        endif
                    endif
                else
                    if k2 == 1 then
                        call DestroyEffect(ee[0])
                        call DestroyEffect(ee[1])
                        set ee[0] = null
                        set ee[1] = null
                    endif
                    call StopSpellUnit2(c)
                    call SetUnitTimeScale( c, 1 )
                    if k2 == 0 or r < 0.36 then
                        call PauseUnit(c, false)
                    endif
                    call DestroyEffect(e2)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set u = null
                    set e2 = null
                    set m_BarraganW[i] = m_BarraganW[MUI_BarraganW]
                    set MUI_BarraganW = MUI_BarraganW - 1
                    if MUI_BarraganW == -1 then
                        call PauseTimer( t_BarraganW )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BarraganW_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_BarraganW = MUI_BarraganW + 1
            set m_BarraganW[MUI_BarraganW] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set a = GAngle2(c, x, y) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = BarraganW_DamageAoe
            set dmg = GetHeroInt(c, true) * (BarraganW_DamageIntBase + (BarraganW_DamageIntStep * (GetUnitAbilityLevel(c, BarraganW_ID) - 1)))
            set dmg = dmg + BarraganW_Damage2StaticBase + ( BarraganW_Damage2StaticStep * ( GetUnitAbilityLevel( c , BarraganW_ID) - 1 ) )
            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e")) != 0 then
                set dmg = dmg + (GetHeroInt( c , true) * BarraganW_DamageMorphIntImprove)
            endif
            call SetUnitFacing( c , a * bj_RADTODEG)
            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e")) == 0 then
                set k2 = 0
                set rmax = 0.69
                call SetUnitTimeScale(c, 0.475)
                call SetUnitAnimationByIndex(c, 10)
                call MakeSound("war3mapimported\\Hero_Barragan_W")
            else
                set e2 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiPurple.mdx", c, "hand right")
                set k2 = 1
                set rmax = 1.02
                set move = SR3(c, x, y) / 15
                set fly = 950// max height of W morph Sfx
                set fly = fly / 17
                call SetUnitTimeScale( c , 2)
                call SetUnitAnimationByIndex( c , 6)
                if GetRandomInt(1, 2) == 1 then
                    call MakeSound("war3mapimported\\Hero_Barragan_EW")
                else
                    call MakeSound("war3mapimported\\Hero_Barragan_EW2")
                endif
                call MakeSound("war3mapimported\\Hero_Barragan_EW3")
            endif
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(BarraganW_ID)), 0)
            if MUI_BarraganW == 0 then
                call TimerStart( t_BarraganW, 0.03, true, function thistype.Loop_BarraganW )
            endif
        endmethod

        private static method Loop_BarraganW2 takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_BarraganW2
                set this = m_BarraganW2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    call DebugUnit(c)
                    set r = r + 0.03
                    if r == rmax - 0.21 then
                        call MakeSound("war3mapimported\\Hero_Barragan_W2 1")
                    endif
                    if r == rmax then
                        call VisionTimed(GetOwningPlayer(c), x, y, 1400, 1.25)
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_BY_Wood_Eff_Ord_DanGe_Wav_Kuosan_1_3_0.5s.mdx", x, y, GetRandomReal(0, 359), 1.0, 1.1, 125, 255, 255, 255, 65))
                        set k = 0
                        loop
                            exitwhen k > 6
                            if k < 3 then
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_acg_bbb.mdx", x, y, GetRandomReal(0, 359), 1.75 - k * 0.2, 1 + k * 0.7, 120, 255, 165, 165, 165))
                            endif
                            if k < 4 then
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_animeslashfinalanother.mdx", x - 150 * Cos(k * 90 * bj_DEGTORAD), y - 150 * Sin(k * 90 * bj_DEGTORAD), k * 90, 0.4, 4.5, 175, 255, 255, 255, 205))
                            endif
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_chongfeng2.mdx", x - 150 * Cos(k * 60 * bj_DEGTORAD), y - 150 * Sin(k * 60 * bj_DEGTORAD), k * 60, 0.8, 4, 0, 255, 255, 255, 55))
                            set k = k + 1
                        endloop
                        call DecorRemove(c, x, y, aoe, 50)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                call dmgphys(c, u, dmg)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_whiteakihared.mdx", GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359), 0.85, 1, GetUnitFlyHeight(u) + 50))
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        call DestroyGroup(g)
                    endif
                else
                    call StopSpellUnit(c)
                    call DestroyEffect(e2)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set u = null
                    set m_BarraganW2[i] = m_BarraganW2[MUI_BarraganW2]
                    set MUI_BarraganW2 = MUI_BarraganW2 - 1
                    if MUI_BarraganW2 == -1 then
                        call PauseTimer( t_BarraganW2 )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BarraganW2_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_BarraganW2 = MUI_BarraganW2 + 1
            set m_BarraganW2[MUI_BarraganW2] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set r2 = 0
            call StartSpellUnit(c)
            set g = CreateGroup()
            set u = null
            set a = GetUnitFacing(c) * bj_DEGTORAD // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = BarraganW2_DamageAoe
            set dmg = GetHeroInt(c, true) * (BarraganW2_DamageIntBase )
            set rmax = 0.42
            call SetUnitTimeScale(c, 0.5)
            call SetUnitAnimationByIndex(c, 0 )
            call MakeSound("war3mapimported\\Hero_Barragan_W2 2")
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_HakkeStart.mdx", x, y, GetRandomReal(0, 359), 0.86, 2.15, 10))
            if MUI_BarraganW2 == 0 then
                call TimerStart( t_BarraganW2, 0.03, true, function thistype.Loop_BarraganW2 )
            endif
        endmethod

    endstruct

    private struct HeroSpells_E
        private static timer t_BarraganE = CreateTimer()
        private static integer array m_BarraganE
        private static integer MUI_BarraganE = -1
        private static timer t_BarraganE2 = CreateTimer()
        private static integer array m_BarraganE2
        private static integer MUI_BarraganE2 = -1
        unit c
        real x
        real y
        real r2
        framehandle array frame_pas1 [10]
        framehandle array frame_pas2 [10]
        framehandle array frame_pas3 [10]
        framehandle array frame_pas4 [10]
        framehandle array frame_pas5 [10]
        framehandle array frame_pas6 [10]
        integer k2
        integer check2
        unit d
        real r3
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

        private static method Loop_BarraganE takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real hp
            loop
                exitwhen i > MUI_BarraganE
                set this = m_BarraganE[i]
                if SpellBoolCaster(c) and r <= rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false then
                    if check == 0 or (check == 1 and IsUnitPaused(c) == false and GetUnitAbilityLevel(c, 'Avul') == 0 ) then
                        set r = r + 0.05
                    endif
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if check == 0 then
                        if r == 0.2 then
                            call SetUnitTimeScale(c, 0)
                            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", c, "weapon")
                        endif
                        if r2 > 0.2 then
                            set r2 = 0
                            call DecorRemove(c, GetUnitX(c), GetUnitY(c), 450, 25)
                            call EffectSpawn2("war3mapimported\\wos_UltimateDarkFlash.mdl", x, y, 0, GetRandomReal(0.5, 0.9), 2, 90, 0.4)
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_saberalterqcpurple.mdx", x, y, GetRandomReal(0, 359), 1.66, 2.15, 11))
                        else
                            set r2 = r2 + 0.05
                        endif
                        if r3 > 0.3 then
                            set r3 = 0
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Purp_Mdx_Effect_BY_Mutou_Huozhu_Siwang.mdl", x, y, GetRandomReal(0, 359), 1.1, 1.8, 115))
                        else
                            set r3 = r3 + 0.05
                        endif
                        if r == rmax - 0.15 then
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_shadowexplosion.mdl", x, y, GetRandomReal(0, 359), 1.35, 2.25, 0))
                        endif
                        if r == rmax then
                        set check2 = 0
                            call DestroyEffect(e2)
                            call StopSpellUnit2(c)
                            call UnitAddAbility(c, BarraganE_Def_ID )
                            call UnitAddAbility(c, BarraganE2_ID )
                            if GetHeroLevel(c) >= 35 then
                            call ReduceCooldown(c,BarraganR_ID,BarraganE_ReduceR_CD)
                                endif
                            call SetUnitAbilityLevel(c, BarraganE2_ID , GetUnitAbilityLevel(c, BarraganE_ID))
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), BarraganE2_ID, true)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), BarraganE_ID, false)
                            call SetUnitAbilityLevel(c, BarraganE_Def_ID , GetUnitAbilityLevel(c, BarraganE_ID))
                            call SaveInteger(hs, GetHandleId(Player(k2)), StringHash("morph e"), 1)
                            call BlzSetAbilityRealLevelField(BlzGetUnitAbility(c, BarraganW_ID), ABILITY_RLF_CAST_RANGE, GetUnitAbilityLevel(c, BarraganW_ID) - 1, BarraganW_MorphRange)
                            call UnitMakeAbilityPermanent(c, true, BarraganE_Def_ID )
                            call BlzSetUnitSkin(c, Barragan2_ID)
                            call AAUniversalTooltips_SetUnitForm(c, 1)
                            set r = 0
                            set rmax = BarraganE_DurationBase + (BarraganE_DurationStep * ( GetUnitAbilityLevel( c , BarraganE_ID) - 1 )) + 0.2
                            set d = CreateUnit(Player(k2), BarraganE_IdDummy, 1, 1, 1)
                            set r2 = 9999
                            call FixAura(c)
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
                                call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Barragan_E", 0, false)
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
                        if check2 == 0 and LoadInteger(hs, GetHandleId(c), StringHash("barragan t")) == 1 then 
                        set check2 = 1
                        set rmax = rmax + BarraganT_Duration
                        call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, rmax + 2)
                        endif
                        if r2 > 1.95 then
                            set r2 = 0.05
                            set x = GetUnitX(c)
                            set y = GetUnitY(c)
                            call GroupClear(g)                            
                            call EUTU2_3(EffectSpawnScale("war3mapimported\\wos_zz-shio_zk_zz_stab2_hy-1_2.mdl", x, y, GetRandomReal(0, 359), 0.55, 0.01, 1, 0.25, 0.01, 1.15), 0.75, 1, c)
                           // call EffectSpawnTarget("war3mapimported\\wos_UltimateDarkFlash.mdx", c, "origin", GetRandomReal(0, 359), 1.15, 1, 0, 5)
                            call GroupEnumUnitsInRange(g, x, y, aoe, null)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c))  then
                                    call BarraganPassiveBurn(c, u)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        else
                            set r2 = r2 + 0.05
                        endif
                        if r == 0.05 then
                            call BlzSetAbilityIcon(BarraganQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Barragan_EQ.blp")
                            call BlzSetAbilityIcon(BarraganW_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Barragan_EW.blp")
                            call BlzSetAbilityIcon(BarraganR_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Barragan_ER.blp")
                        endif
                    endif
                else
                    if check == 0 then
                        call DestroyEffect(e2)
                        call StopSpellUnit2(c)
                    endif
                    if GetUnitCurrentOrder(c) == OrderId("blackarrowoff") then 
                    call IssueImmediateOrder(c,"stop")
                    endif   
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), BarraganE2_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), BarraganE_ID, true)
                    set hp = GetUnitState(c, UNIT_STATE_LIFE) / GetUnitState(c, UNIT_STATE_MAX_LIFE)
                    call BlzSetUnitMaxHP(c, BlzGetUnitMaxHP(c) - (BarraganE_HP_Base + (BarraganE_HP_Step * (GetUnitAbilityLevel(c, BarraganE_ID) - 1))))
                    call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_MAX_LIFE) * hp)
                    call SaveInteger(hs, GetHandleId(Player(k2)), StringHash(I2S(BarraganW_ID)), 0)
                    call BlzSetAbilityRealLevelField(BlzGetUnitAbility(c, BarraganW_ID), ABILITY_RLF_CAST_RANGE, GetUnitAbilityLevel(c, BarraganW_ID) - 1, BarraganW_BaseRange)
                    call BlzSetAbilityIcon(BarraganQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Barragan_Q.blp")
                    call BlzSetAbilityIcon(BarraganW_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Barragan_W.blp")
                    call BlzSetAbilityIcon(BarraganR_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Barragan_R.blp")
                    call SaveInteger(hs, GetHandleId(Player(k2)), StringHash("morph e"), 0)
                    call UnitRemoveAbility(c, BarraganE_Def_ID )
                    call RemoveUnit(d)
                    call BlzSetUnitSkin(c, Barragan_ID)
                    call AAUniversalTooltips_SetUnitForm(c, 0)
                    call FixAura(c)
                    call SetUnitTimeScale( c, 1 )
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame_pas1[k2], false)
                    endif
                    call DestroyGroup(g)
                    set g = null
                    set d = null
                    set c = null
                    set u = null
                    set e2 = null
                    set m_BarraganE[i] = m_BarraganE[MUI_BarraganE]
                    set MUI_BarraganE = MUI_BarraganE - 1
                    if MUI_BarraganE == -1 then
                        call PauseTimer( t_BarraganE )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BarraganE_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            local real hp = 0
            set MUI_BarraganE = MUI_BarraganE + 1
            set m_BarraganE[MUI_BarraganE] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set r2 = 0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            call StartSpellUnit2(c)
            set check = 0
            set g = CreateGroup()
            set u = null
            set a = GetUnitFacing(c) * bj_DEGTORAD // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG - 45)
            set aoe = BarraganE_DamageAoe
            set rmax = 1
            call SetUnitTimeScale(c, 1)
            set hp = GetUnitState(c, UNIT_STATE_LIFE) / GetUnitState(c, UNIT_STATE_MAX_LIFE)
            call BlzSetUnitMaxHP(c, BlzGetUnitMaxHP(c) + BarraganE_HP_Base + (BarraganE_HP_Step * (GetUnitAbilityLevel(c, BarraganE_ID) - 1)))
            call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_MAX_LIFE) * hp)
            call SetUnitAnimationByIndex(c, 9 )
            call MakeSound("war3mapimported\\Hero_Barragan_E1")
            call MakeSound("war3mapimported\\Hero_Barragan_E2")
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_HakkeStart.mdx", x, y, GetRandomReal(0, 359), 0.35, 1.75, 10))
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(BarraganW_ID)), 1)
            if MUI_BarraganE == 0 then
                call TimerStart( t_BarraganE, 0.05, true, function thistype.Loop_BarraganE )
            endif
        endmethod

        private static method Loop_BarraganE2 takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_BarraganE2
                set this = m_BarraganE2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    if r == 0.42 then
                        call BlinkEff(c)
                        call BlinkEff2(c)
                        call SetUnitPosition(c, x - 180 * Cos(a), y - 180 * Sin(a))
                        call BlinkEff(c)
                    endif
                    if r == rmax then
                        
                        call MakeSound("war3mapimported\\Hero_Barragan_W2")
                        if check2 == 1 then 
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_kyaru_skill02purple.mdx", x, y, GetRandomReal(0, 359), 1.25, 0.8, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_by_wood_effect_order_dange_yueyun_2withoutpurple3.mdx", x, y, GetRandomReal(0, 359), 0.45, 1.45, 0))
                        endif
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_saberalterqcpurple.mdx", x, y, GetRandomReal(0, 359), 1.66, 4.15, 11))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPM (513)purple.mdx", x, y, GetRandomReal(0, 359), 1, 1, 0))
                           // call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZarakiWCrack1.mdx", x, y, GetRandomReal(0, 359), 1.25, 1.5, 0))
                            
                        call DecorRemove(c, x, y, aoe, 60)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                call dmgphys(c, u, dmg)
                                if check2 == 1 then 
                                call StunUnit(c,u,BarraganE2T_Stun)
                                endif
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        call DestroyGroup(g)
                    endif
                else                   
                    call StopSpellUnit2(c)
                    call SetUnitTimeScale( c, 1 )
                    call DestroyEffect(e2)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set u = null
                    set e2 = null
                    set m_BarraganE2[i] = m_BarraganE2[MUI_BarraganE2]
                    set MUI_BarraganE2 = MUI_BarraganE2 - 1
                    if MUI_BarraganE2 == -1 then
                        call PauseTimer( t_BarraganE2 )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BarraganE2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_BarraganE2 = MUI_BarraganE2 + 1
            set m_BarraganE2[MUI_BarraganE2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set a = GAngle2(c, x, y) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = BarraganE2_DamageAoe
            set dmg = GetHeroInt(c, true) * BarraganE2_DamageIntBase
            set check2 = 0
            if  LoadInteger(hs, GetHandleId(c), StringHash("barragan t")) == 1 then 
            set check2 = 1
            set dmg = dmg + GetHeroInt(c, true) * BarraganE2_DamageIntBaseTAdd
            endif
            call SetUnitFacing( c , a * bj_RADTODEG)
            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiPurple.mdx", c, "hand right")
            set k2 = 1
            set rmax = 0.51
            call SetUnitTimeScale( c , 1.25)
            call SetUnitAnimationByIndex( c , 5)
            call MakeSound("war3mapimported\\Hero_Barragan_E2 1")
            call MakeSound("war3mapimported\\Hero_Barragan_E2 2")
            if MUI_BarraganE2 == 0 then
                call TimerStart( t_BarraganE2, 0.03, true, function thistype.Loop_BarraganE2 )
            endif
        endmethod

    endstruct

    private struct HeroSpells_R
        private static timer t_BarraganR = CreateTimer()
        private static integer array m_BarraganR
        private static integer MUI_BarraganR = -1
        unit c
        real x
        real y
        real r2
        effect array ee [15]
        integer k
        real scale
        real r3
        real r4
        real r5
        group g
        group g2
        unit u
        real dmg
        integer check
        real aoe
        real r
        effect e
        real a
        real rmax

        private static method Loop_BarraganR takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_BarraganR
                set this = m_BarraganR[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.05
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    call DebugUnit(c)
                    if check == 1 then
                        if aoe < BarraganER_DamageAoe then
                            set aoe = aoe + 125
                        endif
                        if aoe > BarraganER_DamageAoe then
                            set aoe = BarraganER_DamageAoe
                        endif
                        if r == 0.05 then
                            set r5 = 125
                            set scale = 0.05
                            set k = 0
                            loop
                                exitwhen k > 6
                                set ee[k] = EffectSpawn("war3mapimported\\wos_zz-shio_zk_zz_stab2_hy-1.mdl", x + r5 * Cos(k * 52 * bj_DEGTORAD), y + r5 * Sin(k * 52 * bj_DEGTORAD), GetRandomReal(0, 359), 0.75, 0.15, 0)
                                set k = k + 1
                            endloop
                        endif
                        if r > 0.05 and r5 < BarraganER_DamageAoe - 100 then
                            set k = 0
                            set r5 = r5 + 35
                            if scale < 1.25 then
                                set scale = scale + 0.1
                            endif
                            loop
                                exitwhen k > 6
                                call BlzSetSpecialEffectPosition(ee[k], x + r5 * Cos(k * 52 * bj_DEGTORAD), y + r5 * Sin(k * 52 * bj_DEGTORAD), 0)
                                call BlzSetSpecialEffectScale(ee[k], scale)
                                set k = k + 1
                            endloop
                        endif
                    endif
                    if r == 1.2 and check == 0 then
                        call SetUnitTimeScale(c, 0)
                    endif
                    if r2 >= 0.21 then
                        set r2 = 0.05
                        call DecorRemove(c, x, y, aoe + 200, 35)
                        if check == 0 then
                            call SetMpCurrent(c, scale)
                        endif
                        call GroupEnumUnitsInRange(g, x, y, aoe, null)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if check == 0 then
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call dmgmag(c, u, dmg)
                                    call SlowUnit(c, u, BarraganR_Slow , BarraganR_SlowDuration )
                                endif
                            else
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitInGroup(u, g2) == false then
                                    call DmgPTime(c, u, dmg, BarraganER_DamageDuration, BarraganER_DamagePeriodic, 1)
                                    call EffectSpawnTarget("war3mapImported\\wos_zz-fire-ore-hit1-zihei_2.mdx", u, "origin", GetRandomReal(0, 359), 1.15, 2, 0, BarraganER_DamageDuration)
                                    call SlowUnit(c, u, BarraganR_Slow , BarraganR_SlowDuration )
                                    call GroupAddUnit(g2, u)
                                    if GetHeroLevel(c) >= BarraganG_AbilityEnchantLevelGain then
                                        call BarraganPassiveBurn(c, u)
                                    endif
                                endif
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    else
                        set r2 = r2 + 0.05
                    endif
                    if check == 1 then
                        if r4 >= 0.5 then
                            set r4 = 0.05
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_kyaru_skill02purple.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1.25, 1.1, 0))
                        else
                            set r4 = r4 + 0.05
                        endif
                    endif
                    if check == 0 then
                        if r3 >= 0.4 then
                            set r3 = 0.05
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPM (513)red.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1.5, 1.15, 0))
                        else
                            set r3 = r3 + 0.05
                        endif
                        if r5 >= 0.1 then
                            set r5 = 0.05
                            set k = 0
                            loop
                                exitwhen k > 5
                                if check == 0 then
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_dustwave222.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 0.8, 2.75 + 0.6 * k, 0, 225, 125, 125, 45))
                                endif
                                set k = k + 1
                            endloop
                        else
                            set r5 = r5 + 0.05
                        endif
                    endif
                else
                    if check == 1 then
                        set k = 0
                        loop
                            exitwhen k > 6
                            call DestroyEffect(ee[k])
                            set ee[k] = null
                            set k = k + 1
                        endloop
                    endif
                    call DestroyEffect(e)
                    call StopSpellUnit(c)
                    call DestroyGroup(g)
                    if g2 != null then
                        call DestroyGroup(g2)
                    endif
                    set c = null
                    set g = null
                    set g2 = null
                    set e = null
                    set u = null
                    set m_BarraganR[i] = m_BarraganR[MUI_BarraganR]
                    set MUI_BarraganR = MUI_BarraganR - 1
                    if MUI_BarraganR == -1 then
                        call PauseTimer( t_BarraganR )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BarraganR_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_BarraganR = MUI_BarraganR + 1
            set m_BarraganR[MUI_BarraganR] = this
            set c = NewC
            set r = 0
            set r2 = 0
            set r3 = 0
            set r4 = 0
            set r5 = 0
            call PauseUnit(c, true)
            set a = GetUnitFacing(c) * bj_DEGTORAD
            set g = CreateGroup()
            set rmax = BarraganR_DamageInvulBase + (BarraganR_DamageInvulStep * (GetUnitAbilityLevel(c, BarraganR_ID) - 1))
            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e")) == 0 then
                set check = 0
                set aoe = BarraganR_DamageAoe
                set dmg = GetHeroInt(c, true) * (BarraganR_DamageIntBase + (BarraganR_DamageIntStep * (GetUnitAbilityLevel(c, BarraganR_ID) - 1)))
                set dmg = dmg / 4
                set scale = GetUnitState(c, UNIT_STATE_MAX_MANA) * (BarraganR_ManaRestore / 100)
                set scale = scale / (rmax * 4 )
                call SetUnitTimeScale(c, 0.25)
                call SetUnitAnimationByIndex(c, 10)
                call MakeSound("war3mapimported\\Hero_Barragan_R")
                call MakeSound("war3mapimported\\Hero_Barragan_R2")
                call EffectSpawn2("war3mapimported\\wos_JY-Shio_Super_Saiyan_JN_ZiRed.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 9, 70, BarraganR_DamageInvulBase)
                call EffectSpawn2("war3mapimported\\wos_JY-Shio_Super_Saiyan_JN_ZiRed.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 9, 70, BarraganR_DamageInvulBase)
                call EffectSpawn2("war3mapimported\\wos_JY-Shio_Super_Saiyan_JN_ZiRed.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 9, 70, BarraganR_DamageInvulBase)
                call EffectSpawn2("war3mapimported\\wos_JY-Shio_Super_Saiyan_JN_ZiRed.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 9, 70, BarraganR_DamageInvulBase)
            else
                set aoe = 0 // it should be zero for morph spell from begin it would increase till get max variable BarraganER_DamageAoe out
                set dmg = GetHeroInt(c, true) * (BarraganER_DamageIntBase + (BarraganER_DamageIntStep * (GetUnitAbilityLevel(c, BarraganR_ID) - 1)))
                call SetUnitTimeScale(c, 1)
                call SetUnitAnimationByIndex(c, 6)
                set check = 1
                set g2 = CreateGroup()
                call MakeSound("war3mapimported\\Hero_Barragan_ER1")
                call MakeSound("war3mapimported\\Hero_Barragan_ER2")
                call EffectSpawn2("war3mapimported\\wos_JY-Shio_Super_Saiyan_JN_Zi.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 9, 70, BarraganR_DamageInvulBase)
                call EffectSpawn2("war3mapimported\\wos_JY-Shio_Super_Saiyan_JN_Zi.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 9, 70, BarraganR_DamageInvulBase)
                call EffectSpawn2("war3mapimported\\wos_JY-Shio_Super_Saiyan_JN_Zi.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 9, 70, BarraganR_DamageInvulBase)
                call EffectSpawn2("war3mapimported\\wos_JY-Shio_Super_Saiyan_JN_Zi.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 9, 70, BarraganR_DamageInvulBase)
            endif
            call VisionTimed(GetOwningPlayer(c), GetUnitX(c), GetUnitY(c), 2000, rmax)
            if MUI_BarraganR == 0 then
                call TimerStart( t_BarraganR, 0.05, true, function thistype.Loop_BarraganR )
            endif
        endmethod

    endstruct

    private struct HeroSpells_T
        private static timer t_BarraganT = CreateTimer()
        private static integer array m_BarraganT
        private static integer MUI_BarraganT = -1
        private static timer t_BarraganT2 = CreateTimer()
        private static integer array m_BarraganT2
        private static integer MUI_BarraganT2 = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        real r7
        framehandle array frame2_pas1 [10]
        framehandle array frame2_pas2 [10]
        framehandle array frame2_pas3 [10]
        framehandle array frame2_pas4 [10]
        framehandle array frame2_pas5 [10]
        framehandle array frame2_pas6 [10]
        integer k
        integer k2
        unit d
        real scale
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
        real a
        real rmax

        private static method Loop_BarraganT takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_BarraganT
                set this = m_BarraganT[i]
                if SpellBoolCaster(c) and LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e")) > 0 and r < rmax and LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("baragan t cancel")) == 0 then
                    if IsUnitPaused(c) == false then
                        set r = r + 0.05
                    endif
                    call BlzFrameSetValue(frame2_pas3[k2], rmax - (r + 0.1))
                    if rmax - r >= 0 then
                        call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                    endif
                else
                    if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e")) == 0 then
                        call BlzSetAbilityIcon(BarraganQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Barragan_Q.blp")
                    else
                        call BlzSetAbilityIcon(BarraganQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Barragan_EQ.blp")
                    endif
                    call RemoveUnit(d)
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame2_pas1[k2], false)
                    endif
                    call SaveInteger(hs, GetHandleId(c), StringHash("barragan t"), 0)
                    if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e")) == 1 then
                        call AAUniversalTooltips_SetUnitForm(c, 1)
                    else
                        call AAUniversalTooltips_SetUnitForm(c, 0)
                    endif
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), BarraganT2_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), BarraganT_ID, true)
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("baragan t cancel"), 0)
                    call DestroyEffect(e)
                    call SetUnitTimeScale( c, 1 )
                    set c = null
                    set d = null
                    set e = null
                    set m_BarraganT[i] = m_BarraganT[MUI_BarraganT]
                    set MUI_BarraganT = MUI_BarraganT - 1
                    if MUI_BarraganT == -1 then
                        call PauseTimer( t_BarraganT )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BarraganT_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            local real tmp_y = 0.0375
            set MUI_BarraganT = MUI_BarraganT + 1
            set m_BarraganT[MUI_BarraganT] = this
            set c = NewC
            set r = 0
            set r2 = 0
            set rmax = BarraganT_Duration
            call SetUnitTimeScale(c, 1)
            set k2 = GetPlayerId(GetOwningPlayer(c))
            call SetUnitAnimationByIndex(c, 6)
            set d = CreateUnit(GetOwningPlayer(c), BarraganT_IdDummy, 1, 1, 1)
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("baragan t cancel"), 0)
            call SaveInteger(hs, GetHandleId(c), StringHash("barragan t"), 1)
            call AAUniversalTooltips_SetUnitForm(c, 2)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), BarraganT_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), BarraganT2_ID, true)
            call UnitAddAbility(c, BarraganT2_ID)
            call UnitMakeAbilityPermanent(c, true, BarraganT2_ID)
            call MakeSound("war3mapimported\\Hero_Barragan_T")
            call MakeSound("war3mapimported\\Hero_Barragan_T2")
            if frame2_pas1[k2] == null then
                set frame2_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                call BlzFrameSetAbsPoint(frame2_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18 + tmp_y)
                call BlzFrameSetSize(frame2_pas1[k2], 0.135, 0.035)
                call BlzFrameSetTexture(frame2_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                call BlzFrameSetVisible(frame2_pas1[k2], false)
                if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frame2_pas1[k2], true)
                endif
                set frame2_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame2_pas1[k2], 0, 0)
                call BlzFrameSetAbsPoint(frame2_pas2[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
                call BlzFrameSetSize(frame2_pas2[k2], 0.1, 0.019)
                set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)
                call BlzFrameSetSize(frame2_pas3[k2], 0.1, 0.035)
                call BlzFrameSetScale(frame2_pas3[k2], 0.5)
                call BlzFrameSetModel(frame2_pas3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                call BlzFrameSetAbsPoint(frame2_pas3[k2], FRAMEPOINT_CENTER, 0.05, 0.175 + tmp_y)
                call BlzFrameSetMinMaxValue(frame2_pas3[k2], 0, rmax + 2)
                call BlzFrameSetValue(frame2_pas3[k2], rmax)
                set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame2_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18 + tmp_y)
                call BlzFrameSetSize(frame2_pas4[k2], 0.03, 0.03)
                call BlzFrameSetTexture(frame2_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Barragan_T", 0, false)
                set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame2_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
                call BlzFrameSetText(frame2_pas5[k2], "|c00FFFF00" + "Time Left:" + "|r")
                call BlzFrameSetScale(frame2_pas5[k2], 0.9)
                set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame2_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17 + tmp_y)
                call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                call BlzFrameSetScale(frame2_pas6[k2], 0.9)
            else
                if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frame2_pas1[k2], true)
                endif
                call BlzFrameSetValue(frame2_pas3[k2], rmax)
            endif
            
            call BlzSetAbilityIcon(BarraganQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Barragan_ETQ.blp")
            set e = AddSpecialEffectTarget("war3mapimported\\wos_[By XeSHTeG]BarraganAxe.mdx", c, "hand right")
            call EffectSpawn2("war3mapimported\\wos_JY-Shio_Super_Saiyan_JN_Zi.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 3, 70, 1)
            call EffectSpawn2("war3mapimported\\wos_JY-Shio_Super_Saiyan_JN_Zi.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 4, 70, 1)
            call EffectSpawn2("war3mapimported\\wos_JY-Shio_Super_Saiyan_JN_Zi.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 5, 70, 1)
            call VisionTimed(GetOwningPlayer(c), GetUnitX(c), GetUnitY(c), 1800, 1.5)
            set k = 0
            loop
                exitwhen k > 6
                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_dustwave222.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 0.8, 1.55 + 0.45 * k, 0, 175, 55, 205, 45))
                if k < 2 then
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_kyaru_skill02purple.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 0.55, 0))
                endif
                set k = k + 1
            endloop
            if MUI_BarraganT == 0 then
                call TimerStart( t_BarraganT, 0.05, true, function thistype.Loop_BarraganT )
            endif
        endmethod

        private static method Loop_BarraganT2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_BarraganT2
                set this = m_BarraganT2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if r < r5 then
                        call DebugUnit(c)
                    endif
                    if r == r5 then
                        call StopSpellUnit(c)
                        call DestroyEffect(e2)
                      //  call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("baragan t cancel"), 1)
                        call MakeSound("war3mapimported\\Hero_Barragan_TET2 2")
                        set check = 1
                        set x1 = (GetUnitX( c )) + 80 * Cos( a )
                        set y1 = (GetUnitY( c )) + 80 * Sin( a )
                        set e = EffectSpawn("war3mapimported\\wos_[By XeSHTeG]BarraganAxe2.mdx", x1, y1, a * bj_RADTODEG, 5, 1.05, 300)
                        set e2 = EffectSpawn3("war3mapimported\\wos_AZ_DD029.mdl", x1 + 140 * Cos(a + 90 * bj_DEGTORAD), y1 + 140 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 90, 1.5, 2.35, 300, -90)
                    endif
                    if r >= r5 then
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        call MoveEff(e, move, a)
                        call MoveEff(e2, move, a)
                        set r7 = r7 + move
                        if r7 > BarraganT2_Range then
                            set r = 9999
                        endif
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x + move * Cos(a), y + move * Sin(a), aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u, g2) == false then
                                call dmgmag(c, u, dmg)
                                call StunUnit(c, u, BarraganT2_StunDuration)
                                call GroupAddUnit(g2, u)
                                if GetHeroLevel(c) >= BarraganG_AbilityEnchantLevelGain then
                                    call BarraganPassiveBurn(c, u)
                                endif
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        if r3 > 0.09 then
                            set r3 = 0
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_zz-shio_zk_zz_stab2_hy-1.mdx", x, y, a * bj_RADTODEG, 1.85, 0.45, 1))
                        else
                            set r3 = r3 + 0.03
                        endif
                        if r6 >= 0.06 then
                            set r6 = 0
                            call DecorRemove(c, x, y, aoe, 100)
                            call VisionTimed(GetOwningPlayer(c), x + (move * 2) * Cos(a), y + (move * 2) * Sin(a), 900, 1.5)
                        else
                            set r6 = r6 + 0.03
                        endif
                        if r4 > 0.0 then
                            set r4 = 0
                            call EffectSpawn2("war3mapimported\\wos_0233.mdl", x + move * Cos(a), y + move * Sin(a), a * bj_RADTODEG, 1, 2.25, 0, 0.06)
                        else
                            set r4 = r4 + 0.03
                        endif
                    endif
                else
                    call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x,y, aoe*1.5, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u, g2) == false then
                                call dmgmag(c, u, dmg)
                                call StunUnit(c, u, BarraganT2_StunDuration)
                                call GroupAddUnit(g2, u)
                                if GetHeroLevel(c) >= BarraganG_AbilityEnchantLevelGain then
                                    call BarraganPassiveBurn(c, u)
                                endif
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    call BlzSetSpecialEffectTimeScale(e, 0.5)
                    call EffectSpawn2("war3mapimported\\wos_zz-shio_zk_zz_stab2_hy-1.mdl", x, y, GetRandomReal(0, 359), 0.55, 2, 0, 0.35)
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_by_wood_effect_order_dange_yueyun_2withoutpurple3.mdx", x, y, GetRandomReal(0, 359), 0.65, 1.25, 0))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPM (513)purple.mdx", x, y, GetRandomReal(0, 359), 1, 1, 0))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_fangkuai2.mdl", x, y, 160, 1, 1.65, 0))
                    call DestroyEffect( e )
                    call DestroyEffect( e2 )
                    call SetUnitTimeScale( c , 1)
                    if r <= r5 then
                        call StopSpellUnit(c)
                    endif
                    call DestroyGroup( g )
                    set g = null
                    call DestroyGroup( g2 )
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_BarraganT2[i] = m_BarraganT2[ MUI_BarraganT2]
                    set MUI_BarraganT2 = MUI_BarraganT2 - 1
                    if MUI_BarraganT2 == -1 then
                        call PauseTimer( t_BarraganT2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method BarraganT2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_BarraganT2 = MUI_BarraganT2 + 1
            set m_BarraganT2[ MUI_BarraganT2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set scale = 1.2
            call StartSpellUnit(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set check = 0
            set r7 = 0
            set k2 = 0
            set aoe = BarraganT2_DamageAoe
            set dmg = GetHeroInt( c , true) * BarraganT2_DamageIntBase
            set move = 100
            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_m3 (704).mdx", c, "weapon")
            set k2 = 1
            set r5 = 0.81 // delay before axe throw
            set rmax = 2.01 + r5 // max distance formula rmax / 0.03 * move, current 4000
            call SetUnitTimeScale( c , 0.3645)
            call SetUnitAnimationByIndex( c , 10)
            call MakeSound("war3mapimported\\Hero_Barragan_ET2 1")
            if MUI_BarraganT2 == 0 then
                call TimerStart( t_BarraganT2, 0.03, true, function thistype.Loop_BarraganT2)
            endif
        endmethod

    endstruct

   
    //----------------------------Barragan-----------------------------------------------
     /* Animations index:
    Base:
    0 - round attack
    1 - atk to self
    2 - round atk from self fast
    3 - death
    4 - stand
    5 - move
    6 - axe up stand
    7 - sonido
    8 - atk from self
    9 - stand ready to reiatsu
    10 - atk to earth from air
    11 - facepalm
    12 - cero
    13 - cero charge
    
    Morph:
    0 - round attack
    1 - death
    2 - stand
    3 - move
    4 - respira wave
    5 - tripple atk combo
    6 - axe respira another hand
    7 - stand
    8 - atk to self
    9 - atk from self
    10 - atk pierce forward
    
     */ 
    
    function BarraganQ_Start takes unit c, real x, real y returns nothing
        call HeroSpells_Q.BarraganQ_Start( c, x, y )
    endfunction
    function BarraganW_Start takes unit c, real x, real y returns nothing
        call HeroSpells_W.BarraganW_Start( c, x, y )
    endfunction
    function BarraganW2_Start takes unit c returns nothing
        call HeroSpells_W.BarraganW2_Start( c )
    endfunction
    function BarraganE_Start takes unit c returns nothing
        if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph e")) == 0 then
            call HeroSpells_E.BarraganE_Start( c )
        else
            call IssueImmediateOrder(c, "stop")
            call DisplayTimedTextToPlayer(GetOwningPlayer(c), 0, 0, 0.1, "|c00FF0303You already in morph , stop doing that|r")
        endif
    endfunction
    function BarraganE2_Start takes unit c, real x, real y returns nothing
        call HeroSpells_E.BarraganE2_Start( c, x, y )
    endfunction
    function BarraganR_Start takes unit c returns nothing
        call HeroSpells_R.BarraganR_Start( c )
    endfunction
    function BarraganT_Start takes unit c returns nothing
        call HeroSpells_T.BarraganT_Start( c )
    endfunction
    function BarraganT2_Start takes unit c, real x, real y returns nothing
        call HeroSpells_T.BarraganT2_Start( c, x, y )
    endfunction
  
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
