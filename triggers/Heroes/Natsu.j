library NatsuSpells uses GearSystems
    globals
//--------------------------------------Natsu--------------------------------------------------------------
        integer Natsu_ID = 'H001'
        boolean NatsuPicked = false
//---------------Q ability-----------------------------------------------------
        integer NatsuQ_ID = 'A00E'
        real NatsuQ_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real NatsuQ_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real NatsuGQ_DamageAgiBonus = 1 // additional number x Agi damage for raienryuu mode
        real NatsuGQ2_DamageAgiBonus = 3 // additional number x Agi damage for raienryuu mode enchacned roar after g
        real NatsuQ_Damage2StaticBase = 150 // base static damage for 1 level
        real NatsuQ_Damage2StaticStep = 0 // additional static damage for each next level
        real NatsuQ_DamageAoe = 375
        real NatsuQ_Range = 1300 // base breath
        real NatsuQ_Range2 = 2500
        real NatsuQ_Range3 = 5000
//---------------W ability-----------------------------------------------------
        integer NatsuW_ID = 'A00F'
        real NatsuW_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real NatsuW_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real NatsuW_Damage2StaticBase = 175 // base static damage for 1 level
        real NatsuW_Damage2StaticStep = 0 // additional static damage for each next level
        real NatsuGW_DamageAgiBonus = 1 // additional number x Agi damage for raienryuu mode
        real NatsuW_PushRange = 400
        real NatsuW_PushDuration = 0.39
        real NatsuW_Stun = 0.5
//---------------E ability-----------------------------------------------------
        integer NatsuE_ID = 'A00G'
        real NatsuE_DamageAgiBase = 2 // base number x Agi damage for 1 level
        real NatsuE_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real NatsuE_Damage2StaticBase = 0 // base static damage for 1 level
        real NatsuE_Damage2StaticStep = 0 // additional static damage for each next level
        real NatsuGE_DamageAgiBonus = 1 // additional number x Agi damage for raienryuu mode
        real NatsuE_DamageAoe = 700
        integer NatsuE_Slow = 40
        integer NatsuE_Duration = 1
//---------------R ability-----------------------------------------------------
        integer NatsuR_ID = 'A00H'
        real NatsuR_Stun = 1
        real NatsuGR_DamageAgiBonus = 1 // additional number x Agi damage for raienryuu mode
        real NatsuR_DamageAgiBase = 4 // base number x Agi damage for 1 level
        real NatsuR_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real NatsuR_Damage2StaticBase = 0 // base static damage for 1 level
        real NatsuR_Damage2StaticStep = 0 // additional static damage for each next level
        real NatsuR_PushRange = 450
        real NatsuR_PushDuration = 0.3
        real NatsuR_BonusAdd = 3// % dmg with each R press
        real NatsuR_BonusMax = 15// %
//---------------T ability-----------------------------------------------------
        integer NatsuT_ID = 'A00I'
        real NatsuT_DamageAgiBase = 10 // base number x Agi damage
        real NatsuT_DamageAoe = 455 // damage area
        real NatsuT_PushRange = 550
        real NatsuT_Range = 2150
        real NatsuT_PushDuration = 0.42
        real NatsuGT_DamageAgiBonus = 1 // additional number x Agi damage for raienryuu mode
//---------------G ability-----------------------------------------------------
        integer NatsuG_ID = 'A00J'
        integer NatsuG2_ID = 'A00K'
        real NatsuG_Duration = 30 // duration of raienryuu mode
        real NatsuG_CdReduceTime = 2.00 // how much sec cooldown cutdown from 1 fire sphere
        real NatsuG_Aoe = 1600 // aoe where natsu will find fire spheres
        integer NatsuG_LvlReq = 25 // after this lvl he will gain raienryuu from G
        real NatsuG_Cd = 70 // modo raienryuu cd
//---------------F ability-----------------------------------------------------
        integer NatsuF_ID = 'A00L'
        integer NatsuF_Stats_ID = 'A04Z'        
        integer NatsuF_LvlCheck = 12 // when passive start work
        real NatsuF_Duration = 15 // duration of raienryuu mode
        real NatsuF_CdReduceTime = 5 // how much sec cooldown cutdown from R and T
        real NatsuF_Cd = 70 // cooldown of aura
        real NatsuF_AoeSearch = 1800 // aoe where search damaged enemies
        real NatsuF_AllyDamageHigh = 15 // if ally gain more than this % of damage aura activated
        real NatsuF_AllyDamageLow = 35 // if ally gain damage when have lower % of this hp value
//---------------FR ability-----------------------------------------------------     
        integer NatsuFR_ID = 'A00N'
        real NatsuFR_Stun = 0.5
        real NatsuFR_DamageAgiBase = 5 // base number x Agi damage for 1 level
        real NatsuFR_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real NatsuFR_Damage2StaticBase = 0 // base static damage for 1 level
        real NatsuFR_Damage2StaticStep = 0 // additional static damage for each next level
//---------------FT ability-----------------------------------------------------     
        integer NatsuFT_ID = 'A00O'
        real NatsuFT_Stun = 1 // not lower than 1 sec
        real NatsuFT_DamageAgiBase = 11 // base number x Agi damage for 1 level
//------------------------------------------------------------------------------
    endglobals

    private struct NatsuQ_KS
        private static timer t_NatsuQ = CreateTimer( )
        private static integer array m_NatsuQ
        private static integer MUI_NatsuQ = -1
        unit c
        real x
        real y
        real r2
        integer k2
        real scale
        real r_prepare
        real r3
        real r4
        real r5
        real r7
        real fly
        group g
        group g2
        unit u
        real dmg
        integer check
        real aoe
        real move
        real r
        real a
        real rmax
        private static method Loop_NatsuQ takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_NatsuQ
                set this = m_NatsuQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if k2 == 0 then
                        if r == r_prepare - 0.03 then
                            call SetUnitTimeScale(c, 1)
                            set x = GetUnitX(c) + 180 * Cos(a)
                            set y = GetUnitY(c) + 180 * Sin(a)
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 2, 1.25, 1, 255, 255, 255, 225))
                        endif
                        if r < r_prepare then
                            call DebugUnit2(c)
                        endif
                        if r >= r_prepare then
                            set x = x + move * Cos(a)
                            set y = y + move * Sin(a)
                            set r7 = r7 + move
                            if r7 >= NatsuQ_Range then
                                set r = 999999
                            endif
                            if r2 > 0.00 then
                                set r2 = 0
                                set scale = scale + 0.21
                                set move = move + 5
                                set fly = fly + 9
                                call EffectSpawn2("war3mapImported\\wos_File00000377.mdl", x, y, a * bj_RADTODEG , 2, scale, fly, 0.275)
                            else
                                set r2 = r2 + 0.03
                            endif
                            if r3 > 0.03 then
                                set r3 = 0
                                call DecorRemove(c, x, y, aoe, 20)
                                call VisionTimed(GetOwningPlayer(c),x,y,aoe*1.5,1.5)
                                call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_papsnaz (1050).mdl", x, y, GetRandomReal(0, 359), 1.85, 0.01, 0, 0.12, 0.01, scale * 0.6), 0.3, 255, 255, 255, 0.51)
                            else
                                set r3 = r3 + 0.03
                            endif
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null or check > 0
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                    call GroupAddUnit(g2, u)
                                    call dmgmag(c, u, dmg)
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        endif
                    elseif k2 == 1 then
                        if r == r_prepare - 0.03 then
                            call SetUnitTimeScale(c, 1)
                            call MakeSound("war3mapimported\\Hero_Natsu_GQ_02")
                            set x = GetUnitX(c) + 180 * Cos(a)
                            set y = GetUnitY(c) + 180 * Sin(a)
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 2, 2.25, 1, 255, 255, 255, 225))
                        endif
                        if r == 0.21 or r == 0.42 or r == 0.63 or r == 0.84 or r == 1.02 or r == 1.2 then
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_bdef (383).mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 1.25, 15, 255, 255, 255, 155))
                        endif
                        if r == 0.12 then
                            call EffectSpawn2("war3mapImported\\wos_lb_hg2-E12B5.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 0.25, 1.5, 50, r_prepare - r)
                            call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_firacharge.mdl", GetUnitX(c) + 40 * Cos(a), GetUnitY(c) + 40 * Sin(a), a, 1, 1, 1), r_prepare - r, 255, 255, 255, 0.12)
                        endif
                        if r < r_prepare then
                            call DebugUnit2(c)
                        endif
                        if r >= r_prepare then
                            set x = x + move * Cos(a)
                            set y = y + move * Sin(a)
                            set r7 = r7 + move
                            if r7 >= NatsuQ_Range2 then
                                set r = 999999
                            endif
                            if move < 140 then
                                set move = move + 10
                            endif
                            if r2 > 0.00 then
                                set r2 = 0
                                set scale = scale + 0.3
                                set move = move + 5
                                set fly = fly + 18
                                call EffectSpawn2("war3mapImported\\wos_File00000377.mdl", x, y, a * bj_RADTODEG , 2, scale, fly, 0.35)
                            else
                                set r2 = r2 + 0.03
                            endif
                            if r3 > 0.03 then
                                set r3 = 0
                                call DecorRemove(c, x, y, aoe, 50)
                                call VisionTimed(GetOwningPlayer(c),x,y,aoe*2,2)
                                call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_papsnaz (1050).mdl", x, y, GetRandomReal(0, 359), 1.85, 0.01, 0, 0.12, 0.01, scale * 0.6), 0.3, 255, 255, 255, 0.51)
                                call EffectSpawn2("war3mapImported\\wos_lb_hg2-E12B5.mdl", x, y, GetRandomReal(0, 359), 0.5, 2.5, fly - 80, 0.66)
                                call EffectSpawn2("war3mapImported\\wos_yellowspark.mdl", x, y, GetRandomReal(0, 359), 1.5, scale * 1.45, fly - 80, 0.6)
                            else
                                set r3 = r3 + 0.03
                            endif
                            if r4 > 0.09 then
                                set r4 = 0
                                if scale * 1.5 > 2.5 then
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_Kamijo-6_2.mdl", x, y, a * bj_RADTODEG + 180, 0.5, scale * 1.3, 0, 255, 255, 255, 140))
                                else
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_Kamijo-6_2.mdl", x, y, a * bj_RADTODEG + 180, 0.5, scale * 1.5, 0, 255, 255, 255, 140))
                                endif
                            else
                                set r4 = r4 + 0.03
                            endif
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null or check > 0
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                    call GroupAddUnit(g2, u)
                                    call dmgmag(c, u, dmg)
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        endif
                    elseif k2 == 2 then
                    call DebugUnit(c)
                        if r == r_prepare - 0.03 then
                            call SetUnitTimeScale(c, 1)
                            set x = GetUnitX(c) + 180 * Cos(a)
                            set y = GetUnitY(c) + 180 * Sin(a)
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 2, 3.25, 1, 255, 255, 255, 225))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG - 25, 2, 3.25, 1, 255, 255, 255, 225))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG + 25, 2, 3.25, 1, 255, 255, 255, 225))
                        endif
                        if r5 > 0.2 then
                            set r5 = 0
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_bdef (383).mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 1.25, 15, 255, 255, 255, 155))
                        else
                            set r5 = r5 + 0.03
                        endif
                        if r == 0.12 then
                            call EffectSpawn2("war3mapImported\\wos_lb_hg2-E12B5.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 0.25, 2, 50, r_prepare - r)
                            call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_firacharge.mdl", GetUnitX(c) + 40 * Cos(a), GetUnitY(c) + 40 * Sin(a), a, 1, 1.2, 1), r_prepare - r, 255, 255, 255, 0.12)
                        endif
                        if r < r_prepare then
                            call DebugUnit2(c)
                        endif
                        if r >= r_prepare then
                            set x = x + move * Cos(a)
                            set y = y + move * Sin(a)
                            set r7 = r7 + move
                            if r7 >= NatsuQ_Range3 then
                                set r = 999999
                            endif
                            if move < 140 then
                                set move = move + 10
                            endif
                            if r2 > 0.00 then
                                set r2 = 0
                                if scale < 3 then
                                    set scale = scale + 0.3
                                    set move = move + 5
                                    set fly = fly + 18
                                endif
                                call EffectSpawn2("war3mapImported\\wos_File00000377.mdl", x, y, a * bj_RADTODEG , 2, scale, fly, 1.59)
                            else
                                set r2 = r2 + 0.03
                            endif
                            if r3 > 0.03 then
                                set r3 = 0
                                call DecorRemove(c, x, y, aoe, 100)
                                call VisionTimed(GetOwningPlayer(c),x,y,aoe*2.5,4)
                                call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_papsnaz (1050).mdl", x, y, GetRandomReal(0, 359), 1.85, 0.01, 0, 0.12, 0.01, scale * 0.6), 0.3, 255, 255, 255, 1.75)
                                call EffectSpawn2("war3mapImported\\wos_lb_hg2-E12B5.mdl", x, y, GetRandomReal(0, 359), 0.5, 2.5, fly - 80, 1.75)
                                call EffectSpawn2("war3mapImported\\wos_yellowspark.mdl", x, y, GetRandomReal(0, 359), 1.5, scale * 1.45, fly - 80, 1.75)
                            else
                                set r3 = r3 + 0.03
                            endif
                            if r4 > 0.09 then
                                set r4 = 0
                                if scale * 1.5 > 2.5 then
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_Kamijo-6_2.mdl", x, y, a * bj_RADTODEG + 180, 0.255, scale * 1.3, 0, 255, 255, 255, 140))
                                else
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_Kamijo-6_2.mdl", x, y, a * bj_RADTODEG + 180, 0.255, scale * 1.5, 0, 255, 255, 255, 140))
                                endif
                            else
                                set r4 = r4 + 0.03
                            endif
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null or check > 0
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                    call GroupAddUnit(g2, u)
                                    call dmgmag(c, u, dmg)
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        endif
                    endif
                else
                    if k2 == 2 then
                    call StopSpellUnit(c)
                    endif                    
                    call SetUnitAnimation(c, "stand")
                    call StopSpellUnit2(c)
                    call DestroyGroup( g )
                    set g = null
                    call DestroyGroup( g2 )
                    set g2 = null
                    set c = null
                    set u = null
                    set m_NatsuQ[i] = m_NatsuQ[ MUI_NatsuQ]
                    set MUI_NatsuQ = MUI_NatsuQ - 1
                    if MUI_NatsuQ == -1 then
                        call PauseTimer( t_NatsuQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method NatsuQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            local integer kkk = 0
            set MUI_NatsuQ = MUI_NatsuQ + 1
            set m_NatsuQ[ MUI_NatsuQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set r3 = 1
            set k2 = 0
            set check = 0
            call DebugUnit2(c)
            set move = 60
            set g = CreateGroup()
            set g2 = CreateGroup()
            set fly = 0
            set fly = 130

            set scale = 0.25
            call SetUnitAnimationByIndex( c , 17)
            set r3 = 1
            set r4 = 1
            set u = null
            if LoadInteger(hs, GetHandleId(c), StringHash("rev q")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("mode g")) > 0 then
                set k2 = 2
            elseif LoadInteger(hs, GetHandleId(c), StringHash("mode g")) > 0 then
                set k2 = 1
            endif
            set a = GAngle2( c , x , y ) // Angle Between points
            set check = 0
            set aoe = NatsuQ_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( NatsuQ_DamageAgiBase + ( NatsuQ_DamageAgiStep * ( GetUnitAbilityLevel( c , NatsuQ_ID) - 1 ) ) )
            set dmg = dmg + NatsuQ_Damage2StaticBase + ( NatsuQ_Damage2StaticStep * ( GetUnitAbilityLevel( c , NatsuQ_ID) - 1 ) )
            if k2 == 2 then
                set r_prepare = 2.4
                set aoe = NatsuQ_DamageAoe + 175
                call DebugUnit(c)
                call MakeSound("war3mapimported\\Hero_Natsu_GQ")
                call SetUnitTimeScale( c , 0.135)
                set dmg = dmg + GetHeroAgi(c, true) * NatsuGQ2_DamageAgiBonus
                call MyRemoveEff(EffectSpawnScale("war3mapImported\\wos_yellowspark.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 0.5, 200, 0.51, 0.5, 2), r_prepare + 0.39)
                call EffectSpawn2("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_1.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 0.35, 1, r_prepare + 0.39)
            elseif k2 == 1 then
                set dmg = dmg + GetHeroAgi(c, true) * NatsuGQ_DamageAgiBonus
                set r_prepare = 1.02
                set aoe = NatsuQ_DamageAoe + 150
                call MakeSound("war3mapimported\\Hero_Natsu_GQ_01")
                call SetUnitTimeScale( c , 0.5)
            elseif k2 == 0 then
                set r_prepare = 0.63
                call MakeSound("war3mapimported\\Hero_Natsu_Q")
                call SetUnitTimeScale( c , 1)
            endif
            set rmax = r_prepare + 1.5
            call SetUnitFacing( c , a * bj_RADTODEG)
            set r7 = 0
            if MUI_NatsuQ == 0 then
                call TimerStart( t_NatsuQ, 0.03, true, function thistype.Loop_NatsuQ)
            endif
        endmethod
    endstruct

    private struct NatsuW_KS
        private static timer t_NatsuW = CreateTimer( )
        private static integer array m_NatsuW
        private static integer MUI_NatsuW = -1
        unit c
        unit td
        real x
        real y
        integer k2
        real dmg
        real move
        real r
        effect e
        effect e2
        effect e3
        real a
        real rmax
        private static method Loop_NatsuW takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_NatsuW
                set this = m_NatsuW[i]
                if SpellBoolCaster(c) and r <= rmax and SpellBoolCaster(td) then
                    set r = RoundReal(r + 0.03, 3)
                    set a = GAngle(c, td)
                    call SetUnitFacing(c, a * bj_RADTODEG)
                    if r > 0.45 then
                        if SR2(c, td) > 100 then
                            call MoveUnit(c, move, a)
                        else
                            call dmgphys(c, td, dmg)
                            call StunUnit(c,td,NatsuW_Stun)
                            call MUE(td, NatsuW_PushRange, NatsuW_PushDuration, a)
                            if k2 == 1 then
                                call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_Opdef (264).mdl", GetUnitX(td) + 150 * Cos(a), GetUnitY(td) + 150 * Sin(a), 1, 1.25, 0.1, 100, 0.3, 0.1, 0.5), 0.21, 255, 255, 255, 0.51)
                                call MakeSound("war3mapimported\\Hero_Natsu_W3")
                            else
                                call MakeSound("war3mapimported\\Hero_Natsu_W4")
                            endif
                            call DecorRemove(c, x, y, 350, 20)
                            set r = 99999
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_effect_yuzhiboyou_fire_babangouyu_1_kong.mdx", GetUnitX(td) + 100 * Cos(a), GetUnitY(td) + 100 * Sin(a), 1, 1.25, 1, 150))
                            call EUTU2(EffectSpawn("war3mapImported\\wos_firefly-rw-sfx4.mdl", GetUnitX(td), GetUnitY(td), 100, 2, 2, 30), 1.5, 30, td)
                            call EUTU2(EffectSpawn("war3mapImported\\wos_firefly-rq-sfx2.mdl", GetUnitX(td), GetUnitY(td), 100, 1, 1.65, 150), 1.5, 150, td)
                        endif
                    endif
                else
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call StopSpellUnit2(c)
                    if k2 == 1 then
                        call DestroyEffect(e3)
                    endif
                    set c = null
                    set td = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set m_NatsuW[i] = m_NatsuW[ MUI_NatsuW]
                    set MUI_NatsuW = MUI_NatsuW - 1
                    if MUI_NatsuW == -1 then
                        call PauseTimer( t_NatsuW)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method NatsuW_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_NatsuW = MUI_NatsuW + 1
            set m_NatsuW[ MUI_NatsuW] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set k2 = 0
            set move = 50
            set rmax = 3
            call StartSpellUnit2(c)
            call SetUnitAnimationByIndex( c , 14)
            call SetUnitTimeScale(c, 0.35)
            if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) > 0 then
                set k2 = 1
                set e3 = AddSpecialEffectTarget("war3mapImported\\wos_lightningeff.mdl", c, "hand right")
                call MakeSound("war3mapimported\\Hero_Natsu_W2")
            else
                call MakeSound("war3mapimported\\Hero_Natsu_W")
            endif
            set dmg = GetHeroAgi( c , true) * ( NatsuW_DamageAgiBase + ( NatsuW_DamageAgiStep * ( GetUnitAbilityLevel( c , NatsuW_ID) - 1 ) ) )
            set dmg = dmg + NatsuW_Damage2StaticBase + ( NatsuW_Damage2StaticStep * ( GetUnitAbilityLevel( c , NatsuW_ID) - 1 ) )
            if k2 == 2 then
                set dmg = dmg + GetHeroAgi(c, true) * NatsuGW_DamageAgiBonus
            endif
            set e = AddSpecialEffectTarget("war3mapImported\\war3mapImported\\wos_windwalk fire2.mdl", c, "hand right")
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_File00000712.mdl", c, "hand right")
            if MUI_NatsuW == 0 then
                call TimerStart( t_NatsuW, 0.03, true, function thistype.Loop_NatsuW)
            endif
        endmethod
    endstruct

    private struct NatsuE_KS
        private static timer t_NatsuE = CreateTimer( )
        private static integer array m_NatsuE
        private static integer MUI_NatsuE = -1
        unit c
        real x
        real y
        real r2
        integer k
        integer k2
        real r3
        real r4
        real r5
        real r7
        real fly
        group g
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
        private static method Loop_NatsuE takes nothing returns nothing
            local integer this
            local integer i = 0
            local real kk = 72
            loop
                exitwhen i > MUI_NatsuE
                set this = m_NatsuE[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r == 0.18 then
                        if k2 == 1 then
                            set e3 = AddSpecialEffectTarget("war3mapImported\\wos_lb_hg2-E12B5.mdx", c, "hand right")
                            set e4 = AddSpecialEffectTarget("war3mapImported\\wos_chushou_by_wood_yellow_xuli.mdl", c, "hand right")
                        else
                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_firefly-rq-sfx2.mdl", c, "hand right"))
                        endif
                        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_firefly-rq-sfx2.mdl", c, "hand left"))
                    endif
                    if r == 0.3 then
                        set k = 0
                        set kk = 72
                        loop
                            exitwhen k == 5
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c) + 150 * Cos(kk * k * bj_DEGTORAD), GetUnitY(c) + 150 * Sin(kk * k * bj_DEGTORAD), kk * k + 180, 1, 2, 3, 255, 255, 255, 75))
                            set k = k + 1
                        endloop
                    endif
                    if r > 0.21 and r < 0.51 then
                        call DebugUnit(c)
                        call SetFly(c, GetUnitFlyHeight(c) + 35)
                    endif
                    if r == 0.69 then
                        call DestroyEffect(e3)
                        call DestroyEffect(e4)
                        if k2 == 1 then
                            set e2 = EffectSpawn("war3mapImported\\wos_lb_hg2-E12B5.mdl", GetUnitX(c), GetUnitY(c), 1, 1, 2.15, GetUnitFlyHeight(c) + 250)
                        endif
                        set e = EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_3.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 0.6, GetUnitFlyHeight(c) + 250)
                    endif
                    if r == 0.9 then
                        set move = SR3(c, x, y)
                        set fly = GetUnitFlyHeight(c) + 250
                        set r7 = fly
                        set fly = fly / 17
                        set move = move / 18
                    endif
                    if r == 0.9 then
                        call SetUnitTimeScale(c, 1)
                        call SetUnitAnimationByIndex(c, 27)
                        if k2 == 1 then
                            call MakeSound("war3mapimported\\Hero_Natsu_GE2")
                        endif
                    endif
                    if r == 1.02 then
                        call StopSpellUnit(c)
                        call HeightSet(c, 0.33, 0)
                    endif
                    if r >= 1.02 and r <= 1.5 then
                        call MoveEff(e, move, a)
                        set r7 = r7 - fly
                        if k2 == 1 then
                            call MoveEff(e2, move, a)
                            call BlzSetSpecialEffectHeight(e2, r7)
                        endif
                        call BlzSetSpecialEffectHeight(e, r7)
                        if r5>0.03 then 
                        set r5 = 0
                        call VisionTimed(GetOwningPlayer(c),GetEffX(e),GetEffY(e),aoe,1.5)
                        else
                        set r5 = r5 + 0.03
                        endif
                    endif
                    if r == 1.5 then
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        set r3 = 10
                        call VisionTimed(GetOwningPlayer(c),x,y,aoe*2.5,3)
                        if k2 == 1 then
                            call MakeSound("war3mapimported\\Hero_Natsu_GE3")
                            call EffectSpawn2("war3mapImported\\wos_yellowspark.mdl", x + 350 * Cos(120 * bj_DEGTORAD), y + 350 * Sin(120 * bj_DEGTORAD), GetRandomReal(0, 359), 1, 3, 200, 1.2)
                            call EffectSpawn2("war3mapImported\\wos_yellowspark.mdl", x + 350 * Cos(240 * bj_DEGTORAD), y + 350 * Sin(240 * bj_DEGTORAD), GetRandomReal(0, 359), 1, 3, 200, 1.2)
                            call EffectSpawn2("war3mapImported\\wos_yellowspark.mdl", x + 350 * Cos(360 * bj_DEGTORAD), y + 350 * Sin(360 * bj_DEGTORAD), GetRandomReal(0, 359), 1, 3, 200, 1.2)
                        else
                            call MakeSound("war3mapimported\\Hero_Natsu_E2")
                        endif
                        call ScaleEffDummy(e, rmax - r, 0.6, 2)
                        call EffectSpawn2("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_1.mdl", x, y, GetRandomReal(0, 359), 1, 1.35, 1, rmax + 0.35 - r)
                    endif
                    if r > 1.5 then
                        if r3 > 0.15 then
                            set r3 = 0
                            if k2 == 1 then 
                            call DecorRemove(c, x, y, aoe * 1.25, 50)
                            else
                            call DecorRemove(c, x, y, aoe * 1.25, 25)
                            endif
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    call dmgmag(c, u, dmg)
                                    if k2 == 1 then 
                                    call ErzaPassive(c,u,5)
                                    else
                                    call ErzaPassive(c,u,1)                                    
                                    endif
                                    call SlowUnit(c, u, NatsuE_Slow, NatsuE_Duration)
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        else
                            set r3 = r3 + 0.03
                        endif
                        if r4 > 0.75 then
                            set r4 = 0
                            if k2 == 1 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_ljq_jn_lsfgxs02.mdl", x, y, GetRandomReal(0, 359), 4, 0.8, 1))
                            endif
                        else
                            set r4 = r4 + 0.03
                        endif
                        if r2 > 0.35 then
                            set r2 = 0
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_t8_by_wood_effect_order_dange_daoguang_baozha_2_2_clear.mdl", x, y, GetRandomReal(0, 359), 1, 1.33, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdl", x, y, GetRandomReal(0, 359), 1, 2.85, 1))
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    if r < 1.02 then
                        call StopSpellUnit(c)
                        call HeightSet(c, 0.21, 0)
                    endif
                    call ScaleEffDummy(e, 0.3, 1.2, 2)
                    call BlzSetSpecialEffectTimeScale(e, 1.25)
                    call DestroyEffect(e)
                    if k2 == 1 then
                        call DestroyEffect(e2)
                        if r < 0.81 then
                            call DestroyEffect(e3)
                            call DestroyEffect(e4)
                            set e3 = null
                            set e4 = null
                        endif
                    endif
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set u = null
                    set e = null
                    set e2 = null
                    set m_NatsuE[i] = m_NatsuE[ MUI_NatsuE]
                    set MUI_NatsuE = MUI_NatsuE - 1
                    if MUI_NatsuE == -1 then
                        call PauseTimer( t_NatsuE)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method NatsuE_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_NatsuE = MUI_NatsuE + 1
            set m_NatsuE[ MUI_NatsuE] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set r4 = 10
            set aoe = NatsuE_DamageAoe
            set move = 66
            set k2 = 0
            set a = GAngle2(c, x, y)
            call StartSpellUnit(c)
            set g = CreateGroup()
            set rmax = 2.9
            set dmg = GetHeroAgi( c , true) * ( NatsuE_DamageAgiBase + ( NatsuE_DamageAgiStep * ( GetUnitAbilityLevel( c , NatsuE_ID) - 1 ) ) )
            set dmg = dmg + NatsuE_Damage2StaticBase + ( NatsuE_Damage2StaticStep * ( GetUnitAbilityLevel( c , NatsuE_ID) - 1 ) )
            if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) > 0 then
                set k2 = 1
                set dmg = dmg + GetHeroAgi(c, true) * NatsuGE_DamageAgiBonus
                call MakeSound("war3mapimported\\Hero_Natsu_GE")
            else
                call MakeSound("war3mapimported\\Hero_Natsu_E")
            endif
            set dmg = dmg / 7
            call SetUnitAnimationByIndex( c , 9)
            call SetUnitTimeScale(c, 1)
            if MUI_NatsuE == 0 then
                call TimerStart( t_NatsuE, 0.03, true, function thistype.Loop_NatsuE)
            endif
        endmethod
    endstruct

    private struct NatsuR_KS
        private static timer t_NatsuR = CreateTimer( )
        private static integer array m_NatsuR
        private static integer MUI_NatsuR = -1
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
        real r7
        real r8
        real dmg
        real dmg2
        integer check
        real r
        effect e
        effect e2
        effect e3
        effect e4
        effect e5
        real a
        real rmax
        private static method Loop_NatsuR takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr1
            local real rr2
            local real rr3
            loop
                exitwhen i > MUI_NatsuR
                set this = m_NatsuR[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit(c)
                    if r< r8 then
                    call DebugUnit(td)
                    endif
                    set a = GAngle(c, td)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call SetUnitFacing(c, a * bj_RADTODEG)
                    if r <= 3.45 then
                        if r == 0.3 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.5, 1.8, 0))
                            call PosUnit(c, x - 130 * Cos(a), y - 130 * Sin(a))
                            set e5 = EffectSpawn("war3mapImported\\wos_R_Button3.mdx", GetUnitX(c) - 100 * Cos(a + 25 * bj_DEGTORAD), GetUnitY(c) - 100 * Sin(a + 25 * bj_DEGTORAD), 270, 1.5, 1.5, 650)
                            call BlzSetSpecialEffectAlpha(e5, 0)
                            if GetLocalPlayer() == GetOwningPlayer(c) then
                                call BlzSetSpecialEffectAlpha(e5, 255)
                            endif
                            if GetLocalPlayer() == GetOwningPlayer(c) then
                                call CameraSetTargetNoise(15.0, 25.0)
                            endif
                            if GetLocalPlayer() == GetOwningPlayer(td) then
                                call CameraSetTargetNoise(15.0, 25.0)
                            endif
                        endif
                        if r == 0.3 or r == 1.8 then
                            call MakeSound("war3mapimported\\Hero_Natsu_R3")
                        endif
                        if r > 0.3 then
                        call DecorRemove(c, x, y, 450, 10)
                            call BlzSetSpecialEffectPosition(e5, GetUnitX(c) - 100 * Cos(a + 25 * bj_DEGTORAD), GetUnitY(c) - 100 * Sin(a + 25 * bj_DEGTORAD), 650)
                            if LoadInteger(hs, GetHandleId(c), StringHash("natsu r add")) == 1 and check == 0 then
                                if r7 < NatsuR_BonusMax  then
                                    set r3 = r3 - 0.0175
                                    call BlzPlaySpecialEffect(e5, ANIM_TYPE_BIRTH)
                                    call SaveInteger(hs, GetHandleId(c), StringHash("natsu r add"), 0)
                                    call SaveReal(hs, GetHandleId(c), StringHash("cd atk"), r3)
                                    set r7 = r7 + NatsuR_BonusAdd 
                                else
                                    set r7 = NatsuR_BonusMax 
                                    set check = 1
                                    call DestroyEffect(e5)
                                endif
                            endif/*
                            if r2 > r3 then
                                set r2 = 0
                                call UnitRemoveAbility(td, 'Avul')
                                call dmgphys(c, td, dmg)
                                call UnitAddAbility(td, 'Avul')
                            else
                                set r2 = r2 + 0.03
                            endif*/
                            if r4 > 0.03 + (r3 / 4) then
                                set r4 = 0
                                set rr1 = GetRandomReal( -30, 30)
                                set rr2 = GetRandomReal(310, 1000)
                                call EMUE(EffectSpawn2("war3mapImported\\wos_firefly-rr-sfx4.mdl", x, y, a * bj_RADTODEG + rr1, 1, 0.5, 100, 0.35), rr2, 0.42, a + rr1 * bj_DEGTORAD)
                                set rr1 = GetRandomReal( -30, 30)
                                set rr2 = GetRandomReal(310, 1000)
                                call EMUE(EffectSpawn2("war3mapImported\\wos_firefly-rr-sfx4.mdl", x, y, a * bj_RADTODEG + rr1, 1, 0.5, 100, 0.35), rr2, 0.42, a + rr1 * bj_DEGTORAD)
                                if k2 == 1 then
                                    set rr1 = GetRandomReal( -45, 45)
                                    set rr2 = GetRandomReal(150, 750)
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_light hit.mdl", x + rr2 * Cos(a + rr1 * bj_DEGTORAD), y + rr2 * Sin(a + rr1 * bj_DEGTORAD), a * bj_RADTODEG + rr1, 1.25, 3, 125))
                                    set rr1 = GetRandomReal( -45, 45)
                                    set rr2 = GetRandomReal(174, 625)
                                    call EffectSpawn2("war3mapImported\\wos_lb_hg2-E12B5.mdx", x + rr2 * Cos(a + rr1 * bj_DEGTORAD), y + rr2 * Sin(a + rr1 * bj_DEGTORAD), GetRandomReal(0, 359), 1, 1, 125, 0.35)
                                    set rr1 = GetRandomReal( -45, 45)
                                    set rr2 = GetRandomReal(150, 750)
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_light hit.mdl", x + rr2 * Cos(a + rr1 * bj_DEGTORAD), y + rr2 * Sin(a + rr1 * bj_DEGTORAD), a * bj_RADTODEG + rr1, 1.25, 3, 125))
                                    set rr1 = GetRandomReal( -45, 45)
                                    set rr2 = GetRandomReal(174, 625)
                                    call EffectSpawn2("war3mapImported\\wos_lb_hg2-E12B5.mdx", x + rr2 * Cos(a + rr1 * bj_DEGTORAD), y + rr2 * Sin(a + rr1 * bj_DEGTORAD), GetRandomReal(0, 359), 1, 1, 125, 0.35)
                                endif
                            else
                                set r4 = r4 + 0.03
                            endif
                            if r5 > 0.09 + (r3 / 4) then
                                set r5 = 0
                                call MUE(td, 12, 0.3, a)
                                call MUE(c, 12, 0.3, a)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", td, "chest"))
                                set rr1 = GetRandomReal( -45, 45)
                                set rr2 = GetRandomReal(314, 625)
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_fire-hit-kulouwang.mdl", x + rr2 * Cos(a + rr1 * bj_DEGTORAD), y + rr2 * Sin(a + rr1 * bj_DEGTORAD), GetRandomReal(0, 359), 1, 1.5, 125))
                                set rr1 = GetRandomReal( -55, 55)
                                set rr2 = GetRandomReal(0, 55)
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_hitheavy.mdl", x + rr2 * Cos(a + rr1 * bj_DEGTORAD), y + rr2 * Sin(a + rr1 * bj_DEGTORAD), a * bj_RADTODEG, 1, 2.25, 125))
                                set rr1 = GetRandomReal( -45, 45)
                                set rr2 = GetRandomReal(174, 625)
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_BDEF (124)2.mdx", x + rr2 * Cos(a + rr1 * bj_DEGTORAD), y + rr2 * Sin(a + rr1 * bj_DEGTORAD), GetRandomReal(0, 359), 1, 2.5, 125))
                            else
                                set r5 = r5 + 0.03
                            endif
                            if r6 > 0.15 + (r3 / 4) then
                                set r6 = 0
                                call SetUnitAnimationByIndex(c, GetRandomInt(0, 6))
                                call SetUnitAnimation(td, "death")
                                call SetUnitTimeScale(c, 3)
                                set rr1 = GetRandomReal( -35, 35)
                                set rr2 = GetRandomReal(0, 355)
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_firefly-rq-sfx2.mdl", x + rr2 * Cos(a + rr1 * bj_DEGTORAD), y + rr2 * Sin(a + rr1 * bj_DEGTORAD), GetRandomReal(0, 359), 1, 0.5, 125))
                            else
                                set r6 = r6 + 0.03
                            endif
                            if r == rmax - 0.15 then
                                if k2 == 0 then
                                   // call MakeSound("war3mapimported\\Hero_Natsu_R2")
                                endif
                                call SetUnitAnimationByIndex(c, 4)
                                call SetUnitTimeScale(c, 0.2)
                                if k2 == 1 then
                                    set e3 = AddSpecialEffectTarget("war3mapImported\\wos_lightningeff.mdl", c, "hand right")
                                    set e4 = AddSpecialEffectTarget("war3mapImported\\wos_chushou_by_wood_yellow_xuli.mdl", c, "hand right")
                                endif
                            endif
                            if r == rmax then
                                call MUE(td, NatsuR_PushRange, NatsuR_PushDuration, a)
                                if k2 == 1 then
                                    set rmax = rmax + 1.75
                                    call MakeSound("war3mapimported\\Hero_Natsu_GR2")
                                    else
                                    call StopSpellUnit(c)
                                endif
                                call StopSpellUnit(td)   
                                
                                call StunUnit(c, td, NatsuR_Stun)
                                    set dmg =dmg * (1+(r7 /100))
                                call dmgphys(c,td,dmg)
                                
                                
                            endif
                        endif
                    endif
                    if k2 == 1 then
                        if r == r8+0.51 then
                            call MakeSound("war3mapimported\\Hero_Natsu_GR3")
                        endif
                        if r > r8+0.51 then
                            if SR2(c, td) > 140 then
                                call MoveUnit(c, 70, a)
                            else
                                call EUTU2_3(EffectSpawn("war3mapImported\\wos_opdef (353).mdl", GetUnitX(td), GetUnitY(td), 1, 0.65, 1.5, 1), 1.5, 1, td)
                                call EUTU2_3(EffectSpawn("war3mapImported\\wos_papsnaz (707)1.mdl", GetUnitX(td), GetUnitY(td), 1, 1, 2, 55), 1.5, 55, td)
                                call EUTU2_3(EffectSpawn("war3mapImported\\wos_by_wood_effect_yuzhiboyou_fire_babangouyu_1_kong.mdx", GetUnitX(td), GetUnitY(td), 1, 1, 1.5, 115), 1.5, 115, td)
                                set r = 999999
                                call StunUnit(c, td, NatsuR_Stun)
                                call MUE(td, NatsuR_PushRange, NatsuR_PushDuration, a)
                                call dmgphys(c, td, dmg2)
                            endif
                        endif
                    endif
                else
                    call StopSpellUnit(c)
                    if r< r8 then 
                    call StopSpellUnit(td)
                    endif
                    call DestroyEffect(e2)
                    if k2 == 1 then
                        call DestroyEffect(e3)
                        call DestroyEffect(e4)
                    endif
                    if check == 0 then
                        call DestroyEffect(e5)
                    endif
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call CameraSetTargetNoise( 0, 0)
                    endif
                    if GetLocalPlayer() == GetOwningPlayer(td) then
                        call CameraSetTargetNoise( 0, 0)
                    endif
                    call SaveInteger(hs, GetHandleId(c), StringHash("natsu r"), 0)
                    call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("Natsu tt r x"), 0)
                    call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("Natsu tt r y"), 0)
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("Natsu tt r"), 0)
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.21)
                    set c = null
                    set td = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set e5 = null
                    set m_NatsuR[i] = m_NatsuR[ MUI_NatsuR]
                    set MUI_NatsuR = MUI_NatsuR - 1
                    if MUI_NatsuR == -1 then
                        call PauseTimer( t_NatsuR)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method NatsuR_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_NatsuR = MUI_NatsuR + 1
            set m_NatsuR[ MUI_NatsuR] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set r2 = 10
            set k2 = 0
            set r7 = 0
            set a = GAngle2(c, x, y)
            call StartSpellUnit(c)
            call StartSpellUnit(td)
            set e = AddSpecialEffectTarget("war3mapImported\\war3mapImported\\wos_windwalk fire2.mdl", c, "hand right")
            set e2 = AddSpecialEffectTarget("war3mapImported\\war3mapImported\\wos_windwalk fire2.mdl", c, "hand left")
            set rmax = 2.7
            set r8 = rmax
            set check = 0
            set r3 = 0.45
            call SaveReal(hs, GetHandleId(c), StringHash("cd atk"), r3)
            set dmg = GetHeroAgi( c , true) * ( NatsuR_DamageAgiBase + ( NatsuR_DamageAgiStep * ( GetUnitAbilityLevel( c , NatsuR_ID) - 1 ) ) )
            set dmg = dmg + NatsuR_Damage2StaticBase + ( NatsuR_Damage2StaticStep * ( GetUnitAbilityLevel( c , NatsuR_ID) - 1 ) )
            if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) > 0 then
                set k2 = 1
                set dmg2 = GetHeroAgi(c, true) * NatsuGR_DamageAgiBonus
                call MakeSound("war3mapimported\\Hero_Natsu_GR")
            else
                call MakeSound("war3mapimported\\Hero_Natsu_R")
            endif
            call SaveInteger(hs, GetHandleId(c), StringHash("natsu r"), 1)
            call SaveInteger(hs, GetHandleId(c), StringHash("natsu r add"), 0)
            call SetUnitAnimationByIndex( c , 11)
            call SetUnitTimeScale(c, 2)
            if MUI_NatsuR == 0 then
                call TimerStart( t_NatsuR, 0.03, true, function thistype.Loop_NatsuR)
            endif
        endmethod
    endstruct

    private struct NatsuT_KS
        private static timer t_NatsuT = CreateTimer( )
        private static integer array m_NatsuT
        private static integer MUI_NatsuT = -1
        unit c
        real x
        real y
        real r2
        integer k2
        real r3
        group g
        group g2
        unit u
        real dmg
        integer check
        real aoe
        real move
        real r
        real r5
        effect e
        effect e2
        effect e3
        effect e4
        effect e5
        real a
        real rmax
        private static method Loop_NatsuT takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr1 = 0
            local real rr2 = 0
            loop
                exitwhen i > MUI_NatsuT
                set this = m_NatsuT[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if r == 0.3 then
                        set x = GetUnitX(c) + 140 * Cos(a)
                        set y = GetUnitY(c) + 140 * Sin(a)
                    endif
                    if r == 0.51 then
                        call StopSpellUnit2(c)
                    endif
                    if r == 0.9 and k2 == 1 then
                        call MakeSound("war3mapimported\\Hero_Natsu_GT2")
                    endif
                    if r == 0.6 and k2 == 0 then
                        call MakeSound("war3mapimported\\Hero_Natsu_T2")
                    endif
                    if r == 0.66 then
                        call MakeSound("war3mapimported\\Hero_Natsu_T3")
                    endif
                    if r == 0.88 then
                        call MakeSound("war3mapimported\\Hero_Natsu_T4")
                    endif
                    if r == 0.51 or r == 0.57 or r == 0.66 or r == 0.75 then
                        set e3 = EffectSpawn3("war3mapImported\\wos_firefly-r1e-sfx2.mdl", x, y, a * bj_RADTODEG + 180, 2.5, 1, 230, -90)
                        call AnimDummyEff(e3, 0.65, 1)
                        set e3 = null
                    endif
                    if r > 0.51 then
                        set x = x + move * Cos(a)
                        set y = y + move * Sin(a)
                        set r5 = r5 + move 
                        if r5 > NatsuT_Range then 
                        set r = 9999
                        endif
                        if r3> 0.03 then 
                        set r3 = 0
                        call DecorRemove(c, x, y, aoe*1.5, 100)
                        call VisionTimed(GetOwningPlayer(c),x,y,aoe*2,1.5)
                        else
                        set r3 = r3 + 0.03
                        endif
                        if r2 > 0.0 then
                            set r2 = 0
                            set rr1 = GetRandomReal(115, 305)
                            if check == 0 then
                                set rr2 = a + 90 * bj_DEGTORAD
                                set check = 1
                            else
                                set rr2 = a - 90 * bj_DEGTORAD
                                set check = 0
                            endif
                            if k2 == 1 then
                                call MyRemoveEff(EffectSpawnScale("war3mapImported\\wos_lb_hg2-E12B5.mdl", x, y, GetRandomReal(0, 359), 0.5, 1, 100, 0.3, 1, 2.8), rmax + 1 - r)
                            endif
                            call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_papsnaz (1050).mdl", x, y, GetRandomReal(0, 359), 1.45, 0.01, 0, 0.3, 0.01, 1.35), 0.3, 255, 255, 255, 0.51)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_firefly-rq-sfx2.mdl", x + rr1 * Cos(rr2), y + rr1 * Sin(rr2), GetRandomReal(0, 359), 1, 1.75, GetRandomReal(150, 550)))
                        else
                            set r2 = r2 + 0.03
                        endif
                        call GroupClear( g )
                        call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                call GroupAddUnit(g2, u)
                                call dmgmag(c, u, dmg)
                                call MUE(u, NatsuT_PushRange, NatsuT_PushDuration, a)
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    endif
                else
                    if r < 0.51 then
                        call StopSpellUnit2(c)
                    endif
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    if k2 == 1 then
                        call DestroyEffect(e4)
                        call DestroyEffect(e5)
                        set e4 = null
                        set e5 = null
                    endif
                    call StopSpellUnit2(c)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set c = null
                    set e = null
                    set e2 = null
                    set g = null
                    set g2 = null
                    set u = null
                    set m_NatsuT[i] = m_NatsuT[ MUI_NatsuT]
                    set MUI_NatsuT = MUI_NatsuT - 1
                    if MUI_NatsuT == -1 then
                        call PauseTimer( t_NatsuT)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method NatsuT_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_NatsuT = MUI_NatsuT + 1
            set m_NatsuT[ MUI_NatsuT] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set r5 = 0
            call StartSpellUnit2(c)
            set rmax = 1.5
            set move = 120
            set check = 0
            set a = GAngle2(c, x, y)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set dmg = GetHeroAgi( c , true) * NatsuT_DamageAgiBase
            set aoe = NatsuT_DamageAoe
            call SetUnitAnimationByIndex( c , 10)
            call SetUnitTimeScale(c, 0.85)
            set k2 = 0
            if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) > 0 then
                call MakeSound("war3mapimported\\Hero_Natsu_GT")
                set k2 = 1
                set dmg = dmg + NatsuGT_DamageAgiBonus * GetHeroAgi(c, true)
            else
                call MakeSound("war3mapimported\\Hero_Natsu_T")
            endif
            set e = AddSpecialEffectTarget("war3mapImported\\wos_File00000712.mdl", c, "hand right")
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_File00000712.mdl", c, "hand left")
            if k2 == 1 then
                call EUTU2_3(EffectSpawn("war3mapImported\\wos_5731-sl_8bc718f-F.mdl", GetUnitX(c), GetUnitY(c), 1, 0.5, 1.45, 1), 1.5, 1, c)
                call MyRemoveEff(EffectSpawnScale("war3mapImported\\wos_lb_hg2-E12B5.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 0.5, 0.01, 30, 0.3, 0.01, 1), 1.5)
                set e4 = AddSpecialEffectTarget("war3mapImported\\wos_lightningeff.mdl", c, "hand right")
                set e5 = AddSpecialEffectTarget("war3mapImported\\wos_lightningeff.mdl", c, "hand left")
            endif
            if MUI_NatsuT == 0 then
                call TimerStart( t_NatsuT, 0.03, true, function thistype.Loop_NatsuT)
            endif
        endmethod
    endstruct

    private struct NatsuG2_KS
        private static timer t_NatsuG2 = CreateTimer( )
        private static integer array m_NatsuG2
        private static integer MUI_NatsuG2 = -1
        unit c
        real x
        real y
        integer k2
        framehandle array frame_pas1 [10]
        framehandle array frame_pas2 [10]
        framehandle array frame_pas3 [10]
        framehandle array frame_pas4 [10]
        framehandle array frame_pas5 [10]
        framehandle array frame_pas6 [10]
        real r
        effect e
        effect e2
        effect e3
        real rmax
        private static method Loop_NatsuG2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_NatsuG2
                set this = m_NatsuG2[i]
                if SpellBoolCaster(c) and r <= rmax and CheckCoordsInRect(gg_rct_Base,GetUnitX(c),GetUnitY(c))== false then
                    if IsUnitPaused(c) == false then
                        set r = RoundReal(r + 0.03, 3)
                    endif
                    set r = S2R( R2SW( r , 0, 3 ) )
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    call BlzSetSpecialEffectPosition(e, x, y, GetUnitFlyHeight(c) + 105 )
                    call BlzSetSpecialEffectPosition(e2, x, y, GetUnitFlyHeight(c) + 15)
                    call BlzSetSpecialEffectPosition(e3, x, y, GetUnitFlyHeight(c) + 125)
                    call BlzFrameSetValue(frame_pas3[k2], rmax - (r + 0.1))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                else
                if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame_pas1[k2], false)
                    endif
                    call IssueImmediateOrder(c,"stop")
                    call BlzSetAbilityIcon(Natsu_ID,"ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_Icon.blp")
                    call BlzSetAbilityIcon(NatsuQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_Q.blp")
                    call BlzSetAbilityIcon(NatsuW_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_W.blp")
                    call BlzSetAbilityIcon(NatsuE_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_E.blp")
                    call BlzSetAbilityIcon(NatsuR_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_R.blp")
                    call BlzSetAbilityIcon(NatsuT_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_T.blp")
                    call SaveInteger(hs, GetHandleId(c), StringHash("mode g"), 0)
                    call EUTU2_3(e, 0.3, 0, c)
                    call DestroyEffect(e2)
                    call DestroyEffect(e3)
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set m_NatsuG2[i] = m_NatsuG2[ MUI_NatsuG2]
                    set MUI_NatsuG2 = MUI_NatsuG2 - 1
                    if MUI_NatsuG2 == -1 then
                        call PauseTimer( t_NatsuG2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method NatsuG2_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_NatsuG2 = MUI_NatsuG2 + 1
            set m_NatsuG2[ MUI_NatsuG2] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set rmax = NatsuG_Duration
         //   call BlzStartUnitAbilityCooldown(c, NatsuQ_ID, 0.01)
            set e = EffectSpawn("war3mapImported\\wos_Raienryuu no Houkou.mdl", x, y, 1, 1, 1.35, 1)
            set e2 = EffectSpawn("war3mapImported\\wos_lb_hg2-E12B5.mdl", x, y, 1, 0.35, 0.5, 15)
            set e3 = EffectSpawn("war3mapImported\\wos_lb_hg2-E12B5.mdl", x, y, 90, 0.35, 0.4, 125)
            call SaveInteger(hs, GetHandleId(c), StringHash("mode g"), 1)
            call BlzSetAbilityIcon(Natsu_ID,"ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_Icon2.blp")
            call BlzSetAbilityIcon(NatsuQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_GQ.blp")
            call BlzSetAbilityIcon(NatsuW_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_GW.blp")
            call BlzSetAbilityIcon(NatsuE_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_GE.blp")
            call BlzSetAbilityIcon(NatsuR_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_GR.blp")
            call BlzSetAbilityIcon(NatsuT_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_GT.blp")
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
                                call BlzFrameSetValue(frame_pas3[k2], rmax)
                                set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18)
                                call BlzFrameSetSize(frame_pas4[k2], 0.0275, 0.0275)
                                call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_Icon2", 0, false)
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
                                call BlzFrameSetValue(frame_pas3[k2], rmax)
                            endif
            if MUI_NatsuG2 == 0 then
                call TimerStart( t_NatsuG2, 0.03, true, function thistype.Loop_NatsuG2)
            endif
        endmethod
    endstruct

    private struct NatsuG_KS
        private static timer t_NatsuG = CreateTimer( )
        private static integer array m_NatsuG
        private static integer MUI_NatsuG = -1
        unit c
        real x
        real y
        real r2
        integer k2
        real scale
        real r4
        real r5
        real r7
        real fly
        group g
        unit u
        integer check
        integer check2
        real aoe
        real r
        effect e
        effect e2
        real a
        private static method Loop_NatsuG takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_NatsuG
                set this = m_NatsuG[i]
                if GetUnitCurrentOrder(c) == OrderId("creepheal") then
                    set r = r + 0.05
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    set r4 = GetRandomReal(0.5, 1)
                    if r2 > 0.4 and k2 == 1 then
                        set r2 = 0
                        call EffectSpawn2("war3mapImported\\wos_yellowspark.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 1.9, 200, 0.4)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdl", x, y, GetRandomReal(0, 359), 1, 1.85, 5))
                    else
                        set r2 = r2 + 0.05
                    endif
                    if r == 0.05 then 
                    if GetHeroLevel(c) >= NatsuG_LvlReq then
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), NatsuG_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), NatsuG2_ID, true)
                    call UnitAddAbility(c, NatsuG2_ID)
                endif
                    endif 
                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_bdef (383).mdx", x, y, GetRandomReal(0, 359), r4, 1.25, 5, 255, 255, 255, 105))
                    call GroupClear( g )
                    call GroupEnumUnitsInRange( g , x , y , aoe , null)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if GetUnitAbilityLevel(u, 'Avul') > 0 and GetUnitTypeId(u) == Fire_ID and GetUnitAbilityLevel(u, 'Aloc') == 0 then
                            call MUE(u, SR3(u, x, y), 0.66, GAngle2(u, x, y))
                            call SetAnim(u, 0.66, "death")
                            call PauseUnit(u, true)
                            call MyRemoveUnit(u, 1.25)
                            call UnitAddAbility(u, 'Aloc')
                            set check = check + 1
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    set u = null
                    if r == 2.8 and k2 == 1 then
                        call SaveInteger(hs, GetHandleId(c), StringHash("rev q"), 1)
                        call MyFlush(GetHandleId(c), StringHash("rev q"), 0, 5)
                        call DisplayTimedTextToPlayer(GetOwningPlayer(c), 0, 0, 1, "|c00FF8040You have 5 sec to use enchanced Q|r")
                    endif
                else
                    if k2 == 1 then
                        call DestroyEffect(e2)
                        set e2 = null
                    endif
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), NatsuG2_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), NatsuG_ID, true)
                    call StopSound(gg_snd_Hero_Natsu_G, false, false)
                    set r5 = check * 100
                    set r7 = check * NatsuG_CdReduceTime
                    call SetMpCurrent(c, r5)
                    call ReduceCooldown(c, NatsuQ_ID, r7)
                    call ReduceCooldown(c, NatsuW_ID, r7)
                    call ReduceCooldown(c, NatsuE_ID, r7)
                    if check == 0 and check2 == 0 then
                        call DisplayTimedTextToPlayer(GetOwningPlayer(c), 0, 0, 1, "|c00FF0000No flame absorbed|r")
                    elseif check > 0 then
                    if k2 == 0 then 
                    call MakeSound("war3mapimported\\Hero_Natsu_Pick5")
                    endif
                        call DisplayTimedTextToPlayer(GetOwningPlayer(c), 0, 0, 1, "|c00FF0000Restored|r |c000042FF" + I2S(R2I(r5)) + "|r |c00FF0000mana and reduced ongoing Q W E cd for|r |c00FFFC01" + I2S(R2I(r7)) + "|r |c00FF0000sec|r")
                    endif
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.21)
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set e = null
                    set m_NatsuG[i] = m_NatsuG[ MUI_NatsuG]
                    set MUI_NatsuG = MUI_NatsuG - 1
                    if MUI_NatsuG == -1 then
                        call PauseTimer( t_NatsuG)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method NatsuG_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_NatsuG = MUI_NatsuG + 1
            set m_NatsuG[ MUI_NatsuG] = this
            set c = NewC
            set g = CreateGroup()
            set u = null
            set check = 0
            set check2 = 0
            set r = 0
            set k2 = 0
            set r2 = 40
            set aoe = NatsuG_Aoe
            set a = GetUnitFacing(c) * bj_DEGTORAD
            set x = GetUnitX(c) + 10 * Cos(a)
            set y = GetUnitY(c) + 10 * Sin(a)
            set scale = 0.75
            set fly = 15
            call SetUnitFacing(c, a * bj_RADTODEG)
            call SetUnitTimeScale(c, 0.5)
            call SetUnitAnimationByIndex(c, 15)
            if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) == 1 then
                call StartSound(gg_snd_Hero_Natsu_GQ0)
                call SetUnitTimeScale(c, 0.35)
                set k2 = 1
                set e2 = EffectSpawn3("war3mapImported\\wos_models (117)yellow_clear.mdl", x, y, a * bj_RADTODEG + 180, 2, 1.75, 145, -90)
                set scale = 1
                set fly = 0
            else
                
                call StartSound(gg_snd_Hero_Natsu_G)
            endif
            set e = EffectSpawn("war3mapimported\\wos_firacharge.mdl", x, y, a, 1, scale, fly)
            if MUI_NatsuG == 0 then
                call TimerStart( t_NatsuG, 0.05, true, function thistype.Loop_NatsuG)
            endif
        endmethod
    endstruct

    private struct NatsuPas_KS
        private static timer t_NatsuPas = CreateTimer( )
        private static integer array m_NatsuPas
        private static integer MUI_NatsuPas = -1
        unit c
        real x
        real y
        integer k2
        real scale
        real fly
        framehandle array frame2_pas1 [10]
        framehandle array frame2_pas2 [10]
        framehandle array frame2_pas3 [10]
        framehandle array frame2_pas4 [10]
        framehandle array frame2_pas5 [10]
        framehandle array frame2_pas6 [10]
        real r
        effect e
        real a
        real rmax
        private static method Loop_NatsuPas takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_NatsuPas
                set this = m_NatsuPas[i]
                if SpellBoolCaster(c) and r <= rmax and CheckCoordsInRect(gg_rct_Base,GetUnitX(c),GetUnitY(c))== false then
                    if IsUnitPaused(c) == false then
                        set r = RoundReal(r + 0.03, 3)
                    endif
                    if r == 0.03 then                     
                call BlzStartUnitAbilityCooldown(c,NatsuFR_ID,BlzGetUnitAbilityCooldownRemaining(c,NatsuR_ID))
                call BlzStartUnitAbilityCooldown(c,NatsuFT_ID,BlzGetUnitAbilityCooldownRemaining(c,NatsuT_ID))
                    endif
                    if r == 0.06 then 
                    call ReduceCooldown(c, NatsuFT_ID, NatsuF_CdReduceTime)
                    call ReduceCooldown(c, NatsuFR_ID, NatsuF_CdReduceTime)
                    endif
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    call BlzSetSpecialEffectPosition(e, x, y, GetUnitFlyHeight(c) + fly)
                    call BlzFrameSetValue(frame2_pas3[k2], rmax - (r + 0.1))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                else
                if GetUnitCurrentOrder(c) == OrderId("ancestralspirittarget") or GetUnitCurrentOrder(c) == OrderId("awaken") then
                call IssueImmediateOrder(c,"stop")
                endif
                if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame2_pas1[k2], false)
                    endif
                    call UnitRemoveAbility(c, NatsuF_Stats_ID)
                    if GetUnitAbilityLevel(c, NatsuR_ID) > 0 then
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), NatsuFR_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), NatsuFT_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), NatsuR_ID, true)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), NatsuT_ID, true)
                        
                call BlzStartUnitAbilityCooldown(c,NatsuR_ID,BlzGetUnitAbilityCooldownRemaining(c,NatsuFR_ID))
                call BlzStartUnitAbilityCooldown(c,NatsuT_ID,BlzGetUnitAbilityCooldownRemaining(c,NatsuFT_ID))
                    endif
                    call DestroyEffect(e)
                    set c = null
                    set e = null
                    set m_NatsuPas[i] = m_NatsuPas[ MUI_NatsuPas]
                    set MUI_NatsuPas = MUI_NatsuPas - 1
                    if MUI_NatsuPas == -1 then
                        call PauseTimer( t_NatsuPas)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method NatsuPas_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_NatsuPas = MUI_NatsuPas + 1
            set m_NatsuPas[ MUI_NatsuPas] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set rmax = NatsuF_Duration
            set fly = 10
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set scale = 1
            call MakeSound("war3mapimported\\Hero_Natsu_F")
            call UnitAddAbility(c, NatsuF_Stats_ID)
            call UnitMakeAbilityPermanent(c, true, NatsuF_Stats_ID)
            set e = EffectSpawn("war3mapImported\\wos_by_wood_effect_order_dange_dbz_chaosaiguanghuan_1_3.mdl", x, y, a, 1, scale, fly)
            call BlzStartUnitAbilityCooldown(c, NatsuW_ID, 0.01)
            if GetUnitAbilityLevel(c, NatsuR_ID) > 0 then
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), NatsuFR_ID, true)
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), NatsuFT_ID, true)
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), NatsuR_ID, false)
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), NatsuT_ID, false)
                call UnitAddAbility(c, NatsuFR_ID)
                call SetUnitAbilityLevel(c,NatsuFR_ID,GetUnitAbilityLevel(c,NatsuR_ID))
                if GetUnitAbilityLevel(c, NatsuT_ID) > 0 then
                    call UnitAddAbility(c, NatsuFT_ID)
                    //call ReduceCooldown(c, NatsuFT_ID, NatsuF_CdReduceTime)
                endif
                //call ReduceCooldown(c, NatsuFR_ID, NatsuF_CdReduceTime)
            endif
            if frame2_pas1[k2] == null then
                                set frame2_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.2175)
                                call BlzFrameSetSize(frame2_pas1[k2], 0.135, 0.035)
                                call BlzFrameSetTexture(frame2_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                                call BlzFrameSetVisible(frame2_pas1[k2], false)
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame2_pas1[k2], true)
                                endif
                                set frame2_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame2_pas1[k2], 0, 0)
                                call BlzFrameSetAbsPoint(frame2_pas2[k2], FRAMEPOINT_CENTER, 0.07, 0.2225)
                                call BlzFrameSetSize(frame2_pas2[k2], 0.1, 0.019)
                                set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)
                                call BlzFrameSetSize(frame2_pas3[k2], 0.1, 0.035)
                                call BlzFrameSetScale(frame2_pas3[k2], 0.5)
                                call BlzFrameSetModel(frame2_pas3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                                call BlzFrameSetAbsPoint(frame2_pas3[k2], FRAMEPOINT_CENTER, 0.05, 0.2125)
                                call BlzFrameSetMinMaxValue(frame2_pas3[k2], 0, rmax)
                                call BlzFrameSetValue(frame2_pas3[k2], rmax)
                                set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.2175)
                                call BlzFrameSetSize(frame2_pas4[k2], 0.03, 0.03)
                                call BlzFrameSetTexture(frame2_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Natsu_F", 0, false)
                                set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.2225)
                                call BlzFrameSetText(frame2_pas5[k2], "|c00FFFF00" + "Flame of Emotion:" + "|r")
                                call BlzFrameSetScale(frame2_pas5[k2], 0.9)
                                set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.2075)
                                call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                                call BlzFrameSetScale(frame2_pas6[k2], 0.9)
                            else
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame2_pas1[k2], true)
                                endif
                                call BlzFrameSetValue(frame2_pas3[k2], rmax)
                            endif
            if MUI_NatsuPas == 0 then
                call TimerStart( t_NatsuPas, 0.03, true, function thistype.Loop_NatsuPas)
            endif
        endmethod
    endstruct

    private struct NatsuFR_KS
        private static timer t_NatsuFR = CreateTimer( )
        private static integer array m_NatsuFR
        private static integer MUI_NatsuFR = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k2
        integer k3
        real r3
        group g
        real dmg
        real dmg2
        integer check
        real move
        real r
        effect e
        effect e2
        effect e3
        real a
        real rmax
        private static method Loop_NatsuFR takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr1
            local real rr2
            local real rr3
            local real add = 0.51
            loop
                exitwhen i > MUI_NatsuFR
                set this = m_NatsuFR[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and IsUnitType(td,UNIT_TYPE_DEAD)== false and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit(c)
                    if check == 5 then 
                    call DebugUnit(td)
                    endif
                    set a = GAngle(c, td)
                    if check < 5 then
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                    endif
                    call SetUnitFacing(c, a * bj_RADTODEG)
                    if check == 0 then
                        if r == 0.3 then
                            call SetUnitAnimationByIndex(c, 4)
                            call SetUnitTimeScale(c, 0.5)
                                set move = 45
                        endif
                        if r > 0.45 then
                            if SR2(c, td) > 100 then
                                call MoveUnit(c, move, a)
                            else
                                set check = 1
                                set r = 0
                                set move = 45
                                call MUE(td, 190, 0.6, a)
                                call MakeSound("war3mapimported\\Hero_Natsu_FR2")
                                call DecorRemove(c, x, y, 450, 40)
                                call VisionTimed(GetOwningPlayer(c),x,y,450,1.5)
                                if k2 == 1 then
                                    call EUTU2(EffectSpawn("war3mapImported\\wos_lb_hg2-E12B5.mdl", GetUnitX(td), GetUnitY(td), 100, 0.67, 0.85, 40), 1, 35, td)
                                endif
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_effect_yuzhiboyou_fire_babangouyu_1_kong.mdx", GetUnitX(td) + 100 * Cos(a), GetUnitY(td) + 100 * Sin(a), 1, 1.25, 1, 120))
                                call SetUnitAnimation(td, "death")
                                call dmgphys(c, td, dmg)
                                call StunUnit(c,td,NatsuFR_Stun)
                                endif
                        endif
                    elseif check == 1 then
                        if r == 0.45 then
                            call SetUnitAnimationByIndex(c, 5)
                            call SetUnitTimeScale(c, 0.5)
                        endif
                        if r > 0.6 then
                            if SR2(c, td) > 100 then
                                call MoveUnit(c, move, a)
                            else
                                set check = 2
                                set r = 0
                                call MUE(td, 190, 0.6, a)
                                call MakeSound("war3mapimported\\Hero_Natsu_FR3")
                                call DecorRemove(c, x, y, 450, 40)
                                call VisionTimed(GetOwningPlayer(c),x,y,450,1.5)
                                if k2 == 1 then
                                    call EUTU2(EffectSpawn("war3mapImported\\wos_a_light_hity.mdl", GetUnitX(td), GetUnitY(td), 100, 0.67, 1.85, 40), 1, 35, td)
                                endif
                                call EUTU2(EffectSpawn("war3mapImported\\wos_firefly-rw-sfx4.mdl", GetUnitX(td), GetUnitY(td), 100, 2, 1.5, 30), 1.5, 30, td)
                                call EUTU2(EffectSpawn("war3mapImported\\wos_firefly-rq-sfx2.mdl", GetUnitX(td), GetUnitY(td), 100, 1, 1.15, 150), 1.5, 150, td)
                                call SetUnitAnimation(td, "death")
                                call StunUnit(c,td,NatsuFR_Stun)
                                call dmgphys(c, td, dmg)
                                endif
                        endif
                    elseif check == 2 then
                        if r == 0.45 then
                            call SetUnitAnimationByIndex(c, 7)
                        endif
                        if r > 0.6 then
                            if SR2(c, td) > 100 then
                                call MoveUnit(c, move, a)
                            else
                                set check = 3
                                set r = 0
                                call MUE(td, 190, 0.6, a)
                                call SetUnitAnimation(td, "death")
                                call MakeSound("war3mapimported\\Hero_Natsu_FR4")
                                call DecorRemove(c, x, y, 450, 40)
                                call VisionTimed(GetOwningPlayer(c),x,y,450,1.5)
                                if k2 == 1 then
                                    call EUTU2(EffectSpawn("war3mapImported\\wos_a_light_hity.mdl", GetUnitX(td), GetUnitY(td), GetRandomReal(0, 359), 0.67, 1.5, 40), 1, 35, td)
                                endif
                                call EUTU2(EffectSpawn("war3mapImported\\wos_t8_by_wood_effect_order_dange_daoguang_baozha_2_2_clear.mdl", GetUnitX(td), GetUnitY(td), 100, 1, 1, 30), 1.5, 20, td)
                                call EUTU2_3(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdl", GetUnitX(td), GetUnitY(td), 100, 0.5, 1.25, 55), 1, 55, td)
                                call StunUnit(c,td,NatsuFR_Stun)
                                call dmgphys(c, td, dmg)
                            endif
                        endif
                    elseif check == 3 then
                        if r == 0.45 then
                            call SetUnitTimeScale(c, 1.5)
                            call SetUnitAnimationByIndex(c, 25)
                        endif
                        if r > 0.6 then
                            if SR2(c, td) > 100 then
                                call MoveUnit(c, move, a)
                            else
                                set check = 4
                                set r = 0
                                call SetUnitAnimation(td, "death")
                                call MUE(td, 290, 0.6, a)
                                call MakeSound("war3mapimported\\Hero_Natsu_FR5")
                                call DecorRemove(c, x, y, 450, 40)
                                call VisionTimed(GetOwningPlayer(c),x,y,450,1.5)
                                if k2 == 1 then
                                    call EUTU2(EffectSpawn("war3mapImported\\wos_a_light_hity.mdl", GetUnitX(td), GetUnitY(td), GetRandomReal(0, 359), 0.67, 1.5, 40), 1, 35, td)
                                endif
                                call DestroyEffect(EffectSpawn("war3mapImported\\papsnaz (484).mdl", GetUnitX(td), GetUnitY(td), a * bj_RADTODEG, 1.2, 0.45, 110))
                                call EUTU2(EffectSpawn("war3mapImported\\wos_firefly-rq-sfx2.mdl", GetUnitX(td), GetUnitY(td), 100, 2, 1.25, 150), 1.5, 1, td)
                                call StunUnit(c,td,NatsuFR_Stun)
                                call dmgphys(c, td, dmg)
                            endif
                        endif
                    elseif check == 4 then
                        if r == 0.36 then
                            call SetUnitAnimationByIndex(c, 1)
                            call SetUnitTimeScale(c, 0.3)
                        endif
                        if r > 0.6 then
                            if SR2(c, td) > 100 then
                                call MoveUnit(c, move, a)
                            else
                                
                                call SetUnitAnimation(td, "death")
                                call MUE(td, 190, 0.6, a)
                                call MakeSound("war3mapimported\\Hero_Natsu_FR6")
                                call DecorRemove(c, x, y, 450, 40)
                                call VisionTimed(GetOwningPlayer(c),x,y,450,1.5)
                                if k2 == 1 then
                                    call EUTU2(EffectSpawn("war3mapImported\\wos_lb_hg2-E12B5.mdl", GetUnitX(td), GetUnitY(td), 100, 0.67, 1.35, 40), 1, 35, td)
                                endif
                                call EUTU2(EffectSpawn("war3mapImported\\wos_papsnaz (707).mdl", GetUnitX(td), GetUnitY(td), 100, 0.8, 0.65, 150), 1.5, 25, td)
                                call EUTU2(EffectSpawn("war3mapImported\\wos_firefly-rq-sfx2.mdl", GetUnitX(td), GetUnitY(td), 100, 1, 2.15, 150), 1.5, 1, td)
                                call StunUnit(c,td,NatsuFR_Stun)
                                call dmgphys(c, td, dmg)
                                if GetUnitAbilityLevel(c,NatsuT_ID)>0 and BlzGetUnitAbilityCooldownRemaining(c, NatsuFT_ID) == 0 then
                                    set check = 5
                                    set r = 0
                                    call StartSpellUnit(td)
                                else
                                    set r = 99999
                                endif
                            endif
                        endif
                    elseif check == 5 then
                        if r == 0.81 then
                            call SetUnitAnimationByIndex(c, 10)
                            call SetUnitTimeScale(c, 0.65)
                            set x = GetUnitX(c) - 220 * Cos(a)
                            set y = GetUnitY(c) - 220 * Sin(a)
                            call MakeSound("war3mapimported\\Hero_Natsu_FR7")
                        endif
                        if r > 1.81 and r < 3.3 then
                            if r3 > 0.09 then
                                set r3 = 0
                                call SetUnitTimeScale(td, 3)
                                call SetUnitAnimation(td, "death")
                                call HeightSet(td, 0.09, GetUnitFlyHeight(td) + 33)
                                call MUE(td, 90, 0.1, a)
                                call UnitRemoveAbility(td, 'Avul')
                                call dmgmag(c, td, dmg2)
                                call UnitAddAbility(td, 'Avul')
                                call DecorRemove(c, x, y, 450, 100)
                                call VisionTimed(GetOwningPlayer(c),x,y,850,3)
                            else
                                set r3 = r3 + 0.03
                            endif
                        endif
                        if r == 1.2 + add or r == 1.26 + add or r == 1.32 + add or r == 1.38 + add or r == 1.45 + add then
                            set x = x + 300 * Cos(a)
                            set y = y + 300 * Sin(a)
                            set e3 = EffectSpawn3("war3mapImported\\wos_firefly-r1e-sfx2.mdl", x, y, a * bj_RADTODEG + 180, 1.75, 1, 230, -90)
                            call AnimDummyEff(e3, 0.65, 1)
                            set e3 = null
                        endif
                        if r > 1.51 + add then
                            set x = x + move * Cos(a)
                            set y = y + move * Sin(a)
                            if r2 > 0.06 then
                                set r2 = 0
                                set rr1 = GetRandomReal(115, 305)
                                if k3 == 0 then
                                    set rr2 = a + 90 * bj_DEGTORAD
                                    set k3 = 1
                                else
                                    set rr2 = a - 90 * bj_DEGTORAD
                                    set k3 = 0
                                endif
                                if k2 == 1 then
                                    call MyRemoveEff(EffectSpawnScale("war3mapImported\\wos_lb_hg2-E12B5.mdl", x - 250 * Cos(a), y - 250 * Sin(a), GetRandomReal(0, 359), 0.5, 1, 100, 0.3, 1, 2.8), 0.81)
                                endif
                                call ColorEffDummy3(EffectSpawnScale("war3mapImported\\wos_papsnaz (1050).mdl", x, y, GetRandomReal(0, 359), 1.45, 0.01, 0, 0.3, 0.01, 1.35), 0.3, 255, 255, 255, 1.21)
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_firefly-rq-sfx2.mdl", x + rr1 * Cos(rr2), y + rr1 * Sin(rr2), GetRandomReal(0, 359), 1, 1.75, GetRandomReal(150, 550)))
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif
                        if r == 3.51 then
                            set r = 999999
                        endif
                    endif
                else
                    call StopSpellUnit(c)
                    if check == 5 then 
                    call StopSpellUnit(td)
                    endif
                    call DestroyEffect(e2)
                    if check == 5 then
                    call OkarunEggCd(c,NatsuT_ID,BlzGetUnitAbilityCooldown(c, NatsuT_ID, GetUnitAbilityLevel(c, NatsuT_ID) - 1))
                    call OkarunEggCd(c,NatsuFT_ID,BlzGetUnitAbilityCooldown(c, NatsuFT_ID, GetUnitAbilityLevel(c, NatsuFT_ID) - 1))
                        call HeightSet(td, 0.42, 0)
                        call MUE(td, 200, 0.42, a)
                    endif
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call CameraSetTargetNoise( 0, 0)
                    endif
                    if GetLocalPlayer() == GetOwningPlayer(td) then
                        call CameraSetTargetNoise( 0, 0)
                    endif
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.21)
                    call DestroyGroup(g)
                    set c = null
                    set td = null
                    set g = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set m_NatsuFR[i] = m_NatsuFR[ MUI_NatsuFR]
                    set MUI_NatsuFR = MUI_NatsuFR - 1
                    if MUI_NatsuFR == -1 then
                        call PauseTimer( t_NatsuFR)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method NatsuFR_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_NatsuFR = MUI_NatsuFR + 1
            set m_NatsuFR[ MUI_NatsuFR] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set r2 = 10
            set k2 = 0
            set a = GAngle(c, td)
            set move = 60
            call StartSpellUnit(c)
            set g = CreateGroup()
            set e = AddSpecialEffectTarget("war3mapImported\\war3mapImported\\wos_windwalk fire2.mdl", c, "hand right")
            set e2 = AddSpecialEffectTarget("war3mapImported\\war3mapImported\\wos_windwalk fire2.mdl", c, "hand left")
            set rmax = 4
            set check = 0
            set dmg = GetHeroAgi( c , true) * ( NatsuFR_DamageAgiBase + ( NatsuFR_DamageAgiStep * ( GetUnitAbilityLevel( c , NatsuR_ID) - 1 ) ) )
            if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) > 0 then
               // set dmg = dmg + GetHeroAgi(c, true) * NatsuGR_DamageAgiBonus
                set k2 = 1
            endif
            set dmg = dmg / 5
            set dmg2 = GetHeroAgi( c , true) * NatsuFT_DamageAgiBase
            if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) > 0 then
            //    set dmg2 = dmg2 + GetHeroAgi(c, true) * NatsuGT_DamageAgiBonus
            endif
            set dmg2 = dmg2 / 11
            call MakeSound("war3mapimported\\Hero_Natsu_FR")
            call SetUnitAnimationByIndex( c , 11)
            call SetUnitTimeScale(c, 1)
            if MUI_NatsuFR == 0 then
                call TimerStart( t_NatsuFR, 0.03, true, function thistype.Loop_NatsuFR)
            endif
        endmethod
    endstruct

    private struct NatsuFT_KS
        private static timer t_NatsuFT = CreateTimer( )
        private static integer array m_NatsuFT
        private static integer MUI_NatsuFT = -1
        unit c
        unit td
        real x
        real y
        real r2
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
        effect e3
        effect e4
        effect e5
        real a
        real rmax
        private static method Loop_NatsuFT takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr1 = 0
            local real rr2 = 0
            loop
                exitwhen i > MUI_NatsuFT
                set this = m_NatsuFT[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set r = S2R( R2SW( r , 0, 3 ) )
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    if r == 0.9 then
                        call SetUnitTimeScale(c, 0)
                    endif
                    if r == 2.4 then
                        call SetUnitTimeScale(c, 0.55)
                        call AnimDummy(c, 0.6, 0)
                    endif
                    if r < 2.4 then
                        set a = GAngle(c, td)
                        call SetUnitFacing(c, a * bj_RADTODEG)
                        if r5 > 0.29 then
                            set r5 = 0
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_firefly-rw-sfx4.mdl", x , y , GetRandomReal(0, 359), 1.5, 1.25, 5))
                        else
                            set r5 = r5 + 0.03
                        endif
                    endif
                    if r == 2.4 then
                        call MakeSound("war3mapimported\\Hero_Natsu_FT2")
                    endif
                    if r == 2.4 then
                        set rr1 = 175
                        set rr2 = 165
                        set e3 = EffectSpawn("war3mapImported\\wos_papsnaz (763).mdl", (GetUnitX(c) - rr2 * Cos(a)) + rr1 * Cos(a - 90 * bj_DEGTORAD), (GetUnitY(c) - rr2 * Sin(a)) + rr1 * Sin(a - 90 * bj_DEGTORAD), a * bj_RADTODEG + 110, 1, 1.75, 85)
                        set e4 = EffectSpawn("war3mapImported\\wos_papsnaz (763).mdl", (GetUnitX(c) - rr2 * Cos(a)) + rr1 * Cos(a + 90 * bj_DEGTORAD), (GetUnitY(c) - rr2 * Sin(a)) + rr1 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 70, 1, 1.75, 85)
                        set e5 = EffectSpawn("war3mapImported\\wos_papsnaz (763).mdl", (GetUnitX(c) - (rr2 + 50) * Cos(a)) , (GetUnitY(c) - (rr2 + 50) * Sin(a)) , a * bj_RADTODEG + 90, 1, 1.95, 85)
                    endif
                    if r > 2.4 then
                    call BlzSetSpecialEffectYaw(e3,a + (110 * bj_DEGTORAD))
                    call BlzSetSpecialEffectYaw(e4,a + (70 * bj_DEGTORAD))
                    call BlzSetSpecialEffectYaw(e5,a + (90 * bj_DEGTORAD))
                        call MoveUnit(c, move, a)
                        call MoveEff(e3, move, a)
                        call MoveEff(e4, move, a)
                        call MoveEff(e5, move, a)
                        if check == 0 then
                            set a = GAngle(c, td)
                            call SetUnitFacing(c, a * bj_RADTODEG)
                            if SR2(c, td) < move * 2 then
                                set check = 2
                                call SetUnitAnimation(td, "death")
                                call StunUnit(c, td, NatsuFT_Stun)
                                call MakeSound("war3mapimported\\Hero_Natsu_FT3")
                                set r = rmax - 0.51
                            endif
                        elseif check == 2 then
                            call PosUnit(td, GetUnitX(c) + 180 * Cos(a), GetUnitY(c) + 180 * Sin(a))
                        endif
                        if r4 > 0.15 then
                            set r4 = 0
                            call DecorRemove(c, x, y, 750, 100)
                            call VisionTimed(GetOwningPlayer(c),x,y,750,1.9)
                            call BlzPlaySpecialEffect(e3, ANIM_TYPE_STAND)
                            call BlzPlaySpecialEffect(e4, ANIM_TYPE_STAND)
                            call BlzPlaySpecialEffect(e5, ANIM_TYPE_STAND)
                        else
                            set r4 = r4 + 0.03
                        endif
                        if r3 > 0.03 then
                            set r3 = 0
                            if k2 == 1 then
                                call EffectSpawn2("war3mapImported\\wos_lb_hg2-E12B5.mdl", x + 150 * Cos(a), y + 150 * Sin(a), GetRandomReal(0, 359), 0.5, 2.55, 100, 0.45)
                            endif
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_firefly-rq-sfx2.mdl", x + rr1 * Cos(rr2), y + rr1 * Sin(rr2), a * bj_RADTODEG + 90, 1, 1.75, 125))
                        else
                            set r3 = r3 + 0.03
                        endif
                        if r2 > 0.0 then
                            set r2 = 0
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_papsnaz (763).mdl", x, y, a * bj_RADTODEG + 90, 0.35, 1.75, 85), 0, 255, 255, 255, 0.85)
                        else
                            set r2 = r2 + 0.03
                        endif
                       
                        call GroupClear( g )
                        call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                if IsUnitInGroup(u, g2) == false then
                                    call GroupAddUnit(g2, u)
                                    call dmgmag(c, u, dmg)
                                endif
                                if u != td then
                                    call MoveUnit(u, move * 2, a)
                                endif
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    endif
                else
                    if k2 == 1 then
                        call EffectSpawn2("war3mapImported\\wos_lb_hg2-E12B5.mdl", x + 150 * Cos(a), y + 150 * Sin(a), GetRandomReal(0, 359), 1, 3, 0, 0.51)
                    endif
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call DestroyEffect(e3)
                    call DestroyEffect(e4)
                    call DestroyEffect(e5)
                    set e3 = null
                    set e4 = null
                    set e5 = null
                    call StopSpellUnit(c)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set c = null
                    set td = null
                    set e = null
                    set e2 = null
                    set g = null
                    set g2 = null
                    set u = null
                    set m_NatsuFT[i] = m_NatsuFT[ MUI_NatsuFT]
                    set MUI_NatsuFT = MUI_NatsuFT - 1
                    if MUI_NatsuFT == -1 then
                        call PauseTimer( t_NatsuFT)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method NatsuFT_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            local real rr1 = 100
            set MUI_NatsuFT = MUI_NatsuFT + 1
            set m_NatsuFT[ MUI_NatsuFT] = this
            set c = NewC
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r = 0
            set r2 = 10
            call StartSpellUnit(c)
            set rmax = 6
            set move = 120
            set check = 0
            set a = GAngle2(c, x, y)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set aoe = NatsuT_DamageAoe
            call SetUnitAnimationByIndex( c , 16)
            call SetUnitTimeScale(c, 1)
            set k2 = 0
            set r5 = 10
            set dmg = GetHeroAgi( c , true) * NatsuFT_DamageAgiBase
            if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) > 0 then
           //     set dmg = dmg + GetHeroAgi(c, true) * NatsuGT_DamageAgiBonus
                set k2 = 1
            endif
            call MakeSound("war3mapimported\\Hero_Natsu_FT1")
            set e = AddSpecialEffectTarget("war3mapImported\\wos_File00000712.mdl", c, "hand right")
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_File00000712.mdl", c, "hand left")
            if MUI_NatsuFT == 0 then
                call TimerStart( t_NatsuFT, 0.03, true, function thistype.Loop_NatsuFT)
            endif
        endmethod
    endstruct

    //----------------------------Natsu-----------------------------------------------
     /* Animations index:
    0 - atk right
    1 - atk uppercot
    2 - atk left foot
    3 - atk foot round
    4 - atk right slow
    5 - atk left slow
    6 - foot atk
    7 - round atk
    18 - E
    20 - combo atk
    21 - fast combo atk
    22 - walk
    23 - W
    24 - g
    25 - houken
    27 - q
    37 - e 1
    36 - e2
    11 - stand ready
    19 - bakuenjin
     */ 
    function NatsuPas_Start takes unit c returns nothing
        call NatsuPas_KS.NatsuPas_Start( c )
    endfunction
    function NatsuF_Start takes unit damaged returns nothing
    local integer i = 0
    local unit responder
    local player damagedOwner = GetOwningPlayer(damaged)
    local real damagedX = GetUnitX(damaged)
    local real damagedY = GetUnitY(damaged)
    local real dx
    local real dy
    local real rangeSquared = NatsuF_AoeSearch * NatsuF_AoeSearch

    loop
        exitwhen i >= bj_MAX_PLAYER_SLOTS
        set responder = Hero[i]

        if responder != null and GetUnitTypeId(responder) == Natsu_ID and GetWidgetLife(responder) > 1.0 and not IsUnitIllusion(responder) and GetHeroLevel(responder) >= NatsuF_LvlCheck and IsUnitAlly(responder, damagedOwner) then
            set dx = GetUnitX(responder) - damagedX
            set dy = GetUnitY(responder) - damagedY

            if dx * dx + dy * dy <= rangeSquared and IntegerCd(responder, "pas f", NatsuF_Cd) then
                call FakeCD_Start(responder, NatsuF_ID, NatsuF_Cd, StringHash("pas f"), 0)
                call NatsuPas_Start(responder)
            endif
        endif

        set i = i + 1
    endloop

    set responder = null
    set damagedOwner = null
endfunction
    function NatsuQ_Start takes unit c, real x, real y returns nothing
        call NatsuQ_KS.NatsuQ_Start( c, x, y )
    endfunction
    function NatsuW_Start takes unit c, unit td returns nothing
        call NatsuW_KS.NatsuW_Start( c, td )
    endfunction
    function NatsuE_Start takes unit c, real x, real y returns nothing
        call NatsuE_KS.NatsuE_Start( c, x, y )
    endfunction
    function NatsuR_Start takes unit c, unit td returns nothing
        call NatsuR_KS.NatsuR_Start( c, td )
    endfunction
    function NatsuT_Start takes unit c, real x, real y returns nothing
        call NatsuT_KS.NatsuT_Start( c, x, y )
    endfunction
    function NatsuFR_Start takes unit c, unit td returns nothing
        call NatsuFR_KS.NatsuFR_Start( c, td )
    endfunction
    function NatsuFT_Start takes unit c, unit td returns nothing
        call NatsuFT_KS.NatsuFT_Start( c, td )
    endfunction
    function NatsuG_Start takes unit c returns nothing
        call NatsuG_KS.NatsuG_Start( c )
    endfunction
    function NatsuG2_Start takes unit c returns nothing
        local real x = GetUnitX(c)
        local real y = GetUnitY(c)
        if LoadInteger(hs, GetHandleId(c), StringHash("mode g"))==0 then
        call ReduceCooldown(c, NatsuG_ID, 99)
        call MakeSound("war3mapimported\\Hero_Natsu_G3")
        call MakeSound("war3mapimported\\Hero_Natsu_GG")
        call NatsuG2_KS.NatsuG2_Start(c)
        call DisplayTimedTextToPlayer(GetOwningPlayer(c), 0, 0, 1, "|c00FFFC01Modo Raienryuu|r")
        call EUTU2_3(EffectSpawn("war3mapImported\\wos_firefly-rq-sfx2.mdl", x, y, 1, 1, 1.5, 100), 1.5, 100, c)
        call EUTU2_3(EffectSpawn("war3mapImported\\wos_5731-sl_8bc718f-F.mdl", x, y, 1, 1, 1.15, 1), 1.5, 1, c)
        call EUTU2_3(EffectSpawn("war3mapImported\\wos_firefly-rw-sfx4_01.mdl", x, y, 0, 2.25, 1.5, 1), 1.5, 1, c)
    else
    call IssueImmediateOrder(c,"stop")
    endif
    endfunction
endlibrary