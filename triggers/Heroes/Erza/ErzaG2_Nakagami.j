library ErzaG1Spells uses GearSystems
    globals
//--------------------------------------Erza-------------------------------------------------------------- 
        real Erza6_MagicalDmgResist = 40 // in %  , 40 = 40%
        real Erza6_ArmorDuration = 30 // how long both armor live
//---------------Q ability-----------------------------------------------------
        integer Erza6Q_ID = 'A04A'
        real Erza6Q_DamageAgiBase = 6 // base number x Agi damage for 1 level
        real Erza6Q_DamageAoe = 330
        real Erza6Q_Range = 1500
//---------------W ability-----------------------------------------------------
        integer Erza6W_ID = 'A04B'
        real Erza6W_DamageAgiBase = 7 // base number x Agi damage for 1 level
        real Erza6W_DamageAoe = 750 // dont make lower than 475
//---------------E ability-----------------------------------------------------
        integer Erza6E_ID = 'A04C'
        real Erza6E_DamageAgiBase = 4 // base number x Agi damage for 1 level
        real Erza6E_DamageAoe = 400
        real Erza6E_RangePassiveWork = 350 // this or lower rng will trigger pas
//---------------R ability-----------------------------------------------------
        integer Erza6R_ID = 'A04D'
        real Erza6R_Aoe = 600
        real Erza6R_MagRes = 25
        real Erza6R_Silence = 2 // from 0.1 to 3
//---------------T ability-----------------------------------------------------
        integer Erza6T_ID = 'A04E'
        real Erza6T_DamageAgiBase = 10 // base number x Agi damage for 1 level
        real Erza6T_Stun = 0 // from 0.1 to 3
        real Erza6T_DamageAoe = 650
    endglobals
   private function ErzaBaseAbiBlock takes unit c, boolean b returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        call SetPlayerAbilityAvailable(Player(i), ErzaQ_ID, b)
        call SetPlayerAbilityAvailable(Player(i), ErzaW_ID, b)
        call SetPlayerAbilityAvailable(Player(i), ErzaE_ID, b)
        call SetPlayerAbilityAvailable(Player(i), ErzaR_ID, b)
        call SetPlayerAbilityAvailable(Player(i), ErzaT_ID, b)
        if b == false then
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_0706Red.mdl", GetUnitX(c), GetUnitY(c), 0, 1, 3.5, 110))
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_mard effect 2.mdl", GetUnitX(c), GetUnitY(c), 0, 1, 1.35, 0))
        else
            if CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false then
                if GetRandomInt(1, 2) == 1 then
                    call MakeSound("war3mapImported\\Hero_Erza_F_Cancel")
                else
                    call MakeSound("war3mapImported\\Hero_Erza_F_Cancel2")
                endif
            endif
        endif
    endfunction
       private  function ErzaAbiArmorAdd takes unit c, integer id1, integer id2, integer id3, integer id4, integer id5, integer id6, boolean b, integer level returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local real cd
        local real cd2
        local real cd3
        if b == true then
            call SetPlayerAbilityAvailable(Player(i), id1, b)
            call SetPlayerAbilityAvailable(Player(i), id2, b)
            call SetPlayerAbilityAvailable(Player(i), id3, b)
            call SetPlayerAbilityAvailable(Player(i), id4, b)
            call SetPlayerAbilityAvailable(Player(i), id5, b)
            if id6 != 0 then
                call SetPlayerAbilityAvailable(Player(i), id6, b)
            endif
            if GetUnitAbilityLevel(c, id1) == 0 then
                call UnitAddAbility(c, id1)
                call UnitAddAbility(c, id2)
                call UnitAddAbility(c, id3)
                call UnitAddAbility(c, id4)
                call UnitAddAbility(c, id5)
                if id6 != 0 then
                    call UnitAddAbility(c, id6)
                    call UnitMakeAbilityPermanent(c, b, id6)
                endif
                call UnitMakeAbilityPermanent(c, b, id1)
                call UnitMakeAbilityPermanent(c, b, id2)
                call UnitMakeAbilityPermanent(c, b, id3)
                call UnitMakeAbilityPermanent(c, b, id4)
                call UnitMakeAbilityPermanent(c, b, id5)
                call SetUnitAbilityLevel(c, id1, level)
                call SetUnitAbilityLevel(c, id2, level)
                call SetUnitAbilityLevel(c, id3, level)
                call SetUnitAbilityLevel(c, id4, level)
                call SetUnitAbilityLevel(c, id5, level)
            else
                call SetUnitAbilityLevel(c, id1, level)
                call SetUnitAbilityLevel(c, id2, level)
                call SetUnitAbilityLevel(c, id3, level)
                call SetUnitAbilityLevel(c, id4, level)
                call SetUnitAbilityLevel(c, id5, level)
            endif
     //-------------------------------------------------------
    //-----------------------------------------------------------
        else
            call SetPlayerAbilityAvailable(Player(i), id1, b)
            call SetPlayerAbilityAvailable(Player(i), id2, b)
            call SetPlayerAbilityAvailable(Player(i), id3, b)
            call SetPlayerAbilityAvailable(Player(i), id4, b)
            call SetPlayerAbilityAvailable(Player(i), id5, b)
            if id6 != 0 then
                call SetPlayerAbilityAvailable(Player(i), id6, b)
            endif
        endif
    endfunction
    private function ErzaF_Start takes unit c returns nothing
        local integer id = GetHandleId(c)
        local integer i = GetPlayerId(GetOwningPlayer(c))
        local integer sh1 = StringHash("q armor active")
        local integer sh2 = StringHash("w armor active")
        local integer sh3 = StringHash("e armor active")
        local integer sh4 = StringHash("r armor active")
        local integer sh5 = StringHash("t armor active")
        local integer sh6 = StringHash("g armor active")
        local integer k
        local real hp = GetUnitState(c, UNIT_STATE_LIFE) / GetUnitState(c, UNIT_STATE_MAX_LIFE)
        local real cd
        local integer check = 0
        if GetUnitAbilityLevel(c, ErzaG2_ID) > 0 then
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG2_ID, true)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG_ID, false)
        else
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), ErzaG_ID, true)
        endif
        if LoadInteger(hs, id, sh6) == 1 then
            set check = 1
            call BlzSetUnitMaxHP(c, BlzGetUnitMaxHP(c) - ErzaT_ArmorStatHpBase)
            call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_MAX_LIFE) * hp)
            call SaveInteger(hs, GetHandleId(c), StringHash("erza g2 active"), 0)
            call ErzaBaseAbiBlock(c, true)
            call SaveInteger(hs, id, sh6, 0)
            call ErzaAbiArmorAdd(c, Erza6Q_ID, Erza6W_ID, Erza6E_ID, Erza6R_ID, Erza6T_ID, 0, false, GetUnitAbilityLevel(c, ErzaG2_ID))
            call ErzaAbiArmorAdd(c, Erza7Q_ID, Erza7W_ID, Erza7E_ID, Erza7R_ID, Erza7T_ID, 0, false, GetUnitAbilityLevel(c, ErzaG2_ID))
        endif
        if check > 0 then
            call BlzSetUnitSkin(c, ErzaUnitSkin_ID)
            call DestroyEffect(AddSpecialEffectTarget("[dz.spell]002_blue5.mdl", c, "origin"))
        endif
    endfunction

    private struct Erza6Q_KS
        private static timer t_ErzaQ = CreateTimer( )
        private static integer array m_ErzaQ
        private static integer MUI_ErzaQ = -1
        unit c
        real x
        real y
        real r2
        integer k
        real r5
        group g
        group g2
        unit u
        real dmg
        real aoe
        real move
        real r
        real a
        real rmax
        private static method Loop_ErzaQ takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real random
            loop
                exitwhen i > MUI_ErzaQ
                set this = m_ErzaQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    if r == 0.27 then
                        call SetUnitTimeScale(c, 0.)
                    endif
                    if r == 0.3 then
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_tx-ha-chongfeng2.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 5, 0, 255, 255, 255, 75))
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.4, 1, 255, 255, 255, 125))
                    endif
                    if r > 0.3 then
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        if r2 > 0.06 then
                            set r2 = 0
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_tx-ha-chongfeng2.mdl", GetUnitX(c) - 250 * Cos(a), GetUnitY(c) - 250 * Sin(a), a * bj_RADTODEG, 1, 5, 0, 255, 255, 255, 75))
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.4, 1, 255, 255, 255, 125))
                        else
                            set r2 = r2 + 0.03
                        endif
                        call MoveUnit(c, move, a)
                        set r5 = r5 + move
                        if r5 >= Erza6Q_Range then
                            set r = rmax
                        endif
                        call DecorRemove(c, x, y, aoe, 20)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                call MoveUnit(u, move, a)
                                if IsUnitInGroup(u, g2) == false then
                                    call dmgphys(c, u, dmg)
                                    call EUTU2_3(EffectSpawn("war3mapimported\\wos_0854.mdx", x, y, a * bj_RADTODEG, 1, 2.5, 1), 0.76, 1, u)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    call GroupAddUnit(g2, u)
                                endif
                                call IssueImmediateOrder(u, "stop")
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                    if r == rmax then
                        set r = 9999
                        call MakeSound("war3mapImported\\Hero_Erza6_Q3")
                        call DecorRemove(c, x, y, aoe * 1.75, 50)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZarakiWCrack2.mdx", x, y, GetRandomReal(0, 359), 1, 3, 0))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Eff_Ord_DanGe_Wav_Kuosan_1_3_0_5s.mdx", x, y, 1, 1, 1, 100))
                        set k = 0
                        loop
                            exitwhen k > 4
                            call EffectSpawn2("war3mapimported\\wos_LD2209 (157).mdx", x, y, GetRandomReal(0, 359), 1.6 - k * 0.2, 1 + k * 0.5, 0, 1.25)
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_dustgaraa2.mdx", x, y, GetRandomReal(0, 359), 1.85 - k * 0.1, 1.9 + k * 0.42, 0))
                            set k = k + 1
                        endloop
                        call GroupEnumUnitsInRange(g, x, y, aoe * 1.75, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                if IsUnitInGroup(u, g2) == false then
                                    call dmgphys(c, u, dmg)
                                    call EUTU2_3(EffectSpawn("war3mapimported\\wos_0854.mdx", x, y, a * bj_RADTODEG, 1, 2.5, 1), 0.76, 1, u)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    call GroupAddUnit(g2, u)
                                endif
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                else
                    call StopSpellUnit2(c)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
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
            set r2 = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set r5 = 0
            set a = GAngle2(c, x, y) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = Erza6Q_DamageAoe
            set dmg = GetHeroAgi(c, true) * Erza6Q_DamageAgiBase
            set rmax = 2.01
            set move = 90
            call SetUnitTimeScale(c, 2)
            call SetUnitAnimationByIndex(c, 2)
            call MakeSound("war3mapImported\\Hero_Erza6_Q")
            call MakeSound("war3mapImported\\Hero_Erza6_Q2")
            if MUI_ErzaQ == 0 then
                call TimerStart( t_ErzaQ, 0.03, true, function thistype.Loop_ErzaQ )
            endif
        endmethod
    endstruct

    private struct Erza6W_KS
        private static timer t_ErzaW = CreateTimer( )
        private static integer array m_ErzaW
        private static integer MUI_ErzaW = -1
        unit c
        real x
        real y
        integer k
        group g
        group g2
        unit u
        real dmg
        real aoe
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
                    call DebugUnit(c)
                    if r == rmax then
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        set r = 9999
                        call MakeSound("war3mapImported\\Hero_Erza6_W")
                        call DecorRemove(c, x, y, aoe, 100)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Eff_Ord_DanGe_Wav_Kuosan_1_3_0_5s.mdx", x, y, 1, 1, 1.22, 100))
                        set k = 0
                        loop
                            exitwhen k > 3
                            call DestroyEffect(EffectSpawnScale("war3mapimported\\wos_vergilslashes.mdx", x, y, k * 120, 1.1, 6, 110, 0.3, 6, 14.5))
                            call DestroyEffect(EffectSpawnScale("war3mapimported\\wos_vergilslashes.mdx", x, y, k * 120, 1.2, 6, 110, 0.3, 6, 12))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_3.mdl", x, y, GetRandomReal(0, 359), 1.2, 2.5 + k * 0.75, 1, 255, 255, 255, 45))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_3.mdl", x, y, GetRandomReal(0, 359), 1.1, 3.25 + k * 0.8, 1, 255, 255, 255, 60))
                            set k = k + 1
                        endloop
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                if IsUnitInGroup(u, g2) == false then
                                    call dmgphys(c, u, dmg)
                                    call EUTU2_3(EffectSpawn("war3mapimported\\wos_0854.mdx", GetUnitX(u), GetUnitY(u), a * bj_RADTODEG, 1, 2.5, 1), 0.76, 1, u)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    call GroupAddUnit(g2, u)
                                endif
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                else
                    call StopSpellUnit(c)
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
        public static method ErzaW_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaW = MUI_ErzaW + 1
            set m_ErzaW[MUI_ErzaW] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            call StartSpellUnit(c)
            set g = CreateGroup()
            set u = null
            set a = GAngle2(c, x, y) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = Erza6W_DamageAoe
            set dmg = GetHeroAgi(c, true) * Erza6W_DamageAgiBase
            set rmax = 0.51
            call SetUnitTimeScale(c, 1.4)
            call SetUnitAnimationByIndex(c, 5)
            call MakeSound("war3mapImported\\Hero_Erza6_Q2")
            if MUI_ErzaW == 0 then
                call TimerStart( t_ErzaW, 0.03, true, function thistype.Loop_ErzaW )
            endif
        endmethod
    endstruct

    private struct Erza6E_KS
        private static timer t_ErzaE = CreateTimer( )
        private static integer array m_ErzaE
        private static integer MUI_ErzaE = -1
        unit c
        unit td
        real x
        real y
        integer k
        group g
        group g2
        unit u
        real dmg
        real aoe
        real r
        real a
        real rmax
        private static method Loop_ErzaE takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaE
                set this = m_ErzaE[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit(c)
                    call DebugUnit(td)
                    if r == rmax then
                        set x = GetUnitX(c)+125*Cos(a)
                        set y = GetUnitY(c)+125*Sin(a)
                        set r = 9999
                        call StopSpellUnit(td)
                        call MakeSound("war3mapImported\\Hero_Erza7_G3")
                        call DecorRemove(c, x, y, aoe, 50)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Eff_Ord_DanGe_Wav_Kuosan_1_3_0_5s.mdx", x, y, 1, 1, 0.9, 100))
                        set k = 0
                        loop
                            exitwhen k > 3
                            call DestroyEffect(EffectSpawn3("war3mapimported\\wos_vergilslashes.mdx", x + 150 * Cos(a), y + 150 * Cos(a), a * bj_RADTODEG + k * 45 + ( -45), 1.1, 8, 112, -30))
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_tx-ha-chongfeng2.mdl", GetUnitX(c) - 250 * Cos(a), GetUnitY(c) - 250 * Sin(a), a * bj_RADTODEG, 1, 5, 0, 255, 255, 255, 75))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_3.mdl", x, y, GetRandomReal(0, 359), 1.2, 1.2 + k * 0.45, 1, 255, 255, 255, 45))
                            set k = k + 1
                        endloop
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call dmgphys(c, u, dmg)
                                    call MUE(u, 300, 0.3, a)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    call GroupAddUnit(g2, u)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                else
                    if r< rmax then 
                    call StopSpellUnit(td)
                    endif
                    call StopSpellUnit(c)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set td = null
                    set u = null
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
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            call StartSpellUnit(c)
            call StartSpellUnit(td)
            set g = CreateGroup()
            set u = null
            set x = GetUnitX(c)+125*Cos(a)
                        set y = GetUnitY(c)+125*Sin(a)
            call PosUnit(td,x,y)
            set a = GAngle(c, td) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = Erza6E_DamageAoe
            set dmg = GetHeroAgi(c, true) * Erza6E_DamageAgiBase
            set rmax = 0.51
            call SetUnitTimeScale(c, 1.4)
            call SetUnitAnimationByIndex(c, 5)
            call MakeSound("war3mapImported\\Hero_Erza6_Q2")
            if MUI_ErzaE == 0 then
                call TimerStart( t_ErzaE, 0.03, true, function thistype.Loop_ErzaE )
            endif
        endmethod
    endstruct

    private struct Erza6R_KS
        private static timer t_ErzaR = CreateTimer( )
        private static integer array m_ErzaR
        private static integer MUI_ErzaR = -1
        unit c
        real x
        real y
        real r2
        real r3
        group g
        unit u
        real aoe
        real r
        effect e
        effect e2
        private static method Loop_ErzaR takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaR
                set this = m_ErzaR[i]
                if GetUnitCurrentOrder(c) == OrderId("bloodlustoff") then
                    set r = r + 0.05
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    call BlzSetSpecialEffectPosition(e, x, y, 1)
                    call GroupClear( g )
                    call GroupEnumUnitsInRange( g , x, y , 30000 , null)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitAlly( u , GetOwningPlayer( c ))  then
                        call UnitRemoveBuffsEx(u,false,true,true,true,true,true,true)
                            if SR3(u, x, y) < aoe then
                            call ErzaBuffNakagami_Start(c,u)
                        endif
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    set u = null
                    if r3 > 1.4 then
                        set r3 = 0
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_5731-sl_8bc718f-F2.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 3, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_Lion_Pride_2.mdl", x, y, 1, 1, 1, 1))
                    else
                        set r3 = r3 + 0.05
                    endif
                    if r2 > 0.5 then
                        set r2 = 0
                        call DecorRemove(c, x, y, aoe, 20)
                        call GroupClear( g )
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                            call ErzaPassive(c, u, 7)
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    else
                        set r2 = r2 + 0.05
                    endif
                else
                    set u = null
                    if r < 0.33 then
                        call ColorEffDummy3(e, 0.33 - r, 255, 255, 255, 0.27)
                    else
                        call ColorEffDummy3(e, 0, 255, 255, 255, 0.27)
                    endif
                    call DestroyEffect(e2)
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set e = null
                    set e2 = null
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
            set r2 = 10
            set r3 = 10
            set aoe = Erza6R_Aoe
            set g = CreateGroup()
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Lion_Pride_2.mdl", x, y, 1, 1, 1, 1))
            set e = EffectSpawnScale("war3mapImported\\wos_Opdef (18)1.mdl", x, y, 1, 1, 0.01, 1, 0.3, 0.01, 3)
            call ColorEffDummy4(e, 0, 255, 255, 255, 0.33)
            set e2 = EffectSpawnColor("war3mapImported\\wos_JY-[I0]Attack1.mdl", x, y, 1, 1, 1.5, 3, 225, 255, 25, 255)
            call ColorEffDummy4(e2, 0, 255, 255, 75, 0.33)
            call MakeSound("war3mapImported\\Hero_Erza6_R")
            if MUI_ErzaR == 0 then
                call TimerStart( t_ErzaR, 0.05, true, function thistype.Loop_ErzaR )
            endif
        endmethod
    endstruct

    private struct Erza6T_KS
        private static timer t_ErzaT = CreateTimer( )
        private static integer array m_ErzaT
        private static integer MUI_ErzaT = -1
        unit c
        real x
        real y
        real r2
        integer k
        real r3
        real r4
        real r5
        real r6
        group g
        unit u
        real dmg
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
            local real random
            loop
                exitwhen i > MUI_ErzaT
                set this = m_ErzaT[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit(c)
                    if r == 0.3 then
                        call MakeSound("war3mapImported\\Hero_Erza6_T2")
                    endif
                    if r == 0.45 then
                        call SetUnitAnimationByIndex(c, 5)
                    endif
                    if r == 0.48 then
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_tx-ha-chongfeng2.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 5, 0, 255, 255, 255, 75))
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.4, 1, 255, 255, 255, 125))
                    endif
                    if r > 0.51 then
                        if r2 > 0.06 then
                            set r2 = 0
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_tx-ha-chongfeng2.mdl", GetUnitX(c) - 250 * Cos(a), GetUnitY(c) - 250 * Sin(a), a * bj_RADTODEG, 1, 5, 0, 255, 255, 255, 75))
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.4, 1, 255, 255, 255, 125))
                        else
                            set r2 = r2 + 0.03
                        endif                 
                        
                    set a = GAngle2(c,x,y)
                    call BlzSetUnitFacingEx(c,a*bj_RADTODEG)
                        call MoveUnit(c, move, a)
                        if SR3(c, x, y) < 550 and check == 0 then
                            call SetUnitAnimationByIndex(c, 5)
                            set check = 1                    
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_ErzaStarlight.mdl", x, y, 0, 3., 3.5, 0))
                        endif
                        if r3 > 0.06 then
                            set r3 = 0
                            set r5 = GetRandomReal(100, 350)
                            set r6 = GetRandomReal(6, 1)
                            set r4 = GetRandomReal(0.5, 0.9)
                            set e = EffectSpawn3("war3mapimported\\wos_vergilslashes.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG + GetRandomReal( -120, 120), r4, r6, r5, -30)
                            set r5 = GetRandomReal(275, 615)
                            call EMUE(e, r5, 0.42, bj_DEGTORAD * (a * bj_RADTODEG + GetRandomReal( -120, 120)))
                            if GetRandomInt(1, 2) == 1 then
                                call DestroyEffect(e)
                            else
                                call ColorEffDummy3(e, 0.6, 255, 255, 255, 0.5)
                            endif                           
                        else
                            set r3 = r3 + 0.03
                        endif
                        if SR3(c, x, y) < 150 then
                            set r = rmax
                        endif
                        if r == rmax then
                            set r = 9999
                            call MUE(c, 700, 0.33, a)
                            call MakeSound("war3mapImported\\Hero_Erza6_T4")
                            call DecorRemove(c, x, y, aoe, 100)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_hakkestart.mdx", x, y, GetRandomReal(0, 359), 1.25, 1.5, 0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.1, 3, 9))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.1, 4, 9))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.1, 5, 9))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_5731-sl_8bc718f-F2.mdl", x,y, GetRandomReal(0, 359), 1, 3, 1))
                            set random = GetRandomReal(0, 359)
                            set e = EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, random, 0.75, 2, 155)
                            call BlzSetSpecialEffectRoll(e, -10 * bj_DEGTORAD)
                            call DestroyEffect(e)
                            set random = GetRandomReal(0, 359)
                            set e = EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, random, 0.75, 2, 155)
                            call BlzSetSpecialEffectRoll(e, -10 * bj_DEGTORAD)
                            call DestroyEffect(e)
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_ZK_Narumea_lianzhan1.mdx", x - 50 * Cos(a), y - 50 * Sin(a), a * bj_RADTODEG + GetRandomReal( -15, 15), 2.25, 2.95, 1, 255, 255, 255, 125))
                            set k = 0
                            loop
                                exitwhen k > 4
                                if k <= 4 then
                                    call DestroyEffect(EffectSpawn3("war3mapimported\\wos_BY_Wood_Eff_Ord_DanGe_Wav_Kuosan_1_3_0_5s.mdx", x, y, GetRandomReal(0, 359), 1, 1.4, 150, -30))
                                endif
                                set r5 = GetRandomReal(100, 350)
                                set r6 = GetRandomReal(10, 16)
                                set r4 = GetRandomReal(0.5, 0.9)
                                set e = EffectSpawn3("war3mapimported\\wos_vergilslashes.mdx", x, y, GetRandomReal(0, 359), r4, r6, r5, -30)
                                set r5 = GetRandomReal(325, 750)
                                call EMUE(e, r5, 0.42, GetRandomReal(0, 359) * bj_DEGTORAD)
                                call DestroyEffect(e)
                                set k = k + 1
                            endloop
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                        call dmgphys(c, u, dmg)
                                        call StunUnit(c, u, Erza6T_Stun)
                                        call ErzaPassive(c,u,8)
                                        call EUTU2_3(EffectSpawn("war3mapimported\\wos_0854.mdx", x, y, a * bj_RADTODEG, 1, 2.5, 1), 0.76, 1, u)
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        endif
                    endif
                else
                    call MakeSound("war3mapImported\\Hero_Erza6_T3")
                    call DestroyEffect(e2)
                    call DestroyEffect(e3)
                    call StopSpellUnit(c)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
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
        public static method ErzaT_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaT = MUI_ErzaT + 1
            set m_ErzaT[MUI_ErzaT] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set check = 0
            call StartSpellUnit(c)
            set g = CreateGroup()
            set u = null
            set r5 = 0
            set a = GAngle2(c, x, y) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = Erza6T_DamageAoe
            set dmg = GetHeroAgi(c, true) * Erza6T_DamageAgiBase
            set rmax = 2.01
            set move = 90
            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_0001.mdx", c, "origin")
            set e3 = AddSpecialEffectTarget("war3mapimported\\wos_afb (2634).mdl", c, "weapon")
            call SetUnitTimeScale(c, 0.5)
            call SetUnitAnimationByIndex(c, 1)
            call MakeSound("war3mapImported\\Hero_Erza6_T")
            if MUI_ErzaT == 0 then
                call TimerStart( t_ErzaT, 0.03, true, function thistype.Loop_ErzaT )
            endif
        endmethod
    endstruct

    private struct Erza6G_KS
        private static timer t_ErzaG = CreateTimer( )
        private static integer array m_ErzaG
        private static integer MUI_ErzaG = -1
        unit c
        framehandle array frame_pas1[10]
        framehandle array frame_pas2[10]
        framehandle array frame_pas3[10]
        framehandle array frame_pas4[10]
        framehandle array frame_pas5[10]
        framehandle array frame_pas6[10]
        integer k2
        group g2
        real r
        real rmax
        private static method Loop_ErzaG takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real random
            loop
                exitwhen i > MUI_ErzaG
                set this = m_ErzaG[i]
                if SpellBoolCaster(c) and r <= rmax and LoadInteger(hs,GetHandleId(c),StringHash("erza g2 active")) == 1 then 
                if IsUnitPaused(c) == false then 
                    set r = r + 0.1
                    set r = S2R(R2SW(r,0,2))
                    endif
                     call  BlzFrameSetValue(frame_pas3[k2], rmax-(r+0.1))
                        if rmax -r >=0 then 
                        call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(rmax-r,0,2) + "|r")
                    endif
                    else
                    if r>= rmax then 
                    call ErzaF_Start(c)
                    endif
                    if GetLocalPlayer() == GetOwningPlayer(c) then 
                    call BlzFrameSetVisible(frame_pas1[k2],false)
                    endif
                    set c = null
                    set m_ErzaG[i] = m_ErzaG[MUI_ErzaG]
                    set MUI_ErzaG = MUI_ErzaG - 1
                    if MUI_ErzaG == -1 then
                        call PauseTimer( t_ErzaG )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaG_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaG = MUI_ErzaG + 1
            set m_ErzaG[MUI_ErzaG] = this
            set c = NewC
            set r = 0
            set rmax = Erza6_ArmorDuration 
            set k2 = GetPlayerId(GetOwningPlayer(c))
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
        if LoadInteger(hs,GetHandleId(c),StringHash("erza g2 type")) == 1 then 
        call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Erza_G2_1Pas.blp", 0, false)
        else
        call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Erza_G2_2Pas.blp", 0, false)
        endif
        set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
        call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
        call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Time Left:" + "|r")
        call BlzFrameSetScale(frame_pas5[k2],0.9)
        set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
        call BlzFrameSetAbsPoint(frame_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17)
        call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(Test_real,0,2) + "|r")
        call BlzFrameSetScale(frame_pas6[k2],0.9)
        else
        if GetLocalPlayer() == GetOwningPlayer(c) then 
        call BlzFrameSetVisible(frame_pas1[k2],true)
        endif
        if LoadInteger(hs,GetHandleId(c),StringHash("erza g2 type")) == 1 then 
        call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Erza_G2_1Pas.blp", 0, false)
        else
        call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Erza_G2_2Pas.blp", 0, false)
        endif
        call  BlzFrameSetValue(frame_pas3[k2], rmax)
        endif
            if MUI_ErzaG == 0 then
                call TimerStart( t_ErzaG, 0.1, true, function thistype.Loop_ErzaG )
            endif
        endmethod
    endstruct

    //----------------------------Erza-----------------------------------------------
     /* Animations index:
    Base:
    1 - Forward attack
    2 - pierce atk
    3 - move
    4 - fly
    5 - t
     */ 
    function Erza6Q_Start takes unit c, real x, real y returns nothing
        call Erza6Q_KS.ErzaQ_Start( c, x, y )
    endfunction
    function Erza6W_Start takes unit c returns nothing
        call Erza6W_KS.ErzaW_Start( c )
    endfunction
    function Erza6E_Start takes unit c, unit td returns nothing
        call Erza6E_KS.ErzaE_Start( c, td )
    endfunction
    function Erza6R_Start takes unit c returns nothing
        call Erza6R_KS.ErzaR_Start( c )
    endfunction
    function Erza6T_Start takes unit c, real x, real y returns nothing
        call Erza6T_KS.ErzaT_Start( c, x, y)
    endfunction
    function Erza6G_Start takes unit c returns nothing
        call Erza6G_KS.ErzaG_Start( c)
    endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com