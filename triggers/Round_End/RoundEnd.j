library RoundSpells uses GearSystems
    private struct RoundEnd
        private static timer t_RoundTrain = CreateTimer( )
        private static integer array m_RoundTrain
        private static integer MUI_RoundTrain = -1
        private static timer t_Round1 = CreateTimer( )
        private static integer array m_Round1
        private static integer MUI_Round1 = -1
        private static timer t_Round2 = CreateTimer( )
        private static integer array m_Round2
        private static integer MUI_Round2 = -1
        private static timer t_Round3 = CreateTimer( )
        private static integer array m_Round3
        private static integer MUI_Round3 = -1
        private static timer t_Round4 = CreateTimer( )
        private static integer array m_Round4
        private static integer MUI_Round4 = -1
        private static timer t_Round5 = CreateTimer( )
        private static integer array m_Round5
        private static integer MUI_Round5 = -1
        private static timer t_Round6 = CreateTimer( )
        private static integer array m_Round6
        private static integer MUI_Round6 = -1
        private static timer t_Round7 = CreateTimer( )
        private static integer array m_Round7
        private static integer MUI_Round7 = -1
        unit c
        unit td
        unit d
        unit d2
        destructable des1
        destructable des2
        real x
        real y
        real x1
        real y1
        real x2
        real y2
        real r2
        boolean b
        integer k
        integer k2
        integer k3
        real scale
        real scale2
        real r_prepare
        real r3
        real r4
        real r5
        real r6
        real r7
        real sr
        real fly
        group g
        group g2
        group g3
        group g4
        unit u
        real dmg
        real dmg2
        real a2
        integer check
        integer check2
        integer check3
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
        private static method Loop_SukunaEnd takes nothing returns nothing
            local integer this
            local integer i = 0
            local real distance
            loop
                exitwhen i > MUI_Round1
                set this = m_Round1[i]
                if SpellBoolCaster(c) and r <= rmax and CondArena == 1 then
                    set r = r + 1
                    if r == 5 then
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_hakkestart.mdx", GetUnitX(c) - 350 * Cos(a), GetUnitY(c) - 350 * Sin(a), a * bj_RADTODEG, 0.15, 1.8, 0))
                    elseif r == 6 then
                        set e = EffectSpawn("war3mapImported\\wos_SukunaDomain.mdx", GetUnitX(c) - 350 * Cos(a), GetUnitY(c) - 350 * Sin(a), a * bj_RADTODEG, 1, 6.5, 0)
                    elseif r == 7 then
                        call PlayersMsg("|c00FF0303Author:|r Struggle if you wish. Destruction is inevitable.", 2)
                        set e2 = EffectSpawnScale("war3mapImported\\wos_OuterCircleRed.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 22, 1, 59, 22, 6)
                        set e4 = EffectSpawnScale("war3mapImported\\wos_SukunaDomainArea2.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1.92, 10, 59, 1.92, 0.54)
                        call BlzSetSpecialEffectAlpha(e4, 125)
                    endif
                    if r > 6 then
                        set k = 0
                        loop
                            exitwhen k == 10
                            set r4 = GetRandomReal(0.45, 1)
                            set r5 = GetRandomReal(-0.35, -0.15)
                            set r6 = GetRandomReal(150, 650)
                            call DestroyEffect(EffectSpawn3("war3mapImported\\wos_az_jingzi_jiansheng01_e1_l2.mdl", x + (aoe * 1.25) * Cos(k * 36 * bj_DEGTORAD), y + (aoe * 1.25) * Sin(k * 36 * bj_DEGTORAD), GetRandomReal(0, 359), r4, 1.2, 155, r5))
                            call VisionTimed(Player(k), x, y, aoe, 1)
                            set k = k + 1
                        endloop
                        set k = 0
                        if k2 != 0 then
                            loop
                                exitwhen k >= k2
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_1hongse_2red.mdl", x + (aoe) * Cos(k * (360 / k2) * bj_DEGTORAD), y + (aoe) * Sin(k * (360 / k2) * bj_DEGTORAD), GetRandomReal(0, 359), 0.65, 3, 1))
                                set k = k + 1
                            endloop
                        endif
                        if r2 > 1 and k2 > 0 then
                            set r2 = 0
                            set k2 = k2 - 1
                        else
                            set r2 = r2 + 0.5
                        endif
                        if aoe > 1320 then
                            set aoe = aoe - 65.9
                            if aoe < 1320 then
                                set aoe = 1320
                                set k2 = 0
                            endif
                        else
                        endif
                        if dmg < 1300 then
                            set dmg = dmg + 40
                        endif
                        call DecorRemove2(c, x, y, aoe, 50)
                        call GroupClear(g)
                        call GroupEnumUnitsInRect(g , gg_rct_Arena , Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            set distance = SR3(u, x, y)
                            if SpellBool( u ) and distance > aoe then
                                call SetHpCurrent(u, -dmg)
                                call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdl", u, "chest"))
                                set r5 = GetRandomReal(-0.35, -0.15)
                                if GetLocalPlayer() == GetOwningPlayer(u) then
                                    call CinematicFilterGenericBJ(2.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 100.00, 10.00, 10.00, 0.00, 100.00, 10.00, 10.00, 100.00)
                                endif
                                call DestroyEffect(EffectSpawn3("war3mapImported\\wos_az_jingzi_jiansheng01_e1_l2.mdl", GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359), 1, 1.2, GetUnitFlyHeight(u) + 210, r5))
                                call DestroyEffect(EffectSpawn3("war3mapImported\\wos_az_jingzi_jiansheng01_e1_l2.mdl", GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359), 1, 1.2, GetUnitFlyHeight(u) + 120, r5))
                            elseif distance <= aoe then
                                if GetLocalPlayer() == GetOwningPlayer(u) then
                                    call DisplayCineFilter(false)
                                endif
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                    endif
                else
                    set k = 0
                    loop
                        exitwhen k == 10
                        if GetLocalPlayer() == Player(k) then
                            call DisplayCineFilter(false)
                        endif
                        set k = k + 1
                    endloop
                    call StopSound(gg_snd_Round_Sukuna, false, false)
                    call DestroyEffect(e)
                    call DestroyEffect(e3)
                    call DestroyEffect(e4)
                    call BlinkEff(c)
                    call ColorDummy3(c, 0, 255, 255, 255, 0.25)
                    call ColorEffDummy3(e2, 0, 255, 255, 255, 0.3)
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set u = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set e4 = null
                    set m_Round1[i] = m_Round1[ MUI_Round1]
                    set MUI_Round1 = MUI_Round1 - 1
                    if MUI_Round1 == -1 then
                        call PauseTimer( t_Round1)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method SukunaEnd_Start takes nothing returns nothing
            local thistype this = thistype.create( )
            set MUI_Round1 = MUI_Round1 + 1
            set m_Round1[ MUI_Round1] = this
            set x = GetRectCenterX(gg_rct_Arena) + 100 * Cos(270 * bj_DEGTORAD)
            set y = GetRectCenterY(gg_rct_Arena) + 100 * Sin(270 * bj_DEGTORAD)
            set g = CreateGroup()
            set u = null
            call StartSound(gg_snd_Round_Sukuna)
            set c = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'h005', x, y, 270)
            call BlinkEff2(c)
            set rmax = 180
            set dmg = 75
            set aoe = 5000
            set k2 = 36
            set a = 270 * bj_DEGTORAD
            call SetUnitAnimation(c, "spell five")
            set k = 0
            loop
                exitwhen k == 10
                call VisionTimed(Player(k), x, y, aoe, 8)
                set k = k + 1
            endloop
            set r = 0
            set r2 = 0
            set r3 = 0
            call PlayersMsg("|c00FF0303Author:|r Move closer to the center to survive. In a few seconds, Sukuna will shatter the entire arena.", 7)
            set e3 = EffectSpawn("war3mapimported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiRed.mdx", GetUnitX(c) + 45 * Cos(a), GetUnitY(c) + 45 * Sin(a), a * bj_RADTODEG, 1, 2, 125)
            if MUI_Round1 == 0 then
                call TimerStart( t_Round1, 1, true, function thistype.Loop_SukunaEnd)
            endif
        endmethod
        method soundcheck takes unit c returns nothing
        if GetUnitTypeId(c) == Natsu_ID and IntegerCd(c,"cd sound train",10) then 
        if GetRandomInt(1,2) == 1 then 
        call MakeSound("war3mapimported\\wos_NatsuTrain")
        else
        call MakeSound("war3mapimported\\wos_NatsuTrain2")
        endif
        endif
        endmethod
        private static method Loop_Train_Start takes nothing returns nothing
            local integer this
            local integer i = 0
            local real a01 
            local real a02
            loop
                exitwhen i > MUI_RoundTrain
                set this = m_RoundTrain[i]
                if r <= rmax and CondArena == 1 then
                    set r = r + 0.03
                    set a01 = r6*bj_DEGTORAD
                    set a02 = r7*bj_DEGTORAD
                    if move < 75 then
                        set move = move + 0.5
                    endif
                    if GetDestructableLife(des1) <= 1 then
                    if check2 == 0 then
                    set x = GetUnitX(d)
                    set y = GetUnitY(d)
                    call SetUnitAnimation(d, "death")
                    call ColorDummy3(d, 0, 255, 255, 255, 0.75)
                    call GroupClear(g3)
                    call GroupEnumUnitsInRange(g3 , x, y, 650 , Condition(function NoDecor_Filter))
                    loop
                        set u = FirstOfGroup( g3 )
                        exitwhen u == null
                        if SpellBool( u ) then
                        if GetUnitState(u,UNIT_STATE_LIFE)-dmg2<=3 and IsUnitType(u,UNIT_TYPE_HERO) and IsUnitIllusion(u)==false then 
                        set TrainKill = TrainKill + 1
                        endif
                        call SetHpCurrent(u, -dmg2)
                        call soundcheck(u)
                        endif
                        call GroupRemoveUnit( g3 , u )
                    endloop
                    call ScaleDummy(UnitSpawn(Player(PLAYER_NEUTRAL_PASSIVE),Fire_ID,x,y,1,1,1.75,45,9),7.5,1.75,0.5)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_t8_by_wood_effect_order_dange_daoguang_baozha_2_2_clear.mdl", x, y, GetRandomReal(0, 359), 1, 1.33, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdl", x, y, GetRandomReal(0, 359), 1, 2.85, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_effect_yuzhiboyou_unusual_fenshendabaopo_2.mdl", x, y, GetRandomReal(0, 359), 1, 2, 1))
                    endif
                        set check2 = 1
                    endif
                    if check2 == 0 then
                        call MoveUnit2(d, move, a01)
                        if GetDestructableLife(des1) > 0 then
                            // Destructables cannot be moved by the Warcraft III API.
                            call RemoveDestructable(des1)
                            set des1 = null
                            set des1 = CreateDestructable('B017', GetUnitX(d), GetUnitY(d), 0, 0.01, 0)
                        endif
                        call GroupClear(g)
                        set x = GetUnitX(d)+550* Cos(a01)
                        set y = GetUnitY(d)+550* Sin(a01)
                        call GroupEnumUnitsInRange(g , x, y, aoe , Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) then
                                if IsUnitInGroup(u, g4) == false then
                                    if IsUnitInGroup(u, g2) == false then
                                        call GroupAddUnit(g2, u)
                        if GetUnitState(u,UNIT_STATE_LIFE)-dmg<=3 and IsUnitType(u,UNIT_TYPE_HERO) and IsUnitIllusion(u)==false  then 
                        set TrainKill = TrainKill + 1
                        endif
                                        call SetHpCurrent(u, -dmg)
                                        call soundcheck(u)
                                        call StunUnit(u, u, 1.5)
                                        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdl", u, "chest"))
                                    endif
                                    call SetUnitPosition(u, x + 15 * Cos(a01), y + 15 * Sin(a01))
                                endif
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                    endif
                    if GetDestructableLife(des2) <= 1 then
                    if check3 == 0 then 
                    set x = GetUnitX(d2)
                    set y = GetUnitY(d2)
                    call SetUnitAnimation(d2, "death")
                    call ColorDummy3(d2, 0, 255, 255, 255, 0.75)
                    call GroupClear(g3)
                    call GroupEnumUnitsInRange(g3 , x, y, 650 , Condition(function NoDecor_Filter))
                    loop
                        set u = FirstOfGroup( g3 )
                        exitwhen u == null
                        if SpellBool( u ) then
                            if GetUnitState(u,UNIT_STATE_LIFE)-dmg2<=3 and IsUnitType(u,UNIT_TYPE_HERO) and IsUnitIllusion(u)==false  then 
                        set TrainKill = TrainKill + 1
                        endif
                            call SetHpCurrent(u, -dmg2)
                            call soundcheck(u)
                        endif
                        call GroupRemoveUnit( g3 , u )
                    endloop
                    call ScaleDummy(UnitSpawn(Player(PLAYER_NEUTRAL_PASSIVE),Fire_ID,x,y,1,1,1.75,45,9),7.5,1.75,0.5)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_t8_by_wood_effect_order_dange_daoguang_baozha_2_2_clear.mdl", x, y, GetRandomReal(0, 359), 1, 1.33, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdl", x, y, GetRandomReal(0, 359), 1, 2.85, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_effect_yuzhiboyou_unusual_fenshendabaopo_2.mdl", x, y, GetRandomReal(0, 359), 1, 2, 1))
                    endif
                        set check3 = 1
                    endif
                    if check3 == 0 then
                        call MoveUnit2(d2, move, a02)
                        if GetDestructableLife(des2) > 0 then
                            // Destructables cannot be moved by the Warcraft III API.
                            call RemoveDestructable(des2)
                            set des2 = null
                            set des2 = CreateDestructable('B017', GetUnitX(d2), GetUnitY(d2), 0, 0.01, 0)
                        endif
                        call GroupClear(g3)
                        
                        set x = GetUnitX(d2)+550* Cos(a02)
                        set y = GetUnitY(d2)+550* Sin(a02)
                        call GroupEnumUnitsInRange(g3 , x,y, aoe , Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup( g3 )
                            exitwhen u == null
                            if SpellBool( u ) then
                                if IsUnitInGroup(u, g2) == false then
                                    if IsUnitInGroup(u, g4) == false then
                                        call GroupAddUnit(g4, u)
                                        call StunUnit(u, u, 1.5)
                                        if GetUnitState(u,UNIT_STATE_LIFE)-dmg<=3 and IsUnitType(u,UNIT_TYPE_HERO) and IsUnitIllusion(u)==false then 
                        set TrainKill = TrainKill + 1
                        endif
                                        call SetHpCurrent(u, -dmg)
                                        call soundcheck(u)
                                        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdl", u, "chest"))
                                    endif
                                    call SetUnitPosition(u, x + 15 * Cos(a02), y + 15 * Sin(a02))
                                endif
                            endif
                            call GroupRemoveUnit( g3 , u )
                        endloop
                    endif
                    if PathableCheck(GetUnitX(d) + 580 * Cos(a01), GetUnitY(d) + 580 * Sin(a01)) == false then
                        set check2 = 2
                    endif
                    if PathableCheck(GetUnitX(d2) + 580 * Cos(a02), GetUnitY(d2) + 580 * Sin(a02)) == false then
                        set check3 = 2
                    endif
                    if (SR2(d, d2) < 1000 and check == 1) or (check2 == 1 and check3 == 1 ) or (check2 == 2 and check3 == 2 ) then
                        set r = 99999
                    endif
                else 
                    if check2 != 1 then 
                    set x = GetUnitX(d)
                    set y = GetUnitY(d)
                    call SetUnitAnimation(d, "death")
                    call ColorDummy3(d, 0, 255, 255, 255, 0.75)
                    call GroupClear(g3)
                    call GroupEnumUnitsInRange(g3 , x, y, 650 , Condition(function NoDecor_Filter))
                    loop
                        set u = FirstOfGroup( g3 )
                        exitwhen u == null
                        if SpellBool( u ) then
                        if GetUnitState(u,UNIT_STATE_LIFE)-dmg2<=3 and IsUnitType(u,UNIT_TYPE_HERO) and IsUnitIllusion(u)==false  then 
                        set TrainKill = TrainKill + 1
                        endif
                            call SetHpCurrent(u, -dmg2)
                            call soundcheck(u)
                        endif
                        call GroupRemoveUnit( g3 , u )
                    endloop
                    call ScaleDummy(UnitSpawn(Player(PLAYER_NEUTRAL_PASSIVE),Fire_ID,x,y,1,1,1.75,45,9),7.5,1.75,0.5)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_t8_by_wood_effect_order_dange_daoguang_baozha_2_2_clear.mdl", x, y, GetRandomReal(0, 359), 1, 1.33, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdl", x, y, GetRandomReal(0, 359), 1, 2.85, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_effect_yuzhiboyou_unusual_fenshendabaopo_2.mdl", x, y, GetRandomReal(0, 359), 1, 2, 1))
                    endif
                    if check3 != 1 then 
                    set x = GetUnitX(d2)
                    set y = GetUnitY(d2)
                    call GroupClear(g3)
                    call GroupEnumUnitsInRange(g3 , x, y, 650 , Condition(function NoDecor_Filter))
                    loop
                        set u = FirstOfGroup( g3 )
                        exitwhen u == null
                        if SpellBool( u ) then
                        if GetUnitState(u,UNIT_STATE_LIFE)-dmg2<=3 and IsUnitType(u,UNIT_TYPE_HERO) and IsUnitIllusion(u)==false  then 
                        set TrainKill = TrainKill + 1
                        endif
                            call SetHpCurrent(u, -dmg2)
                            call soundcheck(u)
                        endif
                        call GroupRemoveUnit( g3 , u )
                    endloop
                    call SetUnitAnimation(d2, "death")
                    call ColorDummy3(d2, 0, 255, 255, 255, 0.75)
                    call ScaleDummy(UnitSpawn(Player(PLAYER_NEUTRAL_PASSIVE),Fire_ID,x,y,1,1,1.75,45,9),7.5,1.75,0.5)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_t8_by_wood_effect_order_dange_daoguang_baozha_2_2_clear.mdl", x, y, GetRandomReal(0, 359), 1, 1.33, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_OnePiece_AiSi_DaYanJieYanDi_2.mdl", x, y, GetRandomReal(0, 359), 1, 2.85, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_effect_yuzhiboyou_unusual_fenshendabaopo_2.mdl", x, y, GetRandomReal(0, 359), 1, 2, 1))
                    endif
                    call RemoveDestructable(des1)
                    call RemoveDestructable(des2)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    call DestroyGroup(g3)
                    call DestroyGroup(g4)
                    set g = null
                    set g2 = null
                    set g3 = null
                    set g4 = null
                    set u = null
                    set d = null
                    set d2 = null
                    set des1 = null
                    set des2 = null
                    set m_RoundTrain[i] = m_RoundTrain[ MUI_RoundTrain]
                    set MUI_RoundTrain = MUI_RoundTrain - 1
                    if MUI_RoundTrain == -1 then
                        call PauseTimer( t_RoundTrain)
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method Train_Start takes nothing returns nothing
            local thistype this = thistype.create( )
            set MUI_RoundTrain = MUI_RoundTrain + 1
            set m_RoundTrain[ MUI_RoundTrain] = this
            set k = GetRandomInt(1, 8)
            set check = 0
            set check2 = 0
            set check3 = 0
            set r = 0
            if k == 1 then
                set x1 = GetRectCenterX(gg_rct_TrainLeftUp)
                set y1 = GetRectCenterY(gg_rct_TrainLeftUp)
                set x2 = GetRectCenterX(gg_rct_TrainRightBottom)
                set y2 = GetRectCenterY(gg_rct_TrainRightBottom)
                set r6 = 0
                set r7 = 180
            elseif k == 2 then
                set x1 = GetRectCenterX(gg_rct_TrainLeftBottom)
                set y1 = GetRectCenterY(gg_rct_TrainLeftBottom)
                set x2 = GetRectCenterX(gg_rct_TrainRightUp)
                set y2 = GetRectCenterY(gg_rct_TrainRightUp)
                set r6 = 0
                set r7 = 180
            elseif k == 3 then
                set x1 = GetRectCenterX(gg_rct_TrainRightUp)
                set y1 = GetRectCenterY(gg_rct_TrainRightUp)
                set x2 = GetRectCenterX(gg_rct_TrainLeftBottom)
                set y2 = GetRectCenterY(gg_rct_TrainLeftBottom)
                set r6 = 180
                set r7 = 0
            elseif k == 4 then
                set x1 = GetRectCenterX(gg_rct_TrainRightBottom)
                set y1 = GetRectCenterY(gg_rct_TrainRightBottom)
                set x2 = GetRectCenterX(gg_rct_TrainLeftUp)
                set y2 = GetRectCenterY(gg_rct_TrainLeftUp)
                set r6 = 180
                set r7 = 0
            elseif k == 5 then
                set x1 = GetRectCenterX(gg_rct_TrainLeftBottom)
                set y1 = GetRectCenterY(gg_rct_TrainLeftBottom)
                set x2 = GetRectCenterX(gg_rct_TrainLeftUp)
                set y2 = GetRectCenterY(gg_rct_TrainLeftUp)
                set r6 = 0
                set r7 = 0
            elseif k == 6 then
                set x1 = GetRectCenterX(gg_rct_TrainRightBottom)
                set y1 = GetRectCenterY(gg_rct_TrainRightBottom)
                set x2 = GetRectCenterX(gg_rct_TrainRightUp)
                set y2 = GetRectCenterY(gg_rct_TrainRightUp)
                set r6 = 180
                set r7 = 180
            elseif k == 7 then
                set check = 1
                set x1 = GetRectCenterX(gg_rct_TrainRightUp)
                set y1 = GetRectCenterY(gg_rct_TrainRightUp)
                set x2 = GetRectCenterX(gg_rct_TrainLeftUp)
                set y2 = GetRectCenterY(gg_rct_TrainLeftUp)
                set r6 = 180
                set r7 = 0
            elseif k == 8 then
                set check = 1
                set x1 = GetRectCenterX(gg_rct_TrainRightBottom)
                set y1 = GetRectCenterY(gg_rct_TrainRightBottom)
                set x2 = GetRectCenterX(gg_rct_TrainLeftBottom)
                set y2 = GetRectCenterY(gg_rct_TrainLeftBottom)
                set r6 = 180
                set r7 = 0
            endif
            set g = CreateGroup()
            set g2 = CreateGroup()
            set g3 = CreateGroup()
            set g4 = CreateGroup()
            set u = null
            set move = 1
            call MakeSound("war3mapimported\\TrainSound")
            set d = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'h00G', x1, y1, r6 + 180)
            set d2 = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'h00G', x2, y2, r7 + 180)
            call ColorDummy4(d, 0, 255, 255, 255, 0.3)
            call ColorDummy4(d2, 0, 255, 255, 255, 0.3)
            call SetUnitTimeScale(d, 2)
            call SetUnitTimeScale(d2, 2)
            set des1 = CreateDestructable('B017', GetUnitX(d), GetUnitY(d), 0, 0.01, 0)
            set des2 = CreateDestructable('B017', GetUnitX(d2), GetUnitY(d2), 0, 0.01, 0)
            set rmax = 10
            set dmg = 250 + CurrentRound*100
            set dmg2 = 500 + CurrentRound*125
            set aoe = 275
            call PlayersMsg("|c00FF0303Author:|r Train coming.", 3)
            if MUI_RoundTrain == 0 then
                call TimerStart( t_RoundTrain, 0.03, true, function thistype.Loop_Train_Start)
            endif
        endmethod
    endstruct
    function SukunaEnd takes nothing returns nothing
        call RoundEnd.SukunaEnd_Start()
    endfunction
    function TrainStart takes nothing returns nothing
        call RoundEnd.Train_Start()
    endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
