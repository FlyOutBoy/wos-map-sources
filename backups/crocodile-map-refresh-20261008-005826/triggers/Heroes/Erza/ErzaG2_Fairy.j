library ErzaG2Spells uses GearSystems
    globals
//--------------------------------------Erza--------------------------------------------------------------
        real Erza7_PhysicalDmgResist = 30 // in %  , 30 = 30%
//---------------Q ability-----------------------------------------------------
        integer Erza7Q_ID = 'A04F'
        real Erza7Q_DamageAgiBase = 6 // base number x Agi damage for 1 level
        real Erza7Q_DamageAoe = 300
        real Erza7Q_Range = 1900
        real Erza7Q_PushRange = 500
        real Erza7Q_PushTime = 0.45
//---------------W ability-----------------------------------------------------
        integer Erza7W_ID = 'A04G'
        real Erza7W_DamageAgiBase = 7 // base number x Agi damage for 1 level
        real Erza7W_DamageAoe = 750 // dont make lower than 475
//---------------E ability-----------------------------------------------------
        integer Erza7E_ID = 'A04H'
        real Erza7E_DamageAgiBase = 4 // base number x Agi damage for 1 level
        real Erza7E_DamageAoe = 400
        real Erza7E_RangePassiveWork = 600 // this or lower rng will trigger pas
//---------------R ability-----------------------------------------------------
        integer Erza7R_ID = 'A04I'
        integer Erza7R_MagRes_ID = 'A003'
        real Erza7R_DamageAgiBase = 8 // base number x Agi damage per 1 second
        real Erza7R_Aoe = 650
        real Erza7R_PushRange = 250
        real Erza7R_PushTime = 0.3
        real Erza7R_ManaRestore = 40 // 40 = 40% of max mana
//---------------T ability-----------------------------------------------------
        integer Erza7T_ID = 'A04J'
        real Erza7T_DamageAoe = 600
        real Erza7T_DamageAgiBase = 10 // base number x Agi damage for 1 level
        real Erza7T_Stun = 1.5 // from 0.1 to 3
    endglobals
     

    private struct Erza7Q_KS
        private static timer t_ErzaQ = CreateTimer( )
        private static integer array m_ErzaQ
        private static integer MUI_ErzaQ = -1
        unit c
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
        effect e4
        real a
        real rmax
        private static method Loop_ErzaQ takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rkek = 0
            local real rkek2 = 0
            loop
                exitwhen i > MUI_ErzaQ
                set this = m_ErzaQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                        if r < 0.45 then
                            call DebugUnit2(c)
                        endif
                        if r == 0.45 then
                        call DestroyEffect(e)
                        call DestroyEffect(e2)
                        set e = null
                        set e2 = null
                            call StopSpellUnit(c)
                            set e = EffectSpawnColor("war3mapimported\\wos_bladebeamfinallarger.mdl", GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), a * bj_RADTODEG, 1.5, 4, 65,55,255,135,255)
                            set e2 = EffectSpawn("war3mapimported\\wos_krk (1849)5.mdl", GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), a * bj_RADTODEG, 2, 1.5, 65)
                            set e3 = EffectSpawn("war3mapimported\\wos_krk (1849)5.mdl", GetUnitX(c) + 170 * Cos(a+45*bj_DEGTORAD), GetUnitY(c) + 170 * Sin(a+45*bj_DEGTORAD), a * bj_RADTODEG, 2, 1.5, 65)
                            set e4 = EffectSpawn("war3mapimported\\wos_krk (1849)5.mdl", GetUnitX(c) + 170 * Cos(a-45*bj_DEGTORAD), GetUnitY(c) + 170 * Sin(a-45*bj_DEGTORAD), a * bj_RADTODEG, 2, 1.5, 65)
                            call BlzSetSpecialEffectRoll(e2,-90*bj_DEGTORAD)
                            call BlzSetSpecialEffectRoll(e3,-90*bj_DEGTORAD)
                            call BlzSetSpecialEffectRoll(e4,-90*bj_DEGTORAD)
                        endif
                        if r > 0.45 then
                            set x = GetEffX(e) + 140 * Cos(a)
                            set y = GetEffY(e) + 140 * Sin(a)
                            call MoveEff(e, move, a)
                            call MoveEff(e2, move, a)
                            call MoveEff(e3, move, a)
                            call MoveEff(e4, move, a)
                            if r2 > 0.0 then
                                set r2 = 0
                                call VisionTimed(GetOwningPlayer(c),x,y,aoe*1.75,2)
                                call DecorRemove(c,x,y,aoe*1.1,50) 
                                call GroupClear( g )
                                call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                        call dmgmag(c, u, dmg)
                                        call GroupAddUnit(g2, u)
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                        call MUE(u, Erza7Q_PushRange * (1 - (r / rmax)), Erza7Q_PushTime, a)
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif                  
                else
                        if r < 0.45 then
                            call StopSpellUnit2(c)
                        endif
                        call BlzSetSpecialEffectTimeScale(e, 2)
                        call DestroyEffect(e)
                        call DestroyEffect(e2)
                        call DestroyEffect(e3)
                        call DestroyEffect(e4)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set c = null
                    set g = null
                    set g2 = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set m_ErzaQ[i] = m_ErzaQ[ MUI_ErzaQ]
                    set MUI_ErzaQ = MUI_ErzaQ - 1
                    if MUI_ErzaQ == -1 then
                        call PauseTimer( t_ErzaQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaQ = MUI_ErzaQ + 1
            set m_ErzaQ[ MUI_ErzaQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set aoe = Erza7Q_DamageAoe
            set move = 120
            set a = GAngle2(c, x, y)
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set rmax = 0.51 + ((Erza7Q_Range / move) * 0.03)
            set dmg = GetHeroAgi( c , true) *  Erza7Q_DamageAgiBase 
            call SetUnitAnimationByIndex( c , 1)
            set e = AddSpecialEffectTarget("war3mapimported\\wos_AFB_LTSD.mdx",c,"hand right")
            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_AFB_LTSD.mdx",c,"hand left")
                call SetUnitTimeScale(c, 0.65)
                call MakeSound("war3mapimported\\Hero_Erza7_Q2")
                        call MakeSound("war3mapimported\\Hero_Erza7_W2")
            if MUI_ErzaQ == 0 then
                call TimerStart( t_ErzaQ, 0.03, true, function thistype.Loop_ErzaQ)
            endif
        endmethod
    endstruct

    private struct Erza7W_KS
        private static timer t_ErzaW = CreateTimer( )
        private static integer array m_ErzaW
        private static integer MUI_ErzaW = -1
        unit c
        real x
        real y
        real r2
        real r3
        group g
        group g2
        unit u
        real dmg
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax
        private static method Loop_ErzaW takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rkek = 0
            local real rkek2 = 0
            loop
                exitwhen i > MUI_ErzaW
                set this = m_ErzaW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                        call DebugUnit2(c)
                        if r == 0.21 then
                        set r3 = 10
                        call MakeSound("war3mapimported\\Hero_Erza7_W3")
                        call SetUnitTimeScale(c,0.5)
                        endif
                        if r > 0.3 then
                            call MoveUnit(c, move, a)
                        set x = GetUnitX(c)+move*Cos(a)
                        set y = GetUnitY(c)+move*Sin(a)
                        if r3>0.06 then 
                    set r3 = 0
                    call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_tx-ha-chongfeng2.mdl",GetUnitX(c)-250*Cos(a), GetUnitY(c)-250*Sin(a), a * bj_RADTODEG, 1, 5, 0, 255, 255, 255, 75))
                     call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.2, 1, 25, 255, 145, 95))
                    else
                    set r3 = r3 + 0.03
                    endif
                        if r2 > 0.0 then
                                set r2 = 0
                                call DecorRemove(c,x,y,aoe*1.1,50) 
                                call GroupClear( g )
                                call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c ))  then
                                        set r = 999999
                                        set x = GetUnitX(u)
                                        set y = GetUnitY(u)
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                            if r > 999 then
                            endif
                            set u = null
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif                  
                else
                call MakeSound("war3mapimported\\Hero_Erza7_W")
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_hakkestart.mdl",x,y,a*bj_RADTODEG+35,1,1.5,0))
                        call DestroyEffect(EffectSpawn("JY-war3mapImported\\wos_LD2209 (199)green.mdl",x,y,a*bj_RADTODEG+35,1,6,125))
                        call DestroyEffect(EffectSpawn("JY-war3mapImported\\wos_LD2209 (199)green.mdl",x,y,a*bj_RADTODEG-35,1,6,125))
                        call MUE(c,600,0.3,a)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Order_DanGe_LiangYiShi_ZhiSiZhiMoYanZhanJi_green.mdl",x,y,a*bj_RADTODEG,0.9,3.75,75))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_JY-ZK_BM_Mine blasting-Lv-075.mdl",x,y,GetRandomReal(0,359),1.2,2,1))
                         call DecorRemove(c,x,y,aoe*1.1,100) 
                                call GroupClear( g )
                                call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
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
                        call StopSpellUnit2(c)
                        call BlzSetSpecialEffectTimeScale(e, 2)
                        call DestroyEffect(e)
                        call DestroyEffect(e2)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set c = null
                    set g = null
                    set g2 = null
                    set e = null
                    set e2 = null
                    set m_ErzaW[i] = m_ErzaW[ MUI_ErzaW]
                    set MUI_ErzaW = MUI_ErzaW - 1
                    if MUI_ErzaW == -1 then
                        call PauseTimer( t_ErzaW)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaW_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaW = MUI_ErzaW + 1
            set m_ErzaW[ MUI_ErzaW] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set aoe = Erza7Q_DamageAoe
            set move = 80
            set a = GAngle2(c, x, y)
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set rmax = 0.51
            set dmg = GetHeroAgi( c , true) *  Erza7Q_DamageAgiBase 
            call SetUnitAnimationByIndex( c , 4)
            set e = AddSpecialEffectTarget("war3mapimported\\wos_AFB_LTSD.mdx",c,"hand right")
            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_AFB_LTSD.mdx",c,"hand left")
                call SetUnitTimeScale(c, 0.2)
                call MakeSound("war3mapimported\\Hero_Erza7_Q")
            if MUI_ErzaW == 0 then
                call TimerStart( t_ErzaW, 0.03, true, function thistype.Loop_ErzaW)
            endif
        endmethod
    endstruct

    private struct Erza7E_KS
        private static timer t_ErzaE = CreateTimer( )
        private static integer array m_ErzaE
        private static integer MUI_ErzaE = -1
        unit c
        unit td
        real x
        real y
        real r2
        real dmg
        integer check
        real move
        real r
        effect e
        effect e2
        real a
        real rmax
        private static method Loop_ErzaE takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real random
            loop
                exitwhen i > MUI_ErzaE
                set this = m_ErzaE[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit(c)
                    if r == 0.3 then                     
            call MakeSound("war3mapImported\\Hero_Erza7_T2")
                    endif
                    if r> 0.3 then 
                    if r2>0.03 then 
                    set r2 = 0                    
                    call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_tx-ha-chongfeng2.mdl",GetUnitX(c)-250*Cos(a), GetUnitY(c)-250*Sin(a), a * bj_RADTODEG, 1, 4, 0, 255, 255, 255, 75))
                     call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.4, 1, 255, 255, 255, 125))
                    else
                    set r2 = r2 + 0.03
                    endif
                    set a = GAngle(c,td)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call SetUnitFacing(c,a*bj_RADTODEG)
                    call MoveUnit(c,move,a)
                    if SR3(c,x,y)< 250 and check == 0 then 
                    call SetUnitAnimationByIndex(c,4)
                    set check = 1
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_0713_green.mdx",x,y,GetRandomReal(0,359),1,6,250))
                    endif
                    if SR3(c,x,y)< 150  then
                    set r = rmax
                    endif
                    if r == rmax then 
                    set r = 9999
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call StunUnit(c,td,1.5)
                    call dmgmag(c,td,dmg)
                    call SetAnim(td,0.03,"death")
                    call DecorRemove(c,x,y,355,40)                            
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_hakkestart.mdx",x,y,GetRandomReal(0,359),1.25,1.5,0))
                    
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_LD2209 (199)green.mdl",x,y,a*bj_RADTODEG+35,1,6,125))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_LD2209 (199)green.mdl",x,y,a*bj_RADTODEG-35,1,6,125))
                    call EffectSpawn2("war3mapImported\\wos_Evolt-1greenlightning.mdl", x, y, 0, 1, 1.75, 1,0.66)
            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_dustwave222.mdx",x,y,GetRandomReal(0,359),0.6,2,0,25,255,155,100))
            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_dustwave222.mdx",x,y,GetRandomReal(0,359),0.7,2.5,0,25,255,155,100))
            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_dustwave222.mdx",x,y,GetRandomReal(0,359),0.8,3,0,25,255,155,100))
            call EffectSpawn2("war3mapImported\\wos_firefly-rsfx-3green.mdl", x, y, 0, 1, 3,1,0.66)
            endif
            endif
            else
            call DestroyEffect(e)
            call DestroyEffect(e2)
                    call StopSpellUnit(c)
                    set c = null
                    set e = null
                    set e2 = null
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
        public static method ErzaE_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaE = MUI_ErzaE + 1
            set m_ErzaE[MUI_ErzaE] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set r2 = 0
            set check = 0
            call StartSpellUnit(c)
            set a = GAngle(c,td) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set dmg = GetHeroAgi(c, true) * Erza7E_DamageAgiBase
            set rmax = 1.2
            set move = 95
            set e = AddSpecialEffectTarget("war3mapimported\\wos_AFB_LTSD.mdx",c,"hand right")
            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_AFB_LTSD.mdx",c,"hand left")
            call SetUnitTimeScale(c, 0.25)
            call SetUnitAnimationByIndex(c, 1)
            call MakeSound("war3mapImported\\Hero_Erza7_E")
            call MakeSound("war3mapImported\\Hero_Erza7_E2")
            if MUI_ErzaE == 0 then
                call TimerStart( t_ErzaE, 0.03, true, function thistype.Loop_ErzaE )
            endif
        endmethod
    endstruct

    private struct Erza7R_KS
        private static timer t_ErzaR = CreateTimer( )
        private static integer array m_ErzaR
        private static integer MUI_ErzaR = -1
        unit c
        real x
        real y
        real r2
        real r3
        real r4
        real r5
        group g
        unit u
        real dmg
        real aoe
        real r
        effect e
        effect e2
        effect e3
        real rmax
        private static method Loop_ErzaR takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaR
                set this = m_ErzaR[i]
                if SpellBoolCaster(c) and r<rmax then
                    set r = r + 0.05
                    call DebugUnit(c)
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    call BlzSetSpecialEffectPosition(e, x, y, 1)
                    call BlzSetSpecialEffectPosition(e2, x, y, 1)
                    call BlzSetSpecialEffectPosition(e3, x, y, 1)
                    if r == 0.5 then
                    call BlzPlaySpecialEffect(e2,ANIM_TYPE_STAND)
                    endif
                    if r3 > 0.12 then
                        set r3 = 0
            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_dustwave222.mdx",x,y,GetRandomReal(0,359),0.6,2,0,255,255,255,100))
            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_dustwave222.mdx",x,y,GetRandomReal(0,359),0.7,2.5,0,255,255,255,100))
            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_dustwave222.mdx",x,y,GetRandomReal(0,359),0.8,3,0,255,255,255,100))
                    else
                        set r3 = r3 + 0.05
                    endif
                    if r4 > 0.75 then
                        set r4 = 0
            call EffectSpawn2("war3mapimported\\wos_lightgreen.mdl", x, y, 0, 1, 0.8, 1,1)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_5731-sl_8bc718f-F2.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 3, 1))
                    else
                        set r4 = r4 + 0.05
                    endif
                    if r2 > 0.15 then
                        set r2 = 0
                        call SetMpCurrent(c,r5)
                        call DecorRemove(c,x,y, aoe,20)
                        call GroupClear( g )
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                            call dmgmag(c,u,dmg)
                            call MUE(u,Erza7R_PushRange,Erza7R_PushTime,GAngle(c,u))
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    else
                        set r2 = r2 + 0.05
                    endif
                else    
                    call StopSpellUnit(c)
                    call ColorEffDummy3(e,0,255,255,255,0.27)
                    call DestroyEffect(e2)
                    call DestroyEffect(e3)
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set e = null
                    set e2 = null
                    set e3 = null
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
            call StartSpellUnit(c)
            set r2 = 10
            set r3 = 10
            set aoe = Erza7R_Aoe
            set rmax = 2.11
            set r5 = GetUnitState(c,UNIT_STATE_MAX_MANA)*(Erza7R_ManaRestore/100)
            set r5 = r5/8
            set g = CreateGroup()
            set dmg = GetHeroAgi(c, true) * Erza7R_DamageAgiBase
            set dmg = dmg /14
            set e = EffectSpawn("war3mapImported\\wos_Evolt-1greenlightning.mdl", x, y, 0, 1, 4.2, 35)
            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_dustwave222.mdx",x,y,GetRandomReal(0,359),0.6,2,0,255,255,255,100))
            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_dustwave222.mdx",x,y,GetRandomReal(0,359),0.7,2.5,0,255,255,255,100))
            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_dustwave222.mdx",x,y,GetRandomReal(0,359),0.8,3,0,255,255,255,100))
            set e2 = EffectSpawn("war3mapImported\\wos_Opdef (125)2.mdl", x, y, 0, 1, 0.4, 1)
            call ColorEffDummy4(e2,0,255,255,255,0.24)
            set e3 = EffectSpawn("war3mapImported\\wos_firefly-rsfx-3green.mdl", x, y, 0, 1, 4, 2)
            call EffectSpawn2("war3mapimported\\wos_lightgreen.mdl", x, y, 0, 1, 0.8, 1,1)
            call MakeSound("war3mapImported\\Hero_Erza7_R")
            call MakeSound("war3mapImported\\Hero_Erza7_R2")
            if MUI_ErzaR == 0 then
                call TimerStart( t_ErzaR, 0.05, true, function thistype.Loop_ErzaR )
            endif
        endmethod
    endstruct

    private struct Erza7T_KS
        private static timer t_ErzaT = CreateTimer( )
        private static integer array m_ErzaT
        private static integer MUI_ErzaT = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k
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
                    call DebugUnit(c)
                    if r == 0.75 then 
                    call SetUnitAnimationByIndex(c,5)
                    set e3 = EffectSpawn("war3mapimported\\wos_ldeff (11)1.mdl",GetUnitX(c),GetUnitY(c),a*bj_RADTODEG,1,0.8,100)
                    endif
                    if r == 0.9 then
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    set e = null
                    set e2 = null
                    call SetUnitAnimationByIndex(c,3)
                    call SetUnitTimeScale(c,2)
                    call EffectSpawn2("war3mapimported\\wos_krk (1849)5.mdl", GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), a * bj_RADTODEG, 2, 2.5, 65,0.45)
                    call EffectSpawn2("war3mapimported\\wos_krk (1849)5.mdl", GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), a * bj_RADTODEG+30, 2, 2.5, 65,0.45)
                    call EffectSpawn2("war3mapimported\\wos_krk (1849)5.mdl", GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), a * bj_RADTODEG-30, 2, 2.5, 65,0.45)
                     call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_tx-ha-chongfeng2.mdl",GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 5, 0, 255, 255, 255, 75))
                     call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.4, 1, 255, 255, 255, 125))
                    endif
                    if r> 0.9 then 
                    if r2>0.03 then 
                    set r2 = 0                    
                    call EffectSpawn2("war3mapimported\\wos_krk (1849)5.mdl", GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), a * bj_RADTODEG, 2, 2.5, 65,0.45)
                    call EffectSpawn2("war3mapimported\\wos_krk (1849)5.mdl", GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), a * bj_RADTODEG+30, 2, 2.5, 65,0.45)
                    call EffectSpawn2("war3mapimported\\wos_krk (1849)5.mdl", GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), a * bj_RADTODEG-30, 2, 2.5, 65,0.45)
                    call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_tx-ha-chongfeng2.mdl",GetUnitX(c)-250*Cos(a), GetUnitY(c)-250*Sin(a), a * bj_RADTODEG, 1, 5, 0, 255, 255, 255, 75))
                     call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.4, 1, 255, 255, 255, 125))
                    else
                    set r2 = r2 + 0.03
                    endif
                    set a = GAngle(c,td)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call SetUnitFacing(c,a*bj_RADTODEG)
                    call BlzSetSpecialEffectYaw(e3,a)
                    call MoveUnit(c,move,a)
                    call MoveEff(e3,move,a)
                    if SR3(c,x,y)< 250 and check == 0 then 
                    call SetUnitAnimationByIndex(c,4)
                    set check = 1
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_0713_green.mdx",x,y,GetRandomReal(0,359),1,16,250))
                    endif                    
                    if SR3(c,x,y)< 150  then
                    set r = rmax
                    endif
                    if r == rmax then 
                    set r = 9999
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call StopSpellUnit(c)
                    call StunUnit(c,td,Erza7T_Stun)
                    call SetAnim(td,0.03,"death")
                    call MakeSound("war3mapImported\\Hero_Erza7_T2")
                    call DecorRemove(c,x,y,aoe,100)                            
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_hakkestart.mdx",x,y,GetRandomReal(0,359),1.25,1.5,0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_ncds (179).mdl", x, y, a * bj_RADTODEG,3.75, 1.75, 1))
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\Gear_ZK_Narumea_lianzhan1.mdx", x - 50 * Cos(a), y - 50 * Sin(a), a * bj_RADTODEG + GetRandomReal( -15, 15), 2.5, 2.85, 1,255,255,255,125))
                            set k = 0
                            loop
                                exitwhen k >6                                
                    call EffectSpawn2("war3mapimported\\wos_krk (1849)5.mdx",x,y,k*60,1.25,2,100,0.8)
                            call ColorEffDummy3(EffectSpawn3("war3mapimported\\wos_BY_Wood_Eff_Ord_DanGe_Wav_Kuosan_1_3_0_5s.mdx",x,y,GetRandomReal(0,359),1,1.5,150,-30),0,255,255,255,0.35)                            
                    call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_tx-ha-chongfeng2.mdl",x-950*Cos(k*60*bj_DEGTORAD),y-950*Sin(k*60*bj_DEGTORAD), k*60, 0.5, 6, 0, 255, 255, 255, 90))
                            set k = k + 1
                            endloop
                            
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                if IsUnitInGroup(u,g2) == false then 
                                    call dmgmag(c, u, dmg)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    call GroupAddUnit(g2,u)                                    
                                    endif
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        endif
                endif
                else
            call MakeSound("war3mapImported\\Hero_Erza7_T3")
            call DestroyEffect(e2)
            call DestroyEffect(e3)
            call DestroyEffect(e4)
                    call StopSpellUnit(c)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
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
            set r2 = 0
            set check = 0
            call StartSpellUnit(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle(c,td) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = Erza7T_DamageAoe
            set dmg = GetHeroAgi(c, true) * Erza7T_DamageAgiBase
            set rmax = 2.01
            set move = 95
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set e = EffectSpawn("war3mapImported\\wos_Evolt-1greenlightning.mdl", x, y, 0, 1, 1.5, 25)
            set e2 = EffectSpawn("war3mapImported\\wos_firefly-rsfx-3green.mdl", x, y, 0, 1, 2.15, 2)
            set e4 = AddSpecialEffectTarget("war3mapImported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiGreen.mdx",c,"hand right")
            call SetUnitTimeScale(c, 0.25)
            call SetUnitAnimationByIndex(c, 1)
            call MakeSound("war3mapImported\\Hero_Erza7_T")
            if MUI_ErzaT == 0 then
                call TimerStart( t_ErzaT, 0.03, true, function thistype.Loop_ErzaT )
            endif
        endmethod
    endstruct

    //----------------------------Erza-----------------------------------------------
     /* Animations index:
    Base:
    1 - pierce
    2 - pierce another  
    3 - run
    4 - W 
    5 - t
     */ 
    function Erza7Q_Start takes unit c, real x,real y returns nothing
        call Erza7Q_KS.ErzaQ_Start( c,x,y )
    endfunction
    function Erza7W_Start takes unit c,real x,real y returns nothing
        call Erza7W_KS.ErzaW_Start( c,x,y )
    endfunction
    function Erza7E_Start takes unit c,unit td returns nothing
     call Erza7E_KS.ErzaE_Start( c,td)
    endfunction
    function Erza7R_Start takes unit c returns nothing
     call Erza7R_KS.ErzaR_Start( c )
    endfunction
    function Erza7T_Start takes unit c,unit td returns nothing
     call Erza7T_KS.ErzaT_Start( c,td)
    endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com