library OkarunSpells uses GearSystems
    globals
//--------------------------------------Okarun--------------------------------------------------------------
        integer Okarun_ID = 'H01B'
//---------------Q ability-----------------------------------------------------
        integer OkarunQ_ID = 'A077'
        string OkarunQ_Order = "absorb"
        real OkarunQ_DamageIntBase = 1 // base number x Int damage for 1 level
        real OkarunQ_DamageIntStep = 1 // additional number x Int damage for each next level
        real OkarunQ_Damage2StaticBase = 200 // base static damage for 1 level
        real OkarunQ_Damage2StaticStep = 0 // additional static damage for each next level
        real OkarunQ_DamageSpeedBonusBase = 0 // % of okarun speed
        real OkarunQ_DamageSpeedBonusStep = 15 // % of okarun speed
        real OkarunQ_DamageAoe = 235
        real OkarunQ_RangeBase = 800
        real OkarunQ_RangeStep = 100
        real OkarunQ_DamageAoeFinal = 550
        real OkarunQ_PushRange = 450 // slow time 2, 3, 4 sec only
        real OkarunQ_PushDuration = 0.24 // slow time 2, 3, 4 sec only
//---------------W ability-----------------------------------------------------
        integer OkarunW_ID = 'A078' //7 РєСѓР»Р°РєРѕРІ
        string OkarunW_Order = "acolyteharvest"
        real OkarunW_DamageIntBase = 1 // base number x Int damage for 1 level
        real OkarunW_DamageIntStep = 1 // additional number x Int damage for each next level
        real OkarunW_Damage2StaticBase = 200 // base static damage for 1 level
        real OkarunW_Damage2StaticStep = 0 // additional static damage for each next level
        real OkarunW_Stun = 0.5
        real OkarunW_PushRange = 200 // slow time 2, 3, 4 sec only
        real OkarunW_PushDuration = 0.24 // slow time 2, 3, 4 sec only
//---------------E ability-----------------------------------------------------
        integer OkarunE_ID = 'A079'
        string OkarunE_Order = "auravampiric"
        real OkarunE_DamageIntBase = 2 // base number x Int damage for 1 level
        real OkarunE_DamageIntStep = 1 // additional number x Int damage for each next level
        real OkarunE_DamageSpeedBonus = 40 // % of okarun speed
        real OkarunE_DamageAoe = 300 // 
        real OkarunE_PushRange = 450 // slow time 2, 3, 4 sec only
        real OkarunE_PushDuration = 0.24 // slow time 2, 3, 4 sec only
//---------------R ability-----------------------------------------------------
        integer OkarunR_ID = 'A07A'
        string OkarunR_Order = "creepthunderbolt"
        real OkarunR_DamageSpeedBonusBase = 40 // % of okarun speed
        real OkarunR_DamageSpeedBonusStep = 8 // % of okarun speed
        real OkarunR_DamageIntBase = 4 // base number x Int damage for 1 level
        real OkarunR_DamageIntStep = 1 // additional number x Int damage for each next level
        real OkarunR_Stun = 0.3 //
        real OkarunR_Range = 1200 //
        real OkarunR_StunFinal = 1 //
        real OkarunR_PushRange = 1200 // slow time 2, 3, 4 sec only
        real OkarunR_PushDuration = 0.6 // slow time 2, 3, 4 sec only
        real OkarunR_PushFly = 600 // slow time 2, 3, 4 sec only
        real OkarunR_SmallPushRange = 80 // slow time 2, 3, 4 sec only
        real OkarunR_SmallPushDuration = 0.24 // slow time 2, 3, 4 sec only
//---------------T ability-----------------------------------------------------
        integer OkarunT_ID = 'A07B' //
        integer OkarunT_Buff_ID = 'B00L' //
        real OkarunT_Buff_Duration = 10.00
        string OkarunT_Order = "ambush"
        real OkarunT_DamageIntBase = 10 // for each punch
        real OkarunT_DamageAoe = 700 // for each punch
        real OkarunT_bonusspeed = 1.25 // 125%
        integer OkarunT_Slow = 50 // Caused slow %
        integer OkarunT_SlowDuration = 2 // slow time 2, 3, 4 sec only
//---------------F ability-----------------------------------------------------
        integer OkarunF_ID = 'A07C'
        real OkarunF_MaxSpeed0 = 600
        real OkarunF_MaxSpeed1 = 700
        real OkarunF_MaxSpeed2 = 800
        real OkarunF_MaxSpeed3 = 900
        real OkarunF_MaxSpeed4 = 1000
        real OkarunF_AddSpeedPercentPerSec = 5 // gain 10% of max speed per second
        real OkarunF_DecreaseSpeedPercentPerSec = 1.2 // 2% of max speed decreased
    endglobals
    private struct OkarunQ_KS
        private static timer t_OkarunQ = CreateTimer( )
        private static integer array m_OkarunQ
        private static integer MUI_OkarunQ = -1
        unit c
        real x
        real y
        real r2
        integer k
        real r3
        real r4
        real r5
        group g
        unit u
        real dmg
        real aoe
        real move
        real r
        real a
        real rmax
        private static method Loop_OkarunQ takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_OkarunQ
                set this = m_OkarunQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03                      
                    call DebugUnit2(c)
            call SaveInteger(hs,GetHandleId(c),StringHash("spell p"),1)
                    if r == 0.21 or r == 0.42 then                     
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_az2_az_laser3-x.mdl" , GetUnitX(c), GetUnitY(c), 1, 1, 1.25, 11))
                    endif
                    if r == 0.3 then
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, 1, 255, 255, 255, 255))
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.1, 1, 255, 255, 255, 115))
                        call MakeSound("war3mapimported\\Hero_Okarun_Q2")
                    endif
                    if r > 0.3 then
                        if r5 <= r4 then //SR3(c, x, y) > 120 then
                            set r5 = r5 + move
                            call MoveUnit(c, move, a)
                            call SetUnitFacing(c, a * bj_RADTODEG)
                            call DecorRemove(c, GetUnitX(c), GetUnitY(c), aoe, 50)
                            call GroupEnumUnitsInRange( g , GetUnitX(c), GetUnitY(c) , aoe + 25, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    call MoveUnit(u, move * 1.15, a)
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                            if r2 > 0.0 then
                                set r2 = 0
                                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, 1, 255, 255, 255, 255))
                                
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.1, 1, 255, 255, 255, 115))
                            else
                                set r2 = r2 + 0.03
                            endif
                        else
                            set x = GetUnitX(c) + 100 * Cos(a)
                            set y = GetUnitY(c) + 100 * Sin(a)
                            set r = 99999
                            if GetUnitAbilityLevel(c, OkarunT_Buff_ID) == 0 then                        
                            call SaveReal(hs, GetHandleId(c), StringHash("current speed"), GetUnitMoveSpeed(c))
                            endif
                            call MakeSound("war3mapimported\\Hero_Okarun_Q5")
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Satsu-Hit-red.mdx", x, y, a * bj_RADTODEG, 1.25, 3.45, 145))
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 2, 1, 255, 255, 255, 115))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_1baozha_90.mdx", .x, .y, GetRandomReal(0, 359), 1, 3, 1))
                            call DestroyEffect(EffectSpawn3("war3mapimported\\wos_exceffect4.mdl", x , y , a * bj_RADTODEG, 1.5, 3, 120, -90))
                            set k = 0
                            loop
                                exitwhen k > 3
                                call EffectSpawn2("war3mapimported\\wos_LD2209 (157).mdx", x, y, GetRandomReal(0, 359), 1 - k * 0.2, 1 + k * 0.5, 0, 1.25)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_dustgaraa2.mdx", x, y, GetRandomReal(0, 359), 1.5 - k * 0.1, 1.9 + k * 0.42, 0))
                                set k = k + 1
                            endloop
                          
                            call DecorRemove(c, x, y, OkarunQ_DamageAoeFinal, 100)
                            call GroupEnumUnitsInRange( g , x, y , OkarunQ_DamageAoeFinal , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    call dmgphys(c, u, dmg)
                                    call MUE(u, OkarunQ_PushRange, OkarunQ_PushDuration, a)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        endif
                    endif
                else
            call SaveInteger(hs,GetHandleId(c),StringHash("spell p"),0)
                    call StopSpellUnit2(c)
                    call SetUnitTimeScale( c , 1)
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set u = null
                    set m_OkarunQ[i] = m_OkarunQ[ MUI_OkarunQ]
                    set MUI_OkarunQ = MUI_OkarunQ - 1
                    if MUI_OkarunQ == -1 then
                        call PauseTimer( t_OkarunQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method OkarunQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_OkarunQ = MUI_OkarunQ + 1
            set m_OkarunQ[ MUI_OkarunQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set move = 65 + LoadReal(hs, GetHandleId(c), StringHash("current speed1")) / 12
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set r3 = LoadReal(hs, GetHandleId(c), StringHash("current speed1"))
                                if r3>GetUnitMoveSpeed(c) then 
                                set r3 = (r3 - GetUnitMoveSpeed(c))*0.25
                                set r3 =GetUnitMoveSpeed(c)+r3
                                endif
            call SaveInteger(hs,GetHandleId(c),StringHash("spell p"),1)
            set a = GAngle2( c , x , y ) // Angle Between points
            set aoe = OkarunQ_DamageAoe
            set dmg = GetHeroInt( c , true) * ( OkarunQ_DamageIntBase + ( OkarunQ_DamageIntStep * ( GetUnitAbilityLevel( c , OkarunQ_ID) - 1 ) ) )
            set dmg = dmg + OkarunQ_Damage2StaticBase + ( OkarunQ_Damage2StaticStep * ( GetUnitAbilityLevel( c , OkarunQ_ID) - 1 ) )
            set dmg = dmg + (LoadReal(hs, GetHandleId(c), StringHash("current speed1")) * ((OkarunQ_DamageSpeedBonusBase+ (OkarunQ_DamageSpeedBonusStep* ( GetUnitAbilityLevel( c , OkarunQ_ID) - 1 )))/100))
            set rmax = 2.1
            set r5 = 0
            set r4 = OkarunQ_RangeBase + (OkarunQ_RangeStep*(GetUnitAbilityLevel(c,OkarunQ_ID)-1))
            call SetUnitAnimationByIndex(c, 9)
            call MakeSound("war3mapimported\\Hero_Okarun_Q")
            call MakeSound("war3mapimported\\Hero_Okarun_Q3")
            if MUI_OkarunQ == 0 then
                call TimerStart( t_OkarunQ, 0.03, true, function thistype.Loop_OkarunQ)
            endif
        endmethod
    endstruct

    private struct OkarunW_KS
        private static timer t_OkarunW = CreateTimer( )
        private static integer array m_OkarunW
        private static integer MUI_OkarunW = -1
        unit c
        unit td
        real x
        real y
        real dmg
        real r
        real a
        real rmax
        private static method Loop_OkarunW takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_OkarunW
                set this = m_OkarunW[i]
                if SpellBoolCaster(c)  and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit2(c)
            call SaveInteger(hs,GetHandleId(c),StringHash("spell p"),1)
                    if r == 0.33 then
                        set a = GAngle(c, td)
                        call SetUnitAnimationByIndex(c, 8)
                        call BlinkEff(c)
                        call MakeSound("war3mapimported\\Hero_Okarun_W2")
                        call SetUnitTimeScale(c, 3.8)
                    endif
                    if r>=0.3 then                     
                        call PosUnit(c, GetUnitX(td) - 80 * Cos(a), GetUnitY(td) - 80 * Sin(a))
                    endif
                    if r == 0.51 then
                        set r = 999
                        call StunUnit(c, td, OkarunW_Stun)
                        call dmgphys (c, td, dmg)
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        call MUE(td, OkarunW_PushRange, OkarunW_PushDuration, a)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_hitheavy.mdl", x, y, a * bj_RADTODEG, 1, 3.25, 115))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_az_siwen3.mdx", x, y, GetRandomReal(0, 359), 1, 2.5, 125))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_exceffect4.mdl", x , y , GetRandomReal(0, 359), 1.5, 5, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_ldeff (41).mdl", x , y , GetRandomReal(0, 359), 1, 2.75, 0))
                    endif
                else
                    call StopSpellUnit2(c)
            call SaveInteger(hs,GetHandleId(c),StringHash("spell p"),0)
                    call SetUnitTimeScale( c , 1)
                    set c = null
                    set td = null
                    set m_OkarunW[i] = m_OkarunW[ MUI_OkarunW]
                    set MUI_OkarunW = MUI_OkarunW - 1
                    if MUI_OkarunW == -1 then
                        call PauseTimer( t_OkarunW)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method OkarunW_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_OkarunW = MUI_OkarunW + 1
            set m_OkarunW[ MUI_OkarunW] = this
            set c = NewC
            set td = NewTd
            set r = 0
            call SaveInteger(hs,GetHandleId(c),StringHash("spell p"),1)
            set dmg = GetHeroInt( c , true) * ( OkarunW_DamageIntBase + ( OkarunW_DamageIntStep * ( GetUnitAbilityLevel( c , OkarunW_ID) - 1 ) ) )
            set dmg = dmg + OkarunW_Damage2StaticBase + ( OkarunW_Damage2StaticStep * ( GetUnitAbilityLevel( c , OkarunW_ID) - 1 ) )
            call StartSpellUnit2(c)
            set a = GAngle( c , td ) // Angle Between points
            set rmax = 1.2
            call SetUnitAnimationByIndex(c, 7)
            call SetUnitTimeScale(c, 2.95)
            call MakeSound("war3mapimported\\Hero_Okarun_W")
            if MUI_OkarunW == 0 then
                call TimerStart( t_OkarunW, 0.03, true, function thistype.Loop_OkarunW)
            endif
        endmethod
    endstruct

    private struct OkarunE_KS
        private static timer t_OkarunE = CreateTimer( )
        private static integer array m_OkarunE
        private static integer MUI_OkarunE = -1
        unit c
        unit td
        real x
        real y
        real r2
        group g
        unit u
        real dmg
        real aoe
        real move
        real r
        real a
        real rmax
        private static method Loop_OkarunE takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_OkarunE
                set this = m_OkarunE[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
            call SaveInteger(hs,GetHandleId(c),StringHash("spell p"),1)
                    call DebugUnit2(c)
                    if r > 0.3 then
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        if SR2(c, td) > 150 then
                            set a = GAngle(c, td)
                            call MoveUnit(c, move, a)
                            if r2 > 0.00 then
                                set r2 = 0
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_0780red.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1.35, 50))
                            else
                                set r2 = r2 + 0.03
                            endif
                        else
                            set r = 9999
                        endif
                    endif
                else
                    call StopSpellUnit2(c)
                    if r >= 0.3 then
                        if r == 9999 then
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                        else
                            set x = GetUnitX(c) + 300 * Cos(a)
                            set y = GetUnitY(c) + 300 * Sin(a)
                        endif
                        call VisionTimed(GetOwningPlayer(c), x, y , aoe, 1)
                        call DecorRemove(c, x, y , aoe+150, 50)
                        call MUE(td, OkarunE_PushRange, OkarunE_PushDuration, a)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_az2_az_laser3-x.mdl" , x , y, 1, 1.5, 0.75, 111))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_az2_az_laser3-x.mdl" , x , y, 1, 1.5, 1.5, 111))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_az2_az_laser3-x.mdl" , x , y, 1, 1.5, 2.25, 111))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_saberalterqc.mdl" , x , y, 1, 2.5, 4.55, 1))
                        call GroupClear(g)
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                call dmgmag(c, u, dmg)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    endif
            call SaveInteger(hs,GetHandleId(c),StringHash("spell p"),0)
                    call SetUnitTimeScale( c , 1)
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set td = null
                    set u = null
                    set m_OkarunE[i] = m_OkarunE[ MUI_OkarunE]
                    set MUI_OkarunE = MUI_OkarunE - 1
                    if MUI_OkarunE == -1 then
                        call PauseTimer( t_OkarunE)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method OkarunE_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_OkarunE = MUI_OkarunE + 1
            set m_OkarunE[ MUI_OkarunE] = this
            set c = NewC
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r = 0
            set r2 = 0
            set move = 50 + LoadReal(hs, GetHandleId(c), StringHash("current speed1")) / 10
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set aoe = OkarunE_DamageAoe
            call SaveInteger(hs,GetHandleId(c),StringHash("spell p"),1)
            set dmg = GetHeroInt( c , true) * ( OkarunE_DamageIntBase + ( OkarunE_DamageIntStep * ( GetUnitAbilityLevel( c , OkarunE_ID) - 1 ) ) )
            set dmg = dmg + (LoadReal(hs, GetHandleId(c), StringHash("current speed1")) * (OkarunE_DamageSpeedBonus/100))
            set rmax = 2.4
            call SetUnitAnimationByIndex(c, 4)
            call SetUnitTimeScale(c, 0.15)
            call MakeSound("war3mapimported\\Hero_Okarun_E")
            call MakeSound("war3mapimported\\Hero_Okarun_E3")
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_saberalterqc.mdl" , GetUnitX(c) , GetUnitY(c), 1, 2.5, 1.95, 1))
            if MUI_OkarunE == 0 then
                call TimerStart( t_OkarunE, 0.03, true, function thistype.Loop_OkarunE)
            endif
        endmethod
    endstruct

    private struct OkarunR_KS
        private static timer t_OkarunR = CreateTimer( )
        private static integer array m_OkarunR
        private static integer MUI_OkarunR = -1
        unit c
        unit td
        real x
        real y
        real r2
        real r4
        real r5
        group g
        unit u
        real dmg
        integer check
        integer check2
        real move
        real r
        real a
        real rmax
        private static method Loop_OkarunR takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_OkarunR
                set this = m_OkarunR[i]
                if SpellBoolCaster(c)  and CheckCoordsInRect(gg_rct_Base,GetUnitX(c),GetUnitY(c))== false and r <= rmax then
                    set r = r + 0.03
                    if check2 == 0 then
                    call DebugUnit(c)
                            if r> 0.36 then 
                            call MoveUnit(c, move, a)
                            if r4<OkarunR_Range then 
                        set r4 = r4 + move
                        else
                            set r = 9999
                        endif
                            if r2 > 0.00 then
                                set r2 = 0
                                call GroupClear(g)
                                set x = GetUnitX(c)
                                set y = GetUnitY(c)
                                call DecorRemove(c,x,y,300,25)
                        call GroupEnumUnitsInRange( g , x, y , 300 , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null or td != null 
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                set td = u
                                set r = 0
                                set check2 = 1
                                set x = GetUnitX(td)
                                set y = GetUnitY(td)                                
            call SaveInteger(hs,GetHandleId(c),StringHash("spell p"),0)
                                   call MakeSound("war3mapimported\\Hero_Okarun_R")
                                call SetUnitAnimationByIndex(c, 3)
            call BlinkEff2(c)
            call PosUnit(c, x - 100 * Cos(a), y - 100 * Sin(a))
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_0780red.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1.35, 50))
                            else
                                set r2 = r2 + 0.03
                            endif
                            endif
                        
                    else
                    if SpellBoolCaster(td) == false then 
                    set r = 99999
                    else
                    call DebugUnit(c)
                            set a = GAngle(c,td)
                    if r == 0.03 then
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        call SetUnitAnimation(td, "death")
                        call StunUnit(c, td, OkarunR_Stun )
                        call dmgphys(c, td, dmg)
                        call MUE(td, OkarunR_SmallPushRange, OkarunR_SmallPushDuration, a)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_az2_az_laser3-x.mdl" , x , y, 1, 1.5, 1.25, 111))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_saberalterqc.mdl" , x , y, 1, 3, 1.25, 1))
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_acg_bbb.mdl", x, y, a * bj_RADTODEG , 1, 0.85, 111, 255, 255, 255, 125))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_mh_tx-ba-symh-hit11Red.mdx", x , y, a * bj_RADTODEG, 0.9, 2, 116))
                        call SetUnitTimeScale(c, 1.2)
                    endif
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    if r > 0.35 and r < 3.6 then
                        if r2 > 0.36 then
                            call BlinkEff(c)
                            set check = check + 1
                            if GetRandomInt(1, 2) == 1 then
                                call SetUnitAnimationByIndex(c, 12)
                            else
                                call SetUnitAnimationByIndex(c, 13)
                            endif
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            call StunUnit(c, td, OkarunR_Stun )
                            call PosUnit(c, x - 100 * Cos(a), y - 100 * Sin(a))
                            call SetUnitAnimation(td, "death")
                            call dmgphys(c, td, dmg)
                            call MUE(td, OkarunR_SmallPushRange, OkarunR_SmallPushDuration, a)
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_acg_bbb.mdl", x, y, a * bj_RADTODEG , 1, 0.85, 111, 255, 255, 255, 125))
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_gnaden_air.mdl", x, y, GetRandomReal(0, 359), 1, 4.5, 1, 255, 255, 255, 205))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_az2_az_laser3-x.mdl" , x , y, 1, 1.5, 1.25, 111))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_saberalterqc.mdl" , x , y, 1, 3, 1.25, 1))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_mh_tx-ba-symh-hit11Red.mdx", x , y, a * bj_RADTODEG, 0.9, 2, 116))
                            set r2 = 0
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                    if r == 3.6 then
                        call SetUnitAnimationByIndex(c, 13)
                        call SetUnitTimeScale(c, 0.1)
                        call MakeSound("war3mapimported\\Hero_Okarun_R2")
                    elseif r == 3.72 then
                        call MakeSound("war3mapimported\\Hero_Okarun_R3")
                    elseif r == 3.9 then
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        call BlinkEff(c)
                        call PosUnit(c, x - 100 * Cos(a), y - 100 * Sin(a))
                        call BlinkEff(c)
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        set check = check + 1
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_wfile00009065.mdl", x, y, a * bj_RADTODEG , 0.5, 1.1, 1, 255, 255, 255, 255))
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", x, y, a * bj_RADTODEG , 1, 1.1, 1, 255, 255, 255, 115))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-qqsfx-5.mdl", x, y, a * bj_RADTODEG, 1.25, 2.15, 120))
                        call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_az2_az_laser3-x.mdl" , td, "origin"))
                        call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_saberalterqc.mdl", td, "origin"))
                        call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_mh_tx-ba-symh-hit11Red.mdx", td, "chest"))
                        call MakeSound("war3mapimported\\Hero_Okarun_R4")
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_exceffect4.mdl", x , y , GetRandomReal(0, 359), 1, 4.5, 0))
                        call StopSpellUnit(c)
                        call dmgphys(c, td, dmg)
                        call StunUnit(c, td, OkarunR_StunFinal)
                        call MUE(td, OkarunR_PushRange , OkarunR_PushDuration , a)
                        call HeightSet(td, OkarunR_PushDuration / 2, OkarunR_PushFly )
                        call HeightSet2(td, OkarunR_PushDuration / 2, 0, OkarunR_PushDuration / 2)
                        set r = 9999
                    endif
                    endif
                    endif
                else
                    call StopSpellUnit(c)                                 
            call SaveInteger(hs,GetHandleId(c),StringHash("spell p"),0)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set td = null
                    set u = null
                    set m_OkarunR[i] = m_OkarunR[ MUI_OkarunR]
                    set MUI_OkarunR = MUI_OkarunR - 1
                    if MUI_OkarunR == -1 then
                        call PauseTimer( t_OkarunR)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method OkarunR_Start takes unit NewC, real NewX,real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_OkarunR = MUI_OkarunR + 1
            set m_OkarunR[ MUI_OkarunR] = this
            set c = NewC
            set td = null
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 50
            set check = 0
            set check2 = 0
            set move = 100
            call StartSpellUnit(c)
            set u = null
            set g = CreateGroup()
            set r4 = 0            
            call SaveInteger(hs,GetHandleId(c),StringHash("spell p"),1)
            set r5 = OkarunR_DamageSpeedBonusBase + OkarunR_DamageSpeedBonusStep*(GetUnitAbilityLevel(c,OkarunR_ID)-1)
            set a = GAngle2( c , x , y ) // Angle Between points
            set dmg = GetHeroInt( c , true) * ( OkarunR_DamageIntBase + ( OkarunR_DamageIntStep * ( GetUnitAbilityLevel( c , OkarunR_ID) - 1 ) ) )
            set dmg = dmg + (LoadReal(hs, GetHandleId(c), StringHash("current speed1")) * (r5/100))
            set dmg = dmg / 8.5
            set rmax = 7.2
            call MakeSound("war3mapimported\\Hero_Okarun_F")
            call SetUnitAnimationByIndex(c, 3)
            call SetUnitTimeScale(c, 1)            
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_mh_tx-ba-symh-hit11Red.mdx", GetUnitX(c) ,GetUnitY(c), a * bj_RADTODEG, 0.9, 2, 116))
            if MUI_OkarunR == 0 then
                call TimerStart( t_OkarunR, 0.03, true, function thistype.Loop_OkarunR)
            endif
        endmethod
    endstruct

    private struct OkarunTBuff_KS
        private static timer t_OkarunTBuff = CreateTimer()
        private static integer array m_OkarunTBuff
        private static integer MUI_OkarunTBuff = -1
        unit c
        real r

        private static method Loop_OkarunTBuff takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_OkarunTBuff
                set this = m_OkarunTBuff[i]
                set r = r + 0.03
                if r < OkarunT_Buff_Duration and GetUnitTypeId(c) != 0 then
                    if GetUnitAbilityLevel(c, OkarunT_Buff_ID) == 0 then
                        call BuffUnit1(c, c, 3)
                    endif
                else
                    call UnitRemoveAbility(c, OkarunT_Buff_ID)
                    set c = null
                    set m_OkarunTBuff[i] = m_OkarunTBuff[MUI_OkarunTBuff]
                    set MUI_OkarunTBuff = MUI_OkarunTBuff - 1
                    if MUI_OkarunTBuff == -1 then
                        call PauseTimer(t_OkarunTBuff)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method OkarunTBuff_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_OkarunTBuff = MUI_OkarunTBuff + 1
            set m_OkarunTBuff[MUI_OkarunTBuff] = this
            set c = NewC
            set r = 0
            if MUI_OkarunTBuff == 0 then
                call TimerStart(t_OkarunTBuff, 0.03, true, function thistype.Loop_OkarunTBuff)
            endif
        endmethod
    endstruct

    private struct OkarunT_KS
        private static timer t_OkarunT = CreateTimer( )
        private static integer array m_OkarunT
        private static integer MUI_OkarunT = -1
        unit c
        real x
        real y
        real r4
        real r5
        group g
        unit u
        real dmg
        real aoe
        real move
        real r
        effect e
        real a
        real rmax
        private static method Loop_OkarunT takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_OkarunT
                set this = m_OkarunT[i]
                if (SpellBoolCaster(c) or r > 3) and r <= rmax then
                    set r = r + 0.03
                    if r > 0.3 and r < 0.9 then
                        set r5 = r5 + 40
                        call SetFly(c, r5)
                    endif
                    if r == 0.9 then
                        call SetUnitTimeScale(c, 0.2)
                        call SetUnitAnimationByIndex(c, 13)
                    endif
                    if r == 1.2 then
                        set r4 = r5
                        set r5 = r5 / 10
                        set move = SR3(c, x, y) / 10
                    endif
                    if r >= 1.2 then
                        set r4 = r4 - r5
                        call MoveUnit(c, move, a)
                        call SetFly(c, r4)
                    endif
                    if r == 1.5 then
                        set r = 9999
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        call BuffUnit1(c, c, 3)
                        call OkarunTBuff_KS.OkarunTBuff_Start(c)
                        if GetHeroLevel(c) >= 35 then
                set r5 = OkarunF_MaxSpeed3
            elseif GetHeroLevel(c) >= 25 then
                set r5 = OkarunF_MaxSpeed2
            elseif GetHeroLevel(c) >= 12 then
                set r5 = OkarunF_MaxSpeed1
            else
                set r5 = OkarunF_MaxSpeed0
            endif
            call SaveReal(hs, GetHandleId(c), StringHash("current speed"), r5*OkarunT_bonusspeed)
                        call MyFrame(c,OkarunT_Buff_Duration,"BTNHero_Okarun_T",false,0)
                        call MakeSound("war3mapimported\\Hero_Okarun_T3")
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_az2_az_laser3-x.mdl" , x , y, 1, 1, 2.5, 111))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_saberalterqc.mdl" , x , y, 1, 2, 4, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_opm (513)red.mdx" , x , y, 1, 1., 1, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_opm (597)red.mdx" , x , y, 1, 1., 1.85, 1))
                        call GroupClear(g)
                        call DecorRemove(c, x, y , aoe, 100)
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                call dmgphys(c, u, dmg)
                                call SlowUnit(c, u, OkarunT_Slow, OkarunT_SlowDuration)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    endif
                else
                    call SetFly(c, 0)
                    call StopSpellUnit(c)
                    call DestroyEffect(e)
                    call DestroyGroup(g)
                    set g = null
                    set u = null
                    set e = null
                    set c = null
                    set m_OkarunT[i] = m_OkarunT[ MUI_OkarunT]
                    set MUI_OkarunT = MUI_OkarunT - 1
                    if MUI_OkarunT == -1 then
                        call PauseTimer( t_OkarunT)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method OkarunT_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_OkarunT = MUI_OkarunT + 1
            set m_OkarunT[ MUI_OkarunT] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            call StartSpellUnit(c)
            set a = GAngle2( c , x , y ) // Angle Between points
            set aoe = OkarunT_DamageAoe
            set dmg = GetHeroInt( c , true) * OkarunT_DamageIntBase
            set rmax = 3
            set g = CreateGroup()
            call SetUnitAnimationByIndex(c, 6)
            call SetUnitTimeScale(c, 1)            
            set r5 = 0
            call DecorRemove(c, GetUnitX(c), GetUnitY(c) , aoe, 100)
            call GroupEnumUnitsInRange( g , GetUnitX(c), GetUnitY(c), aoe , NoDecor_Cond)
            loop
                set u = FirstOfGroup( g )
                exitwhen u == null
                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                    call SlowUnit(c, u, OkarunT_Slow, OkarunT_SlowDuration)
                endif
                call GroupRemoveUnit( g , u )
            endloop
            set u = null
            set e = AddSpecialEffectTarget("war3mapImported\\wos_aurafbred.mdx",c,"origin")
            call MakeSound("war3mapimported\\Hero_Okarun_T")
            call MakeSound("war3mapimported\\Hero_Okarun_T4")
            call MakeSound("war3mapimported\\Hero_Okarun_T7")
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_opm (513)red.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.25, 1., 1))
            if MUI_OkarunT == 0 then
                call TimerStart( t_OkarunT, 0.03, true, function thistype.Loop_OkarunT)
            endif
        endmethod
    endstruct

    private struct OkarunF_KS
        private static timer t_OkarunF = CreateTimer( )
        private static integer array m_OkarunF
        private static integer MUI_OkarunF = -1
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
        integer check
        real move
        real r
        effect e
        real a
        framehandle array frame_pas1 [10]
        framehandle array frame_pas2 [10]
        framehandle array frame_pas3 [10]
        framehandle array frame_pas4 [10]
        framehandle array frame_pas5 [10]
        framehandle array frame_pas6 [10]
        private static method Loop_OkarunF takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rkek = 0
            local real extraSpeed = 0
            loop
                exitwhen i > MUI_OkarunF
                set this = m_OkarunF[i]
                if check == GetUnitTypeId(c) and Hero[k2] != null then
                    if CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) then
                        call SaveReal(hs, GetHandleId(c), StringHash("current speed"), GetUnitMoveSpeed(c))
                    endif
                    if LoadReal(hs, GetHandleId(c), StringHash("current speed")) != 0 then
                        set r3 = LoadReal(hs, GetHandleId(c), StringHash("current speed"))
                        call SaveReal(hs, GetHandleId(c), StringHash("current speed"), 0)
                    endif
                    if IsUnitPaused(c) == false and GetUnitAbilityLevel(c, 'Avul') == 0 and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false then
                        if GetHeroLevel(c) >= 35 then
                            set r5 = OkarunF_MaxSpeed4
                        elseif GetHeroLevel(c) >= 25 then
                            set r5 = OkarunF_MaxSpeed3
                        elseif GetHeroLevel(c) >= 18 then
                            set r5 = OkarunF_MaxSpeed2    
                        elseif GetHeroLevel(c) >= 12 then
                            set r5 = OkarunF_MaxSpeed1
                        else
                            set r5 = OkarunF_MaxSpeed0
                        endif
                        call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, r5 + 1)
                        set x = LoadReal(hs, GetHandleId(c), StringHash("real x"))
                        set y = LoadReal(hs, GetHandleId(c), StringHash("real y"))
                        if x != 0 then
                            set a = GAngle2(c, x, y)
                            if GetHeroLevel(c)>= 35 then                             
                            set r3 = r3 + r5 * ((OkarunF_AddSpeedPercentPerSec+1) * 0.01) * 0.03
                            else
                            set r3 = r3 + r5 * (OkarunF_AddSpeedPercentPerSec * 0.01) * 0.03
                            endif
                            if r3 > r5 then
                                set r3 = r5
                            endif
                            if GetUnitAbilityLevel(c, OkarunT_Buff_ID) > 0 then
                                set r3 = r5*OkarunT_bonusspeed
                            endif
                            call SaveReal(hs, GetHandleId(c), StringHash("current speed1"), r3)
                            set extraSpeed = r3 - GetUnitMoveSpeed(c)
                            if extraSpeed < 0 then
                                set extraSpeed = 0
                            endif
                            set move = extraSpeed * 0.03
                            if move != 0 then
                                if SR3(c, x, y) > 55 and GetUnitCurrentOrder(c) != OrderId("stop") and GetUnitCurrentOrder(c) != 0 and GetUnitAbilityLevel(c, 'BPSE') == 0 and GetUnitAbilityLevel(c, 'BEer') == 0 then
                                    if r4 > r6 then
                                        set r4 = 0.03
                                        if (GetUnitCurrentOrder(c) == OrderId("smart") or GetUnitCurrentOrder(c) == OrderId("attack")) then 
                                        if  SR3(c,x,y)>120 then 
                                        call SetUnitAnimationByIndex(c, 0)
                                        endif
                                        else
                                        call SetUnitAnimationByIndex(c, 0)
                                        endif
                                    else
                                        set r4 = r4 + 0.03
                                    endif
                                    set td = null
                                    if GetUnitCurrentOrder(c) == OrderId("smart") or GetUnitCurrentOrder(c) == OrderId("move") then
                                    if r7> 0.21  then 
                                    set r7 = 0
                                    set td = LoadUnitHandle(hs, GetHandleId(c), StringHash("unit target"))
                                        if td != null then 
                                        set a = GAngle(c, td)
                                        call IssueTargetOrder(c, "attack", td)
                                        set x = GetUnitX(td)
                                        set y = GetUnitY(td)
                                        else
                                        set a = GAngle2(c, x,y)
                                        call IssuePointOrder(c, "move", x,y)
                                        endif
                                      else
                                      set r7 = r7 + 0.03
                                      endif
                                      set r6 = 0.21
                                    elseif GetUnitCurrentOrder(c) == OrderId(OkarunQ_Order) then
                                        call IssuePointOrder(c, OkarunQ_Order, x, y)
                                        set r6 = 0.15
                                    elseif GetUnitCurrentOrder(c) == OrderId(OkarunW_Order) then
                                        set r6 = 0.15
                                        set td = LoadUnitHandle(hs, GetHandleId(c), StringHash("unit target"))
                                        if td != null then
                                            set a = GAngle(c, td)
                                        endif
                                        if r7> 0.21  then 
                                    set r7 = 0
                                    set td = LoadUnitHandle(hs, GetHandleId(c), StringHash("unit target"))                                        
                                        if td != null then
                                        call IssueTargetOrder(c, OkarunW_Order, td)
                                        endif
                                      else
                                      set r7 = r7 + 0.03
                                      endif
                                    elseif GetUnitCurrentOrder(c) == OrderId(OkarunE_Order) then
                                        set r6 = 0.15
                                        set td = LoadUnitHandle(hs, GetHandleId(c), StringHash("unit target"))
                                        if td != null then
                                        set a = GAngle(c, td)
                                        endif
                                        if r7> 0.21  then 
                                    set r7 = 0
                                    set td = LoadUnitHandle(hs, GetHandleId(c), StringHash("unit target"))                                        
                                        if td != null then
                                        call IssueTargetOrder(c, OkarunE_Order, td)
                                        endif
                                      else
                                      set r7 = r7 + 0.03
                                      endif
                                    elseif GetUnitCurrentOrder(c) == OrderId(OkarunR_Order) then
                                        set r6 = 0.15
                                        set td = LoadUnitHandle(hs, GetHandleId(c), StringHash("unit target"))
                                        if td != null then
                                        set a = GAngle(c, td)
                                        endif
                                        if r7> 0.21  then 
                                    set r7 = 0
                                    set td = LoadUnitHandle(hs, GetHandleId(c), StringHash("unit target"))                                        
                                        if td != null then
                                        call IssueTargetOrder(c, OkarunR_Order, td)
                                        endif
                                      else
                                      set r7 = r7 + 0.03
                                      endif
                                    elseif GetUnitCurrentOrder(c) == OrderId(OkarunT_Order) then
                                        set r6 = 0.15
                                        call IssuePointOrder(c, OkarunT_Order, x, y)
                                    elseif GetUnitCurrentOrder(c) == OrderId("attack") then
                                        set r6 = 0.15
                                        set td = LoadUnitHandle(hs, GetHandleId(c), StringHash("unit target"))
                                        if td != null then 
                                        set a = GAngle(c, td)
                                        call IssueTargetOrder(c, "attack", td)
                                        set x = GetUnitX(td)
                                        set y = GetUnitY(td)
                                        else
                                        set a = GAngle2(c, x,y)
                                        call IssuePointOrder(c, "attack", x,y)
                                        endif
                                    endif
                                    if SR3(c,x,y)>150 then 
                                    set a = GetUnitFacing(c)*bj_DEGTORAD
                                   //call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
                                    call MoveUnit(c, move, a)
                                    set rkek = move*2
                                    if rkek> 20 then 
                                    set rkek = 20 
                                    endif
                                    if PathableCheck(GetUnitX(c)+rkek*Cos(a),GetUnitY(c)+rkek*Sin(a)) == false then 
                                    //call MoveUnit(c, rkek, a)
                                    endif
                                    endif
                                else                        
                                    call SetUnitAnimation(c, "stand")
                                    call IssueImmediateOrder(c, "stop")
                                    call SaveReal(hs, GetHandleId(c), StringHash("real x"), 0)
                                    call SaveReal(hs, GetHandleId(c), StringHash("real y"), 0)
                                endif
                            endif
                        endif
                    endif
                    
                    if r2 > 0.06 then
                        set r2 = 0.03
                        if GetUnitAbilityLevel(c, OkarunT_Buff_ID) > 0 then
                                set r3 = r5*OkarunT_bonusspeed
                            endif
                        call BlzFrameSetValue(frame_pas3[k2], r3)
                        call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(r3, 0, 2) + "|r")
                    else
                        set r2 = r2 + 0.03
                    endif
                    if GetUnitAbilityLevel(c, OkarunT_Buff_ID) == 0 and ( GetUnitCurrentOrder(c) == OrderId("stop") or GetUnitCurrentOrder(c) == 0 or IsUnitPaused(c) == true or GetUnitAbilityLevel(c, 'BPSE') == 1) and LoadInteger(hs,GetHandleId(c),StringHash("spell p")) == 0 then
                        set r3 = r3 - (r5 * (OkarunF_DecreaseSpeedPercentPerSec/100))
                        if r3 < GetUnitMoveSpeed(c) then
                      //  if CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false and IsUnitType(c,UNIT_TYPE_DEAD)== false and IntegerCd(c,"sound cd",40)  then 
                            
                          //  endif
                            set r3 = GetUnitMoveSpeed(c)
                        endif
                    endif
                else
                     if GetLocalPlayer() == Player(k2) then
                    call BlzFrameSetVisible(frame_pas1[k2], false)
                endif
                    call DestroyEffect(e)
                    set c = null
                    set td = null
                    set e = null
                    set m_OkarunF[i] = m_OkarunF[MUI_OkarunF]
                    set MUI_OkarunF = MUI_OkarunF - 1
                    if MUI_OkarunF == -1 then
                        call PauseTimer(t_OkarunF)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method OkarunF_Start takes unit NewC returns nothing
            local thistype this = thistype.create()
            set MUI_OkarunF = MUI_OkarunF + 1
            set m_OkarunF[MUI_OkarunF] = this
            set c = NewC
            set td = null
            set check = GetUnitTypeId(c)
            set r = 0
            set r2 = 0
            set r6 = 0.2
            set r7 = 0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set r3 = GetUnitMoveSpeed(c) // СЃС‚Р°СЂС‚РѕРІР°СЏ СЃРєРѕСЂРѕСЃС‚СЊ (РєР°Рї РґРІРёР¶РєР°)
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
                call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Okarun_F", 0, false)
                set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Current speed:" + "|r")
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
            set e = AddSpecialEffectTarget("war3mapimported\\wos_windwalk blood.mdx", c, "origin")
            if MUI_OkarunF == 0 then
                call TimerStart(t_OkarunF, 0.03, true, function thistype.Loop_OkarunF)
            endif
        endmethod
    endstruct

    //----------------------------Okarun-----------------------------------------------
     /* Animations index:
    
    0 - move
    3 - attack 2
    4 - foot atk
    6 - morph
    7 - razgon udara
    8 - udar target
    10 - upercot
    
     */ 
     
    function OkarunPassive_Start takes unit c returns nothing
        call OkarunF_KS.OkarunF_Start( c )
    endfunction
    function OkarunQ_Start takes unit c, real x, real y returns nothing
        call OkarunQ_KS.OkarunQ_Start( c, x, y )
    endfunction
    function OkarunW_Start takes unit c, unit td returns nothing
        call OkarunW_KS.OkarunW_Start( c, td )
    endfunction
    function OkarunE_Start takes unit c, unit td returns nothing
        call OkarunE_KS.OkarunE_Start( c, td )
    endfunction
    function OkarunR_Start takes unit c, real x, real y returns nothing
        call OkarunR_KS.OkarunR_Start( c, x,y )
    endfunction
    function OkarunT_Start takes unit c, real x, real y returns nothing
        call OkarunT_KS.OkarunT_Start( c, x, y)
    endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
