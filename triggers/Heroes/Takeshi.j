library TakeshiSpells uses GearSystems
    globals
//--------------------------------------Takeshi--------------------------------------------------------------
        integer Takeshi_ID = 'H01H'
        integer Takeshi2_ID = 'H01I'
        integer TakeshiDummy_ID ='h00P'
        unit TakeshiDummy = null
        framehandle array frameTakeshi_pas1 [10]
        framehandle array frameTakeshi_pas2 [10]
        framehandle array frameTakeshi_pas3 [10]
        framehandle array frameTakeshi_pas4 [10]
        framehandle array frameTakeshi_pas5 [10]
        framehandle array frameTakeshi_pas6 [10]
//===============Offensive Form======================================================
//---------------Q ability-----------------------------------------------------
        integer TakeshiQ_ID = 'A08S'
        real TakeshiQ_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real TakeshiQ_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real TakeshiQ_Damage2StaticBase = 175 // base static damage for 1 level
        real TakeshiQ_Damage2StaticStep = 0 // additional static damage for each next level
        real TakeshiQ_DamageAoe = 255
        real TakeshiQ_RangeBase = 1000
        real TakeshiQ_RangeStep = 125
//---------------W ability-----------------------------------------------------
        integer TakeshiW_ID = 'A08T'
        real TakeshiW_DamageAgiBase = 1 // base number x Agi damage for 1 level
        real TakeshiW_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real TakeshiW_Damage2StaticBase = 175 // base static damage for 1 level
        real TakeshiW_Damage2StaticStep = 0 // additional static damage for each next level
        real TakeshiW_Range = 1800
        real TakeshiW_PushRange = 250 // slow time 2, 3, 4 sec only
        real TakeshiW_PushDuration = 0.3 // slow time 2, 3, 4 sec only
        real TakeshiW_DamageAoe = 255
        real TakeshiW_Stun = 0.5
//---------------E ability-----------------------------------------------------
        integer TakeshiE_ID = 'A08U'
        real TakeshiE_DamageAgiBase = 2 // base number x Agi damage for 1 level
        real TakeshiE_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real TakeshiE_DamageAoe = 500
//---------------R ability-----------------------------------------------------
        integer TakeshiR_ID = 'A08V'
        real TakeshiR_DamageAgiBase = 5 // base number x Agi damage for 1 level
        real TakeshiR_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real TakeshiR_DamageAoe = 200
        real TakeshiR_Stun = 1
//===============Defensive Form======================================================
//---------------Q ability-----------------------------------------------------
        integer TakeshiQ2_ID = 'A08Z'
        integer TakeshiQ2_Armor_ID = 'A09B'
        real TakeshiQ2_Aoe = 425
        integer TakeshiQ2_Invis_ID = 'A03W'
        real TakeshiQ2_PushDistance = 600 // how long enemy will be pushed every second , push from cast point it meant , if enemy was in center it will be pushed for full rage, if in aoe edge it would be pushed for distance - aoe ( 800 - 600) = 200 range
        real TakeshiQ2_PushTime = 0.6
        real TakeshiQ2_Stun = 1
//---------------Q2 ability (Utsushi Ame)-----------------------------------------------------
        integer TakeshiQ3_ID = 'A093'
        integer TakeshiQ3_Buff_ID = 'B00X'
        real TakeshiQ3_Range = 3500 // how long enemy will be pushed every second , push from cast point it meant , if enemy was in center it will be pushed for full rage, if in aoe edge it would be pushed for distance - aoe ( 800 - 600) = 200 range
        real TakeshiQ3_DamageAgiBase = 5 // base number x Agi damage for 1 level
        real TakeshiQ3_Stun = 1
//---------------W2 ability-----------------------------------------------------
        integer TakeshiW2_ID = 'A090'
        integer TakeshiW2_Buff_ID = 'B010'
        real TakeshiW2_Range = 2000
        real TakeshiW2_DamageAgiBase = 2 // base number x Agi damage for 1 level
        real TakeshiW2_DamageAgiStep = 1 // additional number x Agi damage for each next level
        real TakeshiW2_Damage2StaticBase = 50 // base static damage for 1 level
        real TakeshiW2_Damage2StaticStep = 25 // additional static damage for each next level
        
//---------------E2 ability-----------------------------------------------------
        integer TakeshiE2_ID = 'A091'
        integer TakeshiE2_Buff_ID = 'B00Y'
        real TakeshiE2_Duration = 2.5
//---------------R ability-----------------------------------------------------
        integer TakeshiR2_ID = 'A092'
        real TakeshiR2_DurationBase = 1.5 // sec
        real TakeshiR2_DurationStep = 0.25 // sec for each next lvl
//---------------T ability-----------------------------------------------------
        integer TakeshiT_ID = 'A08W' //
        integer TakeshiT_Buff_ID = 'B00Z'
        real TakeshiGT_DamageAgiBase = 2 // overall for all 3 sec
        real TakeshiT_DamageAoe = 1000
        real TakeshiT_InvulTime = 1.5
        real TakeshiT_ManacostPerSec = 0 //%
        real TakeshiT_AddDmg = 2 // add additional agi for each atk ability
        real TakeshiT_ReduceCD = 1.5 // per second, if duration 9 sec , it will reduce all cd , except t for 9 sec
        real TakeshiT_Duration = 4 //sec
        integer TakeshiT_Slow = 60 // Caused slow %
        integer TakeshiT_SlowDuration = 1 // slow time 2, 3, 4 sec only
//---------------F ability-----------------------------------------------------
        integer TakeshiF_ID = 'A08X'
//---------------G ability-----------------------------------------------------
        integer TakeshiG_ID = 'A08Y'
        real TakeshiG_Duration = 20
        real TakeshiG_TakenDamageToEnter = 8000
        real TakeshiG_ReduceCD = 15
//---------------G2 ability-----------------------------------------------------
        integer TakeshiG2_ID = 'A09A'
//---------------GQ ability-----------------------------------------------------
        integer TakeshiGQ_ID = 'A095'
        real TakeshiGQ_DamageAgiBase = 7 // base number x Agi damage for 1 level
        real TakeshiGQ_DamageAoe = 555
        real TakeshiGQ_Stun = 0.3
        real TakeshiGQ_Range = 1500
//---------------GW ability-----------------------------------------------------
        integer TakeshiGW_ID = 'A096'
        integer TakeshiGW_Unit_ID = 'h01J'
        unit TakeshiGW_Unit = null
        real TakeshiGW_DamageAgiBase = 7 // base number x Agi damage for 1 level
        real TakeshiGW_DamageAoe = 255
        real TakeshiGW_Time = 4
//---------------GE ability-----------------------------------------------------
        integer TakeshiGE_ID = 'A097'
        real TakeshiGE_DamageAgiBase = 7 // base number x Agi damage for 1 level
        real TakeshiGE_DamageAoe = 255
//---------------GR ability-----------------------------------------------------
        integer TakeshiGR_ID = 'A098'
        real TakeshiGR_DamageAgiBase = 9 // base number x Agi damage for 1 level
        real TakeshiGR_DamageAoe = 425
        real TakeshiGR_Stun = 0.5
//---------------GF ability-----------------------------------------------------
        integer TakeshiGF_ID = 'A099'
        real TakeshiGF_DamageAgiBase = 4 // base number x Agi damage for 1 level
        real TakeshiGF_Root = 1.5
//--------------------------------------------------------------------------------        
    endglobals
    function TakeshiGAdd_Start takes unit c,real dmg returns nothing 
local integer k2 = GetPlayerId(GetOwningPlayer(c))
local real dmg2 = LoadReal(hs,GetHandleId(c),StringHash("takeshi dmg"))+dmg
local real rmax = TakeshiG_TakenDamageToEnter
if GetHeroLevel(c)>=35 then 
if frameTakeshi_pas1 [k2] == null then
                set frameTakeshi_pas1 [k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                call BlzFrameSetAbsPoint(frameTakeshi_pas1 [k2], FRAMEPOINT_CENTER, 0.055, 0.18)
                call BlzFrameSetSize(frameTakeshi_pas1 [k2], 0.135, 0.035)
                call BlzFrameSetTexture(frameTakeshi_pas1 [k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                call BlzFrameSetVisible(frameTakeshi_pas1 [k2], false)
                if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frameTakeshi_pas1 [k2], true)
                endif
                set frameTakeshi_pas2 [k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frameTakeshi_pas1[k2], 0, 0)
                call BlzFrameSetAbsPoint(frameTakeshi_pas2 [k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                call BlzFrameSetSize(frameTakeshi_pas2 [k2], 0.1, 0.019)
                set frameTakeshi_pas3 [k2] = BlzCreateFrameByType("STATUSBAR", "", frameTakeshi_pas1[k2], "", 0)
                call BlzFrameSetSize(frameTakeshi_pas3 [k2], 0.1, 0.035)
                call BlzFrameSetScale(frameTakeshi_pas3 [k2], 0.5)
                call BlzFrameSetModel(frameTakeshi_pas3 [k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                call BlzFrameSetAbsPoint(frameTakeshi_pas3 [k2], FRAMEPOINT_CENTER, 0.05, 0.175)
                call BlzFrameSetMinMaxValue(frameTakeshi_pas3 [k2], 0, rmax+2)
                call BlzFrameSetValue(frameTakeshi_pas3 [k2], 0)
                set frameTakeshi_pas4 [k2] = BlzCreateFrameByType("BACKDROP", "SS", frameTakeshi_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frameTakeshi_pas4 [k2], FRAMEPOINT_CENTER, 0.005, 0.18)
                call BlzFrameSetSize(frameTakeshi_pas4 [k2], 0.03, 0.03)
                call BlzFrameSetTexture(frameTakeshi_pas4 [k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Takeshi_G2", 0, false)
                set frameTakeshi_pas5 [k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frameTakeshi_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frameTakeshi_pas5 [k2], FRAMEPOINT_CENTER, 0.07, 0.185)
                call BlzFrameSetText(frameTakeshi_pas5 [k2], "|c00FFFF00" + "Cambio Damage:" + "|r")
                call BlzFrameSetScale(frameTakeshi_pas5 [k2], 0.9)
                set frameTakeshi_pas6 [k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frameTakeshi_pas1[k2], "", 0)
                call BlzFrameSetAbsPoint(frameTakeshi_pas6 [k2], FRAMEPOINT_CENTER, 0.07, 0.17)
                call BlzFrameSetText(frameTakeshi_pas6 [k2], "|c00FFFF00" +I2S(R2I(dmg2))+"/"+I2S(R2I(rmax))+ "|r")
                call BlzFrameSetScale(frameTakeshi_pas6 [k2], 0.9)
            else
                /*if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frameTakeshi_pas1[k2], true)
                endif*/
                if LoadInteger(hs, GetHandleId(c), StringHash("mode g"))== 0 then 
                if dmg2>=rmax then 
                set dmg2 = rmax
                if TakeshiDummy == null then 
                set TakeshiDummy = CreateUnit(GetOwningPlayer(c),TakeshiDummy_ID,GetRectCenterX(gg_rct_Caster),GetRectCenterY(gg_rct_Caster),1)
                endif
                else  
                if dmg2<0 then 
                set dmg2 = 0
                endif
                if TakeshiDummy != null then 
                call RemoveUnit(TakeshiDummy)
                set TakeshiDummy = null
                endif
                endif                
                call SaveReal(hs,GetHandleId(c),StringHash("takeshi dmg"),dmg2)
                call BlzFrameSetText(frameTakeshi_pas6 [k2], "|c00FFFF00" +I2S(R2I(dmg2))+"/"+I2S(R2I(rmax))+ "|r")
                call BlzFrameSetValue(frameTakeshi_pas3[k2],dmg2 )
                endif
            endif
            endif
endfunction
    private struct TakeshiSpells_Q
        private static timer t_TakeshiQ = CreateTimer()
        private static integer array m_TakeshiQ
        private static integer MUI_TakeshiQ = -1
        private static timer t_TakeshiQ2 = CreateTimer()
        private static integer array m_TakeshiQ2
        private static integer MUI_TakeshiQ2 = -1
        private static timer t_TakeshiQ3 = CreateTimer()
        private static integer array m_TakeshiQ3
        private static integer MUI_TakeshiQ3 = -1
        unit c
        unit td
        real x
        real y
        real x1
        real y1
        real x2
        real y2
        real r2
        real r4
        real r5
        real r6
        real r8
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

        private static method Loop_TakeshiQ takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_TakeshiQ
                set this = m_TakeshiQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    if r == 0.15 then
                        call SetUnitTimeScale(c, 0)
                    endif
                    if r == 0.36 then
                        set x1 = GetUnitX(c)
                        set y1 = GetUnitY(c)
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, 1, 255, 255, 255, 255))
                        call DecorRemove(c, x, y, aoe, 25)
                        call MakeSound("war3mapimported\\Hero_Takeshi_Q3")
                        set e2 = EffectSpawn("war3mapImported\\wos_water dash.mdl", GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), a * bj_RADTODEG, 1, 1.65, 0)
                        set r5 = 0
                    endif
                    if r > 0.45 then
                        if r2 > 0.03 then
                            set r2 = 0
                            call EffectSpawn2("war3mapImported\\wos_Bubbles2.mdx", x1 , y1, GetRandomReal(0, 359), 1, 6, GetRandomReal(50, 150), 0.21)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x1 + 100 * Cos(a), y1 + 100 * Sin(a), a * bj_RADTODEG, 0.5, 2.5, 75))
                        else
                            set r2 = r2 + 0.03
                        endif
                        set r5 = r5 + move
                        if r5 >= r8 then
                            set r = rmax
                        endif
                        if LoadInteger(hs,GetHandleId(c),StringHash("def t"))>0 then 
                        set x2 = LoadReal(hs,GetHandleId(c),StringHash("t x"))
                        set y2 = LoadReal(hs,GetHandleId(c),StringHash("t y"))
                        if SR0(GetUnitX(c)+move*Cos(a),GetUnitY(c)+move*Sin(a),x2,y2)< TakeshiT_DamageAoe-220 then
                        call MoveUnit(c, move, a)
                        endif
                        else
                        call MoveUnit(c, move, a)
                        endif
                        call BlzSetSpecialEffectPosition(e2, GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), 1)
                        call SetUnitFacing(c, a * bj_RADTODEG)
                        set x1 = GetUnitX(c)
                        set y1 = GetUnitY(c)
                        call DecorRemove(c, x1, y1, aoe, 25)
                        call GroupEnumUnitsInRange( g , x1, y1 , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                call GroupAddUnit(g2, u)
                                call dmgphys(c, u, dmg)
                                if IsUnitIllusion(u) == false and IsUnitType(u,UNIT_TYPE_HERO) then 
                                call TakeshiGAdd_Start(c,dmg)
                                endif
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                        if r == rmax then
                            set x = GetUnitX(c) + 135 * Cos(a)
                            set y = GetUnitY(c) + 135 * Sin(a)
                            set r5 = 1.71
                            if r < r5 then
                                call NextSound("war3mapimported\\Hero_Takeshi_Q2", r5 - r)
                            else
                                call MakeSound("war3mapimported\\Hero_Takeshi_Q2")
                            endif
                            set r = 99999
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_tx-shqy21.mdl" , x - 265 * Cos(a), y - 265 * Sin(a), a * bj_RADTODEG, 1., 6, 130))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlash.mdl" , x + 25 * Cos(a), y + 25 * Sin(a), 1, 1., 1.375, 125))
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
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
                    call MyRemoveEff(e2, 0.3)
                    call SetUnitAnimation(c, "stand")
                    call SetUnitTimeScale( c , 1)
                    call DestroyEffect(e)
                    call DestroyGroup( g )
                    call DestroyGroup( g2 )
                    set g = null
                    set g2 = null
                    set c = null
                    set e = null
                    set e2 = null
                    set u = null
                    set m_TakeshiQ[i] = m_TakeshiQ[ MUI_TakeshiQ]
                    set MUI_TakeshiQ = MUI_TakeshiQ - 1
                    if MUI_TakeshiQ == -1 then
                        call PauseTimer( t_TakeshiQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method TakeshiQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_TakeshiQ = MUI_TakeshiQ + 1
            set m_TakeshiQ[ MUI_TakeshiQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set move = 80
            set r6 = 0
            set r8 = TakeshiQ_RangeBase + (TakeshiQ_RangeStep*(GetUnitAbilityLevel(c,TakeshiQ_ID)-1))
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set aoe = TakeshiQ_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( TakeshiQ_DamageAgiBase + ( TakeshiQ_DamageAgiStep * ( GetUnitAbilityLevel( c , TakeshiQ_ID) - 1 ) ) )
            set dmg = dmg + TakeshiQ_Damage2StaticBase + ( TakeshiQ_Damage2StaticStep * ( GetUnitAbilityLevel( c , TakeshiQ_ID) - 1 ) )
            if GetUnitAbilityLevel(c, TakeshiT_Buff_ID) > 0 then
                set dmg = dmg + GetHeroAgi(c, true) * TakeshiT_AddDmg
            endif
            set rmax = 2.1
            call SetUnitAnimationByIndex(c, 15)
            call SetUnitTimeScale(c, 1)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_e tanjiro (4).mdl", c, "weapon")
            call MakeSound("war3mapimported\\Hero_Takeshi_Q")
            if MUI_TakeshiQ == 0 then
                call TimerStart( t_TakeshiQ, 0.03, true, function thistype.Loop_TakeshiQ)
            endif
        endmethod

        private static method Loop_TakeshiQ2 takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_TakeshiQ2
                set this = m_TakeshiQ2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.1
                    if r == 0.4 then
                        if GetHeroLevel(c) >= 12 then
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiQ3_ID, true)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiQ2_ID, false)
                            call UnitAddAbility(c, TakeshiQ3_ID)
                        endif
                        call StopSpellUnit2(c)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (171)44_small.mdl", x, y, 0, 1.25, 0.925, 0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_xiaonajia01_d_W.mdl", x, y, GetRandomReal(0, 359), 1.5, 2, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_xiaonajia01_d_W.mdl", x, y, GetRandomReal(0, 359), 1.5, 2, 215))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_xiaonajia01_d_W.mdl", x, y, GetRandomReal(0, 359), 1.5, 2, 455))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdl", x, y, GetRandomReal(0, 359), 0.75, 1.5, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_tidalerruption.mdl", x, y, 1, 1, 2.75, 1))
                        call VisionTimed(GetOwningPlayer(c), x, y, 1250, rmax + 1.5 - r)
                        call DecorRemove(c, x, y, aoe, 30)
                        call GroupClear( g )
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond )
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                call StunUnit(c, u, TakeshiQ2_Stun)
                                call HeightSet(u, 0.42, 600)
                                call HeightSet2(u, 0.42, 0, 0.45)
                                call SetAnim(u, 0.03, "death")
                                call MUE(u, TakeshiQ2_PushDistance - SR3(u, x, y), TakeshiQ2_PushTime, GAngle3(x, y, u))
                                call ErzaPassive(c, u, 2)
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    endif
                    if r >= 0.4 then
                        call GroupClear( g )
                        call GroupEnumUnitsInRange( g , x, y , 30000 , null)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitAlly( u , GetOwningPlayer( c )) then
                                if SR3(u, x, y) < aoe then
                                    if GetUnitAbilityLevel(u, TakeshiQ2_Invis_ID) == 0 then
                                        call UnitAddAbility(u, TakeshiQ2_Invis_ID)
                                        call MyRemoveAbility(u, rmax - r, TakeshiQ2_Invis_ID, 1)
                                    endif
                                else
                                    call UnitRemoveAbility(u, TakeshiQ2_Invis_ID)
                                    if SR3(u, x, y) > aoe + 525 then
                                        call UnitRemoveAbility(u, TakeshiQ3_Buff_ID)
                                    endif
                                endif
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    endif
                else
                    if r < 0.1 then
                        call StopSpellUnit2(c)
                    endif
                    call UnitRemoveAbility(c, TakeshiQ2_Armor_ID)
                    call UnitRemoveAbility(c, TakeshiQ3_Buff_ID)
                    
                    if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("style")) == 1 and LoadInteger(hs,GetHandleId(c),StringHash("mode g")) == 0 then
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiQ3_ID, false)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiQ2_ID, true)
                    endif
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set u = null
                    set m_TakeshiQ2[i] = m_TakeshiQ2[MUI_TakeshiQ2]
                    set MUI_TakeshiQ2 = MUI_TakeshiQ2 - 1
                    if MUI_TakeshiQ2 == -1 then
                        call PauseTimer( t_TakeshiQ2 )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod

        public static method TakeshiQ2_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_TakeshiQ2 = MUI_TakeshiQ2 + 1
            set m_TakeshiQ2[MUI_TakeshiQ2] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set r2 = 10
            set aoe = TakeshiQ2_Aoe
            set check = 0
            set g = CreateGroup()
            set rmax = 2.61
            call StartSpellUnit2(c)
            call UnitAddAbility(c, TakeshiQ2_Armor_ID)
            call SetUnitAbilityLevel(c, TakeshiQ2_Armor_ID, GetUnitAbilityLevel(c, TakeshiQ2_ID))
            call SetUnitAnimationByIndex(c, 13)
            call SetUnitTimeScale(c, 0.85)
            call MakeSound("war3mapImported\\Hero_Takeshi_FQ")
            call MakeSound("war3mapImported\\Hero_Takeshi_FQ2")
            if MUI_TakeshiQ2 == 0 then
                call TimerStart( t_TakeshiQ2, 0.1, true, function thistype.Loop_TakeshiQ2 )
            endif
        endmethod

        private static method Loop_TakeshiQ3 takes nothing returns nothing
            local thistype this
            local integer i = 0
            loop
                exitwhen i > MUI_TakeshiQ3
                set this = m_TakeshiQ3[i]
                if SpellBoolCaster(c) and r < rmax then
                    set r = r + 0.03
                    call DebugUnit(c)
                    call DebugUnit2(td)
                    call SetUnitX(td, x1)
                    call SetUnitY(td, y1)
                    set r5 = r5 - r4
                    call SetFly(c, r5)
                    call MoveUnit(c, r6, a)
                else
                    call StunUnit(c, td, TakeshiQ3_Stun)
                    call dmgphys(c, td, dmg)
                    if IsUnitIllusion(td) == false and IsUnitType(td,UNIT_TYPE_HERO) then 
                                call TakeshiGAdd_Start(c,dmg)
                                endif
                    set x = x1
                    set y = y1
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_shockwave_b.mdl", x, y, 1, 1, 2.75, 125))
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_waterexplosion.mdl", x, y, 1, 2.5, 3, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_2-[tx]-03-03jianta (3)_1.mdl", x, y, 1, 2, 2.5, 1))
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlash.mdl" , x + 25 * Cos(a), y + 25 * Sin(a), 1, 1., 1.975, 125))
                    call StopSpellUnit(c)
                    call StopSpellUnit2(td)
                    set c = null
                    set td = null
                    set m_TakeshiQ3[i] = m_TakeshiQ3[MUI_TakeshiQ3]
                    set MUI_TakeshiQ3 = MUI_TakeshiQ3 - 1
                    if MUI_TakeshiQ3 == -1 then
                        call PauseTimer( t_TakeshiQ3 )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod

        public static method TakeshiQ3_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_TakeshiQ3 = MUI_TakeshiQ3 + 1
            set m_TakeshiQ3[MUI_TakeshiQ3] = this
            set c = NewC
            set td = NewTd
            set a = GAngle(c, td)
            set x = GetUnitX(td) + 420 * Cos(a)
            set y = GetUnitY(td) + 420 * Sin(a)
            set r = 0
            set r2 = 10
            set aoe = TakeshiQ2_Aoe
            set check = 0
            set rmax = 0.9
            set r5 = 650
            set x1 = GetUnitX(td)
            set y1 = GetUnitY(td)
            call SetUnitAnimationByIndex(c, 4)
            call SetUnitTimeScale(c, 0.425)
            call MakeSound("war3mapImported\\Hero_Takeshi_FQ3 1")
            call MakeSound("war3mapImported\\Hero_Takeshi_FQ3 2")
            call NextSound("war3mapImported\\Hero_Takeshi_FQ3 3", 1.02)
            call StartSpellUnit(c)
            call StartSpellUnit2(td)
            call PosUnit(c, x, y)
            set a = GAngle(c, td)
            set dmg = GetHeroAgi( c , true) * TakeshiQ3_DamageAgiBase
            if GetUnitAbilityLevel(c, TakeshiT_Buff_ID) > 0 then
                set dmg = dmg + GetHeroAgi(c, true) * TakeshiT_AddDmg
            endif
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            call SetFly(c, r5)
            set r6 = SR2(c, td) - 90
            set r4 = r5 / 30
            set r6 = r6 / 30
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (171)44_small.mdl", x, y, 0, 2.75, 0.925, 0))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_xiaonajia01_d_W.mdl", x, y, GetRandomReal(0, 359), 1.5, 2, 1))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_xiaonajia01_d_W.mdl", x, y, GetRandomReal(0, 359), 1.5, 2, 215))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_az_xiaonajia01_d_W.mdl", x, y, GetRandomReal(0, 359), 1.5, 2, 455))
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_obr08 (214).mdl", x, y, GetRandomReal(0, 359), 1.75, 1.5, 1))
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_tidalerruption.mdl", x, y, 1, 1, 2.75, 1))
            if MUI_TakeshiQ3 == 0 then
                call TimerStart( t_TakeshiQ3, 0.03, true, function thistype.Loop_TakeshiQ3 )
            endif
        endmethod

    endstruct

    private struct TakeshiSpells_W
        private static timer t_TakeshiW = CreateTimer()
        private static integer array m_TakeshiW
        private static integer MUI_TakeshiW = -1
        private static timer t_TakeshiW2 = CreateTimer()
        private static integer array m_TakeshiW2
        private static integer MUI_TakeshiW2 = -1
        unit c
        unit td
        real x
        real y
        real x1
        real y1
        real r2
        real r3
        real r5
        group g
        unit u
        real dmg
        real scale
        integer check
        real aoe
        real move
        real r
        effect e
        effect e2
        effect e3
        real a
        real rmax

        private static method Loop_TakeshiW takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_TakeshiW
                set this = m_TakeshiW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if r < 0.6 then
                        call DebugUnit2(c)
                    endif
                    if r == 0.27 then
                        call MakeSound("war3mapimported\\Hero_Takeshi_W3")
                    endif
                    if r == 0.6 then
                        call StopSpellUnit2(c)
                        set scale = 2.01
                        set e = EffectSpawn("war3mapImported\\wos_takeshisword.mdl", GetUnitX(c) + 110 * Cos(a), GetUnitY(c) + 110 * Sin(a), a * bj_RADTODEG, 1, scale, 140)
                        set e2 = EffectSpawn("war3mapImported\\wos_Windwalk Blue Soul.mdl", GetUnitX(c) + 30 * Cos(a), GetUnitY(c) + 30 * Sin(a), a * bj_RADTODEG, 1, 1, 55)
                        set e3 = EffectSpawn("war3mapImported\\wos_Bubbles2.mdl", GetUnitX(c) + 30 * Cos(a), GetUnitY(c) + 30 * Sin(a), a * bj_RADTODEG, 1, 2.2, 95)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", GetUnitX(c) + 230 * Cos(a), GetUnitY(c) + 230 * Sin(a), a * bj_RADTODEG, 1, 1.85, 105))
                    endif
                    if r >= 0.6 then
                        if r5 < TakeshiW_Range then
                            set r5 = r5 + move
                        else
                            set r = 9999
                        endif
                        call MoveEff(e, move, a)
                        call MoveEff(e2, move, a)
                        call MoveEff(e3, move, a)
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        if r3 > 0.06 then
                            set r3 = 0
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x + 140 * Cos(a), y + 140 * Sin(a), a * bj_RADTODEG, 1.12, 1.15, 105))
                        else
                            set r3 = r3 + 0.03
                        endif
                        call VisionTimed(GetOwningPlayer(c), x, y , aoe+300, 1)
                        call DecorRemove(c, x, y , aoe, 40)
                        call GroupClear(g)
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null or td != null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                set td = u
                                set r = 99999
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    endif
                else
                    if r < 0.6 then
                        call StopSpellUnit2(c)
                    else
                        call VisionTimed(GetOwningPlayer(c), x, y , aoe+215, 1)
                        if td != null then
                            call StunUnit(c, td, TakeshiW_Stun)
                            set x = GetEffX(e)
                            set y = GetEffY(e)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_tx-shqy21.mdl" , x - 265 * Cos(a), y - 265 * Sin(a), a * bj_RADTODEG, 1., 4.2, 130))
                            call EffectSpawn2("war3mapImported\\wos_Bubbles2.mdx", x , y, GetRandomReal(0, 359), 1, 6, GetRandomReal(50, 150), 0.21)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x + 10 * Cos(a), y + 10 * Sin(a), a * bj_RADTODEG, 0.5, 2.5, 75))
                            call dmgatk(c, td, dmg)
                            if IsUnitIllusion(td) == false and IsUnitType(td,UNIT_TYPE_HERO) then 
                                call TakeshiGAdd_Start(c,dmg)
                                endif
                            call EUTU2(e, TakeshiW_PushDuration, 100, td)
                            call MUE(td, TakeshiW_PushRange, TakeshiW_PushDuration, a)
                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", td, "chest"))
                        endif
                        call ColorEffDummy3(e, 0, 255, 255, 255, TakeshiW_PushDuration)
                        call DestroyEffect(e2)
                        call DestroyEffect(e3)
                    endif
                    call SetUnitTimeScale( c , 1)
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set td = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set u = null
                    set m_TakeshiW[i] = m_TakeshiW[ MUI_TakeshiW]
                    set MUI_TakeshiW = MUI_TakeshiW - 1
                    if MUI_TakeshiW == -1 then
                        call PauseTimer( t_TakeshiW)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method TakeshiW_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_TakeshiW = MUI_TakeshiW + 1
            set m_TakeshiW[ MUI_TakeshiW] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set td = null
            set move = 120
            set r5 = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set aoe = TakeshiW_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( TakeshiW_DamageAgiBase + ( TakeshiW_DamageAgiStep * ( GetUnitAbilityLevel( c , TakeshiW_ID) - 1 ) ) )
            set dmg = dmg + TakeshiW_Damage2StaticBase + ( TakeshiW_Damage2StaticStep * ( GetUnitAbilityLevel( c , TakeshiW_ID) - 1 ) )
            set rmax = 2.4
            if GetUnitAbilityLevel(c, TakeshiT_Buff_ID) > 0 then
                set dmg = dmg + GetHeroAgi(c, true) * TakeshiT_AddDmg
            endif
            call SetUnitAnimationByIndex(c, 10)
            call SetUnitTimeScale(c, 0.55)
            call MakeSound("war3mapimported\\Hero_Takeshi_W")
            call NextSound("war3mapimported\\Hero_Takeshi_W2", 0.6)
            if MUI_TakeshiW == 0 then
                call TimerStart( t_TakeshiW, 0.03, true, function thistype.Loop_TakeshiW)
            endif
        endmethod

        private static method Loop_TakeshiW2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_TakeshiW2
                set this = m_TakeshiW2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    if check == 0 then
                        if SR2(c, td) > 145 then
                            set a = GAngle(c, td)
                            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
                            call MoveUnit(c, move, a)
                            if r2 > 0.06 then
                                set r2 = 0
                                set x1 = GetUnitX(c)
                                set y1 = GetUnitY(c)
                                call EffectSpawn2("war3mapImported\\wos_Bubbles2.mdx", x1 , y1, GetRandomReal(0, 359), 1, 6, GetRandomReal(50, 150), 0.15)
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x1 + 100 * Cos(a), y1 + 100 * Sin(a), a * bj_RADTODEG, 0.5, 1.75, 75))
                            else
                                set r2 = r2 + 0.03
                            endif
                        else
                            set check = 1
                            set r = 0
                            set rmax = 0.15
                            call SetUnitAnimationByIndex(c, 6)
                            call StartSpellUnit2(c)
                            call DebugUnit2(td)
                        endif
                    elseif check == 1 then
                        call DebugUnit2(td)
                        if r == 0.15 then
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_shockwave_b.mdl", x, y, 1, 0.8, 2, 175))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_bluemorphcircle2.mdl", x, y, GetRandomReal(0, 359), 1, 1.4, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_1mt_shui1.mdl", GetUnitX(c) + 70 * Cos(a), GetUnitY(c) + 70 * Sin(a), a * bj_RADTODEG, 1, 2.25, 150))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_2-[tx]-03-03jianta (3)_1.mdl", x, y, 1, 2, 1, 1))
                            call dmgphys(c, td, dmg)
                             if IsUnitIllusion(td) == false and IsUnitType(td,UNIT_TYPE_HERO) then 
                                call TakeshiGAdd_Start(c,dmg)
                                endif
                            call MakeSound("war3mapimported\\Hero_Takeshi_FW")
                            set r = 9999
                        endif
                    endif
                else
                    call StopSpellUnit2(td)
                    call StopSpellUnit2(c)
                    call DestroyEffect(e)
                    set c = null
                    set td = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set m_TakeshiW2[i] = m_TakeshiW2[ MUI_TakeshiW2]
                    set MUI_TakeshiW2 = MUI_TakeshiW2 - 1
                    if MUI_TakeshiW2 == -1 then
                        call PauseTimer( t_TakeshiW2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method TakeshiW2_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_TakeshiW2 = MUI_TakeshiW2 + 1
            set m_TakeshiW2[ MUI_TakeshiW2] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set r2 = 0
            set move = 75
            set r5 = 0
            set check = 0
            call StartSpellUnit2(c)
            set a = GAngle( c , td ) // Angle Between points
            set dmg = GetHeroAgi( c , true) * ( TakeshiW2_DamageAgiBase + ( TakeshiW2_DamageAgiStep * ( GetUnitAbilityLevel( c , TakeshiW2_ID) - 1 ) ) )
            if GetUnitAbilityLevel(c, TakeshiT_Buff_ID) > 0 then
                set dmg = dmg + GetHeroAgi(c, true) * TakeshiT_AddDmg
            endif
            set rmax = 1.5
            call SetUnitAnimationByIndex(c, 11)
            call SetUnitTimeScale(c, 1.95)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_Windwalk Blue Soul.mdx", c, "weapon")
            call MakeSound("war3mapimported\\Hero_Takeshi_FW2")
            call MakeSound("war3mapimported\\Hero_Takeshi_FW3")
            call NextSound("war3mapimported\\Hero_Takeshi_FW4", 0.6)
            if MUI_TakeshiW2 == 0 then
                call TimerStart( t_TakeshiW2, 0.03, true, function thistype.Loop_TakeshiW2)
            endif
        endmethod

    endstruct

    private struct TakeshiSpells_E
        private static timer t_TakeshiE = CreateTimer()
        private static integer array m_TakeshiE
        private static integer MUI_TakeshiE = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k2
        real r3
        real r5
        group g
        unit u
        real dmg
        real scale
        integer check
        real aoe
        real move
        real r
        real a
        real rmax

        private static method Loop_TakeshiE takes nothing returns nothing
            local integer this
            local integer i = 0
            local real rk1 = 0
            local real rk2 = 0
            local real rk3 = 0
            local real rk4 = 0
            local real rk5 = 0
            local real rk6 = 0
            local real rk7 = 0
            loop
                exitwhen i > MUI_TakeshiE
                set this = m_TakeshiE[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    if check == 0 then
                        if r == r5 then
                            call SetUnitTimeScale(c, 1)
                            call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_Mdx_Effect_05 Mikoto AZ_Dust Rush 01.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG , 1, 1.1, 1, 255, 255, 255, 115))
                        endif
                        if r >=r5 then
                            call MoveUnit(c, move, a)
                            if r == rmax then
                                set check = 1
                                set r = 0
                                set rmax = 0.15
                                call StartSpellUnit(c)
                                call SetUnitTimeScale( c , 1)
                                call MakeSound("war3mapimported\\Hero_Takeshi_E3")
                            endif
                        endif
                    elseif check == 1 then
                        if r == 0.03 then
                            call DestroyEffect(EffectSpawn4("war3mapImported\\wos_1mt_shui1.mdl", GetUnitX(c) + 70 * Cos(a), GetUnitY(c) + 70 * Sin(a), a * bj_RADTODEG, 1, 3, 175, -30))
                        endif
                        if r == 0.06 then
                            call DestroyEffect(EffectSpawn4("war3mapImported\\wos_1mt_shui1.mdl", GetUnitX(c) + 140 * Cos(a), GetUnitY(c) + 140 * Sin(a), a * bj_RADTODEG, 1, 3, 275, 30))
                        endif
                        if r == 0.09 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_1mt_shui1.mdl", GetUnitX(c) + 70 * Cos(a), GetUnitY(c) + 70 * Sin(a), a * bj_RADTODEG, 1, 3, 150))
                        endif
                        if r == rmax then
                            set x = GetUnitX(c) + 125 * Cos(a)
                            set y = GetUnitY(c) + 125 * Sin(a)
                            set rk1 = 550
                            set rk2 = 1.75
                            set rk3 = 45
                            set rk4 = 225
                            set rk5 = 2.6
                            set rk6 = 2.5
                            set rk7 = 0.45
                            
                    call StopSpellUnit(c)
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_shockwave_b.mdl", x, y, 1, 1.1, 3, 175))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_obr08 (214).mdl", x, y, GetRandomReal(0, 359), 1, 1.75, 1))
                      //  call DestroyEffect(EffectSpawn("war3mapImported\\wos_2-[tx]-03-03jianta (3)_1.mdl", x, y, 1, 2.5, 3, 1))
                            call DestroyEffect(EffectSpawnScale("war3mapImported\\wos_1shui_2_1.mdl", x + rk1 * Cos(a + rk3 * bj_DEGTORAD), y + rk1 * Sin(a + rk3 * bj_DEGTORAD), 1, rk5, rk2, 1, rk7, rk2, rk6))
                            call DestroyEffect(EffectSpawnScale("war3mapImported\\wos_1shui_2_1.mdl", x + rk1 * Cos(a - rk3 * bj_DEGTORAD), y + rk1 * Sin(a - rk3 * bj_DEGTORAD), 1, rk5, rk2, 1, rk7, rk2, rk6))
                            call DestroyEffect(EffectSpawnScale("war3mapImported\\wos_1shui_2_1.mdl", x + rk1 * Cos(a + rk4 * bj_DEGTORAD), y + rk1 * Sin(a + rk4 * bj_DEGTORAD), 1, rk5, rk2, 1, rk7, rk2, rk6))
                            call DestroyEffect(EffectSpawnScale("war3mapImported\\wos_1shui_2_1.mdl", x + rk1 * Cos(a - rk4 * bj_DEGTORAD), y + rk1 * Sin(a - rk4 * bj_DEGTORAD), 1, rk5, rk2, 1, rk7, rk2, rk6))
                            call NextSound("war3mapimported\\Hero_Takeshi_E2", 0.3)
                            call DecorRemove(c, x, y, TakeshiE_DamageAoe, 40)
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c) - 70 * Cos(a), GetUnitY(c) - 70 * Sin(a), a * bj_RADTODEG , 2, 2.725, 1, 255, 255, 255, 155))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c) - 70 * Cos(a + 0.25 * bj_DEGTORAD), GetUnitY(c) - 70 * Sin(a + 0.25 * bj_DEGTORAD), a * bj_RADTODEG + 55 , 2, 2.725, 1, 255, 255, 255, 155))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c) - 70 * Cos(a - 0.25 * bj_DEGTORAD), GetUnitY(c) - 70 * Sin(a - 0.25 * bj_DEGTORAD), a * bj_RADTODEG - 55 , 2, 2.725, 1, 255, 255, 255, 155))
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , x , y , TakeshiE_DamageAoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    call dmgphys(c, u, dmg)
                                    if IsUnitIllusion(u) == false and IsUnitType(u,UNIT_TYPE_HERO) then 
                                call TakeshiGAdd_Start(c,dmg)
                                endif
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        endif
                    endif
                else
                    call SetUnitAnimation(c, "stand")
                    if check == 0 then
                        call StopSpellUnit2(c)
                    else
                        call StopSpellUnit(c)
                    endif
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set td = null
                    set u = null
                    set m_TakeshiE[i] = m_TakeshiE[ MUI_TakeshiE]
                    set MUI_TakeshiE = MUI_TakeshiE - 1
                    if MUI_TakeshiE == -1 then
                        call PauseTimer( t_TakeshiE)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method TakeshiE_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            local real time = 0
            set MUI_TakeshiE = MUI_TakeshiE + 1
            set m_TakeshiE[ MUI_TakeshiE] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 10
            set r3 = 1
            set k2 = 0
            set check = 0
            call StartSpellUnit2(c)
            set move = (SR3(c, x, y) - 125) / 9
            set r5 = 0.45
            set rmax = 0.21+r5
            set g = CreateGroup()
            set scale = 5.75
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set check = 0
            set aoe = TakeshiE_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( TakeshiE_DamageAgiBase + ( TakeshiE_DamageAgiStep * ( GetUnitAbilityLevel( c , TakeshiE_ID) - 1 ) ) )
            if GetUnitAbilityLevel(c, TakeshiT_Buff_ID) > 0 then
                set dmg = dmg + GetHeroAgi(c, true) * TakeshiT_AddDmg
            endif
            call SetUnitAnimationByIndex( c , 3)
            call MakeSound("war3mapimported\\Hero_Takeshi_E")
            call SetUnitTimeScale( c , 0.33)
            call SetUnitFacing( c , a * bj_RADTODEG)
            
            if MUI_TakeshiE == 0 then
                call TimerStart( t_TakeshiE, 0.03, true, function thistype.Loop_TakeshiE)
            endif
        endmethod

    endstruct

    private struct TakeshiSpells_R
        private static timer t_TakeshiR = CreateTimer()
        private static integer array m_TakeshiR
        private static integer MUI_TakeshiR = -1
        private static timer t_TakeshiR2 = CreateTimer()
        private static integer array m_TakeshiR2
        private static integer MUI_TakeshiR2 = -1
        unit c
        unit td
        real x
        real y
        real r2
        integer k
        real r3
        real r5
        real r6
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
        effect e3
        effect array ee [5]
        real a
        real rmax

        private static method Loop_TakeshiR takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_TakeshiR
                set this = m_TakeshiR[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r <= rmax then
                    set r = r + 0.03
                    call DebugUnit(c)
                    if r < 0.45 then
                        if r5 < 175 then
                            set r5 = r5 + 6
                            call BlzSetSpecialEffectHeight(e2, r5)
                            call BlzSetSpecialEffectHeight(e3, r5 - 80)
                        endif
                        call MoveEff(e2, 25, a)
                        call MoveEff(e3, 25, a)
                    endif
                    if r == 0.45 then
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, 1, 255, 255, 255, 255))
                        set ee[0] = EffectSpawn("war3mapImported\\wos_water dash.mdl", GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), a * bj_RADTODEG, 1, 2, 0)
                        set ee[1] = EffectSpawn("war3mapImported\\wos_water dash.mdl", GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), a * bj_RADTODEG, 1, 2, 155)
                        call BlzSetSpecialEffectPitch(ee[1], 8 * bj_DEGTORAD)
                        call BlzSetSpecialEffectRoll(ee[1], -90 * bj_DEGTORAD)
                        set ee[2] = EffectSpawn("war3mapImported\\wos_water dash.mdl", GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), a * bj_RADTODEG, 1, 2, 155)
                        call BlzSetSpecialEffectPitch(ee[2], 8 * bj_DEGTORAD)
                        call BlzSetSpecialEffectRoll(ee[2], -270 * bj_DEGTORAD)
                        set ee[3] = EffectSpawn("war3mapImported\\wos_water dash.mdl", GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), a * bj_RADTODEG, 1, 2, 315)
                        call BlzSetSpecialEffectPitch(ee[3], 15 * bj_DEGTORAD)
                        call BlzSetSpecialEffectRoll(ee[3], -90 * bj_DEGTORAD)
                        set ee[4] = EffectSpawn("war3mapImported\\wos_water dash.mdl", GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), a * bj_RADTODEG, 1, 2, 315)
                        call BlzSetSpecialEffectPitch(ee[4], 15 * bj_DEGTORAD)
                        call BlzSetSpecialEffectRoll(ee[4], -270 * bj_DEGTORAD)
                        call MakeSound("war3mapimported\\Hero_Takeshi_R3")
                        set k = 0
                        loop
                            exitwhen k > 4
                            call ColorEffDummy4(ee[k], 0, 255, 255, 255, 0.21)
                            if k > 2 then
                                call ScaleEffDummy(ee[k], 0.3, 1, 2.4)
                            else
                                call ScaleEffDummy(ee[k], 0.3, 1, 2.1)
                            endif
                            set k = k + 1
                        endloop
                    endif
                    if r >= 0.8 then
                        if r == 0.8 then
                            call SetUnitTimeScale(c, 0.1)
                        endif
                        if SR2(c, td) > 210 then
                            set a = GAngle(c, td)
                            call MoveUnit2(c, move, a)
                            set k = 0
                            loop
                                exitwhen k > 4
                                call MoveEff(ee[k], move, a)
                                call BlzSetSpecialEffectYaw(ee[k], a)
                                set k = k + 1
                            endloop
                            call SetUnitFacing(c, a * bj_RADTODEG)
                            call BlzSetSpecialEffectPosition(e2, GetUnitX(c) + 245 * Cos(a), GetUnitY(c) + 245 * Sin(a), BlzGetLocalSpecialEffectZ(e2))
                            call BlzSetSpecialEffectPosition(e3, GetUnitX(c) + 245 * Cos(a), GetUnitY(c) + 245 * Sin(a), BlzGetLocalSpecialEffectZ(e3))
                            call BlzSetSpecialEffectYaw(e2, a)
                            call BlzSetSpecialEffectYaw(e3, a)
                            if r2 > 0.03 then
                                set r2 = 0
                        
                            else
                                set r2 = r2 + 0.03
                            endif
                        else
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            call SetUnitTimeScale(c, 1)
                            set r = 99999
                            
                    call StopSpellUnit(c)
                            call MakeSound("war3mapimported\\Hero_Takeshi_R")
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_shockwave_b.mdl", x, y, 1, 1, 2.75, 125))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_waterexplosion.mdl", x, y, 1, 2.5, 3, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_2-[tx]-03-03jianta (3)_1.mdl", x, y, 1, 2, 2.5, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlash.mdl" , x + 25 * Cos(a), y + 25 * Sin(a), 1, 1., 1.975, 125))
                            call StunUnit(c, td, TakeshiR_Stun )
                            call DecorRemove(c, x, y, aoe, 100)
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    call dmgmag(c, u, dmg)
                                    if IsUnitIllusion(u) == false and IsUnitType(u,UNIT_TYPE_HERO) then 
                                call TakeshiGAdd_Start(c,dmg)
                                endif
                                    call ErzaPassive(c,u,2)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                        endif
                    endif
                else
                    if r >= 0.45 then
                        set k = 0
                        loop
                            exitwhen k > 4
                            call MyRemoveEff(ee[k], 0.3)
                            set ee[k] = null
                            set k = k + 1
                        endloop
                    endif
                    call DestroyEffect(e3)
                    call ColorEffDummy3(e2, 0, 255, 255, 255, 0.3)
                    call StopSpellUnit(c)
                    call SetUnitTimeScale( c , 1)
                    call DestroyEffect(e)
                    call DestroyGroup( g )
                    set g = null
                    set c = null
                    set e = null
                    set u = null
                    set m_TakeshiR[i] = m_TakeshiR[ MUI_TakeshiR]
                    set MUI_TakeshiR = MUI_TakeshiR - 1
                    if MUI_TakeshiR == -1 then
                        call PauseTimer( t_TakeshiR)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method TakeshiR_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_TakeshiR = MUI_TakeshiR + 1
            set m_TakeshiR[ MUI_TakeshiR] = this
            set c = NewC
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r = 0
            set r2 = 0
            set move = 70
            set r6 = 0
            call StartSpellUnit(c)
            set g = CreateGroup()
            set r5 = 125
            set u = null
            set check2 = 0
            set a = GAngle2( c , x , y ) // Angle Between points
            set aoe = TakeshiR_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( TakeshiR_DamageAgiBase + ( TakeshiR_DamageAgiStep * ( GetUnitAbilityLevel( c , TakeshiR_ID) - 1 ) ) )
            set rmax = 2.2
            call SetUnitAnimationByIndex(c, 3)
            call SetUnitTimeScale(c, 0.4)
            set e = AddSpecialEffectTarget("war3mapImported\\wos_Windwalk Blue Soul.mdl", c, "weapon")
            call MakeSound("war3mapimported\\Hero_Takeshi_R2")
            call NextSound("war3mapimported\\Hero_Takeshi_R4", 0.99)
            set e2 = EffectSpawn("war3mapImported\\wos_takeshiswallow.mdl", GetUnitX(c) + 35 * Cos(a), GetUnitY(c) + 35 * Sin(a), a * bj_RADTODEG, 1, 2.25, r5)
            set e3 = EffectSpawn("war3mapImported\\wos_Windwalk Blue Soul.mdl", GetUnitX(c) + 35 * Cos(a), GetUnitY(c) + 35 * Sin(a), a * bj_RADTODEG, 1, 1.5, r5 - 80)
            if MUI_TakeshiR == 0 then
                call TimerStart( t_TakeshiR, 0.03, true, function thistype.Loop_TakeshiR)
            endif
        endmethod

        private static method Loop_TakeshiR2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_TakeshiR2
                set this = m_TakeshiR2[i]
                if SpellBoolCaster(c) and r <= rmax and LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("takeshi esc")) == 0 then
                    set r = r + 0.03
                    call DebugUnit2(c)
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    call BlzSetSpecialEffectPosition(e, x, y, 1)
                    if r == 0.45 then
                        call MakeSound("war3mapimported\\Hero_Takeshi_FR2")
                    endif
                    if r == 1.2 then
                        call MakeSound("war3mapimported\\Hero_Takeshi_FR3")
                    endif
                    if r2 > 0.24 then
                        set r2 = 0
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_bluemorphcircle3.mdl", x, y, GetRandomReal(0, 359), 1, 1.4, 1))
                    else
                        set r2 = r2 + 0.03
                    endif
                else
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("yamamoto fr"), 0)
                    call StopSpellUnit2(c)
                    call DestroyEffect(e)
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("takeshi esc"), 0)
                    set e = null
                    set c = null
                    set m_TakeshiR2[i] = m_TakeshiR2[ MUI_TakeshiR2]
                    set MUI_TakeshiR2 = MUI_TakeshiR2 - 1
                    if MUI_TakeshiR2 == -1 then
                        call PauseTimer( t_TakeshiR2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method TakeshiR2_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            local real time = 0
            set MUI_TakeshiR2 = MUI_TakeshiR2 + 1
            set m_TakeshiR2[ MUI_TakeshiR2] = this
            set c = NewC
            set r = 0
            set r2 = 10
            set r3 = 1
            set check = 0
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("takeshi esc"), 0)
            call StartSpellUnit2(c)
            set rmax = TakeshiR2_DurationBase + TakeshiR2_DurationStep * (GetUnitAbilityLevel(c, TakeshiR2_ID) - 1)
            set a = GetUnitFacing(c) * bj_DEGTORAD // Angle Between points
            call SetUnitAnimationByIndex( c , 5)
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("yamamoto fr"), 1)
            call MakeSound("war3mapimported\\Hero_Takeshi_FR")
            call SetUnitTimeScale( c , 1.1)
            call DecorRemove(c, x, y, 500, 20)
            set e = EffectSpawn("war3mapImported\\wos_fj_w2.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 0.9, 1)
            call SetUnitFacing( c , a * bj_RADTODEG)
            set r5 = 0
            if MUI_TakeshiR2 == 0 then
                call TimerStart( t_TakeshiR2, 0.03, true, function thistype.Loop_TakeshiR2)
            endif
        endmethod

    endstruct

    private struct TakeshiSpells_T
        private static timer t_TakeshiT = CreateTimer()
        private static integer array m_TakeshiT
        private static integer MUI_TakeshiT = -1
        unit c
        unit td
        real x
        real y
        real x1
        real y1
        real r2
        real r3
        real r4
        real r5
        real r6
        group g
        group g2
        unit u
        real dmg
        real scale
        integer check
        integer check2
        integer check3
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_TakeshiT takes nothing returns nothing
            local integer this
            local integer i = 0
            local integer kk = 0
            loop
                exitwhen i > MUI_TakeshiT
                set this = m_TakeshiT[i]
                if SpellBoolCaster(c) and r <= rmax then // and GetUnitState(c, UNIT_STATE_MANA) > 50 then
                    set r = r + 0.03
                    if check >= 1 then
                         /* if r < TakeshiT_InvulTime then
                        call UnitAddAbility(c, 'Avul')
                    elseif check3 == 0 then
                        set check3 = 1
                        call UnitRemoveAbility(c, 'Avul')
                    endif */ 
                    call DecorRemove(c, x, y, aoe, 100)
                    
                    if SR3(c, x, y) < aoe then
                        //call SetMpCurrent(c,-scale)
                    endif
                    if r3 > 0.91 then
                        set r3 = 0
                        if SR3(c, x, y) < aoe then
                            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("style")) == 0 then
                                call ReduceCooldown(c, TakeshiQ_ID, TakeshiT_ReduceCD)
                                call ReduceCooldown(c, TakeshiW_ID, TakeshiT_ReduceCD)
                                call ReduceCooldown(c, TakeshiE_ID, TakeshiT_ReduceCD)
                                call ReduceCooldown(c, TakeshiR_ID, TakeshiT_ReduceCD)
                            else
                                call ReduceCooldown(c, TakeshiQ2_ID, TakeshiT_ReduceCD)
                                call ReduceCooldown(c, TakeshiQ3_ID, TakeshiT_ReduceCD)
                                call ReduceCooldown(c, TakeshiW2_ID, TakeshiT_ReduceCD)
                                call ReduceCooldown(c, TakeshiE2_ID, TakeshiT_ReduceCD)
                                call ReduceCooldown(c, TakeshiR2_ID , TakeshiT_ReduceCD)
                            endif
                            call ReduceCooldown(c, TakeshiGQ_ID, TakeshiT_ReduceCD)
                            call ReduceCooldown(c, TakeshiGW_ID, TakeshiT_ReduceCD)
                            call ReduceCooldown(c, TakeshiGE_ID, TakeshiT_ReduceCD)
                            call ReduceCooldown(c, TakeshiGR_ID, TakeshiT_ReduceCD)
                        endif
                    else
                        set r3 = r3 + 0.03
                    endif
                    if r6 > 0.33 then
                        set r6 = 0
                        call GroupClear(g)
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                call SlowUnit(c, u, TakeshiT_Slow, TakeshiT_SlowDuration)
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_bluemorphcircle.mdl", x, y, GetRandomReal(0, 359), 1, 1.33, 1))
                    else
                        set r6 = r6 + 0.03
                    endif
                endif
                if check == 0 then
                    call DebugUnit2(c)
                    if r > 0.3 then 
                    
                    set a = GAngle2(c,x,y)
                    call BlzSetUnitFacingEx(c,a*bj_RADTODEG)
                    if SR3(c, x, y) >= 500 then
                        call MoveUnit(c, move, a)
                    else
                        set r = 0
                        set rmax = TakeshiT_Duration
                        set check = 1
                        set e = EffectSpawnScale("war3mapImported\\wos_LD2209 (96)_ws2.mdl", x, y, 1, 1, 0.01, 1, 0.5, 0.01, 1.1)
                        if check2 == 0 then
                            call MakeSound("war3mapimported\\Hero_Takeshi_T2")
                            call NextSound("war3mapimported\\Hero_Takeshi_T3", 1.8)
                            call StopSpellUnit(c)
                        else
                            call GroupClear(g)
                            set move = 140
                            set td = null
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                    call GroupAddUnit(g2, u)
                                    call SlowUnit(c, u, TakeshiT_Slow, TakeshiT_SlowDuration)
                                endif
                                call GroupRemoveUnit( g , u )
                            endloop
                            set u = null
                            set check = 2
                            call DebugUnit2(c)
                        endif
                        set r3 = 0
                    endif
                    endif
                elseif check == 1 then
                    if SR3(c, x, y) > aoe then
                        if check3 == 0 then
                            set check3 = 1
                            call SaveInteger(hs,GetHandleId(c),StringHash("def t"),0)
                        endif
                        if IsUnitPaused(c) == false then
                            call UnitRemoveAbility(c, TakeshiT_Buff_ID)
                        endif
                    else
                        set check3 = 0
                            call SaveInteger(hs,GetHandleId(c),StringHash("def t"),1)
                        call BuffUnit1(c, c, 8)
                    endif
                elseif check == 2 then
                    if td == null then
                        set td = FirstOfGroup(g2)
                    endif
                    if td != null then
                        if SR2(c, td) > 145 then
                            set a = GAngle(c, td)
                            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
                            call MoveUnit(c, move, a)
                            if r2 > 0.06 then
                                set r2 = 0
                                set x1 = GetUnitX(c)
                                set y1 = GetUnitY(c)
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x1 + 100 * Cos(a), y1 + 100 * Sin(a), a * bj_RADTODEG, 0.5, 1.75, 75))
                            else
                                set r2 = r2 + 0.03
                            endif
                        else
                            call SetUnitAnimationByIndex(c, 9)
                            call GroupRemoveUnit(g2, td)
                            set x1 = GetUnitX(td)
                            set y1 = GetUnitY(td)
                            call dmgphys(c, td, dmg)
                            call ErzaPassive(c, td, 2)
                            call MakeSound("war3mapimported\\Hero_Takeshi_FW")
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_shockwave_b.mdl", x1, y1, 1, 0.8, 2, 175))
                            call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_bluemorphcircle2.mdl", x1, y1, GetRandomReal(0, 359), 1, 1.4, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_1mt_shui1.mdl", GetUnitX(c) + 0 * Cos(a), GetUnitY(c) + 0 * Sin(a), a * bj_RADTODEG, 2, 2.25, 150))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_2-[tx]-03-03jianta (3)_1.mdl", x1, y1, 1, 2, 1, 1))
                            set td = null
                        endif
                    else
                        call StopSpellUnit(c)
                        set check = 3
                    endif
                elseif check == 3 then
                    if SR3(c, x, y) > aoe then
                        if check3 == 0 then
                            set check3 = 1
                            call SaveInteger(hs,GetHandleId(c),StringHash("def t"),0)
                        endif
                        if IsUnitPaused(c) == false then
                            call UnitRemoveAbility(c, TakeshiT_Buff_ID)
                        endif
                    else
                        set check3 = 0
                            call SaveInteger(hs,GetHandleId(c),StringHash("def t"),1)
                        call BuffUnit1(c, c, 8)
                    endif
                    if r4 > 0.8 and IsUnitPaused(c) == false and SR3(c, x, y) <= aoe then
                        set r4 = 0
                        set kk = 0
                        set td = null
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                call GroupAddUnit(g2, u)
                                set kk = kk + 1
                                    call ErzaPassive(c,u,2)
                                call SlowUnit(c, u, TakeshiT_Slow, TakeshiT_SlowDuration)
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                        if kk > 0 then
                            set check = 2
                            call DebugUnit(c)
                        endif
                    else
                        set r4 = r4 + 0.03
                    endif
                endif
            else    
                call StopSpellUnit2(c)
                if check == 0 then
                    call StopSpellUnit2(c)
                else
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                endif
                if check > 1 then
                    call StopSpellUnit(c)
                endif
                
        call SaveReal(hs,GetHandleId(c),StringHash("t x"),0)
        call SaveReal(hs,GetHandleId(c),StringHash("t y"),0)
                call SaveInteger(hs,GetHandleId(c),StringHash("def t"),0)
                call SaveInteger(hs, GetHandleId(c), StringHash("yama t"), 0)
                call DestroyGroup(g)
                call DestroyGroup(g2)
                set g = null
                set td = null
                set g2 = null
                set e = null
                set u = null
                set e2 = null
                set c = null
                set m_TakeshiT[i] = m_TakeshiT[ MUI_TakeshiT]
                set MUI_TakeshiT = MUI_TakeshiT - 1
                if MUI_TakeshiT == -1 then
                    call PauseTimer( t_TakeshiT)
                endif
                call deallocate(this)
            endif
            set i = i + 1
        endloop
    endmethod

    public static method TakeshiT_Start takes unit NewC, real NewX, real NewY returns nothing
        local thistype this = thistype.create( )
        local real time = 0
        set MUI_TakeshiT = MUI_TakeshiT + 1
        set m_TakeshiT[ MUI_TakeshiT] = this
        set c = NewC
        set x = NewX
        set y = NewY
        call SaveReal(hs,GetHandleId(c),StringHash("t x"),x)
        call SaveReal(hs,GetHandleId(c),StringHash("t y"),y)
        set r = 0
        set r4 = 0.
        set r6 = 10
        set check3 = 0
        set g = CreateGroup()
        set g2 = CreateGroup()
        set r2 = 10
        set move = 70
        set check = 0
        set check2 = 0
        call StartSpellUnit2(c)        
        call SaveInteger(hs,GetHandleId(c),StringHash("def t"),0)
        set scale = (GetUnitState(c, UNIT_STATE_MAX_MANA) * (TakeshiGW_Time / 100)) / 33
        set rmax = 3
        set aoe = TakeshiT_DamageAoe
        set a = GAngle2(c, x, y) // Angle Between points
        if LoadInteger(hs, GetHandleId(c), StringHash("mode g")) == 0 then
            call SetUnitAnimationByIndex( c , 3 )
            set check2 = 0
            call MakeSound("war3mapimported\\Hero_Takeshi_T")
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_Windwalk Blue Soul.mdl", c, "weapon")
        else
            call MakeSound("war3mapimported\\Hero_Takeshi_GT")
            set check2 = 1
            call SaveInteger(hs, GetHandleId(c), StringHash("yama t"), 1)
            call SetUnitAnimationByIndex( c , 17 )
            set dmg = GetHeroAgi( c , true) * TakeshiGT_DamageAgiBase
            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_Windwalk Blue Soul.mdl", c, "hand right")
        endif
        call SetUnitTimeScale( c , 1)
        call SetUnitFacing( c , a * bj_RADTODEG)
        set r5 = 0
        if MUI_TakeshiT == 0 then
            call TimerStart( t_TakeshiT, 0.03, true, function thistype.Loop_TakeshiT)
        endif
    endmethod

    endstruct

    private struct TakeshiSpells_G
        private static timer t_TakeshiG = CreateTimer()
        private static integer array m_TakeshiG
        private static integer MUI_TakeshiG = -1
        private static timer t_TakeshiGQ = CreateTimer()
        private static integer array m_TakeshiGQ
        private static integer MUI_TakeshiGQ = -1
        private static timer t_TakeshiGW2 = CreateTimer()
        private static integer array m_TakeshiGW2
        private static integer MUI_TakeshiGW2 = -1
        private static timer t_TakeshiGW = CreateTimer()
        private static integer array m_TakeshiGW
        private static integer MUI_TakeshiGW = -1
        private static timer t_TakeshiGE2 = CreateTimer()
        private static integer array m_TakeshiGE2
        private static integer MUI_TakeshiGE2 = -1
        private static timer t_TakeshiGE = CreateTimer()
        private static integer array m_TakeshiGE
        private static integer MUI_TakeshiGE = -1
        private static timer t_TakeshiGR = CreateTimer()
        private static integer array m_TakeshiGR
        private static integer MUI_TakeshiGR = -1
        private static timer t_TakeshiGF = CreateTimer()
        private static integer array m_TakeshiGF
        private static integer MUI_TakeshiGF = -1
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
        real r3
        real r4
        real r5
        real r6
        real r7
        real r8
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
        effect e3
        effect e4
        effect array ee [5]
        real a
        real a2
        real rmax
        framehandle array frame2_pas1 [10]
        framehandle array frame2_pas2 [10]
        framehandle array frame2_pas3 [10]
        framehandle array frame2_pas4 [10]
        framehandle array frame2_pas5 [10]
        framehandle array frame2_pas6 [10]

    private static method Loop_TakeshiG takes nothing returns nothing
        local integer this
        local integer i = 0
        local real tmp_y = 0.0375
        loop
            exitwhen i > MUI_TakeshiG
            set this = m_TakeshiG[i]
            if SpellBoolCaster(c) and r <= rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false then
                if check == 0 then
                    call DebugUnit(c)
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if r == 0.39 then
                        call MakeSound("war3mapimported\\Hero_Takeshi_G2")
                    endif
                    call BlzSetSpecialEffectPosition(e, GetUnitX(c), GetUnitY(c), 0)
                    if r == 1.02 then
                        call DestroyEffect(e)
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_waterexplosion.mdl", x, y, 1, 2, 1.5, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_2-[tx]-03-03jianta (3)_1.mdl", x, y, 1, 1, 1.5, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_bluemorphcircle3.mdl", x, y, GetRandomReal(0, 359), 0.7, 1, 1))
                        call MakeSound("war3mapimported\\Hero_Takeshi_G3")
                        call MakeSound("war3mapimported\\Hero_Takeshi_G4")
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiG_ID, false)
                        call UnitAddAbility(c, TakeshiG2_ID)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiG2_ID, true)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiGQ_ID, true)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiGW_ID, true)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiGE_ID, true)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiGR_ID, true)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiGF_ID, true)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiQ_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiQ2_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiQ3_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiW_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiW2_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiE_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiE2_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiR_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiR2_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiF_ID, false)
                        call UnitAddAbility(c, TakeshiGQ_ID)
                        call UnitAddAbility(c, TakeshiGW_ID)
                        call UnitAddAbility(c, TakeshiGE_ID)
                        call UnitAddAbility(c, TakeshiGR_ID)
                        call UnitAddAbility(c, TakeshiGF_ID)
                        call SetUnitAbilityLevel(c, TakeshiT_ID, 2)
                        call OkarunEggCd(c,TakeshiGQ_ID,BlzGetUnitAbilityCooldownRemaining(c, TakeshiQ_ID) - TakeshiG_ReduceCD)
                        call OkarunEggCd(c,TakeshiGW_ID,BlzGetUnitAbilityCooldownRemaining(c, TakeshiW_ID) - TakeshiG_ReduceCD)
                        call OkarunEggCd(c,TakeshiGE_ID,BlzGetUnitAbilityCooldownRemaining(c, TakeshiE_ID) - TakeshiG_ReduceCD)
                        call OkarunEggCd(c,TakeshiGR_ID,BlzGetUnitAbilityCooldownRemaining(c, TakeshiR_ID) - TakeshiG_ReduceCD)
                        call BlzSetUnitSkin(c, Takeshi2_ID)
                        call AddSpecialEffectTarget("war3mapImported\\wos_Takeshiaura.mdl", c, "origin")
                        call FixAura(c)
                        call DecorRemove(c, x, y, 800, 50)
                        call VisionTimed(GetOwningPlayer(c), x , y, 1500, 2)
                        set check = 1
                        call StopSpellUnit(c)
                        set r = 0
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
                            call BlzFrameSetValue(frame2_pas3[k2], rmax)
                            set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)
                            call BlzFrameSetAbsPoint(frame2_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18 + tmp_y)
                            call BlzFrameSetSize(frame2_pas4[k2], 0.03, 0.03)
                            call BlzFrameSetTexture(frame2_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Takeshi_G", 0, false)
                            set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                            call BlzFrameSetAbsPoint(frame2_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185 + tmp_y)
                            call BlzFrameSetText(frame2_pas5[k2], "|c00FFFF00" + "Morph Time Left:" + "|r")
                            call BlzFrameSetScale(frame2_pas5[k2], 0.9)
                            set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                            call BlzFrameSetAbsPoint(frame2_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17 + tmp_y)
                            call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                            call BlzFrameSetScale(frame2_pas6[k2], 0.9)
                        else
                            if GetLocalPlayer() == GetOwningPlayer(c) then
                                call BlzFrameSetVisible(frame2_pas1[k2], true)
                            endif
                            call BlzFrameSetValue(frame2_pas3[k2], rmax)
                        endif
                    endif
                elseif check == 1 then
                    if IsUnitPaused(c) == false and LoadInteger(hs, GetHandleId(c), StringHash("yama t")) == 0 then
                        set r = r + 0.03
                    endif
                    set r = S2R( R2SW( r , 0, 3 ) )
                    call BlzFrameSetValue(frame2_pas3[k2], rmax - (r + 0.1))
                    if rmax - r >= 0 then
                        call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                    endif
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                endif
            else
                call SaveInteger(hs, GetHandleId(c), StringHash("mode g"), 0)
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiG2_ID, false)
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiGQ_ID, false)
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiGW_ID, false)
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiGE_ID, false)
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiGR_ID, false)
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiGF_ID, false)
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiG_ID, true)
                call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiF_ID, true)
                call SetUnitAbilityLevel(c, TakeshiT_ID, 1)
                if LoadInteger(hs, GetHandleId(Player(k2)), StringHash("style")) == 0 then
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiQ_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiW_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiE_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiR_ID, true)
                else
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiQ2_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiW2_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiE2_ID, true)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TakeshiR2_ID, true)
                endif
                 call BlzStartUnitAbilityCooldown(c, TakeshiQ_ID, BlzGetUnitAbilityCooldownRemaining(c, TakeshiGQ_ID))
                 call BlzStartUnitAbilityCooldown(c, TakeshiW_ID, BlzGetUnitAbilityCooldownRemaining(c, TakeshiGW_ID))
                 call BlzStartUnitAbilityCooldown(c, TakeshiE_ID, BlzGetUnitAbilityCooldownRemaining(c, TakeshiGE_ID))
                 call BlzStartUnitAbilityCooldown(c, TakeshiR_ID, BlzGetUnitAbilityCooldownRemaining(c, TakeshiGR_ID))
                call BlzSetUnitSkin(c, Takeshi_ID)
                if GetLocalPlayer() == GetOwningPlayer(c) then
                    call BlzFrameSetVisible(frame2_pas1[k2], false)
                endif
                call IssueImmediateOrder(c, "stop")
                if check == 0 then
                    call StopSpellUnit(c)
                endif
                call FixAura(c)
                set c = null
                set e = null
                set m_TakeshiG[i] = m_TakeshiG[ MUI_TakeshiG]
                set MUI_TakeshiG = MUI_TakeshiG - 1
                if MUI_TakeshiG == -1 then
                    call PauseTimer( t_TakeshiG)
                endif
                call deallocate(this)
            endif
            set i = i + 1
        endloop
    endmethod

    public static method TakeshiG_Start takes unit NewC returns nothing
        local thistype this = thistype.create( )
        set MUI_TakeshiG = MUI_TakeshiG + 1
        set m_TakeshiG[ MUI_TakeshiG] = this
        set c = NewC
        set x = GetUnitX(c)
        set y = GetUnitY(c)
        call StartSpellUnit(c)
        set check = 0
        set r = 0
        set k2 = GetPlayerId(GetOwningPlayer(c))
        set r2 = 10
        call UnitRemoveAbility(c, TsunaW_Buff_ID)
        call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(TsunaG_ID)), 1)
        call SaveInteger(hs, GetHandleId(c), StringHash("mode g"), 1)
        set e = AddSpecialEffectTarget("war3mapImported\\wos_blueauraichigo.mdl", c, "origin")
        set rmax = TakeshiG_Duration
        call MakeSound("war3mapimported\\Hero_Takeshi_G")
        if MUI_TakeshiG == 0 then
            call TimerStart( t_TakeshiG, 0.03, true, function thistype.Loop_TakeshiG)
        endif
    endmethod

    private static method Loop_TakeshiGQ takes nothing returns nothing
        local integer this
        local integer i = 0
        local real rk1 = 0
        local real rk2 = 0
        local real rk3 = 0
        local real rk4 = 0
        local real kkk = 0
        loop
            exitwhen i > MUI_TakeshiGQ
            set this = m_TakeshiGQ[i]
            if SpellBoolCaster(c) and r <= rmax then
                set r = r + 0.03
                call DebugUnit2(c)
                if r == 0.42 then
                    call SetUnitAnimationByIndex(c, 36)
                    set x1 = GetUnitX(c)
                    set y1 = GetUnitY(c)
                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, 1, 255, 255, 255, 255))
                    call DecorRemove(c, x, y, aoe, 25)
                    call MakeSound("war3mapimported\\Hero_Takeshi_Q3")
                    set e2 = EffectSpawn("war3mapImported\\wos_water dash.mdl", GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), a * bj_RADTODEG, 1, 1.65, 0)
                    set r5 = 0
                    set move = TakeshiGQ_Range / 43
                    set r6 = move * 8
                endif
                if r == 0.69 then
                    call MakeSound("war3mapimported\\Hero_Takeshi_GQ2")
                endif
                if r == 1.5 then
                    call MakeSound("war3mapimported\\Hero_Takeshi_GQ3")
                endif
                if r > 0.51 then
                    set x = GetUnitX(c) + 135 * Cos(a)
                    set y = GetUnitY(c) + 135 * Sin(a)
                    set rk1 = GetRandomReal(50, 350)
                    if GetRandomInt(1, 2) == 1 then
                        set rk2 = -90 * bj_DEGTORAD
                    else
                        set rk2 = 90 * bj_DEGTORAD
                    endif
                    set rk3 = GetRandomReal(100, 300)
                    set rk4 = GetRandomReal(600, 900)
                    set e3 = EffectSpawn("war3mapImported\\wos_TakeshiSword2.mdl" , x + rk1 * Cos(a + rk2), y + rk1 * Sin(a + rk2), a * bj_RADTODEG, 1, 3, rk3)
                    call EMUE(e3, rk4, 0.15, a)
                    call ColorEffDummy3(e3, 0, 255, 255, 255, 0.21)
                    if r2 > 0.03 then
                        set r2 = 0
                        set x = GetUnitX(c) + 265 * Cos(a)
                        set y = GetUnitY(c) + 265 * Sin(a)
                        set r2 = 0
                        set rk1 = GetRandomReal(220, 500)
                        if GetRandomInt(1, 2) == 1 then
                            set rk2 = -90 * bj_DEGTORAD
                        else
                            set rk2 = 90 * bj_DEGTORAD
                        endif
                        set rk3 = GetRandomReal(100, 300)
                        set rk4 = GetRandomReal(400, 800)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlash.mdl" , x + rk1 * Cos(a + rk2), y + rk1 * Sin(a + rk2), 1, 1., 0.875, rk3))
                    else
                        set r2 = r2 + 0.03
                    endif
                    if r4 > 0.12 then
                        set r4 = 0
                        call EffectSpawn2("war3mapImported\\wos_Bubbles2.mdx", x1 , y1, GetRandomReal(0, 359), 1, 6, GetRandomReal(50, 150), 0.45)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x1 + 100 * Cos(a), y1 + 100 * Sin(a), a * bj_RADTODEG, 0.75, 2.5, 75))
                    else
                        set r4 = r4 + 0.03
                    endif
                    set r5 = r5 + move
                    if LoadInteger(hs,GetHandleId(c),StringHash("def t"))>0 then 
                        set x2 = LoadReal(hs,GetHandleId(c),StringHash("t x"))
                        set y2 = LoadReal(hs,GetHandleId(c),StringHash("t y"))
                        if SR0(GetUnitX(c)+move*Cos(a),GetUnitY(c)+move*Sin(a),x2,y2)< TakeshiT_DamageAoe-220 then
                        call MoveUnit(c, move, a)
                        else
                        set kkk = 1
                        endif
                        else
                        call MoveUnit(c, move, a)
                        endif
                        
                    call BlzSetSpecialEffectPosition(e2, GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), 1)
                    call SetUnitFacing(c, a * bj_RADTODEG)
                    set x1 = GetUnitX(c)
                    set y1 = GetUnitY(c)
                    call DecorRemove(c, x1, y1, aoe, 25)
                    if r3 >= 0.21 then
                        set r3 = 0
                        set x = GetUnitX(c) + 135 * Cos(a)
                        set y = GetUnitY(c) + 135 * Sin(a)
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) then
                                call dmgphys(c, u, dmg)
                                call ErzaPassive(c, u, 2)
                                call StunUnit(c, u, TakeshiGQ_Stun)
                                if kkk == 0 then 
                                call MUE(u, r6, 0.15, a)
                                endif
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    else
                        set r3 = r3 + 0.03
                    endif
                endif
            else
                call StopSpellUnit2(c)
                call MyRemoveEff(e2, 0.3)
                call SetUnitAnimation(c, "stand")
                call SetUnitTimeScale( c , 1)
                call DestroyEffect(e)
                call DestroyGroup( g )
                set g = null
                set c = null
                set e = null
                set e2 = null
                set u = null
                set m_TakeshiGQ[i] = m_TakeshiGQ[ MUI_TakeshiGQ]
                set MUI_TakeshiGQ = MUI_TakeshiGQ - 1
                if MUI_TakeshiGQ == -1 then
                    call PauseTimer( t_TakeshiGQ)
                endif
                call deallocate(this)
            endif
            set i = i + 1
        endloop
    endmethod

    public static method TakeshiGQ_Start takes unit NewC, real NewX, real NewY returns nothing
        local thistype this = thistype.create( )
        set MUI_TakeshiGQ = MUI_TakeshiGQ + 1
        set m_TakeshiGQ[ MUI_TakeshiGQ] = this
        set c = NewC
        set x = NewX
        set y = NewY
        set r = 0
        set r2 = 0
        set move = 75
        set r6 = 0
        call StartSpellUnit2(c)
        set g = CreateGroup()
        set u = null
        set a = GAngle2( c , x , y ) // Angle Between points
        set aoe = TakeshiGQ_DamageAoe
        set dmg = GetHeroAgi( c , true) * TakeshiGQ_DamageAgiBase
        if GetUnitAbilityLevel(c, TakeshiT_Buff_ID) > 0 then
            set dmg = dmg + GetHeroAgi(c, true) * TakeshiT_AddDmg
        endif
        set dmg = dmg / 5
        set rmax = 1.8
        call SetUnitAnimationByIndex(c, 35)
        call SetUnitTimeScale(c, 1)
        set e = AddSpecialEffectTarget("war3mapImported\\wos_e tanjiro (4).mdl", c, "weapon")
        call MakeSound("war3mapimported\\Hero_Takeshi_GQ")
        if MUI_TakeshiGQ == 0 then
            call TimerStart( t_TakeshiGQ, 0.03, true, function thistype.Loop_TakeshiGQ)
        endif
    endmethod

    private static method Loop_TakeshiGW2 takes nothing returns nothing
        local integer this
        local integer i = 0
        loop
            exitwhen i > MUI_TakeshiGW2
            set this = m_TakeshiGW2[i]
            if SpellBoolCaster(td) and r <= rmax then
                set r = r + 0.03
                set x = GetUnitX(td)
                set y = GetUnitY(td)
                if r == 0.18 then
                    call BlzSetSpecialEffectTimeScale(e, 0.3)
                endif
                if SR5(e, x, y) > 140 then
                    set a = GAngle5(e, x, y)
                    call MoveEff2(e, move, a + a2)
                    call MoveEff2(e2, move, a + a2)
                    set r5 = r5 + 15
                    call BlzSetSpecialEffectYaw(e, r5 * bj_DEGTORAD)
                    if r2 > 0 then
                        set r2 = 0
                        call GroupClear(g)
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        call VisionTimed(GetOwningPlayer(c), x, y, 400, 1)
                        call DecorRemove(c, x, y, aoe, 50)
                        call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                call dmgphys(c, u, dmg)
                                call GroupAddUnit(g2, u)
                                    //call MUE(u,TakeshiGW_PushRange,TakeshiGW_PushDuration,a)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    else
                        set r2 = r2 + 0.03
                    endif
                else
                    set r = 9999
                endif
            else
                call VisionTimed(GetOwningPlayer(c), x, y, 400, 1)
                call DecorRemove(c, x, y, aoe, 50)
                call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
                loop
                    set u = FirstOfGroup( g )
                    exitwhen u == null
                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                        call dmgphys(c, u, dmg)
                        call GroupAddUnit(g2, u)
                                    //call MUE(u,TakeshiGW_PushRange,TakeshiGW_PushDuration,a)
                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                    endif
                    call GroupRemoveUnit( g , u )
                endloop
                set u = null
                call DestroyGroup(g)
                call DestroyGroup(g2)
                set x = GetUnitX(td)
                set y = GetUnitY(td)
                call ErzaPassive(c, td, 2)
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_BrightBlueSlash.mdl", x, y, GetRandomReal(0, 359), GetRandomReal(0.7, 1.1), GetRandomReal(1, 3), 55))
                call DestroyEffect(EffectSpawn3("war3mapImported\\wos_YC_Shockwave_b.mdl", x, y, GetRandomReal(0, 359), 1.25, 2, 205, -30))
                call DestroyEffect(EffectSpawn3("war3mapImported\\wos_slashbluekojiro.mdl", x, y, GetRandomReal(0, 359), 1.25, 2, 205, -30))
                call ColorEffDummy3(e, 0.1, 255, 255, 255, 0.3)
                call DestroyEffect(e2)
                set u = null
                set g = null
                set g2 = null
                set e = null
                set e2 = null
                set c = null
                set td = null
                set u = null
                set m_TakeshiGW2[i] = m_TakeshiGW2[ MUI_TakeshiGW2]
                set MUI_TakeshiGW2 = MUI_TakeshiGW2 - 1
                if MUI_TakeshiGW2 == -1 then
                    call PauseTimer( t_TakeshiGW2)
                endif
                call deallocate(this)
            endif
            set i = i + 1
        endloop
    endmethod

    public static method TakeshiGW2_Start takes unit NewC, unit NewTd, integer NewCheck, real NewDmg returns nothing
        local thistype this = thistype.create( )
        set MUI_TakeshiGW2 = MUI_TakeshiGW2 + 1
        set m_TakeshiGW2[ MUI_TakeshiGW2] = this
        set c = NewC
        set r = 0
        set r2 = 0
        set td = NewTd
        set move = 120
        set r5 = 0
        set k2 = NewCheck
        set check = ModuloInteger(NewCheck, 2)
        set a2 = GetRandomReal(10, 60)
        if check != 0 then
            set a2 = -a2
        endif
        set a2 = a2 * bj_DEGTORAD
        set r5 = GetRandomReal(0, 359)
        set a = GAngle( c , td ) // Angle Between points
        set e = EffectSpawn4("war3mapImported\\wos_by_wood_dange_zhanji_daoguang_6_1.mdl", GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), a * bj_RADTODEG + GetRandomReal( -35, 35), 1, 1.25, 210, GetRandomReal( -60, 60))
        set e2 = EffectSpawn("war3mapImported\\wos_YC_CrossFlash.mdl" , GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), a * bj_RADTODEG + GetRandomReal( -35, 35), 2.5, 0.62, 210)
        set aoe = TakeshiGW_DamageAoe
        set dmg = NewDmg
        set rmax = 2.1
        set g = CreateGroup()
        set g2 = CreateGroup()
        set u = null
        if MUI_TakeshiGW2 == 0 then
            call TimerStart( t_TakeshiGW2, 0.03, true, function thistype.Loop_TakeshiGW2)
        endif
    endmethod

    private static method Loop_TakeshiGW takes nothing returns nothing
        local integer this
        local integer i = 0
        loop
            exitwhen i > MUI_TakeshiGW
            set this = m_TakeshiGW[i]
            if SpellBoolCaster(c) and r <= rmax and check < check2 then
                set r = r + 0.03
                call DebugUnit2(c)
                if r == 0.45 then
                    call MakeSound("war3mapimported\\Hero_Takeshi_GW3")
                    call SetUnitAnimationByIndex(c,17)
                    call StopSpellUnit(c)
                    call StartSpellUnit2(c)
                endif
                if r > 0.51 then
                    if r2 > 0.0 then
                        set r2 = 0
                        set check = check + 1
                        call .TakeshiGW2_Start(c, td, check, dmg)
                    else
                        set r2 = r2 + 0.03
                    endif
                endif
            else
                if TakeshiGW_Unit == null then
                    set TakeshiGW_Unit = CreateUnit(GetOwningPlayer(c), TakeshiGW_Unit_ID, GetRectCenterX(gg_rct_Caster), GetRectCenterY(gg_rct_Caster), 1)
                    call MyRemoveUnit(TakeshiGW_Unit, TakeshiGW_Time)
                    call MyFrame(c,TakeshiGW_Time,"BTNHero_Takeshi_GE",false,0)
                endif
                call DestroyEffect(e)
                call DestroyEffect(e2)
                call StopSpellUnit2(c)
                call SaveUnitHandle(hs, GetHandleId(c), StringHash("target"), td)
                call SetUnitTimeScale( c , 1)
                set c = null
                set td = null
                set e = null
                set e2 = null
                set u = null
                set m_TakeshiGW[i] = m_TakeshiGW[ MUI_TakeshiGW]
                set MUI_TakeshiGW = MUI_TakeshiGW - 1
                if MUI_TakeshiGW == -1 then
                    call PauseTimer( t_TakeshiGW)
                endif
                call deallocate(this)
            endif
            set i = i + 1
        endloop
    endmethod

    public static method TakeshiGW_Start takes unit NewC, unit NewTd returns nothing
        local thistype this = thistype.create( )
        set MUI_TakeshiGW = MUI_TakeshiGW + 1
        set m_TakeshiGW[ MUI_TakeshiGW] = this
        set c = NewC
        set r = 0
        set r2 = 0
        set td = NewTd
        set move = 120
        set r5 = 0
        set TakeshiGW_Unit = null
        call StartSpellUnit(c)
        set a = GAngle2( c , x , y ) // Angle Between points
        set dmg = GetHeroAgi( c , true) * TakeshiGW_DamageAgiBase
        if GetUnitAbilityLevel(c, TakeshiT_Buff_ID) > 0 then
            set dmg = dmg + GetHeroAgi(c, true) * TakeshiT_AddDmg
        endif
        set check2 = 14
        set check = 0
        set dmg = dmg / (check2-3)
        set rmax = 3.3
        call RemoveSavedHandle(hs, GetHandleId(c), StringHash("target"))
        call SetUnitAnimationByIndex(c, 16)
        call SetUnitTimeScale(c, 0.95)
        set e = AddSpecialEffectTarget("war3mapImported\\wos_Windwalk Blue Soul.mdl", c, "hand right")
        set e2 = AddSpecialEffectTarget("war3mapImported\\wos_Windwalk Blue Soul.mdl", c, "hand left")
        call MakeSound("war3mapimported\\Hero_Takeshi_GW")
        call MakeSound("war3mapimported\\Hero_Takeshi_GW2")
        if MUI_TakeshiGW == 0 then
            call TimerStart( t_TakeshiGW, 0.03, true, function thistype.Loop_TakeshiGW)
        endif
    endmethod

    private static method Loop_TakeshiGE2 takes nothing returns nothing
        local integer this
        local integer i = 0
        local real tilt = 0
        loop
            exitwhen i > MUI_TakeshiGE2
            set this = m_TakeshiGE2[i]
            if SpellBoolCaster(td) and r <= rmax then
                set r = r + 0.03
                if r < 0.6 then
                    set tilt = 35 * bj_DEGTORAD
                    if r < 0.45 then
                        set r7 = r7 + 22
                    else
                        set r7 = r7 - 12
                    endif
                    if r > 0.24 then
                        set x = x + r6 * Cos(a) * Cos(tilt)
                        set y = y + r6 * Sin(a) * Cos(tilt)
                        set r5 = r5 + r6 * Sin(tilt)
                    else
                        set r5 = r5 + r6 // С‡РёСЃС‚Рѕ РІРІРµСЂС…
                    endif
                    set r2 = r2 +8.5 * bj_DEGTORAD
                   
                    call BlzSetSpecialEffectPosition(e, x + r7 * Cos(r2), y + r7 * Sin(r2), r5)
                    call BlzSetSpecialEffectPosition(e2, x + r7 * Cos(r2), y + r7 * Sin(r2), r5)
                    call BlzSetSpecialEffectYaw(e, r2+90*bj_DEGTORAD)
                endif
                if r8 > - 270 then
                    set r8 = r8 - 13
                    call BlzSetSpecialEffectPitch(e, r8 * bj_DEGTORAD)
                endif
                if r > 0.6 then
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    if r7 > 100 then
                        set r5 = r5 - 70
                        call BlzSetSpecialEffectHeight(e, r5)
                    endif
                    if SR5(e, x, y) > 140 then
                        set a = GAngle5(e, x, y)
                        call MoveEff2(e, move, a + a2)
                        call MoveEff2(e2, move, a + a2)
                        if check != 0 then
                            call BlzSetSpecialEffectYaw(e, a + a2)
                        else
                            call BlzSetSpecialEffectYaw(e, a + a2)
                        endif
                        if r2 > 0 then
                            set r2 = 0
                            call GroupClear(g)
                            set x = GetEffX(e)
                            set y = GetEffY(e)
                            call VisionTimed(GetOwningPlayer(c), x, y, 400, 1)
                            call DecorRemove(c, x, y, aoe, 50)
                            call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
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
                        else
                            set r2 = r2 + 0.03
                        endif
                    else
                        set r = 9999
                    endif
                endif
            else
                call VisionTimed(GetOwningPlayer(c), x, y, 400, 1)
                call DecorRemove(c, x, y, aoe, 50)
                call GroupEnumUnitsInRange( g , x, y , aoe , NoDecor_Cond)
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
                call DestroyGroup(g)
                call DestroyGroup(g2)
                call ErzaPassive(c, td, 2)
                set x = GetUnitX(td)
                set y = GetUnitY(td)
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlash.mdl", x, y, GetRandomReal(0, 359), GetRandomReal(0.7, 1.1), GetRandomReal(1, 2), 55))
                call DestroyEffect(EffectSpawn3("war3mapImported\\wos_YC_Shockwave_b.mdl", x, y, GetRandomReal(0, 359), 1.25, 2, 205, -30))
                call DestroyEffect(EffectSpawn3("war3mapImported\\wos_slashbluekojiro.mdl", x, y, GetRandomReal(0, 359), 1.25, 2, 205, -30))
                call ColorEffDummy3(e, 0, 255, 255, 255, 0.12)
                call DestroyEffect(e2)
               // call MakeSound("war3mapimported\\Hero_Takeshi_GE3")
                set u = null
                set g = null
                set g2 = null
                set e = null
                set e2 = null
                set c = null
                set td = null
                set u = null
                set m_TakeshiGE2[i] = m_TakeshiGE2[ MUI_TakeshiGE2]
                set MUI_TakeshiGE2 = MUI_TakeshiGE2 - 1
                if MUI_TakeshiGE2 == -1 then
                    call PauseTimer( t_TakeshiGE2)
                endif
                call deallocate(this)
            endif
            set i = i + 1
        endloop
    endmethod

    public static method TakeshiGE2_Start takes unit NewC, unit NewTd, integer NewCheck, real NewDmg returns nothing
        local thistype this = thistype.create( )
        set MUI_TakeshiGE2 = MUI_TakeshiGE2 + 1
        set m_TakeshiGE2[ MUI_TakeshiGE2] = this
        set c = NewC
        set r = 0
        set td = NewTd
        set move = 90
        set x = GetUnitX(c)
        set y = GetUnitY(c)
        set r5 = GetRandomReal(50, 160)
        set r6 = GetRandomReal(10, 30)
        set k2 = NewCheck
        set check = ModuloInteger(NewCheck, 2)
        set a2 = GetRandomReal(5, 50)
        if check != 0 then
            set a2 = -a2
        endif
        set r2 = NewCheck * 25 * bj_DEGTORAD
        set a2 = a2 * bj_DEGTORAD
        set r7 = 225
        set r8 = -45
        set a = GAngle( c , td ) // Angle Between points
        //set e = EffectSpawn3("war3mapImported\\wos_takeshiswallow.mdl", GetUnitX(c) + r7 * Cos(r2), GetUnitY(c) + r7 * Sin(r2), a * bj_RADTODEG + GetRandomReal( -35, 35), 1, 2.35, r5, r8)
        set e = EffectSpawn3("war3mapImported\\wos_[DoFT]kojiroSpell.mdl", GetUnitX(c) + r7 * Cos(r2), GetUnitY(c) + r7 * Sin(r2), a * bj_RADTODEG + GetRandomReal( -35, 35), 2, 0.68, r5, r8)
        set e2 = EffectSpawn("war3mapImported\\wos_Windwalk Blue Soul.mdl" , GetUnitX(c) + r7 * Cos(r2), GetUnitY(c) + r7 * Sin(r2), a * bj_RADTODEG + GetRandomReal( -35, 35), 2.5, 0.75, r5)
        set aoe = TakeshiGE_DamageAoe
        set dmg = NewDmg
        set rmax = 2.1
        set g = CreateGroup()
        set g2 = CreateGroup()
        set u = null
        if MUI_TakeshiGE2 == 0 then
            call TimerStart( t_TakeshiGE2, 0.03, true, function thistype.Loop_TakeshiGE2)
        endif
    endmethod

    private static method Loop_TakeshiGE takes nothing returns nothing
        local integer this
        local integer i = 0
        loop
            exitwhen i > MUI_TakeshiGE
            set this = m_TakeshiGE[i]
            if SpellBoolCaster(c) and r <= rmax then
                set r = r + 0.03
                call DebugUnit(c)
                if r == 0.03 or r == 0.21 or r == 0.42 or r == 0.6 or r == 0.81 or r == 1.02 then
                    set x = GetUnitX(c)
                    set y = GetUnitY(c)
                    call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_bluemorphcircle3.mdl", x, y, GetRandomReal(0, 359), 1, 1.4, 1))
                endif
                if r == 0.66 then
                    call SetUnitAnimationByIndex(c, 25)
                    call NextSound("war3mapimported\\Hero_Takeshi_GE2", 0.6)
                    loop
                        exitwhen check == check2
                        call .TakeshiGE2_Start(c, td, check, dmg)
                        set check = check + 1
                    endloop
                endif
            else
                call DestroyEffect(e)
                call DestroyEffect(e2)
                call StopSpellUnit(c)
                call SetUnitTimeScale( c , 1)
                set c = null
                set td = null
                set e = null
                set e2 = null
                set u = null
                set m_TakeshiGE[i] = m_TakeshiGE[ MUI_TakeshiGE]
                set MUI_TakeshiGE = MUI_TakeshiGE - 1
                if MUI_TakeshiGE == -1 then
                    call PauseTimer( t_TakeshiGE)
                endif
                call deallocate(this)
            endif
            set i = i + 1
        endloop
    endmethod

    public static method TakeshiGE_Start takes unit NewC, unit NewTd returns nothing
        local thistype this = thistype.create( )
        set MUI_TakeshiGE = MUI_TakeshiGE + 1
        set m_TakeshiGE[ MUI_TakeshiGE] = this
        set c = NewC
        set r = 0
        set r2 = 0
        set td = NewTd
        set move = 120
        set r5 = 0
        call StartSpellUnit(c)
        set a = GAngle2( c , x , y ) // Angle Between points
        set dmg = GetHeroAgi( c , true) * TakeshiGE_DamageAgiBase
        if GetUnitAbilityLevel(c, TakeshiT_Buff_ID) > 0 then
            set dmg = dmg + GetHeroAgi(c, true) * TakeshiT_AddDmg
        endif
        set check2 = 14
        set check = 0
        set dmg = dmg / check2
        set rmax = 0.99
          //  call EffectSpawn2("war3mapImported\\wos_fj_w2.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 0.9, 1,1.2)
        call SetUnitAnimationByIndex(c, 23)
        call SetUnitTimeScale(c, 0.95)
        set e = AddSpecialEffectTarget("war3mapImported\\wos_Windwalk Blue Soul.mdl", c, "hand right")
        set e2 = AddSpecialEffectTarget("war3mapImported\\wos_Windwalk Blue Soul.mdl", c, "hand left")
        call MakeSound("war3mapimported\\Hero_Takeshi_GE")
        if MUI_TakeshiGE == 0 then
            call TimerStart( t_TakeshiGE, 0.03, true, function thistype.Loop_TakeshiGE)
        endif
    endmethod

    method AngleDifference takes real a, real b returns real
        local real diff = b - a
        if diff > bj_PI then
            set diff = diff - 2 * bj_PI
        elseif diff < - bj_PI then
            set diff = diff + 2 * bj_PI
        endif
        return diff
    endmethod

    private static method Loop_TakeshiGR takes nothing returns nothing
        local integer this
        local integer i = 0
        local real rkek = 0
        loop
            exitwhen i > MUI_TakeshiGR
            set this = m_TakeshiGR[i]
            if SpellBoolCaster(c) and r <= rmax then
                set r = r + 0.03
                if r > 0.5 then
                    call DebugUnit(c)
                else
                    call DebugUnit(c)
                endif
                if r == 0.5 then
                   // call UnitAddAbility(c,'Avul')
                    //call UnitRemoveAbility(c, 'Avul')
                endif
                if r < 0.45 then
                    if r5 < 175 then
                        set r5 = r5 + 6
                        call BlzSetSpecialEffectHeight(e2, r5)
                        call BlzSetSpecialEffectHeight(e3, r5 - 80)
                    endif
                    call MoveEff(e2, 25, a)
                    call MoveEff(e3, 25, a)
                endif
                if r == 0.45 then
                    call MouseOn(GetOwningPlayer(c))
                    set MouseX[GetPlayerId(GetOwningPlayer(c))] = GetUnitX(c) + 100 * Cos(a)
                    set MouseY[GetPlayerId(GetOwningPlayer(c))] = GetUnitY(c) + 100 * Sin(a)
                    set a2 = a
                    set x1 = MouseX[GetPlayerId(GetOwningPlayer(c))]
                    set y1 = MouseY[GetPlayerId(GetOwningPlayer(c))]
                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_tx-ha_nitu.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.25, 1, 255, 255, 255, 255))
                    set ee[0] = EffectSpawn("war3mapImported\\wos_water dash.mdl", GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), a * bj_RADTODEG, 1, 2, 0)
                    set ee[1] = EffectSpawn("war3mapImported\\wos_water dash.mdl", GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), a * bj_RADTODEG, 1, 2, 155)
                    call BlzSetSpecialEffectPitch(ee[1], 8 * bj_DEGTORAD)
                    call BlzSetSpecialEffectRoll(ee[1], -90 * bj_DEGTORAD)
                    set ee[2] = EffectSpawn("war3mapImported\\wos_water dash.mdl", GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), a * bj_RADTODEG, 1, 2, 155)
                    call BlzSetSpecialEffectPitch(ee[2], 8 * bj_DEGTORAD)
                    call BlzSetSpecialEffectRoll(ee[2], -270 * bj_DEGTORAD)
                    set ee[3] = EffectSpawn("war3mapImported\\wos_water dash.mdl", GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), a * bj_RADTODEG, 1, 2, 315)
                    call BlzSetSpecialEffectPitch(ee[3], 15 * bj_DEGTORAD)
                    call BlzSetSpecialEffectRoll(ee[3], -90 * bj_DEGTORAD)
                    set ee[4] = EffectSpawn("war3mapImported\\wos_water dash.mdl", GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), a * bj_RADTODEG, 1, 2, 315)
                    call BlzSetSpecialEffectPitch(ee[4], 15 * bj_DEGTORAD)
                    call BlzSetSpecialEffectRoll(ee[4], -270 * bj_DEGTORAD)
                    call MakeSound("war3mapimported\\Hero_Takeshi_R3")
                    set k = 0
                    loop
                        exitwhen k > 4
                        call ColorEffDummy4(ee[k], 0, 255, 255, 255, 0.21)
                        if k > 2 then
                            call ScaleEffDummy(ee[k], 0.3, 1, 2.4)
                        else
                            call ScaleEffDummy(ee[k], 0.3, 1, 2.1)
                        endif
                        set k = k + 1
                    endloop
                endif
                if r > 0.6 then
                    if r == 0.75 then
                        call SetUnitTimeScale(c, 0.1)
                    endif
                    if move < 65 then
                        set move = move + 1
                    endif
                    if GetMouseX(GetOwningPlayer(c)) != x1 then
                        set x1 = MouseX[GetPlayerId(GetOwningPlayer(c))]
                        set y1 = MouseY[GetPlayerId(GetOwningPlayer(c))]
                        set a2 = GAngle2(c, x1, y1)
                    endif
                    set a = a + AngleDifference(a, a2) * 0.15
                    call MoveUnit(c, move, a)
                    set k = 0
                    loop
                        exitwhen k > 4
                        call BlzSetSpecialEffectPosition(ee[k], GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), BlzGetLocalSpecialEffectZ(ee[k]))
                        call BlzSetSpecialEffectYaw(ee[k], a)
                        set k = k + 1
                    endloop
                    call SetUnitFacing(c, a * bj_RADTODEG)
                    call BlzSetSpecialEffectPosition(e2, GetUnitX(c) + 345 * Cos(a), GetUnitY(c) + 345 * Sin(a), BlzGetLocalSpecialEffectZ(e2))
                    call BlzSetSpecialEffectPosition(e3, GetUnitX(c) + 345 * Cos(a), GetUnitY(c) + 345 * Sin(a), BlzGetLocalSpecialEffectZ(e3))
                    call BlzSetSpecialEffectYaw(e2, a)
                    call BlzSetSpecialEffectYaw(e3, a)
                    if r2 > 0.03 then
                        set r2 = 0
                        set rkek = 0.3
                        call EffectSpawn2("war3mapImported\\wos_water dash.mdl", GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), a * bj_RADTODEG, 1, 2, 0, rkek)
                        set e4 = EffectSpawn2("war3mapImported\\wos_water dash.mdl", GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), a * bj_RADTODEG, 1, 2, 155, rkek)
                        call BlzSetSpecialEffectPitch(e4, 8 * bj_DEGTORAD)
                        call BlzSetSpecialEffectRoll(e4, -90 * bj_DEGTORAD)
                        set e4 = EffectSpawn2("war3mapImported\\wos_water dash.mdl", GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), a * bj_RADTODEG, 1, 2, 155, rkek)
                        call BlzSetSpecialEffectPitch(e4, 8 * bj_DEGTORAD)
                        call BlzSetSpecialEffectRoll(e4, -270 * bj_DEGTORAD)
                        set e4 = EffectSpawn2("war3mapImported\\wos_water dash.mdl", GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), a * bj_RADTODEG, 1, 2, 315, rkek)
                        call BlzSetSpecialEffectPitch(e4, 15 * bj_DEGTORAD)
                        call BlzSetSpecialEffectRoll(e4, -90 * bj_DEGTORAD)
                        set e4 = EffectSpawn2("war3mapImported\\wos_water dash.mdl", GetUnitX(c) - 165 * Cos(a), GetUnitY(c) - 165 * Sin(a), a * bj_RADTODEG, 1, 2, 315, rkek)
                        call BlzSetSpecialEffectPitch(e4, 15 * bj_DEGTORAD)
                        call BlzSetSpecialEffectRoll(e4, -270 * bj_DEGTORAD)
                    else
                        set r2 = r2 + 0.03
                    endif
                    if r3 > 0.03 then
                        set r3 = 0
                        call DecorRemove(c, GetUnitX(c), GetUnitY(c), aoe, 100)
                        call GroupEnumUnitsInRange( g , GetUnitX(c), GetUnitY(c) , aoe , NoDecor_Cond)
                        loop
                            set u = FirstOfGroup( g )
                            exitwhen u == null
                            if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup(u, g2) == false then
                                call dmgmag(c, u, dmg)
                                set x = GetUnitX(u)
                                set y = GetUnitY(u)
                                call ErzaPassive(c, u, 2)
                                call StunUnit(c, u, TakeshiGR_Stun)
                                call GroupAddUnit(g2, u)
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_shockwave_b.mdl", x, y, 1, 1, 2.75, 125))
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_waterexplosion.mdl", x, y, 1, 2.5, 3, 1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_2-[tx]-03-03jianta (3)_1.mdl", x, y, 1, 2, 2.5, 1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_YC_CrossFlash.mdl" , x + 25 * Cos(a), y + 25 * Sin(a), 1, 1., 1.975, 125))
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                            endif
                            call GroupRemoveUnit( g , u )
                        endloop
                        set u = null
                    else
                        set r3 = r3 + 0.03
                    endif
                endif
            else
                if r > 0.45 then
                    set k = 0
                    loop
                        exitwhen k > 4
                        call MyRemoveEff(ee[k], 0.15)
                        set ee[k] = null
                        set k = k + 1
                    endloop
                endif
                call MouseOff(GetOwningPlayer(c))
                call MakeSound("war3mapimported\\Hero_Takeshi_GR2")
                call DestroyEffect(e3)
                call ColorEffDummy3(e2, 0, 255, 255, 255, 0.15)
                call StopSpellUnit(c)
                call SetUnitTimeScale( c , 1)
                call DestroyEffect(e)
                call DestroyGroup( g )
                call DestroyGroup( g2 )
                set g = null
                set g2 = null
                set c = null
                set e = null
                set e2 = null
                set e3 = null
                set e4 = null
                set u = null
                set m_TakeshiGR[i] = m_TakeshiGR[ MUI_TakeshiGR]
                set MUI_TakeshiGR = MUI_TakeshiGR - 1
                if MUI_TakeshiGR == -1 then
                    call PauseTimer( t_TakeshiGR)
                endif
                call deallocate(this)
            endif
            set i = i + 1
        endloop
    endmethod

    public static method TakeshiGR_Start takes unit NewC returns nothing
        local thistype this = thistype.create( )
        set MUI_TakeshiGR = MUI_TakeshiGR + 1
        set m_TakeshiGR[ MUI_TakeshiGR] = this
        set c = NewC
        set r = 0
        set r2 = 0
        set move = 15
        set r6 = 0
        call StartSpellUnit(c)
        set g = CreateGroup()
        set g2 = CreateGroup()
        set u = null
        set r5 = 125
        set u = null
        set check2 = 0
        set a = GetUnitFacing(c) * bj_DEGTORAD // Angle Between points
        set aoe = TakeshiGR_DamageAoe
        set dmg = GetHeroAgi( c , true) * TakeshiGR_DamageAgiBase
        set rmax = 3
        if GetUnitAbilityLevel(c, TakeshiT_Buff_ID) > 0 then
            set dmg = dmg + GetHeroAgi(c, true) * TakeshiT_AddDmg
        endif
        call SetUnitAnimationByIndex(c, 8)
        call SetUnitTimeScale(c, 0.4)
        set e = AddSpecialEffectTarget("war3mapImported\\wos_Windwalk Blue Soul.mdl", c, "hand right")
        call MakeSound("war3mapimported\\Hero_Takeshi_GR")
        set e2 = EffectSpawn("war3mapImported\\wos_takeshiswallow.mdl", GetUnitX(c) + 35 * Cos(a), GetUnitY(c) + 35 * Sin(a), a * bj_RADTODEG, 1, 2.25, r5)
        set e3 = EffectSpawn("war3mapImported\\wos_Windwalk Blue Soul.mdl", GetUnitX(c) + 35 * Cos(a), GetUnitY(c) + 35 * Sin(a), a * bj_RADTODEG, 1, 1.5, r5 - 80)
        if MUI_TakeshiGR == 0 then
            call TimerStart( t_TakeshiGR, 0.03, true, function thistype.Loop_TakeshiGR)
        endif
    endmethod

    private static method Loop_TakeshiGF takes nothing returns nothing
        local integer this
        local integer i = 0
        loop
            exitwhen i > MUI_TakeshiGF
            set this = m_TakeshiGF[i]
            if SpellBoolCaster(c) and r <= rmax then
                set r = r + 0.03
                call DebugUnit2(c)
                if check == 0 then
                    if SR2(c, td) > 145 then
                        set a = GAngle(c, td)
                        call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
                        call MoveUnit(c, move, a)
                        if r2 > 0.06 then
                            set r2 = 0
                            set x1 = GetUnitX(c)
                            set y1 = GetUnitY(c)
                            call EffectSpawn2("war3mapImported\\wos_Bubbles2.mdx", x1 , y1, GetRandomReal(0, 359), 1, 6, GetRandomReal(50, 150), 0.15)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x1 + 100 * Cos(a), y1 + 100 * Sin(a), a * bj_RADTODEG, 0.5, 1.75, 75))
                        else
                            set r2 = r2 + 0.03
                        endif
                    else
                        set check = 1
                        set r = 0
                        set rmax = 0.15
                        call SetUnitAnimationByIndex(c, 9)
                        call StartSpellUnit2(c)
                        call DebugUnit2(td)
                    endif
                elseif check == 1 then
                    call DebugUnit2(td)
                    if r == 0.15 then
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_gnaden_air.mdl", x, y, GetRandomReal(0, 359), 0.4, 1.5, 1, 255, 255, 255, 205))
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_gnaden_air.mdl", x, y, GetRandomReal(0, 359), 0.3, 2.5, 1, 255, 255, 255, 205))
                        call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_gnaden_air.mdl", x, y, GetRandomReal(0, 359), 0.2, 3.5, 1, 255, 255, 255, 205))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_shockwave_b.mdl", x, y, 1, 0.8, 2, 175))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_yc_bluemorphcircle2.mdl", x, y, GetRandomReal(0, 359), 1, 1.4, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_1mt_shui1.mdl", GetUnitX(c) + 0 * Cos(a), GetUnitY(c) + 0 * Sin(a), a * bj_RADTODEG, 1, 2.25, 150))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_2-[tx]-03-03jianta (3)_1.mdl", x, y, 1, 2, 1, 1))
                        call dmgphys(c, td, dmg)
                        call ErzaPassive(c, td, 2)
                        call RootUnit(c, td, TakeshiGF_Root)
                        call MakeSound("war3mapimported\\Hero_Takeshi_GR2")
                        set r = 9999
                    endif
                endif
            else
                call StopSpellUnit2(td)
                call StopSpellUnit2(c)
                call DestroyEffect(e)
                set c = null
                set td = null
                set e = null
                set m_TakeshiGF[i] = m_TakeshiGF[ MUI_TakeshiGF]
                set MUI_TakeshiGF = MUI_TakeshiGF - 1
                if MUI_TakeshiGF == -1 then
                    call PauseTimer( t_TakeshiGF)
                endif
                call deallocate(this)
            endif
            set i = i + 1
        endloop
    endmethod

    public static method TakeshiGF_Start takes unit NewC, unit NewTd returns nothing
        local thistype this = thistype.create( )
        set MUI_TakeshiGF = MUI_TakeshiGF + 1
        set m_TakeshiGF[ MUI_TakeshiGF] = this
        set c = NewC
        set td = NewTd
        set r = 0
        set r2 = 0
        set move = 70
        set r5 = 0
        set check = 0
        call StartSpellUnit2(c)
        set a = GAngle( c , td ) // Angle Between points
        set dmg = GetHeroAgi( c , true) * TakeshiGF_DamageAgiBase
        if GetUnitAbilityLevel(c, TakeshiT_Buff_ID) > 0 then
            set dmg = dmg + GetHeroAgi(c, true) * TakeshiT_AddDmg
        endif
        set rmax = 1.5
        call SetUnitAnimationByIndex(c, 16)
        call SetUnitTimeScale(c, 1.95)
        set e = AddSpecialEffectTarget("war3mapImported\\wos_Windwalk Blue Soul.mdx", c, "hand right")
        call MakeSound("war3mapimported\\Hero_Takeshi_GF")
        if MUI_TakeshiGF == 0 then
            call TimerStart( t_TakeshiGF, 0.03, true, function thistype.Loop_TakeshiGF)
        endif
    endmethod

    endstruct

    //----------------------------Takeshi-----------------------------------------------
 /* Animations index:
    
0 - stand
1 - stand ready
2 - fast slash up to down
3 - E atk
4 - razvorot atk , mb samidare
5 - shibuki ame
6 - stand ready for samidare
7 - samidare from 6
8 - razvorot s drugoi
10 - morph or W
11 - move
13 - sakamaku
15 - multi strike
    
morph:
4 - stand
5 - stand ready РІР·РјР°С… РІ СЃС‚РѕСЂРѕРЅС‹ РјРµС‡Р°РјРё
6 - move
8 - stan ready
9 - right slash
10 - left slash
11 - double slash
12 - pierce double R
14 - akt in air
15 - brosil mech
16 - stand ebalo
17 - W
19 - vznah 2 mechami v vozduh
20 - E start
21 - E release
24 - jinouka jump
25 - strike from jinouka
28 - double sword
39 - Q prepare
40 - q start
    
 */ 
     
    
function TakeshiQ_Start takes unit c, real x, real y returns nothing
    call TakeshiSpells_Q.TakeshiQ_Start( c, x, y )
endfunction
function TakeshiQ2_Start takes unit c, real x, real y returns nothing
    call TakeshiSpells_Q.TakeshiQ2_Start( c, x, y )
    //call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(TakeshiQ2_ID)),0)
endfunction
function TakeshiQ3_Start takes unit c returns nothing
    call BuffUnit1(c, c, 6)
   // call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(TakeshiQ2_ID)),1)
endfunction
function TakeshiQ3_Act takes unit c, unit td returns nothing
    call TakeshiSpells_Q.TakeshiQ3_Start( c, td )
endfunction
function TakeshiW_Start takes unit c, real x, real y returns nothing
    call TakeshiSpells_W.TakeshiW_Start( c, x, y )
endfunction
function TakeshiW2_Start takes unit c returns nothing
    call BuffUnit1(c, c, 7)
endfunction
function TakeshiW2_Act takes unit c, unit td returns nothing
    call TakeshiSpells_W.TakeshiW2_Start( c, td )
endfunction
function TakeshiE_Start takes unit c, real x, real y returns nothing
    call TakeshiSpells_E.TakeshiE_Start( c, x, y )
endfunction
function TakeshiE2_Start takes unit c, unit td returns nothing
    call CurseUnit(c, td, 3)
    call MakeSound("war3mapimported\\Hero_Takeshi_FE")
    call NextSound("war3mapimported\\Hero_Takeshi_FE2", 0.75)
    call NextSound("war3mapimported\\Hero_Takeshi_FE3", 1.12)
    call MyFrameBuff2(td, TakeshiE2_Buff_ID, TakeshiE2_Duration, "BTNHero_Takeshi_E2", true, GetPlayerId(GetOwningPlayer(c)))
endfunction
function TakeshiE2_Act takes unit c, unit td returns nothing
    local real a = GAngle(c, td)
    local integer i = GetRandomInt(1, 2)
    local real r1 = GetRandomReal(80, 180)
    local real r2 = 0
    if i == 1 then
        set r2 = -90
    else
        set r2 = 90
    endif
    call BlinkEff(c)
    call BlinkEff2(c)
    call MoveUnit(c, r1, a + r2 * bj_DEGTORAD)
    call BlinkEff(c)
endfunction
function TakeshiR_Start takes unit c, unit td returns nothing
    call TakeshiSpells_R.TakeshiR_Start( c, td )
endfunction
function TakeshiR2_Start takes unit c returns nothing
    call TakeshiSpells_R.TakeshiR2_Start( c )
endfunction
function TakeshiT_Start takes unit c, real x, real y returns nothing
    call TakeshiSpells_T.TakeshiT_Start( c, x, y )
endfunction
function TakeshiF_Start takes unit c returns nothing
    local player p = GetOwningPlayer(c)
    if LoadInteger(hs, GetHandleId(p), StringHash("style")) == 0 then
  //  call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(TakeshiQ2_ID)),0)
        call SaveInteger(hs, GetHandleId(p), StringHash("style"), 1)
        call SetPlayerAbilityAvailable(p, TakeshiQ_ID, false)
        call SetPlayerAbilityAvailable(p, TakeshiW_ID, false)
        call SetPlayerAbilityAvailable(p, TakeshiE_ID, false)
        call SetPlayerAbilityAvailable(p, TakeshiR_ID, false)
        call SetPlayerAbilityAvailable(p, TakeshiQ2_ID, true)
        call SetPlayerAbilityAvailable(p, TakeshiW2_ID, true)
        call SetPlayerAbilityAvailable(p, TakeshiE2_ID, true)
        call SetPlayerAbilityAvailable(p, TakeshiR2_ID, true)
        call SetUnitAbilityLevel(c, TakeshiF_ID, 2)
        call UnitAddAbility(c, TakeshiQ2_ID)
        call UnitAddAbility(c, TakeshiW2_ID)
        if GetUnitAbilityLevel(c, TakeshiE_ID) > 0 then
            call UnitAddAbility(c, TakeshiE2_ID)
        endif
        if GetUnitAbilityLevel(c, TakeshiR_ID) > 0 then
            call UnitAddAbility(c, TakeshiR2_ID)
        endif
        call SetUnitAbilityLevel(c, TakeshiQ2_ID, GetUnitAbilityLevel(c, TakeshiQ_ID))
        call SetUnitAbilityLevel(c, TakeshiW2_ID, GetUnitAbilityLevel(c, TakeshiW_ID))
        if GetUnitAbilityLevel(c, TakeshiE2_ID) > 0 then
            call SetUnitAbilityLevel(c, TakeshiE2_ID, GetUnitAbilityLevel(c, TakeshiE_ID))
        endif
        if GetUnitAbilityLevel(c, TakeshiR2_ID) > 0 then
            call SetUnitAbilityLevel(c, TakeshiR2_ID, GetUnitAbilityLevel(c, TakeshiR_ID))
        endif
    else
        call SetUnitAbilityLevel(c, TakeshiF_ID, 1)
        call SetPlayerAbilityAvailable(p, TakeshiQ2_ID, false)
        call SetPlayerAbilityAvailable(p, TakeshiQ3_ID, false)
        call SetPlayerAbilityAvailable(p, TakeshiW2_ID, false)
        call SetPlayerAbilityAvailable(p, TakeshiE2_ID, false)
        call SetPlayerAbilityAvailable(p, TakeshiR2_ID, false)
        call SetPlayerAbilityAvailable(p, TakeshiQ_ID, true)
        call SetPlayerAbilityAvailable(p, TakeshiW_ID, true)
        call SetPlayerAbilityAvailable(p, TakeshiE_ID, true)
        call SetPlayerAbilityAvailable(p, TakeshiR_ID, true)
        call SaveInteger(hs, GetHandleId(p), StringHash("style"), 0)
    endif
    set p = null
endfunction

function TakeshiGOff_Start takes unit c returns nothing 
local integer k2 = GetPlayerId(GetOwningPlayer(c))
local real dmg2 = 0
local real rmax = TakeshiG_TakenDamageToEnter
if frameTakeshi_pas1 [k2] != null then
                call SaveReal(hs,GetHandleId(c),StringHash("takeshi dmg"),dmg2)
                call BlzFrameSetText(frameTakeshi_pas6 [k2], "|c00FFFF00" +I2S(R2I(dmg2))+"/"+I2S(R2I(rmax))+ "|r")
                call BlzFrameSetValue(frameTakeshi_pas3[k2],dmg2 )
                endif
                if TakeshiDummy != null then 
                call RemoveUnit(TakeshiDummy)
                set TakeshiDummy = null
                endif
endfunction

function TakeshiG_Start takes unit c returns nothing
    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(TakeshiQ2_ID)),1)
    call TakeshiSpells_G.TakeshiG_Start( c )
    call TakeshiGOff_Start(c)
endfunction
function TakeshiGQ_Start takes unit c, real x, real y returns nothing
    call TakeshiSpells_G.TakeshiGQ_Start( c, x, y )
endfunction
function TakeshiGW_Start takes unit c, unit td returns nothing
    call TakeshiSpells_G.TakeshiGW_Start( c, td )
endfunction
function TakeshiGE_Start takes unit c returns nothing
    call TakeshiSpells_G.TakeshiGE_Start( c, LoadUnitHandle(hs, GetHandleId(c), StringHash("target")) )
endfunction
function TakeshiGR_Start takes unit c returns nothing
    call TakeshiSpells_G.TakeshiGR_Start( c )
endfunction
function TakeshiGF_Start takes unit c, unit td returns nothing
    call TakeshiSpells_G.TakeshiGF_Start( c, td )
endfunction
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
