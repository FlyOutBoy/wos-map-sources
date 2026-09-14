library GojoSpells initializer InitGojoSpells uses GearSystems
    globals
        private timer GojoTimer03 = null
        private timer GojoTimer05 = null
        private code GojoTimer03Callback
        private code GojoTimer05Callback
        private integer GojoTimer03Users = 0
        private integer GojoTimer05Users = 0
        private framehandle array frame_pas1
        private framehandle array frame_pas2
        private framehandle array frame_pas3
        private framehandle array frame_pas4
        private framehandle array frame_pas5
        private framehandle array frame_pas6
        private framehandle array frame2_pas1
        private framehandle array frame2_pas2
        private framehandle array frame2_pas3
        private framehandle array frame2_pas4
        private framehandle array frame2_pas5
        private framehandle array frame2_pas6
//--------------------------------------Gojo--------------------------------------------------------------
        integer Gojo_ID = 'H009'
//---------------G ability-----------------------------------------------------
        integer GojoG_ID = 'A01U'
        real Gojo_G_ManaRestore = 25 // in % of gojo spell mana cost, it means he will restore % of his manacost for Gojo_G_ManaRestoreTime seconds
        real Gojo_G_ManaRestoreTime = 10 // in seconds, how long time he will restore mana
//---------------Q ability-----------------------------------------------------
        integer GojoQ_ID = 'A01J'
        integer GojoQ2_ID = 'A01L'
        real GojoQ_DamageIntBase = 1 // base number x Int damage for 1 level
        real GojoQ_DamageIntStep = 1 // additional number x Int damage for each next level
        real GojoQ_Damage2StaticBase = 150 // base static damage for 1 level
        real GojoQ_Damage2StaticStep = 0 // additional static damage for each next level
        real GojoQ_DamageAoe = 320
        real GojoQLvl2_DamageAoe = 345
        real GojoQLvl3_DamageAoe = 545
        real GojoQLvl2_Range = 1400
        real GojoQ_PushRange = 400
        real GojoQ_PushDuration = 0.51
//---------------QW Combo-----------------------------------------------------
        real GojoQLvl1_QW_StunTime = 1 // cause stun when you make combo q + w
        real GojoQLvl2_QW_StunTime = 1 // cause stun when you make combo q + w
        real GojoQLvl3_QW_StunTime = 1 // cause stun when you make combo q + w
        real GojoQWLvl1_BonusDmg = 15 // additional bonus to spell damage that close reaction ( if blue dmg after red than it will deal 15% additional damage to blue) for 1 - 2 lvl
        real GojoQWLvl2_BonusDmg = 25 // additional bonus to spell damage that close reaction ( if blue dmg after red than it will deal 30% additional damage to blue) for 3 - 5 lvl
        real GojoQWLvl3_BonusDmg = 35 // additional bonus to spell damage that close reaction ( if blue dmg after red than it will deal 55% additional damage to blue) for 6 lvl
//---------------W ability-----------------------------------------------------
        integer GojoW_ID = 'A01K'
        integer GojoW2_ID = 'A01M'
        real GojoW_DamageIntBase = 1 // base number x Int damage for 1 level
        real GojoW_DamageIntStep = 1 // additional number x Int damage for each next level
        real GojoW_Damage2StaticBase = 150 // base static damage for 1 level
        real GojoW_Damage2StaticStep = 0 // additional static damage for each next level
        real GojoW_DamageAoe = 320
        real GojoWLvl2_DamageAoe = 345
        real GojoWLvl3_DamageAoe = 545
        real GojoWLvl2_Range = 1400
        real GojoWLvl3_Range = 2250
        real GojoW_PushRange = 400
        real GojoW_PushDuration = 0.51
//---------------E ability-----------------------------------------------------
        integer GojoE_ID = 'A01N'
        integer GojoE2_ID = 'A01O'
        real GojoE_Duration = 3 // how much sec ability works on lvl 1 - 4, on lvl 5 how much sec before mana drain start
        real GojoE_AddDuration = 0.5 // for each next level
        real GojoE_MaxDuration = 6 // how much sec ability works on lvl 5 how much sec before ability end
        real GojoE_Lvl5Manacost = 6 // manacost for each sec at 5 lvl after base duration of ability
        real GojoE_DamageAoe = 335
//---------------R ability-----------------------------------------------------
        integer GojoR_ID = 'A01P'
        integer GojoRCancel_ID = 'A09Q'
        real GojoR_StunTime = 1
        real GojoR_DurationBase = 4
        real GojoR_DurationStep = 1
        real GojoR_DamageIntFirst = 1 // int x lvl 1 time
        real GojoR_DamageIntBase = 1 // base number x Int damage for 1 level scythe throw
        real GojoR_DamageIntStep = 0.25 // additional number x Int damage for each next level scythe throw
        real GojoR_DamageAoe = 900 // domain aoe
        real GojoR_35lvl_AddAoe = 150 // additional aoe for gojo when gain 35 lvl
        integer GojoR_Slow = 20 // Caused slow %
        //---------------RQ ability-----------------------------------------------------
        integer GojoRQ_ID = 'A01Q'
        real GojoRQ_Stun = 0.7
        real GojoRQ_DamageAoe = 300 //
        real GojoRQ_Damage = 3 // x atk
         //---------------RW ability-----------------------------------------------------
        integer GojoRW_ID = 'A01R'
        real GojoRW_DamageIntBase = 1 // base number x Int damage for 1 level scythe throw
        real GojoRW_DamageIntStep = 0.5 // additional number x Int damage for each next level scythe throw
         //---------------RR ability-----------------------------------------------------
        integer GojoRR_ID = 'A01S'
        real GojoRR_BaseCd = 3 // how much seconds on cooldown ability will have after rt cast
        integer GojoRR_Count = 1 // how much time it would tight enemy to center, 4 - 4 times
        integer GojoRR_CountAdd = 1 // how much time it would tight enemy to center with next level, 4 - 4 times
//---------------T ability-----------------------------------------------------
        integer GojoT_ID = 'A01T'
        integer GojoT2_ID = 'A01X'
        real GojoT_DamageIntBase = 11 // int number of damage
        real GojoT_DamageAoe = 710
        real GojoT_PushRange = 1400
        real GojoT_PushDuration = 0.36
//------------------------------------------------------------------------------
    endglobals

    private function GojoTimer03Acquire takes nothing returns nothing
        set GojoTimer03Users = GojoTimer03Users + 1
        if GojoTimer03Users == 1 then
            call TimerStart(GojoTimer03, 0.03, true, GojoTimer03Callback)
        endif
    endfunction

    private function GojoTimer03Release takes nothing returns nothing
        set GojoTimer03Users = GojoTimer03Users - 1
        if GojoTimer03Users <= 0 then
            set GojoTimer03Users = 0
            call PauseTimer(GojoTimer03)
        endif
    endfunction

    private function GojoTimer05Acquire takes nothing returns nothing
        set GojoTimer05Users = GojoTimer05Users + 1
        if GojoTimer05Users == 1 then
            call TimerStart(GojoTimer05, 0.05, true, GojoTimer05Callback)
        endif
    endfunction

    private function GojoTimer05Release takes nothing returns nothing
        set GojoTimer05Users = GojoTimer05Users - 1
        if GojoTimer05Users <= 0 then
            set GojoTimer05Users = 0
            call PauseTimer(GojoTimer05)
        endif
    endfunction

    private struct GojoSpells_Q
        private static integer array m_GojoQ
        private static integer MUI_GojoQ = -1
        private static integer array m_GojoQ2
        private static integer MUI_GojoQ2 = -1
        unit c
        real x
        real y
        real x1
        real y1
        real x2
        real y2
        real r2
        integer k
        integer k2
        integer k3
        real scale
        real r3
        real r5
        real r6
        real r7
        real sr
        real fly
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

        public static method Loop_GojoQ takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_GojoQ
                set this = m_GojoQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if k2 == 0 then
                        if r == 0.45 then
                            call StopSpellUnit2(c)
                        endif
                        if r == 0.51 then
                            set r2 = 0
                            call MakeSound("war3mapimported\\Hero_Gojo_Q2")
                            call MakeSound("war3mapimported\\Hero_Gojo_Q2 2")
                            call VisionTimed(GetOwningPlayer(c), x, y, 650, 2)
                        endif
                        if r > 0.51 and r2 > 0.06 then
                            set r2 = 0
                            set k = 0
                            call GroupClear( g )
                            call DecorRemove(c, x1 + (sr + 250) * Cos(a) , y1 + (sr + 250) * Sin(a), aoe * 1.2, 20)
                            call GroupEnumUnitsInRange( g , x1 + (sr + 250) * Cos(a) , y1 + (sr + 250) * Sin(a) , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                    call GroupAddUnit(g2, u)
                                    call SaveInteger(hs, GetHandleId(u), StringHash("blue"), 1)
                                    call MyFlush(GetHandleId(u), StringHash("blue"), 0, 2.25)
                                    if LoadInteger(hs, GetHandleId(u), StringHash("red")) > 0 then
                                        call SaveInteger(hs, GetHandleId(u), StringHash("blue"), 0)
                                        call dmgphys(c, u, dmg + (dmg * (GojoQWLvl1_BonusDmg / 100)))
                                        call StunUnit(c, u, GojoQLvl1_QW_StunTime )
                                        call EUTU2_3(EffectSpawn("war3mapImported\\wos_purple wave explosion.mdl", GetUnitX(u), GetUnitY(u), a * bj_RADTODEG , 1.5, 0.65, 1), 1.25, 5, u)
                                    else
                                        call dmgphys(c, u, dmg)
                                    endif
                                    set r6 = SR2(c, u)
                                    if r6 < GojoQ_PushRange + 100 then
                                        call MUE(u, r6 - 50, GojoQ_PushDuration , a + bj_DEGTORAD * 180)
                                    else
                                        call MUE(u, GojoQ_PushRange , GojoQ_PushDuration , a + bj_DEGTORAD * 180)
                                    endif
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                            call EffectSpawn2("war3mapImported\\wos_AZ_BNPF_FF1BLUE.mdl" , x1 + (sr + 150) * Cos(a) , y1 + (sr + 150) * Sin(a) , a * bj_RADTODEG + 180 , 1.25 , 0.375 , 255, 0.36)
                            call DestroyEffect(EffectSpawn3("war3mapImported\\wos_YC_Shockwave_b.mdl", x1 + (sr + 150) * Cos(a) , y1 + (sr + 150) * Sin(a) , a * bj_RADTODEG + 180, 1, 1, 255, -90))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_cf2.mdx", x1 + (sr + 150) * Cos(a) , y1 + (sr + 150) * Sin(a) , a * bj_RADTODEG + 180, 1.5, 1, 1))
                            set sr = sr - 250
                            set k3 = k3 + 1
                            if k3 >= 4 then
                                set r = rmax + 1111
                            endif
                        else
                            set r2 = r2 + 0.03
                        endif
                    elseif k2 == 1 then
                        if r == 0.36 then
                            call StopSpellUnit2(c)
                            set e = EffectSpawn("war3mapImported\\wos_Blue.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 4, 2.5, 1)
                            set e2 = EffectSpawn("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiBlue.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 2, 155)
                            set move = 56
                            set r5 = 0
                        endif
                        if r == 0.6 then
                            call MakeSound("war3mapimported\\Hero_Gojo_Q4")
                        endif
                        if r > 0.45 then
                            set x = GetEffX(e)
                            set y = GetEffY(e)
                            set r5 = r5 + move
                            if r5 >= GojoQLvl2_Range then
                                set r = 9999999
                                set k = 0
                                loop
                                    exitwhen k == 6
                                    set r5 = GetRandomReal(0.5, 1)
                                    set r6 = GetRandomReal(1.85, 2.8)
                                    if k < 3 then
                                        call EffectSpawnColor2("war3mapimported\\wos_WTW-Cang-DiMian-Blue-B.mdl", x, y, GetRandomReal(0, 359), 1.5, 0.7 + k * 0.4, 1, 0.21, 255, 255, 255, 100)
                                    endif
                                    call DestroyEffect(EffectSpawn3("war3mapImported\\wos_YC_Shockwave_b.mdl", x, y , GetRandomReal(0, 359), r5, r6, 255, -45))
                                    set k = k + 1
                                endloop
                                call GroupClear( g )
                                call DecorRemove(c, x , y, aoe * 1.2, 50)
                                call GroupEnumUnitsInRange( g , x , y , aoe * 1.65 , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                        if IsUnitInGroup(u, g2) == false then
                                            call SaveInteger(hs, GetHandleId(u), StringHash("blue"), 1)
                                            call MyFlush(GetHandleId(u), StringHash("blue"), 0, 2.25)
                                            if LoadInteger(hs, GetHandleId(u), StringHash("red")) > 0 then
                                                call SaveInteger(hs, GetHandleId(u), StringHash("blue"), 0)
                                                call dmgphys(c, u, dmg + (dmg * (GojoQWLvl2_BonusDmg / 100)))
                                                call StunUnit(c, u, GojoQLvl2_QW_StunTime )
                                                call EUTU2_3(EffectSpawn("war3mapImported\\wos_purple wave explosion.mdl", GetUnitX(u), GetUnitY(u), a * bj_RADTODEG , 1.5, 0.65, 1), 1.25, 5, u)
                                            else
                                                call dmgphys(c, u, dmg)
                                            endif
                                            call GroupAddUnit(g2, u)
                                        endif
                                        call MUE(u, SR3(u, x, y) / 1.5 , 0.15 , GAngle2(u, x, y))
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                            endif
                            call MoveEff2(e, move, a)
                            call MoveEff2(e2, move, a)
                            if r3 > 0.09 then
                                set r3 = 0
                                call DestroyEffect(EffectSpawn3("war3mapImported\\wos_YC_Shockwave_b.mdl", x + (150) * Cos(a) , y + (150) * Sin(a) , a * bj_RADTODEG + 180, 1, 1.35, 255, -90))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_cf2.mdx", x + (150) * Cos(a) , y + (150) * Sin(a) , a * bj_RADTODEG, 1.5, 1.35, 1))
                            else
                                set r3 = r3 + 0.03
                            endif
                            if r2 > 0.03 then
                                set r2 = 0
                                if check == 0 then
                                    call VisionTimed(GetOwningPlayer(c), x, y, 750, 2)
                                    call DecorRemove(c, x, y, aoe * 1.1, 50)
                                endif
                                set check = check + 1
                                if check >= 4 then
                                    set check = 0
                                endif
                                call GroupClear( g )
                                call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                        if IsUnitInGroup(u, g2) == false then
                                            call SaveInteger(hs, GetHandleId(u), StringHash("blue"), 1)
                                            call MyFlush(GetHandleId(u), StringHash("blue"), 0, 2.25)
                                            if LoadInteger(hs, GetHandleId(u), StringHash("red")) > 0 then
                                                call SaveInteger(hs, GetHandleId(u), StringHash("blue"), 0)
                                                call dmgphys(c, u, dmg + (dmg * (GojoQWLvl2_BonusDmg / 100)))
                                                call StunUnit(c, u, GojoQLvl2_QW_StunTime )
                                                call EUTU2_3(EffectSpawn("war3mapImported\\wos_purple wave explosion.mdl", GetUnitX(u), GetUnitY(u), a * bj_RADTODEG , 1.5, 0.65, 1), 1.25, 5, u)
                                            else
                                                call dmgphys(c, u, dmg)
                                            endif
                                            call GroupAddUnit(g2, u)
                                        endif
                                        call MUE(u, SR3(u, x, y) / 3 , 0.15 , GAngle2(u, x, y))
                                        call MoveUnit(u, move * 2, a)
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif
                    elseif k2 == 2 then
                        if r3 > 0.09 then
                            call DecorRemove(c, x1, y1, aoe , 100)
                            call VisionTimed(GetOwningPlayer(c), x1, y1, 1050, 2)
                            set r3 = 0
                            if check == 1 and r > 0.56 then
                                set r7 = GetRandomReal(1.45, 0.95 + r)
                                set scale = 45
                            else
                                set r7 = GetRandomReal(1.35, 1.9)
                                set scale = 0
                            endif
                            set r6 = GetRandomReal( -90, -45)
                            call EUTU4(EffectSpawn3("war3mapImported\\wos_YC_Shockwave_b.mdl", GetEffX(e), GetEffY(e), GetRandomReal(0, 359), 1.1, r7, fly, r6), 0.51, 15 + scale, e)
                            if check == 1 and r > 0.6 then
                                call EffectSpawnColor2("war3mapimported\\wos_WTW-Cang-DiMian-Blue-B.mdl", GetEffX(e), GetEffY(e), GetRandomReal(0, 359), 1.5, 1.2 + r, 1, 0.21, 255, 255, 255, 100)
                            endif
                        else
                            set r3 = r3 + 0.03
                        endif
                        if r2 > 0.03 then
                            set r2 = 0
                            set x1 = GetEffX(e)
                            set y1 = GetEffY(e)
                            set aoe = GojoQLvl3_DamageAoe
                            if check == 1 and r > 1.02 then
                                set aoe = GojoQLvl3_DamageAoe * 1.35
                            endif
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , x1 , y1 , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    if IsUnitInGroup(u, g2) == false then
                                        call SaveInteger(hs, GetHandleId(u), StringHash("blue"), 1)
                                        call MyFlush(GetHandleId(u), StringHash("blue"), 0, 3.5)
                                        if LoadInteger(hs, GetHandleId(u), StringHash("red")) > 0 then
                                            call SaveInteger(hs, GetHandleId(u), StringHash("blue"), 0)
                                            call dmgphys(c, u, dmg + (dmg * (GojoQWLvl2_BonusDmg / 100)))
                                            call StunUnit(c, u, GojoQLvl2_QW_StunTime )
                                            call EUTU2_3(EffectSpawn("war3mapImported\\wos_purple wave explosion.mdl", GetUnitX(u), GetUnitY(u), a * bj_RADTODEG , 1.5, 0.65, 1), 1.25, 5, u)
                                        else
                                            call dmgphys(c, u, dmg)
                                        endif
                                        call GroupAddUnit(g2, u)
                                    endif
                                    if r < 0.66 then
                                        call MUE(u, SR3(u, x1, y1) / 2 , 0.15 , GAngle2(u, x1, y1))
                                    else
                                        call MUE(u, SR3(u, x1, y1) / 3 , 0.24 , GAngle2(u, x1, y1))
                                    endif
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        else
                            set r2 = r2 + 0.03
                        endif
                        if check == 0 then
                            if r == 1.11 then
                                call MakeSound("war3mapimported\\Hero_Gojo_Q5")
                            endif
                            if r == 0.03 then
                                call StopSpellUnit(c)
                                set r5 = 225
                                set e = EffectSpawn("war3mapimported\\wos_wtw-1r2-cang.mdx", GetUnitX(c) + r5 * Cos(a), GetUnitY(c) + r5 * Sin(a), a * bj_RADTODEG, 4, 0.25, 0)
                                set e2 = EffectSpawn("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiBlue.mdx", GetUnitX(c) + r5 * Cos(a), GetUnitY(c) + r5 * Sin(a), a * bj_RADTODEG, 1, 2, 175)
                                set e3 = EffectSpawn("war3mapimported\\wos_Windwalk Blue Soul.mdx", GetUnitX(c) + r5 * Cos(a), GetUnitY(c) + r5 * Sin(a), a * bj_RADTODEG, 1, 3, 175)
                                set e4 = EffectSpawn("war3mapimported\\wos_WTW-Wood_NEF_Odr-Cang.mdx", GetUnitX(c) + r5 * Cos(a), GetUnitY(c) + r5 * Sin(a), a * bj_RADTODEG, 1, 1, 175)
                                set move = 45
                                set fly = 105
                                call ScaleEffDummy(e, 1.75, 0.25, 1.75)
                                call ScaleEffDummy(e4, 1.5, 1, 1.95)
                            endif
                            set a = a + 5.6 * bj_DEGTORAD
                            set x1 = GetUnitX(c)
                            set y1 = GetUnitY(c)
                            if r > 1.1 then
                                set fly = fly + 16.5
                            else
                                set fly = fly + 6.5
                            endif
                            if r5 < 655 then
                                set r5 = r5 + 3.5
                            endif
                            call BlzSetSpecialEffectPosition(e, x2 + r5 * Cos(a), y2 + r5 * Sin(a), fly)
                            call BlzSetSpecialEffectPosition(e2, x2 + r5 * Cos(a), y2 + r5 * Sin(a), fly + 15)
                            call BlzSetSpecialEffectPosition(e3, GetEffX(e), GetEffY(e), fly - 20)
                            call BlzSetSpecialEffectPosition(e4, GetEffX(e), GetEffY(e), fly)
                            if r == rmax then
                                set r = 0
                                set check = 1
                                set rmax = 2.52
                                set a = GAngle5(e, x, y)
                                set r3 = 10
                                set aoe = 850
                                set move = SR5(e, x, y) / 21
                                set fly = (fly - 150) / 21
                                set k3 = 255
                            endif
                        elseif check == 1 then
                            if LoadReal(hs, GetHandleId(c), StringHash("blue x")) == 99 then
                                set r = 9999
                            endif
                            if r == 0.9 then
                                call MakeSound("war3mapimported\\Hero_Gojo_Q4")
                            endif
                            if r <= 0.63 then
                                call MoveEff2(e, move, a)
                                call MoveEff2(e2, move, a)
                                call BlzSetSpecialEffectHeight(e, BlzGetLocalSpecialEffectZ(e) - fly)
                                call BlzSetSpecialEffectHeight(e2, BlzGetLocalSpecialEffectZ(e2) - fly)
                                call BlzSetSpecialEffectPosition(e3, GetEffX(e), GetEffY(e), BlzGetLocalSpecialEffectZ(e) - fly)
                                call BlzSetSpecialEffectPosition(e4, GetEffX(e), GetEffY(e), BlzGetLocalSpecialEffectZ(e4) - fly)
                            else
                                set x = GetEffX(e)
                                set y = GetEffY(e)
                                if r == 1.5 then
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_CrackWhitee.mdl", x, y, 1, 0.95, 0.7, 1, 255, 255, 255, 100))
                                endif
                                if r == 0.66 then
                                    set r3 = 10
                                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_CrackWhitee.mdl", x, y, 1, 0.75, 0.7, 1, 255, 255, 255, 100))
                                    set e5 = EffectSpawn2("war3mapImported\\wos_WTW-Wood_NEF_Odr-Cang.mdl", x, y, 1, 1, 1.25, 155, 1.75)
                                    call ScaleEffDummy(e4, 2, 1.75, 3.75)
                                    call ScaleEffDummy(e5, 2, 1.75, 4)
                                    call ScaleEffDummy(e, 3, 1.7, 3.45)
                                    call ScaleEffDummy(e2, 3, 2, 6)
                                    call SaveReal(hs, GetHandleId(c), StringHash("blue x"), x)
                                    call SaveReal(hs, GetHandleId(c), StringHash("blue y"), y)
                                endif
                                if r3 > 0.21 then
                                    set r3 = 0
                                    set k3 = k3 - 55
                                    call BlzSetSpecialEffectHeight(e, BlzGetLocalSpecialEffectZ(e) + 15)
                                    call BlzSetSpecialEffectHeight(e4, BlzGetLocalSpecialEffectZ(e4) + 10)
                                    if k3 < 0 then
                                        set k3 = 0
                                    endif
                                    call BlzSetSpecialEffectColor(e, 255, 255, 255)
                                    call BlzSetSpecialEffectAlpha(e, k3)
                                else
                                    set r3 = r3 + 0.03
                                endif
                            endif
                        endif
                    endif
                else
                    if k2 == 0 and r < 0.45 then
                        call StopSpellUnit2(c)
                    endif
                    if k2 == 2 then
                    //    if LoadReal(hs, GetHandleId(c), StringHash("blue x")) == 99 then
                        call ColorEffDummy3(e, 0, 255, 255, 255, 0.15)
                        call ColorEffDummy3(e2, 0, 255, 255, 255, 0.15)
                        call ColorEffDummy3(e5, 0, 255, 255, 255, 0.15)
                        call DestroyEffect(e3)
                        call DestroyEffect(e4)
                     //   endif
                        call SaveReal(hs, GetHandleId(c), StringHash("blue x"), 0)
                        call SaveReal(hs, GetHandleId(c), StringHash("blue y"), 0)
                        if r < 0.6 then
                            call StopSpellUnit(c)
                        endif
                    endif
                    if k2 == 1 then
                        call DestroyEffect(e)
                        call DestroyEffect(e2)
                    endif
                    call DestroyGroup( g )
                    set g = null
                    call DestroyGroup( g2 )
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set e5 = null
                    set u = null
                    set m_GojoQ[i] = m_GojoQ[ MUI_GojoQ]
                    set MUI_GojoQ = MUI_GojoQ - 1
                    if MUI_GojoQ == -1 then
                        call GojoTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method GojoQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_GojoQ = MUI_GojoQ + 1
            set m_GojoQ[ MUI_GojoQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set r3 = 1
            set k2 = 0
            set e = null
            set e2 = null
            set e3 = null
            set e4 = null
            set e5 = null
            call DebugUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set rmax = 3
            set x1 = GetUnitX(c)
            set y1 = GetUnitY(c)
            set sr = SR3(c, x, y)
            set a = GAngle2( c , x , y ) // Angle Between points
            set check = 0
            set k3 = 0
            set aoe = GojoQ_DamageAoe
            call SaveReal(hs, GetHandleId(c), StringHash("blue x"), 0)
            set dmg = GetHeroInt( c , true) * ( GojoQ_DamageIntBase + ( GojoQ_DamageIntStep * ( GetUnitAbilityLevel( c , GojoQ_ID) - 1 ) ) )
            set dmg = dmg + GojoQ_Damage2StaticBase + ( GojoQ_Damage2StaticStep * ( GetUnitAbilityLevel( c , GojoQ_ID) - 1 ) )
            call SetUnitFacing( c , a * bj_RADTODEG)
            call SetUnitTimeScale( c , 0.45)
            set r5 = 0
            call SetUnitAnimationByIndex( c , 5)
            if GetUnitAbilityLevel(c, GojoQ2_ID) == 1 then
                set dmg = GetHeroInt( c , true) * ( GojoQ_DamageIntBase + ( GojoQ_DamageIntStep * ( GetUnitAbilityLevel( c , GojoQ_ID) + 1 ) ) )
                set dmg = dmg + GojoQ_Damage2StaticBase + ( GojoQ_Damage2StaticStep * ( GetUnitAbilityLevel( c , GojoQ_ID) ) )
                set x2 = GetUnitX(c)
                set y2 = GetUnitY(c)
                set aoe = GojoQLvl3_DamageAoe
                set rmax = 1.5
                call MakeSound("war3mapimported\\Hero_Gojo_Q3")
                call SetUnitAnimationByIndex( c , 23)
                call StartSpellUnit(c)
                set k2 = 2
            elseif GetUnitAbilityLevel(c, GojoQ_ID) >= 3 then
                set k2 = 1
                set aoe = GojoQLvl2_DamageAoe
                call MakeSound("war3mapimported\\Hero_Gojo_Q3")
            else
                call MakeSound("war3mapimported\\Hero_Gojo_Q1")
                set k2 = 0
            endif
            if MUI_GojoQ == 0 then
                call GojoTimer03Acquire()
            endif
        endmethod

        public static method Loop_GojoQ2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_GojoQ2
                set this = m_GojoQ2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    call MoveUnit(c, move, a)
                    if r2 > 0.03 then
                        set r2 = 0
                        call GroupClear( g )
                        call GroupEnumUnitsInRange( g , GetUnitX(c) , GetUnitY(c) , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                if IsUnitInGroup(u, g2) == false then
                                    call dmgatk(c, u, dmg)
                                    call StunUnit(c, u, GojoRQ_Stun)
                                    call GroupAddUnit(g2, u)
                                endif
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_blackblink.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG + 90, 2, 1.65, 0, 255, 255, 255, 125))
                    else
                        set r2 = r2 + 0.03
                    endif
                else
                    call StopSpellUnit2(c)
                    call DestroyGroup( g )
                    set g = null
                    call DestroyGroup( g2 )
                    set g2 = null
                    set c = null
                    set u = null
                    set m_GojoQ2[i] = m_GojoQ2[ MUI_GojoQ2]
                    set MUI_GojoQ2 = MUI_GojoQ2 - 1
                    if MUI_GojoQ2 == -1 then
                        call GojoTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method GojoQ2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_GojoQ2 = MUI_GojoQ2 + 1
            set m_GojoQ2[ MUI_GojoQ2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            call DebugUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set move = 100
            set dmg = GetAttack(c) * GojoRQ_Damage
            set sr = (SR3(c, x, y) / move) * 0.03
            set rmax = sr
            set u = null
            set x1 = LoadReal(hs, GetHandleId(c), StringHash("rt x"))
            set y1 = LoadReal(hs, GetHandleId(c), StringHash("rt y"))
            set a = GAngle2( c , x , y ) // Angle Between points
            set aoe = GojoRQ_DamageAoe
            call SetUnitFacing( c , a * bj_RADTODEG)
            call SetUnitTimeScale( c , 2.5)
            call SetUnitAnimationByIndex( c , 2)
            call MakeSound("war3mapimported\\Hero_Gojo_RQ")
            if MUI_GojoQ2 == 0 then
                call GojoTimer03Acquire()
            endif
        endmethod

    endstruct

    private struct GojoSpells_W
        private static integer array m_GojoW
        private static integer MUI_GojoW = -1
        private static integer array m_GojoW2
        private static integer MUI_GojoW2 = -1
        unit c
        unit td
        real x
        real y
        real x1
        real y1
        real x2
        real y2
        real r2
        integer k
        integer k2
        integer k3
        real r3
        real r5
        real r6
        real sr
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
        real a
        real rmax

        public static method Loop_GojoW takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_GojoW
                set this = m_GojoW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if k2 == 0 then
                        if r == 0.45 then
                            call StopSpellUnit2(c)
                        endif
                        if r == 0.51 then
                            set r2 = 0
                            call VisionTimed(GetOwningPlayer(c), x, y, 650, 2)
                            call MakeSound("war3mapimported\\Hero_Gojo_Q2")
                            call MakeSound("war3mapimported\\Hero_Gojo_W2")
                        endif
                        if r > 0.51 and r2 > 0.06 then
                            set r2 = 0
                            set k = 0
                            call GroupClear( g )
                            call DecorRemove(c, x1 + (sr + 250) * Cos(a) , y1 + (sr + 250) * Sin(a), aoe * 1.2, 20)
                            call GroupEnumUnitsInRange( g , x1 + (sr + 250) * Cos(a) , y1 + (sr + 250) * Sin(a) , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                    call GroupAddUnit(g2, u)
                                    call SaveInteger(hs, GetHandleId(u), StringHash("red"), 1)
                                    call MyFlush(GetHandleId(u), StringHash("red"), 0, 2.25)
                                    if LoadInteger(hs, GetHandleId(u), StringHash("blue")) > 0 then
                                        call SaveInteger(hs, GetHandleId(u), StringHash("red"), 0)
                                        call dmgmag(c, u, dmg + (dmg * (GojoQWLvl1_BonusDmg / 100)))
                                        call StunUnit(c, u, GojoQLvl1_QW_StunTime )
                                        call EUTU2_3(EffectSpawn("war3mapImported\\wos_purple wave explosion.mdl", GetUnitX(u), GetUnitY(u), a * bj_RADTODEG , 1.5, 0.65, 1), 1.25, 5, u)
                                    else
                                        call dmgmag(c, u, dmg)
                                    endif
                                    call MUE(u, GojoW_PushRange , GojoW_PushDuration , a)
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                            call EffectSpawn2("war3mapImported\\wos_AZ_BNPF_FF1REd.mdl" , x1 + (sr) * Cos(a) , y1 + (sr) * Sin(a) , a * bj_RADTODEG , 1.25 , 0.375 , 255, 0.36)
                            call DestroyEffect(EffectSpawn3("war3mapImported\\wos_YC_Shockwave_b_red.mdl", x1 + (sr) * Cos(a) , y1 + (sr) * Sin(a) , a * bj_RADTODEG + 180, 1, 1, 255, -90))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_cf2.mdx", x1 + (sr) * Cos(a) , y1 + (sr) * Sin(a) , a * bj_RADTODEG , 1.5, 1, 1))
                            set sr = sr + 225
                            set k3 = k3 + 1
                            if k3 >= 4 then
                                set r = rmax + 1111
                            endif
                        else
                            set r2 = r2 + 0.03
                        endif
                    elseif k2 == 1 then
                        if r == 0.39 then
                            call StopSpellUnit2(c)
                            set e = EffectSpawn("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 2, 155)
                            set move = 56
                            set r5 = 0
                        endif
                        if r == 0.6 then
                            call MakeSound("war3mapimported\\Hero_Gojo_W4")
                        endif
                        if r > 0.45 then
                            set x = GetEffX(e)
                            set y = GetEffY(e)
                            set r5 = r5 + move
                            if r5 >= GojoWLvl2_Range then
                                set r = 9999999
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_effect_order_dange_yueyun_2withoutred.mdl", x, y, a * bj_RADTODEG, 1.15, 1.15, 1))
                                call DestroyEffect(EffectSpawn3("war3mapImported\\wos_YC_Shockwave_b_red.mdl", x, y , a * bj_RADTODEG + 180, 1.25, 3.85, 125, 0))
                                call MakeSound("war3mapimported\\Hero_Gojo_W5")
                                call GroupClear( g )
                                call DecorRemove(c, x, y, aoe * 1.2, 50)
                                call GroupEnumUnitsInRange( g , x , y , aoe * 1.2 , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                        if IsUnitInGroup(u, g2) == false then
                                            call SaveInteger(hs, GetHandleId(u), StringHash("red"), 1)
                                            call MyFlush(GetHandleId(u), StringHash("red"), 0, 2.25)
                                            if LoadInteger(hs, GetHandleId(u), StringHash("blue")) > 0 then
                                                call SaveInteger(hs, GetHandleId(u), StringHash("red"), 0)
                                                call dmgmag(c, u, dmg + (dmg * (GojoQWLvl2_BonusDmg / 100)))
                                                call StunUnit(c, u, GojoQLvl2_QW_StunTime )
                                                call EUTU2_3(EffectSpawn("war3mapImported\\wos_purple wave explosion.mdl", GetUnitX(u), GetUnitY(u), a * bj_RADTODEG , 1.5, 0.65, 1), 1.25, 5, u)
                                            else
                                                call dmgmag(c, u, dmg)
                                            endif
                                            call GroupAddUnit(g2, u)
                                            call MUE(u, GojoW_PushRange , 0.3 , GAngle3(x, y, u))
                                        endif
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                            endif
                            call MoveEff2(e, move, a)
                            if r3 > 0.09 then
                                set r3 = 0
                                call DestroyEffect(EffectSpawn3("war3mapImported\\wos_YC_Shockwave_b_red.mdl", x + (150) * Cos(a) , y + (150) * Sin(a) , a * bj_RADTODEG + 180, 1, 1.35, 255, -90))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_cf2.mdx", x + (150) * Cos(a) , y + (150) * Sin(a) , a * bj_RADTODEG, 1.5, 1.35, 1))
                            else
                                set r3 = r3 + 0.03
                            endif
                            if r2 > 0.03 then
                                set r2 = 0
                                if check == 0 then
                                    call DecorRemove(c, x, y, aoe * 1.1, 50)
                                    call VisionTimed(GetOwningPlayer(c), x, y, 650, 2)
                                endif
                                set check = check + 1
                                if check >= 4 then
                                    set check = 0
                                endif
                                call GroupClear( g )
                                call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                        if IsUnitInGroup(u, g2) == false then
                                            call SaveInteger(hs, GetHandleId(u), StringHash("red"), 1)
                                            call MyFlush(GetHandleId(u), StringHash("red"), 0, 2.25)
                                            if LoadInteger(hs, GetHandleId(u), StringHash("blue")) > 0 then
                                                call SaveInteger(hs, GetHandleId(u), StringHash("red"), 0)
                                                call dmgmag(c, u, dmg + (dmg * (GojoQWLvl2_BonusDmg / 100)))
                                                call StunUnit(c, u, GojoQLvl2_QW_StunTime )
                                                call EUTU2_3(EffectSpawn("war3mapImported\\wos_purple wave explosion.mdl", GetUnitX(u), GetUnitY(u), a * bj_RADTODEG , 1.5, 0.65, 1), 1.25, 5, u)
                                            else
                                                call dmgmag(c, u, dmg)
                                            endif
                                            call MUE(u, GojoW_PushRange , 0.3 , a)
                                            call GroupAddUnit(g2, u)
                                        endif
                                        call MoveUnit(u, move * 3, a)
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif
                    elseif k2 == 2 then
                        if r == 0.03 then
                            set e = EffectSpawn("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", GetUnitX(c) + 155 * Cos(a), GetUnitY(c) + 155 * Sin(a), a * bj_RADTODEG, 1, 2, 155)
                            set e2 = EffectSpawn("war3mapImported\\wos_FSAeff (85)_001.mdl", GetUnitX(c) + 155 * Cos(a), GetUnitY(c) + 155 * Sin(a), a * bj_RADTODEG, 1, 2, 165)
                            set move = 125
                            set r5 = 0
                        endif
                        if r == 1.59 then
                            set r3 = 0
                            call MakeSound("war3mapimported\\Hero_Gojo_W7")
                            call StopSpellUnit(c)
                            call DestroyEffect(e2)
                            set e2 = null
                            set aoe = GojoWLvl3_DamageAoe
                            set e3 = EffectSpawn("war3mapimported\\wos_mei-wsfx-2.mdx", GetUnitX(c) + 155 * Cos(a), GetUnitY(c) + 155 * Sin(a), a * bj_RADTODEG, 0.5, 5, 55)
                        endif
                        if r > 1.59 then
                            set x = GetEffX(e)
                            set y = GetEffY(e)
                            set r5 = r5 + move
                            set x2 = LoadReal(hs, GetHandleId(c), StringHash("blue x"))
                            set y2 = LoadReal(hs, GetHandleId(c), StringHash("blue y"))
                            if x2 != 0 and SR5(e, x2, y2) < 250 then
                                call SaveReal(hs, GetHandleId(c), StringHash("blue x"), 99)
                                call BlzSetSpecialEffectPosition(e, x2, y2, 90)
                                call MakeSound("war3mapimported\\Hero_Gojo_QW")
                                call DestroyEffect(EffectSpawn("war3mapimported\\WOS_OPM (513)purple.mdx", x2, y2, GetRandomReal(0, 359), 1, 1.1, 1))
                                set e2 = EffectSpawn2("war3mapimported\\wos_WTW-Wood_NEF_Odr-Ci.mdl", x2, y2, GetRandomReal(0, 359), 1, 1, 245, 0.45)
                                call ScaleEffDummy(e2, 0.5, 1, 4.35)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_123 (383)3.mdl", x2, y2, GetRandomReal(0, 359), 0.5, 1.15, 55))
                                set k = 0
                                loop
                                    exitwhen k == 8
                                    set r5 = GetRandomReal(350, 850)
                                    set r6 = GetRandomReal(0, 359)
                                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_wtw-whitethunder-zi.mdl", x2 + r5 * Cos(r6), y2 + r5 * Sin(r6), GetRandomReal(0, 359), 1, 2, 1))
                                    set k = k + 1
                                endloop
                                set r = 9999
                                call GroupClear( g )
                                call DecorRemove(c, x, y, aoe * 1.5, 100)
                                call GroupEnumUnitsInRange( g , x , y , aoe * 1.4 , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                        call dmgmag(c, u, (dmg * (GojoQWLvl3_BonusDmg / 100)))
                                        call MUE(u, GojoW_PushRange , 0.35 , a)
                                        call StunUnit(c, u, GojoQLvl3_QW_StunTime )
                                        call EUTU2_3(EffectSpawn("war3mapImported\\wos_purple wave explosion.mdl", GetUnitX(u), GetUnitY(u), a * bj_RADTODEG , 1.5, 0.65, 1), 1.55, 5, u)
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                            endif
                            if r5 >= GojoWLvl3_Range then
                                set r = 9999999
                            endif
                            call MoveEff2(e, move, a)
                            call MoveEff2(e2, move, a)
                            call MoveEff2(e3, move, a)
                            if r3 > 0.06 then
                                set r3 = 0
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_AZ_TS_TZRed.mdl", x, y, GetRandomReal(0, 359), 3, 3.15, 1))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_0780red.mdl", x, y, a * bj_RADTODEG , 0.75, 4, 1))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_bjt_baozha_WRed.mdl", x, y, a * bj_RADTODEG + 180, 1, 1, 1))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_1hongse_2red.mdl", x, y, GetRandomReal(0, 359), 0.5, 5.35, 1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_effect_order_dange_yueyun_2withoutred.mdl", x, y, a * bj_RADTODEG, 1.15, 1.5, 1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_Satsu-RSFX-10.mdl", x, y, GetRandomReal(0, 359), 1, 9, 175))
                                call DestroyEffect(EffectSpawn3("war3mapImported\\wos_YC_Shockwave_b_red.mdl", x, y , GetRandomReal(0, 359), 1.25, 3.15, 125, 0))
                            else
                                set r3 = r3 + 0.03
                            endif
                            if r2 > 0.03 then
                                set r2 = 0
                                call DecorRemove(c, x, y, aoe * 1.2, 100)
                                call VisionTimed(GetOwningPlayer(c), x, y, 1050, 2)
                                call GroupClear( g )
                                call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                        if IsUnitInGroup(u, g2) == false then
                                            call dmgmag(c, u, dmg)
                                            call GroupAddUnit(g2, u)
                                        endif
                                        call MUE(u, GojoW_PushRange * 0.33 , 0.15 , a)
                                        call MoveUnit(u, move * 2, a)
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif
                    endif
                else
                    if k2 == 0 and r < 0.45 then
                        call StopSpellUnit2(c)
                    elseif k2 == 2 then
                        call SaveReal(hs, GetHandleId(c), StringHash("blue x"), 0)
                        if r <= 1.59 then
                            call StopSpellUnit(c)
                        endif
                        call DestroyEffect(e3)
                    endif
                    if k2 == 1 or k2 == 2 then
                        call DestroyEffect(e)
                        call DestroyEffect(e2)
                    endif
                    call DestroyGroup( g )
                    set g = null
                    call DestroyGroup( g2 )
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set u = null
                    set m_GojoW[i] = m_GojoW[ MUI_GojoW]
                    set MUI_GojoW = MUI_GojoW - 1
                    if MUI_GojoW == -1 then
                        call GojoTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method GojoW_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_GojoW = MUI_GojoW + 1
            set m_GojoW[ MUI_GojoW] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set r3 = 1
            set k2 = 0
            set e = null
            set e2 = null
            set e3 = null
            call DebugUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set rmax = 3
            set x1 = GetUnitX(c)
            set y1 = GetUnitY(c)
            set sr = SR3(c, x, y)
            set a = GAngle2( c , x , y ) // Angle Between points
            set check = 0
            set k3 = 0
            set aoe = GojoW_DamageAoe
            set dmg = GetHeroInt( c , true) * ( GojoW_DamageIntBase + ( GojoW_DamageIntStep * ( GetUnitAbilityLevel( c , GojoW_ID) - 1 ) ) )
            set dmg = dmg + GojoW_Damage2StaticBase + ( GojoW_Damage2StaticStep * ( GetUnitAbilityLevel( c , GojoW_ID) - 1 ) )
            call SetUnitFacing( c , a * bj_RADTODEG)
            call SetUnitTimeScale( c , 0.45)
            set r5 = 0
            if GetUnitAbilityLevel(c, GojoW2_ID) == 1 then
                set dmg = GetHeroInt( c , true) * ( GojoW_DamageIntBase + ( GojoW_DamageIntStep * ( GetUnitAbilityLevel( c , GojoW_ID) + 1 ) ) )
                set dmg = dmg + GojoW_Damage2StaticBase + ( GojoW_Damage2StaticStep * ( GetUnitAbilityLevel( c , GojoW_ID) + 1 ) )
                set x2 = GetUnitX(c)
                set y2 = GetUnitY(c)
                set aoe = GojoWLvl3_DamageAoe
                set rmax = 2.4
                call MakeSound("war3mapimported\\Hero_Gojo_W6")
                call SetUnitAnimationByIndex( c , 8)
                call StartSpellUnit(c)
                set k2 = 2
            elseif GetUnitAbilityLevel(c, GojoW_ID) >= 3 then
                set k2 = 1
                set aoe = GojoWLvl2_DamageAoe
                call SetUnitAnimationByIndex( c , 11)
                call MakeSound("war3mapimported\\Hero_Gojo_W3")
            else
                call SetUnitAnimationByIndex( c , 6)
                set sr = sr - 320
                call MakeSound("war3mapimported\\Hero_Gojo_W1")
                set k2 = 0
            endif
            if MUI_GojoW == 0 then
                call GojoTimer03Acquire()
            endif
        endmethod

        public static method Loop_GojoW2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_GojoW2
                set this = m_GojoW2[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r == 0.03 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1.8, 0))
                        call SetUnitPosition(c, x - 150 * Cos(a), y - 150 * Sin(a))
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_blackblink.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.35, 0, 0, 0, 0, 255))
                        set a = GAngle(c, td)
                        call SetUnitFacing(c, a * bj_RADTODEG)
                    endif
                    if r == 1.2 then
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        call dmgphys(c, td, dmg)
                        call MakeSound("war3mapimported\\Hero_Gojo_RW3")
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-Hit-red.mdl", x, y, a * bj_RADTODEG, 1, 3.25, 200))
                        call DestroyEffect( EffectSpawn("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", x, y, a * bj_RADTODEG + 180, 0.35, 3, 145))
                        call DestroyEffect( EffectSpawn("war3mapimported\\wos_bloodex-special-23.mdx", x, y, a * bj_RADTODEG, 2, 3, 145))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_chushou_by_wood_effect_blood_xuebao.mdl", x, y, GetRandomReal(0, 359), 1, 3.5, 45))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_Shockwave_b_red.mdl", x, y, a * bj_RADTODEG, 2, 2.87, 170))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_1hongse_2red.mdl", x, y, a * bj_RADTODEG, 1, 4.37, 15))
                    endif
                else
                    call StopSpellUnit(c)
                    call StopSpellUnit2(td)
                    set c = null
                    set td = null
                    set m_GojoW2[i] = m_GojoW2[ MUI_GojoW2]
                    set MUI_GojoW2 = MUI_GojoW2 - 1
                    if MUI_GojoW2 == -1 then
                        call GojoTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method GojoW2_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_GojoW2 = MUI_GojoW2 + 1
            set m_GojoW2[ MUI_GojoW2] = this
            set c = NewC
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r = 0
            set r2 = 10
            set r3 = 1
            call StartSpellUnit(c)
            call StartSpellUnit2(td)
            set rmax = 1.2
            set a = GAngle2( c , x , y ) // Angle Between points
            set dmg = GetHeroInt( c , true) * ( GojoRW_DamageIntBase + ( GojoRW_DamageIntStep * ( GetUnitAbilityLevel( c , GojoR_ID) - 1 ) ) )
            call SetUnitFacing( c , a * bj_RADTODEG)
            call SetUnitTimeScale( c , 0.15)
            call SetUnitAnimationByIndex( c , 6)
            call MakeSound("war3mapimported\\Hero_Gojo_RW1")
            call MakeSound("war3mapimported\\Hero_Gojo_RW2")
            if MUI_GojoW2 == 0 then
                call GojoTimer03Acquire()
            endif
        endmethod

    endstruct

    private struct GojoSpells_E
        private static integer array m_GojoE
        private static integer MUI_GojoE = -1
        unit c
        real x
        real y
        real r2
        boolean b
        integer k2
        integer k3
        real r3
        real r7
        group g
        unit u
        integer check
        real aoe
        real r
        effect e
        effect e2
        real rmax

        public static method Loop_GojoE takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_GojoE
                set this = m_GojoE[i]
                if GetUnitAbilityLevel(c, GojoE_ID) >= 5 then
                    set b = SpellBoolCaster(c) and (r <= rmax or GetUnitState(c, UNIT_STATE_MANA) > 0) and LoadInteger(hs, GetHandleId(c), StringHash("turn off e")) == 0 and r < r7
                else
                    set b = SpellBoolCaster(c) and r <= rmax
                endif
                if b then
                    set r = RoundReal(r + 0.03, 3)
                    if r > rmax then
                        if r3 > 0.21 then
                            set r3 = 0
                            call SetMpCurrent(c, -((GetUnitState(c, UNIT_STATE_MAX_MANA) * (GojoE_Lvl5Manacost / 100)) / 4))
                        else
                            set r3 = r3 + 0.03
                        endif
                    endif
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    call BlzSetSpecialEffectPosition(e, x, y, BlzGetLocalUnitZ(c) + 3)
                    if GetUnitAbilityLevel(c, GojoE_ID) >= 3 then
                        call BlzSetSpecialEffectPosition(e2, x, y, BlzGetLocalUnitZ(c) + 3)
                        call EffVision(e, c)
                        call EffVision(e2, c)
                    endif
                    if GetUnitAbilityLevel(c, GojoE_ID) >= 3 and IsUnitPaused(c) == false then
                        if r2 > 0.06 then
                            set r2 = 0
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IntegerCd(u, "move cd", 0.15) then
                                    call MUE(u, 85, 0.15, GAngle2(c, GetUnitX(u), GetUnitY(u)))
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                    if GetUnitAbilityLevel(c, GojoE_ID) >= 5 then
                        call BlzFrameSetValue(frame_pas3[k2], r7 - (r + 0.1))
                        if r7 - r >= 0 then
                            call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(r7 - r, 0, 2) + "|r")
                        endif
                    else
                        call BlzFrameSetValue(frame_pas3[k2], rmax - (r + 0.1))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                    endif
                else
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame_pas1[k2], false)
                    endif
                    call OkarunEggCd(c, GojoE_ID, BlzGetUnitAbilityCooldown(c, GojoE_ID, GetUnitAbilityLevel(c, GojoE_ID) - 1))
                    call SaveInteger(hs, GetHandleId(c), StringHash("gojo e"), 0)
                    call DestroyGroup(g)
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.12)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoE2_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoE_ID, true)
                    if check == 1 then
                        call BlzStartUnitAbilityCooldown(c, GojoQ_ID, BlzGetUnitAbilityCooldownRemaining(c, GojoQ2_ID))
                        call UnitRemoveAbility(c, GojoQ2_ID)
                        if LoadInteger(hs, GetHandleId(c), StringHash("rt")) == 0 then
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoQ_ID, true)
                        endif
                    elseif check == 2 then
                        call SetUnitAbilityLevel(c, GojoQ_ID, GetUnitAbilityLevel(c, GojoQ_ID) - 1)
                    endif
                    if k3 == 1 then
                        call BlzStartUnitAbilityCooldown(c, GojoW_ID, BlzGetUnitAbilityCooldownRemaining(c, GojoW2_ID))
                        call UnitRemoveAbility(c, GojoW2_ID)
                        if LoadInteger(hs, GetHandleId(c), StringHash("rt")) == 0 then
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoW_ID, true)
                        endif
                    elseif k3 == 2 then
                        call SetUnitAbilityLevel(c, GojoW_ID, GetUnitAbilityLevel(c, GojoW_ID) - 1)
                    endif
                    call UnitRemoveAbility(c, GojoE2_ID)
                    call SaveInteger(hs, GetHandleId(c), StringHash("turn off e"), 0)
                    if GetUnitAbilityLevel(c, GojoE_ID) >= 3 then
                        // Effect is owned by ColorEffDummy3 below.
                        call BlzPlaySpecialEffect(e2,ANIM_TYPE_DEATH)
                        call ColorEffDummy3(e2, 0, 255, 255, 255, 0.24)
                    endif
                    set g = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_GojoE[i] = m_GojoE[MUI_GojoE]
                    set MUI_GojoE = MUI_GojoE - 1
                    if MUI_GojoE == -1 then
                        call GojoTimer03Release()
                    endif
                    call destroy( )
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method GojoE_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_GojoE = MUI_GojoE + 1
            set m_GojoE[MUI_GojoE] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set g = CreateGroup()
            set u = null
            set r3 = 0
            set e2 = null
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set aoe = GojoE_DamageAoe
            set rmax = GojoE_Duration + GojoE_AddDuration * (GetUnitAbilityLevel(c, GojoE_ID) - 1)
            set r7 = GojoE_MaxDuration
            if GetUnitAbilityLevel(c, GojoE_ID) >= 3 then
                set e2 = EffectSpawn("war3mapimported\\wos_obr08 (479).mdl", x, y, GetRandomReal(0, 359), 0.5, 1.55, 1)
            endif
            if GetUnitAbilityLevel(c, GojoE_ID) >= 5 then
                set rmax = GojoE_Duration
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoE2_ID, true)
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoE_ID, false)
                call UnitAddAbility(c, GojoE2_ID)
                call BlzStartUnitAbilityCooldown(c, GojoE2_ID, 0.5)
            endif
            set check = 0
            set k3 = 0
            if GetUnitAbilityLevel(c, GojoQ2_ID) == 0 and GetUnitAbilityLevel(c, GojoQ_ID) >= 5 then
                call UnitAddAbility(c, GojoQ2_ID)
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoQ_ID, false)
                if LoadInteger(hs, GetHandleId(c), StringHash("rt")) == 0 then
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoQ2_ID, true)
                else
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoQ2_ID, false)
                endif
                call BlzStartUnitAbilityCooldown(c, GojoQ2_ID, BlzGetUnitAbilityCooldownRemaining(c, GojoQ_ID))
                set check = 1
            elseif GetUnitAbilityLevel(c, GojoQ_ID) < 5 then
                set check = 2
                call SetUnitAbilityLevel(c, GojoQ_ID, GetUnitAbilityLevel(c, GojoQ_ID) + 1)
            endif
            if GetUnitAbilityLevel(c, GojoW2_ID) == 0 and GetUnitAbilityLevel(c, GojoW_ID) >= 5 then
                call UnitAddAbility(c, GojoW2_ID)
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoW_ID, false)
                if LoadInteger(hs, GetHandleId(c), StringHash("rt")) == 0 then
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoW2_ID, true)
                else
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoW2_ID, false)
                endif
                call BlzStartUnitAbilityCooldown(c, GojoW2_ID, BlzGetUnitAbilityCooldownRemaining(c, GojoW_ID))
                set k3 = 1
            elseif GetUnitAbilityLevel(c, GojoW_ID) < 5 then
                set k3 = 2
                call SetUnitAbilityLevel(c, GojoW_ID, GetUnitAbilityLevel(c, GojoW_ID) + 1)
            endif
            set e = EffectSpawn("war3mapimported\\wos_GojoEye1.mdl", x, y, GetRandomReal(0, 359), 1.25, 1.35, 1)
            call SetUnitTimeScale(c, 1)
            call SetUnitAnimationByIndex(c, 4)
            call SaveInteger(hs, GetHandleId(c), StringHash("gojo e"), 1)
            if GetUnitAbilityLevel(c, GojoE_ID) == 5 then
                call MakeSound("war3mapImported\\Hero_Gojo_E3")
            elseif GetUnitAbilityLevel(c, GojoE_ID) >= 3 then
                call MakeSound("war3mapImported\\Hero_Gojo_E2")
            else
                call MakeSound("war3mapImported\\Hero_Gojo_E1")
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
                if GetUnitAbilityLevel(c, GojoE_ID) >= 5 then
                    call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, r7)
                    call BlzFrameSetValue(frame_pas3[k2], r7)
                else
                    call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, rmax)
                    call BlzFrameSetValue(frame_pas3[k2], rmax)
                endif
                set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18)
                call BlzFrameSetSize(frame_pas4[k2], 0.0275, 0.0275)
                call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Gojo_E", 0, false)
                set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Eternity Time Left:" + "|r")
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
            if MUI_GojoE == 0 then
                call GojoTimer03Acquire()
            endif
        endmethod

    endstruct

    private struct GojoSpells_R
        private static integer array m_GojoR2
        private static integer MUI_GojoR2 = -1
        private static integer array m_GojoR
        private static integer MUI_GojoR = -1
        unit c
        real x
        real y
        real r2
        integer k
        integer k2
        integer k3
        real scale
        real r3
        real r7
        group g
        unit u
        real dmg
        real dmg2
        real aoe
        real r
        effect e
        effect e2
        effect e3
        effect e4
        effect e5
        effect e6
        real a
        real rmax

        public static method Loop_GojoR2 takes nothing returns nothing
            local thistype this
            local real rr = 0
            local integer i = 0
            loop
                exitwhen i > MUI_GojoR2
                set this = m_GojoR2[i]
                if r < rmax and LoadInteger(hs, GetHandleId(c), StringHash("rt")) == 1 and k3 < k2 then
                    if r == 0.3 then
                        call MakeSound("war3mapImported\\Hero_Gojo_R4")
                    endif
                    set r = RoundReal(r + 0.03, 3)
                    if r2 > 1.2 then
                        if k3 == 0 then
                            call DecorRemove(c, x, y, aoe * 1.25, 50)
                        endif
                        set k3 = k3 + 1
                        call EffectSpawn2("war3mapimported\\wos_WTW-Wood_NEF_Odr-Ci.mdl", x, y, GetRandomReal(0, 359), 1.35, 3.75, 375, 0.21)
                        set r2 = 0
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                set rr = SR3(u, x, y)
                                if rr > 800 then
                                    set rr = 800
                                endif
                                call MUE(u, rr, 0.7, GAngle2(u, x, y))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    else
                        set r2 = r2 + 0.03
                    endif
                else
                    call DestroyGroup(g)
                    // Effect is owned by ColorEffDummy3 below.
                    call BlzPlaySpecialEffect(e,ANIM_TYPE_DEATH)
                    call BlzSetSpecialEffectTimeScale(e, 3)
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.35)
                    set g = null
                    set c = null
                    set e = null
                    set u = null
                    set m_GojoR2[i] = m_GojoR2[MUI_GojoR2]
                    set MUI_GojoR2 = MUI_GojoR2 - 1
                    if MUI_GojoR2 == -1 then
                        call GojoTimer03Release()
                    endif
                    call destroy( )
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method GojoR2_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_GojoR2 = MUI_GojoR2 + 1
            set m_GojoR2[MUI_GojoR2] = this
            set c = NewC
            set x = LoadReal(hs, GetHandleId(c), StringHash("rt x"))
            set y = LoadReal(hs, GetHandleId(c), StringHash("rt y"))
            set r = 0
            set g = CreateGroup()
            set u = null
            set r2 = 10
            set a = GAngle2(c, x, y) // Angle Between points
            set aoe = GojoR_DamageAoe
            set rmax = 15
            set k2 = GojoRR_Count + (GojoRR_CountAdd * (GetUnitAbilityLevel(c, GojoR_ID) - 1))
            set k3 = 0
            if GetHeroLevel(c) >= 35 then
                call SaveInteger(hs, GetHandleId(c), StringHash("gojo RR"), 1)
            endif
            set e = EffectSpawnColor("war3mapimported\\wos_evolt-8.mdl", x, y, GetRandomReal(0, 359), 1.25, 0.01, 375, 255, 255, 255, 180)
            call ScaleEffDummy(e, 0.35, 0.01, 2.5)
            call MakeSound("war3mapImported\\Hero_Gojo_RE")
            call MakeSound("war3mapImported\\Hero_Gojo_R6")
            if MUI_GojoR2 == 0 then
                call GojoTimer03Acquire()
            endif
        endmethod

        public static method Loop_GojoR takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_GojoR
                set this = m_GojoR[i]
                if SpellBoolCaster(c) and r <= rmax and LoadInteger(hs, GetHandleId(c), StringHash("rt end ")) == 0 then
                    set r = RoundReal(r + 0.05, 2)
                    if r == 0.8 then
                        set e = EffectSpawn("war3mapImported\\wos_RT_Cast3.mdl", x, y, 0, 0.3, 0.5, 15)
                        call ScaleEffDummy(e, 0.75, 0.5, 3.25 * scale)
                        call AnimDummyEff(e, 0.5, 0)
                        set e5 = EffectSpawnColor("war3mapImported\\wos_RT_Cast45.mdl", x, y, 0, 0.3, 0.5, 15, 255, 255, 255, 0)
                        call ScaleEffDummy(e5, 0.75, 0.5, 3.25 * scale)
                        call AnimDummyEff(e5, 0.5, 0)
                        set e2 = EffectSpawnColor("war3mapImported\\wos_HakkeStart.mdx", x, y, 0, 0.5, 0.25, 0, 255, 255, 255, 125)
                        call ScaleEffDummy(e2, 0.75, 0.25, 2.05 * scale)
                        call AnimDummyEff(e2, 0.5, 0)
                        set e6 = EffectSpawnColor("war3mapImported\\wos_HakkeStartWhite.mdx", x, y, 0, 0.5, 0.25, 0, 255, 255, 255, 0)
                        call ScaleEffDummy(e6, 0.75, 0.25, 1.85 * scale)
                        call AnimDummyEff(e6, 0.5, 0)
                    elseif r == 0.95 then
                        set e3 = EffectSpawn("war3mapImported\\wos_wtw-xjcsmblbyq-bai3.mdl", x, y, 0, 1, 0.01, 0)
                        call ScaleEffDummy(e3, 1, 0.01, 3.55 * scale)
                        set e4 = EffectSpawnColor("war3mapImported\\wos_5t5rtx2.mdl", x, y, 0, 1, 3.75 * scale, 25, 255, 255, 255, 0)
                        set k2 = 255
                        set k3 = 0
                        call MakeSound("war3mapImported\\Hero_Gojo_R3")
                    endif
                    if r == 1.5 then
                        set r3 = 10
                        call StopSpellUnit(c)
                        call DecorRemove(c, x, y, aoe * 1.1, 100)
                        call DestroyEffect(e3)
                        set e3 = null
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, null)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                call StunUnit(c, u, GojoR_StunTime)
                                call dmgmag(c, u, dmg2)
                                if SR3(u, x, y) > 400 then
                                    call MUE(u, 400, 0.35, GAngle2(u, x, y))
                                else
                                    call MUE(u, SR3(u, x, y), 0.35, GAngle2(u, x, y))
                                endif
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                    if r > 1.5 then
                        if SR3(c, x, y) > aoe then
                            set r = 9999
                        endif
                        if r2 > 1 then
                            set r2 = 0
                            call DecorRemove(c, x, y, aoe * 1.1, 100)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, null)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call SlowUnit(c, u, GojoR_Slow, 2 )
                                   // call SilenceUnit(c, u, 2 )
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        else
                            set r2 = r2 + 0.03
                        endif
                        if LoadInteger(hs, GetHandleId(c), StringHash("gojo RR")) == 1 and r7 > 1.3 then
                            set r7 = 1.2
                        endif
                        if r3 > r7 then
                            set r3 = 0
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call dmgmag(c, u, dmg)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        else
                            set r3 = r3 + 0.05
                        endif
                    endif
                    if r > 1.5 and r < 2.5 then
                        set k2 = k2 - 13
                        call BlzSetSpecialEffectAlpha(e, k2)
                    endif
                    if r > 1.5 and r < 2.2 then
                        set k3 = k3 + 3
                        call BlzSetSpecialEffectAlpha(e5, k3)
                        call BlzSetSpecialEffectAlpha(e6, k3 * 2)
                        call BlzSetSpecialEffectAlpha(e4, k3 + 125)
                    endif
                else
                    call UnitRemoveAbility(c, GojoRCancel_ID)
                    if e != null then
                        call ColorEffDummy3(e, 0, 255, 255, 255, 0.35)
                    endif
                    if e2 != null then
                        call ColorEffDummy3(e2, 0, 255, 255, 255, 0.35)
                    endif
                    if e3 != null then
                        call ColorEffDummy3(e3, 0, 255, 255, 255, 0.35)
                    endif
                    if e4 != null then
                        call ColorEffDummy3(e4, 0, 255, 255, 255, 0.35)
                    endif
                    if e5 != null then
                        call ColorEffDummy3(e5, 0, 255, 255, 255, 0.35)
                    endif
                    if e6 != null then
                        call ColorEffDummy3(e6, 0, 255, 255, 255, 0.35)
                    endif
                    set e = null
                    set e = EffectSpawnColor("war3mapimported\\wos_almagest1.mdl", x, y, 1, 0.01, 0.01, 155, 255, 255, 255, 0)
                    call ScaleEffDummy(e, 0.06, 0.01, 4.75 * scale)
                    call ColorEffDummy4(e, 0.18, 255, 255, 255, 0.2)
                    call ColorEffDummy3(e, 0.4, 255, 255, 255, 0.2)
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_HakkeStart.mdx", x, y, 1, 2, 3, 5))
                    set e = EffectSpawnColor("war3mapimported\\wos_fuxuan-21.mdl", x, y, 1, 1.5, 6.75 * scale, 335, 255, 255, 255, 255)
                    call DestroyEffect(e)
                   // call ColorEffDummy4(e, 0.18, 255, 255, 255, 0.2)
                  //  call ColorEffDummy3(e, 0.4, 255, 255, 255, 0.2)
                    set e = null
                    set k = 0
                    loop
                        exitwhen k == 6
                        set e = EffectSpawnColor("war3mapimported\\wos_effect pieces2.mdl", x, y, 60 * k, 0, 0.01, 455, 255, 255, 255, 0)
                        call AnimDummyEff(e, 0.25, 0.65)
                        call ScaleEffDummy2(e, 0.35, 0.35, 0.01, 11.5 * scale)
                        call ColorEffDummy4(e, 0.35, 255, 255, 255, 0.2)
                        call ColorEffDummy3(e, 0.55, 255, 255, 255, 0.35)
                        set e = null
                        set k = k + 1
                    endloop
                    call UnitRemoveAbility(c, GojoRQ_ID)
                    call UnitRemoveAbility(c, GojoRW_ID)
                    call UnitRemoveAbility(c, GojoRR_ID)
                    if GetUnitAbilityLevel(c, GojoQ2_ID) > 0 then
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoQ2_ID, true)
                    else
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoQ_ID, true)
                    endif
                    if GetUnitAbilityLevel(c, GojoW2_ID) > 0 then
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoW2_ID, true)
                    else
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoW_ID, true)
                    endif
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoR_ID, true)
                    
                    call SaveInteger(hs, GetHandleId(c), StringHash("rt end "), 0)
                    call SaveInteger(hs, GetHandleId(c), StringHash("rt"), 0)
                    call SaveInteger(hs, GetHandleId(c), StringHash("gojo RR"), 0)
                    call SaveReal(hs, GetHandleId(c), StringHash("rt x"), 0)
                    call SaveReal(hs, GetHandleId(c), StringHash("rt y"), 0)
                    call MakeSound("war3mapImported\\Hero_Gojo_R7")
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set e5 = null
                    set e6 = null
                    set u = null
                    set m_GojoR[i] = m_GojoR[MUI_GojoR]
                    set MUI_GojoR = MUI_GojoR - 1
                    if MUI_GojoR == -1 then
                        call GojoTimer05Release()
                    endif
                    call destroy( )
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method GojoR_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_GojoR = MUI_GojoR + 1
            set m_GojoR[MUI_GojoR] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set g = CreateGroup()
            set u = null
            set r3 = 10
            set r7 = 1.8
            set e = null
            set e2 = null
            set e3 = null
            set e4 = null
            set e5 = null
            set e6 = null
            set a = GAngle2(c, x, y) // Angle Between points
            set aoe = GojoR_DamageAoe
            if GetHeroLevel(c) >= 35 then
                set aoe = aoe + GojoR_35lvl_AddAoe
            endif
            call SaveReal(hs, GetHandleId(c), StringHash("rt x"), x)
            call SaveReal(hs, GetHandleId(c), StringHash("rt y"), y)
            set dmg2 = GetHeroInt( c , true) * (GojoR_DamageIntFirst * GetUnitAbilityLevel( c , GojoR_ID))
            set dmg = GetHeroInt( c , true) * ( GojoR_DamageIntBase + ( GojoR_DamageIntStep * ( GetUnitAbilityLevel( c , GojoR_ID) - 1 ) ) )
            set rmax = 1.75 + GojoR_DurationBase + ( GojoR_DurationStep * ( GetUnitAbilityLevel( c , GojoR_ID) - 1 ) )
            if SR3(c, x, y) > aoe - 350 then
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1.8, 0))
                call PosUnit(c, x - (aoe - 350) * Cos(a), y - (aoe - 350) * Sin(a))
                call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_blackblink.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.35, 0, 0, 0, 0, 255))
            endif
            call SaveInteger(hs, GetHandleId(c), StringHash("rt"), 1)
            call SaveInteger(hs, GetHandleId(c), StringHash("gojo RR"), 0)
            call SaveInteger(hs, GetHandleId(c), StringHash("rt end "), 0)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoQ_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoQ2_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoW_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoW2_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoR_ID, false)
            call UnitAddAbility(c, GojoRQ_ID)
            call UnitAddAbility(c, GojoRW_ID)
            call UnitAddAbility(c, GojoRR_ID)
            call SetUnitAbilityLevel(c, GojoRQ_ID, GetUnitAbilityLevel(c, GojoR_ID))
            call SetUnitAbilityLevel(c, GojoRW_ID, GetUnitAbilityLevel(c, GojoR_ID))
            call SetUnitAbilityLevel(c, GojoRR_ID, GetUnitAbilityLevel(c, GojoR_ID))
            call UnitAddAbility(c, GojoRCancel_ID)
            call OkarunEggCd(c, GojoRR_ID, GojoRR_BaseCd)
            call StartSpellUnit(c)
            call SetUnitAnimationByIndex(c, 28)
            call EffectSpawn2("war3mapimported\\wos_az_g045.mdl", GetUnitX(c), GetUnitY(c), 1, 1.5, 2, 0, 0.8)
            call MakeSound("war3mapImported\\Hero_Gojo_R1")
            call MakeSound("war3mapImported\\Hero_Gojo_R2")
            set scale = aoe / 1000
            call VisionTimed(GetOwningPlayer(c), x, y, 1450, rmax)
            if MUI_GojoR == 0 then
                call GojoTimer05Acquire()
            endif
        endmethod

    endstruct

    private struct GojoSpells_T
        private static integer array m_GojoT
        private static integer MUI_GojoT = -1
        private static integer array m_GojoT2
        private static integer MUI_GojoT2 = -1
        unit c
        real x
        real y
        real x1
        real y1
        real x2
        real y2
        real r2
        integer k
        integer k2
        integer k3
        real scale
        real r3
        real r4
        real r5
        real r6
        real r7
        group g
        group g2
        unit u
        real dmg
        real a2
        integer check2
        real aoe
        real move
        real r
        effect e
        effect e2
        effect e3
        effect e4
        effect e5
        effect e6
        effect e7
        real a
        real rmax

        public static method Loop_GojoT takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real kr2 = 1
            local real kr3 = 1
            local real kr4 = 0.875
            loop
                exitwhen i > MUI_GojoT
                set this = m_GojoT[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r < 4.89 then
                        call DebugUnit(c)
                    endif
                    if r == 0.03 then
                        set a2 = GAngle5(e, GetEffX(e2), GetEffY(e2))
                        set x1 = GetUnitX(c) - 305 * Cos(a)
                        set y1 = GetUnitY(c) - 305 * Sin(a)
                        call StartSpellUnit(c)
                        call MakeSound("war3mapImported\\Hero_Gojo_T3")
                    endif
                    if r > 0.03 and r < 1.39 then
                        if r >= 1.09 then
                            call MoveEff2(e, 4.5 * kr4, a2)
                            call MoveEff2(e2, 4.5 * kr4, a2 + 180 * bj_DEGTORAD)
                        else
                            call MoveEff2(e, 8.5 * kr4, a2)
                            call MoveEff2(e2, 8.5 * kr4, a2 + 180 * bj_DEGTORAD)
                        endif
                    endif
                    if r > 0.69 and r < 1.34 then
                        if r7 > 0.06 then
                            set r7 = 0
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_m2 (573).mdx", x1, y1, 0.45, 1, 1.45, 1 ))
                        else
                            set r7 = r7 + 0.03
                        endif
                    endif
                    if r > 0.39 and r < 3.72 then
                        if r4 > 0.12 then
                            set r4 = 0
                            set k = 0
                            loop
                                exitwhen k == 2
                                set kr2 = GetRandomReal(450, 950)
                                set kr3 = GetRandomReal(0, 359)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_wtw-whitethunder-zi.mdl", GetUnitX(c) + kr2 * Cos(kr3), GetUnitY(c) + kr2 * Sin(kr3), GetRandomReal(0, 359), 1, 2, 1))
                                set k = k + 1
                            endloop
                        else
                            set r4 = r4 + 0.03
                        endif
                    endif
                    if r == 1.89 then
                        set scale = 2.3
                    endif
                    if r > 1.89 and r < 3.39 then
                        if r3 > 0.19 then
                            set r3 = 0
                            if scale < 3 then
                                set scale = scale + 0.1
                            endif
                        else
                            set r3 = r3 + 0.03
                        endif
                    endif
                    if r == 1.14 then
                        call SetUnitAnimationByIndex(c, 11)
                        call SetUnitTimeScale(c, 0.25)
                    endif
                    if r == 1.29 then
                        call MakeSound("war3mapImported\\Hero_Gojo_T10")
                        set k3 = 255
                    endif
                    if r > 1.29 and r < 1.89 then
                        set k3 = k3 - 15
                        if k3 < 0 then
                            set k3 = 0
                        endif
                        call BlzSetSpecialEffectAlpha(e, k3)
                        call BlzSetSpecialEffectAlpha(e2, k3)
                    endif
                    if r == 1.56 then
                        set k = 0
                        loop
                            exitwhen k == 6
                            set kr2 = GetRandomReal(350, 650)
                            set kr3 = GetRandomReal(0, 359)
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_wtw-whitethunder-zi.mdl", x1 + kr2 * Cos(kr3), y1 + kr2 * Sin(kr3), GetRandomReal(0, 359), 1, 2, 1))
                            set k = k + 1
                        endloop
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_Bubbles2_1purp.mdl", x1, y1, 1, 1, 2.75, 205))
                        call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_BubbleCamera.mdl", x1, y1, 0.15, 1.1, 4.25, 235 ), 0.1, 255, 255, 255, 0.35)
                    endif
                    if r == 1.86 then
                        call BlzPlaySpecialEffect(e, ANIM_TYPE_DEATH)
                        call BlzPlaySpecialEffect(e2, ANIM_TYPE_DEATH)
                        call MyRemoveEff(e, 0.5)
                        call MyRemoveEff(e2, 0.5)
                        set e = null
                        set e2 = null
                        call RemoveSavedHandle(hs, GetHandleId(c), StringHash("eff blue"))
                        call RemoveSavedHandle(hs, GetHandleId(c), StringHash("eff red"))
                        call MakeSound("war3mapImported\\Hero_Gojo_T5")
                        call MakeSound("war3mapImported\\Hero_Gojo_T4")
                        set e3 = EffectSpawn("war3mapimported\\wos_rasenganbiru_purp4.mdl", GetUnitX(c) + 550 * Cos(a), GetUnitY(c) + 550 * Sin(a), a * bj_RADTODEG, 1, 0.35, 225)
                        set e4 = EffectSpawn("war3mapimported\\wos_WTW-Wood_NEF_Odr-Ci.mdl", GetEffX(e3), GetEffY(e3), GetRandomReal(0, 359), 3, scale, 255)
                        call ScaleEffDummy(e3, 1, 0.35, 1.28)
                        set x2 = GetUnitX(c)
                        set y2 = GetUnitY(c)
                        set MouseX[GetPlayerId(GetOwningPlayer(c))] = x
                        set MouseY[GetPlayerId(GetOwningPlayer(c))] = y
                        call MouseOn(GetOwningPlayer(c))
                        
                        call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("povorot"), 1)
                        call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("purple"), 1)
                        set e5 = EffectSpawn("war3mapImported\\wos_T_Button.mdx", GetUnitX(c) - 100 * Cos(a + 25 * bj_DEGTORAD), GetUnitY(c) - 100 * Sin(a + 25 * bj_DEGTORAD), 270, 1.5, 1.75, 650)
                        call BlzSetSpecialEffectAlpha(e5, 0)
                        set r6 = GojoT_PushRange
                        if GetLocalPlayer() == GetOwningPlayer(c) then
                            call BlzSetSpecialEffectAlpha(e5, 255)
                        endif
                    endif
                    if r > 1.96 and r < 4.9 then
                        set x = GetMouseX(GetOwningPlayer(c))
                        set y = GetMouseY(GetOwningPlayer(c))
                        set r6 = r6 + 7.5
                        set a = GAngle2(c, x, y)
                        call SetUnitFacing(c, a * bj_RADTODEG)
                        call BlzSetSpecialEffectPosition(e5, GetUnitX(c) - 100 * Cos(a + 25 * bj_DEGTORAD), GetUnitY(c) - 100 * Sin(a + 25 * bj_DEGTORAD), 650)
                        if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("skip t")) == 1 then
                            set r = 4.89
                            call BlzPlaySpecialEffect(e5, ANIM_TYPE_BIRTH)
                            call MyRemoveEff(e5, 0.35)
                            call ColorEffDummy3(e5, 0.35, 255, 255, 255, 0.36)
                            set e5 = null
                            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("purple"), 0)
                            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("skip t"), 0)
                        endif
                        call SetUnitPosition(c, x2, y2)
                        call BlzSetSpecialEffectPosition(e3, GetUnitX(c) + 580 * Cos(a), GetUnitY(c) + 580 * Sin(a), 225)
                        call BlzSetSpecialEffectPosition(e4, GetUnitX(c) + 580 * Cos(a), GetUnitY(c) + 580 * Sin(a), 255)
                        call BlzSetSpecialEffectScale(e4, scale)
                        call SetUnitAnimationByIndex(c, 12)
                    endif
                    if r == 1.89 then
                        call MakeSound("war3mapImported\\Hero_Gojo_T9")
                    endif
                    if r == 4.89 then
                        call DestroyEffect(e7)
                        call DestroyEffect(e4)
                        if e5 != null then
                            call ColorEffDummy3(e5, 0.35, 255, 255, 255, 0.36)
                            set e5 = null
                        endif
                        set move = 120
                        set r4 = 0
                        set r2 = 10
                        call StopSpellUnit(c)
                        call MakeSound("war3mapImported\\Hero_Gojo_T6")
                        call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("purple"), 0)
                        call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("povorot"), 0)
                    endif
                    if r == 5.19 then
                        call MakeSound("war3mapImported\\Hero_Gojo_T7")
                    endif
                    if r > 4.89 then
                        if CheckCoordsInRect(gg_rct_Arena, GetEffX(e3) + move * Cos(a), GetEffY(e3) + move * Sin(a)) then
                            call MoveEff2(e3, move, a)
                        endif
                        if r3 > 0.06 then
                            set r3 = 0
                            set k = 0
                            loop
                                exitwhen k == 2
                                set kr2 = GetRandomReal(350, 550)
                                set kr3 = GetRandomReal(0, 359)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_wtw-whitethunder-zi.mdl", GetEffX(e3) + kr2 * Cos(kr3), GetEffY(e3) + kr2 * Sin(kr3), GetRandomReal(0, 359), 1, 2, 1))
                                set k = k + 1
                            endloop
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_opm (664).mdl", GetEffX(e3), GetEffY(e3), a * bj_RADTODEG, 1, 1.32, 205, 155, 85, 255, 255))
                        else
                            set r3 = r3 + 0.03
                        endif
                        if r2 > 0.12 then
                            set r2 = 0
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_opdef (100)11.mdl", GetEffX(e3), GetEffY(e3), GetRandomReal(0, 359), 1, 0.3, 0), 0.35, 255, 255, 255, 0.75)
                        else
                            set r2 = r2 + 0.03
                        endif
                        if r5 > 0.03 then
                            set r5 = 0
                            set x = GetEffX(e3)
                            set y = GetEffY(e3)
                            if check2 == 0 then
                                call DecorRemove(c, x, y, aoe * 1.2, 100)
                                call VisionTimed(GetOwningPlayer(c), x, y, 1450, 2)
                            endif
                            set check2 = check2 + 1
                            if check2 >= 4 then
                                set check2 = 0
                            endif
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, null)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u, g2) == false then
                                    call dmgmag(c, u, dmg)
                                    call GroupAddUnit(g2, u)
                                 //   call StunUnit(c,u,10)
                                    call MUE(u, r6, GojoT_PushDuration, a)
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        else
                            set r5 = r5 + 0.03
                        endif
                    endif
                else
                    if e != null then
                        call ColorEffDummy3(e, 0, 255, 255, 255, 0.35)
                    endif
                    if e2 != null then
                        call ColorEffDummy3(e2, 0, 255, 255, 255, 0.35)
                    endif
                    if r > 1.86 then
                        call ColorEffDummy3(e3, 0, 255, 255, 255, 0.35)
                    else
                        call RemoveSavedHandle(hs, GetHandleId(c), StringHash("eff blue"))
                        call RemoveSavedHandle(hs, GetHandleId(c), StringHash("eff red"))
                    endif
                    call SaveInteger(hs, GetHandleId(c), StringHash("purple s"), 0)
                    call MouseOff(GetOwningPlayer(c))
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("purple"), 0)
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("skip t"), 0)
                    if r < 4.89 then
                        call SaveInteger(hs, GetHandleId(c), StringHash("povorot"), 0)
                        call DestroyEffect(e7)
                        call DestroyEffect(e4)
                        call StopSpellUnit(c)
                    endif
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set e5 = null
                    set e6 = null
                    set e7 = null
                    set u = null
                    set m_GojoT[i] = m_GojoT[MUI_GojoT]
                    set MUI_GojoT = MUI_GojoT - 1
                    if MUI_GojoT == -1 then
                        call GojoTimer03Release()
                    endif
                    call destroy( )
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method GojoT_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_GojoT = MUI_GojoT + 1
            set m_GojoT[MUI_GojoT] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set r3 = 110
            set check2 = 0
            set e3 = null
            set e4 = null
            set e5 = null
            set e6 = null
            call SaveInteger(hs, GetHandleId(c), StringHash("t cur1"), 0)
            call SaveInteger(hs, GetHandleId(c), StringHash("t cur2"), 0)
            set a = GAngle2(c, x, y) // Angle Between points
            set aoe = GojoT_DamageAoe
            call SaveInteger(hs, GetHandleId(c), StringHash("purple"), 0)
            set dmg = GetHeroInt( c , true) * GojoT_DamageIntBase
            set rmax = 8.5
            call SetUnitFacingTimed(c, a * bj_RADTODEG, 0)
            call StartSpellUnit(c)
            call SetUnitAnimationByIndex(c, 25)
            call MakeSound("war3mapImported\\Hero_Gojo_T8")
            set e7 = EffectSpawn("war3mapimported\\Gear_opdef (429).mdl", GetUnitX(c), GetUnitY(c), 1, 1, 1, 0)
            set e = LoadEffectHandle(hs, GetHandleId(c), StringHash("eff blue"))
            set e2 = LoadEffectHandle(hs, GetHandleId(c), StringHash("eff red"))
            call SaveInteger(hs, GetHandleId(c), StringHash("purple s"), 1)
            call BlzSetSpecialEffectPosition(e, (GetUnitX(c) - 300 * Cos(a)) + 300 * Cos(a - 90 * bj_DEGTORAD), (GetUnitY(c) - 300 * Sin(a)) + 300 * Sin(a - 90 * bj_DEGTORAD), BlzGetLocalUnitZ(c) + 255)
            call BlzSetSpecialEffectPosition(e2, (GetUnitX(c) - 300 * Cos(a)) + 300 * Cos(a + 90 * bj_DEGTORAD), (GetUnitY(c) - 300 * Sin(a)) + 300 * Sin(a + 90 * bj_DEGTORAD), BlzGetLocalUnitZ(c) + 255)
            if MUI_GojoT == 0 then
                call GojoTimer03Acquire()
            endif
        endmethod

        public static method Loop_GojoT22 takes nothing returns nothing
            local thistype this
            local integer i = 0
            local real krr = 0
            local real kr1 = 300
            loop
                exitwhen i > MUI_GojoT2
                set this = m_GojoT2[i]
                if SpellBoolCaster(c) and r <= rmax and LoadInteger(hs, GetHandleId(c), StringHash("purple s")) == 0 then
                    set a = GetUnitFacing(c) * bj_DEGTORAD
                    call BlzSetSpecialEffectPosition(e7, GetUnitX(c), GetUnitY(c), BlzGetLocalUnitZ(c) + 3)
                    if check2 == 2 then
                        call BlzSetSpecialEffectPosition(e, (GetUnitX(c) - 300 * Cos(a)) + kr1 * Cos(a - 90 * bj_DEGTORAD), (GetUnitY(c) - 300 * Sin(a)) + kr1 * Sin(a - 90 * bj_DEGTORAD), BlzGetLocalUnitZ(c) + 255)
                    endif
                    if k3 == 2 then
                        call BlzSetSpecialEffectPosition(e2, (GetUnitX(c) - 300 * Cos(a)) + kr1 * Cos(a + 90 * bj_DEGTORAD), (GetUnitY(c) - 300 * Sin(a)) + kr1 * Sin(a + 90 * bj_DEGTORAD), BlzGetLocalUnitZ(c) + 255)
                    endif
                    if LoadInteger(hs, GetHandleId(c), StringHash("t cur1")) == 1 and check2 < 2 then
                        call DebugUnit2(c)
                        if check2 == 0 then
                            set check2 = 1
                            set r5 = 0
                        endif
                        set krr = 1
                        set r5 = RoundReal(r5 + 0.03, 3)
                        if r5 == 1.59 then
                            call EffectSpawn2("war3mapImported\\wos_FSAeff (85)_002.mdl", (GetUnitX(c) - 350 * Cos(a)) + kr1 * Cos(a - 90 * bj_DEGTORAD), (GetUnitY(c) - 350 * Sin(a)) + kr1 * Sin(a - 90 * bj_DEGTORAD), 1.5, 1, 1, 255, 0.5)
                            set e = EffectSpawn("war3mapImported\\wos_wtw-1r2-cang11.mdl", (GetUnitX(c) - 350 * Cos(a)) + kr1 * Cos(a - 90 * bj_DEGTORAD), (GetUnitY(c) - 350 * Sin(a)) + kr1 * Sin(a - 90 * bj_DEGTORAD), 0.5, 1, 0.8, 255)
                            call SaveEffectHandle(hs, GetHandleId(c), StringHash("eff blue"), e)
                            set check2 = 2
                            call StopSpellUnit2(c)
                        endif
                    endif
                    if LoadInteger(hs, GetHandleId(c), StringHash("t cur2")) == 1 and k3 < 2 then
                        call DebugUnit2(c)
                        set krr = 1
                        if k3 == 0 then
                            call SetUnitAnimationByIndex(c, 25)
                            set k3 = 1
                            call MakeSound("war3mapImported\\Hero_Gojo_T2")
                            set r5 = 0
                        endif
                        set r5 = RoundReal(r5 + 0.03, 3)
                        if r5 == 1.41 then
                            call EffectSpawn2("war3mapImported\\wos_FSAeff (85)_001.mdl", (GetUnitX(c) - 350 * Cos(a)) + kr1 * Cos(a + 90 * bj_DEGTORAD), (GetUnitY(c) - 350 * Sin(a)) + kr1 * Sin(a + 90 * bj_DEGTORAD), 1.5, 1, 1, 255, 0.5)
                        endif
                        if r5 == 1.47 then
                            set k3 = 2
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoT_ID, true)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoT2_ID, false)
                            call UnitAddAbility(c, GojoT_ID)
                            set e2 = EffectSpawn("war3mapImported\\wos_WTW-1R2-He11.mdl", (GetUnitX(c) - 350 * Cos(a)) + kr1 * Cos(a + 90 * bj_DEGTORAD), (GetUnitY(c) - 350 * Sin(a)) + kr1 * Sin(a + 90 * bj_DEGTORAD), 0.5, 1, 0.8, 255)
                            call SaveEffectHandle(hs, GetHandleId(c), StringHash("eff red"), e2)
                            call StopSpellUnit2(c)
                        endif
                    endif
                    if krr == 0 and IsUnitPaused(c) == false then
                        set r = RoundReal(r + 0.03, 3)
                        call BlzFrameSetValue(frame2_pas3[k2], rmax - (r + 0.1))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                    endif
                else
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame2_pas1[k2], false)
                    endif
                    if LoadInteger(hs, GetHandleId(c), StringHash("purple s")) == 0 then
                        if e != null then
                            call ColorEffDummy3(e, 0, 255, 255, 255, 0.35)
                        endif
                        if e2 != null then
                            call ColorEffDummy3(e2, 0, 255, 255, 255, 0.35)
                        endif
                        call RemoveSavedHandle(hs, GetHandleId(c), StringHash("eff blue"))
                        call RemoveSavedHandle(hs, GetHandleId(c), StringHash("eff red"))
                    endif
                    call SaveInteger(hs, GetHandleId(c), StringHash("purple s"), 0)
                    call StopSpellUnit2(c)
                    call OkarunEggCd(c, GojoT2_ID, BlzGetUnitAbilityCooldown(c, GojoT_ID, 0))
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoT2_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), GojoT_ID, false)
                    call SaveInteger(hs, GetHandleId(c), StringHash("t cur1"), 0)
                    call SaveInteger(hs, GetHandleId(c), StringHash("t cur2"), 0)
                    call DestroyEffect(e7)
                    set c = null
                    set e = null
                    set e2 = null
                    set e7 = null
                    set m_GojoT2[i] = m_GojoT2[MUI_GojoT2]
                    set MUI_GojoT2 = MUI_GojoT2 - 1
                    if MUI_GojoT2 == -1 then
                        call GojoTimer03Release()
                    endif
                    call destroy( )
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method GojoT2_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_GojoT2 = MUI_GojoT2 + 1
            set m_GojoT2[MUI_GojoT2] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set a = GetUnitFacing(c) * bj_DEGTORAD
            set rmax = 15
            set r = 0
            set r5 = 0
            set e = null
            set e2 = null
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set check2 = 0
            set k3 = 0
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
                call BlzFrameSetValue(frame2_pas3[k2], rmax - (r + 0.1))
                set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame2_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.2175)
                call BlzFrameSetSize(frame2_pas4[k2], 0.0275, 0.0275)
                call BlzFrameSetTexture(frame2_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Gojo_T2", 0, false)
                set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame2_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.2225)
                call BlzFrameSetText(frame2_pas5[k2], "|c00FFFF00" + "Purple prepare:" + "|r")
                call BlzFrameSetScale(frame2_pas5[k2], 0.9)
                set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frame2_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.2075)
                call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                call BlzFrameSetScale(frame2_pas6[k2], 0.9)
            else
                if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frame2_pas1[k2], true)
                endif
                call BlzFrameSetValue(frame2_pas3[k2], rmax - (r + 0.1))
            endif
            call StartSpellUnit2(c)
            call SetUnitAnimationByIndex(c, 25)
            set e7 = EffectSpawn("war3mapimported\\Gear_opdef (429).mdl", GetUnitX(c), GetUnitY(c), 1, 1, 1, 0)
            call MyRemoveEff(e7, rmax)
            if MUI_GojoT2 == 0 then
                call GojoTimer03Acquire()
            endif
        endmethod

    endstruct

    private function GojoTimer03Loop takes nothing returns nothing
        call GojoSpells_Q.Loop_GojoQ()
        call GojoSpells_Q.Loop_GojoQ2()
        call GojoSpells_W.Loop_GojoW()
        call GojoSpells_W.Loop_GojoW2()
        call GojoSpells_E.Loop_GojoE()
        call GojoSpells_R.Loop_GojoR2()
        call GojoSpells_T.Loop_GojoT()
        call GojoSpells_T.Loop_GojoT22()
    endfunction

    private function GojoTimer05Loop takes nothing returns nothing
        call GojoSpells_R.Loop_GojoR()
    endfunction

    private function InitGojoSpells takes nothing returns nothing
        set GojoTimer03 = CreateTimer()
        set GojoTimer05 = CreateTimer()
        set GojoTimer03Callback = function GojoTimer03Loop
        set GojoTimer05Callback = function GojoTimer05Loop
    endfunction

    //----------------------------Gojo-----------------------------------------------
     /* Animations index:
    1 - move
    2 - fast move
    4 - e
    7 - q2 1
    6 - q2 2
    11 - w start, 11 - t start
    12 - w channel
    13 - w end
    22 - q
    23 - q2 analog
    28 - r
    25 - t start
     */ 
    function GojoPas_Start takes unit c, integer id returns nothing
        local real mana = BlzGetUnitAbilityManaCost(c, id, GetUnitAbilityLevel(c, id) - 1) * (Gojo_G_ManaRestore / 100)
        if GetHeroLevel(c) >= 12 then
            call MPS(c, mana, Gojo_G_ManaRestoreTime)
        endif
    endfunction
    function GojoQ_Start takes unit c, real x, real y returns nothing
        call GojoSpells_Q.GojoQ_Start( c, x, y )
        call GojoPas_Start(c, GojoQ_ID)
    endfunction
    function GojoW_Start takes unit c, real x, real y returns nothing
        call GojoSpells_W.GojoW_Start( c, x, y )
        call GojoPas_Start(c, GojoW_ID)
    endfunction
    function GojoQ2_Start takes unit c, real x, real y returns nothing
        call GojoSpells_Q.GojoQ_Start( c, x, y )
        call GojoPas_Start(c, GojoQ2_ID)
    endfunction
    function GojoW2_Start takes unit c, real x, real y returns nothing
        call GojoSpells_W.GojoW_Start( c, x, y )
        call GojoPas_Start(c, GojoW2_ID)
    endfunction
    function GojoE_Start takes unit c returns nothing
        call GojoSpells_E.GojoE_Start( c )
        call GojoPas_Start(c, GojoE_ID)
    endfunction
    function GojoE2_Start takes unit c returns nothing
        call SaveInteger(hs, GetHandleId(c), StringHash("turn off e"), 1)
    endfunction
    function GojoR_Start takes unit c, real x, real y returns nothing
        call GojoSpells_R.GojoR_Start( c, x, y )
        call GojoPas_Start(c, GojoR_ID)
    endfunction
    function GojoR2_Start takes unit c returns nothing
        call SaveInteger(hs, GetHandleId(c), StringHash("rt end "), 1)
    endfunction
    function GojoRQ_Start takes unit c, real x, real y returns nothing
        call GojoSpells_Q.GojoQ2_Start( c, x, y )
        call GojoPas_Start(c, GojoRQ_ID)
    endfunction
    function GojoRW_Start takes unit c, unit td returns nothing
        call GojoSpells_W.GojoW2_Start( c, td )
        call GojoPas_Start(c, GojoRW_ID)
    endfunction
    function GojoRR_Start takes unit c returns nothing
        call GojoSpells_R.GojoR2_Start( c )
        call GojoPas_Start(c, GojoRR_ID)
    endfunction
    function GojoT_Start takes unit c, real x, real y returns nothing
        call GojoSpells_T.GojoT_Start( c, x, y)
        call GojoPas_Start(c, GojoT_ID)
    endfunction
    function GojoT2_Start takes unit c returns nothing
        local integer id = LoadInteger(hs, GetHandleId(c), StringHash("t cur1"))
        local integer id2 = LoadInteger(hs, GetHandleId(c), StringHash("t cur2"))
        call GojoPas_Start(c, GojoT2_ID)
        if id == 0 then
            call SaveInteger(hs, GetHandleId(c), StringHash("t cur1"), 1)
            call GojoSpells_T.GojoT2_Start(c)
            call MakeSound("war3mapImported\\Hero_Gojo_T8")
            call MakeSound("war3mapImported\\Hero_Gojo_T1")
        elseif id2 == 0 then
            call SaveInteger(hs, GetHandleId(c), StringHash("t cur2"), 1)
        endif
    endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
