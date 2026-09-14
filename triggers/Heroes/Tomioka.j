library TomiokaSpells uses GearSystems
    globals
//--------------------------------------Tomioka--------------------------------------------------------------
        integer Tomioka_ID = 'H00A'
//---------------G ability-----------------------------------------------------
        integer TomiokaG_ID = 'A026'
        real Tomioka_G_AddDamageBase = 0.4 // x agi after cast 1 spell
        real Tomioka_G_AddDamageStep = 0.3 // x agi additional after cast 1 spell
        integer Tomioka_G_AddDamageMaxStacks = 6 // 4 stacks = 2. x agi damage per skill additional
        real Tomioka_G_BuffDuration = 4 // in seconds
        real Tomioka_G_CD = 20 // in seconds
//---------------Q ability-----------------------------------------------------
        integer TomiokaQ_ID = 'A021'
        real TomiokaQ_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real TomiokaQ_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real TomiokaQ_Damage2StaticBase = 175 // base static damage for 1 level
        real TomiokaQ_Damage2StaticStep = 0 // additional static damage for each next level
        real TomiokaQ_DamageAoe = 150
        real TomiokaQ_Stun = 1
//---------------W ability-----------------------------------------------------
        integer TomiokaW_ID = 'A022'
        boolean TomiokaW_InvulGain = false // false = no invul, true = have invul
        real TomiokaW_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real TomiokaW_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real TomiokaW_Damage2StaticBase = 150 // base static damage for 1 level
        real TomiokaW_Damage2StaticStep = 0 // additional static damage for each next level
        real TomiokaW_DamageAoe = 465
        integer TomiokaW_Slow = 30 // Caused slow %
        integer TomiokaW_Duration = 3 // slow time 2, 3, 4 sec only
        real TomiokaW_PushRange = 600 // Stun time from combo QW
        real TomiokaW_PushDuration = 0.51 // Stun time from combo QW
//---------------E ability-----------------------------------------------------
        integer TomiokaE_ID = 'A023'
        real TomiokaE_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real TomiokaE_DamageAgiStep = 0 // additional number x Agi damage for each next level
        real TomiokaE_DamageAoe = 675
        integer TomiokaE_AtkCountBase = 3
        integer TomiokaE_AtkCountStep = 1
//---------------R ability-----------------------------------------------------
        integer TomiokaR_ID = 'A024'
        real TomiokaR_DamageAgiBase = 3 // base number x Agi damage for 1 level
        real TomiokaR_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real TomiokaR_DamageAoe = 700
//---------------T ability-----------------------------------------------------
        integer TomiokaT_ID = 'A025'
        real TomiokaT_DamageAgiBase = 10 // agi number of damage
        real TomiokaT_DamageAoe = 400 // for both variants of e
//---------------F ability-----------------------------------------------------
        integer TomiokaF_ID = 'A027'
        real TomiokaF_DamageAgiBase = 0.8 // agi number of damage
        real TomiokaF_DamageAoe = 875 // for both variants of e
        real TomiokaF_Duration = 3 // not lower than 3.0
//----------------------------Combos-----------------------------------------------------
        real TomiokaCombo_QE_Stun = 0.2 // Stun time from combo QE
        real TomiokaCombo_QW_PushRange = 600 // Stun time from combo QW
        real TomiokaCombo_WQ_Stun = 1.5 // Stun time from combo WQ ( replac default stun time from q)
        integer TomiokaCombo_WE_Slow = 60 // Caused slow % ( replace default slow % from W )
        integer TomiokaCombo_WE_SlowDuration = 3 // Caused slow % ( replace default slow % from W )
//------------------------------------------------------------------------------
    endglobals

    private struct TomiokaQ_KS
        private static timer t_TomiokaQ = CreateTimer( )
        private static integer array m_TomiokaQ
        private static integer MUI_TomiokaQ = -1
        unit c
        unit td
        real x
        real y
        group g
        unit u
        real dmg
        integer check2
        real aoe
        real move
        real r
        effect e
        real a
        real r5 
        real rmax
        private static method Loop_TomiokaQ takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_TomiokaQ
                set this = m_TomiokaQ[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    if r == r5 then
                    call MakeSound("war3mapimported\\Hero_Tomioka_Q2")
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, 1, 255, 255, 255, 255))
                    endif
                    if r > r5 then
                        if SR2(c, td) > 120 then
                            set a = GAngle(c, td)
                            call MoveUnit(c, move, a)
                            call SetUnitFacing(c, a * bj_RADTODEG)
                        else
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            set r = 99999
                            call MakeSound("war3mapimported\\Hero_Tomioka_Q3")
                            call MakeSound("war3mapimported\\Hero_Tomioka_W4")
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlash.mdl" , x + 25 * Cos(a), y + 25 * Sin(a), 1, 1., 1.375, 125))
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_TanjiroEffect229.mdl", x - 100 * Cos(a), y - 100 * Sin(a), a * bj_RADTODEG, 1.5, 2.65, 135), 0.36, 255, 255, 255, 0.3)
                            if check2 == 1 then
                                call StunUnit(c, td, TomiokaCombo_WQ_Stun)
                            else
                                call StunUnit(c, td, TomiokaQ_Stun )
                            endif
                            call DecorRemove(c,x,y,aoe,25)
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
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
                    set m_TomiokaQ[i] = m_TomiokaQ[ MUI_TomiokaQ]
                    set MUI_TomiokaQ = MUI_TomiokaQ - 1
                    if MUI_TomiokaQ == -1 then
                        call PauseTimer( t_TomiokaQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method TomiokaQ_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_TomiokaQ = MUI_TomiokaQ + 1
            set m_TomiokaQ[ MUI_TomiokaQ] = this
            set c = NewC
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r = 0
            set move = 75
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set check2 = 0
            set r5 = 0.45
            if GetHeroLevel(c)>= 35 then 
            set r5 = 0.21
            call SetUnitTimeScale(c, 0.4)
            else
            call SetUnitTimeScale(c, 0.19)
            endif
            set a = GAngle2( c , x , y ) // Angle Between points
            if LoadInteger(hs, GetHandleId(c), StringHash("skill w")) > 0 then
                call SaveInteger(hs, GetHandleId(c), StringHash("skill w"), 0)
                set check2 = 1
                call DisplayTimedTextToPlayer(GetOwningPlayer(c), 0, 0, 1, "|c0084D7FF W+Q combo! Target gain stun at the end|r")
            endif
            set aoe = TomiokaQ_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( TomiokaQ_DamageAgiBase + ( TomiokaQ_DamageAgiStep * ( GetUnitAbilityLevel( c , TomiokaQ_ID) - 1 ) ) )
            set dmg = dmg + TomiokaQ_Damage2StaticBase + ( TomiokaQ_Damage2StaticStep * ( GetUnitAbilityLevel( c , TomiokaQ_ID) - 1 ) )
            if LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg")) > 0 then
                set dmg = dmg + GetHeroAgi( c , true) * ( Tomioka_G_AddDamageBase + ( Tomioka_G_AddDamageStep * ( LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg")) - 1 ) ) )
            endif
            set rmax = 2.9
            call SetUnitAnimationByIndex(c, 5)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_e tanjiro (4).mdl", c, "weapon")
            call MakeSound("war3mapimported\\Hero_Tomioka_Q1")
            if MUI_TomiokaQ == 0 then
                call TimerStart( t_TomiokaQ, 0.03, true, function thistype.Loop_TomiokaQ)
            endif
        endmethod
    endstruct

    private struct TomiokaW_KS
        private static timer t_TomiokaW = CreateTimer( )
        private static integer array m_TomiokaW
        private static integer MUI_TomiokaW = -1
        unit c
        real x
        real y
        group g
        unit u
        real dmg
        integer check2
        real aoe
        real move
        real r
        effect e
        effect e2
        real r5
        real a
        real rmax
        private static method Loop_TomiokaW takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_TomiokaW
                set this = m_TomiokaW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
            if false then//GetHeroLevel(c)>= 35 then
            call DebugUnit(c)
            else
            call DebugUnit2(c)
            endif
                    if r == r5 then
                        call SetUnitAnimationByIndex(c, 11)
                        call SetUnitTimeScale(c, 0.35)
                        set e2 = EffectSpawn("war3mapImported\\wos_water dash.mdl", GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), a * bj_RADTODEG, 1, 1.65, 0)
                    endif
                    if r > r5+0.15 then
                    set a = GAngle2(c,x,y)
                        if SR3(c, x, y) > 120 then
                            call MoveUnit(c, move, a)
                            call MoveEff(e2, move, a)
                        else
                            call MakeSound("war3mapimported\\Hero_Tomioka_W2")
                            set r = 99999
                            call DecorRemove(c,x,y,aoe,40)
                            call MUE(c, 500, 0.3, a)
                            call EMUE(e2, 500, 0.3, a)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_tanjiroqdash2.mdl", x, y, a * bj_RADTODEG, GetRandomReal(0.85, 1.4), 0.95, 80))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_e tanjiro (27)_blue.mdl", x + 10 * Cos(a + 90 * bj_DEGTORAD), y + 10 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 90, GetRandomReal(0.85, 1.4), 3.15, 80))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_e tanjiro (27)_blue.mdl", x - 10 * Cos(a + 90 * bj_DEGTORAD), y - 10 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG - 90, GetRandomReal(0.75, 1.4), 3.15, 80))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_e tanjiro (27)_blue.mdl", x + 50 * Cos(a + 90 * bj_DEGTORAD), y + 50 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG + 90, GetRandomReal(0.85, 1.4), 3.15, 80))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_e tanjiro (27)_blue.mdl", x - 50 * Cos(a + 90 * bj_DEGTORAD), y - 50 * Sin(a + 90 * bj_DEGTORAD), a * bj_RADTODEG - 90, GetRandomReal(0.75, 1.4), 3.15, 80))
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    call dmgphys(c, u, dmg)
                                    if check2 == 0 then
                                        call MUE(u, TomiokaW_PushRange, TomiokaW_PushDuration, a)
                                    else
                                        call MUE(u, TomiokaW_PushRange + TomiokaCombo_QW_PushRange , TomiokaW_PushDuration, a)
                                    endif
                                    call SlowUnit(c, u, TomiokaW_Slow , TomiokaW_Duration)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        endif
                    endif
                else                
            if false then//GetHeroLevel(c)>= 35 then 
            call StopSpellUnit(c)
            else
            call StopSpellUnit2(c)
            endif
                    call SetUnitTimeScale( c , 1)
                    call DestroyEffect(e)
                    call MyRemoveEff(e2, 0.3)
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_TomiokaW[i] = m_TomiokaW[ MUI_TomiokaW]
                    set MUI_TomiokaW = MUI_TomiokaW - 1
                    if MUI_TomiokaW == -1 then
                        call PauseTimer( t_TomiokaW)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method TomiokaW_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_TomiokaW = MUI_TomiokaW + 1
            set m_TomiokaW[ MUI_TomiokaW] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set move = 80
            if false then //GetHeroLevel(c)>= 35 then 
            call StartSpellUnit(c)
            else
            call StartSpellUnit2(c)
            endif
            set r5 = 0.36            
            call SetUnitAnimationByIndex(c, 7)
            if GetHeroLevel(c)>= 35 then 
            set r5 = 0.18
            call SetUnitTimeScale(c, 1.2)
            else
            call SetUnitTimeScale(c, 0.65)
            endif
            set g = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set aoe = TomiokaW_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( TomiokaW_DamageAgiBase + ( TomiokaW_DamageAgiStep * ( GetUnitAbilityLevel( c , TomiokaW_ID) - 1 ) ) )
            set dmg = dmg + TomiokaW_Damage2StaticBase + ( TomiokaW_Damage2StaticStep * ( GetUnitAbilityLevel( c , TomiokaW_ID) - 1 ) )
            if LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg")) > 0 then
                set dmg = dmg + GetHeroAgi( c , true) * ( Tomioka_G_AddDamageBase + ( Tomioka_G_AddDamageStep * ( LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg")) - 1 ) ) )
            endif
            set rmax = 1.2
            set check2 = 0
            if LoadInteger(hs, GetHandleId(c), StringHash("skill q")) > 0 then
                call SaveInteger(hs, GetHandleId(c), StringHash("skill q"), 0)
                set check2 = 1
                call DisplayTimedTextToPlayer(GetOwningPlayer(c), 0, 0, 1, "|c0084D7FF Q+W combo! enemy additionally pushed away|r")
            endif
            set e = AddSpecialEffectTarget("war3mapImported\\wos_e tanjiro (4).mdl", c, "weapon")
            call MakeSound("war3mapimported\\Hero_Tomioka_W1")
            if MUI_TomiokaW == 0 then
                call TimerStart( t_TomiokaW, 0.03, true, function thistype.Loop_TomiokaW)
            endif
        endmethod
    endstruct

    private struct TomiokaE_KS
        private static timer t_TomiokaE = CreateTimer( )
        private static integer array m_TomiokaE
        private static integer MUI_TomiokaE = -1
        unit c
        unit td
        unit d
        real x
        real y
        real r2
        integer k
        integer k2
        group g
        unit u
        real dmg
        integer check
        integer check2
        integer check3
        real aoe
        real r
        effect e
        real a
        real rmax
        private static method Loop_TomiokaE takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_TomiokaE
                set this = m_TomiokaE[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax and check < check3 then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    if r == 0.6 then
                        call MakeSound("war3mapimported\\Hero_Tomioka_E02")
                    endif
                    if r == 1.2 then
                        call MakeSound("war3mapimported\\Hero_Tomioka_E03")
                    endif
                    if r2 > 0.12 then
                        set r2 = 0
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        set k = 0
                        if check > 0 then
                            call GroupClear(g)
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    set k = k + 1
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                            if k > 0 then
                                set k2 = GetRandomInt(1, k)
                                call GroupClear(g)
                                call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                        set k2 = k2 + 1
                                        if k2 == k then
                                            set td = u
                                        endif
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                            else
                            if SpellBoolCaster(d) then 
                            set td = d 
                            else
                                set r = 9999
                            endif
                            endif
                           
                        endif
                        set u = null
                        call SetUnitTimeScale(c, 3)
                        call SetUnitAnimation(c, "attack")
                        if GetRandomInt(1, 2) == 1 then
                            call MakeSound("war3mapimported\\Hero_Tomioka_E3")
                        else
                            call MakeSound("war3mapimported\\Hero_Tomioka_E2")
                        endif
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        set check = check + 1
                        set a = GetRandomReal(0, 359) * bj_DEGTORAD
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.35, 1, 255, 255, 255, 145))
                        call PosUnit(c, x - 125 * Cos(a), y - 125 * Sin(a))
                        set a = GAngle(c, td)
                        call SetUnitFacing(c, a * bj_RADTODEG)
                        call dmgphys(c, td, dmg)
                        if check2 == 1 then
                            call StunUnit(c, td, TomiokaCombo_QE_Stun )
                        elseif check2 == 2 then
                            call SlowUnit(c, td, TomiokaCombo_WE_Slow, TomiokaCombo_WE_SlowDuration)
                        endif
                            call DecorRemove(c,x,y,175,25)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_bloodex-special-23.mdl", x, y, GetRandomReal(0, 359), 2.5, 2, 80))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_BrightBlueSlash.mdl", x, y, GetRandomReal(0, 359), 0.4, 2.5, 25))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_Shockwave_b.mdl", x, y, GetRandomReal(0, 359), 2, 2, 125))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZK_ZL_BS_Arthur.mdl", x, y, 1, 2, 2, 125))
                    else
                        set r2 = r2 + 0.03
                    endif
                else
                    call StopSpellUnit(c)
                    call SetUnitTimeScale( c , 1)
                    call DestroyEffect(e)
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set e = null
                    set td = null
                    set d = null
                    set u = null
                    set m_TomiokaE[i] = m_TomiokaE[ MUI_TomiokaE]
                    set MUI_TomiokaE = MUI_TomiokaE - 1
                    if MUI_TomiokaE == -1 then
                        call PauseTimer( t_TomiokaE)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method TomiokaE_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_TomiokaE = MUI_TomiokaE + 1
            set m_TomiokaE[ MUI_TomiokaE] = this
            set c = NewC
            set td = NewTd
            set d = td 
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r = 0
            set r2 = 0
            call StartSpellUnit(c)
            set g = CreateGroup()
            set check = R2I(LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg"))/2)
            set check3 = TomiokaE_AtkCountBase + ( TomiokaE_AtkCountStep * ( GetUnitAbilityLevel( c , TomiokaE_ID) - 1 ) )+check//+ check
            call DisplayTimedTextToPlayer(GetOwningPlayer(c), 0, 0, 1, "|c0084D7FFAdditional attacks: |r"+I2S(check))
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set aoe = TomiokaE_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( TomiokaE_DamageAgiBase + ( TomiokaE_DamageAgiStep * ( GetUnitAbilityLevel( c , TomiokaE_ID) - 1 ) ) )
            if LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg")) > 0 then
                set dmg = dmg + (GetHeroAgi( c , true) * ( Tomioka_G_AddDamageBase + ( Tomioka_G_AddDamageStep * ( LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg")) - 1 ) ) )) / (check3-1)
            endif
            set rmax = 15
            call SetUnitAnimationByIndex(c, 5)
            call SetUnitTimeScale(c, 0.5)
            set check2 = 0
            if LoadInteger(hs, GetHandleId(c), StringHash("skill q")) > 0 then
                call SaveInteger(hs, GetHandleId(c), StringHash("skill q"), 0)
                set check2 = 1
                call DisplayTimedTextToPlayer(GetOwningPlayer(c), 0, 0, 1, "|c0084D7FF Q+E combo! enemy additionally stuned each hit|r")
            elseif LoadInteger(hs, GetHandleId(c), StringHash("skill w")) > 0 then
                call SaveInteger(hs, GetHandleId(c), StringHash("skill w"), 0)
                set check2 = 2
                call DisplayTimedTextToPlayer(GetOwningPlayer(c), 0, 0, 1, "|c0084D7FF W+E combo! enemy slowed each hit|r")
            endif
            set check = 0
            set e = AddSpecialEffectTarget("war3mapImported\\wos_e tanjiro (4).mdl", c, "weapon")
            call MakeSound("war3mapimported\\Hero_Tomioka_E01")
            if MUI_TomiokaE == 0 then
                call TimerStart( t_TomiokaE, 0.03, true, function thistype.Loop_TomiokaE)
            endif
        endmethod
    endstruct

    private struct TomiokaR_KS
        private static timer t_TomiokaR = CreateTimer( )
        private static integer array m_TomiokaR
        private static integer MUI_TomiokaR = -1
        unit c
        real x
        real y
        real r2
        real r3
        group g
        unit u
        real dmg
        real aoe
        real r
        effect e
        real rmax
        private static method Loop_TomiokaR takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_TomiokaR
                set this = m_TomiokaR[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if r == 0.3 then
                        call MakeSound("war3mapimported\\Hero_Tomioka_W2")
                    endif
                    if r< 0.3 then 
                call DebugUnit2(c)
                    endif
                    if r == 0.3 then
                        call DestroyEffect(e)
                        call SetUnitAnimationByIndex(c, 11)
                        call SetUnitTimeScale(c, 0.35)
                        call StopSpellUnit2(c)
                        set r2 = 0
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdx", x, y, GetRandomReal(0, 359), 0.76 , 1.85, 1))
                    endif
                    if r > 0.15 then
                    if r3>0.27 then 
                    set r3 = 0
                    call DecorRemove(c,x,y,aoe,50)
                    call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    call MUE(u, 90, 0.27, GAngle2(u, x, y))
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Eff (134).mdl", x, y, GetRandomReal(0, 359), 1, 3.4, 75))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_az_xiaonajia01_d_W.mdx", x, y, GetRandomReal(0, 359), 1.5, 1.75, 65))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_az_xiaonajia01_d_W.mdx", x, y, GetRandomReal(0, 359), 1.5, 1.65, 445))
                    else
                    set r3 = r3 + 0.03
                    endif
                        if r2 > 0.39 then
                            set r2 = 0
                            
                            call GroupClear(g)
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    call dmgphys(c, u, dmg)
                                    call ErzaPassive(c,u,2)
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    if r < 0.3 then
                        call StopSpellUnit2(c)
                        call DestroyEffect(e)
                    endif
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set e = null
                    set u = null
                    set m_TomiokaR[i] = m_TomiokaR[ MUI_TomiokaR]
                    set MUI_TomiokaR = MUI_TomiokaR - 1
                    if MUI_TomiokaR == -1 then
                        call PauseTimer( t_TomiokaR)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method TomiokaR_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_TomiokaR = MUI_TomiokaR + 1
            set m_TomiokaR[ MUI_TomiokaR] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set r2 = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set aoe = TomiokaR_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( TomiokaR_DamageAgiBase + ( TomiokaR_DamageAgiStep * ( GetUnitAbilityLevel( c , TomiokaR_ID) - 1 ) ) )
            if LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg")) > 0 then
                set dmg = dmg + GetHeroAgi( c , true) * ( Tomioka_G_AddDamageBase + ( Tomioka_G_AddDamageStep * ( LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg")) - 1 ) ) )
            endif
            set dmg = dmg / 5
            set rmax = 2.62
            call SetUnitAnimationByIndex(c, 6)
            call SetUnitTimeScale(c, 0.5)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_e tanjiro (4).mdl", c, "weapon")
                call MakeSound("war3mapimported\\Hero_Tomioka_R4")
            call MakeSound("war3mapimported\\Hero_Tomioka_R3")
            if MUI_TomiokaR == 0 then
                call TimerStart( t_TomiokaR, 0.03, true, function thistype.Loop_TomiokaR)
            endif
        endmethod
    endstruct

    private struct TomiokaT_KS
        private static timer t_TomiokaT = CreateTimer( )
        private static integer array m_TomiokaT
        private static integer MUI_TomiokaT = -1
        unit c
        unit td
        real x
        real y
        real cx
        real cy
        real scale
        real scale2
        real r3
        real r5
        real r6
        real r7
        group g
        unit u
        real dmg
        real aoe
        real move
        real r
        effect e
        real a
        real rmax
        private static method Loop_TomiokaT takes nothing returns nothing
            local integer this
            local integer i = 0
            local real cz = 0
            local real angle = 0
            loop
                exitwhen i > MUI_TomiokaT
                set this = m_TomiokaT[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit(c)
                    if r < 1.1 then
                        set cx = cx + 13 * Cos(a)
                        set cy = cy + 13 * Sin(a)
                    endif
                    if r < 0.51 then
                        call SetFly(c, GetUnitFlyHeight(c) + 40)
                        call BlzSetSpecialEffectHeight(e, GetUnitFlyHeight(c) + 125)
                    endif
                    if r == 0.51 then
                    endif
                    if r == 1.2 then
                        call BlzSetSpecialEffectTimeScale(e, 0.8)
                    endif
                    set cz = GetUnitFlyHeight(c)
                    if scale2 < 16 then
                        set scale2 = scale2 + 0.4
                    endif
                    set r6 = r6 + scale2 * bj_DEGTORAD
                    if r6 > 6.283 then
                        set r6 = r6 - 6.283
                    endif
                    if scale > 0 then
                        set scale = scale - 3
                    else
                        set scale = 0
                    endif
                    set r5 = scale + 25 * Sin(r6 * 0.7)
                    set angle = a - 90 * bj_DEGTORAD
                    call BlzSetSpecialEffectPosition(e, cx + r5 * Cos(angle) * Cos(r6), cy + r5 * Sin(angle) * Cos(r6), cz + r5 * Sin(r6))
                    if r == 1.5 then
                        call BlzSetSpecialEffectTimeScale(e, 1.5)
                    endif
                    if r > 1.2 then
                        set r7 = r7 + 10
                        set cx = GetUnitX(c) + r7 * Cos(a)
                        set cy = GetUnitY(c) + r7 * Sin(a)
                    endif
                    if r <= 1.5 then
                        if r3 > 0.0 then
                            set r3 = 0
                            call EffectSpawn2("war3mapImported\\wos_BY_Wood_Effect_YuZhiBoYou_Water_ShuiLongDan_2.mdl", GetEffX(e) - 10 * Cos(a), GetEffY(e) - 10 * Sin(a), 1, 1, 3, BlzGetLocalSpecialEffectZ(e), 0.45)
                        else
                            set r3 = r3 + 0.03
                        endif
                    else
                        call EffectSpawn2("war3mapImported\\wos_BY_Wood_Effect_YuZhiBoYou_Water_ShuiLongDan_2.mdl", GetEffX(e) - 10 * Cos(a), GetEffY(e) - 10 * Sin(a), 1, 1, 3, BlzGetLocalSpecialEffectZ(e) + 35, 0.45)
                    endif
                    if r > 2. then
                        if SR2(c, td) > 120 then
                            set a = GAngle(c, td)
                            call MoveUnit(c, move, a)
                            call MoveEff(e, move, a)
                            call SetFly(c, GetUnitFlyHeight(c) - 33)
                            call BlzSetSpecialEffectHeight(e, GetUnitFlyHeight(c) + 125)
                            call SetUnitFacing(c, a * bj_RADTODEG)
                            call BlzSetSpecialEffectYaw(e, a)
                        else
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            set r = 99999
                            call DecorRemove(c,x,y,aoe,100)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (171)4_short2.mdl", x, y, 0, 2, 1, 0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_LD2209 (129).mdx", x, y, GetRandomReal(0, 359), 1.5, 4.15, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_YuZhiBoYou_Water_ShuiLongDan_3.mdl", x, y, 1, 1, 3, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdx", x, y, GetRandomReal(0, 359), 1, 2, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Eff (134).mdl", x, y, GetRandomReal(0, 359), 1, 3, 45))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_az_xiaonajia01_d_W.mdx", x, y, GetRandomReal(0, 359), 1.5, 1.55, 65))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_az_xiaonajia01_d_W.mdx", x, y, GetRandomReal(0, 359), 1.5, 1.45, 445))
                            call MUE(td,350,0.5,a)
                            call StopSpellUnit(c)
                            call SetUnitAnimation(td,"death")
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    call dmgmag(c, u, dmg)
                                    call ErzaPassive(c,u,2)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        endif
                    endif
                else
                    call SetFly(c, 0)
                    call StopSpellUnit(c)
                    call SetUnitTimeScale( c , 1)
                    call BlzSetSpecialEffectTimeScale(e, 1)
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.35)
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set e = null
                    set u = null
                    set m_TomiokaT[i] = m_TomiokaT[ MUI_TomiokaT]
                    set MUI_TomiokaT = MUI_TomiokaT - 1
                    if MUI_TomiokaT == -1 then
                        call PauseTimer( t_TomiokaT)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method TomiokaT_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_TomiokaT = MUI_TomiokaT + 1
            set m_TomiokaT[ MUI_TomiokaT] = this
            set c = NewC
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r = 0
            set move = 65
            set r6 = 0
            set scale = 300
            call StartSpellUnit(c)
            set g = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set aoe = TomiokaT_DamageAoe
            set dmg = GetHeroAgi( c , true) * TomiokaT_DamageAgiBase
            if LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg")) > 0 then
                set dmg = dmg + GetHeroAgi( c , true) * ( Tomioka_G_AddDamageBase + ( Tomioka_G_AddDamageStep * ( LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg")) - 1 ) ) )
            endif
            set rmax = 6
            call SetUnitAnimationByIndex(c, 5)
            call SetUnitTimeScale(c, 0.19)
            set r5 = 300
            set r6 = 0
            set r7 = 0
            set cx = GetUnitX(c) - 425 * Cos(a)
            set cy = GetUnitY(c) - 425 * Sin(a)
            set scale2 = 8
            set e = EffectSpawn("war3mapImported\\wos_DragonTobirama.mdl", cx, cy, a * bj_RADTODEG, 0.65, 0.75, 200)
            call ScaleEffDummy(e, 1.2, 0.75, 1)
            call MakeSound("war3mapimported\\Hero_Tomioka_T")
            if MUI_TomiokaT == 0 then
                call TimerStart( t_TomiokaT, 0.03, true, function thistype.Loop_TomiokaT)
            endif
        endmethod
    endstruct

    private struct TomiokaF_KS
        private static timer t_TomiokaF = CreateTimer( )
        private static integer array m_TomiokaF
        private static integer MUI_TomiokaF = -1
        unit c
        real x
        real y
        real r2
        integer k
        integer k2
        integer k3
        real r4
        real r5
        group g
        unit u
        real dmg
        real aoe
        real r
        effect e
        effect e2
        effect array ee [40]
        real rmax
        private static method Loop_TomiokaF takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_TomiokaF
                set this = m_TomiokaF[i]
                if SpellBoolCaster(c) and r <= rmax and LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("tomioka esc")) == 0 then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    call SetUnitX(c,x)
                    call SetUnitY(c,y)
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("tomioka f invul"), 1)
                    if r == 0.6 then 
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("tomioka f invul"), 1)
                    endif
                    if r == 0.9 then
                        call MakeSound("war3mapimported\\Hero_Tomioka_F2")
                    endif
                    if r == 1.8 then
                        call MakeSound("war3mapimported\\Hero_Tomioka_F3")
                    endif
                    if r == 2.7 then
                        call MakeSound("war3mapimported\\Hero_Tomioka_F4")
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_modelgh (2).mdl", x, y, 1, 1, 7, 11))
                        call BlzSetSpecialEffectTimeScale(e, 0.01)
                    endif
                    if r == 2.52 then
                        set k = 0
                        loop
                            exitwhen k == k2
                            call DestroyEffect(ee[k])
                            call DestroyEffect(ee[k + k2])
                            set ee[k] = null
                            set ee[k + k2] = null
                            set k = k + 1
                        endloop
                    endif
                    if r == 2.76 or r == 2.82 or r == 2.85 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_modelgh (2).mdl", x, y, 1, 1, 7, 11))
                    endif
                    if r2 > 0.2 and LoadInteger(hs, GetHandleId(c), StringHash("tomioka f dmg act")) == 1 then
                        set r2 = 0
                        call MakeSound("war3mapimported\\Hero_Tomioka_F_Cut")
                        call SaveInteger(hs, GetHandleId(c), StringHash("tomioka f dmg act"), 0)
                        call DecorRemove(c,x,y,aoe,40)
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_arthur-sfx-1.mdl", x, y, GetRandomReal(0, 359), GetRandomReal(1, 1.5), 6., 165, 125, 155, 255, 155))
                        call GroupClear(g)
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                call dmgmag(c, u, dmg)
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    else
                        set r2 = r2 + 0.03
                    endif
                    if r4 > r5 then
                        set r4 = 0
                        call MakeSound("war3mapimported\\Hero_Tomioka_F_Cut")
                        call DecorRemove(c,x,y,aoe,40)
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_arthur-sfx-1.mdl", x, y, GetRandomReal(0, 359), GetRandomReal(1, 1.5), 6., 165, 125, 155, 255, 155))
                        call GroupClear(g)
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                call dmgmag(c, u, dmg)
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    else
                        set r4 = r4 + 0.03
                    endif
                else
                    call DebuffClear(c)
                    call SaveInteger(hs, GetHandleId(c), StringHash("tomioka f dmg act"), 0)
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.3)
                    call ColorEffDummy3(e2, 0, 255, 255, 255, 0.3)
                    if r < 2.7 then
                        set k = 0
                        loop
                            exitwhen k == k2
                            call DestroyEffect(ee[k])
                            call DestroyEffect(ee[k + k2])
                            set ee[k] = null
                            set ee[k + k2] = null
                            set k = k + 1
                        endloop
                    endif
                    set k = 0
                    loop
                        exitwhen k == k2
                        call EffectSpawn2("war3mapImported\\wos_BY_Wood_Effect_ShuiYing_Unusual_RongDun_1_21.mdl", x + aoe * Cos(k * (360 / k2) * bj_DEGTORAD), y + aoe * Sin(k * (360 / k2) * bj_DEGTORAD), GetRandomReal(0, 359), 1, 1., 25, 0.15)
                        call EffectSpawn2("war3mapImported\\wos_BY_Wood_Effect_YuZhiBoYou_Water_ShuiLongDan_2", x + aoe * Cos(k * (360 / k2) * bj_DEGTORAD), y + aoe * Sin(k * (360 / k2) * bj_DEGTORAD), GetRandomReal(0, 359), 1, 4.85, 25, 0.15)
                        set k = k + 1
                    endloop
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("tomioka esc"), 0)
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("tomioka f invul"), 0)
                    call StopSpellUnit2(c)
                    call SetUnitTimeScale( c , 1)
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set e = null
                    set u = null
                    set m_TomiokaF[i] = m_TomiokaF[ MUI_TomiokaF]
                    set MUI_TomiokaF = MUI_TomiokaF - 1
                    if MUI_TomiokaF == -1 then
                        call PauseTimer( t_TomiokaF)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method TomiokaF_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_TomiokaF = MUI_TomiokaF + 1
            set m_TomiokaF[ MUI_TomiokaF] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set r2 = 0
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("tomioka f invul"), 1)
            call StartSpellUnit2(c)
            set g = CreateGroup()
            call SaveInteger(hs, GetHandleId(c), StringHash("tomioka esc"), 0)
            set u = null
            set k3 = LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg"))
            set r5 = 3
            set r4 = 0
            if k3 == 1 then 
            set r5 = 2.6
            elseif k3 == 2 then 
            set r5 = 2.3
            elseif k3 == 3 then 
            set r5 = 2
            elseif k3 == 4 then 
            set r5 = 1.7
            elseif k3 == 5 or k3 == 6 then 
            set r5 = 1.4
            elseif k3 == 0 then 
            set r5 = 9999
            endif
            set r4 = 0
            set aoe = TomiokaF_DamageAoe
            set dmg = GetHeroAgi( c , true) * TomiokaF_DamageAgiBase
            if LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg")) > 0 then
                set dmg = dmg + ((GetHeroAgi( c , true) * ( Tomioka_G_AddDamageBase + ( Tomioka_G_AddDamageStep * ( LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg")) - 1 ) ) )) / 10)
            endif
            set rmax = TomiokaF_Duration
            call SetUnitAnimationByIndex(c, 7)
            call SetUnitTimeScale(c, 0.65)
            set e2 = EffectSpawnColor("war3mapImported\\wos_blueglow3.mdx", x, y, GetRandomReal(0, 359), 1, 1.95, 0, 255, 255, 255, 145)
            call AnimDummyEff(e2, 0.5, 0)
            set e = EffectSpawn("war3mapImported\\wos_wangha2.mdl", x, y, 1, 1, 0.01, 1)
            call ScaleEffDummy(e, 0.42, 0.01, 1.65)
            call MakeSound("war3mapimported\\Hero_Tomioka_F")
            set k2 = 13
            set k = 0
            loop
                exitwhen k == k2
                set ee[k] = EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_ShuiYing_Unusual_RongDun_1_21.mdl", x + aoe * Cos(k * (360 / k2) * bj_DEGTORAD), y + aoe * Sin(k * (360 / k2) * bj_DEGTORAD), GetRandomReal(0, 359), 2, 1.5, 25)
                set ee[k + k2] = EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_YuZhiBoYou_Water_ShuiLongDan_2", x + (aoe - 150) * Cos(k * (360 / k2) * bj_DEGTORAD), y + (aoe - 150) * Sin(k * (360 / k2) * bj_DEGTORAD), GetRandomReal(0, 359), 2, 2.85, 25)
                set k = k + 1
            endloop
            if MUI_TomiokaF == 0 then
                call TimerStart( t_TomiokaF, 0.03, true, function thistype.Loop_TomiokaF)
            endif
        endmethod
    endstruct

    private struct TomiokaG_KS
        private static timer t_TomiokaG = CreateTimer( )
        private static integer array m_TomiokaG
        private static integer MUI_TomiokaG = -1
        unit c
        framehandle array frame_pas1 [12]
        framehandle array frame_pas2 [12]
        framehandle array frame_pas3 [12]
        framehandle array frame_pas4 [12]
        framehandle array frame_pas5 [12]
        framehandle array frame_pas6 [12]
        integer k2
        real dmg
        integer check
        real r
        effect e
        real rmax
        private static method Loop_TomiokaG takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_TomiokaG
                set this = m_TomiokaG[i]
                if r < rmax and IsUnitType(c, UNIT_TYPE_DEAD) == false and Hero[k2] != null then
                    if IsUnitPaused(c) == false then
                        set r = r + 0.1
                        set r = S2R(R2SW(r,0,2))
                    endif
                        call  BlzFrameSetValue(frame_pas3[k2], rmax-(r+0.1))
                        if rmax -r >=0 then 
                        call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(rmax-r,0,2) + "|r")
                    endif
                    if check < 2 then 
                    call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + I2S(check)+" Stack" + "|r")
                    else
                    call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + I2S(check)+" Stacks" + "|r")
                    endif
                    if CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) or IsUnitType(c, UNIT_TYPE_DEAD) then
                        set r = 99999
                    endif
                    if check < LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg")) and LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg")) > 0 then
                        set r = 0
                        set check = LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg"))
                        if check > Tomioka_G_AddDamageMaxStacks then
                            set check = Tomioka_G_AddDamageMaxStacks
                            set r = 0
                            call SaveInteger(hs, GetHandleId(c), StringHash("tomioka add dmg"), check)
                        endif
                        call DisplayTimedTextToPlayer(GetOwningPlayer(c), 0, 0, 0.01, "|c00FF0303G: " + R2SW(Tomioka_G_AddDamageBase + (Tomioka_G_AddDamageStep * (check - 1)), 1, 1) + " *Agi" + "|r")
                    endif
                else
                    call SaveInteger(hs, GetHandleId(c), StringHash("tomioka add dmg"), LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg"))-2)
                    if LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg"))>0 then
                    set r = 0
                    set check = LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg"))
                    if check < 2 then 
                    call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + I2S(check)+" Stack" + "|r")
                    else
                    call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + I2S(check)+" Stacks" + "|r")
                    endif
                    else
                    call SaveInteger(hs, GetHandleId(c), StringHash("tomioka add dmg"), 0)
                    call DestroyEffect(e)
                    if GetLocalPlayer() == Player(k2) then 
                    call BlzFrameSetVisible(frame_pas1[k2],false)
                    endif
                    call SaveInteger(hs, GetHandleId(c), StringHash("tomioka g cd"), 0)
                    set c = null
                    set e = null
                    set m_TomiokaG[i] = m_TomiokaG[ MUI_TomiokaG]
                    set MUI_TomiokaG = MUI_TomiokaG - 1
                    if MUI_TomiokaG == -1 then
                        call PauseTimer( t_TomiokaG)
                    endif
                    call deallocate(this)
               endif
               endif
                set i = i + 1
            endloop
        endmethod
        public static method TomiokaG_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_TomiokaG = MUI_TomiokaG + 1
            set m_TomiokaG[ MUI_TomiokaG] = this
            set c = NewC
            set e = AddSpecialEffectTarget("war3mapImported\\wos_aurapartblue.mdl", c, "origin")
            call SaveInteger(hs, GetHandleId(c), StringHash("tomioka add dmg"), 1)
            set check = 1
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set rmax = Tomioka_G_BuffDuration
            if frame_pas1[k2] == null then 
        set frame_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS",main_frame, "", 0)
        call BlzFrameSetAbsPoint(frame_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18)
        call BlzFrameSetSize(frame_pas1[k2], 0.135, 0.035)
        call BlzFrameSetTexture(frame_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
        call BlzFrameSetVisible(frame_pas1[k2],false)
        if GetLocalPlayer() == GetOwningPlayer(c) then 
        call BlzFrameSetVisible(frame_pas1[k2],true)
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
        call  BlzFrameSetValue(frame_pas3[k2], rmax)
        set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS",frame_pas1[k2], "", 0)
        call BlzFrameSetAbsPoint(frame_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18)
        call BlzFrameSetSize(frame_pas4[k2], 0.03, 0.03)
        call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Tomioka_G", 0, false)
        set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
        call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
        call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "1 Stack" + "|r")
        call BlzFrameSetScale(frame_pas5[k2],0.9)
        set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
        call BlzFrameSetAbsPoint(frame_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17)
        call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(Test_real,0,2) + "|r")
        call BlzFrameSetScale(frame_pas6[k2],0.9)
        else
        if GetLocalPlayer() == GetOwningPlayer(c) then 
        call BlzFrameSetVisible(frame_pas1[k2],true)
        endif
        call  BlzFrameSetValue(frame_pas3[k2], rmax)
        endif
        set r = 0
            call DisplayTimedTextToPlayer(GetOwningPlayer(c), 0, 0, 0.01, "|c00FF0303G: " + R2SW(Tomioka_G_AddDamageBase + (Tomioka_G_AddDamageStep * (check - 1)), 1, 1) + " *Agi" + "|r")
            if MUI_TomiokaG == 0 then
                call TimerStart( t_TomiokaG, 0.1, true, function thistype.Loop_TomiokaG)
            endif
        endmethod
    endstruct

    //----------------------------Tomioka-----------------------------------------------
     /* Animations index:
    0 - stand
    1 - ot sebya
    2 - k sebe
    3 - move fast
    5 - move + strong slash
    6 - R
    7 - stand ready
    9 - t
    10 - t2
    11 - t3
    12 - strong hit
     */ 
    function TomiokaPass_Start takes unit c returns nothing
        local integer i = LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg"))
        if GetHeroLevel(c)>=0 then 
        if LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg")) > 0 and LoadInteger(hs, GetHandleId(c), StringHash("tomioka add dmg")) < 9999 then
            call SaveInteger(hs, GetHandleId(c), StringHash("tomioka add dmg"), i + 1)
        endif
        if LoadInteger(hs, GetHandleId(c), StringHash("tomioka g cd")) == 0  then
            call SaveInteger(hs, GetHandleId(c), StringHash("tomioka g cd"), 1)
            call TomiokaG_KS.TomiokaG_Start(c)
        endif
        endif
    endfunction
    function TomiokaQ_Start takes unit c, unit td returns nothing
        call TomiokaPass_Start(c)
        call TomiokaQ_KS.TomiokaQ_Start( c, td )
        if GetHeroLevel(c)>=0 then 
        call SaveInteger(hs, GetHandleId(c), StringHash("skill q"), 1)
        call MyFlush(GetHandleId(c), StringHash("skill q"), 0, 3)
        endif
    endfunction
    function TomiokaW_Start takes unit c, real x, real y returns nothing
        call TomiokaPass_Start(c)
        call TomiokaW_KS.TomiokaW_Start( c, x, y )
        if GetHeroLevel(c)>=0 then 
        call SaveInteger(hs, GetHandleId(c), StringHash("skill w"), 1)
        call MyFlush(GetHandleId(c), StringHash("skill w"), 0, 3)
        endif
    endfunction
    function TomiokaE_Start takes unit c, unit td returns nothing
        call TomiokaPass_Start(c)
        call TomiokaE_KS.TomiokaE_Start( c, td )
    endfunction
    function TomiokaR_Start takes unit c returns nothing
        call TomiokaPass_Start(c)
        call TomiokaR_KS.TomiokaR_Start( c )
    endfunction
    function TomiokaT_Start takes unit c, unit td returns nothing
        call TomiokaPass_Start(c)
        call TomiokaT_KS.TomiokaT_Start( c, td)
    endfunction
    function TomiokaF_Start takes unit c returns nothing
        call TomiokaPass_Start(c)
        call TomiokaF_KS.TomiokaF_Start( c)
    endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com