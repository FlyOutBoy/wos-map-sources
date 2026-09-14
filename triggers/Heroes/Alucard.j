library AlucardSpells uses GearSystems
    globals
//--------------------------------------Alucard--------------------------------------------------------------
        integer Alucard_ID = 'H01Z'        
        integer Alucard_Morph_ID = 'H020'
        unit array Alucard_12Dummy 
//---------------F ability-----------------------------------------------------
        integer AlucardF_ID = 'A0C8'
        integer AlucardF_IdDummy = 'h0CO'//'h0CO'
        integer AlucardF_AdditionalMoveSpeed_ID = 'A0CA' // id of ability that add MS change bonus in object editor
        real AlucardF_MSBonusAngleCap = 45// how much more or less angle will still give MS bonus when runs toward target, best values from 15 to 45
        real AlucardF_VisionAoe = 700
        real AlucardF_VisionTime = 10 // how much time vision live
        real AlucardF_Cooldown = 10 // after end of vision time how much seconds it will not trigger again       
//---------------G ability-----------------------------------------------------
        integer AlucardG_ID = 'A0C9'
        integer AlucardG_Stat_ID = 'A0CB'
        real AlucardG_HpCond1 = 75 // give immun to slow after hp lower or equal of this amount
        real AlucardG_HpCond2 = 50 // give immun to attacks (can be pierced) after hp lower or equal of this amount
        real AlucardG_HpCond3 = 25 // give immun to debuffs after hp lower or equal of this amount
//---------------Q ability-----------------------------------------------------
        integer AlucardQ_ID = 'A0C0'
        integer AlucardQ2_ID = 'A0C1'
        real AlucardQ_DamageAgiBase = 1.5 // base number x Int damage for 1 level
        real AlucardQ_DamageAgiStep = 1 // additional number x Int damage for each next level
        real AlucardQ_Damage2StaticBase = 175 // base static damage for 1 level
        real AlucardQ_Damage2StaticStep = 0 // additional static damage for each next level
        real AlucardQ2_DamageAgiBase = 1 // base number x Int damage for 1 level
        real AlucardQ2_DamageAgiStep = 0.5 // additional number x Int damage for each next level
        real AlucardQ2_Damage2StaticBase = 150 // base static damage for 1 level
        real AlucardQ2_Damage2StaticStep = 0 // additional static damage for each next level
        real AlucardQ_DamageAoe = 215 // bullet aoe
        real AlucardQ_RangeBase = 1300
        real AlucardQ_RangeStep = 100
        real AlucardQ_TimeBeforeQ2Expire = 3 // in seconds , how much time alucard have to cast q2 after succefull q
        real AlucardQ2_StunTime = 1 // in seconds , stun time
        real AlucardRQ_Range = 1600
        real AlucardRQ_HpToAddDamageCondition = 50 // in % , under which percentage of hp alucard will deal more damage
        real AlucardRQ_AddDamageFromMissedHp = 10 // in % additional damage from enemy missed hp
        real AlucardRQ_DamageAoe = 400 // wave aoe
//---------------W ability-----------------------------------------------------
        integer AlucardW_ID = 'A0C2'
        integer AlucardW2_ID = 'A0C3'
        integer AlucardW_Buff_ID = 'B01D'
        real AlucardW_Damage2StaticBase = 150 // base static damage for 1 level
        real AlucardW_Damage2StaticStep = 0 // additional static damage for each next level
        real AlucardW_DamageAgiBase = 1 // base number x Str damage for 1 level
        real AlucardW_DamageAgiStep = 1 // additional number x Str damage for each next level
        real AlucardW_DamageImmuneDuration = 3 // in seconds, 3 = 3 sec, also can be 3.5..... 4.1 ...... 5.. and any other number, but not lower than 0.5
        real AlucardW_SelfHealAgiBase = 2 //x agi
        real AlucardW_SelfHealAgiStep = 0.25 //x agi
        real AlucardRW_DamageAgiBase = 5 // base number x Str damage for 1 level
        real AlucardRW_DamageAgiStep = 1 // additional number x Str damage for each next level
        real AlucardRW_Duration = 2.5 // in seconds, 3 = 3 sec, also can be 3.5..... 4.1 ...... 5.. and any other number, but not lower than 0.5
        real AlucardRW_Speed = 1100 // how fast for a second alucard can move in blood pool state
        real AlucardRW_DamageAoe = 725 // blood pool aoe        
//---------------E ability-----------------------------------------------------
        integer AlucardE_ID = 'A0C4'
        real AlucardE_DamageAgiBase = 2 // base number x Str damage for 1 level
        real AlucardE_DamageAgiStep = 1 // additional number x Str damage for each next level
        real AlucardRE_DamageAgiIncrease = 1 // increased str dmg in Morph 
        real AlucardE_DamageStatic = 00 // static damage for all lvls
        real AlucardE_DamageAoe = 235 // for both variants of e
        real AlucardE_RangeBase = 1600
        real AlucardE_RangeStep = 100
        integer AlucardE_Slow = 40 // in % , 40 = 40% slow ms as
        integer AlucardE_Duration = 3 // from 2 to 4, 2..3...4
//---------------R ability-----------------------------------------------------
        integer AlucardR_ID = 'A0C5'
        real AlucardR_HpCostBase = 0 // 25 = 25% of current hp
        real AlucardR_HpCostStep = 0 // 25 = 25% of current hp
        real AlucardR_DurationBase = 10 // duration of morph
        real AlucardR_DurationStep = 2 // duration of morph
        integer AlucardR_Armor = 'A0HD'
//---------------T ability-----------------------------------------------------
        integer AlucardT_ID = 'A0C6'
        integer AlucardT2_ID = 'A0C7'
        integer AlucardT_Buff_ID = 'B01E'
        integer AlucardT2_Buff_ID = 'B01F'
        real AlucardT2_DamageAgiBase = 10 // base number x Str 
        real AlucardT2_DamageAoe = 675 // base aoe
        real AlucardT2_DamageAoeStep = 300 // increase aoe each time (8 times)
        real AlucardT2_Range = 1800
        real AlucardT2_HpCost = 10 // 25 = 25% of current hp
        real AlucardT2_PercentageCrumwell = 50 // how much in % he will gain bonuses from default T, like additional damage to target and damage resistance, 25 = 25% of normal T value
        real AlucardT_AdditionalDamageToTarget = 20 // in % how much any damage would be increased to target of spell
        real AlucardT_HpToHealCondition = 100 // in % , under which percentage of hp alucard will get heal from kill enemy
        real AlucardT_Heal = 20 // in %, how much hp restored if kill T target under AlucardT_HpToHealCondition hp condition
        real AlucardT2_Heal = 10 // in %, how much hp restored if kill T target under AlucardT_HpToHealCondition hp condition
        real AlucardT_Duration = 8 // duration of spell
//------------------------------------------------------------------------------
    endglobals
    private struct AlucardSpells_Utility
        private static timer t_AlucardPas = CreateTimer()
        private static integer array m_AlucardPas
        private static integer MUI_AlucardPas = -1
        private static timer t_AlucardPas2 = CreateTimer()
        private static integer array m_AlucardPas2
        private static integer MUI_AlucardPas2 = -1
        unit c
        unit td
        real x
        real y
        real x1
        real y1
        fogmodifier fg
        group g2
        real a2
        integer check2
        real r
        effect e
        effect e2
        effect e3
        real a
        real rmax

        private static method Loop_AlucardPas takes nothing returns nothing
            local integer this
            local integer i = 0
            local integer h
            local integer sh
            loop
                exitwhen i > MUI_AlucardPas
                set this = m_AlucardPas[i]
                if SpellBoolCaster(c) and SpellBoolCaster(td) and r < rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(td), GetUnitY(td)) == false then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    set a = GAngle(c, td) * bj_RADTODEG
                    set a2 = (GetUnitFacing(c) - a)
                    if a2 < 0 then
                        set a2 = -a2
                    endif
                    if a2 > 180.0 then
                        set a2 = 360.0 - a2
                    endif
                    if a2 <= AlucardF_MSBonusAngleCap then
                        if GetUnitAbilityLevel(c, AlucardF_AdditionalMoveSpeed_ID) == 0 then
                            call UnitAddAbility(c, AlucardF_AdditionalMoveSpeed_ID)
                            call AddSpellLevel(c,'A01C',10,true)
                        endif
                    else
                        if GetUnitAbilityLevel(c, AlucardF_AdditionalMoveSpeed_ID) > 0 then
                            call AddSpellLevel(c,'A01C',10,false)
                            call UnitRemoveAbility(c, AlucardF_AdditionalMoveSpeed_ID)
                        endif
                    endif
                    if SR0(x, y, x1, y1) > AlucardF_VisionAoe / 6 then
                        set x1 = x
                        set y1 = y
                        call DestroyFogModifier(fg)
                        set fg = null
                        set fg = CreateFogModifierRadius(GetOwningPlayer(c), FOG_OF_WAR_VISIBLE, x, y, AlucardF_VisionAoe, false, false)
                        call FogModifierStart(fg)
                    endif
                    call EffVision(e, td)
                    call BlzSetSpecialEffectPosition(e, x, y, GetUnitFlyHeight(td) + 195)
                    call FogModifierStart(fg)
                else
                    call SaveInteger(hs, GetHandleId(td) , StringHash("Alucard pas"), 0)
                        if GetUnitAbilityLevel(c, AlucardF_AdditionalMoveSpeed_ID) > 0 then
                            call AddSpellLevel(c,'A01C',10,false)
                            call UnitRemoveAbility(c, AlucardF_AdditionalMoveSpeed_ID)
                        endif
                        call FakeCD_Start(c,AlucardF_ID,10,0,0)
                    call DestroyEffect(e)
                    call DestroyFogModifier(fg)
                    call MyFlush(GetHandleId(c) , StringHash("Alucard pas vision"), 0, AlucardF_Cooldown)
                    set c = null
                    set td = null
                    set fg = null
                    set e = null
                    set e2 = null
                    set m_AlucardPas[i] = m_AlucardPas[ MUI_AlucardPas]
                    set MUI_AlucardPas = MUI_AlucardPas - 1
                    if MUI_AlucardPas == -1 then
                        call PauseTimer( t_AlucardPas)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AlucardPas_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_AlucardPas = MUI_AlucardPas + 1
            set m_AlucardPas[ MUI_AlucardPas] = this
            set c = NewC
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set x1 = x
            set y1 = y
            set rmax = AlucardF_VisionTime
            set fg = CreateFogModifierRadius(GetOwningPlayer(c), FOG_OF_WAR_VISIBLE, x, y, AlucardF_VisionAoe, false, false)
            set e = EffectSpawn("war3mapImported\\wos_alucard_eye.mdl", x, y, 1, 0.5, 2, 195)
            call FogModifierStart(fg)
            call SaveInteger(hs, GetHandleId(c) , StringHash("Alucard pas vision"), 1)
            call SaveInteger(hs, GetHandleId(td) , StringHash("Alucard pas"), 1)
            set r = 0
            if MUI_AlucardPas == 0 then
                call TimerStart( t_AlucardPas, 0.03, true, function thistype.Loop_AlucardPas)
            endif
        endmethod

        private static method Loop_AlucardPas2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AlucardPas2
                set this = m_AlucardPas2[i]
                if Hero[check2] == c  then
                if IsUnitType(c,UNIT_TYPE_DEAD) == false then 
                    if LoadInteger(hs,GetHandleId(c),StringHash("reset sfx")) == 1 then 
                    call SaveInteger(hs,GetHandleId(c),StringHash("reset sfx"),0)
                    if e != null then 
                    call DestroyEffect(e)
                    call SaveInteger(hs,GetHandleId(c),StringHash("alucard g1"),0)
                    set e = null
                    endif
                    if e2 != null then 
                    call DestroyEffect(e2)
                    call SaveInteger(hs,GetHandleId(c),StringHash("alucard g2"),0)
                    set e2 = null
                    endif
                    if e3 != null then 
                    call DestroyEffect(e3)
                    call SaveInteger(hs,GetHandleId(c),StringHash("alucard g3"),0)
                    set e3 = null
                    endif
                    endif
                    if GetUnitState(c,UNIT_STATE_LIFE) <= (AlucardG_HpCond1/100)*GetUnitState(c,UNIT_STATE_MAX_LIFE) then
                    if e == null then
                    set e = AddSpecialEffectTarget("war3mapImported\\wos_redauraAi0.mdl",c,"origin")
                    call SaveInteger(hs,GetHandleId(c),StringHash("alucard g1"),1)
                    call UnitAddAbility(c,AlucardG_Stat_ID)
                    if LoadInteger(hs,GetHandleId(c),StringHash("sound1 cd")) == 0 then 
                     call MakeSound("war3mapimported\\Hero_Alucard_G1")
                     call SaveInteger(hs,GetHandleId(c),StringHash("sound1 cd"),1)
                     call MyFlush(GetHandleId(c),StringHash("sound1 cd"),0,60)
                    endif
                    endif
                    elseif e != null then
                    call UnitRemoveAbility(c,AlucardG_Stat_ID)
                    call SaveInteger(hs,GetHandleId(c),StringHash("alucard g1"),0)
                    call DestroyEffect(e)
                    set e = null
                    endif
                    if GetUnitState(c,UNIT_STATE_LIFE) <= (AlucardG_HpCond2/100)*GetUnitState(c,UNIT_STATE_MAX_LIFE) then 
                    if e2 == null then
                    set e2 = AddSpecialEffectTarget("war3mapImported\\wos_model (471)2a.mdl",c,"origin")
                    call SaveInteger(hs,GetHandleId(c),StringHash("alucard g2"),1)
                    if LoadInteger(hs,GetHandleId(c),StringHash("sound2 cd")) == 0 then 
                     call MakeSound("war3mapimported\\Hero_Alucard_G2")
                     call SaveInteger(hs,GetHandleId(c),StringHash("sound2 cd"),1)
                     call MyFlush(GetHandleId(c),StringHash("sound2 cd"),0,60)
                    endif
                    endif
                    elseif e2 != null then
                    call SaveInteger(hs,GetHandleId(c),StringHash("alucard g2"),0)
                    call DestroyEffect(e2)
                    set e2 = null
                    endif
                    if GetUnitState(c,UNIT_STATE_LIFE) <= (AlucardG_HpCond3/100)*GetUnitState(c,UNIT_STATE_MAX_LIFE)  then 
                    if e3 == null then
                    set e3 = AddSpecialEffectTarget("war3mapImported\\wos_crimson aura wbats2.mdl",c,"origin")
                    call SaveInteger(hs,GetHandleId(c),StringHash("alucard g3"),1)
                    if LoadInteger(hs,GetHandleId(c),StringHash("sound3 cd")) == 0 then 
                     call MakeSound("war3mapimported\\Hero_Alucard_G4")
                     call SaveInteger(hs,GetHandleId(c),StringHash("sound3 cd"),1)
                     call MyFlush(GetHandleId(c),StringHash("sound3 cd"),0,60)
                    endif
                    endif
                    call UnitRemoveAbility(c,'BPSE')
                    call UnitRemoveAbility(c,'BNsi')
                    elseif e3 != null then
                    call SaveInteger(hs,GetHandleId(c),StringHash("alucard g3"),0)
                    call DestroyEffect(e3)
                    set e3 = null
                    endif
                    endif
                else
                    set c = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set m_AlucardPas2[i] = m_AlucardPas2[ MUI_AlucardPas2]
                    set MUI_AlucardPas2 = MUI_AlucardPas2 - 1
                    if MUI_AlucardPas2 == -1 then
                        call PauseTimer( t_AlucardPas2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AlucardPas2_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_AlucardPas2 = MUI_AlucardPas2 + 1
            set m_AlucardPas2[ MUI_AlucardPas2] = this
            set c = NewC
            set e = null
            set e2 = null
            set e3 = null
            set check2 = GetPlayerId(GetOwningPlayer(c))
            if MUI_AlucardPas2 == 0 then
                call TimerStart( t_AlucardPas2, 0.05, true, function thistype.Loop_AlucardPas2)
            endif
        endmethod        

    endstruct

    private struct AlucardSpells_Q
        private static timer t_AlucardQ = CreateTimer()
        private static integer array m_AlucardQ
        private static integer MUI_AlucardQ = -1
        unit c
        unit td
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        integer k2
        real r5
        real r6
        real r7
        group g
        group g2
        unit u
        real dmg
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

        private static method Loop_AlucardQ takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AlucardQ
                set this = m_AlucardQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if check2 == 0 then
                        if check == 0 then
                            call DebugUnit2(c)
                            if r >= 0.45 then
                                call StopSpellUnit2(c)
                                set check = 1
                                set k2 = 0
                                set move = 120
                                set r5 = 0
                                set r6 =10
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_alucard bulletfire.mdl", GetUnitX(c) + 195 * Cos(a), GetUnitY(c) + 195 * Sin(a), a * bj_RADTODEG, 1, 3, 100))
                                call MakeSound("war3mapimported\\Hero_Alucard_Q2")
                                set e = EffectSpawn("war3mapImported\\wos_alucard bullet.mdl", GetUnitX(c) + 130 * Cos(a), GetUnitY(c) + 130 * Sin(a), a * bj_RADTODEG, 1, 0.9, 180)
                                set e2 = EffectSpawn("war3mapImported\\wos_Marco bullet.mdl", GetUnitX(c) + 190 * Cos(a), GetUnitY(c) + 190 * Sin(a), a * bj_RADTODEG, 0.5, 1.1, 180)
                                call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_alucard bullet_backward.mdl", GetUnitX(c) + 130 * Cos(a), GetUnitY(c) + 130 * Sin(a), GetRandomReal(0, 359), 1, 1.35, 0), 1, 255, 255, 255, 1)
                                set rmax = 2
                                set r = 0
                                set x1 = GetUnitX(c) + 150 * Cos(a)
                                set y1 = GetUnitY(c) + 150 * Sin(a)
                            endif
                        elseif check == 1 then
                            if r5 >= r7 or k2 > 0 then
                                set r = 9999
                            endif
                            set k = 0
                            set r5 = r5 + move
                            call MoveEff(e, move, a)
                            call MoveEff(e2, move, a)
                            if r6 >= 0.0 then
                                set r6 = 0
                                call GroupClear( g )
                                call GroupEnumUnitsInRange( g , GetEffX(e) , GetEffY(e) , aoe , Condition(function NoDecor_Filter))
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup( u , g2 ) == false then
                                        if IsUnitType(u, UNIT_TYPE_HERO) then
                                            if k2 == 0 then
                                                call dmgphys(c, u, dmg)
                                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                            endif
                                            if IsUnitIllusion(u) == false then
                                                set td = u
                                                call SaveUnitHandle(hs, GetHandleId(c), StringHash("q2 target"), td)
                                                set k2 = k2 + 1
                                            endif
                                        else
                                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                            call GroupAddUnit( g2 , u )
                                            call dmgphys(c, u, dmg)
                                        endif
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                            else
                                set r6 = r6 + 0.03
                            endif
                            if r2 >= 0.06 then
                                set r2 = 0
                                call DecorRemove(c,GetEffX(e) , GetEffY(e), aoe,25)
                                call VisionTimed(GetOwningPlayer(c), GetEffX(e) , GetEffY(e), 600, 1)
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif
                    elseif check2 == 1 then
                        if check == 0 then
                            call DebugUnit2(c)
                            if r >= 0.51 then
                                call StopSpellUnit2(c)
                                set check = 1
                                set k2 = 0
                                set move = 85
                                set r5 = 0
                                call MakeSound("war3mapimported\\Hero_Alucard_Q2")
                                set e = EffectSpawn("war3mapImported\\wos_crimson aura wbats.mdl", GetUnitX(c) + 130 * Cos(a), GetUnitY(c) + 130 * Sin(a), a * bj_RADTODEG, 1, 0.7, 1)
                                set e2 = EffectSpawn("war3mapImported\\wos_red wave with bats.mdl", GetUnitX(c) + 190 * Cos(a), GetUnitY(c) + 190 * Sin(a), a * bj_RADTODEG, 1, 2.35, 1)
                                set rmax = 2
                                set r = 0
                                set x1 = GetUnitX(c) + 150 * Cos(a)
                                set y1 = GetUnitY(c) + 150 * Sin(a)
                            endif
                        elseif check == 1 then
                            if r5 >= AlucardRQ_Range then
                                set r = 9999
                            endif
                            set k = 0
                            set r5 = r5 + move
                            call MoveEff(e, move, a)
                            call MoveEff(e2, move, a)
                            if r6 >= 0.0 then
                                set r6 = 0
                                call GroupClear( g )
                                call GroupEnumUnitsInRange( g , GetEffX(e) , GetEffY(e) , aoe , Condition(function NoDecor_Filter))
                                loop
                                    set u = FirstOfGroup( g )
                                    exitwhen u == null
                                    if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup( u , g2 ) == false then
                                        if check3 == 0 then
                                            call dmgphys(c, u, dmg)
                                        else
                                            call dmgphys(c, u, dmg + MissHp(u, AlucardRQ_AddDamageFromMissedHp / 100))
                                        endif
                                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                        call GroupAddUnit( g2 , u )
                                           
                                    endif
                                    call GroupRemoveUnit( g , u )
                                endloop
                                set u = null
                            else
                                set r6 = r6 + 0.03
                            endif
                            if r2 >= 0.06 then
                                set r2 = 0
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_ldeff (41).mdl", GetEffX(e) + 95 * Cos(a), GetEffY(e) + 95 * Sin(a), GetRandomReal(0, 359), 2, 1.7, 1))
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_spell0382.mdl", GetEffX(e) + 95 * Cos(a), GetEffY(e) + 95 * Sin(a), GetRandomReal(0, 359), 1, 1.7, 151))
                                call VisionTimed(GetOwningPlayer(c), GetEffX(e) + 95 * Cos(a), GetEffY(e) + 95 * Sin(a), 800, 1)
                                call DecorRemove(c, GetEffX(e) + 95 * Cos(a), GetEffY(e) + 95 * Sin(a), aoe,50)
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif
                    endif
                else
                    if check2 == 0 then
                        if k2 > 0 and GetUnitAbilityLevel(c,AlucardQ_ID)>= 5 then
                            call SaveInteger(hs, GetHandleId(td), StringHash("alucard bullet"), 1)
                            call MyFlush(GetHandleId(td), StringHash("alucard bullet"), 0, AlucardQ_TimeBeforeQ2Expire)
                            call EUTU3(EffectSpawn("war3mapImported\\wos_Crosshair.mdl", GetUnitX(td), GetUnitY(td), 1, 1, 2, 60), AlucardQ_TimeBeforeQ2Expire, 105, td, StringHash("alucard bullet"))
                            call SwapAbility(c, AlucardQ_TimeBeforeQ2Expire, AlucardQ2_ID, AlucardQ_ID)
                            call SetUnitAbilityLevel(c,AlucardQ2_ID,GetUnitAbilityLevel(c,AlucardQ_ID))
            call MyFrame(c,AlucardQ_TimeBeforeQ2Expire,"BTNHero_Alucard_Q2",false,0)
                        endif
                    endif
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call SetUnitTimeScale( c , 1)
                    if r <= 0.39 then
                        call StopSpellUnit2(c)
                    endif
                    call DestroyGroup( g )
                    set g = null
                    set td = null
                    set e = null
                    set e2 = null
                    call DestroyGroup( g2 )
                    set g2 = null
                    set c = null
                    set u = null
                    set m_AlucardQ[i] = m_AlucardQ[ MUI_AlucardQ]
                    set MUI_AlucardQ = MUI_AlucardQ - 1
                    if MUI_AlucardQ == -1 then
                        call PauseTimer( t_AlucardQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AlucardQ_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_AlucardQ = MUI_AlucardQ + 1
            set m_AlucardQ[ MUI_AlucardQ] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set r2 = 0
            set move = 0
            set td = null
            set r6 = 0
            set check2 = 0
            set check3 = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set check = 0
            set k = 0
            call RemoveSavedHandle(hs, GetHandleId(c), StringHash("q2 target"))
            set aoe = AlucardQ_DamageAoe
            set dmg = GetHeroAgi( c , true) * ( AlucardQ_DamageAgiBase + ( AlucardQ_DamageAgiStep * ( GetUnitAbilityLevel( c , AlucardQ_ID) - 1 ) ) )
            set dmg = dmg + AlucardQ_Damage2StaticBase + ( AlucardQ_Damage2StaticStep * ( GetUnitAbilityLevel( c , AlucardQ_ID) - 1 ) )
            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph r")) == 1 then// T ability add dmg
                set check2 = 1
                set aoe = AlucardRQ_DamageAoe
                if GetUnitState(c, UNIT_STATE_LIFE) <= GetUnitState(c, UNIT_STATE_MAX_LIFE) * (AlucardRQ_HpToAddDamageCondition / 100) then
                    set check3 = 1
                endif
            endif
            set r7 = AlucardQ_RangeBase + ( AlucardQ_RangeStep * ( GetUnitAbilityLevel( c , AlucardQ_ID) - 1 ) )
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(AlucardQ_ID)), 0)
            set rmax = 2
            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph r")) == 1 then
                set rmax = 2
                if GetRandomInt(1, 2) == 1 then
                    call MakeSound("war3mapimported\\Hero_Alucard_Q04")
                else
                    call MakeSound("war3mapimported\\Hero_Alucard_Q2 02")
                endif
                call MakeSound("war3mapimported\\Hero_Alucard_RQ")
                call SetUnitAnimationByIndex(c, 1)
            else
                call MakeSound("war3mapimported\\Hero_Alucard_Q1")
                call SetUnitAnimationByIndex(c, 8)
                call SetUnitTimeScale(c, 0.65)
                set k = GetRandomInt(1, 5)
                if k == 1 then
                    call MakeSound("war3mapimported\\Hero_Alucard_Q01")
                elseif k == 2 then
                    call MakeSound("war3mapimported\\Hero_Alucard_Q02")
                elseif k == 3 then
                    call MakeSound("war3mapimported\\Hero_Alucard_Q03")
                elseif k == 4 then
                    call MakeSound("war3mapimported\\Hero_Alucard_Q04")
                elseif k == 5 then
                    call MakeSound("war3mapimported\\Hero_Alucard_Q05")
                endif
            endif
            if MUI_AlucardQ == 0 then
                call TimerStart( t_AlucardQ, 0.03, true, function thistype.Loop_AlucardQ)
            endif
        endmethod

        private static method Loop_AlucardQ2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AlucardQ
                set this = m_AlucardQ[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    if check == 0 then
                        call DebugUnit2(c)
                        set a = GAngle(c, td)
                        call SetUnitFacing(c, a * bj_RADTODEG)
                        if r >= 0.51 then
                            call StopSpellUnit2(c)
                            set check = 1
                            set k2 = 0
                            set move = 150
                            set r5 = 0
                            call MakeSound("war3mapimported\\Hero_Alucard_Q2")
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_alucard bulletfire.mdl", GetUnitX(c) + 195 * Cos(a), GetUnitY(c) + 195 * Sin(a), a * bj_RADTODEG, 1, 3, 100))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_alucard bulletfire.mdl", GetUnitX(c) + 130 * Cos(a), GetUnitY(c) + 130 * Sin(a), a * bj_RADTODEG, 1, 2, 100))
                            set e = EffectSpawn("war3mapImported\\wos_alucard bullet.mdl", GetUnitX(c) + 130 * Cos(a), GetUnitY(c) + 130 * Sin(a), a * bj_RADTODEG, 1, 0.9, 150)
                            set e2 = EffectSpawn("war3mapImported\\wos_Marco bullet.mdl", GetUnitX(c) + 195 * Cos(a), GetUnitY(c) + 195 * Sin(a), a * bj_RADTODEG, 0.5, 1.5, 150)
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_alucard bullet_backward.mdl", GetUnitX(c) + 130 * Cos(a), GetUnitY(c) + 130 * Sin(a), GetRandomReal(0, 359), 1, 1.35, 0), 1, 255, 255, 255, 1)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun1.mdl", GetUnitX(c) + 255 * Cos(a), GetUnitY(c) + 255 * Sin(a), a * bj_RADTODEG, 0.9, 3.75, 115))
                            set rmax = 2
                            set r6 = 10
                            set r = 0
                            set x1 = GetUnitX(c) + 150 * Cos(a)
                            set y1 = GetUnitY(c) + 150 * Sin(a)
                        endif
                    elseif check == 1 then
                        set k = 0
                        set r5 = r5 + move
                        set a = GAngle5(e, GetUnitX(td), GetUnitY(td))
                        call MoveEff(e, move, a)
                        call MoveEff(e2, move, a)
                        call BlzSetSpecialEffectYaw(e, a)
                        call BlzSetSpecialEffectYaw(e2, a)                        
                        if r6 >= 0.0 then
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun1.mdl",  GetEffX(e) + 155 * Cos(a),  GetEffY(e) + 155 * Sin(a), a * bj_RADTODEG, 1.15, 0.75, 135,255,125,125,255))
                            set r6 = 0
                            call GroupClear( g )
                            call GroupEnumUnitsInRange( g , GetEffX(e) , GetEffY(e) , aoe , Condition(function NoDecor_Filter))
                            loop
                                set u = FirstOfGroup( g )
                                exitwhen u == null
                                if SpellBool( u ) and IsUnitEnemy( u , GetOwningPlayer( c )) and IsUnitInGroup( u , g2 ) == false then
                                    call dmgphys(c, u, dmg)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
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
                                call DecorRemove(c,GetEffX(e) , GetEffY(e), aoe,25)
                            call VisionTimed(GetOwningPlayer(c), GetEffX(e) , GetEffY(e), 700, 1)
                        else
                            set r2 = r2 + 0.03
                        endif
                    endif
                else
                    if r == 9999 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_blood impact.mdl", GetUnitX(td), GetUnitY(td), a * bj_RADTODEG, 1, 2.5, 0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_bloodex-special-23.mdl", GetUnitX(td), GetUnitY(td), GetRandomReal(0, 359), 2.5, 2, 80))
                        call StunUnit(c, td, AlucardQ2_StunTime)
                    endif
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(AlucardQ_ID)), 1)
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call SaveInteger(hs, GetHandleId(td), StringHash("alucard bullet"), 0)
                    call SetUnitTimeScale( c , 1)
                    if r <= 0.42 then
                        call StopSpellUnit2(c)
                    endif
                    call DestroyGroup( g )
                    set g = null
                    set e = null
                    set td = null
                    set e2 = null
                    call DestroyGroup( g2 )
                    set g2 = null
                    set c = null
                    set u = null
                    set m_AlucardQ[i] = m_AlucardQ[ MUI_AlucardQ]
                    set MUI_AlucardQ = MUI_AlucardQ - 1
                    if MUI_AlucardQ == -1 then
                        call PauseTimer( t_AlucardQ)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AlucardQ2_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_AlucardQ = MUI_AlucardQ + 1
            set m_AlucardQ[ MUI_AlucardQ] = this
            set c = NewC
            set td = NewTd
            set r = 0
            set r2 = 0
            set move = 0
            set r6 = 0
            set check2 = 0
            call StartSpellUnit2(c)
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            set a = GAngle2( c , x , y ) // Angle Between points
            set check = 0
            set k = 0
            set aoe = AlucardQ_DamageAoe+25
            set dmg = GetHeroAgi( c , true) * ( AlucardQ2_DamageAgiBase + ( AlucardQ2_DamageAgiStep * ( GetUnitAbilityLevel( c , AlucardQ_ID) - 1 ) ) )
            set dmg = dmg + AlucardQ2_Damage2StaticBase + ( AlucardQ2_Damage2StaticStep * ( GetUnitAbilityLevel( c , AlucardQ_ID) - 1 ) )
            set rmax = 2
            set a = GAngle(c, td)
            call SetUnitFacing(c, a * bj_RADTODEG)
            call MakeSound("war3mapimported\\Hero_Alucard_Q1")
            call SetUnitAnimationByIndex(c, 12)
            call SetUnitTimeScale(c, 0.65)
            set k = GetRandomInt(1, 3)
            if k == 1 then
                call MakeSound("war3mapimported\\Hero_Alucard_Q2 01")
            elseif k == 2 then
                call MakeSound("war3mapimported\\Hero_Alucard_Q2 02")
            elseif k == 3 then
                call MakeSound("war3mapimported\\Hero_Alucard_Q2 03")
            endif
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_krk (1971).mdl", GetUnitX(c), GetUnitY(c), GetRandomReal(0, 359), 0.65, 1.25, 0))
            if MUI_AlucardQ == 0 then
                call TimerStart( t_AlucardQ, 0.03, true, function thistype.Loop_AlucardQ2)
            endif
        endmethod

    endstruct

    private struct AlucardSpells_W
        private static timer t_AlucardW = CreateTimer()
        private static integer array m_AlucardW
        private static integer MUI_AlucardW = -1
        private static timer t_AlucardW2 = CreateTimer()
        private static integer array m_AlucardW2
        private static integer MUI_AlucardW2 = -1
        unit c
        unit td
        unit d
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        integer k2
        real r3
        real r5
        real r6
        group g
        group g2
        unit u
        real dmg
        integer check
        framehandle array frame2_pas1 [10]
        framehandle array frame2_pas2 [10]
        framehandle array frame2_pas3 [10]
        framehandle array frame2_pas4 [10]
        framehandle array frame2_pas5 [10]
        framehandle array frame2_pas6 [10]
        real aoe
        real move
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_AlucardW takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AlucardW
                set this = m_AlucardW[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.05
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if r == 0.05 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1, 1.8, 0))
                        call SetUnitPosition(c, GetUnitX(td) + 145 * Cos(a), GetUnitY(td) + 145 * Sin(a))
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_blackblink.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2, 1.35, 0, 0, 0, 0, 255))
                        set a = GAngle(c, td)
                        call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
                    endif
                    if r == 0.25 then
                    set a = GAngle(c, td)
                    if check == 1 then                        
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                        call GroupClear(g)
                                call GroupEnumUnitsInRange(g, x, y, 450, Condition(function NoDecor_Filter))
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                            call GroupAddUnit(g2,u)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_ES10.mdl", GetUnitX(u), GetUnitY(u), a * bj_RADTODEG, 0.5, 4, 50))   
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop                     
                        else
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_ES10.mdl", GetUnitX(td), GetUnitY(td), a * bj_RADTODEG, 0.5, 3.5, 50))
                        endif
                    endif
                    if r == 0.5 then
                        call MakeSound("war3mapimported\\Hero_Alucard_W2")
                    endif
                    if r == rmax then
                    if check == 1 then 
                    set x = GetUnitX(td)
                    set y = GetUnitY(td)
                    call SetHpCurrent2(c,c, r5)
                    call GroupClear(g)
                                call GroupEnumUnitsInRange(g, x, y, 2000, Condition(function NoDecor_Filter))
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u,g2) then
                                            call dmgphys(c, u, dmg)
                                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_claw blood splatter (1).mdl", GetUnitX(u), GetUnitY(u), 0, 2, 1.5, 155))
                                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_blood impact.mdl", u, "origin"))                                            
                        call CurseUnit(c,u,5)
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                     call SetHpCurrent2(c,c, r5)
                                            else
                        call MakeSound("war3mapimported\\Hero_Alucard_W3")
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_blood impact.mdl", GetUnitX(td), GetUnitY(td), a * bj_RADTODEG, 1, 2.5, 0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_ldeff (5).mdl", GetUnitX(td), GetUnitY(td), a * bj_RADTODEG, 1, 2.5, 0))
                        set r = 9999
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        call dmgphys(c, td, dmg)                  
                        call SetHpCurrent2(c,c, r5)
                        call CurseUnit(c,td,5)
                        endif
                    endif
                else
                    call StopSpellUnit2(c)
                   // call StopSpellUnit2(td)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set c = null
                    set g =null
                    set g2 =null
                    set u =null
                    set td = null
                    set m_AlucardW[i] = m_AlucardW[ MUI_AlucardW]
                    set MUI_AlucardW = MUI_AlucardW - 1
                    if MUI_AlucardW == -1 then
                        call PauseTimer( t_AlucardW)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AlucardW_Start takes unit NewC, unit NewTd returns nothing
            local thistype this = thistype.create( )
            set MUI_AlucardW = MUI_AlucardW + 1
            set m_AlucardW[ MUI_AlucardW] = this
            set c = NewC
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set r = 0
            set dmg = GetHeroAgi( c , true) * ( AlucardW_DamageAgiBase + ( AlucardW_DamageAgiStep * ( GetUnitAbilityLevel( c , AlucardW_ID) - 1 ) ) )
            set dmg = dmg + AlucardW_Damage2StaticBase + ( AlucardW_Damage2StaticStep * ( GetUnitAbilityLevel( c , AlucardW_ID) - 1 ) )
            set rmax = 0.6
            call StartSpellUnit2(c)
          //  call StartSpellUnit2(td)
            set r5 = ( AlucardW_SelfHealAgiBase  + ( AlucardW_SelfHealAgiStep  * ( GetUnitAbilityLevel( c , AlucardW_ID) - 1 ) ) )*GetHeroAgi(c,true)
            if LoadInteger(hs,GetHandleId(c),StringHash("alucard g3")) == 1 then  
            set r5 = r5 * 1.25
            endif
            call SetUnitAnimationByIndex(c, 13)
            call SetUnitTimeScale(c, 0.1)
            set check = 0
            set g = CreateGroup()
            set g2 = CreateGroup()
            set u = null
            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph r")) == 1 then
            set check = 1
            set dmg = dmg + GetHeroAgi( c , true)
            endif
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapimported\\Hero_Alucard_W01")
            else
                call MakeSound("war3mapimported\\Hero_Alucard_W02")
            endif
            if MUI_AlucardW == 0 then
                call TimerStart( t_AlucardW, 0.05, true, function thistype.Loop_AlucardW)
            endif
        endmethod

        private static method Loop_AlucardW2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AlucardW2
                set this = m_AlucardW2[i]
                if SpellBoolCaster(c) and r <= rmax then
                        set r = r + 0.03
                        set r = S2R( R2SW( r , 0, 3 ) )
                        call DebugUnit(c)
                        call BlzFrameSetValue(frame2_pas3[k2], rmax - (r + 0.06))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                    if r < 0.3 then 
                    set k = k - 26
                    call SetUnitVertexColor(c, 255, 255, 255, k)
                    endif
                    if r == 0.3 then 
                        call SetUnitVertexColor(c, 255, 255, 255, 0)
                        set r2 = 10
                    endif
                    if r >= 0.3 then
                        set x = GetMouseX(GetOwningPlayer(c))
                        set y = GetMouseY(GetOwningPlayer(c))                        
                        if SR0(x1,y1, x, y) >=  move then //and IsUnitPaused(d) == false and IsUnitDebuffed1(d) == false then
                            set a = GAngle2(c, x, y)
                            set x1 = x1 + move *Cos(a)
                            set y1 = y1 + move *Sin(a)
                            call MoveEff(e, move,a)
                            call MoveEff(e2, move,a)
                            call SetUnitX(c,GetEffX(e))
                            call SetUnitY(c,GetEffY(e))
                        endif
                        if r2 > 0.21 then
                            set r2 = 0
                            set x = GetUnitX(c)
                            set y = GetUnitY(c)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call dmgphys(c, u, dmg)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        else
                            set r2 = r2 + 0.03
                        endif
                        if r3 > 0.3 then
                            set r3 = 0
                            set x = GetUnitX(c)
                            set y = GetUnitY(c)
                            call DecorRemove(c,x,y,aoe,20)
                            set r5 = GetRandomReal(0, 450)
                            set r6 = GetRandomReal(0, 359) * bj_DEGTORAD
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_red claw.mdl", x + r5 * Cos(r6), y + r5 * Sin(r6), GetRandomReal(0, 359), 1.85, 2.15, 1))
                            set r5 = GetRandomReal(0, 450)
                            set r6 = GetRandomReal(0, 359) * bj_DEGTORAD
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_red claw.mdl", x + r5 * Cos(r6), y + r5 * Sin(r6), GetRandomReal(0, 359), 1.85, 2.35, 1))
                        else
                            set r3 = r3 + 0.03
                        endif
                    endif
                else
                call MakeSound("war3mapimported\\Hero_Alucard_RW2")
                    call SetFly(c, 0)
                    if GetLocalPlayer() == Player(k2) then
                    call BlzFrameSetVisible(frame2_pas1[k2], false)
                    endif
                    call MouseOff(GetOwningPlayer(c))
                    call SetUnitVertexColor(c,255,255,255,255)
                    call SetUnitPathing(c, true)
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("w start"), 0)
                    call StopSpellUnit(c)
                    call DestroyGroup(g)
                    set c = null
                    set g = null
                    set e = null
                    set m_AlucardW2[i] = m_AlucardW2[ MUI_AlucardW2]
                    set MUI_AlucardW2 = MUI_AlucardW2 - 1
                    if MUI_AlucardW2 == -1 then
                        call PauseTimer( t_AlucardW2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AlucardW2_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            local real tmp_y = 0.0375
            set MUI_AlucardW2 = MUI_AlucardW2 + 1
            set m_AlucardW2[ MUI_AlucardW2] = this            
            set c = NewC
            set r = 0
            set check = 0
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set x1 = GetUnitX(c)
            set y1 = GetUnitY(c)
            set g = CreateGroup()
            set k = 255
            set k2 = GetPlayerId(GetOwningPlayer(c))
            set move = AlucardRW_Speed / 34
            call StartSpellUnit(c)
                        call SetMouseX(GetOwningPlayer(c),GetUnitX(c))
                        call SetMouseY(GetOwningPlayer(c),GetUnitY(c))
                        call MouseOn(GetOwningPlayer(c))
            call SetUnitPathing(c, false)
            call MakeSound("war3mapimported\\Hero_Alucard_RW3")
            if GetRandomInt(1, 2) == 1 then
                call MakeSound("war3mapimported\\Hero_Alucard_RW01")
            else
                call MakeSound("war3mapimported\\Hero_Alucard_RW02")
            endif
            set r2 = 10
            set aoe = AlucardRW_DamageAoe
            set dmg = GetHeroAgi(c, true) * (AlucardRW_DamageAgiBase + (AlucardRW_DamageAgiStep * (GetUnitAbilityLevel(c, AlucardW2_ID) - 1)))
            set dmg = dmg / (10)
            set dmg = dmg + 5
            set rmax = AlucardRW_Duration + 0.33
            call SetUnitAnimationByIndex( c , 12)
            call SetUnitTimeScale( c , 1)
            set e = EffectSpawn("war3mapImported\\wos_crimson aura wbats.mdl", x, y, 0, 1, 1, 5)
            set e2 = EffectSpawn("war3mapImported\\wos_Evtx_x120_rb2.mdl", x, y, 0, 1, 1, 5)
            call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("w start"), 1)
            if frame2_pas1[k2] == null then
                                set frame2_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18+tmp_y)
                                call BlzFrameSetSize(frame2_pas1[k2], 0.135, 0.035)
                                call BlzFrameSetTexture(frame2_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                                call BlzFrameSetVisible(frame2_pas1[k2], false)
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame2_pas1[k2], true)
                                endif
                                set frame2_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame2_pas1[k2], 0, 0)
                                call BlzFrameSetAbsPoint(frame2_pas2[k2], FRAMEPOINT_CENTER, 0.07, 0.185+tmp_y)
                                call BlzFrameSetSize(frame2_pas2[k2], 0.1, 0.019)
                                set frame2_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame2_pas1[k2], "", 0)
                                call BlzFrameSetSize(frame2_pas3[k2], 0.1, 0.035)
                                call BlzFrameSetScale(frame2_pas3[k2], 0.5)
                                call BlzFrameSetModel(frame2_pas3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                                call BlzFrameSetAbsPoint(frame2_pas3[k2], FRAMEPOINT_CENTER, 0.05, 0.175+tmp_y)
                                call BlzFrameSetMinMaxValue(frame2_pas3[k2], 0, rmax+1)
                                call BlzFrameSetValue(frame2_pas3[k2], rmax)
                                set frame2_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18+tmp_y)
                                call BlzFrameSetSize(frame2_pas4[k2], 0.03, 0.03)
                                call BlzFrameSetTexture(frame2_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Alucard_RW", 0, false)
                                set frame2_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185+tmp_y)
                                call BlzFrameSetText(frame2_pas5[k2], "|c00FFFF00" + "Time Left:" + "|r")
                                call BlzFrameSetScale(frame2_pas5[k2], 0.9)
                                set frame2_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame2_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame2_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17+tmp_y)
                                call BlzFrameSetText(frame2_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                                call BlzFrameSetScale(frame2_pas6[k2], 0.9)
                            else
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame2_pas1[k2], true)
                                endif
                                call BlzFrameSetMinMaxValue(frame2_pas3[k2], 0, rmax+1)
                                call BlzFrameSetValue(frame2_pas3[k2], rmax)
                            endif
            if MUI_AlucardW2 == 0 then
                call TimerStart( t_AlucardW2, 0.03, true, function thistype.Loop_AlucardW2)
            endif
        endmethod

    endstruct

    private struct AlucardSpells_E
        private static timer t_AlucardE = CreateTimer()
        private static integer array m_AlucardE
        private static integer MUI_AlucardE = -1
        unit c
        real x
        real y
        real x1
        real y1
        real r2
        integer k
        integer k2
        real scale
        real scale2
        real r4
        real r5
        real r6
        real r7
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
        effect array ee [36]
        real a
        real rmax

        private static method Loop_AlucardE takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AlucardE
                set this = m_AlucardE[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.03
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if check == 0 then
                    if r == 0.3 then 
                    call StopSpellUnit2(c)
                    call BlzPlaySpecialEffect(e, ANIM_TYPE_WALK)
                    call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun1.mdl", GetUnitX(c) + 255 * Cos(a), GetUnitY(c) + 255 * Sin(a), a * bj_RADTODEG, 0.9, 3.75, 115))
                call DestroyEffect(EffectSpawn("war3mapImported\\wos_crimson explosion with bats.mdl", GetUnitX(c) + 255 * Cos(a), GetUnitY(c) + 255 * Sin(a), a * bj_RADTODEG, 0.9, 0.5, 1))
                    endif
                    if r>0.3 then 
                        set r5 = r5 + move
                        if r5 >= r7 or k2 > 0 then
                            set r = 9999
                            if k2 > 0 then
                                call BlzSetSpecialEffectTimeScale(e, 2)
                                call BlzPlaySpecialEffect(e, ANIM_TYPE_ATTACK)
                            endif
                        endif
                        call MoveEff(e, move, a)
                        call MoveEff(e2, move, a)
                        set x = GetEffX(e)
                        set y = GetEffY(e)
                        if r6 >= 0.06 then
                            set r6 = 0
                            call DecorRemove(c,x,y,aoe,25)
                            call VisionTimed(GetOwningPlayer(c), x, y, 600, 1)
                        else
                            set r6 = r6 + 0.03
                        endif
                        if r2 > 0.03 then
                            set r2 = 0
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) and IsUnitInGroup(u, g2) == false then
                                    call GroupAddUnit(g2, u)
                                    if IsUnitType(u, UNIT_TYPE_HERO) then
                                        if k2 == 0 then
                                            set k2 = k2 + 1
                                            set x = GetUnitX(u)
                                            set y = GetUnitY(u)
                                            call BlzSetSpecialEffectPosition(e, x - 180 * Cos(a), y - 180 * Sin(a), 0)
                                            call dmgphys(c, u, dmg)
                                            call SlowUnit(c,u,AlucardE_Slow,AlucardE_Duration)
                                        endif
                                    else
                                        call dmgphys(c, u, dmg)
                                    endif
                                endif
                                call GroupRemoveUnit(g, u)
                            endloop
                        else
                            set r2 = r2 + 0.03
                        endif   
                        endif
                    elseif check == 1 then
                        if r == 0.3 then
                            call BlzSetSpecialEffectTimeScale(e, 1)
                        endif
                        call DebugUnit2(c)
                        if r > 0.33 then
                            set scale = scale + 0.07
                            if scale2 < scale * 0.88 then
                                set scale2 = scale2 + 0.12
                                if scale2 > 1.5 then
                                    set scale2 = scale2 + 0.1
                                endif
                            else
                                set scale2 = scale * 0.88
                            endif
                            set ee[k2] = EffectSpawnColor("war3mapImported\\wos_[By XeSHTeG]Dog Alucard.mdx", GetEffX(e), GetEffY(e), a * bj_RADTODEG, 0.35, scale2, (125*1.5) - r * 300, 125, 125, 125, 255)
                            call MyRemoveEff(ee[k2],1.5)
                            call BlzPlaySpecialEffect(ee[k2], ANIM_TYPE_STAND)
                            call MoveEff(e, move, a)
                            call BlzSetSpecialEffectScale(e, scale)
                            if move < 85 then
                                set move = move*0.5 + r * 70
                            endif                            
                                set aoe = aoe + 5
                            call BlzSetSpecialEffectHeight(e, 145 - r * 100)
                            set k2 = k2 + 1
                            set r5 = r5 + move
                            set x = GetEffX(e)
                            set y = GetEffY(e)
                            if r5 >= r7-150 then
                                set r = 9999
                            endif
                            if r6 >= 0.08 then
                                set r6 = 0
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_corpse explosion.mdl", GetEffX(e) + 150 * Cos(a), GetEffY(e) + 150 * Sin(a), 0, 3, 1.5, 0))
                                call VisionTimed(GetOwningPlayer(c), x, y, 800, 1)
                                call DecorRemove(c,x,y,aoe,100)
                            else
                                set r6 = r6 + 0.03
                            endif
                            if r2 > 0.03 then
                                set r2 = 0
                                call GroupClear(g)
                                call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                        if IsUnitInGroup(u, g2) == false then
                                            call GroupAddUnit(g2, u)
                                            call dmgphys(c, u, dmg)
                                            call SlowUnit(c,u,AlucardE_Slow,AlucardE_Duration)
                                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_claw blood splatter (1).mdl", GetUnitX(u), GetUnitY(u), 0, 2, 1.5, 155))
                                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_blood impact.mdl", u, "origin"))
                                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_bloodex-special-23.mdl", u, "chest"))
                                        endif
                                        call MUE(u, move * 3, 0.09, a)
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                            else
                                set r2 = r2 + 0.03
                            endif
                        endif
                    endif
                else
                    if check == 1 then
                        call StopSpellUnit2(c)
                        call ColorEffDummy3(e, 0, 255, 255, 255, 0.5)
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_Aluc_Explode_blood.mdl", x + 320 * Cos(a), y + 320 * Sin(a), GetRandomReal(0, 359), 2, 1, 1))
                        call DestroyEffect(EffectSpawn("war3mapimported\\wos_Opdef17 (282).mdl", x + 320 * Cos(a), y + 320 * Sin(a), GetRandomReal(0, 359), 1.55, 2.5, 1))
                        set k = 0
                        loop
                            exitwhen k > k2
                            call ColorEffDummy3(ee[k], 0, 125, 125, 125, 0.5)
                            set ee[k] = null
                            set k = k + 1
                        endloop
                         call GroupClear(g)
                                call GroupEnumUnitsInRange(g, x, y, aoe*1.5, Condition(function NoDecor_Filter))
                                loop
                                    set u = FirstOfGroup(g)
                                    exitwhen u == null
                                    if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                        if IsUnitInGroup(u, g2) == false then
                                            call GroupAddUnit(g2, u)
                                            call dmgphys(c, u, dmg)
                                            call SlowUnit(c,u,AlucardE_Slow,AlucardE_Duration)
                                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_claw blood splatter (1).mdl", GetUnitX(u), GetUnitY(u), 0, 2, 1.5, 155))
                                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_blood impact.mdl", u, "origin"))
                                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_bloodex-special-23.mdl", u, "chest"))
                                        endif
                                        call MUE(u, move * 3, 0.09, a)
                                    endif
                                    call GroupRemoveUnit(g, u)
                                endloop
                    else
                    if r< 0.3 then 
                    call StopSpellUnit2(c)
                    endif
                        if k2 == 0 then
                            call BlzSetSpecialEffectTimeScale(e, 2.5)
                            call BlzPlaySpecialEffect(e, ANIM_TYPE_ATTACK)
                            set x = x + 180 * Cos(a)
                            set y = y + 180 * Sin(a)
                            else
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_claw blood splatter (1).mdl", x, y, 0, 1, 1.5, 155))
                        endif
                        call ColorEffDummy3(e, 0, 255, 255, 255, 0.45)
                        call DestroyEffect(e2)
                    endif
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set u = null
                    set e = null
                    set e2 = null
                    set c = null
                    set m_AlucardE[i] = m_AlucardE[ MUI_AlucardE]
                    set MUI_AlucardE = MUI_AlucardE - 1
                    if MUI_AlucardE == -1 then
                        call PauseTimer( t_AlucardE)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AlucardE_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create( )
            set MUI_AlucardE = MUI_AlucardE + 1
            set m_AlucardE[ MUI_AlucardE] = this
            set c = NewC
            set x = NewX
            set y = NewY
            set r = 0
            set check = 0
            set k2 = 0
            set k = 0
            set r5 = 0
            set g = CreateGroup()
            set g2 = CreateGroup()
            set aoe = AlucardE_DamageAoe
            set a = GAngle2( c , x, y ) // Angle Between points
            set x1 = GetUnitX(c) + 400 * Cos(a)
            set y1 = GetUnitX(c) + 400 * Sin(a)
            set dmg = GetHeroAgi( c , true) * ( AlucardE_DamageAgiBase + ( AlucardE_DamageAgiStep * ( GetUnitAbilityLevel( c , AlucardE_ID) - 1 ) ) )
            set rmax = 2
            set r7 = AlucardE_RangeBase + ( AlucardE_RangeStep * ( GetUnitAbilityLevel( c , AlucardE_ID) - 1 ) )
            call SetUnitFacing(c, a * bj_RADTODEG)
            set scale = 0.75
            if LoadInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph r")) == 1 then
                set rmax = 1.5
                set move = 5
                call StartSpellUnit2(c)
                set k2 = 0
                set scale = 1
                set dmg = dmg + AlucardRE_DamageAgiIncrease*GetHeroAgi(c,true)
                set scale2 = 0.3
                set e = EffectSpawn("war3mapImported\\wos_[By XeSHTeG]Dog Alucard.mdl", GetUnitX(c) + 100 * Cos(a), GetUnitY(c) + 100 * Sin(a), a * bj_RADTODEG, 1, scale, 105*1.45)                
                call ColorEffDummy4(e, 0, 255, 255, 255, 0.5)
                set r4 = 999
                set check = 1
                set r7 = r7-350
                call SetUnitAnimationByIndex(c, 0)
                call SetUnitTimeScale(c, 1.45)
                call MakeSound("war3mapimported\\Hero_Alucard_RE")
                call MakeSound("war3mapimported\\Hero_Alucard_RE2")
            else
                set move = 100
                set r5 = 150
                call SetUnitAnimationByIndex(c, 9)
                call SetUnitTimeScale(c, 1)
                call StartSpellUnit2(c)
                call MakeSound("war3mapimported\\Hero_Alucard_E")
                call MakeSound("war3mapimported\\Hero_Alucard_E2")
                set e = EffectSpawn("war3mapImported\\wos_[By XeSHTeG]Alucard Dog.mdl", GetUnitX(c) + 150 * Cos(a), GetUnitY(c) + 150 * Sin(a), a * bj_RADTODEG, 2.5, 2.375, 0)
                call ColorEffDummy4(e,0,255,255,255,0.6)
                set e2 = EffectSpawn("war3mapImported\\Gear_auralanceblack023123.mdl", GetUnitX(c) + 190 * Cos(a), GetUnitY(c) + 190 * Sin(a), a * bj_RADTODEG, 1, 1.65, 150)
            endif               
            if MUI_AlucardE == 0 then
                call TimerStart( t_AlucardE, 0.03, true, function thistype.Loop_AlucardE)
            endif
        endmethod

    endstruct

    private struct AlucardSpells_R
        private static timer t_AlucardR = CreateTimer()
        private static integer array m_AlucardR
        private static integer MUI_AlucardR = -1
        unit c
        real x
        real y
        real r2
        integer k2
        real r3
        real r5
        unit u
        integer check
        integer check2
        framehandle array frame_pas1 [10]
        framehandle array frame_pas2 [10]
        framehandle array frame_pas3 [10]
        framehandle array frame_pas4 [10]
        framehandle array frame_pas5 [10]
        framehandle array frame_pas6 [10]
        real aoe
        real r
        effect e
        effect e2
        real a
        real rmax

        private static method Loop_AlucardR takes nothing returns nothing
            local thistype this
            local real tmp_y = 0
            local integer i = 0
            loop
                exitwhen i > MUI_AlucardR
                set this = m_AlucardR[i]
                if SpellBoolCaster(c) and r <= rmax and CheckCoordsInRect(gg_rct_Base, GetUnitX(c), GetUnitY(c)) == false then
                    if check == 0 or (check == 1 and IsUnitPaused(c) == false and GetUnitAbilityLevel(c, 'Avul') == 0) then
                        set r = r + 0.05
                    endif
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if check == 0 then
                        if r < 1.05 then
                            call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_LIFE) - r5)
                        endif
                        if r == 0.5 then
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZK-SM_XL8.mdl", x, y, GetRandomReal(0, 359), 0.75, 3, 1))
                        endif
                        if r >= 0 then
                            if r2 > 0.15 then
                                set r2 = 0
                                call DecorRemove(c,x,y,aoe,10)
                                call DestroyEffect(EffectSpawnColor("war3mapimported\\wos_gnaden_air.mdl", x, y, GetRandomReal(0, 359), 0.4, 5, 1, 255, 15, 15, 255))
                            else
                                set r2 = r2 + 0.05
                            endif
                            if r3 > 0.25 and r > 0.5 then
                                set r3 = 0
                                call DestroyEffect(EffectSpawn("war3mapimported\\wos_Opdef17 (282).mdl", x, y, GetRandomReal(0, 359), 0.75, 3.5, 55))
                            else
                                set r3 = r3 + 0.05
                            endif
                        endif
                        if r == rmax then
                            call AddUnitAnimationProperties(c, "lumber", true)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Aluc_Explode_blood.mdl", x, y, GetRandomReal(0, 359), 1.2, 1.5, 1))
                            call NextSound("war3mapimported\\Hero_Alucard_R2", 2.6)
                            call BlzSetUnitSkin(c, Alucard_Morph_ID)
                            call AAUniversalTooltips_SetUnitForm(c, 1)
                            call DestroyEffect(e)
                            call DestroyEffect(e2)
                            call SetUnitVertexColor(c, 255, 255, 255, 255)
                            call StopSpellUnit2(c)
                            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("morph r"), 1)
                            set r = 0
                            set rmax = AlucardR_DurationBase + (AlucardR_DurationStep * ( GetUnitAbilityLevel( c , AlucardR_ID) - 1 )) + 0.2
                            set r5 = GetUnitState(c, UNIT_STATE_LIFE) / GetUnitState(c, UNIT_STATE_MAX_LIFE)
                           // call BlzSetUnitRealField(c, UNIT_RF_HIT_POINTS_REGENERATION_RATE, BlzGetUnitRealField(c, UNIT_RF_HIT_POINTS_REGENERATION_RATE) + (AlucardR_HpRegenAddBase + (AlucardR_HpRegenAddStep * (GetUnitAbilityLevel(c, AlucardR_ID) - 1))))
                          //  call BlzSetUnitMaxHP(c, BlzGetUnitMaxHP(c) + (AlucardR_HpAddBase + AlucardR_HpAddStep * (GetUnitAbilityLevel(c, AlucardR_ID) - 1)))
                          //  call UnitAddAbility(c,AlucardR_Stat_AS_ID)
                           // call UnitMakeAbilityPermanent(c,true,AlucardR_Stat_AS_ID)
                            //call UnitAddAbility(c,AlucardR_Stat_MS_ID)
                            //call UnitMakeAbilityPermanent(c,true,AlucardR_Stat_MS_ID)
                          //  call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_MAX_LIFE) * r5)
                            call BlzSetAbilityIcon(AlucardQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Alucard_RQ.blp")
                            //call SetPlayerAbilityAvailable(GetOwningPlayer(c), AlucardW_ID, false)
                            call UnitAddAbility(c, AlucardW2_ID)
                            call SetUnitAbilityLevel(c, AlucardW2_ID, GetUnitAbilityLevel(c, AlucardR_ID))
                            //call BlzStartUnitAbilityCooldown(c, AlucardW2_ID, BlzGetUnitAbilityCooldownRemaining(c, AlucardW_ID))
                            call BlzSetAbilityIcon(AlucardE_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Alucard_RE.blp")
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), AlucardR_ID, false)
                            if GetUnitAbilityLevel(c,AlucardT_ID)>0 then 
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), AlucardT_ID, false)
                            call UnitAddAbility(c, AlucardT2_ID)
                            call SetUnitAbilityLevel(c, AlucardT2_ID, GetUnitAbilityLevel(c, AlucardT_ID))
                            call BlzStartUnitAbilityCooldown(c, AlucardT2_ID, BlzGetUnitAbilityCooldownRemaining(c, AlucardT_ID))
                            endif
                            call SaveInteger(hs,GetHandleId(c),StringHash("reset sfx"),1)
                            set check = 1
                            
                            if frame_pas1[k2] == null then
                                set frame_pas1[k2] = BlzCreateFrameByType("BACKDROP", "SS", main_frame, "", 0)
                                call BlzFrameSetAbsPoint(frame_pas1[k2], FRAMEPOINT_CENTER, 0.055, 0.18+tmp_y)
                                call BlzFrameSetSize(frame_pas1[k2], 0.135, 0.035)
                                call BlzFrameSetTexture(frame_pas1[k2], "UI\\Feedback\\XPBar\\human-xpbar-border.blp", 0, false)
                                call BlzFrameSetVisible(frame_pas1[k2], false)
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame_pas1[k2], true)
                                endif
                                set frame_pas2[k2] = BlzCreateFrame("EscMenuControlBackdropTemplate", frame_pas1[k2], 0, 0)
                                call BlzFrameSetAbsPoint(frame_pas2[k2], FRAMEPOINT_CENTER, 0.07, 0.185+tmp_y)
                                call BlzFrameSetSize(frame_pas2[k2], 0.1, 0.019)
                                set frame_pas3[k2] = BlzCreateFrameByType("STATUSBAR", "", frame_pas1[k2], "", 0)
                                call BlzFrameSetSize(frame_pas3[k2], 0.1, 0.035)
                                call BlzFrameSetScale(frame_pas3[k2], 0.5)
                                call BlzFrameSetModel(frame_pas3[k2], "ui/feedback/XpBar/XpBarConsole.mdx", 0)
                                call BlzFrameSetAbsPoint(frame_pas3[k2], FRAMEPOINT_CENTER, 0.05, 0.175+tmp_y)
                                call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, rmax+1)
                                call BlzFrameSetValue(frame_pas3[k2], rmax)
                                set frame_pas4[k2] = BlzCreateFrameByType("BACKDROP", "SS", frame_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame_pas4[k2], FRAMEPOINT_CENTER, 0.005, 0.18+tmp_y)
                                call BlzFrameSetSize(frame_pas4[k2], 0.03, 0.03)
                                call BlzFrameSetTexture(frame_pas4[k2], "ReplaceableTextures\\CommandButtons\\BTNHero_Alucard_R", 0, false)
                                set frame_pas5[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame_pas5[k2], FRAMEPOINT_CENTER, 0.07, 0.185+tmp_y)
                                call BlzFrameSetText(frame_pas5[k2], "|c00FFFF00" + "Morph Time Left:" + "|r")
                                call BlzFrameSetScale(frame_pas5[k2], 0.9)
                                set frame_pas6[k2] = BlzCreateFrameByType("TEXT", "MyPlayerName", frame_pas1[k2], "", 0)
                                call BlzFrameSetAbsPoint(frame_pas6[k2], FRAMEPOINT_CENTER, 0.07, 0.17+tmp_y)
                                call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(0, 0, 2) + "|r")
                                call BlzFrameSetScale(frame_pas6[k2], 0.9)
                            else
                                if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame_pas1[k2], true)
                                endif
                                call BlzFrameSetMinMaxValue(frame_pas3[k2], 0, rmax+1)
                                call BlzFrameSetValue(frame_pas3[k2], rmax)
                            endif
                        endif
                    elseif check == 1 then
                        
                         call BlzFrameSetValue(frame_pas3[k2], rmax - (r + 0.06))
                        if rmax - r >= 0 then
                            call BlzFrameSetText(frame_pas6[k2], "|c00FFFF00" + R2SW(rmax - r, 0, 2) + "|r")
                        endif
                    endif
                else
                    if check == 0 then
                        call StopSpellUnit2(c)
                    endif
                    if GetLocalPlayer() == GetOwningPlayer(c) then
                                    call BlzFrameSetVisible(frame_pas1[k2], false)
                                endif
                                call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(AlucardQ_ID)), 0)
            
                  //  call BlzSetUnitRealField(c, UNIT_RF_HIT_POINTS_REGENERATION_RATE, BlzGetUnitRealField(c, UNIT_RF_HIT_POINTS_REGENERATION_RATE) -( AlucardR_HpRegenAddBase + (AlucardR_HpRegenAddStep * (GetUnitAbilityLevel(c, AlucardR_ID) - 1))))
                    //call SetPlayerAbilityAvailable(GetOwningPlayer(c), AlucardW_ID, true)
                    //call BlzStartUnitAbilityCooldown(c, AlucardW_ID, BlzGetUnitAbilityCooldownRemaining(c, AlucardW2_ID))
                    call UnitRemoveAbility(c, AlucardW2_ID)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), AlucardT_ID, true)
                    call BlzStartUnitAbilityCooldown(c, AlucardT_ID, BlzGetUnitAbilityCooldownRemaining(c, AlucardT2_ID))
                    call UnitRemoveAbility(c, AlucardT2_ID)
                    call AddUnitAnimationProperties(c, "lumber", false)
                    call UnitRemoveAbility(c, AlucardR_Armor)
                    call UnitRemoveAbility(c, AlterSaberR_Regen0)
                    call UnitRemoveAbility(c, AlterSaberR_Regen1)
                    call UnitRemoveAbility(c, AlterSaberR_Regen2)
                    call UnitRemoveAbility(c, AlterSaberR_Regen3)
                    call UnitRemoveAbility(c, AlterSaberR_Regen4)
                   // set r5 = GetUnitState(c, UNIT_STATE_LIFE) / GetUnitState(c, UNIT_STATE_MAX_LIFE)
                  //  call BlzSetUnitMaxHP(c, BlzGetUnitMaxHP(c) - (AlucardR_HpAddBase + AlucardR_HpAddStep * (GetUnitAbilityLevel(c, AlucardR_ID) - 1)))
                  //  call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_MAX_LIFE) * r5)
                    call SaveInteger(hs, GetHandleId(Player(k2)), StringHash("morph r"), 0)
                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), AlucardR_ID, true)
                  //  call UnitRemoveAbility(c, AlucardR2_ID)
                    call BlzSetAbilityIcon(AlucardQ_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Alucard_Q.blp")
                    call BlzSetAbilityIcon(AlucardW_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Alucard_W.blp")
                    call BlzSetAbilityIcon(AlucardE_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Alucard_E.blp")
                    call BlzSetAbilityIcon(AlucardT_ID, "ReplaceableTextures\\CommandButtons\\BTNHero_Alucard_T.blp")
                    call BlzSetUnitSkin(c, Alucard_ID)
                    call AAUniversalTooltips_SetUnitForm(c, 0)
                    call SaveInteger(hs,GetHandleId(c),StringHash("reset sfx"),1)
                    call SetUnitTimeScale( c, 1 )
                    set c = null
                    set m_AlucardR[i] = m_AlucardR[MUI_AlucardR]
                    set MUI_AlucardR = MUI_AlucardR - 1
                    if MUI_AlucardR == -1 then
                        call PauseTimer( t_AlucardR )
                    endif
                    call destroy( )
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AlucardR_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            local real tmp_y = 0
            set MUI_AlucardR = MUI_AlucardR + 1
            set m_AlucardR[MUI_AlucardR] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set r2 = 10
            set r3 = 10
            set check2 = 0
            set k2 = GetPlayerId(GetOwningPlayer(c))
            call StartSpellUnit2(c)
            set check = 0
            set u = null
            set a = GetUnitFacing(c) * bj_DEGTORAD // Angle Between points
            set rmax = 1
            call UnitAddAbility(c, AlucardR_Armor)
            if GetUnitAbilityLevel(c, AlucardR_ID) == 1 then
                call UnitAddAbility(c, AlterSaberR_Regen0)
            elseif GetUnitAbilityLevel(c, AlucardR_ID) == 2 then
                call UnitAddAbility(c, AlterSaberR_Regen1)
            elseif GetUnitAbilityLevel(c, AlucardR_ID) == 3 then
                call UnitAddAbility(c, AlterSaberR_Regen2)
            elseif GetUnitAbilityLevel(c, AlucardR_ID) == 4 then
                call UnitAddAbility(c, AlterSaberR_Regen3)
            elseif GetUnitAbilityLevel(c, AlucardR_ID) == 5 then
                call UnitAddAbility(c, AlterSaberR_Regen4)
            endif
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(AlucardQ_ID)), 1)
            
            call SetUnitAbilityLevel(c, AlucardR_Armor, GetUnitAbilityLevel(c, AlucardR_ID))
            set r5 = (GetUnitState(c, UNIT_STATE_LIFE) * ((AlucardR_HpCostBase+AlucardR_HpCostStep*(GetUnitAbilityLevel(c, AlucardR_ID)-1)) / 100)) / 20
            call VisionTimed(GetOwningPlayer(c), GetUnitX(c), GetUnitY(c), 1800, rmax )
            call SetUnitTimeScale(c, 1.5)
            call SetUnitAnimationByIndex(c, 18)
            call MakeSound("war3mapimported\\Hero_Alucard_R")
            call MakeSound("war3mapimported\\Hero_Alucard_R3")
            if MUI_AlucardR == 0 then
                call TimerStart( t_AlucardR, 0.05, true, function thistype.Loop_AlucardR )
            endif
        endmethod

    endstruct

    private struct AlucardSpells_T
        private static timer t_AlucardT = CreateTimer()
        private static integer array m_AlucardT
        private static integer MUI_AlucardT = -1
        private static timer t_AlucardT2 = CreateTimer()
        private static integer array m_AlucardT2
        private static integer MUI_AlucardT2 = -1
        unit c
        unit td
        real x
        real y
        real r5
        real r6
        group g
        group g2
        unit u
        real dmg
        real a2
        integer check
        real aoe
        real r
        effect e2
        effect e3
        real a
        real rmax

        private static method Loop_AlucardT takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AlucardT
                set this = m_AlucardT[i]
                if SpellBoolCaster(td) and r <= rmax and (GetUnitAbilityLevel(td,AlucardT_Buff_ID)>0 or GetUnitAbilityLevel(td,AlucardT2_Buff_ID)>0) then
                    set r = r + 0.05
                    set r = S2R( R2SW( r , 0, 3 ) )
                    if r5 >=100 then 
                    call BlzSetSpecialEffectPosition(e2, GetUnitX(td), GetUnitY(td), GetUnitFlyHeight(td) + 150)
                    call EffVision(e2, td)
                    endif
                   // call BlzSetSpecialEffectPosition(e3, GetUnitX(td), GetUnitY(td), GetUnitFlyHeight(td) + 1)
                    //call EffVision(e3, td)
                else
                 if r5 >=100 then 
                    call DestroyEffect(e2)
                    call BlzSetSpecialEffectTimeScale(e2, 2.5)
                    endif
                   // call DestroyEffect(e3)
                 //   call BlzSetSpecialEffectTimeScale(e3, 2.5)
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(td)), StringHash("t immun time target"), 0)
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("t immun time"), 0)
                    set c = null
                    set td = null
                    set e2 = null
                    set e3 = null
                    set m_AlucardT[i] = m_AlucardT[ MUI_AlucardT]
                    set MUI_AlucardT = MUI_AlucardT - 1
                    if MUI_AlucardT == -1 then
                        call PauseTimer( t_AlucardT)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AlucardT_Start takes unit NewC, unit NewTd,real NewAdd,real NewHeal,integer NewCheck returns nothing
            local thistype this = thistype.create( )
            set MUI_AlucardT = MUI_AlucardT + 1
            set m_AlucardT[ MUI_AlucardT] = this
            set c = NewC
            set td = NewTd
            set x = GetUnitX(td)
            set y = GetUnitY(td)
            set check = NewCheck
            set r5 = NewAdd
            set r6 = NewHeal
            set r = 0
            if r5 >=100 then 
            set e2 = EffectSpawn("war3mapImported\\wos_[Spell]EnergyShield-blackred.mdx", x, y, 1, 1, 1.5, 155)
            endif            
            if check == 0 then
            call CurseUnit(c,td,6)
            set rmax = AlucardT_Duration
            call MyFrame(c,rmax,"BTNHero_Alucard_T",false,1)
            call DestroyEffect(EffectSpawn("war3mapimported\\wos_HakkeStart.mdx", x, y, GetRandomReal(0, 359), 0.3, 1.45, 5))
            else            
            set rmax = AlucardT_Duration/2
            endif
            //set e3 = EffectSpawn("war3mapImported\\wos_[By XeSHTeG]Alucard Circle.mdl", x, y, 0, 0.5, 0.85, 1)
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(td)), StringHash("t immun time target"), 1)
            call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash("t immun time"), 1)
            call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("t immun add dmg"), r5/100)
            call SaveReal(hs, GetHandleId(GetOwningPlayer(c)), StringHash("t immun add heal"), r6/100)
            if MUI_AlucardT == 0 then
                call TimerStart( t_AlucardT, 0.05, true, function thistype.Loop_AlucardT)
            endif
        endmethod

        private static method Loop_AlucardT2 takes nothing returns nothing
            local integer this
            local integer i = 0
            loop
                exitwhen i > MUI_AlucardT2
                set this = m_AlucardT2[i]
                if SpellBoolCaster(c) and r <= rmax then
                    set r = r + 0.05
                    set r = S2R( R2SW( r , 0, 3 ) )
                    call DebugUnit(c)
                    if r < 2.05 then
                        call SetUnitState(c, UNIT_STATE_LIFE, GetUnitState(c, UNIT_STATE_LIFE) - r6)
                    endif
                    if r == 1. or r == 1.5 or r == 2 or r == 2.5 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZK-SM_XL8.mdl", GetUnitX(c), GetUnitY(c), 1, 0.75, 2, 90))
                    endif
                    if r == 1. then
                        call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_AlucardRiver.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.5, 1., 1), 2.15, 255, 255, 255, 1)
                        call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_AlucardRiver.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG + 90, 1.5, 1., 1), 2.15, 255, 255, 255, 1)
                        call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_AlucardRiver.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG + 180, 1.5, 1., 1), 2.15, 255, 255, 255, 1)
                        call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_AlucardRiver.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG - 90, 1.5, 1., 1), 2.15, 255, 255, 255, 1)
                        call MakeSound("war3mapimported\\Hero_Alucard_RT3")
                        call MakeSound("war3mapimported\\Hero_Alucard_RT4")
                        set x = GetUnitX(c)
                        set y = GetUnitY(c)
                        set r5 = 200
                    endif
                    if r == 1. or r == 1.5 or r == 2 or r == 2.5   then
                        call GroupClear(g)
                        call DecorRemove(c,x,y,aoe,100)
                        call GroupEnumUnitsInRange(g, x, y, aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                if IsUnitInGroup(u, g2) == false then
                                    call GroupAddUnit(g2, u)                        
                                call CurseUnit(c,u,7)
                                    call AlucardT_Start(c,u,50,AlucardT_Heal/2,1)
                                    call dmgphys(c, u, dmg)            
                                endif
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set a2 = a
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_corpse explosion.mdl", x + r5 * Cos(a2 - 15 * bj_DEGTORAD), y + r5 * Sin(a2 - 15 * bj_DEGTORAD), 0, 2., 2.75, 0))
                        //call DestroyEffect(EffectSpawn("war3mapImported\\wos_corpse explosion.mdl", x + r5 * Cos(a2), y + r5 * Sin(a2), 0, 1.5, 2.15, 0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_corpse explosion.mdl", x + r5 * Cos(a2 + 15 * bj_DEGTORAD), y + r5 * Sin(a2 + 15 * bj_DEGTORAD), 0, 2., 2.75, 0))
                        set a2 = a2 + 90 * bj_DEGTORAD
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_corpse explosion.mdl", x + r5 * Cos(a2 - 15 * bj_DEGTORAD), y + r5 * Sin(a2 - 15 * bj_DEGTORAD), 0, 2., 2.75, 0))
                        //call DestroyEffect(EffectSpawn("war3mapImported\\wos_corpse explosion.mdl", x + r5 * Cos(a2), y + r5 * Sin(a2), 0, 1.5, 2.15, 0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_corpse explosion.mdl", x + r5 * Cos(a2 + 15 * bj_DEGTORAD), y + r5 * Sin(a2 + 15 * bj_DEGTORAD), 0, 2., 2.75, 0))
                        set a2 = a2 + 90 * bj_DEGTORAD
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_corpse explosion.mdl", x + r5 * Cos(a2 - 15 * bj_DEGTORAD), y + r5 * Sin(a2 - 15 * bj_DEGTORAD), 0, 2., 2.75, 0))
                        //call DestroyEffect(EffectSpawn("war3mapImported\\wos_corpse explosion.mdl", x + r5 * Cos(a2), y + r5 * Sin(a2), 0, 1.5, 2.15, 0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_corpse explosion.mdl", x + r5 * Cos(a2 + 15 * bj_DEGTORAD), y + r5 * Sin(a2 + 15 * bj_DEGTORAD), 0, 2., 2.75, 0))
                        set a2 = a2 + 90 * bj_DEGTORAD
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_corpse explosion.mdl", x + r5 * Cos(a2 - 15 * bj_DEGTORAD), y + r5 * Sin(a2 - 15 * bj_DEGTORAD), 0, 2., 2.75, 0))
                        //call DestroyEffect(EffectSpawn("war3mapImported\\wos_corpse explosion.mdl", x + r5 * Cos(a2), y + r5 * Sin(a2), 0, 1.5, 2.15, 0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_corpse explosion.mdl", x + r5 * Cos(a2 + 15 * bj_DEGTORAD), y + r5 * Sin(a2 + 15 * bj_DEGTORAD), 0, 2., 2.75, 0))
                        set a2 = a2 + 90 * bj_DEGTORAD
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_corpse explosion.mdl", x + r5 * Cos(a2 - 15 * bj_DEGTORAD), y + r5 * Sin(a2 - 15 * bj_DEGTORAD), 0, 2., 2.75, 0))
                        //call DestroyEffect(EffectSpawn("war3mapImported\\wos_corpse explosion.mdl", x + r5 * Cos(a2), y + r5 * Sin(a2), 0, 1.5, 2.15, 0))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_corpse explosion.mdl", x + r5 * Cos(a2 + 15 * bj_DEGTORAD), y + r5 * Sin(a2 + 15 * bj_DEGTORAD), 0, 2., 2.75, 0))
                        set r5 = r5 + 400
                        set aoe = aoe + AlucardT2_DamageAoeStep
                    endif
                else
                    call StopSpellUnit(c)
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set c = null
                    set td = null
                    set u = null
                    set g = null
                    set g2 = null
                    set m_AlucardT2[i] = m_AlucardT2[ MUI_AlucardT2]
                    set MUI_AlucardT2 = MUI_AlucardT2 - 1
                    if MUI_AlucardT2 == -1 then
                        call PauseTimer( t_AlucardT2)
                    endif
                    call deallocate(this)
                endif
                set i = i + 1
            endloop
        endmethod

        public static method AlucardT2_Start takes unit NewC returns nothing
            local thistype this = thistype.create( )
            set MUI_AlucardT2 = MUI_AlucardT2 + 1
            set m_AlucardT2[ MUI_AlucardT2] = this
            set c = NewC
            set x = GetUnitX(c)
            set y = GetUnitY(c)
            set r = 0
            set g = CreateGroup()
            set g2 = CreateGroup()
            set dmg = AlucardT2_DamageAgiBase*GetHeroAgi(c,true)
            set rmax = 2.5
            set r6 = (GetUnitState(c, UNIT_STATE_LIFE) * ((AlucardT2_HpCost / 100))) / 40
            set aoe = AlucardT2_DamageAoe
            call StartSpellUnit(c)
            set a = GetUnitFacing(c) * bj_DEGTORAD
            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_red and black pool.mdl", GetUnitX(c), GetUnitY(c), 1, 1.5, 0.95, 1), 1, 255, 255, 255, 0.5)
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZK-SM_XL8.mdl", GetUnitX(c), GetUnitY(c), 1, 0.75, 2, 90))
            call MakeSound("war3mapimported\\Hero_Alucard_RT")
            call MakeSound("war3mapimported\\Hero_Alucard_RT2")
             call VisionTimed(GetOwningPlayer(c), x,y, 2500, 5)
            if MUI_AlucardT2 == 0 then
                call TimerStart( t_AlucardT2, 0.03, true, function thistype.Loop_AlucardT2)
            endif
        endmethod

    endstruct

    //----------------------------Alucard-----------------------------------------------
     /* Animations index:
    0 - move
    1 - move
    2 - fast move
    5 - stand ready double gun
    6 - push gun left
    7 - stand channel
    8 - gun left
    9 - gun right
    10 - punch gun right
    11 - e
    12 - double shot
    13 - q2 end
    14 - mb r
    15 - w with 0.1 timescale
    
     */ 
    function AlucardQ_Start takes unit c, real x, real y returns nothing
        call AlucardSpells_Q.AlucardQ_Start( c, x, y )
    endfunction
    function AlucardQ2_Start takes unit c returns nothing
        local unit td = LoadUnitHandle(hs, GetHandleId(c), StringHash("q2 target"))
        call AlucardSpells_Q.AlucardQ2_Start( c, td )
        set td = null
    endfunction
    function AlucardW_Start takes unit c, unit td returns nothing
        call AlucardSpells_W.AlucardW_Start( c, td )
    endfunction
    function AlucardW2_Start takes unit c returns nothing
        call AlucardSpells_W.AlucardW2_Start( c )
    endfunction
    function AlucardE_Start takes unit c, real x, real y returns nothing
        call AlucardSpells_E.AlucardE_Start( c, x , y )
    endfunction
    function AlucardR_Start takes unit c returns nothing
        call AlucardSpells_R.AlucardR_Start( c )
    endfunction
    function AlucardT_Start takes unit c, unit td returns nothing
        local effect e = null
        local real x = GetUnitX(td)
        local real y = GetUnitY(td)
        call MakeSound("war3mapimported\\Hero_Alucard_T2")
        call MakeSound("war3mapimported\\Hero_Alucard_T")
        call EffectSpawn2("war3mapImported\\wos_crimson aura wbats.mdl", x, y, 1, 1, 1, 5, 2.5)
        set e = EffectSpawn("war3mapImported\\wos_[By XeSHTeG]Alucard Circle.mdl", x, y, 0, 1, 1, 900)
        call AnimDummyEff(e, 0.5, 0.25)
        call ScaleEffDummy(e, 2.3, 1, 4)
        call ColorEffDummy3(e, 2.5, 255, 255, 255, 0.5)
        call AlucardSpells_T.AlucardT_Start( c, td,100,AlucardT_Heal,0)
        set e = null
    endfunction
    function AlucardT2_Start takes unit c returns nothing
        call AlucardSpells_T.AlucardT2_Start( c)
    endfunction
    function AlucardF_Start takes unit c, unit td returns nothing
        call AlucardSpells_Utility.AlucardPas_Start( c, td)
    endfunction
    function AlucardG_Start takes unit c returns nothing
        call AlucardSpells_Utility.AlucardPas2_Start( c )
    endfunction
    
endlibrary


//Code indented using The_Witcher's Script language Aligner
//Download the newest version and report bugs at www.hiveworkshop.com
