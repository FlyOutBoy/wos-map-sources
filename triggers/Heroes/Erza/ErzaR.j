library ErzaRSpells uses GearSystems
    globals
        integer Gray_ID1 = 'H06V'
        integer Gray_ID2 = 'H04L'
//---------------Q ability-----------------------------------------------------
        integer Erza4Q_ID = 'A03H'
        real Erza4Q_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real Erza4Q_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real Erza4Q_Damage2StaticBase = 0 // base static damage for 1 level
        real Erza4Q_Damage2StaticStep = 0 // additional static damage for each next level
        real Erza4Q_DamageAoe = 275
//---------------W ability-----------------------------------------------------
        integer Erza4W_ID = 'A03I'
        real Erza4W_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real Erza4W_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real Erza4W_DamageStatic = 0 // additional number x Agi damage for each next level
        real Erza4W_DamageAoe = 425
//---------------E ability-----------------------------------------------------
        integer Erza4E_ID = 'A03J'
        real Erza4E_DamageAgiFastBase = 0.5 // base number x Agi damage for 1 level for fast variation of slice
        real Erza4E_DamageAgiFastStep = 0.5 // additional number x Agi damage for each next level for fast variation of slice
        real Erza4E_DamageAgiLongBase = 2 // base number x Agi damage for 1 level for long variation of slice
        real Erza4E_DamageAgiLongStep = 1 // additional number x Agi damage for each next level for long variation of slice
        real Erza4E_DamageAoe = 700
        real Erza4E_Stun = 0.1 // each tick of damage cause stun from 0.1 to 3.0
        integer Erza4E_StackDuration = 5 // from 1 to N sec, example 1..2...3...4...5... only integer
//---------------R ability-----------------------------------------------------
        integer Erza4R_ID = 'A03K'
        real Erza4R_DamageAgiBase = 3 // base number x Agi damage per 1 second
        real Erza4R_DamageAgiStep = 1 // additional number x Agi damage for each next level per second
        real Erza4R_DamageAoe = 600
        real Erza4R_Stun = 1 // from 0.1 to 3
//---------------T ability-----------------------------------------------------
        integer Erza4T_ID = 'A03L'
        real Erza4T_DamageAgiBase = 8 // base number x Agi damage for 1 level
        real Erza4T_DamageAoe = 450
        real Erza4T_Stun = 0
        real Erza4TT_Duration = 15 // in seconds , buff duration time
        real Erza4TT_AdditionalAgiDmgPerAtk = 1 // from 0 to N , 0.1...0.5, 2....100...
//---------------F ability-----------------------------------------------------
        integer Erza4F_ID = 'A03M'
        integer Erza4F_AttackDamageAdd_1Element = 50 // any number from 1 to N, work when only 1 element in swords
        integer Erza4F_AttackDamageAdd_2Element = 100 // any number from 1 to N, work when 2 elements in swords
        integer Erza4F_AttackDamageAdd_NatsuGray = 125 // any number from 1 to N, work when natsu and gray in team
        real Erza4F_AddErzaSpellDamage_1Element = 5 // additional damage of Erza abilities Q W E R in %, works when 1 element in swords
        real Erza4F_AddErzaSpellDamage_2Element = 10 // additional damage of Erza abilities Q W E R in %, works when 2 element in swords
        real Erza4F_AddErzaSpellDamage_NatsuGray = 15 // additional damage of Erza abilities Q W E R in %, works when natsu and gray in team
        real Erza4F_Duration = 15 // in seconds , buff duration time
    endglobals
     

    private struct Erza4Q_KS
        private static timer t_ErzaQ = CreateTimer( )
        private static integer array m_ErzaQ
        private static integer MUI_ErzaQ = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k
        group g
        unit u
        real dmg
        integer check
        integer check2
        real aoe
        real move
        real r
        effect e3
        real a
        real rmax
        private static method Loop_ErzaQ takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaQ
                set this = m_ErzaQ[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    if check == 0 then
                        set a = GAngle(c, td)
                        call SetUnitFacing(c, a * bj_RADTODEG)
                        if r < rmax then
                        if r > 0.3 then 
                            call MoveUnit(c, move, a)
                            if r2 > 0.03 then
                                set r2 = 0
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_Hashirama_MADARAa (73).mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.85, 1.15, 1))
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif    
                        endif
                        if SR2(c, td) < 120 then
                            set r = rmax
                        endif
                        if r == rmax then
                            set check = 1
                            set r = 0
                            call SetUnitTimeScale(c, 1.25)
                            call SetUnitAnimationByIndex(c, 3)
                            set rmax = 0.12
                            call MakeSound("Erza1_Q2")
                        endif
                    elseif check == 1 then
                        if r == rmax then
                            set x = GetUnitX(td) + 0 * Cos(a)
                            set y = GetUnitY(td) + 0 * Sin(a)
                            if LoadInteger(hs, GetHandleId(c), StringHash("erza 4 tt")) == 1 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_zk_thunder chopper_you.mdl", x, y, a * bj_RADTODEG - 90, 0.875, 0.8, 275))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_zk_thunder chopper_you.mdl", x, y, a * bj_RADTODEG + 90, 0.9, 0.9, 225))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)4.mdl", x, y, 0, 2, 1, 1))
                            else
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZK_flash2.mdl", GetUnitX(td), GetUnitY(td), a * bj_RADTODEG, 1.5, 1, 145))
                            endif
                            set e3 = EffectSpawnColor("war3mapimported\\wos_Satsu-WSFX-1_1.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.75, 2.15, 1, 255, 35, 35, 255)
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_acg_bbb.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1.85, 2.25, 150, 255, 255, 255, 165))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_windcirclefasterwhite.mdx", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1.85, 1.55, 1, 255, 255, 255, 125))
                            if check2 == 1 then
                                call BlzSetSpecialEffectColor(e3, 255, 185, 25)
                            elseif check2 == 3 then
                                call BlzSetSpecialEffectColor(e3, 125, 255, 255)
                            elseif check2 == 2 then
                                call BlzSetSpecialEffectColor(e3, 0, 155, 255)
                            elseif check2 == 5 then
                                call BlzSetSpecialEffectColor(e3, 255, 185, 25)
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Satsu-WSFX-1_1.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG - 45, 1.75, 2.5, 1, 125, 255, 255, 255))
                            elseif check2 == 4 then
                                call BlzSetSpecialEffectColor(e3, 125, 255, 255)
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Satsu-WSFX-1_1.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG - 45, 1.75, 2.5, 1, 0, 155, 255, 255))
                            elseif check2 == 6 then
                                call BlzSetSpecialEffectColor(e3, 0, 155, 25)
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Satsu-WSFX-1_1.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG - 45, 1.75, 2.5, 1, 125, 255, 255, 255))
                            elseif check2 == 7 then
                                call BlzSetSpecialEffectColor(e3, 255, 185, 25)
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Satsu-WSFX-1_1.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG - 45, 1.75, 2.5, 1, 125, 255, 255, 255))
                            endif
                            call DestroyEffect(e3)
                            if check2 == 1 or check2 == 4 or check2 == 5 or check2 == 7 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_fire explosion.mdl", x, y, GetRandomReal(0, 359), 1, 1.45, 105))
                                if check2 == 1 then
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-fire.mdl", x, y, a * bj_RADTODEG + 45, 1.5, 0.95, 145))
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-fire.mdl", x, y, a * bj_RADTODEG - 45, 1.5, 0.95, 145))
                                endif
                            endif
                            if check2 == 7 then
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_afbbxks2.mdl", x, y, GetRandomReal(0, 359), 2, 2.1, 1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-fire.mdl", x, y, a * bj_RADTODEG + 45, 1.5, 0.95, 145))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, a * bj_RADTODEG - 45, 1.5, 0.95, 145))
                            endif
                            
                            if check2 == 3 or check2 == 5 or check2 == 6 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_SasukeYh-41.mdl", x, y, GetRandomReal(0, 359), 1.5, 4, 75))
                                if check2 == 3 then
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, a * bj_RADTODEG + 45, 1.5, 0.95, 145))
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, a * bj_RADTODEG - 45, 1.5, 0.95, 145))
                                endif
                            endif
                            if check2 == 2 or check2 == 4 or check2 == 6 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_Eff (134).mdl", x, y, GetRandomReal(0, 359), 1.65, 4, 1))
                                if check2 == 2 then
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-water_ice.mdl", x, y, a * bj_RADTODEG + 45, 1.5, 0.95, 145))
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-water_ice.mdl", x, y, a * bj_RADTODEG - 45, 1.5, 0.95, 145))
                                endif
                            endif
                            if check2 == 0 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-red.mdl", x, y, a * bj_RADTODEG + 45, 1.5, 0.95, 145))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-red.mdl", x, y, a * bj_RADTODEG - 45, 1.5, 0.95, 145))
                            endif
                            set k = 0
                            call DecorRemove(c,x,y,aoe,40)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_whiteakihared.mdx", GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359), 0.85, 1, GetUnitFlyHeight(u) + 50))
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    call dmgphys(c, u, dmg)
                                    if check2 > 0 then
                                        call ErzaPassive(c, u, check2)
                                    endif
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        endif
                    endif
                else
                    call StopSpellUnit2(c)
                    call DestroyGroup(g)
                    set g = null
                    set check = 0
                    set c = null
                    set u = null
                    set e3 = null
                    set td = null
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
        public static method ErzaQ_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaQ = MUI_ErzaQ + 1
            set m_ErzaQ[MUI_ErzaQ] = this
            set c = NewC
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r = 0
            set check = 0
            set r2 = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set a = GAngle2(c, x, y) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = Erza4Q_DamageAoe
            set dmg = Erza4Q_Damage2StaticBase + (Erza4Q_Damage2StaticStep * (GetUnitAbilityLevel(c, Erza4Q_ID) - 1))
            set dmg = dmg + GetHeroAgi(c, true) * (Erza4Q_DamageAgiBase + (Erza4Q_DamageAgiStep * (GetUnitAbilityLevel(c, Erza4Q_ID) - 1)))
            set rmax = 0.75
            set move = 90
            set check2 = 0
            if LoadInteger(hs, GetHandleId(c), StringHash("type sword")) > 0 then
                set dmg = dmg + (dmg * LoadReal(hs, GetHandleId(c), StringHash("add spell dmg erza4 f")) )
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("type sword")) // 0 - no sword, 1 - fire, 3 - lightning, 2 - water, 5 - fire and lightning, 4 - fire and water, 6 - water and lightning, 7 - natsu and gray
            endif
            call SetUnitTimeScale(c, 2.15)
            call SetUnitAnimationByIndex(c, 17)
            set k = GetRandomInt(1, 3)
            if k == 1 then
                call MakeSound("war3mapImported\\Hero_Erza4_Q")
            elseif k == 2 then
                call MakeSound("war3mapImported\\Hero_Erza4_Q2")
            elseif k == 3 then
                call MakeSound("war3mapImported\\Hero_Erza4_Q3")
            endif
            if MUI_ErzaQ == 0 then
                call TimerStart( t_ErzaQ, 0.03, true, function thistype.Loop_ErzaQ )
            endif
        endmethod
    endstruct

    private struct Erza4W_KS
        private static timer t_ErzaW = CreateTimer( )
        private static integer array m_ErzaW
        private static integer MUI_ErzaW = -1
        unit c
        real x
        real y
        real r2
        integer k
        group g
        unit u
        real dmg
        integer check2
        real aoe
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
                    if r < rmax then
                    
                    set a = GAngle2(c,x,y)
                    call BlzSetUnitFacingEx(c,a*bj_RADTODEG)
                        call MoveUnit(c, move, a)
                        if r2 > 0.03 then
                            set r2 = 0
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_blackblink.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG + 90, 2.85, 1.5, 1))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_Hashirama_MADARAa (73).mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.85, 1.5, 1))
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                    if SR3(c, x, y) < 120 then
                        set r = rmax
                    endif
                    if r == rmax then
                    set r = 9999
                        set x = GetUnitX(c) + 150 * Cos(a)
                        set y = GetUnitY(c) + 150 * Sin(a)
                        if k == 1 then
                            call MakeSound("war3mapImported\\Hero_Erza4_W2 1")
                        elseif k == 2 then
                            call MakeSound("war3mapImported\\Hero_Erza4_W2 2")
                        elseif k == 3 then
                            call MakeSound("war3mapImported\\Hero_Erza4_W2 3")
                        endif
                        call MUE(c, 350, 0.3, a)
                        if LoadInteger(hs, GetHandleId(c), StringHash("erza 4 tt")) == 1 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_zk_thunder chopper_you.mdl", x, y, a * bj_RADTODEG - 90, 0.875, 0.8, 275))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_zk_thunder chopper_you.mdl", x, y, a * bj_RADTODEG + 90, 0.9, 0.5, 225))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)4.mdl", x, y, 0, 1.8, 1.1, 1))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-Hit-red.mdl", x, y, a * bj_RADTODEG, 1, 3, 155))
                        else
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZK_flash2.mdl", x, y, a * bj_RADTODEG, 1.5, 1., 145))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_3x4_94.mdx", x, y, GetRandomReal(0, 359), 0.65, 2.95, 15))
                        endif
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_acg_bbb.mdx", x, y, GetRandomReal(0, 359), 2.15, 2.25, 150, 255, 255, 255, 165))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_2B2506950AC33FAB.mdx", x, y, GetRandomReal(0, 359), 2.5, 5.1, 1))
                        if check2 == 1 or check2 == 4 or check2 == 5 or check2 == 7 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdx", x, y, GetRandomReal(0, 359), 1, 3.75, 50))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_fire explosion.mdl", x, y, GetRandomReal(0, 359), 1, 1.45, 105))
                            if check2 == 1 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-fire.mdl", x, y, a * bj_RADTODEG + 45, 1.5, 0.95, 145))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-fire.mdl", x, y, a * bj_RADTODEG - 45, 1.5, 0.95, 145))
                            endif
                        endif
                        if check2 == 7 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-fire.mdl", x, y, a * bj_RADTODEG + 45, 1.5, 0.95, 145))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, a * bj_RADTODEG - 45, 1.5, 0.95, 145))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_az-ice-zhendi.mdl", x, y, GetRandomReal(0, 359), 1.5, 3.85, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_nevermoreice_x.mdl", x, y, GetRandomReal(0, 359), 1, 3.5, 1))
                        endif
                        if check2 == 3 or check2 == 5 or check2 == 6 then
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue--zhendi31_3.mdl", x, y, a * bj_RADTODEG, 1.1, 2, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_SasukeYh-41.mdl", x, y, GetRandomReal(0, 359), 1.5, 4, 75))
                            if check2 == 3 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, a * bj_RADTODEG + 45, 1.5, 0.95, 145))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, a * bj_RADTODEG - 45, 1.5, 0.95, 145))
                            endif
                        endif
                        if check2 == 2 or check2 == 4 or check2 == 6 then
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_waterexplosion.mdl", x, y, a * bj_RADTODEG, 1.1, 2, 1))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_az_xiaonajia01_d_W.mdx", x, y, GetRandomReal(0, 359), 0.75, 3, 5))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdl", x, y, GetRandomReal(0, 359), 0.75, 1.75, 1))
                            if check2 == 2 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, a * bj_RADTODEG + 45, 1.5, 0.95, 145))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-blue.mdl", x, y, a * bj_RADTODEG - 45, 1.5, 0.95, 145))
                            endif
                        endif
                        if check2 == 0 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-red.mdl", x, y, a * bj_RADTODEG + 45, 1.5, 0.95, 145))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_zhanji-red.mdl", x, y, a * bj_RADTODEG - 45, 1.5, 0.95, 145))
                        endif
                        set k = 0
                        call DecorRemove(c,x,y,aoe,40)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                call dmgphys(c, u, dmg)
                                if check2 > 0 then
                                    call ErzaPassive(c, u, check2)
                                endif
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                else
                    call SetUnitVertexColor(c, 255, 255, 255, 255)
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
            set g = CreateGroup()
            set u = null
            call StartSpellUnit2(c)
            set a = GAngle2(c, x, y) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = Erza4W_DamageAoe
            set dmg = GetHeroAgi(c, true) * (Erza4W_DamageAgiBase + (Erza4W_DamageAgiStep * (GetUnitAbilityLevel(c, Erza4W_ID) - 1)))
            set rmax = 0.75
            set move = 100
            call SetUnitTimeScale(c, 0.65)
            call SetUnitAnimationByIndex(c, 17)
            call SetUnitVertexColor(c, 25, 25, 25, 155)
            set check2 = 0
            if LoadInteger(hs, GetHandleId(c), StringHash("type sword")) > 0 then
                set dmg = dmg + (dmg * LoadReal(hs, GetHandleId(c), StringHash("add spell dmg erza4 f")) )
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("type sword")) // 0 - no sword, 1 - fire, 3 - lightning, 2 - water, 5 - fire and lightning, 4 - fire and water, 6 - water and lightning, 7 - natsu and gray
            endif
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapImported\\Hero_Erza4_W3")
            else
                call MakeSound("war3mapImported\\Hero_Erza4_W4")
            endif
            set k = GetRandomInt(1, 3)
            if MUI_ErzaW == 0 then
                call TimerStart( t_ErzaW, 0.03, true, function thistype.Loop_ErzaW )
            endif
        endmethod
    endstruct

    private struct Erza4E_KS
        private static timer t_ErzaE = CreateTimer( )
        private static integer array m_ErzaE
        private static integer MUI_ErzaE = -1
        unit c
        real x
        real y
        real r2
        integer k
        integer k3
        real r3
        real r4
        real r5
        group g
        unit u
        real dmg
        integer check2
        real aoe
        real r
        effect e
        real a
        real rmax
        private static method Loop_ErzaE takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real rr1 = 165
            local real rr2 = 185
            loop
                exitwhen i > MUI_ErzaE
                set this = m_ErzaE[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if r == 0.03 then
                        set r2 = 10
                        if k == 3 then
                            call MyFlush(GetHandleId(c), StringHash("e stacks"), 0, 0.1)
                            call OkarunEggCd(c,Erza4E_ID,r5)
                       else
                            call BlzStartUnitAbilityCooldown(c, Erza4E_ID, 0.05)
                        endif
                    endif
                    if r == 0.21 and GetHeroLevel(c)>=35 then 
            call UnitAddAbility(c,'Avul')
                    endif
                    if r == 0.69 and k3 == 1 then
                        call MakeSound("war3mapImported\\Hero_Erza4_E4")
                    endif
                    if k3 == 0 then
                        if r == 0.21 then
                            set r5 = GetRandomReal(0, 359)
                            if check2 == 0 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_red.mdl", x, y, r5, 1, 3, rr1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_red.mdl", x, y, r5 + 180, 0.95, 3.35, rr2))
                            elseif check2 == 1 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_fire2.mdl", x, y, r5, 1, 3, rr1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_fire2.mdl", x, y, r5 + 180, 0.95, 3.35, rr2))
                            elseif check2 == 3 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_lightning2.mdl", x, y, r5, 1, 3, rr1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_lightning2.mdl", x, y, r5 + 180, 0.95, 3.35, rr2))
                            elseif check2 == 2 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_22.mdl", x, y, r5, 1, 3, rr1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_22.mdl", x, y, r5 + 180, 0.95, 3.35, rr2))
                            elseif check2 == 5 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_fire2.mdl", x, y, r5, 1, 3, rr1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_lightning2.mdl", x, y, r5 + 180, 0.95, 3.35, rr2))
                            elseif check2 == 4 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_fire2.mdl", x, y, r5, 1, 3, rr1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_22.mdl", x, y, r5 + 180, 0.95, 3.35, rr2))
                            elseif check2 == 6 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_lightning2.mdl", x, y, r5, 1, 3, rr1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_22.mdl", x, y, r5 + 180, 0.95, 3.35, rr2))
                            elseif check2 == 7 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_fire2.mdl", x, y, r5, 1, 3, rr1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_snow.mdl", x, y, r5 + 180, 0.95, 3.35, rr2))
                            endif
                            if LoadInteger(hs, GetHandleId(c), StringHash("erza 4 tt")) == 1 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)4.mdl", x, y, GetRandomReal(0, 359), 1.7, 1.1, 1))
                            endif
                        endif
                        if r == rmax then
                            set x = GetUnitX(c)
                            set y = GetUnitY(c)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_1feng_932_white.mdl", x, y, GetRandomReal(0, 359), 1.5, 2.15, 0))
                            if check2 == 1 or check2 == 4 or check2 == 5 or check2 == 7 then
                                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdx", x, y, GetRandomReal(0, 359), 1, 3.25, 50, 255, 255, 255, 75))
                            endif
                            if check2 == 3 or check2 == 5 or check2 == 6 then
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue--zhendi31_3.mdl", x, y, a * bj_RADTODEG, 1.1, 2, 1))
                            endif
                            if check2 == 2 or check2 == 4 or check2 == 6 then
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_az_xiaonajia01_d_W.mdx", x, y, GetRandomReal(0, 359), 0.75, 3, 5))
                            endif
                            set k = 0
                            call DecorRemove(c,x,y,aoe,50)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    call dmgphys(c, u, dmg)
                                    call StunUnit(c, u, Erza4E_Stun)
                                    if check2 > 0 then
                                        call ErzaPassive(c, u, check2)
                                    endif
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        endif
                    else
                        if r2 > 0.24 then
                            set r2 = 0
                            set r5 = GetRandomReal(0, 359)
                            if LoadInteger(hs, GetHandleId(c), StringHash("erza 4 tt")) == 1 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)4.mdl", x, y, GetRandomReal(0, 359), 1.7, 1.1, 1))
                            endif
                            if check2 == 0 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_red.mdl", x, y, r5, 1, 3, rr1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_red.mdl", x, y, r5 + 180, 0.95, 3.35, rr2))
                            elseif check2 == 1 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_fire2.mdl", x, y, r5, 1, 3, rr1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_fire2.mdl", x, y, r5 + 180, 0.95, 3.35, rr2))
                            elseif check2 == 3 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_lightning2.mdl", x, y, r5, 1, 3, rr1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_lightning2.mdl", x, y, r5 + 180, 0.95, 3.35, rr2))
                            elseif check2 == 2 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_22.mdl", x, y, r5, 1, 3, rr1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_22.mdl", x, y, r5 + 180, 0.95, 3.35, rr2))
                            elseif check2 == 5 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_fire2.mdl", x, y, r5, 1, 3, rr1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_lightning2.mdl", x, y, r5 + 180, 0.95, 3.35, rr2))
                            elseif check2 == 4 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_fire2.mdl", x, y, r5, 1, 3, rr1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_22.mdl", x, y, r5 + 180, 0.95, 3.35, rr2))
                            elseif check2 == 6 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_lightning2.mdl", x, y, r5, 1, 3, rr1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_22.mdl", x, y, r5 + 180, 0.95, 3.35, rr2))
                            elseif check2 == 7 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_fire2.mdl", x, y, r5, 1, 3, rr1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_32F1D1EAB79EF38E_2_snow.mdl", x, y, r5 + 180, 0.95, 3.35, rr2))
                            endif
                            call GroupClear(g)
                            call DecorRemove(c,x,y,aoe,50)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    call dmgphys(c, u, dmg)
                                    call StunUnit(c, u, Erza4E_Stun)
                                    if check2 > 0 then
                                        call ErzaPassive(c, u, check2)
                                    endif
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        else
                            set r2 = r2 + 0.03
                        endif
                        if r4 > 0.36 then
                            set r4 = 0
                            if check2 == 1 or check2 == 4 or check2 == 5 then
                                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdx", x, y, GetRandomReal(0, 359), 1, 3.25, 50, 255, 255, 255, 95))
                                if check2 == 5 then
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_fire explosion.mdl", x, y, GetRandomReal(0, 359), 1, 2.45, 105))
                                endif
                            endif
                            if check2 == 3 or check2 == 5 or check2 == 6 then
                                if check2 == 5 then
                                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue--zhendi31_3_x1.5.mdl", x, y, a * bj_RADTODEG, 1.1, 1, 1))
                                else
                                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue--zhendi31_3.mdl", x, y, a * bj_RADTODEG, 1.1, 2, 1))
                                endif
                            endif
                            if check2 == 2 or check2 == 4 or check2 == 6 then
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_az_xiaonajia01_d_W.mdx", x, y, GetRandomReal(0, 359), 0.75, 3, 5))
                            endif
                            if check2 == 7 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_fire explosion.mdl", x, y, GetRandomReal(0, 359), 1, 2.45, 105))
                            endif
                        else
                            set r4 = r4 + 0.03
                        endif
                        if r3 > 0.14 then
                            set r3 = 0
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_1feng_932_white.mdl", x, y, GetRandomReal(0, 359), 1.5, 2.15, 0))
                        else
                            set r3 = r3 + 0.03
                        endif
                    endif
                else    
                    if k ==3 then 
                    call UnitRemoveAbility(c,'Avul')
                    endif
                    if GetHeroLevel(c)>=35 then 
            call UnitRemoveAbility(c,'Avul')
            endif
                    call StopSpellUnit2(c)
                    call SetUnitAnimation(c, "stand")
                    call DestroyGroup(g)
                    set g = null
                    set c = null
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
        public static method ErzaE_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaE = MUI_ErzaE + 1
            set m_ErzaE[MUI_ErzaE] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set k3 = 0
            set r2 = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set a = GetUnitFacing(c) * bj_DEGTORAD // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = Erza4E_DamageAoe
            set dmg = GetHeroAgi(c, true) * (Erza4E_DamageAgiFastBase + (Erza4E_DamageAgiFastStep * (GetUnitAbilityLevel(c, Erza4E_ID) - 1)))
            set rmax = 0.45
            if GetHeroLevel(c)>=35 then 
            set rmax = 0.3 
            endif
            set check2 = 0
            call SetUnitTimeScale(c, 1.15)
            call SetUnitAnimationByIndex(c, 14)
            set r5 = BlzGetUnitAbilityCooldown(c, Erza4E_ID, GetUnitAbilityLevel(c, Erza4E_ID) - 1)
            set k = LoadInteger(hs, GetHandleId(c), StringHash("e stacks"))
            set k = k + 1
            call SaveInteger(hs, GetHandleId(c), StringHash("e stacks"), k)
            if k == 3 then
            call UnitAddAbility(c,'Avul')
                set k3 = 1
                set rmax = 2.01
                set dmg = GetHeroAgi(c, true) * (Erza4E_DamageAgiLongBase + (Erza4E_DamageAgiLongStep * (GetUnitAbilityLevel(c, Erza4E_ID) - 1)))
                set dmg = dmg / 6
                call MakeSound("war3mapImported\\Hero_Erza4_E5")
                if GetRandomInt(1, 2) == 1 then
                    call MakeSound("war3mapImported\\Hero_Erza4_E03")
                else
                    call MakeSound("war3mapImported\\Hero_Erza4_E3")
                endif                
                call BlzSetAbilityIcon(Erza4E_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Erza4_E.blp")
            elseif k == 2 then
                call ErzaStackRemoved(c, GetHandleId(c), StringHash("e stacks"), 0, I2R(Erza4E_StackDuration))
                if GetRandomInt(1, 2) == 1 then
                    call MakeSound("war3mapImported\\Hero_Erza4_E02")
                else
                    call MakeSound("war3mapImported\\Hero_Erza4_E2")
                endif
                call BlzSetAbilityIcon(Erza4E_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Stack1.blp")
            elseif k == 1 then
                call ErzaStackRemoved(c, GetHandleId(c), StringHash("e stacks"), 0, I2R(Erza4E_StackDuration))
                if GetRandomInt(1, 2) == 1 then
                    call MakeSound("war3mapImported\\Hero_Erza4_E01")
                else
                    call MakeSound("war3mapImported\\Hero_Erza4_E")
                endif
                call BlzSetAbilityIcon(Erza4E_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Stack2.blp")
            endif
            if LoadInteger(hs, GetHandleId(c), StringHash("type sword")) > 0 then
                set dmg = dmg + (dmg * LoadReal(hs, GetHandleId(c), StringHash("add spell dmg erza4 f")) )
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("type sword")) // 0 - no sword, 1 - fire, 3 - lightning, 2 - water, 5 - fire and lightning, 4 - fire and water, 6 - water and lightning, 7 - natsu and gray
            endif
            if MUI_ErzaE == 0 then
                call TimerStart( t_ErzaE, 0.03, true, function thistype.Loop_ErzaE )
            endif
        endmethod
    endstruct

    private struct Erza4R_KS
        private static timer t_ErzaR = CreateTimer( )
        private static integer array m_ErzaR
        private static integer MUI_ErzaR = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k
        real r3
        group g
        unit u
        real dmg
        integer check
        integer check2
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax
        private static method Loop_ErzaR takes nothing returns nothing
            local thistype this
            local integer i = 0
            local integer red
            local integer green
            local integer blue
            local integer red2 = 0
            local integer green2 = 0
            local integer blue2 = 0
            loop
                exitwhen i > MUI_ErzaR
                set this = m_ErzaR[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    if check == 0 then
                        if r < rmax then
                            if r3 > 0.03 then
                                set r3 = 0
                                if check2 == 0 then
                                    set red = 255
                                    set green = 35
                                    set blue = 35
                                elseif check2 == 1 then
                                    set red = 255
                                    set green = 145
                                    set blue = 85
                                elseif check2 == 2 then
                                    set red = 110
                                    set green = 155
                                    set blue = 255
                                elseif check2 == 3 then
                                    set red = 100
                                    set green = 255
                                    set blue = 255
                                elseif check2 == 4 or check2 == 7 then
                                    set red = 255
                                    set green = 145
                                    set blue = 85
                                    set red2 = 110
                                    set green2 = 155
                                    set blue2 = 255
                                elseif check2 == 5 then
                                    set red = 255
                                    set green = 145
                                    set blue = 85
                                    set red2 = 100
                                    set green2 = 255
                                    set blue2 = 255
                                elseif check2 == 6 then
                                    set red = 100
                                    set green = 255
                                    set blue = 255
                                    set red2 = 110
                                    set green2 = 155
                                    set blue2 = 255
                                endif
                                if r < 0.51 then
                                    if red2 == 0 then
                                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_1feng_932_white.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 1.25, 0, red, green, blue, 100))
                                    else
                                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_1feng_932_white.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 1.25, 0, red2, green2, blue2, 100))
                                    endif
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_dustwave222.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 1.25, 0, red, green, blue, 45))
                                else
                                    if red2 != 0 then
                                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Effect_Order_DanGe_ChongFengQiLiu_1_5.mdx", GetUnitX(c) + 75 * Cos(a), GetUnitY(c) + 75 * Sin(a), a * bj_RADTODEG, 1.25, 0.85, 1, red2, green2, blue2, 255))
                                    endif
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Effect_Order_DanGe_ChongFengQiLiu_1_5.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.25, 0.85, 1, red, green, blue, 255))
                                endif
                            else
                                set r3 = r3 + 0.03
                            endif
                            if r == 0.3 then
                                call SetUnitTimeScale(c, 1.1)
                                call SetUnitAnimationByIndex(c, 9)
                            endif
                            if r > 0.45 then
                            set a = GAngle(c,td)
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                                call MoveUnit(c, move, a)
                                if r2 > 0.03 then
                                    set r2 = 0
                                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_Hashirama_MADARAa (73).mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.85, 1.15, 1))
                                else
                                    set r2 = r2 + 0.03
                                endif
                            if SR3(c, x, y) < 120 then
                                set r = rmax
                            endif    
                            endif
                            
                        endif
                        if r == rmax then
                            set check = 1
                            set r = 0.09
                            call SetUnitTimeScale(c, 1.25)
                            call SetUnitAnimationByIndex(c, 3)
                            set rmax = 0.12
                        endif
                    elseif check == 1 then
                        if r == rmax then
                        set r = 9999
                            if LoadInteger(hs, GetHandleId(c), StringHash("erza 4 tt")) == 1 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)4.mdl", x, y, 0, 1, 1.5, 1))
                            endif
                            set e = EffectSpawnColor("war3mapImported\\wos_bzhanji-black.mdl", x, y, a * bj_RADTODEG + 45, 0.45, 2.55, 135, 255, 35, 35, 255)
                            set e2 = EffectSpawnColor("war3mapImported\\wos_bzhanji-black.mdl", x, y, a * bj_RADTODEG - 45, 0.45, 2.55, 135, 255, 35, 35, 255)
                            if check2 == 0 then
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-Hit-red.mdl", x, y, a * bj_RADTODEG, 1, 3.25, 200))
                            endif
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_HakkeStart.mdx", x, y, GetRandomReal(0, 359), 1.85, 1.75, 3, 255, 255, 255, 255))
                            call MUE(c, 400, 0.3, a)
                            if check2 == 1 then
                                call BlzSetSpecialEffectColor(e, 255, 145, 85)
                                call BlzSetSpecialEffectColor(e2, 255, 145, 85)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-Hit-fire.mdl", x, y, a * bj_RADTODEG, 1, 3.25, 200))
                            elseif check2 == 3 then
                                call BlzSetSpecialEffectColor(e, 100, 255, 255)
                                call BlzSetSpecialEffectColor(e2, 100, 255, 255)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-Hit-lightning.mdl", x, y, a * bj_RADTODEG, 1, 3.25, 200))
                            elseif check2 == 2 then
                                call BlzSetSpecialEffectColor(e, 110, 155, 255)
                                call BlzSetSpecialEffectColor(e2, 110, 155, 255)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-Hit-water.mdl", x, y, a * bj_RADTODEG, 1, 3.25, 200))
                            elseif check2 == 5 then
                                call BlzSetSpecialEffectColor(e, 255, 145, 85)
                                call BlzSetSpecialEffectColor(e2, 100, 255, 255)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-Hit-fire.mdl", x, y, a * bj_RADTODEG, 1, 3, 200))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-Hit-lightning.mdl", x, y, a * bj_RADTODEG, 1, 4, 220))
                            elseif check2 == 4 or check2 == 7 then
                                call BlzSetSpecialEffectColor(e, 255, 145, 85)
                                call BlzSetSpecialEffectColor(e2, 110, 155, 255)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-Hit-fire.mdl", x, y, a * bj_RADTODEG, 1, 3, 200))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-Hit-water.mdl", x, y, a * bj_RADTODEG, 1, 4, 220))
                            elseif check2 == 6 then
                                call BlzSetSpecialEffectColor(e, 100, 255, 255)
                                call BlzSetSpecialEffectColor(e2, 110, 155, 255)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-Hit-water.mdl", x, y, a * bj_RADTODEG, 1, 3, 200))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-Hit-lightning.mdl", x, y, a * bj_RADTODEG, 1, 4, 220))
                            endif
                            call DestroyEffect(e)
                            call DestroyEffect(e2)
                            if check2 == 1 or check2 == 4 or check2 == 5 or check2 == 7 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_fire explosion.mdl", x, y, GetRandomReal(0, 359), 1, 2, 105))
                            endif
                            if check2 == 7 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_WYW-1F-jntxg (71).mdl", x, y, GetRandomReal(0, 359), 1, 0.45, 105))
                            endif
                            if check2 == 3 or check2 == 5 or check2 == 6 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_SasukeYh-41.mdl", x, y, GetRandomReal(0, 359), 1.5, 6, 75))
                            endif
                            if check2 == 2 or check2 == 4 or check2 == 6 then
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_waterexplosion.mdl", x, y, a * bj_RADTODEG, 1.1, 2, 1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdl", x, y, GetRandomReal(0, 359), 0.75, 1.75, 1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 0.65, 3, 3))
                            endif
                            set k = 0
                            call StopSpellUnit2(c)
                            call DecorRemove(c,x,y,aoe,100)
                            call MakeSound("war3mapImported\\Hero_Erza4_E02")
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    call dmgmag(c, u, dmg)
                                    if check2 > 0 then
                                        call ErzaPassive(c, u, check2)
                                    endif
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        endif
                    endif
                else
                    call StopSpellUnit2(c)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
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
        public static method ErzaR_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaR = MUI_ErzaR + 1
            set m_ErzaR[MUI_ErzaR] = this
            set c = NewC
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r = 0
            set check = 0
            set r2 = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set a = GAngle2(c, x, y) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = Erza4R_DamageAoe
            set dmg = GetHeroAgi(c, true) * (Erza4R_DamageAgiBase + (Erza4R_DamageAgiStep * (GetUnitAbilityLevel(c, Erza4R_ID) - 1)))
            set rmax = 1.5 + 0.51
            set move = 110
            set check2 = 0
            if LoadInteger(hs, GetHandleId(c), StringHash("type sword")) > 0 then
                set dmg = dmg + (dmg * LoadReal(hs, GetHandleId(c), StringHash("add spell dmg erza4 f")) )
                set check2 = LoadInteger(hs, GetHandleId(c), StringHash("type sword")) // 0 - no sword, 1 - fire, 3 - lightning, 2 - water, 5 - fire and lightning, 4 - fire and water, 6 - water and lightning, 7 - natsu and gray
            endif
            call SetUnitTimeScale(c, 1)
            call SetUnitAnimationByIndex(c, 8)
            set k = GetRandomInt(1, 2)
            if k == 1 then
                call MakeSound("war3mapImported\\Hero_Erza4_R")
            elseif k == 2 then
                call MakeSound("war3mapImported\\Hero_Erza4_R2")
            endif
            if MUI_ErzaR == 0 then
                call TimerStart( t_ErzaR, 0.03, true, function thistype.Loop_ErzaR )
            endif
        endmethod
    endstruct

    private struct Erza4TT_KS
        private static timer t_ErzaTT = CreateTimer( )
        private static integer array m_ErzaTT
        private static integer MUI_ErzaTT = -1
        framehandle array frame2_pas1 [10]
        framehandle array frame2_pas2 [10]
        framehandle array frame2_pas3 [10]
        framehandle array frame2_pas4 [10]
        framehandle array frame2_pas5 [10]
        framehandle array frame2_pas6 [10]
        unit c
        integer k2
        real r
        effect e
        effect e2
        real rmax
        private static method Loop_ErzaTT takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaTT
                set this = m_ErzaTT[i]
                if SpellBoolCaster(c) and r <= rmax and LoadInteger(hs, GetHandleId(c), StringHash("r armor active")) == 1 then
                    set r = r + 0.05
                     call BlzFrameSetValue(frame2_pas3[k2], rmax - (r + 0.1))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                else
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame2_pas1[k2], false)
                    endif
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call SaveInteger(hs, GetHandleId(c), StringHash("erza 4 tt"), 0)
                    set c = null
                    set e = null
                    set e2 = null
                    set m_ErzaTT[i] = m_ErzaTT[MUI_ErzaTT]
                    set MUI_ErzaTT = MUI_ErzaTT - 1
                    if MUI_ErzaTT == -1 then
                        call PauseTimer( t_ErzaTT )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod
        public static method ErzaTT_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaTT = MUI_ErzaTT + 1
            set m_ErzaTT[MUI_ErzaTT] = this
            set c = NewC
            set r = 0
            set rmax = Erza4TT_Duration
            call SaveInteger(hs, GetHandleId(c), StringHash("erza 4 tt"), 1)
            set e = AddSpecialEffectTarget("war3mapimported\\wos_opdef (919)2.mdx", c, "hand right")
            set e2 = AddSpecialEffectTarget("war3mapimported\\wos_opdef (919)2.mdx", c, "hand left")
            set k2 = GetPlayerId(GetOwningPlayer(c))
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
                                call BlzFrameSetTexture(frame2_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Erza4_T", 0, false)
                                set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.2225)
                                call BlzFrameSetText(frame2_pas5[k2], "|c00FFFF00" + "Benihizakura blade:" + "|r")
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
            if MUI_ErzaTT == 0 then
                call TimerStart( t_ErzaTT, 0.05, true, function thistype.Loop_ErzaTT )
            endif
        endmethod
    endstruct

    private struct Erza4T_KS
        private static timer t_ErzaT = CreateTimer( )
        private static integer array m_ErzaT
        private static integer MUI_ErzaT = -1
        unit c
        unit td
        real x
        real y
        real r2
        real r3
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
                        if r3 > 0.22 and r < 1.5 then
                            set r3 = 0
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_1feng_932_white.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 1.25, 0, 255, 45, 45, 160))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_mh_tx-ba-symh-hit11Red.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1.75, 0))
                        else
                            set r3 = r3 + 0.03
                        endif
                        if r == 0.9 then
                            call MakeSound("war3mapImported\\Hero_Erza4_T3")
                        endif
                        if r == 1.11 then
                            call MakeSound("war3mapImported\\Hero_Erza4_T02")
                            call SetUnitAnimationByIndex(c, 2)
                    
                            call SetUnitTimeScale(c, 1.25)
                            set r2 = 10
                        endif
                        if r == 1.32 then
                            call DestroyEffect(e2)
                            set e2 = null
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1.675, 0, 255, 45, 45, 130))
                        endif
                        if r == 1.5 then
                            call SetUnitTimeScale(c, 0)
                        endif
                        if r > 1.32 then
                            if SR2(c, td) > move * 1.25 then
                                call MoveUnit(c, move, a)
                                if r2 > 0.09 then
                                    set r2 = 0
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_Kamijo-6blue.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1.45, 0, 255, 25, 25, 80))
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun1.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 0.5, 3.75, 75))
                                else
                                    set r2 = r2 + 0.03
                                endif
                            else
                                set check = 1
                                set r = 0
                                set rmax = 0.03
                                call SetUnitTimeScale(c, 1)
                                call MakeSound("war3mapImported\\Hero_Erza4_T4")
                                call PosUnit(td, GetUnitX(c) + 130 * Cos(a), GetUnitY(c) + 130 * Sin(a))
                            endif
                        endif
                    elseif check == 1 then
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        if r == rmax then
                            call SetUnitAnimation(td, "death")
                            call StunUnit(c,td,Erza4T_Stun)
                            call StopSpellUnit(c)
                            call NextSound("war3mapimported\\HeroErza4_TT", 0.35)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_OPm (434)4.mdl", x, y, a * bj_RADTODEG, 2, 1.5 , 55))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_LXY_ZK_BM_Mine blasting.mdl", x, y, a * bj_RADTODEG, 1.5, 2 , 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Flamestrike Dark Blood II.mdl", x, y, a * bj_RADTODEG, 3, 3.5 , 1))
                            call Erza4TT_KS.ErzaTT_Start(c)
                            call DecorRemove(c,x,y,aoe,100)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call dmgmag(c, u, dmg)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        endif
                    endif
                else
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call DestroyEffect(e3)
                    call StopSpellUnit(c)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set check = 0
                    set td = null
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
            set u = null
            set a = GAngle(c, td) // Angle Between points
            call SetUnitFacing(c, a * bj_RADTODEG)
            set aoe = Erza4T_DamageAoe
            set dmg = GetHeroAgi(c, true) * Erza4T_DamageAgiBase
            set rmax = 5
            set move = 100
            set e = AddSpecialEffectTarget("war3mapimported\\wos_bdef (152).mdx", c, "origin")
            set e2 = EffectSpawn("war3mapimported\\wos_opdef (919).mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 0.35, 1.25, 0)
            call SetUnitTimeScale(c, 0.65)
            call SetUnitAnimationByIndex(c, 0)
            call MakeSound("war3mapImported\\Hero_Erza4_T01")
            call MakeSound("war3mapImported\\Hero_Erza4_T2")
            if MUI_ErzaT == 0 then
                call TimerStart( t_ErzaT, 0.03, true, function thistype.Loop_ErzaT )
            endif
        endmethod
    endstruct

    private struct Erza4F_KS
        private static timer t_ErzaF = CreateTimer( )
        private static integer array m_ErzaF
        private static integer MUI_ErzaF = -1
        private static framehandle array frame_pas1
        private static framehandle array frame_pas2
        private static framehandle array frame_pas3
        private static framehandle array frame_pas4
        private static framehandle array frame_pas5
        private static framehandle array frame_pas6
        unit c
        integer k
        integer k2
        integer k3
        real r5
        real r6
        real dmg
        integer check
        integer check2
        real r
        effect e
        effect e2
        real rmax
        private static method Loop_ErzaF takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_ErzaF
                set this = m_ErzaF[i]
                if SpellBoolCaster(c) and r <= rmax and LoadInteger(hs, GetHandleId(c), StringHash("r armor active")) == 1 then
                    set r = r + 0.05
                    set r = S2R( R2SW( r , 0, 3 ) )
                    call BlzFrameSetValue(frame_pas3[k2], rmax - (r + 0.1))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                    set i = i + 1
                else
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame_pas1[k2], false)
                                endif
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call BlzSetUnitBaseDamage(c, BlzGetUnitBaseDamage(c, 0) - check, 0)
                    call SaveReal(hs, GetHandleId(c), StringHash("add spell dmg erza4 f"), 0)
                    call SaveInteger(hs, GetHandleId(c), StringHash("type sword"), 0)
                    set c = null
                    set e = null
                    set e2 = null
                    set m_ErzaF[i] = m_ErzaF[MUI_ErzaF]
                    set MUI_ErzaF = MUI_ErzaF - 1
                    if MUI_ErzaF == -1 then
                        call PauseTimer( t_ErzaF )
                    endif
                    call destroy( )
                endif
            endloop
        endmethod
        public static method ErzaF_Start takes unit NewC, integer NewSword1, integer NewSword2 returns nothing
            local thistype this = thistype.create( )
            set MUI_ErzaF = MUI_ErzaF + 1
            set m_ErzaF[MUI_ErzaF] = this
            set c = NewC
            set r = 0
            set check2 = 0
            set r5 = Erza4F_AddErzaSpellDamage_1Element
            set rmax = Erza4F_Duration
            set k2 = NewSword1
            set k3 = NewSword2
            set k = 0
            if k2 == 0 and k3 == 0 then // natsu and gray
                set e = AddSpecialEffectTarget("war3mapimported\\wos_buff_fire_big2.mdx", c, "hand right")
                set e2 = AddSpecialEffectTarget("war3mapImported\\wos_GrayIce.mdx", c, "hand left")
                set check = Erza4F_AttackDamageAdd_NatsuGray
                set k = 1
                set check2 = 7
                set r5 = Erza4F_AddErzaSpellDamage_NatsuGray
                if GetRandomInt(1, 2) == 1 then
                    call MakeSound("war3mapImported\\Hero_Erza4_W(Alt)")
                else
                    call MakeSound("war3mapImported\\Hero_Erza4_W(Alt)2")
                endif
            elseif k2 == 4 and k3 == 4 then 
                set e = AddSpecialEffectTarget("war3mapimported\\wos_buff_fire_big2.mdx", c, "hand right")
                set e2 = AddSpecialEffectTarget("war3mapImported\\wos_obr08 (166).mdx", c, "hand left")
                set check = Erza4F_AttackDamageAdd_NatsuGray
                set k = 1
                set check2 = 5
                set r5 = Erza4F_AddErzaSpellDamage_NatsuGray
                if GetRandomInt(1, 2) == 1 then
                    call MakeSound("war3mapImported\\Hero_Erza_Pick1")
                else
                    call MakeSound("war3mapImported\\Hero_Erza_Pick2")
                endif
            elseif k2 == 1 and k3 == 2 then // fire and lightning
                set e = AddSpecialEffectTarget("war3mapimported\\wos_buff_fire_big2.mdx", c, "hand right")
                set e2 = AddSpecialEffectTarget("war3mapImported\\wos_obr08 (166).mdx", c, "hand left")
                set check = Erza4F_AttackDamageAdd_2Element
                set r5 = Erza4F_AddErzaSpellDamage_2Element
                set check2 = 5
            elseif k2 == 1 and k3 == 3 then // fire and water
                set check = Erza4F_AttackDamageAdd_2Element
                set e = AddSpecialEffectTarget("war3mapimported\\wos_buff_fire_big2.mdx", c, "hand right")
                set e2 = AddSpecialEffectTarget("war3mapimported\\wos_laz (167).mdx", c, "hand left")
                set r5 = Erza4F_AddErzaSpellDamage_2Element
                set check2 = 4
            elseif k2 == 2 and k3 == 3 then // lightning and water
                set e = AddSpecialEffectTarget("war3mapImported\\wos_obr08 (166).mdx", c, "hand right")
                set e2 = AddSpecialEffectTarget("war3mapimported\\wos_laz (167).mdx", c, "hand left")
                set r5 = Erza4F_AddErzaSpellDamage_2Element
                set check = Erza4F_AttackDamageAdd_2Element
                set check2 = 6
            elseif k2 == 1 and k3 == 0 then // fire sword
                set check2 = 1
                set e = AddSpecialEffectTarget("war3mapimported\\wos_buff_fire_big2.mdx", c, "hand right")
                set e2 = AddSpecialEffectTarget("war3mapimported\\wos_buff_fire_big2.mdx", c, "hand left")
                set check = Erza4F_AttackDamageAdd_1Element
            elseif k2 == 2 and k3 == 0 then // lighting sword
                set e = AddSpecialEffectTarget("war3mapImported\\wos_obr08 (166).mdx", c, "hand right")
                set e2 = AddSpecialEffectTarget("war3mapImported\\wos_obr08 (166).mdx", c, "hand left")
                set check2 = 3
                set check = Erza4F_AttackDamageAdd_1Element
            elseif k2 == 3 and k3 == 0 then // water sword
                set e = AddSpecialEffectTarget("war3mapimported\\wos_laz (167).mdx", c, "hand right")
                set e2 = AddSpecialEffectTarget("war3mapimported\\wos_laz (167).mdx", c, "hand left")
                set check = Erza4F_AttackDamageAdd_1Element
                set check2 = 2
            endif
            call SaveReal(hs, GetHandleId(c), StringHash("add spell dmg erza4 f"), r5 / 100)
            call SaveInteger(hs, GetHandleId(c), StringHash("type sword"), check2)
            if k == 0 then
                if GetRandomInt(1, 2) == 1 then
                    call MakeSound("war3mapImported\\Hero_Erza4_W")
                else
                    call MakeSound("war3mapImported\\Hero_Erza4_W 2")
                endif
            endif
            set r6 = 0.135
            set k2 = GetPlayerId(GetOwningPlayer(c))
            if frame_pas1[k2] == null then
                                set frame_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                                call BlzFrameSetAbsPoint(frame_pas1[k2], FRAMEPOINT_CENTER, 0.055+r6, 0.18)
                                call BlzFrameSetSize(frame_pas1[k2], 0.135, 0.035)
                                call BlzFrameSetTexture(frame_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                                call BlzFrameSetVisible(frame_pas1[k2], false)
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame_pas1[k2], true)
                                endif
                                set frame_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame_pas1[k2], 0, 0)
                                call BlzFrameSetAbsPoint(frame_pas2[k2], FRAMEPOINT_CENTER, 0.07+r6, 0.185)
                                call BlzFrameSetSize(frame_pas2[k2], 0.1, 0.019)
                                set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)
                                call BlzFrameSetSize(frame_pas3[k2], 0.1, 0.035)
                                call BlzFrameSetScale(frame_pas3[k2], 0.5)
                                call BlzFrameSetModel(frame_pas3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                                call BlzFrameSetAbsPoint(frame_pas3[k2], FRAMEPOINT_CENTER, 0.05+r6, 0.175)
                                call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, rmax)
                                call BlzFrameSetValue(frame_pas3[k2], rmax)
                                set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame_pas4[k2], FRAMEPOINT_CENTER, 0.005+r6, 0.18)
                                call BlzFrameSetSize(frame_pas4[k2], 0.0275, 0.0275)
                                call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Erza_W", 0, false)
                                set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07+r6, 0.185)
                                call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Elemental swords:" + "|r")
                                call BlzFrameSetScale(frame_pas5[k2], 0.9)
                                set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame_pas6[k2], FRAMEPOINT_CENTER, 0.07+r6, 0.17)
                                call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                                call BlzFrameSetScale(frame_pas6[k2], 0.9)
                            else
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame_pas1[k2], true)
                                endif
                                call BlzFrameSetValue(frame_pas3[k2], rmax)
                            endif
            call BlzSetUnitBaseDamage(c, BlzGetUnitBaseDamage(c, 0) + check, 0)
            if MUI_ErzaF == 0 then
                call TimerStart( t_ErzaF, 0.05, true, function thistype.Loop_ErzaF )
            endif
        endmethod
    endstruct

    //----------------------------Erza-----------------------------------------------
     /* Animations index:
    Base:
    0 - stand ready
    1 - slow atk 1
    2 - atk pierce
    3 - atk round + jump
    4 - slow atk 2
    5 - atk forward
    6 - same as 3 but 2 sword
    7 - strong double sword atk slow from air to earth
    8 - stand readt nitoryu
    9 - atk double sword from stand ready 8
    13 - atk noga
    14 - spin atk
    17 - move
    18 - move slow
    20 - double sword zahwat
     */ 
    function Erza4Q_Start takes unit c, unit td returns nothing
        call Erza4Q_KS.ErzaQ_Start( c, td )
    endfunction
    function Erza4F_Start takes unit c returns nothing
        local integer counter1 = 0 // 0 - natsu and gray, 1 - fire sword, 2 - lightning sword, 3 - water sword
        local integer counter2 = 0
        local unit u = null
        local integer k1 = 0
        local integer k2 = 0
        local integer k3 = 0
        local boolean shouldStart = false
        local real x = GetUnitX(c)
        local real y = GetUnitY(c)
        local group g = CreateGroup()
        local real x1 = LoadReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("fire x"))
        local real y1 = LoadReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("fire y"))
        local real x2 = LoadReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("lightning x"))
        local real y2 = LoadReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("lightning y"))
        local real x3 = LoadReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("water x"))
        local real y3 = LoadReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("water y"))
        if x1 != 0 and SR3(c, x1, y1) <= Erza1R_DamageAoe then
            if counter1 == 0 then
                set counter1 = 1
            elseif counter2 == 0 then
                set counter2 = 1
            endif
        endif
        if x2 != 0 and SR3(c, x2, y2) <= Erza3W_Aoe then
            if counter1 == 0 then
                set counter1 = 2
            elseif counter2 == 0 then
                set counter2 = 2
            endif
        endif
        if x3 != 0 and SR3(c, x3, y3) <= Erza2W_Aoe then
            if counter1 == 0 then
                set counter1 = 3
            elseif counter2 == 0 then
                set counter2 = 3
            endif
        endif
        // Zero values mean "no absorbed elements" here. Do not pass (0, 0)
        // to ErzaF_Start unless the Natsu + Gray pair was actually found.
        set shouldStart = counter1 > 0 or counter2 > 0
        call GroupEnumUnitsInRange(g, x, y, 1800, NoDecor_Cond)
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if IsUnitAlly(u, GetOwningPlayer(c)) and GetWidgetLife(u) > 0.405 and not IsUnitType(u, UNIT_TYPE_DEAD) and not IsUnitHidden(u) then
                if GetUnitTypeId(u) == Gray_ID1 or GetUnitTypeId(u) == Gray_ID2 then
                    set k1 = k1 + 1
                endif
                if GetUnitTypeId(u) == Natsu_ID then
                    set k2 = k2 + 1
                endif
                if GetUnitTypeId(u) == Laxus_ID then
                    set k3 = k3 + 1
                endif
            endif
            call GroupRemoveUnit(g, u)
        endloop
        call DestroyGroup(g)
        if LoadInteger(hs, GetHandleId(c), StringHash("type sword")) > 0 then
            // An elemental-sword instance is already active for this unit.
            // Do not add another pair of attach effects or base damage.
            set shouldStart = false
        elseif k1 > 0 and k2 > 0 then
            if IntegerCd(c,"elem gain cd",60) then 
                set counter1 = 0
                set counter2 = 0
                set shouldStart = true
            else
                set shouldStart = false
                call DisplayTimedTextToPlayer(GetOwningPlayer(c),0,0,1,"Elemental gain on cooldown")
            endif
        elseif k2 > 0 and k3 > 0 then 
            if IntegerCd(c,"elem gain cd",60) then 
                set counter1 = 4
                set counter2 = 4
                set shouldStart = true
            else
                set shouldStart = false
                call DisplayTimedTextToPlayer(GetOwningPlayer(c),0,0,1,"Elemental gain on cooldown")
            endif            
        endif
        if shouldStart then
            call Erza4F_KS.ErzaF_Start(c, counter1, counter2)
        endif
        set g = null
        set u = null
    endfunction
    function Erza4W_Start takes unit c, real x, real y returns nothing
        call Erza4W_KS.ErzaW_Start( c, x, y )
    endfunction
    function Erza4E_Start takes unit c returns nothing
        call Erza4E_KS.ErzaE_Start( c)
    endfunction
    function Erza4R_Start takes unit c,unit td returns nothing
        call Erza4R_KS.ErzaR_Start( c, td)
    endfunction
    function Erza4T_Start takes unit c, unit td returns nothing
        call Erza4T_KS.ErzaT_Start( c, td)
    endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com

