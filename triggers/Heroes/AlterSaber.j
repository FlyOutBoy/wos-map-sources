library AlterSaberSpells uses GearSystems
    globals
//--------------------------------------AlterSaber--------------------------------------------------------------
        integer AlterSaber_ID = 'H00B'
        integer AlterSaber2_ID = 'H00F'
//------------------------Combo W-----------------------------------------------------
        integer AlterSaberW_ID = 'A05F'
        integer AlterSaberComboLvlCheck =35 // at this lvl + will activate combo from base q and e
        real AlterSaberComboW_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real AlterSaberComboW_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real AlterSaberComboW_Stun = 0.7 // from 0.1 to 3.0
//------------------------Combo E(w)-----------------------------------------------------
        integer AlterSaberComboE_ID = 'A05G'
        real AlterSaberComboE_DamageAgiBase = 2 // base number x Agi damage for 1 level
        real AlterSaberComboE_DamageAgiStep = 0.5 // additional number x Agi damage for each next level
        real AlterSaberComboE_Aoe = 325
//---------------Q ability-----------------------------------------------------
        integer AlterSaberQ_ID = 'A01F'
        real AlterSaberQ_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real AlterSaberQ_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real AlterSaberRQ_DamageAttackBonus = 1.5 // additional number x atk dmg for r
        real AlterSaberQ_Damage2StaticBase = 175 // base static damage for 1 level
        real AlterSaberQ_Damage2StaticStep = 0 // additional static damage for each next level
        real AlterSaberQ_DamageAoeCheck = 250 // check to trigger atks
        real AlterSaberQ_DamageAoe = 475
        real AlterSaberQ_DamageAoe2 = 275
        integer AlterSaberQ_AtkCount = 4
        real AlterSaberQ_Range = 1200 // if no one catched and distance between cast point lower than this amount, hero will anyway run this amount
        real AlterSaberRQ_Range = 1300 // if no one catched and distance between cast point lower than this amount, hero will anyway run this amount
        real AlterSaberQ_PushRange = 350
        real AlterSaberQ_PushDuration = 0.45
//---------------W2 ability-----------------------------------------------------
        integer AlterSaberW2_ID = 'A028'
        real AlterSaberW2_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real AlterSaberW2_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real AlterSaberW2_Damage2StaticBase = 175 // base static damage for 1 level
        real AlterSaberW2_Damage2StaticStep = 0 // additional static damage for each next level
        real AlterSaberW2_Range = 1600
        real AlterSaberW2_DamageAoe = 300
//---------------E ability-----------------------------------------------------
        integer AlterSaberE_ID = 'A029'
        integer AlterSaberEBuff_ID = 'B004'
        real AlterSaberE_DamageAgiBase = 2 // base number x Agi damage for 1 level
        real AlterSaberE_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real AlterSaberE_Damage2StaticBase = 0 // base static damage for 1 level
        real AlterSaberE_Damage2StaticStep = 0 // additional static damage for each next level
        real AlterSaberE_DamageAoe = 500
        real AlterSaberE_Mag_Range = 2000
        real AlterSaberE_RangeCheck = 1200 // if distance between enemy more than this amount she will be blash magic skillshot to enemy position, if lower will cut enemy with physical damage
//---------------R ability-----------------------------------------------------
        integer AlterSaberR_ID = 'A02A'
        integer AlterSaberR_Attack = 'A02J'
        integer AlterSaberR_Armor = 'A02K'
        integer AlterSaberR_Regen0 = 'A04L'
        integer AlterSaberR_Regen1 = 'A02L'
        integer AlterSaberR_Regen2 = 'A04M'
        integer AlterSaberR_Regen3 = 'A04N'
        integer AlterSaberR_Regen4 = 'A04O'
        integer AlterSaberR_DurationBase = 12
        integer AlterSaberR_DurationStep = 2
        unit array AlterSaberR_Dummy[12]
//---------------RR ability-----------------------------------------------------
        integer AlterSaberRR_ID = 'A02D'
        real AlterSaberRR_RootDurationBase = 1.5
        real AlterSaberRR_Aoe = 900 // aoe of pundle
        real AlterSaberRR_Time = 1.5 // how long pundle exist
        real AlterSaberRR_DamageAgiBase = 4 // base damage
        real AlterSaberRR_DamageAgiStep = 0.5 // base damage
//---------------T ability-----------------------------------------------------
        integer AlterSaberT_ID = 'A02B'
        real AlterSaberT_DamageAgiBase = 10 // base number x Agi damage
        real AlterSaberT_DamageAoe = 535 // damage area
        real AlterSaberT_Range = 4000
//---------------F ability-----------------------------------------------------
        integer AlterSaberF_ID = 'A02C'
        real AlterSaberF_DamageFromCurrentManaBase = 9 // additional damage per atk from current saber mana
        real AlterSaberF_DamageFromCurrentManaMorph = 13.5 // additional damage per atk from current saber mana
//---------------G ability-----------------------------------------------------
        integer AlterSaberG_ID = 'A02F'
        real AlterSaberG_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real AlterSaberG_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real AlterSaberG_Damage2StaticBase = 150 // base static damage for 1 level
        real AlterSaberG_Damage2StaticStep = 0 // additional static damage for each next level
        real AlterSaberG_CD_Base = 18
        real AlterSaberG_CD_Step = 4
//------------------------------------------------------------------------------
    endglobals

    private struct AlterSaberQ_KS
        private static timer t_AlterSaberQ = CreateTimer( )
        private static integer array m_AlterSaberQ
        private static integer MUI_AlterSaberQ = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k
        integer k2
        integer k3
        real scale
        real r_prepare
        real r5
        real sr
        group g
        unit u
        real dmg
        real dmg2
        integer check
        integer check2
        real aoe
        real move
        real r
        real a
        real rmax
        private static method Loop_AlterSaberQ takes nothing returns nothing
            local integer this
            local integer i = 0
            local integer kc = 0
            loop
                exitwhen i > MUI_AlterSaberQ
                set this = m_AlterSaberQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if k2 == 0 then
                        call DebugUnit2(c)
                        if check == 0 then
                            if r == r_prepare - 0.03 then
                                call SetUnitTimeScale(c, 1)
                                call SetUnitAnimationByIndex(c, 1)
                                call MakeSound("war3mapimported\\Hero_AlterSaber_Q")
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.1, 1, 255, 255, 255, 115))
                            endif
                            if r < r_prepare then
                                call DebugUnit2(c)
                            endif
                            if r >= r_prepare then
                                if sr < AlterSaberQ_Range then
                                    set sr = sr + move
                                else
                                    set r = rmax - 0.03
                                endif
                                set x = GetUnitX(c) + 50 * Cos(a)
                                set y = GetUnitY(c) + 50 * Sin(a)
                                if r2 > 0.18 then
                                    set r2 = 0
                                    call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.1, 1, 255, 255, 255, 115))
                                else
                                    set r2 = r2 + 0.03
                                endif
                                call MoveUnit(c, move, a)
                                call GroupClear( g )
                                call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null or check > 0
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                        set r = rmax - 0.03
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                                if r == rmax - 0.03 then
                                    set check = 1
                                    set r = 0
                                    set rmax = 0.42
                                    call MUE(u, 100, 0.3, a)
                                    call SetUnitAnimationByIndex(c, 3)
                                endif
                            endif
                        elseif check == 1 then
                            set x = GetUnitX(c) + 85 * Cos(a)
                            set y = GetUnitY(c) + 85 * Sin(a)
                            call DebugUnit2(c)
                            if r == 0.03 then
                                call SetUnitTimeScale(c, 0.9)
                                call SetUnitAnimationByIndex(c, 3)
                                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_wfile00009065.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 0.81, 1.225, 1, 255, 255, 255, 255))
                                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_3.mdl", x, y, GetRandomReal(0, 359), 1.15, 2.35, 1, 255, 255, 255, 90))
                            endif
                            if r == 0.21 then
                                call MakeSound("war3mapimported\\Hero_AlterSaber_Q4")
                            endif
                            if r == 0.3 then
                                if k3 == 0 then
                                    call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_mei-zk_zs_db_dg18.mdl", x, y, a * bj_RADTODEG, 1, scale * 0.19, 165), 1, 255, 255, 255, 0.06)
                                    call DecorRemove(c, x, y, AlterSaberQ_DamageAoe, 20)
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c) - 70 * Cos(a), GetUnitY(c) - 70 * Sin(a), a * bj_RADTODEG , 2, 1.725, 1, 255, 255, 255, 155))
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c) - 70 * Cos(a + 0.25 * bj_DEGTORAD), GetUnitY(c) - 70 * Sin(a + 0.25 * bj_DEGTORAD), a * bj_RADTODEG + 55 , 2, 1.725, 1, 255, 255, 255, 155))
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c) - 70 * Cos(a - 0.25 * bj_DEGTORAD), GetUnitY(c) - 70 * Sin(a - 0.25 * bj_DEGTORAD), a * bj_RADTODEG - 55 , 2, 1.725, 1, 255, 255, 255, 155))
                                else
                                    call DecorRemove(c, x, y, AlterSaberQ_DamageAoe, 40)
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c) - 70 * Cos(a), GetUnitY(c) - 70 * Sin(a), a * bj_RADTODEG , 2, 2.725, 1, 255, 255, 255, 155))
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c) - 70 * Cos(a + 0.25 * bj_DEGTORAD), GetUnitY(c) - 70 * Sin(a + 0.25 * bj_DEGTORAD), a * bj_RADTODEG + 55 , 2, 2.725, 1, 255, 255, 255, 155))
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c) - 70 * Cos(a - 0.25 * bj_DEGTORAD), GetUnitY(c) - 70 * Sin(a - 0.25 * bj_DEGTORAD), a * bj_RADTODEG - 55 , 2, 2.725, 1, 255, 255, 255, 155))
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_mei-qqsfx-5.mdl", GetUnitX(c) + 100 * Cos(a), GetUnitY(c) + 100 * Sin(a), a * bj_RADTODEG + 180, 1.75, 3, 120, 255, 255, 255, 120))
                                    call MyRemoveEff(EffectSpawnColor3("war3mapImported\\wos_Efect125.mdl", GetUnitX(c) + 135 * Cos(a), GetUnitY(c) + 135 * Sin(a), a * bj_RADTODEG, 1, 1.7, 250, -90, 255, 255, 255, 125), 0.33)
                                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_rraiden-esfx-6.mdl", GetUnitX(c) + 135 * Cos(a), GetUnitY(c) + 135 * Sin(a), a * bj_RADTODEG , 1.25, 0.86, 125))
                                endif
                                call GroupClear( g )
                                call GroupEnumUnitsInRange( g , x , y , AlterSaberQ_DamageAoe , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                        call dmgphys(c, u, dmg)
                                        set kc = kc + 1
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                        call MUE(u, AlterSaberQ_PushRange, AlterSaberQ_PushDuration, a)
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                            endif
                        endif
                    elseif k2 == 1 then
                        if check == 0 then
                            call DebugUnit2(c)
                            if r == r_prepare - 0.03 then
                                call SetUnitTimeScale(c, 1)
                                call SetUnitAnimationByIndex(c, 1)
                                call MakeSound("war3mapimported\\Hero_AlterSaber_Q")
                                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_mei-qqsfx-5.mdl", GetUnitX(c) + 111 * Cos(a), GetUnitY(c) + 111 * Sin(a), a * bj_RADTODEG, 1, 1.5, 120, 255, 255, 255, 100))
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.1, 1, 255, 255, 255, 65))
                            endif
                            if r < r_prepare then
                                call DebugUnit2(c)
                            endif
                            if r >= r_prepare then
                                if sr < AlterSaberRQ_Range then
                                    set sr = sr + move
                                else
                                    set r = 99999
                                endif
                                set x = GetUnitX(c) + 50 * Cos(a)
                                set y = GetUnitY(c) + 50 * Sin(a)
                                if r2 > 0.1 then
                                    set r2 = 0
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_mei-qqsfx-5.mdl", GetUnitX(c) + 111 * Cos(a), GetUnitY(c) + 111 * Sin(a), a * bj_RADTODEG, 1, 1.5, 120, 255, 255, 255, 100))
                                    call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.1, 1, 255, 255, 255, 65))
                                else
                                    set r2 = r2 + 0.03
                                endif
                                call MoveUnit(c, move, a)
                                call GroupClear( g )
                                call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null or td != null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                        set td = u
                                        set check = 1
                                        set r = 0
                                        set r5 = 0.03
                                        set rmax = 0.45
                                        set move = 70
                                        call SetUnitAnimationByIndex(c, 3)
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                            endif
                        elseif check == 1 then
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            set a = GAngle(c, td)
                            call DebugUnit(c)
                            call SetUnitFacing(c, a * bj_RADTODEG)
                            if check2 < AlterSaberQ_AtkCount then
                                if r == 0.03 then
                                    call SetUnitTimeScale(c, 0.8)
                                    call SetUnitAnimationByIndex(c, 3)
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_wfile00009065.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 0.81, 1.225, 1, 255, 255, 255, 255))
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Eff_Ord_YeYe_Wid_KuoSan_3.mdl", x, y, GetRandomReal(0, 359), 1.15, 2.35, 1, 255, 255, 255, 90))
                                endif
                                if r == 0.21 then
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_mei-qqsfx-5.mdl", GetUnitX(c) + 111 * Cos(a), GetUnitY(c) + 111 * Sin(a), a * bj_RADTODEG, 1.35, 1.5, 120, 255, 255, 255, 45))
                                    call MakeSound("war3mapimported\\Hero_AlterSaber_Q4")
                                endif
                                if r > 0.15 and r < 0.42 and SR2(c, td) > 110 then
                                    call MoveUnit(c, move, a)
                                endif
                                if r == r5 then
                                    set k = GetRandomInt(1, 3)
                                    call SetUnitTimeScale(c, 2)
                                    if k == 1 then
                                        call SetUnitAnimationByIndex(c, 2)
                                    elseif k == 2 then
                                        call SetUnitAnimationByIndex(c, 3)
                                    elseif k == 3 then
                                        call SetUnitAnimationByIndex(c, 13)
                                    endif
                                    set check2 = check2 + 1
                                    if check2 == 0 or check2 == 6 then
                                        call MakeSound("war3mapimported\\Hero_AlterSaber_Atk1")
                                    elseif check2 == 1 then
                                        call MakeSound("war3mapimported\\Hero_AlterSaber_Atk2")
                                    elseif check2 == 2 then
                                        call MakeSound("war3mapimported\\Hero_AlterSaber_Atk3")
                                    elseif check2 == 3 then
                                        call MakeSound("war3mapimported\\Hero_AlterSaber_Atk4")
                                    elseif check2 == 4 then
                                        call MakeSound("war3mapimported\\Hero_AlterSaber_Atk5")
                                    endif
                                    set r5 = 0.42
                                    set r = 0
                                    if SR2(c, td) < 245 then
                                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_opdef (830).mdl", GetUnitX(c) - 125 * Cos(a), GetUnitY(c) - 125 * Sin(a), a * bj_RADTODEG + 35, 1.15, 2.65, 110))
                                        call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_az_jingzi_jiansheng01_e1.mdl", x, y, GetRandomReal(0, 359), 1, scale * 0.19, 165), 1, 255, 255, 255, 0.06)
                                        call DecorRemove(c, x, y, aoe, 30)
                                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c) - 70 * Cos(a), GetUnitY(c) - 70 * Sin(a), a * bj_RADTODEG , 2, 1.725, 1, 255, 255, 255, 155))
                                        call GroupClear( g )
                                        call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                                        loop
                                            set u = FirstOfGroup( g )
                                            exitwhen u == null
                                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                                call dmgatk(c, u, dmg)
                                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                            endif
                                            call GroupRemoveUnit( g , u )
                                        endloop
                                        set u = null
                                        call MUE(td, 325, 0.21, (GetRandomReal(0, 359) * bj_DEGTORAD))
                                    endif
                                endif
                            else
                                set r = 999
                            endif
                        endif
                    endif
                else
                    call SetUnitAnimation(c, "stand")
                    call StopSpellUnit(c)
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set td = null
                    set u = null
                    set m_AlterSaberQ[i] = m_AlterSaberQ[ MUI_AlterSaberQ]
                    set MUI_AlterSaberQ = MUI_AlterSaberQ - 1
                    if MUI_AlterSaberQ == -1 then
                        call PauseTimer( t_AlterSaberQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method AlterSaberQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            local real time = 0
            set MUI_AlterSaberQ = MUI_AlterSaberQ + 1
            set m_AlterSaberQ[ MUI_AlterSaberQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set k2 = 0
            set check = 0
            call DebugUnit2(c)
            set move = 75
            set sr = 0
            set r_prepare = 0.45
            set rmax = 2
            set g = CreateGroup()
            set scale = 5.75
            set k3 = 0
            set u = null
            set check2 = 0
            if LoadInteger(hs, GetHandleId(c), StringHash("mode r")) > 0 then
                set k2 = 1
            endif
            if LoadInteger(hs, GetHandleId(c), StringHash("saber w")) > 0 then
                set k3 = 1
            endif
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(AlterSaberW_ID)), 0)
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(AlterSaberE_ID)), 0)
            set a = GAngle2( c , x , y ) // Angle Between points
            set check = 0
            set aoe = AlterSaberQ_DamageAoeCheck
            set dmg = GetHeroAgi( c , true) * ( AlterSaberQ_DamageAgiBase + ( AlterSaberQ_DamageAgiStep * ( GetUnitAbilityLevel( c , AlterSaberQ_ID) - 1 ) ) )
            set dmg = dmg + AlterSaberQ_Damage2StaticBase + ( AlterSaberQ_Damage2StaticStep * ( GetUnitAbilityLevel( c , AlterSaberQ_ID) - 1 ) )
            if k2 == 1 then
                set move = 90
                set td = null
                set scale = 6.3
                set r_prepare = 0.36
                set aoe = AlterSaberQ_DamageAoe2
                call SetUnitAnimationByIndex( c , 4)
                call SetUnitTimeScale(c, 1.5)
                call MakeSound("war3mapimported\\Hero_AlterSaber_Q6")
                call MakeSound("war3mapimported\\Hero_AlterSaber_Q5")
                set dmg = GetHeroAgi( c , true) * ( AlterSaberQ_DamageAgiBase + ( AlterSaberQ_DamageAgiStep * ( GetUnitAbilityLevel( c , AlterSaberQ_ID) - 1 ) ) )
                set dmg = dmg + GetAttack(c) * AlterSaberRQ_DamageAttackBonus
                set dmg = dmg / AlterSaberQ_AtkCount
            elseif k2 == 0 then
                call SetUnitAnimationByIndex( c , 4)
                call MakeSound("war3mapimported\\Hero_AlterSaber_Q2")
                call SetUnitTimeScale( c , 1)
                if k3 == 1 then
                    set dmg2 = GetHeroAgi( c , true) * ( AlterSaberG_DamageAgiBase + ( AlterSaberG_DamageAgiStep * ( GetLevelPas3Check(c)-1 ) ) )
                    set dmg2 = dmg2 + AlterSaberG_Damage2StaticBase + ( AlterSaberG_Damage2StaticStep * ( GetLevelPas3Check(c)-1))
                    set dmg = dmg + dmg2 * 0.75                    
                    call SaveInteger(hs,GetHandleId(c),StringHash("saber w"),0)
call SaveInteger(hs,GetHandleId(c),StringHash("saber w cd"),1)
set time = AlterSaberG_CD_Base-((GetLevelPas3Check(c)-1)*AlterSaberG_CD_Step)
 call FakeCD_Start(c,AlterSaberG_ID,time,StringHash("saber w cd"),0)
call MyFlush(GetHandleId(c),StringHash("saber w cd"),0,time)
                
                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_wfile00009065.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 0.81, 1.225, 1, 255, 255, 255, 255))
                endif
            endif
            call SetUnitFacing( c , a * bj_RADTODEG)
            set r5 = 0
            if MUI_AlterSaberQ == 0 then
                call TimerStart( t_AlterSaberQ, 0.03, true, function thistype.Loop_AlterSaberQ)
            endif
        endmethod
    endstruct

    private struct AlterSaberW_KS
        private static timer t_AlterSaberW = CreateTimer( )
        private static integer array m_AlterSaberW
        private static integer MUI_AlterSaberW = -1
        unit c
        effect e
        private static method Loop_AlterSaberW takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AlterSaberW
                set this = m_AlterSaberW[i]
                if SpellBoolCaster(c) and c != null then
                if GetHeroLevel(c)>= 12 then 
                    if LoadInteger(hs, GetHandleId(c), StringHash("saber w")) == 0 then
                        if e != null then
                            call DestroyEffect(e)
                            set e = null
                        endif
                        if LoadInteger(hs, GetHandleId(c), StringHash("saber w cd")) == 0 then
                            call SaveInteger(hs, GetHandleId(c), StringHash("saber w"), 1)
                            if CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false then
                                call MakeSound("war3mapimported\\Hero_AlterSaber_W")
                            endif
                            set e = AddSpecialEffectTarget("war3mapImported\\wos_saber_attach.mdl", c, "weapon")
                        endif
                        
                        
                    endif
                 if LoadInteger(hs, GetHandleId(c), StringHash("saber w trg")) == 1 then
                        call SaveInteger(hs, GetHandleId(c), StringHash("saber w trg"), 0)
                        call DestroyEffect(e)
                        set e = null 
                            set e = AddSpecialEffectTarget("war3mapImported\\wos_saber_attach.mdl", c, "weapon")
                        endif
                 endif   
                else
                    call DestroyEffect(e)
                    set c = null
                    set e = null
                    set m_AlterSaberW[i] = m_AlterSaberW[ MUI_AlterSaberW]
                    set MUI_AlterSaberW = MUI_AlterSaberW - 1
                    if MUI_AlterSaberW == -1 then
                        call PauseTimer( t_AlterSaberW)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method AlterSaberW_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_AlterSaberW = MUI_AlterSaberW + 1
            set m_AlterSaberW[ MUI_AlterSaberW] = this
            set c = NewC
            set e = null
            if MUI_AlterSaberW == 0 then
                call TimerStart( t_AlterSaberW, 0.25, true, function thistype.Loop_AlterSaberW)
            endif
        endmethod
    endstruct

    private struct AlterSaberW2_KS
        private static timer t_AlterSaberW2 = CreateTimer( )
        private static integer array m_AlterSaberW2
        private static integer MUI_AlterSaberW2 = -1
        unit c
        real x
        real y
        real r2
        real r6
        real sr
        group g
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
        private static method Loop_AlterSaberW2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AlterSaberW2
                set this = m_AlterSaberW2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if r < 0.45 then
                        call DebugUnit2(c)
                    endif
                    if r == 0.45 then
                        call MakeSound("war3mapimported\\Hero_AlterSaber_T5")
                        set r2 = 10
                        call StopSpellUnit2(c)
                        set e2 = EffectSpawn3("war3mapImported\\wos_Efect125.mdl", GetUnitX(c) + 215 * Cos(a), GetUnitY(c) + 215 * Sin(a), a * bj_RADTODEG, 2, 0.95, 125, -90)
                        set e = EffectSpawn("war3mapImported\\wos_az_chongci-red%2E.mdl", GetUnitX(c) + 125 * Cos(a), GetUnitY(c) + 125 * Sin(a), a * bj_RADTODEG, 2, 2.5, 1)
                        set e3 = EffectSpawn("war3mapImported\\wos_mei-qqsfx-5.mdl", GetUnitX(c) + 125 * Cos(a), GetUnitY(c) + 125 * Sin(a), a * bj_RADTODEG + 180, 2, 1.3, 150)
                    endif
                    if r > 0.45 then
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        call MoveEff(e, move, a)
                        call MoveEff(e2, move, a)
                        call MoveEff(e3, move, a)
                        if sr < AlterSaberW2_Range then
                            set sr = sr + move
                        else
                            set r = 9999
                        endif
                        if r2 > 0.02 then
                            set r2 = 0
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x + 100 * Cos(a), y + 100 * Sin(a) , aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    set r = rmax
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        else
                            set r2 = r2 + 0.03
                        endif
                        if r6 >= 0.09 then
                            set r6 = 0
                            call BlzPlaySpecialEffect(e3, ANIM_TYPE_DEATH)
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_mei-qqsfx-5.mdl", x , y, a * bj_RADTODEG, 1.75, 1, 130, 255, 255, 255, 100))
                            call VisionTimed(GetOwningPlayer(c), x , y, 750, 2)
                            call MyRemoveEff(EffectSpawnColor3("war3mapImported\\wos_Efect125.mdl", x , y, a * bj_RADTODEG + 180, 1.75, 0.9, 220, -90, 255, 255, 255, 125), 0.21)
                        else
                            set r6 = r6 + 0.03
                        endif
                    endif
                else
                    set x = GetEffX(e)
                    set y = GetEffY(e)
                    call DecorRemove(c, x, y, aoe * 1.8, 50)
                    call VisionTimed(GetOwningPlayer(c), x , y, aoe * 1.8, 2)
                    call MakeSound("war3mapimported\\Hero_AlterSaber_W5")
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_exceffect4.mdl", x , y , GetRandomReal(0, 359), 2.5, 4, 0))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_ldeff (41).mdl", x , y , GetRandomReal(0, 359), 1.25, 2.6, 0))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_afb (2080).mdl", x , y, a * bj_RADTODEG, 0.7, 1.6, 1))
                    call GroupClear(g)
                    call GroupEnumUnitsInRange(g, x, y , aoe * 1.7, NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                            call dmgmag(c, u, dmg)
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call DestroyEffect(e3)
                    if r < 0.42 then
                        call StopSpellUnit2(c)
                    endif
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set u = null
                    set m_AlterSaberW2[i] = m_AlterSaberW2[ MUI_AlterSaberW2]
                    set MUI_AlterSaberW2 = MUI_AlterSaberW2 - 1
                    if MUI_AlterSaberW2 == -1 then
                        call PauseTimer( t_AlterSaberW2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method AlterSaberW2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_AlterSaberW2 = MUI_AlterSaberW2 + 1
            set m_AlterSaberW2[ MUI_AlterSaberW2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            call DebugUnit2(c)
            set sr = 0
            set rmax = 1.75
            set move = 130
            set g = CreateGroup()
            set u = null
            set a = GAngle2( c , x, y ) // Angle Between points
            set aoe = AlterSaberW2_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( AlterSaberW2_DamageAgiBase + ( AlterSaberW2_DamageAgiStep * ( GetUnitAbilityLevel( c , AlterSaberW_ID) - 1 ) ) )
            set dmg = dmg + AlterSaberW2_Damage2StaticBase + ( AlterSaberW2_Damage2StaticStep * ( GetUnitAbilityLevel( c , AlterSaberW_ID) - 1 ) )
            call SetUnitAnimationByIndex( c , 2)
            call SetUnitTimeScale(c, 0.4)
            call MakeSound("war3mapimported\\Hero_AlterSaber_W4")
            call MakeSound("war3mapimported\\Hero_AlterSaber_W6")
            call SetUnitFacing( c , a * bj_RADTODEG)
            if MUI_AlterSaberW2 == 0 then
                call TimerStart( t_AlterSaberW2, 0.03, true, function thistype.Loop_AlterSaberW2)
            endif
        endmethod
    endstruct

    private struct AlterSaberE_KS
        private static timer t_AlterSaberE = CreateTimer( )
        private static integer array m_AlterSaberE
        private static integer MUI_AlterSaberE = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k3
        real scale
        real r6
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
        private static method Loop_AlterSaberE takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AlterSaberE
                set this = m_AlterSaberE[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit(c)
                    if k3 == 1 then
                        if r == 0.33 then
                            call SetUnitAnimationByIndex( c , 3)
                            call SetUnitTimeScale(c, 0.55)
                        endif
                        if r == 0.69 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-wsfx-2.mdl", GetUnitX(c) + 165 * Cos(a), GetUnitY(c) + 165 * Sin(a), GetRandomReal(0, 359), 0.5, 2, 185))
                            call MakeSound("war3mapimported\\Hero_AlterSaber_E5")
                        endif
                        if r == 0.78 then
                            set x = GetUnitX(c) + 55 * Cos(a)
                            set y = GetUnitY(c) + 55 * Sin(a)
                            call SetUnitTimeScale(c, 0.3)
                            call DestroyEffect(e)
                            set r2 = 0
                            set scale = 2
                            set move = 200
                            call EffectSpawn2("war3mapImported\\wos_Laser_BlueYellow2.mdl", x, y, a * bj_RADTODEG, 1.5, 0.18, 150, 0.45)
                        endif
                        if r > 0.78 and r < rmax - 0.03 and r2 < AlterSaberE_Mag_Range then
                            set scale = scale + 0.08
                            set r2 = r2 + move
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x + r2 * Cos(a), y + r2 * Sin(a), aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u, g2) == false then
                                    call dmgmag(c, u, dmg)
                                    call GroupAddUnit(g2, u)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set r2 = r2 + move
                            if r6 >= 0.0 then
                                set r6 = 0
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-qqsfx-5.mdl", x + r2 * Cos(a), y + r2 * Sin(a), a * bj_RADTODEG, 1.25, scale / 1.15, 120))
                                call VisionTimed(GetOwningPlayer(c), x + r2 * Cos(a), y + r2 * Sin(a), 850, 2)
                            else
                                set r6 = r6 + 0.03
                            endif
                        endif
                    else
                        if r == 0.42 then
                            call SetUnitAnimationByIndex( c , 3)
                            call SetUnitTimeScale(c, 0.85)
                            set move = 90
                        endif
                        if r == 0.6 then
                            call MakeSound("war3mapimported\\Hero_AlterSaber_E5")
                        endif
                        if r > 0.6 then
                            if r2 > 0.18 then
                                set r2 = 0
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.1, 1, 255, 255, 255, 115))
                            else
                                set r2 = r2 + 0.03
                            endif
                            if SR2(c, td) > 180 then
                                set a = GAngle(c, td)
                                call MoveUnit(c, move, a)
                            else
                                set r = 999999
                                set x = GetUnitX(td)
                                set y = GetUnitY(td)
                                call GroupClear(g)
                                call StopSpellUnit(c)
                                call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u, g2) == false then
                                        call dmgphys(c, u, dmg)
                                        call GroupAddUnit(g2, u)
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                                call MakeSound("war3mapimported\\Hero_AlterSaber_E4")
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-qqsfx-5.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.25, 2.15, 120))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_rraiden-esfx-6.mdl", GetUnitX(td) - 235 * Cos(a), GetUnitY(td) - 235 * Sin(a), a * bj_RADTODEG , 1.25, 0.9, 125))
                            endif
                        endif
                    endif
                else
                    call DestroyEffect(e)
                    call SetUnitAnimation(c, "stand")
                    call StopSpellUnit(c)
                    call DestroyGroup( g )
                    set g = null
                    call DestroyGroup( g2 )
                    set g2 = null
                    set c = null
                    set e = null
                    set u = null
                    set m_AlterSaberE[i] = m_AlterSaberE[ MUI_AlterSaberE]
                    set MUI_AlterSaberE = MUI_AlterSaberE - 1
                    if MUI_AlterSaberE == -1 then
                        call PauseTimer( t_AlterSaberE)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method AlterSaberE_Start takes unit NewC, unit NewTd, integer NewCheck returns nothing
            local thistype this = thistype.create( )
            set MUI_AlterSaberE = MUI_AlterSaberE + 1
            set m_AlterSaberE[ MUI_AlterSaberE] = this
            set c = NewC
            set td = NewTd
            set k3 = NewCheck
            set r = 0
            set r2 = 10
            call DebugUnit(c)
            set rmax = 1.2
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle( c , td ) // Angle Between points
            set e = AddSpecialEffectTarget("war3mapImported\\wos_HSglb.mdl", c, "weapon")
            set aoe = AlterSaberE_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( AlterSaberE_DamageAgiBase + ( AlterSaberE_DamageAgiStep * ( GetUnitAbilityLevel( c , AlterSaberE_ID) - 1 ) ) )
            set dmg = dmg + AlterSaberE_Damage2StaticBase + ( AlterSaberE_Damage2StaticStep * ( GetUnitAbilityLevel( c , AlterSaberE_ID) - 1 ) )
            call SetUnitAnimationByIndex( c , 4)
            call SetUnitTimeScale(c, 1.5)            
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(AlterSaberW_ID)), 0)
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(AlterSaberE_ID)), 0)
            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_wfile00009065.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 0.5, 1.1, 1, 255, 255, 255, 255))
            if k3 == 1 then
                call MakeSound("war3mapimported\\Hero_AlterSaber_E")
            else
                call MakeSound("war3mapimported\\Hero_AlterSaber_E2")
            endif
            call MakeSound("war3mapimported\\Hero_AlterSaber_E3")
            call SetUnitFacing( c , a * bj_RADTODEG)
            if MUI_AlterSaberE == 0 then
                call TimerStart( t_AlterSaberE, 0.03, true, function thistype.Loop_AlterSaberE)
            endif
        endmethod
    endstruct

    private struct AlterSaberComboW_KS
        private static timer t_AlterSaberComboW = CreateTimer( )
        private static integer array m_AlterSaberComboW
        private static integer MUI_AlterSaberComboW = -1
        unit c
        unit td
        real r2
        real r4
        real r5
        real r6
        real dmg
        integer check
        real move
        real r
        real a
        real rmax
        private static method Loop_AlterSaberComboW takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AlterSaberComboW
                set this = m_AlterSaberComboW[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    if check == 0 then
                        call DebugUnit2(c)
                        if r == 0.03 then
                            call SetUnitAnimationByIndex( c , 3)
                            call SetUnitTimeScale(c, 0.85)
                            set move = 60
                            call MakeSound("war3mapimported\\Hero_AlterSaber_E5")
                        endif
                        if r > 0.45 then
                            if r2 > 0.11 then
                                set r2 = 0
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.1, 1, 255, 255, 255, 115))
                            else
                                set r2 = r2 + 0.03
                            endif
                            if SR2(c, td) > 180 then
                                set a = GAngle(c, td)
                                call MoveUnit(c, move, a)
                            else
                                set r = 0
                                set check = 1
                                set rmax = 1.5
                                set r5 = 1000
                                set r4 = 0
                                set r6 = r5 / 50
                                call SetUnitAbilityLevel(c,AlterSaberComboE_ID,GetUnitAbilityLevel(c,AlterSaberW_ID))
                                call StunUnit(c, td, AlterSaberComboW_Stun)
                                call SaveInteger(hs, GetHandleId(c), StringHash("height td"), 0)
                                call MakeSound("war3mapimported\\Hero_AlterSaber_E4")
                                call dmgphys(c, td, dmg)
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-qqsfx-5.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.25, 2.15, 120))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_rraiden-esfx-6.mdl", GetUnitX(td) - 235 * Cos(a), GetUnitY(td) - 235 * Sin(a), a * bj_RADTODEG , 1.25, 0.9, 125))
                            endif
                        endif
                    elseif check == 1 then
                        if LoadInteger(hs, GetHandleId(c), StringHash("height td")) == 1 then
                            set r = 9999
                        endif
                        if r == 0.09 then 
                        call StopSpellUnit2(c)
                        endif
                        if r == 0.33 then 
                         if GetHeroLevel(c) >= AlterSaberComboLvlCheck  then
                                call SwapAbility(c, 1, AlterSaberComboE_ID, AlterSaberW_ID)
                                endif
                        endif
                        call MoveUnit(td, r6, a)
                        set r4 = r4 + r6
                        call SetFly(td, Parabola(550, r5, r4))
                    endif
                else
                    if check == 0 or (check == 1 and r< 0.09) then
                        call StopSpellUnit2(c)
                    else
                        if LoadInteger(hs, GetHandleId(c), StringHash("height td")) == 0 then
                            call SetFly(td, 0)
                        endif
                    endif                                        
                    call SaveInteger(hs,GetHandleId(c),StringHash("combo w"),0)
                    set c = null
                    set m_AlterSaberComboW[i] = m_AlterSaberComboW[ MUI_AlterSaberComboW]
                    set MUI_AlterSaberComboW = MUI_AlterSaberComboW - 1
                    if MUI_AlterSaberComboW == -1 then
                        call PauseTimer( t_AlterSaberComboW)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method AlterSaberComboW_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_AlterSaberComboW = MUI_AlterSaberComboW + 1
            set m_AlterSaberComboW[ MUI_AlterSaberComboW] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set r2 = 10
            call StartSpellUnit2(c)
            set check = 0
            set rmax = 2.4
            set a = GAngle( c , td ) // Angle Between points
            set dmg = GetHeroAgi( c , true) * ( AlterSaberComboW_DamageAgiBase + ( AlterSaberComboW_DamageAgiStep * ( GetUnitAbilityLevel( c , AlterSaberW_ID) - 1 ) ) )
            set dmg = dmg + 100
            call SetUnitAnimationByIndex( c , 4)
            call SetUnitTimeScale(c, 1.5)
            call SaveInteger(hs,GetHandleId(c),StringHash("combo w"),1)
            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_wfile00009065.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 0.5, 1.1, 1, 255, 255, 255, 255))
            call MakeSound("war3mapimported\\Hero_AlterSaber_Pick5")
            call MakeSound("war3mapimported\\Hero_AlterSaber_E3")
            call SetUnitFacing( c , a * bj_RADTODEG)
            if MUI_AlterSaberComboW == 0 then
                call TimerStart( t_AlterSaberComboW, 0.03, true, function thistype.Loop_AlterSaberComboW)
            endif
        endmethod
    endstruct

    private struct AlterSaberComboE_KS
        private static timer t_AlterSaberComboE = CreateTimer( )
        private static integer array m_AlterSaberComboE
        private static integer MUI_AlterSaberComboE = -1
        unit c
        unit td
        real x
        real y
        real r2
        real r5
        real r6
        group g
        unit u
        real dmg
        real aoe
        real r
        effect e
        real a
        real rmax
        private static method Loop_AlterSaberComboE takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AlterSaberComboE
                set this = m_AlterSaberComboE[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    call DebugUnit2(td)
                    if r == 0.3 then
                        call SetUnitAnimationByIndex( c , 3)
                        call SetUnitTimeScale(c, 0.85)
                        set r5 = GetUnitFlyHeight(c) / 10
                        set r6 = GetUnitFlyHeight(td) / 10
                        call DestroyEffect(EffectSpawn3("war3mapImported\\wos_mei-qqsfx-5.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.25, 2.15, GetUnitFlyHeight(td), -90))
                        set e = EffectSpawn3("war3mapImported\\wos_rraiden-esfx-6.mdl", GetUnitX(td) - 235 * Cos(a), GetUnitY(td) - 235 * Sin(a), a * bj_RADTODEG + 0 , 1.25, 0.9, GetUnitFlyHeight(td), -90)
                        call BlzSetSpecialEffectRoll(e, -90 * bj_DEGTORAD)
                        call DestroyEffect(e)
                    endif
                    if r > 0.3 then
                        if r2 > 0.18 then
                            set r2 = 0
                       //         call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.1, 1, 255, 255, 255, 115))
                        else
                            set r2 = r2 + 0.03
                        endif
                        call SetFly(c, GetUnitFlyHeight(c) - r5)
                        call SetFly(td, GetUnitFlyHeight(td) - r6)
                    endif
                else
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call GroupClear(g)
                    call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                            call dmgatk(c, u, dmg)
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop
                    call MakeSound("war3mapimported\\Hero_AlterSaber_E4")
                    call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_opdef (100)11.mdl", x, y, GetRandomReal(0, 359), 1, 0.16, 0), 0.35, 255, 255, 255, 0.75)
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_exceffect4.mdl", x , y , GetRandomReal(0, 359), 1.5, 5, 0))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_ldeff (41).mdl", x , y , GetRandomReal(0, 359), 1, 2.75, 0))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_afb (2080).mdl", x , y, a * bj_RADTODEG, 0.4, 1.7, 1))
                    call SaveInteger(hs, GetHandleId(c), StringHash("height td"), 0)
                    call SaveInteger(hs,GetHandleId(c),StringHash("combo w"),0)
                    call DestroyEffect(e)
                    call DestroyGroup(g)
                    call SetUnitAnimation(c, "stand")
                    call StopSpellUnit2(c)
                    call StopSpellUnit2(td)
                    call SetFly(c, 0)
                    call SetFly(td, 0)
                    set c = null
                    set td = null
                    set e = null
                    set g = null
                    set u = null
                    set m_AlterSaberComboE[i] = m_AlterSaberComboE[ MUI_AlterSaberComboE]
                    set MUI_AlterSaberComboE = MUI_AlterSaberComboE - 1
                    if MUI_AlterSaberComboE == -1 then
                        call PauseTimer( t_AlterSaberComboE)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method AlterSaberComboE_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_AlterSaberComboE = MUI_AlterSaberComboE + 1
            set m_AlterSaberComboE[ MUI_AlterSaberComboE] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set r2 = 10
            call StartSpellUnit2(c)
            call StartSpellUnit2(td)
            set rmax = 0.6
            set aoe = AlterSaberComboE_Aoe
            set a = GAngle( c , td ) // Angle Between points
            set dmg = GetHeroAgi( c , true) * ( AlterSaberComboE_DamageAgiBase + ( AlterSaberComboE_DamageAgiStep * ( GetUnitAbilityLevel( c , AlterSaberE_ID) - 1 ) ) )
            call SetUnitAnimationByIndex( c , 4)
            call SetUnitTimeScale(c, 1.5)
            call BlinkEff(c)
            set g = CreateGroup()
            set u = null            
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(AlterSaberW_ID)), 1)
            call PosUnit(c, GetUnitX(td) - 100 * Cos(a), GetUnitY(td) - 100 * Sin(a))
            call SetFly(c, GetUnitFlyHeight(td))
            call BlinkEff(c)
            call MakeSound("war3mapimported\\Hero_AlterSaber_R2")
            call SetUnitFacing( c , a * bj_RADTODEG)
            call SaveInteger(hs, GetHandleId(c), StringHash("height td"), 1)
            if MUI_AlterSaberComboE == 0 then
                call TimerStart( t_AlterSaberComboE, 0.03, true, function thistype.Loop_AlterSaberComboE)
            endif
        endmethod
    endstruct

    private struct AlterSaberR_KS
        private static timer t_AlterSaberR = CreateTimer( )
        private static integer array m_AlterSaberR
        private static integer MUI_AlterSaberR = -1
        unit c
        real x
        real y
        framehandle array frame_pas1 [10]
        framehandle array frame_pas2 [10]
        framehandle array frame_pas3 [10]
        framehandle array frame_pas4 [10]
        framehandle array frame_pas5 [10]
        framehandle array frame_pas6 [10]
        integer k2
        integer check
        real r
        effect e
        effect e2
        effect e3
        real rmax
        private static method Loop_AlterSaberR takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AlterSaberR
                set this = m_AlterSaberR[i]
                if SpellBoolCaster(c) and r <= rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false then
                    if check == 0 then
                        call DebugUnit2(c)
                        set r = r + 0.03
                        set r = S2R( R2SW( r , 0, 3 ) )
                        if r == 0.75 then
                        if GetUnitAbilityLevel(c,AlterSaberR_ID) >= 3 then 
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), AlterSaberR_ID, false)
                            call UnitAddAbility(c, AlterSaberRR_ID)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), AlterSaberRR_ID, true)
                            call SetUnitAbilityLevel(c, AlterSaberRR_ID, GetUnitAbilityLevel(c, AlterSaberR_ID))
                            endif
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), AlterSaberW_ID, false)
                            call UnitAddAbility(c, AlterSaberW2_ID)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), AlterSaberW2_ID, true)
                            call SetUnitAbilityLevel(c, AlterSaberW2_ID, GetUnitAbilityLevel(c, AlterSaberR_ID))
                            call DecorRemove(c, x, y, 800, 50)
                            call VisionTimed(GetOwningPlayer(c), x , y, 1500, 2)
                            call MakeSound("war3mapimported\\Hero_AlterSaber_W3")
                            call BlzSetUnitSkin(c, AlterSaber2_ID)
                            call FixAura(c)
                            call ScaleEffDummy(e, 0.5, 3, 6)
                            call ScaleEffDummy(e2, 0.5, 1, 2.5)
                            call ColorEffDummy3(e, 0, 255, 255, 255, 0.6)
                            call ColorEffDummy3(e2, 0, 255, 255, 255, 0.35)
                            call StopSpellUnit2(c)
                            set e3 = AddSpecialEffectTarget("war3mapImported\\wos_BDEF (2313).mdx", c, "origin")
                            set check = 1
                            set r = 0
                            if AlterSaberR_Dummy[k2] == null then
                                set AlterSaberR_Dummy[k2] = UnitSpawn0(Player(k2), DummyR_ID, GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster), 1, 1, 1, 1)
                            endif
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
                                call BlzFrameSetSize(frame_pas4[k2], 0.03, 0.03)
                                call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_AlterSaber_R", 0, false)
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
                            call DestroyEffect(EffectSpawn3("war3mapImported\\wos_mei-qqsfx-5.mdl", GetUnitX(c), GetUnitY(c), 1, 0.85, 4, 1, -90))
                         //   call SaveInteger(hs, GetHandleId(c), StringHash("saber w"), 0)
                          //  call SaveInteger(hs, GetHandleId(c), StringHash("saber w cd"), 0)
                            call SaveInteger(hs, GetHandleId(c), StringHash("saber w trg"), 1)
                        endif
                    elseif check == 1 then
                        if IsUnitPaused(c) == false then
                            set r = r + 0.03
                        endif
                        set r = S2R( R2SW( r , 0, 3 ) )
                        call BlzFrameSetValue(frame_pas3[k2], rmax - (r + 0.1))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                    endif
                else
                    if AlterSaberR_Dummy[k2] != null then
                        call RemoveUnit(AlterSaberR_Dummy[k2])
                        set AlterSaberR_Dummy[k2] = null
                    endif                    
                    call UnitRemoveAbility(c, AlterSaberR_Attack)
                    call UnitRemoveAbility(c, AlterSaberR_Armor)
                    call UnitRemoveAbility(c, AlterSaberR_Regen0)
                    call UnitRemoveAbility(c, AlterSaberR_Regen1)
                    call UnitRemoveAbility(c, AlterSaberR_Regen2)
                    call UnitRemoveAbility(c, AlterSaberR_Regen3)
                    call UnitRemoveAbility(c, AlterSaberR_Regen4)
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(AlterSaberW_ID)), 0)
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(AlterSaberE_ID)), 0)
                   // call SaveInteger(hs, GetHandleId(c), StringHash("saber w"), 0)
                   // call SaveInteger(hs, GetHandleId(c), StringHash("saber w cd"), 0)
                    call SaveInteger(hs, GetHandleId(c), StringHash("saber w trg"), 1)
                    call DestroyEffect(EffectSpawn3("war3mapImported\\wos_mei-qqsfx-5.mdl", GetUnitX(c), GetUnitY(c), 1, 1.25, 3, 50, -90))
                    call BlzSetUnitSkin(c, AlterSaber_ID)
                    call FixAura(c)
                    call BlzSetAbilityIcon(AlterSaber_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_AlterSaber_Icon.blp")
                    call BlzSetAbilityIcon(AlterSaberQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_AlterSaber_Q.blp")
                    call BlzSetAbilityIcon(AlterSaberR_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_AlterSaber_R.blp")
                    call SaveInteger(hs, GetHandleId(c), StringHash("mode r"), 0)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), AlterSaberR_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), AlterSaberRR_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), AlterSaberW_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), AlterSaberW2_ID, false)
                    call EUTU2_3(e, 0.3, 0, c)
                    if check == 0 then
                        call StopSpellUnit2(c)
                        call DestroyEffect(e2)
                    else
                        call DestroyEffect(e3)
                    endif
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame_pas1[k2], false)
                    endif
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set m_AlterSaberR[i] = m_AlterSaberR[ MUI_AlterSaberR]
                    set MUI_AlterSaberR = MUI_AlterSaberR - 1
                    if MUI_AlterSaberR == -1 then
                        call PauseTimer( t_AlterSaberR)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method AlterSaberR_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_AlterSaberR = MUI_AlterSaberR + 1
            set m_AlterSaberR[ MUI_AlterSaberR] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            call StartSpellUnit2(c)
            set check = 0
            set r = 0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            call SaveInteger(hs, GetHandleId(c), StringHash("mode r"), 1)
            set rmax = AlterSaberR_DurationBase + (AlterSaberR_DurationStep * (GetUnitAbilityLevel(c, AlterSaberR_ID) - 1))
            call MakeSound("war3mapimported\\Hero_AlterSaber_R")
            if GetUnitAbilityLevel(c,AlterSaberR_ID) >= 5 then 
            call BlzStartUnitAbilityCooldown(c, AlterSaberQ_ID, 0.01)
            endif
            set e = EffectSpawn("war3mapImported\\wos_LimitIndra-ORA.mdl", x, y, 1, 1, 3, 1)
            call BlzSetSpecialEffectAlpha(e, 0)
            call ColorEffDummy4(e, 0., 255, 255, 255, 0.5)
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(AlterSaberW_ID)), 1)
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(AlterSaberE_ID)), 1)
            call UnitAddAbility(c, AlterSaberR_Attack)
            call UnitAddAbility(c, AlterSaberR_Armor)
            if GetUnitAbilityLevel(c, AlterSaberR_ID) == 1 then
                call UnitAddAbility(c, AlterSaberR_Regen0)
            elseif GetUnitAbilityLevel(c, AlterSaberR_ID) == 2 then
                call UnitAddAbility(c, AlterSaberR_Regen1)
            elseif GetUnitAbilityLevel(c, AlterSaberR_ID) == 3 then
                call UnitAddAbility(c, AlterSaberR_Regen2)
            elseif GetUnitAbilityLevel(c, AlterSaberR_ID) == 4 then
                call UnitAddAbility(c, AlterSaberR_Regen3)
            elseif GetUnitAbilityLevel(c, AlterSaberR_ID) == 5 then
                call UnitAddAbility(c, AlterSaberR_Regen4)
            endif
            call SetUnitAbilityLevel(c, AlterSaberR_Attack, GetUnitAbilityLevel(c, AlterSaberR_ID))
            call SetUnitAbilityLevel(c, AlterSaberR_Armor, GetUnitAbilityLevel(c, AlterSaberR_ID))
            set e2 = EffectSpawn("war3mapImported\\wos_altersabermorph.mdl", x, y, 0, 1.25, 1.25, 1)
            call BlzPlaySpecialEffect(e2, ANIM_TYPE_BIRTH)
            call SetUnitAnimationByIndex(c, 4)
            call BlzSetAbilityIcon(AlterSaber_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_AlterSaber_Icon2.blp")
            call BlzSetAbilityIcon(AlterSaberQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_AlterSaber_RQ.blp")            
            if MUI_AlterSaberR == 0 then
                call TimerStart( t_AlterSaberR, 0.03, true, function thistype.Loop_AlterSaberR)
            endif
        endmethod
    endstruct

    private struct AlterSaberRR_KS
        private static timer t_AlterSaberRR = CreateTimer( )
        private static integer array m_AlterSaberRR
        private static integer MUI_AlterSaberRR = -1
        unit c
        real x
        real y
        group g
        group g2
        unit u
        real dmg
        real aoe
        real r
        effect e
        effect e2
        real rmax
        private static method Loop_AlterSaberRR takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AlterSaberRR
                set this = m_AlterSaberRR[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.5
                    set r = S2R( R2SW( r , 0, 3 ) )
                    call GroupClear(g)
                    call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u, g2) == false then
                            call NextDmg(c, u, dmg, 1, 0.5)
                            call RootUnit(c, u, AlterSaberRR_RootDurationBase)
                            set e2 = EffectSpawn("war3mapImported\\wos_altersabermorph.mdl", GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359), 1.25, 0.65, 1)
                            call BlzPlaySpecialEffect(e2, ANIM_TYPE_ATTACK)
                            call AnimDummyEff(e2, AlterSaberRR_RootDurationBase, 2)
                            call EUTU3(e2, AlterSaberRR_RootDurationBase , 1, u, 'BEer')
                            set e2 = null
                            call GroupAddUnit(g2, u)
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop
                else
                    call ScaleEffDummy(e, 0.42, 1, 0.01)
                    call MyRemoveEff(e, 0.42)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set c = null
                    set g = null
                    set g2 = null
                    set u = null
                    set e = null
                    set m_AlterSaberRR[i] = m_AlterSaberRR[ MUI_AlterSaberRR]
                    set MUI_AlterSaberRR = MUI_AlterSaberRR - 1
                    if MUI_AlterSaberRR == -1 then
                        call PauseTimer( t_AlterSaberRR)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method AlterSaberRR_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_AlterSaberRR = MUI_AlterSaberRR + 1
            set m_AlterSaberRR[ MUI_AlterSaberRR] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set aoe = AlterSaberRR_Aoe
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set rmax = AlterSaberRR_Time
            set dmg = GetHeroAgi( c , true) * ( AlterSaberRR_DamageAgiBase + ( AlterSaberRR_DamageAgiStep * ( GetUnitAbilityLevel( c , AlterSaberR_ID) - 1 ) ) )
            call MakeSound("war3mapimported\\Hero_AlterSaber_RR")
            set e = EffectSpawn("war3mapImported\\wos_AFB (1896)1.mdl", x, y, 1, 1, 0.01, 1)
            call ScaleEffDummy(e, 0.42, 0.01, 1)
            call DecorRemove(c, x, y, aoe * 1.1, 50)
            call VisionTimed(GetOwningPlayer(c), x , y, aoe * 1.5, rmax + 2)
            if MUI_AlterSaberRR == 0 then
                call TimerStart( t_AlterSaberRR, 0.5, true, function thistype.Loop_AlterSaberRR)
            endif
        endmethod
    endstruct

    private struct AlterSaberT_KS
        private static timer t_AlterSaberT = CreateTimer( )
        private static integer array m_AlterSaberT
        private static integer MUI_AlterSaberT = -1
        unit c
        real x
        real y
        real r2
        integer k
        real scale
        real r5
        real r6
        group g
        group g2
        unit u
        real dmg
        integer check2
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax
        private static method Loop_AlterSaberT takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AlterSaberT
                set this = m_AlterSaberT[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit(c)
                    if r == 0.3 then
                        call MakeSound("war3mapimported\\Hero_AlterSaber_T2")
                    endif
                    if r == 1.2 then
                        call MakeSound("war3mapimported\\Hero_AlterSaber_T4")
                    endif
                    if r == 1.5 then
                        call MakeSound("war3mapimported\\Hero_AlterSaber_T3")
                    endif
                    if r == 2.7 then
                        call MakeSound("war3mapimported\\Hero_AlterSaber_T6")
                        call DestroyEffect(e)
                    endif
                    if r == 2.01 then
                        set x = GetUnitX(c) + 55 * Cos(a)
                        set y = GetUnitY(c) + 55 * Sin(a)
                        call MakeSound("war3mapimported\\Hero_AlterSaber_T5")
                        set r2 = 0
                        set scale = 2
                        set move = 200
                        call EffectSpawn2("war3mapImported\\wos_Laser_BlueYellow2.mdl", x, y, a * bj_RADTODEG, 1.5, 0.2, 150, 0.45)
                    endif
                    if r > 2.01 and r < rmax - 0.03 then
                        set scale = scale + 0.13
                        set r2 = r2 + move
                        if r2 > AlterSaberT_Range then
                            set r = 99999
                        endif
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x + r2 * Cos(a), y + r2 * Sin(a), aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u, g2) == false then
                                call dmgmag(c, u, dmg)
                                call GroupAddUnit(g2, u)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set r2 = r2 + move
                        if r6 >= 0.0 and (r2 < AlterSaberT_Range-375) then
                            set r6 = 0
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-qqsfx-5.mdl", x + r2 * Cos(a), y + r2 * Sin(a), a * bj_RADTODEG, 0.44, scale / 1.15, 120))
                            call DecorRemove(c, x + r2 * Cos(a), y + r2 * Sin(a), aoe * 1.4, 100)
                            call VisionTimed(GetOwningPlayer(c), x + r2 * Cos(a), y + r2 * Sin(a), aoe * 2, 2)
                            call MyRemoveEff(EffectSpawnColor3("war3mapImported\\wos_Efect125.mdl", x + r2 * Cos(a), y + r2 * Sin(a), a * bj_RADTODEG + 180, 1, 2.15, 220, -90, 255, 255, 255, 125), 0.75)
                        else
                            set r6 = r6 + 0.03
                        endif
                        if r5 > 0.0 and r < rmax - 0.09 and (r2 < AlterSaberT_Range-375)  then
                            set r5 = 0
                            call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_afb (45).mdl", x + (r2 * 1.1) * Cos(a), y + (r2 * 1.1) * Sin(a), a * bj_RADTODEG, 1., 3, 65), 0., 255, 255, 255, 0.66)
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_afb (2080).mdl", x + (r2 * 1.3) * Cos(a), y + (r2 * 1.3) * Sin(a), a * bj_RADTODEG, 0.6, 1.95, 55))
                        else
                            set r5 = r5 + 0.03
                        endif
                    endif
                else
                    call DestroyEffect(e)
                    if check2 == 1 then
                        call BlzSetUnitSkin(c, AlterSaber_ID)
                        call FixAura(c)
                    endif
                    call SetUnitAnimation(c, "stand")
                    call StopSpellUnit(c)
                    call DestroyGroup( g )
                    set g = null
                    call DestroyGroup( g2 )
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_AlterSaberT[i] = m_AlterSaberT[ MUI_AlterSaberT]
                    set MUI_AlterSaberT = MUI_AlterSaberT - 1
                    if MUI_AlterSaberT == -1 then
                        call PauseTimer( t_AlterSaberT)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method AlterSaberT_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_AlterSaberT = MUI_AlterSaberT + 1
            set m_AlterSaberT[ MUI_AlterSaberT] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set check2 = 0
            if LoadInteger(hs, GetHandleId(c), StringHash("mode r")) == 0 then
                set check2 = 1
                call BlzSetUnitSkin(c, AlterSaber2_ID)
                call FixAura(c)
            endif
            call DebugUnit(c)
            set rmax = 2.7
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2( c , x, y ) // Angle Between points
            set aoe = AlterSaberT_DamageAoe
            set dmg = GetHeroAgi( c , true) * AlterSaberT_DamageAgiBase
            call SetUnitAnimationByIndex( c , 10)
            call SetUnitTimeScale(c, 0.5)
            call BlzSetUnitFacingEx(c,a*bj_RADTODEG)
            call MakeSound("war3mapimported\\Hero_AlterSaber_T")
            set e = AddSpecialEffectTarget("war3mapImported\\wos_HSglb31.mdl", c, "weapon")
            call SetUnitFacing( c , a * bj_RADTODEG)
            call EffectSpawn2("war3mapImported\\wos_stenpafx3.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.25, 8, 1, 2)
            set k = 0
            loop
                exitwhen k == 8
                call ScaleEffDummy2(EffectSpawnColor2("war3mapImported\\wos_Efect125.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1.25, 0.01, k * 450, 2.4, 255, 255, 255, 75), 0.03 * k, 0.24, 0.01, 1.45)
                set k = k + 1
            endloop
            set e2 = EffectSpawn("war3mapImported\\wos_LimitIndra-ORA.mdl", GetUnitX(c), GetUnitY(c), 1, 1, 4, 1)
            call BlzSetSpecialEffectAlpha(e2, 0)
            call ColorEffDummy4(e2, 0., 255, 255, 255, 0.5)
            call ColorEffDummy3(e2, 2.4, 255, 255, 255, 1.2)
            call ScaleEffDummy2(e2, 2.4, 1.2, 4, 6)
            if MUI_AlterSaberT == 0 then
                call TimerStart( t_AlterSaberT, 0.03, true, function thistype.Loop_AlterSaberT)
            endif
        endmethod
    endstruct

    //----------------------------AlterSaber-----------------------------------------------
     /* Animations index:
    0 - stand
    1 - sword pierce
    2 - atk upward
    3 - atk from self
    4 - charge slash (e?)
    6 - move
    7 - atk forward
    8 - atk backward from 7
    9 - atk forward another after 8
    morph:
    1 - stand
    2 - t second cast(atk from jump to earth fast)
    3 - atk from self
    4 - charge ex
    5 - r ( kamikoros)
    7 - stand ready ( w2 cast)
    8 - w2 atk
    9 - t cast
    10 - move
    11 - full cast of ex normal
    12 - stand ready fast + dash
    13 - atk normal 1 ( for e)
    
     */ 
    function AlterSaberPas_Start takes unit c returns nothing
     //   call AlterSaberSpells.AlterSaberPas_Start( c )
    endfunction
    function AlterSaberQ_Start takes unit c, real x, real y returns nothing
        call AlterSaberQ_KS.AlterSaberQ_Start( c, x, y )
    endfunction
    function AlterSaberW_PasTrigger takes unit c, unit td returns nothing
    local real a 
    local real dmg2
    local real x = GetUnitX(td)
    local real y = GetUnitY(td)
    local real time 
if LoadInteger(hs,GetHandleId(c),StringHash("saber w")) > 0 then 
set a = GAngle(c,td)
set dmg2 = GetHeroAgi( c , true) * ( AlterSaberG_DamageAgiBase + ( AlterSaberG_DamageAgiStep * ( GetLevelPas3Check( c)-1 ) ))
set dmg2 = dmg2 + AlterSaberG_Damage2StaticBase + ( AlterSaberG_Damage2StaticStep * ( ( GetLevelPas3Check( c)-1 ) ))
call EUTU2_3(EffectSpawn("war3mapImported\\wos_FireFlyW-SFX-1red.mdl", x, y, a*bj_RADTODEG, 1,1.25, 0), 1, 0, td)
call EUTU2_3(EffectSpawn("war3mapImported\\wos_Satsu-WWSFX-1.mdx", x, y, a*bj_RADTODEG, 1.25, 2., 75), 0.76, 75, td)
call EUTU2_3(EffectSpawn("war3mapImported\\wos_Satsu-Hit-red.mdx", x, y, a*bj_RADTODEG, 1.25, 2.45, 145), 0.76, 145, td)
call EUTU2_3(EffectSpawn("war3mapImported\\wos_mei-wsfx-2.mdl", x, y, a*bj_RADTODEG, 1., 2.45, 135), 0.76, 135, td)
call EUTU2_3(EffectSpawn("war3mapImported\\wos_bloodex-special-23", x, y, a*bj_RADTODEG, 2., 2.45, 135), 2, 135, td)
call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_wfile00009065.mdl", GetUnitX(td), GetUnitY(td), a * bj_RADTODEG , 0.65, 1.75, 1, 255, 255, 255, 255))
call MakeSound("war3mapimported\\Hero_AlterSaber_W3")
call NextDmg(c,td,dmg2,0,0.06)
call SaveInteger(hs,GetHandleId(c),StringHash("saber w"),0)
call SaveInteger(hs,GetHandleId(c),StringHash("saber w cd"),1)
set time = AlterSaberG_CD_Base-((GetLevelPas3Check(c)-1)*AlterSaberG_CD_Step)
 call FakeCD_Start(c,AlterSaberG_ID,time,StringHash("saber w cd"),0)
call MyFlush(GetHandleId(c),StringHash("saber w cd"),0,time)
endif
    endfunction
    function AlterSaberComboW_Start takes unit c, unit td returns nothing
        call AlterSaberComboW_KS.AlterSaberComboW_Start( c, td )
    endfunction
    function AlterSaberComboE_Start takes unit c, unit td returns nothing
        call AlterSaberComboE_KS.AlterSaberComboE_Start( c, td )
    endfunction
    function AlterSaberW_Start takes unit c returns nothing
        call AlterSaberW_KS.AlterSaberW_Start( c )
    endfunction
    function AlterSaberW2_Start takes unit c, real x, real y returns nothing
        call AlterSaberW2_KS.AlterSaberW2_Start( c, x, y )
    endfunction
    function AlterSaberE_Start takes unit c returns nothing
        call BuffUnit1(c, c, 1)
    endfunction
    function AlterSaberE_Act_Start takes unit c, unit td returns nothing
        local integer check = 0
        if SR2(c, td) > AlterSaberE_RangeCheck then
            set check = 1
        endif
        call AlterSaberE_KS.AlterSaberE_Start( c, td, check )
    endfunction
    function AlterSaberR_Start takes unit c returns nothing
        call AlterSaberR_KS.AlterSaberR_Start( c )
    endfunction
    function AlterSaberT_Start takes unit c, real x, real y returns nothing
        call AlterSaberT_KS.AlterSaberT_Start( c, x, y )
    endfunction
    function AlterSaberRR_Start takes unit c returns nothing
        call AlterSaberRR_KS.AlterSaberRR_Start( c )
    endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com