library ErzaQSpells uses GearSystems, ErzaTSpells
    globals
//---------------Q ability-----------------------------------------------------
        integer Erza1Q_ID = 'A032'
        real Erza1Q_DamageAgiBase = 1  // base number x Agi damage for 1 level
        real Erza1Q_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real Erza1Q_Damage2StaticBase = 150 // base static damage for 1 level
        real Erza1Q_Damage2StaticStep = 0 // additional static damage for each next level
        real Erza1Q_DamageAoe = 500
//---------------W ability-----------------------------------------------------
        integer Erza1W_ID = 'A033'
        real Erza1W_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real Erza1W_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real Erza1W_Damage2StaticBase = 150 // base static damage for 1 level
        real Erza1W_Damage2StaticStep = 0 // additional number x Agi damage for each next level
        real Erza1W_DamageAoe = 600
//---------------E ability-----------------------------------------------------
        integer Erza1E_ID = 'A034'
        real Erza1E_DamageAgiBase = 1.5 // base number x Agi damage for 1 level
        real Erza1E_DamageAgiStep = 0.5 // additional number x Agi damage for each next level
        real Erza1E_DamageAoe = 600
        real Erza1E_CD_TIME_Base = 12 
        real Erza1E_CD_TIME_Step = 1 // how much sec removed from cd
//---------------R ability-----------------------------------------------------
        integer Erza1R_ID = 'A035'
        integer Erza1R_DummyElementalId = 'h00O'
        unit ErzaElementalFireDummy = null
        real Erza1R_DamageAgiBase = 0.6 // base number x Agi damage per 1 second
        real Erza1R_DamageAgiStep = 0.2 // additional number x Agi damage for each next level per second
        real Erza1R_DamageAoe = 800
        real Erza1R_Duration = 7
//---------------T ability-----------------------------------------------------
        integer Erza1T_ID = 'A036'
        real Erza1T_DamageAgiBase = 7 // base number x Agi damage for 1 level
        real Erza1T2_DamageAgiBase = 2 // bird x agi damage( cast in R area)
        real Erza1T2_BirdRange = 2100 // bird x agi damage( cast in R area)
        real Erza1T_Stun = 1.5 // from 0.1 sec to 3.0 sec
        real Erza1T_DamageAoe = 500
    endglobals
     

    

    private struct ErzaPas_KS
        private static timer t_ErzaE2 = CreateTimer( )
        private static integer array m_ErzaE2
        private static integer MUI_ErzaE2 = -1
        unit c
        real x
        real y
        integer k
        real r5
        group g
        group g2
        unit u
        real dmg
        real aoe
        real r
        effect e
        real rmax
        private static method Loop_ErzaE2 takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaE2
                set this = m_ErzaE2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    set aoe = aoe + r5
                    call DecorRemove(c,x,y,aoe,20)
                    call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u, g2) == false then
                            call dmgmag(c, u, dmg)
                            call ErzaPassive(c, u, 1)
                            call GroupAddUnit(g2, u)
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop
                else
                    call DestroyGroup(g)
                    set g = null
                    call DestroyGroup(g2)
                    set g2 = null
                    set c = null
                    set u = null
                    set m_ErzaE2[i] = m_ErzaE2[MUI_ErzaE2]
                    set MUI_ErzaE2 = MUI_ErzaE2 - 1
                    if MUI_ErzaE2 == -1 then
                        call PauseTimer( t_ErzaE2 )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaPas_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaE2 = MUI_ErzaE2 + 1
            set m_ErzaE2[MUI_ErzaE2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set g2 = CreateGroup()
            set aoe = Erza1E_DamageAoe / 2
            set r5 = aoe / 18
            set dmg = GetHeroAgi(c, true) * (Erza1E_DamageAgiBase + (Erza1E_DamageAgiStep * (GetUnitAbilityLevel(c, Erza1E_ID) - 1)))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdx", x, y, GetRandomReal(0, 359), 1, 3.5, 50))
            set k = 0
            loop
                exitwhen k > 7
                set e = EffectSpawn2("war3mapImported\\wos_BY_Wood_Effect_Order_MuZhiBenYing_Fir_Huo_DiMianss2.mdl", x + aoe * Cos(k * 52 * bj_DEGTORAD), y + aoe * Sin(k * 52 * bj_DEGTORAD), GetRandomReal(0, 359), 2, 2.5, 200, 0.9)
                call EMUE(e, aoe, 0.75, k * 52 * bj_DEGTORAD)
                set e = null
                set k = k + 1
            endloop
            set r = 0
            set g = CreateGroup()
            set u = null
            set rmax = 0.54
            if MUI_ErzaE2 == 0 then
                call TimerStart( t_ErzaE2, 0.03, true, function thistype.Loop_ErzaE2 )
            endif
        endmethod
    endstruct
function ErzaEPas takes unit c, real x , real y returns nothing
        local real cd = Erza1E_CD_TIME_Base - (Erza1E_CD_TIME_Step * (GetUnitAbilityLevel(c, Erza1Q_ID) - 1))
        if GetHeroLevel(c)>= 6 then 
            if LoadInteger(hs, GetHandleId(c), StringHash("fire armor pas")) == 1 then
                call SaveInteger(hs, GetHandleId(c), StringHash("fire armor pas"), 0)
                call SaveInteger(hs, GetHandleId(c), StringHash("fire armor pas cd"), 999)
                call MyFlush(GetHandleId(c), StringHash("fire armor pas cd"), 0, cd)
                call ErzaPas_KS.ErzaPas_Start(c, x, y)
            endif
        endif    
    endfunction
    private struct ErzaQ_KS
        private static timer t_ErzaQ = CreateTimer( )
        private static integer array m_ErzaQ
        private static integer MUI_ErzaQ = -1
        unit c
        real x
        real y
        real r2
        group g
        unit u
        real dmg
        integer check
        real aoe
        real move
        real r
        real a
        real rmax
        private static method Loop_ErzaQ takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaQ
                set this = m_ErzaQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    if check == 0 then
                        if r < rmax then
                        if r > 0.45 then 
                        
                    set a = GAngle2(c,x,y)
                    call BlzSetUnitFacingEx(c,a*bj_RADTODEG)
                            call MoveUnit(c, move, a)
                            if r2 > 0.03 then
                                set r2 = 0
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_Hashirama_MADARAa (73).mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.85, 1.5, 1))
                                call EffectSpawn2("war3mapImported\\wos_BY_Wood_Effect_Order_MuZhiBenYing_Fir_Huo_DiMianss2.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 2, 1, 0, 0.25)
                            else
                                set r2 = r2 + 0.03
                            endif
                          endif  
                        endif
                        if SR3(c, x, y) < 120 then
                            set r = rmax
                        endif
                        if r == rmax then
                            set check = 1
                            set r = 0
                            call SetUnitTimeScale(c, 1.5)
                            call SetUnitAnimationByIndex(c, 18)
                            set rmax = 0.21
                            call MakeSound("Erza1_Q2")
                        endif
                    elseif check == 1 then
                        if r == 0.15 then
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_bdef (173).mdl", GetUnitX(c) - 150 * Cos(a), GetUnitY(c) - 150 * Sin(a), a * bj_RADTODEG, 0.5, 2.1, 110))
                        endif
                        if r == rmax then
                            set x = GetUnitX(c) + 150 * Cos(a)
                            set y = GetUnitY(c) + 150 * Sin(a)
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_acg_bbb.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1.85, 2.25, 150, 255, 255, 255, 165))
                    call DecorRemove(c,x,y,aoe,20)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_fantasybattle (1650).mdl", GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359), 0.75, 4, 155))
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    call dmgphys(c, u, dmg)
                                  //  call ErzaPassive(c, u, 1)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            call ErzaEPas(c, x, y)
                        endif
                    endif
                else
                    call StopSpellUnit2(c)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set u = null
                    set m_ErzaQ[i] = m_ErzaQ[MUI_ErzaQ]
                    set MUI_ErzaQ = MUI_ErzaQ - 1
                    if MUI_ErzaQ == -1 then
                        call PauseTimer( t_ErzaQ )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaQ = MUI_ErzaQ + 1
            set m_ErzaQ[MUI_ErzaQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set check = 0
            set r2 = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set a = GAngle2(c, x, y) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = Erza1Q_DamageAoe
            set dmg = Erza1Q_Damage2StaticBase + (Erza1Q_Damage2StaticStep * (GetUnitAbilityLevel(c, Erza1Q_ID) - 1))
            set dmg = dmg + GetHeroAgi(c, true) * (Erza1Q_DamageAgiBase + (Erza1Q_DamageAgiStep * (GetUnitAbilityLevel(c, Erza1Q_ID) - 1)))
            set rmax = 1.02
            set move = 90
            call SetUnitTimeScale(c, 0.65)
            call SetUnitAnimationByIndex(c, 4)
            call MakeSound("war3mapImported\\Hero_Erza1_Q")
            if MUI_ErzaQ == 0 then
                call TimerStart( t_ErzaQ, 0.03, true, function thistype.Loop_ErzaQ )
            endif
        endmethod
    endstruct

    private struct ErzaW_KS
        private static timer t_ErzaW = CreateTimer( )
        private static integer array m_ErzaW
        private static integer MUI_ErzaW = -1
        unit c
        real x
        real y
        real r2
        integer k
        real fly
        group g
        unit u
        real dmg
        real aoe
        real sr
        real move
        real r
        real a
        real rmax
        private static method Loop_ErzaW takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaW
                set this = m_ErzaW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    call MoveUnit(c, move, a)
                    set r2 = r2 + ( move)
                    call SetFly(c, Parabola(fly, sr, r2))
                    if r == rmax then
                        set x = GetUnitX(c) + 90 * Cos(a)
                        set y = GetUnitY(c) + 90 * Sin(a)
                    call DecorRemove(c,x,y,aoe,40)
                        call MakeSound("war3mapImported\\Hero_Erza1_W3")
                        call EffectSpawn2("war3mapImported\\wos_opdef (1054).mdl", x, y, 0, 1, 2, 115, 0.7)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_fire explosion.mdx", x, y, GetRandomReal(0, 359), 1.35, 2, 15))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_bwaxec2.mdl", x, y, GetRandomReal(0, 359), 0.35, 2.5, 0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_chushou_by_wood_effect_earth_longzhituxi.mdx", x, y, GetRandomReal(0, 359), 1, 1.25, 0))
                        set k = 0
                        loop
                            exitwhen k > 3
                            call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_kamni.mdx", x, y, GetRandomReal(0, 359), 2.55 - k * 0.1, 0.35 + k * 0.5, 0), 0, 255, 255, 255, 1.5)
                            set k = k + 1
                        endloop
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                call dmgphys(c, u, dmg)
                                call ErzaPassive(c, u, 1)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        call ErzaEPas(c, x, y)
                    endif
                else
                    call StopSpellUnit2(c)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set u = null
                    set m_ErzaW[i] = m_ErzaW[MUI_ErzaW]
                    set MUI_ErzaW = MUI_ErzaW - 1
                    if MUI_ErzaW == -1 then
                        call PauseTimer( t_ErzaW )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaW_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaW = MUI_ErzaW + 1
            set m_ErzaW[MUI_ErzaW] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set fly = 800 // max jump height
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set a = GAngle2(c, x, y) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = Erza1W_DamageAoe
            set dmg = Erza1W_Damage2StaticBase + (Erza1W_Damage2StaticStep * (GetUnitAbilityLevel(c, Erza1W_ID) - 1))
            set dmg = dmg + GetHeroAgi(c, true) * (Erza1W_DamageAgiBase + (Erza1W_DamageAgiStep * (GetUnitAbilityLevel(c, Erza1W_ID) - 1)))
            set rmax = 0.9
            set sr = SR3(c, x, y) // distance between Erza and target point
            set move = sr / 30
            call SetUnitTimeScale(c, 0.65)
            call SetUnitAnimationByIndex(c, 3)
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapImported\\Hero_Erza1_W")
            else
                call MakeSound("war3mapImported\\Hero_Erza1_W2")
            endif
            if MUI_ErzaW == 0 then
                call TimerStart( t_ErzaW, 0.03, true, function thistype.Loop_ErzaW )
            endif
        endmethod
    endstruct

    private struct ErzaE_KS
        private static timer t_ErzaE = CreateTimer( )
        private static integer array m_ErzaE
        private static integer MUI_ErzaE = -1
        unit c
        effect e
        private static method Loop_ErzaE takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaE
                set this = m_ErzaE[i]
                if SpellBoolCaster(c) and LoadInteger(hs, GetHandleId(c), StringHash("q armor active")) == 1 then
                    if LoadInteger(hs, GetHandleId(c), StringHash("fire armor pas")) == 0 and LoadInteger(hs, GetHandleId(c), StringHash("fire armor pas cd")) == 0 then
                        call SaveInteger(hs, GetHandleId(c), StringHash("fire armor pas"), 1)
                        set e = AddSpecialEffectTarget("war3mapImported\\wos_buff_fire_big2.mdx", c, "weapon")
                    elseif LoadInteger(hs, GetHandleId(c), StringHash("fire armor pas")) == 0 then
                        if e != null then
                            call DestroyEffect(e)
                            set e = null
                        endif
                    endif
                else
                    call DestroyEffect(e)
                    set c = null
                    set e = null
                    set m_ErzaE[i] = m_ErzaE[MUI_ErzaE]
                    set MUI_ErzaE = MUI_ErzaE - 1
                    if MUI_ErzaE == -1 then
                        call PauseTimer( t_ErzaE )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaE_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaE = MUI_ErzaE + 1
            set m_ErzaE[MUI_ErzaE] = this
            set c = NewC
            if LoadInteger(hs, GetHandleId(c), StringHash("fire armor pas")) == 1 then
                set e = AddSpecialEffectTarget("war3mapImported\\wos_buff_fire_big2.mdx", c, "weapon")
            endif
            if MUI_ErzaE == 0 then
                call TimerStart( t_ErzaE, 0.05, true, function thistype.Loop_ErzaE )
            endif
        endmethod
    endstruct

    private struct ErzaR_KS
        private static timer t_ErzaR = CreateTimer( )
        private static integer array m_ErzaR
        private static integer MUI_ErzaR = -1
        unit c
        real x
        real y
        real r2
        integer k2
        group g
        unit u
        real dmg
        real aoe
        real r
        effect e
        real a
        real rmax
        private static method Loop_ErzaR takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaR
                set this = m_ErzaR[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.05
                    if r == 0.35 or r == 0.45 or r == 0.55 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdx", x, y, GetRandomReal(0, 359), 0.75, k2, 50))
                        set k2 = k2 + 1
                    endif
                    if r< 0.5 then 
                    call DebugUnit2(c)
                    endif
                    if r == 0.5 then
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        call ScaleDummy(UnitSpawn(Player(PLAYER_NEUTRAL_PASSIVE),Fire_ID,x,y,1,1,1.75,45,rmax),0.5,1.5,0.5)
                        set r2 = 10
                        call VisionTimed(GetOwningPlayer(c), x , y , 1200, rmax+2)
                        call MakeSound("war3mapImported\\Hero_Erza1_R2")
                        call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("fire x"), x)
                        call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("fire y"), y)
                        set e = EffectSpawn("war3mapImported\\wos_muramasa1.mdx", x, y, GetRandomReal(0, 359), 1.35, 1.35, 0)
                        call StopSpellUnit2(c)
                    endif
                    if r > 0.5 then
                        if SR3(c, x, y) <= Erza1R_DamageAoe then
                            call Erza5Pas_Start(c, 1)
                            if ErzaElementalFireDummy == null then
                                set ErzaElementalFireDummy = CreateUnit(GetOwningPlayer(c), Erza1R_DummyElementalId, x, y, 0)
                            endif
                        else
                            if ErzaElementalFireDummy != null then
                                call RemoveUnit(ErzaElementalFireDummy)
                                set ErzaElementalFireDummy = null
                            endif
                        endif
                    endif
                    if r2 > 0.9 and r >= 0.5 then
                        set r2 = 0
                    call DecorRemove(c,x,y,aoe,20)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                call dmgmag(c, u, dmg)
                                call ErzaPassive(c, u, 1)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    else
                        set r2 = r2 + 0.05
                    endif
                else
                    if ErzaElementalFireDummy != null then
                        call RemoveUnit(ErzaElementalFireDummy)
                        set ErzaElementalFireDummy = null
                    endif
                    call DestroyEffect(e)
                    call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("fire x"), 0)
                    call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("fire y"), 0)
                    if r < 0.5 then
                        call StopSpellUnit(c)
                    endif
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set e = null
                    set u = null
                    set m_ErzaR[i] = m_ErzaR[MUI_ErzaR]
                    set MUI_ErzaR = MUI_ErzaR - 1
                    if MUI_ErzaR == -1 then
                        call PauseTimer( t_ErzaR )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaR_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaR = MUI_ErzaR + 1
            set m_ErzaR[MUI_ErzaR] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set r2 = 0
            call StartSpellUnit2(c)
            set k2 = 2
            set g = CreateGroup()
            set u = null
            set a = GAngle2(c, x, y) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = Erza1R_DamageAoe
            set dmg = GetHeroAgi(c, true) * (Erza1R_DamageAgiBase + (Erza1R_DamageAgiStep * (GetUnitAbilityLevel(c, Erza1R_ID) - 1)))
            set rmax = Erza1R_Duration + 0.5
            call SetUnitTimeScale(c, 0.65)
            call SetUnitAnimationByIndex(c, 4)
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapImported\\Hero_Erza1_R1")
            else
                call MakeSound("war3mapImported\\Hero_Erza1_R3")
            endif
            if MUI_ErzaR == 0 then
                call TimerStart( t_ErzaR, 0.05, true, function thistype.Loop_ErzaR )
            endif
        endmethod
    endstruct

    private struct ErzaT_KS
        private static timer t_ErzaT = CreateTimer( )
        private static integer array m_ErzaT
        private static integer MUI_ErzaT = -1
        unit c
        unit td
        real x
        real y
        real x1
        real y1
        integer k2
        group g
        group g2
        unit u
        real dmg
        real dmg2
        integer check
        real aoe
        real move
        real r
        effect e
        effect e2
        effect e3
        real a
        real rmax
        private static method Loop_ErzaT takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaT
                set this = m_ErzaT[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    if check < 2 then
                        set a = GAngle(c, td)
                        call SetUnitFacing(c, a * bj_RADTODEG)
                    endif
                    if check == 0 then
                    call DebugUnit2(c)
                        if r == 1.02 then
                            call MakeSound("war3mapImported\\Hero_Erza1_T2")
                            call SetUnitAnimationByIndex(c, 4)
                        endif
                        if r > 1. then
                            if SR2(c, td) > move * 1.5 then
                                call MoveUnit(c, move, a)
                            else
                                set check = 1
                                set r = 0
                                call SetUnitTimeScale(c, 1.1)
                                call SetUnitAnimationByIndex(c, 18)
                                set rmax = 0.33
                                call MakeSound("war3mapImported\\Hero_Erza1_T4")
                                call StunUnit(c, td, Erza1T_Stun)
                                call PosUnit(td, GetUnitX(c) + 130 * Cos(a), GetUnitY(c) + 130 * Sin(a))
                                call EffectSpawn2("war3mapImported\\wos_opdef (1054).mdl", GetUnitX(td), GetUnitY(td), 0, 1, 1.65, 125, 1)
                            endif
                        endif
                    elseif check == 1 then
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        if r == rmax then
                            call SetUnitAnimation(td, "death")
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_papsnaz (707).mdl", x, y, 0, 1.1, 1.25, 25))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_YanJieHuoZhu_2.mdl", x, y, 0, 1.1, 2, 5))
                            call MakeSound("war3mapImported\\Hero_Erza1_T3")
                                call DecorRemove(c,x,y,aoe,50)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call dmgmag(c, u, dmg)
                                    call ErzaPassive(c, u, 1)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            call ErzaEPas(c, x, y)
                            call VisionTimed(GetOwningPlayer(c), x , y , 1200, 2)
                            if k2 == 1 then
                                set e2 = EffectSpawn("war3mapImported\\wos_1mt_huo5.mdl", x, y, a * bj_RADTODEG, 1.5, 5.5, 155)
                                set e3 = EffectSpawn("war3mapImported\\wos_opdef (1054).mdl", x, y, a * bj_RADTODEG, 0.5, 2, 255)
                                set check = 2
                                set r = 0
                                set rmax = 0.9
                                call DestroyEffect(e)
                                set e = null
                                call StopSpellUnit2(c)
                                set move = Erza1T2_BirdRange / 30
                            endif
                        endif
                    elseif check == 2 then
                        call MoveEff2(e2, move, a)
                        call MoveEff2(e3, move, a)
                         call DecorRemove(c,GetEffX(e2), GetEffY(e2),aoe,50)
                         call VisionTimed(GetOwningPlayer(c),GetEffX(e2), GetEffY(e2),aoe*2,2)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, GetEffX(e2), GetEffY(e2), aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u, g2) == false then
                                call dmgmag(c, u, dmg2)
                                call ErzaPassive(c, u, 1)
                                call GroupAddUnit(g2, u)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                else
                    if check < 2 then
                        call DestroyEffect(e)
                        call StopSpellUnit2(c)
                    else
                        call DestroyEffect(e2)
                        call DestroyEffect(e3)
                        set e2 = null
                        set e3 = null
                    endif
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set c = null
                    set td = null
                    set e = null
                    set u = null
                    set m_ErzaT[i] = m_ErzaT[MUI_ErzaT]
                    set MUI_ErzaT = MUI_ErzaT - 1
                    if MUI_ErzaT == -1 then
                        call PauseTimer( t_ErzaT )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaT_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaT = MUI_ErzaT + 1
            set m_ErzaT[MUI_ErzaT] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set check = 0
            call StartSpellUnit2(c)
            set k2 = 2
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle(c, td) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = Erza1T_DamageAoe
            set dmg = GetHeroAgi(c, true) * Erza1T_DamageAgiBase
            set dmg2 = GetHeroAgi(c, true) * Erza1T2_DamageAgiBase
            set rmax = 5
            set move = 120
            set e = AddSpecialEffectTarget("war3mapImported\\wos_123 (1081).mdx", c, "origin")
            call SetUnitTimeScale(c, 0.65)
            call SetUnitAnimationByIndex(c, 1)
            call MakeSound("war3mapImported\\Hero_Erza1_T")
            set x1 = LoadReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("fire x"))
            set y1 = LoadReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("fire y"))
            if SR3(c, x1, y1) <= Erza1R_DamageAoe and x1 != 0 then
                set k2 = 1
            else
                set k2 = 0
            endif
            if MUI_ErzaT == 0 then
                call TimerStart( t_ErzaT, 0.03, true, function thistype.Loop_ErzaT )
            endif
        endmethod
    endstruct

    //----------------------------Erza-----------------------------------------------
     /* Animations index:
    Base:
    14 - stand
    15 - stand ready
    16 - simple atk slow
    17 - w
    18 - r
    19 - move
     */ 
    function Erza1Q_Start takes unit c, real x, real y returns nothing
        call ErzaQ_KS.ErzaQ_Start( c, x, y )
    endfunction
    function Erza1W_Start takes unit c, real x, real y returns nothing
        call ErzaW_KS.ErzaW_Start( c, x, y )
    endfunction
    function Erza1ECheck_Start takes unit c returns nothing
        call ErzaE_KS.ErzaE_Start(c)
    endfunction
    function Erza1R_Start takes unit c returns nothing
        call ErzaR_KS.ErzaR_Start( c )
    endfunction
    function Erza1T_Start takes unit c, unit td returns nothing
        call ErzaT_KS.ErzaT_Start( c, td)
    endfunction
   
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com