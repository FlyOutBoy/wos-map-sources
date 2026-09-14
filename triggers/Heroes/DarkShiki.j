library DarkShikiSpells uses GearSystems
    globals
//--------------------------------------DarkShiki--------------------------------------------------------------
        integer DarkShiki_ID = 'H01K'
        integer DarkShikiF_ID = 'A09J'
        integer DarkShiki_Clone_ID = 'h01L' // dummmy id used for post clone effect
        real DarkShikiG_Damage = 1 // 1x agi for each cause stack
        real DarkShikiG_Damage35BonusAdd = 0.5 // add bonus to prev damage
        real DarkShikiG_StackFinalDamage = 4 // when trigger next passive after 3 - th stack , cause this amount of damage and remove stacks
        real DarkShikiG_StackFinalDamage35BonusAdd = 2 // add bonus to prev damage
        real DarkShikiG_StackFinalSilenceDuration = 2 // from 0.1 to 3.0 , final big damage will cause stun for this time
        real DarkShikiG_Time = 5 // in seconds
        real DarkShikiG_Time35BonusAdd = 2 // in seconds
//---------------Q ability-----------------------------------------------------
        integer DarkShikiQ_ID = 'A09D'
        integer DarkShikiQ2_ID = 'A09E'
        real DarkShikiQ_RangeBase = 1150
        real DarkShikiQ_RangeStep = 100
        real DarkShikiQ_BackToPosDurationBase = 2 // how much time after dash end he have to back to cast position
        real DarkShikiQ_BackToPosDurationStep = 0.5 // how much time after dash end he have to back to cast position
        real DarkShikiQ_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real DarkShikiQ_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real DarkShikiQ_Damage2StaticBase = 200 // base static damage for 1 level
        real DarkShikiQ_Damage2StaticStep = 0 // additional static damage for each next level
        real DarkShikiQ_DamageAoe = 330
//---------------W ability-----------------------------------------------------
        integer DarkShikiW_ID = 'A09F'
        real DarkShikiW_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real DarkShikiW_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real DarkShikiW_Damage2StaticBase = 150 // base static damage for 1 level
        real DarkShikiW_Damage2StaticStep = 0 // additional static damage for each next level
       // integer DarkShikiW_SilenceDuration = 2 // in seconds, from 2 to 4
//---------------E ability-----------------------------------------------------
        integer DarkShikiE_ID = 'A09G'
        real DarkShikiE_Stun = 1 // from 0.1 to 3
        real DarkShikiE_DamageAgiBase = 2 // base number x Agi damage for 1 level
        real DarkShikiE_DamageAgiStep = 1 // additional number x Agi damage for each next level
//---------------R ability-----------------------------------------------------
        integer DarkShikiR_ID = 'A09H'
        real DarkShikiR_DamageAgiBase = 4 // base number x Agi damage per 1 second
        real DarkShikiR_DamageAgiStep = 1 // additional number x Agi damage for each next level per second
        real DarkShikiR_DamageAoe = 600
        real DarkShikiR_Stun = 0 // from 0.1 to 3
//---------------T ability-----------------------------------------------------
        integer DarkShikiT_ID = 'A09I'
        real DarkShikiT_Stun = 0 // from 0.1 to 3
        real DarkShikiT_DamageAgiBase = 9 // base number x Agi damage for 1 level
//---------------G ability-----------------------------------------------------
        integer DarkShikiG_ID = 'A0CO'
        real DarkShikiG_Stun = 0 // from 0.1 to 3
        real DarkShikiG_DamageAoe = 500
        real DarkShikiG_DamageAgiBase = 5 // base number x Agi damage for 1 level
    endglobals
     function  ShikiClone takes unit c, integer k, real r5, real timescale returns nothing
            local unit d = CreateUnit(GetOwningPlayer(c), DarkShiki_Clone_ID, GetUnitX(c), GetUnitY(c), GetUnitFacing(c))
            call SetScale(d, BlzGetUnitRealField(c, UNIT_RF_SCALING_VALUE))
            call SetUnitVertexColor(d, 255, 255, 255, 255)
            call SetUnitTimeScale(d, timescale)
            call SetFly(d, GetUnitFlyHeight(c))
            call SetUnitAnimationByIndex(d, k)
            call AnimDummy(d, r5, 0)
            call ColorDummy2(d, 0.06, 255, 255, 255, 255, 0.33)
            call MyRemoveUnit(d, 0.39)
            set d = null
    endfunction
    private struct DarkShikiPas_KS
        private static timer t_DarkShikiPas = CreateTimer( )
        private static integer array m_DarkShikiPas
        private static integer MUI_DarkShikiPas = -1
        unit c
        unit td
        real x
        real y
        real r2
        real scale
        real scale2
        real r5
        real fly
        real dmg
        integer check
        integer check2
        real r
        effect e
        effect e2
        effect e3
        real a
        real rmax
        private static method Loop_DarkShikiPas takes nothing returns nothing
            local integer this
            local integer i = 0
            local integer h
            local integer sh
            loop
                exitwhen i > MUI_DarkShikiPas
                set this = m_DarkShikiPas[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r < rmax and LoadUnitHandle(hs, GetHandleId(c), StringHash("passive target")) == td and CheckCoordsInRect(gg_rct_Base, GetUnitX(td), GetUnitY(td)) == false then
                    if LoadInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause")) == 0 then
                        set r = r + 0.03
                        call BlzSetSpecialEffectTimeScale(e3, r5)
                    else
                        call BlzSetSpecialEffectTimeScale(e3, 0)
                    endif
                    set r = S2R( R2SW( r , 0, 3 ) )
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call EffVision(e2, td)
                    call EffVision2(e3, c)
                    set h = GetHandleId(td)
                    set sh = StringHash("DarkShiki pas")
                    set fly = GetUnitFlyHeight(td)
                    if LoadInteger(hs, h, sh) > check then
                        set check = LoadInteger(hs, h, sh)
                        set r = 0
                        set r2 = 11
                        if check == 2 and check2 == 1 then
                            call DestroyEffect(e)
                            set e = null
                            set e = EffectSpawn("war3mapImported\\wos_DarkShikiClock_2.mdx", x, y, 0, scale2, scale, 0)
                        elseif check == 3 and check2 == 1 then
                            call DestroyEffect(e)
                            set e = null
                            set e = EffectSpawn("war3mapImported\\wos_DarkShikiClock_3.mdx", x, y, 0, scale2, scale, 0)
                        elseif check == 4 and check2 == 1 then
                            call DestroyEffect(e)
                            call NextSound("war3mapimported\\Hero_DarkShiki_Stack4", 0.21)
                            set e = null
                            set e = EffectSpawn("war3mapImported\\wos_DarkShikiClock_4.mdx", x, y, 0, scale2, scale, 0)
                        elseif check == 5 and check2 == 1 then
                            call DestroyEffect(e)
                            set e = null
                            set e = EffectSpawn("war3mapImported\\wos_DarkShikiClock_5.mdx", x, y, 0, scale2, scale, 0)
                        endif
                        if check > 3 then
                            set check = 6
                            set r = 9999
                            call SaveInteger(hs, h, sh, 0)
                            call SilenceUnit(c, td, DarkShikiG_StackFinalSilenceDuration)
                            if GetHeroLevel(c) >= 35 then
                                set dmg = (DarkShikiG_StackFinalDamage + DarkShikiG_StackFinalDamage35BonusAdd) * GetHeroAgi(c, true)
                            else
                                set dmg = DarkShikiG_StackFinalDamage * GetHeroAgi(c, true)
                            endif
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-Hit-red.mdl", x, y, a * bj_RADTODEG, 1, 2.25, 135))
                        else
                            if GetHeroLevel(c) >= 35 then
                                set dmg = (DarkShikiG_Damage + DarkShikiG_Damage35BonusAdd) * GetHeroAgi(c, true)
                            else
                                set dmg = DarkShikiG_Damage * GetHeroAgi(c, true)
                            endif
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_ldeff (5).mdx", x, y, GAngle(c, td) * bj_RADTODEG, 1, 2.5, 165))
                        endif
                        call BlzPlaySpecialEffect(e3, ANIM_TYPE_STAND)
                        call NextDmg(c, td, dmg, 0, 0.05)
                    endif
                    if check2 == 1 then
                        call EffVision(e, td)
                        call BlzSetSpecialEffectX(e, x)
                        call BlzSetSpecialEffectY(e, y)
                        call BlzSetSpecialEffectZ(e, fly)
                        call BlzSetSpecialEffectX(e2, x)
                        call BlzSetSpecialEffectY(e2, y)
                        call BlzSetSpecialEffectZ(e2, fly)
                        call BlzSetSpecialEffectYaw(e2, (GetUnitFacing(td) + 180) * bj_DEGTORAD)
                        call BlzSetSpecialEffectX(e3, GetUnitX(c))
                        call BlzSetSpecialEffectY(e3, GetUnitY(c))
                        call BlzSetSpecialEffectZ(e3, GetUnitFlyHeight(c) + 155)
                        call BlzSetSpecialEffectYaw(e3, (GetUnitFacing(c)) * bj_DEGTORAD)
                    endif
                else
                    set h = GetHandleId(td)
                    set sh = StringHash("DarkShiki pas")
                    call DestroyEffect(e)
                    call ColorEffDummy3(e2, 0, 255, 255, 255, 0.12)
                    call BlzSetSpecialEffectAlpha(e3,0)
                    call DestroyEffect(e3)
                    call SaveInteger(hs, h, sh, 0)
                    set c = null
                    set td = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set m_DarkShikiPas[i] = m_DarkShikiPas[ MUI_DarkShikiPas]
                    set MUI_DarkShikiPas = MUI_DarkShikiPas - 1
                    if MUI_DarkShikiPas == -1 then
                        call PauseTimer( t_DarkShikiPas)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method DarkShikiPas_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_DarkShikiPas = MUI_DarkShikiPas + 1
            set m_DarkShikiPas[ MUI_DarkShikiPas] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set scale = 4
            set scale2 = 0.85
            set check = LoadInteger(hs, GetHandleId(td), StringHash("DarkShiki pas"))
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set dmg = GetHeroAgi( c , true) * DarkShikiG_Damage
            set check2 = 0
            if GetHeroLevel(c) >= 35 then
                set r5 = 0.14
                set rmax = DarkShikiG_Time + DarkShikiG_Time35BonusAdd
            else
                set r5 = 0.21
                set rmax = DarkShikiG_Time
            endif
            if IsUnitIllusion(td) == false then
                set check2 = 1
            endif
            if check2 == 1 then          
                            if GetHeroLevel(c) >= 35 then
                                set dmg = (DarkShikiG_Damage + DarkShikiG_Damage35BonusAdd) * GetHeroAgi(c, true)
                            else
                                set dmg = DarkShikiG_Damage * GetHeroAgi(c, true)
                            endif
                call DestroyEffect(EffectSpawn("war3mapimported\\wos_ldeff (5).mdx", x, y, GAngle(c, td) * bj_RADTODEG, 1, 2.5, 165))
                call NextDmg(c, td, dmg, 0, 0.05)
                set e3 = EffectSpawn("war3mapImported\\wos_ShikiCounter.mdl", GetUnitX(c), GetUnitY(c), 0, r5, 4.5, 155)
                set e2 = EffectSpawn("war3mapimported\\wos_AZ_EVEMD.mdl", x, y, 0, scale2, 1.75, 1)
                set e = EffectSpawn("war3mapImported\\wos_DarkShikiClock_1.mdl", x, y, 0, scale2, scale, 0)
            endif
            if MUI_DarkShikiPas == 0 then
                call TimerStart( t_DarkShikiPas, 0.03, true, function thistype.Loop_DarkShikiPas)
            endif
        endmethod
    endstruct

    private struct DarkShikiPassive_KS
        public static method DarkShikiPassiveApply takes unit c, unit td returns nothing
            local integer i = GetPlayerId(GetOwningPlayer(td))
            local integer h = GetHandleId(td)
            local integer sh = StringHash("DarkShiki pas")
            local unit d = LoadUnitHandle(hs, GetHandleId(c), StringHash("passive target"))
            if GetHeroLevel(c) >= 6 and GetUnitAbilityLevel(td, 'Aloc') == 0 and IsUnitType(td,UNIT_TYPE_HERO) then
                if d != td then
                endif
                if LoadInteger(hs, h, sh) == 0 or d != td then
                    call SaveInteger(hs, h, sh, 1)
                    call SaveUnitHandle(hs, GetHandleId(c), StringHash("passive target"), td)
                    call DarkShikiPas_KS.DarkShikiPas_Start(c, td)
                elseif LoadInteger(hs, h, sh) == 1 and d == td then
                    call SaveInteger(hs, h, sh, 2)
                elseif LoadInteger(hs, h, sh) == 2 and d == td then
                    call SaveInteger(hs, h, sh, 3)
                elseif LoadInteger(hs, h, sh) == 3 and d == td then
                    call SaveInteger(hs, h, sh, 4)
                elseif LoadInteger(hs, h, sh) == 4 and d == td then
                    call SaveInteger(hs, h, sh, 5)
                elseif LoadInteger(hs, h, sh) == 5 and d == td then
                    call SaveInteger(hs, h, sh, 6)
                endif
            endif
            set d = null
        endmethod
    endstruct

    private struct DarkShikiQ_KS
        private static timer t_DarkShikiQ = CreateTimer( )
        private static integer array m_DarkShikiQ
        private static integer MUI_DarkShikiQ = -1
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
        real scale
        real r3
        real r5
        real r6
        group g
        group g2
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
        framehandle array frame2_pas1 [10]
        framehandle array frame2_pas2 [10]
        framehandle array frame2_pas3 [10]
        framehandle array frame2_pas4 [10]
        framehandle array frame2_pas5 [10]
        framehandle array frame2_pas6 [10]
        private static method Loop_DarkShikiQ takes nothing returns nothing
            local integer this
            local integer i = 0
            local real tmp_y = 0
            loop
                exitwhen i > MUI_DarkShikiQ
                set this = m_DarkShikiQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if check == 0 then
                        if r == r6 then
                            call PauseUnit( c , false)
                            call SaveInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause"), 0)
                            call SetUnitAnimationByIndex( c , 33)
                            call SetUnitTimeScale(c, 2.5)
                            call MakeSound("war3mapimported\\Hero_DarkShiki_Q2")
                        endif
                        if r == r6+0.12 then
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-ESFX-4.mdl", x1, y1, a * bj_RADTODEG, 1.2, 3.55 * r5, 0))
                        endif
                        if r == r6 then
                            set x1 = GetUnitX(c) + (475 * r5) * Cos(a)
                            set y1 = GetUnitY(c) + (475 * r5) * Sin(a)
                        endif
                        if r >= r6 then
                            set x = GetUnitX(c)
                            set y = GetUnitY(c)
                            if r2 > 0.0 then
                                set r2 = 0
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_tx-ha-chongfeng2.mdl", x, y, a * bj_RADTODEG, GetRandomReal(1.25, 1.75), 4.5, 0, 255, 55, 25, 125))
                            else
                                set r2 = r2 + 0.03
                            endif
                            call MoveUnit(c, move, a)
                            call DecorRemove(c, x, y, aoe, 20)
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                    call GroupAddUnit(g2, u)
                                    if IsUnitIllusion(u) == false and check2 == 0 then
                                        call DarkShikiPassive_KS.DarkShikiPassiveApply(c, u)
                                        set check2 = 1
                                    endif
                                    call dmgphys(c, u, dmg)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        endif
                        if r == rmax then
                            set r = 0
                            set rmax = (DarkShikiQ_BackToPosDurationBase + DarkShikiQ_BackToPosDurationStep * (GetUnitAbilityLevel(c, DarkShikiQ_ID) - 1))
                            set check = 1
                            if frame2_pas1[k2] == null then
                                set frame2_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18 + tmp_y)
                                call BlzFrameSetSize(frame2_pas1[k2], 0.135, 0.035)
                                call BlzFrameSetTexture(frame2_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                                call BlzFrameSetVisible(frame2_pas1[k2], false)
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame2_pas1[k2], true)
                                endif
                                set frame2_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame2_pas1[k2], 0, 0)
                                call BlzFrameSetAbsPoint(frame2_pas2[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
                                call BlzFrameSetSize(frame2_pas2[k2], 0.1, 0.019)
                                set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)
                                call BlzFrameSetSize(frame2_pas3[k2], 0.1, 0.035)
                                call BlzFrameSetScale(frame2_pas3[k2], 0.5)
                                call BlzFrameSetModel(frame2_pas3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                                call BlzFrameSetAbsPoint(frame2_pas3[k2], FRAMEPOINT_CENTER, 0.05, 0.175 + tmp_y)
                                call BlzFrameSetMinMaxValue(frame2_pas3[k2], 0, rmax)
                                call BlzFrameSetValue(frame2_pas3[k2], 0)
                                set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18 + tmp_y)
                                call BlzFrameSetSize(frame2_pas4[k2], 0.03, 0.03)
                                call BlzFrameSetTexture(frame2_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_DarkShiki_Q", 0, false)
                                set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
                                call BlzFrameSetText(frame2_pas5[k2], "|c00FFFF00" + "Time to retreat:" + "|r")
                                call BlzFrameSetScale(frame2_pas5[k2], 0.9)
                                set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17 + tmp_y)
                                call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                                call BlzFrameSetScale(frame2_pas6[k2], 0.9)
                            else
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame2_pas1[k2], true)
                                endif
                                call BlzFrameSetValue(frame2_pas3[k2], 0)
                            endif
                            call SwapAbility(c, rmax, DarkShikiQ2_ID, DarkShikiQ_ID)
                            call PauseUnit( c , false)
                            call SetUnitTimeScale(c, 1)
                        endif
                    elseif check == 1 then
                        call BlzFrameSetValue(frame2_pas3[k2], rmax - (r ))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                        if LoadInteger(hs, GetHandleId(c), StringHash("back to position")) == 1 then
                            set k = GetRandomInt(1, 3)
                            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(DarkShikiQ_ID)), 1)
                            if k == 1 then
                                call MakeSound("war3mapimported\\Hero_DarkShiki_Q01")
                            elseif k == 2 then
                                call MakeSound("war3mapimported\\Hero_DarkShiki_Q02")
                            elseif k == 3 then
                                call MakeSound("war3mapimported\\Hero_DarkShiki_Q03")
                            endif
                            set r = 99999
                            call BlzSetSpecialEffectTimeScale(e2, 10)
                            call DestroyEffect(e2)
                            call ColorEffDummy3(e, 0, 125, 125, 125, 0.21)
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_3yue_5.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1.1, 0.45, 0, 255, 255, 255, 140))
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_3yue_5.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1.35, 0.65, 0, 255, 255, 255, 150))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_111.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 2.5, 0))
                            call BlinkEff(c)
                            call SetUnitPosition(c, x2, y2)
                            call BlinkEff2(c)
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_3yue_5.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1.1, 0.45, 0, 255, 255, 255, 140))
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_3yue_5.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1.35, 0.65, 0, 255, 255, 255, 150))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_111.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 2.5, 0))
                        endif
                    endif
                else
                    if check == 0 then
                        call SaveInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause"), 0)
                        call PauseUnit( c , false)
                        call SetUnitTimeScale(c, 1)
                    endif
                    if r != 99999 then
                        call DestroyEffect(e2)
                        call BlzSetSpecialEffectTimeScale(e2, 10)
                        call ColorEffDummy3(e, 0, 125, 125, 125, 0.21)
                    endif
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                        call BlzFrameSetVisible(frame2_pas1[k2], false)
                    endif
                    call DestroyGroup( g )
                    set g = null
                    call DestroyGroup( g2 )
                    set g2 = null
                    set c = null
                    set e = null
                    set u = null
                    set m_DarkShikiQ[i] = m_DarkShikiQ[ MUI_DarkShikiQ]
                    set MUI_DarkShikiQ = MUI_DarkShikiQ - 1
                    if MUI_DarkShikiQ == -1 then
                        call PauseTimer( t_DarkShikiQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method DarkShikiQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_DarkShikiQ = MUI_DarkShikiQ + 1
            set m_DarkShikiQ[ MUI_DarkShikiQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set r3 = 1
            set check2 = 0
            set x2 = GetUnitX(c)
            set y2 = GetUnitY(c)
            set scale = 2
            set k2 = GetPlayerId(GetOwningPlayer(c))
            call PauseUnit( c , true)
            set g = CreateGroup()
            set g2 = CreateGroup()
            call SaveInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause"), 1)
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set check = 0
            set r6 = 0.45
            set rmax = r6+0.36
            set r5 = (DarkShikiQ_RangeBase + DarkShikiQ_RangeStep * (GetUnitAbilityLevel(c, DarkShikiQ_ID) - 1)) / 1800
            set move = (DarkShikiQ_RangeBase + DarkShikiQ_RangeStep * (GetUnitAbilityLevel(c, DarkShikiQ_ID) - 1)) / 12
            set aoe = DarkShikiQ_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( DarkShikiQ_DamageAgiBase + ( DarkShikiQ_DamageAgiStep * ( GetUnitAbilityLevel( c , DarkShikiQ_ID) - 1 ) ) )
            set dmg = dmg + DarkShikiQ_Damage2StaticBase + ( DarkShikiQ_Damage2StaticStep * ( GetUnitAbilityLevel( c , DarkShikiQ_ID) - 1 ) )
            call SetUnitFacing( c , a * bj_RADTODEG)
            call SetUnitTimeScale( c , 1)
            call SetUnitAnimationByIndex( c , 7)
            set e = EffectSpawnColor("war3mapImported\\wos_DarkShiki.mdl", x2, y2, a * bj_RADTODEG, 0.15, BlzGetUnitRealField(c, UNIT_RF_SCALING_VALUE), 0, 125, 125, 125, 200)
            call BlzSetSpecialEffectAlpha(e,0)
            call ColorEffDummy4(e,r6,255,255,255,r6)
            set e2 = EffectSpawn("war3mapImported\\wos_effect devil slam red.mdx", x2, y2, a * bj_RADTODEG, 0.15, 0.65, 0)
            call BlzSetSpecialEffectAlpha(e2, 165)
            set k = GetRandomInt(1, 3)
            call SetUnitTimeScale(c, 1)
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(DarkShikiQ_ID)), 0)
            call SaveInteger(hs, GetHandleId(c), StringHash("back to position"), 0)
            call VisionTimed(GetOwningPlayer(c), x2, y2, 900, rmax + 1 + (DarkShikiQ_BackToPosDurationBase + DarkShikiQ_BackToPosDurationStep * (GetUnitAbilityLevel(c, DarkShikiQ_ID) - 1)))
            if k == 1 then
                call MakeSound("war3mapimported\\Hero_DarkShiki_Q01")
            elseif k == 2 then
                call MakeSound("war3mapimported\\Hero_DarkShiki_Q02")
            elseif k == 3 then
                call MakeSound("war3mapimported\\Hero_DarkShiki_Q03")
            endif
            call MakeSound("war3mapimported\\Hero_DarkShiki_Q1")
            if MUI_DarkShikiQ == 0 then
                call TimerStart( t_DarkShikiQ, 0.03, true, function thistype.Loop_DarkShikiQ)
            endif
        endmethod
    endstruct

    private struct DarkShikiW_KS
        private static timer t_DarkShikiW = CreateTimer( )
        private static integer array m_DarkShikiW
        private static integer MUI_DarkShikiW = -1
        unit c
        unit td
        real x
        real y
        integer k
        integer k2
        real r5
        real dmg
        integer check2
        real r
        real a
        real rmax
        private static method Loop_DarkShikiW takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_DarkShikiW
                set this = m_DarkShikiW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.05
                    call DebugUnit2(c)
                    call SaveInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause"), 1)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if r == 0.35 then
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_111.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 2.5, 0))
                        call BlinkEff(c)
                        call SetUnitX(c, x)
                        call SetUnitY(c, y)
                        call BlinkEff2(c)
                    endif
                    if r == 0.5 then
                        call MakeSound("war3mapimported\\Hero_DarkShiki_W2")
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_whiteakihared.mdl", x, y, a * bj_RADTODEG + 90, 1.25, 1.85, 135))
                    endif
                    if r == 0.65 then
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_Nanaya2Skill06Dred.mdl", x, y, 0, 1, 1.95, 195))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-RSFX-10.mdl", x, y, 0, 1, 2.5, 195))
                        call MUE(c, 255, 0.35, a)
                    endif
                    if r == rmax then
                        call DecorRemove(c, GetUnitX(td), GetUnitY(td), 300, 20)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_Lucia-leimitx10.mdx", x, y, 0, 2, 2, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-Hit-red.mdl", x, y, 0, 2, 2, 135))
                        call DestroyEffect(EffectSpawn3("war3mapimported\\wos_afb_satomirentaro_kuding-blackred.mdl", x, y, a * bj_RADTODEG, 2.25, 1.1, 235, -0))
                        call DestroyEffect( EffectSpawn("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", x, y, a * bj_RADTODEG, 0.35, 3, 145))
                        call DestroyEffect( EffectSpawn("war3mapimported\\wos_bloodex-special-23.mdx", x, y, a * bj_RADTODEG, 2, 3, 145))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_Lucia-leimitx10.mdx", x, y, 0, 2, 2, 1))
                        call dmgphys(c, td, dmg)
                        //call SilenceUnit(c, td, 2)
                        if IsUnitIllusion(td) == false and check2 == 0 then
                            call DarkShikiPassive_KS.DarkShikiPassiveApply(c, td)
                            set check2 = 1
                        endif
                    endif
                else
                    call SaveInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause"), 0)
                    call PauseUnit(c, false)
                    call StopSpellUnit2(c)
                    set td = null
                    set c = null
                    set m_DarkShikiW[i] = m_DarkShikiW[ MUI_DarkShikiW]
                    set MUI_DarkShikiW = MUI_DarkShikiW - 1
                    if MUI_DarkShikiW == -1 then
                        call PauseTimer( t_DarkShikiW)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method DarkShikiW_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_DarkShikiW = MUI_DarkShikiW + 1
            set m_DarkShikiW[ MUI_DarkShikiW] = this
            set c = NewC
            set td = NewTd
            set k2 = 0
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r = 0
            call SaveInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause"), 1)
            set check2 = 0
            set r5 = 0
            set r = 0
            set a = GAngle( c , td ) // Angle Between points
            set dmg = GetHeroAgi( c , true) * ( DarkShikiW_DamageAgiBase + ( DarkShikiW_DamageAgiStep * ( GetUnitAbilityLevel( c , DarkShikiW_ID) - 1 ) ) )
            set dmg = dmg + DarkShikiW_Damage2StaticBase + ( DarkShikiW_Damage2StaticStep * ( GetUnitAbilityLevel( c , DarkShikiW_ID) - 1 ) )
            set k = GetRandomInt(1, 2)
            call PauseUnit( c , true)
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            call SetUnitTimeScale(c, 0.9)
            if k == 1 then
                call MakeSound("war3mapimported\\Hero_DarkShiki_W02")
            elseif k == 2 then
                call MakeSound("war3mapimported\\Hero_DarkShiki_W03")
            endif
            call MakeSound("war3mapimported\\Hero_DarkShiki_G1")
            set rmax = 0.8
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_HakkeStart.mdx", x, y, 0, 0.9, 1.5, 5))
            call SetUnitAnimationByIndex( c , 31)
            if MUI_DarkShikiW == 0 then
                call TimerStart( t_DarkShikiW, 0.05, true, function thistype.Loop_DarkShikiW)
            endif
        endmethod
        
    endstruct

    private struct DarkShikiE_KS
        private static timer t_DarkShikiE = CreateTimer( )
        private static integer array m_DarkShikiE
        private static integer MUI_DarkShikiE = -1
        unit c
        unit td
        real x
        real y
        integer k
        real r5
        real dmg
        integer check
        integer check2
        real move
        real r
        real a
        real rmax
        private static method Loop_DarkShikiE takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_DarkShikiE
                set this = m_DarkShikiE[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    call SaveInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause"), 1)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    set a = GAngle(c, td)
                    if r == 0.3 then
                        call SetUnitAnimationByIndex(c, 14)
                        set r5 = 0
                    endif
                    if r > 0.45 then
                        if SR2(c, td) > 110 then
                            call ShikiClone(c, 14, r5, 2)
                            set r5 = r5 + 0.015
                            call MoveUnit(c, move, a)
                            call ShikiClone(c, 14, r5, 2)
                            set r5 = r5 + 0.015
                        else
                            set check = 1
                            set r = 9999
                        endif
                    endif
                else
                    call SaveInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause"), 0)
                    call StopSpellUnit2(c)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    if check == 1 then
                        call SetUnitPosition(c, x + 150 * Cos(a), y + 150 * Sin(a))
                        call dmgphys(c, td, dmg)
                        call StunUnit(c, td, DarkShikiE_Stun)
                        if IsUnitIllusion(td) == false and check2 == 0 then
                            call DarkShikiPassive_KS.DarkShikiPassiveApply(c, td)
                            set check2 = 1
                        endif
                        call DecorRemove(c, GetUnitX(td), GetUnitY(td), 300, 20)
                        call MakeSound("war3mapimported\\Hero_DarkShiki_E2")
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Satsu-WSFX-1_1.mdl", x, y, a * bj_RADTODEG, 1.25, 2, 1, 255, 25, 25, 255))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_xie_baozha.mdl", x, y, GetRandomReal(0, 359), 0.75, 1.45, 125))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_bdef (178).mdl", x, y, a * bj_RADTODEG, 0.45, 2, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-WWSFX-1.mdl", x, y, GetRandomReal(0, 359), 0.5, 5, 155))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-WWSFX-1.mdl", x, y, GetRandomReal(0, 359), 0.5, 5, 155))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-WWSFX-1.mdl", x, y, GetRandomReal(0, 359), 0.5, 5, 155))
                    endif
                    set c = null
                    set td = null
                    set m_DarkShikiE[i] = m_DarkShikiE[MUI_DarkShikiE]
                    set MUI_DarkShikiE = MUI_DarkShikiE - 1
                    if MUI_DarkShikiE == -1 then
                        call PauseTimer( t_DarkShikiE )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod
        public static method DarkShikiE_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_DarkShikiE = MUI_DarkShikiE + 1
            set m_DarkShikiE[MUI_DarkShikiE] = this
            set c = NewC
            set td = NewTd
            set dmg = GetHeroAgi( c , true) * ( DarkShikiE_DamageAgiBase + ( DarkShikiE_DamageAgiStep * ( GetUnitAbilityLevel( c , DarkShikiE_ID) - 1 ) ) )
            set r = 0
            set check2 = 0
            set check = 0
            set rmax = 2
            set move = 80
            call StartSpellUnit2(c)
            call SetUnitAnimationByIndex(c, 13)
            call SaveInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause"), 1)
            call SetUnitTimeScale(c, 0.25)
            set a = GAngle(c, td)
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            set k = GetRandomInt(1, 2)
            if k == 1 then
                call MakeSound("war3mapimported\\Hero_DarkShiki_E01")
            elseif k == 2 then
                call MakeSound("war3mapimported\\Hero_DarkShiki_E02")
            endif
            if MUI_DarkShikiE == 0 then
                call TimerStart( t_DarkShikiE, 0.03, true, function thistype.Loop_DarkShikiE )
            endif
        endmethod
    endstruct

    private struct DarkShikiR_KS
        private static timer t_DarkShikiR = CreateTimer( )
        private static integer array m_DarkShikiR
        private static integer MUI_DarkShikiR = -1
        unit c
        real x
        real y
        real r2
        integer k
        integer k2
        integer k3
        real r3
        real r4
        real r5
        real fly
        real r6
        group g
        group g2
        unit u
        real dmg
        integer check
        integer check2
        real aoe
        real move
        real r
        real a
        real rmax
        private static method Loop_DarkShikiR takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rand1 = 0
            local real rand2 = 0
            local real rand3 = 0
            loop
                exitwhen i > MUI_DarkShikiR
                set this = m_DarkShikiR[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if check == 0 then
                        call SaveInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause"), 1)
                        call DebugUnit(c)
                        set r3 = 0.3
                        if r < r3 then
                            set fly = 15
                        endif
                        if r == r3 then
                            call SetUnitTimeScale(c, 1)
                            set fly = GetUnitFlyHeight(c) / ((rmax - r) / 0.03)
                            set r5 = 0
                        endif
                        if r >= r3 then
                            call SetUnitTimeScale(c, 1)
                            set r6 = 0.01
                            call SetFly(c, GetUnitFlyHeight(c) - fly)
                            set k2 = 23
                            set r4 = 1.5
                        else
                            call SetFly(c, GetUnitFlyHeight(c) + fly)
                            set r6 = 0.03
                            call SetUnitTimeScale(c, 3)
                            set k2 = 22
                            set r4 = 6
                        endif
                        if r == 0.6 then
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_Nanaya2Skill06Dred.mdl", x, y, 0, 1, 1.95, 195))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_FireFlyW-SFX-1red.mdl", x, y, 0, 1, 2.5, 1))
                        endif
                        if r <= 0.6 then
                            call ShikiClone(c, k2, r5, r4)
                            set r5 = r5 + r6
                            call MoveUnit(c, move, a)
                            call ShikiClone(c, k2, r5, r4)
                            set r5 = r5 + r6
                        else
                            set check = 1
                            set rmax = 0.69
                            set r = 0
                            set r2 = 10
                    call SetFly(c, 0)
                            call MakeSound("war3mapimported\\Hero_DarkShiki_R3")      
                        endif
                    elseif check == 1 then
                     call DebugUnit(c)
                        if r3 > 0.0 then
                            set k = 0
                            loop
                                exitwhen k == 3
                                set rand1 = GetRandomReal(100, 600)
                                set rand3 = GetRandomReal(100, 450)
                                set rand2 = GetRandomReal(0, 360) * bj_DEGTORAD
                                call DecorRemove(c, x, y, 600, 50)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-WWSFX-1.mdl", x + rand1 * Cos(rand2), y + rand1 * Sin(rand2), GetRandomReal(0, 359), 1, 6, rand3))
                                set k = k + 1
                            endloop
                            set k = 0
                            set r3 = 0
                        else
                            set r3 = r3 + 0.03
                        endif
                        if r2 > 0.1 then
                            set r2 = 0
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                    call dmgphys(c, u, dmg)
                                    call GroupAddUnit(g2, u)
                                    if IsUnitIllusion(u) == false and check2 == 0 then
                                        call DarkShikiPassive_KS.DarkShikiPassiveApply(c, u)
                                        set check2 = 1
                                    endif
                                    call DestroyEffect( EffectSpawn("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", x, y, a * bj_RADTODEG, 0.35, 3, 145))
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    call SetFly(c, 0)
                            call StopSpellUnit(c)
                        call SaveInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause"), 0)
                    if check == 0 then
                        call SaveInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause"), 0)
                    call StopSpellUnit(c)
                    endif                    
                    call SetUnitTimeScale( c , 1)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set u = null
                    set c = null
                    set m_DarkShikiR[i] = m_DarkShikiR[ MUI_DarkShikiR]
                    set MUI_DarkShikiR = MUI_DarkShikiR - 1
                    if MUI_DarkShikiR == -1 then
                        call PauseTimer( t_DarkShikiR)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method DarkShikiR_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_DarkShikiR = MUI_DarkShikiR + 1
            set m_DarkShikiR[ MUI_DarkShikiR] = this
            set c = NewC
            set r = 0
            set x = NewX
            set y = NewY
            set check = 0
            set check2 = 0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set g = CreateGroup()
            set k3 = 0
            set g2 = CreateGroup()
            call SaveInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause"), 1)
            set dmg = GetHeroAgi( c , true) * ( DarkShikiR_DamageAgiBase + ( DarkShikiR_DamageAgiStep * ( GetUnitAbilityLevel( c , DarkShikiR_ID) - 1 ) ) )
            set r2 = 0
            set aoe = DarkShikiR_DamageAoe
            call StartSpellUnit(c)
            call SetUnitAnimationByIndex(c, 22)
            call SetUnitTimeScale(c, 3)
            set a = GAngle2(c, x,y)
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            set move = ( SR3(c, x,y) + 300) / 20
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapimported\\Hero_DarkShiki_R01")
            else
                call MakeSound("war3mapimported\\Hero_DarkShiki_R02")
            endif
            call MakeSound("war3mapimported\\Hero_DarkShiki_G1")
            call VisionTimed(GetOwningPlayer(c),x,y, 1200, 2)
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_HakkeStart.mdx", x, y, 0, 1, 2.2, 5))
            set rmax = 0.9
            if MUI_DarkShikiR == 0 then
                call TimerStart( t_DarkShikiR, 0.03, true, function thistype.Loop_DarkShikiR)
            endif
        endmethod
    endstruct

    private struct DarkShikiT_KS
        private static timer t_DarkShikiT = CreateTimer( )
        private static integer array m_DarkShikiT
        private static integer MUI_DarkShikiT = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k2
        real dmg
        integer check
        integer check2
        real move
        real r
        effect e
        real a
        real rmax
        private static method Loop_DarkShikiT takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_DarkShikiT
                set this = m_DarkShikiT[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                    call SaveInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause"), 1)
                    call DebugUnit2(c)
                    if check == 0 then
                        if r == 0.45 then
                            call MakeSound("war3mapimported\\Hero_DarkShiki_T1")
                            set e = EffectSpawn("war3mapimported\\wos_mh_nanaya_xd.mdl", GetUnitX(c) + 140 * Cos(a), GetUnitY(c) + 140 * Sin(a), a * bj_RADTODEG, 1, 2, 195)
                        endif
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        if r > 0.51 then
                            set a = GAngle5(e, x, y)
                            if SR5(e, x, y) >= move * 1.25 then
                                call MoveEff2(e, move, a)
                                call BlzSetSpecialEffectYaw(e,GAngle5(e,x,y))
                            else
                                call BlzSetSpecialEffectPosition(e, x, y, 185)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_111.mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 1, 2.5, 0))
                                call BlinkEff(c)
                                call SetUnitPosition(c, x, y)
                                call SetUnitAnimationByIndex(c, 32)
                                call ColorEffDummy3(e, 0, 255, 255, 255, 0.4)
                                call SetUnitFacing(c, a * bj_RADTODEG)
                                call MakeSound("war3mapimported\\Hero_DarkShiki_T3")
                                    call MakeSound("war3mapimported\\Hero_DarkShiki_T02")
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-ESFX-4.mdl", x, y, a * bj_RADTODEG + 90, 1, 2.25, 210))
                                set check = 1
                                call SetUnitTimeScale(c, 1.5)
                                set r = 0
                                set rmax = 0.36
                                call MUE(c, 150, rmax, a)
                            endif
                        endif
                    elseif check == 1 then
                        if r == 0.12 then
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-Hit-red.mdl", x, y, a * bj_RADTODEG, 1, 3.25, 200))
                        endif
                        if r == rmax then
                            call DecorRemove(c, GetUnitX(c), GetUnitY(td), 350, 50)
                            call DestroyEffect( EffectSpawn("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", x, y, a * bj_RADTODEG, 0.35, 3, 145))
                            call DestroyEffect( EffectSpawn("war3mapimported\\wos_bloodex-special-23.mdx", x, y, a * bj_RADTODEG, 2, 3, 145))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-RSFX-4.mdl", x, y, a * bj_RADTODEG + 90, 0.5, 2, 1))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_yz-leimitx13.mdl", x, y, a * bj_RADTODEG + 90, 2.5, 3, 1))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_AZ_TS_TZRed.mdl", x, y, a * bj_RADTODEG + 90, 2.5, 2, 1))
                            call MakeSound("war3mapimported\\Hero_DarkShiki_T4")
                            set k2 = 0
                            if GetUnitAbilityLevel(td, 'Avul') > 0 then
                                set k2 = 1
                            //    call UnitRemoveAbility(td, 'Avul')
                            endif
                            if IsUnitIllusion(td) == false and check2 == 0 then
                                call DarkShikiPassive_KS.DarkShikiPassiveApply(c, td)
                                set check2 = 1
                            endif
                            call dmgphys(c, td, dmg)
                           // call StunUnit(c, td, DarkShikiT_Stun)
                            if k2 == 1 then
                               // call UnitAddAbility(td, 'Avul')
                            endif
                        endif
                    endif
                else
                    call SaveInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause"), 0)
                    if check == 0 then
                        call ColorEffDummy3(e, 0, 255, 255, 255, 0.12)
                    else
                      
                    endif
                    call StopSpellUnit2(c)
                    call SetUnitTimeScale( c , 1)
                    set e = null
                    set c = null
                    set td = null
                    set m_DarkShikiT[i] = m_DarkShikiT[ MUI_DarkShikiT]
                    set MUI_DarkShikiT = MUI_DarkShikiT - 1
                    if MUI_DarkShikiT == -1 then
                        call PauseTimer( t_DarkShikiT)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method DarkShikiT_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_DarkShikiT = MUI_DarkShikiT + 1
            set m_DarkShikiT[ MUI_DarkShikiT] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r2 = 0
            call StartSpellUnit2(c)
            set dmg = DarkShikiT_DamageAgiBase * GetHeroAgi(c, true)
            set move = 140
            set check = 0
            set k2 = 0
            set check2 = 0
            call SaveInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause"), 1)
            set a = GAngle(c, td)
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
                set k2 = 1
                call MakeSound("war3mapimported\\Hero_DarkShiki_T01")
            call MakeSound("war3mapimported\\Hero_DarkShiki_T4")
            call VisionTimed(GetOwningPlayer(c), GetUnitX(td), GetUnitY(td), 1200, 3)
            set rmax = 1.02
            call SetUnitAnimationByIndex(c, 1)
            call SetUnitTimeScale(c, 0.7)
            if MUI_DarkShikiT == 0 then
                call TimerStart( t_DarkShikiT, 0.03, true, function thistype.Loop_DarkShikiT)
            endif
        endmethod
    endstruct

    private struct DarkShikiG_KS
        private static timer t_DarkShikiG = CreateTimer( )
        private static integer array m_DarkShikiG
        private static integer MUI_DarkShikiG = -1
        unit c
        real x
        real y
        real r2
        integer k2
        group g
        unit u
        real dmg
        integer check
        integer check2
        real aoe
        real r
        real a
        real rmax
        private static method Loop_DarkShikiG takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rand1 = 0
            local real rand2 = 0
            local real rand3 = 0
            loop
                exitwhen i > MUI_DarkShikiG
                set this = m_DarkShikiG[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                        call SaveInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause"), 1)
                        call DebugUnit(c)
                    if r == rmax then 
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    
                    call StopSpellUnit(c)
                    call DecorRemove(c,x,y,aoe,50)
                            call MakeSound("war3mapimported\\Hero_DarkShiki_R3")
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_Nanaya2Skill06Dred.mdl", x, y, 0, 1, 2.45, 75))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-RSFX-10.mdl", x, y, 0, 1, 3.15, 75))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_AZ_TS_TZRed.mdl", x, y, a * bj_RADTODEG + 90, 1.5, 2.25, 4))
                    call DestroyEffect(EffectSpawn3("war3mapimported\\wos_az_jingzi_jiansheng01_e1_l2.mdl", x, y, a * bj_RADTODEG + 45, 0.65, 2, 45,-25))
                    call DestroyEffect(EffectSpawn3("war3mapimported\\wos_az_jingzi_jiansheng01_e1_l2.mdl", x, y, a * bj_RADTODEG - 45, 0.65, 2, 45,-25))
                    call GroupClear( g )
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c ))  then
                                    call dmgphys(c, u, dmg)
                                    if IsUnitIllusion(u) == false and check2 == 0 then
                                        call DarkShikiPassive_KS.DarkShikiPassiveApply(c, u)
                                        set check2 = 1
                                    endif
                                    call DestroyEffect( EffectSpawn("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", x, y, a * bj_RADTODEG, 0.35, 3, 145))
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                    endif
                else
                    call SetFly(c, 0)
                    if check == 0 then
                        call SaveInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause"), 0)
                    endif
                    call StopSpellUnit(c)
                    call SetUnitTimeScale( c , 1)
                    call DestroyGroup(g)
                    set g = null
                    set u = null
                    set c = null
                    set m_DarkShikiG[i] = m_DarkShikiG[ MUI_DarkShikiG]
                    set MUI_DarkShikiG = MUI_DarkShikiG - 1
                    if MUI_DarkShikiG == -1 then
                        call PauseTimer( t_DarkShikiG)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod
        public static method DarkShikiG_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_DarkShikiG = MUI_DarkShikiG + 1
            set m_DarkShikiG[ MUI_DarkShikiG] = this
            set c = NewC
            set r = 0
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set a = GetUnitFacing(c)*bj_DEGTORAD
            set check = 0
            set check2 = 0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set g = CreateGroup()
            call SaveInteger(hs, GetHandleId(c), StringHash("shiki_spell_pause"), 1)
            set dmg = GetHeroAgi( c , true) *  DarkShikiG_DamageAgiBase
            set r2 = 0
            set aoe = DarkShikiG_DamageAoe
            call StartSpellUnit(c)
            call SetUnitAnimationByIndex(c, 27)
            call SetUnitTimeScale(c, 3.2)
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
                call MakeSound("war3mapimported\\Hero_DarkShiki_T")
            call MakeSound("war3mapimported\\Hero_DarkShiki_G1")
            call VisionTimed(GetOwningPlayer(c),x,y, 1200, 2)
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_HakkeStart.mdx", x, y, 0, 0.6, 1.25, 5))
            set rmax = 0.27
            if MUI_DarkShikiG == 0 then
                call TimerStart( t_DarkShikiG, 0.03, true, function thistype.Loop_DarkShikiG)
            endif
        endmethod
     
    endstruct

    //----------------------------DarkShiki-----------------------------------------------
     /* Animations index:
    Base:
    0 - stand ready
    1 - strike to air from 0
    2 - air atk
    3 - E or R
    6 - atk to floor
    8 - move
    12 - otprig nazad
    13 - charge
    14 - atk
    21 - drugoi otprig c chargom
    22 - vverh prij
    23 - atk after 22
    24 - charge q
    31 - W or T
    32 - T
    33 - Q polet
    
     */ 

    function DarkShikiQ_Start takes unit c, real x, real y returns nothing
        call DarkShikiQ_KS.DarkShikiQ_Start( c, x, y )
    endfunction
    function DarkShikiQ2_Start takes unit c returns nothing
        call SaveInteger(hs, GetHandleId(c), StringHash("back to position"), 1)
    endfunction
    function DarkShikiW_Start takes unit c, unit td returns nothing
        call DarkShikiW_KS.DarkShikiW_Start( c, td )
    endfunction
    function DarkShikiE_Start takes unit c, unit td returns nothing
        call DarkShikiE_KS.DarkShikiE_Start( c, td)
    endfunction
    function DarkShikiR_Start takes unit c, real x,real y returns nothing
        call DarkShikiR_KS.DarkShikiR_Start( c,x,y)
    endfunction
    function DarkShikiT_Start takes unit c, unit td returns nothing
        call DarkShikiT_KS.DarkShikiT_Start( c, td)
    endfunction
    function DarkShikiG_Start takes unit c returns nothing
        call DarkShikiG_KS.DarkShikiG_Start( c)
    endfunction
   
endlibrary

