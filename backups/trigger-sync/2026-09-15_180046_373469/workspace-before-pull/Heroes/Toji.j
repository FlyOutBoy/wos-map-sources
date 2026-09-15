library TojiSpells initializer InitTojiSpells uses GearSystems
    globals
        private timer TojiTimer03
        private code TojiTimer03Callback
        private integer TojiTimer03Users = 0
        private timer TojiTimer05
        private code TojiTimer05Callback
        private integer TojiTimer05Users = 0

        // Move Resume Tracking
        private real array Toji_LastOrderX
        private real array Toji_LastOrderY
        private boolean array Toji_IsMoving

        // System Hash
        private hashtable TojiR_Hash = InitHashtable()

//--------------------------------------Toji Core---------------------------------------------------------
        integer Toji_ID = 'H02J'

//---------------Q ability (Split Soul Katana - Dual Slash)--------------------
        integer TojiQ_ID = 'A0GY'
        // Суммарный конечный урон за 2 слэша. Внутри способности делится на 2.
        real TojiQ_DamageAgiBase = 1.0
        real TojiQ_DamageAgiStep = 1.0
        real TojiQ_Damage2StaticBase = 150.0
        real TojiQ_Damage2StaticStep = 0.0
        real TojiQ_Move = 90.0
        real TojiQ_AttackRange = 200.0
        real TojiQ_FirstHitDelay = 0.09
        real TojiQ_BetweenHits = 0.21
        real TojiQ_ChaseMaxDuration = 2.50
        boolean TojiQ_IsInvul = false
        real TojiQ_CastTime = 0.21
        real TojiQ_DecorDamage = 15.0

//---------------Q2 ability (Playful Cloud - Barrage Rush)---------------------
        integer TojiQ2_ID = 'A0GZ'
        real TojiQ2_DamageAgiBase = 2
        real TojiQ2_DamageAgiStep = 0.5
        real TojiQ2_Damage2StaticBase = 100.0
        real TojiQ2_Damage2StaticStep = 0.0
        integer TojiQ2_DamageCount = 4
        real TojiQ2_DamageAoe = 235.0
        real TojiQ2_Move = 60.0
        real TojiQ2_ReachRange = 100.0
        real TojiQ2_DamageInterval = 0.30
        real TojiQ2_MiniStun = 0.10
        real TojiQ2_ExtraRunDuration = 1.20
        real TojiQ2_FinalStun = 0.30
        real TojiQ2_ChaseMaxDuration = 3.00
        boolean TojiQ2_IsInvul = false
        real TojiQ2_CastTime = 0.00
        real TojiQ2_DecorDamage = 10.0

//---------------Q3 ability (Inverted Spear of Heaven - Lethal Pierce)---------
        integer TojiQ3_ID = 'A0H0'
        real TojiQ3_DamageAgiBase = 4.0
        real TojiQ3_DamageAgiStep = 0.0
        real TojiQ3_DamageStaticBase = 100.0
        real TojiQ3_DamageStaticStep = 0.0
        real TojiQ3_BehindDistance = 110.0
        real TojiQ3_HitDelay = 0.60
        real TojiQ3_Stun = 1.00
        boolean TojiQ3_IsInvul = false
        real TojiQ3_CastTime = 0.60
        real TojiQ3_DecorDamage = 30.0

//---------------Arsenal Progression (F)---------------------------------------
        integer TojiArsenalQ2HeroLevel = 12
        integer TojiArsenalQ3HeroLevel = 25

//---------------W ability (Chain of a Thousand Miles - Harpoon)---------------
        integer TojiW_ID = 'A0H1'
        real TojiW_DamageAgiBase = 1.0
        real TojiW_DamageAgiStep = 1.0
        real TojiW_Damage2StaticBase = 150.0
        real TojiW_Damage2StaticStep = 0.0
        real TojiW_DamageAoe = 175.0
        real TojiW_RangeBase = 1200.0
        real TojiW_RangeStep = 50.0
        real TojiW_MoveBase = 60.0
        real TojiW_MoveStep = 5.0
        real TojiW_ReturnMoveBonus = 0.0
        real TojiW_ChainDuration = 5.0
        real TojiW_ChainMaxRange = 1600.0
        boolean TojiW_IsInvul = false
        real TojiW_CastTime = 0.00
        real TojiW_DecorDamage = 20.0
        integer TojiW_AbiDebuff_ID = 'A0HA'
        integer TojiW_Debuff_ID = 'B02Z'

//---------------W2 ability (Chain Whip / Yank)--------------------------------
        integer TojiW2_ID = 'A0H2'
        real TojiW2_CenterPullRange = 600.0
        real TojiW2_SidePullRange = 550.0
        real TojiW2_SideInwardRange = 250.0
        real TojiW2_PullDuration = 0.15
        real TojiW2_SideClickDeadzone = 250.0
        boolean TojiW2_IsInvul = false
        real TojiW2_CastTime = 0.00
        real TojiW2_DecorDamage = 20.0
        real TojiE_BuffDuration = 2.0

//---------------E ability (Heavenly Step - Dash Charges)----------------------
        integer TojiE_ID = 'A0H3'
        integer TojiE_MaxCharges = 3
        real TojiE_RechargeBase = 20.0
        real TojiE_RechargeStep = 2.0
        real TojiE_RangeBase = 600.0
        real TojiE_RangeStep = 50.0
        real TojiE_DashDuration = 0.24
        real TojiE_HitAoe = 175.0
        real TojiE_Level25DamageAtk = 100.0
        real TojiE_Level25DamageAgi = 1.0
        real TojiE_Level25ThrowRange = 125.0
        real TojiE_Level25ThrowDuration = 0.21
        real TojiE_NextAbilityAgiBonus = 1
        integer TojiE_BuffMaxStacks = 1
        integer TojiE_AbiBuff_ID = 'A0H9'
        integer TojiE_Buff_ID = 'B036'
        boolean TojiE_IsInvul = false
        real TojiE_CastTime = 0.00
        real TojiE_DecorDamage = 15.0

//---------------R ability (Fly Head Swarm)------------------------------------
        integer TojiR_ID = 'A0H4'
        real TojiR_Aoe = 1000.0
        real TojiR_DurationBase = 5.0
        real TojiR_DurationStep = 1.0
        real TojiR_DamageInterval = 1
        real TojiR_DamageAgiBase = 0.40
        real TojiR_DamageAgiStep = 0.15
        real TojiR_DamageStaticBase = 0.0
        real TojiR_DamageStaticStep = 0.0
        integer TojiR_SlowPercent = 40
        integer TojiR_SlowDuration = 4
        integer TojiR_InvisAbility_ID = 'Apiv'
        integer TojiR_InvisAbility2_ID = 'Apiv'
        integer TojiR_InvisBuff_ID = 'BOwk'
        integer TojiR_SlowBuff_ID = 'Bslo'
        boolean TojiR_IsInvul = false
        real TojiR_CastTime = 0.00
        real TojiR_DecorDamage = 20.0

//---------------T ability (Sorcerer Killer - Flurry)--------------------------
        integer TojiT_ID = 'A0H5'
        real TojiT_DamageAgi = 10.0
        real TojiT_DamageAoe = 800.0
        integer TojiT_HitCount = 5
        real TojiT_HitInterval = 0.30
        real TojiT_FlyHeight = 600.0
        real TojiT_DescendDuration = 0.06
        real TojiT_Duration = 1.56
        integer TojiG_AbiShieldPierce_ID = 'A0HC'
        integer TojiT_ShieldPierceBuff_ID = 'B030'
        boolean TojiT_IsInvul = true
        real TojiT_CastTime = 0.00
        real TojiT_DecorDamage = 40.0

//---------------G ability (Cursed Tool Revolver)------------------------------
        integer TojiG_ID = 'A0H7'
        integer TojiG2_ID = 'A0H8'
        real TojiG_DamageAgiBase = 4.00
        real TojiG_DamageAgiStep = 0.0
        real TojiG_DamageStaticBase = 0.0
        real TojiG_DamageStaticStep = 0.0
        real TojiG_DamageAoe = 150.00
        real TojiG_StunTime = 0.50
        real TojiG_Period = 0.05
        real TojiG_MaxFlightTime = 2.00
        real TojiG_ProjectileMove = 150.00
        integer TojiG_AbiDebuff_ID = 'A0HB'
        integer TojiG_Debuff1_ID = 'B031'
        integer TojiG_Debuff2_ID = 'B032'
        integer TojiG_Debuff3_ID = 'B033'
        integer TojiG_Debuff4_ID = 'B034'
        integer TojiG_Debuff5_ID = 'B035'
        real TojiG_DamageIncreasePerStack = 4.00
        real TojiG_DebuffMaxDuration = 10.00
        real TojiG_DebuffTrackPeriod = 0.05
        real TojiG_ResPerAgi = 10.0
        real TojiG_ResMax = 15.0
        real TojiG_Res = 1.0
        real TojiG_CdReduce = 10.0
        boolean TojiG_IsInvul = false
        real TojiG_CastTime = 0.10
        real TojiG_DecorDamage = 25.0

//---------------F ability (Inventory Curse - Arsenal Cycle)-------------------
        integer TojiF_ID = 'A0H6'
        boolean TojiF_IsInvul = false
        real TojiF_CastTime = 0.00
        real TojiF_DecorDamage = 0.0
    endglobals

    private function Toji_TrackPointOrder takes nothing returns boolean
        local unit u = GetOrderedUnit()
        local integer ord
        local integer pid
        if GetUnitTypeId(u) == Toji_ID then
            set ord = GetIssuedOrderId()
            if ord == 851971 or ord == 851986 then
                set pid = GetPlayerId(GetOwningPlayer(u))
                set Toji_LastOrderX[pid] = GetOrderPointX()
                set Toji_LastOrderY[pid] = GetOrderPointY()
                set Toji_IsMoving[pid] = true
            endif
        endif
        set u = null
        return false
    endfunction

    private function Toji_TrackStopOrder takes nothing returns boolean
        local unit u = GetOrderedUnit()
        local integer ord
        if GetUnitTypeId(u) == Toji_ID then
            set ord = GetIssuedOrderId()
            if ord == 851972 or ord == 851973 then
                set Toji_IsMoving[GetPlayerId(GetOwningPlayer(u))] = false
            endif
        endif
        set u = null
        return false
    endfunction

    private function Toji_TrackTargetOrder takes nothing returns boolean
        local unit u = GetOrderedUnit()
        if GetUnitTypeId(u) == Toji_ID then
            set Toji_IsMoving[GetPlayerId(GetOwningPlayer(u))] = false
        endif
        set u = null
        return false
    endfunction

    private function TojiE_AddLeapBuff takes unit c returns nothing
        call BuffUnit01(c, c, TojiE_AbiBuff_ID, "innerfire", 1)
    endfunction

    private function TojiE_ConsumeLeapBonus takes unit c returns real
        local integer key = StringHash("TojiE_LeapBuffStacks")
        local integer stacks = GetUnitAbilityLevel(c, TojiE_Buff_ID)
        if stacks <= 0 then
            return 0.0
        endif
        call UnitRemoveAbility(c, TojiE_Buff_ID)
        call SaveInteger(hs, GetHandleId(c), key, 0)
        return GetHeroAgi(c, true) * TojiE_NextAbilityAgiBonus * stacks
    endfunction

    function TojiE_GetLeapBuffStacks takes unit c returns integer
        return LoadInteger(hs, GetHandleId(c), StringHash("TojiE_LeapBuffStacks"))
    endfunction

    private function TojiAbilityDamage takes unit c, unit td, real damage returns real
        local integer stacks = 0
        if c == null or td == null or GetUnitTypeId(c) != Toji_ID or damage <= 0.00 then
            return damage
        endif

        if GetUnitAbilityLevel(td, TojiG_Debuff5_ID) > 0 then
            set stacks = 5
            call UnitRemoveAbility(td, TojiG_Debuff5_ID)
        elseif GetUnitAbilityLevel(td, TojiG_Debuff4_ID) > 0 then
            set stacks = 5
            call UnitRemoveAbility(td, TojiG_Debuff4_ID)
        elseif GetUnitAbilityLevel(td, TojiG_Debuff3_ID) > 0 then
            set stacks = 4
            call UnitRemoveAbility(td, TojiG_Debuff3_ID)
        elseif GetUnitAbilityLevel(td, TojiG_Debuff2_ID) > 0 then
            set stacks = 3
            call UnitRemoveAbility(td, TojiG_Debuff2_ID)
        elseif GetUnitAbilityLevel(td, TojiG_Debuff1_ID) > 0 then
            set stacks = 2
            call UnitRemoveAbility(td, TojiG_Debuff1_ID)
        endif

        if stacks > 0 then
            call BuffUnit01(c, td, TojiG_AbiDebuff_ID, "curse", stacks)
            set damage = damage * (1.00 + stacks * TojiG_DamageIncreasePerStack / 100.00)
        endif
        return damage
    endfunction

    private function TojiTimer03Acquire takes nothing returns nothing
        set TojiTimer03Users = TojiTimer03Users + 1
        if TojiTimer03Users == 1 then
            call TimerStart(TojiTimer03, 0.03, true, TojiTimer03Callback)
        endif
    endfunction

    private function TojiTimer03Release takes nothing returns nothing
        set TojiTimer03Users = TojiTimer03Users - 1
        if TojiTimer03Users <= 0 then
            set TojiTimer03Users = 0
            call PauseTimer(TojiTimer03)
        endif
    endfunction

    private function TojiTimer05Acquire takes nothing returns nothing
        set TojiTimer05Users = TojiTimer05Users + 1
        if TojiTimer05Users == 1 then
            call TimerStart(TojiTimer05, 0.05, true, TojiTimer05Callback)
        endif
    endfunction

    private function TojiTimer05Release takes nothing returns nothing
        set TojiTimer05Users = TojiTimer05Users - 1
        if TojiTimer05Users <= 0 then
            set TojiTimer05Users = 0
            call PauseTimer(TojiTimer05)
        endif
    endfunction

    private struct TojiSpells_Q
        private static integer array m_TojiQ
        private static integer MUI_TojiQ = -1

        unit c
        unit td
        group g
        integer mode
        integer state
        integer hits
        real a
        real x 
        effect e
        effect e2
        effect e3
        real y
        real r
        real r2
        real move
        real x1
        real y1
        real damageClock
        real effectClock
        real chaseClock
        real dmg
        real bonusDmg

        public static method Loop_TojiQ takes nothing returns nothing
            local integer i = 0
            local thistype this
            local unit picked
            local real dx
            local real dy
            local real distance
            local real step
            local real hitDamage
            local boolean remove
            local real rr1
            local real rr2
            local boolean finishAnimation
            local real fly = 150.0
            local real rr4 = 50.0

            loop
                exitwhen i > MUI_TojiQ
                set this = m_TojiQ[i]
                set remove = false
                set finishAnimation = (mode == 1 and state == 2) or (mode == 2 and state == 2) or (mode == 3 and state == 1)

                if c == null or td == null or GetUnitTypeId(c) == 0 or GetUnitTypeId(td) == 0 or GetWidgetLife(c) <= 0.405 or (GetWidgetLife(td) <= 0.405 and not finishAnimation) then
                    set remove = true

                elseif mode == 1 then
                    if state == 0 then
                        set chaseClock = RoundReal(chaseClock + 0.03, 3)
                        if chaseClock >= 0.33 then 
                            call SetUnitTimeScale(c, 0.0)
                        endif
                        set dx = GetUnitX(td) - GetUnitX(c)
                        set dy = GetUnitY(td) - GetUnitY(c)
                        set distance = SquareRoot(dx * dx + dy * dy)
                        set a = Atan2(dy, dx)
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        call SetUnitFacing(c, a * bj_RADTODEG)
                        if chaseClock == TojiQ_CastTime then 
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_bdef (383).mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.25, 1, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_DustWindFaster3.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.25, 1, 1))
                        endif
                        if chaseClock > TojiQ_CastTime then 
                            if distance > TojiQ_AttackRange + 50.0 and chaseClock < TojiQ_ChaseMaxDuration then
                                set step = move
                                call MoveUnit(c, step, a)
                            else
                                if distance > TojiQ_AttackRange + 10.0 then
                                    call PosUnit(c, GetUnitX(td) - TojiQ_AttackRange * Cos(a), GetUnitY(td) - TojiQ_AttackRange * Sin(a))
                                endif
                                set state = 1
                                set r = 0.0
                                set hits = 0
                                call SetUnitTimeScale(c, 1.20)
                                call MakeSound("war3mapimported\\Hero_Toji_Q1 2")
                            endif
                        endif
                    elseif state == 1 then
                        set r = RoundReal(r + 0.03, 3)
                        call MoveUnit(c, 5.0, a)
                        call MoveUnit(td, 5.0, a)
                        if r >= TojiQ_FirstHitDelay + TojiQ_BetweenHits * hits then
                            set hitDamage = dmg
                            if hits == 0 then
                                set hitDamage = hitDamage + bonusDmg
                                set bonusDmg = 0.0
                            endif
                            call dmgphys(c, td, TojiAbilityDamage(c, td, hitDamage))
                            set rr1 = 0.0
                            set rr2 = 15.0
                            if hits == 0 then 
                                call DestroyEffect(EffectSpawnColor3("war3mapImported\\wos_blue_circular.mdl", x - rr1 * Cos(a), y - rr1 * Sin(a), a * bj_RADTODEG + 60, 1.25, 0.45, 145, -30, 255, 255, 255, 195))
                                call DestroyEffect(EffectSpawnColor3("war3mapImported\\wos_animeslashfinalanother.mdl", x - (rr1 - rr2) * Cos(a), y - (rr1 - rr2) * Sin(a), a * bj_RADTODEG + 60, 1.0, 2.25, 185, -35, 255, 255, 255, 125))
                            else
                                call MakeSound("war3mapimported\\Hero_Toji_Q1 3")
                                call DestroyEffect(EffectSpawnColor3("war3mapImported\\wos_blue_circular.mdl", x - rr1 * Cos(a), y - rr1 * Sin(a), a * bj_RADTODEG - 60, 1.25, 0.45, 145, -30, 255, 255, 255, 195))
                                call DestroyEffect(EffectSpawnColor3("war3mapImported\\wos_animeslashfinalanother.mdl", x - (rr1 - rr2) * Cos(a), y - (rr1 - rr2) * Sin(a), a * bj_RADTODEG - 60, 0.95, 2.25, 185, -35, 255, 255, 255, 125))
                            endif
                            call DestroyEffect(AddSpecialEffectTarget("war3mapimported\\wos_A_[doft]hero_skeletonking_n2s_e_star.mdx", td, "chest"))
                            call DestroyEffect(EffectSpawn3("war3mapImported\\wos_zhanji-blue.mdl", x + 10 * Cos(a), y + 10 * Sin(a), GetRandomReal(0, 359), 1, 0.6, 85, -15))
                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", td, "chest"))
                            call DecorRemove(c, x, y, 250, TojiQ_DecorDamage)
                            set hits = hits + 1
                            if hits >= 2 then
                                set state = 2
                                set r = 9999.0
                            endif
                        endif
                    else
                        set remove = true
                    endif

                elseif mode == 2 then
                    if r2 > 0.03 then 
                        set r2 = 0.0
                        call DecorRemove(c, GetUnitX(c), GetUnitY(c), 300, TojiQ2_DecorDamage)
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_luanzhanwhite01.mdl", GetUnitX(c) + 100 * Cos(a), GetUnitY(c) + 100 * Sin(a), GetRandomReal(0, 359), 1.2, 1.75, 0, 255, 255, 255, 75))
                    else
                        set r2 = RoundReal(r2 + 0.03, 3)
                    endif
                    set effectClock = RoundReal(effectClock + 0.03, 3)
                    if effectClock >= 0.18 then
                        set effectClock = 0.0
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_bdef (383).mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.25, 1, 1))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_DustWindFaster3.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2.55, 1, 1))
                    endif
                    if state == 0 then
                        set chaseClock = RoundReal(chaseClock + 0.03, 3)
                        set dx = GetUnitX(td) - GetUnitX(c)
                        set dy = GetUnitY(td) - GetUnitY(c)
                        set distance = SquareRoot(dx * dx + dy * dy)
                        set a = Atan2(dy, dx)
                        call SetUnitFacing(c, a * bj_RADTODEG)

                        if distance > TojiQ2_ReachRange + 10.0 and chaseClock < TojiQ2_ChaseMaxDuration then
                            set step = move
                            call MoveUnit(c, step, a)
                            call BlzSetSpecialEffectPosition(e, GetUnitX(c) + rr4 * Cos(a), GetUnitY(c) + rr4 * Sin(a), fly)
                            call BlzSetSpecialEffectPosition(e2, GetUnitX(c) + rr4 * Cos(a), GetUnitY(c) + rr4 * Sin(a), fly)
                            call BlzSetSpecialEffectYaw(e, a + 50 * bj_DEGTORAD)
                            call BlzSetSpecialEffectYaw(e2, a - 50 * bj_DEGTORAD)
                        else
                            if distance > TojiQ2_ReachRange + 10.0 then
                                call PosUnit(c, GetUnitX(td) - TojiQ2_ReachRange * Cos(a), GetUnitY(td) - TojiQ2_ReachRange * Sin(a))
                            endif
                            set state = 1
                            set move = move * 0.60
                            call MouseOn(GetOwningPlayer(c))
                            set x = GetUnitX(td)
                            set y = GetUnitY(td)
                            call SetMouseX(GetOwningPlayer(c), x)
                            call SetMouseY(GetOwningPlayer(c), y)
                            set r = 0.0
                            set damageClock = 0.0
                            set hits = 0
                            call SetUnitTimeScale(c, 1.65)
                        endif
                    elseif state == 1 then
                        set r = RoundReal(r + 0.03, 3)
                        set damageClock = RoundReal(damageClock + 0.03, 3)
                        if damageClock >= TojiQ2_DamageInterval and hits < TojiQ2_DamageCount then
                            set damageClock = RoundReal(damageClock - TojiQ2_DamageInterval, 3)
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, GetUnitX(c), GetUnitY(c), TojiQ2_DamageAoe, Condition(function NoDecor_Filter))
                            loop
                                set picked = FirstOfGroup(g)
                                exitwhen picked == null
                                call GroupRemoveUnit(g, picked)
                                if IsUnitEnemy(picked, GetOwningPlayer(c)) and SpellBool(picked) then
                                    set hitDamage = dmg
                                    if picked == td and bonusDmg > 0.0 then
                                        set hitDamage = hitDamage + bonusDmg
                                        set bonusDmg = 0.0
                                    endif
                                    call StunUnit(c, picked, TojiQ2_MiniStun)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", picked, "chest"))
                                    call dmgphys(c, picked, TojiAbilityDamage(c, picked, hitDamage))
                                endif
                            endloop
                            set hits = hits + 1
                        endif
                        set dx = GetUnitX(td) - GetUnitX(c)
                        set dy = GetUnitY(td) - GetUnitY(c)
                        set distance = SquareRoot(dx * dx + dy * dy)
                        if GetMouseX(GetOwningPlayer(c)) != x then 
                            set x = GetMouseX(GetOwningPlayer(c))
                            set y = GetMouseY(GetOwningPlayer(c))
                            set a = GAngle2(c, x, y)
                        endif
                        call SetUnitFacing(c, a * bj_RADTODEG)
                        call MoveUnit(td, move, a)
                        call PosUnit(c, GetUnitX(td) - 150 * Cos(a), GetUnitY(td) - 150 * Sin(a))
                        call BlzSetSpecialEffectPosition(e, GetUnitX(c) + rr4 * Cos(a), GetUnitY(c) + rr4 * Sin(a), fly)
                        call BlzSetSpecialEffectPosition(e2, GetUnitX(c) + rr4 * Cos(a), GetUnitY(c) + rr4 * Sin(a), fly)
                        call BlzSetSpecialEffectYaw(e, a + 50 * bj_DEGTORAD)
                        call BlzSetSpecialEffectYaw(e2, a - 50 * bj_DEGTORAD)

                        if hits >= TojiQ2_DamageCount or r >= TojiQ2_ExtraRunDuration then
                            set bonusDmg = 0.0
                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", td, "chest"))
                            set state = 2
                            set r = 9999.0
                        endif
                    else
                        set remove = true
                    endif

                else // mode == 3 (Q3)
                    if state == 0 then
                        set r = RoundReal(r + 0.03, 3)
                        set x = GetUnitX(td)
                        set y = GetUnitY(td)
                        if r == 0.30 then
                            set a = GAngle(c, td)
                            call SetUnitTimeScale(c, 0.50)
                            if GetRandomInt(1, 2) == 1 then 
                                call MakeSound("war3mapimported\\Hero_Toji_Q3 3")
                            else
                                call MakeSound("war3mapimported\\Hero_Toji_Q1 5")
                            endif
                            call BlinkEff(c) 
                            call BlinkEff2(c)
                            call PosUnit(c, x + 180 * Cos(a), y + 180 * Sin(a))
                            set a = GAngle(c, td)
                            call BlinkEff(c) 
                            call BlinkEff2(c)
                            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_bdef (383).mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 1.25, 1, 1))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_DustWindFaster3.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG, 2.55, 1, 1))
                        endif
                        if r == 0.33 then 
                            call SaveInteger(hs, GetHandleId(c), StringHash("toji q3"), 1)
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_redstart2.mdx", x, y, a * bj_RADTODEG, 1.25, 1.5, 140), 0.3, 255, 255, 255, 0.15)                      
                        endif
                        if r >= TojiQ3_HitDelay then
                            call dmgphys(c, td, TojiAbilityDamage(c, td, dmg + bonusDmg))
                            set bonusDmg = 0.0
                            call StunUnit(c, td, TojiQ3_Stun)                                             
                            call MakeSound("war3mapimported\\Hero_Toji_Q3 2")
                            call DecorRemove(c, GetUnitX(td), GetUnitY(td), 300, TojiQ3_DecorDamage)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_FantasyBattle (1643).mdx", x, y, a * bj_RADTODEG, 0.5, 3, 50))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_blood impact.mdl", GetUnitX(td), GetUnitY(td), a * bj_RADTODEG, 1, 2.5, 0))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun0.mdl", x, y, a * bj_RADTODEG, 0.65, 2.5, 50))
                            call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\wos_bloodex-special-23.mdl", td, "chest"))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_1hongse_2blue.mdl", x, y, GetRandomReal(0, 359), 0.95, 3.95, 11))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_acg_dajiqiquan4.mdx", x, y, GetRandomReal(0, 359), 1.0, 3, 3))
                            call SaveInteger(hs, GetHandleId(c), StringHash("toji q3"), 0)
                            set state = 1
                            set r = 9999.0
                        endif
                    else
                        set remove = true
                    endif
                endif

                if remove then
                    if c != null and GetUnitTypeId(c) != 0 then
                        call SetUnitTimeScale(c, 1.0)
                        call StopSpellUnit2(c)
                        if mode == 1 then 
                            call DestroyEffect(e)
                        elseif mode == 2 then 
                            call MouseOff(GetOwningPlayer(c))
                            call DestroyEffect(e)
                            call DestroyEffect(e2)
                            call DestroyEffect(e3)
                        elseif mode == 3 then 
                            call SaveInteger(hs, GetHandleId(c), StringHash("toji q3"), 0)
                            call DestroyEffect(e)
                            call DestroyEffect(e2)
                            call DestroyEffect(e3)
                        endif
                    endif
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    set g = null
                    set td = null
                    set e = null
                    set e2 = null
                    set e3 = null
                    set c = null
                    set m_TojiQ[i] = m_TojiQ[MUI_TojiQ]
                    set MUI_TojiQ = MUI_TojiQ - 1
                    call deallocate(this)
                    if MUI_TojiQ == -1 then
                        call TojiTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            set picked = null
        endmethod

        public static method TojiQ_Start takes unit NewC, unit NewTarget, integer NewMode returns nothing
            local thistype this
            local integer abilityId
            local integer level

            if NewC == null or NewTarget == null or GetUnitTypeId(NewC) == 0 or GetUnitTypeId(NewTarget) == 0 or GetWidgetLife(NewTarget) <= 0.405 or not IsUnitEnemy(NewTarget, GetOwningPlayer(NewC)) then
                return
            endif

            if NewMode < 1 or NewMode > 3 then
                set NewMode = 1
            endif
            if NewMode == 1 then
                set abilityId = TojiQ_ID
            elseif NewMode == 2 then
                set abilityId = TojiQ2_ID
            else
                set abilityId = TojiQ3_ID
            endif

            set this = thistype.create()
            set MUI_TojiQ = MUI_TojiQ + 1
            set m_TojiQ[MUI_TojiQ] = this
            set c = NewC
            set td = NewTarget
            set g = CreateGroup()
            set mode = NewMode
            set state = 0
            set hits = 0
            set r = 0.0
            set damageClock = 0.0
            set effectClock = 0.0
            set chaseClock = 0.0
            set level = GetUnitAbilityLevel(NewC, abilityId)
            if level < 1 then
                set level = 1
            endif
            set bonusDmg = TojiE_ConsumeLeapBonus(NewC)
            if TojiQ_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif

            if NewMode == 1 then
                set move = TojiQ_Move
                set dmg = GetHeroAgi(NewC, true) * (TojiQ_DamageAgiBase + TojiQ_DamageAgiStep * (level - 1))
                set dmg = dmg + TojiQ_Damage2StaticBase + TojiQ_Damage2StaticStep * (level - 1)
                set dmg = dmg / 2.0
                set a = GAngle2(NewC, GetUnitX(NewTarget), GetUnitY(NewTarget))
                call SetUnitFacing(NewC, a * bj_RADTODEG)
                set e = AddSpecialEffectTarget("Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdx", c, "hand right")
                call SetUnitAnimationByIndex(NewC, 1)
                call SetUnitTimeScale(NewC, 1)
                call MakeSound("war3mapimported\\Hero_Toji_Q1 1")
            elseif NewMode == 2 then
                set move = TojiQ2_Move
                set dmg = GetHeroAgi(NewC, true) * (TojiQ2_DamageAgiBase + TojiQ2_DamageAgiStep * (level - 1))
                set dmg = dmg + TojiQ2_Damage2StaticBase + TojiQ2_Damage2StaticStep * (level - 1)
                set dmg = dmg / I2R(TojiQ2_DamageCount)
                set e = EffectSpawn3("war3mapImported\\wos_SlashAoeOrangeLoop.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG + 45, 1, 0.895, 100, -35)
                set e2 = EffectSpawn3("war3mapImported\\wos_SlashAoeOrangeLoop.mdl", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG + 45, 1, 0.895, 100, -35)
                set e3 = AddSpecialEffectTarget("war3mapimported\\wos_SlidingDustWithRocks.mdx", c, "origin")
                call BlzSetSpecialEffectAlpha(e, 125)
                call BlzSetSpecialEffectAlpha(e2, 125)
                set a = GAngle2(NewC, GetUnitX(NewTarget), GetUnitY(NewTarget))
                call SetUnitFacing(NewC, a * bj_RADTODEG)
                call SetUnitAnimationByIndex(NewC, 6)
                call SetUnitTimeScale(NewC, 1.55)
                call MakeSound("war3mapimported\\Hero_Toji_Q2 1")
                call MakeSound("war3mapimported\\Hero_Toji_Q2 3")
            else
                set move = 0.0
                set dmg = GetHeroAgi(NewC, true) * (TojiQ3_DamageAgiBase + TojiQ3_DamageAgiStep * (level - 1))
                set dmg = dmg + TojiQ3_DamageStaticBase + TojiQ3_DamageStaticStep * (level - 1)
                set e = AddSpecialEffectTarget("Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdx", c, "hand right")
                set e2 = AddSpecialEffectTarget("Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdx", c, "hand left")
                set e3 = AddSpecialEffectTarget("Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdx", c, "chest")
                set a = GAngle2(NewC, GetUnitX(NewTarget), GetUnitY(NewTarget))
                call SetUnitFacing(NewC, a * bj_RADTODEG)
                call SetUnitAnimationByIndex(NewC, 9)
                call SetUnitTimeScale(NewC, 0.10)
                call MakeSound("war3mapimported\\Hero_Toji_Q3 1")
            endif

            if MUI_TojiQ == 0 then
                call TojiTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct TojiSpells_W
        private static integer array m_TojiW
        private static integer MUI_TojiW = -1

        unit c
        unit td
        group g
        effect e
        effect e2
        real r2
        lightning chain
        integer state
        integer level
        real x
        real y
        real a
        real move
        real r
        real r6
        real r7
        real dmg
        real tdMoveSpeed
        real tdSlowSpeed
        real pullX
        real pullY
        real pullAngle
        real pullMove
        real pullRemaining
        real pullElapsed

        public static method Loop_TojiW takes nothing returns nothing
            local integer i = 0
            local thistype this
            local unit picked
            local real step
            local real dx
            local real dy
            local real distance
            local real angle
            local boolean remove
            loop
                exitwhen i > MUI_TojiW
                set this = m_TojiW[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or GetWidgetLife(c) <= 0.405 then
                    set remove = true

                elseif state == 0 then
                    if r6 < r7 then
                        set step = move
                        if r6 + step > r7 then
                            set step = r7 - r6
                        endif
                        set x = x + step * Cos(a)
                        set y = y + step * Sin(a)
                        set r6 = r6 + step
                        call BlzSetSpecialEffectPosition(e, x, y, 110.0)
                        call MoveLightningEx(chain, true, GetUnitX(c), GetUnitY(c), 110.0, x, y, 110.0)
                        if r2 > 0.0 then
                            set r2 = 0.0
                            call DecorRemove(c, x, y, TojiW_DamageAoe, TojiW_DecorDamage)
                            call VisionTimed(GetOwningPlayer(c), x, y, 450, 1.5)
                        else
                            set r2 = r2 + 0.03
                        endif
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, x, y, TojiW_DamageAoe, Condition(function NoDecor_Filter))
                        loop
                            set picked = FirstOfGroup(g)
                            exitwhen picked == null or td != null
                            call GroupRemoveUnit(g, picked)
                            if IsUnitEnemy(picked, GetOwningPlayer(c)) and SpellBool(picked) then
                                set td = picked
                            endif
                        endloop
                        call GroupClear(g)

                        if td != null then
                            set state = 1
                            set r = 0.0                                             
                            call MakeSound("war3mapimported\\Hero_Toji_W 2")
                            call BuffUnit01(c, td, TojiW_AbiDebuff_ID, "curse", GetUnitAbilityLevel(c, TojiW_ID))
                            call dmgphys(c, td, TojiAbilityDamage(c, td, dmg))
                            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", td, "chest"))
                            call MakeSound("war3mapImported\\Hero_Toji_TW2")
                            call DestroyEffect(e)
                            set e = null
                            set e2 = AddSpecialEffectTarget("war3mapImported\\wos_FSAeff (198)1.mdl", td, "chest")
                            call MoveLightningEx(chain, true, GetUnitX(c), GetUnitY(c), 110.0, GetUnitX(td), GetUnitY(td), 110.0)
                            if GetUnitAbilityLevel(c, TojiW2_ID) == 0 then
                                call UnitAddAbility(c, TojiW2_ID)
                                call UnitMakeAbilityPermanent(c, true, TojiW2_ID)
                            endif
                            call SetUnitAbilityLevel(c, TojiW2_ID, level)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), TojiW_ID, false)
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), TojiW2_ID, true)
                            call BlzEndUnitAbilityCooldown(c, TojiW2_ID)
                        elseif r6 >= r7 then
                            set state = 2
                        endif
                    else
                        set state = 2
                    endif

                elseif state == 1 then
                    if td == null or GetUnitTypeId(td) == 0 or GetWidgetLife(td) <= 0.405 or GetUnitAbilityLevel(td,TojiW_Debuff_ID) == 0 then
                        set remove = true
                    else
                        set r = RoundReal(r + 0.03, 3)
                        set dx = GetUnitX(td) - GetUnitX(c)
                        set dy = GetUnitY(td) - GetUnitY(c)
                        set distance = SquareRoot(dx * dx + dy * dy)
                        if distance > TojiW_ChainMaxRange and GetUnitAbilityLevel(td,'Avul')==0  then
                            set angle = Atan2(dy, dx)
                            call PosUnit(td, GetUnitX(c) + TojiW_ChainMaxRange * Cos(angle), GetUnitY(c) + TojiW_ChainMaxRange * Sin(angle))
                        endif
                        call MoveLightningEx(chain, true, GetUnitX(c), GetUnitY(c), 110.0, GetUnitX(td), GetUnitY(td), 110.0)
                        if r >= TojiW_ChainDuration then
                            set remove = true
                        endif
                    endif

                elseif state == 2 then
                    set dx = GetUnitX(c) - x
                    set dy = GetUnitY(c) - y
                    set distance = SquareRoot(dx * dx + dy * dy)
                    set step = move + TojiW_ReturnMoveBonus
                    if distance <= step then
                        set remove = true
                    else
                        set angle = Atan2(dy, dx)
                        set x = x + step * Cos(angle)
                        set y = y + step * Sin(angle)
                        call BlzSetSpecialEffectPosition(e, x, y, 110.0)
                        call MoveLightningEx(chain, true, GetUnitX(c), GetUnitY(c), 110.0, x, y, 110.0)
                    endif

                elseif state == 3 then
                    if td == null or GetUnitTypeId(td) == 0 or GetWidgetLife(td) <= 0.405 or GetUnitAbilityLevel(td, TojiW_Debuff_ID) == 0 then
                        set remove = true
                    else
                        set r = RoundReal(r + 0.03, 3)
                        set pullElapsed = RoundReal(pullElapsed + 0.03, 3)
                        set step = pullMove
                        if step > pullRemaining then
                            set step = pullRemaining
                        endif
                        if step > 0.0 and GetUnitAbilityLevel(td, 'Avul') == 0 then
                            call MoveUnit(td, step, pullAngle)
                            set pullRemaining = pullRemaining - step
                        endif
                        
                        // Срабатывает один раз в момент завершения притягивания:
                        if pullElapsed >= TojiW2_PullDuration or pullRemaining <= 0.5 then
                            call DecorRemove(c, GetUnitX(td), GetUnitY(td), 350, TojiW2_DecorDamage)
                            set state = 1
                        endif

                        set dx = GetUnitX(td) - GetUnitX(c)
                        set dy = GetUnitY(td) - GetUnitY(c)
                        set distance = SquareRoot(dx * dx + dy * dy)
                        if distance > TojiW_ChainMaxRange then
                            set angle = Atan2(dy, dx)
                            call PosUnit(td, GetUnitX(c) + TojiW_ChainMaxRange * Cos(angle), GetUnitY(c) + TojiW_ChainMaxRange * Sin(angle))
                        endif
                        call MoveLightningEx(chain, true, GetUnitX(c), GetUnitY(c), 110.0, GetUnitX(td), GetUnitY(td), 110.0)
                        if r >= TojiW_ChainDuration then
                            set remove = true
                        endif
                    endif
                endif

                if remove then
                    if c != null then
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TojiW2_ID, false)
                        call SetPlayerAbilityAvailable(GetOwningPlayer(c), TojiW_ID, true)
                    endif
                    if e != null then
                        call DestroyEffect(e)
                    endif
                    if e2 != null then
                        call DestroyEffect(e2)
                    endif
                    if chain != null then
                        call DestroyLightning(chain)
                    endif
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    set e = null
                    set e2 = null
                    set chain = null
                    set g = null
                    set td = null
                    set c = null
                    call deallocate(this)
                    set m_TojiW[i] = m_TojiW[MUI_TojiW]
                    set MUI_TojiW = MUI_TojiW - 1
                    if MUI_TojiW == -1 then
                        call TojiTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            set picked = null
        endmethod

        public static method TojiW_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            set MUI_TojiW = MUI_TojiW + 1
            set m_TojiW[MUI_TojiW] = this
            set c = NewC
            set td = null
            set g = CreateGroup()
            set state = 0
            set level = GetUnitAbilityLevel(NewC, TojiW_ID)
            if level < 1 then
                set level = 1
            endif
            set a = GAngle2(NewC, NewX, NewY)
            set x = GetUnitX(NewC) + 75.0 * Cos(a)
            set y = GetUnitY(NewC) + 75.0 * Sin(a)
            set r = 0.0
            set r6 = 0.0
            set r7 = TojiW_RangeBase + TojiW_RangeStep * (level - 1)
            set move = TojiW_MoveBase + TojiW_MoveStep * (level - 1)
            set dmg = GetHeroAgi(NewC, true) * (TojiW_DamageAgiBase + TojiW_DamageAgiStep * (level - 1))
            set dmg = dmg + TojiW_Damage2StaticBase + TojiW_Damage2StaticStep * (level - 1)
            set dmg = dmg + TojiE_ConsumeLeapBonus(NewC)
            call MakeSound("war3mapimported\\Hero_Toji_W 1")
            set tdMoveSpeed = 0.0
            set tdSlowSpeed = 0.0
            set e2 = null
            set pullAngle = 0.0
            set pullMove = 0.0
            set pullRemaining = 0.0
            set pullElapsed = 0.0
            set e = AddSpecialEffect("war3mapImported\\wos_hook1.mdl", x, y)
            call BlzSetSpecialEffectScale(e, 2.10)
            call BlzSetSpecialEffectYaw(e, a)
            call BlzSetSpecialEffectZ(e, 110.0)
            set chain = AddLightningEx("TJ01", true, GetUnitX(NewC), GetUnitY(NewC), 110.0, x, y, 110.0)
            call SetUnitFacing(NewC, a * bj_RADTODEG)
            call SetUnitAnimationByIndex(NewC, 13)
            call MakeSound("war3mapImported\\Hero_Toji_W")
            call VisionTimed(GetOwningPlayer(NewC), NewX, NewY, 750, 6)
            if MUI_TojiW == 0 then
                call TojiTimer03Acquire()
            endif
        endmethod

        public static method TojiW2_Start takes unit NewC, real NewX, real NewY returns nothing
            local integer i = 0
            local thistype this
            local real casterX
            local real casterY
            local real targetX
            local real targetY
            local real baseAngle
            local real difference
            local real distance
            local real inward
            local real sideAngle
            local real pullDistance
            local integer pid
            local real tojiDx
            local real tojiDy
            loop
                exitwhen i > MUI_TojiW
                set this = m_TojiW[i]
                if c == NewC and state == 1 then
                    set casterX = GetUnitX(NewC)
                    set casterY = GetUnitY(NewC)
                    set targetX = GetUnitX(td)
                    set targetY = GetUnitY(td)
                    set baseAngle = Atan2(targetY - casterY, targetX - casterX)
                    set difference = (NewX - targetX) * Cos(baseAngle + bj_PI * 0.5) + (NewY - targetY) * Sin(baseAngle + bj_PI * 0.5)
                    set distance = SquareRoot((targetX - casterX) * (targetX - casterX) + (targetY - casterY) * (targetY - casterY))
                    if difference <= TojiW2_SideClickDeadzone and difference >= -TojiW2_SideClickDeadzone then
                        set inward = TojiW2_CenterPullRange
                        if inward > distance - 125.0 then
                            set inward = distance - 125.0
                        endif
                        if inward < 0.0 then
                            set inward = 0.0
                        endif
                        set pullX = targetX + inward * Cos(baseAngle + bj_PI)
                        set pullY = targetY + inward * Sin(baseAngle + bj_PI)
                    else
                        set inward = TojiW2_SideInwardRange
                        if inward > distance - 125.0 then
                            set inward = distance - 125.0
                        endif
                        if inward < 0.0 then
                            set inward = 0.0
                        endif
                        if difference > 0.0 then
                            set sideAngle = baseAngle + bj_PI * 0.5
                        else
                            set sideAngle = baseAngle - bj_PI * 0.5
                        endif
                        set pullX = targetX + TojiW2_SidePullRange * Cos(sideAngle) + inward * Cos(baseAngle + bj_PI)
                        set pullY = targetY + TojiW2_SidePullRange * Sin(sideAngle) + inward * Sin(baseAngle + bj_PI)
                    endif
                    set pullDistance = SquareRoot((pullX - targetX) * (pullX - targetX) + (pullY - targetY) * (pullY - targetY))
                    set pullAngle = Atan2(pullY - targetY, pullX - targetX)
                    set pullRemaining = pullDistance
                    set pullElapsed = 0.0
                    if TojiW2_PullDuration > 0.03 then
                        set pullMove = pullDistance / (TojiW2_PullDuration / 0.03)
                    else
                        set pullMove = pullDistance
                    endif
                    if pullMove < 0.0 then
                        set pullMove = 0.0
                    endif
                    set state = 3
                    call MakeSound("war3mapImported\\Hero_Toji_W2 1")

                    // Возобновление движения на бегу
                    set pid = GetPlayerId(GetOwningPlayer(NewC))
                    set tojiDx = Toji_LastOrderX[pid] - casterX
                    set tojiDy = Toji_LastOrderY[pid] - casterY
                    if Toji_IsMoving[pid] and (tojiDx * tojiDx + tojiDy * tojiDy > 100.0 * 100.0) then
                        call IssuePointOrder(NewC, "move", Toji_LastOrderX[pid], Toji_LastOrderY[pid])
                    endif

                    set i = MUI_TojiW + 1
                else
                    set i = i + 1
                endif
            endloop
        endmethod
    endstruct

    private struct TojiSpells_E
        private static integer array m_TojiE
        private static integer MUI_TojiE = -1

        unit c
        real r2
        group scanGroup
        group hitGroup
        effect e
        real a
        real move
        real traveled
        real distance
        real attackDamage
        boolean level25

        public static method Loop_TojiE takes nothing returns nothing
            local integer i = 0
            local thistype this
            local unit target
            local real step
            local boolean remove
            loop
                exitwhen i > MUI_TojiE
                set this = m_TojiE[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or GetWidgetLife(c) <= 0.405 then
                    set remove = true
                elseif traveled < distance then
                    set step = move
                    if r2 > 0.0 then
                        set r2 = 0.0
                        call DecorRemove(c, GetUnitX(c), GetUnitY(c), TojiE_HitAoe, TojiE_DecorDamage)
                    else
                        set r2 = r2 + 0.03
                    endif
                    call MoveUnit(c, step, a)
                    call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_blackblink.mdx", GetUnitX(c), GetUnitY(c), a * bj_RADTODEG + 90, 3, 1.35, GetUnitFlyHeight(c), 0, 0, 0, 255))
                    set traveled = traveled + step
                    call BlzSetSpecialEffectPosition(e, GetUnitX(c), GetUnitY(c), 50.0)

                    if level25 then
                        call GroupClear(scanGroup)
                        call GroupEnumUnitsInRange(scanGroup, GetUnitX(c), GetUnitY(c), TojiE_HitAoe, Condition(function NoDecor_Filter))
                        loop
                            set target = FirstOfGroup(scanGroup)
                            exitwhen target == null
                            call GroupRemoveUnit(scanGroup, target)
                            if IsUnitEnemy(target, GetOwningPlayer(c)) and SpellBool(target) and not IsUnitInGroup(target, hitGroup) then
                                call GroupAddUnit(hitGroup, target)
                                call dmgphys(c, target, TojiAbilityDamage(c, target, attackDamage))
                                call MUE(target, TojiE_Level25ThrowRange, TojiE_Level25ThrowDuration, a)
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", target, "chest"))
                            endif
                        endloop
                    endif
                    if traveled >= distance then
                        set remove = true
                    endif
                else
                    set remove = true
                endif

                if remove then
                    if c != null then
                        call SetUnitTimeScale(c, 1.0)
                    endif
                    if e != null then
                        call DestroyEffect(e)
                    endif
                    call DestroyGroup(scanGroup)
                    call DestroyGroup(hitGroup)
                    set e = null
                    set scanGroup = null
                    set hitGroup = null
                    set c = null
                    set target = null
                    call deallocate(this)
                    set m_TojiE[i] = m_TojiE[MUI_TojiE]
                    set MUI_TojiE = MUI_TojiE - 1
                    if MUI_TojiE == -1 then
                        call TojiTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            set target = null
        endmethod

        public static method InitCharges takes unit whichUnit returns nothing
            local integer abilityLevel = GetUnitAbilityLevel(whichUnit, TojiE_ID)
            local real recharge
            if abilityLevel < 1 then
                set abilityLevel = 1
            elseif abilityLevel > 5 then
                set abilityLevel = 5
            endif
            set recharge = TojiE_RechargeBase - TojiE_RechargeStep * (abilityLevel - 1)
            call SpellStacksStart(whichUnit, TojiE_ID, 0, TojiE_MaxCharges, recharge)
        endmethod

        public static method TojiE_Start takes unit NewC, real NewX, real NewY returns nothing
            local integer abilityLevel = GetUnitAbilityLevel(NewC, TojiE_ID)
            local integer diceCount
            local integer diceSides
            local integer dice = 0
            local real startX = GetUnitX(NewC)
            local real startY = GetUnitY(NewC)
            local real dx = NewX - startX
            local real dy = NewY - startY
            local real targetDistance = SquareRoot(dx * dx + dy * dy)
            local real maxDistance
            local thistype this
            
            if abilityLevel < 1 then
                set abilityLevel = 1
            endif
            set maxDistance = TojiE_RangeBase + TojiE_RangeStep * (abilityLevel - 1)
            set targetDistance = maxDistance
            call thistype.InitCharges(NewC)
            if SpellStacksGet(NewC) <= 0 and BlzGetUnitAbilityCooldownRemaining(NewC, TojiE_ID) <= 0.00 then
                call SpellStacksAdd(NewC, 1)
            endif
            if not SpellStacksTryUse(NewC) then
                return
            endif

            if targetDistance <= 1.0 then
                if GetHeroLevel(NewC) >= 25 then
                    call TojiE_AddLeapBuff(NewC)
                endif
                return
            endif

            set this = thistype.create()
            set MUI_TojiE = MUI_TojiE + 1
            set m_TojiE[MUI_TojiE] = this
            set c = NewC
            set scanGroup = CreateGroup()
            set hitGroup = CreateGroup()
            set a = Atan2(dy, dx)
            set traveled = 0.0
            call ColorDummy32(c, 0, 255, 255, 255, 0.15)
            call ColorDummy4(c, 0.3, 255, 255, 255, 0.15)
            set distance = targetDistance
            if TojiE_DashDuration > 0.03 then
                set move = targetDistance / (TojiE_DashDuration / 0.03)
            else
                set move = targetDistance
            endif
            if move < 1.0 then
                set move = 1.0
            endif
            set level25 = GetHeroLevel(NewC) >= 25
            set attackDamage = 0.0
            if level25 then
                set diceCount = BlzGetUnitDiceNumber(NewC, 0)
                set diceSides = BlzGetUnitDiceSides(NewC, 0)
                set attackDamage = I2R(BlzGetUnitBaseDamage(NewC, 0))
                loop
                    exitwhen dice >= diceCount
                    set attackDamage = attackDamage + GetRandomInt(1, diceSides)
                    set dice = dice + 1
                endloop
                set attackDamage = attackDamage * (TojiE_Level25DamageAtk / 100.00) + GetHeroAgi(NewC, true) * TojiE_Level25DamageAgi
                call TojiE_AddLeapBuff(NewC)
            endif
            
            call BlzSetUnitFacingEx(c, a * bj_RADTODEG)
            call SetUnitAnimationByIndex(NewC, 4)
            call SetAnimIndex(c, 0.03, 4)
            call SetUnitTimeScale(NewC, 2.0)
            set e = AddSpecialEffectTarget("war3mapimported\\wos_Windwalk Black.mdx", c, "origin")
            if IntegerCd(c, "sound e cd", 10) then 
                if GetRandomInt(1, 2) == 1 then 
                    call MakeSound("war3mapimported\\Hero_Toji_E3")
                else
                    call MakeSound("war3mapimported\\Hero_Toji_E4")
                endif
            endif
            if GetRandomInt(1, 2) == 1 then 
                call MakeSound("war3mapimported\\Hero_Toji_E")
            else
                call MakeSound("war3mapimported\\Hero_Toji_E2")
            endif
            if MUI_TojiE == 0 then
                call TojiTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct TojiSpells_R_Insectoids
        private static integer array m_TojiRI
        private static integer MUI_TojiRI = -1

        unit c
        group scanGroup
        group damageGroup
        group affectedGroup
        group keepGroup
        real startX
        real startY
        real centerX
        real centerY
        real elapsed
        real scanClock
        real r5
        real damageClock
        real damagePerSecond
        real leapBonus
        integer effectParent
        boolean casterInside
        boolean invisAdded
        boolean invisPrepared

        public static method Loop_TojiRI takes nothing returns nothing
            local integer i = 0
            local integer n
            local integer hid
            local integer invisLevel
            local thistype this
            local unit target
            local effect mosquito
            local group swapGroup
            local real progress
            local real targetX
            local real targetY
            local real targetZ
            local real moveX
            local real moveY
            local real moveZ
            local real moveAngle
            local real moveDistance
            local real moveStart
            local real boundaryDistance
            local real dx
            local real dy
            local real damage
            local boolean inside
            local boolean hit
            local boolean remove
            loop
                exitwhen i > MUI_TojiRI
                set this = m_TojiRI[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 then
                    set remove = true
                else
                    set elapsed = RoundReal(elapsed + 0.03, 3)

                    if elapsed <= 0.80 then
                        set progress = elapsed / 0.80
                        if progress > 1.0 then
                            set progress = 1.0
                        endif
                        set n = 0
                        loop
                            exitwhen n >= 48
                            set mosquito = LoadEffectHandle(TojiR_Hash, effectParent, n)
                            set targetX = LoadReal(TojiR_Hash, effectParent, 1000 + n)
                            set targetY = LoadReal(TojiR_Hash, effectParent, 2000 + n)
                            set targetZ = LoadReal(TojiR_Hash, effectParent, 3000 + n)
                            if mosquito != null then
                                call BlzSetSpecialEffectPosition(mosquito, startX + (targetX - startX) * progress, startY + (targetY - startY) * progress, 70.0 + (targetZ - 70.0) * progress)
                            endif
                            set n = n + 1
                        endloop
                    else
                        set n = 0
                        loop
                            exitwhen n >= 48
                            set mosquito = LoadEffectHandle(TojiR_Hash, effectParent, n)
                            if mosquito != null then
                                if LoadInteger(TojiR_Hash, effectParent, 12000 + n) == 0 and elapsed >= LoadReal(TojiR_Hash, effectParent, 4000 + n) then
                                    set targetX = LoadReal(TojiR_Hash, effectParent, 1000 + n)
                                    set targetY = LoadReal(TojiR_Hash, effectParent, 2000 + n)
                                    set targetZ = LoadReal(TojiR_Hash, effectParent, 3000 + n)
                                    set moveAngle = GetRandomReal(0.0, 2.0 * bj_PI)
                                    set moveDistance = GetRandomReal(150.0, 550.0)
                                    set moveX = targetX + moveDistance * Cos(moveAngle)
                                    set moveY = targetY + moveDistance * Sin(moveAngle)

                                    set dx = moveX - centerX
                                    set dy = moveY - centerY
                                    set boundaryDistance = SquareRoot(dx * dx + dy * dy)
                                    if boundaryDistance > TojiR_Aoe + 135.0 then
                                        set moveAngle = Atan2(centerY - targetY, centerX - targetX) + GetRandomReal(-0.75, 0.75)
                                        set moveX = targetX + moveDistance * Cos(moveAngle)
                                        set moveY = targetY + moveDistance * Sin(moveAngle)
                                        set dx = moveX - centerX
                                        set dy = moveY - centerY
                                        set boundaryDistance = SquareRoot(dx * dx + dy * dy)
                                        if boundaryDistance > TojiR_Aoe + 135.0 then
                                            set moveX = centerX + dx * ((TojiR_Aoe + 135.0) / boundaryDistance)
                                            set moveY = centerY + dy * ((TojiR_Aoe + 135.0) / boundaryDistance)
                                        endif
                                    endif

                                    set moveZ = GetRandomReal(40.0, 280.0)

                                    call SaveReal(TojiR_Hash, effectParent, 5000 + n, targetX)
                                    call SaveReal(TojiR_Hash, effectParent, 6000 + n, targetY)
                                    call SaveReal(TojiR_Hash, effectParent, 7000 + n, targetZ)
                                    call SaveReal(TojiR_Hash, effectParent, 8000 + n, moveX)
                                    call SaveReal(TojiR_Hash, effectParent, 9000 + n, moveY)
                                    call SaveReal(TojiR_Hash, effectParent, 10000 + n, moveZ)
                                    call SaveReal(TojiR_Hash, effectParent, 11000 + n, elapsed)
                                    call SaveReal(TojiR_Hash, effectParent, 4000 + n, elapsed + GetRandomReal(0.81, 1.02))
                                    call SaveInteger(TojiR_Hash, effectParent, 12000 + n, 1)
                                    call BlzSetSpecialEffectYaw(mosquito, Atan2(moveY - targetY, moveX - targetX))
                                endif

                                if LoadInteger(TojiR_Hash, effectParent, 12000 + n) == 1 then
                                    set targetX = LoadReal(TojiR_Hash, effectParent, 5000 + n)
                                    set targetY = LoadReal(TojiR_Hash, effectParent, 6000 + n)
                                    set targetZ = LoadReal(TojiR_Hash, effectParent, 7000 + n)
                                    set moveX = LoadReal(TojiR_Hash, effectParent, 8000 + n)
                                    set moveY = LoadReal(TojiR_Hash, effectParent, 9000 + n)
                                    set moveZ = LoadReal(TojiR_Hash, effectParent, 10000 + n)
                                    set moveStart = LoadReal(TojiR_Hash, effectParent, 11000 + n)
                                    set progress = (elapsed - moveStart) / 0.81
                                    if progress >= 1.0 then
                                        set progress = 1.0
                                        call SaveReal(TojiR_Hash, effectParent, 1000 + n, moveX)
                                        call SaveReal(TojiR_Hash, effectParent, 2000 + n, moveY)
                                        call SaveReal(TojiR_Hash, effectParent, 3000 + n, moveZ)
                                        call SaveInteger(TojiR_Hash, effectParent, 12000 + n, 0)
                                    endif
                                    call BlzSetSpecialEffectPosition(mosquito, targetX + (moveX - targetX) * progress, targetY + (moveY - targetY) * progress, targetZ + (moveZ - targetZ) * progress)
                                endif
                            endif
                            set n = n + 1
                        endloop

                        set scanClock = RoundReal(scanClock + 0.03, 3)
                        set damageClock = RoundReal(damageClock + 0.03, 3)
                        set inside = false
                        if GetWidgetLife(c) > 0.405 then
                            set dx = GetUnitX(c) - centerX
                            set dy = GetUnitY(c) - centerY
                            set inside = dx * dx + dy * dy <= TojiR_Aoe * TojiR_Aoe
                        endif

                        if inside then
                            set casterInside = true
                            call UnitRemoveAbility(c, TojiR_SlowBuff_ID)
                            call UnitRemoveAbility(c, 'B01B')
                            call UnitRemoveAbility(c, 'B01A')
                            call UnitRemoveAbility(c, 'B01C')
                            call UnitRemoveAbility(c, 'B019')
                            call UnitRemoveAbility(c, 'B00T')
                            if not invisPrepared then
                                set invisLevel = GetUnitAbilityLevel(c, TojiR_InvisAbility2_ID)
                                if invisLevel == 0 then
                                    call UnitAddAbility(c, TojiR_InvisAbility2_ID)
                                    call UnitMakeAbilityPermanent(c, true, TojiR_InvisAbility2_ID)
                                    call SetPlayerAbilityAvailable(GetOwningPlayer(c), TojiR_InvisAbility2_ID, true)
                                    set invisAdded = true
                                endif
                                set invisPrepared = true
                            endif
                            
                            if GetUnitAbilityLevel(c, TojiR_InvisBuff_ID) == 0 then
                                call SetPlayerAbilityAvailable(GetOwningPlayer(c), TojiR_InvisAbility2_ID, true)
                                call IssueImmediateOrder(c, "windwalk")
                            else
                                call SetPlayerAbilityAvailable(GetOwningPlayer(c), TojiR_InvisAbility2_ID, false)
                            endif
                        elseif casterInside then
                            set casterInside = false
                            call UnitRemoveAbility(c, TojiR_InvisBuff_ID)
                            if invisAdded then
                                call UnitRemoveAbility(c, TojiR_InvisAbility2_ID)
                                set invisAdded = false
                            else
                                call SetPlayerAbilityAvailable(GetOwningPlayer(c), TojiR_InvisAbility2_ID, true)
                            endif
                            set invisPrepared = false
                        endif

                        if scanClock >= 0.12 then
                            set scanClock = RoundReal(scanClock - 0.12, 3)
                            call GroupClear(scanGroup)
                            call GroupEnumUnitsInRange(scanGroup, centerX, centerY, TojiR_Aoe, Condition(function NoDecor_Filter))
                            call GroupClear(keepGroup)

                            loop
                                set target = FirstOfGroup(affectedGroup)
                                exitwhen target == null
                                call GroupRemoveUnit(affectedGroup, target)
                                if IsUnitInGroup(target, scanGroup) and IsUnitEnemy(target, GetOwningPlayer(c)) and SpellBool(target) then
                                    call GroupAddUnit(keepGroup, target)
                                endif
                            endloop

                            loop
                                set target = FirstOfGroup(scanGroup)
                                exitwhen target == null
                                call GroupRemoveUnit(scanGroup, target)
                                if IsUnitEnemy(target, GetOwningPlayer(c)) and SpellBool(target) then
                                    set hid = GetHandleId(target)
                                    if not IsUnitInGroup(target, keepGroup) then
                                        call GroupAddUnit(keepGroup, target)
                                    endif
                                    call SlowUnit(c, target, TojiR_SlowPercent, TojiR_SlowDuration)
                                endif
                            endloop
                            set swapGroup = affectedGroup
                            set affectedGroup = keepGroup
                            set keepGroup = swapGroup
                            set swapGroup = null
                        endif

                        if damageClock >= TojiR_DamageInterval then
                            set damageClock = RoundReal(damageClock - TojiR_DamageInterval, 3)
                            set damage = damagePerSecond * TojiR_DamageInterval + leapBonus
                            set hit = false
                            call DecorRemove(c, centerX, centerY, TojiR_Aoe, TojiR_DecorDamage)
                            call GroupClear(damageGroup)
                            call GroupEnumUnitsInRange(damageGroup, centerX, centerY, TojiR_Aoe, Condition(function NoDecor_Filter))
                            loop
                                set target = FirstOfGroup(damageGroup)
                                exitwhen target == null
                                call GroupRemoveUnit(damageGroup, target)
                                if IsUnitEnemy(target, GetOwningPlayer(c)) and SpellBool(target) then
                                    call dmgphys(c, target, TojiAbilityDamage(c, target, damage))
                                    set hit = true
                                endif
                            endloop
                            if hit then
                                set leapBonus = 0.0
                            endif
                        endif

                        if elapsed >= 0.80 + r5 then
                            set remove = true
                        endif
                    endif
                endif

                if remove then
                    if c != null and GetUnitTypeId(c) != 0 and invisPrepared then
                        call UnitRemoveAbility(c, TojiR_InvisBuff_ID)
                        if invisAdded then
                            call UnitRemoveAbility(c, TojiR_InvisAbility2_ID)
                        else
                            call SetPlayerAbilityAvailable(GetOwningPlayer(c), TojiR_InvisAbility2_ID, true)
                        endif
                    endif

                    set n = 0
                    loop
                        exitwhen n >= 48
                        set mosquito = LoadEffectHandle(TojiR_Hash, effectParent, n)
                        if mosquito != null then
                            call ColorEffDummy3(mosquito, 0, 255, 255, 255, 0.3)
                        endif
                        set n = n + 1
                    endloop
                    call FlushChildHashtable(TojiR_Hash, effectParent)
                    call DestroyGroup(scanGroup)
                    call DestroyGroup(damageGroup)
                    call DestroyGroup(affectedGroup)
                    call DestroyGroup(keepGroup)
                    set scanGroup = null
                    set damageGroup = null
                    set affectedGroup = null
                    set keepGroup = null
                    set c = null
                    set target = null
                    set mosquito = null
                    call deallocate(this)
                    set m_TojiRI[i] = m_TojiRI[MUI_TojiRI]
                    set MUI_TojiRI = MUI_TojiRI - 1
                    if MUI_TojiRI == -1 then
                        call TojiTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            set target = null
            set mosquito = null
            set swapGroup = null
        endmethod

        public static method TojiR_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this = thistype.create()
            local integer n = 0
            local integer level
            local real angle
            local real radius
            local real targetX
            local real targetY
            local real targetZ
            local effect mosquito
            local integer red
            local integer green
            local integer blue
            set MUI_TojiRI = MUI_TojiRI + 1
            set m_TojiRI[MUI_TojiRI] = this
            set c = NewC
            set startX = GetUnitX(NewC)
            set startY = GetUnitY(NewC)
            set centerX = NewX
            set centerY = NewY
            set level = GetUnitAbilityLevel(NewC, TojiR_ID)
            if level < 1 then
                set level = 1
            endif
            set elapsed = 0.0
            set scanClock = 0.0
            set damageClock = 0.0
            set casterInside = false
            set invisAdded = false
            set invisPrepared = false
            set damagePerSecond = GetHeroAgi(NewC, true) * (TojiR_DamageAgiBase + TojiR_DamageAgiStep * (level - 1))
            set damagePerSecond = damagePerSecond + TojiR_DamageStaticBase + TojiR_DamageStaticStep * (level - 1)
            set leapBonus = TojiE_ConsumeLeapBonus(NewC)
            set scanGroup = CreateGroup()
            set damageGroup = CreateGroup()
            set affectedGroup = CreateGroup()
            set keepGroup = CreateGroup()
            set effectParent = StringHash("TojiR_MosquitoEffects") + this
            loop
                exitwhen n >= 48
                set angle = GetRandomReal(0.0, 2.0 * bj_PI)
                set radius = TojiR_Aoe * SquareRoot(GetRandomReal(0.0, 1.1))
                set targetX = NewX + radius * Cos(angle)
                set targetY = NewY + radius * Sin(angle)
                set targetZ = GetRandomReal(40.0, 280.0)
                if GetRandomInt(1, 2) == 1 then 
                    set mosquito = AddSpecialEffect("units\\undead\\Locust\\Locust.mdl", startX, startY)
                    call BlzSetSpecialEffectScale(mosquito, GetRandomReal(1.75, 2.75))
                else
                    set mosquito = AddSpecialEffect("war3mapimported\\wos_monster_210.mdl", startX, startY)
                    call BlzSetSpecialEffectScale(mosquito, GetRandomReal(1.75 * 0.4, 2.75 * 0.4))
                endif   
                set r5 = TojiR_DurationBase + (TojiR_DurationStep * (level - 1))
                set red = GetRandomInt(1, 255)
                set green = GetRandomInt(1, 255)
                set blue = GetRandomInt(1, 255)
                call BlzSetSpecialEffectTimeScale(mosquito, GetRandomReal(0.5, 1))
                call BlzSetSpecialEffectPosition(mosquito, startX, startY, GetRandomReal(25, 125))
                call BlzSetSpecialEffectYaw(mosquito, Atan2(targetY - startY, targetX - startX))
                call BlzSetSpecialEffectAlpha(mosquito, 0)
                call ColorEffDummy4(mosquito, 0, red, green, blue, 0.35)
                call SaveEffectHandle(TojiR_Hash, effectParent, n, mosquito)
                call SaveReal(TojiR_Hash, effectParent, 1000 + n, targetX)
                call SaveReal(TojiR_Hash, effectParent, 2000 + n, targetY)
                call SaveReal(TojiR_Hash, effectParent, 3000 + n, targetZ)
                call SaveReal(TojiR_Hash, effectParent, 4000 + n, 0.80)
                call SaveInteger(TojiR_Hash, effectParent, 12000 + n, 0)
                set n = n + 1
            endloop
            set mosquito = null
            call VisionTimed(GetOwningPlayer(NewC), NewX, NewY, TojiR_Aoe, 0.80 + r5)
            call MakeSound("war3mapImported\\Hero_Toji_R")
            if MUI_TojiRI == 0 then
                call TojiTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct TojiSpells_G_Debuff
        private static integer array m_TojiG_Debuff
        private static integer MUI_TojiG_Debuff = -1

        unit td
        real elapsed
        real missing

        public static method Loop_TojiG_Debuff takes nothing returns nothing
            local integer i = 0
            local thistype this
            local boolean hasDebuff
            local boolean remove
            loop
                exitwhen i > MUI_TojiG_Debuff
                set this = m_TojiG_Debuff[i]
                set elapsed = RoundReal(elapsed + TojiG_DebuffTrackPeriod, 3)
                set hasDebuff = GetUnitAbilityLevel(td, TojiG_Debuff1_ID) > 0 or GetUnitAbilityLevel(td, TojiG_Debuff2_ID) > 0 or GetUnitAbilityLevel(td, TojiG_Debuff3_ID) > 0 or GetUnitAbilityLevel(td, TojiG_Debuff4_ID) > 0 or GetUnitAbilityLevel(td, TojiG_Debuff5_ID) > 0
                set remove = td == null or GetWidgetLife(td) <= 0.405 or elapsed >= TojiG_DebuffMaxDuration

                if hasDebuff then
                    set missing = 0.00
                else
                    set missing = RoundReal(missing + TojiG_DebuffTrackPeriod, 3)
                    if missing >= 0.20 then
                        set remove = true
                    endif
                endif

                if remove then
                    if elapsed >= TojiG_DebuffMaxDuration and td != null then
                        call UnitRemoveAbility(td, TojiG_Debuff1_ID)
                        call UnitRemoveAbility(td, TojiG_Debuff2_ID)
                        call UnitRemoveAbility(td, TojiG_Debuff3_ID)
                        call UnitRemoveAbility(td, TojiG_Debuff4_ID)
                        call UnitRemoveAbility(td, TojiG_Debuff5_ID)
                    endif
                    set td = null
                    set m_TojiG_Debuff[i] = m_TojiG_Debuff[MUI_TojiG_Debuff]
                    set MUI_TojiG_Debuff = MUI_TojiG_Debuff - 1
                    call deallocate(this)
                    set i = i - 1
                    if MUI_TojiG_Debuff == -1 then
                        call TojiTimer05Release()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method Start takes unit NewTd returns nothing
            local integer i = 0
            local thistype this
            loop
                exitwhen i > MUI_TojiG_Debuff
                set this = m_TojiG_Debuff[i]
                if td == NewTd then
                    set missing = 0.00
                    return
                endif
                set i = i + 1
            endloop

            set this = thistype.create()
            set td = NewTd
            set elapsed = 0.00
            set missing = 0.00
            set MUI_TojiG_Debuff = MUI_TojiG_Debuff + 1
            set m_TojiG_Debuff[MUI_TojiG_Debuff] = this
            if MUI_TojiG_Debuff == 0 then
                call TojiTimer05Acquire()
            endif
        endmethod
    endstruct

    private struct TojiSpells_G
        private static integer array m_TojiG
        private static integer MUI_TojiG = -1

        unit c
        unit td
        unit u
        group g
        group g2
        effect e
        effect e2
        integer check
        real a
        real r
        real r2
        real move
        real aoe
        real dmg

        public static method Loop_TojiG takes nothing returns nothing
            local integer i = 0
            local thistype this
            loop
                exitwhen i > MUI_TojiG
                set this = m_TojiG[i]
                if SpellBoolCaster(c) and r <= TojiG_MaxFlightTime then
                    set r = RoundReal(r + TojiG_Period, 3)
                    if check == 0 then
                        if TojiG_IsInvul then
                            call DebugUnit(c)
                        else
                            call DebugUnit2(c)
                        endif
                        set a = GAngle(c, td)
                        call SetUnitFacing(c, a * bj_RADTODEG)
                        if r >= TojiG_CastTime then
                            if TojiG_IsInvul then
                                call StopSpellUnit(c)
                            else
                                call StopSpellUnit2(c)
                            endif
                            set check = 1
                            set move = TojiG_ProjectileMove
                            call MakeSound("war3mapimported\\Hero_Alucard_Q2")
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_alucard bulletfire.mdl", GetUnitX(c) + 195.00 * Cos(a), GetUnitY(c) + 195.00 * Sin(a), a * bj_RADTODEG, 1.00, 3.00, 100.00))
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_alucard bulletfire.mdl", GetUnitX(c) + 130.00 * Cos(a), GetUnitY(c) + 130.00 * Sin(a), a * bj_RADTODEG, 1.00, 2.00, 100.00))
                            set e = EffectSpawn("war3mapImported\\wos_alucard bullet.mdl", GetUnitX(c) + 130.00 * Cos(a), GetUnitY(c) + 130.00 * Sin(a), a * bj_RADTODEG, 1.00, 0.90, 150.00)
                            set e2 = EffectSpawn("war3mapImported\\wos_Marco bullet.mdl", GetUnitX(c) + 195.00 * Cos(a), GetUnitY(c) + 195.00 * Sin(a), a * bj_RADTODEG, 0.50, 1.50, 150.00)
                            call ColorEffDummy3(EffectSpawn("war3mapImported\\wos_alucard bullet_backward.mdl", GetUnitX(c) + 130.00 * Cos(a), GetUnitY(c) + 130.00 * Sin(a), GetRandomReal(0.00, 359.00), 1.00, 1.35, 0.00), 1, 255, 255, 255, 1.00)
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun1.mdl", GetUnitX(c) + 255.00 * Cos(a), GetUnitY(c) + 255.00 * Sin(a), a * bj_RADTODEG, 0.90, 1.75, 115.00))
                            set r = 0.00
                        endif
                    else
                        set a = GAngle5(e, GetUnitX(td), GetUnitY(td))
                        call MoveEff(e, move, a)
                        call MoveEff(e2, move, a)
                        call BlzSetSpecialEffectYaw(e, a)
                        call BlzSetSpecialEffectYaw(e2, a)
                        call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_BY_Wood_Effect_Kula_2_YiYingCun1.mdl", GetEffX(e) + 155.00 * Cos(a), GetEffY(e) + 155.00 * Sin(a), a * bj_RADTODEG, 1.15, 0.75, 135.00, 255, 125, 125, 255))
                        call GroupClear(g)
                        call GroupEnumUnitsInRange(g, GetEffX(e), GetEffY(e), aoe, Condition(function NoDecor_Filter))
                        loop
                            set u = FirstOfGroup(g)
                            exitwhen u == null
                            if SpellBool(u) and IsUnitEnemy(u, GetOwningPlayer(c)) and not IsUnitInGroup(u, g2) then
                                call dmgphys(c, u, TojiAbilityDamage(c, u, dmg))
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                call GroupAddUnit(g2, u)
                            endif
                            call GroupRemoveUnit(g, u)
                        endloop
                        set u = null
                        if SR5(e, GetUnitX(td), GetUnitY(td)) < 120.00 then
                            set r = 9999.00
                        endif
                        if r2 >= TojiG_Period then
                            set r2 = 0.00
                            call DecorRemove(c, GetEffX(e), GetEffY(e), aoe, TojiG_DecorDamage)
                            call VisionTimed(GetOwningPlayer(c), GetEffX(e), GetEffY(e), 700.00, 1.00)
                        else
                            set r2 = RoundReal(r2 + TojiG_Period, 3)
                        endif
                    endif
                else
                    if r == 9999.00 and td != null and GetWidgetLife(td) > 0.405 then
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_blood impact.mdl", GetUnitX(td), GetUnitY(td), a * bj_RADTODEG, 1.00, 2.50, 0.00))
                        call DestroyEffect(EffectSpawn("war3mapImported\\wos_bloodex-special-23.mdl", GetUnitX(td), GetUnitY(td), GetRandomReal(0.00, 359.00), 2.50, 2.00, 80.00))
                        call StunUnit(c, td, TojiG_StunTime)
                        if GetUnitAbilityLevel(td, TojiG_Debuff1_ID) == 0 and GetUnitAbilityLevel(td, TojiG_Debuff2_ID) == 0 and GetUnitAbilityLevel(td, TojiG_Debuff3_ID) == 0 and GetUnitAbilityLevel(td, TojiG_Debuff4_ID) == 0 and GetUnitAbilityLevel(td, TojiG_Debuff5_ID) == 0 then
                            call BuffUnit01(c, td, TojiG_AbiDebuff_ID, "curse", 1)
                        endif
                        call TojiSpells_G_Debuff.Start(td)
                    endif
                    call SaveInteger(hs, GetHandleId(GetOwningPlayer(c)), StringHash(I2S(TojiG_ID)), 1)
                    call DestroyEffect(e)
                    call DestroyEffect(e2)
                    call SaveInteger(hs, GetHandleId(td), StringHash("toji bullet"), 0)
                    call SetUnitTimeScale(c, 1.00)
                    if r <= 0.42 then
                        if TojiG_IsInvul then
                            call StopSpellUnit(c)
                        else
                            call StopSpellUnit2(c)
                        endif
                    endif
                    call DestroyGroup(g)
                    call DestroyGroup(g2)
                    set g = null
                    set g2 = null
                    set e = null
                    set e2 = null
                    set c = null
                    set td = null
                    set u = null
                    set m_TojiG[i] = m_TojiG[MUI_TojiG]
                    set MUI_TojiG = MUI_TojiG - 1
                    call deallocate(this)
                    set i = i - 1
                    if MUI_TojiG == -1 then
                        call TojiTimer05Release()
                    endif
                endif
                set i = i + 1
            endloop
        endmethod

        public static method TojiG_Start takes unit NewC, unit NewTd returns nothing
            local thistype this
            local integer level
            if NewC == null or NewTd == null or GetWidgetLife(NewTd) <= 0.405 then
                return
            endif
            set this = thistype.create()
            set MUI_TojiG = MUI_TojiG + 1
            set m_TojiG[MUI_TojiG] = this
            set c = NewC
            set td = NewTd
            set r = 0.00
            set r2 = 0.00
            set move = 0.00
            set check = 0
            set u = null
            set e = null
            set e2 = null
            set g = CreateGroup()
            set g2 = CreateGroup()
            set level = GetUnitAbilityLevel(NewC, TojiG_ID)
            if level < 1 then
                set level = 1
            endif
            set aoe = TojiG_DamageAoe + 25.00
            set dmg = GetHeroAgi(NewC, true) * (TojiG_DamageAgiBase + TojiG_DamageAgiStep * (level - 1))
            set dmg = dmg + TojiG_DamageStaticBase + TojiG_DamageStaticStep * (level - 1) + TojiE_ConsumeLeapBonus(NewC)
            set a = GAngle(NewC, NewTd)
            if TojiG_IsInvul then
                call StartSpellUnit(NewC)
            else
                call StartSpellUnit2(NewC)
            endif
            call SetUnitFacing(NewC, a * bj_RADTODEG)
            call MakeSound("war3mapimported\\Hero_Toji_G2 1")
            call MakeSound("war3mapimported\\Hero_Toji_G2 2")
            call SetUnitAnimationByIndex(NewC, 5)
            call SetUnitTimeScale(NewC, 0.65)
            call SaveInteger(hs, GetHandleId(NewTd), StringHash("toji bullet"), 1)
            if MUI_TojiG == 0 then
                call TojiTimer05Acquire()
            endif
        endmethod
    endstruct

    private struct TojiSpells_T
        private static integer array m_TojiT
        private static integer MUI_TojiT = -1

        unit c
        group g
        integer state
        integer hits
        real x
        real r2
        real y
        real r
        real dmg
        boolean pierceAdded

        public static method Loop_TojiT takes nothing returns nothing
            local integer i = 0
            local thistype this
            local unit u
            local real x1
            local real y1
            local real rr1 
            local real rr2
            local real progress
            local integer k 
            local integer k2
            local boolean remove

            loop
                exitwhen i > MUI_TojiT
                set this = m_TojiT[i]
                set remove = false

                if c == null or GetUnitTypeId(c) == 0 or GetWidgetLife(c) <= 0.405 then
                    set remove = true
                else
                    if TojiT_IsInvul then
                        call DebugUnit(c)
                    else
                        call DebugUnit2(c)
                    endif
                    call PosUnit(c, x, y)
                    if state == 0 then
                        set r = RoundReal(r + 0.03, 3)
                        if r2 >= 0.42 then
                            set r2 = 0.0
                            call MakeSound("war3mapImported\\Hero_Toji_T4")
                            call DestroyEffect(EffectSpawn("war3mapImported\\wos_ZarakiWCrack1.mdx", x, y, GetRandomReal(0, 359), 1.25, 2.15, 0))
                            call DestroyEffect(EffectSpawnColor("war3mapImported\\wos_firefly-rr-sfx9.mdl", x, y, GetRandomReal(0, 359), 1.15, 5.55, 650, 255, 255, 255, 145))
                        else
                            set r2 = RoundReal(r2 + 0.03, 3)
                        endif
                        if r >= TojiT_HitInterval then
                            call MakeSound("war3mapImported\\Hero_Toji_T3")
                            set r = RoundReal(r - TojiT_HitInterval, 3)
                            set k = 0
                            set k2 = 2
                            loop
                                exitwhen k == k2
                                set rr1 = GetRandomReal(0, 359) * bj_DEGTORAD
                                set rr2 = GetRandomReal(275, 620)
                                set x1 = x + rr2 * Cos(rr1)
                                set y1 = y + rr2 * Sin(rr1)
                                call DestroyEffect(EffectSpawn("war3mapImported\\wos_NewDirtEXNofire.mdl", x1, y1, GetRandomReal(0, 359), 1.15, 2.05, 0))
                                set k = k + 1
                            endloop
                      
                            call DecorRemove(c, x, y, TojiT_DamageAoe, TojiT_DecorDamage)
                            call DestroyEffect(EffectSpawn3("war3mapImported\\wos_blue_circular.mdl", x, y, GetRandomReal(0, 359), 1.15, 1.25, 425, -45))
                            call GroupClear(g)
                            call GroupEnumUnitsInRange(g, x, y, TojiT_DamageAoe, Condition(function NoDecor_Filter))
                            loop
                                set u = FirstOfGroup(g)
                                exitwhen u == null
                                call GroupRemoveUnit(g, u)
                                if IsUnitEnemy(u, GetOwningPlayer(c)) and SpellBool(u) then
                                    call dmgphys(c, u, TojiAbilityDamage(c, u, dmg))
                                    call BuffUnit01(c, u, TojiG_AbiShieldPierce_ID, "curse", 1)
                                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", u, "chest"))
                                endif
                            endloop

                            set hits = hits + 1
                            if hits >= TojiT_HitCount then
                                set state = 1
                                set r = 0.0
                            endif
                        endif
                    else
                        set r = RoundReal(r + 0.03, 3)
                        set progress = r / TojiT_DescendDuration
                        if progress > 1.0 then
                            set progress = 1.0
                        endif
                        call SetUnitFlyHeight(c, TojiT_FlyHeight * (1.0 - progress), 0.0)
                        if r >= TojiT_DescendDuration then
                            call SetUnitFlyHeight(c, 0.0, 0.0)
                            call BlinkEff(c)
                            set remove = true
                        endif
                    endif
                endif

                if remove then
                    if c != null and GetUnitTypeId(c) != 0 then
                        call SetUnitFlyHeight(c, 0.0, 0.0)
                        call SetUnitTimeScale(c, 1.0)
                        if TojiT_IsInvul then
                            call StopSpellUnit(c)
                        else
                            call StopSpellUnit2(c)
                        endif
                        call ResetUnitAnimation(c)
                        if pierceAdded then
                            call UnitRemoveAbility(c, TojiT_ShieldPierceBuff_ID)
                        endif
                    endif
                    
                    if g != null then
                        call DestroyGroup(g)
                    endif
                    set g = null
                    set c = null
                    set m_TojiT[i] = m_TojiT[MUI_TojiT]
                    set MUI_TojiT = MUI_TojiT - 1
                    call deallocate(this)
                    if MUI_TojiT == -1 then
                        call TojiTimer03Release()
                    endif
                else
                    set i = i + 1
                endif
            endloop
            set u = null
        endmethod

        public static method TojiT_Start takes unit NewC, real NewX, real NewY returns nothing
            local thistype this
            local real totalDamage

            if NewC == null or GetUnitTypeId(NewC) == 0 or GetWidgetLife(NewC) <= 0.405 then
                return
            endif

            set this = thistype.create()
            set MUI_TojiT = MUI_TojiT + 1
            set m_TojiT[MUI_TojiT] = this
            set c = NewC
            set g = CreateGroup()
            set state = 0
            set hits = 0
            set x = NewX
            set y = NewY
            set r = 0.0
            set r2 = 0.30
            set totalDamage = GetHeroAgi(NewC, true) * TojiT_DamageAgi + TojiE_ConsumeLeapBonus(NewC)
            set dmg = totalDamage / I2R(TojiT_HitCount)
            set pierceAdded = GetUnitAbilityLevel(NewC, TojiT_ShieldPierceBuff_ID) == 0
            if TojiT_IsInvul then
                call StartSpellUnit(c)
            else
                call StartSpellUnit2(c)
            endif
            call BlinkEff(NewC)
            call PosUnit(NewC, NewX, NewY)
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_Mdx_Effect_MirrorImage_Black.mdx", GetUnitX(c), GetUnitY(c), GetUnitFacing(c), 1, 1.8, 600))

            if GetUnitAbilityLevel(NewC, 'Amrf') == 0 then
                call UnitAddAbility(NewC, 'Amrf')
                call UnitRemoveAbility(NewC, 'Amrf')
            endif
            if pierceAdded then
                call UnitAddAbility(NewC, TojiT_ShieldPierceBuff_ID)
            endif
            call SetUnitFlyHeight(NewC, TojiT_FlyHeight, 0.0)
            call SetUnitAnimationByIndex(NewC, 8)
            call SetAnimIndex(c, 0.03, 8)
            call VisionTimed(GetOwningPlayer(NewC), NewX, NewY, TojiT_DamageAoe, TojiT_HitInterval * TojiT_HitCount + TojiT_DescendDuration)
            call MakeSound("war3mapImported\\Hero_Toji_T")
            call MakeSound("war3mapImported\\Hero_Toji_T2")

            if MUI_TojiT == 0 then
                call TojiTimer03Acquire()
            endif
        endmethod
    endstruct

    private struct TojiSpells_F
        public static method TojiF_Start takes unit NewC returns nothing
            local integer heroLevel
            local integer abilityLevel
            local integer currentMode
            local integer nextMode
            local integer oldAbilityId
            local integer hid
            local integer key
            local player owner
            local integer pid
            local boolean isMoving

            if NewC == null or GetUnitTypeId(NewC) == 0 then
                return
            endif

            set owner = GetOwningPlayer(NewC)
            set pid = GetPlayerId(owner)
            set isMoving = Toji_IsMoving[pid]

            set heroLevel = GetHeroLevel(NewC)
            set hid = GetHandleId(NewC)
            set key = StringHash("TojiQ_ArsenalMode")
            set currentMode = LoadInteger(hs, hid, key)
            if currentMode < 1 or currentMode > 3 then
                set currentMode = 1
            endif

            if currentMode == 1 then
                set oldAbilityId = TojiQ_ID
                call MakeSoundLocal("war3mapimported\\Hero_Toji_Q2 0", owner)
                if not isMoving then
                    call SetAnimIndex(NewC, 0.03, 6)
                endif
            elseif currentMode == 2 then
                set oldAbilityId = TojiQ2_ID
                call MakeSoundLocal("war3mapimported\\Hero_Toji_Q3 0", owner)
                if not isMoving then
                    call SetAnimIndex(NewC, 0.03, 9)
                endif
            else
                set oldAbilityId = TojiQ3_ID
                call MakeSoundLocal("war3mapimported\\Hero_Toji_Q1 0", owner)
                if not isMoving then
                    call SetAnimIndex(NewC, 0.03, 7)
                endif
            endif
            set abilityLevel = GetUnitAbilityLevel(NewC, oldAbilityId)
            if abilityLevel < 1 then
                set abilityLevel = GetUnitAbilityLevel(NewC, TojiQ_ID)
            endif
            if abilityLevel < 1 then
                set abilityLevel = 1
            endif

            if GetUnitAbilityLevel(NewC, TojiQ_ID) == 0 then
                call UnitAddAbility(NewC, TojiQ_ID)
                call UnitMakeAbilityPermanent(NewC, true, TojiQ_ID)
            endif
            call SetUnitAbilityLevel(NewC, TojiQ_ID, abilityLevel)

            if heroLevel >= TojiArsenalQ2HeroLevel then
                if GetUnitAbilityLevel(NewC, TojiQ2_ID) == 0 then
                    call UnitAddAbility(NewC, TojiQ2_ID)
                    call UnitMakeAbilityPermanent(NewC, true, TojiQ2_ID)
                endif
                call SetUnitAbilityLevel(NewC, TojiQ2_ID, abilityLevel)
            endif
            if heroLevel >= TojiArsenalQ3HeroLevel then
                if GetUnitAbilityLevel(NewC, TojiQ3_ID) == 0 then
                    call UnitAddAbility(NewC, TojiQ3_ID)
                    call UnitMakeAbilityPermanent(NewC, true, TojiQ3_ID)
                endif
                call SetUnitAbilityLevel(NewC, TojiQ3_ID, abilityLevel)
            endif

            if heroLevel < TojiArsenalQ2HeroLevel then
                set nextMode = 1
            elseif heroLevel < TojiArsenalQ3HeroLevel then
                if currentMode == 1 then
                    set nextMode = 2
                else
                    set nextMode = 1
                endif
            elseif currentMode == 1 then
                set nextMode = 2
            elseif currentMode == 2 then
                set nextMode = 3
            else
                set nextMode = 1
            endif

            call SetPlayerAbilityAvailable(owner, TojiQ_ID, nextMode == 1)
            call SetPlayerAbilityAvailable(owner, TojiQ2_ID, nextMode == 2)
            call SetPlayerAbilityAvailable(owner, TojiQ3_ID, nextMode == 3)
            call SaveInteger(hs, hid, key, nextMode)
            
            call DestroyEffect(EffectSpawn("war3mapImported\\wos_bdef (383).mdl", GetUnitX(NewC), GetUnitY(NewC), GetRandomReal(0, 359), 1.25, 0.6, 1))
            if GetRandomInt(1, 2) == 1 then 
                call MakeSoundLocal("war3mapimported\\Hero_Toji_F", owner)
            else
                call MakeSoundLocal("war3mapimported\\Hero_Toji_F2", owner)
            endif

            // Если герой был на бегу — мгновенно продолжаем бег без остановки
            if isMoving then
                call IssuePointOrder(NewC, "move", Toji_LastOrderX[pid], Toji_LastOrderY[pid])
            endif

            set owner = null
        endmethod
    endstruct

    private function TojiTimer03Loop takes nothing returns nothing
        call TojiSpells_Q.Loop_TojiQ()
        call TojiSpells_W.Loop_TojiW()
        call TojiSpells_E.Loop_TojiE()
        call TojiSpells_R_Insectoids.Loop_TojiRI()
        call TojiSpells_T.Loop_TojiT()
    endfunction

    private function TojiTimer05Loop takes nothing returns nothing
        call TojiSpells_G_Debuff.Loop_TojiG_Debuff()
        call TojiSpells_G.Loop_TojiG()
    endfunction

    private function InitTojiSpells takes nothing returns nothing
        local trigger trgPoint = CreateTrigger()
        local trigger trgOrder = CreateTrigger()
        local trigger trgTarget = CreateTrigger()

        set TojiTimer03 = CreateTimer()
        set TojiTimer03Callback = function TojiTimer03Loop
        set TojiTimer05 = CreateTimer()
        set TojiTimer05Callback = function TojiTimer05Loop

        call TriggerRegisterAnyUnitEventBJ(trgPoint, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
        call TriggerAddCondition(trgPoint, Condition(function Toji_TrackPointOrder))

        call TriggerRegisterAnyUnitEventBJ(trgOrder, EVENT_PLAYER_UNIT_ISSUED_ORDER)
        call TriggerAddCondition(trgOrder, Condition(function Toji_TrackStopOrder))

        call TriggerRegisterAnyUnitEventBJ(trgTarget, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
        call TriggerAddCondition(trgTarget, Condition(function Toji_TrackTargetOrder))

        set trgPoint = null
        set trgOrder = null
        set trgTarget = null
    endfunction

    function TojiQ_Start takes unit c, unit td returns nothing
        call TojiSpells_Q.TojiQ_Start(c, td, 1)
    endfunction
    function TojiQ2_Start takes unit c, unit td returns nothing
        call TojiSpells_Q.TojiQ_Start(c, td, 2)
    endfunction
    function TojiQ3_Start takes unit c, unit td returns nothing
        call TojiSpells_Q.TojiQ_Start(c, td, 3)
    endfunction
    function TojiW_Start takes unit c, real x, real y returns nothing
        call TojiSpells_W.TojiW_Start(c, x, y)
    endfunction
    function TojiW2_Start takes unit c, real x, real y returns nothing
        call TojiSpells_W.TojiW2_Start(c, x, y)
    endfunction
    function TojiE_Start takes unit c, real x, real y returns nothing
        call TojiSpells_E.TojiE_Start(c, x, y)
    endfunction
    function TojiE_InitCharges takes unit c returns nothing
        call TojiSpells_E.InitCharges(c)
    endfunction
    function TojiR_Start takes unit c, real x, real y returns nothing
        call TojiSpells_R_Insectoids.TojiR_Start(c, x, y)
    endfunction
    function TojiT_Start takes unit c, real x, real y returns nothing
        call TojiSpells_T.TojiT_Start(c, x, y)
    endfunction
    function TojiG_Start takes unit c, unit td returns nothing
        call TojiSpells_G.TojiG_Start(c, td)
    endfunction
    function TojiF_Start takes unit c returns nothing
        call TojiSpells_F.TojiF_Start(c)
    endfunction
endlibrary