library AkainuSpells uses GearSystems
    globals
//--------------------------------------Akainu--------------------------------------------------------------
        integer Akainu_ID = 'H01A'
//---------------Q ability-----------------------------------------------------
        integer AkainuQ_ID = 'A06V'
        real AkainuQ_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real AkainuQ_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real AkainuQ_Damage2StaticBase = 175 // base static damage for 1 level
        real AkainuQ_Damage2StaticStep = 0 // additional static damage for each next level
        real AkainuQ_DamageAoe = 110
        real AkainuQ_Stun = 1
        real AkainuQ_PushRange = 100 // slow time 2, 3, 4 sec only
        real AkainuQ_PushDuration = 0.21 // slow time 2, 3, 4 sec only
//---------------W ability-----------------------------------------------------
        integer AkainuW_ID = 'A06W' //7 РєСѓР»Р°РєРѕРІ
        real AkainuW_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real AkainuW_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real AkainuW_Damage2StaticBase = 200 // base static damage for 1 level
        real AkainuW_Damage2StaticStep = 0 // additional static damage for each next level
        real AkainuW_DamageAoe = 700
        real AkainuW_DamageAoePunch = 525
        integer AkainuW_Slow = 20 // Caused slow %
        integer AkainuW_Duration = 1 // slow time 2, 3, 4 sec only
//---------------E ability-----------------------------------------------------
        integer AkainuE_ID = 'A06X'
        real AkainuE_DamageAgiBase = 2 // base number x Agi damage for 1 level
        real AkainuE_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real AkainuE_DamageAoe = 575
//---------------R ability-----------------------------------------------------
        integer AkainuR_ID = 'A06Y'
        real AkainuR_DamageAgiBase = 5 // base number x Agi damage for 1 level
        real AkainuR_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real AkainuR_DamageAoe = 480
        real AkainuR_Stun = 1.5 //
        real AkainuR_PushRange = 600 // slow time 2, 3, 4 sec only
        real AkainuR_PushDuration = 0.3 // slow time 2, 3, 4 sec only
//---------------T ability-----------------------------------------------------
        integer AkainuT_ID = 'A06Z' // 36 РєСѓР»Р°РєРѕРІ
        integer AkainuT_Fists = 30
        real AkainuT_DamageAgiBase = 1.2 // for each punch
        real AkainuT_DamageAoe = 2000 // for both variants of e
        real AkainuT_DamageAoePunch = 700 // for both variants of e
        integer AkainuT_Slow = 50 // Caused slow %
        integer AkainuT_Duration = 2 // slow time 2, 3, 4 sec only
//---------------F ability-----------------------------------------------------
        integer AkainuF_ID = 'A070'
        real AkainuF_DamagePhysResist = 15 // %
        real AkainuF_Damage = 2
        real AkainuF_CD = 5
    endglobals

    function AkainuF_Start takes unit c, unit td returns nothing
    if BlzGetUnitAbilityCooldownRemaining(c,FakeAbi_ID) == 0 or GetUnitAbilityLevel(c,FakeAbi_ID)==0 then 
    call DestroyEffect(EffectSpawn("war3mapImported\\wos_GZ_jntxn (11)_R1-200.mdl",GetUnitX(td),GetUnitY(td),1,1,2,1))
    call NextDmg(c,td,AkainuF_Damage*GetHeroAgi(c,true),1,0.03)
    call FakeCD_Start(c,AkainuF_ID,AkainuF_CD,0,0)
    endif
    endfunction

    private struct AkainuQ_KS
        private static timer t_AkainuQ = CreateTimer( )
        private static integer array m_AkainuQ
        private static integer MUI_AkainuQ = -1
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
        effect e
        real a
        real rmax
        private static method Loop_AkainuQ takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AkainuQ
                set this = m_AkainuQ[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit2(c)
                    if r == 0.51 then
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, 1, 255, 255, 255, 255))
                    endif
                    if r > 0.54 then
                        if SR2(c, td) > 120 then
                            set a = GAngle(c, td)
                            call MoveUnit2(c, move, a)
                            call SetUnitFacing(c, a * bj_RADTODEG)
                            if r2>0.06 then 
                            set r2 = 0
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, 1, 255, 255, 255, 255))
                            else
                            set r2 =r2 + 0.03
                            endif
                        else
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            set r = 99999
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_opbr0326 (347).mdl" , x , y, 1, 1., 1, 1))
                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_FSAeff (198)1.mdl", td, "chest"))
                            call StunUnit(c, td, AkainuQ_Stun )
                            call MakeSound("war3mapimported\\Hero_Akainu_Q2")
                            call DecorRemove(c, x, y, aoe, 25)
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    call dmgphys(c, u, dmg)
                                    if GetUnitTypeId(c) == Akainu_ID and GetHeroLevel(c)>= 35  then 
                                    call AkainuF_Start(c,u)
                                    endif
                                    call MUE(u,AkainuQ_PushRange,AkainuQ_PushDuration,a)
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
                    call DestroyEffect(e)
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set td = null
                    set e = null
                    set u = null
                    set m_AkainuQ[i] = m_AkainuQ[ MUI_AkainuQ]
                    set MUI_AkainuQ = MUI_AkainuQ - 1
                    if MUI_AkainuQ == -1 then
                        call PauseTimer( t_AkainuQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method AkainuQ_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_AkainuQ = MUI_AkainuQ + 1
            set m_AkainuQ[ MUI_AkainuQ] = this
            set c = NewC
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r = 0
            set r2 = 0
            set move = 75
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set aoe = AkainuQ_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( AkainuQ_DamageAgiBase + ( AkainuQ_DamageAgiStep * ( GetUnitAbilityLevel( c , AkainuQ_ID) - 1 ) ) )
            set dmg = dmg + AkainuQ_Damage2StaticBase + ( AkainuQ_Damage2StaticStep * ( GetUnitAbilityLevel( c , AkainuQ_ID) - 1 ) )
            set rmax = 2.1
            call SetUnitAnimationByIndex(c, 9)
            call SetUnitTimeScale(c, 0.4)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_magmahandBig-91F172.mdl", c, "hand right")
            call MakeSound("war3mapimported\\Hero_Akainu_Q")
            if MUI_AkainuQ == 0 then
                call TimerStart( t_AkainuQ, 0.03, true, function thistype.Loop_AkainuQ)
            endif
        endmethod
    endstruct

    private struct AkainuW2_KS
        private static timer t_AkainuW2 = CreateTimer( )
        private static integer array m_AkainuW2
        private static integer MUI_AkainuW2 = -1
        unit c
        real x
        real y
        group g
        unit u
        real dmg
        real aoe
        real move
        real r
        effect e
        real a
        real rmax
        private static method Loop_AkainuW2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AkainuW2
                set this = m_AkainuW2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call MoveEff(e, move, a)
                    call VisionTimed(GetOwningPlayer(c), GetEffX(e), GetEffY(e) , aoe, 1)
                    call DecorRemove(c, GetEffX(e), GetEffY(e) , aoe, 20)
                else
                    set x = GetEffX(e)
                    set y = GetEffY(e)
                    call MakeSound("war3mapimported\\Hero_Akainu_W2")
                    call DecorRemove(c, x, y, aoe, 25)
                    call VisionTimed(GetOwningPlayer(c), GetEffX(e), GetEffY(e) , aoe, 2)
                    call DecorRemove(c, GetEffX(e), GetEffY(e) , aoe, 50)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_opbr0326 (347).mdl" , x , y, 1, 1., 1, 1))
                    call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                            call dmgmag(c, u, dmg)                             
                            call SlowUnit(c, u, AkainuW_Slow , AkainuW_Duration)
                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    set u = null
                    call DestroyEffect(e)
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set e = null
                    set u = null
                    set m_AkainuW2[i] = m_AkainuW2[ MUI_AkainuW2]
                    set MUI_AkainuW2 = MUI_AkainuW2 - 1
                    if MUI_AkainuW2 == -1 then
                        call PauseTimer( t_AkainuW2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method AkainuW2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_AkainuW2 = MUI_AkainuW2 + 1
            set m_AkainuW2[ MUI_AkainuW2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set g = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set aoe = AkainuW_DamageAoePunch
            set dmg = GetHeroAgi( c , true) * ( AkainuW_DamageAgiBase + ( AkainuW_DamageAgiStep * ( GetUnitAbilityLevel( c , AkainuW_ID) - 1 ) ) )
            set dmg = dmg + AkainuW_Damage2StaticBase + ( AkainuW_Damage2StaticStep * ( GetUnitAbilityLevel( c , AkainuW_ID) - 1 ) )
            set dmg = dmg / 5
            set rmax = 0.27
            set e = EffectSpawn("war3mapImported\\wos_magmahandBig-91F17.mdl", GetUnitX(c) + 110 * Cos(a), GetUnitY(c) + 110 * Sin(a), a * bj_RADTODEG, 1, 1.25, 110)
            set move = SR5(e, x, y) / 9
            if MUI_AkainuW2 == 0 then
                call TimerStart( t_AkainuW2, 0.03, true, function thistype.Loop_AkainuW2)
            endif
        endmethod
    endstruct

    private struct AkainuW_KS
        private static timer t_AkainuW = CreateTimer( )
        private static integer array m_AkainuW
        private static integer MUI_AkainuW = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        real r3
        integer check
        real aoe
        real r
        effect e
        effect e2
        real rmax
        private static method Loop_AkainuW takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr1 = 0
            local real rr2 = 0
            loop
                exitwhen i > MUI_AkainuW
                set this = m_AkainuW[i]
                if SpellBoolCaster(c) and r <= rmax and check < 5 then
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit2(c)
                    if r == 0.15 then
                        call MakeSound("war3mapimported\\Hero_Akainu_W")
                        call SetUnitAnimationByIndex(c, 0)
                        call SetUnitTimeScale(c, 1.5)
                    endif
                    if r > 0.15 then
                        if r3 > 0.3 then
                            set r3 = 0.03
                            call SetUnitAnimationByIndex(c, 0)
                        else
                            set r3 = r3 + 0.03
                        endif
                        if r2 > 0.15 then
                            set r2 = 0.03
                            set rr1 = GetRandomReal(150, 375)
                            set rr2 = GetRandomReal(0, 359) * bj_DEGTORAD
                            set x1 = x + rr1 * Cos(rr2)
                            set y1 = y + rr1 * Sin(rr2)
                            call AkainuW2_KS.AkainuW2_Start(c, x1, y1)
                            set check = check + 1
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    call StopSpellUnit2(c)
                    call SetUnitTimeScale( c , 1)
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    set c = null
                    set e = null
                    set e2 = null
                    set m_AkainuW[i] = m_AkainuW[ MUI_AkainuW]
                    set MUI_AkainuW = MUI_AkainuW - 1
                    if MUI_AkainuW == -1 then
                        call PauseTimer( t_AkainuW)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method AkainuW_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_AkainuW = MUI_AkainuW + 1
            set m_AkainuW[ MUI_AkainuW] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r3 = 0
            set check = 0
            set r2 = 10
            call StartSpellUnit2(c)
            set aoe = AkainuW_DamageAoe
            set rmax = 2.1
            call SetUnitAnimationByIndex(c, 7)
            call SetUnitTimeScale(c, 0.5)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_magmahandBig-91F172.mdl", c, "hand right")
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_magmahandBig-91F172.mdl", c, "hand left")
            call MakeSound("war3mapimported\\Hero_Akainu_W3")
            if MUI_AkainuW == 0 then
                call TimerStart( t_AkainuW, 0.03, true, function thistype.Loop_AkainuW)
            endif
        endmethod
    endstruct

    private struct AkainuE_KS
        private static timer t_AkainuE = CreateTimer( )
        private static integer array m_AkainuE
        private static integer MUI_AkainuE = -1
        unit c
        unit td
        real x
        real y
        real r2
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
        real a
        real rmax
        private static method Loop_AkainuE takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AkainuE
                set this = m_AkainuE[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r < 0.6 then
                        call DebugUnit(c)
                    endif
                    if r == 0.3 then
                        set e = AddSpecialEffectTarget("war3mapImported\\wos_magmahandBig-91F172.mdl", c, "hand right")
                        set e2 = AddSpecialEffectTarget("war3mapImported\\wos_magmahandBig-91F172.mdl", c, "hand left")
                    endif
                    if r == 0.6 then
                        set e3 = EffectSpawn("war3mapImported\\wos_opbr0326 (762).mdl", GetUnitX(c) + 0 * Cos(a), GetUnitY(c) + 0 * Sin(a), a * bj_RADTODEG, 2, 0.6, 0)
                        call MakeSound("war3mapimported\\Hero_Akainu_E2")
                        call StopSpellUnit(c)
                        call DestroyEffect(e)
                        call DestroyEffect(e2)
                        set e = null
                        set e2 = null
                    endif
                    if r > 0.6 then
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        set a = GAngle5(e3, x, y)
                        if SR5(e3, x, y) > 350 then
                            if r2 > 0.03 then
                                set r2 = 0
                                call VisionTimed(GetOwningPlayer(c), GetEffX(e3), GetEffY(e3) , aoe, 1)
                                call DecorRemove(c, GetEffX(e3), GetEffY(e3) , aoe, 50)
                                call GroupClear(g)
                                call GroupEnumUnitsInRange( g , GetEffX(e3), GetEffY(e3) , aoe , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                        call dmgmag(c, u, dmg)
                                        call GroupAddUnit(g2, u)
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                            else
                                set r2 = r2 + 0.03
                            endif
                            call BlzSetSpecialEffectYaw(e3, a)
                            call MoveEff(e3, move, a)
                        else
                            set r = 9999
                        endif
                    endif                   
                else
                    call StopSpellUnit(c)
                    if r >= 0.3 and r < 0.6 then
                        call DestroyEffect(e)
                        call DestroyEffect(e2)
                    endif
                    if r < 0.6 then
                        call StopSpellUnit2(c)
                    endif
                    if r >= 0.6 then
                        if r == 9999 then
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                        else
                            set x = GetEffX(e3) + 300 * Cos(a)
                            set y = GetEffY(e3) + 300 * Sin(a)
                        endif
                        call VisionTimed(GetOwningPlayer(c), x, y , aoe, 1)
                        call DecorRemove(c, x, y , aoe, 50)
                        call BlzSetSpecialEffectTimeScale(e3, 5)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_opbr0326 (344).mdl" , x , y, 1, 2., 1, 1))
                        call GroupClear(g)
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                call dmgmag(c, u, dmg)
                                call GroupAddUnit(g2, u)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                        call DestroyEffect(e3)
                    endif
                    call SetUnitTimeScale( c , 1)
                    call DestroyGroup( g )
                    call DestroyGroup( g2 )
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set td = null
                    set u = null
                    set m_AkainuE[i] = m_AkainuE[ MUI_AkainuE]
                    set MUI_AkainuE = MUI_AkainuE - 1
                    if MUI_AkainuE == -1 then
                        call PauseTimer( t_AkainuE)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method AkainuE_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_AkainuE = MUI_AkainuE + 1
            set m_AkainuE[ MUI_AkainuE] = this
            set c = NewC
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r = 0
            set r2 = 0
            set move = 75
            call StartSpellUnit(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set aoe = AkainuE_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( AkainuE_DamageAgiBase + ( AkainuE_DamageAgiStep * ( GetUnitAbilityLevel( c , AkainuE_ID) - 1 ) ) )
            set rmax = 2.4
            call SetUnitAnimationByIndex(c, 2)
            call SetUnitTimeScale(c, 1)
            call MakeSound("war3mapimported\\Hero_Akainu_E")
            call MakeSound("war3mapimported\\Hero_Akainu_E3")
            if MUI_AkainuE == 0 then
                call TimerStart( t_AkainuE, 0.03, true, function thistype.Loop_AkainuE)
            endif
        endmethod
    endstruct

    private struct AkainuR_KS
        private static timer t_AkainuR = CreateTimer( )
        private static integer array m_AkainuR
        private static integer MUI_AkainuR = -1
        unit c
        real x
        real y
        real r2
        real r5
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
        private static method Loop_AkainuR takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AkainuR
                set this = m_AkainuR[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call DebugUnit(c)
                    if r == 0.72 then
                        call MakeSound("war3mapimported\\Hero_Akainu_R2")
                        set x = GetUnitX(c) + 150 * Cos(a)
                        set y = GetUnitY(c) + 150 * Sin(a)
                        set r5 = 0.2
                        call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_obr08 (24).mdl", GetUnitX(c) + 110 * Cos(a + 25 * bj_DEGTORAD), GetUnitY(c) + 110 * Sin(a + 25 * bj_DEGTORAD), a * bj_RADTODEG, 0.9, 1.62, 116), 0.56, 255, 255, 255, 0.3)
                    endif
                    if r > 0.72 then
                        set x = x + move * Cos(a)
                        set y = y + move * Sin(a)
                        call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_opbr0326 (40).mdl", x, y, a * bj_RADTODEG, 2, r5, 1), 0, 255, 255, 255, 0.6)
                        if r2 > 0.03 then
                            set r5 = r5 + 0.16
                            set r2 = 0
                            call DecorRemove(c, x, y, aoe, 100)
                            call VisionTimed(GetOwningPlayer(c), x, y , aoe + 400, 2)
                   
                            call GroupClear(g)
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                    call dmgphys(c, u, dmg)
                                    call GroupAddUnit(g2, u)
                                      if GetUnitTypeId(c) == Akainu_ID and GetHeroLevel(c)>= 35  then 
                                       call AkainuF_Start(c,u)
                                      endif
                                    call StunUnit(c, u, AkainuR_Stun)
                                    call MUE(u, AkainuR_PushRange, AkainuR_PushDuration, a)
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    call DestroyEffect(e)
                    call StopSpellUnit(c)
                    call DestroyGroup( g )
                    call DestroyGroup( g2 )
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set u = null
                    set m_AkainuR[i] = m_AkainuR[ MUI_AkainuR]
                    set MUI_AkainuR = MUI_AkainuR - 1
                    if MUI_AkainuR == -1 then
                        call PauseTimer( t_AkainuR)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method AkainuR_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_AkainuR = MUI_AkainuR + 1
            set m_AkainuR[ MUI_AkainuR] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 50
            set move = 165
            call StartSpellUnit(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set aoe = AkainuR_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( AkainuR_DamageAgiBase + ( AkainuR_DamageAgiStep * ( GetUnitAbilityLevel( c , AkainuR_ID) - 1 ) ) )
            set rmax = 0.99
            call SetUnitAnimationByIndex(c, 4)
            call SetUnitTimeScale(c, 1)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_magmahandBig-91F172.mdl", c, "hand right")
            call MakeSound("war3mapimported\\Hero_Akainu_R")
            if MUI_AkainuR == 0 then
                call TimerStart( t_AkainuR, 0.03, true, function thistype.Loop_AkainuR)
            endif
        endmethod
    endstruct

    private struct AkainuT2_KS
        private static timer t_AkainuT2 = CreateTimer( )
        private static integer array m_AkainuT2
        private static integer MUI_AkainuT2 = -1
        unit c
        real x
        real y
        group g
        unit u
        real dmg
        real aoe
        real r
        effect e
        real a
        real rmax
        private static method Loop_AkainuT2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AkainuT2
                set this = m_AkainuT2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                  else
                    set x = GetEffX(e)
                    set y = GetEffY(e)
                    call DecorRemove(c, x, y, aoe, 100)
                    if GetRandomInt(1, 2) == 2 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_opbr0326 (347).mdl" , x , y, 1, 1., 1, 1))
                    endif
                    call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                            call dmgmag(c, u, dmg)
                            call SlowUnit(c, u, AkainuT_Slow , AkainuT_Duration)
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    set u = null
                    call DestroyEffect(e)
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set e = null
                    set u = null
                    set m_AkainuT2[i] = m_AkainuT2[ MUI_AkainuT2]
                    set MUI_AkainuT2 = MUI_AkainuT2 - 1
                    if MUI_AkainuT2 == -1 then
                        call PauseTimer( t_AkainuT2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method AkainuT2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_AkainuT2 = MUI_AkainuT2 + 1
            set m_AkainuT2[ MUI_AkainuT2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set g = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set aoe = AkainuT_DamageAoePunch
            set dmg = GetHeroAgi( c , true) * AkainuT_DamageAgiBase
            set rmax = 0.39
            set e = EffectSpawn("war3mapImported\\wos_OP (114).mdl", x, y, a * bj_RADTODEG, 1, 0.5, 1)
            if MUI_AkainuT2 == 0 then
                call TimerStart( t_AkainuT2, 0.03, true, function thistype.Loop_AkainuT2)
            endif
        endmethod
    endstruct

    private struct AkainuT_KS
        private static timer t_AkainuT = CreateTimer( )
        private static integer array m_AkainuT
        private static integer MUI_AkainuT = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        real r3
        integer check
        real aoe
        real r
        effect e
        effect e2
        effect e3
        real a
        real rmax
        private static method Loop_AkainuT takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr1 = 0
            local real rr2 = 0
            loop
                exitwhen i > MUI_AkainuT
                set this = m_AkainuT[i]
                if (SpellBoolCaster(c) or r > 3) and r <= rmax and check < AkainuT_Fists then
                    set r = RoundReal(r + 0.03, 3)
                    if r == 1.65 then
                        call SetUnitTimeScale(c, 0.15)
                        call MakeSound("war3mapimported\\Hero_Akainu_T2")
                    endif
                    if r > 1.32 and r < 1.8 then
                        if r3 > 0.09 then
                            set r3 = 0
                            set e3 = EffectSpawn3("war3mapImported\\wos_OP (114).mdl", (GetUnitX(c) + 300 * Cos(a)) + 85 * Cos(a + 60 * bj_DEGTORAD), (GetUnitY(c) + 300 * Sin(a)) + 85 * Sin(a + 60 * bj_DEGTORAD), a * bj_RADTODEG + 180, 1, 0.25, 800, -205)
                            call EMUE(e3, 900, 0.12, a)
                            call EHeightSet(e3, 0.12, 1800)
                            call MyRemoveEff(e3, 0.45)
                            set e3 = null
                            set e3 = EffectSpawn3("war3mapImported\\wos_OP (114).mdl", (GetUnitX(c) + 300 * Cos(a)) + 85 * Cos(a - 60 * bj_DEGTORAD), (GetUnitY(c) + 300 * Sin(a)) + 85 * Sin(a - 60 * bj_DEGTORAD), a * bj_RADTODEG + 180, 1, 0.25, 800, -205)
                            call EMUE(e3, 900, 0.12, a)
                            call EHeightSet(e3, 0.12, 1800)
                            call MyRemoveEff(e3, 0.45)
                            set e3 = null
                        else
                            set r3 = r3 + 0.03
                        endif
                    endif
                    if r < 1.8 then
                        call DebugUnit(c)
                    endif
                    if r == 1.8 then
                        call VisionTimed(GetOwningPlayer(c), x, y, aoe + 600, 4.5)
                        call StopSpellUnit(c)
                        call DestroyEffect(e)
                        call DestroyEffect(e2)
                    endif
                    if  r == 4.2 then
                        call MakeSound("war3mapimported\\Hero_Akainu_T3")
                    endif
                    if r > 1.8 then
                        if r2 > 0.15 then
                            set r2 = 0.03
                            set rr1 = GetRandomReal(155, aoe / 2)
                            set rr2 = GetRandomReal(0, 359) * bj_DEGTORAD
                            set x1 = x + rr1 * Cos(rr2)
                            set y1 = y + rr1 * Sin(rr2)
                            call AkainuT2_KS.AkainuT2_Start(c, x1, y1)
                            set check = check + 1
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    if r < 1.68 then
                        call DestroyEffect(e)
                        call DestroyEffect(e2)
                    endif
                    call StopSpellUnit(c)
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set m_AkainuT[i] = m_AkainuT[ MUI_AkainuT]
                    set MUI_AkainuT = MUI_AkainuT - 1
                    if MUI_AkainuT == -1 then
                        call PauseTimer( t_AkainuT)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method AkainuT_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_AkainuT = MUI_AkainuT + 1
            set m_AkainuT[ MUI_AkainuT] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set r3 = 0
            set check = 0
            call StartSpellUnit(c)
            set a = GAngle2( c , x , y ) // Angle Between points
            set aoe = AkainuT_DamageAoe
            set rmax = 25
            call SetUnitAnimationByIndex(c, 6)
            call SetUnitTimeScale(c, 3.3)
            call MakeSound("war3mapimported\\Hero_Akainu_T")
            set e = AddSpecialEffectTarget("war3mapImported\\wos_magmahandBig-91F172.mdl", c, "hand right")
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_magmahandBig-91F172.mdl", c, "hand left")
            if MUI_AkainuT == 0 then
                call TimerStart( t_AkainuT, 0.03, true, function thistype.Loop_AkainuT)
            endif
        endmethod
        
    endstruct

    //----------------------------Akainu-----------------------------------------------
     /* Animations index:
    0 - atk
    2 - E
    3 - dodje f
    4 - R
    5 - udar in floor
    6 - t start
    7 - stand
    8 - move
    
     */ 
   
    function AkainuQ_Start takes unit c, unit td returns nothing
        call AkainuQ_KS.AkainuQ_Start( c, td )
    endfunction
    
    function AkainuW_Start takes unit c, real x, real y returns nothing
        call AkainuW_KS.AkainuW_Start( c, x, y )
    endfunction
    function AkainuE_Start takes unit c, unit td returns nothing
        call AkainuE_KS.AkainuE_Start( c, td )
    endfunction
    function AkainuR_Start takes unit c, real x, real y returns nothing
        call AkainuR_KS.AkainuR_Start( c, x, y )
    endfunction
    function AkainuT_Start takes unit c, real x, real y returns nothing
        call AkainuT_KS.AkainuT_Start( c, x, y)
    endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com