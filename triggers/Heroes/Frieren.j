library FrierenSpells initializer InitFrierenSpells uses GearSystems
    globals
        private timer FrierenTimer03
        private code FrierenTimer03Callback
        private integer FrierenTimer03Users = 0
//--------------------------------------Frieren--------------------------------------------------------------
        integer Frieren_ID = 'H02H'
//---------------Q ability-----------------------------------------------------
        integer FrierenQ_ID = 'A0GK'
        integer FrierenQ2_ID = 'A0GL'
        integer FrierenQ3_ID = 'A0GM'
        real FrierenQ_DamageIntBase = 1 // base number x Str damage for 1 level
        real FrierenQ_DamageIntStep = 1 // additional number x Str damage for each next level
        real FrierenQ_Damage2StaticBase = 150 // base static damage for 1 level
        real FrierenQ_Damage2StaticStep = 0 // additional static damage for each next level
        real FrierenQ2_DamageIntBase = 0.2 // base number x Str damage for 1 level
        real FrierenQ2_DamageIntStep = 0.2 // additional number x Str damage for each next level
        real FrierenQ2_Damage2StaticBase = 40 // base static damage for 1 level
        real FrierenQ2_Damage2StaticStep = 0 // additional static damage for each next level
        real FrierenQ3_DamageIntBase = 5 // base number x Str damage for 1 level
        real FrierenQ3_DamageIntStep = 0 // additional number x Str damage for each next level
        real FrierenQ3_Damage2StaticBase = 150 // base static damage for 1 level
        real FrierenQ3_Damage2StaticStep = 0 // additional static damage for each next level
        real FrierenQ_DamageAoe = 300
        real FrierenQ3_DamageAoe = 675
        real FrierenQ_RangeBase = 1200 // base 
        real FrierenQ_RangeStep = 100 // base 
        real FrierenQ_TimeSwap_Q2 = 4
        real FrierenQ_TimeSwap_Q3 = 5 
//---------------W ability-----------------------------------------------------
        integer FrierenW_ID = 'A0GN'
        integer FrierenW2_ID = 'A0GO'
        real FrierenW2_DamageIntBase = 1.5 // base number x Str damage for 1 level
        real FrierenW2_Damage2StaticBase = 75 // base static damage for 1 level
        real FrierenW2_DamageAoe = 600
        real FrierenW_DamageIntBase = 1 // base number x Str damage for 1 level
        real FrierenW_DamageIntStep = 1 // additional number x Str damage for each next level
        real FrierenW_Damage2StaticBase = 150 // base static damage for 1 level
        real FrierenW_Damage2StaticStep = 0 // additional static damage for each next level
        real FrierenW_PushRange = 200
        real FrierenW_DamageAoe = 200
        real FrierenW_PushDuration = 0.39
        real FrierenW_Stun = 0.5
//---------------E ability-----------------------------------------------------
        integer FrierenE_ID = 'A0GP'
        real FrierenE_DamageIntBase = 1 // base number x Str damage for 1 level
        real FrierenE_DamageIntStep = 0.2 // additional number x Str damage for each next level
        real FrierenTE_DamageIncrease = 1 // additional number x Str damage for each next level
        real FrierenTE_DamageAoeIncrease = 25 // %
        real FrierenE_Damage2StaticBase = 0 // base static damage for 1 level
        real FrierenE_Damage2StaticStep = 0 // additional static damage for each next level
        real FrierenE_DamageAoe = 650
        integer FrierenE_Slow = 40
        integer FrierenE_Duration = 2
//---------------R ability-----------------------------------------------------
        integer FrierenR_ID = 'A0GQ' 
        integer FrierenR_SpellID = 'A0GS' // Жезл иллюзий
        integer FrierenTR_unitid = 'h02I'
        real FrierenR_CloneDamageMultiplier1 = 40 // %
        real FrierenR_CloneDamageMultiplier2 = 60 // %
        real FrierenTR_DamageIntBase = 4 // base number x Str damage for 1 level
        real FrierenTR_DamageAoe = 550
        real FrierenTR_Stun = 0.5
        real FrierenTR_Duration = 16
        real FrierenR_CloneRangeCast = 3000
        real FrierenR_CloneSearchDuration = 0.1
//---------------T ability-----------------------------------------------------
        integer FrierenT_ID = 'A0GR'
        real FrierenT_DamageIntBase = 5 // base number x Str damage for 1 level
        real FrierenT_Duration = 20
        real FrierenT_DamageAoe = 750
        real FrierenT_ReduceCD = 5
        real FrierenT_Stun = 1
//---------------T2 ability-----------------------------------------------------
        integer FrierenT2_ID = 'A0GT'
        real FrierenT2_DamageIntBase = 8 // base number x Str damage for 1 level
        real FrierenT2_DamageAoe = 600
        integer FrierenT2_Slow = 60
        integer FrierenT2_SlowDuration = 1
//---------------G ability-----------------------------------------------------
        integer FrierenG_ID = 'A0GU'
        integer FrierenG_BuffID1 = 'B02V'
        integer FrierenG_BuffID2 = 'B02W'
        integer FrierenG_BuffID3 = 'B02X'
        integer FrierenG_SpellID = 'A0GJ'
        real FrierenG_Duration = 1.5 // duration of raienryuu mode
        real FrierenG_DamageAoe = 450
//---------------F ability-----------------------------------------------------
        integer FrierenF_ID = 'A0GW'
        integer FrierenTF_ID = 'A0GV'
        integer FrierenTF_BuffID = 'B02U'
        integer FrierenTF_SpellID = 'A0GI'
        real FrierenTF_RememberDamage = 50 // 30% of dealt damage from frieren saves to next explode
        real FrierenTF_PierceShield = 15 // 30% of dealt damage from frieren saves to next explode
//------------------------------------------------------------------------------
    endglobals
    globals
        private group FrierenF_Group = CreateGroup()
    endglobals
    private function FrierenCloneCheck takes unit c returns boolean
        return IsUnitIllusion(c) == false and GetUnitTypeId(c) != FrierenTR_unitid
    endfunction
    private function UpdateGIcon takes integer stacks returns nothing
        if stacks >= 10 then
            call BlzSetAbilityIcon(FrierenG_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Frieren_G3.blp")
        elseif stacks >= 5 then
            call BlzSetAbilityIcon(FrierenG_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Frieren_G2.blp")
        else
            call BlzSetAbilityIcon(FrierenG_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Frieren_G.blp")
        endif
    endfunction
    function FrierenF_Stacks takes unit c returns nothing
        local unit f
        local integer stacks
        if GetHeroLevel(c) <= 6 then
            return
        endif
    // Фрирен кастует сама — поиск юнитов не нужен.
        if GetUnitTypeId(c) == Frieren_ID then
            set stacks = S2I(TasAbilityChargeBox_GetValue(c, FrierenF_ID))
            if stacks < 10 then
                call TasAbilityChargeBox_SetValue(c, FrierenF_ID, I2S(stacks + 1))
                call UpdateGIcon(stacks + 1)
            endif
            return
        endif
        call GroupEnumUnitsInRange(FrierenF_Group, GetUnitX(c), GetUnitY(c), 1500.00, null)
        loop
            set f = FirstOfGroup(FrierenF_Group)
            exitwhen f == null
            call GroupRemoveUnit(FrierenF_Group, f)
            if GetUnitTypeId(f) == Frieren_ID and IsUnitAlly(f, GetOwningPlayer(c)) and GetWidgetLife(f) > 0.405 then
                set stacks = S2I(TasAbilityChargeBox_GetValue(f, FrierenF_ID))
                if stacks < 10 then
                    call TasAbilityChargeBox_SetValue(f, FrierenF_ID, I2S(stacks + 1))
                    call UpdateGIcon(stacks + 1)
                endif
                set f = null
                return
            endif
        endloop
        set f = null
    endfunction
    private function FrierenTimer03Acquire takes nothing returns nothing
        set FrierenTimer03Users = FrierenTimer03Users + 1
        if FrierenTimer03Users == 1 then
            call TimerStart(FrierenTimer03, 0.03, true, FrierenTimer03Callback)
        endif
    endfunction
    private function FrierenTimer03Release takes nothing returns nothing
        set FrierenTimer03Users = FrierenTimer03Users - 1
        if FrierenTimer03Users <= 0 then
            set FrierenTimer03Users = 0
            call PauseTimer(FrierenTimer03)
        endif
    endfunction
    private struct FrierenSpells_Q
        private static integer array m_FrierenQ
        private static integer MUI_FrierenQ = -1
        unit c
        unit statSource
        real x
        real y
        real r2
        real scale
        real scale2
        real r3
        real r5
        real r6
        real r7
        group g
        group g2
        group g3
        unit u
        real dmg
        integer check
        real aoe
        real move
        real x1
        real y1
        integer k
        real r
        effect e
        real a
        real rmax
        public static method Loop_FrierenQ takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rkek = 0
            loop
                exitwhen i > MUI_FrierenQ
                set this = m_FrierenQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if check == 0 then
                        call DebugUnit2(c)
                        if r == 0.24 then
                            set r5 = 190
                            set e = EffectSpawn3("war3mapImported\\wos_frieren_sign.mdl", GetUnitX(c) + r5 * Cos(a), GetUnitY(c) + r5 * Sin(a), a * bj_RADTODEG, 1, 1, 160, -90)
                            call ScaleEffDummy(e, 0.15, 0.01, 1.1)
                        endif
                        if r > 0.33 then
                            if r2 > 0.09 then
                                set r2 = 0
                            else
                                set r2 = r2 + 0.03
                            endif
                            if r3 > 0.15 then
                                set r3 = 0
                            else
                                set r3 = r3 + 0.03
                            endif
                        endif
                        call DebugUnit2(c)
                        if r == 0.6 then
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_by_wood_bashenan_juqi_2_2.mdl", GetUnitX(c) + r5 * Cos(a), GetUnitY(c) + r5 * Sin(a), 0, 1, 2.5, 255, 255, 255, 255, 255))
                        endif
                        if r >= 0.6 then
                            call StopSpellUnit2(c)
                            set check = 1
                            if FrierenCloneCheck(c) then
                                call MakeSound("war3mapimported\\Hero_Frieren_Q1 1")
                            endif
                            set x1 = GetUnitX(c) + 150 * Cos(a)
                            set y1 = GetUnitY(c) + 150 * Sin(a)
                            set rmax = (r7 / move) * 0.03
                            set r = 0
                            set r2 = 10
                            set scale = 7.25
                            set scale2 = 1.765
                            set r5 = 0
                        endif
                    elseif check == 1 then
                        if move >= r7 then
                            set r = 9999
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_by_wood_bashenan_juqi_2_2.mdl", x, y, 0, 1, 3.5, 255, 255, 255, 255, 255))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_1baozha_90.mdl", x, y, 1, 1, 2.15, 1))
                            call EffectSpawn2("war3mapimported\\wos_LD2209 (157).mdx", x, y, GetRandomReal(0, 359), 1, 1.8, 0, 1)
                            call EffectSpawn2("war3mapimported\\wos_LD2209 (157).mdx", x, y, GetRandomReal(0, 359), 1, 2.2, 0, 1)
                            //    call EffectSpawn2("war3mapimported\\wos_kamni.mdx", x, y, GetRandomReal(0, 359), 1.5 , 1.2, 0, 0.35)
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_dustgaraa2.mdx", x, y, GetRandomReal(0, 359), 1, 1.5, 0))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_T_dustgaraa2.mdx", x, y, GetRandomReal(0, 359), 1, 2, 0))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_BY_Wood_Eff_Ord_YeYe_Eat_DiBanZhaKai2.mdx", x, y, GetRandomReal(0, 359), 1.5, 1.35, 0))
                        endif
                        set k = 0
                        loop
                            exitwhen k > 1
                            if r < 0.09 then
                                set move = move + 9 + ( scale * 8 )
                            else
                                set move = move + 18 + ( scale * 9 )
                            endif
                            if PathableCheck(x1 + move * Cos( a ), y1 + move * Sin( a )) then
                                set x = x1 + move * Cos( a )
                                set y = y1 + move * Sin( a )
                            endif
                            set rkek = 0
                            call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx" , x , y , a * bj_RADTODEG , 1 , scale , 150 + r * 80 , 0.45 , 0 , 15 , 255 , 145)
                            call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx" , x , y , a * bj_RADTODEG , 1 , scale * 0.7 , 150 + r * 80 , 0.45 , 225 , 225 , 225 , 155)
                            set scale = scale + 0.01
                            set k = k + 1
                        endloop
                        if r3 > 0.03 then
                            set r3 = 0
                            set scale2 = scale2 + 0.005
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", x, y, a * bj_RADTODEG , 1, 1.1, 1, 255, 255, 255, 115))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_1baozha_90.mdl", x, y, 1, 1, 1.75, 1))
                            call DestroyEffect(EffectSpawnColor3("war3mapimported\\wos_whitering.mdx", x + rkek * Cos(a ) , y + rkek * Sin(a) , a * bj_RADTODEG, 3.75, scale2, 265, -90, 0, 75, 255, 255))
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_cf2.mdx", x + rkek * Cos(a ) , y + rkek * Sin(a) , a * bj_RADTODEG, 1, 1.75, 15, 255, 255, 255, 125))
                        else
                            set r3 = r3 + 0.03
                        endif
                        if r6 > 0.03 then
                            set r6 = 0
                              //  call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue--zhendi31_3.mdl", x, y, GetRandomReal(0, 359), 0.85, 2.5, 1))
                            call DecorRemove(c, x + r2 * Cos(a), y + r2 * Sin(a), aoe * StarrkEQ_AoeMultiplier, 50)
                            call VisionTimed(GetOwningPlayer(c), x + r2 * Cos(a), y + r2 * Sin(a), aoe * StarrkEQ_AoeMultiplier + 400, 2)
                        else
                            set r6 = r6 + 0.03
                        endif
                        if r2 > 0.03 then
                            set r2 = 0
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , x , y , aoe * StarrkEQ_AoeMultiplier , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup( u , g2 ) == false then
                                    call dmgmag(c, u, dmg)
                                        //call MUE(u, StarrkEQ_PushDistance, StarrkEQ_PushDuration, a)
                                    call GroupAddUnit( g2 , u )
                                    call GroupAddUnit( g3 , u )
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                            call SaveGroupHandle(hs, GetHandleId(c), StringHash("frieren q group"), g3)
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    call ColorEffDummy3(e, 0, 255, 255, 255, 0.3)
                    if r <= 1.5 and check == 0 then
                        call StopSpellUnit2(c)
                    endif
                    if FrierenCloneCheck(c) then
                    if GetUnitAbilityLevel(c,FrierenQ_ID)>=3 and FirstOfGroup(g3) != null and GetWidgetLife(FirstOfGroup(g3))>5 then
                        call SwapAbility(c, FrierenQ_TimeSwap_Q2 , FrierenQ2_ID, FrierenQ_ID)
                    call SetUnitAbilityLevel(c,FrierenQ2_ID,GetUnitAbilityLevel(c,FrierenQ_ID))
                          call MyFrame(c,FrierenQ_TimeSwap_Q2 ,"BTNHero_Frieren_Q2",false,0)
                    else
                        if LoadInteger(hs, GetHandleId(c), StringHash("mode t")) == 1 then
                            call SwapAbility(c, FrierenQ_TimeSwap_Q3, FrierenQ3_ID, FrierenQ_ID)
                          call MyFrame(c,FrierenQ_TimeSwap_Q3 ,"BTNHero_Frieren_Q3",false,1)
                        endif
                        call RemoveSavedHandle(hs, GetHandleId(c), StringHash("frieren q group"))
                        call DestroyGroup(g3)
                        set g3 = null
                    endif
                    endif
                    call DestroyGroup( g )
                    set g = null
                    call DestroyGroup( g2 )
                    set g2 = null
                    set g3 = null
                    set c = null
                    set statSource = null
                    set e = null
                    set u = null
                    set m_FrierenQ[i] = m_FrierenQ[ MUI_FrierenQ]
                    set m_FrierenQ[MUI_FrierenQ] = 0
                    set MUI_FrierenQ = MUI_FrierenQ - 1
                    if MUI_FrierenQ == -1 then
                        call FrierenTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method FrierenQ_Start takes unit NewC, unit NewStatSource, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_FrierenQ = MUI_FrierenQ + 1
            set m_FrierenQ[ MUI_FrierenQ] = this
            set c = NewC
            set statSource = NewStatSource
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set r3 = 1
            set scale = 1.5
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set check = 0
            set move = 70
            set r7 = FrierenQ_RangeBase + (FrierenQ_RangeStep* (GetUnitAbilityLevel(c,FrierenQ_ID)-1))
            set aoe = FrierenQ_DamageAoe
            set g3 = LoadGroupHandle(hs, GetHandleId(c), StringHash("frieren q group"))
            if g3 == null then
                set g3 = CreateGroup()
            endif
            call GroupClear(g3)
            call SaveGroupHandle(hs, GetHandleId(c), StringHash("frieren q group"), g3)
            set dmg = GetHeroInt( statSource , true) * ( FrierenQ_DamageIntBase + ( FrierenQ_DamageIntStep * ( GetUnitAbilityLevel( statSource , FrierenQ_ID) - 1 ) ) )
            set dmg = dmg + FrierenQ_Damage2StaticBase + ( FrierenQ_Damage2StaticStep * ( GetUnitAbilityLevel( statSource , FrierenQ_ID) - 1 ) )
            call SetUnitFacing( c , a * bj_RADTODEG)
            call SetUnitTimeScale( c , 0.65)
            if FrierenCloneCheck(c) then
                call MakeSound("war3mapimported\\Hero_Frieren_Q1 2")
            call SetUnitAnimationByIndex( c , 1)
            else            
            call SetUnitAnimation( c ,"attack")
            endif
            set rmax = 3
            if MUI_FrierenQ == 0 then
                call FrierenTimer03Acquire()
            endif
        endmethod
    endstruct
    private struct FrierenSpells_FrierenQ2_Act
        private static integer array m_Item11
        private static integer MUI_Item11 = -1
        unit c
        unit statSource
        unit td
        real x
        real y
        real a2
        real dmg
        real move
        real r
        effect e
        integer k
        effect e3
        real r2
        real a
        real rmax
        public static method Loop_FrierenQ2_Act takes nothing returns nothing
            local integer this
            local integer i = 0
            local real step
            loop
                exitwhen i > MUI_Item11
                set this = m_Item11[i]
                if SpellBoolCaster(td) and r <= rmax and SR5(e, GetUnitX(td), GetUnitY(td)) > move*2 then
                    set r = RoundReal(r + 0.03, 3)
                    call BlzSetSpecialEffectYaw(e, a)
                    set k = 0
                    set step = move / 2
                    loop
                        exitwhen k == 2
                        set a = GAngle5(e, GetUnitX(td), GetUnitY(td))
                        call MoveEff2(e, step, a + a2 * bj_DEGTORAD)
                        call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx" , GetEffX(e) , GetEffY(e) , a * bj_RADTODEG , 1 , 3.5 , 90 , 0.15 , 0 , 15 , 255 , 255)
                        call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx" , GetEffX(e) , GetEffY(e) , a * bj_RADTODEG , 1 , 2.75 , 90 , 0.15 , 215, 215 , 215 , 255)
                        set a = GAngle5(e3, GetUnitX(td), GetUnitY(td))
                        call BlzSetSpecialEffectYaw(e3, a)
                        call MoveEff2(e3, step, a - a2 * bj_DEGTORAD)
                        call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx" , GetEffX(e3) , GetEffY(e3) , a * bj_RADTODEG , 1 , 3.5 , 90 , 0.15 , 0 , 15 , 255 , 255)
                        call EffectSpawnColor2("war3mapimported\\wos_ulqashar.mdx" , GetEffX(e3) , GetEffY(e3) , a * bj_RADTODEG , 1 , 2.75 , 90 , 0.15 , 215, 215 , 215 , 255)
                        set k = k + 1
                    endloop
                    if r2> 0.0 then
                    call VisionTimed(GetOwningPlayer(c),GetEffX(e) , GetEffY(e),250,1)
                    call VisionTimed(GetOwningPlayer(c),GetEffX(e3) , GetEffY(e3),250,1)
                    call DecorRemove(c,GetEffX(e) , GetEffY(e),250,10)
                    call DecorRemove(c,GetEffX(e3) , GetEffY(e3),250,10)
                    endif
                else
                    call DestroyEffect(e)
                    call DestroyEffect(e3)
                    call dmgmag(c, td, dmg)
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    //call DestroyEffect(EffectSpawn("war3mapImported\\wos_WTW-whitethunder-Zi.mdl", x, y, GetRandomReal(0, 359), 1.5, 2, 0))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_SasukeYh-41.mdl", x, y, GetRandomReal(0, 359), 1.5, 3, 75))
                    set c = null
                    set statSource = null
                    set td = null
                    set e = null
                    set e3 = null
                    set m_Item11[i] = m_Item11[ MUI_Item11]
                    set m_Item11[MUI_Item11] = 0
                    set MUI_Item11 = MUI_Item11 - 1
                    if MUI_Item11 == -1 then
                        call FrierenTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method FrierenQ2_Act_Start takes unit NewC, unit NewStatSource, unit NewTd, integer NewK returns nothing
            local thistype this = thistype.create( )
            local real x1
            local real y1
            local real r5
            set MUI_Item11 = MUI_Item11 + 1
            set m_Item11[ MUI_Item11] = this
            set c = NewC
            set statSource = NewStatSource
            set td = NewTd
            set a = GAngle(c, td)
            set rmax = 1.5
            set move = 140
            set r2 = 0
            set r = 0
            if NewK == 0 then
                set a2 = GetRandomReal(25, 35)
            elseif NewK == 1 then
                set a2 = GetRandomReal(35, 45)
            elseif NewK == 2 then
                set a2 = GetRandomReal(45, 60)
            elseif NewK == 3 then
                set a2 = GetRandomReal(60, 75)
            else
                set a2 = GetRandomReal(75, 90)
            endif
            set dmg = GetHeroInt( statSource , true) * ( FrierenQ2_DamageIntBase + ( FrierenQ2_DamageIntStep * ( GetUnitAbilityLevel( statSource , FrierenQ_ID) - 1 ) ) )
            set dmg = dmg + FrierenQ2_Damage2StaticBase + ( FrierenQ2_Damage2StaticStep * ( GetUnitAbilityLevel( statSource , FrierenQ_ID) - 1 ) )
            set r5 = GetRandomReal( -250, 250)
            set x1 = GetUnitX(c) + r5 * Cos(a + 90 * bj_DEGTORAD)
            set y1 = GetUnitY(c) + r5 * Sin(a + 90 * bj_DEGTORAD)
            call SetUnitAnimation(c, "attack")
            set e = EffectSpawnScale("war3mapImported\\wos_Windwalk Blue Soul.mdl", x1, y1, a * bj_RADTODEG, 1, 0.01, 25, 0.15, 0.01, 1)
            set r5 = GetRandomReal( -250, 250)
            set x1 = GetUnitX(c) + r5 * Cos(a + 90 * bj_DEGTORAD)
            set y1 = GetUnitY(c) + r5 * Sin(a + 90 * bj_DEGTORAD)
            call SetUnitAnimation(c, "attack")
            set e3 = EffectSpawnScale("war3mapImported\\wos_Windwalk Blue Soul.mdx", x1, y1, a * bj_RADTODEG, 1, 0.01, 25, 0.15, 0.01, 1)
            if MUI_Item11 == 0 then
                call FrierenTimer03Acquire()
            endif
        endmethod
    endstruct
    private struct FrierenSpells_Q2
        private static integer array m_FrierenQ2
        private static integer MUI_FrierenQ2 = -1
        unit c
        unit statSource
        real r2
        real scale
        real r3
        real r5
        group g3
        unit u
        integer check
        integer k
        real r
        effect array ee [60]
        real a
        real rmax
        integer targetCount // Сколько целей было изначально
        integer shotsOnTarget // Сколько выстрелов уже сделано в текущую цель
        integer shotsPerTarget // Сколько выстрелов нужно сделать в текущую цель
        public static method Loop_FrierenQ2 takes nothing returns nothing
            local integer this
            local integer i = 0
            local integer sideIndex = 0
            local real signAngle
            local integer final
            loop
                exitwhen i > MUI_FrierenQ2
                set this = m_FrierenQ2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if check == 0 then
                        call DebugUnit2(c)
                        if r == 0.24 then
                            set k = 0
                            set final = targetCount * 2
                            if final < 6 then
                                set final = 8
                            endif
                            loop
                                exitwhen k == final or k > 57
    // Каждый знак на своей дистанции: 120, 185, 250 и т. д.
                                set r5 = GetRandomReal(100 + sideIndex * 60, 145 + sideIndex * 60)
                                if ModuloInteger(k, 2) == 0 then
        // Чётные: правая сторона от направления каста.
                                    set signAngle = a + (90 + GetRandomReal( -18, 18)) * bj_DEGTORAD
                                else
        // Нечётные: левая сторона от направления каста.
                                    set signAngle = a - (90 + GetRandomReal( -18, 18)) * bj_DEGTORAD
                                    set sideIndex = sideIndex + 1
                                endif
                                set ee[k] = EffectSpawn3("war3mapImported\\wos_frieren_sign.mdl", GetUnitX(c) + r5 * Cos(signAngle), GetUnitY(c) + r5 * Sin(signAngle), signAngle * bj_RADTODEG + 90, 1, 0.35, GetRandomReal(150, 250), -90)
                                call ScaleEffDummy(ee[k], 0.15, 0.01, 0.45)
                                set k = k + 1
                            endloop
                        endif
                        if r > 0.33 then
                            if r2 > 0.09 then
                                set r2 = 0
                            else
                                set r2 = r2 + 0.03
                            endif
                            if r3 > 0.15 then
                                set r3 = 0
                            else
                                set r3 = r3 + 0.03
                            endif
                        endif
                        call DebugUnit2(c)
                        if r == 0.6 then
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_by_wood_bashenan_juqi_2_2.mdl", GetUnitX(c) + r5 * Cos(a), GetUnitY(c) + r5 * Sin(a), 0, 1, 2.5, 255, 255, 255, 255, 255))
                        endif
                        if r >= 0.6 then
                            call StopSpellUnit2(c)
                            set check = 1
                            if FrierenCloneCheck(c) then
                                call MakeSound("war3mapimported\\Hero_Frieren_Q2 1")
                            endif
                            set r = 0
                            set r2 = 10
                            set scale = 7.25
                            set r5 = 0
                        endif
                    elseif check == 1 then
                        if FirstOfGroup(g3) == null then
                            set r = 999
                        endif
                        if r2 > 0.03 then
                            set r2 = 0
                            set u = FirstOfGroup(g3)
                            call FrierenSpells_FrierenQ2_Act.FrierenQ2_Act_Start(c, statSource, u, shotsOnTarget)
                            set shotsOnTarget = shotsOnTarget + 1
// Убираем цель только после нужного количества попаданий.
                            if shotsOnTarget >= shotsPerTarget then
                                call GroupRemoveUnit(g3, u)
                                call SaveGroupHandle(hs, GetHandleId(c), StringHash("frieren q group"), g3)
                                set shotsOnTarget = 0
    // При трёх целях только первая получает два выстрела.
                                if targetCount == 3 then
                                    set shotsPerTarget = 1
                                endif
                            endif
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    if r <= 1.5 and check == 0 then
                        call StopSpellUnit2(c)
                    endif
                    if FrierenCloneCheck(c) then
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(FrierenQ_ID)), 0)
                    if LoadInteger(hs, GetHandleId(c), StringHash("mode t")) == 1 then
                        call SwapAbility(c, FrierenQ_TimeSwap_Q3, FrierenQ3_ID, FrierenQ_ID)
                        call MyFrame(c,FrierenQ_TimeSwap_Q3 ,"BTNHero_Frieren_Q3",false,1)
                    endif
                    endif
                    set k = 0
                    set final = targetCount * 2
                    if final < 6 then
                        set final = 8
                    endif
                    loop
                        exitwhen k == final or k > 57
                        call ColorEffDummy3(ee[k], 0, 255, 255, 255, 0.15)
                        set ee[k] = null
                        set k = k + 1
                    endloop
                    call RemoveSavedHandle(hs, GetHandleId(c), StringHash("frieren q group"))
                    call DestroyGroup(g3)
                    set g3 = null
                    set c = null
                    set statSource = null
                    set u = null
                    set m_FrierenQ2[i] = m_FrierenQ2[ MUI_FrierenQ2]
                    set m_FrierenQ2[MUI_FrierenQ2] = 0
                    set MUI_FrierenQ2 = MUI_FrierenQ2 - 1
                    if MUI_FrierenQ2 == -1 then
                        call FrierenTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method FrierenQ2_Start takes unit NewC, unit NewStatSource returns nothing
            local thistype this = thistype.create( )
            set MUI_FrierenQ2 = MUI_FrierenQ2 + 1
            set m_FrierenQ2[ MUI_FrierenQ2] = this
            set c = NewC
            set statSource = NewStatSource
            set r = 0
            set r2 = 10
            set r3 = 1
            set scale = 1.5
            call StartSpellUnit2(c)
            set u = null
            set a = GetUnitFacing(c) * bj_DEGTORAD // Angle Between points
            set check = 0
            set g3 = LoadGroupHandle(hs, GetHandleId(c), StringHash("frieren q group"))
            set targetCount = GetUnitsCountInGroup(g3, GetUnitX(c), GetUnitY(c))
            set shotsOnTarget = 0
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(FrierenQ_ID)), 1)
            if targetCount == 1 then
                set shotsPerTarget = 4
            elseif targetCount == 2 then
                set shotsPerTarget = 2
            elseif targetCount == 3 then
                set shotsPerTarget = 2 // Первая цель получит два выстрела
            else
                set shotsPerTarget = 1
            endif
            set a = GAngle(c, FirstOfGroup(g3))
            call SetUnitFacing( c , a * bj_RADTODEG)
            call SetUnitTimeScale( c , 0.65)
            call SetUnitAnimationByIndex( c , 2)
            if FrierenCloneCheck(c) then
                call MakeSound("war3mapimported\\Hero_Frieren_Q2 2")
                call MakeSound("war3mapimported\\Hero_Frieren_Q2 3")
            endif
            set rmax = 3
            if MUI_FrierenQ2 == 0 then
                call FrierenTimer03Acquire()
            endif
        endmethod
    endstruct
    private struct FrierenSpells_TQ
        private static integer array m_FrierenTQ
        private static integer MUI_FrierenTQ = -1
        unit c
        unit statSource
        unit td
        real x
        real y
        real dmg
        real move
        group g
        unit u
        real aoe
        real r
        real r2
        integer check
        effect e2
        real a
        real rmax
        public static method Loop_FrierenTQ takes nothing returns nothing
            local integer this
            local integer k
            local integer i = 0
            loop
                exitwhen i > MUI_FrierenTQ
                set this = m_FrierenTQ[i]
                if SpellBoolCaster(c) and r <= rmax and SpellBoolCaster(td) then
                    set r = RoundReal(r + 0.03, 3)
                    set a = GAngle(c, td)
                    call SetUnitFacing(c, a * bj_RADTODEG)
                    if check == 0 then
                        if r == 0.45 then
                            call SetUnitAnimationByIndex(c, 25)
                        endif
                        if r > 0.45 then
                            if SR2(c, td) > 160 then
                                set x = GetUnitX(c)
                                set y = GetUnitY(c)
                                call MoveUnit(c, move, a)
                            // The original `r2 >= 0.0` was permanently true,
                            // making DecorRemove and two effects run every 0.03.
                                set r2 = r2 + 0.03
                                if r2 >= 0.12 then
                                    set r2 = 0.0
                                    call DecorRemove(c, x, y, 350.0, 20.0)
                                endif
                            else
                                call SetUnitPosition(c, GetUnitX(td) - 175 * Cos(a), GetUnitY(td) - 175 * Sin(a))
                                call StartSpellUnit2(td)
                                if FrierenCloneCheck(c) then
                                    call MakeSound("war3mapimported\\Hero_Frieren_W3")
                                endif
                                call SetUnitTimeScale(c, 1)
                                call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_YC_CrossFlash", c, "weapon"))
                                set x = GetUnitX(td)
                                set y = GetUnitY(td)
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlash.mdl" , x , y, 1, 1.15, 1.675, 125))
                                set r = 0
                                set r2 = 0
                                set check = 1
                            endif
                        endif
                    elseif check == 1 then
                        call DebugUnit2(td)
                        call DebugUnit(c)
                        if r == 0.3 then
                            call DestroyEffect(e2)
                            set e2 = null
                        endif
                        if r == 0.3 then
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            call ErzaPassive(c, td, 3)
                            if FrierenCloneCheck(c) then
                                call MakeSound("war3mapimported\\Hero_Frieren_Q3 1")
                            endif
                         //call StunUnit(c,td,FrierenTQ_Stun)
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_by_wood_bashenan_juqi_2_2.mdl", GetUnitX(c) , GetUnitY(c) , 0, 1, 2.5, 255, 255, 255, 255, 255))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (426)1.mdl", x , y , a * bj_RADTODEG, 1.25, 6.75, 250))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_1lanse_99.mdl", x , y , a * bj_RADTODEG, 2, 1.1, 1))
                    //  call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (431232).mdl", x, y, GetRandomReal(0, 359), 0.5, 2.55, 15))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (513).mdl", x, y, GetRandomReal(0, 359), 0.65, 1, 15))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_blue--zhendi31_3_x2.mdl", x, y, GetRandomReal(0, 359), 0.5, 1, 1))
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_by_wood_effect_order_dange_yueyun_2withoutblue2.mdl", x, y, GetRandomReal(0, 359), 0.5, 1.75, 1, 255, 255, 255, 255))
                            if FrierenCloneCheck(c) then
                                call MakeSound("war3mapimported\\Hero_Frieren_F3")
                            endif
                            call DecorRemove(c, x, y, 350, 20)
                            set r = 99999
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_AZ_D073.mdl", x , y , a * bj_RADTODEG, 1.35, 1, 1))
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_A_P.blast3.mdl", x , y , a * bj_RADTODEG, 2.85, 1.3, 1), 0.3, 255, 255, 255, 0.65)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlash.mdl" , x + 25 * Cos(a), y + 25 * Sin(a), 1, 1.15, 3.475, 125))
                            set k = 0
                            loop
                                exitwhen k == 10
                                call ColorEffDummy3(EffectSpawnColor("war3mapimported\\wos_ulqashar.mdx" , x , y , a * bj_RADTODEG , 1 , 15 , 150 + k * 240 , 0 , 15 , 255 , 145), 0.3, 0, 15, 255, 0.5)
                                call ColorEffDummy3(EffectSpawnColor("war3mapimported\\wos_ulqashar.mdx" , x , y , a * bj_RADTODEG , 1 , 15 * 0.75 , 150 + k * 240 , 0 , 15 , 255 , 145), 0.3, 225, 225, 225, 0.5)
                                set k = k + 1
                            endloop
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , x , y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    call dmgmag(c, u, dmg)
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        endif
                    endif
                else
                    if check == 1 then
                        call StopSpellUnit2(td)
                    endif
                    call DestroyEffect(e2)
                    call StopSpellUnit(c)
                    call SetUnitTimeScale(c, 1)
                    call DestroyGroup(g)
                    set g = null
                    set u = null
                    call SetUnitVertexColor(c, 255, 255, 255, 255)
                    set c = null
                    set statSource = null
                    set td = null
                    set e2 = null
                    set m_FrierenTQ[i] = m_FrierenTQ[MUI_FrierenTQ]
                    set m_FrierenTQ[MUI_FrierenTQ] = 0
                    set MUI_FrierenTQ = MUI_FrierenTQ - 1
                    if MUI_FrierenTQ == -1 then
                        call FrierenTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method FrierenTQ_Start takes unit NewC, unit NewStatSource, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_FrierenTQ = MUI_FrierenTQ + 1
            set m_FrierenTQ[MUI_FrierenTQ] = this
            set c = NewC
            set statSource = NewStatSource
            set td = NewTd
            set r = 0
            set r2 = 0
            set check = 0
            set move = 105
            set rmax = 3
            call StartSpellUnit(c)
            set g = CreateGroup()
            set u = null
            if GetUnitTypeId(c) == FrierenTR_unitid then
                call SetUnitAnimation(c, "attack")
            else
                call SetUnitAnimationByIndex(c, 24)
            endif
            call SetUnitTimeScale(c, 1.5)
            set dmg = GetHeroInt( statSource , true) * ( FrierenQ3_DamageIntBase + ( FrierenQ3_DamageIntStep * ( GetUnitAbilityLevel( statSource , FrierenQ_ID) - 1 ) ) )
            set dmg = dmg + FrierenQ3_Damage2StaticBase + ( FrierenQ3_Damage2StaticStep * ( GetUnitAbilityLevel( statSource , FrierenQ_ID) - 1 ) )
            set aoe = FrierenQ3_DamageAoe
            if FrierenCloneCheck(c) then
                call MakeSound("war3mapimported\\Hero_Frieren_Q3 2")
            endif
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiblue.mdl", c, "weapon")
       //set e2 = AddSpecialEffectTarget("war3mapImported\\wos_YellowMissile.mdl", c, "hand right")
            if MUI_FrierenTQ == 0 then
                call FrierenTimer03Acquire()
            endif
        endmethod
    endstruct
    private struct FrierenSpells_W
        private static integer array m_FrierenW
        private static integer MUI_FrierenW = -1
        unit c
        unit statSource
        unit td
        real x
        real y
        real x1
        real y1
        real r2
        real r3
        real r5
        lightning l
        real r6
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
        real a
        real rmax
        public static method Loop_FrierenW takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_FrierenW
                set this = m_FrierenW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if check == 0 then
                        call DebugUnit2(c)
                        set a = GAngle(c, td)
                        call SetUnitFacing(c, a * bj_RADTODEG)
                        if r3 >= 0.06 and r < 0.54 then
                            set r3 = 0
                            set r5 = GetRandomReal(105, 255)
                            set r6 = GetRandomReal(0, 359) * bj_DEGTORAD
                            set x = GetUnitX(c) + r5 * Cos(r6)
                            set y = GetUnitY(c) + r5 * Sin(r6)
                            call DecorRemove(c, x, y, aoe, 20)
                            call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_sdmikotopurple.mdx", x, y, GetRandomReal(0, 359), 1, 2, 0), 0.3, 255, 255, 255, 0.3)
                          //  call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_[1]AtomicThunder.mdx", x, y, GetRandomReal(0, 359), 1, 1.1, 0), 0.3, 255, 255, 255, 0.3)
                        else
                            set r3 = r3 + 0.03
                        endif
                        if r == 0.3 then
                            set move = 100
                            set r5 = 0
                            set e = EffectSpawn("war3mapImported\\wos_ChuShou_BY_Wood_Effect_Glow_GuiPaiQiGong_XuLiPurple.mdl", GetUnitX(c) + 130 * Cos(a), GetUnitY(c) + 130 * Sin(a), a * bj_RADTODEG, 1, 3, 100)
                            set e2 = EffectSpawn("war3mapImported\\wos_krk (1849)6.mdl", GetUnitX(c) + 195 * Cos(a), GetUnitY(c) + 195 * Sin(a), a * bj_RADTODEG, 1, 2, 150)
                            set x1 = GetUnitX(c) + 10 * Cos(a)
                            set y1 = GetUnitY(c) + 10 * Sin(a)
                            set l = AddLightningEx("FR01", false, GetUnitX(c) + 10 * Cos(a), GetUnitY(c) + 10 * Sin(a), GetUnitFlyHeight(c) + 100, x1, y1, GetUnitFlyHeight(c) + 100)
                        endif
                        if r > 0.6 then
                            set rmax = 2
                            set r6 = 10
                            set r = 0
                            set check = 1
                            if FrierenCloneCheck(c) then
                                call MakeSound("war3mapimported\\Hero_Frieren_W3")
                            endif
                            call StopSpellUnit2(c)
                            set x1 = GetUnitX(c) + 130 * Cos(a)
                            set y1 = GetUnitY(c) + 130 * Sin(a)
                        endif
                    elseif check == 1 then
                        set k = 0
                        set r5 = r5 + move
                        set a = GAngle5(e, GetUnitX(td), GetUnitY(td))
                        call MoveEff(e, move, a)
                        call MoveEff(e2, move, a)
                        call BlzSetSpecialEffectYaw(e, a)
                        call BlzSetSpecialEffectYaw(e2, a)
                        call MoveLightningEx(l, false, GetUnitX(c) + 10 * Cos(a), GetUnitY(c) + 10 * Sin(a), GetUnitFlyHeight(c) + 100, GetEffX(e), GetEffY(e), GetUnitFlyHeight(c) + 100)
                        if r6 >= 0.03 then
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_cf2.mdl", GetEffX(e) + 155 * Cos(a), GetEffY(e) + 155 * Sin(a), a * bj_RADTODEG, 1.15, 0.75, 15, 255, 25, 255, 255))
                            set r6 = 0
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , GetEffX(e) , GetEffY(e) , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup( u , g2 ) == false then
                                    call dmgmag(c, u, dmg)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                    call GroupAddUnit( g2 , u )
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        else
                            set r6 = r6 + 0.03
                        endif
                        if SR5(e, GetUnitX(td), GetUnitY(td)) < 120 then
                            set r = 9999
                        endif
                        if r2 >= 0.03 then
                            set r2 = 0
                            call DecorRemove(c, GetEffX(e) , GetEffY(e), aoe, 25)
                            call VisionTimed(GetOwningPlayer(c), GetEffX(e) , GetEffY(e), 700, 1)
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    if r == 9999 then
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_purple wave explosion.mdl", x, y, a * bj_RADTODEG, 1.25, 1, 2))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_RaidenEi-8.mdl", x, y, a * bj_RADTODEG, 1, 1.5, 0))
                        call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_sdmikotopurple.mdx", x, y, GetRandomReal(0, 359), 1, 2, 0), 0.3, 255, 255, 255, 0.3)
                        call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_[1]AtomicThunder.mdx", x, y, GetRandomReal(0, 359), 1, 1.1, 0), 0.3, 255, 255, 255, 0.3)
                        call StunUnit(c, td, FrierenW_Stun)
                    endif
                    if GetHeroLevel(c)>=35 then 
                                call ErzaPassive(c,td,3)
                                endif
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call SetUnitTimeScale( c , 1)
                    if r <= 0.42 then
                        call StopSpellUnit2(c)
                    endif
                        call DestroyLightning(l)
                        call DestroyGroup( g )
                    set g = null
                    set l = null
                    set e = null
                    set td = null
                    set e2 = null
                    call DestroyGroup( g2 )
                    set g2 = null
                    set c = null
                    set statSource = null
                    set u = null
                    set m_FrierenW[i] = m_FrierenW[ MUI_FrierenW]
                    set m_FrierenW[MUI_FrierenW] = 0
                    set MUI_FrierenW = MUI_FrierenW - 1
                    if MUI_FrierenW == -1 then
                        call FrierenTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method FrierenW_Start takes unit NewC, unit NewStatSource, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_FrierenW = MUI_FrierenW + 1
            set m_FrierenW[ MUI_FrierenW] = this
            set c = NewC
            set statSource = NewStatSource
            set td = NewTd
            set r = 0
            set r2 = 0
            set move = 0
            set r6 = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set check = 0
            set k = 0
            set aoe = FrierenW_DamageAoe + 25
            set dmg = GetHeroInt( statSource , true) * ( FrierenW_DamageIntBase + ( FrierenW_DamageIntStep * ( GetUnitAbilityLevel( statSource , FrierenW_ID) - 1 ) ) )
            set dmg = dmg + FrierenW_Damage2StaticBase + ( FrierenW_Damage2StaticStep * ( GetUnitAbilityLevel( statSource , FrierenW_ID) - 1 ) )
            set rmax = 2
            set a = GAngle(c, td)
            call SetUnitFacing(c, a * bj_RADTODEG)
            if FrierenCloneCheck(c) then
                call MakeSound("war3mapimported\\Hero_Frieren_W")
                call MakeSound("war3mapimported\\Hero_Frieren_W2")
            endif
            call SetUnitAnimationByIndex(c, 12)
            call SetUnitTimeScale(c, 0.65)
            if MUI_FrierenW == 0 then
                call FrierenTimer03Acquire()
            endif
        endmethod
    endstruct
    private struct FrierenSpells_W2
        private static integer array m_FrierenW2
        private static integer MUI_FrierenW2 = -1
        unit c
        unit u
        group g
        group g2
        effect e
        real a2
        real x
        real move
        real a
        effect array ee[7]
        real y
        real r
        real r2
        real r3
        real r4
        real r5
        real r6
        real rmax
        real aoe
        real dmg
        integer k
        public static method Loop_FrierenW2 takes nothing returns nothing
            local integer this
            local integer i = 0
            local real x1
            local real y1
            local real rr1
            local real rr2
            loop
                exitwhen i > MUI_FrierenW2
                set this = m_FrierenW2[i]
                if SpellBoolCaster(c) and r < rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set r2 = RoundReal(r2 + 0.03, 3)
                    set r3 = RoundReal(r3 + 0.03, 3)
                    set r4 = RoundReal(r4 + 0.03, 3)
                    set r5 = RoundReal(r5 + 0.03, 3)
                    set r6 = RoundReal(r6 + 0.03, 3)
                    set x = x + move * Cos(a)
                    set y = y + move * Sin(a)
                    call BlzSetSpecialEffectPosition(e, x, y, 265)
                    set k = 0
                    loop
                        exitwhen k == 6
                        call BlzSetSpecialEffectPosition(ee[k], x + 50 * Cos(k * 60 * bj_DEGTORAD), y + 50 * Sin(k * 60 * bj_DEGTORAD), 225)
                        call BlzSetSpecialEffectYaw(ee[k], a2 + 60 * k * bj_DEGTORAD)
                        set k = k + 1
                    endloop
                    set a2 = a2 + 6 * bj_DEGTORAD
                    call BlzSetSpecialEffectYaw(e, a2)
                    if r2 >= 0.21 then
                        set r2 = 0.00
                        call VisionTimed(GetOwningPlayer(c), x, y, aoe, 1)
                    endif
                    if r3 > 0.09 then
                        set r3 = 0
                        set rr1 = GetRandomReal(125, 455)
                        set rr2 = GetRandomReal(0, 359) * bj_DEGTORAD
                        set x1 = x + rr1 * Cos(rr2)
                        set y1 = y + rr1 * Sin(rr2)
                        if GetRandomInt(1, 2) == 1 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-trlightning2.mdl", x1, y1, GetRandomReal(0, 359), 1, 1, 0))
                        endif
                        set rr1 = GetRandomReal(125, 455)
                        set rr2 = GetRandomReal(0, 359) * bj_DEGTORAD
                        set x1 = x + rr1 * Cos(rr2)
                        set y1 = y + rr1 * Sin(rr2)
                        call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_sdmikotopurple.mdx", x1, y1, GetRandomReal(0, 359), 1, 2, 0), 0.3, 255, 255, 255, 0.3)
                          //  call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_[1]AtomicThunder.mdx", x, y, GetRandomReal(0, 359), 1, 1.1, 0), 0.3, 255, 255, 255, 0.3)
                    endif
                    if r4 > 0.3 then
                        set r4 = 0
                        set rr1 = GetRandomReal(125, 455)
                        set rr2 = GetRandomReal(0, 359) * bj_DEGTORAD
                        set x1 = x + rr1 * Cos(rr2)
                        set y1 = y + rr1 * Sin(rr2)
                        call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_[1]AtomicThunder.mdx", x1, y1, GetRandomReal(0, 359), 1, 1.1, 0), 0.3, 255, 255, 255, 0.3)
                    //call BlzPlaySpecialEffect(e2,ANIM_TYPE_BIRTH)2
                    //call BlzPlaySpecialEffect(e4,ANIM_TYPE_DEATH)
                   //call EffectSpawn2("war3mapimported\\wos_Naruto_Effect_DaiTu_ShenWei.mdl", x, y, GetRandomReal(0, 359), 0.65, 3, 275,0.5)
                   // call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_BY_Wood_Effect_Void_KaKaXi_ShenWei_FangChu.mdl", x, y, GetRandomReal(0, 359), 0.65, 2.75, 275, 255, 255, 255, 255))
                    endif
                    if r6 >= 0.5 then
                        set r6 = 0
                        call GroupClear(g2)
                    endif
                    if r5 >= 0.1 then
                        set r5 = 0.00
                        call DecorRemove(c, x, y, aoe, 50)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and IsUnitInGroup(u, g2) == false then
                                call dmgmag(c, u, dmg)
                                if GetHeroLevel(c)>=35 then 
                                call ErzaPassive(c,u,3)
                                endif
                                call GroupAddUnit(g2, u)
                                call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_[1]AtomicThunder.mdx", GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359), 1, 1.1, 0), 0.3, 255, 255, 255, 0.3)
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_mei-trlightning2.mdl", GetUnitX(u), GetUnitY(u), GetRandomReal(0, 359), 1, 2, 0))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                else
                    //call StopSpellUnit2(c)
                    set k = 0
                    loop
                        exitwhen k == 6
                        call DestroyEffect(ee[k])
                        set ee[k] = null
                        set k = k + 1
                    endloop
                    //call ColorEffDummy3(e,0,255,255,255,0.15)
                    call DestroyEffect(e)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set c = null
                    set u = null
                    set e = null
                    set m_FrierenW2[i] = m_FrierenW2[MUI_FrierenW2]
                    set m_FrierenW2[MUI_FrierenW2] = 0
                    set MUI_FrierenW2 = MUI_FrierenW2 - 1
                    if MUI_FrierenW2 == -1 then
                        call FrierenTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method FrierenW2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this
            if NewC == null then
                return
            endif
            set this = thistype.create()
            set MUI_FrierenW2 = MUI_FrierenW2 + 1
            set m_FrierenW2[MUI_FrierenW2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.00
            set r2 = 0.3
            set r3 = 0.3
            set r6 = 0
            set r5 = 0
            set r4 = 0
            set rmax = 3
            set aoe = FrierenW2_DamageAoe
            set k = 0
            set move = 30
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set dmg = FrierenW2_Damage2StaticBase+ (GetInt(c) * FrierenW2_DamageIntBase)
            set a = GAngle2(c, x, y)
            set a2 = GAngle2(c, x, y)
            set x = GetUnitX(c) + 1 * Cos(a)
            set y = GetUnitY(c) + 1 * Sin(a)
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            call SetUnitAnimationByIndex(c, 21)
            set e = EffectSpawn("war3mapimported\\wos_3ygnz_1_2.mdx", x, y, 1, 0.45, 3, 225)
            set k = 0
            loop
                exitwhen k == 6
                set ee[k] = EffectSpawn("war3mapimported\\wos_krk (1849)6.mdx", x + 50 * Cos(k * 60 * bj_DEGTORAD), y + 50 * Sin(k * 60 * bj_DEGTORAD), k * 60, 0.65, 0.75, 225)
                set k = k + 1
                call ScaleEffDummy(e, 0.75, 0.01, 2.45)
            endloop
            if FrierenCloneCheck(c) then
                call MakeSound("war3mapimported\\Hero_Frieren_W4")
                call MakeSound("war3mapimported\\Hero_Frieren_W5")
            endif
            if MUI_FrierenW2 == 0 then
                call FrierenTimer03Acquire()
            endif
        endmethod
    endstruct
    private struct FrierenSpells_E
        private static integer array m_FrierenE
        private static integer MUI_FrierenE = -1
        unit c
        // Настоящая Фрирен: используется только для расчёта характеристик.
        // Источником урона остаётся c — герой или его иллюзия.
        unit statSource
        unit td
        real x
        real y
        real r3
        real r5
        real r6
        integer k
        group g
        group g2
        unit u
        real dmg
        integer check2
        real aoe
        real aoe2
        real r
        real rmax
        public static method Loop_FrierenE takes nothing returns nothing
            local integer this
            local integer j
            local integer tries
            local real dx
            local real dy
            local boolean positionOk
            local integer i = 0
            loop
                exitwhen i > MUI_FrierenE
                set this = m_FrierenE[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if r3 >= 0.42 then
                        set r3 = 0.03
                        set td = null
// Сначала ищем ещё не задетую цель вокруг Фрирен.
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, GetUnitX(c), GetUnitY(c), aoe2, null)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            call GroupRemoveUnit(g, u)
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                set td = u
                                exitwhen true
                            endif
                        endloop
                        if td != null then
    // Столб гарантированно появляется прямо в позиции новой цели.
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                        else
                            set tries = 0
                            loop
                                set r6 = GetRandomReal(0, 360) * bj_DEGTORAD
                                if check2 == 1 then
                                    set r5 = GetRandomReal(355, 665)
                                else
                                    set r5 = GetRandomReal(275, 455)
                                endif
                                set x = GetUnitX(c) + r5 * Cos(r6)
                                set y = GetUnitY(c) + r5 * Sin(r6)
                                set positionOk = true
                                set j = 0
                                loop
                                    exitwhen j >= k
                                    set dx = x - LoadReal(hs, this, StringHash("FrierenEColumnX" + I2S(j)))
                                    set dy = y - LoadReal(hs, this, StringHash("FrierenEColumnY" + I2S(j)))
                                    if dx * dx + dy * dy < 275 * 275 then
                                        set positionOk = false
                                        exitwhen true
                                    endif
                                    set j = j + 1
                                endloop
                                set tries = tries + 1
                                exitwhen positionOk or tries >= 20
                            endloop
                        endif
                        call SaveReal(hs, this, StringHash("FrierenEColumnX" + I2S(k)), x)
                        call SaveReal(hs, this, StringHash("FrierenEColumnY" + I2S(k)), y)
                        set k = k + 1
                        if check2 == 0 then
                            call DecorRemove(c, x, y, aoe, 50)
                          
                            call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_yc_firebeam2.mdx", x, y, GetRandomReal(0, 359), 1.35, 0.6, 0), 0.3, 255, 255, 255, 0.5)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_tx033_5.mdl", x, y, 1, 2, 1.35, 1))
                        else
                            call DecorRemove(c, x, y, aoe, 50)
                            call ColorEffDummy3(EffectSpawn("war3mapimported\\wos_yc_firebeam2.mdx", x, y, GetRandomReal(0, 359), 1.35, 0.82, 0), 0.3, 255, 255, 255, 0.5)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_tx033_5.mdl", x, y, 1, 2, 1.75, 1))
                        endif
                        call VisionTimed(GetOwningPlayer(c),x,y,aoe+200,1.5)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call dmgmag(c, u, dmg) 
                                call ErzaPassive(c,u,1)
                                call SlowUnit(c,u,FrierenE_Slow,FrierenE_Duration)
                                if IsUnitInGroup(u, g2) == false then
                                    call GroupAddUnit(g2, u)
                                endif
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                        set td = null
                    else
                        set r3 = r3 + 0.03
                    endif
                else
                    call SetUnitTimeScale( c , 1)
                    call DestroyGroup( g )
                    call DestroyGroup(g2)
                    call FlushChildHashtable(hs, this)
                    set g2 = null
                    set g = null
                    set c = null
                    set statSource = null
                    set u = null
                    set m_FrierenE[i] = m_FrierenE[ MUI_FrierenE]
                    set m_FrierenE[MUI_FrierenE] = 0
                    set MUI_FrierenE = MUI_FrierenE - 1
                    if MUI_FrierenE == -1 then
                        call FrierenTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method FrierenE_Start takes unit NewC, unit NewStatSource returns nothing
            local thistype this = thistype.create( )
            set MUI_FrierenE = MUI_FrierenE + 1
            set m_FrierenE[ MUI_FrierenE] = this
            set c = NewC
            set statSource = NewStatSource
            set r = 0
            set r6 = 0
            set g2 = CreateGroup()
            set r3 = 0
            set aoe2 = 600
            set check2 = 0
            set aoe = FrierenE_DamageAoe
            set dmg = GetHeroInt( statSource , true) * ( FrierenE_DamageIntBase + ( FrierenE_DamageIntStep * ( GetUnitAbilityLevel( statSource , FrierenE_ID) - 1 ) ) )
            set dmg = dmg + FrierenE_Damage2StaticBase + ( FrierenE_Damage2StaticStep * ( GetUnitAbilityLevel( statSource , FrierenE_ID) - 1 ) )
            
            if LoadInteger(hs, GetHandleId(c), StringHash("mode t")) == 1 then
                set check2 = 1
                set aoe2 = 950
                set dmg = dmg + GetInt(c)*FrierenTE_DamageIncrease
                set aoe = aoe * (1+(FrierenTE_DamageAoeIncrease/100))
            endif
            set g = CreateGroup()
            set u = null
            set k = 0
            set rmax = 3.5
            if FrierenCloneCheck(c) then
                call MakeSound("war3mapimported\\Hero_Frieren_E")
                call NextSound("war3mapimported\\Hero_Frieren_E3", 0.51)
                call NextSound("war3mapimported\\Hero_Frieren_E2", 1.02)
            endif
            call SetAnimIndex(c, 0.03, 9)
            if MUI_FrierenE == 0 then
                call FrierenTimer03Acquire()
            endif
        endmethod
    endstruct
    private struct FrierenRSearch
        private static integer array instances
        private static integer count = -1
        unit c
        real x
        real y
        real r
        integer generation
        group g
        group existing

        public static method Loop takes nothing returns nothing
            local integer this
            local integer i = 0
            local unit u
            local unit illusion
            local boolean finished
            loop
                exitwhen i > count
                set this = instances[i]
                set r = RoundReal(r + 0.03, 3)
                set illusion = null
                set finished = generation != LoadInteger(hs, GetHandleId(c), StringHash("Frieren R search generation"))

                // Ищем возле текущей позиции героя: новая иллюзия появляется рядом с ним,
                // а x/y являются точкой, куда найденный клон будет перенесён.
                if not finished then
                    call GroupClear(g)
                    call GroupEnumUnitsInRange(g, GetUnitX(c), GetUnitY(c), 800.00, null)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        call GroupRemoveUnit(g, u)
                        if GetOwningPlayer(u) == GetOwningPlayer(c) and IsUnitIllusion(u) and GetUnitTypeId(u) == GetUnitTypeId(c) and not IsUnitInGroup(u, existing) then
                            set illusion = u
                            exitwhen true
                        endif
                    endloop
                endif

                if illusion != null then
                    call SaveUnitHandle(hs, GetHandleId(c), StringHash("Frieren R illusion"), illusion)
                    call SetUnitUserData(illusion,25)
                    call SaveInteger(hs, GetHandleId(illusion), StringHash("Frieren R owner"), GetHandleId(c))
                    call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_ade (blue).mdx", illusion, "origin"))
                    call BlinkEff(illusion)
                    call PosUnit(illusion, x, y)
                    call BlinkEff(illusion)
                    set finished = true
                elseif r >= FrierenR_CloneSearchDuration then
                    set finished = true
                endif

                if finished then
                    call DestroyGroup(g)
                    call DestroyGroup(existing)
                    set g = null
                    set existing = null
                    set c = null
                    set instances[i] = instances[count]
                    set instances[count] = 0
                    set count = count - 1
                    if count == -1 then
                        call FrierenTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
            set u = null
            set illusion = null
        endmethod

        public static method Start takes unit caster, real targetX, real targetY returns nothing
            local thistype this = thistype.create()
            local unit d
            local unit u
            local group cleanup = CreateGroup()
            local integer nextGeneration = LoadInteger(hs, GetHandleId(caster), StringHash("Frieren R search generation")) + 1

            // Новый каст отменяет незавершённый поиск предыдущего каста этого героя.
            call SaveInteger(hs, GetHandleId(caster), StringHash("Frieren R search generation"), nextGeneration)

            // Удаляем все старые иллюзии Фрирен этого игрока, включая те,
            // которые прежний короткий поиск не успел сохранить или пометить.
            call GroupEnumUnitsInRect(cleanup, bj_mapInitialPlayableArea, null)
            loop
                set u = FirstOfGroup(cleanup)
                exitwhen u == null
                call GroupRemoveUnit(cleanup, u)
                if GetOwningPlayer(u) == GetOwningPlayer(caster) and IsUnitIllusion(u) and GetUnitTypeId(u) == GetUnitTypeId(caster) and GetUnitUserData(u)== 25 then
                    call RemoveSavedInteger(hs, GetHandleId(u), StringHash("Frieren R owner"))
                    call RemoveUnit(u)
                endif
            endloop
            call RemoveSavedHandle(hs, GetHandleId(caster), StringHash("Frieren R illusion"))

            // Запоминаем все юниты, существовавшие до создания клона R.
            // Поэтому иллюзия от предмета не сможет стать результатом этого поиска.
            set existing = CreateGroup()
            call GroupEnumUnitsInRect(existing, bj_mapInitialPlayableArea, null)
            call DestroyGroup(cleanup)

            set count = count + 1
            set instances[count] = this
            set c = caster
            set r = 0
            set x = targetX
            set y = targetY
            set generation = nextGeneration
            set g = CreateGroup()

            set d = CreateUnit(GetOwningPlayer(c), 'h0C9', GetUnitX(c), GetUnitY(c), 0)
            call UnitAddAbility(d, FrierenR_SpellID)
            call SetUnitAbilityLevel(d, FrierenR_SpellID, GetUnitAbilityLevel(c, FrierenR_ID))
            call IssueTargetOrderById(d, 852274, c)
            call MyRemoveUnit(d, 0.1)
            call MakeSoundLocal("war3mapimported\\Hero_Frieren_R", GetOwningPlayer(c))
            call MakeSoundLocal("war3mapimported\\Hero_Frieren_R2", GetOwningPlayer(c))

            if count == 0 then
                call FrierenTimer03Acquire()
            endif
            set d = null
            set u = null
            set cleanup = null
        endmethod
    endstruct

    private struct FrierenSpells_TR
        private static integer array m_FrierenTR
        private static integer MUI_FrierenTR = -1
        unit c
        unit u
        group g
        effect e
        real fly
        real x
        real move
        real a
        real y
        real r
        real r4
        real rmax
        real aoe
        real dmg
        public static method Loop_FrierenTR takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_FrierenTR
                set this = m_FrierenTR[i]
                if SpellBoolCaster(c) and r < rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set fly = fly - r4
                    call MoveEff2(e, move, a)
                    call BlzSetSpecialEffectHeight(e, fly)
                else
                    //call StopSpellUnit2(c)
                    call DestroyEffect(e)
                    set u = LoadUnitHandle(hs, GetHandleId(c), StringHash("Frieren R illusion"))
                    if u != null then
                        call RemoveUnit(u)
                    endif
                    set u = null
                    set u = CreateUnit(GetOwningPlayer(c), FrierenTR_unitid, x, y, a * bj_RADTODEG)
                    call SaveUnitHandle(hs, GetHandleId(c), StringHash("Frieren R illusion"), u)
                    call UnitApplyTimedLife(u, 'BTLF', FrierenTR_Duration)
                    call SetUnitVertexColor(u, 255, 255, 255, 0)
                    call DecorRemove(c,x,y,aoe, 50)
                    
                    call ScaleDummy(u, 0.5, 1, 1.5)
                    call ColorDummy4(u, 0, 255, 255, 255, 0.5)
                    call MakeSound("war3mapimported\\Hero_Frieren_R4")
                    call DestroyEffect(EffectSpawn3("war3mapImported\\wos_YC_Shockwave_b_red.mdl", x, y , a * bj_RADTODEG + 180, 1.25, 4.85, 125, 0))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_ZarakiWCrack1.mdl", x, y, GetRandomReal(0, 359), 1.25, 2, 5))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlashred.mdl" , x + 25 * Cos(a), y + 25 * Sin(a), 1, 1.15, 2.475, 125))
                    call GroupClear(g)
                    call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                            call dmgphys(c, u, dmg)
                            call StunUnit(c, u, FrierenTR_Stun )
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set u = null
                    set e = null
                    set m_FrierenTR[i] = m_FrierenTR[MUI_FrierenTR]
                    set m_FrierenTR[MUI_FrierenTR] = 0
                    set MUI_FrierenTR = MUI_FrierenTR - 1
                    if MUI_FrierenTR == -1 then
                        call FrierenTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method FrierenTR_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this
            if NewC == null then
                return
            endif
            set this = thistype.create()
            set MUI_FrierenTR = MUI_FrierenTR + 1
            set m_FrierenTR[MUI_FrierenTR] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.00
            set rmax = 0.6
            set aoe = FrierenTR_DamageAoe
            set move = 1400
            set g = CreateGroup()
            set u = null
            set dmg = GetInt(c) * FrierenTR_DamageIntBase
            set a = GAngle2(c, x, y)
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            call SetUnitAnimationByIndex(c, 21)
            set fly = 2100
            set r4 = fly / 20
            set e = EffectSpawn3("war3mapImported\\wos_madara-huitu-11.mdl", x - move * Cos(a), y - move * Sin(a), a * bj_RADTODEG, 0.75, 0.55, fly, -30)
            set a = GAngle5(e, x, y)
            set move = move / 20
            call ColorEffDummy4(e, 0, 255, 255, 255, 0.3)
            call VisionTimed(GetOwningPlayer(c), x, y, aoe, rmax)
            call MakeSound("war3mapimported\\Hero_Frieren_R3")
            if MUI_FrierenTR == 0 then
                call FrierenTimer03Acquire()
            endif
        endmethod
    endstruct
    private struct KS_MoveUnitFrir
        private static integer array m_3
        private static integer MUI_3 = -1
        real r
        real r2
        real a
        real rmax
        integer check
        real move
        unit c

        public static method Loop_MUEFrir takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_3
                set this = m_3[i]
                if c != null and r <= rmax and LoadInteger(hs,GetHandleId(c),StringHash("frieren t push hit"))== 0 then
                    set r = RoundReal(r + 0.03, 3)
                         call MoveUnit3(c, move, a)
                         if r2> 0.0 then 
                         set r2 = 0
                           call DecorRemove(c,GetUnitX(c),GetUnitY(c),400,20)
                            else
                            set r2=r2 + 0.03
                            endif
                    else
                    call SaveInteger(hs,GetHandleId(c),StringHash("frieren t push hit"),0)
                    set c = null
                    set m_3[i] = m_3[MUI_3]
                    set MUI_3 = MUI_3 - 1
                    if MUI_3 == -1 then
                        call GearTimer03Release()
                    endif
                    call destroy()
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod

        public static method MUE_Start1 takes unit NewC, real NewDist, real NewRmax, real NewA returns nothing
            local thistype this
            if NewC == null then
        return
            endif
            set this = thistype.create()
            set MUI_3 = MUI_3 + 1
            set m_3[MUI_3] = this
            set c = NewC
            set r = 0
            set r2 = 0
            set rmax = NewRmax
            set move = (NewDist / (rmax * 100)) * 3
                    call SaveInteger(hs,GetHandleId(c),StringHash("frieren t push hit"),0)
           
            set a = NewA
            if MUI_3 == 0 then
                call GearTimer03Acquire()
            endif
        endmethod

    endstruct
    private struct FrierenSpells_T
        private static integer array m_FrierenT
        private static integer MUI_FrierenT = -1
        unit c
        integer k2
        private static framehandle array frame_pas1
        private static framehandle array frame_pas2
        private static framehandle array frame_pas3
        private static framehandle array frame_pas4
        private static framehandle array frame_pas5
        private static framehandle array frame_pas6
        real r
        effect e
        real aoe
        integer check
        group g
        boolean b
        real dmg
        unit u
        effect e2
        real rmax
        public static method Loop_FrierenT takes nothing returns nothing
            local integer this
            local integer i = 0
            local real remaining
            local real x1
            local real y1
            local real x
            local real y
            local integer k
            local integer k3
            loop
                exitwhen i > MUI_FrierenT
                set this = m_FrierenT[i]
                if SpellBoolCaster(c) and r <= rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false then
                    if check == 0 then
                        set r = RoundReal(r + 0.03, 3)
                        if r == 0.6 then
                            set x = GetUnitX(c)
                            set y = GetUnitY(c)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_es69.mdl", x, y, 0, 1.2, 4, 1))
                            set check = 1
                            set r = 0
                            call StopSpellUnit(c)
                            set k = 0
                            set k3 = 12
                            loop
                                exitwhen k == k3
                                set x1 = x + 250 * Cos((360 / k3) * k * bj_DEGTORAD)
                                set y1 = y + 250 * Sin((360 / k3) * k * bj_DEGTORAD)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_cf2.mdx", x1, y1, k * (360 / k3) + 180, 0.35, 1.65, 1))
                                set k = k + 1
                            endloop
                            set k = 0
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call dmgphys(c,u,dmg)
                                call SaveInteger(hs,GetHandleId(u),StringHash("frieren t push"),1)
                                call MyFlush(GetHandleId(u),StringHash("frieren t push"),0,0.3)
                                    call KS_MoveUnitFrir.MUE_Start1(u, 1000 - SR3(u, x, y), 0.3, GAngle3(x, y, u))
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                            set u = null
                        endif
                    else
                        if IsUnitPaused(c) == false then
                            set r = RoundReal(r + 0.03, 3)
                        endif
                        set remaining = rmax - r
                        if remaining < 0 then
                            set remaining = 0
                        endif
                        if b then
                            call BlzFrameSetValue(frame_pas3[k2], remaining)
                            call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(remaining, 0, 2) + "|r")
                        endif
                    endif
                else
                    if b then
                        if GetLocalPlayer() == Player(k2) then
                            call BlzFrameSetVisible(frame_pas1[k2], false)
                        endif
                    endif
                    if check == 0 then
                        call StopSpellUnit(c)
                    endif
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), FrierenT_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), FrierenT2_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), FrierenF_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), FrierenTF_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), FrierenW_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), FrierenW2_ID, false)
                    call AddUnitAnimationProperties(c, "alternate", false)
                    call SaveInteger(hs, GetHandleId(c), StringHash("mode t"), 0)
                    call DestroyGroup(g)
                    set c = null
                    set e = null
                    set g = null
                    set e2 = null
                    set m_FrierenT[i] = m_FrierenT[ MUI_FrierenT]
                    set m_FrierenT[MUI_FrierenT] = 0
                    set MUI_FrierenT = MUI_FrierenT - 1
                    if MUI_FrierenT == -1 then
                        call FrierenTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method FrierenT_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            local integer id 
            set MUI_FrierenT = MUI_FrierenT + 1
            set m_FrierenT[ MUI_FrierenT] = this
            set c = NewC
            set r = 0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set rmax = FrierenT_Duration
            set check = 0
            call ReduceCooldown(c,FrierenQ_ID,FrierenT_ReduceCD)
            call ReduceCooldown(c,FrierenQ3_ID,FrierenT_ReduceCD)
            call ReduceCooldown(c,FrierenW_ID,FrierenT_ReduceCD)
            call ReduceCooldown(c,FrierenE_ID,FrierenT_ReduceCD)
            call ReduceCooldown(c,FrierenR_ID,FrierenT_ReduceCD)
            call ReduceCooldown(c,FrierenG_ID,FrierenT_ReduceCD)
            call ReduceCooldown(c,FrierenTF_ID,FrierenT_ReduceCD)
         //   call BlzStartUnitAbilityCooldown(c, LaxusQ_ID, 0.01)
            call SetAnimIndex(c, 0.03, 15)
            call StartSpellUnit(c)
            call SaveInteger(hs, GetHandleId(c), StringHash("mode t"), 1)
            set b = FrierenCloneCheck(c)
            set g = CreateGroup()
            set u = null
            set id = GetPlayerId(GetOwningPlayer(c))
            set dmg = GetHeroInt( Hero[id] , true) *  FrierenT_DamageIntBase 
            set aoe = FrierenT_DamageAoe
            call AddUnitAnimationProperties(c, "alternate", true)
            call UnitAddAbility(c, FrierenT2_ID)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), FrierenT_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), FrierenT2_ID, true)
            call UnitAddAbility(c, FrierenTF_ID)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), FrierenF_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), FrierenTF_ID, true)
            call UnitAddAbility(c, FrierenW2_ID)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), FrierenW_ID, false)
            call SetPlayerAbilityAvailable(GetOwningPlayer(c), FrierenW2_ID, true)
            call BlzStartUnitAbilityCooldown(c, FrierenW2_ID, BlzGetUnitAbilityCooldownRemaining(c, FrierenW_ID))
            if b then
                if frame_pas1[k2] == null then
                    set frame_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                    call BlzFrameSetAbsPoint(frame_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18)
                    call BlzFrameSetSize(frame_pas1[k2], 0.135, 0.035)
                    call BlzFrameSetTexture(frame_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                    call BlzFrameSetVisible(frame_pas1[k2], false)
                    if GetLocalPlayer() == Player(k2) then
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
                    call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, rmax + 0.1)
                    call BlzFrameSetValue(frame_pas3[k2], rmax)
                    set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)
                    call BlzFrameSetAbsPoint(frame_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18)
                    call BlzFrameSetSize(frame_pas4[k2], 0.0275, 0.0275)
                    call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Frieren_T.blp", 0, false)
                    set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                    call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                    call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Height of Magic:" + "|r")
                    call BlzFrameSetScale(frame_pas5[k2], 0.9)
                    set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                    call BlzFrameSetAbsPoint(frame_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17)
                    call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                    call BlzFrameSetScale(frame_pas6[k2], 0.9)
                else
                    if GetLocalPlayer() == Player(k2) then
                        call BlzFrameSetVisible(frame_pas1[k2], true)
                    endif
                    call BlzFrameSetValue(frame_pas3[k2], rmax)
                endif
            endif
            if FrierenCloneCheck(c) then
                call MakeSound("war3mapimported\\Hero_Frieren_T1")
                call NextSound("war3mapimported\\Hero_Frieren_T2", 0.8)
                call NextSound("war3mapimported\\Hero_Frieren_T3", 0.45)
            endif
          //  call DestroyEffect(EffectSpawn("war3mapImported\\wos_YellowMissile.mdl",GetUnitX(c),GetUnitY(c),1,1,4,100))
            set e = AddSpecialEffectTarget("war3mapImported\\wos_aurapartblue.mdl", c, "origin")
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_vfx_patchouli_quietmoon2a4.mdl", c, "origin")
            if MUI_FrierenT == 0 then
                call FrierenTimer03Acquire()
            endif
        endmethod
    endstruct
    private struct FrierenSpells_T2
        private static integer array m_FrierenT2
        private static integer MUI_FrierenT2 = -1
        unit c
        unit u
        group g
        effect e
        effect e2
        effect e3
        real a2
        real x
        real move
        real a
        real scale
        real y
        real r
        real r2
        real r3
        real r4
        real rmax
        real aoe
        real dmg
        real dmg2
        integer k
        public static method Loop_FrierenT2 takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rr
            loop
                exitwhen i > MUI_FrierenT2
                set this = m_FrierenT2[i]
                if SpellBoolCaster(c) and r < rmax and k < 10 then
                    set r = RoundReal(r + 0.03, 3)
                    set r2 = RoundReal(r2 + 0.03, 3)
                    set r3 = RoundReal(r3 + 0.03, 3)
                    set r4 = RoundReal(r4 + 0.03, 3)
                    if IsTerrainPathable(x,y,PATHING_TYPE_FLYABILITY)== false then 
                    set x = x + move * Cos(a)
                    set y = y + move * Sin(a)
                    endif
                    if r == 0.9 then
                 //   call BlzPlaySpecialEffect(e,ANIM_TYPE_STAND)
                    endif
                    call BlzSetSpecialEffectPosition(e, x, y, 265)
                    call BlzSetSpecialEffectPosition(e2, x, y, 265)
                    call BlzSetSpecialEffectPosition(e3, x, y, 265)
                    set a2 = a2 + 4 * bj_DEGTORAD
                    call BlzSetSpecialEffectYaw(e, a2)
                    if r2 >= 0.15 then
                        set r2 = 0.00
                        set k = k + 1
                        call DecorRemove(c, x, y, aoe * 1.25, 50)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                set rr = SR3(u, x, y)
                                if rr > 500 then
                                    set rr = 500
                                endif
                                call MUE(u, rr, 0.3, GAngle2(u, x, y))
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                    if r4 > 0.4 then
                        set r4 = 0
                        call BlzPlaySpecialEffect(e3, ANIM_TYPE_STAND)
                    else
                        set r4 = r4 + 0.03
                    endif
                    if r3 >= 0.3 then
                        set r3 = 0.00
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe, NoDecor_Cond)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                                call dmgmag(c, u, dmg)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                    endif
                    if r == 1.8 then
                        if FrierenCloneCheck(c) then
                            call MakeSound("war3mapImported\\Hero_Frieren_W3")
                        endif
                    endif
                else
                    //call StopSpellUnit2(c)
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_OPm (597)red.mdx", x, y, GetRandomReal(0, 359), 2, 1.45, 0))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_1hongse_2red.mdl", x, y, a * bj_RADTODEG + 180, 1, 6.35 * scale, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_by_wood_effect_order_dange_yueyun_2withoutred.mdl", x, y, a * bj_RADTODEG, 1, 1.65 * scale, 1))
                    call DestroyEffect(EffectSpawn3("war3mapImported\\wos_YC_Shockwave_b_red.mdl", x, y , a * bj_RADTODEG + 180, 1.25, 4.85 * scale, 125, 0))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_ZarakiWCrack1.mdl", x, y, GetRandomReal(0, 359), 1.25, 2 * scale, 5))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-Hit-red.mdl", x, y, a * bj_RADTODEG, 1, 3.25 * scale, 200))
                  //  call DestroyEffect(EffectSpawn("war3mapimported\\wos_Satsu-RSFX-4.mdl", x, y, a * bj_RADTODEG + 90, 0.5, 3*scale, 1))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_yz-leimitx13.mdl", x, y, a * bj_RADTODEG + 90, 2.5, 5 * scale, 1))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_AZ_TS_TZRed.mdl", x, y, a * bj_RADTODEG + 90, 2.5, 4 * scale, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlashred.mdl" , x + 25 * Cos(a), y + 25 * Sin(a), 1, 1.15, 2.475 * scale, 125))
                    call GroupClear(g)
                    call GroupEnumUnitsInRange(g, x, y, aoe + 400, NoDecor_Cond)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) then
                            call dmgmag(c, u, dmg2)
                            call SlowUnit(c,u,FrierenT2_Slow,FrierenT2_SlowDuration)
                        endif
                        call GroupRemoveUnit(g, u)
                    endloop
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call DestroyEffect(e3)
                    call DestroyGroup(g)
                    set g = null
                    set c = null
                    set u = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set m_FrierenT2[i] = m_FrierenT2[MUI_FrierenT2]
                    set m_FrierenT2[MUI_FrierenT2] = 0
                    set MUI_FrierenT2 = MUI_FrierenT2 - 1
                    if MUI_FrierenT2 == -1 then
                        call FrierenTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method FrierenT2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this
            if NewC == null then
                return
            endif
            set this = thistype.create()
            set MUI_FrierenT2 = MUI_FrierenT2 + 1
            set m_FrierenT2[MUI_FrierenT2] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0.00
            set r2 = 0.3
            set r3 = 0.3
            set scale = 0.85
            set rmax = 2.5
            set aoe = FrierenT2_DamageAoe
            set k = 0
            set move = 30
            set g = CreateGroup()
            set u = null
            set r4 = 10
              //      call StartSpellUnit2(c)
            set dmg = GetInt(c) * FrierenT2_DamageIntBase
            set dmg2 = dmg / 2
            set dmg = dmg * 0.5
            set dmg = dmg / 6
            set a = GAngle2(c, x, y)
            set a2 = GAngle2(c, x, y)
            set x = GetUnitX(c) + 1 * Cos(a)
            set y = GetUnitY(c) + 1 * Sin(a)
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            call SetUnitAnimationByIndex(c, 21)
            set e = EffectSpawn("war3mapImported\\mei-tsfx-1.mdl", x, y, 1, 0.45, 2, 265)
            set e2 = EffectSpawn("war3mapimported\\wos_Naruto_Effect_DaiTu_ShenWei.mdl", x, y, GetRandomReal(0, 359), 0.65, 2.5, 275)
            set e3 = EffectSpawn("war3mapimported\\wos_Satsu-RSFX-10.mdl", x, y, GetRandomReal(0, 359), 0.65, 3.75, 275)
            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_afbcoyrighthdcec.mdl", x + 150 * Cos(a), y + 150 * Sin(a), GetRandomReal(0, 359), 1.15, 3.25, 255, 255, 255, 255, 255))
            call ScaleEffDummy(e, 0.75, 0.01, 1.75)
            call ScaleEffDummy(e2, 0.75, 0.01, 2.25)
            call ScaleEffDummy(e3, 0.75, 0.01, 3.35)
            call VisionTimed(GetOwningPlayer(c), x, y, aoe, rmax)
            if FrierenCloneCheck(c) then
                call MakeSound("war3mapimported\\Hero_Frieren_TT1")
                call MakeSound("war3mapimported\\Hero_Frieren_TT2")
            endif
            if MUI_FrierenT2 == 0 then
                call FrierenTimer03Acquire()
            endif
        endmethod
    endstruct
    private struct FrierenSpells_G
        private static integer array m_FrierenG
        private static integer MUI_FrierenG = -1
        unit c
        real x
        real y
        real r2
        group g
        unit u
        real aoe
        real r
        effect e
        real rmax
        public static method Loop_FrierenG takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_FrierenG
                set this = m_FrierenG[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    set r2 = r2 + 0.03
                    if r2 >= 0.30 then
                        set r2 = 0
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, aoe + 550, null)
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitAlly(u, GetOwningPlayer(c)) and SR3(u, x, y) <= aoe then
                                call BuffUnit01(c, u, FrierenG_SpellID, "innerfire", 3)
                            else
                                call UnitRemoveAbility(u, FrierenG_BuffID3)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                    endif
                else
                    call GroupClear( g )
                    call GroupEnumUnitsInRange( g , x, y , aoe * 5 , null)
                    loop
                        set u = FirstOfGroup( g )
                        exitwhen u == null
                        if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) == false then
                            call UnitRemoveAbility(u, FrierenG_BuffID3)
                        endif
                        call GroupRemoveUnit( g , u )
                    endloop
                    set u = null
                    call BlzSetSpecialEffectTimeScale(e, 2)
                    call DestroyEffect(e)
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set e = null
                    set u = null
                    set m_FrierenG[i] = m_FrierenG[ MUI_FrierenG]
                    set m_FrierenG[MUI_FrierenG] = 0
                    set MUI_FrierenG = MUI_FrierenG - 1
                    if MUI_FrierenG == -1 then
                        call FrierenTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method FrierenG_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_FrierenG = MUI_FrierenG + 1
            set m_FrierenG[ MUI_FrierenG] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set r2 = 1
            set g = CreateGroup()
            set u = null
             call BuffUnit01(c, u, FrierenG_SpellID, "innerfire", 3)
            set rmax = FrierenG_Duration 
            set aoe = FrierenG_DamageAoe
            call VisionTimed(GetOwningPlayer(c), x, y, aoe + 500, rmax + 1)
            call DecorRemove(c, x, y, aoe, 50)
            set e = EffectSpawn("war3mapImported\\wos_shielddome2.mdl", x, y, 2, 1, 1.475, 35)
            call BlzPlaySpecialEffect(e, ANIM_TYPE_BIRTH)
            if MUI_FrierenG == 0 then
                call FrierenTimer03Acquire()
            endif
        endmethod
    endstruct
    private struct FrierenSpells_F
        private static integer array m_FrierenF
        private static integer MUI_FrierenF = -1
        unit c
        // Настоящая Фрирен: используется только для расчёта характеристик.
        // Источником урона остаётся c — герой или его иллюзия.
        unit td
        real dmg
        real r
        real rmax
        integer phase
        public static method Loop_FrierenF takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_FrierenF
                set this = m_FrierenF[i]
                if GetUnitAbilityLevel(td, FrierenTF_BuffID) > 0 and r <= rmax then
                    set r = RoundReal(r + 0.03, 3)
                    if phase == 0 and r >= 3.78 then
                        set phase = 1
                        call EUTU2(EffectSpawn("war3mapImported\\wos_452.mdl", GetUnitX(td), GetUnitY(td), 0, 1, 0.85, 0), 1.2, 1, td)
                        call MakeSound("war3mapimported\\Hero_Frieren_F2")
                        call MakeSound("war3mapimported\\Hero_Frieren_F")
                    endif
                else
                    set dmg = LoadReal(hs, GetHandleId(td), StringHash("frieren f dmg"))
                    call UnitRemoveAbility(td, FrierenTF_BuffID)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_blood impact.mdl", GetUnitX(td), GetUnitY(td), GetUnitFacing(c), 1, 2.5, 0))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_bloodex-special-23.mdl", GetUnitX(td), GetUnitY(td), GetRandomReal(0, 359), 2.5, 2, 80))
                    call dmgmag(c, td, dmg)
                    call SaveReal(hs, GetHandleId(td), StringHash("frieren f dmg"), 0)
                    set td = null
                    set c = null
                    set m_FrierenF[i] = m_FrierenF[ MUI_FrierenF]
                    set m_FrierenF[MUI_FrierenF] = 0
                    set MUI_FrierenF = MUI_FrierenF - 1
                    if MUI_FrierenF == -1 then
                        call FrierenTimer03Release()
                    endif
                    call deallocate(this)
                    set i = i - 1
                endif
                set i = i + 1
            endloop
        endmethod
        public static method FrierenF_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_FrierenF = MUI_FrierenF + 1
            set m_FrierenF[ MUI_FrierenF] = this
            set c = NewC
            set td = NewTd
            set rmax = 6.99
            set r = 0
            set phase = 0
            call SaveReal(hs, GetHandleId(td), StringHash("frieren f dmg"), 0)
            call MakeSound("war3mapimported\\Hero_Frieren_F3")
            if MUI_FrierenF == 0 then
                call FrierenTimer03Acquire()
            endif
        endmethod
    endstruct
    private function FrierenTimer03Loop takes nothing returns nothing
        call FrierenSpells_Q.Loop_FrierenQ()
        call FrierenSpells_FrierenQ2_Act.Loop_FrierenQ2_Act()
        call FrierenSpells_Q2.Loop_FrierenQ2()
        call FrierenSpells_TQ.Loop_FrierenTQ()
        call FrierenSpells_W.Loop_FrierenW()
        call FrierenSpells_W2.Loop_FrierenW2()
        call FrierenSpells_E.Loop_FrierenE()
        call FrierenRSearch.Loop()
        call FrierenSpells_TR.Loop_FrierenTR()
        call FrierenSpells_T.Loop_FrierenT()
        call FrierenSpells_T2.Loop_FrierenT2()
        call FrierenSpells_G.Loop_FrierenG()
        call FrierenSpells_F.Loop_FrierenF()
        call KS_MoveUnitFrir.Loop_MUEFrir()
    endfunction
     /* 
    1 - Zoltrak
    2 - zoltrak 2
    5 - g
    6 - e / stand ready
    7 - g3 / stand ready 2
    9 - R
    10 - finish r
    11 - r stand ready mbb t2
    14 - pick anim
    15 - T
    16 - T end
    18 - t move
    22 - tw
    24 - Q3
    25 - q3 channel
    19 / 21 - spell air
     */ 
    private function InitFrierenSpells takes nothing returns nothing
        set FrierenTimer03 = CreateTimer()
        set FrierenTimer03Callback = function FrierenTimer03Loop
    endfunction
    // Возвращает сохранённую живую иллюзию.
    private function FrierenR_GetIllusion takes unit c returns unit
        local unit illusion = LoadUnitHandle(hs, GetHandleId(c), StringHash("Frieren R illusion"))
        if illusion != null and GetUnitTypeId(illusion) != 0 and GetUnitState(illusion, UNIT_STATE_LIFE) > 0.405 then
            return illusion
        endif
        call RemoveSavedHandle(hs, GetHandleId(c), StringHash("Frieren R illusion"))
        set illusion = null
        return null
    endfunction
    function FrierenQ_Start takes unit c, real x, real y returns nothing
        local unit illusion = FrierenR_GetIllusion(c)
        call FrierenSpells_Q.FrierenQ_Start(c, c, x, y)
        if illusion != null and SR2(c,illusion)<=FrierenR_CloneRangeCast then
            call FrierenSpells_Q.FrierenQ_Start(illusion, c, x, y)
        endif
        set illusion = null
    endfunction
    function FrierenQ2_Start takes unit c returns nothing
        local unit illusion = FrierenR_GetIllusion(c)
        call FrierenSpells_Q2.FrierenQ2_Start(c, c)
        if illusion != null and SR2(c,illusion)<=FrierenR_CloneRangeCast then
            call FrierenSpells_Q2.FrierenQ2_Start(illusion, c)
        endif
        set illusion = null
    endfunction
    function FrierenQ3_Start takes unit c, unit td returns nothing
        local unit illusion = FrierenR_GetIllusion(c)
        call FrierenSpells_TQ.FrierenTQ_Start(c, c, td)
        if illusion != null and SR2(c,illusion)<=FrierenR_CloneRangeCast then
            call FrierenSpells_TQ.FrierenTQ_Start(illusion, c, td)
        endif
        set illusion = null
    endfunction
    function FrierenW_Start takes unit c, unit td returns nothing
        local unit illusion = FrierenR_GetIllusion(c)
        call FrierenSpells_W.FrierenW_Start(c, c, td)
        if illusion != null and SR2(c,illusion)<=FrierenR_CloneRangeCast then
            call FrierenSpells_W.FrierenW_Start(illusion, c, td)
        endif
        set illusion = null
    endfunction
    function FrierenW2_Start takes unit c, real x, real y returns nothing
        local unit illusion = FrierenR_GetIllusion(c)
        call FrierenSpells_W2.FrierenW2_Start(c, x, y)
        if illusion != null and SR2(c,illusion)<=FrierenR_CloneRangeCast then
            call FrierenSpells_W2.FrierenW2_Start(illusion, x, y)
        endif
        set illusion = null
    endfunction
    function FrierenE_Start takes unit c returns nothing
        local unit illusion = FrierenR_GetIllusion(c)
        call FrierenSpells_E.FrierenE_Start(c, c)
        if illusion != null and SR2(c,illusion)<=FrierenR_CloneRangeCast then
            call FrierenSpells_E.FrierenE_Start(illusion, c)
        endif
        set illusion = null
    endfunction
    function FrierenR_Start takes unit c, real x, real y returns nothing
        if LoadInteger(hs, GetHandleId(c), StringHash("mode t")) == 1 then
            call FrierenSpells_TR.FrierenTR_Start(c, x, y)
        else
            call FrierenRSearch.Start(c, x, y)
        endif
    endfunction
    function FrierenT_Start takes unit c returns nothing
        local unit illusion = FrierenR_GetIllusion(c)
        call FrierenSpells_T.FrierenT_Start(c)
        if illusion != null and SR2(c,illusion)<=FrierenR_CloneRangeCast then
            call FrierenSpells_T.FrierenT_Start(illusion)
        endif
        set illusion = null
    endfunction
    function FrierenT2_Start takes unit c, real x, real y returns nothing
        local unit illusion = FrierenR_GetIllusion(c)
        call FrierenSpells_T2.FrierenT2_Start(c, x, y)
        if illusion != null and SR2(c,illusion)<=FrierenR_CloneRangeCast then
            call FrierenSpells_T2.FrierenT2_Start(illusion, x, y)
        endif
        set illusion = null
    endfunction
    function FrierenF_Start takes unit c, unit td returns nothing
        call BuffUnit01(c, td, FrierenTF_SpellID, "curse", 1)
        call FrierenSpells_F.FrierenF_Start( c, td )
    endfunction
    function FrierenG_Start takes unit c returns nothing
        local integer stacks = S2I(TasAbilityChargeBox_GetValue(c, FrierenF_ID))
        local unit illusion = FrierenR_GetIllusion(c)
        
        if stacks >= 10 then
            call FrierenSpells_G.FrierenG_Start(c)
        if illusion != null and SR2(c,illusion)<=FrierenR_CloneRangeCast then
            call FrierenSpells_G.FrierenG_Start(illusion)
        endif
        elseif stacks >= 5 then
        if illusion != null and SR2(c,illusion)<=FrierenR_CloneRangeCast then
            call BuffUnit01(c, illusion, FrierenG_SpellID , "innerfire", 2)
        endif
            call BuffUnit01(c, c, FrierenG_SpellID , "innerfire", 2)
        else
        if illusion != null and SR2(c,illusion)<=FrierenR_CloneRangeCast then
            call BuffUnit01(c, illusion, FrierenG_SpellID , "innerfire", 1)
        endif
            call BuffUnit01(c, c, FrierenG_SpellID , "innerfire", 1)
        endif
        call MakeSound("war3mapimported\\Hero_Frieren_G")
        call TasAbilityChargeBox_Clear(c)
        call BlzSetAbilityIcon(FrierenG_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Frieren_G.blp")
        set illusion = null
    endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
